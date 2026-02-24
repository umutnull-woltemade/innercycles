// ════════════════════════════════════════════════════════════════════════════
// ENERGY MAP SCREEN - Heatmap Visualization
// ════════════════════════════════════════════════════════════════════════════
// 7x5 heatmap grid (weekday x focus area) + 28-day daily chart.
// Premium: full history + correlation tips.
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
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class EnergyMapScreen extends ConsumerWidget {
  const EnergyMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final energyAsync = ref.watch(energyMapProvider);

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
                  title: isEn ? 'Energy Profile' : 'Enerji Profili',
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: energyAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CosmicLoadingIndicator()),
                    ),
                    error: (e, s) => SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          isEn ? 'Could not load. Your local data is unaffected.' : 'Yüklenemedi. Yerel verileriniz etkilenmedi.',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                    ),
                    data: (data) {
                      if (data == null) {
                        return SliverToBoxAdapter(
                          child: _EmptyState(isDark: isDark, isEn: isEn),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          _SummaryHeader(
                            data: data,
                            isDark: isDark,
                            isEn: isEn,
                          ),
                          const SizedBox(height: 20),
                          _HeatmapGrid(data: data, isDark: isDark, isEn: isEn),
                          const SizedBox(height: 24),
                          _DailyChart(data: data, isDark: isDark, isEn: isEn),
                          const SizedBox(height: 24),
                          _InsightTips(data: data, isDark: isDark, isEn: isEn),
                          const SizedBox(height: 24),
                          ContentDisclaimer(language: language),
                          ToolEcosystemFooter(
                            currentToolId: 'energyMap',
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
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SUMMARY HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _SummaryHeader extends StatelessWidget {
  final EnergyMapData data;
  final bool isDark;
  final bool isEn;

  const _SummaryHeader({
    required this.data,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _StatChip(
            label: isEn ? 'Average' : 'Ortalama',
            value: data.overallAverage > 0
                ? data.overallAverage.toStringAsFixed(1)
                : '-',
            color: AppColors.auroraStart,
            isDark: isDark,
          ),
          const SizedBox(width: 12),
          _StatChip(
            label: isEn ? 'Best Day' : 'En İyi Gün',
            value: _dayLabel(data.bestDay, isEn),
            color: AppColors.success,
            isDark: isDark,
          ),
          const SizedBox(width: 12),
          _StatChip(
            label: isEn ? 'Strongest' : 'En Güçlü',
            value: data.strongestArea != null
                ? (isEn
                      ? data.strongestArea!.displayNameEn
                      : data.strongestArea!.displayNameTr)
                : '-',
            color: AppColors.starGold,
            isDark: isDark,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  String _dayLabel(int weekday, bool isEn) {
    final en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final tr = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return isEn ? en[weekday - 1] : tr[weekday - 1];
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEATMAP GRID (7 days x 5 areas)
// ═══════════════════════════════════════════════════════════════════════════

class _HeatmapGrid extends StatelessWidget {
  final EnergyMapData data;
  final bool isDark;
  final bool isEn;

  const _HeatmapGrid({
    required this.data,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final dayLabels = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Energy by Day & Area' : 'Gün ve Alana Göre Enerji',
            variant: GradientTextVariant.aurora,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Header row
          Row(
            children: [
              const SizedBox(width: 60),
              ...List.generate(
                7,
                (i) => Expanded(
                  child: Center(
                    child: Text(
                      dayLabels[i],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
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
          const SizedBox(height: 8),
          // Area rows
          ...FocusArea.values.map(
            (area) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      isEn ? area.displayNameEn : area.displayNameTr,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ...List.generate(7, (dayIdx) {
                    final cell = data.cells.firstWhere(
                      (c) => c.weekday == dayIdx + 1 && c.area == area,
                      orElse: () => HeatmapCell(
                        weekday: dayIdx + 1,
                        area: area,
                        averageRating: 0.0,
                        entryCount: 0,
                      ),
                    );
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _HeatCell(
                          intensity: cell.intensity,
                          isDark: isDark,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                isEn ? 'Low' : 'Düşük',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 4),
              ...List.generate(
                5,
                (i) => Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: _heatColor(i / 4, isDark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isEn ? 'High' : 'Yüksek',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  static Color _heatColor(double intensity, bool isDark) {
    if (intensity <= 0) {
      return isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.03);
    }
    return Color.lerp(
      AppColors.auroraStart.withValues(alpha: 0.2),
      AppColors.auroraStart,
      intensity,
    )!;
  }
}

class _HeatCell extends StatelessWidget {
  final double intensity;
  final bool isDark;

  const _HeatCell({required this.intensity, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: _HeatmapGrid._heatColor(intensity, isDark),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 28-DAY DAILY CHART
// ═══════════════════════════════════════════════════════════════════════════

class _DailyChart extends StatelessWidget {
  final EnergyMapData data;
  final bool isDark;
  final bool isEn;

  const _DailyChart({
    required this.data,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Last 28 Days' : 'Son 28 Gün',
            variant: GradientTextVariant.aurora,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.dailySnapshots.map((s) {
                final height = s.entryCount > 0
                    ? (s.averageRating / 5.0) * 50 + 4
                    : 2.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.5),
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        color: s.entryCount > 0
                            ? _barColor(s.averageRating)
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.03)),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEn ? '4 weeks ago' : '4 hafta önce',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              Text(
                isEn ? 'Today' : 'Bugün',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Color _barColor(double avg) {
    if (avg >= 4) return AppColors.success;
    if (avg >= 3) return AppColors.auroraStart;
    if (avg >= 2) return AppColors.warning;
    return AppColors.error;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INSIGHT TIPS
// ═══════════════════════════════════════════════════════════════════════════

class _InsightTips extends StatelessWidget {
  final EnergyMapData data;
  final bool isDark;
  final bool isEn;

  const _InsightTips({
    required this.data,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final tips = <String>[];

    if (data.strongestArea != null) {
      tips.add(
        isEn
            ? 'Your strongest area tends to be ${data.strongestArea!.displayNameEn}'
            : 'En güçlü alanın ${data.strongestArea!.displayNameTr} olma eğiliminde',
      );
    }

    final bestDayLabel = isEn
        ? _dayFullEn(data.bestDay)
        : _dayFullTr(data.bestDay);
    tips.add(
      isEn
          ? 'You tend to rate higher on ${bestDayLabel}s'
          : '$bestDayLabel günleri daha yüksek puanlama eğilimindesin',
    );

    if (data.overallAverage > 0) {
      tips.add(
        isEn
            ? 'Your overall average is ${data.overallAverage.toStringAsFixed(1)} out of 5'
            : 'Genel ortalamanız 5 üzerinden ${data.overallAverage.toStringAsFixed(1)}',
      );
    }

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: AppColors.starGold,
              ),
              const SizedBox(width: 8),
              GradientText(
                isEn ? 'Observations' : 'Gözlemler',
                variant: GradientTextVariant.gold,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: TextStyle(
                      color: AppColors.auroraStart,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTypography.decorativeScript(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 300.ms);
  }

  String _dayFullEn(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  String _dayFullTr(int weekday) {
    const days = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];
    return days[weekday - 1];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyState({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return PremiumEmptyState(
      icon: Icons.grid_view_rounded,
      title: isEn ? 'Nothing recorded yet' : 'Henüz kayıt yok',
      description: isEn
          ? 'Add at least 5 entries to see your energy map'
          : 'Enerji haritanı görmek için en az 5 kayıt ekle',
      gradientVariant: GradientTextVariant.aurora,
    );
  }
}
