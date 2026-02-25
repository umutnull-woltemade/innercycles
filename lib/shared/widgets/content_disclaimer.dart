import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/l10n_service.dart';

/// Content Disclaimer Widget
///
/// Used on all interpretation-containing pages.
/// Required for App Store compliance and legal protection.
///
/// USAGE:
/// ```dart
/// // Add to end of page (before footer)
/// ContentDisclaimer(language: language),
/// ```

class ContentDisclaimer extends StatelessWidget {
  final bool compact;
  final String? customText;
  final AppLanguage language;

  const ContentDisclaimer({
    super.key,
    this.compact = false,
    this.customText,
    this.language = AppLanguage.tr,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final text =
        customText ??
        L10nService.get('widgets.content_disclaimer.general', language);

    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: AppTypography.decorativeScript(
            fontSize: 10,
            color: isDark
                ? Colors.white54
                : AppColors.textLight.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: isDark
                ? Colors.white54
                : AppColors.textLight.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.elegantAccent(
                fontSize: 11,
                color: isDark
                    ? Colors.white38
                    : AppColors.textLight.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Category-based disclaimer texts
class DisclaimerTexts {
  static String general(AppLanguage language) =>
      L10nService.get('widgets.content_disclaimer.general', language);

  static String dreams(AppLanguage language) =>
      L10nService.get('widgets.content_disclaimer.dreams', language);

  static String health(AppLanguage language) =>
      L10nService.get('widgets.content_disclaimer.health', language);

  static String wellness(AppLanguage language) =>
      L10nService.get('widgets.content_disclaimer.general', language);

  static String compatibility(AppLanguage language) =>
      L10nService.get('widgets.content_disclaimer.compatibility', language);

  /// Apple-safe disclaimer for Insight assistant
  /// Emphasizes reflection, not prediction
  static String insight(AppLanguage language) =>
      L10nService.get('widgets.content_disclaimer.insight', language);

  /// Apple-safe reflection disclaimer
  /// Used in the unified Insight assistant
  static String reflection(AppLanguage language) =>
      L10nService.get('widgets.content_disclaimer.reflection', language);
}

/// Page footer with disclaimer
class PageFooterWithDisclaimer extends StatelessWidget {
  final String brandText; // "Dream Trace — InnerCycles"
  final String? disclaimerText;
  final bool showDisclaimer;
  final AppLanguage language;

  const PageFooterWithDisclaimer({
    super.key,
    required this.brandText,
    this.disclaimerText,
    this.showDisclaimer = true,
    this.language = AppLanguage.tr,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        if (showDisclaimer) ...[
          ContentDisclaimer(
            compact: true,
            customText: disclaimerText,
            language: language,
          ),
          const SizedBox(height: 8),
        ],
        Center(
          child: Text(
            brandText,
            style: AppTypography.elegantAccent(
              fontSize: 12,
              letterSpacing: 1.0,
              color: isDark ? Colors.white38 : AppColors.textLight,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
