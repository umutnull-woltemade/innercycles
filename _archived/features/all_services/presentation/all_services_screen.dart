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
                    delegate: SliverChildBuilderDelegate((context, index) {
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
                    }, childCount: _getCategories(language).length),
                  ),
                ),

                // Bottom spacing
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
                    Text(icon, style: const TextStyle(fontSize: 16)),
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
        )
        .animate(delay: (80 * categoryIndex).ms)
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
  // CATEGORIES DATA - App Store 4.3(b) Compliant
  // All astrology/horoscope categories have been removed
  // Focus: Insight, Wellness, Dreams, Numerology (educational)
  // ════════════════════════════════════════════════════════════════

  List<Map<String, dynamic>> _getCategories(AppLanguage language) => [
    // Journal & Patterns (Primary Feature)
    {
      'name': language == AppLanguage.en
          ? 'Journal & Patterns'
          : 'Günlük ve Kalıplar',
      'icon': '📓',
      'color': AppColors.auroraStart,
      'services': [
        {
          'name': language == AppLanguage.en
              ? 'Daily Journal'
              : 'Günlük Kayıt',
          'route': Routes.journal,
        },
        {
          'name': language == AppLanguage.en
              ? 'Your Patterns'
              : 'Kalıpların',
          'route': Routes.journalPatterns,
        },
        {
          'name': language == AppLanguage.en
              ? 'Monthly Reflection'
              : 'Aylık Yansıma',
          'route': Routes.journalMonthly,
        },
        {
          'name': language == AppLanguage.en ? 'Archive' : 'Arşiv',
          'route': Routes.journalArchive,
        },
      ],
    },
    // Insight & Reflection
    {
      'name': language == AppLanguage.en
          ? 'Insight & Reflection'
          : 'Içgörü ve Yansıma',
      'icon': '✨',
      'color': AppColors.starGold,
      'services': [
        {
          'name': language == AppLanguage.en
              ? 'Personal Insight'
              : 'Kişisel Içgörü',
          'route': Routes.insight,
        },
        {
          'name': language == AppLanguage.en ? 'Daily Theme' : 'Günün Teması',
          'route': Routes.cosmicToday,
        },
        {
          'name':
              language == AppLanguage.en ? 'Daily Energy' : 'Günlük Enerji',
          'route': Routes.cosmicEnergy,
        },
      ],
    },
    // Wellness & Mindfulness
    {
      'name': language == AppLanguage.en
          ? 'Wellness & Mindfulness'
          : 'Sağlık ve Farkındalık',
      'icon': '🧘',
      'color': AppColors.tantraCrimson,
      'services': [
        {
          'name': language == AppLanguage.en
              ? 'Chakra Analysis'
              : 'Çakra Analizi',
          'route': Routes.chakraAnalysis,
        },
        {
          'name': language == AppLanguage.en ? 'Aura Reading' : 'Aura Okuma',
          'route': Routes.aura,
        },
        {
          'name':
              language == AppLanguage.en ? 'Daily Rituals' : 'Günlük Ritüeller',
          'route': Routes.dailyRituals,
        },
        {
          'name': language == AppLanguage.en ? 'Tantra' : 'Tantra',
          'route': Routes.tantra,
        },
        {
          'name':
              language == AppLanguage.en ? 'Theta Healing' : 'Theta Şifa',
          'route': Routes.thetaHealing,
        },
        {
          'name': language == AppLanguage.en ? 'Reiki' : 'Reiki',
          'route': Routes.reiki,
        },
      ],
    },
    // Dream Journal
    {
      'name': language == AppLanguage.en
          ? 'Dream Journal'
          : 'Rüya Günlüğü',
      'icon': '💭',
      'color': AppColors.waterElement,
      'services': [
        {
          'name': language == AppLanguage.en
              ? 'Dream Interpretation'
              : 'Rüya Yorumu',
          'route': Routes.dreamInterpretation,
        },
        {
          'name': language == AppLanguage.en
              ? 'Dream Dictionary'
              : 'Rüya Sözlüğü',
          'route': Routes.dreamGlossary,
        },
        {
          'name': language == AppLanguage.en ? 'Share Dream' : 'Rüya Paylaş',
          'route': Routes.dreamShare,
        },
      ],
    },
    // Numerology (Educational)
    {
      'name': language == AppLanguage.en
          ? 'Number Patterns'
          : 'Sayı Kalıpları',
      'icon': '🔢',
      'color': AppColors.fireElement,
      'services': [
        {
          'name':
              language == AppLanguage.en ? 'Numerology' : 'Numeroloji',
          'route': Routes.numerology,
        },
        {
          'name':
              language == AppLanguage.en ? 'Life Path' : 'Yaşam Yolu',
          'route': Routes.lifePathDetail.replaceAll(':number', '1'),
        },
      ],
    },
    // Tarot & Kabbalah (Educational)
    {
      'name': language == AppLanguage.en
          ? 'Symbolic Wisdom'
          : 'Sembolik Bilgelik',
      'icon': '🃏',
      'color': AppColors.mystic,
      'services': [
        {
          'name': language == AppLanguage.en ? 'Tarot Guide' : 'Tarot Rehberi',
          'route': Routes.tarot,
        },
        {
          'name': language == AppLanguage.en ? 'Major Arcana' : 'Büyük Arkana',
          'route': Routes.majorArcanaDetail.replaceAll(':number', '0'),
        },
        {
          'name': language == AppLanguage.en ? 'Kabbalah' : 'Kabala',
          'route': Routes.kabbalah,
        },
      ],
    },
    // Reference & Learning
    {
      'name': language == AppLanguage.en
          ? 'Reference & Learning'
          : 'Referans ve Öğrenme',
      'icon': '📚',
      'color': AppColors.earthElement,
      'services': [
        {
          'name': language == AppLanguage.en ? 'Glossary' : 'Sözlük',
          'route': Routes.glossary,
        },
        {
          'name': language == AppLanguage.en ? 'Articles' : 'Makaleler',
          'route': Routes.articles,
        },
        {
          'name': language == AppLanguage.en ? 'Celebrities' : 'Ünlüler',
          'route': Routes.celebrities,
        },
      ],
    },
    // Profile & Settings
    {
      'name': language == AppLanguage.en
          ? 'Profile & Settings'
          : 'Profil ve Ayarlar',
      'icon': '⚙️',
      'color': AppColors.cosmic,
      'services': [
        {
          'name': language == AppLanguage.en ? 'My Profile' : 'Profilim',
          'route': Routes.profile,
        },
        {
          'name':
              language == AppLanguage.en ? 'Saved Profiles' : 'Kayıtlı Profiller',
          'route': Routes.savedProfiles,
        },
        {
          'name': language == AppLanguage.en ? 'Settings' : 'Ayarlar',
          'route': Routes.settings,
        },
        {
          'name': language == AppLanguage.en ? 'Premium' : 'Premium',
          'route': Routes.premium,
        },
      ],
    },
  ];
}
