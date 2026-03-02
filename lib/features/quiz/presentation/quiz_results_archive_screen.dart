// ════════════════════════════════════════════════════════════════════════════
// QUIZ RESULTS ARCHIVE - Browse all past quiz results & dimension evolution
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/quiz_content.dart';
import '../../../data/models/quiz_models.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class QuizResultsArchiveScreen extends ConsumerWidget {
  const QuizResultsArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(quizEngineServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final completedIds = service.completedQuizIds;
              final allQuizzes = QuizContent.allQuizzes;

              // Gather all results per quiz
              int totalAttempts = 0;
              final quizResults = <String, List<QuizResult>>{};
              for (final quiz in allQuizzes) {
                final results = service.getAllResults(quiz.id);
                if (results.isNotEmpty) {
                  quizResults[quiz.id] = results;
                  totalAttempts += results.length;
                }
              }

              if (completedIds.isEmpty) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Quiz Results'
                        : 'Test Sonuçları',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Your self-reflection journey'
                                : 'Öz-yansıma yolculuğun',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview
                          _OverviewHero(
                            uniqueQuizzes: completedIds.length,
                            totalAttempts: totalAttempts,
                            totalAvailable: allQuizzes.length,
                            isEn: isEn,
                            isDark: isDark,
                          )
                              .animate()
                              .fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          GradientText(
                            isEn
                                ? 'Your Results'
                                : 'Sonuçların',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ...allQuizzes.map((quiz) {
                            final results =
                                quizResults[quiz.id] ?? [];
                            if (results.isEmpty) {
                              return _NotTakenCard(
                                quiz: quiz,
                                isEn: isEn,
                                isDark: isDark,
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12),
                              child: _QuizResultCard(
                                quiz: quiz,
                                results: results,
                                isEn: isEn,
                                isDark: isDark,
                              ),
                            );
                          }),

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? '$totalAttempts total quiz attempts'
                                  : '$totalAttempts toplam test denemesi',
                              style: AppTypography.subtitle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OverviewHero extends StatelessWidget {
  final int uniqueQuizzes;
  final int totalAttempts;
  final int totalAvailable;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.uniqueQuizzes,
    required this.totalAttempts,
    required this.totalAvailable,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.amethyst,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '$uniqueQuizzes',
                  style: AppTypography.modernAccent(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.amethyst,
                  ),
                ),
                Text(
                  isEn ? 'Quizzes' : 'Test',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '$totalAttempts',
                  style: AppTypography.modernAccent(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.auroraStart,
                  ),
                ),
                Text(
                  isEn ? 'Attempts' : 'Deneme',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '$totalAvailable',
                  style: AppTypography.modernAccent(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.starGold,
                  ),
                ),
                Text(
                  isEn ? 'Available' : 'Mevcut',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizResultCard extends StatelessWidget {
  final QuizDefinition quiz;
  final List<QuizResult> results;
  final bool isEn;
  final bool isDark;

  const _QuizResultCard({
    required this.quiz,
    required this.results,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final lang = isEn ? AppLanguage.en : AppLanguage.tr;
    final latest = results.first; // already sorted most recent first
    final dimMeta = quiz.dimensions[latest.resultType];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(quiz.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.localizedTitle(lang),
                      style: AppTypography.modernAccent(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      isEn
                          ? 'Taken ${results.length} ${results.length == 1 ? 'time' : 'times'}'
                          : '${results.length} kez çözüldü',
                      style: AppTypography.subtitle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Latest result type
          if (dimMeta != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: dimMeta.color.withValues(alpha: 0.12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(dimMeta.emoji,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    dimMeta.localizedName(lang),
                    style: AppTypography.modernAccent(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: dimMeta.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Dimension bars
          ...quiz.dimensions.entries.map((entry) {
            final dimKey = entry.key;
            final meta = entry.value;
            final pct = latest.percentageFor(dimKey);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      meta.localizedName(lang),
                      style: AppTypography.subtitle(
                        fontSize: 10,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: pct.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.04),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            meta.color),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${(pct * 100).round()}%',
                      textAlign: TextAlign.right,
                      style: AppTypography.modernAccent(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Result evolution if multiple attempts
          if (results.length > 1) ...[
            const SizedBox(height: 10),
            GradientText(
              isEn ? 'Evolution' : 'Gelişim',
              variant: GradientTextVariant.gold,
              style: AppTypography.modernAccent(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            ...results.reversed.map((r) {
              final rMeta = quiz.dimensions[r.resultType];
              final date =
                  '${r.completedAt.day.toString().padLeft(2, '0')}/${r.completedAt.month.toString().padLeft(2, '0')}/${r.completedAt.year}';
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      date,
                      style: AppTypography.subtitle(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (rMeta != null)
                      Text(rMeta.emoji,
                          style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      rMeta?.localizedName(lang) ?? r.resultType,
                      style: AppTypography.modernAccent(
                        fontSize: 10,
                        color: rMeta?.color ??
                            (isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _NotTakenCard extends StatelessWidget {
  final QuizDefinition quiz;
  final bool isEn;
  final bool isDark;

  const _NotTakenCard({
    required this.quiz,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final lang = isEn ? AppLanguage.en : AppLanguage.tr;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.black.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(quiz.emoji,
                style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                quiz.localizedTitle(lang),
                style: AppTypography.modernAccent(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
            Text(
              isEn ? 'Not taken' : 'Çözülmedi',
              style: AppTypography.subtitle(
                fontSize: 9,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Quiz Results' : 'Test Sonuçları',
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F9E0}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Take your first quiz to see results here'
                            : 'Sonuçları burada görmek için ilk testini çöz',
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
