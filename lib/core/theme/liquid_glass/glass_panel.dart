import 'dart:ui';
import 'package:flutter/material.dart';
import 'glass_tokens.dart';

/// Glass elevation levels matching the G1-G5 system
enum GlassElevation { g1, g2, g3, g4, g5 }

/// Frosted glass panel using BackdropFilter.
///
/// The core building block of the Liquid Glass design system.
/// Renders a translucent panel with configurable blur, opacity, and border glow.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final GlassElevation elevation;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? glowColor;
  final double? width;
  final double? height;

  const GlassPanel({
    super.key,
    required this.child,
    this.elevation = GlassElevation.g2,
    this.borderRadius,
    this.padding,
    this.margin,
    this.glowColor,
    this.width,
    this.height,
  });

  int get _level => elevation.index + 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blur = GlassTokens.blurForLevel(_level);
    final opacity = GlassTokens.opacityForLevel(_level);
    final borderOpacity = GlassTokens.borderOpacityForLevel(_level);
    final radius = borderRadius ?? BorderRadius.circular(GlassTokens.radiusLg);

    final surfaceColor = isDark
        ? Colors.white.withValues(alpha: opacity)
        : Colors.black.withValues(alpha: opacity * 0.5);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: borderOpacity)
        : Colors.black.withValues(alpha: borderOpacity * 0.5);

    final effectiveGlow =
        glowColor ?? (isDark ? GlassTokens.glowCosmic : Colors.transparent);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(GlassTokens.spaceLg),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: radius,
              border: Border.all(color: borderColor, width: 0.33),
              boxShadow: _level >= 3
                  ? [
                      BoxShadow(
                        color: effectiveGlow,
                        blurRadius: blur * 0.5,
                        spreadRadius: -2,
                      ),
                    ]
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
