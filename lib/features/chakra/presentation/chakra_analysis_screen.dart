import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/next_blocks.dart';
import '../../../shared/widgets/kadim_not_card.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';

/// Chakra Analysis Screen - Personalized chakra reading based on natal chart
class ChakraAnalysisScreen extends ConsumerStatefulWidget {
  const ChakraAnalysisScreen({super.key});

  @override
  ConsumerState<ChakraAnalysisScreen> createState() => _ChakraAnalysisScreenState();
}

class _ChakraAnalysisScreenState extends ConsumerState<ChakraAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ChakraAnalysisData? _analysisData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAnalysis();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalysis() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final userProfile = ref.read(userProfileProvider);
    final sunSign = userProfile?.sunSign ?? ZodiacSign.aries;

    setState(() {
      _analysisData = ChakraAnalysisService.generate(sunSign);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context, language),
              if (_isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.starGold,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          L10nService.get('chakra.analyzing', language),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildChakraVisualization(context, language),
                      _buildTabBar(context, language),
                      _buildTabContent(context, language),
                      const SizedBox(height: AppConstants.spacingLg),
                      // Kadim Not - Chakra bilgeliği
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
                        child: KadimNotCard(
                          title: L10nService.get('chakra.energy_cycle', language),
                          content: L10nService.get('chakra.energy_cycle_content', language),
                          category: KadimCategory.chakra,
                          source: L10nService.get('chakra.tantric_wisdom', language),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingXl),
                      // Next Blocks - keşfetmeye devam et
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
                        child: const NextBlocks(currentPage: 'chakra'),
                      ),
                      const SizedBox(height: AppConstants.spacingXl),
                      // Entertainment Disclaimer
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
                        child: PageFooterWithDisclaimer(
                          brandText: 'Chakra — Venus One',
                          disclaimerText: DisclaimerTexts.chakra(language),
                          language: language,
                        ),
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

  Widget _buildAppBar(BuildContext context, AppLanguage language) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.starGold,
              const Color(0xFFFFE082),
              AppColors.starGold,
            ],
          ).createShader(bounds),
          child: Text(
            L10nService.get('chakra.title', language),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.cosmicPurple.withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.self_improvement,
              size: 60,
              color: AppColors.starGold.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildChakraVisualization(BuildContext context, AppLanguage language) {
    if (_analysisData == null) return const SizedBox.shrink();

    return Container(
      height: 420,
      margin: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cosmicPurple.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cosmicPurple.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          Container(
            width: 250,
            height: 380,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.cosmicPurple.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Spine line
          Positioned(
            child: Container(
              width: 6,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.cosmicPurple,
                    const Color(0xFF3F51B5),
                    const Color(0xFF03A9F4),
                    const Color(0xFF4CAF50),
                    const Color(0xFFFFEB3B),
                    const Color(0xFFFF9800),
                    const Color(0xFFE53935),
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms)
                .slideY(begin: -0.2),
          ),
          // Chakra points
          ...List.generate(7, (index) {
            final chakra = _analysisData!.chakras[6 - index];
            final yPosition = 30.0 + (index * 50);
            return Positioned(
              top: yPosition,
              child: _buildChakraPoint(context, chakra, language)
                  .animate(delay: Duration(milliseconds: index * 100))
                  .fadeIn()
                  .scale(begin: const Offset(0.5, 0.5)),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildChakraPoint(BuildContext context, ChakraData chakra, AppLanguage language) {
    final size = 32 + (chakra.balance * 18);

    return GestureDetector(
      onTap: () => _showChakraDetail(context, chakra, language),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chakra name
          SizedBox(
            width: 110,
            child: Text(
              chakra.localizedName(language),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Chakra orb
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  chakra.color,
                  chakra.color.withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: chakra.color.withValues(alpha: 0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${(chakra.balance * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Status indicator
          Container(
            width: 90,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (chakra.balance > 0.7
                      ? Colors.green
                      : chakra.balance < 0.4
                          ? Colors.red
                          : Colors.orange)
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  chakra.balance > 0.7
                      ? Icons.arrow_upward
                      : chakra.balance < 0.4
                          ? Icons.arrow_downward
                          : Icons.remove,
                  color: chakra.balance > 0.7
                      ? Colors.green
                      : chakra.balance < 0.4
                          ? Colors.red
                          : Colors.orange,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  chakra.balance > 0.7
                      ? L10nService.get('chakra.active', language)
                      : chakra.balance < 0.4
                          ? L10nService.get('chakra.blocked', language)
                          : L10nService.get('chakra.balanced', language),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChakraDetail(BuildContext context, ChakraData chakra, AppLanguage language) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF0D0D1A),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: chakra.color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with chakra orb
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                chakra.color,
                                chakra.color.withValues(alpha: 0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: chakra.color.withValues(alpha: 0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              chakra.symbol,
                              style: const TextStyle(fontSize: 28, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chakra.localizedName(language),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                chakra.sanskritName,
                                style: TextStyle(
                                  color: chakra.color,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Balance indicator
                    _buildBalanceIndicator(context, chakra, language),
                    const SizedBox(height: 24),

                    // Description
                    _buildDetailSection(
                      context,
                      icon: Icons.info_outline,
                      title: L10nService.get('chakra.about', language),
                      content: chakra.getDescription(language),
                    ),

                    // Physical connection
                    _buildDetailSection(
                      context,
                      icon: Icons.favorite_outline,
                      title: L10nService.get('chakra.physical_connections', language),
                      content: chakra.getPhysicalConnection(language),
                    ),

                    // Emotional aspects
                    _buildDetailSection(
                      context,
                      icon: Icons.psychology_outlined,
                      title: L10nService.get('chakra.emotional_aspects', language),
                      content: chakra.getEmotionalAspects(language),
                    ),

                    // Healing suggestions
                    _buildHealingSuggestions(context, chakra, language),

                    // Affirmation
                    _buildAffirmationCard(context, chakra, language),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceIndicator(BuildContext context, ChakraData chakra, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: chakra.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: chakra.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10nService.get('chakra.balance_status', language),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Text(
                '${(chakra.balance * 100).toInt()}%',
                style: TextStyle(
                  color: chakra.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: chakra.balance,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(chakra.color),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            chakra.getBalanceMessage(language),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.starGold, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealingSuggestions(BuildContext context, ChakraData chakra, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.spa_outlined, color: Colors.green.shade400, size: 20),
              const SizedBox(width: 8),
              Text(
                L10nService.get('chakra.balancing_tips', language),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...chakra.getHealingSuggestions(language).map((suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chakra.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          // Crystals
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chakra.getCrystals(language).map((crystal) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: chakra.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: chakra.color.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    crystal,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationCard(BuildContext context, ChakraData chakra, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            chakra.color.withValues(alpha: 0.25),
            chakra.color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: chakra.color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote, color: chakra.color, size: 28),
          const SizedBox(height: 8),
          Text(
            chakra.getAffirmation(language),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: AppColors.cosmicPurple.withValues(alpha: 0.3),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.cosmicPurple, AppColors.mysticBlue],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: L10nService.get('chakra.map', language)),
          Tab(text: L10nService.get('chakra.meditation', language)),
          Tab(text: L10nService.get('chakra.daily', language)),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, AppLanguage language) {
    if (_analysisData == null) return const SizedBox.shrink();

    return SizedBox(
      height: 520,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, language),
          _buildMeditationTab(context, language),
          _buildDailyTab(context, language),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, AppLanguage language) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.starGold, const Color(0xFFFFE082)],
            ).createShader(bounds),
            child: Text(
              L10nService.get('chakra.profile', language),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _analysisData!.getOverallAnalysis(language),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Strongest chakra
          _buildChakraHighlight(
            context,
            title: L10nService.get('chakra.strongest', language),
            chakra: _analysisData!.strongestChakra,
            color: Colors.green,
            language: language,
          ),
          const SizedBox(height: 16),

          // Needs attention
          _buildChakraHighlight(
            context,
            title: L10nService.get('chakra.needs_attention', language),
            chakra: _analysisData!.needsAttention,
            color: Colors.orange,
            language: language,
          ),
          const SizedBox(height: 24),

          // Tips
          Text(
            L10nService.get('chakra.general_tips', language),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          ..._analysisData!.getGeneralTips(language).map((tip) => _buildTipCard(context, tip)),
        ],
      ),
    );
  }

  Widget _buildChakraHighlight(
    BuildContext context, {
    required String title,
    required ChakraData chakra,
    required Color color,
    required AppLanguage language,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [chakra.color, chakra.color.withValues(alpha: 0.7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: chakra.color.withValues(alpha: 0.4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(chakra.symbol, style: const TextStyle(fontSize: 22, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  chakra.localizedName(language),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(chakra.balance * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: AppColors.starGold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationTab(BuildContext context, AppLanguage language) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.starGold, const Color(0xFFFFE082)],
            ).createShader(bounds),
            child: Text(
              L10nService.get('chakra.meditations', language),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          ..._analysisData!.meditations.map((meditation) => _buildMeditationCard(context, meditation, language)),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(BuildContext context, ChakraMeditation meditation, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: meditation.chakra.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  meditation.chakra.color.withValues(alpha: 0.3),
                  meditation.chakra.color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusMd)),
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [meditation.chakra.color, meditation.chakra.color.withValues(alpha: 0.7)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: meditation.chakra.color.withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(meditation.chakra.symbol, style: const TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meditation.getTitle(language),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: Colors.white.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text(
                            meditation.getFormattedDuration(language),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: meditation.chakra.color.withValues(alpha: 0.5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.play_circle_fill, color: meditation.chakra.color, size: 45),
                    onPressed: () {
                      // Start meditation
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Text(
              meditation.getDescription(language),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTab(BuildContext context, AppLanguage language) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.starGold, const Color(0xFFFFE082)],
            ).createShader(bounds),
            child: Text(
              L10nService.get('chakra.todays_energy', language),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _analysisData!.dailyFocus.getDescription(language),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Focus chakra
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _analysisData!.dailyFocus.focusChakra.color.withValues(alpha: 0.25),
                  _analysisData!.dailyFocus.focusChakra.color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: _analysisData!.dailyFocus.focusChakra.color.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _analysisData!.dailyFocus.focusChakra.color,
                        _analysisData!.dailyFocus.focusChakra.color.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _analysisData!.dailyFocus.focusChakra.color.withValues(alpha: 0.5),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _analysisData!.dailyFocus.focusChakra.symbol,
                      style: const TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  L10nService.get('chakra.focus_today', language).replaceAll('{chakra}', _analysisData!.dailyFocus.focusChakra.localizedName(language)),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _analysisData!.dailyFocus.getFocusReason(language),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Daily activities
          Text(
            L10nService.get('chakra.suggested_activities', language),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          ..._analysisData!.dailyFocus.getActivities(language).map((activity) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  border: Border.all(
                    color: _analysisData!.dailyFocus.focusChakra.color.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getActivityIcon(activity),
                      color: _analysisData!.dailyFocus.focusChakra.color,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        activity,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String activity) {
    final lowerActivity = activity.toLowerCase();
    // Turkish and English keywords for activity detection
    if (lowerActivity.contains('meditasyon') || lowerActivity.contains('meditation')) return Icons.self_improvement;
    if (lowerActivity.contains('yoga')) return Icons.sports_gymnastics;
    if (lowerActivity.contains('nefes') || lowerActivity.contains('breath')) return Icons.air;
    if (lowerActivity.contains('yürü') || lowerActivity.contains('walk') || lowerActivity.contains('barefoot')) return Icons.directions_walk;
    if (lowerActivity.contains('su') || lowerActivity.contains('water') || lowerActivity.contains('swim')) return Icons.water_drop;
    if (lowerActivity.contains('yaz') || lowerActivity.contains('write') || lowerActivity.contains('journal')) return Icons.edit_note;
    if (lowerActivity.contains('taş') || lowerActivity.contains('crystal') || lowerActivity.contains('stone')) return Icons.diamond;
    if (lowerActivity.contains('olumlama') || lowerActivity.contains('affirmation')) return Icons.format_quote;
    return Icons.circle_outlined;
  }
}

// ============== Data Models ==============

class ChakraAnalysisData {
  final List<ChakraData> chakras;
  final ChakraData strongestChakra;
  final ChakraData needsAttention;
  final ZodiacSign sign;
  final List<ChakraMeditation> meditations;
  final DailyChakraFocus dailyFocus;

  ChakraAnalysisData({
    required this.chakras,
    required this.strongestChakra,
    required this.needsAttention,
    required this.sign,
    required this.meditations,
    required this.dailyFocus,
  });

  String getOverallAnalysis(AppLanguage language) {
    final signName = sign.getLocalizedName(language);
    final strongestName = strongestChakra.localizedName(language);
    final weakestName = needsAttention.localizedName(language);
    final emotionalAspects = strongestChakra.getEmotionalAspects(language).toLowerCase();

    return L10nService.getWithParams('chakra.overall_analysis', language, params: {
      'sign': signName,
      'strongest': strongestName,
      'weakest': weakestName,
      'emotional_aspects': emotionalAspects,
    });
  }

  List<String> getGeneralTips(AppLanguage language) {
    return L10nService.getList('chakra.general_tips_list', language);
  }
}

class ChakraData {
  final String name;
  final String key; // key for l10n lookup (root, sacral, solar_plexus, heart, throat, third_eye, crown)
  final String sanskritName;
  final String symbol;
  final Color color;
  final double balance;

  ChakraData({
    required this.name,
    required this.key,
    required this.sanskritName,
    required this.symbol,
    required this.color,
    required this.balance,
  });

  String localizedName(AppLanguage language) {
    return L10nService.get('chakra.names.$key', language);
  }

  String getDescription(AppLanguage language) {
    return L10nService.get('chakra.data.$key.description', language);
  }

  String getPhysicalConnection(AppLanguage language) {
    return L10nService.get('chakra.data.$key.physical_connection', language);
  }

  String getEmotionalAspects(AppLanguage language) {
    return L10nService.get('chakra.data.$key.emotional_aspects', language);
  }

  String getBalanceMessage(AppLanguage language) {
    if (balance > 0.7) {
      return L10nService.get('chakra.data.$key.balance_high', language);
    } else if (balance < 0.4) {
      return L10nService.get('chakra.data.$key.balance_low', language);
    } else {
      return L10nService.get('chakra.data.$key.balance_mid', language);
    }
  }

  List<String> getHealingSuggestions(AppLanguage language) {
    final suggestions = L10nService.getList('chakra.data.$key.healing_suggestions', language);
    return suggestions.isNotEmpty ? suggestions : [];
  }

  List<String> getCrystals(AppLanguage language) {
    final crystals = L10nService.getList('chakra.data.$key.crystals', language);
    return crystals.isNotEmpty ? crystals : [];
  }

  String getAffirmation(AppLanguage language) {
    return L10nService.get('chakra.data.$key.affirmation', language);
  }
}

class ChakraMeditation {
  final ChakraData chakra;
  final String titleKey; // key for l10n lookup (grounding, heart_opening, third_eye_activation)
  final int duration;

  ChakraMeditation({
    required this.chakra,
    required this.titleKey,
    required this.duration,
  });

  String getTitle(AppLanguage language) {
    return L10nService.get('chakra.meditation_titles.$titleKey', language);
  }

  String getDescription(AppLanguage language) {
    return L10nService.get('chakra.meditation_descriptions.$titleKey', language);
  }

  String getFormattedDuration(AppLanguage language) {
    return L10nService.getWithParams('chakra.minutes', language, params: {'duration': duration.toString()});
  }
}

class DailyChakraFocus {
  final ChakraData focusChakra;

  DailyChakraFocus({
    required this.focusChakra,
  });

  String getDescription(AppLanguage language) {
    return L10nService.getWithParams('chakra.daily_description', language,
      params: {'chakra': focusChakra.localizedName(language)});
  }

  String getFocusReason(AppLanguage language) {
    return L10nService.getWithParams('chakra.daily_reason', language,
      params: {'chakra': focusChakra.name});
  }

  List<String> getActivities(AppLanguage language) {
    final healingSuggestions = focusChakra.getHealingSuggestions(language);
    final crystals = focusChakra.getCrystals(language);

    final activities = <String>[];
    if (healingSuggestions.isNotEmpty) {
      activities.add(healingSuggestions.first);
    }
    activities.add(L10nService.getWithParams('chakra.daily_activities.meditation_5min', language,
      params: {'chakra': focusChakra.localizedName(language)}));
    if (crystals.isNotEmpty) {
      activities.add(L10nService.getWithParams('chakra.daily_activities.carry_crystal', language,
        params: {'crystal': crystals.first}));
    }
    activities.add(L10nService.get('chakra.daily_activities.affirmation_3x', language));

    return activities;
  }
}

// ============== Service ==============

class ChakraAnalysisService {
  static ChakraAnalysisData generate(ZodiacSign sign) {
    final chakras = _generateChakras(sign);
    final strongest = chakras.reduce((a, b) => a.balance > b.balance ? a : b);
    final weakest = chakras.reduce((a, b) => a.balance < b.balance ? a : b);

    return ChakraAnalysisData(
      chakras: chakras,
      strongestChakra: strongest,
      needsAttention: weakest,
      sign: sign,
      meditations: _getMeditations(chakras),
      dailyFocus: _getDailyFocus(chakras),
    );
  }

  static List<ChakraData> _generateChakras(ZodiacSign sign) {
    // Base balances influenced by zodiac element
    final element = _getElement(sign);
    final baseBalances = _getElementBalances(element);

    return [
      ChakraData(
        name: 'Root',
        key: 'root',
        sanskritName: 'Muladhara',
        symbol: 'LAM',
        color: const Color(0xFFE53935),
        balance: baseBalances[0],
      ),
      ChakraData(
        name: 'Sacral',
        key: 'sacral',
        sanskritName: 'Svadhisthana',
        symbol: 'VAM',
        color: const Color(0xFFFF9800),
        balance: baseBalances[1],
      ),
      ChakraData(
        name: 'Solar Plexus',
        key: 'solar_plexus',
        sanskritName: 'Manipura',
        symbol: 'RAM',
        color: const Color(0xFFFFEB3B),
        balance: baseBalances[2],
      ),
      ChakraData(
        name: 'Heart',
        key: 'heart',
        sanskritName: 'Anahata',
        symbol: 'YAM',
        color: const Color(0xFF4CAF50),
        balance: baseBalances[3],
      ),
      ChakraData(
        name: 'Throat',
        key: 'throat',
        sanskritName: 'Vishuddha',
        symbol: 'HAM',
        color: const Color(0xFF03A9F4),
        balance: baseBalances[4],
      ),
      ChakraData(
        name: 'Third Eye',
        key: 'third_eye',
        sanskritName: 'Ajna',
        symbol: 'OM',
        color: const Color(0xFF3F51B5),
        balance: baseBalances[5],
      ),
      ChakraData(
        name: 'Crown',
        key: 'crown',
        sanskritName: 'Sahasrara',
        symbol: 'AUM',
        color: const Color(0xFF9C27B0),
        balance: baseBalances[6],
      ),
    ];
  }

  static String _getElement(ZodiacSign sign) {
    switch (sign) {
      case ZodiacSign.aries:
      case ZodiacSign.leo:
      case ZodiacSign.sagittarius:
        return 'fire';
      case ZodiacSign.taurus:
      case ZodiacSign.virgo:
      case ZodiacSign.capricorn:
        return 'earth';
      case ZodiacSign.gemini:
      case ZodiacSign.libra:
      case ZodiacSign.aquarius:
        return 'air';
      case ZodiacSign.cancer:
      case ZodiacSign.scorpio:
      case ZodiacSign.pisces:
        return 'water';
    }
  }

  static List<double> _getElementBalances(String element) {
    switch (element) {
      case 'fire':
        return [0.75, 0.65, 0.85, 0.55, 0.70, 0.50, 0.60];
      case 'earth':
        return [0.90, 0.50, 0.70, 0.60, 0.55, 0.45, 0.40];
      case 'air':
        return [0.50, 0.60, 0.65, 0.70, 0.85, 0.80, 0.75];
      case 'water':
        return [0.55, 0.80, 0.45, 0.85, 0.60, 0.75, 0.70];
      default:
        return [0.60, 0.60, 0.60, 0.60, 0.60, 0.60, 0.60];
    }
  }

  static List<ChakraMeditation> _getMeditations(List<ChakraData> chakras) {
    return [
      ChakraMeditation(
        chakra: chakras[0],
        titleKey: 'grounding',
        duration: 10,
      ),
      ChakraMeditation(
        chakra: chakras[3],
        titleKey: 'heart_opening',
        duration: 15,
      ),
      ChakraMeditation(
        chakra: chakras[5],
        titleKey: 'third_eye_activation',
        duration: 12,
      ),
    ];
  }

  static DailyChakraFocus _getDailyFocus(List<ChakraData> chakras) {
    final dayOfWeek = DateTime.now().weekday;
    final focusIndex = dayOfWeek % 7;
    final focusChakra = chakras[focusIndex];

    return DailyChakraFocus(
      focusChakra: focusChakra,
    );
  }
}
