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
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/glass_dialog.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  FocusArea? _filterArea;
  String _searchQuery = '';
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
                            ref.invalidate(journalServiceProvider),
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: AppColors.starGold,
                        ),
                        label: Text(
                          isEn ? 'Retry' : 'Tekrar Dene',
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
                final entries = _cachedEntries.where((e) {
                  if (_filterArea != null && e.focusArea != _filterArea) {
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
                    slivers: [
                      GlassSliverAppBar(title: isEn ? 'Archive' : 'Arşiv'),
                      // Search bar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingLg,
                          ),
                          child: _buildSearchBar(isDark, isEn),
                        ),
                      ),
                      // Filter chips
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.spacingLg),
                          child: _buildFilterChips(isDark, isEn),
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
                            title: isEn ? 'Your journal is a blank page — ready when you are' : 'Günlüğün boş bir sayfa — hazır olduğunda burada',
                            description: isEn
                                ? 'Your journal entries will appear here as you build your personal cycle map.'
                                : 'Kişisel döngü haritanı oluşturdukça günlük kayıtların burada görünecek.',
                            ctaLabel: isEn ? 'Write First Entry' : 'İlk Kaydını Yaz',
                            onCtaPressed: () => context.go(Routes.journal),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.all(AppConstants.spacingLg),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final entry = entries[index];
                              return Dismissible(
                                key: ValueKey(entry.id),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (_) async {
                                  final confirmed = await GlassDialog.confirm(
                                    context,
                                    title: isEn ? 'Delete Entry?' : 'Kayıt Silinsin mi?',
                                    message: isEn
                                        ? 'This journal entry will be permanently deleted.'
                                        : 'Bu günlük kaydı kalıcı olarak silinecek.',
                                    confirmLabel: isEn ? 'Delete' : 'Sil',
                                    cancelLabel: isEn ? 'Cancel' : 'İptal',
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
                            }, childCount: entries.length),
                          ),
                        ),
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
          hintText: isEn ? 'Search by date, mood, or text...' : 'Tarih, ruh hali veya metne göre ara...',
          hintStyle: AppTypography.subtitle(
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

  Widget _buildFilterChips(bool isDark, bool isEn) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            isEn ? 'All' : 'Tümü',
            _filterArea == null,
            () => setState(() => _filterArea = null),
            isDark,
            isEn: isEn,
          ),
          ...FocusArea.values.map((area) {
            final label = isEn ? area.displayNameEn : area.displayNameTr;
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

  Widget _buildChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool isDark, {
    bool isEn = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Semantics(
        button: true,
        label: isEn ? 'Filter: $label' : 'Filtre: $label',
        child: GestureDetector(
          onTap: onTap,
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
    final areaLabel = isEn
        ? entry.focusArea.displayNameEn
        : entry.focusArea.displayNameTr;
    final dateStr = '${entry.date.day}.${entry.date.month}.${entry.date.year}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: Semantics(
        button: true,
        label: '$areaLabel entry, $dateStr',
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
                            final words = entry.note!.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
                            return isEn ? '$words words' : '$words kelime';
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
