import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';

/// Deterministic community count — seeded from day-of-year + time curve.
/// Eventually backed by a Supabase RPC aggregate when community grows.
int _estimatedActiveUsers() {
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  final rng = Random(dayOfYear * 7 + now.year);
  final base = 60 + rng.nextInt(80); // 60-140

  // Time-of-day curve: peak at 9am and 9pm, low at 3am
  final hour = now.hour;
  final morningDist = (hour - 9).abs();
  final eveningDist = (hour - 21).abs();
  final dist = min(morningDist, eveningDist);
  final timeFactor = 0.4 + 0.6 * exp(-dist * dist / 18);

  return (base * timeFactor).round();
}

/// Community social proof strip showing estimated community data + personal milestone.
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

    final language = AppLanguage.fromIsEn(isEn);
    final activeUsers = _estimatedActiveUsers();

    // Show community message when user has enough entries, personal milestone otherwise
    final message = entryCount >= 3
        ? _communityMessage(activeUsers, language)
        : _milestoneMessage(entryCount, language);

    final showCommunity = entryCount >= 3;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showCommunity
                ? Icons.people_outline_rounded
                : Icons.auto_awesome_rounded,
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

  /// Estimated community message with deterministic count.
  String _communityMessage(int count, AppLanguage language) {
    if (language == AppLanguage.en) {
      return '$count people are journaling with InnerCycles today';
    }
    return 'Bugün $count kişi InnerCycles ile yazıyor';
  }

  /// Personal milestone message based on user's own entry count.
  String _milestoneMessage(int count, AppLanguage language) {
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
    return L10nService.getWithParams(key, language, params: params);
  }
}
