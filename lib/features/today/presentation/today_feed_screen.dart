// ════════════════════════════════════════════════════════════════════════════
// TODAY FEED SCREEN - InnerCycles Premium Home (v3 Three-Zone Architecture)
// ════════════════════════════════════════════════════════════════════════════
// Zone 1 ANCHOR:   Header → HeroJournal → MoodStatsStrip
// Zone 2 CORE:     StreakRecovery → DailyPulse → RecentEntries →
//                  Birthdays → LifeEvents → StreakCard
// Zone 3 DISCOVER: PromotionalBannerStack
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../data/providers/app_providers.dart';
import '../../streak/presentation/streak_card.dart';
import '../../streak/presentation/streak_recovery_banner.dart';
import '../../../shared/widgets/cosmic_background.dart';
import 'widgets/home_header.dart';
import 'widgets/hero_journal_card.dart';
import 'widgets/mood_stats_strip.dart';
import 'widgets/daily_pulse_card.dart';
import 'widgets/recent_entries_section.dart';
import 'widgets/today_birthday_banner.dart';
import 'widgets/recent_life_events_section.dart';
import 'widgets/on_this_day_banner.dart';
import 'widgets/promotional_banner_stack.dart';
import 'widgets/weekly_focus_progress.dart';
import 'widgets/social_proof_strip.dart';
import '../../../data/services/l10n_service.dart';

class TodayFeedScreen extends ConsumerStatefulWidget {
  const TodayFeedScreen({super.key});

  @override
  ConsumerState<TodayFeedScreen> createState() => _TodayFeedScreenState();
}

class _TodayFeedScreenState extends ConsumerState<TodayFeedScreen> {
  static const _lastOpenKey = 'today_feed_last_open';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWelcomeBack();
      _checkAppAnniversary();
    });
  }

  Future<void> _checkWelcomeBack() async {
    final prefs = await SharedPreferences.getInstance();
    final lastOpen = prefs.getInt(_lastOpenKey);
    await prefs.setInt(_lastOpenKey, DateTime.now().millisecondsSinceEpoch);

    if (lastOpen == null) return; // First ever open — skip
    final daysSince = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastOpen))
        .inDays;
    if (daysSince < 3) return; // Active enough — lowered from 7 to 3

    if (!mounted) return;
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get previous streak for urgency
    int previousStreak = 0;
    try {
      final journalService = await ref.read(journalServiceProvider.future);
      previousStreak = journalService.getCurrentStreak();
    } catch (_) {}

    final hasStreak = previousStreak > 1;
    final subtitle = hasStreak
        ? (isEn
            ? 'You had a $previousStreak-day streak! One entry restarts your momentum.'
            : '$previousStreak günlük serin vardı! Bir kayıt ivmeni yeniden başlatır.')
        : (isEn
            ? 'It\'s been $daysSince days. A quick check-in is all it takes to restart.'
            : '$daysSince gündür burada değildin. Kısa bir kayıt yeniden başlamak için yeter.');

    if (!mounted) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
      pageBuilder: (ctx, _, _) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasStreak
                      ? Icons.local_fire_department_rounded
                      : Icons.wb_sunny_rounded,
                  size: 44,
                  color: AppColors.starGold,
                ),
                const SizedBox(height: 16),
                Text(
                  L10nService.get('today.today_feed.welcome_back', isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.decorativeScript(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(Routes.journal);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.starGold, AppColors.celestialGold],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        L10nService.get('today.today_feed.write_an_entry', isEn ? AppLanguage.en : AppLanguage.tr),
                        style: AppTypography.modernAccent(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepSpace,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Text(
                    L10nService.get('today.today_feed.maybe_later', isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.elegantAccent(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _anniversaryCelebratedKey = 'anniversary_celebrated_';
  static const _anniversaryMilestones = [30, 90, 180, 365];

  Future<void> _checkAppAnniversary() async {
    final prefs = await SharedPreferences.getInstance();
    final installMs = prefs.getInt('ic_intro_offer_install_time');
    if (installMs == null) return;

    final installDate = DateTime.fromMillisecondsSinceEpoch(installMs);
    final daysSinceInstall = DateTime.now().difference(installDate).inDays;

    int? milestone;
    for (final m in _anniversaryMilestones.reversed) {
      if (daysSinceInstall >= m) {
        milestone = m;
        break;
      }
    }
    if (milestone == null) return;

    final key = '$_anniversaryCelebratedKey$milestone';
    if (prefs.getBool(key) == true) return;
    await prefs.setBool(key, true);

    if (!mounted) return;
    final language = ref.read(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final label = milestone >= 365
        ? (L10nService.get('today.today_feed.1_year', isEn ? AppLanguage.en : AppLanguage.tr))
        : milestone >= 180
            ? (L10nService.get('today.today_feed.6_months', isEn ? AppLanguage.en : AppLanguage.tr))
            : milestone >= 90
                ? (L10nService.get('today.today_feed.3_months', isEn ? AppLanguage.en : AppLanguage.tr))
                : (L10nService.get('today.today_feed.1_month', isEn ? AppLanguage.en : AppLanguage.tr));

    final emoji = milestone >= 365
        ? '\u{1F389}'
        : milestone >= 90
            ? '\u{1F31F}'
            : '\u{2B50}';

    final message = isEn
        ? 'You\'ve been journaling for $label.\nYour commitment to self-reflection is inspiring.'
        : '$label boyunca g\u00fcnl\u00fck tutuyorsun.\n\u00d6z yans\u0131ma konusundaki kararl\u0131l\u0131\u011f\u0131n ilham verici.';

    if (!mounted) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
      pageBuilder: (ctx, _, _) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.starGold.withValues(alpha: 0.12),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                Text(
                  L10nService.getWithParams('today.anniversary_label', isEn ? AppLanguage.en : AppLanguage.tr, params: {'label': label}),
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.starGold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTypography.decorativeScript(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final text = isEn
                            ? '$emoji $label of journaling with InnerCycles!\n\n'
                              'Building a reflection practice, one day at a time.\n\n'
                              '${AppConstants.appStoreUrl}\n#InnerCycles #Anniversary'
                            : '$emoji InnerCycles ile $label g\u00fcnl\u00fck tutuyorum!\n\n'
                              'Her g\u00fcn bir yans\u0131ma prati\u011fi olu\u015fturuyorum.\n\n'
                              '${AppConstants.appStoreUrl}\n#InnerCycles';
                        SharePlus.instance.share(ShareParams(text: text));
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.starGold.withValues(alpha: 0.15),
                          border: Border.all(
                            color: AppColors.starGold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.share_rounded,
                          size: 20,
                          color: AppColors.starGold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.starGold,
                                AppColors.celestialGold,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              L10nService.get('today.today_feed.continue', isEn ? AppLanguage.en : AppLanguage.tr),
                              style: AppTypography.modernAccent(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepSpace,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProfile = ref.watch(userProfileProvider);
    final userName = userProfile?.name ?? '';

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: RefreshIndicator(
              color: AppColors.starGold,
              onRefresh: () async {
                ref.invalidate(journalServiceProvider);
                ref.invalidate(moodCheckinServiceProvider);
                ref.invalidate(streakStatsProvider);
                ref.invalidate(todayBirthdaysProvider);
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // ═══════════════════════════════════════════════
                  // ZONE 1: ANCHOR
                  // ═══════════════════════════════════════════════

                  // 1. Header
                  SliverToBoxAdapter(
                    child: HomeHeader(
                      userName: userName,
                      isEn: isEn,
                      isDark: isDark,
                    ).glassEntrance(context: context),
                  ),

                  // 2. Hero Journal Card (promoted to #2)
                  SliverToBoxAdapter(
                    child: HeroJournalCard(isEn: isEn, isDark: isDark),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // 3. Mood + Stats Strip
                  SliverToBoxAdapter(
                    child: MoodStatsStrip(
                      isEn: isEn,
                      isDark: isDark,
                    ).glassEntrance(context: context, delay: 180.ms),
                  ),

                  // Zone 1→2 primary divider
                  SliverToBoxAdapter(
                    child: _goldDivider(isDark, primary: true),
                  ),

                  // ═══════════════════════════════════════════════
                  // ZONE 2: CORE
                  // ═══════════════════════════════════════════════

                  // 4. Streak Recovery Banner (conditional)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: StreakRecoveryBanner(),
                    ),
                  ),

                  // 5. Daily Pulse Card
                  SliverToBoxAdapter(
                    child: DailyPulseCard(
                      isEn: isEn,
                      isDark: isDark,
                    ).glassReveal(context: context, delay: 280.ms),
                  ),

                  // 5b. Weekly Focus Progress
                  SliverToBoxAdapter(
                    child: WeeklyFocusProgress(
                      isEn: isEn,
                      isDark: isDark,
                    ).animate().fadeIn(delay: 320.ms, duration: 400.ms),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Gold divider
                  SliverToBoxAdapter(child: _goldDivider(isDark)),

                  // 6. Recent Entries
                  SliverToBoxAdapter(
                    child: RecentEntriesSection(
                      isEn: isEn,
                      isDark: isDark,
                    ).glassEntrance(context: context, delay: 400.ms),
                  ),

                  // 7. Today's Birthdays (conditional)
                  SliverToBoxAdapter(
                    child: TodayBirthdayBanner(isEn: isEn, isDark: isDark),
                  ),

                  // 7b. On This Day — Anniversary memories
                  SliverToBoxAdapter(
                    child: OnThisDayBanner(isEn: isEn, isDark: isDark),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // 8. Recent Life Events
                  SliverToBoxAdapter(
                    child: RecentLifeEventsSection(isEn: isEn, isDark: isDark),
                  ),

                  // 9. Streak Card
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverToBoxAdapter(
                      child: const StreakCard().glassReveal(
                        context: context,
                        delay: 580.ms,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Gold divider
                  SliverToBoxAdapter(child: _goldDivider(isDark)),

                  // ═══════════════════════════════════════════════
                  // ZONE 3: DISCOVER
                  // ═══════════════════════════════════════════════

                  // 10. Promotional Banner Stack
                  SliverToBoxAdapter(
                    child: PromotionalBannerStack(isEn: isEn, isDark: isDark),
                  ),

                  // 11. Social Proof Strip
                  SliverToBoxAdapter(
                    child: SocialProofStrip(isEn: isEn, isDark: isDark),
                  ),

                  // 12. Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _goldDivider(bool isDark, {bool primary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
      child: Container(
        height: primary ? 0.8 : 0.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              (isDark ? AppColors.starGold : AppColors.lightStarGold)
                  .withValues(alpha: 0.18),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
