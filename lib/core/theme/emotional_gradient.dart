// ============================================================================
// EMOTIONAL GRADIENT ENGINE - Dynamic mood-based color gradients
// ============================================================================
// Maps mood values (1.0-5.0) to HSL-based gradient palettes using the
// existing AppColors token system. Includes seasonal tone shifts.
// ============================================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

class EmotionalGradient {
  EmotionalGradient._();

  /// Generate a gradient color list based on mood value (1.0-5.0).
  ///
  /// - 1.0-2.0 → Deep warm/brown (introspective)
  /// - 2.0-3.0 → Warm amber/sunset (transitional)
  /// - 3.0-4.0 → Soft terracotta/caramel (balanced)
  /// - 4.0-5.0 → Warm peach/sunrise (energized)
  static List<Color> emotionalGradient(double moodValue) {
    final mood = moodValue.clamp(1.0, 5.0);

    if (mood <= 2.0) {
      // Introspective: deep warm → brown
      final t = (mood - 1.0); // 0.0 → 1.0
      return [
        Color.lerp(AppColors.deepSpace, AppColors.nebulaPurple, t)!,
        Color.lerp(AppColors.amethyst, AppColors.celestialGold, t)!,
        Color.lerp(AppColors.nebulaPurple, AppColors.twilightEnd, t)!,
      ];
    } else if (mood <= 3.0) {
      // Transitional: warm amber → sunset
      final t = (mood - 2.0); // 0.0 → 1.0
      return [
        Color.lerp(AppColors.nebulaPurple, AppColors.deepAmber, t)!,
        Color.lerp(AppColors.amethyst, AppColors.celestialGold, t)!,
        Color.lerp(AppColors.twilightEnd, AppColors.warmCrimson, t)!,
      ];
    } else if (mood <= 4.0) {
      // Balanced: soft gold → aurora
      final t = (mood - 3.0); // 0.0 → 1.0
      return [
        Color.lerp(AppColors.deepAmber, AppColors.auroraStart, t)!,
        Color.lerp(AppColors.celestialGold, AppColors.starGold, t)!,
        Color.lerp(AppColors.warmCrimson, AppColors.auroraEnd, t)!,
      ];
    } else {
      // Energized: bright rose → sunrise
      final t = (mood - 4.0); // 0.0 → 1.0
      return [
        Color.lerp(AppColors.auroraStart, AppColors.sunriseStart, t)!,
        Color.lerp(AppColors.starGold, AppColors.sunriseEnd, t)!,
        Color.lerp(AppColors.auroraEnd, AppColors.sunriseStart, t)!,
      ];
    }
  }

  /// Seasonal gradient tone shift based on month (1-12).
  ///
  /// - Winter (Dec-Feb): warm charcoal/brown
  /// - Spring (Mar-May): aurora green/gold
  /// - Summer (Jun-Aug): warm sunrise/gold
  /// - Autumn (Sep-Nov): amber/crimson
  static List<Color> seasonalGradient(int month) {
    final m = month.clamp(1, 12);

    if (m == 12 || m <= 2) {
      // Winter — warm, reflective
      return [
        AppColors.deepSpace,
        AppColors.twilightStart,
        AppColors.twilightEnd,
      ];
    } else if (m <= 5) {
      // Spring — fresh, awakening
      return [AppColors.auroraStart, AppColors.success, AppColors.auroraEnd];
    } else if (m <= 8) {
      // Summer — warm, energized
      return [AppColors.sunriseStart, AppColors.starGold, AppColors.sunriseEnd];
    } else {
      // Autumn — amber, grounding
      return [
        AppColors.deepAmber,
        AppColors.celestialGold,
        AppColors.warmCrimson,
      ];
    }
  }

  /// Blend emotional and seasonal gradients (70% mood, 30% season).
  static List<Color> blendedGradient({
    required double moodValue,
    DateTime? dateTime,
  }) {
    final mood = emotionalGradient(moodValue);
    final season = seasonalGradient((dateTime ?? DateTime.now()).month);

    return List.generate(mood.length, (i) {
      return Color.lerp(mood[i], season[i], 0.3)!;
    });
  }
}
