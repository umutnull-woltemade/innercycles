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
  final bool isEn;
  final bool isDark;

  const MoodHabitCorrelationCard({
    super.key,
    required this.isEn,
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
    final adoptedHabits = habitService.getAdoptedHabits();
    if (adoptedHabits.isEmpty) return const SizedBox.shrink();

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

    for (final habit in adoptedHabits) {
      final checkDates = <String>{};
      // Get all completion dates from the last 90 days
      final now = DateTime.now();
      for (int i = 0; i < 90; i++) {
        final d = now.subtract(Duration(days: i));
        final key =
            '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        if (habitService.isCheckedToday(habit.id) && i == 0) {
          checkDates.add(key);
        }
      }

      // Use the service's internal check dates
      final weekCompletions = habitService.getWeekCompletions(habit.id);
      final totalCompletions = habitService.getTotalCompletions(habit.id);

      if (totalCompletions < 3) continue;

      // Calculate mood on habit days vs non-habit days
      double habitDayMoodSum = 0;
      int habitDayCount = 0;
      double nonHabitDayMoodSum = 0;
      int nonHabitDayCount = 0;

      // Check last 30 days
      for (int i = 0; i < 30; i++) {
        final d = now.subtract(Duration(days: i));
        final dateKey =
            '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        final mood = moodByDate[dateKey];
        if (mood == null) continue;

        // Check if habit was completed on this day using week completions pattern
        final dayIndex = 6 - i; // weekCompletions is last 7 days, index 6 = today
        bool wasCompleted = false;
        if (i < 7 && dayIndex >= 0 && dayIndex < weekCompletions.length) {
          wasCompleted = weekCompletions[dayIndex];
        }

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

    final language = AppLanguage.fromIsEn(isEn);
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
