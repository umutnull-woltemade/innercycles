// ════════════════════════════════════════════════════════════════════════════
// ROUTER SERVICE - InnerCycles Navigation (App Store 4.3(b) Compliant)
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
import '../../features/premium/presentation/premium_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/saved_profiles_screen.dart';
import '../../features/profile/presentation/comparison_screen.dart';
import '../../features/glossary/presentation/glossary_screen.dart';
import '../../features/articles/presentation/articles_screen.dart';
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
import '../../features/journal/presentation/daily_entry_screen.dart';
import '../../features/journal/presentation/entry_detail_screen.dart';
import '../../features/journal/presentation/patterns_screen.dart';
import '../../features/journal/presentation/archive_screen.dart';
import '../../features/journal/presentation/monthly_reflection_screen.dart';
import '../../features/admin/presentation/admin_login_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/quiz/presentation/attachment_quiz_screen.dart';
import '../../features/sharing/presentation/share_insight_screen.dart';
import '../../features/journal/presentation/emotional_cycle_screen.dart';
import '../../features/growth/presentation/growth_dashboard_screen.dart';
import '../../features/rituals/presentation/rituals_screen.dart';
import '../../features/rituals/presentation/ritual_create_screen.dart';
import '../../features/wellness/presentation/wellness_detail_screen.dart';
import '../../features/energy/presentation/energy_map_screen.dart';
import '../../features/programs/presentation/program_list_screen.dart';
import '../../features/programs/presentation/active_program_screen.dart';
import '../../features/seasonal/presentation/seasonal_reflection_screen.dart';
import '../../features/breathing/presentation/breathing_timer_screen.dart';
import '../../features/moon/presentation/moon_calendar_screen.dart';
import '../../features/challenges/presentation/challenge_list_screen.dart';
import '../../features/digest/presentation/weekly_digest_screen.dart';
import '../../features/archetype/presentation/archetype_screen.dart';
import '../../features/compatibility/presentation/compatibility_reflection_screen.dart';
import '../../features/blind_spot/presentation/blind_spot_screen.dart';

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

      // WEB: Skip storage check
      if (kIsWeb) {
        return null;
      }

      // MOBILE: First-launch disclaimer check
      final disclaimerAccepted = StorageService.loadDisclaimerAccepted();
      if (!disclaimerAccepted) {
        return Routes.disclaimer;
      }

      // MOBILE: Guard - redirect to onboarding if not completed
      final onboardingDone = StorageService.loadOnboardingComplete();
      if (!onboardingDone) {
        return Routes.onboarding;
      }

      // Legacy route redirects
      final redirect = Routes.legacyRouteRedirects[path];
      if (redirect != null) {
        return redirect;
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
      // INSIGHT - Personal Reflection
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.insight,
        builder: (context, state) => const InsightScreen(),
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
      // DREAM JOURNAL
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
      // GROWTH & ENGAGEMENT
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.attachmentQuiz,
        builder: (context, state) => const AttachmentQuizScreen(),
      ),
      GoRoute(
        path: Routes.shareInsight,
        builder: (context, state) => const ShareInsightScreen(),
      ),
      GoRoute(
        path: Routes.emotionalCycles,
        builder: (context, state) => const EmotionalCycleScreen(),
      ),
      GoRoute(
        path: Routes.growthDashboard,
        builder: (context, state) => const GrowthDashboardScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // RITUALS & HABITS
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.rituals,
        builder: (context, state) => const RitualsScreen(),
      ),
      GoRoute(
        path: Routes.ritualCreate,
        builder: (context, state) => const RitualCreateScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // WELLNESS & SLEEP
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.wellnessDetail,
        builder: (context, state) => const WellnessDetailScreen(),
      ),
      GoRoute(
        path: Routes.energyMap,
        builder: (context, state) => const EnergyMapScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // GUIDED PROGRAMS
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.programs,
        builder: (context, state) => const ProgramListScreen(),
      ),
      GoRoute(
        path: Routes.programDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ActiveProgramScreen(programId: id);
        },
      ),

      // ════════════════════════════════════════════════════════════════
      // P2: SEASONAL, BREATHING, MOON CALENDAR, CHALLENGES
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.seasonal,
        builder: (context, state) => const SeasonalReflectionScreen(),
      ),
      GoRoute(
        path: Routes.breathing,
        builder: (context, state) => const BreathingTimerScreen(),
      ),
      GoRoute(
        path: Routes.moonCalendar,
        builder: (context, state) => const MoonCalendarScreen(),
      ),
      GoRoute(
        path: Routes.challenges,
        builder: (context, state) => const ChallengeListScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // TIER 2 FEATURES
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.weeklyDigest,
        builder: (context, state) => const WeeklyDigestScreen(),
      ),
      GoRoute(
        path: Routes.archetype,
        builder: (context, state) => const ArchetypeScreen(),
      ),
      GoRoute(
        path: Routes.compatibilityReflection,
        builder: (context, state) => const CompatibilityReflectionScreen(),
      ),
      GoRoute(
        path: Routes.blindSpot,
        builder: (context, state) => const BlindSpotScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // REFERENCE & CONTENT
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.glossary,
        builder: (context, state) => const GlossaryScreen(),
      ),
      GoRoute(
        path: Routes.articles,
        builder: (context, state) => const ArticlesScreen(),
      ),
      // Content detail route archived

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

      // ════════════════════════════════════════════════════════════════
      // LEGACY REDIRECTS (all old routes -> insight)
      // ════════════════════════════════════════════════════════════════
      ...Routes.legacyRouteRedirects.entries.map(
        (entry) => GoRoute(
          path: entry.key,
          redirect: (context, state) => entry.value,
        ),
      ),
    ],
  );
});

// ════════════════════════════════════════════════════════════════════════════
// SPLASH SCREEN
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
