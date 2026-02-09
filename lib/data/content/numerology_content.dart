/// NUMEROLOGY CONTENT - SAYI SEMBOLİZMİ VE REFLEKSIYON
///
/// Yaşam Yolu Sayıları (1-9), Master Sayılar (11, 22, 33),
/// Kişisel refleksiyon temaları ve arketipsel içerikler.
///
/// Her içerik refleksiyon amaçlı yazılmıştır:
/// - Sembolik ve arketipsel dil
/// - Öz-farkındalık odaklı yaklaşım
/// - Günlük soruları ve refleksiyon temaları
/// - Kültürel ve tarihsel bağlam
///
/// Bu içerik tahmin değil, kişisel refleksiyon için tasarlanmıştır.
library;

/// Content disclaimer for all numerology content
const String numerologyContentDisclaimer = '''
Number symbolism is a cultural tradition spanning thousands of years.
These descriptions are archetypal patterns for self-reflection, not predictions.

Numerology does not scientifically determine personality or predict events.
It can be used as a framework for self-exploration and journaling.

This is not fortune-telling. It is a tool for inner reflection.
''';

/// ═══════════════════════════════════════════════════════════════════════════
/// YAŞAM YOLU SAYILARI (LIFE PATH) 1-9
/// ═══════════════════════════════════════════════════════════════════════════

class LifePathContent {
  final int number;
  final String title;
  final String archetype;
  final String symbol;
  final String element;
  final String planet;
  final String tarotCard;
  final String color;
  final String crystal;
  final String shortDescription;
  final String deepMeaning;
  final String soulMission;
  final String giftToWorld;
  final String shadowWork;
  final String spiritualLesson;
  final String loveAndRelationships;
  final String careerPath;
  final String healthAndWellness;
  final String famousPeople;
  final String dailyAffirmation;
  final String viralQuote;
  final List<String> compatibleNumbers;
  final List<String> challengingNumbers;
  final List<String> keywords;
  final Map<String, String> yearlyGuidance; // Key: "2024", "2025"

  const LifePathContent({
    required this.number,
    required this.title,
    required this.archetype,
    required this.symbol,
    required this.element,
    required this.planet,
    required this.tarotCard,
    required this.color,
    required this.crystal,
    required this.shortDescription,
    required this.deepMeaning,
    required this.soulMission,
    required this.giftToWorld,
    required this.shadowWork,
    required this.spiritualLesson,
    required this.loveAndRelationships,
    required this.careerPath,
    required this.healthAndWellness,
    required this.famousPeople,
    required this.dailyAffirmation,
    required this.viralQuote,
    required this.compatibleNumbers,
    required this.challengingNumbers,
    required this.keywords,
    this.yearlyGuidance = const {},
  });
}

/// Tüm Yaşam Yolu içerikleri
final Map<int, LifePathContent> lifePathContents = {
  1: const LifePathContent(
    number: 1,
    title: 'Öncü',
    archetype: 'Lider / Yaratıcı',
    symbol: '☉',
    element: 'Ateş',
    planet: 'Güneş',
    tarotCard: 'Büyücü',
    color: 'Altın, Kırmızı',
    crystal: 'Sitrin, Kaplan Gözü',
    shortDescription:
        'Bağımsızlık, liderlik ve yaratıcılığın sayısı. Bireysellik ve özgünlük enerjisini taşır.',
    deepMeaning: '''
1 sayısı, var oluşun ilk titreşimidir - hiçlikten bir şeyin doğuşu. Kadim Kabala'da "Kether" (Taç) ile ilişkilendirilir, saf potansiyelin sembolüdür.

Sen bu hayata yeni başlangıçlar yapmak, kendi yolunu çizmek ve başkalarına ilham vermek için geldin. İçindeki ateş, seni durmaksızın ileriye iter. Ama unutma: gerçek liderlik, önden koşmak değil - ışığı taşımaktır.

Pisagor, 1'i "monad" olarak adlandırdı - bölünmez birlik. Sen de bölünmez bir irade taşıyorsun. Zorluk şu ki, bu irade bazen inatçılığa dönüşebilir. Kadim bilgelik der ki: "Esnemeyen ağaç, fırtınada kırılır."

Sayının gizli dersi: Bağımsızlık, yalnızlık değildir. Liderlik, hizmet etmektir.
''',
    soulMission: '''
Ruhun bu hayata benzersiz bir vizyon getirmek için geldi. Görevin, kendi yolunu yaratırken başkalarına da cesaret vermek.

Kadim öğretiler, 1 sayısını "ilk hareket" olarak tanımlar - Big Bang'in numerolojik karşılığı. Sen de bir şeyleri başlatmak, ateşlemek için buradasın.

Ama dikkat: Misyonun sadece kendin için değil. Işığın başkalarını aydınlattığında gerçek amacına ulaşırsın.
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Cesaret ve öncülük.

İnsanlar senin enerjinden, kararlılığından ve "ben yapabilirim" tutumundan beslenir. Varlığın bile bir motivasyon kaynağı.

Kadim bilgeler, 1'lerin "yol açıcılar" olduğunu söyler. Orman yolunu açan ilk kişi olmak zordur - ama arkandan gelenler için hayat kolaylaşır.
''',
    shadowWork:
        'Ego şişkinliği, aşırı bağımsızlık, başkalarını dinlememe, sabırsızlık, diktatörlük eğilimi. Gölgen, "ben en iyisini bilirim" yanılgısıdır.',
    spiritualLesson: '''
Ruhsal dersin: Güç, kontrol değildir.

Gerçek liderlik, insanları yönetmek değil - onların potansiyelini açığa çıkarmaktır. Güneş gibi ol: Isıt, aydınlat, ama yakma.

Meditasyon önerisi: "Ben her şeyin başlangıcı değilim, ama başlangıçlara ilham verebilirim."
''',
    loveAndRelationships: '''
Aşkta bağımsızlığını koruyan, ama bencilliğe kaçmayan bir denge arıyorsun.

İdeal ilişki: Sana alan tanıyan, ama seni zorlayan bir partner. Sıkıcılığa tahammülün yok - entelektüel ve duygusal uyarıcılara ihtiyacın var.

Dikkat: Kontrolcü olmaktan kaçın. "Benim yolum ya da hiç" yaklaşımı ilişkileri zehirler.

Uyumlu sayılar: 3 (yaratıcı dans), 5 (macera ortağı), 7 (derin bağlantı)
''',
    careerPath: '''
Girişimcilik, yöneticilik, yaratıcı işler sana göre.

Başkalarının vizyonunu uygulamak senin için zor - kendi fikirlerini hayata geçirmelisin.

Önerilen alanlar: Startup kurucusu, yaratıcı direktör, serbest danışman, motivasyon koçu, keşif/araştırma.

Kaçınılması gereken: Monoton, kuralcı, hiyerarşik ortamlar.
''',
    healthAndWellness: '''
Stres baş ve kalp bölgesinde birikir. Yüksek tansiyona dikkat.

Öneriler: Bireysel sporlar (koşu, yüzme), rekabetçi aktiviteler, doğada yalnız yürüyüşler.

Kaçınılması gereken: Aşırı çalışma, uyku ihmalı, tek başına her şeyi yüklenme.
''',
    famousPeople: 'Martin Luther King Jr., Lady Gaga, Steve Jobs, Nikola Tesla',
    dailyAffirmation:
        'Ben yeni başlangıçların gücünü taşıyorum. Cesaretle ileri yürüyorum.',
    viralQuote:
        '"1 ol: Tek ol, özgün ol, ilk ol. Ama asla yalnız değilsin - sen bütünün parçasısın."',
    compatibleNumbers: ['3', '5', '7'],
    challengingNumbers: ['4', '8'],
    keywords: [
      'Liderlik',
      'Bağımsızlık',
      'Yaratıcılık',
      'Öncülük',
      'Cesaret',
      'Vizyon',
    ],
    yearlyGuidance: {
      '2024':
          '2024 senin için yeni projelere başlama yılı. Ertelediğin fikirleri hayata geçir.',
      '2025':
          '2025\'te liderlik becerilerin ön plana çıkacak. Ekip kurmak, işbirliği yapmak önemli.',
      '2026':
          '2026 iç dengeye dönüş yılı. Tek başına zaman geçir, vizyonunu netleştir.',
    },
  ),

  2: const LifePathContent(
    number: 2,
    title: 'Diplomat',
    archetype: 'Barışçı / Şifacı',
    symbol: '☽',
    element: 'Su',
    planet: 'Ay',
    tarotCard: 'Yüksek Rahibe',
    color: 'Gümüş, Turuncu',
    crystal: 'Ay Taşı, Pembe Kuvars',
    shortDescription:
        'Denge, ortaklık ve sezgi sayısı. İlişkilerde uyum ve diplomasi enerjisi taşır.',
    deepMeaning: '''
2 sayısı, birliğin bölünmesi ve yeniden birleşme arayışıdır. Yin-Yang'ın sayısal ifadesi, dualite ve denge.

Kabala'da 2, "Chokmah" (Bilgelik) ile ilişkilendirilir - saf potansiyelin ilk yansıması. Sen ayna gibisin: Başkalarının gerçekliğini yansıtır, onlara kendilerini gösterirsin.

Kadim Mısır'da 2, Isis ve Osiris efsanesinde - ayrılık ve yeniden birleşme - kodlanmıştır. Senin de dersin bu: Bağlantı kurmak, köprü olmak.

Ama dikkat: Ayna kırılgandır. Kendiniyansıtmak için başkalarına ihtiyaç duyarsın - ama kendi ışığını unutma.
''',
    soulMission: '''
Ruhun bu hayata barış getirmek için geldi. Görevin, insanları birbirine bağlamak, çatışmaları çözmek, şifa vermek.

Kadim öğretiler, 2'yi "köprü" olarak tanımlar. İki uç arasında denge noktasısın.

Ama misyonun pasif kalmak değil. Barış bazen cesaret ister - bazen "hayır" demek de barışı korur.
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Empati ve şifa.

İnsanlar yanında kendilerini güvende hisseder. Varlığın, fırtınalı sularda bir liman gibi.

Sezgilerin keskin - çoğu zaman kelimelere dökülmeden önce hissedersin. Bu bir armağan, ama bazen de bir yük olabilir.
''',
    shadowWork:
        'Aşırı uyumculuk, çatışmadan kaçma, kararsızlık, başkalarının onayına bağımlılık, pasif-agresif davranış.',
    spiritualLesson: '''
Ruhsal dersin: Denge dışarıda değil, içeride bulunur.

Başkalarını memnun etmek için kendini feda etme. "Hayır" demek de sevginin bir formudur.

Meditasyon önerisi: "Ben hem bireyim hem de bir parçayım. İkisi de tamamdır."
''',
    loveAndRelationships: '''
Aşk senin için hayatın merkezinde. Derin, anlamlı bağlantılar arıyorsun.

İdeal ilişki: Duygusal olarak mevcut, destekleyici, ama seni boğmayan bir partner.

Dikkat: Bağımlılık tehlikesi var. Kendi ayaklarının üzerinde durabilmelisin.

Uyumlu sayılar: 6 (şefkatli aşk), 8 (güçlü destek), 9 (ruhani bağ)
''',
    careerPath: '''
Danışmanlık, terapi, arabuluculuk, sanat, müzik sana göre.

Takım çalışması ve işbirliği ortamlarında parlarsın.

Önerilen alanlar: Psikolog, mediator, insan kaynakları, sanatçı, sosyal hizmet.

Kaçınılması gereken: Aşırı rekabetçi, agresif ortamlar.
''',
    healthAndWellness: '''
Duygusal stres sindirim sistemi ve bağışıklıkta birikir.

Öneriler: Yoga, dans, su terapisi, meditasyon, eşli sporlar.

Kaçınılması gereken: Yalnız kalmak, duyguları bastırmak, çatışmayı içselleştirmek.
''',
    famousPeople: 'Barack Obama, Madonna, Jennifer Aniston, Kim Kardashian',
    dailyAffirmation:
        'Ben uyum ve dengenin taşıyıcısıyım. Hem kendime hem başkalarına şefkat gösteriyorum.',
    viralQuote:
        '"2 ol: Köprü ol, denge ol, barış ol. Güç tek başına değil, birlikte olunca çoğalır."',
    compatibleNumbers: ['6', '8', '9'],
    challengingNumbers: ['1', '5'],
    keywords: ['Diplomasi', 'Denge', 'Empati', 'Ortaklık', 'Sezgi', 'Barış'],
    yearlyGuidance: {
      '2024':
          '2024 ilişkilerde derinleşme yılı. Yüzeysel bağlantıları bırak, kalıcı olanları koru.',
      '2025': '2025\'te sezgilerin güçlenecek. İç sesin rehberliğine güven.',
      '2026': '2026 işbirliği yılı. Ortaklıklar, birlikte projeler ön planda.',
    },
  ),

  3: const LifePathContent(
    number: 3,
    title: 'İfadeci',
    archetype: 'Sanatçı / İletişimci',
    symbol: '△',
    element: 'Hava',
    planet: 'Jüpiter',
    tarotCard: 'İmparatoriçe',
    color: 'Sarı, Turuncu',
    crystal: 'Akuamarin, Sitrin',
    shortDescription:
        'Yaratıcılık, iletişim ve neşe sayısı. Kendini ifade etme ve sosyal bağlantı enerjisi.',
    deepMeaning: '''
3 sayısı, kadim geometrinin en kutsal şekli - üçgenin sayısıdır. Tez, antitez, sentez. Başlangıç, orta, son. Üçlü tanrıçalar ve trinityler.

Hermetik öğretide 3, yaratıcı ifadenin sayısıdır: Düşünce (1) + Duygu (2) = Manifestasyon (3).

Sen bu hayata yaratmak, ifade etmek, bağlantı kurmak için geldin. İçindeki çocuk hiç ölmez - ve bu senin gücün.

Ama dikkat: Dağınıklık düşmanın. "Her şeyi yapabilirim" hissi bazen "hiçbir şeyi bitirmiyorum"a dönüşür.
''',
    soulMission: '''
Ruhun bu hayata neşe ve yaratıcılık getirmek için geldi. Görevin, karanlıkta bile gülebilmek ve bu ışığı yaymak.

Kadim öğretiler, 3'ü "yaratıcı kelam" olarak tanımlar. Kelimelerin güç taşır - dikkatli kullan.

Misyonun sadece eğlendirmek değil. Sanatın, şifa verebilir. Kelimelerin, dönüştürebilir.
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Neşe ve yaratıcı ilham.

İnsanlar yanında canlanır, gülümser, umutlanır. Varlığın, gri günlerde bir renk patlaması gibi.

Yaratıcılığın sınır tanımaz - ama odaklandığında gerçek eserler ortaya çıkar.
''',
    shadowWork:
        'Dağınıklık, yüzeysellik, aşırı konuşkanlık, eleştiriye aşırı hassasiyet, kaçış mekanizması olarak eğlence.',
    spiritualLesson: '''
Ruhsal dersin: Derinlik, genişlik kadar değerlidir.

Her şeyi deneyimlemek güzel, ama bazen bir şeyde ustalaşmak daha değerli.

Meditasyon önerisi: "Yaratıcılığım akarken, ben de akışta kalıyorum."
''',
    loveAndRelationships: '''
Aşkta eğlence, spontanlık ve entelektüel uyarı arıyorsun.

İdeal ilişki: Seninle gülecek, yaratıcılığını destekleyecek, ama ayakların yere bassın diye seni dengeleyecek biri.

Dikkat: Ciddi konulardan kaçma. İlişkiler sadece eğlence değil, bazen çaba ister.

Uyumlu sayılar: 1 (ilham ortağı), 5 (macera arkadaşı), 7 (derin muhabbet)
''',
    careerPath: '''
Sanat, yazarlık, oyunculuk, pazarlama, eğitim sana göre.

Yaratıcı özgürlük olmadan boğulursun.

Önerilen alanlar: Yazar, komedyen, grafik tasarımcı, öğretmen, sosyal medya uzmanı.

Kaçınılması gereken: Monoton, yaratıcılığı kısıtlayan işler.
''',
    healthAndWellness: '''
Stres boğaz ve sinir sisteminde birikir.

Öneriler: Şarkı söyleme, yazma, dans, sosyal aktiviteler, sanat terapisi.

Kaçınılması gereken: İzolasyon, duyguları bastırma, aşırı kafein.
''',
    famousPeople: 'Jim Carrey, Celine Dion, Snoop Dogg, John Travolta',
    dailyAffirmation:
        'Yaratıcılığım özgürce akıyor. Neşemi dünyayla paylaşıyorum.',
    viralQuote:
        '"3 ol: Yarat, ifade et, neşelen. Hayat sanat, sen de sanatçısın."',
    compatibleNumbers: ['1', '5', '7'],
    challengingNumbers: ['4', '6'],
    keywords: [
      'Yaratıcılık',
      'İletişim',
      'Neşe',
      'Sanat',
      'İfade',
      'Sosyallik',
    ],
    yearlyGuidance: {
      '2024':
          '2024 yaratıcı projeler için ideal. Ertelediğin sanat eserini hayata geçir.',
      '2025': '2025\'te iletişim becerilerin ön planda. Yaz, konuş, paylaş.',
      '2026': '2026 odaklanma yılı. Bir projeyi bitir, sonra diğerine geç.',
    },
  ),

  4: const LifePathContent(
    number: 4,
    title: 'Yapıcı',
    archetype: 'Mimar / Temel Atıcı',
    symbol: '□',
    element: 'Toprak',
    planet: 'Uranüs / Satürn',
    tarotCard: 'İmparator',
    color: 'Yeşil, Kahverengi',
    crystal: 'Yeşim, Turmalin',
    shortDescription:
        'İstikrar, düzen ve çalışkanlık sayısı. Somut temeller kurma ve güvenilirlik enerjisi.',
    deepMeaning: '''
4 sayısı, fiziksel dünyanın temelidir. Dört element, dört yön, dört mevsim. Kare - en stabil geometrik şekil.

Kadim Mısır piramitlerinin dört köşeli tabanı, 4'ün gücünü temsil eder: Sağlam temeller, kalıcı eserler.

Sen bu hayata inşa etmek, düzen kurmak, güvenilir olmak için geldin. Sabır senin süper gücün - ama bazen zindanın da olabilir.

Dikkat: Katılık düşmanın. "Kurallar kurallar" diyerek hayatın akışını kaçırabilirsin.
''',
    soulMission: '''
Ruhun bu hayata kalıcı bir şey bırakmak için geldi. Görevin, gelecek nesillere aktarılacak yapılar, sistemler, değerler oluşturmak.

Kadim öğretiler, 4'ü "temel taşı" olarak tanımlar. Görünmez olabilirsin, ama üzerinde inşa edilen her şeyi sen taşıyorsun.

Misyonun sadece çalışmak değil. Çalışmanın bir amacı olmalı - neyi inşa ediyorsun?
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Güvenilirlik ve istikrar.

İnsanlar sana güvenir, çünkü dediklerini yaparsın. Varlığın, kaotik bir dünyada bir kaya gibi.

Pratik zekan değerli - ama bazen "imkansız" dediklerin aslında mümkün.
''',
    shadowWork:
        'Aşırı katılık, iş bağımlılığı, değişime direnç, kontrol ihtiyacı, duygusal mesafe.',
    spiritualLesson: '''
Ruhsal dersin: Kontrol illüzyondur.

Temelleri sen atarsın, ama evren de işin içinde. Her şeyi planlayamazsın - ve bu normal.

Meditasyon önerisi: "Sağlam temeller kuruyorum, ama hayatın akışına da izin veriyorum."
''',
    loveAndRelationships: '''
Aşkta güvenlik, sadakat ve istikrar arıyorsun.

İdeal ilişki: Güvenilir, tutarlı, ayakları yere basan biri. Romantik sürprizler güzel, ama temel değil.

Dikkat: Çok katı beklentiler ilişkiyi boğabilir. Esneklik de sevginin parçası.

Uyumlu sayılar: 2 (duygusal destek), 6 (aile odaklı), 8 (hedef ortağı)
''',
    careerPath: '''
Mühendislik, mimarlık, finans, proje yönetimi sana göre.

Somut sonuçlar görmek istiyorsun.

Önerilen alanlar: Mühendis, muhasebeci, şef, operasyon müdürü, emlakçı.

Kaçınılması gereken: Belirsiz, yapısız, sürekli değişen ortamlar.
''',
    healthAndWellness: '''
Stres kemik ve eklemlerde birikir. Sırt ağrılarına dikkat.

Öneriler: Düzenli egzersiz rutini, doğada yürüyüş, yoga, masaj.

Kaçınılması gereken: Hareketsiz yaşam, aşırı çalışma, molasız tempo.
''',
    famousPeople: 'Oprah Winfrey, Bill Gates, Elton John, Kim Kardashian',
    dailyAffirmation:
        'Sağlam temeller kuruyorum. Çalışkanlığım meyvelerini veriyor.',
    viralQuote:
        '"4 ol: İnşa et, sabret, kal. Piramitler bir günde dikilmedi - ama hala ayaktalar."',
    compatibleNumbers: ['2', '6', '8'],
    challengingNumbers: ['3', '5'],
    keywords: [
      'İstikrar',
      'Çalışkanlık',
      'Düzen',
      'Güvenilirlik',
      'Yapı',
      'Disiplin',
    ],
    yearlyGuidance: {
      '2024': '2024 temel atma yılı. Uzun vadeli planlarını şimdi başlat.',
      '2025':
          '2025\'te esneklik teması öne çıkıyor. Kontrol etmeye çalışma, akışa gir.',
      '2026': '2026 hasat yılı. Çalışmalarının meyvelerini görmeye başlarsın.',
    },
  ),

  5: const LifePathContent(
    number: 5,
    title: 'Gezgin',
    archetype: 'Maceracı / Değişim Ustası',
    symbol: '☆',
    element: 'Hava / Eter',
    planet: 'Merkür',
    tarotCard: 'Hierophant',
    color: 'Turkuaz, Gri',
    crystal: 'Akuamarin, Turkuaz',
    shortDescription:
        'Özgürlük, değişim ve macera sayısı. Deneyim biriktirme ve uyum sağlama enerjisi.',
    deepMeaning: '''
5 sayısı, değişimin ve özgürlüğün sayısıdır. Beş duyu, beş element (Çin geleneğinde), pentagram.

Hermetik öğretide 5, "quintessence" - beşinci element, yaşam enerjisi, prana - ile ilişkilendirilir.

Sen bu hayata deneyimlemek, öğrenmek, değişmek için geldin. Rutine tahammülün yok - ama bu bazen istikrarsızlığa dönüşebilir.

Dikkat: Kaçış ve özgürlük arasındaki çizgiyi gör. Sorunlardan kaçmak özgürlük değil.
''',
    soulMission: '''
Ruhun bu hayata özgürlüğün anlamını keşfetmek için geldi. Görevin, deneyimler biriktirip bilgeliğe dönüştürmek.

Kadim öğretiler, 5'i "köprü" olarak tanımlar - maddi ve ruhani dünyalar arasında.

Misyonun sadece gezmek değil. Öğrendiklerini paylaşmak, değişimin ustası olmak.
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Uyum ve esneklik.

Her duruma adapte olabilirsin. Varlığın, donmuş kalıpları çözen bir rüzgar gibi.

Deneyimlerin zenginliği, başkalarına ilham veriyor - paylaş!
''',
    shadowWork:
        'Sorumsuzluk, bağlanma korkusu, aşırı dağınıklık, bağımlılık eğilimi (uyuşturucu, alkol, adrenalin).',
    spiritualLesson: '''
Ruhsal dersin: Gerçek özgürlük, içsel barıştır.

Dış dünyada ne kadar gezersen gez, huzur içeriden gelir.

Meditasyon önerisi: "Değişim benim doğam. İçsel huzurum, dış koşullardan bağımsız."
''',
    loveAndRelationships: '''
Aşkta özgürlük, macera ve zeka arıyorsun.

İdeal ilişki: Seninle birlikte keşfedecek, ama seni kontrol etmeyecek biri.

Dikkat: Bağlanma korkun ilişkileri sabote edebilir. Özgürlük, yalnızlık değil.

Uyumlu sayılar: 1 (bağımsız ruhlar), 3 (eğlenceli ortaklık), 7 (entelektüel bağ)
''',
    careerPath: '''
Seyahat, satış, girişimcilik, medya, danışmanlık sana göre.

Değişkenlik ve çeşitlilik şart.

Önerilen alanlar: Seyahat blogger'ı, satış temsilcisi, danışman, pilot, gazeteci.

Kaçınılması gereken: Monoton, masa başı, değişmeyen işler.
''',
    healthAndWellness: '''
Aşırı uyarı sinir sistemini yorar. Uyku sorunlarına dikkat.

Öneriler: Çeşitli egzersiz türleri, macera sporları, doğada vakit, digital detox.

Kaçınılması gereken: Aşırı kafein, uykusuzluk, bağımlılık yapıcı maddeler.
''',
    famousPeople: 'Angelina Jolie, Beyoncé, Steven Spielberg, Abraham Lincoln',
    dailyAffirmation: 'Değişime açığım. Her deneyim beni zenginleştiriyor.',
    viralQuote:
        '"5 ol: Keşfet, değiş, özgürleş. Konfor alanın güzel, ama büyüme orada yok."',
    compatibleNumbers: ['1', '3', '7'],
    challengingNumbers: ['2', '4'],
    keywords: ['Özgürlük', 'Macera', 'Değişim', 'Esneklik', 'Deneyim', 'Uyum'],
    yearlyGuidance: {
      '2024': '2024 değişim yılı. Kalıpları kır, yeni şeyler dene.',
      '2025':
          '2025\'te seyahat enerjisi güçlü. Fiziksel veya zihinsel yolculuklara çık.',
      '2026': '2026 dengeleme yılı. Özgürlük ve sorumluluk arasında denge bul.',
    },
  ),

  6: const LifePathContent(
    number: 6,
    title: 'Bakıcı',
    archetype: 'Şifacı / Koruyucu',
    symbol: '✡',
    element: 'Su / Toprak',
    planet: 'Venüs',
    tarotCard: 'Aşıklar',
    color: 'Pembe, Mavi',
    crystal: 'Gül Kuvarsı, Yeşim',
    shortDescription:
        'Sevgi, sorumluluk ve aile sayısı. Şifa verme ve koruma enerjisi taşır.',
    deepMeaning: '''
6 sayısı, uyum ve dengenin mükemmel ifadesidir. İç içe geçmiş iki üçgen (Davut Yıldızı) - yukarı ve aşağının birleşimi.

Kadim öğretilerde 6, "kozmik anne" enerjisi taşır: Koruyucu, besleyici, şifa verici.

Sen bu hayata sevmek, korumak, iyileştirmek için geldin. Vermen güzel - ama kendini tüketme.

Dikkat: "Herkes için fedakarlık" seni boşaltır. Kendine de bak.
''',
    soulMission: '''
Ruhun bu hayata koşulsuz sevgiyi öğretmek için geldi. Görevin, ev ve aile kavramını yeniden tanımlamak.

Kadim öğretiler, 6'yı "kalp" olarak tanımlar. Sayısal dizide tam ortada - denge noktası.

Misyonun sadece aile değil. Topluluk, dostluk, insanlık ailesi - hepsine şifa götürebilirsin.
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Koşulsuz sevgi ve şifa.

İnsanlar yanında kendilerini kabul edilmiş hisseder. Varlığın, sıcak bir kucaklama gibi.

Estetik anlayışın güçlü - güzellik yaratma yeteneğin var.
''',
    shadowWork:
        'Aşırı korumacılık, fedakarlık bağımlılığı, müdahalecilik, başkalarının hayatını yaşama.',
    spiritualLesson: '''
Ruhsal dersin: Önce kendi maskenizi takın.

Başkalarını kurtaramazsın - sadece destek olabilirsin. Herkesin kendi yolu var.

Meditasyon önerisi: "Sevgim sınırsız, ama enerjim değil. Önce kendimi dolduruyorum."
''',
    loveAndRelationships: '''
Aşkta derin bağlılık, güvenlik ve aile arıyorsun.

İdeal ilişki: Karşılıklı bakım, sadakat, ortak değerler. Yüzeysel ilişkiler seni tatmin etmez.

Dikkat: "Kurtarıcı" rolüne girme. Sağlıklı ilişki, iki eşit insanın birleşimidir.

Uyumlu sayılar: 2 (duygusal derinlik), 4 (istikrar), 9 (idealist birlik)
''',
    careerPath: '''
Sağlık, eğitim, danışmanlık, sanat sana göre.

Başkalarına hizmet etmek tatmin ediyor.

Önerilen alanlar: Doktor, hemşire, öğretmen, terapist, iç mimar, aşçı.

Kaçınılması gereken: Rekabetçi, acımasız, değer odaklı olmayan ortamlar.
''',
    healthAndWellness: '''
Başkalarının stresini üstlenme eğilimi. Omuz ve sırt ağrılarına dikkat.

Öneriler: Masaj, aromaterapi, yemek pişirme, bahçecilik, hayvanlarla vakit.

Kaçınılması gereken: Kendi ihtiyaçlarını ihmal, duygusal tükenme.
''',
    famousPeople:
        'John Lennon, Michael Jackson, Jessica Alba, Victoria Beckham',
    dailyAffirmation:
        'Sevgim şifa veriyor. Önce kendimi seviyorum, sonra dünyayı.',
    viralQuote:
        '"6 ol: Sev, koru, iyileştir. Ama unutma - sen de sevilmeyi hak ediyorsun."',
    compatibleNumbers: ['2', '4', '9'],
    challengingNumbers: ['1', '5'],
    keywords: ['Sevgi', 'Aile', 'Sorumluluk', 'Şifa', 'Koruma', 'Uyum'],
    yearlyGuidance: {
      '2024':
          '2024 aile ve ev odaklı yıl. Sıcak bir yuva oluşturmaya yatırım yap.',
      '2025':
          '2025\'te kendi bakımına önem ver. Başkalarını kurtarmaya çalışma.',
      '2026': '2026 denge yılı. Vermek ve almak arasında uyum bul.',
    },
  ),

  7: const LifePathContent(
    number: 7,
    title: 'Arayıcı',
    archetype: 'Filozof / Mistik',
    symbol: '🔮',
    element: 'Su',
    planet: 'Neptün',
    tarotCard: 'Savaş Arabası',
    color: 'Mor, İndigo',
    crystal: 'Ametist, Lapis Lazuli',
    shortDescription:
        'Bilgelik, içsel arayış ve mistisizm sayısı. Derinlik ve anlam arayışı enerjisi.',
    deepMeaning: '''
7 sayısı, kadim mistisizmin en kutsal sayısıdır. Yedi gün, yedi çakra, yedi kat gök, yedi ölümcül günah...

Kabala'da 7, "Netzach" (Zafer) ile ilişkilendirilir - ruhani mücadele ve üstesinden gelme.

Sen bu hayata sorgulamak, aramak, derinlere inmek için geldin. Yüzeysel cevaplar seni tatmin etmez.

Dikkat: Aşırı izolasyon düşmanın. Bilgelik paylaşılmadığında anlamsızlaşır.
''',
    soulMission: '''
Ruhun bu hayata hakikati aramak için geldi. Görevin, gizemli soruları sormak ve cevapları paylaşmak.

Kadim öğretiler, 7'yi "arayıcı" olarak tanımlar. Görünmeyen dünyayla bağlantın güçlü.

Misyonun sadece okumak değil. Deneyimlemek, sorgulamak, öğrendiklerini entegre etmek.
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Derinlik ve bilgelik.

İnsanlar yanında düşünmeye, sorgulamaya, derinleşmeye davet edilir. Varlığın, sakin bir göl gibi - yüzeyin altında sonsuzluk var.

Sezgilerin keskin, analitik zekan güçlü - birleştirdiğinde benzersiz bir perspektif oluşuyor.
''',
    shadowWork:
        'Aşırı izolasyon, duygusal mesafe, aşırı eleştirisellik, paranoya, "kimse anlamıyor" sendromu.',
    spiritualLesson: '''
Ruhsal dersin: Bilgi, sevgi olmadan eksiktir.

Kafanı geliştirirken kalbini ihmal etme. Gerçek bilgelik, hem akıl hem kalp ister.

Meditasyon önerisi: "Hakikati arıyorum. Yalnız değilim - evren benimle beraber."
''',
    loveAndRelationships: '''
Aşkta derinlik, entelektüel bağ ve ruhani uyum arıyorsun.

İdeal ilişki: Seninle derin sohbetler yapabilecek, sessizliğe de tahammül edebilecek biri.

Dikkat: Duygusal mesafe ilişkileri öldürür. Açılmayı öğren.

Uyumlu sayılar: 3 (yaratıcı ilham), 5 (entelektüel uyarı), 9 (ruhani birlik)
''',
    careerPath: '''
Araştırma, yazarlık, danışmanlık, psikoloji, ruhani meslekler sana göre.

Yüzeysel işler seni tüketir.

Önerilen alanlar: Araştırmacı, yazar, psikolog, din bilgini, veri analisti, şifacı.

Kaçınılması gereken: Sosyal baskının yoğun olduğu, yüzeysel işler.
''',
    healthAndWellness: '''
Aşırı düşünce baş ve sinir sistemini yorar. Uyku sorunlarına dikkat.

Öneriler: Meditasyon, doğada yalnız yürüyüş, su terapisi, sessizlik retritleri.

Kaçınılması gereken: Aşırı kafein, uyku ihmalı, sosyal izolasyon.
''',
    famousPeople:
        'Nikola Tesla, Princess Diana, Stephen Hawking, Leonardo DiCaprio',
    dailyAffirmation: 'Hakikati arıyorum. Derinliğim benim gücüm.',
    viralQuote:
        '"7 ol: Sorgula, ara, derinleş. Cevap her zaman yüzeyde değil - ama arayan bulur."',
    compatibleNumbers: ['3', '5', '9'],
    challengingNumbers: ['1', '8'],
    keywords: [
      'Bilgelik',
      'İçsel Arayış',
      'Mistisizm',
      'Derinlik',
      'Sezgi',
      'Analiz',
    ],
    yearlyGuidance: {
      '2024': '2024 içsel yolculuk yılı. Meditasyon, okuma, sessizlik.',
      '2025': '2025\'te öğrendiklerini paylaş. Yalnız başına bilgi biriktirme.',
      '2026': '2026 denge yılı. Kafanla kalbin arasında köprü kur.',
    },
  ),

  8: const LifePathContent(
    number: 8,
    title: 'Güç Ustası',
    archetype: 'Yönetici / Manifestor',
    symbol: '∞',
    element: 'Toprak',
    planet: 'Satürn',
    tarotCard: 'Güç',
    color: 'Siyah, Altın',
    crystal: 'Obsidyen, Kaplan Gözü',
    shortDescription:
        'Güç, başarı ve bolluk sayısı. Maddi dünyada ustalık ve karmik denge enerjisi.',
    deepMeaning: '''
8 sayısı, sonsuzu (∞) temsil eder - enerji döngüsü, verme ve alma dengesi. Yan yatırılmış 8, karma sembolü.

Kadim öğretilerde 8, "dünyevi ustalık" sayısıdır. Maddi dünyada başarı, ama ruhani hesap verebilirlik ile.

Sen bu hayata güç kullanmayı öğrenmek için geldin. Büyük güç, büyük sorumluluk getirir.

Dikkat: Güç zehirleyebilir. Amaçlarını kontrol et - kime hizmet ediyorsun?
''',
    soulMission: '''
Ruhun bu hayata bolluk ve güç döngüsünü öğretmek için geldi. Görevin, maddi başarıyı ruhani değerlerle dengelemek.

Kadim öğretiler, 8'i "karma ustası" olarak tanımlar. Bu hayatta ne ekersen, kat kat biçersin.

Misyonun sadece zengin olmak değil. Zenginliği akıllıca kullanmak, başkalarına kapı açmak.
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Manifestasyon ve organizasyon.

İnsanlar senin yanında potansiyellerini görmeye başlar. Varlığın, "yapılabilir" enerjisi taşıyor.

Liderlik becerilerin doğal - ama gücü paylaşmayı da öğren.
''',
    shadowWork:
        'Güç sarhoşluğu, materyalizm, manipülasyon, işkoliklik, duygusal soğukluk.',
    spiritualLesson: '''
Ruhsal dersin: Para araç, amaç değil.

Başarı, para biriktirmek değil - değer yaratmak. Ne için yaşıyorsun?

Meditasyon önerisi: "Bolluk bana akıyor. Benim üzerimden geçip başkalarına da ulaşıyor."
''',
    loveAndRelationships: '''
Aşkta güç dengesi, karşılıklı saygı ve ortak hedefler arıyorsun.

İdeal ilişki: Seninle birlikte bir şeyler inşa edecek, ama sana meydan okuyabilecek biri.

Dikkat: İlişkileri de "proje" gibi yönetme. Duygular mantıkla çözülmez.

Uyumlu sayılar: 2 (duygusal denge), 4 (somut ortaklık), 6 (değer odaklı)
''',
    careerPath: '''
Yöneticilik, finans, hukuk, girişimcilik sana göre.

Güç ve etki alanın olmalı.

Önerilen alanlar: CEO, yatırımcı, avukat, emlak geliştirici, siyasetçi.

Kaçınılması gereken: Güç ve otoriteden yoksun, bağımlı pozisyonlar.
''',
    healthAndWellness: '''
Stres sindirim sistemi ve kardiyovasküler sistemde birikir.

Öneriler: Güç antrenmanı, yürüyüş, finansal wellness, iş-yaşam dengesi.

Kaçınılması gereken: İşkoliklik, stresi yemeyle bastırma, uyku ihmalı.
''',
    famousPeople: 'Nelson Mandela, Pablo Picasso, Sandra Bullock, 50 Cent',
    dailyAffirmation: 'Gücümü bilgelikle kullanıyorum. Bolluk hayatıma akıyor.',
    viralQuote:
        '"8 ol: Güç kazan, akıllıca kullan, paylaş. Gerçek zenginlik, verdiğinde çoğalan."',
    compatibleNumbers: ['2', '4', '6'],
    challengingNumbers: ['1', '7'],
    keywords: ['Güç', 'Başarı', 'Bolluk', 'Manifestasyon', 'Karma', 'Liderlik'],
    yearlyGuidance: {
      '2024':
          '2024 finansal fırsatlar yılı. Yatırım yap, ama etik çizgini koru.',
      '2025': '2025\'te güç dengesi teması öne çıkıyor. Yönetirken empati göster.',
      '2026': '2026 karma hasat temalı bir yıl. Geçmişte ektiğin tohumların meyve verme zamanı.',
    },
  ),

  9: const LifePathContent(
    number: 9,
    title: 'İnsancıl',
    archetype: 'Bilge / Şifacı',
    symbol: '☯',
    element: 'Ateş / Su',
    planet: 'Mars / Neptün',
    tarotCard: 'Ermiş',
    color: 'Altın, Beyaz',
    crystal: 'Opal, Ametist',
    shortDescription:
        'Evrensel sevgi, bilgelik ve tamamlanma sayısı. İnsanlığa hizmet ve ruhsal olgunluk enerjisi.',
    deepMeaning: '''
9 sayısı, döngünün tamamlanmasıdır. 1'den 9'a kadar tüm sayıların toplamı (1+2+3+4+5+6+7+8=36, 3+6=9).

Kadim öğretilerde 9, "usta sayı" - tüm deneyimleri içeren, ama hiçbirine bağlı kalmayan.

Sen bu hayata insanlığa hizmet etmek için geldin. Eski ruhsun - birçok yaşamın bilgeliğini taşıyorsun.

Dikkat: "Kurtarıcı kompleksi" tehlikesi var. Herkesi kurtaramazsın - ama ilham verebilirsin.
''',
    soulMission: '''
Ruhun bu hayata bir döngüyü tamamlamak için geldi. Görevin, öğrendiklerini insanlığa hediye etmek.

Kadim öğretiler, 9'u "evrensel sevgi" olarak tanımlar. Tüm sayıların içinde, ama hepsinin ötesinde.

Misyonun sadece yardım değil. Bırakma, tamamlama, yeni başlangıçlara zemin hazırlama.
''',
    giftToWorld: '''
Dünyaya getirdiğin armağan: Evrensel şefkat ve bilgelik.

İnsanlar yanında daha büyük bir şeyin parçası olduklarını hisseder. Varlığın, bir fanus gibi - içeriden parlıyor.

Yaratıcılığın derin - ama en çok başkalarına hizmet ettiğinde tatmin oluyorsun.
''',
    shadowWork:
        'Kurtarıcı kompleksi, geçmişe takılma, kayıp hissi, bırakamama, şehitlik eğilimi.',
    spiritualLesson: '''
Ruhsal dersin: Bırakmak, sevgisizlik değil.

Her şeyin bir sonu var - ve bu normal. Tamamlanma, yeni başlangıcın kapısı.

Meditasyon önerisi: "Bırakıyorum ve bıraktıkça özgürleşiyorum. Evren benim için en iyisini biliyor."
''',
    loveAndRelationships: '''
Aşkta derin ruhani bağ, koşulsuz kabul ve ortak vizyon arıyorsun.

İdeal ilişki: Seninle birlikte dünyayı daha iyi bir yer yapacak, insanlık vizyonunu paylaşacak biri.

Dikkat: Herkes için fedakarlık ilişkini ihmal ettirmesin. Partnerin de önemli.

Uyumlu sayılar: 3 (yaratıcı ruhlar), 6 (şefkatli kalpler), 7 (derin bağ)
''',
    careerPath: '''
İnsani yardım, sanat, sağlık, eğitim, ruhani meslekler sana göre.

Dünyayı değiştirmek istiyorsun.

Önerilen alanlar: STK yöneticisi, sanatçı, psikolog, din adamı, aktivist, terapi.

Kaçınılması gereken: Bencil, sadece kar odaklı işler.
''',
    healthAndWellness: '''
Başkalarının enerjisini üstlenme eğilimi. Bağışıklık sistemine dikkat.

Öneriler: Enerji temizliği, meditasyon, sanat terapisi, topluluk hizmeti.

Kaçınılması gereken: Duygusal vampirler, tükenmişlik, sınırsız verme.
''',
    famousPeople: 'Mahatma Gandhi, Mother Teresa, Bob Marley, Jim Carrey',
    dailyAffirmation: 'Evrensel sevgi benimle akıyor. Dünyanın ışığı oluyorum.',
    viralQuote:
        '"9 ol: Sev, bırak, dönüştür. Son değil - yeni bir başlangıç. Her kapanış bir açılış."',
    compatibleNumbers: ['3', '6', '7'],
    challengingNumbers: ['4', '8'],
    keywords: [
      'İnsanlık',
      'Bilgelik',
      'Tamamlama',
      'Evrensel Sevgi',
      'Şifa',
      'Bırakma',
    ],
    yearlyGuidance: {
      '2024': '2024 tamamlama yılı. Yarım kalan işleri bitir, geçmişi bırak.',
      '2025':
          '2025\'te evrensel hizmet çağrısı. Daha büyük bir amaca hizmet et.',
      '2026':
          '2026 yeni başlangıçlar yılı. 9\'un ardından 1 gelir - yeni döngü başlıyor.',
    },
  ),
};

/// ═══════════════════════════════════════════════════════════════════════════
/// MASTER SAYILARI (11, 22, 33)
/// ═══════════════════════════════════════════════════════════════════════════

class MasterNumberContent {
  final int number;
  final String title;
  final String archetype;
  final String element;
  final String shortDescription;
  final String deepMeaning;
  final String soulMission;
  final String challenge;
  final String spiritualLesson;
  final String viralQuote;
  final List<String> keywords;

  const MasterNumberContent({
    required this.number,
    required this.title,
    required this.archetype,
    required this.element,
    required this.shortDescription,
    required this.deepMeaning,
    required this.soulMission,
    required this.challenge,
    required this.spiritualLesson,
    required this.viralQuote,
    required this.keywords,
  });
}

final Map<int, MasterNumberContent> masterNumberContents = {
  11: const MasterNumberContent(
    number: 11,
    title: 'Mistik Aydınlatıcı',
    archetype: 'Vizoner / Ruhani Öğretmen',
    element: 'Işık / Eter',
    shortDescription:
        'İlham, sezgi ve ruhani aydınlanma sayısı. İnsanlığa ışık tutma misyonu.',
    deepMeaning: '''
11, ilk master sayıdır - "sezgi kapısı". İki paralel 1, iki dünya arasındaki köprü: Görünen ve görünmeyen.

Kabala'da 11, "Da'at" (bilgi) ile ilişkilendirilir - mistik uçurum, bilinenden bilinmeyene geçiş.

11'ler yüksek frekanslı ruhlar. Sezgilerin keskin, vizyonların güçlü. Ama yüksek frekans, yüksek hassasiyet de getirir.

Sayının gizli yükü: Işık taşımak ağır. Kendinle ve dünyayla barış yapmadan başkalarını aydınlatamazsın.
''',
    soulMission: '''
Ruhun bu hayata insanlığa ilham vermek için geldi. Mistik deneyimlerini dünyevi dile çevirmek görevin.

11'ler "köprü ruhlar" - ruhani alemlerin bilgisini bu dünyaya taşıyorlar.

Ama dikkat: Mesajları alırsın - ama iletmek için önce kendini şifamalısın.
''',
    challenge: '''
En büyük zorluk: Aşırı hassasiyet ve anksiyete.

Yüksek frekansın, düşük frekanslı ortamlarda zorlanmanı sağlar. Enerjini korumayı öğrenmelisin.

Pratik dünyayla dengesizlik - bazen "kafası bulutlarda" olarak algılanabilirsin.
''',
    spiritualLesson: '''
Ruhsal dersin: Işık olmak için önce kendi karanlığını aydınlat.

Başkalarını aydınlatmadan önce kendi gölgenle yüzleş. Mesaj taşıyıcısı ol, ama mesajı yaşa da.

Günlük uygulama: Meditasyon, enerji koruma, grounding (topraklanma).
''',
    viralQuote:
        '"11:11 - Evrenin sana mesajı var. Uyan, dinle, aydınlan. Sen ışığın taşıyıcısısın."',
    keywords: ['İlham', 'Sezgi', 'Mistisizm', 'Aydınlanma', 'Köprü', 'Vizyon'],
  ),

  22: const MasterNumberContent(
    number: 22,
    title: 'Usta Mimar',
    archetype: 'İnşaatçı / Vizyon Gerçekleştirici',
    element: 'Toprak / Ateş',
    shortDescription:
        'Vizyonu gerçeğe dönüştürme sayısı. Büyük ölçekte inşa etme ve mirası kodlama misyonu.',
    deepMeaning: '''
22, "Usta Mimar" sayısıdır - vizyonu taşa işlemek. 11'in sezgisel bilgisini 4'ün pratik gücüyle birleştir.

Kadim yapı ustaları, özellikle masonlar, 22'yi kutsal sayardı. Büyük piramitler, katedraller bu enerjinin ürünü.

22'ler dünyayı değiştirecek potansiyel taşır - ama bu potansiyeli gerçekleştirmek ağır bir sorumluluk.

Sayının gizli yükü: Büyük vizyon, büyük hayal kırıklığı riski taşır. Adım adım ilerlemeyi öğren.
''',
    soulMission: '''
Ruhun bu hayata kalıcı bir miras bırakmak için geldi. Sadece kendin için değil - gelecek nesiller için inşa ediyorsun.

22'ler "pratik mistikler" - rüyaları gerçeğe çevirenler.

Ama dikkat: Her vizyonu tek başına gerçekleştiremezsin. Ekip kur, delege et, güven.
''',
    challenge: '''
En büyük zorluk: Vizyonun büyüklüğü ile kapasitenin sınırları arasındaki gerilim.

Mükemmeliyetçilik felç edebilir. "Ya hep ya hiç" yerine "adım adım" öğren.

Stres ve tükenmişlik riski yüksek - sürdürülebilir ritim bul.
''',
    spiritualLesson: '''
Ruhsal dersin: Temel atmak, bina dikmek kadar kutsal.

Görünmeyen işler de önemli. Sabır, disiplin, tutarlılık - bunlar 22'nin gerçek gücü.

Günlük uygulama: Planlama, meditasyon, fiziksel aktivite, doğada vakit.
''',
    viralQuote:
        '"22 - Rüyaları inşa et. Vizyonun büyük, temellerin sağlam olsun. Gelecek senin ellerinde şekilleniyor."',
    keywords: ['İnşa', 'Vizyon', 'Miras', 'Ustalık', 'Pratiklik', 'Kalıcılık'],
  ),

  33: const MasterNumberContent(
    number: 33,
    title: 'Usta Öğretmen',
    archetype: 'İyileştirici / Koşulsuz Sevgi Ustası',
    element: 'Işık / Sevgi',
    shortDescription:
        'Koşulsuz sevgi ve ruhani öğreticilik sayısı. İnsanlığın şifası için hizmet misyonu.',
    deepMeaning: '''
33, master sayıların en yükseğidir - "kozmik kalp". 11'in sezgisi + 22'nin inşa gücü = 33'ün şifa potansiyeli.

Kadim öğretilerde 33, "avatarlık" sayısıdır - İsa'nın 33 yaşında çarmıha gerilmesi, Buddha'nın 33 göğü...

33'ler nadir ve güçlü ruhlar. Varlıkları bile şifa verir - ama bu enerjiye hazır olmak gerekir.

Sayının gizli yükü: Kurtarıcı olmaya çalışma. Herkes kendi yolunda - sen sadece ışık tutuyorsun.
''',
    soulMission: '''
Ruhun bu hayata koşulsuz sevgiyi öğretmek için geldi. Sözlerle değil, varlığınla.

33'ler "yürüyen şifa" - etraflarındaki insanları yükseltiyorlar, çoğu zaman farkında bile olmadan.

Ama dikkat: Bu güç tüketici olabilir. Kendin için de zaman ayır.
''',
    challenge: '''
En büyük zorluk: Başkalarının acısını üstlenme.

Empatik sünger gibisin - her şeyi absorbe edersin. Enerji sınırları kritik.

"Herkes için her şey" olmaya çalışmak tükenmeye götürür.
''',
    spiritualLesson: '''
Ruhsal dersin: Şifa vermek için önce kendi yaralarını iyileştir.

Başkalarına aydınlanmayı öğretemezsin - sadece kendi ışığınla yolu gösterebilirsin.

Günlük uygulama: Sessizlik, meditasyon, doğada vakit, topluluk hizmeti (sınırlı dozda).
''',
    viralQuote:
        '"33 - Koşulsuz sev, ama önce kendini. Şifa verirken tükenme. Sen de evrenin çocuğusun."',
    keywords: [
      'Koşulsuz Sevgi',
      'Şifa',
      'Öğretmenlik',
      'Hizmet',
      'Ustalık',
      'Evrensellik',
    ],
  ),
};

/// ═══════════════════════════════════════════════════════════════════════════
/// KİŞİSEL YIL SAYILARI (1-9)
/// ═══════════════════════════════════════════════════════════════════════════

class PersonalYearContent {
  final int year;
  final String title;
  final String theme;
  final String energy;
  final String guidance;
  final String focus;
  final String avoid;
  final String affirmation;
  final String viralQuote;

  const PersonalYearContent({
    required this.year,
    required this.title,
    required this.theme,
    required this.energy,
    required this.guidance,
    required this.focus,
    required this.avoid,
    required this.affirmation,
    required this.viralQuote,
  });
}

final Map<int, PersonalYearContent> personalYearContents = {
  1: const PersonalYearContent(
    year: 1,
    title: 'Yeni Başlangıçlar',
    theme: 'Doğum, tohum ekme, bağımsızlık',
    energy: 'Ateşli, dinamik, öncü',
    guidance: '''
Bu yıl yeni bir 9 yıllık döngünün başlangıcı. Geçen dönemde öğrendiklerini bırak ve yeniden başla.

Kadim bilgelik: "Her başlangıç, bir sonun devamıdır." Cesaretle ilerle.

Yeni projeler, yeni ilişkiler, yeni alışkanlıklar için ideal zaman. Tereddüt etme - harekete geç.
''',
    focus: 'Kendine odaklan, vizyonunu netleştir, ilk adımları at',
    avoid: 'Kararsızlık, geçmişe takılma, başkalarının onayını bekleme',
    affirmation: 'Yeni başlangıçların gücüyle ilerliyorum. Bu benim yılım.',
    viralQuote:
        '"1. Yıl: Her şey yeniden başlıyor. Tohum ekme zamanı - ne istiyorsan şimdi ek."',
  ),
  2: const PersonalYearContent(
    year: 2,
    title: 'Sabır ve Ortaklık',
    theme: 'Bekleyiş, işbirliği, denge',
    energy: 'Sakin, işbirlikçi, sezgisel',
    guidance: '''
Bu yıl geçen yıl ektiğin tohumların büyümesini bekleme zamanı. Sabır kritik.

Kadim bilgelik: "Tohum karanlıkta büyür." Görmesen de gelişme var.

İlişkiler, ortaklıklar, işbirlikleri ön planda. Birlikte çalışmayı öğren.
''',
    focus: 'Sabır, dinleme, ilişki kurma, detaylara dikkat',
    avoid: 'Sabırsızlık, zorlamak, tek başına her şeyi yapmaya çalışmak',
    affirmation: 'Sabırla bekliyorum. Doğru zamanda doğru şeyler oluyor.',
    viralQuote:
        '"2. Yıl: Bekle, dinle, güven. Tohum toprakta - görünmese de büyüyor."',
  ),
  3: const PersonalYearContent(
    year: 3,
    title: 'Yaratıcılık ve İfade',
    theme: 'Yaratıcı patlama, sosyallik, neşe',
    energy: 'Neşeli, yaratıcı, sosyal',
    guidance: '''
Bu yıl kendini ifade etme, yaratma, sosyalleşme zamanı. Enerjin yüksek.

Kadim bilgelik: "Yaratıcılık ruhun dilidir." Sanat yap, yaz, konuş, paylaş.

Eğlence önemli - ama dağılmamaya dikkat et. Odaklanmış yaratıcılık en güçlüsüdür.
''',
    focus: 'Yaratıcı projeler, sosyal bağlantılar, kendini ifade',
    avoid: 'Dağınıklık, yüzeysellik, eleştiriye aşırı tepki',
    affirmation: 'Yaratıcılığım özgürce akıyor. Neşemi paylaşıyorum.',
    viralQuote:
        '"3. Yıl: Yarat, ifade et, neşelen. Sanatın, sesin, ışığın - dünyaya hediyendir."',
  ),
  4: const PersonalYearContent(
    year: 4,
    title: 'Temel Atma',
    theme: 'Çalışma, yapı kurma, disiplin',
    energy: 'Pratik, disiplinli, odaklı',
    guidance: '''
Bu yıl kolları sıvama ve çalışma zamanı. Geçen yılların vizyonlarını somut temellere dönüştür.

Kadim bilgelik: "Piramit bir taşla başlar." Adım adım inşa et.

Sıkı çalışma mevsimi - ama sabırlı ol. Temellerin sağlamsa, üzerine her şeyi inşa edebilirsin.
''',
    focus: 'Organizasyon, planlama, çalışma, sağlık rutinleri',
    avoid: 'Kaytarmak, temel atmadan bina dikmek, aşırı çalışma',
    affirmation: 'Sağlam temeller kuruyorum. Çalışmam meyvelerini veriyor.',
    viralQuote:
        '"4. Yıl: Çalış, inşa et, sabredÇalışmak zor, ama meyve tatlı."',
  ),
  5: const PersonalYearContent(
    year: 5,
    title: 'Değişim ve Özgürlük',
    theme: 'Dönüşüm, macera, beklenmedik gelişmeler',
    energy: 'Değişken, maceracı, dinamik',
    guidance: '''
Bu yıl değişim rüzgarları esiyor. Beklenmedik fırsatlar, ani dönüşler mümkün.

Kadim bilgelik: "Değişim evrenin doğası." Akışa gir, direnmek yorar.

Esnek ol, yeni deneyimlere açıl. Ama her değişikliğin peşinden koşma - önemli olanı seç.
''',
    focus: 'Esneklik, yeni deneyimler, seyahat, özgürleşme',
    avoid: 'Aşırı dağınıklık, sorumsuzluk, bağımlılıklar',
    affirmation: 'Değişime açığım. Her deneyim beni zenginleştiriyor.',
    viralQuote:
        '"5. Yıl: Değiş, keşfet, özgürleş. Konfor alanın dışına çık - orası büyüyor."',
  ),
  6: const PersonalYearContent(
    year: 6,
    title: 'Sevgi ve Sorumluluk',
    theme: 'Aile, ev, ilişkiler, hizmet',
    energy: 'Sevgi dolu, sorumlu, koruyucu',
    guidance: '''
Bu yıl ev ve aile ön planda. İlişkilere, sorumluluklara odaklan.

Kadim bilgelik: "Ev, kalbin olduğu yerdir." Sevdiklerini kolla, ama kendini de unutma.

Güzellik, estetik, uyum arayışı güçlü. Yaşam alanını düzenle, güzelleştir.
''',
    focus: 'Aile, ev, ilişkiler, estetik, sağlık',
    avoid: 'Aşırı fedakarlık, başkalarının hayatını yaşama, kontrolcülük',
    affirmation:
        'Sevgim şifa veriyor. Önce kendimi, sonra başkalarını seviyorum.',
    viralQuote:
        '"6. Yıl: Sev, koru, iyileştir. Ev sadece dört duvar değil - kalbin olduğu yer."',
  ),
  7: const PersonalYearContent(
    year: 7,
    title: 'İçsel Yolculuk',
    theme: 'Derinleşme, yalnızlık, araştırma, ruhaniyet',
    energy: 'İçe dönük, sezgisel, araştırmacı',
    guidance: '''
Bu yıl içe dönme ve derinleşme zamanı. Yavaşla, sorgula, anlamını ara.

Kadim bilgelik: "Sessizlikte bilgelik konuşur." Dış gürültüyü azalt.

Ruhani gelişim, meditasyon, okuma için ideal yıl. Ama aşırı izolasyondan kaçın.
''',
    focus: 'İçsel çalışma, araştırma, ruhani gelişim, sağlık',
    avoid: 'Aşırı izolasyon, aşırı analiz, paranoya',
    affirmation:
        'İçsel bilgeliğimi keşfediyorum. Sessizlikte cevapları buluyorum.',
    viralQuote:
        '"7. Yıl: Dur, dinle, derinleş. Cevaplar dışarıda değil - içinde."',
  ),
  8: const PersonalYearContent(
    year: 8,
    title: 'Güç ve Bolluk',
    theme: 'Maddi başarı, güç, karma hasat',
    energy: 'Güçlü, hırslı, manifestasyonel',
    guidance: '''
Bu yıl güç ve bolluk enerjisi yoğun. Geçen yılların çalışmalarının meyvelerini topla.

Kadim bilgelik: "Ne ekersen onu biçersin." Bu yıl karma hasat zamanı - iyi de kötü de.

Finansal fırsatlar, kariyer atılımları mümkün. Ama gücü etik kullan.
''',
    focus: 'Kariyer, finans, güç dengeleme, sağlık',
    avoid: 'Açgözlülük, materyalizm, güç sarhoşluğu',
    affirmation: 'Bolluk hayatıma akıyor. Gücümü bilgelikle kullanıyorum.',
    viralQuote:
        '"8. Yıl: Hasat zamanı. Ektiğini biçiyorsun - adil ol, bol ol."',
  ),
  9: const PersonalYearContent(
    year: 9,
    title: 'Tamamlama ve Bırakma',
    theme: 'Bitirme, temizlik, hizmet, hazırlık',
    energy: 'Dönüştürücü, bırakıcı, evrensel',
    guidance: '''
Bu yıl 9 yıllık döngünün finali. Yarım kalanları tamamla, gerekmeyen yükü bırak.

Kadim bilgelik: "Her son, bir başlangıçtır." Bırakmak acı verebilir, ama özgürleştirir.

İnsanlığa hizmet enerjisi güçlü. Ver, paylaş, iyilik yap - ama kendin için de alan bırak.
''',
    focus: 'Tamamlama, bırakma, temizlik, hizmet, hazırlık',
    avoid: 'Yeni başlangıçlar (bekle), geçmişe takılma, şehitlik',
    affirmation: 'Kolaylıkla bırakıyorum. Yeni döngüme hazırım.',
    viralQuote:
        '"9. Yıl: Bitir, bırak, temizle. Bir dönem kapanıyor - yenisine yer açılıyor."',
  ),
};

/// ═══════════════════════════════════════════════════════════════════════════
/// KARMİK BORÇ SAYILARI (KARMIC DEBT) 13, 14, 16, 19
/// ═══════════════════════════════════════════════════════════════════════════

class KarmicDebtContent {
  final int number;
  final String title;
  final String reducesTo;
  final String archetype;
  final String symbol;
  final String keywords;
  final String shortDescription;
  final String deepMeaning;
  final String pastLifeStory;
  final String currentLifeLesson;
  final String challenge;
  final String gift;
  final String healingPath;
  final String relationships;
  final String career;
  final String health;
  final String spiritualPractice;
  final String affirmation;
  final String viralQuote;
  final List<String> warnings;
  final List<String> strengths;

  const KarmicDebtContent({
    required this.number,
    required this.title,
    required this.reducesTo,
    required this.archetype,
    required this.symbol,
    required this.keywords,
    required this.shortDescription,
    required this.deepMeaning,
    required this.pastLifeStory,
    required this.currentLifeLesson,
    required this.challenge,
    required this.gift,
    required this.healingPath,
    required this.relationships,
    required this.career,
    required this.health,
    required this.spiritualPractice,
    required this.affirmation,
    required this.viralQuote,
    required this.warnings,
    required this.strengths,
  });
}

/// 4 Karmik Borç Sayısı
final Map<int, KarmicDebtContent> karmicDebtContents = {
  13: const KarmicDebtContent(
    number: 13,
    title: 'Tembellik Karması',
    reducesTo: '4',
    archetype: 'Tembel Ruh',
    symbol: '⚙️',
    keywords: 'Çalışma, disiplin, sorumluluk, temel inşa',
    shortDescription:
        'Geçmiş yaşamlarda kaçınılan çalışma ve sorumlulukların karmik yükü.',
    deepMeaning: '''
13 karmik borcu, ruhun geçmiş yaşamlarda çalışmaktan kaçındığı, sorumluluklardan kaytardığı ve kolay yolu seçtiği deneyimlerin birikimini taşır.

Bu sayı, "bedava öğle yemeği yoktur" evrensel yasasının somutlaşmış halidir. Geçmişte başkalarının sırtından geçinmiş, işlerini yarım bırakmış veya disiplinsiz yaşamış olabilirsin.

Şimdi bu ders, karşına engeller, gecikmeler ve zorlu çalışma koşulları olarak çıkıyor. Ama bunlar ceza değil - fırsat. Her engel, kaçınılan dersin öğrenilmesi için bir davet.

13 sayısı aynı zamanda dönüşüm sayısıdır. Tarot'ta 13, Ölüm kartıdır - eski benliğin ölümü ve yeni, daha disiplinli bir ruhun doğuşu.
''',
    pastLifeStory: '''
Geçmiş yaşamlarında muhtemelen:
• Başkalarının emeğini sömürdün
• Sorumluluklardan kaçtın
• Kolay yolu seçtin, kestirme aradın
• İşleri yarım bıraktın
• Tembel veya hedonist bir hayat sürdün
• Başkalarını kullandın

Bu yaşamda bunların karması ödeniyor. Ama hatırla: karma ceza değil, öğrenme fırsatı.
''',
    currentLifeLesson: '''
Bu yaşamdaki dersin: DİSİPLİN ve SORUMLULUK.

• Kolay yolu değil, doğru yolu seçmeyi öğren
• İşleri bitirmeyi, tamamlamayı öğren
• Adım adım, sabırla inşa etmeyi öğren
• Kendi emeğinle kazanmayı öğren
• Mazeret üretmek yerine çözüm üretmeyi öğren

Her zorlu iş, geçmişteki bir kaytarmanın karşılığı. Şikayet etmeden, minnetle karşıla.
''',
    challenge:
        'Kolay yolu seçme dürtüsü, tembellik, erteleme, yarım bırakma, mazeret üretme, engellerden yılma.',
    gift:
        'Sabır, dayanıklılık, pratik zeka, sağlam temeller inşa etme, zorlukları fırsata çevirme.',
    healingPath: '''
İyileşme yolunda şunları uygula:
1. Her gün bir şeyi TAMAMLA - küçük de olsa
2. Fiziksel çalışma yap - beden disiplini, zihin disiplini getirir
3. Düzenli rutinler oluştur ve ASLA bozma
4. "Yarın yaparım" yerine "ŞİMDİ başlarım" de
5. Minnettar ol - her zorluk bir ders
6. Topraklanma pratikleri: Doğada çalış, bahçeyle uğraş
''',
    relationships: '''
İlişkilerde 13 karmik borcu:
• Sorumluluk almaktan kaçma eğilimi
• "Benim işim değil" tavrı
• Partnerin sırtından geçinme riski
• Ama öğrenildiğinde: Güvenilir, sadık, sağlam partner

Ders: İlişkide de "iş"ini yap. Eşit sorumluluk, eşit emek.
''',
    career: '''
Kariyer ve para konusunda zorluklar yaşanabilir:
• İşler beklenenden zor olur
• Terfi gecikmeli gelir
• Kolay para yerine emek gerekir
• Ama sağlam temelli başarı mümkün

Tavsiye: Hızlı zenginlik planlarından kaç. Adım adım, sağlam inşa et.
''',
    health: '''
Fiziksel sağlıkta dikkat:
• Tembellik sağlığı bozar
• Düzenli egzersiz ŞART
• Omurga, kemik, eklemler hassas
• Disiplinli beslenme gerekli

Beden disiplini = Ruh disiplini. Bedenine iyi bak.
''',
    spiritualPractice: '''
Ruhsal pratikler:
• Karma yoga: Hizmetle arınma
• Günlük fiziksel pratik: Yoga, yürüyüş
• Toprak elementi çalışması
• Kök chakra dengeleme
• Minnettarlık günlüğü

Mantra: "Ben sorumluluklarımı sevgiyle üstleniyorum."
''',
    affirmation:
        'Çalışmak kutsaldır. Her görev, ruhumu arındırıyor. Disiplinim özgürlüğümdür.',
    viralQuote:
        '"13 Karmik Borcu: Geçmişte kaytardın, şimdi çalışma teması güçlü. Şikayet etme - her damla ter, bir karma damlası siliniyor."',
    warnings: [
      'Kolay para tuzaklarından kaç',
      'İşleri yarım bırakma',
      'Mazeret üretme alışkanlığından vazgeç',
      'Tembelliğe izin verme',
      'Başkalarını kullanma',
    ],
    strengths: [
      'Zor koşullarda çalışabilme',
      'Sabır ve dayanıklılık',
      'Pratik zeka',
      'Sağlam temeller kurma',
      'Zorlukları fırsata çevirme',
    ],
  ),

  14: const KarmicDebtContent(
    number: 14,
    title: 'Özgürlük Suistimali Karması',
    reducesTo: '5',
    archetype: 'Dizginsiz Ruh',
    symbol: '🔗',
    keywords: 'Özgürlük, bağımlılık, disiplin, denge, sorumluluk',
    shortDescription:
        'Geçmiş yaşamlarda özgürlüğün suistimalinin, aşırılıkların karmik sonucu.',
    deepMeaning: '''
14 karmik borcu, ruhun geçmiş yaşamlarda özgürlüğü kötüye kullandığı, aşırılıklara kaçtığı ve başkalarının özgürlüğünü kısıtladığı deneyimlerin yükünü taşır.

Bu sayı, "özgürlük sorumluluk gerektirir" dersinin somutlaşmış halidir. Geçmişte belki bağımlılıklara kapıldın, başkalarını esir ettin veya kendi ihtirasların için sınır tanımadın.

14, değişim ve dönüşüm sayısı olan 5'e indirgenir, ama bu değişim kontrolsüz olmamalı. Ders: ÖZGÜRLÜK + DİSİPLİN = GERÇEK ÖZGÜRLÜK.

Kısıtlamalar, bağımlılıklar ve tekrarlayan kalıplar bu karmayı çözmen için gelen öğretmenlerdir.
''',
    pastLifeStory: '''
Geçmiş yaşamlarında muhtemelen:
• Bağımlılıklara (alkol, kumar, seks, güç) yenik düştün
• Başkalarının özgürlüğünü kısıtladın
• Dizginsiz yaşadın, sınır tanımadın
• Aşırılıklarla başkalarına zarar verdin
• Tutkularının kölesi oldun
• Özgürlük adına sorumsuzca davrandın

Bu yaşamda bu kalıplarla yüzleşme teması var. Bilinçli seçimlerle döngüyü kırabilirsin.
''',
    currentLifeLesson: '''
Bu yaşamdaki dersin: DENGELİ ÖZGÜRLÜK.

• Özgürlük ile sorumluluk arasında denge kur
• Bağımlılık kalıplarını tanı ve aş
• "Hayır" demeyi öğren - kendine ve başkalarına
• Aşırılıklardan kaçın - her şeyde ölçü
• Başkalarının özgürlüğüne saygı göster
• İç özgürlüğü, dış özgürlükten önce bul

Gerçek özgürlük, hiçbir şeye bağımlı olmamaktır.
''',
    challenge:
        'Bağımlılık eğilimleri, aşırılıklar, sınır tanımama, huzursuzluk, taahhüt korkusu, kontrolsüz değişim.',
    gift:
        'Uyum sağlama, esneklik, değişimi yönetme, çeşitlilik, deneyim zenginliği.',
    healingPath: '''
İyileşme yolunda şunları uygula:
1. Her türlü bağımlılığı tanı (madde, ilişki, iş, telefon...)
2. 40 gün disiplin pratiği: Bir şeyden vazgeç
3. Düzenli meditasyon: İç huzuru bul
4. Fiziksel aktivite: Enerjiyi sağlıklı yönlendir
5. Dürüstlük pratiği: Kendinle ve başkalarıyla
6. Taahhüt pratiği: Küçük sözler ver ve tut
''',
    relationships: '''
İlişkilerde 14 karmik borcu:
• Taahhüt korkusu, kaçma dürtüsü
• Bağımlılık veya karşı-bağımlılık
• Aşırı kıskançlık veya ilgisizlik
• İlişkide özgürlük dengesi zorluğu

Ders: Bağlanmak esaret değil, özgür seçimdir. Sağlıklı sınırlarla aşk mümkün.
''',
    career: '''
Kariyer ve para konusunda:
• Bir işte kalamama, sürekli değişim
• Hızlı para ve hızlı kayıp döngüleri
• Risk alma ve kaybetme kalıpları
• İstikrarsızlık

Tavsiye: Esneklik güçlü yanın. Ama sağlam bir temel de kur. Dengeli risk al.
''',
    health: '''
Fiziksel sağlıkta dikkat:
• Bağımlılık eğilimleri (madde, yemek, davranış)
• Sinir sistemi hassasiyeti
• Aşırı aktivite veya tembellik
• Dengesiz beslenme

Ders: Bedenin mabeddir. Onu kirletme, temiz tut, dengede tut.
''',
    spiritualPractice: '''
Ruhsal pratikler:
• Farkındalık meditasyonu
• Bağımlılık kökeni çalışması
• Nefes çalışmaları
• Sakral chakra dengeleme
• 40 gün disiplin pratikleri

Mantra: "Ben özgürüm çünkü hiçbir şeye bağımlı değilim."
''',
    affirmation:
        'Gerçek özgürlüğü içimde buluyorum. Disiplinim beni özgürleştiriyor, kısıtlamıyor.',
    viralQuote:
        '"14 Karmik Borcu: Özgürlüğü suistimal ettin, şimdi gerçek özgürlüğü öğrenme teması var. Hiçbir şeye bağımlı olmamak - işte gerçek özgürlük."',
    warnings: [
      'Bağımlılık yapan her şeyden uzak dur',
      'Aşırılıklardan kaçın',
      'Taahhütlerden kaçma',
      'Anlık hazlar için uzun vadeli mutluluğu feda etme',
      'Başkalarının özgürlüğünü kısıtlama',
    ],
    strengths: [
      'Değişime uyum sağlama',
      'Esneklik ve çeşitlilik',
      'Risk yönetimi (öğrenildiğinde)',
      'Deneyim zenginliği',
      'Dönüşüm kapasitesi',
    ],
  ),

  16: const KarmicDebtContent(
    number: 16,
    title: 'Ego Yıkımı Karması',
    reducesTo: '7',
    archetype: 'Düşen Kule',
    symbol: '🗼',
    keywords: 'Ego, gurur, yıkım, yeniden doğuş, tevazu',
    shortDescription:
        'Geçmiş yaşamlarda egonun şişirilmesi, gururun karmik sonucu.',
    deepMeaning: '''
16 karmik borcu, en zorlu ama en dönüştürücü karmik yüklerden biridir. Geçmiş yaşamlarda ego aşırı şişmiş, gurur kontrolden çıkmış, ruh yoldan sapmıştır.

Tarot'ta 16, Kule kartıdır - ani yıkım, göğe uzanan kulenin yıldırımla vurulması. Ama bu yıkım, sahte temellerin çöküşüdür. Kalan, gerçek özündür.

Bu sayıyla gelenlerin hayatında "Kule anları" olur: Ani kayıplar, düşüşler, imaj çöküşleri. Bunlar ceza değil - ego temizliği. Her yıkım, daha otantik bir yeniden doğuşun habercisidir.

16/7 kombinasyonu, yıkımdan sonra derin içsel bilgeliğe ulaşma potansiyeli taşır. Ama önce egonun ölmesi gerekir.
''',
    pastLifeStory: '''
Geçmiş yaşamlarında muhtemelen:
• Güç ve statü için etik sınırları aştın
• Gurur ve kibirle başkalarını ezdin
• Tanrı rolü oynadın, tevazuyu unuttun
• Başarının seni "özel" kıldığına inandın
• Başkalarını küçümseyerek yükseldin
• Sahte bir imaj inşa ettin

Bu yaşamda bu sahte kule yıkılacak. Ama yıkıntılardan gerçek sen doğacak.
''',
    currentLifeLesson: '''
Bu yaşamdaki dersin: TEVAZU ve OTANTISITE.

• Ego ile özdeşleşmeyi bırak
• Sahte imajları yık, gerçeğini göster
• Kayıpları ruhsal temizlik olarak gör
• Başarıyı da başarısızlığı da dengede tut
• Tevazu pratik yap - her gün
• İç zenginliği, dış görünüşten önemli tut

Egonun ölümü, ruhun doğumudur.
''',
    challenge:
        'Ani kayıplar, imaj çöküşü, gurur yaraları, izolasyon, depresyon, anlam krizi.',
    gift: 'Derin içsel bilgelik, otantisite, ruhsal uyanış, tevazu, gerçeklik.',
    healingPath: '''
İyileşme yolunda şunları uygula:
1. Ego gözlemi: "Bu ben miyim, yoksa egom mu?"
2. Kayıpları armağan olarak kabul et
3. Başkalarına hizmet et - anonim olarak
4. Doğada zaman geçir - doğa ego tanımaz
5. Meditasyon ve içsel çalışma
6. Tevazu pratikleri: Küçük işler yap, övgü bekleme
''',
    relationships: '''
İlişkilerde 16 karmik borcu:
• İlişkilerde de "Kule anları" yaşanabilir
• Ani ayrılıklar, ihanetler, düşüşler
• Partnerle güç savaşları
• Ama öğrenildiğinde: Derin, otantik bağlar

Ders: İlişkide de maskeyi çıkar. Gerçek ben sevilmezse, sahte ben neden sevilsin?
''',
    career: '''
Kariyer ve statü konusunda:
• Ani düşüşler, itibar kayıpları mümkün
• "Zirvedeyken" bile dikkatli ol
• Başarı kalıcı değil, karakterin kalıcı
• Tevazu içinde liderlik öğren

Tavsiye: Başarıyı egoya değil, hizmete bağla. O zaman düşüşler daha az acıtır.
''',
    health: '''
Fiziksel sağlıkta dikkat:
• Ani sağlık sorunları mümkün
• Sinir sistemi, beyin hassasiyeti
• Depresyon eğilimi
• Stres yönetimi kritik

Ders: Beden de ego taşır. Onu da temizle - sağlıklı beslen, hareket et, dinlen.
''',
    spiritualPractice: '''
Ruhsal pratikler:
• Ego ölümü meditasyonları
• Taç chakra çalışması
• Sessizlik ve inziva dönemleri
• Hizmet - anonim olarak
• Doğada yalnız kalma

Mantra: "Ben egomdan ibaret değilim. Gerçek benliğim sonsuz ve tevazu doludur."
''',
    affirmation:
        'Egomun ölümüne izin veriyorum. Gerçek benliğim ortaya çıkıyor. Tevazuda güç buluyorum.',
    viralQuote:
        '"16 Karmik Borcu: Kulen yıkılacak. Ama yıkıntılardan çıkan SEN, kuleden çok daha değerli. Ego ölsün ki ruh doğsun."',
    warnings: [
      'Gururu besleyen her şeyden kaçın',
      'Sahte imaj inşa etme',
      'Başkalarını küçümseme',
      'Başarıya tapma',
      'Kayıplarla savaşma - kabul et',
    ],
    strengths: [
      'Derin içsel bilgelik potansiyeli',
      'Otantisite ve gerçeklik',
      'Ruhsal derinlik',
      'Dönüşüm kapasitesi',
      'Tevazu gücü',
    ],
  ),

  19: const KarmicDebtContent(
    number: 19,
    title: 'Güç Suistimali Karması',
    reducesTo: '1',
    archetype: 'Zalim Kral',
    symbol: '👑',
    keywords: 'Güç, bağımsızlık, bencillik, hizmet, liderlik',
    shortDescription:
        'Geçmiş yaşamlarda gücün bencilce kullanılmasının karmik sonucu.',
    deepMeaning: '''
19 karmik borcu, ruhun geçmiş yaşamlarda güç sahibi olup bunu bencilce, başkalarına zarar verecek şekilde kullandığı deneyimlerin yükünü taşır.

19, 1 (benlik, ego, liderlik) ve 9'un (evrensel hizmet, tamamlama) birleşimidir. Geçmişte 1 enerjisini sadece kendin için kullandın, 9'un evrensel hizmet boyutunu ihmal ettin.

Bu yaşamda güç sana yine gelecek - ama nasıl kullanacağını öğrenmen gerekiyor. Bencil kullanım, daha fazla karma biriktirirken; hizmet odaklı kullanım, karmayı temizler.

Tarot'ta 19, Güneş kartıdır - ama gölgeli yüzüyle. Güneş aydınlatır, ama yakabilir de. Gücünü ne için kullanacaksın?
''',
    pastLifeStory: '''
Geçmiş yaşamlarında muhtemelen:
• Güç sahibiydin ve bunu suistimal ettin
• Bencil liderlik yaptın
• Başkalarının üzerinden yükseldin
• Yardım edeceğine, sömürdün
• Kendi çıkarın için başkalarını feda ettin
• "Ben" dedikçe "Biz"i unuttun

Bu yaşamda bu güç karmasi seninle. Ama güç yine sana gelecek - bu sefer doğru kullan.
''',
    currentLifeLesson: '''
Bu yaşamdaki dersin: HİZMET ODAKLI LİDERLİK.

• Güç seninle, ama başkaları İÇİN
• Bağımsızlık güzel, ama bağlantıyı unutma
• Liderlik et, ama hizmetkar lider ol
• Başarını paylaş, tek başına tutma
• "Ben" yerine "Biz" de
• Alçakgönüllü güç - sessiz liderlik

Gerçek güç, başkalarını güçlendirmektir.
''',
    challenge:
        'Bencillik, yalnızlık, yardım kabul edememe, kontrol ihtiyacı, başkalarına güvenememe.',
    gift:
        'Doğal liderlik, bağımsızlık, yaratıcılık, ilham verme, dönüştürme gücü.',
    healingPath: '''
İyileşme yolunda şunları uygula:
1. Her gün birine yardım et - karşılıksız
2. Ekip çalışması: Tek başına değil, birlikte
3. Minnettarlık: Başkalarının katkısını gör
4. Alçakgönüllülük: Başarını paylaş
5. Hizmet odaklı projeler: Topluma katkı
6. Güç meditasyonları: Gücü nasıl kullanıyorum?
''',
    relationships: '''
İlişkilerde 19 karmik borcu:
• Yardım kabul etmekte zorluk
• Kontrolcülük, "ben bilirim" tavrı
• Yalnız kalma eğilimi
• Ama öğrenildiğinde: İlham veren partner

Ders: İlişkide de "ben" değil "biz". Güçlü olmak, savunmasız olmayı engellemez.
''',
    career: '''
Kariyer ve güç konusunda:
• Liderlik pozisyonları sana gelecek
• Ama tek başına zirve soğuk
• Ekibini yükselt, kendinle birlikte
• Başarını paylaşmayı öğren

Tavsiye: Gücünü hizmet için kullan. Bencil güç geçici, hizmet odaklı güç kalıcı.
''',
    health: '''
Fiziksel sağlıkta dikkat:
• Kalp ve dolaşım sistemi
• Tükenmişlik sendromu
• Her şeyi tek başına yapmaya çalışma
• Yardım kabul et

Ders: Beden de yardıma ihtiyaç duyar. Dinlen, delege et, yardım kabul et.
''',
    spiritualPractice: '''
Ruhsal pratikler:
• Karma yoga: Hizmetle arınma
• Güneş meditasyonları
• Güneş pleksus chakra çalışması
• Grup çalışmaları ve hizmet
• Alçakgönüllülük pratikleri

Mantra: "Gücüm hizmet içindir. Başkalarını yükselterek kendim yükseliyorum."
''',
    affirmation:
        'Gücümü başkalarını güçlendirmek için kullanıyorum. Bencilliği bırakıp hizmete dönüyorum.',
    viralQuote:
        '"19 Karmik Borcu: Gücün var, evet. Ama ne için? Kendin için kullanırsan yalnız kalırsın. Başkaları için kullanırsan - işte o zaman gerçek kral olursun."',
    warnings: [
      'Gücü bencil kullanma',
      'Yalnız kalma',
      'Yardım reddetme',
      'Kontrolcülük',
      'Başkalarının üzerinden yükselme',
    ],
    strengths: [
      'Doğal liderlik',
      'Bağımsız düşünce',
      'Yaratıcılık ve özgünlük',
      'İlham verme kapasitesi',
      'Dönüştürücü güç',
    ],
  ),
};
