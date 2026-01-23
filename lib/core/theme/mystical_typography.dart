import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography styles for the astrology app
/// Uses Cormorant Garamond for display/headers (elegant, mystical, celestial feel)
/// Cinzel for accent text (ancient, mystical, zodiac-inspired)
/// and Raleway for body text (modern, clean, highly readable)
class MysticalTypography {
  MysticalTypography._();

  /// Mystical display font - Cormorant Garamond (elegant, serif, celestial)
  static TextStyle get displayFont => GoogleFonts.cormorantGaramond();

  /// Accent font for special elements - Cinzel (ancient, mystical)
  static TextStyle get accentFont => GoogleFonts.cinzel();

  /// Body font - Raleway (modern, clean, readable)
  static TextStyle get bodyFont => GoogleFonts.raleway();

  static TextTheme get textTheme => TextTheme(
    // Display styles - Cormorant Garamond for celestial elegance
    displayLarge: GoogleFonts.cormorantGaramond(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    ),
    displayMedium: GoogleFonts.cormorantGaramond(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
    ),
    displaySmall: GoogleFonts.cormorantGaramond(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),

    // Headline styles - Cormorant Garamond
    headlineLarge: GoogleFonts.cormorantGaramond(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    headlineMedium: GoogleFonts.cormorantGaramond(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
    headlineSmall: GoogleFonts.cormorantGaramond(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),

    // Title styles - Raleway for readability
    titleLarge: GoogleFonts.raleway(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.raleway(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    titleSmall: GoogleFonts.raleway(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),

    // Body styles - Raleway for excellent readability
    bodyLarge: GoogleFonts.raleway(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.raleway(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.raleway(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4,
    ),

    // Label styles - Raleway
    labelLarge: GoogleFonts.raleway(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    labelMedium: GoogleFonts.raleway(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
    labelSmall: GoogleFonts.raleway(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );

  /// Get Cinzel style for zodiac signs and mystical accents
  static TextStyle zodiacAccent({
    double fontSize = 14,
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
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    FontStyle fontStyle = FontStyle.italic,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      height: 1.6,
    );
  }
}
