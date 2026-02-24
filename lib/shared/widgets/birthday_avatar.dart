// ════════════════════════════════════════════════════════════════════════════
// BIRTHDAY AVATAR - Reusable Circular Photo with Gradient Border
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BirthdayAvatar extends StatelessWidget {
  final String? photoPath;
  final String name;
  final double size;
  final bool useGoldBorder;
  final bool showBirthdayCake;

  const BirthdayAvatar({
    super.key,
    this.photoPath,
    required this.name,
    this.size = 48,
    this.useGoldBorder = true,
    this.showBirthdayCake = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderWidth = size > 60 ? 3.0 : 2.0;
    final gradientColors = useGoldBorder
        ? [AppColors.starGold, AppColors.celestialGold]
        : [AppColors.auroraStart, AppColors.auroraEnd];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(borderWidth),
          child: _buildInner(isDark),
        ),
        if (showBirthdayCake)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.38,
              height: size * 0.38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '\u{1F382}',
                  style: TextStyle(fontSize: size * 0.2),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInner(bool isDark) {
    if (photoPath != null && photoPath!.isNotEmpty) {
      final file = File(photoPath!);
      return ClipOval(
        child: Image.file(
          file,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildInitials(isDark),
        ),
      );
    }
    return _buildInitials(isDark);
  }

  Widget _buildInitials(bool isDark) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = parts.isEmpty
        ? '?'
        : parts.length == 1
            ? parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?'
            : '${parts[0][0]}${parts[1][0]}'.toUpperCase();

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.9)
            : AppColors.lightCard,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.32,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ),
    );
  }
}
