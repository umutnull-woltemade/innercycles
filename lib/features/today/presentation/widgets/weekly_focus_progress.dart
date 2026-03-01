import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';

/// Compact weekly focus area completion indicator.
/// Shows which of the 5 focus areas the user has logged this week.
class WeeklyFocusProgress extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const WeeklyFocusProgress({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  static const _areaColors = {
    FocusArea.energy: AppColors.starGold,
    FocusArea.focus: AppColors.chartBlue,
    FocusArea.emotions: AppColors.chartPink,
    FocusArea.decisions: AppColors.chartGreen,
    FocusArea.social: AppColors.chartPurple,
  };

  static const _areaEmojis = {
    FocusArea.energy: '\u26A1',
    FocusArea.focus: '\uD83C\uDFAF',
    FocusArea.emotions: '\uD83D\uDC9C',
    FocusArea.decisions: '\uD83E\uDDED',
    FocusArea.social: '\uD83E\uDD1D',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final language = AppLanguage.fromIsEn(isEn);
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final allEntries = service.getAllEntries();
        final weekEntries = allEntries.where((e) {
          return !e.date.isBefore(DateTime(weekStart.year, weekStart.month, weekStart.day));
        }).toList();

        if (weekEntries.isEmpty) return const SizedBox.shrink();

        final loggedAreas = weekEntries.map((e) => e.focusArea).toSet();
        final total = FocusArea.values.length;
        final logged = loggedAreas.length;

        if (logged == total) return const SizedBox.shrink(); // All done — no need to show

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 4,
          ),
          child: Row(
            children: [
              Flexible(
                flex: 0,
                child: Text(
                  L10nService.get('today.weekly_focus_progress.week', language),
                  style: AppTypography.elegantAccent(
                    fontSize: 12,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ...FocusArea.values.map((area) {
                final isLogged = loggedAreas.contains(area);
                final color = _areaColors[area] ?? AppColors.textMuted;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Tooltip(
                    message: area.localizedName(language),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLogged
                            ? color.withValues(alpha: 0.2)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.04)),
                        border: Border.all(
                          color: isLogged
                              ? color.withValues(alpha: 0.6)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _areaEmojis[area] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: isLogged ? null : (isDark
                                ? AppColors.textMuted.withValues(alpha: 0.4)
                                : AppColors.lightTextMuted.withValues(alpha: 0.4)),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              Text(
                '$logged/$total',
                style: AppTypography.modernAccent(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starGold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
