import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/moon_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

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

    final recommendations = TimingService.getRecommendations(
      sunSign: sign,
      birthDate: birthDate,
      category: _selectedCategory,
    );

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildCategorySelector(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  children: [
                    _buildTodayOverview(context),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildCurrentConditions(context),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildRecommendations(context, recommendations),
                    const SizedBox(height: AppConstants.spacingXl),
                    _buildUpcoming7Days(context, sign),
                    const SizedBox(height: AppConstants.spacingXl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  'Kisisel Zamanlama',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Yildizlara gore en iyi zamanlar',
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
            child: const Icon(Icons.access_time, color: AppColors.celestialGold, size: 24),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildCategorySelector() {
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(colors: [category.color.withAlpha(60), category.color.withAlpha(30)])
                      : null,
                  color: isSelected ? null : AppColors.surfaceLight.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? category.color : Colors.white12,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(category.icon, size: 16, color: isSelected ? category.color : AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      category.nameTr,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected ? category.color : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

  Widget _buildTodayOverview(BuildContext context) {
    final moonPhase = MoonService.getCurrentPhase();
    final moonSign = MoonService.getCurrentMoonSign();
    final vocStatus = VoidOfCourseMoonExtension.getVoidOfCourseStatus();
    final retrogrades = MoonService.getRetrogradePlanets();

    // Calculate overall score
    int score = 70;
    if (vocStatus.isVoid) score -= 20;
    if (retrogrades.contains('mercury')) score -= 10;
    if (moonPhase.name.contains('full') || moonPhase.name.contains('new')) score += 10;
    score = score.clamp(0, 100);

    final Color scoreColor = score >= 70 ? Colors.green : score >= 50 ? Colors.orange : Colors.red;

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
                    colors: [scoreColor.withAlpha(100), scoreColor.withAlpha(30)],
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
                      'Bugunun Enerjisi',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getOverallMessage(score),
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
                  label: moonPhase.nameTr,
                  value: moonSign.nameTr,
                ),
                Container(width: 1, height: 40, color: Colors.white12),
                _MiniIndicator(
                  icon: vocStatus.isVoid ? Icons.do_not_disturb : Icons.check_circle,
                  label: 'VOC',
                  value: vocStatus.isVoid ? 'Aktif' : 'Yok',
                  color: vocStatus.isVoid ? Colors.purple : Colors.green,
                ),
                Container(width: 1, height: 40, color: Colors.white12),
                _MiniIndicator(
                  icon: Icons.replay,
                  label: 'Retro',
                  value: retrogrades.isEmpty ? 'Yok' : '${retrogrades.length}',
                  color: retrogrades.isEmpty ? Colors.green : Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  String _getOverallMessage(int score) {
    if (score >= 80) return 'Mukemmel bir gun! Onemli isler icin ideal.';
    if (score >= 60) return 'Iyi bir gun. Dikkatli ilerleyebilirsin.';
    if (score >= 40) return 'Orta seviye enerji. Rutinlere odaklan.';
    return 'Zorlayici bir gun. Dinlenmeyi tercih et.';
  }

  Widget _buildCurrentConditions(BuildContext context) {
    final vocStatus = VoidOfCourseMoonExtension.getVoidOfCourseStatus();
    final retrogrades = MoonService.getRetrogradePlanets();

    final conditions = <_ConditionItem>[];

    // VOC Warning
    if (vocStatus.isVoid) {
      conditions.add(_ConditionItem(
        icon: Icons.do_not_disturb_on,
        title: 'Ay Bos Seyir',
        description: 'Onemli baslangiclari erteleyin. ${vocStatus.timeRemainingFormatted ?? "Bitis zamani yaklasıyor"}',
        color: Colors.purple,
        severity: 2,
      ));
    }

    // Mercury Retrograde
    if (retrogrades.contains('mercury')) {
      conditions.add(_ConditionItem(
        icon: Icons.chat_bubble_outline,
        title: 'Merkur Retrosu',
        description: 'Iletisim ve sozlesmelerde dikkatli olun. Eski baglantilar donebilir.',
        color: Colors.orange,
        severity: 2,
      ));
    }

    // Other Retrogrades
    final otherRetros = retrogrades.where((p) => p != 'mercury').toList();
    if (otherRetros.isNotEmpty) {
      conditions.add(_ConditionItem(
        icon: Icons.replay,
        title: 'Diger Retrolar',
        description: '${otherRetros.map((p) => _getPlanetNameTr(p)).join(", ")} retroda. Ilgili alanlarda yavaslik.',
        color: Colors.amber,
        severity: 1,
      ));
    }

    if (conditions.isEmpty) {
      conditions.add(_ConditionItem(
        icon: Icons.check_circle_outline,
        title: 'Temiz Gokyuzu',
        description: 'Onemli bir uyari bulunmuyor. Harika bir gun!',
        color: Colors.green,
        severity: 0,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Guncel Kosullar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...conditions.map((condition) => _buildConditionCard(context, condition)),
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

  Widget _buildRecommendations(BuildContext context, List<TimingRecommendation> recommendations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: AppColors.celestialGold, size: 20),
            const SizedBox(width: 8),
            Text(
              'Iyi Zamanlar',
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
          return _buildRecommendationCard(context, rec, index);
        }),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildRecommendationCard(BuildContext context, TimingRecommendation rec, int index) {
    final Color ratingColor = rec.rating >= 4 ? Colors.green : rec.rating >= 3 ? Colors.amber : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            rec.category.color.withAlpha(25),
            AppColors.surfaceDark,
          ],
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
                child: Icon(rec.category.icon, color: rec.category.color, size: 18),
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
                      rec.category.nameTr,
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, size: 12, color: AppColors.textMuted),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.celestialGold.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tips_and_updates, size: 12, color: AppColors.celestialGold),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            rec.tip,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.celestialGold,
                            ),
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

  Widget _buildUpcoming7Days(BuildContext context, ZodiacSign sign) {
    final days = TimingService.get7DayForecast(sign);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, color: AppColors.moonSilver, size: 20),
            const SizedBox(width: 8),
            Text(
              'Onumuzdeki 7 Gun',
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
                      ? LinearGradient(colors: [AppColors.celestialGold.withAlpha(40), AppColors.starGold.withAlpha(20)])
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
                        color: isToday ? AppColors.celestialGold : AppColors.textMuted,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
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
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
              ).animate().fadeIn(delay: (600 + index * 50).ms, duration: 300.ms);
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms);
  }

  String _getPlanetNameTr(String planet) {
    switch (planet.toLowerCase()) {
      case 'mercury': return 'Merkur';
      case 'venus': return 'Venus';
      case 'mars': return 'Mars';
      case 'jupiter': return 'Jupiter';
      case 'saturn': return 'Saturn';
      case 'uranus': return 'Uranus';
      case 'neptune': return 'Neptun';
      case 'pluto': return 'Pluton';
      default: return planet;
    }
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

// Enums and Models
enum TimingCategory {
  all('Tumu', Icons.apps, AppColors.textPrimary),
  love('Ask', Icons.favorite, Colors.pink),
  career('Kariyer', Icons.work, Colors.blue),
  money('Para', Icons.attach_money, Colors.green),
  health('Saglik', Icons.health_and_safety, Colors.red),
  travel('Seyahat', Icons.flight, Colors.cyan),
  creative('Yaraticilik', Icons.palette, Colors.purple);

  final String nameTr;
  final IconData icon;
  final Color color;

  const TimingCategory(this.nameTr, this.icon, this.color);
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

// Service
class TimingService {
  static List<TimingRecommendation> getRecommendations({
    required ZodiacSign sunSign,
    required DateTime birthDate,
    required TimingCategory category,
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
      if (moonSign == MoonSign.libra || moonSign == MoonSign.taurus) loveRating++;
      if (vocStatus.isVoid) loveRating--;
      if (retrogrades.contains('venus')) loveRating--;
      loveRating = loveRating.clamp(1, 5);

      allRecommendations.add(TimingRecommendation(
        category: TimingCategory.love,
        activity: 'Romantik Anlasma',
        description: _getLoveDescription(moonSign, vocStatus.isVoid, retrogrades),
        rating: loveRating,
        bestTime: _getBestLoveTime(moonSign),
        tip: loveRating >= 4 ? 'Duygularini ifade et' : 'Sabırla bekle',
      ));
    }

    // Career recommendations
    if (category == TimingCategory.all || category == TimingCategory.career) {
      int careerRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.capricorn || moonSign == MoonSign.virgo) careerRating++;
      if (vocStatus.isVoid) careerRating -= 2;
      if (retrogrades.contains('mercury')) careerRating--;
      careerRating = careerRating.clamp(1, 5);

      allRecommendations.add(TimingRecommendation(
        category: TimingCategory.career,
        activity: 'Is Gorusmeleri',
        description: _getCareerDescription(moonSign, vocStatus.isVoid, retrogrades),
        rating: careerRating,
        bestTime: _getBestCareerTime(moonSign),
        tip: careerRating >= 4 ? 'Insiyatif al' : 'Arastirma yap',
      ));
    }

    // Money recommendations
    if (category == TimingCategory.all || category == TimingCategory.money) {
      int moneyRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.taurus || moonSign == MoonSign.scorpio) moneyRating++;
      if (vocStatus.isVoid) moneyRating--;
      moneyRating = moneyRating.clamp(1, 5);

      allRecommendations.add(TimingRecommendation(
        category: TimingCategory.money,
        activity: 'Finansal Kararlar',
        description: _getMoneyDescription(moonSign, vocStatus.isVoid),
        rating: moneyRating,
        bestTime: _getBestMoneyTime(moonSign),
        tip: moneyRating >= 4 ? 'Yatirim zamani' : 'Biriktir',
      ));
    }

    // Health recommendations
    if (category == TimingCategory.all || category == TimingCategory.health) {
      int healthRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.virgo || moonSign == MoonSign.pisces) healthRating++;
      healthRating = healthRating.clamp(1, 5);

      allRecommendations.add(TimingRecommendation(
        category: TimingCategory.health,
        activity: 'Saglik Aktiviteleri',
        description: _getHealthDescription(moonSign),
        rating: healthRating,
        bestTime: _getBestHealthTime(moonSign),
        tip: healthRating >= 4 ? 'Yeni rutinler baslat' : 'Dinlen',
      ));
    }

    // Travel recommendations
    if (category == TimingCategory.all || category == TimingCategory.travel) {
      int travelRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.sagittarius || moonSign == MoonSign.gemini) travelRating++;
      if (retrogrades.contains('mercury')) travelRating -= 2;
      travelRating = travelRating.clamp(1, 5);

      allRecommendations.add(TimingRecommendation(
        category: TimingCategory.travel,
        activity: 'Seyahat Planlama',
        description: _getTravelDescription(moonSign, retrogrades),
        rating: travelRating,
        bestTime: _getBestTravelTime(moonSign),
        tip: travelRating >= 4 ? 'Maceraya atil' : 'Yerel kal',
      ));
    }

    // Creative recommendations
    if (category == TimingCategory.all || category == TimingCategory.creative) {
      int creativeRating = 3 + random.nextInt(2);
      if (moonSign == MoonSign.leo || moonSign == MoonSign.pisces) creativeRating++;
      creativeRating = creativeRating.clamp(1, 5);

      allRecommendations.add(TimingRecommendation(
        category: TimingCategory.creative,
        activity: 'Yaratici Projeler',
        description: _getCreativeDescription(moonSign),
        rating: creativeRating,
        bestTime: _getBestCreativeTime(moonSign),
        tip: creativeRating >= 4 ? 'Ilham doruklarda' : 'Izle ve ogren',
      ));
    }

    // Sort by rating descending
    allRecommendations.sort((a, b) => b.rating.compareTo(a.rating));

    return allRecommendations;
  }

  static List<DayForecast> get7DayForecast(ZodiacSign sign) {
    final days = <DayForecast>[];
    final now = DateTime.now();
    final dayNames = ['Bugun', 'Yarin', 'Per', 'Cum', 'Cmt', 'Paz', 'Pzt'];

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final seed = date.year * 10000 + date.month * 100 + date.day + sign.index;
      final random = Random(seed);

      final score = 50 + random.nextInt(40);
      final Color color = score >= 70 ? Colors.green : score >= 50 ? Colors.amber : Colors.red;

      // Approximate moon sign for the day
      final moonIndex = (date.day + date.month) % 12;
      final moonSign = MoonSign.values[moonIndex];

      days.add(DayForecast(
        dayName: i < dayNames.length ? dayNames[i] : _getShortDayName(date.weekday),
        score: score,
        color: color,
        moonSign: moonSign,
      ));
    }

    return days;
  }

  static String _getShortDayName(int weekday) {
    const names = ['Pzt', 'Sal', 'Car', 'Per', 'Cum', 'Cmt', 'Paz'];
    return names[weekday - 1];
  }

  // Description generators
  static String _getLoveDescription(MoonSign moon, bool voc, List<String> retros) {
    if (voc) return 'Bos seyir nedeniyle duygusal kararlar ertelenmeli. Mevcut iliskilere odaklanin.';
    if (retros.contains('venus')) return 'Venus retrosu eski asklar hakkinda dusundurur. Yeni baslangiclar icin beklemeniz uygun.';

    switch (moon) {
      case MoonSign.libra: return 'Iliski enerjisi yuksek. Partner ile uyum ve romantizm icin ideal bir zaman.';
      case MoonSign.taurus: return 'Fiziksel yakinlik ve guvenlik onemlii. Samimi anlar icin uygun.';
      case MoonSign.cancer: return 'Duygusal derinlik artiyor. Ailenizle ve sevilenlerle kaliteli zaman gecirin.';
      case MoonSign.scorpio: return 'Tutkulu ve yogun duygular hakim. Derin baglanti kurmak icin cesur olun.';
      default: return 'Ask hayatinda yeni firsatlar belirebilir. Acik olmak onemli.';
    }
  }

  static String _getCareerDescription(MoonSign moon, bool voc, List<String> retros) {
    if (voc) return 'Onemli is kararlari ertelenmeli. Mevcut projelere devam edin.';
    if (retros.contains('mercury')) return 'Iletisim hatalarina dikkat. Sozlesmeleri dikkatli inceleyin.';

    switch (moon) {
      case MoonSign.capricorn: return 'Kariyer hedefleri netlesir. Uzun vadeli planlar yapmak icin ideal.';
      case MoonSign.virgo: return 'Detaylara odaklanin. Analiz ve organizasyon isleri destekleniyor.';
      case MoonSign.aries: return 'Liderlik enerjisi yuksek. Yeni projeler baslatmak icin cesaret edin.';
      default: return 'Is hayatinda stabil bir gun. Rutinlere bagli kalmak faydali.';
    }
  }

  static String _getMoneyDescription(MoonSign moon, bool voc) {
    if (voc) return 'Buyuk finansal kararlar ertelenmeli. Arastirma ve planlama icin kullanin.';

    switch (moon) {
      case MoonSign.taurus: return 'Finansal istikrar onemlii. Uzun vadeli yatirimlar dusunulebilir.';
      case MoonSign.scorpio: return 'Gizli firsatlar ortaya cikabilir. Arastirma ve analiz yapın.';
      case MoonSign.capricorn: return 'Pratik finansal kararlar icin ideal. Butce planlamasi yapin.';
      default: return 'Para konularinda dikkatli ilerleyin. Buyuk harcamalardan kacinin.';
    }
  }

  static String _getHealthDescription(MoonSign moon) {
    switch (moon) {
      case MoonSign.virgo: return 'Detoks ve temizlik icin ideal. Saglikli rutinler olusturun.';
      case MoonSign.pisces: return 'Ruhsal denge onemlii. Meditasyon ve rahatlama onerilir.';
      case MoonSign.aries: return 'Fiziksel aktivite icin yuksek enerji. Spor ve egzersiz yapin.';
      case MoonSign.cancer: return 'Duygusal saglik on planda. Kendinize sefkat gosterin.';
      default: return 'Genel saglik icin uygun. Dengeli beslenme ve dinlenme onemlii.';
    }
  }

  static String _getTravelDescription(MoonSign moon, List<String> retros) {
    if (retros.contains('mercury')) return 'Seyahat aksakliklarina hazirlikli olun. Planlari B hazir tutun.';

    switch (moon) {
      case MoonSign.sagittarius: return 'Macera ruhu yuksek! Yeni yerler kesfetmek icin mukkemmel.';
      case MoonSign.gemini: return 'Kisa seyahatler ve yerel kesifler icin ideal bir donem.';
      default: return 'Seyahat planlamasi icin uygun. Detaylari onceden belirleyin.';
    }
  }

  static String _getCreativeDescription(MoonSign moon) {
    switch (moon) {
      case MoonSign.leo: return 'Yaratici ifade dorukta! Sanatsal projeler ve performans icin ideal.';
      case MoonSign.pisces: return 'Hayal gucu ve ilham yuksek. Sezgisel yaraticilik destekleniyor.';
      case MoonSign.aquarius: return 'Yenilikci fikirler akiyor. Alternatif yaklasimlar deneyin.';
      default: return 'Yaratici enerji stabil. Mevcut projelere devam etmek icin uygun.';
    }
  }

  // Best time generators
  static String _getBestLoveTime(MoonSign moon) {
    switch (moon) {
      case MoonSign.libra:
      case MoonSign.taurus:
        return 'Aksam 18:00-21:00';
      case MoonSign.cancer:
        return 'Gece 20:00-23:00';
      default:
        return 'Aksam saatleri';
    }
  }

  static String _getBestCareerTime(MoonSign moon) {
    switch (moon) {
      case MoonSign.capricorn:
      case MoonSign.virgo:
        return 'Sabah 09:00-12:00';
      case MoonSign.aries:
        return 'Sabah erken 08:00-10:00';
      default:
        return 'Ogle saatleri';
    }
  }

  static String _getBestMoneyTime(MoonSign moon) {
    switch (moon) {
      case MoonSign.taurus:
        return 'Ogle 11:00-14:00';
      case MoonSign.capricorn:
        return 'Sabah 10:00-12:00';
      default:
        return 'Is saatleri';
    }
  }

  static String _getBestHealthTime(MoonSign moon) {
    switch (moon) {
      case MoonSign.aries:
        return 'Sabah erken 06:00-09:00';
      case MoonSign.virgo:
        return 'Sabah 07:00-10:00';
      default:
        return 'Gun boyunca';
    }
  }

  static String _getBestTravelTime(MoonSign moon) {
    switch (moon) {
      case MoonSign.sagittarius:
        return 'Sabah erken';
      case MoonSign.gemini:
        return 'Ogle sonrasi';
      default:
        return 'Esnek';
    }
  }

  static String _getBestCreativeTime(MoonSign moon) {
    switch (moon) {
      case MoonSign.pisces:
        return 'Gece gec saatler';
      case MoonSign.leo:
        return 'Ogle sonrasi 14:00-18:00';
      default:
        return 'Aksam saatleri';
    }
  }
}
