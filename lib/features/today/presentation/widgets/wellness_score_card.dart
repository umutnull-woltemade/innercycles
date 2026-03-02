import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../data/services/wellness_score_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';

class WellnessScoreCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const WellnessScoreCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = AppLanguage.fromIsEn(isEn);
    final scoreAsync = ref.watch(wellnessScoreProvider);
    final trendAsync = ref.watch(wellnessTrendProvider);

    return scoreAsync.maybeWhen(
      data: (score) {
        if (score == null || score.score == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: TapScale(
              onTap: () {
                HapticService.selectionTap();
                context.push(Routes.journal);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.auroraStart.withValues(alpha: isDark ? 0.06 : 0.04),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 16,
                      color: AppColors.auroraStart.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'Journal regularly to build your wellness score'
                            : 'Sağlık skorun için düzenli günlük tut',
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 300.ms);
        }

        final trend = trendAsync.whenOrNull(data: (t) => t);
        final direction = trend?.direction ?? 'stable';
        final diff = trend != null
            ? trend.currentScore - trend.previousWeekScore
            : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.wellnessDetail);
            },
            child: PremiumCard(
              style: PremiumCardStyle.aurora,
              borderRadius: 20,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Animated ring
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CustomPaint(
                      painter: _WellnessRingPainter(
                        score: score.score,
                        isDark: isDark,
                      ),
                      child: Center(
                        child: Text(
                          '${score.score}',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _scoreColor(score.score),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? 'Wellness Score' : 'Sag\u{0131}k Skoru',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              direction == 'up'
                                  ? Icons.trending_up_rounded
                                  : direction == 'down'
                                      ? Icons.trending_down_rounded
                                      : Icons.trending_flat_rounded,
                              size: 16,
                              color: direction == 'up'
                                  ? AppColors.success
                                  : direction == 'down'
                                      ? AppColors.error
                                      : AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _trendLabel(direction, diff),
                                style: AppTypography.elegantAccent(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Mini breakdown
                        _buildBreakdownRow(score, language),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ],
              ),
            ),
          ),
        ).glassReveal(context: context, delay: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildBreakdownRow(WellnessScore score, AppLanguage language) {
    final breakdown = score.breakdown;
    return Row(
      children: breakdown.map<Widget>((b) {
        final emoji = _categoryEmoji(b.category);
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            '$emoji${b.score.round()}',
            style: AppTypography.elegantAccent(
              fontSize: 10,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _categoryEmoji(String category) {
    switch (category) {
      case 'journal':
        return '\u{1F4DD}';
      case 'gratitude':
        return '\u{1F64F}';
      case 'rituals':
        return '\u{2728}';
      case 'streak':
        return '\u{1F525}';
      case 'sleep':
        return '\u{1F634}';
      default:
        return '';
    }
  }

  String _trendLabel(String direction, int diff) {
    if (direction == 'up') {
      return isEn ? '+$diff from last week' : 'Ge\u{00E7}en haftadan +$diff';
    } else if (direction == 'down') {
      return isEn ? '$diff from last week' : 'Ge\u{00E7}en haftadan $diff';
    }
    return isEn ? 'Stable this week' : 'Bu hafta stabil';
  }

  Color _scoreColor(int score) {
    if (score >= 70) return AppColors.success;
    if (score >= 40) return AppColors.starGold;
    return AppColors.error;
  }
}

class _WellnessRingPainter extends CustomPainter {
  final int score;
  final bool isDark;

  _WellnessRingPainter({required this.score, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final strokeWidth = 5.0;

    // Background ring
    final bgPaint = Paint()
      ..color = (isDark ? AppColors.textMuted : AppColors.lightTextMuted)
          .withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Score ring
    final scoreColor = score >= 70
        ? AppColors.success
        : score >= 40
            ? AppColors.starGold
            : AppColors.error;

    final scorePaint = Paint()
      ..color = scoreColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / 100) * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WellnessRingPainter old) =>
      old.score != score || old.isDark != isDark;
}
