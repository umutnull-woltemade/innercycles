import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/haptic_service.dart';

/// Style variants for the step progress indicator.
enum StepProgressStyle { dots, bar, numberedDots }

/// Horizontal progress indicator for multi-step flows.
///
/// Usage:
///   StepProgressIndicator(
///     totalSteps: 4,
///     currentStep: 2,
///     style: StepProgressStyle.dots,
///   )
class StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final StepProgressStyle style;

  const StepProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.style = StepProgressStyle.dots,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case StepProgressStyle.dots:
        return _DotsIndicator(
          totalSteps: totalSteps,
          currentStep: currentStep,
        );
      case StepProgressStyle.bar:
        return _BarIndicator(
          totalSteps: totalSteps,
          currentStep: currentStep,
        );
      case StepProgressStyle.numberedDots:
        return _NumberedDotsIndicator(
          totalSteps: totalSteps,
          currentStep: currentStep,
        );
    }
  }
}

class _DotsIndicator extends StatefulWidget {
  final int totalSteps;
  final int currentStep;

  const _DotsIndicator({
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  State<_DotsIndicator> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<_DotsIndicator> {
  int _previousStep = 0;

  @override
  void didUpdateWidget(covariant _DotsIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _previousStep = oldWidget.currentStep;
      HapticService.selectionTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalSteps, (i) {
        final isActive = i == widget.currentStep;
        final isCompleted = i < widget.currentStep;
        final justActivated = isActive && i != _previousStep;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: isActive ? 1.3 : 1.0),
            duration: const Duration(milliseconds: 300),
            curve: justActivated ? Curves.elasticOut : Curves.easeOutCubic,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: (isActive || isCompleted)
                        ? const LinearGradient(
                            colors: [AppColors.starGold, AppColors.celestialGold],
                          )
                        : null,
                    color: (isActive || isCompleted)
                        ? null
                        : (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.15),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.starGold.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          size: 6,
                          color: AppColors.deepSpace,
                        )
                      : null,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _BarIndicator extends StatefulWidget {
  final int totalSteps;
  final int currentStep;

  const _BarIndicator({
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  State<_BarIndicator> createState() => _BarIndicatorState();
}

class _BarIndicatorState extends State<_BarIndicator> {
  @override
  void didUpdateWidget(covariant _BarIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      HapticService.selectionTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (widget.currentStep + 1) / widget.totalSteps;

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 4,
        child: Stack(
          children: [
            // Track
            Container(
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Fill
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              widthFactor: progress.clamp(0.0, 1.0),
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.starGold, AppColors.celestialGold],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.starGold.withValues(alpha: 0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberedDotsIndicator extends StatefulWidget {
  final int totalSteps;
  final int currentStep;

  const _NumberedDotsIndicator({
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  State<_NumberedDotsIndicator> createState() => _NumberedDotsIndicatorState();
}

class _NumberedDotsIndicatorState extends State<_NumberedDotsIndicator> {
  int _previousStep = 0;

  @override
  void didUpdateWidget(covariant _NumberedDotsIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _previousStep = oldWidget.currentStep;
      HapticService.selectionTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalSteps, (i) {
        final isActive = i == widget.currentStep;
        final isCompleted = i < widget.currentStep;
        final justActivated = isActive && i != _previousStep;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: isActive ? 1.15 : 1.0),
            duration: const Duration(milliseconds: 300),
            curve: justActivated ? Curves.elasticOut : Curves.easeOutCubic,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: (isActive || isCompleted)
                        ? const LinearGradient(
                            colors: [AppColors.starGold, AppColors.celestialGold],
                          )
                        : null,
                    color: (isActive || isCompleted)
                        ? null
                        : (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.1),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.starGold.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.deepSpace,
                          )
                        : Text(
                            '${i + 1}',
                            style: AppTypography.subtitle(
                              fontSize: 11,
                              color: (isActive || isCompleted)
                                  ? AppColors.deepSpace
                                  : (isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted),
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
