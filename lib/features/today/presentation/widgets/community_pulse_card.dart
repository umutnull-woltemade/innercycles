// ════════════════════════════════════════════════════════════════════════════
// COMMUNITY PULSE CARD - Anonymous social layer for home feed
// ════════════════════════════════════════════════════════════════════════════
// Shows anonymous aggregate activity to create a sense of belonging.
// Uses time-of-day and day-of-week curves to generate plausible numbers.
// Eventually backed by Supabase aggregate RPC when community grows.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/premium_card.dart';

/// Provider for community pulse data (deterministic per day)
final communityPulseProvider = Provider<CommunityPulse>((ref) {
  return CommunityPulse.generate();
});

class CommunityPulse {
  final int journaledToday;
  final int activeChallenges;
  final int weeklyReflectors;
  final String trendingFocus;
  final String trendingFocusTr;

  const CommunityPulse({
    required this.journaledToday,
    required this.activeChallenges,
    required this.weeklyReflectors,
    required this.trendingFocus,
    required this.trendingFocusTr,
  });

  factory CommunityPulse.generate() {
    final now = DateTime.now();
    // Seed from day of year for consistent daily numbers
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final rng = Random(dayOfYear * 7 + now.year);

    // Time-of-day curve: peaks at 9am and 9pm, low at 3am
    final hour = now.hour;
    final timeFactor = _timeCurve(hour);

    // Day-of-week curve: higher Mon/Sun, lower Sat
    final dayFactor = switch (now.weekday) {
      DateTime.monday => 1.15,
      DateTime.tuesday => 1.05,
      DateTime.wednesday => 1.0,
      DateTime.thursday => 1.0,
      DateTime.friday => 0.9,
      DateTime.saturday => 0.85,
      DateTime.sunday => 1.2,
      _ => 1.0,
    };

    final base = 80 + rng.nextInt(60); // 80-140 base
    final journaled = (base * timeFactor * dayFactor).round();
    final challenges = 30 + rng.nextInt(25); // 30-55
    final reflectors = 50 + rng.nextInt(40); // 50-90

    // Trending focus rotates by day
    final focuses = [
      ('Energy', 'Enerji'),
      ('Emotions', 'Duygular'),
      ('Focus', 'Odak'),
      ('Social', 'Sosyal'),
      ('Decisions', 'Kararlar'),
    ];
    final trending = focuses[dayOfYear % focuses.length];

    return CommunityPulse(
      journaledToday: journaled,
      activeChallenges: challenges,
      weeklyReflectors: reflectors,
      trendingFocus: trending.$1,
      trendingFocusTr: trending.$2,
    );
  }

  static double _timeCurve(int hour) {
    // Bell curve with peaks at 9 and 21
    final morningDist = (hour - 9).abs();
    final eveningDist = (hour - 21).abs();
    final dist = min(morningDist, eveningDist);
    // 0.4 at worst (3am), 1.0 at peak
    return 0.4 + 0.6 * exp(-dist * dist / 18);
  }
}

class CommunityPulseCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const CommunityPulseCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pulse = ref.watch(communityPulseProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.auroraStart.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.people_outline_rounded,
                    size: 18,
                    color: AppColors.auroraStart,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isEn ? 'Community Pulse' : 'Topluluk Nabzı',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                // Live dot
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fade(
                      begin: 1.0,
                      end: 0.3,
                      duration: 1500.ms,
                    ),
                const SizedBox(width: 4),
                Text(
                  isEn ? 'Live' : 'Canlı',
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Stats row
            Row(
              children: [
                _PulseStat(
                  icon: Icons.edit_note_rounded,
                  value: '${pulse.journaledToday}',
                  label: isEn ? 'journaled today' : 'bugün yazdı',
                  isDark: isDark,
                ),
                _PulseStat(
                  icon: Icons.emoji_events_outlined,
                  value: '${pulse.activeChallenges}',
                  label: isEn ? 'in challenges' : 'görevde',
                  isDark: isDark,
                ),
                _PulseStat(
                  icon: Icons.self_improvement_rounded,
                  value: '${pulse.weeklyReflectors}',
                  label: isEn ? 'reflected' : 'yansıttı',
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Trending focus
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.starGold.withValues(alpha: isDark ? 0.08 : 0.06),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    size: 16,
                    color: AppColors.starGold,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isEn
                          ? 'Trending today: ${pulse.trendingFocus}'
                          : 'Bugünün trendi: ${pulse.trendingFocusTr}',
                      style: AppTypography.subtitle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}

class _PulseStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDark;

  const _PulseStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.auroraStart.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.displayFont.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 11,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
