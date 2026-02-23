import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/admin_auth_service.dart';
import '../../../data/services/admin_analytics_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/providers/admin_providers.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/premium_card.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isLoading = false;
  String? _error;
  bool _obscurePin = true;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _checkExistingSession() async {
    if (AdminAuthService.isAuthenticated) {
      if (mounted) {
        context.go(Routes.admin);
      }
    }
  }

  Future<void> _handleLogin() async {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) {
      setState(
        () => _error = L10nService.get(
          'screens.admin_login.pin_required',
          ref.read(languageProvider),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await AdminAuthService.verifyPin(pin);

    if (!mounted) return;

    if (result.success) {
      unawaited(AdminAnalyticsService.trackAdminLoginSuccess());
      ref.invalidate(adminAuthProvider);
      context.go(Routes.admin);
    } else {
      unawaited(AdminAnalyticsService.trackAdminLoginFail());
      setState(() {
        _isLoading = false;
        _error = result.error;
      });
      _pinController.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLocked = AdminAuthService.isLockedOut;
    final remainingAttempts = AdminAuthService.remainingAttempts;
    final language = ref.watch(languageProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isDark, language),
                const SizedBox(height: AppConstants.spacingHuge),
                _buildLoginCard(
                  context,
                  isDark,
                  isLocked,
                  remainingAttempts,
                  language,
                ),
                const SizedBox(height: AppConstants.spacingXl),
                _buildSecurityInfo(context, isDark, language),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppLanguage language) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: AppConstants.spacingSm),
        Flexible(
          child: Text(
            L10nService.get('screens.admin_login.title', language),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.starGold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildLoginCard(
    BuildContext context,
    bool isDark,
    bool isLocked,
    int remainingAttempts,
    AppLanguage language,
  ) {
    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lock icon
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isLocked
                    ? [AppColors.error, AppColors.error.withValues(alpha: 0.7)]
                    : [AppColors.starGold, AppColors.celestialGold],
              ),
            ),
            child: Icon(
              isLocked ? Icons.lock_clock : Icons.admin_panel_settings,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXl),

          // Title
          Text(
            isLocked
                ? L10nService.get(
                    'screens.admin_login.account_locked',
                    language,
                  )
                : L10nService.get('screens.admin_login.enter_pin', language),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),

          // Subtitle
          Text(
            isLocked
                ? L10nService.get(
                    'screens.admin_login.too_many_attempts',
                    language,
                  )
                : L10nService.get(
                    'screens.admin_login.secure_access_required',
                    language,
                  ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXl),

          if (isLocked) ...[
            _buildLockoutTimer(context, isDark, language),
          ] else ...[
            // PIN input
            TextField(
              controller: _pinController,
              focusNode: _focusNode,
              obscureText: _obscurePin,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 8,
              enabled: !_isLoading,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                letterSpacing: 8,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: '••••',
                hintStyle: TextStyle(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                  letterSpacing: 8,
                ),
                counterText: '',
                filled: true,
                fillColor: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.5)
                    : AppColors.lightSurfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: BorderSide(color: AppColors.starGold, width: 2),
                ),
                suffixIcon: IconButton(
                  tooltip: _obscurePin
                      ? (language == AppLanguage.en
                            ? 'Show PIN'
                            : 'PIN\'i göster')
                      : (language == AppLanguage.en
                            ? 'Hide PIN'
                            : 'PIN\'i gizle'),
                  icon: Icon(
                    _obscurePin ? Icons.visibility_off : Icons.visibility,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  onPressed: () => setState(() => _obscurePin = !_obscurePin),
                ),
              ),
              onSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // Remaining attempts
            if (remainingAttempts < AdminAuthService.maxAttempts)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      L10nService.get(
                        'screens.admin_login.attempts_remaining',
                        language,
                      ).replaceAll('{count}', '$remainingAttempts'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Error message
            if (_error != null) ...[
              const SizedBox(height: AppConstants.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppConstants.spacingXl),

            // Login button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.starGold,
                  foregroundColor: AppColors.deepSpace,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const CosmicLoadingIndicator(size: 24)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.login),
                          const SizedBox(width: 8),
                          Text(
                            L10nService.get(
                              'screens.admin_login.access_dashboard',
                              language,
                            ),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.deepSpace,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildLockoutTimer(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    final remaining = AdminAuthService.remainingLockoutTime;
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;

    return Column(
      children: [
        const Icon(Icons.timer_outlined, size: 48, color: AppColors.error),
        const SizedBox(height: AppConstants.spacingMd),
        Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Text(
          L10nService.get('screens.admin_login.wait_before_retry', language),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityInfo(
    BuildContext context,
    bool isDark,
    AppLanguage language,
  ) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: AppConstants.radiusMd,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: AppColors.auroraStart, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get(
                  'screens.admin_login.security_features',
                  language,
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSecurityItem(
            context,
            isDark,
            Icons.lock_clock,
            L10nService.get(
              'screens.admin_login.rate_limiting',
              language,
            ).replaceAll('{count}', '${AdminAuthService.maxAttempts}'),
          ),
          _buildSecurityItem(
            context,
            isDark,
            Icons.timer,
            L10nService.get(
              'screens.admin_login.lockout_duration',
              language,
            ).replaceAll(
              '{minutes}',
              '${AdminAuthService.lockoutDuration.inMinutes}',
            ),
          ),
          _buildSecurityItem(
            context,
            isDark,
            Icons.vpn_key,
            L10nService.get('screens.admin_login.secure_session', language),
          ),
          _buildSecurityItem(
            context,
            isDark,
            Icons.no_encryption_gmailerrorred,
            L10nService.get('screens.admin_login.pin_not_stored', language),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildSecurityItem(
    BuildContext context,
    bool isDark,
    IconData icon,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
