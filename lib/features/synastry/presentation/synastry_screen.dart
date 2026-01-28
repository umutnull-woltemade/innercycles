import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/next_blocks.dart';
import '../../../shared/widgets/kadim_not_card.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../shared/widgets/quiz_cta_card.dart';

class SynastryScreen extends ConsumerStatefulWidget {
  const SynastryScreen({super.key});

  @override
  ConsumerState<SynastryScreen> createState() => _SynastryScreenState();
}

class _SynastryScreenState extends ConsumerState<SynastryScreen> with SingleTickerProviderStateMixin {
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
    final userSign = userProfile?.sunSign ?? ZodiacSign.aries;
    final userBirthDate = userProfile?.birthDate ?? DateTime(1990, 1, 1);

    final synastryData = SynastryCalculator.calculate(
      person1Sign: userSign,
      person1BirthDate: userBirthDate,
      person2Sign: _partnerSign,
      person2BirthDate: _partnerBirthDate,
    );

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: _buildHeader(context, userSign)),
              SliverToBoxAdapter(child: _buildPartnerSelector(context)),
              SliverToBoxAdapter(child: _buildCompactCompatibilityScore(context, synastryData)),
              SliverToBoxAdapter(child: _buildTabBar(context)),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, synastryData),
                _buildAspectsTab(context, synastryData),
                _buildHousesTab(context, synastryData),
                _buildAdviceTab(context, synastryData),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ZodiacSign userSign) {
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
                  'Sinastri Analizi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'İlişki uyumu detaylı analiz',
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

  Widget _buildPartnerSelector(BuildContext context) {
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
                  'Partner Burcu',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _showSignSelector(context),
                  child: Row(
                    children: [
                      Text(
                        _partnerSign.symbol,
                        style: TextStyle(fontSize: 24, color: _partnerSign.color),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _partnerSign.nameTr,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.edit, size: 16, color: AppColors.textMuted),
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
                  'Doğum Tarihi',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => _selectPartnerDate(context),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        '${_partnerBirthDate.day}/${_partnerBirthDate.month}/${_partnerBirthDate.year}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
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
  Widget _buildCompactCompatibilityScore(BuildContext context, SynastryData data) {
    final Color scoreColor = data.overallScore >= 70
        ? Colors.green
        : data.overallScore >= 50
            ? Colors.amber
            : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg, vertical: 4),
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
                  ref.watch(userProfileProvider)?.sunSign.color ?? AppColors.starGold,
                  (ref.watch(userProfileProvider)?.sunSign.color ?? AppColors.starGold).withAlpha(50),
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
          Text('Sen', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted, fontSize: 9)),

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
                    gradient: RadialGradient(colors: [scoreColor.withAlpha(80), scoreColor.withAlpha(20)]),
                    boxShadow: [BoxShadow(color: scoreColor.withAlpha(30), blurRadius: 8, spreadRadius: 1)],
                  ),
                  child: Center(
                    child: Text(
                      '${data.overallScore}%',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(data.compatibilityLevel, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 10)),
              ],
            ),
          ),

          // Person 2 - Mini
          Text('Partner', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMuted, fontSize: 9)),
          const SizedBox(width: 4),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [_partnerSign.color, _partnerSign.color.withAlpha(50)]),
            ),
            child: Center(child: Text(_partnerSign.symbol, style: const TextStyle(fontSize: 16))),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildTabBar(BuildContext context) {
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
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Genel'),
          Tab(text: 'Aspektler'),
          Tab(text: 'Evler'),
          Tab(text: 'Tavsiye'),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildOverviewTab(BuildContext context, SynastryData data) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        // Kategori Skorları - Yatay Kompakt
        _buildCategoryScoresRow(context, data),
        const SizedBox(height: AppConstants.spacingLg),
        // Synastry explanation
        _buildSynastryExplanation(context),
        const SizedBox(height: AppConstants.spacingLg),
        _buildSectionTitle(context, 'İlişki Dinamiği'),
        const SizedBox(height: AppConstants.spacingMd),
        _buildInfoCard(
          context,
          title: 'Genel Bakış',
          content: data.overview,
          icon: Icons.visibility,
          color: Colors.pink,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildInfoCard(
          context,
          title: 'Güçlü Yanlar',
          content: data.strengths.join('\n'),
          icon: Icons.thumb_up,
          color: Colors.green,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildInfoCard(
          context,
          title: 'Zorluklar',
          content: data.challenges.join('\n'),
          icon: Icons.warning_amber,
          color: Colors.orange,
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // Kadim Not - Sinastri bilgeliği
        const KadimNotCard(
          title: 'Ruhların Aynası',
          content: 'Sinastri, iki ruhun kozmik dansını gösteren kadim bir sanat. Haritalar arasındaki açılar, yalnızca uyumu değil - birlikte öğrenilecek dersleri ve ruhsal büyümeyi de ortaya koyar. Her ilişki, evrenin bir okulu.',
          category: KadimCategory.astrology,
          source: 'İlişki Astrolojisi',
        ),
        const SizedBox(height: AppConstants.spacingXl),

        // Quiz CTA - Google Discover Funnel
        QuizCTACard.astrology(compact: true),
        const SizedBox(height: AppConstants.spacingXl),

        // Next Blocks - keşfetmeye devam et
        const NextBlocks(currentPage: 'synastry'),
        const SizedBox(height: AppConstants.spacingXl),
        // Disclaimer
        const PageFooterWithDisclaimer(
          brandText: 'Sinastri — Venus One',
          disclaimerText: DisclaimerTexts.compatibility,
        ),
      ],
    );
  }

  Widget _buildCategoryScoresRow(BuildContext context, SynastryData data) {
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
          _buildMiniScoreItem(context, 'Duygusal', data.emotionalScore, Colors.pink, '💕'),
          _buildScoreDivider(),
          _buildMiniScoreItem(context, 'Zihinsel', data.mentalScore, Colors.blue, '🧠'),
          _buildScoreDivider(),
          _buildMiniScoreItem(context, 'Fiziksel', data.physicalScore, Colors.red, '🔥'),
          _buildScoreDivider(),
          _buildMiniScoreItem(context, 'Ruhsal', data.spiritualScore, Colors.purple, '✨'),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMiniScoreItem(BuildContext context, String label, int score, Color color, String emoji) {
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
    return Container(
      width: 1,
      height: 30,
      color: Colors.white12,
    );
  }

  Widget _buildAspectsTab(BuildContext context, SynastryData data) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        _buildSectionTitle(context, 'Gezegen Aspektleri'),
        const SizedBox(height: AppConstants.spacingMd),
        ...data.aspects.asMap().entries.map((entry) {
          final index = entry.key;
          final aspect = entry.value;
          return _buildAspectCard(context, aspect, index);
        }),
        const SizedBox(height: AppConstants.spacingXl),
      ],
    );
  }

  Widget _buildHousesTab(BuildContext context, SynastryData data) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        _buildSectionTitle(context, 'Ev Yerleşimi'),
        Text(
          'Partnerin gezegenlerinin senin evlerine düşmesi',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        ...data.houseOverlays.asMap().entries.map((entry) {
          final index = entry.key;
          final overlay = entry.value;
          return _buildHouseCard(context, overlay, index);
        }),
        const SizedBox(height: AppConstants.spacingXl),
      ],
    );
  }

  Widget _buildAdviceTab(BuildContext context, SynastryData data) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      children: [
        _buildSectionTitle(context, 'İlişki Tavsiyeleri'),
        const SizedBox(height: AppConstants.spacingMd),
        ...data.advice.asMap().entries.map((entry) {
          final index = entry.key;
          final advice = entry.value;
          return _buildAdviceCard(context, advice, index);
        }),
        const SizedBox(height: AppConstants.spacingLg),
        _buildSectionTitle(context, 'Önemli Tarihler'),
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

  Widget _buildSynastryExplanation(BuildContext context) {
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
                'Sinastri Nedir?',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Sinastri, iki kişinin doğum haritalarının karşılaştırılarak ilişki uyumunun analiz edilmesidir. Bu kadim astroloji tekniği, iki ruhun kozmik dansını anlamak için kullanılır.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Her iki haritadaki gezegenlerin birbirleriyle yaptığı açılar (aspektler), ilişkinin güçlü yanlarını, zorluklarını ve büyüme potansiyelini ortaya koyar. Güneş-Ay, Venüs-Mars gibi etkileşimler özellikle önemlidir.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              _buildSynastryKeyPoint(context, '☌', 'Kavuşum', 'Birleşme'),
              const SizedBox(width: 8),
              _buildSynastryKeyPoint(context, '△', 'Trigon', 'Uyum'),
              const SizedBox(width: 8),
              _buildSynastryKeyPoint(context, '□', 'Kare', 'Büyüme'),
              const SizedBox(width: 8),
              _buildSynastryKeyPoint(context, '☍', 'Karşıt', 'Denge'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSynastryKeyPoint(BuildContext context, String symbol, String name, String meaning) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.purple.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(symbol, style: const TextStyle(fontSize: 16, color: Colors.purple)),
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

  Widget _buildInfoCard(BuildContext context, {
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

  Widget _buildAspectCard(BuildContext context, SynastryAspect aspect, int index) {
    final Color aspectColor = aspect.isHarmonious ? Colors.green : Colors.orange;

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
              aspect.isHarmonious ? 'Uyumlu' : 'Zorlayıcı',
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

  Widget _buildHouseCard(BuildContext context, HouseOverlay overlay, int index) {
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
                      '${overlay.house}. Evde',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.purple,
                      ),
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

  Widget _buildAdviceCard(BuildContext context, RelationshipAdvice advice, int index) {
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms, duration: 300.ms);
  }

  void _showSignSelector(BuildContext context) {
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
                'Partner Burcu Seç',
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
                        color: isSelected ? sign.color.withAlpha(40) : AppColors.surfaceLight.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? sign.color : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(sign.symbol, style: TextStyle(fontSize: 24, color: sign.color)),
                          const SizedBox(height: 4),
                          Text(
                            sign.nameTr,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isSelected ? sign.color : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return ZodiacSign.aries;
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return ZodiacSign.taurus;
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return ZodiacSign.gemini;
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return ZodiacSign.cancer;
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return ZodiacSign.leo;
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return ZodiacSign.virgo;
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return ZodiacSign.libra;
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return ZodiacSign.scorpio;
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return ZodiacSign.sagittarius;
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return ZodiacSign.capricorn;
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return ZodiacSign.aquarius;
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
  }) {
    final seed = person1Sign.index * 12 + person2Sign.index;
    final random = Random(seed);

    // Calculate element compatibility
    final sameElement = person1Sign.element == person2Sign.element;
    final compatibleElements = _areElementsCompatible(person1Sign.element.name, person2Sign.element.name);

    // Base scores
    int baseScore = 50;
    if (sameElement) baseScore += 20;
    else if (compatibleElements) baseScore += 10;

    // Add some variation
    final emotionalScore = (baseScore + random.nextInt(30)).clamp(30, 95);
    final mentalScore = (baseScore + random.nextInt(30) - 5).clamp(30, 95);
    final physicalScore = (baseScore + random.nextInt(35) - 10).clamp(30, 95);
    final spiritualScore = (baseScore + random.nextInt(25)).clamp(30, 95);

    final overallScore = ((emotionalScore + mentalScore + physicalScore + spiritualScore) / 4).round();

    return SynastryData(
      overallScore: overallScore,
      emotionalScore: emotionalScore,
      mentalScore: mentalScore,
      physicalScore: physicalScore,
      spiritualScore: spiritualScore,
      compatibilityLevel: _getCompatibilityLevel(overallScore),
      overview: _getOverview(person1Sign, person2Sign, overallScore),
      strengths: _getStrengths(person1Sign, person2Sign, random),
      challenges: _getChallenges(person1Sign, person2Sign, random),
      aspects: _generateAspects(person1Sign, person2Sign, random),
      houseOverlays: _generateHouseOverlays(person2Sign, random),
      advice: _generateAdvice(person1Sign, person2Sign, overallScore, random),
      importantDates: _generateImportantDates(random),
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

  static String _getCompatibilityLevel(int score) {
    if (score >= 80) return 'Mükemmel Uyum';
    if (score >= 65) return 'Çok İyi';
    if (score >= 50) return 'İyi';
    if (score >= 35) return 'Orta';
    return 'Zorlayıcı';
  }

  static String _getOverview(ZodiacSign sign1, ZodiacSign sign2, int score) {
    if (score >= 70) {
      return '${sign1.nameTr} ve ${sign2.nameTr} arasında güçlü bir çekicilik var. Birbirinizi tamamlayan enerjileriniz, harmonik bir ilişki için sağlam bir temel oluşturuyor. Duygusal bağlarınız derin ve kalıcı olabilir.';
    } else if (score >= 50) {
      return '${sign1.nameTr} ve ${sign2.nameTr} arasında dengeli bir dinamik mevcut. Her iki tarafın da anlayış ve esneklik göstermesiyle bu ilişki büyüyüp gelişebilir. Farklılıklarınız zenginlik katabilir.';
    } else {
      return '${sign1.nameTr} ve ${sign2.nameTr} arasında bazı zorluklar olabilir. Bu ilişki büyüme fırsatları sunuyor ancak her iki tarafın da bilinçli çaba göstermesi gerekiyor.';
    }
  }

  static List<String> _getStrengths(ZodiacSign sign1, ZodiacSign sign2, Random random) {
    final allStrengths = [
      'Duygusal derinlik ve anlayış',
      'Güçlü iletişim bağları',
      'Ortak değerler ve hedefler',
      'Fiziksel çekim ve tutku',
      'Karşılıklı saygı ve güven',
      'Entelektüel uyum',
      'Mizah anlayışında ortaklık',
      'Birlikte büyüme potansiyeli',
      'Sadakat ve bağlılık',
      'Yaratıcı sinerji',
    ];

    final count = 3 + random.nextInt(2);
    allStrengths.shuffle(random);
    return allStrengths.take(count).map((s) => '• $s').toList();
  }

  static List<String> _getChallenges(ZodiacSign sign1, ZodiacSign sign2, Random random) {
    final allChallenges = [
      'Farklı iletişim stilleri',
      'Bağımsızlık vs yakınlık dengesi',
      'Farklı sosyal ihtiyaçlar',
      'Mali konularda farklı yaklaşımlar',
      'Aile ve sorumluluk bakış açıları',
      'Duygusal ifade farklılıkları',
      'Kariyer öncelikleri çatışması',
      'Zaman yönetimi farklılıkları',
    ];

    final count = 2 + random.nextInt(2);
    allChallenges.shuffle(random);
    return allChallenges.take(count).map((s) => '• $s').toList();
  }

  static List<SynastryAspect> _generateAspects(ZodiacSign sign1, ZodiacSign sign2, Random random) {
    final aspects = <SynastryAspect>[
      SynastryAspect(
        planet1: 'Güneş (${sign1.nameTr})',
        planet2: 'Ay (${sign2.nameTr})',
        aspectName: random.nextBool() ? 'Trigon' : 'Kare',
        aspectSymbol: random.nextBool() ? '△' : '□',
        interpretation: random.nextBool()
            ? 'Duygusal anlayış ve empati güçlü. Birbirinizin ihtiyaçlarını sezgisel olarak anlıyorsunuz.'
            : 'Duygusal ifade farklılıkları var. Sabır ve anlayışla aşılabilir.',
        isHarmonious: random.nextBool(),
      ),
      SynastryAspect(
        planet1: 'Venüs (${sign1.nameTr})',
        planet2: 'Mars (${sign2.nameTr})',
        aspectName: random.nextBool() ? 'Kavuşum' : 'Karşıt',
        aspectSymbol: random.nextBool() ? '☌' : '☍',
        interpretation: 'Fiziksel çekim ve tutku yüksek. Romantik enerji yoğun.',
        isHarmonious: true,
      ),
      SynastryAspect(
        planet1: 'Merkür (${sign1.nameTr})',
        planet2: 'Merkür (${sign2.nameTr})',
        aspectName: 'Sextil',
        aspectSymbol: '⚹',
        interpretation: 'İletişim akıcı ve anlaşılır. Fikirleri paylaşma kolaylığı var.',
        isHarmonious: true,
      ),
    ];

    return aspects;
  }

  static List<HouseOverlay> _generateHouseOverlays(ZodiacSign partnerSign, Random random) {
    return [
      HouseOverlay(
        planet: 'Güneş',
        house: 1 + random.nextInt(4),
        meaning: 'Partneriniz sizin kimliğinizi ve benlik ifadenizi etkiliyor.',
      ),
      HouseOverlay(
        planet: 'Ay',
        house: 4 + random.nextInt(3),
        meaning: 'Duygusal güvenlik ve ev hayatı konularında etkili.',
      ),
      HouseOverlay(
        planet: 'Venüs',
        house: 5 + random.nextInt(3),
        meaning: 'Romantizm, yaratıcılık ve eğlence alanlarında uyum.',
      ),
      HouseOverlay(
        planet: 'Mars',
        house: 7 + random.nextInt(2),
        meaning: 'İlişki dinamikleri ve ortaklık enerjisini etkiliyor.',
      ),
    ];
  }

  static List<RelationshipAdvice> _generateAdvice(ZodiacSign sign1, ZodiacSign sign2, int score, Random random) {
    return [
      const RelationshipAdvice(
        title: 'İletişim',
        content: 'Açık ve dürüst iletişim kurun. Duygularınızı ifade ederken "ben" dilini kullanın. Dinleme becerilerinizi geliştirin.',
        icon: Icons.chat_bubble_outline,
        color: Colors.blue,
      ),
      const RelationshipAdvice(
        title: 'Kaliteli Zaman',
        content: 'Birlikte anlamlı aktiviteler yapın. Ortak hobiler geliştirin. Düzenli "biz zamanı" ayırın.',
        icon: Icons.schedule,
        color: Colors.green,
      ),
      const RelationshipAdvice(
        title: 'Saygı',
        content: 'Birbirinizin sınırlarına saygı gösterin. Farklılıkları kabul edin. Küçük jestlerle takdirinizi gösterin.',
        icon: Icons.handshake,
        color: Colors.purple,
      ),
      const RelationshipAdvice(
        title: 'Büyüme',
        content: 'Birlikte ve bireysel olarak büyümeye açık olun. Birbirinizin hedeflerini destekleyin.',
        icon: Icons.trending_up,
        color: Colors.orange,
      ),
    ];
  }

  static List<ImportantDate> _generateImportantDates(Random random) {
    final now = DateTime.now();
    return [
      ImportantDate(
        formattedDate: '${now.add(const Duration(days: 14)).day}/${now.add(const Duration(days: 14)).month}',
        event: 'Venüs Trigonu',
        description: 'Romantik enerji yüksek, özel planlar yapın',
      ),
      ImportantDate(
        formattedDate: '${now.add(const Duration(days: 28)).day}/${now.add(const Duration(days: 28)).month}',
        event: 'Dolunay',
        description: 'Duygusal derinlik, önemli konuşmalara uygun',
      ),
      ImportantDate(
        formattedDate: '${now.add(const Duration(days: 45)).day}/${now.add(const Duration(days: 45)).month}',
        event: 'Mars Sextili',
        description: 'Ortak projeler ve aktiviteler için ideal',
      ),
    ];
  }
}
