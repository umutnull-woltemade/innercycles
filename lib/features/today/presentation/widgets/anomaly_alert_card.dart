// ════════════════════════════════════════════════════════════════════════════
// ANOMALY ALERT CARD - Surfaces significant deviations on the home feed
// ════════════════════════════════════════════════════════════════════════════

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

class AnomalyAlertCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const AnomalyAlertCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(patternEngineServiceProvider);

    return engineAsync.maybeWhen(
      data: (engine) {
        final anomalies = engine.detectAnomalies();
        if (anomalies.isEmpty) return const SizedBox.shrink();

        // Show the most significant anomaly
        final top = anomalies.first;
        final language = AppLanguage.fromIsEn(isEn);
        final message = top.getMessage(language);
        final isDropping = top.isDrop;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TapScale(
            onTap: () {
              HapticService.buttonPress();
              context.push(Routes.moodTrends);
            },
            child: PremiumCard(
              style: PremiumCardStyle.subtle,
              showInnerShadow: false,
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (isDropping ? AppColors.warning : AppColors.success)
                          .withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      isDropping
                          ? Icons.trending_down_rounded
                          : Icons.trending_up_rounded,
                      size: 18,
                      color: isDropping ? AppColors.warning : AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? 'Pattern Alert' : 'Örüntü Uyarısı',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDropping
                                ? AppColors.warning
                                : AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          style: AppTypography.subtitle(
                            fontSize: 12,
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
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 400.ms).slideY(
              begin: 0.1,
              end: 0,
              delay: 350.ms,
              duration: 400.ms,
              curve: Curves.easeOut,
            );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
