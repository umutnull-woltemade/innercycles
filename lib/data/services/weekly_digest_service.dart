// ============================================================================
// WEEKLY DIGEST SERVICE - InnerCycles Weekly Summary
// ============================================================================
// Generates a comprehensive weekly summary of journal activity, patterns,
// mood trends, and insights. Drives D7 retention by giving users a reason
// to return every week.
//
// Uses JournalService for entry queries and PatternEngineService for trend
// analysis. Stores last digest date in SharedPreferences.
// ============================================================================

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import '../providers/app_providers.dart';
import 'journal_service.dart';
import 'pattern_engine_service.dart';

// ============================================================================
// MOOD TREND DIRECTION
// ============================================================================

enum MoodTrendDirection { up, down, stable }

// ============================================================================
// WEEKLY DIGEST DATA MODEL
// ============================================================================

class WeeklyDigestData {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int entriesThisWeek;
  final int entriesLastWeek;
  final double avgMoodRating;
  final FocusArea? topFocusArea;
  final double topFocusAreaPercentage;
  final int streakDays;
  final MoodTrendDirection moodTrend;
  final double moodTrendChangePercent;
  final DateTime? bestDay;
  final int bestDayRating;
  final String highlightInsightEn;
  final String highlightInsightTr;
  final Map<FocusArea, double> areaAverages;
  final Map<FocusArea, int> areaCounts;

  const WeeklyDigestData({
    required this.weekStart,
    required this.weekEnd,
    required this.entriesThisWeek,
    required this.entriesLastWeek,
    required this.avgMoodRating,
    required this.topFocusArea,
    required this.topFocusAreaPercentage,
    required this.streakDays,
    required this.moodTrend,
    required this.moodTrendChangePercent,
    required this.bestDay,
    required this.bestDayRating,
    required this.highlightInsightEn,
    required this.highlightInsightTr,
    required this.areaAverages,
    required this.areaCounts,
  });

  String localizedHighlightInsight(AppLanguage language) =>
      language == AppLanguage.en ? highlightInsightEn : highlightInsightTr;

  Map<String, dynamic> toJson() => {
    'weekStart': weekStart.toIso8601String(),
    'weekEnd': weekEnd.toIso8601String(),
    'entriesThisWeek': entriesThisWeek,
    'entriesLastWeek': entriesLastWeek,
    'avgMoodRating': avgMoodRating,
    'topFocusArea': topFocusArea?.name,
    'topFocusAreaPercentage': topFocusAreaPercentage,
    'streakDays': streakDays,
    'moodTrend': moodTrend.name,
    'moodTrendChangePercent': moodTrendChangePercent,
    'bestDay': bestDay?.toIso8601String(),
    'bestDayRating': bestDayRating,
    'highlightInsightEn': highlightInsightEn,
    'highlightInsightTr': highlightInsightTr,
    'areaAverages': areaAverages.map((k, v) => MapEntry(k.name, v)),
    'areaCounts': areaCounts.map((k, v) => MapEntry(k.name, v)),
  };

  factory WeeklyDigestData.fromJson(Map<String, dynamic> json) {
    return WeeklyDigestData(
      weekStart:
          DateTime.tryParse(json['weekStart']?.toString() ?? '') ??
          DateTime.now(),
      weekEnd:
          DateTime.tryParse(json['weekEnd']?.toString() ?? '') ??
          DateTime.now(),
      entriesThisWeek: json['entriesThisWeek'] as int? ?? 0,
      entriesLastWeek: json['entriesLastWeek'] as int? ?? 0,
      avgMoodRating: (json['avgMoodRating'] as num? ?? 0).toDouble(),
      topFocusArea: json['topFocusArea'] != null
          ? FocusArea.values.firstWhere(
              (e) => e.name == json['topFocusArea'],
              orElse: () => FocusArea.energy,
            )
          : null,
      topFocusAreaPercentage: (json['topFocusAreaPercentage'] as num? ?? 0)
          .toDouble(),
      streakDays: json['streakDays'] as int? ?? 0,
      moodTrend: MoodTrendDirection.values.firstWhere(
        (e) => e.name == json['moodTrend'],
        orElse: () => MoodTrendDirection.stable,
      ),
      moodTrendChangePercent: (json['moodTrendChangePercent'] as num? ?? 0)
          .toDouble(),
      bestDay: json['bestDay'] != null
          ? DateTime.tryParse(json['bestDay'].toString())
          : null,
      bestDayRating: json['bestDayRating'] as int? ?? 0,
      highlightInsightEn: json['highlightInsightEn'] as String? ?? '',
      highlightInsightTr: json['highlightInsightTr'] as String? ?? '',
      areaAverages: _parseAreaDoubleMap(json['areaAverages']),
      areaCounts: _parseAreaIntMap(json['areaCounts']),
    );
  }

  static Map<FocusArea, double> _parseAreaDoubleMap(dynamic raw) {
    if (raw is! Map) return {};
    final result = <FocusArea, double>{};
    for (final entry in raw.entries) {
      final area = FocusArea.values.firstWhere(
        (a) => a.name == entry.key.toString(),
        orElse: () => FocusArea.energy,
      );
      result[area] = (entry.value as num? ?? 0).toDouble();
    }
    return result;
  }

  static Map<FocusArea, int> _parseAreaIntMap(dynamic raw) {
    if (raw is! Map) return {};
    final result = <FocusArea, int>{};
    for (final entry in raw.entries) {
      final area = FocusArea.values.firstWhere(
        (a) => a.name == entry.key.toString(),
        orElse: () => FocusArea.energy,
      );
      result[area] = (entry.value as num? ?? 0).toInt();
    }
    return result;
  }
}

// ============================================================================
// LEGACY MODEL (backward compat for cached digests)
// ============================================================================

class WeeklyDigest {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int entryCount;
  final double avgMood;
  final String topFocusAreaEn;
  final String topFocusAreaTr;
  final String moodTrendEn;
  final String moodTrendTr;
  final String highlightEn;
  final String highlightTr;
  final String growthNudgeEn;
  final String growthNudgeTr;
  final int streakDays;
  final Map<String, double> areaAverages;

  const WeeklyDigest({
    required this.weekStart,
    required this.weekEnd,
    required this.entryCount,
    required this.avgMood,
    required this.topFocusAreaEn,
    required this.topFocusAreaTr,
    required this.moodTrendEn,
    required this.moodTrendTr,
    required this.highlightEn,
    required this.highlightTr,
    required this.growthNudgeEn,
    required this.growthNudgeTr,
    required this.streakDays,
    required this.areaAverages,
  });

  Map<String, dynamic> toJson() => {
    'weekStart': weekStart.toIso8601String(),
    'weekEnd': weekEnd.toIso8601String(),
    'entryCount': entryCount,
    'avgMood': avgMood,
    'topFocusAreaEn': topFocusAreaEn,
    'topFocusAreaTr': topFocusAreaTr,
    'moodTrendEn': moodTrendEn,
    'moodTrendTr': moodTrendTr,
    'highlightEn': highlightEn,
    'highlightTr': highlightTr,
    'growthNudgeEn': growthNudgeEn,
    'growthNudgeTr': growthNudgeTr,
    'streakDays': streakDays,
    'areaAverages': areaAverages,
  };

  factory WeeklyDigest.fromJson(Map<String, dynamic> json) => WeeklyDigest(
    weekStart:
        DateTime.tryParse(json['weekStart']?.toString() ?? '') ??
        DateTime.now(),
    weekEnd:
        DateTime.tryParse(json['weekEnd']?.toString() ?? '') ?? DateTime.now(),
    entryCount: json['entryCount'] as int? ?? 0,
    avgMood: (json['avgMood'] as num? ?? 0).toDouble(),
    topFocusAreaEn: json['topFocusAreaEn'] as String? ?? '',
    topFocusAreaTr: json['topFocusAreaTr'] as String? ?? '',
    moodTrendEn: json['moodTrendEn'] as String? ?? '',
    moodTrendTr: json['moodTrendTr'] as String? ?? '',
    highlightEn: json['highlightEn'] as String? ?? '',
    highlightTr: json['highlightTr'] as String? ?? '',
    growthNudgeEn: json['growthNudgeEn'] as String? ?? '',
    growthNudgeTr: json['growthNudgeTr'] as String? ?? '',
    streakDays: json['streakDays'] as int? ?? 0,
    areaAverages: (json['areaAverages'] as Map<String, dynamic>? ?? {}).map(
      (k, v) => MapEntry(k, (v as num? ?? 0).toDouble()),
    ),
  );
}

// ============================================================================
// WEEKLY DIGEST SERVICE
// ============================================================================

class WeeklyDigestService {
  static const String _digestKey = 'inner_cycles_weekly_digests';
  static const String _lastDigestDateKey = 'inner_cycles_last_digest_date';

  final SharedPreferences _prefs;
  final JournalService _journalService;
  List<WeeklyDigest> _legacyDigests = [];

  WeeklyDigestService._(
    this._prefs,
    this._journalService,
    PatternEngineService? _,
  ) {
    _loadLegacyDigests();
  }

  /// Initialize the weekly digest service with journal + optional pattern engine
  static Future<WeeklyDigestService> init({
    JournalService? journalService,
    PatternEngineService? patternEngine,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final journal = journalService ?? await JournalService.init();
    return WeeklyDigestService._(prefs, journal, patternEngine);
  }

  // ==========================================================================
  // CORE DIGEST GENERATION
  // ==========================================================================

  /// Generate a comprehensive digest for a specific week
  WeeklyDigestData generateDigest(DateTime weekOf) {
    // Calculate Monday-based week boundaries
    final daysSinceMonday = (weekOf.weekday - 1) % 7;
    final weekStart = DateTime(
      weekOf.year,
      weekOf.month,
      weekOf.day,
    ).subtract(Duration(days: daysSinceMonday));
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Previous week for comparison
    final prevWeekStart = weekStart.subtract(const Duration(days: 7));
    final prevWeekEnd = weekStart.subtract(const Duration(days: 1));

    // Fetch entries
    final weekEntries = _journalService.getEntriesByDateRange(
      weekStart,
      weekEnd,
    );
    final prevWeekEntries = _journalService.getEntriesByDateRange(
      prevWeekStart,
      prevWeekEnd,
    );

    final entriesThisWeek = weekEntries.length;
    final entriesLastWeek = prevWeekEntries.length;

    // Average mood rating (1-5 scale)
    double avgMoodRating = 0;
    if (weekEntries.isNotEmpty) {
      avgMoodRating =
          weekEntries
              .map((e) => e.overallRating)
              .reduce((a, b) => a + b)
              .toDouble() /
          weekEntries.length;
    }

    // Top focus area
    final areaCounts = <FocusArea, int>{};
    final areaRatingSums = <FocusArea, int>{};
    final areaRatingCounts = <FocusArea, int>{};
    for (final e in weekEntries) {
      areaCounts[e.focusArea] = (areaCounts[e.focusArea] ?? 0) + 1;
      areaRatingSums[e.focusArea] =
          (areaRatingSums[e.focusArea] ?? 0) + e.overallRating;
      areaRatingCounts[e.focusArea] = (areaRatingCounts[e.focusArea] ?? 0) + 1;
    }

    FocusArea? topArea;
    double topAreaPct = 0;
    if (areaCounts.isNotEmpty) {
      final sorted = areaCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      topArea = sorted.first.key;
      topAreaPct = (sorted.first.value / entriesThisWeek) * 100;
    }

    // Area averages
    final areaAverages = <FocusArea, double>{};
    for (final area in FocusArea.values) {
      final count = areaRatingCounts[area];
      final sum = areaRatingSums[area];
      if (count != null && count > 0 && sum != null) {
        areaAverages[area] = sum / count;
      }
    }

    // Streak
    final streakDays = _journalService.getCurrentStreak();

    // Mood trend: compare first half vs second half of week entries
    final moodTrendResult = _analyzeMoodTrend(weekEntries, prevWeekEntries);

    // Best day (highest single-day average)
    DateTime? bestDay;
    int bestDayRating = 0;
    if (weekEntries.isNotEmpty) {
      final byDate = <String, List<JournalEntry>>{};
      for (final e in weekEntries) {
        byDate.putIfAbsent(e.dateKey, () => []).add(e);
      }
      double bestAvg = 0;
      for (final dateEntries in byDate.entries) {
        final dayAvg =
            dateEntries.value
                .map((e) => e.overallRating)
                .reduce((a, b) => a + b) /
            dateEntries.value.length;
        if (dayAvg > bestAvg) {
          bestAvg = dayAvg;
          bestDay = dateEntries.value.first.date;
          bestDayRating = dayAvg.round();
        }
      }
    }

    // Generate highlight insight using safe language
    final highlight = _generateHighlightInsight(
      entriesThisWeek: entriesThisWeek,
      entriesLastWeek: entriesLastWeek,
      avgMood: avgMoodRating,
      topArea: topArea,
      moodTrend: moodTrendResult.$1,
      streakDays: streakDays,
    );

    // Persist last digest date
    _saveLastDigestDate(DateTime.now());

    return WeeklyDigestData(
      weekStart: weekStart,
      weekEnd: weekEnd,
      entriesThisWeek: entriesThisWeek,
      entriesLastWeek: entriesLastWeek,
      avgMoodRating: double.parse(avgMoodRating.toStringAsFixed(1)),
      topFocusArea: topArea,
      topFocusAreaPercentage: double.parse(topAreaPct.toStringAsFixed(0)),
      streakDays: streakDays,
      moodTrend: moodTrendResult.$1,
      moodTrendChangePercent: moodTrendResult.$2,
      bestDay: bestDay,
      bestDayRating: bestDayRating,
      highlightInsightEn: highlight.$1,
      highlightInsightTr: highlight.$2,
      areaAverages: areaAverages,
      areaCounts: areaCounts,
    );
  }

  /// Check if there is data for a given week
  bool hasDataForWeek(DateTime weekOf) {
    final daysSinceMonday = (weekOf.weekday - 1) % 7;
    final weekStart = DateTime(
      weekOf.year,
      weekOf.month,
      weekOf.day,
    ).subtract(Duration(days: daysSinceMonday));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return _journalService.getEntriesByDateRange(weekStart, weekEnd).isNotEmpty;
  }

  /// Get the date the last digest was generated
  DateTime? getLastDigestDate() {
    final stored = _prefs.getString(_lastDigestDateKey);
    if (stored == null) return null;
    return DateTime.tryParse(stored);
  }

  /// Legacy: get the most recent cached digest
  WeeklyDigest? getLastDigest() =>
      _legacyDigests.isNotEmpty ? _legacyDigests.first : null;

  /// Legacy: get all cached digests
  List<WeeklyDigest> getAllDigests() => List.unmodifiable(_legacyDigests);

  /// Legacy: generate digest from raw entry list (backward compat)
  WeeklyDigest generateLegacyDigest(List<JournalEntry> allEntries) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    final weekEndDate = weekStartDate.add(const Duration(days: 6));

    final weekEntries = allEntries.where((e) {
      return !e.date.isBefore(weekStartDate) &&
          !e.date.isAfter(weekEndDate.add(const Duration(days: 1)));
    }).toList();

    final entryCount = weekEntries.length;

    double avgMood = 0;
    if (weekEntries.isNotEmpty) {
      avgMood =
          weekEntries
              .map((e) => e.overallRating)
              .reduce((a, b) => a + b)
              .toDouble() /
          weekEntries.length;
    }

    final areaCounts = <FocusArea, int>{};
    for (final entry in weekEntries) {
      areaCounts[entry.focusArea] = (areaCounts[entry.focusArea] ?? 0) + 1;
    }
    final topArea = areaCounts.isNotEmpty
        ? (areaCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first
              .key
        : FocusArea.energy;

    final areaRatings = <String, List<int>>{};
    for (final entry in weekEntries) {
      final key = entry.focusArea.name;
      areaRatings.putIfAbsent(key, () => []);
      areaRatings[key]!.add(entry.overallRating);
    }
    final areaAverages = areaRatings.map(
      (k, v) => MapEntry(k, v.reduce((a, b) => a + b) / v.length),
    );

    final moodTrend = _legacyAnalyzeMoodTrend(weekEntries);

    final sortedAll = allEntries.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    int streakDays = 0;
    var checkDate = DateTime(now.year, now.month, now.day);
    for (int i = 0; i < 30; i++) {
      final hasEntry = sortedAll.any(
        (e) =>
            e.date.year == checkDate.year &&
            e.date.month == checkDate.month &&
            e.date.day == checkDate.day,
      );
      if (hasEntry) {
        streakDays++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    final highlight = _legacyGenerateHighlight(entryCount, avgMood, topArea);
    final nudge = _legacyGenerateGrowthNudge(entryCount, avgMood, areaCounts);

    final digest = WeeklyDigest(
      weekStart: weekStartDate,
      weekEnd: weekEndDate,
      entryCount: entryCount,
      avgMood: double.tryParse(avgMood.toStringAsFixed(1)) ?? avgMood,
      topFocusAreaEn: _areaNameEn(topArea),
      topFocusAreaTr: _areaNameTr(topArea),
      moodTrendEn: moodTrend.$1,
      moodTrendTr: moodTrend.$2,
      highlightEn: highlight.$1,
      highlightTr: highlight.$2,
      growthNudgeEn: nudge.$1,
      growthNudgeTr: nudge.$2,
      streakDays: streakDays,
      areaAverages: areaAverages,
    );

    _legacyDigests.insert(0, digest);
    if (_legacyDigests.length > 12) {
      _legacyDigests = _legacyDigests.sublist(0, 12);
    }
    unawaited(_persistLegacyDigests());

    return digest;
  }

  // ==========================================================================
  // MOOD TREND ANALYSIS
  // ==========================================================================

  (MoodTrendDirection, double) _analyzeMoodTrend(
    List<JournalEntry> thisWeek,
    List<JournalEntry> lastWeek,
  ) {
    if (thisWeek.isEmpty) return (MoodTrendDirection.stable, 0);

    final thisAvg =
        thisWeek
            .map((e) => e.overallRating)
            .reduce((a, b) => a + b)
            .toDouble() /
        thisWeek.length;

    if (lastWeek.isEmpty) return (MoodTrendDirection.stable, 0);

    final lastAvg =
        lastWeek
            .map((e) => e.overallRating)
            .reduce((a, b) => a + b)
            .toDouble() /
        lastWeek.length;

    if (lastAvg == 0) return (MoodTrendDirection.stable, 0);

    final changePercent = ((thisAvg - lastAvg) / lastAvg) * 100;

    if (changePercent > 10) {
      return (MoodTrendDirection.up, changePercent);
    } else if (changePercent < -10) {
      return (MoodTrendDirection.down, changePercent);
    }
    return (MoodTrendDirection.stable, changePercent);
  }

  // ==========================================================================
  // HIGHLIGHT INSIGHT GENERATION (safe language)
  // ==========================================================================

  (String, String) _generateHighlightInsight({
    required int entriesThisWeek,
    required int entriesLastWeek,
    required double avgMood,
    required FocusArea? topArea,
    required MoodTrendDirection moodTrend,
    required int streakDays,
  }) {
    if (entriesThisWeek == 0) {
      return (
        'Start journaling to see your weekly highlights.',
        'Haftalık özetini görmek için günlük tutmaya başla.',
      );
    }

    // Streak-based highlight
    if (streakDays >= 7) {
      return (
        'Your journaling streak has been going strong at $streakDays days. '
            'Consistency like this tends to deepen self-awareness.',
        '$streakDays günlük günlük yazma serisi devam ediyor. '
            'Bu tür tutarlılık öz-farkındalığı derinleştirme eğiliminde.',
      );
    }

    // Mood improving
    if (moodTrend == MoodTrendDirection.up && avgMood >= 3.5) {
      return (
        'Your entries suggest an upward shift in your week. '
            'Past entries show that this momentum tends to carry forward.',
        'Kayıtların bu hafta yükselişe geçtiğini gösteriyor. '
            'Geçmiş kayıtlar bu ivmenin ileriye taşıma eğiliminde olduğunu gösteriyor.',
      );
    }

    // More entries than last week
    if (entriesThisWeek > entriesLastWeek && entriesLastWeek > 0) {
      final diff = entriesThisWeek - entriesLastWeek;
      return (
        'You logged $diff more entries than last week. '
            'More data tends to reveal clearer patterns over time.',
        'Geçen haftaya göre $diff daha fazla kayıt girdin. '
            'Daha fazla veri zamanla daha net kalıplar ortaya çıkma eğiliminde.',
      );
    }

    // Top area insight
    if (topArea != null) {
      final nameEn = topArea.displayNameEn;
      final nameTr = topArea.displayNameTr;
      return (
        'You focused most on $nameEn this week. '
            'Tracking a consistent area may help you notice subtle shifts.',
        'Bu hafta en çok $nameTr alanına odaklandın. '
            'Tutarlı bir alanı takip etmek ince değişimleri fark etmene yardımcı olabilir.',
      );
    }

    return (
      'Every entry you write builds a clearer picture of your patterns.',
      'Yazdığın her kayıt kalıplarının daha net bir resmini oluşturur.',
    );
  }

  // ==========================================================================
  // PERSISTENCE
  // ==========================================================================

  void _saveLastDigestDate(DateTime date) {
    _prefs.setString(_lastDigestDateKey, date.toIso8601String());
  }

  void _loadLegacyDigests() {
    final jsonString = _prefs.getString(_digestKey);
    if (jsonString != null) {
      try {
        final list = json.decode(jsonString) as List<dynamic>;
        _legacyDigests = list
            .map((e) => WeeklyDigest.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _legacyDigests = [];
      }
    }
  }

  Future<void> _persistLegacyDigests() async {
    final jsonList = _legacyDigests.map((d) => d.toJson()).toList();
    await _prefs.setString(_digestKey, json.encode(jsonList));
  }

  // ==========================================================================
  // LEGACY HELPERS (backward compat)
  // ==========================================================================

  (String, String) _legacyAnalyzeMoodTrend(List<JournalEntry> entries) {
    if (entries.length < 2) {
      return ('Not enough entries to show a trend yet', 'Eğilim göstermek için henüz yeterli kayıt yok');
    }

    final sorted = entries.toList()..sort((a, b) => a.date.compareTo(b.date));
    final firstHalf = sorted.sublist(0, sorted.length ~/ 2);
    final secondHalf = sorted.sublist(sorted.length ~/ 2);

    final firstAvg =
        firstHalf.map((e) => e.overallRating).reduce((a, b) => a + b) /
        firstHalf.length;
    final secondAvg =
        secondHalf.map((e) => e.overallRating).reduce((a, b) => a + b) /
        secondHalf.length;

    final diff = secondAvg - firstAvg;
    if (diff > 1.0) {
      return (
        'Your mood has been rising this week',
        'Ruh halin bu hafta yükseliyor',
      );
    } else if (diff < -1.0) {
      return (
        'Your mood dipped this week — be gentle with yourself',
        'Ruh halin bu hafta biraz düştü — kendine nazik ol',
      );
    } else {
      return (
        'Your mood has been steady this week',
        'Ruh halin bu hafta sabit kalmış',
      );
    }
  }

  (String, String) _legacyGenerateHighlight(
    int entryCount,
    double avgMood,
    FocusArea topArea,
  ) {
    if (entryCount == 0) {
      return (
        'Start journaling to see your weekly highlights',
        'Haftalık özetini görmek için günlük tutmaya başla',
      );
    }
    if (entryCount >= 5) {
      return (
        'Amazing consistency! You logged $entryCount entries this week',
        'Harika tutarlılık! Bu hafta $entryCount kayıt girdin',
      );
    }
    return (
      'You focused most on ${_areaNameEn(topArea)} this week',
      'Bu hafta en çok ${_areaNameTr(topArea)} alanına odaklandın',
    );
  }

  (String, String) _legacyGenerateGrowthNudge(
    int entryCount,
    double avgMood,
    Map<FocusArea, int> areaCounts,
  ) {
    if (entryCount == 0) {
      return (
        'Try logging just one entry today — small steps matter',
        'Bugün sadece bir kayıt girmeyi dene — küçük adımlar önemli',
      );
    }

    final allAreas = FocusArea.values;
    FocusArea? leastTracked;
    int minCount = 999;
    for (final area in allAreas) {
      final count = areaCounts[area] ?? 0;
      if (count < minCount) {
        minCount = count;
        leastTracked = area;
      }
    }

    if (leastTracked != null && minCount == 0) {
      return (
        'You haven\'t explored ${_areaNameEn(leastTracked)} this week — give it a try',
        'Bu hafta ${_areaNameTr(leastTracked)} alanını keşfetmedin — bir dene',
      );
    }

    return (
      'Keep the momentum going — consistency builds insight',
      'İvmeyi sürdür — tutarlılık içgörü oluşturur',
    );
  }

  static String _areaNameEn(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return 'Energy';
      case FocusArea.focus:
        return 'Focus';
      case FocusArea.emotions:
        return 'Emotions';
      case FocusArea.decisions:
        return 'Decisions';
      case FocusArea.social:
        return 'Social';
    }
  }

  static String _areaNameTr(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return 'Enerji';
      case FocusArea.focus:
        return 'Odak';
      case FocusArea.emotions:
        return 'Duygular';
      case FocusArea.decisions:
        return 'Kararlar';
      case FocusArea.social:
        return 'Sosyal';
    }
  }
}
