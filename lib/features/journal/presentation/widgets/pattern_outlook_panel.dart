// ════════════════════════════════════════════════════════════════════════════
// PATTERN OUTLOOK PANEL - 7-day forward projection from historical cycles
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../shared/widgets/premium_card.dart';

class PatternOutlookPanel extends StatelessWidget {
  final List<JournalEntry> allEntries;
  final bool isDark;
  final bool isEn;

  const PatternOutlookPanel({
    super.key,
    required this.allEntries,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    if (allEntries.length < 14) return const SizedBox.shrink();

    // Compute day-of-week averages from historical data
    final dowSums = List.filled(7, 0.0);
    final dowCounts = List.filled(7, 0);
    for (final e in allEntries) {
      final dow = e.date.weekday - 1; // 0=Mon, 6=Sun
      dowSums[dow] += e.overallRating;
      dowCounts[dow]++;
    }

    final dowAvgs = List.generate(7, (i) {
      return dowCounts[i] > 0 ? dowSums[i] / dowCounts[i] : 0.0;
    });

    // Project next 7 days
    final now = DateTime.now();
    final projections = List.generate(7, (i) {
      final day = now.add(Duration(days: i + 1));
      final dow = day.weekday - 1;
      return (day, dowAvgs[dow], dowCounts[dow]);
    });

    // Need reasonable data
    final validDays = projections.where((p) => p.$3 >= 2).length;
    if (validDays < 4) return const SizedBox.shrink();

    final dayLabels = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    final best = projections.reduce((a, b) => a.$2 > b.$2 ? a : b);
    final bestLabel = dayLabels[best.$1.weekday - 1];

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph_rounded, size: 16, color: AppColors.auroraStart),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEn ? 'Your Week Ahead' : 'Önündeki Hafta',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 7-bar projection
          Row(
            children: projections.map((p) {
              final (day, avg, count) = p;
              final hasData = count >= 2;
              final barHeight = hasData ? (avg / 5 * 40).clamp(8.0, 40.0) : 8.0;
              final isBest = p == best && hasData;
              final confidence = (count / 10).clamp(0.0, 1.0); // 10+ entries = full confidence

              return Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 44,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 16,
                          height: barHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: hasData
                                ? (isBest
                                    ? AppColors.starGold
                                    : AppColors.auroraStart.withValues(alpha: 0.3 + confidence * 0.4))
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.black.withValues(alpha: 0.04)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasData ? avg.toStringAsFixed(1) : '-',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 10,
                        fontWeight: isBest ? FontWeight.w700 : FontWeight.w500,
                        color: isBest
                            ? AppColors.starGold
                            : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                    Text(
                      dayLabels[day.weekday - 1],
                      style: AppTypography.elegantAccent(
                        fontSize: 9,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Past entries suggest $bestLabel tends to be your strongest day.'
                : 'Geçmiş kayıtların $bestLabel gününün en güçlü günün olduğunu gösteriyor.',
            style: AppTypography.decorativeScript(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }
}
