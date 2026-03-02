// ════════════════════════════════════════════════════════════════════════════
// QUADRANT SELECTOR - 2×2 grid for choosing mood quadrant
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../data/content/signal_content.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/haptic_service.dart';

class QuadrantSelector extends StatelessWidget {
  final SignalQuadrant? selected;
  final ValueChanged<SignalQuadrant> onSelected;
  final AppLanguage language;
  final bool compact;

  const QuadrantSelector({
    super.key,
    this.selected,
    required this.onSelected,
    required this.language,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cellSize = compact ? 64.0 : 80.0;
    final spacing = compact ? 8.0 : 12.0;

    return SizedBox(
      width: cellSize * 2 + spacing,
      height: cellSize * 2 + spacing,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _QuadrantCell(
                quadrant: SignalQuadrant.fire,
                selected: selected == SignalQuadrant.fire,
                onTap: () => _select(SignalQuadrant.fire),
                size: cellSize,
                compact: compact,
                isDark: isDark,
                language: language,
              ),
              SizedBox(width: spacing),
              _QuadrantCell(
                quadrant: SignalQuadrant.water,
                selected: selected == SignalQuadrant.water,
                onTap: () => _select(SignalQuadrant.water),
                size: cellSize,
                compact: compact,
                isDark: isDark,
                language: language,
              ),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _QuadrantCell(
                quadrant: SignalQuadrant.storm,
                selected: selected == SignalQuadrant.storm,
                onTap: () => _select(SignalQuadrant.storm),
                size: cellSize,
                compact: compact,
                isDark: isDark,
                language: language,
              ),
              SizedBox(width: spacing),
              _QuadrantCell(
                quadrant: SignalQuadrant.shadow,
                selected: selected == SignalQuadrant.shadow,
                onTap: () => _select(SignalQuadrant.shadow),
                size: cellSize,
                compact: compact,
                isDark: isDark,
                language: language,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _select(SignalQuadrant q) {
    HapticService.selectionTap();
    onSelected(q);
  }
}

class _QuadrantCell extends StatelessWidget {
  final SignalQuadrant quadrant;
  final bool selected;
  final VoidCallback onTap;
  final double size;
  final bool compact;
  final bool isDark;
  final AppLanguage language;

  const _QuadrantCell({
    required this.quadrant,
    required this.selected,
    required this.onTap,
    required this.size,
    required this.compact,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final colors = quadrant.gradientColors;
    final surfaceColor = isDark ? AppColors.surfaceDark : AppColors.lightSurface;
    final borderColor = selected
        ? AppColors.starGold
        : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: surfaceColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.first.withValues(alpha: selected ? 0.25 : 0.12),
              colors.last.withValues(alpha: selected ? 0.15 : 0.06),
            ],
          ),
          border: Border.all(
            color: borderColor,
            width: selected ? 1.5 : 0.5,
          ),
          boxShadow: selected
              ? [BoxShadow(color: colors.first.withValues(alpha: 0.15), blurRadius: 12)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(quadrant.emoji, style: TextStyle(fontSize: compact ? 18 : 22)),
            if (!compact) ...[
              const SizedBox(height: 4),
              Text(
                quadrant.localizedName(language),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)
                      : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
