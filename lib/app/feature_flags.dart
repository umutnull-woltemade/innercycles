/// Feature Flags — Survival Release
/// Controls feature visibility for the focused 5-tab release.
/// SECONDARY features are soft-archived: code preserved, routes removed.
library;

/// Master switch for survival release mode.
/// When true, only CORE features are routable.
const bool kSurvivalMode = true;

/// Feature visibility registry.
/// true = CORE (routable, visible in nav)
/// false = SECONDARY (code preserved, route removed)
const Map<String, bool> featureEnabled = {
  // ── CORE: Home tab ──
  'today': true,
  'streak_stats': true,

  // ── CORE: Journal tab ──
  'journal': true,
  'journal_detail': true,
  'journal_archive': true,
  'journal_patterns': true,
  'journal_monthly': true,

  // ── CORE: Insights tab ──
  'mood_trends': true,
  'calendar_heatmap': true,
  'emotional_cycles': true,

  // ── CORE: Breathe tab ──
  'breathing': true,
  'meditation': true,

  // ── CORE: Profile tab ──
  'profile_hub': true,
  'profile_edit': true,
  'settings': true,
  'premium': true,
  'notifications': true,
  'export': true,

  // ── CORE: System ──
  'onboarding': true,
  'disclaimer': true,
  'app_lock': true,
  'admin': true,

  // ── SECONDARY: Dreams ──
  'dream_interpretation': false,
  'dream_glossary': false,
  'dream_archive': false,
  'dream_canonical': false,

  // ── SECONDARY: Insight Chat ──
  'insight_chat': false, // Rebuilt as Reflection Prompts

  // ── SECONDARY: Discovery & Content ──
  'insights_discovery': false,
  'quiz_hub': false,
  'attachment_quiz': false,
  'share_cards': false,
  'growth_dashboard': false,
  'articles': false,
  'search': false,
  'prompt_library': false,

  // ── SECONDARY: Wellness & Habits ──
  'rituals': false,
  'wellness_detail': false,
  'energy_map': false,
  'habit_suggestions': false,
  'daily_habits': false,
  'gratitude': false,
  'gratitude_archive': false,
  'sleep_detail': false,
  'sleep_trends': false,
  'affirmations': false,
  'emotional_vocabulary': false,

  // ── SECONDARY: Programs & Challenges ──
  'programs': false,
  'program_detail': false,
  'program_completion': false,
  'challenges': false,
  'challenge_hub': false,

  // ── SECONDARY: Seasonal & Astro-adjacent ──
  'seasonal': false,
  'moon_calendar': false,
  'archetype': false,
  'compatibility': false,
  'blind_spot': false,

  // ── SECONDARY: Digests & Reviews ──
  'weekly_digest': false,
  'milestones': false,
  'year_review': false,

  // ── SECONDARY: Tabs (removed from nav) ──
  'tools_catalog': false,
  'library_hub': false,
};

/// Check if a feature is enabled in survival mode.
bool isFeatureEnabled(String feature) {
  if (!kSurvivalMode) return true; // All features enabled outside survival mode
  return featureEnabled[feature] ?? false;
}
