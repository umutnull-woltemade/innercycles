// ════════════════════════════════════════════════════════════════════════════
// CLARITY SCORE CARD - Weekly composite wellbeing snapshot
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/sparkline_chart.dart';

class ClarityScoreCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const ClarityScoreCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clarityAsync = ref.watch(clarityScoreServiceProvider);

    return clarityAsync.maybeWhen(
      data: (service) {
        final current = service.getCurrentWeekCached();
        if (current == null) {
          // Compute on first view, then invalidate to trigger rebuild
          service.computeCurrentWeek().then((_) {
            ref.invalidate(clarityScoreServiceProvider);
          });
          return const SizedBox.shrink();
        }

        final previous = service.getPreviousWeek();
        final delta = previous != null ? current.score - previous.score : 0;
        final recentWeeks = service.getRecentWeeks(count: 4);
        final sparkData =
            recentWeeks.reversed.map((w) => w.score.toDouble()).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.aurora,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.insights_rounded,
                        size: 16, color: AppColors.auroraStart),
                    const SizedBox(width: 8),
                    Text(
                      isEn ? 'Weekly Clarity Score' : 'Haftalık Berraklık Skoru',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (sparkData.length >= 2)
                      SparklineChart(
                        data: sparkData,
                        minValue: 0,
                        maxValue: 100,
                        lineColor: AppColors.auroraStart,
                        fillColor: AppColors.auroraStart.withValues(alpha: 0.1),
                        width: 60,
                        height: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${current.score}',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '/100',
                        style: AppTypography.subtitle(
                          fontSize: 14,
                          color:
                              isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (delta != 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (delta > 0
                                    ? AppColors.success
                                    : AppColors.error)
                                .withValues(alpha: 0.15),
                          ),
                          child: Text(
                            '${delta > 0 ? '+' : ''}$delta',
                            style: AppTypography.subtitle(
                              fontSize: 12,
                              color: delta > 0
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                // Breakdown row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BreakdownChip(
                      icon: Icons.edit_note_rounded,
                      label:
                          '${current.journalDays}${isEn ? 'd' : 'g'}',
                      isDark: isDark,
                    ),
                    _BreakdownChip(
                      icon: Icons.mood_rounded,
                      label: current.avgMood.toStringAsFixed(1),
                      isDark: isDark,
                    ),
                    _BreakdownChip(
                      icon: Icons.check_circle_outline_rounded,
                      label: '${(current.ritualRate * 100).round()}%',
                      isDark: isDark,
                    ),
                    _BreakdownChip(
                      icon: Icons.bedtime_rounded,
                      label: current.sleepAvg > 0
                          ? current.sleepAvg.toStringAsFixed(1)
                          : '—',
                      isDark: isDark,
                    ),
                    _BreakdownChip(
                      icon: Icons.local_fire_department_rounded,
                      label: '${current.streak}',
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _BreakdownChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _BreakdownChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 13,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTypography.subtitle(
            fontSize: 11,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
