// ════════════════════════════════════════════════════════════════════════════
// SELF-COMPASSION CARD - Today feed self-kindness score
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/self_compassion_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/sparkline_chart.dart';

class SelfCompassionCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const SelfCompassionCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(selfCompassionServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final score = service.computeScore();
        if (score.totalEntries < 2) return const SizedBox.shrink();

        final weeklyScores = service.getWeeklyScores();

        String toneEmoji;
        String toneLabel;
        Color toneColor;
        switch (score.dominantTone) {
          case 'kind':
            toneEmoji = '\u{1F49A}';
            toneLabel = isEn ? 'Self-kind' : '\u00d6z-\u015fefkatli';
            toneColor = AppColors.success;
          case 'harsh':
            toneEmoji = '\u{1F494}';
            toneLabel = isEn ? 'Self-critical' : '\u00d6z-ele\u015ftirel';
            toneColor = AppColors.warning;
          default:
            toneEmoji = '\u{1F90D}';
            toneLabel = isEn ? 'Balanced' : 'Dengeli';
            toneColor = AppColors.amethyst;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: GestureDetector(
            onTap: () => context.push(Routes.selfCompassion),
            child: PremiumCard(
              style: PremiumCardStyle.amethyst,
              child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('\u{1F33F}',
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Text(
                        isEn ? 'Self-Compassion' : '\u00d6z \u015eefkat',
                        style: AppTypography.modernAccent(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: toneColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(toneEmoji,
                                style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              toneLabel,
                              style: AppTypography.elegantAccent(
                                fontSize: 11,
                                color: toneColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Score display
                  Row(
                    children: [
                      Text(
                        '${score.score.toInt()}',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          color: toneColor,
                        ),
                      ),
                      Text(
                        '/100',
                        style: AppTypography.elegantAccent(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      const Spacer(),
                      // Sparkline
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: SparklineChart(
                          data: weeklyScores,
                          lineColor: AppColors.amethyst,
                          fillColor:
                              AppColors.amethyst.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Gentle message
                  Text(
                    _getMessage(score, isEn),
                    style: AppTypography.decorativeScript(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        );
      },
    );
  }

  String _getMessage(CompassionScore score, bool isEn) {
    if (score.dominantTone == 'kind') {
      return isEn
          ? 'Your journal shows self-kindness. Keep nurturing that voice.'
          : 'G\u00fcnl\u00fc\u011f\u00fcn \u00f6z-\u015fefkat g\u00f6steriyor. O sesi beslemeye devam et.';
    } else if (score.dominantTone == 'harsh') {
      return isEn
          ? 'Notice the inner critic. What would you say to a friend in your shoes?'
          : '\u0130\u00e7 ele\u015ftirmeni fark et. Senin yerinde bir arkada\u015f\u0131na ne s\u00f6ylerdin?';
    }
    return isEn
        ? 'Your tone is balanced this week. Both kindness and honesty.'
        : 'Bu hafta tonun dengeli. Hem \u015fefkat hem d\u00fcr\u00fcstl\u00fck.';
  }
}
