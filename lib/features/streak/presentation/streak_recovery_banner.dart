// ════════════════════════════════════════════════════════════════════════════
// STREAK RECOVERY BANNER - Re-engage users who missed a day
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';

class StreakRecoveryBanner extends ConsumerWidget {
  const StreakRecoveryBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final streakAsync = ref.watch(streakStatsProvider);

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

        return GestureDetector(
          onTap: () => context.push(Routes.journal),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
                            : '$longestStreak günlük serin sona erdi',
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
        ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0);
      },
    );
  }
}
