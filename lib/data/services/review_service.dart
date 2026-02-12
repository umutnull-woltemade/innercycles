// ════════════════════════════════════════════════════════════════════════════
// REVIEW SERVICE - InnerCycles App Store Review Prompting
// ════════════════════════════════════════════════════════════════════════════
// Tracks optimal moments to request App Store reviews using in_app_review.
// Respects rate limits (max 1 prompt per 90 days) and triggers reviews
// at high-engagement moments: streaks, pattern discoveries, and milestones.
// ════════════════════════════════════════════════════════════════════════════

import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════════════════════
// REVIEW TRIGGER ENUM
// ════════════════════════════════════════════════════════════════════════════

/// Moments that can trigger a review prompt
enum ReviewTrigger {
  /// User reached a 7-day journal streak
  streakMilestone,

  /// First pattern discovered (requires 7+ journal entries)
  patternDiscovered,

  /// First dream interpretation (requires 3+ dream entries)
  dreamInterpretation,

  /// Completed the attachment style quiz
  quizCompleted,

  /// Viewed a monthly report
  monthlyReport,
}

// ════════════════════════════════════════════════════════════════════════════
// REVIEW SERVICE
// ════════════════════════════════════════════════════════════════════════════

class ReviewService {
  static const String _lastPromptDateKey = 'review_last_prompt_date';
  static const String _totalPromptsShownKey = 'review_total_prompts_shown';
  static const String _hasReviewedKey = 'review_has_reviewed';
  static const String _triggersUsedKey = 'review_triggers_used';

  /// Minimum days between review prompts
  static const int _cooldownDays = 90;

  /// Minimum journal entries before pattern-based trigger
  static const int _minEntriesForPattern = 7;

  /// Minimum dream entries before dream interpretation trigger
  static const int _minDreamEntries = 3;

  /// Minimum streak days for streak milestone trigger
  static const int _minStreakDays = 7;

  final SharedPreferences _prefs;
  final InAppReview _inAppReview;

  ReviewService._(this._prefs, this._inAppReview);

  /// Initialize the review service
  static Future<ReviewService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final inAppReview = InAppReview.instance;
    return ReviewService._(prefs, inAppReview);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE ACCESSORS
  // ══════════════════════════════════════════════════════════════════════════

  /// Get the date of the last review prompt shown
  DateTime? get lastPromptDate {
    final millis = _prefs.getInt(_lastPromptDateKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Get total number of review prompts shown
  int get totalPromptsShown => _prefs.getInt(_totalPromptsShownKey) ?? 0;

  /// Whether the user has already reviewed the app
  bool get hasReviewed => _prefs.getBool(_hasReviewedKey) ?? false;

  /// Get the set of triggers that have already been used
  Set<String> get _triggersUsed {
    final list = _prefs.getStringList(_triggersUsedKey);
    return list?.toSet() ?? {};
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REVIEW PROMPT LOGIC
  // ══════════════════════════════════════════════════════════════════════════

  /// Check conditions and prompt for review if appropriate.
  ///
  /// [trigger] - The event that triggered this check.
  /// [currentStreak] - Current journal streak in days (for streakMilestone).
  /// [journalEntryCount] - Total journal entries (for patternDiscovered).
  /// [dreamEntryCount] - Total dream entries (for dreamInterpretation).
  ///
  /// Returns `true` if a review prompt was shown, `false` otherwise.
  Future<bool> checkAndPromptReview(
    ReviewTrigger trigger, {
    int currentStreak = 0,
    int journalEntryCount = 0,
    int dreamEntryCount = 0,
  }) async {
    // Never prompt if user has already reviewed
    if (hasReviewed) return false;

    // Check cooldown period
    if (!_isCooldownExpired()) return false;

    // Check if this specific trigger was already used
    if (_triggersUsed.contains(trigger.name)) return false;

    // Validate trigger-specific conditions
    if (!_isTriggerValid(
      trigger,
      currentStreak: currentStreak,
      journalEntryCount: journalEntryCount,
      dreamEntryCount: dreamEntryCount,
    )) {
      return false;
    }

    // All conditions met - attempt to show review
    return await _requestReview(trigger);
  }

  /// Validate whether a trigger's specific requirements are met.
  bool _isTriggerValid(
    ReviewTrigger trigger, {
    required int currentStreak,
    required int journalEntryCount,
    required int dreamEntryCount,
  }) {
    switch (trigger) {
      case ReviewTrigger.streakMilestone:
        return currentStreak >= _minStreakDays;
      case ReviewTrigger.patternDiscovered:
        return journalEntryCount >= _minEntriesForPattern;
      case ReviewTrigger.dreamInterpretation:
        return dreamEntryCount >= _minDreamEntries;
      case ReviewTrigger.quizCompleted:
        // Quiz completion is always valid when triggered
        return true;
      case ReviewTrigger.monthlyReport:
        // Monthly report is always valid when triggered
        return true;
    }
  }

  /// Check if the cooldown period (90 days) has expired.
  bool _isCooldownExpired() {
    final last = lastPromptDate;
    if (last == null) return true;
    final daysSinceLastPrompt = DateTime.now().difference(last).inDays;
    return daysSinceLastPrompt >= _cooldownDays;
  }

  /// Request the in-app review and persist the prompt state.
  Future<bool> _requestReview(ReviewTrigger trigger) async {
    final isAvailable = await _inAppReview.isAvailable();
    if (!isAvailable) return false;

    await _inAppReview.requestReview();
    await _recordPromptShown(trigger);
    return true;
  }

  /// Record that a review prompt was shown.
  Future<void> _recordPromptShown(ReviewTrigger trigger) async {
    await _prefs.setInt(
      _lastPromptDateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    await _prefs.setInt(_totalPromptsShownKey, totalPromptsShown + 1);

    final used = _triggersUsed;
    used.add(trigger.name);
    await _prefs.setStringList(_triggersUsedKey, used.toList());
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MANUAL STATE MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  /// Mark that the user has reviewed the app.
  /// Call this if you detect the user left a review through other means.
  Future<void> markAsReviewed() async {
    await _prefs.setBool(_hasReviewedKey, true);
  }

  /// Reset all review tracking data.
  /// Useful for testing or if the user requests a fresh start.
  Future<void> resetAll() async {
    await _prefs.remove(_lastPromptDateKey);
    await _prefs.remove(_totalPromptsShownKey);
    await _prefs.remove(_hasReviewedKey);
    await _prefs.remove(_triggersUsedKey);
  }

  /// Check if a specific trigger has already been used.
  bool isTriggerUsed(ReviewTrigger trigger) {
    return _triggersUsed.contains(trigger.name);
  }

  /// Get the number of days remaining in the cooldown period.
  /// Returns 0 if cooldown has expired.
  int get cooldownDaysRemaining {
    final last = lastPromptDate;
    if (last == null) return 0;
    final daysSince = DateTime.now().difference(last).inDays;
    final remaining = _cooldownDays - daysSince;
    return remaining > 0 ? remaining : 0;
  }
}
