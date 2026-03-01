import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/archetype_service.dart';
import '../../../../data/services/content_rotation_service.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../data/services/pattern_engine_service.dart';
import '../../../../shared/widgets/app_symbol.dart';
import '../../../../shared/widgets/gradient_text.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/tap_scale.dart';
import '../../../../data/services/l10n_service.dart';

class DailyPulseCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const DailyPulseCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  static const _focusAreaEmoji = {
    FocusArea.energy: '\u26A1',
    FocusArea.focus: '\uD83C\uDFAF',
    FocusArea.emotions: '\uD83D\uDC9C',
    FocusArea.decisions: '\uD83E\uDDED',
    FocusArea.social: '\uD83E\uDD1D',
  };

  static const _focusAreaColors = {
    FocusArea.energy: AppColors.starGold,
    FocusArea.focus: AppColors.chartBlue,
    FocusArea.emotions: AppColors.chartPink,
    FocusArea.decisions: AppColors.chartGreen,
    FocusArea.social: AppColors.chartPurple,
  };

  static const _focusAreaToPromptArea = {
    FocusArea.energy: 'energy',
    FocusArea.focus: 'productivity',
    FocusArea.emotions: 'mood',
    FocusArea.decisions: 'creativity',
    FocusArea.social: 'social',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsync = ref.watch(patternEngineServiceProvider);

    return engineAsync.maybeWhen(
      data: (engine) {
        final hasFull = engine.hasEnoughData();
        final hasMicro = engine.hasMicroPatternData();
        final averages = hasFull ? engine.getOverallAverages() : <FocusArea, double>{};

        // Build sections conditionally
        final focusPulseWidget = _buildFocusPulse(context, averages);
        final insightWidget = _buildInsight(context, ref, engine, hasFull, hasMicro);
        final promptWidget = _buildPrompt(context, engine, hasFull, averages);

        // If nothing to show, collapse
        if (focusPulseWidget == null && insightWidget == null && promptWidget == null) {
          // Show D0 archetype insight as standalone
          return _buildArchetypeOnlyCard(context, ref);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PremiumCard(
            style: PremiumCardStyle.aurora,
            showInnerShadow: false,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (focusPulseWidget != null) ...[
                  focusPulseWidget,
                ],
                if (focusPulseWidget != null && insightWidget != null)
                  _goldDivider(),
                if (insightWidget != null) ...[
                  insightWidget,
                ],
                if (insightWidget != null && promptWidget != null)
                  _goldDivider(),
                if (promptWidget != null) ...[
                  promptWidget,
                ],
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _goldDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 0.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              (isDark ? AppColors.starGold : AppColors.lightStarGold)
                  .withValues(alpha: 0.15),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  // ── FOCUS PULSE (compact circles) ──
  Widget? _buildFocusPulse(BuildContext context, Map<FocusArea, double> averages) {
    if (averages.isEmpty) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GradientText(
              L10nService.get('today.daily_pulse.focus_pulse', isEn ? AppLanguage.en : AppLanguage.tr),
              variant: GradientTextVariant.gold,
              style: AppTypography.displayFont.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const Spacer(),
            Semantics(
              button: true,
              label: L10nService.get('today.daily_pulse.view_details', isEn ? AppLanguage.en : AppLanguage.tr),
              child: GestureDetector(
                onTap: () {
                  HapticService.selectionTap();
                  context.push(Routes.moodTrends);
                },
                behavior: HitTestBehavior.opaque,
                child: Text(
                  L10nService.get('today.daily_pulse.details', isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.subtitle(
                    fontSize: 13,
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
        SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: averages.entries.toList().asMap().entries.map((mapEntry) {
              final i = mapEntry.key;
              final entry = mapEntry.value;
              final area = entry.key;
              final score = entry.value;
              final color = _focusAreaColors[area] ?? AppColors.starGold;
              final emoji = _focusAreaEmoji[area] ?? '\u2728';

              return TapScale(
                onTap: () {
                  HapticService.selectionTap();
                  context.push(Routes.moodTrends);
                },
                child: SizedBox(
                  width: 56,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: CircularProgressIndicator(
                                value: (score / 5.0).clamp(0.0, 1.0),
                                strokeWidth: 2.5,
                                strokeCap: StrokeCap.round,
                                backgroundColor: isDark
                                    ? AppColors.textMuted.withValues(alpha: 0.12)
                                    : AppColors.lightTextMuted.withValues(alpha: 0.1),
                                valueColor: AlwaysStoppedAnimation(color),
                              ),
                            ),
                            AppSymbol.inline(emoji),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _areaLabel(area),
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    delay: Duration(milliseconds: i * 80),
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(
                    delay: Duration(milliseconds: i * 80),
                    duration: 300.ms,
                  );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── INSIGHT ──
  Widget? _buildInsight(
    BuildContext context,
    WidgetRef ref,
    PatternEngineService engine,
    bool hasFull,
    bool hasMicro,
  ) {
    String? text;
    IconData icon = Icons.lightbulb_outline;

    if (hasFull) {
      final trends = engine.detectTrends();
      if (trends.isNotEmpty) {
        final best = trends.reduce(
          (a, b) => a.changePercent.abs() > b.changePercent.abs() ? a : b,
        );
        text = isEn ? best.getMessageEn() : best.getMessageTr();
      }
    } else if (hasMicro) {
      final micro = engine.detectMicroPattern(isEn: isEn);
      if (micro != null) {
        text = micro;
        icon = Icons.insights_outlined;
      }
    }

    if (text == null) return null;

    return Semantics(
      button: true,
      label: text,
      child: TapScale(
        onTap: () {
          HapticService.buttonPress();
          context.go(Routes.moodTrends);
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: AppTypography.decorativeScript(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
            ),
          ],
        ),
      ),
    );
  }

  // ── PERSONALIZED PROMPT ──
  Widget? _buildPrompt(
    BuildContext context,
    PatternEngineService engine,
    bool hasFull,
    Map<FocusArea, double> averages,
  ) {
    if (!hasFull || averages.isEmpty) return null;

    FocusArea weakestArea = averages.keys.first;
    double lowestScore = averages.values.first;
    for (final entry in averages.entries) {
      if (entry.value < lowestScore) {
        lowestScore = entry.value;
        weakestArea = entry.key;
      }
    }

    final promptArea = _focusAreaToPromptArea[weakestArea] ?? 'mood';
    final prompt = ContentRotationService.getDailyPrompt(
      weakestArea: promptArea,
    );

    final areaName = weakestArea.name;
    final areaLabel = isEn
        ? areaName[0].toUpperCase() + areaName.substring(1)
        : _turkishLabel(areaName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.tips_and_updates_outlined,
              size: 14,
              color: AppColors.amethyst,
            ),
            const SizedBox(width: 6),
            GradientText(
              L10nService.getWithParams('today.daily_pulse.try_for_area', isEn ? AppLanguage.en : AppLanguage.tr, params: {'area': areaLabel}),
              variant: GradientTextVariant.amethyst,
              style: AppTypography.elegantAccent(
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          prompt.localizedPrompt(isEn ? AppLanguage.en : AppLanguage.tr),
          style: AppTypography.decorativeScript(
            fontSize: 14,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  // ── D0 ARCHETYPE CARD (when no pattern data) ──
  Widget _buildArchetypeOnlyCard(BuildContext context, WidgetRef ref) {
    final archetypeAsync = ref.watch(archetypeServiceProvider);
    return archetypeAsync.maybeWhen(
      data: (archetypeService) {
        String text;
        IconData icon;
        final history = archetypeService.getArchetypeHistory();
        if (history.isEmpty) {
          icon = Icons.auto_awesome_outlined;
          text = L10nService.get('today.daily_pulse.each_entry_builds_your_pattern_library_s', isEn ? AppLanguage.en : AppLanguage.tr);
        } else {
          icon = Icons.psychology_outlined;
          final latestId = history.last.archetypeId;
          final archetype = ArchetypeService.archetypes.firstWhere(
            (a) => a.id == latestId,
            orElse: () => ArchetypeService.archetypes.first,
          );
          final tip = archetype.getGrowthTip(isEnglish: isEn);
          text = '${archetype.getName(isEnglish: isEn)}: $tip';
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Semantics(
            label: text,
            button: true,
            child: GestureDetector(
              onTap: () {
                HapticService.buttonPress();
                context.go(Routes.moodTrends);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: isDark
                          ? AppColors.starGold
                          : AppColors.lightStarGold,
                      width: 3,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: isDark
                          ? AppColors.starGold
                          : AppColors.lightStarGold,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
          ),
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  String _areaLabel(FocusArea area) {
    switch (area) {
      case FocusArea.energy:
        return L10nService.get('today.daily_pulse.energy', isEn ? AppLanguage.en : AppLanguage.tr);
      case FocusArea.focus:
        return L10nService.get('today.daily_pulse.focus', isEn ? AppLanguage.en : AppLanguage.tr);
      case FocusArea.emotions:
        return L10nService.get('today.daily_pulse.emotions', isEn ? AppLanguage.en : AppLanguage.tr);
      case FocusArea.decisions:
        return L10nService.get('today.daily_pulse.decisions', isEn ? AppLanguage.en : AppLanguage.tr);
      case FocusArea.social:
        return L10nService.get('today.daily_pulse.social', isEn ? AppLanguage.en : AppLanguage.tr);
    }
  }

  String _turkishLabel(String area) {
    switch (area) {
      case 'energy':
        return 'Enerji';
      case 'focus':
        return 'Odak';
      case 'emotions':
        return 'Duygular';
      case 'decisions':
        return 'Kararlar';
      case 'social':
        return 'Sosyal';
      default:
        return area;
    }
  }
}
