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
import '../../../data/content/habit_suggestions_content.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/habit_suggestion_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
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
      ref.read(smartRouterServiceProvider).whenData((s) => s.recordToolVisit('dailyHabits'));
      ref.read(ecosystemAnalyticsServiceProvider).whenData((s) => s.trackToolOpen('dailyHabits', source: 'direct'));
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
              style: TextStyle(
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
        GlassSliverAppBar(
          title: isEn ? 'Daily Habits' : 'Günlük Alışkanlıklar',
        ),
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
                  child: GestureDetector(
                    onTap: () => context.push(Routes.habitSuggestions),
                    child: Text(
                      isEn ? 'Browse all habits' : 'Tüm alışkanlıkları gözat',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.auroraStart,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],

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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: allDone
              ? [
                  AppColors.success.withValues(alpha: isDark ? 0.2 : 0.1),
                  AppColors.success.withValues(alpha: isDark ? 0.08 : 0.04),
                ]
              : [
                  AppColors.starGold.withValues(alpha: isDark ? 0.15 : 0.08),
                  AppColors.auroraStart.withValues(alpha: isDark ? 0.08 : 0.04),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allDone
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.starGold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            allDone
                ? (isEn ? 'All done for today!' : 'Bugün hepsi tamamlandı!')
                : (isEn ? 'Today\'s Progress' : 'Bugünkü İlerleme'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: allDone
                  ? AppColors.success
                  : (isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$completed / $total',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: allDone ? AppColors.success : AppColors.starGold,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isChecked
            ? AppColors.success.withValues(alpha: isDark ? 0.12 : 0.06)
            : (isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                : AppColors.lightCard),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isChecked
              ? AppColors.success.withValues(alpha: 0.3)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Check circle
              Semantics(
                label: isChecked
                    ? (isEn ? 'Mark incomplete' : 'Tamamlanmadı olarak işaretle')
                    : (isEn ? 'Mark complete' : 'Tamamlandı olarak işaretle'),
                button: true,
                child: GestureDetector(
                  onTap: onToggle,
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
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 20)
                        : null,
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        decoration:
                            isChecked ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${HabitSuggestionService.categoryEmoji(habit.category)} ${habit.durationMinutes} min',
                      style: TextStyle(
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
                        style: TextStyle(
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
              ...['M', 'T', 'W', 'T', 'F', 'S', 'S'].asMap().entries.map(
                (e) {
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
                              ? const Icon(Icons.check,
                                  size: 10, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.playlist_add_check_rounded,
            size: 64,
            color: AppColors.starGold.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 20),
          Text(
            isEn
                ? 'No habits adopted yet'
                : 'Henüz benimsenen alışkanlık yok',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Browse the habit library and adopt habits to track them daily'
                : 'Alışkanlık kütüphanesine göz at ve günlük takip için alışkanlık benimse',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.push(Routes.habitSuggestions),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.starGold,
              foregroundColor: AppColors.deepSpace,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: Text(
              isEn ? 'Browse Habits' : 'Alışkanlıkları Gözat',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
