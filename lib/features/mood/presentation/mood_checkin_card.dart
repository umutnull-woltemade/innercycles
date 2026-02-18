// ════════════════════════════════════════════════════════════════════════════
// MOOD CHECK-IN CARD - Quick Daily Mood Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/emotional_vocabulary_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/mood_checkin_service.dart';

class MoodCheckinCard extends ConsumerStatefulWidget {
  const MoodCheckinCard({super.key});

  @override
  ConsumerState<MoodCheckinCard> createState() => _MoodCheckinCardState();
}

class _MoodCheckinCardState extends ConsumerState<MoodCheckinCard> {
  bool _justLogged = false;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(moodCheckinServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final todayMood = service.getTodayMood();
        final weekMoods = service.getWeekMoods();

        if (todayMood != null && !_justLogged) {
          return _LoggedView(
            todayMood: todayMood,
            weekMoods: weekMoods,
            isDark: isDark,
            isEn: isEn,
          );
        }

        if (_justLogged) {
          return _ThankYouView(
            todayMood: todayMood!,
            weekMoods: weekMoods,
            isDark: isDark,
            isEn: isEn,
          );
        }

        return _CheckinView(
          isDark: isDark,
          isEn: isEn,
          onSelect: (mood, emoji) async {
            await service.logMood(mood, emoji);
            HapticFeedback.mediumImpact();
            if (!mounted) return;
            setState(() => _justLogged = true);
            ref.invalidate(moodCheckinServiceProvider);
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) setState(() => _justLogged = false);
            });
          },
        );
      },
    );
  }
}

class _CheckinView extends StatelessWidget {
  final bool isDark;
  final bool isEn;
  final Function(int, String) onSelect;

  const _CheckinView({
    required this.isDark,
    required this.isEn,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                  AppColors.auroraStart.withValues(alpha: 0.15),
                ]
              : [
                  AppColors.lightCard,
                  AppColors.auroraStart.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.auroraStart.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            isEn ? 'How are you feeling?' : 'Bugün nasıl hissediyorsun?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: MoodCheckinService.moodOptions.map((option) {
              final (mood, emoji, labelEn, labelTr) = option;
              return Semantics(
                label: isEn ? labelEn : labelTr,
                button: true,
                child: GestureDetector(
                  onTap: () => onSelect(mood, emoji),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                        ),
                        child: Center(
                          child: Text(emoji, style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isEn ? labelEn : labelTr,
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _LoggedView extends StatelessWidget {
  final MoodEntry todayMood;
  final List<MoodEntry?> weekMoods;
  final bool isDark;
  final bool isEn;

  const _LoggedView({
    required this.todayMood,
    required this.weekMoods,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withValues(alpha: 0.85)
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(todayMood.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEn ? 'Today\'s Mood' : 'Bugünkü Ruh Halin',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      _moodLabel(todayMood.mood, isEn),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Week mini-timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (i) {
              final entry = weekMoods[i];
              final dayLabels = isEn
                  ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                  : ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pa'];
              final now = DateTime.now();
              final day = now.subtract(Duration(days: 6 - i));
              final dayIndex = (day.weekday - 1) % 7;

              return Column(
                children: [
                  Text(
                    dayLabels[dayIndex],
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: entry != null
                          ? _moodColor(entry.mood).withValues(alpha: 0.2)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : Colors.black.withValues(alpha: 0.03)),
                    ),
                    child: Center(
                      child: Text(
                        entry?.emoji ?? '·',
                        style: TextStyle(
                          fontSize: entry != null ? 14 : 12,
                          color: entry != null
                              ? null
                              : (isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  String _moodLabel(int mood, bool isEn) {
    switch (mood) {
      case 1:
        return isEn ? 'Struggling' : 'Zor';
      case 2:
        return isEn ? 'Low' : 'Düşük';
      case 3:
        return isEn ? 'Okay' : 'İdare';
      case 4:
        return isEn ? 'Good' : 'İyi';
      case 5:
        return isEn ? 'Great' : 'Harika';
      default:
        return '';
    }
  }

  Color _moodColor(int mood) {
    switch (mood) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.auroraStart;
      case 4:
        return AppColors.success;
      case 5:
        return AppColors.starGold;
      default:
        return AppColors.textMuted;
    }
  }
}

class _ThankYouView extends StatelessWidget {
  final MoodEntry todayMood;
  final List<MoodEntry?> weekMoods;
  final bool isDark;
  final bool isEn;

  const _ThankYouView({
    required this.todayMood,
    required this.weekMoods,
    required this.isDark,
    required this.isEn,
  });

  /// Map mood level (1-5) to relevant emotion families for granular suggestion
  List<GranularEmotion> _getSuggestedEmotions(int mood) {
    final List<EmotionFamily> families;
    switch (mood) {
      case 1:
        families = [EmotionFamily.sadness, EmotionFamily.fear];
      case 2:
        families = [EmotionFamily.sadness, EmotionFamily.anger];
      case 3:
        families = [EmotionFamily.calm, EmotionFamily.surprise];
      case 4:
        families = [EmotionFamily.joy, EmotionFamily.calm];
      case 5:
        families = [EmotionFamily.joy, EmotionFamily.surprise];
      default:
        families = [EmotionFamily.calm];
    }
    return allGranularEmotions
        .where((e) => families.contains(e.family))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _getSuggestedEmotions(todayMood.mood);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.success.withValues(alpha: 0.15),
                  AppColors.surfaceDark.withValues(alpha: 0.9),
                ]
              : [
                  AppColors.success.withValues(alpha: 0.08),
                  AppColors.lightCard,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(todayMood.emoji, style: const TextStyle(fontSize: 32))
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  isEn
                      ? 'Mood logged! Get more specific?'
                      : 'Ruh hali kaydedildi! Daha spesifik ol?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Granular emotion chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: suggestions.take(6).map((emotion) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emotion.emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      isEn ? emotion.nameEn : emotion.nameTr,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}
