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
        await showContextualPaywall(context, ref,
            paywallContext: PaywallContext.general);
      }
      return;
    }

    if (_service == null || !_isAvailable) {
      _showError(_getUnavailableMessage());
      return;
    }

    HapticFeedback.mediumImpact();

    if (_isListening) {
      await _service!.stopListening();
    } else {
      final started = await _service!.startListening(
        localeId: widget.localeId,
      );
      if (!started && mounted) {
        _showError(_getPermissionMessage());
      }
    }
  }

  String _getUnavailableMessage() {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    return isEn
        ? 'Voice input is not available on this device.'
        : 'Sesli giriş bu cihazda kullanılamıyor.';
  }

  String _getPermissionMessage() {
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    return isEn
        ? 'Microphone permission is required for voice input. Please enable it in Settings.'
        : 'Sesli giriş için mikrofon izni gerekli. Lütfen Ayarlar\'dan etkinleştirin.';
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = ref.watch(premiumProvider).isPremium;

    if (!isPremium) {
      return _buildLockedButton(isDark);
    }

    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
      );
    }

    return _buildMicButton(isDark);
  }

  Widget _buildLockedButton(bool isDark) {
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    return GestureDetector(
      onTap: _toggleListening,
      child: Semantics(
        label: 'Voice input (premium)',
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
                  child: const Icon(
                    Icons.lock,
                    size: 9,
                    color: Colors.white,
                  ),
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

    Widget button = GestureDetector(
      onTap: _isAvailable ? _toggleListening : null,
      child: Semantics(
        label: _isListening ? 'Stop voice input' : 'Start voice input',
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
