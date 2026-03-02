// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL FINGERPRINT SCREEN - Full generative visual identity
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/emotional_fingerprint_painter.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
// premium_card not directly used on this screen

class EmotionalFingerprintScreen extends ConsumerWidget {
  const EmotionalFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final journalAsync = ref.watch(journalServiceProvider);
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final streakAsync = ref.watch(streakStatsProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: journalAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (journalService) {
              final entries = journalService.getAllEntries();
              if (entries.length < 5) {
                return _InsufficientData(isEn: isEn, isDark: isDark);
              }

              // Compute fingerprint data
              final areaCounts = <FocusArea, int>{};
              for (final e in entries) {
                areaCounts[e.focusArea] =
                    (areaCounts[e.focusArea] ?? 0) + 1;
              }
              final sorted = areaCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));
              final dominantArea = sorted.first.key;

              final avgMood = moodAsync.whenOrNull(data: (s) {
                    final moods = s.getAllEntries();
                    if (moods.isEmpty) return 3.0;
                    return moods.fold<int>(0, (sum, e) => sum + e.mood) /
                        moods.length;
                  }) ??
                  3.0;

              final streak =
                  streakAsync.whenOrNull(data: (v) => v.currentStreak) ?? 0;

              // Dominant journaling hour
              final hourCounts = <int, int>{};
              for (final e in entries) {
                hourCounts[e.createdAt.hour] =
                    (hourCounts[e.createdAt.hour] ?? 0) + 1;
              }
              final hourSorted = hourCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));
              final dominantHour =
                  hourSorted.isNotEmpty ? hourSorted.first.key : 12;

              final fingerprint = FingerprintData(
                dominantArea: dominantArea.index,
                avgMood: avgMood,
                streakLength: streak,
                journalHour: dominantHour,
              );

              final areaNames = [
                isEn ? 'Energy (Spark)' : 'Enerji (Kıvılcım)',
                isEn ? 'Focus (Lens)' : 'Odak (Mercek)',
                isEn ? 'Emotions (Tides)' : 'Duygular (Gelgit)',
                isEn ? 'Decisions (Compass)' : 'Kararlar (Pusula)',
                isEn ? 'Social (Orbit)' : 'Sosyal (Yörünge)',
              ];

              return CustomScrollView(
                slivers: [
                  GlassSliverAppBar(
                    title: isEn
                        ? 'Emotional Fingerprint'
                        : 'Duygusal Parmak İzi',
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
                                ? 'Your unique emotional signature'
                                : 'Benzersiz duygusal imzan',
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Hero fingerprint
                          Center(
                            child: SizedBox(
                              width: 280,
                              height: 280,
                              child: CustomPaint(
                                size: const Size(280, 280),
                                painter:
                                    EmotionalFingerprintPainter(
                                  data: fingerprint,
                                ),
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1, 1),
                                  duration: 600.ms),

                          const SizedBox(height: 24),

                          // Stats grid
                          GradientText(
                            isEn
                                ? 'Your Signature'
                                : 'Senin İmzan',
                            variant: GradientTextVariant.amethyst,
                            style: AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _StatCard(
                                emoji: '\u{2728}',
                                label: isEn
                                    ? 'Dominant Area'
                                    : 'Baskın Alan',
                                value: areaNames[
                                    dominantArea.index],
                                isDark: isDark,
                              ),
                              const SizedBox(width: 12),
                              _StatCard(
                                emoji: '\u{1F551}',
                                label: isEn
                                    ? 'Journal Hour'
                                    : 'Günlük Saati',
                                value:
                                    '${dominantHour.toString().padLeft(2, '0')}:00',
                                isDark: isDark,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _StatCard(
                                emoji: avgMood >= 3.5
                                    ? '\u{2600}\u{FE0F}'
                                    : '\u{1F319}',
                                label: isEn
                                    ? 'Mood Warmth'
                                    : 'Ruh Hali Sıcaklığı',
                                value: avgMood
                                    .toStringAsFixed(1),
                                isDark: isDark,
                              ),
                              const SizedBox(width: 12),
                              _StatCard(
                                emoji: '\u{1F525}',
                                label: isEn
                                    ? 'Streak'
                                    : 'Seri',
                                value: '$streak ${isEn ? 'days' : 'gün'}',
                                isDark: isDark,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Focus area breakdown
                          GradientText(
                            isEn
                                ? 'Area Distribution'
                                : 'Alan Dağılımı',
                            variant:
                                GradientTextVariant.gold,
                            style:
                                AppTypography.modernAccent(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...sorted.map((e) {
                            final pct = (e.value /
                                    entries.length *
                                    100)
                                .round();
                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                      bottom: 8),
                              child: _AreaBar(
                                area: e.key,
                                count: e.value,
                                percentage: pct,
                                isEn: isEn,
                                isDark: isDark,
                              ),
                            );
                          }),

                          const SizedBox(height: 20),

                          // Caption
                          Center(
                            child: Text(
                              isEn
                                  ? 'Based on ${entries.length} journal entries'
                                  : '${entries.length} günlük girdisine dayalı',
                              style:
                                  AppTypography.subtitle(
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
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final bool isDark;

  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.elegantAccent(
                fontSize: 10,
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTypography.modernAccent(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaBar extends StatelessWidget {
  final FocusArea area;
  final int count;
  final int percentage;
  final bool isEn;
  final bool isDark;

  const _AreaBar({
    required this.area,
    required this.count,
    required this.percentage,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            isEn ? area.displayNameEn : area.displayNameTr,
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
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100.0,
              backgroundColor: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation(AppColors.amethyst),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            '$percentage%',
            textAlign: TextAlign.end,
            style: AppTypography.elegantAccent(
              fontSize: 11,
              color: AppColors.amethyst,
            ),
          ),
        ),
      ],
    );
  }
}

class _InsufficientData extends StatelessWidget {
  final bool isEn;
  final bool isDark;

  const _InsufficientData({required this.isEn, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('\u{1F9EC}', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 16),
            Text(
              isEn
                  ? 'Keep journaling to generate your emotional fingerprint'
                  : 'Duygusal parmak izini oluşturmak için günlük yazmaya devam et',
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
