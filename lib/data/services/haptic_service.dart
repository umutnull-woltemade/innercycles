import 'package:flutter/services.dart';

/// Centralized haptic feedback service with mapped patterns for all interactions.
///
/// Usage:
///   HapticService.entryCompleted();
///   HapticService.moodSelected();
///   HapticService.error();
class HapticService {
  HapticService._();

  // ── Core Feedback Types ──────────────────────────────────────────────

  /// Light tap — mood selection, toggle, radio
  static Future<void> selectionTap() async {
    await HapticFeedback.selectionClick();
  }

  /// Entry saved, streak achieved, milestone
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
  }

  /// Validation error, rejected prompt, failed save
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
  }

  /// Warning state, approaching limit
  static Future<void> warning() async {
    await HapticFeedback.lightImpact();
  }

  // ── Interaction-Specific Patterns ────────────────────────────────────

  /// User selects a mood or focus area
  static Future<void> moodSelected() => selectionTap();

  /// Sub-rating slider changed
  static Future<void> ratingChanged() => selectionTap();

  /// Journal entry completed and saved
  static Future<void> entryCompleted() => success();

  /// Dream logged
  static Future<void> dreamLogged() => success();

  /// Streak milestone reached
  static Future<void> streakMilestone() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.lightImpact();
  }

  /// Pattern discovered (aha moment)
  static Future<void> patternDiscovered() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
  }

  /// Swipe action (archive, delete)
  static Future<void> swipeAction() async {
    await HapticFeedback.lightImpact();
  }

  /// Button press — primary CTA
  static Future<void> buttonPress() async {
    await HapticFeedback.lightImpact();
  }

  /// Tab switched in bottom nav
  static Future<void> tabChanged() => selectionTap();

  /// Modal/sheet opened
  static Future<void> sheetOpened() async {
    await HapticFeedback.lightImpact();
  }

  /// Feature unlocked via progressive reveal
  static Future<void> featureUnlocked() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// Calendar date selected
  static Future<void> dateSelected() => selectionTap();

  /// Breathing exercise phase change
  static Future<void> breathingPhase() async {
    await HapticFeedback.lightImpact();
  }

  /// Export completed
  static Future<void> exportCompleted() => success();

  /// Cycle phase changed
  static Future<void> cyclePhaseChanged() async {
    await HapticFeedback.mediumImpact();
  }

  // ── Widget Library Patterns ────────────────────────────────────────

  /// Toggle switched (CupertinoSwitch, checkbox)
  static Future<void> toggleChanged() => selectionTap();

  /// Long press registered
  static Future<void> longPress() async {
    await HapticFeedback.mediumImpact();
  }

  /// Swipe threshold crossed (dismissible hit point)
  static Future<void> swipeThreshold() async {
    await HapticFeedback.lightImpact();
  }

  /// Toast notification appeared
  static Future<void> toastAppeared() async {
    await HapticFeedback.lightImpact();
  }

  /// Scroll-to-top activated
  static Future<void> scrollToTop() async {
    await HapticFeedback.lightImpact();
  }

  // ── Bond / Touch Patterns ────────────────────────────────────────

  /// Touch received — warm pulse
  static Future<void> touchReceivedWarm() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// Touch sent — confirmation tap
  static Future<void> touchSent() async {
    await HapticFeedback.mediumImpact();
  }

  /// Bond formed — celebratory pattern
  static Future<void> bondFormed() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }
}
