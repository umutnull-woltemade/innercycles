// ════════════════════════════════════════════════════════════════════════════
// DAILY HABITS SCREEN - Recurring Check-Off Tracker for Adopted Habits
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/habit_suggestions_content.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/habit_suggestion_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';

class DailyHabitsScreen extends ConsumerStatefulWidget {
  const DailyHabitsScreen({super.key});

  @override
  ConsumerState<DailyHabitsScreen> createState() => _DailyHabitsScreenState();
}

class _DailyHabitsScreenState extends ConsumerState<DailyHabitsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('dailyHabits'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('dailyHabits', source: 'direct'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(habitSuggestionServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Text(
              CommonStrings.somethingWentWrong(language),
              style: AppTypography.subtitle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          data: (service) => _buildContent(context, service, isDark, isEn),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    HabitSuggestionService service,
    bool isDark,
    bool isEn,
  ) {
    final adoptedHabits = service.getAdoptedHabits();
    final completedCount = service.todayCompletedCount;
    final totalAdopted = adoptedHabits.length;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(title: isEn ? 'Routine Tracker' : 'Rutin Takipçisi'),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (adoptedHabits.isEmpty) ...[
                _EmptyState(isDark: isDark, isEn: isEn),
              ] else ...[
                // Progress header
                _ProgressHeader(
                  completed: completedCount,
                  total: totalAdopted,
                  isDark: isDark,
                  isEn: isEn,
                ),
                const SizedBox(height: 20),

                // Habit check-off cards
                ...adoptedHabits.asMap().entries.map((entry) {
                  final index = entry.key;
                  final habit = entry.value;
                  final isChecked = service.isCheckedToday(habit.id);
                  final streak = service.getHabitStreak(habit.id);
                  final weekData = service.getWeekCompletions(habit.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _HabitCheckCard(
                      habit: habit,
                      isChecked: isChecked,
                      streak: streak,
                      weekData: weekData,
                      isDark: isDark,
                      isEn: isEn,
                      onToggle: () async {
                        HapticFeedback.mediumImpact();
                        if (isChecked) {
                          await service.uncheckToday(habit.id);
                        } else {
                          await service.checkOffToday(habit.id);
                        }
                        if (!mounted) return;
                        setState(() {});
                      },
                    ),
                  ).animate().fadeIn(
                    duration: 300.ms,
                    delay: Duration(milliseconds: (60 * index).clamp(0, 400)),
                  );
                }),

                const SizedBox(height: 16),

                // Browse more habits link
                Center(
                  child: Semantics(
                    label: isEn
                        ? 'Browse all habits'
                        : 'Tüm alışkanlıkları gözat',
                    button: true,
                    child: GestureDetector(
                      onTap: () => context.push(Routes.habitSuggestions),
                      behavior: HitTestBehavior.opaque,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 44),
                        child: Center(
                          child: Text(
                            isEn
                                ? 'Browse all habits'
                                : 'Tüm alışkanlıkları gözat',
                            style: AppTypography.elegantAccent(
                              fontSize: 14,
                              color: AppColors.auroraStart,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              ToolEcosystemFooter(
                currentToolId: 'dailyHabits',
                isEn: isEn,
                isDark: isDark,
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PROGRESS HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _ProgressHeader extends StatelessWidget {
  final int completed;
  final int total;
  final bool isDark;
  final bool isEn;

  const _ProgressHeader({
    required this.completed,
    required this.total,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final allDone = completed == total && total > 0;
    final progress = total > 0 ? completed / total : 0.0;

    return PremiumCard(
      style: allDone ? PremiumCardStyle.aurora : PremiumCardStyle.gold,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          allDone
              ? Text(
                  isEn ? 'All done for today!' : 'Bugün hepsi tamamlandı!',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                )
              : GradientText(
                  isEn ? 'Today\'s Progress' : 'Bugünkü İlerleme',
                  variant: GradientTextVariant.gold,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          const SizedBox(height: 12),
          Row(
            children: [
              allDone
                  ? Text(
                      '$completed / $total',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    )
                  : GradientText(
                      '$completed / $total',
                      variant: GradientTextVariant.gold,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      allDone ? AppColors.success : AppColors.starGold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HABIT CHECK CARD
// ═══════════════════════════════════════════════════════════════════════════

class _HabitCheckCard extends StatelessWidget {
  final HabitSuggestion habit;
  final bool isChecked;
  final int streak;
  final List<bool> weekData;
  final bool isDark;
  final bool isEn;
  final VoidCallback onToggle;

  const _HabitCheckCard({
    required this.habit,
    required this.isChecked,
    required this.streak,
    required this.weekData,
    required this.isDark,
    required this.isEn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        children: [
          Row(
            children: [
              // Check circle
              Semantics(
                label: isChecked
                    ? (isEn
                          ? 'Mark incomplete'
                          : 'Tamamlanmadı olarak işaretle')
                    : (isEn ? 'Mark complete' : 'Tamamlandı olarak işaretle'),
                button: true,
                child: GestureDetector(
                  onTap: onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isChecked
                              ? AppColors.success
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.black.withValues(alpha: 0.06)),
                          border: isChecked
                              ? null
                              : Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : Colors.black.withValues(alpha: 0.12),
                                  width: 2,
                                ),
                        ),
                        child: isChecked
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title + category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? habit.titleEn : habit.titleTr,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${HabitSuggestionService.categoryEmoji(habit.category)} ${habit.durationMinutes} ${isEn ? 'min' : 'dk'}',
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Streak badge
              if (streak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.starGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 14,
                        color: AppColors.starGold,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$streak',
                        style: AppTypography.modernAccent(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.starGold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Week dots
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...(isEn
                      ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                      : ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pa'])
                  .asMap()
                  .entries
                  .map((e) {
                    final i = e.key;
                    final day = e.value;
                    final done = weekData[i];

                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Column(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: done
                                  ? AppColors.success.withValues(alpha: 0.8)
                                  : (isDark
                                        ? Colors.white.withValues(alpha: 0.06)
                                        : Colors.black.withValues(alpha: 0.06)),
                            ),
                            child: done
                                ? const Icon(
                                    Icons.check,
                                    size: 10,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            day,
                            style: AppTypography.elegantAccent(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyState({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return PremiumEmptyState(
      icon: Icons.playlist_add_check_rounded,
      title: isEn ? 'No habits adopted yet' : 'Henüz benimsenen alışkanlık yok',
      description: isEn
          ? 'Browse the habit library and adopt habits to track them daily'
          : 'Alışkanlık kütüphanesine göz at ve günlük takip için alışkanlık benimse',
      gradientVariant: GradientTextVariant.gold,
      ctaLabel: isEn ? 'Browse Habits' : 'Alışkanlıkları Gözat',
      onCtaPressed: () => context.push(Routes.habitSuggestions),
    );
  }
}
