// ════════════════════════════════════════════════════════════════════════════
// WEEKLY DIGEST CARD - Compact Weekly Summary Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';

class WeeklyDigestCard extends ConsumerWidget {
  const WeeklyDigestCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(weeklyDigestServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        // Try to generate from journal entries
        final entries = journalAsync.valueOrNull?.getAllEntries() ?? [];
        if (entries.isEmpty) return const SizedBox.shrink();

        final digest = service.generateDigest(entries);
        if (digest.entryCount == 0) return const SizedBox.shrink();

        return Semantics(
              button: true,
              label: isEn ? 'Weekly Digest' : 'Haftalık Özet',
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(Routes.weeklyDigest);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.starGold.withValues(alpha: 0.1),
                              AppColors.surfaceDark.withValues(alpha: 0.9),
                            ]
                          : [
                              AppColors.starGold.withValues(alpha: 0.05),
                              AppColors.lightCard,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.starGold.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.starGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.summarize_rounded,
                              color: AppColors.starGold,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isEn ? 'Your Week' : 'Haftanız',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Stats row
                      Row(
                        children: [
                          _MiniStat(
                            label: isEn ? 'Entries' : 'Kayıt',
                            value: '${digest.entryCount}',
                            isDark: isDark,
                          ),
                          const SizedBox(width: 16),
                          _MiniStat(
                            label: isEn ? 'Avg Mood' : 'Ort. Mod',
                            value: digest.avgMood.toStringAsFixed(1),
                            isDark: isDark,
                          ),
                          if (digest.streakDays > 0) ...[
                            const SizedBox(width: 16),
                            _MiniStat(
                              label: isEn ? 'Streak' : 'Seri',
                              value: '${digest.streakDays}d',
                              isDark: isDark,
                            ),
                          ],
                          const SizedBox(width: 16),
                          _MiniStat(
                            label: isEn ? 'Focus' : 'Odak',
                            value: isEn
                                ? digest.topFocusAreaEn
                                : digest.topFocusAreaTr,
                            isDark: isDark,
                            isText: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Mood trend pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _moodTrendColor(
                            digest.moodTrendEn,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _moodTrendIcon(digest.moodTrendEn),
                              size: 12,
                              color: _moodTrendColor(digest.moodTrendEn),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                isEn ? digest.moodTrendEn : digest.moodTrendTr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: _moodTrendColor(digest.moodTrendEn),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Highlight text
                      Text(
                        isEn ? digest.highlightEn : digest.highlightTr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Growth nudge
                      Text(
                        isEn ? digest.growthNudgeEn : digest.growthNudgeTr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: AppColors.starGold.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.06, duration: 400.ms);
      },
    );
  }

  Color _moodTrendColor(String trendEn) {
    if (trendEn.contains('rising')) return AppColors.success;
    if (trendEn.contains('dipped')) return AppColors.softCoral;
    return AppColors.auroraEnd;
  }

  IconData _moodTrendIcon(String trendEn) {
    if (trendEn.contains('rising')) return Icons.trending_up_rounded;
    if (trendEn.contains('dipped')) return Icons.trending_down_rounded;
    return Icons.trending_flat_rounded;
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isText;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.isDark,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isText ? 13 : 18,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
