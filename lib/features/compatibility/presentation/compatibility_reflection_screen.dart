// ════════════════════════════════════════════════════════════════════════════
// COMPATIBILITY REFLECTION SCREEN - InnerCycles Relationship Self-Reflection
// ════════════════════════════════════════════════════════════════════════════
// Three-state screen:
//   1. Profile list   — saved reflections with scores
//   2. New profile     — step-by-step question flow with progress
//   3. Result view     — radar chart, dimension insights, overall reflection
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/compatibility_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

// ════════════════════════════════════════════════════════════════════════════
// SCREEN
// ════════════════════════════════════════════════════════════════════════════

class CompatibilityReflectionScreen extends ConsumerStatefulWidget {
  const CompatibilityReflectionScreen({super.key});

  @override
  ConsumerState<CompatibilityReflectionScreen> createState() =>
      _CompatibilityReflectionScreenState();
}

class _CompatibilityReflectionScreenState
    extends ConsumerState<CompatibilityReflectionScreen> {
  // ── State ──────────────────────────────────────────────────────
  _ScreenMode _mode = _ScreenMode.profileList;
  List<CompatibilityProfile> _profiles = [];
  bool _loading = true;

  // New-profile flow state
  final TextEditingController _nameController = TextEditingController();
  RelationshipType _selectedType = RelationshipType.partner;
  CompatibilityProfile? _activeProfile;
  int _currentQuestion = 0;
  final List<int> _pendingAnswers = [];
  final PageController _pageController = PageController();

  // Result state
  CompatibilityProfile? _viewingProfile;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DATA
  // ══════════════════════════════════════════════════════════════════════════

  Future<CompatibilityService?> _getService() async {
    final serviceAsync = ref.read(compatibilityServiceProvider);
    return serviceAsync.valueOrNull;
  }

  Future<void> _loadProfiles() async {
    setState(() => _loading = true);
    final service = await _getService();
    if (service != null && mounted) {
      final profiles = await service.getProfiles();
      setState(() {
        _profiles = profiles;
        _loading = false;
      });
    } else if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _startNewProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final service = await _getService();
    if (service == null) return;

    final profile = await service.createProfile(name, _selectedType);
    setState(() {
      _activeProfile = profile;
      _pendingAnswers.clear();
      _currentQuestion = 0;
      _mode = _ScreenMode.questionFlow;
    });

    HapticFeedback.mediumImpact();
  }

  void _answerQuestion(int answerIndex) {
    if (_pendingAnswers.length > _currentQuestion) {
      _pendingAnswers[_currentQuestion] = answerIndex;
    } else {
      _pendingAnswers.add(answerIndex);
    }

    setState(() {});
    HapticFeedback.lightImpact();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      if (_currentQuestion < 9) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _finishQuiz();
      }
    });
  }

  Future<void> _finishQuiz() async {
    if (_activeProfile == null) return;
    final service = await _getService();
    if (service == null) return;

    // Save all answers
    for (int i = 0; i < _pendingAnswers.length; i++) {
      await service.answerQuestion(_activeProfile!.id, i, _pendingAnswers[i]);
    }

    // Calculate scores
    final result = await service.calculateScores(_activeProfile!.id);

    // Reload profile with result
    final profiles = await service.getProfiles();
    final updated = profiles.firstWhere((p) => p.id == _activeProfile!.id);

    setState(() {
      _profiles = profiles;
      _viewingProfile = updated;
      _mode = _ScreenMode.resultView;
    });

    HapticFeedback.heavyImpact();
    // ignore: unused_local_variable
    final _ = result; // result is stored in the profile
  }

  Future<void> _deleteProfile(String id) async {
    final service = await _getService();
    if (service == null) return;
    await service.deleteProfile(id);
    await _loadProfiles();
    HapticFeedback.mediumImpact();
  }

  void _viewResult(CompatibilityProfile profile) {
    setState(() {
      _viewingProfile = profile;
      _mode = _ScreenMode.resultView;
    });
  }

  void _backToList() {
    setState(() {
      _mode = _ScreenMode.profileList;
      _viewingProfile = null;
      _activeProfile = null;
      _nameController.clear();
      _pendingAnswers.clear();
      _currentQuestion = 0;
    });
    _loadProfiles();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    // Watch the provider to trigger rebuilds on init
    ref.watch(compatibilityServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: switch (_mode) {
            _ScreenMode.profileList =>
              _buildProfileList(context, isDark, isEn),
            _ScreenMode.createProfile =>
              _buildCreateProfile(context, isDark, isEn),
            _ScreenMode.questionFlow =>
              _buildQuestionFlow(context, isDark, isEn),
            _ScreenMode.resultView =>
              _buildResultView(context, isDark, isEn),
          },
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE 1 — PROFILE LIST
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildProfileList(BuildContext context, bool isDark, bool isEn) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Relationship Reflections' : 'Iliski Yansimalari',
        ),
        if (_loading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_profiles.isEmpty)
          SliverFillRemaining(
            child: _buildEmptyState(context, isDark, isEn),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header text
                Text(
                  isEn
                      ? 'Explore how you experience your relationships'
                      : 'Iliskilerinizi nasil deneyimlediginizi kesfedin',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 20),

                // Profile cards
                ..._profiles.asMap().entries.map((entry) {
                  final profile = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ProfileCard(
                      profile: profile,
                      isDark: isDark,
                      isEn: isEn,
                      onTap: () {
                        if (profile.result != null) {
                          _viewResult(profile);
                        }
                      },
                      onDelete: () => _deleteProfile(profile.id),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: Duration(milliseconds: 100 + entry.key * 80),
                      )
                      .slideY(
                        begin: 0.05,
                        end: 0,
                        duration: 400.ms,
                        delay: Duration(milliseconds: 100 + entry.key * 80),
                      );
                }),

                const SizedBox(height: 24),

                // New reflection button
                _buildNewReflectionButton(context, isDark, isEn),
                const SizedBox(height: 40),
              ]),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 72,
            color: AppColors.auroraStart.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            isEn ? 'Reflect on Your Relationships' : 'Iliskileriniz Uzerine Dusunun',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isEn
                ? 'Create a reflection profile for someone in your life and explore how you experience the relationship through 10 guided questions.'
                : 'Hayatınızdaki biri için bir yansıma profili oluşturun ve 10 rehberli soru aracılığıyla ilişkiyi nasıl deneyimlediğinizi keşfedin.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildNewReflectionButton(context, isDark, isEn),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildNewReflectionButton(
      BuildContext context, bool isDark, bool isEn) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _mode = _ScreenMode.createProfile;
            _nameController.clear();
            _selectedType = RelationshipType.partner;
          });
        },
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(
          isEn ? 'New Reflection' : 'Yeni Yansima',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.auroraStart,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE 1.5 — CREATE PROFILE (name + type selection)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildCreateProfile(BuildContext context, bool isDark, bool isEn) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'New Reflection' : 'Yeni Yansima',
          showBackButton: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),

              // Person's name
              Text(
                isEn
                    ? 'Who would you like to reflect on?'
                    : 'Kimin uzerine dusunmek istersiniz?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 16),

              // Name input
              TextField(
                controller: _nameController,
                autofocus: true,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: isEn ? 'Their name or initials' : 'Adi veya bas harfleri',
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.surfaceDark.withValues(alpha: 0.6)
                      : AppColors.lightSurfaceVariant.withValues(alpha: 0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.auroraStart,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 28),

              // Relationship type
              Text(
                isEn ? 'Relationship type' : 'Iliski turu',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
              const SizedBox(height: 12),

              // Type chips
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: RelationshipType.values.map((type) {
                  final selected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(
                      isEn ? type.displayNameEn : type.displayNameTr,
                    ),
                    selected: selected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedType = type);
                      HapticFeedback.selectionClick();
                    },
                    selectedColor: AppColors.auroraStart.withValues(alpha: 0.3),
                    backgroundColor: isDark
                        ? AppColors.surfaceDark.withValues(alpha: 0.6)
                        : AppColors.lightSurfaceVariant,
                    labelStyle: TextStyle(
                      color: selected
                          ? AppColors.auroraStart
                          : isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: selected
                          ? AppColors.auroraStart.withValues(alpha: 0.6)
                          : Colors.transparent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              const SizedBox(height: 36),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'This is a personal reflection tool. It helps you explore how you experience this relationship — not a judgment of the other person.'
                            : 'Bu kişisel bir yansıtma aracıdır. Bu ilişkiyi nasıl deneyimlediğinizi keşfetmenize yardımcı olur — diğer kişinin bir yargılaması değil.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.7),
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
              const SizedBox(height: 28),

              // Begin button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nameController.text.trim().isNotEmpty
                      ? _startNewProfile
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.auroraStart,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: isDark
                        ? AppColors.surfaceLight.withValues(alpha: 0.3)
                        : AppColors.lightSurfaceVariant,
                    disabledForegroundColor: AppColors.textMuted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEn ? 'Begin Reflection' : 'Yansimaya Basla',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE 2 — QUESTION FLOW
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildQuestionFlow(BuildContext context, bool isDark, bool isEn) {
    final questions = CompatibilityService.getReflectionQuestions();

    return Column(
      children: [
        // Top bar with back + progress
        _buildQuizTopBar(context, isDark, isEn),

        // Progress indicator
        _buildProgressBar(isDark),
        const SizedBox(height: 12),

        // Question number
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            isEn
                ? 'Question ${_currentQuestion + 1} of 10'
                : 'Soru ${_currentQuestion + 1} / 10',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        const SizedBox(height: 8),

        // Dimension label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _dimensionColor(questions[_currentQuestion].dimension)
                  .withValues(alpha: 0.15),
            ),
            child: Text(
              _dimensionLabel(
                  questions[_currentQuestion].dimension, isEn),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _dimensionColor(
                        questions[_currentQuestion].dimension),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // PageView with questions
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() => _currentQuestion = page);
            },
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return _buildQuestionPage(
                context,
                questions[index],
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

  Widget _buildQuizTopBar(BuildContext context, bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_currentQuestion > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                );
              } else {
                _backToList();
              }
            },
            icon: Icon(
              Icons.chevron_left,
              size: 28,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          Expanded(
            child: Text(
              _activeProfile?.name ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
    final progress = (_currentQuestion + 1) / 10;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.3)
              : AppColors.lightSurfaceVariant,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppColors.auroraStart),
        ),
      ),
    )
        .animate(key: ValueKey(_currentQuestion))
        .fadeIn(duration: 300.ms)
        .scaleX(begin: 0.95, end: 1.0, duration: 300.ms);
  }

  Widget _buildQuestionPage(
    BuildContext context,
    ReflectionQuestion question,
    int index,
    bool isDark,
    bool isEn,
  ) {
    final questionText = isEn ? question.questionEn : question.questionTr;
    final selectedAnswer =
        _pendingAnswers.length > index ? _pendingAnswers[index] : -1;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Question text
              Text(
                questionText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: -0.1, end: 0, duration: 500.ms),
              const SizedBox(height: 24),

              // Options
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final isSelected = selectedAnswer == optionIndex;
                final optionText = isEn ? option.textEn : option.textTr;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildOptionCard(
                    context,
                    text: optionText,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () => _answerQuestion(optionIndex),
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: Duration(milliseconds: 200 + (optionIndex * 80)),
                    )
                    .slideX(
                      begin: 0.05,
                      end: 0,
                      duration: 400.ms,
                      delay: Duration(milliseconds: 200 + (optionIndex * 80)),
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
    required String text,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
            // Selection circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2, right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.auroraStart
                      : AppColors.textSecondary.withValues(alpha: 0.5),
                  width: 2,
                ),
                color: isSelected ? AppColors.auroraStart : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE 3 — RESULT VIEW
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildResultView(BuildContext context, bool isDark, bool isEn) {
    final profile = _viewingProfile;
    if (profile == null || profile.result == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final result = profile.result!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: profile.name,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Overall score card
              _buildOverallScoreCard(context, result, profile, isDark, isEn),
              const SizedBox(height: 24),

              // Radar chart
              _buildRadarChart(context, result, isDark, isEn),
              const SizedBox(height: 24),

              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? AppColors.surfaceDark.withValues(alpha: 0.6)
                      : AppColors.lightSurfaceVariant.withValues(alpha: 0.7),
                ),
                child: Text(
                  isEn ? result.summaryEn : result.summaryTr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
              const SizedBox(height: 24),

              // Dimension insights
              Text(
                isEn ? 'Dimension Insights' : 'Boyut Icegoruleri',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
              const SizedBox(height: 12),

              ...result.dimensions.asMap().entries.map((entry) {
                final dim = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildDimensionCard(context, dim, isDark, isEn),
                )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: Duration(milliseconds: 500 + entry.key * 100),
                    )
                    .slideY(
                      begin: 0.03,
                      end: 0,
                      duration: 400.ms,
                      delay: Duration(milliseconds: 500 + entry.key * 100),
                    );
              }),

              const SizedBox(height: 24),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'This reflects how you experience this relationship today. Relationships evolve — revisit anytime.'
                            : 'Bu, bugun bu iliskiyi nasil deneyimlediginizi yansitir. Iliskiler gelisir — istediginiz zaman tekrar ziyaret edin.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.7),
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 800.ms),
              const SizedBox(height: 24),

              // Back to list button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _backToList,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  label: Text(
                    isEn ? 'Back to Reflections' : 'Yansimalara Don',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.5)
                          : AppColors.lightSurfaceVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 900.ms),
              const SizedBox(height: 48),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallScoreCard(
    BuildContext context,
    CompatibilityResult result,
    CompatibilityProfile profile,
    bool isDark,
    bool isEn,
  ) {
    final scoreColor = _scoreColor(result.overallScore);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scoreColor.withValues(alpha: 0.20),
            scoreColor.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: scoreColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Relationship type icon
          Icon(
            _typeIcon(profile.relationshipType),
            size: 40,
            color: scoreColor.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),

          // Name + type
          Text(
            profile.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn
                ? profile.relationshipType.displayNameEn
                : profile.relationshipType.displayNameTr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 16),

          // Score circle
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: result.overallScore / 100,
                    strokeWidth: 6,
                    backgroundColor: scoreColor.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation(scoreColor),
                  ),
                ),
                Text(
                  '${result.overallScore.round()}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: scoreColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn ? 'Reflection Score' : 'Yansima Puani',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms, delay: 100.ms)
        .scaleXY(begin: 0.95, end: 1.0, duration: 700.ms, delay: 100.ms);
  }

  // ── Radar Chart ───────────────────────────────────────────────

  Widget _buildRadarChart(
    BuildContext context,
    CompatibilityResult result,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.6)
            : AppColors.lightCard.withValues(alpha: 0.9),
      ),
      child: Column(
        children: [
          Text(
            isEn ? 'Dimension Overview' : 'Boyut Genel Gorunumu',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: CustomPaint(
              size: const Size(250, 250),
              painter: _RadarChartPainter(
                dimensions: result.dimensions,
                isDark: isDark,
                isEn: isEn,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: result.dimensions.map((dim) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _dimensionColor(dim.name),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_dimensionLabel(dim.name, isEn)} ${dim.score.round()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 11,
                        ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildDimensionCard(
    BuildContext context,
    CompatibilityDimension dim,
    bool isDark,
    bool isEn,
  ) {
    final color = _dimensionColor(dim.name);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.6)
            : AppColors.lightCard.withValues(alpha: 0.9),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color.withValues(alpha: 0.15),
                ),
                child: Text(
                  _dimensionLabel(dim.name, isEn),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const Spacer(),
              Text(
                '${dim.score.round()}/100',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: dim.score / 100,
              minHeight: 6,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 12),

          // Insight text
          Text(
            isEn ? dim.insightEn : dim.insightTr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  Color _scoreColor(double score) {
    if (score >= 75) return AppColors.success;
    if (score >= 50) return AppColors.auroraStart;
    if (score >= 25) return AppColors.warning;
    return AppColors.sunriseEnd;
  }

  Color _dimensionColor(String name) {
    switch (name) {
      case 'Communication':
        return AppColors.auroraStart;
      case 'Emotional':
        return AppColors.sunriseStart;
      case 'Values':
        return AppColors.starGold;
      case 'Growth':
        return AppColors.success;
      case 'Trust':
        return AppColors.amethyst;
      default:
        return AppColors.auroraStart;
    }
  }

  String _dimensionLabel(String name, bool isEn) {
    if (isEn) return name;
    switch (name) {
      case 'Communication':
        return 'Iletisim';
      case 'Emotional':
        return 'Duygusal';
      case 'Values':
        return 'Degerler';
      case 'Growth':
        return 'Gelisim';
      case 'Trust':
        return 'Guven';
      default:
        return name;
    }
  }

  IconData _typeIcon(RelationshipType type) {
    switch (type) {
      case RelationshipType.partner:
        return Icons.favorite_rounded;
      case RelationshipType.friend:
        return Icons.people_rounded;
      case RelationshipType.family:
        return Icons.home_rounded;
      case RelationshipType.colleague:
        return Icons.work_rounded;
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SCREEN MODE ENUM
// ════════════════════════════════════════════════════════════════════════════

enum _ScreenMode {
  profileList,
  createProfile,
  questionFlow,
  resultView,
}

// ════════════════════════════════════════════════════════════════════════════
// PROFILE CARD WIDGET
// ════════════════════════════════════════════════════════════════════════════

class _ProfileCard extends StatelessWidget {
  final CompatibilityProfile profile;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProfileCard({
    required this.profile,
    required this.isDark,
    required this.isEn,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasResult = profile.result != null;
    final scoreColor = hasResult ? _scoreColor(profile.overallScore) : AppColors.textMuted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.6)
              : AppColors.lightCard.withValues(alpha: 0.9),
          border: Border.all(
            color: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.3)
                : AppColors.lightSurfaceVariant,
          ),
        ),
        child: Row(
          children: [
            // Type icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scoreColor.withValues(alpha: 0.15),
              ),
              child: Icon(
                _typeIcon(profile.relationshipType),
                color: scoreColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Name + type + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${isEn ? profile.relationshipType.displayNameEn : profile.relationshipType.displayNameTr}'
                    '  \u2022  '
                    '${_formatDate(profile.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            // Score or incomplete badge
            if (hasResult)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: scoreColor.withValues(alpha: 0.15),
                ),
                child: Text(
                  '${profile.overallScore.round()}',
                  style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.textMuted.withValues(alpha: 0.15),
                ),
                child: Text(
                  isEn ? 'Incomplete' : 'Eksik',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ),

            const SizedBox(width: 8),

            // Delete button
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.textMuted.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(RelationshipType type) {
    switch (type) {
      case RelationshipType.partner:
        return Icons.favorite_rounded;
      case RelationshipType.friend:
        return Icons.people_rounded;
      case RelationshipType.family:
        return Icons.home_rounded;
      case RelationshipType.colleague:
        return Icons.work_rounded;
    }
  }

  Color _scoreColor(double score) {
    if (score >= 75) return AppColors.success;
    if (score >= 50) return AppColors.auroraStart;
    if (score >= 25) return AppColors.warning;
    return AppColors.sunriseEnd;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RADAR CHART PAINTER
// ════════════════════════════════════════════════════════════════════════════

class _RadarChartPainter extends CustomPainter {
  final List<CompatibilityDimension> dimensions;
  final bool isDark;
  final bool isEn;

  _RadarChartPainter({
    required this.dimensions,
    required this.isDark,
    required this.isEn,
  });

  static const _dimensionColors = [
    AppColors.auroraStart, // Communication
    AppColors.sunriseStart, // Emotional
    AppColors.starGold, // Values
    AppColors.success, // Growth
    AppColors.amethyst, // Trust
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 30;
    final sides = dimensions.length;
    final angleStep = (2 * math.pi) / sides;
    final startAngle = -math.pi / 2; // Start from top

    // Draw grid rings (20, 40, 60, 80, 100)
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int ring = 1; ring <= 5; ring++) {
      final ringRadius = radius * (ring / 5);
      final path = Path();
      for (int i = 0; i <= sides; i++) {
        final angle = startAngle + (i * angleStep);
        final point = Offset(
          center.dx + ringRadius * math.cos(angle),
          center.dy + ringRadius * math.sin(angle),
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // Draw axis lines
    final axisPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i < sides; i++) {
      final angle = startAngle + (i * angleStep);
      final endpoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, endpoint, axisPaint);
    }

    // Draw data polygon (filled)
    final dataPath = Path();
    final dataPoints = <Offset>[];
    for (int i = 0; i < sides; i++) {
      final angle = startAngle + (i * angleStep);
      final normalizedScore = (dimensions[i].score / 100).clamp(0.0, 1.0);
      final point = Offset(
        center.dx + radius * normalizedScore * math.cos(angle),
        center.dy + radius * normalizedScore * math.sin(angle),
      );
      dataPoints.add(point);
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();

    // Fill
    final fillPaint = Paint()
      ..color = AppColors.auroraStart.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Stroke
    final strokePaint = Paint()
      ..color = AppColors.auroraStart.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(dataPath, strokePaint);

    // Draw data points (dots)
    for (int i = 0; i < dataPoints.length; i++) {
      final color = i < _dimensionColors.length
          ? _dimensionColors[i]
          : AppColors.auroraStart;

      // Glow
      canvas.drawCircle(
        dataPoints[i],
        6,
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Dot
      canvas.drawCircle(
        dataPoints[i],
        4,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }

    // Draw labels
    for (int i = 0; i < sides; i++) {
      final angle = startAngle + (i * angleStep);
      final labelRadius = radius + 18;
      final labelCenter = Offset(
        center.dx + labelRadius * math.cos(angle),
        center.dy + labelRadius * math.sin(angle),
      );

      final label = _labelForDimension(dimensions[i].name);
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          labelCenter.dx - textPainter.width / 2,
          labelCenter.dy - textPainter.height / 2,
        ),
      );
    }
  }

  String _labelForDimension(String name) {
    if (isEn) return name;
    switch (name) {
      case 'Communication':
        return 'Iletisim';
      case 'Emotional':
        return 'Duygusal';
      case 'Values':
        return 'Degerler';
      case 'Growth':
        return 'Gelisim';
      case 'Trust':
        return 'Guven';
      default:
        return name;
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.dimensions != dimensions ||
        oldDelegate.isDark != isDark ||
        oldDelegate.isEn != isEn;
  }
}
