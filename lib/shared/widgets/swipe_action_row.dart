import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/services/haptic_service.dart';

/// A single swipe action definition.
class SwipeAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const SwipeAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  /// Delete action (red).
  factory SwipeAction.delete({VoidCallback? onTap}) => SwipeAction(
        icon: Icons.delete_outline_rounded,
        label: 'Delete',
        color: AppColors.error,
        onTap: onTap,
      );

  /// Archive action (gold).
  factory SwipeAction.archive({VoidCallback? onTap}) => SwipeAction(
        icon: Icons.archive_outlined,
        label: 'Archive',
        color: AppColors.starGold,
        onTap: onTap,
      );

  /// Pin action (amethyst).
  factory SwipeAction.pin({VoidCallback? onTap}) => SwipeAction(
        icon: Icons.push_pin_outlined,
        label: 'Pin',
        color: AppColors.amethyst,
        onTap: onTap,
      );
}

/// Themed Dismissible wrapper with rounded action backgrounds.
///
/// Usage:
///   SwipeActionRow(
///     onDismissed: (_) => deleteItem(),
///     endAction: SwipeAction.delete(),
///     child: MyListTile(),
///   )
class SwipeActionRow extends StatefulWidget {
  final Widget child;
  final SwipeAction? startAction;
  final SwipeAction? endAction;
  final DismissDirection direction;
  final double threshold;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;
  final void Function(DismissDirection)? onDismissed;
  final BorderRadius? borderRadius;
  final Key dismissKey;

  const SwipeActionRow({
    super.key,
    required this.child,
    required this.dismissKey,
    this.startAction,
    this.endAction,
    this.direction = DismissDirection.endToStart,
    this.threshold = 0.3,
    this.confirmDismiss,
    this.onDismissed,
    this.borderRadius,
  });

  @override
  State<SwipeActionRow> createState() => _SwipeActionRowState();
}

class _SwipeActionRowState extends State<SwipeActionRow> {
  bool _thresholdCrossed = false;

  SwipeAction? _actionForDirection(DismissDirection dir) {
    if (dir == DismissDirection.startToEnd) return widget.startAction;
    if (dir == DismissDirection.endToStart) return widget.endAction;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(12);

    return ClipRRect(
      borderRadius: radius,
      child: Dismissible(
        key: widget.dismissKey,
        direction: widget.direction,
        dismissThresholds: {widget.direction: widget.threshold},
        confirmDismiss: (direction) async {
          final action = _actionForDirection(direction);
          action?.onTap?.call();

          if (widget.confirmDismiss != null) {
            return widget.confirmDismiss!(direction);
          }
          return true;
        },
        onDismissed: (direction) {
          _thresholdCrossed = false;
          widget.onDismissed?.call(direction);
        },
        onUpdate: (details) {
          final crossedNow = details.progress >= widget.threshold;
          if (crossedNow && !_thresholdCrossed) {
            _thresholdCrossed = true;
            HapticService.swipeThreshold();
          } else if (!crossedNow && _thresholdCrossed) {
            _thresholdCrossed = false;
          }
        },
        background: widget.startAction != null
            ? _buildBackground(widget.startAction!, Alignment.centerLeft)
            : const SizedBox.shrink(),
        secondaryBackground: widget.endAction != null
            ? _buildBackground(widget.endAction!, Alignment.centerRight)
            : const SizedBox.shrink(),
        child: widget.child,
      ),
    );
  }

  Widget _buildBackground(SwipeAction action, Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: action.color.withValues(alpha: 0.15),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(action.icon, color: action.color, size: 22),
            const SizedBox(height: 4),
            Text(
              action.label,
              style: AppTypography.subtitle(
                fontSize: 11,
                color: action.color,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
