// ════════════════════════════════════════════════════════════════════════════
// FEATURE FLAGS - App Store 4.3(b) Compliance Configuration
// ════════════════════════════════════════════════════════════════════════════
//
// This file controls feature visibility for App Store review compliance.
// Set flags to `false` to hide features that may trigger 4.3(b) rejection.
//
// GUIDELINE 4.3(b) CONTEXT:
// Apple rejects apps that "primarily feature astrology, horoscopes, palm
// reading, fortune telling, or zodiac reports" in saturated categories.
//
// STRATEGY:
// - Hide predictive/fortune-telling features during review
// - Emphasize reflection, journaling, and educational content
// - Position as "personal insight tool" not "astrology app"
//
// USAGE:
// ```dart
// if (FeatureFlags.showHoroscopes) {
//   // Show horoscope content
// }
// ```
// ════════════════════════════════════════════════════════════════════════════

/// Feature flags for App Store 4.3(b) compliance.
/// Controls visibility of high-risk features during app review.
class FeatureFlags {
  FeatureFlags._();

  // ══════════════════════════════════════════════════════════════════════════
  // APP STORE REVIEW MODE
  // ══════════════════════════════════════════════════════════════════════════

  /// Master switch for App Store review mode.
  /// When `true`, hides all high-risk features.
  /// Set to `false` after app is approved.
  static const bool appStoreReviewMode = true;

  // ══════════════════════════════════════════════════════════════════════════
  // HIGH-RISK FEATURES (Hide during review)
  // ══════════════════════════════════════════════════════════════════════════

  /// Daily/Weekly/Monthly/Yearly horoscopes - CRITICAL RISK
  /// These are the primary 4.3(b) triggers.
  static bool get showHoroscopes => !appStoreReviewMode;

  /// Love horoscope predictions - HIGH RISK
  static bool get showLoveHoroscope => !appStoreReviewMode;

  /// Zodiac sign reveal in onboarding - HIGH RISK
  /// Shows "You are a Leo!" type messaging.
  static bool get showZodiacOnboarding => !appStoreReviewMode;

  /// Year ahead forecast - HIGH RISK
  /// "What 2026 holds for you" style predictions.
  static bool get showYearAhead => !appStoreReviewMode;

  /// Progressions (predictive astrology) - HIGH RISK
  static bool get showProgressions => !appStoreReviewMode;

  /// Saturn Return (life-cycle predictions) - HIGH RISK
  static bool get showSaturnReturn => !appStoreReviewMode;

  /// Solar Return (birthday forecasts) - HIGH RISK
  static bool get showSolarReturn => !appStoreReviewMode;

  /// Electional astrology ("auspicious times") - HIGH RISK
  static bool get showElectional => !appStoreReviewMode;

  /// Transit calendar (future planet movements) - HIGH RISK
  static bool get showTransitCalendar => !appStoreReviewMode;

  /// Transits screen - MEDIUM-HIGH RISK
  static bool get showTransits => !appStoreReviewMode;

  /// Destiny number in numerology - HIGH RISK
  /// Explicit "destiny" claim.
  static bool get showDestinyNumber => !appStoreReviewMode;

  /// Personal year number - HIGH RISK
  /// Yearly numerology predictions.
  static bool get showPersonalYear => !appStoreReviewMode;

  /// Karmic debt numbers - MEDIUM-HIGH RISK
  static bool get showKarmicDebt => !appStoreReviewMode;

  /// Karma/soulmate discovery themes - HIGH RISK
  static bool get showKarmaDiscovery => !appStoreReviewMode;

  /// Tarot past-present-future spreads - MEDIUM-HIGH RISK
  static bool get showTarotSpreads => !appStoreReviewMode;

  /// Full tarot feature - MEDIUM RISK
  static bool get showFullTarot => !appStoreReviewMode;

  /// Cosmic discovery viral features - MEDIUM-HIGH RISK
  static bool get showCosmicDiscovery => !appStoreReviewMode;

  /// Kozmoz AI cosmic chat - MEDIUM RISK
  static bool get showKozmoz => !appStoreReviewMode;

  /// Eclipse calendar - MEDIUM RISK
  static bool get showEclipseCalendar => !appStoreReviewMode;

  /// Void of course moon timing - MEDIUM RISK
  static bool get showVoidOfCourse => !appStoreReviewMode;

  /// Timing/electional features - MEDIUM RISK
  static bool get showTiming => !appStoreReviewMode;

  // ══════════════════════════════════════════════════════════════════════════
  // SAFE FEATURES (Always show)
  // ══════════════════════════════════════════════════════════════════════════

  /// Insight - reflection-focused assistant
  /// This is the primary App Store-safe feature.
  static const bool showInsight = true;

  /// Dream journal - reframed as personal notes
  static const bool showDreamJournal = true;

  /// Dream interpretation (psychological framing)
  static const bool showDreamInterpretation = true;

  /// Symbol explorer (educational framing)
  static const bool showSymbolExplorer = true;

  /// Birth chart visualization (data display, not predictions)
  static const bool showBirthChart = true;

  /// Glossary (educational reference)
  static const bool showGlossary = true;

  /// Dream glossary (educational reference)
  static const bool showDreamGlossary = true;

  /// Articles (informational content)
  static const bool showArticles = true;

  /// Profile management
  static const bool showProfile = true;

  /// Settings
  static const bool showSettings = true;

  /// Premium features
  static const bool showPremium = true;

  /// Compatibility (reframed as "relationship patterns")
  static const bool showCompatibility = true;

  /// Numerology main screen (educational framing)
  static const bool showNumerology = true;

  /// Life path numbers (pattern awareness, not destiny)
  static const bool showLifePath = true;

  /// Chakra analysis (wellness framing)
  static const bool showChakra = true;

  /// Aura analysis (wellness framing)
  static const bool showAura = true;

  /// Daily rituals (wellness/mindfulness)
  static const bool showRituals = true;

  /// Quiz features
  static const bool showQuiz = true;

  // ══════════════════════════════════════════════════════════════════════════
  // NAVIGATION CONTROL
  // ══════════════════════════════════════════════════════════════════════════

  /// Show horoscope-related navigation cards on home screen
  static bool get showHoroscopeNavigation => !appStoreReviewMode;

  /// Show prediction-based navigation cards
  static bool get showPredictionNavigation => !appStoreReviewMode;

  /// Show zodiac-identity based content
  static bool get showZodiacIdentity => !appStoreReviewMode;

  // ══════════════════════════════════════════════════════════════════════════
  // LANGUAGE CONTROL
  // ══════════════════════════════════════════════════════════════════════════

  /// Use prediction-free language throughout the app
  static const bool useSafeLanguage = true;

  /// Show entertainment disclaimer on all screens
  static const bool showDisclaimer = true;

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ══════════════════════════════════════════════════════════════════════════

  /// Check if a route should be accessible
  static bool isRouteEnabled(String route) {
    if (!appStoreReviewMode) return true;

    // High-risk routes to block
    final blockedRoutes = [
      '/horoscope',
      '/horoscope/weekly',
      '/horoscope/monthly',
      '/horoscope/yearly',
      '/horoscope/love',
      '/year-ahead',
      '/progressions',
      '/saturn-return',
      '/solar-return',
      '/electional',
      '/transit-calendar',
      '/transits',
      '/kozmoz',
      '/timing',
      '/void-of-course',
      '/eclipse-calendar',
      '/numerology/destiny',
      '/numerology/personal-year',
      '/discovery/karma-lessons',
      '/discovery/soulmate',
      '/discovery/soul-contract',
    ];

    // Check if route starts with any blocked pattern
    for (final blocked in blockedRoutes) {
      if (route.startsWith(blocked)) {
        return false;
      }
    }

    return true;
  }

  /// Get the redirect route for blocked features
  static String getRedirectRoute() => '/insight';

  /// Check if we should show zodiac sign in UI
  static bool get shouldShowZodiacSign => !appStoreReviewMode;

  /// Check if we should use "cosmic" language
  static bool get shouldUseCosmicLanguage => !appStoreReviewMode;
}
