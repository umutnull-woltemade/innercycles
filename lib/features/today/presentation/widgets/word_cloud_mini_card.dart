// ════════════════════════════════════════════════════════════════════════════
// WORD CLOUD MINI CARD - Today feed top 5 words teaser
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class WordCloudMiniCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const WordCloudMiniCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(wordCloudServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        if (!service.hasEnoughData) return const SizedBox.shrink();
        final top5 = service.getTopFive();
        if (top5.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: GestureDetector(
            onTap: () => context.push(Routes.wordCloud),
            child: PremiumCard(
              style: PremiumCardStyle.subtle,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('\u{2601}\u{FE0F}',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Text(
                          isEn ? 'Your Top Words' : 'En \u00c7ok Kelimelerin',
                          style: AppTypography.modernAccent(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: top5.asMap().entries.map((e) {
                        final w = e.value;
                        final scale = 1.0 - (e.key * 0.12);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.starGold
                                .withValues(alpha: 0.08 + scale * 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${w.word} \u00d7${w.count}',
                            style: AppTypography.modernAccent(
                              fontSize: 11 + scale * 3,
                              fontWeight: FontWeight.w600,
                              color: AppColors.starGold
                                  .withValues(alpha: 0.6 + scale * 0.4),
                            ),
                          ),
                        );
                      }).toList(),
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
