import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'glass_tokens.dart';

/// Liquid Glass animation presets using flutter_animate extensions.
///
/// All animations respect the iOS "Reduce Motion" accessibility setting.
/// When reduced motion is enabled, looping animations are skipped entirely
/// and entrance animations use instant crossfade only.
///
/// Usage:
///   MyWidget().glassEntrance(context: context)
///   MyWidget().glassFloat(context: context)
///   MyWidget().glassPulse(context: context)
extension GlassAnimations on Widget {
  /// Fade + slide up entrance with glass timing.
  /// Falls back to instant fade when reduced motion is on.
  Widget glassEntrance({
    BuildContext? context,
    Duration? delay,
    Duration? duration,
  }) {
    if (context != null && MediaQuery.of(context).disableAnimations) {
      return this;
    }
    return animate(
      delay: delay ?? Duration.zero,
    )
        .fadeIn(
          duration: duration ?? GlassTokens.normalDuration,
          curve: GlassTokens.defaultCurve,
        )
        .slideY(
          begin: 0.05,
          end: 0,
          duration: duration ?? GlassTokens.normalDuration,
          curve: GlassTokens.entranceCurve,
        );
  }

  /// Gentle floating animation (looping).
  /// Completely skipped when reduced motion is on.
  Widget glassFloat({
    BuildContext? context,
    Duration? duration,
    double offset = 4,
  }) {
    if (context != null && MediaQuery.of(context).disableAnimations) {
      return this;
    }
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).moveY(
      begin: 0,
      end: -offset,
      duration: duration ?? const Duration(milliseconds: 2500),
      curve: Curves.easeInOut,
    );
  }

  /// Subtle scale pulse (looping).
  /// Completely skipped when reduced motion is on.
  Widget glassPulse({
    BuildContext? context,
    Duration? duration,
    double scale = 1.02,
  }) {
    if (context != null && MediaQuery.of(context).disableAnimations) {
      return this;
    }
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scale(
      begin: const Offset(1.0, 1.0),
      end: Offset(scale, scale),
      duration: duration ?? const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
    );
  }

  /// Reveal from opacity 0 with scale.
  /// Falls back to no animation when reduced motion is on.
  Widget glassReveal({
    BuildContext? context,
    Duration? delay,
    Duration? duration,
  }) {
    if (context != null && MediaQuery.of(context).disableAnimations) {
      return this;
    }
    return animate(
      delay: delay ?? Duration.zero,
    )
        .fadeIn(
          duration: duration ?? GlassTokens.slowDuration,
          curve: GlassTokens.defaultCurve,
        )
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: duration ?? GlassTokens.slowDuration,
          curve: GlassTokens.entranceCurve,
        );
  }

  /// Shimmer effect across the widget.
  /// Completely skipped when reduced motion is on.
  Widget glassShimmer({
    BuildContext? context,
    Duration? duration,
    Color? color,
  }) {
    if (context != null && MediaQuery.of(context).disableAnimations) {
      return this;
    }
    return animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: duration ?? const Duration(milliseconds: 2000),
      color: color ?? GlassTokens.starGold.withValues(alpha: 0.3),
    );
  }

  /// Staggered list item entrance.
  /// Falls back to no animation when reduced motion is on.
  Widget glassListItem({
    BuildContext? context,
    required int index,
    Duration? staggerDelay,
  }) {
    if (context != null && MediaQuery.of(context).disableAnimations) {
      return this;
    }
    final delay = (staggerDelay ?? const Duration(milliseconds: 50)) * index;
    return glassEntrance(delay: delay);
  }
}
