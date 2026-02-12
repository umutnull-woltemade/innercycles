// ════════════════════════════════════════════════════════════════════════════
// WEEKLY DIGEST SERVICE - InnerCycles Weekly Summary
// ════════════════════════════════════════════════════════════════════════════
// Generates a weekly summary of journal activity, patterns, and insights.
// Drives D7 retention by giving users a reason to return every week.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

class WeeklyDigest {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int entryCount;
  final double avgMood;
  final String topFocusAreaEn;
  final String topFocusAreaTr;
  final String moodTrendEn;
  final String moodTrendTr;
  final String highlightEn;
  final String highlightTr;
  final String growthNudgeEn;
  final String growthNudgeTr;
  final int streakDays;
  final Map<String, double> areaAverages;

  const WeeklyDigest({
    required this.weekStart,
    required this.weekEnd,
    required this.entryCount,
    required this.avgMood,
    required this.topFocusAreaEn,
    required this.topFocusAreaTr,
    required this.moodTrendEn,
    required this.moodTrendTr,
    required this.highlightEn,
    required this.highlightTr,
    required this.growthNudgeEn,
    required this.growthNudgeTr,
    required this.streakDays,
    required this.areaAverages,
  });

  Map<String, dynamic> toJson() => {
        'weekStart': weekStart.toIso8601String(),
        'weekEnd': weekEnd.toIso8601String(),
        'entryCount': entryCount,
        'avgMood': avgMood,
        'topFocusAreaEn': topFocusAreaEn,
        'topFocusAreaTr': topFocusAreaTr,
        'moodTrendEn': moodTrendEn,
        'moodTrendTr': moodTrendTr,
        'highlightEn': highlightEn,
        'highlightTr': highlightTr,
        'growthNudgeEn': growthNudgeEn,
        'growthNudgeTr': growthNudgeTr,
        'streakDays': streakDays,
        'areaAverages': areaAverages,
      };

  factory WeeklyDigest.fromJson(Map<String, dynamic> json) => WeeklyDigest(
        weekStart: DateTime.parse(json['weekStart']),
        weekEnd: DateTime.parse(json['weekEnd']),
        entryCount: json['entryCount'] as int,
        avgMood: (json['avgMood'] as num).toDouble(),
        topFocusAreaEn: json['topFocusAreaEn'] as String,
        topFocusAreaTr: json['topFocusAreaTr'] as String,
        moodTrendEn: json['moodTrendEn'] as String,
        moodTrendTr: json['moodTrendTr'] as String,
        highlightEn: json['highlightEn'] as String,
        highlightTr: json['highlightTr'] as String,
        growthNudgeEn: json['growthNudgeEn'] as String,
        growthNudgeTr: json['growthNudgeTr'] as String,
        streakDays: json['streakDays'] as int,
        areaAverages: (json['areaAverages'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
      );
}

class WeeklyDigestService {
  static const String _digestKey = 'inner_cycles_weekly_digests';
  final SharedPreferences _prefs;
  List<WeeklyDigest> _digests = [];

  WeeklyDigestService._(this._prefs) {
    _loadDigests();
  }

  static Future<WeeklyDigestService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return WeeklyDigestService._(prefs);
  }

  /// Generate digest for the current/past week from journal entries
  WeeklyDigest generateDigest(List<JournalEntry> allEntries) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate =
        DateTime(weekStart.year, weekStart.month, weekStart.day);
    final weekEndDate = weekStartDate.add(const Duration(days: 6));

    // Filter entries for this week
    final weekEntries = allEntries.where((e) {
      return !e.date.isBefore(weekStartDate) &&
          !e.date.isAfter(weekEndDate.add(const Duration(days: 1)));
    }).toList();

    final entryCount = weekEntries.length;

    // Average mood
    double avgMood = 0;
    if (weekEntries.isNotEmpty) {
      avgMood = weekEntries
              .map((e) => e.overallRating)
              .reduce((a, b) => a + b)
              .toDouble() /
          weekEntries.length;
    }

    // Top focus area
    final areaCounts = <FocusArea, int>{};
    for (final entry in weekEntries) {
      areaCounts[entry.focusArea] =
          (areaCounts[entry.focusArea] ?? 0) + 1;
    }
    final topArea = areaCounts.isNotEmpty
        ? (areaCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
            .first
            .key
        : FocusArea.energy;

    // Area averages
    final areaRatings = <String, List<int>>{};
    for (final entry in weekEntries) {
      final key = entry.focusArea.name;
      areaRatings.putIfAbsent(key, () => []);
      areaRatings[key]!.add(entry.overallRating);
    }
    final areaAverages = areaRatings.map(
      (k, v) => MapEntry(k, v.reduce((a, b) => a + b) / v.length),
    );

    // Mood trend
    final moodTrend = _analyzeMoodTrend(weekEntries);

    // Streak calculation
    final sortedAll = allEntries.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    int streakDays = 0;
    var checkDate = DateTime(now.year, now.month, now.day);
    for (int i = 0; i < 30; i++) {
      final hasEntry = sortedAll.any((e) =>
          e.date.year == checkDate.year &&
          e.date.month == checkDate.month &&
          e.date.day == checkDate.day);
      if (hasEntry) {
        streakDays++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    // Generate highlight and nudge
    final highlight = _generateHighlight(entryCount, avgMood, topArea);
    final nudge = _generateGrowthNudge(entryCount, avgMood, areaCounts);

    final digest = WeeklyDigest(
      weekStart: weekStartDate,
      weekEnd: weekEndDate,
      entryCount: entryCount,
      avgMood: double.parse(avgMood.toStringAsFixed(1)),
      topFocusAreaEn: _areaNameEn(topArea),
      topFocusAreaTr: _areaNameTr(topArea),
      moodTrendEn: moodTrend.$1,
      moodTrendTr: moodTrend.$2,
      highlightEn: highlight.$1,
      highlightTr: highlight.$2,
      growthNudgeEn: nudge.$1,
      growthNudgeTr: nudge.$2,
      streakDays: streakDays,
      areaAverages: areaAverages,
    );

    // Cache the digest
    _digests.insert(0, digest);
    if (_digests.length > 12) _digests = _digests.sublist(0, 12);
    _persistDigests();

    return digest;
  }

  /// Get the most recent cached digest
  WeeklyDigest? getLastDigest() => _digests.isNotEmpty ? _digests.first : null;

  /// Get all cached digests (up to 12 weeks)
  List<WeeklyDigest> getAllDigests() => List.unmodifiable(_digests);

  // ══════════════════════════════════════════════════════════════════════════
  // ANALYSIS HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  (String, String) _analyzeMoodTrend(List<JournalEntry> entries) {
    if (entries.length < 2) {
      return ('Not enough data yet', 'Henüz yeterli veri yok');
    }

    final sorted = entries.toList()..sort((a, b) => a.date.compareTo(b.date));
    final firstHalf = sorted.sublist(0, sorted.length ~/ 2);
    final secondHalf = sorted.sublist(sorted.length ~/ 2);

    final firstAvg =
        firstHalf.map((e) => e.overallRating).reduce((a, b) => a + b) /
            firstHalf.length;
    final secondAvg =
        secondHalf.map((e) => e.overallRating).reduce((a, b) => a + b) /
            secondHalf.length;

    final diff = secondAvg - firstAvg;
    if (diff > 1.0) {
      return ('Your mood has been rising this week', 'Ruh halin bu hafta yükseliyor');
    } else if (diff < -1.0) {
      return (
        'Your mood dipped this week — be gentle with yourself',
        'Ruh halin bu hafta biraz düştü — kendine nazik ol'
      );
    } else {
      return ('Your mood has been steady this week', 'Ruh halin bu hafta sabit kalmış');
    }
  }

  (String, String) _generateHighlight(
      int entryCount, double avgMood, FocusArea topArea) {
    if (entryCount == 0) {
      return (
        'Start journaling to see your weekly highlights',
        'Haftalık özetini görmek için günlük tutmaya başla'
      );
    }
    if (entryCount >= 5) {
      return (
        'Amazing consistency! You logged $entryCount entries this week',
        'Harika tutarlılık! Bu hafta $entryCount kayıt girdin'
      );
    }
    if (avgMood >= 7) {
      return (
        'A strong week! Your average mood was ${avgMood.toStringAsFixed(1)}/10',
        'Güçlü bir hafta! Ortalama ruh halin ${avgMood.toStringAsFixed(1)}/10'
      );
    }
    return (
      'You focused most on ${_areaNameEn(topArea)} this week',
      'Bu hafta en çok ${_areaNameTr(topArea)} alanına odaklandın'
    );
  }

  (String, String) _generateGrowthNudge(
      int entryCount, double avgMood, Map<FocusArea, int> areaCounts) {
    if (entryCount == 0) {
      return (
        'Try logging just one entry today — small steps matter',
        'Bugün sadece bir kayıt girmeyi dene — küçük adımlar önemli'
      );
    }

    // Find least-tracked area
    final allAreas = FocusArea.values;
    FocusArea? leastTracked;
    int minCount = 999;
    for (final area in allAreas) {
      final count = areaCounts[area] ?? 0;
      if (count < minCount) {
        minCount = count;
        leastTracked = area;
      }
    }

    if (leastTracked != null && minCount == 0) {
      return (
        'You haven\'t explored ${_areaNameEn(leastTracked)} this week — give it a try',
        'Bu hafta ${_areaNameTr(leastTracked)} alanını keşfetmedin — bir dene'
      );
    }

    if (avgMood < 5) {
      return (
        'Consider trying a breathing exercise to reset your energy',
        'Enerjini yenilemek için bir nefes egzersizi denemeyi düşün'
      );
    }

    return (
      'Keep the momentum going — consistency builds insight',
      'İvmeyi sürdür — tutarlılık içgörü oluşturur'
    );
  }

  static String _areaNameEn(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return 'Energy';
      case FocusArea.focus:
        return 'Focus';
      case FocusArea.emotions:
        return 'Emotions';
      case FocusArea.decisions:
        return 'Decisions';
      case FocusArea.social:
        return 'Social';
    }
  }

  static String _areaNameTr(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return 'Enerji';
      case FocusArea.focus:
        return 'Odak';
      case FocusArea.emotions:
        return 'Duygular';
      case FocusArea.decisions:
        return 'Kararlar';
      case FocusArea.social:
        return 'Sosyal';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadDigests() {
    final jsonString = _prefs.getString(_digestKey);
    if (jsonString != null) {
      try {
        final list = json.decode(jsonString) as List<dynamic>;
        _digests = list
            .map((e) => WeeklyDigest.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _digests = [];
      }
    }
  }

  Future<void> _persistDigests() async {
    final jsonList = _digests.map((d) => d.toJson()).toList();
    await _prefs.setString(_digestKey, json.encode(jsonList));
  }
}
