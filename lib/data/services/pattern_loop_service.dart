// ════════════════════════════════════════════════════════════════════════════
// PATTERN LOOP ENGINE - Behavioral Reinforcement Loop Detection
// ════════════════════════════════════════════════════════════════════════════
// Detects recurring behavioral loops from journal entries:
//   Trigger → Emotional Shift → Behavior → Outcome → Reinforcement
//
// All output uses safe, non-predictive language.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import 'journal_service.dart';

// ══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════

/// The type of reinforcement a loop produces
enum ReinforcementType {
  positive,
  negative,
  neutral;

  String labelEn() {
    switch (this) {
      case ReinforcementType.positive:
        return 'Positive';
      case ReinforcementType.negative:
        return 'Negative';
      case ReinforcementType.neutral:
        return 'Neutral';
    }
  }

  String labelTr() {
    switch (this) {
      case ReinforcementType.positive:
        return 'Pozitif';
      case ReinforcementType.negative:
        return 'Negatif';
      case ReinforcementType.neutral:
        return 'Nötr';
    }
  }
}

/// A single stage in the behavioral loop
class LoopStage {
  final String id;
  final String labelEn;
  final String labelTr;
  final String? descriptionEn;
  final String? descriptionTr;

  const LoopStage({
    required this.id,
    required this.labelEn,
    required this.labelTr,
    this.descriptionEn,
    this.descriptionTr,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'labelEn': labelEn,
        'labelTr': labelTr,
        'descriptionEn': descriptionEn,
        'descriptionTr': descriptionTr,
      };

  factory LoopStage.fromJson(Map<String, dynamic> json) => LoopStage(
        id: json['id'] as String? ?? '',
        labelEn: json['labelEn'] as String? ?? '',
        labelTr: json['labelTr'] as String? ?? '',
        descriptionEn: json['descriptionEn'] as String?,
        descriptionTr: json['descriptionTr'] as String?,
      );
}

/// A detected behavioral reinforcement loop
class PatternLoop {
  final String id;
  final DateTime firstDetected;
  final DateTime lastSeen;
  final int occurrenceCount;
  final FocusArea primaryArea;
  final FocusArea? secondaryArea;
  final ReinforcementType reinforcementType;
  final double strength; // 0.0 - 1.0

  /// The 5 stages of the loop
  final LoopStage trigger;
  final LoopStage emotionalShift;
  final LoopStage behavior;
  final LoopStage outcome;
  final LoopStage reinforcement;

  /// Safe-language insight about this loop
  final String insightEn;
  final String insightTr;

  /// Suggested action (safe language)
  final String? actionEn;
  final String? actionTr;

  const PatternLoop({
    required this.id,
    required this.firstDetected,
    required this.lastSeen,
    required this.occurrenceCount,
    required this.primaryArea,
    this.secondaryArea,
    required this.reinforcementType,
    required this.strength,
    required this.trigger,
    required this.emotionalShift,
    required this.behavior,
    required this.outcome,
    required this.reinforcement,
    required this.insightEn,
    required this.insightTr,
    this.actionEn,
    this.actionTr,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstDetected': firstDetected.toIso8601String(),
        'lastSeen': lastSeen.toIso8601String(),
        'occurrenceCount': occurrenceCount,
        'primaryArea': primaryArea.name,
        'secondaryArea': secondaryArea?.name,
        'reinforcementType': reinforcementType.name,
        'strength': strength,
        'trigger': trigger.toJson(),
        'emotionalShift': emotionalShift.toJson(),
        'behavior': behavior.toJson(),
        'outcome': outcome.toJson(),
        'reinforcement': reinforcement.toJson(),
        'insightEn': insightEn,
        'insightTr': insightTr,
        'actionEn': actionEn,
        'actionTr': actionTr,
      };

  factory PatternLoop.fromJson(Map<String, dynamic> json) => PatternLoop(
        id: json['id'] as String? ?? '',
        firstDetected: DateTime.tryParse(json['firstDetected']?.toString() ?? '') ?? DateTime.now(),
        lastSeen: DateTime.tryParse(json['lastSeen']?.toString() ?? '') ?? DateTime.now(),
        occurrenceCount: json['occurrenceCount'] as int? ?? 0,
        primaryArea: FocusArea.values.firstWhere(
          (e) => e.name == json['primaryArea'],
          orElse: () => FocusArea.energy,
        ),
        secondaryArea: json['secondaryArea'] != null
            ? FocusArea.values.firstWhere(
                (e) => e.name == json['secondaryArea'],
                orElse: () => FocusArea.energy,
              )
            : null,
        reinforcementType: ReinforcementType.values.firstWhere(
          (e) => e.name == json['reinforcementType'],
          orElse: () => ReinforcementType.neutral,
        ),
        strength: (json['strength'] as num? ?? 0).toDouble(),
        trigger: LoopStage.fromJson(json['trigger'] as Map<String, dynamic>? ?? {}),
        emotionalShift:
            LoopStage.fromJson(json['emotionalShift'] as Map<String, dynamic>? ?? {}),
        behavior:
            LoopStage.fromJson(json['behavior'] as Map<String, dynamic>? ?? {}),
        outcome: LoopStage.fromJson(json['outcome'] as Map<String, dynamic>? ?? {}),
        reinforcement:
            LoopStage.fromJson(json['reinforcement'] as Map<String, dynamic>? ?? {}),
        insightEn: json['insightEn'] as String? ?? '',
        insightTr: json['insightTr'] as String? ?? '',
        actionEn: json['actionEn'] as String?,
        actionTr: json['actionTr'] as String?,
      );
}

/// Result of pattern loop analysis
class PatternLoopAnalysis {
  final List<PatternLoop> detectedLoops;
  final int totalEntriesAnalyzed;
  final Map<ReinforcementType, int> reinforcementBreakdown;

  const PatternLoopAnalysis({
    required this.detectedLoops,
    required this.totalEntriesAnalyzed,
    required this.reinforcementBreakdown,
  });
}

// ══════════════════════════════════════════════════════════════════════════
// PATTERN LOOP SERVICE
// ══════════════════════════════════════════════════════════════════════════

class PatternLoopService {
  static const String _storageKey = 'innercycles_pattern_loops';
  static const int minimumEntries = 14;

  final SharedPreferences _prefs;
  final JournalService _journalService;
  List<PatternLoop> _cachedLoops = [];

  PatternLoopService._(this._prefs, this._journalService) {
    _loadFromStorage();
  }

  static Future<PatternLoopService> init(
    JournalService journalService,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    return PatternLoopService._(prefs, journalService);
  }

  /// Whether enough data exists for loop detection
  bool hasEnoughData() => _journalService.entryCount >= minimumEntries;

  /// How many more entries needed
  int entriesNeeded() =>
      math.max(0, minimumEntries - _journalService.entryCount);

  /// Get all detected loops
  List<PatternLoop> getDetectedLoops() => List.unmodifiable(_cachedLoops);

  /// Get loops by reinforcement type
  List<PatternLoop> getLoopsByType(ReinforcementType type) =>
      _cachedLoops.where((l) => l.reinforcementType == type).toList();

  /// Get the strongest detected loop
  PatternLoop? getStrongestLoop() {
    if (_cachedLoops.isEmpty) return null;
    return _cachedLoops.reduce(
      (a, b) => a.strength > b.strength ? a : b,
    );
  }

  /// Run full pattern loop analysis
  PatternLoopAnalysis analyze() {
    if (!hasEnoughData()) {
      return const PatternLoopAnalysis(
        detectedLoops: [],
        totalEntriesAnalyzed: 0,
        reinforcementBreakdown: {},
      );
    }

    final allEntries = _journalService.getAllEntries();
    final loops = _detectLoops(allEntries);

    // Update cache and persist
    _cachedLoops = loops;
    _saveToStorage();

    // Build reinforcement breakdown
    final breakdown = <ReinforcementType, int>{};
    for (final loop in loops) {
      breakdown[loop.reinforcementType] =
          (breakdown[loop.reinforcementType] ?? 0) + 1;
    }

    return PatternLoopAnalysis(
      detectedLoops: loops,
      totalEntriesAnalyzed: allEntries.length,
      reinforcementBreakdown: breakdown,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LOOP DETECTION ENGINE
  // ══════════════════════════════════════════════════════════════════════════

  List<PatternLoop> _detectLoops(List<JournalEntry> entries) {
    final loops = <PatternLoop>[];

    // Sort chronologically
    final sorted = List.of(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Strategy 1: Detect rating-drop-recovery loops per area
    for (final area in FocusArea.values) {
      final areaEntries =
          sorted.where((e) => e.focusArea == area).toList();
      final dropRecoveryLoop = _detectDropRecoveryLoop(area, areaEntries);
      if (dropRecoveryLoop != null) loops.add(dropRecoveryLoop);
    }

    // Strategy 2: Detect cross-area influence loops
    final crossLoops = _detectCrossAreaLoops(sorted);
    loops.addAll(crossLoops);

    // Strategy 3: Detect weekday-driven loops
    final weekdayLoop = _detectWeekdayLoop(sorted);
    if (weekdayLoop != null) loops.add(weekdayLoop);

    return loops;
  }

  /// Detect drop → recovery loops within a focus area.
  /// Pattern: high → drop → low period → recovery → high again
  PatternLoop? _detectDropRecoveryLoop(
    FocusArea area,
    List<JournalEntry> areaEntries,
  ) {
    if (areaEntries.length < 5) return null;

    // Find sequences where rating drops by 2+ then recovers
    int dropCount = 0;
    int recoveryCount = 0;
    DateTime? firstDrop;
    DateTime? lastRecovery;

    for (int i = 1; i < areaEntries.length; i++) {
      final prev = areaEntries[i - 1].overallRating;
      final curr = areaEntries[i].overallRating;

      if (curr <= prev - 2) {
        dropCount++;
        firstDrop ??= areaEntries[i].date;
      }

      // Recovery: from low (<= 2) back to moderate (>= 3)
      if (i >= 2) {
        final prevPrev = areaEntries[i - 2].overallRating;
        if (prevPrev <= 2 && prev >= 2 && curr >= 3) {
          recoveryCount++;
          lastRecovery = areaEntries[i].date;
        }
      }
    }

    // Need at least 2 drops and 1 recovery for a loop
    if (dropCount < 2 || recoveryCount < 1) return null;

    final strength =
        (math.min(dropCount, 5) / 5 * 0.6 + math.min(recoveryCount, 3) / 3 * 0.4)
            .clamp(0.0, 1.0);

    final areaEn = area.displayNameEn;
    final areaTr = area.displayNameTr;

    return PatternLoop(
      id: 'drop_recovery_${area.name}',
      firstDetected: firstDrop ?? (areaEntries.isNotEmpty ? areaEntries.first.date : DateTime.now()),
      lastSeen: lastRecovery ?? (areaEntries.isNotEmpty ? areaEntries.last.date : DateTime.now()),
      occurrenceCount: dropCount,
      primaryArea: area,
      reinforcementType: ReinforcementType.negative,
      strength: strength,
      trigger: LoopStage(
        id: 'trigger',
        labelEn: '$areaEn Pressure',
        labelTr: '$areaTr Baskısı',
        descriptionEn: 'Sustained pressure in your $areaEn area tends to precede drops',
        descriptionTr: '$areaTr alanındaki sürekli baskı düşüşlerin öncesinde olma eğiliminde',
      ),
      emotionalShift: LoopStage(
        id: 'shift',
        labelEn: 'Rating Drop',
        labelTr: 'Puan Düşüşü',
        descriptionEn: 'Your $areaEn rating drops significantly',
        descriptionTr: '$areaTr puanın belirgin şekilde düşüyor',
      ),
      behavior: LoopStage(
        id: 'behavior',
        labelEn: 'Low Period',
        labelTr: 'Düşük Dönem',
        descriptionEn: 'A period of lower $areaEn follows',
        descriptionTr: 'Düşük $areaTr dönemi takip ediyor',
      ),
      outcome: LoopStage(
        id: 'outcome',
        labelEn: 'Natural Recovery',
        labelTr: 'Doğal Toparlanma',
        descriptionEn: 'Your $areaEn naturally recovers over time',
        descriptionTr: '$areaTr alanın zamanla doğal olarak toparlanıyor',
      ),
      reinforcement: LoopStage(
        id: 'reinforcement',
        labelEn: 'Cycle Repeats',
        labelTr: 'Döngü Tekrarı',
        descriptionEn: 'This pattern has appeared $dropCount times in your data',
        descriptionTr: 'Bu kalıp verilerinde $dropCount kez görünmüş',
      ),
      insightEn:
          'Your $areaEn tends to follow a drop-and-recovery pattern. '
          'This has appeared $dropCount times in your entries.',
      insightTr:
          '$areaTr alanın düşüş-ve-toparlanma kalıbı izleme eğiliminde. '
          'Bu kalıp kayıtlarında $dropCount kez görünmüş.',
      actionEn:
          'Noticing when $areaEn drops begin may help you respond earlier',
      actionTr:
          '$areaTr düşüşlerinin ne zaman başladığını fark etmek daha erken tepki vermene yardımcı olabilir',
    );
  }

  /// Detect cross-area influence loops (e.g., low energy → low focus pattern)
  List<PatternLoop> _detectCrossAreaLoops(List<JournalEntry> sorted) {
    final loops = <PatternLoop>[];
    final byDate = <String, Map<FocusArea, int>>{};

    for (final e in sorted) {
      byDate.putIfAbsent(e.dateKey, () => {})[e.focusArea] = e.overallRating;
    }

    final areas = FocusArea.values;
    for (int i = 0; i < areas.length; i++) {
      for (int j = i + 1; j < areas.length; j++) {
        // Check if low values in area[i] are followed by low values in area[j]
        int coOccurrenceLow = 0;
        int coOccurrenceHigh = 0;
        int totalPairs = 0;

        for (final dayData in byDate.values) {
          final valA = dayData[areas[i]];
          final valB = dayData[areas[j]];
          if (valA != null && valB != null) {
            totalPairs++;
            if (valA <= 2 && valB <= 2) coOccurrenceLow++;
            if (valA >= 4 && valB >= 4) coOccurrenceHigh++;
          }
        }

        if (totalPairs < 5) continue;

        // Significant co-occurrence of low values
        final lowRatio = coOccurrenceLow / totalPairs;
        if (lowRatio >= 0.3 && coOccurrenceLow >= 3) {
          final areaAEn = areas[i].displayNameEn;
          final areaBEn = areas[j].displayNameEn;
          final areaATr = areas[i].displayNameTr;
          final areaBTr = areas[j].displayNameTr;

          loops.add(PatternLoop(
            id: 'cross_low_${areas[i].name}_${areas[j].name}',
            firstDetected: sorted.isNotEmpty ? sorted.first.date : DateTime.now(),
            lastSeen: sorted.isNotEmpty ? sorted.last.date : DateTime.now(),
            occurrenceCount: coOccurrenceLow,
            primaryArea: areas[i],
            secondaryArea: areas[j],
            reinforcementType: ReinforcementType.negative,
            strength: (lowRatio * 1.5).clamp(0.0, 1.0),
            trigger: LoopStage(
              id: 'trigger',
              labelEn: 'Low $areaAEn',
              labelTr: 'Düşük $areaATr',
            ),
            emotionalShift: LoopStage(
              id: 'shift',
              labelEn: '$areaBEn Follows',
              labelTr: '$areaBTr Takip Ediyor',
            ),
            behavior: LoopStage(
              id: 'behavior',
              labelEn: 'Both Low',
              labelTr: 'İkisi de Düşük',
            ),
            outcome: LoopStage(
              id: 'outcome',
              labelEn: 'Compounding Effect',
              labelTr: 'Birleşik Etki',
            ),
            reinforcement: LoopStage(
              id: 'reinforcement',
              labelEn: 'Pattern Reinforced',
              labelTr: 'Kalıp Pekiştirilmiş',
            ),
            insightEn:
                'When $areaAEn is low, $areaBEn tends to be low too. '
                'This co-occurrence appeared $coOccurrenceLow times.',
            insightTr:
                '$areaATr düşük olduğunda, $areaBTr de düşük olma eğiliminde. '
                'Bu birlikte oluşum $coOccurrenceLow kez görünmüş.',
            actionEn:
                'Addressing $areaAEn early may help prevent $areaBEn from dropping',
            actionTr:
                '$areaATr alanına erken müdahale $areaBTr düşüşünü önlemeye yardımcı olabilir',
          ));
        }

        // Significant co-occurrence of high values (positive loop)
        final highRatio = coOccurrenceHigh / totalPairs;
        if (highRatio >= 0.3 && coOccurrenceHigh >= 3) {
          final areaAEn = areas[i].displayNameEn;
          final areaBEn = areas[j].displayNameEn;
          final areaATr = areas[i].displayNameTr;
          final areaBTr = areas[j].displayNameTr;

          loops.add(PatternLoop(
            id: 'cross_high_${areas[i].name}_${areas[j].name}',
            firstDetected: sorted.isNotEmpty ? sorted.first.date : DateTime.now(),
            lastSeen: sorted.isNotEmpty ? sorted.last.date : DateTime.now(),
            occurrenceCount: coOccurrenceHigh,
            primaryArea: areas[i],
            secondaryArea: areas[j],
            reinforcementType: ReinforcementType.positive,
            strength: (highRatio * 1.5).clamp(0.0, 1.0),
            trigger: LoopStage(
              id: 'trigger',
              labelEn: 'High $areaAEn',
              labelTr: 'Yüksek $areaATr',
            ),
            emotionalShift: LoopStage(
              id: 'shift',
              labelEn: '$areaBEn Lifts',
              labelTr: '$areaBTr Yükseliyor',
            ),
            behavior: LoopStage(
              id: 'behavior',
              labelEn: 'Both Elevated',
              labelTr: 'İkisi de Yüksek',
            ),
            outcome: LoopStage(
              id: 'outcome',
              labelEn: 'Positive Momentum',
              labelTr: 'Pozitif İvme',
            ),
            reinforcement: LoopStage(
              id: 'reinforcement',
              labelEn: 'Virtuous Cycle',
              labelTr: 'Erdemli Döngü',
            ),
            insightEn:
                'When $areaAEn is high, $areaBEn tends to be high too. '
                'This positive pattern appeared $coOccurrenceHigh times.',
            insightTr:
                '$areaATr yüksek olduğunda, $areaBTr de yüksek olma eğiliminde. '
                'Bu pozitif kalıp $coOccurrenceHigh kez görünmüş.',
            actionEn:
                'Investing in $areaAEn may create positive momentum for $areaBEn',
            actionTr:
                '$areaATr alanına yatırım yapmak $areaBTr için pozitif ivme yaratabilir',
          ));
        }
      }
    }

    return loops;
  }

  /// Detect weekday-driven behavioral loops
  PatternLoop? _detectWeekdayLoop(List<JournalEntry> sorted) {
    if (sorted.length < 14) return null;

    // Find weekday with consistently lowest ratings
    final sums = <int, double>{};
    final counts = <int, int>{};

    for (final e in sorted) {
      final day = e.date.weekday;
      sums[day] = (sums[day] ?? 0) + e.overallRating;
      counts[day] = (counts[day] ?? 0) + 1;
    }

    int? lowestDay;
    int? highestDay;
    double lowestAvg = 6;
    double highestAvg = 0;

    for (final day in sums.keys) {
      if ((counts[day] ?? 0) < 2) continue;
      final avg = sums[day]! / counts[day]!;
      if (avg < lowestAvg) {
        lowestAvg = avg;
        lowestDay = day;
      }
      if (avg > highestAvg) {
        highestAvg = avg;
        highestDay = day;
      }
    }

    // Only report if there's a significant gap
    if (lowestDay == null || highestDay == null) return null;
    if (highestAvg - lowestAvg < 1.0) return null;

    final dayNamesEn = [
      '', 'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday',
    ];
    final dayNamesTr = [
      '', 'Pazartesi', 'Salı', 'Çarşamba',
      'Perşembe', 'Cuma', 'Cumartesi', 'Pazar',
    ];

    return PatternLoop(
      id: 'weekday_loop',
      firstDetected: sorted.isNotEmpty ? sorted.first.date : DateTime.now(),
      lastSeen: sorted.isNotEmpty ? sorted.last.date : DateTime.now(),
      occurrenceCount: counts[lowestDay] ?? 0,
      primaryArea: FocusArea.energy,
      reinforcementType: ReinforcementType.neutral,
      strength: ((highestAvg - lowestAvg) / 4).clamp(0.0, 1.0),
      trigger: LoopStage(
        id: 'trigger',
        labelEn: '${dayNamesEn[lowestDay]} Arrives',
        labelTr: '${dayNamesTr[lowestDay]} Geliyor',
      ),
      emotionalShift: LoopStage(
        id: 'shift',
        labelEn: 'Rating Drops',
        labelTr: 'Puanlar Düşüyor',
      ),
      behavior: LoopStage(
        id: 'behavior',
        labelEn: 'Lower Engagement',
        labelTr: 'Daha Düşük Katılım',
      ),
      outcome: LoopStage(
        id: 'outcome',
        labelEn: 'Weekday Recovery',
        labelTr: 'Hafta İçi Toparlanma',
        descriptionEn: 'Ratings tend to recover by ${dayNamesEn[highestDay]}',
        descriptionTr: 'Puanlar ${dayNamesTr[highestDay]} gününe kadar toparlanma eğiliminde',
      ),
      reinforcement: LoopStage(
        id: 'reinforcement',
        labelEn: 'Weekly Rhythm',
        labelTr: 'Haftalık Ritim',
      ),
      insightEn:
          'Your ratings tend to be lowest on ${dayNamesEn[lowestDay]}s '
          '(avg ${lowestAvg.toStringAsFixed(1)}) and highest on '
          '${dayNamesEn[highestDay]}s (avg ${highestAvg.toStringAsFixed(1)})',
      insightTr:
          'Puanların ${dayNamesTr[lowestDay]} günleri en düşük '
          '(ort ${lowestAvg.toStringAsFixed(1)}) ve ${dayNamesTr[highestDay]} '
          'günleri en yüksek (ort ${highestAvg.toStringAsFixed(1)}) olma eğiliminde',
      actionEn:
          'Planning lighter activities on ${dayNamesEn[lowestDay]}s may help',
      actionTr:
          '${dayNamesTr[lowestDay]} günleri daha hafif aktiviteler planlamak yardımcı olabilir',
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadFromStorage() {
    final json = _prefs.getString(_storageKey);
    if (json == null) return;

    try {
      final list = jsonDecode(json) as List;
      _cachedLoops = list
          .map((e) => PatternLoop.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      _cachedLoops = [];
    }
  }

  void _saveToStorage() {
    final json = jsonEncode(_cachedLoops.map((l) => l.toJson()).toList());
    _prefs.setString(_storageKey, json);
  }
}
