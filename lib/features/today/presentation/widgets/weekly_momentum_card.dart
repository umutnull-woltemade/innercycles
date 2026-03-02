import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/gradient_text.dart';

/// Shows this week vs last week mood average with trend arrow.
class WeeklyMomentumCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const WeeklyMomentumCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodAsync = ref.watch(moodCheckinServiceProvider);

    return moodAsync.maybeWhen(
      data: (service) {
        final allEntries = service.getAllEntries();
        if (allEntries.length < 3) return const SizedBox.shrink();

        final now = DateTime.now();
        final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
        final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

        final thisWeek = allEntries.where((e) =>
            !e.date.isBefore(thisWeekStart) && !e.date.isAfter(now));
        final lastWeek = allEntries.where((e) =>
            !e.date.isBefore(lastWeekStart) && e.date.isBefore(thisWeekStart));

        if (thisWeek.isEmpty || lastWeek.isEmpty) return const SizedBox.shrink();

        final thisAvg = thisWeek.fold<double>(0, (s, e) => s + e.mood) / thisWeek.length;
        final lastAvg = lastWeek.fold<double>(0, (s, e) => s + e.mood) / lastWeek.length;
        final diff = thisAvg - lastAvg;
        final pctChange = lastAvg > 0 ? (diff / lastAvg * 100).abs().round() : 0;

        final isUp = diff > 0.15;
        final isDown = diff < -0.15;

        final trendIcon = isUp
            ? Icons.trending_up_rounded
            : isDown
                ? Icons.trending_down_rounded
                : Icons.trending_flat_rounded;
        final trendColor = isUp
            ? AppColors.success
            : isDown
                ? AppColors.warning
                : AppColors.auroraStart;
        final trendLabel = isUp
            ? (isEn ? '$pctChange% higher than last week' : 'Geçen haftaya göre %$pctChange daha yüksek')
            : isDown
                ? (isEn ? '$pctChange% lower than last week' : 'Geçen haftaya göre %$pctChange daha düşük')
                : (isEn ? 'Steady compared to last week' : 'Geçen haftayla aynı seviyede');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.subtle,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GradientText(
                      isEn ? 'Weekly Momentum' : 'Haftalık Momentum',
                      variant: GradientTextVariant.aurora,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Icon(trendIcon, size: 22, color: trendColor),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _MoodColumn(
                      label: isEn ? 'This Week' : 'Bu Hafta',
                      value: thisAvg.toStringAsFixed(1),
                      color: trendColor,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 24),
                    _MoodColumn(
                      label: isEn ? 'Last Week' : 'Geçen Hafta',
                      value: lastAvg.toStringAsFixed(1),
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      isDark: isDark,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: trendColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(trendIcon, size: 14, color: trendColor),
                          const SizedBox(width: 4),
                          Text(
                            diff > 0 ? '+${diff.toStringAsFixed(1)}' : diff.toStringAsFixed(1),
                            style: AppTypography.modernAccent(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: trendColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  trendLabel,
                  style: AppTypography.subtitle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _MoodColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _MoodColumn({
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
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
