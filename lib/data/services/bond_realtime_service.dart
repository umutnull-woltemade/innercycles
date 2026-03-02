// ════════════════════════════════════════════════════════════════════════════
// BOND REALTIME SERVICE - Supabase Realtime channels for live bond updates
// ════════════════════════════════════════════════════════════════════════════
// First Realtime usage in the app. Manages Supabase Realtime channels
// per bond_id for instant touch delivery and mood sharing.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bond.dart';

class BondRealtimeService {
  final Map<String, RealtimeChannel> _channels = {};
  final _touchController = StreamController<Touch>.broadcast();
  final _bondStatusController = StreamController<Bond>.broadcast();

  BondRealtimeService._();

  static Future<BondRealtimeService> init() async {
    return BondRealtimeService._();
  }

  /// Subscribe to all active bonds (call after fetching bonds list)
  void subscribeToAll(List<String> bondIds) {
    for (final id in bondIds) {
      subscribeToBond(id);
    }
  }

  SupabaseClient get _supabase => Supabase.instance.client;
  String? get _userId => _supabase.auth.currentUser?.id;

  /// Stream of incoming touches (for any active bond)
  Stream<Touch> get onTouchReceived => _touchController.stream;

  /// Stream of bond status changes
  Stream<Bond> get onBondStatusChanged => _bondStatusController.stream;

  /// Subscribe to realtime updates for a specific bond
  void subscribeToBond(String bondId) {
    if (_channels.containsKey('bond_touches_$bondId')) return; // Already subscribed

    // Listen for new touches on this bond
    final touchChannel = _supabase
        .channel('bond_touches_$bondId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'touches',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'bond_id',
            value: bondId,
          ),
          callback: (payload) {
            try {
              final touch = Touch.fromJson(payload.newRecord);
              // Only emit if we are the receiver
              if (touch.receiverId == _userId) {
                _touchController.add(touch);
              }
            } catch (e) {
              if (kDebugMode) debugPrint('[BondRealtime] touch parse error: $e');
            }
          },
        )
        .subscribe();

    _channels['bond_touches_$bondId'] = touchChannel;

    // Listen for bond status changes
    final bondChannel = _supabase
        .channel('bond_status_$bondId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'bonds',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: bondId,
          ),
          callback: (payload) {
            try {
              final bond = Bond.fromJson(payload.newRecord);
              _bondStatusController.add(bond);
            } catch (e) {
              if (kDebugMode) debugPrint('[BondRealtime] bond parse error: $e');
            }
          },
        )
        .subscribe();

    _channels['status_$bondId'] = bondChannel;
  }

  /// Unsubscribe from a specific bond's updates
  Future<void> unsubscribeFromBond(String bondId) async {
    final touchChannel = _channels.remove('bond_touches_$bondId');
    if (touchChannel != null) {
      await _supabase.removeChannel(touchChannel);
    }
    final statusChannel = _channels.remove('status_$bondId');
    if (statusChannel != null) {
      await _supabase.removeChannel(statusChannel);
    }
  }

  /// Dispose all channels
  Future<void> dispose() async {
    for (final channel in _channels.values) {
      await _supabase.removeChannel(channel);
    }
    _channels.clear();
    await _touchController.close();
    await _bondStatusController.close();
  }
}
