import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/premium_service.dart';
import '../../../data/services/streak_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/gradient_text.dart';

class StreakStatsScreen extends ConsumerWidget {
  const StreakStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final streakAsync = ref.watch(streakServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return Scaffold(
      body: CosmicBackground(
        child: streakAsync.when(
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
          data: (service) {
            final stats = service.getStats(isPremium: isPremium);
            final weekCal = service.getWeekCalendar();
            return _buildContent(
              context,
              ref,
              service,
              stats,
              weekCal,
              isDark,
              isEn,
              isPremium,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    StreakService service,
    StreakStats stats,
    Map<DateTime, bool> weekCalendar,
    bool isDark,
    bool isEn,
    bool isPremium,
  ) {
    return CupertinoScrollbar(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          GlassSliverAppBar(
            title: isEn ? 'Streak Engine' : 'Seri Motoru',
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Current streak hero
                _buildStreakHero(context, stats, isDark, isEn),
                const SizedBox(height: AppConstants.spacingLg),

                // Stats row
                _buildStatsRow(context, stats, isDark, isEn),
                const SizedBox(height: AppConstants.spacingLg),

                // This week calendar
                _buildWeekCalendar(context, weekCalendar, isDark, isEn),
                const SizedBox(height: AppConstants.spacingLg),

                // Freeze status
                _buildFreezeCard(
                  context,
                  ref,
                  service,
                  stats,
                  isDark,
                  isEn,
                  isPremium,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Milestones
                _buildMilestonesCard(context, stats, isDark, isEn),
                const SizedBox(height: AppConstants.spacingLg),

                // Quick action
                _buildQuickAction(context, isDark, isEn),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, duration: 400.ms);
  }

  Widget _buildStreakHero(
    BuildContext context,
    StreakStats stats,
    bool isDark,
    bool isEn,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g3,
      glowColor: AppColors.starGold.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        children: [
          GradientText(
            '${stats.currentStreak}',
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 72,
            ),
          ),
          Text(
            isEn ? 'day streak' : 'günlük seri',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w300,
            ),
          ),
          if (stats.nextMilestone != null) ...[
            const SizedBox(height: 12),
            Semantics(
              label: isEn
                  ? '${stats.currentStreak} of ${stats.nextMilestone} day milestone'
                  : '${stats.nextMilestone} günlük hedefin ${stats.currentStreak} günü tamamlandı',
              child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: stats.nextMilestone! > 0
                    ? (stats.currentStreak / stats.nextMilestone!).clamp(
                        0.0,
                        1.0,
                      )
                    : 0.0,
                backgroundColor: isDark
                    ? AppColors.surfaceLight.withValues(alpha: 0.15)
                    : AppColors.lightSurfaceVariant,
                valueColor: AlwaysStoppedAnimation(AppColors.starGold),
                minHeight: 6,
              ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isEn
                  ? '${stats.nextMilestone! - stats.currentStreak} days to ${stats.nextMilestone}-day milestone'
                  : '${stats.nextMilestone}-gün kilometre taşına ${stats.nextMilestone! - stats.currentStreak} gün',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    StreakStats stats,
    bool isDark,
    bool isEn,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: isEn ? 'Longest' : 'En Uzun',
            value: '${stats.longestStreak}',
            icon: Icons.emoji_events_outlined,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: isEn ? 'Total Entries' : 'Toplam Kayıt',
            value: '${stats.totalEntries}',
            icon: Icons.edit_note,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _StatTile(
            label: isEn ? 'Milestones' : 'Başarılar',
            value: '${stats.celebratedMilestones.length}',
            icon: Icons.stars_outlined,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekCalendar(
    BuildContext context,
    Map<DateTime, bool> weekCalendar,
    bool isDark,
    bool isEn,
  ) {
    final dayLabels = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final today = DateTime.now();

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'This Week' : 'Bu Hafta',
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekCalendar.entries.toList().asMap().entries.map((
              mapEntry,
            ) {
              final i = mapEntry.key;
              final entry = mapEntry.value;
              final day = entry.key;
              final logged = entry.value;
              final isToday =
                  day.year == today.year &&
                  day.month == today.month &&
                  day.day == today.day;

              return Column(
                children: [
                  Text(
                    dayLabels[i],
                    style: TextStyle(
                      fontSize: 11,
                      color: isToday
                          ? AppColors.starGold
                          : (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: logged
                          ? AppColors.auroraStart.withValues(alpha: 0.2)
                          : (isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.1)
                                : AppColors.lightSurfaceVariant),
                      border: isToday
                          ? Border.all(color: AppColors.starGold, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: logged
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.auroraStart,
                            )
                          : Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFreezeCard(
    BuildContext context,
    WidgetRef ref,
    StreakService service,
    StreakStats stats,
    bool isDark,
    bool isEn,
    bool isPremium,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.ac_unit, color: AppColors.auroraStart, size: 20),
              const SizedBox(width: 8),
              GradientText(
                isEn ? 'Streak Freeze' : 'Seri Dondurma',
                variant: GradientTextVariant.aurora,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: Text(
                  isEn
                      ? '${stats.freezesAvailable} freeze${stats.freezesAvailable == 1 ? '' : 's'} available this week'
                      : 'Bu hafta ${stats.freezesAvailable} dondurma hakkı',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              if (stats.freezesAvailable > 0)
                TextButton(
                  onPressed: () async {
                    await service.useFreeze(isPremium: isPremium);
                    if (!context.mounted) return;
                    ref.invalidate(streakServiceProvider);
                    ref.invalidate(streakStatsProvider);
                  },
                  child: Text(
                    isEn ? 'Use Freeze' : 'Kullan',
                    style: TextStyle(color: AppColors.auroraStart),
                  ),
                ),
            ],
          ),
          if (!isPremium) ...[
            const SizedBox(height: 8),
            Text(
              isEn
                  ? 'Premium: 3 freezes per week'
                  : 'Premium: Haftada 3 dondurma hakkı',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.starGold.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMilestonesCard(
    BuildContext context,
    StreakStats stats,
    bool isDark,
    bool isEn,
  ) {
    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            isEn ? 'Milestones' : 'Kilometre Taşları',
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: streakMilestones.map((milestone) {
              final reached = stats.currentStreak >= milestone;
              final celebrated = stats.celebratedMilestones.contains(milestone);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: reached
                          ? AppColors.starGold.withValues(alpha: 0.2)
                          : (isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.1)
                                : AppColors.lightSurfaceVariant),
                      border: Border.all(
                        color: reached
                            ? AppColors.starGold
                            : (isDark
                                  ? AppColors.surfaceLight.withValues(
                                      alpha: 0.3,
                                    )
                                  : AppColors.lightTextMuted.withValues(
                                      alpha: 0.3,
                                    )),
                        width: reached ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: reached
                          ? Icon(
                              celebrated ? Icons.star : Icons.check,
                              size: 20,
                              color: AppColors.starGold,
                            )
                          : Text(
                              '$milestone',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEn ? '$milestone d' : '$milestone g',
                    style: TextStyle(
                      fontSize: 10,
                      color: reached
                          ? AppColors.starGold
                          : (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                      fontWeight: reached ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, bool isDark, bool isEn) {
    return GradientOutlinedButton(
      label: isEn ? 'Log Today\'s Entry' : 'Bugünün Kaydını Yaz',
      icon: Icons.edit_note,
      variant: GradientTextVariant.gold,
      expanded: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      onPressed: () => context.go(Routes.journal),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
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
          Icon(icon, color: AppColors.starGold, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
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
