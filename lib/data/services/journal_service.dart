// ════════════════════════════════════════════════════════════════════════════
// JOURNAL SERVICE - InnerCycles Personal Cycle Tracking
// ════════════════════════════════════════════════════════════════════════════
// Provides CRUD operations, streak tracking, and date-range queries
// for journal entries. Uses SharedPreferences for persistence.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';
import '../mixins/supabase_sync_mixin.dart';

class JournalService with SupabaseSyncMixin {
  static const String _storageKey = 'inner_cycles_journal_entries';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<JournalEntry> _entries = [];
  List<JournalEntry>? _sortedCache;

  @override
  String get tableName => 'journal_entries';

  JournalService._(this._prefs) {
    _loadEntries();
  }

  /// Initialize the journal service
  static Future<JournalService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return JournalService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CRUD OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  /// Save a new journal entry
  Future<JournalEntry> saveEntry({
    required DateTime date,
    required FocusArea focusArea,
    required int overallRating,
    Map<String, int> subRatings = const {},
    String? note,
    String? imagePath,
    List<String> tags = const [],
    bool isPrivate = false,
  }) async {
    final entry = JournalEntry(
      id: _uuid.v4(),
      date: date,
      createdAt: DateTime.now(),
      focusArea: focusArea,
      overallRating: overallRating.clamp(1, 5),
      subRatings: subRatings.map((k, v) => MapEntry(k, v.clamp(1, 5))),
      note: note,
      imagePath: imagePath,
      tags: tags,
      isPrivate: isPrivate,
    );

    _entries.add(entry);
    _sortedCache = null;
    await _persistEntries();

    // Sync to Supabase
    queueSync('UPSERT', entry.id, {
      'id': entry.id,
      'date': entry.dateKey,
      'focus_area': entry.focusArea.name,
      'overall_rating': entry.overallRating,
      'sub_ratings': entry.subRatings,
      'note': entry.note,
      'image_path': entry.imagePath,
      'tags': entry.tags,
      'is_private': entry.isPrivate,
    });

    return entry;
  }

  /// Delete an entry by ID
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    _sortedCache = null;
    await _persistEntries();

    // Soft-delete remotely
    queueSoftDelete(id);
  }

  /// Get a single entry by ID
  JournalEntry? getEntry(String id) {
    return _entries.where((e) => e.id == id).firstOrNull;
  }

  /// Get all non-private entries, sorted by date descending (cached)
  List<JournalEntry> getAllEntries() {
    if (_sortedCache != null) return List.unmodifiable(_sortedCache!);
    final sorted = List<JournalEntry>.from(
      _entries.where((e) => !e.isPrivate),
    )..sort((a, b) => b.date.compareTo(a.date));
    _sortedCache = sorted;
    return List.unmodifiable(sorted);
  }

  /// Get only private (vault) entries, sorted by date descending
  List<JournalEntry> getPrivateEntries() {
    return List.unmodifiable(
      List<JournalEntry>.from(_entries.where((e) => e.isPrivate))
        ..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ══════════════════════════════════════════════════════════════════════════

  /// Get entries within a date range (inclusive), excluding private entries
  List<JournalEntry> getEntriesByDateRange(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return _entries
        .where((e) =>
            !e.isPrivate &&
            !e.date.isBefore(startDay) &&
            !e.date.isAfter(endDay))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get today's entry (if exists)
  JournalEntry? getTodayEntry() {
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return _entries.where((e) => e.dateKey == todayKey).firstOrNull;
  }

  /// Check if user has logged today
  bool hasLoggedToday() => getTodayEntry() != null;

  /// Get total entry count
  int get entryCount => _entries.length;

  /// Get entries for a specific month
  List<JournalEntry> getEntriesForMonth(int year, int month) {
    return _entries
        .where((e) => e.date.year == year && e.date.month == month)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get the most recent N entries
  List<JournalEntry> getRecentEntries(int count) {
    final sorted = getAllEntries();
    return sorted.take(count).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SEARCH & TAGS
  // ══════════════════════════════════════════════════════════════════════════

  /// Full-text search across note content, tags, and focus area display names
  List<JournalEntry> searchEntries(String query) {
    final q = query.toLowerCase();
    return _entries
        .where(
          (e) =>
              (e.note?.toLowerCase().contains(q) ?? false) ||
              e.tags.any((t) => t.toLowerCase().contains(q)) ||
              e.focusArea.displayNameEn.toLowerCase().contains(q) ||
              e.focusArea.displayNameTr.toLowerCase().contains(q) ||
              e.focusArea.name.toLowerCase().contains(q),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get all unique tags across all journal entries
  List<String> getAllTags() {
    final tagSet = <String>{};
    for (final entry in _entries) {
      tagSet.addAll(entry.tags);
    }
    return tagSet.toList()..sort();
  }

  /// Get entries by specific tag
  List<JournalEntry> getEntriesByTag(String tag) {
    final t = tag.toLowerCase();
    return _entries
        .where((e) => e.tags.any((et) => et.toLowerCase() == t))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get most frequently used tags (for suggestions)
  List<String> getFrequentTags({int limit = 10}) {
    final tagCounts = <String, int>{};
    for (final entry in _entries) {
      for (final tag in entry.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    final sorted = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).map((e) => e.key).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STREAK CALCULATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Get the current consecutive-day streak
  int getCurrentStreak() {
    if (_entries.isEmpty) return 0;

    // Get unique dates sorted descending
    final uniqueDates = _entries.map((e) => e.dateKey).toSet().toList()..sort();
    uniqueDates.sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayKey =
        '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    // Streak must include today or yesterday
    if (!uniqueDates.contains(todayKey) &&
        !uniqueDates.contains(yesterdayKey)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = uniqueDates.contains(todayKey) ? today : yesterday;

    for (int i = 0; i < 365; i++) {
      final key =
          '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
      if (uniqueDates.contains(key)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  /// Get the longest streak ever
  int getLongestStreak() {
    if (_entries.isEmpty) return 0;

    final uniqueDates = _entries.map((e) => e.dateKey).toSet().toList()..sort();

    int longest = 1;
    int current = 1;

    for (int i = 1; i < uniqueDates.length; i++) {
      final prev = DateTime.tryParse(uniqueDates[i - 1]);
      final curr = DateTime.tryParse(uniqueDates[i]);
      if (prev == null || curr == null) continue;
      final diff = curr.difference(prev).inDays;

      if (diff == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }

    return longest;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REMOTE MERGE
  // ══════════════════════════════════════════════════════════════════════════

  /// Merge entries pulled from Supabase into local storage.
  Future<void> mergeRemoteEntries(List<Map<String, dynamic>> remoteData) async {
    for (final row in remoteData) {
      final id = row['id'] as String;
      final isDeleted = row['is_deleted'] as bool? ?? false;

      if (isDeleted) {
        _entries.removeWhere((e) => e.id == id);
        continue;
      }

      final entry = JournalEntry(
        id: id,
        date:
            DateTime.tryParse(row['date']?.toString() ?? '') ?? DateTime.now(),
        createdAt:
            DateTime.tryParse(row['created_at']?.toString() ?? '') ??
            DateTime.now(),
        focusArea: FocusArea.values.firstWhere(
          (f) => f.name == row['focus_area'],
          orElse: () => FocusArea.emotions,
        ),
        overallRating: row['overall_rating'] as int? ?? 3,
        subRatings: row['sub_ratings'] is Map
            ? Map<String, int>.from(
                (row['sub_ratings'] as Map).map(
                  (k, v) => MapEntry(k.toString(), v as int),
                ),
              )
            : {},
        note: row['note'] as String?,
        imagePath: row['image_path'] as String?,
        tags: (row['tags'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        isPrivate: row['is_private'] as bool? ?? false,
      );

      final existingIdx = _entries.indexWhere((e) => e.id == id);
      if (existingIdx >= 0) {
        _entries[existingIdx] = entry;
      } else {
        _entries.add(entry);
      }
    }

    _sortedCache = null;
    await _persistEntries();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadEntries() {
    _sortedCache = null;
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _entries = jsonList.map((j) => JournalEntry.fromJson(j)).toList();
      } catch (e) {
        debugPrint('JournalService._loadEntries: JSON decode failed: $e');
        _entries = [];
      }
    }
  }

  Future<void> _persistEntries() async {
    final jsonList = _entries.map((e) => e.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));
  }

  /// Clear all journal data
  Future<void> clearAll() async {
    _entries.clear();
    await _prefs.remove(_storageKey);
  }
}
