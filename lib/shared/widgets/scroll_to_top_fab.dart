import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/liquid_glass/glass_panel.dart';
import '../../data/services/haptic_service.dart';

/// Floating action button that appears after scrolling past [showOffset].
/// Glass circle with a gold arrow, auto-scrolls to top on tap.
///
/// Usage:
///   ScrollToTopFAB(scrollController: _scrollController)
class ScrollToTopFAB extends StatefulWidget {
  final ScrollController scrollController;
  final double showOffset;

  const ScrollToTopFAB({
    super.key,
    required this.scrollController,
    this.showOffset = 300,
  });

  @override
  State<ScrollToTopFAB> createState() => _ScrollToTopFABState();
}

class _ScrollToTopFABState extends State<ScrollToTopFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = widget.scrollController.offset > widget.showOffset;
    if (show != _visible) {
      _visible = show;
      if (show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _scrollToTop() {
    HapticService.scrollToTop();
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isDismissed) return const SizedBox.shrink();
        return Positioned(
          right: 16,
          bottom: 16,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: child,
            ),
          ),
        );
      },
      child: Semantics(
        label: 'Scroll to top',
        button: true,
        child: GestureDetector(
          onTap: _scrollToTop,
          child: SizedBox(
            width: 44,
            height: 44,
            child: GlassPanel(
              elevation: GlassElevation.g3,
              borderRadius: BorderRadius.circular(22),
              padding: EdgeInsets.zero,
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.starGold, AppColors.celestialGold],
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
