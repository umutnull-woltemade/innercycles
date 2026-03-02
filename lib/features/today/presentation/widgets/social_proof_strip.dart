import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';

/// Cached count of users who journaled today, refreshed every 10 minutes.
final _todayActiveUsersProvider = FutureProvider.autoDispose<int>((ref) async {
  try {
    final client = Supabase.instance.client;
    final today = DateTime.now().toIso8601String().split('T').first;

    // Count distinct users who created a journal entry today
    final response = await client
        .from('journal_entries')
        .select('user_id')
        .gte('created_at', '${today}T00:00:00')
        .eq('is_deleted', false)
        .limit(10000);

    // Count unique user_ids
    final userIds = <String>{};
    for (final row in (response as List)) {
      final uid = row['user_id']?.toString();
      if (uid != null) userIds.add(uid);
    }
    return userIds.length;
  } catch (_) {
    return 0;
  }
});

/// Community social proof strip showing real aggregate data + personal milestone.
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

    final activeUsers = ref.watch(_todayActiveUsersProvider).valueOrNull ?? 0;
    final language = AppLanguage.fromIsEn(isEn);

    // Prefer real community data; fall back to personal milestone
    final message = activeUsers > 1
        ? _communityMessage(activeUsers, language)
        : _milestoneMessage(entryCount, language);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            activeUsers > 1
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

  /// Real community message with actual user count.
  String _communityMessage(int count, AppLanguage language) {
    if (language == AppLanguage.en) {
      return '$count people are journaling with InnerCycles today';
    }
    return 'Bugün $count kişi InnerCycles ile yazıyor';
  }

  /// Personal milestone message based on user's own entry count (fallback).
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
