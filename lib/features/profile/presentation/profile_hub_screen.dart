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

    // Growth score calculation
    final entryScore = (totalEntries / 50).clamp(0, 1) * 40;
    final streakScore = (streakDays / 30).clamp(0, 1) * 35;
    final challengeScore = (completedChallenges / 12).clamp(0, 1) * 25;
    final growthScore = (entryScore + streakScore + challengeScore)
        .round()
        .clamp(0, 100);

    final name = profile?.name ?? (L10nService.get('profile.profile_hub.explorer', isEn ? AppLanguage.en : AppLanguage.tr));

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
                  title: L10nService.get('profile.profile_hub.profile', isEn ? AppLanguage.en : AppLanguage.tr),
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
                        isDark: isDark,
                        isEn: isEn,
                      ).glassListItem(context: context, index: 1),
                      const SizedBox(height: AppConstants.spacingXl),

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
