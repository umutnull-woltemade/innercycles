// ════════════════════════════════════════════════════════════════════════════
// TODAY FEED SCREEN - InnerCycles Focused Home (Survival Release)
// ════════════════════════════════════════════════════════════════════════════
// Core loop: Streak → Mood Check-in → Start Journaling → Insight → Entries
// All SECONDARY feature cards removed. Clean, focused, retention-optimized.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/content/reflection_prompts_content.dart';
import '../../streak/presentation/streak_card.dart';
import '../../streak/presentation/streak_recovery_banner.dart';
import '../../mood/presentation/mood_checkin_card.dart';
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

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

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
                        HapticFeedback.lightImpact();
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
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return isEn ? 'Start your day with intention' : 'Güne niyetle başla';
    } else if (hour < 18) {
      return isEn ? 'Take a moment to reflect' : 'Bir an düşünmeye zaman ayır';
    } else {
      return isEn ? 'Wind down and reflect' : 'Günü yansıtarak bitir';
    }
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
              HapticFeedback.lightImpact();
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
        if (!engine.hasEnoughData()) {
          final needed = engine.entriesNeeded();
          return _buildCard(
            context,
            icon: Icons.auto_awesome_outlined,
            text: isEn
                ? 'Log $needed more entries to unlock your personal patterns'
                : 'Kişisel örüntülerini keşfetmek için $needed kayıt daha ekle',
          );
        }

        final trends = engine.detectTrends();
        if (trends.isEmpty) return const SizedBox.shrink();

        // Pick the most notable trend (largest change)
        final best = trends.reduce(
          (a, b) => a.changePercent.abs() > b.changePercent.abs() ? a : b,
        );
        final text = isEn ? best.getMessageEn() : best.getMessageTr();

        return _buildCard(context, icon: Icons.lightbulb_outline, text: text);
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
            HapticFeedback.lightImpact();
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
        final matching = allReflectionPrompts
            .where((p) => p.focusArea == promptArea)
            .toList();
        if (matching.isEmpty) return const SizedBox.shrink();

        final dayIndex = DateTime.now().day % matching.length;
        final prompt = matching[dayIndex];

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
                        HapticFeedback.selectionClick();
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
          HapticFeedback.selectionClick();
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
