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
import '../../../../data/content/share_card_templates.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/share_card_sheet.dart';
import '../../../../shared/widgets/share_nudge_chip.dart';
import '../../../../shared/widgets/tap_scale.dart';

class AnomalyAlertCard extends ConsumerWidget {
  final AppLanguage language;
  final bool isDark;

  const AnomalyAlertCard({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = language == AppLanguage.en;
    final engineAsync = ref.watch(patternEngineServiceProvider);

    return engineAsync.maybeWhen(
      data: (engine) {
        final anomalies = engine.detectAnomalies();
        if (anomalies.isEmpty) return const SizedBox.shrink();

        // Show the most significant anomaly
        final top = anomalies.first;
        final message = top.getMessage(language);
        final isDropping = top.isDrop;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
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
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ShareNudgeChip(
                  label: isEn ? 'Share Pattern' : 'Örüntüyü Paylaş',
                  isDark: isDark,
                  delay: 600.ms,
                  onTap: () {
                    final template = ShareCardTemplates.patternWisdom;
                    final cardData = ShareCardTemplates.buildData(
                      template: template,
                      language: language,
                      reflectionText: message,
                    );
                    ShareCardSheet.show(
                      context,
                      template: template,
                      data: cardData,
                      language: language,
                    );
                  },
                ),
              ),
            ),
          ],
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
