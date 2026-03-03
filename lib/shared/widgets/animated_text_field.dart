import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/liquid_glass/glass_animations.dart';
import '../../core/theme/liquid_glass/glass_tokens.dart';
import '../../data/services/haptic_service.dart';

/// Premium text input with animated focus border, validation shake,
/// and character counter.
///
/// Usage:
///   AnimatedTextField(
///     controller: _controller,
///     label: 'Title',
///     maxLength: 100,
///     validator: (v) => v?.isEmpty == true ? 'Required' : null,
///   )
class AnimatedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final int? maxLength;
  final int maxLines;
  final int minLines;
  final bool showCounter;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;

  const AnimatedTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.showCounter = false,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.enabled = true,
    this.prefix,
    this.suffix,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _borderController;
  late final Animation<double> _borderWidth;
  late final Animation<double> _glowOpacity;
  bool _isFocused = false;
  String? _errorText;
  bool _showShake = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);

    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _borderWidth = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.easeOutCubic),
    );
    _glowOpacity = Tween<double>(begin: 0.0, end: 0.15).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) _focusNode.dispose();
    _borderController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      _borderController.forward();
      HapticService.selectionTap();
    } else {
      _borderController.reverse();
      _validate();
    }
  }

  void _validate() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller?.text);
      if (error != null && error != _errorText) {
        setState(() {
          _errorText = error;
          _showShake = true;
        });
        HapticService.error();
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) setState(() => _showShake = false);
        });
      } else {
        setState(() => _errorText = error);
      }
    }
  }

  Color _counterColor(int current, int max) {
    final ratio = current / max;
    if (ratio < 0.7) return AppColors.success;
    if (ratio < 0.9) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = _errorText != null;
    final textColor = isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    final currentLength = widget.controller?.text.length ?? 0;

    Widget field = Semantics(
      textField: true,
      label: widget.label,
      child: AnimatedBuilder(
        animation: _borderController,
        builder: (context, child) {
          final borderColor = hasError
              ? AppColors.error
              : _isFocused
                  ? AppColors.starGold
                  : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1);

          return Container(
            constraints: const BoxConstraints(minHeight: 48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GlassTokens.radiusMd),
              border: Border.all(
                color: borderColor,
                width: hasError ? 1.5 : _borderWidth.value,
              ),
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.04),
              boxShadow: _isFocused && !hasError
                  ? [
                      BoxShadow(
                        color: AppColors.starGold
                            .withValues(alpha: _glowOpacity.value),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              style: AppTypography.subtitle(
                fontSize: 15,
                color: textColor,
              ),
              onChanged: (value) {
                widget.onChanged?.call(value);
                if (hasError) _validate();
                if (widget.showCounter && widget.maxLength != null) {
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                labelStyle: AppTypography.subtitle(
                  fontSize: 14,
                  color: _isFocused ? AppColors.starGold : mutedColor,
                ),
                hintStyle: AppTypography.subtitle(
                  fontSize: 14,
                  color: mutedColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                counterText: '',
                prefixIcon: widget.prefix,
                suffixIcon: widget.suffix,
              ),
            ),
            if (hasError || (widget.showCounter && widget.maxLength != null))
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                child: Row(
                  children: [
                    if (hasError)
                      Expanded(
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            _errorText!,
                            style: AppTypography.subtitle(
                              fontSize: 12,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (widget.showCounter && widget.maxLength != null)
                      Text(
                        '$currentLength/${widget.maxLength}',
                        style: AppTypography.subtitle(
                          fontSize: 11,
                          color: _counterColor(currentLength, widget.maxLength!),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    if (_showShake) {
      field = field.glassShake(context: context);
    }

    return field;
  }
}
