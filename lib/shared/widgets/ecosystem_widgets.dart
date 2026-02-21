// ════════════════════════════════════════════════════════════════════════════
// ECOSYSTEM WIDGETS - Shared UI components for InnerCycles ecosystem
// ════════════════════════════════════════════════════════════════════════════
// ToolEmptyState - Empty state with progress + demo CTA
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

// ═══════════════════════════════════════════════════════════════════════════
// TOOL EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class ToolEmptyState extends StatelessWidget {
  final IconData icon;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final int currentEntries;
  final int requiredEntries;
  final VoidCallback? onSeeExample;
  final VoidCallback? onStartTemplate;
  final bool isEn;
  final bool isDark;

  const ToolEmptyState({
    super.key,
    required this.icon,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    this.currentEntries = 0,
    this.requiredEntries = 0,
    this.onSeeExample,
    this.onStartTemplate,
    required this.isEn,
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
                isEn ? titleEn : titleTr,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                isEn ? descriptionEn : descriptionTr,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
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
                        style: TextStyle(
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onStartTemplate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.auroraStart,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                      ),
                    ),
                    child: Text(
                      isEn ? 'Start with Template' : 'Sablonla Basla',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              if (onSeeExample != null) ...[
                const SizedBox(height: AppConstants.spacingSm),
                TextButton(
                  onPressed: onSeeExample,
                  child: Text(
                    isEn ? 'See Example' : 'Ornek Gor',
                    style: TextStyle(
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
