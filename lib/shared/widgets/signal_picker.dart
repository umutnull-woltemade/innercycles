// ════════════════════════════════════════════════════════════════════════════
// SIGNAL PICKER - Horizontal row of 4 signals within a quadrant
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../data/content/signal_content.dart';
import '../../data/providers/app_providers.dart';
import '../../data/services/haptic_service.dart';
import 'signal_orb.dart';

class SignalPicker extends StatelessWidget {
  final SignalQuadrant quadrant;
  final String? selectedSignalId;
  final ValueChanged<MoodSignal> onSelected;
  final AppLanguage language;

  const SignalPicker({
    super.key,
    required this.quadrant,
    this.selectedSignalId,
    required this.onSelected,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final signals = getSignalsByQuadrant(quadrant);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < signals.length; i++)
          _SignalOption(
            signal: signals[i],
            isSelected: signals[i].id == selectedSignalId,
            onTap: () {
              HapticService.moodSelected();
              onSelected(signals[i]);
            },
            isDark: isDark,
            language: language,
          )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 80 * i),
                duration: 300.ms,
              )
              .slideY(
                begin: 0.15,
                end: 0,
                delay: Duration(milliseconds: 80 * i),
                duration: 300.ms,
                curve: Curves.easeOutBack,
              ),
      ],
    );
  }
}

class _SignalOption extends StatelessWidget {
  final MoodSignal signal;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final AppLanguage language;

  const _SignalOption({
    required this.signal,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.starGold.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                color: signal.orbGradientColors.first.withValues(alpha: 0.08),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: 200.ms,
              child: SignalOrb.card(
                signalId: signal.id,
                animate: isSelected,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              signal.localizedName(language),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary)
                    : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
