import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography styles for the InnerCycles app
///
/// FONT CHOICES (Thin, Naif, Premium Journaling):
/// - Josefin Sans: Thin geometric sans-serif for display/headlines (delicate, elegant)
/// - Nunito: Rounded warm sans-serif for body (soft, highly readable)
class AppTypography {
  AppTypography._();

  /// Display font - Josefin Sans (thin, geometric, naif)
  static TextStyle get displayFont => GoogleFonts.josefinSans();

  /// Accent font - Josefin Sans (thin, elegant)
  static TextStyle get accentFont => GoogleFonts.josefinSans();

  /// Body font - Nunito (rounded, warm, highly readable)
  static TextStyle get bodyFont => GoogleFonts.nunito();

  static TextTheme get textTheme => TextTheme(
    // Display styles - Josefin Sans thin for delicate elegance
    displayLarge: GoogleFonts.josefinSans(
      fontSize: 52,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.5,
      height: 1.15,
    ),
    displayMedium: GoogleFonts.josefinSans(
      fontSize: 40,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.3,
      height: 1.2,
    ),
    displaySmall: GoogleFonts.josefinSans(
      fontSize: 32,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.2,
      height: 1.25,
    ),

    // Headline styles - Josefin Sans light
    headlineLarge: GoogleFonts.josefinSans(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.3,
    ),
    headlineMedium: GoogleFonts.josefinSans(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.josefinSans(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.35,
    ),

    // Title styles - Nunito for warm clarity
    titleLarge: GoogleFonts.nunito(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.35,
    ),
    titleMedium: GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
    ),
    titleSmall: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
    ),

    // Body styles - Nunito for soft readability
    bodyLarge: GoogleFonts.nunito(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.55,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.05,
      height: 1.45,
    ),

    // Label styles - Nunito with semibold weight
    labelLarge: GoogleFonts.nunito(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      height: 1.4,
    ),
    labelMedium: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.4,
    ),
    labelSmall: GoogleFonts.nunito(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.4,
    ),
  );

  /// Elegant accent for section titles, chapter headers
  static TextStyle elegantAccent({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w300,
    Color? color,
    double letterSpacing = 2.0,
  }) {
    return GoogleFonts.josefinSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Decorative script for quotes and reflective text
  static TextStyle decorativeScript({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w300,
    Color? color,
    FontStyle fontStyle = FontStyle.italic,
  }) {
    return GoogleFonts.josefinSans(
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
    return GoogleFonts.nunito(
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
    return GoogleFonts.nunito(
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
