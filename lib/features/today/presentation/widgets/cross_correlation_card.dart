// ════════════════════════════════════════════════════════════════════════════
// CROSS-CORRELATION CARD - Cross-feature pattern insights on home feed
// ════════════════════════════════════════════════════════════════════════════
// Shows the most significant cross-dimension correlation (e.g., sleep vs mood,
// ritual completion vs focus scores) from PatternEngineService.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class CrossCorrelationCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const CrossCorrelationCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(patternEngineServiceProvider);
    final language = AppLanguage.fromIsEn(isEn);

    return engineAsync.maybeWhen(
      data: (engine) {
        if (!engine.hasEnoughData()) return const SizedBox.shrink();

        final correlations = engine.getCrossCorrelations();
        // Only show significant correlations
        final significant = correlations.where((c) => c.isSignificant).toList();
        if (significant.isEmpty) return const SizedBox.shrink();

        // Sort by coefficient strength — show the strongest
        significant.sort((a, b) =>
            b.coefficient.abs().compareTo(a.coefficient.abs()));

        // Show up to 2 insights
        final top = significant.take(2).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () => context.push(Routes.crossCorrelations),
            child: PremiumCard(
              style: PremiumCardStyle.aurora,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.hub_rounded,
                        size: 16,
                        color: AppColors.auroraStart,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEn ? 'Cross-Feature Insights' : 'Çapraz İçgörüler',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...top.map((correlation) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _CorrelationRow(
                      dimensionA: correlation.dimensionA,
                      dimensionB: correlation.dimensionB,
                      coefficient: correlation.coefficient,
                      insightText: correlation.localizedInsightText(language),
                      strength: isEn
                          ? correlation.strengthEn
                          : correlation.strengthTr,
                      isDark: isDark,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 650.ms, duration: 400.ms).slideY(
              begin: 0.05,
              duration: 300.ms,
              curve: Curves.easeOut,
            );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _CorrelationRow extends StatelessWidget {
  final String dimensionA;
  final String dimensionB;
  final double coefficient;
  final String insightText;
  final String strength;
  final bool isDark;

  const _CorrelationRow({
    required this.dimensionA,
    required this.dimensionB,
    required this.coefficient,
    required this.insightText,
    required this.strength,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = coefficient > 0;
    final color = isPositive ? AppColors.success : AppColors.warning;
    final abs = coefficient.abs();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: isDark ? 0.08 : 0.05),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Dimension labels
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        '$dimensionA  ↔  $dimensionB',
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Strength badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: color.withValues(alpha: 0.12),
                ),
                child: Text(
                  'r=${abs.toStringAsFixed(2)}',
                  style: AppTypography.subtitle(
                    fontSize: 9,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Correlation bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: abs,
                backgroundColor: color.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation(color.withValues(alpha: 0.5)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            insightText,
            style: AppTypography.decorativeScript(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
