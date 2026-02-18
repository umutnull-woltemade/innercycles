// ════════════════════════════════════════════════════════════════════════════
// EMOTION OF THE DAY CARD - Daily Emotional Vocabulary Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/emotional_vocabulary_content.dart';
import '../../../data/providers/app_providers.dart';

class EmotionOfDayCard extends ConsumerStatefulWidget {
  const EmotionOfDayCard({super.key});

  @override
  ConsumerState<EmotionOfDayCard> createState() => _EmotionOfDayCardState();
}

class _EmotionOfDayCardState extends ConsumerState<EmotionOfDayCard> {
  bool _showBody = false;

  GranularEmotion _getDailyEmotion() {
    final now = DateTime.now();
    final dayHash = now.year * 10000 + now.month * 100 + now.day;
    return allGranularEmotions[dayHash % allGranularEmotions.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final emotion = _getDailyEmotion();

    return Semantics(
      button: true,
      label: isEn ? 'Emotion of the Day' : 'Günün Duygusu',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _showBody = !_showBody);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      _familyColor(emotion.family).withValues(alpha: 0.15),
                      _familyColor(emotion.family).withValues(alpha: 0.08),
                      AppColors.surfaceDark.withValues(alpha: 0.9),
                    ]
                  : [
                      _familyColor(emotion.family).withValues(alpha: 0.06),
                      _familyColor(emotion.family).withValues(alpha: 0.03),
                      AppColors.lightCard,
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _familyColor(emotion.family).withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: _familyColor(
                  emotion.family,
                ).withValues(alpha: isDark ? 0.08 : 0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _familyColor(
                        emotion.family,
                      ).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      emotion.emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isEn ? 'Emotion of the Day' : 'Günün Duygusu',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  // Intensity badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _familyColor(
                        emotion.family,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isEn
                          ? emotion.intensity.displayNameEn
                          : emotion.intensity.displayNameTr,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _familyColor(emotion.family),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Emotion name
              Text(
                isEn ? emotion.nameEn : emotion.nameTr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),

              const SizedBox(height: 6),

              // Description
              Text(
                isEn ? emotion.descriptionEn : emotion.descriptionTr,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),

              // Expanded body sensation section
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _familyColor(
                        emotion.family,
                      ).withValues(alpha: isDark ? 0.08 : 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _familyColor(
                          emotion.family,
                        ).withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.accessibility_new_rounded,
                          size: 16,
                          color: _familyColor(
                            emotion.family,
                          ).withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEn
                                    ? 'Where you might feel it'
                                    : 'Nerede hissedebilirsiniz',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _familyColor(emotion.family),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isEn
                                    ? emotion.bodySensationEn
                                    : emotion.bodySensationTr,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.3,
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
                  ),
                ),
                crossFadeState: _showBody
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),

              const SizedBox(height: 12),

              // Bottom row: family pill + tap hint
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _familyColor(
                        emotion.family,
                      ).withValues(alpha: isDark ? 0.15 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _familyColor(
                          emotion.family,
                        ).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      isEn
                          ? emotion.family.displayNameEn
                          : emotion.family.displayNameTr,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: _familyColor(emotion.family),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _showBody
                        ? (isEn ? 'Tap to collapse' : 'Daraltmak için dokun')
                        : (isEn
                              ? 'Tap for body sensation'
                              : 'Beden duyumu için dokun'),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textMuted.withValues(alpha: 0.6)
                          : AppColors.lightTextMuted.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, duration: 500.ms);
  }

  Color _familyColor(EmotionFamily family) {
    switch (family) {
      case EmotionFamily.joy:
        return AppColors.starGold;
      case EmotionFamily.sadness:
        return AppColors.auroraStart;
      case EmotionFamily.anger:
        return AppColors.sunriseEnd;
      case EmotionFamily.fear:
        return AppColors.amethyst;
      case EmotionFamily.surprise:
        return AppColors.brandPink;
      case EmotionFamily.calm:
        return AppColors.success;
    }
  }
}
