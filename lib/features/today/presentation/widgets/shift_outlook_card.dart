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

class ShiftOutlookCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const ShiftOutlookCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outlookAsync = ref.watch(shiftOutlookProvider);

    return outlookAsync.maybeWhen(
      data: (outlook) {
        if (!outlook.hasValidOutlook) return const SizedBox.shrink();

        final language = AppLanguage.fromIsEn(isEn);
        final window = outlook.primaryShiftWindow!;
        final phase = outlook.currentPhase!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.emotionalCycles);
            },
            child: PremiumCard(
              style: PremiumCardStyle.aurora,
              borderRadius: 16,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insights_rounded,
                        size: 18,
                        color: AppColors.auroraStart,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEn ? 'Shift Outlook' : 'Kayma Görünümü',
                          style: AppTypography.modernAccent(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.auroraStart.withValues(alpha: 0.15),
                        ),
                        child: Text(
                          window.confidence.label(language),
                          style: AppTypography.elegantAccent(
                            fontSize: 10,
                            color: AppColors.auroraStart,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Phase transition indicator
                  Row(
                    children: [
                      _phaseChip(
                        isEn
                            ? phase.labelEn()
                            : phase.labelTr(),
                        true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.trending_flat_rounded,
                          size: 16,
                          color: AppColors.auroraStart,
                        ),
                      ),
                      _phaseChip(
                        isEn
                            ? window.suggestedNextPhase.labelEn()
                            : window.suggestedNextPhase.labelTr(),
                        false,
                      ),
                      const Spacer(),
                      Text(
                        isEn
                            ? '~${window.estimatedDaysUntilShift}d'
                            : '~${window.estimatedDaysUntilShift}g',
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: AppColors.auroraStart,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    window.localizedDescription(language),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subtitle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  if (outlook.activeSignals.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.sensors_rounded,
                          size: 13,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isEn
                              ? '${outlook.activeSignals.length} active signal${outlook.activeSignals.length > 1 ? 's' : ''}'
                              : '${outlook.activeSignals.length} aktif sinyal',
                          style: AppTypography.elegantAccent(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 680.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _phaseChip(String label, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isCurrent
            ? (isDark
                ? AppColors.surfaceDark
                : AppColors.lightSurfaceVariant)
            : AppColors.auroraStart.withValues(alpha: 0.12),
        border: isCurrent
            ? null
            : Border.all(
                color: AppColors.auroraStart.withValues(alpha: 0.2),
              ),
      ),
      child: Text(
        label,
        style: AppTypography.modernAccent(
          fontSize: 11,
          fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w600,
          color: isCurrent
              ? (isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary)
              : AppColors.auroraStart,
        ),
      ),
    );
  }
}
