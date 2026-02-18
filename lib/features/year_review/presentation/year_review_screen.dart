// ════════════════════════════════════════════════════════════════════════════
// YEAR IN REVIEW SCREEN - InnerCycles Annual Summary
// ════════════════════════════════════════════════════════════════════════════
// A beautiful, animated annual summary showing mood journey, focus area
// distribution, growth score, patterns, and shareable summary.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

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
import '../../../shared/widgets/glass_sliver_app_bar.dart';

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
      ref.read(smartRouterServiceProvider).whenData((s) => s.recordToolVisit('yearReview'));
      ref.read(ecosystemAnalyticsServiceProvider).whenData((s) => s.trackToolOpen('yearReview', source: 'direct'));
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
                  title: isEn ? 'Year in Review' : 'Yıllık Değerlendirme',
                ),
                // Year selector
                SliverToBoxAdapter(
                  child: yearsAsync.when(
                    loading: () => const SizedBox(height: 48),
                    error: (_, _) => const SizedBox.shrink(),
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
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (_, _) => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Center(
                          child: Text(
                            isEn
                                ? 'Could not load review'
                                : 'Değerlendirme yüklenemedi',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
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
                          const SizedBox(height: 40),
                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: years.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = year == selectedYear;
          return GestureDetector(
            onTap: () => onYearSelected(year),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                  style: TextStyle(
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
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: AppColors.starGold.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            isEn
                ? 'Your Year in Review is ready'
                : 'Yıllık değerlendirmeniz hazır',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isEn
                ? 'Keep journaling to unlock your annual summary. You need at least 7 entries in a year.'
                : 'Yıllık özet için günlük tutmaya devam edin. Bir yılda en az 7 kayıt gerekli.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NotEnoughData extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _NotEnoughData({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.lock_outline,
            size: 56,
            color: AppColors.starGold.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 20),
          Text(
            isEn
                ? 'Not enough entries for this year'
                : 'Bu yıl için yeterli kayıt yok',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'You need at least 7 journal entries to generate a review.'
                : 'Değerlendirme oluşturmak için en az 7 kayıt gerekli.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
          Icon(
            Icons.auto_awesome,
            size: 40,
            color: AppColors.starGold,
          ),
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                label: isEn ? 'Entries' : 'Kayıt',
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
                label: isEn ? 'Days' : 'Gün',
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
                label: isEn ? 'Avg Mood' : 'Ort Ruh Hali',
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
                label: isEn ? 'Best Streak' : 'En İyi Seri',
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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
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
    'J', 'F', 'M', 'A', 'M', 'J',
    'J', 'A', 'S', 'O', 'N', 'D',
  ];
  static const _monthLabelsTr = [
    'O', 'S', 'M', 'N', 'M', 'H',
    'T', 'A', 'E', 'E', 'K', 'A',
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
          Text(
            isEn ? 'Mood Journey' : 'Ruh Hali Yolculuğu',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn
                ? 'Monthly average mood (1-5)'
                : 'Aylık ortalama ruh hali (1-5)',
            style: TextStyle(
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
                            style: TextStyle(
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
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
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
    FocusArea.energy: Color(0xFFFFD700),
    FocusArea.focus: Color(0xFF4FC3F7),
    FocusArea.emotions: Color(0xFFFF6B9D),
    FocusArea.decisions: Color(0xFF81C784),
    FocusArea.social: Color(0xFFCE93D8),
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
          Text(
            isEn ? 'Focus Areas' : 'Odak Alanları',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn
                ? 'Time spent per area'
                : 'Alan başına harcanan zaman',
            style: TextStyle(
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
            final pct =
                ((count / review.totalEntries) * 100).round();
            final label = isEn ? area.displayNameEn : area.displayNameTr;

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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        '$count ($pct%)',
                        style: TextStyle(
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
        ? (isEn ? 'Strong Growth' : 'Güçlü Gelişim')
        : score >= 50
            ? (isEn ? 'Steady Progress' : 'İstikrarlı İlerleme')
            : (isEn ? 'Room to Grow' : 'Gelişim Alanı');

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            isEn ? 'Growth Score' : 'Gelişim Skoru',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn
                ? 'Based on your mood improvement trend'
                : 'Ruh hali iyileşme eğilimi bazında',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 160,
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
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: _scoreColor(score),
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
          Text(
            isEn ? 'Highlights' : 'Öne Çıkanlar',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          ...highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  border: Border.all(
                    color: h.color.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(h.icon, color: h.color, size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        h.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                          height: 1.4,
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
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final monthNamesTr = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
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
            results.add(_Highlight(
              icon: Icons.center_focus_strong,
              text: isEn
                  ? '${area.displayNameEn} was your top focus area ($pct% of entries)'
                  : '${area.displayNameTr} en çok odaklandığınız alan oldu (kayıtların %$pct\'i)',
              color: AppColors.starGold,
            ));
          }
        case 'best_month':
          if (parts.length >= 3) {
            final month = (int.tryParse(parts[1]) ?? 1).clamp(1, 12);
            final avg = parts[2];
            final name = isEn ? monthNamesEn[month] : monthNamesTr[month];
            results.add(_Highlight(
              icon: Icons.emoji_events,
              text: isEn
                  ? '$name was your best month (avg $avg)'
                  : '$name en iyi ayınız oldu (ort $avg)',
              color: AppColors.celestialGold,
            ));
          }
        case 'streak_30plus':
        case 'streak_14plus':
        case 'streak_7plus':
          if (parts.length >= 2) {
            final days = parts[1];
            results.add(_Highlight(
              icon: Icons.local_fire_department,
              text: isEn
                  ? 'Your longest streak was $days days!'
                  : 'En uzun seriniz $days gün oldu!',
              color: AppColors.brandPink,
            ));
          }
        case 'high_average':
          if (parts.length >= 2) {
            results.add(_Highlight(
              icon: Icons.sentiment_very_satisfied,
              text: isEn
                  ? 'You maintained a high average mood of ${parts[1]}'
                  : '${parts[1]} gibi yüksek bir ortalama ruh haliniz oldu',
              color: AppColors.success,
            ));
          }
        case 'diverse_explorer':
          if (parts.length >= 2) {
            results.add(_Highlight(
              icon: Icons.explore,
              text: isEn
                  ? 'You explored ${parts[1]} different focus areas'
                  : '${parts[1]} farklı odak alanını keşfettiniz',
              color: AppColors.auroraStart,
            ));
          }
        case 'daily_journaler':
          results.add(_Highlight(
            icon: Icons.star,
            text: isEn
                ? 'You journaled every single day!'
                : 'Her gün günlük tuttunuz!',
            color: AppColors.starGold,
          ));
        case 'dedicated_journaler':
        case 'committed_journaler':
          if (parts.length >= 2) {
            results.add(_Highlight(
              icon: Icons.auto_stories,
              text: isEn
                  ? 'You logged an impressive ${parts[1]} entries'
                  : 'Etkileyici bir şekilde ${parts[1]} kayıt oluşturdunuz',
              color: AppColors.cosmicPurple.withValues(alpha: 1.0),
            ));
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
    final topAreaName = isEn
        ? review.topFocusArea.displayNameEn
        : review.topFocusArea.displayNameTr;

    return GlassPanel(
      elevation: GlassElevation.g3,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(24),
      glowColor: AppColors.auroraStart.withValues(alpha: 0.15),
      child: Column(
        children: [
          Text(
            isEn ? 'My ${review.year} Summary' : '${review.year} Özetim',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
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
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
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
              icon: const Icon(Icons.share, size: 18),
              label: Text(isEn ? 'Share Summary' : 'Özeti Paylaş'),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.15),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
