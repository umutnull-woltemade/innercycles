// ════════════════════════════════════════════════════════════════════════════
// RADAR CHART PAINTER - 5-axis spider/polygon visualization
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';

class RadarChartPainter extends CustomPainter {
  final List<double> values; // 0-5 scale, one per axis
  final List<double>? compareValues; // optional overlay
  final Color fillColor;
  final Color strokeColor;
  final Color? compareFillColor;
  final Color? compareStrokeColor;
  final Color gridColor;
  final double maxValue;

  RadarChartPainter({
    required this.values,
    this.compareValues,
    required this.fillColor,
    required this.strokeColor,
    this.compareFillColor,
    this.compareStrokeColor,
    required this.gridColor,
    this.maxValue = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final sides = values.length;
    if (sides < 3) return;

    final angleStep = (2 * math.pi) / sides;
    final startAngle = -math.pi / 2; // top

    // Draw grid rings (1-5)
    for (int ring = 1; ring <= 5; ring++) {
      final ringRadius = radius * (ring / 5);
      final ringPath = Path();
      for (int i = 0; i <= sides; i++) {
        final angle = startAngle + (i % sides) * angleStep;
        final x = center.dx + ringRadius * math.cos(angle);
        final y = center.dy + ringRadius * math.sin(angle);
        if (i == 0) {
          ringPath.moveTo(x, y);
        } else {
          ringPath.lineTo(x, y);
        }
      }
      ringPath.close();
      canvas.drawPath(
        ringPath,
        Paint()
          ..color = gridColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
    }

    // Draw axis lines
    for (int i = 0; i < sides; i++) {
      final angle = startAngle + i * angleStep;
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(
        center,
        end,
        Paint()
          ..color = gridColor
          ..strokeWidth = 0.5,
      );
    }

    // Draw compare polygon (if exists, behind primary)
    if (compareValues != null && compareValues!.length == sides) {
      _drawPolygon(
        canvas,
        center,
        radius,
        sides,
        angleStep,
        startAngle,
        compareValues!,
        compareFillColor ?? fillColor.withValues(alpha: 0.08),
        compareStrokeColor ?? strokeColor.withValues(alpha: 0.3),
      );
    }

    // Draw primary polygon
    _drawPolygon(
      canvas,
      center,
      radius,
      sides,
      angleStep,
      startAngle,
      values,
      fillColor,
      strokeColor,
    );

    // Draw dots on primary polygon vertices
    for (int i = 0; i < sides; i++) {
      final v = (values[i] / maxValue).clamp(0.0, 1.0);
      final angle = startAngle + i * angleStep;
      final x = center.dx + radius * v * math.cos(angle);
      final y = center.dy + radius * v * math.sin(angle);
      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = strokeColor,
      );
    }
  }

  void _drawPolygon(
    Canvas canvas,
    Offset center,
    double radius,
    int sides,
    double angleStep,
    double startAngle,
    List<double> vals,
    Color fill,
    Color stroke,
  ) {
    final path = Path();
    for (int i = 0; i <= sides; i++) {
      final v = (vals[i % sides] / maxValue).clamp(0.0, 1.0);
      final angle = startAngle + (i % sides) * angleStep;
      final x = center.dx + radius * v * math.cos(angle);
      final y = center.dy + radius * v * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.compareValues != compareValues;
}
