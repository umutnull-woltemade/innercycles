import '../services/sync_service.dart';

/// Mixin providing write-through sync for any service backed by Supabase.
/// Services that use this mixin queue operations after local persistence,
/// and SyncService handles pushing them to Supabase when online.
mixin SupabaseSyncMixin {
  /// The Supabase table name this service syncs to.
  String get tableName;

  /// Queue a sync operation (UPSERT, UPDATE, DELETE) for a record.
  Future<void> queueSync(
    String operation,
    String recordId,
    Map<String, dynamic> payload,
  ) {
    return SyncService.queueOperation(
      tableName: tableName,
      operation: operation,
      recordId: recordId,
      payload: payload,
    );
  }

  /// Queue a soft-delete (sets is_deleted = true remotely).
  Future<void> queueSoftDelete(String recordId) {
    return queueSync('UPDATE', recordId, {'id': recordId, 'is_deleted': true});
  }
}
