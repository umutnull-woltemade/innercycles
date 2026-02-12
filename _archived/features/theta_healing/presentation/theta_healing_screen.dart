import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/l10n_service.dart';
import '../../../data/providers/app_providers.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';

/// Theta Healing Screen - Subconscious Transformation Practice
/// Energy work performed in the theta brain wave state
class ThetaHealingScreen extends ConsumerStatefulWidget {
  const ThetaHealingScreen({super.key});

  @override
  ConsumerState<ThetaHealingScreen> createState() => _ThetaHealingScreenState();
}

class _ThetaHealingScreenState extends ConsumerState<ThetaHealingScreen>
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
                    _buildIntroTab(isDark, language),
                    _buildTechniquesTab(isDark, language),
                    _buildMeditationsTab(isDark, language),
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
                        const Text('\u{1F9E0}', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          L10nService.get('theta_healing.title', language),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textDark,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      L10nService.get('theta_healing.subtitle', language),
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
                  : const Color(0xFF7C4DFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              L10nService.get('theta_healing.intro_description', language),
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
        labelColor: isDark ? const Color(0xFF7C4DFF) : const Color(0xFF5E35B1),
        unselectedLabelColor: isDark ? Colors.white60 : AppColors.textLight,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: isDark
              ? const Color(0xFF7C4DFF).withValues(alpha: 0.2)
              : const Color(0xFF5E35B1).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: L10nService.get('theta_healing.tabs.intro', language)),
          Tab(text: L10nService.get('theta_healing.tabs.techniques', language)),
          Tab(
            text: L10nService.get('theta_healing.tabs.meditations', language),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroTab(bool isDark, AppLanguage language) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: L10nService.get(
              'theta_healing.intro.theta_state_title',
              language,
            ),
            content: L10nService.get(
              'theta_healing.intro.theta_state_content',
              language,
            ),
            icon: '\u{1F30A}',
            color: const Color(0xFF7C4DFF),
            isDark: isDark,
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoCard(
            title: L10nService.get(
              'theta_healing.intro.limiting_beliefs_title',
              language,
            ),
            content: L10nService.get(
              'theta_healing.intro.limiting_beliefs_content',
              language,
            ),
            icon: '\u{1F513}',
            color: const Color(0xFFE040FB),
            isDark: isDark,
          ).animate(delay: 100.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoCard(
            title: L10nService.get(
              'theta_healing.intro.energy_transformation_title',
              language,
            ),
            content: L10nService.get(
              'theta_healing.intro.energy_transformation_content',
              language,
            ),
            icon: '\u2728',
            color: const Color(0xFF00BCD4),
            isDark: isDark,
          ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1),
          const SizedBox(height: AppConstants.spacingMd),
          _buildInfoCard(
            title: L10nService.get(
              'theta_healing.intro.seven_planes_title',
              language,
            ),
            content: L10nService.get(
              'theta_healing.intro.seven_planes_content',
              language,
            ),
            icon: '\u{1F30C}',
            color: const Color(0xFFFFD700),
            isDark: isDark,
          ).animate(delay: 300.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1),
          const SizedBox(height: AppConstants.spacingXl),
          PageFooterWithDisclaimer(
            brandText:
                '${L10nService.get('theta_healing.title', language)} \u2014 Venus One',
            disclaimerText: DisclaimerTexts.astrology(language),
            language: language,
          ),
        ],
      ),
    );
  }

  Widget _buildTechniquesTab(bool isDark, AppLanguage language) {
    final techniques = [
      _TechniqueTile(
        title: L10nService.get(
          'theta_healing.techniques.digging_title',
          language,
        ),
        description: L10nService.get(
          'theta_healing.techniques.digging_description',
          language,
        ),
        steps: [
          L10nService.get('theta_healing.techniques.digging_step_1', language),
          L10nService.get('theta_healing.techniques.digging_step_2', language),
          L10nService.get('theta_healing.techniques.digging_step_3', language),
          L10nService.get('theta_healing.techniques.digging_step_4', language),
        ],
        icon: '\u26CF\uFE0F',
        color: const Color(0xFFFF7043),
      ),
      _TechniqueTile(
        title: L10nService.get(
          'theta_healing.techniques.belief_change_title',
          language,
        ),
        description: L10nService.get(
          'theta_healing.techniques.belief_change_description',
          language,
        ),
        steps: [
          L10nService.get(
            'theta_healing.techniques.belief_change_step_1',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.belief_change_step_2',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.belief_change_step_3',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.belief_change_step_4',
            language,
          ),
        ],
        icon: '\u{1F504}',
        color: const Color(0xFF4CAF50),
      ),
      _TechniqueTile(
        title: L10nService.get(
          'theta_healing.techniques.feeling_download_title',
          language,
        ),
        description: L10nService.get(
          'theta_healing.techniques.feeling_download_description',
          language,
        ),
        steps: [
          L10nService.get(
            'theta_healing.techniques.feeling_download_step_1',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.feeling_download_step_2',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.feeling_download_step_3',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.feeling_download_step_4',
            language,
          ),
        ],
        icon: '\u{1F49C}',
        color: const Color(0xFF9C27B0),
      ),
      _TechniqueTile(
        title: L10nService.get(
          'theta_healing.techniques.body_scan_title',
          language,
        ),
        description: L10nService.get(
          'theta_healing.techniques.body_scan_description',
          language,
        ),
        steps: [
          L10nService.get(
            'theta_healing.techniques.body_scan_step_1',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.body_scan_step_2',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.body_scan_step_3',
            language,
          ),
          L10nService.get(
            'theta_healing.techniques.body_scan_step_4',
            language,
          ),
        ],
        icon: '\u{1F50D}',
        color: const Color(0xFF2196F3),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      itemCount: techniques.length,
      itemBuilder: (context, index) {
        return _buildTechniqueCard(techniques[index], isDark, language)
            .animate(delay: (100 * index).ms)
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.05);
      },
    );
  }

  Widget _buildMeditationsTab(bool isDark, AppLanguage language) {
    final meditations = [
      _MeditationTile(
        title: L10nService.get(
          'theta_healing.meditations.theta_transition_title',
          language,
        ),
        duration: L10nService.get(
          'theta_healing.meditations.theta_transition_duration',
          language,
        ),
        description: L10nService.get(
          'theta_healing.meditations.theta_transition_description',
          language,
        ),
        icon: '\u{1F30A}',
        color: const Color(0xFF7C4DFF),
      ),
      _MeditationTile(
        title: L10nService.get(
          'theta_healing.meditations.seventh_plane_title',
          language,
        ),
        duration: L10nService.get(
          'theta_healing.meditations.seventh_plane_duration',
          language,
        ),
        description: L10nService.get(
          'theta_healing.meditations.seventh_plane_description',
          language,
        ),
        icon: '\u{1F30C}',
        color: const Color(0xFFFFD700),
      ),
      _MeditationTile(
        title: L10nService.get(
          'theta_healing.meditations.inner_child_title',
          language,
        ),
        duration: L10nService.get(
          'theta_healing.meditations.inner_child_duration',
          language,
        ),
        description: L10nService.get(
          'theta_healing.meditations.inner_child_description',
          language,
        ),
        icon: '\u{1F476}',
        color: const Color(0xFFFF6B9D),
      ),
      _MeditationTile(
        title: L10nService.get(
          'theta_healing.meditations.ancestor_clearing_title',
          language,
        ),
        duration: L10nService.get(
          'theta_healing.meditations.ancestor_clearing_duration',
          language,
        ),
        description: L10nService.get(
          'theta_healing.meditations.ancestor_clearing_description',
          language,
        ),
        icon: '\u{1F333}',
        color: const Color(0xFF4CAF50),
      ),
      _MeditationTile(
        title: L10nService.get(
          'theta_healing.meditations.abundance_title',
          language,
        ),
        duration: L10nService.get(
          'theta_healing.meditations.abundance_duration',
          language,
        ),
        description: L10nService.get(
          'theta_healing.meditations.abundance_description',
          language,
        ),
        icon: '\u{1F4B0}',
        color: const Color(0xFF50C878),
      ),
      _MeditationTile(
        title: L10nService.get(
          'theta_healing.meditations.soulmate_title',
          language,
        ),
        duration: L10nService.get(
          'theta_healing.meditations.soulmate_duration',
          language,
        ),
        description: L10nService.get(
          'theta_healing.meditations.soulmate_description',
          language,
        ),
        icon: '\u{1F495}',
        color: const Color(0xFFE91E63),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      itemCount: meditations.length,
      itemBuilder: (context, index) {
        return _buildMeditationCard(
          meditations[index],
          isDark,
        ).animate(delay: (80 * index).ms).fadeIn(duration: 400.ms);
      },
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required String icon,
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
            color.withValues(alpha: isDark ? 0.2 : 0.1),
            color.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
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

  Widget _buildTechniqueCard(
    _TechniqueTile technique,
    bool isDark,
    AppLanguage language,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
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
            color: technique.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(technique.icon, style: const TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(
          technique.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        subtitle: Text(
          technique.description,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : AppColors.textLight,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: technique.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.get('theta_healing.techniques.steps', language),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: technique.color,
                  ),
                ),
                const SizedBox(height: 8),
                ...technique.steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: technique.color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: technique.color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
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
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(_MeditationTile meditation, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            meditation.color.withValues(alpha: isDark ? 0.15 : 0.08),
            meditation.color.withValues(alpha: isDark ? 0.08 : 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: meditation.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: meditation.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                meditation.icon,
                style: const TextStyle(fontSize: 28),
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
                    Expanded(
                      child: Text(
                        meditation.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: meditation.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        meditation.duration,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: meditation.color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  meditation.description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? Colors.white70 : AppColors.textLight,
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

class _TechniqueTile {
  final String title;
  final String description;
  final List<String> steps;
  final String icon;
  final Color color;

  _TechniqueTile({
    required this.title,
    required this.description,
    required this.steps,
    required this.icon,
    required this.color,
  });
}

class _MeditationTile {
  final String title;
  final String duration;
  final String description;
  final String icon;
  final Color color;

  _MeditationTile({
    required this.title,
    required this.duration,
    required this.description,
    required this.icon,
    required this.color,
  });
}
