// ════════════════════════════════════════════════════════════════════════════
// VAULT PIN SCREEN - PIN Setup & Verification
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';

enum _PinMode { setup, confirm, verify, change }

class VaultPinScreen extends ConsumerStatefulWidget {
  /// null = verify existing, 'setup' = first-time, 'change' = change PIN
  final String? mode;

  const VaultPinScreen({super.key, this.mode});

  @override
  ConsumerState<VaultPinScreen> createState() => _VaultPinScreenState();
}

class _VaultPinScreenState extends ConsumerState<VaultPinScreen> {
  String _pin = '';
  String _firstPin = ''; // stored during setup confirmation
  _PinMode _currentMode = _PinMode.verify;
  String? _error;
  bool _biometricAttempted = false;

  static const int _pinLength = 4;

  @override
  void initState() {
    super.initState();
    if (widget.mode == 'setup') {
      _currentMode = _PinMode.setup;
    } else if (widget.mode == 'change') {
      _currentMode = _PinMode.verify; // verify old first
    } else {
      _currentMode = _PinMode.verify;
      _tryBiometric();
    }
  }

  Future<void> _tryBiometric() async {
    if (_biometricAttempted) return;
    _biometricAttempted = true;

    final vaultService = await ref.read(vaultServiceProvider.future);
    if (!vaultService.isBiometricEnabled) return;

    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    final success = await vaultService.tryBiometricUnlock(language: language);
    if (success && mounted) {
      _onVerified();
    }
  }

  void _onDigitTap(int digit) {
    if (_pin.length >= _pinLength) return;
    HapticService.buttonPress();
    setState(() {
      _pin += digit.toString();
      _error = null;
    });

    if (_pin.length == _pinLength) {
      _processPin();
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    HapticService.buttonPress();
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = null;
    });
  }

  Future<void> _processPin() async {
    final vaultService = await ref.read(vaultServiceProvider.future);
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;

    if (!mounted) return;
    switch (_currentMode) {
      case _PinMode.setup:
        _firstPin = _pin;
        setState(() {
          _pin = '';
          _currentMode = _PinMode.confirm;
        });
        break;

      case _PinMode.confirm:
        if (_pin == _firstPin) {
          await vaultService.setPin(_pin);
          // Check biometric availability and offer
          final canBio = await vaultService.canUseBiometrics();
          if (canBio && mounted) {
            final enableBio = await _showBiometricDialog(isEn);
            if (enableBio) {
              await vaultService.setBiometricEnabled(true);
            }
          }
          if (mounted) {
            ref.invalidate(vaultServiceProvider);
            context.go(Routes.vault);
          }
        } else {
          HapticService.error();
          setState(() {
            _pin = '';
            _firstPin = '';
            _currentMode = _PinMode.setup;
            _error = L10nService.get('vault.vault_pin.those_dont_match_no_worries_try_again', language);
          });
        }
        break;

      case _PinMode.verify:
        if (vaultService.verifyPin(_pin)) {
          if (widget.mode == 'change') {
            setState(() {
              _pin = '';
              _currentMode = _PinMode.setup;
            });
          } else {
            _onVerified();
          }
        } else {
          HapticService.error();
          setState(() {
            _pin = '';
            _error = L10nService.get('vault.vault_pin.that_pin_didnt_match_try_again', language);
          });
        }
        break;

      case _PinMode.change:
        break;
    }
  }

  void _onVerified() {
    context.go(Routes.vault);
  }

  Future<bool> _showBiometricDialog(AppLanguage language) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(L10nService.get('vault.vault_pin.enable_face_id', language)),
        content: Text(
          L10nService.get('vault.vault_pin.use_face_id_to_quickly_access_your_vault', language),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(L10nService.get('vault.vault_pin.not_now', language)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(L10nService.get('vault.vault_pin.enable', language)),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String title;
    String subtitle;
    switch (_currentMode) {
      case _PinMode.setup:
        title = L10nService.get('vault.vault_pin.create_pin', language);
        subtitle = L10nService.get('vault.vault_pin.choose_a_4digit_pin_for_your_vault', language);
        break;
      case _PinMode.confirm:
        title = L10nService.get('vault.vault_pin.confirm_pin', language);
        subtitle = L10nService.get('vault.vault_pin.enter_the_same_pin_again', language);
        break;
      case _PinMode.verify:
        title = L10nService.get('vault.vault_pin.enter_pin', language);
        subtitle = L10nService.get('vault.vault_pin.enter_your_vault_pin', language);
        break;
      case _PinMode.change:
        title = L10nService.get('vault.vault_pin.new_pin', language);
        subtitle = L10nService.get('vault.vault_pin.choose_a_new_4digit_pin', language);
        break;
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.chevron_back,
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                    tooltip: L10nService.get('vault.vault_pin.back', language),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Lock icon
              Icon(
                CupertinoIcons.lock_shield_fill,
                size: 56,
                color: AppColors.amethyst,
              ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),

              const SizedBox(height: 24),

              // Title
              GradientText(
                title,
                variant: GradientTextVariant.amethyst,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 8),

              Text(
                subtitle,
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ).animate().fadeIn(delay: 150.ms),

              const SizedBox(height: 32),

              // PIN dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (i) {
                  final filled = i < _pin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: filled ? 18 : 14,
                    height: filled ? 18 : 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? AppColors.amethyst
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.1)),
                      boxShadow: filled
                          ? [
                              BoxShadow(
                                color: AppColors.amethyst.withValues(alpha: 0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  );
                }),
              ),

              // Error text
              SizedBox(
                height: 32,
                child: _error != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _error!,
                          style: AppTypography.subtitle(
                            fontSize: 13,
                            color: AppColors.error,
                          ),
                        ).animate().shake(duration: 300.ms),
                      )
                    : null,
              ),

              const Spacer(flex: 1),

              // Number pad
              _buildNumPad(isDark),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumPad(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          for (int row = 0; row < 4; row++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (row < 3) ...[
                    for (int col = 0; col < 3; col++)
                      _buildDigitButton(row * 3 + col + 1, isDark),
                  ] else ...[
                    // Bottom row: empty, 0, delete
                    const SizedBox(width: 72, height: 72),
                    _buildDigitButton(0, isDark),
                    _buildDeleteButton(isDark),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDigitButton(int digit, bool isDark) {
    return GestureDetector(
      onTap: () => _onDigitTap(digit),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
        ),
        child: Center(
          child: Text(
            '$digit',
            style: AppTypography.displayFont.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(bool isDark) {
    return GestureDetector(
      onTap: _onDelete,
      child: SizedBox(
        width: 72,
        height: 72,
        child: Center(
          child: Icon(
            CupertinoIcons.delete_left,
            size: 26,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ),
    );
  }
}
