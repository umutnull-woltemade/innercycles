// ════════════════════════════════════════════════════════════════════════════
// PROFILE HUB SCREEN - User profile, growth score, stats, settings
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

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

    final totalEntries =
        journalAsync.whenOrNull(data: (service) => service.entryCount) ?? 0;
    final streakDays = streakAsync.whenOrNull(data: (v) => v) ?? 0;
    final completedChallenges =
        challengeAsync.whenOrNull(
          data: (service) => service.completedChallengeCount,
        ) ??
        0;

    // Simple growth score
    final entryScore = (totalEntries / 50).clamp(0, 1) * 40;
    final streakScore = (streakDays / 30).clamp(0, 1) * 35;
    final challengeScore = (completedChallenges / 12).clamp(0, 1) * 25;
    final growthScore = (entryScore + streakScore + challengeScore)
        .round()
        .clamp(0, 100);

    final name = profile?.name ?? (isEn ? 'Explorer' : 'Ka\u015fif');

    return Scaffold(
      body: CosmicBackground(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Profile' : 'Profil',
                showBackButton: false,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Profile Header
                    _ProfileHeader(
                      name: name,
                      isDark: isDark,
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Growth Score
                    _GrowthScoreCard(
                      score: growthScore,
                      isDark: isDark,
                      isEn: isEn,
                      onTap: () => context.push(Routes.streakStats),
                    ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Quick Stats
                    _QuickStats(
                      streak: streakDays,
                      entries: totalEntries,
                      challenges: completedChallenges,
                      isDark: isDark,
                      isEn: isEn,
                    ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Tools section
                    GradientText(
                      isEn ? 'Tools' : 'Araçlar',
                      variant: GradientTextVariant.gold,
                      style: AppTypography.elegantAccent(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingSm),
                    ..._buildToolLinks(context, isDark, isEn),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Settings links
                    GradientText(
                      isEn ? 'Settings' : 'Ayarlar',
                      variant: GradientTextVariant.gold,
                      style: AppTypography.elegantAccent(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingSm),
                    ..._buildSettingsLinks(context, isDark, isEn),

                    const SizedBox(height: AppConstants.spacingHuge),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildToolLinks(BuildContext context, bool isDark, bool isEn) {
    final links = [
      _SettingsLink(
        '\u{1F32C}\u{FE0F}',
        isEn ? 'Guided Breathwork' : 'Nefes Egzersizi',
        Routes.breathing,
      ),
      _SettingsLink(
        '\u{1F9D8}',
        isEn ? 'Meditation Timer' : 'Meditasyon Zamanlayıcı',
        Routes.meditation,
      ),
      _SettingsLink(
        '\u{1F50E}',
        isEn ? 'Cycle Sync' : 'Döngü Senkronu',
        Routes.cycleSync,
      ),
      _SettingsLink(
        '\u{1FA9E}',
        isEn ? 'Shadow Work Journal' : 'Gölge Çalışması Günlüğü',
        Routes.shadowWork,
      ),
      _SettingsLink(
        '\u{1F4C5}',
        isEn ? 'Heatmap Timeline' : 'Isı Haritası Zaman Çizelgesi',
        Routes.calendarHeatmap,
      ),
      _SettingsLink(
        '\u{1F30A}',
        isEn ? 'Waveform View' : 'Dalga Formu Görünümü',
        Routes.emotionalCycles,
      ),
      _SettingsLink(
        '\u{1F3C6}',
        isEn ? 'Milestones' : 'Ba\u015far\u0131lar',
        Routes.milestones,
      ),
      _SettingsLink(
        '\u{2705}',
        isEn ? 'Routine Tracker' : 'Rutin Takipçisi',
        Routes.dailyHabits,
      ),
      _SettingsLink(
        '\u{1F4DD}',
        isEn ? 'Prompt Engine' : 'Yönlendirme Motoru',
        Routes.promptLibrary,
      ),
      _SettingsLink(
        '\u{1F4CA}',
        isEn ? 'Year Synthesis' : 'Yıl Sentezi',
        Routes.yearReview,
      ),
      _SettingsLink(
        '\u{1F4C8}',
        isEn ? 'Growth Dashboard' : 'Geli\u015fim Panosu',
        Routes.growthDashboard,
      ),
      _SettingsLink(
        '\u{1F3B4}',
        isEn ? 'Share Cards' : 'Payla\u015f\u0131m Kartlar\u0131',
        Routes.shareCardGallery,
      ),
      _SettingsLink(
        '\u{1F5BC}\u{FE0F}',
        isEn ? 'Memories' : 'An\u0131lar',
        Routes.memories,
      ),
    ];

    return links.asMap().entries.map((entry) {
      final index = entry.key;
      final link = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spacingXs),
        child: _SettingsLinkTile(
          link: link,
          isDark: isDark,
          onTap: () => context.push(link.route),
        ),
      ).animate().fadeIn(
        delay: Duration(milliseconds: 220 + index * 40),
        duration: 300.ms,
      );
    }).toList();
  }

  List<Widget> _buildSettingsLinks(
    BuildContext context,
    bool isDark,
    bool isEn,
  ) {
    final links = [
      _SettingsLink(
        '\u{1F514}',
        isEn ? 'Notifications' : 'Bildirimler',
        Routes.notifications,
      ),
      _SettingsLink(
        '\u{1F512}',
        isEn ? 'App Lock' : 'Uygulama Kilidi',
        Routes.appLock,
      ),
      _SettingsLink('\u{2B50}', 'Premium', Routes.premium),
      _SettingsLink(
        '\u{2699}\u{FE0F}',
        isEn ? 'Settings' : 'Ayarlar',
        Routes.settings,
      ),
      _SettingsLink(
        '\u{1F4E4}',
        isEn ? 'Export' : 'D\u0131\u015fa Aktar',
        Routes.exportData,
      ),
    ];

    return links.asMap().entries.map((entry) {
      final index = entry.key;
      final link = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spacingXs),
        child: _SettingsLinkTile(
          link: link,
          isDark: isDark,
          onTap: () => context.push(link.route),
        ),
      ).animate().fadeIn(
        delay: Duration(milliseconds: 250 + index * 40),
        duration: 300.ms,
      );
    }).toList();
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final bool isDark;
  const _ProfileHeader({required this.name, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: AppConstants.radiusXl,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.starGold.withValues(alpha: 0.3),
                  AppColors.starGold.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: const Center(
              child: AppSymbol('\u{2728}', size: AppSymbolSize.lg),
            ),
          ),
          const SizedBox(width: AppConstants.spacingLg),
          Expanded(
            child: GradientText(
              name,
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthScoreCard extends StatelessWidget {
  final int score;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;
  const _GrowthScoreCard({
    required this.score,
    required this.isDark,
    required this.isEn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isEn
          ? 'Growth score $score. Tap for details'
          : 'Gelişim puanı $score. Detaylar için dokun',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: PremiumCard(
          style: PremiumCardStyle.aurora,
          borderRadius: AppConstants.radiusXl,
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        value: score / 100,
                        strokeWidth: 6,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.auroraStart,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '$score',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.auroraStart,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.spacingXl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      isEn ? 'Growth Score' : 'Gelişim Puanı',
                      variant: GradientTextVariant.gold,
                      style: AppTypography.elegantAccent(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXs),
                    Text(
                      isEn
                          ? 'Tap to see your growth dashboard'
                          : 'Geli\u015fim panelini g\u00f6rmek i\u00e7in dokun',
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
                color: AppColors.auroraStart.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final int streak;
  final int entries;
  final int challenges;
  final bool isDark;
  final bool isEn;
  const _QuickStats({
    required this.streak,
    required this.entries,
    required this.challenges,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: '$streak',
            label: isEn ? 'Streak' : 'Seri',
            color: AppColors.starGold,
          ),
          _StatItem(
            value: '$entries',
            label: isEn ? 'Entries' : 'Kay\u0131tlar',
            color: AppColors.auroraStart,
          ),
          _StatItem(
            value: '$challenges',
            label: isEn ? 'Challenges' : 'G\u00f6revler',
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _SettingsLink {
  final String emoji;
  final String name;
  final String route;
  const _SettingsLink(this.emoji, this.name, this.route);
}

class _SettingsLinkTile extends StatelessWidget {
  final _SettingsLink link;
  final bool isDark;
  final VoidCallback onTap;
  const _SettingsLinkTile({
    required this.link,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: link.name,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: PremiumCard(
          style: PremiumCardStyle.subtle,
          borderRadius: AppConstants.radiusMd,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          child: Row(
            children: [
              AppSymbol(link.emoji, size: AppSymbolSize.sm),
              const SizedBox(width: AppConstants.spacingLg),
              Expanded(
                child: Text(
                  link.name,
                  style: AppTypography.subtitle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? AppColors.textSecondary.withValues(alpha: 0.4)
                    : AppColors.lightTextMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
