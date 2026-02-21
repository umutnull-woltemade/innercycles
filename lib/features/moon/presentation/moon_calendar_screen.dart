// ════════════════════════════════════════════════════════════════════════════
// MOON PHASE CALENDAR - Monthly Lunar View
// ════════════════════════════════════════════════════════════════════════════
// Calendar showing moon phases for the current month.
// Tap a day for reflection prompt + phase details.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/moon_phase_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';

class MoonCalendarScreen extends ConsumerStatefulWidget {
  const MoonCalendarScreen({super.key});

  @override
  ConsumerState<MoonCalendarScreen> createState() => _MoonCalendarScreenState();
}

class _MoonCalendarScreenState extends ConsumerState<MoonCalendarScreen> {
  late DateTime _currentMonth;
  MoonPhaseData? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('moonCalendar'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData((s) => s.trackToolOpen('moonCalendar', source: 'direct'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final start = _currentMonth;
    final end = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final phases = MoonPhaseService.getPhaseRange(start, end);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(title: isEn ? 'Moon Calendar' : 'Ay Takvimi'),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Month navigator
                      _MonthNavigator(
                        month: _currentMonth,
                        isEn: isEn,
                        isDark: isDark,
                        onPrevious: () => setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month - 1,
                            1,
                          );
                          _selectedDay = null;
                        }),
                        onNext: () => setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month + 1,
                            1,
                          );
                          _selectedDay = null;
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Day headers
                      _DayHeaders(isEn: isEn, isDark: isDark),
                      const SizedBox(height: 8),

                      // Calendar grid
                      _CalendarGrid(
                        phases: phases,
                        month: _currentMonth,
                        selectedDay: _selectedDay,
                        isDark: isDark,
                        onDayTap: (data) => setState(() => _selectedDay = data),
                      ),
                      const SizedBox(height: 20),

                      // Selected day detail
                      if (_selectedDay != null)
                        _DayDetail(
                          data: _selectedDay!,
                          isDark: isDark,
                          isEn: isEn,
                        ),

                      // Today's phase highlight
                      if (_selectedDay == null)
                        _TodayPhase(isDark: isDark, isEn: isEn),

                      ContentDisclaimer(language: language),
                      ToolEcosystemFooter(
                        currentToolId: 'moonCalendar',
                        isEn: isEn,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════

class _MonthNavigator extends StatelessWidget {
  final DateTime month;
  final bool isEn;
  final bool isDark;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthNavigator({
    required this.month,
    required this.isEn,
    required this.isDark,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: isEn ? 'Previous month' : 'Önceki ay',
          onPressed: onPrevious,
          icon: Icon(
            Icons.chevron_left,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          '${monthNames[month.month - 1]} ${month.year}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
        IconButton(
          tooltip: isEn ? 'Next month' : 'Sonraki ay',
          onPressed: onNext,
          icon: Icon(
            Icons.chevron_right,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _DayHeaders extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _DayHeaders({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final days = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Row(
      children: days
          .map(
            (d) => Expanded(
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
            ),
          )
          .toList(),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final List<MoonPhaseData> phases;
  final DateTime month;
  final MoonPhaseData? selectedDay;
  final bool isDark;
  final ValueChanged<MoonPhaseData> onDayTap;

  const _CalendarGrid({
    required this.phases,
    required this.month,
    this.selectedDay,
    required this.isDark,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstWeekday = month.weekday; // 1=Mon
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalCells = ((firstWeekday - 1 + daysInMonth) / 7).ceil() * 7;
    final today = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayOffset = index - (firstWeekday - 1);
        if (dayOffset < 0 || dayOffset >= daysInMonth) {
          return const SizedBox.shrink();
        }

        final dayNum = dayOffset + 1;
        final phaseData = dayOffset < phases.length ? phases[dayOffset] : null;
        final isToday =
            today.year == month.year &&
            today.month == month.month &&
            today.day == dayNum;
        final isSelected =
            selectedDay?.date.day == dayNum &&
            selectedDay?.date.month == month.month;

        return Semantics(
          label:
              '$dayNum${phaseData != null ? ' ${phaseData.phase.emoji}' : ''}',
          button: phaseData != null,
          selected: isSelected,
          child: GestureDetector(
            onTap: phaseData != null ? () => onDayTap(phaseData) : null,
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.moonSilver.withValues(alpha: 0.15)
                    : isToday
                    ? AppColors.starGold.withValues(alpha: 0.1)
                    : null,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(
                        color: AppColors.starGold.withValues(alpha: 0.4),
                      )
                    : isSelected
                    ? Border.all(
                        color: AppColors.moonSilver.withValues(alpha: 0.4),
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$dayNum',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      color: isToday
                          ? AppColors.starGold
                          : (isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary),
                    ),
                  ),
                  if (phaseData != null)
                    Text(
                      phaseData.phase.emoji,
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _DayDetail extends StatelessWidget {
  final MoonPhaseData data;
  final bool isDark;
  final bool isEn;

  const _DayDetail({
    required this.data,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                  AppColors.cosmicPurple.withValues(alpha: 0.8),
                ]
              : [AppColors.lightCard, AppColors.lightSurfaceVariant],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.moonSilver.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(data.phase.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn
                          ? data.phase.displayNameEn()
                          : data.phase.displayNameTr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      '${data.date.day}.${data.date.month}.${data.date.year} — ${(data.illumination * 100).round()}% ${isEn ? 'illuminated' : 'aydınlık'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.moonSilver,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  size: 20,
                  color: AppColors.moonSilver.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isEn
                        ? data.phase.reflectionPromptEn()
                        : data.phase.reflectionPromptTr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
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
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _TodayPhase extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _TodayPhase({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    final today = MoonPhaseService.today();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(today.phase.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Today\'s Moon' : 'Bugünün Ayı',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  '${isEn ? today.phase.displayNameEn() : today.phase.displayNameTr()} — ${(today.illumination * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }
}
