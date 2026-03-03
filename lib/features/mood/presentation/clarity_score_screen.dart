// ════════════════════════════════════════════════════════════════════════════
// CLARITY SCORE SCREEN - Weekly wellbeing breakdown with pillar analysis
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/clarity_score_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/sparkline_chart.dart';

class ClarityScoreScreen extends ConsumerWidget {
  const ClarityScoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final clarityAsync = ref.watch(clarityScoreServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: clarityAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final current = service.getCurrentWeekCached();
              if (current == null) {
                service.computeCurrentWeek().then((_) {
                  if (context.mounted) {
                    ref.invalidate(clarityScoreServiceProvider);
                  }
                });
                return const Center(child: CircularProgressIndicator());
              }

              final previous = service.getPreviousWeek();
              final delta =
                  previous != null ? current.score - previous.score : 0;
              final recentWeeks = service.getRecentWeeks(count: 8);
              final sparkData = recentWeeks.reversed
                  .map((w) => w.score.toDouble())
                  .toList();

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Clarity Score' : 'Berraklık Skoru',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Your weekly composite wellbeing score'
                                : 'Haftalık bileşik iyi oluş puanın',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Score hero
                          _ScoreHero(
                            score: current.score,
                            delta: delta,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Trend chart
                          if (sparkData.length >= 2) ...[
                            GradientText(
                              isEn ? 'Weekly Trend' : 'Haftalık Trend',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 120,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.04)
                                    : Colors.black.withValues(alpha: 0.03),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: SparklineChart(
                                data: sparkData,
                                lineColor: AppColors.auroraStart,
                                fillColor: AppColors.auroraStart
                                    .withValues(alpha: 0.15),
                                minValue: 0,
                                maxValue: 100,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Pillar breakdown
                          GradientText(
                            isEn ? 'Score Breakdown' : 'Puan Detayı',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _PillarBreakdown(
                            current: current,
                            previous: previous,
                            isEn: isEn,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 24),

                          // History
                          if (recentWeeks.length > 1) ...[
                            GradientText(
                              isEn
                                  ? 'History (${recentWeeks.length} weeks)'
                                  : 'Geçmiş (${recentWeeks.length} hafta)',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...recentWeeks.map((week) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _WeekHistoryTile(
                                    week: week,
                                    isEn: isEn,
                                    isDark: isDark,
                                  ),
                                )),
                          ],

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

class _ScoreHero extends StatelessWidget {
  final int score;
  final int delta;
  final bool isEn;
  final bool isDark;

  const _ScoreHero({
    required this.score,
    required this.delta,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    Color scoreColor;
    String label;
    if (score >= 75) {
      scoreColor = AppColors.success;
      label = isEn ? 'Thriving' : 'Gelişiyor';
    } else if (score >= 50) {
      scoreColor = AppColors.auroraStart;
      label = isEn ? 'Growing' : 'Büyüyor';
    } else if (score >= 25) {
      scoreColor = AppColors.warning;
      label = isEn ? 'Building' : 'İnşa Ediyor';
    } else {
      scoreColor = AppColors.amethyst;
      label = isEn ? 'Starting' : 'Başlıyor';
    }

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '$score',
              style: AppTypography.displayFont.copyWith(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                color: scoreColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTypography.modernAccent(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: scoreColor,
                  ),
                ),
                if (delta != 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: (delta > 0 ? AppColors.success : AppColors.error)
                          .withValues(alpha: 0.15),
                    ),
                    child: Text(
                      '${delta > 0 ? '+' : ''}$delta',
                      style: AppTypography.subtitle(
                        fontSize: 13,
                        color:
                            delta > 0 ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              isEn ? 'out of 100' : '100 üzerinden',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillarBreakdown extends StatelessWidget {
  final WeeklyClarity current;
  final WeeklyClarity? previous;
  final bool isEn;
  final bool isDark;

  const _PillarBreakdown({
    required this.current,
    required this.previous,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final pillars = [
      _Pillar(
        icon: Icons.edit_note_rounded,
        label: isEn ? 'Journal' : 'Günlük',
        value: '${current.journalDays}/7 ${isEn ? 'days' : 'gün'}',
        score: (current.journalDays / 7.0 * 25).round(),
        maxScore: 25,
        color: AppColors.starGold,
      ),
      _Pillar(
        icon: Icons.mood_rounded,
        label: isEn ? 'Mood' : 'Ruh Hali',
        value: current.avgMood.toStringAsFixed(1),
        score: ((current.avgMood - 1) / 4.0 * 20).round(),
        maxScore: 20,
        color: AppColors.celestialGold,
      ),
      _Pillar(
        icon: Icons.check_circle_outline_rounded,
        label: isEn ? 'Rituals' : 'Ritüeller',
        value: '${(current.ritualRate * 100).round()}%',
        score: (current.ritualRate * 20).round(),
        maxScore: 20,
        color: AppColors.amethyst,
      ),
      _Pillar(
        icon: Icons.bedtime_rounded,
        label: isEn ? 'Sleep' : 'Uyku',
        value: current.sleepAvg > 0
            ? current.sleepAvg.toStringAsFixed(1)
            : '—',
        score: (current.sleepAvg / 5.0 * 15).round(),
        maxScore: 15,
        color: AppColors.auroraStart,
      ),
      _Pillar(
        icon: Icons.favorite_rounded,
        label: isEn ? 'Gratitude' : 'Şükür',
        value: '${current.gratitudeDays}/7',
        score: (current.gratitudeDays / 7.0 * 10).round(),
        maxScore: 10,
        color: AppColors.success,
      ),
      _Pillar(
        icon: Icons.local_fire_department_rounded,
        label: isEn ? 'Streak' : 'Seri',
        value: '${current.streak}',
        score: (current.streak / 14.0 * 10).clamp(0, 10).round(),
        maxScore: 10,
        color: AppColors.warning,
      ),
    ];

    return Column(
      children: pillars
          .map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PillarRow(pillar: p, isDark: isDark),
              ))
          .toList(),
    );
  }
}

class _Pillar {
  final IconData icon;
  final String label;
  final String value;
  final int score;
  final int maxScore;
  final Color color;

  const _Pillar({
    required this.icon,
    required this.label,
    required this.value,
    required this.score,
    required this.maxScore,
    required this.color,
  });
}

class _PillarRow extends StatelessWidget {
  final _Pillar pillar;
  final bool isDark;

  const _PillarRow({required this.pillar, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final progress = pillar.maxScore > 0
        ? (pillar.score / pillar.maxScore).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(pillar.icon, size: 18, color: pillar.color),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(
              pillar.label,
              style: AppTypography.modernAccent(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor:
                    (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                valueColor: AlwaysStoppedAnimation(pillar.color),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 40,
            child: Text(
              '${pillar.score}/${pillar.maxScore}',
              textAlign: TextAlign.end,
              style: AppTypography.elegantAccent(
                fontSize: 11,
                color: pillar.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekHistoryTile extends StatelessWidget {
  final WeeklyClarity week;
  final bool isEn;
  final bool isDark;

  const _WeekHistoryTile({
    required this.week,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              week.weekKey,
              style: AppTypography.modernAccent(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: week.score / 100.0,
                backgroundColor:
                    (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                valueColor: AlwaysStoppedAnimation(
                  week.score >= 75
                      ? AppColors.success
                      : week.score >= 50
                          ? AppColors.auroraStart
                          : AppColors.warning,
                ),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${week.score}',
            style: AppTypography.modernAccent(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
