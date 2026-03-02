// ════════════════════════════════════════════════════════════════════════════
// TRIGGER MAP SERVICE - Emotional trigger tracking and analysis
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emotional_trigger.dart';

class TriggerMapService {
  static const _storageKey = 'trigger_map_v1';
  final SharedPreferences _prefs;
  List<EmotionalTrigger> _triggers = [];

  TriggerMapService._(this._prefs) {
    _load();
  }

  static Future<TriggerMapService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return TriggerMapService._(prefs);
  }

  void _load() {
    final raw = _prefs.getStringList(_storageKey) ?? [];
    _triggers = raw
        .map((s) {
          try {
            return EmotionalTrigger.fromJson(
                json.decode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<EmotionalTrigger>()
        .toList()
      ..sort((a, b) => b.frequency.compareTo(a.frequency));
  }

  Future<void> _persist() async {
    final raw = _triggers.map((t) => json.encode(t.toJson())).toList();
    await _prefs.setStringList(_storageKey, raw);
  }

  List<EmotionalTrigger> getAll() => List.unmodifiable(_triggers);

  /// Top triggers by frequency (for bubble visualization)
  List<EmotionalTrigger> getTopTriggers({int limit = 8}) {
    final sorted = [..._triggers]
      ..sort((a, b) => b.recentFrequency.compareTo(a.recentFrequency));
    return sorted.take(limit).toList();
  }

  /// Triggers by category
  Map<TriggerCategory, List<EmotionalTrigger>> getByCategory() {
    final map = <TriggerCategory, List<EmotionalTrigger>>{};
    for (final t in _triggers) {
      map.putIfAbsent(t.category, () => []).add(t);
    }
    return map;
  }

  Future<EmotionalTrigger> addTrigger({
    required String label,
    required TriggerCategory category,
    int intensity = 3,
    List<String> linkedEmotions = const [],
  }) async {
    final trigger = EmotionalTrigger(
      label: label,
      category: category,
      occurrences: [DateTime.now()],
      intensity: intensity,
      linkedEmotions: linkedEmotions,
    );
    _triggers.insert(0, trigger);
    await _persist();
    return trigger;
  }

  Future<void> logOccurrence(String triggerId) async {
    final idx = _triggers.indexWhere((t) => t.id == triggerId);
    if (idx < 0) return;
    final t = _triggers[idx];
    _triggers[idx] = t.copyWith(
      occurrences: [...t.occurrences, DateTime.now()],
    );
    await _persist();
  }

  Future<void> updateIntensity(String triggerId, int intensity) async {
    final idx = _triggers.indexWhere((t) => t.id == triggerId);
    if (idx < 0) return;
    _triggers[idx] = _triggers[idx].copyWith(intensity: intensity);
    await _persist();
  }

  Future<void> delete(String triggerId) async {
    _triggers.removeWhere((t) => t.id == triggerId);
    await _persist();
  }

  int get totalCount => _triggers.length;

  /// Most frequent category
  TriggerCategory? get dominantCategory {
    if (_triggers.isEmpty) return null;
    final counts = <TriggerCategory, int>{};
    for (final t in _triggers) {
      counts[t.category] =
          (counts[t.category] ?? 0) + t.recentFrequency;
    }
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}
