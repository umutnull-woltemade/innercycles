// ════════════════════════════════════════════════════════════════════════════
// MOOD CHECK-IN CARD - Quick Daily Mood Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/emotional_vocabulary_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/mood_checkin_service.dart';
import '../../../data/services/haptic_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../data/services/l10n_service.dart';

class MoodCheckinCard extends ConsumerStatefulWidget {
  const MoodCheckinCard({super.key});

  @override
  ConsumerState<MoodCheckinCard> createState() => _MoodCheckinCardState();
}

class _MoodCheckinCardState extends ConsumerState<MoodCheckinCard> {
  bool _justLogged = false;
  bool _showFirstVisitTip = false;

  @override
  void initState() {
    super.initState();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('mood_first_visit_seen') ?? false;
    if (!seen && mounted) {
      setState(() => _showFirstVisitTip = true);
      await prefs.setBool('mood_first_visit_seen', true);
    }
  }

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

        if (_justLogged && todayMood != null) {
          return _ThankYouView(
            todayMood: todayMood,
            weekMoods: weekMoods,
            isDark: isDark,
            isEn: isEn,
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_showFirstVisitTip)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.amethyst.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.touch_app_rounded, size: 16, color: AppColors.amethyst),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEn
                              ? 'Tap an emoji that matches how you feel right now. This builds your mood patterns over time.'
                              : 'Şu anki hissinize uyan emojiyi seçin. Bu, zaman içinde ruh hali kalıplarınızı oluşturur.',
                          style: AppTypography.subtitle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => setState(() => _showFirstVisitTip = false),
                        child: Icon(Icons.close_rounded, size: 14,
                            color: isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),
            _CheckinView(
          isDark: isDark,
          isEn: isEn,
          onSelect: (mood, emoji) async {
            await service.logMood(mood, emoji);
            HapticService.moodSelected();
            if (!mounted) return;
            setState(() => _justLogged = true);
            ref.invalidate(moodCheckinServiceProvider);
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) setState(() => _justLogged = false);
            });
          },
        ),
          ],
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
    final language = AppLanguage.fromIsEn(isEn);
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      child: Column(
        children: [
          Text(
            L10nService.get('mood.mood_checkin.whats_present_for_you_right_now', language),
            style: AppTypography.displayFont.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: MoodCheckinService.moodOptions.map((option) {
              final (mood, emoji, labelEn, labelTr) = option;
              final label = isEn ? labelEn : labelTr;
              return Semantics(
                label: label,
                button: true,
                child: GestureDetector(
                  onTap: () => onSelect(mood, emoji),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      AppSymbol.card(emoji),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: AppTypography.elegantAccent(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
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
    final language = AppLanguage.fromIsEn(isEn);
    final nowTime = DateTime.now();
    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              AppSymbol(todayMood.emoji, size: AppSymbolSize.lg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10nService.get('mood.mood_checkin.todays_mood', language),
                      style: AppTypography.displayFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      _moodLabel(todayMood.mood, isEn),
                      style: AppTypography.decorativeScript(
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
              final day = nowTime.subtract(Duration(days: 6 - i));
              final dayIndex = (day.weekday - 1) % 7;

              return Column(
                children: [
                  Text(
                    dayLabels[dayIndex],
                    style: AppTypography.elegantAccent(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  entry != null
                      ? AppSymbol.inline(
                          entry.emoji,
                          accentOverride: _moodColor(entry.mood),
                        )
                      : Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : Colors.black.withValues(alpha: 0.03),
                          ),
                          child: Center(
                            child: Text(
                              '·',
                              style: AppTypography.elegantAccent(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textMuted
                                    : AppColors.lightTextMuted,
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
    final language = AppLanguage.fromIsEn(isEn);
    switch (mood) {
      case 1:
        return L10nService.get('mood.mood_checkin.struggling', language);
      case 2:
        return L10nService.get('mood.mood_checkin.low', language);
      case 3:
        return L10nService.get('mood.mood_checkin.okay', language);
      case 4:
        return L10nService.get('mood.mood_checkin.good', language);
      case 5:
        return L10nService.get('mood.mood_checkin.great', language);
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

class _ThankYouView extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<_ThankYouView> createState() => _ThankYouViewState();
}

class _ThankYouViewState extends ConsumerState<_ThankYouView> {
  final Set<String> _selected = {};

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

  Future<void> _toggleEmotion(String emotionId) async {
    setState(() {
      if (_selected.contains(emotionId)) {
        _selected.remove(emotionId);
      } else {
        _selected.add(emotionId);
      }
    });
    // Persist selected emotions
    final service = await ref.read(moodCheckinServiceProvider.future);
    await service.updateSelectedEmotions(_selected.toList());
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLanguage.fromIsEn(widget.isEn);
    final suggestions = _getSuggestedEmotions(widget.todayMood.mood);

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      showGradientBorder: false,
      showInnerShadow: false,
      child: Column(
        children: [
          Row(
            children: [
              AppSymbol(
                widget.todayMood.emoji,
                size: AppSymbolSize.lg,
              ).animate().scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 300.ms,
                curve: Curves.elasticOut,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  L10nService.get('mood.mood_checkin.mood_logged_get_more_specific', language),
                  style: AppTypography.displayFont.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Granular emotion chips — tappable, selections persisted
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: suggestions.take(6).map((emotion) {
              final isSelected = _selected.contains(emotion.id);
              return GestureDetector(
                onTap: () => _toggleEmotion(emotion.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.starGold.withValues(alpha: 0.15)
                        : widget.isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.starGold.withValues(alpha: 0.4),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppSymbol.inline(emotion.emoji),
                      const SizedBox(width: 4),
                      Text(
                        emotion.localizedName(language),
                        style: AppTypography.elegantAccent(
                          fontSize: 11,
                          color: isSelected
                              ? AppColors.starGold
                              : widget.isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
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
    ).animate().fadeIn(duration: 200.ms);
  }
}
