// ════════════════════════════════════════════════════════════════════════════
// SYNC STATUS BANNER - Shows offline/syncing/error state on home feed
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/services/sync_service.dart';
import '../../../../shared/providers/sync_status_provider.dart';

class SyncStatusBanner extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const SyncStatusBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(syncStatusProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider);

    return statusAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (status) {
        // Only show for offline or error states (not idle/synced/syncing)
        if (status == SyncStatus.idle || status == SyncStatus.synced) {
          return const SizedBox.shrink();
        }

        // Brief syncing state — show only if there are pending items
        if (status == SyncStatus.syncing && pendingCount == 0) {
          return const SizedBox.shrink();
        }

        final isOffline = status == SyncStatus.offline;
        final isError = status == SyncStatus.error;
        final isSyncing = status == SyncStatus.syncing;

        final color = isError
            ? AppColors.warning
            : isOffline
                ? AppColors.textMuted
                : AppColors.auroraStart;

        final icon = isError
            ? Icons.sync_problem_rounded
            : isOffline
                ? Icons.cloud_off_rounded
                : Icons.sync_rounded;

        final message = isError
            ? (isEn ? 'Sync issue' : 'Senkron sorunu')
            : isOffline
                ? (isEn ? 'Offline' : 'Çevrimdışı')
                : (isEn ? 'Syncing...' : 'Senkronize ediliyor...');

        final detail = pendingCount > 0
            ? (isEn
                ? '$pendingCount change${pendingCount > 1 ? 's' : ''} pending'
                : '$pendingCount değişiklik bekliyor')
            : (isOffline
                ? (isEn
                    ? 'Changes saved locally'
                    : 'Değişiklikler yerel olarak kaydedildi')
                : null);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color.withValues(alpha: isDark ? 0.1 : 0.06),
              border: Border.all(
                color: color.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 14, color: color)
                    .animate(
                      onPlay: isSyncing ? (c) => c.repeat() : null,
                    )
                    .rotate(
                      duration: isSyncing ? 1200.ms : 0.ms,
                      begin: 0,
                      end: isSyncing ? 1 : 0,
                    ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: color,
                        ),
                      ),
                      if (detail != null)
                        Text(
                          detail,
                          style: AppTypography.subtitle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 300.ms);
      },
    );
  }
}
