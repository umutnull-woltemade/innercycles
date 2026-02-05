import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/next_blocks.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';

/// Year Ahead Forecast Screen
/// Comprehensive yearly forecast with quarterly breakdowns
class YearAheadScreen extends ConsumerStatefulWidget {
  const YearAheadScreen({super.key});

  @override
  ConsumerState<YearAheadScreen> createState() => _YearAheadScreenState();
}

class _YearAheadScreenState extends ConsumerState<YearAheadScreen> {
  late int _selectedYear;
  late YearAheadForecast _forecast;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _generateForecast();
  }

  void _generateForecast([AppLanguage? language]) {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;
    final lang = language ?? AppLanguage.en;
    _forecast = YearAheadService.generate(sign, _selectedYear, lang);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;
    final language = ref.watch(languageProvider);

    // Regenerate forecast when language changes
    _forecast = YearAheadService.generate(sign, _selectedYear, language);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, sign, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildYearOverview(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildQuarterlyBreakdown(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildKeyTransits(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildLuckyPeriods(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildChallengingPeriods(context, language),
                const SizedBox(height: AppConstants.spacingXl),
                _buildYearAffirmation(context, language),
                const SizedBox(height: AppConstants.spacingXxl),
                // Next Blocks
                const NextBlocks(currentPage: 'year_ahead'),
                const SizedBox(height: AppConstants.spacingXl),
                // Entertainment Disclaimer
                PageFooterWithDisclaimer(
                  brandText: '${L10nService.get('year_ahead.title', language)} — Venus One',
                  disclaimerText: DisclaimerTexts.astrology(language),
                  language: language,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ZodiacSign sign, AppLanguage language) {
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
                L10nService.getWithParams('year_ahead.year_forecast', language, params: {'year': '$_selectedYear'}),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  Text(
                    sign.localizedName(language),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: sign.color,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Text(sign.symbol, style: TextStyle(color: sign.color)),
                ],
              ),
            ],
          ),
        ),
        // Year selector
        GestureDetector(
          onTap: () => _showYearPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.starGold.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.starGold.withAlpha(60)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_selectedYear',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: AppColors.starGold),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  void _showYearPicker(BuildContext context) {
    final currentYear = DateTime.now().year;
    final language = ref.read(languageProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              L10nService.get('year_ahead.select_year', language),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(3, (i) {
                final year = currentYear + i;
                final isSelected = year == _selectedYear;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedYear = year;
                      _generateForecast(language);
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.starGold : AppColors.surfaceLight.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$year',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isSelected ? AppColors.deepSpace : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildYearOverview(BuildContext context, AppLanguage language) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withAlpha(30),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.auroraStart.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.auroraStart, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                L10nService.get('year_ahead.year_summary', language),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _forecast.overview,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            children: [
              Expanded(child: _buildScoreCard(context, L10nService.get('categories.career', language), _forecast.careerScore, Icons.work)),
              const SizedBox(width: 12),
              Expanded(child: _buildScoreCard(context, L10nService.get('categories.love', language), _forecast.loveScore, Icons.favorite)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildScoreCard(context, L10nService.get('categories.finance', language), _forecast.financeScore, Icons.attach_money)),
              const SizedBox(width: 12),
              Expanded(child: _buildScoreCard(context, L10nService.get('categories.health', language), _forecast.healthScore, Icons.favorite_border)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildScoreCard(BuildContext context, String label, int score, IconData icon) {
    final color = score >= 80 ? Colors.green : score >= 60 ? AppColors.starGold : score >= 40 ? Colors.orange : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
                Text(
                  '$score%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuarterlyBreakdown(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_view_month, color: AppColors.twilightStart, size: 20),
            const SizedBox(width: 8),
            Text(
              L10nService.get('year_ahead.quarterly_forecasts', language),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ..._forecast.quarters.asMap().entries.map((entry) {
          final index = entry.key;
          final quarter = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
            child: _buildQuarterCard(context, quarter),
          ).animate().fadeIn(delay: (200 + index * 100).ms, duration: 400.ms);
        }),
      ],
    );
  }

  Widget _buildQuarterCard(BuildContext context, QuarterForecast quarter) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: quarter.color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(color: quarter.color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: quarter.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  quarter.name,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: quarter.color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                quarter.dateRange,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
              const Spacer(),
              Text(quarter.emoji, style: const TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            quarter.theme,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            quarter.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyTransits(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.public, color: AppColors.celestialGold, size: 20),
            const SizedBox(width: 8),
            Text(
              L10nService.get('year_ahead.important_transits', language),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ..._forecast.keyTransits.map((transit) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withAlpha(30),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Row(
                  children: [
                    Text(transit.planetEmoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transit.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          Text(
                            transit.dateRange,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.starGold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transit.effect,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildLuckyPeriods(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(
              L10nService.get('year_ahead.lucky_periods', language),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _forecast.luckyPeriods.map((period) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withAlpha(40)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    period,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.green,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(delay: 700.ms, duration: 400.ms);
  }

  Widget _buildChallengingPeriods(BuildContext context, AppLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              L10nService.get('year_ahead.challenging_periods', language),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _forecast.challengingPeriods.map((period) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withAlpha(40)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, color: Colors.orange, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    period,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.orange,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }

  Widget _buildYearAffirmation(BuildContext context, AppLanguage language) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.starGold.withAlpha(20),
            AppColors.auroraEnd.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withAlpha(40)),
      ),
      child: Column(
        children: [
          const Text('✨', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text(
            L10nService.get('year_ahead.year_affirmation', language),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.starGold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '"${_forecast.affirmation}"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 900.ms, duration: 400.ms);
  }
}

/// Year Ahead Service
class YearAheadService {
  static YearAheadForecast generate(ZodiacSign sign, int year, AppLanguage language) {
    final seed = sign.index * 1000 + year;
    final random = Random(seed);

    return YearAheadForecast(
      year: year,
      sign: sign,
      overview: _generateOverview(sign, year, language),
      careerScore: 50 + random.nextInt(45),
      loveScore: 50 + random.nextInt(45),
      financeScore: 50 + random.nextInt(45),
      healthScore: 50 + random.nextInt(45),
      quarters: _generateQuarters(sign, year, random, language),
      keyTransits: _generateTransits(sign, year, language),
      luckyPeriods: _generateLuckyPeriods(sign, year, random, language),
      challengingPeriods: _generateChallengingPeriods(year, random, language),
      affirmation: _generateAffirmation(sign, language),
    );
  }

  static String _generateOverview(ZodiacSign sign, int year, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.getWithParams('year_ahead.overviews.$signKey', language, params: {'year': '$year'});
  }

  static List<QuarterForecast> _generateQuarters(ZodiacSign sign, int year, Random random, AppLanguage language) {
    final themeKeys = [
      ['beginnings', 'energy', 'innovation', 'courage'],
      ['growth', 'stability', 'application', 'gathering'],
      ['harvest', 'balance', 'relationships', 'evaluation'],
      ['completion', 'planning', 'reflection', 'preparation'],
    ];

    final colors = [
      AppColors.fireElement,
      AppColors.earthElement,
      AppColors.airElement,
      AppColors.waterElement,
    ];

    final emojis = ['🌱', '☀️', '🍂', '❄️'];

    return List.generate(4, (i) {
      final q = i + 1;
      final startMonth = i * 3 + 1;
      final endMonth = startMonth + 2;
      final themeIndex = random.nextInt(themeKeys[i].length);
      final themeKey = themeKeys[i][themeIndex];
      final theme = L10nService.get('year_ahead.themes.$themeKey', language);

      return QuarterForecast(
        quarter: q,
        name: L10nService.getWithParams('year_ahead.quarter_name', language, params: {'number': '$q'}),
        dateRange: '${_getMonthName(startMonth, language)} - ${_getMonthName(endMonth, language)}',
        theme: theme,
        description: _getQuarterDescription(sign, q, theme, language),
        color: colors[i],
        emoji: emojis[i],
      );
    });
  }

  static String _getMonthName(int month, AppLanguage language) {
    const monthKeys = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'];
    return L10nService.get('year_ahead.months.${monthKeys[month - 1]}', language);
  }

  static String _getQuarterDescription(ZodiacSign sign, int quarter, String theme, AppLanguage language) {
    final signName = sign.localizedName(language);
    final quarterKey = 'q$quarter';
    return L10nService.getWithParams('year_ahead.quarter_descriptions.$quarterKey', language, params: {'theme': theme, 'sign': signName});
  }

  static List<TransitInfo> _generateTransits(ZodiacSign sign, int year, AppLanguage language) {
    final signName = sign.localizedName(language);
    return [
      TransitInfo(
        planetEmoji: '♃',
        title: L10nService.get('year_ahead.transit_titles.jupiter', language),
        dateRange: L10nService.get('year_ahead.transit_dates.year_long', language),
        effect: L10nService.getWithParams('year_ahead.transit_effects.jupiter', language, params: {'sign': signName}),
      ),
      TransitInfo(
        planetEmoji: '♄',
        title: L10nService.get('year_ahead.transit_titles.saturn', language),
        dateRange: L10nService.get('year_ahead.transit_dates.year_long', language),
        effect: L10nService.get('year_ahead.transit_effects.saturn', language),
      ),
      TransitInfo(
        planetEmoji: '☿',
        title: L10nService.get('year_ahead.transit_titles.mercury_retro', language),
        dateRange: L10nService.get('year_ahead.transit_dates.three_four_times', language),
        effect: L10nService.get('year_ahead.transit_effects.mercury', language),
      ),
    ];
  }

  static List<String> _generateLuckyPeriods(ZodiacSign sign, int year, Random random, AppLanguage language) {
    const monthKeys = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'];
    final luckyMonths = <String>[];

    for (int i = 0; i < 12; i++) {
      if (random.nextDouble() > 0.6) {
        luckyMonths.add(L10nService.get('year_ahead.months.${monthKeys[i]}', language));
      }
    }

    if (luckyMonths.isEmpty) {
      return [
        L10nService.get('year_ahead.months.march', language),
        L10nService.get('year_ahead.months.june', language),
        L10nService.get('year_ahead.months.october', language),
      ];
    }
    return luckyMonths;
  }

  static List<String> _generateChallengingPeriods(int year, Random random, AppLanguage language) {
    // Mercury retrograde periods
    return [
      L10nService.get('year_ahead.mercury_retro_periods.april', language),
      L10nService.get('year_ahead.mercury_retro_periods.august', language),
      L10nService.get('year_ahead.mercury_retro_periods.december', language),
    ];
  }

  static String _generateAffirmation(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.name.toLowerCase();
    return L10nService.get('year_ahead.affirmations.$signKey', language);
  }
}

/// Data classes
class YearAheadForecast {
  final int year;
  final ZodiacSign sign;
  final String overview;
  final int careerScore;
  final int loveScore;
  final int financeScore;
  final int healthScore;
  final List<QuarterForecast> quarters;
  final List<TransitInfo> keyTransits;
  final List<String> luckyPeriods;
  final List<String> challengingPeriods;
  final String affirmation;

  YearAheadForecast({
    required this.year,
    required this.sign,
    required this.overview,
    required this.careerScore,
    required this.loveScore,
    required this.financeScore,
    required this.healthScore,
    required this.quarters,
    required this.keyTransits,
    required this.luckyPeriods,
    required this.challengingPeriods,
    required this.affirmation,
  });
}

class QuarterForecast {
  final int quarter;
  final String name;
  final String dateRange;
  final String theme;
  final String description;
  final Color color;
  final String emoji;

  QuarterForecast({
    required this.quarter,
    required this.name,
    required this.dateRange,
    required this.theme,
    required this.description,
    required this.color,
    required this.emoji,
  });
}

class TransitInfo {
  final String planetEmoji;
  final String title;
  final String dateRange;
  final String effect;

  TransitInfo({
    required this.planetEmoji,
    required this.title,
    required this.dateRange,
    required this.effect,
  });
}
