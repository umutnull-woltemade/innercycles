// ════════════════════════════════════════════════════════════════════════════
// WELLNESS HISTORY SCREEN - 30-day score trend & component breakdown
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/wellness_score_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/sparkline_chart.dart';

class WellnessHistoryScreen extends ConsumerWidget {
  const WellnessHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(wellnessScoreServiceProvider);
    final trendAsync = ref.watch(wellnessTrendProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final monthly = service.getMonthlyScores();
              final today = service.getTodayScore();
              final trend = trendAsync.whenOrNull(data: (t) => t);

              if (monthly.isEmpty && today == null) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              final scores = monthly.isNotEmpty ? monthly : <WellnessScore>[];
              final sparkData =
                  scores.map((s) => s.score.toDouble()).toList();

              // Find best day
              WellnessScore? bestDay;
              for (final s in scores) {
                if (bestDay == null || s.score > bestDay.score) {
                  bestDay = s;
                }
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Wellness History'
                        : 'Sağlık Geçmişi',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Your wellness score over time'
                                : 'Sağlık skorun zaman içinde',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Trend hero
                          if (trend != null)
                            _TrendHero(
                              trend: trend,
                              isEn: isEn,
                              isDark: isDark,
                            ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Sparkline
                          if (sparkData.length >= 2) ...[
                            GradientText(
                              isEn
                                  ? '30-Day Trend'
                                  : '30 Günlük Eğilim',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white
                                        .withValues(alpha: 0.04)
                                    : Colors.black
                                        .withValues(alpha: 0.03),
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              child: SparklineChart(
                                data: sparkData,
                                minValue: 0,
                                maxValue: 100,
                                lineColor: AppColors.auroraStart,
                                fillColor: AppColors.auroraStart
                                    .withValues(alpha: 0.1),
                                width: double.infinity,
                                height: 80,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Best day
                          if (bestDay != null) ...[
                            GradientText(
                              isEn ? 'Best Day' : 'En İyi Gün',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _ScoreDayTile(
                              score: bestDay,
                              isEn: isEn,
                              isDark: isDark,
                              highlight: true,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Today's breakdown
                          if (today != null &&
                              today.breakdown.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Today\'s Breakdown'
                                  : 'Bugünün Dağılımı',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...today.breakdown.map((b) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 6),
                                  child: _BreakdownRow(
                                    breakdown: b,
                                    isEn: isEn,
                                    isDark: isDark,
                                  ),
                                )),
                            const SizedBox(height: 24),
                          ],

                          // Recent scores list
                          if (scores.length > 3) ...[
                            GradientText(
                              isEn
                                  ? 'Recent Scores'
                                  : 'Son Skorlar',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...scores.reversed.take(7).map(
                                  (s) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 6),
                                    child: _ScoreDayTile(
                                      score: s,
                                      isEn: isEn,
                                      isDark: isDark,
                                    ),
                                  ),
                                ),
                          ],

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? '${scores.length} days tracked'
                                  : '${scores.length} gün takip edildi',
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

class _TrendHero extends StatelessWidget {
  final WellnessTrend trend;
  final bool isEn;
  final bool isDark;

  const _TrendHero({
    required this.trend,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = trend.direction == 'up';
    final isDown = trend.direction == 'down';
    final delta = trend.currentScore - trend.previousWeekScore;

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '${trend.currentScore}',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  isEn ? 'This week' : 'Bu hafta',
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
                Icon(
                  isUp
                      ? Icons.trending_up_rounded
                      : isDown
                          ? Icons.trending_down_rounded
                          : Icons.trending_flat_rounded,
                  size: 28,
                  color: isUp
                      ? AppColors.success
                      : isDown
                          ? AppColors.error
                          : AppColors.amethyst,
                ),
                const SizedBox(height: 4),
                if (delta != 0)
                  Text(
                    '${delta > 0 ? '+' : ''}$delta',
                    style: AppTypography.modernAccent(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isUp
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${trend.previousWeekScore}',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: (isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary)
                        .withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  isEn ? 'Last week' : 'Geçen hafta',
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
      ),
    );
  }
}

String _categoryLabel(String category, bool isEn) {
  switch (category) {
    case 'journal':
      return isEn ? 'Journal' : 'Günlük';
    case 'gratitude':
      return isEn ? 'Gratitude' : 'Şükran';
    case 'rituals':
      return isEn ? 'Rituals' : 'Ritüeller';
    case 'streak':
      return isEn ? 'Streak' : 'Seri';
    case 'sleep':
      return isEn ? 'Sleep' : 'Uyku';
    default:
      return category;
  }
}

Color _categoryColor(String category) {
  switch (category) {
    case 'journal':
      return AppColors.starGold;
    case 'gratitude':
      return AppColors.success;
    case 'rituals':
      return AppColors.amethyst;
    case 'streak':
      return AppColors.auroraStart;
    case 'sleep':
      return const Color(0xFF81C784);
    default:
      return AppColors.textMuted;
  }
}

class _BreakdownRow extends StatelessWidget {
  final WellnessBreakdown breakdown;
  final bool isEn;
  final bool isDark;

  const _BreakdownRow({
    required this.breakdown,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(breakdown.category);
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            _categoryLabel(breakdown.category, isEn),
            style: AppTypography.modernAccent(
              fontSize: 12,
              color: color,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: breakdown.score / 100.0,
              backgroundColor: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          child: Text(
            '${breakdown.weightedScore.toStringAsFixed(0)} (${(breakdown.weight * 100).round()}%)',
            textAlign: TextAlign.end,
            style: AppTypography.elegantAccent(
              fontSize: 10,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreDayTile extends StatelessWidget {
  final WellnessScore score;
  final bool isEn;
  final bool isDark;
  final bool highlight;

  const _ScoreDayTile({
    required this.score,
    required this.isEn,
    required this.isDark,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.starGold.withValues(alpha: 0.08)
            : isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            score.dateKey,
            style: AppTypography.elegantAccent(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const Spacer(),
          Text(
            '${score.score}',
            style: AppTypography.modernAccent(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: highlight
                  ? AppColors.starGold
                  : AppColors.auroraStart,
            ),
          ),
          Text(
            '/100',
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
  }
}

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Wellness History' : 'Sağlık Geçmişi',
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
                      const Text('\u{1F4CA}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Keep journaling to build your wellness score history'
                            : 'Sağlık skoru geçmişini oluşturmak için günlük yazmaya devam et',
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
