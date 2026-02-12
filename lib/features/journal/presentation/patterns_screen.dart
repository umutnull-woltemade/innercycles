import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/pattern_engine_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';

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
            error: (_, _) => const SizedBox.shrink(),
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
                  Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: AppColors.starGold.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isEn
                        ? 'Patterns Unlock After 7 Entries'
                        : '7 Kayıttan Sonra Kalıplar Açılır',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w600,
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
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: current / 7,
                      backgroundColor: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.3)
                          : AppColors.lightSurfaceVariant,
                      valueColor: AlwaysStoppedAnimation(AppColors.starGold),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$current / 7',
                    style: TextStyle(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ].animate(interval: 100.ms).fadeIn(duration: 400.ms),
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
              // Cycle arcs visualization
              _buildCycleArcs(context, thisWeek, isDark)
                  .animate()
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: AppConstants.spacingXl),

              // Weekly comparison
              if (thisWeek.isNotEmpty)
                _buildWeeklyComparison(
                  context,
                  thisWeek,
                  lastWeek,
                  isDark,
                  isEn,
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              if (thisWeek.isNotEmpty)
                const SizedBox(height: AppConstants.spacingLg),

              // Trends
              if (trends.isNotEmpty)
                _buildTrends(context, trends, isDark, isEn)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms),
              if (trends.isNotEmpty)
                const SizedBox(height: AppConstants.spacingLg),

              // Correlations
              if (correlations.isNotEmpty)
                _buildCorrelations(context, correlations, isDark, isEn)
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: 40),
            ]),
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

  Widget _buildWeeklyComparison(
    BuildContext context,
    Map<FocusArea, double> thisWeek,
    Map<FocusArea, double> lastWeek,
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

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
