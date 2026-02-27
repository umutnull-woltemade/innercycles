import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/journal_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/ecosystem_widgets.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/premium_empty_state.dart';

class MemoriesScreen extends ConsumerStatefulWidget {
  const MemoriesScreen({super.key});

  @override
  ConsumerState<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends ConsumerState<MemoriesScreen> {
  /// Selected month as DateTime (year + month only)
  DateTime? _selectedMonth;

  JournalService? _lastService;
  List<JournalEntry> _cachedEntries = const [];

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEn ? 'Couldn\'t load your memories' : 'Anıların yüklenemedi',
                    textAlign: TextAlign.center,
                    style: AppTypography.decorativeScript(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(journalServiceProvider),
                    icon: Icon(Icons.refresh_rounded,
                        size: 16, color: AppColors.starGold),
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
            data: (service) {
              if (!identical(service, _lastService)) {
                _lastService = service;
                _cachedEntries = service.getAllEntries();
              }
              final allEntries = _cachedEntries;

              if (allEntries.isEmpty) {
                return _buildEmptyState(context, isDark, isEn);
              }

              // Sort newest first
              final sorted = List<JournalEntry>.from(allEntries)
                ..sort((a, b) => b.date.compareTo(a.date));

              // Default to current month
              final now = DateTime.now();
              final selectedMonth =
                  _selectedMonth ?? DateTime(now.year, now.month);

              // Entries for selected month
              final monthEntries = sorted
                  .where(
                    (e) =>
                        e.date.year == selectedMonth.year &&
                        e.date.month == selectedMonth.month,
                  )
                  .toList();

              // On this day entries
              final onThisDayEntries = sorted.where((e) {
                return e.date.month == now.month &&
                    e.date.day == now.day &&
                    e.date.year != now.year;
              }).toList();

              // Stats
              final photoEntries = allEntries
                  .where((e) => e.imagePath != null)
                  .length;
              final firstEntry = sorted.last;
              final firstDateStr =
                  '${firstEntry.date.day}.${firstEntry.date.month}.${firstEntry.date.year}';

              // Available months
              final months = _getAvailableMonths(sorted);

              return CupertinoScrollbar(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    GlassSliverAppBar(title: isEn ? 'Memories' : 'An\u0131lar'),
                    // Stats header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingLg,
                        ),
                        child: _MemoriesStatsHeader(
                          totalEntries: allEntries.length,
                          photoEntries: photoEntries,
                          firstDate: firstDateStr,
                          isDark: isDark,
                          isEn: isEn,
                        ),
                      ).animate().fadeIn(duration: 300.ms),
                    ),
                    // On This Day
                    if (onThisDayEntries.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppConstants.spacingLg,
                            right: AppConstants.spacingLg,
                            top: AppConstants.spacingXl,
                            bottom: AppConstants.spacingMd,
                          ),
                          child: GradientText(
                            isEn
                                ? 'On This Day'
                                : 'Bug\u00fcn Ge\u00e7mi\u015fte',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingLg,
                            ),
                            itemCount: onThisDayEntries.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: _OnThisDayCard(
                                  entry: onThisDayEntries[index],
                                  isDark: isDark,
                                  isEn: isEn,
                                  onTap: () => _navigateToEntry(
                                    context,
                                    onThisDayEntries[index],
                                  ),
                                ),
                              ).animate().fadeIn(
                                delay: Duration(
                                  milliseconds: 50 * (index % 10),
                                ),
                                duration: 300.ms,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    // Month Selector
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: AppConstants.spacingLg,
                          right: AppConstants.spacingLg,
                          top: AppConstants.spacingXl,
                          bottom: AppConstants.spacingMd,
                        ),
                        child: _MonthSelector(
                          months: months,
                          selectedMonth: selectedMonth,
                          isDark: isDark,
                          isEn: isEn,
                          onMonthSelected: (month) {
                            setState(() => _selectedMonth = month);
                          },
                        ),
                      ),
                    ),
                    // Month entries
                    if (monthEntries.isEmpty)
                      SliverToBoxAdapter(
                        child: PremiumEmptyState(
                          icon: Icons.auto_stories_rounded,
                          title: isEn
                              ? 'This month is a blank canvas'
                              : 'Bu ay boş bir tuval',
                          description: isEn
                              ? 'Your memories from this period will appear here'
                              : 'Bu döneme ait anıların burada görünecek',
                          gradientVariant: GradientTextVariant.gold,
                          ctaLabel: isEn ? 'Write an Entry' : 'Kayıt Yaz',
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
                            final entry = monthEntries[index];
                            return _MemoryCard(
                              entry: entry,
                              isDark: isDark,
                              isEn: isEn,
                              onTap: () => _navigateToEntry(context, entry),
                            ).animate().fadeIn(
                              delay: Duration(milliseconds: 50 * (index % 10)),
                              duration: 300.ms,
                            );
                          }, childCount: monthEntries.length),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, bool isEn) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(title: isEn ? 'Memories' : 'An\u0131lar'),
        SliverFillRemaining(
          hasScrollBody: false,
          child: ToolEmptyState(
            icon: Icons.photo_library_outlined,
            titleEn: 'No memories yet',
            titleTr: 'Hen\u00fcz an\u0131 yok',
            descriptionEn:
                'Start journaling to build your memories collection.',
            descriptionTr:
                'An\u0131lar\u0131n\u0131 olu\u015fturmak i\u00e7in g\u00fcnl\u00fck yazmaya ba\u015fla.',
            onStartTemplate: () => context.go(Routes.journal),
            isEn: isEn,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  List<DateTime> _getAvailableMonths(List<JournalEntry> sortedEntries) {
    final months = <String, DateTime>{};
    for (final entry in sortedEntries) {
      final key = '${entry.date.year}-${entry.date.month}';
      months.putIfAbsent(
        key,
        () => DateTime(entry.date.year, entry.date.month),
      );
    }
    final result = months.values.toList()..sort((a, b) => b.compareTo(a));
    return result;
  }

  void _navigateToEntry(BuildContext context, JournalEntry entry) {
    HapticFeedback.lightImpact();
    context.push(Routes.journalEntryDetail.replaceFirst(':id', entry.id));
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STATS HEADER
// ════════════════════════════════════════════════════════════════════════════

class _MemoriesStatsHeader extends StatelessWidget {
  final int totalEntries;
  final int photoEntries;
  final String firstDate;
  final bool isDark;
  final bool isEn;

  const _MemoriesStatsHeader({
    required this.totalEntries,
    required this.photoEntries,
    required this.firstDate,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 14,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MiniStat(
            value: '$totalEntries',
            label: isEn ? 'Entries' : 'Kay\u0131t',
            color: AppColors.auroraStart,
            isDark: isDark,
          ),
          _MiniStat(
            value: '$photoEntries',
            label: isEn ? 'Photos' : 'Foto\u011fraf',
            color: AppColors.starGold,
            isDark: isDark,
          ),
          _MiniStat(
            value: firstDate,
            label: isEn ? 'Since' : '\u0130lk Kay\u0131t',
            color: AppColors.success,
            isDark: isDark,
            isSmallValue: true,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;
  final bool isSmallValue;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
    this.isSmallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: isSmallValue ? 13 : 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
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

// ════════════════════════════════════════════════════════════════════════════
// ON THIS DAY CARD
// ════════════════════════════════════════════════════════════════════════════

class _OnThisDayCard extends StatelessWidget {
  final JournalEntry entry;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;

  const _OnThisDayCard({
    required this.entry,
    required this.isDark,
    required this.isEn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _hasValidPhoto(entry);
    final dateStr = '${entry.date.day}.${entry.date.month}.${entry.date.year}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.85)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(
            color: AppColors.auroraStart.withValues(alpha: 0.25),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasPhoto)
              SizedBox(
                height: 100,
                child: Image.file(
                  File(entry.imagePath!),
                  fit: BoxFit.cover,
                  cacheWidth: 400,
                  semanticLabel: isEn ? 'Memory photo' : 'Anı fotoğrafı',
                  errorBuilder: (_, _, _) => _placeholderIcon(),
                ),
              )
            else
              SizedBox(height: 100, child: _placeholderIcon()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dateStr,
                      style: AppTypography.modernAccent(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.auroraStart,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isEn
                          ? entry.focusArea.displayNameEn
                          : entry.focusArea.displayNameTr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < entry.overallRating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 12,
                          color: AppColors.starGold,
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

  Widget _placeholderIcon() {
    return Center(
      child: AppSymbol(_focusEmoji(entry.focusArea), size: AppSymbolSize.lg),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MONTH SELECTOR
// ════════════════════════════════════════════════════════════════════════════

class _MonthSelector extends StatelessWidget {
  final List<DateTime> months;
  final DateTime selectedMonth;
  final bool isDark;
  final bool isEn;
  final ValueChanged<DateTime> onMonthSelected;

  const _MonthSelector({
    required this.months,
    required this.selectedMonth,
    required this.isDark,
    required this.isEn,
    required this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: months.map((month) {
          final isSelected =
              month.year == selectedMonth.year &&
              month.month == selectedMonth.month;
          final label = _monthLabel(month, isEn);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onMonthSelected(month),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.auroraStart.withValues(alpha: 0.2)
                        : (isDark
                              ? AppColors.surfaceDark.withValues(alpha: 0.5)
                              : AppColors.lightSurfaceVariant),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusFull,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.auroraStart
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    label,
                    style:
                        AppTypography.subtitle(
                          fontSize: 13,
                          color: isSelected
                              ? AppColors.auroraStart
                              : (isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary),
                        ).copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _monthLabel(DateTime month, bool isEn) {
    final names = isEn
        ? CommonStrings.monthsShortEn
        : CommonStrings.monthsShortTr;
    final name = names[month.month - 1];
    final now = DateTime.now();
    if (month.year == now.year) return name;
    return '$name ${month.year}';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MEMORY CARD
// ════════════════════════════════════════════════════════════════════════════

class _MemoryCard extends StatelessWidget {
  final JournalEntry entry;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;

  const _MemoryCard({
    required this.entry,
    required this.isDark,
    required this.isEn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _hasValidPhoto(entry);
    if (hasPhoto) {
      return _buildPhotoCard(context);
    }
    return _buildTextCard(context);
  }

  Widget _buildPhotoCard(BuildContext context) {
    final dateStr = '${entry.date.day}.${entry.date.month}.${entry.date.year}';
    final areaLabel = isEn
        ? entry.focusArea.displayNameEn
        : entry.focusArea.displayNameTr;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(entry.imagePath!),
                  fit: BoxFit.cover,
                  cacheWidth: 800,
                  semanticLabel: isEn ? 'Memory photo' : 'Anı fotoğrafı',
                  errorBuilder: (_, _, _) => Container(
                    color: isDark
                        ? AppColors.surfaceDark
                        : AppColors.lightSurfaceVariant,
                    child: Center(
                      child: AppSymbol(
                        _focusEmoji(entry.focusArea),
                        size: AppSymbolSize.xl,
                      ),
                    ),
                  ),
                ),
                // Gradient overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateStr,
                                style: AppTypography.displayFont.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                areaLabel,
                                style: AppTypography.elegantAccent(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < entry.overallRating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 14,
                              color: AppColors.starGold,
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
        ),
      ),
    );
  }

  Widget _buildTextCard(BuildContext context) {
    final dateStr = '${entry.date.day}.${entry.date.month}.${entry.date.year}';
    final areaLabel = isEn
        ? entry.focusArea.displayNameEn
        : entry.focusArea.displayNameTr;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: GestureDetector(
        onTap: onTap,
        child: PremiumCard(
          style: PremiumCardStyle.subtle,
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Row(
            children: [
              // Emoji circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.auroraStart.withValues(alpha: 0.12),
                ),
                child: Center(
                  child: Text(
                    _focusEmoji(entry.focusArea),
                    style: AppTypography.subtitle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          areaLabel,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const Spacer(),
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < entry.overallRating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 12,
                            color: AppColors.starGold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.decorativeScript(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HELPERS
// ════════════════════════════════════════════════════════════════════════════

String _focusEmoji(FocusArea area) {
  switch (area) {
    case FocusArea.energy:
      return '\u{26A1}';
    case FocusArea.focus:
      return '\u{1F3AF}';
    case FocusArea.emotions:
      return '\u{1F30A}';
    case FocusArea.decisions:
      return '\u{1F9ED}';
    case FocusArea.social:
      return '\u{1F91D}';
  }
}

bool _hasValidPhoto(JournalEntry entry) {
  if (kIsWeb) return false;
  final path = entry.imagePath;
  if (path == null || path.isEmpty) return false;
  try {
    return File(path).existsSync();
  } catch (_) {
    return false;
  }
}
