// ════════════════════════════════════════════════════════════════════════════
// HABIT SUGGESTIONS SCREEN - Browsable Micro-Habit Library
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/habit_suggestions_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/habit_suggestion_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(habitSuggestionServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Text(
              isEn ? 'Something went wrong' : 'Bir şeyler yanlış gitti',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
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

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // ═══ APP BAR ═══
        SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: true,
          backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              isEn ? 'Micro-Habits' : 'Mikro Alışkanlıklar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
              ),
            ),
            titlePadding: const EdgeInsets.only(left: 52, bottom: 16),
          ),
          actions: [
            // Bookmark filter toggle
            IconButton(
              icon: Icon(
                _showBookmarksOnly
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: _showBookmarksOnly
                    ? AppColors.starGold
                    : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
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
              onTap: () => _showHabitDetail(context, dailyHabit, service, isDark, isEn),
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
                    label: isEn ? 'All' : 'Tümü',
                    emoji: '✨',
                    isSelected: _selectedCategory == null && !_showBookmarksOnly,
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
                            ? HabitSuggestionService.categoryDisplayNameEn(cat)
                            : HabitSuggestionService.categoryDisplayNameTr(cat),
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
                  isEn ? 'No bookmarked habits yet' : 'Henüz kayıtlı alışkanlık yok',
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final habit = habits[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _HabitCard(
                      habit: habit,
                      service: service,
                      isDark: isDark,
                      isEn: isEn,
                      onTap: () =>
                          _showHabitDetail(context, habit, service, isDark, isEn),
                      onRefresh: () => setState(() {}),
                    ),
                  ).animate().fadeIn(
                        duration: 300.ms,
                        delay: Duration(milliseconds: (50 * index).clamp(0, 400)),
                      );
                },
                childCount: habits.length,
              ),
            ),
          ),
      ],
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
    final isTried = service.isTried(habit.id);
    final isAdopted = service.isAdopted(habit.id);

    return GestureDetector(
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
                  child: Text(
                    HabitSuggestionService.categoryEmoji(habit.category),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn ? 'Today\'s Habit' : 'Bugünün Alışkanlığı',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.auroraStart,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isEn ? habit.titleEn : habit.titleTr,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
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
                      color: (isAdopted ? AppColors.success : AppColors.auroraStart)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isAdopted
                          ? (isEn ? 'Adopted' : 'Benimsendi')
                          : (isEn ? 'Tried' : 'Denendi'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isAdopted ? AppColors.success : AppColors.auroraStart,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isEn ? habit.descriptionEn : habit.descriptionTr,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
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
                    color: AppColors.auroraStart.withValues(alpha: isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isEn
                        ? HabitSuggestionService.categoryDisplayNameEn(
                            habit.category)
                        : HabitSuggestionService.categoryDisplayNameTr(
                            habit.category),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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
                        '${habit.durationMinutes} min',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
                  GestureDetector(
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
                          color: AppColors.auroraStart.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        isEn ? 'Try it' : 'Dene',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.auroraStart,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
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
    final tried = service.triedCount;
    final adopted = service.adoptedCount;
    final total = service.totalCount;
    final progress = service.explorationProgress;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.8)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                isEn ? 'Habits Explored' : 'Keşfedilen Alışkanlıklar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$tried / $total',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.auroraStart),
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
                  style: TextStyle(
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
    return GestureDetector(
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
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.auroraStart
                    : (isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
          ],
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
    final isTried = service.isTried(habit.id);
    final isAdopted = service.isAdopted(habit.id);
    final isBookmarked = service.isBookmarked(habit.id);

    return GestureDetector(
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
                color: _categoryCardColor(habit.category)
                    .withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  HabitSuggestionService.categoryEmoji(habit.category),
                  style: const TextStyle(fontSize: 18),
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
                          isEn ? habit.titleEn : habit.titleTr,
                          style: TextStyle(
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
                        '${habit.durationMinutes} min',
                        style: TextStyle(
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
                              ? (isEn ? 'Adopted' : 'Benimsendi')
                              : (isEn ? 'Tried' : 'Denendi'),
                          style: TextStyle(
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
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Category + Duration header
                Row(
                  children: [
                    Text(
                      HabitSuggestionService.categoryEmoji(habit.category),
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn
                                ? HabitSuggestionService.categoryDisplayNameEn(
                                    habit.category)
                                : HabitSuggestionService.categoryDisplayNameTr(
                                    habit.category),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.auroraStart,
                            ),
                          ),
                          Text(
                            '${habit.durationMinutes} ${isEn ? 'minutes' : 'dakika'}',
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
                    // Bookmark button
                    IconButton(
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
                        final result =
                            await widget.service.toggleBookmark(habit.id);
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
                  isEn ? habit.titleEn : habit.titleTr,
                  style: TextStyle(
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
                  isEn ? habit.descriptionEn : habit.descriptionTr,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
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
                            ? (isEn ? 'Tried' : 'Denendi')
                            : (isEn ? 'Mark as Tried' : 'Denendi Olarak İşaretle'),
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
                            ? (isEn ? 'Adopted' : 'Benimsendi')
                            : (isEn ? 'Adopt this Habit' : 'Bu Alışkanlığı Benimse'),
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
    return GestureDetector(
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
            Icon(icon, size: 16, color: isActive ? color : (isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
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
    );
  }
}
