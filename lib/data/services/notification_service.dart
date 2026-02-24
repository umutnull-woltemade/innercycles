import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/routes.dart';
import '../../core/theme/app_colors.dart';
import '../models/note_to_self.dart';
import '../models/birthday_contact.dart';
import 'journal_prompt_service.dart';

/// Global navigator key — shared with GoRouter so notification taps
/// can navigate via GoRouter.of(context).go(route).
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
      case 'monthly_wrapped':
        route = Routes.monthlyWrapped;
        break;
      case 'share_reminder':
        route = Routes.today;
        break;
      case 'pattern_discovery':
        route = Routes.journalPatterns;
        break;
      case 'archetype_evolution':
        route = Routes.archetype;
        break;
      case 'challenge_completed':
        route = Routes.challenges;
        break;
      default:
        if (payload.startsWith('birthday:')) {
          final contactId = payload.substring('birthday:'.length);
          route = Routes.birthdayDetail.replaceFirst(':id', contactId);
        } else if (payload.startsWith('note_reminder:')) {
          route = Routes.noteDetail;
        } else {
          route = Routes.today;
        }
    }

    // Use GoRouter for navigation (not Navigator 1.0 pushNamed)
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      try {
        GoRouter.of(ctx).go(route);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Notification navigation failed: $e');
        }
      }
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

  // ============== Note Reminder Notifications ==============

  /// Schedule a note reminder notification
  Future<void> scheduleNoteReminder({
    required int notificationId,
    required DateTime scheduledAt,
    required String noteTitle,
    String? message,
    required String noteId,
    required ReminderFrequency frequency,
  }) async {
    if (kIsWeb) return;
    _isEn = await _readIsEn();

    final title = _isEn ? 'Note Reminder' : 'Not Hatırlatıcı';
    final body = message ?? noteTitle;

    final scheduledTz = tz.TZDateTime.from(scheduledAt, tz.local);

    DateTimeComponents? matchComponents;
    switch (frequency) {
      case ReminderFrequency.daily:
        matchComponents = DateTimeComponents.time;
        break;
      case ReminderFrequency.weekly:
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
        break;
      case ReminderFrequency.monthly:
        matchComponents = DateTimeComponents.dayOfMonthAndTime;
        break;
      case ReminderFrequency.once:
        matchComponents = null;
        break;
    }

    await _notifications.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: scheduledTz,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'note_reminders',
          _isEn ? 'Note Reminders' : 'Not Hatırlatıcıları',
          channelDescription: _isEn
              ? 'Reminders for your personal notes'
              : 'Kişisel notlarınız için hatırlatıcılar',
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
      matchDateTimeComponents: matchComponents,
      payload: 'note_reminder:$noteId',
    );
  }

  /// Cancel a note reminder notification
  Future<void> cancelNoteReminder(int notificationId) async {
    await _notifications.cancel(id: notificationId);
  }

  // ============== Birthday Notifications ==============

  /// Construct a birthday DateTime safely, handling Feb 29 in non-leap years.
  static DateTime _safeBirthdayDate(int year, int month, int day, int hour, int minute) {
    if (month == 2 && day == 29) {
      final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      if (!isLeap) return DateTime(year, 2, 28, hour, minute);
    }
    return DateTime(year, month, day, hour, minute);
  }

  /// Schedule a birthday notification for a contact at 09:00 on their birthday.
  /// Notification ID is derived from contact ID hash (range 50000-50799).
  /// Day-before reminders use range 51000-51799.
  Future<void> scheduleBirthdayNotification(BirthdayContact contact) async {
    if (kIsWeb || !contact.notificationsEnabled) return;
    _isEn = await _readIsEn();

    final notifId = 50000 + (contact.id.hashCode.abs() % 800);
    final now = DateTime.now();
    var birthday = _safeBirthdayDate(now.year, contact.birthdayMonth, contact.birthdayDay, 9, 0);
    if (birthday.isBefore(now)) {
      birthday = _safeBirthdayDate(now.year + 1, contact.birthdayMonth, contact.birthdayDay, 9, 0);
    }

    final scheduledTz = tz.TZDateTime.from(birthday, tz.local);

    await _notifications.zonedSchedule(
      id: notifId,
      title: _isEn
          ? '\u{1F382} ${contact.name}\'s Birthday!'
          : '\u{1F382} ${contact.name} Do\u{011F}um G\u{00FC}n\u{00FC}!',
      body: _isEn
          ? 'Today is ${contact.name}\'s birthday!'
          : 'Bug\u{00FC}n ${contact.name}\'in do\u{011F}um g\u{00FC}n\u{00FC}!',
      scheduledDate: scheduledTz,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'birthday_reminders',
          _isEn ? 'Birthday Reminders' : 'Do\u{011F}um G\u{00FC}n\u{00FC} Hat\u{0131}rlat\u{0131}c\u{0131}lar\u{0131}',
          channelDescription: _isEn
              ? 'Birthday reminder notifications'
              : 'Do\u{011F}um g\u{00FC}n\u{00FC} hat\u{0131}rlat\u{0131}c\u{0131} bildirimleri',
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
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: 'birthday:${contact.id}',
    );

    // Day-before reminder
    if (contact.dayBeforeReminder) {
      final dayBeforeId = 51000 + (contact.id.hashCode.abs() % 800);
      final dayBefore = birthday.subtract(const Duration(days: 1));
      if (dayBefore.isAfter(now)) {
        final dayBeforeTz = tz.TZDateTime.from(dayBefore, tz.local);
        await _notifications.zonedSchedule(
          id: dayBeforeId,
          title: _isEn
              ? '\u{1F389} Tomorrow: ${contact.name}\'s Birthday'
              : '\u{1F389} Yar\u{0131}n: ${contact.name} Do\u{011F}um G\u{00FC}n\u{00FC}',
          body: _isEn
              ? '${contact.name}\'s birthday is tomorrow!'
              : '${contact.name}\'in do\u{011F}um g\u{00FC}n\u{00FC} yar\u{0131}n!',
          scheduledDate: dayBeforeTz,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'birthday_reminders',
              _isEn ? 'Birthday Reminders' : 'Do\u{011F}um G\u{00FC}n\u{00FC} Hat\u{0131}rlat\u{0131}c\u{0131}lar\u{0131}',
              channelDescription: _isEn
                  ? 'Birthday reminder notifications'
                  : 'Do\u{011F}um g\u{00FC}n\u{00FC} hat\u{0131}rlat\u{0131}c\u{0131} bildirimleri',
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
              icon: '@mipmap/ic_launcher',
              color: AppColors.starGold,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: false,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
          payload: 'birthday:${contact.id}',
        );
      }
    }
  }

  /// Cancel birthday notifications for a contact.
  Future<void> cancelBirthdayNotification(String contactId) async {
    final notifId = 50000 + (contactId.hashCode.abs() % 800);
    final dayBeforeId = 51000 + (contactId.hashCode.abs() % 800);
    await _notifications.cancel(id: notifId);
    await _notifications.cancel(id: dayBeforeId);
  }

  /// Reschedule all birthday notifications (call on app launch).
  Future<void> rescheduleAllBirthdayNotifications(
    List<BirthdayContact> contacts,
  ) async {
    for (final contact in contacts) {
      if (contact.notificationsEnabled) {
        await scheduleBirthdayNotification(contact);
      }
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
