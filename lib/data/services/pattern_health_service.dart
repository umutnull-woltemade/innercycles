// ════════════════════════════════════════════════════════════════════════════
// PATTERN HEALTH SERVICE - InnerCycles Dimension Health Analysis
// ════════════════════════════════════════════════════════════════════════════
// Compares last 30 days vs previous 30 days across all FocusArea dimensions.
// Produces health status (green/yellow/red), alerts, and improvement notes.
// ════════════════════════════════════════════════════════════════════════════

import '../models/journal_entry.dart';
import 'journal_service.dart';
import 'pattern_engine_service.dart' show TrendDirection;

// ══════════════════════════════════════════════════════════════════════════
// ENUMS
// ══════════════════════════════════════════════════════════════════════════

enum HealthStatus { green, yellow, red }

// ══════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ══════════════════════════════════════════════════════════════════════════

class DimensionHealth {
  final FocusArea area;
  final HealthStatus status;
  final double currentAvg;
  final double previousAvg;
  final TrendDirection trendDirection;
  final double changePercent;

  const DimensionHealth({
    required this.area,
    required this.status,
    required this.currentAvg,
    required this.previousAvg,
    required this.trendDirection,
    required this.changePercent,
  });
}

class HealthAlert {
  final String titleEn;
  final String titleTr;
  final HealthStatus severity;
  final FocusArea area;

  const HealthAlert({
    required this.titleEn,
    required this.titleTr,
    required this.severity,
    required this.area,
  });
}

class PatternHealthReport {
  final HealthStatus overallHealth;
  final Map<FocusArea, DimensionHealth> dimensionHealth;
  final List<HealthAlert> alerts;
  final List<String> improvements;
  final DateTime lastUpdated;

  const PatternHealthReport({
    required this.overallHealth,
    required this.dimensionHealth,
    required this.alerts,
    required this.improvements,
    required this.lastUpdated,
  });
}

// ══════════════════════════════════════════════════════════════════════════
// PATTERN HEALTH SERVICE
// ══════════════════════════════════════════════════════════════════════════

class PatternHealthService {
  final JournalService _journalService;

  PatternHealthService(this._journalService);

  /// Factory init that takes a JournalService parameter
  static Future<PatternHealthService> init(
    JournalService journalService,
  ) async {
    return PatternHealthService(journalService);
  }

  /// Analyze health across all dimensions for last 30 days vs previous 30 days
  Future<PatternHealthReport> analyzeHealth() async {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final sixtyDaysAgo = now.subtract(const Duration(days: 60));

    final currentEntries = _journalService.getEntriesByDateRange(
      thirtyDaysAgo,
      now,
    );
    final previousEntries = _journalService.getEntriesByDateRange(
      sixtyDaysAgo,
      thirtyDaysAgo,
    );

    final dimensionMap = <FocusArea, DimensionHealth>{};
    final alerts = <HealthAlert>[];
    final improvements = <String>[];

    for (final area in FocusArea.values) {
      final currentAvg = _averageForArea(currentEntries, area);
      final previousAvg = _averageForArea(previousEntries, area);
      final diff = currentAvg - previousAvg;
      final changePercent = previousAvg > 0
          ? ((diff) / previousAvg) * 100
          : 0.0;

      final trendDirection = diff > 0.1
          ? TrendDirection.up
          : diff < -0.1
          ? TrendDirection.down
          : TrendDirection.stable;

      final status = _classifyStatus(currentAvg, previousAvg);

      dimensionMap[area] = DimensionHealth(
        area: area,
        status: status,
        currentAvg: currentAvg,
        previousAvg: previousAvg,
        trendDirection: trendDirection,
        changePercent: changePercent,
      );

      // Generate alerts for red/yellow areas
      if (status == HealthStatus.red) {
        alerts.add(_buildAlert(area, status, currentAvg, diff));
      } else if (status == HealthStatus.yellow) {
        alerts.add(_buildAlert(area, status, currentAvg, diff));
      }

      // Generate improvement messages for green areas trending up
      if (status == HealthStatus.green && trendDirection == TrendDirection.up) {
        improvements.add(
          '${area.displayNameEn} is trending upward - keep it up!',
        );
      }
    }

    // Cap alerts to 3 and improvements to 2
    final cappedAlerts = alerts.length > 3 ? alerts.sublist(0, 3) : alerts;
    final cappedImprovements = improvements.length > 2
        ? improvements.sublist(0, 2)
        : improvements;

    // Determine overall health
    final greenCount = dimensionMap.values
        .where((d) => d.status == HealthStatus.green)
        .length;
    final redCount = dimensionMap.values
        .where((d) => d.status == HealthStatus.red)
        .length;

    HealthStatus overallHealth;
    if (redCount >= 2) {
      overallHealth = HealthStatus.red;
    } else if (greenCount >= 3) {
      overallHealth = HealthStatus.green;
    } else {
      overallHealth = HealthStatus.yellow;
    }

    return PatternHealthReport(
      overallHealth: overallHealth,
      dimensionHealth: dimensionMap,
      alerts: cappedAlerts,
      improvements: cappedImprovements,
      lastUpdated: now,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  double _averageForArea(List<JournalEntry> entries, FocusArea area) {
    final areaEntries = entries.where((e) => e.focusArea == area).toList();
    if (areaEntries.isEmpty) return 0.0;
    final sum = areaEntries.fold<int>(0, (s, e) => s + e.overallRating);
    return sum / areaEntries.length;
  }

  /// Green: current >= previous OR current > 3.5
  /// Yellow: current < previous by 0.3-0.7 AND current between 2.5-3.5
  /// Red: current < previous by > 0.7 OR current < 2.5
  HealthStatus _classifyStatus(double currentAvg, double previousAvg) {
    final drop = previousAvg - currentAvg;

    // Red: significant drop or very low score
    if (drop > 0.7 || currentAvg < 2.5) {
      return HealthStatus.red;
    }

    // Green: improving or high score
    if (currentAvg >= previousAvg || currentAvg > 3.5) {
      return HealthStatus.green;
    }

    // Yellow: moderate decline in mid range
    if (drop >= 0.3 && drop <= 0.7 && currentAvg >= 2.5 && currentAvg <= 3.5) {
      return HealthStatus.yellow;
    }

    // Default to green for small drops with decent scores
    return HealthStatus.green;
  }

  HealthAlert _buildAlert(
    FocusArea area,
    HealthStatus severity,
    double currentAvg,
    double diff,
  ) {
    if (severity == HealthStatus.red) {
      if (currentAvg < 2.5) {
        return HealthAlert(
          titleEn:
              '${area.displayNameEn} is low at ${currentAvg.toStringAsFixed(1)} - consider giving it more attention',
          titleTr:
              '${area.displayNameTr} ${currentAvg.toStringAsFixed(1)} ile düşük - daha fazla dikkat göstermeyi deneyin',
          severity: severity,
          area: area,
        );
      }
      return HealthAlert(
        titleEn:
            '${area.displayNameEn} dropped significantly (${diff.toStringAsFixed(1)}) from previous period',
        titleTr:
            '${area.displayNameTr} önceki döneme göre belirgin düştü (${diff.toStringAsFixed(1)})',
        severity: severity,
        area: area,
      );
    }

    // Yellow
    return HealthAlert(
      titleEn:
          '${area.displayNameEn} shows a slight decline - you may want to check in with yourself',
      titleTr:
          '${area.displayNameTr} hafif bir düşüş gösteriyor - kendinize bir sorun',
      severity: severity,
      area: area,
    );
  }
}
