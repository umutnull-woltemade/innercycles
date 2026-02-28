import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/content/share_card_templates.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/share_card_sheet.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../../data/services/l10n_service.dart';

class HeroJournalCard extends ConsumerWidget {
  final AppLanguage language;
  bool get isEn => language.isEn;
  final bool isDark;

  const HeroJournalCard({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promptAsync = ref.watch(journalPromptServiceProvider);

    return promptAsync.maybeWhen(
      data: (service) {
        final prompt = service.getDailyPrompt();
        final questionText = isEn ? prompt.promptEn : prompt.promptTr;

        return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PremiumCard(
                style: PremiumCardStyle.aurora,
                borderRadius: 24,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  children: [
                    // Decorative open quote
                    Text(
                      '\u201C',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        height: 0.5,
                        color: isDark
                            ? AppColors.textPrimary.withValues(alpha: 0.12)
                            : AppColors.lightTextPrimary.withValues(alpha: 0.06),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      questionText,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        height: 1.4,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      L10nService.get('today.hero_journal.daily_reflection', language),
                      style: AppTypography.elegantAccent(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                        color: isDark
                            ? AppColors.auroraStart.withValues(alpha: 0.5)
                            : AppColors.lightAuroraStart.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Gold CTA button
                    Semantics(
                      button: true,
                      label: L10nService.get('today.hero_journal.start_writing_journal_entry', language),
                      child: TapScale(
                        onTap: () {
                          HapticService.buttonPress();
                          context.push(
                            Routes.journal,
                            extra: {'journalPrompt': questionText},
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      AppColors.starGold,
                                      AppColors.celestialGold,
                                    ]
                                  : [
                                      AppColors.lightStarGold,
                                      AppColors.celestialGold,
                                    ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.starGold.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                size: 18,
                                color: AppColors.deepSpace,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                L10nService.get('today.hero_journal.start_writing', language),
                                style: AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepSpace,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ).glassShimmer(context: context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Share link
                    Semantics(
                      button: true,
                      label: L10nService.get('today.hero_journal.share_this_question', language),
                      child: TapScale(
                        onTap: () {
                          HapticService.buttonPress();
                          final template = ShareCardTemplates.questionOfTheDay;
                          final cardData = ShareCardTemplates.buildData(
                            template: template,
                            language: language,
                            reflectionText: questionText,
                          );
                          ShareCardSheet.show(
                            context,
                            template: template,
                            data: cardData,
                            language: language,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share_rounded,
                                size: 14,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                L10nService.get('today.hero_journal.share_this_question_1', language),
                                style: AppTypography.elegantAccent(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .glassReveal(context: context, delay: 100.ms);
      },
      orElse: () {
        // Fallback: simple CTA pill
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Semantics(
            button: true,
            label: L10nService.get('today.hero_journal.start_journaling', language),
            child: GestureDetector(
              onTap: () {
                HapticService.buttonPress();
                context.go(Routes.journal);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [AppColors.starGold, AppColors.celestialGold]
                        : [AppColors.lightStarGold, AppColors.celestialGold],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.starGold.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: 20,
                      color: AppColors.deepSpace,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        L10nService.get('today.hero_journal.start_journaling_1', language),
                        style: AppTypography.modernAccent(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          color: AppColors.deepSpace,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 180.ms, duration: 400.ms);
      },
    );
  }
}
