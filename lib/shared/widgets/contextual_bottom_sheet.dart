import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/liquid_glass/glass_tokens.dart';
import '../../data/services/haptic_service.dart';
import 'gradient_text.dart';

/// A single action row in the context menu.
class ContextAction {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const ContextAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  /// Share preset.
  factory ContextAction.share({VoidCallback? onTap}) => ContextAction(
        icon: Icons.share_outlined,
        label: 'Share',
        onTap: onTap,
      );

  /// Copy preset.
  factory ContextAction.copy({VoidCallback? onTap}) => ContextAction(
        icon: Icons.copy_outlined,
        label: 'Copy',
        onTap: onTap,
      );

  /// Edit preset.
  factory ContextAction.edit({VoidCallback? onTap}) => ContextAction(
        icon: Icons.edit_outlined,
        label: 'Edit',
        onTap: onTap,
      );

  /// Delete preset.
  factory ContextAction.delete({VoidCallback? onTap}) => ContextAction(
        icon: Icons.delete_outline_rounded,
        label: 'Delete',
        onTap: onTap,
        isDestructive: true,
      );

  /// Pin preset.
  factory ContextAction.pin({VoidCallback? onTap}) => ContextAction(
        icon: Icons.push_pin_outlined,
        label: 'Pin',
        onTap: onTap,
      );

  /// Make private preset.
  factory ContextAction.makePrivate({VoidCallback? onTap}) => ContextAction(
        icon: Icons.lock_outline_rounded,
        label: 'Make Private',
        onTap: onTap,
      );
}

/// Long-press context menu rendered as a glass bottom sheet.
///
/// Usage:
///   ContextualBottomSheet.show(
///     context,
///     title: 'Journal Entry',
///     actions: [
///       ContextAction.edit(onTap: () => editEntry()),
///       ContextAction.share(onTap: () => shareEntry()),
///       ContextAction.delete(onTap: () => deleteEntry()),
///     ],
///   );
class ContextualBottomSheet extends StatelessWidget {
  final String title;
  final List<ContextAction> actions;

  const ContextualBottomSheet({
    super.key,
    required this.title,
    required this.actions,
  });

  /// Show the contextual bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<ContextAction> actions,
  }) {
    HapticService.sheetOpened();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ContextualBottomSheet(
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      container: true,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(GlassTokens.radiusXl),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: GlassTokens.g4Blur,
            sigmaY: GlassTokens.g4Blur,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? AppColors.surfaceDark : AppColors.lightSurface)
                  .withValues(alpha: isDark ? 0.92 : 0.96),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(GlassTokens.radiusXl),
              ),
              border: Border(
                top: BorderSide(
                  width: 1.5,
                  color: AppColors.starGold.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  // Drag handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GradientText(
                        title,
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Actions
                  ...List.generate(actions.length, (i) {
                    final action = actions[i];
                    final isLast = i == actions.length - 1;
                    return _ActionRow(
                      action: action,
                      isDark: isDark,
                      showDivider: !isLast,
                      index: i,
                    );
                  }),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      )
          .animate()
          .slideY(
            begin: 0.3,
            end: 0,
            duration: 300.ms,
            curve: Curves.easeOutCubic,
          )
          .fadeIn(duration: 300.ms),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final ContextAction action;
  final bool isDark;
  final bool showDivider;
  final int index;

  const _ActionRow({
    required this.action,
    required this.isDark,
    required this.showDivider,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = action.isDestructive
        ? AppColors.error
        : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary);
    final iconColor = action.isDestructive
        ? AppColors.error
        : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary);

    return Semantics(
      button: true,
      label: action.label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (action.isDestructive) {
                  HapticService.error();
                } else {
                  HapticService.selectionTap();
                }
                Navigator.pop(context);
                action.onTap?.call();
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 52),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Icon(action.icon, color: iconColor, size: 22),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        action.label,
                        style: AppTypography.subtitle(
                          fontSize: 15,
                          color: textColor,
                        ).copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showDivider)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.starGold.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 200.ms,
          delay: Duration(milliseconds: 40 * index),
        )
        .slideX(
          begin: 0.05,
          end: 0,
          duration: 200.ms,
          delay: Duration(milliseconds: 40 * index),
          curve: Curves.easeOutCubic,
        );
  }
}
