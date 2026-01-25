import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography styles for the astrology app
///
/// FONT CHOICES:
/// - Playfair Display: Elegant serif for headers (şık, mistik hissiyat)
/// - Space Grotesk: Modern, havalı sans-serif for body (kolay okunan, futuristik)
/// - Cinzel: Ancient style for zodiac accents (kadim, mistik)
///
/// BOYUTLAR BÜYÜTÜLDÜ - daha okunaklı
class MysticalTypography {
  MysticalTypography._();

  /// Display font - Playfair Display (elegant, serif, premium)
  static TextStyle get displayFont => GoogleFonts.playfairDisplay();

  /// Accent font for zodiac signs - Cinzel (ancient, mystical)
  static TextStyle get accentFont => GoogleFonts.cinzel();

  /// Body font - Space Grotesk (modern, clean, futuristic, highly readable)
  static TextStyle get bodyFont => GoogleFonts.spaceGrotesk();

  static TextTheme get textTheme => TextTheme(
    // Display styles - Playfair Display for elegant headers
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 52,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      height: 1.2,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
      height: 1.2,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      height: 1.3,
    ),

    // Headline styles - Playfair Display
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      height: 1.3,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4,
    ),

    // Title styles - Space Grotesk for modern readability
    titleLarge: GoogleFonts.spaceGrotesk(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.spaceGrotesk(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.05,
      height: 1.4,
    ),
    titleSmall: GoogleFonts.spaceGrotesk(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.05,
      height: 1.4,
    ),

    // Body styles - Space Grotesk for excellent readability (BÜYÜTÜLDÜ)
    bodyLarge: GoogleFonts.spaceGrotesk(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.65,
    ),
    bodyMedium: GoogleFonts.spaceGrotesk(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.6,
    ),
    bodySmall: GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.55,
    ),

    // Label styles - Space Grotesk (BÜYÜTÜLDÜ)
    labelLarge: GoogleFonts.spaceGrotesk(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      height: 1.4,
    ),
    labelMedium: GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.25,
      height: 1.4,
    ),
    labelSmall: GoogleFonts.spaceGrotesk(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      height: 1.4,
    ),
  );

  /// Get Cinzel style for zodiac signs and mystical accents
  static TextStyle zodiacAccent({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double letterSpacing = 2.0,
  }) {
    return GoogleFonts.cinzel(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Get elegant script for special quotes and mystical text
  static TextStyle mysticalScript({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    FontStyle fontStyle = FontStyle.italic,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      height: 1.6,
    );
  }

  /// Modern accent for UI elements (buttons, badges)
  static TextStyle modernAccent({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
    double letterSpacing = 1.0,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
