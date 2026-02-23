import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Gradient style variants for [GradientText].
enum GradientTextVariant { aurora, gold, amethyst, cosmic }

/// Renders text with a gradient fill using [ShaderMask].
///
/// Provides four preset gradient variants (aurora, gold, amethyst, cosmic)
/// with automatic light/dark mode adaptation.
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final GradientTextVariant variant;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.variant = GradientTextVariant.aurora,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = _getGradient(isDark);

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  LinearGradient _getGradient(bool isDark) {
    switch (variant) {
      case GradientTextVariant.aurora:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.auroraStart, AppColors.auroraEnd]
              : [AppColors.lightAuroraStart, AppColors.lightAuroraEnd],
        );
      case GradientTextVariant.gold:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.starGold, AppColors.celestialGold]
              : [AppColors.lightStarGold, AppColors.celestialGold],
        );
      case GradientTextVariant.amethyst:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.amethyst, AppColors.cosmicAmethyst]
              : [AppColors.amethyst, AppColors.cosmicAmethyst],
        );
      case GradientTextVariant.cosmic:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.cosmic, AppColors.auroraEnd]
              : [AppColors.lightAuroraStart, AppColors.lightAuroraEnd],
        );
    }
  }
}
