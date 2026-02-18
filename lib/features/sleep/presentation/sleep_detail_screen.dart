// ════════════════════════════════════════════════════════════════════════════
// SLEEP DETAIL SCREEN - Weekly Sleep Quality View
// ════════════════════════════════════════════════════════════════════════════
// Bar chart of last 7 days, trend indicator, tips, and sleep-to-mood
// correlation (premium).
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/sleep_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Sleep Quality' : 'Uyku Kalitesi',
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
                        child: Text(
                          CommonStrings.somethingWentWrong(language),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
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
                        child: _EmptyState(isDark: isDark, isEn: isEn),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        // Summary stats
                        _SummaryCard(
                          summary: summary,
                          isDark: isDark,
                          isEn: isEn,
                        ),
                        const SizedBox(height: 20),

                        // Weekly chart
                        _WeeklyChart(days: last7, isDark: isDark, isEn: isEn),
                        const SizedBox(height: 24),

                        // Trend card
                        if (summary.trendDirection != null)
                          _TrendCard(
                            trend: summary.trendDirection!,
                            isDark: isDark,
                            isEn: isEn,
                          ),
                        if (summary.trendDirection != null)
                          const SizedBox(height: 24),

                        // Tips
                        _SleepTips(isDark: isDark, isEn: isEn),
                        const SizedBox(height: 24),

                        // Recent entries
                        if (entries.isNotEmpty) ...[
                          Text(
                            isEn ? 'Recent Nights' : 'Son Geceler',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...entries
                              .take(14)
                              .map(
                                (entry) => _NightCard(
                                  entry: entry,
                                  isDark: isDark,
                                  isEn: isEn,
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
  final bool isEn;

  const _SummaryCard({
    required this.summary,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: summary.averageQuality > 0
                ? summary.averageQuality.toStringAsFixed(1)
                : '-',
            label: isEn ? 'Average' : 'Ortalama',
            color: _qualityColor(summary.averageQuality),
            isDark: isDark,
          ),
          _StatItem(
            value: '${summary.nightsLogged}',
            label: isEn ? 'Nights' : 'Gece',
            color: AppColors.auroraStart,
            isDark: isDark,
          ),
          _StatItem(
            value: '${summary.bestNightQuality}/5',
            label: isEn ? 'Best' : 'En İyi',
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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<_DayData> days;
  final bool isDark;
  final bool isEn;

  const _WeeklyChart({
    required this.days,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final dayLabels = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Last 7 Days' : 'Son 7 Gün',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
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
                          style: TextStyle(
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
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
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
  final bool isEn;

  const _TrendCard({
    required this.trend,
    required this.isDark,
    required this.isEn,
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
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
  final bool isEn;

  const _SleepTips({required this.isDark, required this.isEn});

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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
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
              Text(
                isEn ? 'Sleep Tips' : 'Uyku İpuçları',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
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
                    style: TextStyle(
                      color: AppColors.auroraStart,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        height: 1.4,
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
  final bool isEn;

  const _NightCard({
    required this.entry,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = ['', '😴', '😐', '🙂', '😊', '🌟'][entry.quality];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.dateKey,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  if (entry.note != null && entry.note!.isNotEmpty)
                    Text(
                      entry.note!,
                      style: TextStyle(
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
                style: TextStyle(
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
  final bool isEn;

  const _EmptyState({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bedtime_outlined,
            size: 64,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.5)
                : AppColors.lightTextMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isEn ? 'No sleep data yet' : 'Henüz uyku verisi yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Log your sleep quality in your daily journal'
                : 'Günlük kayıtınızda uyku kalitenizi kaydedin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
