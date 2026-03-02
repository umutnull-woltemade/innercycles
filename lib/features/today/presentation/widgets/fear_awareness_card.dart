// ════════════════════════════════════════════════════════════════════════════
// FEAR AWARENESS CARD - Today feed card for fear inventory
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class FearAwarenessCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const FearAwarenessCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(fearInventoryServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final activeCount = service.activeCount;

        // Show card when 3+ active fears, or as a daily "name one fear" prompt
        if (activeCount >= 3) {
          return _buildReviewCard(context, activeCount);
        }

        // Show "name a fear" prompt on days with no recent activity
        if (activeCount == 0) {
          return _buildPromptCard(context);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReviewCard(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: () => context.push(Routes.fearInventory),
        child: PremiumCard(
          style: PremiumCardStyle.amethyst,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('\u{1F311}',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Text(
                      isEn ? 'Fear Inventory' : 'Korku Envanteri',
                      style: AppTypography.modernAccent(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  isEn
                      ? 'You have $count named fears. Naming them tends to reduce their hold on you.'
                      : '$count adland\u0131r\u0131lm\u0131\u015f korkun var. Onlar\u0131 adland\u0131rmak etkilerini azaltma e\u011filimindedir.',
                  style: AppTypography.decorativeScript(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.amethyst
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isEn ? 'Review \u2192' : '\u0130ncele \u2192',
                      style: AppTypography.modernAccent(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amethyst,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromptCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: () => context.push(Routes.fearInventory),
        child: PremiumCard(
          style: PremiumCardStyle.subtle,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('\u{1F311}',
                    style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isEn
                        ? 'Name one fear today. Awareness is the first step.'
                        : 'Bug\u00fcn bir korku adland\u0131r. Fark\u0131ndal\u0131k ilk ad\u0131md\u0131r.',
                    style: AppTypography.decorativeScript(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
