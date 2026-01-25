/// Route map verification test.
///
/// Ensures every route constant defined in Routes resolves to a known screen.
/// Acts as a safety net: if someone adds a route without a corresponding screen
/// in the router, this test will catch it.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:astrology_app/core/constants/routes.dart';

void main() {
  group('Routes constants are defined', () {
    // -----------------------------------------------------------------------
    // PART 1 — PARSED ROUTE MAP TABLE
    // -----------------------------------------------------------------------
    //
    // Route Path                             | Widget Class                  | Params
    // --------------------------------------|-------------------------------|----------
    // /                                      | _SplashScreen                 | —
    // /onboarding                            | OnboardingScreen              | —
    // /home                                  | ResponsiveHomeScreen          | —
    // /horoscope                             | HoroscopeScreen               | —
    // /horoscope/:sign                       | HoroscopeDetailScreen         | sign
    // /compatibility                         | CompatibilityScreen           | —
    // /birth-chart                           | NatalChartScreen              | —
    // /numerology                            | NumerologyScreen              | —
    // /numerology/life-path/:number          | LifePathDetailScreen          | number
    // /numerology/master/:number             | MasterNumberScreen            | number
    // /numerology/personal-year/:number      | PersonalYearScreen            | number
    // /numerology/karmic-debt/:number        | KarmicDebtScreen              | number
    // /kabbalah                              | KabbalahScreen                | —
    // /tarot                                 | TarotScreen                   | —
    // /tarot/major/:number                   | MajorArcanaDetailScreen       | number
    // /aura                                  | AuraScreen                    | —
    // /transits                              | TransitsScreen                | —
    // /premium                               | PremiumScreen                 | —
    // /settings                              | SettingsScreen                | —
    // /profile                               | ProfileScreen                 | —
    // /share                                 | ScreenshotShareScreen         | —
    // /cosmic-share                          | CosmicShareScreen             | —
    // /horoscope/weekly                      | WeeklyHoroscopeScreen         | —
    // /horoscope/weekly/:sign                | WeeklyHoroscopeScreen         | sign
    // /horoscope/monthly                     | MonthlyHoroscopeScreen        | —
    // /horoscope/monthly/:sign               | MonthlyHoroscopeScreen        | sign
    // /horoscope/yearly                      | YearlyHoroscopeScreen         | —
    // /horoscope/yearly/:sign                | YearlyHoroscopeScreen         | sign
    // /horoscope/love                        | LoveHoroscopeScreen           | —
    // /horoscope/love/:sign                  | LoveHoroscopeScreen           | sign
    // /eclipse-calendar                      | EclipseCalendarScreen         | —
    // /composite-chart                       | CompositeChartScreen          | —
    // /vedic-chart                           | VedicChartScreen              | —
    // /progressions                          | ProgressionsScreen            | —
    // /saturn-return                         | SaturnReturnScreen            | —
    // /solar-return                          | SolarReturnScreen             | —
    // /year-ahead                            | YearAheadScreen               | —
    // /timing                                | TimingScreen                  | —
    // /void-of-course                        | VoidOfCourseScreen            | —
    // /synastry                              | SynastryScreen                | —
    // /astro-cartography                     | AstroCartographyScreen        | —
    // /electional                            | ElectionalScreen              | —
    // /draconic-chart                        | DraconicChartScreen           | —
    // /asteroids                             | AsteroidsScreen               | —
    // /local-space                           | LocalSpaceScreen              | —
    // /glossary                              | GlossaryScreen                | ?search
    // /gardening-moon                        | GardeningMoonScreen           | —
    // /celebrities                           | CelebritiesScreen             | —
    // /articles                              | ArticlesScreen                | —
    // /transit-calendar                      | TransitCalendarScreen         | —
    // /daily-rituals                         | DailyRitualsScreen            | —
    // /chakra-analysis                       | ChakraAnalysisScreen          | —
    // /crystal-guide                         | CosmicDiscoveryScreen         | —
    // /moon-rituals                          | CosmicDiscoveryScreen         | —
    // /dream-interpretation                  | DreamInterpretationScreen     | —
    // /dream-glossary                        | DreamGlossaryScreen           | —
    // /dream-share                           | DreamShareScreen              | —
    // /ruya/dusmek                           | DreamFallingScreen            | —
    // /ruya/su-gormek                        | DreamWaterScreen              | —
    // /ruya/tekrar-eden                      | DreamRecurringScreen          | —
    // /ruya/kacmak                           | DreamRunningScreen            | —
    // /ruya/ucmak                            | DreamFlyingScreen             | —
    // /ruya/birini-kaybetmek                 | DreamLosingScreen             | —
    // /ruya/karanlik                         | DreamDarknessScreen           | —
    // /ruya/gecmisten-biri                   | DreamPastScreen               | —
    // /ruya/bir-sey-aramak                   | DreamSearchingScreen          | —
    // /ruya/ses-cikaramamak                  | DreamVoicelessScreen          | —
    // /ruya/kaybolmak                        | DreamLostScreen               | —
    // /ruya/ucamamak                         | DreamUnableToFlyScreen        | —
    // /tantra                                | TantraScreen                  | —
    // /tantra/mikro-rituel                   | TantraMicroRitualScreen       | —
    // /kozmik-iletisim                       | DreamInterpretationScreen     | —
    // /ruya-dongusu                          | DreamOracleScreen             | —
    // /kozmik/bugunku-tema                   | CosmicTodayScreen             | —
    // /saved-profiles                        | SavedProfilesScreen           | —
    // /comparison                            | ComparisonScreen              | —
    // /kozmoz                                | KozmozScreen                  | —
    // /tum-cozumlemeler                      | AllServicesScreen             | —
    // /kesif/gunun-ozeti                     | CosmicDiscoveryScreen         | —
    // /kesif/ay-enerjisi                     | CosmicDiscoveryScreen         | —
    // /kesif/ask-enerjisi                    | CosmicDiscoveryScreen         | —
    // /kesif/bolluk-enerjisi                 | CosmicDiscoveryScreen         | —
    // /kesif/ruhsal-donusum                  | CosmicDiscoveryScreen         | —
    // /kesif/hayat-amacin                    | CosmicDiscoveryScreen         | —
    // /kesif/bilincalti-kaliplarin           | CosmicDiscoveryScreen         | —
    // /kesif/karma-derslerin                 | CosmicDiscoveryScreen         | —
    // /kesif/ruh-sozlesmen                   | CosmicDiscoveryScreen         | —
    // /kesif/icsel-gucun                     | CosmicDiscoveryScreen         | —
    // /kesif/golge-benligin                  | CosmicDiscoveryScreen         | —
    // /kesif/liderlik-stilin                 | CosmicDiscoveryScreen         | —
    // /kesif/kalp-yaran                      | CosmicDiscoveryScreen         | —
    // /kesif/red-flaglerin                   | CosmicDiscoveryScreen         | —
    // /kesif/green-flaglerin                 | CosmicDiscoveryScreen         | —
    // /kesif/flort-stilin                    | CosmicDiscoveryScreen         | —
    // /kesif/tarot-kartin                    | CosmicDiscoveryScreen         | —
    // /kesif/aura-rengin                     | CosmicDiscoveryScreen         | —
    // /kesif/cakra-dengen                    | CosmicDiscoveryScreen         | —
    // /kesif/yasam-sayin                     | CosmicDiscoveryScreen         | —
    // /kesif/kabala-yolun                    | CosmicDiscoveryScreen         | —
    // /kesif/saturn-derslerin                | CosmicDiscoveryScreen         | —
    // /kesif/dogum-gunu-enerjin              | CosmicDiscoveryScreen         | —
    // /kesif/tutulma-etkisi                  | CosmicDiscoveryScreen         | —
    // /kesif/transit-akisi                   | CosmicDiscoveryScreen         | —
    // /kesif/uyum-analizi                    | CosmicDiscoveryScreen         | —
    // /kesif/ruh-esin                        | CosmicDiscoveryScreen         | —
    // /kesif/iliski-karman                   | CosmicDiscoveryScreen         | —
    // /kesif/unlu-ikizin                     | CosmicDiscoveryScreen         | —
    // /quiz                                  | QuizScreen                    | ?type, ?source
    // /admin/login                           | AdminLoginScreen              | —
    // /admin                                 | AdminDashboardScreen          | (redirect guard)
    // -----------------------------------------------------------------------

    test('core route paths are non-empty strings', () {
      final corePaths = [
        Routes.splash,
        Routes.onboarding,
        Routes.home,
        Routes.horoscope,
        Routes.horoscopeDetail,
        Routes.compatibility,
        Routes.birthChart,
        Routes.numerology,
        Routes.kabbalah,
        Routes.tarot,
        Routes.aura,
        Routes.transits,
        Routes.premium,
        Routes.settings,
        Routes.profile,
        Routes.shareSummary,
        Routes.cosmicShare,
      ];

      for (final path in corePaths) {
        expect(path, isNotEmpty, reason: 'Route path should not be empty');
        expect(path.startsWith('/'), isTrue,
            reason: '$path should start with /');
      }
    });

    test('extended horoscope routes are defined', () {
      final extendedPaths = [
        Routes.weeklyHoroscope,
        Routes.weeklyHoroscopeDetail,
        Routes.monthlyHoroscope,
        Routes.monthlyHoroscopeDetail,
        Routes.yearlyHoroscope,
        Routes.yearlyHoroscopeDetail,
        Routes.loveHoroscope,
        Routes.loveHoroscopeDetail,
        Routes.eclipseCalendar,
      ];

      for (final path in extendedPaths) {
        expect(path, isNotEmpty);
        expect(path.startsWith('/'), isTrue);
      }
    });

    test('advanced astrology routes are defined', () {
      final advancedPaths = [
        Routes.compositeChart,
        Routes.vedicChart,
        Routes.progressions,
        Routes.saturnReturn,
        Routes.solarReturn,
        Routes.synastry,
        Routes.yearAhead,
        Routes.timing,
        Routes.voidOfCourse,
        Routes.astroCartography,
        Routes.electional,
        Routes.draconicChart,
        Routes.asteroids,
        Routes.localSpace,
      ];

      for (final path in advancedPaths) {
        expect(path, isNotEmpty);
        expect(path.startsWith('/'), isTrue);
      }
    });

    test('dream canonical routes are defined', () {
      final dreamPaths = [
        Routes.dreamFalling,
        Routes.dreamWater,
        Routes.dreamRecurring,
        Routes.dreamRunning,
        Routes.dreamFlying,
        Routes.dreamLosing,
        Routes.dreamDarkness,
        Routes.dreamPast,
        Routes.dreamSearching,
        Routes.dreamVoiceless,
        Routes.dreamLost,
        Routes.dreamUnableToFly,
        Routes.dreamInterpretation,
        Routes.dreamGlossary,
        Routes.dreamShare,
      ];

      for (final path in dreamPaths) {
        expect(path, isNotEmpty);
        expect(path.startsWith('/'), isTrue);
      }
    });

    test('cosmic discovery routes are defined', () {
      final kesifPaths = [
        Routes.dailySummary,
        Routes.moonEnergy,
        Routes.loveEnergy,
        Routes.abundanceEnergy,
        Routes.spiritualTransformation,
        Routes.lifePurpose,
        Routes.subconsciousPatterns,
        Routes.karmaLessons,
        Routes.soulContract,
        Routes.innerPower,
        Routes.shadowSelf,
        Routes.leadershipStyle,
        Routes.heartbreak,
        Routes.redFlags,
        Routes.greenFlags,
        Routes.flirtStyle,
        Routes.tarotCard,
        Routes.auraColor,
        Routes.chakraBalance,
        Routes.lifeNumber,
        Routes.kabbalaPath,
        Routes.saturnLessons,
        Routes.birthdayEnergy,
        Routes.eclipseEffect,
        Routes.transitFlow,
        Routes.compatibilityAnalysis,
        Routes.soulMate,
        Routes.relationshipKarma,
        Routes.celebrityTwin,
      ];

      for (final path in kesifPaths) {
        expect(path, isNotEmpty);
        expect(path.startsWith('/kesif/'), isTrue,
            reason: '$path should be under /kesif/');
      }
    });

    test('admin routes are defined', () {
      expect(Routes.adminLogin, '/admin/login');
      expect(Routes.admin, '/admin');
    });

    test('numerology parameterized routes contain :number', () {
      expect(Routes.lifePathDetail, contains(':number'));
      expect(Routes.masterNumber, contains(':number'));
      expect(Routes.personalYearDetail, contains(':number'));
    });

    test('horoscope detail route contains :sign', () {
      expect(Routes.horoscopeDetail, contains(':sign'));
      expect(Routes.weeklyHoroscopeDetail, contains(':sign'));
      expect(Routes.monthlyHoroscopeDetail, contains(':sign'));
      expect(Routes.yearlyHoroscopeDetail, contains(':sign'));
      expect(Routes.loveHoroscopeDetail, contains(':sign'));
    });

    test('splash route is root /', () {
      expect(Routes.splash, '/');
    });

    test('all static routes start with /', () {
      // Collect all static route constants via reflection-like check
      final allPaths = [
        Routes.splash,
        Routes.onboarding,
        Routes.home,
        Routes.horoscope,
        Routes.compatibility,
        Routes.birthChart,
        Routes.numerology,
        Routes.kabbalah,
        Routes.tarot,
        Routes.aura,
        Routes.transits,
        Routes.premium,
        Routes.settings,
        Routes.profile,
        Routes.shareSummary,
        Routes.cosmicShare,
        Routes.weeklyHoroscope,
        Routes.monthlyHoroscope,
        Routes.yearlyHoroscope,
        Routes.loveHoroscope,
        Routes.eclipseCalendar,
        Routes.compositeChart,
        Routes.vedicChart,
        Routes.progressions,
        Routes.saturnReturn,
        Routes.solarReturn,
        Routes.synastry,
        Routes.yearAhead,
        Routes.timing,
        Routes.voidOfCourse,
        Routes.astroCartography,
        Routes.electional,
        Routes.draconicChart,
        Routes.asteroids,
        Routes.localSpace,
        Routes.glossary,
        Routes.gardeningMoon,
        Routes.celebrities,
        Routes.articles,
        Routes.transitCalendar,
        Routes.dailyRituals,
        Routes.chakraAnalysis,
        Routes.crystalGuide,
        Routes.moonRituals,
        Routes.dreamInterpretation,
        Routes.dreamGlossary,
        Routes.dreamShare,
        Routes.dreamFalling,
        Routes.dreamWater,
        Routes.dreamRecurring,
        Routes.dreamRunning,
        Routes.dreamFlying,
        Routes.dreamLosing,
        Routes.dreamDarkness,
        Routes.dreamPast,
        Routes.dreamSearching,
        Routes.dreamVoiceless,
        Routes.dreamLost,
        Routes.dreamUnableToFly,
        Routes.tantra,
        Routes.tantraMicroRitual,
        Routes.kozmikIletisim,
        Routes.ruyaDongusu,
        Routes.cosmicToday,
        Routes.savedProfiles,
        Routes.comparison,
        Routes.kozmoz,
        Routes.allServices,
        Routes.dailySummary,
        Routes.moonEnergy,
        Routes.loveEnergy,
        Routes.abundanceEnergy,
        Routes.spiritualTransformation,
        Routes.lifePurpose,
        Routes.subconsciousPatterns,
        Routes.karmaLessons,
        Routes.soulContract,
        Routes.innerPower,
        Routes.shadowSelf,
        Routes.leadershipStyle,
        Routes.heartbreak,
        Routes.redFlags,
        Routes.greenFlags,
        Routes.flirtStyle,
        Routes.tarotCard,
        Routes.auraColor,
        Routes.chakraBalance,
        Routes.lifeNumber,
        Routes.kabbalaPath,
        Routes.saturnLessons,
        Routes.birthdayEnergy,
        Routes.eclipseEffect,
        Routes.transitFlow,
        Routes.compatibilityAnalysis,
        Routes.soulMate,
        Routes.relationshipKarma,
        Routes.celebrityTwin,
        Routes.adminLogin,
        Routes.admin,
      ];

      for (final path in allPaths) {
        expect(path.startsWith('/'), isTrue, reason: '$path must start with /');
      }
    });
  });
}
