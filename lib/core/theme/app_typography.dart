import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography styles for the InnerCycles app
///
/// FONT CHOICES (Premium Journaling):
/// - Cormorant Garamond: Warm literary serif for display/headlines
/// - Plus Jakarta Sans: Clean modern sans-serif for body (excellent readability)
/// - Cormorant: Refined literary accent font
class AppTypography {
  AppTypography._();

  /// Display font - Cormorant Garamond (warm, literary, elegant)
  static TextStyle get displayFont => GoogleFonts.cormorantGaramond();

  /// Accent font - Cormorant (refined, literary)
  static TextStyle get accentFont => GoogleFonts.cormorant();

  /// Body font - Plus Jakarta Sans (clean, warm, highly readable)
  static TextStyle get bodyFont => GoogleFonts.plusJakartaSans();

  static TextTheme get textTheme => TextTheme(
    // Display styles - Cormorant Garamond for warm, literary elegance
    displayLarge: GoogleFonts.cormorantGaramond(
      fontSize: 52,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      height: 1.15,
    ),
    displayMedium: GoogleFonts.cormorantGaramond(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      height: 1.2,
    ),
    displaySmall: GoogleFonts.cormorantGaramond(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.25,
    ),

    // Headline styles - Cormorant Garamond
    headlineLarge: GoogleFonts.cormorantGaramond(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.3,
    ),
    headlineMedium: GoogleFonts.cormorantGaramond(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.05,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.cormorantGaramond(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.05,
      height: 1.35,
    ),

    // Title styles - Plus Jakarta Sans for modern clarity
    titleLarge: GoogleFonts.plusJakartaSans(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.35,
    ),
    titleMedium: GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
    ),
    titleSmall: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
    ),

    // Body styles - Plus Jakarta Sans for excellent readability
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.55,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.05,
      height: 1.45,
    ),

    // Label styles - Plus Jakarta Sans with medium weight
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      height: 1.4,
    ),
    labelMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.4,
    ),
    labelSmall: GoogleFonts.plusJakartaSans(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.4,
    ),
  );

  /// Elegant accent for sacred/literary text (chapter headers, section titles)
  static TextStyle elegantAccent({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double letterSpacing = 2.0,
  }) {
    return GoogleFonts.cormorant(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Decorative script for quotes and reflective text
  static TextStyle decorativeScript({
    double fontSize = 18,
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

  /// Modern accent for UI elements (buttons, badges, chips)
  static TextStyle modernAccent({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
    double letterSpacing = 0.5,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Subtitle style — w500 medium weight between body (w400) and label (w600)
  static TextStyle subtitle({
    double fontSize = 15,
    Color? color,
    double height = 1.45,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
    );
  }

  /// Gold gradient text widget — wraps text in a ShaderMask
  static Widget gradientText(
    String text,
    TextStyle style, {
    List<Color>? colors,
    TextAlign? textAlign,
  }) {
    final gradientColors =
        colors ??
        [AppColors.starGold, AppColors.celestialGold, AppColors.starGold];
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}
