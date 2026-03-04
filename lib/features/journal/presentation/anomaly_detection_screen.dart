// ════════════════════════════════════════════════════════════════════════════
// ANOMALY DETECTION SCREEN - Focus area deviations & day-of-week patterns
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/pattern_engine_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class AnomalyDetectionScreen extends ConsumerWidget {
  const AnomalyDetectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final engineAsync = ref.watch(patternEngineServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: engineAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Something went wrong', style: TextStyle(color: Color(0xFF9E8E82)))),
            data: (engine) {
              if (!engine.hasEnoughData()) {
                return _InsufficientData(
                  needed: engine.entriesNeeded(),
                  isEn: isEn,
                  isDark: isDark,
                );
              }

              final anomalies = engine.detectAnomalies();
              final dayAverages = engine.getDayOfWeekAverages();
              final trends = engine.detectTrends();

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Anomaly Radar'
                        : 'Anomali Radarı',
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
                                ? 'Deviations from your usual baseline'
                                : 'Normal seviyenden sapmalar',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Status hero
                          _StatusHero(
                            anomalyCount: anomalies.length,
                            trendCount: trends.length,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Active anomalies
                          if (anomalies.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Active Anomalies (${anomalies.length})'
                                  : 'Aktif Anomaliler (${anomalies.length})',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...anomalies.map(
                                (a) => Padding(
                                      padding:
                                          const EdgeInsets.only(
                                              bottom: 10),
                                      child: _AnomalyCard(
                                        anomaly: a,
                                        isEn: isEn,
                                        isDark: isDark,
                                      ),
                                    )),
                            const SizedBox(height: 24),
                          ] else ...[
                            _NoAnomalies(isEn: isEn, isDark: isDark),
                            const SizedBox(height: 24),
                          ],

                          // Trends
                          if (trends.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Weekly Trends'
                                  : 'Haftalık Eğilimler',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...trends.map(
                                (t) => Padding(
                                      padding:
                                          const EdgeInsets.only(
                                              bottom: 8),
                                      child: _TrendRow(
                                        trend: t,
                                        isEn: isEn,
                                        isDark: isDark,
                                      ),
                                    )),
                            const SizedBox(height: 24),
                          ],

                          // Day-of-week averages
                          if (dayAverages.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Day-of-Week Patterns'
                                  : 'Hafta Günü Kalıpları',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _DayOfWeekChart(
                              averages: dayAverages,
                              isEn: isEn,
                              isDark: isDark,
                            ),
                          ],

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? 'Comparing last 3 days with 30-day baseline'
                                  : 'Son 3 günü 30 günlük baz çizgiyle karşılaştırıyor',
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

class _StatusHero extends StatelessWidget {
  final int anomalyCount;
  final int trendCount;
  final bool isEn;
  final bool isDark;

  const _StatusHero({
    required this.anomalyCount,
    required this.trendCount,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnomalies = anomalyCount > 0;
    final statusColor =
        hasAnomalies ? AppColors.starGold : AppColors.success;
    final statusIcon = hasAnomalies
        ? Icons.warning_amber_rounded
        : Icons.check_circle_rounded;
    final statusLabel = hasAnomalies
        ? (isEn
            ? '$anomalyCount area${anomalyCount > 1 ? 's' : ''} deviating'
            : '$anomalyCount alan sapıyor')
        : (isEn ? 'All areas stable' : 'Tüm alanlar stabil');

    return PremiumCard(
      style: hasAnomalies
          ? PremiumCardStyle.gold
          : PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(statusIcon, size: 36, color: statusColor),
            const SizedBox(height: 10),
            Text(
              statusLabel,
              style: AppTypography.displayFont.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEn
                  ? '$trendCount trends detected'
                  : '$trendCount eğilim tespit edildi',
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
    );
  }
}

class _AnomalyCard extends StatelessWidget {
  final AnomalyInsight anomaly;
  final bool isEn;
  final bool isDark;

  const _AnomalyCard({
    required this.anomaly,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = _focusAreaColor(anomaly.area);
    final isDrop = anomaly.isDrop;
    final deviationColor = isDrop ? AppColors.error : AppColors.success;
    final areaName = isEn
        ? anomaly.area.displayNameEn
        : anomaly.area.displayNameTr;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: deviationColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: deviationColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  areaName,
                  style: AppTypography.modernAccent(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Icon(
                isDrop
                    ? Icons.trending_down_rounded
                    : Icons.trending_up_rounded,
                size: 18,
                color: deviationColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${isDrop ? '' : '+'}${anomaly.deviationPercent.toStringAsFixed(0)}%',
                style: AppTypography.modernAccent(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: deviationColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Baseline vs Recent comparison
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      isEn ? '30-Day Baseline' : '30 Gün Baz',
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      anomaly.baseline30Day.toStringAsFixed(1),
                      style: AppTypography.modernAccent(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: color.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.2),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      isEn ? 'Last 3 Days' : 'Son 3 Gün',
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      anomaly.recent3Day.toStringAsFixed(1),
                      style: AppTypography.modernAccent(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: deviationColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Insight text
          Text(
            isEn
                ? anomaly.getMessageEn()
                : anomaly.getMessageTr(),
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

class _NoAnomalies extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _NoAnomalies({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 20, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEn
                  ? 'No significant deviations detected. Your focus areas are within normal range.'
                  : 'Önemli bir sapma tespit edilmedi. Odak alanların normal aralıkta.',
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

class _TrendRow extends StatelessWidget {
  final TrendInsight trend;
  final bool isEn;
  final bool isDark;

  const _TrendRow({
    required this.trend,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = _focusAreaColor(trend.area);
    final isUp = trend.direction == TrendDirection.up;
    final isDown = trend.direction == TrendDirection.down;
    final dirColor = isUp
        ? AppColors.success
        : isDown
            ? AppColors.error
            : AppColors.textMuted;

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            isEn
                ? trend.area.displayNameEn
                : trend.area.displayNameTr,
            style: AppTypography.modernAccent(
              fontSize: 12,
              color: color,
            ),
          ),
        ),
        Icon(
          isUp
              ? Icons.trending_up_rounded
              : isDown
                  ? Icons.trending_down_rounded
                  : Icons.trending_flat_rounded,
          size: 16,
          color: dirColor,
        ),
        const SizedBox(width: 6),
        Text(
          '${trend.changePercent >= 0 ? '+' : ''}${trend.changePercent.toStringAsFixed(0)}%',
          style: AppTypography.modernAccent(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: dirColor,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            isEn
                ? trend.getMessageEn()
                : trend.getMessageTr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTypography.elegantAccent(
              fontSize: 10,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ),
      ],
    );
  }
}

const _dayLabelsEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _dayLabelsTr = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

class _DayOfWeekChart extends StatelessWidget {
  final Map<int, double> averages;
  final bool isEn;
  final bool isDark;

  const _DayOfWeekChart({
    required this.averages,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final labels = isEn ? _dayLabelsEn : _dayLabelsTr;
    final maxVal = averages.values.fold<double>(
        0, (max, v) => v > max ? v : max);
    final bestDay = averages.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          final day = i + 1; // 1=Mon to 7=Sun
          final avg = averages[day] ?? 0;
          final height = maxVal > 0 ? (avg / 5.0) * 60 : 0.0;
          final isBest = day == bestDay;

          return Column(
            children: [
              SizedBox(
                height: 60,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 24,
                    height: height.clamp(4.0, 60.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isBest
                          ? AppColors.starGold
                          : AppColors.amethyst
                              .withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: isBest
                      ? AppColors.starGold
                      : isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                ),
              ),
              Text(
                avg > 0 ? avg.toStringAsFixed(1) : '-',
                style: AppTypography.modernAccent(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isBest
                      ? AppColors.starGold
                      : isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _InsufficientData extends StatelessWidget {
  final int needed;
  final bool isEn;
  final bool isDark;

  const _InsufficientData({
    required this.needed,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Anomaly Radar' : 'Anomali Radarı',
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
                      const Text('\u{1F4E1}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? '$needed more entries needed to detect anomalies'
                            : 'Anomalileri tespit etmek için $needed kayıt daha gerekli',
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
