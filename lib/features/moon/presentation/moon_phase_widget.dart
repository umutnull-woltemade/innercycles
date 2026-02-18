// ════════════════════════════════════════════════════════════════════════════
// MOON PHASE WIDGET - Decorative Lunar Indicator
// ════════════════════════════════════════════════════════════════════════════
// Shows current moon phase on home screen + compact badge for daily entry.
// Pure astronomical data — no predictions.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/moon_phase_service.dart';

/// Home screen moon phase card — shows phase emoji, name, illumination, reflection prompt
class MoonPhaseCard extends ConsumerWidget {
  const MoonPhaseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final moonData = MoonPhaseService.today();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                  AppColors.cosmicPurple.withValues(alpha: 0.8),
                ]
              : [AppColors.lightCard, AppColors.lightSurfaceVariant],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.moonSilver.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Moon emoji circle
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
            ),
            child: Center(
              child: Text(
                moonData.phase.emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn
                      ? moonData.phase.displayNameEn()
                      : moonData.phase.displayNameTr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${(moonData.illumination * 100).round()}% ${isEn ? 'illuminated' : 'aydınlık'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.moonSilver.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isEn
                      ? moonData.phase.reflectionPromptEn()
                      : moonData.phase.reflectionPromptTr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

/// Compact moon phase badge for daily entry screen header
class MoonPhaseBadge extends StatelessWidget {
  final DateTime date;
  final bool isEn;
  final bool isDark;

  const MoonPhaseBadge({
    super.key,
    required this.date,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final moonData = MoonPhaseService.calculate(date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.moonSilver.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(moonData.phase.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            isEn
                ? moonData.phase.displayNameEn()
                : moonData.phase.displayNameTr(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
