import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/services/referral_service.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

class ProfileReferralSection extends ConsumerWidget {
  final bool isDark;
  final bool isEn;

  const ProfileReferralSection({
    super.key,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referralAsync = ref.watch(referralServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          L10nService.get('profile.profile_referral.invite_earn', isEn ? AppLanguage.en : AppLanguage.tr),
          variant: GradientTextVariant.gold,
          style: AppTypography.elegantAccent(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Semantics(
          button: true,
          label: L10nService.get('profile.profile_referral.open_referral_program', isEn ? AppLanguage.en : AppLanguage.tr),
          child: GestureDetector(
            onTap: () => context.push(Routes.referralProgram),
            behavior: HitTestBehavior.opaque,
            child: PremiumCard(
              style: PremiumCardStyle.gold,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const AppSymbol('\u{1F381}', size: AppSymbolSize.md),
                  const SizedBox(width: AppConstants.spacingLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          L10nService.get('profile.profile_referral.invite_friends_get_premium', isEn ? AppLanguage.en : AppLanguage.tr),
                          style: AppTypography.subtitle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        referralAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                          data: (service) {
                            final count = service.referralCount;
                            return Text(
                              count > 0
                                  ? (isEn
                                      ? '$count friend${count == 1 ? '' : 's'} invited'
                                      : '$count arkadaş davet edildi')
                                  : (L10nService.get('profile.profile_referral.7_days_free_for_each_friend', isEn ? AppLanguage.en : AppLanguage.tr)),
                              style: AppTypography.subtitle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            );
                          },
                        ),
                      ],
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
        ),
      ],
    );
  }
}
