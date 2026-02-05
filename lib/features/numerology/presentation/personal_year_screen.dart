import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/content/numerology_content.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/kadim_not_card.dart';
import '../../../shared/widgets/next_blocks.dart';
import '../../../shared/widgets/page_bottom_navigation.dart';

/// KİŞİSEL YIL DETAY SAYFASI
///
/// 9 yıllık döngüdeki her yıl (1-9) için detaylı içerik.
/// Kullanıcının kişisel yılına göre rehberlik sunar.
class PersonalYearScreen extends ConsumerWidget {
  final int year;

  const PersonalYearScreen({super.key, required this.year});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final content = personalYearContents[year];

    if (content == null) {
      return Scaffold(
        body: CosmicBackground(
          child: Center(
            child: Text(
              L10nService.get('numerology.personal_year_not_found', language),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                floating: true,
                snap: true,
                expandedHeight: 200,
                flexibleSpace: _buildHeader(context, content, language),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Theme Card
                    _buildThemeCard(context, content, language),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Guidance
                    _buildGuidanceSection(context, content.guidance, language),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Kadim Not
                    KadimNotCard(
                      title: L10nService.get('numerology.year_wisdom', language).replaceAll('{number}', year.toString()),
                      content: content.viralQuote,
                      category: KadimCategory.numerology,
                      source: L10nService.get('numerology.cyclical_wisdom', language),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Focus & Avoid
                    _buildFocusAvoidSection(context, content, language),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Affirmation
                    _buildAffirmationCard(context, content.affirmation, language),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Year Cycle Visual
                    _buildYearCycleVisual(context, year, language),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Next Blocks
                    const NextBlocks(currentPage: 'numerology'),
                    const SizedBox(height: AppConstants.spacingXl),

                    // Bottom Navigation
                    PageBottomNavigation(currentRoute: '/numerology', language: language),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PersonalYearContent content, AppLanguage language) {
    final color = _getColorForYear(year);

    return FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.3), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Year Circle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  year.toString(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
            // Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                L10nService.get('numerology.personal_year', language),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  letterSpacing: 1,
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            // Title
            Text(
              content.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, PersonalYearContent content, AppLanguage language) {
    final color = _getColorForYear(year);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.2), AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                L10nService.get('numerology.year_theme', language),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            content.theme,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Energy tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt, color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${L10nService.get('numerology.energy', language)} ${content.energy}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildGuidanceSection(BuildContext context, String guidance, AppLanguage language) {
    final color = _getColorForYear(year);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('numerology.year_guidance', language),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            guidance.trim(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildFocusAvoidSection(
    BuildContext context,
    PersonalYearContent content,
    AppLanguage language,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Focus
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      L10nService.get('numerology.focus', language),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  content.focus,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Avoid
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cancel, color: AppColors.error, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      L10nService.get('numerology.avoid', language),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  content.avoid,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildAffirmationCard(BuildContext context, String affirmation, AppLanguage language) {
    final color = _getColorForYear(year);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.2),
            AppColors.auroraEnd.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote, color: color, size: 32),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            affirmation,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            L10nService.get('numerology.year_affirmation', language),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildYearCycleVisual(BuildContext context, int currentYear, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('numerology.nine_year_cycle', language),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(9, (index) {
              final yearNum = index + 1;
              final isCurrentYear = yearNum == currentYear;
              final color = _getColorForYear(yearNum);

              return GestureDetector(
                onTap: () {
                  context.push('/numerology/personal-year/$yearNum');
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrentYear ? color : color.withValues(alpha: 0.2),
                    border: Border.all(
                      color: color,
                      width: isCurrentYear ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      yearNum.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isCurrentYear ? Colors.white : color,
                        fontWeight: isCurrentYear
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Center(
            child: Text(
              L10nService.get('numerology.current_year_text', language).replaceAll('{number}', currentYear.toString()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Color _getColorForYear(int year) {
    switch (year) {
      case 1:
        return const Color(0xFFFFD700); // Gold - New beginnings
      case 2:
        return const Color(0xFF78909C); // Blue grey - Partnership
      case 3:
        return const Color(0xFFFF9800); // Orange - Creativity
      case 4:
        return const Color(0xFF4CAF50); // Green - Foundation
      case 5:
        return const Color(0xFF00BCD4); // Cyan - Change
      case 6:
        return const Color(0xFFE91E63); // Pink - Love
      case 7:
        return const Color(0xFF9C27B0); // Purple - Introspection
      case 8:
        return const Color(0xFF212121); // Black - Power
      case 9:
        return const Color(0xFFF44336); // Red - Completion
      default:
        return AppColors.auroraStart;
    }
  }
}
