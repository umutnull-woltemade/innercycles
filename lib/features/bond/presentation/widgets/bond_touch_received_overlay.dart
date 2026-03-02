// ════════════════════════════════════════════════════════════════════════════
// BOND TOUCH RECEIVED OVERLAY - Full-screen glow + haptic on receive
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/bond.dart';
import '../../../../data/services/haptic_service.dart';

class BondTouchReceivedOverlay extends StatefulWidget {
  final TouchType touchType;
  final String? senderName;
  final VoidCallback? onDismissed;

  const BondTouchReceivedOverlay({
    super.key,
    required this.touchType,
    this.senderName,
    this.onDismissed,
  });

  @override
  State<BondTouchReceivedOverlay> createState() =>
      _BondTouchReceivedOverlayState();
}

class _BondTouchReceivedOverlayState extends State<BondTouchReceivedOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Trigger haptic on receive
    _triggerHaptic();

    // Fade in
    _fadeController.forward();

    // Auto dismiss after 3 seconds
    _autoDismissTimer = Timer(const Duration(seconds: 3), _dismiss);
  }

  void _triggerHaptic() {
    switch (widget.touchType) {
      case TouchType.warm:
        HapticService.success();
      case TouchType.heartbeat:
        HapticService.streakMilestone();
      case TouchType.light:
        HapticService.selectionTap();
    }
  }

  Future<void> _dismiss() async {
    _autoDismissTimer?.cancel();
    if (!mounted) return;
    await _fadeController.reverse();
    if (!mounted) return;
    widget.onDismissed?.call();
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  Color get _glowColor {
    switch (widget.touchType) {
      case TouchType.warm:
        return AppColors.starGold;
      case TouchType.heartbeat:
        return AppColors.softCoral;
      case TouchType.light:
        return AppColors.auroraStart;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeController,
      child: GestureDetector(
        onTap: _dismiss,
        behavior: HitTestBehavior.opaque,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Radial glow background
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      _glowColor.withValues(alpha: isDark ? 0.25 : 0.15),
                      _glowColor.withValues(alpha: isDark ? 0.08 : 0.04),
                      Colors.black.withValues(alpha: isDark ? 0.6 : 0.3),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Touch emoji
                    Text(
                      widget.touchType.emoji,
                      style: const TextStyle(fontSize: 72),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.3, 0.3),
                          end: const Offset(1.0, 1.0),
                          duration: 600.ms,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(duration: 300.ms),
                    const SizedBox(height: 24),

                    // Touch type name
                    Text(
                      widget.touchType.displayNameEn,
                      style: AppTypography.elegantAccent(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: _glowColor,
                        letterSpacing: 3.0,
                      ),
                    )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        ),

                    if (widget.senderName != null) ...[
                      const SizedBox(height: 12),

                      // Sender name
                      Text(
                        'from ${widget.senderName}',
                        style: AppTypography.subtitle(
                          fontSize: 15,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      )
                          .animate(delay: 400.ms)
                          .fadeIn(duration: 400.ms),
                    ],

                    const SizedBox(height: 32),

                    // Tap to dismiss
                    Text(
                      'Tap to dismiss',
                      style: AppTypography.subtitle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted.withValues(alpha: 0.6)
                            : AppColors.lightTextMuted.withValues(alpha: 0.6),
                      ),
                    )
                        .animate(delay: 800.ms)
                        .fadeIn(duration: 500.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
