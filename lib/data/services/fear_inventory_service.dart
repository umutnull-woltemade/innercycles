// ════════════════════════════════════════════════════════════════════════════
// FEAR INVENTORY SERVICE - Track, reframe, and resolve fears
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/fear_entry.dart';

class FearInventoryService {
  static const String _storageKey = 'inner_cycles_fear_inventory';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<FearEntry> _entries = [];

  FearInventoryService._(this._prefs) {
    _loadEntries();
  }

  static Future<FearInventoryService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return FearInventoryService._(prefs);
  }

  Future<FearEntry> addFear({
    required String fearText,
    required FearCategory category,
    required int intensity,
    String? reframeText,
  }) async {
    final entry = FearEntry(
      id: _uuid.v4(),
      fearText: fearText,
      category: category,
      intensity: intensity,
      reframeText: reframeText,
      createdAt: DateTime.now(),
    );
    _entries.add(entry);
    await _persist();
    return entry;
  }

  Future<void> updateReframe(String id, String reframeText) async {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    _entries[idx] = _entries[idx].copyWith(reframeText: reframeText);
    await _persist();
  }

  Future<void> markResolved(String id) async {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    _entries[idx] = _entries[idx].copyWith(resolvedAt: DateTime.now());
    await _persist();
  }

  Future<void> deleteFear(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _persist();
  }

  List<FearEntry> getActiveFears() =>
      _entries.where((e) => !e.isResolved).toList()
        ..sort((a, b) => b.intensity.compareTo(a.intensity));

  List<FearEntry> getResolvedFears() =>
      _entries.where((e) => e.isResolved).toList()
        ..sort((a, b) => (b.resolvedAt ?? b.createdAt).compareTo(a.resolvedAt ?? a.createdAt));

  List<FearEntry> getByCategory(FearCategory category) =>
      _entries.where((e) => e.category == category && !e.isResolved).toList();

  int get activeCount => _entries.where((e) => !e.isResolved).length;

  FearCategory? get dominantCategory {
    final active = getActiveFears();
    if (active.isEmpty) return null;
    final counts = <FearCategory, int>{};
    for (final e in active) {
      counts[e.category] = (counts[e.category] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  void _loadEntries() {
    final json = _prefs.getString(_storageKey);
    if (json != null) {
      try {
        final list = jsonDecode(json) as List;
        _entries = list.map((e) => FearEntry.fromJson(e)).toList();
      } catch (e) {
        if (kDebugMode) debugPrint('FearInventoryService: load failed: $e');
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
