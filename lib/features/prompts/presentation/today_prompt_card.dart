// ════════════════════════════════════════════════════════════════════════════
// TODAY'S PROMPT CARD - Daily Reflection Prompt Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';

class TodayPromptCard extends ConsumerWidget {
  const TodayPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(journalPromptServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final prompt = service.getDailyPrompt();
        final isCompleted = service.isCompleted(prompt.id);
        final progress = service.getCompletionPercent();

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(Routes.promptLibrary);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.auroraEnd.withValues(alpha: 0.12),
                        AppColors.surfaceDark.withValues(alpha: 0.9),
                      ]
                    : [
                        AppColors.auroraEnd.withValues(alpha: 0.06),
                        AppColors.lightCard,
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.auroraEnd.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.auroraEnd.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.edit_note_rounded,
                        color: AppColors.auroraEnd,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isEn ? 'Today\'s Prompt' : 'Bugünün Sorusu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    if (isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 12,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              isEn ? 'Done' : 'Tamam',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.auroraEnd.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.auroraEnd,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Prompt text
                Text(
                  isEn ? prompt.promptEn : prompt.promptTr,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 10),

                // Bottom row
                Row(
                  children: [
                    // Category pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceLight.withValues(alpha: 0.3)
                            : AppColors.lightSurfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _categoryLabel(prompt.category.name, isEn),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      isEn ? 'Tap to reflect' : 'Düşünmek için dokun',
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
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06, duration: 400.ms);
      },
    );
  }

  String _categoryLabel(String name, bool isEn) {
    switch (name) {
      case 'selfDiscovery':
        return isEn ? 'Self-Discovery' : 'Kendini Keşfet';
      case 'relationships':
        return isEn ? 'Relationships' : 'İlişkiler';
      case 'gratitude':
        return isEn ? 'Gratitude' : 'Şükran';
      case 'emotions':
        return isEn ? 'Emotions' : 'Duygular';
      case 'goals':
        return isEn ? 'Goals' : 'Hedefler';
      case 'healing':
        return isEn ? 'Healing' : 'İyileşme';
      case 'creativity':
        return isEn ? 'Creativity' : 'Yaratıcılık';
      case 'mindfulness':
        return isEn ? 'Mindfulness' : 'Farkındalık';
      default:
        return name;
    }
  }
}
