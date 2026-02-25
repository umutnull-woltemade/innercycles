// ════════════════════════════════════════════════════════════════════════════
// PROGRAM COMPLETION SCREEN - Celebration & Certificate View
// ════════════════════════════════════════════════════════════════════════════
// Shown when a user completes a guided program. Displays a celebratory
// certificate with program details and navigation to continue the journey.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';

class ProgramCompletionScreen extends ConsumerWidget {
  final String programTitle;
  final String programEmoji;
  final int durationDays;
  final int completedDays;

  const ProgramCompletionScreen({
    super.key,
    required this.programTitle,
    required this.programEmoji,
    required this.durationDays,
    required this.completedDays,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXl,
              vertical: AppConstants.spacingLg,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppConstants.spacingHuge),

                // ═══════════════════════════════════════════════════
                // CELEBRATORY HEADER
                // ═══════════════════════════════════════════════════

                // Gold sparkle accent above emoji
                Icon(
                  Icons.auto_awesome,
                  size: 28,
                  color: AppColors.starGold.withValues(alpha: 0.7),
                ),
                const SizedBox(height: AppConstants.spacingSm),

                // Large program emoji
                AppSymbol(programEmoji, size: AppSymbolSize.xxl),
                const SizedBox(height: AppConstants.spacingXl),

                // Congratulations heading in gold
                GradientText(
                  isEn ? 'Congratulations!' : 'Tebrikler!',
                  variant: GradientTextVariant.gold,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Subtitle
                Text(
                  isEn
                      ? 'You completed $programTitle'
                      : '$programTitle tamamlandı',
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitle(
                    fontSize: 17,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXxl),

                // ═══════════════════════════════════════════════════
                // CERTIFICATE CARD (GlassPanel G3)
                // ═══════════════════════════════════════════════════
                GlassPanel(
                  elevation: GlassElevation.g3,
                  glowColor: AppColors.starGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingXl,
                    vertical: AppConstants.spacingXxl,
                  ),
                  child: Column(
                    children: [
                      // Certificate icon
                      Icon(
                        Icons.workspace_premium_rounded,
                        size: 40,
                        color: AppColors.starGold,
                      ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // Certificate title
                      GradientText(
                        isEn
                            ? 'Certificate of Completion'
                            : 'Tamamlama Sertifikası',
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Divider
                      Container(
                        width: 60,
                        height: 1,
                        color: AppColors.starGold.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Program name
                      GradientText(
                        programTitle,
                        variant: GradientTextVariant.aurora,
                        textAlign: TextAlign.center,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // Duration completed
                      _CertificateRow(
                        icon: Icons.calendar_today_rounded,
                        label: isEn ? 'Duration' : 'Süre',
                        value:
                            '$durationDays ${isEn ? 'days of reflection' : 'günlük yansıma'}',
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Days completed count
                      _CertificateRow(
                        icon: Icons.check_circle_rounded,
                        label: isEn ? 'Days Completed' : 'Tamamlanan Günler',
                        value: '$completedDays / $durationDays',
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Date of completion
                      _CertificateRow(
                        icon: Icons.today_rounded,
                        label: isEn ? 'Completed On' : 'Tamamlanma Tarihi',
                        value: _formatDate(DateTime.now(), isEn),
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Divider
                      Container(
                        width: 60,
                        height: 1,
                        color: AppColors.starGold.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // Motivational note
                      Text(
                        isEn
                            ? 'Every day of reflection is a step toward deeper self-understanding.'
                            : 'Her yansıma günü, kendinizi daha derinden anlamaya doğru atılan bir adımdır.',
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXxl),

                // ═══════════════════════════════════════════════════
                // ACTION BUTTONS
                // ═══════════════════════════════════════════════════

                // Start Another Program button
                GradientButton.gold(
                  label: isEn
                      ? 'Start Another Program'
                      : 'Başka Bir Program Başlat',
                  onPressed: () => context.go(Routes.programs),
                  expanded: true,
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Back to Home button
                GradientOutlinedButton(
                  label: isEn ? 'Back to Home' : 'Ana Sayfaya Dön',
                  variant: GradientTextVariant.aurora,
                  expanded: true,
                  fontSize: 16,
                  borderRadius: AppConstants.radiusMd,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  onPressed: () => context.go(Routes.today),
                ),
                const SizedBox(height: AppConstants.spacingHuge),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date, bool isEn) {
    final months = isEn
        ? [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ]
        : [
            'Ocak',
            'Şubat',
            'Mart',
            'Nisan',
            'Mayıs',
            'Haziran',
            'Temmuz',
            'Ağustos',
            'Eylül',
            'Ekim',
            'Kasım',
            'Aralık',
          ];
    final month = months[date.month - 1];
    return isEn
        ? '$month ${date.day}, ${date.year}'
        : '${date.day} $month ${date.year}';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CERTIFICATE ROW - Detail line inside the certificate card
// ═══════════════════════════════════════════════════════════════════════════

class _CertificateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _CertificateRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.auroraStart),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
