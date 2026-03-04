import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class BlindSpotDiscoveryCard extends ConsumerWidget {
  final AppLanguage language;
  final bool isDark;

  const BlindSpotDiscoveryCard({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(blindSpotServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        final report = service.getLastReport();
        if (report == null || report.blindSpots.isEmpty) {
          return const SizedBox.shrink();
        }

        final topSpot = report.blindSpots.first;
        final spotCount = report.blindSpots.length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.blindSpot);
            },
            child: PremiumCard(
              style: PremiumCardStyle.amethyst,
              borderRadius: 18,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.amethyst.withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.psychology_rounded,
                            size: 18,
                            color: AppColors.amethyst,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEn
                                  ? '$spotCount insight${spotCount > 1 ? 's' : ''} about you'
                                  : 'Hakkında $spotCount içgörü',
                              style: AppTypography.modernAccent(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isEn ? 'Blind Spot Analysis' : 'Kör Nokta Analizi',
                              style: AppTypography.elegantAccent(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.amethyst.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    topSpot.localizedInsight(language),
                    style: AppTypography.subtitle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
