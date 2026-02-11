// ════════════════════════════════════════════════════════════════════════════
// FEATURE FLAGS - InnerCycles App Configuration
// ════════════════════════════════════════════════════════════════════════════
//
// Controls feature visibility. All astrology features have been permanently
// removed from the codebase for App Store 4.3(b) compliance.
//
// ════════════════════════════════════════════════════════════════════════════

class FeatureFlags {
  FeatureFlags._();

  // ══════════════════════════════════════════════════════════════════════════
  // CORE FEATURES
  // ══════════════════════════════════════════════════════════════════════════

  /// Journal - daily personal cycle tracking (PRIMARY FEATURE)
  static const bool showJournal = true;

  /// Patterns - trend analysis after 7+ journal entries
  static const bool showPatterns = true;

  /// Insight - reflection-focused assistant
  static const bool showInsight = true;

  /// Dream journal - personal notes and interpretation
  static const bool showDreamJournal = true;

  /// Numerology (educational framing, pattern awareness)
  static const bool showNumerology = true;

  /// Wellness features
  static const bool showChakra = true;
  static const bool showAura = true;
  static const bool showRituals = true;

  /// Tarot - card symbolism (educational)
  static const bool showTarot = true;

  /// Quiz features
  static const bool showQuiz = true;

  // ══════════════════════════════════════════════════════════════════════════
  // LANGUAGE CONTROL
  // ══════════════════════════════════════════════════════════════════════════

  /// Use prediction-free language throughout the app
  static const bool useSafeLanguage = true;

  /// Show entertainment disclaimer on all screens
  static const bool showDisclaimer = true;
}
