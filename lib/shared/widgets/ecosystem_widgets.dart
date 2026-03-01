// ════════════════════════════════════════════════════════════════════════════
// ECOSYSTEM WIDGETS - Shared UI components for InnerCycles ecosystem
// ════════════════════════════════════════════════════════════════════════════
// ToolEmptyState - Empty state with progress + demo CTA
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_typography.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../data/services/l10n_service.dart';
import '../../data/providers/app_providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// TOOL EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class ToolEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int currentEntries;
  final int requiredEntries;
  final VoidCallback? onSeeExample;
  final VoidCallback? onStartTemplate;
  final AppLanguage language;
  final bool isDark;

  const ToolEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.currentEntries = 0,
    this.requiredEntries = 0,
    this.onSeeExample,
    this.onStartTemplate,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress = requiredEntries > 0
        ? (currentEntries / requiredEntries).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: isDark
                    ? AppColors.textMuted.withValues(alpha: 0.4)
                    : AppColors.lightTextMuted.withValues(alpha: 0.4),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTypography.decorativeScript(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              if (requiredEntries > 0) ...[
                const SizedBox(height: AppConstants.spacingLg),
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.06),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.auroraStart,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$currentEntries / $requiredEntries',
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppConstants.spacingXl),
              if (onStartTemplate != null)
                GradientButton(
                  label: L10nService.get('shared.ecosystems.start_with_template', language),
                  onPressed: onStartTemplate,
                  expanded: true,
                  gradient: const LinearGradient(
                    colors: [AppColors.auroraStart, AppColors.auroraEnd],
                  ),
                ),
              if (onSeeExample != null) ...[
                const SizedBox(height: AppConstants.spacingSm),
                TextButton(
                  onPressed: onSeeExample,
                  child: Text(
                    L10nService.get('shared.ecosystems.see_example', language),
                    style: AppTypography.elegantAccent(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.05, duration: 500.ms, curve: Curves.easeOut);
  }
}
