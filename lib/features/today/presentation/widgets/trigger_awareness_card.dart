// ════════════════════════════════════════════════════════════════════════════
// TRIGGER AWARENESS CARD - Today feed nudge for trigger mapping
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class TriggerAwarenessCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const TriggerAwarenessCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(triggerMapServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final topTriggers = service.getTopTriggers(limit: 3);
        final dominant = service.dominantCategory;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: GestureDetector(
            onTap: () => context.push(Routes.triggerMap),
            child: PremiumCard(
              style: PremiumCardStyle.aurora,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('\u{1F30A}',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Text(
                          isEn ? 'Trigger Awareness' : 'Tetikleyici Farkındalığı',
                          style: AppTypography.modernAccent(
                            fontSize: 15,
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
                    const SizedBox(height: 8),
                    if (topTriggers.isEmpty)
                      Text(
                        isEn
                            ? 'Start identifying what triggers your emotions'
                            : 'Duygularını neyin tetiklediğini keşfet',
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      )
                    else ...[
                      if (dominant != null)
                        Text(
                          isEn
                              ? 'Most triggers from: ${dominant.emoji} ${dominant.nameEn}'
                              : 'Çoğu tetikleyici: ${dominant.emoji} ${dominant.nameTr}',
                          style: AppTypography.elegantAccent(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: topTriggers.map((t) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${t.category.emoji} ${t.label}',
                              style: AppTypography.elegantAccent(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
