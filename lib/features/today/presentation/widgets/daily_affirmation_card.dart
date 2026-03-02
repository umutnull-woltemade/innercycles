import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../data/content/share_card_templates.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/share_card_sheet.dart';
import '../../../../shared/widgets/tap_scale.dart';

class DailyAffirmationCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const DailyAffirmationCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = AppLanguage.fromIsEn(isEn);
    final affirmationAsync = ref.watch(affirmationServiceProvider);

    return affirmationAsync.maybeWhen(
      data: (service) {
        final affirmation = service.getDailyAffirmation();
        final text = affirmation.localizedText(language);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.subtle,
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: AppColors.starGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isEn ? 'Daily Affirmation' : 'G\u{00FC}nl\u{00FC}k Olumlamalar',
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: isDark
                            ? AppColors.starGold.withValues(alpha: 0.6)
                            : AppColors.starGold.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    TapScale(
                      onTap: () {
                        HapticService.selectionTap();
                        final template = ShareCardTemplates.questionOfTheDay;
                        final cardData = ShareCardTemplates.buildData(
                          template: template,
                          language: language,
                          reflectionText: text,
                        );
                        ShareCardSheet.show(
                          context,
                          template: template,
                          data: cardData,
                          language: language,
                        );
                      },
                      child: Icon(
                        Icons.share_rounded,
                        size: 14,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTypography.decorativeScript(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
