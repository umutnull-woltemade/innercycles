import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';

/// All Services - Minimal & Aesthetic catalog page
class AllServicesScreen extends ConsumerStatefulWidget {
  const AllServicesScreen({super.key});

  @override
  ConsumerState<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends ConsumerState<AllServicesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final language = ref.watch(languageProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Subtle animated background
          _buildBackground(isDark),

          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Beautiful header
                SliverToBoxAdapter(
                  child: _buildHeader(context, isDark, language),
                ),

                // Categories list
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = _getCategories(language)[index];
                        return _buildCategorySection(
                          context,
                          category['name'] as String,
                          category['icon'] as String,
                          category['color'] as Color,
                          (category['services'] as List<Map<String, dynamic>>),
                          isDark,
                          index,
                        );
                      },
                      childCount: _getCategories(language).length,
                    ),
                  ),
                ),

                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      const Color(0xFF0D0D1A),
                      Color.lerp(
                        const Color(0xFF1A0A2E),
                        const Color(0xFF150820),
                        _bgController.value,
                      )!,
                      const Color(0xFF0D0D1A),
                    ]
                  : [
                      const Color(0xFFFAF8FF),
                      const Color(0xFFF5F0FF),
                      const Color(0xFFFAF8FF),
                    ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        children: [
          // Back button row
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.white70 : AppColors.textDark,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 20),

          // Title with aesthetic design
          Column(
            children: [
              // Decorative line
              Container(
                width: 40,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.starGold.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Main title
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    const Color(0xFFE8D5B7),
                    AppColors.starGold,
                    const Color(0xFFE8D5B7),
                  ],
                ).createShader(bounds),
                child: Text(
                  L10nService.get('home.all_services', language),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                    color: Colors.white,
                    fontFamily: 'serif',
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                '✦ ${L10nService.get('home.all_services_desc', language).toLowerCase()} ✦',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 4,
                  color: isDark
                      ? Colors.white38
                      : AppColors.textLight.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(height: 16),

              // Decorative line
              Container(
                width: 40,
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.starGold.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    String icon,
    Color color,
    List<Map<String, dynamic>> services,
    bool isDark,
    int categoryIndex,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header - minimal
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Services - text only, wrapped
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: services.asMap().entries.map((entry) {
              final service = entry.value;
              return _buildServiceChip(
                context,
                service['name'] as String,
                service['route'] as String,
                color,
                isDark,
              );
            }).toList(),
          ),
        ],
      ),
    ).animate(delay: (80 * categoryIndex).ms)
        .fadeIn(duration: 400.ms)
        .slideX(begin: -0.02);
  }

  Widget _buildServiceChip(
    BuildContext context,
    String name,
    String route,
    Color categoryColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : categoryColor.withValues(alpha: 0.15),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white70 : AppColors.textDark,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // CATEGORIES DATA - Localized
  // ════════════════════════════════════════════════════════════════

  List<Map<String, dynamic>> _getCategories(AppLanguage language) => [
    {
      'name': L10nService.get('sections.horoscope_readings', language),
      'icon': '⭐',
      'color': AppColors.starGold,
      'services': [
        {'name': L10nService.get('menu_features.daily_reading', language), 'route': Routes.horoscope},
        {'name': L10nService.get('menu_features.weekly_reading', language), 'route': Routes.weeklyHoroscope},
        {'name': L10nService.get('menu_features.monthly_reading', language), 'route': Routes.monthlyHoroscope},
        {'name': L10nService.get('menu_features.yearly_reading', language), 'route': Routes.yearlyHoroscope},
        {'name': L10nService.get('menu_features.love_reading', language), 'route': Routes.loveHoroscope},
        {'name': L10nService.get('menu_features.compatibility', language), 'route': Routes.compatibility},
      ],
    },
    {
      'name': L10nService.get('sections.birth_chart_analysis', language),
      'icon': '🗺️',
      'color': AppColors.cosmicPurple,
      'services': [
        {'name': L10nService.get('menu_features.birth_chart', language), 'route': Routes.birthChart},
        {'name': L10nService.get('menu_features.synastry', language), 'route': Routes.synastry},
        {'name': L10nService.get('menu_features.composite', language), 'route': Routes.compositeChart},
        {'name': L10nService.get('menu_features.vedic_chart', language), 'route': Routes.vedicChart},
        {'name': L10nService.get('menu_features.draconic', language), 'route': Routes.draconicChart},
        {'name': L10nService.get('home.quick_actions.asteroids', language), 'route': Routes.asteroids},
        {'name': L10nService.get('home.quick_actions.local_space', language), 'route': Routes.localSpace},
      ],
    },
    {
      'name': L10nService.get('sections.time_transits', language),
      'icon': '⏰',
      'color': AppColors.auroraEnd,
      'services': [
        {'name': L10nService.get('menu_features.transits', language), 'route': Routes.transits},
        {'name': L10nService.get('menu_features.progressions', language), 'route': Routes.progressions},
        {'name': L10nService.get('menu_features.saturn_return', language), 'route': Routes.saturnReturn},
        {'name': L10nService.get('menu_features.solar_return', language), 'route': Routes.solarReturn},
        {'name': L10nService.get('menu_features.year_ahead', language), 'route': Routes.yearAhead},
        {'name': L10nService.get('menu_features.timing', language), 'route': Routes.timing},
        {'name': L10nService.get('menu_features.void_of_course', language), 'route': Routes.voidOfCourse},
        {'name': L10nService.get('menu_features.eclipse_calendar', language), 'route': Routes.eclipseCalendar},
      ],
    },
    {
      'name': L10nService.get('sections.numerology_mystic', language),
      'icon': '🔢',
      'color': AppColors.fireElement,
      'services': [
        {'name': L10nService.get('menu_features.numerology', language), 'route': Routes.numerology},
        {'name': L10nService.get('menu_features.life_number', language), 'route': Routes.lifePath1},
        {'name': L10nService.get('menu_features.kabbalah', language), 'route': Routes.master11},
        {'name': L10nService.get('menu_features.tarot', language), 'route': Routes.personalYear1},
        {'name': L10nService.get('menu_features.aura', language), 'route': Routes.karmicDebt},
      ],
    },
    {
      'name': L10nService.get('sections.spiritual_wellness', language),
      'icon': '🧘',
      'color': AppColors.tantraCrimson,
      'services': [
        {'name': L10nService.get('menu_features.theta_healing', language), 'route': Routes.tantra},
        {'name': L10nService.get('menu_features.chakra', language), 'route': Routes.chakraAnalysis},
        {'name': L10nService.get('menu_features.aura', language), 'route': Routes.aura},
        {'name': L10nService.get('menu_features.kabbalah', language), 'route': Routes.kabbalah},
        {'name': L10nService.get('menu_features.daily_rituals', language), 'route': Routes.dailyRituals},
        {'name': L10nService.get('menu_features.moon_rituals', language), 'route': Routes.moonRituals},
        {'name': L10nService.get('menu_features.crystal_guide', language), 'route': Routes.crystalGuide},
      ],
    },
    {
      'name': L10nService.get('menu_features.tarot', language),
      'icon': '🃏',
      'color': AppColors.mystic,
      'services': [
        {'name': L10nService.get('menu_features.tarot', language), 'route': Routes.tarot},
        {'name': L10nService.get('tarot.major_arcana', language), 'route': Routes.majorArcanaDetail.replaceAll(':number', '0')},
      ],
    },
    {
      'name': L10nService.get('sections.dreams_subconscious', language),
      'icon': '💭',
      'color': AppColors.waterElement,
      'services': [
        {'name': L10nService.get('menu_features.dream_trace', language), 'route': Routes.dreamInterpretation},
        {'name': L10nService.get('menu_features.dream_dictionary', language), 'route': Routes.dreamGlossary},
        {'name': L10nService.get('common.share', language), 'route': Routes.dreamShare},
        {'name': L10nService.get('menu_features.cosmic_trace', language), 'route': Routes.kozmikIletisim},
        {'name': L10nService.get('menu_features.dream_journal', language), 'route': Routes.ruyaDongusu},
      ],
    },
    {
      'name': L10nService.get('sections.relationship_analysis', language),
      'icon': '💑',
      'color': const Color(0xFFE91E63),
      'services': [
        {'name': L10nService.get('menu_features.compatibility_analysis', language), 'route': Routes.compatibility},
        {'name': L10nService.get('menu_features.soulmate', language), 'route': Routes.soulMate},
        {'name': L10nService.get('menu_features.relationship_karma', language), 'route': Routes.relationshipKarma},
        {'name': L10nService.get('menu_features.celebrity_twin', language), 'route': Routes.celebrityTwin},
      ],
    },
    {
      'name': L10nService.get('sections.personality_analysis', language),
      'icon': '🔭',
      'color': AppColors.cosmic,
      'services': [
        {'name': L10nService.get('menu_features.shadow_self', language), 'route': Routes.shadowSelf},
        {'name': L10nService.get('menu_features.heartbreaker', language), 'route': Routes.heartbreak},
        {'name': L10nService.get('menu_features.red_flags', language), 'route': Routes.redFlags},
        {'name': L10nService.get('menu_features.green_flags', language), 'route': Routes.greenFlags},
        {'name': L10nService.get('menu_features.flirt_style', language), 'route': Routes.flirtStyle},
        {'name': L10nService.get('menu_features.leadership_style', language), 'route': Routes.leadershipStyle},
        {'name': L10nService.get('menu_features.tarot_card', language), 'route': Routes.tarotCard},
        {'name': L10nService.get('menu_features.aura_color', language), 'route': Routes.auraColor},
        {'name': L10nService.get('menu_features.chakra_balance', language), 'route': Routes.chakraBalance},
        {'name': L10nService.get('menu_features.life_number', language), 'route': Routes.lifeNumber},
        {'name': L10nService.get('menu_features.kabbalah_path', language), 'route': Routes.kabbalaPath},
      ],
    },
    {
      'name': L10nService.get('sections.references_learning', language),
      'icon': '📚',
      'color': AppColors.earthElement,
      'services': [
        {'name': L10nService.get('menu_features.glossary', language), 'route': Routes.glossary},
        {'name': L10nService.get('menu_features.celebrities', language), 'route': Routes.celebrities},
        {'name': L10nService.get('menu_features.cosmic_trace', language), 'route': Routes.kozmoz},
      ],
    },
  ];
}
