import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/tap_scale.dart';

class WeeklyDigestMiniCard extends ConsumerWidget {
  final AppLanguage language;
  final bool isDark;

  const WeeklyDigestMiniCard({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = language == AppLanguage.en;
    final digestAsync = ref.watch(weeklyDigestDataProvider);

    return digestAsync.maybeWhen(
      data: (digest) {
        if (digest == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: TapScale(
              onTap: () {
                HapticService.selectionTap();
                context.push(Routes.journal);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.starGold.withValues(alpha: isDark ? 0.06 : 0.04),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: AppColors.starGold.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'Your weekly summary will appear here'
                            : 'Haftalık özetin burada görünecek',
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
          ).animate().fadeIn(delay: 700.ms, duration: 300.ms);
        }

        final trendIcon = switch (digest.moodTrend.name) {
          'up' => Icons.trending_up_rounded,
          'down' => Icons.trending_down_rounded,
          _ => Icons.trending_flat_rounded,
        };
        final trendColor = switch (digest.moodTrend.name) {
          'up' => AppColors.success,
          'down' => AppColors.error,
          _ => AppColors.starGold,
        };

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.weeklyDigest);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.3)
                    : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
                border: Border.all(
                  color: AppColors.starGold.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: AppColors.starGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isEn ? 'This Week' : 'Bu Hafta',
                        style: AppTypography.modernAccent(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const Spacer(),
                      Icon(trendIcon, size: 16, color: trendColor),
                      const SizedBox(width: 4),
                      Text(
                        '${digest.moodTrendChangePercent.abs().toStringAsFixed(0)}%',
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Stats row
                  Row(
                    children: [
                      _stat(
                        '${digest.entriesThisWeek}',
                        isEn ? 'entries' : 'kayıt',
                      ),
                      _divider(),
                      _stat(
                        digest.avgMoodRating.toStringAsFixed(1),
                        isEn ? 'avg mood' : 'ort ruh hali',
                      ),
                      _divider(),
                      _stat(
                        '${digest.streakDays}',
                        isEn ? 'streak' : 'seri',
                      ),
                      if (digest.topFocusArea != null) ...[
                        _divider(),
                        _stat(
                          digest.topFocusArea!.localizedName(language),
                          isEn ? 'top area' : 'en çok',
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    digest.localizedHighlightInsight(language),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subtitle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 700.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.modernAccent(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subtitle(
              fontSize: 10,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
          .withValues(alpha: 0.2),
    );
  }
}
