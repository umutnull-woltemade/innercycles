import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/services/growth_challenge_service.dart';
import '../../../data/services/instagram_share_service.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';

/// Full-screen celebration modal for challenge completions.
class ChallengeCelebrationModal extends StatefulWidget {
  final GrowthChallenge challenge;
  final bool isEn;

  const ChallengeCelebrationModal({
    super.key,
    required this.challenge,
    required this.isEn,
  });

  /// Show the celebration modal. Call after a challenge is completed.
  static void show(BuildContext context, GrowthChallenge challenge, bool isEn) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) =>
          ChallengeCelebrationModal(challenge: challenge, isEn: isEn),
    );
  }

  @override
  State<ChallengeCelebrationModal> createState() =>
      _ChallengeCelebrationModalState();
}

class _ChallengeCelebrationModalState extends State<ChallengeCelebrationModal> {
  final _boundaryKey = GlobalKey();
  bool _isSharing = false;

  GrowthChallenge get challenge => widget.challenge;
  bool get isEn => widget.isEn;

  Future<void> _shareCard() async {
    setState(() => _isSharing = true);
    try {
      final boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      final title = isEn ? challenge.titleEn : challenge.titleTr;
      await InstagramShareService.shareCosmicContent(
        boundary: boundary,
        shareText: isEn
            ? '${challenge.emoji} $title completed! — InnerCycles\n\nDiscover your patterns: ${AppConstants.appStoreUrl}'
            : '${challenge.emoji} $title tamamlandı! — InnerCycles\n\nÖrüntülerini keşfet: ${AppConstants.appStoreUrl}',
        hashtags: '#InnerCycles #ChallengeComplete',
        language: isEn ? AppLanguage.en : AppLanguage.tr,
      );
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = isEn ? challenge.titleEn : challenge.titleTr;

    return Semantics(
      label: isEn
          ? '$title challenge completed celebration'
          : '$title meydan okuma tamamlandı kutlaması',
      child: Dialog(
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
          child: RepaintBoundary(
            key: _boundaryKey,
            child: Container(
              color: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated emoji badge
                  Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.celestialGold.withValues(alpha: 0.25),
                              AppColors.auroraStart.withValues(alpha: 0.15),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.celestialGold.withValues(
                              alpha: 0.5,
                            ),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.celestialGold.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          challenge.emoji,
                          style: AppTypography.subtitle(fontSize: 48),
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

                  // Title
                  GradientText(
                        isEn
                            ? 'Challenge Completed!'
                            : 'Meydan Okuma Tamamlandı!',
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.3, end: 0, duration: 400.ms),

                  const SizedBox(height: 8),

                  // Challenge name
                  GradientText(
                    title,
                    variant: GradientTextVariant.gold,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

                  const SizedBox(height: 12),

                  // Message
                  Text(
                    isEn
                        ? 'You showed real commitment'
                        : 'Gerçek bir kararlılık gösterdin',
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

                  // Buttons row: Share + Continue
                  Row(
                        children: [
                          Expanded(
                            child: GradientOutlinedButton(
                              label: isEn ? 'Share' : 'Paylaş',
                              icon: _isSharing ? null : Icons.share_rounded,
                              variant: GradientTextVariant.gold,
                              expanded: true,
                              fontSize: 14,
                              borderRadius: 14,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              onPressed: _isSharing ? null : _shareCard,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GradientButton.gold(
                              label: isEn ? 'Continue' : 'Devam Et',
                              onPressed: () => Navigator.of(context).pop(),
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
    );
  }
}
