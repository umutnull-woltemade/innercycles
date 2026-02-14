// ════════════════════════════════════════════════════════════════════════════
// CROSS-CORRELATION RESULT - InnerCycles Cross-Dimension Analysis
// ════════════════════════════════════════════════════════════════════════════
// Represents a correlation between two different data dimensions
// (e.g., sleep quality vs. next-day mood). Uses safe, non-predictive language.
// ════════════════════════════════════════════════════════════════════════════

/// A correlation result between two data dimensions from different services
class CrossCorrelation {
  final String dimensionA;
  final String dimensionB;
  final double coefficient; // -1.0 to 1.0
  final int sampleSize;
  final String insightTextEn; // human-readable (English)
  final String insightTextTr; // human-readable (Turkish)
  final bool isSignificant; // sampleSize >= 7 and |coefficient| >= 0.3

  const CrossCorrelation({
    required this.dimensionA,
    required this.dimensionB,
    required this.coefficient,
    required this.sampleSize,
    required this.insightTextEn,
    required this.insightTextTr,
    required this.isSignificant,
  });

  /// Strength label for display
  String get strengthEn {
    final abs = coefficient.abs();
    if (abs >= 0.7) return 'Strongly connected';
    if (abs >= 0.5) return 'Moderately connected';
    if (abs >= 0.3) return 'Weakly connected';
    return 'No clear connection';
  }

  String get strengthTr {
    final abs = coefficient.abs();
    if (abs >= 0.7) return 'Güçlü bağlantı';
    if (abs >= 0.5) return 'Orta bağlantı';
    if (abs >= 0.3) return 'Zayıf bağlantı';
    return 'Belirgin bağlantı yok';
  }

  /// Direction label
  String get directionEn =>
      coefficient > 0 ? 'positively correlated' : 'negatively correlated';

  String get directionTr =>
      coefficient > 0 ? 'pozitif ilişkili' : 'negatif ilişkili';

  /// Short display text: "Sleep & Energy: Strongly connected (r=0.72)"
  String shortDisplayEn() =>
      '$dimensionA & $dimensionB: $strengthEn (r=${coefficient.toStringAsFixed(2)})';

  String shortDisplayTr() =>
      '$dimensionA & $dimensionB: $strengthTr (r=${coefficient.toStringAsFixed(2)})';
}
