// ════════════════════════════════════════════════════════════════════════════
// PROFILE VAULT SECTION - Private Vault + App Lock
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../data/services/l10n_service.dart';

class ProfileVaultSection extends ConsumerWidget {
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const ProfileVaultSection({
    super.key,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('profile.profile_vault.vault_security', language),
          variant: GradientTextVariant.amethyst,
          style: AppTypography.elegantAccent(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        PremiumCard(
          style: PremiumCardStyle.amethyst,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Private Vault
              _VaultRow(
                emoji: '\u{1F510}',
                label: L10nService.get('profile.profile_vault.private_vault', language),
                isDark: isDark,
                onTap: () => _navigateToVault(context, ref),
              ),
              // Gradient divider
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLg,
                ),
                height: 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.amethyst.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // App Lock
              _VaultRow(
                emoji: '\u{1F512}',
                label: L10nService.get('profile.profile_vault.app_lock', language),
                isDark: isDark,
                onTap: () => context.push(Routes.appLock),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToVault(BuildContext context, WidgetRef ref) async {
    final vaultService = await ref.read(vaultServiceProvider.future);
    if (!context.mounted) return;
    if (vaultService.isVaultSetUp) {
      context.push(Routes.vaultPin);
    } else {
      context.push(Routes.vaultPin, extra: {'mode': 'setup'});
    }
  }
}

class _VaultRow extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _VaultRow({
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
