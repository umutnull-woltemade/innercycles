import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/routes.dart';
import '../../data/providers/app_providers.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/horoscope/presentation/horoscope_screen.dart';
import '../../features/horoscope/presentation/horoscope_detail_screen.dart';
import '../../features/compatibility/presentation/compatibility_screen.dart';
import '../../features/natal_chart/presentation/natal_chart_screen.dart';
import '../../features/numerology/presentation/numerology_screen.dart';
import '../../features/kabbalah/presentation/kabbalah_screen.dart';
import '../../features/tarot/presentation/tarot_screen.dart';
import '../../features/aura/presentation/aura_screen.dart';
import '../../features/transits/presentation/transits_screen.dart';
import '../../features/premium/presentation/premium_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/share/presentation/share_summary_screen.dart';
import '../../features/horoscopes/presentation/weekly_horoscope_screen.dart';
import '../../features/horoscopes/presentation/monthly_horoscope_screen.dart';
import '../../features/horoscopes/presentation/yearly_horoscope_screen.dart';
import '../../features/horoscopes/presentation/love_horoscope_screen.dart';
import '../../features/horoscopes/presentation/eclipse_calendar_screen.dart';
import '../../features/compatibility/presentation/composite_chart_screen.dart';
import '../../features/vedic/presentation/vedic_chart_screen.dart';
import '../../features/predictive/presentation/progressions_screen.dart';
import '../../features/astrocartography/presentation/astrocartography_screen.dart';
import '../../features/electional/presentation/electional_screen.dart';
import '../../features/draconic/presentation/draconic_chart_screen.dart';
import '../../features/asteroids/presentation/asteroids_screen.dart';
import '../../features/glossary/presentation/glossary_screen.dart';
import '../../features/gardening/presentation/gardening_moon_screen.dart';
import '../../features/celebrities/presentation/celebrities_screen.dart';
import '../../features/articles/presentation/articles_screen.dart';
import '../../features/local_space/presentation/local_space_screen.dart';
import '../../features/saturn_return/presentation/saturn_return_screen.dart';
import '../../features/solar_return/presentation/solar_return_screen.dart';
import '../../features/year_ahead/presentation/year_ahead_screen.dart';
import '../../features/timing/presentation/timing_screen.dart';
import '../../features/synastry/presentation/synastry_screen.dart';
import '../../features/transits/presentation/transit_calendar_screen.dart';
import '../../features/rituals/presentation/daily_rituals_screen.dart';
import '../../features/chakra/presentation/chakra_analysis_screen.dart';
import '../../features/profile/presentation/saved_profiles_screen.dart';
import '../../features/profile/presentation/comparison_screen.dart';
import '../../features/kozmoz/presentation/kozmoz_screen.dart';
import '../../features/cosmic_discovery/presentation/cosmic_discovery_screen.dart';
import '../../features/dreams/presentation/dream_interpretation_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    errorBuilder: (context, state) => _NotFoundScreen(path: state.uri.path),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.horoscope,
        builder: (context, state) => const HoroscopeScreen(),
      ),
      GoRoute(
        path: Routes.horoscopeDetail,
        builder: (context, state) {
          final sign = state.pathParameters['sign'] ?? 'aries';
          return HoroscopeDetailScreen(signName: sign);
        },
      ),
      GoRoute(
        path: Routes.compatibility,
        builder: (context, state) => const CompatibilityScreen(),
      ),
      GoRoute(
        path: Routes.birthChart,
        builder: (context, state) => const NatalChartScreen(),
      ),
      GoRoute(
        path: Routes.numerology,
        builder: (context, state) => const NumerologyScreen(),
      ),
      GoRoute(
        path: Routes.kabbalah,
        builder: (context, state) => const KabbalahScreen(),
      ),
      GoRoute(
        path: Routes.tarot,
        builder: (context, state) => const TarotScreen(),
      ),
      GoRoute(
        path: Routes.aura,
        builder: (context, state) => const AuraScreen(),
      ),
      GoRoute(
        path: Routes.transits,
        builder: (context, state) => const TransitsScreen(),
      ),
      GoRoute(
        path: Routes.premium,
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.shareSummary,
        builder: (context, state) => const ShareSummaryScreen(),
      ),
      // Extended Horoscopes
      GoRoute(
        path: Routes.weeklyHoroscope,
        builder: (context, state) => const WeeklyHoroscopeScreen(),
      ),
      GoRoute(
        path: Routes.weeklyHoroscopeDetail,
        builder: (context, state) {
          final sign = state.pathParameters['sign'] ?? 'aries';
          return WeeklyHoroscopeScreen(signName: sign);
        },
      ),
      GoRoute(
        path: Routes.monthlyHoroscope,
        builder: (context, state) => const MonthlyHoroscopeScreen(),
      ),
      GoRoute(
        path: Routes.monthlyHoroscopeDetail,
        builder: (context, state) {
          final sign = state.pathParameters['sign'] ?? 'aries';
          return MonthlyHoroscopeScreen(signName: sign);
        },
      ),
      GoRoute(
        path: Routes.yearlyHoroscope,
        builder: (context, state) => const YearlyHoroscopeScreen(),
      ),
      GoRoute(
        path: Routes.yearlyHoroscopeDetail,
        builder: (context, state) {
          final sign = state.pathParameters['sign'] ?? 'aries';
          return YearlyHoroscopeScreen(signName: sign);
        },
      ),
      GoRoute(
        path: Routes.loveHoroscope,
        builder: (context, state) => const LoveHoroscopeScreen(),
      ),
      GoRoute(
        path: Routes.loveHoroscopeDetail,
        builder: (context, state) {
          final sign = state.pathParameters['sign'] ?? 'aries';
          return LoveHoroscopeScreen(signName: sign);
        },
      ),
      GoRoute(
        path: Routes.eclipseCalendar,
        builder: (context, state) => const EclipseCalendarScreen(),
      ),
      // Advanced Astrology
      GoRoute(
        path: Routes.compositeChart,
        builder: (context, state) => const CompositeChartScreen(),
      ),
      GoRoute(
        path: Routes.vedicChart,
        builder: (context, state) => const VedicChartScreen(),
      ),
      GoRoute(
        path: Routes.progressions,
        builder: (context, state) => const ProgressionsScreen(),
      ),
      GoRoute(
        path: Routes.saturnReturn,
        builder: (context, state) => const SaturnReturnScreen(),
      ),
      GoRoute(
        path: Routes.solarReturn,
        builder: (context, state) => const SolarReturnScreen(),
      ),
      GoRoute(
        path: Routes.yearAhead,
        builder: (context, state) => const YearAheadScreen(),
      ),
      GoRoute(
        path: Routes.timing,
        builder: (context, state) => const TimingScreen(),
      ),
      GoRoute(
        path: Routes.synastry,
        builder: (context, state) => const SynastryScreen(),
      ),
      // Premium Features
      GoRoute(
        path: Routes.astroCartography,
        builder: (context, state) => const AstroCartographyScreen(),
      ),
      GoRoute(
        path: Routes.electional,
        builder: (context, state) => const ElectionalScreen(),
      ),
      GoRoute(
        path: Routes.draconicChart,
        builder: (context, state) => const DraconicChartScreen(),
      ),
      GoRoute(
        path: Routes.asteroids,
        builder: (context, state) => const AsteroidsScreen(),
      ),
      GoRoute(
        path: Routes.localSpace,
        builder: (context, state) => const LocalSpaceScreen(),
      ),
      // Reference & Content
      GoRoute(
        path: Routes.glossary,
        builder: (context, state) {
          final searchQuery = state.uri.queryParameters['search'];
          return GlossaryScreen(initialSearch: searchQuery);
        },
      ),
      GoRoute(
        path: Routes.gardeningMoon,
        builder: (context, state) => const GardeningMoonScreen(),
      ),
      GoRoute(
        path: Routes.celebrities,
        builder: (context, state) => const CelebritiesScreen(),
      ),
      GoRoute(
        path: Routes.articles,
        builder: (context, state) => const ArticlesScreen(),
      ),
      // New Features
      GoRoute(
        path: Routes.transitCalendar,
        builder: (context, state) => const TransitCalendarScreen(),
      ),
      // Spiritual & Wellness
      GoRoute(
        path: Routes.dailyRituals,
        builder: (context, state) => const DailyRitualsScreen(),
      ),
      GoRoute(
        path: Routes.chakraAnalysis,
        builder: (context, state) => const ChakraAnalysisScreen(),
      ),
      GoRoute(
        path: Routes.crystalGuide,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Kristal Rehberi',
          subtitle: 'Şifalı taşların enerjisi',
          emoji: '💎',
          primaryColor: Color(0xFF9D4EDD),
          type: CosmicDiscoveryType.auraColor,
        ),
      ),
      GoRoute(
        path: Routes.moonRituals,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Ay Ritüelleri',
          subtitle: 'Ayın döngüsüyle uyum',
          emoji: '🌕',
          primaryColor: Color(0xFFC0C0C0),
          type: CosmicDiscoveryType.moonEnergy,
        ),
      ),
      GoRoute(
        path: Routes.dreamInterpretation,
        builder: (context, state) => const DreamInterpretationScreen(),
      ),
      // Profile Management
      GoRoute(
        path: Routes.savedProfiles,
        builder: (context, state) => const SavedProfilesScreen(),
      ),
      GoRoute(
        path: Routes.comparison,
        builder: (context, state) => const ComparisonScreen(),
      ),
      // Kozmoz - Tüm özellikler
      GoRoute(
        path: Routes.kozmoz,
        builder: (context, state) => const KozmozScreen(),
      ),

      // ════════════════════════════════════════════════════════════════
      // KOZMİK KEŞİF - Viral & Felsefi İçerikler (Özel Ekranlar)
      // ════════════════════════════════════════════════════════════════

      // Günlük Enerjiler
      GoRoute(
        path: Routes.dailySummary,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Bugünün Özeti',
          subtitle: 'Kozmik enerjilerin günlük rehberin',
          emoji: '☀️',
          primaryColor: Color(0xFFFFD700),
          type: CosmicDiscoveryType.dailySummary,
        ),
      ),
      GoRoute(
        path: Routes.moonEnergy,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Ay Enerjisi',
          subtitle: 'Ayın bugünkü mesajı',
          emoji: '🌙',
          primaryColor: Color(0xFFC0C0C0),
          type: CosmicDiscoveryType.moonEnergy,
        ),
      ),
      GoRoute(
        path: Routes.loveEnergy,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Aşk Enerjisi',
          subtitle: 'Kalbinin kozmik rehberi',
          emoji: '💕',
          primaryColor: Color(0xFFFF6B9D),
          type: CosmicDiscoveryType.loveEnergy,
        ),
      ),
      GoRoute(
        path: Routes.abundanceEnergy,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Bolluk Enerjisi',
          subtitle: 'Bereketin kaynağını keşfet',
          emoji: '💰',
          primaryColor: Color(0xFF50C878),
          type: CosmicDiscoveryType.abundanceEnergy,
        ),
      ),

      // Ruhsal Dönüşüm & Hayat Amacı
      GoRoute(
        path: Routes.spiritualTransformation,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Ruhsal Dönüşüm',
          subtitle: 'İçsel yolculuğunun haritası',
          emoji: '🦋',
          primaryColor: Color(0xFF9D4EDD),
          type: CosmicDiscoveryType.spiritualTransformation,
        ),
      ),
      GoRoute(
        path: Routes.lifePurpose,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Hayat Amacın',
          subtitle: 'Neden burada olduğunu keşfet',
          emoji: '🎯',
          primaryColor: Color(0xFFE91E63),
          type: CosmicDiscoveryType.lifePurpose,
        ),
      ),
      GoRoute(
        path: Routes.subconsciousPatterns,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Bilinçaltı Kalıpların',
          subtitle: 'Gizli programlarını çöz',
          emoji: '🧠',
          primaryColor: Color(0xFF00BCD4),
          type: CosmicDiscoveryType.subconsciousPatterns,
        ),
      ),
      GoRoute(
        path: Routes.karmaLessons,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Karma Derslerin',
          subtitle: 'Ruhunun öğrenmesi gerekenler',
          emoji: '⚖️',
          primaryColor: Color(0xFFFF9800),
          type: CosmicDiscoveryType.karmaLessons,
        ),
      ),
      GoRoute(
        path: Routes.soulContract,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Ruh Sözleşmen',
          subtitle: 'Doğmadan önce yaptığın anlaşma',
          emoji: '📜',
          primaryColor: Color(0xFFD4AF37),
          type: CosmicDiscoveryType.soulContract,
        ),
      ),
      GoRoute(
        path: Routes.innerPower,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'İçsel Gücün',
          subtitle: 'Süper güçlerini aktive et',
          emoji: '⚡',
          primaryColor: Color(0xFFFFD700),
          type: CosmicDiscoveryType.innerPower,
        ),
      ),

      // Kişilik Analizleri
      GoRoute(
        path: Routes.shadowSelf,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Gölge Benliğin',
          subtitle: 'Karanlık tarafınla tanış',
          emoji: '🌑',
          primaryColor: Color(0xFF37474F),
          type: CosmicDiscoveryType.shadowSelf,
        ),
      ),
      GoRoute(
        path: Routes.leadershipStyle,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Liderlik Stilin',
          subtitle: 'Nasıl bir lider olduğunu keşfet',
          emoji: '👑',
          primaryColor: Color(0xFFFFD700),
          type: CosmicDiscoveryType.leadershipStyle,
        ),
      ),
      GoRoute(
        path: Routes.heartbreak,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Kalp Yaran',
          subtitle: 'Aşkta hassas noktaların',
          emoji: '💔',
          primaryColor: Color(0xFFE91E63),
          type: CosmicDiscoveryType.heartbreak,
        ),
      ),
      GoRoute(
        path: Routes.redFlags,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Red Flag\'lerin',
          subtitle: 'Dikkat etmen gereken yönlerin',
          emoji: '🚩',
          primaryColor: Color(0xFFB71C1C),
          type: CosmicDiscoveryType.redFlags,
        ),
      ),
      GoRoute(
        path: Routes.greenFlags,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Green Flag\'lerin',
          subtitle: 'Harika özelliklerini keşfet',
          emoji: '💚',
          primaryColor: Color(0xFF4CAF50),
          type: CosmicDiscoveryType.greenFlags,
        ),
      ),
      GoRoute(
        path: Routes.flirtStyle,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Flört Stilin',
          subtitle: 'Nasıl baştan çıkardığını öğren',
          emoji: '😏',
          primaryColor: Color(0xFFFF6B9D),
          type: CosmicDiscoveryType.flirtStyle,
        ),
      ),

      // Mistik Keşifler
      GoRoute(
        path: Routes.tarotCard,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Tarot Kartın',
          subtitle: 'Ruhunu temsil eden kart',
          emoji: '🃏',
          primaryColor: Color(0xFF9C27B0),
          type: CosmicDiscoveryType.tarotCard,
        ),
      ),
      GoRoute(
        path: Routes.auraColor,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Aura Rengin',
          subtitle: 'Enerji alanının rengi',
          emoji: '🌈',
          primaryColor: Color(0xFF00BCD4),
          type: CosmicDiscoveryType.auraColor,
        ),
      ),
      GoRoute(
        path: Routes.chakraBalance,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Çakra Dengen',
          subtitle: 'Enerji merkezlerinin durumu',
          emoji: '🔮',
          primaryColor: Color(0xFF673AB7),
          type: CosmicDiscoveryType.chakraBalance,
        ),
      ),
      GoRoute(
        path: Routes.lifeNumber,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Yaşam Sayın',
          subtitle: 'Numerolojik kaderini keşfet',
          emoji: '🔢',
          primaryColor: Color(0xFFFFD700),
          type: CosmicDiscoveryType.lifeNumber,
        ),
      ),
      GoRoute(
        path: Routes.kabbalaPath,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Kabala Yolun',
          subtitle: 'Hayat ağacındaki yerin',
          emoji: '✡️',
          primaryColor: Color(0xFF3F51B5),
          type: CosmicDiscoveryType.kabbalaPath,
        ),
      ),

      // Zaman & Döngüler
      GoRoute(
        path: Routes.saturnLessons,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Saturn Derslerin',
          subtitle: 'Olgunlaşma yolculuğun',
          emoji: '🪐',
          primaryColor: Color(0xFF795548),
          type: CosmicDiscoveryType.saturnLessons,
        ),
      ),
      GoRoute(
        path: Routes.birthdayEnergy,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Doğum Günü Enerjin',
          subtitle: 'Solar return\'ün mesajı',
          emoji: '🎂',
          primaryColor: Color(0xFFE91E63),
          type: CosmicDiscoveryType.birthdayEnergy,
        ),
      ),
      GoRoute(
        path: Routes.eclipseEffect,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Tutulma Etkisi',
          subtitle: 'Tutulmaların sana etkisi',
          emoji: '🌒',
          primaryColor: Color(0xFF212121),
          type: CosmicDiscoveryType.eclipseEffect,
        ),
      ),
      GoRoute(
        path: Routes.transitFlow,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Transit Akışı',
          subtitle: 'Gezegen geçişlerinin etkisi',
          emoji: '🌊',
          primaryColor: Color(0xFF2196F3),
          type: CosmicDiscoveryType.transitFlow,
        ),
      ),

      // İlişki Analizleri
      GoRoute(
        path: Routes.compatibilityAnalysis,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Uyum Analizi',
          subtitle: 'İlişki potansiyelini keşfet',
          emoji: '💞',
          primaryColor: Color(0xFFE91E63),
          type: CosmicDiscoveryType.compatibilityAnalysis,
        ),
      ),
      GoRoute(
        path: Routes.soulMate,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Ruh Eşin',
          subtitle: 'Kozmik eşini tanımla',
          emoji: '👫',
          primaryColor: Color(0xFFFF6B9D),
          type: CosmicDiscoveryType.soulMate,
        ),
      ),
      GoRoute(
        path: Routes.relationshipKarma,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'İlişki Karman',
          subtitle: 'İlişkilerindeki karma kalıplar',
          emoji: '🔄',
          primaryColor: Color(0xFF9C27B0),
          type: CosmicDiscoveryType.relationshipKarma,
        ),
      ),
      GoRoute(
        path: Routes.celebrityTwin,
        builder: (context, state) => const CosmicDiscoveryScreen(
          title: 'Ünlü İkizin',
          subtitle: 'Hangi ünlüyle aynı enerjidesin?',
          emoji: '⭐',
          primaryColor: Color(0xFFFFD700),
          type: CosmicDiscoveryType.celebrityTwin,
        ),
      ),
    ],
  );
});

class _NotFoundScreen extends StatelessWidget {
  final String path;

  const _NotFoundScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🔮',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 24),
                Text(
                  '404',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: const Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sayfa Bulunamadı',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aradığınız sayfa yıldızlarda kaybolmuş görünüyor.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Aranan: $path',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white38,
                        fontFamily: 'monospace',
                      ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.go(Routes.home),
                  icon: const Icon(Icons.home),
                  label: const Text('Ana Sayfaya Dön'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: const Color(0xFF0D0D1A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go(Routes.horoscope),
                  child: const Text(
                    'Burç Yorumlarına Git',
                    style: TextStyle(color: Color(0xFFFFD700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashScreen extends ConsumerStatefulWidget {
  const _SplashScreen();

  @override
  ConsumerState<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final onboardingComplete = ref.read(onboardingCompleteProvider);
    final userProfile = ref.read(userProfileProvider);

    // Require BOTH onboarding complete AND valid user profile with name
    final hasValidProfile = userProfile != null &&
        userProfile.name != null &&
        userProfile.name!.isNotEmpty;

    if (onboardingComplete && hasValidProfile) {
      context.go(Routes.home);
    } else {
      context.go(Routes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '✨',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 24),
            Text(
              'Astrobobo',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: const Color(0xFFFFD700),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
