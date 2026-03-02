// ════════════════════════════════════════════════════════════════════════════
// BOND MOOD ORB - 24px mood signal circle for partner display
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/signal_orb.dart';

class BondMoodOrb extends StatelessWidget {
  final String? signalId;
  final double size;

  const BondMoodOrb({
    super.key,
    this.signalId,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (signalId != null && signalId!.isNotEmpty) {
      return SignalOrb.inline(
        signalId: signalId,
        animate: false,
      );
    }

    // Fallback: grey dot when no mood data
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.35,
          height: size * 0.35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.4)
                : AppColors.lightTextMuted.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
