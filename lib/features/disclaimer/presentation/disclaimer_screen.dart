import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/providers/app_providers.dart';

/// First-launch welcome screen for App Store compliance.
/// Redesigned as a warm, premium welcome with embedded compliance content.
class DisclaimerScreen extends ConsumerWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),

                // ── Hero section ──
                // Outer pulsing ring
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.starGold.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    // Inner icon circle
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppColors.amethyst, AppColors.starGold],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.auroraStart.withValues(alpha: 0.15),
                            blurRadius: 50,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.self_improvement,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ),
                )
                    .glassPulse(context: context, scale: 1.04)
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      curve: Curves.elasticOut,
                      duration: 700.ms,
                    )
                    .fadeIn(duration: 500.ms),

                const SizedBox(height: 28),

                // ── Title ──
                GradientText(
                  L10nService.get('disclaimer.disclaimer.welcome_to_innercycles', isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  variant: GradientTextVariant.gold,
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideY(begin: 0.08, delay: 300.ms, duration: 600.ms),

                const SizedBox(height: 10),

                // ── Subtitle ──
                Text(
                  L10nService.get('disclaimer.disclaimer.a_private_space_for_reflection_not_predi', isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.decorativeScript(
                    fontSize: 15,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                const SizedBox(height: 32),

                // ── Card 0: Journal ──
                PremiumCard(
                  style: PremiumCardStyle.subtle,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.edit_note,
                          color: AppColors.amethyst, size: 22),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          isEn
                              ? 'InnerCycles is a personal journaling tool for self-reflection and pattern awareness.'
                              : L10nService.get('disclaimer.text_1', isEn ? AppLanguage.en : AppLanguage.tr),
                          style: AppTypography.subtitle(
                            fontSize: 15,
                            color: textColor,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .slideX(begin: 0.1, delay: 600.ms, duration: 400.ms),

                const SizedBox(height: 12),

                // ── Card 1: Insights ──
                PremiumCard(
                  style: PremiumCardStyle.subtle,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.insights_outlined,
                          color: AppColors.auroraStart, size: 22),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          isEn
                              ? 'All insights are based solely on your own journal entries. This app does not make predictions about your future.'
                              : L10nService.get('disclaimer.text_2', isEn ? AppLanguage.en : AppLanguage.tr),
                          style: AppTypography.subtitle(
                            fontSize: 15,
                            color: textColor,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 720.ms, duration: 400.ms)
                    .slideX(begin: 0.1, delay: 720.ms, duration: 400.ms),

                const SizedBox(height: 12),

                // ── Card 2: Info ──
                PremiumCard(
                  style: PremiumCardStyle.subtle,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          color: AppColors.starGold, size: 22),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          isEn
                              ? 'This is for personal reflection only. It is not medical, psychological, or professional advice.'
                              : L10nService.get('disclaimer.text_3', isEn ? AppLanguage.en : AppLanguage.tr),
                          style: AppTypography.subtitle(
                            fontSize: 15,
                            color: textColor,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 840.ms, duration: 400.ms)
                    .slideX(begin: 0.1, delay: 840.ms, duration: 400.ms),

                const SizedBox(height: 36),

                // ── CTA Button ──
                GradientButton.gold(
                  label: L10nService.get('common.continue', isEn ? AppLanguage.en : AppLanguage.tr),
                  icon: Icons.arrow_forward,
                  width: double.infinity,
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    await StorageService.saveDisclaimerAccepted(true);
                    if (context.mounted) {
                      context.go(Routes.onboarding);
                    }
                  },
                )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 400.ms)
                    .slideY(begin: 0.2, delay: 1000.ms, duration: 500.ms)
                    .then()
                    .shimmer(
                      delay: 400.ms,
                      duration: 1500.ms,
                      color: AppColors.celestialGold.withValues(alpha: 0.25),
                    ),

                const SizedBox(height: 20),

                // ── Privacy line ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 12,
                      color: AppColors.textMuted.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      L10nService.get('disclaimer.disclaimer.your_data_stays_on_your_device', isEn ? AppLanguage.en : AppLanguage.tr),
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
