// ════════════════════════════════════════════════════════════════════════════
// BOND TOUCH BUTTON - Animated circular send button with haptic + glow
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/bond.dart';
import '../../../../data/services/haptic_service.dart';

class BondTouchButton extends StatefulWidget {
  final TouchType touchType;
  final bool isThrottled;
  final VoidCallback? onSend;

  const BondTouchButton({
    super.key,
    required this.touchType,
    this.isThrottled = false,
    this.onSend,
  });

  @override
  State<BondTouchButton> createState() => _BondTouchButtonState();
}

class _BondTouchButtonState extends State<BondTouchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  bool get _isActive => !widget.isThrottled && widget.onSend != null;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.15, end: 0.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (_isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant BondTouchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isActive && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!_isActive && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isActive) return;
    HapticService.success();
    widget.onSend?.call();
  }

  void _onTapDown(TapDownDetails _) {
    if (!_isActive) return;
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    if (!_isActive) return;
    setState(() => _isPressed = false);
    _handleTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Touch button
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = _isPressed
                  ? 0.92
                  : (disableAnimations || !_isActive
                      ? 1.0
                      : _pulseAnimation.value);
              final glowAlpha = disableAnimations || !_isActive
                  ? 0.0
                  : _glowAnimation.value;

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _isActive
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.starGold,
                              AppColors.celestialGold,
                            ],
                          )
                        : null,
                    color: _isActive
                        ? null
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06)),
                    boxShadow: _isActive
                        ? [
                            BoxShadow(
                              color: AppColors.starGold
                                  .withValues(alpha: glowAlpha),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      widget.touchType.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            },
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.7, 0.7),
              end: const Offset(1.0, 1.0),
              duration: 500.ms,
              curve: Curves.easeOutBack,
            ),

        const SizedBox(height: 12),

        // Label
        AnimatedOpacity(
          opacity: _isActive ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 250),
          child: Text(
            widget.isThrottled ? _throttledLabel(isDark) : widget.touchType.displayNameEn,
            style: AppTypography.subtitle(
              fontSize: 13,
              color: _isActive
                  ? (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            ),
          ),
        ),
      ],
    );
  }

  String _throttledLabel(bool isDark) => 'Sent';
}
