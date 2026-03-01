import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../../data/services/l10n_service.dart';

class OnThisDayBanner extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const OnThisDayBanner({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);
    return journalAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final language = AppLanguage.fromIsEn(isEn);
        final allEntries = service.getAllEntries();
        final now = DateTime.now();
        final onThisDayEntries = allEntries.where((e) {
          return e.date.month == now.month &&
              e.date.day == now.day &&
              e.date.year < now.year;
        }).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        if (onThisDayEntries.isEmpty) return const SizedBox.shrink();

        final yearsAgo = now.year - onThisDayEntries.first.date.year;
        final entry = onThisDayEntries.first;
        final areaLabel = entry.focusArea.localizedName(isEn);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Semantics(
            button: true,
            label: L10nService.get('today.on_this_day.view_memories_from_this_day', language),
            child: TapScale(
              onTap: () => context.push(Routes.memories),
              child: PremiumCard(
                style: PremiumCardStyle.amethyst,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.amethyst.withValues(alpha: 0.15),
                        border: Border.all(
                          color: AppColors.amethyst.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.overallRating}',
                          style: AppTypography.displayFont.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.amethyst,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn
                                ? 'On This Day — $yearsAgo year${yearsAgo == 1 ? '' : 's'} ago'
                                : 'Bugün Geçmişte — $yearsAgo yıl önce',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.displayFont.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            entry.note != null && entry.note!.isNotEmpty
                                ? entry.note!
                                : areaLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.decorativeScript(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          if (onThisDayEntries.length > 1) ...[
                            const SizedBox(height: 2),
                            Text(
                              isEn
                                  ? '+${onThisDayEntries.length - 1} more memories'
                                  : '+${onThisDayEntries.length - 1} anı daha',
                              style: AppTypography.elegantAccent(
                                fontSize: 12,
                                color: AppColors.amethyst,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Share nostalgia card
                    TapScale(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        final noteSnippet =
                            entry.note != null && entry.note!.isNotEmpty
                                ? '"${entry.note!.length > 80 ? '${entry.note!.substring(0, 80)}...' : entry.note!}"'
                                : areaLabel;
                        final shareText = isEn
                            ? '$yearsAgo year${yearsAgo == 1 ? '' : 's'} ago today, I wrote:\n\n$noteSnippet\n\n'
                              'Some things are worth remembering.\n'
                              '#InnerCycles #OnThisDay #Journaling'
                            : '$yearsAgo yıl önce bugün yazmışım:\n\n$noteSnippet\n\n'
                              'Bazı şeyler hatırlamaya değer.\n'
                              '#InnerCycles #BugünGeçmişte #Günlük';
                        SharePlus.instance.share(
                          ShareParams(text: shareText),
                        );
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.amethyst.withValues(alpha: 0.12),
                        ),
                        child: const Icon(
                          Icons.share_rounded,
                          size: 16,
                          color: AppColors.amethyst,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).glassEntrance(context: context);
      },
    );
  }
}
