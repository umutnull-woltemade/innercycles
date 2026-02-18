// ════════════════════════════════════════════════════════════════════════════
// BLIND SPOT SERVICE - Emotional Blind Spot Reveal Engine
// ════════════════════════════════════════════════════════════════════════════
// Analyzes journal entries to surface patterns the user may not notice:
// - Consistently low-rated areas never addressed
// - Day-of-week emotional patterns
// - Avoided focus areas
// - Hidden mood correlations
// - Rating bias detection (positivity / negativity)
//
// All insights use safe, non-judgmental language.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

// ══════════════════════════════════════════════════════════════════════════
// ENUMS
// ══════════════════════════════════════════════════════════════════════════

enum BlindSpotSeverity { low, medium, high }

enum BlindSpotCategory {
  avoidedArea,
  ratingBias,
  dayPattern,
  moodCorrelation,
  neglectedSubRating,
  stagnation,
}

// ══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════

class BlindSpot {
  final String id;
  final String typeEn;
  final String typeTr;
  final String insightEn;
  final String insightTr;
  final BlindSpotSeverity severity;
  final BlindSpotCategory category;
  final DateTime discoveredDate;

  const BlindSpot({
    required this.id,
    required this.typeEn,
    required this.typeTr,
    required this.insightEn,
    required this.insightTr,
    required this.severity,
    required this.category,
    required this.discoveredDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'typeEn': typeEn,
        'typeTr': typeTr,
        'insightEn': insightEn,
        'insightTr': insightTr,
        'severity': severity.name,
        'category': category.name,
        'discoveredDate': discoveredDate.toIso8601String(),
      };

  factory BlindSpot.fromJson(Map<String, dynamic> json) => BlindSpot(
        id: json['id'] as String,
        typeEn: json['typeEn'] as String,
        typeTr: json['typeTr'] as String,
        insightEn: json['insightEn'] as String,
        insightTr: json['insightTr'] as String,
        severity: BlindSpotSeverity.values.firstWhere(
          (e) => e.name == json['severity'],
          orElse: () => BlindSpotSeverity.low,
        ),
        category: BlindSpotCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => BlindSpotCategory.avoidedArea,
        ),
        discoveredDate: DateTime.parse(json['discoveredDate'] as String),
      );
}

class BlindSpotReport {
  final DateTime generatedDate;
  final List<BlindSpot> blindSpots;
  final String overallInsightEn;
  final String overallInsightTr;
  final List<String> growthSuggestionsEn;
  final List<String> growthSuggestionsTr;

  const BlindSpotReport({
    required this.generatedDate,
    required this.blindSpots,
    required this.overallInsightEn,
    required this.overallInsightTr,
    required this.growthSuggestionsEn,
    required this.growthSuggestionsTr,
  });

  Map<String, dynamic> toJson() => {
        'generatedDate': generatedDate.toIso8601String(),
        'blindSpots': blindSpots.map((b) => b.toJson()).toList(),
        'overallInsightEn': overallInsightEn,
        'overallInsightTr': overallInsightTr,
        'growthSuggestionsEn': growthSuggestionsEn,
        'growthSuggestionsTr': growthSuggestionsTr,
      };

  factory BlindSpotReport.fromJson(Map<String, dynamic> json) =>
      BlindSpotReport(
        generatedDate: DateTime.parse(json['generatedDate'] as String),
        blindSpots: (json['blindSpots'] as List)
            .map((b) => BlindSpot.fromJson(b as Map<String, dynamic>))
            .toList(),
        overallInsightEn: json['overallInsightEn'] as String,
        overallInsightTr: json['overallInsightTr'] as String,
        growthSuggestionsEn:
            List<String>.from(json['growthSuggestionsEn'] as List),
        growthSuggestionsTr:
            List<String>.from(json['growthSuggestionsTr'] as List),
      );
}

// ══════════════════════════════════════════════════════════════════════════
// SERVICE
// ══════════════════════════════════════════════════════════════════════════

class BlindSpotService {
  static const String _cacheKey = 'inner_cycles_blind_spot_report';
  static const int _minimumEntries = 14;

  final SharedPreferences _prefs;
  BlindSpotReport? _cachedReport;

  BlindSpotService._(this._prefs) {
    _loadCachedReport();
  }

  /// Initialize the service with SharedPreferences
  static Future<BlindSpotService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return BlindSpotService._(prefs);
  }

  // ════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ════════════════════════════════════════════════════════════════════════

  /// Whether the user has enough journal entries for meaningful analysis
  bool hasEnoughData(List<JournalEntry> entries) {
    return entries.length >= _minimumEntries;
  }

  /// Get the last cached report, or null if none exists
  BlindSpotReport? getLastReport() => _cachedReport;

  /// Generate a full blind-spot report from the user's journal entries
  BlindSpotReport generateReport(List<JournalEntry> entries) {
    final now = DateTime.now();
    final spots = <BlindSpot>[];

    // Run every detector
    spots.addAll(_detectAvoidedAreas(entries, now));
    spots.addAll(_detectRatingBias(entries, now));
    spots.addAll(_detectDayOfWeekPatterns(entries, now));
    spots.addAll(_detectMoodCorrelations(entries, now));
    spots.addAll(_detectNeglectedSubRatings(entries, now));
    spots.addAll(_detectStagnation(entries, now));

    // Sort: high severity first
    spots.sort((a, b) => b.severity.index.compareTo(a.severity.index));

    // Build overall insight
    final overallEn = _buildOverallInsightEn(spots, entries);
    final overallTr = _buildOverallInsightTr(spots, entries);

    // Build growth suggestions
    final suggestionsEn = _buildGrowthSuggestionsEn(spots);
    final suggestionsTr = _buildGrowthSuggestionsTr(spots);

    final report = BlindSpotReport(
      generatedDate: now,
      blindSpots: spots,
      overallInsightEn: overallEn,
      overallInsightTr: overallTr,
      growthSuggestionsEn: suggestionsEn,
      growthSuggestionsTr: suggestionsTr,
    );

    _cachedReport = report;
    unawaited(_persistReport(report));

    return report;
  }

  // ════════════════════════════════════════════════════════════════════════
  // DETECTOR: AVOIDED AREAS
  // ════════════════════════════════════════════════════════════════════════

  List<BlindSpot> _detectAvoidedAreas(
      List<JournalEntry> entries, DateTime now) {
    final spots = <BlindSpot>[];
    final total = entries.length;
    if (total == 0) return spots;

    final counts = <FocusArea, int>{};
    for (final area in FocusArea.values) {
      counts[area] = 0;
    }
    for (final e in entries) {
      counts[e.focusArea] = (counts[e.focusArea] ?? 0) + 1;
    }

    final expectedShare = total / FocusArea.values.length;

    for (final area in FocusArea.values) {
      final count = counts[area] ?? 0;
      final ratio = count / expectedShare;

      // If this area is used less than 30% of the expected share, flag it
      if (ratio < 0.30 && total >= _minimumEntries) {
        final severity =
            count == 0 ? BlindSpotSeverity.high : BlindSpotSeverity.medium;
        spots.add(BlindSpot(
          id: 'avoided_${area.name}',
          typeEn: 'Rarely Explored Area',
          typeTr: 'Nadiren Keşfedilen Alan',
          insightEn: count == 0
              ? 'You have never selected ${area.displayNameEn} as a focus area. '
                  'This might be an area worth exploring when you feel ready.'
              : 'Your entries suggest you rarely focus on ${area.displayNameEn} '
                  '(only $count out of $total entries). This could be an area '
                  'you might explore for new insights.',
          insightTr: count == 0
              ? '${area.displayNameTr} alanını hiç odak olarak seçmedin. '
                  'Hazır hissettiğinde keşfetmeye değer bir alan olabilir.'
              : 'Kayıtların ${area.displayNameTr} alanına nadiren '
                  'odaklandığını gösteriyor ($total kayıttan sadece $count). '
                  'Yeni bakış açıları için keşfedebileceğin bir alan olabilir.',
          severity: severity,
          category: BlindSpotCategory.avoidedArea,
          discoveredDate: now,
        ));
      }
    }

    return spots;
  }

  // ════════════════════════════════════════════════════════════════════════
  // DETECTOR: RATING BIAS
  // ════════════════════════════════════════════════════════════════════════

  List<BlindSpot> _detectRatingBias(
      List<JournalEntry> entries, DateTime now) {
    final spots = <BlindSpot>[];
    if (entries.isEmpty) return spots;

    final ratings = entries.map((e) => e.overallRating).toList();
    final avg = ratings.reduce((a, b) => a + b) / ratings.length;
    final maxRating = 5; // overallRating is 1-5

    // Count how many are at the extremes
    final highCount = ratings.where((r) => r >= maxRating).length;
    final lowCount = ratings.where((r) => r <= 1).length;
    final highRatio = highCount / ratings.length;
    final lowRatio = lowCount / ratings.length;

    // Positivity bias: average >= 4.3 or more than 60% max ratings
    if (avg >= 4.3 || highRatio > 0.60) {
      spots.add(BlindSpot(
        id: 'bias_positivity',
        typeEn: 'Positivity Tendency',
        typeTr: 'Pozitiflik Eğilimi',
        insightEn: 'Your entries tend to have consistently high ratings '
            '(average ${avg.toStringAsFixed(1)}/5). While that can reflect '
            'genuine well-being, you may find value in noticing subtler '
            'fluctuations in how you feel day to day.',
        insightTr: 'Kayıtların genellikle yüksek puanlara sahip '
            '(ortalama ${avg.toStringAsFixed(1)}/5). Bu gerçek bir iyi oluş '
            'halini yansıtabilir, ancak gün içindeki ince dalgalanmaları '
            'fark etmekte de değer bulabilirsin.',
        severity: BlindSpotSeverity.low,
        category: BlindSpotCategory.ratingBias,
        discoveredDate: now,
      ));
    }

    // Negativity bias: average <= 2.0 or more than 50% minimum ratings
    if (avg <= 2.0 || lowRatio > 0.50) {
      spots.add(BlindSpot(
        id: 'bias_negativity',
        typeEn: 'Self-Critical Tendency',
        typeTr: 'Öz Eleştiri Eğilimi',
        insightEn: 'Your entries suggest you may rate yourself lower than '
            'average (${avg.toStringAsFixed(1)}/5). Remember that journaling '
            'captures moments, not your full picture. You might consider '
            'noting small wins alongside challenges.',
        insightTr: 'Kayıtların kendini ortalamadan daha düşük puanladığını '
            'gösteriyor (${avg.toStringAsFixed(1)}/5). Günlüğün anları '
            'yakalıyor, tüm resmini değil. Zorlukların yanında küçük '
            'başarıları da not etmeyi düşünebilirsin.',
        severity: BlindSpotSeverity.medium,
        category: BlindSpotCategory.ratingBias,
        discoveredDate: now,
      ));
    }

    // Low variance: standard deviation < 0.4 — everything always the same
    final variance =
        ratings.map((r) => (r - avg) * (r - avg)).reduce((a, b) => a + b) /
            ratings.length;
    final stdDev = sqrt(variance);
    if (stdDev < 0.4 && entries.length >= _minimumEntries) {
      spots.add(BlindSpot(
        id: 'bias_flat',
        typeEn: 'Narrow Rating Range',
        typeTr: 'Dar Puanlama Aralığı',
        insightEn: 'Your ratings tend to stay very close together. '
            'Allowing yourself to use the full range might help you '
            'notice patterns that are currently hidden in similar scores.',
        insightTr: 'Puanların birbirine çok yakın kalma eğiliminde. '
            'Tam aralık kullanmak, benzer puanların arkasına gizlenen '
            'örüntüleri fark etmene yardımcı olabilir.',
        severity: BlindSpotSeverity.low,
        category: BlindSpotCategory.ratingBias,
        discoveredDate: now,
      ));
    }

    return spots;
  }

  // ════════════════════════════════════════════════════════════════════════
  // DETECTOR: DAY-OF-WEEK PATTERNS
  // ════════════════════════════════════════════════════════════════════════

  List<BlindSpot> _detectDayOfWeekPatterns(
      List<JournalEntry> entries, DateTime now) {
    final spots = <BlindSpot>[];
    if (entries.length < _minimumEntries) return spots;

    // Group ratings by weekday (1=Mon, 7=Sun)
    final dayRatings = <int, List<int>>{};
    for (int d = 1; d <= 7; d++) {
      dayRatings[d] = [];
    }
    for (final e in entries) {
      dayRatings[e.date.weekday]!.add(e.overallRating);
    }

    // Calculate average per day
    final dayAverages = <int, double>{};
    for (final d in dayRatings.keys) {
      final list = dayRatings[d]!;
      if (list.isNotEmpty) {
        dayAverages[d] = list.reduce((a, b) => a + b) / list.length;
      }
    }

    if (dayAverages.isEmpty) return spots;

    final overallAvg = entries.map((e) => e.overallRating).reduce((a, b) =>
        a + b) / entries.length;

    // Find the day that is consistently lowest (at least 0.8 below overall avg)
    int? lowestDay;
    double lowestAvg = double.infinity;
    for (final entry in dayAverages.entries) {
      if (entry.value < lowestAvg && dayRatings[entry.key]!.length >= 2) {
        lowestAvg = entry.value;
        lowestDay = entry.key;
      }
    }

    if (lowestDay != null && (overallAvg - lowestAvg) >= 0.8) {
      final dayNameEn = _dayNameEn(lowestDay);
      final dayNameTr = _dayNameTr(lowestDay);
      spots.add(BlindSpot(
        id: 'day_low_$lowestDay',
        typeEn: 'Recurring Low Day',
        typeTr: 'Tekrarlayan Düşük Gün',
        insightEn: 'Your entries suggest that ${dayNameEn}s tend to feel '
            'more challenging (average ${lowestAvg.toStringAsFixed(1)} '
            'vs your overall ${overallAvg.toStringAsFixed(1)}). '
            'You might explore what typically happens on that day.',
        insightTr: 'Kayıtların $dayNameTr günlerinin daha zorlu '
            'hissettirdiğini gösteriyor (ortalama '
            '${lowestAvg.toStringAsFixed(1)}, genel '
            '${overallAvg.toStringAsFixed(1)}). O gün tipik olarak '
            'neler olduğunu keşfetmek isteyebilirsin.',
        severity: (overallAvg - lowestAvg) >= 1.5
            ? BlindSpotSeverity.high
            : BlindSpotSeverity.medium,
        category: BlindSpotCategory.dayPattern,
        discoveredDate: now,
      ));
    }

    // Find the day that is consistently highest
    int? highestDay;
    double highestAvg = -1;
    for (final entry in dayAverages.entries) {
      if (entry.value > highestAvg && dayRatings[entry.key]!.length >= 2) {
        highestAvg = entry.value;
        highestDay = entry.key;
      }
    }

    if (highestDay != null &&
        (highestAvg - overallAvg) >= 0.8 &&
        highestDay != lowestDay) {
      final dayNameEn = _dayNameEn(highestDay);
      final dayNameTr = _dayNameTr(highestDay);
      spots.add(BlindSpot(
        id: 'day_high_$highestDay',
        typeEn: 'Peak Day Pattern',
        typeTr: 'Zirve Günü Örüntüsü',
        insightEn: 'You may notice that ${dayNameEn}s tend to feel better '
            'than other days (average ${highestAvg.toStringAsFixed(1)}). '
            'Understanding what makes that day work could help other days too.',
        insightTr: '$dayNameTr günlerinin diğer günlerden daha iyi '
            'hissettirdiğini fark edebilirsin (ortalama '
            '${highestAvg.toStringAsFixed(1)}). O günü iyi yapan şeyi '
            'anlamak diğer günlere de yardımcı olabilir.',
        severity: BlindSpotSeverity.low,
        category: BlindSpotCategory.dayPattern,
        discoveredDate: now,
      ));
    }

    return spots;
  }

  // ════════════════════════════════════════════════════════════════════════
  // DETECTOR: MOOD CORRELATIONS
  // ════════════════════════════════════════════════════════════════════════

  List<BlindSpot> _detectMoodCorrelations(
      List<JournalEntry> entries, DateTime now) {
    final spots = <BlindSpot>[];
    if (entries.length < _minimumEntries) return spots;

    // Group entries by date so we can look at consecutive days
    final sorted = List<JournalEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Build a map of date -> entries for that date
    final dateMap = <String, List<JournalEntry>>{};
    for (final e in sorted) {
      dateMap.putIfAbsent(e.dateKey, () => []).add(e);
    }

    // Check: does a high social day correlate with low energy the next day?
    _checkSequentialCorrelation(
      dateMap: dateMap,
      triggerArea: FocusArea.social,
      triggerThreshold: 4,
      triggerAbove: true,
      effectArea: FocusArea.energy,
      effectThreshold: 3,
      effectBelow: true,
      spots: spots,
      now: now,
      idSuffix: 'social_energy',
      typeEn: 'Social-Energy Pattern',
      typeTr: 'Sosyal-Enerji Örüntüsü',
      insightEn: 'Your entries suggest that after days with high Social '
          'ratings, your Energy tends to dip the following day. '
          'You might consider building in recovery time after '
          'socially active days.',
      insightTr: 'Kayıtların yüksek Sosyal puanlı günlerden sonra '
          'Enerji\'nin düşme eğiliminde olduğunu gösteriyor. '
          'Sosyal olarak aktif günlerden sonra toparlanma zamanı '
          'planlamayı düşünebilirsin.',
    );

    // Check: does low focus correlate with low decisions on the same day?
    _checkSameDayCorrelation(
      entries: entries,
      area1: FocusArea.focus,
      area2: FocusArea.decisions,
      spots: spots,
      now: now,
    );

    return spots;
  }

  void _checkSequentialCorrelation({
    required Map<String, List<JournalEntry>> dateMap,
    required FocusArea triggerArea,
    required int triggerThreshold,
    required bool triggerAbove,
    required FocusArea effectArea,
    required int effectThreshold,
    required bool effectBelow,
    required List<BlindSpot> spots,
    required DateTime now,
    required String idSuffix,
    required String typeEn,
    required String typeTr,
    required String insightEn,
    required String insightTr,
  }) {
    int matchCount = 0;
    int totalChecked = 0;

    final dates = dateMap.keys.toList()..sort();
    for (int i = 0; i < dates.length - 1; i++) {
      final todayEntries = dateMap[dates[i]]!;
      final tomorrowKey = _nextDateKey(dates[i]);
      final tomorrowEntries = dateMap[tomorrowKey];
      if (tomorrowEntries == null) continue;

      // Check if today has a trigger-area entry meeting threshold
      final triggerEntries = todayEntries.where((e) =>
          e.focusArea == triggerArea &&
          (triggerAbove
              ? e.overallRating >= triggerThreshold
              : e.overallRating <= triggerThreshold));
      if (triggerEntries.isEmpty) continue;

      // Check if tomorrow has an effect-area entry meeting threshold
      final effectEntries = tomorrowEntries.where((e) =>
          e.focusArea == effectArea &&
          (effectBelow
              ? e.overallRating <= effectThreshold
              : e.overallRating >= effectThreshold));

      totalChecked++;
      if (effectEntries.isNotEmpty) {
        matchCount++;
      }
    }

    if (totalChecked >= 3 && matchCount / totalChecked >= 0.60) {
      spots.add(BlindSpot(
        id: 'corr_$idSuffix',
        typeEn: typeEn,
        typeTr: typeTr,
        insightEn: insightEn,
        insightTr: insightTr,
        severity: matchCount / totalChecked >= 0.75
            ? BlindSpotSeverity.high
            : BlindSpotSeverity.medium,
        category: BlindSpotCategory.moodCorrelation,
        discoveredDate: now,
      ));
    }
  }

  void _checkSameDayCorrelation({
    required List<JournalEntry> entries,
    required FocusArea area1,
    required FocusArea area2,
    required List<BlindSpot> spots,
    required DateTime now,
  }) {
    // Group entries by date
    final dateMap = <String, List<JournalEntry>>{};
    for (final e in entries) {
      dateMap.putIfAbsent(e.dateKey, () => []).add(e);
    }

    int bothLowCount = 0;
    int bothPresentCount = 0;

    for (final dayEntries in dateMap.values) {
      final a1 = dayEntries.where((e) => e.focusArea == area1);
      final a2 = dayEntries.where((e) => e.focusArea == area2);
      if (a1.isEmpty || a2.isEmpty) continue;

      bothPresentCount++;
      final a1Avg = a1.map((e) => e.overallRating).reduce((a, b) => a + b) /
          a1.length;
      final a2Avg = a2.map((e) => e.overallRating).reduce((a, b) => a + b) /
          a2.length;

      if (a1Avg <= 2.5 && a2Avg <= 2.5) {
        bothLowCount++;
      }
    }

    if (bothPresentCount >= 3 && bothLowCount / bothPresentCount >= 0.60) {
      spots.add(BlindSpot(
        id: 'corr_${area1.name}_${area2.name}',
        typeEn: '${area1.displayNameEn}-${area2.displayNameEn} Link',
        typeTr: '${area1.displayNameTr}-${area2.displayNameTr} Bağlantısı',
        insightEn: 'When your ${area1.displayNameEn} is low, your '
            '${area2.displayNameEn} tends to be low on the same day. '
            'Addressing one of these areas might naturally lift the other.',
        insightTr: '${area1.displayNameTr} düşük olduğunda, '
            '${area2.displayNameTr} de aynı gün düşük olma eğiliminde. '
            'Bu alanlardan birini ele almak diğerini doğal olarak '
            'yükseltebilir.',
        severity: BlindSpotSeverity.medium,
        category: BlindSpotCategory.moodCorrelation,
        discoveredDate: now,
      ));
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // DETECTOR: NEGLECTED SUB-RATINGS
  // ════════════════════════════════════════════════════════════════════════

  List<BlindSpot> _detectNeglectedSubRatings(
      List<JournalEntry> entries, DateTime now) {
    final spots = <BlindSpot>[];
    if (entries.length < _minimumEntries) return spots;

    // Collect all sub-rating averages
    final subRatingSums = <String, double>{};
    final subRatingCounts = <String, int>{};

    for (final e in entries) {
      for (final entry in e.subRatings.entries) {
        subRatingSums[entry.key] =
            (subRatingSums[entry.key] ?? 0) + entry.value;
        subRatingCounts[entry.key] =
            (subRatingCounts[entry.key] ?? 0) + 1;
      }
    }

    // Find sub-ratings that are consistently low (avg <= 2.0)
    for (final key in subRatingSums.keys) {
      final count = subRatingCounts[key]!;
      if (count < 5) continue; // need enough data points

      final avg = subRatingSums[key]! / count;
      if (avg <= 2.0) {
        final displayNameEn = _subRatingDisplayNameEn(key);
        final displayNameTr = _subRatingDisplayNameTr(key);

        spots.add(BlindSpot(
          id: 'subrating_$key',
          typeEn: 'Consistently Low: $displayNameEn',
          typeTr: 'Sürekli Düşük: $displayNameTr',
          insightEn: 'Your $displayNameEn sub-rating has averaged '
              '${avg.toStringAsFixed(1)}/5 across $count entries. '
              'This could be something worth gently exploring '
              'or giving extra attention to.',
          insightTr: '$displayNameTr alt puanın $count kayıt boyunca '
              'ortalama ${avg.toStringAsFixed(1)}/5 olmuş. Bu, '
              'nazikçe keşfetmeye veya ekstra dikkat göstermeye '
              'değer bir şey olabilir.',
          severity:
              avg <= 1.5 ? BlindSpotSeverity.high : BlindSpotSeverity.medium,
          category: BlindSpotCategory.neglectedSubRating,
          discoveredDate: now,
        ));
      }
    }

    return spots;
  }

  // ════════════════════════════════════════════════════════════════════════
  // DETECTOR: STAGNATION
  // ════════════════════════════════════════════════════════════════════════

  List<BlindSpot> _detectStagnation(
      List<JournalEntry> entries, DateTime now) {
    final spots = <BlindSpot>[];
    if (entries.length < _minimumEntries) return spots;

    // Check per focus area: is the average over the last 7 entries the same
    // as the average over the first 7 entries? If so, no movement.
    for (final area in FocusArea.values) {
      final areaEntries = entries
          .where((e) => e.focusArea == area)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      if (areaEntries.length < 8) continue;

      final firstHalf = areaEntries.sublist(0, (areaEntries.length / 2).floor());
      final secondHalf =
          areaEntries.sublist((areaEntries.length / 2).floor());

      final firstAvg = firstHalf.map((e) => e.overallRating).reduce(
              (a, b) => a + b) / firstHalf.length;
      final secondAvg = secondHalf.map((e) => e.overallRating).reduce(
              (a, b) => a + b) / secondHalf.length;

      final diff = (secondAvg - firstAvg).abs();
      if (diff < 0.3 && firstAvg <= 3.0) {
        spots.add(BlindSpot(
          id: 'stagnation_${area.name}',
          typeEn: '${area.displayNameEn}: Holding Steady',
          typeTr: '${area.displayNameTr}: Sabit Kalıyor',
          insightEn: 'Your ${area.displayNameEn} ratings have stayed around '
              '${firstAvg.toStringAsFixed(1)}/5 over time. If you feel ready '
              'for change in this area, trying a new approach might help '
              'shift the pattern.',
          insightTr: '${area.displayNameTr} puanların zaman içinde '
              '${firstAvg.toStringAsFixed(1)}/5 civarında kaldı. '
              'Bu alanda değişime hazır hissediyorsan, yeni bir yaklaşım '
              'denemek örüntünü değiştirmeye yardımcı olabilir.',
          severity: firstAvg <= 2.0
              ? BlindSpotSeverity.high
              : BlindSpotSeverity.medium,
          category: BlindSpotCategory.stagnation,
          discoveredDate: now,
        ));
      }
    }

    return spots;
  }

  // ════════════════════════════════════════════════════════════════════════
  // OVERALL INSIGHT BUILDERS
  // ════════════════════════════════════════════════════════════════════════

  String _buildOverallInsightEn(
      List<BlindSpot> spots, List<JournalEntry> entries) {
    if (spots.isEmpty) {
      return 'Based on your ${entries.length} journal entries, no significant '
          'blind spots were detected. This may mean your self-awareness is '
          'well-rounded, or that more entries will reveal subtler patterns '
          'over time. Keep journaling to deepen your understanding.';
    }

    final highCount = spots.where((s) =>
        s.severity == BlindSpotSeverity.high).length;
    final categories = spots.map((s) => s.category).toSet();

    final buffer = StringBuffer();
    buffer.write('After reviewing your ${entries.length} journal entries, ');

    if (highCount > 0) {
      buffer.write('there ${highCount == 1 ? "is" : "are"} '
          '$highCount area${highCount == 1 ? "" : "s"} that might benefit '
          'from your attention. ');
    } else {
      buffer.write('a few subtle patterns emerged that you might find '
          'interesting. ');
    }

    if (categories.contains(BlindSpotCategory.avoidedArea)) {
      buffer.write(
          'Some focus areas appear less explored than others. ');
    }
    if (categories.contains(BlindSpotCategory.ratingBias)) {
      buffer.write(
          'Your rating patterns show some tendencies worth noticing. ');
    }
    if (categories.contains(BlindSpotCategory.dayPattern)) {
      buffer.write('Certain days of the week seem to stand out. ');
    }

    buffer.write('These observations are based on patterns in your entries '
        'and are meant as starting points for reflection, not conclusions.');

    return buffer.toString();
  }

  String _buildOverallInsightTr(
      List<BlindSpot> spots, List<JournalEntry> entries) {
    if (spots.isEmpty) {
      return '${entries.length} günlük kaydın incelenmesinde belirgin bir '
          'kör nokta tespit edilmedi. Bu, öz farkındalığının dengeli '
          'olduğu anlamına gelebilir veya daha fazla kayıt zamanla daha '
          'ince örüntüleri ortaya çıkarabilir. Anlamanı derinleştirmek '
          'için günlük tutmaya devam et.';
    }

    final highCount = spots.where((s) =>
        s.severity == BlindSpotSeverity.high).length;
    final categories = spots.map((s) => s.category).toSet();

    final buffer = StringBuffer();
    buffer.write('${entries.length} günlük kaydın incelenmesinin ardından, ');

    if (highCount > 0) {
      buffer.write('dikkatini çekmesi gereken $highCount alan var. ');
    } else {
      buffer.write('ilginç bulabileceğin birkaç ince örüntüler ortaya çıktı. ');
    }

    if (categories.contains(BlindSpotCategory.avoidedArea)) {
      buffer.write(
          'Bazı odak alanları diğerlerinden daha az keşfedilmiş görünüyor. ');
    }
    if (categories.contains(BlindSpotCategory.ratingBias)) {
      buffer.write(
          'Puanlama örüntülerin fark etmeye değer bazı eğilimler gösteriyor. ');
    }
    if (categories.contains(BlindSpotCategory.dayPattern)) {
      buffer.write('Haftanın bazı günleri öne çıkıyor gibi görünüyor. ');
    }

    buffer.write('Bu gözlemler kayıtlarındaki örüntülere dayanmaktadır '
        've sonuç değil, düşünme başlangıç noktaları olarak tasarlanmıştır.');

    return buffer.toString();
  }

  // ════════════════════════════════════════════════════════════════════════
  // GROWTH SUGGESTIONS BUILDERS
  // ════════════════════════════════════════════════════════════════════════

  List<String> _buildGrowthSuggestionsEn(List<BlindSpot> spots) {
    final suggestions = <String>[];

    final hasAvoided =
        spots.any((s) => s.category == BlindSpotCategory.avoidedArea);
    final hasBias =
        spots.any((s) => s.category == BlindSpotCategory.ratingBias);
    final hasDayPattern =
        spots.any((s) => s.category == BlindSpotCategory.dayPattern);
    final hasCorrelation =
        spots.any((s) => s.category == BlindSpotCategory.moodCorrelation);
    final hasNeglected =
        spots.any((s) => s.category == BlindSpotCategory.neglectedSubRating);
    final hasStagnation =
        spots.any((s) => s.category == BlindSpotCategory.stagnation);

    if (hasAvoided) {
      suggestions.add(
          'Try selecting a focus area you rarely choose, even just once this week, to broaden your self-awareness.');
    }
    if (hasBias) {
      suggestions.add(
          'Before rating, pause for a moment and check in with how your body feels. This can help capture a more nuanced picture.');
    }
    if (hasDayPattern) {
      suggestions.add(
          'On your lower-rated days, try a brief check-in earlier in the day to see if awareness itself shifts the experience.');
    }
    if (hasCorrelation) {
      suggestions.add(
          'When you notice a pattern between two areas, experiment with giving extra care to one and observe whether the other shifts.');
    }
    if (hasNeglected) {
      suggestions.add(
          'Consider giving a bit of intentional attention to your lower sub-ratings. Even small steps can create noticeable shifts.');
    }
    if (hasStagnation) {
      suggestions.add(
          'For areas that have stayed flat, consider changing one small habit or routine to see if it creates movement.');
    }

    if (suggestions.isEmpty) {
      suggestions.add(
          'Continue journaling regularly. Consistency over time is the best way to uncover deeper patterns.');
      suggestions.add(
          'Try adding notes to your entries. Written reflections often reveal insights that numbers alone cannot.');
    }

    return suggestions;
  }

  List<String> _buildGrowthSuggestionsTr(List<BlindSpot> spots) {
    final suggestions = <String>[];

    final hasAvoided =
        spots.any((s) => s.category == BlindSpotCategory.avoidedArea);
    final hasBias =
        spots.any((s) => s.category == BlindSpotCategory.ratingBias);
    final hasDayPattern =
        spots.any((s) => s.category == BlindSpotCategory.dayPattern);
    final hasCorrelation =
        spots.any((s) => s.category == BlindSpotCategory.moodCorrelation);
    final hasNeglected =
        spots.any((s) => s.category == BlindSpotCategory.neglectedSubRating);
    final hasStagnation =
        spots.any((s) => s.category == BlindSpotCategory.stagnation);

    if (hasAvoided) {
      suggestions.add(
          'Bu hafta nadiren seçtiğin bir odak alanını da dene. Öz farkındalığını genişletmeye yardımcı olabilir.');
    }
    if (hasBias) {
      suggestions.add(
          'Puanlamadan önce bir an dur ve bedeninin nasıl hissettiğini kontrol et. Daha nüanslı bir resim yakalamanıza yardımcı olabilir.');
    }
    if (hasDayPattern) {
      suggestions.add(
          'Düşük puanlı günlerinde günün erken saatlerinde kısa bir kontrol dene. Farkındalık deneyimi değiştirebilir.');
    }
    if (hasCorrelation) {
      suggestions.add(
          'İki alan arasında bir örüntü farkettiğinde, birine ekstra özen göstermeyi dene ve diğerinin değişip değişmediğini gözlemle.');
    }
    if (hasNeglected) {
      suggestions.add(
          'Düşük alt puanlarına biraz bilinçli dikkat göstermeyi düşün. Küçük adımlar bile fark edilir değişimler yaratabilir.');
    }
    if (hasStagnation) {
      suggestions.add(
          'Sabit kalan alanlar için küçük bir alışkanlık veya rutin değişikliği dene ve hareket yaratıp yaratmadığını gör.');
    }

    if (suggestions.isEmpty) {
      suggestions.add(
          'Düzenli günlük tutmaya devam et. Zaman içindeki tutarlılık, daha derin örüntüleri ortaya çıkarmanın en iyi yoludur.');
      suggestions.add(
          'Kayıtlarına notlar eklemeyi dene. Yazılı düşünceler, sayıların tek başına ortaya çıkaramadığı içgörüleri sıklıkla ortaya çıkarır.');
    }

    return suggestions;
  }

  // ════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ════════════════════════════════════════════════════════════════════════

  String _dayNameEn(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    return days[weekday - 1];
  }

  String _dayNameTr(int weekday) {
    const days = [
      'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe',
      'Cuma', 'Cumartesi', 'Pazar',
    ];
    return days[weekday - 1];
  }

  String _nextDateKey(String dateKey) {
    final date = DateTime.parse(dateKey);
    final next = date.add(const Duration(days: 1));
    return '${next.year}-${next.month.toString().padLeft(2, '0')}-${next.day.toString().padLeft(2, '0')}';
  }

  String _subRatingDisplayNameEn(String key) {
    const map = {
      'physical': 'Physical',
      'mental': 'Mental',
      'motivation': 'Motivation',
      'clarity': 'Clarity',
      'productivity': 'Productivity',
      'distractibility': 'Distractibility',
      'mood': 'Mood',
      'stress': 'Stress',
      'calm': 'Calm',
      'confidence': 'Confidence',
      'certainty': 'Certainty',
      'regret': 'Regret',
      'connection': 'Connection',
      'isolation': 'Isolation',
      'communication': 'Communication',
    };
    return map[key] ?? key;
  }

  String _subRatingDisplayNameTr(String key) {
    const map = {
      'physical': 'Fiziksel',
      'mental': 'Zihinsel',
      'motivation': 'Motivasyon',
      'clarity': 'Netlik',
      'productivity': 'Verimlilik',
      'distractibility': 'Dikkat Dağınıklığı',
      'mood': 'Ruh Hali',
      'stress': 'Stres',
      'calm': 'Huzur',
      'confidence': 'Güven',
      'certainty': 'Kesinlik',
      'regret': 'Pişmanlık',
      'connection': 'Bağlantı',
      'isolation': 'Yalnızlık',
      'communication': 'İletişim',
    };
    return map[key] ?? key;
  }

  // ════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ════════════════════════════════════════════════════════════════════════

  void _loadCachedReport() {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString != null) {
      try {
        final data = json.decode(jsonString) as Map<String, dynamic>;
        _cachedReport = BlindSpotReport.fromJson(data);
      } catch (_) {
        _cachedReport = null;
      }
    }
  }

  Future<void> _persistReport(BlindSpotReport report) async {
    await _prefs.setString(_cacheKey, json.encode(report.toJson()));
  }
}
