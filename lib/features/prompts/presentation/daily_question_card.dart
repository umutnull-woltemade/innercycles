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
import '../../../data/providers/app_providers.dart';
import '../../../data/content/share_card_templates.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/share_card_sheet.dart';

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
        final questionText = isEn ? prompt.promptEn : prompt.promptTr;

        return Semantics(
          label: '${isEn ? 'Question of the Day' : 'Günün Sorusu'}: $questionText',
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
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      height: 0.6,
                      color: AppColors.amethyst.withValues(alpha: 0.25),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Question text — centered, large, editorial
                  Text(
                    questionText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      height: 1.45,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Label — small caps
                  Text(
                    isEn ? 'QUESTION OF THE DAY' : 'GÜNÜN SORUSU',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.amethyst.withValues(alpha: 0.6),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HapticService.buttonPress();
                            context.push(
                              Routes.journal,
                              extra: {'journalPrompt': questionText},
                            );
                          },
                          icon: Icon(
                            Icons.edit_note_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          label: Text(
                            isEn ? 'Write' : 'Yaz',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : Colors.black.withValues(alpha: 0.08),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HapticService.buttonPress();
                            final template = ShareCardTemplates.questionOfTheDay;
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
                          icon: Icon(
                            Icons.share_rounded,
                            size: 16,
                            color: AppColors.amethyst,
                          ),
                          label: Text(
                            isEn ? 'Share' : 'Paylaş',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.amethyst,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.amethyst.withValues(alpha: 0.25),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
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
