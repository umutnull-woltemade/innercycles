import 'zodiac_sign.dart';

/// Represents a single star in a constellation
class ConstellationStar {
  final double x; // 0.0 - 1.0 normalized coordinate
  final double y; // 0.0 - 1.0 normalized coordinate
  final double magnitude; // Apparent magnitude (lower = brighter)
  final String name; // Star name (e.g., 'Aldebaran')
  final bool isBrightest; // True for the main/glow star

  const ConstellationStar({
    required this.x,
    required this.y,
    required this.magnitude,
    required this.name,
    this.isBrightest = false,
  });

  /// Calculate star radius based on magnitude
  /// Magnitude 1.0 = larger, Magnitude 5.0 = smaller
  double getRadius(double baseSize) {
    final normalizedMag = (magnitude - 1.0) / 4.0; // 0-1 range
    final radiusFactor = 1.0 - (normalizedMag * 0.6); // 1.0 to 0.4
    return baseSize * 0.04 * radiusFactor.clamp(0.4, 1.0);
  }
}

/// Connection between two stars (index-based)
class StarConnection {
  final int from;
  final int to;

  const StarConnection(this.from, this.to);
}

/// Complete constellation pattern for a zodiac sign
class ConstellationPattern {
  final ZodiacSign sign;
  final List<ConstellationStar> stars;
  final List<StarConnection> connections;
  final int brightestStarIndex;

  const ConstellationPattern({
    required this.sign,
    required this.stars,
    required this.connections,
    required this.brightestStarIndex,
  });

  ConstellationStar get brightestStar => stars[brightestStarIndex];
}
