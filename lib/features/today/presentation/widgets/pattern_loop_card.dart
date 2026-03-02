import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class PatternLoopCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const PatternLoopCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(patternLoopAnalysisProvider);

    return analysisAsync.maybeWhen(
      data: (analysis) {
        if (analysis.detectedLoops.isEmpty) return const SizedBox.shrink();

        final language = AppLanguage.fromIsEn(isEn);
        // Get strongest loop
        final loop = analysis.detectedLoops.reduce(
          (a, b) => a.strength > b.strength ? a : b,
        );

        final isPositive =
            loop.reinforcementType.name == 'positive';
        final typeLabel = loop.reinforcementType.label(language);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.emotionalCycles);
            },
            child: PremiumCard(
              style: isPositive
                  ? PremiumCardStyle.aurora
                  : PremiumCardStyle.amethyst,
              borderRadius: 16,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.loop_rounded,
                        size: 18,
                        color: isPositive
                            ? AppColors.auroraStart
                            : AppColors.amethyst,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEn
                              ? 'Behavioral Loop Detected'
                              : 'Davranış Döngüsü Tespit Edildi',
                          style: AppTypography.modernAccent(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: (isPositive
                                  ? AppColors.auroraStart
                                  : AppColors.amethyst)
                              .withValues(alpha: 0.15),
                        ),
                        child: Text(
                          typeLabel,
                          style: AppTypography.elegantAccent(
                            fontSize: 10,
                            color: isPositive
                                ? AppColors.auroraStart
                                : AppColors.amethyst,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Loop stages mini-flow
                  Row(
                    children: [
                      _stageChip(loop.trigger.localizedLabel(language)),
                      _arrow(),
                      _stageChip(loop.behavior.localizedLabel(language)),
                      _arrow(),
                      _stageChip(loop.outcome.localizedLabel(language)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loop.localizedInsight(language),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subtitle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  if (loop.localizedAction(language) != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 13,
                          color: AppColors.starGold,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            loop.localizedAction(language)!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.elegantAccent(
                              fontSize: 11,
                              color: AppColors.starGold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 650.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _stageChip(String label) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isDark
              ? AppColors.surfaceDark
              : AppColors.lightSurfaceVariant,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.subtitle(
            fontSize: 10,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }

  Widget _arrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 10,
        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
      ),
    );
  }
}
