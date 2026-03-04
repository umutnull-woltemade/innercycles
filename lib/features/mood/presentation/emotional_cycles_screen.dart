// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL CYCLES SCREEN - Mood pattern analysis over time
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/signal_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/mood_checkin_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class EmotionalCyclesScreen extends ConsumerWidget {
  const EmotionalCyclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodAsync = ref.watch(moodCheckinServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: moodAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Something went wrong', style: TextStyle(color: Color(0xFF9E8E82)))),
            data: (service) {
              final entries = service.getAllEntries();
              final weekPattern = _computeWeekPattern(entries);
              final hourPattern = _computeHourPattern(entries);
              final monthPattern = _computeMonthPattern(entries);
              final quadrantShifts = _computeQuadrantShifts(entries);

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Emotional Cycles' : 'Duygusal Döngüler',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Discover your emotional rhythms'
                                : 'Duygusal ritimlerini keşfet',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (entries.length < 7)
                            _InsufficientData(isEn: isEn, isDark: isDark)
                          else ...[
                            // Weekly rhythm
                            GradientText(
                              isEn ? 'Weekly Rhythm' : 'Haftalık Ritim',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _WeeklyRhythm(
                              pattern: weekPattern,
                              isEn: isEn,
                              isDark: isDark,
                            ).animate().fadeIn(duration: 400.ms),

                            const SizedBox(height: 24),

                            // Time of day
                            GradientText(
                              isEn
                                  ? 'Time-of-Day Pattern'
                                  : 'Gün İçi Düzen',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _TimeOfDayPattern(
                              pattern: hourPattern,
                              isEn: isEn,
                              isDark: isDark,
                            ),

                            const SizedBox(height: 24),

                            // Monthly trend
                            if (monthPattern.length >= 2) ...[
                              GradientText(
                                isEn
                                    ? 'Monthly Trend'
                                    : 'Aylık Trend',
                                variant: GradientTextVariant.amethyst,
                                style: AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _MonthlyTrend(
                                pattern: monthPattern,
                                isEn: isEn,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Quadrant shifts
                            if (quadrantShifts.isNotEmpty) ...[
                              GradientText(
                                isEn
                                    ? 'Emotional Shifts'
                                    : 'Duygusal Geçişler',
                                variant: GradientTextVariant.cosmic,
                                style: AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...quadrantShifts
                                  .take(5)
                                  .map((shift) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: _ShiftTile(
                                          shift: shift,
                                          isEn: isEn,
                                          isDark: isDark,
                                        ),
                                      )),
                            ],
                          ],

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Average mood per day of week (Mon=1..Sun=7)
  Map<int, double> _computeWeekPattern(List<MoodEntry> entries) {
    final sums = <int, int>{};
    final counts = <int, int>{};
    for (final e in entries) {
      final dow = e.date.weekday;
      sums[dow] = (sums[dow] ?? 0) + e.mood;
      counts[dow] = (counts[dow] ?? 0) + 1;
    }
    return {
      for (int d = 1; d <= 7; d++)
        d: counts.containsKey(d) ? sums[d]! / counts[d]! : 0.0,
    };
  }

  /// Average mood by time period
  Map<String, double> _computeHourPattern(List<MoodEntry> entries) {
    final periods = {'morning': <int>[], 'afternoon': <int>[], 'evening': <int>[], 'night': <int>[]};
    for (final e in entries) {
      final h = e.loggedHour;
      if (h >= 5 && h < 12) {
        periods['morning']!.add(e.mood);
      } else if (h >= 12 && h < 17) {
        periods['afternoon']!.add(e.mood);
      } else if (h >= 17 && h < 21) {
        periods['evening']!.add(e.mood);
      } else {
        periods['night']!.add(e.mood);
      }
    }
    return {
      for (final entry in periods.entries)
        entry.key: entry.value.isEmpty
            ? 0.0
            : entry.value.reduce((a, b) => a + b) / entry.value.length,
    };
  }

  /// Average mood per month
  List<(String, double)> _computeMonthPattern(List<MoodEntry> entries) {
    final months = <String, List<int>>{};
    for (final e in entries) {
      final key =
          '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}';
      (months[key] ??= []).add(e.mood);
    }
    final sorted = months.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sorted
        .map((e) => (e.key, e.value.reduce((a, b) => a + b) / e.value.length))
        .toList();
  }

  /// Detect quadrant shifts (consecutive days with different quadrants)
  List<_QuadrantShift> _computeQuadrantShifts(List<MoodEntry> entries) {
    final withQuadrant =
        entries.where((e) => e.quadrant != null).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    final shifts = <_QuadrantShift>[];
    for (int i = 0; i < withQuadrant.length - 1; i++) {
      if (withQuadrant[i].quadrant != withQuadrant[i + 1].quadrant) {
        shifts.add(_QuadrantShift(
          date: withQuadrant[i].date,
          from: withQuadrant[i + 1].quadrant!,
          to: withQuadrant[i].quadrant!,
        ));
      }
    }
    return shifts;
  }
}

class _WeeklyRhythm extends StatelessWidget {
  final Map<int, double> pattern;
  final bool isEn;
  final bool isDark;

  const _WeeklyRhythm({
    required this.pattern,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dayLabelsEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayLabelsTr = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final labels = isEn ? dayLabelsEn : dayLabelsTr;

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final day = i + 1;
          final avg = pattern[day] ?? 0.0;
          final height = avg > 0 ? (avg / 5.0 * 80).clamp(10.0, 80.0) : 10.0;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (avg > 0)
                    Text(
                      avg.toStringAsFixed(1),
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: AppColors.starGold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.starGold.withValues(alpha: 0.7),
                          AppColors.starGold.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[i],
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
    );
  }
}

class _TimeOfDayPattern extends StatelessWidget {
  final Map<String, double> pattern;
  final bool isEn;
  final bool isDark;

  const _TimeOfDayPattern({
    required this.pattern,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final periods = [
      ('morning', isEn ? 'Morning' : 'Sabah', '\u{2600}\u{FE0F}'),
      ('afternoon', isEn ? 'Afternoon' : 'Öğleden Sonra', '\u{1F324}\u{FE0F}'),
      ('evening', isEn ? 'Evening' : 'Akşam', '\u{1F305}'),
      ('night', isEn ? 'Night' : 'Gece', '\u{1F319}'),
    ];

    return Row(
      children: periods.map((p) {
        final avg = pattern[p.$1] ?? 0;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(p.$3, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                Text(
                  avg > 0 ? avg.toStringAsFixed(1) : '—',
                  style: AppTypography.modernAccent(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _moodColor(avg),
                  ),
                ),
                Text(
                  p.$2,
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
      }).toList(),
    );
  }

  Color _moodColor(double avg) {
    if (avg >= 4) return AppColors.success;
    if (avg >= 3) return AppColors.starGold;
    if (avg >= 2) return AppColors.warning;
    return AppColors.amethyst;
  }
}

class _MonthlyTrend extends StatelessWidget {
  final List<(String, double)> pattern;
  final bool isEn;
  final bool isDark;

  const _MonthlyTrend({
    required this.pattern,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: CustomPaint(
        painter: _MonthTrendPainter(
          data: pattern,
          isDark: isDark,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _MonthTrendPainter extends CustomPainter {
  final List<(String, double)> data;
  final bool isDark;

  _MonthTrendPainter({required this.data, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final linePaint = Paint()
      ..color = AppColors.amethyst
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppColors.amethyst.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = AppColors.amethyst
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = data.length == 1
          ? size.width / 2
          : i / (data.length - 1) * size.width;
      final y = size.height - ((data[i].$2 - 1) / 4.0 * (size.height - 20) + 10);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, dotPaint);

      // Label
      final tp = TextPainter(
        text: TextSpan(
          text: data[i].$1.substring(5), // "01", "02" etc
          style: TextStyle(
            fontSize: 9,
            color: (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - tp.height));
    }

    fillPath.lineTo(
        data.length == 1 ? size.width / 2 : size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _QuadrantShift {
  final DateTime date;
  final String from;
  final String to;

  const _QuadrantShift({
    required this.date,
    required this.from,
    required this.to,
  });
}

class _ShiftTile extends StatelessWidget {
  final _QuadrantShift shift;
  final bool isEn;
  final bool isDark;

  const _ShiftTile({
    required this.shift,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fromQ = SignalQuadrant.values
        .where((q) => q.name == shift.from)
        .firstOrNull;
    final toQ = SignalQuadrant.values
        .where((q) => q.name == shift.to)
        .firstOrNull;

    if (fromQ == null || toQ == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            '${shift.date.day}/${shift.date.month}',
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: fromQ.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(fromQ.emoji, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  fromQ.localizedName(isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: fromQ.color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: toQ.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(toQ.emoji, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  toQ.localizedName(isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: toQ.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsufficientData extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _InsufficientData({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('\u{1F30A}', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 12),
            Text(
              isEn
                  ? 'Keep logging your mood daily to reveal patterns'
                  : 'Kalıpları ortaya çıkarmak için ruh halini günlük kaydetmeye devam et',
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEn
                  ? 'At least 7 entries needed'
                  : 'En az 7 giriş gerekli',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
