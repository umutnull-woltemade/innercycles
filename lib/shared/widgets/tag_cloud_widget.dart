// ════════════════════════════════════════════════════════════════════════════
// TAG CLOUD WIDGET - Visual tag frequency display
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class TagCloudWidget extends StatelessWidget {
  final Map<String, int> tagCounts; // tag → count
  final String? selectedTag;
  final ValueChanged<String?> onTagSelected;
  final bool isDark;
  final int maxTags;

  const TagCloudWidget({
    super.key,
    required this.tagCounts,
    this.selectedTag,
    required this.onTagSelected,
    required this.isDark,
    this.maxTags = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (tagCounts.isEmpty) return const SizedBox.shrink();

    final sorted = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final tags = sorted.take(maxTags).toList();
    final maxCount = tags.first.value;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: tags.asMap().entries.map((entry) {
        final tag = entry.value.key;
        final count = entry.value.value;
        final isSelected = selectedTag == tag;
        final ratio = maxCount > 0 ? count / maxCount : 0.5;
        final fontSize = 11.0 + (ratio * 5.0); // 11-16

        return GestureDetector(
          onTap: () => onTagSelected(isSelected ? null : tag),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isSelected
                  ? AppColors.starGold.withValues(alpha: 0.2)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04)),
              border: isSelected
                  ? Border.all(
                      color: AppColors.starGold.withValues(alpha: 0.5),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '#$tag',
                  style: AppTypography.elegantAccent(
                    fontSize: fontSize,
                    color: isSelected
                        ? AppColors.starGold
                        : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(
              delay: Duration(milliseconds: 50 * entry.key),
              duration: 200.ms,
            );
      }).toList(),
    );
  }
}
