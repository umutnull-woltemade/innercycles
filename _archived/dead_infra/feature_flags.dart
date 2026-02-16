// ════════════════════════════════════════════════════════════════════════════
// FEATURE FLAGS - InnerCycles App Configuration
// ════════════════════════════════════════════════════════════════════════════
//
// Controls feature visibility for App Store 4.3(b) compliance.
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

  // ══════════════════════════════════════════════════════════════════════════
  // LANGUAGE CONTROL
  // ══════════════════════════════════════════════════════════════════════════

  /// Use safe, reflection-focused language throughout the app
  static const bool useSafeLanguage = true;

  /// Show entertainment disclaimer on all screens
  static const bool showDisclaimer = true;
}
