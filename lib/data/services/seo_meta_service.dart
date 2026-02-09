/// SEO Meta Service for Dynamic Meta Tag Management
/// Provides page-specific meta descriptions, titles, and structured data
library;

import '../providers/app_providers.dart';

class SeoMetaService {
  /// Get page-specific meta data for a given route
  static PageMeta getMetaForRoute(String route, {AppLanguage language = AppLanguage.tr}) {
    // Normalize route
    final normalizedRoute = route.replaceAll(RegExp(r'^/+|/+$'), '').toLowerCase();

    final metas = language == AppLanguage.tr ? _pageMetas : _pageMetasEn;
    return metas[normalizedRoute] ?? metas['home']!;
  }

  /// All page-specific meta data
  static final Map<String, PageMeta> _pageMetas = {
    // Ana Sayfa
    'home': PageMeta(
      title: 'Venus One — Kişisel Kozmik Rehberiniz | Ücretsiz Doğum Haritası',
      description: 'Ücretsiz doğum haritası, günlük burç yorumları, synastry uyum analizi ve gezegen transitleri. Swiss Ephemeris ile hesaplanan profesyonel astroloji.',
      keywords: ['astroloji', 'doğum haritası', 'burç yorumu', 'natal chart', 'synastry', 'transit'],
      canonicalPath: '/',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Doğum Haritası
    'birth-chart': PageMeta(
      title: 'Ücretsiz Doğum Haritası Hesaplama | Venus One',
      description: 'Profesyonel doğum haritası hesaplayıcı. Gezegen pozisyonları, ev yerleşimleri, açılar ve yükselen burç analizi. Swiss Ephemeris hassasiyetinde.',
      keywords: ['doğum haritası', 'natal chart', 'yükselen burç', 'gezegen pozisyonları', 'astroloji haritası'],
      canonicalPath: '/birth-chart',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Günlük Burç Yorumu
    'horoscope': PageMeta(
      title: 'Günlük Burç Yorumları — 12 Burç İçin Detaylı Yorum | Venus One',
      description: 'Günlük, haftalık ve aylık burç yorumları. Aşk, kariyer, sağlık ve para konularında kozmik enerji analizi. Tüm burçlar için kişiselleştirilmiş yorumlar.',
      keywords: ['günlük burç yorumu', 'haftalık burç', 'aylık burç', 'burç falı', 'burç analizi'],
      canonicalPath: '/horoscope',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Synastry (İlişki Uyumu)
    'synastry': PageMeta(
      title: 'Synastry — İlişki Uyumu Analizi | Venus One',
      description: 'İki kişinin doğum haritaları arasındaki uyumu keşfedin. Synastry açıları, gezegen etkileşimleri ve ilişki dinamikleri analizi.',
      keywords: ['synastry', 'burç uyumu', 'ilişki uyumu', 'astroloji uyum', 'partner uyumu'],
      canonicalPath: '/synastry',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Kompozit Harita
    'composite': PageMeta(
      title: 'Kompozit Harita — İlişkinin Doğum Haritası | Venus One',
      description: 'İki kişinin birleşik haritası. İlişkinizin ortak enerjisi, potansiyeli ve dinamikleri. Kompozit analiz ile ilişkinizi derinlemesine keşfedin.',
      keywords: ['kompozit harita', 'composite chart', 'ilişki haritası', 'birleşik harita', 'çift analizi'],
      canonicalPath: '/composite',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Solar Return
    'solar-return': PageMeta(
      title: 'Solar Return — Güneş Dönüşü Haritası | Venus One',
      description: 'Yıllık Solar Return haritanız. Doğum gününüzde Güneşin konumuna göre yılın enerjisini, temalarını ve potansiyellerini keşfedin.',
      keywords: ['solar return', 'güneş dönüşü', 'yıllık harita', 'doğum günü astroloji', 'yıllık analiz'],
      canonicalPath: '/solar-return',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Progresyonlar
    'progressions': PageMeta(
      title: 'İkincil Progresyonlar — İç Evrim Haritası | Venus One',
      description: 'Secondary Progressions ile içsel gelişiminizi takip edin. Progrese Ay fazları, gezegen ilerlemeleri ve kişisel evrim döngüleri.',
      keywords: ['progresyon', 'secondary progressions', 'progrese ay', 'astroloji progresyon', 'içsel evrim'],
      canonicalPath: '/progressions',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Transitler
    'transits': PageMeta(
      title: 'Gezegen Transitleri — Güncel Kozmik Akış | Venus One',
      description: 'Şu anki gezegen transitlerinin doğum haritanıza etkileri. Transit Satürn, Jüpiter, Pluto ve diğer gezegenlerin kişisel etkileri.',
      keywords: ['transit', 'gezegen transiti', 'satürn transiti', 'jüpiter transiti', 'güncel astroloji'],
      canonicalPath: '/transits',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Vedik Astroloji
    'vedic': PageMeta(
      title: 'Vedik Astroloji — Hint Astrolojisi Haritası | Venus One',
      description: 'Jyotish (Vedik Astroloji) haritanız. Sidereal zodiac, Nakshatra analizi, Dasha dönemleri ve Hint astroloji yorumları.',
      keywords: ['vedik astroloji', 'jyotish', 'nakshatra', 'dasha', 'hint astrolojisi', 'sidereal'],
      canonicalPath: '/vedic',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Drakonik Harita
    'draconic': PageMeta(
      title: 'Drakonik Harita — Ruhsal Köken Haritası | Venus One',
      description: 'Ay Düğümüne dayalı drakonik haritanız. Ruhsal kökeniniz, karma mirasınız ve yaşam amacınızı keşfedin.',
      keywords: ['drakonik harita', 'draconic chart', 'ruhsal harita', 'karma astroloji', 'ay düğümü'],
      canonicalPath: '/draconic',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Asteroidler
    'asteroids': PageMeta(
      title: 'Asteroidler — Chiron, Lilith, Juno, Ceres | Venus One',
      description: 'Asteroitlerin doğum haritanızdaki etkileri. Chiron yaraları, Lilith gölgesi, Juno ilişki kalıpları ve Ceres bakım tarzı.',
      keywords: ['asteroit', 'chiron', 'lilith', 'juno', 'ceres', 'pallas', 'vesta'],
      canonicalPath: '/asteroids',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Local Space
    'local-space': PageMeta(
      title: 'Local Space — Mekansal Astroloji | Venus One',
      description: 'Bulunduğunuz konumun astrolojik analizi. Gezegen yönleri, enerji hatları ve mekansal etkilerin haritası.',
      keywords: ['local space', 'mekansal astroloji', 'astrokartografi', 'yer astrolojisi', 'konum analizi'],
      canonicalPath: '/local-space',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Zamanlama (Timing)
    'timing': PageMeta(
      title: 'Astrolojik Zamanlama — Electional Astrology | Venus One',
      description: 'Önemli kararlarınız için en uygun zamanları keşfedin. İş başlangıçları, evlilik, seyahat ve yatırım için ideal tarihler.',
      keywords: ['electional astroloji', 'uygun zaman', 'muhurta', 'astrolojik zamanlama', 'tarih seçimi'],
      canonicalPath: '/timing',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Yıllık Önizleme
    'year-ahead': PageMeta(
      title: 'Yıllık Astroloji Önizlemesi — 2026 Analizi | Venus One',
      description: '2026 yılı için kişisel astroloji önizlemeniz. Major transitler, tutulmalar ve önemli dönemlerin analizi.',
      keywords: ['2026 astroloji', 'yıllık burç', 'yıl önizleme', 'yıllık transit', '2026 burç yorumu'],
      canonicalPath: '/year-ahead',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Haftalık Burç
    'weekly-horoscope': PageMeta(
      title: 'Haftalık Burç Yorumları — Bu Hafta İçin Refleksiyon Temaları | Venus One',
      description: 'Haftalık burç yorumları. Haftanın öne çıkan günleri, kozmik enerjileri ve 12 burç için detaylı haftalık analiz.',
      keywords: ['haftalık burç', 'bu hafta burçlar', 'haftalık yorum', 'haftalık astroloji'],
      canonicalPath: '/weekly-horoscope',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Aylık Burç
    'monthly-horoscope': PageMeta(
      title: 'Aylık Burç Yorumları — Bu Ay İçin Refleksiyon Temaları | Venus One',
      description: 'Aylık burç yorumları. Ayın önemli transitleri, dolunay/yeniay etkileri ve 12 burç için detaylı aylık analiz.',
      keywords: ['aylık burç', 'bu ay burçlar', 'aylık yorum', 'aylık astroloji'],
      canonicalPath: '/monthly-horoscope',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Yıllık Burç
    'yearly-horoscope': PageMeta(
      title: 'Yıllık Burç Yorumları 2026 — Yılın Astrolojik Analizi | Venus One',
      description: '2026 yılı burç yorumları. Major gezegenler, tutulmalar ve yılın dönüm noktaları. Tüm burçlar için kapsamlı yıllık analiz.',
      keywords: ['yıllık burç 2026', 'yıllık burç yorumu', '2026 burçlar', 'yıl burcu'],
      canonicalPath: '/yearly-horoscope',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Ünlüler
    'celebrities': PageMeta(
      title: 'Ünlü Doğum Haritaları — Celebrity Astrology | Venus One',
      description: 'Ünlülerin doğum haritaları ve astrolojik analizleri. Dünya liderlerinden sanatçılara, sporculardan iş dünyasına ünlü haritaları.',
      keywords: ['ünlü doğum haritası', 'celebrity astrology', 'ünlü burç', 'ünlü astroloji'],
      canonicalPath: '/celebrities',
      ogType: 'website',
      schemaType: SchemaType.collectionPage,
    ),

    // Glossary (Sözlük)
    'glossary': PageMeta(
      title: 'Astroloji Sözlüğü — Terimler ve Kavramlar | Venus One',
      description: 'A\'dan Z\'ye astroloji terimleri sözlüğü. Açı, ev, burç, gezegen ve diğer kavramların detaylı açıklamaları.',
      keywords: ['astroloji sözlüğü', 'astroloji terimleri', 'astroloji kavramları', 'astroloji rehberi'],
      canonicalPath: '/glossary',
      ogType: 'website',
      schemaType: SchemaType.definedTermSet,
    ),

    // Tarot
    'tarot': PageMeta(
      title: 'Tarot Falı — Günlük Tarot Kartı | Venus One',
      description: 'Ücretsiz tarot falı. Günlük kart, 3 kart açılımı, aşk tarot ve Celtic Cross. 78 kartın detaylı anlamları.',
      keywords: ['tarot', 'tarot falı', 'günlük tarot', 'tarot kartları', 'tarot açılımı'],
      canonicalPath: '/tarot',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Numeroloji
    'numerology': PageMeta(
      title: 'Numeroloji — Sayılarla Kişilik Analizi | Venus One',
      description: 'Yaşam yolu sayınız, kişilik sayınız ve ruh sayınız. İsim numerolojisi ve doğum tarihi analizleri.',
      keywords: ['numeroloji', 'yaşam yolu sayısı', 'kişilik sayısı', 'isim numeroloji', 'sayı falı'],
      canonicalPath: '/numerology',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Satürn Dönüşü
    'saturn-return': PageMeta(
      title: 'Satürn Dönüşü — 29 Yaş Krizi Astrolojisi | Venus One',
      description: 'Satürn Dönüşü nedir ve sizi nasıl etkiler? 27-30 ve 57-60 yaş dönemleri, hayat dersleri ve olgunlaşma süreci.',
      keywords: ['satürn dönüşü', 'saturn return', '29 yaş krizi', 'satürn transiti', 'olgunlaşma'],
      canonicalPath: '/saturn-return',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Premium
    'premium': PageMeta(
      title: 'Venus One Premium — Gelişmiş Astroloji Özellikleri',
      description: 'Premium özelliklere erişin: Detaylı transit raporları, karşılaştırmalı analizler, sınırsız harita ve daha fazlası.',
      keywords: ['astroloji premium', 'venusone premium', 'gelişmiş astroloji'],
      canonicalPath: '/premium',
      ogType: 'website',
      schemaType: SchemaType.product,
    ),

    // Profil
    'profile': PageMeta(
      title: 'Profilim — Astroloji Profilim | Venus One',
      description: 'Kişisel astroloji profiliniz. Kayıtlı haritalarınız, favorileriniz ve astrolojik tercihleriniz.',
      keywords: ['astroloji profil', 'doğum bilgisi', 'kişisel harita'],
      canonicalPath: '/profile',
      ogType: 'profile',
      schemaType: SchemaType.profilePage,
    ),

    // Ayarlar
    'settings': PageMeta(
      title: 'Ayarlar | Venus One',
      description: 'Uygulama ayarları. Ev sistemi, zodiac tipi, tema ve bildirim tercihleri.',
      keywords: ['ayarlar', 'tercihler', 'uygulama ayarları'],
      canonicalPath: '/settings',
      ogType: 'website',
      schemaType: SchemaType.webPage,
    ),

    // Kozmoz (Cosmic Discovery)
    'kozmoz': PageMeta(
      title: 'Kozmoz — Günlük Kozmik Keşif | Venus One',
      description: 'Her gün yeni bir kozmik mesaj. Günün enerjisi, ay fazı etkisi ve kişisel kozmik rehberlik.',
      keywords: ['kozmik mesaj', 'günlük enerji', 'ay fazı', 'kozmik rehber'],
      canonicalPath: '/kozmoz',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Rüyalar
    'dreams': PageMeta(
      title: 'Rüya Yorumu — Sembolik Rüya Analizi | Venus One',
      description: 'Rüyalarınızın sembolik anlamlarını keşfedin. Arketipsel imgeler, bilinçaltı mesajlar ve kişisel içgörüler.',
      keywords: ['rüya yorumu', 'rüya analizi', 'rüya sembolleri', 'bilinçaltı'],
      canonicalPath: '/dreams',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Chakra
    'chakra': PageMeta(
      title: 'Chakra Analizi — Enerji Merkezi Dengesi | Venus One',
      description: 'Yedi ana chakranızın analizi. Enerji blokajları, denge durumu ve chakra uyumlaştırma önerileri.',
      keywords: ['chakra', 'enerji merkezi', 'chakra dengesi', 'kundalini', 'enerji analizi'],
      canonicalPath: '/chakra',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Ritüeller
    'rituals': PageMeta(
      title: 'Kozmik Ritüeller — Ay Fazı Ritüelleri | Venus One',
      description: 'Yeniay ve dolunay ritüelleri. Niyet belirleme, manifestasyon ve enerji temizliği pratikleri.',
      keywords: ['ritüel', 'yeniay ritüeli', 'dolunay ritüeli', 'manifestasyon', 'ay ritüeli'],
      canonicalPath: '/rituals',
      ogType: 'article',
      schemaType: SchemaType.howTo,
    ),

    // ════════════════════════════════════════════════════════════════
    // CANONICAL DREAM PAGES - AI-First SEO with FAQ Schema
    // ════════════════════════════════════════════════════════════════
    'ruya/dusmek': PageMeta(
      title: 'Rüyada Düşmek Ne Demek? | Rüya İzi — Venus One',
      description: 'Rüyada düşmek kontrol kaybı hissini yansıtır. Hayatta bir şeylerin elimizden kaydığını düşündüğümüzde ortaya çıkar. Düşme rüyalarının psikolojik anlamı.',
      keywords: ['rüyada düşmek', 'düşme rüyası', 'rüyada düşmek ne anlama gelir', 'rüya yorumu'],
      canonicalPath: '/ruya/dusmek',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/su-gormek': PageMeta(
      title: 'Rüyada Su Görmek Ne Anlama Gelir? | Rüya İzi — Venus One',
      description: 'Rüyada su görmek bilinçaltını ve duyguları simgeler. Suyun durumu iç dünyanın durumunu yansıtır. Durgun su huzuru, dalgalı su karmaşayı gösterir.',
      keywords: ['rüyada su görmek', 'su rüyası', 'rüyada deniz görmek', 'rüya yorumu'],
      canonicalPath: '/ruya/su-gormek',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/tekrar-eden': PageMeta(
      title: 'Tekrar Eden Rüyalar Neden Olur? | Rüya İzi — Venus One',
      description: 'Tekrar eden rüyalar çözülmemiş bir duygusal konuyu işaret eder. Bilinçaltının dikkatinizi çekmek istediği mesajlar. Tekrarlayan rüya kalıpları.',
      keywords: ['tekrar eden rüya', 'tekrarlayan rüyalar', 'aynı rüyayı görmek', 'rüya yorumu'],
      canonicalPath: '/ruya/tekrar-eden',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/kosmak': PageMeta(
      title: 'Rüyada Koşmak Ne Anlama Gelir? | Rüya İzi — Venus One',
      description: 'Rüyada koşmak bir şeyden kaçma veya bir şeye ulaşma arzusunu gösterir. Koşma hızı ve yönü duygusal durumu yansıtır.',
      keywords: ['rüyada koşmak', 'koşma rüyası', 'rüyada kaçmak', 'rüya yorumu'],
      canonicalPath: '/ruya/kosmak',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/ucmak': PageMeta(
      title: 'Rüyada Uçmak Ne Demek? | Rüya İzi — Venus One',
      description: 'Rüyada uçmak özgürlük, başarı ve engelleri aşma arzusunu simgeler. Uçuş yüksekliği ve kontrolü öz güveni yansıtır.',
      keywords: ['rüyada uçmak', 'uçma rüyası', 'rüyada gökyüzünde uçmak', 'rüya yorumu'],
      canonicalPath: '/ruya/ucmak',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/karanlik': PageMeta(
      title: 'Rüyada Karanlık Görmek Ne Anlama Gelir? | Rüya İzi — Venus One',
      description: 'Rüyada karanlık bilinmeyeni, korkulaı ve belirsizliği simgeler. Karanlıkta kaybolmak veya yol bulmak duygusal durumu yansıtır.',
      keywords: ['rüyada karanlık', 'karanlık rüyası', 'rüyada gece', 'rüya yorumu'],
      canonicalPath: '/ruya/karanlik',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/kaybolmak': PageMeta(
      title: 'Rüyada Kaybolmak Ne Anlama Gelir? | Rüya İzi — Venus One',
      description: 'Rüyada kaybolmak yön kaybını ve belirsizliği simgeler. Hayatta rotanı kaybetmiş hissetmek bilinçaltının uyarısı olabilir.',
      keywords: ['rüyada kaybolmak', 'kaybolma rüyası', 'rüyada yolunu kaybetmek', 'rüya yorumu'],
      canonicalPath: '/ruya/kaybolmak',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/sessiz-kalmak': PageMeta(
      title: 'Rüyada Ses Çıkaramamak Ne Demek? | Rüya İzi — Venus One',
      description: 'Rüyada bağıramamak veya konuşamamak ifade edilememiş duyguları simgeler. İletişim zorlukları ve bastırılmış düşünceler.',
      keywords: ['rüyada ses çıkaramamak', 'konuşamama rüyası', 'rüyada bağıramamak', 'rüya yorumu'],
      canonicalPath: '/ruya/sessiz-kalmak',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/aramak': PageMeta(
      title: 'Rüyada Bir Şey Aramak Ne Anlama Gelir? | Rüya İzi — Venus One',
      description: 'Rüyada aramak eksiklik hissini ve tamamlanmamış bir arayışı simgeler. Neyi aradığınız bilinçaltının mesajını ortaya koyar.',
      keywords: ['rüyada aramak', 'arama rüyası', 'rüyada kayıp eşya', 'rüya yorumu'],
      canonicalPath: '/ruya/aramak',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/gecmis': PageMeta(
      title: 'Rüyada Geçmiş Görmek Ne Demek? | Rüya İzi — Venus One',
      description: 'Rüyada geçmişi görmek çözülmemiş duygular ve nostaljik bağları simgeler. Eski yerler, kişiler ve anıların anlamı.',
      keywords: ['rüyada geçmiş', 'geçmiş rüyası', 'rüyada eski sevgili', 'rüya yorumu'],
      canonicalPath: '/ruya/gecmis',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/ucamamak': PageMeta(
      title: 'Rüyada Uçamamak Ne Demek? | Rüya İzi — Venus One',
      description: 'Rüyada uçmaya çalışıp uçamamak engellenmişlik hissini yansıtır. Hedeflere ulaşmakta zorluk ve sınırlanmış hissetme.',
      keywords: ['rüyada uçamamak', 'uçamama rüyası', 'rüyada uçmaya çalışmak', 'rüya yorumu'],
      canonicalPath: '/ruya/ucamamak',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'ruya/kaybetmek': PageMeta(
      title: 'Rüyada Bir Şey Kaybetmek Ne Anlama Gelir? | Rüya İzi — Venus One',
      description: 'Rüyada kaybetmek değerli bir şeyi yitirme korkusunu simgeler. Kaybedilen nesne veya kişi duygusal bağı ortaya koyar.',
      keywords: ['rüyada kaybetmek', 'kayıp rüyası', 'rüyada eşya kaybetmek', 'rüya yorumu'],
      canonicalPath: '/ruya/kaybetmek',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
  };

  /// English page meta data
  static final Map<String, PageMeta> _pageMetasEn = {
    // Home Page
    'home': PageMeta(
      title: 'Venus One — Your Personal Cosmic Guide | Free Birth Chart',
      description: 'Free birth chart, daily horoscope readings, synastry compatibility analysis, and planetary transits. Professional astrology calculated with Swiss Ephemeris.',
      keywords: ['astrology', 'birth chart', 'horoscope', 'natal chart', 'synastry', 'transit'],
      canonicalPath: '/',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Birth Chart
    'birth-chart': PageMeta(
      title: 'Free Birth Chart Calculator | Venus One',
      description: 'Professional birth chart calculator. Planet positions, house placements, aspects, and rising sign analysis. Swiss Ephemeris accuracy.',
      keywords: ['birth chart', 'natal chart', 'rising sign', 'planet positions', 'astrology chart'],
      canonicalPath: '/birth-chart',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Daily Horoscope
    'horoscope': PageMeta(
      title: 'Daily Horoscope — Detailed Readings for All 12 Signs | Venus One',
      description: 'Daily, weekly, and monthly horoscope readings. Love, career, health, and money cosmic energy analysis. Personalized readings for all zodiac signs.',
      keywords: ['daily horoscope', 'weekly horoscope', 'monthly horoscope', 'zodiac reading', 'horoscope analysis'],
      canonicalPath: '/horoscope',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Synastry (Relationship Compatibility)
    'synastry': PageMeta(
      title: 'Synastry — Relationship Compatibility Analysis | Venus One',
      description: 'Discover the compatibility between two birth charts. Synastry aspects, planetary interactions, and relationship dynamics analysis.',
      keywords: ['synastry', 'zodiac compatibility', 'relationship compatibility', 'astrology compatibility', 'partner compatibility'],
      canonicalPath: '/synastry',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Composite Chart
    'composite': PageMeta(
      title: 'Composite Chart — The Birth Chart of Your Relationship | Venus One',
      description: 'The combined chart of two people. Your relationship\'s shared energy, potential, and dynamics. Explore your relationship deeply with composite analysis.',
      keywords: ['composite chart', 'relationship chart', 'combined chart', 'couple analysis'],
      canonicalPath: '/composite',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Solar Return
    'solar-return': PageMeta(
      title: 'Solar Return — Birthday Chart | Venus One',
      description: 'Your annual Solar Return chart. Discover the year\'s energy, themes, and potentials based on the Sun\'s position on your birthday.',
      keywords: ['solar return', 'birthday astrology', 'annual chart', 'yearly analysis'],
      canonicalPath: '/solar-return',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Progressions
    'progressions': PageMeta(
      title: 'Secondary Progressions — Inner Evolution Chart | Venus One',
      description: 'Track your inner development with Secondary Progressions. Progressed Moon phases, planetary progressions, and personal evolution cycles.',
      keywords: ['progression', 'secondary progressions', 'progressed moon', 'astrology progression', 'inner evolution'],
      canonicalPath: '/progressions',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Transits
    'transits': PageMeta(
      title: 'Planetary Transits — Current Cosmic Flow | Venus One',
      description: 'Current planetary transits\' effects on your birth chart. Transit Saturn, Jupiter, Pluto, and other planets\' personal influences.',
      keywords: ['transit', 'planetary transit', 'saturn transit', 'jupiter transit', 'current astrology'],
      canonicalPath: '/transits',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Vedic Astrology
    'vedic': PageMeta(
      title: 'Vedic Astrology — Jyotish Chart | Venus One',
      description: 'Your Jyotish (Vedic Astrology) chart. Sidereal zodiac, Nakshatra analysis, Dasha periods, and Hindu astrology interpretations.',
      keywords: ['vedic astrology', 'jyotish', 'nakshatra', 'dasha', 'hindu astrology', 'sidereal'],
      canonicalPath: '/vedic',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Draconic Chart
    'draconic': PageMeta(
      title: 'Draconic Chart — Soul Origin Chart | Venus One',
      description: 'Your draconic chart based on the Lunar Node. Discover your soul\'s origin, karmic heritage, and life purpose.',
      keywords: ['draconic chart', 'soul chart', 'karmic astrology', 'lunar node'],
      canonicalPath: '/draconic',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Asteroids
    'asteroids': PageMeta(
      title: 'Asteroids — Chiron, Lilith, Juno, Ceres | Venus One',
      description: 'Asteroids\' effects in your birth chart. Chiron wounds, Lilith shadow, Juno relationship patterns, and Ceres nurturing style.',
      keywords: ['asteroid', 'chiron', 'lilith', 'juno', 'ceres', 'pallas', 'vesta'],
      canonicalPath: '/asteroids',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Local Space
    'local-space': PageMeta(
      title: 'Local Space — Spatial Astrology | Venus One',
      description: 'Astrological analysis of your current location. Planetary directions, energy lines, and spatial effects map.',
      keywords: ['local space', 'spatial astrology', 'astrocartography', 'location astrology', 'location analysis'],
      canonicalPath: '/local-space',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Timing (Electional)
    'timing': PageMeta(
      title: 'Astrological Timing — Electional Astrology | Venus One',
      description: 'Discover the best times for important decisions. Ideal dates for business starts, marriage, travel, and investments.',
      keywords: ['electional astrology', 'right time', 'muhurta', 'astrological timing', 'date selection'],
      canonicalPath: '/timing',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Year Ahead
    'year-ahead': PageMeta(
      title: 'Annual Astrology Preview — 2026 Analysis | Venus One',
      description: 'Your personal astrology preview for 2026. Major transits, eclipses, and key period analysis.',
      keywords: ['2026 astrology', 'yearly horoscope', 'year preview', 'annual transit', '2026 horoscope'],
      canonicalPath: '/year-ahead',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Weekly Horoscope
    'weekly-horoscope': PageMeta(
      title: 'Weekly Horoscope — What Awaits the Zodiac Signs This Week | Venus One',
      description: 'Weekly horoscope readings. The week\'s highlight days, cosmic energies, and detailed weekly analysis for all 12 signs.',
      keywords: ['weekly horoscope', 'this week zodiac', 'weekly reading', 'weekly astrology'],
      canonicalPath: '/weekly-horoscope',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Monthly Horoscope
    'monthly-horoscope': PageMeta(
      title: 'Monthly Horoscope — What Awaits the Zodiac Signs This Month | Venus One',
      description: 'Monthly horoscope readings. Major transits, full moon/new moon effects, and detailed monthly analysis for all 12 signs.',
      keywords: ['monthly horoscope', 'this month zodiac', 'monthly reading', 'monthly astrology'],
      canonicalPath: '/monthly-horoscope',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Yearly Horoscope
    'yearly-horoscope': PageMeta(
      title: '2026 Yearly Horoscope — Annual Astrological Analysis | Venus One',
      description: '2026 horoscope readings. Major planets, eclipses, and turning points of the year. Comprehensive annual analysis for all signs.',
      keywords: ['2026 yearly horoscope', 'annual horoscope', '2026 zodiac', 'year horoscope'],
      canonicalPath: '/yearly-horoscope',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Celebrities
    'celebrities': PageMeta(
      title: 'Celebrity Birth Charts — Celebrity Astrology | Venus One',
      description: 'Birth charts and astrological analyses of celebrities. From world leaders to artists, athletes to business leaders.',
      keywords: ['celebrity birth chart', 'celebrity astrology', 'celebrity zodiac', 'famous people astrology'],
      canonicalPath: '/celebrities',
      ogType: 'website',
      schemaType: SchemaType.collectionPage,
    ),

    // Glossary
    'glossary': PageMeta(
      title: 'Astrology Glossary — Terms and Concepts | Venus One',
      description: 'A to Z astrology terms dictionary. Detailed explanations of aspects, houses, signs, planets, and other concepts.',
      keywords: ['astrology glossary', 'astrology terms', 'astrology concepts', 'astrology guide'],
      canonicalPath: '/glossary',
      ogType: 'website',
      schemaType: SchemaType.definedTermSet,
    ),

    // Tarot
    'tarot': PageMeta(
      title: 'Tarot Reading — Daily Tarot Card | Venus One',
      description: 'Free tarot reading. Daily card, 3-card spread, love tarot, and Celtic Cross. Detailed meanings of all 78 cards.',
      keywords: ['tarot', 'tarot reading', 'daily tarot', 'tarot cards', 'tarot spread'],
      canonicalPath: '/tarot',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Numerology
    'numerology': PageMeta(
      title: 'Numerology — Personality Analysis Through Numbers | Venus One',
      description: 'Your life path number, personality number, and soul number. Name numerology and birth date analyses.',
      keywords: ['numerology', 'life path number', 'personality number', 'name numerology', 'number reading'],
      canonicalPath: '/numerology',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Saturn Return
    'saturn-return': PageMeta(
      title: 'Saturn Return — Age 29 Crisis Astrology | Venus One',
      description: 'What is Saturn Return and how does it affect you? The 27-30 and 57-60 age periods, life lessons, and maturation process.',
      keywords: ['saturn return', '29 crisis', 'saturn transit', 'maturation'],
      canonicalPath: '/saturn-return',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Premium
    'premium': PageMeta(
      title: 'Venus One Premium — Advanced Astrology Features',
      description: 'Access premium features: Detailed transit reports, comparative analyses, unlimited charts, and more.',
      keywords: ['astrology premium', 'venusone premium', 'advanced astrology'],
      canonicalPath: '/premium',
      ogType: 'website',
      schemaType: SchemaType.product,
    ),

    // Profile
    'profile': PageMeta(
      title: 'My Profile — My Astrology Profile | Venus One',
      description: 'Your personal astrology profile. Saved charts, favorites, and astrological preferences.',
      keywords: ['astrology profile', 'birth info', 'personal chart'],
      canonicalPath: '/profile',
      ogType: 'profile',
      schemaType: SchemaType.profilePage,
    ),

    // Settings
    'settings': PageMeta(
      title: 'Settings | Venus One',
      description: 'App settings. House system, zodiac type, theme, and notification preferences.',
      keywords: ['settings', 'preferences', 'app settings'],
      canonicalPath: '/settings',
      ogType: 'website',
      schemaType: SchemaType.webPage,
    ),

    // Kozmoz (Cosmic Discovery)
    'kozmoz': PageMeta(
      title: 'Kozmoz — Daily Cosmic Discovery | Venus One',
      description: 'A new cosmic message every day. Today\'s energy, moon phase effect, and personal cosmic guidance.',
      keywords: ['cosmic message', 'daily energy', 'moon phase', 'cosmic guide'],
      canonicalPath: '/kozmoz',
      ogType: 'article',
      schemaType: SchemaType.article,
    ),

    // Dreams
    'dreams': PageMeta(
      title: 'Dream Interpretation — Symbolic Dream Analysis | Venus One',
      description: 'Discover the symbolic meanings of your dreams. Archetypal images, subconscious messages, and personal insights.',
      keywords: ['dream interpretation', 'dream analysis', 'dream symbols', 'subconscious'],
      canonicalPath: '/dreams',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Chakra
    'chakra': PageMeta(
      title: 'Chakra Analysis — Energy Center Balance | Venus One',
      description: 'Analysis of your seven main chakras. Energy blockages, balance status, and chakra alignment suggestions.',
      keywords: ['chakra', 'energy center', 'chakra balance', 'kundalini', 'energy analysis'],
      canonicalPath: '/chakra',
      ogType: 'website',
      schemaType: SchemaType.webApplication,
    ),

    // Rituals
    'rituals': PageMeta(
      title: 'Cosmic Rituals — Moon Phase Rituals | Venus One',
      description: 'New moon and full moon rituals. Intention setting, manifestation, and energy cleansing practices.',
      keywords: ['ritual', 'new moon ritual', 'full moon ritual', 'manifestation', 'moon ritual'],
      canonicalPath: '/rituals',
      ogType: 'article',
      schemaType: SchemaType.howTo,
    ),

    // ════════════════════════════════════════════════════════════════
    // CANONICAL DREAM PAGES - English versions
    // ════════════════════════════════════════════════════════════════
    'dream/falling': PageMeta(
      title: 'What Does Falling in a Dream Mean? | Dream Trace — Venus One',
      description: 'Falling in a dream reflects a feeling of losing control. It appears when we feel things are slipping away in life. Psychological meaning of falling dreams.',
      keywords: ['falling dream', 'dream of falling', 'what does falling mean', 'dream interpretation'],
      canonicalPath: '/dream/falling',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/water': PageMeta(
      title: 'What Does Water in a Dream Mean? | Dream Trace — Venus One',
      description: 'Water in dreams symbolizes the subconscious and emotions. The state of water reflects the inner world. Calm water shows peace, turbulent water shows turmoil.',
      keywords: ['water dream', 'dream of water', 'sea dream', 'dream interpretation'],
      canonicalPath: '/dream/water',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/recurring': PageMeta(
      title: 'Why Do Recurring Dreams Happen? | Dream Trace — Venus One',
      description: 'Recurring dreams indicate an unresolved emotional issue. Messages your subconscious wants to draw attention to. Recurring dream patterns.',
      keywords: ['recurring dream', 'repeating dreams', 'same dream', 'dream interpretation'],
      canonicalPath: '/dream/recurring',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/running': PageMeta(
      title: 'What Does Running in a Dream Mean? | Dream Trace — Venus One',
      description: 'Running in a dream shows a desire to escape from something or reach something. Running speed and direction reflect emotional state.',
      keywords: ['running dream', 'dream of running', 'fleeing dream', 'dream interpretation'],
      canonicalPath: '/dream/running',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/flying': PageMeta(
      title: 'What Does Flying in a Dream Mean? | Dream Trace — Venus One',
      description: 'Flying in a dream symbolizes freedom, success, and the desire to overcome obstacles. Flight height and control reflect self-confidence.',
      keywords: ['flying dream', 'dream of flying', 'flying in the sky dream', 'dream interpretation'],
      canonicalPath: '/dream/flying',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/darkness': PageMeta(
      title: 'What Does Darkness in a Dream Mean? | Dream Trace — Venus One',
      description: 'Darkness in dreams symbolizes the unknown, fears, and uncertainty. Getting lost or finding your way in darkness reflects emotional state.',
      keywords: ['darkness dream', 'dark dream', 'night dream', 'dream interpretation'],
      canonicalPath: '/dream/darkness',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/lost': PageMeta(
      title: 'What Does Getting Lost in a Dream Mean? | Dream Trace — Venus One',
      description: 'Getting lost in a dream symbolizes loss of direction and uncertainty. Feeling lost in life may be a warning from your subconscious.',
      keywords: ['lost dream', 'getting lost dream', 'losing your way dream', 'dream interpretation'],
      canonicalPath: '/dream/lost',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/voiceless': PageMeta(
      title: 'What Does Not Being Able to Speak in a Dream Mean? | Dream Trace — Venus One',
      description: 'Not being able to scream or speak in a dream symbolizes unexpressed emotions. Communication difficulties and suppressed thoughts.',
      keywords: ['voiceless dream', 'cant speak dream', 'cant scream dream', 'dream interpretation'],
      canonicalPath: '/dream/voiceless',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/searching': PageMeta(
      title: 'What Does Searching for Something in a Dream Mean? | Dream Trace — Venus One',
      description: 'Searching in a dream symbolizes a feeling of lack and an incomplete quest. What you\'re looking for reveals your subconscious message.',
      keywords: ['searching dream', 'looking for something dream', 'lost item dream', 'dream interpretation'],
      canonicalPath: '/dream/searching',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/past': PageMeta(
      title: 'What Does Seeing the Past in a Dream Mean? | Dream Trace — Venus One',
      description: 'Seeing the past in a dream symbolizes unresolved emotions and nostalgic connections. The meaning of old places, people, and memories.',
      keywords: ['past dream', 'old memories dream', 'ex dream', 'dream interpretation'],
      canonicalPath: '/dream/past',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/unable-to-fly': PageMeta(
      title: 'What Does Not Being Able to Fly in a Dream Mean? | Dream Trace — Venus One',
      description: 'Trying but failing to fly in a dream reflects a feeling of being blocked. Difficulty reaching goals and feeling limited.',
      keywords: ['cant fly dream', 'unable to fly dream', 'trying to fly dream', 'dream interpretation'],
      canonicalPath: '/dream/unable-to-fly',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
    'dream/losing': PageMeta(
      title: 'What Does Losing Something in a Dream Mean? | Dream Trace — Venus One',
      description: 'Losing something in a dream symbolizes the fear of losing something valuable. The lost object or person reveals the emotional connection.',
      keywords: ['losing dream', 'lost dream', 'losing belongings dream', 'dream interpretation'],
      canonicalPath: '/dream/losing',
      ogType: 'article',
      schemaType: SchemaType.faqPage,
    ),
  };

  /// Get all available routes for sitemap generation
  static List<String> get allRoutes => _pageMetas.keys.toList();
}

/// Page meta data model
class PageMeta {
  final String title;
  final String description;
  final List<String> keywords;
  final String canonicalPath;
  final String ogType;
  final SchemaType schemaType;

  const PageMeta({
    required this.title,
    required this.description,
    required this.keywords,
    required this.canonicalPath,
    required this.ogType,
    required this.schemaType,
  });

  /// Get keywords as comma-separated string
  String get keywordsString => keywords.join(', ');

  /// Get full canonical URL
  String getCanonicalUrl(String baseUrl) => '$baseUrl$canonicalPath';
}

/// Schema.org type enumeration
enum SchemaType {
  webApplication,
  webPage,
  article,
  howTo,
  product,
  collectionPage,
  profilePage,
  definedTermSet,
  faqPage,
}

/// FAQ Schema generator for structured data
/// Generates Schema.org FAQPage JSON-LD for Google rich results
class FaqSchemaGenerator {
  FaqSchemaGenerator._();

  /// Generate FAQPage JSON-LD schema from question/answer pairs
  static String generateFaqSchema({
    required List<FaqSchemaItem> items,
    String? pageUrl,
    String? pageName,
  }) {
    final faqItems = items.map((item) => {
      '@type': 'Question',
      'name': item.question,
      'acceptedAnswer': {
        '@type': 'Answer',
        'text': item.answer,
      },
    }).toList();

    final schema = {
      '@context': 'https://schema.org',
      '@type': 'FAQPage',
      'name': ?pageName,
      'url': ?pageUrl,
      'mainEntity': faqItems,
    };

    return _jsonEncode(schema);
  }

  /// Generate Article + FAQPage combined schema for dream pages
  static String generateDreamArticleSchema({
    required String title,
    required String description,
    required String url,
    required List<FaqSchemaItem> faqItems,
    String? imageUrl,
    String? datePublished,
    String? dateModified,
  }) {
    final now = DateTime.now().toIso8601String();

    final schema = {
      '@context': 'https://schema.org',
      '@graph': [
        {
          '@type': 'Article',
          'headline': title,
          'description': description,
          'url': url,
          'image': ?imageUrl,
          'datePublished': datePublished ?? now,
          'dateModified': dateModified ?? now,
          'author': {
            '@type': 'Organization',
            'name': 'Venus One',
            'url': 'https://venusone.com',
          },
          'publisher': {
            '@type': 'Organization',
            'name': 'Venus One',
            'logo': {
              '@type': 'ImageObject',
              'url': 'https://venusone.com/images/logo.png',
            },
          },
        },
        {
          '@type': 'FAQPage',
          'mainEntity': faqItems.map((item) => {
            '@type': 'Question',
            'name': item.question,
            'acceptedAnswer': {
              '@type': 'Answer',
              'text': item.answer,
            },
          }).toList(),
        },
      ],
    };

    return _jsonEncode(schema);
  }

  /// Generate BreadcrumbList schema for navigation
  static String generateBreadcrumbSchema({
    required List<BreadcrumbItem> items,
  }) {
    final listItems = items.asMap().entries.map((entry) => {
      '@type': 'ListItem',
      'position': entry.key + 1,
      'name': entry.value.name,
      'item': entry.value.url,
    }).toList();

    final schema = {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      'itemListElement': listItems,
    };

    return _jsonEncode(schema);
  }

  /// Simple JSON encoder (avoiding dart:convert for Flutter web compatibility)
  static String _jsonEncode(Map<String, dynamic> data) {
    String encodeValue(dynamic value) {
      if (value == null) return 'null';
      if (value is String) return '"${value.replaceAll('"', '\\"')}"';
      if (value is num || value is bool) return value.toString();
      if (value is List) {
        return '[${value.map(encodeValue).join(',')}]';
      }
      if (value is Map) {
        final entries = value.entries
            .map((e) => '"${e.key}":${encodeValue(e.value)}')
            .join(',');
        return '{$entries}';
      }
      return '"$value"';
    }
    return encodeValue(data);
  }
}

/// FAQ item model for schema generation
class FaqSchemaItem {
  final String question;
  final String answer;

  const FaqSchemaItem({
    required this.question,
    required this.answer,
  });
}

/// Breadcrumb item model for schema generation
class BreadcrumbItem {
  final String name;
  final String url;

  const BreadcrumbItem({
    required this.name,
    required this.url,
  });
}

// ═══════════════════════════════════════════════════════════════
// GOOGLE DISCOVER OPTIMIZATION - Open Graph Meta Tags
// ═══════════════════════════════════════════════════════════════

/// Discover-optimized meta data for high CTR content
class DiscoverMeta {
  final String title;
  final String description;
  final String ogImage; // 1200x628px, max 500KB
  final String ogImageAlt;
  final String articlePublishedTime;
  final String articleModifiedTime;
  final List<String> articleTags;

  const DiscoverMeta({
    required this.title,
    required this.description,
    required this.ogImage,
    required this.ogImageAlt,
    required this.articlePublishedTime,
    required this.articleModifiedTime,
    this.articleTags = const [],
  });

  /// Generate HTML meta tags for Discover optimization
  String toHtmlMetaTags(String baseUrl) {
    return '''
<!-- Primary Meta Tags -->
<title>$title</title>
<meta name="title" content="$title">
<meta name="description" content="$description">

<!-- Open Graph / Facebook / Discover -->
<meta property="og:type" content="article">
<meta property="og:url" content="$baseUrl">
<meta property="og:title" content="$title">
<meta property="og:description" content="$description">
<meta property="og:image" content="$ogImage">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="628">
<meta property="og:image:alt" content="$ogImageAlt">
<meta property="og:locale" content="tr_TR">
<meta property="og:site_name" content="Venus One">

<!-- Article-specific -->
<meta property="article:published_time" content="$articlePublishedTime">
<meta property="article:modified_time" content="$articleModifiedTime">
${articleTags.map((tag) => '<meta property="article:tag" content="$tag">').join('\n')}

<!-- Twitter -->
<meta property="twitter:card" content="summary_large_image">
<meta property="twitter:url" content="$baseUrl">
<meta property="twitter:title" content="$title">
<meta property="twitter:description" content="$description">
<meta property="twitter:image" content="$ogImage">

<!-- Google Discover Hints -->
<meta name="robots" content="max-image-preview:large">
''';
  }
}

/// Pre-defined Discover content templates for weekly content calendar
class DiscoverContentTemplates {
  DiscoverContentTemplates._();

  /// Monday - Weekly Horoscope
  static DiscoverMeta weeklyHoroscope({
    required String sign,
    required String signEmoji,
    required String highlight,
    AppLanguage language = AppLanguage.tr,
  }) {
    final now = DateTime.now();
    if (language == AppLanguage.tr) {
      return DiscoverMeta(
        title: '$signEmoji $sign Burcu Bu Hafta: $highlight',
        description: 'Bu hafta $sign burcu için aşk, kariyer ve sağlık yorumları. Haftanın şanslı günleri ve dikkat edilmesi gerekenler.',
        ogImage: 'https://venusone.com/images/discover/weekly-$sign.webp',
        ogImageAlt: '$sign burcu haftalık yorum görseli',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['haftalık burç', sign, 'burç yorumu', 'astroloji'],
      );
    } else {
      return DiscoverMeta(
        title: '$signEmoji $sign This Week: $highlight',
        description: 'This week\'s love, career, and health readings for $sign. Lucky days and things to watch out for.',
        ogImage: 'https://venusone.com/images/discover/weekly-$sign.webp',
        ogImageAlt: '$sign weekly horoscope image',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['weekly horoscope', sign, 'horoscope reading', 'astrology'],
      );
    }
  }

  /// Tuesday - Dream Symbol
  static DiscoverMeta dreamSymbol({
    required String symbol,
    required String symbolEmoji,
    required String meaning,
    AppLanguage language = AppLanguage.tr,
  }) {
    final now = DateTime.now();
    if (language == AppLanguage.tr) {
      return DiscoverMeta(
        title: '$symbolEmoji Rüyanda $symbol Görmek Ne Anlama Gelir?',
        description: 'Rüyada $symbol görmek: $meaning. Psikolojik ve spiritüel yorumlar, farklı kültürlerde anlamları.',
        ogImage: 'https://venusone.com/images/discover/dream-$symbol.webp',
        ogImageAlt: 'Rüyada $symbol görmek görseli',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['rüya yorumu', symbol, 'rüya tabiri', 'bilinçaltı'],
      );
    } else {
      return DiscoverMeta(
        title: '$symbolEmoji What Does $symbol in Your Dream Mean?',
        description: 'Seeing $symbol in a dream: $meaning. Psychological and spiritual interpretations, meanings across cultures.',
        ogImage: 'https://venusone.com/images/discover/dream-$symbol.webp',
        ogImageAlt: 'Dreaming of $symbol image',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['dream interpretation', symbol, 'dream meaning', 'subconscious'],
      );
    }
  }

  /// Wednesday - Numerology
  static DiscoverMeta numerologyNumber({
    required int number,
    required String title,
    AppLanguage language = AppLanguage.tr,
  }) {
    final now = DateTime.now();
    if (language == AppLanguage.tr) {
      return DiscoverMeta(
        title: '🔢 $number Sayısının Gizemi: $title',
        description: '$number sayısının numerolojik anlamı, kişilik özellikleri ve hayat yolu. Sayınız $number ise bu özellikleri taşıyorsunuz.',
        ogImage: 'https://venusone.com/images/discover/numerology-$number.webp',
        ogImageAlt: '$number sayısı numeroloji görseli',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['numeroloji', 'yaşam yolu', 'kişilik sayısı', '$number'],
      );
    } else {
      return DiscoverMeta(
        title: '🔢 The Mystery of Number $number: $title',
        description: 'Numerological meaning of $number, personality traits, and life path. If your number is $number, you carry these traits.',
        ogImage: 'https://venusone.com/images/discover/numerology-$number.webp',
        ogImageAlt: 'Number $number numerology image',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['numerology', 'life path', 'personality number', '$number'],
      );
    }
  }

  /// Thursday - Tarot Card
  static DiscoverMeta tarotCard({
    required String cardName,
    required String cardEmoji,
    required String meaning,
    AppLanguage language = AppLanguage.tr,
  }) {
    final now = DateTime.now();
    if (language == AppLanguage.tr) {
      return DiscoverMeta(
        title: '$cardEmoji $cardName Tarot Kartı: $meaning',
        description: '$cardName kartının anlamı, düz ve ters pozisyon yorumları. Aşk, kariyer ve kişisel gelişim için mesajları.',
        ogImage: 'https://venusone.com/images/discover/tarot-${cardName.toLowerCase().replaceAll(' ', '-')}.webp',
        ogImageAlt: '$cardName tarot kartı görseli',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['tarot', cardName, 'tarot falı', 'kart anlamı'],
      );
    } else {
      return DiscoverMeta(
        title: '$cardEmoji $cardName Tarot Card: $meaning',
        description: 'Meaning of $cardName card, upright and reversed interpretations. Messages for love, career, and personal growth.',
        ogImage: 'https://venusone.com/images/discover/tarot-${cardName.toLowerCase().replaceAll(' ', '-')}.webp',
        ogImageAlt: '$cardName tarot card image',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['tarot', cardName, 'tarot reading', 'card meaning'],
      );
    }
  }

  /// Friday - Love/Relationship Horoscopes
  static DiscoverMeta loveHoroscope({
    required String sign1,
    required String sign2,
    required String compatibility,
    AppLanguage language = AppLanguage.tr,
  }) {
    final now = DateTime.now();
    if (language == AppLanguage.tr) {
      return DiscoverMeta(
        title: '💕 $sign1 ve $sign2 Aşk Uyumu: $compatibility',
        description: '$sign1 ve $sign2 burçlarının ilişki dinamikleri, güçlü ve zayıf yönleri. Bu çift uyumlu mu?',
        ogImage: 'https://venusone.com/images/discover/love-$sign1-$sign2.webp',
        ogImageAlt: '$sign1 ve $sign2 aşk uyumu görseli',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['burç uyumu', sign1, sign2, 'aşk', 'ilişki'],
      );
    } else {
      return DiscoverMeta(
        title: '💕 $sign1 and $sign2 Love Compatibility: $compatibility',
        description: 'Relationship dynamics, strengths, and weaknesses of $sign1 and $sign2. Is this couple compatible?',
        ogImage: 'https://venusone.com/images/discover/love-$sign1-$sign2.webp',
        ogImageAlt: '$sign1 and $sign2 love compatibility image',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['zodiac compatibility', sign1, sign2, 'love', 'relationship'],
      );
    }
  }

  /// Saturday - Mega List
  static DiscoverMeta megaList({
    required String title,
    required String subtitle,
    required int listCount,
    AppLanguage language = AppLanguage.tr,
  }) {
    final now = DateTime.now();
    if (language == AppLanguage.tr) {
      return DiscoverMeta(
        title: '✨ $title: $listCount Maddelik Liste',
        description: subtitle,
        ogImage: 'https://venusone.com/images/discover/mega-list.webp',
        ogImageAlt: '$title liste görseli',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['liste', 'astroloji', 'burçlar'],
      );
    } else {
      return DiscoverMeta(
        title: '✨ $title: $listCount Item List',
        description: subtitle,
        ogImage: 'https://venusone.com/images/discover/mega-list.webp',
        ogImageAlt: '$title list image',
        articlePublishedTime: now.toIso8601String(),
        articleModifiedTime: now.toIso8601String(),
        articleTags: ['list', 'astrology', 'zodiac signs'],
      );
    }
  }

  /// Sunday - Viral/Interesting
  static DiscoverMeta viralContent({
    required String hook,
    required String description,
    required List<String> tags,
    AppLanguage language = AppLanguage.tr,
  }) {
    final now = DateTime.now();
    final altText = language == AppLanguage.tr ? 'Viral içerik görseli' : 'Viral content image';
    return DiscoverMeta(
      title: '🔥 $hook',
      description: description,
      ogImage: 'https://venusone.com/images/discover/viral-content.webp',
      ogImageAlt: altText,
      articlePublishedTime: now.toIso8601String(),
      articleModifiedTime: now.toIso8601String(),
      articleTags: tags,
    );
  }
}

/// Cover Image Prompt Generator for AI image tools
class DiscoverCoverImagePrompts {
  DiscoverCoverImagePrompts._();

  /// Burç için cover image prompt
  static String zodiacCover(String sign, String element) {
    final elementStyle = _getElementStyle(element);
    return '''
Professional astrology cover image for Google Discover.
Subject: $sign zodiac sign symbol, elegant and mystical.
Style: $elementStyle, cosmic background with subtle stars.
Composition: Symbol centered, 16:9 aspect ratio (1200x628px).
Mood: Mystical, premium, inviting.
Colors: Deep purple/blue cosmic tones with gold accents.
Text area: Leave clean space on left or bottom for overlay text.
Quality: High contrast, vibrant, Instagram-worthy.
No: Faces, text, watermarks, cluttered elements.
''';
  }

  /// Rüya için cover image prompt
  static String dreamCover(String symbol) {
    return '''
Dreamy, surreal cover image for Google Discover.
Subject: $symbol floating in a dream-like environment.
Style: Soft, ethereal, slightly blurred edges, pastel to deep tones.
Composition: Main symbol prominent but not centered, room for text overlay.
Mood: Mysterious, introspective, calming yet intriguing.
Colors: Deep blues, purples, with moonlight silver highlights.
Lighting: Soft, diffused, as if underwater or in fog.
Aspect ratio: 16:9 (1200x628px).
No: Scary elements, text, faces, harsh contrasts.
''';
  }

  /// Tarot için cover image prompt
  static String tarotCover(String cardName) {
    return '''
Mystical tarot card cover image for Google Discover.
Subject: Abstract representation of $cardName tarot card themes.
Style: Art nouveau meets modern minimalism, rich textures.
Composition: Symbolic elements arranged elegantly, text-friendly areas.
Mood: Mystical, wise, contemplative.
Colors: Deep jewel tones - emerald, ruby, sapphire with gold accents.
Lighting: Dramatic, spotlight effect on key elements.
Aspect ratio: 16:9 (1200x628px).
No: Actual tarot card images (copyright), text, cluttered symbols.
''';
  }

  /// Numeroloji için cover image prompt
  static String numerologyCover(int number) {
    return '''
Sacred geometry cover image for Google Discover.
Subject: Number $number integrated with sacred geometric patterns.
Style: Modern sacred geometry, clean lines, mathematical beauty.
Composition: Number as focal point with radiating patterns.
Mood: Intellectual, mystical, ordered.
Colors: Gold and deep purple/indigo, cosmic backdrop.
Effects: Subtle glow around the number, sacred patterns.
Aspect ratio: 16:9 (1200x628px).
No: Too many numbers, cluttered geometry, text.
''';
  }

  static String _getElementStyle(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return 'warm orange and red tones, dynamic flame-like textures';
      case 'earth':
        return 'rich earth tones, green and brown, grounded textures';
      case 'air':
        return 'light, airy blues and whites, flowing cloud-like textures';
      case 'water':
        return 'deep ocean blues and teals, fluid wave-like textures';
      default:
        return 'cosmic purple and gold tones';
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// DISCOVER KAPAK GÖRSELLERİ - 10 HAZIR AI PROMPT
// Midjourney / DALL-E / Ideogram için optimize edilmiş
// ═══════════════════════════════════════════════════════════════

class DiscoverDreamImagePrompts {
  DiscoverDreamImagePrompts._();

  /// Düşmek rüyası için kapak görseli
  static const String falling = '''
Cinematic dream cover image.
A person falling slowly into darkness, seen from above.
No face visible.
Soft motion blur, calm mood.
Dark blue and grey tones.
Photorealistic, no text.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Diş dökülmesi rüyası için kapak görseli
  static const String teeth = '''
Minimal symbolic dream image.
Single tooth floating in darkness with soft light.
No blood, no fear.
Calm and mysterious.
Dark neutral background.
High quality, no text.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Kovalanmak rüyası için kapak görseli
  static const String chased = '''
Dream-like night scene.
A silhouette running on an empty road under moonlight.
No face details.
Emotional but calm tension.
Dark blue tones, cinematic.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Ölmek rüyası için kapak görseli
  static const String death = '''
Symbolic dream image.
A closed door with soft light leaking through.
No people.
Minimal, calm, mysterious.
Dark tones, high contrast.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Yılan rüyası için kapak görseli
  static const String snake = '''
Close-up symbolic image.
A snake partially hidden in shadow.
No aggression, no fear.
Soft lighting, neutral emotion.
Dark green and black tones.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Uçmak rüyası için kapak görseli
  static const String flying = '''
Dreamlike aerial scene.
A human silhouette floating above clouds at night.
No face.
Peaceful, calm, cinematic.
Soft moonlight.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Deniz/su rüyası için kapak görseli
  static const String water = '''
Night ocean scene.
Calm waves under moonlight.
No people.
Emotional but peaceful.
Dark blue palette.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Bebek rüyası için kapak görseli
  static const String baby = '''
Symbolic dream image.
Soft light illuminating baby footprints on sand.
No baby visible.
Warm but calm mood.
Minimal composition.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Ev rüyası için kapak görseli
  static const String house = '''
Lonely house at night.
Single window glowing softly.
No people.
Emotional, mysterious, calm.
Dark neutral colors.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Yangın rüyası için kapak görseli
  static const String fire = '''
Symbolic fire dream image.
Small controlled flame in darkness.
No destruction.
Calm, metaphorical mood.
Dark background, warm light.
Aspect ratio: 16:9 (1200x628px).
''';

  /// Tüm prompt'ları map olarak al
  static Map<String, String> get all => {
    'falling': falling,
    'teeth': teeth,
    'chased': chased,
    'death': death,
    'snake': snake,
    'flying': flying,
    'water': water,
    'baby': baby,
    'house': house,
    'fire': fire,
  };

  /// Sembol adına göre prompt getir
  static String? getPrompt(String symbol) {
    final normalizedSymbol = symbol.toLowerCase();

    // Türkçe karşılıklar
    final mapping = {
      'düşmek': 'falling',
      'dusmek': 'falling',
      'diş': 'teeth',
      'dis': 'teeth',
      'kovalanmak': 'chased',
      'kaçmak': 'chased',
      'kacmak': 'chased',
      'ölmek': 'death',
      'olmek': 'death',
      'ölüm': 'death',
      'olum': 'death',
      'yılan': 'snake',
      'yilan': 'snake',
      'uçmak': 'flying',
      'ucmak': 'flying',
      'su': 'water',
      'deniz': 'water',
      'okyanus': 'water',
      'bebek': 'baby',
      'çocuk': 'baby',
      'cocuk': 'baby',
      'ev': 'house',
      'bina': 'house',
      'yangın': 'fire',
      'yangin': 'fire',
      'ateş': 'fire',
      'ates': 'fire',
    };

    final key = mapping[normalizedSymbol] ?? normalizedSymbol;
    return all[key];
  }
}

// ═══════════════════════════════════════════════════════════════
// DISCOVER → QUIZ DÖNÜŞÜM METRİKLERİ
// ═══════════════════════════════════════════════════════════════

class DiscoverMetrics {
  DiscoverMetrics._();

  /// Healthy conversion targets
  static const discoverCtrMin = 0.04; // 4%
  static const discoverCtrMax = 0.10; // 10%
  static const pageRetention = 0.60; // 60%
  static const quizClickMin = 0.06; // 6%
  static const quizClickMax = 0.12; // 12%
  static const quizCompletion = 0.70; // 70%
  static const segHighTarget = 0.35; // 30-40%

  /// Alarm levels
  static const quizClickAlarmLow = 0.05; // <5% = text too harsh
  static const quizClickAlarmHigh = 0.15; // >15% = clickbait risk
  static const segHighAlarmLow = 0.25; // <25% = weak quiz questions

  /// Subscription conversion targets
  static const quizToPremium = 0.015; // 1-2%
  static const premiumToSubscription = 0.20; // 15-25%
  static const monthlyChurn = 0.065; // 5-8%

  /// Metric check with language support
  static String checkQuizClick(double rate, {AppLanguage language = AppLanguage.tr}) {
    final percent = (rate * 100).toStringAsFixed(1);
    if (language == AppLanguage.tr) {
      if (rate < quizClickAlarmLow) {
        return 'ALARM: Quiz tıklama çok düşük (%$percent). Metin çok sert veya güven eksik.';
      }
      if (rate > quizClickAlarmHigh) {
        return 'ALARM: Quiz tıklama çok yüksek (%$percent). Clickbait riski!';
      }
      if (rate >= quizClickMin && rate <= quizClickMax) {
        return 'OK: Quiz tıklama sağlıklı (%$percent)';
      }
      return 'İZLE: Quiz tıklama hedef aralığında değil (%$percent)';
    } else {
      if (rate < quizClickAlarmLow) {
        return 'ALARM: Quiz click rate too low ($percent%). Text too harsh or lacking trust.';
      }
      if (rate > quizClickAlarmHigh) {
        return 'ALARM: Quiz click rate too high ($percent%). Clickbait risk!';
      }
      if (rate >= quizClickMin && rate <= quizClickMax) {
        return 'OK: Quiz click rate healthy ($percent%)';
      }
      return 'WATCH: Quiz click rate outside target range ($percent%)';
    }
  }

  static String checkSegHigh(double rate, {AppLanguage language = AppLanguage.tr}) {
    final percent = (rate * 100).toStringAsFixed(1);
    if (language == AppLanguage.tr) {
      if (rate < segHighAlarmLow) {
        return 'ALARM: seg=high oranı düşük (%$percent). Quiz soruları güçlendirilmeli.';
      }
      if (rate >= 0.30 && rate <= 0.40) {
        return 'OK: seg=high oranı ideal (%$percent)';
      }
      return 'İZLE: seg=high oranı beklenenden farklı (%$percent)';
    } else {
      if (rate < segHighAlarmLow) {
        return 'ALARM: seg=high rate low ($percent%). Quiz questions need strengthening.';
      }
      if (rate >= 0.30 && rate <= 0.40) {
        return 'OK: seg=high rate ideal ($percent%)';
      }
      return 'WATCH: seg=high rate differs from expected ($percent%)';
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// SUBSCRIPTION TRIGGER TEXTS
// Quiz → Premium → Subscription flow
// ═══════════════════════════════════════════════════════════════

class SubscriptionTriggerTexts {
  SubscriptionTriggerTexts._();

  /// Get push notification texts by language
  static Map<String, Map<String, String>> getPushNotifications({AppLanguage language = AppLanguage.tr}) {
    if (language == AppLanguage.tr) {
      return {
        'dream_followup': {
          'title': 'Son rüyanın teması bugün de devam ediyor olabilir',
          'body': 'Günlük kişisel yorumlara eriş',
          'cta': 'Keşfet',
        },
        'quiz_reminder': {
          'title': 'Kozmik profilin hazır',
          'body': 'Kişiselleştirilmiş içeriklerin hazır',
          'cta': 'Aç',
        },
        'transit_alert': {
          'title': 'Bu hafta önemli bir transit var',
          'body': 'Seni nasıl etkileyeceğini öğren',
          'cta': 'Detayları Gör',
        },
        'weekly_horoscope': {
          'title': 'Haftalık burcun hazır',
          'body': 'Bu hafta hangi temaları keşfedebilirsin?',
          'cta': 'Oku',
        },
      };
    } else {
      return {
        'dream_followup': {
          'title': 'Your last dream\'s theme may still be continuing today',
          'body': 'Access daily personal readings',
          'cta': 'Explore',
        },
        'quiz_reminder': {
          'title': 'Your cosmic profile is ready',
          'body': 'Personalized content is waiting for you',
          'cta': 'Open',
        },
        'transit_alert': {
          'title': 'There\'s an important transit this week',
          'body': 'Learn how it will affect you',
          'cta': 'See Details',
        },
        'weekly_horoscope': {
          'title': 'Your weekly horoscope is ready',
          'body': 'What themes can you explore this week?',
          'cta': 'Read',
        },
      };
    }
  }

  /// Get email templates by language
  static Map<String, Map<String, String>> getEmailTemplates({AppLanguage language = AppLanguage.tr}) {
    if (language == AppLanguage.tr) {
      return {
        'quiz_completed_high': {
          'subject': '🌟 Kozmik profilin çok güçlü çıktı!',
          'preview': 'Kişiselleştirilmiş içeriklerle yolculuğuna devam et',
          'cta': 'Premium ile Keşfet',
        },
        'dream_analysis': {
          'subject': '🌙 Rüya analizin hazır',
          'preview': 'Bilinçaltının mesajlarını daha derinden keşfet',
          'cta': 'Detaylı Analizi Gör',
        },
        'subscription_offer': {
          'subject': '✨ Sınırsız kozmik rehberliği keşfet',
          'preview': 'Günlük yorumlar, kişisel transitler ve daha fazlası',
          'cta': 'Hemen Başla',
        },
      };
    } else {
      return {
        'quiz_completed_high': {
          'subject': '🌟 Your cosmic profile is very strong!',
          'preview': 'Continue your journey with personalized content',
          'cta': 'Explore with Premium',
        },
        'dream_analysis': {
          'subject': '🌙 Your dream analysis is ready',
          'preview': 'Explore your subconscious messages more deeply',
          'cta': 'See Detailed Analysis',
        },
        'subscription_offer': {
          'subject': '✨ Explore unlimited cosmic guidance',
          'preview': 'Daily readings, personal transits, and more',
          'cta': 'Start Now',
        },
      };
    }
  }

  /// Get in-app CTA texts by language
  static Map<String, String> getInAppCta({AppLanguage language = AppLanguage.tr}) {
    if (language == AppLanguage.tr) {
      return {
        'after_quiz_high': 'Kişisel kozmik haritanı aç ve sınırsız erişim kazan',
        'after_dream': 'Günlük rüya rehberliği ile bilinçaltını keşfet',
        'after_horoscope': 'Haftalık ve aylık detaylı yorumlara eriş',
        'after_transit': 'Kişisel transit raporlarıyla geleceğe hazırlan',
        'general': 'Premium ile kozmik yolculuğunu derinleştir',
      };
    } else {
      return {
        'after_quiz_high': 'Open your personal cosmic chart and gain unlimited access',
        'after_dream': 'Explore your subconscious with daily dream guidance',
        'after_horoscope': 'Access weekly and monthly detailed readings',
        'after_transit': 'Prepare for the future with personal transit reports',
        'general': 'Deepen your cosmic journey with Premium',
      };
    }
  }

  /// Segment-based CTA strategy with language support
  static Map<String, dynamic> getCtaStrategy(String segment, {AppLanguage language = AppLanguage.tr}) {
    if (language == AppLanguage.tr) {
      switch (segment) {
        case 'high':
          return {
            'style': 'aggressive',
            'showModal': true,
            'discount': true,
            'discountPercent': 20,
            'text': 'Özel %20 indirimle Premium\'a geç',
            'urgency': 'Sadece bugün geçerli',
          };
        case 'medium':
          return {
            'style': 'soft',
            'showModal': false,
            'discount': false,
            'text': 'Premium özellikleri keşfet',
            'urgency': null,
          };
        case 'low':
          return {
            'style': 'minimal',
            'showModal': false,
            'discount': false,
            'text': 'Daha fazlasını keşfet',
            'urgency': null,
          };
        default:
          return {
            'style': 'soft',
            'showModal': false,
            'discount': false,
            'text': 'Premium ile devam et',
            'urgency': null,
          };
      }
    } else {
      switch (segment) {
        case 'high':
          return {
            'style': 'aggressive',
            'showModal': true,
            'discount': true,
            'discountPercent': 20,
            'text': 'Switch to Premium with 20% off',
            'urgency': 'Valid today only',
          };
        case 'medium':
          return {
            'style': 'soft',
            'showModal': false,
            'discount': false,
            'text': 'Explore Premium features',
            'urgency': null,
          };
        case 'low':
          return {
            'style': 'minimal',
            'showModal': false,
            'discount': false,
            'text': 'Discover more',
            'urgency': null,
          };
        default:
          return {
            'style': 'soft',
            'showModal': false,
            'discount': false,
            'text': 'Continue with Premium',
            'urgency': null,
          };
      }
    }
  }
}
