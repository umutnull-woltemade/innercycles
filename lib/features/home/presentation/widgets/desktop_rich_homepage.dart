import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/zodiac_sign.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../shared/widgets/cosmic_background.dart';
import '../../../../shared/widgets/page_bottom_navigation.dart';
import '../../../../data/services/l10n_service.dart';

/// DESKTOP RICH HOMEPAGE - App Store 4.3(b) Compliant
///
/// DESIGN GOALS:
/// - Visual, immersive, cinematic experience
/// - Heavy animations, parallax effects, glows
/// - Full cosmic background with nebula
/// - Multi-column layout for large screens
/// - Premium feel with glass morphism
///
/// APP STORE 4.3(b) COMPLIANCE:
/// - All astrology/horoscope features removed
/// - Focus on: Insight, Wellness, Dreams, Numerology (educational)
/// - No zodiac-based predictions
///
/// TARGET: Desktop/Tablet (>768px width)
class DesktopRichHomepage extends ConsumerWidget {
  const DesktopRichHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);

    // Guard: Show loading if no valid profile (don't redirect - causes loop)
    if (userProfile == null ||
        userProfile.name == null ||
        userProfile.name!.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D1A),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFFFFD700)),
              const SizedBox(height: 16),
              Text(
                L10nService.get('common.loading', language),
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    final sign = userProfile.sunSign;

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                children: [
                  // ══════════════════════════════════════════════════════
                  // HEADER - Premium glass morphism header
                  // ══════════════════════════════════════════════════════
                  _DesktopHeader(
                    userName: userProfile.name ?? '',
                    sign: sign,
                    language: language,
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1),

                  const SizedBox(height: 16),

                  // ══════════════════════════════════════════════════════
                  // QUICK DISCOVERY BAR - Safe features only
                  // ══════════════════════════════════════════════════════
                  _QuickDiscoveryBar(
                    language: language,
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  const SizedBox(height: 24),

                  // ══════════════════════════════════════════════════════
                  // HERO SECTION - Large cosmic card with daily message
                  // ══════════════════════════════════════════════════════
                  _HeroSection(sign: sign, language: language)
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .scale(begin: const Offset(0.95, 0.95)),

                  const SizedBox(height: 40),

                  // ══════════════════════════════════════════════════════
                  // FEATURE CATEGORIES - Multi-column grid
                  // ══════════════════════════════════════════════════════
                  _FeatureCategoriesSection(language: language)
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 400.ms),

                  const SizedBox(height: 40),

                  // ══════════════════════════════════════════════════════
                  // BOTTOM NAVIGATION
                  // ══════════════════════════════════════════════════════
                  PageBottomNavigation(
                    currentRoute: '/',
                    language: language,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DESKTOP HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _DesktopHeader extends StatelessWidget {
  final String userName;
  final ZodiacSign sign;
  final AppLanguage language;

  const _DesktopHeader({
    required this.userName,
    required this.sign,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // User greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nService.getWithParams(
                    'home.greeting',
                    language,
                    params: {'name': userName},
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  language == AppLanguage.en
                      ? 'Personal Reflection & Wellness'
                      : 'Kişisel Yansıma ve Sağlık',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Settings button
          IconButton(
            onPressed: () => context.push(Routes.settings),
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 8),
          // Profile button
          IconButton(
            onPressed: () => context.push(Routes.profile),
            icon: Icon(
              Icons.person_outline,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QUICK DISCOVERY BAR - Safe features only
// ═══════════════════════════════════════════════════════════════════════════

class _QuickDiscoveryBar extends StatelessWidget {
  final AppLanguage language;

  const _QuickDiscoveryBar({required this.language});

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickItem(
        icon: '📓',
        label: language == AppLanguage.en ? 'Journal' : 'Günlük',
        route: Routes.journal,
      ),
      _QuickItem(
        icon: '✨',
        label: language == AppLanguage.en ? 'Insight' : 'İçgörü',
        route: Routes.insight,
      ),
      _QuickItem(
        icon: '🌙',
        label: language == AppLanguage.en ? 'Dreams' : 'Rüyalar',
        route: Routes.dreamInterpretation,
      ),
      _QuickItem(
        icon: '🧘',
        label: language == AppLanguage.en ? 'Chakra' : 'Çakra',
        route: Routes.chakraAnalysis,
      ),
      _QuickItem(
        icon: '🔮',
        label: language == AppLanguage.en ? 'Tarot' : 'Tarot',
        route: Routes.tarot,
      ),
      _QuickItem(
        icon: '🔢',
        label: language == AppLanguage.en ? 'Numerology' : 'Numeroloji',
        route: Routes.numerology,
      ),
      _QuickItem(
        icon: '🙏',
        label: language == AppLanguage.en ? 'Rituals' : 'Ritüeller',
        route: Routes.dailyRituals,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _QuickDiscoveryChip(
                  icon: item.icon,
                  label: item.label,
                  onTap: () => context.push(item.route),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _QuickItem {
  final String icon;
  final String label;
  final String route;

  const _QuickItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _QuickDiscoveryChip extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _QuickDiscoveryChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.cosmicPurple.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.starGold.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HERO SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final ZodiacSign sign;
  final AppLanguage language;

  const _HeroSection({
    required this.sign,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cosmicPurple.withValues(alpha: 0.4),
            AppColors.starGold.withValues(alpha: 0.2),
            const Color(0xFF1A1A2E).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.starGold.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Headline
          Text(
            _getDailyHeadline(language),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.starGold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          // Sentence
          Text(
            _getDailySentence(language),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          // CTA Button
          ElevatedButton(
            onPressed: () => context.push(Routes.insight),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.starGold,
              foregroundColor: AppColors.deepSpace,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language == AppLanguage.en
                      ? 'Start Your Reflection'
                      : 'Yansımanı Başlat',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDailyHeadline(AppLanguage language) {
    final headlines = language == AppLanguage.en
        ? [
            'What patterns are you noticing today?',
            'Take a moment for self-reflection',
            'Your inner wisdom awaits',
            'Discover something new about yourself',
            'Today is a day for growth',
            'Embrace your personal journey',
            'Find clarity in stillness',
          ]
        : [
            'Bugün hangi kalıpları fark ediyorsun?',
            'Kendine yansıma için bir an al',
            'İç bilgeliğin seni bekliyor',
            'Kendin hakkında yeni bir şey keşfet',
            'Bugün büyüme günü',
            'Kişisel yolculuğunu kucakla',
            'Sessizlikte netlik bul',
          ];

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return headlines[dayOfYear % headlines.length];
  }

  String _getDailySentence(AppLanguage language) {
    final sentences = language == AppLanguage.en
        ? [
            'Every moment of reflection brings you closer to understanding yourself.',
            'Your thoughts and feelings hold valuable insights.',
            'Take time to explore your inner world today.',
            'Self-awareness is the first step to personal growth.',
            'What does your intuition tell you today?',
            'Notice the patterns in your thoughts and emotions.',
            'Your journey of self-discovery continues.',
          ]
        : [
            'Her yansıma anı seni kendini anlamaya yaklaştırır.',
            'Düşüncelerin ve duyguların değerli içgörüler taşır.',
            'Bugün iç dünyanı keşfetmek için zaman ayır.',
            'Öz farkındalık kişisel büyümenin ilk adımıdır.',
            'Sezgilerin bugün sana ne söylüyor?',
            'Düşüncelerindeki ve duygularındaki kalıpları fark et.',
            'Kendini keşif yolculuğun devam ediyor.',
          ];

    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    return sentences[dayOfYear % sentences.length];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FEATURE CATEGORIES SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _FeatureCategoriesSection extends StatelessWidget {
  final AppLanguage language;

  const _FeatureCategoriesSection({required this.language});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200 ? 3 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.5,
          children: [
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Journal & Patterns'
                  : 'Günlük ve Kalıplar',
              subtitle: language == AppLanguage.en
                  ? 'Track your daily cycles'
                  : 'Günlük döngülerini takip et',
              icon: Icons.edit_note,
              color: AppColors.auroraStart,
              route: Routes.journal,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Insight & Reflection'
                  : 'İçgörü ve Yansıma',
              subtitle: language == AppLanguage.en
                  ? 'AI-powered self-discovery'
                  : 'Yapay zeka destekli öz-keşif',
              icon: Icons.auto_awesome,
              color: AppColors.starGold,
              route: Routes.insight,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Dream Journal'
                  : 'Rüya Günlüğü',
              subtitle: language == AppLanguage.en
                  ? 'Explore your subconscious'
                  : 'Bilinçaltını keşfet',
              icon: Icons.nights_stay,
              color: AppColors.waterElement,
              route: Routes.dreamInterpretation,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Wellness'
                  : 'Sağlık',
              subtitle: language == AppLanguage.en
                  ? 'Chakra, Aura & Rituals'
                  : 'Çakra, Aura ve Ritüeller',
              icon: Icons.spa,
              color: AppColors.tantraCrimson,
              route: Routes.chakraAnalysis,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Numerology'
                  : 'Numeroloji',
              subtitle: language == AppLanguage.en
                  ? 'Number patterns & meanings'
                  : 'Sayı kalıpları ve anlamları',
              icon: Icons.numbers,
              color: AppColors.fireElement,
              route: Routes.numerology,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Tarot Guide'
                  : 'Tarot Rehberi',
              subtitle: language == AppLanguage.en
                  ? 'Card symbolism'
                  : 'Kart sembolizmi',
              icon: Icons.style,
              color: AppColors.mystic,
              route: Routes.tarot,
            ),
            _FeatureCard(
              title: language == AppLanguage.en
                  ? 'Reference'
                  : 'Referans',
              subtitle: language == AppLanguage.en
                  ? 'Glossary & Articles'
                  : 'Sözlük ve Makaleler',
              icon: Icons.menu_book,
              color: AppColors.earthElement,
              route: Routes.glossary,
            ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
