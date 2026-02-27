import 'package:flutter/material.dart';

/// Warm Sand + Terracotta palette for the InnerCycles app
class CosmicPalette {
  CosmicPalette._();

  // === WARM BROWNS ===
  static const Color cosmicPurple = Color(0xFF3D3229);
  static const Color amethyst = Color(0xFF8B6F5E);
  static const Color lavender = Color(0xFFA08574);
  static const Color violetMist = Color(0xFFB8A99A);
  static const Color orchid = Color(0xFFD4704A);

  // === TERRACOTTA SPECTRUM ===
  static const Color starGold = Color(0xFFC8553D);
  static const Color antiqueGold = Color(0xFFD4704A);
  static const Color champagne = Color(0xFFF5EDE6);
  static const Color amber = Color(0xFFBF8D6A);
  static const Color bronzeGlow = Color(0xFF8B6F5E);

  // === WARM DARKS ===
  static const Color midnightBlue = Color(0xFF1E1714);
  static const Color cosmicNavy = Color(0xFF2D241F);
  static const Color nebulaTeal = Color(0xFF5A4A3E);
  static const Color stardustBlue = Color(0xFFA08574);
  static const Color etherealCyan = Color(0xFFD4A07A);

  // === WARM ACCENTS ===
  static const Color starlightWhite = Color(0xFFFBF7F4);
  static const Color moonSilver = Color(0xFFE8D5C4);
  static const Color nebulaRose = Color(0xFFE8D5C4);
  static const Color auroraGreen = Color(0xFFD4A07A);
  static const Color solarOrange = Color(0xFFFF6B35);

  // === BACKGROUNDS ===
  static const Color bgDeepSpace = Color(0xFF1E1714);
  static const Color bgNightSky = Color(0xFF241E19);
  static const Color bgCosmic = Color(0xFF2D241F);
  static const Color bgElevated = Color(0xFF3D322B);
  static const Color bgLight = Color(
    0xFFF5EDE6,
  ); // Warm sand background
  static const Color bgLightElevated = Color(
    0xFFEDE3D9,
  ); // Sand variant cards

  // === TEXT COLORS ===
  static const Color textPrimary = Color(
    0xFFF2EBE4,
  ); // Warm white for maximum visibility
  static const Color textSecondary = Color(
    0xFFA08574,
  ); // Warm taupe for better contrast
  static const Color textMuted = Color(
    0xFF8A7D74,
  ); // Warm gray for better readability
  static const Color textGold = Color(0xFFC8553D);
  static const Color textDark = Color(
    0xFF3D3229,
  ); // Espresso for light mode visibility
  static const Color textDarkSecondary = Color(
    0xFF8B6F5E,
  ); // Warm brown secondary text

  // === ENERGY ACCENT COLORS ===
  static const Color accentWarm = Color(0xFFFF6B35);
  static const Color accentEarth = Color(0xFF4A7C59);
  static const Color accentCool = Color(0xFFD4A07A);
  static const Color accentDeep = Color(0xFF8B6F5E);

  // === EXTENDED PALETTE ===
  static const Color paletteGold = Color(0xFFC8553D);
  static const Color paletteSilver = Color(0xFFE8D5C4);
  static const Color paletteGray = Color(0xFFB8A99A);
  static const Color paletteRose = Color(0xFFE8D5C4);
  static const Color paletteOrange = Color(0xFFFF6B35);
  static const Color paletteAmber = Color(0xFFD4704A);
  static const Color paletteBrown = Color(0xFF8B7355);
  static const Color paletteCyan = Color(0xFFD4A07A);
  static const Color paletteNavy = Color(0xFFA08574);
  static const Color paletteViolet = Color(0xFF8B6F5E);

  // === GRADIENTS ===
  static const List<Color> cosmicGradient = [
    Color(0xFF3D3229),
    Color(0xFF1E1714),
  ];

  static const List<Color> auroraGradient = [
    Color(0xFF8B6F5E),
    Color(0xFFA08574),
    Color(0xFFD4A07A),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFC8553D),
    Color(0xFFD4704A),
    Color(0xFF8B6F5E),
  ];

  static const List<Color> nightSkyGradient = [
    Color(0xFF1E1714),
    Color(0xFF2D241F),
    Color(0xFF3D3229),
  ];

  // === SHADOWS ===
  static List<BoxShadow> get glowPurple => [
    BoxShadow(
      color: amethyst.withValues(alpha: 0.4),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> get glowGold => [
    BoxShadow(
      color: starGold.withValues(alpha: 0.4),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // === COLOR SCHEMES ===
  static ColorScheme get darkScheme => ColorScheme.dark(
    primary: amethyst,
    onPrimary: textPrimary,
    primaryContainer: cosmicPurple,
    onPrimaryContainer: lavender,
    secondary: starGold,
    onSecondary: bgDeepSpace,
    secondaryContainer: antiqueGold.withValues(alpha: 0.2),
    onSecondaryContainer: starGold,
    tertiary: nebulaTeal,
    onTertiary: textPrimary,
    error: solarOrange,
    onError: textPrimary,
    surface: bgCosmic,
    onSurface: textPrimary,
    surfaceContainerHighest: bgElevated,
    onSurfaceVariant: textSecondary,
    outline: textMuted,
    shadow: Colors.black,
  );

  static ColorScheme get lightScheme => ColorScheme.light(
    primary: cosmicPurple,
    onPrimary: Colors.white,
    primaryContainer: amethyst,
    onPrimaryContainer: Colors.white,
    secondary: bronzeGlow,
    onSecondary: Colors.white,
    secondaryContainer: champagne,
    onSecondaryContainer: textDark,
    tertiary: nebulaTeal,
    onTertiary: Colors.white,
    error: solarOrange,
    onError: Colors.white,
    surface: bgLight,
    onSurface: textDark,
    surfaceContainerHighest: bgLightElevated,
    onSurfaceVariant: textDarkSecondary,
    outline: amethyst,
    shadow: cosmicPurple.withValues(alpha: 0.2),
  );
}
