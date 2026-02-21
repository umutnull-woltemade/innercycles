// ============================================================================
// WEEKLY DIGEST SCREEN - InnerCycles Weekly Summary
// ============================================================================
// A comprehensive weekly recap showing entry count, average mood, top focus
// area, streak status, mood trend, and best day highlight.
//
// Supports EN/TR bilingual via inline isEn pattern. Screenshot-shareable
// via RepaintBoundary + toImage + native share sheet.
// ============================================================================

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/weekly_digest_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

class WeeklyDigestScreen extends ConsumerStatefulWidget {
  const WeeklyDigestScreen({super.key});

  @override
  ConsumerState<WeeklyDigestScreen> createState() =>
      _WeeklyDigestScreenState();
}

class _WeeklyDigestScreenState extends ConsumerState<WeeklyDigestScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  // ==========================================================================
  // SHARE ACTION
  // ==========================================================================

  Future<void> _shareDigest(bool isEn) async {
    final boundary = _repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    setState(() => _isSharing = true);
    HapticFeedback.mediumImpact();

    try {
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        if (mounted) setState(() => _isSharing = false);
        return;
      }

      final bytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/innercycles_weekly_digest.png');
      await file.writeAsBytes(bytes);

      final shareText = isEn
          ? 'My weekly debrief from InnerCycles #InnerCycles #WeeklyDebrief'
          : 'InnerCycles haftalik degerlendirmem #InnerCycles #HaftalikDegerlendirme';

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: shareText,
        ),
      );
    } catch (_) {
      // Share cancelled or failed silently
    }

    if (mounted) setState(() => _isSharing = false);
  }

  // ==========================================================================
  // HELPERS
  // ==========================================================================

  String _weekdayNameFull(int weekday, bool isEn) {
    const enDays = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const trDays = [
      '',
      'Pazartesi',
      'Sali',
      'Carsamba',
      'Persembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];
    if (weekday < 1 || weekday > 7) return '';
    return isEn ? enDays[weekday] : trDays[weekday];
  }

  Color _moodColor(double rating) {
    if (rating >= 4.0) return AppColors.success;
    if (rating >= 3.0) return AppColors.starGold;
    if (rating >= 2.0) return AppColors.warning;
    return AppColors.error;
  }

  Color _focusAreaColor(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return AppColors.starGold;
      case FocusArea.focus:
        return AppColors.chartBlue;
      case FocusArea.emotions:
        return AppColors.chartPink;
      case FocusArea.decisions:
        return AppColors.chartGreen;
      case FocusArea.social:
        return AppColors.chartPurple;
    }
  }

  IconData _moodTrendIcon(MoodTrendDirection direction) {
    switch (direction) {
      case MoodTrendDirection.up:
        return Icons.trending_up;
      case MoodTrendDirection.down:
        return Icons.trending_down;
      case MoodTrendDirection.stable:
        return Icons.trending_flat;
    }
  }

  Color _moodTrendColor(MoodTrendDirection direction) {
    switch (direction) {
      case MoodTrendDirection.up:
        return AppColors.success;
      case MoodTrendDirection.down:
        return AppColors.error;
      case MoodTrendDirection.stable:
        return AppColors.starGold;
    }
  }

  (String, String) _moodTrendMessage(MoodTrendDirection direction) {
    switch (direction) {
      case MoodTrendDirection.up:
        return (
          'Your entries suggest an upward shift this week.',
          'Kayitlarin bu hafta yukselise gectigini gosteriyor.',
        );
      case MoodTrendDirection.down:
        return (
          'Your entries suggest a dip this week. Be gentle with yourself.',
          'Kayitlarin bu hafta bir dusus gosteriyor. Kendine nazik ol.',
        );
      case MoodTrendDirection.stable:
        return (
          'Your mood has been consistent this week.',
          'Ruh halin bu hafta tutarli kalmis.',
        );
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final digestDataAsync = ref.watch(weeklyDigestDataProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: digestDataAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => _buildEmptyState(context, isDark, isEn),
            data: (data) {
              if (data == null) {
                return _buildEmptyState(context, isDark, isEn);
              }
              return _buildDigestView(context, data, isDark, isEn);
            },
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // EMPTY STATE
  // ==========================================================================

  Widget _buildEmptyState(BuildContext context, bool isDark, bool isEn) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Weekly Debrief' : 'Haftalık Değerlendirme',
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_view_week_outlined,
                    size: 64,
                    color: AppColors.starGold.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isEn
                        ? 'No entries this week yet'
                        : 'Bu hafta henuz kayit yok',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                        ? 'Start journaling to see your weekly digest with mood trends, patterns, and insights.'
                        : 'Ruh hali egilmleri, kalipler ve icgoruler iceren haftalik ozetini gormek icin gunluk tutmaya basla.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // DIGEST VIEW
  // ==========================================================================

  Widget _buildDigestView(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Weekly Debrief' : 'Haftalık Değerlendirme',
          actions: [
            IconButton(
              onPressed: _isSharing ? null : () => _shareDigest(isEn),
              icon: _isSharing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.starGold,
                      ),
                    )
                  : const Icon(Icons.ios_share, color: AppColors.starGold),
              tooltip: isEn ? 'Share' : 'Paylas',
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              RepaintBoundary(
                key: _repaintKey,
                child: Container(
                  color: isDark
                      ? AppColors.deepSpace
                      : AppColors.lightBackground,
                  child: Column(
                    children: [
                      // 1) Week header
                      _buildWeekHeader(context, data, isDark, isEn)
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(
                            begin: 0.1,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // 2) Entry count + comparison
                      _buildEntryComparison(context, data, isDark, isEn)
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 500.ms)
                          .slideY(
                            begin: 0.1,
                            delay: 100.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // 3) Stats row: Avg mood, Streak, Top Area
                      _buildStatsRow(context, data, isDark, isEn)
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 500.ms)
                          .slideY(
                            begin: 0.1,
                            delay: 200.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // 4) Top focus area with percentage
                      if (data.topFocusArea != null)
                        _buildTopFocusArea(context, data, isDark, isEn)
                            .animate()
                            .fadeIn(delay: 300.ms, duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              delay: 300.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                      if (data.topFocusArea != null)
                        const SizedBox(height: AppConstants.spacingLg),

                      // 5) Mood trend
                      _buildMoodTrend(context, data, isDark, isEn)
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideY(
                            begin: 0.1,
                            delay: 400.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // 6) Best day highlight
                      if (data.bestDay != null)
                        _buildBestDay(context, data, isDark, isEn)
                            .animate()
                            .fadeIn(delay: 500.ms, duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              delay: 500.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                      if (data.bestDay != null)
                        const SizedBox(height: AppConstants.spacingLg),

                      // 7) Focus area breakdown
                      if (data.areaAverages.isNotEmpty)
                        _buildAreaBreakdown(context, data, isDark, isEn)
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              delay: 600.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                      if (data.areaAverages.isNotEmpty)
                        const SizedBox(height: AppConstants.spacingLg),

                      // 8) Highlight insight
                      _buildHighlightInsight(context, data, isDark, isEn)
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 500.ms)
                          .slideY(
                            begin: 0.1,
                            delay: 700.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                      const SizedBox(height: AppConstants.spacingLg),

                      // Watermark
                      _buildWatermark(isDark)
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 500.ms),
                    ],
                  ),
                ),
              ),

              // Disclaimer (outside RepaintBoundary)
              ContentDisclaimer(language: isEn ? AppLanguage.en : AppLanguage.tr),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SECTION 1: WEEK HEADER
  // ==========================================================================

  Widget _buildWeekHeader(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
    final dateFormat = DateFormat('MMM d');
    final range =
        '${dateFormat.format(data.weekStart)} - ${dateFormat.format(data.weekEnd)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withValues(alpha: isDark ? 0.15 : 0.08),
            AppColors.auroraEnd.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            isEn ? 'Week of' : 'Haftasi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            range,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.starGold,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 2: ENTRY COUNT + COMPARISON
  // ==========================================================================

  Widget _buildEntryComparison(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
    final diff = data.entriesThisWeek - data.entriesLastWeek;
    final hasComparison = data.entriesLastWeek > 0;

    String comparisonText;
    Color comparisonColor;
    IconData comparisonIcon;

    if (!hasComparison) {
      comparisonText = isEn ? 'First week tracked' : 'Ilk takip edilen hafta';
      comparisonColor = AppColors.starGold;
      comparisonIcon = Icons.star_outline;
    } else if (diff > 0) {
      comparisonText = isEn
          ? '$diff more than last week'
          : 'Gecen haftaya gore $diff fazla';
      comparisonColor = AppColors.success;
      comparisonIcon = Icons.arrow_upward;
    } else if (diff < 0) {
      comparisonText = isEn
          ? '${diff.abs()} fewer than last week'
          : 'Gecen haftaya gore ${diff.abs()} az';
      comparisonColor = AppColors.warning;
      comparisonIcon = Icons.arrow_downward;
    } else {
      comparisonText = isEn ? 'Same as last week' : 'Gecen haftayla ayni';
      comparisonColor = AppColors.starGold;
      comparisonIcon = Icons.horizontal_rule;
    }

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
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.auroraStart.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.auroraStart.withValues(alpha: 0.3),
              ),
            ),
            child: Center(
              child: Text(
                '${data.entriesThisWeek}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.auroraStart,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Entries This Week' : 'Bu Haftaki Kayitlar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(comparisonIcon, size: 14, color: comparisonColor),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        comparisonText,
                        style: TextStyle(
                          fontSize: 13,
                          color: comparisonColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 3: STATS ROW
  // ==========================================================================

  Widget _buildStatsRow(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
    return Row(
      children: [
        // Average Mood
        Expanded(
          child: _StatCard(
            value: data.avgMoodRating.toStringAsFixed(1),
            label: isEn ? 'Avg Rating' : 'Ort Puan',
            sublabel: '/5',
            icon: Icons.mood,
            color: _moodColor(data.avgMoodRating),
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        // Streak
        Expanded(
          child: _StatCard(
            value: '${data.streakDays}',
            label: isEn ? 'Day Streak' : 'Gun Serisi',
            sublabel: isEn ? 'days' : 'gun',
            icon: Icons.local_fire_department,
            color: AppColors.streakOrange,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SECTION 4: TOP FOCUS AREA
  // ==========================================================================

  Widget _buildTopFocusArea(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
    final area = data.topFocusArea!;
    final areaName = isEn ? area.displayNameEn : area.displayNameTr;
    final color = _focusAreaColor(area);
    final pct = data.topFocusAreaPercentage;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.pie_chart_outline, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Top Focus Area' : 'En Cok Odaklanilan Alan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  areaName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          // Percentage badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              '${pct.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 5: MOOD TREND
  // ==========================================================================

  Widget _buildMoodTrend(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
    final icon = _moodTrendIcon(data.moodTrend);
    final color = _moodTrendColor(data.moodTrend);
    final message = _moodTrendMessage(data.moodTrend);
    final changeStr = data.moodTrendChangePercent.abs() > 0
        ? '(${data.moodTrendChangePercent > 0 ? '+' : ''}${data.moodTrendChangePercent.toStringAsFixed(0)}%)'
        : '';

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
            ),
            child: Icon(icon, size: 26, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isEn ? 'Mood Trend' : 'Ruh Hali Egilimi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    if (changeStr.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(
                        changeStr,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isEn ? message.$1 : message.$2,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 6: BEST DAY HIGHLIGHT
  // ==========================================================================

  Widget _buildBestDay(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
    final bestDate = data.bestDay!;
    final dayName = _weekdayNameFull(bestDate.weekday, isEn);
    final dateStr = DateFormat('MMM d').format(bestDate);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.starGold.withValues(alpha: isDark ? 0.12 : 0.06),
            AppColors.auroraStart.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.starGold.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.starGold.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.starGold,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Best Day' : 'En Iyi Gun',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$dayName, $dateStr',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.starGold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEn
                      ? 'Average rating: ${data.bestDayRating}/5'
                      : 'Ortalama puan: ${data.bestDayRating}/5',
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
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 7: FOCUS AREA BREAKDOWN
  // ==========================================================================

  Widget _buildAreaBreakdown(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
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
            isEn ? 'Focus Area Breakdown' : 'Odak Alani Dagilimi',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...data.areaAverages.entries.map((entry) {
            final area = entry.key;
            final avg = entry.value;
            final count = data.areaCounts[area] ?? 0;
            final color = _focusAreaColor(area);
            final label = isEn ? area.displayNameEn : area.displayNameTr;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (avg / 5).clamp(0, 1),
                        backgroundColor: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.3)
                            : AppColors.lightSurfaceVariant,
                        valueColor: AlwaysStoppedAnimation(color),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    avg.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '($count)',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECTION 8: HIGHLIGHT INSIGHT
  // ==========================================================================

  Widget _buildHighlightInsight(
    BuildContext context,
    WeeklyDigestData data,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.amethyst.withValues(alpha: isDark ? 0.1 : 0.05),
            AppColors.auroraEnd.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.amethyst.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: AppColors.starGold,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            isEn ? 'Weekly Insight' : 'Haftalik Icgoru',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn ? data.highlightInsightEn : data.highlightInsightTr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w500,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // WATERMARK
  // ==========================================================================

  Widget _buildWatermark(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.starGold.withValues(alpha: 0.0),
                  AppColors.starGold.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'InnerCycles',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 24,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.starGold.withValues(alpha: 0.3),
                  AppColors.starGold.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STAT CARD COMPONENT
// ============================================================================

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String sublabel;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.value,
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.spacingLg,
        horizontal: AppConstants.spacingMd,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                sublabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
