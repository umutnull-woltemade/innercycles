// ════════════════════════════════════════════════════════════════════════════
// FEATURE DISCOVERY TIP — Dismissable first-time tip banner
// ════════════════════════════════════════════════════════════════════════════
// Shows a subtle contextual tip the first time a user visits a screen.
// Persists dismissal in SharedPreferences so it only shows once.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class FeatureDiscoveryTip extends StatefulWidget {
  final String tipKey;
  final String tipText;
  final IconData icon;
  final bool isDark;

  const FeatureDiscoveryTip({
    super.key,
    required this.tipKey,
    required this.tipText,
    this.icon = Icons.lightbulb_outline_rounded,
    required this.isDark,
  });

  @override
  State<FeatureDiscoveryTip> createState() => _FeatureDiscoveryTipState();
}

class _FeatureDiscoveryTipState extends State<FeatureDiscoveryTip> {
  bool _dismissed = true; // Start hidden until we check

  @override
  void initState() {
    super.initState();
    _checkIfSeen();
  }

  Future<void> _checkIfSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('tip_${widget.tipKey}') ?? false;
    if (!seen && mounted) {
      setState(() => _dismissed = false);
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tip_${widget.tipKey}', true);
    if (mounted) setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.starGold.withValues(alpha: widget.isDark ? 0.08 : 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            size: 18,
            color: AppColors.starGold,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.tipText,
              style: AppTypography.subtitle(
                fontSize: 13,
                color: widget.isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          GestureDetector(
            onTap: _dismiss,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: widget.isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: -0.1, duration: 400.ms);
  }
}
