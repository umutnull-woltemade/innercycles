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
import '../../../data/content/monthly_themes_content.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/first_taste_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../data/services/pattern_engine_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../core/theme/app_typography.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/services/smart_router_service.dart';
import '../../../data/services/ecosystem_analytics_service.dart';
import '../../../data/services/review_service.dart';
import '../../../data/services/l10n_service.dart';

class MonthlyReflectionScreen extends ConsumerStatefulWidget {
  const MonthlyReflectionScreen({super.key});

  @override
  ConsumerState<MonthlyReflectionScreen> createState() =>
      _MonthlyReflectionScreenState();
}

class _MonthlyReflectionScreenState
    extends ConsumerState<MonthlyReflectionScreen> {
  late int _selectedYear;
  late int _selectedMonth;
  bool _firstTasteRecorded = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(smartRouterServiceProvider)
          .whenData((s) => s.recordToolVisit('monthlyReflection'));
      ref
          .read(ecosystemAnalyticsServiceProvider)
          .whenData(
            (s) => s.trackToolOpen('monthlyReflection', source: 'direct'),
          );
      // Prompt for App Store review after viewing monthly report
      ref.read(reviewServiceProvider.future).then((reviewService) {
        reviewService.checkAndPromptReview(ReviewTrigger.monthlyReport);
      }).catchError((_) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final engineAsync = ref.watch(patternEngineServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);
    final firstTasteAsync = ref.watch(firstTasteServiceProvider);

    // Determine if deep content (theme + breakdown) should be visible
    final firstTasteService = firstTasteAsync.whenOrNull(data: (s) => s);
    final allowFree =
        firstTasteService?.shouldAllowFree(FirstTasteFeature.monthlyReport) ??
        false;
    final showDeepContent = isPremium || allowFree;

    // Record first taste on first view of deep content
    if (showDeepContent &&
        !isPremium &&
        !_firstTasteRecorded &&
        firstTasteService != null) {
      _firstTasteRecorded = true;
      firstTasteService.recordUse(FirstTasteFeature.monthlyReport);
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: engineAsync.when(
            loading: () => const CosmicLoadingIndicator(),
            error: (_, _) => Center(
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
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () =>
                          ref.invalidate(patternEngineServiceProvider),
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: 16,
                        color: AppColors.starGold,
                      ),
                      label: Text(
                        L10nService.get('journal.monthly_reflection.retry', language),
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
            data: (engine) {
              final summary = engine.getMonthSummary(
                _selectedYear,
                _selectedMonth,
              );

              return CupertinoScrollbar(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    GlassSliverAppBar(
                      title: L10nService.get('journal.monthly_reflection.monthly_reflection', language),
                      actions: [
                        if (summary.totalEntries > 0)
                          IconButton(
                            onPressed: () {
                              HapticService.buttonPress();
                              final monthNames = isEn
                                  ? CommonStrings.monthsShortEn
                                  : CommonStrings.monthsShortTr;
                              final monthLabel = monthNames[_selectedMonth - 1];
                              final strongestArea = summary.strongestArea;
                              final strongest = strongestArea != null
                                  ? (strongestArea.localizedName(language))
                                  : null;
                              final msg = isEn
                                  ? 'My $monthLabel $_selectedYear reflection:\n${summary.totalEntries} entries${strongest != null ? '\nStrongest area: $strongest' : ''}\n\nTracking my patterns with InnerCycles.\n${AppConstants.appStoreUrl}\n#InnerCycles #MonthlyReflection'
                                  : '$monthLabel $_selectedYear yansımam:\n${summary.totalEntries} kayıt${strongest != null ? '\nEn güçlü alan: $strongest' : ''}\n\nInnerCycles ile örüntülerimi takip ediyorum.\n${AppConstants.appStoreUrl}\n#InnerCycles';
                              SharePlus.instance.share(ShareParams(text: msg));
                            },
                            icon: Icon(
                              Icons.share_rounded,
                              color: AppColors.starGold,
                              size: 20,
                            ),
                            tooltip: L10nService.get('journal.monthly_reflection.share_monthly_summary', language),
                          ),
                      ],
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Month selector
                          _buildMonthSelector(context, isDark, isEn),
                          const SizedBox(height: AppConstants.spacingXl),

                          // Summary card — always visible
                          _buildSummaryCard(
                            context,
                            summary,
                            isDark,
                            isEn,
                          ).animate().fadeIn(duration: 400.ms),
                          const SizedBox(height: AppConstants.spacingLg),

                          // Monthly theme — gated
                          if (showDeepContent)
                            _buildMonthlyThemeCard(
                              context,
                              _selectedMonth,
                              isDark,
                              isEn,
                            ).animate().fadeIn(delay: 50.ms, duration: 400.ms)
                          else
                            _buildPremiumBlurOverlay(
                              child: _buildMonthlyThemeCard(
                                context,
                                _selectedMonth,
                                isDark,
                                isEn,
                              ),
                              isDark: isDark,
                              isEn: isEn,
                            ).animate().fadeIn(delay: 50.ms, duration: 400.ms),
                          const SizedBox(height: AppConstants.spacingLg),

                          // Area breakdown — gated
                          if (summary.averagesByArea.isNotEmpty)
                            if (showDeepContent)
                              _buildAreaBreakdown(
                                context,
                                summary,
                                isDark,
                                isEn,
                              ).animate().fadeIn(
                                delay: 100.ms,
                                duration: 400.ms,
                              )
                            else
                              _buildPremiumBlurOverlay(
                                child: _buildAreaBreakdown(
                                  context,
                                  summary,
                                  isDark,
                                  isEn,
                                ),
                                isDark: isDark,
                                isEn: isEn,
                              ).animate().fadeIn(
                                delay: 100.ms,
                                duration: 400.ms,
                              ),
                          ContentDisclaimer(language: language),
                          const SizedBox(height: 40),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBlurOverlay({
    required Widget child,
    required bool isDark,
    required bool isEn,
  }) {
    final language = AppLanguage.fromIsEn(isEn);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Stack(
        children: [
          ExcludeSemantics(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: child,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (isDark ? Colors.black : Colors.white).withValues(
                      alpha: 0.7,
                    ),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: AppColors.starGold,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    GradientText(
                      L10nService.get('journal.monthly_reflection.access_your_full_monthly_report', language),
                      variant: GradientTextVariant.gold,
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GradientButton.gold(
                      label: L10nService.get('journal.monthly_reflection.see_full_report', language),
                      onPressed: () => showContextualPaywall(
                        context,
                        ref,
                        paywallContext: PaywallContext.monthlyReport,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context, bool isDark, bool isEn) {
    final language = AppLanguage.fromIsEn(isEn);
    final months = isEn
        ? [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ]
        : [
            'Ocak',
            'Şubat',
            'Mart',
            'Nisan',
            'Mayıs',
            'Haziran',
            'Temmuz',
            'Ağustos',
            'Eylül',
            'Ekim',
            'Kasım',
            'Aralık',
          ];

    return PremiumCard(
      style: PremiumCardStyle.gold,
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingMd,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedMonth--;
                if (_selectedMonth < 1) {
                  _selectedMonth = 12;
                  _selectedYear--;
                }
              });
            },
            tooltip: L10nService.get('journal.monthly_reflection.previous_month', language),
            icon: Icon(
              Icons.chevron_left,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Expanded(
            child: GradientText(
              '${months[_selectedMonth - 1]} $_selectedYear',
              variant: GradientTextVariant.gold,
              textAlign: TextAlign.center,
              style: AppTypography.displayFont.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final now = DateTime.now();
              if (_selectedYear < now.year ||
                  (_selectedYear == now.year && _selectedMonth < now.month)) {
                setState(() {
                  _selectedMonth++;
                  if (_selectedMonth > 12) {
                    _selectedMonth = 1;
                    _selectedYear++;
                  }
                });
              }
            },
            tooltip: L10nService.get('journal.monthly_reflection.next_month', language),
            icon: Icon(
              Icons.chevron_right,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    MonthlySummary summary,
    bool isDark,
    bool isEn,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        children: [
          // Entry count
          Row(
            children: [
              Icon(Icons.edit_note, color: AppColors.starGold, size: 24),
              const SizedBox(width: 12),
              Text(
                isEn
                    ? '${summary.totalEntries} entries this month'
                    : 'Bu ay ${summary.totalEntries} kayıt',
                style: AppTypography.modernAccent(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          if (summary.totalEntries == 0) ...[
            const SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 48,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
                const SizedBox(height: 12),
                Text(
                  L10nService.get('journal.monthly_reflection.this_month_is_waiting_for_your_first_ref', language),
                  style: AppTypography.decorativeScript(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go(Routes.journal),
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    L10nService.get('journal.monthly_reflection.write_your_first_entry', language),
                    style: AppTypography.modernAccent(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.starGold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (summary.strongestArea != null) ...[
            const SizedBox(height: AppConstants.spacingLg),
            _buildHighlight(
              context,
              isDark,
              L10nService.get('journal.monthly_reflection.strongest_area', language),
              summary.strongestArea?.localizedName(language) ?? '',
              Icons.star,
              AppColors.success,
            ),
          ],
          if (summary.weakestArea != null &&
              summary.weakestArea != summary.strongestArea) ...[
            const SizedBox(height: AppConstants.spacingMd),
            _buildHighlight(
              context,
              isDark,
              L10nService.get('journal.monthly_reflection.needs_attention', language),
              summary.weakestArea?.localizedName(language) ?? '',
              Icons.info_outline,
              AppColors.warning,
            ),
          ],
          const SizedBox(height: AppConstants.spacingMd),
          _buildHighlight(
            context,
            isDark,
            L10nService.get('journal.monthly_reflection.current_streak', language),
            isEn
                ? '${summary.currentStreak} days'
                : '${summary.currentStreak} gün',
            Icons.local_fire_department,
            AppColors.starGold,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlight(
    BuildContext context,
    bool isDark,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: AppTypography.subtitle(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.displayFont.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyThemeCard(
    BuildContext context,
    int month,
    bool isDark,
    bool isEn,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    final theme = allMonthlyThemes.firstWhere(
      (t) => t.month == month,
      orElse: () => allMonthlyThemes.first,
    );

    final lang = language;
    final prompts = theme.localizedWeeklyPrompts(lang);
    final tip = theme.localizedWellnessTip(lang);

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.auroraStart, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: GradientText(
                  theme.localizedThemeName(lang),
                  variant: GradientTextVariant.aurora,
                  style: AppTypography.elegantAccent(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            theme.localizedDescription(lang),
            style: AppTypography.decorativeScript(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            L10nService.get('journal.monthly_reflection.weekly_prompts', language),
            style: AppTypography.elegantAccent(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(prompts.length, (i) {
            final language = AppLanguage.fromIsEn(isEn);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${L10nService.get('common.week_abbr', language)}${i + 1}',
                    style: AppTypography.modernAccent(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.starGold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      prompts[i],
                      style: AppTypography.decorativeScript(
                        fontSize: 13,
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.starGold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.spa_outlined, size: 16, color: AppColors.starGold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTypography.decorativeScript(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaBreakdown(
    BuildContext context,
    MonthlySummary summary,
    bool isDark,
    bool isEn,
  ) {
    final language = AppLanguage.fromIsEn(isEn);
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('journal.monthly_reflection.area_breakdown', language),
            variant: GradientTextVariant.gold,
            style: AppTypography.elegantAccent(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...summary.averagesByArea.entries.map((e) {
            final label = e.key.localizedName(language);
            return Semantics(
              label: isEn
                  ? '$label: ${e.value.toStringAsFixed(1)} out of 5'
                  : '$label: 5 üzerinden ${e.value.toStringAsFixed(1)}',
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ExcludeSemantics(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(
                          label,
                          style: AppTypography.subtitle(
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
                            value: e.value / 5,
                            backgroundColor: isDark
                                ? AppColors.surfaceLight.withValues(alpha: 0.3)
                                : AppColors.lightSurfaceVariant,
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.starGold,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        e.value.toStringAsFixed(1),
                        style: AppTypography.modernAccent(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.starGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
