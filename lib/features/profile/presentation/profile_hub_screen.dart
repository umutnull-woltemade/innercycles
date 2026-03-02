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
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/tap_scale.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/analytics_service.dart';
import '../../../data/providers/bond_providers.dart';

class ProfileHubScreen extends ConsumerWidget {
  const ProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(analyticsServiceProvider).logScreenView('profile_hub');
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

    final dreamCount =
        ref.watch(dreamCountProvider).whenOrNull(data: (v) => v) ?? 0;

    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final moodCount =
        moodAsync.whenOrNull(
          data: (service) => service.getAllEntries().length,
        ) ??
        0;

    final sleepAsync = ref.watch(sleepServiceProvider);
    final sleepNights =
        sleepAsync.whenOrNull(
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
                        dreamCount: dreamCount,
                        moodCount: moodCount,
                        sleepNights: sleepNights,
                        isDark: isDark,
                        isEn: isEn,
                      ).glassListItem(context: context, index: 1),
                      const SizedBox(height: AppConstants.spacingXl),

                      // You in Numbers — derived highlights
                      _YouInNumbersCard(
                        totalEntries: totalEntries,
                        totalWords: totalWords,
                        streakDays: streakDays,
                        dreamCount: dreamCount,
                        moodCount: moodCount,
                        sleepNights: sleepNights,
                        gratitudeDays: gratitudeDays,
                        completedChallenges: completedChallenges,
                        isDark: isDark,
                        isEn: isEn,
                      ).glassListItem(context: context, index: 2),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Personal Records
                      _PersonalRecordsCard(
                        isDark: isDark,
                        isEn: isEn,
                      ),
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

                      // Bond (Bağ) — Partner Feature
                      _BondHubLink(isDark: isDark, isEn: isEn)
                          .glassListItem(context: context, index: 5),
                      const SizedBox(height: AppConstants.spacingXl),

                      // Vault & Security
                      ProfileVaultSection(
                        isDark: isDark,
                        isEn: isEn,
                      ).glassListItem(context: context, index: 6),
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

class _YouInNumbersCard extends StatelessWidget {
  final int totalEntries;
  final int totalWords;
  final int streakDays;
  final int dreamCount;
  final int moodCount;
  final int sleepNights;
  final int gratitudeDays;
  final int completedChallenges;
  final bool isDark;
  final bool isEn;

  const _YouInNumbersCard({
    required this.totalEntries,
    required this.totalWords,
    required this.streakDays,
    required this.dreamCount,
    required this.moodCount,
    required this.sleepNights,
    required this.gratitudeDays,
    required this.completedChallenges,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final totalDataPoints =
        totalEntries + dreamCount + moodCount + sleepNights + gratitudeDays;
    if (totalDataPoints == 0) return const SizedBox.shrink();

    final wordsPerEntry =
        totalEntries > 0 ? (totalWords / totalEntries).round() : 0;

    // Count tools used
    int toolsUsed = 0;
    if (totalEntries > 0) toolsUsed++;
    if (dreamCount > 0) toolsUsed++;
    if (moodCount > 0) toolsUsed++;
    if (sleepNights > 0) toolsUsed++;
    if (gratitudeDays > 0) toolsUsed++;
    if (completedChallenges > 0) toolsUsed++;

    final highlights = <(String, String, IconData)>[
      (
        '$totalDataPoints',
        isEn ? 'Total Data Points' : 'Toplam Veri Noktası',
        Icons.insights_rounded,
      ),
      if (wordsPerEntry > 0)
        (
          '$wordsPerEntry',
          isEn ? 'Avg Words/Entry' : 'Ort. Kelime/Kayıt',
          Icons.text_fields_rounded,
        ),
      (
        '$toolsUsed',
        isEn ? 'Tools Used' : 'Kullanılan Araçlar',
        Icons.apps_rounded,
      ),
      (
        '$streakDays',
        isEn ? 'Current Streak' : 'Güncel Seri',
        Icons.local_fire_department_rounded,
      ),
    ];

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'You in Numbers' : 'Sayılarla Sen',
            variant: GradientTextVariant.aurora,
            style: AppTypography.displayFont.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: highlights.map((h) {
              final (value, label, icon) = h;
              return Expanded(
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: isDark
                          ? AppColors.auroraStart
                          : AppColors.auroraStart.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: AppTypography.elegantAccent(
                        fontSize: 9,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PersonalRecordsCard extends ConsumerWidget {
  final bool isDark;
  final bool isEn;

  const _PersonalRecordsCard({
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.maybeWhen(
      data: (service) {
        final entries = service.getAllEntries();
        if (entries.length < 5) return const SizedBox.shrink();

        // Best single rating
        final bestRating = entries.fold<int>(0, (max, e) => e.overallRating > max ? e.overallRating : max);

        // Best week average (sliding 7-day window)
        double bestWeekAvg = 0;
        if (entries.length >= 7) {
          for (int i = 0; i <= entries.length - 7; i++) {
            final window = entries.sublist(i, i + 7);
            final avg = window.fold<int>(0, (s, e) => s + e.overallRating) / 7;
            if (avg > bestWeekAvg) bestWeekAvg = avg;
          }
        }

        // Most entries in a month
        final monthCounts = <String, int>{};
        for (final e in entries) {
          final key = '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}';
          monthCounts[key] = (monthCounts[key] ?? 0) + 1;
        }
        final bestMonth = monthCounts.values.fold<int>(0, (max, v) => v > max ? v : max);

        // Longest streak
        final longestStreak = service.getLongestStreak();

        final records = <(String, String, IconData)>[
          (
            isEn ? 'Longest Streak' : 'En Uzun Seri',
            isEn ? '$longestStreak days' : '$longestStreak gün',
            Icons.local_fire_department_rounded,
          ),
          (
            isEn ? 'Best Rating' : 'En İyi Puan',
            '$bestRating / 5',
            Icons.star_rounded,
          ),
          if (bestWeekAvg > 0) (
            isEn ? 'Best Week Avg' : 'En İyi Hafta Ort.',
            bestWeekAvg.toStringAsFixed(1),
            Icons.trending_up_rounded,
          ),
          (
            isEn ? 'Best Month' : 'En Aktif Ay',
            isEn ? '$bestMonth entries' : '$bestMonth kayıt',
            Icons.calendar_month_rounded,
          ),
        ];

        return PremiumCard(
          style: PremiumCardStyle.amethyst,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events_rounded, size: 16, color: AppColors.starGold),
                  const SizedBox(width: 8),
                  GradientText(
                    isEn ? 'Personal Records' : 'Kişisel Rekorlar',
                    variant: GradientTextVariant.gold,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...records.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(r.$3, size: 16, color: AppColors.starGold.withValues(alpha: 0.7)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        r.$1,
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    Text(
                      r.$2,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOND HUB LINK
// ═══════════════════════════════════════════════════════════════════════════

class _BondHubLink extends ConsumerWidget {
  final bool isDark;
  final bool isEn;

  const _BondHubLink({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bondCount =
        ref.watch(bondCountProvider).whenOrNull(data: (v) => v) ?? 0;

    return TapScale(
      onTap: () {
        HapticService.selectionTap();
        context.push(Routes.bondHub);
      },
      child: PremiumCard(
        style: PremiumCardStyle.amethyst,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.amethyst.withValues(alpha: 0.15),
              ),
              alignment: Alignment.center,
              child: const Text(
                '\u{1FAF6}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    isEn ? 'Bonds' : 'Ba\u011Flar',
                    variant: GradientTextVariant.amethyst,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEn
                        ? bondCount > 0
                            ? '$bondCount active bond${bondCount > 1 ? 's' : ''}'
                            : 'Connect with your closest people'
                        : bondCount > 0
                            ? '$bondCount aktif ba\u011F'
                            : 'En yak\u0131nlar\u0131nla ba\u011Flan',
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
            if (bondCount > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.amethyst.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$bondCount',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.amethyst,
                  ),
                ),
              ),
            const SizedBox(width: 4),
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

