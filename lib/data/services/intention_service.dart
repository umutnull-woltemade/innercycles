// ════════════════════════════════════════════════════════════════════════════
// INTENTION SERVICE - Weekly intentions with self-rating
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/intention.dart';

class IntentionService {
  static const String _storageKey = 'inner_cycles_intentions';
  static const _uuid = Uuid();

  final SharedPreferences _prefs;
  List<Intention> _intentions = [];

  IntentionService._(this._prefs) {
    _load();
  }

  static Future<IntentionService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return IntentionService._(prefs);
  }

  /// Current ISO week key
  static String currentWeekKey() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final weekNum = ((dayOfYear - now.weekday + 10) / 7).floor();
    return '${now.year}-W${weekNum.toString().padLeft(2, '0')}';
  }

  /// Create a new intention for current week
  Future<Intention> addIntention(String text) async {
    final intention = Intention(
      id: _uuid.v4(),
      text: text,
      weekKey: currentWeekKey(),
      createdAt: DateTime.now(),
    );
    _intentions.add(intention);
    await _persist();
    return intention;
  }

  /// Rate an intention (1-5)
  Future<void> rateIntention(String id, int rating) async {
    final idx = _intentions.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    _intentions[idx] = _intentions[idx].copyWith(selfRating: rating);
    await _persist();
  }

  /// Deactivate an intention
  Future<void> deactivate(String id) async {
    final idx = _intentions.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    _intentions[idx] = _intentions[idx].copyWith(isActive: false);
    await _persist();
  }

  /// Delete an intention
  Future<void> delete(String id) async {
    _intentions.removeWhere((i) => i.id == id);
    await _persist();
  }

  /// Get current week's active intentions
  List<Intention> getCurrentWeekIntentions() {
    final key = currentWeekKey();
    return _intentions
        .where((i) => i.weekKey == key && i.isActive)
        .toList();
  }

  /// Get all intentions for a week
  List<Intention> getIntentionsForWeek(String weekKey) {
    return _intentions.where((i) => i.weekKey == weekKey).toList();
  }

  /// Get weekly averages for last N weeks (for sparkline)
  List<double> getWeeklyAverages({int weeks = 12}) {
    final now = DateTime.now();
    final averages = <double>[];

    for (int w = weeks - 1; w >= 0; w--) {
      final date = now.subtract(Duration(days: w * 7));
      final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
      final weekNum = ((dayOfYear - date.weekday + 10) / 7).floor();
      final key = '${date.year}-W${weekNum.toString().padLeft(2, '0')}';

      final weekIntentions = _intentions.where((i) => i.weekKey == key);
      final rated = weekIntentions.where((i) => i.selfRating != null);
      if (rated.isEmpty) {
        averages.add(0);
      } else {
        averages.add(
            rated.fold<int>(0, (s, i) => s + i.selfRating!) / rated.length);
      }
    }
    return averages;
  }

  /// Whether current week needs rating (it's Sunday and there are unrated intentions)
  bool get needsWeeklyRating {
    final now = DateTime.now();
    if (now.weekday != DateTime.sunday) return false;
    final current = getCurrentWeekIntentions();
    return current.isNotEmpty && current.any((i) => i.selfRating == null);
  }

  /// Total intentions count
  int get totalCount => _intentions.length;

  /// Weeks with at least one intention
  int get activeWeeksCount {
    final weeks = _intentions.map((i) => i.weekKey).toSet();
    return weeks.length;
  }

  void _load() {
    final json = _prefs.getString(_storageKey);
    if (json != null) {
      try {
        final list = jsonDecode(json) as List;
        _intentions = list
            .map((e) {
              try {
                return Intention.fromJson(e as Map<String, dynamic>);
              } catch (_) {
                return null;
              }
            })
            .whereType<Intention>()
            .toList();
      } catch (_) {
        _intentions = [];
      }
    }
  }

  Future<void> _persist() async {
    await _prefs.setString(
      _storageKey,
      jsonEncode(_intentions.map((i) => i.toJson()).toList()),
    );
  }
}
