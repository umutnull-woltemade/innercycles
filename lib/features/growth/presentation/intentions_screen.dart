// ════════════════════════════════════════════════════════════════════════════
// INTENTIONS SCREEN - Weekly intentions board with history
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/intention.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/sparkline_chart.dart';

class IntentionsScreen extends ConsumerStatefulWidget {
  const IntentionsScreen({super.key});

  @override
  ConsumerState<IntentionsScreen> createState() => _IntentionsScreenState();
}

class _IntentionsScreenState extends ConsumerState<IntentionsScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = ref.watch(languageProvider) == AppLanguage.en;
    final serviceAsync = ref.watch(intentionServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: serviceAsync.maybeWhen(
        data: (service) {
          final current = service.getCurrentWeekIntentions();
          final averages = service.getWeeklyAverages(weeks: 12);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              GlassSliverAppBar(
                title: isEn ? 'Intentions' : 'Niyetler',
              ),

              // Sparkline history
              if (averages.any((a) => a > 0))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.04),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn ? '12-Week Trend' : '12 Haftalık Trend',
                            style: AppTypography.subtitle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: SparklineChart(
                              data: averages,
                              minValue: 0,
                              maxValue: 5,
                              lineColor: AppColors.starGold,
                              fillColor:
                                  AppColors.starGold.withValues(alpha: 0.1),
                              width: MediaQuery.sizeOf(context).width - 80,
                              height: 60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                ),

              // Current week header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: Text(
                    isEn ? 'This Week' : 'Bu Hafta',
                    style: AppTypography.displayFont.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),

              // Current intentions
              if (current.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      isEn
                          ? 'No intentions set yet. Add up to 3 below.'
                          : 'Henüz niyet belirlenmedi. Aşağıdan 3\'e kadar ekle.',
                      style: AppTypography.subtitle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final intention = current[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 4),
                      child: _IntentionTile(
                        intention: intention,
                        isDark: isDark,
                        isEn: isEn,
                        onRate: (rating) async {
                          await service.rateIntention(intention.id, rating);
                          ref.invalidate(intentionServiceProvider);
                        },
                        onDelete: () async {
                          await service.delete(intention.id);
                          ref.invalidate(intentionServiceProvider);
                        },
                      ),
                    ).animate().fadeIn(
                        delay: (50 * index).ms, duration: 200.ms);
                  },
                  childCount: current.length,
                ),
              ),

              // Add new intention
              if (current.length < 3)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.04),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: AppTypography.subtitle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: isEn
                                    ? 'Add an intention...'
                                    : 'Bir niyet ekle...',
                                hintStyle: AppTypography.subtitle(
                                  fontSize: 14,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (text) async {
                                if (text.trim().isEmpty) return;
                                await service.addIntention(text.trim());
                                _controller.clear();
                                ref.invalidate(intentionServiceProvider);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_rounded,
                                color: AppColors.starGold),
                            onPressed: () async {
                              final text = _controller.text.trim();
                              if (text.isEmpty) return;
                              await service.addIntention(text);
                              _controller.clear();
                              ref.invalidate(intentionServiceProvider);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Row(
                    children: [
                      _StatChip(
                        label: isEn ? 'Total' : 'Toplam',
                        value: '${service.totalCount}',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 12),
                      _StatChip(
                        label: isEn ? 'Active Weeks' : 'Aktif Hafta',
                        value: '${service.activeWeeksCount}',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
          orElse: () => const Center(child: CupertinoActivityIndicator()),
        ),
      ),
    );
  }
}

class _IntentionTile extends StatelessWidget {
  final Intention intention;
  final bool isDark;
  final bool isEn;
  final ValueChanged<int> onRate;
  final VoidCallback onDelete;

  const _IntentionTile({
    required this.intention,
    required this.isDark,
    required this.isEn,
    required this.onRate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  intention.text,
                  style: AppTypography.subtitle(
                    fontSize: 14,
                    color:
                        isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.close_rounded,
                    size: 16,
                    color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Rating row
          Row(
            children: [
              Text(
                intention.selfRating != null
                    ? (isEn ? 'Rated' : 'Puanlandı')
                    : (isEn ? 'How present were you?' : 'Ne kadar uyguladın?'),
                style: AppTypography.subtitle(
                  fontSize: 11,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                ),
              ),
              const Spacer(),
              ...List.generate(5, (i) {
                final rating = i + 1;
                final isSelected =
                    intention.selfRating != null && intention.selfRating! >= rating;
                return GestureDetector(
                  onTap: () => onRate(rating),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.starGold
                            : (isDark ? Colors.white : Colors.black)
                                .withValues(alpha: 0.06),
                      ),
                      child: Center(
                        child: Text(
                          '$rating',
                          style: AppTypography.subtitle(
                            fontSize: 12,
                            color: isSelected
                                ? AppColors.deepSpace
                                : (isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatChip({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.displayFont.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            label,
            style: AppTypography.subtitle(
              fontSize: 10,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
