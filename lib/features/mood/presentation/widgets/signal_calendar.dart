// ════════════════════════════════════════════════════════════════════════════
// SIGNAL CALENDAR - Monthly grid showing daily mood signals as colored circles
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/content/signal_content.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/mood_checkin_service.dart';

class SignalCalendar extends StatefulWidget {
  final List<MoodEntry> entries;
  final AppLanguage language;
  final bool isDark;

  const SignalCalendar({
    super.key,
    required this.entries,
    required this.language,
    required this.isDark,
  });

  @override
  State<SignalCalendar> createState() => _SignalCalendarState();
}

class _SignalCalendarState extends State<SignalCalendar> {
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final isEn = widget.language == AppLanguage.en;
    final daysInMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_displayMonth.year, _displayMonth.month, 1).weekday;
    final entryMap = _buildEntryMap();

    final dayLabels = isEn
        ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
        : ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pa'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 20),
              color: widget.isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              onPressed: () => setState(() {
                _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
              }),
            ),
            Text(
              _monthName(_displayMonth, isEn),
              style: AppTypography.displayFont.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: widget.isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, size: 20),
              color: widget.isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              onPressed: (_displayMonth.year < DateTime.now().year) ||
                      (_displayMonth.year == DateTime.now().year && _displayMonth.month < DateTime.now().month)
                  ? () => setState(() {
                        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
                      })
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Day labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayLabels
              .map((d) => SizedBox(
                    width: 36,
                    child: Center(
                      child: Text(
                        d,
                        style: AppTypography.elegantAccent(
                          fontSize: 10,
                          color: widget.isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),
        // Calendar grid
        ...List.generate(6, (week) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dow) {
                final dayNum = week * 7 + dow - (firstWeekday - 2);
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const SizedBox(width: 36, height: 36);
                }
                final key = '${_displayMonth.year}-${_displayMonth.month.toString().padLeft(2, '0')}-${dayNum.toString().padLeft(2, '0')}';
                final entry = entryMap[key];
                return _CalendarDay(
                  day: dayNum,
                  entry: entry,
                  isDark: widget.isDark,
                  isToday: _isToday(dayNum),
                );
              }),
            ),
          );
        }),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Map<String, MoodEntry> _buildEntryMap() {
    final map = <String, MoodEntry>{};
    for (final e in widget.entries) {
      final key = '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}';
      map[key] = e;
    }
    return map;
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return now.year == _displayMonth.year &&
        now.month == _displayMonth.month &&
        now.day == day;
  }

  String _monthName(DateTime date, bool isEn) {
    const enMonths = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    const trMonths = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];
    final months = isEn ? enMonths : trMonths;
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _CalendarDay extends StatelessWidget {
  final int day;
  final MoodEntry? entry;
  final bool isDark;
  final bool isToday;

  const _CalendarDay({
    required this.day,
    this.entry,
    required this.isDark,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      // Empty day — faint dot
      return SizedBox(
        width: 36,
        height: 36,
        child: Center(
          child: Container(
            width: isToday ? 28 : 6,
            height: isToday ? 28 : 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday
                  ? AppColors.starGold.withValues(alpha: 0.1)
                  : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
              border: isToday
                  ? Border.all(color: AppColors.starGold.withValues(alpha: 0.3), width: 1)
                  : null,
            ),
            child: isToday
                ? Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      );
    }

    // Day with mood entry — colored circle
    final color = (entry!.hasSignal && entry!.signalId != null)
        ? getSignalColor(entry!.signalId!)
        : _moodColor(entry!.mood);

    return SizedBox(
      width: 36,
      height: 36,
      child: Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.8),
                color.withValues(alpha: 0.4),
              ],
            ),
            border: isToday
                ? Border.all(color: AppColors.starGold, width: 1.5)
                : null,
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _moodColor(int mood) {
    switch (mood) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.auroraStart;
      case 4:
        return AppColors.success;
      case 5:
        return AppColors.starGold;
      default:
        return AppColors.textMuted;
    }
  }
}
