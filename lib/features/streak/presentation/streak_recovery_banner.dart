// ════════════════════════════════════════════════════════════════════════════
// STREAK RECOVERY BANNER - Re-engage users who missed a day
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/premium_service.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

class StreakRecoveryBanner extends ConsumerWidget {
  const StreakRecoveryBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final streakAsync = ref.watch(streakStatsProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return streakAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) {
        // Only show when streak was broken (had streak > 3 but current = 0)
        final currentStreak = stats.currentStreak;
        final longestStreak = stats.longestStreak;

        if (currentStreak > 0 || longestStreak < 3) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: isEn ? 'Start a new streak' : 'Yeni seri başlat',
              button: true,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(Routes.journal);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: isPremium ? 16 : 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.warning.withValues(alpha: 0.15),
                              AppColors.surfaceDark.withValues(alpha: 0.9),
                            ]
                          : [
                              AppColors.warning.withValues(alpha: 0.08),
                              AppColors.lightCard,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.warning.withValues(alpha: 0.2),
                        ),
                        child: const Center(
                          child: Text('🔥', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEn
                                  ? 'Your $longestStreak-day streak ended'
                                  : '$longestStreak günlük seri sona erdi',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isEn
                                  ? 'One entry to start a new one'
                                  : 'Yeni bir seri başlatmak için bir kayıt yeterli',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.warning.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),

            // Streak freeze upsell for non-premium users
            if (!isPremium)
              Semantics(
                label: isEn ? 'Access streak freeze' : 'Seri dondurmaya eriş',
                button: true,
                child: GestureDetector(
                  onTap: () => showContextualPaywall(
                    context,
                    ref,
                    paywallContext: PaywallContext.streakFreeze,
                    streakDays: longestStreak,
                    bypassTimingGate: true,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.streakOrange.withValues(alpha: 0.08)
                          : AppColors.streakOrange.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.streakOrange.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.ac_unit_rounded,
                          size: 18,
                          color: AppColors.streakOrange,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isEn
                                ? 'Premium streak freezes could have saved this'
                                : 'Premium seri dondurmalar bunu kurtarabilirdi',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.streakOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          isEn ? 'Learn more' : 'Daha fazla',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.streakOrange.withValues(
                              alpha: 0.7,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 150.ms),
          ],
        );
      },
    );
  }
}
