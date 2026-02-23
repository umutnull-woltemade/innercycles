import 'dart:math';
import 'package:flutter/material.dart';

/// Procedural film grain texture overlay for glass surfaces.
///
/// Uses a seeded [CustomPainter] to draw ~2000 tiny dots at very low alpha,
/// producing a subtle noise/grain effect. Wrapped in [RepaintBoundary] +
/// [IgnorePointer] for zero performance cost.
class NoiseOverlay extends StatelessWidget {
  final double opacity;
  final Widget child;

  const NoiseOverlay({
    super.key,
    this.opacity = 0.03,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _NoisePainter(
                  opacity: opacity,
                  isDark: isDark,
                ),
                willChange: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoisePainter extends CustomPainter {
  final double opacity;
  final bool isDark;

  const _NoisePainter({
    required this.opacity,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint();
    final baseColor = isDark ? Colors.white : Colors.black;

    for (var i = 0; i < 2000; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.5 + rng.nextDouble() * 1.0; // 0.5-1.5px
      final alpha = 0.02 + rng.nextDouble() * 0.04; // 0.02-0.06
      paint.color = baseColor.withValues(alpha: alpha * (opacity / 0.03));
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.isDark != isDark;
}
