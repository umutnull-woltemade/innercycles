// ════════════════════════════════════════════════════════════════════════════
// CYCLE SUMMARY CARD - Focus Area Cycle Info Widget
// ════════════════════════════════════════════════════════════════════════════
// Displays one focus area's cycle information with:
// - Mini wave icon
// - Cycle length in days
// - Current phase badge
// - Trend indicator (improving/stable/declining)
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/emotional_cycle_service.dart';
import 'cycle_wave_painter.dart';

class CycleSummaryCard extends StatelessWidget {
  final FocusAreaCycleSummary summary;
  final bool isDark;
  final bool isEn;

  const CycleSummaryCard({
    super.key,
    required this.summary,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final color = kAreaColors[summary.area] ?? AppColors.auroraStart;
    final hasData = summary.rawPoints.isNotEmpty;
    final areaName =
        isEn ? summary.area.displayNameEn : summary.area.displayNameTr;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: area name + mini wave
          Row(
            children: [
              // Color indicator
              Container(
                width: 4,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      areaName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (hasData)
                      Text(
                        isEn ? summary.getSummaryEn() : summary.getSummaryTr(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                  ],
                ),
              ),
              // Mini wave icon
              SizedBox(
                width: 48,
                height: 24,
                child: CustomPaint(
                  painter: _MiniWavePainter(color: color, hasData: hasData),
                ),
              ),
            ],
          ),

          if (hasData) ...[
            const SizedBox(height: AppConstants.spacingMd),

            // Stats row
            Row(
              children: [
                // Cycle length
                if (summary.cycleLengthDays != null)
                  _buildStatChip(
                    context,
                    icon: Icons.waves,
                    label:
                        '~${summary.cycleLengthDays}${isEn ? 'd' : 'g'}',
                    color: color,
                  ),

                if (summary.cycleLengthDays != null)
                  const SizedBox(width: AppConstants.spacingSm),

                // Current phase
                if (summary.currentPhase != null)
                  _buildPhaseBadge(context, summary.currentPhase!, color),

                const Spacer(),

                // Trend indicator
                _buildTrendIndicator(context, summary.trend),
              ],
            ),

            const SizedBox(height: AppConstants.spacingSm),

            // Current average bar
            Row(
              children: [
                Text(
                  isEn ? 'Current avg' : 'Ort.',
                  style: TextStyle(
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
                      value: summary.currentAverage / 5.0,
                      backgroundColor: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.3)
                          : AppColors.lightSurfaceVariant,
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  summary.currentAverage.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ],

          if (!hasData)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.spacingSm),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    size: 16,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isEn
                        ? 'No entries yet for $areaName'
                        : '$areaName için henüz kayıt yok',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseBadge(
    BuildContext context,
    CyclePhase phase,
    Color areaColor,
  ) {
    final phaseColor = _phaseColor(phase);
    final phaseIcon = _phaseIcon(phase);
    final phaseLabel = isEn ? phase.labelEn() : phase.labelTr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: phaseColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(
          color: phaseColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(phaseIcon, size: 12, color: phaseColor),
          const SizedBox(width: 4),
          Text(
            phaseLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: phaseColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(BuildContext context, CycleTrend trend) {
    final trendColor = _trendColor(trend);
    final trendIcon = _trendIcon(trend);
    final trendLabel = isEn ? trend.labelEn() : trend.labelTr();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(trendIcon, size: 14, color: trendColor),
        const SizedBox(width: 3),
        Text(
          trendLabel,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: trendColor,
          ),
        ),
      ],
    );
  }

  Color _phaseColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.rising:
        return AppColors.success;
      case CyclePhase.peak:
        return AppColors.starGold;
      case CyclePhase.falling:
        return AppColors.warning;
      case CyclePhase.valley:
        return AppColors.auroraStart;
    }
  }

  IconData _phaseIcon(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.rising:
        return Icons.trending_up;
      case CyclePhase.peak:
        return Icons.wb_sunny_outlined;
      case CyclePhase.falling:
        return Icons.trending_down;
      case CyclePhase.valley:
        return Icons.nightlight_round;
    }
  }

  Color _trendColor(CycleTrend trend) {
    switch (trend) {
      case CycleTrend.improving:
        return AppColors.success;
      case CycleTrend.stable:
        return isDark ? AppColors.textMuted : AppColors.lightTextMuted;
      case CycleTrend.declining:
        return AppColors.error;
    }
  }

  IconData _trendIcon(CycleTrend trend) {
    switch (trend) {
      case CycleTrend.improving:
        return Icons.arrow_upward;
      case CycleTrend.stable:
        return Icons.remove;
      case CycleTrend.declining:
        return Icons.arrow_downward;
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MINI WAVE PAINTER
// ════════════════════════════════════════════════════════════════════════════

class _MiniWavePainter extends CustomPainter {
  final Color color;
  final bool hasData;

  _MiniWavePainter({required this.color, required this.hasData});

  @override
  void paint(Canvas canvas, Size size) {
    if (!hasData) {
      // Draw flat dashed line
      final paint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      const dashWidth = 3.0;
      const dashSpace = 3.0;
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(
          Offset(x, size.height / 2),
          Offset((x + dashWidth).clamp(0, size.width), size.height / 2),
          paint,
        );
        x += dashWidth + dashSpace;
      }
      return;
    }

    // Draw a decorative sine wave
    final path = Path();
    final midY = size.height / 2;
    final amplitude = size.height * 0.35;

    path.moveTo(0, midY);
    for (double x = 0; x <= size.width; x += 1) {
      final normalizedX = x / size.width;
      final y = midY - amplitude * math.sin(normalizedX * math.pi * 2.5);
      path.lineTo(x, y);
    }

    // Glow
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // Line
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniWavePainter old) {
    return old.color != color || old.hasData != hasData;
  }
}
