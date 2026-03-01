// ════════════════════════════════════════════════════════════════════════════
// PHASE RING - Emotional Phase Visualizer
// ════════════════════════════════════════════════════════════════════════════
// Subtle animated ring showing the current emotional phase.
// Uses system spring animation, respects Reduce Motion,
// SF-based text hierarchy. HIG-compliant.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/services/emotional_cycle_service.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

class PhaseRing extends StatefulWidget {
  final EmotionalPhase phase;
  final EmotionalArc? arc;
  final bool isDark;
  final bool isEn;
  final double size;

  const PhaseRing({
    super.key,
    required this.phase,
    this.arc,
    required this.isDark,
    required this.isEn,
    this.size = 180,
  });

  @override
  State<PhaseRing> createState() => _PhaseRingState();
}

class _PhaseRingState extends State<PhaseRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _progressAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // System spring feel
    );
    _glowAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Check Reduce Motion preference
        final reduceMotion = MediaQuery.of(context).disableAnimations;
        if (reduceMotion) {
          _controller.value = 1.0;
        } else {
          _controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phaseColor = _phaseColor(widget.phase);
    final phaseProgress = _phaseProgress(widget.phase);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              Semantics(
                label: L10nService.get('journal.phase_ring.emotional_phase_ring', widget.isEn ? AppLanguage.en : AppLanguage.tr),
                image: true,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _PhaseRingPainter(
                    progress: _progressAnimation.value * phaseProgress,
                    color: phaseColor,
                    glowIntensity: _glowAnimation.value,
                    isDark: widget.isDark,
                    segments: 5, // 5 phases
                    activeSegment: widget.phase.index,
                  ),
                ),
              ),

              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phase icon
                  Icon(_phaseIcon(widget.phase), size: 28, color: phaseColor),
                  const SizedBox(height: 6),
                  // Phase label
                  Text(
                    widget.phase.label(widget.isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: widget.isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  // Arc label if present
                  if (widget.arc != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.arc!.label(widget.isEn ? AppLanguage.en : AppLanguage.tr),
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        color: phaseColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _phaseColor(EmotionalPhase phase) {
    switch (phase) {
      case EmotionalPhase.expansion:
        return AppColors.success;
      case EmotionalPhase.stabilization:
        return AppColors.auroraStart;
      case EmotionalPhase.contraction:
        return AppColors.warning;
      case EmotionalPhase.reflection:
        return AppColors.amethyst;
      case EmotionalPhase.recovery:
        return AppColors.celestialGold;
    }
  }

  double _phaseProgress(EmotionalPhase phase) {
    // Each phase fills its segment (1/5 of the ring) plus
    // the completed segments before it
    return (phase.index + 1) / 5;
  }

  IconData _phaseIcon(EmotionalPhase phase) {
    switch (phase) {
      case EmotionalPhase.expansion:
        return Icons.open_in_full;
      case EmotionalPhase.stabilization:
        return Icons.balance;
      case EmotionalPhase.contraction:
        return Icons.compress;
      case EmotionalPhase.reflection:
        return Icons.auto_awesome;
      case EmotionalPhase.recovery:
        return Icons.spa_outlined;
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PHASE RING PAINTER
// ════════════════════════════════════════════════════════════════════════════

class _PhaseRingPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final Color color;
  final double glowIntensity; // 0.0 - 1.0
  final bool isDark;
  final int segments;
  final int activeSegment;

  _PhaseRingPainter({
    required this.progress,
    required this.color,
    required this.glowIntensity,
    required this.isDark,
    required this.segments,
    required this.activeSegment,
  });

  static const _phaseColors = [
    AppColors.success, // expansion
    AppColors.auroraStart, // stabilization
    AppColors.warning, // contraction
    AppColors.amethyst, // reflection
    AppColors.celestialGold, // recovery
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 12;
    const strokeWidth = 6.0;
    const gapAngle = 0.08; // Gap between segments in radians
    final segmentAngle = (2 * math.pi - segments * gapAngle) / segments;
    const startAngle = -math.pi / 2; // Start from top

    // Draw background ring (all segments, dim)
    for (int i = 0; i < segments; i++) {
      final segStart = startAngle + i * (segmentAngle + gapAngle);
      final segColor = _phaseColors[i % _phaseColors.length];

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        segStart,
        segmentAngle,
        false,
        Paint()
          ..color = segColor.withValues(alpha: isDark ? 0.12 : 0.08)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    // Draw active segments (animated fill)
    final totalActiveAngle = progress * (2 * math.pi);
    double drawnAngle = 0;

    for (int i = 0; i < segments && drawnAngle < totalActiveAngle; i++) {
      final segStart = startAngle + i * (segmentAngle + gapAngle);
      final segColor = _phaseColors[i % _phaseColors.length];
      final remainingAngle = totalActiveAngle - drawnAngle;
      final drawAngle = math.min(segmentAngle, remainingAngle);

      // Glow effect for active segment
      if (i == activeSegment && glowIntensity > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          segStart,
          drawAngle,
          false,
          Paint()
            ..color = segColor.withValues(alpha: 0.25 * glowIntensity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth + 6
            ..strokeCap = StrokeCap.round
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * glowIntensity),
        );
      }

      // Active segment fill
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        segStart,
        drawAngle,
        false,
        Paint()
          ..color = segColor.withValues(alpha: i == activeSegment ? 1.0 : 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );

      drawnAngle += segmentAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _PhaseRingPainter old) {
    return old.progress != progress ||
        old.color != color ||
        old.glowIntensity != glowIntensity ||
        old.activeSegment != activeSegment;
  }
}
