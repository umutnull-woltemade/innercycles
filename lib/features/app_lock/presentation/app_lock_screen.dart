import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  String _enteredPin = '';
  bool _showError = false;
  bool _biometricsAttempted = false;

  @override
  void initState() {
    super.initState();
    _tryBiometrics();
  }

  Future<void> _tryBiometrics() async {
    if (_biometricsAttempted) return;
    _biometricsAttempted = true;

    final serviceAsync = ref.read(appLockServiceProvider);
    final service = serviceAsync.valueOrNull;
    if (service == null) return;

    final canBio = await service.canUseBiometrics();
    if (!canBio) return;

    final success = await service.authenticateWithBiometrics(
      reason: 'Unlock InnerCycles',
    );
    if (success && mounted) {
      context.go(Routes.home);
    }
  }

  void _onDigit(int digit) {
    HapticFeedback.lightImpact();
    if (_enteredPin.length >= 4) return;
    setState(() {
      _enteredPin += '$digit';
      _showError = false;
    });
    if (_enteredPin.length == 4) {
      _verifyPin();
    }
  }

  void _onDelete() {
    HapticFeedback.lightImpact();
    if (_enteredPin.isEmpty) return;
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _showError = false;
    });
  }

  void _verifyPin() {
    final serviceAsync = ref.read(appLockServiceProvider);
    final service = serviceAsync.valueOrNull;
    if (service == null) return;

    if (service.verifyPin(_enteredPin)) {
      context.go(Routes.home);
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _showError = true;
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Lock icon
              Icon(
                Icons.lock_outline,
                size: 48,
                color: AppColors.starGold,
              ),
              const SizedBox(height: 16),

              Text(
                isEn ? 'Enter PIN' : 'PIN Girin',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8),

              if (_showError)
                Text(
                  isEn ? 'Incorrect PIN' : 'Yanlış PIN',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                  ),
                ),

              const SizedBox(height: 32),

              // PIN dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _enteredPin.length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled
                            ? AppColors.starGold
                            : Colors.transparent,
                        border: Border.all(
                          color: _showError
                              ? AppColors.error
                              : AppColors.starGold.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const Spacer(),

              // Number pad
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingXl * 2,
                ),
                child: Column(
                  children: [
                    _buildRow([1, 2, 3], isDark),
                    const SizedBox(height: 16),
                    _buildRow([4, 5, 6], isDark),
                    const SizedBox(height: 16),
                    _buildRow([7, 8, 9], isDark),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBioButton(isDark),
                        _buildDigitButton(0, isDark),
                        _buildDeleteButton(isDark),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<int> digits, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _buildDigitButton(d, isDark)).toList(),
    );
  }

  Widget _buildDigitButton(int digit, bool isDark) {
    return Semantics(
      label: '$digit',
      button: true,
      child: GestureDetector(
        onTap: () => _onDigit(digit),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.surfaceLight.withValues(alpha: 0.1)
                : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
            border: Border.all(
              color: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.2)
                  : AppColors.lightTextMuted.withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: Text(
              '$digit',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(bool isDark) {
    return Semantics(
      label: 'Delete',
      button: true,
      child: GestureDetector(
        onTap: _onDelete,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBioButton(bool isDark) {
    return Semantics(
      label: 'Unlock with biometrics',
      button: true,
      child: GestureDetector(
        onTap: () {
          _biometricsAttempted = false;
          _tryBiometrics();
        },
        child: SizedBox(
          width: 72,
          height: 72,
          child: Center(
            child: Icon(
              Icons.fingerprint,
              color: AppColors.starGold.withValues(alpha: 0.7),
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
