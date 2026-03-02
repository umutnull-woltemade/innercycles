// ════════════════════════════════════════════════════════════════════════════
// BOND SERVICE - Partner/close relationship management
// ════════════════════════════════════════════════════════════════════════════
// Supabase-primary with local SharedPreferences cache.
// Handles invite creation/acceptance, bond lifecycle, privacy settings.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/bond.dart';
import '../mixins/supabase_sync_mixin.dart';
import 'sync_service.dart';

class BondService with SupabaseSyncMixin {
  @override
  String get tableName => 'bonds';

  static const String _cacheKey = 'inner_cycles_bonds_cache';
  static const _uuid = Uuid();
  final SharedPreferences _prefs;
  List<Bond> _bonds = [];

  BondService._(this._prefs) {
    _loadCache();
  }

  static Future<BondService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return BondService._(prefs);
  }

  SupabaseClient get _supabase => Supabase.instance.client;
  String? get _userId => _supabase.auth.currentUser?.id;

  // ════════════════════════════════════════════════════════════════
  // INVITE MANAGEMENT
  // ════════════════════════════════════════════════════════════════

  /// Generate a 6-digit alphanumeric invite code with 24h expiry
  Future<BondInvite?> createInvite(BondType bondType) async {
    if (_userId == null) return null;

    final code = _generateCode();
    final invite = BondInvite(
      id: _uuid.v4(),
      creatorId: _userId!,
      code: code,
      bondType: bondType,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      createdAt: DateTime.now(),
    );

    try {
      await _supabase.from('bond_invites').insert(invite.toJson());
      return invite;
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] createInvite error: $e');
      return null;
    }
  }

  /// Accept an invite by code. Creates the bond between users.
  Future<Bond?> acceptInvite(String code) async {
    if (_userId == null) return null;

    try {
      // Fetch the invite
      final rows = await _supabase
          .from('bond_invites')
          .select()
          .eq('code', code.toUpperCase().trim())
          .isFilter('accepted_by', null)
          .limit(1);

      if (rows.isEmpty) return null;
      final invite = BondInvite.fromJson(rows.first);

      if (invite.isExpired) return null;
      if (invite.creatorId == _userId) return null; // Can't accept own invite

      // Mark invite as accepted
      await _supabase.from('bond_invites').update({
        'accepted_by': _userId,
        'accepted_at': DateTime.now().toIso8601String(),
      }).eq('id', invite.id);

      // Create the bond
      final bond = Bond(
        id: _uuid.v4(),
        userA: invite.creatorId,
        userB: _userId!,
        bondType: invite.bondType,
        status: BondStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _supabase.from('bonds').insert(bond.toJson());

      // Create default privacy for both users
      final privacyA = BondPrivacy(
        id: _uuid.v4(),
        bondId: bond.id,
        userId: invite.creatorId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final privacyB = BondPrivacy(
        id: _uuid.v4(),
        bondId: bond.id,
        userId: _userId!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _supabase.from('bond_privacy').insert([
        privacyA.toJson(),
        privacyB.toJson(),
      ]);

      _bonds.add(bond);
      await _persistCache();
      return bond;
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] acceptInvite error: $e');
      return null;
    }
  }

  // ════════════════════════════════════════════════════════════════
  // BOND QUERIES
  // ════════════════════════════════════════════════════════════════

  /// Get all active bonds for current user
  Future<List<Bond>> getActiveBonds() async {
    if (_userId == null) return _bonds;

    try {
      final rows = await _supabase
          .from('bonds')
          .select()
          .or('user_a.eq.$_userId,user_b.eq.$_userId')
          .inFilter('status', ['active', 'paused', 'dissolving'])
          .order('created_at', ascending: false);

      _bonds = rows.map((r) => Bond.fromJson(r)).toList();
      await _persistCache();
      return _bonds;
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] getActiveBonds error: $e');
      return _bonds; // Return cache on error
    }
  }

  /// Get cached bonds (synchronous)
  List<Bond> get cachedBonds => List.unmodifiable(_bonds);

  /// Get bond by ID
  Bond? getBond(String bondId) {
    for (final b in _bonds) {
      if (b.id == bondId) return b;
    }
    return null;
  }

  // ════════════════════════════════════════════════════════════════
  // BOND LIFECYCLE
  // ════════════════════════════════════════════════════════════════

  /// Pause a bond (hide mood sharing temporarily)
  Future<void> pauseBond(String bondId) async {
    try {
      await _supabase.from('bonds').update({
        'status': 'paused',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', bondId);
      await getActiveBonds(); // Refresh
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] pauseBond error: $e');
    }
  }

  /// Resume a paused bond
  Future<void> resumeBond(String bondId) async {
    try {
      await _supabase.from('bonds').update({
        'status': 'active',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', bondId);
      await getActiveBonds();
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] resumeBond error: $e');
    }
  }

  /// Request dissolution (starts 7-day cooling period)
  Future<void> requestDissolve(String bondId) async {
    if (_userId == null) return;
    try {
      await _supabase.from('bonds').update({
        'status': 'dissolving',
        'dissolve_requested_at': DateTime.now().toIso8601String(),
        'dissolve_requested_by': _userId,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', bondId);
      await getActiveBonds();
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] requestDissolve error: $e');
    }
  }

  /// Cancel dissolution request (during cooling period)
  Future<void> cancelDissolve(String bondId) async {
    try {
      await _supabase.from('bonds').update({
        'status': 'active',
        'dissolve_requested_at': null,
        'dissolve_requested_by': null,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', bondId);
      await getActiveBonds();
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] cancelDissolve error: $e');
    }
  }

  // ════════════════════════════════════════════════════════════════
  // PRIVACY
  // ════════════════════════════════════════════════════════════════

  /// Get privacy settings for current user in a bond
  Future<BondPrivacy?> getPrivacy(String bondId) async {
    if (_userId == null) return null;
    try {
      final rows = await _supabase
          .from('bond_privacy')
          .select()
          .eq('bond_id', bondId)
          .eq('user_id', _userId!)
          .limit(1);
      if (rows.isEmpty) return null;
      return BondPrivacy.fromJson(rows.first);
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] getPrivacy error: $e');
      return null;
    }
  }

  /// Update privacy settings (offline-safe via sync queue)
  Future<void> updatePrivacy(BondPrivacy privacy) async {
    try {
      await _supabase
          .from('bond_privacy')
          .update(privacy.toJson())
          .eq('id', privacy.id);
    } catch (e) {
      if (kDebugMode) debugPrint('[BondService] updatePrivacy error: $e');
      // Queue for retry when back online
      SyncService.queueOperation(
        tableName: 'bond_privacy',
        operation: 'UPSERT',
        recordId: privacy.id,
        payload: {
          ...privacy.toJson(),
          'user_id': _userId,
        },
      );
    }
  }

  // ════════════════════════════════════════════════════════════════
  // INTERNAL
  // ════════════════════════════════════════════════════════════════

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    return List.generate(6, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  void _loadCache() {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        final list = json.decode(jsonString) as List<dynamic>;
        _bonds = list.map((e) => Bond.fromJson(e as Map<String, dynamic>)).toList();
      } catch (e) {
        if (kDebugMode) debugPrint('[BondService] cache decode error: $e');
        _bonds = [];
      }
    }
  }

  Future<void> _persistCache() async {
    final jsonList = _bonds.map((b) => b.toJson()).toList();
    await _prefs.setString(_cacheKey, json.encode(jsonList));
  }
}
