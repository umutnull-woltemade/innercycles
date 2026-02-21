// ============================================================================
// WATCH MOOD SERVICE - Apple Watch Mood Ping Reader
// ============================================================================
// Reads mood data logged from the Apple Watch via shared UserDefaults.
// The watch writes to group.com.venusone.innercycles; this service reads it
// through the existing MethodChannel bridge.
// ============================================================================

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Data from a watch mood ping.
class WatchMoodPing {
  final String emoji;
  final String label;
  final int rating;
  final DateTime timestamp;

  const WatchMoodPing({
    required this.emoji,
    required this.label,
    required this.rating,
    required this.timestamp,
  });

  /// How long ago this ping was logged.
  Duration get age => DateTime.now().difference(timestamp);

  /// Whether the ping is recent (within last 2 hours).
  bool get isRecent => age.inHours < 2;
}

/// Reads mood data logged from Apple Watch via shared UserDefaults.
class WatchMoodService {
  static const _channel = MethodChannel('com.venusone.innercycles/widgets');

  static final WatchMoodService _instance = WatchMoodService._();
  factory WatchMoodService() => _instance;
  WatchMoodService._();

  bool get isSupported => !kIsWeb && Platform.isIOS;

  /// Fetch the latest watch mood ping, if any.
  /// Returns null if no watch data exists or platform unsupported.
  Future<WatchMoodPing?> getLatestPing() async {
    if (!isSupported) return null;

    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'getWidgetData',
        {
          'keys': [
            'watch_mood_emoji',
            'watch_mood_label',
            'watch_mood_rating',
            'watch_mood_timestamp',
          ],
        },
      );

      if (result == null) return null;

      final emoji = result['watch_mood_emoji'] as String?;
      final label = result['watch_mood_label'] as String?;
      final rating = result['watch_mood_rating'] as int?;
      final timestamp = result['watch_mood_timestamp'] as double?;

      if (emoji == null || label == null || rating == null) return null;

      return WatchMoodPing(
        emoji: emoji,
        label: label,
        rating: rating,
        timestamp: timestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (timestamp * 1000).toInt(),
              )
            : DateTime.now(),
      );
    } catch (e) {
      debugPrint('[WatchMoodService] Error reading watch mood: $e');
      return null;
    }
  }
}
