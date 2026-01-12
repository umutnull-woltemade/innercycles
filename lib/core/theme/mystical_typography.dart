import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography styles for the astrology app
/// Uses Playfair Display for display/headers (elegant, mystical)
/// and Nunito for body text (modern, highly readable)
class MysticalTypography {
  MysticalTypography._();

  static TextTheme get textTheme => TextTheme(
    // Display styles - Playfair Display for elegance and mysticism
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),

    // Headline styles - Playfair Display
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),

    // Title styles - Nunito for readability
    titleLarge: GoogleFonts.nunito(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    titleSmall: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),

    // Body styles - Nunito for excellent readability (increased weights for visibility)
    bodyLarge: GoogleFonts.nunito(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4,
    ),

    // Label styles - Nunito (increased sizes and weights for visibility)
    labelLarge: GoogleFonts.nunito(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    labelMedium: GoogleFonts.nunito(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
    labelSmall: GoogleFonts.nunito(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
  );
}
