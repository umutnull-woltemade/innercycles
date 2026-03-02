// ════════════════════════════════════════════════════════════════════════════
// SIGNAL ORB - Animated gradient circle for mood signals
// ════════════════════════════════════════════════════════════════════════════
// Radial gradient orb with breathing/pulsing animation.
// Pulse speed reflects energy level: Fire/Storm = fast, Water/Shadow = slow.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/content/signal_content.dart';

/// Size tiers for [SignalOrb], matching AppSymbol conventions.
enum SignalOrbSize {
  inline(24),
  card(48),
  hero(80);

  final double diameter;
  const SignalOrbSize(this.diameter);
}

class SignalOrb extends StatefulWidget {
  final String? signalId;
  final List<Color>? colorsOverride;
  final SignalOrbSize size;
  final int? pulseSpeedMsOverride;
  final bool animate;

  const SignalOrb({
    super.key,
    this.signalId,
    this.colorsOverride,
    this.size = SignalOrbSize.card,
    this.pulseSpeedMsOverride,
    this.animate = true,
  });

  /// 24px — for chips, inline labels, week trail dots.
  const SignalOrb.inline({
    super.key,
    this.signalId,
    this.colorsOverride,
    this.pulseSpeedMsOverride,
    this.animate = true,
  }) : size = SignalOrbSize.inline;

  /// 48px — for card-level display, selection grids.
  const SignalOrb.card({
    super.key,
    this.signalId,
    this.colorsOverride,
    this.pulseSpeedMsOverride,
    this.animate = true,
  }) : size = SignalOrbSize.card;

  /// 80px — for hero display, detail screens.
  const SignalOrb.hero({
    super.key,
    this.signalId,
    this.colorsOverride,
    this.pulseSpeedMsOverride,
    this.animate = true,
  }) : size = SignalOrbSize.hero;

  @override
  State<SignalOrb> createState() => _SignalOrbState();
}

class _SignalOrbState extends State<SignalOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  MoodSignal? get _signal =>
      widget.signalId != null ? getSignalById(widget.signalId!) : null;

  List<Color> get _colors =>
      widget.colorsOverride ??
      _signal?.orbGradientColors ??
      [Colors.grey.shade600, Colors.grey.shade800];

  int get _pulseMs =>
      widget.pulseSpeedMsOverride ?? _signal?.pulseSpeedMs ?? 2000;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _pulseMs),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SignalOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.signalId != widget.signalId ||
        oldWidget.pulseSpeedMsOverride != widget.pulseSpeedMsOverride) {
      _controller.duration = Duration(milliseconds: _pulseMs);
    }
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.size.diameter;
    final showGlow = widget.size != SignalOrbSize.inline;

    Widget orb = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = widget.animate ? _scaleAnimation.value : 1.0;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.2, -0.2),
                radius: 0.9,
                colors: [
                  _colors.first,
                  _colors.last,
                ],
                stops: const [0.0, 1.0],
              ),
              boxShadow: showGlow
                  ? [
                      BoxShadow(
                        color: _colors.first.withValues(alpha: 0.2),
                        blurRadius: d * 0.4,
                        spreadRadius: d * 0.05,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      },
    );

    // Entry animation on first appearance
    if (widget.animate) {
      orb = orb
          .animate()
          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
          .scale(
            begin: const Offset(0.6, 0.6),
            end: const Offset(1.0, 1.0),
            duration: 500.ms,
            curve: Curves.easeOutBack,
          );
    }

    return SizedBox(width: d, height: d, child: orb);
  }
}
