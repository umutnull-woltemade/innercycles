// ════════════════════════════════════════════════════════════════════════════
// MOOD CHECK-IN SERVICE - Quick Daily Mood Logging
// ════════════════════════════════════════════════════════════════════════════
// One-tap mood tracking without full journal entry.
// Drives daily opens and builds streak momentum.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../content/signal_content.dart';
import '../mixins/supabase_sync_mixin.dart';

class MoodEntry {
  final String id;
  final DateTime date;
  final int mood; // 1-5
  final String emoji;
  final List<String> selectedEmotions; // granular emotion IDs from check-in
  final String? quadrant; // SignalQuadrant name (fire/water/storm/shadow)
  final String? signalId; // MoodSignal id (e.g. 'fire_alive')
  final int? energy; // 1-10
  final int? pleasantness; // 1-10

  const MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.emoji,
    this.selectedEmotions = const [],
    this.quadrant,
    this.signalId,
    this.energy,
    this.pleasantness,
  });

  /// Whether this entry was logged via the new signal system
  bool get hasSignal => signalId != null;

  MoodEntry copyWith({
    List<String>? selectedEmotions,
    String? quadrant,
    String? signalId,
    int? energy,
    int? pleasantness,
  }) => MoodEntry(
    id: id,
    date: date,
    mood: mood,
    emoji: emoji,
    selectedEmotions: selectedEmotions ?? this.selectedEmotions,
    quadrant: quadrant ?? this.quadrant,
    signalId: signalId ?? this.signalId,
    energy: energy ?? this.energy,
    pleasantness: pleasantness ?? this.pleasantness,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'mood': mood,
    'emoji': emoji,
    if (selectedEmotions.isNotEmpty) 'selected_emotions': selectedEmotions,
    if (quadrant != null) 'quadrant': quadrant,
    if (signalId != null) 'signal_id': signalId,
    if (energy != null) 'energy': energy,
    if (pleasantness != null) 'pleasantness': pleasantness,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    // Backward-compatible: generate UUID if id missing (old data)
    id: json['id'] as String? ?? const Uuid().v4(),
    date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    mood: json['mood'] as int? ?? 3,
    emoji: json['emoji'] as String? ?? '',
    selectedEmotions: (json['selected_emotions'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [],
    quadrant: json['quadrant'] as String?,
    signalId: json['signal_id'] as String?,
    energy: json['energy'] as int?,
    pleasantness: json['pleasantness'] as int?,
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

  /// Log today's mood (legacy 5-emoji path)
  Future<void> logMood(int mood, String emoji, {List<String> selectedEmotions = const []}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Remove existing entry for today
    _entries.removeWhere(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );

    final entry = MoodEntry(
      id: _uuid.v4(),
      date: today,
      mood: mood,
      emoji: emoji,
      selectedEmotions: selectedEmotions,
    );
    _entries.insert(0, entry);

    // Keep last 90 days
    if (_entries.length > 90) _entries = _entries.sublist(0, 90);
    await _persist();

    // Sync to Supabase
    queueSync('UPSERT', entry.id, _buildSyncPayload(entry, today));
  }

  /// Log today's mood via signal system (quadrant + signal selection)
  Future<void> logSignal(String signalId) async {
    final signal = getSignalById(signalId);
    if (signal == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Remove existing entry for today
    _entries.removeWhere(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );

    final entry = MoodEntry(
      id: _uuid.v4(),
      date: today,
      mood: signal.backwardCompatMood,
      emoji: signal.emoji,
      quadrant: signal.quadrant.name,
      signalId: signal.id,
      energy: signal.defaultEnergy,
      pleasantness: signal.defaultPleasantness,
    );
    _entries.insert(0, entry);

    if (_entries.length > 90) _entries = _entries.sublist(0, 90);
    await _persist();

    queueSync('UPSERT', entry.id, _buildSyncPayload(entry, today));
  }

  /// Get quadrant distribution over the last N days
  Map<String, int> getQuadrantDistribution(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final counts = <String, int>{};
    for (final e in _entries) {
      if (e.date.isAfter(cutoff) && e.quadrant != null) {
        counts[e.quadrant!] = (counts[e.quadrant!] ?? 0) + 1;
      }
    }
    return counts;
  }

  Map<String, dynamic> _buildSyncPayload(MoodEntry entry, DateTime today) {
    return {
      'id': entry.id,
      'date':
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
      'mood': entry.mood,
      'emoji': entry.emoji,
      if (entry.selectedEmotions.isNotEmpty) 'selected_emotions': entry.selectedEmotions,
      if (entry.quadrant != null) 'quadrant': entry.quadrant,
      if (entry.signalId != null) 'signal_id': entry.signalId,
      if (entry.energy != null) 'energy': entry.energy,
      if (entry.pleasantness != null) 'pleasantness': entry.pleasantness,
    };
  }

  /// Update today's mood entry with granular emotion selections
  Future<void> updateSelectedEmotions(List<String> emotionIds) async {
    final now = DateTime.now();
    final todayIdx = _entries.indexWhere(
      (e) =>
          e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day,
    );
    if (todayIdx < 0) return;

    final updated = _entries[todayIdx].copyWith(selectedEmotions: emotionIds);
    _entries[todayIdx] = updated;
    await _persist();

    // Sync updated emotions to Supabase
    queueSync('UPSERT', updated.id, _buildSyncPayload(updated, updated.date));
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

  // ══════════════════════════════════════════════════════════════════════════
  // REMOTE MERGE
  // ══════════════════════════════════════════════════════════════════════════

  /// Merge entries pulled from Supabase into local storage.
  Future<void> mergeRemoteMoods(List<Map<String, dynamic>> remoteData) async {
    for (final row in remoteData) {
      final id = (row['id'] as String?) ?? '';
      final isDeleted = row['is_deleted'] as bool? ?? false;

      if (isDeleted) {
        _entries.removeWhere((e) => e.id == id);
        continue;
      }

      final entry = MoodEntry(
        id: id,
        date:
            DateTime.tryParse(row['date']?.toString() ?? '') ?? DateTime.now(),
        mood: row['mood'] as int? ?? 3,
        emoji: row['emoji'] as String? ?? '',
        selectedEmotions: (row['selected_emotions'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        quadrant: row['quadrant'] as String?,
        signalId: row['signal_id'] as String?,
        energy: row['energy'] as int?,
        pleasantness: row['pleasantness'] as int?,
      );

      final remoteUpdatedAt =
          DateTime.tryParse(row['updated_at']?.toString() ?? '');

      final existingIdx = _entries.indexWhere((e) => e.id == id);
      if (existingIdx >= 0) {
        final localDate = _entries[existingIdx].date;
        if (remoteUpdatedAt == null || remoteUpdatedAt.isAfter(localDate)) {
          _entries[existingIdx] = entry;
        }
      } else {
        _entries.add(entry);
      }
    }
    await _persist();
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
      } catch (e) {
        if (kDebugMode) debugPrint('MoodCheckinService._load: JSON decode failed: $e');
        _entries = [];
      }
    }
  }

  Future<void> _persist() async {
    final jsonList = _entries.map((e) => e.toJson()).toList();
    await _prefs.setString(_key, json.encode(jsonList));
  }
}
