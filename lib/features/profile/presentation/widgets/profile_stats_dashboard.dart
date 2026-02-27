// ════════════════════════════════════════════════════════════════════════════
// PROFILE STATS DASHBOARD - 4-column stat row in aurora card
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/premium_card.dart';

class ProfileStatsDashboard extends StatelessWidget {
  final int streak;
  final int entries;
  final int daysActive;
  final int challenges;
  final int totalWords;
  final bool isDark;
  final bool isEn;

  const ProfileStatsDashboard({
    super.key,
    required this.streak,
    required this.entries,
    required this.daysActive,
    required this.challenges,
    this.totalWords = 0,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingLg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatColumn(
            emoji: '\u{1F525}',
            value: '$streak',
            label: isEn ? 'STREAK' : 'SER\u0130',
            color: AppColors.streakOrange,
          ),
          _StatColumn(
            emoji: '\u{1F4D3}',
            value: '$entries',
            label: isEn ? 'ENTRIES' : 'KAYITLAR',
            color: AppColors.auroraStart,
          ),
          _StatColumn(
            emoji: '\u{270F}\u{FE0F}',
            value: totalWords >= 1000
                ? '${(totalWords / 1000).toStringAsFixed(1)}K'
                : '$totalWords',
            label: isEn ? 'WORDS' : 'KEL\u0130ME',
            color: AppColors.starGold,
          ),
          _StatColumn(
            emoji: '\u{1F3C6}',
            value: '$challenges',
            label: isEn ? 'DONE' : 'B\u0130TEN',
            color: AppColors.amethyst,
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatColumn({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: AppConstants.spacingXs),
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: color.withValues(alpha: 0.7),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
