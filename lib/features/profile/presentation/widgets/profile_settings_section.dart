// ════════════════════════════════════════════════════════════════════════════
// PROFILE SETTINGS SECTION - Premium upsell + settings rows
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

class ProfileSettingsSection extends StatelessWidget {
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;
  final bool isPremium;

  const ProfileSettingsSection({
    super.key,
    required this.isDark,
    required this.language,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('profile.profile_settings.settings', language),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        GlassPanel(
          elevation: GlassElevation.g2,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Premium upsell banner
              if (!isPremium) ...[
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: PremiumCard(
                    style: PremiumCardStyle.gold,
                    padding: const EdgeInsets.all(AppConstants.spacingLg),
                    child: Column(
                      children: [
                        GradientText(
                          L10nService.get('profile.profile_settings.unlock_full_potential', language),
                          variant: GradientTextVariant.gold,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        GradientButton.gold(
                          label: L10nService.get('profile.profile_settings.go_premium', language),
                          expanded: true,
                          onPressed: () => context.push(Routes.premium),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildDivider(),
              ],

              // Setting rows
              _SettingRow(
                emoji: '\u{1F514}',
                label: L10nService.get('profile.profile_settings.notifications', language),
                isDark: isDark,
                onTap: () => context.push(Routes.notifications),
              ),
              _buildDivider(),
              _SettingRow(
                emoji: '\u{2699}\u{FE0F}',
                label: L10nService.get('profile.profile_settings.settings_1', language),
                isDark: isDark,
                onTap: () => context.push(Routes.settings),
              ),
              _buildDivider(),
              _SettingRow(
                emoji: '\u{1F4E4}',
                label: L10nService.get('profile.profile_settings.export_data', language),
                isDark: isDark,
                onTap: () => context.push(Routes.exportData),
              ),
              _buildDivider(),
              _SettingRow(
                emoji: '\u{1F464}',
                label: L10nService.get('profile.profile_settings.edit_profile', language),
                isDark: isDark,
                onTap: () => context.push(Routes.profile),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      height: 0.5,
      color: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _SettingRow({
    required this.emoji,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd + 2,
          ),
          child: Row(
            children: [
              AppSymbol(emoji, size: AppSymbolSize.sm),
              const SizedBox(width: AppConstants.spacingLg),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppColors.textSecondary.withValues(alpha: 0.4)
                    : AppColors.lightTextMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
