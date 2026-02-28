// ════════════════════════════════════════════════════════════════════════════
// POST-SAVE ENGAGEMENT SHEET - Context-aware suggestions after journal save
// ════════════════════════════════════════════════════════════════════════════
// Shows a premium bottom sheet with personalized next actions after the user
// saves a journal entry, encouraging deeper engagement with the app.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../data/services/l10n_service.dart';

class PostSaveEngagementSheet extends ConsumerWidget {
  final int entryCount;
  final int currentStreak;

  const PostSaveEngagementSheet({
    super.key,
    required this.entryCount,
    required this.currentStreak,
  });

  /// Show the engagement sheet as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required int entryCount,
    required int currentStreak,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PostSaveEngagementSheet(
        entryCount: entryCount,
        currentStreak: currentStreak,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final suggestions = _buildSuggestions(ref, isEn);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepSpace : AppColors.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: AppColors.starGold.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Success header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.starGold.withValues(alpha: 0.2),
                          AppColors.celestialGold.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.starGold,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          L10nService.get('journal.post_save_engagement.saved', language),
                          variant: GradientTextVariant.gold,
                          style: AppTypography.elegantAccent(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (currentStreak > 1)
                          Text(
                            isEn
                                ? '$currentStreak day streak'
                                : '$currentStreak g\u00fcnl\u00fck seri',
                            style: AppTypography.subtitle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.95, 0.95), duration: 300.ms),

              const SizedBox(height: 24),

              // Section title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  L10nService.get('journal.post_save_engagement.what_else_would_you_like_to_capture', language),
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

              const SizedBox(height: 14),

              // Suggestion cards
              ...suggestions.asMap().entries.map((entry) {
                final idx = entry.key;
                final s = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _SuggestionTile(
                    icon: s.icon,
                    title: s.title,
                    subtitle: s.subtitle,
                    isDark: isDark,
                    onTap: () {
                      HapticService.buttonPress();
                      Navigator.of(context).pop();
                      context.push(s.route);
                    },
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: 150 + idx * 60),
                      duration: 300.ms,
                    )
                    .slideX(begin: 0.03, duration: 300.ms);
              }),

              const SizedBox(height: 12),

              // Dismiss button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                  L10nService.get('journal.post_save_engagement.back_to_home', language),
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }

  List<_Suggestion> _buildSuggestions(WidgetRef ref, bool isEn) {
    final suggestions = <_Suggestion>[];

    // Always suggest mood check-in (quick action)
    suggestions.add(_Suggestion(
      icon: Icons.mood_rounded,
      title: L10nService.get('journal.post_save_engagement.log_your_mood', isEn ? AppLanguage.en : AppLanguage.tr),
      subtitle: L10nService.get('journal.post_save_engagement.quick_1tap_checkin', isEn ? AppLanguage.en : AppLanguage.tr),
      route: Routes.today,
    ));

    // Dream journal
    suggestions.add(_Suggestion(
      icon: Icons.nightlight_round,
      title: L10nService.get('journal.post_save_engagement.record_a_dream', isEn ? AppLanguage.en : AppLanguage.tr),
      subtitle: L10nService.get('journal.post_save_engagement.capture_it_before_it_fades', isEn ? AppLanguage.en : AppLanguage.tr),
      route: Routes.dreamInterpretation,
    ));

    // Notes to self
    suggestions.add(_Suggestion(
      icon: Icons.sticky_note_2_outlined,
      title: L10nService.get('journal.post_save_engagement.write_a_note_to_yourself', isEn ? AppLanguage.en : AppLanguage.tr),
      subtitle: L10nService.get('journal.post_save_engagement.thoughts_reminders_ideas', isEn ? AppLanguage.en : AppLanguage.tr),
      route: Routes.noteCreate,
    ));

    // Patterns (only if enough entries)
    if (entryCount >= 5) {
      suggestions.add(_Suggestion(
        icon: Icons.insights_rounded,
        title: L10nService.get('journal.post_save_engagement.explore_your_patterns', isEn ? AppLanguage.en : AppLanguage.tr),
        subtitle: isEn
            ? '$entryCount entries analyzed'
            : '$entryCount kay\u0131t analiz edildi',
        route: Routes.journalPatterns,
      ));
    }

    // Invite friends (only after meaningful engagement)
    if (entryCount >= 10) {
      suggestions.add(_Suggestion(
        icon: Icons.card_giftcard_rounded,
        title: L10nService.get('journal.post_save_engagement.invite_a_friend', isEn ? AppLanguage.en : AppLanguage.tr),
        subtitle: L10nService.get('journal.post_save_engagement.you_both_get_7_days_premium_free', isEn ? AppLanguage.en : AppLanguage.tr),
        route: Routes.referralProgram,
      ));
    }

    // Gratitude
    suggestions.add(_Suggestion(
      icon: Icons.volunteer_activism_rounded,
      title: L10nService.get('journal.post_save_engagement.gratitude_journal', isEn ? AppLanguage.en : AppLanguage.tr),
      subtitle: L10nService.get('journal.post_save_engagement.end_your_day_with_gratitude', isEn ? AppLanguage.en : AppLanguage.tr),
      route: Routes.gratitudeJournal,
    ));

    // Cap at 4 suggestions to keep it focused
    return suggestions.take(4).toList();
  }
}

class _Suggestion {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  const _Suggestion({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}

class _SuggestionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.5)
              : AppColors.lightSurfaceVariant.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.starGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(icon, size: 20, color: AppColors.starGold),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
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
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}
