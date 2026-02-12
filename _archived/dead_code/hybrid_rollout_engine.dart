// ML-Assisted Experimentation System - Hybrid Rollout Engine
// Decision hierarchy: Rule-based guards > ML Risk Gate > ML Acceleration
import 'package:flutter/foundation.dart';
import '../models/rollout_decision.dart';
import 'ml_rollout_predictor.dart';

// Re-export RolloutContext for convenience
export '../models/rollout_decision.dart' show RolloutContext;

/// Hybrid Rollout Decision Engine
/// CRITICAL: Decision hierarchy is strictly enforced
/// Level 1 (Hard Guards) ALWAYS takes precedence over ML
class HybridRolloutEngine {
  // ============================================================
  // LEVEL 1: HARD GUARDS (ML CANNOT OVERRIDE)
  // ============================================================

  /// Churn rate threshold for critical level (10%)
  static const double kChurnCriticalThreshold = 0.10;

  /// Churn rate threshold for warning level (7%)
  static const double kChurnWarningThreshold = 0.07;

  /// Crash spike multiplier for immediate rollback (2x baseline)
  static const double kCrashSpikeMultiplier = 2.0;

  /// Error spike multiplier for immediate rollback (3x baseline)
  static const double kErrorSpikeMultiplier = 3.0;

  // ============================================================
  // LEVEL 2: ML RISK GATE THRESHOLDS
  // ============================================================

  /// Risk probability threshold for rollback
  static const double kRiskThresholdRollback = 0.5;

  /// Risk probability threshold for hold
  static const double kRiskThresholdHold = 0.3;

  // ============================================================
  // LEVEL 3: ML ACCELERATION CONSTRAINTS
  // ============================================================

  /// Minimum confidence for ML acceleration
  static const double kMinConfidenceForAcceleration = 0.7;

  /// Maximum rollout step size (25%)
  static const int kMaxRolloutStepSize = 25;

  /// Valid rollout step sizes
  static const List<int> kValidStepSizes = [0, 5, 10, 15, 20, 25];

  final MLRolloutPredictor _predictor;

  HybridRolloutEngine({MLRolloutPredictor? predictor})
    : _predictor = predictor ?? MLRolloutPredictor();

  /// Make rollout decision using hierarchy
  /// Returns decision with full audit trail
  Future<RolloutDecision> decide({
    required String flagName,
    required int currentPercentage,
    required RolloutContext context,
  }) async {
    // ============================================================
    // LEVEL 1: HARD GUARDS (CHECKED FIRST, ALWAYS)
    // ============================================================

    final level1Decision = _checkLevel1HardGuards(
      flagName: flagName,
      currentPercentage: currentPercentage,
      context: context,
    );

    if (level1Decision != null) {
      debugPrint(
        '[HybridRollout] Level 1 guard triggered for $flagName: ${level1Decision.overrideReason}',
      );
      return level1Decision;
    }

    // ============================================================
    // LEVEL 2: ML RISK GATE (ONLY IF LEVEL 1 PASSES)
    // ============================================================

    final mlPrediction = await _predictor.predict(context);

    final level2Decision = _checkLevel2MLRiskGate(
      flagName: flagName,
      currentPercentage: currentPercentage,
      prediction: mlPrediction,
    );

    if (level2Decision != null) {
      debugPrint(
        '[HybridRollout] Level 2 ML risk gate triggered for $flagName: '
        'risk=${mlPrediction.riskProbability.toStringAsFixed(2)}',
      );
      return level2Decision;
    }

    // ============================================================
    // LEVEL 3: ML ACCELERATION (ONLY IF LEVEL 2 PASSES)
    // ============================================================

    return _applyLevel3MLAcceleration(
      flagName: flagName,
      currentPercentage: currentPercentage,
      prediction: mlPrediction,
    );
  }

  /// Level 1: Check hard guards (immutable safety rules)
  RolloutDecision? _checkLevel1HardGuards({
    required String flagName,
    required int currentPercentage,
    required RolloutContext context,
  }) {
    // Check churn level - critical
    if (context.churnRate >= kChurnCriticalThreshold) {
      return RolloutDecision(
        id: _generateId(),
        flagName: flagName,
        action: RolloutAction.freeze,
        previousPercentage: currentPercentage,
        newPercentage: currentPercentage,
        decisionSource: DecisionSource.ruleChurnDefense,
        decisionLevel: 1,
        mlOverridden: true,
        overrideReason:
            'Churn rate ${(context.churnRate * 100).toStringAsFixed(1)}% >= ${(kChurnCriticalThreshold * 100).toStringAsFixed(0)}% critical threshold',
        explanation:
            'CRITICAL: Churn defense activated. Experiments frozen. Force safe values.',
        createdAt: DateTime.now(),
      );
    }

    // Check churn level - warning
    if (context.churnRate >= kChurnWarningThreshold) {
      return RolloutDecision(
        id: _generateId(),
        flagName: flagName,
        action: RolloutAction.freeze,
        previousPercentage: currentPercentage,
        newPercentage: currentPercentage,
        decisionSource: DecisionSource.ruleChurnDefense,
        decisionLevel: 1,
        mlOverridden: true,
        overrideReason:
            'Churn rate ${(context.churnRate * 100).toStringAsFixed(1)}% >= ${(kChurnWarningThreshold * 100).toStringAsFixed(0)}% warning threshold',
        explanation:
            'WARNING: Elevated churn detected. Experiments frozen until stabilization.',
        createdAt: DateTime.now(),
      );
    }

    // Check crash spike (>2x baseline)
    if (context.crashRateBaseline > 0 &&
        context.crashRateCurrent >
            context.crashRateBaseline * kCrashSpikeMultiplier) {
      final multiple = (context.crashRateCurrent / context.crashRateBaseline)
          .toStringAsFixed(1);
      return RolloutDecision(
        id: _generateId(),
        flagName: flagName,
        action: RolloutAction.rollback,
        previousPercentage: currentPercentage,
        newPercentage: _calculateRollbackPercentage(currentPercentage),
        decisionSource: DecisionSource.safetyRollback,
        decisionLevel: 1,
        mlOverridden: true,
        overrideReason:
            'Crash rate spike: ${multiple}x baseline (>${kCrashSpikeMultiplier}x threshold)',
        explanation:
            'IMMEDIATE ROLLBACK: Crash rate spiked to ${multiple}x baseline. Rolling back one stage.',
        createdAt: DateTime.now(),
      );
    }

    // Check error spike (>3x baseline)
    if (context.errorRateBaseline > 0 &&
        context.errorRateCurrent >
            context.errorRateBaseline * kErrorSpikeMultiplier) {
      final multiple = (context.errorRateCurrent / context.errorRateBaseline)
          .toStringAsFixed(1);
      return RolloutDecision(
        id: _generateId(),
        flagName: flagName,
        action: RolloutAction.rollback,
        previousPercentage: currentPercentage,
        newPercentage: _calculateRollbackPercentage(currentPercentage),
        decisionSource: DecisionSource.safetyRollback,
        decisionLevel: 1,
        mlOverridden: true,
        overrideReason:
            'Error rate spike: ${multiple}x baseline (>${kErrorSpikeMultiplier}x threshold)',
        explanation:
            'IMMEDIATE ROLLBACK: Error rate spiked to ${multiple}x baseline. Rolling back one stage.',
        createdAt: DateTime.now(),
      );
    }

    return null; // No Level 1 guards triggered
  }

  /// Level 2: ML Risk Gate
  RolloutDecision? _checkLevel2MLRiskGate({
    required String flagName,
    required int currentPercentage,
    required MLPrediction prediction,
  }) {
    // Risk > 0.5 → Rollback
    if (prediction.riskProbability > kRiskThresholdRollback) {
      return RolloutDecision(
        id: _generateId(),
        flagName: flagName,
        action: RolloutAction.rollback,
        previousPercentage: currentPercentage,
        newPercentage: _calculateRollbackPercentage(currentPercentage),
        decisionSource: DecisionSource.mlRiskGate,
        decisionLevel: 2,
        mlRiskProbability: prediction.riskProbability,
        mlSuggestedDelta: prediction.suggestedDelta,
        mlConfidenceNext: prediction.confidenceNextStage,
        mlOverridden: false,
        explanation: _buildExplanation(prediction, 'rollback'),
        topContributors: prediction.topContributors,
        createdAt: DateTime.now(),
      );
    }

    // Risk > 0.3 → Hold
    if (prediction.riskProbability > kRiskThresholdHold) {
      return RolloutDecision(
        id: _generateId(),
        flagName: flagName,
        action: RolloutAction.hold,
        previousPercentage: currentPercentage,
        newPercentage: currentPercentage,
        decisionSource: DecisionSource.mlRiskGate,
        decisionLevel: 2,
        mlRiskProbability: prediction.riskProbability,
        mlSuggestedDelta: prediction.suggestedDelta,
        mlConfidenceNext: prediction.confidenceNextStage,
        mlOverridden: false,
        explanation: _buildExplanation(prediction, 'hold'),
        topContributors: prediction.topContributors,
        createdAt: DateTime.now(),
      );
    }

    return null; // Risk acceptable, proceed to Level 3
  }

  /// Level 3: ML Acceleration
  RolloutDecision _applyLevel3MLAcceleration({
    required String flagName,
    required int currentPercentage,
    required MLPrediction prediction,
  }) {
    // Check confidence threshold
    if (prediction.confidenceNextStage < kMinConfidenceForAcceleration) {
      return RolloutDecision(
        id: _generateId(),
        flagName: flagName,
        action: RolloutAction.hold,
        previousPercentage: currentPercentage,
        newPercentage: currentPercentage,
        decisionSource: DecisionSource.mlAcceleration,
        decisionLevel: 3,
        mlRiskProbability: prediction.riskProbability,
        mlSuggestedDelta: prediction.suggestedDelta,
        mlConfidenceNext: prediction.confidenceNextStage,
        mlOverridden: false,
        explanation:
            'HOLD: Confidence ${(prediction.confidenceNextStage * 100).toStringAsFixed(0)}% '
            'below ${(kMinConfidenceForAcceleration * 100).toStringAsFixed(0)}% threshold for advancement.',
        topContributors: prediction.topContributors,
        createdAt: DateTime.now(),
      );
    }

    // Apply suggested delta (capped at max)
    final suggestedDelta = prediction.suggestedDelta.clamp(
      0,
      kMaxRolloutStepSize,
    );
    final newPercentage = (currentPercentage + suggestedDelta).clamp(0, 100);

    if (suggestedDelta == 0 || newPercentage == currentPercentage) {
      return RolloutDecision(
        id: _generateId(),
        flagName: flagName,
        action: RolloutAction.hold,
        previousPercentage: currentPercentage,
        newPercentage: currentPercentage,
        decisionSource: DecisionSource.mlAcceleration,
        decisionLevel: 3,
        mlRiskProbability: prediction.riskProbability,
        mlSuggestedDelta: prediction.suggestedDelta,
        mlConfidenceNext: prediction.confidenceNextStage,
        mlOverridden: false,
        explanation: 'HOLD: ML suggests no advancement at this time.',
        topContributors: prediction.topContributors,
        createdAt: DateTime.now(),
      );
    }

    return RolloutDecision(
      id: _generateId(),
      flagName: flagName,
      action: RolloutAction.advance,
      previousPercentage: currentPercentage,
      newPercentage: newPercentage,
      decisionSource: DecisionSource.mlAcceleration,
      decisionLevel: 3,
      mlRiskProbability: prediction.riskProbability,
      mlSuggestedDelta: suggestedDelta,
      mlConfidenceNext: prediction.confidenceNextStage,
      mlOverridden: false,
      explanation: _buildExplanation(prediction, 'advance', suggestedDelta),
      topContributors: prediction.topContributors,
      createdAt: DateTime.now(),
    );
  }

  /// Calculate rollback percentage (one stage back)
  int _calculateRollbackPercentage(int current) {
    if (current >= 100) return 50;
    if (current >= 50) return 10;
    if (current >= 10) return 1;
    return 0;
  }

  /// Build human-readable explanation
  String _buildExplanation(
    MLPrediction prediction,
    String action, [
    int? delta,
  ]) {
    final risk = (prediction.riskProbability * 100).toStringAsFixed(0);
    final confidence = (prediction.confidenceNextStage * 100).toStringAsFixed(
      0,
    );

    final buffer = StringBuffer();

    switch (action) {
      case 'rollback':
        buffer.write('ROLLBACK recommended: ');
        buffer.write('Risk probability $risk% exceeds 50% threshold. ');
        break;
      case 'hold':
        buffer.write('HOLD recommended: ');
        buffer.write('Risk probability $risk% exceeds 30% threshold. ');
        break;
      case 'advance':
        buffer.write('ADVANCE recommended: ');
        buffer.write('Risk probability $risk% is acceptable. ');
        if (delta != null) {
          buffer.write('Suggested step: +$delta%. ');
        }
        break;
    }

    buffer.write('Confidence for next stage: $confidence%. ');

    // Add top contributors
    if (prediction.topContributors.isNotEmpty) {
      final topFactors = prediction.topContributors
          .take(3)
          .map((c) => c.featureName.replaceAll('_', ' '))
          .join(', ');
      buffer.write('Key factors: $topFactors.');
    }

    return buffer.toString();
  }

  /// Generate unique decision ID
  String _generateId() {
    return 'rd_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
  }
}

// Note: RolloutContext is defined in rollout_decision.dart and re-exported above
