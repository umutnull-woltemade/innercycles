// ════════════════════════════════════════════════════════════════════════════
// DAILY HOOK SERVICE - InnerCycles Engagement & Notification Hooks
// ════════════════════════════════════════════════════════════════════════════
// Generates engaging daily hook messages that drive app opens.
// Integrates with NotificationService for delivery. Uses SharedPreferences
// for persistence of shown hooks and category engagement tracking.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════════════════════
// ENUMS
// ════════════════════════════════════════════════════════════════════════════

enum HookCategory {
  morning,
  reflection,
  mindfulness,
  focus,
  mood,
  dream,
  growth,
  pattern,
  achievement,
  social,
  archetype,
}

enum HookTimeSlot {
  morning,
  afternoon,
  evening,
  midweek,
  friday,
  sunday,
  monthEnd,
  anytime,
}

// ════════════════════════════════════════════════════════════════════════════
// DAILY HOOK MODEL
// ════════════════════════════════════════════════════════════════════════════

class DailyHook {
  final int id;
  final String titleEn;
  final String titleTr;
  final HookCategory category;
  final HookTimeSlot timeSlot;

  const DailyHook({
    required this.id,
    required this.titleEn,
    required this.titleTr,
    required this.category,
    required this.timeSlot,
  });

  /// Get localized title based on language preference
  String getTitle({bool isEnglish = true}) => isEnglish ? titleEn : titleTr;
}

// ════════════════════════════════════════════════════════════════════════════
// DAILY HOOK SERVICE
// ════════════════════════════════════════════════════════════════════════════

class DailyHookService {
  static const String _shownHooksKey = 'daily_hook_shown_ids';
  static const String _shownHooksTimestampKey = 'daily_hook_shown_timestamps';
  static const String _categoryEngagementKey = 'daily_hook_category_engagement';
  static const String _lastHookDateKey = 'daily_hook_last_date';

  final SharedPreferences _prefs;
  final Random _random = Random();

  DailyHookService._(this._prefs);

  /// Initialize the daily hook service
  static Future<DailyHookService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return DailyHookService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HOOK TEMPLATES (30 hooks)
  // ══════════════════════════════════════════════════════════════════════════

  static const List<DailyHook> _hooks = [
    DailyHook(
      id: 1,
      titleEn: 'Your energy outlook for today',
      titleTr: 'Bugünkü enerji görünümün',
      category: HookCategory.morning,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 2,
      titleEn: 'One thing to notice about yourself today',
      titleTr: 'Bugün kendinde fark edeceğin bir şey',
      category: HookCategory.reflection,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 3,
      titleEn: 'Your mindfulness check-in',
      titleTr: 'Farkındalık kontrolün',
      category: HookCategory.mindfulness,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 4,
      titleEn: "Today's focus area spotlight",
      titleTr: 'Bugünkü odak alanın',
      category: HookCategory.focus,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 5,
      titleEn: 'Your emotional weather check',
      titleTr: 'Duygusal hava durumun',
      category: HookCategory.mood,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 6,
      titleEn: 'Dream insight of the day',
      titleTr: 'Günün rüya içgörüsü',
      category: HookCategory.dream,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 7,
      titleEn: 'Your daily growth challenge',
      titleTr: 'Günlük büyüme meydan okuman',
      category: HookCategory.growth,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 8,
      titleEn: 'Pattern alert: something shifted',
      titleTr: 'Örüntü uyarısı: bir şey değişti',
      category: HookCategory.pattern,
      timeSlot: HookTimeSlot.anytime,
    ),
    DailyHook(
      id: 9,
      titleEn: 'Your evening reflection prompt',
      titleTr: 'Akşam yansıma sorun',
      category: HookCategory.reflection,
      timeSlot: HookTimeSlot.evening,
    ),
    DailyHook(
      id: 10,
      titleEn: "This week's theme emerging",
      titleTr: 'Bu haftanın teması beliriyor',
      category: HookCategory.pattern,
      timeSlot: HookTimeSlot.midweek,
    ),
    DailyHook(
      id: 11,
      titleEn: 'Your streak milestone',
      titleTr: 'Seri kilometre taşın',
      category: HookCategory.achievement,
      timeSlot: HookTimeSlot.anytime,
    ),
    DailyHook(
      id: 12,
      titleEn: 'Someone with your pattern noticed...',
      titleTr: 'Senin örüntünde biri fark etti...',
      category: HookCategory.social,
      timeSlot: HookTimeSlot.afternoon,
    ),
    DailyHook(
      id: 13,
      titleEn: 'Your forgotten dream clue',
      titleTr: 'Unuttuğun rüya ipucu',
      category: HookCategory.dream,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 14,
      titleEn: "Today's journaling spark",
      titleTr: 'Bugünkü günlük kıvılcımı',
      category: HookCategory.reflection,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 15,
      titleEn: 'Your inner cycle check-in',
      titleTr: 'İç döngü kontrolün',
      category: HookCategory.mood,
      timeSlot: HookTimeSlot.afternoon,
    ),
    DailyHook(
      id: 16,
      titleEn: 'Midday mindfulness check-in',
      titleTr: 'Öğle farkındalık kontrolü',
      category: HookCategory.mindfulness,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 17,
      titleEn: 'Evening intention setting',
      titleTr: 'Akşam niyet belirleme',
      category: HookCategory.mindfulness,
      timeSlot: HookTimeSlot.evening,
    ),
    DailyHook(
      id: 18,
      titleEn: 'Evening release ritual',
      titleTr: 'Akşam bırakma ritüeli',
      category: HookCategory.mindfulness,
      timeSlot: HookTimeSlot.evening,
    ),
    DailyHook(
      id: 19,
      titleEn: 'Your decision clarity score today',
      titleTr: 'Bugünkü karar netliği puanın',
      category: HookCategory.focus,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 20,
      titleEn: 'Energy vs. mood mismatch alert',
      titleTr: 'Enerji-ruh hali uyumsuzluk uyarısı',
      category: HookCategory.pattern,
      timeSlot: HookTimeSlot.afternoon,
    ),
    DailyHook(
      id: 21,
      titleEn: 'Your social battery check',
      titleTr: 'Sosyal batarya kontrolün',
      category: HookCategory.social,
      timeSlot: HookTimeSlot.afternoon,
    ),
    DailyHook(
      id: 22,
      titleEn: 'Gratitude micro-moment',
      titleTr: 'Şükran mikro-anı',
      category: HookCategory.reflection,
      timeSlot: HookTimeSlot.evening,
    ),
    DailyHook(
      id: 23,
      titleEn: "Today's archetype energy",
      titleTr: 'Bugünkü arketip enerjin',
      category: HookCategory.archetype,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 24,
      titleEn: 'Your sleep-dream connection',
      titleTr: 'Uyku-rüya bağlantın',
      category: HookCategory.dream,
      timeSlot: HookTimeSlot.morning,
    ),
    DailyHook(
      id: 25,
      titleEn: 'Midweek emotional reset',
      titleTr: 'Hafta ortası duygusal sıfırlama',
      category: HookCategory.mood,
      timeSlot: HookTimeSlot.midweek,
    ),
    DailyHook(
      id: 26,
      titleEn: 'Friday self-check: how was your week?',
      titleTr: 'Cuma kontrolü: haftan nasıldı?',
      category: HookCategory.reflection,
      timeSlot: HookTimeSlot.friday,
    ),
    DailyHook(
      id: 27,
      titleEn: 'Sunday intention seed',
      titleTr: 'Pazar niyet tohumu',
      category: HookCategory.reflection,
      timeSlot: HookTimeSlot.sunday,
    ),
    DailyHook(
      id: 28,
      titleEn: 'Your emotional courage moment',
      titleTr: 'Duygusal cesaret anın',
      category: HookCategory.growth,
      timeSlot: HookTimeSlot.anytime,
    ),
    DailyHook(
      id: 29,
      titleEn: 'Pattern breakthrough moment',
      titleTr: 'Örüntü kırılma anı',
      category: HookCategory.achievement,
      timeSlot: HookTimeSlot.anytime,
    ),
    DailyHook(
      id: 30,
      titleEn: 'Your monthly emotional summary preview',
      titleTr: 'Aylık duygusal özet önizlemen',
      category: HookCategory.pattern,
      timeSlot: HookTimeSlot.monthEnd,
    ),
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // HOOK SELECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Select the best hook for today, avoiding repeats within 7 days.
  /// Uses day-of-week context, time-of-day context, and category engagement.
  DailyHook getHookForToday({bool isEnglish = true}) {
    final now = DateTime.now();
    final candidates = _getCandidatesForContext(now);
    final recentlyShown = _getRecentlyShownIds();

    // Filter out hooks shown within the last 7 days
    var available = candidates
        .where((h) => !recentlyShown.contains(h.id))
        .toList();

    // If all candidates were recently shown, fall back to full candidates list
    if (available.isEmpty) {
      available = candidates;
    }

    // Prefer hooks from categories the user engages with most
    final engagementScores = _getCategoryEngagement();
    if (engagementScores.isNotEmpty) {
      available.sort((a, b) {
        final scoreA = engagementScores[a.category.name] ?? 0;
        final scoreB = engagementScores[b.category.name] ?? 0;
        return scoreB.compareTo(scoreA);
      });

      // Take top half weighted by engagement, then pick randomly
      final topCount = max(1, available.length ~/ 2);
      available = available.take(topCount).toList();
    }

    // Random pick from remaining candidates
    final hook = available[_random.nextInt(available.length)];
    return hook;
  }

  /// Get a morning-appropriate hook text
  String getMorningHook({bool isEnglish = true}) {
    final now = DateTime.now();
    final morningHooks = _hooks
        .where(
          (h) =>
              h.timeSlot == HookTimeSlot.morning ||
              h.timeSlot == HookTimeSlot.anytime,
        )
        .toList();

    final recentlyShown = _getRecentlyShownIds();
    var available = morningHooks
        .where((h) => !recentlyShown.contains(h.id))
        .toList();

    if (available.isEmpty) {
      available = morningHooks;
    }

    // Check day-of-week overrides
    final daySpecific = _getDaySpecificHooks(now.weekday);
    if (daySpecific.isNotEmpty) {
      final dayAvailable = daySpecific
          .where((h) => !recentlyShown.contains(h.id))
          .toList();
      if (dayAvailable.isNotEmpty) {
        available = dayAvailable;
      }
    }

    final hook = available[_random.nextInt(available.length)];
    return hook.getTitle(isEnglish: isEnglish);
  }

  /// Get an evening-appropriate hook text
  String getEveningHook({bool isEnglish = true}) {
    final eveningHooks = _hooks
        .where(
          (h) =>
              h.timeSlot == HookTimeSlot.evening ||
              h.timeSlot == HookTimeSlot.anytime,
        )
        .toList();

    final recentlyShown = _getRecentlyShownIds();
    var available = eveningHooks
        .where((h) => !recentlyShown.contains(h.id))
        .toList();

    if (available.isEmpty) {
      available = eveningHooks;
    }

    final hook = available[_random.nextInt(available.length)];
    return hook.getTitle(isEnglish: isEnglish);
  }

  /// Get all hooks belonging to a specific category
  List<DailyHook> getHooksByCategory(HookCategory category) {
    return _hooks.where((h) => h.category == category).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  /// Mark a hook as shown to avoid repeating within 7 days
  Future<void> markHookShown(int hookId) async {
    final shownIds = _prefs.getStringList(_shownHooksKey) ?? [];
    final timestamps = _prefs.getStringList(_shownHooksTimestampKey) ?? [];

    shownIds.add(hookId.toString());
    timestamps.add(DateTime.now().toIso8601String());

    await _prefs.setStringList(_shownHooksKey, shownIds);
    await _prefs.setStringList(_shownHooksTimestampKey, timestamps);

    // Update last hook date
    await _prefs.setString(_lastHookDateKey, DateTime.now().toIso8601String());

    // Track category engagement
    final hook = _hooks.firstWhere(
      (h) => h.id == hookId,
      orElse: () => _hooks.first,
    );
    await _incrementCategoryEngagement(hook.category);
  }

  /// Increment engagement count for a category
  Future<void> _incrementCategoryEngagement(HookCategory category) async {
    final engagement = _getCategoryEngagement();
    engagement[category.name] = (engagement[category.name] ?? 0) + 1;
    await _prefs.setString(_categoryEngagementKey, json.encode(engagement));
  }

  /// Track that the user tapped/opened from a specific category
  Future<void> trackCategoryEngagement(HookCategory category) async {
    await _incrementCategoryEngagement(category);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CONTEXT-AWARE SELECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Get candidate hooks based on current date/time context
  List<DailyHook> _getCandidatesForContext(DateTime now) {
    final hour = now.hour;
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final dayOfMonth = now.day;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final candidates = <DailyHook>[];

    for (final hook in _hooks) {
      switch (hook.timeSlot) {
        case HookTimeSlot.morning:
          if (hour < 12) candidates.add(hook);
          break;
        case HookTimeSlot.afternoon:
          if (hour >= 12 && hour < 18) candidates.add(hook);
          break;
        case HookTimeSlot.evening:
          if (hour >= 18) candidates.add(hook);
          break;
        case HookTimeSlot.midweek:
          // Wednesday (3) or Thursday (4)
          if (weekday == DateTime.wednesday || weekday == DateTime.thursday) {
            candidates.add(hook);
          }
          break;
        case HookTimeSlot.friday:
          if (weekday == DateTime.friday) candidates.add(hook);
          break;
        case HookTimeSlot.sunday:
          if (weekday == DateTime.sunday) candidates.add(hook);
          break;
        case HookTimeSlot.monthEnd:
          // Last 3 days of the month
          if (dayOfMonth >= daysInMonth - 2) candidates.add(hook);
          break;
        case HookTimeSlot.anytime:
          candidates.add(hook);
          break;
      }
    }

    // If no context-specific hooks matched, fall back to anytime hooks
    if (candidates.isEmpty) {
      candidates.addAll(
        _hooks.where((h) => h.timeSlot == HookTimeSlot.anytime),
      );
    }

    return candidates;
  }

  /// Get hooks specific to a day of the week
  List<DailyHook> _getDaySpecificHooks(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        // Monday: prefer morning/growth hooks for a fresh start
        return _hooks
            .where(
              (h) =>
                  h.category == HookCategory.growth ||
                  h.category == HookCategory.focus,
            )
            .toList();
      case DateTime.wednesday:
        // Midweek: prefer midweek time slot
        return _hooks.where((h) => h.timeSlot == HookTimeSlot.midweek).toList();
      case DateTime.friday:
        // Friday: prefer friday time slot
        return _hooks.where((h) => h.timeSlot == HookTimeSlot.friday).toList();
      case DateTime.sunday:
        // Sunday: prefer sunday time slot and reflection
        return _hooks
            .where(
              (h) =>
                  h.timeSlot == HookTimeSlot.sunday ||
                  h.category == HookCategory.reflection,
            )
            .toList();
      default:
        return [];
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get hook IDs shown within the last 7 days
  Set<int> _getRecentlyShownIds() {
    final shownIds = _prefs.getStringList(_shownHooksKey) ?? [];
    final timestamps = _prefs.getStringList(_shownHooksTimestampKey) ?? [];

    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final recentIds = <int>{};

    for (int i = 0; i < shownIds.length && i < timestamps.length; i++) {
      try {
        final shownAt = DateTime.parse(timestamps[i]);
        if (shownAt.isAfter(cutoff)) {
          final id = int.tryParse(shownIds[i]);
          if (id != null) recentIds.add(id);
        }
      } catch (_) {
        // Skip malformed entries
      }
    }

    return recentIds;
  }

  /// Get category engagement scores from SharedPreferences
  Map<String, int> _getCategoryEngagement() {
    final engagementJson = _prefs.getString(_categoryEngagementKey);
    if (engagementJson == null) return {};

    try {
      final decoded = json.decode(engagementJson) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {
      return {};
    }
  }

  /// Clean up old shown-hook entries (older than 30 days)
  Future<void> cleanUpOldEntries() async {
    final shownIds = _prefs.getStringList(_shownHooksKey) ?? [];
    final timestamps = _prefs.getStringList(_shownHooksTimestampKey) ?? [];

    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    final newIds = <String>[];
    final newTimestamps = <String>[];

    for (int i = 0; i < shownIds.length && i < timestamps.length; i++) {
      try {
        final shownAt = DateTime.parse(timestamps[i]);
        if (shownAt.isAfter(cutoff)) {
          newIds.add(shownIds[i]);
          newTimestamps.add(timestamps[i]);
        }
      } catch (_) {
        // Drop malformed entries
      }
    }

    await _prefs.setStringList(_shownHooksKey, newIds);
    await _prefs.setStringList(_shownHooksTimestampKey, newTimestamps);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // UTILITY
  // ══════════════════════════════════════════════════════════════════════════

  /// Get all available hooks (useful for settings/preview screens)
  List<DailyHook> getAllHooks() => List.unmodifiable(_hooks);

  /// Get the total number of hook templates
  int get hookCount => _hooks.length;

  /// Check if a hook has been shown today already
  bool hasShownHookToday() {
    final lastDateStr = _prefs.getString(_lastHookDateKey);
    if (lastDateStr == null) return false;

    try {
      final lastDate = DateTime.parse(lastDateStr);
      final now = DateTime.now();
      return lastDate.year == now.year &&
          lastDate.month == now.month &&
          lastDate.day == now.day;
    } catch (_) {
      return false;
    }
  }

  /// Clear all hook tracking data
  Future<void> clearAll() async {
    await _prefs.remove(_shownHooksKey);
    await _prefs.remove(_shownHooksTimestampKey);
    await _prefs.remove(_categoryEngagementKey);
    await _prefs.remove(_lastHookDateKey);
  }
}
