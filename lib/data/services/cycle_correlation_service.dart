import 'package:innercycles/data/providers/app_providers.dart';
// ════════════════════════════════════════════════════════════════════════════
// CYCLE CORRELATION SERVICE - Hormonal × Emotional Pattern Analysis
// ════════════════════════════════════════════════════════════════════════════
// Cross-references journal entries with cycle phases to reveal how
// emotional patterns correlate with hormonal phases.
// ════════════════════════════════════════════════════════════════════════════

import '../models/cycle_entry.dart';
import '../models/journal_entry.dart';
import 'cycle_sync_service.dart';
import 'journal_service.dart';

/// A correlation insight for a specific focus area across cycle phases
class CycleCorrelationInsight {
  final FocusArea focusArea;
  final Map<CyclePhase, double> phaseAverages;
  final CyclePhase? strongestPhase;
  final CyclePhase? weakestPhase;
  final double varianceAcrossPhases;

  const CycleCorrelationInsight({
    required this.focusArea,
    required this.phaseAverages,
    this.strongestPhase,
    this.weakestPhase,
    required this.varianceAcrossPhases,
  });

  /// Whether this insight is significant enough to show
  bool get isSignificant => varianceAcrossPhases >= 0.5;
}

/// Heatmap cell for cycle day × focus area
class CycleHeatmapCell {
  final int cycleDay;
  final FocusArea focusArea;
  final double averageRating;
  final int sampleCount;

  const CycleHeatmapCell({
    required this.cycleDay,
    required this.focusArea,
    required this.averageRating,
    required this.sampleCount,
  });
}

/// Summary of emotional patterns for a single cycle phase
class PhaseSummary {
  final CyclePhase phase;
  final double averageOverallRating;
  final Map<FocusArea, double> focusAreaAverages;
  final int entryCount;

  const PhaseSummary({
    required this.phase,
    required this.averageOverallRating,
    required this.focusAreaAverages,
    required this.entryCount,
  });
}

class CycleCorrelationService {
  final CycleSyncService _cycleSyncService;
  final JournalService _journalService;

  CycleCorrelationService(this._cycleSyncService, this._journalService);

  /// Minimum entries per phase to consider data reliable
  static const int minEntriesPerPhase = 2;

  /// Whether there's enough data for correlation analysis
  bool hasEnoughData() {
    if (!_cycleSyncService.hasEnoughData) return false;
    final entries = _journalService.getAllEntries();
    return entries.length >= 7;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PHASE SUMMARIES
  // ═══════════════════════════════════════════════════════════════════════

  /// Get emotional summary for each cycle phase
  List<PhaseSummary> getPhaseSummaries() {
    if (!hasEnoughData()) return [];

    final entries = _journalService.getAllEntries();
    final phaseEntries = <CyclePhase, List<JournalEntry>>{};

    for (final entry in entries) {
      final phase = _cycleSyncService.getPhaseForDate(entry.date);
      if (phase != null) {
        phaseEntries.putIfAbsent(phase, () => []).add(entry);
      }
    }

    return CyclePhase.values.map((phase) {
      final phaseData = phaseEntries[phase] ?? [];
      if (phaseData.isEmpty) {
        return PhaseSummary(
          phase: phase,
          averageOverallRating: 0,
          focusAreaAverages: {},
          entryCount: 0,
        );
      }

      final avgOverall =
          phaseData.map((e) => e.overallRating).reduce((a, b) => a + b) /
          phaseData.length;

      final focusAverages = <FocusArea, double>{};
      for (final area in FocusArea.values) {
        final areaEntries = phaseData
            .where((e) => e.focusArea == area)
            .toList();
        if (areaEntries.isNotEmpty) {
          focusAverages[area] =
              areaEntries.map((e) => e.overallRating).reduce((a, b) => a + b) /
              areaEntries.length;
        }
      }

      return PhaseSummary(
        phase: phase,
        averageOverallRating: avgOverall,
        focusAreaAverages: focusAverages,
        entryCount: phaseData.length,
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // CORRELATION INSIGHTS
  // ═══════════════════════════════════════════════════════════════════════

  /// Get correlation insights per focus area across phases
  List<CycleCorrelationInsight> getCorrelationInsights() {
    if (!hasEnoughData()) return [];

    final summaries = getPhaseSummaries();
    final insights = <CycleCorrelationInsight>[];

    for (final area in FocusArea.values) {
      final phaseAvgs = <CyclePhase, double>{};
      for (final summary in summaries) {
        if (summary.focusAreaAverages.containsKey(area) &&
            summary.entryCount >= minEntriesPerPhase) {
          phaseAvgs[summary.phase] = summary.focusAreaAverages[area]!;
        }
      }

      if (phaseAvgs.length < 2) continue;

      final values = phaseAvgs.values.toList();
      final mean = values.reduce((a, b) => a + b) / values.length;
      final variance =
          values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
          values.length;

      CyclePhase? strongest;
      CyclePhase? weakest;
      double maxAvg = 0;
      double minAvg = 6;
      for (final entry in phaseAvgs.entries) {
        if (entry.value > maxAvg) {
          maxAvg = entry.value;
          strongest = entry.key;
        }
        if (entry.value < minAvg) {
          minAvg = entry.value;
          weakest = entry.key;
        }
      }

      insights.add(
        CycleCorrelationInsight(
          focusArea: area,
          phaseAverages: phaseAvgs,
          strongestPhase: strongest,
          weakestPhase: weakest,
          varianceAcrossPhases: variance,
        ),
      );
    }

    // Sort by variance (most significant first)
    insights.sort(
      (a, b) => b.varianceAcrossPhases.compareTo(a.varianceAcrossPhases),
    );
    return insights;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HEATMAP DATA
  // ═══════════════════════════════════════════════════════════════════════

  /// Generate heatmap data: cycle day (1..cycleLength) × FocusArea
  List<CycleHeatmapCell> getHeatmapData() {
    if (!hasEnoughData()) return [];

    final entries = _journalService.getAllEntries();
    final cycleLen = _cycleSyncService.getAverageCycleLength();

    // Accumulate ratings per (cycleDay, focusArea)
    final sums = <String, double>{};
    final counts = <String, int>{};

    for (final entry in entries) {
      final phase = _cycleSyncService.getPhaseForDate(entry.date);
      if (phase == null) continue;

      // Calculate cycle day for this entry
      CyclePeriodLog? relevantLog;
      for (final log in _cycleSyncService.getAllLogs()) {
        final diff = entry.date.difference(log.periodStartDate).inDays;
        if (diff >= 0 && diff < cycleLen) {
          relevantLog = log;
          break;
        }
      }
      if (relevantLog == null) continue;

      final cycleDay =
          entry.date.difference(relevantLog.periodStartDate).inDays + 1;
      if (cycleDay < 1 || cycleDay > cycleLen) continue;

      final key = '${cycleDay}_${entry.focusArea.name}';
      sums[key] = (sums[key] ?? 0) + entry.overallRating;
      counts[key] = (counts[key] ?? 0) + 1;
    }

    final cells = <CycleHeatmapCell>[];
    for (int day = 1; day <= cycleLen; day++) {
      for (final area in FocusArea.values) {
        final key = '${day}_${area.name}';
        final count = counts[key] ?? 0;
        if (count > 0) {
          cells.add(
            CycleHeatmapCell(
              cycleDay: day,
              focusArea: area,
              averageRating: (sums[key] ?? 0.0) / count,
              sampleCount: count,
            ),
          );
        }
      }
    }
    return cells;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SAFE-LANGUAGE INSIGHT MESSAGES
  // ═══════════════════════════════════════════════════════════════════════

  /// Generate bilingual insight message for the current phase
  String? getCurrentPhaseInsight(AppLanguage language) {
    final phase = _cycleSyncService.getCurrentPhase();
    if (phase == null) return null;

    final summaries = getPhaseSummaries();
    final currentSummary = summaries
        .where((s) => s.phase == phase && s.entryCount >= minEntriesPerPhase)
        .firstOrNull;
    if (currentSummary == null) return null;

    final insights = getCorrelationInsights();
    final topInsight = insights.where((i) => i.isSignificant).firstOrNull;

    if (topInsight == null) return null;

    final areaName = topInsight.focusArea.localizedName(isEn);
    final strongPhase = topInsight.strongestPhase;
    final weakPhase = topInsight.weakestPhase;

    if (strongPhase == phase) {
      return isEn
          ? 'Your $areaName tends to be stronger during this phase of your cycle.'
          : '$areaName, döngünüzün bu evresinde daha güçlü olma eğiliminde.';
    } else if (weakPhase == phase) {
      return isEn
          ? 'Your $areaName may need extra attention during this phase.'
          : '$areaName, bu evrede ekstra ilgi gerektirebilir.';
    }
    return null;
  }
}
