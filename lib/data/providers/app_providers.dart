// ════════════════════════════════════════════════════════════════════════════
// APP PROVIDERS - Core State Management (App Store 4.3(b) Compliant)
// ════════════════════════════════════════════════════════════════════════════
// All legacy providers have been removed for App Store compliance.
// This file now focuses on:
// - User profile management
// - Language settings
// - Theme settings
// - Dream journal
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

import '../services/storage_service.dart';
import '../services/dream_journal_service.dart';
import '../services/journal_service.dart';
import '../services/streak_service.dart';
import '../services/gratitude_service.dart';
import '../services/ritual_service.dart';
import '../services/review_service.dart';
import '../services/attachment_style_service.dart';
import '../services/sleep_service.dart';
import '../services/wellness_score_service.dart';
import '../services/energy_map_service.dart';
import '../services/guided_program_service.dart';
import '../services/seasonal_reflection_service.dart';
import '../services/growth_challenge_service.dart';
import '../services/weekly_digest_service.dart';
import '../services/mood_checkin_service.dart';
import '../services/archetype_service.dart';
import '../services/compatibility_service.dart';
import '../services/blind_spot_service.dart';
import '../services/export_service.dart';
import '../services/affirmation_service.dart';
import '../services/milestone_service.dart';
import '../services/journal_prompt_service.dart';
import '../services/pattern_health_service.dart';
import '../services/quiz_engine_service.dart';
import '../services/notification_lifecycle_service.dart';
import '../services/voice_journal_service.dart';
import '../services/pattern_engine_service.dart';
import '../services/year_review_service.dart';
import '../services/referral_service.dart';
import '../services/context_module_service.dart';
import '../services/habit_suggestion_service.dart';
import '../services/monthly_theme_service.dart';
import '../services/app_lock_service.dart';
import '../services/pattern_loop_service.dart';
import '../services/shift_outlook_service.dart';
import '../services/emotional_cycle_service.dart';
import '../services/cycle_sync_service.dart';
import '../services/cycle_correlation_service.dart';
import '../services/shadow_work_service.dart';
import '../services/partner_sync_service.dart';
import '../services/dream_journal_correlation_service.dart';
import '../services/telemetry_service.dart';
import '../services/progressive_unlock_service.dart';
import '../services/life_event_service.dart';
import '../models/journal_entry.dart';
import '../models/cross_correlation_result.dart';

// =============================================================================
// USER PROFILE PROVIDERS
// =============================================================================

/// User profile state using Notifier (Riverpod 2.x+)
final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile?>(
  () {
    return UserProfileNotifier();
  },
);

class UserProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => null;

  void setProfile(UserProfile profile) {
    state = profile;
    _syncToStorage(profile);
  }

  void clearProfile() {
    state = null;
  }

  void _syncToStorage(UserProfile profile) {
    StorageService.saveUserProfile(profile);
    ref.read(savedProfilesProvider.notifier).updateProfile(profile);
  }
}

/// Multiple profiles provider
final savedProfilesProvider =
    NotifierProvider<SavedProfilesNotifier, List<UserProfile>>(() {
      return SavedProfilesNotifier();
    });

class SavedProfilesNotifier extends Notifier<List<UserProfile>> {
  @override
  List<UserProfile> build() {
    return StorageService.loadAllProfiles();
  }

  Future<void> addProfile(UserProfile profile) async {
    await StorageService.saveProfile(profile);
    state = StorageService.loadAllProfiles();
  }

  Future<void> updateProfile(UserProfile profile) async {
    await StorageService.saveProfile(profile);
    state = StorageService.loadAllProfiles();
  }

  Future<void> removeProfile(String id) async {
    await StorageService.deleteProfile(id);
    state = StorageService.loadAllProfiles();
  }

  Future<void> setPrimary(String id) async {
    await StorageService.setPrimaryProfileId(id);
    final profiles = state.map((p) {
      return p.copyWith(isPrimary: p.id == id);
    }).toList();
    state = profiles;
  }

  void refresh() {
    state = StorageService.loadAllProfiles();
  }
}

// =============================================================================
// APP STATE PROVIDERS
// =============================================================================

/// Onboarding completed flag
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

// =============================================================================
// LANGUAGE PROVIDER
// =============================================================================

enum AppLanguage {
  en, // English
  tr, // Türkçe
  el, // Ελληνικά (Greek)
  bg, // Български (Bulgarian)
  ru, // Русский (Russian)
  zh, // 中文 (Chinese)
  fr, // Français (French)
  de, // Deutsch (German)
  es, // Español (Spanish)
  ar, // العربية (Arabic - RTL)
}

extension AppLanguageExtension on AppLanguage {
  String get displayName {
    switch (this) {
      case AppLanguage.en:
        return 'English';
      case AppLanguage.tr:
        return 'Türkçe';
      case AppLanguage.el:
        return 'Ελληνικά';
      case AppLanguage.bg:
        return 'Български';
      case AppLanguage.ru:
        return 'Русский';
      case AppLanguage.zh:
        return '中文';
      case AppLanguage.fr:
        return 'Français';
      case AppLanguage.de:
        return 'Deutsch';
      case AppLanguage.es:
        return 'Español';
      case AppLanguage.ar:
        return 'العربية';
    }
  }

  String get flag {
    switch (this) {
      case AppLanguage.en:
        return '🇬🇧';
      case AppLanguage.tr:
        return '🇹🇷';
      case AppLanguage.el:
        return '🇬🇷';
      case AppLanguage.bg:
        return '🇧🇬';
      case AppLanguage.ru:
        return '🇷🇺';
      case AppLanguage.zh:
        return '🇨🇳';
      case AppLanguage.fr:
        return '🇫🇷';
      case AppLanguage.de:
        return '🇩🇪';
      case AppLanguage.es:
        return '🇪🇸';
      case AppLanguage.ar:
        return '🇸🇦';
    }
  }

  bool get isRTL => this == AppLanguage.ar;

  /// Languages with complete translations and strict isolation support
  bool get hasStrictIsolation {
    return this == AppLanguage.en ||
        this == AppLanguage.tr ||
        this == AppLanguage.de ||
        this == AppLanguage.fr;
  }

  /// Languages that are fully available for selection
  bool get isFullyAvailable => hasStrictIsolation;

  Locale get locale {
    switch (this) {
      case AppLanguage.en:
        return const Locale('en', 'US');
      case AppLanguage.tr:
        return const Locale('tr', 'TR');
      case AppLanguage.el:
        return const Locale('el', 'GR');
      case AppLanguage.bg:
        return const Locale('bg', 'BG');
      case AppLanguage.ru:
        return const Locale('ru', 'RU');
      case AppLanguage.zh:
        return const Locale('zh', 'CN');
      case AppLanguage.fr:
        return const Locale('fr', 'FR');
      case AppLanguage.de:
        return const Locale('de', 'DE');
      case AppLanguage.es:
        return const Locale('es', 'ES');
      case AppLanguage.ar:
        return const Locale('ar', 'SA');
    }
  }
}

final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.en);

// =============================================================================
// THEME PROVIDER
// =============================================================================

/// Theme mode provider - default is dark
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

// =============================================================================
// DREAM JOURNAL PROVIDER
// =============================================================================

/// Dream Journal Service provider - async initialization
final dreamJournalServiceProvider = FutureProvider<DreamJournalService>((
  ref,
) async {
  return await DreamJournalService.init();
});

/// Derived dream count provider (sync-safe for widget builds).
final dreamCountProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(dreamJournalServiceProvider.future);
  return service.getDreamCount();
});

// =============================================================================
// JOURNAL PROVIDERS (InnerCycles)
// =============================================================================

/// Journal Service provider - async initialization
final journalServiceProvider = FutureProvider<JournalService>((ref) async {
  return await JournalService.init();
});

/// Today's journal entry (null if not logged yet)
final todayJournalEntryProvider = FutureProvider<JournalEntry?>((ref) async {
  final service = await ref.watch(journalServiceProvider.future);
  return service.getTodayEntry();
});

/// Current streak count
final journalStreakProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(journalServiceProvider.future);
  return service.getCurrentStreak();
});

// =============================================================================
// STREAK SERVICE PROVIDER
// =============================================================================

final streakServiceProvider = FutureProvider<StreakService>((ref) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  return await StreakService.init(journalService);
});

final streakStatsProvider = FutureProvider<StreakStats>((ref) async {
  final streakService = await ref.watch(streakServiceProvider.future);
  return streakService.getStats();
});

// =============================================================================
// GRATITUDE SERVICE PROVIDER
// =============================================================================

final gratitudeServiceProvider = FutureProvider<GratitudeService>((ref) async {
  return await GratitudeService.init();
});

final todayGratitudeProvider = FutureProvider<GratitudeEntry?>((ref) async {
  final service = await ref.watch(gratitudeServiceProvider.future);
  return service.getTodayEntry();
});

final gratitudeSummaryProvider = FutureProvider<GratitudeSummary>((ref) async {
  final service = await ref.watch(gratitudeServiceProvider.future);
  return service.getWeeklySummary();
});

// =============================================================================
// RITUAL SERVICE PROVIDER
// =============================================================================

final ritualServiceProvider = FutureProvider<RitualService>((ref) async {
  return await RitualService.init();
});

final ritualStacksProvider = FutureProvider<List<RitualStack>>((ref) async {
  final service = await ref.watch(ritualServiceProvider.future);
  return service.getStacks();
});

final todayRitualSummaryProvider = FutureProvider<DailyRitualSummary>((
  ref,
) async {
  final service = await ref.watch(ritualServiceProvider.future);
  return service.getTodaySummary();
});

// =============================================================================
// REVIEW SERVICE PROVIDER
// =============================================================================

final reviewServiceProvider = FutureProvider<ReviewService>((ref) async {
  return await ReviewService.init();
});

// =============================================================================
// ATTACHMENT STYLE PROVIDER
// =============================================================================

final attachmentStyleServiceProvider = FutureProvider<AttachmentStyleService>((
  ref,
) async {
  return await AttachmentStyleService.init();
});

// =============================================================================
// SLEEP SERVICE PROVIDER
// =============================================================================

final sleepServiceProvider = FutureProvider<SleepService>((ref) async {
  return await SleepService.init();
});

final todaySleepProvider = FutureProvider<SleepEntry?>((ref) async {
  final service = await ref.watch(sleepServiceProvider.future);
  return service.getTodayEntry();
});

final sleepSummaryProvider = FutureProvider<SleepSummary>((ref) async {
  final service = await ref.watch(sleepServiceProvider.future);
  return service.getWeeklySummary();
});

// =============================================================================
// WELLNESS SCORE PROVIDER
// =============================================================================

final wellnessScoreServiceProvider = FutureProvider<WellnessScoreService>((
  ref,
) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  final gratitudeService = await ref.watch(gratitudeServiceProvider.future);
  final ritualService = await ref.watch(ritualServiceProvider.future);
  final streakService = await ref.watch(streakServiceProvider.future);
  final sleepService = await ref.watch(sleepServiceProvider.future);
  return await WellnessScoreService.init(
    journalService: journalService,
    gratitudeService: gratitudeService,
    ritualService: ritualService,
    streakService: streakService,
    sleepService: sleepService,
  );
});

final wellnessScoreProvider = FutureProvider<WellnessScore?>((ref) async {
  final service = await ref.watch(wellnessScoreServiceProvider.future);
  return await service.calculateTodayScore();
});

final wellnessTrendProvider = FutureProvider<WellnessTrend>((ref) async {
  final service = await ref.watch(wellnessScoreServiceProvider.future);
  return service.getWeeklyTrend();
});

// =============================================================================
// ENERGY MAP PROVIDER
// =============================================================================

final energyMapServiceProvider = FutureProvider<EnergyMapService>((ref) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  return EnergyMapService(journalService);
});

final energyMapProvider = FutureProvider<EnergyMapData?>((ref) async {
  final service = await ref.watch(energyMapServiceProvider.future);
  if (!service.hasEnoughData()) return null;
  return service.buildHeatmap();
});

// =============================================================================
// GUIDED PROGRAM PROVIDER
// =============================================================================

final guidedProgramServiceProvider = FutureProvider<GuidedProgramService>((
  ref,
) async {
  return await GuidedProgramService.init();
});

// =============================================================================
// SEASONAL REFLECTION PROVIDER
// =============================================================================

final seasonalReflectionServiceProvider =
    FutureProvider<SeasonalReflectionService>((ref) async {
      return SeasonalReflectionService.init();
    });

// =============================================================================
// EXPORT SERVICE PROVIDER
// =============================================================================

// =============================================================================
// GROWTH CHALLENGE PROVIDER
// =============================================================================

final growthChallengeServiceProvider = FutureProvider<GrowthChallengeService>((
  ref,
) async {
  return await GrowthChallengeService.init();
});

// =============================================================================
// WEEKLY DIGEST PROVIDER
// =============================================================================

final weeklyDigestServiceProvider = FutureProvider<WeeklyDigestService>((
  ref,
) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  final patternEngine = await ref.watch(patternEngineServiceProvider.future);
  return await WeeklyDigestService.init(
    journalService: journalService,
    patternEngine: patternEngine,
  );
});

/// Pre-computed weekly digest data for the current week
final weeklyDigestDataProvider = FutureProvider<WeeklyDigestData?>((
  ref,
) async {
  final service = await ref.watch(weeklyDigestServiceProvider.future);
  if (!service.hasDataForWeek(DateTime.now())) return null;
  return service.generateDigest(DateTime.now());
});

// =============================================================================
// MOOD CHECK-IN PROVIDER
// =============================================================================

final moodCheckinServiceProvider = FutureProvider<MoodCheckinService>((
  ref,
) async {
  return await MoodCheckinService.init();
});

// =============================================================================
// APP LOCK PROVIDER
// =============================================================================

final appLockServiceProvider = FutureProvider<AppLockService>((ref) async {
  return await AppLockService.init();
});

// =============================================================================
// ARCHETYPE PROVIDER
// =============================================================================

final archetypeServiceProvider = FutureProvider<ArchetypeService>((ref) async {
  return await ArchetypeService.init();
});

// =============================================================================
// COMPATIBILITY PROVIDER
// =============================================================================

final compatibilityServiceProvider = FutureProvider<CompatibilityService>((
  ref,
) async {
  return await CompatibilityService.init();
});

// =============================================================================
// BLIND SPOT PROVIDER
// =============================================================================

final blindSpotServiceProvider = FutureProvider<BlindSpotService>((ref) async {
  return await BlindSpotService.init();
});

// =============================================================================
// EXPORT SERVICE PROVIDER
// =============================================================================

final exportServiceProvider = FutureProvider<ExportService>((ref) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  return ExportService(journalService);
});

// =============================================================================
// AFFIRMATION SERVICE PROVIDER
// =============================================================================

final affirmationServiceProvider = FutureProvider<AffirmationService>((
  ref,
) async {
  return await AffirmationService.init();
});

// =============================================================================
// MILESTONE SERVICE PROVIDER
// =============================================================================

final milestoneServiceProvider = FutureProvider<MilestoneService>((ref) async {
  return await MilestoneService.init();
});

// =============================================================================
// JOURNAL PROMPT SERVICE PROVIDER
// =============================================================================

final journalPromptServiceProvider = FutureProvider<JournalPromptService>((
  ref,
) async {
  return await JournalPromptService.init();
});

// =============================================================================
// PATTERN HEALTH SERVICE PROVIDER
// =============================================================================

final patternHealthServiceProvider = FutureProvider<PatternHealthService>((
  ref,
) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  return await PatternHealthService.init(journalService);
});

final patternHealthReportProvider = FutureProvider<PatternHealthReport>((
  ref,
) async {
  final service = await ref.watch(patternHealthServiceProvider.future);
  return await service.analyzeHealth();
});

// =============================================================================
// VOICE JOURNAL SERVICE PROVIDER
// =============================================================================

final voiceJournalServiceProvider = FutureProvider<VoiceJournalService>((
  ref,
) async {
  return await VoiceJournalService.init();
});

// =============================================================================
// NOTIFICATION LIFECYCLE PROVIDER
// =============================================================================

final notificationLifecycleServiceProvider =
    FutureProvider<NotificationLifecycleService>((ref) async {
      return await NotificationLifecycleService.init();
    });

// =============================================================================
// PATTERN ENGINE SERVICE PROVIDER (with cross-correlation support)
// =============================================================================

final patternEngineServiceProvider = FutureProvider<PatternEngineService>((
  ref,
) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  final sleepService = await ref.watch(sleepServiceProvider.future);
  final gratitudeService = await ref.watch(gratitudeServiceProvider.future);
  final ritualService = await ref.watch(ritualServiceProvider.future);
  final wellnessScoreService = await ref.watch(
    wellnessScoreServiceProvider.future,
  );
  final moodCheckinService = await ref.watch(moodCheckinServiceProvider.future);
  final streakService = await ref.watch(streakServiceProvider.future);
  return PatternEngineService(
    journalService,
    sleepService: sleepService,
    gratitudeService: gratitudeService,
    ritualService: ritualService,
    wellnessScoreService: wellnessScoreService,
    moodCheckinService: moodCheckinService,
    streakService: streakService,
  );
});

// =============================================================================
// CROSS-CORRELATIONS PROVIDER
// =============================================================================

final crossCorrelationsProvider = FutureProvider<List<CrossCorrelation>>((
  ref,
) async {
  final engine = await ref.watch(patternEngineServiceProvider.future);
  return engine.getCrossCorrelations();
});

// =============================================================================
// GRATITUDE-MOOD COMPARISON PROVIDER
// =============================================================================

final gratitudeMoodComparisonProvider =
    FutureProvider<GratitudeMoodComparison?>((ref) async {
  final engine = await ref.watch(patternEngineServiceProvider.future);
  return engine.getGratitudeMoodComparison();
});

// =============================================================================
// QUIZ ENGINE SERVICE PROVIDER
// =============================================================================

final quizEngineServiceProvider = FutureProvider<QuizEngineService>((
  ref,
) async {
  return await QuizEngineService.init();
});

// =============================================================================
// YEAR REVIEW SERVICE PROVIDER
// =============================================================================

final yearReviewServiceProvider = FutureProvider<YearReviewService>((
  ref,
) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  return await YearReviewService.init(journalService);
});

// =============================================================================
// REFERRAL SERVICE PROVIDER
// =============================================================================

final referralServiceProvider = FutureProvider<ReferralService>((ref) async {
  return await ReferralService.init();
});

// =============================================================================
// CONTEXT MODULE SERVICE PROVIDER
// =============================================================================

final contextModuleServiceProvider = FutureProvider<ContextModuleService>((
  ref,
) async {
  return await ContextModuleService.init();
});

// =============================================================================
// HABIT SUGGESTION SERVICE PROVIDER
// =============================================================================

final habitSuggestionServiceProvider = FutureProvider<HabitSuggestionService>((
  ref,
) async {
  return await HabitSuggestionService.init();
});

// =============================================================================
// MONTHLY THEME SERVICE PROVIDER
// =============================================================================

final monthlyThemeServiceProvider = FutureProvider<MonthlyThemeService>((
  ref,
) async {
  return await MonthlyThemeService.init();
});

// =============================================================================
// PATTERN LOOP SERVICE PROVIDER (Emotion Intelligence)
// =============================================================================

final patternLoopServiceProvider = FutureProvider<PatternLoopService>((
  ref,
) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  return await PatternLoopService.init(journalService);
});

final patternLoopAnalysisProvider = FutureProvider<PatternLoopAnalysis>((
  ref,
) async {
  final service = await ref.watch(patternLoopServiceProvider.future);
  return service.analyze();
});

// =============================================================================
// SHIFT OUTLOOK SERVICE PROVIDER (Emotion Intelligence — Premium)
// =============================================================================

final shiftOutlookServiceProvider = FutureProvider<ShiftOutlookService>((
  ref,
) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  return ShiftOutlookService(journalService);
});

final shiftOutlookProvider = FutureProvider<ShiftOutlook>((ref) async {
  final service = await ref.watch(shiftOutlookServiceProvider.future);
  return service.generateOutlook();
});

// =============================================================================
// EMOTIONAL CYCLE ANALYSIS PROVIDER (Emotion Intelligence)
// =============================================================================

final emotionalCycleServiceProvider = FutureProvider<EmotionalCycleService>((
  ref,
) async {
  final journalService = await ref.watch(journalServiceProvider.future);
  return EmotionalCycleService(journalService);
});

final emotionalCycleAnalysisProvider = FutureProvider<EmotionalCycleAnalysis>((
  ref,
) async {
  final cycleService = await ref.watch(emotionalCycleServiceProvider.future);
  if (!cycleService.hasEnoughData()) {
    return EmotionalCycleAnalysis(
      areaSummaries: {},
      insights: [],
      totalEntries: cycleService.entryCount,
    );
  }
  return cycleService.analyze();
});

// =============================================================================
// CYCLE SYNC PROVIDERS (Hormonal Cycle Tracking)
// =============================================================================

final cycleSyncServiceProvider = FutureProvider<CycleSyncService>((
  ref,
) async {
  return await CycleSyncService.init();
});

final cycleCorrelationServiceProvider =
    FutureProvider<CycleCorrelationService>((ref) async {
  final cycleSyncService = await ref.watch(cycleSyncServiceProvider.future);
  final journalService = await ref.watch(journalServiceProvider.future);
  return CycleCorrelationService(cycleSyncService, journalService);
});

// =============================================================================
// SHADOW WORK PROVIDERS (Guided Shadow Journal)
// =============================================================================

final shadowWorkServiceProvider = FutureProvider<ShadowWorkService>((
  ref,
) async {
  return await ShadowWorkService.init();
});

// =============================================================================
// PARTNER SYNC PROVIDERS (Partner Cycle Sharing — Local-First MVP)
// =============================================================================

final partnerSyncServiceProvider = FutureProvider<PartnerSyncService>((
  ref,
) async {
  return await PartnerSyncService.init();
});

// =============================================================================
// DREAM-JOURNAL CORRELATION PROVIDERS (Dream-Mood Cross-Analysis)
// =============================================================================

final dreamJournalCorrelationServiceProvider =
    FutureProvider<DreamJournalCorrelationService>((ref) async {
  final dreamService = await ref.watch(dreamJournalServiceProvider.future);
  final journalService = await ref.watch(journalServiceProvider.future);
  return await DreamJournalCorrelationService.init(
    dreamService: dreamService,
    journalService: journalService,
  );
});

final dreamMoodCorrelationsProvider =
    FutureProvider<List<DreamMoodCorrelation>>((ref) async {
  final service = await ref.watch(
    dreamJournalCorrelationServiceProvider.future,
  );
  return service.analyzeDreamMoodCorrelations();
});

final topDreamMoodCorrelationsProvider =
    FutureProvider<List<DreamMoodCorrelation>>((ref) async {
  final service = await ref.watch(
    dreamJournalCorrelationServiceProvider.future,
  );
  return service.getTopCorrelations(5);
});

// =============================================================================
// TELEMETRY SERVICE PROVIDER
// =============================================================================

final telemetryServiceProvider = FutureProvider<TelemetryService>((ref) async {
  return await TelemetryService.init();
});

// =============================================================================
// PROGRESSIVE UNLOCK SERVICE PROVIDER
// =============================================================================

final progressiveUnlockServiceProvider =
    FutureProvider<ProgressiveUnlockService>((ref) async {
  return await ProgressiveUnlockService.init();
});

// =============================================================================
// LIFE EVENT SERVICE PROVIDER
// =============================================================================

final lifeEventServiceProvider = FutureProvider<LifeEventService>((ref) async {
  return await LifeEventService.init();
});

final lifeEventCountProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(lifeEventServiceProvider.future);
  return service.eventCount;
});
