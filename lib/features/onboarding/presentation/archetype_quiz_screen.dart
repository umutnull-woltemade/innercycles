// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE QUIZ SCREEN - Post-onboarding quick personality reveal
// ════════════════════════════════════════════════════════════════════════════
// 5 quick questions that determine the user's initial archetype.
// Drives immediate engagement + shareable result card.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/theme/liquid_glass/glass_tokens.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/archetype_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';

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
    questionEn: 'When you have free time, you tend to...',
    questionTr: 'Boş zamanın olduğunda genellikle...',
    options: [
      _QuizOption(
        textEn: 'Create something new',
        textTr: 'Yeni bir şey yaratırsın',
        scores: {'creator': 3, 'magician': 1},
      ),
      _QuizOption(
        textEn: 'Explore somewhere unfamiliar',
        textTr: 'Tanımadığın bir yeri keşfedersin',
        scores: {'explorer': 3, 'hero': 1},
      ),
      _QuizOption(
        textEn: 'Learn or read something deep',
        textTr: 'Derin bir şey öğrenirsin',
        scores: {'sage': 3, 'ruler': 1},
      ),
      _QuizOption(
        textEn: 'Spend time with people you love',
        textTr: 'Sevdiğin insanlarla vakit geçirirsin',
        scores: {'lover': 2, 'caregiver': 2},
      ),
    ],
  ),
  _QuizQuestion(
    questionEn: 'In a group, you naturally become the person who...',
    questionTr: 'Bir grupta doğal olarak... olan kişi olursun',
    options: [
      _QuizOption(
        textEn: 'Takes charge and organizes',
        textTr: 'Kontrolü alır ve organize eder',
        scores: {'ruler': 3, 'hero': 1},
      ),
      _QuizOption(
        textEn: 'Makes everyone laugh',
        textTr: 'Herkesi güldürür',
        scores: {'jester': 3, 'innocent': 1},
      ),
      _QuizOption(
        textEn: 'Listens and gives advice',
        textTr: 'Dinler ve tavsiye verir',
        scores: {'caregiver': 2, 'sage': 2},
      ),
      _QuizOption(
        textEn: 'Challenges the usual way of thinking',
        textTr: 'Alışıldık düşünce tarzını sorgular',
        scores: {'rebel': 3, 'magician': 1},
      ),
    ],
  ),
  _QuizQuestion(
    questionEn:
        'When facing a difficult situation, your first instinct is to...',
    questionTr: 'Zor bir durumla karşılaştığında ilk içgüdün...',
    options: [
      _QuizOption(
        textEn: 'Face it head-on with courage',
        textTr: 'Cesaretle yüzyüze gelmek',
        scores: {'hero': 3, 'rebel': 1},
      ),
      _QuizOption(
        textEn: 'Analyze and find a clever solution',
        textTr: 'Analiz edip akıllıca bir çözüm bulmak',
        scores: {'sage': 2, 'magician': 2},
      ),
      _QuizOption(
        textEn: 'Support others through it first',
        textTr: 'Önce başkalarını desteklemek',
        scores: {'caregiver': 3, 'lover': 1},
      ),
      _QuizOption(
        textEn: 'Trust that things will work out',
        textTr: 'İşlerin yoluna gireceğine güven',
        scores: {'innocent': 3, 'orphan': 1},
      ),
    ],
  ),
  _QuizQuestion(
    questionEn: 'What drives you most in life?',
    questionTr: 'Hayatta seni en çok ne motive eder?',
    options: [
      _QuizOption(
        textEn: 'Freedom and self-expression',
        textTr: 'Özgürlük ve kendini ifade etmek',
        scores: {'creator': 2, 'explorer': 2},
      ),
      _QuizOption(
        textEn: 'Making a meaningful impact',
        textTr: 'Anlamlı bir etki bırakmak',
        scores: {'hero': 2, 'ruler': 2},
      ),
      _QuizOption(
        textEn: 'Deep connections with others',
        textTr: 'Başkalarla derin bağlar kurmak',
        scores: {'lover': 3, 'orphan': 1},
      ),
      _QuizOption(
        textEn: 'Transforming and reinventing yourself',
        textTr: 'Dönüşmek ve kendini yeniden keşfetmek',
        scores: {'magician': 3, 'rebel': 1},
      ),
    ],
  ),
  _QuizQuestion(
    questionEn: 'Your happiest moments tend to be when...',
    questionTr: 'En mutlu anların genellikle...',
    options: [
      _QuizOption(
        textEn: 'You achieve something challenging',
        textTr: 'Zor bir şeyi başardığın zamanlar',
        scores: {'hero': 2, 'ruler': 2},
      ),
      _QuizOption(
        textEn: 'You feel completely at peace',
        textTr: 'Tamamen huzurlu hissettiğin zamanlar',
        scores: {'innocent': 2, 'sage': 2},
      ),
      _QuizOption(
        textEn: 'You help someone in a real way',
        textTr: 'Birine gerçekten yardım ettiğin zamanlar',
        scores: {'caregiver': 3, 'orphan': 1},
      ),
      _QuizOption(
        textEn: 'You discover something new about yourself',
        textTr: 'Kendinde yeni bir şey keşfettiğin zamanlar',
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
    } catch (_) {
      // Non-critical — continue even if save fails
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

  Widget _buildQuestion(bool isDark, bool isEn) {
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
                isEn ? 'Skip' : 'Atla',
                style: TextStyle(
                  color: AppColors.textMuted.withValues(alpha: 0.7),
                  fontSize: 14,
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
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),

          const SizedBox(height: 32),

          // Question
          Text(
            isEn ? question.questionEn : question.questionTr,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              height: 1.3,
            ),
          ).glassEntrance(context: context),

          const SizedBox(height: 32),

          // Options
          ...List.generate(question.options.length, (index) {
            final option = question.options[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => _selectOption(option),
                child: GlassPanel(
                  elevation: GlassElevation.g2,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(14),
                  child: Text(
                    isEn ? option.textEn : option.textTr,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
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

  Widget _buildResult(bool isDark, bool isEn) {
    if (_result == null) {
      return const Center(child: CosmicLoadingIndicator());
    }

    final archetype = _result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Emoji
          Text(
            archetype.emoji,
            style: const TextStyle(fontSize: 64),
          ).glassReveal(context: context),

          const SizedBox(height: 16),

          // Title
          Text(
            isEn ? 'Your Inner Archetype' : 'İç Arketipin',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.starGold,
              letterSpacing: 1.5,
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 300),
          ),

          const SizedBox(height: 8),

          // Archetype name
          Text(
            archetype.getName(isEnglish: isEn),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
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
            style: TextStyle(
              fontSize: 15,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              height: 1.5,
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
                Text(
                  isEn ? 'Your Strengths' : 'Güçlü Yönlerin',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.starGold,
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
                                style: TextStyle(
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
                Text(
                  isEn ? 'Growth Tip' : 'Büyüme İpucu',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cosmicPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  archetype.getGrowthTip(isEnglish: isEn),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    height: 1.4,
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
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _goHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.starGold,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                isEn ? 'Start Your Journey' : 'Yolculuğuna Başla',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 800),
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: _goHome,
            child: Text(
              isEn ? 'Skip for now' : 'Şimdilik atla',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
