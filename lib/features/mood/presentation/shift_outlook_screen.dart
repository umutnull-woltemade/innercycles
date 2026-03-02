// ════════════════════════════════════════════════════════════════════════════
// SHIFT OUTLOOK SCREEN - Emotional shift window analysis
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/shift_outlook_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class ShiftOutlookScreen extends ConsumerWidget {
  const ShiftOutlookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outlookAsync = ref.watch(shiftOutlookProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: outlookAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (outlook) {
              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Shift Outlook' : 'Kayma Görünümü',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Signals from your emotional patterns'
                                : 'Duygusal kalıplarından gelen sinyaller',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (!outlook.hasValidOutlook)
                            _InsufficientData(isEn: isEn, isDark: isDark)
                          else ...[
                            // Current phase hero
                            _PhaseHero(
                              outlook: outlook,
                              isEn: isEn,
                              isDark: isDark,
                            ).animate().fadeIn(duration: 400.ms),

                            const SizedBox(height: 24),

                            // Primary shift window
                            if (outlook.primaryShiftWindow != null) ...[
                              GradientText(
                                isEn
                                    ? 'Shift Window'
                                    : 'Kayma Penceresi',
                                variant: GradientTextVariant.gold,
                                style: AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _ShiftWindowCard(
                                window: outlook.primaryShiftWindow!,
                                isEn: isEn,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Active signals
                            if (outlook.activeSignals.isNotEmpty) ...[
                              GradientText(
                                isEn
                                    ? 'Active Signals (${outlook.activeSignals.length})'
                                    : 'Aktif Sinyaller (${outlook.activeSignals.length})',
                                variant: GradientTextVariant.aurora,
                                style: AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...outlook.activeSignals.map((signal) =>
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8),
                                    child: _SignalTile(
                                      signal: signal,
                                      isEn: isEn,
                                      isDark: isDark,
                                    ),
                                  )),
                              const SizedBox(height: 16),
                            ],

                            // Alternative windows
                            if (outlook.alternativeWindows.isNotEmpty) ...[
                              GradientText(
                                isEn
                                    ? 'Alternative Path'
                                    : 'Alternatif Yol',
                                variant: GradientTextVariant.amethyst,
                                style: AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...outlook.alternativeWindows
                                  .map((w) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8),
                                        child: _ShiftWindowCard(
                                          window: w,
                                          isEn: isEn,
                                          isDark: isDark,
                                          isAlternative: true,
                                        ),
                                      )),
                            ],
                          ],

                          const SizedBox(height: 24),

                          // Disclaimer
                          Text(
                            isEn
                                ? 'Based on ${outlook.dataPointsUsed} journal entries. These are pattern observations, not predictions.'
                                : '${outlook.dataPointsUsed} günlük girdisine dayalı. Bunlar kalıp gözlemleri, tahmin değil.',
                            style: AppTypography.subtitle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
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

class _PhaseHero extends StatelessWidget {
  final ShiftOutlook outlook;
  final bool isEn;
  final bool isDark;

  const _PhaseHero({
    required this.outlook,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final phase = outlook.currentPhase!;
    final phaseLabel = isEn ? phase.labelEn() : phase.labelTr();

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              isEn ? 'Current Phase' : 'Mevcut Evre',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              phaseLabel,
              style: AppTypography.displayFont.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: AppColors.auroraStart,
              ),
            ),
            if (outlook.currentArc != null) ...[
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.auroraStart.withValues(alpha: 0.12),
                ),
                child: Text(
                  isEn
                      ? outlook.currentArc!.labelEn()
                      : outlook.currentArc!.labelTr(),
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: AppColors.auroraStart,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShiftWindowCard extends StatelessWidget {
  final ShiftWindow window;
  final bool isEn;
  final bool isDark;
  final bool isAlternative;

  const _ShiftWindowCard({
    required this.window,
    required this.isEn,
    required this.isDark,
    this.isAlternative = false,
  });

  @override
  Widget build(BuildContext context) {
    final confColor = switch (window.confidence) {
      OutlookConfidence.high => AppColors.success,
      OutlookConfidence.moderate => AppColors.starGold,
      OutlookConfidence.low => AppColors.amethyst,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phase transition
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.amethyst.withValues(alpha: 0.12),
                ),
                child: Text(
                  isEn
                      ? window.currentPhase.labelEn()
                      : window.currentPhase.labelTr(),
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: AppColors.amethyst,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward_rounded,
                    size: 14,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.auroraStart.withValues(alpha: 0.12),
                ),
                child: Text(
                  isEn
                      ? window.suggestedNextPhase.labelEn()
                      : window.suggestedNextPhase.labelTr(),
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: AppColors.auroraStart,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '~${window.estimatedDaysUntilShift}${isEn ? 'd' : 'g'}',
                style: AppTypography.modernAccent(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Confidence badge
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: confColor.withValues(alpha: 0.12),
                ),
                child: Text(
                  window.confidence.label(
                      isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
                    color: confColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'confidence' : 'güven',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            window.localizedDescription(
                isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.subtitle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // Action recommendation
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.starGold.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    size: 14, color: AppColors.starGold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    window.localizedAction(
                        isEn ? AppLanguage.en : AppLanguage.tr),
                    style: AppTypography.subtitle(
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
}

class _SignalTile extends StatelessWidget {
  final MicroSignal signal;
  final bool isEn;
  final bool isDark;

  const _SignalTile({
    required this.signal,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Magnitude indicator
          SizedBox(
            width: 32,
            height: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: signal.magnitude,
                  backgroundColor: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.06),
                  valueColor: AlwaysStoppedAnimation(AppColors.auroraStart),
                  strokeWidth: 3,
                ),
                Text(
                  '${(signal.magnitude * 100).round()}',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: AppColors.auroraStart,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  signal.area.displayNameEn,
                  style: AppTypography.modernAccent(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  signal.localizedSignal(
                      isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.subtitle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsufficientData extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _InsufficientData({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('\u{1F52E}', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 12),
            Text(
              isEn
                  ? 'Keep journaling to reveal your emotional shift patterns'
                  : 'Duygusal kayma kalıplarını ortaya çıkarmak için günlük yazmaya devam et',
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEn ? 'At least 14 entries needed' : 'En az 14 giriş gerekli',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
