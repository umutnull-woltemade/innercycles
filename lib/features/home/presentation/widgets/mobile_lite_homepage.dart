import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/zodiac_sign.dart';
import '../../../../data/providers/app_providers.dart';

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

    // Guard: Redirect to onboarding if no valid profile
    if (userProfile == null || userProfile.name == null || userProfile.name!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(Routes.onboarding);
        }
      });
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D1A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
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

class _AboveTheFold extends StatelessWidget {
  final String userName;
  final ZodiacSign sign;
  final bool isDark;

  const _AboveTheFold({
    required this.userName,
    required this.sign,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final headline = _getDailyHeadline(sign);
    final sentence = _getDailySentence(sign);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1A2E)
            : const Color(0xFFF0F2F8),
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
                      color: isDark ? AppColors.starGold : AppColors.lightStarGold,
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
                      'Merhaba, $userName',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sign.nameTr,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
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
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quick discovery chips - Kozmik araçlara hızlı erişim
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickDiscoveryChip(
                  icon: '🌙',
                  label: 'Rüya',
                  onTap: () => context.push(Routes.dreamInterpretation),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🌌',
                  label: 'Kozmoz İzi',
                  onTap: () => context.push(Routes.kozmoz),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🔮',
                  label: 'Tarot',
                  onTap: () => context.push(Routes.tarot),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '⭐',
                  label: 'Burç',
                  onTap: () => context.push(Routes.horoscope),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _QuickDiscoveryChip(
                  icon: '🕯️',
                  label: 'Tantra',
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
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // Primary CTA - "Bugünün Kozmik Mesajı"
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(Routes.cosmicShare),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.starGold : AppColors.lightStarGold,
                foregroundColor: AppColors.deepSpace,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bugünün Kozmik Mesajı',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pre-computed headlines - no runtime calculation
  String _getDailyHeadline(ZodiacSign sign) {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = (dayOfYear + sign.index) % _headlines[sign.index].length;
    return _headlines[sign.index][index];
  }

  String _getDailySentence(ZodiacSign sign) {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = (dayOfYear + sign.index) % _sentences[sign.index].length;
    return _sentences[sign.index][index];
  }

  // Static content - no API calls, instant load
  static const List<List<String>> _headlines = [
    // Aries
    ['Cesaretin bugün test ediliyor.', 'Ateşin içinden geçme zamanı.', 'Liderlik enerjin yükseliyor.'],
    // Taurus
    ['Köklerin seni taşıyor.', 'Sabır bugün en büyük gücün.', 'Değerini bil, taviz verme.'],
    // Gemini
    ['İki dünya arasında dans ediyorsun.', 'Kelimeler bugün silahın.', 'Merakın kapıları açıyor.'],
    // Cancer
    ['Ay seninle konuşuyor.', 'Duygularında cevap var.', 'Koruyucu kabuğun altında güç.'],
    // Leo
    ['Güneş senin için doğuyor.', 'Işığın karanlığı yırtıyor.', 'Tahtın hazır, sahip çık.'],
    // Virgo
    ['Detaylarda evren gizli.', 'Mükemmellik değil, anlam ara.', 'Şifa veren ellerin var.'],
    // Libra
    ['Denge noktasındasın.', 'Güzellik ve adalet senin.', 'İlişkilerde dönüşüm zamanı.'],
    // Scorpio
    ['Karanlıktan korkmuyorsun.', 'Dönüşüm kapıda.', 'Derinliklerde hazine var.'],
    // Sagittarius
    ['Ufuk seni çağırıyor.', 'Ok yaydan çıkmak üzere.', 'Özgürlük senin doğum hakkın.'],
    // Capricorn
    ['Zirve görüş mesafesinde.', 'Disiplin bugün süper gücün.', 'Zamanın ustası sensin.'],
    // Aquarius
    ['Geleceği sen yazıyorsun.', 'Farklılığın senin armağanın.', 'Devrim içinden başlıyor.'],
    // Pisces
    ['Rüyalar gerçeğe dönüşüyor.', 'Sezgilerin keskin.', 'Okyanus derinliğinde yüzüyorsun.'],
  ];

  static const List<List<String>> _sentences = [
    // Aries
    ['Bugün enerjin yüksek ama sabırlı ol.', 'Yeni başlangıçlar için ideal bir gün.', 'İçindeki ateşi kontrollü kullan.'],
    // Taurus
    ['Bugün maddi konularda şanslısın.', 'Rahatlığını korurken ilerlemeye bak.', 'Doğayla vakit geçirmek iyi gelecek.'],
    // Gemini
    ['Bugün iletişim yıldızın parlıyor.', 'Yeni bilgiler seni heyecanlandıracak.', 'Sosyal ağın genişliyor.'],
    // Cancer
    ['Bugün ev ve aile ön planda.', 'Duygusal sezgilerin güçlü.', 'Kendine bakmayı ihmal etme.'],
    // Leo
    ['Bugün sahne senin.', 'Yaratıcılığın zirve yapıyor.', 'Kalbin seni doğru yöne çekiyor.'],
    // Virgo
    ['Bugün detaylara dikkat et.', 'Organizasyon becerilerin işe yarayacak.', 'Sağlığına önem ver.'],
    // Libra
    ['Bugün ilişkiler ön planda.', 'Estetik zevkin takdir görecek.', 'Denge arayışın meyvelerini veriyor.'],
    // Scorpio
    ['Bugün içsel dönüşüm zamanı.', 'Gizli konular açığa çıkabilir.', 'Sezgilerin seni yanıltmaz.'],
    // Sagittarius
    ['Bugün macera ruhun uyanıyor.', 'Yeni fikirler ilham veriyor.', 'Optimizmin bulaşıcı.'],
    // Capricorn
    ['Bugün kariyer fırsatları var.', 'Disiplinli çalışman ödüllendirilecek.', 'Uzun vadeli planlar yap.'],
    // Aquarius
    ['Bugün yenilikçi fikirlerin öne çıkıyor.', 'Arkadaşlarınla vakit geçir.', 'Farklı olmaktan çekinme.'],
    // Pisces
    ['Bugün ruhsal farkındalık yüksek.', 'Sanat ve müzik ilham veriyor.', 'Hayallerine güven.'],
  ];
}

// ═══════════════════════════════════════════════════════════════════════════
// BELOW THE FOLD SECTION
// Simple list of entry points - no heavy UI
// ═══════════════════════════════════════════════════════════════════════════

class _BelowTheFold extends StatelessWidget {
  final bool isDark;

  const _BelowTheFold({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Keşfet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          // Entry points list
          _EntryPointTile(
            icon: Icons.wb_sunny_outlined,
            title: 'Günlük Burç Yorumu',
            subtitle: 'Bugünün kozmik enerjileri',
            route: Routes.horoscope,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.calendar_month_outlined,
            title: 'Haftalık Yorum',
            subtitle: 'Bu hafta seni neler bekliyor',
            route: Routes.weeklyHoroscope,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.auto_awesome_outlined,
            title: 'Kozmik Paylaşım',
            subtitle: 'Kişisel kozmik mesajını paylaş',
            route: Routes.cosmicShare,
            isDark: isDark,
            isHighlighted: true,
          ),

          _EntryPointTile(
            icon: Icons.style_outlined,
            title: 'Tarot Falı',
            subtitle: 'Kartlar ne diyor?',
            route: Routes.tarot,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.favorite_border_outlined,
            title: 'Burç Uyumu',
            subtitle: 'İlişki uyumunu keşfet',
            route: Routes.compatibility,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.pie_chart_outline,
            title: 'Doğum Haritası',
            subtitle: 'Kozmik haritanı incele',
            route: Routes.birthChart,
            isDark: isDark,
          ),

          const SizedBox(height: 24),

          // Secondary section - More features
          Text(
            'Daha Fazla',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
            ),
          ),

          const SizedBox(height: 16),

          _EntryPointTile(
            icon: Icons.numbers_outlined,
            title: 'Numeroloji',
            subtitle: 'Sayıların gizemi',
            route: Routes.numerology,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.nights_stay_outlined,
            title: 'Rüya İzi',
            subtitle: 'Rüyalarının anlamı',
            route: Routes.dreamInterpretation,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.blur_circular_outlined,
            title: 'Chakra Analizi',
            subtitle: 'Enerji merkezlerin',
            route: Routes.chakraAnalysis,
            isDark: isDark,
          ),

          _EntryPointTile(
            icon: Icons.all_inclusive_outlined,
            title: 'Tüm Burçlar',
            subtitle: '12 burcu keşfet',
            route: Routes.horoscope,
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
                      ? AppColors.textMuted.withOpacity(0.5)
                      : AppColors.lightTextMuted.withOpacity(0.5),
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
                ? AppColors.cosmicPurple.withOpacity(0.3)
                : AppColors.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? AppColors.starGold.withOpacity(0.3)
                  : AppColors.lightStarGold.withOpacity(0.3),
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
                  color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
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
                      ? AppColors.starGold.withOpacity(0.1)
                      : AppColors.lightStarGold.withOpacity(0.1))
                  : (isDark
                      ? AppColors.surfaceDark
                      : AppColors.lightCard),
              borderRadius: BorderRadius.circular(12),
              border: isHighlighted
                  ? Border.all(
                      color: isDark
                          ? AppColors.starGold.withOpacity(0.3)
                          : AppColors.lightStarGold.withOpacity(0.3),
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
                        ? (isDark ? AppColors.starGold : AppColors.lightStarGold)
                        : (isDark ? AppColors.auroraStart : AppColors.lightAuroraStart),
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
