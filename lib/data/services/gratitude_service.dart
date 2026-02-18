// ════════════════════════════════════════════════════════════════════════════
// GRATITUDE SERVICE - InnerCycles Gratitude Journal Layer
// ════════════════════════════════════════════════════════════════════════════
// Optional gratitude entries attached to daily journal entries.
// Tracks themes over time for pattern engine correlation.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A single gratitude entry for a specific day
class GratitudeEntry {
  final String dateKey; // yyyy-MM-dd
  final List<String> items; // 1-3 gratitude items
  final DateTime createdAt;

  const GratitudeEntry({
    required this.dateKey,
    required this.items,
    required this.createdAt,
  });

  GratitudeEntry copyWith({List<String>? items}) => GratitudeEntry(
    dateKey: dateKey,
    items: items ?? this.items,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => {
    'dateKey': dateKey,
    'items': items,
    'createdAt': createdAt.toIso8601String(),
  };

  factory GratitudeEntry.fromJson(Map<String, dynamic> json) => GratitudeEntry(
    dateKey: json['dateKey'] as String? ?? '',
    items: (json['items'] as List<dynamic>? ?? []).whereType<String>().toList(),
    createdAt:
        DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
        DateTime.now(),
  );
}

/// Weekly gratitude summary for home screen card
class GratitudeSummary {
  final int totalItems;
  final Map<String, int> topThemes; // word -> frequency
  final int daysWithGratitude;

  const GratitudeSummary({
    required this.totalItems,
    required this.topThemes,
    required this.daysWithGratitude,
  });
}

class GratitudeService {
  static const String _storageKey = 'inner_cycles_gratitude_entries';

  final SharedPreferences _prefs;
  Map<String, GratitudeEntry> _entries = {}; // dateKey -> entry

  GratitudeService._(this._prefs) {
    _loadEntries();
  }

  static Future<GratitudeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return GratitudeService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CRUD
  // ══════════════════════════════════════════════════════════════════════════

  /// Save or update gratitude items for a date
  Future<GratitudeEntry> saveGratitude({
    required DateTime date,
    required List<String> items,
  }) async {
    final dateKey = _dateToKey(date);
    final entry = GratitudeEntry(
      dateKey: dateKey,
      items: items.where((s) => s.trim().isNotEmpty).toList(),
      createdAt: DateTime.now(),
    );
    _entries[dateKey] = entry;
    await _persistEntries();
    return entry;
  }

  /// Get gratitude entry for a specific date
  GratitudeEntry? getEntry(DateTime date) {
    return _entries[_dateToKey(date)];
  }

  /// Get today's gratitude entry
  GratitudeEntry? getTodayEntry() => getEntry(DateTime.now());

  /// Delete gratitude entry for a date
  Future<void> deleteEntry(DateTime date) async {
    _entries.remove(_dateToKey(date));
    await _persistEntries();
  }

  /// Get all entries sorted by date descending
  List<GratitudeEntry> getAllEntries() {
    final list = _entries.values.toList();
    list.sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return list;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get weekly gratitude summary (last 7 days)
  GratitudeSummary getWeeklySummary() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final recentEntries = _entries.values.where((e) {
      final date = DateTime.tryParse('${e.dateKey}T00:00:00') ?? DateTime.now();
      return !date.isBefore(weekAgo);
    }).toList();

    final allItems = recentEntries.expand((e) => e.items).toList();
    final wordFreq = <String, int>{};

    for (final item in allItems) {
      // Extract meaningful words (3+ chars, lowercase)
      final words = item
          .toLowerCase()
          .split(RegExp(r'\s+'))
          .where((w) => w.length >= 3 && !_stopWords.contains(w));
      for (final word in words) {
        wordFreq[word] = (wordFreq[word] ?? 0) + 1;
      }
    }

    // Sort by frequency and take top 5
    final sorted = wordFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topThemes = Map.fromEntries(sorted.take(5));

    return GratitudeSummary(
      totalItems: allItems.length,
      topThemes: topThemes,
      daysWithGratitude: recentEntries.length,
    );
  }

  /// Get all-time gratitude themes (premium)
  Map<String, int> getAllTimeThemes() {
    final allItems = _entries.values.expand((e) => e.items).toList();
    final wordFreq = <String, int>{};

    for (final item in allItems) {
      final words = item
          .toLowerCase()
          .split(RegExp(r'\s+'))
          .where((w) => w.length >= 3 && !_stopWords.contains(w));
      for (final word in words) {
        wordFreq[word] = (wordFreq[word] ?? 0) + 1;
      }
    }

    final sorted = wordFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(20));
  }

  int get entryCount => _entries.length;

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadEntries() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _entries = jsonMap.map(
          (k, v) => MapEntry(k, GratitudeEntry.fromJson(v)),
        );
      } catch (_) {
        _entries = {};
      }
    }
  }

  Future<void> _persistEntries() async {
    final jsonMap = _entries.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs.setString(_storageKey, json.encode(jsonMap));
  }

  Future<void> clearAll() async {
    _entries.clear();
    await _prefs.remove(_storageKey);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  String _dateToKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static const _stopWords = {
    'the',
    'and',
    'for',
    'that',
    'this',
    'with',
    'was',
    'are',
    'had',
    'has',
    'have',
    'been',
    'from',
    'but',
    'not',
    'they',
    'all',
    'can',
    'her',
    'his',
    'she',
    'him',
    'how',
    'its',
    'may',
    'our',
    'out',
    'who',
    'get',
    'got',
    'did',
    'just',
    'than',
    'then',
    'what',
    'when',
    'bir',
    've',
    'ile',
    'için',
    'olan',
    'ama',
    'ben',
    'sen',
    'benim',
    'senin',
    'onun',
    'çok',
    'daha',
    'gibi',
  };
}
