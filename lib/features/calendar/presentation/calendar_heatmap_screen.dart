// ════════════════════════════════════════════════════════════════════════════
// CALENDAR HEATMAP SCREEN - GitHub-Style Activity Visualization
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/journal_entry.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/journal_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class CalendarHeatmapScreen extends ConsumerStatefulWidget {
  const CalendarHeatmapScreen({super.key});

  @override
  ConsumerState<CalendarHeatmapScreen> createState() =>
      _CalendarHeatmapScreenState();
}

class _CalendarHeatmapScreenState extends ConsumerState<CalendarHeatmapScreen> {
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  String? _selectedDateKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(smartRouterServiceProvider).whenData((s) => s.recordToolVisit('calendarHeatmap'));
      ref.read(ecosystemAnalyticsServiceProvider).whenData((s) => s.trackToolOpen('calendarHeatmap', source: 'direct'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Text(
              CommonStrings.somethingWentWrong(language),
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
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
    JournalService service,
    bool isDark,
    bool isEn,
  ) {
    final allEntries = service.getAllEntries();
    final monthEntries = service.getEntriesForMonth(_selectedYear, _selectedMonth);

    // Build entry map: dateKey -> entry
    final entryMap = <String, JournalEntry>{};
    for (final entry in allEntries) {
      entryMap[entry.dateKey] = entry;
    }

    // Stats
    final totalEntries = allEntries.length;
    final monthCount = monthEntries.length;
    final streak = service.getCurrentStreak();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Activity Map' : 'Aktivite Haritası',
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Stats row
              _StatsRow(
                totalEntries: totalEntries,
                monthCount: monthCount,
                streak: streak,
                isDark: isDark,
                isEn: isEn,
              ),
              const SizedBox(height: 20),

              // Month navigator
              _MonthNavigator(
                year: _selectedYear,
                month: _selectedMonth,
                isDark: isDark,
                isEn: isEn,
                onPrevious: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedMonth--;
                    if (_selectedMonth < 1) {
                      _selectedMonth = 12;
                      _selectedYear--;
                    }
                    _selectedDateKey = null;
                  });
                },
                onNext: () {
                  final now = DateTime.now();
                  if (_selectedYear > now.year ||
                      (_selectedYear == now.year && _selectedMonth >= now.month)) {
                    return;
                  }
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedMonth++;
                    if (_selectedMonth > 12) {
                      _selectedMonth = 1;
                      _selectedYear++;
                    }
                    _selectedDateKey = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Calendar grid
              _CalendarGrid(
                year: _selectedYear,
                month: _selectedMonth,
                entryMap: entryMap,
                selectedDateKey: _selectedDateKey,
                isDark: isDark,
                isEn: isEn,
                onDayTap: (dateKey) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedDateKey =
                        _selectedDateKey == dateKey ? null : dateKey;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Legend
              _Legend(isDark: isDark, isEn: isEn),
              const SizedBox(height: 20),

              // Selected day detail
              if (_selectedDateKey != null) ...[
                _DayDetail(
                  dateKey: _selectedDateKey!,
                  entry: entryMap[_selectedDateKey],
                  isDark: isDark,
                  isEn: isEn,
                  onViewEntry: (id) => context.push(Routes.journalEntryDetail.replaceFirst(':id', id)),
                  onCreateEntry: () => context.push(Routes.journal),
                ),
                const SizedBox(height: 20),
              ],

              // Year heatmap (mini)
              _YearHeatmap(
                year: _selectedYear,
                entryMap: entryMap,
                isDark: isDark,
                isEn: isEn,
              ),

              ToolEcosystemFooter(currentToolId: 'calendarHeatmap', isEn: isEn, isDark: isDark),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATS ROW
// ═══════════════════════════════════════════════════════════════════════════

class _StatsRow extends StatelessWidget {
  final int totalEntries;
  final int monthCount;
  final int streak;
  final bool isDark;
  final bool isEn;

  const _StatsRow({
    required this.totalEntries,
    required this.monthCount,
    required this.streak,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatPill(
          label: isEn ? 'Total' : 'Toplam',
          value: '$totalEntries',
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatPill(
          label: isEn ? 'This Month' : 'Bu Ay',
          value: '$monthCount',
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatPill(
          label: isEn ? 'Streak' : 'Seri',
          value: '$streak',
          isDark: isDark,
          accent: true,
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool accent;

  const _StatPill({
    required this.label,
    required this.value,
    required this.isDark,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: accent
              ? AppColors.starGold.withValues(alpha: isDark ? 0.15 : 0.1)
              : (isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.8)
                  : AppColors.lightCard),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accent
                ? AppColors.starGold.withValues(alpha: 0.3)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.05)),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: accent
                    ? AppColors.starGold
                    : (isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MONTH NAVIGATOR
// ═══════════════════════════════════════════════════════════════════════════

class _MonthNavigator extends StatelessWidget {
  final int year;
  final int month;
  final bool isDark;
  final bool isEn;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthNavigator({
    required this.year,
    required this.month,
    required this.isDark,
    required this.isEn,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final monthNames = isEn
        ? [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December',
          ]
        : [
            'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
            'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
          ];

    final now = DateTime.now();
    final isCurrentMonth = year == now.year && month == now.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: isEn ? 'Previous month' : 'Önceki ay',
          icon: Icon(
            Icons.chevron_left_rounded,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
          ),
          onPressed: onPrevious,
        ),
        Text(
          '${monthNames[month - 1]} $year',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        IconButton(
          tooltip: isEn ? 'Next month' : 'Sonraki ay',
          icon: Icon(
            Icons.chevron_right_rounded,
            color: isCurrentMonth
                ? (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                    .withValues(alpha: 0.3)
                : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
          ),
          onPressed: isCurrentMonth ? null : onNext,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CALENDAR GRID
// ═══════════════════════════════════════════════════════════════════════════

class _CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final Map<String, JournalEntry> entryMap;
  final String? selectedDateKey;
  final bool isDark;
  final bool isEn;
  final ValueChanged<String> onDayTap;

  const _CalendarGrid({
    required this.year,
    required this.month,
    required this.entryMap,
    this.selectedDateKey,
    required this.isDark,
    required this.isEn,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = (firstDay.weekday % 7); // 0=Mon in ISO, adjust to Sun start
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.8)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          // Day headers
          Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) {
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Day cells
          ...List.generate(_weekCount(startWeekday, daysInMonth), (week) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (weekday) {
                  final dayIndex = week * 7 + weekday - (startWeekday - 1);
                  if (dayIndex < 1 || dayIndex > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 40));
                  }

                  final date = DateTime(year, month, dayIndex);
                  final dateKey =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  final entry = entryMap[dateKey];
                  final isToday = date.year == today.year &&
                      date.month == today.month &&
                      date.day == today.day;
                  final isFuture = date.isAfter(today);
                  final isSelected = dateKey == selectedDateKey;

                  return Expanded(
                    child: Semantics(
                      label: '${date.day}/${date.month}${entry != null ? (isEn ? ', has entry' : ', kayıt var') : ''}',
                      button: !isFuture,
                      child: GestureDetector(
                      onTap: isFuture ? null : () => onDayTap(dateKey),
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: _getCellColor(entry, isToday, isFuture, isDark),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.starGold,
                                  width: 2,
                                )
                              : isToday
                                  ? Border.all(
                                      color: AppColors.auroraStart
                                          .withValues(alpha: 0.5),
                                      width: 1.5,
                                    )
                                  : null,
                        ),
                        child: Center(
                          child: Text(
                            '$dayIndex',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: entry != null
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isFuture
                                  ? (isDark
                                      ? AppColors.textMuted
                                          .withValues(alpha: 0.3)
                                      : AppColors.lightTextMuted
                                          .withValues(alpha: 0.3))
                                  : entry != null
                                      ? Colors.white
                                      : (isDark
                                          ? AppColors.textMuted
                                          : AppColors.lightTextMuted),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Color _getCellColor(
    JournalEntry? entry,
    bool isToday,
    bool isFuture,
    bool isDark,
  ) {
    if (isFuture) {
      return isDark
          ? Colors.white.withValues(alpha: 0.02)
          : Colors.black.withValues(alpha: 0.02);
    }
    if (entry == null) {
      return isDark
          ? Colors.white.withValues(alpha: 0.04)
          : Colors.black.withValues(alpha: 0.04);
    }

    // Color intensity based on overall rating (1-5)
    final rating = entry.overallRating;
    switch (rating) {
      case 1:
        return AppColors.auroraStart.withValues(alpha: 0.3);
      case 2:
        return AppColors.auroraStart.withValues(alpha: 0.45);
      case 3:
        return AppColors.auroraStart.withValues(alpha: 0.6);
      case 4:
        return AppColors.auroraStart.withValues(alpha: 0.8);
      case 5:
        return AppColors.auroraStart;
      default:
        return AppColors.auroraStart.withValues(alpha: 0.5);
    }
  }

  int _weekCount(int startWeekday, int daysInMonth) {
    return ((startWeekday - 1 + daysInMonth) / 7).ceil();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LEGEND
// ═══════════════════════════════════════════════════════════════════════════

class _Legend extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _Legend({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isEn ? 'Less' : 'Az',
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
        const SizedBox(width: 6),
        ...[0.3, 0.45, 0.6, 0.8, 1.0].map((alpha) {
          return Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: AppColors.auroraStart.withValues(alpha: alpha),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
        const SizedBox(width: 6),
        Text(
          isEn ? 'More' : 'Çok',
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DAY DETAIL (shown when a day is tapped)
// ═══════════════════════════════════════════════════════════════════════════

class _DayDetail extends StatelessWidget {
  final String dateKey;
  final JournalEntry? entry;
  final bool isDark;
  final bool isEn;
  final ValueChanged<String> onViewEntry;
  final VoidCallback onCreateEntry;

  const _DayDetail({
    required this.dateKey,
    this.entry,
    required this.isDark,
    required this.isEn,
    required this.onViewEntry,
    required this.onCreateEntry,
  });

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.8)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Text(
              dateKey,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEn ? 'No entry for this day' : 'Bu gün için kayıt yok',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              label: isEn ? 'Log this day' : 'Bu günü kaydet',
              button: true,
              child: GestureDetector(
              onTap: onCreateEntry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isEn ? 'Log this day' : 'Bu günü kaydet',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.auroraStart,
                  ),
                ),
              ),
            ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 200.ms);
    }

    final e = entry!;
    final ratingLabels = isEn
        ? ['Low', 'Below Avg', 'Average', 'Good', 'Excellent']
        : ['Düşük', 'Ortanın Altı', 'Orta', 'İyi', 'Mükemmel'];

    return Semantics(
      label: isEn
          ? 'View entry: ${e.focusArea.displayNameEn}, rating ${e.overallRating}'
          : 'Kaydı gör: ${e.focusArea.displayNameTr}, puan ${e.overallRating}',
      button: true,
      child: GestureDetector(
      onTap: () => onViewEntry(e.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.8)
              : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.auroraStart.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.starGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dateKey,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starGold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isEn
                      ? e.focusArea.displayNameEn
                      : e.focusArea.displayNameTr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _ratingColor(e.overallRating)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ratingLabels[(e.overallRating - 1).clamp(0, ratingLabels.length - 1)],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _ratingColor(e.overallRating),
                    ),
                  ),
                ),
              ],
            ),
            if (e.note case final note? when note.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                note.length > 120
                    ? '${note.substring(0, 120)}...'
                    : note,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  isEn ? 'View entry' : 'Kaydı görüntüle',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.auroraStart,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.auroraStart,
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Color _ratingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red.shade400;
      case 2:
        return Colors.orange.shade400;
      case 3:
        return AppColors.starGold;
      case 4:
        return Colors.lightGreen.shade400;
      case 5:
        return AppColors.success;
      default:
        return AppColors.starGold;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// YEAR HEATMAP (mini GitHub-style grid)
// ═══════════════════════════════════════════════════════════════════════════

class _YearHeatmap extends StatelessWidget {
  final int year;
  final Map<String, JournalEntry> entryMap;
  final bool isDark;
  final bool isEn;

  const _YearHeatmap({
    required this.year,
    required this.entryMap,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final endDate = DateTime.now().isBefore(DateTime(year, 12, 31))
        ? DateTime.now()
        : DateTime(year, 12, 31);

    // Count entries per month for the year
    final monthCounts = List.filled(12, 0);
    for (final entry in entryMap.entries) {
      final parts = entry.key.split('-');
      if (parts.length == 3 && (int.tryParse(parts[0]) ?? 0) == year) {
        final m = int.tryParse(parts[1]) ?? 0;
        if (m >= 1 && m <= 12) {
          monthCounts[m - 1]++;
        }
      }
    }

    final maxCount = monthCounts.reduce((a, b) => a > b ? a : b);

    final monthLabels = isEn
        ? ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D']
        : ['O', 'Ş', 'M', 'N', 'M', 'H', 'T', 'A', 'E', 'E', 'K', 'A'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.8)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$year ${isEn ? 'Overview' : 'Genel Bakış'}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(12, (i) {
              final alpha = maxCount > 0
                  ? (monthCounts[i] / maxCount).clamp(0.1, 1.0)
                  : 0.05;
              final isFutureMonth = DateTime(year, i + 1, 1).isAfter(endDate);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: isFutureMonth
                              ? (isDark
                                  ? Colors.white.withValues(alpha: 0.02)
                                  : Colors.black.withValues(alpha: 0.02))
                              : monthCounts[i] > 0
                                  ? AppColors.auroraStart
                                      .withValues(alpha: alpha)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.04)
                                      : Colors.black
                                          .withValues(alpha: 0.04)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: monthCounts[i] > 0
                            ? Center(
                                child: Text(
                                  '${monthCounts[i]}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: alpha > 0.5
                                        ? Colors.white
                                        : (isDark
                                            ? AppColors.textMuted
                                            : AppColors.lightTextMuted),
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        monthLabels[i],
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
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }
}
