// ════════════════════════════════════════════════════════════════════════════
// WELLNESS SCORE SERVICE - InnerCycles Composite Health Metric
// ════════════════════════════════════════════════════════════════════════════
// Computes a daily/weekly wellness score (1-100) from:
//   - Journal ratings (40% weight)
//   - Gratitude practice (15% weight)
//   - Ritual completion (15% weight)
//   - Streak consistency (15% weight)
//   - Sleep quality (15% weight)
// Transparent breakdown. Premium: monthly trends + correlations.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'journal_service.dart';
import 'gratitude_service.dart';
import 'ritual_service.dart';
import 'streak_service.dart';
import 'sleep_service.dart';

/// Category breakdown for transparency
class WellnessBreakdown {
  final String category;
  final double score; // 0-100
  final double weight;

  const WellnessBreakdown({
    required this.category,
    required this.score,
    required this.weight,
  });

  double get weightedScore => score * weight;
}

/// Daily wellness score snapshot
class WellnessScore {
  final String dateKey;
  final int score; // 1-100
  final List<WellnessBreakdown> breakdown;
  final DateTime calculatedAt;

  const WellnessScore({
    required this.dateKey,
    required this.score,
    required this.breakdown,
    required this.calculatedAt,
  });

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'score': score,
        'breakdown': breakdown
            .map((b) => {
                  'category': b.category,
                  'score': b.score,
                  'weight': b.weight,
                })
            .toList(),
        'calculatedAt': calculatedAt.toIso8601String(),
      };

  factory WellnessScore.fromJson(Map<String, dynamic> json) => WellnessScore(
        dateKey: json['dateKey'] as String? ?? '',
        score: json['score'] as int? ?? 0,
        breakdown: (json['breakdown'] as List<dynamic>?)
                ?.map((b) => WellnessBreakdown(
                      category: b['category'] as String? ?? '',
                      score: (b['score'] as num? ?? 0).toDouble(),
                      weight: (b['weight'] as num? ?? 0).toDouble(),
                    ))
                .toList() ??
            [],
        calculatedAt: DateTime.tryParse(json['calculatedAt']?.toString() ?? '') ?? DateTime.now(),
      );
}

/// Weekly wellness trend for home screen card
class WellnessTrend {
  final int currentScore;
  final int previousWeekScore;
  final List<WellnessScore> dailyScores; // last 7 days
  final String direction; // 'up', 'down', 'stable'

  const WellnessTrend({
    required this.currentScore,
    required this.previousWeekScore,
    required this.dailyScores,
    required this.direction,
  });
}

class WellnessScoreService {
  static const String _storageKey = 'inner_cycles_wellness_scores';

  final SharedPreferences _prefs;
  final JournalService _journalService;
  final GratitudeService _gratitudeService;
  final RitualService _ritualService;
  final StreakService _streakService;
  final SleepService _sleepService;

  Map<String, WellnessScore> _scores = {}; // dateKey -> score

  WellnessScoreService._({
    required SharedPreferences prefs,
    required JournalService journalService,
    required GratitudeService gratitudeService,
    required RitualService ritualService,
    required StreakService streakService,
    required SleepService sleepService,
  })  : _prefs = prefs,
        _journalService = journalService,
        _gratitudeService = gratitudeService,
        _ritualService = ritualService,
        _streakService = streakService,
        _sleepService = sleepService {
    _loadScores();
  }

  static Future<WellnessScoreService> init({
    required JournalService journalService,
    required GratitudeService gratitudeService,
    required RitualService ritualService,
    required StreakService streakService,
    required SleepService sleepService,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return WellnessScoreService._(
      prefs: prefs,
      journalService: journalService,
      gratitudeService: gratitudeService,
      ritualService: ritualService,
      streakService: streakService,
      sleepService: sleepService,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SCORE CALCULATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Calculate today's wellness score
  Future<WellnessScore> calculateTodayScore() async {
    final now = DateTime.now();
    final dateKey = _dateToKey(now);

    // Journal component (40% weight) — based on latest entry's overall rating
    double journalScore = 0;
    final todayEntry = _journalService.getTodayEntry();
    if (todayEntry != null) {
      journalScore = (todayEntry.overallRating / 5.0) * 100;
    } else {
      // Check if there's a recent entry (last 3 days)
      final recent = _journalService.getRecentEntries(1);
      if (recent.isNotEmpty) {
        final daysDiff = now.difference(recent.first.date).inDays;
        if (daysDiff <= 3) {
          journalScore = (recent.first.overallRating / 5.0) * 100 * (1 - daysDiff * 0.15);
        }
      }
    }

    // Gratitude component (15% weight) — logged today = 100, recent = partial
    double gratitudeScore = 0;
    final todayGratitude = _gratitudeService.getTodayEntry();
    if (todayGratitude != null && todayGratitude.items.isNotEmpty) {
      gratitudeScore = (todayGratitude.items.length / 3.0).clamp(0, 1) * 100;
    }

    // Ritual component (15% weight) — today's completion rate
    double ritualScore = 0;
    final ritualSummary = _ritualService.getTodaySummary();
    if (ritualSummary.totalItems > 0) {
      ritualScore = ritualSummary.overallCompletion * 100;
    }

    // Streak component (15% weight) — scaled by streak length
    double streakScore = 0;
    final streak = _streakService.getCurrentStreak();
    if (streak > 0) {
      // Logarithmic scaling: 1 day = 20, 7 days = 60, 30 days = 85, 90+ = 100
      if (streak >= 90) {
        streakScore = 100;
      } else if (streak >= 30) {
        streakScore = 85 + (streak - 30) / 60 * 15;
      } else if (streak >= 7) {
        streakScore = 60 + (streak - 7) / 23 * 25;
      } else {
        streakScore = 20 + (streak - 1) / 6 * 40;
      }
    }

    // Sleep component (15% weight) — today's sleep rating
    double sleepScore = 0;
    final todaySleep = _sleepService.getTodayEntry();
    if (todaySleep != null) {
      sleepScore = (todaySleep.quality / 5.0) * 100;
    } else {
      // Check recent sleep
      final summary = _sleepService.getWeeklySummary();
      if (summary.nightsLogged > 0) {
        sleepScore = (summary.averageQuality / 5.0) * 100 * 0.7; // Decay
      }
    }

    final breakdown = [
      WellnessBreakdown(category: 'journal', score: journalScore, weight: 0.40),
      WellnessBreakdown(category: 'gratitude', score: gratitudeScore, weight: 0.15),
      WellnessBreakdown(category: 'rituals', score: ritualScore, weight: 0.15),
      WellnessBreakdown(category: 'streak', score: streakScore, weight: 0.15),
      WellnessBreakdown(category: 'sleep', score: sleepScore, weight: 0.15),
    ];

    final totalScore = breakdown
        .map((b) => b.weightedScore)
        .reduce((a, b) => a + b)
        .round()
        .clamp(0, 100);

    final score = WellnessScore(
      dateKey: dateKey,
      score: totalScore,
      breakdown: breakdown,
      calculatedAt: DateTime.now(),
    );

    _scores[dateKey] = score;
    await _persistScores();
    return score;
  }

  /// Get cached score for a date (or null if not calculated)
  WellnessScore? getScore(DateTime date) {
    return _scores[_dateToKey(date)];
  }

  /// Get today's cached score
  WellnessScore? getTodayScore() => getScore(DateTime.now());

  // ══════════════════════════════════════════════════════════════════════════
  // TRENDS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get weekly wellness trend
  WellnessTrend getWeeklyTrend() {
    final now = DateTime.now();
    final thisWeekScores = <WellnessScore>[];
    final prevWeekScores = <WellnessScore>[];

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final score = _scores[_dateToKey(date)];
      if (score != null) thisWeekScores.add(score);
    }

    for (int i = 7; i < 14; i++) {
      final date = now.subtract(Duration(days: i));
      final score = _scores[_dateToKey(date)];
      if (score != null) prevWeekScores.add(score);
    }

    final currentAvg = thisWeekScores.isEmpty
        ? 0
        : thisWeekScores.map((s) => s.score).reduce((a, b) => a + b) ~/
            thisWeekScores.length;

    final prevAvg = prevWeekScores.isEmpty
        ? 0
        : prevWeekScores.map((s) => s.score).reduce((a, b) => a + b) ~/
            prevWeekScores.length;

    String direction;
    if (prevAvg == 0) {
      direction = 'stable';
    } else if (currentAvg - prevAvg > 5) {
      direction = 'up';
    } else if (prevAvg - currentAvg > 5) {
      direction = 'down';
    } else {
      direction = 'stable';
    }

    return WellnessTrend(
      currentScore: currentAvg,
      previousWeekScore: prevAvg,
      dailyScores: thisWeekScores,
      direction: direction,
    );
  }

  /// Get monthly scores (premium) - last 30 days
  List<WellnessScore> getMonthlyScores() {
    final now = DateTime.now();
    final scores = <WellnessScore>[];
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final score = _scores[_dateToKey(date)];
      if (score != null) scores.add(score);
    }
    scores.sort((a, b) => a.dateKey.compareTo(b.dateKey));
    return scores;
  }

  int get totalScores => _scores.length;

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadScores() {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _scores = jsonMap.map(
          (k, v) => MapEntry(k, WellnessScore.fromJson(v)),
        );
      } catch (_) {
        _scores = {};
      }
    }
  }

  Future<void> _persistScores() async {
    final jsonMap = _scores.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs.setString(_storageKey, json.encode(jsonMap));
  }

  Future<void> clearAll() async {
    _scores.clear();
    await _prefs.remove(_storageKey);
  }

  String _dateToKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
