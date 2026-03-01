import 'package:flutter/material.dart';
import '../../core/theme/liquid_glass/glass_tokens.dart';
import '../../core/theme/liquid_glass/glass_animations.dart';

/// Auto-applies staggered entrance animation to SliverList children.
/// Drop-in replacement for SliverList.
///
/// Items 0-14 animate with a 50ms stagger. Items 15+ render instantly.
/// Each item is wrapped in RepaintBoundary for performance.
///
/// Usage:
///   StaggeredSliverList(
///     itemCount: items.length,
///     itemBuilder: (context, index) => MyCard(items[index]),
///   )
class StaggeredSliverList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Duration itemDuration;
  final Duration staggerDelay;
  final int maxAnimatedItems;

  const StaggeredSliverList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemDuration = GlassTokens.normalDuration,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.maxAnimatedItems = 15,
  });

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final child = RepaintBoundary(
            child: itemBuilder(context, index),
          );

          if (disableAnimations || index >= maxAnimatedItems) {
            return child;
          }

          return child.glassEntrance(
            context: context,
            delay: staggerDelay * index,
            duration: itemDuration,
          );
        },
        childCount: itemCount,
      ),
    );
  }
}

/// Extension to add stagger entrance to any widget inline.
///
/// Usage in existing SliverList delegates:
///   SliverList(
///     delegate: SliverChildBuilderDelegate((context, index) {
///       return MyCard().staggerIn(index, context: context);
///     }),
///   )
extension StaggerInExtension on Widget {
  Widget staggerIn(
    int index, {
    BuildContext? context,
    Duration stagger = const Duration(milliseconds: 50),
    int maxItems = 15,
  }) {
    if (context != null && MediaQuery.of(context).disableAnimations) {
      return this;
    }
    if (index >= maxItems) return this;

    return RepaintBoundary(
      child: this,
    ).glassEntrance(
      context: context,
      delay: stagger * index,
    );
  }
}
