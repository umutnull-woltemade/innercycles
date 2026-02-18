import 'package:flutter/material.dart';
import 'cosmic_palette.dart';
import 'app_typography.dart';
import '../constants/app_constants.dart';

/// App theme configuration with dark and light modes
class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: CosmicPalette.darkScheme,
    // Smooth page transitions with swipe-back gesture (iOS style)
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),
    textTheme: AppTypography.textTheme.apply(
      bodyColor: CosmicPalette.textPrimary,
      displayColor: CosmicPalette.textPrimary,
    ),
    scaffoldBackgroundColor: CosmicPalette.bgDeepSpace,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: CosmicPalette.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: CosmicPalette.bgCosmic,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CosmicPalette.amethyst,
        foregroundColor: CosmicPalette.textPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXl,
          vertical: AppConstants.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CosmicPalette.starGold,
        side: const BorderSide(color: CosmicPalette.starGold),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXl,
          vertical: AppConstants.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CosmicPalette.bgElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        borderSide: BorderSide(
          color: CosmicPalette.textMuted.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        borderSide: const BorderSide(color: CosmicPalette.amethyst),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: CosmicPalette.textMuted,
      thickness: 0.5,
    ),
    iconTheme: const IconThemeData(
      color: CosmicPalette.textSecondary,
      size: 24,
    ),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: CosmicPalette.lightScheme,
    // Smooth page transitions with swipe-back gesture (iOS style)
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),
    textTheme: AppTypography.textTheme.apply(
      bodyColor: CosmicPalette.textDark,
      displayColor: CosmicPalette.textDark,
    ),
    scaffoldBackgroundColor: CosmicPalette.bgLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: CosmicPalette.textDark),
    ),
    cardTheme: CardThemeData(
      color: CosmicPalette.bgLightElevated,
      elevation: 2,
      shadowColor: CosmicPalette.amethyst.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CosmicPalette.amethyst,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXl,
          vertical: AppConstants.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CosmicPalette.amethyst,
        side: const BorderSide(color: CosmicPalette.amethyst),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXl,
          vertical: AppConstants.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CosmicPalette.bgLightElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        borderSide: BorderSide(
          color: CosmicPalette.violetMist.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        borderSide: const BorderSide(color: CosmicPalette.amethyst),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: CosmicPalette.violetMist,
      thickness: 0.5,
    ),
    iconTheme: const IconThemeData(
      color: CosmicPalette.textDarkSecondary,
      size: 24,
    ),
  );
}
