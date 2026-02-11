// ML-Assisted Experimentation System - Feature Extractor
// Extracts features from experiment metric history for learning agent
import 'dart:math' as math;
import '../models/experiment_metrics.dart';

/// Feature engineering pipeline for experiment metrics
class ExperimentFeatureExtractor {
  /// Minimum samples required for trend calculation
  static const int kMinTrendSamples = 3;

  /// Minimum samples for volatility calculation
  static const int kMinVolatilitySamples = 5;

  /// Anomaly detection threshold (z-score)
  static const double kAnomalyZScoreThreshold = 3.0;

  /// Extract features from metric history
  ExtractedFeatures extract(List<ExperimentMetricSnapshot> history) {
    if (history.isEmpty) {
      return const ExtractedFeatures(
        successRate: 0.0,
        errorRate: 0.0,
        crashRate: 0.0,
        confidenceScore: 0.0,
        rolloutPercentage: 0.0,
        sampleSize: 0,
        hoursInStage: 0,
      );
    }

    // Sort by timestamp
    final sorted = List<ExperimentMetricSnapshot>.from(history)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final current = sorted.last;
    final previous = sorted.length > 1 ? sorted[sorted.length - 2] : null;

    // Current state features
    final successRate = current.successRate;
    final errorRate = current.errorRate;
    final crashRate = current.crashRate;
    final confidenceScore = current.confidenceScore;
    final rolloutPercentage = current.rolloutPercentage;
    final sampleSize = current.sampleSize;
    final hoursInStage = current.hoursInStage;

    // Calculate deltas
    final successDelta = previous != null
        ? current.successRate - previous.successRate
        : 0.0;
    final errorDelta = previous != null
        ? current.errorRate - previous.errorRate
        : 0.0;
    final crashDelta = previous != null
        ? current.crashRate - previous.crashRate
        : 0.0;

    // Calculate trends
    final successTrendSlope = _calculateTrendSlope(
      sorted.map((s) => s.successRate).toList(),
    );
    final errorTrendSlope = _calculateTrendSlope(
      sorted.map((s) => s.errorRate).toList(),
    );
    final crashTrendSlope = _calculateTrendSlope(
      sorted.map((s) => s.crashRate).toList(),
    );

    // Calculate volatility
    final successVolatility = _calculateVolatility(
      sorted.map((s) => s.successRate).toList(),
    );
    final errorVolatility = _calculateVolatility(
      sorted.map((s) => s.errorRate).toList(),
    );
    final crashVolatility = _calculateVolatility(
      sorted.map((s) => s.crashRate).toList(),
    );

    // Calculate growth rates
    final sampleGrowthRate = _calculateGrowthRate(
      sorted.map((s) => s.sampleSize.toDouble()).toList(),
    );
    final confidenceGrowthRate = _calculateGrowthRate(
      sorted.map((s) => s.confidenceScore).toList(),
    );

    // Detect signals
    final isStabilizing = _detectStabilization(sorted);
    final hasCriticalAnomaly = _detectCriticalAnomaly(sorted);
    final earlyWarningSignals = _detectEarlyWarnings(sorted);

    return ExtractedFeatures(
      successRate: successRate,
      errorRate: errorRate,
      crashRate: crashRate,
      confidenceScore: confidenceScore,
      rolloutPercentage: rolloutPercentage,
      sampleSize: sampleSize,
      hoursInStage: hoursInStage,
      successDelta: successDelta,
      errorDelta: errorDelta,
      crashDelta: crashDelta,
      successTrendSlope: successTrendSlope,
      errorTrendSlope: errorTrendSlope,
      crashTrendSlope: crashTrendSlope,
      successVolatility: successVolatility,
      errorVolatility: errorVolatility,
      crashVolatility: crashVolatility,
      sampleGrowthRate: sampleGrowthRate,
      confidenceGrowthRate: confidenceGrowthRate,
      isStabilizing: isStabilizing,
      hasCriticalAnomaly: hasCriticalAnomaly,
      earlyWarningSignals: earlyWarningSignals,
    );
  }

  /// Calculate linear trend slope using least squares regression
  double _calculateTrendSlope(List<double> values) {
    if (values.length < kMinTrendSamples) return 0.0;

    final n = values.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

    for (var i = 0; i < n; i++) {
      sumX += i;
      sumY += values[i];
      sumXY += i * values[i];
      sumX2 += i * i;
    }

    final denominator = n * sumX2 - sumX * sumX;
    if (denominator == 0) return 0.0;

    return (n * sumXY - sumX * sumY) / denominator;
  }

  /// Calculate volatility (standard deviation)
  double _calculateVolatility(List<double> values) {
    if (values.length < kMinVolatilitySamples) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance =
        values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
        values.length;

    return math.sqrt(variance);
  }

  /// Calculate growth rate (percentage change)
  double _calculateGrowthRate(List<double> values) {
    if (values.length < 2) return 0.0;

    final first = values.first;
    final last = values.last;

    if (first == 0) return last > 0 ? 1.0 : 0.0;

    return (last - first) / first;
  }

  /// Detect if metrics are stabilizing
  bool _detectStabilization(List<ExperimentMetricSnapshot> history) {
    if (history.length < kMinVolatilitySamples) return false;

    // Take the last half of samples
    final recentCount = history.length ~/ 2;
    final recent = history.sublist(history.length - recentCount);
    final older = history.sublist(0, recentCount);

    // Compare volatility between periods
    final recentSuccessVol = _calculateVolatility(
      recent.map((s) => s.successRate).toList(),
    );
    final olderSuccessVol = _calculateVolatility(
      older.map((s) => s.successRate).toList(),
    );

    final recentErrorVol = _calculateVolatility(
      recent.map((s) => s.errorRate).toList(),
    );
    final olderErrorVol = _calculateVolatility(
      older.map((s) => s.errorRate).toList(),
    );

    // Stabilizing if recent volatility is lower
    return recentSuccessVol < olderSuccessVol * 0.8 &&
        recentErrorVol < olderErrorVol * 0.8;
  }

  /// Detect critical anomalies using z-score
  bool _detectCriticalAnomaly(List<ExperimentMetricSnapshot> history) {
    if (history.length < kMinVolatilitySamples) return false;

    final current = history.last;

    // Calculate z-scores for error and crash rates
    final errorValues = history.map((s) => s.errorRate).toList();
    final crashValues = history.map((s) => s.crashRate).toList();

    final errorZScore = _calculateZScore(current.errorRate, errorValues);
    final crashZScore = _calculateZScore(current.crashRate, crashValues);

    return errorZScore > kAnomalyZScoreThreshold ||
        crashZScore > kAnomalyZScoreThreshold;
  }

  /// Calculate z-score for a value
  double _calculateZScore(double value, List<double> population) {
    if (population.length < 2) return 0.0;

    final mean = population.reduce((a, b) => a + b) / population.length;
    final stdDev = _calculateVolatility(population);

    if (stdDev == 0) return 0.0;

    return (value - mean) / stdDev;
  }

  /// Detect early warning signals
  List<String> _detectEarlyWarnings(List<ExperimentMetricSnapshot> history) {
    final warnings = <String>[];

    if (history.length < 2) return warnings;

    final current = history.last;
    final previous = history[history.length - 2];

    // Error rate increasing rapidly
    final errorDelta = current.errorRate - previous.errorRate;
    if (errorDelta > 0.02) {
      warnings.add(
        'Error rate increased by ${(errorDelta * 100).toStringAsFixed(1)}%',
      );
    }

    // Crash rate spike
    final crashDelta = current.crashRate - previous.crashRate;
    if (crashDelta > 0.005) {
      warnings.add(
        'Crash rate spiked by ${(crashDelta * 100).toStringAsFixed(2)}%',
      );
    }

    // Success rate declining
    final successDelta = current.successRate - previous.successRate;
    if (successDelta < -0.05) {
      warnings.add(
        'Success rate declined by ${(successDelta.abs() * 100).toStringAsFixed(1)}%',
      );
    }

    // Confidence dropping
    final confidenceDelta = current.confidenceScore - previous.confidenceScore;
    if (confidenceDelta < -0.1) {
      warnings.add(
        'Confidence score dropped by ${(confidenceDelta.abs() * 100).toStringAsFixed(0)}%',
      );
    }

    // Sample growth stalling
    if (history.length >= 3) {
      final recentSamples = history
          .sublist(history.length - 3)
          .map((s) => s.sampleSize)
          .toList();
      final sampleGrowth = _calculateGrowthRate(
        recentSamples.map((s) => s.toDouble()).toList(),
      );
      if (sampleGrowth < 0.1 && current.sampleSize < 500) {
        warnings.add('Sample growth stalled at ${current.sampleSize}');
      }
    }

    // High volatility in error rates
    if (history.length >= kMinVolatilitySamples) {
      final errorVolatility = _calculateVolatility(
        history.map((s) => s.errorRate).toList(),
      );
      if (errorVolatility > 0.03) {
        warnings.add('High error rate volatility detected');
      }
    }

    return warnings;
  }

  /// Extract features for a specific stage transition
  ExtractedFeatures extractForStageTransition({
    required List<ExperimentMetricSnapshot> beforeStage,
    required List<ExperimentMetricSnapshot> afterStage,
  }) {
    if (afterStage.isEmpty) {
      return extract(beforeStage);
    }

    final combined = [...beforeStage, ...afterStage];
    final baseFeatures = extract(combined);

    // Calculate stage-specific deltas
    final beforeLast = beforeStage.isNotEmpty ? beforeStage.last : null;
    final afterFirst = afterStage.first;

    final transitionSuccessDelta = beforeLast != null
        ? afterFirst.successRate - beforeLast.successRate
        : 0.0;
    final transitionErrorDelta = beforeLast != null
        ? afterFirst.errorRate - beforeLast.errorRate
        : 0.0;
    final transitionCrashDelta = beforeLast != null
        ? afterFirst.crashRate - beforeLast.crashRate
        : 0.0;

    return ExtractedFeatures(
      successRate: baseFeatures.successRate,
      errorRate: baseFeatures.errorRate,
      crashRate: baseFeatures.crashRate,
      confidenceScore: baseFeatures.confidenceScore,
      rolloutPercentage: baseFeatures.rolloutPercentage,
      sampleSize: baseFeatures.sampleSize,
      hoursInStage: baseFeatures.hoursInStage,
      successDelta: transitionSuccessDelta,
      errorDelta: transitionErrorDelta,
      crashDelta: transitionCrashDelta,
      successTrendSlope: baseFeatures.successTrendSlope,
      errorTrendSlope: baseFeatures.errorTrendSlope,
      crashTrendSlope: baseFeatures.crashTrendSlope,
      successVolatility: baseFeatures.successVolatility,
      errorVolatility: baseFeatures.errorVolatility,
      crashVolatility: baseFeatures.crashVolatility,
      sampleGrowthRate: baseFeatures.sampleGrowthRate,
      confidenceGrowthRate: baseFeatures.confidenceGrowthRate,
      isStabilizing: baseFeatures.isStabilizing,
      hasCriticalAnomaly: baseFeatures.hasCriticalAnomaly,
      earlyWarningSignals: baseFeatures.earlyWarningSignals,
    );
  }

  /// Calculate feature importance scores based on correlation with outcomes
  Map<String, double> calculateFeatureImportance({
    required List<ExtractedFeatures> featureHistory,
    required List<bool> outcomes,
  }) {
    if (featureHistory.length != outcomes.length || featureHistory.isEmpty) {
      return {};
    }

    final importance = <String, double>{};
    final featureNames = featureHistory.first.toMap().keys.toList();

    for (final name in featureNames) {
      final values = featureHistory.map((f) => f.toMap()[name] ?? 0.0).toList();
      final correlation = _calculatePointBiserialCorrelation(values, outcomes);
      importance[name] = correlation.abs();
    }

    // Normalize to sum to 1
    final total = importance.values.reduce((a, b) => a + b);
    if (total > 0) {
      for (final key in importance.keys.toList()) {
        importance[key] = importance[key]! / total;
      }
    }

    return importance;
  }

  /// Calculate point-biserial correlation between continuous and binary variables
  double _calculatePointBiserialCorrelation(
    List<double> continuous,
    List<bool> binary,
  ) {
    if (continuous.length != binary.length || continuous.isEmpty) return 0.0;

    final n = continuous.length;
    final group1 = <double>[];
    final group0 = <double>[];

    for (var i = 0; i < n; i++) {
      if (binary[i]) {
        group1.add(continuous[i]);
      } else {
        group0.add(continuous[i]);
      }
    }

    if (group1.isEmpty || group0.isEmpty) return 0.0;

    final mean1 = group1.reduce((a, b) => a + b) / group1.length;
    final mean0 = group0.reduce((a, b) => a + b) / group0.length;
    final stdDev = _calculateVolatility(continuous);

    if (stdDev == 0) return 0.0;

    final n1 = group1.length;
    final n0 = group0.length;
    final p = n1 / n;
    final q = n0 / n;

    return ((mean1 - mean0) / stdDev) * math.sqrt(p * q);
  }
}
