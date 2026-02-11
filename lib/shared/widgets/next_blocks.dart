import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/routes.dart';
import '../../data/services/l10n_service.dart';
import '../../data/providers/app_providers.dart';

/// NEXT BLOCKS WIDGET - App Store 4.3(b) Compliant
///
/// Suggests next features to explore after completing a page.
/// All astrology/horoscope features removed for App Store compliance.
///
/// USAGE:
/// ```dart
/// NextBlocks(
///   currentPage: 'insight',
///   language: AppLanguage.en,
/// )
/// ```
class NextBlocks extends StatelessWidget {
  final String currentPage;
  final String? signName;
  final String? title;
  final AppLanguage language;

  const NextBlocks({
    super.key,
    required this.currentPage,
    this.signName,
    this.title,
    this.language = AppLanguage.en,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blocks = _getBlocksForPage(currentPage);

    if (blocks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title ?? L10nService.get('common.continue_exploring', language),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Blocks grid (2 columns)
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: blocks
              .map((block) => _NextBlockCard(block: block, isDark: isDark))
              .toList(),
        ),
      ],
    );
  }

  List<_NextBlock> _getBlocksForPage(String page) {
    // Default blocks for all pages - safe features only
    final defaultBlocks = [
      _NextBlock(
        icon: Icons.edit_note_outlined,
        title: language == AppLanguage.en ? 'Journal' : 'Günlük',
        subtitle: language == AppLanguage.en
            ? 'Track your day'
            : 'Gününü takip et',
        route: Routes.journal,
        isHighlighted: true,
      ),
      _NextBlock(
        icon: Icons.auto_awesome_outlined,
        title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
        subtitle: language == AppLanguage.en
            ? 'Personal reflection'
            : 'Kişisel yansıma',
        route: Routes.insight,
      ),
      _NextBlock(
        icon: Icons.nights_stay_outlined,
        title: language == AppLanguage.en ? 'Dreams' : 'Rüyalar',
        subtitle: language == AppLanguage.en
            ? 'Explore your dreams'
            : 'Rüyalarını keşfet',
        route: Routes.dreamInterpretation,
      ),
      _NextBlock(
        icon: Icons.blur_circular_outlined,
        title: language == AppLanguage.en ? 'Chakra' : 'Çakra',
        subtitle: language == AppLanguage.en
            ? 'Energy awareness'
            : 'Enerji farkındalığı',
        route: Routes.chakraAnalysis,
      ),
    ];

    switch (page) {
      case 'journal':
      case 'daily_entry':
        return [
          _NextBlock(
            icon: Icons.insights_outlined,
            title: language == AppLanguage.en ? 'Patterns' : 'Kalıplar',
            subtitle: language == AppLanguage.en
                ? 'Your trends'
                : 'Eğilimlerin',
            route: Routes.journalPatterns,
          ),
          _NextBlock(
            icon: Icons.calendar_month_outlined,
            title: language == AppLanguage.en ? 'Monthly' : 'Aylık',
            subtitle: language == AppLanguage.en
                ? 'Month overview'
                : 'Ay özeti',
            route: Routes.journalMonthly,
          ),
          _NextBlock(
            icon: Icons.archive_outlined,
            title: language == AppLanguage.en ? 'Archive' : 'Arşiv',
            subtitle: language == AppLanguage.en
                ? 'All entries'
                : 'Tüm kayıtlar',
            route: Routes.journalArchive,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Personal reflection'
                : 'Kişisel yansıma',
            route: Routes.insight,
          ),
        ];

      case 'insight':
        return [
          _NextBlock(
            icon: Icons.edit_note_outlined,
            title: language == AppLanguage.en ? 'Journal' : 'Günlük',
            subtitle: language == AppLanguage.en
                ? 'Track your day'
                : 'Gününü takip et',
            route: Routes.journal,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.nights_stay_outlined,
            title: language == AppLanguage.en ? 'Dreams' : 'Rüyalar',
            subtitle: language == AppLanguage.en
                ? 'Explore your dreams'
                : 'Rüyalarını keşfet',
            route: Routes.dreamInterpretation,
          ),
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: language == AppLanguage.en ? 'Chakra' : 'Çakra',
            subtitle: language == AppLanguage.en
                ? 'Energy awareness'
                : 'Enerji farkındalığı',
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: language == AppLanguage.en ? 'Numerology' : 'Numeroloji',
            subtitle: language == AppLanguage.en
                ? 'Number patterns'
                : 'Sayı kalıpları',
            route: Routes.numerology,
          ),
        ];

      case 'dream':
      case 'dream_interpretation':
        return [
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Personal reflection'
                : 'Kişisel yansıma',
            route: Routes.insight,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.book_outlined,
            title: language == AppLanguage.en ? 'Dream Dictionary' : 'Rüya Sözlüğü',
            subtitle: language == AppLanguage.en
                ? 'Symbol meanings'
                : 'Sembol anlamları',
            route: Routes.dreamGlossary,
          ),
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: language == AppLanguage.en ? 'Chakra' : 'Çakra',
            subtitle: language == AppLanguage.en
                ? 'Energy awareness'
                : 'Enerji farkındalığı',
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.self_improvement_outlined,
            title: language == AppLanguage.en ? 'Rituals' : 'Ritüeller',
            subtitle: language == AppLanguage.en
                ? 'Daily practices'
                : 'Günlük pratikler',
            route: Routes.dailyRituals,
          ),
        ];

      case 'chakra':
      case 'chakra_analysis':
        return [
          _NextBlock(
            icon: Icons.spa_outlined,
            title: language == AppLanguage.en ? 'Aura' : 'Aura',
            subtitle: language == AppLanguage.en
                ? 'Energy field'
                : 'Enerji alanı',
            route: Routes.aura,
          ),
          _NextBlock(
            icon: Icons.self_improvement_outlined,
            title: language == AppLanguage.en ? 'Rituals' : 'Ritüeller',
            subtitle: language == AppLanguage.en
                ? 'Daily practices'
                : 'Günlük pratikler',
            route: Routes.dailyRituals,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Personal reflection'
                : 'Kişisel yansıma',
            route: Routes.insight,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.nights_stay_outlined,
            title: language == AppLanguage.en ? 'Dreams' : 'Rüyalar',
            subtitle: language == AppLanguage.en
                ? 'Explore your dreams'
                : 'Rüyalarını keşfet',
            route: Routes.dreamInterpretation,
          ),
        ];

      case 'aura':
        return [
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: language == AppLanguage.en ? 'Chakra' : 'Çakra',
            subtitle: language == AppLanguage.en
                ? 'Energy centers'
                : 'Enerji merkezleri',
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.self_improvement_outlined,
            title: language == AppLanguage.en ? 'Rituals' : 'Ritüeller',
            subtitle: language == AppLanguage.en
                ? 'Daily practices'
                : 'Günlük pratikler',
            route: Routes.dailyRituals,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Personal reflection'
                : 'Kişisel yansıma',
            route: Routes.insight,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.nights_stay_outlined,
            title: language == AppLanguage.en ? 'Dreams' : 'Rüyalar',
            subtitle: language == AppLanguage.en
                ? 'Explore your dreams'
                : 'Rüyalarını keşfet',
            route: Routes.dreamInterpretation,
          ),
        ];

      case 'numerology':
        return [
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Personal reflection'
                : 'Kişisel yansıma',
            route: Routes.insight,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: language == AppLanguage.en ? 'Tarot' : 'Tarot',
            subtitle: language == AppLanguage.en
                ? 'Card meanings'
                : 'Kart anlamları',
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: language == AppLanguage.en ? 'Chakra' : 'Çakra',
            subtitle: language == AppLanguage.en
                ? 'Energy awareness'
                : 'Enerji farkındalığı',
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.menu_book_outlined,
            title: language == AppLanguage.en ? 'Glossary' : 'Sözlük',
            subtitle: language == AppLanguage.en
                ? 'Learn terms'
                : 'Terimleri öğren',
            route: Routes.glossary,
          ),
        ];

      case 'tarot':
        return [
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Personal reflection'
                : 'Kişisel yansıma',
            route: Routes.insight,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: language == AppLanguage.en ? 'Numerology' : 'Numeroloji',
            subtitle: language == AppLanguage.en
                ? 'Number patterns'
                : 'Sayı kalıpları',
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.nights_stay_outlined,
            title: language == AppLanguage.en ? 'Dreams' : 'Rüyalar',
            subtitle: language == AppLanguage.en
                ? 'Dream symbols'
                : 'Rüya sembolleri',
            route: Routes.dreamInterpretation,
          ),
          _NextBlock(
            icon: Icons.menu_book_outlined,
            title: language == AppLanguage.en ? 'Glossary' : 'Sözlük',
            subtitle: language == AppLanguage.en
                ? 'Learn terms'
                : 'Terimleri öğren',
            route: Routes.glossary,
          ),
        ];

      case 'rituals':
      case 'daily_rituals':
        return [
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: language == AppLanguage.en ? 'Chakra' : 'Çakra',
            subtitle: language == AppLanguage.en
                ? 'Energy centers'
                : 'Enerji merkezleri',
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.spa_outlined,
            title: language == AppLanguage.en ? 'Aura' : 'Aura',
            subtitle: language == AppLanguage.en
                ? 'Energy field'
                : 'Enerji alanı',
            route: Routes.aura,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Personal reflection'
                : 'Kişisel yansıma',
            route: Routes.insight,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.nights_stay_outlined,
            title: language == AppLanguage.en ? 'Dreams' : 'Rüyalar',
            subtitle: language == AppLanguage.en
                ? 'Dream journal'
                : 'Rüya günlüğü',
            route: Routes.dreamInterpretation,
          ),
        ];

      case 'glossary':
        return [
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en ? 'Insight' : 'İçgörü',
            subtitle: language == AppLanguage.en
                ? 'Personal reflection'
                : 'Kişisel yansıma',
            route: Routes.insight,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.article_outlined,
            title: language == AppLanguage.en ? 'Articles' : 'Makaleler',
            subtitle: language == AppLanguage.en
                ? 'Read more'
                : 'Daha fazla oku',
            route: Routes.articles,
          ),
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: language == AppLanguage.en ? 'Numerology' : 'Numeroloji',
            subtitle: language == AppLanguage.en
                ? 'Number patterns'
                : 'Sayı kalıpları',
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: language == AppLanguage.en ? 'Tarot' : 'Tarot',
            subtitle: language == AppLanguage.en
                ? 'Card meanings'
                : 'Kart anlamları',
            route: Routes.tarot,
          ),
        ];

      default:
        return defaultBlocks;
    }
  }
}

class _NextBlock {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool isHighlighted;

  const _NextBlock({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.isHighlighted = false,
  });
}

class _NextBlockCard extends StatelessWidget {
  final _NextBlock block;
  final bool isDark;

  const _NextBlockCard({
    required this.block,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48 - 12) / 2;

    return SizedBox(
      width: cardWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(block.route),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: block.isHighlighted
                  ? (isDark
                        ? AppColors.starGold.withValues(alpha: 0.1)
                        : AppColors.lightStarGold.withValues(alpha: 0.1))
                  : (isDark
                        ? AppColors.surfaceDark
                        : AppColors.lightCard),
              borderRadius: BorderRadius.circular(16),
              border: block.isHighlighted
                  ? Border.all(
                      color: isDark
                          ? AppColors.starGold.withValues(alpha: 0.3)
                          : AppColors.lightStarGold.withValues(alpha: 0.3),
                    )
                  : Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.withValues(alpha: 0.1),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cosmicPurple.withValues(alpha: 0.5)
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    block.icon,
                    size: 20,
                    color: block.isHighlighted
                        ? (isDark
                              ? AppColors.starGold
                              : AppColors.lightStarGold)
                        : (isDark
                              ? AppColors.auroraStart
                              : AppColors.lightAuroraStart),
                  ),
                ),
                const SizedBox(height: 12),
                // Title
                Text(
                  block.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  block.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textMuted
                        : AppColors.lightTextMuted,
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
