// ════════════════════════════════════════════════════════════════════════════
// MORNING PAGES CARD - Today feed invitation (shows before noon only)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class MorningPagesCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const MorningPagesCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only show before noon
    if (DateTime.now().hour >= 12) return const SizedBox.shrink();

    final serviceAsync = ref.watch(morningPagesServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        if (service.hasSessionToday) return const SizedBox.shrink();

        final streak = service.currentStreak;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: GestureDetector(
            onTap: () => context.push(Routes.morningPages),
            child: PremiumCard(
              style: PremiumCardStyle.gold,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.starGold.withValues(alpha: 0.15),
                      ),
                      child: const Center(
                        child: Text('\u{2600}\u{FE0F}',
                            style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn
                                ? 'Morning Pages'
                                : 'Sabah Sayfalar\u0131',
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            streak > 0
                                ? (isEn
                                    ? '$streak-day streak \u2022 Keep the flow'
                                    : '$streak g\u00fcnl\u00fck seri \u2022 Ak\u0131\u015f\u0131 s\u00fcrd\u00fcr')
                                : (isEn
                                    ? 'Start your day with free writing'
                                    : 'G\u00fcn\u00fcne serbest yaz\u0131yla ba\u015fla'),
                            style: AppTypography.elegantAccent(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
