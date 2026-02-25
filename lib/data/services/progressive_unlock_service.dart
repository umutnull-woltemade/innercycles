import 'package:shared_preferences/shared_preferences.dart';

/// Progressive feature unlock based on journal entry count.
///
/// Gates features behind entry milestones to create natural
/// retention loops and prevent overwhelming new users.
///
/// Unlock schedule:
///   1 entry  → Basic journal + mood
///   3 entries → Dream journal
///   7 entries → Pattern screen (first correlation visible)
///   14 entries → Monthly reflection
///   30 entries → Annual heatmap populates
///   60 entries → Cycle sync cross-correlation
class ProgressiveUnlockService {
  final SharedPreferences _prefs;

  static const String _entryCountKey = 'progressive_entry_count';
  static const String _unlockedFeaturesKey = 'progressive_unlocked';

  ProgressiveUnlockService(this._prefs);

  static Future<ProgressiveUnlockService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressiveUnlockService(prefs);
  }

  // ── Thresholds ──────────────────────────────────────────────────────

  static const Map<String, int> thresholds = {
    'dream_journal': 3,
    'patterns': 7,
    'monthly_reflection': 14,
    'annual_heatmap': 30,
    'cycle_correlation': 60,
  };

  // ── Entry count ──────────────────────────────────────────────────────

  int get entryCount => _prefs.getInt(_entryCountKey) ?? 0;

  Future<void> incrementEntryCount() async {
    final count = entryCount + 1;
    await _prefs.setInt(_entryCountKey, count);
  }

  Future<void> setEntryCount(int count) async {
    await _prefs.setInt(_entryCountKey, count);
  }

  // ── Feature access checks ────────────────────────────────────────────

  bool get isDreamJournalUnlocked => entryCount >= thresholds['dream_journal']!;
  bool get isPatternsUnlocked => entryCount >= thresholds['patterns']!;
  bool get isMonthlyReflectionUnlocked =>
      entryCount >= thresholds['monthly_reflection']!;
  bool get isAnnualHeatmapUnlocked =>
      entryCount >= thresholds['annual_heatmap']!;
  bool get isCycleCorrelationUnlocked =>
      entryCount >= thresholds['cycle_correlation']!;

  /// Check if a specific feature is unlocked
  bool isUnlocked(String featureKey) {
    final threshold = thresholds[featureKey];
    if (threshold == null) return true; // Unknown features default to unlocked
    return entryCount >= threshold;
  }

  /// Entries remaining until a feature unlocks
  int entriesUntilUnlock(String featureKey) {
    final threshold = thresholds[featureKey];
    if (threshold == null) return 0;
    final remaining = threshold - entryCount;
    return remaining > 0 ? remaining : 0;
  }

  // ── Newly unlocked detection ─────────────────────────────────────────

  /// Returns list of features that just became available (not yet shown to user)
  List<String> getNewlyUnlockedFeatures() {
    final shown = _prefs.getStringList(_unlockedFeaturesKey) ?? [];
    final newlyUnlocked = <String>[];

    for (final entry in thresholds.entries) {
      if (entryCount >= entry.value && !shown.contains(entry.key)) {
        newlyUnlocked.add(entry.key);
      }
    }

    return newlyUnlocked;
  }

  /// Mark a feature as "shown" so the unlock celebration doesn't repeat
  Future<void> markFeatureShown(String featureKey) async {
    final shown = _prefs.getStringList(_unlockedFeaturesKey) ?? [];
    if (!shown.contains(featureKey)) {
      shown.add(featureKey);
      await _prefs.setStringList(_unlockedFeaturesKey, shown);
    }
  }

  /// Mark all current unlocks as shown
  Future<void> markAllShown() async {
    final newlyUnlocked = getNewlyUnlockedFeatures();
    for (final feature in newlyUnlocked) {
      await markFeatureShown(feature);
    }
  }

  // ── Progress info ────────────────────────────────────────────────────

  /// Next feature to unlock and how many entries away
  ({String feature, int remaining})? get nextUnlock {
    String? nextFeature;
    int minRemaining = 999;

    for (final entry in thresholds.entries) {
      final remaining = entry.value - entryCount;
      if (remaining > 0 && remaining < minRemaining) {
        minRemaining = remaining;
        nextFeature = entry.key;
      }
    }

    if (nextFeature == null) return null;
    return (feature: nextFeature, remaining: minRemaining);
  }

  /// Overall unlock progress (0.0 to 1.0)
  double get overallProgress {
    final maxThreshold = thresholds.values.reduce((a, b) => a > b ? a : b);
    return (entryCount / maxThreshold).clamp(0.0, 1.0);
  }

  /// Human-readable message for next unlock
  String get nextUnlockMessage {
    final next = nextUnlock;
    if (next == null) return 'All features unlocked!';

    final featureNames = {
      'dream_journal': 'Dream Journal',
      'patterns': 'Pattern Analysis',
      'monthly_reflection': 'Monthly Reflection',
      'annual_heatmap': 'Annual Heatmap',
      'cycle_correlation': 'Cycle Correlation',
    };

    final name = featureNames[next.feature] ?? next.feature;
    if (next.remaining == 1) {
      return '1 more entry unlocks $name';
    }
    return '${next.remaining} more entries unlock $name';
  }
}
