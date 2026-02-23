// ============================================================================
// WIDGET DATA SERVICE - iOS WidgetKit Data Bridge
// ============================================================================
// Writes data to shared UserDefaults via MethodChannel so iOS widgets
// (DailyReflection, MoodInsight, LockScreen, CyclePosition) can read it.
// Uses App Group: group.com.venusone.innercycles
// ============================================================================

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service for updating iOS Widget content via shared UserDefaults.
/// The native side (AppDelegate) handles writing to UserDefaults(suiteName:)
/// and calling WidgetCenter.shared.reloadAllTimelines().
class WidgetDataService {
  static const _channel = MethodChannel('com.venusone.innercycles/widgets');

  /// Singleton
  static final WidgetDataService _instance = WidgetDataService._();
  factory WidgetDataService() => _instance;
  WidgetDataService._();

  /// Only supported on iOS (WidgetKit)
  bool get isSupported => !kIsWeb && Platform.isIOS;

  // --------------------------------------------------------------------------
  // CYCLE POSITION WIDGET
  // --------------------------------------------------------------------------

  /// Update CyclePositionWidget data.
  ///
  /// [emotionalPhase] - raw phase name (e.g. "Expansion", "Reflection")
  /// [phaseEmoji]     - emoji representing the phase
  /// [phaseLabel]     - localized label (e.g. "Expansion Phase")
  /// [cycleDay]       - current day within the cycle (1-based)
  /// [cycleLength]    - total cycle length in days
  Future<void> updateCyclePosition({
    required String emotionalPhase,
    required String phaseEmoji,
    required String phaseLabel,
    required int cycleDay,
    required int cycleLength,
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'widget_emotional_phase': emotionalPhase,
        'widget_phase_emoji': phaseEmoji,
        'widget_phase_label': phaseLabel,
        'widget_cycle_day': cycleDay.clamp(1, cycleLength),
        'widget_cycle_length': cycleLength.clamp(1, 365),
      });

      debugPrint(
        '[WidgetDataService] Cycle position updated: '
        '$emotionalPhase (day $cycleDay/$cycleLength)',
      );
    } catch (e) {
      debugPrint('[WidgetDataService] Error updating cycle position: $e');
    }
  }

  // --------------------------------------------------------------------------
  // DAILY REFLECTION WIDGET
  // --------------------------------------------------------------------------

  /// Update DailyReflectionWidget data.
  Future<void> updateDailyReflection({
    required String moodEmoji,
    required String moodLabel,
    required String dailyPrompt,
    required String focusArea,
    required int streakDays,
    required int moodRating,
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'widget_mood_emoji': moodEmoji,
        'widget_mood_label': moodLabel,
        'widget_daily_prompt': dailyPrompt,
        'widget_focus_area': focusArea,
        'widget_streak_days': streakDays,
        'widget_mood_rating': moodRating.clamp(1, 5),
      });

      debugPrint('[WidgetDataService] Daily reflection widget updated');
    } catch (e) {
      debugPrint('[WidgetDataService] Error updating daily reflection: $e');
    }
  }

  // --------------------------------------------------------------------------
  // MOOD INSIGHT WIDGET
  // --------------------------------------------------------------------------

  /// Update MoodInsightWidget data.
  Future<void> updateMoodInsight({
    required String currentMood,
    required String moodEmoji,
    required int energyLevel,
    required String advice,
    String weekTrend = 'Steady',
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'widget_current_mood': currentMood,
        'widget_mood_emoji': moodEmoji,
        'widget_energy_level': energyLevel.clamp(0, 100),
        'widget_mood_advice': advice,
        'widget_week_trend': weekTrend,
      });

      debugPrint('[WidgetDataService] Mood insight widget updated');
    } catch (e) {
      debugPrint('[WidgetDataService] Error updating mood insight: $e');
    }
  }

  // --------------------------------------------------------------------------
  // LOCK SCREEN WIDGET
  // --------------------------------------------------------------------------

  /// Update LockScreenWidget data.
  Future<void> updateLockScreen({
    required String moodEmoji,
    required String accentEmoji,
    required String shortMessage,
    required int energyLevel,
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'widget_mood_emoji': moodEmoji,
        'widget_accent_emoji': accentEmoji,
        'widget_short_message': shortMessage.length > 40
            ? '${shortMessage.substring(0, 37)}...'
            : shortMessage,
        'widget_lock_energy': energyLevel.clamp(1, 5),
      });

      debugPrint('[WidgetDataService] Lock screen widget updated');
    } catch (e) {
      debugPrint('[WidgetDataService] Error updating lock screen: $e');
    }
  }

  // --------------------------------------------------------------------------
  // WIDGET METADATA (language, 7-day history, timestamps)
  // --------------------------------------------------------------------------

  /// Update shared widget metadata for bilingual support and 7-day history.
  Future<void> updateWidgetMetadata({
    required String languageCode,
    required List<int> moodHistory7d,
    required List<String> moodEmojis7d,
    required List<String> dayLabels7d,
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'widget_language': languageCode,
        'widget_mood_history_7d': moodHistory7d.take(7).join(','),
        'widget_mood_history_emojis_7d': moodEmojis7d.take(7).join(','),
        'widget_mood_history_dates_7d': dayLabels7d.take(7).join(','),
        'widget_last_updated': DateTime.now().millisecondsSinceEpoch / 1000.0,
      });

      debugPrint('[WidgetDataService] Widget metadata updated (lang=$languageCode)');
    } catch (e) {
      debugPrint('[WidgetDataService] Error updating widget metadata: $e');
    }
  }

  // --------------------------------------------------------------------------
  // FORCE REFRESH
  // --------------------------------------------------------------------------

  /// Force reload all widget timelines without sending new data.
  Future<void> reloadAllWidgets() async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('reloadWidgets');
      debugPrint('[WidgetDataService] All widgets reloaded');
    } catch (e) {
      debugPrint('[WidgetDataService] Error reloading widgets: $e');
    }
  }

  // --------------------------------------------------------------------------
  // HELPERS - Emoji lookups for emotional phases
  // --------------------------------------------------------------------------

  /// Returns an emoji for the given emotional phase name.
  static String phaseToEmoji(String phase) {
    switch (phase.toLowerCase()) {
      case 'expansion':
        return '\u{1F31F}'; // star
      case 'stabilization':
        return '\u{2696}\u{FE0F}'; // balance scale
      case 'contraction':
        return '\u{1F319}'; // crescent moon
      case 'reflection':
        return '\u{1FA9E}'; // mirror
      case 'recovery':
        return '\u{1F331}'; // seedling
      default:
        return '\u{1F300}'; // cyclone
    }
  }
}
