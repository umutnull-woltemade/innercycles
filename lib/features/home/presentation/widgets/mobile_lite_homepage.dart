import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/zodiac_sign.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/services/l10n_service.dart';

/// MOBILE LITE HOMEPAGE - App Store 4.3(b) Compliant
///
/// STRICT RULES FOLLOWED:
/// - NO heavy animations (only simple fade/scale)
/// - NO blur, glow, parallax effects
/// - NO background video or canvas
/// - NO astrology calculations on load
/// - NO lottie, particles, scroll-based JS logic
/// - Flat background colors only
/// - Single font family, max 2 weights
/// - First load target: < 1.5s on slow 4G
/// - Static, simple, FAST
///
/// APP STORE 4.3(b) COMPLIANCE:
/// - All astrology/horoscope features removed
/// - Focus on: Insight, Wellness, Dreams, Numerology (educational)
/// - No zodiac-based predictions
class MobileLiteHomepage extends ConsumerWidget {
  const MobileLiteHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    // Guard: Show loading if no valid profile (don't redirect - causes loop)
    if (userProfile == null ||
        userProfile.name == null ||
        userProfile.name!.isEmpty) {
      final language = ref.watch(languageProvider);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.deepSpace : AppColors.lightBackground,
      body: SafeArea(
        child: RepaintBoundary(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ════════════════════════════════════════════════════════════
                // ABOVE THE FOLD - Ultra simple, instant load
                // ════════════════════════════════════════════════════════════
                _AboveTheFold(
                  userName: userProfile.name ?? '',
                  sign: sign,
                  isDark: isDark,
                ),

                // ════════════════════════════════════════════════════════════
                // BELOW THE FOLD - Simple list of entry points
                // ════════════════════════════════════════════════════════════
                _BelowTheFold(isDark: isDark),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ABOVE THE FOLD SECTION
// Flat background, one headline, one sentence, one CTA
// ═══════════════════════════════════════════════════════════════════════════

class _AboveTheFold extends ConsumerWidget {
  final String userName;
  final ZodiacSign sign;
  final bool isDark;

  const _AboveTheFold({
    required this.userName,
    required this.sign,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final headline = _getDailyHeadline(language);
    final sentence = _getDailySentence(language);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F2F8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Minimal header row
          Row(
            children: [
              // Insight symbol
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cosmicPurple
                      : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 24,
                    color: isDark
                        ? AppColors.starGold
                        : AppColors.lightStarGold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      language == AppLanguage.en
                          ? 'Personal Reflection'
                          : 'Kişisel Yansıma',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Settings icon
              IconButton(
                onPressed: () => context.push(Routes.settings),
                icon: Icon(
                  Icons.settings_outlined,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick discovery chips - Quick access to safe features
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickDiscoveryChip(
                  icon: '📓',
                  label: language == AppLanguage.en ? 'Journal' : 'Günlük',
                  onTap: () => context.push(Routes.journal),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '✨',
                  label: language == AppLanguage.en ? 'Insight' : 'İçgörü',
                  onTap: () => context.push(Routes.insight),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🌙',
                  label: L10nService.get('home.chips.dream', language),
                  onTap: () => context.push(Routes.dreamInterpretation),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🧘',
                  label: language == AppLanguage.en ? 'Chakra' : 'Çakra',
                  onTap: () => context.push(Routes.chakraAnalysis),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🔮',
                  label: L10nService.get('home.chips.tarot', language),
                  onTap: () => context.push(Routes.tarot),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🔢',
                  label: language == AppLanguage.en ? 'Numerology' : 'Numeroloji',
                  onTap: () => context.push(Routes.numerology),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🙏',
                  label: L10nService.get('home.chips.reiki', language),
                  onTap: () => context.push(Routes.reiki),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🕯️',
                  label: L10nService.get('home.chips.tantra', language),
                  onTap: () => context.push(Routes.tantra),
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Reflection headline - short, impactful
          Text(
            headline,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.starGold : AppColors.lightStarGold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // Daily emotional sentence
          Text(
            sentence,
            style: TextStyle(
              fontSize: 15,
              color: isDark
                  ? AppColors.textSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Primary CTA - Personal Insight
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(Routes.insight),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.starGold
                    : AppColors.lightStarGold,
                foregroundColor: AppColors.deepSpace,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      language == AppLanguage.en
                          ? 'Start Your Reflection'
                          : 'Yansımanı Başlat',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pre-computed headlines - reflection focused
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
// BELOW THE FOLD SECTION
// Simple list of entry points - no heavy UI
// ═══════════════════════════════════════════════════════════════════════════

class _BelowTheFold extends ConsumerWidget {
  final bool isDark;

  const _BelowTheFold({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title - Journal & Patterns
          Text(
            language == AppLanguage.en
                ? 'Journal & Patterns'
                : 'Günlük ve Kalıplar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.edit_note_outlined,
            title: language == AppLanguage.en
                ? 'Daily Journal'
                : 'Günlük Kayıt',
            subtitle: language == AppLanguage.en
                ? 'Track your energy, focus & emotions'
                : 'Enerji, odak ve duygularını takip et',
            route: Routes.journal,
            isDark: isDark,
            isHighlighted: true,
          ),

          _EntryPointTile(
            icon: Icons.insights_outlined,
            title: language == AppLanguage.en
                ? 'Your Patterns'
                : 'Kalıpların',
            subtitle: language == AppLanguage.en
                ? 'Trends & correlations from your entries'
                : 'Kayıtlarındaki eğilimler ve bağlantılar',
            route: Routes.journalPatterns,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.calendar_month_outlined,
            title: language == AppLanguage.en
                ? 'Monthly Reflection'
                : 'Aylık Yansıma',
            subtitle: language == AppLanguage.en
                ? 'Review your month at a glance'
                : 'Ayına bir bakışta göz at',
            route: Routes.journalMonthly,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.archive_outlined,
            title: language == AppLanguage.en
                ? 'Archive'
                : 'Arşiv',
            subtitle: language == AppLanguage.en
                ? 'Search & browse all entries'
                : 'Tüm kayıtları ara ve gözat',
            route: Routes.journalArchive,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Section title - Insight & Reflection
          Text(
            language == AppLanguage.en
                ? 'Insight & Reflection'
                : 'İçgörü ve Yansıma',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          // Entry points list - Safe features only
          _EntryPointTile(
            icon: Icons.auto_awesome_outlined,
            title: language == AppLanguage.en
                ? 'Personal Insight'
                : 'Kişisel İçgörü',
            subtitle: language == AppLanguage.en
                ? 'AI-powered self-reflection assistant'
                : 'Yapay zeka destekli öz-yansıma asistanı',
            route: Routes.insight,
            isDark: isDark,
            isHighlighted: true,
          ),

          _EntryPointTile(
            icon: Icons.wb_sunny_outlined,
            title: language == AppLanguage.en
                ? 'Daily Theme'
                : 'Günün Teması',
            subtitle: language == AppLanguage.en
                ? 'Today\'s reflection theme'
                : 'Bugünün yansıma teması',
            route: Routes.cosmicToday,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Wellness section
          Text(
            language == AppLanguage.en
                ? 'Wellness & Mindfulness'
                : 'Sağlık ve Farkındalık',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.blur_circular_outlined,
            title: language == AppLanguage.en
                ? 'Chakra Analysis'
                : 'Çakra Analizi',
            subtitle: language == AppLanguage.en
                ? 'Energy center awareness'
                : 'Enerji merkezi farkındalığı',
            route: Routes.chakraAnalysis,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.spa_outlined,
            title: language == AppLanguage.en
                ? 'Aura Reading'
                : 'Aura Okuma',
            subtitle: language == AppLanguage.en
                ? 'Energy field exploration'
                : 'Enerji alanı keşfi',
            route: Routes.aura,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.self_improvement_outlined,
            title: language == AppLanguage.en
                ? 'Daily Rituals'
                : 'Günlük Ritüeller',
            subtitle: language == AppLanguage.en
                ? 'Mindfulness practices'
                : 'Farkındalık pratikleri',
            route: Routes.dailyRituals,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Dream Journal section
          Text(
            language == AppLanguage.en
                ? 'Dream Journal'
                : 'Rüya Günlüğü',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.nights_stay_outlined,
            title: language == AppLanguage.en
                ? 'Dream Interpretation'
                : 'Rüya Yorumu',
            subtitle: language == AppLanguage.en
                ? 'Explore your dream symbols'
                : 'Rüya sembollerini keşfet',
            route: Routes.dreamInterpretation,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.book_outlined,
            title: language == AppLanguage.en
                ? 'Dream Dictionary'
                : 'Rüya Sözlüğü',
            subtitle: language == AppLanguage.en
                ? 'Symbol reference guide'
                : 'Sembol referans rehberi',
            route: Routes.dreamGlossary,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Learning section
          Text(
            language == AppLanguage.en
                ? 'Learning & Reference'
                : 'Öğrenme ve Referans',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.numbers_outlined,
            title: language == AppLanguage.en
                ? 'Numerology'
                : 'Numeroloji',
            subtitle: language == AppLanguage.en
                ? 'Number patterns & meanings'
                : 'Sayı kalıpları ve anlamları',
            route: Routes.numerology,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.style_outlined,
            title: language == AppLanguage.en
                ? 'Tarot Guide'
                : 'Tarot Rehberi',
            subtitle: language == AppLanguage.en
                ? 'Card symbolism & meanings'
                : 'Kart sembolizmi ve anlamları',
            route: Routes.tarot,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.menu_book_outlined,
            title: language == AppLanguage.en
                ? 'Glossary'
                : 'Sözlük',
            subtitle: language == AppLanguage.en
                ? 'Terms & definitions'
                : 'Terimler ve tanımlar',
            route: Routes.glossary,
            isDark: isDark,
          ),

          const SizedBox(height: 32),

          // Footer branding - minimal
          Center(
            child: GestureDetector(
              onTap: () => context.push(Routes.settings),
              child: Text(
                'InnerCycles',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textMuted.withValues(alpha: 0.7)
                      : AppColors.lightTextMuted.withValues(alpha: 0.7),
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QUICK DISCOVERY CHIP
// Compact chip for above-fold quick access
// ═══════════════════════════════════════════════════════════════════════════

class _QuickDiscoveryChip extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickDiscoveryChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.cosmicPurple.withValues(alpha: 0.3)
                : AppColors.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? AppColors.starGold.withValues(alpha: 0.3)
                  : AppColors.lightStarGold.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
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
// ENTRY POINT TILE
// Simple, clean, no animations
// ═══════════════════════════════════════════════════════════════════════════

class _EntryPointTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool isDark;
  final bool isHighlighted;

  const _EntryPointTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.isDark,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? (isDark
                        ? AppColors.starGold.withValues(alpha: 0.1)
                        : AppColors.lightStarGold.withValues(alpha: 0.1))
                  : (isDark ? AppColors.surfaceDark : AppColors.lightCard),
              borderRadius: BorderRadius.circular(12),
              border: isHighlighted
                  ? Border.all(
                      color: isDark
                          ? AppColors.starGold.withValues(alpha: 0.3)
                          : AppColors.lightStarGold.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cosmicPurple
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isHighlighted
                        ? (isDark
                              ? AppColors.starGold
                              : AppColors.lightStarGold)
                        : (isDark
                              ? AppColors.auroraStart
                              : AppColors.lightAuroraStart),
                  ),
                ),

                const SizedBox(width: 14),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
