import 'dart:math' show Random, pi, sin;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/services/moon_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/kadim_not_card.dart';
import '../../../shared/widgets/next_blocks.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';

class TimingScreen extends ConsumerStatefulWidget {
  const TimingScreen({super.key});

  @override
  ConsumerState<TimingScreen> createState() => _TimingScreenState();
}

class _TimingScreenState extends ConsumerState<TimingScreen> {
  TimingCategory _selectedCategory = TimingCategory.all;

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;
    final birthDate = userProfile?.birthDate ?? DateTime(1990, 1, 1);
    final language = ref.watch(languageProvider);

    final recommendations = TimingService.getRecommendations(
      sunSign: sign,
      birthDate: birthDate,
      category: _selectedCategory,
      language: language,
    );

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, language),
              _buildCategorySelector(language),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  children: [
                    _buildTodayOverview(context, language),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildCurrentConditions(context, language),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildRecommendations(context, recommendations, language),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildUpcoming7Days(context, sign, language),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildPlanetaryHours(context, language),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildLuckyElements(context, sign, birthDate, language),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildBiorhythm(context, birthDate, language),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildDailyAspects(context, language),
                    const SizedBox(height: AppConstants.spacingXl),
                    // Kadim Not
                    KadimNotCard(
                      category: KadimCategory.astrology,
                      title: L10nService.get('timing.kadim_title', language),
                      content: L10nService.get(
                        'timing.kadim_content',
                        language,
                      ),
                      icon: Icons.access_time,
                    ),
                    const SizedBox(height: AppConstants.spacingXl),
                    // Next Blocks
                    const NextBlocks(currentPage: 'timing'),
                    const SizedBox(height: AppConstants.spacingXl),
                    // Entertainment Disclaimer
                    PageFooterWithDisclaimer(
                      brandText: L10nService.get(
                        'timing.brand_footer',
                        language,
                      ),
                      disclaimerText: DisclaimerTexts.astrology(language),
                      language: language,
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLanguage language) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('timing.title', language),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  L10nService.get('timing.subtitle', language),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.celestialGold.withAlpha(40),
                  AppColors.starGold.withAlpha(20),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time,
              color: AppColors.celestialGold,
              size: 24,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildCategorySelector(AppLanguage language) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
        itemCount: TimingCategory.values.length,
        itemBuilder: (context, index) {
          final category = TimingCategory.values[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            category.color.withAlpha(60),
                            category.color.withAlpha(30),
                          ],
                        )
                      : null,
                  color: isSelected
                      ? null
                      : AppColors.surfaceLight.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? category.color : Colors.white12,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      size: 16,
                      color: isSelected
                          ? category.color
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.localizedName(language),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? category.color
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildTodayOverview(BuildContext context, AppLanguage language) {
    final moonPhase = MoonService.getCurrentPhase();
    final moonSign = MoonService.getCurrentMoonSign();
    final vocStatus = VoidOfCourseMoonExtension.getVoidOfCourseStatus();
    final retrogrades = MoonService.getRetrogradePlanets();

    // Calculate overall score
    int score = 70;
    if (vocStatus.isVoid) score -= 20;
    if (retrogrades.contains('mercury')) score -= 10;
    if (moonPhase.name.contains('full') || moonPhase.name.contains('new'))
      score += 10;
    score = score.clamp(0, 100);

    final Color scoreColor = score >= 70
        ? Colors.green
        : score >= 50
        ? Colors.orange
        : Colors.red;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.celestialGold.withAlpha(30),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.celestialGold.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      scoreColor.withAlpha(100),
                      scoreColor.withAlpha(30),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    '$score',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10nService.get('timing.todays_energy', language),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getOverallMessage(score, language),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniIndicator(
                  icon: Icons.nightlight_round,
                  label: moonPhase.localizedName(language),
                  value: moonSign.localizedName(language),
                ),
                Container(width: 1, height: 40, color: Colors.white12),
                GestureDetector(
                  onTap: () => context.push('/void-of-course'),
                  child: _MiniIndicator(
                    icon: vocStatus.isVoid
                        ? Icons.do_not_disturb
                        : Icons.check_circle,
                    label: L10nService.get('timing.voc_short', language),
                    value: vocStatus.isVoid
                        ? L10nService.get('timing.active', language)
                        : L10nService.get('timing.none', language),
                    color: vocStatus.isVoid ? Colors.purple : Colors.green,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white12),
                _MiniIndicator(
                  icon: Icons.replay,
                  label: L10nService.get('timing.retro_short', language),
                  value: retrogrades.isEmpty
                      ? L10nService.get('timing.none', language)
                      : '${retrogrades.length}',
                  color: retrogrades.isEmpty ? Colors.green : Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  String _getOverallMessage(int score, AppLanguage language) {
    if (score >= 80) return L10nService.get('timing.score_excellent', language);
    if (score >= 60) return L10nService.get('timing.score_good', language);
    if (score >= 40) return L10nService.get('timing.score_moderate', language);
    return L10nService.get('timing.score_challenging', language);
  }

  Widget _buildCurrentConditions(BuildContext context, AppLanguage language) {
    final vocStatus = VoidOfCourseMoonExtension.getVoidOfCourseStatus();
    final retrogrades = MoonService.getRetrogradePlanets();

    final conditions = <_ConditionItem>[];

    // VOC Warning
    if (vocStatus.isVoid) {
      conditions.add(
        _ConditionItem(
          icon: Icons.do_not_disturb_on,
          title: L10nService.get('timing.voc_title', language),
          description:
              '${L10nService.get('timing.voc_desc', language)} ${vocStatus.timeRemainingFormatted ?? L10nService.get('timing.ending_soon', language)}',
          color: Colors.purple,
          severity: 2,
        ),
      );
    }

    // Mercury Retrograde
    if (retrogrades.contains('mercury')) {
      conditions.add(
        _ConditionItem(
          icon: Icons.chat_bubble_outline,
          title: L10nService.get('timing.mercury_retro_title', language),
          description: L10nService.get('timing.mercury_retro_desc', language),
          color: Colors.orange,
          severity: 2,
        ),
      );
    }

    // Other Retrogrades
    final otherRetros = retrogrades.where((p) => p != 'mercury').toList();
    if (otherRetros.isNotEmpty) {
      conditions.add(
        _ConditionItem(
          icon: Icons.replay,
          title: L10nService.get('timing.other_retros_title', language),
          description:
              '${otherRetros.map((p) => _getPlanetName(p, language)).join(", ")} ${L10nService.get('timing.in_retrograde', language)}',
          color: Colors.amber,
          severity: 1,
        ),
      );
    }

    if (conditions.isEmpty) {
      conditions.add(
        _ConditionItem(
          icon: Icons.check_circle_outline,
          title: L10nService.get('timing.clear_sky_title', language),
          description: L10nService.get('timing.clear_sky_desc', language),
          color: Colors.green,
          severity: 0,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              L10nService.get('timing.current_conditions', language),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...conditions.map(
          (condition) => _buildConditionCard(context, condition),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildConditionCard(BuildContext context, _ConditionItem condition) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: condition.color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: condition.color.withAlpha(60)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: condition.color.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(condition.icon, color: condition.color, size: 18),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  condition.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: condition.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  condition.description,
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

  Widget _buildRecommendations(
    BuildContext context,
    List<TimingRecommendation> recommendations,
    AppLanguage language,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.lightbulb_outline,
              color: AppColors.celestialGold,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              L10nService.get('timing.good_times', language),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...recommendations.asMap().entries.map((entry) {
          final index = entry.key;
          final rec = entry.value;
          return _buildRecommendationCard(context, rec, index, language);
        }),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    TimingRecommendation rec,
    int index,
    AppLanguage language,
  ) {
    final Color ratingColor = rec.rating >= 4
        ? Colors.green
        : rec.rating >= 3
        ? Colors.amber
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [rec.category.color.withAlpha(25), AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: rec.category.color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: rec.category.color.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  rec.category.icon,
                  color: rec.category.color,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec.activity,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      rec.category.localizedName(language),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: rec.category.color,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating stars
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < rec.rating ? Icons.star : Icons.star_border,
                    size: 14,
                    color: ratingColor,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            rec.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rec.bestTime,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (rec.tip.isNotEmpty)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.celestialGold.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.tips_and_updates,
                          size: 12,
                          color: AppColors.celestialGold,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            rec.tip,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: AppColors.celestialGold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (500 + index * 100).ms, duration: 400.ms);
  }

  Widget _buildUpcoming7Days(
    BuildContext context,
    ZodiacSign sign,
    AppLanguage language,
  ) {
    final days = TimingService.get7DayForecast(sign, language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: AppColors.moonSilver,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              L10nService.get('timing.next_7_days', language),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isToday = index == 0;

              return Container(
                width: 70,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                decoration: BoxDecoration(
                  gradient: isToday
                      ? LinearGradient(
                          colors: [
                            AppColors.celestialGold.withAlpha(40),
                            AppColors.starGold.withAlpha(20),
                          ],
                        )
                      : null,
                  color: isToday ? null : AppColors.surfaceLight.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(
                    color: isToday ? AppColors.celestialGold : Colors.white12,
                    width: isToday ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.dayName,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isToday
                            ? AppColors.celestialGold
                            : AppColors.textMuted,
                        fontWeight: isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: day.color.withAlpha(40),
                      ),
                      child: Center(
                        child: Text(
                          '${day.score}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: day.color,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.moonSign.symbol,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ).animate().fadeIn(
                delay: (600 + index * 50).ms,
                duration: 300.ms,
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  String _getPlanetName(String planet, AppLanguage language) {
    final key = 'planets.${planet.toLowerCase()}';
    return L10nService.get(key, language);
  }

  Widget _buildPlanetaryHours(BuildContext context, AppLanguage language) {
    final planetaryHours = TimingService.getPlanetaryHours(language);
    final currentHour = DateTime.now().hour;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.schedule, color: AppColors.auroraStart, size: 20),
            const SizedBox(width: 8),
            Text(
              L10nService.get('timing.planetary_hours', language),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.auroraStart.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${L10nService.get('timing.now', language)}: ${planetaryHours[currentHour % planetaryHours.length].planetName}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.auroraStart,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withAlpha(20),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              // Current planetary hour highlight
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      planetaryHours[currentHour % planetaryHours.length].color
                          .withAlpha(40),
                      AppColors.surfaceDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  border: Border.all(
                    color: planetaryHours[currentHour % planetaryHours.length]
                        .color
                        .withAlpha(60),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      planetaryHours[currentHour % planetaryHours.length]
                          .symbol,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${planetaryHours[currentHour % planetaryHours.length].planetName} ${L10nService.get('timing.hour', language)}',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color:
                                      planetaryHours[currentHour %
                                              planetaryHours.length]
                                          .color,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            planetaryHours[currentHour % planetaryHours.length]
                                .meaning,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Upcoming hours grid
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final hourIndex =
                        (currentHour + index + 1) % planetaryHours.length;
                    final hour = planetaryHours[hourIndex];
                    final displayHour = (currentHour + index + 1) % 24;

                    return Container(
                      width: 65,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: hour.color.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: hour.color.withAlpha(40)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            hour.symbol,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${displayHour.toString().padLeft(2, '0')}:00',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: AppColors.textMuted),
                          ),
                          Text(
                            hour.planetName,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: hour.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildLuckyElements(
    BuildContext context,
    ZodiacSign sign,
    DateTime birthDate,
    AppLanguage language,
  ) {
    final lucky = TimingService.getLuckyElements(sign, birthDate, language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.starGold, size: 20),
            const SizedBox(width: 8),
            Text(
              L10nService.get('timing.lucky_elements', language),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.starGold.withAlpha(20), AppColors.surfaceDark],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(color: AppColors.starGold.withAlpha(40)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _LuckyCard(
                      icon: Icons.tag,
                      label: L10nService.get('timing.lucky_numbers', language),
                      value: lucky.numbers.join(', '),
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LuckyCard(
                      icon: Icons.color_lens,
                      label: L10nService.get('timing.lucky_color', language),
                      value: lucky.colorName,
                      color: lucky.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LuckyCard(
                      icon: Icons.explore,
                      label: L10nService.get(
                        'timing.lucky_direction',
                        language,
                      ),
                      value: lucky.direction,
                      color: Colors.cyan,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LuckyCard(
                      icon: Icons.access_time,
                      label: L10nService.get('timing.lucky_hour', language),
                      value: lucky.time,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LuckyCard(
                      icon: Icons.local_florist,
                      label: L10nService.get('timing.lucky_flower', language),
                      value: lucky.flower,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LuckyCard(
                      icon: Icons.diamond,
                      label: L10nService.get('timing.lucky_stone', language),
                      value: lucky.gemstone,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 700.ms, duration: 400.ms);
  }

  Widget _buildBiorhythm(
    BuildContext context,
    DateTime birthDate,
    AppLanguage language,
  ) {
    final biorhythm = TimingService.getBiorhythm(birthDate, language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.waves, color: Colors.cyan, size: 20),
            const SizedBox(width: 8),
            Text(
              L10nService.get('timing.biorhythm_cycle', language),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withAlpha(20),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              _BiorhythmBar(
                label: L10nService.get('timing.physical', language),
                value: biorhythm.physical,
                color: Colors.red,
                icon: Icons.fitness_center,
              ),
              const SizedBox(height: 16),
              _BiorhythmBar(
                label: L10nService.get('timing.emotional', language),
                value: biorhythm.emotional,
                color: Colors.pink,
                icon: Icons.favorite,
              ),
              const SizedBox(height: 16),
              _BiorhythmBar(
                label: L10nService.get('timing.intellectual', language),
                value: biorhythm.intellectual,
                color: Colors.blue,
                icon: Icons.psychology,
              ),
              const SizedBox(height: 16),
              _BiorhythmBar(
                label: L10nService.get('timing.intuitive', language),
                value: biorhythm.intuitive,
                color: Colors.purple,
                icon: Icons.visibility,
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        biorhythm.summary,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms, duration: 400.ms);
  }

  Widget _buildDailyAspects(BuildContext context, AppLanguage language) {
    final aspects = TimingService.getDailyAspects(language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.blur_circular, color: AppColors.mystic, size: 20),
            const SizedBox(width: 8),
            Text(
              L10nService.get('timing.daily_aspects', language),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...aspects.map(
          (aspect) => Container(
            margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [aspect.color.withAlpha(30), AppColors.surfaceDark],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: aspect.color.withAlpha(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: aspect.color.withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        aspect.time,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: aspect.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      aspect.planets,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: aspect.isHarmonious
                            ? Colors.green.withAlpha(40)
                            : Colors.orange.withAlpha(40),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        aspect.aspectName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: aspect.isHarmonious
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  aspect.interpretation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 900.ms, duration: 400.ms);
  }
}

// Helper Widgets
class _MiniIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _MiniIndicator({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color ?? AppColors.moonSilver),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textMuted,
            fontSize: 9,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color ?? AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ConditionItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final int severity;

  const _ConditionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.severity,
  });
}

class _LuckyCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _LuckyCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BiorhythmBar extends StatelessWidget {
  final String label;
  final double value; // -1 to 1
  final Color color;
  final IconData icon;

  const _BiorhythmBar({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = ((value + 1) / 2 * 100).round();

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (value + 1) / 2,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withAlpha(150), color],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          child: Text(
            '$percentage%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// Enums and Models
enum TimingCategory {
  all(Icons.apps, AppColors.textPrimary),
  love(Icons.favorite, Colors.pink),
  career(Icons.work, Colors.blue),
  money(Icons.attach_money, Colors.green),
  health(Icons.health_and_safety, Colors.red),
  travel(Icons.flight, Colors.cyan),
  creative(Icons.palette, Colors.purple);

  final IconData icon;
  final Color color;

  const TimingCategory(this.icon, this.color);

  String localizedName(AppLanguage language) {
    final key = 'timing.category_$name';
    return L10nService.get(key, language);
  }
}

class TimingRecommendation {
  final TimingCategory category;
  final String activity;
  final String description;
  final int rating;
  final String bestTime;
  final String tip;

  const TimingRecommendation({
    required this.category,
    required this.activity,
    required this.description,
    required this.rating,
    required this.bestTime,
    this.tip = '',
  });
}

class DayForecast {
  final String dayName;
  final int score;
  final Color color;
  final MoonSign moonSign;

  const DayForecast({
    required this.dayName,
    required this.score,
    required this.color,
    required this.moonSign,
  });
}

class PlanetaryHour {
  final String planet;
  final String planetName;
  final String symbol;
  final Color color;
  final String meaning;

  const PlanetaryHour({
    required this.planet,
    required this.planetName,
    required this.symbol,
    required this.color,
    required this.meaning,
  });
}

class LuckyElements {
  final List<int> numbers;
  final Color color;
  final String colorName;
  final String direction;
  final String time;
  final String flower;
  final String gemstone;

  const LuckyElements({
    required this.numbers,
    required this.color,
    required this.colorName,
    required this.direction,
    required this.time,
    required this.flower,
    required this.gemstone,
  });
}

class Biorhythm {
  final double physical;
  final double emotional;
  final double intellectual;
  final double intuitive;
  final String summary;

  const Biorhythm({
    required this.physical,
    required this.emotional,
    required this.intellectual,
    required this.intuitive,
    required this.summary,
  });
}

class DailyAspect {
  final String time;
  final String planets;
  final String aspectName;
  final bool isHarmonious;
  final String interpretation;
  final Color color;

  const DailyAspect({
    required this.time,
    required this.planets,
    required this.aspectName,
    required this.isHarmonious,
    required this.interpretation,
    required this.color,
  });
}

// Service
class TimingService {
  static List<TimingRecommendation> getRecommendations({
    required ZodiacSign sunSign,
    required DateTime birthDate,
    required TimingCategory category,
    required AppLanguage language,
  }) {
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day + sunSign.index;
    final random = Random(seed);

    final moonSign = MoonService.getCurrentMoonSign();
    final vocStatus = VoidOfCourseMoonExtension.getVoidOfCourseStatus();
    final retrogrades = MoonService.getRetrogradePlanets();

    final allRecommendations = <TimingRecommendation>[];

    // Love recommendations
    if (category == TimingCategory.all || category == TimingCategory.love) {
      int loveRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.libra || moonSign == MoonSign.taurus)
        loveRating++;
      if (vocStatus.isVoid) loveRating--;
      if (retrogrades.contains('venus')) loveRating--;
      loveRating = loveRating.clamp(1, 5);

      allRecommendations.add(
        TimingRecommendation(
          category: TimingCategory.love,
          activity: L10nService.get('timing.rec_love_activity', language),
          description: _getLoveDescription(
            moonSign,
            vocStatus.isVoid,
            retrogrades,
            language,
          ),
          rating: loveRating,
          bestTime: _getBestLoveTime(moonSign, language),
          tip: loveRating >= 4
              ? L10nService.get('timing.tip_express_feelings', language)
              : L10nService.get('timing.tip_wait_patiently', language),
        ),
      );
    }

    // Career recommendations
    if (category == TimingCategory.all || category == TimingCategory.career) {
      int careerRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.capricorn || moonSign == MoonSign.virgo)
        careerRating++;
      if (vocStatus.isVoid) careerRating -= 2;
      if (retrogrades.contains('mercury')) careerRating--;
      careerRating = careerRating.clamp(1, 5);

      allRecommendations.add(
        TimingRecommendation(
          category: TimingCategory.career,
          activity: L10nService.get('timing.rec_career_activity', language),
          description: _getCareerDescription(
            moonSign,
            vocStatus.isVoid,
            retrogrades,
            language,
          ),
          rating: careerRating,
          bestTime: _getBestCareerTime(moonSign, language),
          tip: careerRating >= 4
              ? L10nService.get('timing.tip_take_initiative', language)
              : L10nService.get('timing.tip_do_research', language),
        ),
      );
    }

    // Money recommendations
    if (category == TimingCategory.all || category == TimingCategory.money) {
      int moneyRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.taurus || moonSign == MoonSign.scorpio)
        moneyRating++;
      if (vocStatus.isVoid) moneyRating--;
      moneyRating = moneyRating.clamp(1, 5);

      allRecommendations.add(
        TimingRecommendation(
          category: TimingCategory.money,
          activity: L10nService.get('timing.rec_money_activity', language),
          description: _getMoneyDescription(
            moonSign,
            vocStatus.isVoid,
            language,
          ),
          rating: moneyRating,
          bestTime: _getBestMoneyTime(moonSign, language),
          tip: moneyRating >= 4
              ? L10nService.get('timing.tip_investment_time', language)
              : L10nService.get('timing.tip_save', language),
        ),
      );
    }

    // Health recommendations
    if (category == TimingCategory.all || category == TimingCategory.health) {
      int healthRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.virgo || moonSign == MoonSign.pisces)
        healthRating++;
      healthRating = healthRating.clamp(1, 5);

      allRecommendations.add(
        TimingRecommendation(
          category: TimingCategory.health,
          activity: L10nService.get('timing.rec_health_activity', language),
          description: _getHealthDescription(moonSign, language),
          rating: healthRating,
          bestTime: _getBestHealthTime(moonSign, language),
          tip: healthRating >= 4
              ? L10nService.get('timing.tip_start_new_routines', language)
              : L10nService.get('timing.tip_rest', language),
        ),
      );
    }

    // Travel recommendations
    if (category == TimingCategory.all || category == TimingCategory.travel) {
      int travelRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.sagittarius || moonSign == MoonSign.gemini)
        travelRating++;
      if (retrogrades.contains('mercury')) travelRating -= 2;
      travelRating = travelRating.clamp(1, 5);

      allRecommendations.add(
        TimingRecommendation(
          category: TimingCategory.travel,
          activity: L10nService.get('timing.rec_travel_activity', language),
          description: _getTravelDescription(moonSign, retrogrades, language),
          rating: travelRating,
          bestTime: _getBestTravelTime(moonSign, language),
          tip: travelRating >= 4
              ? L10nService.get('timing.tip_jump_into_adventure', language)
              : L10nService.get('timing.tip_stay_local', language),
        ),
      );
    }

    // Creative recommendations
    if (category == TimingCategory.all || category == TimingCategory.creative) {
      int creativeRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.leo || moonSign == MoonSign.pisces)
        creativeRating++;
      creativeRating = creativeRating.clamp(1, 5);

      allRecommendations.add(
        TimingRecommendation(
          category: TimingCategory.creative,
          activity: L10nService.get('timing.rec_creative_activity', language),
          description: _getCreativeDescription(moonSign, language),
          rating: creativeRating,
          bestTime: _getBestCreativeTime(moonSign, language),
          tip: creativeRating >= 4
              ? L10nService.get('timing.tip_inspiration_peak', language)
              : L10nService.get('timing.tip_watch_and_learn', language),
        ),
      );
    }

    // Sort by rating descending
    allRecommendations.sort((a, b) => b.rating.compareTo(a.rating));

    return allRecommendations;
  }

  static List<DayForecast> get7DayForecast(
    ZodiacSign sign,
    AppLanguage language,
  ) {
    final days = <DayForecast>[];
    final now = DateTime.now();
    final dayNames = [
      L10nService.get('timing.today', language),
      L10nService.get('timing.tomorrow', language),
      ...L10nService.getList('common.weekdays_short', language).skip(2).take(5),
    ];

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final seed = date.year * 10000 + date.month * 100 + date.day + sign.index;
      final random = Random(seed);

      final score = 50 + random.nextInt(40);
      final Color color = score >= 70
          ? Colors.green
          : score >= 50
          ? Colors.amber
          : Colors.red;

      // Approximate moon sign for the day
      final moonIndex = (date.day + date.month) % 12;
      final moonSign = MoonSign.values[moonIndex];

      days.add(
        DayForecast(
          dayName: i < dayNames.length
              ? dayNames[i]
              : _getShortDayName(date.weekday, language),
          score: score,
          color: color,
          moonSign: moonSign,
        ),
      );
    }

    return days;
  }

  static String _getShortDayName(int weekday, AppLanguage language) {
    final names = L10nService.getList('common.weekdays_short', language);
    if (names.isNotEmpty && weekday >= 1 && weekday <= 7) {
      return names[weekday - 1];
    }
    return '$weekday';
  }

  // Description generators
  static String _getLoveDescription(
    MoonSign moon,
    bool voc,
    List<String> retros,
    AppLanguage language,
  ) {
    if (voc) return L10nService.get('timing.rec_love_desc_voc', language);
    if (retros.contains('venus'))
      return L10nService.get('timing.rec_love_desc_venus_retro', language);

    switch (moon) {
      case MoonSign.libra:
        return L10nService.get('timing.rec_love_desc_libra', language);
      case MoonSign.taurus:
        return L10nService.get('timing.rec_love_desc_taurus', language);
      case MoonSign.cancer:
        return L10nService.get('timing.rec_love_desc_cancer', language);
      case MoonSign.scorpio:
        return L10nService.get('timing.rec_love_desc_scorpio', language);
      default:
        return L10nService.get('timing.rec_love_desc_default', language);
    }
  }

  static String _getCareerDescription(
    MoonSign moon,
    bool voc,
    List<String> retros,
    AppLanguage language,
  ) {
    if (voc) return L10nService.get('timing.rec_career_desc_voc', language);
    if (retros.contains('mercury'))
      return L10nService.get('timing.rec_career_desc_mercury_retro', language);

    switch (moon) {
      case MoonSign.capricorn:
        return L10nService.get('timing.rec_career_desc_capricorn', language);
      case MoonSign.virgo:
        return L10nService.get('timing.rec_career_desc_virgo', language);
      case MoonSign.aries:
        return L10nService.get('timing.rec_career_desc_aries', language);
      default:
        return L10nService.get('timing.rec_career_desc_default', language);
    }
  }

  static String _getMoneyDescription(
    MoonSign moon,
    bool voc,
    AppLanguage language,
  ) {
    if (voc) return L10nService.get('timing.rec_money_desc_voc', language);

    switch (moon) {
      case MoonSign.taurus:
        return L10nService.get('timing.rec_money_desc_taurus', language);
      case MoonSign.scorpio:
        return L10nService.get('timing.rec_money_desc_scorpio', language);
      case MoonSign.capricorn:
        return L10nService.get('timing.rec_money_desc_capricorn', language);
      default:
        return L10nService.get('timing.rec_money_desc_default', language);
    }
  }

  static String _getHealthDescription(MoonSign moon, AppLanguage language) {
    switch (moon) {
      case MoonSign.virgo:
        return L10nService.get('timing.rec_health_desc_virgo', language);
      case MoonSign.pisces:
        return L10nService.get('timing.rec_health_desc_pisces', language);
      case MoonSign.aries:
        return L10nService.get('timing.rec_health_desc_aries', language);
      case MoonSign.cancer:
        return L10nService.get('timing.rec_health_desc_cancer', language);
      default:
        return L10nService.get('timing.rec_health_desc_default', language);
    }
  }

  static String _getTravelDescription(
    MoonSign moon,
    List<String> retros,
    AppLanguage language,
  ) {
    if (retros.contains('mercury'))
      return L10nService.get('timing.rec_travel_desc_mercury_retro', language);

    switch (moon) {
      case MoonSign.sagittarius:
        return L10nService.get('timing.rec_travel_desc_sagittarius', language);
      case MoonSign.gemini:
        return L10nService.get('timing.rec_travel_desc_gemini', language);
      default:
        return L10nService.get('timing.rec_travel_desc_default', language);
    }
  }

  static String _getCreativeDescription(MoonSign moon, AppLanguage language) {
    switch (moon) {
      case MoonSign.leo:
        return L10nService.get('timing.rec_creative_desc_leo', language);
      case MoonSign.pisces:
        return L10nService.get('timing.rec_creative_desc_pisces', language);
      case MoonSign.aquarius:
        return L10nService.get('timing.rec_creative_desc_aquarius', language);
      default:
        return L10nService.get('timing.rec_creative_desc_default', language);
    }
  }

  // Best time generators
  static String _getBestLoveTime(MoonSign moon, AppLanguage language) {
    switch (moon) {
      case MoonSign.libra:
      case MoonSign.taurus:
        return L10nService.get('timing.best_time_evening_18_21', language);
      case MoonSign.cancer:
        return L10nService.get('timing.best_time_night_20_23', language);
      default:
        return L10nService.get('timing.best_time_evening_hours', language);
    }
  }

  static String _getBestCareerTime(MoonSign moon, AppLanguage language) {
    switch (moon) {
      case MoonSign.capricorn:
      case MoonSign.virgo:
        return L10nService.get('timing.best_time_morning_09_12', language);
      case MoonSign.aries:
        return L10nService.get(
          'timing.best_time_early_morning_08_10',
          language,
        );
      default:
        return L10nService.get('timing.best_time_noon_hours', language);
    }
  }

  static String _getBestMoneyTime(MoonSign moon, AppLanguage language) {
    switch (moon) {
      case MoonSign.taurus:
        return L10nService.get('timing.best_time_noon_11_14', language);
      case MoonSign.capricorn:
        return L10nService.get('timing.best_time_morning_10_12', language);
      default:
        return L10nService.get('timing.best_time_business_hours', language);
    }
  }

  static String _getBestHealthTime(MoonSign moon, AppLanguage language) {
    switch (moon) {
      case MoonSign.aries:
        return L10nService.get(
          'timing.best_time_early_morning_06_09',
          language,
        );
      case MoonSign.virgo:
        return L10nService.get('timing.best_time_morning_07_10', language);
      default:
        return L10nService.get('timing.best_time_all_day', language);
    }
  }

  static String _getBestTravelTime(MoonSign moon, AppLanguage language) {
    switch (moon) {
      case MoonSign.sagittarius:
        return L10nService.get('timing.best_time_early_morning', language);
      case MoonSign.gemini:
        return L10nService.get('timing.best_time_afternoon', language);
      default:
        return L10nService.get('timing.best_time_flexible', language);
    }
  }

  static String _getBestCreativeTime(MoonSign moon, AppLanguage language) {
    switch (moon) {
      case MoonSign.pisces:
        return L10nService.get('timing.best_time_late_night', language);
      case MoonSign.leo:
        return L10nService.get('timing.best_time_afternoon_14_18', language);
      default:
        return L10nService.get('timing.best_time_evening_hours', language);
    }
  }

  // Planetary Hours
  static List<PlanetaryHour> getPlanetaryHours(AppLanguage language) {
    // Traditional Chaldean order, starting from Sunday sunrise
    final now = DateTime.now();
    final dayOfWeek = now.weekday % 7; // Sunday = 0

    // Day rulers in order: Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn
    final dayRulers = [
      PlanetaryHour(
        planet: 'Sun',
        planetName: L10nService.get('planets.sun', language),
        symbol: '☀️',
        color: Colors.amber,
        meaning: L10nService.get('timing.planet_sun_meaning', language),
      ),
      PlanetaryHour(
        planet: 'Moon',
        planetName: L10nService.get('planets.moon', language),
        symbol: '🌙',
        color: Colors.blueGrey,
        meaning: L10nService.get('timing.planet_moon_meaning', language),
      ),
      PlanetaryHour(
        planet: 'Mars',
        planetName: L10nService.get('planets.mars', language),
        symbol: '♂️',
        color: Colors.red,
        meaning: L10nService.get('timing.planet_mars_meaning', language),
      ),
      PlanetaryHour(
        planet: 'Mercury',
        planetName: L10nService.get('planets.mercury', language),
        symbol: '☿️',
        color: Colors.cyan,
        meaning: L10nService.get('timing.planet_mercury_meaning', language),
      ),
      PlanetaryHour(
        planet: 'Jupiter',
        planetName: L10nService.get('planets.jupiter', language),
        symbol: '♃',
        color: Colors.purple,
        meaning: L10nService.get('timing.planet_jupiter_meaning', language),
      ),
      PlanetaryHour(
        planet: 'Venus',
        planetName: L10nService.get('planets.venus', language),
        symbol: '♀️',
        color: Colors.pink,
        meaning: L10nService.get('timing.planet_venus_meaning', language),
      ),
      PlanetaryHour(
        planet: 'Saturn',
        planetName: L10nService.get('planets.saturn', language),
        symbol: '♄',
        color: Colors.brown,
        meaning: L10nService.get('timing.planet_saturn_meaning', language),
      ),
    ];

    // Rotate based on day of week
    final hourSequence = <PlanetaryHour>[];
    for (int i = 0; i < 24; i++) {
      final index = (dayOfWeek + i) % 7;
      hourSequence.add(dayRulers[index]);
    }

    return hourSequence;
  }

  // Lucky Elements
  static LuckyElements getLuckyElements(
    ZodiacSign sign,
    DateTime birthDate,
    AppLanguage language,
  ) {
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day + sign.index;
    final random = Random(seed);

    // Generate lucky numbers based on sign and day
    final baseNumbers = <int>[];
    final signNumber = sign.index + 1;
    baseNumbers.add(signNumber);
    baseNumbers.add((now.day + signNumber) % 49 + 1);
    baseNumbers.add((now.month * signNumber) % 49 + 1);
    baseNumbers.add(random.nextInt(49) + 1);

    // Remove duplicates and sort
    final uniqueNumbers = baseNumbers.toSet().toList()..sort();

    // Lucky colors by sign - use localization keys
    final signColorKeys = {
      ZodiacSign.aries: (Colors.red, 'red'),
      ZodiacSign.taurus: (Colors.green, 'green'),
      ZodiacSign.gemini: (Colors.yellow, 'yellow'),
      ZodiacSign.cancer: (Colors.white, 'white'),
      ZodiacSign.leo: (Colors.orange, 'orange'),
      ZodiacSign.virgo: (Colors.brown, 'brown'),
      ZodiacSign.libra: (Colors.pink, 'pink'),
      ZodiacSign.scorpio: (Colors.purple, 'purple'),
      ZodiacSign.sagittarius: (Colors.blue, 'blue'),
      ZodiacSign.capricorn: (Colors.grey, 'grey'),
      ZodiacSign.aquarius: (Colors.cyan, 'turquoise'),
      ZodiacSign.pisces: (Colors.teal, 'sea_blue'),
    };

    final directions = L10nService.getList('timing.directions', language);
    final times = [
      '06:00-09:00',
      '09:00-12:00',
      '12:00-15:00',
      '15:00-18:00',
      '18:00-21:00',
      '21:00-24:00',
    ];

    // Flower keys for localization
    final signFlowerKeys = {
      ZodiacSign.aries: 'poppy',
      ZodiacSign.taurus: 'rose',
      ZodiacSign.gemini: 'lavender',
      ZodiacSign.cancer: 'lily',
      ZodiacSign.leo: 'sunflower',
      ZodiacSign.virgo: 'daisy',
      ZodiacSign.libra: 'orchid',
      ZodiacSign.scorpio: 'chrysanthemum',
      ZodiacSign.sagittarius: 'carnation',
      ZodiacSign.capricorn: 'pansy',
      ZodiacSign.aquarius: 'violet',
      ZodiacSign.pisces: 'water_lily',
    };

    // Gemstone keys for localization
    final signGemstoneKeys = {
      ZodiacSign.aries: 'diamond',
      ZodiacSign.taurus: 'emerald',
      ZodiacSign.gemini: 'agate',
      ZodiacSign.cancer: 'pearl',
      ZodiacSign.leo: 'ruby',
      ZodiacSign.virgo: 'sapphire',
      ZodiacSign.libra: 'opal',
      ZodiacSign.scorpio: 'topaz',
      ZodiacSign.sagittarius: 'turquoise',
      ZodiacSign.capricorn: 'garnet',
      ZodiacSign.aquarius: 'amethyst',
      ZodiacSign.pisces: 'aquamarine',
    };

    final colorPair = signColorKeys[sign] ?? (Colors.blue, 'blue');
    final flowerKey = signFlowerKeys[sign] ?? 'rose';
    final gemstoneKey = signGemstoneKeys[sign] ?? 'crystal';

    return LuckyElements(
      numbers: uniqueNumbers.take(4).toList(),
      color: colorPair.$1,
      colorName: L10nService.get('colors.${colorPair.$2}', language),
      direction: directions.isNotEmpty
          ? directions[random.nextInt(directions.length)]
          : '',
      time: times[random.nextInt(times.length)],
      flower: L10nService.get('flowers.$flowerKey', language),
      gemstone: L10nService.get('gemstones.$gemstoneKey', language),
    );
  }

  // Biorhythm Calculation
  static Biorhythm getBiorhythm(DateTime birthDate, AppLanguage language) {
    final now = DateTime.now();
    final daysSinceBirth = now.difference(birthDate).inDays;

    // Standard biorhythm cycles
    final physical = sin(2 * pi * daysSinceBirth / 23);
    final emotional = sin(2 * pi * daysSinceBirth / 28);
    final intellectual = sin(2 * pi * daysSinceBirth / 33);
    final intuitive = sin(2 * pi * daysSinceBirth / 38);

    // Generate summary based on values
    String summary;
    final avgPositive = (physical + emotional + intellectual) / 3;

    if (avgPositive > 0.5) {
      summary = L10nService.get('timing.biorhythm_high', language);
    } else if (avgPositive > 0) {
      summary = L10nService.get('timing.biorhythm_balanced', language);
    } else if (avgPositive > -0.5) {
      summary = L10nService.get('timing.biorhythm_low', language);
    } else {
      summary = L10nService.get('timing.biorhythm_critical', language);
    }

    return Biorhythm(
      physical: physical,
      emotional: emotional,
      intellectual: intellectual,
      intuitive: intuitive,
      summary: summary,
    );
  }

  // Daily Aspects
  static List<DailyAspect> getDailyAspects(AppLanguage language) {
    final now = DateTime.now();
    final seed = now.year * 10000 + now.month * 100 + now.day;
    final random = Random(seed);

    final aspects = <DailyAspect>[];

    // Generate 3-5 aspects for the day
    final aspectCount = 3 + random.nextInt(3);

    // Planet pairs using localization keys
    final planetPairKeys = [
      ('sun', 'moon'),
      ('mercury', 'venus'),
      ('mars', 'jupiter'),
      ('venus', 'mars'),
      ('moon', 'saturn'),
      ('jupiter', 'neptune'),
      ('mercury', 'mars'),
      ('venus', 'jupiter'),
      ('saturn', 'pluto'),
      ('moon', 'venus'),
    ];

    // Aspect type keys
    final aspectTypeKeys = [
      ('conjunction', true, Colors.purple),
      ('trine', true, Colors.green),
      ('sextile', true, Colors.cyan),
      ('square', false, Colors.red),
      ('opposition', false, Colors.orange),
    ];

    final usedPairs = <int>{};

    for (int i = 0; i < aspectCount; i++) {
      int pairIndex;
      do {
        pairIndex = random.nextInt(planetPairKeys.length);
      } while (usedPairs.contains(pairIndex));
      usedPairs.add(pairIndex);

      final pairKeys = planetPairKeys[pairIndex];
      final aspectType = aspectTypeKeys[random.nextInt(aspectTypeKeys.length)];
      final hour = 6 + random.nextInt(16);

      final p1 = L10nService.get('planets.${pairKeys.$1}', language);
      final p2 = L10nService.get('planets.${pairKeys.$2}', language);
      final aspectName = L10nService.get('aspects.${aspectType.$1}', language);

      String interpretation;
      if (aspectType.$2) {
        // Harmonious
        interpretation = _getHarmoniousInterpretation(
          pairKeys.$1,
          pairKeys.$2,
          language,
        );
      } else {
        // Challenging
        interpretation = _getChallengingInterpretation(
          pairKeys.$1,
          pairKeys.$2,
          language,
        );
      }

      aspects.add(
        DailyAspect(
          time:
              '${hour.toString().padLeft(2, '0')}:${(random.nextInt(4) * 15).toString().padLeft(2, '0')}',
          planets: '$p1 - $p2',
          aspectName: aspectName,
          isHarmonious: aspectType.$2,
          interpretation: interpretation,
          color: aspectType.$3,
        ),
      );
    }

    // Sort by time
    aspects.sort((a, b) => a.time.compareTo(b.time));

    return aspects;
  }

  static String _getHarmoniousInterpretation(
    String p1,
    String p2,
    AppLanguage language,
  ) {
    if (p1 == 'sun' || p2 == 'sun') {
      return L10nService.get('timing.aspect_sun_harmonious', language);
    }
    if (p1 == 'moon' || p2 == 'moon') {
      return L10nService.get('timing.aspect_moon_harmonious', language);
    }
    if (p1 == 'venus' || p2 == 'venus') {
      return L10nService.get('timing.aspect_venus_harmonious', language);
    }
    if (p1 == 'jupiter' || p2 == 'jupiter') {
      return L10nService.get('timing.aspect_jupiter_harmonious', language);
    }
    return L10nService.get('timing.aspect_default_harmonious', language);
  }

  static String _getChallengingInterpretation(
    String p1,
    String p2,
    AppLanguage language,
  ) {
    if (p1 == 'mars' || p2 == 'mars') {
      return L10nService.get('timing.aspect_mars_challenging', language);
    }
    if (p1 == 'saturn' || p2 == 'saturn') {
      return L10nService.get('timing.aspect_saturn_challenging', language);
    }
    if (p1 == 'pluto' || p2 == 'pluto') {
      return L10nService.get('timing.aspect_pluto_challenging', language);
    }
    return L10nService.get('timing.aspect_default_challenging', language);
  }
}
