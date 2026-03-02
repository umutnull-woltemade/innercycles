// ════════════════════════════════════════════════════════════════════════════
// ATTACHMENT STYLE RESULT SCREEN - Style evolution deep dive
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/attachment_style.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/sparkline_chart.dart';

class AttachmentStyleResultScreen extends ConsumerWidget {
  const AttachmentStyleResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(attachmentStyleServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final latest = service.getLatestResult();
              if (latest == null) {
                return _NoResults(isEn: isEn, isDark: isDark);
              }

              final allResults = service.getAllResults();
              final evolution = service.getEvolutionData();
              final canRetake = service.canRetakeQuiz();
              final daysLeft = service.daysUntilRetake();

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Attachment Style'
                        : 'Bağlanma Stili',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Your relational pattern profile'
                                : 'İlişkisel kalıp profilin',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Hero card — dominant style
                          _StyleHero(
                            result: latest,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Score breakdown
                          GradientText(
                            isEn ? 'Style Breakdown' : 'Stil Dağılımı',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...AttachmentStyle.values.map((style) {
                            final pct = latest.percentageFor(style);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _StyleBar(
                                style: style,
                                percentage: pct,
                                isEn: isEn,
                                isDark: isDark,
                                isDominant:
                                    style == latest.attachmentStyle,
                              ),
                            );
                          }),

                          const SizedBox(height: 24),

                          // Evolution timeline
                          if (evolution.length >= 2) ...[
                            GradientText(
                              isEn
                                  ? 'Evolution (${evolution.length} quizzes)'
                                  : 'Gelişim (${evolution.length} test)',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _EvolutionChart(
                              results: evolution,
                              isEn: isEn,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Strengths & growth
                          GradientText(
                            isEn ? 'Strengths' : 'Güçlü Yanlar',
                            variant: GradientTextVariant.amethyst,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            latest.attachmentStyle
                                .localizedStrengths(
                                    isEn ? AppLanguage.en : AppLanguage.tr)
                                .join('\n'),
                            style: AppTypography.subtitle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GradientText(
                            isEn ? 'Growth Areas' : 'Gelişim Alanları',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            latest.attachmentStyle
                                .localizedGrowthAreas(
                                    isEn ? AppLanguage.en : AppLanguage.tr)
                                .join('\n'),
                            style: AppTypography.subtitle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Retake info
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: (canRetake
                                        ? AppColors.success
                                        : AppColors.amethyst)
                                    .withValues(alpha: 0.1),
                              ),
                              child: Text(
                                canRetake
                                    ? (isEn
                                        ? 'You can retake the quiz'
                                        : 'Testi tekrar yapabilirsin')
                                    : (isEn
                                        ? '$daysLeft days until retake'
                                        : '$daysLeft gün sonra tekrar yapabilirsin'),
                                style: AppTypography.elegantAccent(
                                  fontSize: 12,
                                  color: canRetake
                                      ? AppColors.success
                                      : AppColors.amethyst,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Taken count
                          Center(
                            child: Text(
                              isEn
                                  ? 'Based on ${allResults.length} quiz${allResults.length > 1 ? 'zes' : ''}'
                                  : '${allResults.length} teste dayalı',
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

class _StyleHero extends StatelessWidget {
  final AttachmentQuizResult result;
  final bool isEn;
  final bool isDark;

  const _StyleHero({
    required this.result,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final style = result.attachmentStyle;
    return PremiumCard(
      style: PremiumCardStyle.amethyst,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              style.emojiIcon,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 10),
            Text(
              style.localizedName(
                  isEn ? AppLanguage.en : AppLanguage.tr),
              style: AppTypography.displayFont.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: style.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${result.percentageFor(style).round()}%',
              style: AppTypography.modernAccent(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              style.localizedDescription(
                  isEn ? AppLanguage.en : AppLanguage.tr),
              textAlign: TextAlign.center,
              style: AppTypography.subtitle(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyleBar extends StatelessWidget {
  final AttachmentStyle style;
  final double percentage;
  final bool isEn;
  final bool isDark;
  final bool isDominant;

  const _StyleBar({
    required this.style,
    required this.percentage,
    required this.isEn,
    required this.isDark,
    required this.isDominant,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            style.localizedName(isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.modernAccent(
              fontSize: 12,
              fontWeight: isDominant ? FontWeight.w700 : FontWeight.w500,
              color: isDominant
                  ? style.color
                  : (isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100.0,
              backgroundColor: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation(style.color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${percentage.round()}%',
            textAlign: TextAlign.end,
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: style.color,
            ),
          ),
        ),
      ],
    );
  }
}

class _EvolutionChart extends StatelessWidget {
  final List<AttachmentQuizResult> results;
  final bool isEn;
  final bool isDark;

  const _EvolutionChart({
    required this.results,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Show sparklines for each style across quiz history
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: AttachmentStyle.values.map((style) {
          final data = results
              .map((r) => r.percentageFor(style))
              .toList();
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    style.localizedName(
                        isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: style.color,
                    ),
                  ),
                ),
                Expanded(
                  child: SparklineChart(
                    data: data,
                    minValue: 0,
                    maxValue: 100,
                    lineColor: style.color,
                    fillColor: style.color.withValues(alpha: 0.1),
                    width: double.infinity,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${data.last.round()}%',
                    textAlign: TextAlign.end,
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: style.color,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _NoResults({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Attachment Style' : 'Bağlanma Stili',
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
                            ? 'Take the attachment style quiz to discover your relational patterns'
                            : 'İlişkisel kalıplarını keşfetmek için bağlanma stili testini yap',
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
