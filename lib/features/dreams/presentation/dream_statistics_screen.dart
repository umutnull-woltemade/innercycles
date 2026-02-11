import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/dream_memory.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/dream_memory_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

/// Dream Statistics & Insights Dashboard
/// Comprehensive analytics for dream patterns, symbols, emotions, and progress
class DreamStatisticsScreen extends ConsumerStatefulWidget {
  const DreamStatisticsScreen({super.key});

  @override
  ConsumerState<DreamStatisticsScreen> createState() =>
      _DreamStatisticsScreenState();
}

class _DreamStatisticsScreenState extends ConsumerState<DreamStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DreamMemoryService? _memoryService;
  DreamMemory? _memory;
  List<Dream>? _allDreams;
  bool _isLoading = true;

  // Computed statistics
  DreamStats? _stats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      _memoryService = await DreamMemoryService.init();
      _memory = await _memoryService!.getDreamMemory();
      _allDreams = await _memoryService!.getAllDreams();
      _stats = _computeStats();
    } catch (e) {
      debugPrint('Error loading dream data: $e');
    }

    setState(() => _isLoading = false);
  }

  DreamStats _computeStats() {
    final dreams = _allDreams ?? [];
    final memory = _memory;

    if (dreams.isEmpty || memory == null) {
      return DreamStats.empty();
    }

    // Calculate streak
    int currentStreak = memory.milestones.currentStreak;
    int longestStreak = memory.milestones.longestStreak;

    // Calculate dreams per week (last 4 weeks)
    final fourWeeksAgo = DateTime.now().subtract(const Duration(days: 28));
    final recentDreams = dreams
        .where((d) => d.dreamDate.isAfter(fourWeeksAgo))
        .toList();
    double dreamsPerWeek = recentDreams.length / 4;

    // Lucid and nightmare percentages
    int lucidCount = dreams
        .where(
          (d) =>
              d.themes.any((t) => t.toLowerCase().contains('lucid')) ||
              d.content.toLowerCase().contains('bilincli ruya') ||
              d.content.toLowerCase().contains('lucid'),
        )
        .length;

    int nightmareCount = dreams
        .where(
          (d) =>
              d.dominantEmotion?.toLowerCase().contains('korku') == true ||
              d.themes.any((t) => t.toLowerCase().contains('nightmare')) ||
              d.themes.any((t) => t.toLowerCase().contains('kabus')),
        )
        .length;

    double lucidPercentage = dreams.isNotEmpty
        ? (lucidCount / dreams.length) * 100
        : 0;
    double nightmarePercentage = dreams.isNotEmpty
        ? (nightmareCount / dreams.length) * 100
        : 0;

    // Symbol frequency
    Map<String, int> symbolFrequency = {};
    for (final dream in dreams) {
      for (final symbol in dream.symbols) {
        symbolFrequency[symbol] = (symbolFrequency[symbol] ?? 0) + 1;
      }
    }

    // Emotion distribution
    Map<String, int> emotionDistribution = {};
    for (final dream in dreams) {
      if (dream.dominantEmotion != null) {
        emotionDistribution[dream.dominantEmotion!] =
            (emotionDistribution[dream.dominantEmotion!] ?? 0) + 1;
      }
    }

    // Dreams by day of week
    Map<int, int> dreamsByDayOfWeek = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0,
    };
    for (final dream in dreams) {
      dreamsByDayOfWeek[dream.dreamDate.weekday] =
          (dreamsByDayOfWeek[dream.dreamDate.weekday] ?? 0) + 1;
    }

    // Dreams by month
    Map<int, int> dreamsByMonth = {};
    for (int i = 1; i <= 12; i++) {
      dreamsByMonth[i] = 0;
    }
    for (final dream in dreams) {
      dreamsByMonth[dream.dreamDate.month] =
          (dreamsByMonth[dream.dreamDate.month] ?? 0) + 1;
    }

    // Moon phase correlation (approximate)
    Map<String, int> dreamsByMoonPhase = _calculateMoonPhaseDistribution(
      dreams,
    );

    // Theme clusters
    Map<String, int> themeFrequency = {};
    for (final dream in dreams) {
      for (final theme in dream.themes) {
        themeFrequency[theme] = (themeFrequency[theme] ?? 0) + 1;
      }
    }

    // Character frequency from content
    Map<String, int> characterFrequency = _extractCharacterFrequency(dreams);

    // Location frequency from content
    Map<String, int> locationFrequency = _extractLocationFrequency(dreams);

    // Recurring dreams detection
    List<RecurringDreamPattern> recurringPatterns = _detectRecurringPatterns(
      dreams,
    );

    // Progress tracking
    DreamProgressMetrics progress = _calculateProgress(dreams);

    // Achievements
    List<DreamAchievement> achievements = _calculateAchievements(
      dreams,
      memory,
    );

    return DreamStats(
      totalDreams: dreams.length,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      dreamsPerWeek: dreamsPerWeek,
      lucidPercentage: lucidPercentage,
      nightmarePercentage: nightmarePercentage,
      lucidCount: lucidCount,
      nightmareCount: nightmareCount,
      symbolFrequency: symbolFrequency,
      emotionDistribution: emotionDistribution,
      dreamsByDayOfWeek: dreamsByDayOfWeek,
      dreamsByMonth: dreamsByMonth,
      dreamsByMoonPhase: dreamsByMoonPhase,
      themeFrequency: themeFrequency,
      characterFrequency: characterFrequency,
      locationFrequency: locationFrequency,
      recurringPatterns: recurringPatterns,
      progress: progress,
      achievements: achievements,
    );
  }

  Map<String, int> _calculateMoonPhaseDistribution(List<Dream> dreams) {
    // Use internal keys for moon phases
    Map<String, int> moonPhases = {
      'new_moon': 0,
      'waxing_crescent': 0,
      'first_quarter': 0,
      'waxing_gibbous': 0,
      'full_moon': 0,
      'waning_gibbous': 0,
      'last_quarter': 0,
      'waning_crescent': 0,
    };

    for (final dream in dreams) {
      final phase = _getMoonPhaseKey(dream.dreamDate);
      moonPhases[phase] = (moonPhases[phase] ?? 0) + 1;
    }

    return moonPhases;
  }

  String _getMoonPhaseKey(DateTime date) {
    // Approximate moon phase calculation
    // Moon cycle is about 29.53 days
    // Reference: January 6, 2000 was a new moon
    final reference = DateTime(2000, 1, 6);
    final daysSinceReference = date.difference(reference).inDays;
    final moonAge = daysSinceReference % 29.53;

    if (moonAge < 1.85) return 'new_moon';
    if (moonAge < 7.38) return 'waxing_crescent';
    if (moonAge < 9.23) return 'first_quarter';
    if (moonAge < 14.77) return 'waxing_gibbous';
    if (moonAge < 16.61) return 'full_moon';
    if (moonAge < 22.15) return 'waning_gibbous';
    if (moonAge < 24.00) return 'last_quarter';
    return 'waning_crescent';
  }

  Map<String, int> _extractCharacterFrequency(List<Dream> dreams) {
    Map<String, int> characters = {};
    final characterPatterns = [
      'anne',
      'baba',
      'kardes',
      'arkadasim',
      'sevgilim',
      'esi',
      'cocuk',
      'bebek',
      'dede',
      'nine',
      'ogretmen',
      'patron',
      'yabanci',
      'taninmayan',
      'unlu',
      'hayvan',
    ];

    for (final dream in dreams) {
      final content = dream.content.toLowerCase();
      for (final character in characterPatterns) {
        if (content.contains(character)) {
          final displayName = _getCharacterDisplayName(character);
          characters[displayName] = (characters[displayName] ?? 0) + 1;
        }
      }
    }

    return characters;
  }

  String _getCharacterDisplayName(String key) {
    final lang = ref.read(languageProvider);
    // Map search keys to i18n keys
    final keyMap = {
      'anne': 'anne',
      'baba': 'baba',
      'kardes': 'kardes',
      'arkadasim': 'arkadas',
      'sevgilim': 'sevgili',
      'esi': 'es',
      'cocuk': 'cocuk',
      'bebek': 'bebek',
      'dede': 'dede',
      'nine': 'nine',
      'ogretmen': 'ogretmen',
      'patron': 'patron',
      'yabanci': 'yabanci',
      'taninmayan': 'taninmayan',
      'unlu': 'unlu',
      'hayvan': 'hayvan',
    };
    final i18nKey = keyMap[key] ?? key;
    return L10nService.get('dreams.statistics.characters.$i18nKey', lang);
  }

  Map<String, int> _extractLocationFrequency(List<Dream> dreams) {
    Map<String, int> locations = {};
    final locationPatterns = [
      'ev',
      'okul',
      'is',
      'deniz',
      'orman',
      'dag',
      'sehir',
      'koy',
      'hastane',
      'ucak',
      'araba',
      'tren',
      'uzay',
      'ada',
      'magara',
      'kale',
    ];

    for (final dream in dreams) {
      final content = dream.content.toLowerCase();
      for (final location in locationPatterns) {
        if (content.contains(location)) {
          final displayName = _getLocationDisplayName(location);
          locations[displayName] = (locations[displayName] ?? 0) + 1;
        }
      }
    }

    return locations;
  }

  String _getLocationDisplayName(String key) {
    final lang = ref.read(languageProvider);
    return L10nService.get('dreams.statistics.locations.$key', lang);
  }

  List<RecurringDreamPattern> _detectRecurringPatterns(List<Dream> dreams) {
    List<RecurringDreamPattern> patterns = [];

    // Find recurring symbols (3+ occurrences)
    Map<String, List<Dream>> symbolDreams = {};
    for (final dream in dreams) {
      for (final symbol in dream.symbols) {
        symbolDreams[symbol] = [...(symbolDreams[symbol] ?? []), dream];
      }
    }

    for (final entry in symbolDreams.entries) {
      if (entry.value.length >= 3) {
        patterns.add(
          RecurringDreamPattern(
            type: 'symbol', // Use key, will be localized in display
            identifier: entry.key,
            count: entry.value.length,
            firstOccurrence: entry.value.last.dreamDate,
            lastOccurrence: entry.value.first.dreamDate,
          ),
        );
      }
    }

    // Find recurring themes
    Map<String, List<Dream>> themeDreams = {};
    for (final dream in dreams) {
      for (final theme in dream.themes) {
        themeDreams[theme] = [...(themeDreams[theme] ?? []), dream];
      }
    }

    for (final entry in themeDreams.entries) {
      if (entry.value.length >= 3) {
        patterns.add(
          RecurringDreamPattern(
            type: 'theme', // Use key, will be localized in display
            identifier: entry.key,
            count: entry.value.length,
            firstOccurrence: entry.value.last.dreamDate,
            lastOccurrence: entry.value.first.dreamDate,
          ),
        );
      }
    }

    // Sort by count descending
    patterns.sort((a, b) => b.count.compareTo(a.count));
    return patterns.take(10).toList();
  }

  DreamProgressMetrics _calculateProgress(List<Dream> dreams) {
    if (dreams.isEmpty) {
      return DreamProgressMetrics(
        recallImprovement: 0,
        lucidProgress: 0,
        nightmareReduction: 0,
        shadowIntegration: 0,
        weeklyTrend: [],
      );
    }

    // Calculate weekly trend (last 8 weeks)
    List<int> weeklyTrend = [];
    for (int i = 7; i >= 0; i--) {
      final weekStart = DateTime.now().subtract(Duration(days: (i + 1) * 7));
      final weekEnd = DateTime.now().subtract(Duration(days: i * 7));
      final count = dreams
          .where(
            (d) =>
                d.dreamDate.isAfter(weekStart) && d.dreamDate.isBefore(weekEnd),
          )
          .length;
      weeklyTrend.add(count);
    }

    // Calculate recall improvement (compare first month to last month)
    double recallImprovement = 0;
    if (dreams.length >= 10) {
      final firstHalf = dreams.sublist(dreams.length ~/ 2);
      final secondHalf = dreams.sublist(0, dreams.length ~/ 2);
      final firstAvgWords = firstHalf.isEmpty
          ? 0
          : firstHalf
                    .map((d) => d.content.split(' ').length)
                    .reduce((a, b) => a + b) /
                firstHalf.length;
      final secondAvgWords = secondHalf.isEmpty
          ? 0
          : secondHalf
                    .map((d) => d.content.split(' ').length)
                    .reduce((a, b) => a + b) /
                secondHalf.length;
      if (firstAvgWords > 0) {
        recallImprovement =
            ((secondAvgWords - firstAvgWords) / firstAvgWords) * 100;
      }
    }

    // Calculate lucid progress
    int lucidFirst = dreams
        .sublist(dreams.length ~/ 2)
        .where(
          (d) =>
              d.themes.any((t) => t.toLowerCase().contains('lucid')) ||
              d.content.toLowerCase().contains('bilincli ruya'),
        )
        .length;
    int lucidSecond = dreams
        .sublist(0, dreams.length ~/ 2)
        .where(
          (d) =>
              d.themes.any((t) => t.toLowerCase().contains('lucid')) ||
              d.content.toLowerCase().contains('bilincli ruya'),
        )
        .length;
    double lucidProgress = lucidFirst > 0
        ? ((lucidSecond - lucidFirst) / lucidFirst) * 100
        : 0;

    // Calculate nightmare reduction
    int nightmareFirst = dreams
        .sublist(dreams.length ~/ 2)
        .where(
          (d) => d.dominantEmotion?.toLowerCase().contains('korku') == true,
        )
        .length;
    int nightmareSecond = dreams
        .sublist(0, dreams.length ~/ 2)
        .where(
          (d) => d.dominantEmotion?.toLowerCase().contains('korku') == true,
        )
        .length;
    double nightmareReduction = nightmareFirst > 0
        ? ((nightmareFirst - nightmareSecond) / nightmareFirst) * 100
        : 0;

    // Shadow integration (diversity of emotions explored)
    Set<String> emotionsExplored = {};
    for (final dream in dreams) {
      if (dream.dominantEmotion != null) {
        emotionsExplored.add(dream.dominantEmotion!);
      }
    }
    double shadowIntegration = (emotionsExplored.length / 10) * 100;
    shadowIntegration = shadowIntegration.clamp(0, 100);

    return DreamProgressMetrics(
      recallImprovement: recallImprovement,
      lucidProgress: lucidProgress,
      nightmareReduction: nightmareReduction,
      shadowIntegration: shadowIntegration,
      weeklyTrend: weeklyTrend,
    );
  }

  List<DreamAchievement> _calculateAchievements(
    List<Dream> dreams,
    DreamMemory memory,
  ) {
    final lang = ref.read(languageProvider);
    List<DreamAchievement> achievements = [];

    // Dream count milestones
    if (dreams.isNotEmpty) {
      achievements.add(
        DreamAchievement(
          id: 'first_dream',
          title: L10nService.get(
            'dreams.statistics.achievements_list.first_step',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.first_step_desc',
            lang,
          ),
          emoji: '🌱',
          isUnlocked: true,
          unlockedAt: dreams.last.createdAt,
        ),
      );
    }

    if (dreams.length >= 10) {
      achievements.add(
        DreamAchievement(
          id: 'dream_explorer',
          title: L10nService.get(
            'dreams.statistics.achievements_list.dream_explorer',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.dream_explorer_desc',
            lang,
          ),
          emoji: '🔍',
          isUnlocked: true,
        ),
      );
    }

    if (dreams.length >= 50) {
      achievements.add(
        DreamAchievement(
          id: 'dream_voyager',
          title: L10nService.get(
            'dreams.statistics.achievements_list.dream_traveler',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.dream_traveler_desc',
            lang,
          ),
          emoji: '🚀',
          isUnlocked: true,
        ),
      );
    }

    if (dreams.length >= 100) {
      achievements.add(
        DreamAchievement(
          id: 'dream_master',
          title: L10nService.get(
            'dreams.statistics.achievements_list.dream_master',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.dream_master_desc',
            lang,
          ),
          emoji: '👑',
          isUnlocked: true,
        ),
      );
    }

    // Streak achievements
    if (memory.milestones.longestStreak >= 7) {
      achievements.add(
        DreamAchievement(
          id: 'week_streak',
          title: L10nService.get(
            'dreams.statistics.achievements_list.weekly_streak',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.weekly_streak_desc',
            lang,
          ),
          emoji: '🔥',
          isUnlocked: true,
        ),
      );
    }

    if (memory.milestones.longestStreak >= 30) {
      achievements.add(
        DreamAchievement(
          id: 'month_streak',
          title: L10nService.get(
            'dreams.statistics.achievements_list.monthly_streak',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.monthly_streak_desc',
            lang,
          ),
          emoji: '⚡',
          isUnlocked: true,
        ),
      );
    }

    // Symbol discoveries
    int uniqueSymbols = memory.symbols.length;
    if (uniqueSymbols >= 10) {
      achievements.add(
        DreamAchievement(
          id: 'symbol_finder',
          title: L10nService.get(
            'dreams.statistics.achievements_list.symbol_hunter',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.symbol_hunter_desc',
            lang,
          ),
          emoji: '🎯',
          isUnlocked: true,
        ),
      );
    }

    if (uniqueSymbols >= 25) {
      achievements.add(
        DreamAchievement(
          id: 'symbol_master',
          title: L10nService.get(
            'dreams.statistics.achievements_list.symbol_master',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.symbol_master_desc',
            lang,
          ),
          emoji: '🏆',
          isUnlocked: true,
        ),
      );
    }

    // Lucid dreaming
    int lucidCount = dreams
        .where(
          (d) =>
              d.themes.any((t) => t.toLowerCase().contains('lucid')) ||
              d.content.toLowerCase().contains('bilincli ruya'),
        )
        .length;

    if (lucidCount >= 1) {
      achievements.add(
        DreamAchievement(
          id: 'first_lucid',
          title: L10nService.get(
            'dreams.statistics.achievements_list.awakening',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.awakening_desc',
            lang,
          ),
          emoji: '✨',
          isUnlocked: true,
        ),
      );
    }

    if (lucidCount >= 10) {
      achievements.add(
        DreamAchievement(
          id: 'lucid_master',
          title: L10nService.get(
            'dreams.statistics.achievements_list.lucid_master',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.lucid_master_desc',
            lang,
          ),
          emoji: '🌟',
          isUnlocked: true,
        ),
      );
    }

    // Add locked achievements
    if (dreams.length < 10) {
      achievements.add(
        DreamAchievement(
          id: 'dream_explorer_locked',
          title: L10nService.get(
            'dreams.statistics.achievements_list.dream_explorer',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.dream_explorer_desc',
            lang,
          ),
          emoji: '🔒',
          isUnlocked: false,
          progress: dreams.length / 10,
        ),
      );
    }

    if (memory.milestones.longestStreak < 7) {
      achievements.add(
        DreamAchievement(
          id: 'week_streak_locked',
          title: L10nService.get(
            'dreams.statistics.achievements_list.weekly_streak',
            lang,
          ),
          description: L10nService.get(
            'dreams.statistics.achievements_list.weekly_streak_desc',
            lang,
          ),
          emoji: '🔒',
          isUnlocked: false,
          progress: memory.milestones.longestStreak / 7,
        ),
      );
    }

    return achievements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildTabBar(),
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _stats == null || _stats!.totalDreams == 0
                    ? _buildEmptyState()
                    : _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.mystic.withValues(alpha: 0.3), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.mystic.withValues(alpha: 0.5),
                  AppColors.nebulaPurple.withValues(alpha: 0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Text(
              '\u{1F4CA}', // Chart emoji
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('dreams.statistics_title', language),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  L10nService.get('dreams.statistics_subtitle', language),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildTabBar() {
    final language = ref.watch(languageProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.mystic.withValues(alpha: 0.4),
              AppColors.cosmicPurple.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        dividerColor: Colors.transparent,
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textMuted,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: [
          Tab(text: L10nService.get('dreams.tab_general', language)),
          Tab(text: L10nService.get('dreams.tab_symbols', language)),
          Tab(text: L10nService.get('dreams.tab_time', language)),
          Tab(text: L10nService.get('dreams.tab_progress', language)),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(),
        _buildSymbolsTab(),
        _buildTimeTab(),
        _buildProgressTab(),
      ],
    );
  }

  Widget _buildLoadingState() {
    final language = ref.watch(languageProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.mystic),
          const SizedBox(height: 16),
          Text(
            L10nService.get('dreams.loading_data', language),
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final language = ref.watch(languageProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('\u{1F319}', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 24),
            Text(
              L10nService.get('dreams.no_dreams_yet', language),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              L10nService.get('dreams.no_dreams_description', language),
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/dream-interpretation'),
              icon: const Icon(Icons.add),
              label: Text(L10nService.get('dreams.save_dream', language)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mystic,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // OVERVIEW TAB
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.mystic,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewStats(),
            const SizedBox(height: 24),
            _buildEmotionSection(),
            const SizedBox(height: 24),
            _buildMoonPhaseSection(),
            const SizedBox(height: 24),
            _buildAchievementsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStats() {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mystic.withValues(alpha: 0.2),
            AppColors.cosmicPurple.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{2728}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.overview', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starGold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem(
                value: '${_stats!.totalDreams}',
                label: L10nService.get('dreams.total_dreams', language),
                emoji: '\u{1F319}',
              ),
              _buildStatItem(
                value: '${_stats!.currentStreak}',
                label: L10nService.get('dreams.current_streak', language),
                emoji: '\u{1F525}',
              ),
              _buildStatItem(
                value: _stats!.dreamsPerWeek.toStringAsFixed(1),
                label: L10nService.get('dreams.weekly_avg', language),
                emoji: '\u{1F4C5}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPercentageBar(
                  label: L10nService.get('dreams.lucid_dream', language),
                  value: _stats!.lucidPercentage,
                  color: AppColors.starGold,
                  emoji: '\u{2728}',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPercentageBar(
                  label: L10nService.get('dreams.nightmare', language),
                  value: _stats!.nightmarePercentage,
                  color: AppColors.fireElement,
                  emoji: '\u{1F47F}',
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1);
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required String emoji,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageBar({
    required String label,
    required double value,
    required Color color,
    required String emoji,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionSection() {
    if (_stats!.emotionDistribution.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final sortedEmotions = _stats!.emotionDistribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F3AD}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.emotion_distribution', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: CustomPaint(
              size: const Size(double.infinity, 180),
              painter: _EmotionPieChartPainter(
                emotions: _stats!.emotionDistribution,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: sortedEmotions.take(6).map((e) {
              final color = _getEmotionColor(e.key);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${e.key} (${e.value})',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Color _getEmotionColor(String emotion) {
    final colors = {
      'korku': AppColors.fireElement,
      'mutluluk': AppColors.starGold,
      'merak': AppColors.auroraStart,
      'huzur': AppColors.success,
      'saskinlik': AppColors.waterElement,
      'uzuntu': AppColors.mysticBlue,
      'ofke': const Color(0xFFE74C3C),
      'ask': AppColors.sunriseEnd,
    };
    return colors[emotion.toLowerCase()] ?? AppColors.mystic;
  }

  Widget _buildMoonPhaseSection() {
    if (_stats!.dreamsByMoonPhase.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final sortedPhases = _stats!.dreamsByMoonPhase.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final bestPhase = sortedPhases.first;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.moonSilver.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F311}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.moon_phase_correlation', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.moonSilver,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mystic.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  _getMoonPhaseEmoji(bestPhase.key),
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10nService.get('dreams.best_moon_phase', language),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        _getLocalizedMoonPhase(bestPhase.key, language),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  L10nService.get(
                    'dreams.dreams_count',
                    language,
                  ).replaceAll('{count}', '${bestPhase.value}'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.starGold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...sortedPhases
              .take(4)
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        _getMoonPhaseEmoji(e.key),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.key,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _stats!.totalDreams > 0
                              ? e.value / _stats!.totalDreams
                              : 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.moonSilver,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${e.value}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  String _getMoonPhaseEmoji(String phaseKey) {
    final emojis = {
      'new_moon': '\u{1F311}',
      'waxing_crescent': '\u{1F312}',
      'first_quarter': '\u{1F313}',
      'waxing_gibbous': '\u{1F314}',
      'full_moon': '\u{1F315}',
      'waning_gibbous': '\u{1F316}',
      'last_quarter': '\u{1F317}',
      'waning_crescent': '\u{1F318}',
    };
    return emojis[phaseKey] ?? '\u{1F319}';
  }

  String _getLocalizedMoonPhase(String phaseKey, AppLanguage language) {
    return L10nService.get('dreams.moon_phases.$phaseKey', language);
  }

  Widget _buildAchievementsSection() {
    if (_stats!.achievements.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final unlocked = _stats!.achievements.where((a) => a.isUnlocked).toList();
    final locked = _stats!.achievements.where((a) => !a.isUnlocked).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.starGold.withValues(alpha: 0.1),
            AppColors.surfaceDark.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.starGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F3C6}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.achievements', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starGold,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${unlocked.length}/${_stats!.achievements.length}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...unlocked.map((a) => _buildAchievementChip(a, true)),
              ...locked.take(3).map((a) => _buildAchievementChip(a, false)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildAchievementChip(DreamAchievement achievement, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.starGold.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked
              ? AppColors.starGold.withValues(alpha: 0.5)
              : Colors.white12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(achievement.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                achievement.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
              ),
              if (!isUnlocked && achievement.progress != null)
                SizedBox(
                  width: 60,
                  child: LinearProgressIndicator(
                    value: achievement.progress!,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation(AppColors.mystic),
                    minHeight: 2,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // SYMBOLS TAB
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildSymbolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSymbolsChart(),
          const SizedBox(height: 24),
          _buildSymbolWordCloud(),
          const SizedBox(height: 24),
          _buildRecurringPatternsSection(),
          const SizedBox(height: 24),
          _buildThemeClustersSection(),
        ],
      ),
    );
  }

  Widget _buildTopSymbolsChart() {
    if (_stats!.symbolFrequency.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final sortedSymbols = _stats!.symbolFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topSymbols = sortedSymbols.take(10).toList();
    final maxCount = topSymbols.isNotEmpty
        ? topSymbols.first.value.toDouble()
        : 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F52E}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.most_frequent_symbols', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...topSymbols.asMap().entries.map((entry) {
            final index = entry.key;
            final symbol = entry.value;
            final percentage = symbol.value / maxCount;
            final symbolInfo = DreamSymbol.commonSymbols[symbol.key];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      symbolInfo?.emoji ?? '\u{2728}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbolInfo?.nameTr ?? symbol.key,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.white10,
                            valueColor: AlwaysStoppedAnimation(
                              Color.lerp(
                                AppColors.mystic,
                                AppColors.starGold,
                                index / 10,
                              )!,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${symbol.value}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: -0.1);
          }),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildSymbolWordCloud() {
    if (_stats!.symbolFrequency.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final sortedSymbols = _stats!.symbolFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxCount = sortedSymbols.isNotEmpty
        ? sortedSymbols.first.value.toDouble()
        : 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{2601}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.symbol_cloud', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: sortedSymbols.take(20).map((entry) {
                final size = 12 + (entry.value / maxCount) * 18;
                final opacity = 0.5 + (entry.value / maxCount) * 0.5;
                final symbolInfo = DreamSymbol.commonSymbols[entry.key];

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mystic.withValues(alpha: opacity * 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.mystic.withValues(alpha: opacity * 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        symbolInfo?.emoji ?? '\u{2728}',
                        style: TextStyle(fontSize: size),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        symbolInfo?.nameTr ?? entry.key,
                        style: TextStyle(
                          fontSize: size - 4,
                          color: AppColors.textPrimary.withValues(
                            alpha: opacity,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildRecurringPatternsSection() {
    if (_stats!.recurringPatterns.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withValues(alpha: 0.1),
            AppColors.surfaceDark.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F504}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.recurring_patterns', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.auroraStart,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._stats!.recurringPatterns.take(5).map((pattern) {
            final symbolInfo = DreamSymbol.commonSymbols[pattern.identifier];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    symbolInfo?.emoji ?? '\u{1F504}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbolInfo?.nameTr ?? pattern.identifier,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          L10nService.get('dreams.pattern_repeated', language)
                              .replaceAll('{type}', pattern.type)
                              .replaceAll('{count}', '${pattern.count}'),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.auroraStart.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      L10nService.get('dreams.active', language),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.auroraStart,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildThemeClustersSection() {
    if (_stats!.themeFrequency.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final sortedThemes = _stats!.themeFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F3AF}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.theme_clusters', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sortedThemes.take(12).map((theme) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mystic.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.mystic.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      theme.key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.starGold.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${theme.value}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.starGold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // TIME TAB
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildTimeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekdayChart(),
          const SizedBox(height: 24),
          _buildMonthlyChart(),
          const SizedBox(height: 24),
          _buildCharacterFrequencySection(),
          const SizedBox(height: 24),
          _buildLocationFrequencySection(),
        ],
      ),
    );
  }

  Widget _buildWeekdayChart() {
    final language = ref.watch(languageProvider);
    final days = [
      L10nService.get('dreams.days.mon', language),
      L10nService.get('dreams.days.tue', language),
      L10nService.get('dreams.days.wed', language),
      L10nService.get('dreams.days.thu', language),
      L10nService.get('dreams.days.fri', language),
      L10nService.get('dreams.days.sat', language),
      L10nService.get('dreams.days.sun', language),
    ];
    final maxCount = _stats!.dreamsByDayOfWeek.values.isEmpty
        ? 1
        : _stats!.dreamsByDayOfWeek.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F4C5}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.by_day_of_week', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final count = _stats!.dreamsByDayOfWeek[index + 1] ?? 0;
                final height = maxCount > 0 ? (count / maxCount) * 100 : 0.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 32,
                      height: height + 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.mystic, AppColors.auroraStart],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mystic.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      days[index],
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildMonthlyChart() {
    final language = ref.watch(languageProvider);
    final months = [
      L10nService.get('dreams.months_short.jan', language),
      L10nService.get('dreams.months_short.feb', language),
      L10nService.get('dreams.months_short.mar', language),
      L10nService.get('dreams.months_short.apr', language),
      L10nService.get('dreams.months_short.may', language),
      L10nService.get('dreams.months_short.jun', language),
      L10nService.get('dreams.months_short.jul', language),
      L10nService.get('dreams.months_short.aug', language),
      L10nService.get('dreams.months_short.sep', language),
      L10nService.get('dreams.months_short.oct', language),
      L10nService.get('dreams.months_short.nov', language),
      L10nService.get('dreams.months_short.dec', language),
    ];
    final maxCount = _stats!.dreamsByMonth.values.isEmpty
        ? 1
        : _stats!.dreamsByMonth.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F4C8}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.monthly_distribution', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _LineChartPainter(
                data: List.generate(
                  12,
                  (i) => _stats!.dreamsByMonth[i + 1]?.toDouble() ?? 0,
                ),
                labels: months,
                maxValue: maxCount.toDouble(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(12, (index) {
              return Text(
                months[index],
                style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
              );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildCharacterFrequencySection() {
    if (_stats!.characterFrequency.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final sortedCharacters = _stats!.characterFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F465}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.character_frequency', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sortedCharacters.take(8).map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.waterElement.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.waterElement.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('\u{1F464}', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      e.key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.waterElement.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${e.value}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildLocationFrequencySection() {
    if (_stats!.locationFrequency.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final sortedLocations = _stats!.locationFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F5FA}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.location_frequency', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sortedLocations.take(8).map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.earthElement.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.earthElement.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('\u{1F4CD}', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      e.key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.earthElement.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${e.value}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // PROGRESS TAB
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeeklyTrendChart(),
          const SizedBox(height: 24),
          _buildProgressMetrics(),
          const SizedBox(height: 24),
          _buildShadowIntegrationSection(),
          const SizedBox(height: 24),
          _buildAllAchievements(),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendChart() {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withValues(alpha: 0.1),
            AppColors.surfaceDark.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.auroraStart.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F4C8}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.weekly_trend', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.auroraStart,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                L10nService.get('dreams.last_8_weeks', language),
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: CustomPaint(
              size: const Size(double.infinity, 100),
              painter: _TrendChartPainter(
                data: _stats!.progress.weeklyTrend
                    .map((e) => e.toDouble())
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(8, (index) {
              return Text(
                '${8 - index}h',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildProgressMetrics() {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F680}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.progress_metrics', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressRow(
            label: L10nService.get('dreams.dream_recall', language),
            value: _stats!.progress.recallImprovement,
            emoji: '\u{1F4DD}',
            description: L10nService.get('dreams.dream_detail_level', language),
          ),
          const SizedBox(height: 16),
          _buildProgressRow(
            label: L10nService.get('dreams.lucid_progress', language),
            value: _stats!.progress.lucidProgress,
            emoji: '\u{2728}',
            description: L10nService.get(
              'dreams.lucid_dream_development',
              language,
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressRow(
            label: L10nService.get('dreams.nightmare_reduction', language),
            value: _stats!.progress.nightmareReduction,
            emoji: '\u{1F31F}',
            description: L10nService.get(
              'dreams.nightmare_frequency_change',
              language,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildProgressRow({
    required String label,
    required double value,
    required String emoji,
    required String description,
  }) {
    final isPositive = value >= 0;
    final displayValue = value.abs();
    final color = isPositive ? AppColors.success : AppColors.fireElement;

    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                '${displayValue.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShadowIntegrationSection() {
    final language = ref.watch(languageProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.nebulaPurple.withValues(alpha: 0.3),
            AppColors.surfaceDark.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.mystic.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F319}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.shadow_integration', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mystic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            L10nService.get('dreams.shadow_description', language),
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CustomPaint(
                        painter: _ProgressCirclePainter(
                          progress: _stats!.progress.shadowIntegration / 100,
                          color: AppColors.mystic,
                        ),
                        child: Center(
                          child: Text(
                            '${_stats!.progress.shadowIntegration.toInt()}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      L10nService.get('dreams.discovered_emotions', language),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildJourneyStep(
                      L10nService.get('dreams.awareness', language),
                      true,
                    ),
                    _buildJourneyStep(
                      L10nService.get('dreams.acceptance', language),
                      _stats!.progress.shadowIntegration >= 30,
                    ),
                    _buildJourneyStep(
                      L10nService.get('dreams.understanding', language),
                      _stats!.progress.shadowIntegration >= 50,
                    ),
                    _buildJourneyStep(
                      L10nService.get('dreams.integration', language),
                      _stats!.progress.shadowIntegration >= 70,
                    ),
                    _buildJourneyStep(
                      L10nService.get('dreams.harmony', language),
                      _stats!.progress.shadowIntegration >= 90,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildJourneyStep(String label, bool isComplete) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isComplete
                  ? AppColors.success
                  : Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isComplete ? AppColors.success : Colors.white24,
                width: 2,
              ),
            ),
            child: isComplete
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isComplete ? AppColors.textPrimary : AppColors.textMuted,
              fontWeight: isComplete ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllAchievements() {
    if (_stats!.achievements.isEmpty) return const SizedBox.shrink();

    final language = ref.watch(languageProvider);
    final unlocked = _stats!.achievements.where((a) => a.isUnlocked).toList();
    final locked = _stats!.achievements.where((a) => !a.isUnlocked).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.starGold.withValues(alpha: 0.1),
            AppColors.surfaceDark.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.starGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u{1F3C6}', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                L10nService.get('dreams.all_achievements', language),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starGold,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${unlocked.length}/${_stats!.achievements.length}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (unlocked.isNotEmpty) ...[
            Text(
              L10nService.get('dreams.earned', language),
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ...unlocked.map((a) => _buildAchievementRow(a, true)),
          ],
          if (locked.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              L10nService.get('dreams.locked', language),
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ...locked.map((a) => _buildAchievementRow(a, false)),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildAchievementRow(DreamAchievement achievement, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.starGold.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? AppColors.starGold.withValues(alpha: 0.3)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Text(achievement.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
                Text(
                  achievement.description,
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                if (!isUnlocked && achievement.progress != null) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: achievement.progress!,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation(AppColors.mystic),
                      minHeight: 4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isUnlocked)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.starGold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, size: 16, color: AppColors.starGold),
            ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ════════════════════════════════════════════════════════════════════════════

class _EmotionPieChartPainter extends CustomPainter {
  final Map<String, int> emotions;

  _EmotionPieChartPainter({required this.emotions});

  @override
  void paint(Canvas canvas, Size size) {
    if (emotions.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    final total = emotions.values.reduce((a, b) => a + b);
    double startAngle = -math.pi / 2;

    final colors = [
      AppColors.fireElement,
      AppColors.starGold,
      AppColors.auroraStart,
      AppColors.success,
      AppColors.waterElement,
      AppColors.mysticBlue,
      const Color(0xFFE74C3C),
      AppColors.sunriseEnd,
      AppColors.mystic,
      AppColors.earthElement,
    ];

    int colorIndex = 0;
    for (final entry in emotions.entries) {
      final sweepAngle = (entry.value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = colors[colorIndex % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Border
      final borderPaint = Paint()
        ..color = Colors.black26
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
      colorIndex++;
    }

    // Inner circle for donut effect
    final innerPaint = Paint()
      ..color = AppColors.surfaceDark
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.5, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double maxValue;

  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.mystic
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y =
          size.height - (data[i] / (maxValue > 0 ? maxValue : 1)) * size.height;
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        final p0 = i > 0 ? points[i - 1] : points[0];
        final p1 = points[i];
        final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
        final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          p1.dx,
          p1.dy,
        );
      }

      canvas.drawPath(path, paint);

      // Draw gradient fill
      final fillPath = Path.from(path);
      fillPath.lineTo(size.width, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.mystic.withValues(alpha: 0.3),
          AppColors.mystic.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawPath(fillPath, Paint()..shader = gradient);

      // Draw points
      final pointPaint = Paint()
        ..color = AppColors.mystic
        ..style = PaintingStyle.fill;

      for (final point in points) {
        canvas.drawCircle(point, 4, pointPaint);
        canvas.drawCircle(
          point,
          6,
          Paint()..color = AppColors.mystic.withValues(alpha: 0.3),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrendChartPainter extends CustomPainter {
  final List<double> data;

  _TrendChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return;

    final paint = Paint()
      ..color = AppColors.auroraStart
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] / maxValue) * size.height;
      points.add(Offset(x, y.clamp(0, size.height)));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        final p0 = points[i - 1];
        final p1 = points[i];
        final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
        final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          p1.dx,
          p1.dy,
        );
      }

      // Glow effect
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.auroraStart.withValues(alpha: 0.3)
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      canvas.drawPath(path, paint);

      // Draw points
      for (final point in points) {
        canvas.drawCircle(point, 5, Paint()..color = AppColors.auroraStart);
        canvas.drawCircle(point, 3, Paint()..color = Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProgressCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ProgressCirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Glow effect
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ════════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ════════════════════════════════════════════════════════════════════════════

class DreamStats {
  final int totalDreams;
  final int currentStreak;
  final int longestStreak;
  final double dreamsPerWeek;
  final double lucidPercentage;
  final double nightmarePercentage;
  final int lucidCount;
  final int nightmareCount;
  final Map<String, int> symbolFrequency;
  final Map<String, int> emotionDistribution;
  final Map<int, int> dreamsByDayOfWeek;
  final Map<int, int> dreamsByMonth;
  final Map<String, int> dreamsByMoonPhase;
  final Map<String, int> themeFrequency;
  final Map<String, int> characterFrequency;
  final Map<String, int> locationFrequency;
  final List<RecurringDreamPattern> recurringPatterns;
  final DreamProgressMetrics progress;
  final List<DreamAchievement> achievements;

  DreamStats({
    required this.totalDreams,
    required this.currentStreak,
    required this.longestStreak,
    required this.dreamsPerWeek,
    required this.lucidPercentage,
    required this.nightmarePercentage,
    required this.lucidCount,
    required this.nightmareCount,
    required this.symbolFrequency,
    required this.emotionDistribution,
    required this.dreamsByDayOfWeek,
    required this.dreamsByMonth,
    required this.dreamsByMoonPhase,
    required this.themeFrequency,
    required this.characterFrequency,
    required this.locationFrequency,
    required this.recurringPatterns,
    required this.progress,
    required this.achievements,
  });

  factory DreamStats.empty() => DreamStats(
    totalDreams: 0,
    currentStreak: 0,
    longestStreak: 0,
    dreamsPerWeek: 0,
    lucidPercentage: 0,
    nightmarePercentage: 0,
    lucidCount: 0,
    nightmareCount: 0,
    symbolFrequency: {},
    emotionDistribution: {},
    dreamsByDayOfWeek: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0},
    dreamsByMonth: {},
    dreamsByMoonPhase: {},
    themeFrequency: {},
    characterFrequency: {},
    locationFrequency: {},
    recurringPatterns: [],
    progress: DreamProgressMetrics(
      recallImprovement: 0,
      lucidProgress: 0,
      nightmareReduction: 0,
      shadowIntegration: 0,
      weeklyTrend: [],
    ),
    achievements: [],
  );
}

class RecurringDreamPattern {
  final String type;
  final String identifier;
  final int count;
  final DateTime firstOccurrence;
  final DateTime lastOccurrence;

  RecurringDreamPattern({
    required this.type,
    required this.identifier,
    required this.count,
    required this.firstOccurrence,
    required this.lastOccurrence,
  });
}

class DreamProgressMetrics {
  final double recallImprovement;
  final double lucidProgress;
  final double nightmareReduction;
  final double shadowIntegration;
  final List<int> weeklyTrend;

  DreamProgressMetrics({
    required this.recallImprovement,
    required this.lucidProgress,
    required this.nightmareReduction,
    required this.shadowIntegration,
    required this.weeklyTrend,
  });
}

class DreamAchievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double? progress;

  DreamAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.isUnlocked,
    this.unlockedAt,
    this.progress,
  });
}
