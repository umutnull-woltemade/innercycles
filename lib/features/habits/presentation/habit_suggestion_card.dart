// ════════════════════════════════════════════════════════════════════════════
// HABIT SUGGESTION CARD - Daily Micro-Habit Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/habit_suggestion_service.dart';

class HabitSuggestionCard extends ConsumerWidget {
  const HabitSuggestionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(habitSuggestionServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final habit = service.getDailyHabit();
        final progress = service.explorationProgress;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(Routes.habitSuggestions);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.success.withValues(alpha: 0.12),
                        AppColors.auroraStart.withValues(alpha: 0.08),
                        AppColors.surfaceDark.withValues(alpha: 0.9),
                      ]
                    : [
                        AppColors.success.withValues(alpha: 0.06),
                        AppColors.auroraStart.withValues(alpha: 0.03),
                        AppColors.lightCard,
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success
                      .withValues(alpha: isDark ? 0.06 : 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        HabitSuggestionService.categoryEmoji(habit.category),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isEn ? 'Daily Habit' : 'Günlük Alışkanlık',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    // Progress badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Habit title
                Text(
                  isEn ? habit.titleEn : habit.titleTr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                // Description preview
                Text(
                  isEn ? habit.descriptionEn : habit.descriptionTr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 12),

                // Bottom row
                Row(
                  children: [
                    // Category pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success
                            .withValues(alpha: isDark ? 0.15 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        isEn
                            ? HabitSuggestionService.categoryDisplayNameEn(
                                habit.category)
                            : HabitSuggestionService.categoryDisplayNameTr(
                                habit.category),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Duration badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.3)
                            : AppColors.lightSurfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${habit.durationMinutes} min',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      isEn ? 'Tap to explore' : 'Keşfetmek için dokun',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted.withValues(alpha: 0.6)
                            : AppColors.lightTextMuted.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, duration: 500.ms);
      },
    );
  }
}
