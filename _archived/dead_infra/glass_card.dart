import 'package:flutter/material.dart';
import 'glass_panel.dart';
import 'glass_tokens.dart';

/// Interactive glass card with tap feedback.
///
/// Wraps [GlassPanel] with optional onTap and press-scale animation.
class GlassCard extends StatefulWidget {
  final Widget child;
  final GlassElevation elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? glowColor;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.elevation = GlassElevation.g2,
    this.onTap,
    this.borderRadius,
    this.padding,
    this.margin,
    this.glowColor,
    this.width,
    this.height,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: GlassTokens.fastDuration,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: GlassTokens.defaultCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap != null) _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onTap != null) _controller.reverse();
  }

  void _onTapCancel() {
    if (widget.onTap != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: GlassPanel(
          elevation: widget.elevation,
          borderRadius: widget.borderRadius,
          padding: widget.padding,
          margin: widget.margin,
          glowColor: widget.glowColor,
          width: widget.width,
          height: widget.height,
          child: widget.child,
        ),
      ),
    );
  }
}
