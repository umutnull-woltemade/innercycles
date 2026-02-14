// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL CYCLE SERVICE - InnerCycles Signature Feature
// ════════════════════════════════════════════════════════════════════════════
// Analyzes journal entries over time to detect emotional cycles.
// Computes rolling averages, detects cycle lengths, identifies phases,
// and generates safe-language insights.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import '../models/journal_entry.dart';
import 'journal_service.dart';

// ══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════

/// A single data point in a time series
class CycleDataPoint {
  final DateTime date;
  final double value;

  const CycleDataPoint({required this.date, required this.value});
}

/// Phase of an emotional cycle
enum CyclePhase {
  rising,
  peak,
  falling,
  valley;

  String labelEn() {
    switch (this) {
      case CyclePhase.rising:
        return 'Rising';
      case CyclePhase.peak:
        return 'Peak';
      case CyclePhase.falling:
        return 'Falling';
      case CyclePhase.valley:
        return 'Valley';
    }
  }

  String labelTr() {
    switch (this) {
      case CyclePhase.rising:
        return 'Yukselis';
      case CyclePhase.peak:
        return 'Zirve';
      case CyclePhase.falling:
        return 'Dusus';
      case CyclePhase.valley:
        return 'Dinlenme';
    }
  }
}

/// Trend direction for an area
enum CycleTrend {
  improving,
  stable,
  declining;

  String labelEn() {
    switch (this) {
      case CycleTrend.improving:
        return 'Improving';
      case CycleTrend.stable:
        return 'Stable';
      case CycleTrend.declining:
        return 'Declining';
    }
  }

  String labelTr() {
    switch (this) {
      case CycleTrend.improving:
        return 'Gelisiyor';
      case CycleTrend.stable:
        return 'Sabit';
      case CycleTrend.declining:
        return 'Geriliyor';
    }
  }
}

/// Summary of one focus area's cycle analysis
class FocusAreaCycleSummary {
  final FocusArea area;
  final int? cycleLengthDays;
  final CyclePhase? currentPhase;
  final CycleTrend trend;
  final double currentAverage;
  final List<CycleDataPoint> rollingAverage7;
  final List<CycleDataPoint> rollingAverage14;
  final List<CycleDataPoint> rollingAverage30;
  final List<CycleDataPoint> rawPoints;

  const FocusAreaCycleSummary({
    required this.area,
    this.cycleLengthDays,
    this.currentPhase,
    required this.trend,
    required this.currentAverage,
    required this.rollingAverage7,
    required this.rollingAverage14,
    required this.rollingAverage30,
    required this.rawPoints,
  });

  /// Safe-language summary of this cycle
  String getSummaryEn() {
    if (cycleLengthDays != null) {
      return 'Your ${area.displayNameEn} tends to cycle every ~$cycleLengthDays days';
    }
    return 'Not enough data to detect your ${area.displayNameEn} cycle yet';
  }

  String getSummaryTr() {
    if (cycleLengthDays != null) {
      return '${area.displayNameTr} alanin ~$cycleLengthDays gunde bir dongu egilimi gosteriyor';
    }
    return '${area.displayNameTr} dongunu tespit etmek icin henuz yeterli veri yok';
  }
}

/// A textual insight with metadata
class CycleInsight {
  final String messageEn;
  final String messageTr;
  final FocusArea? relatedArea;
  final FocusArea? secondaryArea;

  const CycleInsight({
    required this.messageEn,
    required this.messageTr,
    this.relatedArea,
    this.secondaryArea,
  });
}

/// Full emotional cycle analysis result
class EmotionalCycleAnalysis {
  final Map<FocusArea, FocusAreaCycleSummary> areaSummaries;
  final List<CycleInsight> insights;
  final int? bestWeekday;
  final int totalEntries;

  const EmotionalCycleAnalysis({
    required this.areaSummaries,
    required this.insights,
    this.bestWeekday,
    required this.totalEntries,
  });
}

// ══════════════════════════════════════════════════════════════════════════
// EMOTIONAL CYCLE SERVICE
// ══════════════════════════════════════════════════════════════════════════

class EmotionalCycleService {
  final JournalService _journalService;

  EmotionalCycleService(this._journalService);

  /// Minimum entries needed for cycle analysis
  static const int minimumEntries = 7;

  /// Whether enough data exists for analysis
  bool hasEnoughData() => _journalService.entryCount >= minimumEntries;

  /// How many more entries are needed
  int entriesNeeded() =>
      math.max(0, minimumEntries - _journalService.entryCount);

  /// Run the full emotional cycle analysis
  EmotionalCycleAnalysis analyze() {
    final allEntries = _journalService.getAllEntries();
    final summaries = <FocusArea, FocusAreaCycleSummary>{};

    for (final area in FocusArea.values) {
      summaries[area] = _analyzeArea(area, allEntries);
    }

    final insights = _generateInsights(allEntries, summaries);
    final bestWeekday = _findBestWeekday(allEntries);

    return EmotionalCycleAnalysis(
      areaSummaries: summaries,
      insights: insights,
      bestWeekday: bestWeekday,
      totalEntries: allEntries.length,
    );
  }

  /// Get raw data points for a specific area within a date range
  List<CycleDataPoint> getAreaDataPoints(
    FocusArea area,
    DateTime start,
    DateTime end,
  ) {
    final entries = _journalService.getEntriesByDateRange(start, end);
    final areaEntries = entries
        .where((e) => e.focusArea == area)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return areaEntries
        .map((e) => CycleDataPoint(
              date: e.date,
              value: e.overallRating.toDouble(),
            ))
        .toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // AREA ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  FocusAreaCycleSummary _analyzeArea(
    FocusArea area,
    List<JournalEntry> allEntries,
  ) {
    final areaEntries = allEntries
        .where((e) => e.focusArea == area)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (areaEntries.isEmpty) {
      return FocusAreaCycleSummary(
        area: area,
        trend: CycleTrend.stable,
        currentAverage: 0,
        rollingAverage7: [],
        rollingAverage14: [],
        rollingAverage30: [],
        rawPoints: [],
      );
    }

    final rawPoints = areaEntries
        .map((e) => CycleDataPoint(
              date: e.date,
              value: e.overallRating.toDouble(),
            ))
        .toList();

    // Compute rolling averages
    final rolling7 = _computeRollingAverage(rawPoints, 7);
    final rolling14 = _computeRollingAverage(rawPoints, 14);
    final rolling30 = _computeRollingAverage(rawPoints, 30);

    // Detect cycle length
    final cycleLength = _detectCycleLength(rawPoints);

    // Detect current phase
    final phase = _detectPhase(rawPoints);

    // Detect trend
    final trend = _detectTrend(rawPoints);

    // Current average (last 7 days)
    final now = DateTime.now();
    final recentEntries = areaEntries
        .where(
            (e) => e.date.isAfter(now.subtract(const Duration(days: 7))))
        .toList();
    final currentAvg = recentEntries.isEmpty
        ? rawPoints.last.value
        : recentEntries.fold<double>(
                0, (s, e) => s + e.overallRating) /
            recentEntries.length;

    return FocusAreaCycleSummary(
      area: area,
      cycleLengthDays: cycleLength,
      currentPhase: phase,
      trend: trend,
      currentAverage: currentAvg,
      rollingAverage7: rolling7,
      rollingAverage14: rolling14,
      rollingAverage30: rolling30,
      rawPoints: rawPoints,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ROLLING AVERAGES
  // ══════════════════════════════════════════════════════════════════════════

  /// Computes rolling average over a window of [windowDays] days
  List<CycleDataPoint> _computeRollingAverage(
    List<CycleDataPoint> points,
    int windowDays,
  ) {
    if (points.length < 2) return points;

    final result = <CycleDataPoint>[];
    final windowDuration = Duration(days: windowDays);

    for (int i = 0; i < points.length; i++) {
      final currentDate = points[i].date;
      final windowStart = currentDate.subtract(windowDuration);

      // Collect all points within the window
      final windowPoints = <double>[];
      for (int j = 0; j <= i; j++) {
        if (points[j].date.isAfter(windowStart) ||
            points[j].date.isAtSameMomentAs(windowStart)) {
          windowPoints.add(points[j].value);
        }
      }

      if (windowPoints.isNotEmpty) {
        final avg = windowPoints.reduce((a, b) => a + b) / windowPoints.length;
        result.add(CycleDataPoint(date: currentDate, value: avg));
      }
    }

    return result;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CYCLE LENGTH DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Detect cycle length by finding peaks (local maxima) and computing
  /// average peak-to-peak interval
  int? _detectCycleLength(List<CycleDataPoint> points) {
    if (points.length < 5) return null;

    // Find peaks (local maxima)
    final peaks = <DateTime>[];
    for (int i = 1; i < points.length - 1; i++) {
      if (points[i].value > points[i - 1].value &&
          points[i].value > points[i + 1].value) {
        peaks.add(points[i].date);
      }
    }

    // Also check if the first or last point is a peak relative to its neighbors
    if (points.length >= 2 && points.first.value > points[1].value) {
      peaks.insert(0, points.first.date);
    }
    if (points.length >= 2 &&
        points.last.value > points[points.length - 2].value) {
      peaks.add(points.last.date);
    }

    if (peaks.length < 2) return null;

    // Average distance between consecutive peaks
    double totalDays = 0;
    for (int i = 1; i < peaks.length; i++) {
      totalDays += peaks[i].difference(peaks[i - 1]).inDays;
    }
    final avgCycle = totalDays / (peaks.length - 1);

    // Only return reasonable cycle lengths (3-60 days)
    if (avgCycle < 3 || avgCycle > 60) return null;
    return avgCycle.round();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PHASE DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Identify current phase based on recent trajectory
  CyclePhase? _detectPhase(List<CycleDataPoint> points) {
    if (points.length < 3) return null;

    // Take the last 3 points
    final recent = points.sublist(points.length - 3);
    final v0 = recent[0].value; // oldest of the 3
    final v1 = recent[1].value;
    final v2 = recent[2].value; // most recent

    // Rising: consistently increasing
    if (v2 > v1 && v1 > v0) return CyclePhase.rising;

    // Peak: high and leveling off or just starting to dip
    if (v1 >= v0 && v1 >= v2 && v1 >= 4.0) return CyclePhase.peak;
    if (v2 >= 4.0 && v2 >= v1) return CyclePhase.peak;

    // Falling: consistently decreasing
    if (v2 < v1 && v1 < v0) return CyclePhase.falling;

    // Valley: low values
    if (v2 <= 2.0) return CyclePhase.valley;

    // Default based on latest direction
    if (v2 > v1) return CyclePhase.rising;
    if (v2 < v1) return CyclePhase.falling;

    return CyclePhase.peak;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TREND DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  CycleTrend _detectTrend(List<CycleDataPoint> points) {
    if (points.length < 4) return CycleTrend.stable;

    // Compare the average of first half vs second half
    final mid = points.length ~/ 2;
    final firstHalf = points.sublist(0, mid);
    final secondHalf = points.sublist(mid);

    final firstAvg =
        firstHalf.fold<double>(0, (s, p) => s + p.value) / firstHalf.length;
    final secondAvg =
        secondHalf.fold<double>(0, (s, p) => s + p.value) / secondHalf.length;

    final diff = secondAvg - firstAvg;
    if (diff > 0.3) return CycleTrend.improving;
    if (diff < -0.3) return CycleTrend.declining;
    return CycleTrend.stable;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // INSIGHT GENERATION
  // ══════════════════════════════════════════════════════════════════════════

  List<CycleInsight> _generateInsights(
    List<JournalEntry> allEntries,
    Map<FocusArea, FocusAreaCycleSummary> summaries,
  ) {
    final insights = <CycleInsight>[];
    if (allEntries.isEmpty) return insights;

    // 1. Strongest area insight
    FocusArea? strongest;
    double highestAvg = 0;
    for (final entry in summaries.entries) {
      if (entry.value.currentAverage > highestAvg &&
          entry.value.rawPoints.isNotEmpty) {
        highestAvg = entry.value.currentAverage;
        strongest = entry.key;
      }
    }
    if (strongest != null && highestAvg > 0) {
      insights.add(CycleInsight(
        messageEn:
            'Your ${strongest.displayNameEn} tends to be your strongest dimension recently',
        messageTr:
            '${strongest.displayNameTr} son zamanlarda en guclu boyutun olma egiliminde',
        relatedArea: strongest,
      ));
    }

    // 2. Correlation between areas
    final areaRatingsByDate = <String, Map<FocusArea, double>>{};
    for (final e in allEntries) {
      areaRatingsByDate.putIfAbsent(e.dateKey, () => {});
      areaRatingsByDate[e.dateKey]![e.focusArea] = e.overallRating.toDouble();
    }

    final areas = FocusArea.values;
    for (int i = 0; i < areas.length; i++) {
      for (int j = i + 1; j < areas.length; j++) {
        final pairs = <List<double>>[];
        for (final dayData in areaRatingsByDate.values) {
          if (dayData.containsKey(areas[i]) &&
              dayData.containsKey(areas[j])) {
            pairs.add([dayData[areas[i]]!, dayData[areas[j]]!]);
          }
        }
        if (pairs.length >= 3) {
          final corr = _pearsonCorrelation(pairs);
          if (corr > 0.5) {
            insights.add(CycleInsight(
              messageEn:
                  '${areas[i].displayNameEn} and ${areas[j].displayNameEn} tend to move together in your data',
              messageTr:
                  '${areas[i].displayNameTr} ve ${areas[j].displayNameTr} verilerinde birlikte hareket etme egiliminde',
              relatedArea: areas[i],
              secondaryArea: areas[j],
            ));
          } else if (corr < -0.5) {
            insights.add(CycleInsight(
              messageEn:
                  'When your ${areas[i].displayNameEn} is high, your ${areas[j].displayNameEn} tends to be lower',
              messageTr:
                  '${areas[i].displayNameTr} yuksek oldugunda, ${areas[j].displayNameTr} dusuk olma egiliminde',
              relatedArea: areas[i],
              secondaryArea: areas[j],
            ));
          }
        }
      }
    }

    // 3. Best weekday insight
    final bestDay = _findBestWeekday(allEntries);
    if (bestDay != null) {
      final dayNamesEn = [
        '', 'Mondays', 'Tuesdays', 'Wednesdays',
        'Thursdays', 'Fridays', 'Saturdays', 'Sundays',
      ];
      final dayNamesTr = [
        '', 'Pazartesi', 'Sali', 'Carsamba',
        'Persembe', 'Cuma', 'Cumartesi', 'Pazar',
      ];
      insights.add(CycleInsight(
        messageEn:
            'Your ratings tend to be higher on ${dayNamesEn[bestDay]}',
        messageTr:
            'Puanlarinin ${dayNamesTr[bestDay]} gunleri daha yuksek olma egiliminde',
      ));
    }

    // 4. Cycle length insights for areas with detected cycles
    for (final summary in summaries.values) {
      if (summary.cycleLengthDays != null) {
        insights.add(CycleInsight(
          messageEn:
              'Your ${summary.area.displayNameEn} patterns suggest a ~${summary.cycleLengthDays}-day cycle',
          messageTr:
              '${summary.area.displayNameTr} kaliplarin ~${summary.cycleLengthDays} gunluk bir dongu oneriyor',
          relatedArea: summary.area,
        ));
      }
    }

    // 5. Improving/declining trend insights
    for (final summary in summaries.values) {
      if (summary.trend == CycleTrend.improving &&
          summary.rawPoints.length >= 4) {
        insights.add(CycleInsight(
          messageEn:
              'Your ${summary.area.displayNameEn} appears to be gradually improving',
          messageTr:
              '${summary.area.displayNameTr} alanin kademeli olarak iyilesiyor gibi gorunuyor',
          relatedArea: summary.area,
        ));
      } else if (summary.trend == CycleTrend.declining &&
          summary.rawPoints.length >= 4) {
        insights.add(CycleInsight(
          messageEn:
              'Your ${summary.area.displayNameEn} may need some attention recently',
          messageTr:
              '${summary.area.displayNameTr} alanin son zamanlarda biraz ilgi gerektirebilir',
          relatedArea: summary.area,
        ));
      }
    }

    return insights;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  int? _findBestWeekday(List<JournalEntry> entries) {
    if (entries.length < 5) return null;

    final sums = <int, double>{};
    final counts = <int, int>{};

    for (final e in entries) {
      final day = e.date.weekday;
      sums[day] = (sums[day] ?? 0) + e.overallRating;
      counts[day] = (counts[day] ?? 0) + 1;
    }

    int? bestDay;
    double bestAvg = 0;
    for (final day in sums.keys) {
      final avg = sums[day]! / counts[day]!;
      if (avg > bestAvg) {
        bestAvg = avg;
        bestDay = day;
      }
    }
    return bestDay;
  }

  double _pearsonCorrelation(List<List<double>> pairs) {
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
        math.sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));

    if (denominator == 0) return 0;
    return numerator / denominator;
  }
}
