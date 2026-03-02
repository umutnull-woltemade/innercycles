import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/sparkline_chart.dart';
import '../../../../shared/widgets/tap_scale.dart';

class SleepQualityMiniCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const SleepQualityMiniCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(sleepSummaryProvider);

    return summaryAsync.maybeWhen(
      data: (summary) {
        // Only show if user has logged enough sleep
        if (summary.nightsLogged < 2) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: TapScale(
              onTap: () {
                HapticService.selectionTap();
                context.push(Routes.sleepTrends);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.amethyst.withValues(alpha: isDark ? 0.06 : 0.04),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bedtime_outlined,
                      size: 16,
                      color: AppColors.amethyst.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'Log your sleep to discover patterns'
                            : 'Örüntüleri keşfetmek için uykunu kaydet',
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 580.ms, duration: 300.ms);
        }

        final trendIcon = switch (summary.trendDirection) {
          'improving' => Icons.trending_up_rounded,
          'declining' => Icons.trending_down_rounded,
          _ => Icons.trending_flat_rounded,
        };
        final trendColor = switch (summary.trendDirection) {
          'improving' => AppColors.success,
          'declining' => AppColors.error,
          _ => AppColors.starGold,
        };
        final trendLabel = switch (summary.trendDirection) {
          'improving' => isEn ? 'Improving' : 'İyileşiyor',
          'declining' => isEn ? 'Declining' : 'Düşüyor',
          _ => isEn ? 'Stable' : 'Sabit',
        };

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.sleepTrends);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.3)
                    : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
                border: Border.all(
                  color: AppColors.amethyst.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  // Sleep quality ring
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: CircularProgressIndicator(
                            value: summary.averageQuality / 5.0,
                            strokeWidth: 3,
                            backgroundColor: (isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted)
                                .withValues(alpha: 0.15),
                            valueColor: AlwaysStoppedAnimation(
                              _qualityColor(summary.averageQuality),
                            ),
                          ),
                        ),
                        Text(
                          summary.averageQuality.toStringAsFixed(1),
                          style: AppTypography.modernAccent(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _qualityColor(summary.averageQuality),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? 'Sleep This Week' : 'Bu Hafta Uyku',
                          style: AppTypography.modernAccent(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEn
                              ? '${summary.nightsLogged} night${summary.nightsLogged > 1 ? 's' : ''} logged'
                              : '${summary.nightsLogged} gece kaydedildi',
                          style: AppTypography.subtitle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Sparkline + Trend
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Builder(
                        builder: (context) {
                          final serviceAsync = ref.watch(sleepServiceProvider);
                          final weekData = serviceAsync.whenOrNull(
                            data: (s) => s.getWeekQualities(),
                          );
                          if (weekData == null || weekData.where((v) => v > 0).length < 2) {
                            return const SizedBox.shrink();
                          }
                          return SparklineChart(
                            data: weekData.map((v) => v == 0 ? 0.0 : v).toList(),
                            minValue: 0,
                            maxValue: 5,
                            lineColor: _qualityColor(summary.averageQuality),
                            width: 60,
                            height: 24,
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(trendIcon, size: 12, color: trendColor),
                          const SizedBox(width: 3),
                          Text(
                            trendLabel,
                            style: AppTypography.elegantAccent(
                              fontSize: 10,
                              color: trendColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 580.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Color _qualityColor(double avg) {
    if (avg >= 4.0) return AppColors.success;
    if (avg >= 3.0) return AppColors.starGold;
    if (avg >= 2.0) return AppColors.celestialGold;
    return AppColors.error;
  }
}
