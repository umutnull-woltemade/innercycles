// ════════════════════════════════════════════════════════════════════════════
// RITUAL SERVICE - InnerCycles Habit Stacking Tracker
// ════════════════════════════════════════════════════════════════════════════
// Custom ritual stacks (Morning/Midday/Evening) with check-off tracking.
// Correlates ritual completion with focus area ratings via PatternEngine.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Time of day for a ritual stack
enum RitualTime { morning, midday, evening }

extension RitualTimeExtension on RitualTime {
  String get displayNameEn {
    switch (this) {
      case RitualTime.morning:
        return 'Morning';
      case RitualTime.midday:
        return 'Midday';
      case RitualTime.evening:
        return 'Evening';
    }
  }

  String get displayNameTr {
    switch (this) {
      case RitualTime.morning:
        return 'Sabah';
      case RitualTime.midday:
        return 'Öğle';
      case RitualTime.evening:
        return 'Akşam';
    }
  }

  String get icon {
    switch (this) {
      case RitualTime.morning:
        return '🌅';
      case RitualTime.midday:
        return '☀️';
      case RitualTime.evening:
        return '🌙';
    }
  }
}

/// A single ritual item within a stack
class RitualItem {
  final String id;
  final String name;
  final int order;

  const RitualItem({
    required this.id,
    required this.name,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'order': order,
      };

  factory RitualItem.fromJson(Map<String, dynamic> json) => RitualItem(
        id: json['id'] as String,
        name: json['name'] as String,
        order: json['order'] as int? ?? 0,
      );
}

/// A ritual stack (e.g., Morning routine with 3-5 items)
class RitualStack {
  final String id;
  final RitualTime time;
  final String name;
  final List<RitualItem> items;
  final DateTime createdAt;

  const RitualStack({
    required this.id,
    required this.time,
    required this.name,
    required this.items,
    required this.createdAt,
  });

  RitualStack copyWith({String? name, List<RitualItem>? items}) => RitualStack(
        id: id,
        time: time,
        name: name ?? this.name,
        items: items ?? this.items,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': time.name,
        'name': name,
        'items': items.map((i) => i.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory RitualStack.fromJson(Map<String, dynamic> json) => RitualStack(
        id: json['id'] as String,
        time: RitualTime.values.firstWhere(
          (t) => t.name == json['time'],
          orElse: () => RitualTime.morning,
        ),
        name: json['name'] as String,
        items: (json['items'] as List<dynamic>)
            .map((i) => RitualItem.fromJson(i))
            .toList(),
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      );
}

/// Daily ritual completion record
class RitualCompletion {
  final String dateKey;
  final String stackId;
  final Set<String> completedItemIds;
  final DateTime updatedAt;

  RitualCompletion({
    required this.dateKey,
    required this.stackId,
    required this.completedItemIds,
    required this.updatedAt,
  });

  bool get isFullyComplete => completedItemIds.isNotEmpty;

  double completionRate(int totalItems) {
    if (totalItems == 0) return 0;
    return completedItemIds.length / totalItems;
  }

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'stackId': stackId,
        'completedItemIds': completedItemIds.toList(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory RitualCompletion.fromJson(Map<String, dynamic> json) =>
      RitualCompletion(
        dateKey: json['dateKey'] as String,
        stackId: json['stackId'] as String,
        completedItemIds:
            (json['completedItemIds'] as List<dynamic>).cast<String>().toSet(),
        updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      );
}

/// Daily ritual summary for home screen
class DailyRitualSummary {
  final int totalItems;
  final int completedItems;
  final Map<RitualTime, double> completionByTime; // time -> 0.0-1.0

  const DailyRitualSummary({
    required this.totalItems,
    required this.completedItems,
    required this.completionByTime,
  });

  double get overallCompletion =>
      totalItems == 0 ? 0 : completedItems / totalItems;
}

class RitualService {
  static const String _stacksKey = 'inner_cycles_ritual_stacks';
  static const String _completionsKey = 'inner_cycles_ritual_completions';
  static const int _freeMaxStacks = 1;
  static const int _premiumMaxStacks = 3;
  static const int _freeMaxItems = 3;
  static const int _premiumMaxItems = 5;

  final SharedPreferences _prefs;
  List<RitualStack> _stacks = [];
  Map<String, RitualCompletion> _completions = {}; // "dateKey:stackId" -> comp

  RitualService._(this._prefs) {
    _loadStacks();
    _loadCompletions();
  }

  static Future<RitualService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return RitualService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STACK MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  List<RitualStack> getStacks() => List.unmodifiable(_stacks);

  int get stackCount => _stacks.length;

  bool canAddStack({bool isPremium = false}) {
    final max = isPremium ? _premiumMaxStacks : _freeMaxStacks;
    return _stacks.length < max;
  }

  int maxItems({bool isPremium = false}) =>
      isPremium ? _premiumMaxItems : _freeMaxItems;

  Future<RitualStack> createStack({
    required RitualTime time,
    required String name,
    required List<String> itemNames,
    bool isPremium = false,
  }) async {
    final maxI = maxItems(isPremium: isPremium);
    final clampedItems = itemNames.take(maxI).toList();

    final stack = RitualStack(
      id: '${time.name}_${DateTime.now().millisecondsSinceEpoch}',
      time: time,
      name: name,
      items: clampedItems
          .asMap()
          .entries
          .map((e) => RitualItem(
                id: '${time.name}_item_${e.key}',
                name: e.value,
                order: e.key,
              ))
          .toList(),
      createdAt: DateTime.now(),
    );

    _stacks.add(stack);
    await _persistStacks();
    return stack;
  }

  Future<void> updateStack(RitualStack updated) async {
    final index = _stacks.indexWhere((s) => s.id == updated.id);
    if (index >= 0) {
      _stacks[index] = updated;
      await _persistStacks();
    }
  }

  Future<void> deleteStack(String stackId) async {
    _stacks.removeWhere((s) => s.id == stackId);
    // Remove completions for this stack
    _completions.removeWhere((key, _) => key.endsWith(':$stackId'));
    await _persistStacks();
    await _persistCompletions();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DAILY CHECK-OFF
  // ══════════════════════════════════════════════════════════════════════════

  /// Toggle a ritual item for today
  Future<void> toggleItem({
    required String stackId,
    required String itemId,
    DateTime? date,
  }) async {
    final dateKey = _dateToKey(date ?? DateTime.now());
    final key = '$dateKey:$stackId';

    final existing = _completions[key];
    final completedIds = existing?.completedItemIds.toSet() ?? {};

    if (completedIds.contains(itemId)) {
      completedIds.remove(itemId);
    } else {
      completedIds.add(itemId);
    }

    _completions[key] = RitualCompletion(
      dateKey: dateKey,
      stackId: stackId,
      completedItemIds: completedIds,
      updatedAt: DateTime.now(),
    );

    await _persistCompletions();
  }

  /// Check if a specific item is completed today
  bool isItemCompleted({
    required String stackId,
    required String itemId,
    DateTime? date,
  }) {
    final dateKey = _dateToKey(date ?? DateTime.now());
    final key = '$dateKey:$stackId';
    return _completions[key]?.completedItemIds.contains(itemId) ?? false;
  }

  /// Get completion for a specific stack on a date
  RitualCompletion? getCompletion(String stackId, {DateTime? date}) {
    final dateKey = _dateToKey(date ?? DateTime.now());
    return _completions['$dateKey:$stackId'];
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════════════════

  /// Get today's ritual summary
  DailyRitualSummary getTodaySummary() {
    final dateKey = _dateToKey(DateTime.now());
    int totalItems = 0;
    int completedItems = 0;
    final completionByTime = <RitualTime, double>{};

    for (final stack in _stacks) {
      final comp = _completions['$dateKey:${stack.id}'];
      final stackTotal = stack.items.length;
      final stackDone = comp?.completedItemIds.length ?? 0;

      totalItems += stackTotal;
      completedItems += stackDone;

      completionByTime[stack.time] =
          stackTotal == 0 ? 0 : stackDone / stackTotal;
    }

    return DailyRitualSummary(
      totalItems: totalItems,
      completedItems: completedItems,
      completionByTime: completionByTime,
    );
  }

  /// Get completion rate for a date range (for pattern engine)
  double getCompletionRateForRange(DateTime start, DateTime end) {
    int totalItems = 0;
    int completedItems = 0;

    var date = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (!date.isAfter(endDate)) {
      final dateKey = _dateToKey(date);
      for (final stack in _stacks) {
        final comp = _completions['$dateKey:${stack.id}'];
        totalItems += stack.items.length;
        completedItems += comp?.completedItemIds.length ?? 0;
      }
      date = date.add(const Duration(days: 1));
    }

    return totalItems == 0 ? 0 : completedItems / totalItems;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadStacks() {
    final jsonString = _prefs.getString(_stacksKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _stacks = jsonList.map((j) => RitualStack.fromJson(j)).toList();
      } catch (_) {
        _stacks = [];
      }
    }
  }

  Future<void> _persistStacks() async {
    final jsonList = _stacks.map((s) => s.toJson()).toList();
    await _prefs.setString(_stacksKey, json.encode(jsonList));
  }

  void _loadCompletions() {
    final jsonString = _prefs.getString(_completionsKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _completions = jsonMap.map(
          (k, v) => MapEntry(k, RitualCompletion.fromJson(v)),
        );
      } catch (_) {
        _completions = {};
      }
    }
  }

  Future<void> _persistCompletions() async {
    final jsonMap = _completions.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs.setString(_completionsKey, json.encode(jsonMap));
  }

  Future<void> clearAll() async {
    _stacks.clear();
    _completions.clear();
    await _prefs.remove(_stacksKey);
    await _prefs.remove(_completionsKey);
  }

  String _dateToKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
