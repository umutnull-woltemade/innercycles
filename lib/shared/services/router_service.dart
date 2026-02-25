// ════════════════════════════════════════════════════════════════════════════
// ROUTER SERVICE - InnerCycles Navigation (Survival Release)
// ════════════════════════════════════════════════════════════════════════════
// 5-Tab: Home | Journal | Signal Dashboard | Notes | Profile
// SECONDARY features soft-archived: code preserved, routes removed.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/notification_service.dart' show navigatorKey;

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
import '../../features/notes/presentation/notes_list_screen.dart';
import '../../features/notes/presentation/note_detail_screen.dart';
import '../../features/admin/presentation/admin_login_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/cycle_sync/presentation/cycle_sync_screen.dart';
import '../../features/shadow_work/presentation/shadow_work_screen.dart';
import '../../features/prompts/presentation/prompt_library_screen.dart';
import '../../features/milestones/presentation/milestone_screen.dart';
import '../../features/year_review/presentation/year_review_screen.dart';
import '../../features/year_review/presentation/wrapped_screen.dart';
import '../../features/habits/presentation/daily_habits_screen.dart';
// partner_sync_screen + referral_screen imports removed (killed features)
import '../../features/journal/presentation/annual_report_screen.dart';
import '../../features/retrospective/presentation/retrospective_screen.dart';
import '../../features/digest/presentation/monthly_wrapped_screen.dart';
import '../../features/sharing/presentation/share_card_gallery.dart';
import '../../features/habits/presentation/habit_suggestions_screen.dart';
import '../../features/growth/presentation/growth_dashboard_screen.dart';
import '../../features/digest/presentation/weekly_digest_screen.dart';
import '../../features/affirmation/presentation/affirmation_library_screen.dart';
import '../../features/archetype/presentation/archetype_screen.dart';
// articles_screen import removed (killed feature)
import '../../features/blind_spot/presentation/blind_spot_screen.dart';
import '../../features/challenges/presentation/challenge_hub_screen.dart';
import '../../features/challenges/presentation/challenge_list_screen.dart';
// compatibility_reflection_screen import removed (killed feature)
import '../../features/dreams/presentation/dream_archive_screen.dart';
import '../../features/dreams/presentation/canonical/dream_theme_screen.dart';
import '../../features/dreams/presentation/dream_glossary_screen.dart';
import '../../features/dreams/presentation/dream_interpretation_screen.dart';
import '../../features/energy/presentation/energy_map_screen.dart';
import '../../features/life_events/presentation/life_event_screen.dart';
import '../../features/life_events/presentation/life_event_detail_screen.dart';
import '../../features/life_events/presentation/life_timeline_screen.dart';
import '../../features/birthdays/presentation/birthday_agenda_screen.dart';
import '../../features/birthdays/presentation/birthday_detail_screen.dart';
import '../../features/birthdays/presentation/birthday_add_screen.dart';
import '../../features/birthdays/presentation/birthday_import_screen.dart';
import '../../features/gratitude/presentation/gratitude_archive_screen.dart';
import '../../features/gratitude/presentation/gratitude_screen.dart';
import '../../features/insight/presentation/insight_screen.dart';
import '../../features/insight/presentation/insights_discovery_screen.dart';
import '../../features/library/presentation/library_hub_screen.dart';
// moon_calendar_screen import removed (killed feature)
import '../../features/mood/presentation/emotional_vocabulary_screen.dart';
import '../../features/programs/presentation/active_program_screen.dart';
import '../../features/programs/presentation/program_completion_screen.dart';
import '../../features/programs/presentation/program_list_screen.dart';
import '../../features/quiz/presentation/attachment_quiz_screen.dart';
import '../../features/quiz/presentation/generic_quiz_screen.dart';
import '../../features/quiz/presentation/quiz_hub_screen.dart';
import '../../features/rituals/presentation/ritual_create_screen.dart';
import '../../features/rituals/presentation/rituals_screen.dart';
import '../../features/search/presentation/global_search_screen.dart';
import '../../features/seasonal/presentation/seasonal_reflection_screen.dart';
import '../../features/sleep/presentation/sleep_detail_screen.dart';
import '../../features/sleep/presentation/sleep_trends_screen.dart';
import '../../features/memories/presentation/memories_screen.dart';
import '../../features/tools/presentation/tool_catalog_screen.dart';
import '../../features/wellness/presentation/wellness_detail_screen.dart';
import '../../shared/widgets/main_shell_screen.dart';
import '../../data/services/admin_auth_service.dart';
import '../../data/services/storage_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
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

      // Allow admin routes without onboarding (debug only)
      if (kDebugMode && path.startsWith(Routes.admin)) {
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
      // 5-TAB SHELL: Home | Journal | Insights | Notes | Profile
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
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  return DailyEntryScreen(
                    initialDate: extra?['initialDate'] as DateTime?,
                    journalPrompt: extra?['journalPrompt'] as String?,
                    retrospectiveDateId:
                        extra?['retrospectiveDateId'] as String?,
                  );
                },
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
          // Tab 3: Notes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.notesList,
                builder: (context, state) => const NotesListScreen(),
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
      GoRoute(
        path: Routes.memories,
        builder: (context, state) => const MemoriesScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // INSIGHTS (sub-screens, outside shell)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.calendarHeatmap,
        builder: (context, state) => const CalendarHeatmapScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // LIFE EVENTS
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.lifeEventNew,
        builder: (context, state) {
          final date = state.uri.queryParameters['date'];
          return LifeEventScreen(initialDate: date);
        },
      ),
      GoRoute(
        path: Routes.lifeEventEdit,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return LifeEventScreen(editId: id);
        },
      ),
      GoRoute(
        path: Routes.lifeEventDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return LifeEventDetailScreen(eventId: id);
        },
      ),
      GoRoute(
        path: Routes.lifeTimeline,
        builder: (context, state) => const LifeTimelineScreen(),
      ),
      GoRoute(
        path: Routes.emotionalCycles,
        builder: (context, state) => const EmotionalCycleScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // BIRTHDAY AGENDA
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.birthdayAgenda,
        builder: (context, state) => const BirthdayAgendaScreen(),
      ),
      GoRoute(
        path: Routes.birthdayDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return BirthdayDetailScreen(contactId: id);
        },
      ),
      GoRoute(
        path: Routes.birthdayAdd,
        builder: (context, state) => const BirthdayAddScreen(),
      ),
      GoRoute(
        path: Routes.birthdayEdit,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return BirthdayAddScreen(editId: id);
        },
      ),
      GoRoute(
        path: Routes.birthdayImport,
        builder: (context, state) => const BirthdayImportScreen(),
      ),
      GoRoute(
        path: Routes.cycleSync,
        builder: (context, state) => const CycleSyncScreen(),
      ),
      GoRoute(
        path: Routes.shadowWork,
        builder: (context, state) => const ShadowWorkScreen(),
      ),
      // ════════════════════════════════════════════════════════════════
      // BREATHE & MEDITATION (standalone, accessible from Profile)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.breathing,
        builder: (context, state) => const BreathingTimerScreen(),
      ),
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
      // NOTES TO SELF (detail/create sub-screens, outside shell)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.noteDetail,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final noteId = extra?['noteId'] as String? ?? '';
          return NoteDetailScreen(noteId: noteId);
        },
      ),
      GoRoute(
        path: Routes.noteCreate,
        builder: (context, state) => const NoteDetailScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // APP LOCK
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.appLock,
        builder: (context, state) => const AppLockScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // ADMIN SYSTEM (debug builds only)
      // ════════════════════════════════════════════════════════════════
      if (kDebugMode) ...[
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
      ],

      // ════════════════════════════════════════════════════════════════
      // DISCOVERY & GROWTH FEATURES
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.promptLibrary,
        builder: (context, state) => const PromptLibraryScreen(),
      ),
      GoRoute(
        path: Routes.milestones,
        builder: (context, state) => const MilestoneScreen(),
      ),
      GoRoute(
        path: Routes.yearReview,
        builder: (context, state) => const YearReviewScreen(),
      ),
      GoRoute(
        path: Routes.wrapped,
        builder: (context, state) => const WrappedScreen(),
      ),
      GoRoute(
        path: Routes.dailyHabits,
        builder: (context, state) => const DailyHabitsScreen(),
      ),
      // partner + referral routes removed (killed features)
      GoRoute(
        path: Routes.annualReport,
        builder: (context, state) => const AnnualReportScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // RETROSPECTIVE & MONTHLY WRAPPED
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.retrospective,
        builder: (context, state) => const RetrospectiveScreen(),
      ),
      GoRoute(
        path: Routes.monthlyWrapped,
        builder: (context, state) => const MonthlyWrappedScreen(),
      ),
      GoRoute(
        path: Routes.shareCardGallery,
        builder: (context, state) => const ShareCardGalleryScreen(),
      ),
      GoRoute(
        path: Routes.habitSuggestions,
        builder: (context, state) => const HabitSuggestionsScreen(),
      ),
      GoRoute(
        path: Routes.growthDashboard,
        builder: (context, state) => const GrowthDashboardScreen(),
      ),
      GoRoute(
        path: Routes.weeklyDigest,
        builder: (context, state) => const WeeklyDigestScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // INSIGHT & DISCOVERY
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.insight,
        builder: (context, state) => const InsightScreen(),
      ),
      GoRoute(
        path: Routes.insightsDiscovery,
        builder: (context, state) => const InsightsDiscoveryScreen(),
      ),
      GoRoute(
        path: Routes.search,
        builder: (context, state) => const GlobalSearchScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // DREAMS
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
        path: Routes.dreamArchive,
        builder: (context, state) => const DreamArchiveScreen(),
      ),
      // ── Dream Pages (single parameterized route) ──
      GoRoute(
        path: '/dreams/:theme',
        builder: (context, state) {
          final theme = state.pathParameters['theme']!;
          // Skip non-canonical routes handled above
          if (theme == 'archive') return const DreamArchiveScreen();
          return DreamThemeScreen(themeId: theme);
        },
      ),

      // ════════════════════════════════════════════════════════════════
      // RITUALS & WELLNESS
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.rituals,
        builder: (context, state) => const RitualsScreen(),
      ),
      GoRoute(
        path: Routes.ritualCreate,
        builder: (context, state) => const RitualCreateScreen(),
      ),
      GoRoute(
        path: Routes.wellnessDetail,
        builder: (context, state) => const WellnessDetailScreen(),
      ),
      GoRoute(
        path: Routes.energyMap,
        builder: (context, state) => const EnergyMapScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // SEASONAL, MOON, CHALLENGES
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.seasonal,
        builder: (context, state) => const SeasonalReflectionScreen(),
      ),
      // moonCalendar route removed (killed feature)
      GoRoute(
        path: Routes.challengeHub,
        builder: (context, state) => const ChallengeHubScreen(),
      ),
      GoRoute(
        path: Routes.challenges,
        builder: (context, state) => const ChallengeListScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // GRATITUDE & SLEEP
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.gratitudeJournal,
        builder: (context, state) => const GratitudeScreen(),
      ),
      GoRoute(
        path: Routes.gratitudeArchive,
        builder: (context, state) => const GratitudeArchiveScreen(),
      ),
      GoRoute(
        path: Routes.sleepDetail,
        builder: (context, state) => const SleepDetailScreen(),
      ),
      GoRoute(
        path: Routes.sleepTrends,
        builder: (context, state) => const SleepTrendsScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // PROGRAMS
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
      GoRoute(
        path: Routes.programCompletion,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ProgramCompletionScreen(
            programTitle: extra['programTitle'] as String? ?? '',
            programEmoji: extra['programEmoji'] as String? ?? '',
            durationDays: extra['durationDays'] as int? ?? 0,
            completedDays: extra['completedDays'] as int? ?? 0,
          );
        },
      ),

      // ════════════════════════════════════════════════════════════════
      // QUIZZES
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.quizHub,
        builder: (context, state) => const QuizHubScreen(),
      ),
      GoRoute(
        path: Routes.attachmentQuiz,
        builder: (context, state) => const AttachmentQuizScreen(),
      ),
      GoRoute(
        path: Routes.quizGeneric,
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          return GenericQuizScreen(quizId: quizId);
        },
      ),

      // ════════════════════════════════════════════════════════════════
      // REFERENCE & CONTENT
      // ════════════════════════════════════════════════════════════════
      // articles route removed (killed feature)
      GoRoute(
        path: Routes.affirmations,
        builder: (context, state) => const AffirmationLibraryScreen(),
      ),
      GoRoute(
        path: Routes.emotionalVocabulary,
        builder: (context, state) => const EmotionalVocabularyScreen(),
      ),
      // Redirect dead routes to closest equivalents
      GoRoute(
        path: Routes.shareInsight,
        redirect: (_, _) => Routes.shareCardGallery,
      ),
      GoRoute(
        path: Routes.glossary,
        redirect: (_, _) => Routes.dreamGlossary,
      ),

      // ════════════════════════════════════════════════════════════════
      // PERSONALITY & COMPATIBILITY
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.archetype,
        builder: (context, state) => const ArchetypeScreen(),
      ),
      // compatibility route removed (killed feature)
      GoRoute(
        path: Routes.blindSpot,
        builder: (context, state) => const BlindSpotScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // TABS (library, tools)
      // ════════════════════════════════════════════════════════════════
      GoRoute(
        path: Routes.library,
        builder: (context, state) => const LibraryHubScreen(),
      ),
      GoRoute(
        path: Routes.tools,
        builder: (context, state) => const ToolCatalogScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // DEEP LINK ROUTES (innercycles:// scheme)
      // ════════════════════════════════════════════════════════════════
      // deepLinkInvite removed (referral killed)
      GoRoute(
        path: Routes.deepLinkShare,
        redirect: (context, state) {
          // Navigate to share card gallery (cardId available via query for future use)
          final cardId = state.pathParameters['cardId'] ?? '';
          return '${Routes.shareCardGallery}?cardId=$cardId';
        },
      ),

      // ════════════════════════════════════════════════════════════════
      // LEGACY DREAM REDIRECTS (Turkish backward compatibility)
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
              style: AppTypography.subtitle(
                fontSize: 12,
                color: Colors.white38,
              ).copyWith(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => context.go(Routes.today),
              icon: const Icon(Icons.home, color: Colors.white70),
              label: Text(
                'Home / Ana Sayfa',
                style: AppTypography.elegantAccent(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
