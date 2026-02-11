import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/mystical_colors.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/providers/app_providers.dart';

/// First-launch disclaimer screen for App Store compliance.
/// Shows entertainment/educational purpose disclaimer before onboarding.
class DisclaimerScreen extends ConsumerWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(flex: 1),
                // Icon - Custom cosmic symbol
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.cosmicPurple, MysticalColors.amethyst],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cosmicPurple.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 36,
                  ),
                ).animate().scale(
                  begin: const Offset(0.5, 0.5),
                  curve: Curves.elasticOut,
                  duration: 600.ms,
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  L10nService.get('disclaimer.before_using', language),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.starGold,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 32),
                // Body content
                _buildDisclaimerContent(context, language),
                const Spacer(flex: 2),
                // Continue button
                GradientButton(
                  label: L10nService.get('common.continue', language),
                  icon: Icons.arrow_forward,
                  width: double.infinity,
                  onPressed: () async {
                    // Persist disclaimer acceptance for App Store compliance
                    await StorageService.saveDisclaimerAccepted(true);
                    if (context.mounted) {
                      context.go(Routes.onboarding);
                    }
                  },
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisclaimerContent(BuildContext context, AppLanguage language) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceLight.withAlpha(25)
            : AppColors.lightSurfaceVariant.withAlpha(200),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceLight.withAlpha(50)
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParagraph(
            context,
            L10nService.get('disclaimer.text_1', language),
            textColor,
          ),
          const SizedBox(height: 16),
          _buildParagraph(
            context,
            L10nService.get('disclaimer.text_2', language),
            textColor,
            icon: Icons.favorite_border,
          ),
          const SizedBox(height: 16),
          _buildParagraph(
            context,
            L10nService.get('disclaimer.text_3', language),
            textColor,
            icon: Icons.nights_stay_outlined,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildParagraph(
    BuildContext context,
    String text,
    Color textColor, {
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.starGold, size: 20),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: textColor, height: 1.6),
          ),
        ),
      ],
    );
  }
}
