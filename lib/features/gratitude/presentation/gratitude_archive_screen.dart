import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/gratitude_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class GratitudeArchiveScreen extends ConsumerWidget {
  const GratitudeArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(gratitudeServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                isEn ? 'Something went wrong' : 'Bir şeyler yanlış gitti',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
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
    GratitudeService service,
    bool isDark,
    bool isEn,
  ) {
    final allEntries = service.getAllEntries();
    final themes = service.getAllTimeThemes();
    final summary = service.getWeeklySummary();

    if (allEntries.isEmpty) {
      return CustomScrollView(
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Gratitude Archive' : 'Şükran Arşivi',
          ),
          SliverFillRemaining(
            child: Center(
              child: Text(
                isEn
                    ? 'No gratitude entries yet.\nStart your gratitude practice today!'
                    : 'Henüz şükran kaydı yok.\nBugün şükran pratiğine başla!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Group by month
    final grouped = <String, List<GratitudeEntry>>{};
    for (final entry in allEntries) {
      final parts = entry.dateKey.split('-');
      if (parts.length < 2) continue;
      final monthKey = '${parts[0]}-${parts[1]}';
      grouped.putIfAbsent(monthKey, () => []).add(entry);
    }
    final months = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Gratitude Archive' : 'Şükran Arşivi',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                _buildStatsRow(context, isDark, isEn, summary, allEntries.length),
                const SizedBox(height: AppConstants.spacingLg),

                // Top themes
                if (themes.isNotEmpty) ...[
                  _buildThemesCard(context, isDark, isEn, themes),
                  const SizedBox(height: AppConstants.spacingLg),
                ],

                // Monthly sections
                ...months.expand((monthKey) {
                  final entries = grouped[monthKey]!;
                  return [
                    _buildMonthHeader(context, isDark, isEn, monthKey, entries.length),
                    ...entries.map((e) => _buildEntryCard(context, isDark, e)),
                    const SizedBox(height: AppConstants.spacingMd),
                  ];
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    bool isDark,
    bool isEn,
    GratitudeSummary summary,
    int total,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: isEn ? 'Total Days' : 'Toplam Gün',
            value: '$total',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: isEn ? 'This Week' : 'Bu Hafta',
            value: '${summary.daysWithGratitude}',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: isEn ? 'Week Items' : 'Hafta Madde',
            value: '${summary.totalItems}',
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildThemesCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    Map<String, int> themes,
  ) {
    final topThemes = themes.entries.take(10).toList();
    if (topThemes.isEmpty) return const SizedBox.shrink();
    final maxFreq = topThemes.first.value;

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Recurring Themes' : 'Tekrarlanan Temalar',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topThemes.map((theme) {
              final opacity = 0.4 + (theme.value / maxFreq) * 0.6;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withValues(alpha: opacity * 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.auroraStart.withValues(alpha: opacity * 0.5),
                  ),
                ),
                child: Text(
                  '${theme.key} (${theme.value})',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.auroraStart.withValues(alpha: opacity),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(
    BuildContext context,
    bool isDark,
    bool isEn,
    String monthKey,
    int count,
  ) {
    final parts = monthKey.split('-');
    if (parts.length < 2) return const SizedBox.shrink();
    final year = parts[0];
    final month = int.tryParse(parts[1]) ?? 1;
    final monthNames = isEn
        ? ['', 'January', 'February', 'March', 'April', 'May', 'June',
           'July', 'August', 'September', 'October', 'November', 'December']
        : ['', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
           'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];

    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacingMd,
        bottom: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          Text(
            '${monthNames[month]} $year',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.starGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            isEn ? '$count entries' : '$count kayıt',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    bool isDark,
    GratitudeEntry entry,
  ) {
    final parts = entry.dateKey.split('-');
    final dayStr = parts.length >= 3 ? '${parts[2]}.${parts[1]}.${parts[0]}' : entry.dateKey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GlassPanel(
        elevation: GlassElevation.g1,
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayStr,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 6),
            ...entry.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✦ ',
                    style: TextStyle(
                      color: AppColors.auroraStart,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
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
              color: AppColors.auroraStart,
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
