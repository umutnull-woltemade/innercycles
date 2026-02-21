// ============================================================================
// ANNUAL CYCLE REPORT - InnerCycles Year-in-Review (Wrapped-style)
// ============================================================================
// A shareable, animated year-in-review screen showing the user's emotional
// journey through their journal entries. Uses safe, non-predictive language.
// Supports EN/TR via inline isEn pattern. Screenshot-shareable via
// RepaintBoundary + toImage + native share sheet.
// ============================================================================

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/journal_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

// ============================================================================
// ANNUAL REPORT DATA MODEL
// ============================================================================

class _AnnualReportData {
  final int year;
  final int totalEntries;
  final List<MapEntry<FocusArea, double>> topFocusAreas;
  final Map<int, double> monthlyAverageRatings;
  final int longestStreak;
  final MapEntry<int, int>? mostActiveMonth; // month -> entry count
  final double overallAverageRating;

  const _AnnualReportData({
    required this.year,
    required this.totalEntries,
    required this.topFocusAreas,
    required this.monthlyAverageRatings,
    required this.longestStreak,
    required this.mostActiveMonth,
    required this.overallAverageRating,
  });
}

// ============================================================================
// SCREEN
// ============================================================================

class AnnualReportScreen extends ConsumerStatefulWidget {
  /// Optionally specify which year to report on. Defaults to current year.
  final int? year;

  const AnnualReportScreen({super.key, this.year});

  @override
  ConsumerState<AnnualReportScreen> createState() =>
      _AnnualReportScreenState();
}

class _AnnualReportScreenState extends ConsumerState<AnnualReportScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isSharing = false;

  // =========================================================================
  // DATA COMPUTATION
  // =========================================================================

  _AnnualReportData? _computeReport(JournalService service, int year) {
    final allEntries = service.getAllEntries();
    final yearEntries =
        allEntries.where((e) => e.date.year == year).toList();

    if (yearEntries.isEmpty) return null;

    // --- Top focus areas with percentage ---
    final areaCounts = <FocusArea, int>{};
    final areaRatingSums = <FocusArea, int>{};
    final areaRatingCounts = <FocusArea, int>{};
    for (final e in yearEntries) {
      areaCounts[e.focusArea] = (areaCounts[e.focusArea] ?? 0) + 1;
      areaRatingSums[e.focusArea] =
          (areaRatingSums[e.focusArea] ?? 0) + e.overallRating;
      areaRatingCounts[e.focusArea] =
          (areaRatingCounts[e.focusArea] ?? 0) + 1;
    }

    final sortedAreas = areaCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topFocusAreas = sortedAreas
        .take(3)
        .map((e) => MapEntry(
              e.key,
              (e.value / yearEntries.length) * 100,
            ))
        .toList();

    // --- Monthly average ratings ---
    final monthlyRatingSums = <int, int>{};
    final monthlyRatingCounts = <int, int>{};
    final monthlyEntryCounts = <int, int>{};
    for (final e in yearEntries) {
      monthlyRatingSums[e.date.month] =
          (monthlyRatingSums[e.date.month] ?? 0) + e.overallRating;
      monthlyRatingCounts[e.date.month] =
          (monthlyRatingCounts[e.date.month] ?? 0) + 1;
      monthlyEntryCounts[e.date.month] =
          (monthlyEntryCounts[e.date.month] ?? 0) + 1;
    }

    final monthlyAverages = <int, double>{};
    for (final month in monthlyRatingSums.keys) {
      final count = monthlyRatingCounts[month] ?? 1;
      monthlyAverages[month] = count > 0
          ? (monthlyRatingSums[month] ?? 0) / count
          : 0.0;
    }

    // --- Longest streak (within this year) ---
    final yearDates = yearEntries.map((e) => e.dateKey).toSet().toList()
      ..sort();
    int longest = yearDates.isNotEmpty ? 1 : 0;
    int current = 1;
    for (int i = 1; i < yearDates.length; i++) {
      final prev = DateTime.tryParse(yearDates[i - 1]);
      final curr = DateTime.tryParse(yearDates[i]);
      if (prev != null && curr != null && curr.difference(prev).inDays == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }

    // --- Most active month ---
    MapEntry<int, int>? mostActive;
    if (monthlyEntryCounts.isNotEmpty) {
      final sorted = monthlyEntryCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      mostActive = sorted.first;
    }

    // --- Overall average rating ---
    final totalRating =
        yearEntries.fold<int>(0, (sum, e) => sum + e.overallRating);
    final overallAvg = yearEntries.isNotEmpty
        ? totalRating / yearEntries.length
        : 0.0;

    return _AnnualReportData(
      year: year,
      totalEntries: yearEntries.length,
      topFocusAreas: topFocusAreas,
      monthlyAverageRatings: monthlyAverages,
      longestStreak: longest,
      mostActiveMonth: mostActive,
      overallAverageRating: overallAvg,
    );
  }

  // =========================================================================
  // SHARE ACTION
  // =========================================================================

  Future<void> _shareReport(bool isEn) async {
    final boundary = _repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return;

    setState(() => _isSharing = true);

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
      final file = File(
        '${tempDir.path}/innercycles_annual_report.png',
      );
      await file.writeAsBytes(bytes);

      final shareText = isEn
          ? 'My year in review with InnerCycles! #InnerCycles #YearInReview'
          : 'InnerCycles ile yıllık raporum! #InnerCycles #YıllıkRapor';

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

  // =========================================================================
  // HELPERS
  // =========================================================================

  String _monthName(int month, bool isEn) {
    const enMonths = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const trMonths = [
      '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
    ];
    if (month < 1 || month > 12) return '';
    return isEn ? enMonths[month] : trMonths[month];
  }

  String _monthNameFull(int month, bool isEn) {
    const enMonths = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    const trMonths = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];
    if (month < 1 || month > 12) return '';
    return isEn ? enMonths[month] : trMonths[month];
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

  String _motivationalMessage(
    _AnnualReportData data,
    bool isEn,
  ) {
    if (data.totalEntries >= 200) {
      return isEn
          ? 'An extraordinary year of self-reflection. Your dedication to understanding yourself has been remarkable.'
          : 'Olağanüstü bir öz-düşünme yılı. Kendini anlamaya olan bağlılığın dikkat çekiciydi.';
    } else if (data.totalEntries >= 100) {
      return isEn
          ? 'You showed up consistently for yourself this year. Your journal entries reveal a meaningful journey of growth.'
          : 'Bu yıl kendin için sürekli olarak orda oldun. Günlük kayıtların anlamlı bir gelişim yolculuğu ortaya koyuyor.';
    } else if (data.totalEntries >= 30) {
      return isEn
          ? 'Every entry you wrote was a step toward knowing yourself better. Your patterns tell a story worth celebrating.'
          : 'Yazdığın her kayıt kendini daha iyi tanımaya doğru bir adımdı. Kalıpların kutlanmaya değer bir hikaye anlatıyor.';
    } else {
      return isEn
          ? 'You started a journey of self-awareness this year. Each entry matters, and your story is just beginning.'
          : 'Bu yıl bir öz-farkındalık yolculuğuna başladınız. Her kayıt önemli ve hikayeniz daha yeni başlıyor.';
    }
  }

  // =========================================================================
  // BUILD
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final journalAsync = ref.watch(journalServiceProvider);
    final reportYear = widget.year ?? DateTime.now().year;

    return Scaffold(
      body: CosmicBackground(
        child: journalAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.starGold),
          ),
          error: (_, _) => Center(
            child: Text(
              isEn ? 'Something went wrong' : 'Bir hata oluştu',
              style: TextStyle(
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          data: (service) {
            final report = _computeReport(service, reportYear);

            if (report == null) {
              return _buildEmptyState(context, isDark, isEn, reportYear);
            }

            return _buildReportView(context, report, isDark, isEn);
          },
        ),
      ),
    );
  }

  // =========================================================================
  // EMPTY STATE
  // =========================================================================

  Widget _buildEmptyState(
    BuildContext context,
    bool isDark,
    bool isEn,
    int year,
  ) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Year Synthesis' : 'Yıl Sentezi',
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
                      Icons.auto_stories_outlined,
                      size: 64,
                      color: AppColors.starGold.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isEn
                          ? 'No entries for $year yet'
                          : '$year için henüz kayıt yok',
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
                          ? 'Start journaling to see your year in review.'
                          : 'Yıllık raporunu görmek için günlük yazmaya başla.',
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
      ),
    );
  }

  // =========================================================================
  // REPORT VIEW
  // =========================================================================

  Widget _buildReportView(
    BuildContext context,
    _AnnualReportData report,
    bool isDark,
    bool isEn,
  ) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Year Synthesis' : 'Yıl Sentezi',
            actions: [
              IconButton(
                onPressed: _isSharing ? null : () => _shareReport(isEn),
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
                        // 1) Year title + total entries
                        _buildYearHeader(context, report, isDark, isEn)
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: AppConstants.spacingXl),

                        // 2) Top 3 focus areas
                        _buildTopFocusAreas(context, report, isDark, isEn)
                            .animate()
                            .fadeIn(delay: 150.ms, duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              delay: 150.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: AppConstants.spacingXl),

                        // 3) Monthly mood chart
                        _buildMonthlyChart(context, report, isDark, isEn)
                            .animate()
                            .fadeIn(delay: 300.ms, duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              delay: 300.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: AppConstants.spacingXl),

                        // 4) Longest streak
                        _buildStreakCard(context, report, isDark, isEn)
                            .animate()
                            .fadeIn(delay: 450.ms, duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              delay: 450.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: AppConstants.spacingXl),

                        // 5) Most active month
                        if (report.mostActiveMonth != null)
                          _buildMostActiveMonth(
                                  context, report, isDark, isEn)
                              .animate()
                              .fadeIn(delay: 600.ms, duration: 500.ms)
                              .slideY(
                                begin: 0.1,
                                delay: 600.ms,
                                duration: 500.ms,
                                curve: Curves.easeOut,
                              ),
                        if (report.mostActiveMonth != null)
                          const SizedBox(height: AppConstants.spacingXl),

                        // 6) Motivational summary
                        _buildMotivationalSummary(
                                context, report, isDark, isEn)
                            .animate()
                            .fadeIn(delay: 750.ms, duration: 500.ms)
                            .slideY(
                              begin: 0.1,
                              delay: 750.ms,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                        const SizedBox(height: AppConstants.spacingLg),

                        // Watermark
                        _buildWatermark(isDark)
                            .animate()
                            .fadeIn(delay: 900.ms, duration: 500.ms),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 1: YEAR HEADER
  // =========================================================================

  Widget _buildYearHeader(
    BuildContext context,
    _AnnualReportData report,
    bool isDark,
    bool isEn,
  ) {
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
          // Year
          Text(
            '${report.year}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.starGold,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn ? 'Your Year Synthesis' : 'Senin Yıl Sentezin',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 20),
          // Total entries stat
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatBadge(
                value: '${report.totalEntries}',
                label: isEn ? 'Entries' : 'Kayit',
                color: AppColors.starGold,
                isDark: isDark,
              ),
              const SizedBox(width: 16),
              _StatBadge(
                value: report.overallAverageRating.toStringAsFixed(1),
                label: isEn ? 'Avg Rating' : 'Ort Puan',
                color: AppColors.auroraStart,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 2: TOP FOCUS AREAS
  // =========================================================================

  Widget _buildTopFocusAreas(
    BuildContext context,
    _AnnualReportData report,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      width: double.infinity,
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
          Row(
            children: [
              Icon(Icons.pie_chart_outline,
                  color: AppColors.starGold, size: 20),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Top Focus Areas' : 'En Cok Odaklanilan Alanlar',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...report.topFocusAreas.asMap().entries.map((indexed) {
            final entry = indexed.value;
            final rank = indexed.key + 1;
            final area = entry.key;
            final pct = entry.value;
            final color = _focusAreaColor(area);
            final areaName =
                isEn ? area.displayNameEn : area.displayNameTr;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  // Rank badge
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.15),
                      border: Border.all(
                        color: color.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '#$rank',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Area name
                  Expanded(
                    child: Text(
                      areaName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  // Percentage bar + label
                  SizedBox(
                    width: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct / 100,
                              backgroundColor: isDark
                                  ? AppColors.surfaceLight
                                      .withValues(alpha: 0.3)
                                  : AppColors.lightSurfaceVariant,
                              valueColor: AlwaysStoppedAnimation(color),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
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

  // =========================================================================
  // SECTION 3: MONTHLY MOOD CHART
  // =========================================================================

  Widget _buildMonthlyChart(
    BuildContext context,
    _AnnualReportData report,
    bool isDark,
    bool isEn,
  ) {
    final maxRating = report.monthlyAverageRatings.values.isNotEmpty
        ? report.monthlyAverageRatings.values.reduce(max)
        : 5.0;
    const chartHeight = 140.0;

    return Container(
      width: double.infinity,
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
          Row(
            children: [
              Icon(Icons.bar_chart_rounded,
                  color: AppColors.auroraStart, size: 20),
              const SizedBox(width: 8),
              Text(
                isEn
                    ? 'Average Rating by Month'
                    : 'Aylik Ortalama Puanlar',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          SizedBox(
            height: chartHeight + 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (i) {
                final month = i + 1;
                final avg =
                    report.monthlyAverageRatings[month] ?? 0.0;
                final normalizedHeight = maxRating > 0
                    ? (avg / maxRating) * chartHeight
                    : 0.0;
                final hasData = avg > 0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Rating label above bar
                        if (hasData)
                          Text(
                            avg.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        const SizedBox(height: 2),
                        // Bar
                        Container(
                          height:
                              hasData ? max(4.0, normalizedHeight) : 4.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: hasData
                                ? LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.auroraStart
                                          .withValues(alpha: 0.9),
                                      AppColors.auroraEnd
                                          .withValues(alpha: 0.5),
                                    ],
                                  )
                                : null,
                            color: hasData
                                ? null
                                : (isDark
                                    ? AppColors.surfaceLight
                                        .withValues(alpha: 0.2)
                                    : AppColors.lightSurfaceVariant),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Month label
                        Text(
                          _monthName(month, isEn),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 4: LONGEST STREAK
  // =========================================================================

  Widget _buildStreakCard(
    BuildContext context,
    _AnnualReportData report,
    bool isDark,
    bool isEn,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.streakOrange.withValues(alpha: isDark ? 0.12 : 0.06),
            AppColors.starGold.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.streakOrange.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Streak flame icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.streakOrange.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.streakOrange.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: AppColors.streakOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Longest Streak' : 'En Uzun Seri',
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
                  isEn
                      ? '${report.longestStreak} consecutive days'
                      : '${report.longestStreak} ardisik gun',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.streakOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SECTION 5: MOST ACTIVE MONTH
  // =========================================================================

  Widget _buildMostActiveMonth(
    BuildContext context,
    _AnnualReportData report,
    bool isDark,
    bool isEn,
  ) {
    final month = report.mostActiveMonth!.key;
    final count = report.mostActiveMonth!.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.chartBlue.withValues(alpha: isDark ? 0.12 : 0.06),
            AppColors.auroraStart.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.chartBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Calendar icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.chartBlue.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.chartBlue.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: AppColors.chartBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEn ? 'Most Active Month' : 'En Aktif Ay',
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
                  _monthNameFull(month, isEn),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.chartBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEn
                      ? '$count entries recorded'
                      : '$count kayit yazildi',
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

  // =========================================================================
  // SECTION 6: MOTIVATIONAL SUMMARY
  // =========================================================================

  Widget _buildMotivationalSummary(
    BuildContext context,
    _AnnualReportData report,
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
          Icon(
            Icons.auto_awesome,
            color: AppColors.starGold,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            _motivationalMessage(report, isEn),
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

  // =========================================================================
  // WATERMARK
  // =========================================================================

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
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
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
// STAT BADGE COMPONENT
// ============================================================================

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatBadge({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        color: color.withValues(alpha: isDark ? 0.12 : 0.08),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
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
    );
  }
}
