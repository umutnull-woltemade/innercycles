import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/journal_entry.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/journal_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../data/services/premium_service.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/skeleton_loader.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';
import '../../../shared/widgets/tag_cloud_widget.dart';
import 'widgets/year_heatmap_calendar.dart';
import '../../../data/services/l10n_service.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  FocusArea? _filterArea;
  String _searchQuery = '';
  String _dateRange = 'all'; // all, 7d, 30d, 3m, year
  bool _showOnlyFavorites = false;
  String? _selectedTag;
  bool _showTagCloud = false;
  bool _showCalendarView = false;
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  // Cache allEntries to avoid refetching on every setState (search/filter)
  JournalService? _lastService;
  List<JournalEntry> _cachedEntries = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('journalArchive'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('journalArchive', source: 'direct'));
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: serviceAsync.when(
              loading: () => Padding(
                padding: const EdgeInsets.all(24),
                child: SkeletonLoader.cardList(count: 5),
              ),
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
                            ref.invalidate(journalServiceProvider),
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: AppColors.starGold,
                        ),
                        label: Text(
                          L10nService.get('journal.archive.retry', language),
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
              data: (service) {
                if (!identical(service, _lastService)) {
                  _lastService = service;
                  _cachedEntries = service.getAllEntries();
                }
                final searchLower = _searchQuery.toLowerCase();
                final now = DateTime.now();
                final dateFloor = _dateRange == '7d'
                    ? now.subtract(const Duration(days: 7))
                    : _dateRange == '30d'
                        ? now.subtract(const Duration(days: 30))
                        : _dateRange == '3m'
                            ? now.subtract(const Duration(days: 90))
                            : _dateRange == 'year'
                                ? DateTime(now.year, 1, 1)
                                : null;
                final entries = _cachedEntries.where((e) {
                  if (_showOnlyFavorites && !e.isFavorite) return false;
                  if (_selectedTag != null && !e.tags.any((t) => t.toLowerCase() == _selectedTag!.toLowerCase())) return false;
                  if (_filterArea != null && e.focusArea != _filterArea) {
                    return false;
                  }
                  if (dateFloor != null && e.date.isBefore(dateFloor)) {
                    return false;
                  }
                  if (searchLower.isNotEmpty) {
                    return e.note?.toLowerCase().contains(searchLower) ?? false;
                  }
                  return true;
                }).toList();

                return RefreshIndicator(
                  color: AppColors.starGold,
                  onRefresh: () async {
                    _lastService = null;
                    ref.invalidate(journalServiceProvider);
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
                        title: L10nService.get('journal.archive.archive', language),
                        actions: [
                          GestureDetector(
                            onTap: () => setState(() => _showCalendarView = !_showCalendarView),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Icon(
                                _showCalendarView ? Icons.view_list_rounded : Icons.calendar_view_month_rounded,
                                size: 22,
                                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Search bar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingLg,
                          ),
                          child: _buildSearchBar(isDark, isEn),
                        ),
                      ),
                      // Focus area filter chips
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppConstants.spacingLg,
                            AppConstants.spacingLg,
                            AppConstants.spacingLg,
                            AppConstants.spacingXs,
                          ),
                          child: _buildFilterChips(isDark, isEn),
                        ),
                      ),
                      // Date range filter chips
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppConstants.spacingLg,
                            0,
                            AppConstants.spacingLg,
                            AppConstants.spacingMd,
                          ),
                          child: _buildDateRangeChips(isDark, isEn),
                        ),
                      ),
                      // Tag cloud (toggleable)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppConstants.spacingLg,
                            0,
                            AppConstants.spacingLg,
                            AppConstants.spacingSm,
                          ),
                          child: _buildTagCloudSection(service, isDark, isEn),
                        ),
                      ),
                      // Year heatmap calendar (toggleable)
                      if (_showCalendarView)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingLg,
                              vertical: AppConstants.spacingSm,
                            ),
                            child: YearHeatmapCalendar(
                              entries: _cachedEntries,
                              isDark: isDark,
                              isEn: isEn,
                              onEntryTapped: (entry) => context.push(
                                Routes.journalEntryDetail.replaceFirst(':id', entry.id),
                              ),
                            ),
                          ),
                        ),
                      // Entry count
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingLg,
                          ),
                          child: Text(
                            isEn
                                ? '${entries.length} entries'
                                : '${entries.length} kayıt',
                            style: AppTypography.elegantAccent(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      // Entry list
                      if (entries.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: PremiumEmptyState(
                            icon: Icons.book_outlined,
                            title: L10nService.get('journal.archive.your_journal_is_a_blank_page_ready_when', language),
                            description: L10nService.get('journal.archive.your_journal_entries_will_appear_here_as', language),
                            ctaLabel: L10nService.get('journal.archive.write_first_entry', language),
                            onCtaPressed: () => context.push(Routes.journal),
                          ),
                        )
                      else ...[
                        SliverPadding(
                          padding: const EdgeInsets.all(AppConstants.spacingLg),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final isPremium = ref.watch(isPremiumUserProvider);
                              const freeLimit = 10;
                              // Gate: free users see only last 10 entries
                              if (!isPremium && index >= freeLimit) {
                                if (index == freeLimit) {
                                  return _buildPremiumArchiveGate(isDark, isEn);
                                }
                                return const SizedBox.shrink();
                              }
                              final entry = entries[index];
                              return Dismissible(
                                key: ValueKey(entry.id),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (_) async {
                                  final confirmed = await GlassDialog.confirm(
                                    context,
                                    title: L10nService.get('journal.archive.delete_entry', language),
                                    message: L10nService.get('journal.archive.this_journal_entry_will_be_permanently_d', language),
                                    confirmLabel: L10nService.get('journal.archive.delete', language),
                                    cancelLabel: L10nService.get('journal.archive.cancel', language),
                                    isDestructive: true,
                                  );
                                  if (confirmed == true) {
                                    final service = ref.read(journalServiceProvider).valueOrNull;
                                    if (service != null) {
                                      await service.deleteEntry(entry.id);
                                      _lastService = null;
                                      if (mounted) setState(() {
                                        _cachedEntries = ref.read(journalServiceProvider).valueOrNull?.getAllEntries() ?? [];
                                      });
                                    }
                                  }
                                  return false;
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 28),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                    size: 22,
                                  ),
                                ),
                                child: _buildEntryCard(
                                  context,
                                  entry,
                                  isDark,
                                  isEn,
                                ),
                              ).animate().fadeIn(
                                delay: Duration(
                                  milliseconds: 50 * (index % 10),
                                ),
                                duration: 300.ms,
                              );
                            }, childCount: () {
                              final isPremium = ref.watch(isPremiumUserProvider);
                              const freeLimit = 10;
                              if (!isPremium && entries.length > freeLimit) {
                                return freeLimit + 1; // +1 for gate widget
                              }
                              return entries.length;
                            }()),
                          ),
                        ),
                      ],
                      const SliverToBoxAdapter(child: SizedBox(height: 40)),
                    ],
                  ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumArchiveGate(bool isDark, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.starGold.withValues(alpha: isDark ? 0.08 : 0.05),
              AppColors.celestialGold.withValues(alpha: isDark ? 0.04 : 0.03),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.starGold.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.lock_rounded,
              size: 28,
              color: AppColors.starGold,
            ),
            const SizedBox(height: 10),
            Text(
              isEn
                  ? 'Unlock Your Full Archive'
                  : 'Tüm Arşivini Aç',
              style: AppTypography.displayFont.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              isEn
                  ? 'Premium members can browse all entries and discover deeper patterns'
                  : 'Premium üyeler tüm girişlere göz atabilir ve daha derin örüntüler keşfedebilir',
              style: AppTypography.subtitle(
                fontSize: 13,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    showContextualPaywall(
                      context,
                      ref,
                      paywallContext: PaywallContext.general,
                      bypassTimingGate: true,
                    );
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEn ? 'See Premium Plans' : 'Premium Planları Gör',
                    style: AppTypography.subtitle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, bool isEn) {
    final language = AppLanguage.fromIsEn(isEn);
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
      child: Semantics(
        label: isEn ? 'Search journal entries' : 'Günlük kayıtlarını ara',
        textField: true,
        child: TextField(
          controller: _searchController,
        textInputAction: TextInputAction.search,
        onChanged: (v) {
          _searchDebounce?.cancel();
          _searchDebounce = Timer(const Duration(milliseconds: 300), () {
            if (mounted) setState(() => _searchQuery = v);
          });
        },
        style: AppTypography.subtitle(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: L10nService.get('journal.archive.search_by_date_mood_or_text', language),
          hintStyle: AppTypography.subtitle(
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  tooltip: L10nService.get('journal.archive.clear_search', language),
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
      ),
    );
  }

  Widget _buildFilterChips(bool isDark, bool isEn) {
    final language = AppLanguage.fromIsEn(isEn);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            L10nService.get('journal.archive.all', language),
            _filterArea == null && !_showOnlyFavorites,
            () => setState(() { _filterArea = null; _showOnlyFavorites = false; }),
            isDark,
            isEn: isEn,
          ),
          _buildChip(
            isEn ? '★ Favorites' : '★ Favoriler',
            _showOnlyFavorites,
            () => setState(() => _showOnlyFavorites = !_showOnlyFavorites),
            isDark,
            isEn: isEn,
          ),
          ...FocusArea.values.map((area) {
            final label = area.localizedName(language);
            return _buildChip(
              label,
              _filterArea == area,
              () => setState(() => _filterArea = area),
              isDark,
              isEn: isEn,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDateRangeChips(bool isDark, bool isEn) {
    final ranges = <String, String>{
      'all': isEn ? 'All Time' : 'Tüm Zamanlar',
      '7d': isEn ? 'Last 7 Days' : 'Son 7 Gün',
      '30d': isEn ? 'Last 30 Days' : 'Son 30 Gün',
      '3m': isEn ? 'Last 3 Months' : 'Son 3 Ay',
      'year': isEn ? 'This Year' : 'Bu Yıl',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ranges.entries.map((e) {
          final isSelected = _dateRange == e.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                HapticService.selectionTap();
                setState(() => _dateRange = e.key);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.auroraStart.withValues(alpha: 0.2)
                      : (isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.3)
                            : AppColors.lightSurfaceVariant.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.auroraStart.withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  e.value,
                  style: AppTypography.elegantAccent(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? AppColors.auroraStart
                        : (isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTagCloudSection(JournalService service, bool isDark, bool isEn) {
    final allTags = service.getAllTags();
    if (allTags.isEmpty) return const SizedBox.shrink();

    // Build tag counts
    final tagCounts = <String, int>{};
    for (final entry in service.getAllEntries()) {
      for (final tag in entry.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _showTagCloud = !_showTagCloud;
            if (!_showTagCloud) _selectedTag = null;
          }),
          child: Row(
            children: [
              Icon(
                Icons.tag_rounded,
                size: 14,
                color: _selectedTag != null
                    ? AppColors.starGold
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
              const SizedBox(width: 6),
              Text(
                isEn
                    ? 'Tags${_selectedTag != null ? ': #$_selectedTag' : ''}'
                    : 'Etiketler${_selectedTag != null ? ': #$_selectedTag' : ''}',
                style: AppTypography.elegantAccent(
                  fontSize: 12,
                  color: _selectedTag != null
                      ? AppColors.starGold
                      : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                ),
              ),
              const Spacer(),
              Icon(
                _showTagCloud ? Icons.expand_less : Icons.expand_more,
                size: 18,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
        if (_showTagCloud) ...[
          const SizedBox(height: 8),
          TagCloudWidget(
            tagCounts: tagCounts,
            selectedTag: _selectedTag,
            onTagSelected: (tag) => setState(() => _selectedTag = tag),
            isDark: isDark,
          ),
        ],
      ],
    );
  }

  Widget _buildChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool isDark, {
    bool isEn = true,
  }) {
    final language = AppLanguage.fromIsEn(isEn);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        label: L10nService.getWithParams('journal.archive.filter_label', language, params: {'label': label}),
        child: GestureDetector(
          onTap: () {
            HapticService.selectionTap();
            onTap();
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.starGold.withValues(alpha: 0.2)
                    : (isDark
                          ? AppColors.surfaceDark.withValues(alpha: 0.5)
                          : AppColors.lightSurfaceVariant),
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                border: Border.all(
                  color: isSelected ? AppColors.starGold : Colors.transparent,
                ),
              ),
              child: Text(
                label,
                style: AppTypography.elegantAccent(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? AppColors.starGold
                      : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    JournalEntry entry,
    bool isDark,
    bool isEn,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    final areaLabel = entry.focusArea.localizedName(language);
    final dateStr = '${entry.date.day}.${entry.date.month}.${entry.date.year}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: Semantics(
        button: true,
        label: L10nService.getWithParams('journal.archive.entry_semantics_label', language, params: {'area': areaLabel, 'date': dateStr}),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(
              Routes.journalEntryDetail.replaceFirst(':id', entry.id),
            );
          },
          child: PremiumCard(
            style: PremiumCardStyle.subtle,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Row(
              children: [
                // Rating circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.starGold.withValues(alpha: 0.15),
                    border: Border.all(
                      color: AppColors.starGold.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.overallRating}',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.starGold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        areaLabel,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (entry.note != null && entry.note!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          entry.note!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.decorativeScript(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          () {
                            final language = AppLanguage.fromIsEn(isEn);
                            final words = entry.note!.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
                            return L10nService.getWithParams('journal.archive.word_count', language, params: {'count': '$words'});
                          }(),
                          style: AppTypography.elegantAccent(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted.withValues(alpha: 0.6)
                                : AppColors.lightTextMuted.withValues(alpha: 0.6),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final service = ref.read(journalServiceProvider).valueOrNull;
                    if (service != null) {
                      await service.toggleFavorite(entry.id);
                      _lastService = null;
                      if (mounted) {
                        setState(() {
                          _cachedEntries = ref.read(journalServiceProvider).valueOrNull?.getAllEntries() ?? [];
                        });
                      }
                    }
                  },
                  child: Icon(
                    entry.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 20,
                    color: entry.isFavorite
                        ? AppColors.starGold
                        : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
