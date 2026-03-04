import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/mood_checkin_service.dart';
import '../../../../data/services/habit_suggestion_service.dart';
import '../../../../data/content/habit_suggestions_content.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';

/// Shows mood-habit correlation insight on the home feed.
/// E.g. "On days you completed Morning Walk, your mood averaged 4.2 vs 2.8"
class MoodHabitCorrelationCard extends ConsumerWidget {
  final AppLanguage language;
  final bool isDark;

  const MoodHabitCorrelationCard({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final habitAsync = ref.watch(habitSuggestionServiceProvider);

    return moodAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (moodService) => habitAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
        data: (habitService) =>
            _build(context, moodService, habitService),
      ),
    );
  }

  Widget _build(
    BuildContext context,
    MoodCheckinService moodService,
    HabitSuggestionService habitService,
  ) {
    final isEn = language == AppLanguage.en;
    final adoptedHabits = habitService.getAdoptedHabits();
    if (adoptedHabits.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.amethyst.withValues(alpha: isDark ? 0.06 : 0.04),
          ),
          child: Row(
            children: [
              Icon(
                Icons.insights_rounded,
                size: 16,
                color: AppColors.amethyst.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEn
                      ? 'Adopt a habit to discover mood-habit links'
                      : 'Ruh hali-alışkanlık bağlantılarını keşfetmek için bir alışkanlık edin',
                  style: AppTypography.subtitle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 600.ms, duration: 300.ms);
    }

    final allMoods = moodService.getAllEntries();
    if (allMoods.length < 7) return const SizedBox.shrink();

    // Build date→mood map
    final moodByDate = <String, int>{};
    for (final entry in allMoods) {
      final key =
          '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')}';
      moodByDate[key] = entry.mood;
    }

    // Compute correlation for each adopted habit
    _HabitCorrelation? bestCorrelation;
    double bestDiff = 0;

    final now = DateTime.now();

    for (final habit in adoptedHabits) {
      final weekCompletions = habitService.getWeekCompletions(habit.id);
      final totalCompletions = habitService.getTotalCompletions(habit.id);

      if (totalCompletions < 3) continue;

      // Calculate mood on habit days vs non-habit days (last 7 days only —
      // weekCompletions only covers 7 days, index 0 = 6 days ago, index 6 = today)
      double habitDayMoodSum = 0;
      int habitDayCount = 0;
      double nonHabitDayMoodSum = 0;
      int nonHabitDayCount = 0;

      for (int i = 0; i < 7; i++) {
        final d = now.subtract(Duration(days: i));
        final dateKey =
            '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        final mood = moodByDate[dateKey];
        if (mood == null) continue;

        final dayIndex = 6 - i;
        final wasCompleted =
            dayIndex >= 0 && dayIndex < weekCompletions.length && weekCompletions[dayIndex];

        if (wasCompleted) {
          habitDayMoodSum += mood;
          habitDayCount++;
        } else {
          nonHabitDayMoodSum += mood;
          nonHabitDayCount++;
        }
      }

      if (habitDayCount >= 2 && nonHabitDayCount >= 2) {
        final habitAvg = habitDayMoodSum / habitDayCount;
        final nonHabitAvg = nonHabitDayMoodSum / nonHabitDayCount;
        final diff = habitAvg - nonHabitAvg;

        if (diff.abs() > bestDiff && diff > 0) {
          bestDiff = diff.abs();
          bestCorrelation = _HabitCorrelation(
            habit: habit,
            habitDayAvg: habitAvg,
            nonHabitDayAvg: nonHabitAvg,
            diff: diff,
            habitDayCount: habitDayCount,
          );
        }
      }
    }

    if (bestCorrelation == null || bestDiff < 0.3) {
      return const SizedBox.shrink();
    }

    final habitName = bestCorrelation.habit.localizedTitle(language);
    final avgWith = bestCorrelation.habitDayAvg.toStringAsFixed(1);
    final avgWithout = bestCorrelation.nonHabitDayAvg.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PremiumCard(
        style: PremiumCardStyle.amethyst,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights_rounded,
                  size: 18,
                  color: AppColors.amethyst,
                ),
                const SizedBox(width: 8),
                GradientText(
                  isEn ? 'Habit Insight' : 'Alışkanlık İçgörüsü',
                  variant: GradientTextVariant.amethyst,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isEn
                  ? 'On days you complete "$habitName", your mood averages $avgWith vs $avgWithout on other days.'
                  : '"$habitName" yaptığın günlerde ruh halin ortalama $avgWith, diğer günlerde $avgWithout.',
              style: AppTypography.subtitle(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 10),
            // Visual bar comparison
            Row(
              children: [
                Expanded(
                  child: _MoodBar(
                    label: isEn ? 'With habit' : 'Alışkanlıkla',
                    value: bestCorrelation.habitDayAvg / 5,
                    color: AppColors.success,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MoodBar(
                    label: isEn ? 'Without' : 'Olmadan',
                    value: bestCorrelation.nonHabitDayAvg / 5,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 600.ms, duration: 400.ms).slideY(
            begin: 0.08,
            duration: 400.ms,
          ),
    );
  }
}

class _MoodBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isDark;

  const _MoodBar({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _HabitCorrelation {
  final HabitSuggestion habit;
  final double habitDayAvg;
  final double nonHabitDayAvg;
  final double diff;
  final int habitDayCount;

  const _HabitCorrelation({
    required this.habit,
    required this.habitDayAvg,
    required this.nonHabitDayAvg,
    required this.diff,
    required this.habitDayCount,
  });
}
