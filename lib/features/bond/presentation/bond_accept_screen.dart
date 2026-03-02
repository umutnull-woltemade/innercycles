// ════════════════════════════════════════════════════════════════════════════
// BOND ACCEPT SCREEN - OTP-style 6-digit code input to accept invite
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/bond.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/providers/bond_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class BondAcceptScreen extends ConsumerStatefulWidget {
  final String? prefilledCode;

  const BondAcceptScreen({
    super.key,
    this.prefilledCode,
  });

  @override
  ConsumerState<BondAcceptScreen> createState() => _BondAcceptScreenState();
}

class _BondAcceptScreenState extends ConsumerState<BondAcceptScreen> {
  static const _codeLength = 6;
  final List<TextEditingController> _controllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _codeLength,
    (_) => FocusNode(),
  );

  bool _isValidating = false;
  String? _errorMessage;
  bool _isSuccess = false;
  Bond? _acceptedBond;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledCode != null && widget.prefilledCode!.length == _codeLength) {
      for (var i = 0; i < _codeLength; i++) {
        _controllers[i].text = widget.prefilledCode![i].toUpperCase();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();
  bool get _isCodeComplete => _code.length == _codeLength;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: isEn ? 'Accept Bond' : 'Bag Kabul Et',
                  useGradientTitle: true,
                  gradientVariant: GradientTextVariant.amethyst,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _isSuccess
                        ? _buildSuccessState(isDark, isEn)
                        : _buildCodeInput(isDark, isEn),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CODE INPUT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCodeInput(bool isDark, bool isEn) {
    return Column(
      children: [
        const SizedBox(height: 24),

        // Icon
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark
                ? AppColors.amethyst.withValues(alpha: 0.12)
                : AppColors.amethyst.withValues(alpha: 0.08),
          ),
          child: const Center(
            child: Text('🔗', style: TextStyle(fontSize: 32)),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 400.ms,
              curve: Curves.easeOutBack,
            ),
        const SizedBox(height: 20),

        // Title
        GradientText(
          isEn ? 'Enter Invite Code' : 'Davet Kodunu Gir',
          variant: GradientTextVariant.amethyst,
          style: AppTypography.displayFont.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        )
            .animate(delay: 80.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 8),

        Text(
          isEn
              ? 'Enter the 6-character code shared by your bond partner.'
              : 'Bag partnerinin paylastigi 6 karakterli kodu gir.',
          textAlign: TextAlign.center,
          style: AppTypography.subtitle(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        )
            .animate(delay: 120.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 36),

        // OTP-style input fields
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_codeLength, (i) {
            return Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 0 : 6,
                right: i == 2 ? 10 : 0, // gap between 3rd and 4th
              ),
              child: _CodeInputField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                isDark: isDark,
                hasError: _errorMessage != null,
                onChanged: (value) => _onDigitChanged(i, value),
                onBackspace: () => _onBackspace(i),
              ),
            );
          }),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .slideY(
                begin: 0.06,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOut),
        const SizedBox(height: 24),

        // Error message
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: _errorMessage != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.subtitle(
                            fontSize: 13,
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),

        // Validate button
        GradientButton.gold(
          label: isEn ? 'Connect' : 'Baglan',
          icon: Icons.link_rounded,
          expanded: true,
          isLoading: _isValidating,
          onPressed: _isCodeComplete ? _validateCode : null,
        )
            .animate(delay: 320.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUCCESS STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSuccessState(bool isDark, bool isEn) {
    return Column(
      children: [
        const SizedBox(height: 48),

        // Success animation
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.success.withValues(alpha: 0.2),
                AppColors.success.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.favorite_rounded,
              color: AppColors.success,
              size: 42,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 600.ms,
              curve: Curves.easeOutBack,
            ),
        const SizedBox(height: 24),

        // Title
        GradientText(
          isEn ? 'Bond Created!' : 'Bag Kuruldu!',
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 26,
          ),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 12),

        if (_acceptedBond != null) ...[
          // Bond type display
          PremiumCard(
            style: PremiumCardStyle.amethyst,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _acceptedBond!.bondType.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 10),
                Text(
                  _acceptedBond!.bondType.displayNameEn,
                  style: AppTypography.subtitle(
                    fontSize: 16,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
              .animate(delay: 300.ms)
              .fadeIn(duration: 400.ms, curve: Curves.easeOut),
          const SizedBox(height: 12),
        ],

        Text(
          isEn
              ? 'You are now connected. Start sharing your moods and sending touches!'
              : 'Artik baglisiniz. Ruh hallerini paylasma ve dokunuslar gondermeye basla!',
          textAlign: TextAlign.center,
          style: AppTypography.subtitle(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        )
            .animate(delay: 350.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
        const SizedBox(height: 36),

        // Go to bond hub
        GradientButton.gold(
          label: isEn ? 'Go to Bonds' : 'Baglara Git',
          icon: Icons.people_rounded,
          expanded: true,
          onPressed: () {
            HapticService.buttonPress();
            ref.invalidate(activeBondsProvider);
            context.go('/bond');
          },
        )
            .animate(delay: 450.ms)
            .fadeIn(duration: 400.ms, curve: Curves.easeOut),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INPUT LOGIC
  // ═══════════════════════════════════════════════════════════════════════════

  void _onDigitChanged(int index, String value) {
    setState(() => _errorMessage = null);

    if (value.isNotEmpty) {
      // Auto-advance to next field
      if (index < _codeLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() {});
  }

  void _onBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      setState(() {});
    }
  }

  Future<void> _validateCode() async {
    if (!_isCodeComplete || _isValidating) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isValidating = true;
      _errorMessage = null;
    });

    try {
      final bondService = await ref.read(bondServiceProvider.future);
      final bond = await bondService.acceptInvite(_code);

      if (!mounted) return;

      if (bond != null) {
        HapticService.success();
        setState(() {
          _isSuccess = true;
          _acceptedBond = bond;
          _isValidating = false;
        });
      } else {
        HapticService.error();
        final language = ref.read(languageProvider);
        final isEn = language == AppLanguage.en;
        setState(() {
          _errorMessage = isEn
              ? 'Invalid or expired code. Please check and try again.'
              : 'Gecersiz veya suresi dolmus kod. Kontrol edip tekrar dene.';
          _isValidating = false;
        });
      }
    } catch (_) {
      HapticService.error();
      if (mounted) {
        final language = ref.read(languageProvider);
        final isEn = language == AppLanguage.en;
        setState(() {
          _errorMessage = isEn
              ? 'Something went wrong. Please try again.'
              : 'Bir seyler ters gitti. Lutfen tekrar dene.';
          _isValidating = false;
        });
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CODE INPUT FIELD
// ═══════════════════════════════════════════════════════════════════════════

class _CodeInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _CodeInputField({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.hasError,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.isNotEmpty;

    return SizedBox(
      width: 46,
      height: 58,
      child: KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            onBackspace();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLength: 1,
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
            UpperCaseTextFormatter(),
          ],
          style: AppTypography.elegantAccent(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: hasError
                ? AppColors.error
                : (isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary),
            letterSpacing: 0,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.error.withValues(alpha: 0.4)
                    : hasValue
                        ? AppColors.amethyst.withValues(alpha: isDark ? 0.3 : 0.2)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.08)),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.error.withValues(alpha: 0.6)
                    : AppColors.amethyst.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// UPPER CASE FORMATTER
// ═══════════════════════════════════════════════════════════════════════════

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
