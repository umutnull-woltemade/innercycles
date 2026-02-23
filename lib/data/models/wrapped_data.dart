// ============================================================================
// WRAPPED DATA MODEL - InnerCycles Wrapped (Annual Recap)
// ============================================================================
// Extends YearReview with cinematic-ready data for the Wrapped experience.
// Computes emotional arc, breakthrough moments, intensity, and activity stats.
// ============================================================================

import '../models/journal_entry.dart';

/// The dominant emotional trajectory for the year
enum EmotionalArc {
  rising,
  steady,
  transforming;

  String label(bool isEn) {
    switch (this) {
      case EmotionalArc.rising:
        return isEn ? 'Rising' : 'Yükselen';
      case EmotionalArc.steady:
        return isEn ? 'Steady' : 'Dengeli';
      case EmotionalArc.transforming:
        return isEn ? 'Transforming' : 'Dönüşen';
    }
  }

  String description(bool isEn) {
    switch (this) {
      case EmotionalArc.rising:
        return isEn
            ? 'Your emotional trajectory has been climbing upward'
            : 'Duygusal yörüngen yukarı doğru tırmanıyor';
      case EmotionalArc.steady:
        return isEn
            ? 'You maintained a grounded, stable emotional rhythm'
            : 'İstikrarlı ve dengeli bir duygusal ritim sürdürdün';
      case EmotionalArc.transforming:
        return isEn
            ? 'Your emotional landscape has been shifting and evolving'
            : 'Duygusal manzaran değişim ve evrim içinde';
    }
  }
}

/// Wrapped-specific data that complements the base YearReview
class WrappedData {
  final int year;
  final int totalEntries;
  final int totalJournalingDays;
  final double averageMood;
  final int growthScore;
  final int streakBest;

  /// The dominant emotional trajectory
  final EmotionalArc dominantEmotionalArc;

  /// Number of "breakthrough" moments (mood >= 4.0 entries starting a positive streak)
  final int breakthroughCount;

  /// The week (Monday date) with the highest mood variance
  final DateTime? mostIntenseWeek;

  /// Month index (1-12) with the fewest entries
  final int quietestMonth;

  /// Month index (1-12) with the most entries
  final int busiestMonth;

  /// Top 5 most-used emotion tags from journal entries
  final List<String> topEmotionTags;

  /// Focus area distribution (for card 4)
  final Map<FocusArea, int> focusAreaCounts;

  /// Top 3 detected patterns (for card 7)
  final List<String> topPatterns;

  /// 12 monthly mood averages (for visualization)
  final List<double> moodJourney;

  const WrappedData({
    required this.year,
    required this.totalEntries,
    required this.totalJournalingDays,
    required this.averageMood,
    required this.growthScore,
    required this.streakBest,
    required this.dominantEmotionalArc,
    required this.breakthroughCount,
    this.mostIntenseWeek,
    required this.quietestMonth,
    required this.busiestMonth,
    required this.topEmotionTags,
    required this.focusAreaCounts,
    required this.topPatterns,
    required this.moodJourney,
  });
}
