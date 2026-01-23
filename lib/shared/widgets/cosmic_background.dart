import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CosmicBackground extends StatelessWidget {
  final Widget child;
  final bool showStars;
  final bool showGradient;

  const CosmicBackground({
    super.key,
    required this.child,
    this.showStars = true,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode - clean, soft gradient background
    if (!isDark) {
      return Container(
        decoration: BoxDecoration(
          gradient: showGradient
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.lightBackground,
                    AppColors.lightSurfaceVariant,
                  ],
                )
              : null,
          color: showGradient ? null : AppColors.lightBackground,
        ),
        child: child,
      );
    }

    // Dark mode - GÜZEL KOZMİK ARKA PLAN
    return Stack(
      children: [
        // Ana kozmik arka plan - nebula ve yıldızlar
        const Positioned.fill(
          child: IgnorePointer(
            child: _BeautifulCosmicBackground(),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// GÜZEL KOZMİK ARKA PLAN - Nebula, yıldızlar, ışık efektleri
// ═══════════════════════════════════════════════════════════════════════════
class _BeautifulCosmicBackground extends StatelessWidget {
  const _BeautifulCosmicBackground();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: const _CosmicPainter(),
        willChange: false,
        isComplex: true,
      ),
    );
  }
}

class _CosmicPainter extends CustomPainter {
  const _CosmicPainter();

  // Sabit veriler - her zaman aynı
  static final List<_Star> _stars = _generateStars();
  static final List<_Nebula> _nebulas = _generateNebulas();
  static final List<_GlowOrb> _glowOrbs = _generateGlowOrbs();

  static List<_Star> _generateStars() {
    final random = math.Random(42);
    final stars = <_Star>[];

    // 200 yıldız - farklı boyut ve parlaklıkta
    for (int i = 0; i < 200; i++) {
      final size = random.nextDouble();
      stars.add(_Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: size < 0.7 ? 0.5 + random.nextDouble() * 1.0 : 1.5 + random.nextDouble() * 2.5,
        opacity: 0.3 + random.nextDouble() * 0.7,
        hasGlow: size > 0.85, // Büyük yıldızlarda glow efekti
        color: _getStarColor(random),
      ));
    }
    return stars;
  }

  static Color _getStarColor(math.Random random) {
    final colors = [
      Colors.white,
      Colors.white,
      Colors.white,
      const Color(0xFFFFE4B5), // Sıcak sarı
      const Color(0xFFADD8E6), // Açık mavi
      const Color(0xFFFFB6C1), // Pembe
      const Color(0xFFE6E6FA), // Lavanta
    ];
    return colors[random.nextInt(colors.length)];
  }

  static List<_Nebula> _generateNebulas() {
    return [
      // Mor nebula - sol üst
      _Nebula(
        x: 0.15,
        y: 0.2,
        radiusX: 0.4,
        radiusY: 0.3,
        color: const Color(0xFF9C27B0),
        opacity: 0.15,
      ),
      // Pembe nebula - sağ orta
      _Nebula(
        x: 0.85,
        y: 0.4,
        radiusX: 0.35,
        radiusY: 0.45,
        color: const Color(0xFFE91E63),
        opacity: 0.12,
      ),
      // Mavi nebula - alt
      _Nebula(
        x: 0.5,
        y: 0.85,
        radiusX: 0.5,
        radiusY: 0.3,
        color: const Color(0xFF3F51B5),
        opacity: 0.1,
      ),
      // Turkuaz nebula - orta
      _Nebula(
        x: 0.3,
        y: 0.6,
        radiusX: 0.25,
        radiusY: 0.35,
        color: const Color(0xFF00BCD4),
        opacity: 0.08,
      ),
      // Altın nebula - sağ üst
      _Nebula(
        x: 0.8,
        y: 0.15,
        radiusX: 0.2,
        radiusY: 0.2,
        color: const Color(0xFFFFD700),
        opacity: 0.06,
      ),
    ];
  }

  static List<_GlowOrb> _generateGlowOrbs() {
    return [
      // Büyük mor ışık
      _GlowOrb(x: 0.1, y: 0.3, size: 0.15, color: const Color(0xFF9C27B0), opacity: 0.3),
      // Pembe ışık
      _GlowOrb(x: 0.9, y: 0.5, size: 0.12, color: const Color(0xFFE91E63), opacity: 0.25),
      // Mavi ışık
      _GlowOrb(x: 0.5, y: 0.9, size: 0.18, color: const Color(0xFF2196F3), opacity: 0.2),
      // Turkuaz ışık
      _GlowOrb(x: 0.2, y: 0.7, size: 0.1, color: const Color(0xFF00BCD4), opacity: 0.2),
      // Altın ışık
      _GlowOrb(x: 0.75, y: 0.2, size: 0.08, color: const Color(0xFFFFD700), opacity: 0.15),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Derin uzay gradient arka planı
    _drawSpaceGradient(canvas, size);

    // 2. Nebula bulutları
    _drawNebulas(canvas, size);

    // 3. Parlak ışık küreleri
    _drawGlowOrbs(canvas, size);

    // 4. Yıldızlar
    _drawStars(canvas, size);
  }

  void _drawSpaceGradient(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = ui.Gradient.linear(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.7, size.height),
      [
        const Color(0xFF0D0D1A), // Derin uzay siyahı
        const Color(0xFF1A1A2E), // Koyu mor
        const Color(0xFF16213E), // Lacivert
        const Color(0xFF1A1A2E), // Koyu mor
        const Color(0xFF0F0F1A), // Derin siyah
      ],
      [0.0, 0.25, 0.5, 0.75, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient);
  }

  void _drawNebulas(Canvas canvas, Size size) {
    for (final nebula in _nebulas) {
      final center = Offset(nebula.x * size.width, nebula.y * size.height);
      final radiusX = nebula.radiusX * size.width;
      final radiusY = nebula.radiusY * size.height;

      final gradient = ui.Gradient.radial(
        center,
        math.max(radiusX, radiusY),
        [
          nebula.color.withOpacity(nebula.opacity),
          nebula.color.withOpacity(nebula.opacity * 0.5),
          nebula.color.withOpacity(0),
        ],
        [0.0, 0.5, 1.0],
      );

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(1.0, radiusY / radiusX);
      canvas.translate(-center.dx, -center.dy);

      canvas.drawCircle(
        center,
        radiusX,
        Paint()
          ..shader = gradient
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50),
      );
      canvas.restore();
    }
  }

  void _drawGlowOrbs(Canvas canvas, Size size) {
    for (final orb in _glowOrbs) {
      final center = Offset(orb.x * size.width, orb.y * size.height);
      final radius = orb.size * size.width;

      final gradient = ui.Gradient.radial(
        center,
        radius,
        [
          orb.color.withOpacity(orb.opacity),
          orb.color.withOpacity(orb.opacity * 0.3),
          orb.color.withOpacity(0),
        ],
        [0.0, 0.4, 1.0],
      );

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = gradient
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
      );
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final star in _stars) {
      final center = Offset(star.x * size.width, star.y * size.height);

      // Glow efekti olan yıldızlar için
      if (star.hasGlow) {
        canvas.drawCircle(
          center,
          star.size * 3,
          Paint()
            ..color = star.color.withOpacity(star.opacity * 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      // Ana yıldız
      paint.color = star.color.withOpacity(star.opacity);
      canvas.drawCircle(center, star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CosmicPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// VERİ MODELLERİ
// ═══════════════════════════════════════════════════════════════════════════

class _Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final bool hasGlow;
  final Color color;

  const _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.hasGlow,
    required this.color,
  });
}

class _Nebula {
  final double x;
  final double y;
  final double radiusX;
  final double radiusY;
  final Color color;
  final double opacity;

  const _Nebula({
    required this.x,
    required this.y,
    required this.radiusX,
    required this.radiusY,
    required this.color,
    required this.opacity,
  });
}

class _GlowOrb {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double opacity;

  const _GlowOrb({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.opacity,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// LEGACY WIDGET'LAR - Uyumluluk için
// ═══════════════════════════════════════════════════════════════════════════

class StarField extends StatelessWidget {
  const StarField({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BeautifulCosmicBackground();
  }
}

class StaticStarField extends StatelessWidget {
  const StaticStarField({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BeautifulCosmicBackground();
  }
}

class GlowingOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double blurRadius;

  const GlowingOrb({
    super.key,
    required this.color,
    this.size = 200,
    this.blurRadius = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: blurRadius,
            spreadRadius: blurRadius / 2,
          ),
        ],
      ),
    );
  }
}
