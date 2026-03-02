// ════════════════════════════════════════════════════════════════════════════
// MOOD BOARD CARD - Today feed mini mood color strip
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';

class MoodBoardCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const MoodBoardCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  static const _moodColors = <int, Color>{
    1: Color(0xFF8B6F5E),
    2: Color(0xFFB8956A),
    3: Color(0xFFD4A07A),
    4: Color(0xFFC8553D),
    5: Color(0xFFD4704A),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    return moodAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final week = service.getWeekMoods();
        final hasData = week.any((m) => m != null);
        if (!hasData) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: GestureDetector(
            onTap: () => context.push(Routes.moodBoard),
            child: PremiumCard(
              style: PremiumCardStyle.aurora,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('\u{1F3A8}',
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Text(
                          isEn ? 'Mood Board' : 'Ruh Hali Panosu',
                          style: AppTypography.modernAccent(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Mini 7-day color strip
                    Row(
                      children: week.map((m) {
                        final color = m != null
                            ? (_moodColors[m.mood.clamp(1, 5)] ??
                                AppColors.amethyst)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.black.withValues(alpha: 0.04));
                        return Expanded(
                          child: Container(
                            height: 28,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: m != null ? 0.7 : 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: m != null
                                ? Center(
                                    child: Text(m.emoji,
                                        style: const TextStyle(fontSize: 14)))
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
