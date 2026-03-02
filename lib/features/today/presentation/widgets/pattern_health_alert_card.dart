import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/tap_scale.dart';

class PatternHealthAlertCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const PatternHealthAlertCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(patternHealthReportProvider);

    return reportAsync.maybeWhen(
      data: (report) {
        // Only show if there are yellow or red alerts
        final actionableAlerts = report.alerts.where(
          (a) => a.severity.name == 'yellow' || a.severity.name == 'red',
        ).toList();
        if (actionableAlerts.isEmpty) return const SizedBox.shrink();

        final topAlert = actionableAlerts.first;
        final isRed = topAlert.severity.name == 'red';
        final alertColor = isRed ? AppColors.error : AppColors.starGold;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.patternHealth);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: alertColor.withValues(alpha: isDark ? 0.08 : 0.06),
                border: Border.all(
                  color: alertColor.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: alertColor.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      isRed
                          ? Icons.warning_amber_rounded
                          : Icons.info_outline_rounded,
                      size: 18,
                      color: alertColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? topAlert.titleEn : topAlert.titleTr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.modernAccent(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        if (actionableAlerts.length > 1) ...[
                          const SizedBox(height: 2),
                          Text(
                            isEn
                                ? '+${actionableAlerts.length - 1} more alert${actionableAlerts.length > 2 ? 's' : ''}'
                                : '+${actionableAlerts.length - 1} uyarı daha',
                            style: AppTypography.subtitle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
