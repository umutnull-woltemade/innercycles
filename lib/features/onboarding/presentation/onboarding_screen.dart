import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/cities/world_cities.dart';
import '../../../data/models/user_profile.dart';

import '../../../data/providers/app_providers.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../shared/widgets/birth_date_picker.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime = const TimeOfDay(
    hour: 12,
    minute: 0,
  ); // Default 12:00
  String? _userName;
  String? _birthPlace = 'Marmaris, Mugla (Türkiye)'; // Default Marmaris
  double? _birthLatitude = 36.8500; // Marmaris coordinates
  double? _birthLongitude = 28.2667;

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
    if (_selectedDate != null) {
      String? birthTimeStr;
      if (_selectedTime != null) {
        birthTimeStr =
            '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      }

      final profile = UserProfile(
        name: _userName,
        birthDate: _selectedDate!,
        birthTime: birthTimeStr,
        birthPlace: _birthPlace,
        birthLatitude: _birthLatitude,
        birthLongitude: _birthLongitude,
      );

      // Save to state
      ref.read(userProfileProvider.notifier).setProfile(profile);
      ref.read(onboardingCompleteProvider.notifier).state = true;

      // Persist to local storage
      await StorageService.saveUserProfile(profile);
      await StorageService.saveOnboardingComplete(true);

      // Wait for state to propagate before navigation
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        context.go(Routes.home);
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
                      selectedTime: _selectedTime,
                      onTimeSelected: (time) {
                        setState(() => _selectedTime = time);
                      },
                      userName: _userName,
                      onNameChanged: (name) {
                        setState(() => _userName = name);
                      },
                      birthPlace: _birthPlace,
                      onPlaceChanged: (place, lat, lng) {
                        setState(() {
                          _birthPlace = place;
                          _birthLatitude = lat;
                          _birthLongitude = lng;
                        });
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
      // All fields are required for accurate profile calculation
      return _userName != null &&
          _userName!.isNotEmpty &&
          _selectedDate != null &&
          _selectedTime != null &&
          _birthPlace != null;
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
      debugPrint('⚠️ Supabase not initialized - skipping auth listeners');
      return;
    }

    // OAuth callback'lerini dinle (mobile only)
    _authStateStream = AuthService.authStateChanges;
    _authStateStream.listen((state) {
      debugPrint('🔐 Auth state changed: ${state.event}');
      if (state.event == AuthChangeEvent.signedIn && state.session != null) {
        debugPrint('🔐 User signed in via OAuth callback!');
        _handleOAuthSuccess(state.session!.user);
      }
    });

    // Sayfa yüklendiğinde zaten oturum açık mı kontrol et
    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      debugPrint('🔐 User already signed in: ${currentUser.email}');
      // Biraz bekle ki UI hazır olsun
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

    // Kozmik karşılama overlay'i göster
    _showCosmicWelcome(displayName);
  }

  void _showCosmicWelcome(String? name) {
    // Ezoterik karşılama mesajları - from locale
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
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WEB: Simple static version without animations (prevents white screen)
    // The animated version causes layout/animation issues on web
    if (kIsWeb) {
      // ignore: avoid_print
      print('🌐 WEB: _WelcomePage building static version');
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo - Use actual InnerCycles logo with fallback for web
              Image.asset(
                'assets/brand/venus-logo/png/venus-logo-256.png',
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
              // ENTERTAINMENT DISCLAIMER - App Store 4.3(b) Compliance
              // ═══════════════════════════════════════════════════════════════
              EntertainmentDisclaimer(language: widget.language, compact: true),
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
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),

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
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

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
            ).animate().fadeIn(delay: 1200.ms),

            const SizedBox(height: 24),

            // ═══════════════════════════════════════════════════════════════
            // ENTERTAINMENT DISCLAIMER - App Store 4.3(b) Compliance
            // ═══════════════════════════════════════════════════════════════
            EntertainmentDisclaimer(language: widget.language, compact: true),

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
            'assets/brand/venus-logo/png/venus-logo-256.png',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
        )
        .animate()
        .fadeIn(duration: 1000.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          curve: Curves.elasticOut,
          duration: 1200.ms,
        );
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
    ).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(begin: 0.3);
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
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
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
    ).animate().fadeIn(delay: 900.ms, duration: 500.ms).slideY(begin: 0.2);
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
            .animate()
            .fadeIn(delay: (1000 + index * 100).ms, duration: 400.ms)
            .slideY(begin: 0.3);
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
        // Kozmik karşılama overlay'i göster
        _showCosmicWelcome(userInfo.displayName);
      }
      // userInfo null ise web'de OAuth redirect olacak
      // authStateChanges listener basarili girisi yakalayacak
      // Loading state'i devam etsin ta ki redirect olana kadar
    } catch (e) {
      if (!mounted) return;
      final errorStr = e.toString();

      // Web'de JS interop hatalarini gosterme - OAuth devam ediyor olabilir
      if (errorStr.contains('TypeError') ||
          errorStr.contains('JSObject') ||
          errorStr.contains('minified')) {
        debugPrint(
          '🍎 JS interop hatasi yakalandi - OAuth redirect bekleniyor',
        );
        // Loading state'i devam etsin
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
    // finally bloğunu kaldırdık - loading state'i sadece hata durumunda kapatılıyor
    // başarılı OAuth'da redirect olacağı için loading devam etmeli
  }
}

class _BirthDataPage extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final String? userName;
  final ValueChanged<String> onNameChanged;
  final String? birthPlace;
  final void Function(String place, double lat, double lng) onPlaceChanged;
  final VoidCallback onContinue;
  final AppLanguage language;

  const _BirthDataPage({
    required this.selectedDate,
    required this.onDateSelected,
    required this.selectedTime,
    required this.onTimeSelected,
    required this.userName,
    required this.onNameChanged,
    required this.birthPlace,
    required this.onPlaceChanged,
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
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          const SizedBox(height: AppConstants.spacingLg),

          // Birth Date
          _buildSectionTitle(
            context,
            L10nService.get('input.birth_date_required', language),
          ),
          const SizedBox(height: 8),
          BirthDatePicker(
            initialDate: selectedDate,
            onDateChanged: onDateSelected,
            language: language,
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
          const SizedBox(height: AppConstants.spacingLg),

          // Birth Time
          _buildSectionTitle(
            context,
            L10nService.get('input.birth_time_required', language),
          ),
          const SizedBox(height: 8),
          _BirthTimePicker(
            selectedTime: selectedTime,
            onTimeSelected: onTimeSelected,
            language: language,
          ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
          const SizedBox(height: AppConstants.spacingLg),

          // Birth Place
          _buildSectionTitle(
            context,
            L10nService.get('input.birth_place_required', language),
          ),
          const SizedBox(height: 8),
          _BirthPlacePicker(
            selectedPlace: birthPlace,
            onPlaceSelected: onPlaceChanged,
            language: language,
          ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

          const SizedBox(height: AppConstants.spacingLg),

          // Info box
          _InfoBox(
            language: language,
          ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(isDark ? 25 : 15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withAlpha(isDark ? 76 : 50),
        ),
      ),
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

class _BirthTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final AppLanguage language;

  const _BirthTimePicker({
    required this.selectedTime,
    required this.onTimeSelected,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showTimePicker(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withAlpha(128)
              : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedTime != null
                ? colorScheme.primary
                : (isDark ? AppColors.surfaceLight : Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: selectedTime != null
                  ? colorScheme.primary
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: selectedTime != null
                  ? Text(
                      '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    )
                  : Text(
                      L10nService.get('input.select_time', language),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
            ),
            if (selectedTime != null)
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        int selectedHour = selectedTime?.hour ?? 12;
        int selectedMinute = selectedTime?.minute ?? 0;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 350,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          L10nService.get('common.cancel', language),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                      Text(
                        L10nService.get('input.birth_time', language),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          onTimeSelected(
                            TimeOfDay(
                              hour: selectedHour,
                              minute: selectedMinute,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          L10nService.get('common.ok', language),
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        // Hour picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedHour,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setModalState(() => selectedHour = index);
                            },
                            children: List.generate(24, (index) {
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Minute picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedMinute,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setModalState(() => selectedMinute = index);
                            },
                            children: List.generate(60, (index) {
                              return Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BirthPlacePicker extends StatefulWidget {
  final String? selectedPlace;
  final void Function(String place, double lat, double lng) onPlaceSelected;
  final AppLanguage language;

  const _BirthPlacePicker({
    required this.selectedPlace,
    required this.onPlaceSelected,
    required this.language,
  });

  @override
  State<_BirthPlacePicker> createState() => _BirthPlacePickerState();
}

class _BirthPlacePickerState extends State<_BirthPlacePicker> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showPlacePicker(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withAlpha(128)
              : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.selectedPlace != null
                ? colorScheme.primary
                : (isDark ? AppColors.surfaceLight : Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: widget.selectedPlace != null
                  ? colorScheme.primary
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: widget.selectedPlace != null
                  ? Text(
                      widget.selectedPlace!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      '${L10nService.get('input.select_city', widget.language)} (${WorldCities.sortedCities.length})',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
            ),
            if (widget.selectedPlace != null)
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showPlacePicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setModalState) {
            List<CityData> filteredCities;
            if (searchQuery.isEmpty) {
              filteredCities = WorldCities.sortedCities;
            } else {
              filteredCities = WorldCities.search(searchQuery);
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          L10nService.get('common.cancel', widget.language),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            L10nService.get(
                              'input.birth_place',
                              widget.language,
                            ),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                          ),
                          Text(
                            '${WorldCities.sortedCities.length}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 60),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search field
                  TextField(
                    onChanged: (value) {
                      setModalState(() => searchQuery = value);
                    },
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: L10nService.get(
                        'input.search_city',
                        widget.language,
                      ),
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.surfaceLight.withAlpha(76)
                          : AppColors.lightSurfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Results count
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filteredCities.length} ${L10nService.get('common.results', widget.language)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        final isSelected =
                            widget.selectedPlace == city.displayName;

                        return ListTile(
                          leading: Icon(
                            city.country == 'Türkiye' || city.country == 'KKTC'
                                ? Icons.flag
                                : Icons.public,
                            color: isSelected
                                ? colorScheme.primary
                                : (isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted),
                          ),
                          title: Text(
                            city.name,
                            style: TextStyle(
                              color: isSelected
                                  ? colorScheme.primary
                                  : (isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            city.region != null
                                ? '${city.region}, ${city.country}'
                                : city.country,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                              fontSize: 14,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: colorScheme.primary,
                                )
                              : null,
                          onTap: () {
                            widget.onPlaceSelected(
                              city.displayName,
                              city.lat,
                              city.lng,
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// _YourSignPage archived to _archived/

/// Kozmik karşılama overlay'i - tam ekran, animasyonlu
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

    // 2.5 saniye sonra otomatik geç
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
              // Yıldızlar arka planı
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

              // Ana içerik
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
                        // Ay/Yıldız ikonu
                        const Text('🌙', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 32),

                        // Ezoterik mesaj
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

                        // İsim varsa göster
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

                        // Alt mesaj
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
            ).animate().scale(
              begin: const Offset(0.5, 0.5),
              curve: Curves.elasticOut,
              duration: 600.ms,
            ),

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
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Subtitle - reflection focused
            Text(
              L10nService.get('onboarding.ready_subtitle', language),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

            const SizedBox(height: 48),

            // Feature preview - safe features only
            Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight.withAlpha(30),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
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
                .animate()
                .fadeIn(delay: 600.ms, duration: 400.ms)
                .slideY(begin: 0.2),

            const SizedBox(height: 24),

            // Disclaimer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
              ),
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
            ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
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
