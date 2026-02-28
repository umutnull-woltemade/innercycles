import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../data/models/life_event.dart';
import '../../../../data/content/life_event_presets.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../../data/services/l10n_service.dart';

class RecentLifeEventsSection extends ConsumerWidget {
  final AppLanguage language;
  bool get isEn => language.isEn;
  final bool isDark;

  const RecentLifeEventsSection({
    super.key,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(lifeEventServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final recentEvents = service.getRecentEvents(3);
        if (recentEvents.isEmpty) {
          return _buildRetentionPrompt(context);
        }

        final cutoff = DateTime.now().subtract(const Duration(days: 14));
        final recentEnough = recentEvents
            .where((e) => e.date.isAfter(cutoff))
            .toList();
        if (recentEnough.isEmpty) {
          return _buildRetentionPrompt(context);
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: GradientText(
                      L10nService.get('today.recent_life_events.recent_life_events', language),
                      variant: GradientTextVariant.amethyst,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Semantics(
                    button: true,
                    label: L10nService.get('today.recent_life_events.see_all_life_events', language),
                    child: GestureDetector(
                      onTap: () => context.push(Routes.lifeTimeline),
                      child: Text(
                        L10nService.get('today.recent_life_events.see_all', language),
                        style: AppTypography.subtitle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.starGold
                              : AppColors.lightStarGold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...() {
                final items = recentEnough.take(2).toList();
                return items.asMap().entries.map((mapEntry) {
                final index = mapEntry.key;
                final event = mapEntry.value;
                final isPositive = event.type == LifeEventType.positive;
                final preset = event.eventKey != null
                    ? LifeEventPresets.getByKey(event.eventKey!)
                    : null;
                final emoji =
                    preset?.emoji ?? (isPositive ? '\u{2728}' : '\u{1F4AD}');
                final isLastItem = index == items.length - 1;

                final emojiAccent = AppSymbol.accentForEmoji(emoji);
                return Semantics(
                  button: true,
                  label: isEn
                      ? 'View life event: ${event.title}'
                      : 'Yaşam olayını gör: ${event.title}',
                  child: TapScale(
                    onTap: () {
                      HapticService.buttonPress();
                      context.push(
                        Routes.lifeEventDetail.replaceFirst(':id', event.id),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: isLastItem
                            ? null
                            : Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? AppColors.textMuted.withValues(alpha: 0.12)
                                      : AppColors.lightTextMuted.withValues(alpha: 0.1),
                                  width: 0.5,
                                ),
                              ),
                      ),
                      child: Row(
                        children: [
                          // Left accent bar
                          Container(
                            width: 3,
                            height: 36,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  emojiAccent.withValues(alpha: 0.8),
                                  emojiAccent.withValues(alpha: 0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          AppSymbol(emoji, size: AppSymbolSize.sm),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: AppTypography.displayFont.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                if (event.emotionTags.isNotEmpty)
                                  Text(
                                    event.emotionTags.take(2).join(', '),
                                    style: AppTypography.elegantAccent(
                                      fontSize: 13,
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
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
              }(),
            ],
          ),
        ).glassEntrance(context: context, delay: 500.ms);
      },
    );
  }

  Widget _buildRetentionPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Semantics(
        button: true,
        label: L10nService.get('today.recent_life_events.record_a_life_event', language),
        child: TapScale(
          onTap: () {
            HapticService.buttonPress();
            context.push(Routes.lifeEventNew);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.starGold.withValues(alpha: 0.06)
                  : AppColors.starGold.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: isDark ? AppColors.starGold : AppColors.lightStarGold,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10nService.get('today.recent_life_events.any_big_moments_this_week', language),
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        L10nService.get('today.recent_life_events.record_a_life_event_1', language),
                        style: AppTypography.elegantAccent(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark ? AppColors.starGold : AppColors.lightStarGold,
                ),
              ],
            ),
          ),
        ),
      ),
    ).glassEntrance(context: context);
  }
}
