// ════════════════════════════════════════════════════════════════════════════
// CYCLE CORRELATION SCREEN - Phase × focus area deep dive
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/cycle_entry.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/cycle_correlation_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class CycleCorrelationScreen extends ConsumerWidget {
  const CycleCorrelationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(cycleCorrelationServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              if (!service.hasEnoughData()) {
                return _InsufficientData(isEn: isEn, isDark: isDark);
              }

              final summaries = service.getPhaseSummaries();
              final insights = service.getCorrelationInsights();
              final heatmap = service.getHeatmapData();

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Cycle Correlation'
                        : 'Döngü Korelasyonu',
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
                                ? 'How your cycle phases relate to your journal focus'
                                : 'Döngü evrelerin günlük odağınla nasıl ilişkili',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Phase summaries
                          GradientText(
                            isEn
                                ? 'Phase Overview'
                                : 'Evre Genel Bakışı',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...summaries
                              .where((s) => s.entryCount > 0)
                              .map((s) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10),
                                    child: _PhaseSummaryCard(
                                      summary: s,
                                      isEn: isEn,
                                      isDark: isDark,
                                    ),
                                  ))
                              .toList()
                              .animate(interval: 80.ms)
                              .fadeIn(duration: 300.ms)
                              .slideX(begin: 0.05, end: 0),

                          const SizedBox(height: 24),

                          // Correlation insights
                          if (insights
                              .where((i) => i.isSignificant)
                              .isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Key Insights'
                                  : 'Temel Bulgular',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...insights
                                .where((i) => i.isSignificant)
                                .take(5)
                                .map((insight) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: _InsightTile(
                                        insight: insight,
                                        isEn: isEn,
                                        isDark: isDark,
                                      ),
                                    )),
                            const SizedBox(height: 24),
                          ],

                          // Heatmap
                          if (heatmap.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Cycle Day Heatmap'
                                  : 'Döngü Günü Isı Haritası',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _HeatmapGrid(
                              cells: heatmap,
                              isEn: isEn,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Disclaimer
                          Text(
                            isEn
                                ? 'These are pattern observations from your journal entries, not medical advice.'
                                : 'Bunlar günlük girdilerinden elde edilen kalıp gözlemleri, tıbbi tavsiye değil.',
                            style: AppTypography.subtitle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
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

Color _phaseColor(CyclePhase phase) {
  switch (phase) {
    case CyclePhase.menstrual:
      return const Color(0xFFE57373);
    case CyclePhase.follicular:
      return const Color(0xFF81C784);
    case CyclePhase.ovulatory:
      return AppColors.starGold;
    case CyclePhase.luteal:
      return AppColors.amethyst;
  }
}

String _phaseEmoji(CyclePhase phase) {
  switch (phase) {
    case CyclePhase.menstrual:
      return '\u{1F319}';
    case CyclePhase.follicular:
      return '\u{1F331}';
    case CyclePhase.ovulatory:
      return '\u{2600}\u{FE0F}';
    case CyclePhase.luteal:
      return '\u{1F343}';
  }
}

class _PhaseSummaryCard extends StatelessWidget {
  final PhaseSummary summary;
  final bool isEn;
  final bool isDark;

  const _PhaseSummaryCard({
    required this.summary,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = _phaseColor(summary.phase);
    final phaseName = isEn
        ? summary.phase.displayNameEn
        : summary.phase.displayNameTr;

    // Find best and worst focus areas
    FocusArea? bestArea;
    FocusArea? worstArea;
    double bestVal = 0;
    double worstVal = 6;
    for (final entry in summary.focusAreaAverages.entries) {
      if (entry.value > bestVal) {
        bestVal = entry.value;
        bestArea = entry.key;
      }
      if (entry.value < worstVal) {
        worstVal = entry.value;
        worstArea = entry.key;
      }
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color.withValues(alpha: 0.12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_phaseEmoji(summary.phase),
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 6),
                    Text(
                      phaseName,
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${summary.entryCount} ${isEn ? 'entries' : 'giriş'}',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Overall rating
          Row(
            children: [
              Text(
                isEn ? 'Avg rating' : 'Ort. puan',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: summary.averageOverallRating / 5.0,
                    backgroundColor:
                        (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                summary.averageOverallRating.toStringAsFixed(1),
                style: AppTypography.modernAccent(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),

          if (bestArea != null && worstArea != null && bestArea != worstArea) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.arrow_upward_rounded,
                    size: 12, color: AppColors.success),
                const SizedBox(width: 4),
                Text(
                  isEn
                      ? bestArea.displayNameEn
                      : bestArea.displayNameTr,
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.arrow_downward_rounded,
                    size: 12, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  isEn
                      ? worstArea.displayNameEn
                      : worstArea.displayNameTr,
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final CycleCorrelationInsight insight;
  final bool isEn;
  final bool isDark;

  const _InsightTile({
    required this.insight,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final areaName = isEn
        ? insight.focusArea.displayNameEn
        : insight.focusArea.displayNameTr;
    final strongName = insight.strongestPhase != null
        ? (isEn
            ? insight.strongestPhase!.displayNameEn
            : insight.strongestPhase!.displayNameTr)
        : null;
    final weakName = insight.weakestPhase != null
        ? (isEn
            ? insight.weakestPhase!.displayNameEn
            : insight.weakestPhase!.displayNameTr)
        : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            areaName,
            style: AppTypography.modernAccent(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Phase averages bar chart
          ...insight.phaseAverages.entries.map((entry) {
            final color = _phaseColor(entry.key);
            final phaseName = isEn
                ? entry.key.displayNameEn
                : entry.key.displayNameTr;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      phaseName,
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: entry.value / 5.0,
                        backgroundColor:
                            (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.06),
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 28,
                    child: Text(
                      entry.value.toStringAsFixed(1),
                      textAlign: TextAlign.end,
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Insight text
          if (strongName != null || weakName != null) ...[
            const SizedBox(height: 6),
            Text(
              _buildInsightText(
                areaName, strongName, weakName, isEn),
              style: AppTypography.subtitle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildInsightText(
      String area, String? strong, String? weak, bool isEn) {
    if (strong != null && weak != null) {
      return isEn
          ? '$area tends to be strongest during $strong and may need more attention during $weak.'
          : '$area, $strong evresinde en güçlü olma eğiliminde ve $weak evresinde daha fazla dikkat gerektirebilir.';
    }
    if (strong != null) {
      return isEn
          ? '$area tends to be strongest during $strong.'
          : '$area, $strong evresinde en güçlü olma eğiliminde.';
    }
    if (weak != null) {
      return isEn
          ? '$area may need more attention during $weak.'
          : '$area, $weak evresinde daha fazla dikkat gerektirebilir.';
    }
    return '';
  }
}

class _HeatmapGrid extends StatelessWidget {
  final List<CycleHeatmapCell> cells;
  final bool isEn;
  final bool isDark;

  const _HeatmapGrid({
    required this.cells,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Build a grid: rows = focus areas, columns = cycle days
    final maxDay = cells.fold<int>(
        0, (max, c) => c.cycleDay > max ? c.cycleDay : max);
    final areas = FocusArea.values;

    // Build lookup map
    final lookup = <String, CycleHeatmapCell>{};
    for (final cell in cells) {
      lookup['${cell.cycleDay}-${cell.focusArea.index}'] = cell;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row — cycle days
          Row(
            children: [
              const SizedBox(width: 52),
              ...List.generate(
                maxDay.clamp(1, 28),
                (i) => Expanded(
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: AppTypography.elegantAccent(
                        fontSize: 7,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Rows per focus area
          ...areas.map((area) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: Text(
                      isEn
                          ? area.displayNameEn
                          : area.displayNameTr,
                      style: AppTypography.elegantAccent(
                        fontSize: 8,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ...List.generate(
                    maxDay.clamp(1, 28),
                    (i) {
                      final cell =
                          lookup['${i + 1}-${area.index}'];
                      final intensity = cell != null
                          ? (cell.averageRating / 5.0).clamp(0.0, 1.0)
                          : 0.0;
                      return Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            margin: const EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(2),
                              color: cell != null
                                  ? AppColors.auroraStart
                                      .withValues(
                                          alpha: 0.1 +
                                              intensity * 0.6)
                                  : (isDark
                                          ? Colors.white
                                          : Colors.black)
                                      .withValues(alpha: 0.03),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEn ? 'Low' : 'Düşük',
                style: AppTypography.elegantAccent(
                  fontSize: 9,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 6),
              ...List.generate(5, (i) {
                final alpha = 0.1 + (i / 4) * 0.6;
                return Container(
                  width: 12,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppColors.auroraStart
                        .withValues(alpha: alpha),
                  ),
                );
              }),
              const SizedBox(width: 6),
              Text(
                isEn ? 'High' : 'Yüksek',
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
    );
  }
}

class _InsufficientData extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _InsufficientData({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Cycle Correlation' : 'Döngü Korelasyonu',
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
                      const Text('\u{1F300}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Keep logging your cycle and journal entries to reveal phase-focus patterns'
                            : 'Evre-odak kalıplarını ortaya çıkarmak için döngü ve günlük kaydına devam et',
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEn
                            ? 'At least 7 journal entries with cycle data needed'
                            : 'En az 7 günlük girdisi ve döngü verisi gerekli',
                        style: AppTypography.elegantAccent(
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
        ),
      ],
    );
  }
}
