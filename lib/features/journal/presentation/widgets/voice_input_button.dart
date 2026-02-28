// ════════════════════════════════════════════════════════════════════════════
// VOICE INPUT BUTTON - Microphone toggle for voice journaling
// ════════════════════════════════════════════════════════════════════════════
// A ConsumerStatefulWidget that provides a pulsing microphone button.
// When tapped, it starts/stops speech recognition and streams the
// transcribed text back via a callback.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/premium_service.dart';
import '../../../../data/services/voice_journal_service.dart';
import '../../../premium/presentation/contextual_paywall_modal.dart';
import '../../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../../data/services/l10n_service.dart';

class VoiceInputButton extends ConsumerStatefulWidget {
  /// Called whenever new text is recognized from speech.
  /// The callback receives the full recognized text for the current session.
  final ValueChanged<String> onTextRecognized;

  /// Called when the listening state changes (true = started, false = stopped).
  final ValueChanged<bool>? onListeningStateChanged;

  /// Optional locale override (e.g. 'en_US', 'tr_TR').
  /// If null, the system default locale is used.
  final String? localeId;

  /// Size of the button. Defaults to 48.
  final double size;

  const VoiceInputButton({
    super.key,
    required this.onTextRecognized,
    this.onListeningStateChanged,
    this.localeId,
    this.size = 48,
  });

  @override
  ConsumerState<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends ConsumerState<VoiceInputButton> {
  bool _isListening = false;
  bool _isAvailable = false;
  bool _isLoading = true;
  VoiceJournalService? _service;
  StreamSubscription<String>? _textSub;
  StreamSubscription<bool>? _stateSub;
  StreamSubscription<String>? _errorSub;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    try {
      final service = await ref.read(voiceJournalServiceProvider.future);
      if (!mounted) return;
      _service = service;

      _textSub = service.onTextRecognized.listen((text) {
        widget.onTextRecognized(text);
      });

      _stateSub = service.onListeningStateChanged.listen((listening) {
        if (mounted) {
          setState(() => _isListening = listening);
          widget.onListeningStateChanged?.call(listening);
        }
      });

      _errorSub = service.onError.listen((error) {
        if (mounted) {
          _showError(error);
        }
      });

      setState(() {
        _isAvailable = service.isAvailable;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAvailable = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _textSub?.cancel();
    _stateSub?.cancel();
    _errorSub?.cancel();
    // Stop listening if active when widget is disposed
    if (_isListening) {
      _service?.stopListening();
    }
    super.dispose();
  }

  Future<void> _toggleListening() async {
    // GUARDRAIL: Voice journaling is a premium feature
    final isPremium = ref.read(premiumProvider).isPremium;
    if (!isPremium) {
      HapticFeedback.lightImpact();
      if (mounted) {
        await showContextualPaywall(
          context,
          ref,
          paywallContext: PaywallContext.general,
        );
      }
      return;
    }

    final service = _service;
    if (service == null || !_isAvailable) {
      _showError(_getUnavailableMessage());
      return;
    }

    HapticFeedback.mediumImpact();

    if (_isListening) {
      await service.stopListening();
    } else {
      final started = await service.startListening(localeId: widget.localeId);
      if (!started && mounted) {
        _showError(_getPermissionMessage());
      }
    }
  }

  String _getUnavailableMessage() {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    return L10nService.get('journal.voice_input_button.voice_input_is_not_available_on_this_dev', isEn ? AppLanguage.en : AppLanguage.tr);
  }

  String _getPermissionMessage() {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    return L10nService.get('journal.voice_input_button.microphone_permission_is_required_for_vo', isEn ? AppLanguage.en : AppLanguage.tr);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = ref.watch(isPremiumUserProvider);

    if (!isPremium) {
      return _buildLockedButton(isDark);
    }

    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const CosmicLoadingIndicator(size: 20),
      );
    }

    return _buildMicButton(isDark);
  }

  Widget _buildLockedButton(bool isDark) {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    return GestureDetector(
      onTap: _toggleListening,
      child: Semantics(
        label: L10nService.get('journal.voice_input_button.voice_input_premium', isEn ? AppLanguage.en : AppLanguage.tr),
        button: true,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: mutedColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: mutedColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.mic_rounded,
                      color: mutedColor,
                      size: widget.size * 0.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.celestialGold,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(Icons.lock, size: 9, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton(bool isDark) {
    final color = _isListening
        ? AppColors.error
        : (isDark ? AppColors.starGold : AppColors.starGold);

    final bgColor = _isListening
        ? AppColors.error.withValues(alpha: 0.15)
        : (isDark
              ? AppColors.surfaceLight.withValues(alpha: 0.5)
              : AppColors.lightSurfaceVariant);

    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    Widget button = GestureDetector(
      onTap: _isAvailable ? _toggleListening : null,
      child: Semantics(
        label: _isListening
            ? (L10nService.get('journal.voice_input_button.stop_voice_input', isEn ? AppLanguage.en : AppLanguage.tr))
            : (L10nService.get('journal.voice_input_button.start_voice_input', isEn ? AppLanguage.en : AppLanguage.tr)),
        button: true,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isListening
                  ? AppColors.error.withValues(alpha: 0.5)
                  : color.withValues(alpha: 0.3),
              width: _isListening ? 2 : 1,
            ),
            boxShadow: _isListening
                ? [
                    BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              _isListening ? Icons.stop_rounded : Icons.mic_rounded,
              color: _isAvailable
                  ? color
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              size: widget.size * 0.5,
            ),
          ),
        ),
      ),
    );

    // Add pulsing animation when actively listening
    if (_isListening) {
      button = button
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.08, 1.08),
            duration: 800.ms,
            curve: Curves.easeInOut,
          );
    }

    return button;
  }
}
