import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/services/l10n_service.dart';
import '../../../../data/models/house.dart';
import '../../../../data/models/natal_chart.dart';
import '../../../../data/models/planet.dart';
import '../../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../../data/providers/app_providers.dart';

class HousesCard extends ConsumerWidget {
  final NatalChart chart;

  const HousesCard({super.key, required this.chart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    if (chart.houses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: Colors.white.withAlpha(25)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.textMuted,
              size: 48,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              L10nService.get('houses.birth_time_required', language),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              L10nService.get('houses.birth_time_required_desc', language),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Group houses by type
    final angularHouses = chart.houses.where((h) => h.house.isAngular).toList();
    final succedentHouses = chart.houses
        .where((h) => h.house.isSuccedent)
        .toList();
    final cadentHouses = chart.houses.where((h) => h.house.isCadent).toList();

    return Column(
      children: [
        _buildHouseTypeSection(
          context,
          language,
          L10nService.get('houses.angular', language),
          L10nService.get('houses.angular_desc', language),
          angularHouses,
          AppColors.starGold,
          0,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildHouseTypeSection(
          context,
          language,
          L10nService.get('houses.succedent', language),
          L10nService.get('houses.succedent_desc', language),
          succedentHouses,
          AppColors.auroraStart,
          100,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildHouseTypeSection(
          context,
          language,
          L10nService.get('houses.cadent', language),
          L10nService.get('houses.cadent_desc', language),
          cadentHouses,
          AppColors.auroraEnd,
          200,
        ),
      ],
    );
  }

  Widget _buildHouseTypeSection(
    BuildContext context,
    AppLanguage language,
    String title,
    String subtitle,
    List<HouseCusp> houses,
    Color accentColor,
    int delayMs,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: accentColor.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: accentColor),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          ...houses.asMap().entries.map((entry) {
            final index = entry.key;
            final house = entry.value;
            final planetsInHouse = chart.planetsInHouse(house.house);
            return _HouseRow(
              house: house,
              language: language,
              planetsInHouse: planetsInHouse.cast<PlanetPosition>(),
              isLast: index == houses.length - 1,
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: delayMs.ms, duration: 400.ms);
  }
}

class _HouseRow extends StatefulWidget {
  final HouseCusp house;
  final AppLanguage language;
  final List<PlanetPosition> planetsInHouse;
  final bool isLast;

  const _HouseRow({
    required this.house,
    required this.language,
    required this.planetsInHouse,
    this.isLast = false,
  });

  @override
  State<_HouseRow> createState() => _HouseRowState();
}

class _HouseRowState extends State<_HouseRow> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
  }

  // Ev için detaylı ezoterik yorum (i18n)
  String _getEsotericHouseInterpretation(
    int houseNumber,
    zodiac.ZodiacSign sign,
  ) {
    final signName = zodiac.ZodiacSignExtension(
      sign,
    ).localizedName(widget.language);
    final description = L10nService.get(
      'houses.esoteric.$houseNumber.description',
      widget.language,
    );
    // Replace {signName} placeholder if present
    return description.replaceAll('{signName}', signName);
  }

  String _getHouseShadowAndGift(int houseNumber) {
    final shadow = L10nService.get(
      'houses.shadow_gift_short.$houseNumber.shadow',
      widget.language,
    );
    final gift = L10nService.get(
      'houses.shadow_gift_short.$houseNumber.gift',
      widget.language,
    );
    return '$shadow | $gift';
  }

  String _getHouseSignInterpretation(int houseNumber, zodiac.ZodiacSign sign) {
    final signName = zodiac.ZodiacSignExtension(
      sign,
    ).localizedName(widget.language);
    final signKey = sign.name.toLowerCase();

    final theme = L10nService.get(
      'houses.themes.$houseNumber',
      widget.language,
    );
    final trait = L10nService.get(
      'houses.sign_traits.$signKey',
      widget.language,
    );

    // Use template from JSON if available, otherwise build manually
    final template = L10nService.get(
      'houses.sign_interpretation_template',
      widget.language,
    );
    if (template.isNotEmpty &&
        !template.contains('houses.sign_interpretation_template')) {
      return template
          .replaceAll('{houseNumber}', houseNumber.toString())
          .replaceAll('{signName}', signName)
          .replaceAll('{themes}', theme)
          .replaceAll('{traits}', trait);
    }

    // Fallback manual construction
    return '$signName $houseNumber. ${L10nService.get('natal_chart.house', widget.language)} $theme $trait.';
  }

  String _getPlanetsInHouseInterpretation(
    int houseNumber,
    List<PlanetPosition> planets,
  ) {
    if (planets.isEmpty) return '';

    final area = L10nService.get(
      'houses.planet_areas.$houseNumber',
      widget.language,
    );
    final planetNames = planets
        .map((p) => p.planet.localizedName(widget.language))
        .join(', ');
    final count = planets.length;

    // Build interpretation based on language
    if (count == 1) {
      return L10nService.getWithParams(
        'houses.planet_single',
        widget.language,
        params: {
          'planet': planetNames,
          'area': area,
          'energy': planets.first.planet.meaning.toLowerCase(),
        },
      );
    } else {
      return L10nService.getWithParams(
        'houses.planet_multiple',
        widget.language,
        params: {
          'count': count.toString(),
          'planets': planetNames,
          'area': area,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signColor = zodiac.ZodiacSignExtension(widget.house.sign).color;
    final signSymbol = zodiac.ZodiacSignExtension(widget.house.sign).symbol;
    final esotericInterp = _getEsotericHouseInterpretation(
      widget.house.house.number,
      widget.house.sign,
    );
    final shadowGift = _getHouseShadowAndGift(widget.house.house.number);

    return ExpansionTile(
      initiallyExpanded: false,
      onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
      tilePadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: 0,
      ),
      childrenPadding: const EdgeInsets.only(
        left: AppConstants.spacingMd,
        right: AppConstants.spacingMd,
        bottom: AppConstants.spacingMd,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _isExpanded
              ? signColor.withAlpha(80)
              : signColor.withAlpha(51),
          borderRadius: BorderRadius.circular(8),
          border: _isExpanded ? Border.all(color: signColor, width: 2) : null,
        ),
        child: Center(
          child: Text(
            '${widget.house.house.number}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: signColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        widget.house.house.nameTr,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: _isExpanded ? signColor : AppColors.textPrimary,
          fontWeight: _isExpanded ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        widget.house.house.keywords,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(signSymbol, style: TextStyle(fontSize: 18, color: signColor)),
          const SizedBox(width: 4),
          Text(
            '${widget.house.degree}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: signColor),
          ),
          if (widget.planetsInHouse.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.auroraStart.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${widget.planetsInHouse.length}',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.auroraStart),
              ),
            ),
          ],
        ],
      ),
      iconColor: AppColors.textMuted,
      collapsedIconColor: AppColors.textMuted,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [signColor.withAlpha(25), AppColors.surfaceDark],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            border: Border.all(color: signColor.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ezoterik Başlık
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [signColor.withAlpha(40), Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text('✨', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getEsotericTitle(widget.house.house.number),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: signColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Ezoterik Yorum
              if (esotericInterp.isNotEmpty) ...[
                Text(
                  esotericInterp,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Gölge ve Armağan
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('🌑', style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(
                            shadowGift.split(' | ')[0],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.orange.shade300,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.white12),
                    Expanded(
                      child: Column(
                        children: [
                          Text('🌟', style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(
                            shadowGift.split(' | ')[1],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.starGold,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // House meaning header
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: AppColors.starGold),
                  const SizedBox(width: 8),
                  Text(
                    L10nService.get('houses.house_meaning', widget.language),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.house.house.meaning,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),

              // Detailed house interpretation
              const SizedBox(height: AppConstants.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: signColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: signColor.withAlpha(50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          signSymbol,
                          style: TextStyle(fontSize: 14, color: signColor),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          L10nService.get(
                            'houses.under_sign_rule',
                            widget.language,
                          ).replaceAll(
                            '{signName}',
                            zodiac.ZodiacSignExtension(
                              widget.house.sign,
                            ).localizedName(widget.language),
                          ),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: signColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getHouseSignInterpretation(
                        widget.house.house.number,
                        widget.house.sign,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.planetsInHouse.isNotEmpty) ...[
                const SizedBox(height: AppConstants.spacingMd),
                Row(
                  children: [
                    Icon(Icons.public, size: 16, color: AppColors.auroraStart),
                    const SizedBox(width: 8),
                    Text(
                      L10nService.get(
                        'houses.planets_in_house',
                        widget.language,
                      ),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.auroraStart,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.planetsInHouse.map((planet) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: planet.planet.color.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: planet.planet.color.withAlpha(128),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            planet.planet.symbol,
                            style: TextStyle(
                              fontSize: 14,
                              color: planet.planet.color,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            planet.planet.localizedName(widget.language),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  _getPlanetsInHouseInterpretation(
                    widget.house.house.number,
                    widget.planetsInHouse,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ] else ...[
                const SizedBox(height: AppConstants.spacingMd),
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingSm),
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          L10nService.get(
                            'houses.no_planets_info',
                            widget.language,
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getEsotericTitle(int houseNumber) {
    final title = L10nService.get(
      'houses.esoteric.$houseNumber.title',
      widget.language,
    );
    if (title.isNotEmpty && !title.contains('houses.esoteric')) {
      return title;
    }
    return '$houseNumber. ${L10nService.get('natal_chart.house', widget.language)}';
  }
}
