// ════════════════════════════════════════════════════════════════════════════
// BOND PARTNER CARD - PremiumCard.amethyst with partner info + mood orb
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/bond.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/providers/bond_providers.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/signal_orb.dart';

class BondPartnerCard extends ConsumerWidget {
  final Bond bond;
  final AppLanguage language;
  final String currentUserId;
  final VoidCallback? onTap;

  const BondPartnerCard({
    super.key,
    required this.bond,
    required this.language,
    required this.currentUserId,
    this.onTap,
  });

  bool get isEn => language == AppLanguage.en;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final partnerName = bond.partnerDisplayName(currentUserId) ??
        (isEn ? 'Partner' : 'Partner');
    final partnerMoodAsync = ref.watch(partnerMoodProvider(bond.id));

    return GestureDetector(
      onTap: onTap,
      child: PremiumCard(
        style: PremiumCardStyle.amethyst,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Partner mood orb or placeholder
            _PartnerMoodOrb(
              signalId: partnerMoodAsync.valueOrNull,
              isDark: isDark,
            ),
            const SizedBox(width: 16),

            // Partner info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Partner name
                  Text(
                    partnerName,
                    style: AppTypography.subtitle(
                      fontSize: 17,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ).copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Bond type with emoji
                  Row(
                    children: [
                      Text(
                        bond.bondType.emoji,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          bond.bondType.localizedName(language),
                          style: AppTypography.subtitle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Mood signal status
                  _MoodSignalLabel(
                    signalId: partnerMoodAsync.valueOrNull,
                    isDark: isDark,
                    isEn: isEn,
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
              size: 22,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PARTNER MOOD ORB
// ═══════════════════════════════════════════════════════════════════════════

class _PartnerMoodOrb extends StatelessWidget {
  final String? signalId;
  final bool isDark;

  const _PartnerMoodOrb({
    required this.signalId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (signalId != null) {
      return SignalOrb.inline(signalId: signalId);
    }

    // Placeholder grey dot when no mood shared
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MOOD SIGNAL LABEL
// ═══════════════════════════════════════════════════════════════════════════

class _MoodSignalLabel extends StatelessWidget {
  final String? signalId;
  final bool isDark;
  final bool isEn;

  const _MoodSignalLabel({
    required this.signalId,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final text = signalId != null
        ? (isEn ? 'Mood shared today' : 'Ruh hali bugün paylaşıldı')
        : (isEn ? 'No mood shared yet' : 'Henüz ruh hali paylaşılmadı');

    final color = signalId != null
        ? AppColors.amethyst
        : (isDark ? AppColors.textMuted : AppColors.lightTextMuted);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: signalId != null
                ? AppColors.success
                : (isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.1)),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: AppTypography.subtitle(fontSize: 11, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
