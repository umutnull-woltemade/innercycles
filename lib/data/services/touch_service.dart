// ════════════════════════════════════════════════════════════════════════════
// TOUCH SERVICE - Send/receive haptic touches between bond partners
// ════════════════════════════════════════════════════════════════════════════
// Client-side throttle: max 1 touch per 5 seconds.
// Uses Supabase Realtime for instant delivery.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/bond.dart';
import '../mixins/supabase_sync_mixin.dart';

class TouchService with SupabaseSyncMixin {
  @override
  String get tableName => 'touches';

  static const _uuid = Uuid();
  static const _throttleMs = 5000; // 5 second throttle

  DateTime? _lastTouchSent;

  TouchService._();

  static Future<TouchService> init() async {
    return TouchService._();
  }

  SupabaseClient get _supabase => Supabase.instance.client;
  String? get _userId => _supabase.auth.currentUser?.id;

  /// Send a touch to a bond partner
  /// Returns the created Touch or null if throttled/error
  Future<Touch?> sendTouch({
    required String bondId,
    required String receiverId,
    TouchType type = TouchType.warm,
  }) async {
    if (_userId == null) return null;

    // Client-side throttle
    if (_lastTouchSent != null) {
      final elapsed = DateTime.now().difference(_lastTouchSent!).inMilliseconds;
      if (elapsed < _throttleMs) return null;
    }

    final touch = Touch(
      id: _uuid.v4(),
      bondId: bondId,
      senderId: _userId!,
      receiverId: receiverId,
      touchType: type,
      createdAt: DateTime.now(),
    );

    try {
      await _supabase.from('touches').insert(touch.toJson());
      _lastTouchSent = DateTime.now();
      return touch;
    } catch (e) {
      if (kDebugMode) debugPrint('[TouchService] sendTouch error: $e');
      return null;
    }
  }

  /// Get recent touches for a bond (last 50)
  Future<List<Touch>> getRecentTouches(String bondId) async {
    try {
      final rows = await _supabase
          .from('touches')
          .select()
          .eq('bond_id', bondId)
          .order('created_at', ascending: false)
          .limit(50);
      return rows.map((r) => Touch.fromJson(r)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('[TouchService] getRecentTouches error: $e');
      return [];
    }
  }

  /// Mark a touch as seen
  Future<void> markTouchSeen(String touchId) async {
    try {
      await _supabase.from('touches').update({
        'seen_at': DateTime.now().toIso8601String(),
      }).eq('id', touchId);
    } catch (e) {
      if (kDebugMode) debugPrint('[TouchService] markTouchSeen error: $e');
    }
  }

  /// Count unseen touches for current user
  Future<int> getUnseenTouchCount() async {
    if (_userId == null) return 0;
    try {
      final rows = await _supabase
          .from('touches')
          .select('id')
          .eq('receiver_id', _userId!)
          .isFilter('seen_at', null);
      return rows.length;
    } catch (e) {
      if (kDebugMode) debugPrint('[TouchService] getUnseenTouchCount error: $e');
      return 0;
    }
  }
}
