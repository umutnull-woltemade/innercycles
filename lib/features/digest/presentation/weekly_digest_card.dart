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

        return GestureDetector(
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
                  ],
                ),

                const SizedBox(height: 10),

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
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06, duration: 400.ms);
      },
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
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
    );
  }
}
