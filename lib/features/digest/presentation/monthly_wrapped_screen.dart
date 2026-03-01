// ════════════════════════════════════════════════════════════════════════════
// MONTHLY WRAPPED SCREEN - Story-style monthly summary (5 slides)
// ════════════════════════════════════════════════════════════════════════════
// Slide 1: Total entries + avg rating
// Slide 2: Dominant focus area
// Slide 3: Best day + streak peak
// Slide 4: Personal insight
// Slide 5: Shareable summary card
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../data/services/monthly_wrapped_service.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/content/share_card_templates.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/share_card_sheet.dart';
import '../../../data/services/l10n_service.dart';

class MonthlyWrappedScreen extends ConsumerStatefulWidget {
  const MonthlyWrappedScreen({super.key});

  @override
  ConsumerState<MonthlyWrappedScreen> createState() =>
      _MonthlyWrappedScreenState();
}

class _MonthlyWrappedScreenState extends ConsumerState<MonthlyWrappedScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wrappedAsync = ref.watch(monthlyWrappedServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: wrappedAsync.when(
            loading: () => const Center(child: CosmicLoadingIndicator()),
            error: (_, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      L10nService.get('digest.monthly_wrapped.keep_journaling_to_build_your_monthly_st', language),
                      textAlign: TextAlign.center,
                      style: AppTypography.subtitle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(monthlyWrappedServiceProvider),
                    icon: Icon(Icons.refresh_rounded,
                        size: 16, color: AppColors.starGold),
                    label: Text(
                      L10nService.get('digest.monthly_wrapped.retry', language),
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
            data: (service) {
              final now = DateTime.now();
              // Show last month's data
              final targetMonth = now.month == 1 ? 12 : now.month - 1;
              final targetYear = now.month == 1 ? now.year - 1 : now.year;
              final data = service.generateWrapped(targetYear, targetMonth);

              if (data == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppSymbol('\u{1F4CA}', size: AppSymbolSize.xl),
                        const SizedBox(height: 16),
                        Text(
                          L10nService.get('digest.monthly_wrapped.keep_journaling_your_monthly_wrapped_wil', language),
                          textAlign: TextAlign.center,
                          style: AppTypography.decorativeScript(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(L10nService.get('digest.monthly_wrapped.go_back', language)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // Page indicator
                  Semantics(
                    label:
                        '${L10nService.get('digest.monthly_wrapped.slide', language)} ${_currentPage + 1} / 5',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      child: Row(
                        children: List.generate(5, (i) {
                          final isActive = i <= _currentPage;
                          return Expanded(
                            child: Container(
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: isActive
                                    ? AppColors.starGold
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.1)
                                          : Colors.black.withValues(
                                              alpha: 0.08,
                                            )),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        tooltip: L10nService.get('digest.monthly_wrapped.close', language),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (page) =>
                          setState(() => _currentPage = page),
                      children: [
                        _Slide1Entries(data: data, isEn: isEn, isDark: isDark),
                        _Slide2Focus(data: data, isEn: isEn, isDark: isDark),
                        _Slide3BestDay(data: data, isEn: isEn, isDark: isDark),
                        _Slide4Insight(data: data, isEn: isEn, isDark: isDark),
                        _Slide5Share(data: data, isEn: isEn, isDark: isDark),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SLIDES
// ════════════════════════════════════════════════════════════════════════════

class _Slide1Entries extends StatelessWidget {
  final MonthlyWrappedData data;
  final bool isEn;
  final bool isDark;

  const _Slide1Entries({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      emoji: '\u{1F4DD}',
      title: isEn
          ? '${data.totalEntries} entries this month'
          : 'Bu ay ${data.totalEntries} kayıt',
      subtitle: isEn
          ? 'Average rating: ${data.avgRating.toStringAsFixed(1)} / 5'
          : 'Ortalama puan: ${data.avgRating.toStringAsFixed(1)} / 5',
      isDark: isDark,
    );
  }
}

class _Slide2Focus extends StatelessWidget {
  final MonthlyWrappedData data;
  final bool isEn;
  final bool isDark;

  const _Slide2Focus({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  String _areaName(FocusArea? area, bool isEn) {
    final language = AppLanguage.fromIsEn(isEn);
    if (area == null) return L10nService.get('digest.monthly_wrapped.balanced', language);
    return area.localizedName(isEn);
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return _SlideBase(
      emoji: '\u{1F3AF}',
      title: isEn
          ? 'You focused most on ${_areaName(data.dominantArea, true)}'
          : 'En çok ${_areaName(data.dominantArea, false)} odağındaydın',
      subtitle: L10nService.get('digest.monthly_wrapped.this_area_drew_your_attention_more_than', language),
      isDark: isDark,
    );
  }
}

class _Slide3BestDay extends StatelessWidget {
  final MonthlyWrappedData data;
  final bool isEn;
  final bool isDark;

  const _Slide3BestDay({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      emoji: '\u{1F525}',
      title: isEn
          ? '${data.bestDayOfWeek}s were your best days'
          : '${data.bestDayOfWeek} günlerin en iyi günlerindi',
      subtitle: isEn
          ? 'Longest streak this month: ${data.streakPeak} days'
          : 'Bu ayki en uzun seri: ${data.streakPeak} gün',
      isDark: isDark,
    );
  }
}

class _Slide4Insight extends StatelessWidget {
  final MonthlyWrappedData data;
  final bool isEn;
  final bool isDark;

  const _Slide4Insight({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return _SlideBase(
      emoji: '\u{1F4A1}',
      title: data.personalInsight(isEn),
      subtitle: L10nService.get('digest.monthly_wrapped.based_on_your_monthly_patterns', language),
      isDark: isDark,
    );
  }
}

class _Slide5Share extends StatelessWidget {
  final MonthlyWrappedData data;
  final bool isEn;
  final bool isDark;

  const _Slide5Share({
    required this.data,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(isEn);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSymbol.hero('\u{2728}').animate().scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1, 1),
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 24),
          GradientText(
            L10nService.get('digest.monthly_wrapped.your_month_at_a_glance', language),
            variant: GradientTextVariant.gold,
            style: AppTypography.displayFont.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 32),
          GradientButton.gold(
            label: L10nService.get('digest.monthly_wrapped.share_your_month', language),
            icon: Icons.share_rounded,
            onPressed: () {
              final template = ShareCardTemplates.monthlyWrapped;
              final cardData = ShareCardTemplates.buildData(
                template: template,
                isEn: isEn,
                journalDays: data.totalEntries,
                moodValues: data.dailyRatings.where((r) => r > 0).toList(),
              );
              ShareCardSheet.show(
                context,
                template: template,
                data: cardData,
                isEn: isEn,
              );
            },
            expanded: true,
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SLIDE BASE
// ════════════════════════════════════════════════════════════════════════════

class _SlideBase extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool isDark;

  const _SlideBase({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSymbol.hero(emoji).animate().scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1, 1),
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 32),
          GradientText(
            title,
            variant: GradientTextVariant.gold,
            textAlign: TextAlign.center,
            style: AppTypography.displayFont.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.decorativeScript(
              fontSize: 16,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
