import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CosmicBackground extends StatelessWidget {
  final Widget child;
  final bool showStars;
  final bool showGradient;

  const CosmicBackground({
    super.key,
    required this.child,
    this.showStars = true,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode - clean, soft gradient with subtle dot texture
    if (!isDark) {
      return Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: showGradient
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.lightBackground,
                          AppColors.lightSurfaceVariant,
                        ],
                      )
                    : null,
                color: showGradient ? null : AppColors.lightBackground,
              ),
            ),
          ),
          if (showStars)
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: const _LightPatternPainter(),
                    willChange: false,
                  ),
                ),
              ),
            ),
          child,
        ],
      );
    }

    // Dark mode - abstract gradient background
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: kIsWeb
                ? const _SimplifiedWebBackground()
                : const _AbstractDarkBackground(),
          ),
        ),
        child,
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SIMPLIFIED WEB BACKGROUND
// ═══════════════════════════════════════════════════════════════════════════
class _SimplifiedWebBackground extends StatelessWidget {
  const _SimplifiedWebBackground();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: const _WebPainter(),
        willChange: false,
        isComplex: true,
      ),
    );
  }
}

class _WebPainter extends CustomPainter {
  const _WebPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = ui.Gradient.linear(
      Offset.zero,
      Offset(size.width, size.height),
      const [
        AppColors.deepSpace,
        AppColors.cosmicPurple,
        AppColors.nebulaPurple,
        Color(0xFF0F0F1A),
      ],
      const [0.0, 0.3, 0.7, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient);

    // Star field
    _drawStarField(canvas, size);
  }

  void _drawStarField(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint();

    // Tiny stars — 40 for web
    for (var i = 0; i < 40; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.5 + rng.nextDouble() * 0.7;
      final opacity = 0.08 + rng.nextDouble() * 0.12;
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // Medium stars — 15 for web
    for (var i = 0; i < 15; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 1.5 + rng.nextDouble() * 1.0;
      final opacity = 0.15 + rng.nextDouble() * 0.20;
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // Bright stars — 5 for web
    for (var i = 0; i < 5; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 2.5 + rng.nextDouble() * 1.0;
      final opacity = 0.25 + rng.nextDouble() * 0.25;
      final pos = Offset(x, y);

      // Halo
      paint.color = Colors.white.withValues(alpha: 0.06);
      canvas.drawCircle(pos, r * 3, paint);

      // Core
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(pos, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WebPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// ABSTRACT DARK BACKGROUND - Soft gradient mesh + star field
// ═══════════════════════════════════════════════════════════════════════════
class _AbstractDarkBackground extends StatelessWidget {
  const _AbstractDarkBackground();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: const _AbstractPainter(),
        willChange: false,
        isComplex: true,
      ),
    );
  }
}

class _AbstractPainter extends CustomPainter {
  const _AbstractPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Deep gradient base
    _drawBaseGradient(canvas, size);

    // 2. Soft organic color washes (subtle, not nebula-like)
    _drawColorWashes(canvas, size);

    // 3. Star field
    _drawStarField(canvas, size);
  }

  void _drawBaseGradient(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = ui.Gradient.linear(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.8, size.height),
      [
        AppColors.deepSpace,
        AppColors.cosmicPurple,
        const Color(0xFF141428),
        AppColors.nebulaPurple,
        const Color(0xFF0F0F1A),
      ],
      [0.0, 0.25, 0.5, 0.75, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient);
  }

  void _drawColorWashes(Canvas canvas, Size size) {
    // Subtle warm wash — top area
    _drawWash(
      canvas,
      Offset(size.width * 0.3, size.height * 0.15),
      size.width * 0.5,
      const Color(0xFF6C3483),
      0.06,
    );

    // Cool wash — center-right
    _drawWash(
      canvas,
      Offset(size.width * 0.75, size.height * 0.45),
      size.width * 0.4,
      const Color(0xFF2E4057),
      0.05,
    );

    // Soft accent wash — bottom-left
    _drawWash(
      canvas,
      Offset(size.width * 0.2, size.height * 0.75),
      size.width * 0.45,
      const Color(0xFF1A3A5C),
      0.04,
    );
  }

  void _drawStarField(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint();

    // Colored star colors for bright layer
    const coloredStarColors = [
      AppColors.auroraStart,
      AppColors.starGold,
      AppColors.auroraStart,
    ];

    // Layer 1: Tiny stars (~60)
    for (var i = 0; i < 60; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.5 + rng.nextDouble() * 0.7; // 0.5-1.2px
      final opacity = 0.08 + rng.nextDouble() * 0.12; // 0.08-0.20
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // Layer 2: Medium stars (~25)
    for (var i = 0; i < 25; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 1.5 + rng.nextDouble() * 1.0; // 1.5-2.5px
      final opacity = 0.15 + rng.nextDouble() * 0.20; // 0.15-0.35
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // Layer 3: Bright stars (~8) with halos
    for (var i = 0; i < 8; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 2.5 + rng.nextDouble() * 1.0; // 2.5-3.5px
      final opacity = 0.25 + rng.nextDouble() * 0.25; // 0.25-0.50
      final pos = Offset(x, y);

      // 2-3 bright stars get a color tint
      final isColored = i < 3;
      final baseColor =
          isColored ? coloredStarColors[i] : Colors.white;

      // Halo glow
      paint.color = baseColor.withValues(alpha: 0.06);
      canvas.drawCircle(pos, r * 3, paint);

      // Core
      paint.color = baseColor.withValues(alpha: opacity);
      canvas.drawCircle(pos, r, paint);
    }
  }

  void _drawWash(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double opacity,
  ) {
    final gradient = ui.Gradient.radial(
      center,
      radius,
      [
        color.withValues(alpha: opacity),
        color.withValues(alpha: opacity * 0.4),
        color.withValues(alpha: 0),
      ],
      [0.0, 0.5, 1.0],
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = gradient
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60),
    );
  }

  @override
  bool shouldRepaint(covariant _AbstractPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// LIGHT MODE PATTERN PAINTER - Subtle dot texture
// ═══════════════════════════════════════════════════════════════════════════
class _LightPatternPainter extends CustomPainter {
  const _LightPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint();

    // ~30 small subtle dots in grey tones
    for (var i = 0; i < 30; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.8 + rng.nextDouble() * 1.0; // 0.8-1.8px
      final opacity = 0.03 + rng.nextDouble() * 0.03; // 0.03-0.06
      final grey = 0.3 + rng.nextDouble() * 0.3; // 0.3-0.6 grey value
      paint.color = Color.fromRGBO(
        (grey * 255).round(),
        (grey * 255).round(),
        (grey * 255).round(),
        opacity,
      );
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LightPatternPainter oldDelegate) => false;
}
