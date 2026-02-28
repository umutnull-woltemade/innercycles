import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/analytics_service.dart';
import '../../../data/services/paywall_experiment_service.dart';
import '../../../data/services/paywall_service.dart';
import '../../../data/services/premium_service.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../data/services/l10n_service.dart';

/// The type of contextual paywall to show — each has unique visuals and copy.
enum PaywallContext {
  patterns,
  dreams,
  streakFreeze,
  monthlyReport,
  export,
  adRemoval,
  programs,
  challenges,
  cycleSync,
  shadowWork,
  general,
}

/// Shows a contextual paywall bottom sheet tailored to what the user just tried
/// to do. Returns true if user purchased, false otherwise.
///
/// Respects the A/B timing gate from [PaywallExperimentService]:
/// - `immediate`: always shows
/// - `firstInsight`: shows only after user has enough journal data for insights
/// - `delayed`: shows only after session 3+
///
/// Set [bypassTimingGate] to true for explicit user-initiated paywall views
/// (e.g. tapping "Premium" in settings).
Future<bool> showContextualPaywall(
  BuildContext context,
  WidgetRef ref, {
  required PaywallContext paywallContext,
  int? entryCount,
  int? streakDays,
  bool bypassTimingGate = false,
}) async {
  // Skip timing gate for explicit user actions (settings, premium button)
  if (!bypassTimingGate) {
    try {
      final experiment = await ref.read(paywallExperimentProvider.future);
      final journalService = await ref.read(journalServiceProvider.future);
      final hasInsight = journalService.entryCount >= 5;

      if (!experiment.shouldShowPaywall(hasGeneratedInsight: hasInsight)) {
        return false; // Timing says "not yet" — silently skip
      }

      // Adaptive telemetry gate: if user dismisses >80% of paywalls, skip
      final telemetry = await ref.read(telemetryServiceProvider.future);
      if (telemetry.shouldDelayPaywall) {
        return false; // User is paywall-fatigued — back off
      }
    } catch (_) {
      // If experiment service fails, default to showing paywall
    }
  }

  // ignore: use_build_context_synchronously
  if (!context.mounted) return false;

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ContextualPaywallSheet(
      paywallContext: paywallContext,
      entryCount: entryCount,
      streakDays: streakDays,
    ),
  );
  return result ?? false;
}

class _ContextualPaywallSheet extends ConsumerStatefulWidget {
  final PaywallContext paywallContext;
  final int? entryCount;
  final int? streakDays;

  const _ContextualPaywallSheet({
    required this.paywallContext,
    this.entryCount,
    this.streakDays,
  });

  @override
  ConsumerState<_ContextualPaywallSheet> createState() =>
      _ContextualPaywallSheetState();
}

class _ContextualPaywallSheetState
    extends ConsumerState<_ContextualPaywallSheet> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logEvent('contextual_paywall_shown', {
      'context': widget.paywallContext.name,
    });
    // Log experiment-aware paywall view
    final experiment = ref
        .read(paywallExperimentProvider)
        .whenOrNull(data: (e) => e);
    experiment?.logPaywallView();
    // Track telemetry for adaptive paywall gate
    ref.read(telemetryServiceProvider).whenData((t) {
      t.paywallShown(
        triggerPoint: widget.paywallContext.name,
        entriesCount: widget.entryCount ?? 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final config = _getConfig(isEn);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.cosmicPurple.withValues(alpha: 0.95),
                AppColors.deepSpace.withValues(alpha: 0.98),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(
                color: AppColors.starGold.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          config.accentColor.withValues(alpha: 0.3),
                          config.accentColor.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      config.icon,
                      size: 40,
                      color: config.accentColor,
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 20),

                  // Headline
                  Text(
                    config.headline,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayFont.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    config.subtitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.decorativeScript(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                  const SizedBox(height: 8),

                  // Contextual detail (e.g. entry count, streak days)
                  if (config.detail != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: config.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: config.accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        config.detail!,
                        style: AppTypography.elegantAccent(
                          fontSize: 13,
                          letterSpacing: 0.5,
                          color: config.accentColor,
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
                  ],

                  const SizedBox(height: 16),

                  // Social proof
                  _buildSocialProof(
                    isEn,
                  ).animate().fadeIn(duration: 400.ms, delay: 270.ms),

                  const SizedBox(height: 16),

                  // Dynamic value recap
                  _buildValueRecap(
                    isEn,
                    config.accentColor,
                  ).animate().fadeIn(duration: 400.ms, delay: 290.ms),

                  const SizedBox(height: 24),

                  // Primary CTA
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            config.accentColor,
                            config.accentColor.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: config.accentColor.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Semantics(
                        label: config.cta,
                        button: true,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading
                                ? null
                                : () {
                                    HapticFeedback.mediumImpact();
                                    _handlePrimaryCta();
                                  },
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: _isLoading
                                    ? const CosmicLoadingIndicator(size: 22)
                                    : Text(
                                        config.cta,
                                        style: AppTypography.modernAccent(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                  const SizedBox(height: 12),

                  // Price anchor (variant-aware)
                  _buildPriceAnchor(
                    isEn,
                  ).animate().fadeIn(duration: 400.ms, delay: 350.ms),
                  const SizedBox(height: 16),

                  // Risk reversal
                  Text(
                    L10nService.get('premium.contextual_paywall.cancel_anytime_your_entries_are_always_y', isEn ? AppLanguage.en : AppLanguage.tr),
                    textAlign: TextAlign.center,
                    style: AppTypography.decorativeScript(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                  const SizedBox(height: 12),

                  // Secondary - dismiss
                  TextButton(
                    onPressed: () {
                      final experiment = ref
                          .read(paywallExperimentProvider)
                          .whenOrNull(data: (e) => e);
                      experiment?.logPaywallDismissal();
                      ref.read(telemetryServiceProvider).whenData((t) {
                        t.paywallDismissed(
                          triggerPoint: widget.paywallContext.name,
                        );
                      });
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      L10nService.get('premium.contextual_paywall.not_now', isEn ? AppLanguage.en : AppLanguage.tr),
                      style: AppTypography.elegantAccent(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
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

  Widget _buildPriceAnchor(bool isEn) {
    final experiment = ref
        .watch(paywallExperimentProvider)
        .whenOrNull(data: (e) => e);
    final dynamicMonthly = ref
        .read(premiumProvider.notifier)
        .getProductPrice(PremiumTier.monthly);
    final monthlyLabel =
        experiment?.monthlyPriceLabel ??
        dynamicMonthly ??
        L10nService.get('premium.pricing.monthly', isEn ? AppLanguage.en : AppLanguage.tr);
    final yearlyLabel =
        experiment?.yearlyMonthlyEquivalent ??
        L10nService.get('premium.pricing.yearly_monthly', isEn ? AppLanguage.en : AppLanguage.tr);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            isEn
                ? monthlyLabel
                : monthlyLabel.replaceAll('.', ',').replaceAll('/mo', '/ay'),
            style:
                AppTypography.elegantAccent(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13,
                ).copyWith(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.white.withValues(alpha: 0.4),
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            isEn
                ? '$yearlyLabel billed yearly'
                : '${yearlyLabel.replaceAll('.', ',').replaceAll('/mo', '/ay')} yıllık',
            style: AppTypography.modernAccent(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _handlePrimaryCta() async {
    setState(() => _isLoading = true);

    ref.read(analyticsServiceProvider).logEvent('contextual_paywall_cta_tap', {
      'context': widget.paywallContext.name,
    });

    final result = await ref.read(paywallServiceProvider).presentPaywall();
    if (!mounted) return;

    final experiment = ref
        .read(paywallExperimentProvider)
        .whenOrNull(data: (e) => e);

    if (mounted) {
      setState(() => _isLoading = false);
      if (result == PaywallResult.purchased ||
          result == PaywallResult.restored) {
        experiment?.logPaywallConversion();
        ref.read(telemetryServiceProvider).whenData((t) {
          t.paywallConverted(
            plan: 'premium',
            triggerPoint: widget.paywallContext.name,
          );
        });
        Navigator.pop(context, true);
      } else {
        experiment?.logPaywallDismissal();
        ref.read(telemetryServiceProvider).whenData((t) {
          t.paywallDismissed(triggerPoint: widget.paywallContext.name);
        });
      }
    }
  }

  Widget _buildSocialProof(bool isEn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.people_outline,
          size: 14,
          color: Colors.white.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            L10nService.get('premium.contextual_paywall.surface_patterns_from_your_entries_with', isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.decorativeScript(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildValueRecap(bool isEn, Color accentColor) {
    final entryCount =
        widget.entryCount ??
        ref.read(journalServiceProvider).valueOrNull?.entryCount ??
        0;
    final streakDays =
        widget.streakDays ??
        ref.read(streakStatsProvider).valueOrNull?.currentStreak ??
        0;
    final dreamCount = ref.read(dreamCountProvider).valueOrNull ?? 0;

    // Only show if user has meaningful data
    if (entryCount == 0 && streakDays == 0 && dreamCount == 0) {
      return const SizedBox.shrink();
    }

    final items = <_ValueItem>[];
    if (entryCount > 0) {
      items.add(
        _ValueItem(
          Icons.edit_note_outlined,
          L10nService.getWithParams('premium.entry_count', isEn ? AppLanguage.en : AppLanguage.tr, params: {'count': '$entryCount'}),
        ),
      );
    }
    if (streakDays > 0) {
      items.add(
        _ValueItem(
          Icons.local_fire_department_outlined,
          L10nService.getWithParams('premium.day_streak', isEn ? AppLanguage.en : AppLanguage.tr, params: {'count': '$streakDays'}),
        ),
      );
    }
    if (dreamCount > 0) {
      items.add(
        _ValueItem(
          Icons.nights_stay_outlined,
          L10nService.getWithParams('premium.dream_count', isEn ? AppLanguage.en : AppLanguage.tr, params: {'count': '$dreamCount'}),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Text(
            L10nService.get('premium.contextual_paywall.your_investment_so_far', isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.elegantAccent(
              fontSize: 11,
              letterSpacing: 1.0,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items
                .map(
                  (item) => Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon, size: 14, color: accentColor),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item.label,
                            style: AppTypography.subtitle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  _PaywallConfig _getConfig(bool isEn) {
    switch (widget.paywallContext) {
      case PaywallContext.patterns:
        return _PaywallConfig(
          icon: Icons.psychology_outlined,
          accentColor: AppColors.starGold,
          headline: L10nService.get('premium.contextual_paywall.your_data_has_more_to_show', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('premium.contextual_paywall.your_entries_hold_patterns_you_cant_see', isEn ? AppLanguage.en : AppLanguage.tr),
          detail: widget.entryCount != null
              ? (isEn
                    ? '${widget.entryCount} entries analyzed'
                    : '${widget.entryCount} kayıt analiz edildi')
              : null,
          cta: L10nService.get('premium.contextual_paywall.discover_my_patterns', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.dreams:
        return _PaywallConfig(
          icon: Icons.nightlight_round,
          accentColor: AppColors.mediumSlateBlue,
          headline: L10nService.get('premium.contextual_paywall.your_dream_has_more_to_say', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('premium.contextual_paywall.4_more_interpretation_perspectives_avail', isEn ? AppLanguage.en : AppLanguage.tr),
          cta: L10nService.get('premium.contextual_paywall.access_all_perspectives', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.streakFreeze:
        return _PaywallConfig(
          icon: Icons.local_fire_department,
          accentColor: AppColors.streakOrange,
          headline: isEn
              ? "Don't lose what you've built"
              : 'İnşa ettiğini kaybetme',
          subtitle: L10nService.get('premium.contextual_paywall.freeze_your_streak_and_pick_up_where_you', isEn ? AppLanguage.en : AppLanguage.tr),
          detail: widget.streakDays != null
              ? (isEn
                    ? '${widget.streakDays}-day streak at risk'
                    : '${widget.streakDays} günlük seri risk altında')
              : null,
          cta: L10nService.get('premium.contextual_paywall.protect_my_streak', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.monthlyReport:
        return _PaywallConfig(
          icon: Icons.insert_chart_outlined,
          accentColor: AppColors.chartBlue,
          headline: isEn
              ? "You've done the work. See the growth."
              : 'Emeği verdin. Büyümeyi gör.',
          subtitle: L10nService.get('premium.contextual_paywall.your_monthly_reflection_report_distills', isEn ? AppLanguage.en : AppLanguage.tr),
          cta: L10nService.get('premium.contextual_paywall.view_my_report', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.export:
        return _PaywallConfig(
          icon: Icons.download_rounded,
          accentColor: AppColors.exportGreen,
          headline: L10nService.get('premium.contextual_paywall.your_data_belongs_to_you', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: isEn
              ? 'Export your complete journal history in any format. All ${widget.entryCount ?? ''} entries, yours to keep.'
              : 'Tüm günlük geçmişini istediğin formatta dışa aktar. ${widget.entryCount ?? ''} kayıt, senin.',
          cta: L10nService.get('premium.contextual_paywall.export_everything', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.adRemoval:
        return _PaywallConfig(
          icon: Icons.visibility_off,
          accentColor: AppColors.amethyst,
          headline: L10nService.get('premium.contextual_paywall.your_reflection_space_uninterrupted', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('premium.contextual_paywall.remove_all_ads_and_focus_on_what_matters', isEn ? AppLanguage.en : AppLanguage.tr),
          cta: L10nService.get('premium.contextual_paywall.go_adfree', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.programs:
        return _PaywallConfig(
          icon: Icons.school_rounded,
          accentColor: AppColors.greenAccent,
          headline: L10nService.get('premium.contextual_paywall.go_deeper_with_guided_growth', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('premium.contextual_paywall.structured_multiday_sequences_designed_t', isEn ? AppLanguage.en : AppLanguage.tr),
          cta: L10nService.get('premium.contextual_paywall.start_program', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.challenges:
        return _PaywallConfig(
          icon: Icons.emoji_events_rounded,
          accentColor: AppColors.celestialGold,
          headline: L10nService.get('premium.contextual_paywall.push_your_limits', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('premium.contextual_paywall.pro_growth_challenges_that_elevate_your', isEn ? AppLanguage.en : AppLanguage.tr),
          cta: L10nService.get('premium.contextual_paywall.accept_challenge', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.cycleSync:
        return _PaywallConfig(
          icon: Icons.favorite_rounded,
          accentColor: AppColors.amethyst,
          headline: L10nService.get('premium.contextual_paywall.understand_your_cycle_patterns', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('premium.contextual_paywall.see_how_your_emotional_patterns_align_wi', isEn ? AppLanguage.en : AppLanguage.tr),
          cta: L10nService.get('premium.contextual_paywall.access_cycle_insights', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.shadowWork:
        return _PaywallConfig(
          icon: Icons.psychology_rounded,
          accentColor: AppColors.amethyst,
          headline: L10nService.get('premium.contextual_paywall.explore_your_hidden_patterns', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('premium.contextual_paywall.guided_shadow_work_helps_you_understand', isEn ? AppLanguage.en : AppLanguage.tr),
          cta: L10nService.get('premium.contextual_paywall.access_shadow_work', isEn ? AppLanguage.en : AppLanguage.tr),
        );

      case PaywallContext.general:
        return _PaywallConfig(
          icon: Icons.psychology_outlined,
          accentColor: AppColors.starGold,
          headline: L10nService.get('premium.contextual_paywall.your_data_has_more_to_show_1', isEn ? AppLanguage.en : AppLanguage.tr),
          subtitle: L10nService.get('premium.contextual_paywall.no_ai_no_cloud_just_your_words_revealing', isEn ? AppLanguage.en : AppLanguage.tr),
          cta: L10nService.get('premium.contextual_paywall.discover_my_patterns_1', isEn ? AppLanguage.en : AppLanguage.tr),
        );
    }
  }
}

class _PaywallConfig {
  final IconData icon;
  final Color accentColor;
  final String headline;
  final String subtitle;
  final String? detail;
  final String cta;

  const _PaywallConfig({
    required this.icon,
    required this.accentColor,
    required this.headline,
    required this.subtitle,
    this.detail,
    required this.cta,
  });
}

class _ValueItem {
  final IconData icon;
  final String label;
  const _ValueItem(this.icon, this.label);
}
