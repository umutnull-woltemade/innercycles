// ════════════════════════════════════════════════════════════════════════════
// ROUTER SERVICE - InnerCycles Navigation (Survival Release)
// ════════════════════════════════════════════════════════════════════════════
// 5-Tab: Home | Journal | Insights | Breathe | Profile
// SECONDARY features soft-archived: code preserved, routes removed.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/routes.dart';

// ── CORE screen imports ──
import '../../features/disclaimer/presentation/disclaimer_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/archetype_quiz_screen.dart';
import '../../features/today/presentation/today_feed_screen.dart';
import '../../features/journal/presentation/daily_entry_screen.dart';
import '../../features/journal/presentation/entry_detail_screen.dart';
import '../../features/journal/presentation/patterns_screen.dart';
import '../../features/journal/presentation/archive_screen.dart';
import '../../features/journal/presentation/monthly_reflection_screen.dart';
import '../../features/journal/presentation/emotional_cycle_screen.dart';
import '../../features/mood/presentation/mood_trends_screen.dart';
import '../../features/calendar/presentation/calendar_heatmap_screen.dart';
import '../../features/breathing/presentation/breathing_timer_screen.dart';
import '../../features/meditation/presentation/meditation_timer_screen.dart';
import '../../features/profile/presentation/profile_hub_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/premium/presentation/premium_screen.dart';
import '../../features/settings/presentation/notification_schedule_screen.dart';
import '../../features/export/presentation/export_screen.dart';
import '../../features/streak/presentation/streak_stats_screen.dart';
import '../../features/app_lock/presentation/app_lock_screen.dart';
import '../../features/admin/presentation/admin_login_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../shared/widgets/main_shell_screen.dart';
import '../../data/services/admin_auth_service.dart';
import '../../data/services/storage_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.disclaimer,
    errorBuilder: (context, state) => _NotFoundScreen(path: state.uri.path),
    redirect: (context, state) {
      final path = state.uri.path;

      // Allow disclaimer, onboarding, quiz, and lock without guard
      if (path == Routes.disclaimer ||
          path == Routes.onboarding ||
          path == Routes.archetypeQuiz ||
          path == Routes.appLock) {
        return null;
      }

      // Allow admin routes without onboarding
      if (path.startsWith(Routes.admin)) {
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

      return null;
    },
    routes: [
      // ════════════════════════════════════════════════════════════════
      // SYSTEM ROUTES
      // ════════════════════════════════════════════════════════════════
      GoRoute(path: '/', redirect: (_, _) => Routes.today),
      GoRoute(
        path: Routes.disclaimer,
        builder: (context, state) => const DisclaimerScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.archetypeQuiz,
        builder: (context, state) => const ArchetypeQuizScreen(),
      ),
      // ════════════════════════════════════════════════════════════════
      // 5-TAB SHELL: Home | Journal | Insights | Breathe | Profile
      // ════════════════════════════════════════════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.today,
                builder: (context, state) => const TodayFeedScreen(),
              ),
            ],
          ),
          // Tab 1: Journal
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.journal,
                builder: (context, state) => const DailyEntryScreen(),
              ),
            ],
          ),
          // Tab 2: Insights
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.moodTrends,
                builder: (context, state) => const MoodTrendsScreen(),
              ),
            ],
          ),
          // Tab 3: Breathe
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.breathing,
                builder: (context, state) => const BreathingTimerScreen(),
              ),
            ],
          ),
          // Tab 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profileHub,
                builder: (context, state) => const ProfileHubScreen(),
              ),
            ],
          ),
        ],
      ),

      // ════════════════════════════════════════════════════════════════
      // JOURNAL (sub-screens, outside shell)
      // ════════════════════════════════════════════════════════════════
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
      // INSIGHTS (sub-screens, outside shell)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.calendarHeatmap,
        builder: (context, state) => const CalendarHeatmapScreen(),
      ),
      GoRoute(
        path: Routes.emotionalCycles,
        builder: (context, state) => const EmotionalCycleScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // BREATHE (sub-screens, outside shell)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.meditation,
        builder: (context, state) => const MeditationTimerScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // PROFILE & SETTINGS
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.premium,
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationScheduleScreen(),
      ),
      GoRoute(
        path: Routes.exportData,
        builder: (context, state) => const ExportScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // STREAK
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.streakStats,
        builder: (context, state) => const StreakStatsScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // APP LOCK
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.appLock,
        builder: (context, state) => const AppLockScreen(),
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
      // SOFT-ARCHIVE REDIRECTS
      // All removed routes redirect to Home gracefully
      // ════════════════════════════════════════════════════════════════
      GoRoute(path: Routes.insight, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.insightsDiscovery, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.tools, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.challengeHub, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.library, redirect: (_, _) => Routes.today),
      GoRoute(
        path: Routes.dreamInterpretation,
        redirect: (_, _) => Routes.today,
      ),
      GoRoute(path: Routes.dreamGlossary, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.dreamArchive, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.quizHub, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.attachmentQuiz, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.shareCardGallery, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.growthDashboard, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.rituals, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.ritualCreate, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.wellnessDetail, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.energyMap, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.programs, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.seasonal, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.moonCalendar, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.challenges, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.weeklyDigest, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.archetype, redirect: (_, _) => Routes.today),
      GoRoute(
        path: Routes.compatibilityReflection,
        redirect: (_, _) => Routes.today,
      ),
      GoRoute(path: Routes.blindSpot, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.promptLibrary, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.milestones, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.yearReview, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.habitSuggestions, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.dailyHabits, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.gratitudeJournal, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.sleepDetail, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.gratitudeArchive, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.sleepTrends, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.affirmations, redirect: (_, _) => Routes.today),
      GoRoute(
        path: Routes.emotionalVocabulary,
        redirect: (_, _) => Routes.today,
      ),
      GoRoute(path: Routes.articles, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.glossary, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.search, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.programCompletion, redirect: (_, _) => Routes.today),
      GoRoute(path: Routes.shareInsight, redirect: (_, _) => Routes.today),

      // ════════════════════════════════════════════════════════════════
      // LEGACY REDIRECTS (all → Home)
      // ════════════════════════════════════════════════════════════════
      GoRoute(path: '/legacy-home', redirect: (_, _) => Routes.today),
      GoRoute(path: '/energy-profile', redirect: (_, _) => Routes.today),
      GoRoute(path: '/number-patterns', redirect: (_, _) => Routes.today),
      GoRoute(path: '/legacy-analysis', redirect: (_, _) => Routes.today),
      GoRoute(path: '/moon-rituals', redirect: (_, _) => Routes.today),
      GoRoute(path: '/legacy-insight', redirect: (_, _) => Routes.today),
      GoRoute(path: '/timing', redirect: (_, _) => Routes.today),
      GoRoute(path: '/celebrities', redirect: (_, _) => Routes.today),
      GoRoute(path: '/daily-rituals', redirect: (_, _) => Routes.today),
      GoRoute(path: '/kesif/ruhsal-donusum', redirect: (_, _) => Routes.today),
      ...Routes.legacyRouteRedirects.entries.map(
        (entry) => GoRoute(
          path: entry.key,
          redirect: (context, state) => Routes.today,
        ),
      ),
    ],
  );
});

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
            const Icon(Icons.explore_off, size: 64, color: Colors.white38),
            const SizedBox(height: 24),
            Text(
              'Page Not Found / Sayfa Bulunamad\u0131',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
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
              onPressed: () => context.go(Routes.today),
              icon: const Icon(Icons.home, color: Colors.white70),
              label: const Text(
                'Home / Ana Sayfa',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
