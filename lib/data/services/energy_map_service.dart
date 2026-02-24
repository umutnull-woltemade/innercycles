// ════════════════════════════════════════════════════════════════════════════
// ENERGY MAP SERVICE - InnerCycles Heatmap Data
// ════════════════════════════════════════════════════════════════════════════
// Transforms journal data into heatmap-ready structures for energy mapping.
// Uses PatternEngineService for underlying analysis.
// ════════════════════════════════════════════════════════════════════════════

import '../models/journal_entry.dart';
import 'journal_service.dart';

/// A single cell in the energy heatmap
class HeatmapCell {
  final int weekday; // 1=Mon, 7=Sun
  final FocusArea area;
  final double averageRating; // 0.0 if no data, 1.0-5.0 with data
  final int entryCount;

  const HeatmapCell({
    required this.weekday,
    required this.area,
    required this.averageRating,
    required this.entryCount,
  });

  double get intensity => entryCount > 0 ? (averageRating - 1) / 4 : 0;
}

/// Daily energy snapshot
class DailyEnergySnapshot {
  final DateTime date;
  final double averageRating;
  final FocusArea? dominantArea;
  final int entryCount;

  const DailyEnergySnapshot({
    required this.date,
    required this.averageRating,
    this.dominantArea,
    required this.entryCount,
  });
}

/// Weekly energy summary for the heatmap
class EnergyMapData {
  final List<HeatmapCell> cells; // 7 days x 5 areas = 35 cells
  final List<DailyEnergySnapshot> dailySnapshots; // last 28 days
  final double overallAverage;
  final int bestDay; // weekday number
  final int worstDay; // weekday number
  final FocusArea? strongestArea;

  const EnergyMapData({
    required this.cells,
    required this.dailySnapshots,
    required this.overallAverage,
    required this.bestDay,
    required this.worstDay,
    this.strongestArea,
  });
}

class EnergyMapService {
  final JournalService _journalService;

  EnergyMapService(this._journalService);

  /// Build the full heatmap data from journal entries
  EnergyMapData buildHeatmap() {
    final entries = _journalService.getAllEntries();

    // Build 7x5 grid (weekday x focusArea)
    final sums = <String, double>{};
    final counts = <String, int>{};

    for (final e in entries) {
      final key = '${e.date.weekday}_${e.focusArea.index}';
      sums[key] = (sums[key] ?? 0) + e.overallRating;
      counts[key] = (counts[key] ?? 0) + 1;
    }

    final cells = <HeatmapCell>[];
    for (int day = 1; day <= 7; day++) {
      for (final area in FocusArea.values) {
        final key = '${day}_${area.index}';
        final count = counts[key] ?? 0;
        final avg = count > 0 ? ((sums[key] ?? 0.0) / count) : 0.0;
        cells.add(
          HeatmapCell(
            weekday: day,
            area: area,
            averageRating: avg,
            entryCount: count,
          ),
        );
      }
    }

    // Build daily snapshots for last 28 days
    final now = DateTime.now();
    final snapshots = <DailyEnergySnapshot>[];
    for (int i = 27; i >= 0; i--) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayEntries = entries.where((e) => e.dateKey == dateKey).toList();

      if (dayEntries.isNotEmpty) {
        final avg =
            dayEntries.fold<int>(0, (s, e) => s + e.overallRating) /
            dayEntries.length;
        // Find dominant area
        final areaCounts = <FocusArea, int>{};
        for (final e in dayEntries) {
          areaCounts[e.focusArea] = (areaCounts[e.focusArea] ?? 0) + 1;
        }
        final dominant = areaCounts.entries
            .reduce((a, b) => a.value >= b.value ? a : b)
            .key;

        snapshots.add(
          DailyEnergySnapshot(
            date: date,
            averageRating: avg,
            dominantArea: dominant,
            entryCount: dayEntries.length,
          ),
        );
      } else {
        snapshots.add(
          DailyEnergySnapshot(date: date, averageRating: 0, entryCount: 0),
        );
      }
    }

    // Compute day-of-week averages for best/worst
    final daySums = <int, double>{};
    final dayCounts = <int, int>{};
    for (final e in entries) {
      daySums[e.date.weekday] =
          (daySums[e.date.weekday] ?? 0) + e.overallRating;
      dayCounts[e.date.weekday] = (dayCounts[e.date.weekday] ?? 0) + 1;
    }

    int bestDay = 1;
    int worstDay = 1;
    double bestAvg = 0;
    double worstAvg = 6;
    for (final day in daySums.keys) {
      final dayCount = dayCounts[day] ?? 0;
      if (dayCount == 0) continue;
      final avg = (daySums[day] ?? 0.0) / dayCount;
      if (avg > bestAvg) {
        bestAvg = avg;
        bestDay = day;
      }
      if (avg < worstAvg) {
        worstAvg = avg;
        worstDay = day;
      }
    }

    // Overall average
    final overallAvg = entries.isNotEmpty
        ? entries.fold<int>(0, (s, e) => s + e.overallRating) / entries.length
        : 0.0;

    // Strongest area
    final areaAvgs = <FocusArea, double>{};
    for (final area in FocusArea.values) {
      final areaEntries = entries.where((e) => e.focusArea == area);
      if (areaEntries.isNotEmpty) {
        areaAvgs[area] =
            areaEntries.fold<int>(0, (s, e) => s + e.overallRating) /
            areaEntries.length;
      }
    }
    FocusArea? strongestArea;
    if (areaAvgs.isNotEmpty) {
      strongestArea = areaAvgs.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    return EnergyMapData(
      cells: cells,
      dailySnapshots: snapshots,
      overallAverage: overallAvg,
      bestDay: bestDay,
      worstDay: worstDay,
      strongestArea: strongestArea,
    );
  }

  /// Check if there's enough data for a meaningful heatmap
  bool hasEnoughData() => _journalService.entryCount >= 5;
}
