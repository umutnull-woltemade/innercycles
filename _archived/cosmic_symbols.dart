/// Cosmic Symbols - Web-safe unicode symbols for Venus One
/// These symbols work across all platforms including web browsers
///
/// IMPORTANT: Avoid emojis (like 🔮, ✨, 🌙) as they render inconsistently on web.
/// Use these unicode characters or Material Icons instead.
class CosmicSymbols {
  CosmicSymbols._();

  // ═══════════════════════════════════════════════════════════════════════════
  // STARS & CELESTIAL - Works on all platforms
  // ═══════════════════════════════════════════════════════════════════════════

  /// Filled star ★
  static const String star = '★';

  /// Empty star ☆
  static const String starEmpty = '☆';

  /// Sun symbol ☉
  static const String sun = '☉';

  /// Moon crescent ☽
  static const String moon = '☽';

  /// Full moon ○
  static const String moonFull = '○';

  /// New moon ●
  static const String moonNew = '●';

  // ═══════════════════════════════════════════════════════════════════════════
  // ZODIAC SIGNS - Universal unicode
  // ═══════════════════════════════════════════════════════════════════════════

  static const String aries = '♈';
  static const String taurus = '♉';
  static const String gemini = '♊';
  static const String cancer = '♋';
  static const String leo = '♌';
  static const String virgo = '♍';
  static const String libra = '♎';
  static const String scorpio = '♏';
  static const String sagittarius = '♐';
  static const String capricorn = '♑';
  static const String aquarius = '♒';
  static const String pisces = '♓';

  // ═══════════════════════════════════════════════════════════════════════════
  // PLANETS - Astronomical symbols
  // ═══════════════════════════════════════════════════════════════════════════

  static const String mercury = '☿';
  static const String venus = '♀';
  static const String mars = '♂';
  static const String jupiter = '♃';
  static const String saturn = '♄';
  static const String uranus = '♅';
  static const String neptune = '♆';
  static const String pluto = '♇';

  // ═══════════════════════════════════════════════════════════════════════════
  // DECORATIVE - Safe unicode symbols
  // ═══════════════════════════════════════════════════════════════════════════

  /// Diamond ◆
  static const String diamond = '◆';

  /// Diamond empty ◇
  static const String diamondEmpty = '◇';

  /// Circle filled ●
  static const String circle = '●';

  /// Circle empty ○
  static const String circleEmpty = '○';

  /// Triangle ▲
  static const String triangle = '▲';

  /// Triangle down ▼
  static const String triangleDown = '▼';

  /// Square ■
  static const String square = '■';

  /// Square empty □
  static const String squareEmpty = '□';

  /// Bullet •
  static const String bullet = '•';

  /// Infinity ∞
  static const String infinity = '∞';

  /// Cross ✕
  static const String cross = '✕';

  /// Check ✓
  static const String check = '✓';

  // ═══════════════════════════════════════════════════════════════════════════
  // MYSTICAL - Safe alternatives
  // ═══════════════════════════════════════════════════════════════════════════

  /// Sparkle (4-pointed) ✦
  static const String sparkle = '✦';

  /// Sparkle empty ✧
  static const String sparkleEmpty = '✧';

  /// Asterisk ✱
  static const String asterisk = '✱';

  /// Flower ✿
  static const String flower = '✿';

  /// Heart ♥
  static const String heart = '♥';

  /// Heart empty ♡
  static const String heartEmpty = '♡';

  /// Yin yang ☯
  static const String yinYang = '☯';

  /// Om ॐ
  static const String om = 'ॐ';

  /// Ankh ☥
  static const String ankh = '☥';

  // ═══════════════════════════════════════════════════════════════════════════
  // ARROWS & MISC
  // ═══════════════════════════════════════════════════════════════════════════

  static const String arrowRight = '→';
  static const String arrowLeft = '←';
  static const String arrowUp = '↑';
  static const String arrowDown = '↓';
  static const String arrowDouble = '↔';

  /// Decorative line ═
  static const String line = '═';

  /// Separator ·
  static const String separator = '·';

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY ICONS - For section headers
  // ═══════════════════════════════════════════════════════════════════════════

  /// For horoscopes/zodiac ★
  static const String categoryZodiac = '★';

  /// For moon/dreams ☽
  static const String categoryDream = '☽';

  /// For mystical/spiritual ✦
  static const String categoryMystical = '✦';

  /// For energy/chakra ◆
  static const String categoryEnergy = '◆';

  /// For numerology ∞
  static const String categoryNumerology = '∞';

  /// For compatibility ♥
  static const String categoryLove = '♥';

  /// For warning/attention ▲
  static const String categoryWarning = '▲';

  /// For info ○
  static const String categoryInfo = '○';

  // ═══════════════════════════════════════════════════════════════════════════
  // DECORATIVE COMBINATIONS - For titles
  // ═══════════════════════════════════════════════════════════════════════════

  /// "✦ Title ✦"
  static String decorateTitle(String title) => '✦ $title ✦';

  /// "★ Title"
  static String starTitle(String title) => '★ $title';

  /// "☽ Title"
  static String moonTitle(String title) => '☽ $title';

  /// "• Item"
  static String bulletItem(String item) => '• $item';
}
