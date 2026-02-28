// ════════════════════════════════════════════════════════════════════════════
// MONTHLY WRAPPED SERVICE - Aylık Özet Engine
// ════════════════════════════════════════════════════════════════════════════
// Follows WeeklyDigestService pattern. Uses JournalService + PatternEngine
// to generate a monthly summary for the shareable Wrapped screen.
// ════════════════════════════════════════════════════════════════════════════

import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import '../services/pattern_engine_service.dart';

class MonthlyWrappedData {
  final int totalEntries;
  final double avgRating;
  final FocusArea? dominantArea;
  final int streakPeak;
  final String bestDayOfWeek;
  final String personalInsightEn;
  final String personalInsightTr;
  final List<double> dailyRatings;
  final int year;
  final int month;

  const MonthlyWrappedData({
    required this.totalEntries,
    required this.avgRating,
    this.dominantArea,
    required this.streakPeak,
    required this.bestDayOfWeek,
    required this.personalInsightEn,
    required this.personalInsightTr,
    required this.dailyRatings,
    required this.year,
    required this.month,
  });

  String personalInsight(bool isEn) =>
      isEn ? personalInsightEn : personalInsightTr;
}

class MonthlyWrappedService {
  final JournalService journalService;
  final PatternEngineService patternEngine;

  MonthlyWrappedService({
    required this.journalService,
    required this.patternEngine,
  });

  bool hasDataForMonth(int year, int month) {
    final entries = journalService.getEntriesForMonth(year, month);
    return entries.length >= 3;
  }

  MonthlyWrappedData? generateWrapped(int year, int month) {
    final entries = journalService.getEntriesForMonth(year, month);
    if (entries.length < 3) return null;

    // Average rating
    final totalRating = entries.fold<double>(
      0,
      (sum, e) => sum + e.overallRating,
    );
    final avgRating = totalRating / entries.length;

    // Dominant focus area
    final areaCounts = <FocusArea, int>{};
    for (final entry in entries) {
      areaCounts[entry.focusArea] = (areaCounts[entry.focusArea] ?? 0) + 1;
    }
    FocusArea? dominantArea;
    int maxCount = 0;
    for (final entry in areaCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        dominantArea = entry.key;
      }
    }

    // Best day of week
    final dayRatings = <int, List<double>>{};
    for (final entry in entries) {
      dayRatings
          .putIfAbsent(entry.date.weekday, () => [])
          .add(entry.overallRating.toDouble());
    }
    int bestDay = 1;
    double bestAvg = 0;
    for (final e in dayRatings.entries) {
      final avg = e.value.reduce((a, b) => a + b) / e.value.length;
      if (avg > bestAvg) {
        bestAvg = avg;
        bestDay = e.key;
      }
    }
    final bestDayOfWeek = _dayName(bestDay);

    // Streak peak (consecutive days in the month)
    final sortedDates = entries.map((e) => e.dateKey).toSet().toList()..sort();
    int streakPeak = 1;
    int currentStreak = 1;
    for (int i = 1; i < sortedDates.length; i++) {
      final prev = DateTime.parse(sortedDates[i - 1]);
      final curr = DateTime.parse(sortedDates[i]);
      if (curr.difference(prev).inDays == 1) {
        currentStreak++;
        if (currentStreak > streakPeak) streakPeak = currentStreak;
      } else {
        currentStreak = 1;
      }
    }

    // Daily ratings sparkline (average per day)
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final dailyRatings = List<double>.filled(daysInMonth, 0);
    final dayCounts = List<int>.filled(daysInMonth, 0);
    for (final entry in entries) {
      final day = entry.date.day - 1;
      dailyRatings[day] += entry.overallRating;
      dayCounts[day]++;
    }
    for (int i = 0; i < daysInMonth; i++) {
      if (dayCounts[i] > 0) {
        dailyRatings[i] = dailyRatings[i] / dayCounts[i];
      }
    }

    // Personal insight
    final personalInsightEn = _generateInsightEn(
      entries.length,
      avgRating,
      dominantArea,
      bestDayOfWeek,
    );
    final personalInsightTr = _generateInsightTr(
      entries.length,
      avgRating,
      dominantArea,
      bestDayOfWeek,
    );

    return MonthlyWrappedData(
      totalEntries: entries.length,
      avgRating: avgRating,
      dominantArea: dominantArea,
      streakPeak: streakPeak,
      bestDayOfWeek: bestDayOfWeek,
      personalInsightEn: personalInsightEn,
      personalInsightTr: personalInsightTr,
      dailyRatings: dailyRatings,
      year: year,
      month: month,
    );
  }

  String _dayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[(weekday - 1).clamp(0, 6)];
  }

  String _generateInsightEn(
    int count,
    double avg,
    FocusArea? area,
    String bestDay,
  ) {
    if (avg >= 4.0) {
      return 'This was a strong month for you. Your entries suggest a period of clarity and momentum.';
    }
    if (avg >= 3.0) {
      return 'A balanced month. Your patterns suggest steady awareness with room to explore deeper.';
    }
    return 'A month of navigating challenges. Your entries suggest resilience through the tough spots.';
  }

  String _generateInsightTr(
    int count,
    double avg,
    FocusArea? area,
    String bestDay,
  ) {
    if (avg >= 4.0) {
      return 'Bu ay senin için güçlü geçti. Kayıtların berraklık ve ivme dönemi öneriyor.';
    }
    if (avg >= 3.0) {
      return 'Dengeli bir ay. Örüntülerin istikrarlı bir farkındalık ve daha derine inme fırsatı gösteriyor.';
    }
    return 'Zorluklarla başa çıktığın bir ay. Kayıtların zor anlarda dayanıklılık gösterdiğini öneriyor.';
  }
}
