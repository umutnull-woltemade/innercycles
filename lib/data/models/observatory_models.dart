// ════════════════════════════════════════════════════════════════════════════
// OBSERVATORY DATA MODELS
// ════════════════════════════════════════════════════════════════════════════
//
// Data models for the Internal Tech & Content Observatory system.
// Owner-only visibility for platform control and compliance monitoring.
//
// ════════════════════════════════════════════════════════════════════════════

/// Complete observatory summary for dashboard display
class ObservatorySummary {
  final LanguageCoverage languageCoverage;
  final ContentInventory contentInventory;
  final SafetyMetrics safetyMetrics;
  final PlatformHealth platformHealth;
  final DateTime generatedAt;

  const ObservatorySummary({
    required this.languageCoverage,
    required this.contentInventory,
    required this.safetyMetrics,
    required this.platformHealth,
    required this.generatedAt,
  });

  /// Overall health status based on all metrics
  HealthStatus get overallStatus {
    final statuses = [
      languageCoverage.status,
      contentInventory.status,
      safetyMetrics.status,
      platformHealth.status,
    ];

    if (statuses.any((s) => s == HealthStatus.critical)) {
      return HealthStatus.critical;
    }
    if (statuses.any((s) => s == HealthStatus.warning)) {
      return HealthStatus.warning;
    }
    return HealthStatus.healthy;
  }
}

/// Health status enum for all observatory panels
enum HealthStatus {
  healthy,
  warning,
  critical;

  String get label {
    switch (this) {
      case HealthStatus.healthy:
        return 'Healthy';
      case HealthStatus.warning:
        return 'Warning';
      case HealthStatus.critical:
        return 'Critical';
    }
  }

  String get emoji {
    switch (this) {
      case HealthStatus.healthy:
        return '';
      case HealthStatus.warning:
        return '';
      case HealthStatus.critical:
        return '';
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// LANGUAGE COVERAGE MODELS
// ════════════════════════════════════════════════════════════════════════════

/// Language coverage statistics
class LanguageCoverage {
  final int totalStrings;
  final Map<String, LocaleCoverage> locales;
  final int hardcodedCount;
  final List<MissingTranslation> missingTranslations;
  final DateTime lastAuditAt;

  const LanguageCoverage({
    required this.totalStrings,
    required this.locales,
    required this.hardcodedCount,
    required this.missingTranslations,
    required this.lastAuditAt,
  });

  double get averageCompletion {
    if (locales.isEmpty) return 0.0;
    final total = locales.values.fold<double>(
      0,
      (sum, l) => sum + l.completionPercent,
    );
    return total / locales.length;
  }

  HealthStatus get status {
    if (averageCompletion >= 99 && hardcodedCount == 0) {
      return HealthStatus.healthy;
    }
    if (averageCompletion >= 95 && hardcodedCount <= 5) {
      return HealthStatus.warning;
    }
    return HealthStatus.critical;
  }

  factory LanguageCoverage.empty() => LanguageCoverage(
    totalStrings: 0,
    locales: const {},
    hardcodedCount: 0,
    missingTranslations: const [],
    lastAuditAt: DateTime.now(),
  );
}

/// Coverage for a single locale
class LocaleCoverage {
  final String locale;
  final String displayName;
  final int translatedCount;
  final int totalCount;
  final int aiGeneratedCount;
  final int unreviewedCount;

  const LocaleCoverage({
    required this.locale,
    required this.displayName,
    required this.translatedCount,
    required this.totalCount,
    this.aiGeneratedCount = 0,
    this.unreviewedCount = 0,
  });

  double get completionPercent {
    if (totalCount == 0) return 100.0;
    return (translatedCount / totalCount) * 100;
  }

  int get missingCount => totalCount - translatedCount;

  HealthStatus get status {
    if (completionPercent >= 99) return HealthStatus.healthy;
    if (completionPercent >= 95) return HealthStatus.warning;
    return HealthStatus.critical;
  }
}

/// A missing translation entry
class MissingTranslation {
  final String key;
  final List<String> missingLocales;
  final String? pageModule;
  final String namespace;

  const MissingTranslation({
    required this.key,
    required this.missingLocales,
    this.pageModule,
    required this.namespace,
  });
}

/// Detected hardcoded string
class HardcodedString {
  final String filePath;
  final int lineNumber;
  final String detectedString;
  final DateTime detectedAt;
  final bool resolved;
  final String? resolutionKey;

  const HardcodedString({
    required this.filePath,
    required this.lineNumber,
    required this.detectedString,
    required this.detectedAt,
    this.resolved = false,
    this.resolutionKey,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// CONTENT INVENTORY MODELS
// ════════════════════════════════════════════════════════════════════════════

/// Content inventory statistics
class ContentInventory {
  final int totalItems;
  final int aiGeneratedCount;
  final int staticCount;
  final Map<String, int> byCategory;
  final Map<String, int> byLocale;
  final ContentGrowth growth;
  final DateTime lastUpdated;

  const ContentInventory({
    required this.totalItems,
    required this.aiGeneratedCount,
    required this.staticCount,
    required this.byCategory,
    required this.byLocale,
    required this.growth,
    required this.lastUpdated,
  });

  double get aiGeneratedPercent {
    if (totalItems == 0) return 0.0;
    return (aiGeneratedCount / totalItems) * 100;
  }

  HealthStatus get status {
    // Content is healthy if we have substantial inventory
    if (totalItems >= 10000) return HealthStatus.healthy;
    if (totalItems >= 5000) return HealthStatus.warning;
    return HealthStatus.critical;
  }

  factory ContentInventory.empty() => ContentInventory(
    totalItems: 0,
    aiGeneratedCount: 0,
    staticCount: 0,
    byCategory: const {},
    byLocale: const {},
    growth: const ContentGrowth(last7Days: 0, last30Days: 0, dailyTrend: []),
    lastUpdated: DateTime.now(),
  );
}

/// Content growth metrics
class ContentGrowth {
  final int last7Days;
  final int last30Days;
  final List<DailyGrowth> dailyTrend;

  const ContentGrowth({
    required this.last7Days,
    required this.last30Days,
    required this.dailyTrend,
  });
}

/// Daily content growth point
class DailyGrowth {
  final DateTime date;
  final int count;

  const DailyGrowth({required this.date, required this.count});
}

/// Content category breakdown
class ContentCategory {
  final String name;
  final String displayName;
  final int count;
  final int aiGenerated;
  final int static;

  const ContentCategory({
    required this.name,
    required this.displayName,
    required this.count,
    this.aiGenerated = 0,
    this.static = 0,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// SAFETY METRICS MODELS
// ════════════════════════════════════════════════════════════════════════════

/// AI safety and compliance metrics
class SafetyMetrics {
  final int contentProcessed24h;
  final int filterHits24h;
  final int autoRewrites24h;
  final int runtimeBlocks24h;
  final double hitRatePercent;
  final double rewriteSuccessPercent;
  final List<PatternHit> topPatterns;
  final List<SafetyEvent> recentEvents;
  final ReviewModeStatus reviewMode;
  final List<DailySafetyMetric> trend7Days;
  final DateTime lastUpdated;

  const SafetyMetrics({
    required this.contentProcessed24h,
    required this.filterHits24h,
    required this.autoRewrites24h,
    required this.runtimeBlocks24h,
    required this.hitRatePercent,
    required this.rewriteSuccessPercent,
    required this.topPatterns,
    required this.recentEvents,
    required this.reviewMode,
    required this.trend7Days,
    required this.lastUpdated,
  });

  HealthStatus get status {
    // Critical if >10 blocks or hit rate >3%
    if (runtimeBlocks24h > 10 || hitRatePercent > 3) {
      return HealthStatus.critical;
    }
    // Warning if 3-10 blocks or hit rate 1-3%
    if (runtimeBlocks24h >= 3 || hitRatePercent >= 1) {
      return HealthStatus.warning;
    }
    return HealthStatus.healthy;
  }

  factory SafetyMetrics.empty() => SafetyMetrics(
    contentProcessed24h: 0,
    filterHits24h: 0,
    autoRewrites24h: 0,
    runtimeBlocks24h: 0,
    hitRatePercent: 0,
    rewriteSuccessPercent: 100,
    topPatterns: const [],
    recentEvents: const [],
    reviewMode: const ReviewModeStatus(mode: ReviewMode.normal),
    trend7Days: const [],
    lastUpdated: DateTime.now(),
  );
}

/// A pattern that was triggered
class PatternHit {
  final String pattern;
  final int hitCount;
  final DateTime firstHit;
  final DateTime lastHit;
  final bool isActive;

  const PatternHit({
    required this.pattern,
    required this.hitCount,
    required this.firstHit,
    required this.lastHit,
    this.isActive = true,
  });
}

/// A safety event (filter hit, rewrite, block)
class SafetyEvent {
  final String id;
  final SafetyEventType type;
  final String contentHash;
  final String context;
  final String? patternMatched;
  final String? replacementUsed;
  final DateTime timestamp;

  const SafetyEvent({
    required this.id,
    required this.type,
    required this.contentHash,
    required this.context,
    this.patternMatched,
    this.replacementUsed,
    required this.timestamp,
  });
}

/// Safety event types
enum SafetyEventType {
  filterHit,
  rewrite,
  block;

  String get label {
    switch (this) {
      case SafetyEventType.filterHit:
        return 'Filter Hit';
      case SafetyEventType.rewrite:
        return 'Auto-Rewrite';
      case SafetyEventType.block:
        return 'Blocked';
    }
  }
}

/// Review mode status
class ReviewModeStatus {
  final ReviewMode mode;
  final DateTime? activatedAt;
  final String? activatedBy;
  final String? reason;

  const ReviewModeStatus({
    required this.mode,
    this.activatedAt,
    this.activatedBy,
    this.reason,
  });
}

/// Review mode options
enum ReviewMode {
  normal,
  reviewSafe,
  lockdown;

  String get label {
    switch (this) {
      case ReviewMode.normal:
        return 'Normal';
      case ReviewMode.reviewSafe:
        return 'Review-Safe';
      case ReviewMode.lockdown:
        return 'Lockdown';
    }
  }
}

/// Daily safety metrics for trend
class DailySafetyMetric {
  final DateTime date;
  final int hits;
  final int rewrites;
  final int blocks;
  final double hitRate;

  const DailySafetyMetric({
    required this.date,
    required this.hits,
    required this.rewrites,
    required this.blocks,
    required this.hitRate,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// PLATFORM HEALTH MODELS
// ════════════════════════════════════════════════════════════════════════════

/// Platform health status
class PlatformHealth {
  final BuildStatus webBuild;
  final BuildStatus iosBuild;
  final List<CIWorkflow> ciWorkflows;
  final PerformanceMetrics webPerformance;
  final PerformanceMetrics iosPerformance;
  final List<BuildHistoryEntry> buildHistory;
  final DateTime lastUpdated;

  const PlatformHealth({
    required this.webBuild,
    required this.iosBuild,
    required this.ciWorkflows,
    required this.webPerformance,
    required this.iosPerformance,
    required this.buildHistory,
    required this.lastUpdated,
  });

  HealthStatus get status {
    if (webBuild.status == BuildStatusType.failed ||
        iosBuild.status == BuildStatusType.failed) {
      return HealthStatus.critical;
    }
    if (webBuild.status == BuildStatusType.warning ||
        iosBuild.status == BuildStatusType.warning) {
      return HealthStatus.warning;
    }
    return HealthStatus.healthy;
  }

  factory PlatformHealth.empty() => PlatformHealth(
    webBuild: const BuildStatus(
      platform: 'web',
      buildNumber: '-',
      status: BuildStatusType.unknown,
    ),
    iosBuild: const BuildStatus(
      platform: 'ios',
      buildNumber: '-',
      status: BuildStatusType.unknown,
    ),
    ciWorkflows: const [],
    webPerformance: const PerformanceMetrics(
      platform: 'web',
      lighthouseScore: 0,
      crashFreePercent: 0,
      coldStartMs: 0,
      bundleSizeMb: 0,
    ),
    iosPerformance: const PerformanceMetrics(
      platform: 'ios',
      lighthouseScore: 0,
      crashFreePercent: 0,
      coldStartMs: 0,
      bundleSizeMb: 0,
    ),
    buildHistory: const [],
    lastUpdated: DateTime.now(),
  );
}

/// Build status for a platform
class BuildStatus {
  final String platform;
  final String buildNumber;
  final BuildStatusType status;
  final String? commitSha;
  final Duration? duration;
  final DateTime? completedAt;
  final String? triggeredBy;

  const BuildStatus({
    required this.platform,
    required this.buildNumber,
    required this.status,
    this.commitSha,
    this.duration,
    this.completedAt,
    this.triggeredBy,
  });
}

/// Build status types
enum BuildStatusType {
  success,
  failed,
  building,
  warning,
  unknown;

  String get label {
    switch (this) {
      case BuildStatusType.success:
        return 'Success';
      case BuildStatusType.failed:
        return 'Failed';
      case BuildStatusType.building:
        return 'Building';
      case BuildStatusType.warning:
        return 'Warning';
      case BuildStatusType.unknown:
        return 'Unknown';
    }
  }

  String get emoji {
    switch (this) {
      case BuildStatusType.success:
        return '';
      case BuildStatusType.failed:
        return '';
      case BuildStatusType.building:
        return '';
      case BuildStatusType.warning:
        return '';
      case BuildStatusType.unknown:
        return '';
    }
  }
}

/// CI workflow status
class CIWorkflow {
  final String name;
  final String runId;
  final BuildStatusType status;
  final Duration? duration;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? logsUrl;

  const CIWorkflow({
    required this.name,
    required this.runId,
    required this.status,
    this.duration,
    this.startedAt,
    this.completedAt,
    this.logsUrl,
  });
}

/// Performance metrics for a platform
class PerformanceMetrics {
  final String platform;
  final int lighthouseScore;
  final double crashFreePercent;
  final int coldStartMs;
  final double bundleSizeMb;
  final int? scoreChange;

  const PerformanceMetrics({
    required this.platform,
    required this.lighthouseScore,
    required this.crashFreePercent,
    required this.coldStartMs,
    required this.bundleSizeMb,
    this.scoreChange,
  });
}

/// Build history entry
class BuildHistoryEntry {
  final String platform;
  final String buildNumber;
  final BuildStatusType status;
  final DateTime completedAt;

  const BuildHistoryEntry({
    required this.platform,
    required this.buildNumber,
    required this.status,
    required this.completedAt,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// TECHNOLOGY INVENTORY MODELS
// ════════════════════════════════════════════════════════════════════════════

/// A proprietary technology/engine
class TechnologyEngine {
  final String name;
  final String purpose;
  final List<String> inputs;
  final List<String> outputs;
  final String appleSafetyRole;
  final bool isUserFacing;
  final String? filePath;

  const TechnologyEngine({
    required this.name,
    required this.purpose,
    required this.inputs,
    required this.outputs,
    required this.appleSafetyRole,
    required this.isUserFacing,
    this.filePath,
  });
}

/// Complete technology inventory
class TechnologyInventory {
  final List<TechnologyEngine> engines;
  final DateTime lastUpdated;

  const TechnologyInventory({
    required this.engines,
    required this.lastUpdated,
  });

  static TechnologyInventory get standard => TechnologyInventory(
    engines: const [
      TechnologyEngine(
        name: 'Language Engine',
        purpose: 'Multi-language translation with strict isolation',
        inputs: ['User locale', 'String keys', 'Parameters'],
        outputs: ['Localized strings (EN/TR/DE/FR)'],
        appleSafetyRole: 'Ensures no cross-language leakage',
        isUserFacing: false,
        filePath: 'lib/data/services/l10n_service.dart',
      ),
      TechnologyEngine(
        name: 'Content Safety Filter',
        purpose: 'Runtime App Store 4.3(b) compliance',
        inputs: ['AI-generated text', 'Context identifier'],
        outputs: ['Filtered safe content', 'Privacy-safe telemetry'],
        appleSafetyRole: 'Core 4.3(b) compliance, blocks prediction language',
        isUserFacing: false,
        filePath: 'lib/data/services/content_safety_filter.dart',
      ),
      TechnologyEngine(
        name: 'Reflection Engine',
        purpose: 'Transform concepts into self-reflection prompts',
        inputs: ['Birth data', 'Preferences', 'Current date'],
        outputs: ['Reflection prompts', 'Personal insights'],
        appleSafetyRole: 'Reframes predictions as insights',
        isUserFacing: true,
      ),
      TechnologyEngine(
        name: 'Pattern Detection Engine',
        purpose: 'Symbol and theme analysis',
        inputs: ['Dream text', 'Journal entries'],
        outputs: ['Pattern metadata', 'Symbol connections'],
        appleSafetyRole: 'Educational framing only',
        isUserFacing: true,
      ),
      TechnologyEngine(
        name: 'Personalization Engine',
        purpose: 'Session and preference management',
        inputs: ['User interactions', 'Settings'],
        outputs: ['Personalized content weights'],
        appleSafetyRole: 'No predictive claims',
        isUserFacing: false,
      ),
      TechnologyEngine(
        name: 'Dream Analysis Engine',
        purpose: '7-dimensional dream interpretation',
        inputs: ['Dream narrative', 'Mood', 'Previous patterns'],
        outputs: ['Symbol interpretations', 'Emotional readings'],
        appleSafetyRole: 'Entertainment disclaimer required',
        isUserFacing: true,
        filePath: 'lib/data/services/dream_ai_engine.dart',
      ),
      TechnologyEngine(
        name: 'Numerology Engine',
        purpose: 'Numerical pattern calculation',
        inputs: ['Birth date', 'Name'],
        outputs: ['Life path analysis', 'Number meanings'],
        appleSafetyRole: 'Self-discovery framing',
        isUserFacing: true,
        filePath: 'lib/data/services/numerology_calculation_service.dart',
      ),
      TechnologyEngine(
        name: 'Tarot Engine',
        purpose: 'Card spread generation and interpretation',
        inputs: ['Spread type', 'Query context'],
        outputs: ['Card draws', 'Interpretations'],
        appleSafetyRole: 'Reflection-based language only',
        isUserFacing: true,
        filePath: 'lib/data/services/tarot_service.dart',
      ),
      TechnologyEngine(
        name: 'Rollout Engine',
        purpose: 'ML-based feature deployment',
        inputs: ['Feature flags', 'User metrics'],
        outputs: ['Rollout decisions', 'A/B assignments'],
        appleSafetyRole: 'N/A - Internal only',
        isUserFacing: false,
        filePath: 'lib/data/services/hybrid_rollout_engine.dart',
      ),
      TechnologyEngine(
        name: 'Analytics Engine',
        purpose: 'Privacy-safe event tracking',
        inputs: ['User events (non-PII)'],
        outputs: ['Aggregated metrics', 'KPI calculations'],
        appleSafetyRole: 'Privacy-safe logging, hash-only',
        isUserFacing: false,
        filePath: 'lib/data/services/admin_analytics_service.dart',
      ),
    ],
    lastUpdated: DateTime.now(),
  );
}
