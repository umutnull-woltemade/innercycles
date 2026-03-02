// ════════════════════════════════════════════════════════════════════════════
// SHADOW WORK ARCHIVE SCREEN - Past entries & archetype analytics
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/shadow_work_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class ShadowWorkArchiveScreen extends ConsumerWidget {
  const ShadowWorkArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(shadowWorkServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              if (!service.hasData) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              final entries = service.getEntries();
              final stats = service.getArchetypeStats();
              final mostActive = service.getMostActiveArchetype();
              final unexplored = service.getUnexploredArchetypes();
              final avgIntensity = service.getAverageIntensity();
              final breakthroughs = service.getBreakthroughCount();
              final streak = service.getStreak();

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Shadow Archive'
                        : 'Gölge Arşivi',
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
                                ? 'Your shadow integration journey'
                                : 'Gölge entegrasyonu yolculuğun',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Overview hero
                          _OverviewHero(
                            totalEntries: entries.length,
                            breakthroughs: breakthroughs,
                            avgIntensity: avgIntensity,
                            streak: streak,
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Archetype exploration
                          GradientText(
                            isEn
                                ? 'Archetype Exploration'
                                : 'Arketip Keşfi',
                            variant: GradientTextVariant.amethyst,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...ShadowArchetype.values.map((arch) {
                            final count = stats[arch] ?? 0;
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 6),
                              child: _ArchetypeBar(
                                archetype: arch,
                                count: count,
                                maxCount: entries.length,
                                isMostActive:
                                    arch == mostActive,
                                isEn: isEn,
                                isDark: isDark,
                              ),
                            );
                          }),

                          const SizedBox(height: 24),

                          // Unexplored archetypes
                          if (unexplored.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Unexplored (${unexplored.length})'
                                  : 'Keşfedilmemiş (${unexplored.length})',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: unexplored
                                  .map((arch) => Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                          color: AppColors.starGold
                                              .withValues(
                                                  alpha: 0.08),
                                          border: Border.all(
                                            color: AppColors.starGold
                                                .withValues(
                                                    alpha: 0.2),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          children: [
                                            Text(
                                              arch.iconEmoji,
                                              style:
                                                  const TextStyle(
                                                      fontSize: 14),
                                            ),
                                            const SizedBox(
                                                width: 6),
                                            Text(
                                              arch.localizedName(
                                                  isEn
                                                      ? AppLanguage
                                                          .en
                                                      : AppLanguage
                                                          .tr),
                                              style: AppTypography
                                                  .elegantAccent(
                                                fontSize: 12,
                                                color: AppColors
                                                    .starGold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Recent entries
                          GradientText(
                            isEn
                                ? 'Recent Entries (${entries.length})'
                                : 'Son Girdiler (${entries.length})',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...entries.take(10).map((entry) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10),
                                child: _EntryTile(
                                  entry: entry,
                                  isEn: isEn,
                                  isDark: isDark,
                                ),
                              )),

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

class _OverviewHero extends StatelessWidget {
  final int totalEntries;
  final int breakthroughs;
  final double avgIntensity;
  final int streak;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.totalEntries,
    required this.breakthroughs,
    required this.avgIntensity,
    required this.streak,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.amethyst,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _OverviewStat(
              value: '$totalEntries',
              label: isEn ? 'Sessions' : 'Oturum',
              color: AppColors.amethyst,
              isDark: isDark,
            ),
            _OverviewStat(
              value: '$breakthroughs',
              label: isEn ? 'Breakthroughs' : 'Atılım',
              color: AppColors.starGold,
              isDark: isDark,
            ),
            _OverviewStat(
              value: avgIntensity.toStringAsFixed(1),
              label: isEn ? 'Avg Depth' : 'Ort. Derinlik',
              color: AppColors.auroraStart,
              isDark: isDark,
            ),
            _OverviewStat(
              value: '$streak',
              label: isEn ? 'Streak' : 'Seri',
              color: AppColors.success,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _OverviewStat({
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.modernAccent(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 9,
            color:
                isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _ArchetypeBar extends StatelessWidget {
  final ShadowArchetype archetype;
  final int count;
  final int maxCount;
  final bool isMostActive;
  final bool isEn;
  final bool isDark;

  const _ArchetypeBar({
    required this.archetype,
    required this.count,
    required this.maxCount,
    required this.isMostActive,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxCount > 0 ? count / maxCount : 0.0;

    return Row(
      children: [
        Text(archetype.iconEmoji,
            style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 6),
        SizedBox(
          width: 90,
          child: Text(
            archetype.localizedName(
                isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.modernAccent(
              fontSize: 11,
              fontWeight:
                  isMostActive ? FontWeight.w700 : FontWeight.w500,
              color: isMostActive
                  ? AppColors.amethyst
                  : (isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation(
                  count > 0 ? AppColors.amethyst : AppColors.textMuted),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            textAlign: TextAlign.end,
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: count > 0
                  ? AppColors.amethyst
                  : (isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted),
            ),
          ),
        ),
      ],
    );
  }
}

class _EntryTile extends StatelessWidget {
  final ShadowWorkEntry entry;
  final bool isEn;
  final bool isDark;

  const _EntryTile({
    required this.entry,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${entry.date.day}.${entry.date.month}.${entry.date.year}';

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
              Text(entry.archetype.iconEmoji,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.archetype.localizedName(
                      isEn ? AppLanguage.en : AppLanguage.tr),
                  style: AppTypography.modernAccent(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              if (entry.breakthroughMoment)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.starGold
                        .withValues(alpha: 0.12),
                  ),
                  child: Text(
                    '\u{2728}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                dateStr,
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Intensity bar
          Row(
            children: [
              Text(
                isEn ? 'Depth' : 'Derinlik',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 6),
              ...List.generate(10, (i) {
                final filled = i < entry.intensity;
                return Container(
                  width: 14,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: filled
                        ? AppColors.amethyst
                            .withValues(alpha: 0.3 + (i / 10) * 0.5)
                        : (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.06),
                  ),
                );
              }),
              const SizedBox(width: 6),
              Text(
                '${entry.intensity}/10',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: AppColors.amethyst,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            entry.response,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Shadow Archive' : 'Gölge Arşivi',
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
                      const Text('\u{1F311}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Begin your shadow work journey to see your integration patterns'
                            : 'Entegrasyon kalıplarını görmek için gölge çalışma yolculuğuna başla',
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
