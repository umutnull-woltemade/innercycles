// ════════════════════════════════════════════════════════════════════════════
// GRATITUDE-MOOD CORRELATION - Cross-reference gratitude & mood data
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class GratitudeMoodCorrelationCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const GratitudeMoodCorrelationCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gratitudeAsync = ref.watch(gratitudeServiceProvider);
    final moodAsync = ref.watch(moodCheckinServiceProvider);

    return gratitudeAsync.maybeWhen(
      data: (gratService) => moodAsync.maybeWhen(
        data: (moodService) {
          final gratEntries = gratService.getAllEntries();
          final moodEntries = moodService.getAllEntries();

          if (gratEntries.length < 5 || moodEntries.length < 5) {
            return const SizedBox.shrink();
          }

          // Build mood map by date key
          final moodByDate = <String, int>{};
          for (final m in moodEntries) {
            final key =
                '${m.date.year}-${m.date.month.toString().padLeft(2, '0')}-${m.date.day.toString().padLeft(2, '0')}';
            moodByDate[key] = m.mood;
          }

          // Compare mood on gratitude days vs non-gratitude days
          final gratDates = gratEntries.map((e) => e.dateKey).toSet();
          double gratMoodSum = 0;
          int gratMoodCount = 0;
          double nonGratMoodSum = 0;
          int nonGratMoodCount = 0;

          for (final entry in moodByDate.entries) {
            if (gratDates.contains(entry.key)) {
              gratMoodSum += entry.value;
              gratMoodCount++;
            } else {
              nonGratMoodSum += entry.value;
              nonGratMoodCount++;
            }
          }

          if (gratMoodCount < 3 || nonGratMoodCount < 3) {
            return const SizedBox.shrink();
          }

          final gratAvg = gratMoodSum / gratMoodCount;
          final nonGratAvg = nonGratMoodSum / nonGratMoodCount;
          final diff = gratAvg - nonGratAvg;
          final pctDiff = nonGratAvg > 0 ? ((diff / nonGratAvg) * 100).round() : 0;

          if (pctDiff.abs() < 3) return const SizedBox.shrink();

          final isPositive = pctDiff > 0;

          return GestureDetector(
            onTap: () => context.push(Routes.gratitudeInsights),
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: PremiumCard(
              style: PremiumCardStyle.subtle,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        size: 16,
                        color: AppColors.auroraStart,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEn ? 'Gratitude & Mood' : 'Şükran & Ruh Hali',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Correlation bar
                  Row(
                    children: [
                      _AvgBadge(
                        label: isEn ? 'With Gratitude' : 'Şükranla',
                        value: gratAvg,
                        isDark: isDark,
                        isHighlight: isPositive,
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: 18,
                        color: isPositive ? AppColors.success : AppColors.warning,
                      ),
                      const SizedBox(width: 12),
                      _AvgBadge(
                        label: isEn ? 'Without' : 'Şükransız',
                        value: nonGratAvg,
                        isDark: isDark,
                        isHighlight: !isPositive,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPositive
                        ? (isEn
                            ? 'Days you practiced gratitude had $pctDiff% higher mood.'
                            : 'Şükran uyguladığın günlerde ruh halin %$pctDiff daha yüksek.')
                        : (isEn
                            ? 'Your gratitude practice is building — keep going!'
                            : 'Şükran pratiğin gelişiyor — devam et!'),
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
          ).animate().fadeIn(delay: 550.ms, duration: 300.ms),
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _AvgBadge extends StatelessWidget {
  final String label;
  final double value;
  final bool isDark;
  final bool isHighlight;

  const _AvgBadge({
    required this.label,
    required this.value,
    required this.isDark,
    required this.isHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isHighlight
              ? AppColors.success.withValues(alpha: 0.1)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03)),
        ),
        child: Column(
          children: [
            Text(
              value.toStringAsFixed(1),
              style: AppTypography.displayFont.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isHighlight
                    ? AppColors.success
                    : (isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
            Text(
              label,
              style: AppTypography.elegantAccent(
                fontSize: 10,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
