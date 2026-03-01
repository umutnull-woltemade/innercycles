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
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/quiz_content.dart';
import '../../../data/models/quiz_models.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/l10n_service.dart';

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
                title: L10nService.get('quiz.quiz_hub.selfreflection_quizzes', language),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header description
                    Text(
                          L10nService.get('quiz.quiz_hub.explore_different_aspects_of_yourself_th', language),
                          style: AppTypography.decorativeScript(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.05, end: 0, duration: 500.ms),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Quiz cards
                    ...QuizContent.allQuizzes.asMap().entries.map((entry) {
                      final language = AppLanguage.fromIsEn(isEn);
                      final index = entry.key;
                      final quiz = entry.value;

                      // Check completion status
                      final isCompleted =
                          quizServiceAsync.whenOrNull(
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
                            lastResultName = dim.localizedName(language);
                          }
                        }
                      }

                      return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.spacingLg,
                            ),
                            child: _QuizCard(
                              quiz: quiz,
                              isCompleted: isCompleted,
                              lastResultName: lastResultName,
                              isDark: isDark,
                              isEn: isEn,
                              onTap: () => context.push(
                                Routes.quizGeneric.replaceFirst(
                                  ':quizId',
                                  quiz.id,
                                ),
                              ),
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

                    ToolEcosystemFooter(
                      currentToolId: 'quizHub',
                      isEn: isEn,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 40),
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
    final language = AppLanguage.fromIsEn(isEn);
    return Semantics(
      button: true,
      label: quiz.localizedTitle(language),
      hint: isCompleted ? (L10nService.get('quiz.quiz_hub.completed', language)) : null,
      child: GestureDetector(
        onTap: onTap,
        child: PremiumCard(
          style: isCompleted
              ? PremiumCardStyle.aurora
              : PremiumCardStyle.subtle,
          padding: const EdgeInsets.all(AppConstants.spacingLg),
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
                  child: AppSymbol(quiz.emoji, size: AppSymbolSize.lg),
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
                            quiz.localizedTitle(language),
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 16,
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
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusFull,
                              ),
                              color: AppColors.auroraStart.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            child: Text(
                              L10nService.get('quiz.quiz_hub.completed_1', language),
                              style: AppTypography.elegantAccent(
                                fontSize: 11,
                                color: AppColors.auroraStart,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingXs),
                    Text(
                      quiz.localizedDescription(language),
                      style: AppTypography.subtitle(
                        fontSize: 12,
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
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
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
      ),
    );
  }
}
