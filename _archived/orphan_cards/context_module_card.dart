// ════════════════════════════════════════════════════════════════════════════
// CONTEXT MODULE CARD - Daily Insight Widget for Home Screen
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/context_modules_content.dart';
import '../../../data/providers/app_providers.dart';

class ContextModuleCard extends ConsumerWidget {
  const ContextModuleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(contextModuleServiceProvider);

    return serviceAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (service) {
        final module = service.getDailyModule();
        final progress = service.readProgress;

        return Semantics(
              button: true,
              label: isEn
                  ? 'Daily Insight'
                  : 'G\u00fcnl\u00fck \u0130\u00e7g\u00f6r\u00fc',
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(Routes.insightsDiscovery);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.amethyst.withValues(alpha: 0.15),
                              AppColors.auroraEnd.withValues(alpha: 0.1),
                              AppColors.surfaceDark.withValues(alpha: 0.9),
                            ]
                          : [
                              AppColors.amethyst.withValues(alpha: 0.06),
                              AppColors.lightAuroraEnd.withValues(alpha: 0.04),
                              AppColors.lightCard,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.amethyst.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.amethyst.withValues(
                          alpha: isDark ? 0.08 : 0.04,
                        ),
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
                              color: AppColors.amethyst.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.psychology_alt_rounded,
                              color: isDark
                                  ? AppColors.amethyst
                                  : AppColors.amethyst,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isEn ? 'Daily Insight' : 'Günün İçgörüsü',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                          // Progress indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amethyst.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(progress * 100).round()}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.amethyst,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Module title
                      Text(
                        isEn ? module.titleEn : module.titleTr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Module summary
                      Text(
                        isEn ? module.summaryEn : module.summaryTr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Bottom row: category + depth + tap hint
                      Row(
                        children: [
                          // Category pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _categoryColor(
                                module.category,
                              ).withValues(alpha: isDark ? 0.15 : 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _categoryColor(
                                  module.category,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _categoryIcon(module.category),
                                  size: 12,
                                  color: _categoryColor(module.category),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isEn
                                      ? module.category.displayNameEn
                                      : module.category.displayNameTr,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: _categoryColor(module.category),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Depth badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceLight.withValues(
                                      alpha: 0.3,
                                    )
                                  : AppColors.lightSurfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isEn
                                  ? module.depth.displayNameEn
                                  : module.depth.displayNameTr,
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
                            isEn ? 'Tap to explore' : 'Keşfetmek için dokun',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.textMuted.withValues(alpha: 0.6)
                                  : AppColors.lightTextMuted.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.08, duration: 500.ms);
      },
    );
  }

  Color _categoryColor(ContextModuleCategory category) {
    switch (category) {
      case ContextModuleCategory.emotionalLiteracy:
        return AppColors.brandPink;
      case ContextModuleCategory.mythVsReality:
        return AppColors.sunriseEnd;
      case ContextModuleCategory.patternRecognition:
        return AppColors.auroraStart;
      case ContextModuleCategory.selfAwareness:
        return AppColors.amethyst;
      case ContextModuleCategory.cyclicalWellness:
        return AppColors.success;
      case ContextModuleCategory.journalScience:
        return AppColors.starGold;
    }
  }

  IconData _categoryIcon(ContextModuleCategory category) {
    switch (category) {
      case ContextModuleCategory.emotionalLiteracy:
        return Icons.psychology_rounded;
      case ContextModuleCategory.mythVsReality:
        return Icons.lightbulb_outline_rounded;
      case ContextModuleCategory.patternRecognition:
        return Icons.timeline_rounded;
      case ContextModuleCategory.selfAwareness:
        return Icons.self_improvement_rounded;
      case ContextModuleCategory.cyclicalWellness:
        return Icons.loop_rounded;
      case ContextModuleCategory.journalScience:
        return Icons.science_rounded;
    }
  }
}
