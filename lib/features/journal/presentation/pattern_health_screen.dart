// ════════════════════════════════════════════════════════════════════════════
// PATTERN HEALTH SCREEN - Per-dimension wellbeing deep dive
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/pattern_health_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class PatternHealthScreen extends ConsumerWidget {
  const PatternHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reportAsync = ref.watch(patternHealthReportProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: reportAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (report) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Pattern Health' : 'Kalıp Sağlığı',
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
                                ? 'How your focus areas are trending'
                                : 'Odak alanlarının nasıl bir eğilim gösterdiği',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overall status hero
                          _OverallHero(
                            status: report.overallHealth,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Dimension cards
                          GradientText(
                            isEn ? 'Dimensions' : 'Boyutlar',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...report.dimensionHealth.entries.map((e) =>
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _DimensionCard(
                                  dimension: e.value,
                                  isEn: isEn,
                                  isDark: isDark,
                                ),
                              )),

                          const SizedBox(height: 24),

                          // Alerts
                          if (report.alerts.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Active Alerts (${report.alerts.length})'
                                  : 'Aktif Uyarılar (${report.alerts.length})',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...report.alerts.map((alert) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _AlertTile(
                                    alert: alert,
                                    isEn: isEn,
                                    isDark: isDark,
                                  ),
                                )),
                            const SizedBox(height: 24),
                          ],

                          // Improvements
                          if (report.improvements.isNotEmpty) ...[
                            GradientText(
                              isEn ? 'Improvements' : 'İyileşmeler',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...report.improvements.map((text) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.trending_up_rounded,
                                          size: 14,
                                          color: AppColors.success),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          text,
                                          style: AppTypography.subtitle(
                                            fontSize: 13,
                                            color: isDark
                                                ? AppColors.textSecondary
                                                : AppColors
                                                    .lightTextSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],

                          const SizedBox(height: 16),

                          // Disclaimer
                          Center(
                            child: Text(
                              isEn
                                  ? 'Comparing last 30 days with previous 30 days'
                                  : 'Son 30 gün ile önceki 30 günü karşılaştırıyor',
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

Color _statusColor(HealthStatus status) {
  switch (status) {
    case HealthStatus.green:
      return AppColors.success;
    case HealthStatus.yellow:
      return AppColors.starGold;
    case HealthStatus.red:
      return AppColors.error;
  }
}

String _statusLabel(HealthStatus status, bool isEn) {
  switch (status) {
    case HealthStatus.green:
      return isEn ? 'Thriving' : 'Gelişiyor';
    case HealthStatus.yellow:
      return isEn ? 'Attention' : 'Dikkat';
    case HealthStatus.red:
      return isEn ? 'Needs Care' : 'Bakım Gerekli';
  }
}

IconData _statusIcon(HealthStatus status) {
  switch (status) {
    case HealthStatus.green:
      return Icons.check_circle_rounded;
    case HealthStatus.yellow:
      return Icons.warning_amber_rounded;
    case HealthStatus.red:
      return Icons.error_outline_rounded;
  }
}

class _OverallHero extends StatelessWidget {
  final HealthStatus status;
  final bool isEn;
  final bool isDark;

  const _OverallHero({
    required this.status,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(_statusIcon(status), size: 36, color: color),
            const SizedBox(height: 10),
            Text(
              _statusLabel(status, isEn),
              style: AppTypography.displayFont.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEn
                  ? 'Overall pattern health'
                  : 'Genel kalıp sağlığı',
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

class _DimensionCard extends StatelessWidget {
  final DimensionHealth dimension;
  final bool isEn;
  final bool isDark;

  const _DimensionCard({
    required this.dimension,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(dimension.status);
    final areaName = isEn
        ? dimension.area.displayNameEn
        : dimension.area.displayNameTr;
    final change = dimension.changePercent;
    final isUp = change >= 0;

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
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (isUp ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 12,
                      color:
                          isUp ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isUp ? '+' : ''}${change.toStringAsFixed(0)}%',
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: isUp
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Current vs previous bars
          Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  isEn ? 'Now' : 'Şimdi',
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (dimension.currentAvg / 5.0).clamp(0.0, 1.0),
                    backgroundColor:
                        (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 28,
                child: Text(
                  dimension.currentAvg.toStringAsFixed(1),
                  textAlign: TextAlign.end,
                  style: AppTypography.modernAccent(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  isEn ? 'Before' : 'Önce',
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value:
                        (dimension.previousAvg / 5.0).clamp(0.0, 1.0),
                    backgroundColor:
                        (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(
                        color.withValues(alpha: 0.4)),
                    minHeight: 5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 28,
                child: Text(
                  dimension.previousAvg.toStringAsFixed(1),
                  textAlign: TextAlign.end,
                  style: AppTypography.elegantAccent(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final HealthAlert alert;
  final bool isEn;
  final bool isDark;

  const _AlertTile({
    required this.alert,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(alert.severity);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(_statusIcon(alert.severity), size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEn ? alert.titleEn : alert.titleTr,
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
