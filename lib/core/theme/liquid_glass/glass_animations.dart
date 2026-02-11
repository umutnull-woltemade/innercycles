import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'glass_tokens.dart';

/// Liquid Glass animation presets using flutter_animate extensions.
///
/// Usage:
///   MyWidget().glassEntrance()
///   MyWidget().glassFloat()
///   MyWidget().glassPulse()
extension GlassAnimations on Widget {
  /// Fade + slide up entrance with glass timing
  Widget glassEntrance({
    Duration? delay,
    Duration? duration,
  }) {
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

  /// Gentle floating animation (looping)
  Widget glassFloat({
    Duration? duration,
    double offset = 4,
  }) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).moveY(
      begin: 0,
      end: -offset,
      duration: duration ?? const Duration(milliseconds: 2500),
      curve: Curves.easeInOut,
    );
  }

  /// Subtle scale pulse (looping)
  Widget glassPulse({
    Duration? duration,
    double scale = 1.02,
  }) {
    return animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scale(
      begin: const Offset(1.0, 1.0),
      end: Offset(scale, scale),
      duration: duration ?? const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
    );
  }

  /// Reveal from opacity 0 with scale
  Widget glassReveal({
    Duration? delay,
    Duration? duration,
  }) {
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

  /// Shimmer effect across the widget
  Widget glassShimmer({
    Duration? duration,
    Color? color,
  }) {
    return animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: duration ?? const Duration(milliseconds: 2000),
      color: color ?? GlassTokens.starGold.withValues(alpha: 0.3),
    );
  }

  /// Staggered list item entrance
  Widget glassListItem({
    required int index,
    Duration? staggerDelay,
  }) {
    final delay = (staggerDelay ?? const Duration(milliseconds: 50)) * index;
    return glassEntrance(delay: delay);
  }
}
