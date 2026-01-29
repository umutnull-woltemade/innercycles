import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/mystical_colors.dart';
import '../../../data/models/zodiac_sign.dart' as zodiac;

/// Instagram Story formatına uygun kart (1080x1920 - 9:16)
/// VİRAL & PAYLAŞILABILIR - Instagram trendlerine uygun
class InstagramStoryCard extends StatelessWidget {
  final String name;
  final zodiac.ZodiacSign sign;
  final zodiac.ZodiacSign? moonSign;
  final zodiac.ZodiacSign? risingSign;
  final DateTime? birthDate;

  const InstagramStoryCard({
    super.key,
    required this.name,
    required this.sign,
    this.moonSign,
    this.risingSign,
    this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 32;
    final cardHeight = screenWidth * (16 / 9);

    return Container(
      width: screenWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: sign.color.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            _buildBackground(),
            _buildStarsOverlay(),
            CustomPaint(
              size: Size(screenWidth, cardHeight),
              painter: _ConstellationPainter(sign.color),
            ),
            _buildGlowingOrbs(screenWidth, cardHeight),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // Viral hook başlık
                  _buildViralHook(),

                  const SizedBox(height: 16),

                  // Ana burç sembolü
                  _buildZodiacHero(),

                  const SizedBox(height: 12),

                  // Günün viral mesajı
                  _buildViralMessage(),

                  const SizedBox(height: 16),

                  // Big Three - kompakt
                  _buildBigThreeCompact(),

                  const SizedBox(height: 12),

                  // Viral traits - etiketler
                  _buildViralTraits(),

                  const SizedBox(height: 10),

                  // Ezoterik Günlük Kristal & Tarot
                  _buildEsotericDaily(),

                  const SizedBox(height: 10),

                  // Günün şansı - gamification
                  _buildLuckMeter(),

                  const SizedBox(height: 10),

                  // Aşk uyumu teaser
                  _buildLoveTeaser(),

                  const SizedBox(height: 10),

                  // Kozmik Uyarı / Tavsiye
                  _buildCosmicAdvice(),

                  const Spacer(),

                  // CTA & Branding
                  _buildFooterCTA(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0D0D1A),
            sign.color.withOpacity(0.4),
            const Color(0xFF1A0D2E),
            const Color(0xFF0D0D1A),
          ],
          stops: const [0.0, 0.35, 0.65, 1.0],
        ),
      ),
    );
  }

  Widget _buildStarsOverlay() {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: _StarsPainter(),
    );
  }

  Widget _buildGlowingOrbs(double width, double height) {
    return Stack(
      children: [
        Positioned(
          top: height * 0.15,
          left: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  sign.color.withOpacity(0.5),
                  sign.color.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: height * 0.25,
          right: -40,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  MysticalColors.cosmicPurple.withOpacity(0.4),
                  MysticalColors.cosmicPurple.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VİRAL HOOK - Dikkat çekici başlık
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildViralHook() {
    final hooks = _getViralHooks(sign);
    final hook = hooks[DateTime.now().day % hooks.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B9D).withOpacity(0.3),
            const Color(0xFF9C27B0).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              hook,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          const Text('🔥', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  List<String> _getViralHooks(zodiac.ZodiacSign sign) {
    final hooks = {
      zodiac.ZodiacSign.aries: [
        'KOÇ BURCU AMA RED FLAG DEĞİL 🚩',
        'KAÇIYOR MU KOVALIYORSAN? KOÇ İŞTE 😏',
        'EN ATEŞLI BURÇ SIRALAMASI: 1️⃣',
        'KOÇ ENERJİSİ BUGÜN FARKLI HİT EDİYOR',
      ],
      zodiac.ZodiacSign.taurus: [
        'BOĞA AMA TOXIC DEĞİL (BELKİ) 🤭',
        'LOYALTY TEST: BOĞA KAZANDI 💪',
        'EN İNATÇI BURÇ? GİRİŞ ÜCRETSİZ 🐂',
        'BOĞA ENERJİSİ = ZENGİN ENERJİSİ 💰',
      ],
      zodiac.ZodiacSign.gemini: [
        'İKİZLER AMA BİPOLAR DEĞİL (TAMAM BELKİ) 🙃',
        '2 KİŞİLİK SADECE 1 BURÇ 👯',
        'İKİZLER BUGÜN HANGİ MOOD? 🎭',
        'KONUŞKAN MI? İKİZLER CONFIRMED ✅',
      ],
      zodiac.ZodiacSign.cancer: [
        'YENGEÇ AMA AĞLAMIYORUZ (BUGÜN) 🥲',
        'DUYGUSAL ZEKA: YENGEÇ 100/100 🧠',
        'KABUĞA ÇEKİLME MODU: ON 🦀',
        'YENGEÇ SEVGİSİ = GERÇEK SEVGİ 💕',
      ],
      zodiac.ZodiacSign.leo: [
        'ASLAN AMA EGO YOK (YOK DİYORUM) 👑',
        'SPOTLIGHT KİMİN? ASLAN BURCU 🦁',
        'DRAMA QUEEN/KING: EVET VE? 💅',
        'ASLAN ENERJİSİ BUGÜN PARLAK ✨',
      ],
      zodiac.ZodiacSign.virgo: [
        'BAŞAK AMA OBSESİF DEĞİL (ÇOK) 🧹',
        'PERFECTIONIST? BAŞAK CONFIRMED 💯',
        'DETAYLARA TAKILMAK: BAŞAK 101 📝',
        'BAŞAK BURCU = KALİTE GARANTİ ✅',
      ],
      zodiac.ZodiacSign.libra: [
        'TERAZİ AMA KARARSIZ DEĞİL (BELKİ) ⚖️',
        'ESTETİK ANLAYIŞI: TERAZİ SUPREME 🎨',
        'HERKES SEVSİN Mİ? TERAZİ EVET 🥰',
        'TERAZİ DENGESİ BUGÜN TUTTURDU ✨',
      ],
      zodiac.ZodiacSign.scorpio: [
        'AKREP AMA TOXIC DEĞİL (EĞER SEVERSEn) 🦂',
        'GİZEMLİ Mİ? AKREP ASLA SÖYLEMEZ 🤫',
        'AKREP BAKIŞI = RÖNTGEN CİHAZI 👀',
        'EN TUTKULU BURÇ: AKREP DUH 🔥',
      ],
      zodiac.ZodiacSign.sagittarius: [
        'YAY AMA KAÇMIYOR (HEMEN DEĞİL) 🏃',
        'ÖZGÜRLÜK Mİ SEVGİ Mİ? YAY: İKİSİ 🌍',
        'MACERACI MI? YAY 7/24 HAZIR ✈️',
        'YAY ENERJİSİ = POZİTİF VİBES 🌈',
      ],
      zodiac.ZodiacSign.capricorn: [
        'OĞLAK AMA WORKAHOLIC DEĞİL (AZ) 💼',
        'CEO ENERJİSİ: OĞLAK APPROVED 📈',
        'SORUMLU MU? OĞLAK BURCU EVET 🏆',
        'OĞLAK HEDEFİ = GERÇEK OLUYOR 🎯',
      ],
      zodiac.ZodiacSign.aquarius: [
        'KOVA AMA ALIEN DEĞİL (EMİN MİSİN?) 👽',
        'FARKLI OLMAK: KOVA ÖYLE DOĞDU 🦄',
        'KOVA FİKİRLERİ = GELECEKTEN 🚀',
        'REBELLİON MODE: KOVA ON 🔥',
      ],
      zodiac.ZodiacSign.pisces: [
        'BALIK AMA KAÇMIYOR (YÜZÜYOR) 🐟',
        'HAYALPEREST Mİ? BALIK HER ZAMAN 🌙',
        'EMPATİ SEVİYESİ: BALIK MAX 💫',
        'BALIK ENERJİSİ = SEZGI GÜCÜ 🔮',
      ],
    };
    return hooks[sign] ?? ['YILDIZLARIN FAVORİSİ ✨'];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ANA BURÇ HERO SEKSİYONU
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildZodiacHero() {
    return Column(
      children: [
        // Burç sembolü - büyük ve dikkat çekici
        Stack(
          alignment: Alignment.center,
          children: [
            // Dış halka
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: sign.color.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            // İç dolu daire
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    sign.color.withOpacity(0.5),
                    sign.color.withOpacity(0.2),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: sign.color.withOpacity(0.6),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  sign.symbol,
                  style: TextStyle(
                    fontSize: 52,
                    color: Colors.white,
                    shadows: [Shadow(color: sign.color, blurRadius: 25)],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Burç adı
        Text(
          sign.nameTr.toUpperCase(),
          style: GoogleFonts.cinzel(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 8,
            shadows: [
              Shadow(color: sign.color.withOpacity(0.8), blurRadius: 15),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Element ve tarih
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: sign.color.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sign.color.withOpacity(0.5)),
              ),
              child: Text(
                '${_getElementEmoji(sign.element)} ${_getElementName(sign.element)}',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              sign.dateRange,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VİRAL MESAJ - Paylaşılabilir içerik
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildViralMessage() {
    final message = _getViralMessage(sign);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sign.color.withOpacity(0.2),
            const Color(0xFF9C27B0).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sign.color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            '💬 BUGÜNÜN GERÇEĞI',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: MysticalColors.starGold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.95),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _getViralMessage(zodiac.ZodiacSign sign) {
    final day = DateTime.now().day;
    final messages = {
      zodiac.ZodiacSign.aries: [
        'Bugün biri seni kızdırmaya çalışacak ama sen zaten biliyorsun 😏',
        'Sabırsızlığın değil, herkes yavaş işte 🔥',
        'Ego mu? Hayır, özgüven 💪',
        'Liderlik yapmak değil, herkes takip ediyor sadece 👑',
      ],
      zodiac.ZodiacSign.taurus: [
        'Yemek mi para mı? Cevap: ikisi de 🍕💰',
        'İnatçı değilim, haklıyım 🤷',
        'Konfor alanım? Lüks versiyonu lütfen 💎',
        'Sadık mıyım? Beni üzene kadar evet 🐂',
      ],
      zodiac.ZodiacSign.gemini: [
        'Hangi kişiliğim? Duruma göre değişir 🎭',
        'Sıkıldım, yeni hobi lazım. Dakika 1 gün 1 👀',
        'Çok konuşuyorum ama hep doğru 💬',
        'Kararsız değilim, seçenekler çok 🤔',
      ],
      zodiac.ZodiacSign.cancer: [
        'Ağlamıyorum, gözüme duygularım kaçtı 🥲',
        'Ev mi dışarı mı? Ev. Her zaman ev 🏠',
        'Kabuğuma çekiliyorum ama WiFi var 🦀',
        'Koruyucu değilim, sadece herkes bebek gibi 👶',
      ],
      zodiac.ZodiacSign.leo: [
        'Kompliman beklemiyorum ama... neden gelmiyor? 👑',
        'Drama queen? Hayır, oscar ödüllü 🏆',
        'Egom mu? Adına özgüven diyelim ✨',
        'İlgi mi istiyorum? Hak ediyorum 💅',
      ],
      zodiac.ZodiacSign.virgo: [
        'Eleştirmiyorum, geliştiriyorum 📝',
        'Mükemmeliyetçi değilim, standartlarım yüksek 💯',
        'Takıntılı değilim, detaycıyım 🔍',
        'Temizlik değil, hijyen bilinci 🧹',
      ],
      zodiac.ZodiacSign.libra: [
        'Kararsız değilim, adil olmaya çalışıyorum ⚖️',
        'Herkes mutlu olsun istiyorum, sorun mu? 🥰',
        'Estetik takıntısı değil, göz zevki 🎨',
        'Flörtöz mü? Sadece nazik 💋',
      ],
      zodiac.ZodiacSign.scorpio: [
        'Gizemli değilim, sormadınız 🤫',
        'İntikamcı değilim, sadece unutmuyorum 🦂',
        'Yoğun mu? Sıkıcı olmaktansa... 🔥',
        'Kıskanç değilim, sahipleniyorum 💀',
      ],
      zodiac.ZodiacSign.sagittarius: [
        'Kaçmıyorum, keşfediyorum 🌍',
        'Taahhüt mü? Yarın konuşalım ✈️',
        'Brutally honest? Truth hurts 🎯',
        'Pozitifim çünkü negatiflik yoruyor 🌈',
      ],
      zodiac.ZodiacSign.capricorn: [
        'Workaholic değilim, başarı odaklıyım 💼',
        'Soğuk değilim, profesyonelim 🧊',
        'Plan yapmak hobi değil, yaşam tarzı 📈',
        'Hırslı mı? Hedef odaklı diyelim 🎯',
      ],
      zodiac.ZodiacSign.aquarius: [
        'Garip değilim, zamandan önceyim 👽',
        'Duygusuz değilim, farklı ifade ediyorum 🤖',
        'Asi mi? Sisteme karşı değilim, onu değiştiriyorum 🦄',
        'Bağımsızım çünkü kimse ayak uyduramıyor 🚀',
      ],
      zodiac.ZodiacSign.pisces: [
        'Hayalperest değilim, vizyonerim 🌙',
        'Hassas mı? Empatik diyelim 💫',
        'Kaçıyorum mu? Yüzüyorum 🐟',
        'Duygusal zeka? Tanrı seviyesi 🔮',
      ],
    };
    final signMessages = messages[sign] ?? ['Yıldızlar bugün seninle 🌟'];
    return signMessages[day % signMessages.length];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BIG THREE - Kompakt versiyon
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBigThreeCompact() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBigThreeItem('☀️', 'GÜNEŞ', sign),
          Container(width: 1, height: 35, color: Colors.white.withOpacity(0.1)),
          _buildBigThreeItem('🌙', 'AY', moonSign ?? sign),
          Container(width: 1, height: 35, color: Colors.white.withOpacity(0.1)),
          _buildBigThreeItem('⬆️', 'YÜKSELEN', risingSign ?? sign),
        ],
      ),
    );
  }

  Widget _buildBigThreeItem(
    String emoji,
    String label,
    zodiac.ZodiacSign itemSign,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              itemSign.symbol,
              style: TextStyle(fontSize: 16, color: itemSign.color),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          itemSign.nameTr,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VİRAL TRAITS - Etiketler
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildViralTraits() {
    final traits = _getViralTraits(sign);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: traits
          .map(
            (trait) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    sign.color.withOpacity(0.35),
                    sign.color.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: sign.color.withOpacity(0.5)),
              ),
              child: Text(
                trait,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<String> _getViralTraits(zodiac.ZodiacSign sign) {
    final traits = {
      zodiac.ZodiacSign.aries: [
        '🔥 ATEŞLI',
        '💪 GÜÇLÜ',
        '🏃 HIZLI',
        '👑 LİDER',
      ],
      zodiac.ZodiacSign.taurus: [
        '💰 ZENGİN VİBE',
        '🍕 GURME',
        '💎 LÜKS',
        '🐂 SADIK',
      ],
      zodiac.ZodiacSign.gemini: [
        '🎭 ÇİFT KİŞİLİK',
        '💬 KONUŞKAN',
        '🧠 ZEKİ',
        '🦋 DEĞİŞKEN',
      ],
      zodiac.ZodiacSign.cancer: [
        '🏠 EV KURDU',
        '🥲 DUYGUSAL',
        '🦀 KORUYUCU',
        '💕 SEVGİ DOLU',
      ],
      zodiac.ZodiacSign.leo: [
        '👑 KRAL/KRALİÇE',
        '✨ PARLAK',
        '🦁 CESUR',
        '💅 DRAMA',
      ],
      zodiac.ZodiacSign.virgo: [
        '💯 MÜKEMMELİYETÇİ',
        '🔍 DETAYCI',
        '📝 ORGANİZE',
        '🧹 TEMİZ',
      ],
      zodiac.ZodiacSign.libra: [
        '⚖️ DENGELİ',
        '🎨 ESTETİK',
        '💋 FLÖRTÖZ',
        '🥰 UYUMLU',
      ],
      zodiac.ZodiacSign.scorpio: [
        '🦂 GİZEMLİ',
        '🔥 TUTKULU',
        '👀 SEZGİSEL',
        '💀 YOĞUN',
      ],
      zodiac.ZodiacSign.sagittarius: [
        '✈️ MACERACI',
        '🌍 GEZGN',
        '🎯 DÜRÜST',
        '🌈 POZİTİF',
      ],
      zodiac.ZodiacSign.capricorn: [
        '💼 CEO VİBE',
        '🎯 HEDEF ODAKLI',
        '📈 BAŞARILI',
        '🏆 HIRSLII',
      ],
      zodiac.ZodiacSign.aquarius: [
        '👽 FARKLI',
        '🦄 ÖZGÜN',
        '🚀 YENİLİKÇİ',
        '🔥 ASİ',
      ],
      zodiac.ZodiacSign.pisces: [
        '🌙 HAYALPEREST',
        '💫 SEZGİSEL',
        '🐟 AKIŞKAN',
        '🔮 MİSTİK',
      ],
    };
    return traits[sign] ?? ['✨ ÖZEL', '🌟 BENZERSİZ'];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EZOTERİK GÜNLÜK - Kristal, Tarot, Çakra
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildEsotericDaily() {
    final crystal = _getDailyCrystal(sign);
    final tarot = _getDailyTarot(sign);
    final chakra = _getDailyChakra(sign);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF9C27B0).withOpacity(0.25),
            const Color(0xFF673AB7).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF9C27B0).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEsotericItem(
            '💎',
            'KRİSTAL',
            crystal['name']!,
            crystal['emoji']!,
          ),
          Container(width: 1, height: 35, color: Colors.white.withOpacity(0.1)),
          _buildEsotericItem('🃏', 'TAROT', tarot['name']!, tarot['emoji']!),
          Container(width: 1, height: 35, color: Colors.white.withOpacity(0.1)),
          _buildEsotericItem('🔮', 'ÇAKRA', chakra['name']!, chakra['emoji']!),
        ],
      ),
    );
  }

  Widget _buildEsotericItem(
    String emoji,
    String label,
    String value,
    String valueEmoji,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.6),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(valueEmoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 3),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, String> _getDailyCrystal(zodiac.ZodiacSign sign) {
    final day = DateTime.now().day % 4;
    final crystals = {
      zodiac.ZodiacSign.aries: [
        {'name': 'Karnelian', 'emoji': '🔴'},
        {'name': 'Sitrin', 'emoji': '🟡'},
        {'name': 'Kırmızı Jasper', 'emoji': '🔴'},
        {'name': 'Hematit', 'emoji': '⚫'},
      ],
      zodiac.ZodiacSign.taurus: [
        {'name': 'Roze Kuvars', 'emoji': '💖'},
        {'name': 'Yeşil Aventurin', 'emoji': '💚'},
        {'name': 'Malakit', 'emoji': '💚'},
        {'name': 'Lapis Lazuli', 'emoji': '💙'},
      ],
      zodiac.ZodiacSign.gemini: [
        {'name': 'Akvamarin', 'emoji': '💎'},
        {'name': 'Kaplan Gözü', 'emoji': '🟤'},
        {'name': 'Sitrin', 'emoji': '🟡'},
        {'name': 'Fluorit', 'emoji': '💜'},
      ],
      zodiac.ZodiacSign.cancer: [
        {'name': 'Ay Taşı', 'emoji': '🌙'},
        {'name': 'İnci', 'emoji': '⚪'},
        {'name': 'Roze Kuvars', 'emoji': '💖'},
        {'name': 'Selenit', 'emoji': '✨'},
      ],
      zodiac.ZodiacSign.leo: [
        {'name': 'Kaplan Gözü', 'emoji': '🟤'},
        {'name': 'Güneş Taşı', 'emoji': '🧡'},
        {'name': 'Pirit', 'emoji': '💛'},
        {'name': 'Sitrin', 'emoji': '🟡'},
      ],
      zodiac.ZodiacSign.virgo: [
        {'name': 'Amazonit', 'emoji': '💚'},
        {'name': 'Yeşil Aventurin', 'emoji': '💚'},
        {'name': 'Peridot', 'emoji': '💚'},
        {'name': 'Dumanlı Kuvars', 'emoji': '🤎'},
      ],
      zodiac.ZodiacSign.libra: [
        {'name': 'Lepidolit', 'emoji': '💜'},
        {'name': 'Roze Kuvars', 'emoji': '💖'},
        {'name': 'Lapis Lazuli', 'emoji': '💙'},
        {'name': 'Opal', 'emoji': '🌈'},
      ],
      zodiac.ZodiacSign.scorpio: [
        {'name': 'Obsidyen', 'emoji': '⚫'},
        {'name': 'Labradorit', 'emoji': '💙'},
        {'name': 'Granat', 'emoji': '🔴'},
        {'name': 'Malakit', 'emoji': '💚'},
      ],
      zodiac.ZodiacSign.sagittarius: [
        {'name': 'Turkuaz', 'emoji': '💎'},
        {'name': 'Ametist', 'emoji': '💜'},
        {'name': 'Lapis Lazuli', 'emoji': '💙'},
        {'name': 'Sodalit', 'emoji': '💙'},
      ],
      zodiac.ZodiacSign.capricorn: [
        {'name': 'Granat', 'emoji': '🔴'},
        {'name': 'Oniks', 'emoji': '⚫'},
        {'name': 'Dumanlı Kuvars', 'emoji': '🤎'},
        {'name': 'Obsidyen', 'emoji': '⚫'},
      ],
      zodiac.ZodiacSign.aquarius: [
        {'name': 'Ametist', 'emoji': '💜'},
        {'name': 'Akvamarin', 'emoji': '💎'},
        {'name': 'Labradorit', 'emoji': '💙'},
        {'name': 'Fluorit', 'emoji': '💜'},
      ],
      zodiac.ZodiacSign.pisces: [
        {'name': 'Ametist', 'emoji': '💜'},
        {'name': 'Ay Taşı', 'emoji': '🌙'},
        {'name': 'Akvamarin', 'emoji': '💎'},
        {'name': 'Lepidolit', 'emoji': '💜'},
      ],
    };
    final signCrystals =
        crystals[sign] ??
        [
          {'name': 'Kuvars', 'emoji': '💎'},
        ];
    return signCrystals[day];
  }

  Map<String, String> _getDailyTarot(zodiac.ZodiacSign sign) {
    final day = DateTime.now().day % 4;
    final tarots = {
      zodiac.ZodiacSign.aries: [
        {'name': 'İmparator', 'emoji': '👑'},
        {'name': 'Kule', 'emoji': '🗼'},
        {'name': 'Savaş Arabası', 'emoji': '🏎️'},
        {'name': 'Güç', 'emoji': '💪'},
      ],
      zodiac.ZodiacSign.taurus: [
        {'name': 'İmparatoriçe', 'emoji': '👸'},
        {'name': 'Hierofant', 'emoji': '🙏'},
        {'name': 'Dünya', 'emoji': '🌍'},
        {'name': 'Para Asası', 'emoji': '💰'},
      ],
      zodiac.ZodiacSign.gemini: [
        {'name': 'Aşıklar', 'emoji': '💑'},
        {'name': 'Sihirbaz', 'emoji': '🎩'},
        {'name': 'Kılıç 2', 'emoji': '⚔️'},
        {'name': 'Sayfa', 'emoji': '📜'},
      ],
      zodiac.ZodiacSign.cancer: [
        {'name': 'Savaş Arabası', 'emoji': '🏎️'},
        {'name': 'Ay', 'emoji': '🌙'},
        {'name': 'Kupa Asası', 'emoji': '🏆'},
        {'name': 'Yüksek Rahibe', 'emoji': '🧙‍♀️'},
      ],
      zodiac.ZodiacSign.leo: [
        {'name': 'Güç', 'emoji': '💪'},
        {'name': 'Güneş', 'emoji': '☀️'},
        {'name': 'Asa Kralı', 'emoji': '👑'},
        {'name': 'Yıldız', 'emoji': '⭐'},
      ],
      zodiac.ZodiacSign.virgo: [
        {'name': 'Münzevi', 'emoji': '🧘'},
        {'name': 'Para 8', 'emoji': '💵'},
        {'name': 'Adalet', 'emoji': '⚖️'},
        {'name': 'Para Kraliçesi', 'emoji': '👑'},
      ],
      zodiac.ZodiacSign.libra: [
        {'name': 'Adalet', 'emoji': '⚖️'},
        {'name': 'Aşıklar', 'emoji': '💑'},
        {'name': 'Kılıç Kraliçesi', 'emoji': '👑'},
        {'name': 'Ölçülülük', 'emoji': '⚖️'},
      ],
      zodiac.ZodiacSign.scorpio: [
        {'name': 'Ölüm', 'emoji': '💀'},
        {'name': 'Kule', 'emoji': '🗼'},
        {'name': 'Kupa Kralı', 'emoji': '👑'},
        {'name': 'Şeytan', 'emoji': '😈'},
      ],
      zodiac.ZodiacSign.sagittarius: [
        {'name': 'Ölçülülük', 'emoji': '⚖️'},
        {'name': 'Çark', 'emoji': '🎡'},
        {'name': 'Asa Şövalyesi', 'emoji': '🏇'},
        {'name': 'Yıldız', 'emoji': '⭐'},
      ],
      zodiac.ZodiacSign.capricorn: [
        {'name': 'Şeytan', 'emoji': '😈'},
        {'name': 'İmparator', 'emoji': '👑'},
        {'name': 'Dünya', 'emoji': '🌍'},
        {'name': 'Para Kralı', 'emoji': '👑'},
      ],
      zodiac.ZodiacSign.aquarius: [
        {'name': 'Yıldız', 'emoji': '⭐'},
        {'name': 'Aptal', 'emoji': '🃏'},
        {'name': 'Kılıç Asası', 'emoji': '⚔️'},
        {'name': 'Çark', 'emoji': '🎡'},
      ],
      zodiac.ZodiacSign.pisces: [
        {'name': 'Ay', 'emoji': '🌙'},
        {'name': 'Asılı Adam', 'emoji': '🙃'},
        {'name': 'Kupa Asası', 'emoji': '🏆'},
        {'name': 'Yüksek Rahibe', 'emoji': '🧙‍♀️'},
      ],
    };
    final signTarots =
        tarots[sign] ??
        [
          {'name': 'Aptal', 'emoji': '🃏'},
        ];
    return signTarots[day];
  }

  Map<String, String> _getDailyChakra(zodiac.ZodiacSign sign) {
    final chakras = {
      zodiac.ZodiacSign.aries: {'name': 'Kök', 'emoji': '🔴'},
      zodiac.ZodiacSign.taurus: {'name': 'Sakral', 'emoji': '🟠'},
      zodiac.ZodiacSign.gemini: {'name': 'Boğaz', 'emoji': '💙'},
      zodiac.ZodiacSign.cancer: {'name': 'Kalp', 'emoji': '💚'},
      zodiac.ZodiacSign.leo: {'name': 'Solar', 'emoji': '💛'},
      zodiac.ZodiacSign.virgo: {'name': 'Solar', 'emoji': '💛'},
      zodiac.ZodiacSign.libra: {'name': 'Kalp', 'emoji': '💚'},
      zodiac.ZodiacSign.scorpio: {'name': 'Sakral', 'emoji': '🟠'},
      zodiac.ZodiacSign.sagittarius: {'name': 'Üçüncü Göz', 'emoji': '💜'},
      zodiac.ZodiacSign.capricorn: {'name': 'Kök', 'emoji': '🔴'},
      zodiac.ZodiacSign.aquarius: {'name': 'Taç', 'emoji': '👑'},
      zodiac.ZodiacSign.pisces: {'name': 'Taç', 'emoji': '👑'},
    };
    return chakras[sign] ?? {'name': 'Kalp', 'emoji': '💚'};
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // KOZMİK TAVSİYE - Günlük uyarı/tavsiye
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCosmicAdvice() {
    final advice = _getCosmicAdvice(sign);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MysticalColors.starGold.withOpacity(0.2),
            const Color(0xFFFF6B9D).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MysticalColors.starGold.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Text('🌟', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KOZMİK TAVSİYE',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: MysticalColors.starGold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  advice,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCosmicAdvice(zodiac.ZodiacSign sign) {
    final day = DateTime.now().day % 4;
    final advices = {
      zodiac.ZodiacSign.aries: [
        'Sabır senin süper gücün olabilir, dene 🔥',
        'Bugün geri adım at, yarın savaş 💪',
        'Öfken değil, tutkun konuşsun ✨',
        'Liderlik bazen dinlemekle başlar 👑',
      ],
      zodiac.ZodiacSign.taurus: [
        'Konfor alanından bir adım at bugün 🌱',
        'Değişim düşman değil, dost 💫',
        'Bugün bir şeyi bırakmayı dene 🦋',
        'Maddeyi değil, anlamı biriktir 💎',
      ],
      zodiac.ZodiacSign.gemini: [
        'Bir şeye odaklan, derinleş 🎯',
        'Bugün dinle, yarın konuş 👂',
        'Tutarlılık senin gizli silahın 🗡️',
        'İki seçenek arasında kal - bu sefer seç 🦋',
      ],
      zodiac.ZodiacSign.cancer: [
        'Kabuğundan çık, güneşi gör ☀️',
        'Geçmişi bırak, şimdiye gel 🌸',
        'Duyguların gerçek değil, hisler geçici 🌊',
        'Korumak yerine güvenmeyi dene 💕',
      ],
      zodiac.ZodiacSign.leo: [
        'Işık başkalarında da parlasın bırak ✨',
        'Ego değil, kalp konuşsun bugün 💛',
        'Alkış beklemeden yap 👏',
        'Zafer paylaşınca büyür 🦁',
      ],
      zodiac.ZodiacSign.virgo: [
        'Kusur değil, gelişim gör bugün 🌱',
        '"Yeterince iyi" bazen mükemmeldir 💯',
        'Kendine de şefkat göster 💝',
        'Detaylarda kaybolma, büyük resmi gör 🖼️',
      ],
      zodiac.ZodiacSign.libra: [
        'Karar ver ve arkana bakma 🎯',
        'Herkes mutlu olmak zorunda değil ⚖️',
        'Kendi dengenin önce gel 🧘',
        'Hayır demek de sevgi olabilir 💕',
      ],
      zodiac.ZodiacSign.scorpio: [
        'Kontrol etme, akışa bırak 🌊',
        'İntikam yerine serbest bırak 🦋',
        'Güvenmek cesaret ister, cesaretlisin 💪',
        'Gölgeler ışığın kaynağını gösterir 🔦',
      ],
      zodiac.ZodiacSign.sagittarius: [
        'Şimdi de güzel, sonrasını bekle 🎯',
        'Derinleş, yüzeyde kalma 🏊',
        'Macera içerde de olabilir 🧠',
        'Özgürlük sorumlulukla gelir 🦅',
      ],
      zodiac.ZodiacSign.capricorn: [
        'Mola ver, dünya dönmeye devam eder 🌍',
        'Başarı sadece zirve değil, yolculuk 🏔️',
        'Duygular zayıflık değil, güç 💪',
        'Bugün sadece keyif al, başarma 🎉',
      ],
      zodiac.ZodiacSign.aquarius: [
        'Farklı olmak için değil, kendin için yap 🦄',
        'Bağlanmak kaybetmek değil 💕',
        'Bugün kalple düşün 💜',
        'İnsanlık soyut değil, yanındakilerle başlar 👥',
      ],
      zodiac.ZodiacSign.pisces: [
        'Hayal ile gerçek arasında köprü kur 🌈',
        'Sınırlar korur, hapsetmez 🛡️',
        'Duygular pusula, harita değil 🧭',
        'Bugün ayaklarını yere bas 🌍',
      ],
    };
    final signAdvices = advices[sign] ?? ['Yıldızlar seninle ✨'];
    return signAdvices[day];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LUCK METER - Gamification
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildLuckMeter() {
    final luck =
        (sign.index + DateTime.now().day + DateTime.now().hour) % 5 + 6;
    final luckEmoji = luck >= 9
        ? '🔥'
        : luck >= 7
        ? '✨'
        : '💫';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MysticalColors.starGold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(luckEmoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    'BUGÜNÜN ŞANSI',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MysticalColors.starGold, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$luck/10',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: luck / 10,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                luck >= 8
                    ? Colors.green
                    : luck >= 6
                    ? MysticalColors.starGold
                    : Colors.orange,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOVE TEASER - Aşk uyumu teaser
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildLoveTeaser() {
    final bestMatch = _getBestMatch(sign);
    final worstMatch = _getWorstMatch(sign);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE91E63).withOpacity(0.2),
            const Color(0xFF9C27B0).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMatchItem('💕', 'UYUMLU', bestMatch, true),
          Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
          _buildMatchItem('💔', 'DİKKAT', worstMatch, false),
        ],
      ),
    );
  }

  Widget _buildMatchItem(
    String emoji,
    String label,
    zodiac.ZodiacSign matchSign,
    bool isGood,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.6),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (isGood ? Colors.green : Colors.red).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (isGood ? Colors.green : Colors.red).withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(matchSign.symbol, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 3),
              Text(
                matchSign.nameTr,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  zodiac.ZodiacSign _getBestMatch(zodiac.ZodiacSign sign) {
    final matches = {
      zodiac.ZodiacSign.aries: zodiac.ZodiacSign.leo,
      zodiac.ZodiacSign.taurus: zodiac.ZodiacSign.virgo,
      zodiac.ZodiacSign.gemini: zodiac.ZodiacSign.libra,
      zodiac.ZodiacSign.cancer: zodiac.ZodiacSign.scorpio,
      zodiac.ZodiacSign.leo: zodiac.ZodiacSign.sagittarius,
      zodiac.ZodiacSign.virgo: zodiac.ZodiacSign.capricorn,
      zodiac.ZodiacSign.libra: zodiac.ZodiacSign.aquarius,
      zodiac.ZodiacSign.scorpio: zodiac.ZodiacSign.pisces,
      zodiac.ZodiacSign.sagittarius: zodiac.ZodiacSign.aries,
      zodiac.ZodiacSign.capricorn: zodiac.ZodiacSign.taurus,
      zodiac.ZodiacSign.aquarius: zodiac.ZodiacSign.gemini,
      zodiac.ZodiacSign.pisces: zodiac.ZodiacSign.cancer,
    };
    return matches[sign] ?? zodiac.ZodiacSign.aries;
  }

  zodiac.ZodiacSign _getWorstMatch(zodiac.ZodiacSign sign) {
    final matches = {
      zodiac.ZodiacSign.aries: zodiac.ZodiacSign.cancer,
      zodiac.ZodiacSign.taurus: zodiac.ZodiacSign.aquarius,
      zodiac.ZodiacSign.gemini: zodiac.ZodiacSign.virgo,
      zodiac.ZodiacSign.cancer: zodiac.ZodiacSign.aries,
      zodiac.ZodiacSign.leo: zodiac.ZodiacSign.scorpio,
      zodiac.ZodiacSign.virgo: zodiac.ZodiacSign.sagittarius,
      zodiac.ZodiacSign.libra: zodiac.ZodiacSign.capricorn,
      zodiac.ZodiacSign.scorpio: zodiac.ZodiacSign.leo,
      zodiac.ZodiacSign.sagittarius: zodiac.ZodiacSign.virgo,
      zodiac.ZodiacSign.capricorn: zodiac.ZodiacSign.libra,
      zodiac.ZodiacSign.aquarius: zodiac.ZodiacSign.taurus,
      zodiac.ZodiacSign.pisces: zodiac.ZodiacSign.gemini,
    };
    return matches[sign] ?? zodiac.ZodiacSign.aries;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FOOTER CTA & BRANDING
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildFooterCTA() {
    return Column(
      children: [
        // Swipe up teaser
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MysticalColors.starGold.withOpacity(0.3),
                const Color(0xFFFF6B9D).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: MysticalColors.starGold.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('👆', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                'SENİN BURÇ ANALİZİN İÇİN',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Branding
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 1,
              color: MysticalColors.starGold.withOpacity(0.4),
            ),
            const SizedBox(width: 10),
            Text(
              '✨ ASTROBOBO ✨',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: MysticalColors.starGold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 30,
              height: 1,
              color: MysticalColors.starGold.withOpacity(0.4),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════
  String _getElementEmoji(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire:
        return '🔥';
      case zodiac.Element.earth:
        return '🌍';
      case zodiac.Element.air:
        return '💨';
      case zodiac.Element.water:
        return '💧';
    }
  }

  String _getElementName(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire:
        return 'ATEŞ';
      case zodiac.Element.earth:
        return 'TOPRAK';
      case zodiac.Element.air:
        return 'HAVA';
      case zodiac.Element.water:
        return 'SU';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAINTERS
// ═══════════════════════════════════════════════════════════════════════════

class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final paint = Paint()..color = Colors.white;

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      final opacity = random.nextDouble() * 0.5 + 0.3;

      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConstellationPainter extends CustomPainter {
  final Color color;

  _ConstellationPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final random = math.Random(123);

    for (int i = 0; i < 8; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = startX + (random.nextDouble() - 0.5) * 100;
      final endY = startY + (random.nextDouble() - 0.5) * 100;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      final dotPaint = Paint()..color = color.withOpacity(0.3);
      canvas.drawCircle(Offset(startX, startY), 2, dotPaint);
      canvas.drawCircle(Offset(endX, endY), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
