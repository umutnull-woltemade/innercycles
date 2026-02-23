// ════════════════════════════════════════════════════════════════════════════
// APP SYMBOL - Premium emoji & icon display widget
// ════════════════════════════════════════════════════════════════════════════
// Centralized widget that wraps any emoji in a premium styled container.
// Every raw Text(emoji) in the app should use this widget instead.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Size tiers for [AppSymbol].
///
/// [containerSize] is the total widget footprint.
/// [fontSize] is the emoji text size inside the container.
/// [defaultGlow] determines whether the glow shadow appears by default.
enum AppSymbolSize {
  xs(24, 13, false),
  sm(32, 17, false),
  md(44, 24, true),
  lg(56, 30, true),
  xl(72, 40, true),
  xxl(96, 52, true);

  final double containerSize;
  final double fontSize;
  final bool defaultGlow;
  const AppSymbolSize(this.containerSize, this.fontSize, this.defaultGlow);
}

/// Premium emoji display widget.
///
/// Wraps an emoji string in a circular container with:
/// - Radial gradient background (accent color at 15% → 5% alpha)
/// - 0.5px subtle border (accent at 12% alpha)
/// - Optional BoxShadow glow for elevated sizes
/// - Auto accent color per emoji (curated map → AppColors)
class AppSymbol extends StatelessWidget {
  final String emoji;
  final AppSymbolSize size;
  final bool? _showGlow;
  final Color? accentOverride;

  const AppSymbol(
    this.emoji, {
    super.key,
    this.size = AppSymbolSize.md,
    bool? showGlow,
    this.accentOverride,
  }) : _showGlow = showGlow;

  /// xs size, no glow — for chips & inline labels.
  const AppSymbol.inline(this.emoji, {super.key, this.accentOverride})
      : size = AppSymbolSize.xs,
        _showGlow = false;

  /// md size, subtle glow — for card-level display.
  const AppSymbol.card(this.emoji, {super.key, this.accentOverride})
      : size = AppSymbolSize.md,
        _showGlow = true;

  /// xl size, prominent glow — for hero / full-screen display.
  const AppSymbol.hero(this.emoji, {super.key, this.accentOverride})
      : size = AppSymbolSize.xl,
        _showGlow = true;

  bool get showGlow => _showGlow ?? size.defaultGlow;

  Color get _accent => accentOverride ?? accentForEmoji(emoji);

  @override
  Widget build(BuildContext context) {
    final isLarge = size == AppSymbolSize.xl || size == AppSymbolSize.xxl;
    return Container(
      width: size.containerSize,
      height: size.containerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _accent.withValues(alpha: 0.15),
            _accent.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: _accent.withValues(alpha: 0.12),
          width: 0.5,
        ),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: _accent.withValues(alpha: isLarge ? 0.25 : 0.12),
                  blurRadius: isLarge ? 16 : 8,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(emoji, style: TextStyle(fontSize: size.fontSize)),
      ),
    );
  }

  /// Returns the curated accent color for a given emoji, falling back to
  /// [AppColors.cosmic] for unknown emoji.
  static Color accentForEmoji(String emoji) {
    return _emojiAccentMap[emoji] ?? AppColors.cosmic;
  }

  static const Map<String, Color> _emojiAccentMap = {
    // Fire / Energy
    '🔥': AppColors.streakOrange,
    '⚡': AppColors.starGold,
    '💥': AppColors.streakOrange,

    // Moon / Night
    '🌙': AppColors.cosmic,
    '🌕': AppColors.celestialGold,
    '🌑': AppColors.cosmicAmethyst,
    '🌛': AppColors.cosmic,
    '🌜': AppColors.cosmic,

    // Stars / Sparkles
    '⭐': AppColors.starGold,
    '✨': AppColors.starGold,
    '🌟': AppColors.starGold,
    '💫': AppColors.celestialGold,

    // Hearts
    '❤️': AppColors.softCoral,
    '💖': AppColors.softPink,
    '💝': AppColors.roseGold,
    '💗': AppColors.softPink,
    '💕': AppColors.roseGold,
    '🤎': AppColors.earthWarm,
    '💛': AppColors.starGold,
    '💚': AppColors.greenAccent,
    '💜': AppColors.purpleAccent,
    '🩷': AppColors.softPink,

    // Nature / Growth
    '🌿': AppColors.greenAccent,
    '🌱': AppColors.greenAccent,
    '🌳': AppColors.greenAccent,
    '🍃': AppColors.greenAccent,
    '🌲': AppColors.greenAccent,
    '🌾': AppColors.earthWarm,
    '🪴': AppColors.greenAccent,
    '🍀': AppColors.greenAccent,

    // Flowers
    '🌸': AppColors.softPink,
    '🌷': AppColors.softPink,
    '🌺': AppColors.softCoral,
    '🌻': AppColors.celestialGold,
    '💐': AppColors.softPink,
    '🌹': AppColors.warmCrimson,
    '🪷': AppColors.softPink,

    // Water / Ocean
    '🌊': AppColors.blueAccent,
    '💧': AppColors.blueAccent,
    '🌧️': AppColors.chatAccent,

    // Sky / Weather / Seasons
    '☀️': AppColors.celestialGold,
    '🌅': AppColors.celestialGold,
    '🌈': AppColors.auroraStart,
    '☁️': AppColors.moonSilver,
    '❄️': AppColors.chartBlue,
    '🌤️': AppColors.celestialGold,
    '🍂': AppColors.deepAmber,
    '🍁': AppColors.streakOrange,
    '☃️': AppColors.chartBlue,
    '🌞': AppColors.celestialGold,

    // Mind / Spiritual
    '🧠': AppColors.purpleAccent,
    '🧘': AppColors.amethyst,
    '🔮': AppColors.cosmicAmethyst,
    '💎': AppColors.mediumSlateBlue,
    '🕯️': AppColors.celestialGold,

    // Butterfly / Transformation
    '🦋': AppColors.auroraStart,

    // Books / Writing
    '📔': AppColors.warmTan,
    '📓': AppColors.warmTan,
    '📖': AppColors.warmTan,
    '📝': AppColors.chatAccent,
    '📚': AppColors.warmTan,
    '✍️': AppColors.warmTan,

    // Charts / Data
    '📊': AppColors.chartBlue,
    '📈': AppColors.chartGreen,

    // Search / Tools
    '🔍': AppColors.cosmic,
    '🔗': AppColors.chatAccent,

    // People / Expressions
    '🤗': AppColors.starGold,
    '😊': AppColors.starGold,
    '😌': AppColors.cosmic,
    '😴': AppColors.cosmic,
    '🥰': AppColors.softPink,
    '😤': AppColors.warmCrimson,
    '😢': AppColors.blueAccent,
    '😨': AppColors.moonSilver,
    '🤔': AppColors.celestialGold,

    // Food / Wellness
    '🍵': AppColors.greenAccent,
    '🍎': AppColors.warmCrimson,

    // Abstract / Misc
    '💭': AppColors.moonSilver,
    '🎭': AppColors.cosmicAmethyst,
    '🎯': AppColors.warmCrimson,
    '🏆': AppColors.starGold,
    '🎪': AppColors.auroraStart,
    '🎨': AppColors.auroraStart,
    '🎵': AppColors.cosmicAmethyst,
    '🏛️': AppColors.moonSilver,
    '🏛': AppColors.moonSilver,
    '🎓': AppColors.cosmic,
    '🧩': AppColors.auroraStart,
    '📦': AppColors.earthWarm,
    '👤': AppColors.moonSilver,
    '🏃': AppColors.greenAccent,
    '🗺️': AppColors.earthWarm,
    '🧭': AppColors.chatAccent,
    '🪞': AppColors.moonSilver,
    '⏰': AppColors.streakOrange,
    '🎁': AppColors.softPink,
    '🏠': AppColors.earthWarm,
    '🔔': AppColors.starGold,
    '⚙️': AppColors.moonSilver,
    '🛡️': AppColors.blueAccent,
    '🧪': AppColors.chartGreen,
    '🔑': AppColors.starGold,
    '💡': AppColors.celestialGold,
    '🎶': AppColors.cosmicAmethyst,
    '🧬': AppColors.chartGreen,
    '🌐': AppColors.blueAccent,
    '📱': AppColors.cosmic,
    '🖊️': AppColors.warmTan,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// symbolFor — Material Icon replacement helper
// ═══════════════════════════════════════════════════════════════════════════

/// 7 emojis that look better as Material Icons.
const Map<String, IconData> _materialReplacements = {
  '😴': Icons.bedtime_outlined,
  '📝': Icons.edit_note_rounded,
  '📦': Icons.category_outlined,
  '👤': Icons.person_outline_rounded,
  '🏃': Icons.directions_run_rounded,
  '💭': Icons.cloud_outlined,
  '🎭': Icons.theater_comedy_outlined,
};

/// Returns either an [AppSymbol] or a styled Material [Icon] widget,
/// depending on whether the emoji is in the 7-item replacement list.
///
/// Data layer stays untouched — only presentation changes.
Widget symbolFor(
  String emoji,
  AppSymbolSize size, {
  bool? showGlow,
  Color? accent,
}) {
  final iconData = _materialReplacements[emoji];
  if (iconData == null) {
    return AppSymbol(emoji, size: size, showGlow: showGlow, accentOverride: accent);
  }

  final resolvedAccent = accent ?? AppSymbol.accentForEmoji(emoji);
  final hasGlow = showGlow ?? size.defaultGlow;
  final isLarge = size == AppSymbolSize.xl || size == AppSymbolSize.xxl;

  return Container(
    width: size.containerSize,
    height: size.containerSize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [
          resolvedAccent.withValues(alpha: 0.15),
          resolvedAccent.withValues(alpha: 0.05),
        ],
      ),
      border: Border.all(
        color: resolvedAccent.withValues(alpha: 0.12),
        width: 0.5,
      ),
      boxShadow: hasGlow
          ? [
              BoxShadow(
                color: resolvedAccent.withValues(alpha: isLarge ? 0.25 : 0.12),
                blurRadius: isLarge ? 16 : 8,
              ),
            ]
          : null,
    ),
    child: Center(
      child: Icon(iconData, size: size.fontSize, color: resolvedAccent),
    ),
  );
}
