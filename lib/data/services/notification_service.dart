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
import 'analytics_service.dart';
import 'l10n_service.dart';
import 'mood_checkin_service.dart';
import '../providers/app_providers.dart';

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
  static const int streakRecoveryId = 11;
  static const int onThisDayId = 12;
  static const int referralRewardId = 13;
  static const int monthlyRecapId = 14;
  static const int weeklyInsightId = 15;
  static const int moodCheckinReminderId = 16;
  static const int sleepTrackingReminderId = 17;
  static const int habitCompletionReminderId = 18;
  static const int premiumExpiry3DayId = 19;
  static const int premiumExpiry1DayId = 20;

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
  static const String _keyMoodCheckinEnabled = 'notification_mood_checkin_enabled';
  static const String _keySleepTrackingEnabled = 'notification_sleep_tracking_enabled';
  static const String _keyHabitReminderEnabled = 'notification_habit_reminder_enabled';

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
      case 'weekly_digest':
        route = Routes.weeklyDigest;
        break;
      case 'archetype_evolution':
        route = Routes.archetype;
        break;
      case 'challenge_completed':
        route = Routes.challenges;
        break;
      case 'streak_risk':
        route = Routes.journal;
        break;
      case 'streak_recovery':
        route = Routes.journal;
        break;
      case 'on_this_day':
        route = Routes.memories;
        break;
      case 'referral_reward':
        route = Routes.referralProgram;
        break;
      default:
        if (payload.startsWith('birthday:')) {
          final contactId = payload.substring('birthday:'.length);
          route = Routes.birthdayDetail.replaceFirst(':id', contactId);
        } else if (payload.startsWith('note_reminder:')) {
          final noteId = payload.substring('note_reminder:'.length);
          route = '${Routes.noteDetail}?noteId=$noteId';
        } else {
          route = Routes.today;
        }
    }

    // Track notification tap analytics
    AnalyticsService().logEvent('notification_tapped', {
      'payload': payload,
      'route': route,
    });

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
    final language = AppLanguage.fromIsEn(_isEn);
    final message =
        personalizedMessage ??
        (L10nService.get('data.services.notification.take_a_moment_to_reflect_on_your_day', language));

    await _notifications.zonedSchedule(
      id: dailyReflectionId,
      title: L10nService.get('data.services.notification._your_daily_reflection', language),
      body: message,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reflection',
          L10nService.get('data.services.notification.daily_reflection', language),
          channelDescription: L10nService.get('data.services.notification.daily_journal_reflection_reminders', language),
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: AppColors.starGold,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
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
    final language = AppLanguage.fromIsEn(_isEn);

    // Smart copy based on recent mood
    String body;
    try {
      final moodService = await MoodCheckinService.init();
      final todayMood = moodService.getTodayMood();
      if (todayMood != null && todayMood.mood <= 2) {
        body = _isEn
            ? 'Tough days deserve reflection too. Your journal is here for you.'
            : 'Zor günler de yansıtmayı hak eder. Günlüğün senin için burada.';
      } else if (todayMood != null && todayMood.mood >= 4) {
        body = _isEn
            ? 'Great day? Capture what made it special before it fades.'
            : 'Güzel bir gün mü? Özel kılan şeyleri kaybetmeden kaydet.';
      } else {
        body = L10nService.get('data.services.notification.how_was_your_day_take_a_moment_to_journa', language);
      }
    } catch (_) {
      body = L10nService.get('data.services.notification.how_was_your_day_take_a_moment_to_journa', language);
    }

    await _notifications.zonedSchedule(
      id: eveningReflectionId,
      title: L10nService.get('data.services.notification.evening_reflection', language),
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'evening_reflection',
          L10nService.get('data.services.notification.evening_reflection_1', language),
          channelDescription: L10nService.get('data.services.notification.evening_journal_reflection_reminders', language),
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: AppColors.amethyst,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
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
    final language = AppLanguage.fromIsEn(_isEn);

    // Get today's deterministic prompt
    final promptService = await JournalPromptService.init();
    final prompt = promptService.getDailyPrompt();
    final body = prompt.localizedPrompt(language);

    await _notifications.zonedSchedule(
      id: journalPromptId,
      title: L10nService.get('data.services.notification.todays_journal_prompt', language),
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'journal_prompt',
          L10nService.get('data.services.notification.journal_prompts', language),
          channelDescription: L10nService.get('data.services.notification.daily_journaling_prompt_to_inspire_your', language),
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

  // ============== Streak-at-Risk Notifications ==============

  /// Schedule a streak-at-risk reminder for 8:30 PM if user hasn't journaled.
  /// Call this on app launch — it schedules for today at 20:30.
  /// Should be canceled when user saves a journal entry.
  Future<void> scheduleStreakAtRisk({required int currentStreak}) async {
    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);

    final now = DateTime.now();
    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
      30,
    );

    // If 8:30 PM already passed, don't schedule
    if (scheduledTime.isBefore(now)) return;

    // Day 0/1 users get an encouraging first-day nudge instead
    final String title;
    final String body;
    if (currentStreak < 2) {
      title = _isEn ? 'Your first day!' : 'İlk günün!';
      body = _isEn
          ? 'A quick entry tonight starts your journaling streak'
          : 'Bu akşam kısa bir giriş, yazma serini başlatır';
    } else {
      title = L10nService.getWithParams('data.services.notification.streak_at_risk_title', language, params: {'streak': '$currentStreak'});
      body = L10nService.get('data.services.notification.a_quick_checkin_keeps_your_momentum_goin', language);
    }

    await _notifications.zonedSchedule(
      id: journalStreakId,
      title: title,
      body: body,
      scheduledDate: scheduledTime,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_risk',
          L10nService.get('data.services.notification.streak_reminders', language),
          channelDescription: L10nService.get('data.services.notification.alerts_when_your_journaling_streak_is_ab', language),
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
      payload: 'streak_risk',
    );
  }

  /// Cancel streak-at-risk notification (call after user journals today).
  Future<void> cancelStreakAtRisk() async {
    await _notifications.cancel(id: journalStreakId);
  }

  // ============== Streak Recovery Notifications ==============

  /// Schedule a gentle re-engagement notification for tomorrow at 10:00 AM
  /// when the user just broke their streak. Encourages them to start fresh.
  Future<void> scheduleStreakRecovery({required int lostStreak}) async {
    if (lostStreak < 2) return;

    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);

    final now = DateTime.now();
    final tomorrow = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + 1,
      10,
      0,
    );

    await _notifications.zonedSchedule(
      id: streakRecoveryId,
      title: L10nService.get('data.services.notification.every_streak_starts_at_day_1', language),
      body: L10nService.getWithParams('data.services.notification.streak_recovery_body', language, params: {'streak': '$lostStreak'}),
      scheduledDate: tomorrow,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_recovery',
          L10nService.get('data.services.notification.streak_recovery', language),
          channelDescription: L10nService.get('data.services.notification.encouragement_to_start_a_new_streak', language),
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
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
      payload: 'streak_recovery',
    );
  }

  /// Cancel streak recovery notification.
  Future<void> cancelStreakRecovery() async {
    await _notifications.cancel(id: streakRecoveryId);
  }

  // ============== On This Day Memory Notifications ==============

  /// Schedule a nostalgia notification for today at 11 AM when user has
  /// entries from the same date in a previous year.
  Future<void> scheduleOnThisDayMemory({required int yearsAgo}) async {
    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);

    final now = DateTime.now();
    var scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11, 0);

    // If 11 AM already passed, skip
    if (scheduledTime.isBefore(now)) return;

    await _notifications.zonedSchedule(
      id: onThisDayId,
      title: L10nService.getWithParams(yearsAgo == 1 ? 'data.services.notification.on_this_day_title_singular' : 'data.services.notification.on_this_day_title_plural', language, params: {'years': '$yearsAgo'}),
      body: L10nService.get('data.services.notification.see_what_you_wrote_on_this_day_your_past', language),
      scheduledDate: scheduledTime,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'on_this_day',
          L10nService.get('data.services.notification.on_this_day', language),
          channelDescription: L10nService.get('data.services.notification.memories_from_past_journal_entries', language),
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: AppColors.starGold,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'on_this_day',
    );
  }

  // ============== Referral Reward Notifications ==============

  /// Show immediate notification when a referral reward is earned.
  Future<void> showReferralRewardNotification({
    required int totalReferrals,
  }) async {
    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);

    String title;
    String body;

    if (totalReferrals >= 10) {
      title = L10nService.get('data.services.notification.u1f48e_lifetime_premium_unlocked', language);
      body = L10nService.get('data.services.notification.10_friends_joined_youve_earned_lifetime', language);
    } else if (totalReferrals >= 3) {
      title = L10nService.get('data.services.notification.u2b50_1_month_free_premium', language);
      body = L10nService.getWithParams('data.services.notification.referral_body_month', language, params: {'count': '$totalReferrals'});
    } else {
      title = L10nService.get('data.services.notification.u1f381_referral_reward_7_days_premium', language);
      body = L10nService.get('data.services.notification.a_friend_joined_with_your_code_you_both', language);
    }

    await _notifications.show(
      id: referralRewardId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'referral_rewards',
          L10nService.get('data.services.notification.referral_rewards', language),
          channelDescription: L10nService.get('data.services.notification.notifications_when_friends_join_with_you', language),
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
      payload: 'referral_reward',
    );
  }

  // ============== Moon Cycle Awareness Notifications ==============

  /// Schedule moon cycle mindfulness reminders
  Future<void> scheduleMoonPhaseNotifications() async {
    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);
    await _notifications.zonedSchedule(
      id: moonCycleId,
      title: L10nService.get('data.services.notification.moon_cycle_awareness', language),
      body: L10nService.get('data.services.notification.a_new_moon_phase_is_here_a_good_time_for', language),
      scheduledDate: _nextInstanceOfTime(20, 0),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          L10nService.get('data.services.notification.moon_cycle_awareness_1', language),
          channelDescription: L10nService.get('data.services.notification.moon_cycle_mindfulness_reminders', language),
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
    final language = AppLanguage.fromIsEn(_isEn);
    await _notifications.show(
      id: newMoonId,
      title: L10nService.get('data.services.notification._new_moon', language),
      body: message ??
          (L10nService.get('data.services.notification.a_time_for_new_beginnings_and_setting_in', language)),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          L10nService.get('data.services.notification.moon_cycle_awareness_2', language),
          channelDescription: L10nService.get('data.services.notification.moon_cycle_mindfulness_reminders_1', language),
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
      payload: 'new_moon',
    );
  }

  /// Show full moon notification
  Future<void> showFullMoonNotification({String? message}) async {
    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);
    await _notifications.show(
      id: fullMoonId,
      title: L10nService.get('data.services.notification._full_moon', language),
      body: message ??
          (L10nService.get('data.services.notification.a_time_for_reflection_and_gratitude', language)),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'moon_cycle',
          L10nService.get('data.services.notification.moon_cycle_awareness_3', language),
          channelDescription: L10nService.get('data.services.notification.moon_cycle_mindfulness_reminders_2', language),
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: AppColors.celestialGold,
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
    final language = AppLanguage.fromIsEn(_isEn);

    final title = L10nService.get('data.services.notification.note_reminder', language);
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
          L10nService.get('data.services.notification.note_reminders', language),
          channelDescription: L10nService.get('data.services.notification.reminders_for_your_personal_notes', language),
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
  static DateTime _safeBirthdayDate(
    int year,
    int month,
    int day,
    int hour,
    int minute,
  ) {
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
    final language = AppLanguage.fromIsEn(_isEn);

    final notifId = 50000 + (contact.id.hashCode.abs() % 800);
    final now = DateTime.now();
    var birthday = _safeBirthdayDate(
      now.year,
      contact.birthdayMonth,
      contact.birthdayDay,
      9,
      0,
    );
    if (birthday.isBefore(now)) {
      birthday = _safeBirthdayDate(
        now.year + 1,
        contact.birthdayMonth,
        contact.birthdayDay,
        9,
        0,
      );
    }

    final scheduledTz = tz.TZDateTime.from(birthday, tz.local);

    await _notifications.zonedSchedule(
      id: notifId,
      title: L10nService.getWithParams('data.services.notification.birthday_today_title', language, params: {'name': contact.name}),
      body: L10nService.getWithParams('data.services.notification.birthday_today_body', language, params: {'name': contact.name}),
      scheduledDate: scheduledTz,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'birthday_reminders',
          L10nService.get('data.services.notification.birthday_reminders', language),
          channelDescription: L10nService.get('data.services.notification.birthday_reminder_notifications', language),
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
          title: L10nService.getWithParams('data.services.notification.birthday_tomorrow_title', language, params: {'name': contact.name}),
          body: L10nService.getWithParams('data.services.notification.birthday_tomorrow_body', language, params: {'name': contact.name}),
          scheduledDate: dayBeforeTz,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'birthday_reminders',
              L10nService.get('data.services.notification.birthday_reminders_1', language),
              channelDescription: L10nService.get('data.services.notification.birthday_reminder_notifications_1', language),
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

  // ============== Monthly Recap Notifications ==============

  /// Schedule a notification for the 1st of next month at 10 AM
  /// reminding the user to check their monthly recap.
  Future<void> scheduleMonthlyRecapNotification({
    required int lastMonthEntryCount,
  }) async {
    _isEn = await _readIsEn();

    final now = DateTime.now();
    // Schedule for the 1st of next month at 10 AM
    final nextMonth = now.month == 12
        ? tz.TZDateTime(tz.local, now.year + 1, 1, 1, 10, 0)
        : tz.TZDateTime(tz.local, now.year, now.month + 1, 1, 10, 0);

    final title = _isEn
        ? '\uD83D\uDCCA Your Monthly Recap is Ready'
        : '\uD83D\uDCCA Aylık Özetin Hazır';

    final body = lastMonthEntryCount > 0
        ? (_isEn
            ? 'You wrote $lastMonthEntryCount entries last month. See your patterns and insights.'
            : 'Geçen ay $lastMonthEntryCount kayıt yazdın. Örüntülerini ve içgörülerini gör.')
        : (_isEn
            ? 'Start the new month with a fresh perspective. Check your recap.'
            : 'Yeni aya taze bir bakış açısıyla başla. Özetine göz at.');

    await _notifications.zonedSchedule(
      id: monthlyRecapId,
      title: title,
      body: body,
      scheduledDate: nextMonth,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'monthly_recap',
          _isEn ? 'Monthly Recap' : 'Aylık Özet',
          channelDescription: _isEn
              ? 'Monthly recap notification'
              : 'Aylık özet bildirimi',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: AppColors.starGold,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'monthly_recap',
    );
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

  // ============== Mood Check-in Reminder ==============

  /// Schedule daily mood check-in reminder at 2 PM.
  Future<void> scheduleMoodCheckinReminder() async {
    if (!_isInitialized) await initialize();
    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);

    final title = language == AppLanguage.en
        ? 'How are you feeling?'
        : 'Nas\u0131l hissediyorsun?';
    final body = language == AppLanguage.en
        ? 'A quick mood check-in takes 5 seconds and helps track your patterns.'
        : 'H\u0131zl\u0131 bir ruh hali kayd\u0131 5 saniye s\u00fcrer ve \u00f6r\u00fcnt\u00fclerini takip etmene yard\u0131mc\u0131 olur.';

    await _notifications.zonedSchedule(
      id: moodCheckinReminderId,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(14, 0),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'mood_checkin',
          language == AppLanguage.en ? 'Mood Check-in' : 'Ruh Hali Kayd\u0131',
          channelDescription: language == AppLanguage.en
              ? 'Daily mood check-in reminders'
              : 'G\u00fcnl\u00fck ruh hali kay\u0131t hat\u0131rlat\u0131c\u0131lar\u0131',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
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
      payload: 'mood_checkin',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMoodCheckinEnabled, true);
  }

  Future<void> cancelMoodCheckinReminder() async {
    await _notifications.cancel(id: moodCheckinReminderId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMoodCheckinEnabled, false);
  }

  Future<bool> isMoodCheckinReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyMoodCheckinEnabled) ?? false;
  }

  // ============== Sleep Tracking Reminder ==============

  /// Schedule daily sleep tracking reminder at 9 AM.
  Future<void> scheduleSleepTrackingReminder() async {
    if (!_isInitialized) await initialize();
    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);

    final title = language == AppLanguage.en
        ? 'How did you sleep?'
        : 'Nas\u0131l uyudun?';
    final body = language == AppLanguage.en
        ? 'Log your sleep quality to discover patterns between rest and mood.'
        : 'Uyku kaliteni kaydet ve dinlenme ile ruh halin aras\u0131ndaki ba\u011flant\u0131lar\u0131 ke\u015ffet.';

    await _notifications.zonedSchedule(
      id: sleepTrackingReminderId,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(9, 0),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'sleep_tracking',
          language == AppLanguage.en ? 'Sleep Tracking' : 'Uyku Takibi',
          channelDescription: language == AppLanguage.en
              ? 'Daily sleep tracking reminders'
              : 'G\u00fcnl\u00fck uyku takibi hat\u0131rlat\u0131c\u0131lar\u0131',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: AppColors.amethyst,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'sleep_tracking',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySleepTrackingEnabled, true);
  }

  Future<void> cancelSleepTrackingReminder() async {
    await _notifications.cancel(id: sleepTrackingReminderId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySleepTrackingEnabled, false);
  }

  Future<bool> isSleepTrackingReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySleepTrackingEnabled) ?? false;
  }

  // ============== Habit Completion Reminder ==============

  /// Schedule daily habit completion reminder at 7 PM.
  Future<void> scheduleHabitCompletionReminder() async {
    if (!_isInitialized) await initialize();
    _isEn = await _readIsEn();
    final language = AppLanguage.fromIsEn(_isEn);

    final title = language == AppLanguage.en
        ? 'Complete your daily habits'
        : 'G\u00fcnl\u00fck al\u0131\u015fkanl\u0131klar\u0131n\u0131 tamamla';
    final body = language == AppLanguage.en
        ? 'Small consistent actions shape who you become.'
        : 'K\u00fc\u00e7\u00fck tutarl\u0131 ad\u0131mlar kim olaca\u011f\u0131n\u0131 \u015fekillendirir.';

    await _notifications.zonedSchedule(
      id: habitCompletionReminderId,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(19, 0),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminder',
          language == AppLanguage.en ? 'Habit Reminders' : 'Al\u0131\u015fkanl\u0131k Hat\u0131rlat\u0131c\u0131lar\u0131',
          channelDescription: language == AppLanguage.en
              ? 'Daily habit completion reminders'
              : 'G\u00fcnl\u00fck al\u0131\u015fkanl\u0131k tamamlama hat\u0131rlat\u0131c\u0131lar\u0131',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: AppColors.success,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'habit_reminder',
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHabitReminderEnabled, true);
  }

  Future<void> cancelHabitCompletionReminder() async {
    await _notifications.cancel(id: habitCompletionReminderId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHabitReminderEnabled, false);
  }

  Future<bool> isHabitReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHabitReminderEnabled) ?? false;
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
    await prefs.setBool(_keyMoodCheckinEnabled, false);
    await prefs.setBool(_keySleepTrackingEnabled, false);
    await prefs.setBool(_keyHabitReminderEnabled, false);
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
      journalPromptEnabled: prefs.getBool(_keyJournalPromptEnabled) ?? false,
      journalPromptTimeMinutes: prefs.getInt(_keyJournalPromptTime),
      moodCheckinEnabled: prefs.getBool(_keyMoodCheckinEnabled) ?? false,
      sleepTrackingEnabled: prefs.getBool(_keySleepTrackingEnabled) ?? false,
      habitReminderEnabled: prefs.getBool(_keyHabitReminderEnabled) ?? false,
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROACTIVE INSIGHT NOTIFICATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Schedule a weekly pattern insight notification.
  /// Fires Sunday at 18:00 with the given insight text.
  Future<void> scheduleWeeklyInsight({
    required String insightText,
    AppLanguage language = AppLanguage.en,
  }) async {
    if (!_isInitialized) await initialize();

    final title = language == AppLanguage.en
        ? 'Weekly Pattern Insight'
        : 'Haftalık Örüntü Keşfi';

    // Schedule for next Sunday at 18:00
    final now = tz.TZDateTime.now(tz.local);
    var nextSunday = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      18,
      0,
    );
    // Advance to next Sunday
    while (nextSunday.weekday != DateTime.sunday || nextSunday.isBefore(now)) {
      nextSunday = nextSunday.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id: weeklyInsightId,
      title: title,
      body: insightText,
      scheduledDate: nextSunday,
      notificationDetails: NotificationDetails(
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'insight',
        ),
        android: const AndroidNotificationDetails(
          'insight',
          'Pattern Insights',
          channelDescription: 'Weekly pattern insights from your journal data',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'pattern_discovery',
    );
  }

  /// Cancel the weekly insight notification.
  Future<void> cancelWeeklyInsight() async {
    await _notifications.cancel(id: weeklyInsightId);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // WEEKLY DIGEST NOTIFICATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Schedule a "Your weekly summary is ready" notification for Sunday 10:00.
  /// The teaser message is personalized with the user's week stats.
  Future<void> scheduleWeeklyDigest({
    required int entriesThisWeek,
    required int streakDays,
    AppLanguage language = AppLanguage.en,
  }) async {
    if (!_isInitialized) await initialize();

    final title = language == AppLanguage.en
        ? 'Your Weekly Summary is Ready'
        : 'Haftalık Özetin Hazır';

    final body = language == AppLanguage.en
        ? '$entriesThisWeek entries this week${streakDays > 2 ? ' · $streakDays-day streak' : ''}. See your patterns & share your progress!'
        : 'Bu hafta $entriesThisWeek kayıt${streakDays > 2 ? ' · $streakDays günlük seri' : ''}. Örüntülerini gör ve ilerlemenİ paylaş!';

    // Schedule for next Sunday at 10:00
    final now = tz.TZDateTime.now(tz.local);
    var nextSunday = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      10,
      0,
    );
    while (nextSunday.weekday != DateTime.sunday || nextSunday.isBefore(now)) {
      nextSunday = nextSunday.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id: weeklyReviewId,
      title: title,
      body: body,
      scheduledDate: nextSunday,
      notificationDetails: NotificationDetails(
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'digest',
        ),
        android: const AndroidNotificationDetails(
          'digest',
          'Weekly Digest',
          channelDescription: 'Weekly journal summary notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'weekly_digest',
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PREMIUM EXPIRY REMINDERS
  // ══════════════════════════════════════════════════════════════════════════

  /// Schedule pre-expiry notifications at 3 days and 1 day before premium expires
  Future<void> schedulePremiumExpiryReminders({
    required DateTime expiryDate,
    AppLanguage language = AppLanguage.en,
  }) async {
    if (!_isInitialized) await initialize();

    // Cancel any existing expiry reminders
    await cancelPremiumExpiryReminders();

    final now = tz.TZDateTime.now(tz.local);

    // 3-day reminder
    final threeDaysBefore = tz.TZDateTime.from(
      expiryDate.subtract(const Duration(days: 3)),
      tz.local,
    );
    if (threeDaysBefore.isAfter(now)) {
      final title = language == AppLanguage.en
          ? 'Premium expires in 3 days'
          : 'Premium 3 gün sonra bitiyor';
      final body = language == AppLanguage.en
          ? 'Renew now to keep your patterns, AI insights & streak freeze.'
          : 'Örüntülerini, AI içgörülerini ve seri korumayı kaybetme — şimdi yenile.';

      await _notifications.zonedSchedule(
        id: premiumExpiry3DayId,
        title: title,
        body: body,
        scheduledDate: threeDaysBefore,
        notificationDetails: const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            threadIdentifier: 'premium',
          ),
          android: AndroidNotificationDetails(
            'premium',
            'Premium',
            channelDescription: 'Premium subscription notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'premium_expiry',
      );
    }

    // 1-day reminder
    final oneDayBefore = tz.TZDateTime.from(
      expiryDate.subtract(const Duration(days: 1)),
      tz.local,
    );
    if (oneDayBefore.isAfter(now)) {
      final title = language == AppLanguage.en
          ? 'Premium expires tomorrow'
          : 'Premium yarın bitiyor';
      final body = language == AppLanguage.en
          ? 'Last chance to renew — your streak freeze and AI features will be paused.'
          : 'Yenileme için son şans — seri koruma ve AI özelliklerin duraklatılacak.';

      await _notifications.zonedSchedule(
        id: premiumExpiry1DayId,
        title: title,
        body: body,
        scheduledDate: oneDayBefore,
        notificationDetails: const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            threadIdentifier: 'premium',
          ),
          android: AndroidNotificationDetails(
            'premium',
            'Premium',
            channelDescription: 'Premium subscription notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'premium_expiry',
      );
    }
  }

  Future<void> cancelPremiumExpiryReminders() async {
    if (!_isInitialized) await initialize();
    await _notifications.cancel(id: premiumExpiry3DayId);
    await _notifications.cancel(id: premiumExpiry1DayId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOND / TOUCH NOTIFICATIONS (IDs 52000-52999)
  // ═══════════════════════════════════════════════════════════════════════════

  static const int _bondTouchBaseId = 52000;
  static const int _bondStatusBaseId = 52500;

  /// Show instant notification for received touch
  Future<void> showTouchReceivedNotification({
    required String senderName,
    required String touchTypeEmoji,
    bool isEn = true,
  }) async {
    if (!_isInitialized) await initialize();

    final title = isEn ? '$touchTypeEmoji Touch received' : '$touchTypeEmoji Dokunuş alındı';
    final body = isEn
        ? '$senderName sent you a warm touch'
        : '$senderName sana sıcak bir dokunuş gönderdi';

    await _notifications.show(
      id: _bondTouchBaseId + (DateTime.now().millisecondsSinceEpoch % 999),
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'bond_touches',
          isEn ? 'Bond Touches' : 'Bağ Dokunuşları',
          channelDescription: isEn
              ? 'Notifications when your bond partner sends a touch'
              : 'Bağ partneriniz dokunuş gönderdiğinde bildirimler',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: AppColors.amethyst,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'bond_touch',
    );
  }

  /// Show notification for bond formed
  Future<void> showBondFormedNotification({
    required String partnerName,
    bool isEn = true,
  }) async {
    if (!_isInitialized) await initialize();

    final title = isEn ? '💑 Bond created!' : '💑 Bağ oluşturuldu!';
    final body = isEn
        ? 'You and $partnerName are now connected'
        : 'Sen ve $partnerName artık bağlısınız';

    await _notifications.show(
      id: _bondStatusBaseId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'bond_status',
          isEn ? 'Bond Updates' : 'Bağ Güncellemeleri',
          channelDescription: isEn
              ? 'Bond creation and status notifications'
              : 'Bağ oluşturma ve durum bildirimleri',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: AppColors.amethyst,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'bond_formed',
    );
  }

  /// Show notification for bond dissolve request
  Future<void> showBondDissolveNotification({
    required String partnerName,
    bool isEn = true,
  }) async {
    if (!_isInitialized) await initialize();

    final title = isEn ? 'Bond dissolving' : 'Bağ çözülüyor';
    final body = isEn
        ? '$partnerName requested to dissolve your bond. 7-day cooling period started.'
        : '$partnerName bağınızı çözmeyi istedi. 7 günlük bekleme süresi başladı.';

    await _notifications.show(
      id: _bondStatusBaseId + 1,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'bond_status',
          isEn ? 'Bond Updates' : 'Bağ Güncellemeleri',
          channelDescription: isEn
              ? 'Bond creation and status notifications'
              : 'Bağ oluşturma ve durum bildirimleri',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: AppColors.warning,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'bond_dissolve',
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
  final bool moodCheckinEnabled;
  final bool sleepTrackingEnabled;
  final bool habitReminderEnabled;

  NotificationSettings({
    required this.dailyReflectionEnabled,
    this.dailyReflectionTimeMinutes,
    required this.moonPhaseEnabled,
    required this.wellnessRemindersEnabled,
    required this.eveningReflectionEnabled,
    required this.journalPromptEnabled,
    this.journalPromptTimeMinutes,
    this.moodCheckinEnabled = false,
    this.sleepTrackingEnabled = false,
    this.habitReminderEnabled = false,
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
