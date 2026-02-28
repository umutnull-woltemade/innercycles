// ════════════════════════════════════════════════════════════════════════════
// SLEEP DETAIL SCREEN - Weekly Sleep Quality View
// ════════════════════════════════════════════════════════════════════════════
// Bar chart of last 7 days, trend indicator, tips, and sleep-to-mood
// correlation (premium).
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/sleep_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../../data/services/l10n_service.dart';

class SleepDetailScreen extends ConsumerWidget {
  const SleepDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final sleepAsync = ref.watch(sleepServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: L10nService.get('sleep.sleep_detail.sleep_quality', language),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: sleepAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CosmicLoadingIndicator()),
                    ),
                    error: (_, _) => SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CommonStrings.somethingWentWrong(language),
                                textAlign: TextAlign.center,
                                style: AppTypography.decorativeScript(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () =>
                                    ref.invalidate(sleepServiceProvider),
                                icon: Icon(Icons.refresh_rounded,
                                    size: 16, color: AppColors.starGold),
                                label: Text(
                                  L10nService.get('sleep.sleep_detail.retry', language),
                                  style: AppTypography.elegantAccent(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.starGold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    data: (service) {
                      final summary = service.getWeeklySummary();
                      final entries = service.getAllEntries();
                      final last7 = _getLast7Days(service);

                      if (summary.nightsLogged == 0) {
                        return SliverToBoxAdapter(
                          child: _EmptyState(isDark: isDark, language: language),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Summary stats
                          _SummaryCard(
                            summary: summary,
                            isDark: isDark,
                            language: language,
                          ),
                          const SizedBox(height: 20),

                          // Weekly chart
                          _WeeklyChart(days: last7, isDark: isDark, language: language),
                          const SizedBox(height: 24),

                          // Trend card
                          if (summary.trendDirection != null)
                            _TrendCard(
                              trend: summary.trendDirection!,
                              isDark: isDark,
                              language: language,
                            ),
                          if (summary.trendDirection != null)
                            const SizedBox(height: 24),

                          // Tips
                          _SleepTips(isDark: isDark, language: language),
                          const SizedBox(height: 24),

                          // Recent entries
                          if (entries.isNotEmpty) ...[
                            GradientText(
                              L10nService.get('sleep.sleep_detail.recent_nights', language),
                              variant: GradientTextVariant.gold,
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...entries
                                .take(14)
                                .map(
                                  (entry) => _NightCard(
                                    entry: entry,
                                    isDark: isDark,
                                    language: language,
                                  ),
                                ),
                          ],

                          const SizedBox(height: 40),
                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_DayData> _getLast7Days(SleepService service) {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      final entry = service.getEntry(date);
      return _DayData(date: date, quality: entry?.quality);
    });
  }
}

class _DayData {
  final DateTime date;
  final int? quality;

  const _DayData({required this.date, this.quality});
}

class _SummaryCard extends StatelessWidget {
  final SleepSummary summary;
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _SummaryCard({
    required this.summary,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 14,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: summary.averageQuality > 0
                ? summary.averageQuality.toStringAsFixed(1)
                : '-',
            label: L10nService.get('sleep.sleep_detail.average', language),
            color: _qualityColor(summary.averageQuality),
            isDark: isDark,
          ),
          _StatItem(
            value: '${summary.nightsLogged}',
            label: L10nService.get('sleep.sleep_detail.nights', language),
            color: AppColors.auroraStart,
            isDark: isDark,
          ),
          _StatItem(
            value: '${summary.bestNightQuality}/5',
            label: L10nService.get('sleep.sleep_detail.best', language),
            color: AppColors.success,
            isDark: isDark,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Color _qualityColor(double avg) {
    if (avg >= 4) return AppColors.success;
    if (avg >= 3) return AppColors.auroraStart;
    if (avg >= 2) return AppColors.warning;
    return AppColors.error;
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatItem({
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
          style: AppTypography.displayFont.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<_DayData> days;
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _WeeklyChart({
    required this.days,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final dayLabels = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 14,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('sleep.sleep_detail.last_7_days', language),
            variant: GradientTextVariant.aurora,
            style: AppTypography.displayFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.map((d) {
                final q = d.quality ?? 0;
                final barHeight = q > 0 ? (q / 5.0) * 90 + 8 : 4.0;
                final label = dayLabels[d.date.weekday - 1];
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (q > 0)
                        Text(
                          '$q',
                          style: AppTypography.modernAccent(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _barColor(q),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Container(
                        height: barHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: q > 0
                              ? _barColor(q)
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.black.withValues(alpha: 0.04)),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: AppTypography.elegantAccent(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Color _barColor(int quality) {
    if (quality >= 4) return AppColors.success;
    if (quality >= 3) return AppColors.auroraStart;
    if (quality >= 2) return AppColors.warning;
    return AppColors.error;
  }
}

class _TrendCard extends StatelessWidget {
  final String trend;
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _TrendCard({
    required this.trend,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final icon = trend == 'improving'
        ? Icons.trending_up
        : trend == 'declining'
        ? Icons.trending_down
        : Icons.trending_flat;
    final color = trend == 'improving'
        ? AppColors.success
        : trend == 'declining'
        ? AppColors.warning
        : AppColors.auroraStart;
    final label = isEn
        ? (trend == 'improving'
              ? 'Your sleep quality is improving'
              : trend == 'declining'
              ? 'Your sleep quality may be declining'
              : 'Your sleep quality is stable')
        : (trend == 'improving'
              ? 'Uyku kaliteniz iyileşiyor'
              : trend == 'declining'
              ? 'Uyku kaliteniz düşüyor olabilir'
              : 'Uyku kaliteniz stabil');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}

class _SleepTips extends StatelessWidget {
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _SleepTips({required this.isDark, required this.language});

  @override
  Widget build(BuildContext context) {
    final tips = isEn
        ? [
            'Maintain a consistent sleep schedule',
            'Limit screen time 1 hour before bed',
            'Keep your bedroom cool and dark',
            'Try the breathing exercises before sleep',
          ]
        : [
            'Tutarlı bir uyku programı sürdürün',
            'Yatmadan 1 saat önce ekran süresini sınırlayın',
            'Yatak odanızı serin ve karanlık tutun',
            'Uyumadan önce nefes egzersizlerini deneyin',
          ];

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 14,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: AppColors.starGold,
              ),
              const SizedBox(width: 8),
              GradientText(
                L10nService.get('sleep.sleep_detail.sleep_tips', language),
                variant: GradientTextVariant.gold,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  •  ',
                    style: AppTypography.modernAccent(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.auroraStart,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTypography.decorativeScript(
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
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 300.ms);
  }
}

class _NightCard extends StatelessWidget {
  final SleepEntry entry;
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _NightCard({
    required this.entry,
    required this.isDark,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = ['', '😴', '😐', '🙂', '😊', '🌟'][entry.quality];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        borderRadius: 12,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            AppSymbol.card(emoji),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.dateKey,
                    style: AppTypography.elegantAccent(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (entry.note != null && entry.note!.isNotEmpty)
                    Text(
                      entry.note!,
                      style: AppTypography.decorativeScript(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _qualityColor(entry.quality).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${entry.quality}/5',
                style: AppTypography.modernAccent(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _qualityColor(entry.quality),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _qualityColor(int quality) {
    if (quality >= 4) return AppColors.success;
    if (quality >= 3) return AppColors.auroraStart;
    if (quality >= 2) return AppColors.warning;
    return AppColors.error;
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final AppLanguage language;
  bool get isEn => language.isEn;

  const _EmptyState({required this.isDark, required this.language});

  @override
  Widget build(BuildContext context) {
    return PremiumEmptyState(
      icon: Icons.bedtime_outlined,
      title: L10nService.get('sleep.sleep_detail.your_sleep_story_is_waiting_to_begin', language),
      description: L10nService.get('sleep.sleep_detail.log_your_sleep_quality_in_your_daily_jou', language),
      gradientVariant: GradientTextVariant.amethyst,
      ctaLabel: L10nService.get('sleep.sleep_detail.write_journal_entry', language),
      onCtaPressed: () => context.go(Routes.journal),
    );
  }
}
