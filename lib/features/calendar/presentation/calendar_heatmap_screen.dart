// ════════════════════════════════════════════════════════════════════════════
// CALENDAR HEATMAP SCREEN - GitHub-Style Activity Visualization
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/life_event.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/journal_service.dart';
import '../../../data/services/life_event_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/services/l10n_service.dart';

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

  // Cache entryMap so it's not rebuilt on every setState (month nav, day tap)
  JournalService? _lastService;
  Map<String, JournalEntry> _entryMap = const {};
  int _totalEntryCount = 0;

  // Cache lifeEventMap
  LifeEventService? _lastLifeEventService;
  Map<String, List<LifeEvent>> _lifeEventMap = const {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('calendarHeatmap'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData(
            (s) => s.trackToolOpen('calendarHeatmap', source: 'direct'),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalServiceProvider);
    final lifeEventAsync = ref.watch(lifeEventServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
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
                  onPressed: () => ref.invalidate(journalServiceProvider),
                  icon: Icon(Icons.refresh_rounded,
                      size: 16, color: AppColors.starGold),
                  label: Text(
                    L10nService.get('calendar.calendar_heatmap.retry', language),
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
            // Life event service may still be loading — use empty map as fallback
            final lifeEventService = lifeEventAsync.valueOrNull;
            return _buildContent(
              context,
              service,
              lifeEventService,
              isDark,
              isEn,
              isPremium,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    JournalService service,
    LifeEventService? lifeEventService,
    bool isDark,
    bool isEn,
    bool isPremium,
  ) {
    // Cache entryMap — only rebuild when service instance changes
    if (!identical(service, _lastService)) {
      _lastService = service;
      final allEntries = service.getAllEntries();
      _totalEntryCount = allEntries.length;
      final map = <String, JournalEntry>{};
      for (final entry in allEntries) {
        map[entry.dateKey] = entry;
      }
      _entryMap = map;
    }
    final entryMap = _entryMap;

    // Cache lifeEventMap
    if (lifeEventService != null &&
        !identical(lifeEventService, _lastLifeEventService)) {
      _lastLifeEventService = lifeEventService;
      _lifeEventMap = lifeEventService.getEventsMap();
    }
    final lifeEventMap = _lifeEventMap;

    final monthEntries = service.getEntriesForMonth(
      _selectedYear,
      _selectedMonth,
    );

    // Stats
    final totalEntries = _totalEntryCount;
    final monthCount = monthEntries.length;
    final streak = service.getCurrentStreak();

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: L10nService.get('calendar.calendar_heatmap.heatmap_timeline', isEn ? AppLanguage.en : AppLanguage.tr),
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
                    if (!isPremium) {
                      showContextualPaywall(
                        context,
                        ref,
                        paywallContext: PaywallContext.patterns,
                      );
                      return;
                    }
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
                        (_selectedYear == now.year &&
                            _selectedMonth >= now.month)) {
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
                  lifeEventMap: lifeEventMap,
                  selectedDateKey: _selectedDateKey,
                  isDark: isDark,
                  isEn: isEn,
                  onDayTap: (dateKey) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedDateKey = _selectedDateKey == dateKey
                          ? null
                          : dateKey;
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
                    lifeEvents: lifeEventMap[_selectedDateKey] ?? [],
                    isDark: isDark,
                    isEn: isEn,
                    onViewEntry: (id) => context.push(
                      Routes.journalEntryDetail.replaceFirst(':id', id),
                    ),
                    onCreateEntry: () => context.go(Routes.journal),
                    onAddLifeEvent: () => context.push(
                      '${Routes.lifeEventNew}?date=$_selectedDateKey',
                    ),
                    onViewLifeEvent: (id) => context.push(
                      Routes.lifeEventDetail.replaceFirst(':id', id),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Year heatmap (mini) — PREMIUM
                if (isPremium)
                  _YearHeatmap(
                    year: _selectedYear,
                    entryMap: entryMap,
                    isDark: isDark,
                    isEn: isEn,
                  )
                else
                  _PremiumYearOverlay(isDark: isDark, isEn: isEn),

                ContentDisclaimer(
                  language: isEn ? AppLanguage.en : AppLanguage.tr,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
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
          label: L10nService.get('calendar.calendar_heatmap.total', isEn ? AppLanguage.en : AppLanguage.tr),
          value: '$totalEntries',
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatPill(
          label: L10nService.get('calendar.calendar_heatmap.this_month', isEn ? AppLanguage.en : AppLanguage.tr),
          value: '$monthCount',
          isDark: isDark,
        ),
        const SizedBox(width: 10),
        _StatPill(
          label: L10nService.get('calendar.calendar_heatmap.streak', isEn ? AppLanguage.en : AppLanguage.tr),
          value: '$streak',
          isDark: isDark,
          accent: true,
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 80.ms);
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
      child: PremiumCard(
        style: accent ? PremiumCardStyle.gold : PremiumCardStyle.subtle,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        borderRadius: 12,
        showGradientBorder: accent,
        showInnerShadow: false,
        showNoise: false,
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.displayFont.copyWith(
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
              style: AppTypography.elegantAccent(
                fontSize: 11,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                letterSpacing: 1.0,
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

    final now = DateTime.now();
    final isCurrentMonth = year == now.year && month == now.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: L10nService.get('calendar.calendar_heatmap.previous_month', isEn ? AppLanguage.en : AppLanguage.tr),
          icon: Icon(
            Icons.chevron_left_rounded,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
          onPressed: onPrevious,
        ),
        GradientText(
          '${monthNames[month - 1]} $year',
          variant: GradientTextVariant.gold,
          style: AppTypography.displayFont.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          tooltip: L10nService.get('calendar.calendar_heatmap.next_month', isEn ? AppLanguage.en : AppLanguage.tr),
          icon: Icon(
            Icons.chevron_right_rounded,
            color: isCurrentMonth
                ? (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                      .withValues(alpha: 0.3)
                : (isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary),
          ),
          onPressed: isCurrentMonth ? null : onNext,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CALENDAR GRID (with dot indicators)
// ═══════════════════════════════════════════════════════════════════════════

class _CalendarGrid extends StatelessWidget {
  final int year;
  final int month;
  final Map<String, JournalEntry> entryMap;
  final Map<String, List<LifeEvent>> lifeEventMap;
  final String? selectedDateKey;
  final bool isDark;
  final bool isEn;
  final ValueChanged<String> onDayTap;

  const _CalendarGrid({
    required this.year,
    required this.month,
    required this.entryMap,
    required this.lifeEventMap,
    this.selectedDateKey,
    required this.isDark,
    required this.isEn,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday =
        (firstDay.weekday % 7); // 0=Mon in ISO, adjust to Sun start
    final today = DateTime.now();

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Day headers
          Row(
            children:
                (isEn
                        ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                        : ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pa'])
                    .map((d) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: AppTypography.modernAccent(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
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
                    return const Expanded(child: SizedBox(height: 52));
                  }

                  final date = DateTime(year, month, dayIndex);
                  final dateKey =
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  final entry = entryMap[dateKey];
                  final dayLifeEvents = lifeEventMap[dateKey] ?? [];
                  final isToday =
                      date.year == today.year &&
                      date.month == today.month &&
                      date.day == today.day;
                  final isFuture = date.isAfter(today);
                  final isSelected = dateKey == selectedDateKey;

                  // Determine which dot indicators to show
                  final hasJournal = entry != null;
                  final hasPositiveEvent = dayLifeEvents.any(
                    (e) => e.type == LifeEventType.positive,
                  );
                  final hasChallengeEvent = dayLifeEvents.any(
                    (e) =>
                        e.type == LifeEventType.challenging ||
                        e.type == LifeEventType.custom,
                  );

                  return Expanded(
                    child: Semantics(
                      label:
                          '${date.day}/${date.month}'
                          '${hasJournal ? (L10nService.get('calendar.calendar_heatmap._has_entry', isEn ? AppLanguage.en : AppLanguage.tr)) : ''}'
                          '${dayLifeEvents.isNotEmpty ? (L10nService.get('calendar.calendar_heatmap._life_event', isEn ? AppLanguage.en : AppLanguage.tr)) : ''}',
                      button: !isFuture,
                      child: GestureDetector(
                        onTap: isFuture ? null : () => onDayTap(dateKey),
                        child: Container(
                          height: 52,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: _getCellColor(
                              entry,
                              isToday,
                              isFuture,
                              isDark,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.starGold,
                                    width: 2,
                                  )
                                : isToday
                                ? Border.all(
                                    color: AppColors.auroraStart.withValues(
                                      alpha: 0.5,
                                    ),
                                    width: 1.5,
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$dayIndex',
                                style:
                                    AppTypography.subtitle(
                                      fontSize: 13,
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
                                    ).copyWith(
                                      fontWeight: entry != null
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                              ),
                              // Dot indicators row
                              if (!isFuture &&
                                  (hasJournal ||
                                      hasPositiveEvent ||
                                      hasChallengeEvent))
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (hasJournal)
                                        _dot(AppColors.auroraStart),
                                      if (hasPositiveEvent)
                                        _dot(AppColors.starGold),
                                      if (hasChallengeEvent)
                                        _dot(AppColors.amethyst),
                                    ],
                                  ),
                                ),
                            ],
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
    ).animate().fadeIn(duration: 400.ms, delay: 160.ms);
  }

  Widget _dot(Color color) {
    return Container(
      width: 5,
      height: 5,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
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
// LEGEND (with life event dot types)
// ═══════════════════════════════════════════════════════════════════════════

class _Legend extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _Legend({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    final mutedColor = isDark ? AppColors.textMuted : AppColors.lightTextMuted;
    const dotSize = 8.0;

    return Column(
      children: [
        // Rating intensity legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              L10nService.get('calendar.calendar_heatmap.less', isEn ? AppLanguage.en : AppLanguage.tr),
              style: AppTypography.elegantAccent(
                fontSize: 10,
                color: mutedColor,
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
              L10nService.get('calendar.calendar_heatmap.more', isEn ? AppLanguage.en : AppLanguage.tr),
              style: AppTypography.elegantAccent(
                fontSize: 10,
                color: mutedColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Dot indicator legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendDot(
              AppColors.auroraStart,
              L10nService.get('calendar.calendar_heatmap.journal', isEn ? AppLanguage.en : AppLanguage.tr),
              mutedColor,
              dotSize,
            ),
            const SizedBox(width: 14),
            _legendDot(
              AppColors.starGold,
              L10nService.get('calendar.calendar_heatmap.positive', isEn ? AppLanguage.en : AppLanguage.tr),
              mutedColor,
              dotSize,
            ),
            const SizedBox(width: 14),
            _legendDot(
              AppColors.amethyst,
              L10nService.get('calendar.calendar_heatmap.challenging', isEn ? AppLanguage.en : AppLanguage.tr),
              mutedColor,
              dotSize,
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label, Color textColor, double size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.elegantAccent(fontSize: 10, color: textColor),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DAY DETAIL (shown when a day is tapped — now with life events)
// ═══════════════════════════════════════════════════════════════════════════

class _DayDetail extends StatelessWidget {
  final String dateKey;
  final JournalEntry? entry;
  final List<LifeEvent> lifeEvents;
  final bool isDark;
  final bool isEn;
  final ValueChanged<String> onViewEntry;
  final VoidCallback onCreateEntry;
  final VoidCallback onAddLifeEvent;
  final ValueChanged<String> onViewLifeEvent;

  const _DayDetail({
    required this.dateKey,
    this.entry,
    this.lifeEvents = const [],
    required this.isDark,
    required this.isEn,
    required this.onViewEntry,
    required this.onCreateEntry,
    required this.onAddLifeEvent,
    required this.onViewLifeEvent,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      borderRadius: 14,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero date display
          _buildDateHeader(),
          const SizedBox(height: 12),

          // Journal entry section
          if (entry != null) _buildJournalCard(entry!),
          if (entry == null) _buildAddJournalButton(),

          // Life events section
          if (lifeEvents.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...lifeEvents.map(_buildLifeEventCard),
          ],

          // Add Life Event button
          const SizedBox(height: 10),
          _buildAddLifeEventButton(),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms, delay: 240.ms);
  }

  Widget _buildDateHeader() {
    final parts = dateKey.split('-');
    final day = parts.length > 2 ? parts[2] : '';
    final monthYear = parts.length > 1 ? '${parts[1]}/${parts[0]}' : dateKey;

    return Row(
      children: [
        Text(
          day,
          style: AppTypography.displayFont.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          monthYear,
          style: AppTypography.elegantAccent(
            fontSize: 14,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildJournalCard(JournalEntry e) {
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
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.auroraStart.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.auroraStart.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.auroraStart,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    e.focusArea.localizedName(isEn),
                    style: AppTypography.elegantAccent(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _ratingColor(
                        e.overallRating,
                      ).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ratingLabels[(e.overallRating - 1).clamp(
                        0,
                        ratingLabels.length - 1,
                      )],
                      style: AppTypography.modernAccent(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _ratingColor(e.overallRating),
                      ),
                    ),
                  ),
                ],
              ),
              if (e.note case final note? when note.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  note.length > 80 ? '${note.substring(0, 80)}...' : note,
                  style: AppTypography.decorativeScript(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    L10nService.get('calendar.calendar_heatmap.view_entry', isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.subtitle(
                      fontSize: 11,
                      color: AppColors.auroraStart,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: AppColors.auroraStart,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddJournalButton() {
    return GestureDetector(
      onTap: onCreateEntry,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.auroraStart.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.auroraStart.withValues(alpha: 0.15),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 16, color: AppColors.auroraStart),
            const SizedBox(width: 6),
            Text(
              L10nService.get('calendar.calendar_heatmap.log_this_day', isEn ? AppLanguage.en : AppLanguage.tr),
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: AppColors.auroraStart,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifeEventCard(LifeEvent event) {
    final isPositive = event.type == LifeEventType.positive;
    final accentColor = isPositive ? AppColors.starGold : AppColors.amethyst;

    // Resolve emoji from preset if available
    final preset = event.eventKey != null
        ? LifeEventPresets.getByKey(event.eventKey!)
        : null;
    final emoji = preset?.emoji ?? (isPositive ? '\u{2728}' : '\u{1F4AD}');

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: () => onViewLifeEvent(event.id),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: accentColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              AppSymbol(emoji, size: AppSymbolSize.sm),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    if (event.emotionTags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          event.emotionTags.take(3).join(' \u{2022} '),
                          style: AppTypography.elegantAccent(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddLifeEventButton() {
    return GestureDetector(
      onTap: onAddLifeEvent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.starGold.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.starGold.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 16,
              color: AppColors.starGold,
            ),
            const SizedBox(width: 6),
            Text(
              L10nService.get('calendar.calendar_heatmap.add_life_event', isEn ? AppLanguage.en : AppLanguage.tr),
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: AppColors.starGold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _ratingColor(int rating) {
    switch (rating) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
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

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 14,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            '$year ${L10nService.get('calendar.calendar_heatmap.overview', isEn ? AppLanguage.en : AppLanguage.tr)}',
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
                              ? AppColors.auroraStart.withValues(alpha: alpha)
                              : (isDark
                                    ? Colors.white.withValues(alpha: 0.04)
                                    : Colors.black.withValues(alpha: 0.04)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: monthCounts[i] > 0
                            ? Center(
                                child: Text(
                                  '${monthCounts[i]}',
                                  style: AppTypography.modernAccent(
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
                        style: AppTypography.elegantAccent(
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

// ═══════════════════════════════════════════════════════════════════════════
// PREMIUM YEAR OVERLAY — shown to free users in place of year heatmap
// ═══════════════════════════════════════════════════════════════════════════

class _PremiumYearOverlay extends ConsumerWidget {
  final bool isDark;
  final bool isEn;

  const _PremiumYearOverlay({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.calendar_today, size: 32, color: AppColors.starGold),
          const SizedBox(height: 12),
          GradientText(
            L10nService.get('calendar.calendar_heatmap.year_heatmap', isEn ? AppLanguage.en : AppLanguage.tr),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            L10nService.get('calendar.calendar_heatmap.see_your_full_year_at_a_glance_with_pro', isEn ? AppLanguage.en : AppLanguage.tr),
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => showContextualPaywall(
              context,
              ref,
              paywallContext: PaywallContext.patterns,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [AppColors.starGold, AppColors.celestialGold],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.starGold.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                L10nService.get('calendar.calendar_heatmap.upgrade_to_pro', isEn ? AppLanguage.en : AppLanguage.tr),
                style: AppTypography.modernAccent(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepSpace,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
