// ════════════════════════════════════════════════════════════════════════════
// GROWTH DASHBOARD SCREEN - InnerCycles Streak Gamification & Progress
// ════════════════════════════════════════════════════════════════════════════
// Shows personal growth metrics, streaks, milestones, and monthly summaries.
// Uses JournalService + DreamJournalService for data. Follows safe language
// rules — no predictions, only reflections on past entries.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:go_router/go_router.dart';
import '../../../core/theme/app_typography.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../data/models/journal_entry.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/journal_service.dart';
import '../../../data/services/growth_challenge_service.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/gratitude_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../data/services/l10n_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// GROWTH DASHBOARD SCREEN
// ════════════════════════════════════════════════════════════════════════════

class GrowthDashboardScreen extends ConsumerStatefulWidget {
  const GrowthDashboardScreen({super.key});

  @override
  ConsumerState<GrowthDashboardScreen> createState() =>
      _GrowthDashboardScreenState();
}

class _GrowthDashboardScreenState extends ConsumerState<GrowthDashboardScreen> {
  bool _scoreAnimated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('growthDashboard'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData(
            (s) => s.trackToolOpen('growthDashboard', source: 'direct'),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final journalAsync = ref.watch(journalServiceProvider);
    final dreamCountAsync = ref.watch(dreamCountProvider);
    final challengeAsync = ref.watch(growthChallengeServiceProvider);
    final gratitudeAsync = ref.watch(gratitudeServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: journalAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CommonStrings.somethingWentWrong(language),
                      textAlign: TextAlign.center,
                      style: AppTypography.subtitle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () =>
                          ref.invalidate(journalServiceProvider),
                      icon: Icon(Icons.refresh_rounded,
                          size: 16, color: AppColors.starGold),
                      label: Text(
                        L10nService.get('growth.growth_dashboard.retry', isEn ? AppLanguage.en : AppLanguage.tr),
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.starGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            data: (journalService) {
              final dreamCount = dreamCountAsync.valueOrNull ?? 0;
              final challengeService = challengeAsync.valueOrNull;
              final gratitudeService = gratitudeAsync.valueOrNull;
              return _buildDashboard(
                context,
                journalService,
                dreamCount,
                challengeService,
                gratitudeService,
                isDark,
                isEn,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    JournalService journalService,
    int dreamCount,
    GrowthChallengeService? challengeService,
    GratitudeService? gratitudeService,
    bool isDark,
    bool isEn,
  ) {
    final now = DateTime.now();
    final entries = journalService.getAllEntries();
    final currentStreak = journalService.getCurrentStreak();
    final longestStreak = journalService.getLongestStreak();
    final monthEntries = journalService.getEntriesForMonth(now.year, now.month);

    // Calculate data for growth score
    final focusAreasCoveredThisMonth = _focusAreasCoveredThisMonth(
      monthEntries,
    );
    final consistencyDays = _consistencyDaysLast30(journalService, now);
    final completedChallenges = challengeService?.completedChallengeCount ?? 0;
    final gratitudeCount = gratitudeService?.entryCount ?? 0;

    final growthScore = calculateGrowthScore(
      currentStreak: currentStreak,
      totalEntries: entries.length,
      focusAreasCovered: focusAreasCoveredThisMonth,
      consistencyDays: consistencyDays,
      dreamCount: dreamCount,
      completedChallenges: completedChallenges,
      gratitudeCount: gratitudeCount,
    );

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(title: L10nService.get('growth.growth_dashboard.your_growth', isEn ? AppLanguage.en : AppLanguage.tr)),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ═══════════════════════════════════════════════════════
                // GROWTH SCORE HERO CARD
                // ═══════════════════════════════════════════════════════
                _buildGrowthScoreCard(context, growthScore, isDark, isEn)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(
                      begin: 0.1,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
                const SizedBox(height: AppConstants.spacingXl),

                // ═══════════════════════════════════════════════════════
                // STREAK SECTION
                // ═══════════════════════════════════════════════════════
                _buildStreakSection(
                  context,
                  entries,
                  now,
                  currentStreak,
                  longestStreak,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingXl),

                // ═══════════════════════════════════════════════════════
                // MILESTONES GRID
                // ═══════════════════════════════════════════════════════
                _buildMilestonesSection(
                  context,
                  entries,
                  currentStreak,
                  longestStreak,
                  dreamCount,
                  focusAreasCoveredThisMonth,
                  completedChallenges,
                  gratitudeCount,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingXl),

                // ═══════════════════════════════════════════════════════
                // EXPLORE GROWTH TOOLS
                // ═══════════════════════════════════════════════════════
                _buildExploreSection(
                  context,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingXl),

                // ═══════════════════════════════════════════════════════
                // MONTHLY SUMMARY CARD
                // ═══════════════════════════════════════════════════════
                _buildMonthlySummary(
                  context,
                  monthEntries,
                  dreamCount,
                  completedChallenges,
                  gratitudeCount,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingXl),

                // ═══════════════════════════════════════════════════════
                // SHARE GROWTH BUTTON
                // ═══════════════════════════════════════════════════════
                _buildShareButton(
                  context,
                  growthScore,
                  currentStreak,
                  entries.length,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                ContentDisclaimer(
                  language: isEn ? AppLanguage.en : AppLanguage.tr,
                ),
                ToolEcosystemFooter(
                  currentToolId: 'growthDashboard',
                  isEn: isEn,
                  isDark: isDark,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GROWTH SCORE CALCULATION
  // ══════════════════════════════════════════════════════════════════════════

  int calculateGrowthScore({
    required int currentStreak,
    required int totalEntries,
    required int focusAreasCovered,
    required int consistencyDays,
    required int dreamCount,
    int completedChallenges = 0,
    int gratitudeCount = 0,
  }) {
    final streakScore = (currentStreak.clamp(0, 30) / 30 * 25)
        .round(); // 25% weight
    final entryScore = (totalEntries.clamp(0, 100) / 100 * 15)
        .round(); // 15% weight
    final coverageScore = (focusAreasCovered / 5 * 15).round(); // 15% weight
    final consistencyScore = (consistencyDays / 30 * 15).round(); // 15% weight
    final dreamScore = (dreamCount.clamp(0, 20) / 20 * 10)
        .round(); // 10% weight
    final challengeScore = (completedChallenges.clamp(0, 10) / 10 * 10)
        .round(); // 10% weight
    final gratitudeScore = (gratitudeCount.clamp(0, 30) / 30 * 10)
        .round(); // 10% weight
    return (streakScore +
            entryScore +
            coverageScore +
            consistencyScore +
            dreamScore +
            challengeScore +
            gratitudeScore)
        .clamp(0, 100);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GROWTH SCORE HERO CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildGrowthScoreCard(
    BuildContext context,
    int score,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.auroraStart, AppColors.auroraEnd],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular progress indicator with score
          SizedBox(
            width: 160,
            height: 160,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: score / 100),
              duration: _scoreAnimated
                  ? const Duration(milliseconds: 300)
                  : const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              onEnd: () {
                if (!_scoreAnimated) {
                  setState(() => _scoreAnimated = true);
                }
              },
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 10,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    // Score number
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(value * 100).round()}',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          L10nService.get('growth.growth_dashboard.growth_score', isEn ? AppLanguage.en : AppLanguage.tr),
                          style: AppTypography.elegantAccent(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.85),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Motivational message
          Text(
            _getScoreMessage(score, isEn),
            style: AppTypography.decorativeScript(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(int score, bool isEn) {
    if (score >= 80) {
      return L10nService.get('growth.growth_dashboard.outstanding_you_are_deeply_committed_to', isEn ? AppLanguage.en : AppLanguage.tr);
    } else if (score >= 60) {
      return L10nService.get('growth.growth_dashboard.great_progress_keep_building_your_habits', isEn ? AppLanguage.en : AppLanguage.tr);
    } else if (score >= 30) {
      return L10nService.get('growth.growth_dashboard.good_start_every_entry_brings_you_closer', isEn ? AppLanguage.en : AppLanguage.tr);
    } else {
      return L10nService.get('growth.growth_dashboard.begin_your_progress_one_entry_at_a_time', isEn ? AppLanguage.en : AppLanguage.tr);
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STREAK SECTION
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildStreakSection(
    BuildContext context,
    List<JournalEntry> entries,
    DateTime now,
    int currentStreak,
    int longestStreak,
    bool isDark,
    bool isEn,
  ) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current streak — large and bold
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const AppSymbol('\u{1F525}', size: AppSymbolSize.lg),
              const SizedBox(width: 8),
              Text(
                '$currentStreak',
                style: AppTypography.displayFont.copyWith(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: AppColors.starGold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                L10nService.get('growth.growth_dashboard.days', isEn ? AppLanguage.en : AppLanguage.tr),
                style: AppTypography.displayFont.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Longest streak
          Text(
            L10nService.getWithParams('growth.best_streak_days', isEn ? AppLanguage.en : AppLanguage.tr, params: {'count': '$longestStreak'}),
            style: AppTypography.elegantAccent(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Streak calendar heatmap — last 30 days
          _buildStreakHeatmap(entries, now, isDark),
        ],
      ),
    );
  }

  Widget _buildStreakHeatmap(
    List<JournalEntry> entries,
    DateTime now,
    bool isDark,
  ) {
    final last30 = List.generate(30, (i) {
      final date = now.subtract(Duration(days: 29 - i));
      return DateTime(date.year, date.month, date.day);
    });

    // Build a set of logged date keys for fast lookup
    final loggedKeys = <String>{};
    for (final entry in entries) {
      loggedKeys.add(entry.dateKey);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: last30.map((date) {
          final key =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final hasEntry = loggedKeys.contains(key);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Tooltip(
              message: '${date.day}/${date.month}',
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.95)
                    : AppColors.lightTextPrimary.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: AppTypography.modernAccent(
                color: isDark ? AppColors.textPrimary : Colors.white,
                fontSize: 12,
              ),
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasEntry
                      ? AppColors.starGold
                      : isDark
                      ? AppColors.surfaceDark
                      : AppColors.lightSurfaceVariant,
                  border: hasEntry
                      ? null
                      : Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.06),
                          width: 1,
                        ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MILESTONES GRID
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildMilestonesSection(
    BuildContext context,
    List<JournalEntry> entries,
    int currentStreak,
    int longestStreak,
    int dreamCount,
    int focusAreasCoveredThisMonth,
    int completedChallenges,
    int gratitudeCount,
    bool isDark,
    bool isEn,
  ) {
    final milestones = _buildMilestoneData(
      entries: entries,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      dreamCount: dreamCount,
      focusAreasCoveredThisMonth: focusAreasCoveredThisMonth,
      completedChallenges: completedChallenges,
      gratitudeCount: gratitudeCount,
      isEn: isEn,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('growth.growth_dashboard.milestones', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.modernAccent(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: AppConstants.spacingMd,
            mainAxisSpacing: AppConstants.spacingMd,
          ),
          itemCount: milestones.length,
          itemBuilder: (context, index) {
            final milestone = milestones[index];
            return _buildMilestoneCard(context, milestone, isDark, isEn, index);
          },
        ),
      ],
    );
  }

  Widget _buildMilestoneCard(
    BuildContext context,
    _Milestone milestone,
    bool isDark,
    bool isEn,
    int index,
  ) {
    final unlocked = milestone.unlocked;

    return Container(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: unlocked ? 0.8 : 0.4)
                : unlocked
                ? AppColors.lightCard
                : AppColors.lightSurfaceVariant.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
              color: unlocked
                  ? AppColors.starGold.withValues(alpha: 0.4)
                  : isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with status
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Icon(
                    milestone.icon,
                    size: 32,
                    color: unlocked
                        ? AppColors.starGold
                        : isDark
                        ? AppColors.textMuted.withValues(alpha: 0.4)
                        : AppColors.lightTextMuted.withValues(alpha: 0.5),
                  ),
                  if (unlocked)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 10,
                        color: Colors.white,
                      ),
                    )
                  else
                    Icon(
                      Icons.lock,
                      size: 14,
                      color: isDark
                          ? AppColors.textMuted.withValues(alpha: 0.5)
                          : AppColors.lightTextMuted,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                milestone.title,
                style: AppTypography.elegantAccent(
                  fontSize: 13,
                  color: unlocked
                      ? (isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary)
                      : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Progress hint
              if (!unlocked)
                Text(
                  milestone.progressHint,
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted.withValues(alpha: 0.6)
                        : AppColors.lightTextMuted,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        )
        .animate(delay: (50 * index).ms)
        .fadeIn(duration: 300.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  List<_Milestone> _buildMilestoneData({
    required List<JournalEntry> entries,
    required int currentStreak,
    required int longestStreak,
    required int dreamCount,
    required int focusAreasCoveredThisMonth,
    required int completedChallenges,
    required int gratitudeCount,
    required bool isEn,
  }) {
    final maxStreak = math.max(currentStreak, longestStreak);

    return [
      _Milestone(
        icon: Icons.edit_note,
        title: L10nService.get('growth.growth_dashboard.first_entry', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: entries.isNotEmpty,
        progressHint: L10nService.get('growth.growth_dashboard.1_entry_to_activate', isEn ? AppLanguage.en : AppLanguage.tr),
      ),
      _Milestone(
        icon: Icons.local_fire_department,
        title: L10nService.get('growth.growth_dashboard.7day_observer', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: maxStreak >= 7,
        progressHint: maxStreak < 7
            ? isEn
                  ? '${7 - maxStreak} more to activate'
                  : '${7 - maxStreak} gün daha'
            : '',
      ),
      _Milestone(
        icon: Icons.auto_graph,
        title: L10nService.get('growth.growth_dashboard.pattern_seeker', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: entries.length >= 7,
        progressHint: entries.length < 7
            ? isEn
                  ? '${7 - entries.length} more entries'
                  : '${7 - entries.length} kayıt daha'
            : '',
      ),
      _Milestone(
        icon: Icons.nights_stay,
        title: L10nService.get('growth.growth_dashboard.dream_logger', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: dreamCount >= 3,
        progressHint: dreamCount < 3
            ? isEn
                  ? '${3 - dreamCount} more dreams'
                  : '${3 - dreamCount} rüya daha'
            : '',
      ),
      _Milestone(
        icon: Icons.emoji_events,
        title: L10nService.get('growth.growth_dashboard.challenge_completer', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: completedChallenges >= 3,
        progressHint: completedChallenges < 3
            ? isEn
                  ? '${3 - completedChallenges} challenges left'
                  : '${3 - completedChallenges} görev kaldı'
            : '',
      ),
      _Milestone(
        icon: Icons.favorite,
        title: L10nService.get('growth.growth_dashboard.gratitude_streak', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: gratitudeCount >= 7,
        progressHint: gratitudeCount < 7
            ? isEn
                  ? '${7 - gratitudeCount} gratitude entries'
                  : '${7 - gratitudeCount} şükran kaydı'
            : '',
      ),
      _Milestone(
        icon: Icons.emoji_events,
        title: L10nService.get('growth.growth_dashboard.30day_streak', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: maxStreak >= 30,
        progressHint: maxStreak < 30
            ? isEn
                  ? '${30 - maxStreak} more to activate'
                  : '${30 - maxStreak} gün daha'
            : '',
      ),
      _Milestone(
        icon: Icons.psychology,
        title: L10nService.get('growth.growth_dashboard.self_aware', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: focusAreasCoveredThisMonth >= 5,
        progressHint: focusAreasCoveredThisMonth < 5
            ? isEn
                  ? '${5 - focusAreasCoveredThisMonth} more areas'
                  : '${5 - focusAreasCoveredThisMonth} alan daha'
            : '',
      ),
      _Milestone(
        icon: Icons.share,
        title: L10nService.get('growth.growth_dashboard.story_teller', isEn ? AppLanguage.en : AppLanguage.tr),
        unlocked: false,
        progressHint: L10nService.get('growth.growth_dashboard.share_your_progress', isEn ? AppLanguage.en : AppLanguage.tr),
      ),
    ];
  }

  // ══════════════════════════════════════════════════════════════════════════
  // EXPLORE GROWTH TOOLS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildExploreSection(BuildContext context, bool isDark, bool isEn) {
    final tools = [
      _GrowthTool(
        icon: Icons.fingerprint_outlined,
        title: L10nService.get('growth.growth_dashboard.your_archetype', isEn ? AppLanguage.en : AppLanguage.tr),
        subtitle: L10nService.get('growth.growth_dashboard.emotional_profile', isEn ? AppLanguage.en : AppLanguage.tr),
        route: Routes.archetype,
        color: AppColors.amethyst,
      ),
      _GrowthTool(
        icon: Icons.visibility_off_outlined,
        title: L10nService.get('growth.growth_dashboard.blind_spots', isEn ? AppLanguage.en : AppLanguage.tr),
        subtitle: L10nService.get('growth.growth_dashboard.hidden_patterns', isEn ? AppLanguage.en : AppLanguage.tr),
        route: Routes.blindSpot,
        color: AppColors.brandPink,
      ),
      // compatibility/relationship reflection removed (killed feature)
      _GrowthTool(
        icon: Icons.military_tech_outlined,
        title: L10nService.get('growth.growth_dashboard.milestones_1', isEn ? AppLanguage.en : AppLanguage.tr),
        subtitle: L10nService.get('growth.growth_dashboard.achievements', isEn ? AppLanguage.en : AppLanguage.tr),
        route: Routes.milestones,
        color: AppColors.starGold,
      ),
      _GrowthTool(
        icon: Icons.lightbulb_outline_rounded,
        title: L10nService.get('growth.growth_dashboard.microhabits', isEn ? AppLanguage.en : AppLanguage.tr),
        subtitle: L10nService.get('growth.growth_dashboard.56_habits_to_try', isEn ? AppLanguage.en : AppLanguage.tr),
        route: Routes.habitSuggestions,
        color: AppColors.success,
      ),
      _GrowthTool(
        icon: Icons.psychology_alt_outlined,
        title: L10nService.get('growth.growth_dashboard.insights', isEn ? AppLanguage.en : AppLanguage.tr),
        subtitle: L10nService.get('growth.growth_dashboard.36_modules', isEn ? AppLanguage.en : AppLanguage.tr),
        route: Routes.insightsDiscovery,
        color: AppColors.auroraEnd,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('growth.growth_dashboard.explore_growth_tools', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.aurora,
          style: AppTypography.modernAccent(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: AppConstants.spacingSm,
            mainAxisSpacing: AppConstants.spacingSm,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return Semantics(
                  label: tool.title,
                  button: true,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.push(tool.route);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? tool.color.withValues(alpha: 0.08)
                            : tool.color.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                        border: Border.all(
                          color: tool.color.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: tool.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(tool.icon, color: tool.color, size: 22),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tool.title,
                            style: AppTypography.elegantAccent(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                              letterSpacing: 0.8,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tool.subtitle,
                            style: AppTypography.subtitle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate(delay: Duration(milliseconds: 50 * index))
                .fadeIn(duration: 300.ms);
          },
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MONTHLY SUMMARY CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildMonthlySummary(
    BuildContext context,
    List<JournalEntry> monthEntries,
    int dreamCount,
    int completedChallenges,
    int gratitudeCount,
    bool isDark,
    bool isEn,
  ) {
    // Most tracked focus area this month
    final areaCount = <FocusArea, int>{};
    for (final entry in monthEntries) {
      areaCount[entry.focusArea] = (areaCount[entry.focusArea] ?? 0) + 1;
    }
    FocusArea? mostTracked;
    if (areaCount.isNotEmpty) {
      final sorted = areaCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      mostTracked = sorted.first.key;
    }

    // Average overall rating
    double avgRating = 0;
    if (monthEntries.isNotEmpty) {
      final sum = monthEntries
          .map((e) => e.overallRating)
          .reduce((a, b) => a + b);
      avgRating = sum / monthEntries.length;
    }

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('growth.growth_dashboard.this_month', isEn ? AppLanguage.en : AppLanguage.tr),
            variant: GradientTextVariant.gold,
            style: AppTypography.modernAccent(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildSummaryRow(
            icon: Icons.edit_note,
            label: L10nService.get('growth.growth_dashboard.entries_this_month', isEn ? AppLanguage.en : AppLanguage.tr),
            value: '${monthEntries.length}',
            color: AppColors.auroraStart,
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSummaryRow(
            icon: Icons.category,
            label: L10nService.get('growth.growth_dashboard.most_tracked_area', isEn ? AppLanguage.en : AppLanguage.tr),
            value: mostTracked != null
                ? (isEn ? mostTracked.displayNameEn : mostTracked.displayNameTr)
                : (L10nService.get('growth.growth_dashboard.none_yet', isEn ? AppLanguage.en : AppLanguage.tr)),
            color: AppColors.starGold,
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSummaryRow(
            icon: Icons.sentiment_satisfied_alt,
            label: L10nService.get('growth.growth_dashboard.average_mood', isEn ? AppLanguage.en : AppLanguage.tr),
            value: monthEntries.isNotEmpty
                ? '${avgRating.toStringAsFixed(1)} / 5'
                : (L10nService.get('growth.growth_dashboard.na', isEn ? AppLanguage.en : AppLanguage.tr)),
            color: AppColors.success,
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSummaryRow(
            icon: Icons.nights_stay,
            label: L10nService.get('growth.growth_dashboard.dreams_logged', isEn ? AppLanguage.en : AppLanguage.tr),
            value: '$dreamCount',
            color: AppColors.amethyst,
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSummaryRow(
            icon: Icons.emoji_events,
            label: L10nService.get('growth.growth_dashboard.challenges_completed', isEn ? AppLanguage.en : AppLanguage.tr),
            value: '$completedChallenges',
            color: AppColors.celestialGold,
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSummaryRow(
            icon: Icons.favorite,
            label: L10nService.get('growth.growth_dashboard.gratitude_entries', isEn ? AppLanguage.en : AppLanguage.tr),
            value: '$gratitudeCount',
            color: AppColors.softCoral,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHARE GROWTH BUTTON
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildShareButton(
    BuildContext context,
    int score,
    int streak,
    int totalEntries,
    bool isDark,
    bool isEn,
  ) {
    return GradientButton.gold(
      label: L10nService.get('growth.growth_dashboard.share_your_progress_1', isEn ? AppLanguage.en : AppLanguage.tr),
      icon: Icons.share,
      onPressed: () => _shareProgress(score, streak, totalEntries, isEn),
      expanded: true,
    );
  }

  void _shareProgress(int score, int streak, int totalEntries, bool isEn) {
    final text = isEn
        ? 'My InnerCycles Growth Score: $score/100\n'
              'Current streak: $streak days\n'
              'Total entries: $totalEntries\n\n'
              '${AppConstants.appStoreUrl}\n#InnerCycles #GrowthScore'
        : 'InnerCycles Büyüme Puanım: $score/100\n'
              'Mevcut seri: $streak gün\n'
              'Toplam kayıt: $totalEntries\n\n'
              '${AppConstants.appStoreUrl}\n#InnerCycles';

    SharePlus.instance.share(ShareParams(text: text));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ══════════════════════════════════════════════════════════════════════════

  /// Count how many distinct FocusArea values have been logged this month
  int _focusAreasCoveredThisMonth(List<JournalEntry> monthEntries) {
    final areas = <FocusArea>{};
    for (final entry in monthEntries) {
      areas.add(entry.focusArea);
    }
    return areas.length;
  }

  /// Count days with at least one entry in the last 30 days
  int _consistencyDaysLast30(JournalService service, DateTime now) {
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final entries = service.getEntriesByDateRange(thirtyDaysAgo, now);
    final uniqueDays = <String>{};
    for (final entry in entries) {
      uniqueDays.add(entry.dateKey);
    }
    return uniqueDays.length;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MILESTONE DATA MODEL
// ════════════════════════════════════════════════════════════════════════════

class _Milestone {
  final IconData icon;
  final String title;
  final bool unlocked;
  final String progressHint;

  const _Milestone({
    required this.icon,
    required this.title,
    required this.unlocked,
    required this.progressHint,
  });
}

class _GrowthTool {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;

  const _GrowthTool({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });
}
