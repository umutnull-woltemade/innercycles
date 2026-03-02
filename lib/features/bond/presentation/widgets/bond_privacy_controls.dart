// ════════════════════════════════════════════════════════════════════════════
// BOND PRIVACY CONTROLS - CupertinoSwitch toggles for bond sharing prefs
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/bond.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';

class BondPrivacyControls extends ConsumerWidget {
  final BondPrivacy privacy;
  final AppLanguage language;
  final ValueChanged<BondPrivacy> onChanged;

  const BondPrivacyControls({
    super.key,
    required this.privacy,
    required this.language,
    required this.onChanged,
  });

  bool get isEn => language == AppLanguage.en;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: Text(
              isEn ? 'Privacy' : 'Gizlilik',
              style: AppTypography.modernAccent(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              isEn
                  ? 'Control what your partner can see'
                  : 'Partnerinin görebileceklerini kontrol et',
              style: AppTypography.subtitle(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),

          // Toggles
          _PrivacyToggle(
            icon: CupertinoIcons.smiley,
            title: isEn ? 'Share Mood' : 'Ruh Halini Paylaş',
            subtitle: isEn
                ? 'Let your partner see your daily mood'
                : 'Partnerinin günlük ruh halini görmesine izin ver',
            value: privacy.shareMood,
            isDark: isDark,
            onChanged: (v) {
              HapticService.toggleChanged();
              onChanged(privacy.copyWith(shareMood: v));
            },
          ),
          _divider(isDark),

          _PrivacyToggle(
            icon: CupertinoIcons.circle_fill,
            title: isEn ? 'Share Signal' : 'Sinyali Paylaş',
            subtitle: isEn
                ? 'Show your mood signal orb to your partner'
                : 'Ruh hali sinyal orbunu partnerine göster',
            value: privacy.shareSignal,
            isDark: isDark,
            onChanged: (v) {
              HapticService.toggleChanged();
              onChanged(privacy.copyWith(shareSignal: v));
            },
          ),
          _divider(isDark),

          _PrivacyToggle(
            icon: CupertinoIcons.flame,
            title: isEn ? 'Share Streak' : 'Seriyi Paylaş',
            subtitle: isEn
                ? 'Display your journaling streak'
                : 'Günlük yazma serini göster',
            value: privacy.shareStreak,
            isDark: isDark,
            onChanged: (v) {
              HapticService.toggleChanged();
              onChanged(privacy.copyWith(shareStreak: v));
            },
          ),
          _divider(isDark),

          _PrivacyToggle(
            icon: CupertinoIcons.hand_raised,
            title: isEn ? 'Allow Touches' : 'Dokunuşlara İzin Ver',
            subtitle: isEn
                ? 'Receive haptic touches from your partner'
                : 'Partnerinden dokunuş bildirimleri al',
            value: privacy.allowTouches,
            isDark: isDark,
            onChanged: (v) {
              HapticService.toggleChanged();
              onChanged(privacy.copyWith(allowTouches: v));
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.03, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _divider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 0.5,
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.black.withValues(alpha: 0.04),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INDIVIDUAL TOGGLE ROW
// ═══════════════════════════════════════════════════════════════════════════

class _PrivacyToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _PrivacyToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? AppColors.amethyst.withValues(alpha: 0.12)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04)),
            ),
            child: Icon(
              icon,
              size: 16,
              color: value
                  ? AppColors.amethyst
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            ),
          ),
          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.subtitle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Switch
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.amethyst,
          ),
        ],
      ),
    );
  }
}
