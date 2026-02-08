/// Shared GoRouter configuration for route-aware tests.
///
/// Mirrors the REAL router in router_service.dart — same paths, same widgets.
/// Used by integration-style widget tests that need navigation.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:astrology_app/core/constants/routes.dart';
import 'package:astrology_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:astrology_app/features/home/presentation/responsive_home_screen.dart';
import 'package:astrology_app/features/horoscope/presentation/horoscope_screen.dart';
import 'package:astrology_app/features/horoscope/presentation/horoscope_detail_screen.dart';
import 'package:astrology_app/features/compatibility/presentation/compatibility_screen.dart';
import 'package:astrology_app/features/natal_chart/presentation/natal_chart_screen.dart';
import 'package:astrology_app/features/numerology/presentation/numerology_screen.dart';
import 'package:astrology_app/features/numerology/presentation/life_path_detail_screen.dart';
import 'package:astrology_app/features/numerology/presentation/master_number_screen.dart';
import 'package:astrology_app/features/numerology/presentation/personal_year_screen.dart';
import 'package:astrology_app/features/numerology/presentation/karmic_debt_screen.dart';
import 'package:astrology_app/features/kabbalah/presentation/kabbalah_screen.dart';
import 'package:astrology_app/features/tarot/presentation/tarot_screen.dart';
import 'package:astrology_app/features/tarot/presentation/major_arcana_detail_screen.dart';
import 'package:astrology_app/features/aura/presentation/aura_screen.dart';
import 'package:astrology_app/features/transits/presentation/transits_screen.dart';
import 'package:astrology_app/features/premium/presentation/premium_screen.dart';
import 'package:astrology_app/features/settings/presentation/settings_screen.dart';
import 'package:astrology_app/features/profile/presentation/profile_screen.dart';
import 'package:astrology_app/features/profile/presentation/saved_profiles_screen.dart';
import 'package:astrology_app/features/profile/presentation/comparison_screen.dart';
import 'package:astrology_app/features/share/presentation/screenshot_share_screen.dart';
import 'package:astrology_app/features/share/presentation/cosmic_share_screen.dart';
import 'package:astrology_app/features/horoscopes/presentation/weekly_horoscope_screen.dart';
import 'package:astrology_app/features/horoscopes/presentation/monthly_horoscope_screen.dart';
import 'package:astrology_app/features/horoscopes/presentation/yearly_horoscope_screen.dart';
import 'package:astrology_app/features/horoscopes/presentation/love_horoscope_screen.dart';
import 'package:astrology_app/features/horoscopes/presentation/eclipse_calendar_screen.dart';
import 'package:astrology_app/features/compatibility/presentation/composite_chart_screen.dart';
import 'package:astrology_app/features/vedic/presentation/vedic_chart_screen.dart';
import 'package:astrology_app/features/predictive/presentation/progressions_screen.dart';
import 'package:astrology_app/features/saturn_return/presentation/saturn_return_screen.dart';
import 'package:astrology_app/features/solar_return/presentation/solar_return_screen.dart';
import 'package:astrology_app/features/year_ahead/presentation/year_ahead_screen.dart';
import 'package:astrology_app/features/timing/presentation/timing_screen.dart';
import 'package:astrology_app/features/timing/presentation/void_of_course_screen.dart';
import 'package:astrology_app/features/synastry/presentation/synastry_screen.dart';
import 'package:astrology_app/features/astrocartography/presentation/astrocartography_screen.dart';
import 'package:astrology_app/features/electional/presentation/electional_screen.dart';
import 'package:astrology_app/features/draconic/presentation/draconic_chart_screen.dart';
import 'package:astrology_app/features/asteroids/presentation/asteroids_screen.dart';
import 'package:astrology_app/features/local_space/presentation/local_space_screen.dart';
import 'package:astrology_app/features/glossary/presentation/glossary_screen.dart';
import 'package:astrology_app/features/gardening/presentation/gardening_moon_screen.dart';
import 'package:astrology_app/features/celebrities/presentation/celebrities_screen.dart';
import 'package:astrology_app/features/articles/presentation/articles_screen.dart';
import 'package:astrology_app/features/transits/presentation/transit_calendar_screen.dart';
import 'package:astrology_app/features/rituals/presentation/daily_rituals_screen.dart';
import 'package:astrology_app/features/chakra/presentation/chakra_analysis_screen.dart';
import 'package:astrology_app/features/cosmic_discovery/presentation/cosmic_discovery_screen.dart';
import 'package:astrology_app/features/dreams/presentation/dream_interpretation_screen.dart';
import 'package:astrology_app/features/dreams/presentation/dream_glossary_screen.dart';
import 'package:astrology_app/features/insight/presentation/insight_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_falling_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_water_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_recurring_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_running_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_flying_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_losing_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_darkness_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_past_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_searching_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_voiceless_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_lost_screen.dart';
import 'package:astrology_app/features/dreams/presentation/canonical/dream_unable_to_fly_screen.dart';
import 'package:astrology_app/features/tantra/presentation/tantra_screen.dart';
import 'package:astrology_app/features/tantra/presentation/canonical/tantra_micro_ritual_screen.dart';
import 'package:astrology_app/features/kozmik/presentation/canonical/cosmic_today_screen.dart';
import 'package:astrology_app/features/kozmoz/presentation/kozmoz_screen.dart';
import 'package:astrology_app/features/all_services/presentation/all_services_screen.dart';
import 'package:astrology_app/features/quiz/presentation/quiz_screen.dart';
import 'package:astrology_app/features/admin/presentation/admin_login_screen.dart';
import 'package:astrology_app/features/admin/presentation/admin_dashboard_screen.dart';

/// Build a GoRouter with the same route table as the production app.
/// [initialLocation] overrides the starting path (defaults to /home).
GoRouter buildTestRouter({String initialLocation = '/home'}) {
  return GoRouter(
    initialLocation: initialLocation,
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('404 — ${state.uri.path}')),
    ),
    routes: _testRoutes,
  );
}

final List<RouteBase> _testRoutes = [
  GoRoute(
    path: Routes.onboarding,
    builder: (context, state) => const OnboardingScreen(),
  ),
  GoRoute(
    path: Routes.home,
    builder: (context, state) => const ResponsiveHomeScreen(),
  ),
  GoRoute(
    path: Routes.horoscope,
    builder: (context, state) => const HoroscopeScreen(),
  ),
  GoRoute(
    path: Routes.horoscopeDetail,
    builder: (context, state) {
      final sign = state.pathParameters['sign'] ?? 'aries';
      return HoroscopeDetailScreen(signName: sign);
    },
  ),
  GoRoute(
    path: Routes.compatibility,
    builder: (context, state) => const CompatibilityScreen(),
  ),
  GoRoute(
    path: Routes.birthChart,
    builder: (context, state) => const NatalChartScreen(),
  ),
  GoRoute(
    path: Routes.numerology,
    builder: (context, state) => const NumerologyScreen(),
  ),
  GoRoute(
    path: Routes.lifePathDetail,
    builder: (context, state) {
      final number =
          int.tryParse(state.pathParameters['number'] ?? '1') ?? 1;
      return LifePathDetailScreen(number: number);
    },
  ),
  GoRoute(
    path: Routes.masterNumber,
    builder: (context, state) {
      final number =
          int.tryParse(state.pathParameters['number'] ?? '11') ?? 11;
      return MasterNumberScreen(number: number);
    },
  ),
  GoRoute(
    path: Routes.personalYearDetail,
    builder: (context, state) {
      final number =
          int.tryParse(state.pathParameters['number'] ?? '1') ?? 1;
      return PersonalYearScreen(year: number);
    },
  ),
  GoRoute(
    path: '/numerology/karmic-debt/:number',
    builder: (context, state) {
      final number =
          int.tryParse(state.pathParameters['number'] ?? '13') ?? 13;
      return KarmicDebtScreen(debtNumber: number);
    },
  ),
  GoRoute(
    path: Routes.kabbalah,
    builder: (context, state) => const KabbalahScreen(),
  ),
  GoRoute(
    path: Routes.tarot,
    builder: (context, state) => const TarotScreen(),
  ),
  GoRoute(
    path: '/tarot/major/:number',
    builder: (context, state) {
      final number =
          int.tryParse(state.pathParameters['number'] ?? '0') ?? 0;
      return MajorArcanaDetailScreen(cardNumber: number);
    },
  ),
  GoRoute(
    path: Routes.aura,
    builder: (context, state) => const AuraScreen(),
  ),
  GoRoute(
    path: Routes.transits,
    builder: (context, state) => const TransitsScreen(),
  ),
  GoRoute(
    path: Routes.premium,
    builder: (context, state) => const PremiumScreen(),
  ),
  GoRoute(
    path: Routes.settings,
    builder: (context, state) => const SettingsScreen(),
  ),
  GoRoute(
    path: Routes.profile,
    builder: (context, state) => const ProfileScreen(),
  ),
  GoRoute(
    path: Routes.shareSummary,
    builder: (context, state) => const ScreenshotShareScreen(),
  ),
  GoRoute(
    path: Routes.cosmicShare,
    builder: (context, state) => const CosmicShareScreen(),
  ),
  // Extended Horoscopes
  GoRoute(
    path: Routes.weeklyHoroscope,
    builder: (context, state) => const WeeklyHoroscopeScreen(),
  ),
  GoRoute(
    path: Routes.weeklyHoroscopeDetail,
    builder: (context, state) {
      final sign = state.pathParameters['sign'] ?? 'aries';
      return WeeklyHoroscopeScreen(signName: sign);
    },
  ),
  GoRoute(
    path: Routes.monthlyHoroscope,
    builder: (context, state) => const MonthlyHoroscopeScreen(),
  ),
  GoRoute(
    path: Routes.monthlyHoroscopeDetail,
    builder: (context, state) {
      final sign = state.pathParameters['sign'] ?? 'aries';
      return MonthlyHoroscopeScreen(signName: sign);
    },
  ),
  GoRoute(
    path: Routes.yearlyHoroscope,
    builder: (context, state) => const YearlyHoroscopeScreen(),
  ),
  GoRoute(
    path: Routes.yearlyHoroscopeDetail,
    builder: (context, state) {
      final sign = state.pathParameters['sign'] ?? 'aries';
      return YearlyHoroscopeScreen(signName: sign);
    },
  ),
  GoRoute(
    path: Routes.loveHoroscope,
    builder: (context, state) => const LoveHoroscopeScreen(),
  ),
  GoRoute(
    path: Routes.loveHoroscopeDetail,
    builder: (context, state) {
      final sign = state.pathParameters['sign'] ?? 'aries';
      return LoveHoroscopeScreen(signName: sign);
    },
  ),
  GoRoute(
    path: Routes.eclipseCalendar,
    builder: (context, state) => const EclipseCalendarScreen(),
  ),
  // Advanced Astrology
  GoRoute(
    path: Routes.compositeChart,
    builder: (context, state) => const CompositeChartScreen(),
  ),
  GoRoute(
    path: Routes.vedicChart,
    builder: (context, state) => const VedicChartScreen(),
  ),
  GoRoute(
    path: Routes.progressions,
    builder: (context, state) => const ProgressionsScreen(),
  ),
  GoRoute(
    path: Routes.saturnReturn,
    builder: (context, state) => const SaturnReturnScreen(),
  ),
  GoRoute(
    path: Routes.solarReturn,
    builder: (context, state) => const SolarReturnScreen(),
  ),
  GoRoute(
    path: Routes.yearAhead,
    builder: (context, state) => const YearAheadScreen(),
  ),
  GoRoute(
    path: Routes.timing,
    builder: (context, state) => const TimingScreen(),
  ),
  GoRoute(
    path: Routes.voidOfCourse,
    builder: (context, state) => const VoidOfCourseScreen(),
  ),
  GoRoute(
    path: Routes.synastry,
    builder: (context, state) => const SynastryScreen(),
  ),
  // Premium Features
  GoRoute(
    path: Routes.astroCartography,
    builder: (context, state) => const AstroCartographyScreen(),
  ),
  GoRoute(
    path: Routes.electional,
    builder: (context, state) => const ElectionalScreen(),
  ),
  GoRoute(
    path: Routes.draconicChart,
    builder: (context, state) => const DraconicChartScreen(),
  ),
  GoRoute(
    path: Routes.asteroids,
    builder: (context, state) => const AsteroidsScreen(),
  ),
  GoRoute(
    path: Routes.localSpace,
    builder: (context, state) => const LocalSpaceScreen(),
  ),
  // Reference & Content
  GoRoute(
    path: Routes.glossary,
    builder: (context, state) {
      final search = state.uri.queryParameters['search'];
      return GlossaryScreen(initialSearch: search);
    },
  ),
  GoRoute(
    path: Routes.gardeningMoon,
    builder: (context, state) => const GardeningMoonScreen(),
  ),
  GoRoute(
    path: Routes.celebrities,
    builder: (context, state) => const CelebritiesScreen(),
  ),
  GoRoute(
    path: Routes.articles,
    builder: (context, state) => const ArticlesScreen(),
  ),
  GoRoute(
    path: Routes.transitCalendar,
    builder: (context, state) => const TransitCalendarScreen(),
  ),
  // Spiritual & Wellness
  GoRoute(
    path: Routes.dailyRituals,
    builder: (context, state) => const DailyRitualsScreen(),
  ),
  GoRoute(
    path: Routes.chakraAnalysis,
    builder: (context, state) => const ChakraAnalysisScreen(),
  ),
  GoRoute(
    path: Routes.crystalGuide,
    builder: (context, state) => const CosmicDiscoveryScreen(
      title: 'Kristal Rehberi',
      subtitle: 'Şifalı taşların enerjisi',
      emoji: '💎',
      primaryColor: Color(0xFF9D4EDD),
      type: CosmicDiscoveryType.auraColor,
    ),
  ),
  GoRoute(
    path: Routes.moonRituals,
    builder: (context, state) => const CosmicDiscoveryScreen(
      title: 'Ay Ritüelleri',
      subtitle: 'Ayın döngüsüyle uyum',
      emoji: '🌕',
      primaryColor: Color(0xFFC0C0C0),
      type: CosmicDiscoveryType.moonEnergy,
    ),
  ),
  // Dreams
  GoRoute(
    path: Routes.dreamInterpretation,
    builder: (context, state) => const DreamInterpretationScreen(),
  ),
  GoRoute(
    path: Routes.dreamGlossary,
    builder: (context, state) => const DreamGlossaryScreen(),
  ),
  GoRoute(
    path: Routes.dreamFalling,
    builder: (context, state) => const DreamFallingScreen(),
  ),
  GoRoute(
    path: Routes.dreamWater,
    builder: (context, state) => const DreamWaterScreen(),
  ),
  GoRoute(
    path: Routes.dreamRecurring,
    builder: (context, state) => const DreamRecurringScreen(),
  ),
  GoRoute(
    path: Routes.dreamRunning,
    builder: (context, state) => const DreamRunningScreen(),
  ),
  GoRoute(
    path: Routes.dreamFlying,
    builder: (context, state) => const DreamFlyingScreen(),
  ),
  GoRoute(
    path: Routes.dreamLosing,
    builder: (context, state) => const DreamLosingScreen(),
  ),
  GoRoute(
    path: Routes.dreamDarkness,
    builder: (context, state) => const DreamDarknessScreen(),
  ),
  GoRoute(
    path: Routes.dreamPast,
    builder: (context, state) => const DreamPastScreen(),
  ),
  GoRoute(
    path: Routes.dreamSearching,
    builder: (context, state) => const DreamSearchingScreen(),
  ),
  GoRoute(
    path: Routes.dreamVoiceless,
    builder: (context, state) => const DreamVoicelessScreen(),
  ),
  GoRoute(
    path: Routes.dreamLost,
    builder: (context, state) => const DreamLostScreen(),
  ),
  GoRoute(
    path: Routes.dreamUnableToFly,
    builder: (context, state) => const DreamUnableToFlyScreen(),
  ),
  // Tantra
  GoRoute(
    path: Routes.tantra,
    builder: (context, state) => const TantraScreen(),
  ),
  GoRoute(
    path: Routes.tantraMicroRitual,
    builder: (context, state) => const TantraMicroRitualScreen(),
  ),
  // Insight - unified entry point for reflection (App Store 4.3(b) compliant)
  GoRoute(
    path: Routes.insight,
    builder: (context, state) => const InsightScreen(),
  ),
  // Deprecated routes redirect to Insight
  GoRoute(
    path: Routes.kozmikIletisim,
    redirect: (context, state) => Routes.insight,
  ),
  GoRoute(
    path: Routes.ruyaDongusu,
    redirect: (context, state) => Routes.insight,
  ),
  GoRoute(
    path: Routes.cosmicToday,
    builder: (context, state) => const CosmicTodayScreen(),
  ),
  // Profile Management
  GoRoute(
    path: Routes.savedProfiles,
    builder: (context, state) => const SavedProfilesScreen(),
  ),
  GoRoute(
    path: Routes.comparison,
    builder: (context, state) => const ComparisonScreen(),
  ),
  // Hubs
  GoRoute(
    path: Routes.kozmoz,
    builder: (context, state) => const KozmozScreen(),
  ),
  GoRoute(
    path: Routes.allServices,
    builder: (context, state) => const AllServicesScreen(),
  ),
  // Cosmic Discovery (sample)
  GoRoute(
    path: Routes.dailySummary,
    builder: (context, state) => const CosmicDiscoveryScreen(
      title: 'Bugünün Özeti',
      subtitle: 'Kozmik enerjilerin günlük rehberin',
      emoji: '☀️',
      primaryColor: Color(0xFFFFD700),
      type: CosmicDiscoveryType.dailySummary,
    ),
  ),
  // Quiz
  GoRoute(
    path: '/quiz',
    builder: (context, state) {
      final quizType = state.uri.queryParameters['type'] ?? 'general';
      final source = state.uri.queryParameters['source'];
      return QuizScreen(quizType: quizType, sourceContext: source);
    },
  ),
  // Admin
  GoRoute(
    path: Routes.adminLogin,
    builder: (context, state) => const AdminLoginScreen(),
  ),
  GoRoute(
    path: Routes.admin,
    builder: (context, state) => const AdminDashboardScreen(),
  ),
];

/// Expose the raw route list for tests that need to build custom routers.
List<RouteBase> get testRoutes => _testRoutes;
