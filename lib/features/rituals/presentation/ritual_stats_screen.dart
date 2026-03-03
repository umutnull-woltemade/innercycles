// ════════════════════════════════════════════════════════════════════════════
// RITUAL STATS SCREEN - Completion analytics & consistency insights
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/ritual_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class RitualStatsScreen extends ConsumerWidget {
  const RitualStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(ritualServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final stacks = service.getStacks();
              if (stacks.isEmpty) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              final now = DateTime.now();
              final thirtyDaysAgo =
                  now.subtract(const Duration(days: 30));
              final sevenDaysAgo =
                  now.subtract(const Duration(days: 7));

              final rate30 = service.getCompletionRateForRange(
                  thirtyDaysAgo, now);
              final rate7 = service.getCompletionRateForRange(
                  sevenDaysAgo, now);
              final todaySummary = service.getTodaySummary();

              // Build 30-day completion grid
              final dayData = <DateTime, double>{};
              for (int i = 0; i < 30; i++) {
                final day = now.subtract(Duration(days: 29 - i));
                final dayStart = DateTime(day.year, day.month, day.day);
                final dayEnd = dayStart.add(const Duration(days: 1));
                dayData[dayStart] =
                    service.getCompletionRateForRange(dayStart, dayEnd);
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Ritual Analytics'
                        : 'Ritüel Analizi',
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
                                ? 'Your consistency patterns'
                                : 'Tutarlılık kalıpların',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview hero
                          _OverviewHero(
                            rate30: rate30,
                            rate7: rate7,
                            todaySummary: todaySummary,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // 30-day grid
                          GradientText(
                            isEn
                                ? '30-Day Consistency'
                                : '30 Günlük Tutarlılık',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _CompletionGrid(
                            dayData: dayData,
                            isDark: isDark,
                            isEn: isEn,
                          ),

                          const SizedBox(height: 24),

                          // Time-of-day breakdown
                          GradientText(
                            isEn
                                ? 'By Time of Day'
                                : 'Günün Zamanına Göre',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _TimeBreakdown(
                            summary: todaySummary,
                            isEn: isEn,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 24),

                          // Per-stack stats
                          GradientText(
                            isEn
                                ? 'Stacks (${stacks.length})'
                                : 'Yığınlar (${stacks.length})',
                            variant: GradientTextVariant.amethyst,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...stacks.map((stack) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10),
                                child: _StackTile(
                                  stack: stack,
                                  service: service,
                                  isEn: isEn,
                                  isDark: isDark,
                                ),
                              )),

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

class _OverviewHero extends StatelessWidget {
  final double rate30;
  final double rate7;
  final DailyRitualSummary todaySummary;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.rate30,
    required this.rate7,
    required this.todaySummary,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              isEn ? 'Overall Consistency' : 'Genel Tutarlılık',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(rate30 * 100).round()}%',
              style: AppTypography.displayFont.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w300,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isEn ? '30-day average' : '30 günlük ortalama',
              style: AppTypography.elegantAccent(
                fontSize: 11,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniStat(
                  label: isEn ? '7-day' : '7 gün',
                  value: '${(rate7 * 100).round()}%',
                  isDark: isDark,
                ),
                _MiniStat(
                  label: isEn ? 'Today' : 'Bugün',
                  value:
                      '${todaySummary.completedItems}/${todaySummary.totalItems}',
                  isDark: isDark,
                ),
                _MiniStat(
                  label: isEn ? 'Rate' : 'Oran',
                  value:
                      '${(todaySummary.overallCompletion * 100).round()}%',
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
      children: [
        Text(
          value,
          style: AppTypography.modernAccent(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.auroraStart,
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

class _CompletionGrid extends StatelessWidget {
  final Map<DateTime, double> dayData;
  final bool isDark;
  final bool isEn;

  const _CompletionGrid({
    required this.dayData,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = dayData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: sorted.map((entry) {
              final intensity =
                  entry.value.clamp(0.0, 1.0);
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: intensity > 0
                      ? AppColors.success.withValues(
                          alpha: 0.15 + intensity * 0.55)
                      : (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.04),
                ),
                child: Center(
                  child: Text(
                    '${entry.key.day}',
                    style: AppTypography.elegantAccent(
                      fontSize: 9,
                      color: intensity > 0.5
                          ? AppColors.success
                          : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEn ? 'Less' : 'Az',
                style: AppTypography.elegantAccent(
                  fontSize: 9,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 6),
              ...List.generate(4, (i) {
                final alpha = 0.15 + (i / 3) * 0.55;
                return Container(
                  width: 12,
                  height: 8,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppColors.success
                        .withValues(alpha: alpha),
                  ),
                );
              }),
              const SizedBox(width: 6),
              Text(
                isEn ? 'More' : 'Çok',
                style: AppTypography.elegantAccent(
                  fontSize: 9,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeBreakdown extends StatelessWidget {
  final DailyRitualSummary summary;
  final bool isEn;
  final bool isDark;

  const _TimeBreakdown({
    required this.summary,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: RitualTime.values.map((time) {
        final rate = summary.completionByTime[time] ?? 0.0;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
                right: time != RitualTime.evening ? 8 : 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  time.icon,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(rate * 100).round()}%',
                  style: AppTypography.modernAccent(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time.localizedName(
                      isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StackTile extends StatelessWidget {
  final RitualStack stack;
  final RitualService service;
  final bool isEn;
  final bool isDark;

  const _StackTile({
    required this.stack,
    required this.service,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final completion = service.getCompletion(stack.id);
    final completedCount = completion?.completedItemIds.length ?? 0;
    final totalCount = stack.items.length;
    final rate = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                stack.time.icon,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stack.name,
                  style: AppTypography.modernAccent(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Text(
                '$completedCount/$totalCount',
                style: AppTypography.elegantAccent(
                  fontSize: 12,
                  color: AppColors.auroraStart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: rate,
              backgroundColor: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation(AppColors.success),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${stack.items.length} ${isEn ? 'items' : 'öğe'}',
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
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
          title: isEn ? 'Ritual Analytics' : 'Ritüel Analizi',
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
                      const Text('\u{2728}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Create your first ritual stack to start tracking consistency'
                            : 'Tutarlılığı takip etmeye başlamak için ilk ritüel yığınını oluştur',
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
