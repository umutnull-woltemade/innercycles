// ════════════════════════════════════════════════════════════════════════════
// ENERGY MAP EXPLORER - Deep dive into energy patterns & heatmap
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/energy_map_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class EnergyMapExplorerScreen extends ConsumerWidget {
  const EnergyMapExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mapAsync = ref.watch(energyMapProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: mapAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (mapData) {
              if (mapData == null) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Energy Explorer'
                        : 'Enerji Keşfi',
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
                                ? 'Your energy patterns across days and focus areas'
                                : 'Günler ve odak alanları arasındaki enerji kalıpların',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview hero
                          _OverviewHero(
                            mapData: mapData,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Heatmap grid
                          GradientText(
                            isEn
                                ? 'Energy Heatmap'
                                : 'Enerji Isı Haritası',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _HeatmapGrid(
                            cells: mapData.cells,
                            isEn: isEn,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 24),

                          // Day of week chart
                          GradientText(
                            isEn
                                ? 'Day of Week Averages'
                                : 'Hafta Günü Ortalamaları',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _DayOfWeekChart(
                            cells: mapData.cells,
                            bestDay: mapData.bestDay,
                            worstDay: mapData.worstDay,
                            isEn: isEn,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 24),

                          // 28-day timeline
                          if (mapData.dailySnapshots.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? '28-Day Timeline'
                                  : '28 Günlük Zaman Çizelgesi',
                              variant:
                                  GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _DailyTimeline(
                              snapshots: mapData.dailySnapshots,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? 'Patterns from your journal entries'
                                  : 'Günlük kayıtlarından kalıplar',
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

String _dayLabel(int weekday, bool isEn) {
  const en = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const tr = ['', 'Pzt', 'Sal', '\u00C7ar', 'Per', 'Cum', 'Cmt', 'Paz'];
  return (isEn ? en : tr)[weekday];
}

String _focusLabel(FocusArea area, bool isEn) {
  switch (area) {
    case FocusArea.energy:
      return isEn ? 'Energy' : 'Enerji';
    case FocusArea.focus:
      return isEn ? 'Focus' : 'Odak';
    case FocusArea.emotions:
      return isEn ? 'Emotions' : 'Duygular';
    case FocusArea.decisions:
      return isEn ? 'Decisions' : 'Kararlar';
    case FocusArea.social:
      return isEn ? 'Social' : 'Sosyal';
  }
}

Color _intensityColor(double intensity, bool isDark) {
  if (intensity <= 0) {
    return (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04);
  }
  return AppColors.auroraStart.withValues(alpha: 0.1 + (intensity * 0.6));
}

class _OverviewHero extends StatelessWidget {
  final EnergyMapData mapData;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.mapData,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
                  mapData.overallAverage.toStringAsFixed(1),
                  style: AppTypography.modernAccent(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.auroraStart,
                  ),
                ),
                Text(
                  isEn ? 'Avg Rating' : 'Ort Puan',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
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
                  _dayLabel(mapData.bestDay, isEn),
                  style: AppTypography.modernAccent(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                Text(
                  isEn ? 'Best Day' : 'En İyi Gün',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
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
                  _dayLabel(mapData.worstDay, isEn),
                  style: AppTypography.modernAccent(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                  ),
                ),
                Text(
                  isEn ? 'Low Day' : 'Düşük Gün',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            if (mapData.strongestArea != null)
              Column(
                children: [
                  Text(
                    _focusLabel(mapData.strongestArea!, isEn),
                    style: AppTypography.modernAccent(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.starGold,
                    ),
                  ),
                  Text(
                    isEn ? 'Strongest' : 'En G\u00FC\u00E7l\u00FC',
                    style: AppTypography.elegantAccent(
                      fontSize: 9,
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

class _HeatmapGrid extends StatelessWidget {
  final List<HeatmapCell> cells;
  final bool isEn;
  final bool isDark;

  const _HeatmapGrid({
    required this.cells,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          // Header row (days)
          Row(
            children: [
              const SizedBox(width: 60),
              ...List.generate(7, (i) {
                final day = i + 1;
                return Expanded(
                  child: Center(
                    child: Text(
                      _dayLabel(day, isEn),
                      style: AppTypography.elegantAccent(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 6),
          // Focus area rows
          ...FocusArea.values.map((area) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      _focusLabel(area, isEn),
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  ...List.generate(7, (i) {
                    final day = i + 1;
                    final cell = cells.where(
                        (c) => c.weekday == day && c.area == area);
                    final intensity = cell.isNotEmpty
                        ? cell.first.intensity
                        : 0.0;
                    final rating = cell.isNotEmpty
                        ? cell.first.averageRating
                        : 0.0;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(4),
                              color: _intensityColor(
                                  intensity, isDark),
                            ),
                            child: rating > 0
                                ? Center(
                                    child: Text(
                                      rating.toStringAsFixed(1),
                                      style: AppTypography
                                          .modernAccent(
                                        fontSize: 8,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: intensity > 0.5
                                            ? Colors.white
                                            : (isDark
                                                ? AppColors
                                                    .textMuted
                                                : AppColors
                                                    .lightTextMuted),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DayOfWeekChart extends StatelessWidget {
  final List<HeatmapCell> cells;
  final int bestDay;
  final int worstDay;
  final bool isEn;
  final bool isDark;

  const _DayOfWeekChart({
    required this.cells,
    required this.bestDay,
    required this.worstDay,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate day averages
    final dayAvgs = <int, double>{};
    for (int d = 1; d <= 7; d++) {
      final dayCells =
          cells.where((c) => c.weekday == d && c.averageRating > 0);
      if (dayCells.isNotEmpty) {
        dayAvgs[d] = dayCells
                .map((c) => c.averageRating)
                .reduce((a, b) => a + b) /
            dayCells.length;
      }
    }

    final maxAvg = dayAvgs.values.isNotEmpty
        ? dayAvgs.values.reduce((a, b) => a > b ? a : b)
        : 5.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (i) {
            final day = i + 1;
            final avg = dayAvgs[day] ?? 0.0;
            final ratio = maxAvg > 0 ? avg / maxAvg : 0.0;
            final isBest = day == bestDay;
            final isWorst = day == worstDay;
            final color = isBest
                ? AppColors.success
                : isWorst
                    ? AppColors.warning
                    : AppColors.auroraStart;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (avg > 0)
                      Text(
                        avg.toStringAsFixed(1),
                        style: AppTypography.modernAccent(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: ratio.clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(4),
                            color:
                                color.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _dayLabel(day, isEn),
                      style: AppTypography.elegantAccent(
                        fontSize: 9,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _DailyTimeline extends StatelessWidget {
  final List<DailyEnergySnapshot> snapshots;
  final bool isDark;

  const _DailyTimeline({
    required this.snapshots,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final maxRating = snapshots
        .map((s) => s.averageRating)
        .where((r) => r > 0)
        .fold(5.0, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: snapshots.map((snap) {
            final ratio =
                maxRating > 0 ? snap.averageRating / maxRating : 0.0;
            final color = snap.dominantArea != null
                ? _focusAreaColor(snap.dominantArea!)
                : AppColors.auroraStart;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.5),
                child: FractionallySizedBox(
                  heightFactor: ratio > 0 ? ratio.clamp(0.05, 1.0) : 0.02,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: ratio > 0
                          ? color.withValues(alpha: 0.5)
                          : (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.06),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

Color _focusAreaColor(FocusArea area) {
  switch (area) {
    case FocusArea.energy:
      return AppColors.starGold;
    case FocusArea.focus:
      return AppColors.chartBlue;
    case FocusArea.emotions:
      return AppColors.brandPink;
    case FocusArea.decisions:
      return AppColors.success;
    case FocusArea.social:
      return AppColors.amethyst;
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
          title: isEn ? 'Energy Explorer' : 'Enerji Keşfi',
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
                      const Text('\u{26A1}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Write at least 5 journal entries to see your energy patterns'
                            : 'Enerji kalıplarını görmek için en az 5 günlük kaydı yaz',
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
