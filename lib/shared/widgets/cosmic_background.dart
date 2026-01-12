import 'package:flutter/material.dart';
import 'dart:math' as math;
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

    // Dark mode - cosmic background with stars
    return Container(
      decoration: BoxDecoration(
        gradient: showGradient
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.deepSpace,
                  AppColors.cosmicPurple,
                  AppColors.nebulaPurple,
                ],
              )
            : null,
        color: showGradient ? null : AppColors.deepSpace,
      ),
      child: Stack(
        children: [
          if (showStars) const StarField(),
          child,
        ],
      ),
    );
  }
}

class StarField extends StatelessWidget {
  const StarField({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarPainter(),
      size: Size.infinite,
    );
  }
}

class StarPainter extends CustomPainter {
  final math.Random _random = math.Random(42); // Fixed seed for consistency

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    // Draw small stars
    for (int i = 0; i < 100; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final opacity = 0.3 + _random.nextDouble() * 0.7;
      final radius = 0.5 + _random.nextDouble() * 1.5;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw a few larger, brighter stars
    for (int i = 0; i < 15; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final opacity = 0.6 + _random.nextDouble() * 0.4;
      final radius = 1.5 + _random.nextDouble() * 1.5;

      // Glow effect
      final glowPaint = Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(x, y), radius * 3, glowPaint);

      // Core
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
