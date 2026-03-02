import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../data/providers/app_providers.dart';

/// Shows a subtle focus area streak badge when the user has logged
/// consecutive days with the same focus area (2+ days).
class FocusAreaStreak extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const FocusAreaStreak({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  static const _focusAreaEmoji = {
    FocusArea.energy: '\u26A1',
    FocusArea.focus: '\uD83C\uDFAF',
    FocusArea.emotions: '\uD83D\uDC9C',
    FocusArea.decisions: '\uD83E\uDDED',
    FocusArea.social: '\uD83E\uDD1D',
  };

  static const _focusAreaColors = {
    FocusArea.energy: AppColors.starGold,
    FocusArea.focus: AppColors.chartBlue,
    FocusArea.emotions: AppColors.chartPink,
    FocusArea.decisions: AppColors.chartGreen,
    FocusArea.social: AppColors.chartPurple,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final entries = service.getAllEntries();
        if (entries.length < 2) return const SizedBox.shrink();

        // Sort by date descending (most recent first)
        final sorted = [...entries]
          ..sort((a, b) => b.date.compareTo(a.date));

        // Count consecutive days with same focus area
        final firstArea = sorted.first.focusArea;
        int streak = 1;
        for (int i = 1; i < sorted.length && i < 30; i++) {
          if (sorted[i].focusArea == firstArea) {
            // Check it's actually a consecutive day
            final dayDiff =
                sorted[i - 1].date.difference(sorted[i].date).inDays;
            if (dayDiff <= 1) {
              streak++;
            } else {
              break;
            }
          } else {
            break;
          }
        }

        if (streak < 2) return const SizedBox.shrink();

        final emoji = _focusAreaEmoji[firstArea] ?? '\u26A1';
        final color = _focusAreaColors[firstArea] ?? AppColors.starGold;
        final areaName = isEn
            ? firstArea.displayNameEn
            : firstArea.displayNameTr;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.1 : 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isEn
                        ? '$streak days focused on $areaName'
                        : '$streak gündür $areaName odağında',
                    style: AppTypography.elegantAccent(
                      fontSize: 12,
                      color: color,
                    ),
                  ),
                ),
                if (streak >= 3)
                  GestureDetector(
                    onTap: () {
                      final text = isEn
                          ? '$emoji $streak-day $areaName focus streak in InnerCycles!\n\n${AppConstants.appStoreUrl}'
                          : '$emoji InnerCycles\'da $streak günlük $areaName odak serisi!\n\n${AppConstants.appStoreUrl}';
                      SharePlus.instance.share(ShareParams(text: text));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.share_rounded,
                        size: 14,
                        color: color.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        );
      },
    );
  }
}
