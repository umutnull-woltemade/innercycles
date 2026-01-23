import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../shared/widgets/cosmic_background.dart';

/// Kozmoz - Tüm çözümlemeler ve kozmik keşifler (sadece text)
class KozmozScreen extends StatefulWidget {
  const KozmozScreen({super.key});

  @override
  State<KozmozScreen> createState() => _KozmozScreenState();
}

class _KozmozScreenState extends State<KozmozScreen> {
  // Hover/tap edilen item index'i
  int? _hoveredIndex;

  // Tüm çözümlemeler ve özellikler - TAM LİSTE
  final List<Map<String, dynamic>> _allFeatures = [
    // ════════════════════════════════════════════════════
    // ÖZEL ÇÖZÜMLEMELERİMİZ - Profil Bazlı Analizler
    // ════════════════════════════════════════════════════
    {'name': 'Doğum Haritası', 'route': Routes.birthChart, 'category': 'ozel'},
    {'name': 'Burç Uyumu', 'route': Routes.compatibility, 'category': 'ozel'},
    {'name': 'Sinastri Analizi', 'route': Routes.synastry, 'category': 'ozel'},
    {'name': 'Kompozit Harita', 'route': Routes.compositeChart, 'category': 'ozel'},
    {'name': 'Transitler', 'route': Routes.transits, 'category': 'ozel'},
    {'name': 'Transit Takvimi', 'route': Routes.transitCalendar, 'category': 'ozel'},
    {'name': 'Progresyonlar', 'route': Routes.progressions, 'category': 'ozel'},
    {'name': 'Saturn Dönüşü', 'route': Routes.saturnReturn, 'category': 'ozel'},
    {'name': 'Solar Return', 'route': Routes.solarReturn, 'category': 'ozel'},
    {'name': 'Yıl Öngörüsü', 'route': Routes.yearAhead, 'category': 'ozel'},
    {'name': 'Vedik Harita', 'route': Routes.vedicChart, 'category': 'ozel'},
    {'name': 'Drakonik Harita', 'route': Routes.draconicChart, 'category': 'ozel'},
    {'name': 'Asteroidler', 'route': Routes.asteroids, 'category': 'ozel'},
    {'name': 'Astrokartografi', 'route': Routes.astroCartography, 'category': 'ozel'},
    {'name': 'Yerel Uzay', 'route': Routes.localSpace, 'category': 'ozel'},
    {'name': 'Elektif Astroloji', 'route': Routes.electional, 'category': 'ozel'},
    {'name': 'Zamanlama', 'route': Routes.timing, 'category': 'ozel'},
    {'name': 'Numeroloji', 'route': Routes.numerology, 'category': 'ozel'},
    {'name': 'Kozmik Özet', 'route': Routes.shareSummary, 'category': 'ozel'},

    // ════════════════════════════════════════════════════
    // BURÇ YORUMLARI
    // ════════════════════════════════════════════════════
    {'name': 'Günlük Burç', 'route': Routes.horoscope, 'category': 'burc'},
    {'name': 'Haftalık Burç', 'route': Routes.weeklyHoroscope, 'category': 'burc'},
    {'name': 'Aylık Burç', 'route': Routes.monthlyHoroscope, 'category': 'burc'},
    {'name': 'Yıllık Burç', 'route': Routes.yearlyHoroscope, 'category': 'burc'},
    {'name': 'Aşk Burcu', 'route': Routes.loveHoroscope, 'category': 'burc'},

    // ════════════════════════════════════════════════════
    // MİSTİK ARAÇLAR
    // ════════════════════════════════════════════════════
    {'name': 'Rüya Tabiri', 'route': Routes.dreamInterpretation, 'category': 'mistik'},
    {'name': 'Tarot Falı', 'route': Routes.tarot, 'category': 'mistik'},
    {'name': 'Kabala', 'route': Routes.kabbalah, 'category': 'mistik'},
    {'name': 'Aura Analizi', 'route': Routes.aura, 'category': 'mistik'},
    {'name': 'Çakra Analizi', 'route': Routes.chakraAnalysis, 'category': 'mistik'},
    {'name': 'Kristal Rehberi', 'route': Routes.crystalGuide, 'category': 'mistik'},
    {'name': 'Günlük Ritüel', 'route': Routes.dailyRituals, 'category': 'mistik'},
    {'name': 'Ay Ritüelleri', 'route': Routes.moonRituals, 'category': 'mistik'},

    // ════════════════════════════════════════════════════
    // KOZMİK KEŞİF - Viral & Felsefi İçerikler (Özel Sayfalar)
    // ════════════════════════════════════════════════════
    {'name': 'Bugünün Özeti', 'route': Routes.dailySummary, 'category': 'kesif'},
    {'name': 'Ay Enerjisi', 'route': Routes.moonEnergy, 'category': 'kesif'},
    {'name': 'Aşk Enerjisi', 'route': Routes.loveEnergy, 'category': 'kesif'},
    {'name': 'Bolluk Enerjisi', 'route': Routes.abundanceEnergy, 'category': 'kesif'},
    {'name': 'Ruhsal Dönüşüm', 'route': Routes.spiritualTransformation, 'category': 'kesif'},
    {'name': 'Hayat Amacın', 'route': Routes.lifePurpose, 'category': 'kesif'},
    {'name': 'Bilinçaltı Kalıpların', 'route': Routes.subconsciousPatterns, 'category': 'kesif'},
    {'name': 'Karma Derslerin', 'route': Routes.karmaLessons, 'category': 'kesif'},
    {'name': 'Ruh Sözleşmen', 'route': Routes.soulContract, 'category': 'kesif'},
    {'name': 'İçsel Gücün', 'route': Routes.innerPower, 'category': 'kesif'},
    {'name': 'Gölge Benliğin', 'route': Routes.shadowSelf, 'category': 'kesif'},
    {'name': 'Liderlik Stilin', 'route': Routes.leadershipStyle, 'category': 'kesif'},
    {'name': 'Kalp Yaran', 'route': Routes.heartbreak, 'category': 'kesif'},
    {'name': 'Red Flag\'lerin', 'route': Routes.redFlags, 'category': 'kesif'},
    {'name': 'Green Flag\'lerin', 'route': Routes.greenFlags, 'category': 'kesif'},
    {'name': 'Flört Stilin', 'route': Routes.flirtStyle, 'category': 'kesif'},
    {'name': 'Tarot Kartın', 'route': Routes.tarotCard, 'category': 'kesif'},
    {'name': 'Aura Rengin', 'route': Routes.auraColor, 'category': 'kesif'},
    {'name': 'Çakra Dengen', 'route': Routes.chakraBalance, 'category': 'kesif'},
    {'name': 'Yaşam Sayın', 'route': Routes.lifeNumber, 'category': 'kesif'},
    {'name': 'Kabala Yolun', 'route': Routes.kabbalaPath, 'category': 'kesif'},
    {'name': 'Saturn Derslerin', 'route': Routes.saturnLessons, 'category': 'kesif'},
    {'name': 'Doğum Günü Enerjin', 'route': Routes.birthdayEnergy, 'category': 'kesif'},
    {'name': 'Tutulma Etkisi', 'route': Routes.eclipseEffect, 'category': 'kesif'},
    {'name': 'Transit Akışı', 'route': Routes.transitFlow, 'category': 'kesif'},
    {'name': 'Uyum Analizi', 'route': Routes.compatibilityAnalysis, 'category': 'kesif'},
    {'name': 'Ruh Eşin', 'route': Routes.soulMate, 'category': 'kesif'},
    {'name': 'İlişki Karman', 'route': Routes.relationshipKarma, 'category': 'kesif'},
    {'name': 'Ünlü İkizin', 'route': Routes.celebrityTwin, 'category': 'kesif'},

    // ════════════════════════════════════════════════════
    // TAKVİM & DÖNGÜLER
    // ════════════════════════════════════════════════════
    {'name': 'Tutulma Takvimi', 'route': Routes.eclipseCalendar, 'category': 'takvim'},
    {'name': 'Bahçe Ayı', 'route': Routes.gardeningMoon, 'category': 'takvim'},

    // ════════════════════════════════════════════════════
    // BİLGİ & İÇERİK
    // ════════════════════════════════════════════════════
    {'name': 'Ünlü Haritaları', 'route': Routes.celebrities, 'category': 'bilgi'},
    {'name': 'Makaleler', 'route': Routes.articles, 'category': 'bilgi'},
    {'name': 'Astroloji Sözlük', 'route': Routes.glossary, 'category': 'bilgi'},

    // ════════════════════════════════════════════════════
    // PROFİL YÖNETİMİ
    // ════════════════════════════════════════════════════
    {'name': 'Kayıtlı Profiller', 'route': Routes.savedProfiles, 'category': 'profil'},
    {'name': 'Profil Karşılaştır', 'route': Routes.comparison, 'category': 'profil'},
    {'name': 'Ayarlar', 'route': Routes.settings, 'category': 'profil'},
    {'name': 'Profil', 'route': Routes.profile, 'category': 'profil'},
    {'name': 'Premium', 'route': Routes.premium, 'category': 'profil'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Çözümlemeler Listesi
              Expanded(
                child: _buildFeaturesList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Geri butonu
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF6B9D), Color(0xFF9D4EDD)],
                  ).createShader(bounds),
                  child: const Text(
                    'KOZMOZ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                Text(
                  'Tüm Çözümlemeler & Keşifler',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    // Kategorilere göre grupla - TAM LİSTE
    final categories = [
      {'key': 'ozel', 'title': '✨ Özel Çözümlemeler', 'color': const Color(0xFFFFD700)},
      {'key': 'burc', 'title': '⭐ Burç Yorumları', 'color': const Color(0xFFFF6B9D)},
      {'key': 'kesif', 'title': '🦋 Kozmik Keşif', 'color': const Color(0xFFE91E63)},
      {'key': 'mistik', 'title': '🔮 Mistik Araçlar', 'color': const Color(0xFF9D4EDD)},
      {'key': 'takvim', 'title': '📅 Takvim & Döngüler', 'color': const Color(0xFF00BCD4)},
      {'key': 'bilgi', 'title': '📚 Bilgi & İçerik', 'color': const Color(0xFFFF9800)},
      {'key': 'profil', 'title': '👤 Profil & Ayarlar', 'color': const Color(0xFF4CAF50)},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: categories.length,
      itemBuilder: (context, categoryIndex) {
        final category = categories[categoryIndex];
        final categoryItems = _allFeatures
            .asMap()
            .entries
            .where((e) => e.value['category'] == category['key'])
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori başlığı
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                category['title'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: category['color'] as Color,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Kategori itemları - Wrap ile text listesi
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categoryItems.map((entry) {
                final globalIndex = entry.key;
                final item = entry.value;
                return _buildTextItem(context, item, globalIndex, category['color'] as Color);
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildTextItem(BuildContext context, Map<String, dynamic> item, int index, Color categoryColor) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _hoveredIndex = index),
        onTapUp: (_) {
          context.push(item['route'] as String);
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) setState(() => _hoveredIndex = null);
          });
        },
        onTapCancel: () => setState(() => _hoveredIndex = null),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            fontSize: isHovered ? 15 : 13,
            fontWeight: isHovered ? FontWeight.w700 : FontWeight.w400,
            color: isHovered ? Colors.white : Colors.white.withOpacity(0.7),
            shadows: isHovered
                ? [
                    Shadow(
                      color: categoryColor.withOpacity(0.8),
                      blurRadius: 12,
                    ),
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
          child: Text(item['name'] as String),
        ),
      ),
    );
  }
}

