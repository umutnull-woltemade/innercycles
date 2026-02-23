// ════════════════════════════════════════════════════════════════════════════
// NOTIFICATION LIFECYCLE SERVICE - InnerCycles Smart Notification Manager
// ════════════════════════════════════════════════════════════════════════════
// Schedules contextual notifications based on user behavior, streaks,
// milestones, moon phases, and re-engagement windows. Respects quiet hours,
// enforces max 1 notification/day, and learns preferred journaling time.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import 'journal_service.dart';
import 'moon_phase_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// NOTIFICATION TYPES
// ════════════════════════════════════════════════════════════════════════════

/// All lifecycle notification types, ordered by priority (highest first).
enum LifecycleNotificationType {
  milestonesCelebration,
  challengeCompleted,
  archetypeEvolution,
  patternDiscovery,
  streakReminder,
  insightTeaser,
  shareReminder,
  moodCheckIn,
  weeklyDigest,
  monthlyWrappedReady,
  seasonalTrigger,
  wrappedReady,
  reEngagement3Day,
  reEngagement7Day,
  reEngagement14Day,
  reEngagement30Day,
}

// ════════════════════════════════════════════════════════════════════════════
// NOTIFICATION IDS (offset from existing IDs in NotificationService)
// ════════════════════════════════════════════════════════════════════════════

/// Unique notification IDs for each lifecycle type.
/// Offset at 100 to avoid collision with base NotificationService IDs (1-9).
/// Reserved for future per-type independent scheduling.
// ignore: unused_element
class _LifecycleNotificationIds {
  // ignore: unused_field
  static const int streakReminder = 100;
  // ignore: unused_field
  static const int insightTeaser = 101;
  // ignore: unused_field
  static const int moodCheckIn = 102;
  // ignore: unused_field
  static const int milestonesCelebration = 103;
  // ignore: unused_field
  static const int seasonalTrigger = 104;
  // ignore: unused_field
  static const int reEngagement3Day = 105;
  // ignore: unused_field
  static const int reEngagement7Day = 106;
  // ignore: unused_field
  static const int reEngagement14Day = 107;
  // ignore: unused_field
  static const int reEngagement30Day = 108;
  // ignore: unused_field
  static const int weeklyDigest = 109;
  // ignore: unused_field
  static const int wrappedReady = 110;
  // ignore: unused_field
  static const int challengeCompleted = 111;
  // ignore: unused_field
  static const int archetypeEvolution = 112;
  // ignore: unused_field
  static const int patternDiscovery = 113;
  // ignore: unused_field
  static const int shareReminder = 114;
  // ignore: unused_field
  static const int monthlyWrappedReady = 115;
}

// ════════════════════════════════════════════════════════════════════════════
// NOTIFICATION LIFECYCLE SERVICE
// ════════════════════════════════════════════════════════════════════════════

class NotificationLifecycleService {
  // SharedPreferences keys
  static const String _keyLastActivity = 'nlc_last_activity_date';
  static const String _keyJournalingHours = 'nlc_journaling_hours';
  static const String _keyLastNotifDate = 'nlc_last_notification_date';
  static const String _keyLastNotifType = 'nlc_last_notification_type';
  static const String _keyCelebratedMilestones = 'nlc_celebrated_milestones';
  static const String _keyEnabled = 'nlc_lifecycle_enabled';
  static const String _keyLastMilestoneDate = 'nlc_last_milestone_date';
  static const String _keyLastArchetype = 'nlc_last_archetype';
  static const String _keyLastPatternCount = 'nlc_last_pattern_count';

  final SharedPreferences _prefs;
  final NotificationService _notificationService;

  NotificationLifecycleService._(this._prefs, this._notificationService);

  /// Whether the user's language is English (false = Turkish).
  bool get _isEn => (_prefs.getInt('app_language') ?? 0) == 0;

  /// Initialize the notification lifecycle service.
  static Future<NotificationLifecycleService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final notifService = NotificationService();
    return NotificationLifecycleService._(prefs, notifService);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ENABLE / DISABLE
  // ══════════════════════════════════════════════════════════════════════════

  /// Whether lifecycle notifications are enabled. Defaults to true.
  bool get isEnabled => _prefs.getBool(_keyEnabled) ?? true;

  /// Enable or disable all lifecycle notifications.
  Future<void> setEnabled(bool enabled) async {
    await _prefs.setBool(_keyEnabled, enabled);
    if (!enabled) {
      await cancelAllLifecycleNotifications();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ACTIVITY TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  /// Record that the user performed an activity (journal entry, check-in, etc.).
  /// Call this whenever the user creates or updates a journal entry.
  Future<void> recordActivity() async {
    final now = DateTime.now();
    await _prefs.setString(_keyLastActivity, now.toIso8601String());

    // Track the hour for preferred-time learning
    await _trackJournalingHour(now.hour);
  }

  /// Get the last activity date, or null if never recorded.
  DateTime? get lastActivityDate {
    final str = _prefs.getString(_keyLastActivity);
    if (str == null) return null;
    try {
      return DateTime.parse(str);
    } catch (e) {
      if (kDebugMode) debugPrint('NotifLifecycle: parse lastActivityDate: $e');
      return null;
    }
  }

  /// Number of days since the user's last activity.
  /// Returns -1 if no activity has ever been recorded.
  int get daysSinceLastActivity {
    final last = lastActivityDate;
    if (last == null) return -1;
    return DateTime.now().difference(last).inDays;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PREFERRED JOURNALING TIME
  // ══════════════════════════════════════════════════════════════════════════

  /// Track the hour the user journals at.
  Future<void> _trackJournalingHour(int hour) async {
    final hours = _getJournalingHours();
    hours.add(hour);

    // Keep only the last 30 data points
    if (hours.length > 30) {
      hours.removeRange(0, hours.length - 30);
    }

    await _prefs.setString(_keyJournalingHours, json.encode(hours));
  }

  /// Get recorded journaling hours.
  List<int> _getJournalingHours() {
    final str = _prefs.getString(_keyJournalingHours);
    if (str == null) return [];
    try {
      final decoded = json.decode(str) as List<dynamic>;
      return decoded.map((e) => (e as num).toInt()).toList();
    } catch (e) {
      if (kDebugMode) debugPrint('NotifLifecycle: decode journaling hours: $e');
      return [];
    }
  }

  /// Calculate the user's preferred journaling hour based on history.
  /// Falls back to 9 AM (morning) if insufficient data.
  int get preferredHour {
    final hours = _getJournalingHours();
    if (hours.length < 3) return 9; // Default: 9 AM

    // Find the most frequent hour
    final frequency = <int, int>{};
    for (final h in hours) {
      frequency[h] = (frequency[h] ?? 0) + 1;
    }

    int bestHour = 9;
    int bestCount = 0;
    for (final entry in frequency.entries) {
      if (entry.value > bestCount) {
        bestCount = entry.value;
        bestHour = entry.key;
      }
    }

    // Clamp to respect quiet hours (7 AM - 10 PM)
    return _clampToAllowedHours(bestHour);
  }

  /// Ensure the hour is within allowed notification window (7 AM - 10 PM).
  int _clampToAllowedHours(int hour) {
    if (hour < 7) return 9; // Too early -> default 9 AM
    if (hour >= 22) return 20; // Too late -> default 8 PM
    return hour;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DAILY LIMIT CHECK
  // ══════════════════════════════════════════════════════════════════════════

  /// Whether a lifecycle notification has already been sent today.
  bool get hasNotifiedToday {
    final str = _prefs.getString(_keyLastNotifDate);
    if (str == null) return false;
    try {
      final lastDate = DateTime.parse(str);
      final now = DateTime.now();
      return lastDate.year == now.year &&
          lastDate.month == now.month &&
          lastDate.day == now.day;
    } catch (e) {
      if (kDebugMode) debugPrint('NotifLifecycle: parse hasNotifiedToday: $e');
      return false;
    }
  }

  /// Mark that a notification was sent today.
  Future<void> _markNotificationSent(LifecycleNotificationType type) async {
    await _prefs.setString(_keyLastNotifDate, DateTime.now().toIso8601String());
    await _prefs.setString(_keyLastNotifType, type.name);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MILESTONE TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  /// Milestone day counts that trigger celebration notifications.
  static const List<int> milestoneDays = [7, 14, 30, 60, 90, 180, 365];

  /// Get the set of milestones already celebrated.
  Set<int> get _celebratedMilestones {
    final str = _prefs.getString(_keyCelebratedMilestones);
    if (str == null) return {};
    try {
      final decoded = json.decode(str) as List<dynamic>;
      return decoded.map((e) => (e as num).toInt()).toSet();
    } catch (e) {
      if (kDebugMode) debugPrint('NotifLifecycle: decode milestones: $e');
      return {};
    }
  }

  /// Mark a milestone as celebrated.
  Future<void> _celebrateMilestone(int days) async {
    final celebrated = _celebratedMilestones;
    celebrated.add(days);
    await _prefs.setString(
      _keyCelebratedMilestones,
      json.encode(celebrated.toList()),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NOTIFICATION EVALUATION & SCHEDULING
  // ══════════════════════════════════════════════════════════════════════════

  /// Evaluate the user's current state and schedule the single most
  /// appropriate notification. This should be called on app launch and
  /// after each journal save.
  ///
  /// Requires [journalService] to read streak and entry data.
  Future<void> evaluate(
    JournalService journalService, {
    String? currentArchetype,
    int? patternCount,
    bool? challengeJustCompleted,
    bool? monthlyWrappedAvailable,
  }) async {
    if (kIsWeb) return;
    if (!isEnabled) return;

    // Cancel any previously scheduled lifecycle notifications first
    await cancelAllLifecycleNotifications();

    // Determine the best notification to schedule
    final selected = _selectNotification(
      journalService,
      currentArchetype: currentArchetype,
      patternCount: patternCount,
      challengeJustCompleted: challengeJustCompleted,
      monthlyWrappedAvailable: monthlyWrappedAvailable,
    );
    if (selected == null) return;

    await _scheduleNotification(selected, journalService);
  }

  /// Select the highest-priority notification type that applies right now.
  /// Returns null if no notification should be scheduled.
  LifecycleNotificationType? _selectNotification(
    JournalService journalService, {
    String? currentArchetype,
    int? patternCount,
    bool? challengeJustCompleted,
    bool? monthlyWrappedAvailable,
  }) {
    final now = DateTime.now();
    final streak = journalService.getCurrentStreak();
    final totalEntries = journalService.entryCount;
    final hasLoggedToday = journalService.hasLoggedToday();
    final inactivityDays = daysSinceLastActivity;

    // Priority 1: Milestone celebration
    for (final milestone in milestoneDays) {
      if (totalEntries == milestone &&
          !_celebratedMilestones.contains(milestone)) {
        return LifecycleNotificationType.milestonesCelebration;
      }
    }

    // Priority 1.5: Challenge completed
    if (challengeJustCompleted == true) {
      return LifecycleNotificationType.challengeCompleted;
    }

    // Priority 1.6: Archetype evolution (monthly archetype changed)
    if (currentArchetype != null) {
      final lastArchetype = _prefs.getString(_keyLastArchetype);
      if (lastArchetype != null && lastArchetype != currentArchetype) {
        _prefs.setString(_keyLastArchetype, currentArchetype);
        return LifecycleNotificationType.archetypeEvolution;
      }
      // Save current archetype for future comparison
      if (lastArchetype == null) {
        _prefs.setString(_keyLastArchetype, currentArchetype);
      }
    }

    // Priority 1.7: Pattern discovery (new correlation found)
    if (patternCount != null) {
      final lastPatternCount = _prefs.getInt(_keyLastPatternCount) ?? 0;
      if (patternCount > lastPatternCount && lastPatternCount > 0) {
        _prefs.setInt(_keyLastPatternCount, patternCount);
        return LifecycleNotificationType.patternDiscovery;
      }
      _prefs.setInt(_keyLastPatternCount, patternCount);
    }

    // Priority 2: Streak reminder (only if user has a streak and hasn't logged today)
    if (streak >= 2 && !hasLoggedToday) {
      return LifecycleNotificationType.streakReminder;
    }

    // Priority 3: Insight teaser (weekly, only if 7+ entries exist)
    if (totalEntries >= 7 && now.weekday == DateTime.thursday) {
      return LifecycleNotificationType.insightTeaser;
    }

    // Priority 3.5: Share reminder (1 day after milestone)
    final lastMilestoneStr = _prefs.getString(_keyLastMilestoneDate);
    if (lastMilestoneStr != null) {
      final lastMilestone = DateTime.tryParse(lastMilestoneStr);
      if (lastMilestone != null &&
          now.difference(lastMilestone).inDays == 1) {
        return LifecycleNotificationType.shareReminder;
      }
    }

    // Priority 4: Mood check-in (gentle daily, only if logged today already)
    // Sent in the evening if user journaled in the morning
    if (hasLoggedToday) {
      final todayEntry = journalService.getTodayEntry();
      if (todayEntry != null && todayEntry.createdAt.hour < 14) {
        return LifecycleNotificationType.moodCheckIn;
      }
    }

    // Priority 5: Weekly digest (every Sunday)
    if (now.weekday == DateTime.sunday && totalEntries >= 3) {
      return LifecycleNotificationType.weeklyDigest;
    }

    // Priority 5.5: Monthly wrapped ready (1st-3rd of month)
    if (monthlyWrappedAvailable == true ||
        (now.day >= 1 && now.day <= 3 && totalEntries >= 7)) {
      return LifecycleNotificationType.monthlyWrappedReady;
    }

    // Priority 6: Wrapped ready (Dec 26 - Dec 31)
    if (now.month == 12 && now.day >= 26 && totalEntries >= 7) {
      return LifecycleNotificationType.wrappedReady;
    }

    // Priority 7: Seasonal / moon phase trigger
    final moonData = MoonPhaseService.today();
    if (moonData.phase == MoonPhase.newMoon ||
        moonData.phase == MoonPhase.fullMoon) {
      return LifecycleNotificationType.seasonalTrigger;
    }

    // Priority 7-10: Re-engagement (based on inactivity)
    if (inactivityDays >= 30) {
      return LifecycleNotificationType.reEngagement30Day;
    }
    if (inactivityDays >= 14) {
      return LifecycleNotificationType.reEngagement14Day;
    }
    if (inactivityDays >= 7) {
      return LifecycleNotificationType.reEngagement7Day;
    }
    if (inactivityDays >= 3) {
      return LifecycleNotificationType.reEngagement3Day;
    }

    return null;
  }

  /// Schedule a single notification of the given type.
  Future<void> _scheduleNotification(
    LifecycleNotificationType type,
    JournalService journalService,
  ) async {
    final content = _buildNotificationContent(type, journalService);
    if (content == null) return;

    final hour = _getDeliveryHour(type);
    final minute = 0;

    // Use the base notification service to schedule
    try {
      await _notificationService.scheduleDailyReflection(
        hour: hour,
        minute: minute,
        personalizedMessage: content.body,
      );

      await _markNotificationSent(type);

      // If milestone, mark it celebrated and record date for share reminder
      if (type == LifecycleNotificationType.milestonesCelebration) {
        final totalEntries = journalService.entryCount;
        for (final milestone in milestoneDays) {
          if (totalEntries == milestone) {
            await _celebrateMilestone(milestone);
          }
        }
        await _prefs.setString(
          _keyLastMilestoneDate,
          DateTime.now().toIso8601String(),
        );
      }

      if (kDebugMode) {
        debugPrint('NotificationLifecycle: Scheduled ${type.name} at $hour:00');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'NotificationLifecycle: Failed to schedule ${type.name}: $e',
        );
      }
    }
  }

  /// Determine the best delivery hour for a notification type.
  int _getDeliveryHour(LifecycleNotificationType type) {
    switch (type) {
      case LifecycleNotificationType.streakReminder:
        return preferredHour;
      case LifecycleNotificationType.moodCheckIn:
        return _clampToAllowedHours(19);
      case LifecycleNotificationType.insightTeaser:
        return _clampToAllowedHours(18);
      case LifecycleNotificationType.milestonesCelebration:
        return _clampToAllowedHours(10);
      case LifecycleNotificationType.challengeCompleted:
        return _clampToAllowedHours(12);
      case LifecycleNotificationType.archetypeEvolution:
        return _clampToAllowedHours(11);
      case LifecycleNotificationType.patternDiscovery:
        return _clampToAllowedHours(18);
      case LifecycleNotificationType.shareReminder:
        return _clampToAllowedHours(10);
      case LifecycleNotificationType.monthlyWrappedReady:
        return _clampToAllowedHours(10);
      case LifecycleNotificationType.seasonalTrigger:
        return _clampToAllowedHours(20);
      case LifecycleNotificationType.wrappedReady:
        return _clampToAllowedHours(11);
      case LifecycleNotificationType.weeklyDigest:
        return _clampToAllowedHours(10);
      case LifecycleNotificationType.reEngagement3Day:
      case LifecycleNotificationType.reEngagement7Day:
      case LifecycleNotificationType.reEngagement14Day:
      case LifecycleNotificationType.reEngagement30Day:
        return preferredHour;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NOTIFICATION CONTENT
  // ══════════════════════════════════════════════════════════════════════════

  /// Build the notification title and body for a given type.
  _NotificationContent? _buildNotificationContent(
    LifecycleNotificationType type,
    JournalService journalService,
  ) {
    final isEn = _isEn;
    switch (type) {
      case LifecycleNotificationType.challengeCompleted:
        return _NotificationContent(
          title: isEn ? 'Challenge Completed!' : 'Meydan Okuma Tamamlandı!',
          body: isEn
              ? 'You finished a challenge! Share your achievement with friends.'
              : 'Bir meydan okumayı tamamladın! Başarını arkadaşlarınla paylaş.',
        );

      case LifecycleNotificationType.archetypeEvolution:
        return _NotificationContent(
          title: isEn ? 'Your Archetype Shifted' : 'Arketipin Değişti',
          body: isEn
              ? 'Your monthly archetype has evolved — check out your new pattern.'
              : 'Aylık arketipin değişti — yeni örüntünü keşfet.',
        );

      case LifecycleNotificationType.patternDiscovery:
        return _NotificationContent(
          title: isEn ? 'New Pattern Found' : 'Yeni Örüntü Bulundu',
          body: isEn
              ? 'A new correlation emerged in your journal entries.'
              : 'Günlük kayıtlarında yeni bir korelasyon ortaya çıktı.',
        );

      case LifecycleNotificationType.shareReminder:
        return _NotificationContent(
          title: isEn ? 'Celebrate Your Progress' : 'İlerlemeni Kutla',
          body: isEn
              ? 'You reached a milestone recently — share it with someone who would appreciate it.'
              : 'Yakın zamanda bir başarıya ulaştın — bunu takdir edecek biriyle paylaş.',
        );

      case LifecycleNotificationType.monthlyWrappedReady:
        return _NotificationContent(
          title: isEn ? 'Monthly Wrapped Ready' : 'Aylık Özetin Hazır',
          body: isEn
              ? 'Your monthly recap is ready to review — see your patterns at a glance.'
              : 'Aylık özetin incelemeye hazır — örüntülerine bir göz at.',
        );

      case LifecycleNotificationType.streakReminder:
        final streak = journalService.getCurrentStreak();
        return _NotificationContent(
          title: isEn ? 'Your Streak is Waiting' : 'Serin Seni Bekliyor!',
          body: isEn
              ? 'Your $streak-day streak is waiting! A quick entry keeps it going.'
              : '$streak günlük seri devam ediyor! Kısa bir kayıt yeterli.',
        );

      case LifecycleNotificationType.insightTeaser:
        return _NotificationContent(
          title: isEn ? 'Something Interesting' : 'İlginç Bir Şey',
          body: isEn
              ? 'Something interesting emerged in your patterns this week...'
              : 'Bu hafta kalıplarında ilginç bir şey ortaya çıktı...',
        );

      case LifecycleNotificationType.moodCheckIn:
        return _NotificationContent(
          title: isEn ? 'Quick Check-In' : 'Hızlı Kontrol',
          body: isEn
              ? 'What\'s present for you right now? A quick check-in takes 30 seconds.'
              : 'Şu an neler hissediyorsun? Hızlı bir kontrol 30 saniye sürer.',
        );

      case LifecycleNotificationType.milestonesCelebration:
        final total = journalService.entryCount;
        return _NotificationContent(
          title: isEn ? 'Milestone Reached!' : 'Kilometre Taşı!',
          body: isEn
              ? 'You\'ve journaled $total days! Your patterns are getting really interesting.'
              : '$total gün günlük tuttun! Kalıpların gerçekten ilginçleşiyor.',
        );

      case LifecycleNotificationType.seasonalTrigger:
        final moonData = MoonPhaseService.today();
        if (moonData.phase == MoonPhase.newMoon) {
          return _NotificationContent(
            title: isEn ? 'New Moon Tonight' : 'Bu Gece Yeni Ay',
            body: isEn
                ? 'The new moon is tonight — a perfect time for reflection.'
                : 'Bu gece yeni ay — yansıtma için harika bir zaman.',
          );
        }
        if (moonData.phase == MoonPhase.fullMoon) {
          return _NotificationContent(
            title: isEn ? 'Full Moon Tonight' : 'Bu Gece Dolunay',
            body: isEn
                ? 'The full moon is tonight — a wonderful moment for gratitude.'
                : 'Bu gece dolunay — şükran için güzel bir an.',
          );
        }
        return null;

      case LifecycleNotificationType.reEngagement3Day:
        return _NotificationContent(
          title: isEn ? 'Your Journal Awaits' : 'Günlüğün Burada',
          body: isEn
              ? 'Your journal is here whenever you are ready.'
              : 'Hazır olduğunda günlüğün burada seni bekliyor.',
        );

      case LifecycleNotificationType.reEngagement7Day:
        return _NotificationContent(
          title: isEn ? 'One Sentence Counts' : 'Bir Cümle Yeter',
          body: isEn
              ? 'It\'s been a little while — even one sentence counts.'
              : 'Biraz zaman geçti — tek bir cümle bile yeterli.',
        );

      case LifecycleNotificationType.reEngagement14Day:
        return _NotificationContent(
          title: isEn ? 'Still Here For You' : 'Hâlâ Buradayız',
          body: isEn
              ? 'Your patterns are still here, ready when you are.'
              : 'Kalıpların hâlâ burada, hazır olduğunda seni bekliyor.',
        );

      case LifecycleNotificationType.reEngagement30Day:
        return _NotificationContent(
          title: isEn ? 'Welcome Back?' : 'Tekrar Hoş Geldin?',
          body: isEn
              ? 'Sometimes the best entries come after a break. Welcome back?'
              : 'Bazen en güzel kayıtlar aradan sonra gelir. Tekrar hoş geldin?',
        );

      case LifecycleNotificationType.wrappedReady:
        final year = DateTime.now().year;
        return _NotificationContent(
          title: isEn
              ? 'Your $year Wrapped is Ready!'
              : '$year Wrapped\'ın Hazır!',
          body: isEn
              ? 'See your year in patterns — your personal recap awaits.'
              : 'Yılını örüntülerle gör — kişisel özetin seni bekliyor.',
        );

      case LifecycleNotificationType.weeklyDigest:
        return _NotificationContent(
          title: isEn ? 'Weekly Reflection' : 'Haftalık Yansıtma',
          body: isEn
              ? 'Your weekly reflection is ready to review.'
              : 'Haftalık yansıtman incelemeye hazır.',
        );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CANCELLATION
  // ══════════════════════════════════════════════════════════════════════════

  /// Cancel all lifecycle-managed notifications.
  /// Currently uses the base notification service's daily reflection ID
  /// since we schedule through scheduleDailyReflection. Each evaluation
  /// cycle effectively replaces the previous lifecycle notification.
  /// The IDs in _LifecycleNotificationIds are reserved for future
  /// per-type independent scheduling.
  Future<void> cancelAllLifecycleNotifications() async {
    await _notificationService.cancelDailyReflection();

    if (kDebugMode) {
      debugPrint(
        'NotificationLifecycle: Cancelled all lifecycle notifications',
      );
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CLEANUP
  // ══════════════════════════════════════════════════════════════════════════

  /// Clear all lifecycle notification preferences.
  Future<void> clearAll() async {
    await _prefs.remove(_keyLastActivity);
    await _prefs.remove(_keyJournalingHours);
    await _prefs.remove(_keyLastNotifDate);
    await _prefs.remove(_keyLastNotifType);
    await _prefs.remove(_keyCelebratedMilestones);
    await _prefs.remove(_keyEnabled);
    await _prefs.remove(_keyLastMilestoneDate);
    await _prefs.remove(_keyLastArchetype);
    await _prefs.remove(_keyLastPatternCount);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DEBUG / STATUS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get a debug-friendly status map for the lifecycle service.
  Map<String, dynamic> getStatus() {
    return {
      'enabled': isEnabled,
      'lastActivity': lastActivityDate?.toIso8601String(),
      'daysSinceActivity': daysSinceLastActivity,
      'preferredHour': preferredHour,
      'hasNotifiedToday': hasNotifiedToday,
      'celebratedMilestones': _celebratedMilestones.toList(),
      'lastNotificationType': _prefs.getString(_keyLastNotifType),
    };
  }
}

// ════════════════════════════════════════════════════════════════════════════
// INTERNAL MODELS
// ════════════════════════════════════════════════════════════════════════════

class _NotificationContent {
  final String title;
  final String body;

  const _NotificationContent({required this.title, required this.body});
}
