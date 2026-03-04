import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/gratitude_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/ecosystem_widgets.dart';
import '../../../core/constants/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/l10n_service.dart';

class GratitudeArchiveScreen extends ConsumerStatefulWidget {
  const GratitudeArchiveScreen({super.key});

  @override
  ConsumerState<GratitudeArchiveScreen> createState() => _GratitudeArchiveScreenState();
}

class _GratitudeArchiveScreenState extends ConsumerState<GratitudeArchiveScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(gratitudeServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    CommonStrings.somethingWentWrong(language),
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(gratitudeServiceProvider),
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 16,
                      color: AppColors.starGold,
                    ),
                    label: Text(
                      L10nService.get('gratitude.gratitude_archive.retry', language),
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
    final language = AppLanguage.fromIsEn(isEn);
    final rawEntries = service.getAllEntries();
    final themes = service.getAllTimeThemes();
    final summary = service.getWeeklySummary();

    // Apply search filter
    final allEntries = _searchQuery.isEmpty
        ? rawEntries
        : rawEntries.where((e) =>
            e.items.any((item) => item.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();

    if (rawEntries.isEmpty) {
      return CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          GlassSliverAppBar(
            title: L10nService.get('gratitude.gratitude_archive.gratitude_archive', language),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: ToolEmptyState(
              icon: Icons.favorite_border,
              title: isEn
                  ? 'Your gratitude garden is ready to bloom'
                  : 'Şükran bahçen çiçek açmaya hazır',
              description: isEn
                  ? 'Start your gratitude practice to see your appreciation patterns grow.'
                  : 'Şükran kalıplarının büyümesini görmek için şükran pratiğine başla.',
              onStartTemplate: () => context.push(Routes.gratitudeJournal),
              language: language,
              isDark: isDark,
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

    return RefreshIndicator(
      color: AppColors.starGold,
      onRefresh: () async {
        ref.invalidate(gratitudeServiceProvider);
        await Future.delayed(const Duration(milliseconds: 300));
      },
      child: CupertinoScrollbar(
        child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          GlassSliverAppBar(
            title: L10nService.get('gratitude.gratitude_archive.gratitude_archive_1', language),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: isEn ? 'Search gratitude entries...' : 'Şükran kayıtlarında ara...',
                      hintStyle: AppTypography.decorativeScript(
                        fontSize: 13,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                      prefixIcon: Icon(CupertinoIcons.search, size: 18,
                          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: Icon(CupertinoIcons.xmark_circle_fill, size: 16,
                                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Stats row
                _buildStatsRow(
                  context,
                  isDark,
                  isEn,
                  summary,
                  allEntries.length,
                ),
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
                    _buildMonthHeader(
                      context,
                      isDark,
                      isEn,
                      monthKey,
                      entries.length,
                    ),
                    ...entries.map((e) => _buildEntryCard(context, isDark, e, isEn)),
                    const SizedBox(height: AppConstants.spacingMd),
                  ];
                }),
              ]),
            ),
          ),
        ],
      ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  Widget _buildStatsRow(
    BuildContext context,
    bool isDark,
    bool isEn,
    GratitudeSummary summary,
    int total,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: L10nService.get('gratitude.gratitude_archive.total_days', language),
            value: '$total',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: L10nService.get('gratitude.gratitude_archive.this_week', language),
            value: '${summary.daysWithGratitude}',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: L10nService.get('gratitude.gratitude_archive.week_items', language),
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
    final language = AppLanguage.fromIsEn(isEn);
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
            L10nService.get('gratitude.gratitude_archive.recurring_themes', language),
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withValues(alpha: opacity * 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.auroraStart.withValues(
                      alpha: opacity * 0.5,
                    ),
                  ),
                ),
                child: Text(
                  '${theme.key} (${theme.value})',
                  style: AppTypography.elegantAccent(
                    fontSize: 13,
                    color: AppColors.auroraStart.withValues(alpha: opacity),
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
    final language = AppLanguage.fromIsEn(isEn);
    final parts = monthKey.split('-');
    if (parts.length < 2) return const SizedBox.shrink();
    final year = parts[0];
    final month = int.tryParse(parts[1]) ?? 1;
    final monthNames = isEn
        ? [
            '',
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ]
        : [
            '',
            'Ocak',
            'Şubat',
            'Mart',
            'Nisan',
            'Mayıs',
            'Haziran',
            'Temmuz',
            'Ağustos',
            'Eylül',
            'Ekim',
            'Kasım',
            'Aralık',
          ];

    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacingMd,
        bottom: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          GradientText(
            '${monthNames[month]} $year',
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            L10nService.getWithParams('gratitude.archive.entry_count', language, params: {'count': '$count'}),
            style: AppTypography.elegantAccent(
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
    bool isEn,
  ) {
    final parts = entry.dateKey.split('-');
    final dayStr = parts.length >= 3
        ? '${parts[2]}.${parts[1]}.${parts[0]}'
        : entry.dateKey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GlassPanel(
        elevation: GlassElevation.g1,
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dayStr,
                  style: AppTypography.elegantAccent(
                    fontSize: 12,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    HapticService.buttonPress();
                    final items = entry.items.map((item) => '✦ $item').join('\n');
                    final text = isEn
                        ? 'Grateful for:\n$items\n\n— InnerCycles'
                        : 'Şükran duyduklarım:\n$items\n\n— InnerCycles';
                    SharePlus.instance.share(ShareParams(text: text));
                  },
                  child: Icon(
                    Icons.share_outlined,
                    size: 16,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...entry.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✦ ',
                      style: AppTypography.elegantAccent(
                        color: AppColors.auroraStart,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          GradientText(
            value,
            variant: GradientTextVariant.aurora,
            style: AppTypography.displayFont.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.elegantAccent(
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
