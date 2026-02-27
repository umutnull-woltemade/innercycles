import 'package:flutter/material.dart';

/// Liquid Glass Design System — Design Tokens
///
/// Elevation levels G1-G5 control blur, opacity, and border glow intensity.
/// All values are tuned for both light and dark modes.
class GlassTokens {
  GlassTokens._();

  // ═══════════════════════════════════════════════════════════════════════════
  // COLOR SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════

  // Dark mode surfaces
  static const Color darkSurface = Color(0xFF1E1714);
  static const Color darkElevated = Color(0xFF2D241F);
  static const Color darkOverlay = Color(0x40FFFFFF);
  static const Color darkBorder = Color(0x30FFFFFF);

  // Light mode surfaces
  static const Color lightSurface = Color(0xFFFBF7F4);
  static const Color lightElevated = Color(0xFFFFFFFF);
  static const Color lightOverlay = Color(0x20000000);
  static const Color lightBorder = Color(0x18000000);

  // Accent
  static const Color starGold = Color(0xFFC8553D);
  static const Color celestialGold = Color(0xFFD4704A);
  static const Color amethyst = Color(0xFF8B6F5E);
  static const Color auroraStart = Color(0xFFD4A07A);
  static const Color auroraEnd = Color(0xFF8B6F5E);
  static const Color cosmic = Color(0xFFD4A07A);

  // Glow colors (for border gradients)
  static const Color glowGold = Color(0x40C8553D);
  static const Color glowAmethyst = Color(0x408B6F5E);
  static const Color glowCosmic = Color(0x40C8553D);

  // ═══════════════════════════════════════════════════════════════════════════
  // BLUR SCALE
  // ═══════════════════════════════════════════════════════════════════════════

  static const double blurNone = 0;
  static const double blurSubtle = 4;
  static const double blurLight = 8;
  static const double blurMedium = 16;
  static const double blurHeavy = 24;
  static const double blurMax = 40;

  // ═══════════════════════════════════════════════════════════════════════════
  // ELEVATION SYSTEM (G1-G5)
  // ═══════════════════════════════════════════════════════════════════════════

  // G1: Subtle background panel (e.g. page background overlay)
  static const double g1Blur = 8;
  static const double g1Opacity = 0.05;
  static const double g1BorderOpacity = 0.08;

  // G2: Card level (e.g. content cards, list items) — matches iOS .ultraThinMaterial
  static const double g2Blur = 12;
  static const double g2Opacity = 0.18;
  static const double g2BorderOpacity = 0.15;

  // G3: Elevated panel (e.g. modals, sheets) — matches iOS .thinMaterial
  static const double g3Blur = 20;
  static const double g3Opacity = 0.30;
  static const double g3BorderOpacity = 0.20;

  // G4: Prominent surface (e.g. floating action areas) — matches iOS .regularMaterial
  static const double g4Blur = 28;
  static const double g4Opacity = 0.45;
  static const double g4BorderOpacity = 0.25;

  // G5: Maximum glass (e.g. overlay dialogs, tooltips)
  static const double g5Blur = 40;
  static const double g5Opacity = 0.25;
  static const double g5BorderOpacity = 0.30;

  // ═══════════════════════════════════════════════════════════════════════════
  // ANIMATION TIMING
  // ═══════════════════════════════════════════════════════════════════════════

  static const Duration instantDuration = Duration(milliseconds: 100);
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 350);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration dramaticDuration = Duration(milliseconds: 800);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve entranceCurve = Curves.easeOutBack;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPOGRAPHY
  // ═══════════════════════════════════════════════════════════════════════════

  static const String fontFamily = 'Josefin Sans';
  static const String fontFamilyFallback = 'Nunito';

  static const double fontHero = 32;
  static const double fontTitle = 24;
  static const double fontHeadline = 20;
  static const double fontBody = 16;
  static const double fontCaption = 14;
  static const double fontMicro = 12;

  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemibold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;

  // ═══════════════════════════════════════════════════════════════════════════
  // SPACING
  // ═══════════════════════════════════════════════════════════════════════════

  static const double spaceXxs = 2;
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
  static const double spaceXxl = 32;
  static const double spaceHuge = 48;

  // ═══════════════════════════════════════════════════════════════════════════
  // RADII
  // ═══════════════════════════════════════════════════════════════════════════

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 9999;

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns blur sigma for a given G-level (1-5)
  static double blurForLevel(int level) {
    switch (level) {
      case 1:
        return g1Blur;
      case 2:
        return g2Blur;
      case 3:
        return g3Blur;
      case 4:
        return g4Blur;
      case 5:
        return g5Blur;
      default:
        return g2Blur;
    }
  }

  /// Returns surface opacity for a given G-level (1-5)
  static double opacityForLevel(int level) {
    switch (level) {
      case 1:
        return g1Opacity;
      case 2:
        return g2Opacity;
      case 3:
        return g3Opacity;
      case 4:
        return g4Opacity;
      case 5:
        return g5Opacity;
      default:
        return g2Opacity;
    }
  }

  /// Returns border opacity for a given G-level (1-5)
  static double borderOpacityForLevel(int level) {
    switch (level) {
      case 1:
        return g1BorderOpacity;
      case 2:
        return g2BorderOpacity;
      case 3:
        return g3BorderOpacity;
      case 4:
        return g4BorderOpacity;
      case 5:
        return g5BorderOpacity;
      default:
        return g2BorderOpacity;
    }
  }
}
