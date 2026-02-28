// ════════════════════════════════════════════════════════════════════════════
// SEASONAL REFLECTION SCREEN - Quarterly Themed Prompts
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/common_strings.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/seasonal_reflection_service.dart';
import '../../../shared/widgets/app_symbol.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/cosmic_loading_indicator.dart';
import '../../../shared/widgets/content_disclaimer.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/gradient_outlined_button.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/tool_ecosystem_footer.dart';
import '../../../data/services/l10n_service.dart';

class SeasonalReflectionScreen extends ConsumerWidget {
  const SeasonalReflectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEn = language == AppLanguage.en;
    final serviceAsync = ref.watch(seasonalReflectionServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                GlassSliverAppBar(
                  title: L10nService.get('seasonal.seasonal_reflection.seasonal_reflections', language),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: serviceAsync.when(
                    loading: () => SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CosmicLoadingIndicator(),
                            const SizedBox(height: 12),
                            Text(
                              L10nService.get('seasonal.seasonal_reflection.loading_reflections', language),
                              style: AppTypography.subtitle(
                                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    error: (_, _) => SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CommonStrings.somethingWentWrong(language),
                                textAlign: TextAlign.center,
                                style: AppTypography.subtitle(
                                  color: isDark
                                      ? AppColors.textMuted
                                      : AppColors.lightTextMuted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton.icon(
                                onPressed: () => ref.invalidate(
                                    seasonalReflectionServiceProvider),
                                icon: Icon(Icons.refresh_rounded,
                                    size: 16, color: AppColors.starGold),
                                label: Text(
                                  L10nService.get('seasonal.seasonal_reflection.retry', language),
                                  style: AppTypography.elegantAccent(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.starGold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    data: (service) {
                      final module = service.getCurrentModule();
                      final progress = service.getCurrentProgress();
                      final completion = service.getCompletionPercent();

                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Season header
                          _SeasonHeader(
                            module: module,
                            completion: completion,
                            isDark: isDark,
                            isEn: isEn,
                          ),
                          const SizedBox(height: 20),

                          // Prompts list
                          ...module.prompts.map((prompt) {
                            final isCompleted = progress.completedPrompts
                                .contains(prompt.index);
                            return _PromptCard(
                              prompt: prompt,
                              isCompleted: isCompleted,
                              isDark: isDark,
                              isEn: isEn,
                              onComplete: () async {
                                await service.completePrompt(prompt.index);
                                if (!context.mounted) return;
                                ref.invalidate(
                                  seasonalReflectionServiceProvider,
                                );
                                HapticFeedback.mediumImpact();
                              },
                            );
                          }),

                          const SizedBox(height: 24),

                          // All seasons overview
                          _AllSeasonsRow(isDark: isDark, isEn: isEn),
                          const SizedBox(height: 24),
                          ContentDisclaimer(language: language),
                          ToolEcosystemFooter(
                            currentToolId: 'seasonalReflection',
                            isEn: isEn,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 40),
                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════

class _SeasonHeader extends StatelessWidget {
  final SeasonalModule module;
  final double completion;
  final bool isDark;
  final bool isEn;

  const _SeasonHeader({
    required this.module,
    required this.completion,
    required this.isDark,
    required this.isEn,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      style: PremiumCardStyle.aurora,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          AppSymbol.hero(module.emoji),
          const SizedBox(height: 12),
          GradientText(
            isEn ? module.nameEn : module.nameTr,
            variant: GradientTextVariant.aurora,
            style: AppTypography.displayFont.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn ? module.themeEn : module.themeTr,
            style: AppTypography.decorativeScript(
              fontSize: 15,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: completion,
              minHeight: 6,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation(_seasonColor(module.season)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(completion * 100).round()}% ${L10nService.get('seasonal.seasonal_reflection.complete', isEn ? AppLanguage.en : AppLanguage.tr)}',
            style: AppTypography.modernAccent(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _seasonColor(module.season),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Color _seasonColor(Season season) {
    switch (season) {
      case Season.spring:
        return AppColors.success;
      case Season.summer:
        return AppColors.starGold;
      case Season.autumn:
        return AppColors.sunriseEnd;
      case Season.winter:
        return AppColors.auroraStart;
    }
  }
}

class _PromptCard extends StatelessWidget {
  final SeasonalPrompt prompt;
  final bool isCompleted;
  final bool isDark;
  final bool isEn;
  final VoidCallback onComplete;

  const _PromptCard({
    required this.prompt,
    required this.isCompleted,
    required this.isDark,
    required this.isEn,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        style: isCompleted ? PremiumCardStyle.gold : PremiumCardStyle.subtle,
        padding: const EdgeInsets.all(16),
        borderRadius: 14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.success
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04)),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            '${prompt.index + 1}',
                            style: AppTypography.modernAccent(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isEn ? prompt.titleEn : prompt.titleTr,
                    style:
                        AppTypography.modernAccent(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ).copyWith(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isEn ? prompt.promptEn : prompt.promptTr,
              style: AppTypography.decorativeScript(
                fontSize: 13,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            if (!isCompleted) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GradientOutlinedButton(
                  label: L10nService.get('seasonal.seasonal_reflection.mark_complete', isEn ? AppLanguage.en : AppLanguage.tr),
                  icon: Icons.check_rounded,
                  variant: GradientTextVariant.aurora,
                  fontSize: 13,
                  onPressed: onComplete,
                ),
              ),
            ],
          ],
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}

class _AllSeasonsRow extends StatelessWidget {
  final bool isDark;
  final bool isEn;

  const _AllSeasonsRow({required this.isDark, required this.isEn});

  @override
  Widget build(BuildContext context) {
    final current = SeasonalReflectionService.currentSeason();

    return PremiumCard(
      style: PremiumCardStyle.subtle,
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('seasonal.seasonal_reflection.all_seasons', isEn ? AppLanguage.en : AppLanguage.tr),
            style: AppTypography.modernAccent(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: SeasonalReflectionService.allModules.map((m) {
              final isCurrent = m.season == current;
              return Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent
                          ? AppColors.starGold.withValues(alpha: 0.15)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.03)),
                      border: isCurrent
                          ? Border.all(
                              color: AppColors.starGold.withValues(alpha: 0.4),
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        m.emoji,
                        style: AppTypography.subtitle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isEn
                        ? m.nameEn.split(' ').first
                        : m.nameTr.split(' ').first,
                    style: AppTypography.elegantAccent(
                      fontSize: 11,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      color: isCurrent
                          ? AppColors.starGold
                          : (isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 300.ms);
  }
}
