import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// GoRouter-compatible page transition factories for the InnerCycles app.
///
/// All transitions check `disableAnimations` and fall back to instant
/// MaterialPage when reduced motion is enabled.
///
/// Usage in router:
///   GoRoute(
///     path: '/entry/:id',
///     pageBuilder: (context, state) => PageTransitions.cardDetail(
///       child: EntryDetailScreen(entryId: state.pathParameters['id']!),
///       key: state.pageKey,
///     ),
///   )
class PageTransitions {
  PageTransitions._();

  /// Standard push: fade + subtle slideY (0.03).
  /// Best for most screen transitions.
  static Page<void> fadeSlide({
    required Widget child,
    LocalKey? key,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.of(context).disableAnimations) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Scale modal: scale(0.92→1.0) + fade.
  /// Best for premium, vault, paywall screens.
  static Page<void> scaleModal({
    required Widget child,
    LocalKey? key,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.of(context).disableAnimations) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Card detail: scale(0.95→1.0) + fade.
  /// Best for entry detail, birthday detail, note detail screens.
  static Page<void> cardDetail({
    required Widget child,
    LocalKey? key,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.of(context).disableAnimations) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Slide up: slideY(1.0→0.0) + fade.
  /// Best for bottom sheet style screens (breathing, meditation, export).
  static Page<void> slideUp({
    required Widget child,
    LocalKey? key,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (MediaQuery.of(context).disableAnimations) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1.0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
