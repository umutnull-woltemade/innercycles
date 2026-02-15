// ════════════════════════════════════════════════════════════════════════════
// CONTEXT MODULE SERVICE - Educational Insight Delivery Engine
// ════════════════════════════════════════════════════════════════════════════
// Provides context-aware educational modules, reading history tracking,
// bookmark management, and focus-area-based module recommendations.
// ════════════════════════════════════════════════════════════════════════════
library;

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../content/context_modules_content.dart';

class ContextModuleService {
  static const String _readHistoryKey = 'context_module_read_history';
  static const String _bookmarksKey = 'context_module_bookmarks';
  static const String _lastDailyKey = 'context_module_last_daily';
  static const String _dailyIdKey = 'context_module_daily_id';

  final SharedPreferences _prefs;

  ContextModuleService(this._prefs);

  /// Initialize service with SharedPreferences
  static Future<ContextModuleService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ContextModuleService(prefs);
  }

  // ═══════════════════════════════════════════════════════════════
  // DAILY MODULE
  // ═══════════════════════════════════════════════════════════════

  /// Get today's featured module using a deterministic date-based hash.
  /// Prefers unread modules. Falls back to rotation.
  ContextModule getDailyModule() {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final lastDaily = _prefs.getString(_lastDailyKey);

    // Return cached daily if still the same day
    if (lastDaily == todayStr) {
      final cachedId = _prefs.getString(_dailyIdKey);
      if (cachedId != null) {
        final cached = getModuleById(cachedId);
        if (cached != null) return cached;
      }
    }

    // Select new daily module
    final dayHash = now.year * 10000 + now.month * 100 + now.day;
    final readIds = _getReadHistory();

    // Prefer unread modules
    final unread =
        allContextModules.where((m) => !readIds.contains(m.id)).toList();
    final pool = unread.isNotEmpty ? unread : allContextModules;

    final index = dayHash % pool.length;
    final selected = pool[index];

    // Cache selection
    _prefs.setString(_lastDailyKey, todayStr);
    _prefs.setString(_dailyIdKey, selected.id);

    return selected;
  }

  // ═══════════════════════════════════════════════════════════════
  // MODULE ACCESS
  // ═══════════════════════════════════════════════════════════════

  /// Get a module by ID
  ContextModule? getModuleById(String id) {
    try {
      return allContextModules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get all modules
  List<ContextModule> getAllModules() => allContextModules;

  /// Get modules by category
  List<ContextModule> getByCategory(ContextModuleCategory category) {
    return allContextModules.where((m) => m.category == category).toList();
  }

  /// Get modules by depth level
  List<ContextModule> getByDepth(ContextModuleDepth depth) {
    return allContextModules.where((m) => m.depth == depth).toList();
  }

  /// Get modules related to a focus area (mood, energy, social, etc.)
  List<ContextModule> getByFocusArea(String focusArea) {
    return allContextModules
        .where((m) => m.relatedFocusAreas.contains(focusArea))
        .toList();
  }

  /// Get related modules for a given module
  List<ContextModule> getRelatedModules(ContextModule module) {
    return module.relatedModuleIds
        .map((id) => getModuleById(id))
        .where((m) => m != null)
        .cast<ContextModule>()
        .toList();
  }

  /// Get a random unread module. Returns any random module if all are read.
  ContextModule getRandomUnread() {
    final readIds = _getReadHistory();
    final unread =
        allContextModules.where((m) => !readIds.contains(m.id)).toList();
    final pool = unread.isNotEmpty ? unread : allContextModules;
    return pool[Random().nextInt(pool.length)];
  }

  // ═══════════════════════════════════════════════════════════════
  // READ HISTORY
  // ═══════════════════════════════════════════════════════════════

  /// Mark a module as read
  Future<void> markAsRead(String id) async {
    final history = _getReadHistory();
    history.add(id);
    await _prefs.setStringList(_readHistoryKey, history.toList());
  }

  /// Check if a module has been read
  bool isRead(String id) => _getReadHistory().contains(id);

  /// Get reading progress as a fraction (0.0 to 1.0)
  double get readProgress {
    final readCount = _getReadHistory().length;
    return allContextModules.isEmpty
        ? 0.0
        : (readCount / allContextModules.length).clamp(0.0, 1.0);
  }

  /// Get count of read modules
  int get readCount => _getReadHistory().length;

  /// Get total module count
  int get totalCount => allContextModules.length;

  Set<String> _getReadHistory() {
    final list = _prefs.getStringList(_readHistoryKey) ?? [];
    return list.toSet();
  }

  // ═══════════════════════════════════════════════════════════════
  // BOOKMARKS
  // ═══════════════════════════════════════════════════════════════

  /// Toggle bookmark state for a module. Returns new bookmark state.
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

  /// Check if a module is bookmarked
  bool isBookmarked(String id) => _getBookmarkIds().contains(id);

  /// Get all bookmarked modules
  List<ContextModule> getBookmarked() {
    final bookmarkIds = _getBookmarkIds();
    return allContextModules
        .where((m) => bookmarkIds.contains(m.id))
        .toList();
  }

  Set<String> _getBookmarkIds() {
    final list = _prefs.getStringList(_bookmarksKey) ?? [];
    return list.toSet();
  }

  // ═══════════════════════════════════════════════════════════════
  // SMART RECOMMENDATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Get contextual recommendations based on a focus area and current mood.
  /// Returns up to [limit] modules sorted by relevance.
  List<ContextModule> getRecommendations({
    String? focusArea,
    ContextModuleDepth? preferredDepth,
    int limit = 3,
  }) {
    var pool = List<ContextModule>.from(allContextModules);
    final readIds = _getReadHistory();

    // Score each module
    final scored = pool.map((m) {
      int score = 0;

      // Unread bonus
      if (!readIds.contains(m.id)) score += 3;

      // Focus area match bonus
      if (focusArea != null && m.relatedFocusAreas.contains(focusArea)) {
        score += 5;
      }

      // Depth preference bonus
      if (preferredDepth != null && m.depth == preferredDepth) {
        score += 2;
      }

      return MapEntry(m, score);
    }).toList();

    // Sort by score descending
    scored.sort((a, b) => b.value.compareTo(a.value));

    return scored.take(limit).map((e) => e.key).toList();
  }

  /// Serialize read/bookmark data for export
  Map<String, dynamic> exportData() {
    return {
      'readHistory': _getReadHistory().toList(),
      'bookmarks': _getBookmarkIds().toList(),
    };
  }

  /// Import read/bookmark data
  Future<void> importData(Map<String, dynamic> data) async {
    if (data['readHistory'] is List) {
      final history = (data['readHistory'] as List).cast<String>();
      await _prefs.setStringList(_readHistoryKey, history);
    }
    if (data['bookmarks'] is List) {
      final bookmarks = (data['bookmarks'] as List).cast<String>();
      await _prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }
}
