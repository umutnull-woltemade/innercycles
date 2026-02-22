// ════════════════════════════════════════════════════════════════════════════
// ROUTES - InnerCycles Navigation Constants (App Store 4.3(b) Compliant)
// ════════════════════════════════════════════════════════════════════════════
// Focused on:
// - Core navigation (onboarding, today feed)
// - Journal (primary feature)
// - Dream journal
// - Insight & reflection
// - Profile & settings
// ════════════════════════════════════════════════════════════════════════════

class Routes {
  Routes._();

  // ════════════════════════════════════════════════════════════════
  // CORE NAVIGATION
  // ════════════════════════════════════════════════════════════════
  static const String disclaimer = '/disclaimer';
  static const String onboarding = '/onboarding';

  // ════════════════════════════════════════════════════════════════
  // JOURNAL - Personal Cycle Tracking (PRIMARY FEATURE)
  // ════════════════════════════════════════════════════════════════
  static const String journal = '/journal';
  static const String journalEntryDetail = '/journal/entry/:id';
  static const String journalPatterns = '/journal/patterns';
  static const String journalMonthly = '/journal/monthly';
  static const String journalArchive = '/journal/archive';

  // ════════════════════════════════════════════════════════════════
  // INSIGHT - Personal Reflection Assistant
  // ════════════════════════════════════════════════════════════════
  static const String insight = '/insight';
  static const String insightsDiscovery = '/insights-discovery';

  // ════════════════════════════════════════════════════════════════
  // DREAM JOURNAL
  // ════════════════════════════════════════════════════════════════
  static const String dreamInterpretation = '/dream-interpretation';
  static const String dreamGlossary = '/dream-glossary';
  // Dream Pages
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
  // RITUALS & HABITS
  // ════════════════════════════════════════════════════════════════
  static const String rituals = '/rituals';
  static const String ritualCreate = '/rituals/create';

  // ════════════════════════════════════════════════════════════════
  // WELLNESS & SLEEP
  // ════════════════════════════════════════════════════════════════
  static const String wellnessDetail = '/wellness';
  static const String energyMap = '/energy-map';

  // ════════════════════════════════════════════════════════════════
  // GUIDED PROGRAMS
  // ════════════════════════════════════════════════════════════════
  static const String programs = '/programs';
  static const String programDetail = '/programs/:id';

  // ════════════════════════════════════════════════════════════════
  // P2: SEASONAL, BREATHING, MOON CALENDAR, CHALLENGES
  // ════════════════════════════════════════════════════════════════
  static const String seasonal = '/seasonal';
  static const String breathing = '/breathing';
  static const String moonCalendar = '/moon-calendar';
  static const String challenges = '/challenges';

  // ════════════════════════════════════════════════════════════════
  // EXPORT, MEDITATION, GRATITUDE, SLEEP DETAIL
  // ════════════════════════════════════════════════════════════════
  static const String exportData = '/export';
  static const String meditation = '/meditation';
  static const String gratitudeJournal = '/gratitude';
  static const String sleepDetail = '/sleep';

  // ════════════════════════════════════════════════════════════════
  // REFERENCE & CONTENT
  // ════════════════════════════════════════════════════════════════
  static const String glossary = '/glossary';
  static const String articles = '/articles';

  // ════════════════════════════════════════════════════════════════
  // GROWTH & ENGAGEMENT
  // ════════════════════════════════════════════════════════════════
  static const String attachmentQuiz = '/quiz/attachment';
  static const String quizHub = '/quiz';
  static const String quizGeneric = '/quiz/:quizId';
  static const String shareInsight = '/share-insight';
  static const String shareCardGallery = '/share-cards';
  static const String emotionalCycles = '/emotional-cycles';
  static const String growthDashboard = '/growth';

  // ════════════════════════════════════════════════════════════════
  // CYCLE SYNC (Hormonal × Emotional Pattern Tracking)
  // ════════════════════════════════════════════════════════════════
  static const String cycleSync = '/cycle-sync';

  // ════════════════════════════════════════════════════════════════
  // SHADOW WORK (Guided Shadow Integration Journal)
  // ════════════════════════════════════════════════════════════════
  static const String shadowWork = '/shadow-work';

  // ════════════════════════════════════════════════════════════════
  // LIFE EVENTS (Life Timeline)
  // ════════════════════════════════════════════════════════════════
  static const String lifeEventNew = '/life-events/new';
  static const String lifeEventEdit = '/life-events/edit/:id';
  static const String lifeEventDetail = '/life-events/:id';
  static const String lifeTimeline = '/life-timeline';

  // ════════════════════════════════════════════════════════════════
  // CALENDAR & SEARCH
  // ════════════════════════════════════════════════════════════════
  static const String calendarHeatmap = '/calendar';
  static const String search = '/search';

  // ════════════════════════════════════════════════════════════════
  // TRENDS & HISTORY
  // ════════════════════════════════════════════════════════════════
  static const String moodTrends = '/mood/trends';
  static const String gratitudeArchive = '/gratitude/archive';
  static const String sleepTrends = '/sleep/trends';

  // ════════════════════════════════════════════════════════════════
  // TIER 2 FEATURES
  // ════════════════════════════════════════════════════════════════
  static const String weeklyDigest = '/weekly-digest';
  static const String archetype = '/archetype';
  static const String compatibilityReflection = '/compatibility';
  static const String blindSpot = '/blind-spot';
  static const String promptLibrary = '/prompts';
  static const String milestones = '/milestones';
  static const String habitSuggestions = '/habits';
  static const String dailyHabits = '/habits/daily';
  static const String archetypeQuiz = '/onboarding/quiz';
  static const String yearReview = '/year-review';

  // ════════════════════════════════════════════════════════════════
  // PARTNER SYNC & ANNUAL REPORT
  // ════════════════════════════════════════════════════════════════
  static const String partner = '/partner';
  static const String annualReport = '/annual-report';

  // ════════════════════════════════════════════════════════════════
  // REFERRAL (Invite Friends & Earn Rewards)
  // ════════════════════════════════════════════════════════════════
  static const String referral = '/referral';

  // ════════════════════════════════════════════════════════════════
  // DEEP LINK ROUTES (innercycles:// scheme)
  // ════════════════════════════════════════════════════════════════
  static const String deepLinkInvite = '/invite/:code';
  static const String deepLinkShare = '/share/:cardId';

  // ════════════════════════════════════════════════════════════════
  // AFFIRMATIONS, EMOTIONAL VOCABULARY
  // ════════════════════════════════════════════════════════════════
  static const String affirmations = '/affirmations';
  static const String emotionalVocabulary = '/emotions';

  // ════════════════════════════════════════════════════════════════
  // STREAK, DREAM ARCHIVE, NOTIFICATIONS, PROGRAM COMPLETION
  // ════════════════════════════════════════════════════════════════
  static const String streakStats = '/streak/stats';
  static const String dreamArchive = '/dreams/archive';
  static const String notifications = '/notifications';
  static const String programCompletion = '/programs/completion';

  // ════════════════════════════════════════════════════════════════
  // APP LOCK
  // ════════════════════════════════════════════════════════════════
  static const String appLock = '/app-lock';

  // ════════════════════════════════════════════════════════════════
  // TAB ROUTES (BottomNavigationBar shell)
  // ════════════════════════════════════════════════════════════════
  static const String today = '/today';
  static const String tools = '/tools';
  static const String challengeHub = '/challenge-hub';
  static const String library = '/library';
  static const String profileHub = '/profile-hub';

  // ════════════════════════════════════════════════════════════════
  // PROFILE & SETTINGS
  // ════════════════════════════════════════════════════════════════
  static const String profile = '/profile';
  // savedProfiles and comparison routes removed (dead code)
  static const String settings = '/settings';
  static const String premium = '/premium';

  // ════════════════════════════════════════════════════════════════
  // ADMIN SYSTEM - PIN Protected Dashboard
  // ════════════════════════════════════════════════════════════════
  static const String adminLogin = '/admin/login';
  static const String admin = '/admin';

  // ════════════════════════════════════════════════════════════════
  // Turkish dream route redirects (backward compatibility)
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
  };
}
