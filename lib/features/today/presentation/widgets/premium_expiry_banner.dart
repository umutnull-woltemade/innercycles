// ════════════════════════════════════════════════════════════════════════════
// PREMIUM EXPIRY BANNER - Nudge renewal when subscription is expiring soon
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/services/premium_service.dart';
import '../../../../shared/widgets/tap_scale.dart';

class PremiumExpiryBanner extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const PremiumExpiryBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumProvider);

    // Only show for premium users with a non-lifetime expiry within 3 days
    if (!premiumState.isPremium ||
        premiumState.isLifetime ||
        premiumState.expiryDate == null) {
      return const SizedBox.shrink();
    }

    final daysUntilExpiry =
        premiumState.expiryDate!.difference(DateTime.now()).inDays;

    if (daysUntilExpiry > 3 || daysUntilExpiry < 0) {
      return const SizedBox.shrink();
    }

    final isLastDay = daysUntilExpiry <= 1;
    final accentColor = isLastDay ? AppColors.error : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: TapScale(
        onTap: () {
          // Open subscription management
          ref.read(premiumProvider.notifier).presentCustomerCenter();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                accentColor.withValues(alpha: isDark ? 0.05 : 0.03),
              ],
            ),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Icon(
                    isLastDay
                        ? Icons.warning_amber_rounded
                        : Icons.schedule_rounded,
                    size: 20,
                    color: accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLastDay
                          ? (isEn
                              ? 'Premium expires today'
                              : 'Premium bugün bitiyor')
                          : (isEn
                              ? 'Premium expires in $daysUntilExpiry days'
                              : 'Premium $daysUntilExpiry gün sonra bitiyor'),
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isEn
                          ? 'Renew to keep your patterns & AI insights'
                          : 'Örüntülerini ve AI içgörülerini korumak için yenile',
                      style: AppTypography.subtitle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: accentColor.withValues(alpha: 0.15),
                ),
                child: Text(
                  isEn ? 'Renew' : 'Yenile',
                  style: AppTypography.elegantAccent(
                    fontSize: 12,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.08, duration: 300.ms);
  }
}
