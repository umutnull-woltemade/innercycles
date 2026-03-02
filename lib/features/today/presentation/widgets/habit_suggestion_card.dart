import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/habit_suggestion_service.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../data/services/pattern_engine_service.dart';
import '../../../../data/content/habit_suggestions_content.dart';
import '../../../../shared/widgets/tap_scale.dart';

/// Maps journal FocusArea to habit category for adaptive suggestions
const _focusToHabitCategory = <FocusArea, String>{
  FocusArea.energy: 'physical',
  FocusArea.focus: 'morning',
  FocusArea.emotions: 'mindfulness',
  FocusArea.decisions: 'reflective',
  FocusArea.social: 'social',
};

class HabitSuggestionCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const HabitSuggestionCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(habitSuggestionServiceProvider);
    final engineAsync = ref.watch(patternEngineServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        // Try adaptive selection: weakest area → matching habit category
        HabitSuggestion habit;
        String? adaptiveReason;

        final engine = engineAsync.valueOrNull;
        if (engine != null && engine.hasEnoughData()) {
          final trends = engine.detectTrends();
          // Find the most declining area
          final declining = trends.where((t) => t.direction == TrendDirection.down).toList();
          if (declining.isNotEmpty) {
            declining.sort((a, b) => b.changePercent.abs().compareTo(a.changePercent.abs()));
            final weakArea = declining.first.area;
            final targetCategory = _focusToHabitCategory[weakArea];
            if (targetCategory != null) {
              final pool = service.getByCategory(targetCategory);
              // Pick deterministically by day (stable across refreshes)
              if (pool.isNotEmpty) {
                final dayIndex = DateTime.now().day % pool.length;
                habit = pool[dayIndex];
                adaptiveReason = isEn
                    ? 'Suggested for your ${weakArea.displayNameEn.toLowerCase()} trend'
                    : '${weakArea.displayNameTr} eğilimine göre önerildi';
              } else {
                habit = service.getDailyHabit();
              }
            } else {
              habit = service.getDailyHabit();
            }
          } else {
            habit = service.getDailyHabit();
          }
        } else {
          habit = service.getDailyHabit();
        }

        final progress = service.explorationProgress;
        final emoji = HabitSuggestionService.categoryEmoji(habit.category);
        final categoryName = isEn
            ? HabitSuggestionService.categoryDisplayNameEn(habit.category)
            : HabitSuggestionService.categoryDisplayNameTr(habit.category);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.habitSuggestions);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.success.withValues(alpha: isDark ? 0.1 : 0.06),
                    AppColors.auroraStart.withValues(alpha: isDark ? 0.06 : 0.03),
                  ],
                ),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEn ? 'Daily Habit' : 'Günlük Alışkanlık',
                          style: AppTypography.modernAccent(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      if (adaptiveReason != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.amethyst.withValues(alpha: 0.12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 10,
                                color: AppColors.amethyst,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                isEn ? 'FOR YOU' : 'SENİN İÇİN',
                                style: AppTypography.elegantAccent(
                                  fontSize: 9,
                                  color: AppColors.amethyst,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.success.withValues(alpha: 0.12),
                          ),
                          child: Text(
                            '${(progress * 100).round()}%',
                            style: AppTypography.elegantAccent(
                              fontSize: 10,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEn ? habit.titleEn : habit.titleTr,
                    style: AppTypography.modernAccent(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEn ? habit.descriptionEn : habit.descriptionTr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subtitle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  if (adaptiveReason != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.trending_down_rounded,
                          size: 12,
                          color: AppColors.amethyst.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            adaptiveReason,
                            style: AppTypography.elegantAccent(
                              fontSize: 11,
                              color: AppColors.amethyst.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.success.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          categoryName,
                          style: AppTypography.elegantAccent(
                            fontSize: 10,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.timer_outlined,
                        size: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${habit.durationMinutes} ${isEn ? 'min' : 'dk'}',
                        style: AppTypography.subtitle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 620.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
