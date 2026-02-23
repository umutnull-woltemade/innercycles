import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/sync_service.dart';

/// Provides a stream of the current sync status (syncing/synced/error/offline).
final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  return SyncService.statusStream;
});

/// Provides the number of pending (un-synced) operations in the queue.
final pendingSyncCountProvider = Provider<int>((ref) {
  // Re-evaluate whenever sync status changes
  ref.watch(syncStatusProvider);
  return SyncService.pendingCount;
});
