// ════════════════════════════════════════════════════════════════════════════
// TIME CAPSULE SERVICE - Store and deliver letters to future self
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/time_capsule_entry.dart';

class TimeCapsuleService {
  static const String _storageKey = 'inner_cycles_time_capsules';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<TimeCapsuleEntry> _entries = [];

  TimeCapsuleService._(this._prefs) {
    _loadEntries();
  }

  static Future<TimeCapsuleService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return TimeCapsuleService._(prefs);
  }

  /// Create a new time capsule
  Future<TimeCapsuleEntry> createCapsule({
    required String content,
    required DateTime deliveryDate,
  }) async {
    final entry = TimeCapsuleEntry(
      id: _uuid.v4(),
      content: content,
      createdAt: DateTime.now(),
      deliveryDate: deliveryDate,
    );
    _entries.add(entry);
    await _persist();
    return entry;
  }

  /// Mark a capsule as opened
  Future<void> openCapsule(String id) async {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    _entries[idx] = _entries[idx].copyWith(isOpened: true);
    await _persist();
  }

  /// Get capsules ready to deliver (delivery date passed, not yet opened)
  List<TimeCapsuleEntry> getReadyCapsules() {
    return _entries.where((e) => e.isReadyToDeliver).toList()
      ..sort((a, b) => a.deliveryDate.compareTo(b.deliveryDate));
  }

  /// Get all capsules (sorted by delivery date)
  List<TimeCapsuleEntry> getAllCapsules() {
    return List.from(_entries)..sort((a, b) => a.deliveryDate.compareTo(b.deliveryDate));
  }

  /// Get count of pending (not yet delivered) capsules
  int get pendingCount => _entries.where((e) => !e.isReadyToDeliver && !e.isOpened).length;

  /// Get count of ready-to-open capsules
  int get readyCount => _entries.where((e) => e.isReadyToDeliver).length;

  void _loadEntries() {
    final json = _prefs.getString(_storageKey);
    if (json != null) {
      try {
        final list = jsonDecode(json) as List;
        _entries = list
            .map((e) {
              try { return TimeCapsuleEntry.fromJson(e); } catch (_) { return null; }
            })
            .whereType<TimeCapsuleEntry>()
            .toList();
      } catch (e) {
        if (kDebugMode) debugPrint('TimeCapsuleService: load failed: $e');
        _entries = [];
      }
    }
  }

  Future<void> _persist() async {
    await _prefs.setString(
      _storageKey,
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
  }
}
