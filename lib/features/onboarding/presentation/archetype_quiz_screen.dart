// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE QUIZ SCREEN - Post-onboarding quick personality reveal
// ════════════════════════════════════════════════════════════════════════════
// 5 quick questions that determine the user's initial archetype.
// Drives immediate engagement + shareable result card.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/theme/liquid_glass/glass_tokens.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/archetype_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// QUIZ DATA
// ════════════════════════════════════════════════════════════════════════════

class _QuizQuestion {
  final String questionEn;
  final String questionTr;
  final List<_QuizOption> options;

  const _QuizQuestion({
    required this.questionEn,
    required this.questionTr,
    required this.options,
  });
}

class _QuizOption {
  final String textEn;
  final String textTr;
  final Map<String, int> scores; // archetypeId -> weight

  const _QuizOption({
    required this.textEn,
    required this.textTr,
    required this.scores,
  });
}

const List<_QuizQuestion> _questions = [
  _QuizQuestion(
    questionEn: "It's 2 AM and you can't sleep. You...",
    questionTr: 'Gece 2, uyuyamıyorsun. Ne yaparsın?',
    options: [
      _QuizOption(
        textEn: 'Start a project nobody asked for',
        textTr: 'Kimsenin istemediği bir projeye başlarsın',
        scores: {'creator': 3, 'magician': 1},
      ),
      _QuizOption(
        textEn: 'Go for a walk in the dark',
        textTr: 'Karanlıkta yürüyüşe çıkarsın',
        scores: {'explorer': 3, 'hero': 1},
      ),
      _QuizOption(
        textEn: 'Fall into a Wikipedia rabbit hole',
        textTr: "Wikipedia'da kaybolursun",
        scores: {'sage': 3, 'ruler': 1},
      ),
      _QuizOption(
        textEn: 'Text someone "are you awake?"',
        textTr: '"Uyuyor musun?" diye mesaj atarsın',
        scores: {'lover': 2, 'caregiver': 2},
      ),
    ],
  ),
  _QuizQuestion(
    questionEn: 'Your friend group secretly thinks you are...',
    questionTr: 'Arkadaş grubu seni gizlice... sanıyor',
    options: [
      _QuizOption(
        textEn: 'The one who always has a plan',
        textTr: 'Her zaman planı olan kişi',
        scores: {'ruler': 3, 'hero': 1},
      ),
      _QuizOption(
        textEn: 'The chaos they need',
        textTr: 'İhtiyaç duydukları kaos',
        scores: {'jester': 3, 'innocent': 1},
      ),
      _QuizOption(
        textEn: 'The one everyone vents to',
        textTr: 'Herkesin dert yandığı kişi',
        scores: {'caregiver': 2, 'sage': 2},
      ),
      _QuizOption(
        textEn: 'The one who says what everyone thinks',
        textTr: 'Herkesin düşündüğünü söyleyen kişi',
        scores: {'rebel': 3, 'magician': 1},
      ),
    ],
  ),
  _QuizQuestion(
    questionEn: 'A stranger gives you a mysterious envelope. You...',
    questionTr: 'Bir yabancı sana gizemli bir zarf veriyor. Sen...',
    options: [
      _QuizOption(
        textEn: 'Rip it open immediately',
        textTr: 'Anında açarsın',
        scores: {'hero': 3, 'rebel': 1},
      ),
      _QuizOption(
        textEn: 'Hold it up to the light first',
        textTr: 'Önce ışığa tutarsın',
        scores: {'sage': 2, 'magician': 2},
      ),
      _QuizOption(
        textEn: 'Ask if they need help before looking',
        textTr: 'Bakmadan önce yardıma ihtiyacı var mı sorarsın',
        scores: {'caregiver': 3, 'lover': 1},
      ),
      _QuizOption(
        textEn: "Assume it's probably fine",
        textTr: 'Bir şey olmaz diye düşünürsün',
        scores: {'innocent': 3, 'orphan': 1},
      ),
    ],
  ),
  _QuizQuestion(
    questionEn: 'Pick a superpower. No overthinking.',
    questionTr: 'Bir süper güç seç. Fazla düşünme.',
    options: [
      _QuizOption(
        textEn: 'Shapeshifting — become anyone',
        textTr: 'Şekil değiştirme — herkes olabilmek',
        scores: {'creator': 2, 'explorer': 2},
      ),
      _QuizOption(
        textEn: 'Time control — rewrite moments',
        textTr: 'Zaman kontrolü — anları yeniden yazmak',
        scores: {'hero': 2, 'ruler': 2},
      ),
      _QuizOption(
        textEn: 'Telepathy — feel what others feel',
        textTr: 'Telepati — başkalarının hissettiklerini hissetmek',
        scores: {'lover': 3, 'orphan': 1},
      ),
      _QuizOption(
        textEn: 'Teleportation — vanish and reappear',
        textTr: 'Işınlanma — kaybolup tekrar belirmek',
        scores: {'magician': 3, 'rebel': 1},
      ),
    ],
  ),
  _QuizQuestion(
    questionEn: 'What would your autobiography be called?',
    questionTr: 'Otobiyografinin adı ne olurdu?',
    options: [
      _QuizOption(
        textEn: '"I Did It My Way (And It Worked)"',
        textTr: '"Kendi Yolumdan Gittim (Ve İşe Yaradı)"',
        scores: {'hero': 2, 'ruler': 2},
      ),
      _QuizOption(
        textEn: '"The Art of Doing Nothing Beautifully"',
        textTr: '"Güzelce Hiçbir Şey Yapma Sanatı"',
        scores: {'innocent': 2, 'sage': 2},
      ),
      _QuizOption(
        textEn: '"Everyone Else First: A Memoir"',
        textTr: '"Önce Herkes: Bir Anı"',
        scores: {'caregiver': 3, 'orphan': 1},
      ),
      _QuizOption(
        textEn: '"Wait, Who Am I Again?"',
        textTr: '"Dur, Ben Kimim?"',
        scores: {'explorer': 2, 'magician': 2},
      ),
    ],
  ),
];

// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE QUIZ SCREEN
// ════════════════════════════════════════════════════════════════════════════

class ArchetypeQuizScreen extends ConsumerStatefulWidget {
  const ArchetypeQuizScreen({super.key});

  @override
  ConsumerState<ArchetypeQuizScreen> createState() =>
      _ArchetypeQuizScreenState();
}

class _ArchetypeQuizScreenState extends ConsumerState<ArchetypeQuizScreen> {
  int _currentQuestion = 0;
  final Map<String, int> _scores = {};
  Archetype? _result;
  bool _showResult = false;

  void _selectOption(_QuizOption option) {
    HapticFeedback.lightImpact();

    // Accumulate scores
    for (final entry in option.scores.entries) {
      _scores[entry.key] = (_scores[entry.key] ?? 0) + entry.value;
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() => _currentQuestion++);
    } else {
      _computeResult();
    }
  }

  void _computeResult() {
    // Find the archetype with the highest score
    String? topId;
    int topScore = 0;
    for (final entry in _scores.entries) {
      if (entry.value > topScore) {
        topScore = entry.value;
        topId = entry.key;
      }
    }

    if (topId != null) {
      _result = ArchetypeService.archetypes.firstWhere(
        (a) => a.id == topId,
        orElse: () => ArchetypeService.archetypes.first,
      );

      // Save the archetype to the service
      _saveArchetype(topId);
    }

    setState(() => _showResult = true);
  }

  Future<void> _saveArchetype(String archetypeId) async {
    try {
      final service = await ref.read(archetypeServiceProvider.future);
      await service.setInitialArchetype(archetypeId);
    } catch (e) {
      if (kDebugMode) debugPrint('ArchetypeQuiz: save error: $e');
    }
  }

  void _skipQuiz() {
    context.go(Routes.today);
  }

  void _goHome() {
    HapticFeedback.mediumImpact();
    context.go(Routes.today);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: _showResult
              ? _buildResult(isDark, isEn)
              : _buildQuestion(isDark, isEn),
        ),
      ),
    );
  }

  Widget _buildQuestion(bool isDark, AppLanguage language) {
    final question = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skip button
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: _skipQuiz,
              child: Text(
                L10nService.get('onboarding.archetype_quiz.skip', language),
                style: AppTypography.elegantAccent(
                  fontSize: 14,
                  color: AppColors.textMuted.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.starGold,
              ),
              minHeight: 4,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '${_currentQuestion + 1}/${_questions.length}',
            style: AppTypography.elegantAccent(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),

          const SizedBox(height: 32),

          // Question
          GradientText(
            isEn ? question.questionEn : question.questionTr,
            variant: GradientTextVariant.aurora,
            style: AppTypography.displayFont.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ).glassEntrance(context: context),

          const SizedBox(height: 32),

          // Options
          ...List.generate(question.options.length, (index) {
            final option = question.options[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Semantics(
                label: isEn ? option.textEn : option.textTr,
                button: true,
                child: GestureDetector(
                  onTap: () => _selectOption(option),
                  child: GlassPanel(
                    elevation: GlassElevation.g2,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    borderRadius: BorderRadius.circular(14),
                    child: Text(
                      isEn ? option.textEn : option.textTr,
                      style: AppTypography.subtitle(
                        fontSize: 16,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ).glassListItem(context: context, index: index);
          }),
        ],
      ),
    );
  }

  Widget _buildResult(bool isDark, AppLanguage language) {
    if (_result == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CosmicLoadingIndicator(),
            const SizedBox(height: 12),
            Text(
              L10nService.get('onboarding.archetype_quiz.discovering_your_archetype', language),
              style: AppTypography.subtitle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      );
    }

    final archetype = _result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Emoji
          AppSymbol.hero(archetype.emoji).glassReveal(context: context),

          const SizedBox(height: 16),

          // Title
          Text(
            L10nService.get('onboarding.archetype_quiz.your_inner_archetype', language),
            style: AppTypography.elegantAccent(
              fontSize: 14,
              color: AppColors.starGold,
              letterSpacing: 1.5,
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 300),
          ),

          const SizedBox(height: 8),

          // Archetype name
          GradientText(
            archetype.getName(isEnglish: isEn),
            variant: GradientTextVariant.cosmic,
            style: AppTypography.displayFont.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 400),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            archetype.getDescription(isEnglish: isEn),
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 15,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 500),
          ),

          const SizedBox(height: 28),

          // Strengths card
          GlassPanel(
            elevation: GlassElevation.g3,
            glowColor: GlassTokens.glowGold,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  L10nService.get('onboarding.archetype_quiz.your_strengths', language),
                  variant: GradientTextVariant.gold,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...archetype
                    .getStrengths(isEnglish: isEn)
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.starGold,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                s,
                                style: AppTypography.subtitle(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 600),
          ),

          const SizedBox(height: 16),

          // Growth tip card
          GlassPanel(
            elevation: GlassElevation.g3,
            glowColor: GlassTokens.glowAmethyst,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  L10nService.get('onboarding.archetype_quiz.growth_tip', language),
                  variant: GradientTextVariant.amethyst,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  archetype.getGrowthTip(isEnglish: isEn),
                  style: AppTypography.decorativeScript(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 700),
          ),

          const SizedBox(height: 32),

          // Continue button
          GradientButton.gold(
            label: L10nService.get('onboarding.archetype_quiz.get_started', language),
            onPressed: _goHome,
            expanded: true,
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 800),
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: _goHome,
            child: Text(
              L10nService.get('onboarding.archetype_quiz.skip_for_now', language),
              style: AppTypography.elegantAccent(
                fontSize: 14,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
