// ════════════════════════════════════════════════════════════════════════════
// GENERIC QUIZ SCREEN - InnerCycles Reusable Quiz Runner
// ════════════════════════════════════════════════════════════════════════════
// A fully reusable quiz screen that works with any QuizDefinition.
// Features: progress indicator, animated transitions, result display.
// Pattern: CustomScrollView + CosmicBackground + flutter_animate
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
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../data/services/l10n_service.dart';

class GenericQuizScreen extends ConsumerStatefulWidget {
  final String quizId;

  const GenericQuizScreen({super.key, required this.quizId});

  @override
  ConsumerState<GenericQuizScreen> createState() => _GenericQuizScreenState();
}

class _GenericQuizScreenState extends ConsumerState<GenericQuizScreen> {
  final PageController _pageController = PageController();
  final List<int> _answers = [];
  int _currentPage = 0;
  bool _showResult = false;
  QuizResult? _result;

  QuizDefinition? get _definition => QuizContent.getById(widget.quizId);
  int get _totalPages => _definition?.questions.length ?? 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ══════════════════════════════════════════════════════════════════════════

  void _selectAnswer(int answerIndex) {
    if (_answers.length > _currentPage) {
      _answers[_currentPage] = answerIndex;
    } else {
      _answers.add(answerIndex);
    }

    setState(() {});

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      if (_currentPage < _totalPages - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _computeResult();
      }
    });
  }

  Future<void> _computeResult() async {
    final definition = _definition;
    if (definition == null) return;

    final serviceAsync = ref.read(quizEngineServiceProvider);
    final service = serviceAsync.valueOrNull;
    if (service == null) return;

    final result = service.calculateResult(definition, _answers);
    setState(() {
      _result = result;
      _showResult = true;
    });
  }

  void _restartQuiz() {
    setState(() {
      _answers.clear();
      _currentPage = 0;
      _showResult = false;
      _result = null;
    });
    _pageController.jumpToPage(0);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final definition = _definition;
    if (definition == null) {
      final lang = ref.watch(languageProvider);
      return Scaffold(
        body: CosmicBackground(
          child: Center(
            child: Text(
              lang == AppLanguage.en ? 'Quiz not found' : 'Test bulunamadı',
              style: AppTypography.modernAccent(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: _showResult && _result != null
              ? _buildResultView(context, definition, isDark, isEn)
              : _buildQuizView(context, definition, isDark, isEn),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUIZ VIEW
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildQuizView(
    BuildContext context,
    QuizDefinition definition,
    bool isDark,
    bool isEn,
  ) {
    return Column(
      children: [
        _buildQuizAppBar(context, definition, isDark, isEn),
        _buildProgressBar(isDark),
        const SizedBox(height: AppConstants.spacingMd),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
          ),
          child: Text(
            isEn
                ? 'Question ${_currentPage + 1} of $_totalPages'
                : 'Soru ${_currentPage + 1} / $_totalPages',
            style: AppTypography.subtitle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              return _buildQuestionPage(
                context,
                definition,
                index,
                isDark,
                isEn,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuizAppBar(
    BuildContext context,
    QuizDefinition definition,
    bool isDark,
    bool isEn,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: L10nService.get('quiz.generic_quiz.back', isEn ? AppLanguage.en : AppLanguage.tr),
            onPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                );
              } else {
                context.pop();
              }
            },
            icon: Icon(
              Icons.chevron_left,
              size: 28,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Expanded(
            child: Text(
              definition.localizedTitle(isEn ? AppLanguage.en : AppLanguage.tr),
              textAlign: TextAlign.center,
              style: AppTypography.displayFont.copyWith(
                fontSize: 22,
                color: AppColors.starGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProgressBar(bool isDark) {
    final progress = _totalPages > 0 ? (_currentPage + 1) / _totalPages : 0.0;
    return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                  : AppColors.lightSurfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.auroraStart,
              ),
            ),
          ),
        )
        .animate(key: ValueKey(_currentPage))
        .fadeIn(duration: 300.ms)
        .scaleX(begin: 0.95, end: 1.0, duration: 300.ms);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUESTION PAGE
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildQuestionPage(
    BuildContext context,
    QuizDefinition definition,
    int index,
    bool isDark,
    bool isEn,
  ) {
    final question = definition.questions[index];
    final questionText = isEn ? question.text : question.textTr;
    final selectedAnswer = _answers.length > index ? _answers[index] : -1;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Text(
                    questionText,
                    style: AppTypography.modernAccent(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ).copyWith(height: 1.5),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: -0.1, end: 0, duration: 500.ms),
              const SizedBox(height: AppConstants.spacingXl),
              ...List.generate(question.options.length, (optionIndex) {
                final option = question.options[optionIndex];
                final optionText = isEn ? option.text : option.textTr;
                final isSelected = selectedAnswer == optionIndex;

                return Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.spacingMd,
                      ),
                      child: _buildOptionCard(
                        context,
                        optionText: optionText,
                        isSelected: isSelected,
                        isDark: isDark,
                        onTap: () => _selectAnswer(optionIndex),
                      ),
                    )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: Duration(milliseconds: 200 + (optionIndex * 100)),
                    )
                    .slideX(
                      begin: 0.05,
                      end: 0,
                      duration: 400.ms,
                      delay: Duration(milliseconds: 200 + (optionIndex * 100)),
                    );
              }),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String optionText,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: optionText,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
              color: isSelected
                  ? AppColors.auroraStart
                  : isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.4)
                  : AppColors.lightSurfaceVariant,
              width: isSelected ? 2 : 1,
            ),
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.auroraStart.withValues(alpha: 0.15),
                      AppColors.auroraEnd.withValues(alpha: 0.10),
                    ],
                  )
                : null,
            color: isSelected
                ? null
                : isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.6)
                : AppColors.lightCard.withValues(alpha: 0.9),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(
                  top: 2,
                  right: AppConstants.spacingMd,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.auroraStart
                        : AppColors.textSecondary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  color: isSelected
                      ? AppColors.auroraStart
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              Expanded(
                child: Text(
                  optionText,
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // RESULT VIEW
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildResultView(
    BuildContext context,
    QuizDefinition definition,
    bool isDark,
    bool isEn,
  ) {
    final result = _result!;
    final winningDim = definition.dimensions[result.resultType];
    if (winningDim == null) return const SizedBox.shrink();

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(title: L10nService.get('quiz.generic_quiz.your_result', isEn ? AppLanguage.en : AppLanguage.tr)),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Disclaimer
                _buildDisclaimer(context, isDark, isEn),
                const SizedBox(height: AppConstants.spacingXl),

                // Primary result card
                _buildPrimaryResultCard(
                  context,
                  definition,
                  result,
                  winningDim,
                  isDark,
                  isEn,
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Percentage breakdown
                _buildPercentageBreakdown(
                  context,
                  definition,
                  result,
                  isDark,
                  isEn,
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Strengths
                if (winningDim.strengthsEn.isNotEmpty) ...[
                  _buildListSection(
                    context,
                    title: L10nService.get('quiz.generic_quiz.your_strengths', isEn ? AppLanguage.en : AppLanguage.tr),
                    items: winningDim.localizedStrengths(isEn ? AppLanguage.en : AppLanguage.tr),
                    icon: Icons.star_rounded,
                    color: AppColors.starGold,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppConstants.spacingXl),
                ],

                // Growth areas
                if (winningDim.growthAreasEn.isNotEmpty) ...[
                  _buildListSection(
                    context,
                    title: L10nService.get('quiz.generic_quiz.growth_areas', isEn ? AppLanguage.en : AppLanguage.tr),
                    items: winningDim.localizedGrowthAreas(isEn ? AppLanguage.en : AppLanguage.tr),
                    icon: Icons.spa_rounded,
                    color: AppColors.amethyst,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppConstants.spacingXxl),
                ],

                // Action buttons
                _buildRetakeButton(context, isDark, isEn),
                const SizedBox(height: AppConstants.spacingMd),
                _buildBackToHubButton(context, isDark, isEn),
                const SizedBox(height: AppConstants.spacingHuge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context, bool isDark, bool isEn) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.5)
            : AppColors.lightSurfaceVariant.withValues(alpha: 0.7),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Text(
              isEn
                  ? 'This is a self-reflection tool for personal awareness, '
                        'not a clinical assessment.'
                  : 'Bu, klinik bir değerlendirme değil, kişisel farkındalık '
                        'için bir öz yansıtma aracıdır.',
              style: AppTypography.decorativeScript(
                fontSize: 13,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildPrimaryResultCard(
    BuildContext context,
    QuizDefinition definition,
    QuizResult result,
    QuizDimensionMeta dim,
    bool isDark,
    bool isEn,
  ) {
    final percentage = (result.percentageFor(result.resultType) * 100)
        .toStringAsFixed(0);

    return Container(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                dim.color.withValues(alpha: 0.25),
                dim.color.withValues(alpha: 0.10),
              ],
            ),
            border: Border.all(
              color: dim.color.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              AppSymbol.hero(dim.emoji),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                dim.localizedName(isEn ? AppLanguage.en : AppLanguage.tr),
                style: AppTypography.displayFont.copyWith(
                  fontSize: 20,
                  color: dim.color,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingXs),
              Text(
                '$percentage%',
                style: AppTypography.modernAccent(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: dim.color.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),
              Text(
                dim.localizedDescription(isEn ? AppLanguage.en : AppLanguage.tr),
                style: AppTypography.decorativeScript(
                  fontSize: 15,
                  color: isDark
                      ? AppColors.textPrimary.withValues(alpha: 0.9)
                      : AppColors.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 700.ms, delay: 200.ms)
        .scaleXY(begin: 0.95, end: 1.0, duration: 700.ms, delay: 200.ms);
  }

  Widget _buildPercentageBreakdown(
    BuildContext context,
    QuizDefinition definition,
    QuizResult result,
    bool isDark,
    bool isEn,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10nService.get('quiz.generic_quiz.full_breakdown', isEn ? AppLanguage.en : AppLanguage.tr),
          style: AppTypography.displayFont.copyWith(
            fontSize: 18,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),
        ...definition.dimensions.entries.map((entry) {
          final dim = entry.value;
          final percentage = result.percentageFor(entry.key);
          final percentText = '${(percentage * 100).toStringAsFixed(0)}%';
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
            child: _buildPercentageRow(
              context,
              dim: dim,
              percentage: percentage,
              percentText: percentText,
              isDark: isDark,
              isEn: isEn,
            ),
          );
        }),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildPercentageRow(
    BuildContext context, {
    required QuizDimensionMeta dim,
    required double percentage,
    required String percentText,
    required bool isDark,
    required bool isEn,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                dim.localizedName(isEn ? AppLanguage.en : AppLanguage.tr),
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            Text(
              percentText,
              style: AppTypography.subtitle(
                fontSize: 14,
                color: dim.color,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingXs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.3)
                : AppColors.lightSurfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(dim.color),
          ),
        ),
      ],
    );
  }

  Widget _buildListSection(
    BuildContext context, {
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: AppConstants.spacingSm),
            Text(
              title,
              style: AppTypography.displayFont.copyWith(
                fontSize: 18,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...items.asMap().entries.map((entry) {
          return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 7, right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: 0.6),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTypography.subtitle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(
                duration: 400.ms,
                delay: Duration(milliseconds: 500 + (entry.key * 120)),
              )
              .slideX(
                begin: 0.03,
                end: 0,
                duration: 400.ms,
                delay: Duration(milliseconds: 500 + (entry.key * 120)),
              );
        }),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ACTION BUTTONS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildRetakeButton(BuildContext context, bool isDark, bool isEn) {
    return GradientButton(
      label: L10nService.get('quiz.generic_quiz.retake_quiz', isEn ? AppLanguage.en : AppLanguage.tr),
      icon: Icons.refresh_rounded,
      onPressed: _restartQuiz,
      expanded: true,
      gradient: const LinearGradient(
        colors: [AppColors.auroraStart, AppColors.auroraEnd],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 800.ms);
  }

  Widget _buildBackToHubButton(BuildContext context, bool isDark, bool isEn) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: () => context.go(Routes.quizHub),
        child: Text(
          L10nService.get('quiz.generic_quiz.back_to_all_quizzes', isEn ? AppLanguage.en : AppLanguage.tr),
          style: AppTypography.elegantAccent(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 900.ms);
  }
}
