// ════════════════════════════════════════════════════════════════════════════
// DREAM-JOURNAL CORRELATION SERVICE - InnerCycles Cross-Analysis
// ════════════════════════════════════════════════════════════════════════════
// Correlates dream themes/symbols/emotions with journal mood entries to
// surface unique insights. Matches each dream to journal entries recorded
// on the same day (mood-before context) and the following day (mood-after
// effect) to reveal how dream content relates to waking-life emotional
// states. All output uses safe, non-predictive language.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'dream_journal_service.dart';
import 'journal_service.dart';
import 'l10n_service.dart';
import '../providers/app_providers.dart';

// ════════════════════════════════════════════════════════════════════════════
// DATA MODEL
// ════════════════════════════════════════════════════════════════════════════

/// Direction a correlation moves between before/after mood observations.
enum CorrelationDirection {
  moodRises,
  moodDrops,
  moodStable;

  String labelEn() {
    switch (this) {
      case CorrelationDirection.moodRises:
        return 'mood tends to rise';
      case CorrelationDirection.moodDrops:
        return 'mood tends to dip';
      case CorrelationDirection.moodStable:
        return 'mood stays steady';
    }
  }

  String labelTr() {
    switch (this) {
      case CorrelationDirection.moodRises:
        return 'ruh halin yükselme eğiliminde';
      case CorrelationDirection.moodDrops:
        return 'ruh halin düşme eğiliminde';
      case CorrelationDirection.moodStable:
        return 'ruh halin sabit kalıyor';
    }
  }
}

/// A single correlation between a dream theme and journal mood.
class DreamMoodCorrelation {
  /// The dream theme, symbol, or emotion label this correlation describes.
  final String theme;

  /// Average journal mood rating on the day the dream was recorded
  /// (represents mood context *before* the dream's symbolic processing).
  final double avgMoodBefore;

  /// Average journal mood rating on the day *after* the dream.
  final double avgMoodAfter;

  /// Number of dream-journal pairs that contributed to this correlation.
  final int sampleSize;

  /// Whether mood rose, dropped, or stayed stable after the dream.
  final CorrelationDirection direction;

  /// Absolute mood delta (avgMoodAfter - avgMoodBefore).
  double get delta => avgMoodAfter - avgMoodBefore;

  /// Strength of the correlation on a 0-1 scale (higher = stronger signal).
  /// Computed as |delta| / 4 (max possible swing on a 1-5 scale), clamped.
  double get strength => (delta.abs() / 4.0).clamp(0.0, 1.0);

  const DreamMoodCorrelation({
    required this.theme,
    required this.avgMoodBefore,
    required this.avgMoodAfter,
    required this.sampleSize,
    required this.direction,
  });

  Map<String, dynamic> toJson() => {
    'theme': theme,
    'avgMoodBefore': avgMoodBefore,
    'avgMoodAfter': avgMoodAfter,
    'sampleSize': sampleSize,
    'direction': direction.name,
  };

  factory DreamMoodCorrelation.fromJson(Map<String, dynamic> json) {
    return DreamMoodCorrelation(
      theme: json['theme'] as String? ?? '',
      avgMoodBefore: (json['avgMoodBefore'] as num?)?.toDouble() ?? 0,
      avgMoodAfter: (json['avgMoodAfter'] as num?)?.toDouble() ?? 0,
      sampleSize: json['sampleSize'] as int? ?? 0,
      direction: CorrelationDirection.values.firstWhere(
        (e) => e.name == json['direction'],
        orElse: () => CorrelationDirection.moodStable,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SERVICE
// ════════════════════════════════════════════════════════════════════════════

class DreamJournalCorrelationService {
  final DreamJournalService _dreamService;
  final JournalService _journalService;

  /// Minimum dream-journal pairs required for a theme to surface.
  static const int _minSampleSize = 2;

  /// Minimum |delta| (on a 1-5 scale) to be considered non-stable.
  static const double _stableThreshold = 0.25;

  DreamJournalCorrelationService._(this._dreamService, this._journalService);

  /// Factory initializer following project convention.
  static Future<DreamJournalCorrelationService> init({
    DreamJournalService? dreamService,
    JournalService? journalService,
  }) async {
    final ds = dreamService ?? await DreamJournalService.init();
    final js = journalService ?? await JournalService.init();
    return DreamJournalCorrelationService._(ds, js);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CORE ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  /// Analyze correlations between dream themes and journal mood ratings.
  ///
  /// For every dream entry, we look up:
  ///   - Journal entries on the *same day* (mood-before / context mood)
  ///   - Journal entries on the *next day* (mood-after / effect mood)
  ///
  /// Themes are derived from detected symbols, user tags, dominant emotion
  /// label, and boolean flags (lucid, nightmare, recurring).
  ///
  /// Returns all correlations with sampleSize >= [_minSampleSize], sorted by
  /// absolute delta descending (strongest signal first).
  Future<List<DreamMoodCorrelation>> analyzeDreamMoodCorrelations() async {
    final dreams = await _dreamService.getAllDreams();
    final journalEntries = _journalService.getAllEntries();

    if (dreams.isEmpty || journalEntries.isEmpty) return [];

    // Build a lookup of average journal mood by date key.
    // A single day can have multiple journal entries across different focus
    // areas; we average all overallRatings for that day.
    final moodSumByDate = <String, double>{};
    final moodCountByDate = <String, int>{};
    for (final entry in journalEntries) {
      moodSumByDate[entry.dateKey] =
          (moodSumByDate[entry.dateKey] ?? 0) + entry.overallRating;
      moodCountByDate[entry.dateKey] =
          (moodCountByDate[entry.dateKey] ?? 0) + 1;
    }

    final moodByDate = <String, double>{};
    for (final key in moodSumByDate.keys) {
      final count = moodCountByDate[key] ?? 1;
      moodByDate[key] = count > 0 ? moodSumByDate[key]! / count : 3.0;
    }

    // Collect (theme -> list of {moodBefore, moodAfter}) pairs.
    final themeData = <String, List<_MoodPair>>{};

    for (final dream in dreams) {
      final dreamDateKey = _dateToKey(dream.dreamDate);
      final nextDay = dream.dreamDate.add(const Duration(days: 1));
      final nextDayKey = _dateToKey(nextDay);

      final moodBefore = moodByDate[dreamDateKey];
      final moodAfter = moodByDate[nextDayKey];

      // We need at least one of the two to form a useful pair; but for
      // delta-based correlation we need both.
      if (moodBefore == null || moodAfter == null) continue;

      final pair = _MoodPair(moodBefore, moodAfter);

      // Extract themes from this dream
      final themes = _extractThemes(dream);
      for (final theme in themes) {
        themeData.putIfAbsent(theme, () => []).add(pair);
      }
    }

    // Build correlations for themes that meet the minimum sample size.
    final correlations = <DreamMoodCorrelation>[];
    for (final entry in themeData.entries) {
      if (entry.value.length < _minSampleSize) continue;

      final pairs = entry.value;
      final avgBefore =
          pairs.map((p) => p.before).reduce((a, b) => a + b) / pairs.length;
      final avgAfter =
          pairs.map((p) => p.after).reduce((a, b) => a + b) / pairs.length;
      final delta = avgAfter - avgBefore;

      CorrelationDirection direction;
      if (delta > _stableThreshold) {
        direction = CorrelationDirection.moodRises;
      } else if (delta < -_stableThreshold) {
        direction = CorrelationDirection.moodDrops;
      } else {
        direction = CorrelationDirection.moodStable;
      }

      correlations.add(
        DreamMoodCorrelation(
          theme: entry.key,
          avgMoodBefore: _round2(avgBefore),
          avgMoodAfter: _round2(avgAfter),
          sampleSize: pairs.length,
          direction: direction,
        ),
      );
    }

    // Sort strongest signal first.
    correlations.sort((a, b) => b.delta.abs().compareTo(a.delta.abs()));

    return correlations;
  }

  /// Return the top [count] strongest correlations.
  Future<List<DreamMoodCorrelation>> getTopCorrelations(int count) async {
    final all = await analyzeDreamMoodCorrelations();
    return all.take(min(count, all.length)).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // INSIGHT GENERATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Generate a human-readable insight string summarizing the strongest
  /// dream-mood correlations. Uses safe language ("Your entries suggest...")
  /// and respects [isEn] for English/Turkish output.
  Future<String> generateInsight({required bool isEn}) async {
    final lang = isEn ? AppLanguage.en : AppLanguage.tr;
    final correlations = await getTopCorrelations(3);

    if (correlations.isEmpty) {
      return L10nService.get('dream_correlation.not_enough_data', lang);
    }

    final buffer = StringBuffer();
    buffer.writeln(L10nService.get('dream_correlation.connections_header', lang));

    for (final c in correlations) {
      final deltaStr = c.delta.abs().toStringAsFixed(1);
      final direction = isEn ? c.direction.labelEn() : c.direction.labelTr();
      buffer.writeln(
        L10nService.getWithParams('dream_correlation.connection_item', lang, params: {
          'theme': c.theme,
          'direction': direction,
          'before': c.avgMoodBefore.toStringAsFixed(1),
          'after': c.avgMoodAfter.toStringAsFixed(1),
          'samples': '${c.sampleSize}',
          'delta': deltaStr,
        }),
      );
    }

    buffer.write(L10nService.get('dream_correlation.patterns_note', lang));

    return buffer.toString().trim();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  /// Extract a set of theme strings from a single dream entry.
  /// Combines detected symbols, user tags, dominant emotion label,
  /// and notable boolean flags.
  List<String> _extractThemes(DreamEntry dream) {
    final themes = <String>{};

    // Detected symbols
    for (final symbol in dream.detectedSymbols) {
      if (symbol.trim().isNotEmpty) {
        themes.add(symbol.trim().toLowerCase());
      }
    }

    // User tags
    for (final tag in dream.userTags) {
      if (tag.trim().isNotEmpty) {
        themes.add(tag.trim().toLowerCase());
      }
    }

    // Dominant emotion as a theme
    themes.add(dream.dominantEmotion.label.toLowerCase());

    // Boolean flags as synthetic themes
    if (dream.isLucid) themes.add('lucid');
    if (dream.isNightmare) themes.add('nightmare');
    if (dream.isRecurring) themes.add('recurring');

    return themes.toList();
  }

  /// Convert DateTime to yyyy-MM-dd key (matching JournalEntry.dateKey).
  String _dateToKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Round to 2 decimal places.
  double _round2(double value) => (value * 100).roundToDouble() / 100;
}

// ══════════════════════════════════════════════════════════════════════════
// INTERNAL HELPER
// ══════════════════════════════════════════════════════════════════════════

class _MoodPair {
  final double before;
  final double after;
  const _MoodPair(this.before, this.after);
}
