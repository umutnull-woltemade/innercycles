import 'package:flutter/material.dart';

/// Accessibility helpers for iOS HIG compliance.
///
/// Checks system accessibility settings and provides guards
/// for animations, text scaling, and contrast.
class AccessibilityUtils {
  AccessibilityUtils._();

  /// Returns true if the user has enabled "Reduce Motion" in iOS settings.
  /// When true, all non-essential animations should be disabled.
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Returns true if the user has enabled "Bold Text" in iOS settings.
  static bool shouldBoldText(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }

  /// Returns true if the user has enabled "Increase Contrast" in iOS settings.
  static bool shouldIncreaseContrast(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Returns the current text scale factor.
  /// 1.0 = default, up to 3.5 for accessibility XXL.
  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Returns Duration.zero if reduce motion is enabled,
  /// otherwise returns the provided duration.
  static Duration animationDuration(BuildContext context, Duration duration) {
    return shouldReduceMotion(context) ? Duration.zero : duration;
  }
}

/// Extension on Widget to conditionally apply flutter_animate animations
/// based on the reduce motion accessibility setting.
///
/// Usage:
///   myWidget.accessibleAnimate(context)?.fadeIn(duration: 300.ms) ?? myWidget
///
/// Or use the guard pattern:
///   if (!AccessibilityUtils.shouldReduceMotion(context)) {
///     widget = widget.animate().fadeIn();
///   }
