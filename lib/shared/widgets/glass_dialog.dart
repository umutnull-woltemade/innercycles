// ============================================================================
// GLASS DIALOG - Premium glass-morphism dialog replacement for AlertDialog
// ============================================================================
// Wraps content in BackdropFilter blur + gradient accent top border +
// glass surface. Use GlassDialog.show() for simple confirmation dialogs.
// ============================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import 'gradient_text.dart';

/// A premium glass-morphism dialog with backdrop blur, gradient accent border,
/// and gradient title text.
class GlassDialog extends StatelessWidget {
  final String title;
  final String? content;
  final GradientTextVariant gradientVariant;
  final List<Widget> actions;

  const GlassDialog({
    super.key,
    required this.title,
    this.content,
    this.gradientVariant = GradientTextVariant.aurora,
    this.actions = const [],
  });

  /// Show a standard confirmation dialog with glass styling.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String cancelLabel,
    required String confirmLabel,
    GradientTextVariant gradientVariant = GradientTextVariant.aurora,
    bool isDestructive = false,
    VoidCallback? onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => GlassDialog(
        title: title,
        content: message,
        gradientVariant: gradientVariant,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelLabel,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(context, true);
            },
            child: Text(
              confirmLabel,
              style: TextStyle(
                color: isDestructive ? AppColors.error : AppColors.auroraStart,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _accentFromVariant(gradientVariant);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? AppColors.surfaceDark : AppColors.lightSurface)
                  .withValues(alpha: isDark ? 0.82 : 0.90),
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              border: Border(
                top: BorderSide(
                  color: accentColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  title,
                  variant: gradientVariant,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (content != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    content!,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
                if (actions.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Color _accentFromVariant(GradientTextVariant variant) {
    switch (variant) {
      case GradientTextVariant.aurora:
        return AppColors.auroraStart;
      case GradientTextVariant.gold:
        return AppColors.starGold;
      case GradientTextVariant.amethyst:
        return AppColors.amethyst;
      case GradientTextVariant.cosmic:
        return AppColors.cosmic;
    }
  }
}
