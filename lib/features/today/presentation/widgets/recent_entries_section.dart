import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/common_strings.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../../data/services/l10n_service.dart';

class RecentEntriesSection extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const RecentEntriesSection({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  static const _focusAreaColors = {
    FocusArea.energy: AppColors.starGold,
    FocusArea.focus: AppColors.chartBlue,
    FocusArea.emotions: AppColors.chartPink,
    FocusArea.decisions: AppColors.chartGreen,
    FocusArea.social: AppColors.chartPurple,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);

    return journalAsync.maybeWhen(
      data: (service) {
        final language = AppLanguage.fromIsEn(isEn);
        final entries = service.getRecentEntries(5);
        if (entries.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradientText(
                      L10nService.get('today.recent_entries.recent_entries', language),
                      variant: GradientTextVariant.aurora,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Semantics(
                      label: L10nService.get('today.recent_entries.see_all_entries', language),
                      button: true,
                      child: GestureDetector(
                        onTap: () {
                          HapticService.selectionTap();
                          context.push(Routes.journalArchive);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 44),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              L10nService.get('today.recent_entries.see_all', language),
                              style: AppTypography.subtitle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.starGold
                                    : AppColors.lightStarGold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Horizontal scroll
              SizedBox(
                height: 135,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final accentColor =
                        _focusAreaColors[entry.focusArea] ?? AppColors.starGold;
                    final dateStr = _formatDate(entry.date);
                    final areaLabel = _focusAreaLabel(entry.focusArea);

                    return Semantics(
                      button: true,
                      label: isEn
                          ? 'View journal entry from $dateStr'
                          : '$dateStr tarihli günlük kaydını gör',
                      child: TapScale(
                        onTap: () {
                          HapticService.selectionTap();
                          context.push(Routes.journalEntryDetail.replaceFirst(':id', entry.id));
                        },
                        child: Container(
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: PremiumCard(
                            style: PremiumCardStyle.subtle,
                            showGradientBorder: false,
                            borderRadius: 16,
                            padding: EdgeInsets.zero,
                            child: Row(
                              children: [
                                // Focus area accent bar
                                Container(
                                  width: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        accentColor.withValues(alpha: 0.8),
                                        accentColor.withValues(alpha: 0.2),
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dateStr,
                                          style: AppTypography.elegantAccent(
                                            fontSize: 13,
                                            color: isDark
                                                ? AppColors.textMuted
                                                : AppColors.lightTextMuted,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: accentColor.withValues(
                                              alpha: 0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            areaLabel,
                                            style: AppTypography.modernAccent(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: accentColor,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: List.generate(5, (i) {
                                            final filled =
                                                i < entry.overallRating;
                                            return Container(
                                              width: 8,
                                              height: 8,
                                              margin: const EdgeInsets.only(
                                                right: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: filled
                                                    ? (isDark
                                                          ? AppColors.starGold
                                                          : AppColors
                                                                .lightStarGold)
                                                    : (isDark
                                                          ? Colors.white
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                )
                                                          : Colors.black
                                                                .withValues(
                                                                  alpha: 0.06,
                                                                )),
                                                boxShadow: filled
                                                    ? [
                                                        BoxShadow(
                                                          color: AppColors
                                                              .starGold
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                          blurRadius: 4,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).glassListItem(context: context, index: index);
                  },
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  String _formatDate(DateTime date) {
    final months = isEn
        ? CommonStrings.monthsShortEn
        : CommonStrings.monthsShortTr;
    return '${months[date.month - 1]} ${date.day}';
  }

  String _focusAreaLabel(FocusArea area) {
    final language = AppLanguage.fromIsEn(isEn);
    switch (area) {
      case FocusArea.energy:
        return L10nService.get('today.recent_entries.energy', language);
      case FocusArea.focus:
        return L10nService.get('today.recent_entries.focus', language);
      case FocusArea.emotions:
        return L10nService.get('today.recent_entries.emotions', language);
      case FocusArea.decisions:
        return L10nService.get('today.recent_entries.decisions', language);
      case FocusArea.social:
        return L10nService.get('today.recent_entries.social', language);
    }
  }
}
