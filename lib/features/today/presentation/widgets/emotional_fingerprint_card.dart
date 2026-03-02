// ════════════════════════════════════════════════════════════════════════════
// EMOTIONAL FINGERPRINT CARD - Monthly generative visual identity
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/journal_entry.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/emotional_fingerprint_painter.dart';
import '../../../../shared/widgets/premium_card.dart';

class EmotionalFingerprintCard extends ConsumerWidget {
  final bool isEn;
  final bool isDark;

  const EmotionalFingerprintCard({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalServiceProvider);
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final streakAsync = ref.watch(streakStatsProvider);

    return journalAsync.maybeWhen(
      data: (journalService) {
        final entries = journalService.getAllEntries();
        if (entries.length < 10) return const SizedBox.shrink();

        // Only show on first 3 days of month
        final now = DateTime.now();
        if (now.day > 3) return const SizedBox.shrink();

        // Compute fingerprint data
        final areaCounts = <FocusArea, int>{};
        for (final e in entries) {
          areaCounts[e.focusArea] = (areaCounts[e.focusArea] ?? 0) + 1;
        }
        final sorted = areaCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
        final dominantArea = sorted.first.key.index;

        final avgMood = moodAsync.whenOrNull(data: (s) {
          final moods = s.getAllEntries();
          if (moods.isEmpty) return 3.0;
          return moods.fold<int>(0, (sum, e) => sum + e.mood) / moods.length;
        }) ?? 3.0;

        final streak = streakAsync.whenOrNull(data: (v) => v.currentStreak) ?? 0;

        // Dominant journaling hour
        final hourCounts = <int, int>{};
        for (final e in entries) {
          hourCounts[e.date.hour] = (hourCounts[e.date.hour] ?? 0) + 1;
        }
        final hourSorted = hourCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
        final dominantHour = hourSorted.isNotEmpty ? hourSorted.first.key : 12;

        final fingerprint = FingerprintData(
          dominantArea: dominantArea,
          avgMood: avgMood,
          streakLength: streak,
          journalHour: dominantHour,
        );

        final areaNames = [
          isEn ? 'Spark' : 'Kıvılcım',
          isEn ? 'Lens' : 'Mercek',
          isEn ? 'Tides' : 'Gelgit',
          isEn ? 'Compass' : 'Pusula',
          isEn ? 'Orbit' : 'Yörünge',
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: PremiumCard(
            style: PremiumCardStyle.amethyst,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.fingerprint_rounded, size: 16, color: AppColors.amethyst),
                    const SizedBox(width: 8),
                    Text(
                      isEn ? 'Your Emotional Fingerprint' : 'Duygusal Parmak İzin',
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: CustomPaint(
                      size: const Size(160, 160),
                      painter: EmotionalFingerprintPainter(data: fingerprint),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    isEn
                        ? 'Shaped by ${areaNames[dominantArea]}, colored by ${avgMood > 3.5 ? "warmth" : "reflection"}'
                        : '${areaNames[dominantArea]} ile şekillenmiş, ${avgMood > 3.5 ? "sıcaklık" : "yansıma"} ile renklenmiş',
                    textAlign: TextAlign.center,
                    style: AppTypography.decorativeScript(
                      fontSize: 12,
                      color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
