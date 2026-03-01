import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

/// "Love InnerCycles?" rate-us card for profile hub.
/// Triggers native App Store review dialog via in_app_review.
class ProfileRateSection extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  final int totalEntries;

  const ProfileRateSection({
    super.key,
    required this.isDark,
    required this.isEn,
    required this.totalEntries,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    // Only show after meaningful engagement (5+ entries)
    if (totalEntries < 5) return const SizedBox.shrink();

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  AppColors.starGold.withValues(alpha: 0.15),
                  AppColors.celestialGold.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: const Center(
              child: Text('\u2B50', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  L10nService.get('profile.profile_rate.enjoying_innercycles', language),
                  variant: GradientTextVariant.gold,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  L10nService.get('profile.profile_rate.a_quick_rating_helps_us_grow', language),
                  style: AppTypography.subtitle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();
              final inAppReview = InAppReview.instance;
              if (await inAppReview.isAvailable()) {
                await inAppReview.requestReview();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppColors.starGold,
                    AppColors.celestialGold,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.starGold.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                L10nService.get('profile.profile_rate.rate', language),
                style: AppTypography.elegantAccent(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepSpace,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
