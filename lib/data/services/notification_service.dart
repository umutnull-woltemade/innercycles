import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/app_colors.dart';
import 'journal_prompt_service.dart';

/// Global navigator key for notification navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Notification service for daily journal reminders
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Cached language preference (true = EN, false = TR)
  bool _isEn = true;

  /// Read language preference from SharedPreferences
  Future<bool> _readIsEn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return (prefs.getInt('app_language') ?? 0) == 0;
    } catch (e) {
      if (kDebugMode) debugPrint('Notification: read language pref error: $e');
      return true;
    }
  }

  // Notification IDs
  static const int dailyReflectionId = 1;
  static const int weeklyReviewId = 2;
  static const int moonCycleId = 3;
  static const int wellnessReminderId = 4;
  static const int journalStreakId = 5;
  static const int mindfulnessId = 6;
  static const int newMoonId = 7;
  static const int fullMoonId = 8;
  static const int eveningReflectionId = 9;
  static const int journalPromptId = 10;

  // Preference keys
  static const String _keyDailyEnabled = 'notification_daily_enabled';
  static const String _keyDailyTime = 'notification_daily_time';
  static const String _keyMoonPhaseEnabled = 'notification_moon_enabled';
  static const String _keyWellnessEnabled = 'notification_wellness_enabled';
  static const String _keyEveningEnabled = 'notification_evening_enabled';
  static const String _keyJournalPromptEnabled =
      'notification_journal_prompt_enabled';
  static const String _keyJournalPromptTime =
      'notification_journal_prompt_time';

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (kIsWeb) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return result ?? false;
    }

    return false;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return false;

    if (defaultTargetPlatform == TargetPlatform.android) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.areNotificationsEnabled();
      return result ?? false;
    }

    return _isInitialized;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    String? route;
    switch (payload) {
      case 'daily_reflection':
        route = Routes.journal;
        break;
      case 'moon_cycle':
      case 'new_moon':
      case 'full_moon':
        route = Routes.journal;
        break;
      case 'wellness':
        route = Routes.insight;
        break;
      case 'evening_reflection':
        route = Routes.journal;
        break;
      case 'journal_prompt':
        route = Routes.journal;
        break;
      default:
        route = Routes.today;
    }

    final state = navigatorKey.currentState;
    if (state != null) {
      state.pushNamed(route);
    }
  }

  // ============== Daily Reflection Notifications ==============

  /// Schedule daily reflection notification
  Future<void> scheduleDailyReflection({
    required int hour,
    required int minute,
    String? personalizedMessage,
  }) async {
    _isEn = await _readIsEn();
    final message =
        personalizedMessage ??
        (_isEn
            ? 'Take a moment to reflect on your day.'
            : 'Bugününü düşünmek için bir an dur.');

    await _notifications.zonedSchedule(
      id: dailyReflectionId,
      title: _isEn ? '✨ Your Daily Reflection' : '✨ Günlük Yansıma',
      body: message,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reflection',
          _isEn ? 'Daily Reflection' : 'Günlük Yansıma',
          channelDescription: _isEn
              ? 'Daily journal reflection reminders'
              : 'Günlük yansıma hatırlatıcıları',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: AppColors.starGold,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reflection',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDailyEnabled, true);
    await prefs.setInt(_keyDailyTime, hour * 60 + minute);
  }

  /// Cancel daily reflection notification
  Future<void> cancelDailyReflection() async {
    await _notifications.cancel(id: dailyReflectionId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDailyEnabled, false);
  }

  /// Check if daily reflection notification is enabled
  Future<bool> isDailyReflectionEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDailyEnabled) ?? false;
  }

  /// Get scheduled daily reflection time
  Future<TimeOfDay?> getDailyReflectionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final minutes = prefs.getInt(_keyDailyTime);
    if (minutes == null) return null;
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  // ============== Evening Reflection Notifications ==============

  /// Schedule evening reflection notification
  Future<void> scheduleEveningReflection({
    required int hour,
    required int minute,
  }) async {
    _isEn = await _readIsEn();
    await _notifications.zonedSchedule(
      id: eveningReflectionId,
      title: _isEn ? 'Evening Reflection' : 'Akşam Yansıması',
      body: _isEn
          ? 'How was your day? Take a moment to journal your thoughts.'
          : 'Bugün nasıl geçti? Düşüncelerini günlüğüne yaz.',
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_reflection',
          _isEn ? 'Evening Reflection' : 'Akşam Yansıması',
          channelDescription: _isEn
              ? 'Evening journal reflection reminders'
              : 'Akşam yansıma hatırlatıcıları',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: AppColors.amethyst,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'evening_reflection',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEveningEnabled, true);
  }

  /// Cancel evening reflection notifications
  Future<void> cancelEveningReflection() async {
    await _notifications.cancel(id: eveningReflectionId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEveningEnabled, false);
  }

  // ============== Journal Prompt Notifications ==============

  /// Schedule a daily journal prompt notification at the given time.
  /// Picks today's deterministic prompt from JournalPromptService and
  /// uses the stored language preference for bilingual support.
  Future<void> scheduleJournalPromptNotification({
    required int hour,
    required int minute,
  }) async {
    _isEn = await _readIsEn();

    // Get today's deterministic prompt
    final promptService = await JournalPromptService.init();
    final prompt = promptService.getDailyPrompt();
    final body = _isEn ? prompt.promptEn : prompt.promptTr;

    await _notifications.zonedSchedule(
      id: journalPromptId,
      title: _isEn ? 'Today\'s Journal Prompt' : 'Bugünkü Günlük Sorusu',
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'journal_prompt',
          _isEn ? 'Journal Prompts' : 'Günlük Soruları',
          channelDescription: _isEn
              ? 'Daily journaling prompt to inspire your writing'
              : 'Yazmanıza ilham verecek günlük soru',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: AppColors.auroraEnd,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'journal_prompt',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyJournalPromptEnabled, true);
    await prefs.setInt(_keyJournalPromptTime, hour * 60 + minute);
  }

  /// Cancel journal prompt notification
  Future<void> cancelJournalPromptNotification() async {
    await _notifications.cancel(id: journalPromptId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyJournalPromptEnabled, false);
  }

  /// Check if journal prompt notification is enabled
  Future<bool> isJournalPromptEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyJournalPromptEnabled) ?? false;
  }

  /// Get scheduled journal prompt time
  Future<TimeOfDay?> getJournalPromptTime() async {
    final prefs = await SharedPreferences.getInstance();
    final minutes = prefs.getInt(_keyJournalPromptTime);
    if (minutes == null) return null;
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  // ============== Moon Cycle Awareness Notifications ==============

  /// Schedule moon cycle mindfulness reminders
  Future<void> scheduleMoonPhaseNotifications() async {
    _isEn = await _readIsEn();
    await _notifications.zonedSchedule(
      id: moonCycleId,
      title: _isEn ? 'Moon Cycle Awareness' : 'Ay Döngüsü Farkındalığı',
      body: _isEn
          ? 'A new moon phase is here. A good time for mindful reflection.'
          : 'Yeni bir ay evresi başladı. Bilinçli yansıma için güzel bir zaman.',
      scheduledDate: _nextInstanceOfTime(20, 0),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          _isEn ? 'Moon Cycle Awareness' : 'Ay Döngüsü Farkındalığı',
          channelDescription: _isEn
              ? 'Moon cycle mindfulness reminders'
              : 'Ay döngüsü farkındalık hatırlatıcıları',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'moon_cycle',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMoonPhaseEnabled, true);
  }

  /// Show new moon notification
  Future<void> showNewMoonNotification({String? message}) async {
    _isEn = await _readIsEn();
    await _notifications.show(
      id: newMoonId,
      title: _isEn ? '🌑 New Moon' : '🌑 Yeni Ay',
      body:
          message ??
          (_isEn
              ? 'A time for new beginnings and setting intentions.'
              : 'Yeni başlangıçlar ve niyet belirleme zamanı.'),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          _isEn ? 'Moon Cycle Awareness' : 'Ay Döngüsü Farkındalığı',
          channelDescription: _isEn
              ? 'Moon cycle mindfulness reminders'
              : 'Ay döngüsü farkındalık hatırlatıcıları',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: AppColors.cosmicPurple,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'new_moon',
    );
  }

  /// Show full moon notification
  Future<void> showFullMoonNotification({String? message}) async {
    _isEn = await _readIsEn();
    await _notifications.show(
      id: fullMoonId,
      title: _isEn ? '🌕 Full Moon' : '🌕 Dolunay',
      body:
          message ??
          (_isEn
              ? 'A time for reflection and gratitude.'
              : 'Yansıma ve şükran zamanı.'),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          _isEn ? 'Moon Cycle Awareness' : 'Ay Döngüsü Farkındalığı',
          channelDescription: _isEn
              ? 'Moon cycle mindfulness reminders'
              : 'Ay döngüsü farkındalık hatırlatıcıları',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFF5F5DC),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'full_moon',
    );
  }

  /// Cancel moon cycle notifications
  Future<void> cancelMoonPhaseNotifications() async {
    await _notifications.cancel(id: moonCycleId);
    await _notifications.cancel(id: newMoonId);
    await _notifications.cancel(id: fullMoonId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMoonPhaseEnabled, false);
  }

  // ============== Wellness Reminders ==============

  /// Enable/disable wellness reminders
  Future<void> setWellnessRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWellnessEnabled, enabled);

    if (!enabled) {
      await _notifications.cancel(id: wellnessReminderId);
    }
  }

  // ============== Utility Methods ==============

  /// Get next instance of specified time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDailyEnabled, false);
    await prefs.setBool(_keyMoonPhaseEnabled, false);
    await prefs.setBool(_keyWellnessEnabled, false);
    await prefs.setBool(_keyEveningEnabled, false);
    await prefs.setBool(_keyJournalPromptEnabled, false);
  }

  /// Get notification settings
  Future<NotificationSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationSettings(
      dailyReflectionEnabled: prefs.getBool(_keyDailyEnabled) ?? false,
      dailyReflectionTimeMinutes: prefs.getInt(_keyDailyTime),
      moonPhaseEnabled: prefs.getBool(_keyMoonPhaseEnabled) ?? false,
      wellnessRemindersEnabled: prefs.getBool(_keyWellnessEnabled) ?? false,
      eveningReflectionEnabled: prefs.getBool(_keyEveningEnabled) ?? false,
      journalPromptEnabled:
          prefs.getBool(_keyJournalPromptEnabled) ?? false,
      journalPromptTimeMinutes: prefs.getInt(_keyJournalPromptTime),
    );
  }
}

/// Notification settings model
class NotificationSettings {
  final bool dailyReflectionEnabled;
  final int? dailyReflectionTimeMinutes;
  final bool moonPhaseEnabled;
  final bool wellnessRemindersEnabled;
  final bool eveningReflectionEnabled;
  final bool journalPromptEnabled;
  final int? journalPromptTimeMinutes;

  NotificationSettings({
    required this.dailyReflectionEnabled,
    this.dailyReflectionTimeMinutes,
    required this.moonPhaseEnabled,
    required this.wellnessRemindersEnabled,
    required this.eveningReflectionEnabled,
    required this.journalPromptEnabled,
    this.journalPromptTimeMinutes,
  });

  TimeOfDay? get dailyReflectionTime {
    if (dailyReflectionTimeMinutes == null) return null;
    return TimeOfDay(
      hour: dailyReflectionTimeMinutes! ~/ 60,
      minute: dailyReflectionTimeMinutes! % 60,
    );
  }

  TimeOfDay? get journalPromptTime {
    if (journalPromptTimeMinutes == null) return null;
    return TimeOfDay(
      hour: journalPromptTimeMinutes! ~/ 60,
      minute: journalPromptTimeMinutes! % 60,
    );
  }
}
