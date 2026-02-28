import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/services/milestone_service.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/providers/app_providers.dart';

/// Full-screen celebration modal for any badge/milestone unlock.
/// Shows confetti particles, animated emoji, haptic feedback.
class BadgeCelebrationModal extends StatefulWidget {
  final Milestone milestone;
  final bool isEn;

  const BadgeCelebrationModal({
    super.key,
    required this.milestone,
    required this.isEn,
  });

  /// Show the celebration modal for a newly earned badge.
  static void show(BuildContext context, Milestone milestone, bool isEn) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) =>
          BadgeCelebrationModal(milestone: milestone, isEn: isEn),
    );
  }

  /// Show celebrations for multiple badges, one after another.
  static Future<void> showSequential(
    BuildContext context,
    List<Milestone> milestones,
    bool isEn,
  ) async {
    for (final m in milestones) {
      if (!context.mounted) return;
      HapticFeedback.heavyImpact();
      await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (_) => BadgeCelebrationModal(milestone: m, isEn: isEn),
      );
    }
  }

  @override
  State<BadgeCelebrationModal> createState() => _BadgeCelebrationModalState();
}

class _BadgeCelebrationModalState extends State<BadgeCelebrationModal>
    with TickerProviderStateMixin {
  late final AnimationController _confettiController;

  Milestone get milestone => widget.milestone;
  bool get isEn => widget.isEn;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _share() {
    HapticFeedback.lightImpact();
    final name = isEn ? milestone.nameEn : milestone.nameTr;
    final desc = isEn ? milestone.descriptionEn : milestone.descriptionTr;
    final text = isEn
        ? '${milestone.emoji} Badge Unlocked: $name\n\n$desc\n\n'
          'Track your growth: ${AppConstants.appStoreUrl}\n'
          '#InnerCycles #BadgeUnlocked #Journaling'
        : '${milestone.emoji} Rozet Kazanıldı: $name\n\n$desc\n\n'
          'Gelişimini takip et: ${AppConstants.appStoreUrl}\n'
          '#InnerCycles #RozetKazanıldı #Günlük';
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = isEn ? milestone.nameEn : milestone.nameTr;
    final desc = isEn ? milestone.descriptionEn : milestone.descriptionTr;
    final category = milestone.category.localizedName(isEn);

    return Semantics(
      label: isEn
          ? 'Badge unlocked: $name'
          : 'Rozet kazanıldı: $name',
      child: Stack(
        children: [
          // Confetti layer
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _confettiController,
                builder: (context, _) => CustomPaint(
                  painter: _ConfettiPainter(
                    progress: _confettiController.value,
                    color1: AppColors.starGold,
                    color2: AppColors.amethyst,
                    color3: AppColors.celestialGold,
                  ),
                ),
              ),
            ),
          ),

          // Dialog content
          Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: (isDark
                            ? AppColors.surfaceDark
                            : AppColors.lightSurface)
                        .withValues(alpha: isDark ? 0.82 : 0.90),
                    borderRadius: BorderRadius.circular(28),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.starGold.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.starGold.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 36,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge emoji in glowing circle
                      Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.starGold.withValues(alpha: 0.25),
                                  AppColors.auroraStart.withValues(alpha: 0.15),
                                ],
                              ),
                              border: Border.all(
                                color:
                                    AppColors.starGold.withValues(alpha: 0.5),
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.starGold
                                      .withValues(alpha: 0.3),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              milestone.emoji,
                              style: const TextStyle(fontSize: 44),
                            ),
                          )
                          .animate()
                          .scale(
                            begin: const Offset(0.3, 0.3),
                            end: const Offset(1, 1),
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          )
                          .fadeIn(duration: 300.ms),

                      const SizedBox(height: 24),

                      // Badge name
                      GradientText(
                            name,
                            variant: GradientTextVariant.gold,
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                          .animate(delay: 200.ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.3, end: 0, duration: 400.ms),

                      const SizedBox(height: 6),

                      // Category chip
                      Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  AppColors.starGold.withValues(alpha: 0.12),
                            ),
                            child: Text(
                              category,
                              style: AppTypography.elegantAccent(
                                fontSize: 11,
                                color: AppColors.starGold,
                              ),
                            ),
                          )
                          .animate(delay: 300.ms)
                          .fadeIn(duration: 300.ms),

                      const SizedBox(height: 14),

                      // Description
                      Text(
                        desc,
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 15,
                          color: isDark
                              ? Colors.white70
                              : AppColors.textDark.withValues(alpha: 0.7),
                        ),
                      ).animate(delay: 350.ms).fadeIn(duration: 400.ms),

                      // InnerCycles watermark
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: isDark
                                ? Colors.white24
                                : AppColors.textDark.withValues(alpha: 0.3),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'InnerCycles',
                            style: AppTypography.elegantAccent(
                              fontSize: 11,
                              letterSpacing: 1.5,
                              color: isDark
                                  ? Colors.white24
                                  : AppColors.textDark.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Buttons: Share + Continue
                      Row(
                            children: [
                              Expanded(
                                child: GradientOutlinedButton(
                                  label: L10nService.get('milestones.badge_celebration.share', isEn ? AppLanguage.en : AppLanguage.tr),
                                  icon: Icons.share_rounded,
                                  variant: GradientTextVariant.gold,
                                  expanded: true,
                                  fontSize: 14,
                                  borderRadius: 14,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  onPressed: _share,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GradientButton.gold(
                                  label: L10nService.get('milestones.badge_celebration.keep_going', isEn ? AppLanguage.en : AppLanguage.tr),
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  expanded: true,
                                ),
                              ),
                            ],
                          )
                          .animate(delay: 500.ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.2, end: 0, duration: 400.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// CONFETTI PAINTER - burst of particles on badge unlock
// ════════════════════════════════════════════════════════════════════════════════

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final Color color1;
  final Color color2;
  final Color color3;

  static final List<_Particle> _particles = _generateParticles();

  _ConfettiPainter({
    required this.progress,
    required this.color1,
    required this.color2,
    required this.color3,
  });

  static List<_Particle> _generateParticles() {
    final random = Random(42);
    return List.generate(60, (i) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 0.3 + random.nextDouble() * 0.7;
      final size = 3.0 + random.nextDouble() * 5.0;
      final colorIndex = random.nextInt(3);
      final rotationSpeed = (random.nextDouble() - 0.5) * 4;
      return _Particle(
        angle: angle,
        speed: speed,
        size: size,
        colorIndex: colorIndex,
        rotationSpeed: rotationSpeed,
        shape: random.nextInt(3), // 0=circle, 1=rect, 2=diamond
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final centerX = size.width / 2;
    final centerY = size.height * 0.35; // burst from badge area
    final maxRadius = size.height * 0.6;

    final fadeOut = progress > 0.7 ? (1.0 - progress) / 0.3 : 1.0;
    final colors = [color1, color2, color3];

    for (final p in _particles) {
      final dist = maxRadius * p.speed * progress;
      final gravity = progress * progress * 80; // gravity pull
      final x = centerX + cos(p.angle) * dist;
      final y = centerY + sin(p.angle) * dist + gravity;

      final alpha = (fadeOut * 0.8).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = colors[p.colorIndex].withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotationSpeed * progress * pi);

      switch (p.shape) {
        case 0: // circle
          canvas.drawCircle(Offset.zero, p.size / 2, paint);
        case 1: // rectangle
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.5,
            ),
            paint,
          );
        default: // diamond
          final path = Path()
            ..moveTo(0, -p.size / 2)
            ..lineTo(p.size / 3, 0)
            ..lineTo(0, p.size / 2)
            ..lineTo(-p.size / 3, 0)
            ..close();
          canvas.drawPath(path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final int colorIndex;
  final double rotationSpeed;
  final int shape;

  const _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.colorIndex,
    required this.rotationSpeed,
    required this.shape,
  });
}
