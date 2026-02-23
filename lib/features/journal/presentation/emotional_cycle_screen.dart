// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL CYCLE VISUALIZER - InnerCycles Signature Feature
// ════════════════════════════════════════════════════════════════════════════
// The signature screen of InnerCycles. Visualizes emotional patterns as
// smooth animated wave curves with gradient fills, cycle detection,
// phase analysis, per-area summary cards, insights, and share.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/services/emotional_cycle_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/premium_card.dart';
import 'widgets/cycle_wave_painter.dart';
import 'widgets/cycle_summary_card.dart';
import 'widgets/phase_ring.dart';
import 'widgets/shift_outlook_card.dart';
import 'widgets/pattern_loop_analyzer.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _waveAnimController.forward();
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('emotionalCycles'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData(
            (s) => s.trackToolOpen('emotionalCycles', source: 'direct'),
          );
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
    final cycleServiceAsync = ref.watch(emotionalCycleServiceProvider);
    final analysisAsync = ref.watch(emotionalCycleAnalysisProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: cycleServiceAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
              child: Text(
                isEn ? 'Unable to load data' : 'Veri yüklenemedi',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            data: (cycleService) {
              if (!cycleService.hasEnoughData()) {
                return _buildLockedView(
                  context,
                  isDark,
                  isEn,
                  cycleService.entriesNeeded(),
                  cycleService.entryCount,
                );
              }
              final analysis = analysisAsync.valueOrNull;
              if (analysis == null) {
                return const CosmicLoadingIndicator();
              }
              return _buildContent(
                context,
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
  // LOCKED VIEW
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
            title: isEn ? 'Your Inner Cycles' : 'İç Döngülerin',
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Blurred wave preview teaser
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.auroraStart.withValues(
                                      alpha: 0.12,
                                    ),
                                    AppColors.amethyst.withValues(alpha: 0.08),
                                    AppColors.success.withValues(alpha: 0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CustomPaint(
                                painter: _WavePreviewPainter(
                                  color: AppColors.auroraStart.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                                : Colors.white.withValues(alpha: 0.8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.auroraStart.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.waves,
                            size: 28,
                            color: AppColors.auroraStart,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isEn ? 'Your Cycles Are Forming' : 'Döngülerin Oluşuyor',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
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
                          ? 'Pattern detection requires a minimum of 7 entries across 5 days. You have $current so far.'
                          : 'Kalıp tespiti en az 7 kayıt ve 5 gün gerektirir. Şu ana kadar $current kaydın var.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    // Animated circular progress
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: (current / 7).clamp(0.0, 1.0),
                              strokeWidth: 6,
                              backgroundColor: isDark
                                  ? AppColors.surfaceLight.withValues(
                                      alpha: 0.2,
                                    )
                                  : AppColors.lightSurfaceVariant,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.auroraStart,
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Text(
                            '$current/7',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.auroraStart,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => context.go(Routes.journal),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.auroraStart,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusLg,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.edit_note, size: 20),
                        label: Text(
                          isEn ? 'Start Journaling' : 'Kayıt Yapmaya Başla',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
    EmotionalCycleService cycleService,
    EmotionalCycleAnalysis analysis,
    bool isDark,
    bool isEn,
  ) {
    final now = DateTime.now();
    final bool hasEnoughForFull = analysis.totalEntries >= 30;
    final int displayDays = hasEnoughForFull ? 30 : 14;
    final rangeStart = now.subtract(Duration(days: displayDays));
    final Map<FocusArea, List<CycleDataPoint>> chartData = {};
    for (final area in FocusArea.values) {
      chartData[area] = cycleService.getAreaDataPoints(area, rangeStart, now);
    }

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Your Inner Cycles' : 'İç Döngülerin',
            largeTitleMode: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // PHASE RING
                if (analysis.overallPhase != null) ...[
                  Center(
                        child: PhaseRing(
                          phase: analysis.overallPhase!,
                          arc: analysis.overallArc,
                          isDark: isDark,
                          isEn: isEn,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                        duration: 600.ms,
                      ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark.withValues(alpha: 0.6)
                            : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                      ),
                      child: Text(
                        isEn
                            ? analysis.overallPhase!.descriptionEn()
                            : analysis.overallPhase!.descriptionTr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  const SizedBox(height: AppConstants.spacingXl),
                ],

                // WAVE CHART
                _buildHeroWaveSection(
                  context,
                  isDark,
                  isEn,
                  chartData,
                  displayDays,
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: AppConstants.spacingMd),

                // LEGEND
                _buildLegend(
                  context,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingXl),

                // SUMMARY CARDS
                Text(
                  isEn ? 'Your Dimensions' : 'Boyutların',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingMd),

                ...FocusArea.values.asMap().entries.map((entry) {
                  final summary = analysis.areaSummaries[entry.value];
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
                      )
                      .animate()
                      .fadeIn(
                        delay: (350 + entry.key * 60).ms,
                        duration: 400.ms,
                      )
                      .slideY(
                        begin: 0.05,
                        end: 0,
                        delay: (350 + entry.key * 60).ms,
                        duration: 400.ms,
                      );
                }),

                const SizedBox(height: AppConstants.spacingXl),

                // INSIGHTS
                if (analysis.insights.isNotEmpty) ...[
                  Text(
                    isEn ? 'Cycle Insights' : 'Döngü İçgörüleri',
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

                // SHIFT OUTLOOK (Premium)
                _buildShiftOutlookSection(
                  context,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 850.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingLg),

                // PATTERN LOOPS
                _buildPatternLoopSection(
                  context,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingLg),

                // SHARE
                _buildShareButton(
                  context,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 950.ms, duration: 400.ms),

                // PREMIUM GATE
                if (!hasEnoughForFull) ...[
                  const SizedBox(height: AppConstants.spacingLg),
                  _buildPremiumGate(
                    context,
                    isDark,
                    isEn,
                    analysis.totalEntries,
                  ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                ],
                ContentDisclaimer(
                  language: isEn ? AppLanguage.en : AppLanguage.tr,
                ),
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
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      borderRadius: AppConstants.radiusXl,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.waves, color: AppColors.auroraStart, size: 20),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Last $displayDays Days' : 'Son $displayDays Gün',
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
                          : 'Döngüleri görmek için kayıt yapmaya başla',
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
              builder: (context, _) => SizedBox(
                height: 240,
                child: CycleWaveChart(
                  areaData: chartData,
                  visibleAreas: _visibleAreas,
                  isDark: isDark,
                  isEn: isEn,
                  displayDays: displayDays,
                  animationProgress: _waveAnimation.value,
                  onPointSelected: (info) =>
                      setState(() => _selectedPoint = info),
                ),
              ),
            ),
          if (_selectedPoint != null) ...[
            const SizedBox(height: AppConstants.spacingSm),
            _buildSelectedPointInfo(context, isDark, isEn),
          ],
          if (hasData)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEn ? '$displayDays days ago' : '$displayDays gün önce',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  Text(
                    isEn ? 'Today' : 'Bugün',
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

  Widget _buildSelectedPointInfo(BuildContext context, bool isDark, bool isEn) {
    final point = _selectedPoint!;
    final color = kAreaColors[point.area] ?? AppColors.auroraStart;
    final areaName = isEn ? point.area.displayNameEn : point.area.displayNameTr;
    final dateStr = '${point.date.day}/${point.date.month}/${point.date.year}';
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LEGEND
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildLegend(BuildContext context, bool isDark, bool isEn) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: FocusArea.values.map((area) {
          final isVisible = _visibleAreas.contains(area);
          final color = kAreaColors[area] ?? AppColors.auroraStart;
          final label = isEn ? area.displayNameEn : area.displayNameTr;
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingSm),
            child: Semantics(
              label:
                  '$label ${isVisible ? (isEn ? "visible" : "görünür") : (isEn ? "hidden" : "gizli")}',
              toggled: isVisible,
              button: true,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    isVisible
                        ? _visibleAreas.remove(area)
                        : _visibleAreas.add(area);
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
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusFull,
                      ),
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
                            fontWeight: isVisible
                                ? FontWeight.w600
                                : FontWeight.normal,
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
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
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
  // SHIFT OUTLOOK (Premium)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildShiftOutlookSection(
    BuildContext context,
    bool isDark,
    bool isEn,
  ) {
    final isPremium = ref.watch(isPremiumUserProvider);
    final outlookAsync = ref.watch(shiftOutlookProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isEn ? 'Shift Outlook' : 'Kayma Görünümü',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (!isPremium) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.starGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.starGold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        if (isPremium)
          outlookAsync.when(
            loading: () => const SizedBox(
              height: 80,
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (outlook) =>
                ShiftOutlookCard(outlook: outlook, isDark: isDark, isEn: isEn),
          )
        else
          Semantics(
            button: true,
            label: isEn ? 'Access Shift Outlook' : 'Değişim Görünümüne Eriş',
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                showContextualPaywall(
                  context,
                  ref,
                  paywallContext: PaywallContext.patterns,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.auroraStart.withValues(alpha: 0.08),
                      AppColors.auroraEnd.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  border: Border.all(
                    color: AppColors.starGold.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: AppColors.starGold,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isEn
                            ? 'Access Shift Outlook to see when your emotional phases may shift'
                            : 'Duygusal evrelerinin ne zaman kayabileceğini görmek için Kayma Görünümüne eriş',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.starGold,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PATTERN LOOPS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildPatternLoopSection(
    BuildContext context,
    bool isDark,
    bool isEn,
  ) {
    final loopAnalysisAsync = ref.watch(patternLoopAnalysisProvider);
    return loopAnalysisAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (loopAnalysis) => PatternLoopAnalyzer(
        analysis: loopAnalysis,
        isDark: isDark,
        isEn: isEn,
      ),
    );
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
      child: Semantics(
        label: isEn ? 'Share My Inner Cycles' : 'İç Döngülerimi Paylaş',
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              context.push(Routes.shareCardGallery);
            },
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    isEn ? 'Share My Inner Cycles' : 'İç Döngülerimi Paylaş',
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
    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        children: [
          const Icon(Icons.lock_outline, color: AppColors.starGold, size: 36),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            isEn ? 'Access Full 30-Day View' : 'Tam 30 Günlük Görünüme Eriş',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.starGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            isEn
                ? 'You have $totalEntries entries. Log 30+ days for the full cycle view, or go premium.'
                : '$totalEntries kaydın var. Tam döngü görünümü için 30+ gün kayıt yap veya premium\'a geç.',
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
              onPressed: () => showContextualPaywall(
                context,
                ref,
                paywallContext: PaywallContext.patterns,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.starGold,
                side: const BorderSide(color: AppColors.starGold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                ),
              ),
              child: Text(
                isEn ? 'Go Pro' : 'Pro\'ya Geç',
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

// ════════════════════════════════════════════════════════════════════════════
// WAVE PREVIEW PAINTER (Locked View Teaser)
// ════════════════════════════════════════════════════════════════════════════

class _WavePreviewPainter extends CustomPainter {
  final Color color;

  _WavePreviewPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height / 2;
    const amplitude = 20.0;

    path.moveTo(0, midY);
    for (double x = 0; x <= size.width; x += 1) {
      final y =
          midY +
          amplitude * math.sin(x * 0.03) +
          (amplitude * 0.5) * math.sin(x * 0.07 + 1.5);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    // Second wave (offset)
    final path2 = Path();
    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    path2.moveTo(0, midY + 10);
    for (double x = 0; x <= size.width; x += 1) {
      final y =
          midY +
          10 +
          (amplitude * 0.7) * math.sin(x * 0.04 + 2) +
          (amplitude * 0.3) * math.sin(x * 0.08 + 3);
      path2.lineTo(x, y);
    }

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WavePreviewPainter old) => old.color != color;
}
