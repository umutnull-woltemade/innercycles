import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'gradient_border.dart';
import 'noise_overlay.dart';

/// Visual style presets for [PremiumCard].
enum PremiumCardStyle { aurora, gold, amethyst, subtle }

/// A composite premium card that layers multiple visual effects for a
/// luxurious, Figma-level appearance:
///
/// 1. Outer + mid drop shadows
/// 2. Gradient stroke border
/// 3. Glass surface (BackdropFilter)
/// 4. Inner shadow highlight/depth
/// 5. Noise grain overlay
/// 6. Child content
class PremiumCard extends StatelessWidget {
  final Widget child;
  final PremiumCardStyle style;
  final bool showNoise;
  final bool showGradientBorder;
  final bool showInnerShadow;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const PremiumCard({
    super.key,
    required this.child,
    this.style = PremiumCardStyle.subtle,
    this.showNoise = true,
    this.showGradientBorder = true,
    this.showInnerShadow = true,
    this.padding,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getStyleColors(isDark);

    // Outer shadow container
    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          // Outer colored shadow
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          // Mid depth shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? colors.surface.withValues(alpha: 0.18)
                  : colors.surface.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                // Inner shadow
                if (showInnerShadow)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _InnerShadowPainter(
                            borderRadius: borderRadius,
                            isDark: isDark,
                          ),
                          willChange: false,
                        ),
                      ),
                    ),
                  ),

                // Noise grain
                if (showNoise)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _NoiseMicroPainter(isDark: isDark),
                          willChange: false,
                        ),
                      ),
                    ),
                  ),

                // Content
                Padding(
                  padding: padding ?? const EdgeInsets.all(16),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Gradient border wrapper
    if (showGradientBorder) {
      card = GradientBorderContainer(
        gradient: colors.gradient,
        strokeWidth: 1.0,
        borderRadius: borderRadius,
        child: card,
      );
    }

    return card;
  }

  _PremiumColors _getStyleColors(bool isDark) {
    switch (style) {
      case PremiumCardStyle.aurora:
        return _PremiumColors(
          accent: isDark ? AppColors.auroraStart : AppColors.lightAuroraStart,
          surface: isDark ? AppColors.surfaceDark : AppColors.lightCard,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.auroraStart, AppColors.auroraEnd]
                : [AppColors.lightAuroraStart, AppColors.lightAuroraEnd],
          ),
        );
      case PremiumCardStyle.gold:
        return _PremiumColors(
          accent: isDark ? AppColors.starGold : AppColors.lightStarGold,
          surface: isDark ? AppColors.surfaceDark : AppColors.lightCard,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.starGold, AppColors.celestialGold]
                : [AppColors.lightStarGold, AppColors.celestialGold],
          ),
        );
      case PremiumCardStyle.amethyst:
        return _PremiumColors(
          accent: AppColors.amethyst,
          surface: isDark ? AppColors.surfaceDark : AppColors.lightCard,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.amethyst, AppColors.cosmicAmethyst],
          ),
        );
      case PremiumCardStyle.subtle:
        return _PremiumColors(
          accent: isDark ? Colors.white : Colors.black,
          surface: isDark ? AppColors.surfaceDark : AppColors.lightCard,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.05),
                  ]
                : [
                    Colors.black.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.02),
                  ],
          ),
        );
    }
  }
}

class _PremiumColors {
  final Color accent;
  final Color surface;
  final LinearGradient gradient;

  const _PremiumColors({
    required this.accent,
    required this.surface,
    required this.gradient,
  });
}

/// Draws an inset shadow — dark at bottom for depth, light highlight at top.
class _InnerShadowPainter extends CustomPainter {
  final double borderRadius;
  final bool isDark;

  const _InnerShadowPainter({
    required this.borderRadius,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    canvas.save();
    canvas.clipRRect(rrect);

    // Top highlight
    final highlightPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.white)
          .withValues(alpha: isDark ? 0.06 : 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-2, -8, size.width + 4, 12),
        Radius.circular(borderRadius),
      ),
      highlightPaint,
    );

    // Bottom inner shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: isDark ? 0.08 : 0.04)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-2, size.height - 4, size.width + 4, 12),
        Radius.circular(borderRadius),
      ),
      shadowPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) =>
      oldDelegate.borderRadius != borderRadius ||
      oldDelegate.isDark != isDark;
}

/// Lightweight inline noise painter (fewer dots than full NoiseOverlay).
class _NoiseMicroPainter extends CustomPainter {
  final bool isDark;

  const _NoiseMicroPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = _SeedRandom(77);
    final paint = Paint();
    final baseColor = isDark ? Colors.white : Colors.black;
    final count = (size.width * size.height / 200).clamp(200, 1200).toInt();

    for (var i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.4 + rng.nextDouble() * 0.8;
      paint.color = baseColor.withValues(alpha: 0.015 + rng.nextDouble() * 0.025);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoiseMicroPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

/// Simple seeded pseudo-random for deterministic noise.
class _SeedRandom {
  int _seed;
  _SeedRandom(this._seed);

  double nextDouble() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed / 0x7fffffff;
  }
}
