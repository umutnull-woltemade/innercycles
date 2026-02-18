import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Offline-first sync service for Supabase
/// Queues operations when offline and syncs when connectivity is restored
class SyncService {
  static const String _syncQueueBoxName = 'sync_queue_box';
  static Box? _syncBox;
  static bool _isSyncing = false;

  /// Initialize the sync service
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Web doesn't use Hive for sync queue (session-only)
      if (kDebugMode) {
        debugPrint('SyncService: Web mode - sync queue disabled');
      }
      return;
    }

    try {
      _syncBox = await Hive.openBox(_syncQueueBoxName);

      // Listen for connectivity changes
      Connectivity().onConnectivityChanged.listen((
        List<ConnectivityResult> result,
      ) {
        if (!result.contains(ConnectivityResult.none)) {
          syncPendingOperations();
        }
      });

      // Try initial sync
      syncPendingOperations();

      if (kDebugMode) {
        debugPrint(
          'SyncService: Initialized with ${_syncBox?.length ?? 0} pending operations',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Initialization error: $e');
      }
    }
  }

  /// Check if device is online
  static Future<bool> get _isOnline async {
    try {
      final result = await Connectivity().checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  /// Sync all pending operations
  static Future<SyncResult> syncPendingOperations() async {
    if (_isSyncing) {
      return SyncResult(
        synced: 0,
        failed: 0,
        message: 'Sync already in progress',
      );
    }

    final box = _syncBox;
    if (kIsWeb || box == null) {
      return SyncResult(synced: 0, failed: 0, message: 'Sync not available');
    }

    if (!await _isOnline) {
      return SyncResult(synced: 0, failed: 0, message: 'Offline');
    }

    _isSyncing = true;
    int synced = 0;
    int failed = 0;

    try {
      final keys = box.keys.toList();

      for (final key in keys) {
        final json = box.get(key) as String?;
        if (json == null) continue;

        try {
          final item = SyncQueueItem.fromJson(jsonDecode(json));

          if (item.status == 'synced') {
            await box.delete(key);
            continue;
          }

          final success = await _executeOperation(item);

          if (success) {
            await box.delete(key);
            synced++;
          } else {
            // Update retry count
            final updated = item.copyWith(
              retryCount: item.retryCount + 1,
              lastError: 'Sync failed',
            );
            await box.put(key, jsonEncode(updated.toJson()));
            failed++;
          }
        } catch (e) {
          failed++;
          if (kDebugMode) {
            debugPrint('SyncService: Error processing item $key: $e');
          }
        }
      }
    } finally {
      _isSyncing = false;
    }

    if (kDebugMode) {
      debugPrint('SyncService: Sync complete - $synced synced, $failed failed');
    }

    return SyncResult(synced: synced, failed: failed, message: 'Sync complete');
  }

  /// Execute a single sync operation
  static Future<bool> _executeOperation(SyncQueueItem item) async {
    try {
      final supabase = Supabase.instance.client;

      switch (item.operation) {
        case 'INSERT':
          await supabase.from(item.tableName).insert(item.payload);
          break;
        case 'UPDATE':
          await supabase
              .from(item.tableName)
              .update(item.payload)
              .eq('id', item.recordId);
          break;
        case 'DELETE':
          await supabase.from(item.tableName).delete().eq('id', item.recordId);
          break;
        case 'UPSERT':
          await supabase.from(item.tableName).upsert(item.payload);
          break;
        default:
          if (kDebugMode) {
            debugPrint('SyncService: Unknown operation ${item.operation}');
          }
          return false;
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Operation failed: $e');
      }
      return false;
    }
  }

}

/// Sync queue item model
class SyncQueueItem {
  final String id;
  final String operation;
  final String tableName;
  final String recordId;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final String status;
  final int retryCount;
  final String? lastError;

  SyncQueueItem({
    required this.id,
    required this.operation,
    required this.tableName,
    required this.recordId,
    required this.payload,
    required this.createdAt,
    this.status = 'pending',
    this.retryCount = 0,
    this.lastError,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'operation': operation,
    'table_name': tableName,
    'record_id': recordId,
    'payload': payload,
    'created_at': createdAt.toIso8601String(),
    'status': status,
    'retry_count': retryCount,
    'last_error': lastError,
  };

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) => SyncQueueItem(
    id: json['id'],
    operation: json['operation'],
    tableName: json['table_name'],
    recordId: json['record_id'],
    payload: json['payload'] is Map
        ? Map<String, dynamic>.from(json['payload'] as Map)
        : <String, dynamic>{},
    createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    status: json['status'] ?? 'pending',
    retryCount: json['retry_count'] ?? 0,
    lastError: json['last_error'],
  );

  SyncQueueItem copyWith({
    String? status,
    int? retryCount,
    String? lastError,
  }) => SyncQueueItem(
    id: id,
    operation: operation,
    tableName: tableName,
    recordId: recordId,
    payload: payload,
    createdAt: createdAt,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError ?? this.lastError,
  );
}

/// Sync result model
class SyncResult {
  final int synced;
  final int failed;
  final String message;

  SyncResult({
    required this.synced,
    required this.failed,
    required this.message,
  });
}
