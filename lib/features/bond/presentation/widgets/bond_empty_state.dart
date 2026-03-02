// ════════════════════════════════════════════════════════════════════════════
// BOND EMPTY STATE - No bonds CTA with illustration text + invite button
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/gradient_text.dart';

class BondEmptyState extends StatelessWidget {
  final AppLanguage language;
  final VoidCallback? onInvite;

  const BondEmptyState({
    super.key,
    required this.language,
    this.onInvite,
  });

  bool get isEn => language == AppLanguage.en;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Illustration emoji cluster
          _IllustrationCluster()
              .animate()
              .fadeIn(duration: 600.ms, curve: Curves.easeOut)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: 28),

          // Title
          GradientText(
            isEn ? 'Create a Bond' : 'Bir Bağ Kur',
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: 200.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms),
          const SizedBox(height: 14),

          // Description
          Text(
            isEn
                ? 'Invite your partner, best friend, or sibling to share a private emotional bond. See each other\'s mood signals and send gentle touches.'
                : 'Partnerini, en yakın arkadaşını veya kardeşini özel bir duygusal bağ kurmaya davet et. Birbirinizin ruh hali sinyallerini görün ve nazik dokunuşlar gönderin.',
            textAlign: TextAlign.center,
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              height: 1.6,
            ),
          )
              .animate(delay: 350.ms)
              .fadeIn(duration: 400.ms),
          const SizedBox(height: 32),

          // CTA button
          GradientButton.gold(
            label: isEn ? 'Invite Someone' : 'Birini Davet Et',
            icon: Icons.favorite_rounded,
            onPressed: onInvite,
            expanded: true,
          )
              .animate(delay: 500.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.15, end: 0, duration: 400.ms, curve: Curves.easeOut),
          const SizedBox(height: 16),

          // Privacy note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
              const SizedBox(width: 6),
              Text(
                isEn
                    ? 'End-to-end private. You control what\'s shared.'
                    : 'Uçtan uca gizli. Neyin paylaşıldığını sen kontrol et.',
                style: AppTypography.subtitle(
                  fontSize: 11,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          )
              .animate(delay: 650.ms)
              .fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ILLUSTRATION CLUSTER
// ═══════════════════════════════════════════════════════════════════════════

class _IllustrationCluster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft glow behind
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.amethyst.withValues(alpha: isDark ? 0.12 : 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Outer ring
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.amethyst.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
          ),

          // Inner ring
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
          ),

          // Center hearts
          const Text(
            '💑',
            style: TextStyle(fontSize: 36),
          ),
        ],
      ),
    );
  }
}
