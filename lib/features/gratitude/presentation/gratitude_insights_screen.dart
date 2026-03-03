// ════════════════════════════════════════════════════════════════════════════
// GRATITUDE INSIGHTS SCREEN - Theme analytics & mood correlation
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/gratitude_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class GratitudeInsightsScreen extends ConsumerWidget {
  const GratitudeInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(gratitudeServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final entries = service.getAllEntries();
              if (entries.isEmpty) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              final summary = service.getWeeklySummary();
              final allTimeThemes = service.getAllTimeThemes();
              final entryCount = service.entryCount;

              // Build 30-day streak grid
              final now = DateTime.now();
              final streakDays = <DateTime, bool>{};
              for (int i = 0; i < 30; i++) {
                final day = now.subtract(Duration(days: 29 - i));
                final dayKey = DateTime(day.year, day.month, day.day);
                streakDays[dayKey] = service.getEntry(day) != null;
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Gratitude Insights'
                        : 'Şükran Analizleri',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'What you appreciate shapes who you become'
                                : 'Takdir ettiğin şeyler kim olduğunu şekillendirir',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Summary hero
                          _SummaryHero(
                            summary: summary,
                            totalEntries: entryCount,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // 30-day streak
                          GradientText(
                            isEn
                                ? '30-Day Gratitude Streak'
                                : '30 Günlük Şükran Serisi',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _StreakGrid(
                            days: streakDays,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 24),

                          // Top themes
                          if (allTimeThemes.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Your Gratitude Pillars'
                                  : 'Şükran Sütunların',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _ThemeCloud(
                              themes: allTimeThemes,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Weekly themes
                          if (summary.topThemes.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'This Week\'s Themes'
                                  : 'Bu Haftanın Temaları',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: summary.topThemes.entries
                                  .map((e) => _ThemeChip(
                                        theme: e.key,
                                        count: e.value,
                                        isDark: isDark,
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Caption
                          Center(
                            child: Text(
                              isEn
                                  ? 'Based on $entryCount gratitude entries'
                                  : '$entryCount şükran girdisine dayalı',
                              style: AppTypography.subtitle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryHero extends StatelessWidget {
  final GratitudeSummary summary;
  final int totalEntries;
  final bool isEn;
  final bool isDark;

  const _SummaryHero({
    required this.summary,
    required this.totalEntries,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.gold,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              isEn ? 'Weekly Summary' : 'Haftalık Özet',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HeroStat(
                  value: '${summary.daysWithGratitude}',
                  label: isEn ? 'Days' : 'Gün',
                  color: AppColors.success,
                  isDark: isDark,
                ),
                _HeroStat(
                  value: '${summary.totalItems}',
                  label: isEn ? 'Items' : 'Öğe',
                  color: AppColors.starGold,
                  isDark: isDark,
                ),
                _HeroStat(
                  value: '$totalEntries',
                  label: isEn ? 'All time' : 'Toplam',
                  color: AppColors.amethyst,
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _HeroStat({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.modernAccent(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 10,
            color:
                isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _StreakGrid extends StatelessWidget {
  final Map<DateTime, bool> days;
  final bool isDark;

  const _StreakGrid({required this.days, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final sorted = days.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: sorted.map((entry) {
          final hasEntry = entry.value;
          return Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: hasEntry
                  ? AppColors.starGold.withValues(alpha: 0.5)
                  : (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.04),
            ),
            child: Center(
              child: Text(
                '${entry.key.day}',
                style: AppTypography.elegantAccent(
                  fontSize: 9,
                  color: hasEntry
                      ? AppColors.starGold
                      : (isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ThemeCloud extends StatelessWidget {
  final Map<String, int> themes;
  final bool isDark;

  const _ThemeCloud({required this.themes, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final maxCount =
        themes.values.fold<int>(0, (max, v) => v > max ? v : max);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: themes.entries.take(15).map((e) {
        final relative = maxCount > 0 ? e.value / maxCount : 0.5;
        final fontSize = 11.0 + relative * 8.0;
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.amethyst
                .withValues(alpha: 0.08 + relative * 0.15),
          ),
          child: Text(
            '${e.key} (${e.value})',
            style: AppTypography.modernAccent(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.amethyst,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String theme;
  final int count;
  final bool isDark;

  const _ThemeChip({
    required this.theme,
    required this.count,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.starGold.withValues(alpha: 0.1),
      ),
      child: Text(
        '$theme \u{00D7}$count',
        style: AppTypography.elegantAccent(
          fontSize: 12,
          color: AppColors.starGold,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Gratitude Insights' : 'Şükran Analizleri',
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F331}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Start logging gratitude to discover your appreciation patterns'
                            : 'Takdir kalıplarını keşfetmek için şükran kaydetmeye başla',
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
