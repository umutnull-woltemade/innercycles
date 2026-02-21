// ════════════════════════════════════════════════════════════════════════════
// ARCHETYPE EVOLUTION SCREEN - Jungian Self-Reflection Dashboard
// ════════════════════════════════════════════════════════════════════════════
// Displays the user's dominant archetype, strengths/shadow, growth tip,
// evolution timeline, and full breakdown chart. Based on journal patterns.
//
// IMPORTANT: This is a self-reflection tool, NOT a personality test.
// All language is safe, reflective, and non-prescriptive.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/archetype_service.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';

class ArchetypeScreen extends ConsumerWidget {
  const ArchetypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;

    final archetypeAsync = ref.watch(archetypeServiceProvider);
    final journalAsync = ref.watch(journalServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: isEn ? 'Your Archetype' : 'Arketip Profilin',
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: archetypeAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CosmicLoadingIndicator()),
                    ),
                    error: (e, s) => SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          isEn ? 'Could not load. Your local data is unaffected.' : 'Yüklenemedi. Yerel verileriniz etkilenmedi.',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                    ),
                    data: (archetypeService) {
                      return journalAsync.when(
                        loading: () => const SliverToBoxAdapter(
                          child: Center(child: CosmicLoadingIndicator()),
                        ),
                        error: (e, s) => SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              isEn
                                  ? 'Could not load. Your local data is unaffected.'
                                  : 'Yüklenemedi. Yerel verileriniz etkilenmedi.',
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
                              ),
                            ),
                          ),
                        ),
                        data: (journalService) {
                          final entries = journalService.getAllEntries();

                          if (!archetypeService.hasEnoughData(entries)) {
                            return SliverToBoxAdapter(
                              child: _EmptyState(isDark: isDark, isEn: isEn),
                            );
                          }

                          // Try saving monthly snapshot
                          archetypeService.saveMonthlySnapshot(entries);

                          final result = archetypeService.getCurrentArchetype(
                            entries,
                          );
                          if (result == null) {
                            return SliverToBoxAdapter(
                              child: _EmptyState(isDark: isDark, isEn: isEn),
                            );
                          }

                          final history = archetypeService.getRecentSnapshots(
                            count: 6,
                          );

                          return SliverList(
                            delegate: SliverChildListDelegate([
                              _DominantArchetypeCard(
                                result: result,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                              const SizedBox(height: 20),
                              _StrengthsShadowSection(
                                archetype: result.dominant,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                              const SizedBox(height: 20),
                              _GrowthTipCard(
                                archetype: result.dominant,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                              const SizedBox(height: 24),
                              if (history.isNotEmpty) ...[
                                _EvolutionTimeline(
                                  snapshots: history,
                                  isDark: isDark,
                                  isEn: isEn,
                                ),
                                const SizedBox(height: 24),
                              ],
                              _BreakdownChart(
                                breakdown: result.breakdown,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                              const SizedBox(height: 20),
                              _DisclaimerCard(isDark: isDark, isEn: isEn),
                              const SizedBox(height: 20),
                              _ShareArchetypeButton(
                                archetype: result.dominant,
                                isDark: isDark,
                                isEn: isEn,
                              ),
                              const SizedBox(height: 20),
                              ContentDisclaimer(language: language),
                              ToolEcosystemFooter(
                                currentToolId: 'archetype',
                                isEn: isEn,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 40),
                            ]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DOMINANT ARCHETYPE CARD
// ═══════════════════════════════════════════════════════════════════════════

class _DominantArchetypeCard extends StatelessWidget {
  final ArchetypeResult result;
  final bool isDark;
  final bool isEn;

  const _DominantArchetypeCard({
    required this.result,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final archetype = result.dominant;
    final confidencePct = (result.confidence * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.cosmicPurple.withValues(alpha: 0.9),
                  AppColors.nebulaPurple.withValues(alpha: 0.9),
                ]
              : [AppColors.lightCard, AppColors.lightSurfaceVariant],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.starGold.withValues(alpha: 0.3)
              : AppColors.lightStarGold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.auroraStart.withValues(
              alpha: isDark ? 0.15 : 0.08,
            ),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Emoji
          Text(archetype.emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 12),
          // Name
          Text(
            archetype.getName(isEnglish: isEn),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
            ),
          ),
          const SizedBox(height: 8),
          // Confidence badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.auroraStart.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isEn ? '$confidencePct% alignment' : '%$confidencePct uyum',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.auroraStart,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            archetype.getDescription(isEnglish: isEn),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STRENGTHS & SHADOW SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _StrengthsShadowSection extends StatelessWidget {
  final Archetype archetype;
  final bool isDark;
  final bool isEn;

  const _StrengthsShadowSection({
    required this.archetype,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final strengths = archetype.getStrengths(isEnglish: isEn);
    final shadow = archetype.getShadow(isEnglish: isEn);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Strengths
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: AppColors.starGold),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Strengths' : 'Güçlü Yönler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: strengths
                .map((s) => _StrengthChip(label: s, isDark: isDark))
                .toList(),
          ),
          const SizedBox(height: 24),
          // Shadow
          Row(
            children: [
              Icon(
                Icons.nights_stay_outlined,
                size: 18,
                color: AppColors.cosmicPurple.withValues(
                  alpha: isDark ? 1.0 : 0.7,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Shadow Side' : 'Gölge Yönü',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            shadow,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }
}

class _StrengthChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _StrengthChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.success,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// GROWTH TIP CARD
// ═══════════════════════════════════════════════════════════════════════════

class _GrowthTipCard extends StatelessWidget {
  final Archetype archetype;
  final bool isDark;
  final bool isEn;

  const _GrowthTipCard({
    required this.archetype,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.auroraStart.withValues(alpha: 0.12),
                  AppColors.cosmicPurple.withValues(alpha: 0.3),
                ]
              : [
                  AppColors.lightAuroraStart.withValues(alpha: 0.08),
                  AppColors.lightSurfaceVariant,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.auroraStart.withValues(alpha: 0.25)
              : AppColors.lightAuroraStart.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_outlined,
                size: 20,
                color: AppColors.starGold,
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Growth Insight' : 'Büyüme İçgörüsü',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            archetype.getGrowthTip(isEnglish: isEn),
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EVOLUTION TIMELINE (last 6 months)
// ═══════════════════════════════════════════════════════════════════════════

class _EvolutionTimeline extends StatelessWidget {
  final List<ArchetypeSnapshot> snapshots;
  final bool isDark;
  final bool isEn;

  const _EvolutionTimeline({
    required this.snapshots,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.timeline_outlined,
                size: 18,
                color: AppColors.auroraStart,
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Evolution Timeline' : 'Gelişim Zaman Çizgisi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: snapshots.map((snapshot) {
                final archetype = ArchetypeService.getArchetypeById(
                  snapshot.archetypeId,
                );
                final monthLabel = _monthLabel(snapshot.month, isEn);
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        archetype.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        monthLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${(snapshot.confidence * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.auroraStart.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Connecting line
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.auroraStart.withValues(alpha: 0.1),
                  AppColors.auroraStart.withValues(alpha: 0.5),
                  AppColors.starGold.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms, duration: 300.ms);
  }

  String _monthLabel(int month, bool isEn) {
    const en = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const tr = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return isEn ? en[month - 1] : tr[month - 1];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FULL BREAKDOWN BAR CHART
// ═══════════════════════════════════════════════════════════════════════════

class _BreakdownChart extends StatelessWidget {
  final Map<String, double> breakdown;
  final bool isDark;
  final bool isEn;

  const _BreakdownChart({
    required this.breakdown,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    // Sort archetypes by percentage descending
    final sortedIds = breakdown.keys.toList()
      ..sort((a, b) => (breakdown[b] ?? 0).compareTo(breakdown[a] ?? 0));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                size: 18,
                color: AppColors.auroraStart,
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Full Archetype Breakdown' : 'Tam Arketip Dağılımı',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sortedIds.map((id) {
            final archetype = ArchetypeService.getArchetypeById(id);
            final pct = breakdown[id] ?? 0;
            final isTop = sortedIds.indexOf(id) == 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _BreakdownRow(
                archetype: archetype,
                percentage: pct,
                isTop: isTop,
                isDark: isDark,
                isEn: isEn,
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 300.ms);
  }
}

class _BreakdownRow extends StatelessWidget {
  final Archetype archetype;
  final double percentage;
  final bool isTop;
  final bool isDark;
  final bool isEn;

  const _BreakdownRow({
    required this.archetype,
    required this.percentage,
    required this.isTop,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = isTop
        ? AppColors.starGold
        : AppColors.auroraStart.withValues(alpha: 0.7);
    final pctStr = percentage.toStringAsFixed(1);

    return Row(
      children: [
        // Emoji
        SizedBox(
          width: 28,
          child: Text(archetype.emoji, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 4),
        // Name
        SizedBox(
          width: 90,
          child: Text(
            archetype.getName(isEnglish: isEn),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isTop ? FontWeight.w600 : FontWeight.w400,
              color: isDark
                  ? (isTop ? AppColors.textPrimary : AppColors.textSecondary)
                  : (isTop
                        ? AppColors.lightTextPrimary
                        : AppColors.lightTextSecondary),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        // Bar
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (percentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Percentage
        SizedBox(
          width: 42,
          child: Text(
            '$pctStr%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isTop
                  ? AppColors.starGold
                  : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DISCLAIMER CARD
// ═══════════════════════════════════════════════════════════════════════════

class _DisclaimerCard extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _DisclaimerCard({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEn
                  ? 'Your archetype is based on your journal patterns and '
                        'is meant as a self-reflection tool, not a personality '
                        'test. It may shift as your entries evolve over time.'
                  : 'Arketipin günlük kalıplarına dayanıyor ve bir '
                        'kişilik testi değil, öz-yansıtma aracı olarak '
                        'tasarlanmıştır. Kayıtların zaman içinde '
                        'değiştikçe değişebilir.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _EmptyState({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 64,
            color: isDark
                ? AppColors.textMuted.withValues(alpha: 0.5)
                : AppColors.lightTextMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isEn ? 'Nothing recorded yet' : 'Henüz kayıt yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEn
                ? 'Add at least 3 entries to surface your '
                      'dominant archetype'
                : 'Baskın arketipini ortaya çıkarmak için en az 3 '
                      'kayıt ekle',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHARE ARCHETYPE BUTTON
// ═══════════════════════════════════════════════════════════════════════════

class _ShareArchetypeButton extends StatelessWidget {
  final Archetype archetype;
  final bool isDark;
  final bool isEn;

  const _ShareArchetypeButton({
    required this.archetype,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          final name = isEn ? archetype.nameEn : archetype.nameTr;
          final text = isEn
              ? 'My emotional archetype is "$name" — discovered through self-reflection with InnerCycles.\n\n'
                    'What\'s yours? Try it free:\nhttps://apps.apple.com/app/innercycles/id6758612716'
              : 'Duygusal arketipim "$name" — InnerCycles ile kendimi keşfederek buldum.\n\n'
                    'Seninki ne? Ücretsiz dene:\nhttps://apps.apple.com/app/innercycles/id6758612716';
          SharePlus.instance.share(ShareParams(text: text));
        },
        icon: const Icon(Icons.share_rounded, size: 18),
        label: Text(
          isEn ? 'Share Your Archetype' : 'Arketipini Paylaş',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amethyst.withValues(alpha: 0.15),
          foregroundColor: AppColors.amethyst,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.amethyst.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }
}
