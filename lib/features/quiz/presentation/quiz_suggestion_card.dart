// ════════════════════════════════════════════════════════════════════════════
// QUIZ SUGGESTION CARD - Daily Quiz Recommendation for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/quiz_content.dart';
import '../../../data/providers/app_providers.dart';

class QuizSuggestionCard extends ConsumerWidget {
  const QuizSuggestionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;

    // Rotate quiz suggestion daily
    final quizzes = QuizContent.allQuizzes;
    if (quizzes.isEmpty) return const SizedBox.shrink();

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final quiz = quizzes[dayOfYear % quizzes.length];

    return Semantics(
      label: isEn
          ? 'Suggested Quiz: ${quiz.title}'
          : 'Önerilen Test: ${quiz.titleTr}',
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          context.push(Routes.quizGeneric.replaceFirst(':quizId', quiz.id));
        },
        child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.auroraStart.withValues(alpha: 0.1),
                    AppColors.auroraEnd.withValues(alpha: 0.06),
                    AppColors.surfaceDark.withValues(alpha: 0.9),
                  ]
                : [
                    AppColors.auroraStart.withValues(alpha: 0.06),
                    AppColors.auroraEnd.withValues(alpha: 0.03),
                    AppColors.lightCard,
                  ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.auroraStart.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.auroraStart.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(quiz.emoji, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEn ? 'Suggested Quiz' : 'Önerilen Test',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.auroraStart.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${quiz.questions.length} Q',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.auroraStart,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Quiz title
            Text(
              isEn ? quiz.title : quiz.titleTr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),

            const SizedBox(height: 4),

            // Quiz description
            Text(
              isEn ? quiz.description : quiz.descriptionTr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),

            const SizedBox(height: 10),

            // CTA row
            Row(
              children: [
                // Dimension pills (first 3)
                ...quiz.dimensions.values
                    .take(3)
                    .map(
                      (dim) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.2)
                                : AppColors.lightSurfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${dim.emoji} ${isEn ? dim.nameEn : dim.nameTr}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                const Spacer(),
                Text(
                  isEn ? 'Take quiz →' : 'Teste başla →',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.auroraStart,
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06, duration: 400.ms);
  }
}
