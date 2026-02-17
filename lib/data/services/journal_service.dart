// ════════════════════════════════════════════════════════════════════════════
// JOURNAL SERVICE - InnerCycles Personal Cycle Tracking
// ════════════════════════════════════════════════════════════════════════════
// Provides CRUD operations, streak tracking, and date-range queries
// for journal entries. Uses SharedPreferences for persistence.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';

class JournalService {
  static const String _storageKey = 'inner_cycles_journal_entries';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<JournalEntry> _entries = [];

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
    );

    _entries.add(entry);
    await _persistEntries();
    return entry;
  }

  /// Update an existing entry
  Future<void> updateEntry(JournalEntry updated) async {
    final index = _entries.indexWhere((e) => e.id == updated.id);
    if (index >= 0) {
      _entries[index] = updated;
      await _persistEntries();
    }
  }

  /// Delete an entry by ID
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _persistEntries();
  }

  /// Get a single entry by ID
  JournalEntry? getEntry(String id) {
    try {
      return _entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get all entries, sorted by date descending
  List<JournalEntry> getAllEntries() {
    final sorted = List<JournalEntry>.from(_entries);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ══════════════════════════════════════════════════════════════════════════

  /// Get entries within a date range (inclusive)
  List<JournalEntry> getEntriesByDateRange(DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day, 23, 59, 59);
    return _entries
        .where((e) => !e.date.isBefore(startDay) && !e.date.isAfter(endDay))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get entries filtered by focus area
  List<JournalEntry> getEntriesByFocusArea(FocusArea area) {
    return _entries.where((e) => e.focusArea == area).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get today's entry (if exists)
  JournalEntry? getTodayEntry() {
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    try {
      return _entries.firstWhere((e) => e.dateKey == todayKey);
    } catch (_) {
      return null;
    }
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
    DateTime checkDate =
        uniqueDates.contains(todayKey) ? today : yesterday;

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
      final prev = DateTime.parse(uniqueDates[i - 1]);
      final curr = DateTime.parse(uniqueDates[i]);
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
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadEntries() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _entries =
            jsonList.map((j) => JournalEntry.fromJson(j)).toList();
      } catch (_) {
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
