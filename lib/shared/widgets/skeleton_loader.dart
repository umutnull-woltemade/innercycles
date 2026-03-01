import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/liquid_glass/glass_tokens.dart';

/// Shimmer skeleton placeholder matching the warm palette.
///
/// Replaces `CosmicLoadingIndicator()` in async `.when(loading:)` calls
/// for a more polished loading experience.
///
/// Usage:
///   SkeletonLoader.journalCard()
///   SkeletonLoader.paragraph(lines: 3)
///   SkeletonLoader.cardList(count: 4)
///   SkeletonLoader.profileRow()
class SkeletonLoader extends StatelessWidget {
  final SkeletonShape shape;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final int index;

  const SkeletonLoader({
    super.key,
    this.shape = SkeletonShape.card,
    this.width,
    this.height,
    this.borderRadius,
    this.index = 0,
  });

  /// Full-width card skeleton (journal/dream/note card shape).
  factory SkeletonLoader.journalCard({int index = 0}) => SkeletonLoader(
        shape: SkeletonShape.card,
        height: 96,
        index: index,
      );

  /// Multiple text lines skeleton.
  static Widget paragraph({int lines = 3, int startIndex = 0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (i) {
        final isLast = i == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
          child: SkeletonLoader(
            shape: SkeletonShape.textLine,
            width: isLast ? 0.6 : (i.isEven ? 1.0 : 0.85),
            height: 14,
            index: startIndex + i,
          ),
        );
      }),
    );
  }

  /// List of card skeletons.
  static Widget cardList({int count = 4}) {
    return Column(
      children: List.generate(count, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SkeletonLoader.journalCard(index: i),
        );
      }),
    );
  }

  /// Profile row skeleton (circle + text lines).
  factory SkeletonLoader.profileRow({int index = 0}) => SkeletonLoader(
        shape: SkeletonShape.profileRow,
        index: index,
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final baseColor = isDark ? AppColors.cosmicPurple : AppColors.lightSurfaceVariant;
    final shimmerColor = isDark
        ? AppColors.auroraStart.withValues(alpha: 0.12)
        : AppColors.lightAuroraStart.withValues(alpha: 0.15);

    return Semantics(
      label: 'Loading content',
      child: _buildShape(context, baseColor, shimmerColor, reduceMotion),
    );
  }

  Widget _buildShape(
    BuildContext context,
    Color baseColor,
    Color shimmerColor,
    bool reduceMotion,
  ) {
    switch (shape) {
      case SkeletonShape.card:
        return _animatedBox(
          baseColor,
          shimmerColor,
          reduceMotion,
          width: double.infinity,
          height: height ?? 96,
          radius: borderRadius ?? BorderRadius.circular(GlassTokens.radiusMd),
        );
      case SkeletonShape.textLine:
        return LayoutBuilder(
          builder: (context, constraints) {
            final lineWidth = (width ?? 1.0) <= 1.0
                ? constraints.maxWidth * (width ?? 1.0)
                : width!;
            return _animatedBox(
              baseColor,
              shimmerColor,
              reduceMotion,
              width: lineWidth,
              height: height ?? 14,
              radius: borderRadius ?? BorderRadius.circular(4),
            );
          },
        );
      case SkeletonShape.circle:
        final size = height ?? 44;
        return _animatedBox(
          baseColor,
          shimmerColor,
          reduceMotion,
          width: size,
          height: size,
          radius: BorderRadius.circular(size / 2),
        );
      case SkeletonShape.profileRow:
        return Row(
          children: [
            SkeletonLoader(
              shape: SkeletonShape.circle,
              height: 44,
              index: index,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(
                    shape: SkeletonShape.textLine,
                    width: 0.6,
                    height: 16,
                    index: index,
                  ),
                  const SizedBox(height: 8),
                  SkeletonLoader(
                    shape: SkeletonShape.textLine,
                    width: 0.4,
                    height: 12,
                    index: index + 1,
                  ),
                ],
              ),
            ),
          ],
        );
      case SkeletonShape.custom:
        return _animatedBox(
          baseColor,
          shimmerColor,
          reduceMotion,
          width: width ?? double.infinity,
          height: height ?? 48,
          radius: borderRadius ?? BorderRadius.circular(GlassTokens.radiusSm),
        );
    }
  }

  Widget _animatedBox(
    Color baseColor,
    Color shimmerColor,
    bool reduceMotion, {
    required double width,
    required double height,
    required BorderRadius radius,
  }) {
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: radius,
      ),
    );

    if (reduceMotion) return box;

    final delay = Duration(milliseconds: 80 * index);
    return box
        .animate(
          delay: delay,
          onPlay: (controller) => controller.repeat(),
        )
        .shimmer(
          duration: 1500.ms,
          color: shimmerColor,
        );
  }
}

enum SkeletonShape { card, textLine, circle, profileRow, custom }
