import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/tap_scale.dart';

class SeasonalProgressRing extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const SeasonalProgressRing({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(seasonalReflectionServiceProvider);

    return serviceAsync.maybeWhen(
      data: (service) {
        final module = service.getCurrentModule();
        final progress = service.getCurrentProgress();
        final pct = service.getCompletionPercent();
        final completed = progress.completedPrompts.length;
        final total = module.prompts.length;
        final language = AppLanguage.fromIsEn(isEn);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: TapScale(
            onTap: () {
              HapticService.selectionTap();
              context.push(Routes.seasonal);
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.3)
                    : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
              ),
              child: Row(
                children: [
                  // Mini ring
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: CustomPaint(
                      painter: _SeasonRingPainter(
                        progress: pct,
                        color: AppColors.auroraStart,
                        bgColor: isDark
                            ? AppColors.surfaceDark
                            : AppColors.lightSurfaceVariant,
                      ),
                      child: Center(
                        child: Text(
                          module.emoji,
                          style: const TextStyle(fontSize: 18),
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
                          module.localizedName(language),
                          style: AppTypography.modernAccent(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$completed/$total ${isEn ? 'prompts' : 'yansıma'}',
                          style: AppTypography.subtitle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (pct >= 1.0)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: AppColors.success,
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 360.ms, duration: 300.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _SeasonRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;

  _SeasonRingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    const strokeWidth = 3.5;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SeasonRingPainter old) =>
      old.progress != progress;
}
