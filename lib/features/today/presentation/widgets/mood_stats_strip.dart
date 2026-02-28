import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../../data/services/l10n_service.dart';

class MoodStatsStrip extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const MoodStatsStrip({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakStatsProvider);
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);

    final streakCount =
        streakAsync.whenOrNull(data: (stats) => stats.currentStreak) ?? 0;

    final todayMood = moodAsync.whenOrNull(
      data: (service) => service.getTodayMood(),
    );

    final entryCount =
        journalAsync.whenOrNull(
          data: (service) => service.getAllEntries().length,
        ) ??
        0;

    final moodEmoji = todayMood?.emoji;
    final moodText = todayMood != null
        ? _moodLabel(todayMood.mood)
        : (L10nService.get('today.mood_stats_strip.check_in', isEn ? AppLanguage.en : AppLanguage.tr));
    final hasNoMood = todayMood == null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: PremiumCard(
        style: PremiumCardStyle.subtle,
        showGradientBorder: false,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        borderRadius: 16,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              // Mood pill
              Expanded(
                child: _StripPill(
                  emoji: moodEmoji,
                  icon: moodEmoji == null ? Icons.favorite_rounded : null,
                  iconColor: AppColors.auroraStart,
                  label: moodText,
                  isDark: isDark,
                  showPulse: hasNoMood,
                  onTap: () {
                    HapticService.selectionTap();
                    context.push(Routes.moodTrends);
                  },
                ),
              ),
              _verticalDivider(),
              // Streak pill
              Expanded(
                child: _StripPill(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: AppColors.streakOrange,
                  label: '$streakCount ${isEn ? "Streak" : "Seri"}',
                  isDark: isDark,
                  onTap: () {
                    HapticService.selectionTap();
                    context.push(Routes.streakStats);
                  },
                ),
              ),
              _verticalDivider(),
              // Entries pill
              Expanded(
                child: _StripPill(
                  icon: Icons.auto_stories_rounded,
                  iconColor: AppColors.amethyst,
                  label: '$entryCount ${isEn ? "Entries" : "Kayıt"}',
                  isDark: isDark,
                  onTap: () {
                    HapticService.selectionTap();
                    context.push(Routes.journalArchive);
                  },
                ),
              ),
              _verticalDivider(),
              // Mood count pill
              Expanded(
                child: _StripPill(
                  icon: Icons.mood_rounded,
                  iconColor: AppColors.chartPink,
                  label: _moodCountLabel(ref),
                  isDark: isDark,
                  onTap: () {
                    HapticService.selectionTap();
                    context.push(Routes.moodTrends);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 0.5,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: AppColors.textMuted.withValues(alpha: 0.15),
    );
  }

  String _moodCountLabel(WidgetRef ref) {
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final count = moodAsync.whenOrNull(
          data: (service) => service.getAllEntries().length,
        ) ??
        0;
    return L10nService.getWithParams('today.mood_stats.mood_count', isEn ? AppLanguage.en : AppLanguage.tr, params: {'count': '$count'});
  }

  String _moodLabel(int mood) {
    final lang = isEn ? AppLanguage.en : AppLanguage.tr;
    switch (mood) {
      case 1:
        return L10nService.get('today.mood_stats.mood_low', lang);
      case 2:
        return L10nService.get('today.mood_stats.mood_meh', lang);
      case 3:
        return L10nService.get('today.mood_stats.mood_okay', lang);
      case 4:
        return L10nService.get('today.mood_stats.mood_good', lang);
      case 5:
        return L10nService.get('today.mood_stats.mood_great', lang);
      default:
        return '';
    }
  }
}

class _StripPill extends StatelessWidget {
  final IconData? icon;
  final String? emoji;
  final Color? iconColor;
  final String label;
  final bool isDark;
  final bool showPulse;
  final VoidCallback onTap;

  const _StripPill({
    this.icon,
    this.emoji,
    this.iconColor,
    required this.label,
    required this.isDark,
    this.showPulse = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Semantics(
      button: true,
      label: label,
      child: TapScale(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (emoji != null)
              Text(emoji!, style: AppTypography.subtitle(fontSize: 18))
            else if (icon != null)
              Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: AppTypography.displayFont.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    if (showPulse) {
      content = content
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .tint(
            color: AppColors.starGold.withValues(alpha: 0.08),
            duration: 1500.ms,
          );
    }

    return content;
  }
}
