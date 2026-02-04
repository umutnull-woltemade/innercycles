// ML-Assisted Experimentation System - ML Rollout Predictor
// Logistic regression inference for rollout risk prediction
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../models/rollout_decision.dart';

/// ML Rollout Predictor using Logistic Regression
/// Provides risk assessment and optimal step size suggestions
class MLRolloutPredictor {
  MLRolloutModel? _activeModel;
  bool _shadowMode;

  MLRolloutPredictor({
    MLRolloutModel? initialModel,
    bool shadowMode = true,
  })  : _activeModel = initialModel,
        _shadowMode = shadowMode;

  /// Whether predictor is in shadow mode (log only, don't influence decisions)
  bool get isShadowMode => _shadowMode;

  /// Set shadow mode
  set shadowMode(bool value) {
    _shadowMode = value;
    debugPrint('[MLPredictor] Shadow mode: $value');
  }

  /// Get active model info
  String? get activeModelVersion => _activeModel?.version;

  /// Load model from storage or API
  void loadModel(MLRolloutModel model) {
    if (!model.meetsQualityThreshold) {
      debugPrint(
        '[MLPredictor] Model ${model.version} does not meet quality threshold '
        '(F1: ${model.f1Score?.toStringAsFixed(2) ?? "N/A"} < 0.6)',
      );
      return;
    }

    _activeModel = model;
    debugPrint(
      '[MLPredictor] Loaded model ${model.version} '
      '(F1: ${model.f1Score?.toStringAsFixed(2)}, samples: ${model.trainingSamples})',
    );
  }

  /// Predict risk and get recommendation
  Future<MLPrediction> predict(RolloutContext context) async {
    final snapshot = context.trainingSnapshot;

    if (_activeModel == null || snapshot == null) {
      return _getDefaultPrediction();
    }

    try {
      // Extract features
      final features = snapshot.toFeatureVector();

      // Predict risk probability
      final riskProbability = _activeModel!.predict(features);

      // Get feature contributions for explainability
      final contributions = _activeModel!.getFeatureContributions(features);

      // Calculate suggested step size based on risk
      final suggestedDelta = _calculateSuggestedDelta(riskProbability);

      // Calculate confidence for next stage
      final confidenceNext = _calculateConfidenceNext(
        riskProbability,
        snapshot,
      );

      // Build natural language explanation
      final explanation = _buildNaturalLanguageExplanation(
        riskProbability: riskProbability,
        suggestedDelta: suggestedDelta,
        confidenceNext: confidenceNext,
        topContributors: contributions.take(5).toList(),
        snapshot: snapshot,
      );

      final prediction = MLPrediction(
        riskProbability: riskProbability,
        suggestedDelta: suggestedDelta,
        confidenceNextStage: confidenceNext,
        topContributors: contributions.take(5).toList(),
        naturalLanguageExplanation: explanation,
        modelVersion: _activeModel!.version,
        predictedAt: DateTime.now(),
      );

      if (_shadowMode) {
        debugPrint(
          '[MLPredictor] SHADOW: risk=${riskProbability.toStringAsFixed(2)}, '
          'delta=$suggestedDelta, confidence=${confidenceNext.toStringAsFixed(2)}',
        );
      }

      return prediction;
    } catch (e) {
      debugPrint('[MLPredictor] Prediction error: $e');
      return _getDefaultPrediction();
    }
  }

  /// Get default prediction when model unavailable
  MLPrediction _getDefaultPrediction() {
    return MLPrediction(
      riskProbability: 0.5, // Neutral risk
      suggestedDelta: 0, // No advancement
      confidenceNextStage: 0.5, // Neutral confidence
      topContributors: [],
      naturalLanguageExplanation:
          'No ML model available. Using conservative defaults.',
      modelVersion: 'none',
      predictedAt: DateTime.now(),
    );
  }

  /// Calculate suggested rollout step size based on risk
  int _calculateSuggestedDelta(double riskProbability) {
    // Risk-based step sizing
    // Lower risk → larger steps allowed
    // Higher risk → smaller steps or hold

    if (riskProbability > 0.5) return 0; // High risk - no advancement
    if (riskProbability > 0.4) return 5; // Moderate-high risk - minimal step
    if (riskProbability > 0.3) return 10; // Moderate risk - small step
    if (riskProbability > 0.2) return 15; // Low-moderate risk - medium step
    if (riskProbability > 0.1) return 20; // Low risk - larger step
    return 25; // Very low risk - maximum step
  }

  /// Calculate confidence for next stage
  double _calculateConfidenceNext(
    double riskProbability,
    RolloutTrainingSnapshot snapshot,
  ) {
    // Base confidence from inverse risk
    double confidence = 1.0 - riskProbability;

    // Adjust based on current metrics
    // Higher D1 retention boosts confidence
    if (snapshot.retentionD1Exposed > 0.7) {
      confidence *= 1.1;
    } else if (snapshot.retentionD1Exposed < 0.5) {
      confidence *= 0.9;
    }

    // Higher conversion rate boosts confidence
    if (snapshot.conversionRateExposed > 0.1) {
      confidence *= 1.05;
    }

    // Negative crash delta boosts confidence
    if (snapshot.crashRateDelta24h < 0) {
      confidence *= 1.05;
    } else if (snapshot.crashRateDelta24h > 0.001) {
      confidence *= 0.9;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Build natural language explanation
  String _buildNaturalLanguageExplanation({
    required double riskProbability,
    required int suggestedDelta,
    required double confidenceNext,
    required List<FeatureContribution> topContributors,
    required RolloutTrainingSnapshot snapshot,
  }) {
    final buffer = StringBuffer();

    // Action recommendation
    if (riskProbability > 0.5) {
      buffer.write('ROLLBACK recommended: ');
    } else if (riskProbability > 0.3) {
      buffer.write('HOLD recommended: ');
    } else {
      buffer.write('ADVANCE recommended: ');
    }

    // Risk assessment
    final riskPercent = (riskProbability * 100).toStringAsFixed(0);
    buffer.write('Risk probability $riskPercent%. ');

    // Key metrics
    if (snapshot.crashRateDelta24h > 0.001) {
      buffer.write(
        'Elevated crash rate (+${(snapshot.crashRateDelta24h * 100).toStringAsFixed(2)}%). ',
      );
    }

    if (snapshot.churnRateExposedVsControl > 0.02) {
      buffer.write(
        'Higher churn in exposed group (+${(snapshot.churnRateExposedVsControl * 100).toStringAsFixed(1)}%). ',
      );
    }

    if (snapshot.retentionD1Exposed > 0.7) {
      buffer.write(
        'D1 retention is healthy at ${(snapshot.retentionD1Exposed * 100).toStringAsFixed(0)}%. ',
      );
    }

    // Top contributing factors
    if (topContributors.isNotEmpty) {
      final factors = topContributors
          .take(3)
          .map((c) {
            final name = c.featureName.replaceAll('_', ' ');
            final direction = c.direction == 'positive' ? 'increasing' : 'decreasing';
            return '$name ($direction risk)';
          })
          .join(', ');
      buffer.write('Key factors: $factors.');
    }

    return buffer.toString();
  }

  /// Train model from historical data (called by Edge Function)
  /// This is a placeholder - actual training happens in Edge Function
  static MLRolloutModel trainModel({
    required List<RolloutTrainingSnapshot> trainingData,
    required String version,
  }) {
    if (trainingData.length < 100) {
      throw ArgumentError('Insufficient training data: ${trainingData.length} < 100 required');
    }

    // Extract features and labels
    final features = <List<double>>[];
    final labels = <bool>[];

    for (final snapshot in trainingData) {
      features.add(snapshot.toFeatureVector());
      labels.add(snapshot.hadIncidentWithin24h);
    }

    // Train logistic regression
    final weights = _trainLogisticRegression(
      features: features,
      labels: labels,
      learningRate: 0.01,
      iterations: 1000,
    );

    // Calculate feature importance
    final featureImportance = <String, double>{};
    for (var i = 0; i < RolloutTrainingSnapshot.featureNames.length; i++) {
      final name = RolloutTrainingSnapshot.featureNames[i];
      featureImportance[name] = weights[name]?.abs() ?? 0.0;
    }

    // Normalize importance
    final total = featureImportance.values.reduce((a, b) => a + b);
    if (total > 0) {
      for (final key in featureImportance.keys.toList()) {
        featureImportance[key] = featureImportance[key]! / total;
      }
    }

    // Calculate metrics on holdout (simplified)
    final predictions = <bool>[];
    for (final f in features) {
      double z = weights['bias'] ?? 0.0;
      for (var i = 0; i < f.length; i++) {
        z += (weights[RolloutTrainingSnapshot.featureNames[i]] ?? 0.0) * f[i];
      }
      predictions.add(1.0 / (1.0 + math.exp(-z)) > 0.5);
    }

    int tp = 0, fp = 0, fn = 0;
    for (var i = 0; i < labels.length; i++) {
      if (predictions[i] && labels[i]) tp++;
      if (predictions[i] && !labels[i]) fp++;
      if (!predictions[i] && labels[i]) fn++;
    }

    final precision = tp > 0 ? tp / (tp + fp) : 0.0;
    final recall = tp > 0 ? tp / (tp + fn) : 0.0;
    final f1 = precision + recall > 0
        ? 2 * precision * recall / (precision + recall)
        : 0.0;

    return MLRolloutModel(
      id: 'model_${DateTime.now().millisecondsSinceEpoch}',
      version: version,
      weights: weights,
      featureNames: RolloutTrainingSnapshot.featureNames,
      featureImportance: featureImportance,
      trainingSamples: trainingData.length,
      f1Score: f1,
      precisionScore: precision,
      recallScore: recall,
      createdAt: DateTime.now(),
    );
  }

  /// Simple logistic regression training
  static Map<String, double> _trainLogisticRegression({
    required List<List<double>> features,
    required List<bool> labels,
    required double learningRate,
    required int iterations,
  }) {
    final n = features.length;
    final m = features.first.length;

    // Initialize weights
    final weights = <String, double>{'bias': 0.0};
    for (final name in RolloutTrainingSnapshot.featureNames) {
      weights[name] = 0.0;
    }

    // Gradient descent
    for (var iter = 0; iter < iterations; iter++) {
      final gradients = <String, double>{'bias': 0.0};
      for (final name in RolloutTrainingSnapshot.featureNames) {
        gradients[name] = 0.0;
      }

      for (var i = 0; i < n; i++) {
        // Compute prediction
        double z = weights['bias']!;
        for (var j = 0; j < m; j++) {
          z += weights[RolloutTrainingSnapshot.featureNames[j]]! * features[i][j];
        }
        final prediction = 1.0 / (1.0 + math.exp(-z.clamp(-500, 500)));

        // Compute error
        final error = prediction - (labels[i] ? 1.0 : 0.0);

        // Accumulate gradients
        gradients['bias'] = gradients['bias']! + error;
        for (var j = 0; j < m; j++) {
          final name = RolloutTrainingSnapshot.featureNames[j];
          gradients[name] = gradients[name]! + error * features[i][j];
        }
      }

      // Update weights
      weights['bias'] = weights['bias']! - learningRate * gradients['bias']! / n;
      for (final name in RolloutTrainingSnapshot.featureNames) {
        weights[name] = weights[name]! - learningRate * gradients[name]! / n;
      }
    }

    return weights;
  }
}

// RolloutContext is now defined in rollout_decision.dart
