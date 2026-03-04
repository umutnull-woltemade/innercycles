import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../data/services/referral_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class ReferralInviteCard extends ConsumerWidget {
  final AppLanguage language;
  final bool isDark;

  const ReferralInviteCard({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(referralServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        final code = service.myCode;
        if (code.isEmpty) return const SizedBox.shrink();

        final info = service.info;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.gold,
            borderRadius: 16,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard_rounded,
                      size: 18,
                      color: AppColors.starGold,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'Invite Friends, Get Premium'
                            : 'Arkadaşlarını Davet Et, Premium Kazan',
                        style: AppTypography.modernAccent(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isEn
                      ? 'Share your code and both get 7 days of Premium free!'
                      : 'Kodunu paylaş, ikisi de 7 gün Premium kazansın!',
                  style: AppTypography.subtitle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Code display
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDark
                              ? AppColors.surfaceDark
                              : AppColors.lightSurfaceVariant,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                code,
                                style: AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.0,
                                  color: AppColors.starGold,
                                ),
                              ),
                            ),
                            TapScale(
                              onTap: () {
                                HapticService.selectionTap();
                                Clipboard.setData(ClipboardData(text: code));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isEn ? 'Code copied!' : 'Kod kopyalandı!',
                                    ),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.copy_rounded,
                                size: 16,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Share button
                    TapScale(
                      onTap: () {
                        HapticService.buttonPress();
                        SharePlus.instance.share(ShareParams(text: service.shareText(language: language)));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.starGold,
                              AppColors.celestialGold,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.share_rounded,
                              size: 14,
                              color: AppColors.deepSpace,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isEn ? 'Share' : 'Paylaş',
                              style: AppTypography.modernAccent(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepSpace,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (info.referralCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    isEn
                        ? '${info.referralCount} friend${info.referralCount > 1 ? 's' : ''} joined'
                        : '${info.referralCount} arkadaş katıldı',
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: AppColors.starGold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(delay: 550.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
