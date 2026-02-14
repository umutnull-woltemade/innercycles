// ════════════════════════════════════════════════════════════════════════════
// QUIZ HUB SCREEN - InnerCycles Quiz Discovery
// ════════════════════════════════════════════════════════════════════════════
// Shows all available self-reflection quizzes as cards with emoji, title,
// description, and a "Completed" badge if already taken.
// Pattern: CustomScrollView + SliverAppBar + CosmicBackground
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/quiz_content.dart';
import '../../../data/models/quiz_models.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class QuizHubScreen extends ConsumerWidget {
  const QuizHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final quizServiceAsync = ref.watch(quizEngineServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Self-Reflection Quizzes' : 'Oz Yansitma Testleri',
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header description
                    Text(
                      isEn
                          ? 'Explore different aspects of yourself through thoughtful self-reflection. These are personal awareness tools, not clinical assessments.'
                          : 'Dusunceli oz yansitma yoluyla kendinizin farkli yonlerini kesfedin. Bunlar kisisel farkindalik araclaridir, klinik degerlendirmeler degildir.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.05, end: 0, duration: 500.ms),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Quiz cards
                    ...QuizContent.allQuizzes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final quiz = entry.value;

                      // Check completion status
                      final isCompleted = quizServiceAsync.whenOrNull(
                            data: (service) => service.hasCompleted(quiz.id),
                          ) ??
                          false;

                      // Get last result type for completed badge
                      String? lastResultName;
                      if (isCompleted) {
                        final lastResult = quizServiceAsync.whenOrNull(
                          data: (service) => service.getLatestResult(quiz.id),
                        );
                        if (lastResult != null) {
                          final dim = quiz.dimensions[lastResult.resultType];
                          if (dim != null) {
                            lastResultName =
                                isEn ? dim.nameEn : dim.nameTr;
                          }
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppConstants.spacingLg),
                        child: _QuizCard(
                          quiz: quiz,
                          isCompleted: isCompleted,
                          lastResultName: lastResultName,
                          isDark: isDark,
                          isEn: isEn,
                          onTap: () => context.push('/quiz/${quiz.id}'),
                        ),
                      )
                          .animate()
                          .fadeIn(
                            duration: 500.ms,
                            delay: Duration(milliseconds: 100 + (index * 80)),
                          )
                          .slideY(
                            begin: 0.05,
                            end: 0,
                            duration: 500.ms,
                            delay: Duration(milliseconds: 100 + (index * 80)),
                          );
                    }),

                    const SizedBox(height: AppConstants.spacingHuge),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// QUIZ CARD WIDGET
// ════════════════════════════════════════════════════════════════════════════

class _QuizCard extends StatelessWidget {
  final QuizDefinition quiz;
  final bool isCompleted;
  final String? lastResultName;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;

  const _QuizCard({
    required this.quiz,
    required this.isCompleted,
    this.lastResultName,
    required this.isDark,
    required this.isEn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          border: Border.all(
            color: isCompleted
                ? AppColors.auroraStart.withValues(alpha: 0.4)
                : isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.4)
                    : AppColors.lightSurfaceVariant,
            width: isCompleted ? 1.5 : 1,
          ),
          gradient: isCompleted
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.auroraStart.withValues(alpha: 0.08),
                    AppColors.auroraEnd.withValues(alpha: 0.04),
                  ],
                )
              : null,
          color: isCompleted
              ? null
              : isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.6)
                  : AppColors.lightCard.withValues(alpha: 0.9),
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.3)
                    : AppColors.lightSurfaceVariant.withValues(alpha: 0.8),
              ),
              child: Center(
                child: Text(
                  quiz.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingLg),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEn ? quiz.title : quiz.titleTr,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusFull),
                            color: AppColors.auroraStart.withValues(alpha: 0.2),
                          ),
                          child: Text(
                            isEn ? 'Done' : 'Tamam',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.auroraStart,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingXs),
                  Text(
                    isEn ? quiz.description : quiz.descriptionTr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                          height: 1.4,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isCompleted && lastResultName != null) ...[
                    const SizedBox(height: AppConstants.spacingXs),
                    Text(
                      isEn
                          ? 'Your result: $lastResultName'
                          : 'Sonucunuz: $lastResultName',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.starGold,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.textSecondary.withValues(alpha: 0.5)
                  : AppColors.lightTextMuted,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
