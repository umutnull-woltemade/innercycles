// ════════════════════════════════════════════════════════════════════════════
// HABIT ADOPTION SCREEN - Adopted habits portfolio with analytics
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/content/habit_suggestions_content.dart';
import '../../../data/services/habit_suggestion_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class HabitAdoptionScreen extends ConsumerWidget {
  const HabitAdoptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(habitSuggestionServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final adopted = service.getAdoptedHabits();
              final bookmarked = service.getBookmarked();
              final progress = service.explorationProgress;

              if (adopted.isEmpty && bookmarked.isEmpty) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'My Habits' : 'Alışkanlıklarım',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Your adopted habit portfolio'
                                : 'Benimsenen alışkanlık portföyün',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview hero
                          _OverviewHero(
                            adoptedCount: service.adoptedCount,
                            triedCount: service.triedCount,
                            progress: progress,
                            todayDone: service.todayCompletedCount,
                            todayTotal: service.todayTotalAdopted,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Adopted habits
                          if (adopted.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Adopted (${adopted.length})'
                                  : 'Benimsenen (${adopted.length})',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...adopted.map((habit) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 10),
                                  child: _HabitTile(
                                    habit: habit,
                                    service: service,
                                    isEn: isEn,
                                    isDark: isDark,
                                    onToggle: () async {
                                      if (service
                                          .isCheckedToday(habit.id)) {
                                        await service.uncheckToday(habit.id);
                                      } else {
                                        await service.checkOffToday(habit.id);
                                      }
                                      ref.invalidate(
                                          habitSuggestionServiceProvider);
                                    },
                                  ),
                                )),
                            const SizedBox(height: 24),
                          ],

                          // Bookmarked
                          if (bookmarked.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Bookmarked (${bookmarked.length})'
                                  : 'Kaydedilen (${bookmarked.length})',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: bookmarked.map((habit) {
                                final emoji =
                                    HabitSuggestionService
                                        .categoryEmoji(
                                            habit.category);
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    color: AppColors.starGold
                                        .withValues(alpha: 0.08),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(emoji,
                                          style: const TextStyle(
                                              fontSize: 14)),
                                      const SizedBox(width: 6),
                                      Text(
                                        isEn
                                            ? habit.titleEn
                                            : habit.titleTr,
                                        style:
                                            AppTypography.elegantAccent(
                                          fontSize: 12,
                                          color: AppColors.starGold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OverviewHero extends StatelessWidget {
  final int adoptedCount;
  final int triedCount;
  final double progress;
  final int todayDone;
  final int todayTotal;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.adoptedCount,
    required this.triedCount,
    required this.progress,
    required this.todayDone,
    required this.todayTotal,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat(
                  value: '$adoptedCount',
                  label: isEn ? 'Adopted' : 'Benimsenen',
                  color: AppColors.auroraStart,
                  isDark: isDark,
                ),
                _Stat(
                  value: '$triedCount',
                  label: isEn ? 'Tried' : 'Denenen',
                  color: AppColors.starGold,
                  isDark: isDark,
                ),
                _Stat(
                  value: '${(progress * 100).round()}%',
                  label: isEn ? 'Explored' : 'Keşfedilen',
                  color: AppColors.amethyst,
                  isDark: isDark,
                ),
                _Stat(
                  value: '$todayDone/$todayTotal',
                  label: isEn ? 'Today' : 'Bugün',
                  color: AppColors.success,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.06),
                valueColor:
                    AlwaysStoppedAnimation(AppColors.auroraStart),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _Stat({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.modernAccent(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 9,
            color:
                isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _HabitTile extends StatelessWidget {
  final HabitSuggestion habit;
  final HabitSuggestionService service;
  final bool isEn;
  final bool isDark;
  final VoidCallback onToggle;

  const _HabitTile({
    required this.habit,
    required this.service,
    required this.isEn,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final streak = service.getHabitStreak(habit.id);
    final total = service.getTotalCompletions(habit.id);
    final weekDays = service.getWeekCompletions(habit.id);
    final isChecked = service.isCheckedToday(habit.id);
    final emoji = HabitSuggestionService.categoryEmoji(habit.category);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isEn ? habit.titleEn : habit.titleTr,
                  style: AppTypography.modernAccent(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isChecked
                        ? AppColors.success.withValues(alpha: 0.15)
                        : (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
                    border: Border.all(
                      color: isChecked
                          ? AppColors.success
                          : (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.15),
                    ),
                  ),
                  child: isChecked
                      ? Icon(Icons.check_rounded,
                          size: 16, color: AppColors.success)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Stats row
          Row(
            children: [
              Icon(Icons.local_fire_department_rounded,
                  size: 12, color: AppColors.starGold),
              const SizedBox(width: 4),
              Text(
                '$streak${isEn ? 'd' : 'g'}',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: AppColors.starGold,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.check_circle_outline_rounded,
                  size: 12, color: AppColors.auroraStart),
              const SizedBox(width: 4),
              Text(
                '$total${isEn ? ' total' : ' toplam'}',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: AppColors.auroraStart,
                ),
              ),
              const Spacer(),
              // 7-day dots
              ...List.generate(7, (i) {
                final done = i < weekDays.length && weekDays[i];
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done
                        ? AppColors.success.withValues(alpha: 0.6)
                        : (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
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

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'My Habits' : 'Alışkanlıklarım',
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F3AF}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Adopt habits from the library to track your consistency here'
                            : 'Tutarlılığını burada takip etmek için kütüphaneden alışkanlık benimse',
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
