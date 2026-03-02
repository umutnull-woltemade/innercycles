// ════════════════════════════════════════════════════════════════════════════
// PREMIUM CELEBRATION MODAL - Post-purchase celebration with feature highlights
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/providers/app_providers.dart';

class PremiumCelebrationModal extends StatelessWidget {
  final AppLanguage language;
  final VoidCallback onDismiss;

  const PremiumCelebrationModal({
    super.key,
    required this.language,
    required this.onDismiss,
  });

  static Future<void> show(BuildContext context, {required AppLanguage language}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => PremiumCelebrationModal(
        language: language,
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final features = [
      _Feature(
        icon: Icons.insights_rounded,
        title: isEn ? 'Pattern Analysis' : 'Örüntü Analizi',
        subtitle: isEn ? 'Deep insights from your entries' : 'Kayıtlarından derin içgörüler',
        color: AppColors.auroraStart,
      ),
      _Feature(
        icon: Icons.auto_awesome_rounded,
        title: isEn ? 'Unlimited AI' : 'Sınırsız AI',
        subtitle: isEn ? 'Dreams, reflections & prompts' : 'Rüyalar, yansımalar ve istemler',
        color: AppColors.amethyst,
      ),
      _Feature(
        icon: Icons.ac_unit_rounded,
        title: isEn ? 'Streak Freeze' : 'Seri Koruma',
        subtitle: isEn ? 'Protect your streak on busy days' : 'Yoğun günlerde serini koru',
        color: AppColors.chartBlue,
      ),
      _Feature(
        icon: Icons.block_rounded,
        title: isEn ? 'Ad-Free' : 'Reklamsız',
        subtitle: isEn ? 'Pure, distraction-free journaling' : 'Saf, dikkat dağıtmayan günlük',
        color: AppColors.success,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepSpace : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: AppColors.starGold.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Celebration icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.starGold.withValues(alpha: 0.2),
                      AppColors.celestialGold.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text('✨', style: TextStyle(fontSize: 32)),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  )
                  .then()
                  .shimmer(delay: 200.ms, duration: 800.ms),
              const SizedBox(height: 16),

              // Title
              GradientText(
                isEn ? 'Welcome to Premium' : 'Premium\'a Hoş Geldin',
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: 8),

              Text(
                isEn
                    ? 'You\'ve unlocked the full InnerCycles experience'
                    : 'InnerCycles deneyiminin tamamını açtın',
                textAlign: TextAlign.center,
                style: AppTypography.decorativeScript(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: 24),

              // Feature highlights
              ...features.asMap().entries.map((entry) {
                final idx = entry.key;
                final f = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: f.color.withValues(alpha: isDark ? 0.08 : 0.05),
                      border: Border.all(
                        color: f.color.withValues(alpha: 0.12),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: f.color.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Icon(f.icon, size: 18, color: f.color),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.title,
                                style: AppTypography.displayFont.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                f.subtitle,
                                style: AppTypography.subtitle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: f.color,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: 400 + idx * 80),
                      duration: 300.ms,
                    )
                    .slideX(begin: 0.05, duration: 300.ms);
              }),

              const SizedBox(height: 20),

              // CTA
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [AppColors.starGold, AppColors.celestialGold],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isEn ? 'Start Exploring' : 'Keşfetmeye Başla',
                      style: AppTypography.modernAccent(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 300.ms)
                  .then()
                  .shimmer(delay: 300.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
