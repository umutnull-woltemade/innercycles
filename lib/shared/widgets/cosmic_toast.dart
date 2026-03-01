import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/liquid_glass/glass_tokens.dart';
import '../../data/services/haptic_service.dart';

/// Toast notification type determines accent color and haptic.
enum CosmicToastType { success, info, warning, error }

/// Themed SnackBar replacement using OverlayEntry for top-of-screen
/// glass notifications.
///
/// Usage:
///   CosmicToast.show(context, message: 'Saved!', type: CosmicToastType.success);
///   CosmicToast.success(context, 'Entry saved');
///   CosmicToast.error(context, 'Something went wrong');
class CosmicToast {
  CosmicToast._();

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  /// Show a toast notification.
  static void show(
    BuildContext context, {
    required String message,
    CosmicToastType type = CosmicToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    dismiss();

    final overlay = Overlay.of(context);
    final mediaQuery = MediaQuery.of(context);

    _currentEntry = OverlayEntry(
      builder: (_) => _CosmicToastWidget(
        message: message,
        type: type,
        actionLabel: actionLabel,
        onAction: onAction,
        topPadding: mediaQuery.padding.top,
        onDismiss: dismiss,
      ),
    );

    overlay.insert(_currentEntry!);

    // Haptic by type
    switch (type) {
      case CosmicToastType.success:
        HapticService.success();
      case CosmicToastType.warning:
        HapticService.warning();
      case CosmicToastType.error:
        HapticService.error();
      case CosmicToastType.info:
        HapticService.toastAppeared();
    }

    _dismissTimer = Timer(duration, dismiss);
  }

  /// Convenience: success toast.
  static void success(BuildContext context, String message) =>
      show(context, message: message, type: CosmicToastType.success);

  /// Convenience: error toast.
  static void error(BuildContext context, String message) =>
      show(context, message: message, type: CosmicToastType.error);

  /// Convenience: warning toast.
  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: CosmicToastType.warning);

  /// Convenience: info toast.
  static void info(BuildContext context, String message) =>
      show(context, message: message, type: CosmicToastType.info);

  /// Dismiss the current toast.
  static void dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _CosmicToastWidget extends StatelessWidget {
  final String message;
  final CosmicToastType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double topPadding;
  final VoidCallback onDismiss;

  const _CosmicToastWidget({
    required this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
    required this.topPadding,
    required this.onDismiss,
  });

  Color get _accentColor {
    switch (type) {
      case CosmicToastType.success:
        return AppColors.success;
      case CosmicToastType.info:
        return AppColors.auroraStart;
      case CosmicToastType.warning:
        return AppColors.warning;
      case CosmicToastType.error:
        return AppColors.error;
    }
  }

  IconData get _icon {
    switch (type) {
      case CosmicToastType.success:
        return Icons.check_circle_outline_rounded;
      case CosmicToastType.info:
        return Icons.info_outline_rounded;
      case CosmicToastType.warning:
        return Icons.warning_amber_rounded;
      case CosmicToastType.error:
        return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      top: topPadding + 8,
      left: 16,
      right: 16,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
            onDismiss();
          }
        },
        child: Semantics(
          liveRegion: true,
          label: message,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(GlassTokens.radiusMd),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: GlassTokens.g3Blur,
                  sigmaY: GlassTokens.g3Blur,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.surfaceDark : AppColors.lightSurface)
                        .withValues(alpha: isDark ? 0.88 : 0.94),
                    borderRadius: BorderRadius.circular(GlassTokens.radiusMd),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.08),
                      width: 0.33,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Left accent bar
                        Container(
                          width: 3,
                          decoration: BoxDecoration(
                            color: _accentColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _icon,
                                  color: _accentColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    message,
                                    style: AppTypography.subtitle(
                                      fontSize: 14,
                                      color: isDark
                                          ? AppColors.textPrimary
                                          : AppColors.lightTextPrimary,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (actionLabel != null) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      onAction?.call();
                                      onDismiss();
                                    },
                                    child: Text(
                                      actionLabel!,
                                      style: AppTypography.subtitle(
                                        fontSize: 14,
                                        color: _accentColor,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
            .animate()
            .slideY(
              begin: -1.0,
              end: 0,
              duration: 350.ms,
              curve: Curves.easeOutCubic,
            )
            .fadeIn(duration: 350.ms),
      ),
    );
  }
}
