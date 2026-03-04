// ════════════════════════════════════════════════════════════════════════════
// DREAM CORRELATION SCREEN - Dream theme × mood impact analysis
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/dream_journal_correlation_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class DreamCorrelationScreen extends ConsumerWidget {
  const DreamCorrelationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(dreamCorrelationServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (_, _) => Center(child: Text('Something went wrong', style: TextStyle(color: Color(0xFF9E8E82)))),
            data: (service) {
              return FutureBuilder<List<DreamMoodCorrelation>>(
                future: service.analyzeDreamMoodCorrelations(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(child: Text('${snap.error}'));
                  }
                  if (!snap.hasData) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  final correlations = snap.data!;

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      GlassSliverAppBar(
                        title: isEn
                            ? 'Dream × Mood'
                            : 'Rüya × Ruh Hali',
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
                                    ? 'How dream themes relate to your waking mood'
                                    : 'Rüya temaları uyanık halindeki ruh halini nasıl etkiliyor',
                                style: AppTypography.decorativeScript(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),

                              if (correlations.isEmpty)
                                _EmptyState(
                                    isEn: isEn, isDark: isDark)
                              else ...[
                                // Top correlations
                                ...correlations
                                    .take(10)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) => Padding(
                                          padding:
                                              const EdgeInsets.only(
                                                  bottom: 10),
                                          child: _CorrelationTile(
                                            correlation: e.value,
                                            rank: e.key + 1,
                                            isEn: isEn,
                                            isDark: isDark,
                                          ),
                                        ))
                                    .toList()
                                    .animate(
                                        interval: 80.ms)
                                    .fadeIn(duration: 300.ms)
                                    .slideX(
                                        begin: 0.05, end: 0),

                                const SizedBox(height: 20),

                                // Insight
                                _InsightSection(
                                  correlations: correlations,
                                  isEn: isEn,
                                  isDark: isDark,
                                ),
                              ],

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CorrelationTile extends StatelessWidget {
  final DreamMoodCorrelation correlation;
  final int rank;
  final bool isEn;
  final bool isDark;

  const _CorrelationTile({
    required this.correlation,
    required this.rank,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dirColor = correlation.direction == CorrelationDirection.moodRises
        ? AppColors.success
        : correlation.direction == CorrelationDirection.moodDrops
            ? AppColors.warning
            : AppColors.amethyst;

    final dirIcon = correlation.direction == CorrelationDirection.moodRises
        ? Icons.trending_up_rounded
        : correlation.direction == CorrelationDirection.moodDrops
            ? Icons.trending_down_rounded
            : Icons.trending_flat_rounded;

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
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dirColor.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      color: dirColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  correlation.theme,
                  style: AppTypography.modernAccent(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              Icon(dirIcon, size: 18, color: dirColor),
              const SizedBox(width: 6),
              Text(
                '${correlation.delta > 0 ? '+' : ''}${correlation.delta.toStringAsFixed(1)}',
                style: AppTypography.modernAccent(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: dirColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Strength bar
          Row(
            children: [
              Text(
                correlation.avgMoodBefore.toStringAsFixed(1),
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: correlation.strength,
                    backgroundColor: (isDark ? Colors.white : Colors.black)
                        .withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(dirColor),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                correlation.avgMoodAfter.toStringAsFixed(1),
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${correlation.sampleSize}×',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isEn
                ? 'After dreams about "${correlation.theme}", ${correlation.direction.labelEn()}'
                : '"${correlation.theme}" rüyalarından sonra ${correlation.direction.labelTr()}',
            style: AppTypography.subtitle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightSection extends StatelessWidget {
  final List<DreamMoodCorrelation> correlations;
  final bool isEn;
  final bool isDark;

  const _InsightSection({
    required this.correlations,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final rising = correlations
        .where((c) => c.direction == CorrelationDirection.moodRises)
        .length;
    final dropping = correlations
        .where((c) => c.direction == CorrelationDirection.moodDrops)
        .length;
    final stable = correlations
        .where((c) => c.direction == CorrelationDirection.moodStable)
        .length;

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(
              isEn ? 'Patterns' : 'Kalıplar',
              variant: GradientTextVariant.amethyst,
              style: AppTypography.modernAccent(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(
                  icon: Icons.trending_up_rounded,
                  label: isEn ? 'Mood rises' : 'Yükselme',
                  value: '$rising',
                  color: AppColors.success,
                  isDark: isDark,
                ),
                _StatChip(
                  icon: Icons.trending_down_rounded,
                  label: isEn ? 'Mood dips' : 'Düşme',
                  value: '$dropping',
                  color: AppColors.warning,
                  isDark: isDark,
                ),
                _StatChip(
                  icon: Icons.trending_flat_rounded,
                  label: isEn ? 'Stable' : 'Sabit',
                  value: '$stable',
                  color: AppColors.amethyst,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isEn
                  ? 'Your dream patterns suggest connections between dream themes and how you feel the next day. These are observations from your journal entries, not predictions.'
                  : 'Rüya kalıpların, rüya temaları ile ertesi gün nasıl hissettiğin arasındaki bağlantıları gösteriyor. Bunlar günlük girdilerinden gözlemler, tahmin değil.',
              style: AppTypography.subtitle(
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

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.modernAccent(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 10,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
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
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('\u{1F30C}', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 12),
            Text(
              isEn
                  ? 'Keep logging dreams and journal entries to reveal dream-mood patterns'
                  : 'Rüya-ruh hali kalıplarını ortaya çıkarmak için rüyaları ve günlüğü kaydetmeye devam et',
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
    );
  }
}
