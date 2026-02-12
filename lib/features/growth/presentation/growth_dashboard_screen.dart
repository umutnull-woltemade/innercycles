// ════════════════════════════════════════════════════════════════════════════
// GROWTH DASHBOARD SCREEN - InnerCycles Streak Gamification & Progress
// ════════════════════════════════════════════════════════════════════════════
// Shows personal growth metrics, streaks, milestones, and monthly summaries.
// Uses JournalService + DreamJournalService for data. Follows safe language
// rules — no predictions, only reflections on past entries.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/journal_service.dart';
import '../../../data/services/dream_journal_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

// ════════════════════════════════════════════════════════════════════════════
// GROWTH DASHBOARD SCREEN
// ════════════════════════════════════════════════════════════════════════════

class GrowthDashboardScreen extends ConsumerStatefulWidget {
  const GrowthDashboardScreen({super.key});

  @override
  ConsumerState<GrowthDashboardScreen> createState() =>
      _GrowthDashboardScreenState();
}

class _GrowthDashboardScreenState
    extends ConsumerState<GrowthDashboardScreen> {
  bool _scoreAnimated = false;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final journalAsync = ref.watch(journalServiceProvider);
    final dreamAsync = ref.watch(dreamJournalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: journalAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (journalService) {
              return dreamAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (dreamService) {
                  return _buildDashboard(
                    context,
                    journalService,
                    dreamService,
                    isDark,
                    isEn,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    JournalService journalService,
    DreamJournalService dreamService,
    bool isDark,
    bool isEn,
  ) {
    final now = DateTime.now();
    final entries = journalService.getAllEntries();
    final currentStreak = journalService.getCurrentStreak();
    final longestStreak = journalService.getLongestStreak();
    final monthEntries = journalService.getEntriesForMonth(now.year, now.month);

    // Calculate data for growth score
    final focusAreasCoveredThisMonth = _focusAreasCoveredThisMonth(monthEntries);
    final consistencyDays = _consistencyDaysLast30(journalService);

    return FutureBuilder<int>(
      future: dreamService.getDreamCount(),
      builder: (context, dreamSnapshot) {
        final dreamCount = dreamSnapshot.data ?? 0;

        final growthScore = calculateGrowthScore(
          currentStreak: currentStreak,
          totalEntries: entries.length,
          focusAreasCovered: focusAreasCoveredThisMonth,
          consistencyDays: consistencyDays,
          dreamCount: dreamCount,
        );

        return CupertinoScrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Your Growth' : 'Buyumen',
              ),
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ═══════════════════════════════════════════════════════
                  // GROWTH SCORE HERO CARD
                  // ═══════════════════════════════════════════════════════
                  _buildGrowthScoreCard(
                    context,
                    growthScore,
                    isDark,
                    isEn,
                  ).animate().fadeIn(duration: 400.ms).slideY(
                        begin: 0.1,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: AppConstants.spacingXl),

                  // ═══════════════════════════════════════════════════════
                  // STREAK SECTION
                  // ═══════════════════════════════════════════════════════
                  _buildStreakSection(
                    context,
                    journalService,
                    currentStreak,
                    longestStreak,
                    isDark,
                    isEn,
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                  const SizedBox(height: AppConstants.spacingXl),

                  // ═══════════════════════════════════════════════════════
                  // MILESTONES GRID
                  // ═══════════════════════════════════════════════════════
                  _buildMilestonesSection(
                    context,
                    entries,
                    currentStreak,
                    longestStreak,
                    dreamCount,
                    focusAreasCoveredThisMonth,
                    isDark,
                    isEn,
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: AppConstants.spacingXl),

                  // ═══════════════════════════════════════════════════════
                  // MONTHLY SUMMARY CARD
                  // ═══════════════════════════════════════════════════════
                  _buildMonthlySummary(
                    context,
                    monthEntries,
                    dreamCount,
                    isDark,
                    isEn,
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  const SizedBox(height: AppConstants.spacingXl),

                  // ═══════════════════════════════════════════════════════
                  // SHARE GROWTH BUTTON
                  // ═══════════════════════════════════════════════════════
                  _buildShareButton(
                    context,
                    growthScore,
                    currentStreak,
                    entries.length,
                    isDark,
                    isEn,
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GROWTH SCORE CALCULATION
  // ══════════════════════════════════════════════════════════════════════════

  int calculateGrowthScore({
    required int currentStreak,
    required int totalEntries,
    required int focusAreasCovered,
    required int consistencyDays,
    required int dreamCount,
  }) {
    final streakScore =
        (currentStreak.clamp(0, 30) / 30 * 30).round(); // 30% weight
    final entryScore =
        (totalEntries.clamp(0, 100) / 100 * 20).round(); // 20% weight
    final coverageScore =
        (focusAreasCovered / 5 * 20).round(); // 20% weight
    final consistencyScore =
        (consistencyDays / 30 * 15).round(); // 15% weight
    final dreamScore =
        (dreamCount.clamp(0, 20) / 20 * 15).round(); // 15% weight
    return (streakScore +
            entryScore +
            coverageScore +
            consistencyScore +
            dreamScore)
        .clamp(0, 100);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // GROWTH SCORE HERO CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildGrowthScoreCard(
    BuildContext context,
    int score,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.auroraStart, AppColors.auroraEnd],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular progress indicator with score
          SizedBox(
            width: 160,
            height: 160,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: score / 100),
              duration: _scoreAnimated
                  ? const Duration(milliseconds: 300)
                  : const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              onEnd: () {
                if (!_scoreAnimated) {
                  setState(() => _scoreAnimated = true);
                }
              },
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 10,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    // Score number
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(value * 100).round()}',
                          style: GoogleFonts.spaceMono(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEn ? 'Growth Score' : 'Buyume Puani',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Motivational message
          Text(
            _getScoreMessage(score, isEn),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(int score, bool isEn) {
    if (score >= 80) {
      return isEn
          ? 'Outstanding! You are deeply committed to your growth.'
          : 'Muhteseml Buyumene cok baglisin.';
    } else if (score >= 60) {
      return isEn
          ? 'Great progress! Keep building your habits.'
          : 'Harika ilerleme! Aliskanliklarini gelistirmeye devam et.';
    } else if (score >= 30) {
      return isEn
          ? 'Good start! Every entry brings you closer.'
          : 'Iyi bir baslangic! Her kayit seni yaklastiriyor.';
    } else {
      return isEn
          ? 'Begin your journey. One entry at a time.'
          : 'Yolculuguna basla. Her seferinde bir kayit.';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STREAK SECTION
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildStreakSection(
    BuildContext context,
    JournalService service,
    int currentStreak,
    int longestStreak,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current streak — large and bold
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\u{1F525}',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 8),
              Text(
                '$currentStreak',
                style: GoogleFonts.spaceMono(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: AppColors.starGold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Days' : 'Gun',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Longest streak
          Text(
            isEn
                ? 'Best: $longestStreak days'
                : 'En iyi: $longestStreak gun',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Streak calendar heatmap — last 30 days
          _buildStreakHeatmap(service, isDark),
        ],
      ),
    );
  }

  Widget _buildStreakHeatmap(JournalService service, bool isDark) {
    final now = DateTime.now();
    final last30 = List.generate(30, (i) {
      final date = now.subtract(Duration(days: 29 - i));
      return DateTime(date.year, date.month, date.day);
    });

    // Build a set of logged date keys for fast lookup
    final loggedKeys = <String>{};
    for (final entry in service.getAllEntries()) {
      loggedKeys.add(entry.dateKey);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: last30.map((date) {
          final key =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          final hasEntry = loggedKeys.contains(key);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Tooltip(
              message:
                  '${date.day}/${date.month}',
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasEntry
                      ? AppColors.starGold
                      : isDark
                          ? AppColors.surfaceDark
                          : AppColors.lightSurfaceVariant,
                  border: hasEntry
                      ? null
                      : Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.06),
                          width: 1,
                        ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MILESTONES GRID
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildMilestonesSection(
    BuildContext context,
    List<JournalEntry> entries,
    int currentStreak,
    int longestStreak,
    int dreamCount,
    int focusAreasCoveredThisMonth,
    bool isDark,
    bool isEn,
  ) {
    final milestones = _buildMilestoneData(
      entries: entries,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      dreamCount: dreamCount,
      focusAreasCoveredThisMonth: focusAreasCoveredThisMonth,
      isEn: isEn,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'Milestones' : 'Kilometre Taslari',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: AppConstants.spacingMd,
            mainAxisSpacing: AppConstants.spacingMd,
          ),
          itemCount: milestones.length,
          itemBuilder: (context, index) {
            final milestone = milestones[index];
            return _buildMilestoneCard(
              context,
              milestone,
              isDark,
              isEn,
              index,
            );
          },
        ),
      ],
    );
  }

  Widget _buildMilestoneCard(
    BuildContext context,
    _Milestone milestone,
    bool isDark,
    bool isEn,
    int index,
  ) {
    final unlocked = milestone.unlocked;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: unlocked ? 0.8 : 0.4)
            : unlocked
                ? AppColors.lightCard
                : AppColors.lightSurfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: unlocked
              ? AppColors.starGold.withValues(alpha: 0.4)
              : isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with status
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Icon(
                milestone.icon,
                size: 32,
                color: unlocked
                    ? AppColors.starGold
                    : isDark
                        ? AppColors.textMuted.withValues(alpha: 0.4)
                        : AppColors.lightTextMuted.withValues(alpha: 0.5),
              ),
              if (unlocked)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.white,
                  ),
                )
              else
                Icon(
                  Icons.lock,
                  size: 14,
                  color: isDark
                      ? AppColors.textMuted.withValues(alpha: 0.5)
                      : AppColors.lightTextMuted,
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            milestone.title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: unlocked
                  ? (isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary)
                  : (isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Progress hint
          if (!unlocked)
            Text(
              milestone.progressHint,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.textMuted.withValues(alpha: 0.6)
                    : AppColors.lightTextMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    ).animate(delay: (50 * index).ms).fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  List<_Milestone> _buildMilestoneData({
    required List<JournalEntry> entries,
    required int currentStreak,
    required int longestStreak,
    required int dreamCount,
    required int focusAreasCoveredThisMonth,
    required bool isEn,
  }) {
    final maxStreak = math.max(currentStreak, longestStreak);

    return [
      _Milestone(
        icon: Icons.edit_note,
        title: isEn ? 'First Entry' : 'Ilk Kayit',
        unlocked: entries.isNotEmpty,
        progressHint: isEn ? '1 entry to unlock' : '1 kayit gerekli',
      ),
      _Milestone(
        icon: Icons.local_fire_department,
        title: isEn ? 'Week Warrior' : 'Hafta Savascisi',
        unlocked: maxStreak >= 7,
        progressHint: maxStreak < 7
            ? isEn
                ? '${7 - maxStreak} more to unlock'
                : '${7 - maxStreak} gun daha'
            : '',
      ),
      _Milestone(
        icon: Icons.auto_graph,
        title: isEn ? 'Pattern Seeker' : 'Kalip Arayici',
        unlocked: entries.length >= 7,
        progressHint: entries.length < 7
            ? isEn
                ? '${7 - entries.length} more entries'
                : '${7 - entries.length} kayit daha'
            : '',
      ),
      _Milestone(
        icon: Icons.nights_stay,
        title: isEn ? 'Dream Explorer' : 'Ruya Kasifl',
        unlocked: dreamCount >= 3,
        progressHint: dreamCount < 3
            ? isEn
                ? '${3 - dreamCount} more dreams'
                : '${3 - dreamCount} ruya daha'
            : '',
      ),
      _Milestone(
        icon: Icons.brightness_2,
        title: isEn ? 'Moon Connected' : 'Ay Baglantisi',
        // This requires logging during full/new moon — tracked as a stretch goal
        unlocked: false,
        progressHint: isEn ? 'Log during full/new moon' : 'Dolunayda kayit yap',
      ),
      _Milestone(
        icon: Icons.emoji_events,
        title: isEn ? 'Month Master' : 'Ay Ustasi',
        unlocked: maxStreak >= 30,
        progressHint: maxStreak < 30
            ? isEn
                ? '${30 - maxStreak} more to unlock'
                : '${30 - maxStreak} gun daha'
            : '',
      ),
      _Milestone(
        icon: Icons.psychology,
        title: isEn ? 'Self Aware' : 'Oz Farkindalik',
        unlocked: focusAreasCoveredThisMonth >= 5,
        progressHint: focusAreasCoveredThisMonth < 5
            ? isEn
                ? '${5 - focusAreasCoveredThisMonth} more areas'
                : '${5 - focusAreasCoveredThisMonth} alan daha'
            : '',
      ),
      _Milestone(
        icon: Icons.share,
        title: isEn ? 'Story Teller' : 'Hikaye Anlaticisi',
        // Unlocked when user shares — tracked in SharedPreferences as stretch goal
        unlocked: false,
        progressHint:
            isEn ? 'Share your progress' : 'Ilerlemeni paylas',
      ),
    ];
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MONTHLY SUMMARY CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildMonthlySummary(
    BuildContext context,
    List<JournalEntry> monthEntries,
    int dreamCount,
    bool isDark,
    bool isEn,
  ) {
    // Most tracked focus area this month
    final areaCount = <FocusArea, int>{};
    for (final entry in monthEntries) {
      areaCount[entry.focusArea] = (areaCount[entry.focusArea] ?? 0) + 1;
    }
    FocusArea? mostTracked;
    if (areaCount.isNotEmpty) {
      final sorted = areaCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      mostTracked = sorted.first.key;
    }

    // Average overall rating
    double avgRating = 0;
    if (monthEntries.isNotEmpty) {
      final sum =
          monthEntries.map((e) => e.overallRating).reduce((a, b) => a + b);
      avgRating = sum / monthEntries.length;
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'This Month' : 'Bu Ay',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.starGold,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildSummaryRow(
            icon: Icons.edit_note,
            label: isEn ? 'Entries this month' : 'Bu ayin kayitlari',
            value: '${monthEntries.length}',
            color: AppColors.auroraStart,
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSummaryRow(
            icon: Icons.category,
            label: isEn ? 'Most tracked area' : 'En cok takip edilen alan',
            value: mostTracked != null
                ? (isEn
                    ? mostTracked.displayNameEn
                    : mostTracked.displayNameTr)
                : (isEn ? 'None yet' : 'Henuz yok'),
            color: AppColors.starGold,
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSummaryRow(
            icon: Icons.sentiment_satisfied_alt,
            label: isEn ? 'Average mood' : 'Ortalama ruh hali',
            value: monthEntries.isNotEmpty
                ? '${avgRating.toStringAsFixed(1)} / 5'
                : (isEn ? 'N/A' : 'Yok'),
            color: AppColors.success,
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSummaryRow(
            icon: Icons.nights_stay,
            label: isEn ? 'Dreams logged' : 'Kaydedilen ruyalar',
            value: '$dreamCount',
            color: AppColors.amethyst,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHARE GROWTH BUTTON
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildShareButton(
    BuildContext context,
    int score,
    int streak,
    int totalEntries,
    bool isDark,
    bool isEn,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => _shareProgress(score, streak, totalEntries, isEn),
        icon: const Icon(Icons.share, size: 20),
        label: Text(
          isEn ? 'Share Your Progress' : 'Ilerlemeni Paylas',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.starGold,
          foregroundColor: AppColors.deepSpace,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _shareProgress(int score, int streak, int totalEntries, bool isEn) {
    final text = isEn
        ? 'My InnerCycles Growth Score: $score/100\n'
            'Current streak: $streak days\n'
            'Total entries: $totalEntries\n\n'
            'Track your personal growth with InnerCycles!'
        : 'InnerCycles Buyume Puanim: $score/100\n'
            'Mevcut seri: $streak gun\n'
            'Toplam kayit: $totalEntries\n\n'
            'InnerCycles ile kisisel buyumeni takip et!';

    Share.share(text);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ══════════════════════════════════════════════════════════════════════════

  /// Count how many distinct FocusArea values have been logged this month
  int _focusAreasCoveredThisMonth(List<JournalEntry> monthEntries) {
    final areas = <FocusArea>{};
    for (final entry in monthEntries) {
      areas.add(entry.focusArea);
    }
    return areas.length;
  }

  /// Count days with at least one entry in the last 30 days
  int _consistencyDaysLast30(JournalService service) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final entries = service.getEntriesByDateRange(thirtyDaysAgo, now);
    final uniqueDays = <String>{};
    for (final entry in entries) {
      uniqueDays.add(entry.dateKey);
    }
    return uniqueDays.length;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MILESTONE DATA MODEL
// ════════════════════════════════════════════════════════════════════════════

class _Milestone {
  final IconData icon;
  final String title;
  final bool unlocked;
  final String progressHint;

  const _Milestone({
    required this.icon,
    required this.title,
    required this.unlocked,
    required this.progressHint,
  });
}
