import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Provides glass-themed Material date and time pickers that match the app's
/// premium visual style. Wraps the standard pickers with a custom [Theme]
/// builder that applies aurora/gold color schemes and dark/light surface
/// colors.
class ThemedPicker {
  ThemedPicker._();

  /// Shows a themed date picker with glass-style colors.
  static Future<DateTime?> showDate(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: isDark
              ? ColorScheme.dark(
                  primary: AppColors.auroraStart,
                  onPrimary: Colors.white,
                  surface: AppColors.surfaceDark,
                  onSurface: AppColors.textPrimary,
                )
              : ColorScheme.light(
                  primary: AppColors.lightAuroraStart,
                  onPrimary: Colors.white,
                  surface: AppColors.lightSurface,
                  onSurface: AppColors.lightTextPrimary,
                ),
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: child!,
      ),
    );
  }

  /// Shows a themed time picker with glass-style colors.
  static Future<TimeOfDay?> showTime(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: isDark
              ? ColorScheme.dark(
                  primary: AppColors.starGold,
                  onPrimary: AppColors.deepSpace,
                  surface: AppColors.surfaceDark,
                  onSurface: AppColors.textPrimary,
                )
              : ColorScheme.light(
                  primary: AppColors.lightStarGold,
                  onPrimary: Colors.white,
                  surface: AppColors.lightSurface,
                  onSurface: AppColors.lightTextPrimary,
                ),
          timePickerTheme: TimePickerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: child!,
      ),
    );
  }
}
