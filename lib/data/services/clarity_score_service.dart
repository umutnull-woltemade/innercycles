// ════════════════════════════════════════════════════════════════════════════
// CLARITY SCORE SERVICE - Weekly composite wellbeing score (0-100)
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'journal_service.dart';
import 'mood_checkin_service.dart';
import 'ritual_service.dart';
import 'sleep_service.dart';
import 'gratitude_service.dart';
import 'streak_service.dart';

class WeeklyClarity {
  final String weekKey; // e.g. "2026-W09"
  final int score; // 0-100
  final int journalDays;
  final double avgMood;
  final double ritualRate;
  final double sleepAvg;
  final int gratitudeDays;
  final int streak;
  final DateTime computedAt;

  const WeeklyClarity({
    required this.weekKey,
    required this.score,
    required this.journalDays,
    required this.avgMood,
    required this.ritualRate,
    required this.sleepAvg,
    required this.gratitudeDays,
    required this.streak,
    required this.computedAt,
  });

  Map<String, dynamic> toJson() => {
        'weekKey': weekKey,
        'score': score,
        'journalDays': journalDays,
        'avgMood': avgMood,
        'ritualRate': ritualRate,
        'sleepAvg': sleepAvg,
        'gratitudeDays': gratitudeDays,
        'streak': streak,
        'computedAt': computedAt.toIso8601String(),
      };

  factory WeeklyClarity.fromJson(Map<String, dynamic> json) => WeeklyClarity(
        weekKey: json['weekKey'] as String? ?? '',
        score: json['score'] as int? ?? 0,
        journalDays: json['journalDays'] as int? ?? 0,
        avgMood: (json['avgMood'] as num?)?.toDouble() ?? 3.0,
        ritualRate: (json['ritualRate'] as num?)?.toDouble() ?? 0.0,
        sleepAvg: (json['sleepAvg'] as num?)?.toDouble() ?? 0.0,
        gratitudeDays: json['gratitudeDays'] as int? ?? 0,
        streak: json['streak'] as int? ?? 0,
        computedAt: DateTime.tryParse(json['computedAt']?.toString() ?? '') ?? DateTime.now(),
      );
}

class ClarityScoreService {
  static const String _storageKey = 'inner_cycles_clarity_scores';

  final SharedPreferences _prefs;
  final JournalService _journalService;
  final MoodCheckinService _moodService;
  final RitualService _ritualService;
  final SleepService _sleepService;
  final GratitudeService _gratitudeService;
  final StreakService _streakService;

  Map<String, WeeklyClarity> _cache = {};

  ClarityScoreService._({
    required SharedPreferences prefs,
    required JournalService journalService,
    required MoodCheckinService moodService,
    required RitualService ritualService,
    required SleepService sleepService,
    required GratitudeService gratitudeService,
    required StreakService streakService,
  })  : _prefs = prefs,
        _journalService = journalService,
        _moodService = moodService,
        _ritualService = ritualService,
        _sleepService = sleepService,
        _gratitudeService = gratitudeService,
        _streakService = streakService {
    _loadCache();
  }

  static Future<ClarityScoreService> init({
    required JournalService journalService,
    required MoodCheckinService moodService,
    required RitualService ritualService,
    required SleepService sleepService,
    required GratitudeService gratitudeService,
    required StreakService streakService,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return ClarityScoreService._(
      prefs: prefs,
      journalService: journalService,
      moodService: moodService,
      ritualService: ritualService,
      sleepService: sleepService,
      gratitudeService: gratitudeService,
      streakService: streakService,
    );
  }

  /// Get ISO 8601 week key for a date
  static String weekKey(DateTime date) {
    // ISO 8601: week containing Thursday belongs to that year
    final thursday = date.add(Duration(days: DateTime.thursday - date.weekday));
    final weekYear = thursday.year;
    final jan4 = DateTime(weekYear, 1, 4); // Jan 4 is always in W01
    final weekOne = jan4.subtract(Duration(days: jan4.weekday - 1));
    final weekNum = date.difference(weekOne).inDays ~/ 7 + 1;
    return '$weekYear-W${weekNum.toString().padLeft(2, '0')}';
  }

  /// Compute clarity score for this week
  Future<WeeklyClarity> computeCurrentWeek() async {
    final now = DateTime.now();
    final key = weekKey(now);

    // Monday of this week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(monday.year, monday.month, monday.day);

    // 1. Journal consistency (0-7 days journaled this week → 0-25 pts)
    final entries = _journalService.getEntriesByDateRange(weekStart, now);
    final journalDays = <String>{};
    for (final e in entries) {
      journalDays.add(
          '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}');
    }
    final journalScore = (journalDays.length / 7.0 * 25).clamp(0, 25).round();

    // 2. Mood trend (avg mood 1-5 → 0-20 pts)
    final weekMoods = _moodService.getWeekMoods();
    final validMoods = weekMoods.whereType<MoodEntry>().toList();
    final avgMood = validMoods.isEmpty
        ? 3.0
        : validMoods.fold<double>(0.0, (sum, m) => sum + m.mood) /
            validMoods.length;
    final moodScore = ((avgMood - 1) / 4.0 * 20).clamp(0, 20).round();

    // 3. Ritual completion (0-1 → 0-20 pts)
    final ritualRate =
        _ritualService.getCompletionRateForRange(weekStart, now);
    final ritualScore = (ritualRate * 20).clamp(0, 20).round();

    // 4. Sleep quality (0-5 avg → 0-15 pts)
    final sleepQualities = _sleepService.getWeekQualities();
    final validSleep = sleepQualities.where((q) => q > 0).toList();
    final sleepAvg = validSleep.isEmpty
        ? 0.0
        : validSleep.fold<double>(0, (sum, q) => sum + q) / validSleep.length;
    final sleepScore = (sleepAvg / 5.0 * 15).clamp(0, 15).round();

    // 5. Gratitude + streak bonus (0-20 pts)
    final gratEntries = _gratitudeService.getAllEntries();
    final gratDays = <String>{};
    for (final g in gratEntries) {
      if (g.createdAt.isAfter(weekStart.subtract(const Duration(days: 1)))) {
        gratDays.add(
            '${g.createdAt.year}-${g.createdAt.month.toString().padLeft(2, '0')}-${g.createdAt.day.toString().padLeft(2, '0')}');
      }
    }
    final gratScore = (gratDays.length / 7.0 * 10).clamp(0, 10).round();
    final streak = _streakService.getCurrentStreak();
    final streakBonus = (streak / 14.0 * 10).clamp(0, 10).round();

    final totalScore =
        (journalScore + moodScore + ritualScore + sleepScore + gratScore + streakBonus)
            .clamp(0, 100);

    final clarity = WeeklyClarity(
      weekKey: key,
      score: totalScore,
      journalDays: journalDays.length,
      avgMood: avgMood,
      ritualRate: ritualRate,
      sleepAvg: sleepAvg,
      gratitudeDays: gratDays.length,
      streak: streak,
      computedAt: now,
    );

    _cache[key] = clarity;
    await _persist();
    return clarity;
  }

  /// Get last N weeks of clarity scores (most recent first)
  List<WeeklyClarity> getRecentWeeks({int count = 4}) {
    final sorted = _cache.values.toList()
      ..sort((a, b) => b.weekKey.compareTo(a.weekKey));
    return sorted.take(count).toList();
  }

  /// Get previous week's clarity (for delta comparison)
  WeeklyClarity? getPreviousWeek() {
    final now = DateTime.now();
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));
    final lastMonday = thisMonday.subtract(const Duration(days: 7));
    return _cache[weekKey(lastMonday)];
  }

  /// Get current week's cached clarity
  WeeklyClarity? getCurrentWeekCached() {
    return _cache[weekKey(DateTime.now())];
  }

  void _loadCache() {
    final json = _prefs.getString(_storageKey);
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        _cache = map.map(
            (k, v) => MapEntry(k, WeeklyClarity.fromJson(v as Map<String, dynamic>)));
      } catch (_) {
        _cache = {};
      }
    }
  }

  Future<void> _persist() async {
    await _prefs.setString(
      _storageKey,
      jsonEncode(_cache.map((k, v) => MapEntry(k, v.toJson()))),
    );
  }
}
