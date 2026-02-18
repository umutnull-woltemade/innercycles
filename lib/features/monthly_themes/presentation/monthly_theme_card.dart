// ════════════════════════════════════════════════════════════════════════════
// MONTHLY THEME CARD - Current Month's Theme Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';

class MonthlyThemeCard extends ConsumerWidget {
  const MonthlyThemeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(monthlyThemeServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final theme = service.getCurrentTheme();
        final weekIndex = service.getCurrentWeek();
        final weekPrompt = isEn
            ? theme.weeklyPromptsEn[weekIndex]
            : theme.weeklyPromptsTr[weekIndex];
        final progress = service.monthProgress(theme.month);

        return Semantics(
          button: true,
          label: isEn ? 'Monthly Theme' : 'Aylık Tema',
          child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push(Routes.journalMonthly);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.brandPink.withValues(alpha: 0.12),
                        AppColors.sunriseEnd.withValues(alpha: 0.08),
                        AppColors.surfaceDark.withValues(alpha: 0.9),
                      ]
                    : [
                        AppColors.brandPink.withValues(alpha: 0.06),
                        AppColors.sunriseEnd.withValues(alpha: 0.03),
                        AppColors.lightCard,
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.brandPink.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandPink
                      .withValues(alpha: isDark ? 0.06 : 0.03),
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
                        color: AppColors.brandPink.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _monthIcon(theme.month),
                        color: AppColors.brandPink,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn ? 'This Month\'s Theme' : 'Bu Ayın Teması',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          Text(
                            isEn ? theme.themeNameEn : theme.themeNameTr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Week progress
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brandPink.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isEn
                            ? 'Week ${weekIndex + 1}/4'
                            : 'Hafta ${weekIndex + 1}/4',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandPink,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Weekly prompt
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.brandPink
                        .withValues(alpha: isDark ? 0.08 : 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.brandPink.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.format_quote_rounded,
                        size: 16,
                        color: AppColors.brandPink.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          weekPrompt,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            fontStyle: FontStyle.italic,
                            color: isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Progress bar + tip
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.06),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.brandPink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, duration: 500.ms);
      },
    );
  }

  IconData _monthIcon(int month) {
    switch (month) {
      case 1:
        return Icons.ac_unit_rounded;
      case 2:
        return Icons.favorite_rounded;
      case 3:
        return Icons.eco_rounded;
      case 4:
        return Icons.wb_sunny_rounded;
      case 5:
        return Icons.local_florist_rounded;
      case 6:
        return Icons.light_mode_rounded;
      case 7:
        return Icons.beach_access_rounded;
      case 8:
        return Icons.water_rounded;
      case 9:
        return Icons.park_rounded;
      case 10:
        return Icons.nights_stay_rounded;
      case 11:
        return Icons.shield_rounded;
      case 12:
        return Icons.auto_stories_rounded;
      default:
        return Icons.calendar_month_rounded;
    }
  }
}
