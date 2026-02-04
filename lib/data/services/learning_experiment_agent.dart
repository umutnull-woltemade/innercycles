// ML-Assisted Experimentation System - Learning Experiment Agent
// Self-improving A/B interpretation with pattern detection
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../models/experiment_metrics.dart';
import 'experiment_feature_extractor.dart';

/// Learning A/B Interpretation Agent
/// Safety constraints are IMMUTABLE and cannot be bypassed by learning
class LearningExperimentAgent {
  // ============================================================
  // SAFETY CONSTRAINTS (IMMUTABLE - CANNOT BE BYPASSED)
  // ============================================================

  /// Maximum crash rate before forced rollback (0.5%)
  static const double kCrashThresholdAbsolute = 0.005;

  /// Maximum error rate before forced rollback (15%)
  static const double kErrorThresholdAbsolute = 0.15;

  /// Minimum sample size before any decision (100)
  static const int kMinSampleSize = 100;

  /// Minimum hours in stage before advancement (24)
  static const int kMinHoursPerStage = 24;

  /// Minimum confidence for advancement (0.7)
  static const double kMinConfidenceForAdvance = 0.7;

  // ============================================================
  // LEARNING PARAMETERS
  // ============================================================

  /// Learning rate for weight updates
  static const double kLearningRate = 0.1;

  /// Minimum weight value
  static const double kMinWeight = -10.0;

  /// Maximum weight value
  static const double kMaxWeight = 10.0;

  final ExperimentFeatureExtractor _featureExtractor;
  LearningModelState _modelState;

  LearningExperimentAgent({
    ExperimentFeatureExtractor? featureExtractor,
    LearningModelState? initialModelState,
  })  : _featureExtractor = featureExtractor ?? ExperimentFeatureExtractor(),
        _modelState = initialModelState ?? LearningModelState.initial();

  /// Get current model state
  LearningModelState get modelState => _modelState;

  /// Analyze experiment and return recommendation
  /// SAFETY CHECKS ARE ALWAYS PERFORMED FIRST
  AgentRecommendation analyze(List<ExperimentMetricSnapshot> history) {
    if (history.isEmpty) {
      return AgentRecommendation(
        recommendation: RecommendationType.hold,
        confidence: 0.0,
        explanation: 'No metric history available',
        generatedAt: DateTime.now(),
      );
    }

    final current = history.last;
    final features = _featureExtractor.extract(history);

    // ============================================================
    // LEVEL 1: SAFETY CONSTRAINTS (CANNOT BE BYPASSED)
    // ============================================================

    final safetyCheck = _checkSafetyConstraints(current, features);
    if (safetyCheck != null) {
      return safetyCheck;
    }

    // ============================================================
    // LEVEL 2: LEARNING-BASED ANALYSIS
    // ============================================================

    return _runLearningAnalysis(features, history);
  }

  /// Check safety constraints - returns recommendation if violated, null otherwise
  AgentRecommendation? _checkSafetyConstraints(
    ExperimentMetricSnapshot current,
    ExtractedFeatures features,
  ) {
    final triggeredGuards = <String>[];

    // Check crash rate threshold (HARD LIMIT)
    if (current.crashRate > kCrashThresholdAbsolute) {
      triggeredGuards.add('crash_rate_exceeded');
      return AgentRecommendation.safetyOverride(
        recommendation: RecommendationType.rollback,
        reason: 'Crash rate ${(current.crashRate * 100).toStringAsFixed(2)}% exceeds absolute limit of ${(kCrashThresholdAbsolute * 100).toStringAsFixed(1)}%',
        triggeredGuards: triggeredGuards,
      );
    }

    // Check error rate threshold (HARD LIMIT)
    if (current.errorRate > kErrorThresholdAbsolute) {
      triggeredGuards.add('error_rate_exceeded');
      return AgentRecommendation.safetyOverride(
        recommendation: RecommendationType.rollback,
        reason: 'Error rate ${(current.errorRate * 100).toStringAsFixed(1)}% exceeds absolute limit of ${(kErrorThresholdAbsolute * 100).toStringAsFixed(0)}%',
        triggeredGuards: triggeredGuards,
      );
    }

    // Check for critical anomaly
    if (features.hasCriticalAnomaly) {
      triggeredGuards.add('critical_anomaly_detected');
      return AgentRecommendation.safetyOverride(
        recommendation: RecommendationType.rollback,
        reason: 'Critical anomaly detected in metrics',
        triggeredGuards: triggeredGuards,
      );
    }

    // Check minimum sample size (HARD LIMIT)
    if (current.sampleSize < kMinSampleSize) {
      triggeredGuards.add('insufficient_sample_size');
      return AgentRecommendation(
        recommendation: RecommendationType.hold,
        confidence: 0.5,
        explanation: 'Insufficient sample size: ${current.sampleSize} < $kMinSampleSize minimum',
        generatedAt: DateTime.now(),
        isSafetyOverride: true,
        safetyOverrideReason: 'Minimum sample size not met',
        triggeredSafetyGuards: triggeredGuards,
      );
    }

    // Check minimum time in stage (HARD LIMIT)
    if (current.hoursInStage < kMinHoursPerStage) {
      triggeredGuards.add('insufficient_observation_time');
      return AgentRecommendation(
        recommendation: RecommendationType.hold,
        confidence: 0.5,
        explanation: 'Insufficient observation time: ${current.hoursInStage}h < ${kMinHoursPerStage}h minimum',
        generatedAt: DateTime.now(),
        isSafetyOverride: true,
        safetyOverrideReason: 'Minimum observation time not met',
        triggeredSafetyGuards: triggeredGuards,
      );
    }

    // Check learned thresholds (within bounds)
    if (current.crashRate > _modelState.crashThresholdWarning) {
      triggeredGuards.add('crash_rate_warning');
      return AgentRecommendation(
        recommendation: RecommendationType.hold,
        confidence: 0.7,
        explanation: 'Crash rate ${(current.crashRate * 100).toStringAsFixed(2)}% exceeds learned warning threshold',
        signals: features.earlyWarningSignals,
        generatedAt: DateTime.now(),
        triggeredSafetyGuards: triggeredGuards,
      );
    }

    if (current.errorRate > _modelState.errorThresholdWarning) {
      triggeredGuards.add('error_rate_warning');
      return AgentRecommendation(
        recommendation: RecommendationType.hold,
        confidence: 0.7,
        explanation: 'Error rate ${(current.errorRate * 100).toStringAsFixed(1)}% exceeds learned warning threshold',
        signals: features.earlyWarningSignals,
        generatedAt: DateTime.now(),
        triggeredSafetyGuards: triggeredGuards,
      );
    }

    return null; // No safety issues
  }

  /// Run learning-based analysis
  AgentRecommendation _runLearningAnalysis(
    ExtractedFeatures features,
    List<ExperimentMetricSnapshot> history,
  ) {
    // Calculate scores using learned weights
    final featureMap = features.toMap();
    double advanceScore = 0.0;
    double rollbackScore = 0.0;
    double holdScore = 0.0;

    final contributingFeatures = <String, double>{};

    for (final entry in _modelState.featureWeights.entries) {
      final featureValue = featureMap[entry.key] ?? 0.0;
      final weightedValue = featureValue * entry.value;
      contributingFeatures[entry.key] = weightedValue;

      if (entry.value > 0) {
        advanceScore += weightedValue;
      } else {
        rollbackScore += weightedValue.abs();
      }
    }

    // Normalize scores
    final totalScore = advanceScore + rollbackScore + 1.0;
    advanceScore /= totalScore;
    rollbackScore /= totalScore;
    holdScore = 1.0 - advanceScore - rollbackScore;

    // Check for pattern matches
    final matchingPatterns = _findMatchingPatterns(featureMap);
    if (matchingPatterns.isNotEmpty) {
      final bestPattern = matchingPatterns.first;
      return AgentRecommendation(
        recommendation: bestPattern.recommendedAction,
        confidence: bestPattern.confidence,
        explanation: 'Pattern match: ${bestPattern.description}',
        signals: features.earlyWarningSignals,
        featureWeights: contributingFeatures,
        generatedAt: DateTime.now(),
      );
    }

    // Make decision based on scores
    RecommendationType recommendation;
    double confidence;
    String explanation;

    if (advanceScore > rollbackScore && advanceScore > holdScore) {
      // Check confidence threshold for advancement
      if (features.confidenceScore < kMinConfidenceForAdvance) {
        recommendation = RecommendationType.hold;
        confidence = features.confidenceScore;
        explanation = 'Metrics look good but confidence ${(features.confidenceScore * 100).toStringAsFixed(0)}% below ${(kMinConfidenceForAdvance * 100).toStringAsFixed(0)}% threshold';
      } else if (features.isStabilizing) {
        recommendation = RecommendationType.advance;
        confidence = math.min(0.95, advanceScore + 0.1);
        explanation = 'Metrics stable and healthy. Recommend advancing to next stage.';
      } else {
        recommendation = RecommendationType.advance;
        confidence = advanceScore;
        explanation = 'Positive signals detected. Recommend advancement.';
      }
    } else if (rollbackScore > advanceScore && rollbackScore > holdScore) {
      recommendation = RecommendationType.rollback;
      confidence = rollbackScore;
      explanation = 'Negative trend detected. Recommend rollback.';
    } else {
      recommendation = RecommendationType.hold;
      confidence = holdScore;
      if (features.earlyWarningSignals.isNotEmpty) {
        explanation = 'Early warnings detected: ${features.earlyWarningSignals.join(", ")}';
      } else {
        explanation = 'Metrics inconclusive. Recommend holding for more data.';
      }
    }

    return AgentRecommendation(
      recommendation: recommendation,
      confidence: confidence,
      confidenceDelta: features.confidenceScore -
          (history.length > 1 ? history[history.length - 2].confidenceScore : 0),
      explanation: explanation,
      signals: features.earlyWarningSignals,
      featureWeights: contributingFeatures,
      generatedAt: DateTime.now(),
    );
  }

  /// Find patterns that match current features
  List<LearnedPattern> _findMatchingPatterns(Map<String, double> features) {
    final matches = <LearnedPattern>[];

    for (final pattern in _modelState.patterns) {
      if (pattern.matches(features)) {
        matches.add(pattern);
      }
    }

    // Sort by confidence
    matches.sort((a, b) => b.confidence.compareTo(a.confidence));

    return matches;
  }

  /// Record outcome and update model
  void recordOutcome({
    required String experimentId,
    required bool wasSuccessful,
    required AgentRecommendation recommendation,
    required List<ExperimentMetricSnapshot> history,
  }) {
    if (history.isEmpty) return;

    final features = _featureExtractor.extract(history);
    final featureMap = features.toMap();

    // Determine if prediction was correct
    final predictedSuccess =
        recommendation.recommendation == RecommendationType.advance;
    final wasCorrect = predictedSuccess == wasSuccessful;

    // Update prediction counts
    final newCorrectPredictions =
        _modelState.correctPredictions + (wasCorrect ? 1 : 0);
    final newTotalPredictions = _modelState.totalPredictions + 1;
    final newAccuracy = newTotalPredictions > 0
        ? newCorrectPredictions / newTotalPredictions
        : 0.0;

    // Update weights based on outcome
    final newWeights = Map<String, double>.from(_modelState.featureWeights);

    for (final entry in newWeights.entries) {
      final featureValue = featureMap[entry.key] ?? 0.0;

      double adjustment;
      if (wasCorrect) {
        // Reinforce current weights
        adjustment = kLearningRate * featureValue * entry.value.sign;
      } else {
        // Adjust weights in opposite direction
        adjustment = -kLearningRate * featureValue * entry.value.sign;
      }

      newWeights[entry.key] =
          (entry.value + adjustment).clamp(kMinWeight, kMaxWeight);
    }

    // Update thresholds based on outcome
    double newCrashThreshold = _modelState.crashThresholdWarning;
    double newErrorThreshold = _modelState.errorThresholdWarning;

    if (!wasSuccessful) {
      // If failed, consider tightening thresholds
      if (features.crashRate > 0 && features.crashRate < newCrashThreshold) {
        newCrashThreshold = math.max(
          LearningModelState.kCrashThresholdMin,
          newCrashThreshold - 0.0001,
        );
      }
      if (features.errorRate > 0 && features.errorRate < newErrorThreshold) {
        newErrorThreshold = math.max(
          LearningModelState.kErrorThresholdMin,
          newErrorThreshold - 0.005,
        );
      }
    } else if (wasCorrect && recommendation.recommendation == RecommendationType.advance) {
      // If successful advance, consider loosening thresholds slightly
      newCrashThreshold = math.min(
        LearningModelState.kCrashThresholdMax,
        newCrashThreshold + 0.00005,
      );
      newErrorThreshold = math.min(
        LearningModelState.kErrorThresholdMax,
        newErrorThreshold + 0.002,
      );
    }

    // Detect and store new patterns
    final newPatterns = List<LearnedPattern>.from(_modelState.patterns);
    final patternCandidate = _detectPattern(featureMap, wasSuccessful, recommendation);
    if (patternCandidate != null) {
      // Check if similar pattern exists
      final existingIndex = newPatterns.indexWhere(
        (p) => p.name == patternCandidate.name,
      );
      if (existingIndex >= 0) {
        // Update existing pattern
        final existing = newPatterns[existingIndex];
        newPatterns[existingIndex] = LearnedPattern(
          id: existing.id,
          name: existing.name,
          description: existing.description,
          featureConditions: patternCandidate.featureConditions,
          recommendedAction: patternCandidate.recommendedAction,
          confidence: (existing.confidence * existing.observationCount +
                  patternCandidate.confidence) /
              (existing.observationCount + 1),
          observationCount: existing.observationCount + 1,
          lastObserved: DateTime.now(),
        );
      } else if (newPatterns.length < 50) {
        // Add new pattern (max 50 patterns)
        newPatterns.add(patternCandidate);
      }
    }

    // Update model state
    _modelState = _modelState.copyWith(
      modelVersion: _modelState.nextVersion,
      lastUpdated: DateTime.now(),
      trainingEpochs: _modelState.trainingEpochs + 1,
      crashThresholdWarning: newCrashThreshold,
      errorThresholdWarning: newErrorThreshold,
      featureWeights: newWeights,
      patterns: newPatterns,
      accuracy: newAccuracy,
      correctPredictions: newCorrectPredictions,
      totalPredictions: newTotalPredictions,
    );

    debugPrint(
      '[LearningAgent] Updated model to ${_modelState.modelVersion}, '
      'accuracy: ${(newAccuracy * 100).toStringAsFixed(1)}%',
    );
  }

  /// Detect potential pattern from outcome
  LearnedPattern? _detectPattern(
    Map<String, double> features,
    bool wasSuccessful,
    AgentRecommendation recommendation,
  ) {
    // Only create patterns for clear outcomes
    if (recommendation.confidence < 0.6) return null;

    // Identify significant features
    final significantFeatures = <String, double>{};
    final sortedContributions = recommendation.featureWeights.entries.toList()
      ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));

    for (final entry in sortedContributions.take(3)) {
      final featureValue = features[entry.key];
      if (featureValue != null && entry.value.abs() > 0.1) {
        significantFeatures[entry.key] = featureValue;
      }
    }

    if (significantFeatures.isEmpty) return null;

    final patternName = wasSuccessful ? 'success_pattern' : 'failure_pattern';
    final action = wasSuccessful
        ? RecommendationType.advance
        : RecommendationType.rollback;

    return LearnedPattern(
      id: '${patternName}_${DateTime.now().millisecondsSinceEpoch}',
      name: patternName,
      description: wasSuccessful
          ? 'Detected success pattern with ${significantFeatures.keys.join(", ")}'
          : 'Detected failure pattern with ${significantFeatures.keys.join(", ")}',
      featureConditions: significantFeatures,
      recommendedAction: action,
      confidence: recommendation.confidence,
      observationCount: 1,
      lastObserved: DateTime.now(),
    );
  }

  /// Load model state from storage
  void loadModelState(LearningModelState state) {
    _modelState = state;
    debugPrint('[LearningAgent] Loaded model ${state.modelVersion}');
  }

  /// Export model state for persistence
  Map<String, dynamic> exportModelState() {
    return _modelState.toJson();
  }

  /// Reset model to initial state
  void resetModel() {
    _modelState = LearningModelState.initial();
    debugPrint('[LearningAgent] Model reset to initial state');
  }
}
