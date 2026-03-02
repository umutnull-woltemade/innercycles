// ════════════════════════════════════════════════════════════════════════════
// TIME CAPSULE WRITE CARD - Prompt to write when no pending capsules
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class TimeCapsuleWriteCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const TimeCapsuleWriteCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(timeCapsuleServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        // Only show when user has no pending capsules
        if (service.pendingCount > 0) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: GestureDetector(
            onTap: () => context.push(Routes.timeCapsule),
            child: PremiumCard(
              style: PremiumCardStyle.amethyst,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('\u{1F48C}',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Text(
                          isEn ? 'Time Capsule' : 'Zaman Kapsülü',
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
                          ? 'Write a letter to your future self. It will be sealed and delivered when the time comes.'
                          : 'Gelecekteki kendine bir mektup yaz. Mühürlenecek ve zamanı geldiğinde teslim edilecek.',
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
                          isEn ? 'Write Now \u2192' : '\u015eimdi Yaz \u2192',
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
      },
    );
  }
}
