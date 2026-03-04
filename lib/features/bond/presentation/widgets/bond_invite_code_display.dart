// ════════════════════════════════════════════════════════════════════════════
// BOND INVITE CODE DISPLAY - Large 6-digit code with share + expiry
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/bond.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/gradient_text.dart';

class BondInviteCodeDisplay extends StatefulWidget {
  final BondInvite invite;
  final bool isEn;

  const BondInviteCodeDisplay({
    super.key,
    required this.invite,
    required this.isEn,
  });

  @override
  State<BondInviteCodeDisplay> createState() => _BondInviteCodeDisplayState();
}

class _BondInviteCodeDisplayState extends State<BondInviteCodeDisplay> {
  Timer? _countdownTimer;
  Duration _remaining = Duration.zero;
  bool _justCopied = false;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateRemaining(),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final diff = widget.invite.expiresAt.difference(now);
    if (mounted) {
      setState(() {
        _remaining = diff.isNegative ? Duration.zero : diff;
      });
    }
  }

  String get _formattedCountdown {
    if (_remaining == Duration.zero) {
      return widget.isEn ? 'Expired' : 'Süresi doldu';
    }
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);
    if (hours > 0) {
      return widget.isEn ? '${hours}h ${minutes}m' : '${hours}sa ${minutes}dk';
    }
    return widget.isEn ? '${minutes}m ${seconds}s' : '${minutes}dk ${seconds}sn';
  }

  bool get _isExpired => _remaining == Duration.zero;

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.invite.code));
    HapticService.success();
    if (mounted) {
      setState(() => _justCopied = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _justCopied = false);
      });
    }
  }

  Future<void> _shareCode() async {
    HapticService.buttonPress();
    final message = widget.isEn
        ? 'Join me on InnerCycles! Use my bond code: ${widget.invite.code}'
        : 'InnerCycles\'te bana katıl! Bağ kodum: ${widget.invite.code}';
    await SharePlus.instance.share(ShareParams(text: message));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codeChars = widget.invite.code.split('');
    final screenWidth = MediaQuery.sizeOf(context).width;
    final digitWidth = screenWidth < 375 ? 38.0 : 44.0;
    final digitHeight = screenWidth < 375 ? 48.0 : 56.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          widget.isEn ? 'Your Invite Code' : 'Davet Kodun',
          style: AppTypography.subtitle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 16),

        // Code digits
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(codeChars.length, (i) {
            return Padding(
              padding: EdgeInsets.only(
                left: i == 0 ? 0 : 6,
                right: i == 3 ? 8 : 0, // gap between 3rd and 4th
              ),
              child: _CodeDigit(
                char: codeChars[i],
                isDark: isDark,
                isExpired: _isExpired,
                width: digitWidth,
                height: digitHeight,
              ),
            );
          }),
        )
            .animate()
            .fadeIn(duration: 500.ms, curve: Curves.easeOut)
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.0, 1.0),
              duration: 500.ms,
              curve: Curves.easeOutBack,
            ),
        const SizedBox(height: 16),

        // Countdown
        AnimatedOpacity(
          opacity: _isExpired ? 0.4 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isExpired ? Icons.timer_off_rounded : Icons.timer_outlined,
                size: 14,
                color: _isExpired
                    ? AppColors.error
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
              const SizedBox(width: 6),
              Text(
                _isExpired
                    ? _formattedCountdown
                    : (widget.isEn
                        ? 'Expires in $_formattedCountdown'
                        : '$_formattedCountdown sonra sona erer'),
                style: AppTypography.subtitle(
                  fontSize: 12,
                  color: _isExpired
                      ? AppColors.error
                      : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Copy button
            _ActionChip(
              label: _justCopied
                  ? (widget.isEn ? 'Copied!' : 'Kopyalandı!')
                  : (widget.isEn ? 'Copy' : 'Kopyala'),
              icon: _justCopied
                  ? Icons.check_rounded
                  : Icons.copy_rounded,
              isDark: isDark,
              isDisabled: _isExpired,
              onTap: _isExpired ? null : _copyCode,
            ),
            const SizedBox(width: 12),

            // Share button
            _ActionChip(
              label: widget.isEn ? 'Share' : 'Paylaş',
              icon: Icons.share_rounded,
              isDark: isDark,
              isPrimary: true,
              isDisabled: _isExpired,
              onTap: _isExpired ? null : _shareCode,
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CODE DIGIT
// ═══════════════════════════════════════════════════════════════════════════

class _CodeDigit extends StatelessWidget {
  final String char;
  final bool isDark;
  final bool isExpired;
  final double width;
  final double height;

  const _CodeDigit({
    required this.char,
    required this.isDark,
    required this.isExpired,
    this.width = 44,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpired
              ? AppColors.error.withValues(alpha: 0.2)
              : AppColors.amethyst.withValues(alpha: isDark ? 0.25 : 0.15),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: isExpired
          ? Text(
              char,
              style: AppTypography.elegantAccent(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
                letterSpacing: 0,
              ),
            )
          : GradientText(
              char,
              variant: GradientTextVariant.gold,
              style: AppTypography.elegantAccent(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ACTION CHIP
// ═══════════════════════════════════════════════════════════════════════════

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final bool isPrimary;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.isDark,
    this.isPrimary = false,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fgColor = isDisabled
        ? (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
        : isPrimary
            ? AppColors.deepSpace
            : (isDark ? AppColors.textPrimary : AppColors.lightTextPrimary);

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isPrimary && !isDisabled
              ? const LinearGradient(
                  colors: [AppColors.starGold, AppColors.celestialGold],
                )
              : null,
          color: isPrimary
              ? null
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fgColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.modernAccent(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
