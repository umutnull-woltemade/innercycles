// ════════════════════════════════════════════════════════════════════════════
// LIFE WHEEL CHECK-IN CARD - Monthly balance assessment prompt
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class LifeWheelCheckinCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const LifeWheelCheckinCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(lifeWheelServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        if (!service.isDueForCheckin) return const SizedBox.shrink();

        final latest = service.getLatestEntry();
        final isFirst = latest == null;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: GestureDetector(
            onTap: () => context.push(Routes.lifeWheel),
            child: PremiumCard(
              style: PremiumCardStyle.aurora,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('\u{1F3AF}',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Text(
                          isEn ? 'Life Balance' : 'Ya\u015fam Dengesi',
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
                      isFirst
                          ? (isEn
                              ? 'Assess 8 areas of your life. Discover where you\u2019re thriving and where you need attention.'
                              : 'Hayat\u0131n\u0131n 8 alan\u0131n\u0131 de\u011ferlendir. Nerede geli\u015fti\u011fini ve nereye dikkat etmen gerekti\u011fini ke\u015ffet.')
                          : (isEn
                              ? 'It\u2019s been a month since your last assessment. See how your balance has shifted.'
                              : 'Son de\u011ferlendirmenden bir ay ge\u00e7ti. Dengenin nas\u0131l de\u011fi\u015fti\u011fini g\u00f6r.'),
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
                          color: AppColors.starGold
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isEn ? 'Check In \u2192' : 'De\u011ferlendir \u2192',
                          style: AppTypography.modernAccent(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.starGold,
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
