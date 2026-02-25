import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Themed loading indicator matching the cosmic design system.
/// Replaces bare CircularProgressIndicator across all screens.
///
/// Features a gradient-stroked ring with a soft glow backdrop and
/// optional pulsing message text.
class CosmicLoadingIndicator extends StatefulWidget {
  final double size;
  final String? message;

  const CosmicLoadingIndicator({super.key, this.size = 32, this.message});

  @override
  State<CosmicLoadingIndicator> createState() => _CosmicLoadingIndicatorState();
}

class _CosmicLoadingIndicatorState extends State<CosmicLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    if (disableAnimations) {
      return _buildStatic(isDark);
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: widget.size + 16,
            height: widget.size + 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft glow backdrop
                Container(
                  width: widget.size + 8,
                  height: widget.size + 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isDark
                                    ? AppColors.starGold
                                    : AppColors.lightStarGold)
                                .withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
                // Gradient spinning ring
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: _GradientRingPainter(
                        progress: _controller.value,
                        isDark: isDark,
                        strokeWidth: widget.size < 24 ? 2.0 : 2.5,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.message!,
              style: AppTypography.decorativeScript(
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  Widget _buildStatic(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              strokeWidth: widget.size < 24 ? 2.0 : 2.5,
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.message!,
              style: AppTypography.decorativeScript(
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Paints a gradient arc that rotates, creating an orbital spinner effect.
class _GradientRingPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final double strokeWidth;

  const _GradientRingPainter({
    required this.progress,
    required this.isDark,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide / 2) - strokeWidth;

    final sweepAngle = pi * 1.2; // ~216 degrees arc
    final startAngle = progress * 2 * pi;

    // Gradient colors: gold → aurora
    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: isDark
          ? [
              AppColors.starGold.withValues(alpha: 0.0),
              AppColors.starGold,
              AppColors.auroraStart,
            ]
          : [
              AppColors.lightStarGold.withValues(alpha: 0.0),
              AppColors.lightStarGold,
              AppColors.lightAuroraStart,
            ],
      stops: const [0.0, 0.4, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.isDark != isDark ||
      oldDelegate.strokeWidth != strokeWidth;
}
