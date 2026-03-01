// ════════════════════════════════════════════════════════════════════════════
// HABIT SUGGESTIONS SCREEN - Browsable Micro-Habit Library
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/habit_suggestions_content.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/habit_suggestion_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../data/services/l10n_service.dart';

class HabitSuggestionsScreen extends ConsumerStatefulWidget {
  const HabitSuggestionsScreen({super.key});

  @override
  ConsumerState<HabitSuggestionsScreen> createState() =>
      _HabitSuggestionsScreenState();
}

class _HabitSuggestionsScreenState
    extends ConsumerState<HabitSuggestionsScreen> {
  String? _selectedCategory;
  bool _showBookmarksOnly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('habitSuggestions'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData(
            (s) => s.trackToolOpen('habitSuggestions', source: 'direct'),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(habitSuggestionServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CommonStrings.somethingWentWrong(language),
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () =>
                      ref.invalidate(habitSuggestionServiceProvider),
                  icon: Icon(Icons.refresh_rounded,
                      size: 16, color: AppColors.starGold),
                  label: Text(
                    L10nService.get('habits.habit_suggestions.retry', language),
                    style: AppTypography.elegantAccent(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starGold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          data: (service) => _buildContent(context, service, isDark, isEn),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    HabitSuggestionService service,
    bool isDark,
    bool isEn,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    final dailyHabit = service.getDailyHabit();

    // Build filtered list
    List<HabitSuggestion> habits;
    if (_showBookmarksOnly) {
      habits = service.getBookmarked();
    } else if (_selectedCategory != null) {
      habits = service.getByCategory(_selectedCategory!);
    } else {
      habits = service.getAllHabits();
    }

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // ═══ APP BAR ═══
          GlassSliverAppBar(
            title: L10nService.get('habits.habit_suggestions.microhabits', language),
            largeTitleMode: true,
            actions: [
              // Bookmark filter toggle
              IconButton(
                tooltip: _showBookmarksOnly
                    ? (L10nService.get('habits.habit_suggestions.show_all_habits', language))
                    : (L10nService.get('habits.habit_suggestions.show_bookmarks', language)),
                icon: Icon(
                  _showBookmarksOnly
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: _showBookmarksOnly
                      ? AppColors.starGold
                      : (isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _showBookmarksOnly = !_showBookmarksOnly;
                    if (_showBookmarksOnly) _selectedCategory = null;
                  });
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ═══ DAILY SPOTLIGHT ═══
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: _DailySpotlightCard(
                habit: dailyHabit,
                service: service,
                isDark: isDark,
                isEn: isEn,
                onTap: () => _showHabitDetail(
                  context,
                  dailyHabit,
                  service,
                  isDark,
                  isEn,
                ),
                onRefresh: () => setState(() {}),
              ),
            ),
          ),

          // ═══ PROGRESS BAR ═══
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ProgressBar(service: service, isDark: isDark, isEn: isEn),
            ),
          ),

          // ═══ CATEGORY CHIPS ═══
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CategoryChip(
                      label: L10nService.get('habits.habit_suggestions.all', language),
                      emoji: '✨',
                      isSelected:
                          _selectedCategory == null && !_showBookmarksOnly,
                      isDark: isDark,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _selectedCategory = null;
                          _showBookmarksOnly = false;
                        });
                      },
                    ),
                    ...HabitSuggestionService.categories.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _CategoryChip(
                          label: isEn
                              ? HabitSuggestionService.categoryDisplayNameEn(
                                  cat,
                                )
                              : HabitSuggestionService.categoryDisplayNameTr(
                                  cat,
                                ),
                          emoji: HabitSuggestionService.categoryEmoji(cat),
                          isSelected: _selectedCategory == cat,
                          isDark: isDark,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _selectedCategory = cat;
                              _showBookmarksOnly = false;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // ═══ HABIT CARDS ═══
          if (habits.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    L10nService.get('habits.habit_suggestions.your_bookmark_list_is_ready_for_habits', language),
                    style: AppTypography.subtitle(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final habit = habits[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _HabitCard(
                      habit: habit,
                      service: service,
                      isDark: isDark,
                      isEn: isEn,
                      onTap: () => _showHabitDetail(
                        context,
                        habit,
                        service,
                        isDark,
                        isEn,
                      ),
                      onRefresh: () => setState(() {}),
                    ),
                  ).animate().fadeIn(
                    duration: 300.ms,
                    delay: Duration(milliseconds: (50 * index).clamp(0, 400)),
                  );
                }, childCount: habits.length),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: ToolEcosystemFooter(
                currentToolId: 'habitSuggestions',
                isEn: isEn,
                isDark: isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHabitDetail(
    BuildContext context,
    HabitSuggestion habit,
    HabitSuggestionService service,
    bool isDark,
    bool isEn,
  ) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _HabitDetailSheet(
        habit: habit,
        service: service,
        isDark: isDark,
        isEn: isEn,
        onChanged: () => setState(() {}),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DAILY SPOTLIGHT CARD
// ═══════════════════════════════════════════════════════════════════════════

class _DailySpotlightCard extends StatelessWidget {
  final HabitSuggestion habit;
  final HabitSuggestionService service;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;
  final VoidCallback onRefresh;

  const _DailySpotlightCard({
    required this.habit,
    required this.service,
    required this.isDark,
    required this.isEn,
    required this.onTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    final isTried = service.isTried(habit.id);
    final isAdopted = service.isAdopted(habit.id);

    return Semantics(
      label: habit.localizedTitle(language),
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.auroraStart.withValues(alpha: 0.2),
                      AppColors.auroraEnd.withValues(alpha: 0.1),
                      AppColors.surfaceDark.withValues(alpha: 0.9),
                    ]
                  : [
                      AppColors.auroraStart.withValues(alpha: 0.08),
                      AppColors.lightAuroraEnd.withValues(alpha: 0.04),
                      AppColors.lightCard,
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.auroraStart.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.auroraStart.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppSymbol(
                      HabitSuggestionService.categoryEmoji(habit.category),
                      size: AppSymbolSize.sm,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientText(
                          L10nService.get('habits.habit_suggestions.todays_habit', language),
                          variant: GradientTextVariant.aurora,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        GradientText(
                          habit.localizedTitle(language),
                          variant: GradientTextVariant.gold,
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isTried || isAdopted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (isAdopted
                                    ? AppColors.success
                                    : AppColors.auroraStart)
                                .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isAdopted
                            ? (L10nService.get('habits.habit_suggestions.adopted', language))
                            : (L10nService.get('habits.habit_suggestions.tried', language)),
                        style: AppTypography.modernAccent(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isAdopted
                              ? AppColors.success
                              : AppColors.auroraStart,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                habit.localizedDescription(language),
                style: AppTypography.decorativeScript(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  // Category pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.auroraStart.withValues(
                        alpha: isDark ? 0.15 : 0.1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isEn
                          ? HabitSuggestionService.categoryDisplayNameEn(
                              habit.category,
                            )
                          : HabitSuggestionService.categoryDisplayNameTr(
                              habit.category,
                            ),
                      style: AppTypography.subtitle(
                        fontSize: 11,
                        color: AppColors.auroraStart,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Duration pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.3)
                          : AppColors.lightSurfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.durationMinutes} ${L10nService.get('habits.habit_suggestions.min', language)}',
                          style: AppTypography.subtitle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!isTried)
                    Semantics(
                      label: L10nService.get('habits.habit_suggestions.try_this_habit', language),
                      button: true,
                      child: GestureDetector(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          await service.markAsTried(habit.id);
                          onRefresh();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.auroraStart.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.auroraStart.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          child: Text(
                            L10nService.get('habits.habit_suggestions.try_it', language),
                            style: AppTypography.modernAccent(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.auroraStart,
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
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, duration: 500.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PROGRESS BAR
// ═══════════════════════════════════════════════════════════════════════════

class _ProgressBar extends StatelessWidget {
  final HabitSuggestionService service;
  final bool isDark;
  final bool isEn;

  const _ProgressBar({
    required this.service,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    final tried = service.triedCount;
    final adopted = service.adoptedCount;
    final total = service.totalCount;
    final progress = service.explorationProgress;

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      borderRadius: 14,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                L10nService.get('habits.habit_suggestions.habits_explored', language),
                style: AppTypography.elegantAccent(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Text(
                '$tried / $total',
                style: AppTypography.subtitle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.auroraStart),
            ),
          ),
          if (adopted > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 14,
                  color: AppColors.success,
                ),
                const SizedBox(width: 4),
                Text(
                  isEn
                      ? '$adopted adopted into your routine'
                      : '$adopted rutininize eklendi',
                  style: AppTypography.subtitle(
                    fontSize: 11,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CATEGORY CHIP
// ═══════════════════════════════════════════════════════════════════════════

class _CategoryChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.auroraStart.withValues(alpha: isDark ? 0.2 : 0.15)
                : (isDark
                      ? AppColors.surfaceDark
                      : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.auroraStart.withValues(alpha: 0.5)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.08)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSymbol.inline(emoji),
              const SizedBox(width: 4),
              Text(
                label,
                style: isSelected
                    ? AppTypography.modernAccent(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.auroraStart,
                      )
                    : AppTypography.subtitle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HABIT CARD
// ═══════════════════════════════════════════════════════════════════════════

class _HabitCard extends StatelessWidget {
  final HabitSuggestion habit;
  final HabitSuggestionService service;
  final bool isDark;
  final bool isEn;
  final VoidCallback onTap;
  final VoidCallback onRefresh;

  const _HabitCard({
    required this.habit,
    required this.service,
    required this.isDark,
    required this.isEn,
    required this.onTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    final isTried = service.isTried(habit.id);
    final isAdopted = service.isAdopted(habit.id);
    final isBookmarked = service.isBookmarked(habit.id);

    return Semantics(
      label: habit.localizedTitle(language),
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                : AppColors.lightCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isAdopted
                  ? AppColors.success.withValues(alpha: 0.3)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.05)),
            ),
          ),
          child: Row(
            children: [
              // Category emoji
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _categoryCardColor(
                    habit.category,
                  ).withValues(alpha: isDark ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: AppSymbol(
                    HabitSuggestionService.categoryEmoji(habit.category),
                    size: AppSymbolSize.sm,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            habit.localizedTitle(language),
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        if (isBookmarked)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.bookmark_rounded,
                              size: 16,
                              color: AppColors.starGold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Duration
                        Icon(
                          Icons.timer_outlined,
                          size: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${habit.durationMinutes} ${L10nService.get('habits.habit_suggestions.min_1', language)}',
                          style: AppTypography.subtitle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                        if (isTried || isAdopted) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isAdopted
                                ? Icons.check_circle_rounded
                                : Icons.check_rounded,
                            size: 12,
                            color: isAdopted
                                ? AppColors.success
                                : AppColors.auroraStart,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            isAdopted
                                ? (L10nService.get('habits.habit_suggestions.adopted_1', language))
                                : (L10nService.get('habits.habit_suggestions.tried_1', language)),
                            style: AppTypography.subtitle(
                              fontSize: 11,
                              color: isAdopted
                                  ? AppColors.success
                                  : AppColors.auroraStart,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _categoryCardColor(String category) {
    switch (category) {
      case 'morning':
        return AppColors.starGold;
      case 'evening':
        return AppColors.amethyst;
      case 'mindfulness':
        return AppColors.auroraStart;
      case 'social':
        return AppColors.brandPink;
      case 'creative':
        return AppColors.sunriseEnd;
      case 'physical':
        return AppColors.success;
      case 'reflective':
        return AppColors.auroraEnd;
      default:
        return AppColors.auroraStart;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HABIT DETAIL BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════

class _HabitDetailSheet extends StatefulWidget {
  final HabitSuggestion habit;
  final HabitSuggestionService service;
  final bool isDark;
  final bool isEn;
  final VoidCallback onChanged;

  const _HabitDetailSheet({
    required this.habit,
    required this.service,
    required this.isDark,
    required this.isEn,
    required this.onChanged,
  });

  @override
  State<_HabitDetailSheet> createState() => _HabitDetailSheetState();
}

class _HabitDetailSheetState extends State<_HabitDetailSheet> {
  late bool _isTried;
  late bool _isAdopted;
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isTried = widget.service.isTried(widget.habit.id);
    _isAdopted = widget.service.isAdopted(widget.habit.id);
    _isBookmarked = widget.service.isBookmarked(widget.habit.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isEn = widget.isEn;
    final habit = widget.habit;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        final language = AppLanguage.fromIsEn(isEn);
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: (isDark ? AppColors.cosmicPurple : Colors.white)
                    .withValues(alpha: isDark ? 0.85 : 0.92),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.auroraStart.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.auroraStart.withValues(alpha: 0.6),
                              AppColors.auroraEnd.withValues(alpha: 0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category + Duration header
                    Row(
                      children: [
                        AppSymbol(
                          HabitSuggestionService.categoryEmoji(habit.category),
                          size: AppSymbolSize.lg,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEn
                                    ? HabitSuggestionService.categoryDisplayNameEn(
                                        habit.category,
                                      )
                                    : HabitSuggestionService.categoryDisplayNameTr(
                                        habit.category,
                                      ),
                                style: AppTypography.elegantAccent(
                                  fontSize: 12,
                                  color: AppColors.auroraStart,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                '${habit.durationMinutes} ${L10nService.get('habits.habit_suggestions.minutes', language)}',
                                style: AppTypography.subtitle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bookmark button
                        IconButton(
                          tooltip: _isBookmarked
                              ? (L10nService.get('habits.habit_suggestions.remove_bookmark', language))
                              : (L10nService.get('habits.habit_suggestions.bookmark', language)),
                          icon: Icon(
                            _isBookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: _isBookmarked
                                ? AppColors.starGold
                                : (isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary),
                          ),
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            final result = await widget.service.toggleBookmark(
                              habit.id,
                            );
                            if (!mounted) return;
                            setState(() => _isBookmarked = result);
                            widget.onChanged();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Text(
                      habit.localizedTitle(language),
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      habit.localizedDescription(language),
                      style: AppTypography.decorativeScript(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: _isTried
                                ? (L10nService.get('habits.habit_suggestions.tried_2', language))
                                : (L10nService.get('habits.habit_suggestions.mark_as_tried', language)),
                            icon: _isTried
                                ? Icons.check_rounded
                                : Icons.touch_app_rounded,
                            color: AppColors.auroraStart,
                            isDark: isDark,
                            isActive: _isTried,
                            onTap: _isTried
                                ? null
                                : () async {
                                    HapticFeedback.mediumImpact();
                                    await widget.service.markAsTried(habit.id);
                                    if (!mounted) return;
                                    setState(() => _isTried = true);
                                    widget.onChanged();
                                  },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            label: _isAdopted
                                ? (L10nService.get('habits.habit_suggestions.adopted_2', language))
                                : (L10nService.get('habits.habit_suggestions.adopt_this_habit', language)),
                            icon: _isAdopted
                                ? Icons.check_circle_rounded
                                : Icons.favorite_border_rounded,
                            color: AppColors.success,
                            isDark: isDark,
                            isActive: _isAdopted,
                            onTap: () async {
                              HapticFeedback.mediumImpact();
                              if (_isAdopted) {
                                await widget.service.removeAdopted(habit.id);
                                if (!mounted) return;
                                setState(() => _isAdopted = false);
                              } else {
                                await widget.service.markAsAdopted(habit.id);
                                if (!mounted) return;
                                setState(() {
                                  _isAdopted = true;
                                  _isTried = true;
                                });
                              }
                              widget.onChanged();
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;
  final bool isActive;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? color.withValues(alpha: 0.15)
                : (isDark
                      ? AppColors.surfaceDark
                      : AppColors.lightSurfaceVariant),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? color.withValues(alpha: 0.4)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.08)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive
                    ? color
                    : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.modernAccent(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? color
                        : (isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
