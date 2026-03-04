// ════════════════════════════════════════════════════════════════════════════
// PATTERN LOOP ARCHIVE SCREEN - Detected behavioral loops & stages
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/pattern_loop_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class PatternLoopArchiveScreen extends ConsumerWidget {
  const PatternLoopArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(patternLoopServiceProvider);
    final analysisAsync = ref.watch(patternLoopAnalysisProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              if (!service.hasEnoughData()) {
                return _InsufficientData(
                  needed: service.entriesNeeded(),
                  isEn: isEn,
                  isDark: isDark,
                );
              }

              final analysis =
                  analysisAsync.whenOrNull(data: (a) => a);
              final loops = service.getDetectedLoops();
              final strongest = service.getStrongestLoop();

              if (loops.isEmpty) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Pattern Loops'
                        : 'Kalıp Döngüleri',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            isEn
                                ? 'Recurring behavioral patterns in your entries'
                                : 'Yazılarında tekrarlayan davranış kalıpları',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview hero
                          if (analysis != null)
                            _OverviewHero(
                              analysis: analysis,
                              isEn: isEn,
                              isDark: isDark,
                            ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Strongest loop highlight
                          if (strongest != null) ...[
                            GradientText(
                              isEn
                                  ? 'Strongest Pattern'
                                  : 'En Güçlü Kalıp',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _LoopCard(
                              loop: strongest,
                              isEn: isEn,
                              isDark: isDark,
                              highlight: true,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Reinforcement breakdown
                          if (analysis != null &&
                              analysis.reinforcementBreakdown
                                  .isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Reinforcement Types'
                                  : 'Pekiştirme Türleri',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _ReinforcementBreakdown(
                              breakdown:
                                  analysis.reinforcementBreakdown,
                              isEn: isEn,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // All detected loops
                          GradientText(
                            isEn
                                ? 'All Detected Loops (${loops.length})'
                                : 'Tespit Edilen Döngüler (${loops.length})',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...loops
                              .where((l) => l.id != strongest?.id)
                              .map((loop) => Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10),
                                    child: _LoopCard(
                                      loop: loop,
                                      isEn: isEn,
                                      isDark: isDark,
                                    ),
                                  )),

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? 'Pattern observations, not predictions'
                                  : 'Kalıp gözlemleri, tahmin değil',
                              style: AppTypography.subtitle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
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

Color _focusAreaColor(FocusArea area) {
  switch (area) {
    case FocusArea.energy:
      return AppColors.starGold;
    case FocusArea.focus:
      return AppColors.chartBlue;
    case FocusArea.emotions:
      return AppColors.brandPink;
    case FocusArea.decisions:
      return AppColors.success;
    case FocusArea.social:
      return AppColors.amethyst;
  }
}

Color _reinforcementColor(ReinforcementType type) {
  switch (type) {
    case ReinforcementType.positive:
      return AppColors.success;
    case ReinforcementType.negative:
      return AppColors.error;
    case ReinforcementType.neutral:
      return AppColors.amethyst;
  }
}

class _OverviewHero extends StatelessWidget {
  final PatternLoopAnalysis analysis;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.analysis,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final total = analysis.detectedLoops.length;
    final positive =
        analysis.reinforcementBreakdown[ReinforcementType.positive] ?? 0;
    final negative =
        analysis.reinforcementBreakdown[ReinforcementType.negative] ?? 0;

    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  '$total',
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  isEn ? 'Loops' : 'Döngü',
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '$positive',
                  style: AppTypography.modernAccent(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                Text(
                  isEn ? 'Positive' : 'Olumlu',
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '$negative',
                  style: AppTypography.modernAccent(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
                Text(
                  isEn ? 'Negative' : 'Olumsuz',
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${analysis.totalEntriesAnalyzed}',
                  style: AppTypography.modernAccent(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.auroraStart,
                  ),
                ),
                Text(
                  isEn ? 'Analyzed' : 'İncelenen',
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
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
    );
  }
}

class _ReinforcementBreakdown extends StatelessWidget {
  final Map<ReinforcementType, int> breakdown;
  final bool isEn;
  final bool isDark;

  const _ReinforcementBreakdown({
    required this.breakdown,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final total =
        breakdown.values.fold<int>(0, (sum, v) => sum + v);
    if (total == 0) return const SizedBox.shrink();

    return Row(
      children: ReinforcementType.values.map((type) {
        final count = breakdown[type] ?? 0;
        final ratio = count / total;
        final color = _reinforcementColor(type);
        final label = isEn ? type.labelEn() : type.labelTr();

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: color.withValues(alpha: 0.12)),
            ),
            child: Column(
              children: [
                Text(
                  '$count',
                  style: AppTypography.modernAccent(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor:
                        (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LoopCard extends StatelessWidget {
  final PatternLoop loop;
  final bool isEn;
  final bool isDark;
  final bool highlight;

  const _LoopCard({
    required this.loop,
    required this.isEn,
    required this.isDark,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _focusAreaColor(loop.primaryArea);
    final rColor = _reinforcementColor(loop.reinforcementType);
    final areaName = isEn
        ? loop.primaryArea.displayNameEn
        : loop.primaryArea.displayNameTr;
    final rLabel = isEn
        ? loop.reinforcementType.labelEn()
        : loop.reinforcementType.labelTr();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.starGold.withValues(alpha: 0.06)
            : isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: highlight
            ? Border.all(
                color: AppColors.starGold.withValues(alpha: 0.15))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                areaName,
                style: AppTypography.modernAccent(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              if (loop.secondaryArea != null) ...[
                const SizedBox(width: 6),
                Text(
                  '+',
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isEn
                      ? loop.secondaryArea!.displayNameEn
                      : loop.secondaryArea!.displayNameTr,
                  style: AppTypography.modernAccent(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        _focusAreaColor(loop.secondaryArea!),
                  ),
                ),
              ],
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: rColor.withValues(alpha: 0.12),
                ),
                child: Text(
                  rLabel,
                  style: AppTypography.elegantAccent(
                    fontSize: 10,
                    color: rColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 5-stage flow
          _StageFlow(
            loop: loop,
            isEn: isEn,
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Strength bar
          Row(
            children: [
              Text(
                isEn ? 'Strength' : 'Güç',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: loop.strength.clamp(0.0, 1.0),
                    backgroundColor:
                        (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(loop.strength * 100).round()}%',
                style: AppTypography.modernAccent(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Stats row
          Row(
            children: [
              Icon(Icons.replay_rounded,
                  size: 12, color: AppColors.auroraStart),
              const SizedBox(width: 4),
              Text(
                '${loop.occurrenceCount}${isEn ? 'x seen' : 'x görüldü'}',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: AppColors.auroraStart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Insight
          Text(
            isEn ? loop.insightEn : loop.insightTr,
            style: AppTypography.subtitle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),

          // Action
          if ((isEn ? loop.actionEn : loop.actionTr) != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    size: 13, color: AppColors.starGold),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (isEn ? loop.actionEn : loop.actionTr)!,
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: AppColors.starGold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StageFlow extends StatelessWidget {
  final PatternLoop loop;
  final bool isEn;
  final bool isDark;

  const _StageFlow({
    required this.loop,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final stages = [
      loop.trigger,
      loop.emotionalShift,
      loop.behavior,
      loop.outcome,
      loop.reinforcement,
    ];
    final stageIcons = [
      Icons.flash_on_rounded,
      Icons.mood_rounded,
      Icons.directions_run_rounded,
      Icons.flag_rounded,
      Icons.loop_rounded,
    ];

    return Row(
      children: List.generate(stages.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Arrow between stages
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 10,
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.2),
            ),
          );
        }
        final idx = i ~/ 2;
        final stage = stages[idx];
        final label = isEn ? stage.labelEn : stage.labelTr;

        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  stageIcons[idx],
                  size: 14,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.elegantAccent(
                    fontSize: 8,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _InsufficientData extends StatelessWidget {
  final int needed;
  final bool isEn;
  final bool isDark;

  const _InsufficientData({
    required this.needed,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Pattern Loops' : 'Kalıp Döngüleri',
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F504}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? '$needed more entries needed to detect behavioral loops'
                            : 'Davranış döngülerini tespit etmek için $needed kayıt daha gerekli',
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Pattern Loops' : 'Kalıp Döngüleri',
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: PremiumCard(
                style: PremiumCardStyle.subtle,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('\u{1F50D}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'No behavioral loops detected yet. Keep journaling consistently to uncover patterns.'
                            : 'Henüz davranış döngüsü tespit edilmedi. Kalıpları ortaya çıkarmak için düzenli yazmaya devam et.',
                        textAlign: TextAlign.center,
                        style: AppTypography.decorativeScript(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
