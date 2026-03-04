// ════════════════════════════════════════════════════════════════════════════
// YEAR HEATMAP CALENDAR - GitHub-style 365-day journal rating grid
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../shared/widgets/premium_card.dart';

class YearHeatmapCalendar extends StatefulWidget {
  final List<JournalEntry> entries;
  final bool isDark;
  final bool isEn;
  final ValueChanged<JournalEntry>? onEntryTapped;

  const YearHeatmapCalendar({
    super.key,
    required this.entries,
    required this.isDark,
    required this.isEn,
    this.onEntryTapped,
  });

  @override
  State<YearHeatmapCalendar> createState() => _YearHeatmapCalendarState();
}

class _YearHeatmapCalendarState extends State<YearHeatmapCalendar> {
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    // Build date→rating map for selected year
    final ratingMap = <String, int>{};
    final entryMap = <String, JournalEntry>{};
    for (final e in widget.entries) {
      if (e.date.year == _year) {
        ratingMap[e.dateKey] = e.overallRating;
        entryMap[e.dateKey] = e;
      }
    }

    final hasEntries = ratingMap.isNotEmpty;

    // Month labels
    final months = widget.isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with year nav
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _year--),
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                  color: widget.isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$_year',
                style: AppTypography.displayFont.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: widget.isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: _year < DateTime.now().year ? () => setState(() => _year++) : null,
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: _year < DateTime.now().year
                      ? (widget.isDark ? AppColors.textMuted : AppColors.lightTextMuted)
                      : Colors.transparent,
                ),
              ),
              const Spacer(),
              Icon(Icons.grid_view_rounded, size: 14, color: AppColors.auroraStart),
              const SizedBox(width: 6),
              Text(
                widget.isEn ? 'Year View' : 'Yıllık Görünüm',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: widget.isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (!hasEntries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  widget.isEn ? 'No entries for $_year' : '$_year yılında kayıt yok',
                  style: AppTypography.elegantAccent(
                    fontSize: 12,
                    color: widget.isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            )
          else ...[
            // 12-month grid
            ...List.generate(12, (monthIdx) {
              final month = monthIdx + 1;
              final daysInMonth = DateUtils.getDaysInMonth(_year, month);
              final firstWeekday = DateTime(_year, month, 1).weekday; // 1=Mon, 7=Sun

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      months[monthIdx],
                      style: AppTypography.elegantAccent(
                        fontSize: 9,
                        color: widget.isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(37, (i) {
                        // 7 weekday columns × ~5 weeks + padding
                        if (i >= daysInMonth + firstWeekday - 1) return const SizedBox(width: 0);
                        final cellWidth = (MediaQuery.sizeOf(context).width - 80 - 37) / 37;
                        if (i < firstWeekday - 1) {
                          return Container(
                            width: cellWidth,
                            height: 8,
                            margin: const EdgeInsets.all(0.5),
                          );
                        }
                        final day = i - firstWeekday + 2;
                        final dateKey = '$_year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
                        final rating = ratingMap[dateKey];
                        final entry = entryMap[dateKey];

                        return GestureDetector(
                          onTap: entry != null && widget.onEntryTapped != null
                              ? () => widget.onEntryTapped!(entry)
                              : null,
                          child: Container(
                            width: cellWidth,
                            height: 8,
                            margin: const EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1.5),
                              color: rating != null
                                  ? _ratingColor(rating)
                                  : (widget.isDark
                                      ? Colors.white.withValues(alpha: 0.04)
                                      : Colors.black.withValues(alpha: 0.03)),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 8),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isEn ? 'Low' : 'Düşük',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: widget.isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(width: 4),
                ...List.generate(5, (i) {
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: _ratingColor(i + 1),
                    ),
                  );
                }),
                const SizedBox(width: 4),
                Text(
                  widget.isEn ? 'High' : 'Yüksek',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: widget.isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Color _ratingColor(int rating) {
    switch (rating) {
      case 1:
        return const Color(0xFF8B6F5E).withValues(alpha: 0.3); // muted brown
      case 2:
        return const Color(0xFFB8946D).withValues(alpha: 0.5); // light brown
      case 3:
        return const Color(0xFFD4A07A).withValues(alpha: 0.6); // aurora
      case 4:
        return AppColors.celestialGold.withValues(alpha: 0.7); // celestial
      case 5:
        return AppColors.starGold; // star gold
      default:
        return Colors.transparent;
    }
  }
}
