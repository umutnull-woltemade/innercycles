// ════════════════════════════════════════════════════════════════════════════
// SHADOW WORK SERVICE - Guided Shadow Integration Journal
// ════════════════════════════════════════════════════════════════════════════
// Persistence for shadow work entries with archetype analytics.
// SharedPreferences pattern matching CycleSyncService.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shadow_work_entry.dart';

class ShadowWorkService {
  static const String _entriesKey = 'inner_cycles_shadow_entries';
  final SharedPreferences _prefs;
  List<ShadowWorkEntry> _entries = [];

  ShadowWorkService._(this._prefs) {
    _load();
  }

  static Future<ShadowWorkService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ShadowWorkService._(prefs);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ENTRY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════

  /// Save a new shadow work entry
  Future<void> saveEntry(ShadowWorkEntry entry) async {
    // Remove existing entry with same ID
    _entries.removeWhere((e) => e.id == entry.id);
    _entries.insert(0, entry);

    // Sort by date descending
    _entries.sort((a, b) => b.date.compareTo(a.date));

    await _persist();
  }

  /// Delete an entry by ID
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _persist();
  }

  /// Get all entries, newest first
  List<ShadowWorkEntry> getEntries() => List.unmodifiable(_entries);

  /// Get entries for a specific archetype
  List<ShadowWorkEntry> getEntriesByArchetype(ShadowArchetype archetype) {
    return _entries.where((e) => e.archetype == archetype).toList();
  }

  /// Get entries from the last N days
  List<ShadowWorkEntry> getRecentEntries(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _entries.where((e) => e.date.isAfter(cutoff)).toList();
  }

  /// Get the most recent entry
  ShadowWorkEntry? get latestEntry =>
      _entries.isNotEmpty ? _entries.first : null;

  /// Whether the user has any shadow work entries
  bool get hasData => _entries.isNotEmpty;

  /// Total entry count
  int get totalEntries => _entries.length;

  // ═══════════════════════════════════════════════════════════════════════
  // ARCHETYPE ANALYTICS
  // ═══════════════════════════════════════════════════════════════════════

  /// Get frequency map of archetypes explored
  Map<ShadowArchetype, int> getArchetypeStats() {
    final stats = <ShadowArchetype, int>{};
    for (final entry in _entries) {
      stats[entry.archetype] = (stats[entry.archetype] ?? 0) + 1;
    }
    return stats;
  }

  /// Get the most frequently explored archetype
  ShadowArchetype? getMostActiveArchetype() {
    final stats = getArchetypeStats();
    if (stats.isEmpty) return null;
    return stats.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Get archetypes the user has NOT explored yet
  List<ShadowArchetype> getUnexploredArchetypes() {
    final explored = getArchetypeStats().keys.toSet();
    return ShadowArchetype.values.where((a) => !explored.contains(a)).toList();
  }

  /// Get average intensity across all entries
  double getAverageIntensity() {
    if (_entries.isEmpty) return 0;
    final sum = _entries.fold<int>(0, (acc, e) => acc + e.intensity);
    return sum / _entries.length;
  }

  /// Count breakthrough moments
  int getBreakthroughCount() {
    return _entries.where((e) => e.breakthroughMoment).length;
  }

  /// Get shadow work streak (consecutive days with entries)
  int getStreak() {
    if (_entries.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Get unique entry dates
    final dates =
        _entries
            .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a)); // newest first

    if (dates.isEmpty) return 0;

    // Check if most recent entry is today or yesterday
    final daysSinceLatest = today.difference(dates.first).inDays;
    if (daysSinceLatest > 1) return 0;

    int streak = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      final diff = dates[i].difference(dates[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ═══════════════════════════════════════════════════════════════════════

  void _load() {
    final jsonString = _prefs.getString(_entriesKey);
    if (jsonString != null) {
      try {
        final list = json.decode(jsonString) as List<dynamic>;
        _entries = list
            .map((e) => ShadowWorkEntry.fromJson(e as Map<String, dynamic>))
            .toList();
        _entries.sort((a, b) => b.date.compareTo(a.date));
      } catch (_) {
        _entries = [];
      }
    }
  }

  Future<void> _persist() async {
    final jsonList = _entries.map((e) => e.toJson()).toList();
    await _prefs.setString(_entriesKey, json.encode(jsonList));
  }

  // ═══════════════════════════════════════════════════════════════════════
  // JOURNAL CROSS-REFERENCE (FocusArea → Shadow Archetype suggestions)
  // ═══════════════════════════════════════════════════════════════════════

  /// Suggest shadow archetypes based on the user's weakest focus areas.
  /// Maps low-scoring journal dimensions to relevant shadow patterns.
  static List<ShadowArchetype> suggestArchetypesForWeakAreas(
    List<String> weakAreaNames,
  ) {
    final suggestions = <ShadowArchetype>{};
    for (final area in weakAreaNames) {
      switch (area.toLowerCase()) {
        case 'energy':
          suggestions.addAll([
            ShadowArchetype.caretaker,
            ShadowArchetype.perfectionist,
          ]);
        case 'focus':
          suggestions.addAll([ShadowArchetype.avoider, ShadowArchetype.rebel]);
        case 'emotions':
          suggestions.addAll([
            ShadowArchetype.innerCritic,
            ShadowArchetype.victim,
          ]);
        case 'decisions':
          suggestions.addAll([
            ShadowArchetype.controller,
            ShadowArchetype.peoplePleaser,
          ]);
        case 'social':
          suggestions.addAll([
            ShadowArchetype.peoplePleaser,
            ShadowArchetype.avoider,
          ]);
      }
    }
    return suggestions.toList();
  }
}
