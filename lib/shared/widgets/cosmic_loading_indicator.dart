import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';

/// Themed loading indicator matching the cosmic design system.
/// Replaces bare CircularProgressIndicator across all screens.
class CosmicLoadingIndicator extends StatelessWidget {
  final String? message;

  const CosmicLoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              strokeWidth: 2.5,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ],
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}
