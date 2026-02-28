import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';

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
    if (isEn) {
      if (count >= 100) return '$count entries — your story keeps growing';
      if (count >= 50) return '$count entries — half a hundred reflections';
      if (count >= 30) return '$count entries — a month of insight';
      if (count >= 14) return '$count entries — two weeks of reflection';
      if (count >= 7) return '$count entries — one week strong';
      if (count >= 3) return '$count entries — building a habit';
      return '$count entry — your journey begins';
    } else {
      if (count >= 100) return '$count kayıt — hikayen büyümeye devam ediyor';
      if (count >= 50) return '$count kayıt — elli yansıma';
      if (count >= 30) return '$count kayıt — bir aylık içgörü';
      if (count >= 14) return '$count kayıt — iki haftalık yansıma';
      if (count >= 7) return '$count kayıt — bir hafta güçlü';
      if (count >= 3) return '$count kayıt — alışkanlık oluşuyor';
      return '$count kayıt — yolculuğun başlıyor';
    }
  }
}
