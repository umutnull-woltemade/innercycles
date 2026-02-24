import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
export 'gradient_text.dart' show GradientTextVariant;
import 'gradient_text.dart';

/// A premium empty state widget with gradient icon backdrop, gradient title,
/// styled description, and optional gradient CTA button.
class PremiumEmptyState extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String title;
  final String description;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;
  final GradientTextVariant gradientVariant;
  final Color? accentColor;

  const PremiumEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconSize = 48,
    this.ctaLabel,
    this.onCtaPressed,
    this.gradientVariant = GradientTextVariant.aurora,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = accentColor ?? _accentForVariant(isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // Gradient circle backdrop + icon
          SizedBox(
            height: iconSize + 40,
            width: iconSize + 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: iconSize + 36,
                  height: iconSize + 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accent.withValues(alpha: 0.12),
                        accent.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
                Icon(
                  icon,
                  size: iconSize,
                  color: accent.withValues(alpha: 0.6),
                ),
              ],
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 20),

          // Gradient title
          GradientText(
            title,
            variant: gradientVariant,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

          const SizedBox(height: 10),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

          // CTA button
          if (ctaLabel != null && onCtaPressed != null) ...[
            const SizedBox(height: 24),
            _GradientCTA(
              label: ctaLabel!,
              onPressed: onCtaPressed!,
              accent: accent,
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(
                  begin: 0.1,
                  end: 0,
                  duration: 400.ms,
                ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Color _accentForVariant(bool isDark) {
    switch (gradientVariant) {
      case GradientTextVariant.aurora:
        return isDark ? AppColors.auroraStart : AppColors.lightAuroraStart;
      case GradientTextVariant.gold:
        return isDark ? AppColors.starGold : AppColors.lightStarGold;
      case GradientTextVariant.amethyst:
        return AppColors.amethyst;
      case GradientTextVariant.cosmic:
        return AppColors.cosmic;
    }
  }
}

class _GradientCTA extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color accent;

  const _GradientCTA({
    required this.label,
    required this.onPressed,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent, accent.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
