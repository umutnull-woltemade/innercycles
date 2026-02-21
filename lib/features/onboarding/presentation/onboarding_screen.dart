import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/theme/liquid_glass/glass_tokens.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/archetype_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../shared/widgets/birth_date_picker.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';

// ════════════════════════════════════════════════════════════════════════════
// ONBOARDING QUIZ DATA (3 key questions from archetype quiz)
// ════════════════════════════════════════════════════════════════════════════

class _QuizOption {
  final String textEn;
  final String textTr;
  final Map<String, int> scores;

  const _QuizOption({
    required this.textEn,
    required this.textTr,
    required this.scores,
  });
}

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

const List<_QuizQuestion> _onboardingQuestions = [
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
];

// ════════════════════════════════════════════════════════════════════════════
// ONBOARDING SCREEN — 5-Step Premium Flow
// ════════════════════════════════════════════════════════════════════════════
// Step 0: Identity — Name + Apple Sign-In
// Step 1: First Cycle — Focus area selection
// Step 2: Birthday — Optional date picker
// Step 3: Archetype Reveal — 3 quick questions + animated result
// Step 4: Permission + Start — Notifications + CTA
// ════════════════════════════════════════════════════════════════════════════

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Step 0: Identity
  String? _userName;

  // Step 1: Focus Area
  FocusArea? _selectedFocusArea;

  // Step 2: Birth Date
  DateTime? _selectedDate;

  // Step 3: Archetype Quiz
  int _quizQuestion = 0;
  final Map<String, int> _quizScores = {};
  Archetype? _archetypeResult;
  bool _showArchetypeResult = false;

  // Step 4: Notifications
  bool _notificationsRequested = false;

  // Double-tap guard
  bool _isCompleting = false;

  static const int _totalPages = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    HapticFeedback.lightImpact();
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _goToPage(_currentPage + 1);
    } else {
      _completeOnboarding();
    }
  }

  void _selectQuizOption(_QuizOption option) {
    HapticFeedback.lightImpact();

    for (final entry in option.scores.entries) {
      _quizScores[entry.key] = (_quizScores[entry.key] ?? 0) + entry.value;
    }

    if (_quizQuestion < _onboardingQuestions.length - 1) {
      setState(() => _quizQuestion++);
    } else {
      _computeArchetypeResult();
    }
  }

  void _computeArchetypeResult() {
    String? topId;
    int topScore = 0;
    for (final entry in _quizScores.entries) {
      if (entry.value > topScore) {
        topScore = entry.value;
        topId = entry.key;
      }
    }

    if (topId != null) {
      _archetypeResult = ArchetypeService.archetypes.firstWhere(
        (a) => a.id == topId,
        orElse: () => ArchetypeService.archetypes.first,
      );
      _saveArchetype(topId);
    }

    HapticFeedback.mediumImpact();
    setState(() => _showArchetypeResult = true);
  }

  Future<void> _saveArchetype(String archetypeId) async {
    try {
      final service = await ref.read(archetypeServiceProvider.future);
      await service.setInitialArchetype(archetypeId);
    } catch (_) {
      // Non-critical
    }
  }

  void _skipArchetypeQuiz() {
    setState(() {
      _showArchetypeResult = false;
      _archetypeResult = null;
    });
    _nextPage();
  }

  Future<void> _requestNotifications() async {
    if (kIsWeb || _notificationsRequested) return;

    setState(() => _notificationsRequested = true);
    try {
      final notifService = NotificationService();
      await notifService.initialize();
      final granted = await notifService.requestPermissions();
      if (granted) {
        await notifService.scheduleDailyReflection(hour: 9, minute: 0);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Onboarding notification setup failed: $e');
      }
    }
  }

  Future<void> _completeOnboarding() async {
    if (_isCompleting) return;
    _isCompleting = true;

    HapticFeedback.selectionClick();

    if (_userName != null && _userName!.isNotEmpty) {
      final profile = UserProfile(
        name: _userName,
        birthDate: _selectedDate ?? DateTime(2000, 1, 1),
      );

      ref.read(userProfileProvider.notifier).setProfile(profile);
      ref.read(onboardingCompleteProvider.notifier).state = true;

      await StorageService.saveUserProfile(profile);
      await StorageService.saveOnboardingComplete(true);

      // Save selected focus area preference
      if (_selectedFocusArea != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('preferred_focus_area', _selectedFocusArea!.name);
      }

      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        context.go(Routes.today);
      }
    }
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0: // Identity
        return _userName != null && _userName!.isNotEmpty;
      case 1: // Focus area
        return _selectedFocusArea != null;
      case 2: // Birth date (optional)
        return true;
      case 3: // Archetype quiz
        return _showArchetypeResult;
      case 4: // Permission + start
        return true;
      default:
        return true;
    }
  }

  // Should we show the bottom nav section (indicators + button)?
  bool _showBottomNav() {
    // Hide bottom nav during archetype quiz questions (not result)
    if (_currentPage == 3 && !_showArchetypeResult) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.deepSpace
          : AppColors.lightBackground,
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    _IdentityPage(
                      userName: _userName,
                      onNameChanged: (name) => setState(() => _userName = name),
                      onContinue: _nextPage,
                      language: language,
                    ),
                    _FirstCyclePage(
                      selectedFocusArea: _selectedFocusArea,
                      onFocusAreaSelected: (area) =>
                          setState(() => _selectedFocusArea = area),
                      language: language,
                    ),
                    _BirthdayPage(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) =>
                          setState(() => _selectedDate = date),
                      language: language,
                    ),
                    _ArchetypeRevealPage(
                      quizQuestion: _quizQuestion,
                      showResult: _showArchetypeResult,
                      result: _archetypeResult,
                      onSelectOption: _selectQuizOption,
                      onSkip: _skipArchetypeQuiz,
                      language: language,
                    ),
                    _PermissionStartPage(
                      notificationsRequested: _notificationsRequested,
                      onRequestNotifications: _requestNotifications,
                      language: language,
                    ),
                  ],
                ),
              ),
              if (_showBottomNav()) _buildBottomSection(language),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(AppLanguage language) {
    final isLastPage = _currentPage == _totalPages - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          // 5 page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_totalPages, (index) {
              final isActive = _currentPage == index;
              final isPast = index < _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.starGold
                      : isPast
                      ? AppColors.starGold.withValues(alpha: 0.47)
                      : AppColors.surfaceLight.withValues(alpha: 0.31),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          // CTA button
          GradientButton(
            label: isLastPage
                ? L10nService.get('common.start_journey', language)
                : L10nService.get('common.continue', language),
            icon: isLastPage ? Icons.auto_awesome : Icons.arrow_forward,
            width: double.infinity,
            onPressed: _canProceed() ? _nextPage : null,
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 0: IDENTITY PAGE — Name + Apple Sign-In
// ════════════════════════════════════════════════════════════════════════════

class _IdentityPage extends StatefulWidget {
  final String? userName;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onContinue;
  final AppLanguage language;

  const _IdentityPage({
    required this.userName,
    required this.onNameChanged,
    required this.onContinue,
    required this.language,
  });

  @override
  State<_IdentityPage> createState() => _IdentityPageState();
}

class _IdentityPageState extends State<_IdentityPage>
    with SingleTickerProviderStateMixin {
  bool _isAppleLoading = false;
  late AnimationController _glowController;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _glowController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
      return;
    }

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    if (!AuthService.isSupabaseInitialized) return;

    _authSubscription = AuthService.authStateChanges.listen((state) {
      if (state.event == AuthChangeEvent.signedIn && state.session != null) {
        _handleOAuthSuccess(state.session!.user);
      }
    });

    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _handleOAuthSuccess(currentUser);
      });
    }
  }

  void _handleOAuthSuccess(User user) {
    if (!mounted) return;
    final displayName =
        user.userMetadata?['full_name'] as String? ??
        user.userMetadata?['name'] as String? ??
        user.email?.split('@').first;

    _showCosmicWelcome(displayName);
  }

  void _showCosmicWelcome(String? name) {
    final cosmicGreetings = L10nService.getList(
      'greetings.cosmic_welcome',
      widget.language,
    );
    final greeting = cosmicGreetings.isNotEmpty
        ? cosmicGreetings[DateTime.now().millisecond % cosmicGreetings.length]
        : L10nService.get('greetings.cosmic_welcome', widget.language);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) {
        return _CosmicWelcomeOverlay(
          greeting: greeting,
          name: name,
          language: widget.language,
          onComplete: () {
            Navigator.of(context).pop();
            // Auto-fill name if available from OAuth
            if (name != null && name.isNotEmpty) {
              widget.onNameChanged(name);
            }
            widget.onContinue();
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isAppleLoading = true);
    try {
      final userInfo = await AuthService.signInWithApple();
      if (!mounted) return;
      if (userInfo != null) {
        _showCosmicWelcome(userInfo.displayName);
      }
    } catch (e) {
      if (!mounted) return;
      final errorStr = e.toString();
      if (errorStr.contains('TypeError') ||
          errorStr.contains('JSObject') ||
          errorStr.contains('minified')) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${L10nService.get('auth.apple_connection_failed', widget.language)}: $e',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      setState(() => _isAppleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebVersion();
    }
    return _buildMobileVersion();
  }

  Widget _buildWebVersion() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/brand/app-logo/png/app-logo-256.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              semanticLabel: 'InnerCycles logo',
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.auroraStart, AppColors.auroraEnd],
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 48,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              L10nService.get('app.name', widget.language),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w100,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 300,
              child: _NameInput(
                userName: widget.userName,
                onNameChanged: widget.onNameChanged,
                language: widget.language,
              ),
            ),
            const SizedBox(height: 24),
            ContentDisclaimer(language: widget.language, compact: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileVersion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Animated logo with cosmic glow
          _buildAnimatedLogo(),
          const SizedBox(height: 20),

          // App name
          Text(
            L10nService.get('app.name', widget.language),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w100,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ).glassReveal(context: context),

          const SizedBox(height: 8),

          // Tagline
          Text(
            L10nService.get('onboarding.start_cosmic_journey', widget.language),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ).glassListItem(context: context, index: 1),

          const SizedBox(height: 36),

          // Name input — primary action
          _NameInput(
            userName: widget.userName,
            onNameChanged: widget.onNameChanged,
            language: widget.language,
          ).glassListItem(context: context, index: 2),

          const SizedBox(height: 28),

          // Apple Sign-In button
          _buildAppleSignInButton(),

          const SizedBox(height: 16),

          // Terms text
          Text(
            L10nService.get('onboarding.by_continuing', widget.language),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted.withValues(alpha: 0.59),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ).glassListItem(context: context, index: 5),

          const SizedBox(height: 16),

          ContentDisclaimer(language: widget.language, compact: true),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.auroraStart.withValues(
                  alpha: (100 * _glowController.value + 50) / 255,
                ),
                blurRadius: 40 + (20 * _glowController.value),
                spreadRadius: 10 + (10 * _glowController.value),
              ),
              BoxShadow(
                color: AppColors.amethyst.withValues(
                  alpha: (80 * _glowController.value + 30) / 255,
                ),
                blurRadius: 60 + (30 * _glowController.value),
                spreadRadius: 5,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Image.asset(
        'assets/brand/app-logo/png/app-logo-256.png',
        width: 130,
        height: 130,
        fit: BoxFit.contain,
        semanticLabel: 'InnerCycles logo',
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.self_improvement,
          size: 100,
          color: AppColors.amethyst,
        ),
      ),
    ).glassReveal(context: context);
  }

  Widget _buildAppleSignInButton() {
    return Semantics(
      button: true,
      label: widget.language.name == 'en'
          ? 'Sign in with Apple'
          : 'Apple ile giriş yap',
      child: GestureDetector(
        onTap: _isAppleLoading ? null : _handleAppleSignIn,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isAppleLoading)
                const CosmicLoadingIndicator(size: 22)
              else
                const Icon(Icons.apple, color: Colors.white, size: 26),
              const SizedBox(width: 12),
              Text(
                _isAppleLoading
                    ? L10nService.get('onboarding.connecting', widget.language)
                    : L10nService.get(
                        'onboarding.connect_with_apple',
                        widget.language,
                      ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    ).glassListItem(context: context, index: 3);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 1: FIRST CYCLE — Focus Area Selection
// ════════════════════════════════════════════════════════════════════════════

class _FirstCyclePage extends StatelessWidget {
  final FocusArea? selectedFocusArea;
  final ValueChanged<FocusArea> onFocusAreaSelected;
  final AppLanguage language;

  const _FirstCyclePage({
    required this.selectedFocusArea,
    required this.onFocusAreaSelected,
    required this.language,
  });

  static const _focusAreas = [
    FocusArea.energy,
    FocusArea.emotions,
    FocusArea.focus,
    FocusArea.social,
  ];

  static const Map<FocusArea, IconData> _focusIcons = {
    FocusArea.energy: Icons.bolt_rounded,
    FocusArea.emotions: Icons.favorite_rounded,
    FocusArea.focus: Icons.center_focus_strong_rounded,
    FocusArea.social: Icons.people_rounded,
  };

  static const Map<FocusArea, String> _focusDescEn = {
    FocusArea.energy: 'Track physical & mental energy',
    FocusArea.emotions: 'Explore emotional patterns',
    FocusArea.focus: 'Monitor clarity & productivity',
    FocusArea.social: 'Understand social rhythms',
  };

  static const Map<FocusArea, String> _focusDescTr = {
    FocusArea.energy: 'Fiziksel ve zihinsel enerji',
    FocusArea.emotions: 'Duygusal kalıpları keşfet',
    FocusArea.focus: 'Netlik ve verimliliği takip et',
    FocusArea.social: 'Sosyal ritimlerini anla',
  };

  static const Map<FocusArea, Color> _focusColors = {
    FocusArea.energy: Color(0xFFFF6B6B),
    FocusArea.emotions: AppColors.amethyst,
    FocusArea.focus: AppColors.auroraStart,
    FocusArea.social: Color(0xFF4ECDC4),
  };

  @override
  Widget build(BuildContext context) {
    final isEn = language == AppLanguage.en;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Title
          Text(
            isEn ? 'Choose Your First Cycle' : 'İlk Döngünü Seç',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ).glassEntrance(context: context),

          const SizedBox(height: 8),

          Text(
            isEn
                ? 'What would you like to track first?'
                : 'İlk olarak neyi takip etmek istersin?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
              fontSize: 15,
            ),
          ).glassListItem(context: context, index: 0),

          const SizedBox(height: 32),

          // 2x2 Focus Area Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.05,
              physics: const NeverScrollableScrollPhysics(),
              children: _focusAreas.asMap().entries.map((entry) {
                final index = entry.key;
                final area = entry.value;
                final isSelected = selectedFocusArea == area;
                final color = _focusColors[area] ?? AppColors.auroraStart;

                return Semantics(
                  button: true,
                  label: isEn ? area.displayNameEn : area.displayNameTr,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onFocusAreaSelected(area);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? color
                              : Colors.white.withValues(alpha: 0.12),
                          width: isSelected ? 2 : 1,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            color.withValues(alpha: isSelected ? 0.2 : 0.08),
                            color.withValues(alpha: isSelected ? 0.12 : 0.03),
                          ],
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.16),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _focusIcons[area],
                              size: 36,
                              color: isSelected
                                  ? color
                                  : color.withValues(alpha: 0.71),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isEn ? area.displayNameEn : area.displayNameTr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.78),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isEn
                                  ? (_focusDescEn[area] ?? '')
                                  : (_focusDescTr[area] ?? ''),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted.withValues(
                                  alpha: 0.71,
                                ),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).glassListItem(context: context, index: index);
              }).toList(),
            ),
          ),

          // Info note
          GlassPanel(
            elevation: GlassElevation.g1,
            borderRadius: BorderRadius.circular(10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEn
                        ? 'You can track all areas later'
                        : 'Diğer alanları sonra takip edebilirsin',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ).glassListItem(context: context, index: 5),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 2: BIRTHDAY — Optional Date Picker
// ════════════════════════════════════════════════════════════════════════════

class _BirthdayPage extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final AppLanguage language;

  const _BirthdayPage({
    required this.selectedDate,
    required this.onDateSelected,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isEn = language == AppLanguage.en;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Title
          Text(
            isEn ? 'Your Birthday' : 'Doğum Günün',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ).glassEntrance(context: context),

          const SizedBox(height: 8),

          Text(
            isEn
                ? 'Optional — for milestone reminders'
                : 'İsteğe bağlı — hatırlatıcılar için',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
              fontSize: 15,
            ),
          ).glassListItem(context: context, index: 0),

          const SizedBox(height: 32),

          // Date picker
          BirthDatePicker(
            initialDate: selectedDate,
            onDateChanged: onDateSelected,
            language: language,
          ).glassListItem(context: context, index: 1),

          const SizedBox(height: 24),

          // Privacy info box
          GlassPanel(
            elevation: GlassElevation.g2,
            borderRadius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isEn
                        ? 'Your data stays on your device. We never share personal information.'
                        : 'Verilerin cihazında kalır. Kişisel bilgileri asla paylaşmayız.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ).glassListItem(context: context, index: 2),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 3: ARCHETYPE REVEAL — 3 Quick Questions + Animated Result
// ════════════════════════════════════════════════════════════════════════════

class _ArchetypeRevealPage extends StatelessWidget {
  final int quizQuestion;
  final bool showResult;
  final Archetype? result;
  final ValueChanged<_QuizOption> onSelectOption;
  final VoidCallback onSkip;
  final AppLanguage language;

  const _ArchetypeRevealPage({
    required this.quizQuestion,
    required this.showResult,
    required this.result,
    required this.onSelectOption,
    required this.onSkip,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (showResult && result != null) {
      return _buildResult(context, isDark, isEn);
    }

    return _buildQuestion(context, isDark, isEn);
  }

  Widget _buildQuestion(BuildContext context, bool isDark, bool isEn) {
    final question = _onboardingQuestions[quizQuestion];
    final progress = (quizQuestion + 1) / _onboardingQuestions.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skip + title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEn ? 'Discover Your Archetype' : 'Arketipini Keşfet',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.starGold,
                  letterSpacing: 1,
                ),
              ),
              TextButton(
                onPressed: onSkip,
                child: Text(
                  isEn ? 'Skip' : 'Atla',
                  style: TextStyle(
                    color: AppColors.textMuted.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

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

          const SizedBox(height: 6),

          Text(
            '${quizQuestion + 1}/${_onboardingQuestions.length}',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),

          const SizedBox(height: 28),

          // Question text
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

          const SizedBox(height: 28),

          // Options
          ...List.generate(question.options.length, (index) {
            final option = question.options[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Semantics(
                button: true,
                label: isEn ? option.textEn : option.textTr,
                child: GestureDetector(
                  onTap: () => onSelectOption(option),
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
              ),
            ).glassListItem(context: context, index: index);
          }),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context, bool isDark, bool isEn) {
    final archetype = result!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Archetype emoji with gold glow
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.starGold.withValues(alpha: 0.24),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: AppColors.amethyst.withValues(alpha: 0.12),
                  blurRadius: 60,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                archetype.emoji,
                style: const TextStyle(fontSize: 56),
              ),
            ),
          ).glassReveal(context: context),

          const SizedBox(height: 16),

          // Label
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

          // Name
          Text(
            archetype.getName(isEnglish: isEn),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 400),
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            archetype.getDescription(isEnglish: isEn),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              height: 1.5,
            ),
          ).glassEntrance(
            context: context,
            delay: const Duration(milliseconds: 500),
          ),

          const SizedBox(height: 24),

          // Strengths card with gold glow
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

          const SizedBox(height: 14),

          // Growth tip card with amethyst glow
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

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STEP 4: PERMISSION + START
// ════════════════════════════════════════════════════════════════════════════

class _PermissionStartPage extends StatelessWidget {
  final bool notificationsRequested;
  final VoidCallback onRequestNotifications;
  final AppLanguage language;

  const _PermissionStartPage({
    required this.notificationsRequested,
    required this.onRequestNotifications,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isEn = language == AppLanguage.en;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Success icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.auroraStart.withValues(alpha: 0.16),
                  AppColors.amethyst.withValues(alpha: 0.16),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.auroraStart.withValues(alpha: 0.2),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 56,
              color: AppColors.success,
            ),
          ).glassReveal(context: context),

          const SizedBox(height: 20),

          Text(
            isEn ? 'You\'re All Set' : 'Her Şey Hazır',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ).glassListItem(context: context, index: 1),

          const SizedBox(height: 12),

          Text(
            isEn
                ? 'One last thing — stay on track with gentle reminders'
                : 'Son bir şey — nazik hatırlatıcılarla yolda kal',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ).glassListItem(context: context, index: 2),

          const SizedBox(height: 24),

          // Notification toggle card
          if (!kIsWeb)
            GlassPanel(
              elevation: GlassElevation.g2,
              borderRadius: BorderRadius.circular(14),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.auroraStart.withValues(alpha: 0.16),
                          AppColors.amethyst.withValues(alpha: 0.16),
                        ],
                      ),
                    ),
                    child: Icon(
                      notificationsRequested
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_outlined,
                      color: notificationsRequested
                          ? AppColors.starGold
                          : AppColors.auroraStart,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn
                              ? 'Daily Reflection Reminder'
                              : 'Günlük Yansıma Hatırlatıcı',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEn
                              ? 'A gentle nudge at 9:00 AM'
                              : 'Sabah 9:00\'da nazik bir hatırlatma',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: isEn
                        ? 'Enable notifications'
                        : 'Bildirimleri etkinleştir',
                    child: GestureDetector(
                      onTap: notificationsRequested
                          ? null
                          : onRequestNotifications,
                      child: SizedBox(
                        width: 52,
                        height: 44,
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 52,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: notificationsRequested
                                  ? AppColors.starGold
                                  : Colors.white.withValues(alpha: 0.1),
                              border: Border.all(
                                color: notificationsRequested
                                    ? AppColors.starGold
                                    : Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutBack,
                              alignment: notificationsRequested
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 24,
                                height: 24,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: notificationsRequested
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.71),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).glassListItem(context: context, index: 3),

          const SizedBox(height: 24),

          // Features summary
          GlassPanel(
            elevation: GlassElevation.g2,
            borderRadius: BorderRadius.circular(14),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'What\'s Included' : 'Neler Dahil',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lavender,
                  ),
                ),
                const SizedBox(height: 14),
                _FeatureRow(
                  icon: Icons.edit_note,
                  text: isEn
                      ? 'Daily reflection journal'
                      : 'Günlük yansıma günlüğü',
                ),
                _FeatureRow(
                  icon: Icons.nights_stay,
                  text: isEn ? 'Dream journal' : 'Rüya günlüğü',
                ),
                _FeatureRow(
                  icon: Icons.auto_graph,
                  text: isEn ? 'Pattern recognition' : 'Kalıp tanıma',
                ),
                _FeatureRow(
                  icon: Icons.library_books,
                  text: isEn ? 'Symbol glossary' : 'Sembol sözlüğü',
                ),
              ],
            ),
          ).glassListItem(context: context, index: 4),

          const Spacer(),

          // Disclaimer
          GlassPanel(
            elevation: GlassElevation.g1,
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    L10nService.get('disclaimer.reflection_only', language),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ).glassListItem(context: context, index: 5),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.auroraStart),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ════════════════════════════════════════════════════════════════════════════

class _NameInput extends StatelessWidget {
  final String? userName;
  final ValueChanged<String> onNameChanged;
  final AppLanguage language;

  const _NameInput({
    required this.userName,
    required this.onNameChanged,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final hasValue = userName != null && userName!.isNotEmpty;

    return TextField(
      onChanged: onNameChanged,
      style: TextStyle(
        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: L10nService.get('input.your_name', language),
        hintStyle: TextStyle(
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          fontSize: 15,
        ),
        prefixIcon: Icon(
          Icons.person_outline,
          color: hasValue
              ? colorScheme.primary
              : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
        ),
        suffixIcon: hasValue
            ? const Icon(Icons.check_circle, color: AppColors.success, size: 20)
            : null,
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.5)
            : AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasValue
                ? colorScheme.primary
                : (isDark
                      ? AppColors.surfaceLight
                      : AppColors.lightSurfaceVariant),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// COSMIC WELCOME OVERLAY — Full screen animated welcome for OAuth
// ════════════════════════════════════════════════════════════════════════════

class _CosmicWelcomeOverlay extends StatefulWidget {
  final String greeting;
  final String? name;
  final AppLanguage language;
  final VoidCallback onComplete;

  const _CosmicWelcomeOverlay({
    required this.greeting,
    this.name,
    required this.language,
    required this.onComplete,
  });

  @override
  State<_CosmicWelcomeOverlay> createState() => _CosmicWelcomeOverlayState();
}

class _CosmicWelcomeOverlayState extends State<_CosmicWelcomeOverlay>
    with TickerProviderStateMixin {
  late AnimationController _starController;
  late AnimationController _textController;

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _starController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: widget.language.name == 'en'
            ? 'Tap to continue'
            : 'Devam etmek için dokunun',
        child: GestureDetector(
          onTap: widget.onComplete,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.deepSpace,
                  AppColors.cosmicPurple,
                  AppColors.nebulaPurple,
                  AppColors.amethystBlue,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Stars background
                ...List.generate(50, (index) {
                  final random = index * 7.3;
                  return Positioned(
                    left: (random * 13) % MediaQuery.of(context).size.width,
                    top: (random * 17) % MediaQuery.of(context).size.height,
                    child: AnimatedBuilder(
                      animation: _starController,
                      builder: (context, child) {
                        final twinkle =
                            ((_starController.value * 2 + random / 50) % 1.0);
                        return Opacity(
                          opacity: 0.3 + twinkle * 0.7,
                          child: Icon(
                            Icons.star,
                            size: 4 + (index % 4) * 2.0,
                            color: index % 3 == 0
                                ? AppColors.starGold
                                : index % 3 == 1
                                ? AppColors.lavender
                                : Colors.white,
                          ),
                        );
                      },
                    ),
                  );
                }),

                // Main content
                Center(
                  child: FadeTransition(
                    opacity: _textController,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _textController,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('📓', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 32),

                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                AppColors.starGold,
                                AppColors.chartPink,
                                AppColors.amethyst,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              widget.greeting,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          if (widget.name != null &&
                              widget.name!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              widget.name!,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.starGold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],

                          const SizedBox(height: 48),

                          Text(
                            L10nService.get(
                              'onboarding.tap_to_continue',
                              widget.language,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.5),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
