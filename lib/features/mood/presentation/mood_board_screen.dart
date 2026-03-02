// ════════════════════════════════════════════════════════════════════════════
// MOOD BOARD SCREEN - Visual mood collage grid
// ════════════════════════════════════════════════════════════════════════════

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

class MoodBoardScreen extends ConsumerStatefulWidget {
  const MoodBoardScreen({super.key});

  @override
  ConsumerState<MoodBoardScreen> createState() => _MoodBoardScreenState();
}

class _MoodBoardScreenState extends ConsumerState<MoodBoardScreen> {
  int _rangeDays = 30;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodAsync = ref.watch(moodCheckinServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: moodAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final entries = service.getAllEntries();
              final cutoff = DateTime.now().subtract(Duration(days: _rangeDays));
              final recent = entries
                  .where((e) => e.date.isAfter(cutoff))
                  .toList()
                ..sort((a, b) => a.date.compareTo(b.date));

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Mood Board' : 'Ruh Hali Panosu',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Range picker
                          Row(
                            children: [7, 14, 30, 90].map((d) {
                              final selected = d == _rangeDays;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () => setState(() => _rangeDays = d),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? AppColors.starGold
                                              .withValues(alpha: 0.2)
                                          : (isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.05)
                                              : Colors.black
                                                  .withValues(alpha: 0.04)),
                                      borderRadius: BorderRadius.circular(16),
                                      border: selected
                                          ? Border.all(
                                              color: AppColors.starGold
                                                  .withValues(alpha: 0.5))
                                          : null,
                                    ),
                                    child: Text(
                                      '${d}d',
                                      style: AppTypography.modernAccent(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? AppColors.starGold
                                            : (isDark
                                                ? AppColors.textSecondary
                                                : AppColors
                                                    .lightTextSecondary),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 16),

                          if (recent.isEmpty)
                            _EmptyState(isEn: isEn, isDark: isDark)
                          else ...[
                            // Stats row
                            _MoodStatsRow(
                                entries: recent, isEn: isEn, isDark: isDark),
                            const SizedBox(height: 16),

                            // Mood grid
                            GradientText(
                              isEn ? 'Your Mood Mosaic' : 'Ruh Hali Mozaiğin',
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            _MoodGrid(
                                entries: recent, isDark: isDark),
                            const SizedBox(height: 24),

                            // Emotion frequency
                            GradientText(
                              isEn ? 'Dominant Emotions' : 'Baskın Duygular',
                              variant: GradientTextVariant.amethyst,
                              style: AppTypography.modernAccent(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            _EmotionFrequency(
                                entries: recent, isEn: isEn, isDark: isDark),
                          ],

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

class _MoodStatsRow extends StatelessWidget {
  final List<MoodEntry> entries;
  final bool isEn;
  final bool isDark;

  const _MoodStatsRow(
      {required this.entries, required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final avgMood =
        entries.map((e) => e.mood).reduce((a, b) => a + b) / entries.length;
    final uniqueEmojis = entries.map((e) => e.emoji).toSet();

    return Row(
      children: [
        _StatChip(
          label: isEn ? 'Avg Mood' : 'Ort. Ruh Hali',
          value: avgMood.toStringAsFixed(1),
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _StatChip(
          label: isEn ? 'Entries' : 'Kayıt',
          value: '${entries.length}',
          isDark: isDark,
        ),
        const SizedBox(width: 8),
        _StatChip(
          label: isEn ? 'Emojis' : 'Emojiler',
          value: '${uniqueEmojis.length}',
          isDark: isDark,
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatChip(
      {required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTypography.displayFont.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.starGold,
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
        ),
      ),
    );
  }
}

class _MoodGrid extends StatelessWidget {
  final List<MoodEntry> entries;
  final bool isDark;

  const _MoodGrid({required this.entries, required this.isDark});

  static const _moodColors = <int, Color>{
    1: Color(0xFF8B6F5E), // low
    2: Color(0xFFB8956A),
    3: Color(0xFFD4A07A), // neutral
    4: Color(0xFFC8553D),
    5: Color(0xFFD4704A), // high
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: entries.asMap().entries.map((e) {
        final entry = e.value;
        final color = _moodColors[entry.mood.clamp(1, 5)] ?? AppColors.amethyst;
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + e.key * 20),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              entry.emoji,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _EmotionFrequency extends StatelessWidget {
  final List<MoodEntry> entries;
  final bool isEn;
  final bool isDark;

  const _EmotionFrequency(
      {required this.entries, required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final emojiCounts = <String, int>{};
    for (final e in entries) {
      emojiCounts[e.emoji] = (emojiCounts[e.emoji] ?? 0) + 1;
    }
    final sorted = emojiCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(8).toList();
    if (top.isEmpty) return const SizedBox.shrink();

    final maxCount = top.first.value;

    return Column(
      children: top.map((e) {
        final ratio = e.value / maxCount;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Text(e.key, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04),
                    valueColor: AlwaysStoppedAnimation(
                      AppColors.starGold.withValues(alpha: 0.5),
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${e.value}x',
                style: AppTypography.elegantAccent(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}

class _EmptyState extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _EmptyState({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Text('\u{1F3A8}', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text(
              isEn
                  ? 'Log moods to build your board'
                  : 'Panonuzu oluşturmak için ruh halinizi kaydedin',
              textAlign: TextAlign.center,
              style: AppTypography.decorativeScript(
                fontSize: 15,
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
