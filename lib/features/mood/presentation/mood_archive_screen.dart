// ════════════════════════════════════════════════════════════════════════════
// MOOD ARCHIVE SCREEN - Full mood check-in history & analytics
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/mood_checkin_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class MoodArchiveScreen extends ConsumerWidget {
  const MoodArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(moodCheckinServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => Center(child: CupertinoActivityIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final entries = service.getAllEntries();

              if (entries.isEmpty) {
                return _EmptyState(isEn: isEn, isDark: isDark);
              }

              final sorted = List<MoodEntry>.from(entries)
                ..sort((a, b) => b.date.compareTo(a.date));

              // Mood distribution (1-5)
              final moodCounts = <int, int>{};
              for (final e in sorted) {
                moodCounts[e.mood] = (moodCounts[e.mood] ?? 0) + 1;
              }

              // Quadrant distribution
              final quadrantCounts = <String, int>{};
              for (final e in sorted) {
                if (e.quadrant != null) {
                  quadrantCounts[e.quadrant!] =
                      (quadrantCounts[e.quadrant!] ?? 0) + 1;
                }
              }

              // Emotion frequency
              final emotionCounts = <String, int>{};
              for (final e in sorted) {
                for (final emotion in e.selectedEmotions) {
                  emotionCounts[emotion] =
                      (emotionCounts[emotion] ?? 0) + 1;
                }
              }
              final sortedEmotions = emotionCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              // Average mood
              final avgMood =
                  sorted.map((e) => e.mood).reduce((a, b) => a + b) /
                      sorted.length;

              // Average energy
              final energyEntries =
                  sorted.where((e) => e.energy != null).toList();
              final avgEnergy = energyEntries.isNotEmpty
                  ? energyEntries
                          .map((e) => e.energy!)
                          .reduce((a, b) => a + b) /
                      energyEntries.length
                  : 0.0;

              // Emoji frequency
              final emojiCounts = <String, int>{};
              for (final e in sorted) {
                if (e.emoji.isNotEmpty) {
                  emojiCounts[e.emoji] =
                      (emojiCounts[e.emoji] ?? 0) + 1;
                }
              }
              final sortedEmojis = emojiCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Mood Archive' : 'Ruh Hali Arşivi',
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
                                ? 'Your emotional landscape over time'
                                : 'Zaman içindeki duygusal manzaran',
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
                            totalEntries: sorted.length,
                            avgMood: avgMood,
                            avgEnergy: avgEnergy,
                            topEmoji: sortedEmojis.isNotEmpty
                                ? sortedEmojis.first.key
                                : '',
                            isEn: isEn,
                            isDark: isDark,
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 24),

                          // Mood distribution
                          GradientText(
                            isEn
                                ? 'Mood Distribution'
                                : 'Ruh Hali Dağılımı',
                            variant: GradientTextVariant.gold,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _MoodDistribution(
                            counts: moodCounts,
                            total: sorted.length,
                            isDark: isDark,
                          ),

                          const SizedBox(height: 24),

                          // Quadrant breakdown
                          if (quadrantCounts.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Signal Quadrants'
                                  : 'Sinyal Kadranları',
                              variant: GradientTextVariant.aurora,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _QuadrantBreakdown(
                              counts: quadrantCounts,
                              total: quadrantCounts.values
                                  .fold(0, (a, b) => a + b),
                              isEn: isEn,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Emoji cloud
                          if (sortedEmojis.length > 2) ...[
                            GradientText(
                              isEn
                                  ? 'Most Used Emojis'
                                  : 'En Çok Kullanılan Emojiler',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _EmojiCloud(
                              emojis: sortedEmojis.take(12).toList(),
                              isDark: isDark,
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Top emotions
                          if (sortedEmotions.isNotEmpty) ...[
                            GradientText(
                              isEn
                                  ? 'Frequent Emotions'
                                  : 'Sık Yaşanan Duygular',
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
                              children: sortedEmotions
                                  .take(15)
                                  .map((e) => _EmotionChip(
                                        emotion: e.key,
                                        count: e.value,
                                        maxCount:
                                            sortedEmotions.first.value,
                                        isDark: isDark,
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Recent entries
                          GradientText(
                            isEn
                                ? 'Recent Check-ins'
                                : 'Son Kayıtlar',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...sorted.take(20).map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 6),
                                  child: _MoodEntryRow(
                                    entry: entry,
                                    isEn: isEn,
                                    isDark: isDark,
                                  ),
                                ),
                              ),

                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              isEn
                                  ? '${sorted.length} mood check-ins recorded'
                                  : '${sorted.length} ruh hali kaydı',
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

class _OverviewHero extends StatelessWidget {
  final int totalEntries;
  final double avgMood;
  final double avgEnergy;
  final String topEmoji;
  final bool isEn;
  final bool isDark;

  const _OverviewHero({
    required this.totalEntries,
    required this.avgMood,
    required this.avgEnergy,
    required this.topEmoji,
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
              value: '$totalEntries',
              label: isEn ? 'Check-ins' : 'Kayıt',
              color: AppColors.auroraStart,
              isDark: isDark,
            ),
            _Stat(
              value: avgMood.toStringAsFixed(1),
              label: isEn ? 'Avg Mood' : 'Ort Ruh Hali',
              color: AppColors.starGold,
              isDark: isDark,
            ),
            if (avgEnergy > 0)
              _Stat(
                value: avgEnergy.toStringAsFixed(1),
                label: isEn ? 'Avg Energy' : 'Ort Enerji',
                color: AppColors.success,
                isDark: isDark,
              ),
            if (topEmoji.isNotEmpty)
              Column(
                children: [
                  Text(topEmoji, style: const TextStyle(fontSize: 22)),
                  Text(
                    isEn ? 'Top' : 'En Çok',
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.elegantAccent(
            fontSize: 9,
            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}

class _MoodDistribution extends StatelessWidget {
  final Map<int, int> counts;
  final int total;
  final bool isDark;

  const _MoodDistribution({
    required this.counts,
    required this.total,
    required this.isDark,
  });

  static const _moodEmojis = ['', '\u{1F614}', '\u{1F615}', '\u{1F610}', '\u{1F60A}', '\u{1F929}'];

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
        children: List.generate(5, (i) {
          final level = i + 1;
          final count = counts[level] ?? 0;
          final ratio = total > 0 ? count / total : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    _moodEmojis[level],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: ratio,
                      backgroundColor:
                          (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.06),
                      valueColor: AlwaysStoppedAnimation(
                        _moodColor(level),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  child: Text(
                    '${(ratio * 100).round()}%',
                    textAlign: TextAlign.end,
                    style: AppTypography.modernAccent(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _moodColor(level),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Color _moodColor(int level) {
    switch (level) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.amethyst;
      case 4:
        return AppColors.auroraStart;
      case 5:
        return AppColors.success;
      default:
        return AppColors.textMuted;
    }
  }
}

Color _quadrantColor(String quadrant) {
  switch (quadrant) {
    case 'fire':
      return AppColors.starGold;
    case 'water':
      return AppColors.chartBlue;
    case 'storm':
      return AppColors.amethyst;
    case 'shadow':
      return AppColors.error;
    default:
      return AppColors.textMuted;
  }
}

String _quadrantLabel(String quadrant, bool isEn) {
  switch (quadrant) {
    case 'fire':
      return isEn ? 'Fire' : 'Ateş';
    case 'water':
      return isEn ? 'Water' : 'Su';
    case 'storm':
      return isEn ? 'Storm' : 'Fırtına';
    case 'shadow':
      return isEn ? 'Shadow' : 'Gölge';
    default:
      return quadrant;
  }
}

class _QuadrantBreakdown extends StatelessWidget {
  final Map<String, int> counts;
  final int total;
  final bool isEn;
  final bool isDark;

  const _QuadrantBreakdown({
    required this.counts,
    required this.total,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
        children: sorted.map((e) {
          final ratio = total > 0 ? e.value / total : 0.0;
          final color = _quadrantColor(e.key);
          return Column(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: ratio,
                      strokeWidth: 4,
                      backgroundColor:
                          color.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                    Text(
                      '${(ratio * 100).round()}%',
                      style: AppTypography.modernAccent(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _quadrantLabel(e.key, isEn),
                style: AppTypography.elegantAccent(
                  fontSize: 10,
                  color: color,
                ),
              ),
              Text(
                '${e.value}',
                style: AppTypography.subtitle(
                  fontSize: 9,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _EmojiCloud extends StatelessWidget {
  final List<MapEntry<String, int>> emojis;
  final bool isDark;

  const _EmojiCloud({
    required this.emojis,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final maxCount = emojis.first.value;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: emojis.map((e) {
        final ratio = e.value / maxCount;
        final size = 18.0 + (ratio * 20);
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (isDark ? Colors.white : Colors.black)
                .withValues(alpha: 0.04),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.key, style: TextStyle(fontSize: size)),
              const SizedBox(width: 4),
              Text(
                '${e.value}',
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
      }).toList(),
    );
  }
}

class _EmotionChip extends StatelessWidget {
  final String emotion;
  final int count;
  final int maxCount;
  final bool isDark;

  const _EmotionChip({
    required this.emotion,
    required this.count,
    required this.maxCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxCount > 0 ? count / maxCount : 0.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.starGold
            .withValues(alpha: 0.05 + (ratio * 0.1)),
      ),
      child: Text(
        '$emotion ($count)',
        style: AppTypography.elegantAccent(
          fontSize: 11,
          color: AppColors.starGold,
        ),
      ),
    );
  }
}

class _MoodEntryRow extends StatelessWidget {
  final MoodEntry entry;
  final bool isEn;
  final bool isDark;

  const _MoodEntryRow({
    required this.entry,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${entry.date.day}/${entry.date.month}/${entry.date.year}';
    final timeStr = entry.createdAt != null
        ? '${entry.createdAt!.hour.toString().padLeft(2, '0')}:${entry.createdAt!.minute.toString().padLeft(2, '0')}'
        : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            entry.emoji.isNotEmpty ? entry.emoji : '\u{1F610}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: AppTypography.modernAccent(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                if (entry.selectedEmotions.isNotEmpty)
                  Text(
                    entry.selectedEmotions.take(3).join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
          if (entry.quadrant != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _quadrantColor(entry.quadrant!),
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (timeStr.isNotEmpty)
            Text(
              timeStr,
              style: AppTypography.subtitle(
                fontSize: 10,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
          const SizedBox(width: 6),
          Text(
            '${entry.mood}/5',
            style: AppTypography.modernAccent(
              fontSize: 12,
              fontWeight: FontWeight.w700,
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
          title: isEn ? 'Mood Archive' : 'Ruh Hali Arşivi',
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
                      const Text('\u{1F3AD}',
                          style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        isEn
                            ? 'Start logging your mood to build your emotional archive'
                            : 'Duygusal arşivini oluşturmak için ruh halini kaydetmeye başla',
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
