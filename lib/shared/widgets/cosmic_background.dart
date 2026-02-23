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
// ABSTRACT DARK BACKGROUND - Soft gradient mesh + star field + floating orbs
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
      center: Offset(0.25, 0.2),
      radius: 120,
      color: AppColors.cosmicPurple,
      speed: 0.4,
      phase: 0,
      driftRadius: 30,
    ),
    _Orb(
      center: Offset(0.75, 0.35),
      radius: 100,
      color: AppColors.auroraStart,
      speed: 0.3,
      phase: 1.2,
      driftRadius: 25,
    ),
    _Orb(
      center: Offset(0.4, 0.65),
      radius: 140,
      color: AppColors.amethyst,
      speed: 0.25,
      phase: 2.5,
      driftRadius: 35,
    ),
    _Orb(
      center: Offset(0.8, 0.8),
      radius: 90,
      color: AppColors.starGold,
      speed: 0.35,
      phase: 3.8,
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
    final disableAnimations =
        MediaQuery.of(context).disableAnimations;

    return Stack(
      children: [
        // Static star field + gradient base
        RepaintBoundary(
          child: CustomPaint(
            painter: const _AbstractPainter(),
            willChange: false,
            isComplex: true,
          ),
        ),
        // Animated floating orbs (dark mode only)
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
          // Static orbs fallback for reduce-motion
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _OrbPainter(
                    orbs: _orbs,
                    progress: 0,
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

class _Orb {
  final Offset center; // normalized 0-1
  final double radius;
  final Color color;
  final double speed; // radians per full cycle
  final double phase; // starting angle
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
  final double progress; // 0-1

  const _OrbPainter({required this.orbs, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final angle = progress * 2 * pi;

    for (final orb in orbs) {
      final cx = orb.center.dx * size.width +
          cos(angle * orb.speed + orb.phase) * orb.driftRadius;
      final cy = orb.center.dy * size.height +
          sin(angle * orb.speed * 0.7 + orb.phase) * orb.driftRadius * 0.8;

      final gradient = ui.Gradient.radial(
        Offset(cx, cy),
        orb.radius,
        [
          orb.color.withValues(alpha: 0.12),
          orb.color.withValues(alpha: 0.05),
          orb.color.withValues(alpha: 0),
        ],
        [0.0, 0.5, 1.0],
      );

      canvas.drawCircle(
        Offset(cx, cy),
        orb.radius,
        Paint()
          ..shader = gradient
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      oldDelegate.progress != progress;
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

    // Layer 1: Tiny stars (~80)
    for (var i = 0; i < 80; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.6 + rng.nextDouble() * 1.0; // 0.6-1.6px
      final opacity = 0.15 + rng.nextDouble() * 0.25; // 0.15-0.40
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // Layer 2: Medium stars (~35)
    for (var i = 0; i < 35; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 1.5 + rng.nextDouble() * 1.5; // 1.5-3.0px
      final opacity = 0.25 + rng.nextDouble() * 0.30; // 0.25-0.55
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // Layer 3: Bright stars (~12) with halos
    for (var i = 0; i < 12; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 2.5 + rng.nextDouble() * 1.5; // 2.5-4.0px
      final opacity = 0.40 + rng.nextDouble() * 0.35; // 0.40-0.75
      final pos = Offset(x, y);

      // 3-4 bright stars get a color tint
      final isColored = i < 4;
      final baseColor =
          isColored ? coloredStarColors[i % coloredStarColors.length] : Colors.white;

      // Halo glow
      paint.color = baseColor.withValues(alpha: 0.12);
      canvas.drawCircle(pos, r * 3.5, paint);

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

    // 1. Soft radial color washes — premium watercolor-paper feel
    _drawSoftWash(canvas, Offset(size.width * 0.2, size.height * 0.12),
        size.width * 0.55, const Color(0xFFE8D5F5), 0.07);
    _drawSoftWash(canvas, Offset(size.width * 0.82, size.height * 0.45),
        size.width * 0.4, const Color(0xFFF5E6D0), 0.05);
    _drawSoftWash(canvas, Offset(size.width * 0.35, size.height * 0.78),
        size.width * 0.45, const Color(0xFFD5E5F5), 0.04);

    // 2. Fine noise grain texture
    for (var i = 0; i < 200; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.3 + rng.nextDouble() * 0.5;
      final opacity = 0.025 + rng.nextDouble() * 0.035;
      paint.color = Colors.black.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), r, paint);
    }

    // 3. Subtle dot grid with jitter — structured depth
    const spacing = 44.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final jitterX = (rng.nextDouble() - 0.5) * 8;
        final jitterY = (rng.nextDouble() - 0.5) * 8;
        final x = col * spacing + jitterX;
        final y = row * spacing + jitterY;
        final opacity = 0.03 + rng.nextDouble() * 0.025;
        paint.color = Colors.black.withValues(alpha: opacity);
        canvas.drawCircle(Offset(x, y), 0.7, paint);
      }
    }
  }

  void _drawSoftWash(
      Canvas canvas, Offset center, double radius, Color color, double opacity) {
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
