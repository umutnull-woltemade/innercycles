// ════════════════════════════════════════════════════════════════════════════
// PATTERN ENGINE - InnerCycles Trend Analysis
// ════════════════════════════════════════════════════════════════════════════
// Analyzes journal entries to detect patterns, trends, and correlations.
// Cross-dimension analysis: sleep, gratitude, rituals, mood, wellness, streak.
// All output uses safe, non-predictive language.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';
import '../models/journal_entry.dart';
import '../models/cross_correlation_result.dart';
import 'journal_service.dart';
import 'sleep_service.dart';
import 'gratitude_service.dart';
import 'ritual_service.dart';
import 'wellness_score_service.dart';
import 'mood_checkin_service.dart';
import 'streak_service.dart';

// ══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════

enum TrendDirection { up, down, stable }

class TrendInsight {
  final FocusArea area;
  final TrendDirection direction;
  final double changePercent;

  const TrendInsight({
    required this.area,
    required this.direction,
    required this.changePercent,
  });

  String getMessageEn() {
    switch (direction) {
      case TrendDirection.up:
        return 'Your ${area.displayNameEn} has been improving (+${changePercent.toStringAsFixed(0)}%)';
      case TrendDirection.down:
        return 'Your ${area.displayNameEn} may need attention (${changePercent.toStringAsFixed(0)}%)';
      case TrendDirection.stable:
        return 'Your ${area.displayNameEn} has been consistent';
    }
  }

  String getMessageTr() {
    switch (direction) {
      case TrendDirection.up:
        return '${area.displayNameTr} alanin iyilesiyor (+${changePercent.toStringAsFixed(0)}%)';
      case TrendDirection.down:
        return '${area.displayNameTr} alanin dikkat gerektirebilir (${changePercent.toStringAsFixed(0)}%)';
      case TrendDirection.stable:
        return '${area.displayNameTr} alanin tutarli';
    }
  }
}

class CorrelationInsight {
  final FocusArea area1;
  final FocusArea area2;
  final double correlation; // -1.0 to 1.0

  const CorrelationInsight({
    required this.area1,
    required this.area2,
    required this.correlation,
  });

  String getMessageEn() {
    if (correlation > 0.5) {
      return 'When your ${area1.displayNameEn} is high, your ${area2.displayNameEn} tends to be higher too';
    } else if (correlation < -0.5) {
      return 'When your ${area1.displayNameEn} is high, your ${area2.displayNameEn} tends to be lower';
    }
    return '';
  }

  String getMessageTr() {
    if (correlation > 0.5) {
      return '${area1.displayNameTr} yuksek oldugunda, ${area2.displayNameTr} de yuksek olma egiliminde';
    } else if (correlation < -0.5) {
      return '${area1.displayNameTr} yuksek oldugunda, ${area2.displayNameTr} dusuk olma egiliminde';
    }
    return '';
  }
}

class MonthlySummary {
  final int year;
  final int month;
  final int totalEntries;
  final Map<FocusArea, double> averagesByArea;
  final FocusArea? strongestArea;
  final FocusArea? weakestArea;
  final int currentStreak;

  const MonthlySummary({
    required this.year,
    required this.month,
    required this.totalEntries,
    required this.averagesByArea,
    this.strongestArea,
    this.weakestArea,
    required this.currentStreak,
  });
}

// ══════════════════════════════════════════════════════════════════════════
// PATTERN ENGINE SERVICE
// ══════════════════════════════════════════════════════════════════════════

class PatternEngineService {
  final JournalService _journalService;
  final SleepService? _sleepService;
  final GratitudeService? _gratitudeService;
  final RitualService? _ritualService;
  final WellnessScoreService? _wellnessScoreService;
  final MoodCheckinService? _moodCheckinService;
  final StreakService? _streakService;

  PatternEngineService(
    this._journalService, {
    SleepService? sleepService,
    GratitudeService? gratitudeService,
    RitualService? ritualService,
    WellnessScoreService? wellnessScoreService,
    MoodCheckinService? moodCheckinService,
    StreakService? streakService,
  })  : _sleepService = sleepService,
        _gratitudeService = gratitudeService,
        _ritualService = ritualService,
        _wellnessScoreService = wellnessScoreService,
        _moodCheckinService = moodCheckinService,
        _streakService = streakService;

  /// Minimum entries needed to unlock pattern analysis
  static const int minimumEntries = 7;

  /// Minimum sample size for cross-correlation significance
  static const int _minCrossCorrelationSamples = 7;

  /// Minimum |coefficient| for significance
  static const double _minSignificantCoefficient = 0.3;

  /// Check if user has enough data
  bool hasEnoughData() => _journalService.entryCount >= minimumEntries;

  /// How many more entries needed
  int entriesNeeded() =>
      max(0, minimumEntries - _journalService.entryCount);

  /// Weekly averages by focus area
  Map<FocusArea, double> getWeeklyAverages() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final entries = _journalService.getEntriesByDateRange(weekAgo, now);

    final result = <FocusArea, double>{};
    for (final area in FocusArea.values) {
      final areaEntries = entries.where((e) => e.focusArea == area).toList();
      if (areaEntries.isNotEmpty) {
        final sum = areaEntries.fold<int>(
          0,
          (s, e) => s + e.overallRating,
        );
        result[area] = sum / areaEntries.length;
      }
    }
    return result;
  }

  /// Last week's averages for comparison
  Map<FocusArea, double> getLastWeekAverages() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final entries = _journalService.getEntriesByDateRange(twoWeeksAgo, weekAgo);

    final result = <FocusArea, double>{};
    for (final area in FocusArea.values) {
      final areaEntries = entries.where((e) => e.focusArea == area).toList();
      if (areaEntries.isNotEmpty) {
        final sum = areaEntries.fold<int>(
          0,
          (s, e) => s + e.overallRating,
        );
        result[area] = sum / areaEntries.length;
      }
    }
    return result;
  }

  /// Detect trends across focus areas
  List<TrendInsight> detectTrends() {
    if (!hasEnoughData()) return [];

    final thisWeek = getWeeklyAverages();
    final lastWeek = getLastWeekAverages();
    final trends = <TrendInsight>[];

    for (final area in FocusArea.values) {
      final current = thisWeek[area];
      final previous = lastWeek[area];

      if (current != null && previous != null && previous > 0) {
        final change = ((current - previous) / previous) * 100;
        TrendDirection direction;
        if (change > 10) {
          direction = TrendDirection.up;
        } else if (change < -10) {
          direction = TrendDirection.down;
        } else {
          direction = TrendDirection.stable;
        }
        trends.add(TrendInsight(
          area: area,
          direction: direction,
          changePercent: change,
        ));
      } else if (current != null) {
        trends.add(TrendInsight(
          area: area,
          direction: TrendDirection.stable,
          changePercent: 0,
        ));
      }
    }

    return trends;
  }

  /// Find correlations between focus areas
  List<CorrelationInsight> detectCorrelations() {
    if (!hasEnoughData()) return [];

    final entries = _journalService.getAllEntries();
    final insights = <CorrelationInsight>[];

    // Group entries by date
    final byDate = <String, Map<FocusArea, int>>{};
    for (final e in entries) {
      byDate.putIfAbsent(e.dateKey, () => {});
      byDate[e.dateKey]![e.focusArea] = e.overallRating;
    }

    // Check pairs of focus areas
    final areas = FocusArea.values;
    for (int i = 0; i < areas.length; i++) {
      for (int j = i + 1; j < areas.length; j++) {
        final pairs = <List<int>>[];
        for (final dayData in byDate.values) {
          if (dayData.containsKey(areas[i]) &&
              dayData.containsKey(areas[j])) {
            pairs.add([dayData[areas[i]]!, dayData[areas[j]]!]);
          }
        }
        if (pairs.length >= 3) {
          final corr = _pearsonCorrelation(pairs);
          if (corr.abs() > 0.5) {
            insights.add(CorrelationInsight(
              area1: areas[i],
              area2: areas[j],
              correlation: corr,
            ));
          }
        }
      }
    }

    return insights;
  }

  /// Day-of-week analysis
  Map<int, double> getDayOfWeekAverages() {
    final entries = _journalService.getAllEntries();
    final sums = <int, int>{};
    final counts = <int, int>{};

    for (final e in entries) {
      final day = e.date.weekday;
      sums[day] = (sums[day] ?? 0) + e.overallRating;
      counts[day] = (counts[day] ?? 0) + 1;
    }

    return sums.map((day, sum) => MapEntry(day, sum / counts[day]!));
  }

  /// Monthly summary
  MonthlySummary getMonthSummary(int year, int month) {
    final entries = _journalService.getEntriesForMonth(year, month);

    final averages = <FocusArea, double>{};
    for (final area in FocusArea.values) {
      final areaEntries = entries.where((e) => e.focusArea == area).toList();
      if (areaEntries.isNotEmpty) {
        final sum = areaEntries.fold<int>(0, (s, e) => s + e.overallRating);
        averages[area] = sum / areaEntries.length;
      }
    }

    FocusArea? strongest;
    FocusArea? weakest;
    double maxAvg = 0;
    double minAvg = 6;
    for (final entry in averages.entries) {
      if (entry.value > maxAvg) {
        maxAvg = entry.value;
        strongest = entry.key;
      }
      if (entry.value < minAvg) {
        minAvg = entry.value;
        weakest = entry.key;
      }
    }

    return MonthlySummary(
      year: year,
      month: month,
      totalEntries: entries.length,
      averagesByArea: averages,
      strongestArea: strongest,
      weakestArea: weakest,
      currentStreak: _journalService.getCurrentStreak(),
    );
  }

  /// Overall averages across all entries
  Map<FocusArea, double> getOverallAverages() {
    final entries = _journalService.getAllEntries();
    final result = <FocusArea, double>{};

    for (final area in FocusArea.values) {
      final areaEntries = entries.where((e) => e.focusArea == area).toList();
      if (areaEntries.isNotEmpty) {
        final sum = areaEntries.fold<int>(0, (s, e) => s + e.overallRating);
        result[area] = sum / areaEntries.length;
      }
    }
    return result;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CROSS-DIMENSION CORRELATIONS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get all significant cross-correlations between data dimensions.
  /// Returns only correlations with sufficient sample size (>=7)
  /// and meaningful coefficient (|r| >= 0.3).
  List<CrossCorrelation> getCrossCorrelations() {
    final results = <CrossCorrelation>[];

    // 1. Sleep quality vs. next-day mood rating
    final sleepMood = _correlateSleepVsNextDayMood();
    if (sleepMood != null) results.add(sleepMood);

    // 2. Sleep quality vs. next-day energy rating
    final sleepEnergy = _correlateSleepVsNextDayEnergy();
    if (sleepEnergy != null) results.add(sleepEnergy);

    // 3. Gratitude entry count vs. weekly mood average
    final gratitudeMood = _correlateGratitudeVsWeeklyMood();
    if (gratitudeMood != null) results.add(gratitudeMood);

    // 4. Ritual completion rate vs. focus area scores
    final ritualFocus = _correlateRitualVsFocusScores();
    if (ritualFocus != null) results.add(ritualFocus);

    // 5. Wellness score trend vs. journaling frequency
    final wellnessJournal = _correlateWellnessVsJournalFrequency();
    if (wellnessJournal != null) results.add(wellnessJournal);

    // 6. Streak length vs. average mood
    final streakMood = _correlateStreakVsMood();
    if (streakMood != null) results.add(streakMood);

    // 7. Sleep quality vs. next-day stress (emotions sub-rating)
    final sleepStress = _correlateSleepVsNextDayStress();
    if (sleepStress != null) results.add(sleepStress);

    return results;
  }

  /// Sleep quality vs. next-day mood (from mood check-ins)
  CrossCorrelation? _correlateSleepVsNextDayMood() {
    final sleep = _sleepService;
    final mood = _moodCheckinService;
    if (sleep == null || mood == null) return null;

    final sleepEntries = sleep.getAllEntries();
    final moodEntries = mood.getAllEntries();
    if (sleepEntries.isEmpty || moodEntries.isEmpty) return null;

    // Build mood lookup by date key
    final moodByDate = <String, int>{};
    for (final m in moodEntries) {
      final key = _dateToKey(m.date);
      moodByDate[key] = m.mood;
    }

    // Pair each sleep entry with next day's mood
    final pairs = <List<double>>[];
    for (final s in sleepEntries) {
      // Sleep dateKey is the morning date; mood for that same day is "next-day" effect
      final nextDayMood = moodByDate[s.dateKey];
      if (nextDayMood != null) {
        pairs.add([s.quality.toDouble(), nextDayMood.toDouble()]);
      }
    }

    return _buildCrossCorrelation(
      pairs: pairs,
      dimensionA: 'Sleep Quality',
      dimensionB: 'Mood',
      insightTemplateEn: 'Your entries suggest that sleep quality and mood are {direction} (r={r})',
      insightTemplateTr: 'Kayitlarin uyku kalitesi ile ruh halinin {direction} oldugunu gosteriyor (r={r})',
    );
  }

  /// Sleep quality vs. next-day energy (from journal energy ratings)
  CrossCorrelation? _correlateSleepVsNextDayEnergy() {
    final sleep = _sleepService;
    if (sleep == null) return null;

    final sleepEntries = sleep.getAllEntries();
    final journalEntries = _journalService.getAllEntries();
    if (sleepEntries.isEmpty || journalEntries.isEmpty) return null;

    // Build energy rating lookup by date key (only energy focus area entries)
    final energyByDate = <String, int>{};
    for (final j in journalEntries) {
      if (j.focusArea == FocusArea.energy) {
        energyByDate[j.dateKey] = j.overallRating;
      }
    }

    // Pair sleep with same-day energy (sleep is logged in the morning, energy during the day)
    final pairs = <List<double>>[];
    for (final s in sleepEntries) {
      final dayEnergy = energyByDate[s.dateKey];
      if (dayEnergy != null) {
        pairs.add([s.quality.toDouble(), dayEnergy.toDouble()]);
      }
    }

    return _buildCrossCorrelation(
      pairs: pairs,
      dimensionA: 'Sleep Quality',
      dimensionB: 'Energy',
      insightTemplateEn: 'Your entries suggest that sleep quality and next-day energy are {direction} (r={r})',
      insightTemplateTr: 'Kayitlarin uyku kalitesi ile ertesi gun enerjinin {direction} oldugunu gosteriyor (r={r})',
    );
  }

  /// Gratitude entry count vs. weekly mood average
  /// Groups data into weekly buckets, compares gratitude count to mood average
  CrossCorrelation? _correlateGratitudeVsWeeklyMood() {
    final gratitude = _gratitudeService;
    final mood = _moodCheckinService;
    if (gratitude == null || mood == null) return null;

    final gratitudeEntries = gratitude.getAllEntries();
    final moodEntries = mood.getAllEntries();
    if (gratitudeEntries.isEmpty || moodEntries.isEmpty) return null;

    // Group gratitude items count by week number
    final gratitudeByWeek = <String, int>{};
    for (final g in gratitudeEntries) {
      final weekKey = _weekKeyFromDateKey(g.dateKey);
      gratitudeByWeek[weekKey] = (gratitudeByWeek[weekKey] ?? 0) + g.items.length;
    }

    // Group mood average by week number
    final moodSumByWeek = <String, double>{};
    final moodCountByWeek = <String, int>{};
    for (final m in moodEntries) {
      final weekKey = _weekKeyFromDate(m.date);
      moodSumByWeek[weekKey] = (moodSumByWeek[weekKey] ?? 0) + m.mood;
      moodCountByWeek[weekKey] = (moodCountByWeek[weekKey] ?? 0) + 1;
    }

    // Build pairs for weeks that have both data
    final pairs = <List<double>>[];
    for (final weekKey in gratitudeByWeek.keys) {
      if (moodSumByWeek.containsKey(weekKey)) {
        final gratCount = gratitudeByWeek[weekKey]!.toDouble();
        final moodAvg = moodSumByWeek[weekKey]! / moodCountByWeek[weekKey]!;
        pairs.add([gratCount, moodAvg]);
      }
    }

    return _buildCrossCorrelation(
      pairs: pairs,
      dimensionA: 'Gratitude',
      dimensionB: 'Weekly Mood',
      insightTemplateEn: 'Your entries suggest that gratitude practice and weekly mood are {direction} (r={r})',
      insightTemplateTr: 'Kayitlarin minnettarlik pratigi ile haftalik ruh halinin {direction} oldugunu gosteriyor (r={r})',
    );
  }

  /// Ritual completion rate vs. overall daily journal score
  CrossCorrelation? _correlateRitualVsFocusScores() {
    final ritual = _ritualService;
    if (ritual == null) return null;

    final journalEntries = _journalService.getAllEntries();
    if (journalEntries.isEmpty) return null;

    // Build daily journal average by date
    final journalSumByDate = <String, int>{};
    final journalCountByDate = <String, int>{};
    for (final j in journalEntries) {
      journalSumByDate[j.dateKey] = (journalSumByDate[j.dateKey] ?? 0) + j.overallRating;
      journalCountByDate[j.dateKey] = (journalCountByDate[j.dateKey] ?? 0) + 1;
    }

    // Get unique dates from journal to check ritual completion
    final pairs = <List<double>>[];
    for (final dateKey in journalSumByDate.keys) {
      final date = DateTime.parse('${dateKey}T00:00:00');
      // Calculate ritual completion for this date
      final stacks = ritual.getStacks();
      if (stacks.isEmpty) continue;

      int totalItems = 0;
      int completedItems = 0;
      for (final stack in stacks) {
        final comp = ritual.getCompletion(stack.id, date: date);
        totalItems += stack.items.length;
        completedItems += comp?.completedItemIds.length ?? 0;
      }
      if (totalItems == 0) continue;

      final completionRate = completedItems / totalItems;
      final journalAvg = journalSumByDate[dateKey]! / journalCountByDate[dateKey]!;
      // Normalize journal avg to 0-1 scale (ratings are 1-5)
      final normalizedJournal = (journalAvg - 1) / 4;
      pairs.add([completionRate, normalizedJournal]);
    }

    return _buildCrossCorrelation(
      pairs: pairs,
      dimensionA: 'Ritual Completion',
      dimensionB: 'Journal Scores',
      insightTemplateEn: 'Your entries suggest that ritual completion and journal ratings are {direction} (r={r})',
      insightTemplateTr: 'Kayitlarin rituel tamamlama ile gunluk puanlarinin {direction} oldugunu gosteriyor (r={r})',
    );
  }

  /// Wellness score vs. journaling frequency (weekly buckets)
  CrossCorrelation? _correlateWellnessVsJournalFrequency() {
    final wellness = _wellnessScoreService;
    if (wellness == null) return null;

    final monthlyScores = wellness.getMonthlyScores();
    if (monthlyScores.isEmpty) return null;

    final journalEntries = _journalService.getAllEntries();
    if (journalEntries.isEmpty) return null;

    // Group wellness scores by week
    final wellnessByWeek = <String, List<int>>{};
    for (final score in monthlyScores) {
      final weekKey = _weekKeyFromDateKey(score.dateKey);
      wellnessByWeek.putIfAbsent(weekKey, () => []).add(score.score);
    }

    // Group journal entry count by week
    final journalCountByWeek = <String, int>{};
    for (final j in journalEntries) {
      final weekKey = _weekKeyFromDateKey(j.dateKey);
      journalCountByWeek[weekKey] = (journalCountByWeek[weekKey] ?? 0) + 1;
    }

    // Build pairs
    final pairs = <List<double>>[];
    for (final weekKey in wellnessByWeek.keys) {
      if (journalCountByWeek.containsKey(weekKey)) {
        final avgWellness = wellnessByWeek[weekKey]!.reduce((a, b) => a + b) /
            wellnessByWeek[weekKey]!.length;
        final journalFreq = journalCountByWeek[weekKey]!.toDouble();
        pairs.add([avgWellness, journalFreq]);
      }
    }

    return _buildCrossCorrelation(
      pairs: pairs,
      dimensionA: 'Wellness Score',
      dimensionB: 'Journal Frequency',
      insightTemplateEn: 'Your entries suggest that wellness score and journaling frequency are {direction} (r={r})',
      insightTemplateTr: 'Kayitlarin saglik puani ile gunluk yazma sikliginin {direction} oldugunu gosteriyor (r={r})',
    );
  }

  /// Streak length vs. average mood
  /// Uses rolling windows: for each mood entry, calculates the streak at that point
  CrossCorrelation? _correlateStreakVsMood() {
    final mood = _moodCheckinService;
    final streak = _streakService;
    if (mood == null || streak == null) return null;

    final moodEntries = mood.getAllEntries();
    if (moodEntries.isEmpty) return null;

    final currentStreak = streak.getCurrentStreak();
    if (currentStreak == 0) return null;

    // Simple approach: group mood by weekly buckets, estimate streak length
    // at each week based on journal entry density
    final journalEntries = _journalService.getAllEntries();
    if (journalEntries.isEmpty) return null;

    // Build journal dates set for streak calculation
    final journalDates = journalEntries.map((e) => e.dateKey).toSet();

    // Group mood by week, also count consecutive journal days ending in that week
    final moodByWeek = <String, List<int>>{};
    for (final m in moodEntries) {
      final weekKey = _weekKeyFromDate(m.date);
      moodByWeek.putIfAbsent(weekKey, () => []).add(m.mood);
    }

    // For each week, estimate streak length (consecutive days up to end of week)
    final streakByWeek = <String, int>{};
    final sortedDates = journalDates.toList()..sort();
    for (final dateStr in sortedDates) {
      final weekKey = _weekKeyFromDateKey(dateStr);
      // Count backward streak from this date
      int s = 0;
      DateTime checkDate = DateTime.parse('${dateStr}T00:00:00');
      for (int i = 0; i < 90; i++) {
        final key = _dateToKey(checkDate);
        if (journalDates.contains(key)) {
          s++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
      // Keep the max streak seen in this week
      final existing = streakByWeek[weekKey] ?? 0;
      if (s > existing) streakByWeek[weekKey] = s;
    }

    // Build pairs
    final pairs = <List<double>>[];
    for (final weekKey in moodByWeek.keys) {
      if (streakByWeek.containsKey(weekKey)) {
        final avgMood = moodByWeek[weekKey]!.reduce((a, b) => a + b) /
            moodByWeek[weekKey]!.length;
        final streakLen = streakByWeek[weekKey]!.toDouble();
        pairs.add([streakLen, avgMood]);
      }
    }

    return _buildCrossCorrelation(
      pairs: pairs,
      dimensionA: 'Streak Length',
      dimensionB: 'Mood',
      insightTemplateEn: 'Your entries suggest that journaling consistency and mood are {direction} (r={r})',
      insightTemplateTr: 'Kayitlarin gunluk tutarliligi ile ruh halinin {direction} oldugunu gosteriyor (r={r})',
    );
  }

  /// Sleep quality vs. next-day stress (emotions sub-rating "stress")
  CrossCorrelation? _correlateSleepVsNextDayStress() {
    final sleep = _sleepService;
    if (sleep == null) return null;

    final sleepEntries = sleep.getAllEntries();
    final journalEntries = _journalService.getAllEntries();
    if (sleepEntries.isEmpty || journalEntries.isEmpty) return null;

    // Build stress rating lookup (from emotions focus area, stress sub-rating)
    final stressByDate = <String, int>{};
    for (final j in journalEntries) {
      if (j.focusArea == FocusArea.emotions && j.subRatings.containsKey('stress')) {
        stressByDate[j.dateKey] = j.subRatings['stress']!;
      }
    }

    // Pair sleep with same-day stress
    final pairs = <List<double>>[];
    for (final s in sleepEntries) {
      final dayStress = stressByDate[s.dateKey];
      if (dayStress != null) {
        // Higher sleep quality should correlate with lower stress (negative expected)
        pairs.add([s.quality.toDouble(), dayStress.toDouble()]);
      }
    }

    return _buildCrossCorrelation(
      pairs: pairs,
      dimensionA: 'Sleep Quality',
      dimensionB: 'Stress Level',
      insightTemplateEn: 'Your entries suggest that sleep quality and stress levels are {direction} (r={r})',
      insightTemplateTr: 'Kayitlarin uyku kalitesi ile stres seviyesinin {direction} oldugunu gosteriyor (r={r})',
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  /// Build a CrossCorrelation from paired data, or null if insufficient data
  CrossCorrelation? _buildCrossCorrelation({
    required List<List<double>> pairs,
    required String dimensionA,
    required String dimensionB,
    required String insightTemplateEn,
    required String insightTemplateTr,
  }) {
    if (pairs.length < _minCrossCorrelationSamples) return null;

    final r = _pearsonCorrelationDouble(pairs);
    final isSignificant = pairs.length >= _minCrossCorrelationSamples &&
        r.abs() >= _minSignificantCoefficient;

    if (!isSignificant) return null;

    final dirEn = r > 0 ? 'positively correlated' : 'negatively correlated';
    final dirTr = r > 0 ? 'pozitif iliskili' : 'negatif iliskili';
    final rStr = r.toStringAsFixed(2);

    final insightEn = insightTemplateEn
        .replaceAll('{direction}', dirEn)
        .replaceAll('{r}', rStr);
    final insightTr = insightTemplateTr
        .replaceAll('{direction}', dirTr)
        .replaceAll('{r}', rStr);

    return CrossCorrelation(
      dimensionA: dimensionA,
      dimensionB: dimensionB,
      coefficient: r,
      sampleSize: pairs.length,
      insightTextEn: insightEn,
      insightTextTr: insightTr,
      isSignificant: isSignificant,
    );
  }

  double _pearsonCorrelation(List<List<int>> pairs) {
    if (pairs.length < 2) return 0;

    final n = pairs.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;

    for (final p in pairs) {
      sumX += p[0];
      sumY += p[1];
      sumXY += p[0] * p[1];
      sumX2 += p[0] * p[0];
      sumY2 += p[1] * p[1];
    }

    final numerator = n * sumXY - sumX * sumY;
    final denominator =
        sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));

    if (denominator == 0) return 0;
    return numerator / denominator;
  }

  /// Pearson correlation for double-valued pairs
  double _pearsonCorrelationDouble(List<List<double>> pairs) {
    if (pairs.length < 2) return 0;

    final n = pairs.length.toDouble();
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;

    for (final p in pairs) {
      sumX += p[0];
      sumY += p[1];
      sumXY += p[0] * p[1];
      sumX2 += p[0] * p[0];
      sumY2 += p[1] * p[1];
    }

    final numerator = n * sumXY - sumX * sumY;
    final denominator =
        sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));

    if (denominator == 0) return 0;
    return (numerator / denominator).clamp(-1.0, 1.0);
  }

  /// Convert DateTime to yyyy-MM-dd key
  String _dateToKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Get ISO week key from a yyyy-MM-dd date key string
  String _weekKeyFromDateKey(String dateKey) {
    final date = DateTime.parse('${dateKey}T00:00:00');
    return _weekKeyFromDate(date);
  }

  /// Get ISO week key from DateTime (yyyy-Www format)
  String _weekKeyFromDate(DateTime date) {
    // Calculate ISO week number
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    final weekday = date.weekday; // 1=Mon, 7=Sun
    final weekNumber = ((dayOfYear - weekday + 10) / 7).floor();
    return '${date.year}-W${weekNumber.toString().padLeft(2, '0')}';
  }
}
