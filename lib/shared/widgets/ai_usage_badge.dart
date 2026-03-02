// ════════════════════════════════════════════════════════════════════════════
// AI USAGE BADGE - Shows free-tier AI usage progress (e.g., "1/2 this week")
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AIUsageBadge extends StatelessWidget {
  final int used;
  final int limit;
  final bool isDark;

  const AIUsageBadge({
    super.key,
    required this.used,
    required this.limit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (limit - used).clamp(0, limit);
    final isExhausted = remaining == 0;
    final color = isExhausted ? AppColors.warning : AppColors.amethyst;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: isDark ? 0.12 : 0.08),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$used/$limit',
            style: AppTypography.elegantAccent(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
