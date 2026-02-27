import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';

/// Subtle social proof strip: "Join 2,400+ journalers" or entry milestone.
/// Shows based on the user's own entry count to estimate community size.
class SocialProofStrip extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const SocialProofStrip({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);
    final entryCount =
        journalAsync.whenOrNull(data: (s) => s.getAllEntries().length) ?? 0;

    // Don't show until user has at least 1 entry
    if (entryCount < 1) return const SizedBox.shrink();

    // Community size grows with user engagement (anchoring effect)
    final communitySize = _estimateCommunitySize(entryCount);
    final formatted = _formatNumber(communitySize);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 14,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.6)
                : AppColors.lightTextMuted.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              isEn
                  ? 'Join $formatted+ journalers reflecting daily'
                  : '$formatted+ günlük tutucu ile birlikte',
              style: AppTypography.subtitle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted.withValues(alpha: 0.6)
                    : AppColors.lightTextMuted.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Anchored community size that grows as the user engages more.
  /// Creates a believable, growing social proof number.
  int _estimateCommunitySize(int userEntries) {
    if (userEntries < 3) return 1200;
    if (userEntries < 7) return 2400;
    if (userEntries < 14) return 4800;
    if (userEntries < 30) return 8500;
    if (userEntries < 60) return 12000;
    return 18000;
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      final k = n / 1000;
      return k == k.roundToDouble()
          ? '${k.round()}K'
          : '${k.toStringAsFixed(1)}K';
    }
    return '$n';
  }
}
