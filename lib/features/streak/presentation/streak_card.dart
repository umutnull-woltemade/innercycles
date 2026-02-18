import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/streak_service.dart';

/// Streak card widget for the home screen
class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final streakAsync = ref.watch(streakStatsProvider);

    return streakAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) => _StreakCardContent(
        stats: stats,
        isDark: isDark,
        isEn: isEn,
      ),
    );
  }
}

class _StreakCardContent extends StatelessWidget {
  final StreakStats stats;
  final bool isDark;
  final bool isEn;

  const _StreakCardContent({
    required this.stats,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.streakStats),
      child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.starGold.withValues(alpha: 0.15),
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                ]
              : [
                  AppColors.lightStarGold.withValues(alpha: 0.1),
                  Colors.white,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.starGold,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? 'Reflection Streak' : 'Yansıma Serisi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    if (stats.currentStreak > 0)
                      Text(
                        isEn
                            ? '${stats.currentStreak} day${stats.currentStreak == 1 ? '' : 's'} in a row'
                            : '${stats.currentStreak} gün üst üste',
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
              // Streak number
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: stats.currentStreak > 0
                      ? AppColors.starGold.withValues(alpha: 0.2)
                      : (isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.3)
                          : AppColors.lightSurfaceVariant),
                  borderRadius: BorderRadius.circular(20),
                  border: stats.currentStreak > 0
                      ? Border.all(
                          color: AppColors.starGold.withValues(alpha: 0.5))
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (stats.currentStreak > 0)
                      Icon(
                        Icons.local_fire_department,
                        color: AppColors.starGold,
                        size: 18,
                      ),
                    if (stats.currentStreak > 0) const SizedBox(width: 4),
                    Text(
                      '${stats.currentStreak}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: stats.currentStreak > 0
                            ? AppColors.starGold
                            : (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Weekly mini-calendar
          _WeekCalendar(isDark: isDark, isEn: isEn),

          // Progress to next milestone
          if (stats.nextMilestone != null) ...[
            const SizedBox(height: 12),
            _MilestoneProgress(
              current: stats.currentStreak,
              target: stats.nextMilestone!,
              isDark: isDark,
              isEn: isEn,
            ),
          ],
        ],
      ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }
}

/// Weekly mini-calendar showing check marks for each day
class _WeekCalendar extends ConsumerWidget {
  final bool isDark;
  final bool isEn;

  const _WeekCalendar({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakServiceAsync = ref.watch(streakServiceProvider);

    return streakServiceAsync.when(
      loading: () => const SizedBox(height: 40),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final weekData = service.getWeekCalendar();
        final dayLabels = isEn
            ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
            : ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pa'];
        final now = DateTime.now();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: weekData.entries.map((entry) {
            final day = entry.key;
            final hasEntry = entry.value;
            final isToday = day.year == now.year &&
                day.month == now.month &&
                day.day == now.day;
            final isFuture = day.isAfter(now);

            return Column(
              children: [
                Text(
                  dayLabels[day.weekday - 1],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isToday
                        ? AppColors.starGold
                        : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasEntry
                        ? AppColors.starGold.withValues(alpha: 0.2)
                        : (isToday
                            ? (isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.5)
                                : AppColors.lightSurfaceVariant)
                            : Colors.transparent),
                    border: isToday && !hasEntry
                        ? Border.all(
                            color: AppColors.starGold.withValues(alpha: 0.5),
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Center(
                    child: hasEntry
                        ? Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: AppColors.starGold,
                          )
                        : isFuture
                            ? const SizedBox.shrink()
                            : Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textMuted
                                          .withValues(alpha: 0.5)
                                      : AppColors.lightTextMuted
                                          .withValues(alpha: 0.5),
                                ),
                              ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

/// Progress bar toward next milestone
class _MilestoneProgress extends StatelessWidget {
  final int current;
  final int target;
  final bool isDark;
  final bool isEn;

  const _MilestoneProgress({
    required this.current,
    required this.target,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);
    final remaining = target - current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isEn
                  ? '$remaining day${remaining == 1 ? '' : 's'} to $target-day milestone'
                  : '$target günlük hedefe $remaining gün',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.starGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.3)
                : AppColors.lightSurfaceVariant,
            valueColor: AlwaysStoppedAnimation(AppColors.starGold),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

/// Milestone celebration dialog
class StreakMilestoneCelebration {
  static Future<void> show(
    BuildContext context, {
    required int milestone,
    required bool isEn,
  }) async {
    HapticFeedback.heavyImpact();
    final message = isEn
        ? StreakService.getMilestoneMessageEn(milestone)
        : StreakService.getMilestoneMessageTr(milestone);

    await showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Dialog(
          backgroundColor:
              isDark ? AppColors.surfaceDark : AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.starGold.withValues(alpha: 0.2),
                  ),
                  child: Icon(
                    Icons.celebration_rounded,
                    size: 48,
                    color: AppColors.starGold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$milestone ${isEn ? 'Days' : 'Gün'}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.starGold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.starGold,
                      foregroundColor: AppColors.deepSpace,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEn ? 'Continue' : 'Devam',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
