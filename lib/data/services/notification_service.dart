import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/routes.dart';

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

  // Preference keys
  static const String _keyDailyEnabled = 'notification_daily_enabled';
  static const String _keyDailyTime = 'notification_daily_time';
  static const String _keyMoonPhaseEnabled = 'notification_moon_enabled';
  static const String _keyWellnessEnabled = 'notification_wellness_enabled';
  static const String _keyEveningEnabled = 'notification_evening_enabled';

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
      default:
        route = Routes.home;
    }

    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(route);
    }
  }

  // ============== Daily Reflection Notifications ==============

  /// Schedule daily reflection notification
  Future<void> scheduleDailyReflection({
    required int hour,
    required int minute,
    String? personalizedMessage,
  }) async {
    final message =
        personalizedMessage ?? 'Take a moment to reflect on your day.';

    await _notifications.zonedSchedule(
      id: dailyReflectionId,
      title: '✨ Your Daily Reflection',
      body: message,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reflection',
          'Daily Reflection',
          channelDescription: 'Daily journal reflection reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFFFD700),
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
    await _notifications.zonedSchedule(
      id: eveningReflectionId,
      title: 'Evening Reflection',
      body: 'How was your day? Take a moment to journal your thoughts.',
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_reflection',
          'Evening Reflection',
          channelDescription: 'Evening journal reflection reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF9B59B6),
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

  // ============== Moon Cycle Awareness Notifications ==============

  /// Schedule moon cycle mindfulness reminders
  Future<void> scheduleMoonPhaseNotifications() async {
    await _notifications.zonedSchedule(
      id: moonCycleId,
      title: 'Moon Cycle Awareness',
      body: 'A new moon phase is here. A good time for mindful reflection.',
      scheduledDate: _nextInstanceOfTime(20, 0),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          'Moon Cycle Awareness',
          channelDescription: 'Moon cycle mindfulness reminders',
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
    await _notifications.show(
      id: newMoonId,
      title: '🌑 New Moon',
      body: message ?? 'A time for new beginnings and setting intentions.',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          'Moon Cycle Awareness',
          channelDescription: 'Moon cycle mindfulness reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF1A1A2E),
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
    await _notifications.show(
      id: fullMoonId,
      title: '🌕 Full Moon',
      body: message ?? 'A time for reflection and gratitude.',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          'Moon Cycle Awareness',
          channelDescription: 'Moon cycle mindfulness reminders',
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

  NotificationSettings({
    required this.dailyReflectionEnabled,
    this.dailyReflectionTimeMinutes,
    required this.moonPhaseEnabled,
    required this.wellnessRemindersEnabled,
    required this.eveningReflectionEnabled,
  });

  TimeOfDay? get dailyReflectionTime {
    if (dailyReflectionTimeMinutes == null) return null;
    return TimeOfDay(
      hour: dailyReflectionTimeMinutes! ~/ 60,
      minute: dailyReflectionTimeMinutes! % 60,
    );
  }
}
