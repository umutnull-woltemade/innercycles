// ════════════════════════════════════════════════════════════════════════════
// DREAM MEMORY ANALYTICS SCREEN - Symbol patterns, streaks & emotional profile
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/dream_memory.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class DreamMemoryAnalyticsScreen extends ConsumerWidget {
  const DreamMemoryAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(dreamMemoryServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              return FutureBuilder<DreamMemory>(
                future: service.getDreamMemory(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  final memory = snapshot.data!;
                  final milestones = memory.milestones;

                  if (milestones.dreamCount == 0) {
                    return _EmptyState(isEn: isEn, isDark: isDark);
                  }

                  final recurring = memory.recurringSymbols;
                  final themes = memory.themes.entries.toList()
                    ..sort((a, b) => b.value.count.compareTo(a.value.count));
                  final profile = memory.emotionalProfile;

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      GlassSliverAppBar(
                        title: isEn
                            ? 'Dream Memory'
                            : 'Rüya Hafızası',
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
                                    ? 'Your subconscious patterns over time'
                                    : 'Zaman içindeki bilinçaltı kalıpların',
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
                                milestones: milestones,
                                symbolCount: memory.symbols.length,
                                themeCount: memory.themes.length,
                                isEn: isEn,
                                isDark: isDark,
                              ).animate().fadeIn(duration: 400.ms),

                              const SizedBox(height: 24),

                              // Emotional profile
                              if (profile.dominantTones
                                  .isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Emotional Profile'
                                      : 'Duygusal Profil',
                                  variant:
                                      GradientTextVariant.amethyst,
                                  style: AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _EmotionalProfileCard(
                                  profile: profile,
                                  isEn: isEn,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Recurring symbols
                              if (recurring.isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Recurring Symbols (${recurring.length})'
                                      : 'Tekrarlayan Semboller (${recurring.length})',
                                  variant: GradientTextVariant.gold,
                                  style: AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...recurring.take(10).map(
                                      (entry) => Padding(
                                        padding:
                                            const EdgeInsets.only(
                                                bottom: 8),
                                        child: _SymbolRow(
                                          symbol: entry.key,
                                          occurrence: entry.value,
                                          maxCount:
                                              recurring.first.value
                                                  .count,
                                          isEn: isEn,
                                          isDark: isDark,
                                        ),
                                      ),
                                    ),
                                const SizedBox(height: 24),
                              ],

                              // All symbols cloud
                              if (memory.symbols.isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Symbol Universe'
                                      : 'Sembol Evreni',
                                  variant:
                                      GradientTextVariant.aurora,
                                  style: AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _SymbolCloud(
                                  symbols: memory.symbols,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Themes
                              if (themes.isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Dream Themes'
                                      : 'Rüya Temaları',
                                  variant:
                                      GradientTextVariant.amethyst,
                                  style: AppTypography.modernAccent(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: themes
                                      .take(12)
                                      .map((e) => _ThemeChip(
                                            theme: e.key,
                                            count: e.value.count,
                                            isDark: isDark,
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Achievements
                              if (milestones
                                  .achievements.isNotEmpty) ...[
                                GradientText(
                                  isEn
                                      ? 'Achievements'
                                      : 'Başarımlar',
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
                                  children: milestones.achievements
                                      .map((a) =>
                                          _AchievementBadge(
                                            id: a,
                                            isEn: isEn,
                                            isDark: isDark,
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Caption
                              Center(
                                child: Text(
                                  isEn
                                      ? 'Based on ${milestones.dreamCount} dream entries'
                                      : '${milestones.dreamCount} rüya kaydına dayalı',
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OverviewHero extends StatelessWidget {
  final DreamMilestones milestones;
  final int symbolCount;
  final int themeCount;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.milestones,
    required this.symbolCount,
    required this.themeCount,
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
            _Stat(
              value: '${milestones.dreamCount}',
              label: isEn ? 'Dreams' : 'Rüya',
              color: AppColors.amethyst,
              isDark: isDark,
            ),
            _Stat(
              value: '${milestones.isStreakActive ? milestones.currentStreak : 0}',
              label: isEn ? 'Streak' : 'Seri',
              color: AppColors.starGold,
              isDark: isDark,
            ),
            _Stat(
              value: '$symbolCount',
              label: isEn ? 'Symbols' : 'Sembol',
              color: AppColors.auroraStart,
              isDark: isDark,
            ),
            _Stat(
              value: '$themeCount',
              label: isEn ? 'Themes' : 'Tema',
              color: AppColors.chartBlue,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _Stat({
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
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 10,
            color:
                isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _EmotionalProfileCard extends StatelessWidget {
  final EmotionalProfile profile;
  final bool isEn;
  final bool isDark;

  const _EmotionalProfileCard({
    required this.profile,
    required this.isEn,
    required this.isDark,
  });

  String _trendLabel(String trend) {
    switch (trend) {
      case 'processing':
        return isEn ? 'Processing' : 'İşleniyor';
      case 'integrating':
        return isEn ? 'Integrating' : 'Bütünleşiyor';
      case 'seeking':
        return isEn ? 'Seeking' : 'Arıyor';
      default:
        return trend;
    }
  }

  Color _trendColor(String trend) {
    switch (trend) {
      case 'processing':
        return AppColors.starGold;
      case 'integrating':
        return AppColors.success;
      case 'seeking':
        return AppColors.amethyst;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trendColor = _trendColor(profile.recentTrend);
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
              Text(
                isEn ? 'Current Trend' : 'Mevcut Eğilim',
                style: AppTypography.elegantAccent(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: trendColor.withValues(alpha: 0.12),
                ),
                child: Text(
                  _trendLabel(profile.recentTrend),
                  style: AppTypography.modernAccent(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: trendColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isEn ? 'Dominant Tones' : 'Baskın Tonlar',
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: profile.dominantTones.map((tone) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.amethyst
                      .withValues(alpha: 0.1),
                ),
                child: Text(
                  tone,
                  style: AppTypography.elegantAccent(
                    fontSize: 11,
                    color: AppColors.amethyst,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SymbolRow extends StatelessWidget {
  final String symbol;
  final SymbolOccurrence occurrence;
  final int maxCount;
  final bool isEn;
  final bool isDark;

  const _SymbolRow({
    required this.symbol,
    required this.occurrence,
    required this.maxCount,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dreamSymbol = DreamSymbol.commonSymbols[symbol];
    final emoji = dreamSymbol?.emoji ?? '\u{1F52E}';
    final ratio = maxCount > 0 ? occurrence.count / maxCount : 0.0;

    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            dreamSymbol != null
                ? (isEn ? dreamSymbol.name : dreamSymbol.nameTr)
                : symbol,
            style: AppTypography.modernAccent(
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
              valueColor:
                  AlwaysStoppedAnimation(AppColors.starGold),
              minHeight: 5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            '${occurrence.count}x',
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

class _SymbolCloud extends StatelessWidget {
  final Map<String, SymbolOccurrence> symbols;
  final bool isDark;

  const _SymbolCloud({required this.symbols, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final sorted = symbols.entries.toList()
      ..sort((a, b) => b.value.count.compareTo(a.value.count));
    final maxCount = sorted.isNotEmpty ? sorted.first.value.count : 1;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: sorted.take(20).map((entry) {
        final dreamSymbol = DreamSymbol.commonSymbols[entry.key];
        final emoji = dreamSymbol?.emoji ?? '\u{1F52E}';
        final relative =
            maxCount > 0 ? entry.value.count / maxCount : 0.5;
        final fontSize = 10.0 + relative * 6.0;

        return Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.auroraStart
                .withValues(alpha: 0.06 + relative * 0.12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji,
                  style: TextStyle(fontSize: fontSize)),
              const SizedBox(width: 4),
              Text(
                '${entry.value.count}',
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: AppColors.auroraStart,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String theme;
  final int count;
  final bool isDark;

  const _ThemeChip({
    required this.theme,
    required this.count,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.amethyst.withValues(alpha: 0.1),
      ),
      child: Text(
        '$theme \u{00D7}$count',
        style: AppTypography.elegantAccent(
          fontSize: 12,
          color: AppColors.amethyst,
        ),
      ),
    );
  }
}

String _achievementLabel(String id, bool isEn) {
  switch (id) {
    case 'first_10':
      return isEn ? 'First 10 Dreams' : 'İlk 10 Rüya';
    case 'dream_explorer':
      return isEn ? 'Dream Explorer (50)' : 'Rüya Kaşifi (50)';
    case 'dream_master':
      return isEn ? 'Dream Master (100)' : 'Rüya Ustası (100)';
    case 'week_streak':
      return isEn ? '7-Day Streak' : '7 Günlük Seri';
    case 'month_streak':
      return isEn ? '30-Day Streak' : '30 Günlük Seri';
    default:
      return id;
  }
}

String _achievementEmoji(String id) {
  switch (id) {
    case 'first_10':
      return '\u{1F31F}';
    case 'dream_explorer':
      return '\u{1F30D}';
    case 'dream_master':
      return '\u{1F451}';
    case 'week_streak':
      return '\u{1F525}';
    case 'month_streak':
      return '\u{1F3C6}';
    default:
      return '\u{2B50}';
  }
}

class _AchievementBadge extends StatelessWidget {
  final String id;
  final bool isEn;
  final bool isDark;

  const _AchievementBadge({
    required this.id,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.starGold.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_achievementEmoji(id),
              style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            _achievementLabel(id, isEn),
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: AppColors.starGold,
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
          title: isEn ? 'Dream Memory' : 'Rüya Hafızası',
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
                      const Text('\u{1F319}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Start logging dreams to build your dream memory'
                            : 'Rüya hafızanı oluşturmak için rüya kaydetmeye başla',
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
