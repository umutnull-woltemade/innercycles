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
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/life_event.dart';
import '../../../data/content/life_event_presets.dart';
import '../../../data/services/archetype_service.dart';
import '../../../data/services/content_rotation_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../streak/presentation/streak_card.dart';
import '../../streak/presentation/streak_recovery_banner.dart';
import '../../mood/presentation/mood_checkin_card.dart';
// unlock_progress_banner import removed (Today Feed simplified)
import '../../../shared/widgets/cosmic_background.dart';

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

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // ═══════════════════════════════════════════════════════
              // PRIMARY CTA - Start Journaling
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticService.buttonPress();
                        context.push(Routes.journal);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.starGold
                            : AppColors.lightStarGold,
                        foregroundColor: AppColors.deepSpace,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusLg,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note_rounded, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              isEn ? 'Start Journaling' : 'Günlüğe Başla',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ═══════════════════════════════════════════════════════
              // TODAY'S INSIGHT (pattern-based, if 3+ entries)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _TodaysInsightSection(isEn: isEn, isDark: isDark),
              ),

              // ═══════════════════════════════════════════════════════
              // PERSONALIZED PROMPT (filtered by weakest focus area)
              // ═══════════════════════════════════════════════════════
              SliverToBoxAdapter(
                child: _PersonalizedPromptSection(isEn: isEn, isDark: isDark),
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

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HOME HEADER
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.isNotEmpty ? '$greeting, $userName' : greeting,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getSubtitle(isEn),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: isEn ? 'Settings' : 'Ayarlar',
            onPressed: () {
              HapticService.buttonPress();
              context.push(Routes.settings);
            },
            icon: Icon(
              Icons.settings_outlined,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TODAY'S INSIGHT — Pattern-based note from journal history
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
              text: '${archetype.emoji} ${archetype.getName(isEnglish: isEn)}: $tip',
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
            context.push(Routes.moodTrends);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.starGold.withValues(alpha: 0.08)
                  : AppColors.lightStarGold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark
                    ? AppColors.starGold.withValues(alpha: 0.2)
                    : AppColors.lightStarGold.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
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
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PERSONALIZED PROMPT — Filtered by weakest focus area from pattern engine
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
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.amethyst.withValues(alpha: 0.08)
                  : AppColors.amethyst.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isDark
                    ? AppColors.amethyst.withValues(alpha: 0.2)
                    : AppColors.amethyst.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_outlined,
                      size: 16,
                      color: isDark ? AppColors.amethyst : AppColors.amethyst,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEn ? 'For your $areaLabel' : '$areaLabel için',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.amethyst : AppColors.amethyst,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
// RECENT ENTRIES — Last 3 journal entries (compact)
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
                  Text(
                    isEn ? 'Recent Entries' : 'Son Kayıtlar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
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
  final VoidCallback onTap;

  const _RecentEntryRow({
    required this.entry,
    required this.isEn,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(entry.date, isEn);
    final areaLabel = _focusAreaLabel(entry.focusArea, isEn);
    final rating = entry.overallRating;

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
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.6)
                : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
            ),
          ),
          child: Row(
            children: [
              // Date
              SizedBox(
                width: 70,
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
              // Rating dots (1-5)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final filled = i < rating;
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? (isDark
                                ? AppColors.starGold
                                : AppColors.lightStarGold)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.black.withValues(alpha: 0.08)),
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
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ]
        : [
            'Oca',
            'Şub',
            'Mar',
            'Nis',
            'May',
            'Haz',
            'Tem',
            'Ağu',
            'Eyl',
            'Eki',
            'Kas',
            'Ara',
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
// RECENT LIFE EVENTS CARD
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
          // Show retention prompt if no life events at all
          return _buildRetentionPrompt(context);
        }

        // Only show if there are events in the last 14 days
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
                  Text(
                    isEn ? 'Recent Life Events' : 'Son Yaşam Olayları',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(Routes.lifeTimeline),
                    child: Text(
                      isEn ? 'See all' : 'Tümünü gör',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.starGold,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...recentEnough.take(2).map((event) {
                final isPositive = event.type == LifeEventType.positive;
                final accentColor =
                    isPositive ? AppColors.starGold : AppColors.amethyst;
                final preset = event.eventKey != null
                    ? LifeEventPresets.getByKey(event.eventKey!)
                    : null;
                final emoji =
                    preset?.emoji ?? (isPositive ? '\u{2728}' : '\u{1F4AD}');

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      HapticService.buttonPress();
                      context.push(
                        Routes.lifeEventDetail.replaceFirst(':id', event.id),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 20)),
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
            color: AppColors.starGold.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.starGold.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.starGold,
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
                color: AppColors.starGold,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
