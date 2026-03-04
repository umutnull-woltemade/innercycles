import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/content/habit_suggestions_content.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/tap_scale.dart';

class DailyHabitsStrip extends ConsumerWidget {
  final AppLanguage language;
  final bool isDark;

  const DailyHabitsStrip({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = language == AppLanguage.en;
    final habitAsync = ref.watch(habitSuggestionServiceProvider);

    return habitAsync.maybeWhen(
      data: (service) {
        final adopted = service.getAdoptedHabits();

        // No adopted habits — show daily teaser
        if (adopted.isEmpty) {
          final daily = service.getDailyHabit();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: TapScale(
              onTap: () {
                HapticService.selectionTap();
                context.push(Routes.habitSuggestions);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.starGold.withValues(alpha: 0.08),
                  border: Border.all(
                    color: AppColors.starGold.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 16,
                      color: AppColors.starGold,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        daily.localizedTitle(language),
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      isEn ? 'Discover' : 'Ke\u{015F}fet',
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.starGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 300.ms);
        }

        // Show adopted habits as horizontal chip strip
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: adopted.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final habit = adopted[index];
                final checked = service.isCheckedToday(habit.id);
                return _HabitChip(
                  habit: habit,
                  checked: checked,
                  language: language,
                  isDark: isDark,
                  onTap: () async {
                    HapticService.selectionTap();
                    if (checked) {
                      await service.uncheckToday(habit.id);
                    } else {
                      await service.checkOffToday(habit.id);
                    }
                    ref.invalidate(habitSuggestionServiceProvider);
                  },
                );
              },
            ),
          ),
        ).animate().fadeIn(delay: 250.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _HabitChip extends StatelessWidget {
  final HabitSuggestion habit;
  final bool checked;
  final AppLanguage language;
  final bool isDark;
  final VoidCallback onTap;

  const _HabitChip({
    required this.habit,
    required this.checked,
    required this.language,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: checked
              ? AppColors.success.withValues(alpha: 0.15)
              : (isDark
                  ? AppColors.surfaceDark
                  : AppColors.lightSurfaceVariant),
          border: Border.all(
            color: checked
                ? AppColors.success.withValues(alpha: 0.4)
                : AppColors.textMuted.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              checked
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 16,
              color: checked
                  ? AppColors.success
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 6),
            Text(
              habit.localizedTitle(language),
              style: AppTypography.elegantAccent(
                fontSize: 12,
                fontWeight: checked ? FontWeight.w600 : FontWeight.w500,
                color: checked
                    ? AppColors.success
                    : (isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
