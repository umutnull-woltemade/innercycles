import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/services/streak_service.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../data/content/share_card_templates.dart';
import '../../../data/models/share_card_models.dart';
import '../../../shared/widgets/share_card_sheet.dart';
import '../../../data/services/l10n_service.dart';

/// Full-screen celebration modal for streak milestones (D3, D7, D14, etc.)
class MilestoneCelebrationModal extends StatefulWidget {
  final int streakDays;
  final AppLanguage language;
  bool get isEn => language.isEn;
  final bool isPremium;

  const MilestoneCelebrationModal({
    super.key,
    required this.streakDays,
    required this.language,
    this.isPremium = false,
  });

  /// Show the celebration modal. Call after saving an entry.
  static void show(BuildContext context, int days, AppLanguage language, {bool isPremium = false}) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => MilestoneCelebrationModal(
        streakDays: days,
        language: language,
        isPremium: isPremium,
      ),
    );
  }

  @override
  State<MilestoneCelebrationModal> createState() =>
      _MilestoneCelebrationModalState();
}

class _MilestoneCelebrationModalState extends State<MilestoneCelebrationModal> {
  final _boundaryKey = GlobalKey();
  final bool _isSharing = false;

  int get streakDays => widget.streakDays;
  bool get isEn => widget.isEn;
  bool get isPremium => widget.isPremium;

  Future<void> _shareCard() async {
    // Open the visual share card gallery for a higher-quality, branded share
    if (!mounted) return;
    Navigator.of(context).pop(); // close celebration first
    if (!context.mounted) return;
    await ShareCardSheet.show(
      context,
      template: ShareCardTemplates.streakFlame,
      data: ShareCardData(
        headline: _title,
        subtitle: _message,
        statValue: '$streakDays',
        statLabel: L10nService.get('streak.milestone_celebration.day_streak', language),
      ),
      language: language,
    );
  }

  IconData get _milestoneIcon {
    switch (streakDays) {
      case 3:
        return Icons.local_fire_department_rounded;
      case 7:
        return Icons.bolt_rounded;
      case 14:
        return Icons.star_rounded;
      case 30:
        return Icons.emoji_events_rounded;
      case 60:
        return Icons.diamond_rounded;
      case 90:
        return Icons.workspace_premium_rounded;
      case 180:
        return Icons.public_rounded;
      case 365:
        return Icons.auto_awesome_rounded;
      default:
        return Icons.local_fire_department_rounded;
    }
  }

  String get _title {
    final lang = language;
    switch (streakDays) {
      case 3:
        return L10nService.get('streak.milestone.title_3', lang);
      case 7:
        return L10nService.get('streak.milestone.title_7', lang);
      case 14:
        return L10nService.get('streak.milestone.title_14', lang);
      case 30:
        return L10nService.get('streak.milestone.title_30', lang);
      case 60:
        return L10nService.get('streak.milestone.title_60', lang);
      case 90:
        return L10nService.get('streak.milestone.title_90', lang);
      case 180:
        return L10nService.get('streak.milestone.title_180', lang);
      case 365:
        return L10nService.get('streak.milestone.title_365', lang);
      default:
        return L10nService.getWithParams('streak.milestone.title_default', lang, params: {'count': '$streakDays'});
    }
  }

  String get _message => isEn
      ? StreakService.getMilestoneMessageEn(streakDays)
      : StreakService.getMilestoneMessageTr(streakDays);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: L10nService.getWithParams('streak.milestone.celebration_label', language, params: {'count': '$streakDays'}),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: (isDark ? AppColors.surfaceDark : AppColors.lightSurface)
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
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: RepaintBoundary(
                key: _boundaryKey,
                child: Container(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.lightSurface,
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
                                  AppColors.starGold.withValues(alpha: 0.25),
                                  AppColors.auroraStart.withValues(alpha: 0.15),
                                ],
                              ),
                              border: Border.all(
                                color: AppColors.starGold.withValues(
                                  alpha: 0.5,
                                ),
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.starGold.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              _milestoneIcon,
                              size: 44,
                              color: AppColors.starGold,
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

                      // Streak count
                      GradientText(
                            _title,
                            variant: GradientTextVariant.gold,
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                          .animate(delay: 200.ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.3, end: 0, duration: 400.ms),

                      const SizedBox(height: 12),

                      // Message
                      Text(
                        _message,
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 16,
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

                      // Premium nudge for free users at 7-day streak
                      if (!isPremium && streakDays == 7) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.starGold.withValues(alpha: 0.08),
                                AppColors.celestialGold.withValues(alpha: 0.04),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.starGold.withValues(alpha: 0.15),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 16,
                                color: AppColors.starGold,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  L10nService.get('streak.milestone_celebration.unlock_deeper_insights_with_premium', language),
                                  style: AppTypography.subtitle(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.starGold.withValues(alpha: 0.8)
                                        : AppColors.starGold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate(delay: 450.ms).fadeIn(duration: 400.ms),
                      ],

                      const SizedBox(height: 20),

                      // Buttons row: Share + Keep Going
                      Row(
                            children: [
                              // Share button
                              Expanded(
                                child: GradientOutlinedButton(
                                  label: L10nService.get('streak.milestone_celebration.share', language),
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
                              // Keep Going button
                              Expanded(
                                child: GradientButton.gold(
                                  label: L10nService.get('streak.milestone_celebration.keep_going', language),
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
        ),
      ),
    );
  }
}
