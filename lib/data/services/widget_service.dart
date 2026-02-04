// Venus One - iOS Widget Service
// Manages data sharing between Flutter app and iOS Widgets

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service for updating iOS Widget content
/// Uses App Groups to share data with WidgetKit extensions
class WidgetService {
  static const _channel = MethodChannel('com.umut.astrologyApp/widgets');
  /// App Group ID for shared data (used in iOS native code)
  // ignore: unused_field
  static const appGroupId = 'group.com.umut.astrologyApp';

  /// Singleton instance
  static final WidgetService _instance = WidgetService._();
  factory WidgetService() => _instance;
  WidgetService._();

  /// Check if widgets are supported (iOS only)
  bool get isSupported => !kIsWeb && Platform.isIOS;

  /// Update daily horoscope widget data
  Future<void> updateDailyHoroscope({
    required String zodiacSign,
    required String zodiacEmoji,
    required String dailyMessage,
    required int luckyNumber,
    required String element,
    required int moodRating, // 1-5
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'widget_zodiac_sign': zodiacSign,
        'widget_zodiac_emoji': zodiacEmoji,
        'widget_daily_message': dailyMessage,
        'widget_lucky_number': luckyNumber,
        'widget_element': element,
        'widget_mood_rating': moodRating.clamp(1, 5),
      });

      debugPrint('[WidgetService] Daily horoscope widget updated for $zodiacSign');
    } catch (e) {
      debugPrint('[WidgetService] Error updating horoscope widget: $e');
    }
  }

  /// Update cosmic energy widget data
  Future<void> updateCosmicEnergy({
    required String moonPhase,
    required String moonEmoji,
    required String planetaryFocus,
    required int energyLevel, // 0-100
    required String advice,
    String currentTransit = '',
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'widget_moon_phase': moonPhase,
        'widget_moon_emoji': moonEmoji,
        'widget_planetary_focus': planetaryFocus,
        'widget_energy_level': energyLevel.clamp(0, 100),
        'widget_cosmic_advice': advice,
        'widget_current_transit': currentTransit,
      });

      debugPrint('[WidgetService] Cosmic energy widget updated');
    } catch (e) {
      debugPrint('[WidgetService] Error updating cosmic widget: $e');
    }
  }

  /// Update lock screen widget data (iOS 16+)
  Future<void> updateLockScreen({
    required String zodiacEmoji,
    required String moonEmoji,
    required String shortMessage, // Keep under 30 chars
    required int energyLevel, // 1-5 for lock screen
  }) async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('updateWidgetData', {
        'widget_zodiac_emoji': zodiacEmoji,
        'widget_moon_emoji': moonEmoji,
        'widget_short_message': shortMessage.length > 40
            ? '${shortMessage.substring(0, 37)}...'
            : shortMessage,
        'widget_lock_energy': energyLevel.clamp(1, 5),
      });

      debugPrint('[WidgetService] Lock screen widget updated');
    } catch (e) {
      debugPrint('[WidgetService] Error updating lock screen widget: $e');
    }
  }

  /// Update all widgets at once with comprehensive data
  Future<void> updateAllWidgets({
    required String zodiacSign,
    required String zodiacEmoji,
    required String element,
    required String dailyMessage,
    required String shortMessage,
    required int luckyNumber,
    required int moodRating,
    required String moonPhase,
    required String moonEmoji,
    required String planetaryFocus,
    required int energyLevel,
    required String cosmicAdvice,
    String currentTransit = '',
  }) async {
    if (!isSupported) return;

    try {
      // Convert 0-100 energy to 1-5 for lock screen
      final lockEnergy = ((energyLevel / 100) * 4 + 1).round().clamp(1, 5);

      await _channel.invokeMethod('updateWidgetData', {
        // Daily horoscope
        'widget_zodiac_sign': zodiacSign,
        'widget_zodiac_emoji': zodiacEmoji,
        'widget_daily_message': dailyMessage,
        'widget_lucky_number': luckyNumber,
        'widget_element': element,
        'widget_mood_rating': moodRating.clamp(1, 5),
        // Cosmic energy
        'widget_moon_phase': moonPhase,
        'widget_moon_emoji': moonEmoji,
        'widget_planetary_focus': planetaryFocus,
        'widget_energy_level': energyLevel.clamp(0, 100),
        'widget_cosmic_advice': cosmicAdvice,
        'widget_current_transit': currentTransit,
        // Lock screen
        'widget_short_message': shortMessage.length > 40
            ? '${shortMessage.substring(0, 37)}...'
            : shortMessage,
        'widget_lock_energy': lockEnergy,
      });

      // Request widget refresh
      await _refreshWidgets();

      debugPrint('[WidgetService] All widgets updated successfully');
    } catch (e) {
      debugPrint('[WidgetService] Error updating all widgets: $e');
    }
  }

  /// Force refresh all widgets
  Future<void> _refreshWidgets() async {
    if (!isSupported) return;

    try {
      await _channel.invokeMethod('reloadWidgets');
    } catch (e) {
      debugPrint('[WidgetService] Error refreshing widgets: $e');
    }
  }

  /// Get zodiac emoji from sign name
  static String getZodiacEmoji(String sign) {
    const emojis = {
      'aries': '♈️',
      'taurus': '♉️',
      'gemini': '♊️',
      'cancer': '♋️',
      'leo': '♌️',
      'virgo': '♍️',
      'libra': '♎️',
      'scorpio': '♏️',
      'sagittarius': '♐️',
      'capricorn': '♑️',
      'aquarius': '♒️',
      'pisces': '♓️',
    };
    return emojis[sign.toLowerCase()] ?? '⭐';
  }

  /// Get moon phase emoji
  static String getMoonEmoji(String phase) {
    final phaseLower = phase.toLowerCase();
    if (phaseLower.contains('new')) return '🌑';
    if (phaseLower.contains('waxing crescent')) return '🌒';
    if (phaseLower.contains('first quarter')) return '🌓';
    if (phaseLower.contains('waxing gibbous')) return '🌔';
    if (phaseLower.contains('full')) return '🌕';
    if (phaseLower.contains('waning gibbous')) return '🌖';
    if (phaseLower.contains('third quarter') || phaseLower.contains('last quarter')) return '🌗';
    if (phaseLower.contains('waning crescent')) return '🌘';
    return '🌙';
  }

  /// Get element from zodiac sign
  static String getElement(String sign) {
    const fireSign = ['aries', 'leo', 'sagittarius'];
    const earthSigns = ['taurus', 'virgo', 'capricorn'];
    const airSigns = ['gemini', 'libra', 'aquarius'];
    const waterSigns = ['cancer', 'scorpio', 'pisces'];

    final signLower = sign.toLowerCase();
    if (fireSign.contains(signLower)) return 'Fire';
    if (earthSigns.contains(signLower)) return 'Earth';
    if (airSigns.contains(signLower)) return 'Air';
    if (waterSigns.contains(signLower)) return 'Water';
    return 'Unknown';
  }
}
