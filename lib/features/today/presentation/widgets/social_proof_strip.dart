import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';

/// Personal milestone strip showing the user's own journaling progress.
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

    final message = _milestoneMessage(entryCount);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 14,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.6)
                : AppColors.lightTextMuted.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              message,
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

  /// Personal milestone message based on user's own entry count.
  String _milestoneMessage(int count) {
    final lang = isEn ? AppLanguage.en : AppLanguage.tr;
    final params = {'count': '$count'};
    String key;
    if (count >= 100) {
      key = 'today.social_proof.milestone_100';
    } else if (count >= 50) {
      key = 'today.social_proof.milestone_50';
    } else if (count >= 30) {
      key = 'today.social_proof.milestone_30';
    } else if (count >= 14) {
      key = 'today.social_proof.milestone_14';
    } else if (count >= 7) {
      key = 'today.social_proof.milestone_7';
    } else if (count >= 3) {
      key = 'today.social_proof.milestone_3';
    } else {
      key = 'today.social_proof.milestone_1';
    }
    return L10nService.getWithParams(key, lang, params: params);
  }
}
