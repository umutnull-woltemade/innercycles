import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/sleep_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class SleepTrendsScreen extends ConsumerWidget {
  const SleepTrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(sleepServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                CommonStrings.somethingWentWrong(language),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),
          data: (service) => _buildContent(context, service, isDark, isEn),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SleepService service,
    bool isDark,
    bool isEn,
  ) {
    final allEntries = service.getAllEntries();
    final summary = service.getWeeklySummary();

    if (allEntries.isEmpty) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(title: isEn ? 'Sleep Trends' : 'Uyku Trendleri'),
          SliverFillRemaining(
            child: Center(
              child: Text(
                isEn
                    ? 'No sleep data yet.\nLog your first night\'s sleep!'
                    : 'Henüz uyku verisi yok.\nİlk uyku kaydını oluştur!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Last 14 days data for bar chart
    final now = DateTime.now();
    final last14 = <_DayQuality>[];
    for (int i = 13; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final entry = service.getEntry(day);
      last14.add(_DayQuality(day: day, quality: entry?.quality));
    }

    // Quality distribution
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final entry in allEntries) {
      distribution[entry.quality] = (distribution[entry.quality] ?? 0) + 1;
    }

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(title: isEn ? 'Sleep Trends' : 'Uyku Trendleri'),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                _buildStatsRow(
                  context,
                  isDark,
                  isEn,
                  summary,
                  allEntries.length,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Trend indicator
                if (summary.trendDirection != null)
                  _buildTrendCard(
                    context,
                    isDark,
                    isEn,
                    summary.trendDirection!,
                  ),
                if (summary.trendDirection != null)
                  const SizedBox(height: AppConstants.spacingLg),

                // 14-day bar chart
                _buildBarChart(context, isDark, isEn, last14),
                const SizedBox(height: AppConstants.spacingLg),

                // Quality distribution
                _buildDistributionCard(context, isDark, isEn, distribution),
                const SizedBox(height: AppConstants.spacingLg),

                // Recent entries with notes
                _buildRecentCard(
                  context,
                  isDark,
                  isEn,
                  allEntries
                      .where((e) => e.note != null && e.note!.isNotEmpty)
                      .take(10)
                      .toList(),
                ),
                ContentDisclaimer(
                  language: isEn ? AppLanguage.en : AppLanguage.tr,
                ),
                const SizedBox(height: 16),
                ToolEcosystemFooter(
                  currentToolId: 'sleepTrends',
                  isEn: isEn,
                  isDark: isDark,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  Widget _buildStatsRow(
    BuildContext context,
    bool isDark,
    bool isEn,
    SleepSummary summary,
    int total,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: isEn ? 'Week Avg' : 'Hafta Ort.',
            value: summary.averageQuality > 0
                ? summary.averageQuality.toStringAsFixed(1)
                : '-',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: isEn ? 'Best' : 'En İyi',
            value: summary.bestNightQuality > 0
                ? '${summary.bestNightQuality}/5'
                : '-',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: isEn ? 'Nights' : 'Gece',
            value: '$total',
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    String trend,
  ) {
    final IconData icon;
    final Color color;
    final String text;

    switch (trend) {
      case 'improving':
        icon = Icons.trending_up;
        color = AppColors.auroraStart;
        text = isEn
            ? 'Your sleep quality is improving'
            : 'Uyku kaliten iyileşiyor';
      case 'declining':
        icon = Icons.trending_down;
        color = AppColors.chartOrange;
        text = isEn
            ? 'Your sleep quality has dipped recently'
            : 'Uyku kaliten son zamanlarda düştü';
      default:
        icon = Icons.trending_flat;
        color = AppColors.starGold;
        text = isEn ? 'Your sleep quality is stable' : 'Uyku kaliten sabit';
    }

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
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
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    bool isDark,
    bool isEn,
    List<_DayQuality> days,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Last 14 Nights' : 'Son 14 Gece',
            variant: GradientTextVariant.aurora,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.map((d) {
                final barHeight = d.quality != null
                    ? (d.quality! / 5.0) * 90
                    : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (d.quality != null)
                          Container(
                            height: barHeight,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                              color: _qualityColor(d.quality!),
                            ),
                          )
                        else
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: isDark
                                  ? AppColors.surfaceLight.withValues(
                                      alpha: 0.2,
                                    )
                                  : AppColors.lightSurfaceVariant,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '${d.day.day}',
                          style: TextStyle(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    Map<int, int> distribution,
  ) {
    final labels = [
      (1, isEn ? 'Poor' : 'Kötü'),
      (2, isEn ? 'Fair' : 'Vasat'),
      (3, isEn ? 'Okay' : 'İdare'),
      (4, isEn ? 'Good' : 'İyi'),
      (5, isEn ? 'Great' : 'Harika'),
    ];
    final total = distribution.values.fold(0, (a, b) => a + b);

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Quality Distribution' : 'Kalite Dağılımı',
            variant: GradientTextVariant.aurora,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...labels.map((item) {
            final count = distribution[item.$1] ?? 0;
            final fraction = total > 0 ? count / total : 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    child: Text(
                      '${item.$1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _qualityColor(item.$1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 48,
                    child: Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: fraction,
                        backgroundColor: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.15)
                            : AppColors.lightSurfaceVariant,
                        valueColor: AlwaysStoppedAnimation(
                          _qualityColor(item.$1),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 24,
                    child: Text(
                      '$count',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    List<SleepEntry> entries,
  ) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Notes' : 'Notlar',
            variant: GradientTextVariant.aurora,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...entries.map((entry) {
            final parts = entry.dateKey.split('-');
            final dateStr = parts.length >= 3
                ? '${parts[2]}.${parts[1]}.${parts[0]}'
                : entry.dateKey;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _qualityColor(
                        entry.quality,
                      ).withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.quality}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _qualityColor(entry.quality),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.note!,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _qualityColor(int quality) {
    switch (quality) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.chartOrange;
      case 3:
        return AppColors.starGold;
      case 4:
        return Colors.lightGreen;
      case 5:
        return AppColors.auroraStart;
      default:
        return AppColors.starGold;
    }
  }
}

class _DayQuality {
  final DateTime day;
  final int? quality;
  const _DayQuality({required this.day, this.quality});
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatTile({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      elevation: GlassElevation.g1,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingLg,
      ),
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.starGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
