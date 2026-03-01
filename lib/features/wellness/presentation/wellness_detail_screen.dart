import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/wellness_score_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/l10n_service.dart';

class WellnessDetailScreen extends ConsumerWidget {
  const WellnessDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final scoreAsync = ref.watch(wellnessScoreProvider);
    final trendAsync = ref.watch(wellnessTrendProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: L10nService.get('wellness.wellness_detail.wellness_score', language),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Score hero
                      scoreAsync.when(
                        loading: () =>
                            const Center(child: CosmicLoadingIndicator()),
                        error: (_, _) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  L10nService.get('wellness.wellness_detail.could_not_load_your_local_data_is_unaffe', language),
                                  textAlign: TextAlign.center,
                                  style: AppTypography.decorativeScript(
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.textMuted
                                        : AppColors.lightTextMuted,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton.icon(
                                  onPressed: () =>
                                      ref.invalidate(wellnessScoreProvider),
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: 16,
                                    color: AppColors.starGold,
                                  ),
                                  label: Text(
                                    L10nService.get('wellness.wellness_detail.retry', language),
                                    style: AppTypography.elegantAccent(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.starGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        data: (score) {
                          if (score == null) {
                            return _buildEmptyState(context, isDark, isEn);
                          }
                          return _ScoreHero(
                            score: score,
                            isDark: isDark,
                            isEn: isEn,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Breakdown detail
                      scoreAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (score) {
                          if (score == null) return const SizedBox.shrink();
                          return _BreakdownDetail(
                            breakdown: score.breakdown,
                            isDark: isDark,
                            isEn: isEn,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Weekly trend
                      trendAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (trend) {
                          if (trend.dailyScores.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return _WeeklyTrendChart(
                            trend: trend,
                            isDark: isDark,
                            isEn: isEn,
                            isPremium: isPremium,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Tips
                      _buildTips(isDark, isEn),

                      const SizedBox(height: 24),
                      ContentDisclaimer(language: language),
                      ToolEcosystemFooter(
                        currentToolId: 'wellnessDetail',
                        isEn: isEn,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return PremiumEmptyState(
      icon: Icons.favorite_outline,
      title: L10nService.get('wellness.wellness_detail.your_wellness_score_is_building', language),
      description: L10nService.get('wellness.wellness_detail.log_a_cycle_entry_gratitude_or_sleep_to', language),
      gradientVariant: GradientTextVariant.aurora,
      ctaLabel: L10nService.get('wellness.wellness_detail.write_journal_entry', language),
      onCtaPressed: () => context.go(Routes.journal),
    );
  }

  Widget _buildTips(bool isDark, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('wellness.wellness_detail.how_your_score_works', language),
            variant: GradientTextVariant.aurora,
            style: AppTypography.displayFont.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _TipRow(
            icon: Icons.edit_note,
            text: L10nService.get('wellness.wellness_detail.journal_rating_40_of_score', language),
            isDark: isDark,
          ),
          _TipRow(
            icon: Icons.favorite_border,
            text: L10nService.get('wellness.wellness_detail.gratitude_items_15', language),
            isDark: isDark,
          ),
          _TipRow(
            icon: Icons.playlist_add_check,
            text: L10nService.get('wellness.wellness_detail.ritual_completion_15', language),
            isDark: isDark,
          ),
          _TipRow(
            icon: Icons.local_fire_department,
            text: L10nService.get('wellness.wellness_detail.streak_consistency_15', language),
            isDark: isDark,
          ),
          _TipRow(
            icon: Icons.bedtime_outlined,
            text: L10nService.get('wellness.wellness_detail.sleep_quality_15', language),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ScoreHero extends StatelessWidget {
  final WellnessScore score;
  final bool isDark;
  final bool isEn;

  const _ScoreHero({
    required this.score,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _scoreColor(score.score),
                  _scoreColor(score.score).withValues(alpha: 0.5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _scoreColor(score.score).withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${score.score}',
                style: AppTypography.displayFont.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ).animate().scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 400.ms,
            curve: Curves.easeOutBack,
          ),
          const SizedBox(height: 12),
          Text(
            _scoreLabel(score.score, isEn),
            style: AppTypography.displayFont.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _scoreColor(score.score),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            L10nService.get('wellness.wellness_detail.out_of_100', language),
            style: AppTypography.elegantAccent(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.auroraStart;
    if (score >= 40) return AppColors.warning;
    if (score >= 20) return AppColors.sunriseEnd;
    return AppColors.error;
  }

  String _scoreLabel(int score, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    if (score >= 80) return L10nService.get('wellness.wellness_detail.thriving', language);
    if (score >= 60) return L10nService.get('wellness.wellness_detail.good_balance', language);
    if (score >= 40) return L10nService.get('wellness.wellness_detail.room_to_grow', language);
    if (score >= 20) return L10nService.get('wellness.wellness_detail.getting_started', language);
    return L10nService.get('wellness.wellness_detail.get_started', language);
  }
}

class _BreakdownDetail extends StatelessWidget {
  final List<WellnessBreakdown> breakdown;
  final bool isDark;
  final bool isEn;

  const _BreakdownDetail({
    required this.breakdown,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('wellness.wellness_detail.score_breakdown', language),
            style: AppTypography.displayFont.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...breakdown.asMap().entries.map((entry) {
            final b = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _categoryIcon(b.category),
                        size: 16,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _categoryLabel(b.category, isEn),
                          style: AppTypography.subtitle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      Text(
                        '${b.score.round()}/100',
                        style: AppTypography.modernAccent(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${(b.weight * 100).round()}%)',
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (b.score / 100).clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                      valueColor: AlwaysStoppedAnimation(_barColor(b.score)),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (entry.key * 80).ms, duration: 300.ms);
          }),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'journal':
        return Icons.edit_note;
      case 'gratitude':
        return Icons.favorite_border;
      case 'rituals':
        return Icons.playlist_add_check;
      case 'streak':
        return Icons.local_fire_department;
      case 'sleep':
        return Icons.bedtime_outlined;
      default:
        return Icons.circle;
    }
  }

  String _categoryLabel(String category, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    switch (category) {
      case 'journal':
        return L10nService.get('wellness.wellness_detail.journal_rating', language);
      case 'gratitude':
        return L10nService.get('wellness.wellness_detail.gratitude_practice', language);
      case 'rituals':
        return L10nService.get('wellness.wellness_detail.ritual_completion', language);
      case 'streak':
        return L10nService.get('wellness.wellness_detail.streak_consistency', language);
      case 'sleep':
        return L10nService.get('wellness.wellness_detail.sleep_quality', language);
      default:
        return category;
    }
  }

  Color _barColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.auroraStart;
    if (score >= 40) return AppColors.warning;
    if (score >= 20) return AppColors.sunriseEnd;
    return AppColors.error;
  }
}

class _WeeklyTrendChart extends StatelessWidget {
  final WellnessTrend trend;
  final bool isDark;
  final bool isEn;
  final bool isPremium;

  const _WeeklyTrendChart({
    required this.trend,
    required this.isDark,
    required this.isEn,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                L10nService.get('wellness.wellness_detail.weekly_trend', language),
                style: AppTypography.displayFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                trend.direction == 'up'
                    ? Icons.trending_up
                    : trend.direction == 'down'
                    ? Icons.trending_down
                    : Icons.trending_flat,
                size: 20,
                color: trend.direction == 'up'
                    ? AppColors.success
                    : trend.direction == 'down'
                    ? AppColors.warning
                    : AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                _trendLabel(trend.direction, isEn),
                style: AppTypography.elegantAccent(
                  fontSize: 12,
                  color: trend.direction == 'up'
                      ? AppColors.success
                      : trend.direction == 'down'
                      ? AppColors.warning
                      : (isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Simple bar chart for the week
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trend.dailyScores.reversed
                  .take(7)
                  .toList()
                  .reversed
                  .map((score) {
                    final height = (score.score / 100 * 80).clamp(4.0, 80.0);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${score.score}',
                          style: AppTypography.elegantAccent(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 28,
                          height: height,
                          decoration: BoxDecoration(
                            color: _barColor(score.score),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          score.dateKey.length > 8
                              ? score.dateKey.substring(8)
                              : score.dateKey,
                          style: AppTypography.elegantAccent(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    );
                  })
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _trendLabel(String direction, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    switch (direction) {
      case 'up':
        return L10nService.get('wellness.wellness_detail.improving', language);
      case 'down':
        return L10nService.get('wellness.wellness_detail.declining', language);
      default:
        return L10nService.get('wellness.wellness_detail.stable', language);
    }
  }

  Color _barColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.auroraStart;
    if (score >= 40) return AppColors.warning;
    return AppColors.sunriseEnd;
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const _TipRow({required this.icon, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.subtitle(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
