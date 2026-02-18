import 'package:flutter/material.dart';

/// Cosmic color palette for the InnerCycles app
class AppColors {
  AppColors._();

  // Primary cosmic colors (dark mode)
  static const Color deepSpace = Color(0xFF0D0D1A);
  static const Color cosmicPurple = Color(0xFF1A1A2E);
  static const Color nebulaPurple = Color(0xFF16213E);
  static const Color amethystBlue = Color(0xFF0F3460);

  // Accent colors
  static const Color starGold = Color(0xFFFFD700);
  static const Color celestialGold = Color(0xFFF4C430);
  static const Color moonSilver = Color(0xFFC0C0C0);
  static const Color stardust = Color(0xFFE8E4E1);
  static const Color amethyst = Color(0xFF9B59B6);

  // Gradient colors
  static const Color auroraStart = Color(0xFF667EEA);
  static const Color auroraEnd = Color(0xFF764BA2);
  static const Color sunriseStart = Color(0xFFF093FB);
  static const Color sunriseEnd = Color(0xFFF5576C);
  static const Color twilightStart = Color(0xFF4776E6);
  static const Color twilightEnd = Color(0xFF8E54E9);

  // Category accent colors
  static const Color warmAccent = Color(0xFFE74C3C);
  static const Color greenAccent = Color(0xFF27AE60);
  static const Color blueAccent = Color(0xFF3498DB);
  static const Color purpleAccent = Color(0xFF9B59B6);

  // Text colors (dark mode)
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB8B8D1);
  static const Color textMuted = Color(0xFF8A8AA8);

  // Text colors (for theme-aware usage)
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textLight = Color(0xFF8A8AA8);

  // Cosmic accent
  static const Color cosmic = Color(0xFF667EEA);
  static const Color cosmicAmethyst = Color(0xFF8E54E9);
  static const Color gold = Color(0xFFFFD700);

  // Surface colors (dark mode)
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color surfaceLight = Color(0xFF2D2D44);
  static const Color cardBackground = Color(0xFF252540);

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
  static const Color lightBackground = Color(0xFFF8F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F2F8);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Light mode text
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF4A4A6A);
  static const Color lightTextMuted = Color(0xFF6B6B8A);

  // Light mode accent (slightly darker for better contrast)
  static const Color lightAuroraStart = Color(0xFF5A6FD6);
  static const Color lightAuroraEnd = Color(0xFF6B4199);
  static const Color lightStarGold = Color(0xFFD4A800);

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
    colors: [Color(0x30667EEA), Color(0x00667EEA)],
  );

  // ========== CHAT / INSIGHT COLORS ==========
  static const Color chatAccent = Color(0xFF4A90A4);
  static const Color chatAccentDark = Color(0xFF357A8C);
  static const Color chatBubbleUser = Color(0xFF2D5A7B);
  static const Color chatSurface = Color(0xFF1C2128);
  static const Color chatInputArea = Color(0xFF161B22);
  static const Color chatInputField = Color(0xFF0D1117);

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
    starGold,   // Energy
    chartBlue,  // Focus
    chartPink,  // Emotions
    chartGreen, // Decisions
    chartPurple, // Social
  ];

  // ========== FEATURE-SPECIFIC ACCENT COLORS ==========
  static const Color exportGreen = Color(0xFF66BB6A);
  static const Color streakOrange = Color(0xFFFF6B35);
  static const Color mediumSlateBlue = Color(0xFF7B68EE);
}
