// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL CYCLE VISUALIZER - InnerCycles Signature Feature
// ════════════════════════════════════════════════════════════════════════════
// The signature screen of InnerCycles. Visualizes emotional patterns as
// smooth animated wave curves with gradient fills, cycle detection,
// phase analysis, per-area summary cards, insights, and share.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/services/emotional_cycle_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import 'widgets/cycle_wave_painter.dart';
import 'widgets/cycle_summary_card.dart';

// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL CYCLE SCREEN
// ════════════════════════════════════════════════════════════════════════════

class EmotionalCycleScreen extends ConsumerStatefulWidget {
  const EmotionalCycleScreen({super.key});

  @override
  ConsumerState<EmotionalCycleScreen> createState() =>
      _EmotionalCycleScreenState();
}

class _EmotionalCycleScreenState extends ConsumerState<EmotionalCycleScreen>
    with SingleTickerProviderStateMixin {
  final Set<FocusArea> _visibleAreas = Set.from(FocusArea.values);
  late AnimationController _waveAnimController;
  late Animation<double> _waveAnimation;
  CycleDataPointInfo? _selectedPoint;

  @override
  void initState() {
    super.initState();
    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _waveAnimation = CurvedAnimation(
      parent: _waveAnimController,
      curve: Curves.easeOutCubic,
    );
    // Start animation after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _waveAnimController.forward();
    });
  }

  @override
  void dispose() {
    _waveAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.starGold),
            ),
            error: (_, _) => Center(
              child: Text(
                isEn ? 'Unable to load data' : 'Veri yuklenemedi',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            data: (service) {
              final cycleService = EmotionalCycleService(service);

              if (!cycleService.hasEnoughData()) {
                return _buildLockedView(
                  context,
                  isDark,
                  isEn,
                  cycleService.entriesNeeded(),
                  service.entryCount,
                );
              }

              final analysis = cycleService.analyze();
              return _buildContent(
                context,
                service,
                cycleService,
                analysis,
                isDark,
                isEn,
              );
            },
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LOCKED VIEW - Not enough entries yet
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildLockedView(
    BuildContext context,
    bool isDark,
    bool isEn,
    int needed,
    int current,
  ) {
    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Your Inner Cycles' : 'Ic Dongulerin',
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated wave icon
                    Icon(
                      Icons.waves,
                      size: 72,
                      color: AppColors.auroraStart.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isEn
                          ? 'Your Cycles Are Forming'
                          : 'Dongulerin Olusturuluyor',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isEn
                          ? 'Log $needed more entries to discover your emotional patterns. You have $current so far.'
                          : '$needed kayit daha yap ve duygusal kaliplarini kesfet. Su ana kadar $current kaydin var.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: current / 7,
                        backgroundColor: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.3)
                            : AppColors.lightSurfaceVariant,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.auroraStart),
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$current / 7',
                      style: const TextStyle(
                        color: AppColors.auroraStart,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => context.push('/journal'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.auroraStart,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusLg),
                        ),
                      ),
                      icon: const Icon(Icons.edit_note, size: 20),
                      label: Text(
                        isEn ? 'Start Journaling' : 'Kayit Yapmaya Basla',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ].animate(interval: 80.ms).fadeIn(duration: 400.ms),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MAIN CONTENT
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildContent(
    BuildContext context,
    dynamic service,
    EmotionalCycleService cycleService,
    EmotionalCycleAnalysis analysis,
    bool isDark,
    bool isEn,
  ) {
    final now = DateTime.now();
    final bool hasEnoughForFull = analysis.totalEntries >= 30;
    final int displayDays = hasEnoughForFull ? 30 : 14;
    final rangeStart = now.subtract(Duration(days: displayDays));

    // Build per-area data points for wave chart
    final Map<FocusArea, List<CycleDataPoint>> chartData = {};
    for (final area in FocusArea.values) {
      chartData[area] =
          cycleService.getAreaDataPoints(area, rangeStart, now);
    }

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Your Inner Cycles' : 'Ic Dongulerin',
            largeTitleMode: true,
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ══════════════════════════════════════════════════════════
                // HERO SECTION: Wave Chart
                // ══════════════════════════════════════════════════════════
                _buildHeroWaveSection(
                  context,
                  isDark,
                  isEn,
                  chartData,
                  displayDays,
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: AppConstants.spacingMd),

                // ══════════════════════════════════════════════════════════
                // FOCUS AREA LEGEND (toggle chips)
                // ══════════════════════════════════════════════════════════
                _buildLegend(context, isDark, isEn)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingXl),

                // ══════════════════════════════════════════════════════════
                // CYCLE SUMMARY CARDS
                // ══════════════════════════════════════════════════════════
                Text(
                  isEn ? 'Your Dimensions' : 'Boyutlarin',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingMd),

                ...FocusArea.values.asMap().entries.map((entry) {
                  final area = entry.value;
                  final summary = analysis.areaSummaries[area];
                  if (summary == null) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spacingMd,
                    ),
                    child: CycleSummaryCard(
                      summary: summary,
                      isDark: isDark,
                      isEn: isEn,
                    ),
                  ).animate().fadeIn(
                    delay: (350 + entry.key * 60).ms,
                    duration: 400.ms,
                  ).slideY(
                    begin: 0.05,
                    end: 0,
                    delay: (350 + entry.key * 60).ms,
                    duration: 400.ms,
                  );
                }),

                const SizedBox(height: AppConstants.spacingXl),

                // ══════════════════════════════════════════════════════════
                // CYCLE INSIGHTS
                // ══════════════════════════════════════════════════════════
                if (analysis.insights.isNotEmpty) ...[
                  Text(
                    isEn ? 'Cycle Insights' : 'Dongu Icgoruleri',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
                  const SizedBox(height: AppConstants.spacingMd),
                  ...analysis.insights.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.spacingMd,
                      ),
                      child: _buildInsightCard(
                        context,
                        isDark,
                        isEn,
                        entry.value,
                      ),
                    ).animate().fadeIn(
                      delay: (750 + entry.key * 60).ms,
                      duration: 400.ms,
                    );
                  }),
                ],

                const SizedBox(height: AppConstants.spacingLg),

                // ══════════════════════════════════════════════════════════
                // SHARE BUTTON
                // ══════════════════════════════════════════════════════════
                _buildShareButton(context, isDark, isEn)
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 400.ms),

                // ══════════════════════════════════════════════════════════
                // PREMIUM GATE (if not enough for 30-day view)
                // ══════════════════════════════════════════════════════════
                if (!hasEnoughForFull) ...[
                  const SizedBox(height: AppConstants.spacingLg),
                  _buildPremiumGate(
                    context,
                    isDark,
                    isEn,
                    analysis.totalEntries,
                  ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                ],

                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HERO WAVE SECTION
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildHeroWaveSection(
    BuildContext context,
    bool isDark,
    bool isEn,
    Map<FocusArea, List<CycleDataPoint>> chartData,
    int displayDays,
  ) {
    final hasData = chartData.values.any((list) => list.isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.8)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: isDark
              ? AppColors.auroraStart.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                Icons.waves,
                color: AppColors.auroraStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isEn
                    ? 'Last $displayDays Days'
                    : 'Son $displayDays Gun',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Wave chart
          if (!hasData)
            SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 48,
                      color: isDark
                          ? AppColors.textMuted.withValues(alpha: 0.4)
                          : AppColors.lightTextMuted.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isEn
                          ? 'Start journaling to see your cycles'
                          : 'Dongulerni gormek icin kayit yapmaya basla',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, _) {
                return SizedBox(
                  height: 240,
                  child: CycleWaveChart(
                    areaData: chartData,
                    visibleAreas: _visibleAreas,
                    isDark: isDark,
                    displayDays: displayDays,
                    animationProgress: _waveAnimation.value,
                    onPointSelected: (info) {
                      setState(() => _selectedPoint = info);
                    },
                  ),
                );
              },
            ),

          // Selected point info
          if (_selectedPoint != null) ...[
            const SizedBox(height: AppConstants.spacingSm),
            _buildSelectedPointInfo(context, isDark, isEn),
          ],

          // Date axis labels
          if (hasData)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEn
                        ? '$displayDays days ago'
                        : '$displayDays gun once',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    isEn ? 'Today' : 'Bugun',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SELECTED POINT INFO BAR
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildSelectedPointInfo(
    BuildContext context,
    bool isDark,
    bool isEn,
  ) {
    final point = _selectedPoint!;
    final color = kAreaColors[point.area] ?? AppColors.auroraStart;
    final areaName =
        isEn ? point.area.displayNameEn : point.area.displayNameTr;
    final dateStr =
        '${point.date.day}/${point.date.month}/${point.date.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$areaName: ${point.value.toStringAsFixed(1)}',
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
            dateStr,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FOCUS AREA LEGEND
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildLegend(BuildContext context, bool isDark, bool isEn) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: FocusArea.values.map((area) {
          final isVisible = _visibleAreas.contains(area);
          final color = kAreaColors[area]!;
          final label = isEn ? area.displayNameEn : area.displayNameTr;

          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingSm),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isVisible) {
                    _visibleAreas.remove(area);
                  } else {
                    _visibleAreas.add(area);
                  }
                });
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isVisible
                        ? color.withValues(alpha: 0.15)
                        : (isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.5)
                            : AppColors.lightSurfaceVariant),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                    border: Border.all(
                      color: isVisible
                          ? color.withValues(alpha: 0.5)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isVisible
                              ? color
                              : color.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          boxShadow: isVisible
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isVisible ? FontWeight.w600 : FontWeight.normal,
                          color: isVisible
                              ? (isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary)
                              : (isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted),
                        ),
                      ),
                    ],
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
  // INSIGHT CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildInsightCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    CycleInsight insight,
  ) {
    final color = insight.relatedArea != null
        ? (kAreaColors[insight.relatedArea!] ?? AppColors.auroraStart)
        : AppColors.auroraStart;

    final icon = _insightIcon(insight);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEn ? insight.messageEn : insight.messageTr,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _insightIcon(CycleInsight insight) {
    final msg = insight.messageEn.toLowerCase();
    if (msg.contains('strongest')) return Icons.star;
    if (msg.contains('move together') || msg.contains('tend to be'))
      return Icons.link;
    if (msg.contains('higher on')) return Icons.calendar_today;
    if (msg.contains('cycle')) return Icons.waves;
    if (msg.contains('improving')) return Icons.trending_up;
    if (msg.contains('attention')) return Icons.priority_high;
    return Icons.lightbulb_outline;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHARE BUTTON
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildShareButton(BuildContext context, bool isDark, bool isEn) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        gradient: const LinearGradient(
          colors: [AppColors.auroraStart, AppColors.auroraEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/share-insight'),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.share, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  isEn
                      ? 'Share My Inner Cycles'
                      : 'Ic Dongullerimi Paylas',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PREMIUM GATE
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildPremiumGate(
    BuildContext context,
    bool isDark,
    bool isEn,
    int totalEntries,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withValues(alpha: 0.12),
            AppColors.auroraEnd.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lock_outline,
            color: AppColors.starGold,
            size: 36,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            isEn ? 'Unlock Full 30-Day View' : 'Tam 30 Gunluk Gorunumu Ac',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.starGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            isEn
                ? 'You have $totalEntries entries. Log 30+ days for the full cycle view, or go premium.'
                : '$totalEntries kaydin var. Tam dongu gorunumu icin 30+ gun kayit yap veya premium\'a gec.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/premium'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.starGold,
                side: const BorderSide(color: AppColors.starGold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusLg),
                ),
              ),
              child: Text(
                isEn ? 'Go Premium' : 'Premium\'a Gec',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
