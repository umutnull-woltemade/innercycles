// ════════════════════════════════════════════════════════════════════════════
// SLEEP QUALITY SERVICE - InnerCycles Sleep Tracking Layer
// ════════════════════════════════════════════════════════════════════════════
// Quick 1-5 sleep quality rating with optional notes.
// Correlates with journal focus areas for pattern insights.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A single sleep log entry for a specific night
class SleepEntry {
  final String dateKey; // yyyy-MM-dd (the morning date)
  final int quality; // 1-5
  final String? note;
  final DateTime createdAt;

  const SleepEntry({
    required this.dateKey,
    required this.quality,
    this.note,
    required this.createdAt,
  });

  SleepEntry copyWith({int? quality, String? note}) => SleepEntry(
        dateKey: dateKey,
        quality: quality ?? this.quality,
        note: note ?? this.note,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'quality': quality,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SleepEntry.fromJson(Map<String, dynamic> json) => SleepEntry(
        dateKey: json['dateKey'] as String,
        quality: json['quality'] as int? ?? 3,
        note: json['note'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Weekly sleep summary for home screen card
class SleepSummary {
  final double averageQuality; // 1.0-5.0
  final int nightsLogged;
  final int bestNightQuality;
  final int worstNightQuality;
  final String? trendDirection; // 'improving', 'declining', 'stable'

  const SleepSummary({
    required this.averageQuality,
    required this.nightsLogged,
    required this.bestNightQuality,
    required this.worstNightQuality,
    this.trendDirection,
  });
}

class SleepService {
  static const String _storageKey = 'inner_cycles_sleep_entries';

  final SharedPreferences _prefs;
  Map<String, SleepEntry> _entries = {}; // dateKey -> entry

  SleepService._(this._prefs) {
    _loadEntries();
  }

  static Future<SleepService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SleepService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CRUD
  // ══════════════════════════════════════════════════════════════════════════

  /// Save or update sleep quality for a date
  Future<SleepEntry> saveSleep({
    required DateTime date,
    required int quality,
    String? note,
  }) async {
    final dateKey = _dateToKey(date);
    final entry = SleepEntry(
      dateKey: dateKey,
      quality: quality.clamp(1, 5),
      note: note?.trim().isNotEmpty == true ? note!.trim() : null,
      createdAt: DateTime.now(),
    );
    _entries[dateKey] = entry;
    await _persistEntries();
    return entry;
  }

  /// Get sleep entry for a specific date
  SleepEntry? getEntry(DateTime date) {
    return _entries[_dateToKey(date)];
  }

  /// Get today's sleep entry
  SleepEntry? getTodayEntry() => getEntry(DateTime.now());

  /// Delete sleep entry for a date
  Future<void> deleteEntry(DateTime date) async {
    _entries.remove(_dateToKey(date));
    await _persistEntries();
  }

  /// Get all entries sorted by date descending
  List<SleepEntry> getAllEntries() {
    final list = _entries.values.toList();
    list.sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return list;
  }

  int get entryCount => _entries.length;

  // ══════════════════════════════════════════════════════════════════════════
  // ANALYSIS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get weekly sleep summary (last 7 days)
  SleepSummary getWeeklySummary() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final recentEntries = _entries.values.where((e) {
      final date = DateTime.parse('${e.dateKey}T00:00:00');
      return !date.isBefore(weekAgo);
    }).toList();

    if (recentEntries.isEmpty) {
      return const SleepSummary(
        averageQuality: 0,
        nightsLogged: 0,
        bestNightQuality: 0,
        worstNightQuality: 0,
      );
    }

    final qualities = recentEntries.map((e) => e.quality).toList();
    final avg = qualities.reduce((a, b) => a + b) / qualities.length;
    final best = qualities.reduce((a, b) => a > b ? a : b);
    final worst = qualities.reduce((a, b) => a < b ? a : b);

    // Determine trend from first half vs second half of week
    String? trend;
    if (recentEntries.length >= 4) {
      recentEntries.sort((a, b) => a.dateKey.compareTo(b.dateKey));
      final mid = recentEntries.length ~/ 2;
      final firstHalf =
          recentEntries.sublist(0, mid).map((e) => e.quality).toList();
      final secondHalf =
          recentEntries.sublist(mid).map((e) => e.quality).toList();
      final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
      final secondAvg =
          secondHalf.reduce((a, b) => a + b) / secondHalf.length;
      if (secondAvg - firstAvg > 0.3) {
        trend = 'improving';
      } else if (firstAvg - secondAvg > 0.3) {
        trend = 'declining';
      } else {
        trend = 'stable';
      }
    }

    return SleepSummary(
      averageQuality: avg,
      nightsLogged: recentEntries.length,
      bestNightQuality: best,
      worstNightQuality: worst,
      trendDirection: trend,
    );
  }

  /// Get average sleep quality for a date range (for pattern engine)
  double getAverageForRange(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    final entries = _entries.values.where((e) {
      final date = DateTime.parse('${e.dateKey}T00:00:00');
      return !date.isBefore(startDay) && !date.isAfter(endDay);
    }).toList();

    if (entries.isEmpty) return 0;
    return entries.map((e) => e.quality).reduce((a, b) => a + b) /
        entries.length;
  }

  /// Get sleep-to-rating correlation data (premium)
  /// Returns map of sleep quality -> average journal rating for that sleep level
  Map<int, double> getSleepToRatingCorrelation(
    Map<String, double> journalRatingsByDate,
  ) {
    final correlations = <int, List<double>>{};

    for (final entry in _entries.values) {
      final journalRating = journalRatingsByDate[entry.dateKey];
      if (journalRating != null) {
        correlations.putIfAbsent(entry.quality, () => []).add(journalRating);
      }
    }

    return correlations.map((quality, ratings) =>
        MapEntry(quality, ratings.reduce((a, b) => a + b) / ratings.length));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadEntries() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _entries = jsonMap.map(
          (k, v) => MapEntry(k, SleepEntry.fromJson(v)),
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

  String _dateToKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
