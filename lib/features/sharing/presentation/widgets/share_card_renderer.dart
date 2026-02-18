// ============================================================================
// SHARE CARD RENDERER - Generic card renderer for all 20 templates
// ============================================================================
// Takes a ShareCardTemplate + ShareCardData and renders a premium
// Instagram-worthy card at 1080x1080. Supports dark/light variants,
// gradient backgrounds, mini charts, badge heroes, quote blocks, and
// stat rows. Includes InnerCycles watermark on every card.
// ============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/share_card_models.dart';
import '../../../../data/content/share_card_templates.dart';

// ============================================================================
// MAIN RENDERER
// ============================================================================

class ShareCardRenderer extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final GlobalKey? repaintKey;
  final bool isDark;

  /// Display size on screen (will be captured at 3x for 1080x1080)
  final double displaySize;

  const ShareCardRenderer({
    super.key,
    required this.template,
    required this.data,
    this.repaintKey,
    this.isDark = true,
    this.displaySize = 360,
  });

  @override
  Widget build(BuildContext context) {
    final accent = ShareCardTemplates.accentColor(template);

    final card = Container(
      width: displaySize,
      height: displaySize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: _GradientBackground(
                colors: isDark
                    ? template.gradientColors
                    : _lightVariant(template.gradientColors),
                accent: accent,
              ),
            ),

            // Stars overlay
            Positioned.fill(
              child: CustomPaint(painter: _CardStarsPainter(accent: accent)),
            ),

            // Accent glow - top
            Positioned(
              top: -40,
              left: displaySize * 0.2,
              child: Container(
                width: displaySize * 0.6,
                height: displaySize * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accent.withValues(alpha: 0.12),
                      accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),

            // Top accent bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      accent.withValues(alpha: 0.8),
                      accent.withValues(alpha: 0.3),
                      accent.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),

            // Badge pill
            Positioned(
              top: 20,
              right: 20,
              child: _BadgePill(text: template.badge(true), color: accent),
            ),

            // Main content by layout type
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 40,
                ),
                child: _buildLayout(accent),
              ),
            ),

            // Bottom watermark + divider
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _BottomWatermark(accent: accent),
            ),
          ],
        ),
      ),
    );

    if (repaintKey != null) {
      return RepaintBoundary(key: repaintKey, child: card);
    }
    return card;
  }

  Widget _buildLayout(Color accent) {
    switch (template.layoutType) {
      case ShareCardLayout.centered:
        return _CenteredLayout(template: template, data: data, accent: accent);
      case ShareCardLayout.badgeHero:
        return _BadgeHeroLayout(template: template, data: data, accent: accent);
      case ShareCardLayout.miniChart:
        return _MiniChartLayout(template: template, data: data, accent: accent);
      case ShareCardLayout.quoteBlock:
        return _QuoteBlockLayout(
          template: template,
          data: data,
          accent: accent,
        );
      case ShareCardLayout.statRow:
        return _StatRowLayout(template: template, data: data, accent: accent);
    }
  }

  List<Color> _lightVariant(List<Color> colors) {
    return colors.map((c) {
      final hsl = HSLColor.fromColor(c);
      return hsl
          .withLightness((hsl.lightness + 0.55).clamp(0.0, 0.95))
          .withSaturation((hsl.saturation * 0.4).clamp(0.0, 1.0))
          .toColor();
    }).toList();
  }
}

// ============================================================================
// GRADIENT BACKGROUND
// ============================================================================

class _GradientBackground extends StatelessWidget {
  final List<Color> colors;
  final Color accent;

  const _GradientBackground({required this.colors, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors.length >= 2
              ? colors
              : colors.isNotEmpty
              ? [colors.first, colors.first.withValues(alpha: 0.8)]
              : [AppColors.cosmicPurple, AppColors.nebulaPurple],
        ),
      ),
    );
  }
}

// ============================================================================
// LAYOUT: CENTERED (Identity cards)
// ============================================================================

class _CenteredLayout extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final Color accent;

  const _CenteredLayout({
    required this.template,
    required this.data,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Icon circle
        _IconCircle(icon: template.icon, accent: accent),
        const SizedBox(height: 20),

        // Headline
        Text(
          data.headline,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Divider
        _AccentDivider(color: accent),
        const SizedBox(height: 12),

        // Subtitle
        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),

        // Detail
        if (data.detail != null) ...[
          const SizedBox(height: 10),
          Text(
            data.detail!,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],

        const Spacer(flex: 3),
      ],
    );
  }
}

// ============================================================================
// LAYOUT: BADGE HERO (Streak, milestones, top emotion)
// ============================================================================

class _BadgeHeroLayout extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final Color accent;

  const _BadgeHeroLayout({
    required this.template,
    required this.data,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final isEmoji =
        data.statValue != null &&
        data.statValue!.length <= 2 &&
        !RegExp(r'^[0-9+\-]+$').hasMatch(data.statValue!);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Large stat or icon
        if (isEmoji)
          Text(data.statValue!, style: const TextStyle(fontSize: 64))
        else if (data.statValue != null)
          _HeroStat(value: data.statValue!, accent: accent)
        else
          _IconCircle(icon: template.icon, accent: accent, size: 80),

        const SizedBox(height: 16),

        // Headline
        Text(
          data.headline,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        // Stat label
        if (data.statLabel != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: accent.withValues(alpha: 0.15),
              border: Border.all(color: accent.withValues(alpha: 0.3)),
            ),
            child: Text(
              data.statLabel!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: accent,
                letterSpacing: 0.5,
              ),
            ),
          ),
        const SizedBox(height: 12),

        // Subtitle
        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),

        const Spacer(flex: 3),
      ],
    );
  }
}

// ============================================================================
// LAYOUT: MINI CHART (Mood wave, radar, sleep)
// ============================================================================

class _MiniChartLayout extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final Color accent;

  const _MiniChartLayout({
    required this.template,
    required this.data,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Icon + title row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(template.icon, color: accent, size: 22),
            const SizedBox(width: 8),
            Text(
              data.headline,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 20),

        // Chart area
        SizedBox(
          height: 120,
          child: data.chartValues != null && data.chartValues!.isNotEmpty
              ? _MiniBarChart(
                  values: data.chartValues!,
                  labels: data.chartLabels,
                  accent: accent,
                )
              : const SizedBox.shrink(),
        ),

        const Spacer(flex: 3),
      ],
    );
  }
}

// ============================================================================
// LAYOUT: QUOTE BLOCK (Wisdom cards)
// ============================================================================

class _QuoteBlockLayout extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final Color accent;

  const _QuoteBlockLayout({
    required this.template,
    required this.data,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Opening quote mark
        Text(
          '\u{201C}',
          style: GoogleFonts.playfairDisplay(
            fontSize: 64,
            fontWeight: FontWeight.w700,
            color: accent.withValues(alpha: 0.5),
            height: 0.8,
          ),
        ),
        const SizedBox(height: 8),

        // Quote text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            data.headline,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Divider
        _AccentDivider(color: accent),
        const SizedBox(height: 12),

        // Attribution / subtitle
        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),

        const Spacer(flex: 3),
      ],
    );
  }
}

// ============================================================================
// LAYOUT: STAT ROW (Consistency, growth journey)
// ============================================================================

class _StatRowLayout extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final Color accent;

  const _StatRowLayout({
    required this.template,
    required this.data,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Icon
        _IconCircle(icon: template.icon, accent: accent),
        const SizedBox(height: 16),

        // Headline
        Text(
          data.headline,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),

        // Stat pill row
        if (data.statValue != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatPill(
                value: data.statValue!,
                label: data.statLabel ?? '',
                accent: accent,
              ),
            ],
          ),
        const SizedBox(height: 14),

        // Subtitle
        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),

        const Spacer(flex: 3),
      ],
    );
  }
}

// ============================================================================
// SHARED COMPONENTS
// ============================================================================

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final double size;

  const _IconCircle({required this.icon, required this.accent, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            accent.withValues(alpha: 0.25),
            accent.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Icon(icon, size: size * 0.45, color: accent),
    );
  }
}

class _AccentDivider extends StatelessWidget {
  final Color color;
  const _AccentDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.0),
                color.withValues(alpha: 0.5),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 24,
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.5),
                color.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BadgePill extends StatelessWidget {
  final String text;
  final Color color;

  const _BadgePill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final Color accent;

  const _HeroStat({required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 64,
        fontWeight: FontWeight.w900,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: [accent, accent.withValues(alpha: 0.6)],
          ).createShader(const Rect.fromLTWH(0, 0, 200, 80)),
        height: 1.0,
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final Color accent;

  const _StatPill({
    required this.value,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: accent.withValues(alpha: 0.12),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomWatermark extends StatelessWidget {
  final Color accent;
  const _BottomWatermark({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gradient divider line
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: 0.0),
                accent.withValues(alpha: 0.3),
                accent.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.only(bottom: 18, right: 20),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'InnerCycles',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// MINI BAR CHART
// ============================================================================

class _MiniBarChart extends StatelessWidget {
  final List<double> values;
  final List<String>? labels;
  final Color accent;

  const _MiniBarChart({
    required this.values,
    this.labels,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = values.isEmpty
        ? 5.0
        : values.reduce((a, b) => a > b ? a : b);
    final normalised = values
        .map((v) => maxVal > 0 ? v / maxVal : 0.0)
        .toList();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(values.length, (i) {
            // Stagger each bar with a slight delay factor
            final barProgress = (progress - (i * 0.08)).clamp(0.0, 1.0);
            final height = 20.0 + normalised[i] * 80 * barProgress;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 28,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        accent.withValues(alpha: 0.8),
                        accent.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                if (labels != null && i < labels!.length)
                  Opacity(
                    opacity: barProgress,
                    child: Text(
                      labels![i],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            );
          }),
        );
      },
    );
  }
}

// ============================================================================
// STARS PAINTER
// ============================================================================

class _CardStarsPainter extends CustomPainter {
  final Color accent;
  _CardStarsPainter({required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(91);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 35; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = 0.4 + random.nextDouble() * 1.0;
      final opacity = 0.15 + random.nextDouble() * 0.3;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }

    // A few accent-colored stars
    for (int i = 0; i < 4; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = 0.8 + random.nextDouble() * 1.2;
      final opacity = 0.10 + random.nextDouble() * 0.15;

      paint.color = accent.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);
      paint.color = accent.withValues(alpha: opacity * 0.3);
      canvas.drawCircle(Offset(x, y), starSize * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CardStarsPainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}
