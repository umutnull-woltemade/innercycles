// ML-Assisted Experimentation System - Rollout Decision Models
// Part of the ML Rollout Policy (Hybrid)

/// Rollout action types
enum RolloutAction { hold, advance, rollback, freeze, unfreeze }

/// Decision source types (hierarchy levels)
enum DecisionSource {
  /// Level 1: Hard guards (cannot be overridden by ML)
  ruleHardGuard('rule_hard_guard', 1),

  /// Level 1: Churn defense triggered
  ruleChurnDefense('rule_churn_defense', 1),

  /// Level 2: ML risk gate blocked advancement
  mlRiskGate('ml_risk_gate', 2),

  /// Level 3: ML acceleration approved advancement
  mlAcceleration('ml_acceleration', 3),

  /// Manual override by admin
  manualOverride('manual_override', 0),

  /// Safety rollback (crash/error spike)
  safetyRollback('safety_rollback', 1);

  const DecisionSource(this.dbValue, this.level);
  final String dbValue;
  final int level;

  static DecisionSource fromDbValue(String value) {
    return DecisionSource.values.firstWhere(
      (e) => e.dbValue == value,
      orElse: () => DecisionSource.ruleHardGuard,
    );
  }
}

/// Incident severity levels
enum IncidentSeverity { low, medium, high, critical }

/// Feature contribution for explainability
class FeatureContribution {
  final String featureName;
  final double featureValue;
  final double contribution;
  final String direction; // 'positive', 'negative', 'neutral'

  const FeatureContribution({
    required this.featureName,
    required this.featureValue,
    required this.contribution,
    required this.direction,
  });

  factory FeatureContribution.fromJson(Map<String, dynamic> json) {
    return FeatureContribution(
      featureName: json['feature_name'] as String,
      featureValue: (json['feature_value'] as num).toDouble(),
      contribution: (json['contribution'] as num).toDouble(),
      direction: json['direction'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feature_name': featureName,
      'feature_value': featureValue,
      'contribution': contribution,
      'direction': direction,
    };
  }
}

/// ML prediction with explainability
class MLPrediction {
  final double riskProbability;
  final int suggestedDelta;
  final double confidenceNextStage;
  final List<FeatureContribution> topContributors;
  final String naturalLanguageExplanation;
  final String modelVersion;
  final DateTime predictedAt;

  const MLPrediction({
    required this.riskProbability,
    required this.suggestedDelta,
    required this.confidenceNextStage,
    this.topContributors = const [],
    required this.naturalLanguageExplanation,
    required this.modelVersion,
    required this.predictedAt,
  });

  factory MLPrediction.fromJson(Map<String, dynamic> json) {
    return MLPrediction(
      riskProbability: (json['risk_probability'] as num).toDouble(),
      suggestedDelta: json['suggested_delta'] as int,
      confidenceNextStage: (json['confidence_next_stage'] as num).toDouble(),
      topContributors:
          (json['top_contributors'] as List?)
              ?.map(
                (c) => FeatureContribution.fromJson(c as Map<String, dynamic>),
              )
              .toList() ??
          [],
      naturalLanguageExplanation:
          json['natural_language_explanation'] as String,
      modelVersion: json['model_version'] as String,
      predictedAt: DateTime.parse(json['predicted_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk_probability': riskProbability,
      'suggested_delta': suggestedDelta,
      'confidence_next_stage': confidenceNextStage,
      'top_contributors': topContributors.map((c) => c.toJson()).toList(),
      'natural_language_explanation': naturalLanguageExplanation,
      'model_version': modelVersion,
      'predicted_at': predictedAt.toIso8601String(),
    };
  }

  /// Check if risk is acceptable for advancement
  bool get isRiskAcceptable => riskProbability <= 0.3;

  /// Check if risk requires hold
  bool get requiresHold => riskProbability > 0.3 && riskProbability <= 0.5;

  /// Check if risk requires rollback
  bool get requiresRollback => riskProbability > 0.5;
}

/// Rollout decision record
class RolloutDecision {
  final String id;
  final String flagName;
  final RolloutAction action;
  final int? previousPercentage;
  final int? newPercentage;

  // Decision metadata
  final DecisionSource decisionSource;
  final int decisionLevel;

  // ML details (if applicable)
  final double? mlRiskProbability;
  final int? mlSuggestedDelta;
  final double? mlConfidenceNext;
  final bool mlOverridden;
  final String? overrideReason;

  // Explainability
  final String? explanation;
  final List<FeatureContribution> topContributors;

  final DateTime createdAt;

  const RolloutDecision({
    required this.id,
    required this.flagName,
    required this.action,
    this.previousPercentage,
    this.newPercentage,
    required this.decisionSource,
    required this.decisionLevel,
    this.mlRiskProbability,
    this.mlSuggestedDelta,
    this.mlConfidenceNext,
    this.mlOverridden = false,
    this.overrideReason,
    this.explanation,
    this.topContributors = const [],
    required this.createdAt,
  });

  factory RolloutDecision.fromJson(Map<String, dynamic> json) {
    return RolloutDecision(
      id: json['id'] as String,
      flagName: json['flag_name'] as String,
      action: RolloutAction.values.firstWhere(
        (e) => e.name == json['action'],
        orElse: () => RolloutAction.hold,
      ),
      previousPercentage: json['previous_percentage'] as int?,
      newPercentage: json['new_percentage'] as int?,
      decisionSource: DecisionSource.fromDbValue(
        json['decision_source'] as String,
      ),
      decisionLevel: json['decision_level'] as int? ?? 1,
      mlRiskProbability: (json['ml_risk_probability'] as num?)?.toDouble(),
      mlSuggestedDelta: json['ml_suggested_delta'] as int?,
      mlConfidenceNext: (json['ml_confidence_next'] as num?)?.toDouble(),
      mlOverridden: json['ml_overridden'] as bool? ?? false,
      overrideReason: json['override_reason'] as String?,
      explanation: json['explanation'] as String?,
      topContributors:
          (json['top_contributors'] as List?)
              ?.map(
                (c) => FeatureContribution.fromJson(c as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flag_name': flagName,
      'action': action.name,
      if (previousPercentage != null) 'previous_percentage': previousPercentage,
      if (newPercentage != null) 'new_percentage': newPercentage,
      'decision_source': decisionSource.dbValue,
      'decision_level': decisionLevel,
      if (mlRiskProbability != null) 'ml_risk_probability': mlRiskProbability,
      if (mlSuggestedDelta != null) 'ml_suggested_delta': mlSuggestedDelta,
      if (mlConfidenceNext != null) 'ml_confidence_next': mlConfidenceNext,
      'ml_overridden': mlOverridden,
      if (overrideReason != null) 'override_reason': overrideReason,
      if (explanation != null) 'explanation': explanation,
      'top_contributors': topContributors.map((c) => c.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Check if this was an ML-driven decision
  bool get isMLDriven =>
      decisionSource == DecisionSource.mlRiskGate ||
      decisionSource == DecisionSource.mlAcceleration;

  /// Check if this was a safety-driven decision
  bool get isSafetyDriven =>
      decisionSource == DecisionSource.ruleHardGuard ||
      decisionSource == DecisionSource.ruleChurnDefense ||
      decisionSource == DecisionSource.safetyRollback;
}

/// Rollout training data snapshot
class RolloutTrainingSnapshot {
  final String id;
  final String flagName;
  final DateTime snapshotTimestamp;

  // Rollout context features
  final int currentRolloutPercentage;
  final int timeSinceLastStepHours;
  final int totalExposedUsers;

  // Health metrics
  final double crashRateDelta24h;
  final double errorRateDelta24h;
  final double churnRateExposedVsControl;

  // Success signals
  final double conversionRateExposed;
  final double engagementDeltaExposed;
  final double retentionD1Exposed;

  // Platform distribution
  final double platformIosRatio;
  final double platformAndroidRatio;

  // Outcome (for training)
  final bool hadIncidentWithin24h;
  final String? incidentType;
  final IncidentSeverity? incidentSeverity;

  const RolloutTrainingSnapshot({
    required this.id,
    required this.flagName,
    required this.snapshotTimestamp,
    required this.currentRolloutPercentage,
    required this.timeSinceLastStepHours,
    required this.totalExposedUsers,
    required this.crashRateDelta24h,
    required this.errorRateDelta24h,
    required this.churnRateExposedVsControl,
    required this.conversionRateExposed,
    required this.engagementDeltaExposed,
    required this.retentionD1Exposed,
    required this.platformIosRatio,
    required this.platformAndroidRatio,
    this.hadIncidentWithin24h = false,
    this.incidentType,
    this.incidentSeverity,
  });

  factory RolloutTrainingSnapshot.fromJson(Map<String, dynamic> json) {
    return RolloutTrainingSnapshot(
      id: json['id'] as String,
      flagName: json['flag_name'] as String,
      snapshotTimestamp: DateTime.parse(json['snapshot_timestamp'] as String),
      currentRolloutPercentage: json['current_rollout_percentage'] as int,
      timeSinceLastStepHours: json['time_since_last_step_hours'] as int,
      totalExposedUsers: json['total_exposed_users'] as int,
      crashRateDelta24h: (json['crash_rate_delta_24h'] as num).toDouble(),
      errorRateDelta24h: (json['error_rate_delta_24h'] as num).toDouble(),
      churnRateExposedVsControl: (json['churn_rate_exposed_vs_control'] as num)
          .toDouble(),
      conversionRateExposed: (json['conversion_rate_exposed'] as num)
          .toDouble(),
      engagementDeltaExposed: (json['engagement_delta_exposed'] as num)
          .toDouble(),
      retentionD1Exposed: (json['retention_d1_exposed'] as num).toDouble(),
      platformIosRatio: (json['platform_ios_ratio'] as num).toDouble(),
      platformAndroidRatio: (json['platform_android_ratio'] as num).toDouble(),
      hadIncidentWithin24h: json['had_incident_within_24h'] as bool? ?? false,
      incidentType: json['incident_type'] as String?,
      incidentSeverity: json['incident_severity'] != null
          ? IncidentSeverity.values.firstWhere(
              (e) => e.name == json['incident_severity'],
              orElse: () => IncidentSeverity.low,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flag_name': flagName,
      'snapshot_timestamp': snapshotTimestamp.toIso8601String(),
      'current_rollout_percentage': currentRolloutPercentage,
      'time_since_last_step_hours': timeSinceLastStepHours,
      'total_exposed_users': totalExposedUsers,
      'crash_rate_delta_24h': crashRateDelta24h,
      'error_rate_delta_24h': errorRateDelta24h,
      'churn_rate_exposed_vs_control': churnRateExposedVsControl,
      'conversion_rate_exposed': conversionRateExposed,
      'engagement_delta_exposed': engagementDeltaExposed,
      'retention_d1_exposed': retentionD1Exposed,
      'platform_ios_ratio': platformIosRatio,
      'platform_android_ratio': platformAndroidRatio,
      'had_incident_within_24h': hadIncidentWithin24h,
      if (incidentType != null) 'incident_type': incidentType,
      if (incidentSeverity != null) 'incident_severity': incidentSeverity!.name,
    };
  }

  /// Convert to feature vector for ML prediction
  List<double> toFeatureVector() {
    return [
      currentRolloutPercentage.toDouble(),
      timeSinceLastStepHours.toDouble(),
      totalExposedUsers > 0 ? (totalExposedUsers).toDouble().log() : 0.0,
      crashRateDelta24h,
      errorRateDelta24h,
      churnRateExposedVsControl,
      conversionRateExposed,
      engagementDeltaExposed,
      retentionD1Exposed,
      platformIosRatio,
      platformAndroidRatio,
    ];
  }

  /// Feature names for explainability
  static const List<String> featureNames = [
    'current_rollout_percentage',
    'time_since_last_step_hours',
    'total_exposed_users_log',
    'crash_rate_delta_24h',
    'error_rate_delta_24h',
    'churn_rate_exposed_vs_control',
    'conversion_rate_exposed',
    'engagement_delta_exposed',
    'retention_d1_exposed',
    'platform_ios_ratio',
    'platform_android_ratio',
  ];
}

/// ML rollout model metadata
class MLRolloutModel {
  final String id;
  final String version;
  final String modelType;
  final Map<String, double> weights;
  final List<String> featureNames;
  final Map<String, double> featureImportance;
  final int trainingSamples;

  // Model metrics
  final double? f1Score;
  final double? precisionScore;
  final double? recallScore;
  final double? aucRoc;

  // Status
  final String status;
  final bool isActive;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime createdAt;

  const MLRolloutModel({
    required this.id,
    required this.version,
    this.modelType = 'logistic_regression',
    required this.weights,
    required this.featureNames,
    this.featureImportance = const {},
    this.trainingSamples = 0,
    this.f1Score,
    this.precisionScore,
    this.recallScore,
    this.aucRoc,
    this.status = 'trained',
    this.isActive = false,
    this.approvedBy,
    this.approvedAt,
    required this.createdAt,
  });

  factory MLRolloutModel.fromJson(Map<String, dynamic> json) {
    return MLRolloutModel(
      id: json['id'] as String,
      version: json['version'] as String,
      modelType: json['model_type'] as String? ?? 'logistic_regression',
      weights: Map<String, double>.from(
        (json['weights'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      ),
      featureNames: List<String>.from(json['feature_names']),
      featureImportance: Map<String, double>.from(
        (json['feature_importance'] as Map?)?.map(
              (k, v) => MapEntry(k as String, (v as num).toDouble()),
            ) ??
            {},
      ),
      trainingSamples: json['training_samples'] as int? ?? 0,
      f1Score: (json['f1_score'] as num?)?.toDouble(),
      precisionScore: (json['precision_score'] as num?)?.toDouble(),
      recallScore: (json['recall_score'] as num?)?.toDouble(),
      aucRoc: (json['auc_roc'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'trained',
      isActive: json['is_active'] as bool? ?? false,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'model_type': modelType,
      'weights': weights,
      'feature_names': featureNames,
      'feature_importance': featureImportance,
      'training_samples': trainingSamples,
      if (f1Score != null) 'f1_score': f1Score,
      if (precisionScore != null) 'precision_score': precisionScore,
      if (recallScore != null) 'recall_score': recallScore,
      if (aucRoc != null) 'auc_roc': aucRoc,
      'status': status,
      'is_active': isActive,
      if (approvedBy != null) 'approved_by': approvedBy,
      if (approvedAt != null) 'approved_at': approvedAt!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Check if model meets minimum quality threshold
  bool get meetsQualityThreshold => (f1Score ?? 0) >= 0.6;

  /// Predict risk probability using logistic regression
  double predict(List<double> features) {
    if (features.length != featureNames.length) {
      throw ArgumentError(
        'Feature count mismatch: expected ${featureNames.length}, got ${features.length}',
      );
    }

    // Compute weighted sum (logistic regression)
    double z = weights['bias'] ?? 0.0;
    for (var i = 0; i < features.length; i++) {
      final featureName = featureNames[i];
      final weight = weights[featureName] ?? 0.0;
      z += weight * features[i];
    }

    // Sigmoid function
    return 1.0 / (1.0 + (-z).exp());
  }

  /// Get feature contributions for explainability
  List<FeatureContribution> getFeatureContributions(List<double> features) {
    final contributions = <FeatureContribution>[];

    for (var i = 0; i < features.length; i++) {
      final featureName = featureNames[i];
      final weight = weights[featureName] ?? 0.0;
      final contribution = weight * features[i];

      contributions.add(
        FeatureContribution(
          featureName: featureName,
          featureValue: features[i],
          contribution: contribution.abs(),
          direction: contribution > 0
              ? 'positive'
              : (contribution < 0 ? 'negative' : 'neutral'),
        ),
      );
    }

    // Sort by absolute contribution
    contributions.sort((a, b) => b.contribution.compareTo(a.contribution));
    return contributions;
  }
}

/// Dart extension for log on double
extension DoubleLogExtension on double {
  double log() => this > 0 ? _logImpl(this) : 0.0;
  double exp() => _expImpl(this);
}

// Math implementations
double _logImpl(double x) {
  // Natural log approximation using Taylor series
  if (x <= 0) return double.negativeInfinity;
  if (x == 1) return 0.0;

  // Use identity: ln(x) = 2 * arctanh((x-1)/(x+1))
  // For better convergence, normalize x to [0.5, 1.5]
  int k = 0;
  while (x > 1.5) {
    x /= 2.718281828459045;
    k++;
  }
  while (x < 0.5) {
    x *= 2.718281828459045;
    k--;
  }

  // Taylor series for ln(1+y) where y = x-1
  final y = x - 1;
  double result = 0;
  double term = y;
  for (int n = 1; n <= 50; n++) {
    result += term / n;
    term *= -y;
  }
  return result + k;
}

double _expImpl(double x) {
  if (x > 700) return double.infinity;
  if (x < -700) return 0.0;

  // Taylor series for e^x
  double result = 1.0;
  double term = 1.0;
  for (int n = 1; n <= 50; n++) {
    term *= x / n;
    result += term;
    if (term.abs() < 1e-15) break;
  }
  return result;
}

/// Rollout context for prediction and decision making
class RolloutContext {
  /// Current churn rate
  final double churnRate;

  /// Current crash rate
  final double crashRateCurrent;

  /// Baseline crash rate (for comparison)
  final double crashRateBaseline;

  /// Current error rate
  final double errorRateCurrent;

  /// Baseline error rate (for comparison)
  final double errorRateBaseline;

  /// Training data snapshot for ML prediction
  final RolloutTrainingSnapshot? trainingSnapshot;

  const RolloutContext({
    required this.churnRate,
    required this.crashRateCurrent,
    required this.crashRateBaseline,
    required this.errorRateCurrent,
    required this.errorRateBaseline,
    this.trainingSnapshot,
  });
}
