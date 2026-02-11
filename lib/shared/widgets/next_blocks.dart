import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/routes.dart';
import '../../data/services/l10n_service.dart';
import '../../data/providers/app_providers.dart';

/// NEXT BLOCKS WIDGET
///
/// Kullanıcıyı dead-end'de bırakmamak için her sayfanın sonuna eklenen
/// "sonraki adımlar" önerileri.
///
/// KULLANIM:
/// ```dart
/// NextBlocks(
///   currentPage: 'horoscope',
///   signName: 'aries', // optional
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
    final blocks = _getBlocksForPage(currentPage, signName);

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

  List<_NextBlock> _getBlocksForPage(String page, String? sign) {
    // Helper to get localized strings
    String t(String key) => L10nService.get(key, language);

    switch (page) {
      case 'horoscope':
      case 'horoscope_detail':
        return [
          _NextBlock(
            icon: Icons.calendar_month_outlined,
            title: t('nav.weekly_reading'),
            subtitle: t('nav.weekly_energy'),
            route: Routes.weeklyHoroscope,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.cosmic_share'),
            subtitle: t('nav.share_energy'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.favorite_border_outlined,
            title: t('nav.compatibility'),
            subtitle: t('nav.who_compatible'),
            route: Routes.compatibility,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.grid_view_outlined,
            title: t('nav.all_signs'),
            subtitle: t('nav.discover_12_signs'),
            route: Routes.horoscope,
          ),
        ];

      case 'natal_chart':
      case 'birth_chart':
        return [
          _NextBlock(
            icon: Icons.compare_arrows_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.transits,
          ),
          _NextBlock(
            icon: Icons.people_outline,
            title: t('nav.synastry'),
            subtitle: t('nav.synastry_insight'),
            route: Routes.synastry,
          ),
          _NextBlock(
            icon: Icons.cake_outlined,
            title: t('nav.solar_return'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.solarReturn,
          ),
          _NextBlock(
            icon: Icons.loop_outlined,
            title: t('nav.saturn_return'),
            subtitle: t('nav.saturn_return_insight'),
            route: Routes.saturnReturn,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share_chart'),
            subtitle: t('nav.share_cosmic_energy'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.person_add_outlined,
            title: t('nav.compare_profiles'),
            subtitle: t('nav.compare_with_friend'),
            route: Routes.comparison,
          ),
        ];

      case 'tarot':
        return [
          _NextBlock(
            icon: Icons.auto_graph_outlined,
            title: t('nav.the_fool'),
            subtitle: t('nav.new_beginnings'),
            route: '/tarot/major/0',
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share_card'),
            subtitle: t('nav.share_cosmic_message'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: t('nav.chakra_analysis'),
            subtitle: t('nav.energy_centers'),
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.nights_stay_outlined,
            title: t('nav.dream_trace'),
            subtitle: t('nav.dream_meanings'),
            route: Routes.dreamInterpretation,
          ),
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.daily_energy'),
            route: Routes.horoscope,
          ),
        ];

      case 'compatibility':
        return [
          _NextBlock(
            icon: Icons.people_outline,
            title: t('nav.synastry'),
            subtitle: t('nav.detailed_relationship'),
            route: Routes.synastry,
          ),
          _NextBlock(
            icon: Icons.group_outlined,
            title: t('nav.composite'),
            subtitle: t('nav.combined_chart'),
            route: Routes.compositeChart,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share_compatibility'),
            subtitle: t('nav.share_cosmic_bond'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.daily_energy'),
            route: Routes.horoscope,
          ),
          _NextBlock(
            icon: Icons.favorite_outlined,
            title: t('nav.love_reading'),
            subtitle: t('nav.relationship_energy'),
            route: Routes.loveHoroscope,
          ),
          _NextBlock(
            icon: Icons.grid_view_outlined,
            title: t('nav.all_signs'),
            subtitle: t('nav.discover_12_signs'),
            route: Routes.horoscope,
          ),
        ];

      case 'numerology':
        return [
          _NextBlock(
            icon: Icons.route_outlined,
            title: t('nav.life_path'),
            subtitle: t('nav.leader_archetype'),
            route: '/numerology/life-path/1',
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.star_outline,
            title: t('nav.expression_number'),
            subtitle: t('nav.master_mystery'),
            route: '/numerology/master/11',
          ),
          _NextBlock(
            icon: Icons.warning_amber_outlined,
            title: t('nav.soul_urge'),
            subtitle: t('nav.deepest_desires'),
            route: '/numerology/karmic-debt/13',
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: t('nav.chakra_analysis'),
            subtitle: t('nav.energy_centers'),
            route: Routes.chakraAnalysis,
          ),
        ];

      case 'chakra':
        return [
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share_energy'),
            subtitle: t('nav.share_cosmic_energy'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.palette_outlined,
            title: t('nav.aura'),
            subtitle: t('nav.aura_insight'),
            route: Routes.aura,
          ),
          _NextBlock(
            icon: Icons.spa_outlined,
            title: t('nav.rituals'),
            subtitle: t('nav.cosmic_rituals'),
            route: Routes.dailyRituals,
          ),
          _NextBlock(
            icon: Icons.nights_stay_outlined,
            title: t('nav.dream_trace'),
            subtitle: t('nav.dream_meanings'),
            route: Routes.dreamInterpretation,
          ),
        ];

      case 'synastry':
        return [
          _NextBlock(
            icon: Icons.group_outlined,
            title: t('nav.composite'),
            subtitle: t('nav.combined_chart'),
            route: Routes.compositeChart,
          ),
          _NextBlock(
            icon: Icons.favorite_border_outlined,
            title: t('nav.compatibility'),
            subtitle: t('nav.basic_compatibility'),
            route: Routes.compatibility,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share_relationship'),
            subtitle: t('nav.share_cosmic_bond'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.favorite_outlined,
            title: t('nav.love_reading'),
            subtitle: t('nav.relationship_energy'),
            route: Routes.loveHoroscope,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.daily_energy'),
            route: Routes.horoscope,
          ),
        ];

      case 'dreams':
      case 'dream_interpretation':
        return [
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: t('nav.chakra_analysis'),
            subtitle: t('nav.energy_centers'),
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_cosmic_message'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.bedtime_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.horoscope,
          ),
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.daily_energy'),
            route: Routes.horoscope,
          ),
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
        ];

      // ════════════════════════════════════════════════════════════════
      // TAROT DETAIL PAGES
      // ════════════════════════════════════════════════════════════════
      case 'major_arcana_detail':
        return [
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: '22 Major Arcana',
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share_card'),
            subtitle: t('nav.share_cosmic_message'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: t('nav.chakra_analysis'),
            subtitle: t('nav.energy_centers'),
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.nights_stay_outlined,
            title: t('nav.dream_trace'),
            subtitle: t('nav.dream_meanings'),
            route: Routes.dreamInterpretation,
          ),
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.daily_energy'),
            route: Routes.horoscope,
          ),
        ];

      // ════════════════════════════════════════════════════════════════
      // NUMEROLOGY DETAIL PAGES
      // ════════════════════════════════════════════════════════════════
      case 'life_path_detail':
        return [
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.star_outline,
            title: t('nav.expression_number'),
            subtitle: t('nav.soul_voice'),
            route: '/numerology/master/11',
          ),
          _NextBlock(
            icon: Icons.warning_amber_outlined,
            title: t('nav.soul_urge'),
            subtitle: t('nav.deepest_desires'),
            route: '/numerology/karmic-debt/13',
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
        ];

      case 'master_number_detail':
        return [
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.route_outlined,
            title: t('nav.life_path'),
            subtitle: t('nav.life_path'),
            route: '/numerology/life-path/1',
          ),
          _NextBlock(
            icon: Icons.warning_amber_outlined,
            title: t('nav.soul_urge'),
            subtitle: t('nav.deepest_desires'),
            route: '/numerology/karmic-debt/13',
          ),
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: t('nav.chakra_analysis'),
            subtitle: t('nav.energy_centers'),
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.account_tree_outlined,
            title: t('nav.kabbalah'),
            subtitle: t('nav.cosmic_wisdom'),
            route: Routes.kabbalah,
          ),
        ];

      case 'karmic_debt_detail':
        return [
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.route_outlined,
            title: t('nav.life_path'),
            subtitle: t('nav.life_path'),
            route: '/numerology/life-path/1',
          ),
          _NextBlock(
            icon: Icons.star_outline,
            title: t('nav.expression_number'),
            subtitle: t('nav.master_mystery'),
            route: '/numerology/master/11',
          ),
          _NextBlock(
            icon: Icons.loop_outlined,
            title: t('nav.saturn_return'),
            subtitle: t('nav.saturn_return_insight'),
            route: Routes.saturnReturn,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
        ];

      case 'personal_year_detail':
        return [
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.calendar_today_outlined,
            title: t('nav.yearly_reading'),
            subtitle: t('nav.yearly_energy'),
            route: Routes.yearAhead,
          ),
          _NextBlock(
            icon: Icons.cake_outlined,
            title: t('nav.solar_return'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.solarReturn,
          ),
          _NextBlock(
            icon: Icons.route_outlined,
            title: t('nav.life_path'),
            subtitle: t('nav.life_path'),
            route: '/numerology/life-path/1',
          ),
          _NextBlock(
            icon: Icons.compare_arrows_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.transits,
          ),
        ];

      case 'transits':
        return [
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.timeline_outlined,
            title: t('nav.progressions'),
            subtitle: t('nav.inner_evolution'),
            route: Routes.progressions,
          ),
          _NextBlock(
            icon: Icons.cake_outlined,
            title: t('nav.solar_return'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.solarReturn,
          ),
          _NextBlock(
            icon: Icons.loop_outlined,
            title: t('nav.saturn_return'),
            subtitle: t('nav.saturn_return_insight'),
            route: Routes.saturnReturn,
          ),
          _NextBlock(
            icon: Icons.schedule_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.best_times'),
            route: Routes.timing,
          ),
        ];

      case 'timing':
        return [
          _NextBlock(
            icon: Icons.compare_arrows_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.transits,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.do_not_disturb_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.voidOfCourse,
          ),
          _NextBlock(
            icon: Icons.calendar_month_outlined,
            title: t('nav.yearly_reading'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.yearAhead,
          ),
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.daily_energy'),
            route: Routes.horoscope,
          ),
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
        ];

      case 'aura':
        return [
          _NextBlock(
            icon: Icons.blur_circular_outlined,
            title: t('nav.chakra_analysis'),
            subtitle: t('nav.energy_centers'),
            route: Routes.chakraAnalysis,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.aura'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.numbers_outlined,
            title: t('nav.numerology'),
            subtitle: t('nav.numerology_insight'),
            route: Routes.numerology,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.spa_outlined,
            title: t('nav.rituals'),
            subtitle: t('nav.energy_practices'),
            route: Routes.dailyRituals,
          ),
          _NextBlock(
            icon: Icons.diamond_outlined,
            title: t('nav.crystal_guide'),
            subtitle: t('nav.cosmic_wisdom'),
            route: Routes.crystalGuide,
          ),
        ];

      case 'saturn_return':
        return [
          _NextBlock(
            icon: Icons.compare_arrows_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.transits,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.calendar_today_outlined,
            title: t('nav.yearly_reading'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.yearAhead,
          ),
          _NextBlock(
            icon: Icons.warning_amber_outlined,
            title: t('nav.soul_urge'),
            subtitle: t('nav.deepest_desires'),
            route: '/numerology/karmic-debt/13',
          ),
          _NextBlock(
            icon: Icons.timeline_outlined,
            title: t('nav.progressions'),
            subtitle: t('nav.inner_evolution'),
            route: Routes.progressions,
          ),
        ];

      case 'progressions':
        return [
          _NextBlock(
            icon: Icons.compare_arrows_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.transits,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.cake_outlined,
            title: t('nav.solar_return'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.solarReturn,
          ),
          _NextBlock(
            icon: Icons.loop_outlined,
            title: t('nav.saturn_return'),
            subtitle: t('nav.saturn_return_insight'),
            route: Routes.saturnReturn,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.calendar_today_outlined,
            title: t('nav.yearly_reading'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.yearAhead,
          ),
        ];

      case 'cosmic_share':
        return [
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.cosmic_wisdom'),
            route: Routes.horoscope,
          ),
          _NextBlock(
            icon: Icons.calendar_month_outlined,
            title: t('nav.weekly_reading'),
            subtitle: t('nav.what_awaits_this_week'),
            route: Routes.weeklyHoroscope,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.favorite_border_outlined,
            title: t('nav.compatibility'),
            subtitle: t('nav.who_compatible'),
            route: Routes.compatibility,
          ),
          _NextBlock(
            icon: Icons.chat_bubble_outline,
            title: t('nav.cosmic_share'),
            subtitle: t('nav.cosmic_wisdom'),
            route: Routes.kozmoz,
          ),
        ];

      case 'weekly_horoscope':
        return [
          _NextBlock(
            icon: Icons.calendar_view_month_outlined,
            title: t('nav.monthly_reading'),
            subtitle: t('nav.what_awaits_this_month'),
            route: Routes.monthlyHoroscope,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.compare_arrows_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.transits,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.grid_view_outlined,
            title: t('nav.all_signs'),
            subtitle: t('nav.discover_12_signs'),
            route: Routes.horoscope,
          ),
        ];

      case 'solar_return':
        return [
          _NextBlock(
            icon: Icons.calendar_today_outlined,
            title: t('nav.yearly_reading'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.yearAhead,
          ),
          _NextBlock(
            icon: Icons.loop_outlined,
            title: t('nav.saturn_return'),
            subtitle: t('nav.saturn_return_insight'),
            route: Routes.saturnReturn,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.compare_arrows_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.transits,
          ),
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.daily_energy'),
            route: Routes.horoscope,
          ),
        ];

      case 'year_ahead':
        return [
          _NextBlock(
            icon: Icons.cake_outlined,
            title: t('nav.solar_return'),
            subtitle: t('nav.solar_return_insight'),
            route: Routes.solarReturn,
          ),
          _NextBlock(
            icon: Icons.calendar_view_month_outlined,
            title: t('nav.monthly_reading'),
            subtitle: t('nav.monthly_energy'),
            route: Routes.monthlyHoroscope,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.share'),
            subtitle: t('nav.share_insight'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.timeline_outlined,
            title: t('nav.progressions'),
            subtitle: t('nav.inner_evolution'),
            route: Routes.progressions,
          ),
          _NextBlock(
            icon: Icons.compare_arrows_outlined,
            title: t('nav.transits'),
            subtitle: t('nav.transits_insight'),
            route: Routes.transits,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
        ];

      default:
        // Generic blocks for any page
        return [
          _NextBlock(
            icon: Icons.wb_sunny_outlined,
            title: t('nav.daily_reading'),
            subtitle: t('nav.daily_energy'),
            route: Routes.horoscope,
          ),
          _NextBlock(
            icon: Icons.auto_awesome_outlined,
            title: t('nav.cosmic_share'),
            subtitle: t('nav.share_energy'),
            route: Routes.cosmicShare,
            isHighlighted: true,
          ),
          _NextBlock(
            icon: Icons.pie_chart_outline,
            title: t('nav.birth_chart'),
            subtitle: t('nav.explore_cosmic_map'),
            route: Routes.birthChart,
          ),
          _NextBlock(
            icon: Icons.style_outlined,
            title: t('nav.tarot'),
            subtitle: t('nav.tarot_guidance'),
            route: Routes.tarot,
          ),
          _NextBlock(
            icon: Icons.favorite_border_outlined,
            title: t('nav.compatibility'),
            subtitle: t('nav.who_compatible'),
            route: Routes.compatibility,
          ),
          _NextBlock(
            icon: Icons.home_outlined,
            title: t('nav.home'),
            subtitle: t('common.all_features'),
            route: Routes.home,
          ),
        ];
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

  const _NextBlockCard({required this.block, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - 32 - 12) / 2; // 2 columns with padding and gap

    return SizedBox(
      width: cardWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(block.route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: block.isHighlighted
                  ? (isDark
                        ? AppColors.starGold.withValues(alpha: 0.1)
                        : AppColors.lightStarGold.withValues(alpha: 0.1))
                  : (isDark ? AppColors.surfaceDark : AppColors.lightCard),
              borderRadius: BorderRadius.circular(12),
              border: block.isHighlighted
                  ? Border.all(
                      color: isDark
                          ? AppColors.starGold.withValues(alpha: 0.3)
                          : AppColors.lightStarGold.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cosmicPurple
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
                const SizedBox(width: 12),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        block.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        block.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

/// Compact version for smaller spaces
class NextBlocksCompact extends StatelessWidget {
  final String currentPage;
  final int maxItems;
  final AppLanguage language;

  const NextBlocksCompact({
    super.key,
    required this.currentPage,
    this.maxItems = 3,
    this.language = AppLanguage.en,
  });

  @override
  Widget build(BuildContext context) {
    return NextBlocks(
      currentPage: currentPage,
      title: L10nService.get('nav.up_next', language),
      language: language,
    );
  }
}
