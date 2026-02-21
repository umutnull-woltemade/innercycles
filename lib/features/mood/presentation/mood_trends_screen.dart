import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/mood_checkin_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';

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
          loading: () => const CosmicLoadingIndicator(),
          error: (_, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                CommonStrings.somethingWentWrong(language),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
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
    final allEntries = service.getAllEntries();
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

    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(title: isEn ? 'Mood Trends' : 'Ruh Hali Trendleri'),
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

                // Week view (FREE)
                _buildWeekCard(context, isDark, isEn, weekMoods, now),
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
                ContentDisclaimer(
                  language: isEn ? AppLanguage.en : AppLanguage.tr,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  Widget _buildPremiumSection(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    bool isEn,
    bool isPremium, {
    required Widget child,
  }) {
    if (isPremium) return child;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: child,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 28, color: AppColors.starGold),
                  const SizedBox(height: 8),
                  Text(
                    isEn ? 'Unlock 30-Day Analytics' : '30 Gün Analitiği Aç',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => showContextualPaywall(
                      context,
                      ref,
                      paywallContext: PaywallContext.patterns,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.starGold,
                      foregroundColor: AppColors.deepSpace,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                      ),
                    ),
                    child: Text(
                      isEn ? 'Upgrade to Premium' : 'Premium\'a Yükselt',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: isEn ? '7-Day Avg' : '7 Gün Ort.',
            value: avg7 > 0 ? avg7.toStringAsFixed(1) : '-',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: isEn ? '30-Day Avg' : '30 Gün Ort.',
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
            label: isEn ? 'Total Logs' : 'Toplam',
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
          Text(
            isEn ? 'This Week' : 'Bu Hafta',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
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
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mood != null
                          ? _moodColor(mood.mood).withValues(alpha: 0.2)
                          : (isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.1)
                                : AppColors.lightSurfaceVariant),
                    ),
                    child: Center(
                      child: Text(
                        mood?.emoji ?? '·',
                        style: const TextStyle(fontSize: 18),
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

  Widget _buildDistributionCard(
    BuildContext context,
    bool isDark,
    bool isEn,
    Map<int, int> distribution,
    int maxCount,
  ) {
    final labels = [
      (1, '😔', isEn ? 'Struggling' : 'Zor'),
      (2, '😐', isEn ? 'Low' : 'Düşük'),
      (3, '🙂', isEn ? 'Okay' : 'İdare'),
      (4, '😊', isEn ? 'Good' : 'İyi'),
      (5, '🤩', isEn ? 'Great' : 'Harika'),
    ];

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Last 30 Days' : 'Son 30 Gün',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...labels.map((item) {
            final count = distribution[item.$1] ?? 0;
            final fraction = maxCount > 0 ? count / maxCount : 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Text(item.$2, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: Text(
                      item.$3,
                      style: TextStyle(
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
                      child: LinearProgressIndicator(
                        value: fraction,
                        backgroundColor: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.15)
                            : AppColors.lightSurfaceVariant,
                        valueColor: AlwaysStoppedAnimation(_moodColor(item.$1)),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 24,
                    child: Text(
                      '$count',
                      textAlign: TextAlign.right,
                      style: TextStyle(
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
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEn ? 'Recent Check-ins' : 'Son Kayıtlar',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
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
                  Text(entry.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      dateStr,
                      style: TextStyle(
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
        return AppColors.chartOrange;
      case 3:
        return AppColors.starGold;
      case 4:
        return Colors.lightGreen;
      case 5:
        return AppColors.auroraStart;
      default:
        return AppColors.starGold;
    }
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isPro
                  ? AppColors.starGold.withValues(alpha: 0.5)
                  : AppColors.starGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
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
