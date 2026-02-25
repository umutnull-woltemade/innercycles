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

    // Light mode - clean, soft gradient with subtle organic texture
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

    // Dark mode - flowing organic pattern
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
    _FlowingPattern.drawConcentric(canvas, size, layerCount: 3, opacity: 0.05);
    _FlowingPattern.drawFlowLines(canvas, size, lineCount: 8, opacity: 0.04);
    _FlowingPattern.drawBokeh(canvas, size, count: 15, opacity: 0.06);
  }

  @override
  bool shouldRepaint(covariant _WebPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// ABSTRACT DARK BACKGROUND - Gradient mesh + flowing pattern + floating orbs
// ═══════════════════════════════════════════════════════════════════════════
class _AbstractDarkBackground extends StatefulWidget {
  const _AbstractDarkBackground();

  @override
  State<_AbstractDarkBackground> createState() =>
      _AbstractDarkBackgroundState();
}

class _AbstractDarkBackgroundState extends State<_AbstractDarkBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _orbs = [
    _Orb(
      center: Offset(0.22, 0.18),
      radius: 140,
      color: Color(0xFFB695C0), // soft pastel lavender
      speed: 0.35,
      phase: 0,
      driftRadius: 35,
    ),
    _Orb(
      center: Offset(0.78, 0.32),
      radius: 120,
      color: Color(0xFF7EA8BE), // pastel steel blue
      speed: 0.3,
      phase: 1.2,
      driftRadius: 30,
    ),
    _Orb(
      center: Offset(0.38, 0.6),
      radius: 150,
      color: Color(0xFFD4A07A), // warm peach/apricot
      speed: 0.25,
      phase: 2.5,
      driftRadius: 40,
    ),
    _Orb(
      center: Offset(0.82, 0.78),
      radius: 110,
      color: Color(0xFFC9B8D8), // pale amethyst
      speed: 0.3,
      phase: 3.8,
      driftRadius: 25,
    ),
    _Orb(
      center: Offset(0.5, 0.42),
      radius: 100,
      color: AppColors.starGold,
      speed: 0.2,
      phase: 5.0,
      driftRadius: 20,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Stack(
      children: [
        // Static base: gradient + flowing pattern
        RepaintBoundary(
          child: CustomPaint(
            painter: const _AbstractPainter(),
            willChange: false,
            isComplex: true,
          ),
        ),
        // Animated floating orbs
        if (!disableAnimations)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _OrbPainter(
                      orbs: _orbs,
                      progress: _controller.value,
                    ),
                    willChange: true,
                  );
                },
              ),
            ),
          )
        else
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _OrbPainter(orbs: _orbs, progress: 0),
                  willChange: false,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Orb {
  final Offset center;
  final double radius;
  final Color color;
  final double speed;
  final double phase;
  final double driftRadius;

  const _Orb({
    required this.center,
    required this.radius,
    required this.color,
    required this.speed,
    required this.phase,
    required this.driftRadius,
  });
}

class _OrbPainter extends CustomPainter {
  final List<_Orb> orbs;
  final double progress;

  const _OrbPainter({required this.orbs, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final angle = progress * 2 * pi;

    for (final orb in orbs) {
      final cx =
          orb.center.dx * size.width +
          cos(angle * orb.speed + orb.phase) * orb.driftRadius;
      final cy =
          orb.center.dy * size.height +
          sin(angle * orb.speed * 0.7 + orb.phase) * orb.driftRadius * 0.8;

      final gradient = ui.Gradient.radial(
        Offset(cx, cy),
        orb.radius,
        [
          orb.color.withValues(alpha: 0.18),
          orb.color.withValues(alpha: 0.08),
          orb.color.withValues(alpha: 0),
        ],
        [0.0, 0.5, 1.0],
      );

      canvas.drawCircle(
        Offset(cx, cy),
        orb.radius,
        Paint()
          ..shader = gradient
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ═══════════════════════════════════════════════════════════════════════════
// ABSTRACT DARK PAINTER — Gradient + flowing organic pattern (no stars)
// ═══════════════════════════════════════════════════════════════════════════
class _AbstractPainter extends CustomPainter {
  const _AbstractPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _drawBaseGradient(canvas, size);
    _drawColorWashes(canvas, size);
    // Flowing organic pattern — visible & warm
    _FlowingPattern.drawConcentric(canvas, size, layerCount: 5, opacity: 0.06);
    _FlowingPattern.drawFlowLines(canvas, size, lineCount: 14, opacity: 0.045);
    _FlowingPattern.drawBokeh(canvas, size, count: 25, opacity: 0.07);
    _FlowingPattern.drawSacredDots(canvas, size, opacity: 0.055);
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
    // Warm pastel lavender wash — top left
    _drawWash(
      canvas,
      Offset(size.width * 0.25, size.height * 0.12),
      size.width * 0.55,
      const Color(0xFF8B6AAE), // soft lavender
      0.10,
    );
    // Warm rose gold wash — center right
    _drawWash(
      canvas,
      Offset(size.width * 0.78, size.height * 0.38),
      size.width * 0.45,
      const Color(0xFF7B5C6B), // dusty rose
      0.08,
    );
    // Warm amber wash — bottom
    _drawWash(
      canvas,
      Offset(size.width * 0.35, size.height * 0.72),
      size.width * 0.5,
      const Color(0xFF6B5B3E), // warm amber
      0.07,
    );
    // Soft teal accent — bottom right
    _drawWash(
      canvas,
      Offset(size.width * 0.7, size.height * 0.85),
      size.width * 0.35,
      const Color(0xFF3A6B6E), // sage teal
      0.06,
    );
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
// FLOWING PATTERN — Concentric arcs, flow lines, bokeh, sacred geometry
// Replaces star fields with organic, journal-appropriate visuals
// ═══════════════════════════════════════════════════════════════════════════
class _FlowingPattern {
  _FlowingPattern._();

  /// Concentric circular arcs — like ripples in still water
  static void drawConcentric(
    Canvas canvas,
    Size size, {
    int layerCount = 4,
    double opacity = 0.025,
  }) {
    final rng = Random(77);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Two focal points for ripple origins
    final centers = [
      Offset(size.width * 0.3, size.height * 0.2),
      Offset(size.width * 0.72, size.height * 0.6),
    ];

    for (final center in centers) {
      for (var i = 1; i <= layerCount; i++) {
        final radius = 60.0 + i * 65.0 + rng.nextDouble() * 20;
        final sweep = 1.2 + rng.nextDouble() * 1.8; // partial arc
        final startAngle = rng.nextDouble() * 2 * pi;
        final alpha = opacity * (1.0 - i * 0.15);

        paint
          ..color = Colors.white.withValues(alpha: alpha.clamp(0.01, 0.08))
          ..strokeWidth = 0.6 + rng.nextDouble() * 0.5;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          false,
          paint,
        );
      }
    }
  }

  /// Smooth flowing curves — like gentle breath or wind
  static void drawFlowLines(
    Canvas canvas,
    Size size, {
    int lineCount = 12,
    double opacity = 0.02,
  }) {
    final rng = Random(99);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < lineCount; i++) {
      final path = Path();
      final startY = size.height * (0.05 + rng.nextDouble() * 0.9);
      final startX = -20.0;

      path.moveTo(startX, startY);

      // 3 control-point bezier across the screen
      final cp1x = size.width * (0.15 + rng.nextDouble() * 0.2);
      final cp1y = startY + (rng.nextDouble() - 0.5) * size.height * 0.15;
      final cp2x = size.width * (0.55 + rng.nextDouble() * 0.2);
      final cp2y = startY + (rng.nextDouble() - 0.5) * size.height * 0.2;
      final endX = size.width + 20;
      final endY = startY + (rng.nextDouble() - 0.5) * size.height * 0.12;

      path.cubicTo(cp1x, cp1y, cp2x, cp2y, endX, endY);

      final alpha = opacity * (0.6 + rng.nextDouble() * 0.4);

      paint
        ..color = Colors.white.withValues(alpha: alpha.clamp(0.01, 0.06))
        ..strokeWidth = 0.4 + rng.nextDouble() * 0.6;

      canvas.drawPath(path, paint);
    }
  }

  /// Soft bokeh circles — like defocused light
  static void drawBokeh(
    Canvas canvas,
    Size size, {
    int count = 20,
    double opacity = 0.035,
  }) {
    final rng = Random(55);
    final paint = Paint()..style = PaintingStyle.stroke;

    const tints = [
      Color(0xFFB695C0), // pastel lavender
      Color(0xFF7EA8BE), // pastel blue
      Color(0xFFD4A07A), // warm peach
      AppColors.starGold,
      Color(0xFFE8B4B8), // rose gold
      Colors.white,
    ];

    for (var i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = 8.0 + rng.nextDouble() * 28.0;
      final tint = tints[i % tints.length];
      final alpha = opacity * (0.4 + rng.nextDouble() * 0.6);

      // Soft ring
      paint
        ..color = tint.withValues(alpha: alpha.clamp(0.015, 0.07))
        ..strokeWidth = 0.5 + rng.nextDouble() * 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);

      // Inner fill with lower opacity
      final fillPaint = Paint()
        ..color = tint.withValues(alpha: (alpha * 0.3).clamp(0.005, 0.025));
      canvas.drawCircle(Offset(x, y), radius, fillPaint);
    }
  }

  /// Sacred geometry dots — evenly spaced with subtle glow
  static void drawSacredDots(
    Canvas canvas,
    Size size, {
    double opacity = 0.03,
  }) {
    final rng = Random(33);
    final paint = Paint();
    const spacing = 52.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        // Hex-grid offset for organic feel
        final offsetX = (row % 2 == 0) ? 0.0 : spacing * 0.5;
        final x = col * spacing + offsetX + (rng.nextDouble() - 0.5) * 4;
        final y = row * spacing + (rng.nextDouble() - 0.5) * 4;
        final alpha = opacity * (0.3 + rng.nextDouble() * 0.7);

        paint.color = Colors.white.withValues(alpha: alpha.clamp(0.01, 0.05));
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LIGHT MODE PATTERN PAINTER — Soft organic texture
// ═══════════════════════════════════════════════════════════════════════════
class _LightPatternPainter extends CustomPainter {
  const _LightPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint();

    // 1. Soft radial color washes — watercolor-paper feel
    _drawSoftWash(
      canvas,
      Offset(size.width * 0.2, size.height * 0.12),
      size.width * 0.55,
      const Color(0xFFE8D5F5),
      0.07,
    );
    _drawSoftWash(
      canvas,
      Offset(size.width * 0.82, size.height * 0.45),
      size.width * 0.4,
      const Color(0xFFF5E6D0),
      0.05,
    );
    _drawSoftWash(
      canvas,
      Offset(size.width * 0.35, size.height * 0.78),
      size.width * 0.45,
      const Color(0xFFD5E5F5),
      0.04,
    );

    // 2. Fine noise grain texture
    for (var i = 0; i < 200; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.3 + rng.nextDouble() * 0.5;
      final opacity = 0.025 + rng.nextDouble() * 0.035;
      paint.color = Colors.black.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // 3. Flowing concentric arcs (light mode — very subtle)
    _drawLightArcs(canvas, size);

    // 4. Soft flow lines
    _drawLightFlowLines(canvas, size);

    // 5. Hex-grid sacred dots
    _drawLightDots(canvas, size);
  }

  void _drawLightArcs(Canvas canvas, Size size) {
    final rng = Random(77);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centers = [
      Offset(size.width * 0.25, size.height * 0.15),
      Offset(size.width * 0.78, size.height * 0.55),
    ];

    for (final center in centers) {
      for (var i = 1; i <= 3; i++) {
        final radius = 50.0 + i * 60.0 + rng.nextDouble() * 20;
        final sweep = 1.0 + rng.nextDouble() * 1.5;
        final startAngle = rng.nextDouble() * 2 * pi;

        paint
          ..color = Colors.black.withValues(
            alpha: 0.02 + rng.nextDouble() * 0.015,
          )
          ..strokeWidth = 0.4 + rng.nextDouble() * 0.3;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          false,
          paint,
        );
      }
    }
  }

  void _drawLightFlowLines(Canvas canvas, Size size) {
    final rng = Random(88);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 6; i++) {
      final path = Path();
      final startY = size.height * (0.1 + rng.nextDouble() * 0.8);
      path.moveTo(-10, startY);

      final cp1x = size.width * (0.2 + rng.nextDouble() * 0.15);
      final cp1y = startY + (rng.nextDouble() - 0.5) * size.height * 0.1;
      final cp2x = size.width * (0.6 + rng.nextDouble() * 0.15);
      final cp2y = startY + (rng.nextDouble() - 0.5) * size.height * 0.12;
      final endY = startY + (rng.nextDouble() - 0.5) * size.height * 0.08;

      path.cubicTo(cp1x, cp1y, cp2x, cp2y, size.width + 10, endY);

      paint
        ..color = Colors.black.withValues(
          alpha: 0.015 + rng.nextDouble() * 0.01,
        )
        ..strokeWidth = 0.3 + rng.nextDouble() * 0.3;

      canvas.drawPath(path, paint);
    }
  }

  void _drawLightDots(Canvas canvas, Size size) {
    final rng = Random(33);
    final paint = Paint();
    const spacing = 48.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final offsetX = (row % 2 == 0) ? 0.0 : spacing * 0.5;
        final x = col * spacing + offsetX + (rng.nextDouble() - 0.5) * 4;
        final y = row * spacing + (rng.nextDouble() - 0.5) * 4;
        final opacity = 0.02 + rng.nextDouble() * 0.02;
        paint.color = Colors.black.withValues(alpha: opacity);
        canvas.drawCircle(Offset(x, y), 0.6, paint);
      }
    }
  }

  void _drawSoftWash(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double opacity,
  ) {
    final gradient = ui.Gradient.radial(
      center,
      radius,
      [color.withValues(alpha: opacity), color.withValues(alpha: 0)],
      [0.0, 1.0],
    );
    canvas.drawCircle(center, radius, Paint()..shader = gradient);
  }

  @override
  bool shouldRepaint(covariant _LightPatternPainter oldDelegate) => false;
}
