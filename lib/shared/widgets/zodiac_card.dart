import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/zodiac_sign.dart' as zodiac;

class ZodiacCard extends StatelessWidget {
  final zodiac.ZodiacSign sign;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showDetails;

  const ZodiacCard({
    super.key,
    required this.sign,
    this.isSelected = false,
    this.onTap,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    sign.color.withAlpha(76),
                    sign.color.withAlpha(25),
                  ]
                : [
                    AppColors.surfaceLight,
                    AppColors.surfaceDark,
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? sign.color : Colors.white.withAlpha(25),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: sign.color.withAlpha(76),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sign.symbol,
              style: TextStyle(
                fontSize: showDetails ? 48 : 32,
                color: isSelected ? sign.color : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sign.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? sign.color : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (showDetails) ...[
              const SizedBox(height: 4),
              Text(
                sign.dateRange,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 12),
              _ElementBadge(element: sign.element),
            ],
          ],
        ),
      ),
    );
  }
}

class _ElementBadge extends StatelessWidget {
  final zodiac.Element element;

  const _ElementBadge({required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: element.color.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: element.color.withAlpha(127),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            element.symbol,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            element.name,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: element.color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class ZodiacGridCard extends StatelessWidget {
  final zodiac.ZodiacSign sign;
  final VoidCallback? onTap;

  const ZodiacGridCard({
    super.key,
    required this.sign,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withAlpha(25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sign.color.withAlpha(38),
                shape: BoxShape.circle,
              ),
              child: Text(
                sign.symbol,
                style: TextStyle(
                  fontSize: 28,
                  color: sign.color,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sign.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              sign.dateRange,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.9, 0.9),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}
