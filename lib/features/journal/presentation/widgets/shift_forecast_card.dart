// ════════════════════════════════════════════════════════════════════════════
// SHIFT FORECAST CARD - Upcoming Shift Window Visualization
// ════════════════════════════════════════════════════════════════════════════
// Native card showing upcoming shift window with supporting signals.
// HIG-compliant: native card elevation, clear primary action focus,
// system motion curves. Premium-gated feature.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/shift_forecast_service.dart';
import '../../../../data/services/emotional_cycle_service.dart';

class ShiftForecastCard extends StatelessWidget {
  final ShiftForecast forecast;
  final bool isDark;
  final bool isEn;
  final VoidCallback? onTapDetails;

  const ShiftForecastCard({
    super.key,
    required this.forecast,
    required this.isDark,
    required this.isEn,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (!forecast.hasValidForecast) {
      return _buildNoForecast(context);
    }

    final window = forecast.primaryShiftWindow!;
    final phaseColor = _phaseColor(window.suggestedNextPhase);
    final currentColor = _phaseColor(window.currentPhase);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.9)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: phaseColor.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: phaseColor.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
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
                child: Icon(
                  Icons.timeline,
                  color: phaseColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? 'Shift Outlook' : 'Kayma Görünümü',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${window.confidence.labelEn()} ${isEn ? 'confidence' : 'güven'}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _confidenceColor(window.confidence),
                        fontWeight: FontWeight.w500,
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
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: phaseColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '~${window.estimatedDaysUntilShift}${isEn ? 'd' : 'g'}',
                  style: TextStyle(
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
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
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
              border: Border.all(
                color: phaseColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: phaseColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEn ? window.actionEn : window.actionTr,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
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
          if (forecast.activeSignals.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              isEn ? 'Supporting Signals' : 'Destekleyen Sinyaller',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            ...forecast.activeSignals.take(3).map((signal) {
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
                        style: TextStyle(
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
            color: isDark
                ? AppColors.textMuted
                : AppColors.lightTextMuted,
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
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildNoForecast(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.7)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timeline,
            color: isDark
                ? AppColors.textMuted
                : AppColors.lightTextMuted,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEn
                  ? 'Not enough data for shift outlook yet'
                  : 'Kayma görünümü için henüz yeterli veri yok',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
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

  Color _confidenceColor(ForecastConfidence confidence) {
    switch (confidence) {
      case ForecastConfidence.high:
        return AppColors.success;
      case ForecastConfidence.moderate:
        return AppColors.celestialGold;
      case ForecastConfidence.low:
        return AppColors.warning;
    }
  }

  Color _signalColor(double magnitude) {
    if (magnitude > 0.7) return AppColors.success;
    if (magnitude > 0.4) return AppColors.celestialGold;
    return AppColors.textMuted;
  }
}
