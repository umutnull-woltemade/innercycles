// ════════════════════════════════════════════════════════════════════════════
// YEAR REVIEW SERVICE - InnerCycles Annual Summary
// ════════════════════════════════════════════════════════════════════════════
// Analyzes all journal entries for a given year and generates a
// comprehensive annual review. Caches results in SharedPreferences.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import 'journal_service.dart';

// ══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════

/// Monthly breakdown of journal data for one month
class MonthlyBreakdown {
  final int month;
  final int entryCount;
  final double averageMood;
  final FocusArea? topFocusArea;

  const MonthlyBreakdown({
    required this.month,
    required this.entryCount,
    required this.averageMood,
    this.topFocusArea,
  });

  Map<String, dynamic> toJson() => {
        'month': month,
        'entryCount': entryCount,
        'averageMood': averageMood,
        'topFocusArea': topFocusArea?.name,
      };

  factory MonthlyBreakdown.fromJson(Map<String, dynamic> json) =>
      MonthlyBreakdown(
        month: json['month'] as int,
        entryCount: json['entryCount'] as int,
        averageMood: (json['averageMood'] as num).toDouble(),
        topFocusArea: json['topFocusArea'] != null
            ? FocusArea.values.firstWhere(
                (e) => e.name == json['topFocusArea'],
                orElse: () => FocusArea.energy,
              )
            : null,
      );
}

/// Complete year-in-review data model
class YearReview {
  final int year;
  final int totalEntries;
  final double averageMood;
  final FocusArea topFocusArea;
  final List<double> moodJourney; // 12 monthly averages (0.0 if no data)
  final List<String> topPatterns;
  final int streakBest;
  final int totalJournalingDays;
  final int growthScore; // 0-100
  final List<MonthlyBreakdown> monthlyBreakdown;
  final Map<FocusArea, int> focusAreaCounts;

  const YearReview({
    required this.year,
    required this.totalEntries,
    required this.averageMood,
    required this.topFocusArea,
    required this.moodJourney,
    required this.topPatterns,
    required this.streakBest,
    required this.totalJournalingDays,
    required this.growthScore,
    required this.monthlyBreakdown,
    required this.focusAreaCounts,
  });

  Map<String, dynamic> toJson() => {
        'year': year,
        'totalEntries': totalEntries,
        'averageMood': averageMood,
        'topFocusArea': topFocusArea.name,
        'moodJourney': moodJourney,
        'topPatterns': topPatterns,
        'streakBest': streakBest,
        'totalJournalingDays': totalJournalingDays,
        'growthScore': growthScore,
        'monthlyBreakdown':
            monthlyBreakdown.map((m) => m.toJson()).toList(),
        'focusAreaCounts': focusAreaCounts.map(
          (k, v) => MapEntry(k.name, v),
        ),
      };

  factory YearReview.fromJson(Map<String, dynamic> json) {
    final focusCounts = <FocusArea, int>{};
    if (json['focusAreaCounts'] != null) {
      final raw = json['focusAreaCounts'] as Map;
      for (final entry in raw.entries) {
        final area = FocusArea.values.firstWhere(
          (e) => e.name == entry.key.toString(),
          orElse: () => FocusArea.energy,
        );
        focusCounts[area] = (entry.value as num).toInt();
      }
    }

    return YearReview(
      year: json['year'] as int,
      totalEntries: json['totalEntries'] as int,
      averageMood: (json['averageMood'] as num).toDouble(),
      topFocusArea: FocusArea.values.firstWhere(
        (e) => e.name == json['topFocusArea'],
        orElse: () => FocusArea.energy,
      ),
      moodJourney: (json['moodJourney'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      topPatterns:
          (json['topPatterns'] as List).map((e) => e as String).toList(),
      streakBest: json['streakBest'] as int,
      totalJournalingDays: json['totalJournalingDays'] as int,
      growthScore: json['growthScore'] as int,
      monthlyBreakdown: (json['monthlyBreakdown'] as List)
          .map((m) => MonthlyBreakdown.fromJson(m as Map<String, dynamic>))
          .toList(),
      focusAreaCounts: focusCounts,
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// SERVICE
// ══════════════════════════════════════════════════════════════════════════

class YearReviewService {
  static const String _cacheKeyPrefix = 'year_review_';
  static const int _minimumEntries = 7;

  final SharedPreferences _prefs;
  final JournalService _journalService;

  YearReviewService._(this._prefs, this._journalService);

  /// Factory initialization following InnerCycles service pattern
  static Future<YearReviewService> init(
      JournalService journalService) async {
    final prefs = await SharedPreferences.getInstance();
    return YearReviewService._(prefs, journalService);
  }

  // ════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ════════════════════════════════════════════════════════════════════════

  /// Generate a year-in-review for the given year.
  /// Returns null if there are fewer than 7 entries that year.
  Future<YearReview?> generateReview(int year) async {
    // Check cache first
    final cached = _loadFromCache(year);
    if (cached != null) return cached;

    // Gather entries for this year
    final entries = _getEntriesForYear(year);
    if (entries.length < _minimumEntries) return null;

    // Build the review
    final review = _buildReview(year, entries);

    // Cache result
    await _saveToCache(review);

    return review;
  }

  /// Returns a list of years that have at least 7 entries
  Future<List<int>> getAvailableYears() async {
    final allEntries = _journalService.getAllEntries();
    final yearCounts = <int, int>{};

    for (final entry in allEntries) {
      yearCounts[entry.date.year] =
          (yearCounts[entry.date.year] ?? 0) + 1;
    }

    final available = yearCounts.entries
        .where((e) => e.value >= _minimumEntries)
        .map((e) => e.key)
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Most recent first

    return available;
  }

  /// Clear cached review for a year (e.g. when new entries are added)
  Future<void> invalidateCache(int year) async {
    await _prefs.remove('$_cacheKeyPrefix$year');
  }

  // ════════════════════════════════════════════════════════════════════════
  // ANALYSIS ENGINE
  // ════════════════════════════════════════════════════════════════════════

  List<JournalEntry> _getEntriesForYear(int year) {
    return _journalService.getEntriesByDateRange(
      DateTime(year, 1, 1),
      DateTime(year, 12, 31),
    );
  }

  YearReview _buildReview(int year, List<JournalEntry> entries) {
    // --- Basic stats ---
    final totalEntries = entries.length;
    final averageMood =
        entries.map((e) => e.overallRating).reduce((a, b) => a + b) /
            totalEntries;

    // --- Unique journaling days ---
    final uniqueDays = entries.map((e) => e.dateKey).toSet();
    final totalJournalingDays = uniqueDays.length;

    // --- Focus area breakdown ---
    final focusCounts = <FocusArea, int>{};
    for (final entry in entries) {
      focusCounts[entry.focusArea] =
          (focusCounts[entry.focusArea] ?? 0) + 1;
    }
    final topFocusArea = focusCounts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    // --- Monthly mood journey (12 months) ---
    final moodJourney = List<double>.filled(12, 0.0);
    final monthlyBreakdown = <MonthlyBreakdown>[];

    for (int month = 1; month <= 12; month++) {
      final monthEntries =
          entries.where((e) => e.date.month == month).toList();
      if (monthEntries.isEmpty) {
        monthlyBreakdown.add(MonthlyBreakdown(
          month: month,
          entryCount: 0,
          averageMood: 0.0,
        ));
        continue;
      }

      final monthAvg =
          monthEntries.map((e) => e.overallRating).reduce((a, b) => a + b) /
              monthEntries.length;
      moodJourney[month - 1] = monthAvg;

      // Top focus area for this month
      final monthFocusCounts = <FocusArea, int>{};
      for (final e in monthEntries) {
        monthFocusCounts[e.focusArea] =
            (monthFocusCounts[e.focusArea] ?? 0) + 1;
      }
      final monthTopFocus = monthFocusCounts.entries
          .reduce((a, b) => a.value >= b.value ? a : b)
          .key;

      monthlyBreakdown.add(MonthlyBreakdown(
        month: month,
        entryCount: monthEntries.length,
        averageMood: monthAvg,
        topFocusArea: monthTopFocus,
      ));
    }

    // --- Best streak within the year ---
    final streakBest = _calculateBestStreakForYear(uniqueDays, year);

    // --- Growth score (0-100) based on mood improvement trend ---
    final growthScore = _calculateGrowthScore(moodJourney);

    // --- Top patterns / insights ---
    final topPatterns = _detectPatterns(
      entries,
      focusCounts,
      moodJourney,
      averageMood,
      streakBest,
    );

    return YearReview(
      year: year,
      totalEntries: totalEntries,
      averageMood: averageMood,
      topFocusArea: topFocusArea,
      moodJourney: moodJourney,
      topPatterns: topPatterns,
      streakBest: streakBest,
      totalJournalingDays: totalJournalingDays,
      growthScore: growthScore,
      monthlyBreakdown: monthlyBreakdown,
      focusAreaCounts: focusCounts,
    );
  }

  int _calculateBestStreakForYear(Set<String> uniqueDays, int year) {
    if (uniqueDays.isEmpty) return 0;

    final sorted = uniqueDays.toList()..sort();
    int best = 1;
    int current = 1;

    for (int i = 1; i < sorted.length; i++) {
      final prev = DateTime.parse(sorted[i - 1]);
      final curr = DateTime.parse(sorted[i]);
      if (curr.difference(prev).inDays == 1) {
        current++;
        best = max(best, current);
      } else {
        current = 1;
      }
    }

    return best;
  }

  /// Growth score: compare first-half average to second-half average.
  /// Score 50 = flat, >50 = improvement, <50 = decline.
  /// Clamped to 0-100.
  int _calculateGrowthScore(List<double> moodJourney) {
    // Only consider months with data
    final withData = <_MonthMood>[];
    for (int i = 0; i < moodJourney.length; i++) {
      if (moodJourney[i] > 0) {
        withData.add(_MonthMood(month: i + 1, avg: moodJourney[i]));
      }
    }

    if (withData.length < 2) return 50; // Not enough data for trend

    final half = withData.length ~/ 2;
    final firstHalf = withData.sublist(0, half);
    final secondHalf = withData.sublist(half);

    final firstAvg =
        firstHalf.map((m) => m.avg).reduce((a, b) => a + b) /
            firstHalf.length;
    final secondAvg =
        secondHalf.map((m) => m.avg).reduce((a, b) => a + b) /
            secondHalf.length;

    // Difference scaled: +1.0 full improvement maps to score ~85
    // -1.0 full decline maps to score ~15
    final diff = secondAvg - firstAvg;
    final raw = 50 + (diff * 35).round();
    return raw.clamp(0, 100);
  }

  /// Detect notable patterns and generate insight strings
  List<String> _detectPatterns(
    List<JournalEntry> entries,
    Map<FocusArea, int> focusCounts,
    List<double> moodJourney,
    double averageMood,
    int bestStreak,
  ) {
    final patterns = <String>[];

    // 1. Top focus area emphasis
    final topArea =
        focusCounts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final pct =
        ((topArea.value / entries.length) * 100).round();
    patterns.add(
      'focus_dominant:${topArea.key.name}:$pct',
    );

    // 2. Best month
    double bestMonthAvg = 0;
    int bestMonth = 0;
    for (int i = 0; i < moodJourney.length; i++) {
      if (moodJourney[i] > bestMonthAvg) {
        bestMonthAvg = moodJourney[i];
        bestMonth = i + 1;
      }
    }
    if (bestMonth > 0) {
      patterns.add('best_month:$bestMonth:${bestMonthAvg.toStringAsFixed(1)}');
    }

    // 3. Consistency achievement
    if (bestStreak >= 30) {
      patterns.add('streak_30plus:$bestStreak');
    } else if (bestStreak >= 14) {
      patterns.add('streak_14plus:$bestStreak');
    } else if (bestStreak >= 7) {
      patterns.add('streak_7plus:$bestStreak');
    }

    // 4. High-mood trend
    if (averageMood >= 4.0) {
      patterns.add('high_average:${averageMood.toStringAsFixed(1)}');
    }

    // 5. Variety - did user explore multiple focus areas?
    final areasUsed = focusCounts.entries.where((e) => e.value > 0).length;
    if (areasUsed >= 4) {
      patterns.add('diverse_explorer:$areasUsed');
    }

    // 6. Volume achievement
    if (entries.length >= 365) {
      patterns.add('daily_journaler');
    } else if (entries.length >= 200) {
      patterns.add('dedicated_journaler:${entries.length}');
    } else if (entries.length >= 100) {
      patterns.add('committed_journaler:${entries.length}');
    }

    return patterns;
  }

  // ════════════════════════════════════════════════════════════════════════
  // CACHE PERSISTENCE
  // ════════════════════════════════════════════════════════════════════════

  YearReview? _loadFromCache(int year) {
    final jsonString = _prefs.getString('$_cacheKeyPrefix$year');
    if (jsonString == null) return null;
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return YearReview.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(YearReview review) async {
    final jsonString = jsonEncode(review.toJson());
    await _prefs.setString(
      '$_cacheKeyPrefix${review.year}',
      jsonString,
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// INTERNAL HELPERS
// ══════════════════════════════════════════════════════════════════════════

class _MonthMood {
  final int month;
  final double avg;
  const _MonthMood({required this.month, required this.avg});
}
