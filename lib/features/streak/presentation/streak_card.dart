import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/streak_service.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/premium_card.dart';

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
      data: (stats) =>
          _StreakCardContent(stats: stats, isDark: isDark, isEn: isEn),
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
    return Semantics(
      label: isEn
          ? 'Streak: ${stats.currentStreak} days. Tap for details'
          : 'Seri: ${stats.currentStreak} gün. Detaylar için dokun',
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(Routes.streakStats);
        },
        child: PremiumCard(
          style: PremiumCardStyle.gold,
          padding: const EdgeInsets.all(20),
          borderRadius: 20,
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
                          style: AppTypography.displayFont.copyWith(
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
                            style: AppTypography.decorativeScript(
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
                              color: AppColors.starGold.withValues(alpha: 0.5),
                            )
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
                          style: AppTypography.displayFont.copyWith(
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

              // 14-day chain visualization
              if (stats.currentStreak > 0) ...[
                const SizedBox(height: 14),
                _StreakChain(isDark: isDark, isEn: isEn),
              ],

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
            final isToday =
                day.year == now.year &&
                day.month == now.month &&
                day.day == now.day;
            final isFuture = day.isAfter(now);

            return Column(
              children: [
                Text(
                  dayLabels[day.weekday - 1],
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
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
                                    ? AppColors.surfaceLight.withValues(
                                        alpha: 0.5,
                                      )
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
                            style: AppTypography.elegantAccent(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textMuted.withValues(alpha: 0.5)
                                  : AppColors.lightTextMuted.withValues(
                                      alpha: 0.5,
                                    ),
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
              style: AppTypography.decorativeScript(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: AppColors.starGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Semantics(
          label: isEn
              ? '${(progress * 100).round()}% to next milestone'
              : 'Sonraki kilometre taşına %${(progress * 100).round()}',
          child: ClipRRect(
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
        ),
      ],
    );
  }
}

/// 14-day "Don't Break the Chain" visualization
class _StreakChain extends ConsumerWidget {
  final bool isDark;
  final bool isEn;

  const _StreakChain({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.maybeWhen(
      data: (journal) {
        final now = DateTime.now();
        final startDay = DateTime(now.year, now.month, now.day - 13);
        final endDay = DateTime(now.year, now.month, now.day);
        final rangeEntries = journal.getEntriesByDateRange(startDay, endDay);
        final entryDates = <String>{};
        for (final e in rangeEntries) {
          entryDates.add('${e.date.year}-${e.date.month}-${e.date.day}');
        }
        final days = <_ChainDay>[];
        for (int i = 13; i >= 0; i--) {
          final day = DateTime(now.year, now.month, now.day - i);
          final key = '${day.year}-${day.month}-${day.day}';
          days.add(
            _ChainDay(
              date: day,
              hasEntry: entryDates.contains(key),
              isToday: i == 0,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEn ? '14-Day Chain' : '14 Günlük Zincir',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 28,
              child: Row(
                children: List.generate(days.length, (i) {
                  final day = days[i];
                  final isConnectedLeft =
                      i > 0 && days[i - 1].hasEntry && day.hasEntry;
                  final isConnectedRight =
                      i < days.length - 1 &&
                      days[i + 1].hasEntry &&
                      day.hasEntry;

                  return Expanded(
                    child: Row(
                      children: [
                        // Left connector
                        if (i > 0)
                          Expanded(
                            child: Container(
                              height: 3,
                              color: isConnectedLeft
                                  ? AppColors.starGold.withValues(alpha: 0.6)
                                  : (isDark
                                        ? AppColors.surfaceLight.withValues(
                                            alpha: 0.15,
                                          )
                                        : AppColors.lightSurfaceVariant
                                              .withValues(alpha: 0.5)),
                            ),
                          ),
                        // Chain link dot
                        Container(
                          width: day.isToday ? 14 : 10,
                          height: day.isToday ? 14 : 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day.hasEntry
                                ? AppColors.starGold
                                : (isDark
                                      ? AppColors.surfaceLight.withValues(
                                          alpha: 0.3,
                                        )
                                      : AppColors.lightSurfaceVariant),
                            border: day.isToday
                                ? Border.all(
                                    color: AppColors.starGold,
                                    width: 2,
                                  )
                                : null,
                            boxShadow: day.hasEntry
                                ? [
                                    BoxShadow(
                                      color: AppColors.starGold.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        // Right connector
                        if (i < days.length - 1)
                          Expanded(
                            child: Container(
                              height: 3,
                              color: isConnectedRight
                                  ? AppColors.starGold.withValues(alpha: 0.6)
                                  : (isDark
                                        ? AppColors.surfaceLight.withValues(
                                            alpha: 0.15,
                                          )
                                        : AppColors.lightSurfaceVariant
                                              .withValues(alpha: 0.5)),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _ChainDay {
  final DateTime date;
  final bool hasEntry;
  final bool isToday;

  const _ChainDay({
    required this.date,
    required this.hasEntry,
    required this.isToday,
  });
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

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (ctx, anim, secondAnim, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.elasticOut),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (ctx, anim, secondAnim) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.starGold.withValues(alpha: 0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.starGold.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated celebration icon
                  Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.starGold.withValues(alpha: 0.3),
                              AppColors.starGold.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.celebration_rounded,
                          size: 48,
                          color: AppColors.starGold,
                        ),
                      )
                      .animate()
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .shimmer(
                        delay: 400.ms,
                        duration: 1200.ms,
                        color: AppColors.starGold.withValues(alpha: 0.3),
                      ),
                  const SizedBox(height: 20),

                  // Milestone number
                  Text(
                        '$milestone ${isEn ? 'Days' : 'Gün'}',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.starGold,
                          letterSpacing: 1,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.3, duration: 400.ms),
                  const SizedBox(height: 4),

                  Text(
                    isEn ? 'Milestone Reached' : 'Hedefe Ulaşıldı',
                    style: AppTypography.elegantAccent(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starGold.withValues(alpha: 0.7),
                      letterSpacing: 1.5,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  const SizedBox(height: 16),

                  // Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTypography.decorativeScript(
                      fontSize: 15,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: 28),

                  // CTA
                  GradientButton.gold(
                    label: isEn ? 'Keep Going' : 'Devam Et',
                    onPressed: () => Navigator.pop(ctx),
                    expanded: true,
                  ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
