import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';

import '../../../data/models/user_profile.dart';

import '../../../data/providers/app_providers.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../shared/widgets/birth_date_picker.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/content_disclaimer.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? _selectedDate;
  String? _userName;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    if (_userName != null && _userName!.isNotEmpty) {
      final profile = UserProfile(
        name: _userName,
        birthDate: _selectedDate ?? DateTime(2000, 1, 1),
      );

      // Save to state
      ref.read(userProfileProvider.notifier).setProfile(profile);
      ref.read(onboardingCompleteProvider.notifier).state = true;

      // Persist to local storage
      await StorageService.saveUserProfile(profile);
      await StorageService.saveOnboardingComplete(true);

      // Request notification permissions and set default schedule (mobile only)
      if (!kIsWeb) {
        try {
          final notifService = NotificationService();
          await notifService.initialize();
          final granted = await notifService.requestPermissions();
          if (granted) {
            // Schedule default daily reflection at 9:00 AM
            await notifService.scheduleDailyReflection(hour: 9, minute: 0);
            // Enable moon phase notifications
            await notifService.scheduleMoonPhaseNotifications();
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ Onboarding notification setup failed: $e');
          }
        }
      }

      // Wait for state to propagate before navigation
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        context.go(Routes.archetypeQuiz);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);

    // ═══════════════════════════════════════════════════════════════════════════
    // BOTH WEB AND MOBILE: Same onboarding UI
    // ═══════════════════════════════════════════════════════════════════════════
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Fallback dark background
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    _WelcomePage(onContinue: _nextPage, language: language),
                    _BirthDataPage(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() => _selectedDate = date);
                      },
                      userName: _userName,
                      onNameChanged: (name) {
                        setState(() => _userName = name);
                      },
                      onContinue: _nextPage,
                      language: language,
                    ),
                    _ReadyPage(
                            selectedDate: _selectedDate,
                            onComplete: _completeOnboarding,
                            language: language,
                          ),
                  ],
                ),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.auroraStart
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: AppConstants.spacingXl),
          // Continue button
          GradientButton(
            label: _currentPage == 2
                ? L10nService.get(
                    'common.start_journey',
                    ref.watch(languageProvider),
                  )
                : L10nService.get(
                    'common.continue',
                    ref.watch(languageProvider),
                  ),
            icon: _currentPage == 2 ? Icons.auto_awesome : Icons.arrow_forward,
            width: double.infinity,
            onPressed: _canProceed() ? _nextPage : null,
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    if (_currentPage == 1) {
      // Only name is required; date is optional
      return _userName != null && _userName!.isNotEmpty;
    }
    return true;
  }
}

class _WelcomePage extends StatefulWidget {
  final VoidCallback onContinue;
  final AppLanguage language;

  const _WelcomePage({required this.onContinue, required this.language});

  @override
  State<_WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<_WelcomePage>
    with SingleTickerProviderStateMixin {
  bool _isAppleLoading = false;
  late AnimationController _glowController;
  late final Stream<AuthState> _authStateStream;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();

    // Skip ALL complex initialization on web to prevent white screen
    if (kIsWeb) {
      if (kDebugMode) {
        debugPrint('⚠️ Web: Using simplified onboarding (no animations)');
      }
      // Create a dummy controller that won't cause issues
      _glowController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );
      return;
    }

    // MOBILE: Full animated experience
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Guard Supabase access (may not be initialized in tests)
    if (!AuthService.isSupabaseInitialized) {
      if (kDebugMode) debugPrint('⚠️ Supabase not initialized - skipping auth listeners');
      return;
    }

    // Listen for OAuth callbacks (mobile only)
    _authStateStream = AuthService.authStateChanges;
    _authSubscription = _authStateStream.listen((state) {
      if (kDebugMode) debugPrint('🔐 Auth state changed: ${state.event}');
      if (state.event == AuthChangeEvent.signedIn && state.session != null) {
        if (kDebugMode) debugPrint('🔐 User signed in via OAuth callback!');
        _handleOAuthSuccess(state.session!.user);
      }
    });

    // Check if user is already signed in when page loads
    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      if (kDebugMode) debugPrint('🔐 User already signed in: ${currentUser.email}');
      // Wait briefly for UI to be ready
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _handleOAuthSuccess(currentUser);
        }
      });
    }
  }

  void _handleOAuthSuccess(User user) {
    if (!mounted) return;

    final displayName =
        user.userMetadata?['full_name'] as String? ??
        user.userMetadata?['name'] as String? ??
        user.email?.split('@').first;

    // Show welcome overlay
    _showCosmicWelcome(displayName);
  }

  void _showCosmicWelcome(String? name) {
    // Welcome greeting messages - from locale
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

  @override
  Widget build(BuildContext context) {
    // WEB: Simple static version without animations (prevents white screen)
    // The animated version causes layout/animation issues on web
    if (kIsWeb) {
      if (kDebugMode) {
        debugPrint('WEB: _WelcomePage building static version');
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo - Use actual InnerCycles logo with fallback for web
              Image.asset(
                'assets/brand/app-logo/png/app-logo-256.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback: gradient circle with star icon (if asset fails on web)
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 60,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // App name
              Text(
                L10nService.get('app.name', widget.language),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              // Tagline
              Text(
                L10nService.get(
                  'onboarding.start_cosmic_journey',
                  widget.language,
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 48),
              // Continue button
              ElevatedButton(
                onPressed: widget.onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  L10nService.get('common.continue', widget.language),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 32),
              // ═══════════════════════════════════════════════════════════════
              // CONTENT DISCLAIMER - App Store 4.3(b) Compliance
              // ═══════════════════════════════════════════════════════════════
              ContentDisclaimer(language: widget.language, compact: true),
            ],
          ),
        ),
      );
    }

    // MOBILE: Original animated version
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // ══════════════════════════════════════════════════════
            // ANIMATED LOGO with cosmic glow
            // ══════════════════════════════════════════════════════
            _buildAnimatedLogo(),
            const SizedBox(height: 24),

            // App name - ultra thin font
            Text(
              L10nService.get('app.name', widget.language),
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w100,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ).glassReveal(context: context),

            const SizedBox(height: 8),

            // Tagline
            Text(
              L10nService.get(
                'onboarding.start_cosmic_journey',
                widget.language,
              ),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ).glassListItem(context: context, index: 1),

            const SizedBox(height: 48),

            // ══════════════════════════════════════════════════════
            // SIGN-IN BUTTONS - Premium Design
            // ══════════════════════════════════════════════════════

            // Apple Sign-In Button
            _buildAppleSignInButton(),

            const SizedBox(height: 24),

            // Divider with text
            _buildDivider(),

            const SizedBox(height: 24),

            // Guest continue button
            _buildGuestButton(),

            const SizedBox(height: 32),

            // Features preview
            _buildFeaturesPreview(),

            const SizedBox(height: 24),

            // Terms text
            Text(
              L10nService.get('onboarding.by_continuing', widget.language),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted.withAlpha(150),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ).glassListItem(context: context, index: 9),

            const SizedBox(height: 24),

            // ═══════════════════════════════════════════════════════════════
            // CONTENT DISCLAIMER - App Store 4.3(b) Compliance
            // ═══════════════════════════════════════════════════════════════
            ContentDisclaimer(language: widget.language, compact: true),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF667EEA,
                    ).withAlpha((100 * _glowController.value).toInt() + 50),
                    blurRadius: 40 + (20 * _glowController.value),
                    spreadRadius: 10 + (10 * _glowController.value),
                  ),
                  BoxShadow(
                    color: const Color(
                      0xFF9B59B6,
                    ).withAlpha((80 * _glowController.value).toInt() + 30),
                    blurRadius: 60 + (30 * _glowController.value),
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: const Color(
                      0xFFFFD700,
                    ).withAlpha((60 * _glowController.value).toInt() + 20),
                    blurRadius: 80,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Image.asset(
            'assets/brand/app-logo/png/app-logo-256.png',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
        )
        .glassReveal(context: context);
  }

  Widget _buildAppleSignInButton() {
    return GestureDetector(
      onTap: _isAppleLoading ? null : _handleAppleSignIn,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isAppleLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              const Icon(Icons.apple, color: Colors.white, size: 28),
            const SizedBox(width: 14),
            Text(
              _isAppleLoading
                  ? L10nService.get('onboarding.connecting', widget.language)
                  : L10nService.get(
                      'onboarding.connect_with_apple',
                      widget.language,
                    ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    ).glassListItem(context: context, index: 2);
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.textMuted.withAlpha(100),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            L10nService.get('common.or', widget.language),
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.textMuted.withAlpha(100),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    ).glassListItem(context: context, index: 3);
  }

  Widget _buildGuestButton() {
    return GestureDetector(
      onTap: widget.onContinue,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667EEA).withAlpha(40),
              const Color(0xFF9B59B6).withAlpha(40),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF667EEA).withAlpha(100),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF9B59B6)],
              ).createShader(bounds),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF9B59B6)],
              ).createShader(bounds),
              child: Text(
                L10nService.get('onboarding.explore_now', widget.language),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    ).glassListItem(context: context, index: 4);
  }

  Widget _buildFeaturesPreview() {
    final features = [
      {
        'icon': '🌙',
        'text': L10nService.get(
          'onboarding.features.personal_profile',
          widget.language,
        ),
      },
      {
        'icon': '✨',
        'text': L10nService.get(
          'onboarding.features.daily_reading',
          widget.language,
        ),
      },
      {
        'icon': '📓',
        'text': L10nService.get(
          'onboarding.features.dream_journal',
          widget.language,
        ),
      },
      {
        'icon': '📊',
        'text': L10nService.get(
          'onboarding.features.patterns',
          widget.language,
        ),
      },
    ];

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 8,
      runSpacing: 12,
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF667EEA).withAlpha(50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      feature['icon']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feature['text']!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            )
            .glassListItem(context: context, index: 5 + index);
      }).toList(),
    );
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isAppleLoading = true);

    try {
      // Import and use AuthService for Apple Sign-In
      final userInfo = await AuthService.signInWithApple();

      if (!mounted) return;

      if (userInfo != null) {
        // Show welcome overlay
        _showCosmicWelcome(userInfo.displayName);
      }
      // If userInfo is null, web will do OAuth redirect
      // authStateChanges listener will catch successful sign-in
      // Keep loading state until redirect completes
    } catch (e) {
      if (!mounted) return;
      final errorStr = e.toString();

      // Don't show JS interop errors on web - OAuth may still be in progress
      if (errorStr.contains('TypeError') ||
          errorStr.contains('JSObject') ||
          errorStr.contains('minified')) {
        if (kDebugMode) {
          debugPrint('JS interop error caught - waiting for OAuth redirect');
        }
        // Keep loading state active
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
    // Removed finally block - loading state only cleared on error
    // On successful OAuth, redirect will happen so loading should persist
  }
}

class _BirthDataPage extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? userName;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onContinue;
  final AppLanguage language;

  const _BirthDataPage({
    required this.selectedDate,
    required this.onDateSelected,
    required this.userName,
    required this.onNameChanged,
    required this.onContinue,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Name input
          _buildSectionTitle(
            context,
            L10nService.get('input.name_required', language),
          ),
          const SizedBox(height: 8),
          _NameInput(
            userName: userName,
            onNameChanged: onNameChanged,
            language: language,
          ).glassListItem(context: context, index: 0),
          const SizedBox(height: AppConstants.spacingLg),

          // Birth Date (optional)
          _buildSectionTitle(
            context,
            L10nService.get('input.birth_date', language),
          ),
          const SizedBox(height: 4),
          Text(
            language == AppLanguage.en
                ? 'Optional — helps personalize your experience'
                : 'İsteğe bağlı — deneyiminizi kişiselleştirmeye yardımcı olur',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          BirthDatePicker(
            initialDate: selectedDate,
            onDateChanged: onDateSelected,
            language: language,
          ).glassListItem(context: context, index: 1),

          const SizedBox(height: AppConstants.spacingLg),

          // Info box
          _InfoBox(
            language: language,
          ).glassListItem(context: context, index: 2),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

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
            ? AppColors.surfaceDark.withAlpha(128)
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
                : (isDark ? AppColors.surfaceLight : Colors.grey.shade300),
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

class _InfoBox extends StatelessWidget {
  final AppLanguage language;
  const _InfoBox({required this.language});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GlassPanel(
      elevation: GlassElevation.g2,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              L10nService.get('onboarding.info_box_text', language),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Welcome overlay - full screen, animated
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

    // Auto-advance after 2.5 seconds
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
                Color(0xFF0D0D1A),
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F3460),
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
                              ? const Color(0xFFFFD700)
                              : index % 3 == 1
                              ? const Color(0xFFE6E6FA)
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
                        // Moon/Star icon
                        const Text('🌙', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 32),

                        // Welcome message
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFFF6B9D),
                              Color(0xFF9B59B6),
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

                        // Show name if available
                        if (widget.name != null && widget.name!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            widget.name!,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700),
                              letterSpacing: 2,
                            ),
                          ),
                        ],

                        const SizedBox(height: 48),

                        // Bottom message
                        Text(
                          '✨ ${L10nService.get('onboarding.tap_to_continue', widget.language)} ✨',
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
    );
  }
}

/// ════════════════════════════════════════════════════════════════════════════
/// APP STORE 4.3(b) COMPLIANT READY PAGE
/// ════════════════════════════════════════════════════════════════════════════
/// Neutral completion page for App Store 4.3(b) compliance.
/// Shows a safe, personality-type-free ready screen.
class _ReadyPage extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onComplete;
  final AppLanguage language;

  const _ReadyPage({
    required this.selectedDate,
    required this.onComplete,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Success checkmark with glow
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF667EEA).withAlpha(40),
                    const Color(0xFF9B59B6).withAlpha(40),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withAlpha(60),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 64,
                color: Color(0xFF4CAF50),
              ),
            ).glassReveal(context: context),

            const SizedBox(height: 32),

            // Title - neutral
            Text(
              L10nService.get('onboarding.profile_ready', language),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ).glassListItem(context: context, index: 1),

            const SizedBox(height: 16),

            // Subtitle - reflection focused
            Text(
              L10nService.get('onboarding.ready_subtitle', language),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ).glassListItem(context: context, index: 2),

            const SizedBox(height: 48),

            // Feature preview - safe features only
            GlassPanel(
                  elevation: GlassElevation.g2,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10nService.get('onboarding.whats_included', language),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE6E6FA),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildFeatureItem(
                        context,
                        Icons.edit_note,
                        L10nService.get(
                          'onboarding.feature_reflection',
                          language,
                        ),
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.nights_stay,
                        L10nService.get('onboarding.feature_dreams', language),
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.auto_graph,
                        L10nService.get(
                          'onboarding.feature_patterns',
                          language,
                        ),
                      ),
                      _buildFeatureItem(
                        context,
                        Icons.library_books,
                        L10nService.get('onboarding.feature_symbols', language),
                      ),
                    ],
                  ),
                )
                .glassListItem(context: context, index: 3),

            const SizedBox(height: 24),

            // Disclaimer
            GlassPanel(
              elevation: GlassElevation.g2,
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      L10nService.get('disclaimer.reflection_only', language),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ).glassListItem(context: context, index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF667EEA)),
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
