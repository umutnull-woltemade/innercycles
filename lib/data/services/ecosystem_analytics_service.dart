// ════════════════════════════════════════════════════════════════════════════
// ECOSYSTEM ANALYTICS SERVICE - Event tracking for InnerCycles
// ════════════════════════════════════════════════════════════════════════════
// Tracks tool visits, outputs, challenge actions, navigation, search,
// feedback, and session events. FIFO buffer with SharedPreferences.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics_service.dart';

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.name,
    required this.properties,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'name': name,
    'properties': properties,
    'timestamp': timestamp.toIso8601String(),
  };

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) => AnalyticsEvent(
    name: json['name'] as String? ?? '',
    properties: Map<String, dynamic>.from(json['properties'] as Map? ?? {}),
    timestamp:
        DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
        DateTime.now(),
  );
}

class EcosystemAnalyticsService {
  static const String _eventsKey = 'ecosystem_analytics_events';
  static const int _maxEvents = 1000;

  final SharedPreferences _prefs;
  List<AnalyticsEvent> _events = [];

  EcosystemAnalyticsService._(this._prefs) {
    _loadEvents();
  }

  static Future<EcosystemAnalyticsService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return EcosystemAnalyticsService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TOOL EVENTS
  // ══════════════════════════════════════════════════════════════════════════

  void trackToolOpen(String toolId, {String? source}) {
    final props = <String, dynamic>{'tool_id': toolId};
    if (source != null) props['source'] = source;
    _track('tool_open', props);
  }

  void trackToolOutput(String toolId, String outputType) {
    _track('tool_output', {'tool_id': toolId, 'output_type': outputType});
  }

  void trackToolClose(String toolId, int durationSeconds) {
    _track('tool_close', {
      'tool_id': toolId,
      'duration_seconds': durationSeconds,
    });
  }

  void trackToolEmpty(String toolId) {
    _track('tool_empty', {'tool_id': toolId});
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CHALLENGE EVENTS
  // ══════════════════════════════════════════════════════════════════════════

  void trackChallengeStart(String challengeId) {
    _track('challenge_start', {'challenge_id': challengeId});
  }

  void trackChallengeProgress(
    String challengeId,
    int currentDay,
    int totalDays,
  ) {
    _track('challenge_progress', {
      'challenge_id': challengeId,
      'current_day': currentDay,
      'total_days': totalDays,
    });
  }

  void trackChallengeComplete(String challengeId) {
    _track('challenge_complete', {'challenge_id': challengeId});
  }

  void trackChallengeAbandon(String challengeId, int dayReached) {
    _track('challenge_abandon', {
      'challenge_id': challengeId,
      'day_reached': dayReached,
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NAVIGATION EVENTS
  // ══════════════════════════════════════════════════════════════════════════

  void trackTabSwitch(int fromIndex, int toIndex) {
    _track('tab_switch', {'from': fromIndex, 'to': toIndex});
  }

  void trackNavigation(String fromRoute, String toRoute, {String? trigger}) {
    final props = <String, dynamic>{'from': fromRoute, 'to': toRoute};
    if (trigger != null) props['trigger'] = trigger;
    _track('navigation', props);
  }

  void trackNextToolTap(String fromToolId, String toToolId, String source) {
    _track('next_tool_tap', {
      'from_tool': fromToolId,
      'to_tool': toToolId,
      'source': source,
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SEARCH EVENTS
  // ══════════════════════════════════════════════════════════════════════════

  void trackSearchQuery(String query, int resultCount) {
    _track('search_query', {'query': query, 'result_count': resultCount});
  }

  void trackSearchResultTap(String query, String toolId) {
    _track('search_result_tap', {'query': query, 'tool_id': toolId});
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FEEDBACK EVENTS
  // ══════════════════════════════════════════════════════════════════════════

  void trackFeedback(String toolId, bool isPositive) {
    _track('feedback', {'tool_id': toolId, 'is_positive': isPositive});
  }

  void trackFavoriteToggle(String toolId, bool isFavorite) {
    _track('favorite_toggle', {'tool_id': toolId, 'is_favorite': isFavorite});
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SESSION EVENTS
  // ══════════════════════════════════════════════════════════════════════════

  void trackSessionStart() {
    _track('session_start', {});
  }

  void trackSessionEnd(int durationSeconds, int toolsUsed) {
    _track('session_end', {
      'duration_seconds': durationSeconds,
      'tools_used': toolsUsed,
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUERY HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  List<AnalyticsEvent> getEvents({String? name, int limit = 50}) {
    var filtered = _events;
    if (name != null) filtered = filtered.where((e) => e.name == name).toList();
    return filtered.take(limit).toList();
  }

  int getEventCount(String name) {
    return _events.where((e) => e.name == name).length;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // INTERNAL
  // ══════════════════════════════════════════════════════════════════════════

  void _track(String name, Map<String, dynamic> properties) {
    final event = AnalyticsEvent(name: name, properties: properties);
    _events.insert(0, event);
    if (_events.length > _maxEvents) {
      _events = _events.sublist(0, _maxEvents);
    }
    _persistEvents();

    // Forward to main AnalyticsService for Supabase batch flush
    AnalyticsService().logEvent('eco_$name', properties);
  }

  void _loadEvents() {
    final jsonString = _prefs.getString(_eventsKey);
    if (jsonString != null) {
      try {
        final list = jsonDecode(jsonString) as List;
        _events = list
            .map((e) => AnalyticsEvent.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('EcosystemAnalyticsService._loadEvents: JSON decode failed: $e');
        _events = [];
      }
    }
  }

  Future<void> _persistEvents() async {
    final jsonList = _events.take(200).map((e) => e.toJson()).toList();
    await _prefs.setString(_eventsKey, jsonEncode(jsonList));
  }

  Future<void> clearAll() async {
    _events.clear();
    await _prefs.remove(_eventsKey);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RIVERPOD PROVIDER
// ════════════════════════════════════════════════════════════════════════════

final ecosystemAnalyticsServiceProvider =
    FutureProvider<EcosystemAnalyticsService>((ref) async {
      return await EcosystemAnalyticsService.init();
    });
