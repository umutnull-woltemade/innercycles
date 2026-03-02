// ════════════════════════════════════════════════════════════════════════════
// PROFILE HERO SECTION - Avatar ring, name, badge, growth score arc
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/providers/app_providers.dart';

class ProfileHeroSection extends StatefulWidget {
  final String name;
  final bool isPremium;
  final bool isDark;
  final bool isEn;
  final int growthScore;

  const ProfileHeroSection({
    super.key,
    required this.name,
    required this.isPremium,
    required this.isDark,
    required this.isEn,
    required this.growthScore,
  });

  @override
  State<ProfileHeroSection> createState() => _ProfileHeroSectionState();
}

class _ProfileHeroSectionState extends State<ProfileHeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _loadPhoto();
  }

  Future<void> _loadPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_avatar_path');
    if (path != null && File(path).existsSync() && mounted) {
      setState(() => _photoPath = path);
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (xFile == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final dest = '${dir.path}/profile_avatar.jpg';
    await File(xFile.path).copy(dest);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_avatar_path', dest);
    if (mounted) setState(() => _photoPath = dest);
  }

  String _getInitials() {
    if (widget.name.isEmpty) return '';
    final parts = widget.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return widget.name[0].toUpperCase();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(widget.isEn);
    return Column(
      children: [
        // Animated avatar with rotating aurora ring
        AnimatedBuilder(
          animation: _ringController,
          builder: (context, child) {
            return Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  transform: GradientRotation(
                    _ringController.value * 2 * math.pi,
                  ),
                  colors: const [
                    AppColors.auroraStart,
                    AppColors.auroraEnd,
                    AppColors.starGold,
                    AppColors.auroraStart,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: child,
            );
          },
          child: GestureDetector(
            onTap: _pickPhoto,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isDark
                    ? AppColors.deepSpace
                    : AppColors.lightBackground,
              ),
              child: _photoPath != null
                  ? ClipOval(
                      child: Image.file(
                        File(_photoPath!),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: widget.name.isNotEmpty
                          ? Text(
                              _getInitials(),
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppColors.auroraStart,
                              ),
                            )
                          : const AppSymbol.hero('\u{2728}'),
                    ),
            ),
          ),
        ).glassEntrance(context: context),

        const SizedBox(height: AppConstants.spacingLg),

        // Name + membership badge
        Column(
          children: [
            GradientText(
              widget.name,
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                gradient: widget.isPremium
                    ? const LinearGradient(
                        colors: [AppColors.starGold, AppColors.celestialGold],
                      )
                    : null,
                color: widget.isPremium
                    ? null
                    : (widget.isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06)),
                border: widget.isPremium
                    ? null
                    : Border.all(
                        color: widget.isDark
                            ? Colors.white.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
              ),
              child: Text(
                widget.isPremium ? 'PRO' : 'FREE',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: widget.isPremium
                      ? AppColors.deepSpace
                      : (widget.isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ).glassReveal(
          context: context,
          delay: const Duration(milliseconds: 100),
        ),

        const SizedBox(height: AppConstants.spacingXl),

        // Growth Score Arc
        GestureDetector(
          onTap: () => context.push(Routes.streakStats),
          child: Semantics(
            label: widget.isEn
                ? 'Growth score ${widget.growthScore}. Tap for details'
                : 'Geli\u015fim puan\u0131 ${widget.growthScore}. Detaylar i\u00e7in dokun',
            button: true,
            child: SizedBox(
              width: 160,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(160, 100),
                    painter: _GrowthArcPainter(
                      score: widget.growthScore,
                      isDark: widget.isDark,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: Text(
                      '${widget.growthScore}',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.auroraStart,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    child: Text(
                      L10nService.get('profile.profile_hero.growth_score', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).glassReveal(
          context: context,
          delay: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class _GrowthArcPainter extends CustomPainter {
  final int score;
  final bool isDark;

  const _GrowthArcPainter({required this.score, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 4);
    final radius = size.width / 2 - 8;

    // Background arc (180°)
    final bgPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Score arc
    if (score > 0) {
      final sweepAngle = (score / 100) * math.pi;
      final rect = Rect.fromCircle(center: center, radius: radius);
      final scorePaint = Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.auroraStart, AppColors.auroraEnd],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, math.pi, sweepAngle, false, scorePaint);
    }
  }

  @override
  bool shouldRepaint(_GrowthArcPainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.isDark != isDark;
}
