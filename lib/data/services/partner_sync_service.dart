// ════════════════════════════════════════════════════════════════════════════
// PARTNER SYNC SERVICE - InnerCycles Partner Cycle Sharing (Local-First MVP)
// ════════════════════════════════════════════════════════════════════════════
// Invite-based partner linking with local SharedPreferences storage.
// Partners share emotional cycle position via 6-character invite codes.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════════════════════
// PARTNER PROFILE MODEL
// ════════════════════════════════════════════════════════════════════════════

class PartnerProfile {
  final String name;
  final DateTime linkedDate;
  final String? lastSharedMood;
  final String? lastSharedPhase;
  final DateTime? lastUpdated;

  const PartnerProfile({
    required this.name,
    required this.linkedDate,
    this.lastSharedMood,
    this.lastSharedPhase,
    this.lastUpdated,
  });

  PartnerProfile copyWith({
    String? name,
    DateTime? linkedDate,
    String? lastSharedMood,
    String? lastSharedPhase,
    DateTime? lastUpdated,
  }) {
    return PartnerProfile(
      name: name ?? this.name,
      linkedDate: linkedDate ?? this.linkedDate,
      lastSharedMood: lastSharedMood ?? this.lastSharedMood,
      lastSharedPhase: lastSharedPhase ?? this.lastSharedPhase,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'linkedDate': linkedDate.toIso8601String(),
    'lastSharedMood': lastSharedMood,
    'lastSharedPhase': lastSharedPhase,
    'lastUpdated': lastUpdated?.toIso8601String(),
  };

  factory PartnerProfile.fromJson(Map<String, dynamic> json) => PartnerProfile(
    name: json['name'] as String? ?? '',
    linkedDate:
        DateTime.tryParse(json['linkedDate']?.toString() ?? '') ??
        DateTime.now(),
    lastSharedMood: json['lastSharedMood'] as String?,
    lastSharedPhase: json['lastSharedPhase'] as String?,
    lastUpdated: json['lastUpdated'] != null
        ? DateTime.tryParse(json['lastUpdated'].toString())
        : null,
  );

  /// Days since linked
  int get daysTogether => DateTime.now().difference(linkedDate).inDays;
}

// ════════════════════════════════════════════════════════════════════════════
// SERVICE
// ════════════════════════════════════════════════════════════════════════════

class PartnerSyncService {
  static const String _partnerKey = 'inner_cycles_partner_data';
  static const String _inviteCodeKey = 'inner_cycles_invite_code';
  static const String _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  final SharedPreferences _prefs;
  PartnerProfile? _partner;
  String? _inviteCode;

  PartnerSyncService._(this._prefs) {
    _loadPartnerData();
    _loadInviteCode();
  }

  /// Initialize the partner sync service
  static Future<PartnerSyncService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PartnerSyncService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // INVITE CODE
  // ══════════════════════════════════════════════════════════════════════════

  /// Generate a new 6-character invite code (uppercase alphanumeric, no
  /// ambiguous characters like 0/O, 1/I/L).
  String generateInviteCode() {
    final random = Random.secure();
    final code = List.generate(
      6,
      (_) => _codeChars[random.nextInt(_codeChars.length)],
    ).join();
    _inviteCode = code;
    _prefs.setString(_inviteCodeKey, code);
    return code;
  }

  /// Get current invite code (generates one if none exists)
  String getInviteCode() {
    if (_inviteCode != null) return _inviteCode!;
    return generateInviteCode();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PARTNER LINKING
  // ══════════════════════════════════════════════════════════════════════════

  /// Link a partner using their invite code and display name.
  /// Returns true on success.
  Future<bool> linkPartner(String code, String name) async {
    final trimmedCode = code.trim().toUpperCase();
    final trimmedName = name.trim();

    if (trimmedCode.length != 6 || trimmedName.isEmpty) return false;

    _partner = PartnerProfile(
      name: trimmedName,
      linkedDate: DateTime.now(),
    );
    await _persistPartnerData();
    return true;
  }

  /// Unlink the current partner (clears all partner data)
  Future<void> unlinkPartner() async {
    _partner = null;
    await _prefs.remove(_partnerKey);
  }

  /// Check if a partner is currently linked
  bool isLinked() => _partner != null;

  /// Get current partner data (null if not linked)
  PartnerProfile? getPartnerData() => _partner;

  // ══════════════════════════════════════════════════════════════════════════
  // SHARED CYCLE DATA
  // ══════════════════════════════════════════════════════════════════════════

  /// Update the partner's shared mood and phase.
  /// Called when partner data is received (future cloud sync).
  Future<void> updateSharedCycleData({
    String? mood,
    String? phase,
  }) async {
    if (_partner == null) return;
    _partner = _partner!.copyWith(
      lastSharedMood: mood ?? _partner!.lastSharedMood,
      lastSharedPhase: phase ?? _partner!.lastSharedPhase,
      lastUpdated: DateTime.now(),
    );
    await _persistPartnerData();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadPartnerData() {
    final jsonString = _prefs.getString(_partnerKey);
    if (jsonString != null) {
      try {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        _partner = PartnerProfile.fromJson(jsonMap);
      } catch (_) {
        _partner = null;
      }
    }
  }

  void _loadInviteCode() {
    _inviteCode = _prefs.getString(_inviteCodeKey);
  }

  Future<void> _persistPartnerData() async {
    if (_partner != null) {
      await _prefs.setString(_partnerKey, json.encode(_partner!.toJson()));
    }
  }

  /// Clear all partner sync data
  Future<void> clearAll() async {
    _partner = null;
    _inviteCode = null;
    await _prefs.remove(_partnerKey);
    await _prefs.remove(_inviteCodeKey);
  }
}
