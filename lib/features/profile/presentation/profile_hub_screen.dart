// ════════════════════════════════════════════════════════════════════════════
// PROFILE HUB SCREEN - Composition root for premium profile experience
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import 'widgets/profile_hero_section.dart';
import 'widgets/profile_stats_dashboard.dart';
import 'widgets/profile_tools_grid.dart';
import 'widgets/profile_vault_section.dart';
import 'widgets/profile_rate_section.dart';
import 'widgets/profile_referral_section.dart';
import 'widgets/profile_settings_section.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/tap_scale.dart';
import 'package:go_router/go_router.dart';

class ProfileHubScreen extends ConsumerWidget {
  const ProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final profile = ref.watch(userProfileProvider);
    final journalAsync = ref.watch(journalServiceProvider);
    final streakAsync = ref.watch(journalStreakProvider);
    final challengeAsync = ref.watch(growthChallengeServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    final totalEntries =
        journalAsync.whenOrNull(data: (service) => service.entryCount) ?? 0;
    final totalWords = journalAsync.whenOrNull(data: (service) {
      return service.getAllEntries().fold<int>(0, (sum, e) {
        final note = e.note ?? '';
        return sum + (note.trim().isEmpty ? 0 : note.trim().split(RegExp(r'\s+')).length);
      });
    }) ?? 0;
    final streakDays = streakAsync.whenOrNull(data: (v) => v) ?? 0;
    final completedChallenges =
        challengeAsync.whenOrNull(
          data: (service) => service.completedChallengeCount,
        ) ??
        0;

    final gratitudeAsync = ref.watch(gratitudeServiceProvider);
    final gratitudeDays =
        gratitudeAsync.whenOrNull(
          data: (service) => service.getAllEntries().length,
        ) ??
        0;

    // Growth score calculation
    final entryScore = (totalEntries / 50).clamp(0, 1) * 40;
    final streakScore = (streakDays / 30).clamp(0, 1) * 35;
    final challengeScore = (completedChallenges / 12).clamp(0, 1) * 25;
    final growthScore = (entryScore + streakScore + challengeScore)
        .round()
        .clamp(0, 100);

    final name = profile?.name ?? (L10nService.get('profile.profile_hub.explorer', language));

    return Scaffold(
      body: CosmicBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: L10nService.get('profile.profile_hub.profile', language),
                  showBackButton: false,
                  largeTitleMode: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Hero: avatar ring, name, badge, growth arc
                      ProfileHeroSection(
                        name: name,
                        isPremium: isPremium,
                        isDark: isDark,
                        isEn: isEn,
                        growthScore: growthScore,
                      ),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Stats: 4-column dashboard
                      ProfileStatsDashboard(
                        streak: streakDays,
                        entries: totalEntries,
                        daysActive: totalEntries,
                        challenges: completedChallenges,
                        totalWords: totalWords,
                        gratitudeDays: gratitudeDays,
                        isDark: isDark,
                        isEn: isEn,
                      ).glassListItem(context: context, index: 1),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Archetype mini-card
                      _ArchetypeMiniCard(isDark: isDark, isEn: isEn),

                      // Tools: suggested + category tabs + grid
                      ProfileToolsGrid(
                        isDark: isDark,
                        isEn: isEn,
                      ).glassListItem(context: context, index: 2),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Invite & Earn (Referral)
                      ProfileReferralSection(
                        isDark: isDark,
                        isEn: isEn,
                      ).glassListItem(context: context, index: 3),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Rate Us
                      ProfileRateSection(
                        isDark: isDark,
                        isEn: isEn,
                        totalEntries: totalEntries,
                      ).glassListItem(context: context, index: 4),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Vault & Security
                      ProfileVaultSection(
                        isDark: isDark,
                        isEn: isEn,
                      ).glassListItem(context: context, index: 5),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Settings & Account
                      ProfileSettingsSection(
                        isDark: isDark,
                        isEn: isEn,
                        isPremium: isPremium,
                      ).glassListItem(context: context, index: 6),
                      const SizedBox(height: AppConstants.spacingHuge),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArchetypeMiniCard extends ConsumerWidget {
  final bool isDark;
  final bool isEn;

  const _ArchetypeMiniCard({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archetypeAsync = ref.watch(archetypeServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);

    return archetypeAsync.maybeWhen(
      data: (service) {
        return journalAsync.maybeWhen(
          data: (jService) {
            final entries = jService.getAllEntries();
            if (entries.length < 5) return const SizedBox.shrink();

            final result = service.getCurrentArchetype(entries);
            if (result == null) return const SizedBox.shrink();

            final language = AppLanguage.fromIsEn(isEn);
            final archetype = result.dominant;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingXl),
              child: TapScale(
                onTap: () {
                  HapticService.selectionTap();
                  context.push(Routes.archetype);
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isDark
                        ? AppColors.surfaceLight.withValues(alpha: 0.3)
                        : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        archetype.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              archetype.localizedName(language),
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isEn
                                  ? 'Your current archetype'
                                  : 'Mevcut arketipin',
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
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
