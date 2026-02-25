// ════════════════════════════════════════════════════════════════════════════
// ATTACHMENT QUIZ SCREEN - InnerCycles Self-Reflection Quiz
// ════════════════════════════════════════════════════════════════════════════
// A step-by-step, animated quiz flow that helps users explore their
// attachment style through thoughtful self-reflection questions.
// Framed as personal growth awareness, NOT clinical diagnosis.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/attachment_style.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/attachment_style_service.dart';
import '../../../data/services/review_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';

// ════════════════════════════════════════════════════════════════════════════
// QUIZ SCREEN
// ════════════════════════════════════════════════════════════════════════════

class AttachmentQuizScreen extends ConsumerStatefulWidget {
  const AttachmentQuizScreen({super.key});

  @override
  ConsumerState<AttachmentQuizScreen> createState() =>
      _AttachmentQuizScreenState();
}

class _AttachmentQuizScreenState extends ConsumerState<AttachmentQuizScreen> {
  final PageController _pageController = PageController();
  final List<int> _answers = [];
  int _currentPage = 0;
  bool _showResult = false;
  AttachmentQuizResult? _result;

  int get _totalPages => AttachmentStyleService.questions.length;

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

    // Short delay to show selection, then advance
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
    final serviceAsync = ref.read(attachmentStyleServiceProvider);
    final service = serviceAsync.valueOrNull;
    if (service == null) return;

    final result = service.calculateResult(_answers);
    setState(() {
      _result = result;
      _showResult = true;
    });

    // Check for review prompt after quiz completion
    try {
      final reviewService = await ref.read(reviewServiceProvider.future);
      await reviewService.checkAndPromptReview(ReviewTrigger.quizCompleted);
    } catch (e) {
      if (kDebugMode) debugPrint('Review prompt failed: $e');
    }
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
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: _showResult && _result != null
              ? _buildResultView(context, isDark, isEn)
              : _buildQuizView(context, isDark, isEn),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUIZ VIEW
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildQuizView(BuildContext context, bool isDark, bool isEn) {
    return Column(
      children: [
        // App bar area
        _buildQuizAppBar(context, isDark, isEn),

        // Progress indicator
        _buildProgressBar(isDark),
        const SizedBox(height: AppConstants.spacingMd),

        // Question number
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

        // PageView with questions
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              return _buildQuestionPage(context, index, isDark, isEn);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuizAppBar(BuildContext context, bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSm,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: isEn ? 'Back' : 'Geri',
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
              isEn ? 'Attachment Style' : 'Bağlanma Stili',
              textAlign: TextAlign.center,
              style: AppTypography.displayFont.copyWith(
                fontSize: 22,
                color: AppColors.starGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48), // balance the back button
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
    int index,
    bool isDark,
    bool isEn,
  ) {
    final question = AttachmentStyleService.questions[index];
    final questionText = isEn ? question.questionEn : question.questionTr;
    final options = isEn ? question.optionsEn : question.optionsTr;

    // Ordered list of styles for consistent mapping
    final styleOrder = [
      AttachmentStyle.secure,
      AttachmentStyle.anxiousPreoccupied,
      AttachmentStyle.dismissiveAvoidant,
      AttachmentStyle.fearfulAvoidant,
    ];

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
              // Question text
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

              // Option cards
              ...List.generate(styleOrder.length, (optionIndex) {
                final style = styleOrder[optionIndex];
                final optionText = options[style] ?? '';
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
              // Selection indicator
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
              // Option text
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

  Widget _buildResultView(BuildContext context, bool isDark, bool isEn) {
    final result = _result!;
    final style = result.attachmentStyle;

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // App bar
          GlassSliverAppBar(title: isEn ? 'Your Reflection' : 'Yansımanız'),

          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Disclaimer
                _buildDisclaimer(context, isDark, isEn),
                const SizedBox(height: AppConstants.spacingXl),

                // Primary style card
                _buildPrimaryStyleCard(context, style, result, isDark, isEn),
                const SizedBox(height: AppConstants.spacingXl),

                // Percentage breakdown
                _buildPercentageBreakdown(context, result, isDark, isEn),
                const SizedBox(height: AppConstants.spacingXl),

                // Strengths
                _buildListSection(
                  context,
                  title: isEn ? 'Your Strengths' : 'Güçlü Yanlarınız',
                  items: isEn ? style.strengthsEn : style.strengthsTr,
                  icon: Icons.star_rounded,
                  color: AppColors.starGold,
                  isDark: isDark,
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Growth areas
                _buildListSection(
                  context,
                  title: isEn ? 'Growth Areas' : 'Gelişim Alanları',
                  items: isEn ? style.growthAreasEn : style.growthAreasTr,
                  icon: Icons.spa_rounded,
                  color: AppColors.amethyst,
                  isDark: isDark,
                ),
                const SizedBox(height: AppConstants.spacingXxl),

                // Action buttons
                _buildShareButton(context, isDark, isEn),
                const SizedBox(height: AppConstants.spacingMd),
                _buildGoDeeperButton(context, isDark, isEn),
                const SizedBox(height: AppConstants.spacingMd),
                _buildRetakeButton(context, isDark, isEn),
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

  Widget _buildPrimaryStyleCard(
    BuildContext context,
    AttachmentStyle style,
    AttachmentQuizResult result,
    bool isDark,
    bool isEn,
  ) {
    final percentage = (result.percentageFor(style) * 100).toStringAsFixed(0);

    return Container(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                style.color.withValues(alpha: 0.25),
                style.color.withValues(alpha: 0.10),
              ],
            ),
            border: Border.all(
              color: style.color.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // Style icon
              AppSymbol.hero(style.emojiIcon),
              const SizedBox(height: AppConstants.spacingMd),

              // Style name
              Text(
                isEn ? style.displayNameEn : style.displayNameTr,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 20,
                  color: style.color,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingXs),

              // Percentage
              Text(
                '$percentage%',
                style: AppTypography.modernAccent(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: style.color.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Description
              Text(
                isEn ? style.descriptionEn : style.descriptionTr,
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
    AttachmentQuizResult result,
    bool isDark,
    bool isEn,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'Full Breakdown' : 'Detaylı Dağılım',
          style: AppTypography.displayFont.copyWith(
            fontSize: 18,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),
        ...AttachmentStyle.values.map((style) {
          final percentage = result.percentageFor(style);
          final percentText = '${(percentage * 100).toStringAsFixed(0)}%';
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
            child: _buildPercentageRow(
              context,
              style: style,
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
    required AttachmentStyle style,
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
                isEn ? style.displayNameEn : style.displayNameTr,
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
                color: style.color,
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
            valueColor: AlwaysStoppedAnimation<Color>(style.color),
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

  Widget _buildShareButton(BuildContext context, bool isDark, bool isEn) {
    return GradientButton(
      label: isEn ? 'Share Your Result' : 'Sonucunu Paylaş',
      icon: Icons.share_rounded,
      onPressed: () {
        if (_result == null) return;
        final style = _result!.attachmentStyle;
        final pct = (_result!.percentageFor(style) * 100).toStringAsFixed(0);
        final text = isEn
            ? 'I discovered my attachment style: ${style.displayNameEn} ($pct%)\n\nUnderstanding your patterns is the first step to growth.\n\nExplore yours with InnerCycles'
            : 'Bağlanma stilimi keşfettim: ${style.displayNameTr} (%$pct)\n\nKalıplarını anlamak büyümenin ilk adımıdır.\n\nInnerCycles ile keşfet';
        SharePlus.instance.share(ShareParams(text: text));
      },
      expanded: true,
      gradient: const LinearGradient(
        colors: [AppColors.auroraStart, AppColors.auroraEnd],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 800.ms);
  }

  Widget _buildGoDeeperButton(BuildContext context, bool isDark, bool isEn) {
    return GradientOutlinedButton(
      label: isEn ? 'Go Deeper - Premium' : 'Derine İn - Premium',
      icon: Icons.auto_awesome,
      variant: GradientTextVariant.gold,
      expanded: true,
      fontSize: 16,
      borderRadius: AppConstants.radiusLg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      onPressed: () {
        showContextualPaywall(
          context,
          ref,
          paywallContext: PaywallContext.general,
        );
      },
    ).animate().fadeIn(duration: 500.ms, delay: 900.ms);
  }

  Widget _buildRetakeButton(BuildContext context, bool isDark, bool isEn) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: _restartQuiz,
        child: Text(
          isEn ? 'Retake Quiz' : 'Testi Tekrarla',
          style: AppTypography.elegantAccent(fontSize: 15, color: AppColors.textSecondary),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 1000.ms);
  }
}
