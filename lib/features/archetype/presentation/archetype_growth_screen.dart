// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE GROWTH SCREEN - Growth areas, intentions & compatible archetypes
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/archetype_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class ArchetypeGrowthScreen extends ConsumerWidget {
  const ArchetypeGrowthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(archetypeServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              return journalAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (journalService) {
                  final entries = journalService.getAllEntries();
                  if (!service.hasEnoughData(entries)) {
                    return _EmptyState(isEn: isEn, isDark: isDark);
                  }

                  final result = service.getCurrentArchetype(entries);
                  if (result == null) {
                    return _EmptyState(isEn: isEn, isDark: isDark);
                  }

                  final dominant = result.dominant;
                  final snapshots = service.getRecentSnapshots(count: 12);

                  // Find top 3 secondary archetypes
                  final sortedBreakdown = result.breakdown.entries
                      .toList()
                    ..sort(
                        (a, b) => b.value.compareTo(a.value));
                  final secondaries = sortedBreakdown
                      .skip(1)
                      .take(3)
                      .toList();

                  return CustomScrollView(
                    slivers: [
                      GlassSliverAppBar(
                        title: isEn
                            ? 'Growth Profile'
                            : 'Gelişim Profili',
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                isEn
                                    ? 'Your archetype-guided personal growth path'
                                    : 'Arketip rehberliğinde kişisel gelişim yolun',
                                style:
                                    AppTypography.decorativeScript(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColors
                                          .lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Dominant archetype hero
                              _ArchetypeHero(
                                archetype: dominant,
                                confidence: result.confidence,
                                language: language,
                                isDark: isDark,
                              )
                                  .animate()
                                  .fadeIn(duration: 400.ms),

                              const SizedBox(height: 24),

                              // Growth Areas
                              if (dominant
                                  .getGrowthAreas(
                                      language: language)
                                  .isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Growth Areas'
                                      : 'Gelişim Alanları',
                                  variant:
                                      GradientTextVariant.aurora,
                                  style:
                                      AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...dominant
                                    .getGrowthAreas(
                                        language: language)
                                    .asMap()
                                    .entries
                                    .map((e) => Padding(
                                          padding:
                                              const EdgeInsets
                                                  .only(
                                                  bottom: 8),
                                          child:
                                              _GrowthAreaCard(
                                            index: e.key + 1,
                                            text: e.value,
                                            isDark: isDark,
                                          ),
                                        )),
                                const SizedBox(height: 24),
                              ],

                              // Daily Intention Style
                              if (dominant
                                  .getDailyIntentionStyle(
                                      language: language)
                                  .isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Your Daily Practice'
                                      : 'Günlük Pratiğin',
                                  variant:
                                      GradientTextVariant.gold,
                                  style:
                                      AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                PremiumCard(
                                  style:
                                      PremiumCardStyle.subtle,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(
                                            16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration:
                                              BoxDecoration(
                                            shape:
                                                BoxShape.circle,
                                            color: AppColors
                                                .starGold
                                                .withValues(
                                                    alpha:
                                                        0.12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              dominant.emoji,
                                              style:
                                                  const TextStyle(
                                                      fontSize:
                                                          18),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 12),
                                        Expanded(
                                          child: Text(
                                            dominant.getDailyIntentionStyle(
                                                language:
                                                    language),
                                            style: AppTypography
                                                .decorativeScript(
                                              fontSize: 13,
                                              color: isDark
                                                  ? AppColors
                                                      .textSecondary
                                                  : AppColors
                                                      .lightTextSecondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Shadow Integration
                              GradientText(
                                isEn
                                    ? 'Shadow to Integrate'
                                    : 'Bütünleştirilecek Gölge',
                                variant:
                                    GradientTextVariant.amethyst,
                                style:
                                    AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding:
                                    const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.amethyst
                                      .withValues(
                                          alpha: 0.06),
                                  borderRadius:
                                      BorderRadius.circular(
                                          14),
                                  border: Border.all(
                                    color: AppColors.amethyst
                                        .withValues(
                                            alpha: 0.12),
                                  ),
                                ),
                                child: Text(
                                  dominant.getShadow(
                                      language: language),
                                  style: AppTypography
                                      .decorativeScript(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors
                                            .textSecondary
                                        : AppColors
                                            .lightTextSecondary,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Compatible Archetypes
                              if (dominant.compatibleArchetypes
                                  .isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Compatible Archetypes'
                                      : 'Uyumlu Arketipler',
                                  variant:
                                      GradientTextVariant.aurora,
                                  style:
                                      AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: dominant
                                      .compatibleArchetypes
                                      .map((id) {
                                    final arch = ArchetypeService
                                        .archetypes
                                        .where((a) =>
                                            a.id == id)
                                        .firstOrNull;
                                    if (arch == null) {
                                      return const SizedBox
                                          .shrink();
                                    }
                                    return _CompatibleChip(
                                      archetype: arch,
                                      language: language,
                                      isDark: isDark,
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Secondary archetypes
                              if (secondaries.isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Secondary Influences'
                                      : 'İkincil Etkiler',
                                  variant:
                                      GradientTextVariant.gold,
                                  style:
                                      AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...secondaries.map((e) {
                                  final arch = ArchetypeService
                                      .archetypes
                                      .where(
                                          (a) => a.id == e.key)
                                      .firstOrNull;
                                  if (arch == null) {
                                    return const SizedBox
                                        .shrink();
                                  }
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(
                                            bottom: 8),
                                    child: _SecondaryRow(
                                      archetype: arch,
                                      percentage: e.value,
                                      maxPercentage:
                                          sortedBreakdown
                                              .first.value,
                                      language: language,
                                      isDark: isDark,
                                    ),
                                  );
                                }),
                                const SizedBox(height: 24),
                              ],

                              // Evolution (if snapshots exist)
                              if (snapshots.length > 1) ...[
                                GradientText(
                                  isEn
                                      ? 'Evolution Path'
                                      : 'Evrim Yolu',
                                  variant: GradientTextVariant
                                      .amethyst,
                                  style:
                                      AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _EvolutionTimeline(
                                  snapshots: snapshots,
                                  language: language,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 24),
                              ],

                              const SizedBox(height: 16),
                              Center(
                                child: Text(
                                  isEn
                                      ? 'Based on your journal entries, not a clinical assessment'
                                      : 'Günlük kayıtlarına dayalı, klinik bir değerlendirme değil',
                                  style: AppTypography.subtitle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textMuted
                                        : AppColors
                                            .lightTextMuted,
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ArchetypeHero extends StatelessWidget {
  final Archetype archetype;
  final double confidence;
  final AppLanguage language;
  final bool isDark;

  const _ArchetypeHero({
    required this.archetype,
    required this.confidence,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.amethyst,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(archetype.emoji,
                style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              archetype.getName(language: language),
              style: AppTypography.modernAccent(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(confidence * 100).round()}% ${language == AppLanguage.en ? 'alignment' : 'uyum'}',
              style: AppTypography.elegantAccent(
                fontSize: 12,
                color: AppColors.amethyst,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              archetype.getGrowthTip(language: language),
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 13,
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

class _GrowthAreaCard extends StatelessWidget {
  final int index;
  final String text;
  final bool isDark;

  const _GrowthAreaCard({
    required this.index,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.auroraStart.withValues(alpha: 0.15),
            ),
            child: Center(
              child: Text(
                '$index',
                style: AppTypography.modernAccent(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.auroraStart,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.subtitle(
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
}

class _CompatibleChip extends StatelessWidget {
  final Archetype archetype;
  final AppLanguage language;
  final bool isDark;

  const _CompatibleChip({
    required this.archetype,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.auroraStart.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.auroraStart.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(archetype.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            archetype.getName(language: language),
            style: AppTypography.modernAccent(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryRow extends StatelessWidget {
  final Archetype archetype;
  final double percentage;
  final double maxPercentage;
  final AppLanguage language;
  final bool isDark;

  const _SecondaryRow({
    required this.archetype,
    required this.percentage,
    required this.maxPercentage,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxPercentage > 0 ? percentage / maxPercentage : 0.0;

    return Row(
      children: [
        Text(archetype.emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(
            archetype.getName(language: language),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.modernAccent(
              fontSize: 12,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
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
              valueColor: AlwaysStoppedAnimation(AppColors.starGold),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            '${percentage.round()}%',
            textAlign: TextAlign.end,
            style: AppTypography.modernAccent(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
            ),
          ),
        ),
      ],
    );
  }
}

class _EvolutionTimeline extends StatelessWidget {
  final List<ArchetypeSnapshot> snapshots;
  final AppLanguage language;
  final bool isDark;

  const _EvolutionTimeline({
    required this.snapshots,
    required this.language,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: snapshots.asMap().entries.map((e) {
          final snap = e.value;
          final isLast = e.key == snapshots.length - 1;
          final arch = ArchetypeService.archetypes
              .where((a) => a.id == snap.archetypeId)
              .firstOrNull;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot + line
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLast
                            ? AppColors.amethyst
                            : AppColors.amethyst
                                .withValues(alpha: 0.4),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 1,
                        height: 28,
                        color: AppColors.amethyst
                            .withValues(alpha: 0.2),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        arch?.emoji ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          arch?.getName(language: language) ?? snap.archetypeId,
                          style: AppTypography.modernAccent(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${snap.month}/${snap.year}',
                        style: AppTypography.subtitle(
                          fontSize: 10,
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
          );
        }).toList(),
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
          title: isEn ? 'Growth Profile' : 'Gelişim Profili',
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
                      const Text('\u{2728}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Write at least 3 journal entries to discover your archetype growth path'
                            : 'Arketip gelişim yolunu keşfetmek için en az 3 günlük kaydı yaz',
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
