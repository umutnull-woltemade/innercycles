import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/content/signal_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/mood_checkin_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/skeleton_loader.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/signal_orb.dart';
import 'widgets/signal_calendar.dart';

class MoodTrendsScreen extends ConsumerWidget {
  const MoodTrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(moodCheckinServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.when(
          loading: () => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SkeletonLoader.journalCard(index: 0),
                      const SizedBox(height: 16),
                      SkeletonLoader.paragraph(lines: 4, startIndex: 1),
                    ],
                  ),
                ),
              ),
          error: (_, _) => SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CommonStrings.somethingWentWrong(language),
                      textAlign: TextAlign.center,
                      style: AppTypography.decorativeScript(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () =>
                          ref.invalidate(moodCheckinServiceProvider),
                      icon: Icon(Icons.refresh_rounded,
                          size: 16, color: AppColors.starGold),
                      label: Text(
                        L10nService.get('mood.mood_trends.retry', language),
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
            ),
          ),
          data: (service) =>
              _buildContent(context, ref, service, isDark, isEn, isPremium),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    MoodCheckinService service,
    bool isDark,
    bool isEn,
    bool isPremium,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    final allEntries = service.getAllEntries();

    // Empty state — inline mood check-in so users can start right here
    if (allEntries.isEmpty) {
      return CupertinoScrollbar(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            GlassSliverAppBar(
              title: L10nService.get('mood.mood_trends.signal_dashboard', language),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingXl),
                  child: _EmptyStateMoodCheckin(
                    service: service,
                    ref: ref,
                    isDark: isDark,
                    isEn: isEn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
    }

    final weekMoods = service.getWeekMoods();
    final avg7 = service.getAverageMood(7);
    final avg30 = service.getAverageMood(30);

    // Distribution for last 30 days
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(days: 30));
    final recent = allEntries.where((e) => e.date.isAfter(cutoff)).toList();
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final entry in recent) {
      distribution[entry.mood] = (distribution[entry.mood] ?? 0) + 1;
    }
    final maxCount = distribution.values.fold(0, (a, b) => a > b ? a : b);

    return RefreshIndicator(
      color: AppColors.starGold,
      onRefresh: () async {
        ref.invalidate(moodCheckinServiceProvider);
        await Future.delayed(const Duration(milliseconds: 300));
      },
      child: CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(title: L10nService.get('mood.mood_trends.signal_dashboard_1', language)),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row (free: 7-day avg, premium: 30-day avg)
                _buildStatsRow(
                  context,
                  isDark,
                  isEn,
                  avg7,
                  avg30,
                  allEntries.length,
                  isPremium,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Quadrant Distribution (FREE — shows when signal data exists)
                if (service.getQuadrantDistribution(30).isNotEmpty)
                  _buildQuadrantDistribution(isDark, isEn, service),
                if (service.getQuadrantDistribution(30).isNotEmpty)
                  const SizedBox(height: AppConstants.spacingLg),

                // Signal Calendar (FREE)
                _buildSignalCalendar(isDark, isEn, allEntries, language),
                const SizedBox(height: AppConstants.spacingLg),

                // Week view (FREE)
                _buildWeekCard(context, isDark, isEn, weekMoods, now),
                const SizedBox(height: 8),
                // Share mood summary
                _buildShareMoodRow(isDark, isEn, avg7, weekMoods, allEntries.length),
                const SizedBox(height: AppConstants.spacingLg),

                // Mood Stability Score
                if (allEntries.length >= 7)
                  _buildStabilityCard(isDark, isEn, allEntries),
                if (allEntries.length >= 7)
                  const SizedBox(height: AppConstants.spacingLg),

                // Distribution chart (PREMIUM — blurred for free)
                _buildPremiumSection(
                  context,
                  ref,
                  isDark,
                  isEn,
                  isPremium,
                  child: _buildDistributionCard(
                    context,
                    isDark,
                    isEn,
                    distribution,
                    maxCount,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Recent entries (PREMIUM — blurred for free)
                if (allEntries.isNotEmpty)
                  _buildPremiumSection(
                    context,
                    ref,
                    isDark,
                    isEn,
                    isPremium,
                    child: _buildRecentCard(
                      context,
                      isDark,
                      isEn,
                      allEntries.take(20).toList(),
                    ),
                  ),
                // Time-of-Day mood pattern (PREMIUM)
                if (allEntries.length >= 7)
                  _buildPremiumSection(
                    context,
                    ref,
                    isDark,
                    isEn,
                    isPremium,
                    child: _buildTimeOfDayCard(
                      context,
                      isDark,
                      isEn,
                      allEntries,
                    ),
                  ),
                // Deeper Tools Discovery
                const SizedBox(height: AppConstants.spacingMd),
                _buildDeeperToolsSection(context, isDark, isEn),
                const SizedBox(height: AppConstants.spacingLg),

                ContentDisclaimer(
                  language: language,
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    )).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  Widget _buildPremiumSection(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    bool isEn,
    bool isPremium, {
    required Widget child,
  }) {
    final language = AppLanguage.fromIsEn(isEn);
    if (isPremium) return child;

    return Stack(
      children: [
        ExcludeSemantics(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: child,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: AppColors.starGold,
                      ),
                      const SizedBox(height: 2),
                      GradientText(
                        L10nService.get('mood.mood_trends.your_data_has_more_to_show', language),
                        variant: GradientTextVariant.gold,
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GradientButton.gold(
                        label: L10nService.get('mood.mood_trends.upgrade_to_pro', language),
                        onPressed: () => showContextualPaywall(
                          context,
                          ref,
                          paywallContext: PaywallContext.patterns,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuadrantDistribution(
    bool isDark,
    bool isEn,
    MoodCheckinService service,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    final dist = service.getQuadrantDistribution(30);
    final total = dist.values.fold(0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Quadrant Distribution' : 'Kadran Dağılımı',
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            isEn ? 'Last 30 days' : 'Son 30 gün',
            style: AppTypography.subtitle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          // Donut chart
          SizedBox(
            height: 120,
            child: Row(
              children: [
                // Donut
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomPaint(
                    painter: _QuadrantDonutPainter(
                      distribution: dist,
                      total: total,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Legend
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final q in SignalQuadrant.values)
                        if ((dist[q.name] ?? 0) > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: q.color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${q.emoji} ${q.localizedName(language)}',
                                    style: AppTypography.subtitle(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.textSecondary
                                          : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${((dist[q.name]! / total) * 100).round()}%',
                                  style: AppTypography.displayFont.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: q.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSignalCalendar(
    bool isDark,
    bool isEn,
    List<MoodEntry> entries,
    AppLanguage language,
  ) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Signal Calendar' : 'Sinyal Takvimi',
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SignalCalendar(
            entries: entries,
            language: language,
            isDark: isDark,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStatsRow(
    BuildContext context,
    bool isDark,
    bool isEn,
    double avg7,
    double avg30,
    int total,
    bool isPremium,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: L10nService.get('mood.mood_trends.7day_avg', language),
            value: avg7 > 0 ? avg7.toStringAsFixed(1) : '-',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: L10nService.get('mood.mood_trends.30day_avg', language),
            value: isPremium
                ? (avg30 > 0 ? avg30.toStringAsFixed(1) : '-')
                : 'PRO',
            isDark: isDark,
            isPro: !isPremium,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: L10nService.get('mood.mood_trends.total_logs', language),
            value: '$total',
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    List<MoodEntry?> weekMoods,
    DateTime now,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    final dayLabels = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    final weekStart = now.subtract(Duration(days: 6));

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('mood.mood_trends.this_week', language),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final day = weekStart.add(Duration(days: i));
              final dayIndex = (day.weekday - 1) % 7;
              final mood = weekMoods[i];
              return Column(
                children: [
                  Text(
                    dayLabels[dayIndex],
                    style: AppTypography.subtitle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Semantics(
                    label: mood != null
                        ? (isEn
                              ? '${dayLabels[dayIndex]}: mood ${mood.mood} of 5'
                              : '${dayLabels[dayIndex]}: ruh hali ${mood.mood}/5')
                        : (isEn
                              ? '${dayLabels[dayIndex]}: no entry'
                              : '${dayLabels[dayIndex]}: kayıt yok'),
                    child: mood != null && mood.hasSignal && mood.signalId != null
                        ? SizedBox(
                            width: 36,
                            height: 36,
                            child: Center(
                              child: SignalOrb.inline(
                                signalId: mood.signalId,
                                animate: false,
                              ),
                            ),
                          )
                        : Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: mood != null
                                  ? _moodColor(mood.mood)
                                      .withValues(alpha: 0.2)
                                  : (isDark
                                        ? AppColors.surfaceLight
                                            .withValues(alpha: 0.1)
                                        : AppColors.lightSurfaceVariant),
                            ),
                            child: Center(
                              child: Text(
                                mood?.emoji ?? '·',
                                style:
                                    AppTypography.subtitle(fontSize: 18),
                              ),
                            ),
                          ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStabilityCard(bool isDark, bool isEn, List<MoodEntry> entries) {
    // Calculate stability from last 30 days
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(days: 30));
    final recent = entries.where((e) => e.date.isAfter(cutoff)).toList();
    if (recent.length < 3) return const SizedBox.shrink();

    final moods = recent.map((e) => e.mood.toDouble()).toList();
    final avg = moods.reduce((a, b) => a + b) / moods.length;
    // Standard deviation
    final variance = moods.map((m) => (m - avg) * (m - avg)).reduce((a, b) => a + b) / moods.length;
    final stdDev = variance > 0 ? (variance * 1.0) : 0.0;
    // Stability: 100 means perfectly stable, 0 means max variance
    // Max possible std for 1-5 scale is 2.0
    final stability = ((1 - math.sqrt(stdDev) / 2.0) * 100).round().clamp(0, 100);

    final color = stability >= 70
        ? AppColors.success
        : stability >= 40
            ? AppColors.auroraStart
            : AppColors.warning;
    final label = stability >= 70
        ? (isEn ? 'Very Stable' : 'Çok Stabil')
        : stability >= 40
            ? (isEn ? 'Moderate' : 'Orta')
            : (isEn ? 'Variable' : 'Değişken');

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GradientText(
                isEn ? 'Mood Stability' : 'Duygu Stabilitesi',
                variant: GradientTextVariant.aurora,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: AppTypography.modernAccent(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$stability%',
                style: AppTypography.displayFont.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: stability / 100,
                        minHeight: 8,
                        backgroundColor: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isEn
                          ? 'Based on ${recent.length} entries in the last 30 days'
                          : 'Son 30 günde ${recent.length} kayda dayalı',
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }

  Widget _buildShareMoodRow(
    bool isDark,
    bool isEn,
    double avg7,
    List<MoodEntry?> weekMoods,
    int totalLogs,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    if (totalLogs < 3) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          HapticService.buttonPress();
          final filledDays = weekMoods.where((m) => m != null).length;
          final emojis = weekMoods
              .map((m) => m?.emoji ?? '·')
              .join(' ');
          final msg = isEn
              ? 'My mood this week: $emojis\n7-day average: ${avg7.toStringAsFixed(1)}/5 ($filledDays days tracked)\n\nTracking my emotional patterns with InnerCycles.\n${AppConstants.appStoreUrl}\n#InnerCycles #MoodTracking'
              : 'Bu haftaki ruh halim: $emojis\n7 günlük ortalama: ${avg7.toStringAsFixed(1)}/5 ($filledDays gün takip)\n\nInnerCycles ile duygusal örüntülerimi takip ediyorum.\n${AppConstants.appStoreUrl}\n#InnerCycles';
          SharePlus.instance.share(ShareParams(text: msg));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share_rounded,
              size: 14,
              color: AppColors.starGold.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 4),
            Text(
              L10nService.get('mood.mood_trends.share_week', language),
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: AppColors.starGold.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    Map<int, int> distribution,
    int maxCount,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    final labels = [
      (1, '😔', L10nService.get('mood.mood_trends.struggling', language)),
      (2, '😐', L10nService.get('mood.mood_trends.low', language)),
      (3, '🙂', L10nService.get('mood.mood_trends.okay', language)),
      (4, '😊', L10nService.get('mood.mood_trends.good', language)),
      (5, '🤩', L10nService.get('mood.mood_trends.great', language)),
    ];

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('mood.mood_trends.last_30_days', language),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...labels.map((item) {
            final count = distribution[item.$1] ?? 0;
            final fraction = maxCount > 0 ? count / maxCount : 0.0;
            return Semantics(
              label: '${item.$3}: $count',
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    AppSymbol.inline(item.$2),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 60,
                      child: Text(
                        item.$3,
                        style: AppTypography.subtitle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Semantics(
                          value: '${(fraction * 100).round()}%',
                          child: LinearProgressIndicator(
                            value: fraction,
                            backgroundColor: isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.15)
                                : AppColors.lightSurfaceVariant,
                            valueColor: AlwaysStoppedAnimation(
                              _moodColor(item.$1),
                            ),
                            minHeight: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 24,
                      child: Text(
                        '$count',
                        textAlign: TextAlign.right,
                        style: AppTypography.modernAccent(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    List<MoodEntry> entries,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('mood.mood_trends.recent_checkins', language),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...entries.map((entry) {
            final dateStr =
                '${entry.date.day}.${entry.date.month}.${entry.date.year}';
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  (entry.hasSignal && entry.signalId != null)
                      ? SignalOrb.inline(
                          signalId: entry.signalId,
                          animate: false,
                        )
                      : AppSymbol.inline(entry.emoji),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dateStr,
                      style: AppTypography.subtitle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  _buildMoodDots(entry.mood, isDark),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMoodDots(int mood, bool isDark) {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < mood;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled
                  ? _moodColor(mood)
                  : (isDark
                        ? AppColors.surfaceLight.withValues(alpha: 0.2)
                        : AppColors.lightSurfaceVariant),
            ),
          ),
        );
      }),
    );
  }

  Color _moodColor(int mood) {
    switch (mood) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.auroraStart;
      case 4:
        return AppColors.success;
      case 5:
        return AppColors.starGold;
      default:
        return AppColors.textMuted;
    }
  }

  Widget _buildTimeOfDayCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    List<MoodEntry> allEntries,
  ) {
    // Group by time bucket
    final buckets = <String, List<int>>{
      'morning': [],
      'afternoon': [],
      'evening': [],
    };

    for (final entry in allEntries) {
      final hour = entry.loggedHour;
      if (hour >= 6 && hour < 12) {
        buckets['morning']!.add(entry.mood);
      } else if (hour >= 12 && hour < 18) {
        buckets['afternoon']!.add(entry.mood);
      } else {
        buckets['evening']!.add(entry.mood);
      }
    }

    // Need at least 2 buckets with data
    final activeBuckets = buckets.entries
        .where((e) => e.value.isNotEmpty)
        .toList();
    if (activeBuckets.length < 2) return const SizedBox.shrink();

    final averages = <String, double>{};
    for (final entry in activeBuckets) {
      averages[entry.key] = entry.value.reduce((a, b) => a + b) /
          entry.value.length;
    }

    final bestTime = averages.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    final labels = {
      'morning': (
        isEn ? 'Morning' : 'Sabah',
        '\u{1F305}',
      ),
      'afternoon': (
        isEn ? 'Afternoon' : '\u{00D6}\u{011F}leden Sonra',
        '\u{2600}\u{FE0F}',
      ),
      'evening': (
        isEn ? 'Evening' : 'Ak\u{015F}am',
        '\u{1F319}',
      ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingLg),
      child: PremiumCard(
        style: PremiumCardStyle.aurora,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              isEn
                  ? 'Your Best Time of Day'
                  : 'G\u{00FC}n\u{00FC}n En \u{0130}yi Zaman\u{0131}',
              variant: GradientTextVariant.aurora,
              style: AppTypography.displayFont.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            for (final bucket in ['morning', 'afternoon', 'evening'])
              if (averages.containsKey(bucket)) ...[
                _buildTimeBar(
                  emoji: labels[bucket]!.$2,
                  label: labels[bucket]!.$1,
                  avg: averages[bucket]!,
                  isBest: bucket == bestTime.key,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
              ],
            const SizedBox(height: 4),
            Text(
              isEn
                  ? 'You tend to feel best in the ${labels[bestTime.key]!.$1.toLowerCase()}'
                  : '${labels[bestTime.key]!.$1} saatlerinde daha iyi hissediyorsun',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBar({
    required String emoji,
    required String label,
    required double avg,
    required bool isBest,
    required bool isDark,
  }) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (avg / 5).clamp(0, 1),
              minHeight: 8,
              backgroundColor: (isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted)
                  .withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation(
                isBest ? AppColors.success : AppColors.starGold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          avg.toStringAsFixed(1),
          style: AppTypography.displayFont.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isBest
                ? AppColors.success
                : (isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildDeeperToolsSection(
    BuildContext context,
    bool isDark,
    bool isEn,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    return GlassPanel(
      elevation: GlassElevation.g1,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('mood.mood_trends.go_deeper', language),
            variant: GradientTextVariant.amethyst,
            style: AppTypography.displayFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildToolTile(
            context,
            isDark,
            icon: Icons.favorite_rounded,
            color: AppColors.amethyst,
            title: isEn ? 'Cycle Sync' : 'Döngü Senkronu',
            subtitle: isEn ? 'How your cycle shapes your emotions' : 'Döngün duygularını nasıl şekillendiriyor',
            route: Routes.cycleSync,
          ),
          const SizedBox(height: 8),
          _buildToolTile(
            context,
            isDark,
            icon: Icons.psychology_rounded,
            color: AppColors.amethyst,
            title: isEn ? 'Shadow Work' : 'Gölge Çalışması',
            subtitle: isEn ? 'Explore hidden emotional patterns' : 'Gizli duygusal kalıpları keşfet',
            route: Routes.shadowWork,
          ),
          const SizedBox(height: 8),
          _buildToolTile(
            context,
            isDark,
            icon: Icons.waves_rounded,
            color: AppColors.auroraStart,
            title: isEn ? 'Emotional Cycles' : 'Duygusal Döngüler',
            subtitle: isEn ? 'Recurring patterns over time' : 'Zaman içinde tekrarlanan kalıplar',
            route: Routes.emotionalCycles,
          ),
          const SizedBox(height: 8),
          _buildToolTile(
            context,
            isDark,
            icon: Icons.calendar_month_rounded,
            color: AppColors.starGold,
            title: isEn ? 'Heatmap Timeline' : 'Isı Haritası Zaman Çizelgesi',
            subtitle: isEn ? 'Visualize your journaling activity' : 'Günlük aktiviteni görselleştir',
            route: Routes.calendarHeatmap,
          ),
        ],
      ),
    );
  }

  Widget _buildToolTile(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        HapticService.selectionTap();
        context.push(route);
      },
      child: Semantics(
        label: title,
        button: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.08 : 0.06),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.modernAccent(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
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
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isPro;

  const _StatTile({
    required this.label,
    required this.value,
    required this.isDark,
    this.isPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      elevation: GlassElevation.g1,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingLg,
      ),
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.displayFont.copyWith(
              fontSize: 24,
              color: isPro
                  ? AppColors.starGold.withValues(alpha: 0.5)
                  : AppColors.starGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 11,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// INLINE MOOD CHECK-IN — Replaces empty state with actionable UI
// ════════════════════════════════════════════════════════════════════════════

class _EmptyStateMoodCheckin extends StatelessWidget {
  final MoodCheckinService service;
  final WidgetRef ref;
  final bool isDark;
  final bool isEn;

  const _EmptyStateMoodCheckin({
    required this.service,
    required this.ref,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.amethyst.withValues(alpha: 0.15),
                AppColors.amethyst.withValues(alpha: 0.03),
              ],
            ),
          ),
          child: Icon(
            Icons.insights_rounded,
            size: 40,
            color: AppColors.amethyst.withValues(alpha: 0.7),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),

        const SizedBox(height: 20),

        GradientText(
          L10nService.get('mood.mood_trends.start_your_first_checkin', language),
          variant: GradientTextVariant.amethyst,
          textAlign: TextAlign.center,
          style: AppTypography.displayFont.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

        const SizedBox(height: 8),

        Text(
          L10nService.get('mood.mood_trends.tap_how_you_feel_your_dashboard_lights_u', language),
          textAlign: TextAlign.center,
          style: AppTypography.decorativeScript(
            fontSize: 14,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

        const SizedBox(height: 32),

        // Inline mood options
        GlassPanel(
          elevation: GlassElevation.g2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: 20,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: Column(
            children: [
              Text(
                L10nService.get('mood.mood_trends.how_are_you_feeling_right_now', language),
                style: AppTypography.displayFont.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: MoodCheckinService.moodOptions.map((option) {
                  final (mood, emoji, labelEn, labelTr) = option;
                  final label = isEn ? labelEn : labelTr;
                  return Semantics(
                    label: label,
                    button: true,
                    child: GestureDetector(
                      onTap: () async {
                        HapticService.moodSelected();
                        await service.logMood(mood, emoji);
                        ref.invalidate(moodCheckinServiceProvider);
                      },
                      child: Column(
                        children: [
                          AppSymbol.card(emoji),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: AppTypography.elegantAccent(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 400.ms)
            .slideY(begin: 0.1, end: 0, duration: 400.ms),
      ],
    );
  }
}

class _QuadrantDonutPainter extends CustomPainter {
  final Map<String, int> distribution;
  final int total;

  _QuadrantDonutPainter({required this.distribution, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final strokeWidth = 16.0;

    var startAngle = -math.pi / 2;
    final order = ['fire', 'water', 'storm', 'shadow'];
    final colors = {
      'fire': AppColors.starGold,
      'water': AppColors.waterCalm,
      'storm': AppColors.stormAmber,
      'shadow': AppColors.amethyst,
    };

    for (final key in order) {
      final count = distribution[key] ?? 0;
      if (count == 0) continue;
      final sweepAngle = (count / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[key]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        math.max(sweepAngle - 0.04, 0.01), // small gap between segments
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _QuadrantDonutPainter oldDelegate) =>
      oldDelegate.distribution != distribution || oldDelegate.total != total;
}
