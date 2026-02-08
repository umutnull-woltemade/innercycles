import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/mystical_colors.dart';
import '../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../data/providers/app_providers.dart';
import '../../../data/services/l10n_service.dart';

/// Instagram Story formatına uygun kart (1080x1920 - 9:16)
/// VİRAL & PAYLAŞILABILIR - Instagram trendlerine uygun
class InstagramStoryCard extends StatelessWidget {
  final String name;
  final zodiac.ZodiacSign sign;
  final zodiac.ZodiacSign? moonSign;
  final zodiac.ZodiacSign? risingSign;
  final DateTime? birthDate;
  final AppLanguage language;

  const InstagramStoryCard({
    super.key,
    required this.name,
    required this.sign,
    this.moonSign,
    this.risingSign,
    this.birthDate,
    this.language = AppLanguage.tr,
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
            color: sign.color.withValues(alpha: 0.4),
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
            sign.color.withValues(alpha: 0.4),
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
                  sign.color.withValues(alpha: 0.5),
                  sign.color.withValues(alpha: 0.1),
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
                  MysticalColors.cosmicPurple.withValues(alpha: 0.4),
                  MysticalColors.cosmicPurple.withValues(alpha: 0.1),
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
            const Color(0xFFFF6B9D).withValues(alpha: 0.3),
            const Color(0xFF9C27B0).withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFFFF6B9D).withValues(alpha: 0.5),
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
    final signKey = sign.name.toLowerCase();
    final hooks = L10nService.getList('share.instagram.viral_hooks.$signKey', language);
    if (hooks.isNotEmpty) return hooks;
    return [L10nService.get('share.instagram.default_hook', language)];
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
                  color: sign.color.withValues(alpha: 0.3),
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
                    sign.color.withValues(alpha: 0.5),
                    sign.color.withValues(alpha: 0.2),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: sign.color.withValues(alpha: 0.6),
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
                    shadows: [
                      Shadow(color: sign.color, blurRadius: 25),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Burç adı
        Text(
          sign.localizedName(language).toUpperCase(),
          style: GoogleFonts.cinzel(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 8,
            shadows: [
              Shadow(color: sign.color.withValues(alpha: 0.8), blurRadius: 15),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Element ve tarih
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: sign.color.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sign.color.withValues(alpha: 0.5)),
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
            Text(
              sign.dateRange,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.7),
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
            sign.color.withValues(alpha: 0.2),
            const Color(0xFF9C27B0).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sign.color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(
            '💬 ${L10nService.get('share.instagram.todays_truth', language)}',
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
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _getViralMessage(zodiac.ZodiacSign sign) {
    final day = DateTime.now().day;
    final signKey = sign.name.toLowerCase();
    final messages = L10nService.getList('share.instagram.viral_messages.$signKey', language);
    if (messages.isNotEmpty) return messages[day % messages.length];
    return L10nService.get('share.instagram.default_message', language);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BIG THREE - Kompakt versiyon
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildBigThreeCompact() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBigThreeItem('☀️', L10nService.get('share.instagram.sun', language), sign),
          Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
          _buildBigThreeItem('🌙', L10nService.get('share.instagram.moon', language), moonSign ?? sign),
          Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
          _buildBigThreeItem('⬆️', L10nService.get('share.instagram.rising', language), risingSign ?? sign),
        ],
      ),
    );
  }

  Widget _buildBigThreeItem(String emoji, String label, zodiac.ZodiacSign itemSign) {
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
          itemSign.localizedName(language),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.8),
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
      children: traits.map((trait) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              sign.color.withValues(alpha: 0.35),
              sign.color.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sign.color.withValues(alpha: 0.5)),
        ),
        child: Text(
          trait,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      )).toList(),
    );
  }

  List<String> _getViralTraits(zodiac.ZodiacSign sign) {
    final signKey = sign.name.toLowerCase();
    final traits = L10nService.getList('share.instagram.viral_traits.$signKey', language);
    if (traits.isNotEmpty) return traits;
    return L10nService.getList('share.instagram.viral_traits.default', language);
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
            const Color(0xFF9C27B0).withValues(alpha: 0.25),
            const Color(0xFF673AB7).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF9C27B0).withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEsotericItem('💎', L10nService.get('share.instagram.crystal', language), crystal['name']!, crystal['emoji']!),
          Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
          _buildEsotericItem('🃏', L10nService.get('share.instagram.tarot', language), tarot['name']!, tarot['emoji']!),
          Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
          _buildEsotericItem('🔮', L10nService.get('share.instagram.chakra', language), chakra['name']!, chakra['emoji']!),
        ],
      ),
    );
  }

  Widget _buildEsotericItem(String emoji, String label, String value, String valueEmoji) {
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
                color: Colors.white.withValues(alpha: 0.6),
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
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Map<String, String> _getDailyCrystal(zodiac.ZodiacSign sign) {
    final day = DateTime.now().day % 4;
    final signKey = sign.name.toLowerCase();
    final crystals = L10nService.getMapList('share.instagram.crystals.$signKey', language);
    if (crystals.isNotEmpty && day < crystals.length) {
      return {'name': crystals[day]['name'] ?? '', 'emoji': crystals[day]['emoji'] ?? '💎'};
    }
    final defaultCrystals = L10nService.getMapList('share.instagram.crystals.default', language);
    if (defaultCrystals.isNotEmpty) {
      return {'name': defaultCrystals[0]['name'] ?? 'Crystal', 'emoji': defaultCrystals[0]['emoji'] ?? '💎'};
    }
    return {'name': 'Crystal', 'emoji': '💎'};
  }

  Map<String, String> _getDailyTarot(zodiac.ZodiacSign sign) {
    final day = DateTime.now().day % 4;
    final signKey = sign.name.toLowerCase();
    final tarots = L10nService.getMapList('share.instagram.tarot_cards.$signKey', language);
    if (tarots.isNotEmpty && day < tarots.length) {
      return {'name': tarots[day]['name'] ?? '', 'emoji': tarots[day]['emoji'] ?? '🃏'};
    }
    final defaultTarots = L10nService.getMapList('share.instagram.tarot_cards.default', language);
    if (defaultTarots.isNotEmpty) {
      return {'name': defaultTarots[0]['name'] ?? 'Tarot', 'emoji': defaultTarots[0]['emoji'] ?? '🃏'};
    }
    return {'name': 'Tarot', 'emoji': '🃏'};
  }

  Map<String, String> _getDailyChakra(zodiac.ZodiacSign sign) {
    final signKey = sign.name.toLowerCase();
    final chakra = L10nService.getMap('share.instagram.chakras.$signKey', language);
    if (chakra.isNotEmpty) {
      return {'name': chakra['name'] ?? '', 'emoji': chakra['emoji'] ?? '💚'};
    }
    final defaultChakra = L10nService.getMap('share.instagram.chakras.default', language);
    if (defaultChakra.isNotEmpty) {
      return {'name': defaultChakra['name'] ?? 'Heart', 'emoji': defaultChakra['emoji'] ?? '💚'};
    }
    return {'name': 'Heart', 'emoji': '💚'};
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
            MysticalColors.starGold.withValues(alpha: 0.2),
            const Color(0xFFFF6B9D).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MysticalColors.starGold.withValues(alpha: 0.4)),
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
                  L10nService.get('share.instagram.cosmic_advice', language),
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
                    color: Colors.white.withValues(alpha: 0.9),
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
    final signKey = sign.name.toLowerCase();
    final advices = L10nService.getList('share.instagram.cosmic_advice.$signKey', language);
    if (advices.isNotEmpty) return advices[day % advices.length];
    return L10nService.get('share.instagram.default_advice', language);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LUCK METER - Gamification
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildLuckMeter() {
    final luck = (sign.index + DateTime.now().day + DateTime.now().hour) % 5 + 6;
    final luckEmoji = luck >= 9 ? '🔥' : luck >= 7 ? '✨' : '💫';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MysticalColors.starGold.withValues(alpha: 0.3)),
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
                    L10nService.get('share.instagram.todays_luck', language),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                luck >= 8 ? Colors.green : luck >= 6 ? MysticalColors.starGold : Colors.orange,
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
            const Color(0xFFE91E63).withValues(alpha: 0.2),
            const Color(0xFF9C27B0).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMatchItem('💕', L10nService.get('share.instagram.compatible', language), bestMatch, true),
          Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.1)),
          _buildMatchItem('💔', L10nService.get('share.instagram.warning', language), worstMatch, false),
        ],
      ),
    );
  }

  Widget _buildMatchItem(String emoji, String label, zodiac.ZodiacSign matchSign, bool isGood) {
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
                color: Colors.white.withValues(alpha: 0.6),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (isGood ? Colors.green : Colors.red).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (isGood ? Colors.green : Colors.red).withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(matchSign.symbol, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 3),
              Text(
                matchSign.localizedName(language),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
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
                MysticalColors.starGold.withValues(alpha: 0.3),
                const Color(0xFFFF6B9D).withValues(alpha: 0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: MysticalColors.starGold.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('👆', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                L10nService.get('share.instagram.for_your_sign_analysis', language),
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
            Container(width: 30, height: 1, color: MysticalColors.starGold.withValues(alpha: 0.4)),
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
            Container(width: 30, height: 1, color: MysticalColors.starGold.withValues(alpha: 0.4)),
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
      case zodiac.Element.fire: return '🔥';
      case zodiac.Element.earth: return '🌍';
      case zodiac.Element.air: return '💨';
      case zodiac.Element.water: return '💧';
    }
  }

  String _getElementName(zodiac.Element element) {
    switch (element) {
      case zodiac.Element.fire: return L10nService.get('elements.fire', language);
      case zodiac.Element.earth: return L10nService.get('elements.earth', language);
      case zodiac.Element.air: return L10nService.get('elements.air', language);
      case zodiac.Element.water: return L10nService.get('elements.water', language);
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

      paint.color = Colors.white.withValues(alpha: opacity);
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
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final random = math.Random(123);

    for (int i = 0; i < 8; i++) {
      final startX = random.nextDouble() * size.width;
      final startY = random.nextDouble() * size.height;
      final endX = startX + (random.nextDouble() - 0.5) * 100;
      final endY = startY + (random.nextDouble() - 0.5) * 100;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      final dotPaint = Paint()..color = color.withValues(alpha: 0.3);
      canvas.drawCircle(Offset(startX, startY), 2, dotPaint);
      canvas.drawCircle(Offset(endX, endY), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
