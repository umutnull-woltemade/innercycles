// ════════════════════════════════════════════════════════════════════════════
// DAILY QUESTION CARD - Shareable question-of-the-day widget
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.amethyst.withValues(alpha: 0.15),
                        AppColors.auroraEnd.withValues(alpha: 0.08),
                      ]
                    : [
                        AppColors.amethyst.withValues(alpha: 0.08),
                        AppColors.lightAuroraEnd.withValues(alpha: 0.05),
                      ],
              ),
              border: Border.all(
                color: AppColors.amethyst.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      size: 16,
                      color: AppColors.amethyst,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEn ? 'Question of the Day' : 'Günün Sorusu',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amethyst,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  questionText,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
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
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.1),
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
                            color: AppColors.amethyst.withValues(alpha: 0.3),
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
