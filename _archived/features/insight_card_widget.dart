// ════════════════════════════════════════════════════════════════════════════
// INSIGHT CARD WIDGET - Shareable Instagram Story Card for InnerCycles
// ════════════════════════════════════════════════════════════════════════════
// Beautiful, screenshot-ready insight cards matching the cosmic theme.
// Designed for 9:16 (1080x1920) Instagram Stories aspect ratio.
// Uses RepaintBoundary for high-quality image capture via
// InstagramShareService.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

// ════════════════════════════════════════════════════════════════════════════
// INSIGHT CARD DATA MODEL
// ════════════════════════════════════════════════════════════════════════════

enum InsightCardType {
  archetype, // "My Archetype Today"
  moodPattern, // "My Week in Feelings"
  streak, // "Day X Streak"
  dreamSymbol, // "My Dream Personality"
  attachmentStyle, // "My Attachment Style"
  emotionalCycle, // "My Inner Cycle Phase"
  monthlyReview, // "Monthly Milestone"
  growthScore, // "Growth Score: X"
  weeklyTheme, // "Weekly Theme"
  moonPhase, // "Moon Phase Wisdom"
}

class InsightCardData {
  final InsightCardType type;
  final String headline;
  final String subtitle;
  final String? detail;
  final Color accentColor;
  final String? badgeText;

  const InsightCardData({
    required this.type,
    required this.headline,
    required this.subtitle,
    this.detail,
    this.accentColor = AppColors.auroraStart,
    this.badgeText,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// INSIGHT CARD WIDGET
// ════════════════════════════════════════════════════════════════════════════

class InsightCard extends StatelessWidget {
  final InsightCardData data;
  final GlobalKey repaintKey;

  const InsightCard({
    super.key,
    required this.data,
    required this.repaintKey,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: repaintKey,
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.deepSpace,
                AppColors.cosmicPurple,
                AppColors.nebulaPurple,
                AppColors.deepSpace,
              ],
              stops: [0.0, 0.35, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Star / glow overlay
              Positioned.fill(
                child: _StarGlowOverlay(accentColor: data.accentColor),
              ),

              // Accent color bar - top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        data.accentColor,
                        data.accentColor.withValues(alpha: 0.6),
                        data.accentColor,
                      ],
                    ),
                  ),
                ),
              ),

              // Badge (top-right)
              if (data.badgeText != null)
                Positioned(
                  top: 20,
                  right: 20,
                  child: _BadgePill(
                    text: data.badgeText!,
                    color: data.accentColor,
                  ),
                ),

              // Main content - centered
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 48,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // Icon for card type
                      _CardTypeIcon(
                        type: data.type,
                        accentColor: data.accentColor,
                      ),
                      const SizedBox(height: 24),

                      // Headline
                      Text(
                        data.headline,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Decorative divider
                      _AccentDivider(color: data.accentColor),
                      const SizedBox(height: 16),

                      // Subtitle
                      Text(
                        data.subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      // Detail text (optional)
                      if (data.detail != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          data.detail!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textMuted,
                            height: 1.6,
                          ),
                        ),
                      ],

                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),

              // Bottom watermark + decorative line
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomWatermark(accentColor: data.accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// INTERNAL COMPONENTS
// ════════════════════════════════════════════════════════════════════════════

/// Subtle star and glow effect overlay
class _StarGlowOverlay extends StatelessWidget {
  final Color accentColor;

  const _StarGlowOverlay({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Radial glow - top center
          Positioned(
            top: -40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.12),
                      accentColor.withValues(alpha: 0.04),
                      accentColor.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Radial glow - bottom left
          Positioned(
            bottom: -60,
            left: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.amethyst.withValues(alpha: 0.08),
                    AppColors.amethyst.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Radial glow - right middle
          Positioned(
            top: 200,
            right: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.mysticBlue.withValues(alpha: 0.10),
                    AppColors.mysticBlue.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Static stars
          CustomPaint(
            size: Size.infinite,
            painter: _InsightStarsPainter(accentColor: accentColor),
          ),
        ],
      ),
    );
  }
}

/// Paints small decorative stars on the card
class _InsightStarsPainter extends CustomPainter {
  final Color accentColor;

  _InsightStarsPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(77);
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw 40 small stars
    for (int i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = 0.4 + random.nextDouble() * 1.2;
      final opacity = 0.15 + random.nextDouble() * 0.35;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }

    // Draw 5 slightly larger accent-colored stars
    for (int i = 0; i < 5; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final starSize = 1.0 + random.nextDouble() * 1.5;
      final opacity = 0.10 + random.nextDouble() * 0.20;

      paint.color = accentColor.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, y), starSize, paint);

      // Glow around accent stars
      paint.color = accentColor.withValues(alpha: opacity * 0.4);
      canvas.drawCircle(Offset(x, y), starSize * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _InsightStarsPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor;
  }
}

/// Icon representing the card type
class _CardTypeIcon extends StatelessWidget {
  final InsightCardType type;
  final Color accentColor;

  const _CardTypeIcon({required this.type, required this.accentColor});

  IconData get _icon {
    switch (type) {
      case InsightCardType.archetype:
        return Icons.auto_awesome;
      case InsightCardType.moodPattern:
        return Icons.waves_rounded;
      case InsightCardType.streak:
        return Icons.local_fire_department_rounded;
      case InsightCardType.dreamSymbol:
        return Icons.nights_stay_rounded;
      case InsightCardType.attachmentStyle:
        return Icons.favorite_rounded;
      case InsightCardType.emotionalCycle:
        return Icons.cyclone_rounded;
      case InsightCardType.monthlyReview:
        return Icons.calendar_month_rounded;
      case InsightCardType.growthScore:
        return Icons.trending_up_rounded;
      case InsightCardType.weeklyTheme:
        return Icons.lightbulb_rounded;
      case InsightCardType.moonPhase:
        return Icons.dark_mode_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            accentColor.withValues(alpha: 0.25),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Icon(
        _icon,
        size: 34,
        color: accentColor,
      ),
    );
  }
}

/// Small accent-colored decorative divider
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

/// Badge pill (top-right corner)
class _BadgePill extends StatelessWidget {
  final String text;
  final Color color;

  const _BadgePill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.15),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Bottom watermark with decorative line
class _BottomWatermark extends StatelessWidget {
  final Color accentColor;

  const _BottomWatermark({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decorative gradient line
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withValues(alpha: 0.0),
                accentColor.withValues(alpha: 0.3),
                accentColor.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // InnerCycles watermark
        Padding(
          padding: const EdgeInsets.only(bottom: 24, right: 24),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'InnerCycles',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
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
