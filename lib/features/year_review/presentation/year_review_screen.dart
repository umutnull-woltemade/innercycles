// ════════════════════════════════════════════════════════════════════════════
// YEAR IN REVIEW SCREEN - InnerCycles Annual Summary
// ════════════════════════════════════════════════════════════════════════════
// A beautiful, animated annual summary showing mood journey, focus area
// distribution, growth score, patterns, and shareable summary.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/year_review_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/l10n_service.dart';

// ══════════════════════════════════════════════════════════════════════════
// SCREEN-SPECIFIC PROVIDERS
// ══════════════════════════════════════════════════════════════════════════

final availableYearsProvider = FutureProvider<List<int>>((ref) async {
  final service = await ref.watch(yearReviewServiceProvider.future);
  return await service.getAvailableYears();
});

final selectedYearProvider = StateProvider<int?>((ref) => null);

final yearReviewProvider = FutureProvider<YearReview?>((ref) async {
  final service = await ref.watch(yearReviewServiceProvider.future);
  final selectedYear = ref.watch(selectedYearProvider);
  if (selectedYear == null) return null;
  return await service.generateReview(selectedYear);
});

// ══════════════════════════════════════════════════════════════════════════
// SCREEN
// ══════════════════════════════════════════════════════════════════════════

class YearReviewScreen extends ConsumerStatefulWidget {
  const YearReviewScreen({super.key});

  @override
  ConsumerState<YearReviewScreen> createState() => _YearReviewScreenState();
}

class _YearReviewScreenState extends ConsumerState<YearReviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('yearReview'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('yearReview', source: 'direct'));
    });
    // Auto-select the most recent available year on first load
    Future.microtask(() async {
      if (!mounted) return;
      final years = await ref.read(availableYearsProvider.future);
      if (!mounted) return;
      if (years.isNotEmpty && ref.read(selectedYearProvider) == null) {
        ref.read(selectedYearProvider.notifier).state = years.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final yearsAsync = ref.watch(availableYearsProvider);
    final reviewAsync = ref.watch(yearReviewProvider);
    final selectedYear = ref.watch(selectedYearProvider);

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
                  title: L10nService.get('year_review.year_review.year_synthesis', isEn ? AppLanguage.en : AppLanguage.tr),
                ),
                // Year selector
                SliverToBoxAdapter(
                  child: yearsAsync.when(
                    loading: () => const SizedBox(height: 48),
                    error: (_, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              L10nService.get('year_review.year_review.could_not_load_your_local_data_is_unaffe', isEn ? AppLanguage.en : AppLanguage.tr),
                              textAlign: TextAlign.center,
                              style: AppTypography.subtitle(
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: () =>
                                  ref.invalidate(availableYearsProvider),
                              icon: Icon(
                                Icons.refresh_rounded,
                                size: 16,
                                color: AppColors.starGold,
                              ),
                              label: Text(
                                L10nService.get('year_review.year_review.retry', isEn ? AppLanguage.en : AppLanguage.tr),
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
                    data: (years) {
                      if (years.isEmpty) {
                        return _EmptyState(isDark: isDark, isEn: isEn);
                      }
                      if (years.length > 1) {
                        return _YearSelector(
                          years: years,
                          selectedYear: selectedYear,
                          isDark: isDark,
                          onYearSelected: (year) {
                            ref.read(selectedYearProvider.notifier).state =
                                year;
                          },
                        );
                      }
                      return const SizedBox(height: 8);
                    },
                  ),
                ),
                // Review content
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: reviewAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: Center(child: CosmicLoadingIndicator()),
                      ),
                    ),
                    error: (_, _) => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                L10nService.get('year_review.year_review.could_not_load_your_local_data_is_unaffe_1', isEn ? AppLanguage.en : AppLanguage.tr),
                                textAlign: TextAlign.center,
                                style: AppTypography.subtitle(
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () =>
                                    ref.invalidate(yearReviewProvider),
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  size: 16,
                                  color: AppColors.starGold,
                                ),
                                label: Text(
                                  L10nService.get('year_review.year_review.retry_1', isEn ? AppLanguage.en : AppLanguage.tr),
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
                    ),
                    data: (review) {
                      if (review == null) {
                        if (selectedYear == null) {
                          return SliverToBoxAdapter(
                            child: _EmptyState(isDark: isDark, isEn: isEn),
                          );
                        }
                        return SliverToBoxAdapter(
                          child: _NotEnoughData(isDark: isDark, isEn: isEn),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: 8),
                          _HeroCard(
                            review: review,
                            isDark: isDark,
                            isEn: isEn,
                          ).glassReveal(context: context),
                          const SizedBox(height: 20),
                          _MoodJourneyCard(
                            review: review,
                            isDark: isDark,
                            isEn: isEn,
                          ).glassListItem(context: context, index: 1),
                          const SizedBox(height: 20),
                          _FocusAreasCard(
                            review: review,
                            isDark: isDark,
                            isEn: isEn,
                          ).glassListItem(context: context, index: 2),
                          const SizedBox(height: 20),
                          _GrowthScoreCard(
                            review: review,
                            isDark: isDark,
                            isEn: isEn,
                          ).glassListItem(context: context, index: 3),
                          const SizedBox(height: 20),
                          _HighlightsCard(
                            review: review,
                            isDark: isDark,
                            isEn: isEn,
                          ).glassListItem(context: context, index: 4),
                          const SizedBox(height: 20),
                          _ShareableSummaryCard(
                            review: review,
                            isDark: isDark,
                            isEn: isEn,
                          ).glassListItem(context: context, index: 5),
                          ContentDisclaimer(
                            language: language,
                          ),
                          ToolEcosystemFooter(
                            currentToolId: 'yearReview',
                            isEn: isEn,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 40),
                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// YEAR SELECTOR
// ══════════════════════════════════════════════════════════════════════════

class _YearSelector extends StatelessWidget {
  final List<int> years;
  final int? selectedYear;
  final bool isDark;
  final ValueChanged<int> onYearSelected;

  const _YearSelector({
    required this.years,
    required this.selectedYear,
    required this.isDark,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: years.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = year == selectedYear;
          return Semantics(
            label: '$year',
            button: true,
            selected: isSelected,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onYearSelected(year);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.starGold
                      : isDark
                      ? AppColors.surfaceDark.withValues(alpha: 0.8)
                      : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.starGold
                        : isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$year',
                    style: AppTypography.modernAccent(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.black
                          : isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// EMPTY / NOT-ENOUGH-DATA STATES
// ══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyState({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return PremiumEmptyState(
      icon: Icons.auto_awesome,
      title: L10nService.get('year_review.year_review.your_year_synthesis_is_ready', isEn ? AppLanguage.en : AppLanguage.tr),
      description: L10nService.get('year_review.year_review.keep_recording_to_activate_your_annual_s', isEn ? AppLanguage.en : AppLanguage.tr),
      gradientVariant: GradientTextVariant.gold,
    );
  }
}

class _NotEnoughData extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _NotEnoughData({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return PremiumEmptyState(
      icon: Icons.lock_outline,
      title: L10nService.get('year_review.year_review.not_enough_entries_for_this_year', isEn ? AppLanguage.en : AppLanguage.tr),
      description: L10nService.get('year_review.year_review.you_need_at_least_7_journal_entries_to_g', isEn ? AppLanguage.en : AppLanguage.tr),
      gradientVariant: GradientTextVariant.gold,
      ctaLabel: L10nService.get('year_review.year_review.start_journaling', isEn ? AppLanguage.en : AppLanguage.tr),
      onCtaPressed: () => context.go(Routes.journal),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// 1) HERO CARD
// ══════════════════════════════════════════════════════════════════════════

class _HeroCard extends StatelessWidget {
  final YearReview review;
  final bool isDark;
  final bool isEn;

  const _HeroCard({
    required this.review,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      elevation: GlassElevation.g3,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(24),
      glowColor: AppColors.starGold.withValues(alpha: 0.2),
      child: Column(
        children: [
          Icon(Icons.auto_awesome, size: 40, color: AppColors.starGold),
          const SizedBox(height: 8),
          Text(
            'InnerCycles',
            style: AppTypography.elegantAccent(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.0,
              color: AppColors.starGold.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isEn
                ? 'Your ${review.year} in Review'
                : '${review.year} Yılı Değerlendirmesi',
            style: AppTypography.modernAccent(
              fontSize: 24,
              color: AppColors.starGold,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatColumn(
                value: '${review.totalEntries}',
                label: L10nService.get('year_review.year_review.entries', isEn ? AppLanguage.en : AppLanguage.tr),
                isDark: isDark,
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.08),
              ),
              _StatColumn(
                value: '${review.totalJournalingDays}',
                label: L10nService.get('year_review.year_review.days', isEn ? AppLanguage.en : AppLanguage.tr),
                isDark: isDark,
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.08),
              ),
              _StatColumn(
                value: review.averageMood.toStringAsFixed(1),
                label: L10nService.get('year_review.year_review.avg_mood', isEn ? AppLanguage.en : AppLanguage.tr),
                isDark: isDark,
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.08),
              ),
              _StatColumn(
                value: '${review.streakBest}',
                label: L10nService.get('year_review.year_review.best_streak', isEn ? AppLanguage.en : AppLanguage.tr),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _StatColumn({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// 2) MOOD JOURNEY (12-month bar chart)
// ══════════════════════════════════════════════════════════════════════════

class _MoodJourneyCard extends StatelessWidget {
  final YearReview review;
  final bool isDark;
  final bool isEn;

  const _MoodJourneyCard({
    required this.review,
    required this.isDark,
    required this.isEn,
  });

  static const _monthLabelsEn = [
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ];
  static const _monthLabelsTr = [
    'O',
    'S',
    'M',
    'N',
    'M',
    'H',
    'T',
    'A',
    'E',
    'E',
    'K',
    'A',
  ];

  @override
  Widget build(BuildContext context) {
    final monthLabels = isEn ? _monthLabelsEn : _monthLabelsTr;

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('year_review.year_review.mood_trajectory', isEn ? AppLanguage.en : AppLanguage.tr),
            variant: GradientTextVariant.aurora,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            L10nService.get('year_review.year_review.monthly_average_mood_15', isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.elegantAccent(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (i) {
                final value = review.moodJourney[i];
                final barHeight = value > 0 ? (value / 5.0) * 120 : 0.0;
                final hasData = value > 0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (hasData)
                          Text(
                            value.toStringAsFixed(1),
                            style: AppTypography.modernAccent(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: barHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: hasData
                                ? LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      _moodColor(value).withValues(alpha: 0.6),
                                      _moodColor(value),
                                    ],
                                  )
                                : null,
                            color: hasData
                                ? null
                                : isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.03),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          monthLabels[i],
                          style: AppTypography.subtitle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _moodColor(double mood) {
    if (mood >= 4.0) return AppColors.success;
    if (mood >= 3.0) return AppColors.starGold;
    if (mood >= 2.0) return AppColors.warning;
    return AppColors.error;
  }
}

// ══════════════════════════════════════════════════════════════════════════
// 3) FOCUS AREAS CARD (horizontal bars)
// ══════════════════════════════════════════════════════════════════════════

class _FocusAreasCard extends StatelessWidget {
  final YearReview review;
  final bool isDark;
  final bool isEn;

  const _FocusAreasCard({
    required this.review,
    required this.isDark,
    required this.isEn,
  });

  static const _areaColors = {
    FocusArea.energy: AppColors.starGold,
    FocusArea.focus: AppColors.chartBlue,
    FocusArea.emotions: AppColors.chartPink,
    FocusArea.decisions: AppColors.chartGreen,
    FocusArea.social: AppColors.chartPurple,
  };

  @override
  Widget build(BuildContext context) {
    // Sort by count descending
    final sortedAreas = review.focusAreaCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCount = sortedAreas.isNotEmpty ? sortedAreas.first.value : 1;

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('year_review.year_review.focus_areas', isEn ? AppLanguage.en : AppLanguage.tr),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            L10nService.get('year_review.year_review.time_spent_per_area', isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.elegantAccent(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          ...sortedAreas.map((entry) {
            final area = entry.key;
            final count = entry.value;
            final ratio = count / maxCount;
            final color = _areaColors[area] ?? AppColors.starGold;
            final pct = ((count / review.totalEntries) * 100).round();
            final label = area.localizedName(isEn);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: AppTypography.subtitle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        '$count ($pct%)',
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ratio,
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05),
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// 4) GROWTH SCORE (circular progress)
// ══════════════════════════════════════════════════════════════════════════

class _GrowthScoreCard extends StatelessWidget {
  final YearReview review;
  final bool isDark;
  final bool isEn;

  const _GrowthScoreCard({
    required this.review,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final score = review.growthScore;
    final label = score >= 70
        ? (L10nService.get('year_review.year_review.strong_growth', isEn ? AppLanguage.en : AppLanguage.tr))
        : score >= 50
        ? (L10nService.get('year_review.year_review.steady_progress', isEn ? AppLanguage.en : AppLanguage.tr))
        : (L10nService.get('year_review.year_review.room_to_grow', isEn ? AppLanguage.en : AppLanguage.tr));

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          GradientText(
            L10nService.get('year_review.year_review.growth_score', isEn ? AppLanguage.en : AppLanguage.tr),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            L10nService.get('year_review.year_review.based_on_your_mood_improvement_trend', isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.elegantAccent(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 160,
            child: Semantics(
              label: isEn
                  ? 'Growth score: $score out of 100'
                  : 'Gelişim skoru: 100 üzerinden $score',
              image: true,
              child: CustomPaint(
                painter: _GrowthCirclePainter(
                  progress: score / 100.0,
                  isDark: isDark,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$score',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: _scoreColor(score),
                        ),
                      ),
                      Text(
                        label,
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 70) return AppColors.success;
    if (score >= 50) return AppColors.starGold;
    if (score >= 30) return AppColors.warning;
    return AppColors.error;
  }
}

class _GrowthCirclePainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _GrowthCirclePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 12.0;

    // Background ring
    final bgPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressColor = progress >= 0.7
        ? AppColors.success
        : progress >= 0.5
        ? AppColors.starGold
        : progress >= 0.3
        ? AppColors.warning
        : AppColors.error;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Glow effect
    final glowPaint = Paint()
      ..color = progressColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GrowthCirclePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDark != isDark;
}

// ══════════════════════════════════════════════════════════════════════════
// 5) HIGHLIGHTS CARD (patterns & achievements)
// ══════════════════════════════════════════════════════════════════════════

class _HighlightsCard extends StatelessWidget {
  final YearReview review;
  final bool isDark;
  final bool isEn;

  const _HighlightsCard({
    required this.review,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final highlights = _parseHighlights(review.topPatterns);
    if (highlights.isEmpty) return const SizedBox.shrink();

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('year_review.year_review.highlights', isEn ? AppLanguage.en : AppLanguage.tr),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            h.color.withValues(alpha: 0.15),
                            h.color.withValues(alpha: 0.05),
                          ]
                        : [
                            h.color.withValues(alpha: 0.1),
                            h.color.withValues(alpha: 0.03),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: h.color.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Icon(h.icon, color: h.color, size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        h.text,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_Highlight> _parseHighlights(List<String> patterns) {
    final results = <_Highlight>[];
    final monthNamesEn = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final monthNamesTr = [
      '',
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];

    for (final p in patterns) {
      final parts = p.split(':');
      final type = parts[0];

      switch (type) {
        case 'focus_dominant':
          if (parts.length >= 3) {
            final areaName = parts[1];
            final pct = parts[2];
            final area = FocusArea.values.firstWhere(
              (a) => a.name == areaName,
              orElse: () => FocusArea.energy,
            );
            results.add(
              _Highlight(
                icon: Icons.center_focus_strong,
                text: isEn
                    ? '${area.displayNameEn} was your top focus area ($pct% of entries)'
                    : '${area.displayNameTr} en çok odaklandığınız alan oldu (kayıtların %$pct\'i)',
                color: AppColors.starGold,
              ),
            );
          }
        case 'best_month':
          if (parts.length >= 3) {
            final month = (int.tryParse(parts[1]) ?? 1).clamp(1, 12);
            final avg = parts[2];
            final name = isEn ? monthNamesEn[month] : monthNamesTr[month];
            results.add(
              _Highlight(
                icon: Icons.emoji_events,
                text: isEn
                    ? '$name was your best month (avg $avg)'
                    : '$name en iyi ayınız oldu (ort $avg)',
                color: AppColors.celestialGold,
              ),
            );
          }
        case 'streak_30plus':
        case 'streak_14plus':
        case 'streak_7plus':
          if (parts.length >= 2) {
            final days = parts[1];
            results.add(
              _Highlight(
                icon: Icons.local_fire_department,
                text: isEn
                    ? 'Your longest streak was $days days!'
                    : 'En uzun seriniz $days gün oldu!',
                color: AppColors.brandPink,
              ),
            );
          }
        case 'high_average':
          if (parts.length >= 2) {
            results.add(
              _Highlight(
                icon: Icons.sentiment_very_satisfied,
                text: isEn
                    ? 'You maintained a high average mood of ${parts[1]}'
                    : '${parts[1]} gibi yüksek bir ortalama ruh haliniz oldu',
                color: AppColors.success,
              ),
            );
          }
        case 'diverse_explorer':
          if (parts.length >= 2) {
            results.add(
              _Highlight(
                icon: Icons.explore,
                text: isEn
                    ? 'You explored ${parts[1]} different focus areas'
                    : '${parts[1]} farklı odak alanını keşfettiniz',
                color: AppColors.auroraStart,
              ),
            );
          }
        case 'daily_journaler':
          results.add(
            _Highlight(
              icon: Icons.star,
              text: L10nService.get('year_review.year_review.you_journaled_every_single_day', isEn ? AppLanguage.en : AppLanguage.tr),
              color: AppColors.starGold,
            ),
          );
        case 'dedicated_journaler':
        case 'committed_journaler':
          if (parts.length >= 2) {
            results.add(
              _Highlight(
                icon: Icons.auto_stories,
                text: isEn
                    ? 'You logged an impressive ${parts[1]} entries'
                    : 'Etkileyici bir şekilde ${parts[1]} kayıt oluşturdunuz',
                color: AppColors.amethyst,
              ),
            );
          }
      }
    }

    return results;
  }
}

class _Highlight {
  final IconData icon;
  final String text;
  final Color color;

  const _Highlight({
    required this.icon,
    required this.text,
    required this.color,
  });
}

// ══════════════════════════════════════════════════════════════════════════
// 6) SHAREABLE SUMMARY CARD
// ══════════════════════════════════════════════════════════════════════════

class _ShareableSummaryCard extends StatelessWidget {
  final YearReview review;
  final bool isDark;
  final bool isEn;

  const _ShareableSummaryCard({
    required this.review,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final topAreaName = review.topFocusArea.localizedName(isEn);

    return GlassPanel(
      elevation: GlassElevation.g3,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(24),
      glowColor: AppColors.auroraStart.withValues(alpha: 0.15),
      child: Column(
        children: [
          GradientText(
            L10nService.getWithParams('year_review.my_year_summary', isEn ? AppLanguage.en : AppLanguage.tr, params: {'year': '${review.year}'}),
            variant: GradientTextVariant.aurora,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEn
                ? '${review.totalEntries} entries across ${review.totalJournalingDays} days\n'
                      'Top focus: $topAreaName\n'
                      'Growth score: ${review.growthScore}/100\n'
                      'Best streak: ${review.streakBest} days'
                : '${review.totalJournalingDays} günde ${review.totalEntries} kayıt\n'
                      'En çok odak: $topAreaName\n'
                      'Gelişim skoru: ${review.growthScore}/100\n'
                      'En iyi seri: ${review.streakBest} gün',
            style: AppTypography.decorativeScript(
              fontSize: 15,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'InnerCycles',
            style: AppTypography.elegantAccent(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
              color: AppColors.starGold.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          GradientOutlinedButton(
            label: L10nService.get('year_review.year_review.share_summary', isEn ? AppLanguage.en : AppLanguage.tr),
            icon: Icons.share,
            variant: GradientTextVariant.gold,
            expanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            onPressed: () {
              HapticFeedback.mediumImpact();
              final shareText = isEn
                  ? 'My ${review.year} in Review\n\n'
                        '${review.totalEntries} entries across ${review.totalJournalingDays} days\n'
                        'Top focus: $topAreaName\n'
                        'Growth score: ${review.growthScore}/100\n'
                        'Best streak: ${review.streakBest} days\n\n'
                        'Reflected with InnerCycles'
                  : '${review.year} Yılı Değerlendirmem\n\n'
                        '${review.totalJournalingDays} günde ${review.totalEntries} kayıt\n'
                        'En çok odak: $topAreaName\n'
                        'Gelişim skoru: ${review.growthScore}/100\n'
                        'En iyi seri: ${review.streakBest} gün\n\n'
                        'InnerCycles ile yansıma yaptım';
              SharePlus.instance.share(ShareParams(text: shareText));
            },
          ),
        ],
      ),
    );
  }
}
