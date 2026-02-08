import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../shared/widgets/kadim_not_card.dart';
import '../../../shared/widgets/next_blocks.dart';
import '../../../shared/widgets/quiz_cta_card.dart';

class SynastryScreen extends ConsumerStatefulWidget {
  const SynastryScreen({super.key});

  @override
  ConsumerState<SynastryScreen> createState() => _SynastryScreenState();
}

class _SynastryScreenState extends ConsumerState<SynastryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Partner data (in real app, this would be entered by user)
  ZodiacSign _partnerSign = ZodiacSign.libra;
  DateTime _partnerBirthDate = DateTime(1992, 10, 15);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);
    final userSign = userProfile?.sunSign ?? ZodiacSign.aries;
    final userBirthDate = userProfile?.birthDate ?? DateTime(1990, 1, 1);

    final synastryData = SynastryCalculator.calculate(
      person1Sign: userSign,
      person1BirthDate: userBirthDate,
      person2Sign: _partnerSign,
      person2BirthDate: _partnerBirthDate,
      language: language,
    );

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: _buildHeader(context, userSign, language)),
              SliverToBoxAdapter(child: _buildPartnerSelector(context, language)),
              SliverToBoxAdapter(
                child: _buildCompactCompatibilityScore(context, synastryData, language),
              ),
              SliverToBoxAdapter(child: _buildTabBar(context, language)),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, synastryData, language),
                _buildAspectsTab(context, synastryData, language),
                _buildHousesTab(context, synastryData, language),
                _buildAdviceTab(context, synastryData, language),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ZodiacSign userSign, AppLanguage language) {
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
                  L10nService.get('synastry.title', language),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  L10nService.get('synastry.subtitle', language),
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
                  Colors.pink.withAlpha(40),
                  Colors.purple.withAlpha(20),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.pink, size: 24),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildPartnerSelector(BuildContext context, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(20),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('synastry.partner_sign', language),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _showSignSelector(context, language),
                  child: Row(
                    children: [
                      Text(
                        _partnerSign.symbol,
                        style: TextStyle(
                          fontSize: 24,
                          color: _partnerSign.color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _partnerSign.localizedName(language),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.edit,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white12),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('birth_date', language),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _selectPartnerDate(context),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_partnerBirthDate.day}/${_partnerBirthDate.month}/${_partnerBirthDate.year}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  // KOMPAKT VERSİYON - Daha az yer kaplayan uyumluluk göstergesi
  Widget _buildCompactCompatibilityScore(
    BuildContext context,
    SynastryData data,
    AppLanguage language,
  ) {
    final Color scoreColor = data.overallScore >= 70
        ? Colors.green
        : data.overallScore >= 50
        ? Colors.amber
        : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: 4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withAlpha(20),
            Colors.purple.withAlpha(10),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.pink.withAlpha(30)),
      ),
      child: Row(
        children: [
          // Person 1 - Mini
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  ref.watch(userProfileProvider)?.sunSign.color ??
                      AppColors.starGold,
                  (ref.watch(userProfileProvider)?.sunSign.color ??
                          AppColors.starGold)
                      .withAlpha(50),
                ],
              ),
            ),
            child: Center(
              child: Text(
                ref.watch(userProfileProvider)?.sunSign.symbol ?? '?',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            L10nService.get('synastry.you', language),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textMuted,
              fontSize: 9,
            ),
          ),

          // Score in middle
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        scoreColor.withAlpha(80),
                        scoreColor.withAlpha(20),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scoreColor.withAlpha(30),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${data.overallScore}%',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scoreColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  data.compatibilityLevel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Person 2 - Mini
          Text(
            L10nService.get('synastry.partner', language),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textMuted,
              fontSize: 9,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_partnerSign.color, _partnerSign.color.withAlpha(50)],
              ),
            ),
            child: Center(
              child: Text(
                _partnerSign.symbol,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildTabBar(BuildContext context, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.pink.withAlpha(40),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        labelColor: Colors.pink,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        tabs: [
          Tab(text: L10nService.get('tab_general', language)),
          Tab(text: L10nService.get('tab_aspects', language)),
          Tab(text: L10nService.get('tab_houses', language)),
          Tab(text: L10nService.get('tab_advice', language)),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildOverviewTab(BuildContext context, SynastryData data, AppLanguage language) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        // Kategori Skorları - Yatay Kompakt
        _buildCategoryScoresRow(context, data, language),
        const SizedBox(height: AppConstants.spacingLg),
        // Synastry explanation
        _buildSynastryExplanation(context, language),
        const SizedBox(height: AppConstants.spacingLg),
        _buildSectionTitle(context, L10nService.get('synastry.relationship_dynamics', language)),
        const SizedBox(height: AppConstants.spacingMd),
        _buildInfoCard(
          context,
          title: L10nService.get('synastry.spiritual_bond', language),
          content: data.overview,
          icon: Icons.visibility,
          color: Colors.pink,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildInfoCard(
          context,
          title: L10nService.get('synastry.strengths', language),
          content: data.strengths.join('\n'),
          icon: Icons.thumb_up,
          color: Colors.green,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildInfoCard(
          context,
          title: L10nService.get('synastry.challenges', language),
          content: data.challenges.join('\n'),
          icon: Icons.warning_amber,
          color: Colors.orange,
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // Kadim Not - Sinastri bilgeliği
        KadimNotCard(
          title: L10nService.get('synastry.kadim_title', language),
          content: L10nService.get('synastry.kadim_content', language),
          category: KadimCategory.astrology,
          source: L10nService.get('synastry.kadim_source', language),
        ),
        const SizedBox(height: AppConstants.spacingXl),

        // Quiz CTA - Google Discover Funnel
        QuizCTACard.astrology(compact: true),
        const SizedBox(height: AppConstants.spacingXl),

        // Next Blocks - keşfetmeye devam et
        const NextBlocks(currentPage: 'synastry'),
        const SizedBox(height: AppConstants.spacingXl),
        // Disclaimer
        PageFooterWithDisclaimer(
          brandText: 'Sinastri — Venus One',
          disclaimerText: DisclaimerTexts.compatibility(language),
          language: language,
        ),
      ],
    );
  }

  Widget _buildCategoryScoresRow(BuildContext context, SynastryData data, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withAlpha(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMiniScoreItem(
            context,
            L10nService.get('synastry.emotional', language),
            data.emotionalScore,
            Colors.pink,
            '💕',
          ),
          _buildScoreDivider(),
          _buildMiniScoreItem(
            context,
            L10nService.get('synastry.mental', language),
            data.mentalScore,
            Colors.blue,
            '🧠',
          ),
          _buildScoreDivider(),
          _buildMiniScoreItem(
            context,
            L10nService.get('synastry.physical', language),
            data.physicalScore,
            Colors.red,
            '🔥',
          ),
          _buildScoreDivider(),
          _buildMiniScoreItem(
            context,
            L10nService.get('synastry.spiritual', language),
            data.spiritualScore,
            Colors.purple,
            '✨',
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMiniScoreItem(
    BuildContext context,
    String label,
    int score,
    Color color,
    String emoji,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              '$score',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textMuted,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreDivider() {
    return Container(width: 1, height: 30, color: Colors.white12);
  }

  Widget _buildAspectsTab(BuildContext context, SynastryData data, AppLanguage language) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        _buildSectionTitle(context, L10nService.get('synastry.planet_aspects', language)),
        const SizedBox(height: AppConstants.spacingMd),
        ...data.aspects.asMap().entries.map((entry) {
          final index = entry.key;
          final aspect = entry.value;
          return _buildAspectCard(context, aspect, index, language);
        }),
        const SizedBox(height: AppConstants.spacingXl),
      ],
    );
  }

  Widget _buildHousesTab(BuildContext context, SynastryData data, AppLanguage language) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        _buildSectionTitle(context, L10nService.get('synastry.house_placement', language)),
        Text(
          L10nService.get('synastry.house_placement_subtitle', language),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...data.houseOverlays.asMap().entries.map((entry) {
          final index = entry.key;
          final overlay = entry.value;
          return _buildHouseCard(context, overlay, index, language);
        }),
        const SizedBox(height: AppConstants.spacingXl),
      ],
    );
  }

  Widget _buildAdviceTab(BuildContext context, SynastryData data, AppLanguage language) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        _buildSectionTitle(context, L10nService.get('synastry.relationship_advice', language)),
        const SizedBox(height: AppConstants.spacingMd),
        ...data.advice.asMap().entries.map((entry) {
          final index = entry.key;
          final advice = entry.value;
          return _buildAdviceCard(context, advice, index);
        }),
        const SizedBox(height: AppConstants.spacingLg),
        _buildSectionTitle(context, L10nService.get('synastry.important_dates', language)),
        const SizedBox(height: AppConstants.spacingMd),
        ...data.importantDates.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value;
          return _buildDateCard(context, date, index);
        }),
        const SizedBox(height: AppConstants.spacingXl),
      ],
    );
  }

  Widget _buildSynastryExplanation(BuildContext context, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withAlpha(25),
            Colors.pink.withAlpha(15),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.purple.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('synastry.what_is_synastry', language),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            L10nService.get('synastry.explanation_1', language),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            L10nService.get('synastry.explanation_2', language),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              _buildSynastryKeyPoint(context, '☌', L10nService.get('synastry.conjunction', language), L10nService.get('synastry.union', language)),
              const SizedBox(width: 8),
              _buildSynastryKeyPoint(context, '△', L10nService.get('synastry.trine', language), L10nService.get('synastry.harmony', language)),
              const SizedBox(width: 8),
              _buildSynastryKeyPoint(context, '□', L10nService.get('synastry.square', language), L10nService.get('synastry.growth', language)),
              const SizedBox(width: 8),
              _buildSynastryKeyPoint(context, '☍', L10nService.get('synastry.opposition', language), L10nService.get('synastry.balance', language)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSynastryKeyPoint(
    BuildContext context,
    String symbol,
    String name,
    String meaning,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.purple.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              symbol,
              style: const TextStyle(fontSize: 16, color: Colors.purple),
            ),
            const SizedBox(height: 2),
            Text(
              name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              meaning,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.purple,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAspectCard(
    BuildContext context,
    SynastryAspect aspect,
    int index,
    AppLanguage language,
  ) {
    final Color aspectColor = aspect.isHarmonious
        ? Colors.green
        : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: aspectColor.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: aspectColor.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                aspect.aspectSymbol,
                style: TextStyle(fontSize: 18, color: aspectColor),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${aspect.planet1} ${aspect.aspectName} ${aspect.planet2}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  aspect.interpretation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: aspectColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              aspect.isHarmonious ? L10nService.get('synastry.harmonious', language) : L10nService.get('synastry.challenging', language),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: aspectColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 400.ms);
  }

  Widget _buildHouseCard(
    BuildContext context,
    HouseOverlay overlay,
    int index,
    AppLanguage language,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.purple.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.purple.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${overlay.house}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.purple,
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
                Row(
                  children: [
                    Text(
                      '${overlay.planet} ',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      L10nService.getWithParams('synastry.in_house', language, params: {'house': overlay.house.toString()}),
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.purple),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  overlay.meaning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 400.ms);
  }

  Widget _buildAdviceCard(
    BuildContext context,
    RelationshipAdvice advice,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [advice.color.withAlpha(25), AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: advice.color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(advice.icon, color: advice.color, size: 20),
              const SizedBox(width: 8),
              Text(
                advice.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: advice.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            advice.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 400.ms);
  }

  Widget _buildDateCard(BuildContext context, ImportantDate date, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.pink.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date.formattedDate,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date.event,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  date.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms, duration: 300.ms);
  }

  void _showSignSelector(BuildContext context, AppLanguage language) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                L10nService.get('synastry.select_partner_sign', language),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ZodiacSign.values.map((sign) {
                  final isSelected = sign == _partnerSign;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _partnerSign = sign);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? sign.color.withAlpha(40)
                            : AppColors.surfaceLight.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? sign.color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            sign.symbol,
                            style: TextStyle(fontSize: 24, color: sign.color),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sign.localizedName(language),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: isSelected
                                      ? sign.color
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectPartnerDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _partnerBirthDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.pink,
              surface: AppColors.surfaceDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _partnerBirthDate = picked;
        // Update partner sign based on date
        _partnerSign = _getSignFromDate(picked);
      });
    }
  }

  ZodiacSign _getSignFromDate(DateTime date) {
    final month = date.month;
    final day = date.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return ZodiacSign.aries;
    }
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return ZodiacSign.taurus;
    }
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return ZodiacSign.gemini;
    }
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return ZodiacSign.cancer;
    }
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return ZodiacSign.leo;
    }
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return ZodiacSign.virgo;
    }
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return ZodiacSign.libra;
    }
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return ZodiacSign.scorpio;
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return ZodiacSign.sagittarius;
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return ZodiacSign.capricorn;
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return ZodiacSign.aquarius;
    }
    return ZodiacSign.pisces;
  }
}

// Data Models
class SynastryData {
  final int overallScore;
  final int emotionalScore;
  final int mentalScore;
  final int physicalScore;
  final int spiritualScore;
  final String compatibilityLevel;
  final String overview;
  final List<String> strengths;
  final List<String> challenges;
  final List<SynastryAspect> aspects;
  final List<HouseOverlay> houseOverlays;
  final List<RelationshipAdvice> advice;
  final List<ImportantDate> importantDates;

  const SynastryData({
    required this.overallScore,
    required this.emotionalScore,
    required this.mentalScore,
    required this.physicalScore,
    required this.spiritualScore,
    required this.compatibilityLevel,
    required this.overview,
    required this.strengths,
    required this.challenges,
    required this.aspects,
    required this.houseOverlays,
    required this.advice,
    required this.importantDates,
  });
}

class SynastryAspect {
  final String planet1;
  final String planet2;
  final String aspectName;
  final String aspectSymbol;
  final String interpretation;
  final bool isHarmonious;

  const SynastryAspect({
    required this.planet1,
    required this.planet2,
    required this.aspectName,
    required this.aspectSymbol,
    required this.interpretation,
    required this.isHarmonious,
  });
}

class HouseOverlay {
  final String planet;
  final int house;
  final String meaning;

  const HouseOverlay({
    required this.planet,
    required this.house,
    required this.meaning,
  });
}

class RelationshipAdvice {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const RelationshipAdvice({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });
}

class ImportantDate {
  final String formattedDate;
  final String event;
  final String description;

  const ImportantDate({
    required this.formattedDate,
    required this.event,
    required this.description,
  });
}

// Calculator
class SynastryCalculator {
  static SynastryData calculate({
    required ZodiacSign person1Sign,
    required DateTime person1BirthDate,
    required ZodiacSign person2Sign,
    required DateTime person2BirthDate,
    required AppLanguage language,
  }) {
    final seed = person1Sign.index * 12 + person2Sign.index;
    final random = Random(seed);

    // Calculate element compatibility
    final sameElement = person1Sign.element == person2Sign.element;
    final compatibleElements = _areElementsCompatible(
      person1Sign.element.name,
      person2Sign.element.name,
    );

    // Base scores
    int baseScore = 50;
    if (sameElement) {
      baseScore += 20;
    } else if (compatibleElements) {
      baseScore += 10;
    }

    // Add some variation
    final emotionalScore = (baseScore + random.nextInt(30)).clamp(30, 95);
    final mentalScore = (baseScore + random.nextInt(30) - 5).clamp(30, 95);
    final physicalScore = (baseScore + random.nextInt(35) - 10).clamp(30, 95);
    final spiritualScore = (baseScore + random.nextInt(25)).clamp(30, 95);

    final overallScore =
        ((emotionalScore + mentalScore + physicalScore + spiritualScore) / 4)
            .round();

    return SynastryData(
      overallScore: overallScore,
      emotionalScore: emotionalScore,
      mentalScore: mentalScore,
      physicalScore: physicalScore,
      spiritualScore: spiritualScore,
      compatibilityLevel: _getCompatibilityLevel(overallScore, language),
      overview: _getOverview(person1Sign, person2Sign, overallScore, language),
      strengths: _getStrengths(person1Sign, person2Sign, random, language),
      challenges: _getChallenges(person1Sign, person2Sign, random, language),
      aspects: _generateAspects(person1Sign, person2Sign, random, language),
      houseOverlays: _generateHouseOverlays(person2Sign, random, language),
      advice: _generateAdvice(person1Sign, person2Sign, overallScore, random, language),
      importantDates: _generateImportantDates(random, language),
    );
  }

  static bool _areElementsCompatible(String element1, String element2) {
    const compatible = {
      'fire': ['air'],
      'air': ['fire'],
      'earth': ['water'],
      'water': ['earth'],
    };
    return compatible[element1]?.contains(element2) ?? false;
  }

  static String _getCompatibilityLevel(int score, AppLanguage language) {
    if (score >= 80) return L10nService.get('synastry.level_perfect', language);
    if (score >= 65) return L10nService.get('synastry.level_very_good', language);
    if (score >= 50) return L10nService.get('synastry.level_good', language);
    if (score >= 35) return L10nService.get('synastry.level_moderate', language);
    return L10nService.get('synastry.level_challenging', language);
  }

  static String _getOverview(ZodiacSign sign1, ZodiacSign sign2, int score, AppLanguage language) {
    final sign1Name = sign1.localizedName(language);
    final sign2Name = sign2.localizedName(language);
    if (score >= 70) {
      return L10nService.getWithParams('synastry.overview_high', language, params: {'sign1': sign1Name, 'sign2': sign2Name});
    } else if (score >= 50) {
      return L10nService.getWithParams('synastry.overview_medium', language, params: {'sign1': sign1Name, 'sign2': sign2Name});
    } else {
      return L10nService.getWithParams('synastry.overview_low', language, params: {'sign1': sign1Name, 'sign2': sign2Name});
    }
  }

  static List<String> _getStrengths(
    ZodiacSign sign1,
    ZodiacSign sign2,
    Random random,
    AppLanguage language,
  ) {
    final allStrengths = L10nService.getList('synastry.strengths_list', language);

    final count = 3 + random.nextInt(2);
    final shuffled = List<String>.from(allStrengths);
    shuffled.shuffle(random);
    return shuffled.take(count).map((s) => '• $s').toList();
  }

  static List<String> _getChallenges(
    ZodiacSign sign1,
    ZodiacSign sign2,
    Random random,
    AppLanguage language,
  ) {
    final allChallenges = L10nService.getList('synastry.challenges_list', language);

    final count = 2 + random.nextInt(2);
    final shuffled = List<String>.from(allChallenges);
    shuffled.shuffle(random);
    return shuffled.take(count).map((s) => '• $s').toList();
  }

  static List<SynastryAspect> _generateAspects(
    ZodiacSign sign1,
    ZodiacSign sign2,
    Random random,
    AppLanguage language,
  ) {
    final sign1Name = sign1.localizedName(language);
    final sign2Name = sign2.localizedName(language);
    final sunLabel = L10nService.get('planets.sun', language);
    final moonLabel = L10nService.get('planets.moon', language);
    final venusLabel = L10nService.get('planets.venus', language);
    final marsLabel = L10nService.get('planets.mars', language);
    final mercuryLabel = L10nService.get('planets.mercury', language);

    final trigonName = L10nService.get('synastry.trine', language);
    final squareName = L10nService.get('synastry.square', language);
    final conjunctionName = L10nService.get('synastry.conjunction', language);
    final oppositionName = L10nService.get('synastry.opposition', language);
    final sextileName = L10nService.get('synastry.sextile', language);

    final aspects = <SynastryAspect>[
      SynastryAspect(
        planet1: '$sunLabel ($sign1Name)',
        planet2: '$moonLabel ($sign2Name)',
        aspectName: random.nextBool() ? trigonName : squareName,
        aspectSymbol: random.nextBool() ? '△' : '□',
        interpretation: random.nextBool()
            ? L10nService.get('synastry.aspect_sun_moon_positive', language)
            : L10nService.get('synastry.aspect_sun_moon_negative', language),
        isHarmonious: random.nextBool(),
      ),
      SynastryAspect(
        planet1: '$venusLabel ($sign1Name)',
        planet2: '$marsLabel ($sign2Name)',
        aspectName: random.nextBool() ? conjunctionName : oppositionName,
        aspectSymbol: random.nextBool() ? '☌' : '☍',
        interpretation: L10nService.get('synastry.aspect_venus_mars', language),
        isHarmonious: true,
      ),
      SynastryAspect(
        planet1: '$mercuryLabel ($sign1Name)',
        planet2: '$mercuryLabel ($sign2Name)',
        aspectName: sextileName,
        aspectSymbol: '⚹',
        interpretation: L10nService.get('synastry.aspect_mercury_mercury', language),
        isHarmonious: true,
      ),
    ];

    return aspects;
  }

  static List<HouseOverlay> _generateHouseOverlays(
    ZodiacSign partnerSign,
    Random random,
    AppLanguage language,
  ) {
    return [
      HouseOverlay(
        planet: L10nService.get('planets.sun', language),
        house: 1 + random.nextInt(4),
        meaning: L10nService.get('synastry.house_sun_meaning', language),
      ),
      HouseOverlay(
        planet: L10nService.get('planets.moon', language),
        house: 4 + random.nextInt(3),
        meaning: L10nService.get('synastry.house_moon_meaning', language),
      ),
      HouseOverlay(
        planet: L10nService.get('planets.venus', language),
        house: 5 + random.nextInt(3),
        meaning: L10nService.get('synastry.house_venus_meaning', language),
      ),
      HouseOverlay(
        planet: L10nService.get('planets.mars', language),
        house: 7 + random.nextInt(2),
        meaning: L10nService.get('synastry.house_mars_meaning', language),
      ),
    ];
  }

  static List<RelationshipAdvice> _generateAdvice(
    ZodiacSign sign1,
    ZodiacSign sign2,
    int score,
    Random random,
    AppLanguage language,
  ) {
    return [
      RelationshipAdvice(
        title: L10nService.get('synastry.advice_communication_title', language),
        content: L10nService.get('synastry.advice_communication_content', language),
        icon: Icons.chat_bubble_outline,
        color: Colors.blue,
      ),
      RelationshipAdvice(
        title: L10nService.get('synastry.advice_quality_time_title', language),
        content: L10nService.get('synastry.advice_quality_time_content', language),
        icon: Icons.schedule,
        color: Colors.green,
      ),
      RelationshipAdvice(
        title: L10nService.get('synastry.advice_respect_title', language),
        content: L10nService.get('synastry.advice_respect_content', language),
        icon: Icons.handshake,
        color: Colors.purple,
      ),
      RelationshipAdvice(
        title: L10nService.get('synastry.advice_growth_title', language),
        content: L10nService.get('synastry.advice_growth_content', language),
        icon: Icons.trending_up,
        color: Colors.orange,
      ),
    ];
  }

  static List<ImportantDate> _generateImportantDates(Random random, AppLanguage language) {
    final now = DateTime.now();
    return [
      ImportantDate(
        formattedDate:
            '${now.add(const Duration(days: 14)).day}/${now.add(const Duration(days: 14)).month}',
        event: L10nService.get('synastry.date_venus_trine', language),
        description: L10nService.get('synastry.date_venus_trine_desc', language),
      ),
      ImportantDate(
        formattedDate:
            '${now.add(const Duration(days: 28)).day}/${now.add(const Duration(days: 28)).month}',
        event: L10nService.get('synastry.date_full_moon', language),
        description: L10nService.get('synastry.date_full_moon_desc', language),
      ),
      ImportantDate(
        formattedDate:
            '${now.add(const Duration(days: 45)).day}/${now.add(const Duration(days: 45)).month}',
        event: L10nService.get('synastry.date_mars_sextile', language),
        description: L10nService.get('synastry.date_mars_sextile_desc', language),
      ),
    ];
  }
}
