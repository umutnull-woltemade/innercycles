// ════════════════════════════════════════════════════════════════════════════
// REFERRAL PROGRESS CARD - Compact Share-to-Earn Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/premium_service.dart';

class ReferralProgressCard extends ConsumerWidget {
  const ReferralProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = ref.watch(isPremiumUserProvider);
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;

    // Don't show for premium users
    if (isPremium) return const SizedBox.shrink();

    final referralAsync = ref.watch(referralServiceProvider);

    return referralAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final status = service.getStatus(language);

        // Don't show if trial expired (already shown in settings)
        if (status.isExpired) return const SizedBox.shrink();

        // Show active trial banner
        if (status.isUnlocked) {
          return _ActiveTrialBanner(status: status, isDark: isDark, isEn: isEn)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.06, duration: 400.ms);
        }

        // Show share progress card
        return Semantics(
              button: true,
              label: isEn
                  ? 'Share & Unlock Premium'
                  : 'Payla\u015f ve Premium A\u00e7',
              child: GestureDetector(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  final unlocked = await service.shareApp(language: language);
                  if (unlocked && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEn
                              ? 'Premium trial unlocked for 7 days!'
                              : 'Premium deneme 7 gün için açıldı!',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  ref.invalidate(referralServiceProvider);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.celestialGold.withValues(alpha: 0.12),
                              AppColors.surfaceDark.withValues(alpha: 0.9),
                            ]
                          : [
                              AppColors.celestialGold.withValues(alpha: 0.06),
                              AppColors.lightCard,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.celestialGold.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.celestialGold.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.card_giftcard_rounded,
                              color: AppColors.celestialGold,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              status.headline,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          // Share count dots
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              final filled = i < service.shareCount;
                              return Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: filled
                                        ? AppColors.celestialGold
                                        : (isDark
                                              ? Colors.white.withValues(
                                                  alpha: 0.1,
                                                )
                                              : Colors.black.withValues(
                                                  alpha: 0.08,
                                                )),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: status.progress,
                          minHeight: 4,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.06),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.celestialGold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Bottom row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              status.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                          Text(
                            isEn ? 'Tap to share' : 'Paylaşmak için dokun',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.celestialGold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.06, duration: 400.ms);
      },
    );
  }
}

class _ActiveTrialBanner extends StatelessWidget {
  final dynamic status;
  final bool isDark;
  final bool isEn;

  const _ActiveTrialBanner({
    required this.status,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.success.withValues(alpha: 0.12),
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                ]
              : [
                  AppColors.success.withValues(alpha: 0.06),
                  AppColors.lightCard,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.success,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.headline,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  status.subtitle,
                  style: TextStyle(fontSize: 11, color: AppColors.success),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
