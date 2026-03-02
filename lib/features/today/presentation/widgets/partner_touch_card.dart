// ════════════════════════════════════════════════════════════════════════════
// PARTNER TOUCH CARD - Home feed card for bond touches
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/bond.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/providers/bond_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/gradient_text.dart';

class PartnerTouchCard extends ConsumerWidget {
  const PartnerTouchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bondsAsync = ref.watch(activeBondsProvider);

    return bondsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (bonds) {
        if (bonds.isEmpty) return const SizedBox.shrink();
        final bond = bonds.first;
        final partnerName = bond.partnerDisplayName(
              ref.read(bondServiceProvider).valueOrNull?.cachedBonds.isNotEmpty == true
                  ? bonds.first.userA
                  : '',
            ) ??
            (isEn ? 'Your partner' : 'Partnerin');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: PremiumCard(
            style: PremiumCardStyle.amethyst,
            child: GestureDetector(
              onTap: () {
                HapticService.selectionTap();
                context.push('/bond/detail/${bond.id}');
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  // Bond emoji
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.amethyst.withValues(alpha: 0.15),
                    ),
                    alignment: Alignment.center,
                    child: Text(bond.bondType.emoji, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          isEn ? 'Send a touch' : 'Bir dokunuş gönder',
                          variant: GradientTextVariant.amethyst,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          isEn
                              ? 'Let $partnerName know you\'re thinking of them'
                              : '$partnerName\'e düşündüğünü bildir',
                          style: AppTypography.subtitle(
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
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, duration: 400.ms);
      },
    );
  }
}
