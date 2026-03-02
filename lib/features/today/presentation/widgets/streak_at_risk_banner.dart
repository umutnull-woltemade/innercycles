// ════════════════════════════════════════════════════════════════════════════
// STREAK AT RISK BANNER - Proactive streak shield visibility
// ════════════════════════════════════════════════════════════════════════════
// Shows when user has an active streak (3+) but hasn't journaled today.
// Surfaces the freeze option prominently instead of burying it in stats.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/premium_service.dart';

class StreakAtRiskBanner extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const StreakAtRiskBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakStatsProvider);
    final todayEntryAsync = ref.watch(todayJournalEntryProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return streakAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) {
        // Only show if streak >= 3 AND no entry today
        if (stats.currentStreak < 3) return const SizedBox.shrink();

        final hasEntryToday = todayEntryAsync.whenOrNull(
          data: (entry) => entry != null,
        ) ?? false;

        if (hasEntryToday) return const SizedBox.shrink();

        final now = DateTime.now();
        final isEvening = now.hour >= 18;
        final freezesAvailable = stats.freezesAvailable;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.streakOrange.withValues(alpha: 0.12),
                        AppColors.surfaceDark.withValues(alpha: 0.95),
                      ]
                    : [
                        AppColors.streakOrange.withValues(alpha: 0.08),
                        AppColors.lightCard,
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.streakOrange.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Pulsing fire icon for urgency
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.streakOrange.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.streakOrange,
                        size: 22,
                      ),
                    )
                        .animate(
                          onPlay: (c) => c.repeat(reverse: true),
                        )
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.08, 1.08),
                          duration: 1200.ms,
                        ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn
                                ? '${stats.currentStreak}-day streak at risk!'
                                : '${stats.currentStreak} günlük seri risk altında!',
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEvening
                                ? (isEn
                                    ? 'Write a quick entry before midnight'
                                    : 'Gece yarısından önce kısa bir kayıt yaz')
                                : (isEn
                                    ? 'Journal today to keep your streak alive'
                                    : 'Serini korumak için bugün günlük yaz'),
                            style: AppTypography.subtitle(
                              fontSize: 12,
                              color: AppColors.streakOrange.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Action buttons
                Row(
                  children: [
                    // Primary: Write entry
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push(Routes.journal);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.starGold,
                                AppColors.celestialGold,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              isEn ? 'Write Now' : 'Şimdi Yaz',
                              style: AppTypography.modernAccent(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepSpace,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Secondary: Use freeze
                    if (freezesAvailable > 0)
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            final streakService = await ref.read(
                              streakServiceProvider.future,
                            );
                            final used = await streakService.useFreeze(
                              isPremium: isPremium,
                            );
                            if (used) {
                              ref.invalidate(streakStatsProvider);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.streakOrange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.streakOrange.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.ac_unit_rounded,
                                    size: 14,
                                    color: AppColors.streakOrange,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      isEn
                                          ? 'Freeze ($freezesAvailable)'
                                          : 'Dondur ($freezesAvailable)',
                                      style: AppTypography.modernAccent(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.streakOrange,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),
        );
      },
    );
  }
}
