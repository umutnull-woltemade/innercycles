import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/localization_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../shared/widgets/next_blocks.dart';

/// Solar Return Screen
/// Shows the yearly forecast based on the Sun returning to its natal position
class SolarReturnScreen extends ConsumerStatefulWidget {
  const SolarReturnScreen({super.key});

  @override
  ConsumerState<SolarReturnScreen> createState() => _SolarReturnScreenState();
}

class _SolarReturnScreenState extends ConsumerState<SolarReturnScreen> {
  late int _selectedYear;
  late SolarReturnData _returnData;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _calculateReturn();
  }

  void _calculateReturn() {
    final userProfile = ref.read(userProfileProvider);
    final birthDate = userProfile?.birthDate ?? DateTime(1990, 6, 15);
    _returnData = SolarReturnCalculator.calculate(birthDate, _selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    // Watch for profile changes
    ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildYearSelector(context),
                const SizedBox(height: AppConstants.spacingXl),
                _buildReturnInfo(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildYearThemes(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildMonthlyHighlights(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildKeyDates(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildAdvice(context, language),
                const SizedBox(height: AppConstants.spacingXxl),
                // Next Blocks
                const NextBlocks(currentPage: 'solar_return'),
                const SizedBox(height: AppConstants.spacingXl),
                // Entertainment Disclaimer
                const PageFooterWithDisclaimer(
                  brandText: 'Solar Return — Venus One',
                  disclaimerText: DisclaimerTexts.astrology,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLanguage language) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.get('solar_return_title', language),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.starGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                L10n.get('solar_return_subtitle', language),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                AppColors.starGold.withAlpha(60),
                AppColors.starGold.withAlpha(20),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Text('☀️', style: TextStyle(fontSize: 28)),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildYearSelector(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - 2 + i);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = year == _selectedYear;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedYear = year;
                _calculateReturn();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.starGold : Colors.transparent,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Center(
                child: Text(
                  '$year',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected
                        ? AppColors.deepSpace
                        : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildReturnInfo(BuildContext context, AppLanguage language) {
    final userProfile = ref.watch(userProfileProvider);
    final sunSign = userProfile?.sunSign ?? ZodiacSign.aries;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.starGold.withAlpha(30), AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withAlpha(50)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.starGold.withAlpha(100),
                      AppColors.starGold.withAlpha(30),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    sunSign.symbol,
                    style: TextStyle(fontSize: 28, color: sunSign.color),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_selectedYear ${L10n.get('solar_return_title', language)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      L10n.get('solar_return_sun_returns', language).replaceAll('{sign}', sunSign.localizedName(language)),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      context,
                      L10n.get('solar_return_return_date', language),
                      _formatDate(_returnData.exactReturnDate, language),
                    ),
                    _buildInfoItem(
                      context,
                      L10n.get('rising_sign', language),
                      _returnData.risingSign.localizedName(language),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(
                      context,
                      L10n.get('solar_return_sun_house', language),
                      L10n.get('solar_return_house_number', language).replaceAll('{number}', '${_returnData.sunHouse}'),
                    ),
                    _buildInfoItem(
                      context,
                      L10n.get('moon_sign', language),
                      _returnData.moonSign.localizedName(language),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildYearThemes(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.starGold, size: 20),
            const SizedBox(width: 8),
            Text(
              L10n.get('solar_return_year_themes', language),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ..._returnData.themes.asMap().entries.map((entry) {
          final index = entry.key;
          final theme = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
            child: _buildThemeCard(context, theme, language),
          ).animate().fadeIn(delay: (300 + index * 100).ms, duration: 400.ms);
        }),
      ],
    );
  }

  Widget _buildThemeCard(BuildContext context, SolarReturnTheme theme, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: theme.color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: theme.color.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(theme.emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10n.get(theme.titleKey, language),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: theme.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  L10n.get(theme.descriptionKey, language),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyHighlights(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: AppColors.auroraStart,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              L10n.get('solar_return_monthly_highlights', language),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              final highlight = _returnData.monthlyHighlights[index];
              final monthAbbr = _getMonthAbbr(index + 1, language);
              return Container(
                width: 80,
                margin: EdgeInsets.only(right: index < 11 ? 8 : 0),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: highlight.isPositive
                      ? Colors.green.withAlpha(20)
                      : highlight.isChallenging
                      ? Colors.orange.withAlpha(20)
                      : AppColors.surfaceLight.withAlpha(30),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  border: Border.all(
                    color: highlight.isPositive
                        ? Colors.green.withAlpha(40)
                        : highlight.isChallenging
                        ? Colors.orange.withAlpha(40)
                        : AppColors.surfaceLight.withAlpha(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      monthAbbr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(highlight.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      L10n.get(highlight.keywordKey, language),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildKeyDates(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.event_note,
              color: AppColors.twilightStart,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              L10n.get('solar_return_important_dates', language),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ..._returnData.keyDates.map(
          (keyDate) => Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withAlpha(30),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Column(
                      children: [
                        Text(
                          '${keyDate.date.day}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.starGold,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          _getMonthAbbr(keyDate.date.month, language),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          L10n.get(keyDate.titleKey, language),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                        Text(
                          L10n.get(keyDate.descriptionKey, language),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(keyDate.emoji, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 700.ms, duration: 400.ms);
  }

  Widget _buildAdvice(BuildContext context, AppLanguage language) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withAlpha(20),
            AppColors.auroraEnd.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.auroraStart.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.auroraStart,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                L10n.get('solar_return_year_advice', language),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.auroraStart,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            L10n.get(_returnData.yearAdviceKey, language),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }

  String _formatDate(DateTime date, AppLanguage language) {
    final monthKey = _getMonthKey(date.month);
    final monthName = L10n.get(monthKey, language);
    return '${date.day} $monthName ${date.year}';
  }

  String _getMonthAbbr(int month, AppLanguage language) {
    final monthAbbrKey = _getMonthAbbrKey(month);
    return L10n.get(monthAbbrKey, language);
  }

  String _getMonthKey(int month) {
    const monthKeys = [
      'month_january',
      'month_february',
      'month_march',
      'month_april',
      'month_may',
      'month_june',
      'month_july',
      'month_august',
      'month_september',
      'month_october',
      'month_november',
      'month_december',
    ];
    return monthKeys[month - 1];
  }

  String _getMonthAbbrKey(int month) {
    const monthAbbrKeys = [
      'month_abbr_jan',
      'month_abbr_feb',
      'month_abbr_mar',
      'month_abbr_apr',
      'month_abbr_may',
      'month_abbr_jun',
      'month_abbr_jul',
      'month_abbr_aug',
      'month_abbr_sep',
      'month_abbr_oct',
      'month_abbr_nov',
      'month_abbr_dec',
    ];
    return monthAbbrKeys[month - 1];
  }
}

/// Solar Return Calculator
class SolarReturnCalculator {
  static SolarReturnData calculate(DateTime birthDate, int year) {
    // Calculate exact return date (approximate - Sun returns to natal position)
    final exactReturnDate = DateTime(
      year,
      birthDate.month,
      birthDate.day,
      12,
      0,
    );

    // Generate return data based on year and birth data
    final seed = year * 1000 + birthDate.month * 10 + birthDate.day;

    // Pseudo-random but consistent results
    final risingIndex = (seed + year) % 12;
    final moonIndex = (seed + year * 2) % 12;
    final sunHouse = ((seed + year) % 12) + 1;

    return SolarReturnData(
      year: year,
      birthDate: birthDate,
      exactReturnDate: exactReturnDate,
      risingSign: ZodiacSign.values[risingIndex],
      moonSign: ZodiacSign.values[moonIndex],
      sunHouse: sunHouse,
      themes: _generateThemes(seed, sunHouse),
      monthlyHighlights: _generateMonthlyHighlights(seed),
      keyDates: _generateKeyDates(year, seed),
      yearAdviceKey: _generateAdviceKey(sunHouse),
    );
  }

  static List<SolarReturnTheme> _generateThemes(int seed, int sunHouse) {
    final allThemes = [
      SolarReturnTheme(
        titleKey: 'solar_return_theme_career_title',
        descriptionKey: 'solar_return_theme_career_desc',
        emoji: '💼',
        color: AppColors.starGold,
      ),
      SolarReturnTheme(
        titleKey: 'solar_return_theme_relationships_title',
        descriptionKey: 'solar_return_theme_relationships_desc',
        emoji: '💕',
        color: Colors.pink,
      ),
      SolarReturnTheme(
        titleKey: 'solar_return_theme_personal_growth_title',
        descriptionKey: 'solar_return_theme_personal_growth_desc',
        emoji: '🌱',
        color: AppColors.earthElement,
      ),
      SolarReturnTheme(
        titleKey: 'solar_return_theme_financial_title',
        descriptionKey: 'solar_return_theme_financial_desc',
        emoji: '💰',
        color: AppColors.celestialGold,
      ),
      SolarReturnTheme(
        titleKey: 'solar_return_theme_education_travel_title',
        descriptionKey: 'solar_return_theme_education_travel_desc',
        emoji: '✈️',
        color: AppColors.airElement,
      ),
      SolarReturnTheme(
        titleKey: 'solar_return_theme_home_family_title',
        descriptionKey: 'solar_return_theme_home_family_desc',
        emoji: '🏠',
        color: AppColors.waterElement,
      ),
      SolarReturnTheme(
        titleKey: 'solar_return_theme_creativity_title',
        descriptionKey: 'solar_return_theme_creativity_desc',
        emoji: '🎨',
        color: AppColors.auroraStart,
      ),
      SolarReturnTheme(
        titleKey: 'solar_return_theme_health_routine_title',
        descriptionKey: 'solar_return_theme_health_routine_desc',
        emoji: '🧘',
        color: Colors.teal,
      ),
    ];

    // Select 3-4 themes based on sun house
    final selectedIndices = <int>{};
    selectedIndices.add(sunHouse % allThemes.length);
    selectedIndices.add((sunHouse + 3) % allThemes.length);
    selectedIndices.add((sunHouse + 7) % allThemes.length);
    if (sunHouse > 6) {
      selectedIndices.add((sunHouse + 5) % allThemes.length);
    }

    return selectedIndices.map((i) => allThemes[i]).toList();
  }

  static List<MonthlyHighlight> _generateMonthlyHighlights(int seed) {
    final keywordKeys = [
      'solar_return_keyword_beginning',
      'solar_return_keyword_growth',
      'solar_return_keyword_challenge',
      'solar_return_keyword_opportunity',
      'solar_return_keyword_rest',
      'solar_return_keyword_action',
      'solar_return_keyword_reflection',
      'solar_return_keyword_progress',
      'solar_return_keyword_change',
      'solar_return_keyword_balance',
      'solar_return_keyword_harvest',
      'solar_return_keyword_closure',
    ];
    final emojis = [
      '🚀',
      '🌿',
      '⚡',
      '✨',
      '🌙',
      '🔥',
      '🤔',
      '📈',
      '🔄',
      '⚖️',
      '🌾',
      '🎁',
    ];

    return List.generate(12, (month) {
      final monthSeed = seed + month;
      final isPositive = monthSeed % 3 == 0;
      final isChallenging = monthSeed % 5 == 0 && !isPositive;

      return MonthlyHighlight(
        month: month + 1,
        keywordKey: keywordKeys[month],
        emoji: emojis[month],
        isPositive: isPositive,
        isChallenging: isChallenging,
      );
    });
  }

  static List<KeyDate> _generateKeyDates(int year, int seed) {
    return [
      KeyDate(
        date: DateTime(year, 3, 20 + (seed % 3)),
        titleKey: 'solar_return_spring_equinox_title',
        descriptionKey: 'solar_return_spring_equinox_desc',
        emoji: '🌸',
      ),
      KeyDate(
        date: DateTime(year, 6, 20 + (seed % 2)),
        titleKey: 'solar_return_summer_solstice_title',
        descriptionKey: 'solar_return_summer_solstice_desc',
        emoji: '☀️',
      ),
      KeyDate(
        date: DateTime(year, 9, 22 + (seed % 2)),
        titleKey: 'solar_return_autumn_equinox_title',
        descriptionKey: 'solar_return_autumn_equinox_desc',
        emoji: '🍂',
      ),
      KeyDate(
        date: DateTime(year, 12, 21),
        titleKey: 'solar_return_winter_solstice_title',
        descriptionKey: 'solar_return_winter_solstice_desc',
        emoji: '❄️',
      ),
    ];
  }

  static String _generateAdviceKey(int sunHouse) {
    final houseAdviceKeys = {
      1: 'solar_return_advice_house_1',
      2: 'solar_return_advice_house_2',
      3: 'solar_return_advice_house_3',
      4: 'solar_return_advice_house_4',
      5: 'solar_return_advice_house_5',
      6: 'solar_return_advice_house_6',
      7: 'solar_return_advice_house_7',
      8: 'solar_return_advice_house_8',
      9: 'solar_return_advice_house_9',
      10: 'solar_return_advice_house_10',
      11: 'solar_return_advice_house_11',
      12: 'solar_return_advice_house_12',
    };

    return houseAdviceKeys[sunHouse] ?? 'solar_return_advice_default';
  }
}

/// Solar Return Data
class SolarReturnData {
  final int year;
  final DateTime birthDate;
  final DateTime exactReturnDate;
  final ZodiacSign risingSign;
  final ZodiacSign moonSign;
  final int sunHouse;
  final List<SolarReturnTheme> themes;
  final List<MonthlyHighlight> monthlyHighlights;
  final List<KeyDate> keyDates;
  final String yearAdviceKey;

  SolarReturnData({
    required this.year,
    required this.birthDate,
    required this.exactReturnDate,
    required this.risingSign,
    required this.moonSign,
    required this.sunHouse,
    required this.themes,
    required this.monthlyHighlights,
    required this.keyDates,
    required this.yearAdviceKey,
  });
}

class SolarReturnTheme {
  final String titleKey;
  final String descriptionKey;
  final String emoji;
  final Color color;

  SolarReturnTheme({
    required this.titleKey,
    required this.descriptionKey,
    required this.emoji,
    required this.color,
  });
}

class MonthlyHighlight {
  final int month;
  final String keywordKey;
  final String emoji;
  final bool isPositive;
  final bool isChallenging;

  MonthlyHighlight({
    required this.month,
    required this.keywordKey,
    required this.emoji,
    required this.isPositive,
    required this.isChallenging,
  });
}

class KeyDate {
  final DateTime date;
  final String titleKey;
  final String descriptionKey;
  final String emoji;

  KeyDate({
    required this.date,
    required this.titleKey,
    required this.descriptionKey,
    required this.emoji,
  });
}
