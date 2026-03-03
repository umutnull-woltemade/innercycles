import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/affirmation_service.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../data/content/share_card_templates.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/share_card_sheet.dart';
import '../../../../shared/widgets/tap_scale.dart';

class DailyAffirmationCard extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const DailyAffirmationCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<DailyAffirmationCard> createState() =>
      _DailyAffirmationCardState();
}

class _DailyAffirmationCardState extends ConsumerState<DailyAffirmationCard> {
  bool _isFavorite = false;
  String? _currentId;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final affirmationAsync = ref.watch(affirmationServiceProvider);

    return affirmationAsync.maybeWhen(
      data: (service) {
        final affirmation = service.getDailyAffirmation();
        final text = affirmation.localizedText(language);

        // Sync favorite state
        if (_currentId != affirmation.id) {
          _currentId = affirmation.id;
          _isFavorite = service.isFavorite(affirmation.id);
        }

        final favCount = service.getFavorites().length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.subtle,
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: AppColors.starGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.isEn
                          ? 'Daily Affirmation'
                          : 'G\u{00FC}nl\u{00FC}k Olumlamalar',
                      style: AppTypography.elegantAccent(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: widget.isDark
                            ? AppColors.starGold.withValues(alpha: 0.6)
                            : AppColors.starGold.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    // Saved count badge (tap to view saved)
                    if (favCount > 0)
                      TapScale(
                        onTap: () {
                          HapticService.selectionTap();
                          _showSavedSheet(context, service, language);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.starGold.withValues(alpha: 0.1),
                          ),
                          child: Text(
                            '$favCount',
                            style: AppTypography.elegantAccent(
                              fontSize: 10,
                              color: AppColors.starGold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    // Favorite button
                    TapScale(
                      onTap: () async {
                        HapticService.buttonPress();
                        final nowFav =
                            await service.toggleFavorite(affirmation.id);
                        if (mounted) {
                          setState(() => _isFavorite = nowFav);
                        }
                      },
                      child: Icon(
                        _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 16,
                        color: _isFavorite
                            ? AppColors.starGold
                            : (widget.isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Share button
                    TapScale(
                      onTap: () {
                        HapticService.selectionTap();
                        final template = ShareCardTemplates.questionOfTheDay;
                        final cardData = ShareCardTemplates.buildData(
                          template: template,
                          language: language,
                          reflectionText: text,
                        );
                        ShareCardSheet.show(
                          context,
                          template: template,
                          data: cardData,
                          language: language,
                        );
                      },
                      child: Icon(
                        Icons.share_rounded,
                        size: 14,
                        color: widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTypography.decorativeScript(
                    fontSize: 15,
                    color: widget.isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  void _showSavedSheet(
    BuildContext context,
    AffirmationService service,
    AppLanguage language,
  ) {
    final favorites = service.getFavorites();
    if (favorites.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: widget.isDark
              ? AppColors.surfaceDark
              : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: (widget.isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted)
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 18,
                    color: AppColors.starGold,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.isEn
                        ? 'Saved Affirmations'
                        : 'Kaydedilen Olumlamalar',
                    style: AppTypography.modernAccent(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${favorites.length}',
                    style: AppTypography.elegantAccent(
                      fontSize: 13,
                      color: widget.isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: favorites.length,
                separatorBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    height: 1,
                    color: (widget.isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted)
                        .withValues(alpha: 0.1),
                  ),
                ),
                itemBuilder: (_, index) {
                  final aff = favorites[index];
                  return Text(
                    aff.localizedText(language),
                    style: AppTypography.decorativeScript(
                      fontSize: 14,
                      color: widget.isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
