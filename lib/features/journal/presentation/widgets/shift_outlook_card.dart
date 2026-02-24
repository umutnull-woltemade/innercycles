// ════════════════════════════════════════════════════════════════════════════
// SHIFT OUTLOOK CARD - Upcoming Shift Window Visualization
// ════════════════════════════════════════════════════════════════════════════
// Native card showing upcoming shift window with supporting signals.
// HIG-compliant: native card elevation, clear primary action focus,
// system motion curves. Premium-gated feature.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/services/shift_outlook_service.dart';
import '../../../../data/services/emotional_cycle_service.dart';
import '../../../../shared/widgets/premium_card.dart';

class ShiftOutlookCard extends StatelessWidget {
  final ShiftOutlook outlook;
  final bool isDark;
  final bool isEn;
  final VoidCallback? onTapDetails;

  const ShiftOutlookCard({
    super.key,
    required this.outlook,
    required this.isDark,
    required this.isEn,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (!outlook.hasValidOutlook) {
      return _buildNoOutlook(context);
    }

    final window = outlook.primaryShiftWindow!;
    final phaseColor = _phaseColor(window.suggestedNextPhase);
    final currentColor = _phaseColor(window.currentPhase);

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      borderRadius: AppConstants.radiusXl,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: phaseColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.timeline, color: phaseColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? 'Shift Outlook' : 'Kayma Görünümü',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 16,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${isEn ? window.confidence.labelEn() : window.confidence.labelTr()} ${isEn ? 'confidence' : 'güven'}',
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        color: _confidenceColor(window.confidence),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Days badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: phaseColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(color: phaseColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '~${window.estimatedDaysUntilShift}${isEn ? 'd' : 'g'}',
                  style: AppTypography.modernAccent(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: phaseColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLg),

          // Phase transition visualization
          _buildPhaseTransition(
            context,
            window.currentPhase,
            window.suggestedNextPhase,
            currentColor,
            phaseColor,
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // Description
          Text(
            isEn ? window.descriptionEn : window.descriptionTr,
            style: AppTypography.decorativeScript(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // Action recommendation
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: phaseColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: phaseColor.withValues(alpha: 0.12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, size: 16, color: phaseColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEn ? window.actionEn : window.actionTr,
                    style: AppTypography.decorativeScript(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Micro signals
          if (outlook.activeSignals.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              isEn ? 'Supporting Signals' : 'Destekleyen Sinyaller',
              style: AppTypography.modernAccent(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            ...outlook.activeSignals.take(3).map((signal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: _signalColor(signal.magnitude),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn ? signal.signalEn : signal.signalTr,
                        style: AppTypography.decorativeScript(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildPhaseTransition(
    BuildContext context,
    EmotionalPhase current,
    EmotionalPhase next,
    Color currentColor,
    Color nextColor,
  ) {
    return Row(
      children: [
        // Current phase badge
        _buildPhaseBadge(
          context,
          isEn ? current.labelEn() : current.labelTr(),
          currentColor,
          true,
        ),
        // Arrow
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.arrow_forward,
            size: 18,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        // Next phase badge
        _buildPhaseBadge(
          context,
          isEn ? next.labelEn() : next.labelTr(),
          nextColor,
          false,
        ),
      ],
    );
  }

  Widget _buildPhaseBadge(
    BuildContext context,
    String label,
    Color color,
    bool isCurrent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isCurrent ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: isCurrent ? 0.4 : 0.2),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.modernAccent(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildNoOutlook(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        children: [
          Icon(
            Icons.timeline,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEn
                  ? 'Not enough data for shift outlook yet'
                  : 'Kayma görünümü için henüz yeterli veri yok',
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _phaseColor(EmotionalPhase phase) {
    switch (phase) {
      case EmotionalPhase.expansion:
        return AppColors.success;
      case EmotionalPhase.stabilization:
        return AppColors.auroraStart;
      case EmotionalPhase.contraction:
        return AppColors.warning;
      case EmotionalPhase.reflection:
        return AppColors.amethyst;
      case EmotionalPhase.recovery:
        return AppColors.celestialGold;
    }
  }

  Color _confidenceColor(OutlookConfidence confidence) {
    switch (confidence) {
      case OutlookConfidence.high:
        return AppColors.success;
      case OutlookConfidence.moderate:
        return AppColors.celestialGold;
      case OutlookConfidence.low:
        return AppColors.warning;
    }
  }

  Color _signalColor(double magnitude) {
    if (magnitude > 0.7) return AppColors.success;
    if (magnitude > 0.4) return AppColors.celestialGold;
    return AppColors.textMuted;
  }
}
