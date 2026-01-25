/// Static HTML Page Generator for SEO Pre-rendering
/// Generates static HTML fallback pages for all routes
///
/// Run with: dart run scripts/generate_static_pages.dart

import 'dart:io';

/// Page meta data
class PageMeta {
  final String route;
  final String title;
  final String description;
  final String keywords;
  final String ogType;
  final List<String> content;

  const PageMeta({
    required this.route,
    required this.title,
    required this.description,
    required this.keywords,
    required this.ogType,
    required this.content,
  });
}

const String baseUrl = 'https://astrobobo.com';

final List<PageMeta> pages = [
  // Ana Sayfa
  PageMeta(
    route: '',
    title: 'Astrobobo — Kişisel Kozmik Rehberiniz | Ücretsiz Doğum Haritası',
    description: 'Ücretsiz doğum haritası, günlük burç yorumları, synastry uyum analizi ve gezegen transitleri. Swiss Ephemeris ile hesaplanan profesyonel astroloji.',
    keywords: 'astroloji, doğum haritası, burç yorumu, natal chart, synastry, transit',
    ogType: 'website',
    content: [
      'Astrobobo — Kozmik Yolculuğunuz Başlıyor',
      'Ücretsiz profesyonel doğum haritası hesaplama',
      'Günlük, haftalık ve aylık burç yorumları',
      'Synastry ilişki uyumu analizi',
      'Gezegen transitleri ve etkileri',
      'Swiss Ephemeris hassasiyetinde hesaplamalar',
    ],
  ),

  // Doğum Haritası
  PageMeta(
    route: 'birth-chart',
    title: 'Ücretsiz Doğum Haritası Hesaplama | Astrobobo',
    description: 'Profesyonel doğum haritası hesaplayıcı. Gezegen pozisyonları, ev yerleşimleri, açılar ve yükselen burç analizi. Swiss Ephemeris hassasiyetinde.',
    keywords: 'doğum haritası, natal chart, yükselen burç, gezegen pozisyonları, astroloji haritası',
    ogType: 'website',
    content: [
      'Ücretsiz Doğum Haritası Hesaplama',
      'Doğum haritası, doğduğunuz anda gökyüzündeki gezegenlerin konumlarını gösteren kozmik bir anlık görüntüdür.',
      'Haritanızda Neler Var?',
      '• Güneş Burcu: Temel kimliğiniz ve yaşam enerjiniz',
      '• Ay Burcu: Duygusal doğanız ve iç dünyanız',
      '• Yükselen Burç: Dünyaya nasıl görünürsünüz',
      '• 10 Gezegen: Her biri farklı bir yaşam alanını temsil eder',
      '• 12 Ev: Hayatın farklı alanları ve deneyimleri',
      '• Açılar: Gezegenler arası etkileşimler',
      'Metodoloji',
      'Swiss Ephemeris kullanarak yüksek hassasiyetli hesaplamalar yapıyoruz.',
      'Placidus ev sistemi ve Tropical zodiac kullanılmaktadır.',
    ],
  ),

  // Günlük Burç
  PageMeta(
    route: 'horoscope',
    title: 'Günlük Burç Yorumları — 12 Burç İçin Detaylı Yorum | Astrobobo',
    description: 'Günlük, haftalık ve aylık burç yorumları. Aşk, kariyer, sağlık ve para konularında kozmik enerji analizi.',
    keywords: 'günlük burç yorumu, haftalık burç, aylık burç, burç falı',
    ogType: 'article',
    content: [
      'Günlük Burç Yorumları',
      'Her gün güncellenen, kişiselleştirilmiş burç yorumları',
      '12 Burç İçin Yorumlar',
      '♈ Koç (21 Mart - 19 Nisan)',
      '♉ Boğa (20 Nisan - 20 Mayıs)',
      '♊ İkizler (21 Mayıs - 20 Haziran)',
      '♋ Yengeç (21 Haziran - 22 Temmuz)',
      '♌ Aslan (23 Temmuz - 22 Ağustos)',
      '♍ Başak (23 Ağustos - 22 Eylül)',
      '♎ Terazi (23 Eylül - 22 Ekim)',
      '♏ Akrep (23 Ekim - 21 Kasım)',
      '♐ Yay (22 Kasım - 21 Aralık)',
      '♑ Oğlak (22 Aralık - 19 Ocak)',
      '♒ Kova (20 Ocak - 18 Şubat)',
      '♓ Balık (19 Şubat - 20 Mart)',
    ],
  ),

  // Synastry
  PageMeta(
    route: 'synastry',
    title: 'Synastry — İlişki Uyumu Analizi | Astrobobo',
    description: 'İki kişinin doğum haritaları arasındaki uyumu keşfedin. Synastry açıları, gezegen etkileşimleri ve ilişki dinamikleri.',
    keywords: 'synastry, burç uyumu, ilişki uyumu, astroloji uyum',
    ogType: 'website',
    content: [
      'Synastry — İlişki Uyumu Analizi',
      'İki kişinin doğum haritaları arasındaki kozmik bağlantıları keşfedin.',
      'Synastry Nedir?',
      'Synastry, iki kişinin doğum haritalarını karşılaştırarak ilişki dinamiklerini analiz eden astroloji dalıdır.',
      'Analiz Edilen Unsurlar',
      '• Güneş-Ay uyumu: Temel kimlik ve duygusal bağ',
      '• Venüs-Mars açıları: Romantik ve fiziksel çekim',
      '• Merkür etkileşimleri: İletişim uyumu',
      '• Satürn açıları: Uzun vadeli potansiyel',
    ],
  ),

  // Kompozit
  PageMeta(
    route: 'composite',
    title: 'Kompozit Harita — İlişkinin Doğum Haritası | Astrobobo',
    description: 'İki kişinin birleşik haritası. İlişkinizin ortak enerjisi, potansiyeli ve dinamikleri.',
    keywords: 'kompozit harita, composite chart, ilişki haritası',
    ogType: 'website',
    content: [
      'Kompozit Harita — İlişkinin Doğum Haritası',
      'Kompozit harita, iki kişinin haritalarının matematiksel ortalamasıdır.',
      'Bu harita, ilişkinin kendi "kişiliğini" ortaya koyar.',
      'Kompozit Analiz',
      '• Kompozit Güneş: İlişkinin amacı ve kimliği',
      '• Kompozit Ay: Duygusal temel ve güvenlik',
      '• Kompozit Venüs: Sevgi dili ve değerler',
      '• Kompozit Mars: Enerji ve motivasyon',
    ],
  ),

  // Solar Return
  PageMeta(
    route: 'solar-return',
    title: 'Solar Return — Güneş Dönüşü Haritası | Astrobobo',
    description: 'Yıllık Solar Return haritanız. Doğum gününüzde Güneşin konumuna göre yılın temaları.',
    keywords: 'solar return, güneş dönüşü, yıllık harita',
    ogType: 'website',
    content: [
      'Solar Return — Güneş Dönüşü Haritası',
      'Solar Return, Güneşin her yıl doğum pozisyonuna döndüğü anın haritasıdır.',
      'Yıllık Temalar',
      '• Solar Return Yükselen: Yılın genel enerjisi',
      '• SR Güneş evi: Odak noktası',
      '• SR Ay: Duygusal ihtiyaçlar',
      '• Gezegen vurguları: Öne çıkan konular',
    ],
  ),

  // Progresyonlar
  PageMeta(
    route: 'progressions',
    title: 'İkincil Progresyonlar — İç Evrim Haritası | Astrobobo',
    description: 'Secondary Progressions ile içsel gelişiminizi takip edin. Progrese Ay fazları ve kişisel evrim.',
    keywords: 'progresyon, secondary progressions, progrese ay',
    ogType: 'website',
    content: [
      'İkincil Progresyonlar',
      'Secondary Progressions, içsel evriminizin astrolojik haritasıdır.',
      'Bir gün = Bir yıl prensibi ile hesaplanır.',
      'Önemli Progresyonlar',
      '• Progrese Ay: 2.5 yıllık duygusal döngüler',
      '• Progrese Güneş burç değişimi: Kimlik evrimi',
      '• Progrese gezegen açıları: Hayat dönüm noktaları',
    ],
  ),

  // Transitler
  PageMeta(
    route: 'transits',
    title: 'Gezegen Transitleri — Güncel Kozmik Akış | Astrobobo',
    description: 'Şu anki gezegen transitlerinin doğum haritanıza etkileri.',
    keywords: 'transit, gezegen transiti, satürn transiti, jüpiter transiti',
    ogType: 'website',
    content: [
      'Gezegen Transitleri',
      'Transitler, gökyüzündeki şu anki gezegenlerin doğum haritanızdaki noktalara yaptığı açılardır.',
      'Major Transitler',
      '• Satürn Transiti: Yapılanma ve olgunlaşma',
      '• Jüpiter Transiti: Genişleme ve fırsatlar',
      '• Pluto Transiti: Derin dönüşüm',
      '• Uranüs Transiti: Beklenmedik değişimler',
    ],
  ),

  // Vedik
  PageMeta(
    route: 'vedic',
    title: 'Vedik Astroloji — Hint Astrolojisi Haritası | Astrobobo',
    description: 'Jyotish (Vedik Astroloji) haritanız. Sidereal zodiac, Nakshatra ve Dasha analizi.',
    keywords: 'vedik astroloji, jyotish, nakshatra, dasha',
    ogType: 'website',
    content: [
      'Vedik Astroloji — Jyotish',
      'Vedik astroloji, Hindistan kaynaklı kadim bir astroloji sistemidir.',
      'Temel Farklar',
      '• Sidereal zodiac kullanır (gerçek takımyıldız konumları)',
      '• Nakshatra sistemi: 27 Ay konağı',
      '• Dasha dönemleri: Gezegen periyotları',
      '• Farklı ev hesaplama sistemleri',
    ],
  ),

  // Drakonik
  PageMeta(
    route: 'draconic',
    title: 'Drakonik Harita — Ruhsal Köken Haritası | Astrobobo',
    description: 'Ay Düğümüne dayalı drakonik haritanız. Ruhsal kökeniniz ve karma mirasınız.',
    keywords: 'drakonik harita, draconic chart, ruhsal harita',
    ogType: 'website',
    content: [
      'Drakonik Harita — Ruhsal Köken',
      'Drakonik harita, Kuzey Ay Düğümünü 0° Koç noktasına yerleştirerek hesaplanır.',
      'Bu harita ruhsal özünüzü ve karma mirasınızı yansıtır.',
      'Drakonik Yorumlama',
      '• Ruhsal yetenekler ve potansiyeller',
      '• Geçmiş yaşam izleri',
      '• Karşılaşmanız gereken karma temalar',
    ],
  ),

  // Asteroidler
  PageMeta(
    route: 'asteroids',
    title: 'Asteroidler — Chiron, Lilith, Juno, Ceres | Astrobobo',
    description: 'Asteroitlerin doğum haritanızdaki etkileri. Chiron, Lilith, Juno, Ceres analizi.',
    keywords: 'asteroit, chiron, lilith, juno, ceres, pallas, vesta',
    ogType: 'website',
    content: [
      'Asteroidler',
      'Ana gezegenler dışındaki asteroitler, haritanıza derinlik katar.',
      'Önemli Asteroidler',
      '• Chiron: Şifacı yara, iyileşme potansiyeli',
      '• Lilith: Bastırılmış güç, gölge tarafı',
      '• Juno: İlişki kalıpları, bağlanma stili',
      '• Ceres: Bakım verme ve alma tarzı',
      '• Pallas: Strateji ve bilgelik',
      '• Vesta: Adanmışlık ve odak',
    ],
  ),

  // Local Space
  PageMeta(
    route: 'local-space',
    title: 'Local Space — Mekansal Astroloji | Astrobobo',
    description: 'Bulunduğunuz konumun astrolojik analizi. Gezegen yönleri ve enerji hatları.',
    keywords: 'local space, mekansal astroloji, astrokartografi',
    ogType: 'website',
    content: [
      'Local Space — Mekansal Astroloji',
      'Local Space, gezegensel enerjilerin fiziksel mekanınızdaki yönlerini gösterir.',
      'Uygulama Alanları',
      '• Ev düzeni ve feng shui entegrasyonu',
      '• Çalışma alanı optimizasyonu',
      '• Uyku yönü seçimi',
      '• Meditasyon köşesi yerleşimi',
    ],
  ),

  // Timing
  PageMeta(
    route: 'timing',
    title: 'Astrolojik Zamanlama — Electional Astrology | Astrobobo',
    description: 'Önemli kararlarınız için en uygun zamanları keşfedin.',
    keywords: 'electional astroloji, uygun zaman, muhurta',
    ogType: 'website',
    content: [
      'Astrolojik Zamanlama',
      'Electional astroloji, önemli eylemler için en uygun zamanları belirleme sanatıdır.',
      'Zamanlama Alanları',
      '• İş başlangıçları ve sözleşmeler',
      '• Evlilik ve nişan',
      '• Seyahat planlaması',
      '• Yatırım ve finansal kararlar',
      '• Ameliyat ve sağlık',
    ],
  ),

  // Year Ahead
  PageMeta(
    route: 'year-ahead',
    title: 'Yıllık Astroloji Önizlemesi — 2025 Analizi | Astrobobo',
    description: '2025 yılı için kişisel astroloji önizlemeniz. Major transitler ve tutulmalar.',
    keywords: '2025 astroloji, yıllık burç, yıl önizleme',
    ogType: 'article',
    content: [
      'Yıllık Astroloji Önizlemesi — 2025',
      '2025 yılının önemli astrolojik olayları ve kişisel etkileri.',
      '2025 Önemli Olaylar',
      '• Major gezegen transitleri',
      '• Tutulma sezonu etkileri',
      '• Retrograd dönemleri',
      '• Kişisel dönüm noktaları',
    ],
  ),

  // Weekly Horoscope
  PageMeta(
    route: 'weekly-horoscope',
    title: 'Haftalık Burç Yorumları | Astrobobo',
    description: 'Haftalık burç yorumları. Bu hafta burçları neler bekliyor?',
    keywords: 'haftalık burç, bu hafta burçlar, haftalık yorum',
    ogType: 'article',
    content: [
      'Haftalık Burç Yorumları',
      'Her pazartesi güncellenen detaylı haftalık analizler.',
      'Haftanın Kozmik Haritası',
      '• Ay transitleri ve duygusal akış',
      '• Haftanın kritik günleri',
      '• 12 burç için özel öneriler',
    ],
  ),

  // Monthly Horoscope
  PageMeta(
    route: 'monthly-horoscope',
    title: 'Aylık Burç Yorumları | Astrobobo',
    description: 'Aylık burç yorumları. Bu ay burçları neler bekliyor?',
    keywords: 'aylık burç, bu ay burçlar, aylık yorum',
    ogType: 'article',
    content: [
      'Aylık Burç Yorumları',
      'Her ayın başında güncellenen kapsamlı analizler.',
      'Ayın Vurguları',
      '• Yeniay ve dolunay etkileri',
      '• Önemli gezegen açıları',
      '• 12 burç için aylık rehber',
    ],
  ),

  // Yearly Horoscope
  PageMeta(
    route: 'yearly-horoscope',
    title: 'Yıllık Burç Yorumları 2025 | Astrobobo',
    description: '2025 yılı burç yorumları. Major gezegenler ve tutulmaların etkileri.',
    keywords: 'yıllık burç 2025, yıllık burç yorumu, 2025 burçlar',
    ogType: 'article',
    content: [
      'Yıllık Burç Yorumları — 2025',
      '2025 yılının kapsamlı astrolojik analizi.',
      'Yılın Temaları',
      '• Jüpiter ve Satürn etkileri',
      '• Tutulma eksenleri',
      '• 12 burç için yıllık rehber',
    ],
  ),

  // Celebrities
  PageMeta(
    route: 'celebrities',
    title: 'Ünlü Doğum Haritaları — Celebrity Astrology | Astrobobo',
    description: 'Ünlülerin doğum haritaları ve astrolojik analizleri.',
    keywords: 'ünlü doğum haritası, celebrity astrology, ünlü burç',
    ogType: 'website',
    content: [
      'Ünlü Doğum Haritaları',
      'Dünya genelindeki ünlülerin astrolojik portreleri.',
      'Kategoriler',
      '• Dünya liderleri',
      '• Sanatçılar ve müzisyenler',
      '• Sporcular',
      '• İş dünyası liderleri',
      '• Türk ünlüleri',
    ],
  ),

  // Glossary
  PageMeta(
    route: 'glossary',
    title: 'Astroloji Sözlüğü — Terimler ve Kavramlar | Astrobobo',
    description: "A'dan Z'ye astroloji terimleri sözlüğü.",
    keywords: 'astroloji sözlüğü, astroloji terimleri, astroloji kavramları',
    ogType: 'website',
    content: [
      "Astroloji Sözlüğü — A'dan Z'ye",
      'Astroloji dünyasının temel kavramlarının açıklamaları.',
      'Temel Terimler',
      '• Açı (Aspect): Gezegenler arası geometrik ilişkiler',
      '• Ev (House): Hayatın 12 farklı alanı',
      '• Transit: Şu anki gezegen konumları',
      '• Retrograd: Geri giden görünen gezegen',
      '• Yükselen (Ascendant): Doğu ufku burcu',
    ],
  ),

  // Tarot
  PageMeta(
    route: 'tarot',
    title: 'Tarot Falı — Günlük Tarot Kartı | Astrobobo',
    description: 'Ücretsiz tarot falı. Günlük kart, 3 kart açılımı, aşk tarot.',
    keywords: 'tarot, tarot falı, günlük tarot, tarot kartları',
    ogType: 'website',
    content: [
      'Tarot Falı',
      '78 karttan oluşan tarot destesi ile sembolik okumalar.',
      'Açılım Türleri',
      '• Günlük Kart: Günün mesajı',
      '• 3 Kart Açılımı: Geçmiş, şimdi, gelecek',
      '• Aşk Açılımı: İlişki dinamikleri',
      '• Celtic Cross: Detaylı analiz',
    ],
  ),

  // Numeroloji
  PageMeta(
    route: 'numerology',
    title: 'Numeroloji — Sayılarla Kişilik Analizi | Astrobobo',
    description: 'Yaşam yolu sayınız, kişilik sayınız ve ruh sayınız.',
    keywords: 'numeroloji, yaşam yolu sayısı, kişilik sayısı',
    ogType: 'website',
    content: [
      'Numeroloji — Sayıların Bilgeliği',
      'Doğum tarihiniz ve isminizden hesaplanan sayısal analizler.',
      'Temel Sayılar',
      '• Yaşam Yolu Sayısı: Hayat amacınız',
      '• Kişilik Sayısı: Dışa yansımanız',
      '• Ruh Sayısı: İç motivasyonunuz',
      '• Kader Sayısı: Potansiyeliniz',
    ],
  ),

  // Saturn Return
  PageMeta(
    route: 'saturn-return',
    title: 'Satürn Dönüşü — 29 Yaş Krizi Astrolojisi | Astrobobo',
    description: 'Satürn Dönüşü nedir ve sizi nasıl etkiler? 27-30 yaş dönemi analizi.',
    keywords: 'satürn dönüşü, saturn return, 29 yaş krizi',
    ogType: 'article',
    content: [
      'Satürn Dönüşü — Olgunlaşma Transiti',
      "Satürn'ün doğum konumuna dönmesi yaklaşık 29.5 yıl sürer.",
      'Satürn Dönüşü Dönemleri',
      '• 1. Dönüş (27-30 yaş): Yetişkinliğe geçiş',
      '• 2. Dönüş (56-60 yaş): Bilgelik dönemi',
      '• 3. Dönüş (84-90 yaş): Miras bırakma',
    ],
  ),

  // Premium
  PageMeta(
    route: 'premium',
    title: 'Astrobobo Premium — Gelişmiş Astroloji Özellikleri',
    description: 'Premium özelliklere erişin: Detaylı raporlar, karşılaştırmalı analizler.',
    keywords: 'astroloji premium, astrobobo premium',
    ogType: 'website',
    content: [
      'Astrobobo Premium',
      'Astroloji deneyiminizi bir üst seviyeye taşıyın.',
      'Premium Özellikler',
      '• Detaylı transit raporları',
      '• Sınırsız synastry analizi',
      '• Gelişmiş progresyon takibi',
      '• Reklamsız deneyim',
      '• Öncelikli destek',
    ],
  ),

  // Profile
  PageMeta(
    route: 'profile',
    title: 'Profilim — Astroloji Profilim | Astrobobo',
    description: 'Kişisel astroloji profiliniz. Kayıtlı haritalarınız ve tercihleriniz.',
    keywords: 'astroloji profil, doğum bilgisi, kişisel harita',
    ogType: 'profile',
    content: [
      'Astroloji Profilim',
      'Kişisel doğum bilgileriniz ve kayıtlı haritalarınız.',
      'Profil Özellikleri',
      '• Doğum haritanız',
      '• Kayıtlı partner/arkadaş haritaları',
      '• Favori analizleriniz',
      '• Kişisel tercihleriniz',
    ],
  ),

  // Settings
  PageMeta(
    route: 'settings',
    title: 'Ayarlar | Astrobobo',
    description: 'Uygulama ayarları. Ev sistemi, zodiac tipi ve tema tercihleri.',
    keywords: 'ayarlar, tercihler, uygulama ayarları',
    ogType: 'website',
    content: [
      'Uygulama Ayarları',
      'Astrobobo deneyiminizi özelleştirin.',
      'Ayar Kategorileri',
      '• Ev sistemi seçimi (Placidus, Whole Sign, vb.)',
      '• Zodiac tipi (Tropical/Sidereal)',
      '• Tema (Koyu/Açık)',
      '• Bildirim tercihleri',
    ],
  ),

  // Kozmoz
  PageMeta(
    route: 'kozmoz',
    title: 'Kozmoz — Günlük Kozmik Keşif | Astrobobo',
    description: 'Her gün yeni bir kozmik mesaj. Günün enerjisi ve kişisel rehberlik.',
    keywords: 'kozmik mesaj, günlük enerji, ay fazı',
    ogType: 'article',
    content: [
      'Kozmoz — Günlük Kozmik Keşif',
      'Her gün yeni bir kozmik içgörü sizi bekliyor.',
      'Günlük İçerikler',
      '• Günün kozmik mesajı',
      '• Ay fazı etkisi',
      '• Günün rengi ve sayısı',
      '• Kişisel affirmation',
    ],
  ),

  // Dreams
  PageMeta(
    route: 'dreams',
    title: 'Rüya Yorumu — Sembolik Rüya Analizi | Astrobobo',
    description: 'Rüyalarınızın sembolik anlamlarını keşfedin.',
    keywords: 'rüya yorumu, rüya analizi, rüya sembolleri',
    ogType: 'website',
    content: [
      'Rüya Yorumu',
      'Bilinçaltınızın mesajlarını sembolik perspektiften keşfedin.',
      'Rüya Analizi Yaklaşımı',
      '• Arketipsel sembol yorumlama',
      '• Kişisel bağlam değerlendirmesi',
      '• Duygusal rezonans analizi',
      '• İçgörü ve farkındalık',
    ],
  ),

  // Chakra
  PageMeta(
    route: 'chakra',
    title: 'Chakra Analizi — Enerji Merkezi Dengesi | Astrobobo',
    description: 'Yedi ana chakranızın analizi. Enerji blokajları ve denge durumu.',
    keywords: 'chakra, enerji merkezi, chakra dengesi, kundalini',
    ogType: 'website',
    content: [
      'Chakra Analizi',
      'Yedi ana enerji merkezinizin durumunu keşfedin.',
      'Yedi Chakra',
      '• Muladhara (Kök): Güvenlik ve temel',
      '• Svadhisthana (Sakral): Yaratıcılık ve duygular',
      '• Manipura (Güneş Pleksusu): Güç ve irade',
      '• Anahata (Kalp): Sevgi ve şefkat',
      '• Vishuddha (Boğaz): İletişim ve ifade',
      '• Ajna (Üçüncü Göz): Sezgi ve içgörü',
      '• Sahasrara (Taç): Bilincin birliği',
    ],
  ),

  // Rituals
  PageMeta(
    route: 'rituals',
    title: 'Kozmik Ritüeller — Ay Fazı Ritüelleri | Astrobobo',
    description: 'Yeniay ve dolunay ritüelleri. Niyet belirleme ve manifestasyon.',
    keywords: 'ritüel, yeniay ritüeli, dolunay ritüeli, manifestasyon',
    ogType: 'article',
    content: [
      'Kozmik Ritüeller',
      'Ayın döngüleriyle uyumlu pratikler.',
      'Ritüel Türleri',
      '• Yeniay Ritüeli: Yeni başlangıçlar için niyet belirleme',
      '• Dolunay Ritüeli: Bırakma ve tamamlama',
      '• Tutulma Ritüelleri: Dönüşüm pratikleri',
      '• Mevsim ritüelleri: Ekinoks ve gündönümü',
    ],
  ),
];

void main() async {
  final webDir = Directory('web');

  if (!await webDir.exists()) {
    print('Error: web directory not found. Run from project root.');
    return;
  }

  print('🌙 Generating static HTML pages for SEO...\n');

  for (final page in pages) {
    final fileName = page.route.isEmpty ? 'index-static.html' : '${page.route}.html';
    final file = File('web/$fileName');

    final html = generateHtml(page);
    await file.writeAsString(html);

    print('✓ Generated: $fileName');
  }

  // Generate sitemap
  await generateSitemap();

  print('\n✨ Done! Generated ${pages.length} static pages.');
  print('\nNext steps:');
  print('1. Configure your server to serve these as fallbacks for crawlers');
  print('2. Use user-agent detection or prerender.io for dynamic serving');
}

String generateHtml(PageMeta page) {
  final canonicalUrl = page.route.isEmpty
      ? baseUrl
      : '$baseUrl/${page.route}';

  final contentHtml = page.content.map((line) {
    if (line.startsWith('•')) {
      return '      <li>${line.substring(2)}</li>';
    } else if (line == page.content.first) {
      return '      <h1 style="color: #FFD700; font-size: 2rem; margin-bottom: 1rem;">$line</h1>';
    } else if (line.contains('Nedir') ||
               line.contains('Temalar') ||
               line.contains('Özellikler') ||
               line.contains('Analiz') ||
               line.contains('Metodoloji') ||
               line.contains('Kategoriler') ||
               line.contains('Türleri') ||
               line.contains('Sayılar') ||
               line.contains('Chakra') ||
               line.contains('Dönemleri')) {
      return '      <h2 style="color: #C9B8FF; font-size: 1.5rem; margin-top: 1.5rem;">$line</h2>';
    } else {
      return '      <p style="line-height: 1.6;">$line</p>';
    }
  }).join('\n');

  return '''<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Primary SEO -->
  <title>${page.title}</title>
  <meta name="description" content="${page.description}">
  <meta name="keywords" content="${page.keywords}">
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="$canonicalUrl">

  <!-- Open Graph -->
  <meta property="og:type" content="${page.ogType}">
  <meta property="og:url" content="$canonicalUrl">
  <meta property="og:title" content="${page.title}">
  <meta property="og:description" content="${page.description}">
  <meta property="og:image" content="$baseUrl/images/og-image.png">
  <meta property="og:locale" content="tr_TR">
  <meta property="og:site_name" content="Astrobobo">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="${page.title}">
  <meta name="twitter:description" content="${page.description}">
  <meta name="twitter:image" content="$baseUrl/images/twitter-image.png">

  <!-- Theme -->
  <meta name="theme-color" content="#0D0D1A">
  <link rel="icon" href="/favicon.png">

  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: linear-gradient(135deg, #0D0D1A 0%, #1A1A2E 100%);
      color: #F5F5F5;
      min-height: 100vh;
      padding: 2rem;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
    }
    ul {
      list-style: none;
      margin: 1rem 0;
    }
    li {
      padding: 0.5rem 0;
      padding-left: 1.5rem;
      position: relative;
    }
    li::before {
      content: "✦";
      position: absolute;
      left: 0;
      color: #FFD700;
    }
    .cta {
      display: inline-block;
      margin-top: 2rem;
      padding: 1rem 2rem;
      background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
      color: #0D0D1A;
      text-decoration: none;
      border-radius: 8px;
      font-weight: bold;
    }
    .footer {
      margin-top: 3rem;
      padding-top: 2rem;
      border-top: 1px solid #333;
      text-align: center;
      color: #888;
    }
    .footer a { color: #C9B8FF; text-decoration: none; }
  </style>
</head>
<body>
  <div class="container">
$contentHtml

    <a href="/" class="cta">Uygulamayı Aç →</a>

    <div class="footer">
      <p>© 2025 Astrobobo — Kişisel Kozmik Rehberiniz</p>
      <p>
        <a href="/birth-chart">Doğum Haritası</a> ·
        <a href="/horoscope">Burç Yorumları</a> ·
        <a href="/synastry">İlişki Uyumu</a> ·
        <a href="/tarot">Tarot</a> ·
        <a href="/glossary">Sözlük</a>
      </p>
    </div>
  </div>

  <!-- Redirect to app for regular users -->
  <script>
    // Only redirect if JavaScript is enabled and not a crawler
    var userAgent = navigator.userAgent.toLowerCase();
    var isCrawler = /bot|crawler|spider|crawling|googlebot|bingbot|yandex|baidu/i.test(userAgent);
    if (!isCrawler) {
      window.location.href = '/${page.route}';
    }
  </script>
</body>
</html>
''';
}

Future<void> generateSitemap() async {
  final now = DateTime.now().toIso8601String().split('T')[0];

  final urls = pages.map((page) {
    final loc = page.route.isEmpty ? baseUrl : '$baseUrl/${page.route}';
    final priority = page.route.isEmpty ? '1.0' :
                     page.route == 'birth-chart' ? '0.9' :
                     page.route == 'horoscope' ? '0.9' : '0.8';
    return '''  <url>
    <loc>$loc</loc>
    <lastmod>$now</lastmod>
    <changefreq>daily</changefreq>
    <priority>$priority</priority>
  </url>''';
  }).join('\n');

  final sitemap = '''<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$urls
</urlset>
''';

  await File('web/sitemap.xml').writeAsString(sitemap);
  print('✓ Generated: sitemap.xml');
}
