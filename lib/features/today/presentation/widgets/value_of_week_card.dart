// ════════════════════════════════════════════════════════════════════════════
// VALUE OF THE WEEK CARD - Rotates through user's top values
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class ValueOfWeekCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const ValueOfWeekCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(valuesServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        if (!service.hasCompleted) {
          // Show invitation to discover values
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: GestureDetector(
              onTap: () => context.push(Routes.valuesCompass),
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.diamond_rounded,
                        size: 18, color: AppColors.amethyst),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'Discover your core values'
                            : 'Temel değerlerini keşfet',
                        style: AppTypography.subtitle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 300.ms);
        }

        final value = service.getValueOfWeek();
        if (value == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: GestureDetector(
            onTap: () => context.push(Routes.valuesCompass),
            child: PremiumCard(
              style: PremiumCardStyle.amethyst,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value.color.withValues(alpha: 0.15),
                    ),
                    child: Icon(value.icon, size: 18, color: value.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn
                              ? 'Value of the Week'
                              : 'Haftanın Değeri',
                          style: AppTypography.subtitle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value.name(isEn),
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      size: 18,
                      color:
                          isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 380.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
