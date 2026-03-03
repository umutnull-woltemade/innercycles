// ════════════════════════════════════════════════════════════════════════════
// BOND TOUCH TIMELINE - Touch history & connection analytics
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/bond.dart';
import '../../../data/providers/bond_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class BondTouchTimelineScreen extends ConsumerWidget {
  final String bondId;

  const BondTouchTimelineScreen({super.key, required this.bondId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final touchServiceAsync = ref.watch(touchServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: touchServiceAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text(
                isEn ? 'Something went wrong' : 'Bir şeyler ters gitti',
                style: AppTypography.subtitle(
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            data: (touchService) {
              return FutureBuilder<List<Touch>>(
                future: touchService.getRecentTouches(bondId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final touches = snapshot.data ?? [];

                  if (touches.isEmpty) {
                    return _EmptyState(isEn: isEn, isDark: isDark);
                  }

                  // Stats
                  final unseen =
                      touches.where((t) => !t.isSeen).length;
                  final typeCounts = <TouchType, int>{};
                  for (final t in touches) {
                    typeCounts[t.touchType] =
                        (typeCounts[t.touchType] ?? 0) + 1;
                  }

                  // Group by date
                  final grouped = <String, List<Touch>>{};
                  for (final t in touches) {
                    final key =
                        '${t.createdAt.year}-${t.createdAt.month.toString().padLeft(2, '0')}-${t.createdAt.day.toString().padLeft(2, '0')}';
                    grouped.putIfAbsent(key, () => []).add(t);
                  }
                  final sortedDates = grouped.keys.toList()
                    ..sort((a, b) => b.compareTo(a));

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      GlassSliverAppBar(
                        title: isEn
                            ? 'Touch Timeline'
                            : 'Dokunuş Zaman Çizelgesi',
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
                                    ? 'Your connection moments'
                                    : 'Bağlantı anların',
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

                              // Overview hero
                              _TouchOverview(
                                total: touches.length,
                                unseen: unseen,
                                typeCounts: typeCounts,
                                isEn: isEn,
                                isDark: isDark,
                              )
                                  .animate()
                                  .fadeIn(duration: 400.ms),

                              const SizedBox(height: 24),

                              // Touch types breakdown
                              if (typeCounts.length > 1) ...[
                                GradientText(
                                  isEn
                                      ? 'Touch Types'
                                      : 'Dokunuş Türleri',
                                  variant:
                                      GradientTextVariant.gold,
                                  style:
                                      AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _TouchTypeBreakdown(
                                  counts: typeCounts,
                                  total: touches.length,
                                  isEn: isEn,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Timeline
                              GradientText(
                                isEn
                                    ? 'Recent Touches'
                                    : 'Son Dokunuşlar',
                                variant:
                                    GradientTextVariant.aurora,
                                style:
                                    AppTypography.modernAccent(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),

                              ...sortedDates.map((dateKey) {
                                final dayTouches =
                                    grouped[dateKey]!;
                                final parts =
                                    dateKey.split('-');
                                final dateLabel =
                                    '${parts[2]}/${parts[1]}/${parts[0]}';

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets
                                              .only(
                                              bottom: 8,
                                              top: 4),
                                      child: Text(
                                        dateLabel,
                                        style: AppTypography
                                            .modernAccent(
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.w600,
                                          color: isDark
                                              ? AppColors
                                                  .textSecondary
                                              : AppColors
                                                  .lightTextSecondary,
                                        ),
                                      ),
                                    ),
                                    ...dayTouches.map(
                                      (touch) => Padding(
                                        padding:
                                            const EdgeInsets
                                                .only(
                                                bottom: 6),
                                        child: _TouchRow(
                                          touch: touch,
                                          isEn: isEn,
                                          isDark: isDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                );
                              }),

                              const SizedBox(height: 16),
                              Center(
                                child: Text(
                                  isEn
                                      ? '${touches.length} touches in your connection'
                                      : '${touches.length} dokunuş bağlantınızda',
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

class _TouchOverview extends StatelessWidget {
  final int total;
  final int unseen;
  final Map<TouchType, int> typeCounts;
  final bool isEn;
  final bool isDark;

  const _TouchOverview({
    required this.total,
    required this.unseen,
    required this.typeCounts,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Most used type
    TouchType? topType;
    int topCount = 0;
    for (final e in typeCounts.entries) {
      if (e.value > topCount) {
        topCount = e.value;
        topType = e.key;
      }
    }

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
                  style: AppTypography.modernAccent(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.auroraStart,
                  ),
                ),
                Text(
                  isEn ? 'Touches' : 'Dokunuş',
                  style: AppTypography.elegantAccent(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
            if (unseen > 0)
              Column(
                children: [
                  Text(
                    '$unseen',
                    style: AppTypography.modernAccent(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brandPink,
                    ),
                  ),
                  Text(
                    isEn ? 'New' : 'Yeni',
                    style: AppTypography.elegantAccent(
                      fontSize: 9,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            if (topType != null)
              Column(
                children: [
                  Text(
                    topType.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    isEn ? 'Most Used' : 'En \u00C7ok',
                    style: AppTypography.elegantAccent(
                      fontSize: 9,
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

class _TouchTypeBreakdown extends StatelessWidget {
  final Map<TouchType, int> counts;
  final int total;
  final bool isEn;
  final bool isDark;

  const _TouchTypeBreakdown({
    required this.counts,
    required this.total,
    required this.isEn,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: TouchType.values.map((type) {
          final count = counts[type] ?? 0;
          final ratio = total > 0 ? count / total : 0.0;
          return Column(
            children: [
              Text(type.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: AppTypography.modernAccent(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${(ratio * 100).round()}%',
                style: AppTypography.subtitle(
                  fontSize: 9,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEn ? type.displayNameEn : type.displayNameTr,
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _TouchRow extends StatelessWidget {
  final Touch touch;
  final bool isEn;
  final bool isDark;

  const _TouchRow({
    required this.touch,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final time =
        '${touch.createdAt.hour.toString().padLeft(2, '0')}:${touch.createdAt.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
        border: !touch.isSeen
            ? Border.all(
                color: AppColors.brandPink.withValues(alpha: 0.2),
              )
            : null,
      ),
      child: Row(
        children: [
          Text(touch.touchType.emoji,
              style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isEn
                  ? touch.touchType.displayNameEn
                  : touch.touchType.displayNameTr,
              style: AppTypography.modernAccent(
                fontSize: 12,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          if (!touch.isSeen)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.brandPink.withValues(alpha: 0.12),
              ),
              child: Text(
                isEn ? 'New' : 'Yeni',
                style: AppTypography.elegantAccent(
                  fontSize: 9,
                  color: AppColors.brandPink,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            time,
            style: AppTypography.subtitle(
              fontSize: 10,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
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
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        GlassSliverAppBar(
          title: isEn ? 'Touch Timeline' : 'Dokunuş Zaman Çizelgesi',
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
                      const Text('\u{1FAF6}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Send your first touch to start building your connection timeline'
                            : 'Bağlantı zaman çizelgeni oluşturmak için ilk dokunuşunu gönder',
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
