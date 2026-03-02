// ════════════════════════════════════════════════════════════════════════════
// SHARE NUDGE CHIP - Subtle contextual share prompt
// ════════════════════════════════════════════════════════════════════════════
// A small, non-intrusive chip that appears at high-engagement moments.
// Taps open the share card sheet with the appropriate template.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/haptic_service.dart';

class ShareNudgeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final Duration delay;

  const ShareNudgeChip({
    super.key,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.buttonPress();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AppColors.starGold.withValues(alpha: isDark ? 0.12 : 0.08),
              AppColors.celestialGold.withValues(alpha: isDark ? 0.06 : 0.04),
            ],
          ),
          border: Border.all(
            color: AppColors.starGold.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share_rounded,
              size: 12,
              color: AppColors.starGold,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.elegantAccent(
                fontSize: 11,
                color: AppColors.starGold,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay, duration: 400.ms).scale(
          begin: const Offset(0.9, 0.9),
          delay: delay,
          duration: 300.ms,
        );
  }
}
