import 'dart:async';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/dream_journal_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/ecosystem_widgets.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../core/constants/routes.dart';
import 'package:go_router/go_router.dart';

class DreamArchiveScreen extends ConsumerStatefulWidget {
  const DreamArchiveScreen({super.key});

  @override
  ConsumerState<DreamArchiveScreen> createState() => _DreamArchiveScreenState();
}

class _DreamArchiveScreenState extends ConsumerState<DreamArchiveScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  List<DreamEntry>? _dreams;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('dreamArchive'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('dreamArchive', source: 'direct'));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _searchQuery = value.trim());
      _loadDreams();
    });
  }

  Future<void> _loadDreams() async {
    final serviceAsync = ref.read(dreamJournalServiceProvider);
    final service = serviceAsync.valueOrNull;
    if (service == null) return;

    setState(() => _isLoading = true);

    try {
      final List<DreamEntry> results;
      if (_searchQuery.isNotEmpty) {
        results = await service.searchByKeyword(_searchQuery);
      } else {
        results = await service.getAllDreams();
      }
      // Sort newest first
      results.sort((a, b) => b.dreamDate.compareTo(a.dreamDate));
      if (mounted) {
        setState(() {
          _dreams = results;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Groups dreams by month and returns sorted map entries (newest first).
  List<MapEntry<String, List<DreamEntry>>> _groupByMonth(
    List<DreamEntry> dreams,
  ) {
    final grouped = <String, List<DreamEntry>>{};
    for (final dream in dreams) {
      final key =
          '${dream.dreamDate.year}-${dream.dreamDate.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(dream);
    }
    final entries = grouped.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return entries;
  }

  String _formatMonthHeader(String key, bool isEn) {
    final parts = key.split('-');
    if (parts.length < 2) return key;
    final year = parts[0];
    final month = int.tryParse(parts[1]) ?? 1;

    final months = isEn ? CommonStrings.monthsFullEn : CommonStrings.monthsFullTr;

    final monthName = months[month - 1];
    return '$monthName $year';
  }

  String _formatDate(DateTime date, bool isEn) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return isEn ? '$month/$day/$year' : '$day.$month.$year';
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(dreamJournalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: serviceAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
              child: Text(
                isEn ? 'Failed to load dreams' : 'Rüyalar yüklenemedi',
                style: AppTypography.decorativeScript(
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
            data: (service) {
              // Initial load
              if (_dreams == null && _isLoading) {
                _loadDreamsInitial(service);
              }

              final dreams = _dreams ?? [];
              final grouped = _groupByMonth(dreams);

              // Compute stats
              final totalDreams = dreams.length;
              final recurringCount = dreams.where((d) => d.isRecurring).length;
              final lucidCount = dreams.where((d) => d.isLucid).length;

              return CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      GlassSliverAppBar(
                        title: isEn ? 'Dream Archive' : 'Rüya Arşivi',
                      ),

                      // Stats row
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppConstants.spacingLg,
                            AppConstants.spacingMd,
                            AppConstants.spacingLg,
                            AppConstants.spacingSm,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _StatTile(
                                  label: isEn ? 'Total' : 'Toplam',
                                  value: '$totalDreams',
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingSm),
                              Expanded(
                                child: _StatTile(
                                  label: isEn ? 'Recurring' : 'Tekrarlayan',
                                  value: '$recurringCount',
                                  isDark: isDark,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingSm),
                              Expanded(
                                child: _StatTile(
                                  label: isEn ? 'Lucid' : 'Lüsid',
                                  value: '$lucidCount',
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Search field
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingLg,
                            vertical: AppConstants.spacingSm,
                          ),
                          child: _buildSearchBar(isDark, isEn),
                        ),
                      ),

                      // Loading indicator
                      if (_isLoading)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(AppConstants.spacingXl),
                            child: Center(child: CupertinoActivityIndicator()),
                          ),
                        )
                      // Empty state
                      else if (dreams.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: ToolEmptyState(
                            icon: Icons.nightlight_round,
                            titleEn: 'No dreams logged',
                            titleTr: 'Henüz rüya kaydedilmedi',
                            descriptionEn:
                                'No dreams logged. The glossary is available when you are.',
                            descriptionTr:
                                'Henüz rüya kaydedilmedi. Sözlük hazır olduğunda seni bekliyor.',
                            onStartTemplate: () =>
                                context.push(Routes.dreamInterpretation),
                            isEn: isEn,
                            isDark: isDark,
                          ),
                        )
                      // Grouped dream list
                      else
                        ...grouped.map((entry) {
                          final monthKey = entry.key;
                          final monthDreams = entry.value;

                          return SliverMainAxisGroup(
                            slivers: [
                              // Month header
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    AppConstants.spacingLg,
                                    AppConstants.spacingLg,
                                    AppConstants.spacingLg,
                                    AppConstants.spacingSm,
                                  ),
                                  child: GradientText(
                                    _formatMonthHeader(monthKey, isEn),
                                    variant: GradientTextVariant.gold,
                                    style: AppTypography.displayFont.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                              // Dream cards for this month
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spacingLg,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppConstants.spacingSm,
                                      ),
                                      child: _DreamCard(
                                        dream: monthDreams[index],
                                        isDark: isDark,
                                        isEn: isEn,
                                        formatDate: _formatDate,
                                      ),
                                    );
                                  }, childCount: monthDreams.length),
                                ),
                              ),
                            ],
                          );
                        }),

                      // Footer
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingLg,
                          ),
                          child: ToolEcosystemFooter(
                            currentToolId: 'dreamArchive',
                            isEn: isEn,
                            isDark: isDark,
                          ),
                        ),
                      ),

                      // Bottom padding
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppConstants.spacingHuge),
                      ),
                    ],
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.02, duration: 400.ms);
            },
          ),
        ),
      ),
    );
  }

  void _loadDreamsInitial(DreamJournalService service) {
    // Schedule the load after this build frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final results = await service.getAllDreams();
      results.sort((a, b) => b.dreamDate.compareTo(a.dreamDate));
      if (mounted) {
        setState(() {
          _dreams = results;
          _isLoading = false;
        });
      }
    });
  }

  Widget _buildSearchBar(bool isDark, bool isEn) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: TextStyle(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: isEn ? 'Search dreams...' : 'Rüyalarda ara...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  tooltip: isEn ? 'Clear search' : 'Aramayı temizle',
                  icon: Icon(
                    Icons.cancel,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                    _loadDreams();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// STAT TILE
// =============================================================================

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
        vertical: AppConstants.spacingMd,
      ),
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.displayFont.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.elegantAccent(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DREAM CARD
// =============================================================================

class _DreamCard extends StatelessWidget {
  final DreamEntry dream;
  final bool isDark;
  final bool isEn;
  final String Function(DateTime, bool) formatDate;

  const _DreamCard({
    required this.dream,
    required this.isDark,
    required this.isEn,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with indicators
          Row(
            children: [
              Expanded(
                child: Text(
                  dream.title,
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (dream.isRecurring || dream.isLucid || dream.isNightmare)
                Padding(
                  padding: const EdgeInsets.only(left: AppConstants.spacingSm),
                  child: _buildIndicators(),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingXs),

          // Date
          Text(
            formatDate(dream.dreamDate, isEn),
            style: AppTypography.elegantAccent(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),

          // Content preview
          if (dream.content.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              dream.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],

          // Detected symbols as tags
          if (dream.detectedSymbols.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingSm),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: dream.detectedSymbols.take(5).map((symbol) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.starGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusFull,
                    ),
                    border: Border.all(
                      color: AppColors.starGold.withValues(alpha: 0.25),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    symbol,
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.starGold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    final indicators = <String>[];
    if (dream.isRecurring) indicators.add('\u{1F504}');
    if (dream.isLucid) indicators.add('\u{1F4AB}');
    if (dream.isNightmare) indicators.add('\u{1F630}');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: indicators
          .map(
            (emoji) => Padding(
              padding: const EdgeInsets.only(left: 2),
              child: AppSymbol.inline(emoji),
            ),
          )
          .toList(),
    );
  }
}
