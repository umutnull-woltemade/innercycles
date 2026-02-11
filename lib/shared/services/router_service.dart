// ════════════════════════════════════════════════════════════════════════════
// ROUTER SERVICE - InnerCycles Navigation (App Store 4.3(b) Compliant)
// ════════════════════════════════════════════════════════════════════════════
// This router has been refactored to remove all astrology/horoscope routes
// for App Store compliance. Only journaling, wellness, and reflection features
// are included.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/routes.dart';
import '../../features/disclaimer/presentation/disclaimer_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/responsive_home_screen.dart';
import '../../features/numerology/presentation/numerology_screen.dart';
import '../../features/kabbalah/presentation/kabbalah_screen.dart';
import '../../features/tarot/presentation/tarot_screen.dart';
import '../../features/aura/presentation/aura_screen.dart';
import '../../features/premium/presentation/premium_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/share/presentation/cosmic_share_screen.dart';
import '../../features/share/presentation/screenshot_share_screen.dart';
import '../../features/glossary/presentation/glossary_screen.dart';
import '../../features/gardening/presentation/gardening_moon_screen.dart';
import '../../features/celebrities/presentation/celebrities_screen.dart';
import '../../features/articles/presentation/articles_screen.dart';
import '../../features/rituals/presentation/daily_rituals_screen.dart';
import '../../features/chakra/presentation/chakra_analysis_screen.dart';
import '../../features/profile/presentation/saved_profiles_screen.dart';
import '../../features/profile/presentation/comparison_screen.dart';
import '../../features/kozmoz/presentation/kozmoz_screen.dart';
import '../../features/insight/presentation/insight_screen.dart';
import '../../features/dreams/presentation/dream_interpretation_screen.dart';
import '../../features/dreams/presentation/dream_glossary_screen.dart';
import '../../features/dreams/presentation/dream_share_screen.dart';
import '../../features/dreams/presentation/canonical/dream_falling_screen.dart';
import '../../features/dreams/presentation/canonical/dream_water_screen.dart';
import '../../features/dreams/presentation/canonical/dream_recurring_screen.dart';
import '../../features/dreams/presentation/canonical/dream_running_screen.dart';
import '../../features/dreams/presentation/canonical/dream_flying_screen.dart';
import '../../features/dreams/presentation/canonical/dream_losing_screen.dart';
import '../../features/dreams/presentation/canonical/dream_darkness_screen.dart';
import '../../features/dreams/presentation/canonical/dream_past_screen.dart';
import '../../features/dreams/presentation/canonical/dream_searching_screen.dart';
import '../../features/dreams/presentation/canonical/dream_voiceless_screen.dart';
import '../../features/dreams/presentation/canonical/dream_lost_screen.dart';
import '../../features/dreams/presentation/canonical/dream_unable_to_fly_screen.dart';
import '../../features/tantra/presentation/tantra_screen.dart';
import '../../features/theta_healing/presentation/theta_healing_screen.dart';
import '../../features/reiki/presentation/reiki_screen.dart';
import '../../features/kozmik/presentation/canonical/cosmic_today_screen.dart';
import '../../features/tantra/presentation/canonical/tantra_micro_ritual_screen.dart';
import '../../features/tarot/presentation/major_arcana_detail_screen.dart';
import '../../features/numerology/presentation/life_path_detail_screen.dart';
import '../../features/numerology/presentation/master_number_screen.dart';
import '../../features/all_services/presentation/all_services_screen.dart';
import '../../features/journal/presentation/daily_entry_screen.dart';
import '../../features/journal/presentation/entry_detail_screen.dart';
import '../../features/journal/presentation/patterns_screen.dart';
import '../../features/journal/presentation/archive_screen.dart';
import '../../features/journal/presentation/monthly_reflection_screen.dart';
import '../../features/admin/presentation/admin_login_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/observatory/presentation/observatory_screen.dart';
import '../../features/quiz/presentation/quiz_screen.dart';
import '../../features/content/presentation/content_detail_screen.dart';
import '../../data/services/admin_auth_service.dart';
import '../../data/services/storage_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.disclaimer,
    errorBuilder: (context, state) => _NotFoundScreen(path: state.uri.path),
    redirect: (context, state) {
      final path = state.uri.path;

      // Allow splash, disclaimer, and onboarding without guard
      if (path == Routes.splash ||
          path == Routes.disclaimer ||
          path == Routes.onboarding) {
        return null;
      }

      // Allow admin routes without onboarding
      if (path.startsWith('/admin')) {
        return null;
      }

      // WEB: Skip storage check - web has no persistence (memory-only mode)
      if (kIsWeb) {
        return null;
      }

      // MOBILE: First-launch disclaimer check (App Store compliance)
      final disclaimerAccepted = StorageService.loadDisclaimerAccepted();
      if (!disclaimerAccepted) {
        return Routes.disclaimer;
      }

      // MOBILE: Guard - redirect to onboarding if not completed
      final onboardingDone = StorageService.loadOnboardingComplete();
      if (!onboardingDone) {
        return Routes.onboarding;
      }

      return null;
    },
    routes: [
      // ════════════════════════════════════════════════════════════════
      // CORE ROUTES
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: Routes.disclaimer,
        builder: (context, state) => const DisclaimerScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const ResponsiveHomeScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // INSIGHT - Apple-Safe Personal Reflection Assistant
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.insight,
        builder: (context, state) => const InsightScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // NUMEROLOGY (Educational, Pattern-Based)
      // ════════════════════════════════════════════════════════════════
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

      // ════════════════════════════════════════════════════════════════
      // KABBALAH (Spiritual Education)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.kabbalah,
        builder: (context, state) => const KabbalahScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // TAROT (Symbol Education)
      // ════════════════════════════════════════════════════════════════
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

      // ════════════════════════════════════════════════════════════════
      // WELLNESS & MINDFULNESS
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.aura,
        builder: (context, state) => const AuraScreen(),
      ),
      GoRoute(
        path: Routes.chakraAnalysis,
        builder: (context, state) => const ChakraAnalysisScreen(),
      ),
      GoRoute(
        path: Routes.dailyRituals,
        builder: (context, state) => const DailyRitualsScreen(),
      ),
      GoRoute(
        path: Routes.tantra,
        builder: (context, state) => const TantraScreen(),
      ),
      GoRoute(
        path: Routes.thetaHealing,
        builder: (context, state) => const ThetaHealingScreen(),
      ),
      GoRoute(
        path: Routes.reiki,
        builder: (context, state) => const ReikiScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // DREAM JOURNAL & INTERPRETATION
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.dreamInterpretation,
        builder: (context, state) => const DreamInterpretationScreen(),
      ),
      GoRoute(
        path: Routes.dreamGlossary,
        builder: (context, state) => const DreamGlossaryScreen(),
      ),
      GoRoute(
        path: Routes.dreamShare,
        builder: (context, state) => const DreamShareScreen(),
      ),

      // Dream Trace - Canonical Dream Pages
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

      // ════════════════════════════════════════════════════════════════
      // COSMIC & TANTRA CANONICAL PAGES
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.cosmicToday,
        builder: (context, state) => const CosmicTodayScreen(),
      ),
      GoRoute(
        path: Routes.cosmicEnergy,
        builder: (context, state) => const CosmicTodayScreen(),
      ),
      GoRoute(
        path: Routes.cosmicEmotion,
        builder: (context, state) => const CosmicTodayScreen(),
      ),
      GoRoute(
        path: Routes.tantraMicroRitual,
        builder: (context, state) => const TantraMicroRitualScreen(),
      ),
      GoRoute(
        path: Routes.tantraBreath,
        builder: (context, state) => const TantraMicroRitualScreen(),
      ),
      GoRoute(
        path: Routes.tantraIntention,
        builder: (context, state) => const TantraMicroRitualScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // JOURNAL - Personal Cycle Tracking (PRIMARY FEATURE)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.journal,
        builder: (context, state) => const DailyEntryScreen(),
      ),
      GoRoute(
        path: Routes.journalEntryDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return EntryDetailScreen(entryId: id);
        },
      ),
      GoRoute(
        path: Routes.journalPatterns,
        builder: (context, state) => const PatternsScreen(),
      ),
      GoRoute(
        path: Routes.journalMonthly,
        builder: (context, state) => const MonthlyReflectionScreen(),
      ),
      GoRoute(
        path: Routes.journalArchive,
        builder: (context, state) => const ArchiveScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // REFERENCE & EDUCATIONAL CONTENT
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.glossary,
        builder: (context, state) => const GlossaryScreen(),
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

      // ════════════════════════════════════════════════════════════════
      // PROFILE & SETTINGS
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.savedProfiles,
        builder: (context, state) => const SavedProfilesScreen(),
      ),
      GoRoute(
        path: Routes.comparison,
        builder: (context, state) => const ComparisonScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.premium,
        builder: (context, state) => const PremiumScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // SHARING
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.shareSummary,
        builder: (context, state) => const ScreenshotShareScreen(),
      ),
      GoRoute(
        path: Routes.cosmicShare,
        builder: (context, state) => const CosmicShareScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // ALL SERVICES CATALOG
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.allServices,
        builder: (context, state) => const AllServicesScreen(),
      ),
      GoRoute(
        path: Routes.kozmoz,
        builder: (context, state) => const KozmozScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // QUIZ
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: '/quiz/:type',
        builder: (context, state) {
          final type = state.pathParameters['type'] ?? 'personality';
          return QuizScreen(quizType: type);
        },
      ),

      // ════════════════════════════════════════════════════════════════
      // CONTENT DETAIL (Generic)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: '/content/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ContentDetailScreen(contentId: id);
        },
      ),

      // ════════════════════════════════════════════════════════════════
      // ADMIN SYSTEM
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.adminLogin,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: Routes.admin,
        redirect: (context, state) {
          if (!AdminAuthService.isAuthenticated) {
            return Routes.adminLogin;
          }
          return null;
        },
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: Routes.observatory,
        redirect: (context, state) {
          if (!AdminAuthService.isAuthenticated) {
            return Routes.adminLogin;
          }
          return null;
        },
        builder: (context, state) => const ObservatoryScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // LEGACY ROUTE REDIRECTS (SEO backward compatibility)
      // ════════════════════════════════════════════════════════════════
      // Turkish dream routes redirect to English equivalents
      GoRoute(
        path: '/ruya/dusmek',
        redirect: (context, state) => Routes.dreamFalling,
      ),
      GoRoute(
        path: '/ruya/su-gormek',
        redirect: (context, state) => Routes.dreamWater,
      ),
      GoRoute(
        path: '/ruya/tekrar-eden',
        redirect: (context, state) => Routes.dreamRecurring,
      ),
      GoRoute(
        path: '/ruya/kacmak',
        redirect: (context, state) => Routes.dreamRunning,
      ),
      GoRoute(
        path: '/ruya/ucmak',
        redirect: (context, state) => Routes.dreamFlying,
      ),
      GoRoute(
        path: '/ruya/birini-kaybetmek',
        redirect: (context, state) => Routes.dreamLosing,
      ),
      GoRoute(
        path: '/ruya/karanlik',
        redirect: (context, state) => Routes.dreamDarkness,
      ),
      GoRoute(
        path: '/ruya/gecmisten-biri',
        redirect: (context, state) => Routes.dreamPast,
      ),
      GoRoute(
        path: '/ruya/bir-sey-aramak',
        redirect: (context, state) => Routes.dreamSearching,
      ),
      GoRoute(
        path: '/ruya/ses-cikaramamak',
        redirect: (context, state) => Routes.dreamVoiceless,
      ),
      GoRoute(
        path: '/ruya/kaybolmak',
        redirect: (context, state) => Routes.dreamLost,
      ),
      GoRoute(
        path: '/ruya/ucamamak',
        redirect: (context, state) => Routes.dreamUnableToFly,
      ),

      // Cosmic routes redirect to insight (safe alternative)
      GoRoute(
        path: '/kozmik/bugunku-tema',
        redirect: (context, state) => Routes.insight,
      ),
      GoRoute(
        path: '/kozmik/bugunku-enerji',
        redirect: (context, state) => Routes.insight,
      ),
      GoRoute(
        path: '/kozmik/one-cikan-duygu',
        redirect: (context, state) => Routes.insight,
      ),

      // All astrology/horoscope routes redirect to insight
      GoRoute(
        path: '/horoscope',
        redirect: (context, state) => Routes.insight,
      ),
      GoRoute(
        path: '/horoscope/:sign',
        redirect: (context, state) => Routes.insight,
      ),
      GoRoute(
        path: '/compatibility',
        redirect: (context, state) => Routes.insight,
      ),
      GoRoute(
        path: '/birth-chart',
        redirect: (context, state) => Routes.insight,
      ),
      GoRoute(
        path: '/transits',
        redirect: (context, state) => Routes.insight,
      ),
    ],
  );
});

// ════════════════════════════════════════════════════════════════════════════
// SPLASH SCREEN (Internal)
// ════════════════════════════════════════════════════════════════════════════

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.self_improvement,
              size: 80,
              color: Colors.white,
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            const SizedBox(height: 24),
            Text(
              'InnerCycles',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4,
                  ),
            ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
            const SizedBox(height: 8),
            Text(
              'Personal Reflection Journal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white54,
                    letterSpacing: 2,
                  ),
            ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// NOT FOUND SCREEN
// ════════════════════════════════════════════════════════════════════════════

class _NotFoundScreen extends StatelessWidget {
  final String path;

  const _NotFoundScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.explore_off,
              size: 64,
              color: Colors.white38,
            ),
            const SizedBox(height: 24),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              path,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white38,
                    fontFamily: 'monospace',
                  ),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => context.go(Routes.home),
              icon: const Icon(Icons.home, color: Colors.white70),
              label: const Text(
                'Go Home',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
