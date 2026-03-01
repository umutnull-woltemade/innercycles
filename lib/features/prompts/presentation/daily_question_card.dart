// ════════════════════════════════════════════════════════════════════════════
// DAILY QUESTION CARD - Editorial style question-of-the-day
// ════════════════════════════════════════════════════════════════════════════
// Uses JournalPromptService.getDailyPrompt() to display a beautiful card.
// "Write" sends to journal, "Share" opens ShareCardSheet.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/content/share_card_templates.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/share_card_sheet.dart';
import '../../../data/services/l10n_service.dart';

class DailyQuestionCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const DailyQuestionCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promptAsync = ref.watch(journalPromptServiceProvider);

    return promptAsync.maybeWhen(
      data: (service) {
        final prompt = service.getDailyPrompt();
        final questionText = prompt.localizedPrompt(isEn ? AppLanguage.en : AppLanguage.tr);

        return Semantics(
          label:
              '${L10nService.get('prompts.daily_question.question_of_the_day', isEn ? AppLanguage.en : AppLanguage.tr)}: $questionText',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: PremiumCard(
              style: PremiumCardStyle.amethyst,
              borderRadius: 20,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                children: [
                  // Large decorative open-quote mark
                  Text(
                    '\u201C',
                    style: AppTypography.decorativeScript(
                      fontSize: 52,
                      color: AppColors.amethyst.withValues(alpha: 0.25),
                    ).copyWith(fontWeight: FontWeight.w800, height: 0.6),
                  ),
                  const SizedBox(height: 8),
                  // Question text — centered, large, editorial
                  Text(
                    questionText,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Label — small caps
                  Text(
                    L10nService.get('prompts.daily_question.question_of_the_day_1', isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: AppColors.amethyst.withValues(alpha: 0.6),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GradientOutlinedButton(
                          label: L10nService.get('prompts.daily_question.write', isEn ? AppLanguage.en : AppLanguage.tr),
                          icon: Icons.edit_note_rounded,
                          variant: GradientTextVariant.aurora,
                          fontSize: 13,
                          expanded: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          onPressed: () {
                            HapticService.buttonPress();
                            context.push(
                              Routes.journal,
                              extra: {'journalPrompt': questionText},
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GradientOutlinedButton(
                          label: L10nService.get('prompts.daily_question.share', isEn ? AppLanguage.en : AppLanguage.tr),
                          icon: Icons.share_rounded,
                          variant: GradientTextVariant.amethyst,
                          fontSize: 13,
                          expanded: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          onPressed: () {
                            HapticService.buttonPress();
                            final template =
                                ShareCardTemplates.questionOfTheDay;
                            final cardData = ShareCardTemplates.buildData(
                              template: template,
                              isEn: isEn,
                              reflectionText: questionText,
                            );
                            ShareCardSheet.show(
                              context,
                              template: template,
                              data: cardData,
                              isEn: isEn,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
