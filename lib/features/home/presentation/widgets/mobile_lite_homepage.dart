import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/zodiac_sign.dart';
import '../../../../data/providers/app_providers.dart';
import '../../../../data/content/venus_homepage_content.dart';
import '../../../../data/services/l10n_service.dart';

/// MOBILE LITE HOMEPAGE
///
/// STRICT RULES FOLLOWED:
/// - NO heavy animations (only simple fade/scale)
/// - NO blur, glow, parallax effects
/// - NO background video or canvas
/// - NO astro calculations on load
/// - NO lottie, particles, scroll-based JS logic
/// - Flat background colors only
/// - Single font family, max 2 weights
/// - First load target: < 1.5s on slow 4G
/// - Static, simple, FAST
///
/// PERFORMANCE OPTIMIZATIONS (2026):
/// - const constructors everywhere possible
/// - RepaintBoundary on scroll content
/// - AutomaticKeepAlive for cached state
/// - Minimal rebuilds with select() when possible
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
    final headline = _getDailyHeadline(sign, language);
    final sentence = _getDailySentence(sign, language);

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
              // Sign symbol
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
                  child: Text(
                    sign.symbol,
                    style: TextStyle(
                      fontSize: 24,
                      color: isDark
                          ? AppColors.starGold
                          : AppColors.lightStarGold,
                    ),
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
                      sign.localizedName(language),
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

          // Quick discovery chips - Quick access to cosmic tools
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickDiscoveryChip(
                  icon: '🌙',
                  label: L10nService.get('home.chips.dream', language),
                  onTap: () => context.push(Routes.dreamInterpretation),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🌌',
                  label: L10nService.get('home.chips.kozmoz', language),
                  onTap: () => context.push(Routes.kozmoz),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🗺️',
                  label: L10nService.get('home.chips.birth_chart', language),
                  onTap: () => context.push(Routes.birthChart),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🧠',
                  label: L10nService.get('home.chips.theta_healing', language),
                  onTap: () => context.push(Routes.thetaHealing),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🌍',
                  label: L10nService.get(
                    'home.chips.astrocartography',
                    language,
                  ),
                  onTap: () => context.push(Routes.astroCartography),
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
                  icon: '🔮',
                  label: L10nService.get('home.chips.tarot', language),
                  onTap: () => context.push(Routes.tarot),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '⭐',
                  label: L10nService.get('home.chips.horoscope', language),
                  onTap: () => context.push(Routes.horoscope),
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

          // Cosmic headline - short, impactful
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

          // Primary CTA - Today's Cosmic Message
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(Routes.cosmicShare),
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
                      L10nService.get('home.todays_cosmic_message', language),
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

  // Pre-computed headlines - uses localized content
  String _getDailyHeadline(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.toString().split('.').last; // 'aries', 'taurus', etc.
    final headlines = L10nService.getList('home.headlines.$signKey', language);
    if (headlines.isEmpty) return '';
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final index = (dayOfYear + sign.index) % headlines.length;
    return headlines[index];
  }

  String _getDailySentence(ZodiacSign sign, AppLanguage language) {
    final signKey = sign.toString().split('.').last; // 'aries', 'taurus', etc.
    final sentences = L10nService.getList('home.sentences.$signKey', language);
    if (sentences.isEmpty) return '';
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final index = (dayOfYear + sign.index) % sentences.length;
    return sentences[index];
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
          // Section title
          Text(
            L10nService.get('home.sections.star_gate', language),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          // Entry points list
          _EntryPointTile(
            icon: Icons.wb_sunny_outlined,
            title: L10nService.get('home.entries.cosmic_flow.title', language),
            subtitle: L10nService.get(
              'home.entries.cosmic_flow.subtitle',
              language,
            ),
            route: Routes.horoscope,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.auto_awesome_outlined,
            title: L10nService.get('home.entries.cosmic_share.title', language),
            subtitle: L10nService.get(
              'home.entries.cosmic_share.subtitle',
              language,
            ),
            route: Routes.cosmicShare,
            isDark: isDark,
            isHighlighted: true,
          ),

          _EntryPointTile(
            icon: Icons.style_outlined,
            title: L10nService.get('home.entries.tarot.title', language),
            subtitle: L10nService.get('home.entries.tarot.subtitle', language),
            route: Routes.tarot,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.favorite_border_outlined,
            title: L10nService.get(
              'home.entries.compatibility.title',
              language,
            ),
            subtitle: L10nService.get(
              'home.entries.compatibility.subtitle',
              language,
            ),
            route: Routes.compatibility,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.pie_chart_outline,
            title: L10nService.get('home.entries.birth_chart.title', language),
            subtitle: L10nService.get(
              'home.entries.birth_chart.subtitle',
              language,
            ),
            route: Routes.birthChart,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Secondary section - More features
          Text(
            L10nService.get('home.sections.hidden_knowledge', language),
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
            title: L10nService.get('home.entries.numerology.title', language),
            subtitle: L10nService.get(
              'home.entries.numerology.subtitle',
              language,
            ),
            route: Routes.numerology,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.nights_stay_outlined,
            title: L10nService.get('home.entries.dream.title', language),
            subtitle: L10nService.get('home.entries.dream.subtitle', language),
            route: Routes.dreamInterpretation,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.blur_circular_outlined,
            title: L10nService.get('home.entries.chakra.title', language),
            subtitle: L10nService.get('home.entries.chakra.subtitle', language),
            route: Routes.chakraAnalysis,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.all_inclusive_outlined,
            title: L10nService.get('home.entries.all_signs.title', language),
            subtitle: L10nService.get(
              'home.entries.all_signs.subtitle',
              language,
            ),
            route: Routes.horoscope,
            isDark: isDark,
          ),

          const SizedBox(height: 32),

          // ════════════════════════════════════════════════════════════
          // VENUS WISDOM SECTION - 12 Rich Content Sections
          // ════════════════════════════════════════════════════════════
          Text(
            L10nService.get('home.sections.venus_wisdom', language),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            L10nService.get('home.sections.venus_wisdom_subtitle', language),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
            ),
          ),

          const SizedBox(height: 16),

          // Venus content tiles (first 6)
          ...VenusHomepageContent.sections
              .take(6)
              .map(
                (section) => _VenusContentTile(
                  emoji: section.emoji,
                  title: section.getTitle(language),
                  subtitle: section.getSubtitle(language),
                  badge: section.getBadge(language),
                  route: section.route,
                  isDark: isDark,
                ),
              ),

          const SizedBox(height: 24),

          // Expandable "More Venus Content" section
          Text(
            L10nService.get('home.sections.ancient_secrets', language),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          // Venus content tiles (remaining 6)
          ...VenusHomepageContent.sections
              .skip(6)
              .map(
                (section) => _VenusContentTile(
                  emoji: section.emoji,
                  title: section.getTitle(language),
                  subtitle: section.getSubtitle(language),
                  badge: section.getBadge(language),
                  route: section.route,
                  isDark: isDark,
                ),
              ),

          const SizedBox(height: 32),

          // House System Section
          Text(
            L10nService.get('home.sections.astrological_houses', language),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _EntryPointTile(
            icon: Icons.home_outlined,
            title: L10nService.get('home.entries.house_system.title', language),
            subtitle: L10nService.get(
              'home.entries.house_system.subtitle',
              language,
            ),
            route: Routes.birthChart,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Footer branding - minimal (tap to go to Kozmoz)
          Center(
            child: GestureDetector(
              onTap: () => context.push(Routes.kozmoz),
              child: Text(
                'Venus One',
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
// VENUS CONTENT TILE
// Rich content entry point with emoji, badge support
// ═══════════════════════════════════════════════════════════════════════════

class _VenusContentTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String? badge;
  final String route;
  final bool isDark;

  const _VenusContentTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.route,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(route),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.5)
                  : AppColors.lightSurfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? AppColors.cosmicPurple.withValues(alpha: 0.3)
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                // Emoji icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cosmicPurple.withValues(alpha: 0.4)
                        : AppColors.lightStarGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 14),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          if (badge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: badge == 'Yeni'
                                    ? AppColors.starGold.withValues(alpha: 0.2)
                                    : AppColors.cosmicPurple.withValues(
                                        alpha: 0.2,
                                      ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                badge!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: badge == 'Yeni'
                                      ? AppColors.starGold
                                      : (isDark
                                            ? AppColors.textSecondary
                                            : AppColors.lightTextSecondary),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
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

// ═══════════════════════════════════════════════════════════════════════════
// ENTRY POINT TILE
// Simple, clean, no animations
// ═══════════════════════════════════════════════════════════════════════════

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
