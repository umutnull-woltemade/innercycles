// ════════════════════════════════════════════════════════════════════════════
// STREAK SERVICE - InnerCycles Consistency & Habit Tracking
// ════════════════════════════════════════════════════════════════════════════
// Manages streak state, freeze mechanics, and milestone celebrations.
// Wraps JournalService streak data with premium features.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'journal_service.dart';

/// Streak milestones that trigger celebrations
const List<int> streakMilestones = [3, 7, 14, 30, 60, 90, 180, 365];

/// A freeze record for streak protection
class StreakFreeze {
  final DateTime date;
  final bool wasAutomatic;

  const StreakFreeze({required this.date, this.wasAutomatic = false});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'wasAutomatic': wasAutomatic,
  };

  factory StreakFreeze.fromJson(Map<String, dynamic> json) => StreakFreeze(
    date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    wasAutomatic: json['wasAutomatic'] as bool? ?? false,
  );

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Streak statistics snapshot
class StreakStats {
  final int currentStreak;
  final int longestStreak;
  final int totalEntries;
  final int freezesUsedThisWeek;
  final int freezesAvailable;
  final int? lastMilestoneReached;
  final int? nextMilestone;
  final List<int> celebratedMilestones;

  const StreakStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalEntries,
    required this.freezesUsedThisWeek,
    required this.freezesAvailable,
    this.lastMilestoneReached,
    this.nextMilestone,
    this.celebratedMilestones = const [],
  });
}

class StreakService {
  static const String _freezeKey = 'inner_cycles_streak_freezes';
  static const String _celebratedKey = 'inner_cycles_celebrated_milestones';
  static const int _freeFreezePerWeek = 1;
  static const int _premiumFreezePerWeek = 3;

  final SharedPreferences _prefs;
  final JournalService _journalService;
  List<StreakFreeze> _freezes = [];
  List<int> _celebratedMilestones = [];

  StreakService._(this._prefs, this._journalService) {
    _loadFreezes();
    _loadCelebratedMilestones();
  }

  static Future<StreakService> init(JournalService journalService) async {
    final prefs = await SharedPreferences.getInstance();
    return StreakService._(prefs, journalService);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STREAK DATA
  // ══════════════════════════════════════════════════════════════════════════

  int getCurrentStreak() => _journalService.getCurrentStreak();
  int getLongestStreak() => _journalService.getLongestStreak();
  int getTotalEntries() => _journalService.entryCount;

  /// Get comprehensive streak stats
  StreakStats getStats({bool isPremium = false}) {
    final current = getCurrentStreak();
    final longest = getLongestStreak();
    final freezesUsed = _freezesUsedThisWeek();
    final maxFreezes = isPremium ? _premiumFreezePerWeek : _freeFreezePerWeek;

    int? lastMilestone;
    int? nextMilestone;
    for (final m in streakMilestones) {
      if (current >= m) {
        lastMilestone = m;
      } else {
        nextMilestone ??= m;
      }
    }

    return StreakStats(
      currentStreak: current,
      longestStreak: longest,
      totalEntries: getTotalEntries(),
      freezesUsedThisWeek: freezesUsed,
      freezesAvailable: (maxFreezes - freezesUsed).clamp(0, maxFreezes),
      lastMilestoneReached: lastMilestone,
      nextMilestone: nextMilestone,
      celebratedMilestones: List.unmodifiable(_celebratedMilestones),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FREEZE MECHANICS
  // ══════════════════════════════════════════════════════════════════════════

  bool canFreeze({bool isPremium = false}) {
    final maxFreezes = isPremium ? _premiumFreezePerWeek : _freeFreezePerWeek;
    return _freezesUsedThisWeek() < maxFreezes;
  }

  Future<bool> useFreeze({bool isPremium = false}) async {
    if (!canFreeze(isPremium: isPremium)) return false;

    final freeze = StreakFreeze(date: DateTime.now());
    _freezes.add(freeze);
    await _persistFreezes();
    return true;
  }

  int _freezesUsedThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    return _freezes.where((f) => !f.date.isBefore(weekStartDay)).length;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MILESTONE CELEBRATIONS
  // ══════════════════════════════════════════════════════════════════════════

  /// Check if there's a new milestone to celebrate
  int? checkForNewMilestone() {
    final current = getCurrentStreak();
    for (final milestone in streakMilestones) {
      if (current >= milestone && !_celebratedMilestones.contains(milestone)) {
        return milestone;
      }
    }
    return null;
  }

  /// Mark a milestone as celebrated
  Future<void> celebrateMilestone(int milestone) async {
    if (!_celebratedMilestones.contains(milestone)) {
      _celebratedMilestones.add(milestone);
      await _persistCelebratedMilestones();
    }
  }

  /// Get the celebration message for a milestone (safe language)
  static String getMilestoneMessageEn(int days) {
    switch (days) {
      case 3:
        return '3-day reflection streak. You\'re building a meaningful practice.';
      case 7:
        return 'One full week of reflection. Your patterns are becoming richer.';
      case 14:
        return 'Two weeks of consistent reflection. That takes real commitment.';
      case 30:
        return '30 days of reflection. That\'s a genuine practice.';
      case 60:
        return '60 days. Your journal is becoming a mirror of growth.';
      case 90:
        return '90 days of reflection. You know yourself better than most.';
      case 180:
        return 'Half a year of daily reflection. That\'s extraordinary.';
      case 365:
        return 'One full year. Your inner cycles tell a remarkable story.';
      default:
        return '$days days of reflection. Your practice continues.';
    }
  }

  static String getMilestoneMessageTr(int days) {
    switch (days) {
      case 3:
        return '3 günlük yansıma serisi. Anlamlı bir pratik oluşturuyorsun.';
      case 7:
        return 'Tam bir hafta yansıma. Kalıpların zenginleşiyor.';
      case 14:
        return 'İki haftalık tutarlı yansıma. Gerçek bir kararlılık.';
      case 30:
        return '30 günlük yansıma. Bu gerçek bir pratik.';
      case 60:
        return '60 gün. Günlüğün bir büyüme aynasına dönüşüyor.';
      case 90:
        return '90 günlük yansıma. Kendini çoğu insandan daha iyi tanıyorsun.';
      case 180:
        return 'Yarım yıl günlük yansıma. Bu olağanüstü.';
      case 365:
        return 'Tam bir yıl. İç döngülerin dikkat çekici bir hikaye anlatıyor.';
      default:
        return '$days günlük yansıma. Pratiğin devam ediyor.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // WEEKLY MINI-CALENDAR DATA
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns a map of the current week's days to whether an entry exists
  Map<DateTime, bool> getWeekCalendar() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final result = <DateTime, bool>{};

    for (int i = 0; i < 7; i++) {
      final day = DateTime(monday.year, monday.month, monday.day + i);
      final entries = _journalService.getEntriesByDateRange(day, day);
      result[day] = entries.isNotEmpty;
    }

    return result;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadFreezes() {
    final jsonString = _prefs.getString(_freezeKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _freezes = jsonList.map((j) => StreakFreeze.fromJson(j)).toList();
      } catch (_) {
        _freezes = [];
      }
    }
  }

  Future<void> _persistFreezes() async {
    final jsonList = _freezes.map((f) => f.toJson()).toList();
    await _prefs.setString(_freezeKey, json.encode(jsonList));
  }

  void _loadCelebratedMilestones() {
    final jsonString = _prefs.getString(_celebratedKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        _celebratedMilestones = jsonList.whereType<int>().toList();
      } catch (_) {
        _celebratedMilestones = [];
      }
    }
  }

  Future<void> _persistCelebratedMilestones() async {
    await _prefs.setString(_celebratedKey, json.encode(_celebratedMilestones));
  }

  Future<void> clearAll() async {
    _freezes.clear();
    _celebratedMilestones.clear();
    await _prefs.remove(_freezeKey);
    await _prefs.remove(_celebratedKey);
  }
}
