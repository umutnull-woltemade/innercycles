// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL FINGERPRINT PAINTER - Generative visual from user journal data
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Parameters computed from user data
class FingerprintData {
  final int dominantArea; // 0-4 (energy, focus, emotions, decisions, social)
  final double avgMood; // 0-5, determines warmth
  final int streakLength; // determines density
  final int journalHour; // 0-23, dominant hour

  const FingerprintData({
    this.dominantArea = 2,
    this.avgMood = 3.0,
    this.streakLength = 0,
    this.journalHour = 12,
  });
}

class EmotionalFingerprintPainter extends CustomPainter {
  final FingerprintData data;

  EmotionalFingerprintPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;
    final rng = math.Random(data.dominantArea * 1000 + data.avgMood.round() * 100 + data.streakLength);

    // Color warmth based on mood (low=cool brown, high=warm gold)
    final warmth = (data.avgMood / 5).clamp(0.0, 1.0);
    final baseColor = Color.lerp(
      const Color(0xFF8B6F5E), // cool brown
      AppColors.starGold, // warm gold
      warmth,
    )!;

    // Density based on streak
    final density = (data.streakLength.clamp(1, 30) / 30 * 12 + 4).round();

    // Shape based on dominant area
    switch (data.dominantArea) {
      case 0: // Energy — sunburst rays
        _drawSunburst(canvas, center, maxRadius, baseColor, density, rng);
        break;
      case 1: // Focus — concentric rings
        _drawConcentricRings(canvas, center, maxRadius, baseColor, density, rng);
        break;
      case 2: // Emotions — flowing waves
        _drawFlowingWaves(canvas, center, maxRadius, baseColor, density, rng);
        break;
      case 3: // Decisions — geometric facets
        _drawFacets(canvas, center, maxRadius, baseColor, density, rng);
        break;
      case 4: // Social — orbiting dots
        _drawOrbits(canvas, center, maxRadius, baseColor, density, rng);
        break;
    }
  }

  void _drawSunburst(Canvas canvas, Offset center, double radius, Color color, int rays, math.Random rng) {
    for (int i = 0; i < rays; i++) {
      final angle = (i / rays) * 2 * math.pi + rng.nextDouble() * 0.3;
      final rayLen = radius * (0.4 + rng.nextDouble() * 0.5);
      final width = 1.5 + rng.nextDouble() * 2;
      final opacity = 0.1 + rng.nextDouble() * 0.25;

      canvas.drawLine(
        center,
        Offset(center.dx + rayLen * math.cos(angle), center.dy + rayLen * math.sin(angle)),
        Paint()
          ..color = color.withValues(alpha: opacity)
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }
    // Central glow
    canvas.drawCircle(center, radius * 0.15, Paint()..color = color.withValues(alpha: 0.2));
  }

  void _drawConcentricRings(Canvas canvas, Offset center, double radius, Color color, int count, math.Random rng) {
    for (int i = 0; i < count; i++) {
      final r = radius * (0.1 + (i / count) * 0.85);
      final opacity = 0.08 + (1 - i / count) * 0.15;
      final offset = Offset(rng.nextDouble() * 3 - 1.5, rng.nextDouble() * 3 - 1.5);
      canvas.drawCircle(
        center + offset,
        r,
        Paint()
          ..color = color.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2 + rng.nextDouble(),
      );
    }
  }

  void _drawFlowingWaves(Canvas canvas, Offset center, double radius, Color color, int waves, math.Random rng) {
    for (int w = 0; w < waves; w++) {
      final path = Path();
      final y0 = center.dy - radius + (w / waves) * radius * 2;
      path.moveTo(center.dx - radius, y0);
      for (double x = -radius; x <= radius; x += 4) {
        final amp = 5 + rng.nextDouble() * 15;
        final freq = 0.03 + rng.nextDouble() * 0.04;
        final y = y0 + amp * math.sin((x + w * 20) * freq);
        path.lineTo(center.dx + x, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.08 + rng.nextDouble() * 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0 + rng.nextDouble()
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawFacets(Canvas canvas, Offset center, double radius, Color color, int count, math.Random rng) {
    for (int i = 0; i < count; i++) {
      final sides = 3 + rng.nextInt(3); // 3-5 sides
      final r = radius * (0.2 + rng.nextDouble() * 0.6);
      final cx = center.dx + (rng.nextDouble() - 0.5) * radius * 0.6;
      final cy = center.dy + (rng.nextDouble() - 0.5) * radius * 0.6;
      final startAngle = rng.nextDouble() * math.pi;

      final path = Path();
      for (int s = 0; s <= sides; s++) {
        final angle = startAngle + (s / sides) * 2 * math.pi;
        final x = cx + r * 0.4 * math.cos(angle);
        final y = cy + r * 0.4 * math.sin(angle);
        if (s == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.06 + rng.nextDouble() * 0.1)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.12)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }
  }

  void _drawOrbits(Canvas canvas, Offset center, double radius, Color color, int count, math.Random rng) {
    for (int i = 0; i < count; i++) {
      final orbitR = radius * (0.2 + rng.nextDouble() * 0.7);
      // Orbit ring
      canvas.drawCircle(
        center,
        orbitR,
        Paint()
          ..color = color.withValues(alpha: 0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
      // Dots on orbit
      final dots = 2 + rng.nextInt(4);
      for (int d = 0; d < dots; d++) {
        final angle = rng.nextDouble() * 2 * math.pi;
        final dotR = 2.0 + rng.nextDouble() * 3;
        canvas.drawCircle(
          Offset(center.dx + orbitR * math.cos(angle), center.dy + orbitR * math.sin(angle)),
          dotR,
          Paint()..color = color.withValues(alpha: 0.15 + rng.nextDouble() * 0.2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant EmotionalFingerprintPainter old) => old.data != data;
}
