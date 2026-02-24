import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import 'gradient_border.dart';
import 'gradient_text.dart';

/// A premium outlined button with gradient border and gradient text.
///
/// Replaces plain [OutlinedButton] with a gradient stroke border using
/// [GradientBorderPainter] and gradient-filled label via [ShaderMask].
class GradientOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final GradientTextVariant variant;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final bool expanded;

  const GradientOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = GradientTextVariant.aurora,
    this.borderRadius = 12,
    this.padding,
    this.fontSize,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = _getGradient(isDark);
    final isEnabled = onPressed != null;
    final effectiveAlpha = isEnabled ? 1.0 : 0.4;

    Widget child = GestureDetector(
      onTap: isEnabled
          ? () {
              HapticFeedback.lightImpact();
              onPressed!();
            }
          : null,
      child: Opacity(
        opacity: effectiveAlpha,
        child: GradientBorderContainer(
          gradient: gradient,
          strokeWidth: 1.5,
          borderRadius: borderRadius,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => gradient.createShader(bounds),
                  child: Icon(icon, size: fontSize != null ? fontSize! + 4 : 20),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => gradient.createShader(bounds),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize ?? 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return child;
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
          colors: [AppColors.amethyst, AppColors.cosmicAmethyst],
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
