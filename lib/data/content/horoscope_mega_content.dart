/// Archetype Reflection Content - Reflection themes based on archetypes and symbols
/// Comprehensive reflection templates for personal growth and self-awareness
/// Content is designed for reflection purposes only, not prediction.
library;

/// Content disclaimer for all content in this file
const String megaContentDisclaimer =
    'This content is for reflection and self-awareness only. It does not predict events or outcomes.';

// ════════════════════════════════════════════════════════════════════════════
// GÜNLÜK REFLEKSIYON TEMA ŞABLONLARI
// ════════════════════════════════════════════════════════════════════════════

class DailyHoroscopeTemplates {
  /// Ay fazlarına göre refleksiyon tema şablonları (kültürel sembolizm)
  static const Map<String, MoonPhaseTheme> moonPhaseThemes = {
    'new_moon': MoonPhaseTheme(
      phase: 'Yeni Ay',
      generalTheme:
          'Birçok kültürde yeni başlangıçlarla ilişkilendirilen bir dönem',
      energyLevel: 'İçsel, yansıtıcı',
      bestFor: [
        'Niyet belirleme üzerine düşünme',
        'Yeni projeler planlama',
        'İç görü çalışması',
      ],
      avoid: [
        'Bu dönemde bazı insanlar büyük kararları ertelemeyi tercih eder',
      ],
      affirmation:
          'Niyetlerimi netleştirmek için bir fırsat olarak düşünebilirim.',
    ),
    'waxing_crescent': MoonPhaseTheme(
      phase: 'Hilal (Büyüyen)',
      generalTheme:
          'Geleneksel olarak momentum ve hareket ile ilişkilendirilen dönem',
      energyLevel: 'Artan, motive',
      bestFor: [
        'Planları gözden geçirme',
        'İlk adımlar üzerine düşünme',
        'Engeller üzerine refleksiyon',
      ],
      avoid: ['Erteleme kalıplarını fark etme fırsatı'],
      affirmation: 'Her adım bir öğrenme fırsatı olarak düşünülebilir.',
    ),
    'first_quarter': MoonPhaseTheme(
      phase: 'İlk Dördün',
      generalTheme: 'Zorluklar ve kararlılık üzerine düşünme daveti',
      energyLevel: 'Gerilimli, zorlayıcı',
      bestFor: [
        'Zorluklar üzerine refleksiyon',
        'Kararlılık teması',
        'Strateji değerlendirmesi',
      ],
      avoid: ['Sabırsızlık kalıplarını fark etme'],
      affirmation: 'Zorluklarla yüzleşmek üzerine düşünmek isteyebilirim.',
    ),
    'waxing_gibbous': MoonPhaseTheme(
      phase: 'Şişkin Ay (Büyüyen)',
      generalTheme: 'İyileştirme ve detaylar üzerine düşünme daveti',
      energyLevel: 'Yoğun, detay odaklı',
      bestFor: [
        'İnce ayarlar üzerine düşünme',
        'Analiz ve değerlendirme',
        'Hazırlık refleksiyonu',
      ],
      avoid: ['Mükemmeliyetçilik kalıplarını fark etme'],
      affirmation:
          'Detaylar ve büyük resim arasındaki denge üzerine düşünebilirim.',
    ),
    'full_moon': MoonPhaseTheme(
      phase: 'Dolunay',
      generalTheme:
          'Birçok gelenekte tamamlanma ve şükran ile ilişkilendirilen dönem',
      energyLevel: 'Maksimum, yoğun',
      bestFor: [
        'Şükran pratiği',
        'Farkındalık',
        'İlişkiler üzerine refleksiyon',
        'Bırakma temaları',
      ],
      avoid: ['Aşırı tepki kalıplarını fark etme'],
      affirmation:
          'Başarılarımı ve öğrendiklerimi takdir etmek için bir fırsat.',
    ),
    'waning_gibbous': MoonPhaseTheme(
      phase: 'Şişkin Ay (Küçülen)',
      generalTheme: 'Paylaşma ve şükran temaları üzerine düşünme daveti',
      energyLevel: 'Azalan, içsel dönen',
      bestFor: [
        'Öğrenilenleri paylaşma üzerine düşünme',
        'Şükran pratiği',
        'Başkalarına yardım teması',
      ],
      avoid: ['Ego kalıplarını fark etme'],
      affirmation: 'Öğrendiklerimi paylaşmak üzerine düşünmek isteyebilirim.',
    ),
    'last_quarter': MoonPhaseTheme(
      phase: 'Son Dördün',
      generalTheme: 'Bırakma ve temizlik temaları üzerine düşünme daveti',
      energyLevel: 'Gerilimli, dönüştürücü',
      bestFor: [
        'Eski kalıplar üzerine refleksiyon',
        'Temizlik teması',
        'Bağışlama üzerine düşünme',
      ],
      avoid: ['Geçmişe takılma kalıplarını fark etme'],
      affirmation: 'Bırakma ve yenilenme temaları üzerine düşünebilirim.',
    ),
    'waning_crescent': MoonPhaseTheme(
      phase: 'Hilal (Küçülen)',
      generalTheme:
          'Dinlenme ve içsel hazırlık temaları üzerine düşünme daveti',
      energyLevel: 'Minimum, içsel',
      bestFor: ['Meditasyon', 'Rüyalara dikkat', 'Sessizlik', 'Kendine bakım'],
      avoid: ['Aşırı yorgunluk kalıplarını fark etme'],
      affirmation: 'Dinlenmenin değeri üzerine düşünmek isteyebilirim.',
    ),
  };

  /// Haftanın günlerine göre gezegen enerjileri
  static const Map<String, DayPlanetaryEnergy> dailyPlanetaryEnergies = {
    'monday': DayPlanetaryEnergy(
      day: 'Pazartesi',
      rulingPlanet: 'Ay',
      planetSymbol: '☽',
      theme: 'Duygular, sezgi, ev ve aile',
      bestActivities: [
        'Ev işleri',
        'Aile zamanı',
        'Bakım ve beslenme',
        'Duygusal iyileşme',
      ],
      color: 'Beyaz, gümüş',
      crystal: 'Aytaşı, İnci',
      affirmation: 'Duygularımı onurlandırıyorum.',
    ),
    'tuesday': DayPlanetaryEnergy(
      day: 'Salı',
      rulingPlanet: 'Mars',
      planetSymbol: '♂',
      theme: 'Eylem, enerji, cesaret ve rekabet',
      bestActivities: [
        'Spor',
        'Yeni girişimler',
        'Fiziksel aktivite',
        'Liderlik',
      ],
      color: 'Kırmızı, turuncu',
      crystal: 'Kırmızı Jasper, Karneol',
      affirmation: 'Cesaretim ve enerjim beni ileriye taşıyor.',
    ),
    'wednesday': DayPlanetaryEnergy(
      day: 'Çarşamba',
      rulingPlanet: 'Merkür',
      planetSymbol: '☿',
      theme: 'İletişim, öğrenme, yazma ve seyahat',
      bestActivities: [
        'Yazışmalar',
        'Öğrenme',
        'Toplantılar',
        'Kısa yolculuklar',
      ],
      color: 'Sarı, turuncu',
      crystal: 'Sitrin, Kaplan Gözü',
      affirmation: 'Fikirlerimi açıkça ifade ediyorum.',
    ),
    'thursday': DayPlanetaryEnergy(
      day: 'Perşembe',
      rulingPlanet: 'Jüpiter',
      planetSymbol: '♃',
      theme: 'Genişleme, şans, yüksek öğrenim ve felsefe',
      bestActivities: [
        'Yasal işler',
        'Yayıncılık',
        'Eğitim',
        'Uzun yolculuklar',
      ],
      color: 'Mavi, mor',
      crystal: 'Ametist, Lapis Lazuli',
      affirmation: 'Evren benim için bolluğu açıyor.',
    ),
    'friday': DayPlanetaryEnergy(
      day: 'Cuma',
      rulingPlanet: 'Venüs',
      planetSymbol: '♀',
      theme: 'Aşk, güzellik, sanat ve para',
      bestActivities: ['Randevular', 'Sanat', 'Alışveriş', 'Güzellik bakımı'],
      color: 'Pembe, yeşil',
      crystal: 'Gül Kuvars, Yeşim',
      affirmation: 'Sevgi ve güzellik hayatıma akıyor.',
    ),
    'saturday': DayPlanetaryEnergy(
      day: 'Cumartesi',
      rulingPlanet: 'Satürn',
      planetSymbol: '♄',
      theme: 'Yapı, disiplin, sorumluluk ve kariyer',
      bestActivities: [
        'Planlama',
        'Organizasyon',
        'Kariyer işleri',
        'Yaşlılara saygı',
      ],
      color: 'Siyah, koyu mavi',
      crystal: 'Obsidyen, Oniks',
      affirmation: 'Disiplin ve sabırla hedeflerime ulaşıyorum.',
    ),
    'sunday': DayPlanetaryEnergy(
      day: 'Pazar',
      rulingPlanet: 'Güneş',
      planetSymbol: '☉',
      theme: 'Benlik, yaratıcılık, neşe ve liderlik',
      bestActivities: [
        'Kendine zaman',
        'Yaratıcı projeler',
        'Dinlenme',
        'Kutlama',
      ],
      color: 'Altın, sarı',
      crystal: 'Kaplan Gözü, Sitrin',
      affirmation: 'Işığımı dünyayla paylaşıyorum.',
    ),
  };

  /// Her arketip için günlük refleksiyon alanları
  static const Map<String, DailyHoroscopeAreas> horoscopeAreas = {
    'love': DailyHoroscopeAreas(
      area: 'İlişkiler',
      icon: '💕',
      questions: [
        'İlişkilerimde hangi kalıpları fark ediyorum?',
        'Bağlantı ve yalnızlık üzerine ne düşünüyorum?',
        'Duygusal farkındalığım nasıl?',
      ],
    ),
    'career': DailyHoroscopeAreas(
      area: 'Profesyonel',
      icon: '💼',
      questions: [
        'İş hayatımla ilgili hangi temalar üzerine düşünebilirim?',
        'Profesyonel değerlerim neler?',
        'Mesleki gelişim üzerine refleksiyon',
      ],
    ),
    'health': DailyHoroscopeAreas(
      area: 'Wellness',
      icon: '🏃',
      questions: [
        'Enerji seviyemi nasıl değerlendiriyorum?',
        'Öz-bakım kalıplarım hakkında ne fark ediyorum?',
        'Stres ve dinlenme dengem nasıl?',
      ],
    ),
    'money': DailyHoroscopeAreas(
      area: 'Değerler',
      icon: '💰',
      questions: [
        'Finansal değerlerim ve alışkanlıklarım üzerine ne düşünüyorum?',
        'Bolluk ve kıtlık zihniyeti üzerine refleksiyon',
        'Harcama kalıplarım hakkında ne fark ediyorum?',
      ],
    ),
    'mood': DailyHoroscopeAreas(
      area: 'Duygusal Farkındalık',
      icon: '🎭',
      questions: [
        'Duygusal durumum hakkında ne fark ediyorum?',
        'Motivasyon kaynakları üzerine düşünme',
        'İç huzur için neler yapabilirim?',
      ],
    ),
  };
}

// ════════════════════════════════════════════════════════════════════════════
// BURÇ BAZLI GÜNLÜK İÇERİK ŞABLONLARI
// ════════════════════════════════════════════════════════════════════════════

class ZodiacDailyContent {
  /// Koç günlük içerik şablonları
  static const AriesDailyTemplates aries = AriesDailyTemplates();

  /// Boğa günlük içerik şablonları
  static const TaurusDailyTemplates taurus = TaurusDailyTemplates();

  // ... diğer burçlar
}

class AriesDailyTemplates {
  const AriesDailyTemplates();

  /// Ateş arketipi yüksek enerji refleksiyon temaları
  static const List<String> highEnergyDays = [
    '''
## Mars Arketipi: Eylem ve İnisiyatif Refleksiyonu

Mars arketipi, mitolojide ve modern psikolojide eylem, girişkenlik ve
isteklerimizi takip etme kapasitemizi simgeler. Koç arketipi ile
ilişkilendirilen bu enerji, cesaret ve kişisel itici güç temalarını keşfetmeye davet eder.

🔥 REFLEKSIYON TEMASI: Ateşli ve dinamik
Hayatında inisiyatif almak istediğin alanlar neler?
Sağlıklı girişkenlik senin için şu an nasıl görünüyor?

💡 DÜŞÜNME DAVETI:
Rekabet ve iş birliği arasındaki denge üzerine düşünmek isteyebilirsin.
Enerjini yapıcı yollarla kanalize etme fırsatları hakkında ne düşünüyorsun?

⚡ FARKINDLIK ALANI:
Aceleci kararlar ve bilinçli eylem arasındaki fark üzerine düşünebilirsin.
Sabır ve harekete geçme arasındaki dengeyi nasıl buluyorsun?

*Bu içerik refleksiyon amaçlıdır. Olayları tahmin etmez.*
''',
    '''
## Öncü Arketipi: Cesaret ve Liderlik Refleksiyonu

Koç arketipi, öncü enerjisini temsil eder. Bu, savaşmak değil,
yol göstermek ve aydınlatmak anlamına da gelebilir.

🎯 REFLEKSIYON ALANI: Başarı ve hedefler
"Başarı" senin için ne anlama geliyor? Bu kavram üzerine düşünmek isteyebilirsin.
Büyük hedefler ve detaylar arasındaki denge hakkında ne düşünüyorsun?

🚀 DÜŞÜNME DAVETI:
Ertelediğin girişimler veya projeler var mı? Bu konu üzerine düşünebilirsin.
Cesaret ve tedbirlilik arasındaki denge hakkında refleksiyon yapabilirsin.

⚠️ FARKINDLIK:
Ego ve özgüven arasındaki fark üzerine düşünmek faydalı olabilir.
Haklı olmak ile ilişki sağlığı arasındaki denge hakkında ne düşünüyorsun?

*Bu içerik refleksiyon amaçlıdır. Olayları tahmin etmez.*
''',
  ];

  /// Düşük enerji dönemleri için refleksiyon temaları
  static const List<String> lowEnergyDays = [
    '''
## Dinlenme ve Strateji: İçsel Dönem Refleksiyonu

Enerji seviyesi düşük hissedilen dönemler, içe dönmek ve
strateji geliştirmek için bir davet olarak düşünülebilir.

🌙 REFLEKSIYON TEMASI: Yavaşlama ve dinleme
Her gün aksiyon odaklı olmak zorunda değil. Stratejik geri çekilme
kavramı üzerine düşünmek isteyebilirsin.

🧘 İÇ DÜNYA:
İçe dönük zaman geçirmenin değeri üzerine düşünebilirsin.
Meditasyon veya sessiz yürüyüş hakkında ne düşünüyorsun?

📝 DÜŞÜNME DAVETI:
Sabır bir güç gösterisi olarak düşünülebilir.
Enerji biriktirme ve hareket arasındaki denge hakkında refleksiyon yapabilirsin.

*Bu içerik refleksiyon amaçlıdır. Olayları tahmin etmez.*
''',
  ];

  /// İlişki refleksiyon temaları
  static const Map<String, List<String>> loveTemplates = {
    'single': [
      '''
## Bağlantı Refleksiyonu: İlişki Temaları

İlişkiler ve bağlantı, birçok insanın düzenli olarak düşünmeyi
anlamlı bulduğu alanlardır. Romantik karşılaşmalar tahmin etmek
yerine, bağlantının kendisi ile ilişkinizi düşünmeye davet eder.

🤔 KENDİ KENDİNE SORULAR:
• Anlamlı bağlantılarda hangi özelliklere değer veriyorsun?
• Yeni ilişkilere veya arkadaşlıklara genellikle nasıl yaklaşıyorsun?
• Sosyal ortamlarda otantik kendini ifade etmek senin için nasıl görünüyor?

💘 GÜNLÜK SORUSU:
"Günün etkileşimlerine başkalarına karşı gerçek merakla yaklaşsaydım ne değişirdi?"

*Bu içerik ilişki temaları üzerine refleksiyon için tasarlanmıştır.
Romantik sonuçları tahmin etmez.*
''',
    ],
    'relationship': [
      '''
## İlişki Dinamikleri: Refleksiyon Temaları

Mevcut ilişkilerdeki dinamikler üzerine düşünmek,
öz-farkındalık ve büyüme için değerli olabilir.

💑 REFLEKSIYON ALANLARI:
• Partnerinle iletişim kalıpların nasıl?
• Birlikte aktivite yapmanın ilişkinize katkısı hakkında ne düşünüyorsun?
• Tartışmalar sırasında tutumun hakkında farkındalık geliştirmek isteyebilirsin.

⚡ DÜŞÜNME DAVETI:
Küçük şeyleri büyütme eğilimi üzerine düşünmek faydalı olabilir.
Haklı olmak ile ilişki sağlığı arasındaki denge hakkında ne düşünüyorsun?

*Bu içerik ilişki refleksiyonu için tasarlanmıştır. Tavsiye niteliği taşımaz.*
''',
    ],
  };

  /// Profesyonel refleksiyon temaları
  static const Map<String, List<String>> careerTemplates = {
    'positive': [
      '''
## Liderlik ve İnisiyatif: Profesyonel Refleksiyon Temaları

Öncü arketipi, profesyonel yaşamımıza nasıl yaklaştığımız
üzerine refleksiyon yapmaya davet eder. Bu, kariyer sonuçlarını
tahmin etmek değil, iş ve hırs ile ilişkinizi düşünmektir.

🤔 DÜŞÜNME ALANLARI:
• Düşündüğün ama hayata geçirmekte tereddüt ettiğin girişimler var mı?
• Profesyonel ortamlarda konuşmak ile dinlemek arasındaki dengeyi nasıl kuruyorsun?
• Mevcut rolündeki anlamlı katkı nasıl görünüyor?

💼 GÜNLÜK SORUSU:
"Profesyonel içgüdülerime tam güvenseydim neyi farklı yapardım?"

*Bu içerik profesyonel öz-refleksiyon için temalar sunar.
Kariyer kararları kendi yargınıza ve gerektiğinde profesyonel tavsiyeye dayalı olmalıdır.*
''',
    ],
    'challenging': [
      '''
## Profesyonel Zorluklar: Refleksiyon Temaları

Zorlayıcı dönemler, kalıplarımızı fark etmek ve büyümek için
fırsatlar olarak düşünülebilir.

🤔 REFLEKSIYON ALANLARI:
• Otoriteyle ilişkin hakkında ne fark ediyorsun?
• "Ne" söylediğin ile "nasıl" söylediğin arasındaki fark üzerine düşünebilirsin.
• Hangi mücadelelerin gerçekten önemli olduğunu nasıl belirliyorsun?

🛠️ DÜŞÜNME DAVETI:
Stratejik düşünme ve reaktif davranış arasındaki fark
üzerine düşünmek isteyebilirsin. Büyük resmi görmek hakkında ne düşünüyorsun?

*Bu içerik profesyonel refleksiyon için tasarlanmıştır. Tavsiye niteliği taşımaz.*
''',
    ],
  };
}

class TaurusDailyTemplates {
  const TaurusDailyTemplates();

  static const List<String> highEnergyDays = [
    '''
## Venüs Arketipi: Güzellik ve Değer Refleksiyonu

Venüs arketipi, sevgi, güzellik ve değerler temalarını simgeler.
Boğa arketipi ile ilişkilendirilen bu enerji, duyusal deneyimler
ve öz-değer üzerine düşünmeye davet eder.

🌸 REFLEKSIYON TEMASI: Zenginlik ve huzur
Her anın tadını çıkarmak üzerine düşünmek isteyebilirsin.
Beş duyun ve farkındalık arasındaki ilişki hakkında ne düşünüyorsun?

💎 DEĞER REFLEKSIYONU:
Hem maddi hem manevi değerler üzerine düşünebilirsin.
Senin için gerçekten önemli olan nedir?

🌿 DÜŞÜNME DAVETI:
Doğayla bağlantı kurmanın değeri üzerine düşünmek isteyebilirsin.
Topraklama pratiği hakkında ne düşünüyorsun?

*Bu içerik refleksiyon amaçlıdır. Olayları tahmin etmez.*
''',
  ];

  static const Map<String, List<String>> loveTemplates = {
    'single': [
      '''
## Bağlantı ve Değer: İlişki Refleksiyonu

İlişkilere sabırlı ve değer odaklı bir yaklaşım üzerine düşünmek
anlamlı olabilir. Bu, romantik sonuçları tahmin etmek değil,
bağlantı tarzın hakkında farkındalık geliştirmektir.

🤔 KENDİ KENDİNE SORULAR:
• Sakin ve güvenilir enerji senin için ne anlama geliyor?
• Kalıcı bağlantılar için sabırlı yaklaşım hakkında ne düşünüyorsun?
• Estetik değerlerini paylaşan biriyle bağlantı kurma fikri nasıl hissettiriyor?

💕 GÜNLÜK SORUSU:
"İlişkilerde neye değer veriyorum ve bunu nasıl ifade ediyorum?"

*Bu içerik ilişki temaları üzerine refleksiyon için tasarlanmıştır.*
''',
    ],
    'relationship': [
      '''
## İlişkide Besleyici Enerji: Refleksiyon Temaları

Mevcut ilişkilerde besleyicilik ve fiziksel yakınlık temaları
üzerine düşünmek değerli olabilir.

💑 REFLEKSIYON ALANLARI:
• Partnerine sevgi gösterme şeklin hakkında ne fark ediyorsun?
• Sessiz birlikteliğin değeri üzerine düşünmek isteyebilirsin.
• Küçük jestlerin önemi hakkında ne düşünüyorsun?

🌹 DÜŞÜNME DAVETI:
Fiziksel yakınlık ve duygusal bağlantı arasındaki ilişki
üzerine düşünebilirsin. Hediye vermek ve almak senin için ne anlama geliyor?

*Bu içerik ilişki refleksiyonu için tasarlanmıştır. Tavsiye niteliği taşımaz.*
''',
    ],
  };
}

// ════════════════════════════════════════════════════════════════════════════
// HAFTALIK REFLEKSIYON TEMALARI
// ════════════════════════════════════════════════════════════════════════════

class WeeklyHoroscopeContent {
  static const String introduction = '''
Haftalık refleksiyon temaları, haftanın genel temasını ve her gün için
düşünme davetlerini içerir. Bu içerik tahmin değil, kişisel
farkındalık ve refleksiyon için tasarlanmıştır.
''';

  /// Haftalık refleksiyon yapı şablonu
  static const WeeklyStructure structure = WeeklyStructure(
    sections: [
      'Haftanın Refleksiyon Teması',
      'Sembolik Gezegensel Temalar',
      'İlişki Refleksiyonu',
      'Profesyonel Refleksiyon',
      'Wellness ve Enerji Farkındalığı',
      'Kültürel Sembolik Bilgi',
      'Haftanın Günlük Sorusu',
    ],
    dailyHighlights: true,
    luckyNumbers: false, // Kaldırıldı - tahmin içerir
    luckyColors: true, // Kültürel bilgi olarak korundu
  );

  /// Haftalık tema şablonları (kültürel sembolizm olarak çerçevelenmiş)
  static const Map<String, WeeklyTheme> weeklyThemes = {
    'mercury_retrograde': WeeklyTheme(
      theme: 'Merkür Retrosu: Kültürel Bir Yavaşlama Sembolü',
      generalAdvice: '''
Merkür retrosu, astrolojik gelenekte yaygın olarak tanınan bir dönemdir,
ancak etkileri bilimsel gerçeklik değil, kişisel inanç meselesidir.
Kültürel olarak, birçok kişi bu dönemi iletişim kalıpları üzerine
yavaşlama ve düşünme için sembolik bir hatırlatıcı olarak kullanır.

REFLEKSIYON TEMALARI (Tahmin Değil):
• Önemli belgeler ve iletişimleri ekstra dikkatle gözden geçirmek üzerine düşünebilirsin
• Geçmiş ilişkiler ve sana ne öğrettikleri üzerine refleksiyon yapabilirsin
• Teknolojinin hedeflerine nasıl hizmet ettiği (veya dikkatini dağıttığı) üzerine düşünmek isteyebilirsin

TARİHSEL & KÜLTÜREL BAĞLAM:
Merkür retrosu kavramı, Dünya'dan gözlemlendiğinde Merkür'ün görünürdeki
geriye doğru hareketinden gelir. Tarih boyunca, Merkür (veya Hermes)
çeşitli kültürlerde iletişim, ticaret ve seyahati simgelemiştir.

GÜNLÜK SORUSU:
"Hangi bitmemiş konuşmalar veya projeler dikkatimden faydalanabilir?"

*Bu içerik kültürel/sembolik bir geleneği tanımlar. Olayları veya sonuçları tahmin etmez.*
''',
      doList: [
        'İletişim üzerine refleksiyon',
        'Geçmiş dersleri gözden geçirme',
        'Bilinçli iletişim',
      ],
      dontList: [], // Kaldırıldı - tahmin içeriyordu
    ),
    'venus_retrograde': WeeklyTheme(
      theme: 'Venüs Retrosu: İlişki ve Değer Refleksiyonu',
      generalAdvice: '''
Venüs retrosu, astrolojik gelenekte aşk ve değerler üzerine
refleksiyon dönemi olarak yorumlanır. Bilimsel olarak kanıtlanmış
etkileri olmamasına rağmen, birçok kişi bu dönemi ilişkiler ve
değerler üzerine düşünmek için bir hatırlatıcı olarak kullanır.

İLİŞKİ REFLEKSIYON TEMALARI:
• Geçmiş ilişkilerden öğrendiğin dersler üzerine düşünebilirsin
• Mevcut ilişkilerindeki kalıplar hakkında farkındalık geliştirmek isteyebilirsin
• Gerçekten ne istediğin üzerine refleksiyon yapabilirsin

DEĞER REFLEKSIYONU:
• Neye değer verdiğin üzerine düşünmek isteyebilirsin
• Harcama kalıpların ve değerlerin arasındaki uyum hakkında ne düşünüyorsun?
• İmpulsif kararlar ve bilinçli seçimler arasındaki fark üzerine refleksiyon

*Bu içerik ilişki ve değer refleksiyonu için tasarlanmıştır. Olayları tahmin etmez.*
''',
      doList: ['İlişki refleksiyonu', 'Öz-değer keşfi', 'Güzellik takdiri'],
      dontList: [], // Kaldırıldı - tahmin içeriyordu
    ),
    'mars_retrograde': WeeklyTheme(
      theme: 'Mars Retrosu: Enerji ve Eylem Refleksiyonu',
      generalAdvice: '''
Mars retrosu, geleneksel olarak eylem enerjisinin içe döndüğü
bir dönem olarak yorumlanır. Bu dönem, motivasyon ve enerji
yönetimi üzerine düşünmek için bir davet olarak kullanılabilir.

ENERJİ REFLEKSIYON TEMALARI:
• Enerji seviyelerinle ilişkin hakkında düşünmek isteyebilirsin
• Öfke ve frustrasyon kalıpların üzerine farkındalık geliştirebilirsin
• Dinlenme ve aktivite arasındaki denge hakkında ne düşünüyorsun?

DÜŞÜNME DAVETLERİ:
• Sabır kavramı senin için ne anlama geliyor?
• Strateji geliştirme vs. ani tepki verme üzerine refleksiyon
• Enerji biriktirme ve harcama arasındaki denge

*Bu içerik enerji ve eylem refleksiyonu için tasarlanmıştır. Olayları tahmin etmez.*
''',
      doList: [
        'Strateji refleksiyonu',
        'Dinlenme ve yenilenme',
        'İçsel motivasyon keşfi',
      ],
      dontList: [], // Kaldırıldı - tahmin içeriyordu
    ),
  };
}

// ════════════════════════════════════════════════════════════════════════════
// AYLIK BURÇ YORUMLARI
// ════════════════════════════════════════════════════════════════════════════

class MonthlyHoroscopeContent {
  /// Ayların astrolojik temaları
  static const Map<int, MonthlyTheme> monthlyThemes = {
    1: MonthlyTheme(
      month: 'Ocak',
      sign: 'Oğlak',
      generalTheme: 'Yeni Yıl Niyetleri ve Yapılandırma',
      keyPhrases: ['Hedef belirleme', 'Disiplin', 'Yeni başlangıçlar'],
      collectiveEnergy: '''
Oğlak sezonu devam ediyor. Kariyer, hırs ve sorumluluk vurgulanıyor.
Yeni yıl kararlarını somut planlara dönüştürme zamanı.

Ocak ayı Satürn enerjisi taşır - yapı, disiplin ve uzun vadeli hedefler.
Hayallerini gerçeğe dönüştürecek temelleri şimdi at.
''',
    ),
    2: MonthlyTheme(
      month: 'Şubat',
      sign: 'Kova',
      generalTheme: 'İnovasyon ve Topluluk',
      keyPhrases: ['Özgünlük', 'Sosyal bağlar', 'Geleceği hayal etme'],
      collectiveEnergy: '''
Kova sezonu yenilik ve bağımsızlık getiriyor. Topluluk, arkadaşlık
ve insanlığa hizmet temaları öne çıkıyor.

Sevgililer Günü bu ayda - ama Kova enerjisi geleneksel romantizm
yerine benzersiz bağlantılar arıyor.
''',
    ),
    3: MonthlyTheme(
      month: 'Mart',
      sign: 'Balık',
      generalTheme: 'Maneviyat ve Yaratıcılık',
      keyPhrases: ['Sezgi', 'Rüyalar', 'Sanat', 'Şifa'],
      collectiveEnergy: '''
Balık sezonu mistik ve ruhani enerjiler getiriyor. Meditasyon,
sanat ve rüyalara dikkat için ideal zaman.

Bahar ekinoksu bu ayda - yeniden doğuş enerjisi. Kış uykusundan
uyanış ve yeni başlangıçlar için hazırlık.
''',
    ),
    4: MonthlyTheme(
      month: 'Nisan',
      sign: 'Koç',
      generalTheme: 'Eylem ve Yeni Başlangıçlar',
      keyPhrases: ['Cesaret', 'Başlatma', 'Enerji patlaması'],
      collectiveEnergy: '''
Koç sezonu! Zodyakın yeni yılı başlıyor. Enerji, cesaret ve
girişimcilik dorukta. Harekete geç!

Mars enerjisi her yerde. Projeler başlat, riskler al, öncü ol.
Tereddüt için zaman yok - şimdi!
''',
    ),
    5: MonthlyTheme(
      month: 'Mayıs',
      sign: 'Boğa',
      generalTheme: 'Değer ve Duyusal Zevkler',
      keyPhrases: ['İstikrar', 'Güzellik', 'Toprak', 'Bolluk'],
      collectiveEnergy: '''
Boğa sezonu yavaşlama ve tadını çıkarma zamanı. Baharın tam
ortasında doğa canlanıyor - ve sen de.

Değerler, finans ve duyusal zevkler öne çıkıyor. Ne istiyorsun?
Neye değer veriyorsun? Yanıtları bul.
''',
    ),
    6: MonthlyTheme(
      month: 'Haziran',
      sign: 'İkizler',
      generalTheme: 'İletişim ve Hareket',
      keyPhrases: ['Merak', 'Öğrenme', 'Sosyalleşme', 'Çeşitlilik'],
      collectiveEnergy: '''
İkizler sezonu - zihinsel aktivite zirveye çıkıyor! İletişim,
öğrenme ve sosyal bağlantılar hızlanıyor.

Yaz gündönümü bu ayda - yılın en uzun günü. Kutla, paylaş,
bağlan. Sosyal bağlantı temaları güçlü.
''',
    ),
    7: MonthlyTheme(
      month: 'Temmuz',
      sign: 'Yengeç',
      generalTheme: 'Ev ve Duygusal Kökler',
      keyPhrases: ['Aile', 'Yuva', 'Nostalji', 'Bakım'],
      collectiveEnergy: '''
Yengeç sezonu - ev, aile ve duygusal güvenlik ön planda.
Köklerine dön, sevdiklerinle vakit geçir.

Yaz tatili sezonu başlıyor. Dinlenme, yeniden şarj olma ve
duygusal bağları güçlendirme zamanı.
''',
    ),
    8: MonthlyTheme(
      month: 'Ağustos',
      sign: 'Aslan',
      generalTheme: 'Yaratıcılık ve Özgüven',
      keyPhrases: ['Parıldama', 'Eğlence', 'Romantizm', 'Liderlik'],
      collectiveEnergy: '''
Aslan sezonu - parıldama zamanı! Yaratıcılık, özgüven ve
bireysel ifade zirveye ulaşıyor.

Güneş kendi burcunda en güçlü. Işığını dünyayla paylaş,
sahnede yerini al. Seni görmelerini sağla!
''',
    ),
    9: MonthlyTheme(
      month: 'Eylül',
      sign: 'Başak',
      generalTheme: 'Düzen ve İyileştirme',
      keyPhrases: ['Analiz', 'Sağlık', 'Hizmet', 'Detaylar'],
      collectiveEnergy: '''
Başak sezonu - düzene koyma zamanı! Yaz gevşekliğinden sonra
odaklanma, organize olma ve sağlık ön planda.

Okul başlıyor, rutinler yeniden kuruluyor. Analitik düşünce
ve pratik iyileştirmeler için ideal.
''',
    ),
    10: MonthlyTheme(
      month: 'Ekim',
      sign: 'Terazi',
      generalTheme: 'Denge ve İlişkiler',
      keyPhrases: ['Ortaklık', 'Uyum', 'Güzellik', 'Adalet'],
      collectiveEnergy: '''
Terazi sezonu - ilişkiler ve denge merkeze alınıyor. Birliktelik,
ortaklık ve sosyal uyum vurgulanıyor.

Sonbahar ekinoksu - gece ve gündüz dengede. Hayatında dengeyi
sağlayacak ayarlamalar yap.
''',
    ),
    11: MonthlyTheme(
      month: 'Kasım',
      sign: 'Akrep',
      generalTheme: 'Dönüşüm ve Derinlik',
      keyPhrases: ['Yoğunluk', 'Gizem', 'Yeniden doğuş', 'Güç'],
      collectiveEnergy: '''
Akrep sezonu - derinliklere dalış! Dönüşüm, psikolojik farkındalık
ve gizli gerçekler gün yüzüne çıkıyor.

Ölüler Günü temaları - atalara saygı, ölüm ve yeniden doğuş.
Bırakman gerekenleri bırak, dönüşümü kucakla.
''',
    ),
    12: MonthlyTheme(
      month: 'Aralık',
      sign: 'Yay',
      generalTheme: 'Genişleme ve Kutlama',
      keyPhrases: ['İyimserlik', 'Seyahat', 'Felsefe', 'Şükran'],
      collectiveEnergy: '''
Yay sezonu - genişleme ve iyimserlik! Tatil sezonu, kutlamalar
ve yılın değerlendirmesi zamanı.

Kış gündönümü - karanlıktan aydınlığa dönüş. Şükran, umut ve
yeni yıl için hazırlık.
''',
    ),
  };

  /// Her burç için aylık yorum alanları
  static const List<String> monthlySections = [
    'Ayın Genel Teması',
    'Önemli Tarihler',
    'Yeni Ay ve Dolunay Etkileri',
    'Aşk ve İlişkiler Aylığı',
    'Kariyer ve Finans Aylığı',
    'Sağlık ve Wellness',
    'Kişisel Gelişim',
    'Ayın Tavsiyesi',
    'Şanslı Günler',
  ];
}

// ════════════════════════════════════════════════════════════════════════════
// YILLIK BURÇ YORUMLARI
// ════════════════════════════════════════════════════════════════════════════

class YearlyHoroscopeContent {
  /// Yıllık yorum yapısı
  static const YearlyStructure structure = YearlyStructure(
    sections: [
      'Yılın Genel Teması',
      'Önemli Gezegen Transitları',
      'Aşk ve İlişkiler Yıllık',
      'Kariyer ve Finans Yıllık',
      'Sağlık ve Wellness',
      'Spiritüel Gelişim',
      'Yılın Dönemleri (3 aylık)',
      'Kritik Tarihler',
      'Yılın Tavsiyesi',
    ],
    quarterlyBreakdown: true,
    monthlyHighlights: true,
    luckyDays: true,
  );

  /// Dış gezegen transitlerinin uzun vadeli etkileri
  static const Map<String, LongTermTransit> majorTransits = {
    'pluto_in_aquarius': LongTermTransit(
      transit: 'Plüton Kova\'da',
      period: '2024-2044',
      generalTheme: 'Toplumsal dönüşüm ve teknoloji devrimi',
      collectiveEffect: '''
Plüton Kova'ya geçişi, nesiller boyu toplumu şekillendirecek
devasa bir dönüşüm başlatıyor.

TEMALAR:
• Teknoloji ve yapay zeka devrimi
• Toplumsal yapıların dönüşümü
• Bireysel özgürlük vs. kollektif
• Yeni güç yapıları
• Dijital dünya evrimi

BİREYSEL ETKİ:
Kova evine göre hayatında hangi alan dönüşüyor? Kendi
Plüton transitlerinin bu büyük dalganın parçası.
''',
      signEffects: {
        'aries': 'Sosyal çevren ve gelecek vizyonun dönüşüyor',
        'taurus': 'Kariyer ve kamusal imajın yeniden yapılanıyor',
        'gemini': 'Felsefe, inançlar ve yabancı bağlantılar dönüşüyor',
        'cancer': 'Derin psikolojik dönüşüm, ortak kaynaklar',
        'leo': 'İlişkiler ve ortaklıklar köklü dönüşüm geçiriyor',
        'virgo': 'Günlük yaşam, sağlık ve iş rutinleri değişiyor',
        'libra': 'Yaratıcılık, romantizm ve çocuklarla ilişki dönüşüyor',
        'scorpio': 'Ev, aile ve duygusal temel yeniden yapılanıyor',
        'sagittarius': 'İletişim, öğrenme ve kardeşlerle ilişki dönüşüyor',
        'capricorn': 'Değerler ve finansal yapın köklü değişiyor',
        'aquarius': 'KİMLİĞİN TAMAMIYLA DÖNÜŞÜYOR - yeniden doğuş',
        'pisces': 'Bilinçaltı, maneviyat ve gizli düşmanlar',
      },
    ),
    'neptune_in_aries': LongTermTransit(
      transit: 'Neptün Koç\'a Geçiyor',
      period: '2025-2039',
      generalTheme: 'Kolektif rüyaların yeni başlangıçları',
      collectiveEffect: '''
Neptün 2025'te Koç'a giriyor - 165 yıl sonra ilk kez!
Yeni bir kolektif rüya, yeni ilham çağı başlıyor.

TEMALAR:
• Spiritüel öncülük ve liderlik
• Yeni sanat ve müzik akımları
• Kolektif vizyonların yenilenmesi
• İnanç sistemlerinde devrim
• Teknoloji ve maneviyat birleşimi

Bu transit kuşakları etkileyecek büyük bir enerji değişimi.
''',
      signEffects: {
        'aries': 'BÜYÜK MANEVİ UYANIS - kimliğinin ruhsal dönüşümü',
        'taurus': 'Bilinçaltı ve rüyalar çok aktif',
        'gemini': 'Sosyal çevre ve idealler bulanıklaşıp netleşiyor',
        'cancer': 'Kariyer vizyonu ve hayat amacı yeniden tanımlanıyor',
        'leo': 'Felsefi ve spiritüel arayışlar yoğunlaşıyor',
        'virgo': 'Derin duygusal ve finansal konularda sezgisel rehberlik',
        'libra': 'İlişkilerde maneviyat ve kayıp sınırlar',
        'scorpio': 'Günlük yaşamda ilham ve hizmet',
        'sagittarius': 'Yaratıcılık ve romantizmde mistik boyut',
        'capricorn': 'Ev ve ailede spiritüel şifa',
        'aquarius': 'İletişimde sezgi ve telepati',
        'pisces': 'Değerlerde ve öz-değerde dönüşüm',
      },
    ),
    'uranus_in_gemini': LongTermTransit(
      transit: 'Uranüs İkizler\'e Geçiyor',
      period: '2025-2033',
      generalTheme: 'İletişim ve bilgi devrimi',
      collectiveEffect: '''
Uranüs 2025'te İkizler'e giriyor - iletişim, bilgi ve
medyada devrim başlıyor.

TEMALAR:
• Bilgi erişiminde devrim
• Medya ve haberleşme dönüşümü
• Eğitim sistemlerinin yenilenmesi
• Yapay zeka ve dil
• Seyahat ve ulaşımda inovasyon

84 yılda bir döngü - son kez 1940'larda!
''',
      signEffects: {
        'aries': 'İletişim ve öğrenme tarzın devrim geçiriyor',
        'taurus': 'Finansal değerler ve kazanç yöntemleri sarsılıyor',
        'gemini': 'KİMLİĞİN TAMAMIYLA DEVRİME UĞRUYOR',
        'cancer': 'Bilinçaltı ve maneviyatta beklenmedik uyanışlar',
        'leo': 'Sosyal çevre ve gelecek vizyonunda sürprizler',
        'virgo': 'Kariyer ve kamusal rolde ani değişiklikler',
        'libra': 'İnançlar ve yabancı bağlantılarda devrim',
        'scorpio': 'Ortak kaynaklar ve derin bağlarda sarsıntı',
        'sagittarius': 'İlişkilerde özgürlük ve beklenmedik gelişmeler',
        'capricorn': 'Günlük rutinlerde ve sağlıkta ani değişimler',
        'aquarius': 'Yaratıcılık ve romantizmde inovasyon',
        'pisces': 'Ev ve ailede beklenmedik dönüşümler',
      },
    ),
  };
}

// ════════════════════════════════════════════════════════════════════════════
// MODEL SINIFLAR
// ════════════════════════════════════════════════════════════════════════════

class MoonPhaseTheme {
  final String phase;
  final String generalTheme;
  final String energyLevel;
  final List<String> bestFor;
  final List<String> avoid;
  final String affirmation;

  const MoonPhaseTheme({
    required this.phase,
    required this.generalTheme,
    required this.energyLevel,
    required this.bestFor,
    required this.avoid,
    required this.affirmation,
  });
}

class DayPlanetaryEnergy {
  final String day;
  final String rulingPlanet;
  final String planetSymbol;
  final String theme;
  final List<String> bestActivities;
  final String color;
  final String crystal;
  final String affirmation;

  const DayPlanetaryEnergy({
    required this.day,
    required this.rulingPlanet,
    required this.planetSymbol,
    required this.theme,
    required this.bestActivities,
    required this.color,
    required this.crystal,
    required this.affirmation,
  });
}

class DailyHoroscopeAreas {
  final String area;
  final String icon;
  final List<String> questions;

  const DailyHoroscopeAreas({
    required this.area,
    required this.icon,
    required this.questions,
  });
}

class WeeklyStructure {
  final List<String> sections;
  final bool dailyHighlights;
  final bool luckyNumbers;
  final bool luckyColors;

  const WeeklyStructure({
    required this.sections,
    required this.dailyHighlights,
    required this.luckyNumbers,
    required this.luckyColors,
  });
}

class WeeklyTheme {
  final String theme;
  final String generalAdvice;
  final List<String> doList;
  final List<String> dontList;

  const WeeklyTheme({
    required this.theme,
    required this.generalAdvice,
    required this.doList,
    required this.dontList,
  });
}

class MonthlyTheme {
  final String month;
  final String sign;
  final String generalTheme;
  final List<String> keyPhrases;
  final String collectiveEnergy;

  const MonthlyTheme({
    required this.month,
    required this.sign,
    required this.generalTheme,
    required this.keyPhrases,
    required this.collectiveEnergy,
  });
}

class YearlyStructure {
  final List<String> sections;
  final bool quarterlyBreakdown;
  final bool monthlyHighlights;
  final bool luckyDays;

  const YearlyStructure({
    required this.sections,
    required this.quarterlyBreakdown,
    required this.monthlyHighlights,
    required this.luckyDays,
  });
}

class LongTermTransit {
  final String transit;
  final String period;
  final String generalTheme;
  final String collectiveEffect;
  final Map<String, String> signEffects;

  const LongTermTransit({
    required this.transit,
    required this.period,
    required this.generalTheme,
    required this.collectiveEffect,
    required this.signEffects,
  });
}
