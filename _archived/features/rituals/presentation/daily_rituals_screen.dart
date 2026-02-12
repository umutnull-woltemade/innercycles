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
import '../../../data/services/moon_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

/// Daily Rituals & Meditation Screen
/// Personalized spiritual practices based on moon phase, zodiac sign, and planetary influences
class DailyRitualsScreen extends ConsumerStatefulWidget {
  const DailyRitualsScreen({super.key});

  @override
  ConsumerState<DailyRitualsScreen> createState() => _DailyRitualsScreenState();
}

class _DailyRitualsScreenState extends ConsumerState<DailyRitualsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DailyRitualData _ritualData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generateRituals();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateRituals([AppLanguage? lang]) {
    final userProfile = ref.read(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;
    final moonPhase = MoonService.getCurrentPhase();
    final moonSign = MoonService.getCurrentMoonSign();
    final language = lang ?? ref.read(languageProvider);

    _ritualData = DailyRitualsService.generate(
      sunSign: sign,
      moonPhase: moonPhase,
      moonSign: moonSign,
      language: language ?? AppLanguage.tr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;
    final language = ref.watch(languageProvider);

    // Regenerate rituals when language changes
    _generateRituals(language);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, sign, language),
              _buildTabBar(context, language),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMorningRitual(context, language),
                    _buildMeditationTab(context, language),
                    _buildAffirmationsTab(context, language),
                    _buildEveningRitual(context, language),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ZodiacSign sign,
    AppLanguage language,
  ) {
    final moonPhase = MoonService.getCurrentPhase();

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('rituals.daily_ritual_meditation', language),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.starGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${sign.localizedName(language)} ',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: sign.color),
                    ),
                    Text(sign.symbol, style: TextStyle(color: sign.color)),
                    Text(
                      ' • ${moonPhase.emoji} ${moonPhase.localizedName(language)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabBar(BuildContext context, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.auroraStart.withAlpha(60),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        labelColor: AppColors.auroraStart,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: L10nService.get('rituals.morning', language)),
          Tab(text: L10nService.get('rituals.meditation', language)),
          Tab(text: L10nService.get('rituals.affirmation', language)),
          Tab(text: L10nService.get('rituals.evening', language)),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 300.ms);
  }

  Widget _buildMorningRitual(BuildContext context, AppLanguage language) {
    final ritual = _ritualData.morningRitual;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRitualHeader(
            context,
            icon: Icons.wb_sunny,
            title: L10nService.get('rituals.morning_ritual', language),
            subtitle: L10nService.get('rituals.morning_subtitle', language),
            color: Colors.orange,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildTimeCard(
            context,
            ritual.bestTime,
            L10nService.get('rituals.best_time', language),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildIntentionCard(context, ritual.intention, language),
          const SizedBox(height: AppConstants.spacingMd),
          _buildStepsSection(context, ritual.steps, language),
          const SizedBox(height: AppConstants.spacingMd),
          _buildCrystalCard(context, ritual.crystalSuggestion, language),
          const SizedBox(height: AppConstants.spacingMd),
          _buildEssentialOilCard(context, ritual.essentialOil, language),
          const SizedBox(height: AppConstants.spacingXxl),
        ],
      ),
    );
  }

  Widget _buildMeditationTab(BuildContext context, AppLanguage language) {
    final meditation = _ritualData.meditation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRitualHeader(
            context,
            icon: Icons.self_improvement,
            title: L10nService.get('rituals.todays_meditation', language),
            subtitle: L10nService.get('rituals.find_inner_peace', language),
            color: AppColors.auroraStart,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildMeditationTypeCard(context, meditation),
          const SizedBox(height: AppConstants.spacingMd),
          _buildDurationSelector(
            context,
            meditation.recommendedDuration,
            language,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildMeditationGuide(context, meditation, language),
          const SizedBox(height: AppConstants.spacingMd),
          _buildBreathingExercise(
            context,
            meditation.breathingPattern,
            language,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildChakraFocus(context, meditation.chakraFocus, language),
          const SizedBox(height: AppConstants.spacingXxl),
        ],
      ),
    );
  }

  Widget _buildAffirmationsTab(BuildContext context, AppLanguage language) {
    final affirmations = _ritualData.affirmations;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRitualHeader(
            context,
            icon: Icons.format_quote,
            title: L10nService.get('rituals.todays_affirmations', language),
            subtitle: L10nService.get(
              'rituals.affirmations_subtitle',
              language,
            ),
            color: AppColors.starGold,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildMainAffirmation(
            context,
            affirmations.mainAffirmation,
            language,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildAffirmationList(
            context,
            L10nService.get('rituals.morning_affirmations', language),
            affirmations.morningAffirmations,
            Colors.orange,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildAffirmationList(
            context,
            L10nService.get('rituals.noon_affirmations', language),
            affirmations.noonAffirmations,
            AppColors.starGold,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildAffirmationList(
            context,
            L10nService.get('rituals.evening_affirmations', language),
            affirmations.eveningAffirmations,
            AppColors.auroraStart,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildAffirmationTips(context, language),
          const SizedBox(height: AppConstants.spacingXxl),
        ],
      ),
    );
  }

  Widget _buildEveningRitual(BuildContext context, AppLanguage language) {
    final ritual = _ritualData.eveningRitual;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRitualHeader(
            context,
            icon: Icons.nightlight_round,
            title: L10nService.get('rituals.evening_ritual', language),
            subtitle: L10nService.get('rituals.evening_subtitle', language),
            color: AppColors.auroraEnd,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildTimeCard(
            context,
            ritual.bestTime,
            L10nService.get('rituals.best_time', language),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildReflectionCard(context, ritual.reflectionPrompts, language),
          const SizedBox(height: AppConstants.spacingMd),
          _buildGratitudeSection(context, ritual.gratitudePrompts, language),
          const SizedBox(height: AppConstants.spacingMd),
          _buildReleasingRitual(context, ritual.releasingRitual, language),
          const SizedBox(height: AppConstants.spacingMd),
          _buildSleepPreparation(context, ritual.sleepPreparation, language),
          const SizedBox(height: AppConstants.spacingXxl),
        ],
      ),
    );
  }

  Widget _buildRitualHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withAlpha(30), AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildTimeCard(BuildContext context, String time, String label) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: AppColors.starGold, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.starGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntentionCard(
    BuildContext context,
    String intention,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.starGold.withAlpha(20), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.starGold, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('rituals.todays_intention', language),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.starGold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            '"$intention"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSection(
    BuildContext context,
    List<RitualStep> steps,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('rituals.ritual_steps', language),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.auroraStart.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.auroraStart,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          step.description,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          '${step.durationMinutes} ${L10nService.get('rituals.minutes', language)}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCrystalCard(
    BuildContext context,
    CrystalSuggestion crystal,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.withAlpha(20), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.purple.withAlpha(40)),
      ),
      child: Row(
        children: [
          Text(crystal.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('rituals.suggested_crystal', language),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
                Text(
                  crystal.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  crystal.benefit,
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

  Widget _buildEssentialOilCard(
    BuildContext context,
    EssentialOilSuggestion oil,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withAlpha(20), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.green.withAlpha(40)),
      ),
      child: Row(
        children: [
          Text(oil.emoji, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('rituals.suggested_essential_oil', language),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
                Text(
                  oil.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  oil.usage,
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

  Widget _buildMeditationTypeCard(
    BuildContext context,
    MeditationData meditation,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.auroraStart.withAlpha(30), AppColors.surfaceDark],
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
                child: Text(
                  meditation.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meditation.type,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.auroraStart,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      meditation.focus,
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
          Text(
            meditation.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelector(
    BuildContext context,
    int minutes,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(30),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            L10nService.get('rituals.recommended_duration', language),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.auroraStart.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, color: AppColors.auroraStart, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$minutes ${L10nService.get('rituals.minutes', language)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.auroraStart,
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

  Widget _buildMeditationGuide(
    BuildContext context,
    MeditationData meditation,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10nService.get('rituals.meditation_guide', language),
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...meditation.steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.auroraStart.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.auroraStart,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBreathingExercise(
    BuildContext context,
    BreathingPattern pattern,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.withAlpha(20), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.blue.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.air, color: Colors.blue, size: 24),
              const SizedBox(width: 8),
              Text(
                '${L10nService.get('rituals.breathing_exercise', language)}: ${pattern.name}',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBreathPhase(
                context,
                L10nService.get('rituals.inhale', language),
                '${pattern.inhaleSeconds}s',
                Colors.blue,
              ),
              _buildBreathPhase(
                context,
                L10nService.get('rituals.hold', language),
                '${pattern.holdSeconds}s',
                Colors.purple,
              ),
              _buildBreathPhase(
                context,
                L10nService.get('rituals.exhale', language),
                '${pattern.exhaleSeconds}s',
                Colors.teal,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            L10nService.get(
              'rituals.repeat_times',
              language,
            ).replaceAll('{count}', '${pattern.cycles}'),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBreathPhase(
    BuildContext context,
    String label,
    String duration,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              duration,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildChakraFocus(
    BuildContext context,
    ChakraInfo chakra,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [chakra.color.withAlpha(30), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: chakra.color.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: chakra.color.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(chakra.symbol, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('rituals.chakra_to_focus', language),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
                Text(
                  chakra.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: chakra.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  chakra.focus,
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

  Widget _buildMainAffirmation(
    BuildContext context,
    String affirmation,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.starGold.withAlpha(30),
            AppColors.auroraStart.withAlpha(20),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.starGold.withAlpha(50)),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote, color: AppColors.starGold, size: 40),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            affirmation,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            L10nService.get('rituals.main_affirmation', language),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.starGold),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationList(
    BuildContext context,
    String title,
    List<String> affirmations,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...affirmations.map(
            (aff) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.star, color: color, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      aff,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationTips(BuildContext context, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates, color: AppColors.starGold, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('rituals.affirmation_tips', language),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.starGold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _buildTipItem(
            context,
            L10nService.get('rituals.tip_say_aloud', language),
          ),
          _buildTipItem(
            context,
            L10nService.get('rituals.tip_mirror', language),
          ),
          _buildTipItem(context, L10nService.get('rituals.tip_feel', language)),
          _buildTipItem(
            context,
            L10nService.get('rituals.tip_repeat', language),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.starGold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            tip,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard(
    BuildContext context,
    List<String> prompts,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: AppColors.auroraEnd, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('rituals.end_of_day_reflection', language),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.auroraEnd),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...prompts.map(
            (prompt) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.help_outline,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      prompt,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGratitudeSection(
    BuildContext context,
    List<String> prompts,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.withAlpha(20), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.pink.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.pink, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('rituals.gratitude_practice', language),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.pink),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            L10nService.get('rituals.gratitude_prompt', language),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...prompts.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.withAlpha(10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      '${entry.key + 1}.',
                      style: TextStyle(color: Colors.pink),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReleasingRitual(
    BuildContext context,
    ReleasingRitual ritual,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.waves, color: AppColors.auroraEnd, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('rituals.releasing_ritual', language),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.auroraEnd),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            ritual.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            L10nService.get('rituals.release', language),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ritual.thingsToRelease.map((thing) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  thing,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.red),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepPreparation(
    BuildContext context,
    SleepPreparation prep,
    AppLanguage language,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.withAlpha(20), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.indigo.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bedtime, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('rituals.sleep_preparation', language),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.indigo),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...prep.steps.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key + 1}.',
                    style: TextStyle(color: Colors.indigo),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.format_quote, color: Colors.indigo, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"${prep.sleepAffirmation}"',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Data Classes ====================

class DailyRitualData {
  final MorningRitual morningRitual;
  final MeditationData meditation;
  final AffirmationsData affirmations;
  final EveningRitual eveningRitual;

  DailyRitualData({
    required this.morningRitual,
    required this.meditation,
    required this.affirmations,
    required this.eveningRitual,
  });
}

class MorningRitual {
  final String bestTime;
  final String intention;
  final List<RitualStep> steps;
  final CrystalSuggestion crystalSuggestion;
  final EssentialOilSuggestion essentialOil;

  MorningRitual({
    required this.bestTime,
    required this.intention,
    required this.steps,
    required this.crystalSuggestion,
    required this.essentialOil,
  });
}

class RitualStep {
  final String title;
  final String description;
  final int durationMinutes;

  RitualStep({
    required this.title,
    required this.description,
    required this.durationMinutes,
  });
}

class CrystalSuggestion {
  final String name;
  final String emoji;
  final String benefit;

  CrystalSuggestion({
    required this.name,
    required this.emoji,
    required this.benefit,
  });
}

class EssentialOilSuggestion {
  final String name;
  final String emoji;
  final String usage;

  EssentialOilSuggestion({
    required this.name,
    required this.emoji,
    required this.usage,
  });
}

class MeditationData {
  final String type;
  final String emoji;
  final String focus;
  final String description;
  final int recommendedDuration;
  final List<String> steps;
  final BreathingPattern breathingPattern;
  final ChakraInfo chakraFocus;

  MeditationData({
    required this.type,
    required this.emoji,
    required this.focus,
    required this.description,
    required this.recommendedDuration,
    required this.steps,
    required this.breathingPattern,
    required this.chakraFocus,
  });
}

class BreathingPattern {
  final String name;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int cycles;

  BreathingPattern({
    required this.name,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    required this.cycles,
  });
}

class ChakraInfo {
  final String name;
  final String symbol;
  final Color color;
  final String focus;

  ChakraInfo({
    required this.name,
    required this.symbol,
    required this.color,
    required this.focus,
  });
}

class AffirmationsData {
  final String mainAffirmation;
  final List<String> morningAffirmations;
  final List<String> noonAffirmations;
  final List<String> eveningAffirmations;

  AffirmationsData({
    required this.mainAffirmation,
    required this.morningAffirmations,
    required this.noonAffirmations,
    required this.eveningAffirmations,
  });
}

class EveningRitual {
  final String bestTime;
  final List<String> reflectionPrompts;
  final List<String> gratitudePrompts;
  final ReleasingRitual releasingRitual;
  final SleepPreparation sleepPreparation;

  EveningRitual({
    required this.bestTime,
    required this.reflectionPrompts,
    required this.gratitudePrompts,
    required this.releasingRitual,
    required this.sleepPreparation,
  });
}

class ReleasingRitual {
  final String description;
  final List<String> thingsToRelease;

  ReleasingRitual({required this.description, required this.thingsToRelease});
}

class SleepPreparation {
  final List<String> steps;
  final String sleepAffirmation;

  SleepPreparation({required this.steps, required this.sleepAffirmation});
}

// ==================== Service ====================

class DailyRitualsService {
  static DailyRitualData generate({
    required ZodiacSign sunSign,
    required MoonPhase moonPhase,
    required MoonSign moonSign,
    required AppLanguage language,
  }) {
    final seed = DateTime.now().day + sunSign.index + moonPhase.index;
    final random = Random(seed);

    return DailyRitualData(
      morningRitual: _generateMorningRitual(
        sunSign,
        moonPhase,
        random,
        language,
      ),
      meditation: _generateMeditation(sunSign, moonSign, random, language),
      affirmations: _generateAffirmations(sunSign, moonPhase, language),
      eveningRitual: _generateEveningRitual(
        sunSign,
        moonPhase,
        random,
        language,
      ),
    );
  }

  static MorningRitual _generateMorningRitual(
    ZodiacSign sign,
    MoonPhase moonPhase,
    Random random,
    AppLanguage language,
  ) {
    final crystals = [
      CrystalSuggestion(
        name: L10nService.get('rituals.crystals.amethyst', language),
        emoji: '💜',
        benefit: L10nService.get('rituals.crystals.amethyst_benefit', language),
      ),
      CrystalSuggestion(
        name: L10nService.get('rituals.crystals.citrine', language),
        emoji: '💛',
        benefit: L10nService.get('rituals.crystals.citrine_benefit', language),
      ),
      CrystalSuggestion(
        name: L10nService.get('rituals.crystals.rose_quartz', language),
        emoji: '💗',
        benefit: L10nService.get(
          'rituals.crystals.rose_quartz_benefit',
          language,
        ),
      ),
      CrystalSuggestion(
        name: L10nService.get('rituals.crystals.tigers_eye', language),
        emoji: '🧡',
        benefit: L10nService.get(
          'rituals.crystals.tigers_eye_benefit',
          language,
        ),
      ),
      CrystalSuggestion(
        name: L10nService.get('rituals.crystals.aventurine', language),
        emoji: '💚',
        benefit: L10nService.get(
          'rituals.crystals.aventurine_benefit',
          language,
        ),
      ),
      CrystalSuggestion(
        name: L10nService.get('rituals.crystals.lapis_lazuli', language),
        emoji: '💙',
        benefit: L10nService.get(
          'rituals.crystals.lapis_lazuli_benefit',
          language,
        ),
      ),
    ];

    final oils = [
      EssentialOilSuggestion(
        name: L10nService.get('rituals.oils.lavender', language),
        emoji: '💜',
        usage: L10nService.get('rituals.oils.lavender_usage', language),
      ),
      EssentialOilSuggestion(
        name: L10nService.get('rituals.oils.lemon', language),
        emoji: '🍋',
        usage: L10nService.get('rituals.oils.lemon_usage', language),
      ),
      EssentialOilSuggestion(
        name: L10nService.get('rituals.oils.peppermint', language),
        emoji: '🌿',
        usage: L10nService.get('rituals.oils.peppermint_usage', language),
      ),
      EssentialOilSuggestion(
        name: L10nService.get('rituals.oils.orange', language),
        emoji: '🍊',
        usage: L10nService.get('rituals.oils.orange_usage', language),
      ),
      EssentialOilSuggestion(
        name: L10nService.get('rituals.oils.eucalyptus', language),
        emoji: '🌲',
        usage: L10nService.get('rituals.oils.eucalyptus_usage', language),
      ),
    ];

    final intentionKey = 'rituals.intentions.${sign.name}';
    final intention = L10nService.get(intentionKey, language);
    final finalIntention = intention == intentionKey
        ? L10nService.get('rituals.intentions.default', language)
        : intention;

    return MorningRitual(
      bestTime: '06:00 - 08:00',
      intention: finalIntention,
      steps: [
        RitualStep(
          title: L10nService.get('rituals.steps.awakening_breath', language),
          description: L10nService.get(
            'rituals.steps.awakening_breath_desc',
            language,
          ),
          durationMinutes: 2,
        ),
        RitualStep(
          title: L10nService.get('rituals.steps.set_intention', language),
          description: L10nService.get(
            'rituals.steps.set_intention_desc',
            language,
          ),
          durationMinutes: 3,
        ),
        RitualStep(
          title: L10nService.get('rituals.steps.body_awakening', language),
          description: L10nService.get(
            'rituals.steps.body_awakening_desc',
            language,
          ),
          durationMinutes: 5,
        ),
        RitualStep(
          title: L10nService.get('rituals.steps.gratitude_moment', language),
          description: L10nService.get(
            'rituals.steps.gratitude_moment_desc',
            language,
          ),
          durationMinutes: 2,
        ),
      ],
      crystalSuggestion: crystals[random.nextInt(crystals.length)],
      essentialOil: oils[random.nextInt(oils.length)],
    );
  }

  static MeditationData _generateMeditation(
    ZodiacSign sunSign,
    MoonSign moonSign,
    Random random,
    AppLanguage language,
  ) {
    final meditations = [
      MeditationData(
        type: L10nService.get(
          'rituals.meditations.breath_meditation',
          language,
        ),
        emoji: '🌬️',
        focus: L10nService.get('rituals.meditations.breath_focus', language),
        description: L10nService.get(
          'rituals.meditations.breath_desc',
          language,
        ),
        recommendedDuration: 15,
        steps: [
          L10nService.get('rituals.meditation_steps.sit_comfortably', language),
          L10nService.get('rituals.meditation_steps.close_eyes', language),
          L10nService.get('rituals.meditation_steps.watch_breath', language),
          L10nService.get(
            'rituals.meditation_steps.return_to_breath',
            language,
          ),
          L10nService.get('rituals.meditation_steps.feel_body_relax', language),
        ],
        breathingPattern: BreathingPattern(
          name: L10nService.get(
            'rituals.breathing_patterns.four_seven_eight',
            language,
          ),
          inhaleSeconds: 4,
          holdSeconds: 7,
          exhaleSeconds: 8,
          cycles: 4,
        ),
        chakraFocus: ChakraInfo(
          name: L10nService.get('rituals.chakras.heart', language),
          symbol: '💚',
          color: Colors.green,
          focus: L10nService.get('rituals.chakras.heart_focus', language),
        ),
      ),
      MeditationData(
        type: L10nService.get('rituals.meditations.body_scan', language),
        emoji: '🧘',
        focus: L10nService.get('rituals.meditations.body_awareness', language),
        description: L10nService.get(
          'rituals.meditations.body_scan_desc',
          language,
        ),
        recommendedDuration: 20,
        steps: [
          L10nService.get('rituals.meditation_steps.lie_on_back', language),
          L10nService.get('rituals.meditation_steps.start_from_toes', language),
          L10nService.get('rituals.meditation_steps.pay_attention', language),
          L10nService.get('rituals.meditation_steps.move_upward', language),
          L10nService.get('rituals.meditation_steps.feel_whole_body', language),
        ],
        breathingPattern: BreathingPattern(
          name: L10nService.get(
            'rituals.breathing_patterns.natural_breath',
            language,
          ),
          inhaleSeconds: 4,
          holdSeconds: 0,
          exhaleSeconds: 6,
          cycles: 10,
        ),
        chakraFocus: ChakraInfo(
          name: L10nService.get('rituals.chakras.root', language),
          symbol: '🔴',
          color: Colors.red,
          focus: L10nService.get('rituals.chakras.root_focus', language),
        ),
      ),
      MeditationData(
        type: L10nService.get('rituals.meditations.loving_kindness', language),
        emoji: '💕',
        focus: L10nService.get(
          'rituals.meditations.metta_meditation',
          language,
        ),
        description: L10nService.get(
          'rituals.meditations.loving_kindness_desc',
          language,
        ),
        recommendedDuration: 15,
        steps: [
          L10nService.get('rituals.meditation_steps.sit_comfortably', language),
          L10nService.get('rituals.meditation_steps.send_love_self', language),
          L10nService.get('rituals.meditation_steps.send_love_loved', language),
          L10nService.get(
            'rituals.meditation_steps.send_love_stranger',
            language,
          ),
          L10nService.get('rituals.meditation_steps.send_love_all', language),
        ],
        breathingPattern: BreathingPattern(
          name: L10nService.get(
            'rituals.breathing_patterns.heart_breath',
            language,
          ),
          inhaleSeconds: 4,
          holdSeconds: 4,
          exhaleSeconds: 4,
          cycles: 6,
        ),
        chakraFocus: ChakraInfo(
          name: L10nService.get('rituals.chakras.heart', language),
          symbol: '💚',
          color: Colors.green,
          focus: L10nService.get(
            'rituals.chakras.unconditional_love',
            language,
          ),
        ),
      ),
      MeditationData(
        type: L10nService.get('rituals.meditations.visualization', language),
        emoji: '🌟',
        focus: L10nService.get('rituals.meditations.imagination', language),
        description: L10nService.get(
          'rituals.meditations.visualization_desc',
          language,
        ),
        recommendedDuration: 20,
        steps: [
          L10nService.get('rituals.meditation_steps.sit_comfortably', language),
          L10nService.get('rituals.meditation_steps.close_eyes', language),
          L10nService.get('rituals.meditation_steps.imagine_goal', language),
          L10nService.get(
            'rituals.meditation_steps.experience_senses',
            language,
          ),
          L10nService.get('rituals.meditation_steps.accept_reality', language),
        ],
        breathingPattern: BreathingPattern(
          name: L10nService.get(
            'rituals.breathing_patterns.creative_breath',
            language,
          ),
          inhaleSeconds: 5,
          holdSeconds: 3,
          exhaleSeconds: 5,
          cycles: 5,
        ),
        chakraFocus: ChakraInfo(
          name: L10nService.get('rituals.chakras.third_eye', language),
          symbol: '💜',
          color: Colors.indigo,
          focus: L10nService.get('rituals.chakras.third_eye_focus', language),
        ),
      ),
    ];

    return meditations[random.nextInt(meditations.length)];
  }

  static AffirmationsData _generateAffirmations(
    ZodiacSign sign,
    MoonPhase moonPhase,
    AppLanguage language,
  ) {
    final affirmationKey = 'rituals.main_affirmations.${sign.name}';
    final mainAffirmation = L10nService.get(affirmationKey, language);
    final finalMainAffirmation = mainAffirmation == affirmationKey
        ? L10nService.get('rituals.main_affirmations.default', language)
        : mainAffirmation;

    return AffirmationsData(
      mainAffirmation: finalMainAffirmation,
      morningAffirmations: [
        L10nService.get('rituals.affirmation_lists.morning_1', language),
        L10nService.get('rituals.affirmation_lists.morning_2', language),
        L10nService.get('rituals.affirmation_lists.morning_3', language),
      ],
      noonAffirmations: [
        L10nService.get('rituals.affirmation_lists.noon_1', language),
        L10nService.get('rituals.affirmation_lists.noon_2', language),
        L10nService.get('rituals.affirmation_lists.noon_3', language),
      ],
      eveningAffirmations: [
        L10nService.get('rituals.affirmation_lists.evening_1', language),
        L10nService.get('rituals.affirmation_lists.evening_2', language),
        L10nService.get('rituals.affirmation_lists.evening_3', language),
      ],
    );
  }

  static EveningRitual _generateEveningRitual(
    ZodiacSign sign,
    MoonPhase moonPhase,
    Random random,
    AppLanguage language,
  ) {
    return EveningRitual(
      bestTime: '21:00 - 22:00',
      reflectionPrompts: [
        L10nService.get(
          'rituals.reflection_prompts.what_accomplished',
          language,
        ),
        L10nService.get('rituals.reflection_prompts.what_learned', language),
        L10nService.get('rituals.reflection_prompts.what_different', language),
      ],
      gratitudePrompts: [
        L10nService.get('rituals.gratitude_prompts.person', language),
        L10nService.get('rituals.gratitude_prompts.experience', language),
        L10nService.get('rituals.gratitude_prompts.possession', language),
      ],
      releasingRitual: ReleasingRitual(
        description: L10nService.get('rituals.releasing.description', language),
        thingsToRelease: [
          L10nService.get('rituals.releasing.daily_stress', language),
          L10nService.get('rituals.releasing.worries', language),
          L10nService.get('rituals.releasing.unfinished_tasks', language),
          L10nService.get('rituals.releasing.negative_thoughts', language),
        ],
      ),
      sleepPreparation: SleepPreparation(
        steps: [
          L10nService.get('rituals.sleep_prep.turn_off_devices', language),
          L10nService.get('rituals.sleep_prep.darken_room', language),
          L10nService.get('rituals.sleep_prep.comfortable_position', language),
          L10nService.get('rituals.sleep_prep.slow_breath', language),
          L10nService.get('rituals.sleep_prep.relax_body', language),
        ],
        sleepAffirmation: L10nService.get(
          'rituals.sleep_prep.sleep_affirmation',
          language,
        ),
      ),
    );
  }
}
