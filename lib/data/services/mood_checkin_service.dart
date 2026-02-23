// ════════════════════════════════════════════════════════════════════════════
// MOOD CHECK-IN SERVICE - Quick Daily Mood Logging
// ════════════════════════════════════════════════════════════════════════════
// One-tap mood tracking without full journal entry.
// Drives daily opens and builds streak momentum.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../mixins/supabase_sync_mixin.dart';

class MoodEntry {
  final String id;
  final DateTime date;
  final int mood; // 1-5
  final String emoji;

  const MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.emoji,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'mood': mood,
    'emoji': emoji,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    // Backward-compatible: generate UUID if id missing (old data)
    id: json['id'] as String? ?? const Uuid().v4(),
    date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    mood: json['mood'] as int? ?? 3,
    emoji: json['emoji'] as String? ?? '',
  );
}

class MoodCheckinService with SupabaseSyncMixin {
  @override
  String get tableName => 'mood_entries';

  static const String _key = 'inner_cycles_mood_checkins';
  static const _uuid = Uuid();
  final SharedPreferences _prefs;
  List<MoodEntry> _entries = [];

  MoodCheckinService._(this._prefs) {
    _load();
  }

  static Future<MoodCheckinService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return MoodCheckinService._(prefs);
  }

  /// Available mood options
  static const List<(int, String, String, String)> moodOptions = [
    (1, '😔', 'Struggling', 'Zor'),
    (2, '😐', 'Low', 'Düşük'),
    (3, '🙂', 'Okay', 'İdare'),
    (4, '😊', 'Good', 'İyi'),
    (5, '🤩', 'Great', 'Harika'),
  ];

  /// Log today's mood
  Future<void> logMood(int mood, String emoji) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Remove existing entry for today
    _entries.removeWhere(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );

    final entry = MoodEntry(id: _uuid.v4(), date: today, mood: mood, emoji: emoji);
    _entries.insert(0, entry);

    // Keep last 90 days
    if (_entries.length > 90) _entries = _entries.sublist(0, 90);
    await _persist();

    // Sync to Supabase
    queueSync('UPSERT', entry.id, {
      'id': entry.id,
      'date': '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
      'mood': mood,
      'emoji': emoji,
    });
  }

  /// Get today's mood
  MoodEntry? getTodayMood() {
    final now = DateTime.now();
    return _entries
        .where(
          (e) =>
              e.date.year == now.year &&
              e.date.month == now.month &&
              e.date.day == now.day,
        )
        .firstOrNull;
  }

  /// Get last 7 days of moods
  List<MoodEntry?> getWeekMoods() {
    final now = DateTime.now();
    final result = <MoodEntry?>[];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final entry = _entries
          .where(
            (e) =>
                e.date.year == day.year &&
                e.date.month == day.month &&
                e.date.day == day.day,
          )
          .firstOrNull;
      result.add(entry);
    }
    return result;
  }

  /// Get all entries
  List<MoodEntry> getAllEntries() => List.unmodifiable(_entries);

  /// Get average mood for the last N days
  double getAverageMood(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recent = _entries.where((e) => e.date.isAfter(cutoff)).toList();
    if (recent.isEmpty) return 0;
    return recent.map((e) => e.mood).reduce((a, b) => a + b) / recent.length;
  }

  // Persistence
  void _load() {
    final jsonString = _prefs.getString(_key);
    if (jsonString != null) {
      try {
        final list = json.decode(jsonString) as List<dynamic>;
        _entries = list
            .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _entries = [];
      }
    }
  }

  Future<void> _persist() async {
    final jsonList = _entries.map((e) => e.toJson()).toList();
    await _prefs.setString(_key, json.encode(jsonList));
  }
}
