// ML-Assisted Experimentation System - Experiment Metrics Models
// Part of the Learning A/B Interpretation Agent
import 'dart:math' as math;

/// Recommendation types for experiment decisions
enum RecommendationType { hold, advance, rollback }

/// Time-series metric snapshot for experiment tracking
class ExperimentMetricSnapshot {
  final String id;
  final String experimentId;
  final String variantCode;
  final DateTime timestamp;
  final int stageNumber; // 1=canary, 2=10%, 3=50%, 4=100%
  final double rolloutPercentage;
  final int sampleSize;

  // Core metrics
  final double successRate;
  final double errorRate;
  final double crashRate;
  final double confidenceScore;

  // Time tracking
  final int hoursInStage;
  final int hoursTotal;

  // Optional user reference
  final String? userId;

  const ExperimentMetricSnapshot({
    required this.id,
    required this.experimentId,
    required this.variantCode,
    required this.timestamp,
    required this.stageNumber,
    required this.rolloutPercentage,
    required this.sampleSize,
    required this.successRate,
    required this.errorRate,
    required this.crashRate,
    required this.confidenceScore,
    required this.hoursInStage,
    required this.hoursTotal,
    this.userId,
  });

  factory ExperimentMetricSnapshot.fromJson(Map<String, dynamic> json) {
    return ExperimentMetricSnapshot(
      id: json['id'] as String,
      experimentId: json['experiment_id'] as String,
      variantCode: json['variant_code'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      stageNumber: json['stage_number'] as int,
      rolloutPercentage: (json['rollout_percentage'] as num).toDouble(),
      sampleSize: json['sample_size'] as int,
      successRate: (json['success_rate'] as num).toDouble(),
      errorRate: (json['error_rate'] as num).toDouble(),
      crashRate: (json['crash_rate'] as num).toDouble(),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      hoursInStage: json['hours_in_stage'] as int,
      hoursTotal: json['hours_total'] as int,
      userId: json['user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experiment_id': experimentId,
      'variant_code': variantCode,
      'timestamp': timestamp.toIso8601String(),
      'stage_number': stageNumber,
      'rollout_percentage': rolloutPercentage,
      'sample_size': sampleSize,
      'success_rate': successRate,
      'error_rate': errorRate,
      'crash_rate': crashRate,
      'confidence_score': confidenceScore,
      'hours_in_stage': hoursInStage,
      'hours_total': hoursTotal,
      if (userId != null) 'user_id': userId,
    };
  }

  ExperimentMetricSnapshot copyWith({
    String? id,
    String? experimentId,
    String? variantCode,
    DateTime? timestamp,
    int? stageNumber,
    double? rolloutPercentage,
    int? sampleSize,
    double? successRate,
    double? errorRate,
    double? crashRate,
    double? confidenceScore,
    int? hoursInStage,
    int? hoursTotal,
    String? userId,
  }) {
    return ExperimentMetricSnapshot(
      id: id ?? this.id,
      experimentId: experimentId ?? this.experimentId,
      variantCode: variantCode ?? this.variantCode,
      timestamp: timestamp ?? this.timestamp,
      stageNumber: stageNumber ?? this.stageNumber,
      rolloutPercentage: rolloutPercentage ?? this.rolloutPercentage,
      sampleSize: sampleSize ?? this.sampleSize,
      successRate: successRate ?? this.successRate,
      errorRate: errorRate ?? this.errorRate,
      crashRate: crashRate ?? this.crashRate,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      hoursInStage: hoursInStage ?? this.hoursInStage,
      hoursTotal: hoursTotal ?? this.hoursTotal,
      userId: userId ?? this.userId,
    );
  }
}

/// Agent recommendation output
class AgentRecommendation {
  final RecommendationType recommendation;
  final double confidence;
  final double confidenceDelta;
  final String explanation;
  final List<String> signals;
  final Map<String, double> featureWeights;
  final DateTime generatedAt;
  final bool isSafetyOverride;
  final String? safetyOverrideReason;
  final List<String> triggeredSafetyGuards;

  const AgentRecommendation({
    required this.recommendation,
    required this.confidence,
    this.confidenceDelta = 0.0,
    required this.explanation,
    this.signals = const [],
    this.featureWeights = const {},
    required this.generatedAt,
    this.isSafetyOverride = false,
    this.safetyOverrideReason,
    this.triggeredSafetyGuards = const [],
  });

  factory AgentRecommendation.fromJson(Map<String, dynamic> json) {
    return AgentRecommendation(
      recommendation: RecommendationType.values.firstWhere(
        (e) => e.name == json['recommendation'],
        orElse: () => RecommendationType.hold,
      ),
      confidence: (json['confidence'] as num).toDouble(),
      confidenceDelta: (json['confidence_delta'] as num?)?.toDouble() ?? 0.0,
      explanation: json['explanation'] as String,
      signals: List<String>.from(json['signals'] ?? []),
      featureWeights: Map<String, double>.from(
        (json['feature_weights'] as Map?)?.map(
              (k, v) => MapEntry(k as String, (v as num).toDouble()),
            ) ??
            {},
      ),
      generatedAt: DateTime.parse(json['generated_at'] as String),
      isSafetyOverride: json['is_safety_override'] as bool? ?? false,
      safetyOverrideReason: json['safety_override_reason'] as String?,
      triggeredSafetyGuards: List<String>.from(
        json['triggered_safety_guards'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendation': recommendation.name,
      'confidence': confidence,
      'confidence_delta': confidenceDelta,
      'explanation': explanation,
      'signals': signals,
      'feature_weights': featureWeights,
      'generated_at': generatedAt.toIso8601String(),
      'is_safety_override': isSafetyOverride,
      if (safetyOverrideReason != null)
        'safety_override_reason': safetyOverrideReason,
      'triggered_safety_guards': triggeredSafetyGuards,
    };
  }

  factory AgentRecommendation.safetyOverride({
    required RecommendationType recommendation,
    required String reason,
    required List<String> triggeredGuards,
  }) {
    return AgentRecommendation(
      recommendation: recommendation,
      confidence: 1.0,
      explanation: 'SAFETY OVERRIDE: \$reason',
      generatedAt: DateTime.now(),
      isSafetyOverride: true,
      safetyOverrideReason: reason,
      triggeredSafetyGuards: triggeredGuards,
    );
  }
}

/// Learned pattern from historical data
class LearnedPattern {
  final String id;
  final String name;
  final String description;
  final Map<String, double> featureConditions;
  final RecommendationType recommendedAction;
  final double confidence;
  final int observationCount;
  final DateTime lastObserved;

  const LearnedPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.featureConditions,
    required this.recommendedAction,
    required this.confidence,
    required this.observationCount,
    required this.lastObserved,
  });

  factory LearnedPattern.fromJson(Map<String, dynamic> json) {
    return LearnedPattern(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      featureConditions: Map<String, double>.from(
        (json['feature_conditions'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      ),
      recommendedAction: RecommendationType.values.firstWhere(
        (e) => e.name == json['recommended_action'],
        orElse: () => RecommendationType.hold,
      ),
      confidence: (json['confidence'] as num).toDouble(),
      observationCount: json['observation_count'] as int,
      lastObserved: DateTime.parse(json['last_observed'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'feature_conditions': featureConditions,
      'recommended_action': recommendedAction.name,
      'confidence': confidence,
      'observation_count': observationCount,
      'last_observed': lastObserved.toIso8601String(),
    };
  }

  bool matches(Map<String, double> features, {double tolerance = 0.1}) {
    for (final entry in featureConditions.entries) {
      final featureValue = features[entry.key];
      if (featureValue == null) return false;
      if ((featureValue - entry.value).abs() > tolerance) return false;
    }
    return true;
  }
}

/// Learned model state for persistence
class LearningModelState {
  final String modelVersion;
  final DateTime lastUpdated;
  final int trainingEpochs;
  final double crashThresholdWarning;
  final double errorThresholdWarning;
  final Map<String, double> featureWeights;
  final List<LearnedPattern> patterns;
  final double accuracy;
  final int correctPredictions;
  final int totalPredictions;

  static const double kCrashThresholdMin = 0.001;
  static const double kCrashThresholdMax = 0.004;
  static const double kErrorThresholdMin = 0.02;
  static const double kErrorThresholdMax = 0.075;

  const LearningModelState({
    required this.modelVersion,
    required this.lastUpdated,
    this.trainingEpochs = 0,
    this.crashThresholdWarning = 0.003,
    this.errorThresholdWarning = 0.05,
    this.featureWeights = const {},
    this.patterns = const [],
    this.accuracy = 0.0,
    this.correctPredictions = 0,
    this.totalPredictions = 0,
  });

  factory LearningModelState.fromJson(Map<String, dynamic> json) {
    return LearningModelState(
      modelVersion: json['model_version'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      trainingEpochs: json['training_epochs'] as int? ?? 0,
      crashThresholdWarning:
          (json['crash_threshold_warning'] as num?)?.toDouble() ?? 0.003,
      errorThresholdWarning:
          (json['error_threshold_warning'] as num?)?.toDouble() ?? 0.05,
      featureWeights: Map<String, double>.from(
        (json['feature_weights'] as Map?)?.map(
              (k, v) => MapEntry(k as String, (v as num).toDouble()),
            ) ??
            {},
      ),
      patterns:
          (json['patterns'] as List?)
              ?.map((p) => LearnedPattern.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      correctPredictions: json['correct_predictions'] as int? ?? 0,
      totalPredictions: json['total_predictions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_version': modelVersion,
      'last_updated': lastUpdated.toIso8601String(),
      'training_epochs': trainingEpochs,
      'crash_threshold_warning': crashThresholdWarning,
      'error_threshold_warning': errorThresholdWarning,
      'feature_weights': featureWeights,
      'patterns': patterns.map((p) => p.toJson()).toList(),
      'accuracy': accuracy,
      'correct_predictions': correctPredictions,
      'total_predictions': totalPredictions,
    };
  }

  factory LearningModelState.initial() {
    return LearningModelState(
      modelVersion: 'v1.0.0',
      lastUpdated: DateTime.now(),
      featureWeights: _defaultFeatureWeights,
    );
  }

  static const Map<String, double> _defaultFeatureWeights = {
    'success_rate': 1.0,
    'error_rate': -2.0,
    'crash_rate': -5.0,
    'confidence_score': 1.5,
    'sample_size_normalized': 0.5,
    'hours_in_stage_normalized': 0.3,
    'success_delta': 0.8,
    'error_delta': -1.5,
    'crash_delta': -3.0,
    'success_trend_slope': 0.6,
    'error_trend_slope': -1.2,
    'crash_trend_slope': -2.5,
    'success_volatility': -0.3,
    'error_volatility': -0.5,
    'crash_volatility': -1.0,
  };

  LearningModelState copyWith({
    String? modelVersion,
    DateTime? lastUpdated,
    int? trainingEpochs,
    double? crashThresholdWarning,
    double? errorThresholdWarning,
    Map<String, double>? featureWeights,
    List<LearnedPattern>? patterns,
    double? accuracy,
    int? correctPredictions,
    int? totalPredictions,
  }) {
    final newCrashThreshold =
        crashThresholdWarning ?? this.crashThresholdWarning;
    final newErrorThreshold =
        errorThresholdWarning ?? this.errorThresholdWarning;

    return LearningModelState(
      modelVersion: modelVersion ?? this.modelVersion,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      trainingEpochs: trainingEpochs ?? this.trainingEpochs,
      crashThresholdWarning: newCrashThreshold.clamp(
        kCrashThresholdMin,
        kCrashThresholdMax,
      ),
      errorThresholdWarning: newErrorThreshold.clamp(
        kErrorThresholdMin,
        kErrorThresholdMax,
      ),
      featureWeights: featureWeights ?? this.featureWeights,
      patterns: patterns ?? this.patterns,
      accuracy: accuracy ?? this.accuracy,
      correctPredictions: correctPredictions ?? this.correctPredictions,
      totalPredictions: totalPredictions ?? this.totalPredictions,
    );
  }

  String get nextVersion {
    final parts = modelVersion.replaceAll('v', '').split('.');
    if (parts.length == 3) {
      final patch = int.tryParse(parts[2]) ?? 0;
      return 'v${parts[0]}.${parts[1]}.${patch + 1}';
    }
    return 'v1.0.${trainingEpochs + 1}';
  }
}

/// Experiment outcome for learning feedback
class ExperimentOutcome {
  final String id;
  final String experimentId;
  final bool wasSuccessful;
  final String variantCode;
  final List<AgentRecommendation> recommendations;
  final Map<String, dynamic> metricSummary;
  final DateTime recordedAt;

  const ExperimentOutcome({
    required this.id,
    required this.experimentId,
    required this.wasSuccessful,
    required this.variantCode,
    this.recommendations = const [],
    this.metricSummary = const {},
    required this.recordedAt,
  });

  factory ExperimentOutcome.fromJson(Map<String, dynamic> json) {
    return ExperimentOutcome(
      id: json['id'] as String,
      experimentId: json['experiment_id'] as String,
      wasSuccessful: json['was_successful'] as bool,
      variantCode: json['variant_code'] as String,
      recommendations:
          (json['recommendations'] as List?)
              ?.map(
                (r) => AgentRecommendation.fromJson(r as Map<String, dynamic>),
              )
              .toList() ??
          [],
      metricSummary: Map<String, dynamic>.from(
        json['metric_summary'] as Map? ?? {},
      ),
      recordedAt: DateTime.parse(json['recorded_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experiment_id': experimentId,
      'was_successful': wasSuccessful,
      'variant_code': variantCode,
      'recommendations': recommendations.map((r) => r.toJson()).toList(),
      'metric_summary': metricSummary,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}

/// Extracted features from metric history
class ExtractedFeatures {
  final double successRate;
  final double errorRate;
  final double crashRate;
  final double confidenceScore;
  final double rolloutPercentage;
  final int sampleSize;
  final int hoursInStage;
  final double successDelta;
  final double errorDelta;
  final double crashDelta;
  final double successTrendSlope;
  final double errorTrendSlope;
  final double crashTrendSlope;
  final double successVolatility;
  final double errorVolatility;
  final double crashVolatility;
  final double sampleGrowthRate;
  final double confidenceGrowthRate;
  final bool isStabilizing;
  final bool hasCriticalAnomaly;
  final List<String> earlyWarningSignals;

  const ExtractedFeatures({
    required this.successRate,
    required this.errorRate,
    required this.crashRate,
    required this.confidenceScore,
    required this.rolloutPercentage,
    required this.sampleSize,
    required this.hoursInStage,
    this.successDelta = 0.0,
    this.errorDelta = 0.0,
    this.crashDelta = 0.0,
    this.successTrendSlope = 0.0,
    this.errorTrendSlope = 0.0,
    this.crashTrendSlope = 0.0,
    this.successVolatility = 0.0,
    this.errorVolatility = 0.0,
    this.crashVolatility = 0.0,
    this.sampleGrowthRate = 0.0,
    this.confidenceGrowthRate = 0.0,
    this.isStabilizing = false,
    this.hasCriticalAnomaly = false,
    this.earlyWarningSignals = const [],
  });

  Map<String, double> toMap() {
    return {
      'success_rate': successRate,
      'error_rate': errorRate,
      'crash_rate': crashRate,
      'confidence_score': confidenceScore,
      'rollout_percentage': rolloutPercentage / 100.0,
      'sample_size_normalized': math.min(sampleSize / 1000.0, 1.0),
      'hours_in_stage_normalized': math.min(hoursInStage / 72.0, 1.0),
      'success_delta': successDelta,
      'error_delta': errorDelta,
      'crash_delta': crashDelta,
      'success_trend_slope': successTrendSlope,
      'error_trend_slope': errorTrendSlope,
      'crash_trend_slope': crashTrendSlope,
      'success_volatility': successVolatility,
      'error_volatility': errorVolatility,
      'crash_volatility': crashVolatility,
      'sample_growth_rate': sampleGrowthRate,
      'confidence_growth_rate': confidenceGrowthRate,
      'is_stabilizing': isStabilizing ? 1.0 : 0.0,
      'has_critical_anomaly': hasCriticalAnomaly ? 1.0 : 0.0,
    };
  }

  factory ExtractedFeatures.fromJson(Map<String, dynamic> json) {
    return ExtractedFeatures(
      successRate: (json['success_rate'] as num).toDouble(),
      errorRate: (json['error_rate'] as num).toDouble(),
      crashRate: (json['crash_rate'] as num).toDouble(),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      rolloutPercentage: (json['rollout_percentage'] as num).toDouble(),
      sampleSize: json['sample_size'] as int,
      hoursInStage: json['hours_in_stage'] as int,
      successDelta: (json['success_delta'] as num?)?.toDouble() ?? 0.0,
      errorDelta: (json['error_delta'] as num?)?.toDouble() ?? 0.0,
      crashDelta: (json['crash_delta'] as num?)?.toDouble() ?? 0.0,
      successTrendSlope:
          (json['success_trend_slope'] as num?)?.toDouble() ?? 0.0,
      errorTrendSlope: (json['error_trend_slope'] as num?)?.toDouble() ?? 0.0,
      crashTrendSlope: (json['crash_trend_slope'] as num?)?.toDouble() ?? 0.0,
      successVolatility:
          (json['success_volatility'] as num?)?.toDouble() ?? 0.0,
      errorVolatility: (json['error_volatility'] as num?)?.toDouble() ?? 0.0,
      crashVolatility: (json['crash_volatility'] as num?)?.toDouble() ?? 0.0,
      sampleGrowthRate: (json['sample_growth_rate'] as num?)?.toDouble() ?? 0.0,
      confidenceGrowthRate:
          (json['confidence_growth_rate'] as num?)?.toDouble() ?? 0.0,
      isStabilizing: json['is_stabilizing'] as bool? ?? false,
      hasCriticalAnomaly: json['has_critical_anomaly'] as bool? ?? false,
      earlyWarningSignals: List<String>.from(
        json['early_warning_signals'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success_rate': successRate,
      'error_rate': errorRate,
      'crash_rate': crashRate,
      'confidence_score': confidenceScore,
      'rollout_percentage': rolloutPercentage,
      'sample_size': sampleSize,
      'hours_in_stage': hoursInStage,
      'success_delta': successDelta,
      'error_delta': errorDelta,
      'crash_delta': crashDelta,
      'success_trend_slope': successTrendSlope,
      'error_trend_slope': errorTrendSlope,
      'crash_trend_slope': crashTrendSlope,
      'success_volatility': successVolatility,
      'error_volatility': errorVolatility,
      'crash_volatility': crashVolatility,
      'sample_growth_rate': sampleGrowthRate,
      'confidence_growth_rate': confidenceGrowthRate,
      'is_stabilizing': isStabilizing,
      'has_critical_anomaly': hasCriticalAnomaly,
      'early_warning_signals': earlyWarningSignals,
    };
  }
}
