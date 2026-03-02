// ════════════════════════════════════════════════════════════════════════════
// MOOD TEMPORAL INSIGHT - Intra-day mood pattern analysis
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class MoodTemporalInsightCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const MoodTemporalInsightCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(moodCheckinServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        final entries = service.getAllEntries();
        if (entries.length < 5) return const SizedBox.shrink();

        // Group mood by time of day (last 30 entries)
        final recent = entries.take(30).toList();
        double morningSum = 0, afternoonSum = 0, eveningSum = 0;
        int morningCount = 0, afternoonCount = 0, eveningCount = 0;

        for (final e in recent) {
          final hour = e.date.hour;
          if (hour >= 5 && hour < 12) {
            morningSum += e.mood;
            morningCount++;
          } else if (hour >= 12 && hour < 18) {
            afternoonSum += e.mood;
            afternoonCount++;
          } else {
            eveningSum += e.mood;
            eveningCount++;
          }
        }

        // Need at least 2 time periods with data
        final periods = [
          if (morningCount >= 2) (isEn ? 'Morning' : 'Sabah', morningSum / morningCount, morningCount),
          if (afternoonCount >= 2) (isEn ? 'Afternoon' : 'Öğleden Sonra', afternoonSum / afternoonCount, afternoonCount),
          if (eveningCount >= 2) (isEn ? 'Evening' : 'Akşam', eveningSum / eveningCount, eveningCount),
        ];

        if (periods.length < 2) return const SizedBox.shrink();

        // Find best period
        periods.sort((a, b) => b.$2.compareTo(a.$2));
        final best = periods.first;

        return Padding(
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
                      Icons.schedule_rounded,
                      size: 16,
                      color: AppColors.auroraStart,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEn ? 'Your Mood Rhythm' : 'Ruh Hali Ritmin',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Timeline row
                Row(
                  children: periods.map((p) {
                    final (label, avg, _) = p;
                    final isBest = p == best;
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: isBest
                                  ? AppColors.success
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.black.withValues(alpha: 0.06)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            avg.toStringAsFixed(1),
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isBest
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
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  isEn
                      ? 'You tend to feel best in the ${best.$1.toLowerCase()}.'
                      : '${best.$1} saatlerinde en iyi hissetme eğilimindesin.',
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
        ).animate().fadeIn(delay: 500.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
