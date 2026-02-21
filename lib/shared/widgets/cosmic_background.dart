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

    // Light mode - clean, soft gradient background
    if (!isDark) {
      return Container(
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
        child: child,
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.deepSpace,
            AppColors.cosmicPurple,
            AppColors.nebulaPurple,
            Color(0xFF0F0F1A),
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ABSTRACT DARK BACKGROUND - Soft gradient mesh, no stars/nebula
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

  void _drawWash(Canvas canvas, Offset center, double radius, Color color, double opacity) {
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
// LEGACY WIDGETS - Compatibility
// ═══════════════════════════════════════════════════════════════════════════

class StarField extends StatelessWidget {
  const StarField({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AbstractDarkBackground();
  }
}

class StaticStarField extends StatelessWidget {
  const StaticStarField({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AbstractDarkBackground();
  }
}

class GlowingOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double blurRadius;

  const GlowingOrb({
    super.key,
    required this.color,
    this.size = 200,
    this.blurRadius = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: blurRadius,
            spreadRadius: blurRadius / 2,
          ),
        ],
      ),
    );
  }
}
