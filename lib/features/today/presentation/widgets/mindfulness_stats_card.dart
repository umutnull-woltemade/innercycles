import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/gradient_text.dart';

/// Provider that reads breathing + meditation session counts.
final mindfulnessStatsProvider = FutureProvider<(int, int)>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final breathing = prefs.getInt('mindfulness_breathing_count') ?? 0;
  final meditation = prefs.getInt('mindfulness_meditation_count') ?? 0;
  return (breathing, meditation);
});

/// Shows total breathing and meditation sessions completed.
class MindfulnessStatsCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const MindfulnessStatsCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(mindfulnessStatsProvider);

    return statsAsync.maybeWhen(
      data: (stats) {
        final breathing = stats.$1;
        final meditation = stats.$2;
        final total = breathing + meditation;
        if (total == 0) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.subtle,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.self_improvement_rounded,
                        size: 18, color: AppColors.auroraStart),
                    const SizedBox(width: 8),
                    GradientText(
                      isEn ? 'Mindfulness Practice' : 'Farkındalık Pratiği',
                      variant: GradientTextVariant.aurora,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatTile(
                      icon: Icons.air_rounded,
                      count: breathing,
                      label: isEn ? 'Breathing' : 'Nefes',
                      color: AppColors.chartBlue,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 16),
                    _StatTile(
                      icon: Icons.spa_rounded,
                      count: meditation,
                      label: isEn ? 'Meditation' : 'Meditasyon',
                      color: AppColors.chartPurple,
                      isDark: isDark,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.auroraStart.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isEn ? '$total total' : '$total toplam',
                        style: AppTypography.modernAccent(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.auroraStart,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;
  final bool isDark;

  const _StatTile({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: AppTypography.displayFont.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: AppTypography.elegantAccent(
                fontSize: 10,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
