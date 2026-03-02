// ════════════════════════════════════════════════════════════════════════════
// FOCUS AREA RADAR CARD - Spider chart for 5 life cycle dimensions
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/journal_entry.dart';
import 'premium_card.dart';
import 'radar_chart_painter.dart';

class FocusAreaRadarCard extends StatelessWidget {
  final Map<FocusArea, double> thisWeek;
  final Map<FocusArea, double> lastWeek;
  final bool isDark;
  final bool isEn;

  const FocusAreaRadarCard({
    super.key,
    required this.thisWeek,
    required this.lastWeek,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    // Need at least 3 areas with data this week
    if (thisWeek.length < 3) return const SizedBox.shrink();

    final areas = FocusArea.values;
    final currentValues = areas.map((a) => thisWeek[a] ?? 0.0).toList();
    final previousValues = lastWeek.length >= 3
        ? areas.map((a) => lastWeek[a] ?? 0.0).toList()
        : null;

    final labels = areas
        .map((a) => isEn ? a.displayNameEn : a.displayNameTr)
        .toList();

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pentagon_outlined,
                size: 16,
                color: AppColors.auroraStart,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEn ? 'Your Focus Radar' : 'Odak Radarın',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              if (previousValues != null)
                _LegendDot(
                  color: AppColors.starGold.withValues(alpha: 0.3),
                  label: isEn ? 'Last week' : 'Geçen hafta',
                  isDark: isDark,
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Radar chart
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: RadarChartPainter(
                      values: currentValues,
                      compareValues: previousValues,
                      fillColor: AppColors.starGold.withValues(alpha: 0.15),
                      strokeColor: AppColors.starGold,
                      compareFillColor: (isDark
                              ? Colors.white
                              : Colors.black)
                          .withValues(alpha: 0.04),
                      compareStrokeColor: (isDark
                              ? Colors.white
                              : Colors.black)
                          .withValues(alpha: 0.15),
                      gridColor: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.08),
                    ),
                  ),
                  // Axis labels
                  ...List.generate(areas.length, (i) {
                    final angle =
                        -math.pi / 2 + i * (2 * math.pi / areas.length);
                    const labelRadius = 108.0;
                    final dx = 100 + labelRadius * math.cos(angle);
                    final dy = 100 + labelRadius * math.sin(angle);
                    return Positioned(
                      left: dx - 30,
                      top: dy - 8,
                      child: SizedBox(
                        width: 60,
                        child: Text(
                          labels[i],
                          textAlign: TextAlign.center,
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
            ),
          ),
          const SizedBox(height: 12),
          // Summary row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: areas.map((a) {
              final val = thisWeek[a];
              if (val == null) return const SizedBox.shrink();
              return Column(
                children: [
                  Text(
                    val.toStringAsFixed(1),
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    isEn ? a.displayNameEn : a.displayNameTr,
                    style: AppTypography.elegantAccent(
                      fontSize: 9,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;

  const _LegendDot({
    required this.color,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 9,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}
