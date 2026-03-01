import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final Gradient? gradient;
  final bool expanded;
  final Color? foregroundColor;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.gradient,
    this.expanded = false,
    this.foregroundColor,
  });

  /// Gold CTA variant — gold gradient with deep space text.
  const GradientButton.gold({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.expanded = false,
  }) : gradient = const LinearGradient(
         colors: [AppColors.starGold, AppColors.celestialGold],
       ),
       foregroundColor = AppColors.deepSpace;

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? Colors.white;
    final shadowColor = gradient != null
        ? (gradient as LinearGradient).colors.first
        : AppColors.auroraStart;

    return Semantics(
      label: label,
      button: true,
      enabled: onPressed != null && !isLoading,
      child: SizedBox(
        width: expanded ? double.infinity : width,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              decoration: BoxDecoration(
                gradient: onPressed == null
                    ? null
                    : (gradient ?? AppColors.primaryGradient),
                color: onPressed == null ? AppColors.surfaceLight : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: onPressed != null
                    ? [
                        BoxShadow(
                          color: shadowColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CupertinoActivityIndicator(),
                      )
                    else ...[
                      if (icon != null) ...[
                        Icon(icon, color: fg, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          style: AppTypography.modernAccent(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: fg,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
