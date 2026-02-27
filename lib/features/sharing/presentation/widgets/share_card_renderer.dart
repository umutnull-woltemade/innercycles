// ============================================================================
// SHARE CARD RENDERER - Generic card renderer for all 21 templates
// ============================================================================
// Takes a ShareCardTemplate + ShareCardData and renders a premium
// Instagram-worthy card. Standard cards render at 1080x1080 (1:1).
// The Cycle Position card renders at 1080x1920 (9:16 Stories ratio).
// Supports dark/light variants, gradient backgrounds, mini charts,
// badge heroes, quote blocks, stat rows, and cycle position arcs.
// Includes InnerCycles watermark on every card.
// ============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/share_card_models.dart';
import '../../../../data/content/share_card_templates.dart';
import '../../../../shared/widgets/app_symbol.dart';

// ============================================================================
// MAIN RENDERER
// ============================================================================

class ShareCardRenderer extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final GlobalKey? repaintKey;
  final bool isDark;

  /// Whether the user has premium (hides watermark badge)
  final bool isPremium;

  /// Display size on screen (will be captured at 3x for 1080x1080)
  final double displaySize;

  const ShareCardRenderer({
    super.key,
    required this.template,
    required this.data,
    this.repaintKey,
    this.isDark = true,
    this.isPremium = false,
    this.displaySize = 360,
  });

  /// Whether this template uses the 9:16 Instagram Stories aspect ratio
  bool get _isStoryRatio =>
      template.layoutType == ShareCardLayout.cyclePosition;

  /// Effective card width
  double get _cardWidth => displaySize;

  /// Effective card height (9:16 for stories, 1:1 otherwise)
  double get _cardHeight =>
      _isStoryRatio ? displaySize * (16 / 9) : displaySize;

  @override
  Widget build(BuildContext context) {
    final accent = ShareCardTemplates.accentColor(template);

    // Use mood gradient override if available, otherwise use template default
    final gradientColors =
        data.moodGradientOverride ??
        (isDark
            ? template.gradientColors
            : _lightVariant(template.gradientColors));

    final card = Container(
      width: _cardWidth,
      height: _cardHeight,
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
            // Background gradient (mood-aware)
            Positioned.fill(
              child: _GradientBackground(
                colors: gradientColors,
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
              left: _cardWidth * 0.2,
              child: Container(
                width: _cardWidth * 0.6,
                height: _cardWidth * 0.4,
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
              child: _BottomWatermark(accent: accent, isPremium: isPremium),
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
      case ShareCardLayout.cyclePosition:
        return _CyclePositionLayout(
          template: template,
          data: data,
          accent: accent,
          cardWidth: _cardWidth,
        );
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
              : [AppColors.amethyst, AppColors.nebulaPurple],
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
          style: AppTypography.displayFont.copyWith(
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
          style: AppTypography.subtitle(
            fontSize: 15,
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
            style: AppTypography.elegantAccent(
              fontSize: 12,
              color: AppColors.textMuted,
            ).copyWith(height: 1.5),
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
          AppSymbol(data.statValue!, size: AppSymbolSize.xxl)
        else if (data.statValue != null)
          _HeroStat(value: data.statValue!, accent: accent)
        else
          _IconCircle(icon: template.icon, accent: accent, size: 80),

        const SizedBox(height: 16),

        // Headline
        Text(
          data.headline,
          textAlign: TextAlign.center,
          style: AppTypography.displayFont.copyWith(
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
              style: AppTypography.elegantAccent(
                fontSize: 12,
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
          style: AppTypography.subtitle(
            fontSize: 14,
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
              style: AppTypography.displayFont.copyWith(
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
          style: AppTypography.subtitle(
            fontSize: 12,
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
          style: AppTypography.displayFont.copyWith(
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
            style: AppTypography.displayFont.copyWith(
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
          style: AppTypography.subtitle(
            fontSize: 13,
            color: AppColors.textMuted,
          ).copyWith(letterSpacing: 0.5),
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
          style: AppTypography.displayFont.copyWith(
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
          style: AppTypography.subtitle(
            fontSize: 14,
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
        style: AppTypography.elegantAccent(
          fontSize: 10,
          color: color,
          letterSpacing: 0.8,
        ).copyWith(fontWeight: FontWeight.w700),
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
      style: AppTypography.displayFont.copyWith(
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
            style: AppTypography.displayFont.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 13,
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
  final bool isPremium;
  const _BottomWatermark({required this.accent, this.isPremium = false});

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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 14, left: 20, right: 20),
          child: isPremium
              // Premium: clean minimal branding
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'InnerCycles',
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                    ),
                  ),
                )
              // Free: promotional watermark — every share = free ad
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Download CTA
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: accent.withValues(alpha: 0.12),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        'Try InnerCycles — Free',
                        style: AppTypography.elegantAccent(
                          fontSize: 9,
                          color: accent,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    // Brand name
                    Text(
                      'Made with InnerCycles',
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: AppColors.textMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ============================================================================
// LAYOUT: CYCLE POSITION (Instagram Stories 9:16)
// ============================================================================

class _CyclePositionLayout extends StatelessWidget {
  final ShareCardTemplate template;
  final ShareCardData data;
  final Color accent;
  final double cardWidth;

  const _CyclePositionLayout({
    required this.template,
    required this.data,
    required this.accent,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Extract cycle day / cycle length from chartValues
    final cycleDay = data.chartValues != null && data.chartValues!.isNotEmpty
        ? data.chartValues![0]
        : 12.0;
    final cycleLength =
        data.chartValues != null && data.chartValues!.length >= 2
        ? data.chartValues![1]
        : 28.0;
    final progress = cycleLength > 0
        ? (cycleDay / cycleLength).clamp(0.0, 1.0)
        : 0.0;

    final arcSize = cardWidth * 0.55;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 3),

        // Phase label (small tag above the arc)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: accent.withValues(alpha: 0.15),
            border: Border.all(color: accent.withValues(alpha: 0.3)),
          ),
          child: Text(
            data.detail ?? 'Day ${cycleDay.toInt()} of ${cycleLength.toInt()}',
            style: AppTypography.elegantAccent(
              fontSize: 12,
              color: accent,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Circular progress arc with day count
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: progress),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, animatedProgress, child) {
            return SizedBox(
              width: arcSize,
              height: arcSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Arc painter
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CycleArcPainter(
                        progress: animatedProgress,
                        accent: accent,
                        trackOpacity: 0.12,
                        strokeWidth: 10,
                      ),
                    ),
                  ),

                  // Center content: day number + label
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${cycleDay.toInt()}',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: arcSize * 0.22,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..shader =
                                LinearGradient(
                                  colors: [
                                    accent,
                                    accent.withValues(alpha: 0.6),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    arcSize * 0.3,
                                    arcSize * 0.25,
                                  ),
                                ),
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'of ${cycleLength.toInt()}',
                        style: AppTypography.subtitle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 32),

        // Phase name (headline)
        Text(
          data.headline,
          textAlign: TextAlign.center,
          style: AppTypography.displayFont.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Accent divider
        _AccentDivider(color: accent),
        const SizedBox(height: 14),

        // Phase description (subtitle)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            data.subtitle,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subtitle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ),

        const Spacer(flex: 4),
      ],
    );
  }
}

// ============================================================================
// CYCLE ARC PAINTER - Circular progress arc for cycle position
// ============================================================================

class _CycleArcPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final Color accent;
  final double trackOpacity;
  final double strokeWidth;

  _CycleArcPainter({
    required this.progress,
    required this.accent,
    this.trackOpacity = 0.12,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth;

    // Background track
    final trackPaint = Paint()
      ..color = accent.withValues(alpha: trackOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressRect = Rect.fromCircle(center: center, radius: radius);
    final sweepAngle = 2 * math.pi * progress;

    // Gradient shader for the arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + sweepAngle,
        colors: [
          accent.withValues(alpha: 0.6),
          accent,
          accent.withValues(alpha: 0.9),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(progressRect);

    // Draw arc starting from top (-pi/2)
    canvas.drawArc(
      progressRect,
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Glow dot at the end of the arc
    if (progress > 0.01) {
      final endAngle = -math.pi / 2 + sweepAngle;
      final dotX = center.dx + radius * math.cos(endAngle);
      final dotY = center.dy + radius * math.sin(endAngle);

      // Outer glow
      final glowPaint = Paint()
        ..color = accent.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(dotX, dotY), strokeWidth * 1.2, glowPaint);

      // Inner dot
      final dotPaint = Paint()..color = accent;
      canvas.drawCircle(Offset(dotX, dotY), strokeWidth * 0.6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CycleArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.accent != accent;
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
                      style: AppTypography.elegantAccent(
                        fontSize: 10,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
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
