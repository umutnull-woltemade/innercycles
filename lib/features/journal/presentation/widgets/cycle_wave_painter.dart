// ════════════════════════════════════════════════════════════════════════════
// CYCLE WAVE PAINTER - Smooth Wave Curves with Gradient Fill
// ════════════════════════════════════════════════════════════════════════════
// CustomPainter that draws smooth wave curves for emotional cycle data.
// Features:
// - Catmull-Rom spline interpolation for smooth curves
// - Gradient fill under each curve
// - Touch interaction to inspect data points
// - Animated entrance via progress parameter
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../data/services/emotional_cycle_service.dart';

/// Color palette for each focus area dimension
const Map<FocusArea, Color> kAreaColors = {
  FocusArea.energy: Color(0xFFFF6B6B), // Warm coral red
  FocusArea.focus: Color(0xFF4ECDC4), // Teal cyan
  FocusArea.emotions: AppColors.chartPurple, // Soft purple
  FocusArea.decisions: Color(0xFFFFD93D), // Warm gold
  FocusArea.social: Color(0xFF6BCB77), // Fresh green
};

/// Secondary gradient color for each area (lighter)
const Map<FocusArea, Color> kAreaGradientEnd = {
  FocusArea.energy: Color(0xFFFF9A9E),
  FocusArea.focus: Color(0xFFA8EDEA),
  FocusArea.emotions: Color(0xFFF3E5F5),
  FocusArea.decisions: Color(0xFFFFF9C4),
  FocusArea.social: Color(0xFFC8E6C9),
};

/// Interactive wave chart widget with touch support and animation
class CycleWaveChart extends StatefulWidget {
  final Map<FocusArea, List<CycleDataPoint>> areaData;
  final Set<FocusArea> visibleAreas;
  final bool isDark;
  final bool isEn;
  final int displayDays;
  final double animationProgress;
  final ValueChanged<CycleDataPointInfo?>? onPointSelected;

  const CycleWaveChart({
    super.key,
    required this.areaData,
    required this.visibleAreas,
    required this.isDark,
    this.isEn = true,
    required this.displayDays,
    this.animationProgress = 1.0,
    this.onPointSelected,
  });

  @override
  State<CycleWaveChart> createState() => _CycleWaveChartState();
}

class _CycleWaveChartState extends State<CycleWaveChart> {
  CycleDataPointInfo? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _handleTap(details.localPosition),
      onPanUpdate: (details) => _handleTap(details.localPosition),
      onPanEnd: (_) => _clearSelection(),
      onTapUp: (_) {
        // Keep selection visible briefly
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _clearSelection();
        });
      },
      child: Semantics(
        label: widget.isEn
            ? 'Emotional cycle wave chart'
            : 'Duygusal döngü dalga grafiği',
        image: true,
        child: RepaintBoundary(
          child: CustomPaint(
            size: const Size(double.infinity, 240),
            painter: _CycleWavePainterImpl(
              data: widget.areaData,
              visibleAreas: widget.visibleAreas,
              isDark: widget.isDark,
              displayDays: widget.displayDays,
              progress: widget.animationProgress,
              selectedPoint: _selectedPoint,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(Offset position) {
    final now = DateTime.now();
    final rangeStart = now.subtract(Duration(days: widget.displayDays));
    final totalMs = now.difference(rangeStart).inMilliseconds.toDouble();
    if (totalMs <= 0) return;

    const leftPadding = 28.0;
    const rightPadding = 12.0;
    const topPadding = 12.0;
    const bottomPadding = 24.0;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Find the closest data point
    CycleDataPointInfo? closest;
    double closestDist = 30.0; // Maximum tap distance in pixels

    for (final area in widget.visibleAreas) {
      final points = widget.areaData[area];
      if (points == null) continue;

      for (final point in points) {
        final dx =
            leftPadding +
            (point.date.difference(rangeStart).inMilliseconds / totalMs) *
                chartWidth;
        final dy =
            topPadding + chartHeight - ((point.value - 1) / 4) * chartHeight;

        final dist = (Offset(dx, dy) - position).distance;
        if (dist < closestDist) {
          closestDist = dist;
          closest = CycleDataPointInfo(
            area: area,
            date: point.date,
            value: point.value,
            canvasX: dx,
            canvasY: dy,
          );
        }
      }
    }

    setState(() {
      _selectedPoint = closest;
    });
    widget.onPointSelected?.call(closest);
  }

  void _clearSelection() {
    if (mounted) {
      setState(() {
        _selectedPoint = null;
      });
      widget.onPointSelected?.call(null);
    }
  }
}

/// Info about a selected data point (for tooltip display)
class CycleDataPointInfo {
  final FocusArea area;
  final DateTime date;
  final double value;
  final double canvasX;
  final double canvasY;

  const CycleDataPointInfo({
    required this.area,
    required this.date,
    required this.value,
    required this.canvasX,
    required this.canvasY,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// PAINTER IMPLEMENTATION
// ════════════════════════════════════════════════════════════════════════════

class _CycleWavePainterImpl extends CustomPainter {
  final Map<FocusArea, List<CycleDataPoint>> data;
  final Set<FocusArea> visibleAreas;
  final bool isDark;
  final int displayDays;
  final double progress;
  final CycleDataPointInfo? selectedPoint;

  _CycleWavePainterImpl({
    required this.data,
    required this.visibleAreas,
    required this.isDark,
    required this.displayDays,
    required this.progress,
    this.selectedPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    final rangeStart = now.subtract(Duration(days: displayDays));
    final totalMs = now.difference(rangeStart).inMilliseconds.toDouble();
    if (totalMs <= 0) return;

    const leftPadding = 28.0;
    const rightPadding = 12.0;
    const topPadding = 12.0;
    const bottomPadding = 24.0;
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Draw grid
    _drawGrid(canvas, size, leftPadding, topPadding, chartWidth, chartHeight);

    // Draw each visible area
    for (final area in FocusArea.values) {
      if (!visibleAreas.contains(area)) continue;

      final points = data[area];
      if (points == null || points.isEmpty) continue;

      final color = kAreaColors[area] ?? Colors.white;
      final gradientEnd =
          kAreaGradientEnd[area] ?? color.withValues(alpha: 0.1);

      // Convert to canvas coordinates
      final canvasPoints = <Offset>[];
      for (final point in points) {
        final dx =
            leftPadding +
            (point.date.difference(rangeStart).inMilliseconds / totalMs) *
                chartWidth;
        final dy =
            topPadding + chartHeight - ((point.value - 1) / 4) * chartHeight;
        canvasPoints.add(
          Offset(
            dx.clamp(leftPadding, leftPadding + chartWidth),
            dy.clamp(topPadding, topPadding + chartHeight),
          ),
        );
      }

      if (canvasPoints.isEmpty) continue;

      if (canvasPoints.length == 1) {
        // Single point: draw a glowing dot
        _drawGlowDot(canvas, canvasPoints.first, color);
        continue;
      }

      // Build smooth path
      final path = _buildCatmullRomPath(canvasPoints);

      // Apply animation progress (clip horizontally)
      final clipRight = leftPadding + chartWidth * progress;
      canvas.save();
      canvas.clipRect(Rect.fromLTRB(0, 0, clipRight, size.height));

      // Draw gradient fill under the curve
      _drawGradientFill(
        canvas,
        path,
        canvasPoints,
        color,
        gradientEnd,
        topPadding,
        topPadding + chartHeight,
      );

      // Draw the curve line with glow
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
        ..isAntiAlias = true;
      canvas.drawPath(path, glowPaint);

      final linePaint = Paint()
        ..color = color.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true;
      canvas.drawPath(path, linePaint);

      // Draw data point dots
      for (final pt in canvasPoints) {
        canvas.drawCircle(pt, 3.5, Paint()..color = color);
        canvas.drawCircle(pt, 1.5, Paint()..color = Colors.white);
      }

      canvas.restore();
    }

    // Draw selected point tooltip
    if (selectedPoint != null) {
      _drawTooltip(canvas, size, selectedPoint!);
    }
  }

  void _drawGrid(
    Canvas canvas,
    Size size,
    double leftPadding,
    double topPadding,
    double chartWidth,
    double chartHeight,
  ) {
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int rating = 1; rating <= 5; rating++) {
      final y = topPadding + chartHeight - ((rating - 1) / 4) * chartHeight;

      // Draw dashed grid line
      const dashWidth = 4.0;
      const dashSpace = 4.0;
      double startX = leftPadding;
      while (startX < leftPadding + chartWidth) {
        canvas.drawLine(
          Offset(startX, y),
          Offset((startX + dashWidth).clamp(0, leftPadding + chartWidth), y),
          gridPaint,
        );
        startX += dashWidth + dashSpace;
      }

      // Label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: '$rating',
          style: AppTypography.modernAccent(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.3,
            ),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(canvas, Offset(6, y - labelPainter.height / 2));
    }
  }

  void _drawGradientFill(
    Canvas canvas,
    Path curvePath,
    List<Offset> points,
    Color color,
    Color gradientEnd,
    double topY,
    double bottomY,
  ) {
    // Create a closed path for the fill
    final fillPath = Path.from(curvePath);
    fillPath.lineTo(points.last.dx, bottomY);
    fillPath.lineTo(points.first.dx, bottomY);
    fillPath.close();

    final gradient = ui.Gradient.linear(
      Offset(0, topY),
      Offset(0, bottomY),
      [
        color.withValues(alpha: 0.25),
        gradientEnd.withValues(alpha: 0.05),
        color.withValues(alpha: 0.0),
      ],
      [0.0, 0.6, 1.0],
    );

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = gradient
        ..style = PaintingStyle.fill,
    );
  }

  void _drawGlowDot(Canvas canvas, Offset center, Color color) {
    // Outer glow
    canvas.drawCircle(
      center,
      8,
      Paint()
        ..color = color.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Main dot
    canvas.drawCircle(center, 4, Paint()..color = color);
    canvas.drawCircle(center, 2, Paint()..color = Colors.white);
  }

  void _drawTooltip(Canvas canvas, Size size, CycleDataPointInfo point) {
    final color = kAreaColors[point.area] ?? Colors.white;

    // Draw highlight circle
    canvas.drawCircle(
      Offset(point.canvasX, point.canvasY),
      10,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(
      Offset(point.canvasX, point.canvasY),
      5,
      Paint()..color = color,
    );
    canvas.drawCircle(
      Offset(point.canvasX, point.canvasY),
      2.5,
      Paint()..color = Colors.white,
    );

    // Tooltip text
    final dateStr = '${point.date.day}/${point.date.month}';
    final valueStr = point.value.toStringAsFixed(1);
    final text = '$dateStr: $valueStr';

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTypography.modernAccent(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Tooltip background
    final tooltipWidth = textPainter.width + 16;
    final tooltipHeight = textPainter.height + 10;
    var tooltipX = point.canvasX - tooltipWidth / 2;
    final tooltipY = point.canvasY - tooltipHeight - 14;

    // Clamp within canvas
    tooltipX = tooltipX.clamp(4, size.width - tooltipWidth - 4);
    final clampedY = tooltipY.clamp(4.0, size.height - tooltipHeight - 4);

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX, clampedY, tooltipWidth, tooltipHeight),
      const Radius.circular(6),
    );

    // Shadow
    canvas.drawRRect(
      tooltipRect.shift(const Offset(0, 2)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Background
    canvas.drawRRect(
      tooltipRect,
      Paint()
        ..color = isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
    );

    // Border
    canvas.drawRRect(
      tooltipRect,
      Paint()
        ..color = color.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    textPainter.paint(canvas, Offset(tooltipX + 8, clampedY + 5));
  }

  /// Build a smooth Catmull-Rom spline path through points
  Path _buildCatmullRomPath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;

    path.moveTo(points.first.dx, points.first.dy);

    if (points.length == 2) {
      path.lineTo(points[1].dx, points[1].dy);
      return path;
    }

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < points.length ? points[i + 2] : p2;

      // Catmull-Rom to Bezier control points with tension
      const tension = 0.3;
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) * tension,
        p1.dy + (p2.dy - p0.dy) * tension,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) * tension,
        p2.dy - (p3.dy - p1.dy) * tension,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _CycleWavePainterImpl old) {
    return old.visibleAreas != visibleAreas ||
        old.data != data ||
        old.isDark != isDark ||
        old.progress != progress ||
        old.selectedPoint != selectedPoint;
  }
}
