// ════════════════════════════════════════════════════════════════════════════
// PATTERN ENGINE - InnerCycles Trend Analysis
// ════════════════════════════════════════════════════════════════════════════
// Analyzes journal entries to detect patterns, trends, and correlations.
// All output uses safe, non-predictive language.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';
import '../models/journal_entry.dart';
import 'journal_service.dart';

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
        return '${area.displayNameTr} alanın iyileşiyor (+${changePercent.toStringAsFixed(0)}%)';
      case TrendDirection.down:
        return '${area.displayNameTr} alanın dikkat gerektirebilir (${changePercent.toStringAsFixed(0)}%)';
      case TrendDirection.stable:
        return '${area.displayNameTr} alanın tutarlı';
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
      return '${area1.displayNameTr} yüksek olduğunda, ${area2.displayNameTr} de yüksek olma eğiliminde';
    } else if (correlation < -0.5) {
      return '${area1.displayNameTr} yüksek olduğunda, ${area2.displayNameTr} düşük olma eğiliminde';
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

  PatternEngineService(this._journalService);

  /// Minimum entries needed to unlock pattern analysis
  static const int minimumEntries = 7;

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
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

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
}
