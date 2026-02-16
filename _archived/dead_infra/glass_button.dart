import 'dart:ui';
import 'package:flutter/material.dart';
import 'glass_tokens.dart';

/// Primary glass button with starGold fill and frosted backdrop.
class GlassPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const GlassPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<GlassPrimaryButton> createState() => _GlassPrimaryButtonState();
}

class _GlassPrimaryButtonState extends State<GlassPrimaryButton>
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
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: GlassTokens.defaultCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: enabled ? (_) => _controller.forward() : null,
      onTapUp: enabled ? (_) => _controller.reverse() : null,
      onTapCancel: enabled ? () => _controller.reverse() : null,
      onTap: enabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(GlassTokens.radiusMd),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: AnimatedContainer(
              duration: GlassTokens.fastDuration,
              padding: const EdgeInsets.symmetric(
                horizontal: GlassTokens.spaceXl,
                vertical: GlassTokens.spaceLg,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: enabled
                      ? [GlassTokens.starGold, GlassTokens.celestialGold]
                      : [Colors.grey.shade600, Colors.grey.shade700],
                ),
                borderRadius: BorderRadius.circular(GlassTokens.radiusMd),
                border: Border.all(
                  color: enabled
                      ? GlassTokens.starGold.withValues(alpha: 0.5)
                      : Colors.grey.withValues(alpha: 0.3),
                  width: 0.33,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black87,
                      ),
                    )
                  else ...[
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 18, color: Colors.black87),
                      const SizedBox(width: GlassTokens.spaceSm),
                    ],
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: GlassTokens.fontBody,
                        fontWeight: GlassTokens.weightSemibold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary glass button with outline style.
class GlassSecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GlassSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  State<GlassSecondaryButton> createState() => _GlassSecondaryButtonState();
}

class _GlassSecondaryButtonState extends State<GlassSecondaryButton>
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
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: GlassTokens.defaultCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GlassTokens.starGold : GlassTokens.amethyst;
    final borderColor = textColor.withValues(alpha: 0.5);

    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onPressed != null ? (_) => _controller.reverse() : null,
      onTapCancel: widget.onPressed != null ? () => _controller.reverse() : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(GlassTokens.radiusMd),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: GlassTokens.spaceXl,
                vertical: GlassTokens.spaceLg,
              ),
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(GlassTokens.radiusMd),
                border: Border.all(color: borderColor, width: 0.33),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 18, color: textColor),
                    const SizedBox(width: GlassTokens.spaceSm),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: GlassTokens.fontBody,
                      fontWeight: GlassTokens.weightSemibold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
