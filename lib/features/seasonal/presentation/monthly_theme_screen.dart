// ════════════════════════════════════════════════════════════════════════════
// MONTHLY THEME SCREEN - Dedicated monthly theme with weekly prompt tracker
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/content/monthly_themes_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/glass_sliver_app_bar.dart';
import '../../../shared/widgets/gradient_text.dart';
import '../../../shared/widgets/premium_card.dart';

class MonthlyThemeScreen extends ConsumerStatefulWidget {
  const MonthlyThemeScreen({super.key});

  @override
  ConsumerState<MonthlyThemeScreen> createState() => _MonthlyThemeScreenState();
}

class _MonthlyThemeScreenState extends ConsumerState<MonthlyThemeScreen> {
  int _selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isEn = language == AppLanguage.en;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final serviceAsync = ref.watch(monthlyThemeServiceProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: serviceAsync.when(
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (service) {
              final theme = service.getThemeForMonth(_selectedMonth) ??
                  allMonthlyThemes.first;
              final currentWeek = _selectedMonth == DateTime.now().month
                  ? service.getCurrentWeek()
                  : -1;
              final progress = service.monthProgress(_selectedMonth);
              final prompts = isEn ? theme.weeklyPromptsEn : theme.weeklyPromptsTr;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  GlassSliverAppBar(
                    title: isEn ? 'Monthly Theme' : 'Ayl\u0131k Tema',
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          // Month selector
                          SizedBox(
                            height: 36,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 12,
                              itemBuilder: (context, i) {
                                final m = i + 1;
                                final selected = m == _selectedMonth;
                                final isCurrent = m == DateTime.now().month;
                                final names = isEn
                                    ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                                    : ['Oca', '\u015eub', 'Mar', 'Nis', 'May', 'Haz',
                                       'Tem', 'A\u011fu', 'Eyl', 'Eki', 'Kas', 'Ara'];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedMonth = m),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppColors.starGold.withValues(alpha: 0.2)
                                            : (isDark
                                                ? Colors.white.withValues(alpha: 0.05)
                                                : Colors.black.withValues(alpha: 0.04)),
                                        borderRadius: BorderRadius.circular(16),
                                        border: selected
                                            ? Border.all(
                                                color: AppColors.starGold
                                                    .withValues(alpha: 0.5))
                                            : isCurrent
                                                ? Border.all(
                                                    color: AppColors.amethyst
                                                        .withValues(alpha: 0.3))
                                                : null,
                                      ),
                                      child: Text(
                                        names[i],
                                        style: AppTypography.modernAccent(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: selected
                                              ? AppColors.starGold
                                              : (isDark
                                                  ? AppColors.textSecondary
                                                  : AppColors.lightTextSecondary),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Hero theme name
                          Center(
                            child: GradientText(
                              isEn ? theme.themeNameEn : theme.themeNameTr,
                              variant: GradientTextVariant.gold,
                              style: AppTypography.modernAccent(
                                fontSize: 28,
                              ).copyWith(fontWeight: FontWeight.w300),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Progress ring
                          Center(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 3,
                                    backgroundColor: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.black.withValues(alpha: 0.06),
                                    valueColor: AlwaysStoppedAnimation(
                                      AppColors.starGold.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  Text(
                                    '${(progress * 100).round()}%',
                                    style: AppTypography.modernAccent(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.starGold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description
                          Text(
                            isEn ? theme.descriptionEn : theme.descriptionTr,
                            style: AppTypography.decorativeScript(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ).copyWith(height: 1.6),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Weekly prompts
                          GradientText(
                            isEn ? 'Weekly Prompts' : 'Haftal\u0131k Sorular',
                            variant: GradientTextVariant.amethyst,
                            style: AppTypography.modernAccent(fontSize: 15),
                          ),
                          const SizedBox(height: 10),

                          ...List.generate(4, (weekIndex) {
                            final completed = service.isPromptCompleted(
                                _selectedMonth, weekIndex);
                            final isCurrentWeek = weekIndex == currentWeek;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GestureDetector(
                                onTap: () {
                                  service.markPromptCompleted(
                                      _selectedMonth, weekIndex);
                                  ref.invalidate(monthlyThemeServiceProvider);
                                  context.push(Routes.journal, extra: {
                                    'journalPrompt': prompts[weekIndex],
                                  });
                                },
                                child: PremiumCard(
                                  style: isCurrentWeek
                                      ? PremiumCardStyle.gold
                                      : PremiumCardStyle.subtle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: completed
                                                ? AppColors.success
                                                    .withValues(alpha: 0.2)
                                                : (isDark
                                                    ? Colors.white
                                                        .withValues(alpha: 0.06)
                                                    : Colors.black
                                                        .withValues(alpha: 0.04)),
                                          ),
                                          child: completed
                                              ? const Icon(Icons.check,
                                                  size: 16,
                                                  color: AppColors.success)
                                              : Center(
                                                  child: Text(
                                                    '${weekIndex + 1}',
                                                    style: AppTypography
                                                        .modernAccent(
                                                      fontSize: 12,
                                                      color: isDark
                                                          ? AppColors.textMuted
                                                          : AppColors
                                                              .lightTextMuted,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isEn
                                                    ? 'Week ${weekIndex + 1}'
                                                    : 'Hafta ${weekIndex + 1}',
                                                style:
                                                    AppTypography.modernAccent(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: isCurrentWeek
                                                      ? AppColors.starGold
                                                      : (isDark
                                                          ? AppColors
                                                              .textMuted
                                                          : AppColors
                                                              .lightTextMuted),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                prompts[weekIndex],
                                                style: AppTypography.subtitle(
                                                  fontSize: 13,
                                                  color: isDark
                                                      ? AppColors.textPrimary
                                                      : AppColors
                                                          .lightTextPrimary,
                                                ),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 18,
                                          color: isDark
                                              ? AppColors.textMuted
                                              : AppColors.lightTextMuted,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 20),

                          // Wellness tip
                          GradientText(
                            isEn ? 'Wellness Tip' : 'Sa\u011fl\u0131k \u0130pucu',
                            variant: GradientTextVariant.aurora,
                            style: AppTypography.modernAccent(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isEn ? theme.wellnessTipEn : theme.wellnessTipTr,
                            style: AppTypography.decorativeScript(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColors.lightTextSecondary,
                            ).copyWith(fontStyle: FontStyle.italic, height: 1.5),
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
