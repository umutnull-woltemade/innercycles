// ════════════════════════════════════════════════════════════════════════════
// SIGNAL RESPONSE SHEET - Micro-interventions after low mood check-in
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/content/signal_content.dart';
import '../../../../data/services/signal_response_service.dart';

class SignalResponseSheet extends StatelessWidget {
  final SignalQuadrant quadrant;
  final bool isEn;
  final bool isDark;

  const SignalResponseSheet({
    super.key,
    required this.quadrant,
    required this.isEn,
    required this.isDark,
  });

  static Future<void> show(
    BuildContext context, {
    required SignalQuadrant quadrant,
    required bool isEn,
    required bool isDark,
  }) {
    if (!SignalResponseService.shouldShowResponse(quadrant)) {
      return Future.value();
    }
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SignalResponseSheet(
        quadrant: quadrant,
        isEn: isEn,
        isDark: isDark,
      ),
    );
  }

  IconData _iconForResponse(String iconName) {
    switch (iconName) {
      case 'air':
        return Icons.air_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      case 'edit_note':
        return Icons.edit_note_rounded;
      default:
        return Icons.lightbulb_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responses = SignalResponseService.getResponses(quadrant);
    if (responses.isEmpty) return const SizedBox.shrink();

    final isStorm = quadrant == SignalQuadrant.storm;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cosmicPurple : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isStorm
                ? (isEn ? 'Take a moment for yourself' : 'Kendine bir an ayır')
                : (isEn ? 'A gentle nudge' : 'Nazik bir dürtü'),
            style: AppTypography.displayFont.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isStorm
                ? (isEn
                    ? 'Feeling intense? These might help right now.'
                    : 'Yoğun hissediyorsun. Bunlar şu an işe yarayabilir.')
                : (isEn
                    ? 'Low energy is okay. Try one of these.'
                    : 'Düşük enerji normal. Bunlardan birini dene.'),
            textAlign: TextAlign.center,
            style: AppTypography.subtitle(
              fontSize: 13,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),
          ...responses.asMap().entries.map((entry) {
            final i = entry.key;
            final r = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(r.route);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color:
                        (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                    border: Border.all(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.06),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isStorm
                                ? [AppColors.error.withValues(alpha: 0.2), AppColors.warning.withValues(alpha: 0.2)]
                                : [AppColors.amethyst.withValues(alpha: 0.2), AppColors.auroraStart.withValues(alpha: 0.2)],
                          ),
                        ),
                        child: Icon(
                          _iconForResponse(r.icon),
                          size: 20,
                          color: isStorm ? AppColors.warning : AppColors.amethyst,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.title(isEn),
                              style: AppTypography.subtitle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              r.desc(isEn),
                              style: AppTypography.subtitle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: (150 + i * 100).ms, duration: 300.ms);
          }),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Text(
              isEn ? 'I\'m okay, thanks' : 'İyiyim, teşekkürler',
              style: AppTypography.subtitle(
                fontSize: 13,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.1, end: 0, duration: 300.ms);
  }
}
