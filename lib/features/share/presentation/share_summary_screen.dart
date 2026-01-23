import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../../../core/theme/mystical_colors.dart';
import '../../../core/theme/mystical_typography.dart';
import '../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../data/providers/app_providers.dart';
import 'instagram_story_card.dart';

class ShareSummaryScreen extends ConsumerStatefulWidget {
  const ShareSummaryScreen({super.key});

  @override
  ConsumerState<ShareSummaryScreen> createState() => _ShareSummaryScreenState();
}

class _ShareSummaryScreenState extends ConsumerState<ShareSummaryScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isCapturing = false;

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final sign = userProfile?.sunSign ?? zodiac.ZodiacSign.aries;
    final horoscope = ref.watch(dailyHoroscopeProvider(sign));

    return Scaffold(
      backgroundColor: MysticalColors.bgDeepSpace,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: MysticalColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Kozmik Paylaşım',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: MysticalColors.textPrimary,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Instagram Story Card (9:16 aspect ratio - NEW DESIGN)
            RepaintBoundary(
              key: _cardKey,
              child: InstagramStoryCard(
                name: userProfile?.name ?? sign.nameTr,
                sign: sign,
                moonSign: userProfile?.moonSign,
                risingSign: userProfile?.risingSign,
                birthDate: userProfile?.birthDate,
              ),
            ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 24),

            // Share Button
            _ShareButton(
              isLoading: _isCapturing,
              onPressed: _captureAndShare,
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Hint
            Text(
              'Instagram hikayende kozmik enerjini paylaş!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MysticalColors.textSecondary,
                  ),
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _captureAndShare() async {
    setState(() => _isCapturing = true);

    try {
      // Wait for next frame
      await Future.delayed(const Duration(milliseconds: 100));

      // Find RenderRepaintBoundary
      final boundary = _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // Capture image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/astrobobo_summary.png');
      await file.writeAsBytes(bytes);

      // Share
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Bugünün kozmik enerjisi benimle! ✨🔮 Evrenin fısıltılarını dinle... #astrobobo #astroloji #burçyorumu #kozmikenerji',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paylaşım hatası: $e')),
      );
    } finally {
      setState(() => _isCapturing = false);
    }
  }
}

class _InstagramStoryCard extends StatelessWidget {
  final String name;
  final zodiac.ZodiacSign sign;
  final zodiac.ZodiacSign? moonSign;
  final zodiac.ZodiacSign? risingSign;
  final dynamic horoscope;
  final DateTime? birthDate;

  const _InstagramStoryCard({
    required this.name,
    required this.sign,
    required this.moonSign,
    required this.risingSign,
    required this.horoscope,
    this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 32;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MysticalColors.bgCosmic,
            MysticalColors.cosmicPurple.withOpacity(0.9),
            MysticalColors.midnightBlue,
            MysticalColors.bgDeepSpace,
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: MysticalColors.amethyst.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Constellation pattern background
          Positioned.fill(
            child: CustomPaint(
              painter: _ConstellationPainter(sign.color),
            ),
          ),

          // Background stars pattern
          ..._buildStars(),

          // Cosmic circles
          _buildCosmicCircles(),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with date
                _buildHeader(),

                const SizedBox(height: 16),

                // Zodiac Symbol with glow
                _buildZodiacSymbol(),

                const SizedBox(height: 12),

                // Sign name - Using Cinzel for mystical zodiac feel
                Text(
                  sign.nameTr.toUpperCase(),
                  style: GoogleFonts.cinzel(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: MysticalColors.textPrimary,
                    letterSpacing: 8,
                    shadows: [
                      Shadow(
                        color: sign.color.withOpacity(0.6),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // Date range & element
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sign.dateRange,
                      style: TextStyle(
                        fontSize: 12,
                        color: MysticalColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: sign.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getElementEmoji(sign.element) + ' ' + _getElementName(sign.element),
                        style: TextStyle(
                          fontSize: 10,
                          color: sign.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Name badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MysticalColors.starGold.withOpacity(0.6),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        MysticalColors.starGold.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    name,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MysticalColors.starGold,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Big Three (Sun, Moon, Rising)
                _buildBigThree(),

                const SizedBox(height: 20),

                // Ezoterik Günlük Mesaj
                _buildEsotericMessage(),

                const SizedBox(height: 16),

                // Aşk Yorumu
                _buildAdviceCard(
                  icon: '💕',
                  title: 'AŞK & İLİŞKİLER',
                  content: horoscope?.loveAdvice ?? _getDefaultLoveAdvice(sign),
                  color: Colors.pink,
                ),

                const SizedBox(height: 12),

                // Kariyer Yorumu
                _buildAdviceCard(
                  icon: '💼',
                  title: 'KARİYER & BEREKET',
                  content: horoscope?.careerAdvice ?? _getDefaultCareerAdvice(sign),
                  color: MysticalColors.starGold,
                ),

                const SizedBox(height: 12),

                // Sağlık Yorumu
                _buildAdviceCard(
                  icon: '🧘',
                  title: 'RUHSAL DENGE',
                  content: horoscope?.healthAdvice ?? _getDefaultHealthAdvice(sign),
                  color: Colors.teal,
                ),

                const SizedBox(height: 16),

                // Daily Intention - Günün Niyeti
                _buildDailyIntention(),

                const SizedBox(height: 16),

                // Cosmic Energy Meter - Kozmik Enerji Göstergesi
                _buildCosmicEnergyMeter(),

                const SizedBox(height: 16),

                // Lucky items row
                _buildLuckyItems(),

                const SizedBox(height: 16),

                // Planet positions - Gezegen konumları
                _buildPlanetPositions(),

                const SizedBox(height: 16),

                // Daily crystal & power hour
                _buildDailyCrystalAndHour(),

                const SizedBox(height: 16),

                // Traits
                _buildTraits(),

                const SizedBox(height: 16),

                // Weekly preview - haftalık ön izleme
                _buildWeeklyPreview(),

                const SizedBox(height: 16),

                // Ezoterik Bilgelik
                _buildWisdomQuote(),

                const SizedBox(height: 16),

                // Affirmation - Olumlamalar
                _buildDailyAffirmation(),

                const SizedBox(height: 16),

                // Footer with app branding
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final days = ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'];
    final months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: MysticalColors.bgElevated.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MysticalColors.starGold.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌟', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]}',
            style: const TextStyle(
              fontSize: 12,
              color: MysticalColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 8),
          const Text('🌟', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCosmicCircles() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _CosmicCirclesPainter(sign.color),
      ),
    );
  }

  Widget _buildZodiacSymbol() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: sign.color.withOpacity(0.6),
          width: 2,
        ),
        gradient: RadialGradient(
          colors: [
            sign.color.withOpacity(0.3),
            sign.color.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: sign.color.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          sign.symbol,
          style: TextStyle(
            fontSize: 48,
            color: sign.color,
            shadows: [
              Shadow(
                color: sign.color.withOpacity(0.8),
                blurRadius: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigThree() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MysticalColors.bgElevated.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MysticalColors.amethyst.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BigThreeItem(
            label: 'GÜNEŞ',
            sign: sign,
            icon: '☀️',
          ),
          Container(width: 1, height: 40, color: MysticalColors.amethyst.withOpacity(0.3)),
          _BigThreeItem(
            label: 'AY',
            sign: moonSign ?? sign,
            icon: '🌙',
          ),
          Container(width: 1, height: 40, color: MysticalColors.amethyst.withOpacity(0.3)),
          _BigThreeItem(
            label: 'YÜKSELEN',
            sign: risingSign ?? sign,
            icon: '⬆️',
          ),
        ],
      ),
    );
  }

  Widget _buildEsotericMessage() {
    final summary = horoscope?.summary ?? _getDefaultEsotericMessage(sign);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sign.color.withOpacity(0.15),
            MysticalColors.bgElevated.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sign.color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('✨', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                'KOZMİK FISILTISI',
                style: GoogleFonts.cinzel(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: sign.color,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(width: 8),
              Text('✨', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 14,
              color: MysticalColors.textPrimary,
              height: 1.6,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard({
    required String icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 11,
              color: MysticalColors.textPrimary.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyIntention() {
    final intentions = _getDailyIntentions(sign);
    final dayIndex = DateTime.now().weekday % intentions.length;
    final intention = intentions[dayIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B9D).withOpacity(0.15), // Soft pink
            const Color(0xFF60A5FA).withOpacity(0.15), // Sky blue
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🌸', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                'GÜNÜN NİYETİ',
                style: GoogleFonts.cinzel(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF6B9D),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              const Text('🌸', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            intention,
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 13,
              color: MysticalColors.textPrimary,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCosmicEnergyMeter() {
    final energyLevels = _getCosmicEnergyLevels(sign);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MysticalColors.bgElevated.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MysticalColors.amethyst.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⚡', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                'KOZMİK ENERJİ',
                style: GoogleFonts.cinzel(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: MysticalColors.amethyst,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              const Text('⚡', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          // Energy bars
          Row(
            children: [
              Expanded(
                child: _EnergyBar(
                  label: 'Aşk',
                  value: energyLevels['love']!,
                  color: const Color(0xFFFF6B9D),
                  icon: '💕',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _EnergyBar(
                  label: 'Kariyer',
                  value: energyLevels['career']!,
                  color: MysticalColors.starGold,
                  icon: '💼',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _EnergyBar(
                  label: 'Sağlık',
                  value: energyLevels['health']!,
                  color: Colors.teal,
                  icon: '🧘',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<String> _getDailyIntentions(zodiac.ZodiacSign sign) {
    final intentions = {
      zodiac.ZodiacSign.aries: [
        'Bugün cesaretimle yeni kapılar açıyorum.',
        'Liderlik enerjimle başkalarına ilham veriyorum.',
        'Tutkumla imkansızı mümkün kılıyorum.',
        'Enerjimi pozitif yönde kanalize ediyorum.',
        'Sabırlı ve kararlı adımlar atıyorum.',
        'Kalbimin sesini cesurca takip ediyorum.',
        'Yeni başlangıçlara açık ve hazırım.',
      ],
      zodiac.ZodiacSign.taurus: [
        'Bolluk ve berekete açılıyorum.',
        'Değerimi biliyorum ve sınırlarımı koruyorum.',
        'Hayatın güzelliklerinin tadını çıkarıyorum.',
        'Sabırla hedeflerime yürüyorum.',
        'Güvenlik ve konforumu yaratıyorum.',
        'Doğayla bağlantımı güçlendiriyorum.',
        'Minnettarlıkla günümü başlatıyorum.',
      ],
      zodiac.ZodiacSign.gemini: [
        'Zihinsel çevikliğimle problemleri çözüyorum.',
        'İletişimde açık ve net oluyorum.',
        'Merakımla yeni şeyler öğreniyorum.',
        'Esnekliğimle değişime uyum sağlıyorum.',
        'Fikirlerimi cesurca paylaşıyorum.',
        'Bağlantılar kuruyorum ve sürdürüyorum.',
        'Çok yönlülüğümü kutluyorum.',
      ],
      zodiac.ZodiacSign.cancer: [
        'Duygularıma alan tanıyorum.',
        'Sezgilerime güveniyorum.',
        'Sevdiklerime sevgimi gösteriyorum.',
        'Kendime şefkatle yaklaşıyorum.',
        'Yuva enerjisi yaratıyorum.',
        'Geçmişi iyileştiriyorum.',
        'Koruyucu kalbimi paylaşıyorum.',
      ],
      zodiac.ZodiacSign.leo: [
        'Işığımı saklamadan parlıyorum.',
        'Yaratıcılığımı özgürce ifade ediyorum.',
        'Cömertlikle veriyorum.',
        'Kalbimin krallığını yönetiyorum.',
        'Kendimi sevgiyle kutluyorum.',
        'Başkalarının ışımasına alan açıyorum.',
        'Asaletimleparladığım bir gün.',
      ],
      zodiac.ZodiacSign.virgo: [
        'İlerlemeyi mükemmelliğin önüne koyuyorum.',
        'Detaylarda anlam buluyorum.',
        'Sağlığıma öncelik veriyorum.',
        'Hizmet ederken sınır koyuyorum.',
        'Kendime şefkat gösteriyorum.',
        'Düzeni sevgiyle yaratıyorum.',
        'Analiz yeteneğimi pozitif kullanıyorum.',
      ],
      zodiac.ZodiacSign.libra: [
        'İç dengeyi buluyorum.',
        'İlişkilerimde uyum yaratıyorum.',
        'Güzellik ve estetik yaratıyorum.',
        'Adalet için sesimi yükseltiyorum.',
        'Kararlarımda kendime güveniyorum.',
        'Barış ve harmoni yayıyorum.',
        'Partnerliklerimde denge kuruyorum.',
      ],
      zodiac.ZodiacSign.scorpio: [
        'Dönüşüm gücümü kucaklıyorum.',
        'Derinliklerdeki bilgeliği arıyorum.',
        'Gölgelerimi aydınlatıyorum.',
        'Tutkumu bilinçle yönlendiriyorum.',
        'Yeniden doğuşa hazırım.',
        'Güvenmeyi ve açılmayı öğreniyorum.',
        'İç gücümü keşfediyorum.',
      ],
      zodiac.ZodiacSign.sagittarius: [
        'Yeni ufuklara yelken açıyorum.',
        'Bilgelik arayışımı sürdürüyorum.',
        'Özgürlüğümü sorumlulukla kullanıyorum.',
        'İyimserliği yayıyorum.',
        'Maceraya evet diyorum.',
        'Büyük resmi görüyorum.',
        'İnancımı güçlendiriyorum.',
      ],
      zodiac.ZodiacSign.capricorn: [
        'Hedeflerime kararlılıkla ilerliyorum.',
        'Disiplinimi sevgiyle uyguluyorum.',
        'Başarıyı kutluyorum.',
        'Temelleri sağlam atıyorum.',
        'Zirveye bir adım daha yaklaşıyorum.',
        'Sorumluluklarımı dengeliyorum.',
        'Sabırla ilerleyeceğim.',
      ],
      zodiac.ZodiacSign.aquarius: [
        'Benzersizliğimi kutluyorum.',
        'İnsanlığa katkıda bulunuyorum.',
        'Yenilikçi düşünüyorum.',
        'Geleceği şekillendiriyorum.',
        'Özgür düşünceyi savunuyorum.',
        'Değişimi kucaklıyorum.',
        'Toplulukla bağ kuruyorum.',
      ],
      zodiac.ZodiacSign.pisces: [
        'Sezgilerime güveniyorum.',
        'Yaratıcılığımı ifade ediyorum.',
        'Spiritüel bağlantımı derinleştiriyorum.',
        'Empatiyle sınır koyuyorum.',
        'Rüyalarıma dikkat ediyorum.',
        'Koşulsuz sevgi veriyorum.',
        'Evrenle bir oluyorum.',
      ],
    };
    return intentions[sign] ?? [
      'Bugün en iyi versiyonum olmayı seçiyorum.',
      'Her ana minnettarlıkla yaklaşıyorum.',
      'Evrenin akışına güveniyorum.',
      'Sevgi ve ışık yayıyorum.',
      'İç huzurumu buluyorum.',
      'Potansiyelimi keşfediyorum.',
      'Şu anda kalıyorum.',
    ];
  }

  Map<String, double> _getCosmicEnergyLevels(zodiac.ZodiacSign sign) {
    final random = math.Random(DateTime.now().day + sign.index);
    return {
      'love': 0.5 + random.nextDouble() * 0.5,
      'career': 0.5 + random.nextDouble() * 0.5,
      'health': 0.5 + random.nextDouble() * 0.5,
    };
  }

  Widget _buildLuckyItems() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: MysticalColors.starGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MysticalColors.starGold.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _LuckyItem(
            icon: '🎨',
            label: 'Renk',
            value: horoscope?.luckyColor ?? 'Altın',
          ),
          Container(width: 1, height: 30, color: MysticalColors.starGold.withOpacity(0.3)),
          _LuckyItem(
            icon: '🔢',
            label: 'Sayı',
            value: horoscope?.luckyNumber ?? '7',
          ),
          Container(width: 1, height: 30, color: MysticalColors.starGold.withOpacity(0.3)),
          _LuckyItem(
            icon: '💫',
            label: 'Ruh Hali',
            value: horoscope?.mood ?? 'Huzurlu',
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetPositions() {
    final planets = _getPlanetPositions(sign);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MysticalColors.bgElevated.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MysticalColors.cosmicPurple.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🪐', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                'GEZEGEN KONUMLARI',
                style: GoogleFonts.cinzel(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: MysticalColors.cosmicPurple,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              const Text('🪐', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: planets.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: MysticalColors.cosmicPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MysticalColors.cosmicPurple.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(e.value['emoji'] as String, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      '${e.key}: ${e.value['sign']}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: MysticalColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Map<String, Map<String, String>> _getPlanetPositions(zodiac.ZodiacSign sign) {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final signs = ['Koç', 'Boğa', 'İkizler', 'Yengeç', 'Aslan', 'Başak', 'Terazi', 'Akrep', 'Yay', 'Oğlak', 'Kova', 'Balık'];

    return {
      'Merkür': {'emoji': '☿️', 'sign': signs[(dayOfYear ~/ 20 + sign.index) % 12]},
      'Venüs': {'emoji': '♀️', 'sign': signs[(dayOfYear ~/ 25 + sign.index + 2) % 12]},
      'Mars': {'emoji': '♂️', 'sign': signs[(dayOfYear ~/ 45 + sign.index + 4) % 12]},
      'Jüpiter': {'emoji': '♃', 'sign': signs[(dayOfYear ~/ 365 + sign.index + 6) % 12]},
    };
  }

  Widget _buildDailyCrystalAndHour() {
    final crystal = _getDailyCrystal(sign);
    final hour = _getPowerHour(sign);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.15),
                  Colors.pink.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.purple.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(crystal['emoji']!, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text(
                  'GÜNÜN TAŞI',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.purple.shade300,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  crystal['name']!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.purple.shade200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  crystal['property']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    color: MysticalColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MysticalColors.starGold.withOpacity(0.15),
                  Colors.orange.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: MysticalColors.starGold.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Text('⏰', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text(
                  'GÜÇ SAATİ',
                  style: TextStyle(
                    fontSize: 8,
                    color: MysticalColors.starGold,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hour['time']!,
                  style: TextStyle(
                    fontSize: 11,
                    color: MysticalColors.starGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hour['activity']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    color: MysticalColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Map<String, String> _getDailyCrystal(zodiac.ZodiacSign sign) {
    final crystals = {
      zodiac.ZodiacSign.aries: {'emoji': '💎', 'name': 'Kırmızı Jasper', 'property': 'Cesaret & Güç'},
      zodiac.ZodiacSign.taurus: {'emoji': '💚', 'name': 'Yeşil Aventurin', 'property': 'Bolluk & Şans'},
      zodiac.ZodiacSign.gemini: {'emoji': '🔮', 'name': 'Sitrin', 'property': 'İletişim & Netlik'},
      zodiac.ZodiacSign.cancer: {'emoji': '🤍', 'name': 'Ay Taşı', 'property': 'Sezgi & Koruma'},
      zodiac.ZodiacSign.leo: {'emoji': '🧡', 'name': 'Kaplan Gözü', 'property': 'Güven & Liderlik'},
      zodiac.ZodiacSign.virgo: {'emoji': '💙', 'name': 'Amazonit', 'property': 'Denge & Şifa'},
      zodiac.ZodiacSign.libra: {'emoji': '💗', 'name': 'Pembe Kuvars', 'property': 'Aşk & Uyum'},
      zodiac.ZodiacSign.scorpio: {'emoji': '🖤', 'name': 'Obsidyen', 'property': 'Dönüşüm & Koruma'},
      zodiac.ZodiacSign.sagittarius: {'emoji': '💜', 'name': 'Lapis Lazuli', 'property': 'Bilgelik & Gerçek'},
      zodiac.ZodiacSign.capricorn: {'emoji': '🩶', 'name': 'Hematit', 'property': 'Topraklama & Odak'},
      zodiac.ZodiacSign.aquarius: {'emoji': '💎', 'name': 'Akuamarin', 'property': 'Özgürlük & Vizyon'},
      zodiac.ZodiacSign.pisces: {'emoji': '💜', 'name': 'Ametist', 'property': 'Spiritüellik & Huzur'},
    };
    return crystals[sign] ?? {'emoji': '💎', 'name': 'Kuvars', 'property': 'Enerji & Berraklık'};
  }

  Map<String, String> _getPowerHour(zodiac.ZodiacSign sign) {
    final hours = {
      zodiac.ZodiacSign.aries: {'time': '06:00 - 08:00', 'activity': 'Egzersiz & Başlangıç'},
      zodiac.ZodiacSign.taurus: {'time': '10:00 - 12:00', 'activity': 'Finans & Planlama'},
      zodiac.ZodiacSign.gemini: {'time': '11:00 - 13:00', 'activity': 'İletişim & Network'},
      zodiac.ZodiacSign.cancer: {'time': '20:00 - 22:00', 'activity': 'Aile & Ev'},
      zodiac.ZodiacSign.leo: {'time': '12:00 - 14:00', 'activity': 'Yaratıcılık & Liderlik'},
      zodiac.ZodiacSign.virgo: {'time': '09:00 - 11:00', 'activity': 'Organizasyon & Detay'},
      zodiac.ZodiacSign.libra: {'time': '15:00 - 17:00', 'activity': 'İş Birliği & Sanat'},
      zodiac.ZodiacSign.scorpio: {'time': '22:00 - 00:00', 'activity': 'Araştırma & Dönüşüm'},
      zodiac.ZodiacSign.sagittarius: {'time': '14:00 - 16:00', 'activity': 'Öğrenme & Keşif'},
      zodiac.ZodiacSign.capricorn: {'time': '08:00 - 10:00', 'activity': 'Kariyer & Hedefler'},
      zodiac.ZodiacSign.aquarius: {'time': '16:00 - 18:00', 'activity': 'İnovasyon & Topluluk'},
      zodiac.ZodiacSign.pisces: {'time': '21:00 - 23:00', 'activity': 'Meditasyon & Yaratıcılık'},
    };
    return hours[sign] ?? {'time': '12:00 - 14:00', 'activity': 'Odaklanma'};
  }

  Widget _buildWeeklyPreview() {
    final preview = _getWeeklyPreview(sign);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withOpacity(0.12),
            Colors.blue.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📅', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                'HAFTALIK ÖN İZLEME',
                style: GoogleFonts.cinzel(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo.shade300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              const Text('📅', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            preview,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: MysticalColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeeklyPreview(zodiac.ZodiacSign sign) {
    final previews = {
      zodiac.ZodiacSign.aries: 'Bu hafta cesaret ve inisiyatif ön planda. Çarşamba günü önemli bir fırsat kapısı açılabilir. Hafta sonu enerjini şarj etmeye ayır.',
      zodiac.ZodiacSign.taurus: 'Finansal konularda olumlu gelişmeler bekleniyor. Perşembe günü önemli bir karar anı. Hafta sonu romantik sürprizlere açık ol.',
      zodiac.ZodiacSign.gemini: 'İletişim ve sosyal bağlantılar güçleniyor. Salı günü önemli bir haber gelebilir. Cuma günü yaratıcı projeler için ideal.',
      zodiac.ZodiacSign.cancer: 'Aile ve ev konuları ön planda. Pazartesi günü duygusal bir dönüm noktası. Hafta sonu iç huzur için zaman ayır.',
      zodiac.ZodiacSign.leo: 'Kariyer ve tanınırlık artıyor. Çarşamba liderlik fırsatları sunuyor. Cumartesi yaratıcı ifade için mükemmel.',
      zodiac.ZodiacSign.virgo: 'Detaylara dikkat edilmesi gereken bir hafta. Salı günü sağlık rutienleri gözden geçirilmeli. Pazar günü organize olmak için ideal.',
      zodiac.ZodiacSign.libra: 'İlişkiler ve partnerlikler güçleniyor. Perşembe günü önemli bir toplantı. Hafta sonu sosyal etkinlikler için şanslı.',
      zodiac.ZodiacSign.scorpio: 'Dönüşüm ve yenilenme haftası. Cuma günü derin içgörüler geliyor. Pazar günü meditasyon için mükemmel.',
      zodiac.ZodiacSign.sagittarius: 'Macera ve keşif enerjisi yüksek. Pazartesi yeni öğrenme fırsatları. Cumartesi seyahat veya yeni deneyimler için ideal.',
      zodiac.ZodiacSign.capricorn: 'Kariyer hedeflerinde ilerleme var. Çarşamba önemli bir başarı. Hafta sonu dinlenme ve yansıma için zaman ayır.',
      zodiac.ZodiacSign.aquarius: 'Yenilikçi fikirler ön planda. Salı günü ilham dolu anlar. Cuma günü topluluk çalışmaları için bereketli.',
      zodiac.ZodiacSign.pisces: 'Sezgisel güç dorukta. Perşembe günü spiritüel uyanış. Hafta sonu sanatsal ve yaratıcı çalışmalar için ideal.',
    };
    return previews[sign] ?? 'Bu hafta evrenin enerjileri seninle. Her gün yeni fırsatlar için gözlerini açık tut.';
  }

  Widget _buildDailyAffirmation() {
    final affirmation = _getDailyAffirmation(sign);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.withOpacity(0.12),
            Colors.cyan.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🌟', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                'GÜNÜN OLUMLAMASI',
                style: GoogleFonts.cinzel(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              const Text('🌟', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"$affirmation"',
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 13,
              color: MysticalColors.textPrimary,
              height: 1.5,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getDailyAffirmation(zodiac.ZodiacSign sign) {
    final dayIndex = DateTime.now().weekday;
    final affirmations = {
      zodiac.ZodiacSign.aries: [
        'Ben cesur ve güçlüyüm. Her engeli aşabilirim.',
        'Liderlik enerjim dünyayı değiştiriyor.',
        'Tutkum sonsuz, gücüm sınırsız.',
        'Yeni başlangıçlar için hazırım.',
        'Cesaretim yolumu aydınlatıyor.',
        'Ben bir savaşçıyım ve kazanacağım.',
        'Enerjim bulaşıcı, ruhum özgür.',
      ],
      zodiac.ZodiacSign.taurus: [
        'Bolluk ve bereket bana akıyor.',
        'Sabır en güçlü silahımdır.',
        'Değerimi biliyorum ve koruyorum.',
        'Güvenlik ve huzur içindeyim.',
        'Doğanın gücü benimle.',
        'Her gün daha zenginleşiyorum.',
        'Minnettarlık kalbimde yaşıyor.',
      ],
      zodiac.ZodiacSign.gemini: [
        'Zihinsel çevikliğim mucizeler yaratıyor.',
        'İletişimim köprüler kuruyor.',
        'Merakım beni büyütüyor.',
        'Her gün yeni şeyler öğreniyorum.',
        'Fikirlerim değerli ve önemli.',
        'Esnekliğim gücümdür.',
        'Çok yönlülüğüm armağanımdır.',
      ],
      zodiac.ZodiacSign.cancer: [
        'Duygularım gücüm, sezgilerim rehberim.',
        'Sevgi veriyorum, sevgi alıyorum.',
        'Kendime şefkatle yaklaşıyorum.',
        'Yuva enerjisi her yerde benimle.',
        'Geçmişi iyileştiriyorum, geleceği kucaklıyorum.',
        'Koruyucu kalbim herkesi sarıyor.',
        'Ay\'ın ışığında yenileniyorum.',
      ],
      zodiac.ZodiacSign.leo: [
        'Işığım parlıyor, dünya beni görüyor.',
        'Yaratıcılığım sınır tanımıyor.',
        'Kalbimin krallığını sevgiyle yönetiyorum.',
        'Cömertliğim bereketimi artırıyor.',
        'Sahnenin yıldızıyım.',
        'Kendimi seviyorum, kendime güveniyorum.',
        'Asaletim her adımımda belli.',
      ],
      zodiac.ZodiacSign.virgo: [
        'Mükemmellik değil, ilerleme hedefim.',
        'Detaylarda büyüyü buluyorum.',
        'Şifalı ellerim dünyayı iyileştiriyor.',
        'Kendime karşı nazik oluyorum.',
        'Düzen içinde huzur buluyorum.',
        'Analitik zekam bereketimi artırıyor.',
        'Her küçük adım önemli.',
      ],
      zodiac.ZodiacSign.libra: [
        'İç dengem dış dünyamı şekillendiriyor.',
        'Uyum her yerde benimle.',
        'Güzellik yaratıyorum, güzellik görüyorum.',
        'Adalet kalbimde yaşıyor.',
        'Kararlarıma güveniyorum.',
        'Barış elçisiyim.',
        'İlişkilerimde harmoni var.',
      ],
      zodiac.ZodiacSign.scorpio: [
        'Dönüşüm gücüm sınırsız.',
        'Karanlıkta ışık buluyorum.',
        'Tutkum beni ileriye taşıyor.',
        'Yeniden doğmaya hazırım.',
        'Güvenmeyi öğreniyorum.',
        'Derinliklerde hazineler keşfediyorum.',
        'İç gücüm her şeyi aşar.',
      ],
      zodiac.ZodiacSign.sagittarius: [
        'Ufuklarım sınırsız.',
        'Bilgelik arayışım hiç bitmiyor.',
        'Özgürlüğüm kutsal.',
        'İyimserlik silahımdır.',
        'Macera beni çağırıyor.',
        'Büyük resmi görüyorum.',
        'İnanç dağları oynatır.',
      ],
      zodiac.ZodiacSign.capricorn: [
        'Hedeflerime emin adımlarla yürüyorum.',
        'Disiplin ve sevgi bir arada.',
        'Başarı benim doğal halim.',
        'Temeller sağlam, gelecek parlak.',
        'Her gün zirveye biraz daha yakınım.',
        'Sorumluluklarım beni güçlendiriyor.',
        'Sabır meyve verir.',
      ],
      zodiac.ZodiacSign.aquarius: [
        'Benzersizliğim armağanımdır.',
        'İnsanlığa hizmet ediyorum.',
        'Yenilikçi fikirlerim dünyayı değiştiriyor.',
        'Geleceği bugünden şekillendiriyorum.',
        'Özgür düşünce hakkımdır.',
        'Değişim dostum.',
        'Topluluk gücümüzdür.',
      ],
      zodiac.ZodiacSign.pisces: [
        'Sezgilerim beni doğru yola götürüyor.',
        'Yaratıcılığım evreni zenginleştiriyor.',
        'Spiritüel bağım güçlü.',
        'Empati gücümdür.',
        'Rüyalarım gerçek oluyor.',
        'Koşulsuz sevgi veriyorum.',
        'Evrenle bir oluyorum.',
      ],
    };
    final signAffirmations = affirmations[sign] ?? ['Evren beni seviyor ve destekliyor.'];
    return signAffirmations[(dayIndex - 1) % signAffirmations.length];
  }

  Widget _buildTraits() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: sign.traits.take(5).map((trait) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                sign.color.withOpacity(0.25),
                sign.color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: sign.color.withOpacity(0.4),
            ),
          ),
          child: Text(
            trait,
            style: TextStyle(
              fontSize: 10,
              color: sign.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWisdomQuote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MysticalColors.amethyst.withOpacity(0.15),
            MysticalColors.cosmicPurple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MysticalColors.amethyst.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text('🔮', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            _getWisdomQuote(sign),
            textAlign: TextAlign.center,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 12,
              color: MysticalColors.amethyst,
              height: 1.5,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                MysticalColors.starGold.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⭐', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            Text(
              'ASTROBOBO',
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: MysticalColors.starGold,
                letterSpacing: 5,
              ),
            ),
            const SizedBox(width: 8),
            const Text('⭐', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Kozmik Rehberin',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 11,
            color: MysticalColors.textMuted,
            letterSpacing: 2,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStars() {
    final List<Widget> stars = [];
    final starPositions = [
      const Offset(20, 40),
      const Offset(70, 100),
      const Offset(280, 60),
      const Offset(320, 130),
      const Offset(40, 250),
      const Offset(300, 320),
      const Offset(60, 400),
      const Offset(280, 450),
      const Offset(30, 550),
      const Offset(310, 600),
      const Offset(50, 700),
      const Offset(290, 750),
      const Offset(25, 850),
      const Offset(305, 900),
    ];

    for (var i = 0; i < starPositions.length; i++) {
      final pos = starPositions[i];
      final size = 1.5 + (i % 3) * 1.2;
      final opacity = 0.25 + (i % 4) * 0.12;

      stars.add(
        Positioned(
          left: pos.dx,
          top: pos.dy,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(opacity),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(opacity * 0.5),
                  blurRadius: size * 2,
                  spreadRadius: size * 0.5,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return stars;
  }

  String _getElementEmoji(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire: return '🔥';
      case zodiac.Element.earth: return '🌍';
      case zodiac.Element.air: return '💨';
      case zodiac.Element.water: return '💧';
    }
  }

  String _getElementName(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire: return 'Ateş';
      case zodiac.Element.earth: return 'Toprak';
      case zodiac.Element.air: return 'Hava';
      case zodiac.Element.water: return 'Su';
    }
  }

  String _getDefaultEsotericMessage(zodiac.ZodiacSign sign) {
    final messages = {
      zodiac.ZodiacSign.aries: 'Ateş ruhun bugün yeni başlangıçların kapısını aralıyor. Cesaretinle ileri atıl, evren seninle dans ediyor. Öncü enerjin dağları yerinden oynatacak güçte.',
      zodiac.ZodiacSign.taurus: 'Toprak ana seni besliyor, köklerini derinleştir. Sabır ve kararlılığın meyvelerini toplama zamanı yaklaşıyor. Değerin, yıldızlarda yazılı.',
      zodiac.ZodiacSign.gemini: 'Zihnin galaksiler arası bir köprü gibi çalışıyor. Her düşünce bir yıldız, her kelime bir büyü. İletişim gücünle dünyaları birleştir.',
      zodiac.ZodiacSign.cancer: 'Ay\'ın çocuğu, sezgilerin bugün kristal berraklığında. Duygusal derinliğin okyanuslar kadar engin, kalbinin sesini dinle.',
      zodiac.ZodiacSign.leo: 'Güneş\'in tacını taşıyan asil ruh, ışığın karanlığı eritiyor. Yaratıcılığın ve cesaretinle sahneye çık, gökyüzü senin sahnedir.',
      zodiac.ZodiacSign.virgo: 'Kusursuzluk arayışın bugün evrensel düzenle buluşuyor. Analitik zekân ve şifalı ellerin dünyayı iyileştiriyor.',
      zodiac.ZodiacSign.libra: 'Denge noktasında duran ruh, uyum senin doğal halin. Güzellik ve adalet arayışın evrenin yasalarıyla örtüşüyor.',
      zodiac.ZodiacSign.scorpio: 'Dönüşümün simyacısı, derinliklerde gizli hazineler seni bekliyor. Karanlığı aydınlığa çeviren gücünle yüksel.',
      zodiac.ZodiacSign.sagittarius: 'Bilgelik okçusu, hedefin sonsuzluk. Macera ruhu ve felsefi derinliğinle yeni ufuklar keşfet.',
      zodiac.ZodiacSign.capricorn: 'Dağların efendisi, zirveye giden yol ayaklarının altında. Disiplin ve kararlılığınla imkansızı mümkün kıl.',
      zodiac.ZodiacSign.aquarius: 'Geleceğin mimarı, vizyonun zamanın ötesinde. İnsanlığa hizmet eden ruhun yıldızlarla konuşuyor.',
      zodiac.ZodiacSign.pisces: 'Rüyaların gezgini, sezgisel okyanusta yüzüyorsun. Spiritüel derinliğin ve şefkatin evrensel bir armağan.',
    };
    return messages[sign] ?? 'Evren bugün seninle dans ediyor. Kozmik enerjiler seni destekliyor.';
  }

  String _getDefaultLoveAdvice(zodiac.ZodiacSign sign) {
    final advice = {
      zodiac.ZodiacSign.aries: 'Tutkulu enerjin aşk hayatını canlandırıyor. Beklenmedik romantik sürprizlere hazır ol, kalp atışların evrenle senkronize.',
      zodiac.ZodiacSign.taurus: 'Sadakat ve güven ilişkilerini güçlendiriyor. Derin duygusal bağlar kurma zamanı, sevgini somut eylemlerle göster.',
      zodiac.ZodiacSign.gemini: 'İletişim aşkın anahtarı. Kelimelerinle büyüle, zihninle fethet. Çift ruhlu doğan seni bekliyor.',
      zodiac.ZodiacSign.cancer: 'Duygusal derinliğin partner çekiyor. Yuva kurma içgüdün güçlü, kalbini açmaktan korkma.',
      zodiac.ZodiacSign.leo: 'Dramatiğin ve romantik jestlerin parıldıyor. Göz kamaştırıcı aşk enerjin etrafındakileri büyülüyor.',
      zodiac.ZodiacSign.virgo: 'Detaylarda gizli aşk. Küçük jestler büyük anlamlar taşıyor, pratik sevgi dilinle bağ kur.',
      zodiac.ZodiacSign.libra: 'Venüs\'ün çocuğu, romantizm seninle doğuyor. Uyumlu partnerlikler için yıldızlar düzenleniyor.',
      zodiac.ZodiacSign.scorpio: 'Yoğun tutkular ve derin bağlar. Güven inşa et, karşılıklı dönüşüm için hazır ol.',
      zodiac.ZodiacSign.sagittarius: 'Özgür ruhlu aşk macerası. Entelektüel bağ fiziksel çekimi güçlendiriyor.',
      zodiac.ZodiacSign.capricorn: 'Uzun vadeli ilişkiler için temel atılıyor. Sadakat ve bağlılığın meyve veriyor.',
      zodiac.ZodiacSign.aquarius: 'Sıra dışı bağlantılar ve arkadaşlık temelli aşk. Özgünlüğün çekiciliğin.',
      zodiac.ZodiacSign.pisces: 'Ruhani aşk bağları güçleniyor. Şefkat ve empatin sonsuz, ruh eşi enerjisi yoğun.',
    };
    return advice[sign] ?? 'Kalbin kozmik frekanslara açık. Aşk kapıda.';
  }

  String _getDefaultCareerAdvice(zodiac.ZodiacSign sign) {
    final advice = {
      zodiac.ZodiacSign.aries: 'Liderlik pozisyonları parlıyor. Girişimci ruhun yeni projelere hazır, cesaretle ileri atıl.',
      zodiac.ZodiacSign.taurus: 'Finansal istikrar güçleniyor. Yatırımlar için uygun zaman, sabırlı ol ve bereket akacak.',
      zodiac.ZodiacSign.gemini: 'İletişim projeleri öne çıkıyor. Network genişliyor, bilgi akışı kazanç getiriyor.',
      zodiac.ZodiacSign.cancer: 'Ev tabanlı işler ve duygusal zeka gerektiren roller parlıyor. Sezgisel kararlar al.',
      zodiac.ZodiacSign.leo: 'Yaratıcı projeler ve liderlik rolleri için mükemmel zaman. Sahneye çık, parlama vaktin.',
      zodiac.ZodiacSign.virgo: 'Detay odaklı işlerde başarı. Organizasyon yeteneğin takdir görüyor, sistemler kur.',
      zodiac.ZodiacSign.libra: 'Ortaklıklar ve diplomasi alanında fırsatlar. İş birliği projeleri bereketli.',
      zodiac.ZodiacSign.scorpio: 'Araştırma ve dönüşüm projeleri öne çıkıyor. Gizli fırsatları keşfet.',
      zodiac.ZodiacSign.sagittarius: 'Uluslararası bağlantılar ve eğitim alanında gelişmeler. Ufukları genişlet.',
      zodiac.ZodiacSign.capricorn: 'Kariyer zirvesine tırmanış hızlanıyor. Uzun vadeli hedeflere odaklan.',
      zodiac.ZodiacSign.aquarius: 'Teknoloji ve yenilik projeleri parlıyor. Sıra dışı fikirlerin değer kazanıyor.',
      zodiac.ZodiacSign.pisces: 'Yaratıcı ve spiritüel alanlarda kariyer fırsatları. Sezgilerine güven.',
    };
    return advice[sign] ?? 'Evren bolluk kapılarını açıyor. Fırsatları yakala.';
  }

  String _getDefaultHealthAdvice(zodiac.ZodiacSign sign) {
    final advice = {
      zodiac.ZodiacSign.aries: 'Fiziksel aktivite enerjini dengele. Meditasyon sabırsızlığını yatıştıracak, nefes çalışmaları yap.',
      zodiac.ZodiacSign.taurus: 'Duyu zevkleriyle şımart kendini. Doğa yürüyüşleri ve topraklanma ritüelleri şifa verecek.',
      zodiac.ZodiacSign.gemini: 'Zihinsel detoks zamanı. Bilgi bombardımanından uzaklaş, sessizliğin gücünü keşfet.',
      zodiac.ZodiacSign.cancer: 'Duygusal arınma ve su terapisi. Ay banyoları ve deniz tuzu ritüelleri ruhunu temizlesin.',
      zodiac.ZodiacSign.leo: 'Kalp çakrası çalışması. Yaratıcı ifade enerjini dengeler, dans et ve özgürce parla.',
      zodiac.ZodiacSign.virgo: 'Detoks ve arınma ritüelleri. Sağlıklı rutinler oluştur, mükemmeliyetçiliği bırak.',
      zodiac.ZodiacSign.libra: 'Denge ve uyum çalışmaları. Yoga ve nefes teknikleri iç huzuru getirecek.',
      zodiac.ZodiacSign.scorpio: 'Derin dönüşüm ve şifa çalışmaları. Gölge çalışması ve meditasyon gücünü artıracak.',
      zodiac.ZodiacSign.sagittarius: 'Hareket ve macera. Doğada vakit geçir, ruhunu özgür bırak.',
      zodiac.ZodiacSign.capricorn: 'Kemik ve eklem sağlığına dikkat. Dinlenme ve rejenerasyon zamanı.',
      zodiac.ZodiacSign.aquarius: 'Sinir sistemi dengelemesi. Teknolojiden uzaklaş, doğayla bağlan.',
      zodiac.ZodiacSign.pisces: 'Su elementleriyle şifa. Yüzme, banyo ritüelleri ve rüya çalışması.',
    };
    return advice[sign] ?? 'Beden-zihin-ruh üçlüsünü dengele. Şifa içinden geliyor.';
  }

  String _getWisdomQuote(zodiac.ZodiacSign sign) {
    final quotes = {
      zodiac.ZodiacSign.aries: '"Evrendeki her başlangıç, sonsuz cesaretin bir yansımasıdır. Sen, kozmosun ilk kıvılcımısın."',
      zodiac.ZodiacSign.taurus: '"Sabır, evrenin en güçlü simyasıdır. Bekleyen, dönüştürür."',
      zodiac.ZodiacSign.gemini: '"Her düşünce bir yıldız tohumudur. Zihnin, galaksilerin bahçesidir."',
      zodiac.ZodiacSign.cancer: '"Ay\'ın ışığında, ruhun en derin sırları aydınlanır."',
      zodiac.ZodiacSign.leo: '"Kalbindeki güneş, binlerce yıldızdan daha parlaktır."',
      zodiac.ZodiacSign.virgo: '"Mükemmellik, detaylarda gizli ilahi düzenin keşfidir."',
      zodiac.ZodiacSign.libra: '"Denge, evrenin en kadim yasasıdır. Sen, kozmik uyumun koruyucususun."',
      zodiac.ZodiacSign.scorpio: '"Karanlık, ışığın doğum yeridir. Dönüşüm, ruhun uyanışıdır."',
      zodiac.ZodiacSign.sagittarius: '"Ufuk çizgisinin ötesinde, bilgeliğin sonsuz okyanusları yatar."',
      zodiac.ZodiacSign.capricorn: '"Zirve, sabır ve kararlılığın buluşma noktasıdır."',
      zodiac.ZodiacSign.aquarius: '"Gelecek, vizyonerlerin rüyalarından doğar."',
      zodiac.ZodiacSign.pisces: '"Evrenin tüm sırları, sezginin sessiz sularında yüzer."',
    };
    return quotes[sign] ?? '"Yıldızlar, ruhunun haritasını çizer. Yolun aydınlık olsun."';
  }
}

class _CosmicCirclesPainter extends CustomPainter {
  final Color accentColor;

  _CosmicCirclesPainter(this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw subtle cosmic circles
    paint.color = accentColor.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.15), 120, paint);

    paint.color = MysticalColors.amethyst.withOpacity(0.05);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.5), 80, paint);

    paint.color = MysticalColors.starGold.withOpacity(0.05);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.7), 60, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Draws constellation lines connecting stars in mystical patterns
class _ConstellationPainter extends CustomPainter {
  final Color accentColor;

  _ConstellationPainter(this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistency

    // Generate constellation star positions
    final List<Offset> stars = [];
    for (int i = 0; i < 25; i++) {
      stars.add(Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      ));
    }

    // Draw constellation lines connecting nearby stars
    final linePaint = Paint()
      ..color = accentColor.withOpacity(0.06)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < stars.length; i++) {
      for (int j = i + 1; j < stars.length; j++) {
        final distance = (stars[i] - stars[j]).distance;
        if (distance < 120 && random.nextDouble() > 0.5) {
          // Draw line with gradient opacity based on distance
          final opacity = 0.08 * (1 - distance / 120);
          linePaint.color = accentColor.withOpacity(opacity);
          canvas.drawLine(stars[i], stars[j], linePaint);
        }
      }
    }

    // Draw star nodes at intersections
    final nodePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    for (final star in stars) {
      final nodeSize = 1.0 + random.nextDouble() * 1.5;
      canvas.drawCircle(star, nodeSize, nodePaint);

      // Add subtle glow to some stars
      if (random.nextDouble() > 0.7) {
        final glowPaint = Paint()
          ..color = accentColor.withOpacity(0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(star, nodeSize * 2, glowPaint);
      }
    }

    // Draw zodiac-inspired geometric shapes
    _drawZodiacGeometry(canvas, size, accentColor);
  }

  void _drawZodiacGeometry(Canvas canvas, Size size, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.04)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw subtle hexagon pattern (astrological symbol)
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.12;
    final radius = 60.0;

    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Draw inner star pattern
    paint.color = color.withOpacity(0.03);
    for (int i = 0; i < 6; i++) {
      final angle1 = (i * 60 - 30) * math.pi / 180;
      final angle2 = ((i + 2) * 60 - 30) * math.pi / 180;
      final x1 = centerX + radius * math.cos(angle1);
      final y1 = centerY + radius * math.sin(angle1);
      final x2 = centerX + radius * math.cos(angle2);
      final y2 = centerY + radius * math.sin(angle2);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Draw bottom decorative arc
    paint.color = MysticalColors.starGold.withOpacity(0.03);
    final arcRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.95),
      width: size.width * 0.8,
      height: 100,
    );
    canvas.drawArc(arcRect, math.pi, math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BigThreeItem extends StatelessWidget {
  final String label;
  final zodiac.ZodiacSign sign;
  final String icon;

  const _BigThreeItem({
    required this.label,
    required this.sign,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: MysticalColors.textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sign.symbol,
              style: TextStyle(fontSize: 12, color: sign.color),
            ),
            const SizedBox(width: 3),
            Text(
              sign.nameTr,
              style: TextStyle(
                fontSize: 10,
                color: sign.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LuckyItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _LuckyItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: MysticalColors.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            color: MysticalColors.starGold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ShareButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _ShareButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _gradientController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ListenableBuilder(
        listenable: Listenable.merge([_shimmerController, _pulseController, _gradientController]),
        builder: (context, child) {
          final pulseValue = 1.0 + (_pulseController.value * 0.03);
          final gradientShift = _gradientController.value;

          return Transform.scale(
            scale: pulseValue,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1 + gradientShift * 2, -1),
                  end: Alignment(1 + gradientShift * 2, 1),
                  colors: const [
                    Color(0xFFFF3CAC), // Hot pink
                    Color(0xFF784BA0), // Purple
                    Color(0xFF2B86C5), // Blue
                    Color(0xFFFF3CAC), // Hot pink (repeat for smooth loop)
                  ],
                  stops: const [0.0, 0.33, 0.66, 1.0],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withAlpha(60),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF3CAC).withAlpha((100 + 50 * _pulseController.value).toInt()),
                    blurRadius: 25 + 10 * _pulseController.value,
                    offset: const Offset(-3, 6),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: const Color(0xFF2B86C5).withAlpha((100 + 50 * _pulseController.value).toInt()),
                    blurRadius: 25 + 10 * _pulseController.value,
                    offset: const Offset(3, 6),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.white.withAlpha(30),
                    blurRadius: 1,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Glass effect overlay
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withAlpha(40),
                              Colors.white.withAlpha(5),
                            ],
                            stops: const [0.0, 0.5],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Shimmer effect
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment(-1.5 + 3 * _shimmerController.value, 0),
                            end: Alignment(-0.5 + 3 * _shimmerController.value, 0),
                            colors: [
                              Colors.white.withAlpha(0),
                              Colors.white.withAlpha(80),
                              Colors.white.withAlpha(0),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Container(color: Colors.white.withAlpha(10)),
                      ),
                    ),
                  ),
                  // Content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isLoading)
                        const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      else ...[
                        // Sparkle emoji
                        const Text('✨', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        // Instagram icon - premium design
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFEDA77),
                                Color(0xFFF58529),
                                Color(0xFFDD2A7B),
                                Color(0xFF8134AF),
                                Color(0xFF515BD4),
                              ],
                              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDD2A7B).withAlpha(120),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Inner border
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                              // Camera icon
                              const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              // Dot
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Text content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Instagram\'da Paylaş',
                                  style: GoogleFonts.raleway(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withAlpha(60),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text('💫', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Hikayende kozmik enerjini paylaş!',
                              style: GoogleFonts.raleway(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withAlpha(220),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        const Text('🔮', style: TextStyle(fontSize: 22)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Animated builder helper widget
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder2({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}

/// Energy bar widget for cosmic energy meter
class _EnergyBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String icon;

  const _EnergyBar({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: MysticalColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: MysticalColors.bgElevated,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.7),
                    color,
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
