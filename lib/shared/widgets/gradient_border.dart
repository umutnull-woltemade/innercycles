import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// CustomPainter that draws a rounded rectangle stroke with a gradient shader.
class GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  final double borderRadius;

  const GradientBorderPainter({
    required this.gradient,
    this.strokeWidth = 1.0,
    this.borderRadius = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(borderRadius),
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.borderRadius != borderRadius;
}

/// A container widget that renders a gradient stroke border around its child.
///
/// Uses [GradientBorderPainter] to draw the gradient border, with the child
/// clipped to the border radius.
class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double strokeWidth;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GradientBorderContainer({
    super.key,
    required this.child,
    this.gradient,
    this.strokeWidth = 1.0,
    this.borderRadius = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? AppColors.primaryGradient;

    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: effectiveGradient,
        strokeWidth: strokeWidth,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
  }
}
