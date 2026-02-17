// ════════════════════════════════════════════════════════════════════════════
// HABIT SUGGESTION SERVICE - Daily Micro-Habit Delivery Engine
// ════════════════════════════════════════════════════════════════════════════
// Provides daily habit rotation, adoption tracking, bookmarks, and
// category-based browsing for 56 evidence-based micro-habits.
// ════════════════════════════════════════════════════════════════════════════
library;

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../content/habit_suggestions_content.dart';

class HabitSuggestionService {
  static const String _triedKey = 'habit_tried_ids';
  static const String _adoptedKey = 'habit_adopted_ids';
  static const String _bookmarksKey = 'habit_bookmarks';
  static const String _lastDailyKey = 'habit_last_daily_date';
  static const String _dailyIdKey = 'habit_daily_id';

  final SharedPreferences _prefs;

  HabitSuggestionService(this._prefs);

  static Future<HabitSuggestionService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return HabitSuggestionService(prefs);
  }

  // ═══════════════════════════════════════════════════════════════
  // CATEGORIES
  // ═══════════════════════════════════════════════════════════════

  static const List<String> categories = [
    'morning',
    'evening',
    'mindfulness',
    'social',
    'creative',
    'physical',
    'reflective',
  ];

  static String categoryDisplayNameEn(String category) {
    switch (category) {
      case 'morning':
        return 'Morning';
      case 'evening':
        return 'Evening';
      case 'mindfulness':
        return 'Mindfulness';
      case 'social':
        return 'Social';
      case 'creative':
        return 'Creative';
      case 'physical':
        return 'Physical';
      case 'reflective':
        return 'Reflective';
      default:
        return category;
    }
  }

  static String categoryDisplayNameTr(String category) {
    switch (category) {
      case 'morning':
        return 'Sabah';
      case 'evening':
        return 'Akşam';
      case 'mindfulness':
        return 'Farkındalık';
      case 'social':
        return 'Sosyal';
      case 'creative':
        return 'Yaratıcı';
      case 'physical':
        return 'Fiziksel';
      case 'reflective':
        return 'Düşünsel';
      default:
        return category;
    }
  }

  static String categoryEmoji(String category) {
    switch (category) {
      case 'morning':
        return '🌅';
      case 'evening':
        return '🌙';
      case 'mindfulness':
        return '🧘';
      case 'social':
        return '💬';
      case 'creative':
        return '🎨';
      case 'physical':
        return '🏃';
      case 'reflective':
        return '🪞';
      default:
        return '✨';
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DAILY HABIT
  // ═══════════════════════════════════════════════════════════════

  HabitSuggestion getDailyHabit() {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final lastDaily = _prefs.getString(_lastDailyKey);

    if (lastDaily == todayStr) {
      final cachedId = _prefs.getString(_dailyIdKey);
      if (cachedId != null) {
        final cached = getHabitById(cachedId);
        if (cached != null) return cached;
      }
    }

    final dayHash = now.year * 10000 + now.month * 100 + now.day;
    final triedIds = _getTriedIds();

    // Prefer untried habits
    final untried =
        allHabitSuggestions.where((h) => !triedIds.contains(h.id)).toList();
    final pool = untried.isNotEmpty ? untried : allHabitSuggestions;

    final index = dayHash % pool.length;
    final selected = pool[index];

    _prefs.setString(_lastDailyKey, todayStr);
    _prefs.setString(_dailyIdKey, selected.id);

    return selected;
  }

  // ═══════════════════════════════════════════════════════════════
  // HABIT ACCESS
  // ═══════════════════════════════════════════════════════════════

  HabitSuggestion? getHabitById(String id) {
    try {
      return allHabitSuggestions.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  List<HabitSuggestion> getAllHabits() => allHabitSuggestions;

  List<HabitSuggestion> getByCategory(String category) {
    return allHabitSuggestions.where((h) => h.category == category).toList();
  }

  HabitSuggestion getRandomFromCategory(String category) {
    final pool = getByCategory(category);
    return pool[Random().nextInt(pool.length)];
  }

  // ═══════════════════════════════════════════════════════════════
  // TRIED / ADOPTED TRACKING
  // ═══════════════════════════════════════════════════════════════

  Future<void> markAsTried(String id) async {
    final tried = _getTriedIds();
    tried.add(id);
    await _prefs.setStringList(_triedKey, tried.toList());
  }

  Future<void> markAsAdopted(String id) async {
    final adopted = _getAdoptedIds();
    adopted.add(id);
    await _prefs.setStringList(_adoptedKey, adopted.toList());
    // Also mark as tried
    await markAsTried(id);
  }

  Future<void> removeAdopted(String id) async {
    final adopted = _getAdoptedIds();
    adopted.remove(id);
    await _prefs.setStringList(_adoptedKey, adopted.toList());
  }

  bool isTried(String id) => _getTriedIds().contains(id);
  bool isAdopted(String id) => _getAdoptedIds().contains(id);

  int get triedCount => _getTriedIds().length;
  int get adoptedCount => _getAdoptedIds().length;
  int get totalCount => allHabitSuggestions.length;

  double get explorationProgress {
    return allHabitSuggestions.isEmpty
        ? 0.0
        : (_getTriedIds().length / allHabitSuggestions.length).clamp(0.0, 1.0);
  }

  List<HabitSuggestion> getAdoptedHabits() {
    final adoptedIds = _getAdoptedIds();
    return allHabitSuggestions
        .where((h) => adoptedIds.contains(h.id))
        .toList();
  }

  Set<String> _getTriedIds() {
    final list = _prefs.getStringList(_triedKey) ?? [];
    return list.toSet();
  }

  Set<String> _getAdoptedIds() {
    final list = _prefs.getStringList(_adoptedKey) ?? [];
    return list.toSet();
  }

  // ═══════════════════════════════════════════════════════════════
  // BOOKMARKS
  // ═══════════════════════════════════════════════════════════════

  Future<bool> toggleBookmark(String id) async {
    final bookmarks = _getBookmarkIds();
    final isNowBookmarked = !bookmarks.contains(id);

    if (isNowBookmarked) {
      bookmarks.add(id);
    } else {
      bookmarks.remove(id);
    }

    await _prefs.setStringList(_bookmarksKey, bookmarks.toList());
    return isNowBookmarked;
  }

  bool isBookmarked(String id) => _getBookmarkIds().contains(id);

  List<HabitSuggestion> getBookmarked() {
    final bookmarkIds = _getBookmarkIds();
    return allHabitSuggestions
        .where((h) => bookmarkIds.contains(h.id))
        .toList();
  }

  Set<String> _getBookmarkIds() {
    final list = _prefs.getStringList(_bookmarksKey) ?? [];
    return list.toSet();
  }

  // ═══════════════════════════════════════════════════════════════
  // QUICK HABITS (short duration)
  // ═══════════════════════════════════════════════════════════════

  List<HabitSuggestion> getQuickHabits({int maxMinutes = 3}) {
    return allHabitSuggestions
        .where((h) => h.durationMinutes <= maxMinutes)
        .toList();
  }

  // ═══════════════════════════════════════════════════════════════
  // DAILY CHECK-OFF TRACKING (for adopted habits)
  // ═══════════════════════════════════════════════════════════════

  static const String _dailyCheckPrefix = 'habit_daily_check_';

  String _checkKey(String habitId) => '$_dailyCheckPrefix$habitId';

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Check off a habit for today
  Future<void> checkOffToday(String habitId) async {
    final dates = _getCheckDates(habitId);
    final today = _todayKey();
    if (!dates.contains(today)) {
      dates.add(today);
      await _prefs.setStringList(_checkKey(habitId), dates);
    }
  }

  /// Uncheck a habit for today
  Future<void> uncheckToday(String habitId) async {
    final dates = _getCheckDates(habitId);
    dates.remove(_todayKey());
    await _prefs.setStringList(_checkKey(habitId), dates);
  }

  /// Check if a habit is checked off today
  bool isCheckedToday(String habitId) {
    return _getCheckDates(habitId).contains(_todayKey());
  }

  /// Get all dates a habit was checked off
  List<String> _getCheckDates(String habitId) {
    return _prefs.getStringList(_checkKey(habitId)) ?? [];
  }

  /// Get current streak for a habit
  int getHabitStreak(String habitId) {
    final dates = _getCheckDates(habitId);
    if (dates.isEmpty) return 0;

    dates.sort();
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final key =
          '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';
      if (dates.contains(key)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Get total completions for a habit
  int getTotalCompletions(String habitId) {
    return _getCheckDates(habitId).length;
  }

  /// Get completions in the last 7 days for a habit (returns list of booleans, Mon-Sun)
  List<bool> getWeekCompletions(String habitId) {
    final dates = _getCheckDates(habitId).toSet();
    final today = DateTime.now();
    final result = <bool>[];

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      result.add(dates.contains(key));
    }
    return result;
  }

  /// Get count of adopted habits checked off today
  int get todayCompletedCount {
    final adopted = _getAdoptedIds();
    return adopted.where((id) => isCheckedToday(id)).length;
  }

  /// Get total adopted habits count
  int get todayTotalAdopted => _getAdoptedIds().length;
}
