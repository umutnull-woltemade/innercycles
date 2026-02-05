import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';

/// Reiki Screen - Universal Life Energy Healing
/// Opening energy channels and healing practice
class ReikiScreen extends ConsumerStatefulWidget {
  const ReikiScreen({super.key});

  @override
  ConsumerState<ReikiScreen> createState() => _ReikiScreenState();
}

class _ReikiScreenState extends ConsumerState<ReikiScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark, language),
              _buildTabBar(isDark, language),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPrinciplesTab(isDark, language),
                    _buildChakrasTab(isDark, language),
                    _buildPracticeTab(isDark, language),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '🙏',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          L10nService.get('screens.reiki.title', language),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textDark,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      L10nService.get('screens.reiki.subtitle', language),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingSm,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : const Color(0xFFFF7043).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: const Color(0xFFFF7043).withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              L10nService.get('screens.reiki.description', language),
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.white70 : AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabBar(bool isDark, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: isDark ? const Color(0xFFFF7043) : const Color(0xFFE64A19),
        unselectedLabelColor: isDark ? Colors.white60 : AppColors.textLight,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: isDark
              ? const Color(0xFFFF7043).withValues(alpha: 0.2)
              : const Color(0xFFE64A19).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: L10nService.get('screens.reiki.tabs.principles', language)),
          Tab(text: L10nService.get('screens.reiki.tabs.chakras', language)),
          Tab(text: L10nService.get('screens.reiki.tabs.practice', language)),
        ],
      ),
    );
  }

  Widget _buildPrinciplesTab(bool isDark, AppLanguage language) {
    final principles = [
      _ReikiPrinciple(
        japanese: L10nService.get('screens.reiki.principles.kyo_dake_wa.japanese', language),
        translation: L10nService.get('screens.reiki.principles.kyo_dake_wa.translation', language),
        description: L10nService.get('screens.reiki.principles.kyo_dake_wa.description', language),
        icon: '☀️',
        color: const Color(0xFFFFD700),
      ),
      _ReikiPrinciple(
        japanese: L10nService.get('screens.reiki.principles.ikaru_na.japanese', language),
        translation: L10nService.get('screens.reiki.principles.ikaru_na.translation', language),
        description: L10nService.get('screens.reiki.principles.ikaru_na.description', language),
        icon: '🔥',
        color: const Color(0xFFFF5722),
      ),
      _ReikiPrinciple(
        japanese: L10nService.get('screens.reiki.principles.shinpai_suna.japanese', language),
        translation: L10nService.get('screens.reiki.principles.shinpai_suna.translation', language),
        description: L10nService.get('screens.reiki.principles.shinpai_suna.description', language),
        icon: '🌊',
        color: const Color(0xFF2196F3),
      ),
      _ReikiPrinciple(
        japanese: L10nService.get('screens.reiki.principles.kansha_shite.japanese', language),
        translation: L10nService.get('screens.reiki.principles.kansha_shite.translation', language),
        description: L10nService.get('screens.reiki.principles.kansha_shite.description', language),
        icon: '💚',
        color: const Color(0xFF4CAF50),
      ),
      _ReikiPrinciple(
        japanese: L10nService.get('screens.reiki.principles.gyo_wo_hageme.japanese', language),
        translation: L10nService.get('screens.reiki.principles.gyo_wo_hageme.translation', language),
        description: L10nService.get('screens.reiki.principles.gyo_wo_hageme.description', language),
        icon: '⭐',
        color: const Color(0xFF9C27B0),
      ),
      _ReikiPrinciple(
        japanese: L10nService.get('screens.reiki.principles.hito_ni_shinsetsu_ni.japanese', language),
        translation: L10nService.get('screens.reiki.principles.hito_ni_shinsetsu_ni.translation', language),
        description: L10nService.get('screens.reiki.principles.hito_ni_shinsetsu_ni.description', language),
        icon: '💕',
        color: const Color(0xFFE91E63),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF7043).withValues(alpha: isDark ? 0.2 : 0.1),
                  const Color(0xFFFFD700).withValues(alpha: isDark ? 0.1 : 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: Column(
              children: [
                const Text(
                  '五戒',
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  L10nService.get('screens.reiki.gokai.title', language),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  L10nService.get('screens.reiki.gokai.subtitle', language),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),
          const SizedBox(height: AppConstants.spacingLg),
          ...principles.asMap().entries.map((entry) {
            return _buildPrincipleCard(entry.value, isDark)
                .animate(delay: (100 * entry.key).ms)
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.05);
          }),
          const SizedBox(height: AppConstants.spacingXl),
          PageFooterWithDisclaimer(
            brandText: 'Reiki — Venus One',
            disclaimerText: DisclaimerTexts.astrology(language),
            language: language,
          ),
        ],
      ),
    );
  }

  Widget _buildChakrasTab(bool isDark, AppLanguage language) {
    final chakras = [
      _ChakraInfo(
        name: L10nService.get('screens.reiki.chakras.root.name', language),
        sanskrit: L10nService.get('screens.reiki.chakras.root.sanskrit', language),
        location: L10nService.get('screens.reiki.chakras.root.location', language),
        color: const Color(0xFFE53935),
        icon: '🔴',
        attributes: L10nService.getList('screens.reiki.chakras.root.attributes', language),
        reikiPosition: L10nService.get('screens.reiki.chakras.root.reiki_position', language),
      ),
      _ChakraInfo(
        name: L10nService.get('screens.reiki.chakras.sacral.name', language),
        sanskrit: L10nService.get('screens.reiki.chakras.sacral.sanskrit', language),
        location: L10nService.get('screens.reiki.chakras.sacral.location', language),
        color: const Color(0xFFFF9800),
        icon: '🟠',
        attributes: L10nService.getList('screens.reiki.chakras.sacral.attributes', language),
        reikiPosition: L10nService.get('screens.reiki.chakras.sacral.reiki_position', language),
      ),
      _ChakraInfo(
        name: L10nService.get('screens.reiki.chakras.solar_plexus.name', language),
        sanskrit: L10nService.get('screens.reiki.chakras.solar_plexus.sanskrit', language),
        location: L10nService.get('screens.reiki.chakras.solar_plexus.location', language),
        color: const Color(0xFFFFEB3B),
        icon: '🟡',
        attributes: L10nService.getList('screens.reiki.chakras.solar_plexus.attributes', language),
        reikiPosition: L10nService.get('screens.reiki.chakras.solar_plexus.reiki_position', language),
      ),
      _ChakraInfo(
        name: L10nService.get('screens.reiki.chakras.heart.name', language),
        sanskrit: L10nService.get('screens.reiki.chakras.heart.sanskrit', language),
        location: L10nService.get('screens.reiki.chakras.heart.location', language),
        color: const Color(0xFF4CAF50),
        icon: '💚',
        attributes: L10nService.getList('screens.reiki.chakras.heart.attributes', language),
        reikiPosition: L10nService.get('screens.reiki.chakras.heart.reiki_position', language),
      ),
      _ChakraInfo(
        name: L10nService.get('screens.reiki.chakras.throat.name', language),
        sanskrit: L10nService.get('screens.reiki.chakras.throat.sanskrit', language),
        location: L10nService.get('screens.reiki.chakras.throat.location', language),
        color: const Color(0xFF03A9F4),
        icon: '🔵',
        attributes: L10nService.getList('screens.reiki.chakras.throat.attributes', language),
        reikiPosition: L10nService.get('screens.reiki.chakras.throat.reiki_position', language),
      ),
      _ChakraInfo(
        name: L10nService.get('screens.reiki.chakras.third_eye.name', language),
        sanskrit: L10nService.get('screens.reiki.chakras.third_eye.sanskrit', language),
        location: L10nService.get('screens.reiki.chakras.third_eye.location', language),
        color: const Color(0xFF3F51B5),
        icon: '🟣',
        attributes: L10nService.getList('screens.reiki.chakras.third_eye.attributes', language),
        reikiPosition: L10nService.get('screens.reiki.chakras.third_eye.reiki_position', language),
      ),
      _ChakraInfo(
        name: L10nService.get('screens.reiki.chakras.crown.name', language),
        sanskrit: L10nService.get('screens.reiki.chakras.crown.sanskrit', language),
        location: L10nService.get('screens.reiki.chakras.crown.location', language),
        color: const Color(0xFF9C27B0),
        icon: '👑',
        attributes: L10nService.getList('screens.reiki.chakras.crown.attributes', language),
        reikiPosition: L10nService.get('screens.reiki.chakras.crown.reiki_position', language),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      itemCount: chakras.length,
      itemBuilder: (context, index) {
        return _buildChakraCard(chakras[index], isDark, language)
            .animate(delay: (80 * index).ms)
            .fadeIn(duration: 400.ms);
      },
    );
  }

  Widget _buildPracticeTab(bool isDark, AppLanguage language) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPracticeSection(
            title: L10nService.get('screens.reiki.practice.self_reiki.title', language),
            icon: '🙌',
            steps: L10nService.getList('screens.reiki.practice.self_reiki.steps', language),
            color: const Color(0xFFFF7043),
            isDark: isDark,
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
          const SizedBox(height: AppConstants.spacingLg),
          _buildPracticeSection(
            title: L10nService.get('screens.reiki.practice.daily_cleansing.title', language),
            icon: '🌊',
            steps: L10nService.getList('screens.reiki.practice.daily_cleansing.steps', language),
            color: const Color(0xFF2196F3),
            isDark: isDark,
          ).animate(delay: 100.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1),
          const SizedBox(height: AppConstants.spacingLg),
          _buildPracticeSection(
            title: L10nService.get('screens.reiki.practice.distance_reiki.title', language),
            icon: '🌍',
            steps: L10nService.getList('screens.reiki.practice.distance_reiki.steps', language),
            color: const Color(0xFF9C27B0),
            isDark: isDark,
          ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1),
          const SizedBox(height: AppConstants.spacingLg),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: Colors.amber.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    L10nService.get('screens.reiki.tip', language),
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? Colors.white70 : AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
          ).animate(delay: 300.ms).fadeIn(duration: 500.ms),
          const SizedBox(height: AppConstants.spacingXl),
        ],
      ),
    );
  }

  Widget _buildPrincipleCard(_ReikiPrinciple principle, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            principle.color.withValues(alpha: isDark ? 0.15 : 0.08),
            principle.color.withValues(alpha: isDark ? 0.08 : 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: principle.color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(principle.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      principle.japanese,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: principle.color,
                      ),
                    ),
                    Text(
                      principle.translation,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            principle.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark ? Colors.white70 : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChakraCard(_ChakraInfo chakra, bool isDark, AppLanguage language) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: chakra.color.withValues(alpha: 0.3),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: AppConstants.spacingSm,
        ),
        childrenPadding: const EdgeInsets.only(
          left: AppConstants.spacingLg,
          right: AppConstants.spacingLg,
          bottom: AppConstants.spacingLg,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: chakra.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              chakra.icon,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        title: Text(
          chakra.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              chakra.sanskrit,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: chakra.color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '• ${chakra.location}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : AppColors.textLight,
              ),
            ),
          ],
        ),
        children: [
          // Attributes
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chakra.attributes.map((attr) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: chakra.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  attr,
                  style: TextStyle(
                    fontSize: 12,
                    color: chakra.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Reiki position
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: chakra.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Row(
              children: [
                const Text('🙌', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10nService.get('screens.reiki.reiki_position_label', language),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: chakra.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chakra.reikiPosition,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white : AppColors.textDark,
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
    );
  }

  Widget _buildPracticeSection({
    required String title,
    required String icon,
    required List<String> steps,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.08),
            color.withValues(alpha: isDark ? 0.08 : 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? Colors.white : AppColors.textDark,
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
}

class _ReikiPrinciple {
  final String japanese;
  final String translation;
  final String description;
  final String icon;
  final Color color;

  _ReikiPrinciple({
    required this.japanese,
    required this.translation,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _ChakraInfo {
  final String name;
  final String sanskrit;
  final String location;
  final Color color;
  final String icon;
  final List<String> attributes;
  final String reikiPosition;

  _ChakraInfo({
    required this.name,
    required this.sanskrit,
    required this.location,
    required this.color,
    required this.icon,
    required this.attributes,
    required this.reikiPosition,
  });
}
