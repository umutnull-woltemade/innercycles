import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'dart:ui';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/cross_correlation_result.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/pattern_engine_service.dart';
import '../../../data/services/pattern_health_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

class PatternsScreen extends ConsumerWidget {
  const PatternsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  isEn ? 'Something went wrong' : 'Bir şeyler yanlış gitti',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
            data: (service) {
              final engine = PatternEngineService(service);

              if (!engine.hasEnoughData()) {
                return _buildLockedView(
                  context,
                  isDark,
                  isEn,
                  engine.entriesNeeded(),
                  service.entryCount,
                );
              }

              return _buildPatternsView(context, ref, engine, isDark, isEn);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLockedView(
    BuildContext context,
    bool isDark,
    bool isEn,
    int needed,
    int current,
  ) {
    final progress = (current / 7).clamp(0.0, 1.0);

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          _buildAppBar(context, isDark, isEn),
          SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Blurred preview teaser
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Fake chart preview (blurred)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.starGold.withValues(alpha: 0.1),
                                  AppColors.amethyst.withValues(alpha: 0.08),
                                  AppColors.auroraStart.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(7, (i) {
                                final h = 30.0 + (i * 8.0) + (i.isEven ? 15 : 0);
                                return Container(
                                  width: 24,
                                  height: h,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.starGold.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                      // Lock overlay
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.surfaceDark.withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.starGold.withValues(alpha: 0.3),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          size: 32,
                          color: AppColors.starGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    isEn
                        ? 'Patterns Unlock After 7 Entries'
                        : '7 Kayıttan Sonra Kalıplar Açılır',
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
                        ? 'You have $current entries. $needed more to go!'
                        : '$current kaydınız var. $needed tane daha!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Animated progress ring
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
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.2)
                                : AppColors.lightSurfaceVariant,
                            valueColor: AlwaysStoppedAnimation(AppColors.starGold),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          '$current/7',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.starGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // CTA to journal
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push(Routes.journal),
                      icon: const Icon(Icons.edit_note_outlined, size: 20),
                      label: Text(
                        isEn ? 'Write Entry' : 'Kayıt Yaz',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.starGold,
                        foregroundColor: AppColors.deepSpace,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ].animate(interval: 80.ms).fadeIn(duration: 400.ms).slideY(
                      begin: 0.08,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _buildPatternsView(
    BuildContext context,
    WidgetRef ref,
    PatternEngineService engine,
    bool isDark,
    bool isEn,
  ) {
    final thisWeek = engine.getWeeklyAverages();
    final lastWeek = engine.getLastWeekAverages();
    final trends = engine.detectTrends();
    final correlations = engine.detectCorrelations();
    final healthAsync = ref.watch(patternHealthReportProvider);
    final crossCorrelationsAsync = ref.watch(crossCorrelationsProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    // Extract dimension health map (null if loading/error)
    final healthMap = healthAsync.whenOrNull(
      data: (report) => report.dimensionHealth,
    );

    // Extract cross-correlations (empty list if loading/error)
    final crossCorrelations = crossCorrelationsAsync.whenOrNull(
      data: (list) => list,
    ) ?? [];

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
        _buildAppBar(context, isDark, isEn),
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Cycle arcs visualization — always free
              _buildCycleArcs(context, thisWeek, isDark)
                  .animate()
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: AppConstants.spacingXl),

              // Weekly comparison — always free (summary level)
              if (thisWeek.isNotEmpty)
                _buildWeeklyComparison(
                  context,
                  thisWeek,
                  lastWeek,
                  isDark,
                  isEn,
                  healthMap: isPremium ? healthMap : null,
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              if (thisWeek.isNotEmpty)
                const SizedBox(height: AppConstants.spacingLg),

              // Deep analysis — blurred for free users
              if (!isPremium && (trends.isNotEmpty || correlations.isNotEmpty || crossCorrelations.isNotEmpty))
                _buildPremiumBlurOverlay(context, ref, isEn, isDark,
                  child: Column(
                    children: [
                      if (trends.isNotEmpty)
                        _buildTrends(context, trends, isDark, isEn),
                      if (trends.isNotEmpty)
                        const SizedBox(height: AppConstants.spacingLg),
                      if (correlations.isNotEmpty)
                        _buildCorrelations(context, correlations, isDark, isEn),
                      if (correlations.isNotEmpty)
                        const SizedBox(height: AppConstants.spacingLg),
                      if (crossCorrelations.isNotEmpty)
                        _buildCrossCorrelations(
                          context, crossCorrelations, isDark, isEn,
                        ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              // Premium users see everything unblurred
              if (isPremium) ...[
                if (trends.isNotEmpty)
                  _buildTrends(context, trends, isDark, isEn)
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms),
                if (trends.isNotEmpty)
                  const SizedBox(height: AppConstants.spacingLg),
                if (correlations.isNotEmpty)
                  _buildCorrelations(context, correlations, isDark, isEn)
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms),
                if (correlations.isNotEmpty)
                  const SizedBox(height: AppConstants.spacingLg),
                if (crossCorrelations.isNotEmpty)
                  _buildCrossCorrelations(
                    context, crossCorrelations, isDark, isEn,
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
              ],
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
      ),
    );
  }

  /// Blurred overlay for deep analysis sections — tappable to open contextual paywall
  Widget _buildPremiumBlurOverlay(
    BuildContext context,
    WidgetRef ref,
    bool isEn,
    bool isDark, {
    required Widget child,
  }) {
    return GestureDetector(
      onTap: () {
        showContextualPaywall(
          context,
          ref,
          paywallContext: PaywallContext.patterns,
        );
      },
      child: Stack(
        children: [
          // Blurred content
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: IgnorePointer(child: child),
            ),
          ),
          // Overlay CTA
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (isDark ? Colors.black : Colors.white).withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.starGold, Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.starGold.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.black, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        isEn ? 'See Full Analysis' : 'Tam Analizi Gör',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GlassSliverAppBar _buildAppBar(BuildContext context, bool isDark, bool isEn) {
    return GlassSliverAppBar(
      title: isEn ? 'Your Patterns' : 'Kalıpların',
    );
  }

  Widget _buildCycleArcs(
    BuildContext context,
    Map<FocusArea, double> averages,
    bool isDark,
  ) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.2),
        ),
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 170),
        painter: _CycleArcsPainter(averages, isDark),
      ),
    );
  }

  Color _healthStatusColor(HealthStatus status) {
    switch (status) {
      case HealthStatus.green:
        return AppColors.success;
      case HealthStatus.yellow:
        return AppColors.warning;
      case HealthStatus.red:
        return const Color(0xFFE53935);
    }
  }

  Widget _buildWeeklyComparison(
    BuildContext context,
    Map<FocusArea, double> thisWeek,
    Map<FocusArea, double> lastWeek,
    bool isDark,
    bool isEn, {
    Map<FocusArea, DimensionHealth>? healthMap,
  }) {
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
            isEn ? 'This Week vs Last Week' : 'Bu Hafta vs Geçen Hafta',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...thisWeek.entries.map((entry) {
            final prev = lastWeek[entry.key];
            final diff = prev != null ? entry.value - prev : 0.0;
            final label = isEn
                ? entry.key.displayNameEn
                : entry.key.displayNameTr;
            final dimensionHealth = healthMap?[entry.key];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  // Health status dot
                  if (dimensionHealth != null) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _healthStatusColor(dimensionHealth.status),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  SizedBox(
                    width: dimensionHealth != null ? 76 : 90,
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
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: entry.value / 5,
                        backgroundColor: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.3)
                            : AppColors.lightSurfaceVariant,
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.starGold),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.value.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (diff.abs() > 0.1)
                    Icon(
                      diff > 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 14,
                      color: diff > 0 ? AppColors.success : AppColors.error,
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrends(
    BuildContext context,
    List<TrendInsight> trends,
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
            isEn ? 'Trends' : 'Eğilimler',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...trends.map((t) {
            final icon = t.direction == TrendDirection.up
                ? Icons.trending_up
                : t.direction == TrendDirection.down
                    ? Icons.trending_down
                    : Icons.trending_flat;
            final color = t.direction == TrendDirection.up
                ? AppColors.success
                : t.direction == TrendDirection.down
                    ? AppColors.error
                    : AppColors.starGold;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEn ? t.getMessageEn() : t.getMessageTr(),
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
          }),
        ],
      ),
    );
  }

  Widget _buildCorrelations(
    BuildContext context,
    List<CorrelationInsight> correlations,
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
            isEn ? 'Connections' : 'Bağlantılar',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...correlations.map((c) {
            final msg = isEn ? c.getMessageEn() : c.getMessageTr();
            if (msg.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    color: AppColors.auroraStart,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      msg,
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
          }),
        ],
      ),
    );
  }

  Widget _buildCrossCorrelations(
    BuildContext context,
    List<CrossCorrelation> crossCorrelations,
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
          Row(
            children: [
              Icon(
                Icons.insights,
                color: AppColors.auroraStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Cross-Dimension Insights' : 'Boyutlar Arası İçgörüler',
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
          ...crossCorrelations.map((cc) {
            final strengthColor = cc.coefficient.abs() >= 0.7
                ? AppColors.success
                : cc.coefficient.abs() >= 0.5
                    ? AppColors.starGold
                    : AppColors.auroraStart;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dimension pair header
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: strengthColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isEn
                            ? cc.shortDisplayEn()
                            : cc.shortDisplayTr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Insight text
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      isEn ? cc.insightTextEn : cc.insightTextTr,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  // Correlation strength bar
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            isEn
                                ? '${cc.sampleSize} days'
                                : '${cc.sampleSize} gün',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textSecondary.withValues(alpha: 0.7)
                                  : AppColors.lightTextSecondary.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: cc.coefficient.abs(),
                              backgroundColor: isDark
                                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                                  : AppColors.lightSurfaceVariant,
                              valueColor:
                                  AlwaysStoppedAnimation(strengthColor),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppConstants.spacingSm),
          // Disclaimer
          Text(
            isEn
                ? 'Based on your personal journal entries. Not a clinical assessment.'
                : 'Kişisel günlük kayıtlarınıza dayanmaktadır. Klinik bir değerlendirme değildir.',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: isDark
                  ? AppColors.textSecondary.withValues(alpha: 0.5)
                  : AppColors.lightTextSecondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// CYCLE ARCS PAINTER
// ══════════════════════════════════════════════════════════════════════════

class _CycleArcsPainter extends CustomPainter {
  final Map<FocusArea, double> averages;
  final bool isDark;

  static const _colors = [
    Color(0xFFFFD700), // Energy - gold
    Color(0xFF4FC3F7), // Focus - blue
    Color(0xFFFF6B9D), // Emotions - pink
    Color(0xFF81C784), // Decisions - green
    Color(0xFFCE93D8), // Social - purple
  ];

  _CycleArcsPainter(this.averages, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final maxRadius = size.height * 0.9;

    for (int i = 0; i < FocusArea.values.length; i++) {
      final area = FocusArea.values[i];
      final value = averages[area] ?? 0;
      if (value == 0) continue;

      final radius = maxRadius - (i * 28);
      final sweepAngle = (value / 5) * 3.14159; // Half circle, scaled by rating
      final startAngle = 3.14159; // Start from left (180 degrees)

      final paint = Paint()
        ..color = _colors[i].withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round;

      // Background arc
      final bgPaint = Paint()
        ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        3.14159,
        false,
        bgPaint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: area.displayNameEn,
          style: TextStyle(
            color: _colors[i],
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(
        canvas,
        Offset(center.dx + radius + 4, center.dy - 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CycleArcsPainter oldDelegate) =>
      oldDelegate.averages != averages || oldDelegate.isDark != isDark;
}
