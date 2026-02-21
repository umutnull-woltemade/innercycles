// ════════════════════════════════════════════════════════════════════════════
// SHIFT OUTLOOK ENGINE - Emotional Shift Window Detection
// ════════════════════════════════════════════════════════════════════════════
// Analyzes emotional cycle data to detect micro-signals and generate
// shift window suggestions. All output uses safe, non-predictive language.
//
// PREMIUM FEATURE: This service powers outlook intelligence.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import '../models/journal_entry.dart';
import 'journal_service.dart';
import 'emotional_cycle_service.dart';

// ══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════

/// Confidence level for an outlook
enum OutlookConfidence {
  low,
  moderate,
  high;

  String labelEn() {
    switch (this) {
      case OutlookConfidence.low:
        return 'Low';
      case OutlookConfidence.moderate:
        return 'Moderate';
      case OutlookConfidence.high:
        return 'High';
    }
  }

  String labelTr() {
    switch (this) {
      case OutlookConfidence.low:
        return 'Düşük';
      case OutlookConfidence.moderate:
        return 'Orta';
      case OutlookConfidence.high:
        return 'Yüksek';
    }
  }
}

/// A detected micro-signal that may indicate an upcoming shift
class MicroSignal {
  final String id;
  final FocusArea area;
  final String signalEn;
  final String signalTr;
  final double magnitude; // 0.0 - 1.0
  final DateTime detectedAt;

  const MicroSignal({
    required this.id,
    required this.area,
    required this.signalEn,
    required this.signalTr,
    required this.magnitude,
    required this.detectedAt,
  });
}

/// A shift window — a period where a phase transition may occur
class ShiftWindow {
  final EmotionalPhase currentPhase;
  final EmotionalPhase suggestedNextPhase;
  final int estimatedDaysUntilShift;
  final OutlookConfidence confidence;
  final List<MicroSignal> supportingSignals;

  /// Safe-language description
  final String descriptionEn;
  final String descriptionTr;

  /// Adaptive action recommendation
  final String actionEn;
  final String actionTr;

  const ShiftWindow({
    required this.currentPhase,
    required this.suggestedNextPhase,
    required this.estimatedDaysUntilShift,
    required this.confidence,
    required this.supportingSignals,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.actionEn,
    required this.actionTr,
  });
}

/// Full shift outlook result
class ShiftOutlook {
  final EmotionalPhase? currentPhase;
  final EmotionalArc? currentArc;
  final List<MicroSignal> activeSignals;
  final ShiftWindow? primaryShiftWindow;
  final List<ShiftWindow> alternativeWindows;
  final int dataPointsUsed;

  const ShiftOutlook({
    this.currentPhase,
    this.currentArc,
    required this.activeSignals,
    this.primaryShiftWindow,
    this.alternativeWindows = const [],
    required this.dataPointsUsed,
  });

  bool get hasValidOutlook =>
      primaryShiftWindow != null && activeSignals.isNotEmpty;
}

// ══════════════════════════════════════════════════════════════════════════
// SHIFT OUTLOOK SERVICE
// ══════════════════════════════════════════════════════════════════════════

class ShiftOutlookService {
  final JournalService _journalService;
  static const int minimumEntries = 14;

  ShiftOutlookService(this._journalService);

  /// Whether enough data exists for outlook analysis
  bool hasEnoughData() => _journalService.entryCount >= minimumEntries;

  /// How many more entries needed
  int entriesNeeded() =>
      math.max(0, minimumEntries - _journalService.entryCount);

  /// Generate the shift outlook
  ShiftOutlook generateOutlook() {
    if (!hasEnoughData()) {
      return const ShiftOutlook(activeSignals: [], dataPointsUsed: 0);
    }

    final cycleService = EmotionalCycleService(_journalService);
    final analysis = cycleService.analyze();

    // Detect micro-signals from recent data
    final signals = _detectMicroSignals(analysis);

    // Generate shift windows based on cycle data + signals
    final windows = _generateShiftWindows(analysis, signals);

    // Sort windows by confidence
    windows.sort((a, b) => b.confidence.index.compareTo(a.confidence.index));

    return ShiftOutlook(
      currentPhase: analysis.overallPhase,
      currentArc: analysis.overallArc,
      activeSignals: signals,
      primaryShiftWindow: windows.isNotEmpty ? windows.first : null,
      alternativeWindows: windows.length > 1 ? windows.sublist(1) : [],
      dataPointsUsed: analysis.totalEntries,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MICRO-SIGNAL DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  List<MicroSignal> _detectMicroSignals(EmotionalCycleAnalysis analysis) {
    final signals = <MicroSignal>[];
    final now = DateTime.now();

    for (final entry in analysis.areaSummaries.entries) {
      final area = entry.key;
      final summary = entry.value;

      if (summary.rawPoints.length < 3) continue;

      // Signal 1: Sudden direction change (velocity reversal)
      final velocitySignal = _detectVelocityReversal(area, summary, now);
      if (velocitySignal != null) signals.add(velocitySignal);

      // Signal 2: Variance spike (emotional turbulence)
      final varianceSignal = _detectVarianceSpike(area, summary, now);
      if (varianceSignal != null) signals.add(varianceSignal);

      // Signal 3: Threshold crossing (entering extreme zone)
      final thresholdSignal = _detectThresholdCrossing(area, summary, now);
      if (thresholdSignal != null) signals.add(thresholdSignal);

      // Signal 4: Cycle timing (near expected cycle peak/valley)
      final cycleSignal = _detectCycleTiming(area, summary, now);
      if (cycleSignal != null) signals.add(cycleSignal);
    }

    // Sort by magnitude (strongest first)
    signals.sort((a, b) => b.magnitude.compareTo(a.magnitude));
    return signals;
  }

  /// Detect when the direction of change reverses
  MicroSignal? _detectVelocityReversal(
    FocusArea area,
    FocusAreaCycleSummary summary,
    DateTime now,
  ) {
    final points = summary.rawPoints;
    if (points.length < 4) return null;

    final last4 = points.sublist(points.length - 4);
    final oldVelocity = last4[1].value - last4[0].value;
    final newVelocity = last4[3].value - last4[2].value;

    // Velocity reversal: direction changed significantly
    if (oldVelocity * newVelocity < 0 &&
        (oldVelocity - newVelocity).abs() > 0.5) {
      final direction = newVelocity > 0 ? 'upward' : 'downward';
      final directionTr = newVelocity > 0 ? 'yukarı' : 'aşağı';

      return MicroSignal(
        id: 'velocity_${area.name}',
        area: area,
        signalEn: 'Your ${area.displayNameEn} shows a recent $direction shift',
        signalTr:
            '${area.displayNameTr} alanın yakın zamanda $directionTr yönde bir kayma gösteriyor',
        magnitude: (oldVelocity - newVelocity).abs().clamp(0.0, 1.0),
        detectedAt: now,
      );
    }

    return null;
  }

  /// Detect unusual variance in recent ratings
  MicroSignal? _detectVarianceSpike(
    FocusArea area,
    FocusAreaCycleSummary summary,
    DateTime now,
  ) {
    final points = summary.rawPoints;
    if (points.length < 6) return null;

    // Compare variance of last 3 vs previous 3
    final recent3 = points.sublist(points.length - 3);
    final prev3 = points.sublist(points.length - 6, points.length - 3);

    final recentVar = _variance(recent3.map((p) => p.value).toList());
    final prevVar = _variance(prev3.map((p) => p.value).toList());

    // Variance increased by 2x or more
    if (recentVar > prevVar * 2 && recentVar > 0.5) {
      return MicroSignal(
        id: 'variance_${area.name}',
        area: area,
        signalEn: 'Your ${area.displayNameEn} has been more variable recently',
        signalTr:
            '${area.displayNameTr} alanın son zamanlarda daha değişken olmuş',
        magnitude: (recentVar / 2).clamp(0.0, 1.0),
        detectedAt: now,
      );
    }

    return null;
  }

  /// Detect crossing into extreme zones
  MicroSignal? _detectThresholdCrossing(
    FocusArea area,
    FocusAreaCycleSummary summary,
    DateTime now,
  ) {
    final points = summary.rawPoints;
    if (points.length < 2) return null;

    final prev = points[points.length - 2].value;
    final curr = points.last.value;

    // Crossed from moderate to low
    if (prev >= 2.5 && curr < 2.0) {
      return MicroSignal(
        id: 'threshold_low_${area.name}',
        area: area,
        signalEn: 'Your ${area.displayNameEn} has entered a lower range',
        signalTr: '${area.displayNameTr} alanın daha düşük bir aralığa girmiş',
        magnitude: (2.5 - curr).clamp(0.0, 1.0),
        detectedAt: now,
      );
    }

    // Crossed from moderate to high
    if (prev <= 3.5 && curr > 4.0) {
      return MicroSignal(
        id: 'threshold_high_${area.name}',
        area: area,
        signalEn: 'Your ${area.displayNameEn} has entered an elevated range',
        signalTr: '${area.displayNameTr} alanın yüksek bir aralığa girmiş',
        magnitude: (curr - 3.5).clamp(0.0, 1.0),
        detectedAt: now,
      );
    }

    return null;
  }

  /// Detect when cycle timing suggests an upcoming shift
  MicroSignal? _detectCycleTiming(
    FocusArea area,
    FocusAreaCycleSummary summary,
    DateTime now,
  ) {
    if (summary.cycleLengthDays == null) return null;
    if (summary.rawPoints.isEmpty) return null;

    final cycleLen = summary.cycleLengthDays!;
    final lastPoint = summary.rawPoints.last;
    final daysSinceLast = now.difference(lastPoint.date).inDays;

    // Within 20% of cycle length from expected shift
    final nearCycleEnd = (daysSinceLast % cycleLen);
    final distanceToShift = (cycleLen - nearCycleEnd).abs();

    if (distanceToShift <= (cycleLen * 0.2).round() && distanceToShift > 0) {
      return MicroSignal(
        id: 'cycle_timing_${area.name}',
        area: area,
        signalEn:
            'Your ${area.displayNameEn} ~$cycleLen-day cycle suggests a shift may be approaching',
        signalTr:
            '${area.displayNameTr} ~$cycleLen günlük döngün bir kaymanın yaklaşıyor olabileceğini öneriyor',
        magnitude: (1.0 - distanceToShift / cycleLen).clamp(0.0, 1.0),
        detectedAt: now,
      );
    }

    return null;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHIFT WINDOW GENERATION
  // ══════════════════════════════════════════════════════════════════════════

  List<ShiftWindow> _generateShiftWindows(
    EmotionalCycleAnalysis analysis,
    List<MicroSignal> signals,
  ) {
    final windows = <ShiftWindow>[];
    final currentPhase = analysis.overallPhase;
    if (currentPhase == null) return windows;

    // Determine the natural next phase in the cycle
    final nextPhase = _naturalNextPhase(currentPhase);

    // Calculate estimated days until shift
    final avgCycleLength = _averageCycleLength(analysis);
    final estimatedDays = avgCycleLength != null
        ? (avgCycleLength / 5).round().clamp(2, 14) // Rough phase duration
        : 7; // Default to a week

    // Determine confidence based on signals and data quality
    final confidence = _calculateConfidence(analysis, signals);

    // Get relevant signals for this shift
    final relevantSignals = signals.where((s) => s.magnitude > 0.3).toList();

    windows.add(
      ShiftWindow(
        currentPhase: currentPhase,
        suggestedNextPhase: nextPhase,
        estimatedDaysUntilShift: estimatedDays,
        confidence: confidence,
        supportingSignals: relevantSignals,
        descriptionEn: _buildShiftDescriptionEn(
          currentPhase,
          nextPhase,
          estimatedDays,
          confidence,
        ),
        descriptionTr: _buildShiftDescriptionTr(
          currentPhase,
          nextPhase,
          estimatedDays,
          confidence,
        ),
        actionEn: _buildActionEn(currentPhase, nextPhase),
        actionTr: _buildActionTr(currentPhase, nextPhase),
      ),
    );

    // If signals suggest a different path, add an alternative
    if (signals.isNotEmpty) {
      final altPhase = _signalSuggestedPhase(currentPhase, signals);
      if (altPhase != nextPhase) {
        windows.add(
          ShiftWindow(
            currentPhase: currentPhase,
            suggestedNextPhase: altPhase,
            estimatedDaysUntilShift: estimatedDays + 2,
            confidence: OutlookConfidence.low,
            supportingSignals: signals.where((s) => s.magnitude > 0.5).toList(),
            descriptionEn: _buildShiftDescriptionEn(
              currentPhase,
              altPhase,
              estimatedDays + 2,
              OutlookConfidence.low,
            ),
            descriptionTr: _buildShiftDescriptionTr(
              currentPhase,
              altPhase,
              estimatedDays + 2,
              OutlookConfidence.low,
            ),
            actionEn: _buildActionEn(currentPhase, altPhase),
            actionTr: _buildActionTr(currentPhase, altPhase),
          ),
        );
      }
    }

    return windows;
  }

  /// Natural cycle progression
  EmotionalPhase _naturalNextPhase(EmotionalPhase current) {
    switch (current) {
      case EmotionalPhase.expansion:
        return EmotionalPhase.stabilization;
      case EmotionalPhase.stabilization:
        return EmotionalPhase.contraction;
      case EmotionalPhase.contraction:
        return EmotionalPhase.reflection;
      case EmotionalPhase.reflection:
        return EmotionalPhase.recovery;
      case EmotionalPhase.recovery:
        return EmotionalPhase.expansion;
    }
  }

  /// Use signals to suggest a non-standard next phase
  EmotionalPhase _signalSuggestedPhase(
    EmotionalPhase current,
    List<MicroSignal> signals,
  ) {
    // If there are strong downward signals, suggest contraction
    final downSignals = signals.where(
      (s) => s.signalEn.contains('lower') || s.signalEn.contains('downward'),
    );
    if (downSignals.length >= 2) return EmotionalPhase.contraction;

    // If strong upward signals, suggest expansion
    final upSignals = signals.where(
      (s) => s.signalEn.contains('elevated') || s.signalEn.contains('upward'),
    );
    if (upSignals.length >= 2) return EmotionalPhase.expansion;

    // If high variance, suggest reflection
    final varianceSignals = signals.where(
      (s) => s.signalEn.contains('variable'),
    );
    if (varianceSignals.isNotEmpty) return EmotionalPhase.reflection;

    return _naturalNextPhase(current);
  }

  int? _averageCycleLength(EmotionalCycleAnalysis analysis) {
    final lengths = analysis.areaSummaries.values
        .where((s) => s.cycleLengthDays != null)
        .map((s) => s.cycleLengthDays!)
        .toList();
    if (lengths.isEmpty) return null;
    return (lengths.reduce((a, b) => a + b) / lengths.length).round();
  }

  OutlookConfidence _calculateConfidence(
    EmotionalCycleAnalysis analysis,
    List<MicroSignal> signals,
  ) {
    int score = 0;

    // More entries = more confidence
    if (analysis.totalEntries >= 30)
      score += 2;
    else if (analysis.totalEntries >= 14)
      score += 1;

    // Detected cycles increase confidence
    final cyclesDetected = analysis.areaSummaries.values
        .where((s) => s.cycleLengthDays != null)
        .length;
    if (cyclesDetected >= 3)
      score += 2;
    else if (cyclesDetected >= 1)
      score += 1;

    // Strong signals increase confidence
    final strongSignals = signals.where((s) => s.magnitude > 0.6).length;
    if (strongSignals >= 2) score += 1;

    // Phase transitions detected increase confidence
    if (analysis.recentTransitions.isNotEmpty) score += 1;

    if (score >= 5) return OutlookConfidence.high;
    if (score >= 3) return OutlookConfidence.moderate;
    return OutlookConfidence.low;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SAFE-LANGUAGE BUILDERS
  // ══════════════════════════════════════════════════════════════════════════

  String _buildShiftDescriptionEn(
    EmotionalPhase current,
    EmotionalPhase next,
    int days,
    OutlookConfidence confidence,
  ) {
    final qualifier = switch (confidence) {
      OutlookConfidence.high => 'Your patterns suggest',
      OutlookConfidence.moderate => 'Based on your recent entries',
      OutlookConfidence.low => 'Early signals hint that',
    };

    return '$qualifier a shift from ${current.labelEn()} toward '
        '${next.labelEn()} may be developing over the next ~$days days';
  }

  String _buildShiftDescriptionTr(
    EmotionalPhase current,
    EmotionalPhase next,
    int days,
    OutlookConfidence confidence,
  ) {
    final qualifier = switch (confidence) {
      OutlookConfidence.high => 'Kalıpların',
      OutlookConfidence.moderate => 'Son kayıtlarına göre',
      OutlookConfidence.low => 'Erken sinyaller',
    };

    return '$qualifier ${current.labelTr()} evresinden ${next.labelTr()} '
        'evresine doğru ~$days gün içinde bir kayma gelişiyor olabilir';
  }

  String _buildActionEn(EmotionalPhase current, EmotionalPhase next) {
    return switch (next) {
      EmotionalPhase.expansion =>
        'Consider preparing for a more active period — this may be a good time for new goals',
      EmotionalPhase.stabilization =>
        'You may benefit from consolidating recent progress and establishing routines',
      EmotionalPhase.contraction =>
        'Gentle rest and reducing commitments may help during this transition',
      EmotionalPhase.reflection =>
        'Journaling and quiet activities may feel especially valuable soon',
      EmotionalPhase.recovery =>
        'Small, manageable steps and patience with yourself tend to help during recovery',
    };
  }

  String _buildActionTr(EmotionalPhase current, EmotionalPhase next) {
    return switch (next) {
      EmotionalPhase.expansion =>
        'Daha aktif bir döneme hazırlanmayı düşünebilirsin — yeni hedefler için iyi bir zaman olabilir',
      EmotionalPhase.stabilization =>
        'Son ilerlemeyi pekiştirmek ve rutinler oluşturmaktan fayda görebilirsin',
      EmotionalPhase.contraction =>
        'Nazik öz bakım ve taahhütleri azaltmak bu geçişte yardımcı olabilir',
      EmotionalPhase.reflection =>
        'Günlük yazma ve sakin aktiviteler yakında özellikle değerli hissedebilir',
      EmotionalPhase.recovery =>
        'Küçük, yönetilebilir adımlar ve kendine sabır toparlanma döneminde yardımcı olma eğiliminde',
    };
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  double _variance(List<double> values) {
    if (values.length < 2) return 0;
    final mean = values.reduce((a, b) => a + b) / values.length;
    return values.fold<double>(0, (s, v) => s + (v - mean) * (v - mean)) /
        values.length;
  }
}
