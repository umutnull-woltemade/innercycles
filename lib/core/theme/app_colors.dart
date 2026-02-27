import 'package:flutter/material.dart';

/// Warm Sand + Terracotta color palette for the InnerCycles app
class AppColors {
  AppColors._();

  // Primary warm colors (dark mode)
  static const Color deepSpace = Color(0xFF1E1714);
  static const Color cosmicPurple = Color(0xFF2D241F);
  static const Color nebulaPurple = Color(0xFF3D322B);
  static const Color amethystBlue = Color(0xFF5A4A3E);

  // Accent colors
  static const Color starGold = Color(0xFFC8553D);
  static const Color celestialGold = Color(0xFFD4704A);
  static const Color moonSilver = Color(0xFFB8A99A);
  static const Color stardust = Color(0xFFE8E4E1);
  static const Color amethyst = Color(0xFF8B6F5E);

  // Gradient colors
  static const Color auroraStart = Color(0xFFD4A07A);
  static const Color auroraEnd = Color(0xFF8B6F5E);
  static const Color sunriseStart = Color(0xFFE8D5C4);
  static const Color sunriseEnd = Color(0xFFC8553D);
  static const Color twilightStart = Color(0xFFD4A07A);
  static const Color twilightEnd = Color(0xFF8B6F5E);

  // Category accent colors
  static const Color warmAccent = Color(0xFFE74C3C);
  static const Color greenAccent = Color(0xFF27AE60);
  static const Color blueAccent = Color(0xFF3498DB);
  static const Color purpleAccent = Color(0xFF8B6F5E);

  // Text colors (dark mode)
  static const Color textPrimary = Color(0xFFF2EBE4);
  static const Color textSecondary = Color(0xFFA08574);
  static const Color textMuted = Color(0xFF8A7D74);

  // Text colors (for theme-aware usage)
  static const Color textDark = Color(0xFF3D3229);
  static const Color textLight = Color(0xFF8A7D74);

  // Warm accent
  static const Color cosmic = Color(0xFFD4A07A);
  static const Color cosmicAmethyst = Color(0xFF8B6F5E);
  static const Color gold = Color(0xFFC8553D);

  // Surface colors (dark mode)
  static const Color surfaceDark = Color(0xFF2D241F);
  static const Color surfaceLight = Color(0xFF3D322B);
  static const Color cardBackground = Color(0xFF352C25);

  // Status colors
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);

  // Palette accent colors
  static const Color amberBrown = Color(0xFF8B7355);
  static const Color warmTan = Color(0xFFD4A574);
  static const Color softCoral = Color(0xFFCD5C5C);
  static const Color softPink = Color(0xFFFFB6C1);
  static const Color silverGray = Color(0xFFB8B8B8);

  // Brand accent color
  static const Color brandPink = Color(0xFFE91E8C);

  // ========== LIGHT MODE COLORS ==========

  // Light mode backgrounds
  static const Color lightBackground = Color(0xFFFBF7F4);
  static const Color lightSurface = Color(0xFFF5EDE6);
  static const Color lightSurfaceVariant = Color(0xFFEDE3D9);
  static const Color lightCard = Color(0xFFF5EDE6);

  // Light mode text
  static const Color lightTextPrimary = Color(0xFF3D3229);
  static const Color lightTextSecondary = Color(0xFF8B6F5E);
  static const Color lightTextMuted = Color(0xFFB8A99A);

  // Light mode accent (slightly darker for better contrast)
  static const Color lightAuroraStart = Color(0xFFBF8D6A);
  static const Color lightAuroraEnd = Color(0xFF7A5F4E);
  static const Color lightStarGold = Color(0xFFC8553D);

  // Common gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [auroraStart, auroraEnd],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceLight, surfaceDark],
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightSurface, lightSurfaceVariant],
  );

  // ========== WARM ACCENT COLORS ==========
  // Warm, grounding palette
  static const Color earthWarm = Color(0xFFC4A484); // Warm earth
  static const Color warmCrimson = Color(0xFFBC544B); // Soft crimson
  static const Color roseGold = Color(0xFFE8B4B8); // Rose gold
  static const Color deepAmber = Color(0xFF8B5A2B); // Deep amber
  static const Color creamIvory = Color(0xFFFDF6E3); // Cream ivory

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [starGold, celestialGold],
  );

  static const RadialGradient cosmicGlow = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [Color(0x30D4A07A), Color(0x00D4A07A)],
  );

  // ========== CHAT / INSIGHT COLORS ==========
  static const Color chatAccent = Color(0xFFA08574);
  static const Color chatAccentDark = Color(0xFF6B5A4D);
  static const Color chatBubbleUser = Color(0xFF4A3D33);
  static const Color chatSurface = Color(0xFF2D241F);
  static const Color chatInputArea = Color(0xFF241E19);
  static const Color chatInputField = Color(0xFF1A1510);

  static const LinearGradient chatAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [chatAccent, chatAccentDark],
  );

  // ========== CHART / DATA VISUALIZATION COLORS ==========
  static const Color chartOrange = Color(0xFFFFA500);
  static const Color chartBlue = Color(0xFF4FC3F7);
  static const Color chartPink = Color(0xFFFF6B9D);
  static const Color chartGreen = Color(0xFF81C784);
  static const Color chartPurple = Color(0xFFCE93D8);

  static const List<Color> focusAreaPalette = [
    starGold, // Energy
    chartBlue, // Focus
    chartPink, // Emotions
    chartGreen, // Decisions
    chartPurple, // Social
  ];

  // ========== FEATURE-SPECIFIC ACCENT COLORS ==========
  static const Color exportGreen = Color(0xFF66BB6A);
  static const Color streakOrange = Color(0xFFFF6B35);
  static const Color mediumSlateBlue = Color(0xFFA08574);
  static const Color lavender = Color(0xFFE8D5C4);
}
