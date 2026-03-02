// ════════════════════════════════════════════════════════════════════════════
// CROSS-CORRELATION SCREEN - Multi-dimension pattern connections
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/cross_correlation_result.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class CrossCorrelationScreen extends ConsumerWidget {
  const CrossCorrelationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final correlationsAsync = ref.watch(crossCorrelationsProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: correlationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (correlations) {
              if (correlations.isEmpty) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              final significant =
                  correlations.where((c) => c.isSignificant).toList()
                    ..sort((a, b) => b.coefficient
                        .abs()
                        .compareTo(a.coefficient.abs()));
              final weak =
                  correlations.where((c) => !c.isSignificant).toList();

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Cross-Correlations'
                        : 'Çapraz Korelasyonlar',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'How different areas of your life connect'
                                : 'Hayatının farklı alanları nasıl bağlantılı',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Summary hero
                          _SummaryHero(
                            total: correlations.length,
                            significant: significant.length,
                            strongest: significant.isNotEmpty
                                ? significant.first
                                : null,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Significant correlations
                          if (significant.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Significant Connections (${significant.length})'
                                  : 'Anlamlı Bağlantılar (${significant.length})',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...significant.map(
                                (c) => Padding(
                                      padding:
                                          const EdgeInsets.only(
                                              bottom: 10),
                                      child: _CorrelationCard(
                                        correlation: c,
                                        isEn: isEn,
                                        isDark: isDark,
                                      ),
                                    )),
                            const SizedBox(height: 24),
                          ],

                          // Weak / not-yet significant
                          if (weak.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Emerging Patterns'
                                  : 'Gelişen Kalıplar',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...weak.map(
                                (c) => Padding(
                                      padding:
                                          const EdgeInsets.only(
                                              bottom: 10),
                                      child: _CorrelationCard(
                                        correlation: c,
                                        isEn: isEn,
                                        isDark: isDark,
                                        muted: true,
                                      ),
                                    )),
                          ],

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? 'Observations from your entries, not predictions'
                                  : 'Kayıtlarından gözlemler, tahmin değil',
                              style: AppTypography.subtitle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryHero extends StatelessWidget {
  final int total;
  final int significant;
  final CrossCorrelation? strongest;
  final bool isEn;
  final bool isDark;

  const _SummaryHero({
    required this.total,
    required this.significant,
    required this.strongest,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '$total',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      isEn ? 'Analyzed' : 'İncelenen',
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$significant',
                      style: AppTypography.modernAccent(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      isEn ? 'Significant' : 'Anlamlı',
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (strongest != null) ...[
              const SizedBox(height: 12),
              Text(
                isEn
                    ? 'Strongest: ${strongest!.dimensionA} \u{2194} ${strongest!.dimensionB}'
                    : 'En güçlü: ${strongest!.dimensionA} \u{2194} ${strongest!.dimensionB}',
                style: AppTypography.elegantAccent(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Color _coefficientColor(double coefficient) {
  final abs = coefficient.abs();
  if (abs >= 0.7) return AppColors.success;
  if (abs >= 0.5) return AppColors.auroraStart;
  if (abs >= 0.3) return AppColors.starGold;
  return AppColors.textMuted;
}

class _CorrelationCard extends StatelessWidget {
  final CrossCorrelation correlation;
  final bool isEn;
  final bool isDark;
  final bool muted;

  const _CorrelationCard({
    required this.correlation,
    required this.isEn,
    required this.isDark,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _coefficientColor(correlation.coefficient);
    final isPositive = correlation.coefficient >= 0;
    final strength = isEn
        ? correlation.strengthEn
        : correlation.strengthTr;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: muted
            ? (isDark ? Colors.white : Colors.black)
                .withValues(alpha: 0.03)
            : color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: muted
            ? null
            : Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  '${correlation.dimensionA} \u{2194} ${correlation.dimensionB}',
                  style: AppTypography.modernAccent(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color.withValues(alpha: 0.15),
                ),
                child: Text(
                  strength,
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Coefficient bar
          Row(
            children: [
              Text(
                isPositive ? '+' : '',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: color,
                ),
              ),
              Text(
                correlation.coefficient.toStringAsFixed(2),
                style: AppTypography.modernAccent(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CoefficientBar(
                  value: correlation.coefficient,
                  color: color,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'n=${correlation.sampleSize}',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Insight text
          Text(
            isEn
                ? correlation.insightTextEn
                : correlation.insightTextTr,
            style: AppTypography.subtitle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoefficientBar extends StatelessWidget {
  final double value;
  final Color color;
  final bool isDark;

  const _CoefficientBar({
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Coefficient ranges -1 to +1, we show it as a centered bar
    final normalized = (value + 1) / 2; // 0 to 1

    return SizedBox(
      height: 6,
      child: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.06),
            ),
          ),
          // Center line
          Positioned(
            left: 0,
            right: 0,
            top: 2,
            child: Container(
              height: 2,
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.1),
            ),
          ),
          // Value indicator
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: normalized.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: color.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(
          title: isEn
              ? 'Cross-Correlations'
              : 'Çapraz Korelasyonlar',
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F517}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Keep tracking sleep, mood, gratitude, and journal entries to discover connections between them'
                            : 'Aralarındaki bağlantıları keşfetmek için uyku, ruh hali, şükran ve günlük kayıtlarını takip etmeye devam et',
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
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
          ),
        ),
      ],
    );
  }
}
