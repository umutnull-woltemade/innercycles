import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/storage_service.dart';
import 'gradient_text.dart';

/// iOS-native SliverAppBar with frosted glass backdrop blur.
///
/// Replaces all transparent SliverAppBars to prevent content
/// bleeding behind the status bar / Dynamic Island.
///
/// Features:
/// - BackdropFilter blur (sigma 10) matching iOS .ultraThinMaterial
/// - 0.33pt bottom separator (retina hairline)
/// - iOS-standard chevron_left back button (28pt)
/// - Large title collapse support
/// - Optional gradient title via [useGradientTitle]
class GlassSliverAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool largeTitleMode;
  final Color? titleColor;
  final bool useGradientTitle;
  final GradientTextVariant gradientVariant;

  const GlassSliverAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.largeTitleMode = false,
    this.titleColor,
    this.useGradientTitle = false,
    this.gradientVariant = GradientTextVariant.aurora,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTitleColor = titleColor ?? AppColors.starGold;
    final backColor = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;

    if (largeTitleMode) {
      return SliverAppBar(
        pinned: true,
        expandedHeight: 96,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: showBackButton && Navigator.of(context).canPop()
            ? _buildBackButton(context, backColor)
            : null,
        actions: actions,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.5),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.1),
                    width: 0.33,
                  ),
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(
                  start: 16,
                  bottom: 14,
                ),
                title: useGradientTitle
                    ? GradientText(
                        title,
                        variant: gradientVariant,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      )
                    : Text(
                        title,
                        style: TextStyle(
                          color: effectiveTitleColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                collapseMode: CollapseMode.pin,
              ),
            ),
          ),
        ),
      );
    }

    // Standard inline title with blur
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBackButton && Navigator.of(context).canPop()
          ? _buildBackButton(context, backColor)
          : null,
      title: useGradientTitle
          ? GradientText(
              title,
              variant: gradientVariant,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            )
          : Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: effectiveTitleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: actions,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.5),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.black.withValues(alpha: 0.1),
                  width: 0.33,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, Color color) {
    final isEn = StorageService.loadLanguage() == AppLanguage.en;
    return Semantics(
      label: isEn ? 'Back' : 'Geri',
      button: true,
      child: IconButton(
        tooltip: isEn ? 'Back' : 'Geri',
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.chevron_left, color: color, size: 28),
      ),
    );
  }
}
