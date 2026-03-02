// ════════════════════════════════════════════════════════════════════════════
// LIFE WHEEL SERVICE - Balance assessment tracking
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/life_wheel_entry.dart';

class LifeWheelService {
  static const String _storageKey = 'inner_cycles_life_wheel';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<LifeWheelEntry> _entries = [];

  LifeWheelService._(this._prefs) {
    _loadEntries();
  }

  static Future<LifeWheelService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LifeWheelService._(prefs);
  }

  Future<LifeWheelEntry> saveEntry({
    required Map<LifeArea, int> scores,
    String? note,
  }) async {
    final entry = LifeWheelEntry(
      id: _uuid.v4(),
      scores: scores,
      note: note,
      createdAt: DateTime.now(),
    );
    _entries.add(entry);
    await _persist();
    return entry;
  }

  LifeWheelEntry? getLatestEntry() {
    if (_entries.isEmpty) return null;
    return _entries.last;
  }

  List<LifeWheelEntry> getHistory() {
    return List.from(_entries)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get score delta between latest and previous entry
  Map<LifeArea, int>? getDelta() {
    if (_entries.length < 2) return null;
    final current = _entries.last;
    final previous = _entries[_entries.length - 2];
    return {
      for (final area in LifeArea.values)
        area: (current.scores[area] ?? 0) - (previous.scores[area] ?? 0),
    };
  }

  /// Check if it's been 30+ days since last assessment
  bool get isDueForCheckin {
    if (_entries.isEmpty) return true;
    final daysSince = DateTime.now().difference(_entries.last.createdAt).inDays;
    return daysSince >= 30;
  }

  int get entryCount => _entries.length;

  void _loadEntries() {
    final json = _prefs.getString(_storageKey);
    if (json != null) {
      try {
        final list = jsonDecode(json) as List;
        _entries = list.map((e) => LifeWheelEntry.fromJson(e)).toList();
      } catch (e) {
        if (kDebugMode) debugPrint('LifeWheelService: load failed: $e');
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
