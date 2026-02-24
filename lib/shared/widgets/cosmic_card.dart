// ════════════════════════════════════════════════════════════════════════════
// COSMIC CARD — 3-tier card system with depth hierarchy
// ════════════════════════════════════════════════════════════════════════════
// flat     — subtle surface elevation (1px border, no shadow) — list items
// elevated — soft shadow + subtle gradient border — feature cards
// hero     — gradient border glow + deeper shadow + glass tint — primary CTA
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum CosmicCardTier { flat, elevated, hero }

class CosmicCard extends StatelessWidget {
  final Widget child;
  final CosmicCardTier tier;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? accentColor;

  const CosmicCard({
    super.key,
    required this.child,
    this.tier = CosmicCardTier.flat,
    this.padding,
    this.borderRadius = 16,
    this.accentColor,
  });

  const CosmicCard.flat({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.accentColor,
  }) : tier = CosmicCardTier.flat;

  const CosmicCard.elevated({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.accentColor,
  }) : tier = CosmicCardTier.elevated;

  const CosmicCard.hero({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.accentColor,
  }) : tier = CosmicCardTier.hero;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = accentColor ?? AppColors.amethyst;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: _backgroundColor(isDark),
        border: _border(isDark, accent),
        boxShadow: _shadows(isDark, accent),
        gradient: tier == CosmicCardTier.hero ? _heroGradient(isDark) : null,
      ),
      child: tier == CosmicCardTier.hero
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(16),
                  child: child,
                ),
              ),
            )
          : Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
    );
  }

  Color _backgroundColor(bool isDark) {
    switch (tier) {
      case CosmicCardTier.flat:
        return isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.7);
      case CosmicCardTier.elevated:
        return isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.85);
      case CosmicCardTier.hero:
        return Colors.transparent;
    }
  }

  LinearGradient? _heroGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              AppColors.cosmicPurple.withValues(alpha: 0.6),
              AppColors.deepSpace.withValues(alpha: 0.8),
            ]
          : [
              Colors.white.withValues(alpha: 0.9),
              AppColors.lightSurfaceVariant.withValues(alpha: 0.9),
            ],
    );
  }

  Border? _border(bool isDark, Color accent) {
    switch (tier) {
      case CosmicCardTier.flat:
        return Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
          width: 1,
        );
      case CosmicCardTier.elevated:
        return Border.all(
          color: isDark
              ? accent.withValues(alpha: 0.15)
              : accent.withValues(alpha: 0.1),
          width: 1,
        );
      case CosmicCardTier.hero:
        return Border.all(
          color: isDark
              ? accent.withValues(alpha: 0.35)
              : accent.withValues(alpha: 0.2),
          width: 1.5,
        );
    }
  }

  List<BoxShadow>? _shadows(bool isDark, Color accent) {
    switch (tier) {
      case CosmicCardTier.flat:
        return null;
      case CosmicCardTier.elevated:
        return [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
      case CosmicCardTier.hero:
        return [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 48,
            spreadRadius: 4,
          ),
        ];
    }
  }
}
