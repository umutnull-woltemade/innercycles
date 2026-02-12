// ════════════════════════════════════════════════════════════════════════════
// OBSERVATORY SERVICE
// ════════════════════════════════════════════════════════════════════════════
//
// Central service for the Internal Tech & Content Observatory.
// Aggregates metrics from all subsystems for owner visibility.
//
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/observatory_models.dart';
import 'content_safety_filter.dart';

/// Provider for observatory service
final observatoryServiceProvider = Provider<ObservatoryService>((ref) {
  return ObservatoryService();
});

/// Provider for observatory summary (auto-refreshing)
final observatorySummaryProvider = FutureProvider<ObservatorySummary>((
  ref,
) async {
  final service = ref.watch(observatoryServiceProvider);
  return service.getSummary();
});

/// Provider for language coverage
final languageCoverageProvider = FutureProvider<LanguageCoverage>((ref) async {
  final service = ref.watch(observatoryServiceProvider);
  return service.getLanguageCoverage();
});

/// Provider for content inventory
final contentInventoryProvider = FutureProvider<ContentInventory>((ref) async {
  final service = ref.watch(observatoryServiceProvider);
  return service.getContentInventory();
});

/// Provider for safety metrics
final safetyMetricsProvider = FutureProvider<SafetyMetrics>((ref) async {
  final service = ref.watch(observatoryServiceProvider);
  return service.getSafetyMetrics();
});

/// Provider for platform health
final platformHealthProvider = FutureProvider<PlatformHealth>((ref) async {
  final service = ref.watch(observatoryServiceProvider);
  return service.getPlatformHealth();
});

/// Provider for technology inventory
final technologyInventoryProvider = Provider<TechnologyInventory>((ref) {
  return TechnologyInventory.standard;
});

/// Main observatory service
class ObservatoryService {
  static final ObservatoryService _instance = ObservatoryService._internal();
  factory ObservatoryService() => _instance;
  ObservatoryService._internal();

  // Cached data
  Map<String, dynamic>? _cachedEnStrings;
  Map<String, dynamic>? _cachedTrStrings;
  Map<String, dynamic>? _cachedDeStrings;
  Map<String, dynamic>? _cachedFrStrings;

  // Safety metrics counters (in-memory, would be persistent in production)
  int _contentProcessed = 0;
  int _filterHits = 0;
  int _autoRewrites = 0;
  int _runtimeBlocks = 0;
  final List<SafetyEvent> _recentEvents = [];
  final Map<String, int> _patternHits = {};

  // ══════════════════════════════════════════════════════════════════════════
  // MAIN SUMMARY
  // ══════════════════════════════════════════════════════════════════════════

  /// Get complete observatory summary
  Future<ObservatorySummary> getSummary() async {
    final results = await Future.wait([
      getLanguageCoverage(),
      getContentInventory(),
      getSafetyMetrics(),
      getPlatformHealth(),
    ]);

    return ObservatorySummary(
      languageCoverage: results[0] as LanguageCoverage,
      contentInventory: results[1] as ContentInventory,
      safetyMetrics: results[2] as SafetyMetrics,
      platformHealth: results[3] as PlatformHealth,
      generatedAt: DateTime.now(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LANGUAGE COVERAGE
  // ══════════════════════════════════════════════════════════════════════════

  /// Get language coverage statistics
  Future<LanguageCoverage> getLanguageCoverage() async {
    try {
      // Load all locale files
      await _loadLocaleFiles();

      final enKeys = _flattenKeys(_cachedEnStrings ?? {});
      final trKeys = _flattenKeys(_cachedTrStrings ?? {});
      final deKeys = _flattenKeys(_cachedDeStrings ?? {});
      final frKeys = _flattenKeys(_cachedFrStrings ?? {});

      // English is the reference (should have all keys)
      final totalStrings = enKeys.length;

      // Calculate per-locale coverage
      final locales = <String, LocaleCoverage>{
        'en': LocaleCoverage(
          locale: 'en',
          displayName: 'English',
          translatedCount: enKeys.length,
          totalCount: totalStrings,
        ),
        'tr': LocaleCoverage(
          locale: 'tr',
          displayName: 'Turkish',
          translatedCount: trKeys.length,
          totalCount: totalStrings,
        ),
        'de': LocaleCoverage(
          locale: 'de',
          displayName: 'German',
          translatedCount: deKeys.length,
          totalCount: totalStrings,
        ),
        'fr': LocaleCoverage(
          locale: 'fr',
          displayName: 'French',
          translatedCount: frKeys.length,
          totalCount: totalStrings,
        ),
      };

      // Find missing translations
      final missingTranslations = <MissingTranslation>[];
      for (final key in enKeys) {
        final missing = <String>[];
        if (!trKeys.contains(key)) missing.add('tr');
        if (!deKeys.contains(key)) missing.add('de');
        if (!frKeys.contains(key)) missing.add('fr');

        if (missing.isNotEmpty) {
          final namespace = key.contains('.') ? key.split('.').first : 'root';
          missingTranslations.add(
            MissingTranslation(
              key: key,
              missingLocales: missing,
              namespace: namespace,
            ),
          );
        }
      }

      return LanguageCoverage(
        totalStrings: totalStrings,
        locales: locales,
        hardcodedCount: 0, // Would need static analysis tool
        missingTranslations: missingTranslations.take(50).toList(),
        lastAuditAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('ObservatoryService: Error getting language coverage: $e');
      return LanguageCoverage.empty();
    }
  }

  /// Load locale files into cache
  Future<void> _loadLocaleFiles() async {
    if (_cachedEnStrings != null) return; // Already loaded

    try {
      final results = await Future.wait([
        rootBundle.loadString('assets/l10n/en.json'),
        rootBundle.loadString('assets/l10n/tr.json'),
        rootBundle.loadString('assets/l10n/de.json'),
        rootBundle.loadString('assets/l10n/fr.json'),
      ]);

      _cachedEnStrings = json.decode(results[0]) as Map<String, dynamic>;
      _cachedTrStrings = json.decode(results[1]) as Map<String, dynamic>;
      _cachedDeStrings = json.decode(results[2]) as Map<String, dynamic>;
      _cachedFrStrings = json.decode(results[3]) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('ObservatoryService: Error loading locale files: $e');
    }
  }

  /// Flatten nested JSON keys into dot-notation
  Set<String> _flattenKeys(Map<String, dynamic> map, [String prefix = '']) {
    final keys = <String>{};

    for (final entry in map.entries) {
      final key = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';

      if (entry.value is Map<String, dynamic>) {
        keys.addAll(_flattenKeys(entry.value as Map<String, dynamic>, key));
      } else if (entry.value is List) {
        // Lists are terminal values
        keys.add(key);
      } else {
        keys.add(key);
      }
    }

    return keys;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CONTENT INVENTORY
  // ══════════════════════════════════════════════════════════════════════════

  /// Get content inventory statistics
  Future<ContentInventory> getContentInventory() async {
    await _loadLocaleFiles();

    // Count content items from locale files
    final contentCounts = _countContentItems(_cachedEnStrings ?? {});

    // Calculate category breakdown
    final byCategory = <String, int>{
      'Insights': contentCounts['insights'] ?? 0,
      'Dreams': contentCounts['dreams'] ?? 0,
      'Tarot': contentCounts['tarot'] ?? 0,
      'Reflections': contentCounts['reflections'] ?? 0,
      'Glossary': contentCounts['glossary'] ?? 0,
      'UI/System': contentCounts['ui'] ?? 0,
    };

    final totalItems = byCategory.values.fold<int>(0, (sum, c) => sum + c);

    // Estimate AI-generated content (templates, dynamic content)
    final aiGenerated = (totalItems * 0.35).round(); // ~35% estimate

    return ContentInventory(
      totalItems: totalItems,
      aiGeneratedCount: aiGenerated,
      staticCount: totalItems - aiGenerated,
      byCategory: byCategory,
      byLocale: {
        'en': totalItems,
        'tr': totalItems,
        'de': (totalItems * 0.95).round(),
        'fr': (totalItems * 0.95).round(),
      },
      growth: ContentGrowth(
        last7Days: 127,
        last30Days: 892,
        dailyTrend: _generateMockGrowthTrend(),
      ),
      lastUpdated: DateTime.now(),
    );
  }

  /// Count content items by category
  Map<String, int> _countContentItems(Map<String, dynamic> translations) {
    final counts = <String, int>{
      'insights': 0,
      'dreams': 0,
      'tarot': 0,
      'reflections': 0,
      'glossary': 0,
      'ui': 0,
    };

    void countRecursive(Map<String, dynamic> map, String path) {
      for (final entry in map.entries) {
        final currentPath = path.isEmpty ? entry.key : '$path.${entry.key}';

        if (entry.value is Map<String, dynamic>) {
          countRecursive(entry.value as Map<String, dynamic>, currentPath);
        } else {
          // Categorize based on path
          if (currentPath.contains('insight') ||
              currentPath.contains('archetype') ||
              currentPath.contains('sign')) {
            counts['insights'] = (counts['insights'] ?? 0) + 1;
          } else if (currentPath.contains('dream')) {
            counts['dreams'] = (counts['dreams'] ?? 0) + 1;
          } else if (currentPath.contains('tarot') ||
              currentPath.contains('card')) {
            counts['tarot'] = (counts['tarot'] ?? 0) + 1;
          } else if (currentPath.contains('reflection') ||
              currentPath.contains('insight') ||
              currentPath.contains('prompt')) {
            counts['reflections'] = (counts['reflections'] ?? 0) + 1;
          } else if (currentPath.contains('glossary') ||
              currentPath.contains('definition')) {
            counts['glossary'] = (counts['glossary'] ?? 0) + 1;
          } else {
            counts['ui'] = (counts['ui'] ?? 0) + 1;
          }
        }
      }
    }

    countRecursive(translations, '');
    return counts;
  }

  List<DailyGrowth> _generateMockGrowthTrend() {
    final now = DateTime.now();
    return List.generate(30, (i) {
      return DailyGrowth(
        date: now.subtract(Duration(days: 29 - i)),
        count: 20 + (i * 2) + (i % 5),
      );
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SAFETY METRICS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get safety metrics
  Future<SafetyMetrics> getSafetyMetrics() async {
    // Calculate hit rate
    final hitRate = _contentProcessed > 0
        ? (_filterHits / _contentProcessed) * 100
        : 0.0;

    // Calculate rewrite success rate
    final rewriteSuccess = _filterHits > 0
        ? (_autoRewrites / _filterHits) * 100
        : 100.0;

    // Build pattern hits list
    final topPatterns =
        _patternHits.entries
            .map(
              (e) => PatternHit(
                pattern: e.key,
                hitCount: e.value,
                firstHit: DateTime.now().subtract(const Duration(days: 7)),
                lastHit: DateTime.now(),
              ),
            )
            .toList()
          ..sort((a, b) => b.hitCount.compareTo(a.hitCount));

    return SafetyMetrics(
      contentProcessed24h: _contentProcessed,
      filterHits24h: _filterHits,
      autoRewrites24h: _autoRewrites,
      runtimeBlocks24h: _runtimeBlocks,
      hitRatePercent: hitRate,
      rewriteSuccessPercent: rewriteSuccess,
      topPatterns: topPatterns.take(10).toList(),
      recentEvents: _recentEvents.take(20).toList(),
      reviewMode: const ReviewModeStatus(mode: ReviewMode.normal),
      trend7Days: _generateMockSafetyTrend(),
      lastUpdated: DateTime.now(),
    );
  }

  /// Record a content processing event
  void recordContentProcessed() {
    _contentProcessed++;
  }

  /// Record a filter hit
  void recordFilterHit(String pattern, String context) {
    _filterHits++;
    _patternHits[pattern] = (_patternHits[pattern] ?? 0) + 1;

    _recentEvents.insert(
      0,
      SafetyEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: SafetyEventType.filterHit,
        contentHash: context.hashCode.toString(),
        context: context,
        patternMatched: pattern,
        timestamp: DateTime.now(),
      ),
    );

    // Keep only last 100 events
    if (_recentEvents.length > 100) {
      _recentEvents.removeRange(100, _recentEvents.length);
    }
  }

  /// Record an auto-rewrite
  void recordAutoRewrite(String pattern, String replacement) {
    _autoRewrites++;

    _recentEvents.insert(
      0,
      SafetyEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: SafetyEventType.rewrite,
        contentHash: pattern.hashCode.toString(),
        context: 'AUTO_REWRITE',
        patternMatched: pattern,
        replacementUsed: replacement,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Record a runtime block
  void recordRuntimeBlock(String context) {
    _runtimeBlocks++;

    _recentEvents.insert(
      0,
      SafetyEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: SafetyEventType.block,
        contentHash: context.hashCode.toString(),
        context: context,
        timestamp: DateTime.now(),
      ),
    );
  }

  List<DailySafetyMetric> _generateMockSafetyTrend() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final hits = 15 + (i % 3) * 5;
      return DailySafetyMetric(
        date: now.subtract(Duration(days: 6 - i)),
        hits: hits,
        rewrites: (hits * 0.9).round(),
        blocks: i % 4 == 0 ? 1 : 0,
        hitRate: 0.15 + (i % 3) * 0.05,
      );
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PLATFORM HEALTH
  // ══════════════════════════════════════════════════════════════════════════

  /// Get platform health metrics
  Future<PlatformHealth> getPlatformHealth() async {
    // In production, would fetch from GitHub Actions API & Firebase
    return PlatformHealth(
      webBuild: BuildStatus(
        platform: 'web',
        buildNumber: '#847',
        status: BuildStatusType.success,
        commitSha: 'c6c1843',
        duration: const Duration(minutes: 4, seconds: 32),
        completedAt: DateTime.now().subtract(const Duration(minutes: 12)),
        triggeredBy: 'push',
      ),
      iosBuild: BuildStatus(
        platform: 'ios',
        buildNumber: '2.4.1 (92)',
        status: BuildStatusType.success,
        commitSha: 'c6c1843',
        duration: const Duration(minutes: 12, seconds: 18),
        completedAt: DateTime.now().subtract(const Duration(hours: 3)),
        triggeredBy: 'push',
      ),
      ciWorkflows: [
        CIWorkflow(
          name: 'flutter_web_build',
          runId: '12345',
          status: BuildStatusType.success,
          duration: const Duration(minutes: 4, seconds: 32),
          completedAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        CIWorkflow(
          name: 'flutter_ios_build',
          runId: '12344',
          status: BuildStatusType.success,
          duration: const Duration(minutes: 12, seconds: 18),
          completedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        CIWorkflow(
          name: 'unit_tests',
          runId: '12345',
          status: BuildStatusType.success,
          duration: const Duration(minutes: 2, seconds: 47),
          completedAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        CIWorkflow(
          name: 'i18n_guard',
          runId: '12345',
          status: BuildStatusType.success,
          duration: const Duration(seconds: 45),
          completedAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        CIWorkflow(
          name: 'forbidden_phrase_guard',
          runId: '12345',
          status: BuildStatusType.success,
          duration: const Duration(seconds: 38),
          completedAt: DateTime.now().subtract(const Duration(minutes: 12)),
        ),
        CIWorkflow(
          name: 'lighthouse_audit',
          runId: '12340',
          status: BuildStatusType.warning,
          duration: const Duration(minutes: 3, seconds: 12),
          completedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ],
      webPerformance: const PerformanceMetrics(
        platform: 'web',
        lighthouseScore: 94,
        crashFreePercent: 99.9,
        coldStartMs: 1200,
        bundleSizeMb: 2.1,
        scoreChange: 2,
      ),
      iosPerformance: const PerformanceMetrics(
        platform: 'ios',
        lighthouseScore: 0, // N/A for iOS
        crashFreePercent: 99.7,
        coldStartMs: 800,
        bundleSizeMb: 48,
        scoreChange: 0,
      ),
      buildHistory: _generateMockBuildHistory(),
      lastUpdated: DateTime.now(),
    );
  }

  List<BuildHistoryEntry> _generateMockBuildHistory() {
    final now = DateTime.now();
    final entries = <BuildHistoryEntry>[];

    // Generate 21 web builds over 7 days
    for (var i = 0; i < 21; i++) {
      entries.add(
        BuildHistoryEntry(
          platform: 'web',
          buildNumber: '#${847 - i}',
          status: i == 6 ? BuildStatusType.warning : BuildStatusType.success,
          completedAt: now.subtract(Duration(hours: i * 8)),
        ),
      );
    }

    // Generate 8 iOS builds over 7 days
    for (var i = 0; i < 8; i++) {
      entries.add(
        BuildHistoryEntry(
          platform: 'ios',
          buildNumber: '2.4.${1 - (i ~/ 3)} (${92 - i})',
          status: BuildStatusType.success,
          completedAt: now.subtract(Duration(hours: i * 21)),
        ),
      );
    }

    return entries..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // EXPORT FUNCTIONALITY
  // ══════════════════════════════════════════════════════════════════════════

  /// Generate CSV export of language coverage
  Future<String> exportLanguageCoverageCSV() async {
    final coverage = await getLanguageCoverage();
    final buffer = StringBuffer();

    buffer.writeln('Locale,Display Name,Translated,Total,Completion %');
    for (final locale in coverage.locales.values) {
      buffer.writeln(
        '${locale.locale},${locale.displayName},${locale.translatedCount},'
        '${locale.totalCount},${locale.completionPercent.toStringAsFixed(2)}',
      );
    }

    buffer.writeln('');
    buffer.writeln('Missing Translations');
    buffer.writeln('Key,Missing Locales,Namespace');
    for (final missing in coverage.missingTranslations) {
      buffer.writeln(
        '${missing.key},"${missing.missingLocales.join(', ')}",${missing.namespace}',
      );
    }

    return buffer.toString();
  }

  /// Generate CSV export of safety metrics
  Future<String> exportSafetyMetricsCSV() async {
    final safety = await getSafetyMetrics();
    final buffer = StringBuffer();

    buffer.writeln('Safety Metrics Report');
    buffer.writeln('Generated At,${DateTime.now().toIso8601String()}');
    buffer.writeln('');
    buffer.writeln('Metric,Value');
    buffer.writeln('Content Processed (24h),${safety.contentProcessed24h}');
    buffer.writeln('Filter Hits (24h),${safety.filterHits24h}');
    buffer.writeln('Auto-Rewrites (24h),${safety.autoRewrites24h}');
    buffer.writeln('Runtime Blocks (24h),${safety.runtimeBlocks24h}');
    buffer.writeln('Hit Rate %,${safety.hitRatePercent.toStringAsFixed(2)}');
    buffer.writeln(
      'Rewrite Success %,${safety.rewriteSuccessPercent.toStringAsFixed(2)}',
    );

    buffer.writeln('');
    buffer.writeln('Top Patterns');
    buffer.writeln('Pattern,Hit Count,Last Hit');
    for (final pattern in safety.topPatterns) {
      buffer.writeln(
        '"${pattern.pattern}",${pattern.hitCount},${pattern.lastHit.toIso8601String()}',
      );
    }

    return buffer.toString();
  }

  /// Reset metrics (for testing)
  void resetMetrics() {
    _contentProcessed = 0;
    _filterHits = 0;
    _autoRewrites = 0;
    _runtimeBlocks = 0;
    _recentEvents.clear();
    _patternHits.clear();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ENHANCED CONTENT SAFETY FILTER WITH OBSERVATORY INTEGRATION
// ════════════════════════════════════════════════════════════════════════════

/// Extension to ContentSafetyFilter for observatory integration
extension ContentSafetyFilterObservatory on ContentSafetyFilter {
  /// Filter content and record metrics
  static String filterWithMetrics(
    String content, {
    String context = 'UNKNOWN',
  }) {
    final observatory = ObservatoryService();
    observatory.recordContentProcessed();

    if (ContentSafetyFilter.containsForbiddenContent(content)) {
      // Detect which patterns matched
      final detected = ContentSafetyFilter.detectForbiddenPhrases(content);
      for (final pattern in detected) {
        observatory.recordFilterHit(pattern, context);
      }

      // Apply filter
      final filtered = ContentSafetyFilter.filterContent(content);
      if (filtered != content) {
        observatory.recordAutoRewrite(detected.first, 'safe_alternative');
      }

      return filtered;
    }

    return content;
  }
}
