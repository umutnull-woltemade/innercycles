import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/zodiac_sign.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/moon_service.dart';
import '../../../data/services/l10n_service.dart';

/// SCREENSHOT SHARE SCREEN - Instagram Story Optimized
///
/// DESIGN PRINCIPLES:
/// - TEK FULLSCREEN GÖRSEL - kullanıcı screenshot alacak
/// - STRICT 9:16 aspect ratio - Instagram Story safe area
/// - CAPTURE MODE - Hide system UI for clean screenshots
/// - NO SCROLL - everything fits in one view
/// - Mobile-first, performans odaklı
///
/// STORY-SAFE ZONES:
/// - Top 14%: Instagram UI overlay zone (avoid text)
/// - Middle 72%: Safe content area
/// - Bottom 14%: Instagram UI overlay zone (avoid text)
///
/// KULLANIM:
/// context.push('/share') veya context.push(Routes.shareSummary)
class ScreenshotShareScreen extends ConsumerStatefulWidget {
  const ScreenshotShareScreen({super.key});

  @override
  ConsumerState<ScreenshotShareScreen> createState() => _ScreenshotShareScreenState();
}

class _ScreenshotShareScreenState extends ConsumerState<ScreenshotShareScreen> {
  @override
  void initState() {
    super.initState();
    // CAPTURE MODE: Enter immersive mode for clean screenshots
    _enterCaptureMode();
  }

  @override
  void dispose() {
    // CAPTURE MODE: Restore system UI on exit
    _exitCaptureMode();
    super.dispose();
  }

  void _enterCaptureMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
    // Lock to portrait for consistent screenshots
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _exitCaptureMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);
    final sign = userProfile?.sunSign ?? ZodiacSign.aries;
    final userName = userProfile?.name ?? sign.localizedName(language);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: GestureDetector(
        // Tap anywhere to show/hide exit button temporarily
        onTap: () => _showExitHint(context, language),
        child: Stack(
          children: [
            // ════════════════════════════════════════════════════════════
            // FULLSCREEN 9:16 SHARE IMAGE - NO SAFE AREA (capture mode)
            // ════════════════════════════════════════════════════════════
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: _ShareImageCard(
                    sign: sign,
                    userName: userName,
                    language: language,
                  ),
                ),
              ),
            ),

            // ════════════════════════════════════════════════════════════
            // EXIT BUTTON - Semi-transparent, minimal (outside capture area)
            // ════════════════════════════════════════════════════════════
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  _exitCaptureMode();
                  context.pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white60,
                    size: 24,
                  ),
                ),
              ),
            ),

            // ════════════════════════════════════════════════════════════
            // SCREENSHOT HINT (Bottom, outside capture area)
            // ════════════════════════════════════════════════════════════
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.screenshot_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          L10nService.get('share.take_screenshot_and_share', language),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitHint(BuildContext context, AppLanguage language) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10nService.get('share.tap_x_to_exit', language)),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// SHARE IMAGE CARD - STORY-SAFE LAYOUT
///
/// Instagram Story Safe Zones:
/// ┌─────────────────────┐
/// │░░░ TOP 14% ░░░░░░░░░│ ← Instagram UI (username, close button)
/// ├─────────────────────┤
/// │                     │
/// │   SAFE CONTENT      │ ← 72% middle - all important content here
/// │      AREA           │
/// │                     │
/// ├─────────────────────┤
/// │░░░ BOTTOM 14% ░░░░░░│ ← Instagram UI (reply, share buttons)
/// └─────────────────────┘
///
/// Text Rules:
/// - User name: max 20 chars, truncate with "..."
/// - Headline: max 50 chars, 2 lines max
/// - Quote: max 80 chars, 2 lines max
/// ═══════════════════════════════════════════════════════════════════════════
class _ShareImageCard extends StatelessWidget {
  final ZodiacSign sign;
  final String userName;
  final AppLanguage language;

  const _ShareImageCard({
    required this.sign,
    required this.userName,
    required this.language,
  });

  // Truncation helpers
  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  @override
  Widget build(BuildContext context) {
    final content = _getCosmicContent(sign, language);
    final moonPhase = MoonService.getCurrentPhase(DateTime.now());

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0D0D1A),
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
            const Color(0xFF0D0D1A),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Column(
        children: [
          // ═══════════════════════════════════════════════════════════════
          // TOP 14% - SAFE ZONE (minimal content, Instagram UI overlay)
          // ═══════════════════════════════════════════════════════════════
          Expanded(
            flex: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Opacity(
                  opacity: 0.4,
                  child: Text(
                    '✧ venusone ✧',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ═══════════════════════════════════════════════════════════════
          // MIDDLE 72% - SAFE CONTENT AREA (all important content)
          // ═══════════════════════════════════════════════════════════════
          Expanded(
            flex: 72,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SECTION 1: Sign Identity
                  Column(
                    children: [
                      // Sign Symbol
                      Text(
                        sign.symbol,
                        style: TextStyle(
                          fontSize: 52,
                          color: sign.color,
                          shadows: [
                            Shadow(
                              color: sign.color.withValues(alpha: 0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Sign Name
                      Text(
                        sign.localizedName(language).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Date & Moon
                      Text(
                        '${_formatDate(DateTime.now(), language)} • ${moonPhase.emoji}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),

                  // SECTION 2: Cosmic Headline
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: sign.color.withValues(alpha: 0.3), width: 1),
                        bottom: BorderSide(color: sign.color.withValues(alpha: 0.3), width: 1),
                      ),
                    ),
                    child: Text(
                      _truncate(content.headline.toUpperCase(), 50),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.starGold,
                        height: 1.3,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // SECTION 3: Quote
                  Text(
                    '"${_truncate(content.quote, 80)}"',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),

                  // SECTION 4: Energy Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        L10nService.get('share.energy', language),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildEnergyBar(content.energy),
                      const SizedBox(width: 10),
                      Text(
                        '${content.energy}%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.starGold,
                        ),
                      ),
                    ],
                  ),

                  // SECTION 5: Shadow & Light Pills
                  Column(
                    children: [
                      _buildShadowLightPill(
                        '🌑',
                        content.shadow,
                        Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      _buildShadowLightPill(
                        '✨',
                        content.light,
                        AppColors.starGold,
                      ),
                    ],
                  ),

                  // SECTION 6: Micro Message
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '"${_truncate(content.microMessage, 60)}"',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ═══════════════════════════════════════════════════════════════
          // BOTTOM 14% - SAFE ZONE (minimal content, Instagram UI overlay)
          // ═══════════════════════════════════════════════════════════════
          Expanded(
            flex: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'venusone.com',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.3),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyBar(int energy) {
    return Container(
      width: 100,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white.withValues(alpha: 0.1),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: energy / 100,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              colors: [
                AppColors.starGold,
                AppColors.celestialGold,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShadowLightPill(String emoji, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, AppLanguage language) {
    final months = L10nService.getList('share.months', language);
    if (months.isEmpty) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Get cosmic content for the sign (deterministic based on day)
  _CosmicContent _getCosmicContent(ZodiacSign sign, AppLanguage language) {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;

    // Get localized content for the sign
    final signKey = sign.name.toLowerCase();
    final headlines = L10nService.getList('share.headlines.$signKey', language);
    final quotes = L10nService.getList('share.quotes.$signKey', language);
    final microMessages = L10nService.getList('share.micro_messages.$signKey', language);
    final shadows = L10nService.getList('share.shadows.$signKey', language);
    final lights = L10nService.getList('share.lights.$signKey', language);

    // Fallback to static content if localization not available
    final headlineList = headlines.isNotEmpty ? headlines : _headlines[sign.index];
    final quoteList = quotes.isNotEmpty ? quotes : _quotes[sign.index];
    final microMessageList = microMessages.isNotEmpty ? microMessages : _microMessages[sign.index];
    final shadowList = shadows.isNotEmpty ? shadows : _shadows[sign.index];
    final lightList = lights.isNotEmpty ? lights : _lights[sign.index];

    final seed = (dayOfYear + sign.index) % headlineList.length;

    return _CosmicContent(
      headline: headlineList[seed],
      quote: quoteList[seed % quoteList.length],
      energy: 60 + ((dayOfYear + sign.index * 7) % 35), // 60-94
      microMessage: microMessageList[seed % microMessageList.length],
      shadow: shadowList[seed % shadowList.length],
      light: lightList[seed % lightList.length],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTENT DATA (Turkish)
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<List<String>> _headlines = [
    // Aries / Koç
    ['Bugün cesaretin test ediliyor.', 'Ateşin içinden geçme zamanı.', 'Liderlik enerjin yükseliyor.'],
    // Taurus / Boğa
    ['Köklerin seni taşıyor.', 'Sabır bugün en büyük gücün.', 'Değerini bil, taviz verme.'],
    // Gemini / İkizler
    ['İki dünya arasında dans ediyorsun.', 'Kelimeler bugün silahın.', 'Merakın kapıları açıyor.'],
    // Cancer / Yengeç
    ['Ay seninle konuşuyor.', 'Duygularında cevap var.', 'Koruyucu kabuğun altında güç.'],
    // Leo / Aslan
    ['Güneş senin için doğuyor.', 'Işığın karanlığı yırtıyor.', 'Tahtın hazır, sahip çık.'],
    // Virgo / Başak
    ['Detaylarda evren gizli.', 'Mükemmellik değil, anlam ara.', 'Şifa veren ellerin var.'],
    // Libra / Terazi
    ['Denge noktasındasın.', 'Güzellik ve adalet senin.', 'İlişkilerde dönüşüm zamanı.'],
    // Scorpio / Akrep
    ['Karanlıktan korkmuyorsun.', 'Dönüşüm temaları öne çıkıyor.', 'Derinliklerde hazine var.'],
    // Sagittarius / Yay
    ['Ufuk seni çağırıyor.', 'Ok yaydan çıkmak üzere.', 'Özgürlük senin doğum hakkın.'],
    // Capricorn / Oğlak
    ['Zirve görüş mesafesinde.', 'Disiplin bugün süper gücün.', 'Zamanın ustası sensin.'],
    // Aquarius / Kova
    ['Geleceği sen yazıyorsun.', 'Farklılığın senin armağanın.', 'Devrim içinden başlıyor.'],
    // Pisces / Balık
    ['Rüyalar gerçeğe dönüşüyor.', 'Sezgilerin keskin.', 'Okyanus derinliğinde yüzüyorsun.'],
  ];

  static const List<List<String>> _quotes = [
    // Aries
    ['Beklemek bitsin, harekete geçme zamanı.', 'Korkuyla değil, güvenle ilerle.', 'İlk adımı atan kazanır.'],
    // Taurus
    ['Bırakmak bazen sahiplenmektir.', 'Değişim düşman değil, davet.', 'Köklerin sağlam, dalların özgür.'],
    // Gemini
    ['Her düşünceni takip etmek zorunda değilsin.', 'Sessizlik de bir cevap.', 'İki yol varsa, üçüncüsünü bul.'],
    // Cancer
    ['Kırılganlık zayıflık değil.', 'Geçmiş öğretmen, ev değil.', 'Kendini sevmek için izin al.'],
    // Leo
    ['Alkış olmadan da değerlisin.', 'Işığın başkalarını aydınlatıyor.', 'Kalbin pusulan olsun.'],
    // Virgo
    ['Kusursuz değil, gerçek ol.', 'Detaylar önemli ama bütün daha önemli.', 'Yardım istemek güçtür.'],
    // Libra
    ['Hayır demek de sevgi.', 'Dengeyi kendinde bul.', 'Güzellik içinden başlar.'],
    // Scorpio
    ['Kontrol illüzyon.', 'Güvenmek risk değil, hediye.', 'Karanlık, ışığı tanımlar.'],
    // Sagittarius
    ['Kaçış çözüm değil, keşif.', 'Cevap burada da olabilir.', 'Özgürlük sorumlulukla gelir.'],
    // Capricorn
    ['Başarı mutluluk garantisi değil.', 'Mola vermek vazgeçmek değil.', 'Zirve yolculuktur, varış değil.'],
    // Aquarius
    ['Farklı olmak için farklı olma.', 'Kalp de akıl kadar önemli.', 'Devrim önce kendinde.'],
    // Pisces
    ['Rüya güzel, gerçeklik de.', 'Sınırlar sevgisizlik değil.', 'Hayal et ama yap da.'],
  ];

  static const List<List<String>> _microMessages = [
    // Aries
    ['Sessizliğin bazen en güçlü cevaptır.', 'Herkes senin enerjine erişmeyi hak etmiyor.', 'Sabır en keskin silahın.'],
    // Taurus
    ['Değişimden korkma, onu yönet.', 'Konfor alanın hapishane olmasın.', 'Esneklik de güçtür.'],
    // Gemini
    ['Çelişkilerin seni zenginleştiriyor.', 'Odaklan, dağılma.', 'Derinlik, genişlikten değerlidir.'],
    // Cancer
    ['Sevilmek için mükemmel olmana gerek yok.', 'Duvarlar korumaz, hapseder.', 'Geçmişi bırak, şimdiye dön.'],
    // Leo
    ['Görünmez olduğunda kim oluyorsun?', 'Ego değil, özgüven.', 'Işık paylaşınca çoğalır.'],
    // Virgo
    ['Büyük resmi gör.', 'Hata yapmak öğrenmektir.', 'Kendine de şefkatli ol.'],
    // Libra
    ['Kararsızlık da bir karar.', 'Herkes mutlu olamaz, sen de dahil.', 'Kendi seçimlerini yap.'],
    // Scorpio
    ['Affetmek seni özgürleştirir.', 'Her şeyi bilmek zorunda değilsin.', 'Güven, kontrolden değerlidir.'],
    // Sagittarius
    ['Macera içeride de var.', 'Her yol bir ders.', 'Bağlanmak bağımlılık değil.'],
    // Capricorn
    ['Yolculuk önemli, varış değil.', 'Başarı tanımını sen yaz.', 'Dinlenmek üretkenliğin parçası.'],
    // Aquarius
    ['Bağlantı özgürlüğü kısıtlamaz.', 'İnsanlık bireysellikten önemli.', 'Fikirler eylemle değerlenir.'],
    // Pisces
    ['Sınırlar korunmaktır, reddedilmek değil.', 'Gerçeklik de güzel olabilir.', 'Duygular pusula, harita değil.'],
  ];

  static const List<List<String>> _shadows = [
    // Aries
    ['Sabırsızlık', 'Düşünmeden hareket', 'Öfke'],
    // Taurus
    ['İnatçılık', 'Değişime direnç', 'Bağımlılık'],
    // Gemini
    ['Dağınıklık', 'Yüzeysellik', 'Tutarsızlık'],
    // Cancer
    ['Aşırı hassasiyet', 'Geçmişe takılmak', 'Kapanmak'],
    // Leo
    ['Ego', 'Onay bağımlılığı', 'Kibir'],
    // Virgo
    ['Mükemmeliyetçilik', 'Aşırı eleştiri', 'Endişe'],
    // Libra
    ['Kararsızlık', 'Başkalarına bağımlılık', 'Kaçınma'],
    // Scorpio
    ['Kontrol ihtiyacı', 'Kıskançlık', 'Intikam'],
    // Sagittarius
    ['Kaçış', 'Sorumsuzluk', 'Aşırı iyimserlik'],
    // Capricorn
    ['İş bağımlılığı', 'Katılık', 'Pesimizm'],
    // Aquarius
    ['Duygusal uzaklık', 'İnatçılık', 'Üstünlük'],
    // Pisces
    ['Kaçış', 'Sınırsızlık', 'Kurban rolü'],
  ];

  static const List<List<String>> _lights = [
    // Aries
    ['Cesaret', 'Liderlik', 'Kararlılık'],
    // Taurus
    ['Sadakat', 'Sabır', 'Güvenilirlik'],
    // Gemini
    ['İletişim', 'Uyum', 'Zeka'],
    // Cancer
    ['Empati', 'Koruyuculuk', 'Sezgi'],
    // Leo
    ['Cömertlik', 'Yaratıcılık', 'Sıcaklık'],
    // Virgo
    ['Analitik düşünce', 'Yardımseverlik', 'Özveri'],
    // Libra
    ['Diplomasi', 'Adalet', 'Estetik'],
    // Scorpio
    ['Dönüşüm', 'Derinlik', 'Sadakat'],
    // Sagittarius
    ['İyimserlik', 'Bilgelik', 'Macera'],
    // Capricorn
    ['Disiplin', 'Azim', 'Sorumluluk'],
    // Aquarius
    ['Özgünlük', 'Vizyon', 'İnsancıllık'],
    // Pisces
    ['Şefkat', 'Yaratıcılık', 'Ruhsallık'],
  ];
}

class _CosmicContent {
  final String headline;
  final String quote;
  final int energy;
  final String microMessage;
  final String shadow;
  final String light;

  const _CosmicContent({
    required this.headline,
    required this.quote,
    required this.energy,
    required this.microMessage,
    required this.shadow,
    required this.light,
  });
}
