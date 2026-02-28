// ════════════════════════════════════════════════════════════════════════════
// CYCLE SYNC SERVICE - Hormonal Cycle Tracking & Phase Detection
// ════════════════════════════════════════════════════════════════════════════
// Tracks menstrual cycle data to correlate with emotional patterns.
// Persistence: SharedPreferences, same pattern as MoodCheckinService.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/cycle_entry.dart';
import '../mixins/supabase_sync_mixin.dart';

class CycleSyncService with SupabaseSyncMixin {
  @override
  String get tableName => 'cycle_period_logs';
  static const String _periodLogsKey = 'inner_cycles_period_logs';
  static const String _cycleLengthKey = 'inner_cycles_avg_cycle_length';
  static const String _periodLengthKey = 'inner_cycles_avg_period_length';
  static const _uuid = Uuid();
  final SharedPreferences _prefs;
  List<CyclePeriodLog> _periodLogs = [];

  /// Default cycle length if insufficient data
  static const int defaultCycleLength = 28;

  /// Default period length if insufficient data
  static const int defaultPeriodLength = 5;

  CycleSyncService._(this._prefs) {
    _load();
  }

  static Future<CycleSyncService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return CycleSyncService._(prefs);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PERIOD LOGGING
  // ═══════════════════════════════════════════════════════════════════════

  /// Log a period start date
  Future<void> logPeriodStart({
    required DateTime date,
    FlowIntensity? flowIntensity,
    List<String> symptoms = const [],
  }) async {
    final today = DateTime(date.year, date.month, date.day);

    // Don't add duplicate for same day
    _periodLogs.removeWhere((l) {
      final d = l.periodStartDate;
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day;
    });

    final log = CyclePeriodLog(
      id: _uuid.v4(),
      periodStartDate: today,
      flowIntensity: flowIntensity,
      symptoms: symptoms,
    );

    _periodLogs.insert(0, log);

    // Sort by date descending
    _periodLogs.sort((a, b) => b.periodStartDate.compareTo(a.periodStartDate));

    // Keep last 24 months of data
    if (_periodLogs.length > 24) {
      _periodLogs = _periodLogs.sublist(0, 24);
    }

    _recalculateAverages();
    await _persist();

    // Sync to Supabase
    _queueLogSync(log);
  }

  /// Mark period end for the most recent period
  Future<void> logPeriodEnd(DateTime date) async {
    if (_periodLogs.isEmpty) return;
    final latest = _periodLogs.first;
    final endDate = DateTime(date.year, date.month, date.day);

    final updated = CyclePeriodLog(
      id: latest.id,
      periodStartDate: latest.periodStartDate,
      periodEndDate: endDate,
      flowIntensity: latest.flowIntensity,
      symptoms: latest.symptoms,
    );

    _periodLogs[0] = updated;

    _recalculateAverages();
    await _persist();

    // Sync to Supabase
    _queueLogSync(updated);
  }

  /// Delete a period log
  Future<void> deletePeriodLog(String id) async {
    _periodLogs.removeWhere((l) => l.id == id);
    _recalculateAverages();
    await _persist();

    // Soft-delete remotely
    queueSoftDelete(id);
  }

  void _queueLogSync(CyclePeriodLog log) {
    queueSync('UPSERT', log.id, {
      'id': log.id,
      'period_start_date': log.dateKey,
      'period_end_date': log.periodEndDate != null
          ? '${log.periodEndDate!.year}-${log.periodEndDate!.month.toString().padLeft(2, '0')}-${log.periodEndDate!.day.toString().padLeft(2, '0')}'
          : null,
      'flow_intensity': log.flowIntensity?.name,
      'symptoms': log.symptoms,
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PHASE CALCULATION
  // ═══════════════════════════════════════════════════════════════════════

  /// Get the current cycle day (1-based)
  int? getCurrentCycleDay() {
    if (_periodLogs.isEmpty) return null;
    final lastPeriodStart = _periodLogs.first.periodStartDate;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(lastPeriodStart).inDays;
    if (diff < 0) return null;
    final cycleLen = getAverageCycleLength();
    // Wrap around if past cycle length (new cycle started)
    return (diff % cycleLen) + 1;
  }

  /// Get the current cycle phase
  CyclePhase? getCurrentPhase() {
    final day = getCurrentCycleDay();
    if (day == null) return null;
    return getPhaseForDay(day);
  }

  /// Determine which phase a given cycle day falls in
  CyclePhase getPhaseForDay(int cycleDay) {
    final periodLen = getAveragePeriodLength();
    final cycleLen = getAverageCycleLength();

    // Phase boundaries (approximate, evidence-based)
    // Menstrual: day 1 to periodLength
    // Follicular: periodLength+1 to ~day 13
    // Ovulatory: ~day 13 to ~day 16
    // Luteal: ~day 17 to end of cycle
    final follicularEnd = (cycleLen * 0.46).round(); // ~day 13 for 28-day
    final ovulatoryEnd = (cycleLen * 0.57).round(); // ~day 16 for 28-day

    if (cycleDay <= periodLen) return CyclePhase.menstrual;
    if (cycleDay <= follicularEnd) return CyclePhase.follicular;
    if (cycleDay <= ovulatoryEnd) return CyclePhase.ovulatory;
    return CyclePhase.luteal;
  }

  /// Get phase for a specific date
  CyclePhase? getPhaseForDate(DateTime date) {
    if (_periodLogs.isEmpty) return null;

    // Find which cycle this date falls in
    final target = DateTime(date.year, date.month, date.day);

    for (int i = 0; i < _periodLogs.length; i++) {
      final periodStart = _periodLogs[i].periodStartDate;
      final diff = target.difference(periodStart).inDays;

      if (diff >= 0) {
        final cycleLen = getAverageCycleLength();
        if (diff < cycleLen || i == 0) {
          final cycleDay = diff + 1;
          return getPhaseForDay(cycleDay);
        }
      }
    }
    return null;
  }

  /// Get the estimated next period start date
  DateTime? getNextPeriodEstimate() {
    if (_periodLogs.isEmpty) return null;
    final lastStart = _periodLogs.first.periodStartDate;
    return lastStart.add(Duration(days: getAverageCycleLength()));
  }

  /// Days until next estimated period
  int? getDaysUntilNextPeriod() {
    final next = getNextPeriodEstimate();
    if (next == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = next.difference(today).inDays;
    return diff > 0 ? diff : 0;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // AVERAGES
  // ═══════════════════════════════════════════════════════════════════════

  /// Get average cycle length from logged data
  int getAverageCycleLength() {
    return _prefs.getInt(_cycleLengthKey) ?? defaultCycleLength;
  }

  /// Get average period length from logged data
  int getAveragePeriodLength() {
    return _prefs.getInt(_periodLengthKey) ?? defaultPeriodLength;
  }

  void _recalculateAverages() {
    if (_periodLogs.length < 2) return;

    // Cycle length: gaps between consecutive period starts
    final gaps = <int>[];
    for (int i = 0; i < _periodLogs.length - 1; i++) {
      final gap = _periodLogs[i].periodStartDate
          .difference(_periodLogs[i + 1].periodStartDate)
          .inDays;
      // Only count reasonable cycle lengths (21-45 days)
      if (gap >= 21 && gap <= 45) {
        gaps.add(gap);
      }
    }
    if (gaps.isNotEmpty) {
      final avg = gaps.reduce((a, b) => a + b) ~/ gaps.length;
      _prefs.setInt(_cycleLengthKey, avg);
    }

    // Period length: from start to end where available
    final periodLens = <int>[];
    for (final log in _periodLogs) {
      if (log.periodEndDate != null) {
        final len =
            log.periodEndDate!.difference(log.periodStartDate).inDays + 1;
        if (len >= 1 && len <= 10) {
          periodLens.add(len);
        }
      }
    }
    if (periodLens.isNotEmpty) {
      final avg = periodLens.reduce((a, b) => a + b) ~/ periodLens.length;
      _prefs.setInt(_periodLengthKey, avg);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // REMOTE MERGE
  // ═══════════════════════════════════════════════════════════════════════

  /// Merge cycle logs pulled from Supabase into local storage.
  Future<void> mergeRemoteLogs(List<Map<String, dynamic>> remoteData) async {
    for (final row in remoteData) {
      final id = row['id'] as String;
      final isDeleted = row['is_deleted'] as bool? ?? false;

      if (isDeleted) {
        _periodLogs.removeWhere((l) => l.id == id);
        continue;
      }

      final log = CyclePeriodLog(
        id: id,
        periodStartDate:
            DateTime.tryParse(row['period_start_date']?.toString() ?? '') ??
            DateTime.now(),
        periodEndDate: row['period_end_date'] != null
            ? DateTime.tryParse(row['period_end_date'].toString())
            : null,
        flowIntensity: row['flow_intensity'] != null
            ? FlowIntensity.values.firstWhere(
                (e) => e.name == row['flow_intensity'],
                orElse: () => FlowIntensity.medium,
              )
            : null,
        symptoms:
            (row['symptoms'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

      final existingIdx = _periodLogs.indexWhere((l) => l.id == id);
      if (existingIdx >= 0) {
        _periodLogs[existingIdx] = log;
      } else {
        _periodLogs.add(log);
      }
    }

    _periodLogs.sort((a, b) => b.periodStartDate.compareTo(a.periodStartDate));
    _recalculateAverages();
    await _persist();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // QUERIES
  // ═══════════════════════════════════════════════════════════════════════

  /// Get all period logs
  List<CyclePeriodLog> getAllLogs() => List.unmodifiable(_periodLogs);

  /// Whether the user has logged at least one period
  bool get hasData => _periodLogs.isNotEmpty;

  /// Whether there's enough data for cycle analysis
  bool get hasEnoughData => _periodLogs.length >= 2;

  /// Get the most recent period log
  CyclePeriodLog? get latestLog =>
      _periodLogs.isNotEmpty ? _periodLogs.first : null;

  // ═══════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ═══════════════════════════════════════════════════════════════════════

  void _load() {
    final jsonString = _prefs.getString(_periodLogsKey);
    if (jsonString != null) {
      try {
        final list = json.decode(jsonString) as List<dynamic>;
        _periodLogs = list
            .map((e) => CyclePeriodLog.fromJson(e as Map<String, dynamic>))
            .toList();
        // Ensure sorted
        _periodLogs.sort(
          (a, b) => b.periodStartDate.compareTo(a.periodStartDate),
        );
      } catch (e) {
        debugPrint('CycleSyncService._load: JSON decode failed: $e');
        _periodLogs = [];
      }
    }
  }

  Future<void> _persist() async {
    final jsonList = _periodLogs.map((e) => e.toJson()).toList();
    await _prefs.setString(_periodLogsKey, json.encode(jsonList));
  }
}
