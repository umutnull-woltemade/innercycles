class Routes {
  Routes._();

  static const String splash = '/';
  static const String disclaimer = '/disclaimer';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String horoscope = '/horoscope';
  static const String horoscopeDetail = '/horoscope/:sign';
  static const String compatibility = '/compatibility';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String birthChart = '/birth-chart';
  static const String numerology = '/numerology';
  static const String kabbalah = '/kabbalah';
  static const String tarot = '/tarot';
  static const String majorArcanaDetail = '/tarot/major/:number';
  static const String aura = '/aura';
  static const String transits = '/transits';
  static const String premium = '/premium';
  static const String shareSummary = '/share';
  static const String cosmicShare = '/cosmic-share';

  // Extended Horoscopes
  static const String weeklyHoroscope = '/horoscope/weekly';
  static const String weeklyHoroscopeDetail = '/horoscope/weekly/:sign';
  static const String monthlyHoroscope = '/horoscope/monthly';
  static const String monthlyHoroscopeDetail = '/horoscope/monthly/:sign';
  static const String yearlyHoroscope = '/horoscope/yearly';
  static const String yearlyHoroscopeDetail = '/horoscope/yearly/:sign';
  static const String loveHoroscope = '/horoscope/love';
  static const String loveHoroscopeDetail = '/horoscope/love/:sign';
  static const String eclipseCalendar = '/eclipse-calendar';

  // Advanced Astrology
  static const String compositeChart = '/composite-chart';
  static const String vedicChart = '/vedic-chart';
  static const String progressions = '/progressions';
  static const String saturnReturn = '/saturn-return';
  static const String solarReturn = '/solar-return';
  static const String synastry = '/synastry';
  static const String yearAhead = '/year-ahead';
  static const String timing = '/timing';

  // Premium Features
  static const String astroCartography = '/astro-cartography';
  static const String electional = '/electional';
  static const String draconicChart = '/draconic-chart';
  static const String asteroids = '/asteroids';
  static const String localSpace = '/local-space';

  // Reference & Content
  static const String glossary = '/glossary';
  static const String gardeningMoon = '/gardening-moon';
  static const String celebrities = '/celebrities';
  static const String articles = '/articles';

  // New Features
  static const String transitCalendar = '/transit-calendar';
  static const String voidOfCourse = '/void-of-course';

  // ════════════════════════════════════════════════════════════════
  // NUMEROLOGY - Ancient Number Wisdom (60+ Content)
  // ════════════════════════════════════════════════════════════════

  // Life Path Numbers (1-9)
  static const String lifePathDetail = '/numerology/life-path/:number';
  static const String lifePath1 = '/numerology/life-path/1';
  static const String lifePath2 = '/numerology/life-path/2';
  static const String lifePath3 = '/numerology/life-path/3';
  static const String lifePath4 = '/numerology/life-path/4';
  static const String lifePath5 = '/numerology/life-path/5';
  static const String lifePath6 = '/numerology/life-path/6';
  static const String lifePath7 = '/numerology/life-path/7';
  static const String lifePath8 = '/numerology/life-path/8';
  static const String lifePath9 = '/numerology/life-path/9';

  // Master Numbers
  static const String masterNumber = '/numerology/master/:number';
  static const String master11 = '/numerology/master/11';
  static const String master22 = '/numerology/master/22';
  static const String master33 = '/numerology/master/33';

  // Personal Year
  static const String personalYearDetail = '/numerology/personal-year/:number';
  static const String personalYear1 = '/numerology/personal-year/1';
  static const String personalYear2 = '/numerology/personal-year/2';
  static const String personalYear3 = '/numerology/personal-year/3';
  static const String personalYear4 = '/numerology/personal-year/4';
  static const String personalYear5 = '/numerology/personal-year/5';
  static const String personalYear6 = '/numerology/personal-year/6';
  static const String personalYear7 = '/numerology/personal-year/7';
  static const String personalYear8 = '/numerology/personal-year/8';
  static const String personalYear9 = '/numerology/personal-year/9';

  // Additional Numerology Content
  static const String birthdayNumber = '/numerology/birthday';
  static const String destinyNumber = '/numerology/destiny';
  static const String soulUrge = '/numerology/soul-urge';
  static const String personalityNumber = '/numerology/personality';
  static const String karmicDebt = '/numerology/karmic-debt';
  static const String missingNumbers = '/numerology/missing-numbers';
  static const String numerologyCompatibility = '/numerology/compatibility';

  // Spiritual & Wellness
  static const String dailyRituals = '/daily-rituals';
  static const String chakraAnalysis = '/chakra-analysis';
  static const String crystalGuide = '/crystal-guide';
  static const String moonRituals = '/moon-rituals';
  static const String dreamInterpretation = '/dream-interpretation';
  static const String dreamGlossary = '/dream-glossary';
  static const String dreamShare = '/dream-share';
  static const String tantra = '/tantra';
  static const String thetaHealing = '/theta-healing';
  static const String reiki = '/reiki';

  // ════════════════════════════════════════════════════════════════
  // DREAM TRACE - AI-First Canonical Pages
  // ════════════════════════════════════════════════════════════════
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
  // COSMIC - Daily Theme
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
  // INSIGHT - Unified Personal Reflection Assistant (Apple-Safe)
  // Single entry point replacing Kozmoz and Dream Oracle
  // ════════════════════════════════════════════════════════════════
  static const String insight =
      '/insight'; // Primary entry - "Start a Reflection"

  // Legacy routes (DEPRECATED - kept for backward compatibility)
  // These should redirect to /insight
  @Deprecated(
    'Use insight instead - merging into single assistant for App Store compliance',
  )
  static const String kozmikIletisim = '/cosmic-chat'; // DEPRECATED
  @Deprecated(
    'Use insight instead - merging into single assistant for App Store compliance',
  )
  static const String ruyaDongusu = '/dream-oracle'; // DEPRECATED

  // Profile Management
  static const String savedProfiles = '/saved-profiles';
  static const String comparison = '/comparison';

  // Kozmoz - All features screen
  static const String kozmoz = '/kozmoz';

  // All Services - Main catalog page
  static const String allServices = '/all-services';

  // ════════════════════════════════════════════════════════════════
  // COSMIC DISCOVERY - Viral & Philosophical Content (Special Screens)
  // ════════════════════════════════════════════════════════════════

  // Daily Energies
  static const String dailySummary = '/discovery/daily-summary';
  static const String moonEnergy = '/discovery/moon-energy';
  static const String loveEnergy = '/discovery/love-energy';
  static const String abundanceEnergy = '/discovery/abundance-energy';

  // Spiritual Transformation & Life Purpose
  static const String spiritualTransformation =
      '/discovery/spiritual-transformation';
  static const String lifePurpose = '/discovery/life-purpose';
  static const String subconsciousPatterns = '/discovery/subconscious-patterns';
  static const String karmaLessons = '/discovery/karma-lessons';
  static const String soulContract = '/discovery/soul-contract';
  static const String innerPower = '/discovery/inner-power';

  // Personality Analysis
  static const String shadowSelf = '/discovery/shadow-self';
  static const String leadershipStyle = '/discovery/leadership-style';
  static const String heartbreak = '/discovery/heartbreak';
  static const String redFlags = '/discovery/red-flags';
  static const String greenFlags = '/discovery/green-flags';
  static const String flirtStyle = '/discovery/flirt-style';

  // Mystic Discoveries
  static const String tarotCard = '/discovery/tarot-card';
  static const String auraColor = '/discovery/aura-color';
  static const String chakraBalance = '/discovery/chakra-balance';
  static const String lifeNumber = '/discovery/life-number';
  static const String kabbalaPath = '/discovery/kabbala-path';

  // Time & Cycles
  static const String saturnLessons = '/discovery/saturn-lessons';
  static const String birthdayEnergy = '/discovery/birthday-energy';
  static const String eclipseEffect = '/discovery/eclipse-effect';
  static const String transitFlow = '/discovery/transit-flow';

  // Relationship Analysis
  static const String compatibilityAnalysis =
      '/discovery/compatibility-analysis';
  static const String soulMate = '/discovery/soulmate';
  static const String relationshipKarma = '/discovery/relationship-karma';
  static const String celebrityTwin = '/discovery/celebrity-twin';

  // ════════════════════════════════════════════════════════════════
  // ADMIN SYSTEM - PIN Protected Dashboard
  // ════════════════════════════════════════════════════════════════
  static const String adminLogin = '/admin/login';
  static const String admin = '/admin';

  // ════════════════════════════════════════════════════════════════
  // OBSERVATORY - Owner-Only Platform Control System
  // ════════════════════════════════════════════════════════════════
  static const String observatory = '/admin/observatory';
  static const String observatoryTech = '/admin/observatory/tech';
  static const String observatoryLanguage = '/admin/observatory/language';
  static const String observatoryContent = '/admin/observatory/content';
  static const String observatorySafety = '/admin/observatory/safety';
  static const String observatoryPlatform = '/admin/observatory/platform';

  // ════════════════════════════════════════════════════════════════
  // LEGACY TURKISH ROUTE REDIRECTS (for SEO backward compatibility)
  // These should redirect to English equivalents
  // ════════════════════════════════════════════════════════════════
  static const Map<String, String> legacyRouteRedirects = {
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
    '/kozmik/bugunku-tema': '/cosmic/daily-theme',
    '/kozmik/bugunku-enerji': '/cosmic/daily-energy',
    '/kozmik/one-cikan-duygu': '/cosmic/featured-emotion',
    '/tantra/mikro-rituel': '/tantra/micro-ritual',
    '/tantra/nefes-farkindalik': '/tantra/breath-awareness',
    '/tantra/niyet-ritueli': '/tantra/intention-ritual',
    '/kozmik-iletisim': '/cosmic-chat',
    '/ruya-dongusu': '/dream-oracle',
    '/tum-cozumlemeler': '/all-services',
    '/kesif/gunun-ozeti': '/discovery/daily-summary',
    '/kesif/ay-enerjisi': '/discovery/moon-energy',
    '/kesif/ask-enerjisi': '/discovery/love-energy',
    '/kesif/bolluk-enerjisi': '/discovery/abundance-energy',
    '/kesif/ruhsal-donusum': '/discovery/spiritual-transformation',
    '/kesif/hayat-amacin': '/discovery/life-purpose',
    '/kesif/bilincalti-kaliplarin': '/discovery/subconscious-patterns',
    '/kesif/karma-derslerin': '/discovery/karma-lessons',
    '/kesif/ruh-sozlesmen': '/discovery/soul-contract',
    '/kesif/icsel-gucun': '/discovery/inner-power',
    '/kesif/golge-benligin': '/discovery/shadow-self',
    '/kesif/liderlik-stilin': '/discovery/leadership-style',
    '/kesif/kalp-yaran': '/discovery/heartbreak',
    '/kesif/red-flaglerin': '/discovery/red-flags',
    '/kesif/green-flaglerin': '/discovery/green-flags',
    '/kesif/flort-stilin': '/discovery/flirt-style',
    '/kesif/tarot-kartin': '/discovery/tarot-card',
    '/kesif/aura-rengin': '/discovery/aura-color',
    '/kesif/cakra-dengen': '/discovery/chakra-balance',
    '/kesif/yasam-sayin': '/discovery/life-number',
    '/kesif/kabala-yolun': '/discovery/kabbala-path',
    '/kesif/saturn-derslerin': '/discovery/saturn-lessons',
    '/kesif/dogum-gunu-enerjin': '/discovery/birthday-energy',
    '/kesif/tutulma-etkisi': '/discovery/eclipse-effect',
    '/kesif/transit-akisi': '/discovery/transit-flow',
    '/kesif/uyum-analizi': '/discovery/compatibility-analysis',
    '/kesif/ruh-esin': '/discovery/soulmate',
    '/kesif/iliski-karman': '/discovery/relationship-karma',
    '/kesif/unlu-ikizin': '/discovery/celebrity-twin',
  };
}
