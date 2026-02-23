// ════════════════════════════════════════════════════════════════════════════
// TODAY FEED SCREEN - InnerCycles Focused Home (Survival Release)
// ════════════════════════════════════════════════════════════════════════════
// Core 8: Header → StreakRecovery → MoodCheckin → StartJournal → Insight →
//          Prompt → RecentEntries → LifeEvents → StreakCard
// Surgery: CycleSync, ShadowWork, UnlockProgress, DiscoverMore removed.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/life_event.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/services/archetype_service.dart';
import '../../../data/services/content_rotation_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../streak/presentation/streak_card.dart';
import '../../prompts/presentation/daily_question_card.dart';
import '../../streak/presentation/streak_recovery_banner.dart';
import '../../mood/presentation/mood_checkin_card.dart';
// unlock_progress_banner import removed (Today Feed simplified)
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/gradient_text.dart';

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
              // HEADER - Greeting + Settings
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _HomeHeader(
                  userName: userName,
                  isEn: isEn,
                  isDark: isDark,
                ).animate().fadeIn(duration: 400.ms),
              ),

              // ═══════════════════════════════════════════════════════
              // STREAK RECOVERY BANNER (if applicable)
              // ═══════════════════════════════════════════════════════
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: StreakRecoveryBanner(),
                ),
              ),

              // ═══════════════════════════════════════════════════════
              // MOOD CHECK-IN
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const MoodCheckinCard(),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // ═══════════════════════════════════════════════════════
              // PRIMARY CTA - Start Journaling (pill shape)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              isEn ? 'Start Journaling' : 'Günlüğe Başla',
                              style: const TextStyle(
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
                  )
                      .animate().fadeIn(delay: 180.ms, duration: 400.ms)
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(
                        delay: 3000.ms,
                        duration: 1800.ms,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ═══════════════════════════════════════════════════════
              // RETROSPECTIVE BANNER (if < 5 entries or never used)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _RetrospectiveBanner(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // TODAY'S INSIGHT (pattern-based, if 3+ entries)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _TodaysInsightSection(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // DAILY QUESTION CARD (shareable question of the day)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: DailyQuestionCard(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // PERSONALIZED PROMPT (filtered by weakest focus area)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _PersonalizedPromptSection(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // UPCOMING NOTE REMINDERS (next 48h)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _UpcomingRemindersCard(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // WEEKLY SHARE CARD PROMPT (once per week)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _WeeklySharePrompt(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // WRAPPED BANNER (Dec 26 - Jan 7)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _WrappedBanner(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // MONTHLY WRAPPED BANNER (first 10 days of each month)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _MonthlyWrappedBanner(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // RECENT ENTRIES (last 3)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _RecentEntriesSection(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // RECENT LIFE EVENTS
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _RecentLifeEventsCard(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // STREAK CARD
              // ═══════════════════════════════════════════════════════
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: const StreakCard().animate().fadeIn(
                    delay: 300.ms,
                    duration: 400.ms,
                  ),
                ),
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
// HOME HEADER — Split greeting: small line + bold name
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

  String _getSubtitle(bool isEn) {
    final insight = ContentRotationService.getDailyInsight();
    return isEn ? insight.en : insight.tr;
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = isEn ? 'Good morning' : 'Günaydın';
    } else if (hour < 18) {
      greeting = isEn ? 'Good afternoon' : 'İyi günler';
    } else {
      greeting = isEn ? 'Good evening' : 'İyi akşamlar';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.isNotEmpty ? '$greeting,' : greeting,
                  style: TextStyle(
                    fontSize: 15,
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
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  _getSubtitle(isEn),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 0.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.starGold.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
            ),
            child: IconButton(
              tooltip: isEn ? 'Settings' : 'Ayarlar',
              onPressed: () {
                HapticService.buttonPress();
                context.push(Routes.settings);
              },
              icon: Icon(
                Icons.settings_outlined,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
                size: 20,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
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
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                      height: 1.4,
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
// PERSONALIZED PROMPT — Left accent bar, amethyst
// ════════════════════════════════════════════════════════════════════════════

class _PersonalizedPromptSection extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _PersonalizedPromptSection({required this.isEn, required this.isDark});

  // Map journal FocusArea enum to prompt focusArea strings
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

        // Find weakest focus area from overall averages
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

        // Map to prompt category and pick a date-rotated prompt
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
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.amethyst.withValues(alpha: 0.6),
                  width: 3,
                ),
              ),
            ),
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
                    Text(
                      isEn ? 'For your $areaLabel' : '$areaLabel için',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amethyst,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isEn ? prompt.promptEn : prompt.promptTr,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
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
// RECENT ENTRIES — Clean list with dividers, no cards
// ════════════════════════════════════════════════════════════════════════════

class _RecentEntriesSection extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const _RecentEntriesSection({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.maybeWhen(
      data: (service) {
        final entries = service.getRecentEntries(3);
        if (entries.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientText(
                    isEn ? 'Recent Entries' : 'Son Kayıtlar',
                    variant: GradientTextVariant.gold,
                    style: const TextStyle(
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
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
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
              const SizedBox(height: 12),
              ...entries.asMap().entries.map((mapEntry) {
                final index = mapEntry.key;
                final entry = mapEntry.value;
                return _RecentEntryRow(
                  entry: entry,
                  isEn: isEn,
                  isDark: isDark,
                  isLast: index == entries.length - 1,
                  onTap: () => context.push('/journal/entry/${entry.id}'),
                ).animate().fadeIn(
                  delay: Duration(milliseconds: 250 + index * 60),
                  duration: 400.ms,
                );
              }),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _RecentEntryRow extends StatelessWidget {
  final JournalEntry entry;
  final bool isEn;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _RecentEntryRow({
    required this.entry,
    required this.isEn,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  static const _focusAreaColors = {
    FocusArea.energy: AppColors.starGold,
    FocusArea.focus: AppColors.chartBlue,
    FocusArea.emotions: AppColors.chartPink,
    FocusArea.decisions: AppColors.chartGreen,
    FocusArea.social: AppColors.chartPurple,
  };

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(entry.date, isEn);
    final areaLabel = _focusAreaLabel(entry.focusArea, isEn);
    final rating = entry.overallRating;
    final accentColor = _focusAreaColors[entry.focusArea] ?? AppColors.starGold;

    final entryLabel = isEn
        ? '$areaLabel entry on $dateStr'
        : '$dateStr tarihli $areaLabel kaydı';

    return Semantics(
      label: entryLabel,
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticService.selectionTap();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      width: 0.5,
                    ),
                  ),
          ),
          child: Row(
            children: [
              // Focus area accent bar
              Container(
                width: 3,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      accentColor.withValues(alpha: 0.8),
                      accentColor.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Date
              SizedBox(
                width: 60,
                child: Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Focus area label
              Expanded(
                child: Text(
                  areaLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Rating dots
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final filled = i < rating;
                  return Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(left: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? (isDark
                                ? AppColors.starGold
                                : AppColors.lightStarGold)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.black.withValues(alpha: 0.06)),
                      boxShadow: filled
                          ? [
                              BoxShadow(
                                color: AppColors.starGold.withValues(alpha: 0.4),
                                blurRadius: 4,
                                spreadRadius: 0.5,
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
    );
  }

  static String _formatDate(DateTime date, bool isEn) {
    final months = isEn
        ? [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
          ]
        : [
            'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
            'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
          ];
    return '${months[date.month - 1]} ${date.day}';
  }

  static String _focusAreaLabel(FocusArea area, bool isEn) {
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(Routes.lifeTimeline),
                    child: Text(
                      isEn ? 'See all' : 'Tümünü gör',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.starGold
                            : AppColors.lightStarGold,
                        fontWeight: FontWeight.w500,
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

                return GestureDetector(
                  onTap: () {
                    HapticService.buttonPress();
                    context.push(
                      Routes.lifeEventDetail.replaceFirst(':id', event.id),
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
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.black.withValues(alpha: 0.04),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              if (event.emotionTags.isNotEmpty)
                                Text(
                                  event.emotionTags.take(2).join(', '),
                                  style: TextStyle(
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
                color: isDark ? AppColors.starGold : AppColors.lightStarGold,
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
                      style: TextStyle(
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
                      style: TextStyle(
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
                color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              ),
            ],
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
                color: isDark ? AppColors.auroraStart : AppColors.lightAuroraStart,
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
                      style: TextStyle(
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
                      style: TextStyle(
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
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// UPCOMING NOTE REMINDERS — Tinted container
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: GestureDetector(
                onTap: () => context.push(Routes.notesList),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.starGold.withValues(alpha: 0.06)
                        : AppColors.starGold.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications_active, size: 16, color: isDark ? AppColors.starGold : AppColors.lightStarGold),
                          const SizedBox(width: 6),
                          Text(
                            isEn ? 'Upcoming Reminders' : 'Yaklaşan Hatırlatıcılar',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            isEn ? 'See all' : 'Tümünü gör',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
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
                              Icon(Icons.schedule, size: 14, color: isDark ? Colors.white38 : Colors.black38),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  note?.title ?? (isEn ? 'Note' : 'Not'),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? Colors.white.withValues(alpha: 0.8) : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTimeLeft(r.scheduledAt, isEn),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white38 : Colors.black38,
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
            ).animate().fadeIn(delay: 150.ms, duration: 300.ms);
          },
        );
      },
    );
  }

  String _formatTimeLeft(DateTime dt, bool isEn) {
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
// WEEKLY SHARE CARD PROMPT — Tinted container
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
    ) ?? false;

    if (!hasEntries) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          HapticService.buttonPress();
          context.push(Routes.shareCardGallery);
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
                Icons.auto_awesome_rounded,
                color: isDark ? AppColors.auroraStart : AppColors.lightAuroraStart,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn
                          ? 'Your latest pattern card is ready'
                          : 'Son örüntü kartın hazır',
                      style: TextStyle(
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
                          ? 'Share your week\'s insights'
                          : 'Haftanın içgörülerini paylaş',
                      style: TextStyle(
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
      child: GestureDetector(
        onTap: () {
          HapticService.buttonPress();
          context.push(Routes.wrapped);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.starGold.withValues(alpha: 0.08)
                : AppColors.starGold.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: isDark ? AppColors.starGold : AppColors.lightStarGold,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn
                          ? 'Your ${DateTime.now().year} Wrapped is ready!'
                          : '${DateTime.now().year} Wrapped\'ın hazır!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isEn
                          ? 'See your year in patterns'
                          : 'Yılını örüntülerle gör',
                      style: TextStyle(
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
                color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              ),
            ],
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
        ? [
            '',
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December',
          ]
        : [
            '',
            'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
            'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          HapticService.buttonPress();
          context.push(Routes.monthlyWrapped);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.amethyst.withValues(alpha: 0.08)
                : AppColors.amethyst.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const AppSymbol.card('\u{1F4CA}'),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn
                          ? 'Your ${monthNames[lastMonth]} Wrapped'
                          : '${monthNames[lastMonth]} Özetin Hazır',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isEn
                          ? 'See your month at a glance'
                          : 'Ayına bir bakış at',
                      style: TextStyle(
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
    ).animate().fadeIn(duration: 400.ms);
  }
}
