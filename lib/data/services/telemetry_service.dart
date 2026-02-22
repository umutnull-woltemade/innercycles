import 'package:shared_preferences/shared_preferences.dart';

/// Telemetry event schema + adaptive UI trigger engine.
///
/// Tracks behavioral events locally (SharedPreferences) and exposes
/// signals for adaptive UI tuning. No external analytics dependency.
class TelemetryService {
  final SharedPreferences _prefs;

  TelemetryService(this._prefs);

  static Future<TelemetryService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return TelemetryService(prefs);
  }

  // ═══════════════════════════════════════════════════════════════════════
  // EVENT TRACKING
  // ═══════════════════════════════════════════════════════════════════════

  /// Track a named event with optional properties
  Future<void> track(String event, [Map<String, dynamic>? props]) async {
    final key = 'telemetry_count_$event';
    final count = _prefs.getInt(key) ?? 0;
    await _prefs.setInt(key, count + 1);

    // Track last occurrence
    await _prefs.setInt(
      'telemetry_last_$event',
      DateTime.now().millisecondsSinceEpoch,
    );

    // Track specific property aggregations
    if (props != null) {
      for (final entry in props.entries) {
        if (entry.value is int || entry.value is double) {
          final sumKey = 'telemetry_sum_${event}_${entry.key}';
          final current = _prefs.getDouble(sumKey) ?? 0;
          await _prefs.setDouble(
            sumKey,
            current + (entry.value as num).toDouble(),
          );
        }
      }
    }
  }

  int eventCount(String event) => _prefs.getInt('telemetry_count_$event') ?? 0;

  // ═══════════════════════════════════════════════════════════════════════
  // PREDEFINED EVENTS
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> appOpened({required int sessionCount}) async {
    await track('app_open', {'session_count': sessionCount});
  }

  Future<void> entryStarted(String focusArea) async {
    await track('entry_started', {'focus_area_hash': focusArea.hashCode});
  }

  Future<void> entryCompleted({
    required String focusArea,
    required int durationSeconds,
    required bool hasNote,
    required bool hasPhoto,
  }) async {
    await track('entry_completed', {
      'duration_seconds': durationSeconds,
    });
  }

  Future<void> entryAbandoned({
    required String focusArea,
    required int durationSeconds,
  }) async {
    await track('entry_abandoned', {'duration_seconds': durationSeconds});
  }

  Future<void> patternViewed({required int entriesCount}) async {
    await track('pattern_viewed', {'entries_count': entriesCount});
  }

  Future<void> dreamLogged(String dreamType) async {
    await track('dream_logged');
  }

  Future<void> cycleSyncOpened(String currentPhase) async {
    await track('cycle_sync_opened');
  }

  Future<void> paywallShown({required String triggerPoint, required int entriesCount}) async {
    await track('paywall_shown', {'entries_count': entriesCount});
  }

  Future<void> paywallConverted({required String plan, required String triggerPoint}) async {
    await track('paywall_converted');
  }

  Future<void> paywallDismissed({required String triggerPoint}) async {
    await track('paywall_dismissed');
  }

  Future<void> screenViewed(String screenName) async {
    await track('screen_view');
  }

  Future<void> featureDiscovered(String featureName) async {
    await track('feature_discovered');
  }

  Future<void> notificationOpened(String notificationType) async {
    await track('notification_opened');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ADAPTIVE UI SIGNALS
  // ═══════════════════════════════════════════════════════════════════════

  /// Entry abandonment rate (completed / (completed + abandoned))
  double get entryAbandonmentRate {
    final completed = eventCount('entry_completed');
    final abandoned = eventCount('entry_abandoned');
    final total = completed + abandoned;
    if (total == 0) return 0;
    return abandoned / total;
  }

  /// Should simplify entry form? (> 40% abandonment)
  bool get shouldSimplifyEntryForm => entryAbandonmentRate > 0.4;

  /// Paywall dismiss rate
  double get paywallDismissRate {
    final shown = eventCount('paywall_shown');
    final dismissed = eventCount('paywall_dismissed');
    if (shown == 0) return 0;
    return dismissed / shown;
  }

  /// Should delay paywall? (> 80% dismiss rate)
  bool get shouldDelayPaywall => paywallDismissRate > 0.8;

  /// Is user primarily a night user? (check via last app_open timestamps)
  bool get isNightUser {
    final lastOpen = _prefs.getInt('telemetry_last_app_open');
    if (lastOpen == null) return false;
    final hour = DateTime.fromMillisecondsSinceEpoch(lastOpen).hour;
    return hour >= 20 || hour < 6;
  }

  /// Has user used dream journal at all?
  bool get hasDreamActivity => eventCount('dream_logged') > 0;

  /// Pattern screen engagement (viewed at least once with enough data)
  bool get hasPatternEngagement => eventCount('pattern_viewed') > 0;

  /// Total completed entries (useful for progressive unlock)
  int get totalCompletedEntries => eventCount('entry_completed');

  /// Average entry duration in seconds
  double get avgEntryDuration {
    final count = eventCount('entry_completed');
    if (count == 0) return 0;
    final total = _prefs.getDouble('telemetry_sum_entry_completed_duration_seconds') ?? 0;
    return total / count;
  }

  /// Session count
  int get sessionCount => eventCount('app_open');
}
