// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL CYCLE VISUALIZER - InnerCycles Wave Chart & Insights
// ════════════════════════════════════════════════════════════════════════════
// Visualizes emotional patterns as smooth wave/cycle charts over time.
// Uses CustomPainter with Bezier curves for each focus area dimension.
// Includes cycle length detection, phase analysis, and insights.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/services/journal_service.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

// ════════════════════════════════════════════════════════════════════════════
// FOCUS AREA COLORS
// ════════════════════════════════════════════════════════════════════════════

const Map<FocusArea, Color> _areaColors = {
  FocusArea.energy: Color(0xFFE74C3C),
  FocusArea.focus: Color(0xFF3498DB),
  FocusArea.emotions: Color(0xFF9B59B6),
  FocusArea.decisions: Color(0xFFFFD700),
  FocusArea.social: Color(0xFF27AE60),
};

// ════════════════════════════════════════════════════════════════════════════
// CYCLE PHASE ENUM
// ════════════════════════════════════════════════════════════════════════════

enum CyclePhase {
  rising,
  peak,
  declining,
  rest;

  String labelEn() {
    switch (this) {
      case CyclePhase.rising:
        return 'Rising';
      case CyclePhase.peak:
        return 'Peak';
      case CyclePhase.declining:
        return 'Declining';
      case CyclePhase.rest:
        return 'Rest';
    }
  }

  String labelTr() {
    switch (this) {
      case CyclePhase.rising:
        return 'Yükseliş';
      case CyclePhase.peak:
        return 'Zirve';
      case CyclePhase.declining:
        return 'Düşüş';
      case CyclePhase.rest:
        return 'Dinlenme';
    }
  }

  IconData get icon {
    switch (this) {
      case CyclePhase.rising:
        return Icons.trending_up;
      case CyclePhase.peak:
        return Icons.wb_sunny;
      case CyclePhase.declining:
        return Icons.trending_down;
      case CyclePhase.rest:
        return Icons.nightlight_round;
    }
  }

  Color get color {
    switch (this) {
      case CyclePhase.rising:
        return AppColors.success;
      case CyclePhase.peak:
        return AppColors.starGold;
      case CyclePhase.declining:
        return AppColors.error;
      case CyclePhase.rest:
        return AppColors.auroraStart;
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL CYCLE SCREEN
// ════════════════════════════════════════════════════════════════════════════

class EmotionalCycleScreen extends ConsumerStatefulWidget {
  const EmotionalCycleScreen({super.key});

  @override
  ConsumerState<EmotionalCycleScreen> createState() =>
      _EmotionalCycleScreenState();
}

class _EmotionalCycleScreenState extends ConsumerState<EmotionalCycleScreen> {
  final Set<FocusArea> _visibleAreas = Set.from(FocusArea.values);

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.deepSpace, AppColors.cosmicPurple]
                : [AppColors.lightBackground, AppColors.lightSurfaceVariant],
          ),
        ),
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (service) => _buildContent(context, service, isDark, isEn),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    JournalService service,
    bool isDark,
    bool isEn,
  ) {
    final allEntries = service.getAllEntries();
    final now = DateTime.now();

    // Determine date range based on data availability (premium gate)
    final bool hasEnoughForFull = allEntries.length >= 30;
    final int displayDays = hasEnoughForFull ? 30 : 7;
    final rangeStart = now.subtract(Duration(days: displayDays));
    final rangeEntries = service.getEntriesByDateRange(rangeStart, now);

    // Build per-area time series data
    final Map<FocusArea, List<MapEntry<DateTime, double>>> areaData = {};
    for (final area in FocusArea.values) {
      final entries = rangeEntries
          .where((e) => e.focusArea == area)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
      areaData[area] = entries
          .map((e) => MapEntry(e.date, e.overallRating.toDouble()))
          .toList();
    }

    // Cycle length detection (on emotions dimension, full history)
    final cycleInfo = _detectCycleLength(allEntries);
    final phase = _detectCurrentPhase(allEntries);

    // Insights
    final insights = _computeInsights(rangeEntries, isEn);

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Your Inner Cycles' : 'İç Döngülerin',
          ),

        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ════════════════════════════════════════════════════════════
              // CYCLE OVERVIEW CARD
              // ════════════════════════════════════════════════════════════
              _buildCycleOverviewCard(
                context,
                isDark,
                isEn,
                cycleInfo,
                phase,
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: AppConstants.spacingXl),

              // ════════════════════════════════════════════════════════════
              // WAVE CHART
              // ════════════════════════════════════════════════════════════
              _buildWaveChart(
                context,
                isDark,
                isEn,
                areaData,
                displayDays,
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: AppConstants.spacingMd),

              // ════════════════════════════════════════════════════════════
              // FOCUS AREA LEGEND
              // ════════════════════════════════════════════════════════════
              _buildLegend(context, isDark, isEn)
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: AppConstants.spacingXl),

              // ════════════════════════════════════════════════════════════
              // CYCLE INSIGHTS
              // ════════════════════════════════════════════════════════════
              if (insights.isNotEmpty) ...[
                Text(
                  isEn ? 'Cycle Insights' : 'Döngü İçgörüleri',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const SizedBox(height: AppConstants.spacingMd),
                ...insights.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spacingMd,
                    ),
                    child: _buildInsightCard(
                      context,
                      isDark,
                      entry.value,
                    ),
                  ).animate().fadeIn(
                    delay: (350 + entry.key * 80).ms,
                    duration: 400.ms,
                  );
                }),
              ],

              const SizedBox(height: AppConstants.spacingLg),

              // ════════════════════════════════════════════════════════════
              // SHARE BUTTON
              // ════════════════════════════════════════════════════════════
              _buildShareButton(context, isDark, isEn)
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 400.ms),

              // ════════════════════════════════════════════════════════════
              // PREMIUM GATE
              // ════════════════════════════════════════════════════════════
              if (!hasEnoughForFull) ...[
                const SizedBox(height: AppConstants.spacingLg),
                _buildPremiumGate(context, isDark, isEn, allEntries.length)
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms),
              ],

              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CYCLE OVERVIEW CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildCycleOverviewCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    int? cycleLengthDays,
    CyclePhase? phase,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cycle length
          Row(
            children: [
              Icon(
                Icons.waves,
                color: AppColors.auroraStart,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cycleLengthDays != null
                      ? (isEn
                          ? 'Your emotional cycle length: ~$cycleLengthDays days'
                          : 'Duygusal döngü uzunluğun: ~$cycleLengthDays gün')
                      : (isEn
                          ? 'Need more entries to detect your cycle'
                          : 'Döngünü tespit etmek için daha fazla kayıt gerekli'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // Current phase
          if (phase != null) ...[
            const SizedBox(height: AppConstants.spacingLg),
            Row(
              children: [
                Icon(
                  phase.icon,
                  color: phase.color,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  isEn ? 'Current phase: ' : 'Mevcut aşama: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: phase.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    border: Border.all(
                      color: phase.color.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    isEn ? phase.labelEn() : phase.labelTr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: phase.color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // WAVE CHART
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildWaveChart(
    BuildContext context,
    bool isDark,
    bool isEn,
    Map<FocusArea, List<MapEntry<DateTime, double>>> areaData,
    int displayDays,
  ) {
    final bool hasData = areaData.values.any((list) => list.isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
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
            isEn
                ? 'Last $displayDays Days'
                : 'Son $displayDays Gün',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          if (!hasData)
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  isEn
                      ? 'Start journaling to see your cycles'
                      : 'Döngülerini görmek için kayıt yapmaya başla',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 220,
              child: CustomPaint(
                size: const Size(double.infinity, 220),
                painter: CycleWavePainter(
                  data: areaData,
                  visibleAreas: _visibleAreas,
                  areaColors: _areaColors,
                  isDark: isDark,
                  displayDays: displayDays,
                ),
              ),
            ),
          // Y-axis labels
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

  // ══════════════════════════════════════════════════════════════════════════
  // FOCUS AREA LEGEND
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildLegend(BuildContext context, bool isDark, bool isEn) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: FocusArea.values.map((area) {
          final isVisible = _visibleAreas.contains(area);
          final color = _areaColors[area]!;
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
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isVisible
                      ? color.withValues(alpha: 0.2)
                      : (isDark
                          ? AppColors.surfaceDark.withValues(alpha: 0.5)
                          : AppColors.lightSurfaceVariant),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: isVisible
                        ? color.withValues(alpha: 0.6)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isVisible
                            ? color
                            : color.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
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
    _CycleInsight insight,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: insight.color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(insight.icon, color: insight.color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight.message,
              style: TextStyle(
                fontSize: 14,
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

  // ══════════════════════════════════════════════════════════════════════════
  // SHARE BUTTON
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildShareButton(BuildContext context, bool isDark, bool isEn) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.push('/share-insight'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.auroraStart,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
        ),
        icon: const Icon(Icons.share, size: 20),
        label: Text(
          isEn ? 'Share Your Cycle' : 'Döngünü Paylaş',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
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
            AppColors.auroraStart.withValues(alpha: 0.15),
            AppColors.auroraEnd.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.4),
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
            isEn
                ? 'Unlock Full History'
                : 'Tüm Geçmişi Aç',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.starGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            isEn
                ? 'You have $totalEntries entries. Log 30+ days to unlock the full 30-day cycle view, or upgrade to premium.'
                : '$totalEntries kaydınız var. 30 günlük döngü görünümünün kilidini açmak için 30+ gün kayıt yapın veya premium\'a geçin.',
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
              onPressed: () {
                // Navigate to premium/paywall screen
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.starGold,
                side: const BorderSide(color: AppColors.starGold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                ),
              ),
              child: Text(
                isEn ? 'Go Premium' : 'Premium\'a Geç',
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

  // ══════════════════════════════════════════════════════════════════════════
  // CYCLE LENGTH DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Detect cycle length by finding peaks in the emotions dimension
  /// Returns null if insufficient data
  int? _detectCycleLength(List<JournalEntry> allEntries) {
    final emotionEntries = allEntries
        .where((e) => e.focusArea == FocusArea.emotions)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (emotionEntries.length < 5) return null;

    // Find peaks (local maxima)
    final List<DateTime> peaks = [];
    for (int i = 1; i < emotionEntries.length - 1; i++) {
      final prev = emotionEntries[i - 1].overallRating;
      final curr = emotionEntries[i].overallRating;
      final next = emotionEntries[i + 1].overallRating;
      if (curr > prev && curr > next) {
        peaks.add(emotionEntries[i].date);
      }
    }

    if (peaks.length < 2) return null;

    // Average distance between consecutive peaks
    double totalDays = 0;
    for (int i = 1; i < peaks.length; i++) {
      totalDays += peaks[i].difference(peaks[i - 1]).inDays;
    }
    final avgCycle = totalDays / (peaks.length - 1);

    // Only return if the cycle length is reasonable (3-60 days)
    if (avgCycle < 3 || avgCycle > 60) return null;
    return avgCycle.round();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CURRENT PHASE DETECTION
  // ══════════════════════════════════════════════════════════════════════════

  CyclePhase? _detectCurrentPhase(List<JournalEntry> allEntries) {
    final emotionEntries = allEntries
        .where((e) => e.focusArea == FocusArea.emotions)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first

    if (emotionEntries.length < 3) return null;

    // Take last 3 entries to determine trend
    final recent = emotionEntries.take(3).toList();
    final ratings = recent.map((e) => e.overallRating).toList();

    // ratings[0] is most recent, ratings[2] is oldest
    final latest = ratings[0];
    final middle = ratings[1];
    final oldest = ratings[2];

    if (latest > middle && middle > oldest) {
      return CyclePhase.rising;
    } else if (latest >= 4 && middle >= 4) {
      return CyclePhase.peak;
    } else if (latest < middle && middle < oldest) {
      return CyclePhase.declining;
    } else if (latest <= 2) {
      return CyclePhase.rest;
    } else if (latest > middle) {
      return CyclePhase.rising;
    } else {
      return CyclePhase.declining;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // INSIGHTS COMPUTATION
  // ══════════════════════════════════════════════════════════════════════════

  List<_CycleInsight> _computeInsights(
    List<JournalEntry> entries,
    bool isEn,
  ) {
    if (entries.isEmpty) return [];

    final List<_CycleInsight> insights = [];

    // Compute averages per area
    final Map<FocusArea, List<int>> areaRatings = {};
    for (final entry in entries) {
      areaRatings.putIfAbsent(entry.focusArea, () => []);
      areaRatings[entry.focusArea]!.add(entry.overallRating);
    }

    if (areaRatings.isEmpty) return [];

    // Strongest area (highest average)
    FocusArea? strongestArea;
    double highestAvg = 0;
    for (final entry in areaRatings.entries) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      if (avg > highestAvg) {
        highestAvg = avg;
        strongestArea = entry.key;
      }
    }

    if (strongestArea != null) {
      final areaName = isEn
          ? strongestArea.displayNameEn
          : strongestArea.displayNameTr;
      insights.add(_CycleInsight(
        message: isEn
            ? 'Your strongest area this month: $areaName'
            : 'Bu ay en güçlü alanın: $areaName',
        icon: Icons.star,
        color: _areaColors[strongestArea]!,
      ));
    }

    // Most variable area (highest standard deviation)
    FocusArea? mostVariable;
    double highestStdDev = 0;
    for (final entry in areaRatings.entries) {
      if (entry.value.length < 2) continue;
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      final variance = entry.value
              .map((r) => (r - avg) * (r - avg))
              .reduce((a, b) => a + b) /
          entry.value.length;
      final stdDev = math.sqrt(variance);
      if (stdDev > highestStdDev) {
        highestStdDev = stdDev;
        mostVariable = entry.key;
      }
    }

    if (mostVariable != null && highestStdDev > 0.5) {
      final areaName = isEn
          ? mostVariable.displayNameEn
          : mostVariable.displayNameTr;
      insights.add(_CycleInsight(
        message: isEn
            ? 'Your most variable area: $areaName'
            : 'En değişken alanın: $areaName',
        icon: Icons.show_chart,
        color: _areaColors[mostVariable]!,
      ));
    }

    // Best day pattern (weekday with highest average)
    final Map<int, List<int>> weekdayRatings = {};
    for (final entry in entries) {
      weekdayRatings.putIfAbsent(entry.date.weekday, () => []);
      weekdayRatings[entry.date.weekday]!.add(entry.overallRating);
    }

    int? bestWeekday;
    double bestWeekdayAvg = 0;
    for (final entry in weekdayRatings.entries) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      if (avg > bestWeekdayAvg) {
        bestWeekdayAvg = avg;
        bestWeekday = entry.key;
      }
    }

    if (bestWeekday != null) {
      final weekdayNames = isEn
          ? [
              '',
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
              'Sunday',
            ]
          : [
              '',
              'Pazartesi',
              'Salı',
              'Çarşamba',
              'Perşembe',
              'Cuma',
              'Cumartesi',
              'Pazar',
            ];
      insights.add(_CycleInsight(
        message: isEn
            ? 'Best day pattern: ${weekdayNames[bestWeekday]}'
            : 'En iyi gün kalıbı: ${weekdayNames[bestWeekday]}',
        icon: Icons.calendar_today,
        color: AppColors.starGold,
      ));
    }

    return insights;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// INSIGHT DATA CLASS
// ════════════════════════════════════════════════════════════════════════════

class _CycleInsight {
  final String message;
  final IconData icon;
  final Color color;

  const _CycleInsight({
    required this.message,
    required this.icon,
    required this.color,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// CYCLE WAVE PAINTER - Smooth Bezier curves for each focus area
// ════════════════════════════════════════════════════════════════════════════

class CycleWavePainter extends CustomPainter {
  final Map<FocusArea, List<MapEntry<DateTime, double>>> data;
  final Set<FocusArea> visibleAreas;
  final Map<FocusArea, Color> areaColors;
  final bool isDark;
  final int displayDays;

  CycleWavePainter({
    required this.data,
    required this.visibleAreas,
    required this.areaColors,
    required this.isDark,
    required this.displayDays,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();
    final rangeStart = now.subtract(Duration(days: displayDays));
    final totalMs = now.difference(rangeStart).inMilliseconds.toDouble();

    // Chart area with padding for Y-axis labels
    const leftPadding = 24.0;
    const rightPadding = 8.0;
    const topPadding = 8.0;
    const bottomPadding = 20.0;
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Draw Y-axis grid lines and labels (1-5)
    _drawGrid(canvas, size, leftPadding, topPadding, chartWidth, chartHeight);

    // Draw each visible focus area as a smooth bezier curve
    for (final area in FocusArea.values) {
      if (!visibleAreas.contains(area)) continue;

      final points = data[area];
      if (points == null || points.isEmpty) continue;

      final color = areaColors[area] ?? Colors.white;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      // Convert data points to canvas coordinates
      final List<Offset> canvasPoints = [];
      for (final point in points) {
        final dx = leftPadding +
            (point.key.difference(rangeStart).inMilliseconds / totalMs) *
                chartWidth;
        // Y is inverted (top = 5, bottom = 1)
        final dy = topPadding +
            chartHeight -
            ((point.value - 1) / 4) * chartHeight;
        canvasPoints.add(Offset(dx.clamp(leftPadding, leftPadding + chartWidth),
            dy.clamp(topPadding, topPadding + chartHeight)));
      }

      if (canvasPoints.length == 1) {
        // Single point: draw a dot
        canvas.drawCircle(
          canvasPoints.first,
          4,
          Paint()..color = color,
        );
        continue;
      }

      // Draw smooth bezier path
      final path = _buildSmoothPath(canvasPoints);
      canvas.drawPath(path, paint);

      // Draw glow effect underneath
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
        ..isAntiAlias = true;
      canvas.drawPath(path, glowPaint);

      // Draw data point dots
      for (final pt in canvasPoints) {
        canvas.drawCircle(
          pt,
          3,
          Paint()..color = color,
        );
        canvas.drawCircle(
          pt,
          1.5,
          Paint()..color = Colors.white,
        );
      }
    }
  }

  /// Draw background grid with Y-axis labels
  void _drawGrid(
    Canvas canvas,
    Size size,
    double leftPadding,
    double topPadding,
    double chartWidth,
    double chartHeight,
  ) {
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int rating = 1; rating <= 5; rating++) {
      final y = topPadding + chartHeight - ((rating - 1) / 4) * chartHeight;

      // Grid line
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + chartWidth, y),
        gridPaint,
      );

      // Label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: '$rating',
          style: TextStyle(
            color: (isDark ? Colors.white : Colors.black)
                .withValues(alpha: 0.35),
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(
        canvas,
        Offset(4, y - labelPainter.height / 2),
      );
    }
  }

  /// Build a smooth cubic bezier path through the given points
  Path _buildSmoothPath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;

    path.moveTo(points.first.dx, points.first.dy);

    if (points.length == 2) {
      path.lineTo(points[1].dx, points[1].dy);
      return path;
    }

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i + 2 < points.length ? points[i + 2] : p2;

      // Catmull-Rom to Bezier control points
      final tension = 0.3;
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) * tension,
        p1.dy + (p2.dy - p0.dy) * tension,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) * tension,
        p2.dy - (p3.dy - p1.dy) * tension,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CycleWavePainter oldDelegate) {
    return oldDelegate.visibleAreas != visibleAreas ||
        oldDelegate.data != data ||
        oldDelegate.isDark != isDark;
  }
}
