/// Dream Advanced Content - Lucid Rüya, Kişilik Rüya Profilleri, Rüya Ritüelleri
/// İleri düzey rüya çalışmaları için kapsamlı içerik
library;

// ════════════════════════════════════════════════════════════════════════════
// LUCİD RÜYA TEKNİKLERİ
// ════════════════════════════════════════════════════════════════════════════

/// Lucid rüya teknikleri ve rehberi
class LucidRuyaRehberi {
  /// Temel teknikler
  static const List<LucidTechnique> teknikler = [
    LucidTechnique(
      id: 'reality-check',
      name: 'Reality Check',
      nameTr: 'Gerçeklik Kontrolü',
      difficulty: 'Başlangıç',
      description:
          'Gün içinde düzenli olarak "Rüyada mıyım?" sorusunu sor ve gerçeklik testleri yap.',
      steps: [
        'Günde en az 10-15 kez gerçeklik kontrolü yap',
        'Ellerine bak - rüyada parmaklar bulanık veya fazla/eksik olur',
        'Bir metni iki kez oku - rüyada yazı değişir',
        'Burnunu kapatıp nefes almayı dene - rüyada hâlâ nefes alabilirsin',
        'Işık düğmesine bas - rüyada ışık düzgün çalışmaz',
        'Bu kontrolleri günlük rutinin yap - bilinçaltı öğrenecek',
      ],
      tips: [
        'Kontrol yaparken gerçekten sorgula, otomatik yapma',
        'Telefon alarmı kur, her çaldığında kontrol et',
        'Kapılardan geçerken kontrol et - tetikleyici oluştur',
      ],
      timeToMaster: '2-4 hafta düzenli pratikle',
      successRate: 'Yeni başlayanlar için en etkili teknik',
    ),
    LucidTechnique(
      id: 'wild',
      name: 'WILD',
      nameTr: 'Uyanıkken Başlatılan Lucid Rüya',
      difficulty: 'İleri',
      description:
          'Uyanıkken doğrudan rüyaya geçiş. Bilinç kaybetmeden rüya haline giriş.',
      steps: [
        '4-6 saat uyuduktan sonra uyan (REM dönemine denk gelir)',
        '15-30 dakika uyanık kal, kitap oku veya yazı yaz',
        'Tekrar yat, sırtüstü veya rahat pozisyonda',
        'Bedenin uyumasına izin ver, zihnin uyanık kalsın',
        'Hipnagojik görüntüleri izle (göz ardı halüsinasyonları)',
        'Görüntüler netleşince, kendini rüyanın içinde bul',
      ],
      tips: [
        'Uyku felci olabilir - panik yapma, bu geçiş aşaması',
        'Nefese odaklan, düşünceleri bırak',
        'İlk denemeler genellikle başarısız - sabır',
        'Alfa dalgası müziği yardımcı olabilir',
      ],
      timeToMaster: '1-3 ay yoğun pratikle',
      successRate: 'En net lucid deneyimi sağlar ama en zoru',
    ),
    LucidTechnique(
      id: 'mild',
      name: 'MILD',
      nameTr: 'Anımsatıcı Lucid Rüya Telkini',
      difficulty: 'Orta',
      description: 'Uyumadan önce niyet kurarak rüyada farkındalık tetiklemek.',
      steps: [
        'Uyumadan önce bir rüyayı detaylı hatırla',
        'O rüyada farkındalığın olduğunu hayal et',
        '"Rüyada olduğumu anlayacağım" niyetini tekrarla',
        'Farkındalık anını görselleştir',
        'Bu niyetle uykuya dal',
        'Gece uyanırsan, niyeti tekrarla ve devam et',
      ],
      tips: [
        'Affirmasyonu kendi sözlerinle oluştur',
        'Duygusal bağlantı kur - neden lucid olmak istiyorsun?',
        'Rüya günlüğü tutmak MILD etkinliğini artırır',
      ],
      timeToMaster: '2-6 hafta',
      successRate: 'En dengelenmiş teknik - orta zorluk, iyi sonuç',
    ),
    LucidTechnique(
      id: 'wbtb',
      name: 'WBTB',
      nameTr: 'Uyanıp Tekrar Yatma',
      difficulty: 'Orta',
      description:
          'Gece ortasında uyanıp, kısa süre sonra tekrar uyumak. REM dönemini hedefler.',
      steps: [
        '5-6 saat uyuduktan sonra alarm kur',
        'Uyanınca 20-60 dakika uyanık kal',
        'Bu sürede lucid rüya hakkında oku veya düşün',
        'Tekrar uykuya dal - mümkünse MILD veya WILD ile birleştir',
        'Sabah REM dönemleri uzundur - lucid şansı yüksek',
      ],
      tips: [
        'Çok uyanık kalma - tekrar uyumak zorlaşır',
        'Parlak ışıktan kaçın - melatonini bozma',
        'Hafta sonları dene - uyku borcunu telafi edebilirsin',
      ],
      timeToMaster: '1-2 hafta',
      successRate: 'Diğer tekniklerle birleştirildiğinde çok etkili',
    ),
    LucidTechnique(
      id: 'ssild',
      name: 'SSILD',
      nameTr: 'Duyularla Başlatılan Lucid Rüya',
      difficulty: 'Orta',
      description:
          'Duyulara odaklanarak bilinçaltını tetiklemek. WBTB ile birlikte kullanılır.',
      steps: [
        'WBTB sonrası uyanıkken yat',
        'Gözlerin kapalı, göz ardındaki görüntülere odaklan (10-15 sn)',
        'Kulaklarına odaklan, sesleri dinle (10-15 sn)',
        'Bedenine odaklan, ağırlığı hisset (10-15 sn)',
        'Bu döngüyü 4-6 kez tekrarla',
        'Sonra bırak ve uyu - bilinçaltı devralır',
      ],
      tips: [
        'Konsantre olma, pasif gözlem yap',
        'Döngüleri hızlandırma, yavaş ve rahat',
        'Uyku felci olabilir - korkmadan gözlemle',
      ],
      timeToMaster: '2-4 hafta',
      successRate: 'Yeni geliştirilmiş, yüksek başarı oranı rapor ediliyor',
    ),
  ];

  /// Lucid rüyada yapılacaklar
  static const List<String> lucidAktiviteler = [
    'Uç - en popüler lucid aktivitesi, özgürlük deneyimi',
    'Rüya rehberinle tanış - "Rehberim nerede?" diye sor',
    'Bilinçaltına soru sor - cevaplar sembolik gelir',
    'Gölgenle yüzleş - "Gölgem nerede?" de, kucakla',
    'Geçmiş yaşamları keşfet - "Beni geçmişe götür" niyeti',
    'Yaratıcı problem çözümü - uyanıkken çözemediğin soruyu sor',
    'Şifa çalışması - bedenin sağlıklı halini görselleştir',
    'Paralel evrenleri keşfet - "Başka bir versiyonumu göster"',
    'Ölüm deneyimi - güvenli ortamda "ölümü" deneyimle (dönüştürücü)',
    'Teleportasyon - bir yeri düşün ve orada ol',
    'Zaman yolculuğu - geçmişe veya geleceğe git',
    'Rüya karakterleriyle konuş - kim olduklarını sor',
  ];

  /// Stabilizasyon teknikleri (rüyada kalmak için)
  static const List<String> stabilizasyonTeknikleri = [
    'Ellerine bak ve döndür - görsel odak sağlar',
    'Yere doğru eğil ve detayları incele',
    '"Netlik artır!" veya "Stabilize ol!" diye bağır',
    'Etrafta dön - ama kontrollü, düşme riski var',
    'Nesnelere dokun - dokunsal his stabilize eder',
    'Matematik yap - "2+2 kaç?" gibi basit işlemler',
    'Rüyanın içinde yürümeye başla - hareket stabilize eder',
    'Derin nefes al - fizyolojik bağlantı kurar',
  ];

  /// Yaygın sorunlar ve çözümleri
  static const Map<String, String> sorunCozumleri = {
    'Hemen uyanıyorum':
        'Heyecanı kontrol et. Stabilizasyon tekniklerini kullan. İlk lucid rüyalar kısa olur - normal.',
    'Lucid olamıyorum':
        'Rüya hatırlama kapasiteni geliştir. Günde 3-5 rüya hatırlamadan lucid zor.',
    'Rüya bulanık': '"Netlik!" komutu ver. Ellerine bak. Detaylara odaklan.',
    'Kontrol edemiyorum':
        'Kontrol etmeye çalışma, akışa bırak. Niyet kur ama zorlamadan.',
    'Kötü deneyimler':
        'Lucid kâbus, gölge entegrasyonu için fırsat. Korkma, sor: "Ne öğretiyorsun?"',
    'Uyku kalitesi bozuldu':
        'WBTB\'yi azalt. Rüya çalışmasını hafta sonlarına kaydır.',
  };
}

/// Lucid teknik modeli
class LucidTechnique {
  final String id;
  final String name;
  final String nameTr;
  final String difficulty;
  final String description;
  final List<String> steps;
  final List<String> tips;
  final String timeToMaster;
  final String successRate;

  const LucidTechnique({
    required this.id,
    required this.name,
    required this.nameTr,
    required this.difficulty,
    required this.description,
    required this.steps,
    required this.tips,
    required this.timeToMaster,
    required this.successRate,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// PSİKOLOJİK RÜYA TEMATİKLERİ
// ════════════════════════════════════════════════════════════════════════════

/// Psikolojik rüya tema kategorileri
class PsikolojikRuyaTemalari {
  /// Temel psikolojik rüya tema grupları
  static const List<DreamThemeCategory> temaKategorileri = [
    DreamThemeCategory(
      category: 'Duygusal Dünya',
      symbol: '☽',
      emoji: '🌙',
      description:
          'Rüyalar, duygusal durumumuzu yansıtma eğilimindedir. Uyku döngüleri ve uyku kalitesi rüya yoğunluğunu etkileyebilir.',
      themeDetails: {
        'Cesaret & Eylem':
            'Aksiyon rüyaları, mücadele, rekabet, cesaret temaları',
        'Güvenlik & Konfor': 'Doğa, yemek, konfor, maddi güvenlik rüyaları',
        'İletişim & Bağlantı': 'İletişim, yolculuk, çokluk rüyaları',
        'Aile & Yuva': 'Ev, aile, anne, su, duygusal yoğun rüyalar',
        'İfade & Yaratıcılık': 'Sahne, tanınma, yaratıcılık, kalp rüyaları',
        'Düzen & Analiz': 'Detay, sağlık, iş, düzenleme rüyaları',
        'İlişki & Denge': 'İlişki, denge, adalet, güzellik rüyaları',
        'Dönüşüm & Derinlik': 'Dönüşüm, yeniden doğuş, gizem temaları',
        'Keşif & Anlam': 'Seyahat, felsefe, eğitim, yabancı kültür temaları',
        'Hedef & Yapı': 'Kariyer, otorite, yapı, baba figürü temaları',
        'Yenilik & Vizyon': 'Grup, teknoloji, gelecek, sıra dışı temalar',
        'Sezgi & Hayal Gücü':
            'Sezgisel, derin, su, kaybolma, sezgisel mesajlar',
      },
      notes:
          'Uyku kalitesi yüksek olduğunda rüyalar daha canlı hatırlanabilir. Derin uyku dönemlerinde rüya hatırlama azalabilir.',
    ),
    DreamThemeCategory(
      category: 'İletişim & İfade',
      symbol: '☿',
      emoji: '📝',
      description:
          'İletişim ve ifade ile ilgili rüyalar, iç dünyamızdaki tamamlanmamış diyalogları yansıtabilir.',
      themeDetails: {
        'Geçmiş':
            'Geçmişle ilgili rüyalar, eski insanlar, tamamlanmamış konuşmalar',
        'Netlik': 'Net mesajlar, berrak semboller, iletişim temaları',
      },
      notes:
          'İletişim temelli rüyalarda karışık mesajlar ve geçmişten figürler görülebilir. Bu, iç sesin işlenme biçimidir.',
    ),
    DreamThemeCategory(
      category: 'İlişkiler & Değerler',
      symbol: '♀',
      emoji: '💕',
      description:
          'Aşk, güzellik ve değerlerle ilgili rüyalar, ilişkisel ihtiyaçlarımızı yansıtma eğilimindedir.',
      themeDetails: {
        'Tutku': 'Tutku, heyecan, yeni ilişki rüyaları',
        'Konfor': 'Duyusal, rahat, güzel mekanlar rüyası',
        'Uyum': 'Romantik, uyumlu, ideal partner rüyaları',
        'Derinlik': 'Yoğun, dönüştürücü ilişki rüyaları',
        'Nostalji': 'Özlem, kayıp sevgili, nostalji',
      },
      notes:
          'Eski ilişkilerle ilgili rüyalar, tamamlanmamış duygusal süreçleri işaret edebilir.',
    ),
    DreamThemeCategory(
      category: 'Enerji & Eylem',
      symbol: '♂',
      emoji: '⚔️',
      description:
          'Eylem, öfke ve enerji ile ilgili rüyalar, bastırılmış duyguları işleme biçimimiz olabilir.',
      themeDetails: {
        'Mücadele': 'Savaş, yarış, rekabet, kazanma rüyaları',
        'Güç': 'Yoğun duygusal güç mücadelesi, dönüşüm',
        'Kariyer': 'Kariyer mücadelesi, otorite çatışması',
      },
      notes:
          'Bastırılmış öfke rüyalarda yoğunlaşabilir. Bu temaları fark etmek, enerjiyi bilinçli yönlendirmeye yardımcı olabilir.',
    ),
    DreamThemeCategory(
      category: 'Büyüme & Genişleme',
      symbol: '♃',
      emoji: '🎯',
      description:
          'Büyüme, bolluk ve öğrenme temaları, kişisel gelişim süreçlerimizi yansıtabilir.',
      themeDetails: {
        'Keşif': 'Büyük yolculuklar, felsefe, öğretmenler rüyası',
        'İç Uyanış': 'İçsel uyanış, derin deneyimler',
        'Yenilik': 'Yeni başlangıçlar, cesaret, macera',
      },
      notes:
          'İyimser ve genişletici rüyalar, kişisel büyüme dönemlerinde daha sık görülme eğilimindedir.',
    ),
    DreamThemeCategory(
      category: 'Sorumluluk & Olgunlaşma',
      symbol: '♄',
      emoji: '⏳',
      description:
          'Sorumluluk ve zaman temalı rüyalar, hayattaki sınırlarımızı ve olgunlaşma sürecimizi yansıtabilir.',
      themeDetails: {
        'Yapı': 'Kariyer baskısı, baba figürü, yapı rüyaları',
        'Toplum': 'Toplumsal sorumluluk, yalnızlık, reform',
        'İlişki': 'İlişki testleri, bağlılık soruları',
      },
      notes:
          'Olgunlaşma dönemlerinde (özellikle 28-30 yaş civarı) yoğun öğretici rüyalar görülme eğilimindedir.',
    ),
    DreamThemeCategory(
      category: 'Sürpriz & Uyanış',
      symbol: '♅',
      emoji: '⚡',
      description:
          'Beklenmedik ve sıra dışı rüyalar, bilinçaltımızdaki yenilikçi düşünceyi yansıtabilir.',
      themeDetails: {
        'Genel': 'Sıra dışı deneyimler, teknoloji, uzay, uçak rüyaları',
      },
      notes:
          'Sıra dışı rüya dönemlerinde lucid rüya farkındalığı artma eğilimi gösterebilir.',
    ),
    DreamThemeCategory(
      category: 'Hayal Gücü & Sezgi',
      symbol: '♆',
      emoji: '🔮',
      description:
          'Hayal gücü ve sezgiye dayalı rüyalar, iç dünyamızdaki yaratıcı potansiyeli yansıtabilir.',
      themeDetails: {
        'Derinlik':
            'En yoğun rüya deneyimleri, derin iç mesajlar, anı parçaları',
        'Kolektif': 'Kolektif bilinç rüyaları, insanlık temaları',
      },
      notes:
          'Canlı ve etkileyici rüyalar, hayal gücünün aktif olduğu dönemlerde daha sık görülme eğilimindedir.',
    ),
    DreamThemeCategory(
      category: 'Dönüşüm & Yeniden Doğuş',
      symbol: '♇',
      emoji: '🦂',
      description:
          'Dönüşüm ve yeniden doğuş temaları, hayatımızdaki derin değişim süreçlerini yansıtabilir.',
      themeDetails: {'Genel': 'Dönüşüm, yılan, yeraltı, hazine rüyaları'},
      notes:
          'Yoğun değişim dönemlerinde kâbuslar artabilir, ancak bunlar derin bir şifa süreci taşıyabilir.',
    ),
  ];

  /// Uyku döngüsü notları
  static const Map<String, SleepCycleDreamNote> uykuDongusuNotlari = {
    'derinUyku': SleepCycleDreamNote(
      phase: 'Derin Uyku',
      emoji: '🌑',
      dreamQuality: 'Derin ama hatırlanması zor',
      themes: ['Yeni başlangıçlar', 'Tohum fikirleri', 'Dinlenme'],
      lucidPotential: 'Düşük - bilinçdışı çok aktif',
      advice: 'Uyumadan önce niyet koy. Ne başlatmak istiyorsun?',
      journalPrompt: 'Yeni döngüde neyi keşfetmek istiyorum?',
    ),
    'hafifUyku': SleepCycleDreamNote(
      phase: 'Hafif Uyku Geçişi',
      emoji: '🌒',
      dreamQuality: 'Artan netlik, büyüme temaları',
      themes: ['Büyüme', 'Cesaret', 'İlk adımlar', 'Umut'],
      lucidPotential: 'Orta - farkındalık artıyor',
      advice: 'Rüyalardaki işaretlere dikkat et. Niyetinin ipuçları var.',
      journalPrompt: 'Hangi düşünceler filizleniyor?',
    ),
    'remBaslangic': SleepCycleDreamNote(
      phase: 'REM Başlangıcı',
      emoji: '🌓',
      dreamQuality: 'Gerilim, karar noktaları',
      themes: ['Çatışma', 'Seçim', 'Engeller', 'Eylem çağrısı'],
      lucidPotential: 'Orta-yüksek - kararsızlık lucid tetikleyebilir',
      advice: 'Rüyadaki çatışmalar gerçek hayat kararlarını yansıtabilir.',
      journalPrompt: 'Hangi seçimle karşı karşıyayım?',
    ),
    'remYogunlasan': SleepCycleDreamNote(
      phase: 'Yoğunlaşan REM',
      emoji: '🌔',
      dreamQuality: 'Yoğunlaşan, detaylı',
      themes: ['Tamamlanma', 'İnşa', 'Netleşme'],
      lucidPotential: 'Yüksek - farkındalık doruğa yaklaşıyor',
      advice: 'Rüyalar ne tamamlanmak üzere olduğunu gösterebilir.',
      journalPrompt: 'Ne olgunlaşıyor hayatımda?',
    ),
    'remDoruk': SleepCycleDreamNote(
      phase: 'REM Doruk Noktası',
      emoji: '🌕',
      dreamQuality: 'En canlı, hatırlanması kolay, yoğun',
      themes: ['Farkındalık', 'Açığa çıkma', 'Doruk', 'Tamamlanma'],
      lucidPotential: 'En yüksek - farkındalık doruğunda',
      advice: 'Rüya günlüğünü yastığının yanına koy.',
      journalPrompt: 'Ne aydınlandı? Ne fark ettim?',
    ),
    'remAzalan': SleepCycleDreamNote(
      phase: 'Azalan REM',
      emoji: '🌖',
      dreamQuality: 'Yansıtıcı, değerlendirici',
      themes: ['Değerlendirme', 'Minnettarlık', 'Geri bakış'],
      lucidPotential: 'Orta-yüksek',
      advice: 'Rüyalar neyin işe yaradığını gösterebilir.',
      journalPrompt: 'Neye minnettarım? Ne öğrendim?',
    ),
    'uyanmaOncesi': SleepCycleDreamNote(
      phase: 'Uyanma Öncesi',
      emoji: '🌗',
      dreamQuality: 'Bırakma temaları, temizlik',
      themes: ['Bırakma', 'Affetme', 'Temizlik', 'Son'],
      lucidPotential: 'Orta',
      advice: 'Rüyalarda gördüğün "eski" şeyleri bırakmanın zamanı olabilir.',
      journalPrompt: 'Neyi bırakmam gerekiyor?',
    ),
    'derinDinlenme': SleepCycleDreamNote(
      phase: 'Derin Dinlenme',
      emoji: '🌘',
      dreamQuality: 'En derin, en gizli mesajlar',
      themes: ['Geri çekilme', 'Dinlenme', 'Gizli bilgelik', 'Bilinçdışı'],
      lucidPotential: 'Düşük ama gerçekleşirse çok derin',
      advice: 'Dinlen. Zorla hatırlama. Bırak gitsin.',
      journalPrompt: 'Sessizlikte ne öğreniyorum?',
    ),
  };

  /// Kişilik arketipine göre rüya temaları
  static const Map<String, ArchetypeDreamProfile> arketipRuyaProfili = {
    'pioneer': ArchetypeDreamProfile(
      archetype: 'Öncü',
      emoji: '🚀',
      commonThemes: [
        'Savaş',
        'yarış',
        'yangın',
        'kırmızı',
        'baş/kafa',
        'öncülük',
      ],
      nightmareThemes: ['Yenilgi', 'geç kalma', 'güçsüzlük', 'hareketsizlik'],
      lucidTendency: 'Yüksek - güçlü irade',
      dreamAdvice:
          'Rüyalarında eylem çağrısı ara. Pasif izleme sana göre değil.',
      dreamSymbols: ['Kılıç', 'ateş', 'kırmızı', 'at'],
    ),
    'builder': ArchetypeDreamProfile(
      archetype: 'Kurucu',
      emoji: '🏗',
      commonThemes: ['Doğa', 'yemek', 'para', 'bahçe', 'konfor', 'boyun'],
      nightmareThemes: [
        'Yoksulluk',
        'açlık',
        'değişim zorlaması',
        'istikrarsızlık',
      ],
      lucidTendency: 'Orta - sabırlı ama yavaş',
      dreamAdvice:
          'Duyusal detaylara dikkat et. Rüyandaki koku, tat, dokunuş önemli.',
      dreamSymbols: ['Çiçek', 'toprak', 'yeşil', 'dağ'],
    ),
    'communicator': ArchetypeDreamProfile(
      archetype: 'İletişimci',
      emoji: '💬',
      commonThemes: [
        'İletişim',
        'yolculuk',
        'çokluk',
        'kitaplar',
        'telefon',
        'eller',
      ],
      nightmareThemes: [
        'Konuşamama',
        'yanlış anlaşılma',
        'kaybolma',
        'bölünme',
      ],
      lucidTendency: 'Yüksek - meraklı zihin',
      dreamAdvice:
          'Rüyalardaki konuşmalara dikkat et. Mesajlar kelimelerle gelir.',
      dreamSymbols: ['Kuş', 'kanat', 'sarı', 'kitap'],
    ),
    'nurturer': ArchetypeDreamProfile(
      archetype: 'Koruyucu',
      emoji: '🛡',
      commonThemes: ['Ev', 'aile', 'anne', 'su', 'geçmiş', 'göğüs', 'mutfak'],
      nightmareThemes: ['Evsizlik', 'aile kaybı', 'boğulma', 'terk edilme'],
      lucidTendency: 'Yüksek - güçlü bilinçdışı bağlantı',
      dreamAdvice: 'Rüyaların duygusal termometren. Hislerine güven.',
      dreamSymbols: ['Deniz kabuğu', 'su', 'gümüş', 'yuva'],
    ),
    'performer': ArchetypeDreamProfile(
      archetype: 'Sahne Yıldızı',
      emoji: '🌟',
      commonThemes: [
        'Sahne',
        'tanınma',
        'altın',
        'güneş',
        'kalp',
        'çocuklar',
        'yaratıcılık',
      ],
      nightmareThemes: [
        'Görmezden gelinme',
        'alay',
        'tahttan düşme',
        'kalp sorunları',
      ],
      lucidTendency: 'Çok yüksek - güçlü irade ve ego',
      dreamAdvice: 'Rüyalarında liderlik rolünü keşfet.',
      dreamSymbols: ['Güneş', 'altın', 'taç', 'ışık'],
    ),
    'analyst': ArchetypeDreamProfile(
      archetype: 'Analist',
      emoji: '🔍',
      commonThemes: ['İş', 'sağlık', 'detay', 'temizlik', 'sindirim', 'analiz'],
      nightmareThemes: [
        'Düzensizlik',
        'hastalık',
        'eleştiri',
        'mükemmel olmama',
      ],
      lucidTendency: 'Orta - analitik ama skeptik',
      dreamAdvice: 'Detaylara odaklan ama büyük resmi kaçırma.',
      dreamSymbols: ['Buğday', 'yeşil', 'kristal', 'bahçe'],
    ),
    'harmonizer': ArchetypeDreamProfile(
      archetype: 'Dengeleyici',
      emoji: '⚖️',
      commonThemes: [
        'İlişki',
        'denge',
        'güzellik',
        'adalet',
        'evlilik',
        'uyum',
      ],
      nightmareThemes: [
        'Adaletsizlik',
        'yalnızlık',
        'karar verememe',
        'çirkinlik',
      ],
      lucidTendency: 'Orta - kararsızlık engelleyebilir',
      dreamAdvice: 'İlişki rüyalarına dikkat et. Denge nerede bozuk?',
      dreamSymbols: ['Gül', 'pembe', 'ayna', 'köprü'],
    ),
    'transformer': ArchetypeDreamProfile(
      archetype: 'Dönüştürücü',
      emoji: '🦋',
      commonThemes: [
        'Dönüşüm',
        'ölüm',
        'gizem',
        'yeraltı',
        'derinlik',
        'yeniden doğuş',
      ],
      nightmareThemes: ['İhanet', 'güç kaybı', 'açığa çıkma', 'zehir'],
      lucidTendency: 'Çok yüksek - derin bilinçdışı erişim',
      dreamAdvice: 'Karanlık rüyalardan korkma. En derin şifa oradan gelir.',
      dreamSymbols: ['Yılan', 'anka kuşu', 'bordo', 'ateş'],
    ),
    'explorer': ArchetypeDreamProfile(
      archetype: 'Kaşif',
      emoji: '🧭',
      commonThemes: [
        'Seyahat',
        'felsefe',
        'at',
        'eğitim',
        'yabancı ülkeler',
        'macera',
      ],
      nightmareThemes: ['Hapis', 'kısıtlanma', 'dogma', 'anlamsızlık'],
      lucidTendency: 'Yüksek - maceraperest ruh',
      dreamAdvice: 'Rüyalardaki yolculuklar iç arayışını yansıtabilir.',
      dreamSymbols: ['Ok', 'at', 'mor', 'yıldızlar'],
    ),
    'achiever': ArchetypeDreamProfile(
      archetype: 'Başarıcı',
      emoji: '🏔',
      commonThemes: [
        'Kariyer',
        'dağ',
        'baba',
        'yapı',
        'zaman',
        'kemikler',
        'dizler',
      ],
      nightmareThemes: ['Başarısızlık', 'düşüş', 'rezil olma', 'yaşlanma'],
      lucidTendency: 'Orta - disiplinli ama rüyalara mesafeli',
      dreamAdvice: 'Kariyer rüyaları gerçek hedeflerini yansıtabilir.',
      dreamSymbols: ['Dağ', 'taş', 'siyah', 'yapı'],
    ),
    'visionary': ArchetypeDreamProfile(
      archetype: 'Vizyoner',
      emoji: '💡',
      commonThemes: [
        'Grup',
        'teknoloji',
        'gelecek',
        'uzay',
        'reform',
        'yenilik',
      ],
      nightmareThemes: ['Uyumsuzluk', 'yalnızlık', 'distopya', 'makineleşme'],
      lucidTendency: 'Yüksek - alışılmadık zihin',
      dreamAdvice: 'Sıra dışı rüyaların yaratıcı yeteneklerini yansıtabilir.',
      dreamSymbols: ['Su dalgası', 'yıldız', 'mavi', 'elektrik'],
    ),
    'dreamer': ArchetypeDreamProfile(
      archetype: 'Hayalperest',
      emoji: '🌙',
      commonThemes: [
        'Su',
        'hayal gücü',
        'kaybolma',
        'sezgi',
        'ayaklar',
        'hayal',
      ],
      nightmareThemes: ['Boğulma', 'bulanıklık', 'aldatılma', 'bağımlılık'],
      lucidTendency: 'Çok yüksek - doğal rüya yeteneği',
      dreamAdvice: 'Rüyaların en güçlü süper gücün. Sezgisel mesajlara aç ol.',
      dreamSymbols: ['Okyanus', 'turkuaz', 'lotus', 'su'],
    ),
  };
}

/// Rüya tema kategorisi modeli
class DreamThemeCategory {
  final String category;
  final String symbol;
  final String emoji;
  final String description;
  final Map<String, String> themeDetails;
  final String notes;

  const DreamThemeCategory({
    required this.category,
    required this.symbol,
    required this.emoji,
    required this.description,
    required this.themeDetails,
    required this.notes,
  });
}

/// Uyku döngüsü rüya notu modeli
class SleepCycleDreamNote {
  final String phase;
  final String emoji;
  final String dreamQuality;
  final List<String> themes;
  final String lucidPotential;
  final String advice;
  final String journalPrompt;

  const SleepCycleDreamNote({
    required this.phase,
    required this.emoji,
    required this.dreamQuality,
    required this.themes,
    required this.lucidPotential,
    required this.advice,
    required this.journalPrompt,
  });
}

/// Kişilik arketipi rüya profili modeli
class ArchetypeDreamProfile {
  final String archetype;
  final String emoji;
  final List<String> commonThemes;
  final List<String> nightmareThemes;
  final String lucidTendency;
  final String dreamAdvice;
  final List<String> dreamSymbols;

  const ArchetypeDreamProfile({
    required this.archetype,
    required this.emoji,
    required this.commonThemes,
    required this.nightmareThemes,
    required this.lucidTendency,
    required this.dreamAdvice,
    required this.dreamSymbols,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// RÜYA RİTÜELLERİ
// ════════════════════════════════════════════════════════════════════════════

/// Rüya ritüelleri ve pratikleri
class RuyaRituelleri {
  /// Uyku öncesi ritüeller
  static const List<DreamRitual> uykuOncesi = [
    DreamRitual(
      name: 'Niyet Koyma Ritüeli',
      duration: '5 dakika',
      description: 'Uyumadan önce rüya niyeti belirle',
      steps: [
        'Yatağa uzan, gözlerini kapat',
        'Üç derin nefes al',
        '"Bu gece rüyamda [niyet] hakkında mesaj alacağım" de',
        'Niyetini görselleştir',
        'Minnettarlıkla bırak',
      ],
      bestFor: 'Spesifik sorulara cevap arayanlar',
      timingTip: 'Düzenli uygulandığında en etkili',
    ),
    DreamRitual(
      name: 'Lavanta Arınma Ritüeli',
      duration: '10 dakika',
      description: 'Lavanta ile zihinsel arınma ve sakinleşme',
      steps: [
        'Lavanta yağı veya kuru lavanta hazırla',
        'Yastığına birkaç damla veya torba koy',
        'Derin nefeslerle kokuyu içine çek',
        '"Zihnimim temizleniyor, rüyalarım berraklaşıyor" niyeti',
        'Sakin düşüncelerle uykuya dal',
      ],
      bestFor: 'Kabuslar ve stresli rüyalar',
      timingTip: 'Stresli günlerin ardından en etkili',
    ),
    DreamRitual(
      name: 'Rüya Kristali Aktivasyonu',
      duration: '5 dakika',
      description: 'Ametist veya ay taşı ile rüya enerjisi',
      steps: [
        'Kristali eline al',
        'Temizlemek için su veya tütsü kullan',
        '"Bu kristal rüyalarıma ışık tutsun" niyeti koy',
        'Yastığının altına veya yanına koy',
        'Sabah kristale teşekkür et',
      ],
      bestFor: 'Lucid rüya çalışanlar, derin rüya arayanlar',
      timingTip: 'Her akşam uygulanabilir',
    ),
    DreamRitual(
      name: 'Günlük Tarama Ritüeli',
      duration: '10 dakika',
      description: 'Günün gözden geçirilmesi ile bilinçaltı hazırlığı',
      steps: [
        'Günü tersine sararak hatırla (akşamdan sabaha)',
        'Duygusal anları not et',
        'Çözülmemiş konuları fark et',
        '"Bu geceye teslim ediyorum" de',
        'Bırak ve uyu',
      ],
      bestFor: 'Gün içi stres taşıyanlar',
      timingTip: 'Her gün yapılabilir',
    ),
  ];

  /// Sabah ritüelleri
  static const List<DreamRitual> sabah = [
    DreamRitual(
      name: 'Anında Kayıt Ritüeli',
      duration: '5-10 dakika',
      description: 'Uyandığı anda rüyayı kaydet',
      steps: [
        'Gözlerini açma, hareket etme - bu rüya hafızasını bozar',
        'Rüyayı zihninde gözden geçir',
        'Anahtar kelimeleri not et',
        'Duyguları, renkleri, sembolleri yaz',
        'Detayları sonra tamamla',
      ],
      bestFor: 'Herkes - temel pratik',
      timingTip: 'Her sabah uygulanmalı',
    ),
    DreamRitual(
      name: 'Rüya Çizimi Ritüeli',
      duration: '10-15 dakika',
      description: 'Rüyayı görsel olarak kaydet',
      steps: [
        'Rüyadan bir sahne seç',
        'Yetenek önemli değil - sembolik çiz',
        'Renkleri kullan',
        'Duyguları temsil eden şekiller ekle',
        'Çizimin altına kısa not yaz',
      ],
      bestFor: 'Görsel öğrenenler, sanatçılar',
      timingTip: 'Yaratıcı hissettiğin günlerde özellikle etkili',
    ),
    DreamRitual(
      name: 'Rüya Diyalogu Ritüeli',
      duration: '15-20 dakika',
      description: 'Rüya karakterleriyle yazılı diyalog',
      steps: [
        'Rüyadan bir figür veya sembol seç',
        'İki sandalye düşün: sen ve o',
        'Soru sor, cevabını yaz (akışa bırak)',
        'Diyaloğu sürdür',
        'Teşekkür et ve kapat',
      ],
      bestFor: 'Derin anlam arayanlar, Jungian çalışanlar',
      timingTip: 'Dinlendiğin ve sakin olduğun günlerde en derin diyaloglar',
    ),
  ];

  /// Haftalık ritüeller
  static const List<DreamRitual> haftalik = [
    DreamRitual(
      name: 'Haftalık Rüya İncelemesi',
      duration: '30 dakika',
      description: 'Haftanın rüyalarını gözden geçir, kalıpları bul',
      steps: [
        'Haftanın tüm rüyalarını oku',
        'Tekrarlayan sembolleri listele',
        'Duygusal kalıpları fark et',
        'Hayattaki olaylarla bağlantı kur',
        'Önümüzdeki hafta için niyet belirle',
      ],
      bestFor: 'Ciddi rüya çalışanlar',
      timingTip: 'Pazar günleri yeni haftaya hazırlık olarak',
    ),
    DreamRitual(
      name: 'Lucid Niyet Güncelleme',
      duration: '15 dakika',
      description: 'Lucid rüya niyetlerini gözden geçir',
      steps: [
        'Geçen haftaki lucid deneyimleri değerlendir',
        'Tekniklerden hangisi işe yaradı?',
        'Yeni hafta için spesifik hedef koy',
        'Affirmasyonları güncelle',
        'Reality check rutinini tazele',
      ],
      bestFor: 'Lucid rüya pratisyenleri',
      timingTip: 'Her hafta başında yeni lucid hedefler',
    ),
  ];

  /// Haftalık ritüel döngüsü önerileri
  static const Map<String, List<String>> haftalikDonguRituelleri = {
    'pazartesi': [
      'Yeni hafta için rüya niyeti belirle',
      'Rüya günlüğüne başla veya yenile',
      'Dinlenmeye izin ver',
    ],
    'salı': [
      'Yeni semboller için araştırma yap',
      'Büyüme niyetini rüyalara sor',
      'Cesaretli rüya hedefleri koy',
    ],
    'çarşamba': [
      'Rüyalardaki çatışmaları incele',
      'Karar gerektiren konuları rüyaya sor',
      'Eylem çağrısı rüyalarına dikkat et',
    ],
    'perşembe': [
      'Yoğun rüya kaydı yap - birden fazla rüya olabilir',
      'Lucid rüya denemesi için uygun gece',
      'Açığa çıkan bilgiyi değerlendir',
    ],
    'cuma': [
      'Bırakma ritüeli yap - rüyalardaki "eski" şeyleri not et',
      'Affetme çalışması - rüyalardaki figürleri affet',
      'Temizlik ve arınma niyeti',
    ],
  };
}

/// Rüya ritüeli modeli
class DreamRitual {
  final String name;
  final String duration;
  final String description;
  final List<String> steps;
  final String bestFor;
  final String timingTip;

  const DreamRitual({
    required this.name,
    required this.duration,
    required this.description,
    required this.steps,
    required this.bestFor,
    required this.timingTip,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// RÜYA SÖZLÜĞÜ - HIZLI REFERANS
// ════════════════════════════════════════════════════════════════════════════

/// Hızlı sembol referansı
class HizliSembolSozlugu {
  static const Map<String, String> semboller = {
    // A
    'ağaç': 'Yaşam, büyüme, kökler, aile soy ağacı',
    'ağlamak': 'Duygusal boşalma, arınma, kayıp',
    'anahtar': 'Çözüm, erişim, gizli bilgi, fırsat',
    'anne': 'Beslenme, şefkat, köken, iç anne arketipi',
    'araba': 'Hayat yolculuğu, kontrol, ego',
    'aslan': 'Güç, cesaret, liderlik, gurur',
    'at': 'Özgürlük, güç, içgüdü, cinsellik',
    'ateş': 'Dönüşüm, tutku, öfke, enerji',
    'ay': 'Bilinçdışı, sezgi, feminen, döngü',

    // B
    'baba': 'Otorite, koruma, dış dünya, iç baba',
    'bahçe': 'İç dünya, bakım, büyüme, cennet',
    'balık': 'Bilinçaltı, bereket, içsel farkındalık',
    'bebek': 'Yeni başlangıç, masumiyet, iç çocuk, proje',
    'bisiklet': 'Denge, öz-güç, özgürlük',
    'bodrum': 'Bilinçaltı derinlikleri, bastırılmış',
    'boğulmak': 'Duygusal bunaltı, kontrol kaybı',

    // C-Ç
    'canavar': 'Gölge, bastırılmış korku, bilinmeyen',
    'çatı': 'Yüksek bilinç, içsel alan',
    'çıplaklık': 'Savunmasızlık, gerçek benlik, utanç',
    'çiçek': 'Güzellik, açılma, kırılganlık, geçicilik',

    // D
    'deniz': 'Duygular, bilinçdışı, sonsuzluk',
    'deprem': 'Köklü değişim, güvensizlik, şok',
    'dişler': 'Güç, imaj, iletişim, yaşlanma',
    'dövüşmek': 'İç çatışma, sınır koruma, mücadele',
    'düğün': 'Birleşme, taahhüt, anima/animus evliliği',
    'düşmek': 'Kontrol kaybı, başarısızlık korkusu',

    // E
    'ev': 'Benlik, psişe, güvenlik, aile',
    'ex': 'Tamamlanmamış duygusal iş, geçmiş kalıplar',

    // F
    'fırtına': 'Duygusal çalkantı, arınma, değişim',

    // G
    'gökkuşağı': 'Umut, vaat, köprü, fırtına sonu',
    'gölge': 'Bastırılmış yönler, Jungian gölge',
    'göl': 'Sakin duygular, yansıma, iç huzur',
    'güneş': 'Bilinç, maskülen, yaşam gücü, ego',

    // H
    'hapishane': 'Kısıtlanma, suçluluk, özgürlük kaybı',
    'hastane': 'Şifa ihtiyacı, kırılganlık, bakım',
    'hayalet': 'Geçmiş, tamamlanmamış iş, atalar',

    // K
    'kalabalık': 'Toplum, aidiyet, kimlik kaybı',
    'kapı': 'Fırsat, geçiş, seçim, yeni başlangıç',
    'kar': 'Arınma, saflık, duygusal soğuma',
    'karga': 'Sihir, dönüşüm, ölüm habercisi',
    'kartal': 'Yüksek bakış, içsel farkındalık, özgürlük',
    'kedi': 'Bağımsızlık, sezgi, feminen gizem',
    'kelebek': 'Dönüşüm, ruh, kırılganlık, güzellik',
    'kitap': 'Bilgi, hikaye, hayat dersleri',
    'köpek': 'Sadakat, koruma, içgüdü, dostluk',
    'köprü': 'Geçiş, bağlantı, engeli aşma',
    'kovalanmak': 'Kaçınılan yönler, yüzleşme çağrısı',
    'kurt': 'Vahşi doğa, içgüdü, sürü, öğretmen',

    // L
    'labirent': 'Karmaşıklık, iç yolculuk, kaybolma',

    // M
    'maske': 'Persona, gizleme, sosyal yüz',
    'merdiven': 'İlerleme, yükseliş, bilinç seviyeleri',

    // O-Ö
    'okyanus': 'Kolektif bilinçdışı, sonsuzluk',
    'orman': 'Bilinçdışı, kaybolma, dönüşüm yeri',
    'ölüm': 'Dönüşüm, son, yeniden doğuş',
    'örümcek': 'Kader, yaratıcılık, tuzak, sabır',

    // P
    'para': 'Öz-değer, güç, güvenlik, bolluk',

    // R
    'rüzgar': 'Değişim, zihin, iletişim, görünmez güç',

    // S-Ş
    'saat': 'Zaman, ölümlülük, aciliyet',
    'saklanmak': 'Kaçınma, koruma, utanç',
    'sel': 'Duygusal taşma, kontrol kaybı, arınma',
    'şimşek': 'Ani aydınlanma, ilahi güç, şok',

    // T
    'telefon': 'İletişim, mesaj, bağlantı',
    'tren': 'Kader yolculuğu, kolektif hareket',
    'tünel': 'Geçiş, doğum kanalı, karanlıktan ışığa',

    // U-Ü
    'uçak': 'Yüksek hedefler, hızlı değişim',
    'uçmak': 'Özgürlük, aşkınlık, içsel yükseliş',

    // Y
    'yağmur': 'Arınma, gözyaşı, bereket, yenilenme',
    'yılan': 'Dönüşüm, şifa, cinsellik, tehlike/bilgelik',
    'yıldız': 'Rehberlik, kader, umut, ilham',

    // Z
    'zil': 'Uyarı, uyanış çağrısı, dikkat',
  };

  /// Sembol ara
  static String? bul(String sembol) {
    return semboller[sembol.toLowerCase()];
  }

  /// Tüm sembolleri alfabetik getir
  static List<MapEntry<String, String>> get alfabetik {
    final entries = semboller.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }
}
