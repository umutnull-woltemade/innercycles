import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/haptic_service.dart';
import '../../../../shared/widgets/tap_scale.dart';

/// Inline quick mood check-in row for the home feed.
/// Shows 5 mood emoji buttons when no mood has been logged today.
/// Hides itself after the user checks in.
class QuickMoodCheckin extends ConsumerStatefulWidget {
  final bool isEn;
  final bool isDark;

  const QuickMoodCheckin({
    super.key,
    required this.isEn,
    required this.isDark,
  });

  @override
  ConsumerState<QuickMoodCheckin> createState() => _QuickMoodCheckinState();
}

class _QuickMoodCheckinState extends ConsumerState<QuickMoodCheckin> {
  bool _justCheckedIn = false;

  static const _moods = [
    (1, '\u{1F614}'), // pensive
    (2, '\u{1F615}'), // confused
    (3, '\u{1F642}'), // slightly smiling
    (4, '\u{1F60A}'), // smiling with eyes
    (5, '\u{1F929}'), // star-struck
  ];

  @override
  Widget build(BuildContext context) {
    final moodAsync = ref.watch(moodCheckinServiceProvider);
    final todayMood = moodAsync.whenOrNull(
      data: (service) => service.getTodayMood(),
    );

    // Already logged today — don't show
    if (todayMood != null || _justCheckedIn) return const SizedBox.shrink();

    final isEn = widget.isEn;
    final isDark = widget.isDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Column(
        children: [
          Text(
            isEn ? 'How are you feeling?' : 'Bugün nasıl hissediyorsun?',
            style: AppTypography.subtitle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _moods.asMap().entries.map((entry) {
              final i = entry.key;
              final (mood, emoji) = entry.value;
              return TapScale(
                onTap: () => _logMood(mood, emoji),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.black.withValues(alpha: 0.03),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ).animate(delay: (80 + i * 60).ms).fadeIn(duration: 250.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 250.ms,
                    curve: Curves.easeOutBack,
                  );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Future<void> _logMood(int mood, String emoji) async {
    HapticService.moodSelected();
    setState(() => _justCheckedIn = true);

    final moodService = ref.read(moodCheckinServiceProvider).valueOrNull;
    if (moodService != null) {
      await moodService.logMood(mood, emoji);
      ref.invalidate(moodCheckinServiceProvider);
    }
  }
}
