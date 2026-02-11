// ════════════════════════════════════════════════════════════════════════════
// ROUTES - App Navigation Constants (App Store 4.3(b) Compliant)
// ════════════════════════════════════════════════════════════════════════════
// All astrology/horoscope routes have been removed for App Store compliance.
// This file focuses on:
// - Core navigation (splash, onboarding, home)
// - Insight & reflection features
// - Wellness & mindfulness
// - Dream journal
// - Profile & settings
// ════════════════════════════════════════════════════════════════════════════

class Routes {
  Routes._();

  // ════════════════════════════════════════════════════════════════
  // CORE NAVIGATION
  // ════════════════════════════════════════════════════════════════
  static const String splash = '/';
  static const String disclaimer = '/disclaimer';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  // ════════════════════════════════════════════════════════════════
  // JOURNAL - Personal Cycle Tracking (PRIMARY FEATURE)
  // ════════════════════════════════════════════════════════════════
  static const String journal = '/journal';
  static const String journalEntryDetail = '/journal/entry/:id';
  static const String journalPatterns = '/journal/patterns';
  static const String journalMonthly = '/journal/monthly';
  static const String journalArchive = '/journal/archive';

  // ════════════════════════════════════════════════════════════════
  // INSIGHT - Apple-Safe Personal Reflection Assistant
  // ════════════════════════════════════════════════════════════════
  static const String insight = '/insight';

  // ════════════════════════════════════════════════════════════════
  // NUMEROLOGY (Educational, Pattern-Based - NOT predictive)
  // ════════════════════════════════════════════════════════════════
  static const String numerology = '/numerology';
  static const String lifePathDetail = '/numerology/life-path/:number';

  // Master Numbers
  static const String masterNumber = '/numerology/master/:number';

  // ════════════════════════════════════════════════════════════════
  // KABBALAH & TAROT (Spiritual Education)
  // ════════════════════════════════════════════════════════════════
  static const String kabbalah = '/kabbalah';
  static const String tarot = '/tarot';
  static const String majorArcanaDetail = '/tarot/major/:number';

  // ════════════════════════════════════════════════════════════════
  // WELLNESS & MINDFULNESS
  // ════════════════════════════════════════════════════════════════
  static const String aura = '/aura';
  static const String chakraAnalysis = '/chakra-analysis';
  static const String dailyRituals = '/daily-rituals';
  static const String tantra = '/tantra';
  static const String thetaHealing = '/theta-healing';
  static const String reiki = '/reiki';

  // ════════════════════════════════════════════════════════════════
  // DREAM JOURNAL & INTERPRETATION
  // ════════════════════════════════════════════════════════════════
  static const String dreamInterpretation = '/dream-interpretation';
  static const String dreamGlossary = '/dream-glossary';
  static const String dreamShare = '/dream-share';

  // Dream Trace - Canonical Dream Pages
  static const String dreamFalling = '/dreams/falling';
  static const String dreamWater = '/dreams/water';
  static const String dreamRecurring = '/dreams/recurring';
  static const String dreamRunning = '/dreams/running';
  static const String dreamLosing = '/dreams/losing-someone';
  static const String dreamFlying = '/dreams/flying';
  static const String dreamDarkness = '/dreams/darkness';
  static const String dreamPast = '/dreams/someone-from-past';
  static const String dreamSearching = '/dreams/searching';
  static const String dreamVoiceless = '/dreams/voiceless';
  static const String dreamLost = '/dreams/lost';
  static const String dreamUnableToFly = '/dreams/unable-to-fly';

  // ════════════════════════════════════════════════════════════════
  // COSMIC - Daily Theme (Reflective, Not Predictive)
  // ════════════════════════════════════════════════════════════════
  static const String cosmicToday = '/cosmic/daily-theme';
  static const String cosmicEnergy = '/cosmic/daily-energy';
  static const String cosmicEmotion = '/cosmic/featured-emotion';

  // ════════════════════════════════════════════════════════════════
  // TANTRA - Micro Rituals
  // ════════════════════════════════════════════════════════════════
  static const String tantraMicroRitual = '/tantra/micro-ritual';
  static const String tantraBreath = '/tantra/breath-awareness';
  static const String tantraIntention = '/tantra/intention-ritual';

  // ════════════════════════════════════════════════════════════════
  // REFERENCE & EDUCATIONAL CONTENT
  // ════════════════════════════════════════════════════════════════
  static const String glossary = '/glossary';
  static const String gardeningMoon = '/gardening-moon';
  static const String celebrities = '/celebrities';
  static const String articles = '/articles';

  // ════════════════════════════════════════════════════════════════
  // PROFILE & SETTINGS
  // ════════════════════════════════════════════════════════════════
  static const String profile = '/profile';
  static const String savedProfiles = '/saved-profiles';
  static const String comparison = '/comparison';
  static const String settings = '/settings';
  static const String premium = '/premium';

  // ════════════════════════════════════════════════════════════════
  // SHARING
  // ════════════════════════════════════════════════════════════════
  static const String shareSummary = '/share';
  static const String cosmicShare = '/cosmic-share';

  // ════════════════════════════════════════════════════════════════
  // ALL SERVICES CATALOG
  // ════════════════════════════════════════════════════════════════
  static const String allServices = '/all-services';
  static const String kozmoz = '/kozmoz';

  // ════════════════════════════════════════════════════════════════
  // ADMIN SYSTEM - PIN Protected Dashboard
  // ════════════════════════════════════════════════════════════════
  static const String adminLogin = '/admin/login';
  static const String admin = '/admin';
  static const String observatory = '/admin/observatory';
  static const String observatoryTech = '/admin/observatory/tech';
  static const String observatoryLanguage = '/admin/observatory/language';
  static const String observatoryContent = '/admin/observatory/content';
  static const String observatorySafety = '/admin/observatory/safety';
  static const String observatoryPlatform = '/admin/observatory/platform';

  // ════════════════════════════════════════════════════════════════
  // LEGACY ROUTE REDIRECTS (for backward compatibility)
  // All astrology routes now redirect to /insight
  // ════════════════════════════════════════════════════════════════
  static const Map<String, String> legacyRouteRedirects = {
    // Turkish dream routes -> English
    '/ruya/dusmek': '/dreams/falling',
    '/ruya/su-gormek': '/dreams/water',
    '/ruya/tekrar-eden': '/dreams/recurring',
    '/ruya/kacmak': '/dreams/running',
    '/ruya/birini-kaybetmek': '/dreams/losing-someone',
    '/ruya/ucmak': '/dreams/flying',
    '/ruya/karanlik': '/dreams/darkness',
    '/ruya/gecmisten-biri': '/dreams/someone-from-past',
    '/ruya/bir-sey-aramak': '/dreams/searching',
    '/ruya/ses-cikaramamak': '/dreams/voiceless',
    '/ruya/kaybolmak': '/dreams/lost',
    '/ruya/ucamamak': '/dreams/unable-to-fly',

    // Astrology routes -> Insight (App Store 4.3b compliance)
    '/horoscope': '/insight',
    '/compatibility': '/insight',
    '/birth-chart': '/insight',
    '/transits': '/insight',
    '/synastry': '/insight',
    '/year-ahead': '/insight',
    '/progressions': '/insight',
    '/saturn-return': '/insight',
    '/solar-return': '/insight',
  };
}
