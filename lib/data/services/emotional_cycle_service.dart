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
        return 'Yükseliş';
      case CyclePhase.peak:
        return 'Zirve';
      case CyclePhase.falling:
        return 'Düşüş';
      case CyclePhase.valley:
        return 'Dinlenme';
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════
// EMOTIONAL PHASE MODEL - 5-Phase Emotion Intelligence System
// ══════════════════════════════════════════════════════════════════════════

/// The 5 emotional phases that define the Emotion Intelligence Cycle.
/// Unlike CyclePhase (trajectory shape), EmotionalPhase describes the
/// psychological state the user is experiencing within their cycle.
enum EmotionalPhase {
  /// High energy, openness, growth — things feel expansive
  expansion,

  /// Grounding period — integrating gains, steady state
  stabilization,

  /// Pulling inward — reduced capacity, emotional narrowing
  contraction,

  /// Looking back — processing, meaning-making, understanding
  reflection,

  /// Rebuilding — restoring capacity, gentle upward movement
  recovery;

  String labelEn() {
    switch (this) {
      case EmotionalPhase.expansion:
        return 'Expansion';
      case EmotionalPhase.stabilization:
        return 'Stabilization';
      case EmotionalPhase.contraction:
        return 'Contraction';
      case EmotionalPhase.reflection:
        return 'Reflection';
      case EmotionalPhase.recovery:
        return 'Recovery';
    }
  }

  String labelTr() {
    switch (this) {
      case EmotionalPhase.expansion:
        return 'Genişleme';
      case EmotionalPhase.stabilization:
        return 'Dengelenme';
      case EmotionalPhase.contraction:
        return 'Daralma';
      case EmotionalPhase.reflection:
        return 'Yansıma';
      case EmotionalPhase.recovery:
        return 'Toparlanma';
    }
  }

  /// Safe-language description of this phase
  String descriptionEn() {
    switch (this) {
      case EmotionalPhase.expansion:
        return 'Your recent entries suggest a period of openness and growth';
      case EmotionalPhase.stabilization:
        return 'Your patterns indicate a grounding period of integration';
      case EmotionalPhase.contraction:
        return 'Your data suggests a natural inward turn — this is part of the cycle';
      case EmotionalPhase.reflection:
        return 'Your entries show a reflective period of processing and understanding';
      case EmotionalPhase.recovery:
        return 'Your patterns suggest capacity is gently rebuilding';
    }
  }

  String descriptionTr() {
    switch (this) {
      case EmotionalPhase.expansion:
        return 'Son kayıtların açıklık ve büyüme dönemi öneriyor';
      case EmotionalPhase.stabilization:
        return 'Kalıpların bütünleşme ve dengelenme dönemi gösteriyor';
      case EmotionalPhase.contraction:
        return 'Verilerin doğal bir içe dönüş öneriyor — bu döngünün bir parçası';
      case EmotionalPhase.reflection:
        return 'Kayıtların işleme ve anlama odaklı yansıtıcı bir dönem gösteriyor';
      case EmotionalPhase.recovery:
        return 'Kalıpların kapasitenin yavaşça yeniden inşa edildiğini öneriyor';
    }
  }

  /// Recommended action for this phase (safe language)
  String actionEn() {
    switch (this) {
      case EmotionalPhase.expansion:
        return 'You may find this a good time for new initiatives';
      case EmotionalPhase.stabilization:
        return 'Consider consolidating recent gains';
      case EmotionalPhase.contraction:
        return 'Gentle self-care may be especially helpful now';
      case EmotionalPhase.reflection:
        return 'Journaling about recent experiences may add clarity';
      case EmotionalPhase.recovery:
        return 'Small, manageable steps tend to work well in this phase';
    }
  }

  String actionTr() {
    switch (this) {
      case EmotionalPhase.expansion:
        return 'Yeni girişimler için iyi bir zaman olabilir';
      case EmotionalPhase.stabilization:
        return 'Son kazanımları pekiştirmeyi düşünebilirsin';
      case EmotionalPhase.contraction:
        return 'Nazik öz bakım şu anda özellikle faydalı olabilir';
      case EmotionalPhase.reflection:
        return 'Son deneyimler hakkında yazmak netlik katabilir';
      case EmotionalPhase.recovery:
        return 'Küçük, yönetilebilir adımlar bu dönemde iyi çalışma eğiliminde';
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════
// EMOTIONAL ARC MODEL - Trajectory Shape
// ══════════════════════════════════════════════════════════════════════════

/// Describes the shape of the emotional trajectory over a window.
/// Arcs are about the movement direction, while Phases describe
/// the psychological state.
enum EmotionalArc {
  rising,
  peak,
  drop,
  plateau;

  String labelEn() {
    switch (this) {
      case EmotionalArc.rising:
        return 'Rising';
      case EmotionalArc.peak:
        return 'Peak';
      case EmotionalArc.drop:
        return 'Drop';
      case EmotionalArc.plateau:
        return 'Plateau';
    }
  }

  String labelTr() {
    switch (this) {
      case EmotionalArc.rising:
        return 'Yükseliş';
      case EmotionalArc.peak:
        return 'Zirve';
      case EmotionalArc.drop:
        return 'Düşüş';
      case EmotionalArc.plateau:
        return 'Plato';
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════
// PHASE TRANSITION
// ══════════════════════════════════════════════════════════════════════════

/// Records a detected transition between emotional phases
class PhaseTransition {
  final EmotionalPhase fromPhase;
  final EmotionalPhase toPhase;
  final DateTime detectedAt;
  final double confidence; // 0.0 - 1.0

  const PhaseTransition({
    required this.fromPhase,
    required this.toPhase,
    required this.detectedAt,
    required this.confidence,
  });
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
        return 'Gelişiyor';
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
  final EmotionalPhase? emotionalPhase;
  final EmotionalArc? currentArc;
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
    this.emotionalPhase,
    this.currentArc,
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
      return '${area.displayNameTr} alanın ~$cycleLengthDays günde bir döngü eğilimi gösteriyor';
    }
    return '${area.displayNameTr} döngünü tespit etmek için henüz yeterli veri yok';
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

  /// Overall emotional phase across all dimensions
  final EmotionalPhase? overallPhase;

  /// Overall emotional arc across all dimensions
  final EmotionalArc? overallArc;

  /// Recent phase transitions detected
  final List<PhaseTransition> recentTransitions;

  const EmotionalCycleAnalysis({
    required this.areaSummaries,
    required this.insights,
    this.bestWeekday,
    required this.totalEntries,
    this.overallPhase,
    this.overallArc,
    this.recentTransitions = const [],
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

  /// Current entry count (for progress displays)
  int get entryCount => _journalService.entryCount;

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

    // Compute overall phase and arc from all dimensions
    final overallPhase = _detectOverallEmotionalPhase(summaries);
    final overallArc = _detectOverallArc(summaries);
    final transitions = _detectPhaseTransitions(allEntries);

    return EmotionalCycleAnalysis(
      areaSummaries: summaries,
      insights: insights,
      bestWeekday: bestWeekday,
      totalEntries: allEntries.length,
      overallPhase: overallPhase,
      overallArc: overallArc,
      recentTransitions: transitions,
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

    // Detect emotional phase (5-phase model)
    final emotionalPhase = _detectEmotionalPhase(rawPoints, trend);

    // Detect emotional arc (trajectory shape)
    final arc = _detectArc(rawPoints);

    return FocusAreaCycleSummary(
      area: area,
      cycleLengthDays: cycleLength,
      currentPhase: phase,
      emotionalPhase: emotionalPhase,
      currentArc: arc,
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
            '${strongest.displayNameTr} son zamanlarda en güçlü boyutun olma eğiliminde',
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
                  '${areas[i].displayNameTr} ve ${areas[j].displayNameTr} verilerinde birlikte hareket etme eğiliminde',
              relatedArea: areas[i],
              secondaryArea: areas[j],
            ));
          } else if (corr < -0.5) {
            insights.add(CycleInsight(
              messageEn:
                  'When your ${areas[i].displayNameEn} is high, your ${areas[j].displayNameEn} tends to be lower',
              messageTr:
                  '${areas[i].displayNameTr} yüksek olduğunda, ${areas[j].displayNameTr} düşük olma eğiliminde',
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
        '', 'Pazartesi', 'Salı', 'Çarşamba',
        'Perşembe', 'Cuma', 'Cumartesi', 'Pazar',
      ];
      insights.add(CycleInsight(
        messageEn:
            'Your ratings tend to be higher on ${dayNamesEn[bestDay]}',
        messageTr:
            'Puanlarının ${dayNamesTr[bestDay]} günleri daha yüksek olma eğiliminde',
      ));
    }

    // 4. Cycle length insights for areas with detected cycles
    for (final summary in summaries.values) {
      if (summary.cycleLengthDays != null) {
        insights.add(CycleInsight(
          messageEn:
              'Your ${summary.area.displayNameEn} patterns suggest a ~${summary.cycleLengthDays}-day cycle',
          messageTr:
              '${summary.area.displayNameTr} kalıpların ~${summary.cycleLengthDays} günlük bir döngü öneriyor',
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
              '${summary.area.displayNameTr} alanın kademeli olarak iyileşiyor gibi görünüyor',
          relatedArea: summary.area,
        ));
      } else if (summary.trend == CycleTrend.declining &&
          summary.rawPoints.length >= 4) {
        insights.add(CycleInsight(
          messageEn:
              'Your ${summary.area.displayNameEn} may need some attention recently',
          messageTr:
              '${summary.area.displayNameTr} alanın son zamanlarda biraz ilgi gerektirebilir',
          relatedArea: summary.area,
        ));
      }
    }

    return insights;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // EMOTIONAL PHASE DETECTION (5-Phase Model)
  // ══════════════════════════════════════════════════════════════════════════

  /// Detect the emotional phase from raw data points and trend.
  /// Maps the trajectory shape + value level to a psychological state.
  EmotionalPhase? _detectEmotionalPhase(
    List<CycleDataPoint> points,
    CycleTrend trend,
  ) {
    if (points.length < 3) return null;

    final recent5 = points.length >= 5
        ? points.sublist(points.length - 5)
        : points;
    final recentAvg =
        recent5.fold<double>(0, (s, p) => s + p.value) / recent5.length;
    final latestValue = points.last.value;

    // Calculate velocity (rate of change over last 3 points)
    final last3 = points.sublist(points.length - 3);
    final velocity = (last3.last.value - last3.first.value) / 2;

    // Calculate variability (standard deviation of recent values)
    final meanRecent = recentAvg;
    final variance = recent5.fold<double>(
            0, (s, p) => s + (p.value - meanRecent) * (p.value - meanRecent)) /
        recent5.length;
    final stdDev = math.sqrt(variance);

    // Phase detection logic based on value level, velocity, and stability
    //
    // Expansion: High values + rising or high velocity
    if (recentAvg >= 3.5 && velocity > 0.2) return EmotionalPhase.expansion;
    if (latestValue >= 4.0 && velocity >= 0) return EmotionalPhase.expansion;

    // Stabilization: Moderate-high values + low variability + stable
    if (recentAvg >= 3.0 && stdDev < 0.5 && velocity.abs() < 0.3) {
      return EmotionalPhase.stabilization;
    }

    // Contraction: Falling values or low values
    if (velocity < -0.3 && recentAvg < 3.5) return EmotionalPhase.contraction;
    if (latestValue <= 2.0) return EmotionalPhase.contraction;

    // Reflection: Low variability at moderate levels, slight downward or flat
    if (recentAvg >= 2.5 && recentAvg <= 3.5 && stdDev < 0.6 &&
        velocity >= -0.2 && velocity <= 0.1) {
      return EmotionalPhase.reflection;
    }

    // Recovery: Rising from low values
    if (velocity > 0.1 && recentAvg < 3.5 && trend == CycleTrend.improving) {
      return EmotionalPhase.recovery;
    }
    if (latestValue > recent5.first.value && recentAvg < 3.0) {
      return EmotionalPhase.recovery;
    }

    // Fallback: use trend to infer
    switch (trend) {
      case CycleTrend.improving:
        return recentAvg >= 3.5
            ? EmotionalPhase.expansion
            : EmotionalPhase.recovery;
      case CycleTrend.declining:
        return EmotionalPhase.contraction;
      case CycleTrend.stable:
        return recentAvg >= 3.0
            ? EmotionalPhase.stabilization
            : EmotionalPhase.reflection;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // EMOTIONAL ARC DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Detect the trajectory arc shape from recent data points.
  EmotionalArc? _detectArc(List<CycleDataPoint> points) {
    if (points.length < 3) return null;

    final last5 = points.length >= 5
        ? points.sublist(points.length - 5)
        : points;

    final first = last5.first.value;
    final last = last5.last.value;
    final mid = last5[last5.length ~/ 2].value;
    final maxVal = last5.fold<double>(0, (m, p) => math.max(m, p.value));
    final minVal = last5.fold<double>(5, (m, p) => math.min(m, p.value));

    // Rising: consistently increasing
    if (last > first + 0.3 && last >= mid) return EmotionalArc.rising;

    // Peak: high middle, lower ends
    if (mid >= first && mid >= last && maxVal >= 3.5 && (maxVal - minVal) > 0.5) {
      return EmotionalArc.peak;
    }

    // Drop: consistently decreasing
    if (last < first - 0.3 && last <= mid) return EmotionalArc.drop;

    // Plateau: low variance
    return EmotionalArc.plateau;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // OVERALL PHASE & ARC (across all dimensions)
  // ══════════════════════════════════════════════════════════════════════════

  /// Compute the overall emotional phase by voting across dimensions
  EmotionalPhase? _detectOverallEmotionalPhase(
    Map<FocusArea, FocusAreaCycleSummary> summaries,
  ) {
    final votes = <EmotionalPhase, int>{};
    for (final summary in summaries.values) {
      if (summary.emotionalPhase != null) {
        votes[summary.emotionalPhase!] =
            (votes[summary.emotionalPhase!] ?? 0) + 1;
      }
    }
    if (votes.isEmpty) return null;

    // Return the phase with the most votes
    final sorted = votes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  /// Compute the overall arc by voting across dimensions
  EmotionalArc? _detectOverallArc(
    Map<FocusArea, FocusAreaCycleSummary> summaries,
  ) {
    final votes = <EmotionalArc, int>{};
    for (final summary in summaries.values) {
      if (summary.currentArc != null) {
        votes[summary.currentArc!] =
            (votes[summary.currentArc!] ?? 0) + 1;
      }
    }
    if (votes.isEmpty) return null;

    final sorted = votes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PHASE TRANSITION DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Detect phase transitions by comparing phase at different time windows
  List<PhaseTransition> _detectPhaseTransitions(
    List<JournalEntry> allEntries,
  ) {
    if (allEntries.length < 10) return [];

    final sorted = List.of(allEntries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Split into two halves and detect phase for each
    final mid = sorted.length ~/ 2;
    final olderHalf = sorted.sublist(0, mid);
    final newerHalf = sorted.sublist(mid);

    final olderPoints = _entriesToAggregatePoints(olderHalf);
    final newerPoints = _entriesToAggregatePoints(newerHalf);

    final olderTrend = _detectTrend(olderPoints);
    final newerTrend = _detectTrend(newerPoints);

    final olderPhase = _detectEmotionalPhase(olderPoints, olderTrend);
    final newerPhase = _detectEmotionalPhase(newerPoints, newerTrend);

    if (olderPhase != null && newerPhase != null && olderPhase != newerPhase) {
      // Calculate confidence based on data density
      final daySpan = sorted.last.date.difference(sorted.first.date).inDays;
      final density = sorted.length / math.max(daySpan, 1);
      final confidence = (density * 2).clamp(0.3, 0.95);

      return [
        PhaseTransition(
          fromPhase: olderPhase,
          toPhase: newerPhase,
          detectedAt: newerHalf.first.date,
          confidence: confidence,
        ),
      ];
    }

    return [];
  }

  /// Aggregate entries into daily average data points
  List<CycleDataPoint> _entriesToAggregatePoints(List<JournalEntry> entries) {
    final byDate = <String, List<int>>{};
    for (final e in entries) {
      byDate.putIfAbsent(e.dateKey, () => []).add(e.overallRating);
    }

    final points = <CycleDataPoint>[];
    for (final entry in byDate.entries) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      points.add(CycleDataPoint(
        date: DateTime.tryParse('${entry.key}T00:00:00') ?? DateTime.now(),
        value: avg,
      ));
    }
    points.sort((a, b) => a.date.compareTo(b.date));
    return points;
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
