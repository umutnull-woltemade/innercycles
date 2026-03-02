import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';

/// Subtle year progress visualization showing how far through the year
/// the user is + their journaling consistency rate.
class YearProgressRing extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const YearProgressRing({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final entryCount = service.entryCount;
        if (entryCount < 3) return const SizedBox.shrink();

        final now = DateTime.now();
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfYear = DateTime(now.year, 12, 31);
        final totalDays =
            endOfYear.difference(startOfYear).inDays + 1;
        final daysPassed = now.difference(startOfYear).inDays + 1;
        final yearProgress = daysPassed / totalDays;

        // Count entries this year
        final entries = service.getAllEntries();
        final thisYearEntries = entries
            .where((e) => e.date.year == now.year)
            .length;
        final consistency = thisYearEntries / daysPassed;
        final consistencyPercent = (consistency * 100).round();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cosmicPurple.withValues(alpha: 0.3)
                  : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // Year progress ring
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomPaint(
                    painter: _DualRingPainter(
                      yearProgress: yearProgress,
                      consistency: consistency.clamp(0.0, 1.0),
                      isDark: isDark,
                    ),
                    child: Center(
                      child: Text(
                        '${now.year}',
                        style: AppTypography.elegantAccent(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn
                            ? '${(yearProgress * 100).round()}% of ${now.year} · $thisYearEntries entries'
                            : '${now.year}\'ın %${(yearProgress * 100).round()}\'ı · $thisYearEntries kayıt',
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn
                            ? '$consistencyPercent% consistency'
                            : '%$consistencyPercent tutarlılık',
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: consistency >= 0.5
                              ? AppColors.success
                              : AppColors.celestialGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
        );
      },
    );
  }
}

class _DualRingPainter extends CustomPainter {
  final double yearProgress;
  final double consistency;
  final bool isDark;

  _DualRingPainter({
    required this.yearProgress,
    required this.consistency,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 2;
    final innerRadius = outerRadius - 5;

    // Background tracks
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      -math.pi / 2,
      2 * math.pi,
      false,
      trackPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      -math.pi / 2,
      2 * math.pi,
      false,
      trackPaint,
    );

    // Year progress (outer ring - gold)
    final yearPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = AppColors.starGold;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      -math.pi / 2,
      2 * math.pi * yearProgress,
      false,
      yearPaint,
    );

    // Consistency (inner ring - green/amber)
    final consistencyPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = consistency >= 0.5 ? AppColors.success : AppColors.celestialGold;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      -math.pi / 2,
      2 * math.pi * consistency,
      false,
      consistencyPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DualRingPainter oldDelegate) =>
      oldDelegate.yearProgress != yearProgress ||
      oldDelegate.consistency != consistency;
}
