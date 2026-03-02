// ════════════════════════════════════════════════════════════════════════════
// SPARKLINE CHART - Compact line chart for inline data visualization
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SparklineChart extends StatelessWidget {
  final List<double> data;
  final double minValue;
  final double maxValue;
  final Color lineColor;
  final Color? fillColor;
  final double strokeWidth;
  final double width;
  final double height;

  const SparklineChart({
    super.key,
    required this.data,
    this.minValue = 0,
    this.maxValue = 5,
    this.lineColor = const Color(0xFF7EB8A8),
    this.fillColor,
    this.strokeWidth = 2.0,
    this.width = 80,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) return SizedBox(width: width, height: height);

    return CustomPaint(
      size: Size(width, height),
      painter: _SparklinePainter(
        data: data,
        minValue: minValue,
        maxValue: maxValue,
        lineColor: lineColor,
        fillColor: fillColor ?? lineColor.withValues(alpha: 0.15),
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final double minValue;
  final double maxValue;
  final Color lineColor;
  final Color fillColor;
  final double strokeWidth;

  _SparklinePainter({
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.lineColor,
    required this.fillColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final range = maxValue - minValue;
    if (range <= 0) return;

    final points = <Offset>[];
    final step = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * step;
      final normalized = ((data[i] - minValue) / range).clamp(0.0, 1.0);
      final y = size.height - (normalized * size.height);
      points.add(Offset(x, y));
    }

    // Fill area under line
    final fillPath = Path()
      ..moveTo(0, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo(size.width, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, size.height),
        [fillColor, fillColor.withValues(alpha: 0)],
      );
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    // Draw dot at last point
    final dotPaint = Paint()..color = lineColor;
    canvas.drawCircle(points.last, strokeWidth + 1, dotPaint);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.data != data || old.lineColor != lineColor;
}
