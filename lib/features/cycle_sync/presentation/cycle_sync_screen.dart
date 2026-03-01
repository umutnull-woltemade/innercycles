// ════════════════════════════════════════════════════════════════════════════
// CYCLE SYNC SCREEN - Hormonal × Emotional Pattern Dashboard
// ════════════════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../core/theme/liquid_glass/glass_animations.dart';
import '../../../core/theme/liquid_glass/glass_panel.dart';
import '../../../data/models/cycle_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../premium/presentation/contextual_paywall_modal.dart';
import '../../../data/services/l10n_service.dart';

class CycleSyncScreen extends ConsumerStatefulWidget {
  const CycleSyncScreen({super.key});

  @override
  ConsumerState<CycleSyncScreen> createState() => _CycleSyncScreenState();
}

class _CycleSyncScreenState extends ConsumerState<CycleSyncScreen> {
  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cycleSyncAsync = ref.watch(cycleSyncServiceProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: cycleSyncAsync.when(
            loading: () => const Center(child: CosmicLoadingIndicator()),
            error: (_, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    L10nService.get('cycle_sync.cycle_sync.couldnt_load_your_cycle_data', language),
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(cycleSyncServiceProvider),
                    icon: Icon(Icons.refresh_rounded,
                        size: 16, color: AppColors.starGold),
                    label: Text(
                      L10nService.get('cycle_sync.cycle_sync.retry', language),
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
            data: (cycleService) {
              return CupertinoScrollbar(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    GlassSliverAppBar(
                      title: L10nService.get('cycle_sync.cycle_sync.cycle_sync', language),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppConstants.spacingLg),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Cycle Day Indicator
                          _buildCycleDayCard(
                            context,
                            cycleService,
                            isDark,
                            isEn,
                          ).glassReveal(context: context),
                          const SizedBox(height: AppConstants.spacingLg),

                          // Phase Info Card
                          _buildPhaseCard(
                            context,
                            cycleService,
                            isDark,
                            isEn,
                          ).glassListItem(context: context, index: 1),
                          const SizedBox(height: AppConstants.spacingLg),

                          // Phase-Aware Prompt (PREMIUM)
                          if (cycleService.hasData)
                            _buildPremiumGate(
                              context,
                              isDark,
                              isEn,
                              isPremium,
                              paywallContext: PaywallContext.cycleSync,
                              child: _buildPhasePromptCard(
                                context,
                                cycleService,
                                isDark,
                                isEn,
                              ),
                            ).glassListItem(context: context, index: 2),
                          if (cycleService.hasData)
                            const SizedBox(height: AppConstants.spacingLg),

                          // Correlation Insight (PREMIUM)
                          _buildPremiumGate(
                            context,
                            isDark,
                            isEn,
                            isPremium,
                            paywallContext: PaywallContext.cycleSync,
                            child: _buildCorrelationCard(context, isDark, isEn),
                          ).glassListItem(context: context, index: 3),
                          const SizedBox(height: AppConstants.spacingLg),

                          // Phase Timeline
                          _buildPhaseTimeline(
                            context,
                            cycleService,
                            isDark,
                            isEn,
                          ).glassListItem(context: context, index: 4),
                          const SizedBox(height: AppConstants.spacingXl),
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
      floatingActionButton: _buildLogPeriodFab(context, isEn),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // CYCLE DAY INDICATOR
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildCycleDayCard(
    BuildContext context,
    dynamic cycleService,
    bool isDark,
    bool isEn,
  ) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    final cycleDay = cycleService.getCurrentCycleDay();
    final cycleLength = cycleService.getAverageCycleLength();
    final phase = cycleService.getCurrentPhase();

    if (!cycleService.hasData) {
      return GlassPanel(
        elevation: GlassElevation.g3,
        glowColor: AppColors.amethyst.withValues(alpha: 0.3),
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: Column(
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.favorite_border_rounded,
                size: 48,
                color: AppColors.amethyst,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            GradientText(
              L10nService.get('cycle_sync.cycle_sync.start_tracking_your_cycle', language),
              variant: GradientTextVariant.aurora,
              textAlign: TextAlign.center,
              style: AppTypography.displayFont.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              L10nService.get('cycle_sync.cycle_sync.log_your_period_to_see_how_your_emotiona', language),
              style: AppTypography.subtitle(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final progress = (cycleDay != null && cycleLength > 0)
        ? cycleDay / cycleLength
        : 0.0;
    final phaseColor = _phaseColor(phase);

    return Semantics(
      label: isEn
          ? 'Cycle day ${cycleDay ?? 0} of $cycleLength, ${phase != null ? phase.displayNameEn : "unknown"} phase'
          : 'Döngü günü ${cycleDay ?? 0} / $cycleLength, ${phase != null ? phase.displayNameTr : "bilinmiyor"} evresi',
      child: GlassPanel(
        elevation: GlassElevation.g3,
        glowColor: phaseColor.withValues(alpha: 0.3),
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        child: Column(
          children: [
            // Circular progress
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 8,
                      backgroundColor: isDark
                          ? AppColors.surfaceLight.withValues(alpha: 0.2)
                          : AppColors.lightSurfaceVariant,
                      valueColor: AlwaysStoppedAnimation(phaseColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        L10nService.get('cycle_sync.cycle_sync.day', language),
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      Text(
                        '${cycleDay ?? '-'}',
                        style: AppTypography.displayFont.copyWith(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: phaseColor,
                        ),
                      ),
                      Text(
                        L10nService.getWithParams('cycle_sync.of_cycle_length', language, params: {'count': '$cycleLength'}),
                        style: AppTypography.elegantAccent(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            if (phase != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: phaseColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  phase.localizedName(isEn),
                  style: AppTypography.modernAccent(
                    color: phaseColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            if (phase != null)
              Text(
                phase.localizedDescription(language),
                style: AppTypography.subtitle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PHASE INFO CARD
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPhaseCard(
    BuildContext context,
    dynamic cycleService,
    bool isDark,
    bool isEn,
  ) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    final daysUntil = cycleService.getDaysUntilNextPeriod();

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('cycle_sync.cycle_sync.cycle_overview', language),
            variant: GradientTextVariant.aurora,
            style: AppTypography.modernAccent(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoRow(
            context,
            Icons.calendar_today_rounded,
            L10nService.get('cycle_sync.cycle_sync.cycle_length', language),
            isEn
                ? '${cycleService.getAverageCycleLength()} days'
                : '${cycleService.getAverageCycleLength()} gün',
            isDark,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.water_drop_outlined,
            L10nService.get('cycle_sync.cycle_sync.period_length', language),
            isEn
                ? '${cycleService.getAveragePeriodLength()} days'
                : '${cycleService.getAveragePeriodLength()} gün',
            isDark,
          ),
          if (daysUntil != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.schedule_rounded,
              L10nService.get('cycle_sync.cycle_sync.next_period', language),
              L10nService.getWithParams('cycle_sync.in_n_days', language, params: {'count': '$daysUntil'}),
              isDark,
            ),
          ],
          if (cycleService.getAllLogs().length >= 2) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.insights_rounded,
              L10nService.get('cycle_sync.cycle_sync.cycles_logged', language),
              '${cycleService.getAllLogs().length}',
              isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
        ),
        const SizedBox(width: 12),
        Expanded(
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
        Text(
          value,
          style: AppTypography.modernAccent(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PHASE-AWARE PROMPT
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPhasePromptCard(
    BuildContext context,
    dynamic cycleService,
    bool isDark,
    bool isEn,
  ) {
    final phase = cycleService.getCurrentPhase();
    if (phase == null) return const SizedBox.shrink();

    final prompt = _getPhasePrompt(phase, isEn);
    final phaseColor = _phaseColor(phase);

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: phaseColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isEn
                    ? '${phase.displayNameEn} Phase Prompt'
                    : '${phase.displayNameTr} Evresi İpucu',
                style: AppTypography.modernAccent(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: phaseColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            prompt,
            style: AppTypography.subtitle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
              height: 1.5,
            ).copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  String _getPhasePrompt(CyclePhase phase, bool isEn) {
    // Date-rotated prompt
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    final prompts = _phasePrompts[phase] ?? _phasePrompts.values.first;
    if (prompts.isEmpty) return '';
    final index = dayOfYear % prompts.length;
    return isEn ? prompts[index].$1 : prompts[index].$2;
  }

  static const Map<CyclePhase, List<(String, String)>> _phasePrompts = {
    CyclePhase.menstrual: [
      (
        'What does your body need most right now?',
        'Bedenin şu an en çok neye ihtiyaç duyuyor?',
      ),
      (
        'What can you release during this rest phase?',
        'Bu dinlenme evresinde nelerden vazgeçebilirsin?',
      ),
      (
        'How do you feel about slowing down?',
        'Yavaşlamak hakkında ne hissediyorsun?',
      ),
    ],
    CyclePhase.follicular: [
      (
        'What new idea excites you right now?',
        'Şu an seni heyecanlandıran yeni bir fikir ne?',
      ),
      (
        'Your energy is rising — what will you channel it toward?',
        'Enerjin yükseliyor — onu neye yönlendireceksin?',
      ),
      (
        'What creative impulse have you been putting off?',
        'Ertelediğin yaratıcı bir dürtü var mı?',
      ),
    ],
    CyclePhase.ovulatory: [
      (
        'Who do you want to connect with today?',
        'Bugün kiminle bağlantı kurmak istiyorsun?',
      ),
      (
        'How will you use your peak social energy?',
        'Zirve sosyal enerjini nasıl kullanacaksın?',
      ),
      (
        'What conversation have you been avoiding?',
        'Hangi konuşmadan kaçınıyordun?',
      ),
    ],
    CyclePhase.luteal: [
      (
        'What feelings are surfacing as your energy turns inward?',
        'Enerjin içe dönerken hangi duygular yüzeye çıkıyor?',
      ),
      (
        'What patterns repeat at this point in your cycle?',
        'Döngünün bu noktasında hangi kalıplar tekrarlanıyor?',
      ),
      (
        'How can you be gentle with yourself during this phase?',
        'Bu evrede kendine nasıl nazik olabilirsin?',
      ),
    ],
  };

  // ═══════════════════════════════════════════════════════════════════════
  // CORRELATION INSIGHT
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildCorrelationCard(BuildContext context, bool isDark, bool isEn) {
    final correlationAsync = ref.watch(cycleCorrelationServiceProvider);

    return correlationAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (correlationService) {
        final language = isEn ? AppLanguage.en : AppLanguage.tr;
        final insight = correlationService.getCurrentPhaseInsight(isEn);
        if (insight == null) {
          return GlassPanel(
            elevation: GlassElevation.g2,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    L10nService.get('cycle_sync.cycle_sync.add_more_entries_to_surface_cycleemotion', language),
                    style: AppTypography.decorativeScript(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return GlassPanel(
          elevation: GlassElevation.g2,
          glowColor: AppColors.auroraStart.withValues(alpha: 0.2),
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: AppColors.auroraStart,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GradientText(
                    L10nService.get('cycle_sync.cycle_sync.cycle_insight', language),
                    variant: GradientTextVariant.aurora,
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                insight,
                style: AppTypography.subtitle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PHASE TIMELINE
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPhaseTimeline(
    BuildContext context,
    dynamic cycleService,
    bool isDark,
    bool isEn,
  ) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    final cycleLength = cycleService.getAverageCycleLength() as int;
    final currentDay = cycleService.getCurrentCycleDay() as int?;

    return GlassPanel(
      elevation: GlassElevation.g2,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            L10nService.get('cycle_sync.cycle_sync.phase_timeline', language),
            variant: GradientTextVariant.aurora,
            style: AppTypography.modernAccent(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Phase bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 32,
              child: Row(
                children: CyclePhase.values.map((phase) {
                  final fraction = _phaseFraction(
                    phase,
                    cycleLength,
                    cycleService.getAveragePeriodLength() as int,
                  );
                  return Expanded(
                    flex: (fraction * 100).round().clamp(1, 100),
                    child: Container(
                      color: _phaseColor(phase).withValues(alpha: 0.6),
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            isEn
                                ? phase.displayNameEn.substring(
                                    0,
                                    phase.displayNameEn.length.clamp(0, 3),
                                  )
                                : phase.displayNameTr.substring(
                                    0,
                                    phase.displayNameTr.length.clamp(0, 3),
                                  ),
                            style: AppTypography.modernAccent(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Current day marker
          if (currentDay != null && cycleLength > 0) ...[
            const SizedBox(height: 4),
            LayoutBuilder(
              builder: (context, constraints) {
                final markerX =
                    (currentDay / cycleLength) * constraints.maxWidth;
                return SizedBox(
                  height: 16,
                  child: Stack(
                    children: [
                      Positioned(
                        left: markerX.clamp(0, constraints.maxWidth - 8),
                        child: Icon(
                          Icons.arrow_drop_up_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 8),
          // Phase labels
          ...CyclePhase.values.map(
            (phase) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _phaseColor(phase),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    phase.localizedName(isEn),
                    style: AppTypography.subtitle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    phase.localizedDescription(language),
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _phaseFraction(CyclePhase phase, int cycleLength, int periodLength) {
    if (cycleLength <= 0) return 0.25;
    final follicularEnd = (cycleLength * 0.46).round();
    final ovulatoryEnd = (cycleLength * 0.57).round();

    switch (phase) {
      case CyclePhase.menstrual:
        return periodLength / cycleLength;
      case CyclePhase.follicular:
        return (follicularEnd - periodLength) / cycleLength;
      case CyclePhase.ovulatory:
        return (ovulatoryEnd - follicularEnd) / cycleLength;
      case CyclePhase.luteal:
        return (cycleLength - ovulatoryEnd) / cycleLength;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // LOG PERIOD FAB
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildLogPeriodFab(BuildContext context, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    return Semantics(
      label: L10nService.get('cycle_sync.cycle_sync.log_period_start', language),
      button: true,
      child: FloatingActionButton.extended(
        onPressed: () => _showLogPeriodSheet(context, isEn),
        backgroundColor: AppColors.amethyst,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.water_drop_rounded),
        label: Text(
          L10nService.get('cycle_sync.cycle_sync.log_period', language),
          style: AppTypography.modernAccent(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showLogPeriodSheet(BuildContext context, bool isEn) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? AppColors.deepSpace : Colors.white).withValues(
                alpha: isDark ? 0.85 : 0.92,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(
                  color: AppColors.auroraStart.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.auroraStart.withValues(alpha: 0.6),
                          AppColors.auroraEnd.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientText(
                    L10nService.get('cycle_sync.cycle_sync.log_period_start_1', language),
                    variant: GradientTextVariant.aurora,
                    style: AppTypography.modernAccent(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    L10nService.get('cycle_sync.cycle_sync.mark_today_as_the_start_of_your_period', language),
                    style: AppTypography.subtitle(
                      color: isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () async {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(ctx);
                      final service = await ref.read(
                        cycleSyncServiceProvider.future,
                      );
                      await service.logPeriodStart(date: DateTime.now());
                      ref.invalidate(cycleSyncServiceProvider);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.amethyst,
                            AppColors.cosmicAmethyst,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.amethyst.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        L10nService.get('cycle_sync.cycle_sync.period_started_today', language),
                        textAlign: TextAlign.center,
                        style: AppTypography.modernAccent(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      L10nService.get('cycle_sync.cycle_sync.cancel', language),
                      style: AppTypography.subtitle(
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PREMIUM GATE
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPremiumGate(
    BuildContext context,
    bool isDark,
    bool isEn,
    bool isPremium, {
    required Widget child,
    required PaywallContext paywallContext,
  }) {
    final language = isEn ? AppLanguage.en : AppLanguage.tr;
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 28, color: AppColors.starGold),
                  const SizedBox(height: 8),
                  Text(
                    L10nService.get('cycle_sync.cycle_sync.unlock_deeper_cycle_insights', language),
                    style: AppTypography.modernAccent(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GradientButton.gold(
                    label: L10nService.get('common.upgrade_to_pro', language),
                    onPressed: () => showContextualPaywall(
                      context,
                      ref,
                      paywallContext: paywallContext,
                    ),
                    expanded: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════

  Color _phaseColor(CyclePhase? phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return const Color(0xFFE57373); // Soft red
      case CyclePhase.follicular:
        return const Color(0xFF81C784); // Fresh green
      case CyclePhase.ovulatory:
        return AppColors.starGold;
      case CyclePhase.luteal:
        return AppColors.amethyst;
      case null:
        return AppColors.textMuted;
    }
  }
}
