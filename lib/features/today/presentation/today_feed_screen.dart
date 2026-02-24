// ════════════════════════════════════════════════════════════════════════════
// TODAY FEED SCREEN - InnerCycles Premium Home (v2 Refit)
// ════════════════════════════════════════════════════════════════════════════
// Hero Layout: Header → QuickStats → MoodCheckin → HeroJournal →
//              Insight → Prompt → FocusPulse → RecentEntries →
//              LifeEvents → StreakCard → Banners
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/common_strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/life_event.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/content/share_card_templates.dart';
import '../../../data/services/archetype_service.dart';
import '../../../data/services/content_rotation_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../streak/presentation/streak_card.dart';
import '../../streak/presentation/streak_recovery_banner.dart';
import '../../mood/presentation/mood_checkin_card.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/share_card_sheet.dart';
import '../../../shared/widgets/birthday_avatar.dart';

class TodayFeedScreen extends ConsumerStatefulWidget {
  const TodayFeedScreen({super.key});

  @override
  ConsumerState<TodayFeedScreen> createState() => _TodayFeedScreenState();
}

class _TodayFeedScreenState extends ConsumerState<TodayFeedScreen> {
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // ═══════════════════════════════════════════════════════
              // 1. HEADER — Date + Greeting + Name + Avatar
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _HomeHeader(
                  userName: userName,
                  isEn: isEn,
                  isDark: isDark,
                ).animate().fadeIn(duration: 400.ms),
              ),

              // ═══════════════════════════════════════════════════════
              // 2. QUICK STATS ROW — Streak / Mood / Entries
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _QuickStatsRow(isEn: isEn, isDark: isDark),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ═══════════════════════════════════════════════════════
              // 3. MOOD CHECK-IN
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const MoodCheckinCard(),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                  child: Container(
                    height: 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          (isDark ? AppColors.starGold : AppColors.lightStarGold)
                              .withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════════
              // 4. HERO JOURNAL CARD — Daily question + CTA
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _HeroJournalCard(isEn: isEn, isDark: isDark)
                    .animate()
                    .fadeIn(delay: 180.ms, duration: 400.ms)
                    .slideY(begin: 0.05, delay: 180.ms, duration: 400.ms),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ═══════════════════════════════════════════════════════
              // 5. STREAK RECOVERY BANNER (if applicable)
              // ═══════════════════════════════════════════════════════
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: StreakRecoveryBanner(),
                ),
              ),

              // ═══════════════════════════════════════════════════════
              // 6. TODAY'S INSIGHT (pattern-based, if 3+ entries)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _TodaysInsightSection(isEn: isEn, isDark: isDark)
                    .animate()
                    .fadeIn(delay: 320.ms, duration: 400.ms)
                    .slideY(begin: 0.05, delay: 320.ms, duration: 400.ms),
              ),

              // ═══════════════════════════════════════════════════════
              // 7. PERSONALIZED PROMPT (filtered by weakest area)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _PersonalizedPromptSection(isEn: isEn, isDark: isDark)
                    .animate()
                    .fadeIn(delay: 450.ms, duration: 400.ms)
                    .slideY(begin: 0.05, delay: 450.ms, duration: 400.ms),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                  child: Container(
                    height: 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          (isDark ? AppColors.starGold : AppColors.lightStarGold)
                              .withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════════
              // 8. FOCUS PULSE — Horizontal focus area scores
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _FocusPulseRow(isEn: isEn, isDark: isDark)
                    .animate()
                    .fadeIn(delay: 520.ms, duration: 400.ms),
              ),

              // ═══════════════════════════════════════════════════════
              // 9. RECENT ENTRIES — Horizontal scroll cards
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _RecentEntriesHorizontal(isEn: isEn, isDark: isDark)
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .slideY(begin: 0.05, delay: 600.ms, duration: 400.ms),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                  child: Container(
                    height: 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          (isDark ? AppColors.starGold : AppColors.lightStarGold)
                              .withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ═══════════════════════════════════════════════════════
              // 9b. TODAY'S BIRTHDAYS (conditional)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _TodayBirthdayBanner(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // 10. RECENT LIFE EVENTS
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _RecentLifeEventsCard(isEn: isEn, isDark: isDark)
                    .animate()
                    .fadeIn(delay: 680.ms, duration: 400.ms)
                    .slideY(begin: 0.05, delay: 680.ms, duration: 400.ms),
              ),

              // ═══════════════════════════════════════════════════════
              // 11. STREAK CARD
              // ═══════════════════════════════════════════════════════
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: const StreakCard().animate().fadeIn(
                    delay: 750.ms,
                    duration: 400.ms,
                  ).slideY(begin: 0.05, delay: 750.ms, duration: 400.ms),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ═══════════════════════════════════════════════════════
              // 12. UPCOMING NOTE REMINDERS
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _UpcomingRemindersCard(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // 13. RETROSPECTIVE BANNER
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _RetrospectiveBanner(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // 14. WRAPPED / MONTHLY WRAPPED BANNERS
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _WrappedBanner(isEn: isEn, isDark: isDark),
              ),
              SliverToBoxAdapter(
                child: _MonthlyWrappedBanner(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // 15. WEEKLY SHARE PROMPT
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _WeeklySharePrompt(isEn: isEn, isDark: isDark),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HOME HEADER — Date badge + Greeting + Name + Avatar circle
// ════════════════════════════════════════════════════════════════════════════

class _HomeHeader extends StatelessWidget {
  final String userName;
  final bool isEn;
  final bool isDark;

  const _HomeHeader({
    required this.userName,
    required this.isEn,
    required this.isDark,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return isEn ? 'Good morning' : 'Günaydın';
    if (hour < 18) return isEn ? 'Good afternoon' : 'İyi günler';
    return isEn ? 'Good evening' : 'İyi akşamlar';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const dayNamesEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const dayNamesTr = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final monthsEn = CommonStrings.monthsShortEn;
    final monthsTr = CommonStrings.monthsShortTr;
    final dayIndex = now.weekday - 1;
    if (isEn) {
      return '${dayNamesEn[dayIndex]}, ${monthsEn[now.month - 1]} ${now.day}';
    }
    return '${dayNamesTr[dayIndex]}, ${now.day} ${monthsTr[now.month - 1]}';
  }

  String _getInitials() {
    if (userName.isEmpty) return '';
    final parts = userName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return userName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final dateStr = _getFormattedDate();
    final insight = ContentRotationService.getDailyInsight();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date in gold elegant small caps
                    Text(
                      dateStr.toUpperCase(),
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: isDark
                            ? AppColors.starGold.withValues(alpha: 0.6)
                            : AppColors.lightStarGold.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Greeting — literary serif
                    Text(
                      userName.isNotEmpty ? '$greeting,' : greeting,
                      style: AppTypography.decorativeScript(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    if (userName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      GradientText(
                        userName,
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                          .animate()
                          .fadeIn(
                            duration: 600.ms,
                            curve: Curves.easeOut,
                          )
                          .slideX(
                            begin: -0.05,
                            end: 0,
                            duration: 600.ms,
                            curve: Curves.easeOut,
                          )
                          .then(delay: 800.ms)
                          .shimmer(
                            duration: 2000.ms,
                            color: AppColors.starGold.withValues(alpha: 0.15),
                          ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      isEn ? insight.en : insight.tr,
                      style: AppTypography.decorativeScript(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Avatar circle → Settings
              Semantics(
                label: isEn ? 'Profile & Settings' : 'Profil ve Ayarlar',
                button: true,
                child: GestureDetector(
                  onTap: () {
                    HapticService.buttonPress();
                    context.push(Routes.settings);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (isDark
                                  ? AppColors.starGold
                                  : AppColors.lightStarGold)
                              .withValues(alpha: 0.15),
                          (isDark
                                  ? AppColors.starGold
                                  : AppColors.lightStarGold)
                              .withValues(alpha: 0.05),
                        ],
                      ),
                      border: Border.all(
                        color: (isDark
                                ? AppColors.starGold
                                : AppColors.lightStarGold)
                            .withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.starGold.withValues(alpha: isDark ? 0.15 : 0.08),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: userName.isNotEmpty
                          ? Text(
                              _getInitials(),
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.starGold
                                    : AppColors.lightStarGold,
                              ),
                            )
                          : Icon(
                              Icons.person_outline_rounded,
                              size: 22,
                              color: isDark
                                  ? AppColors.starGold
                                  : AppColors.lightStarGold,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Subtle gold divider
          Container(
            height: 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  (isDark ? AppColors.starGold : AppColors.lightStarGold)
                      .withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// QUICK STATS ROW — 3 glass mini-cards: Streak / Mood / Entries
// ════════════════════════════════════════════════════════════════════════════

class _QuickStatsRow extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _QuickStatsRow({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakStatsProvider);
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);

    final streakCount = streakAsync.whenOrNull(
          data: (stats) => stats.currentStreak,
        ) ??
        0;

    final todayMood = moodAsync.whenOrNull(
      data: (service) => service.getTodayMood(),
    );

    final entryCount = journalAsync.whenOrNull(
          data: (service) => service.getAllEntries().length,
        ) ??
        0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        children: [
          // Streak
          Expanded(
            child: _StatCard(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.streakOrange,
              value: '$streakCount',
              label: isEn ? 'Streak' : 'Seri',
              isDark: isDark,
              onTap: () => context.push(Routes.streakStats),
            ),
          ),
          const SizedBox(width: 10),
          // Mood
          Expanded(
            child: _StatCard(
              emoji: todayMood?.emoji,
              icon: Icons.favorite_rounded,
              iconColor: AppColors.auroraStart,
              value: todayMood != null
                  ? _moodLabel(todayMood.mood)
                  : (isEn ? 'Check in' : 'Kaydet'),
              label: isEn ? 'Mood' : 'Ruh Hali',
              isDark: isDark,
              onTap: () => context.push(Routes.moodTrends),
            ),
          ),
          const SizedBox(width: 10),
          // Entries
          Expanded(
            child: _StatCard(
              icon: Icons.auto_stories_rounded,
              iconColor: AppColors.amethyst,
              value: '$entryCount',
              label: isEn ? 'Entries' : 'Kayıt',
              isDark: isDark,
              onTap: () => context.push(Routes.journalArchive),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 80.ms, duration: 400.ms)
        .slideY(begin: 0.05, duration: 400.ms);
  }

  String _moodLabel(int mood) {
    if (isEn) {
      switch (mood) {
        case 1:
          return 'Low';
        case 2:
          return 'Meh';
        case 3:
          return 'Okay';
        case 4:
          return 'Good';
        case 5:
          return 'Great';
        default:
          return '';
      }
    }
    switch (mood) {
      case 1:
        return 'Zor';
      case 2:
        return 'Düşük';
      case 3:
        return 'İdare';
      case 4:
        return 'İyi';
      case 5:
        return 'Harika';
      default:
        return '';
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData? icon;
  final String? emoji;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _StatCard({
    this.icon,
    this.emoji,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$value $label',
      child: GestureDetector(
        onTap: () {
          HapticService.selectionTap();
          onTap();
        },
        child: PremiumCard(
          style: PremiumCardStyle.subtle,
          showGradientBorder: false,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          borderRadius: 14,
          child: Column(
            children: [
              if (emoji != null)
                Text(emoji!, style: const TextStyle(fontSize: 22))
              else
                Icon(icon, size: 22, color: iconColor),
              const SizedBox(height: 6),
              Text(
                value,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  letterSpacing: 0.3,
                  color:
                      isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HERO JOURNAL CARD — Daily question + Start Writing CTA
// ════════════════════════════════════════════════════════════════════════════

class _HeroJournalCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _HeroJournalCard({required this.isEn, required this.isDark});

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
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
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
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                const SizedBox(height: 8),
                // Question text — literary serif for warmth
                Text(
                  questionText,
                  textAlign: TextAlign.center,
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
                // Label — elegant accent
                Text(
                  isEn ? 'DAILY REFLECTION' : 'GÜNLÜK YANSIMA',
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
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
                  label: isEn
                      ? 'Start writing journal entry'
                      : 'Günlük kaydı yazmaya başla',
                  child: GestureDetector(
                    onTap: () {
                      HapticService.buttonPress();
                      context.push(
                        Routes.journal,
                        extra: {'journalPrompt': questionText},
                      );
                    },
                    child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [AppColors.starGold, AppColors.celestialGold]
                            : [
                                AppColors.lightStarGold,
                                AppColors.celestialGold,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.starGold.withValues(alpha: 0.25),
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
                          isEn ? 'Start Writing' : 'Yazmaya Başla',
                          style: AppTypography.modernAccent(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepSpace,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(
                        delay: 3000.ms,
                        duration: 1800.ms,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                ),
                const SizedBox(height: 12),
                // Share link
                Semantics(
                  button: true,
                  label: isEn
                      ? 'Share this question'
                      : 'Bu soruyu paylaş',
                  child: GestureDetector(
                    onTap: () {
                      HapticService.buttonPress();
                      final template = ShareCardTemplates.questionOfTheDay;
                      final cardData = ShareCardTemplates.buildData(
                        template: template,
                        isEn: isEn,
                        reflectionText: questionText,
                      );
                      ShareCardSheet.show(
                        context,
                        template: template,
                        data: cardData,
                        isEn: isEn,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
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
                            isEn
                                ? 'Share this question'
                                : 'Bu soruyu paylaş',
                            style: AppTypography.elegantAccent(
                              fontSize: 12,
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
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms)
            .slideY(begin: 0.03, duration: 400.ms);
      },
      orElse: () {
        // Fallback: simple CTA pill
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Semantics(
            button: true,
            label: isEn ? 'Start journaling' : 'Günlüğe başla',
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
                        : [
                            AppColors.lightStarGold,
                            AppColors.celestialGold,
                          ],
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
                        isEn ? 'Start Journaling' : 'Günlüğe Başla',
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

// ════════════════════════════════════════════════════════════════════════════
// FOCUS PULSE ROW — Horizontal scroll of focus area circular scores
// ════════════════════════════════════════════════════════════════════════════

class _FocusPulseRow extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _FocusPulseRow({required this.isEn, required this.isDark});

  static const _focusAreaEmoji = {
    FocusArea.energy: '\u26A1',
    FocusArea.focus: '\uD83C\uDFAF',
    FocusArea.emotions: '\uD83D\uDC9C',
    FocusArea.decisions: '\uD83E\uDDED',
    FocusArea.social: '\uD83E\uDD1D',
  };

  static const _focusAreaColors = {
    FocusArea.energy: AppColors.starGold,
    FocusArea.focus: AppColors.chartBlue,
    FocusArea.emotions: AppColors.chartPink,
    FocusArea.decisions: AppColors.chartGreen,
    FocusArea.social: AppColors.chartPurple,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(patternEngineServiceProvider);

    return engineAsync.maybeWhen(
      data: (engine) {
        if (!engine.hasEnoughData()) return const SizedBox.shrink();
        final averages = engine.getOverallAverages();
        if (averages.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    GradientText(
                      isEn ? 'Your Focus Pulse' : 'Odak Nabzın',
                      variant: GradientTextVariant.gold,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    Semantics(
                      button: true,
                      label: isEn
                          ? 'View focus pulse details'
                          : 'Odak nabzı detaylarını gör',
                      child: GestureDetector(
                        onTap: () {
                          HapticService.selectionTap();
                          context.push(Routes.moodTrends);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          isEn ? 'Details' : 'Detaylar',
                          style: AppTypography.subtitle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.starGold
                                : AppColors.lightStarGold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: averages.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final entry = averages.entries.elementAt(index);
                    final area = entry.key;
                    final score = entry.value;
                    final color =
                        _focusAreaColors[area] ?? AppColors.starGold;
                    final emoji = _focusAreaEmoji[area] ?? '\u2728';

                    return Semantics(
                      button: true,
                      label:
                          '${_areaLabel(area)} ${score.toStringAsFixed(1)}',
                      child: GestureDetector(
                        onTap: () {
                          HapticService.selectionTap();
                          context.push(Routes.moodTrends);
                        },
                        child: SizedBox(
                          width: 80,
                          child: Column(
                            children: [
                              // Circular progress ring
                              SizedBox(
                                width: 56,
                                height: 56,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: CircularProgressIndicator(
                                        value:
                                            (score / 5.0).clamp(0.0, 1.0),
                                        strokeWidth: 3,
                                        strokeCap: StrokeCap.round,
                                        backgroundColor: isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.06)
                                            : Colors.black
                                                .withValues(alpha: 0.04),
                                        valueColor:
                                            AlwaysStoppedAnimation(color),
                                      ),
                                    ),
                                    Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _areaLabel(area),
                                style: AppTypography.elegantAccent(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                score.toStringAsFixed(1),
                                style: AppTypography.displayFont.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  String _areaLabel(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return isEn ? 'Energy' : 'Enerji';
      case FocusArea.focus:
        return isEn ? 'Focus' : 'Odak';
      case FocusArea.emotions:
        return isEn ? 'Emotions' : 'Duygular';
      case FocusArea.decisions:
        return isEn ? 'Decisions' : 'Kararlar';
      case FocusArea.social:
        return isEn ? 'Social' : 'Sosyal';
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RECENT ENTRIES — Horizontal scroll of entry cards
// ════════════════════════════════════════════════════════════════════════════

class _RecentEntriesHorizontal extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _RecentEntriesHorizontal({required this.isEn, required this.isDark});

  static const _focusAreaColors = {
    FocusArea.energy: AppColors.starGold,
    FocusArea.focus: AppColors.chartBlue,
    FocusArea.emotions: AppColors.chartPink,
    FocusArea.decisions: AppColors.chartGreen,
    FocusArea.social: AppColors.chartPurple,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.maybeWhen(
      data: (service) {
        final entries = service.getRecentEntries(5);
        if (entries.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      isEn ? 'Recent Entries' : 'Son Kayıtlar',
                      variant: GradientTextVariant.gold,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Semantics(
                      label: isEn ? 'See all entries' : 'Tüm kayıtları gör',
                      button: true,
                      child: GestureDetector(
                        onTap: () {
                          HapticService.selectionTap();
                          context.push(Routes.journalArchive);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 44),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              isEn ? 'See All' : 'Tümünü Gör',
                              style: AppTypography.subtitle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.starGold
                                    : AppColors.lightStarGold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Horizontal scroll
              SizedBox(
                height: 135,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final accentColor =
                        _focusAreaColors[entry.focusArea] ??
                            AppColors.starGold;
                    final dateStr = _formatDate(entry.date);
                    final areaLabel = _focusAreaLabel(entry.focusArea);

                    return Semantics(
                      button: true,
                      label: isEn
                          ? 'View journal entry from $dateStr'
                          : '$dateStr tarihli günlük kaydını gör',
                      child: GestureDetector(
                        onTap: () {
                          HapticService.selectionTap();
                          context.push(
                            '/journal/entry/${entry.id}',
                          );
                        },
                        child: SizedBox(
                        width: 160,
                        child: PremiumCard(
                          style: PremiumCardStyle.subtle,
                          showGradientBorder: false,
                          borderRadius: 16,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              // Focus area accent bar
                              Container(
                                width: 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      accentColor.withValues(alpha: 0.8),
                                      accentColor.withValues(alpha: 0.2),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Date
                                      Text(
                                        dateStr,
                                        style: AppTypography.elegantAccent(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors.textMuted
                                              : AppColors.lightTextMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Focus area chip
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: accentColor
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          areaLabel,
                                          style: AppTypography.modernAccent(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: accentColor,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Rating dots
                                      Row(
                                        children: List.generate(5, (i) {
                                          final filled =
                                              i < entry.overallRating;
                                          return Container(
                                            width: 8,
                                            height: 8,
                                            margin: const EdgeInsets.only(
                                                right: 4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: filled
                                                  ? (isDark
                                                      ? AppColors.starGold
                                                      : AppColors
                                                          .lightStarGold)
                                                  : (isDark
                                                      ? Colors.white
                                                          .withValues(
                                                              alpha: 0.1)
                                                      : Colors.black
                                                          .withValues(
                                                          alpha: 0.06,
                                                        )),
                                              boxShadow: filled
                                                  ? [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .starGold
                                                            .withValues(
                                                                alpha: 0.3),
                                                        blurRadius: 4,
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                          delay: Duration(
                            milliseconds: 250 + index * 60,
                          ),
                          duration: 400.ms,
                        );
                  },
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  String _formatDate(DateTime date) {
    final months = isEn ? CommonStrings.monthsShortEn : CommonStrings.monthsShortTr;
    return '${months[date.month - 1]} ${date.day}';
  }

  String _focusAreaLabel(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return isEn ? 'Energy' : 'Enerji';
      case FocusArea.focus:
        return isEn ? 'Focus' : 'Odak';
      case FocusArea.emotions:
        return isEn ? 'Emotions' : 'Duygular';
      case FocusArea.decisions:
        return isEn ? 'Decisions' : 'Kararlar';
      case FocusArea.social:
        return isEn ? 'Social' : 'Sosyal';
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TODAY'S INSIGHT — Left accent bar editorial style
// ════════════════════════════════════════════════════════════════════════════

class _TodaysInsightSection extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _TodaysInsightSection({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(patternEngineServiceProvider);

    return engineAsync.maybeWhen(
      data: (engine) {
        // ── FULL PATTERN (7+ entries) ──
        if (engine.hasEnoughData()) {
          final trends = engine.detectTrends();
          if (trends.isEmpty) return const SizedBox.shrink();
          final best = trends.reduce(
            (a, b) => a.changePercent.abs() > b.changePercent.abs() ? a : b,
          );
          final text = isEn ? best.getMessageEn() : best.getMessageTr();
          return _buildCard(
              context, icon: Icons.lightbulb_outline, text: text);
        }

        // ── MICRO-PATTERN (3-6 entries) ──
        if (engine.hasMicroPatternData()) {
          final micro = engine.detectMicroPattern(isEn: isEn);
          if (micro != null) {
            return _buildCard(
                context, icon: Icons.insights_outlined, text: micro);
          }
        }

        // ── D0 ARCHETYPE INSIGHT (0-2 entries) ──
        final archetypeAsync = ref.watch(archetypeServiceProvider);
        return archetypeAsync.maybeWhen(
          data: (archetypeService) {
            final history = archetypeService.getArchetypeHistory();
            if (history.isEmpty) {
              return _buildCard(
                context,
                icon: Icons.auto_awesome_outlined,
                text: isEn
                    ? 'Each entry builds your pattern library. Start journaling to see what emerges.'
                    : 'Her kayıt örüntü kütüphaneni oluşturur. Ne ortaya çıkacağını görmek için yazmaya başla.',
              );
            }
            final latestId = history.last.archetypeId;
            final archetype = ArchetypeService.archetypes.firstWhere(
              (a) => a.id == latestId,
              orElse: () => ArchetypeService.archetypes.first,
            );
            final tip = archetype.getGrowthTip(isEnglish: isEn);
            return _buildCard(
              context,
              icon: Icons.psychology_outlined,
              text: '${archetype.getName(isEnglish: isEn)}: $tip',
            );
          },
          orElse: () {
            return _buildCard(
              context,
              icon: Icons.auto_awesome_outlined,
              text: isEn
                  ? 'You\'re building momentum — your first personal insight is just around the corner.'
                  : 'İvme kazanıyorsun — ilk kişisel içgörün çok yakında.',
            );
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Semantics(
        label: text,
        button: true,
        child: GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            context.go(Routes.moodTrends);
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isDark ? AppColors.starGold : AppColors.lightStarGold,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isDark ? AppColors.starGold : AppColors.lightStarGold,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: AppTypography.decorativeScript(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PERSONALIZED PROMPT — PremiumCard amethyst, focus-area filtered
// ════════════════════════════════════════════════════════════════════════════

class _PersonalizedPromptSection extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _PersonalizedPromptSection({required this.isEn, required this.isDark});

  static const _focusAreaToPromptArea = {
    FocusArea.energy: 'energy',
    FocusArea.focus: 'productivity',
    FocusArea.emotions: 'mood',
    FocusArea.decisions: 'creativity',
    FocusArea.social: 'social',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(patternEngineServiceProvider);

    return engineAsync.maybeWhen(
      data: (engine) {
        if (!engine.hasEnoughData()) return const SizedBox.shrink();

        final averages = engine.getOverallAverages();
        if (averages.isEmpty) return const SizedBox.shrink();

        FocusArea weakestArea = averages.keys.first;
        double lowestScore = averages.values.first;
        for (final entry in averages.entries) {
          if (entry.value < lowestScore) {
            lowestScore = entry.value;
            weakestArea = entry.key;
          }
        }

        final promptArea = _focusAreaToPromptArea[weakestArea] ?? 'mood';
        final prompt = ContentRotationService.getDailyPrompt(
          weakestArea: promptArea,
        );

        final areaName = weakestArea.name;
        final areaLabel = isEn
            ? areaName[0].toUpperCase() + areaName.substring(1)
            : _turkishLabel(areaName);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: PremiumCard(
            style: PremiumCardStyle.amethyst,
            showInnerShadow: false,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_outlined,
                      size: 14,
                      color: AppColors.amethyst,
                    ),
                    const SizedBox(width: 8),
                    GradientText(
                      isEn ? 'For your $areaLabel' : '$areaLabel için',
                      variant: GradientTextVariant.amethyst,
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isEn ? prompt.promptEn : prompt.promptTr,
                  style: AppTypography.decorativeScript(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  String _turkishLabel(String area) {
    switch (area) {
      case 'energy':
        return 'Enerji';
      case 'focus':
        return 'Odak';
      case 'emotions':
        return 'Duygular';
      case 'decisions':
        return 'Kararlar';
      case 'social':
        return 'Sosyal';
      default:
        return area;
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TODAY'S BIRTHDAYS — Gold banner shown only when someone has a birthday
// ════════════════════════════════════════════════════════════════════════════

class _TodayBirthdayBanner extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _TodayBirthdayBanner({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(birthdayContactServiceProvider);
    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final todayBirthdays = service.getTodayBirthdays();
        if (todayBirthdays.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Semantics(
            button: true,
            label: isEn
                ? 'View birthday agenda'
                : 'Doğum günü ajandası',
            child: GestureDetector(
              onTap: () => context.push(Routes.birthdayAgenda),
              child: PremiumCard(
                style: PremiumCardStyle.gold,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Stacked avatars
                    SizedBox(
                      width: todayBirthdays.length == 1 ? 48 : 64,
                      height: 48,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          BirthdayAvatar(
                            photoPath: todayBirthdays.first.photoPath,
                            name: todayBirthdays.first.name,
                            size: 44,
                            showBirthdayCake: true,
                          ),
                          if (todayBirthdays.length > 1)
                            Positioned(
                              left: 24,
                              child: BirthdayAvatar(
                                photoPath: todayBirthdays[1].photoPath,
                                name: todayBirthdays[1].name,
                                size: 44,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todayBirthdays.length == 1
                                ? todayBirthdays.first.name
                                : '${todayBirthdays.first.name} +${todayBirthdays.length - 1}',
                            style: AppTypography.displayFont.copyWith(
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
                                ? '\u{1F382} Birthday today!'
                                : '\u{1F382} Bug\u{00FC}n do\u{011F}um g\u{00FC}n\u{00FC}!',
                            style: AppTypography.subtitle(
                              fontSize: 12,
                              color: AppColors.starGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.starGold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 660.ms, duration: 400.ms).slideY(
          begin: 0.05,
          delay: 660.ms,
          duration: 400.ms,
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RECENT LIFE EVENTS — Clean list, tinted retention prompt
// ════════════════════════════════════════════════════════════════════════════

class _RecentLifeEventsCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _RecentLifeEventsCard({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(lifeEventServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final recentEvents = service.getRecentEvents(3);
        if (recentEvents.isEmpty) {
          return _buildRetentionPrompt(context);
        }

        final cutoff = DateTime.now().subtract(const Duration(days: 14));
        final recentEnough = recentEvents.where(
          (e) => e.date.isAfter(cutoff),
        ).toList();
        if (recentEnough.isEmpty) {
          return _buildRetentionPrompt(context);
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GradientText(
                    isEn ? 'Recent Life Events' : 'Son Yaşam Olayları',
                    variant: GradientTextVariant.gold,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  Semantics(
                    button: true,
                    label: isEn
                        ? 'See all life events'
                        : 'Tüm yaşam olaylarını gör',
                    child: GestureDetector(
                      onTap: () => context.push(Routes.lifeTimeline),
                      child: Text(
                        isEn ? 'See all' : 'Tümünü gör',
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.starGold
                              : AppColors.lightStarGold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...recentEnough.take(2).toList().asMap().entries.map((mapEntry) {
                final index = mapEntry.key;
                final event = mapEntry.value;
                final isPositive = event.type == LifeEventType.positive;
                final preset = event.eventKey != null
                    ? LifeEventPresets.getByKey(event.eventKey!)
                    : null;
                final emoji =
                    preset?.emoji ?? (isPositive ? '\u{2728}' : '\u{1F4AD}');
                final isLastItem = index == recentEnough.take(2).length - 1;

                return Semantics(
                  button: true,
                  label: isEn
                      ? 'View life event: ${event.title}'
                      : 'Yaşam olayını gör: ${event.title}',
                  child: GestureDetector(
                    onTap: () {
                      HapticService.buttonPress();
                      context.push(
                        Routes.lifeEventDetail
                            .replaceFirst(':id', event.id),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: isLastItem
                            ? null
                            : Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? Colors.white
                                          .withValues(alpha: 0.06)
                                      : Colors.black
                                          .withValues(alpha: 0.04),
                                  width: 0.5,
                                ),
                              ),
                      ),
                      child: Row(
                        children: [
                          AppSymbol(emoji, size: AppSymbolSize.sm),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: AppTypography.displayFont.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                if (event.emotionTags.isNotEmpty)
                                  Text(
                                    event.emotionTags
                                        .take(2)
                                        .join(', '),
                                    style: AppTypography.elegantAccent(
                                      fontSize: 11,
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
                            size: 18,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms);
      },
    );
  }

  Widget _buildRetentionPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Semantics(
        button: true,
        label: isEn ? 'Record a life event' : 'Yaşam olayı kaydet',
        child: GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            context.push(Routes.lifeEventNew);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.starGold.withValues(alpha: 0.06)
                  : AppColors.starGold.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color:
                      isDark ? AppColors.starGold : AppColors.lightStarGold,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn
                            ? 'Any big moments this week?'
                            : 'Bu hafta büyük anlar oldu mu?',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        isEn
                            ? 'Record a life event'
                            : 'Bir yaşam olayı kaydedin',
                        style: AppTypography.elegantAccent(
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
                  color:
                      isDark ? AppColors.starGold : AppColors.lightStarGold,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// RETROSPECTIVE BANNER — Tinted container, no card border
// ════════════════════════════════════════════════════════════════════════════

class _RetrospectiveBanner extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _RetrospectiveBanner({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);
    final retroAsync = ref.watch(retrospectiveDateServiceProvider);

    final shouldShow = journalAsync.whenOrNull(data: (service) {
          final entryCount = service.getAllEntries().length;
          final hasRetro = retroAsync.whenOrNull(
                data: (retro) => retro.hasAnyDates,
              ) ??
              false;
          return entryCount < 5 || !hasRetro;
        }) ??
        false;

    if (!shouldShow) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Semantics(
        button: true,
        label: isEn
            ? 'Add retrospective entries'
            : 'Geçmişe dönük kayıtlar ekle',
        child: GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            context.push(Routes.retrospective);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.auroraStart.withValues(alpha: 0.08)
                  : AppColors.auroraStart.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: isDark
                      ? AppColors.auroraStart
                      : AppColors.lightAuroraStart,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn
                            ? 'Add entries for your most meaningful days'
                            : 'Geçmişindeki önemli günleri ekle',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn
                            ? 'Your story didn\'t start today'
                            : 'Hikayen bugün başlamadı',
                        style: AppTypography.elegantAccent(
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
                  color:
                      isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// UPCOMING NOTE REMINDERS — PremiumCard gold
// ════════════════════════════════════════════════════════════════════════════

class _UpcomingRemindersCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _UpcomingRemindersCard({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(upcomingRemindersProvider);
    final notesServiceAsync = ref.watch(notesToSelfServiceProvider);

    return remindersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (reminders) {
        if (reminders.isEmpty) return const SizedBox.shrink();

        return notesServiceAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (service) {
            final upcoming = reminders.take(2).toList();

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Semantics(
                button: true,
                label: isEn
                    ? 'View upcoming reminders'
                    : 'Yaklaşan hatırlatıcıları gör',
                child: GestureDetector(
                  onTap: () => context.push(Routes.notesList),
                  child: PremiumCard(
                    style: PremiumCardStyle.gold,
                    showInnerShadow: false,
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications_active,
                                size: 16,
                                color: isDark
                                    ? AppColors.starGold
                                    : AppColors.lightStarGold),
                            const SizedBox(width: 6),
                            GradientText(
                              isEn
                                  ? 'Upcoming Reminders'
                                  : 'Yaklaşan Hatırlatıcılar',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.displayFont.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              isEn ? 'See all' : 'Tümünü gör',
                              style: AppTypography.elegantAccent(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.starGold
                                    : AppColors.lightStarGold,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      ...upcoming.map((r) {
                        final note = service.getNote(r.noteId);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(Icons.schedule,
                                  size: 14,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black38),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  note?.title ?? (isEn ? 'Note' : 'Not'),
                                  style: AppTypography.subtitle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTimeLeft(r.scheduledAt),
                                style: AppTypography.elegantAccent(
                                  fontSize: 11,
                                  color: isDark
                                      ? Colors.white38
                                      : Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      ],
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 300.ms);
          },
        );
      },
    );
  }

  String _formatTimeLeft(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now);
    if (diff.isNegative) return isEn ? 'Now' : 'Şimdi';
    if (diff.inMinutes < 60) {
      return isEn ? 'in ${diff.inMinutes}m' : '${diff.inMinutes}dk içinde';
    }
    if (diff.inHours < 24) {
      return isEn ? 'in ${diff.inHours}h' : '${diff.inHours}sa içinde';
    }
    return isEn ? 'in ${diff.inDays}d' : '${diff.inDays}g içinde';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// WEEKLY SHARE CARD PROMPT — PremiumCard aurora (Sundays only)
// ════════════════════════════════════════════════════════════════════════════

class _WeeklySharePrompt extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _WeeklySharePrompt({required this.isEn, required this.isDark});

  bool get _shouldShow {
    return DateTime.now().weekday == DateTime.sunday;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!_shouldShow) return const SizedBox.shrink();

    final journalAsync = ref.watch(journalServiceProvider);
    final hasEntries = journalAsync.whenOrNull(
          data: (service) => service.getAllEntries().length >= 3,
        ) ??
        false;

    if (!hasEntries) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Semantics(
        button: true,
        label: isEn ? 'Share weekly insights' : 'Haftalık içgörüleri paylaş',
        child: GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            context.push(Routes.shareCardGallery);
          },
          child: PremiumCard(
            style: PremiumCardStyle.aurora,
            showInnerShadow: false,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: isDark
                      ? AppColors.auroraStart
                      : AppColors.lightAuroraStart,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        isEn
                            ? 'Your latest pattern card is ready'
                            : 'Son örüntü kartın hazır',
                        variant: GradientTextVariant.aurora,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn
                            ? 'Share your week\'s insights'
                            : 'Haftanın içgörülerini paylaş',
                        style: AppTypography.elegantAccent(
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
                  color:
                      isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// WRAPPED BANNER — Dec 26 - Jan 7
// ════════════════════════════════════════════════════════════════════════════

class _WrappedBanner extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _WrappedBanner({required this.isEn, required this.isDark});

  bool get _isWrappedSeason {
    final now = DateTime.now();
    return (now.month == 12 && now.day >= 26) ||
        (now.month == 1 && now.day <= 7);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isWrappedSeason) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Semantics(
        button: true,
        label: isEn ? 'View year wrapped' : 'Yıllık özeti gör',
        child: GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            context.push(Routes.wrapped);
          },
          child: PremiumCard(
            style: PremiumCardStyle.gold,
            showInnerShadow: false,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color:
                      isDark ? AppColors.starGold : AppColors.lightStarGold,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        isEn
                            ? 'Your ${DateTime.now().year} Wrapped is ready!'
                            : '${DateTime.now().year} Wrapped\'ın hazır!',
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn
                            ? 'See your year in patterns'
                            : 'Yılını örüntülerle gör',
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color:
                      isDark ? AppColors.starGold : AppColors.lightStarGold,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MONTHLY WRAPPED BANNER (first 10 days of month)
// ════════════════════════════════════════════════════════════════════════════

class _MonthlyWrappedBanner extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _MonthlyWrappedBanner({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    if (now.day > 10) return const SizedBox.shrink();
    if ((now.month == 1 && now.day <= 7) ||
        (now.month == 12 && now.day >= 26)) {
      return const SizedBox.shrink();
    }

    final lastMonth = now.month == 1 ? 12 : now.month - 1;
    final monthNames = isEn
        ? ['', ...CommonStrings.monthsFullEn]
        : ['', ...CommonStrings.monthsFullTr];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Semantics(
        button: true,
        label: isEn
            ? 'View monthly wrapped'
            : 'Aylık özeti gör',
        child: GestureDetector(
          onTap: () {
            HapticService.buttonPress();
            context.push(Routes.monthlyWrapped);
          },
          child: PremiumCard(
            style: PremiumCardStyle.amethyst,
            showInnerShadow: false,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const AppSymbol.card('\u{1F4CA}'),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        isEn
                            ? 'Your ${monthNames[lastMonth]} Wrapped'
                            : '${monthNames[lastMonth]} Özetin Hazır',
                        variant: GradientTextVariant.amethyst,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn
                            ? 'See your month at a glance'
                            : 'Ayına bir bakış at',
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.amethyst,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

