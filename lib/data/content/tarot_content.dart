/// TAROT CONTENT - ARKETİPSEL SEMBOLLER
///
/// 22 Major Arcana kartı için detaylı kadim/ezoterik içerikler.
/// Her kart için: anlam, ters anlam, sembolizm, arketip, tavsiye, meditasyon.
library;

import '../providers/app_providers.dart';

class MajorArcanaContent {
  final int number;
  final String name;
  final String nameTr;
  final String archetype;
  final String element;
  final String planet;
  final String hebrewLetter;
  final String keywords;
  final String shortMeaning;
  final String deepMeaning;
  final String reversedMeaning;
  final String symbolism;
  final String spiritualLesson;
  final String loveReading;
  final String careerReading;
  final String advice;
  final String meditation;
  final String viralQuote;
  final String shadowAspect;

  const MajorArcanaContent({
    required this.number,
    required this.name,
    required this.nameTr,
    required this.archetype,
    required this.element,
    required this.planet,
    required this.hebrewLetter,
    required this.keywords,
    required this.shortMeaning,
    required this.deepMeaning,
    required this.reversedMeaning,
    required this.symbolism,
    required this.spiritualLesson,
    required this.loveReading,
    required this.careerReading,
    required this.advice,
    required this.meditation,
    required this.viralQuote,
    required this.shadowAspect,
  });

  /// Localized card name based on language
  String localizedName(AppLanguage language) {
    switch (language) {
      case AppLanguage.tr:
        return nameTr;
      case AppLanguage.en:
      case AppLanguage.de:
      case AppLanguage.fr:
      default:
        return name;
    }
  }
}

/// 22 Major Arcana Kartı
final Map<int, MajorArcanaContent> majorArcanaContents = {
  0: const MajorArcanaContent(
    number: 0,
    name: 'The Fool',
    nameTr: 'Deli / Aptal',
    archetype: 'Masum Yolcu',
    element: 'Hava',
    planet: 'Uranüs',
    hebrewLetter: 'Aleph (א)',
    keywords:
        'Yeni başlangıçlar, masumiyet, spontanlık, inanç sıçrayışı, potansiyel',
    shortMeaning:
        'Bilinmeyene adım atma cesareti. Saf potansiyel ve sınırsız olasılıklar.',
    deepMeaning: '''
Deli, Tarot yolculuğunun hem başlangıcı hem sonudur - 0 sayısı sonsuzluğu temsil eder. O henüz hiçbir şey deneyimlememiştir, ama tüm deneyimlerin potansiyelini taşır.

Kabala'da Aleph harfi, nefes ve ruhun başlangıcını simgeler. Deli, ruhun madde alemine ilk inişidir - henüz şartlanmamış, saf bilinç.

Uçurumun kenarında durur ama korkmaz - çünkü düşebileceğini bilmez. Bu cehalet mi, yoksa en derin bilgelik mi? Belki de ikisi de aynı şeydir.

Jung'a göre Deli, "puer aeternus" - ebedi çocuk arketipidir. Yaşlanmayan, kalıplaşmayan, her an yeniden doğabilen ruh.
''',
    reversedMeaning: '''
Ters Deli, ihtiyatsızlık, düşüncesizlik veya harekete geçememe korkusunu gösterir.

Belki çok uzun süredir uçurumun kenarında bekliyorsun - atlamaktan korkuyorsun. Ya da tam tersi: düşünmeden atlıyorsun ve sonuçlarına katlanmak zorunda kalıyorsun.

Soru şu: Korkuların mı seni engelliyor, yoksa gerçek bir tehlike mi var? Bazen "aptallık" aslında bilgeliktir - bazen de gerçekten aptallıktır.
''',
    symbolism: '''
• Beyaz güneş: Saf bilinç, aydınlanma
• Beyaz gül: Masumiyet, saflık
• Küçük çanta: Geçmişten taşınan minimal bagaj
• Beyaz köpek: İçgüdüler, sadık rehber
• Uçurum: Bilinmeyen, potansiyel
• Renkli giysiler: Yaşamın tüm deneyimleri
• Dağlar: Gelecekteki zorluklar ve başarılar
''',
    spiritualLesson: '''
Ruhsal ders: Güven ve teslimiyet.

Hayat bir sıçrayıştır - her an. Kontrol illüzyonundan vazgeç ve akışa teslim ol. Evren seni tutacak - ama önce atlamam gerekiyor.

"Bilmiyorum" demek cesaret ister. Ve bazen en bilge cevap budur.
''',
    loveReading: '''
Aşkta yeni bir başlangıç kapıda. Belki yeni bir ilişki, belki mevcut ilişkide yeni bir sayfa.

Kalıplarını bırak, geçmişin yaralarını bu ilişkiye taşıma. Her insan yeni bir evren - ona o gözle bak.

Uyarı: Körü körüne aşık olma. Sezgilerine güven, ama gözlerini de aç.
''',
    careerReading: '''
Yeni bir kariyer yolu, beklenmedik bir fırsat veya tamamen farklı bir alan.

Risk almaktan korkma - ama hesaplanmış risk al. Bazen en "mantıksız" kararlar en doğru olanlardır.

Girişimcilik, freelance çalışma veya yaratıcı projeler için mükemmel enerji.
''',
    advice: 'Atla. Düşünme, hisset. Bilinmeyene güven. Şimdi zamanı.',
    meditation: '''
Gözlerini kapat. Bir uçurumun kenarında durduğunu hayal et. Aşağısı görünmüyor - sadece bulutlar var.

Korkuyu hisset. Sonra bırak. Bir adım at. Düşmüyorsun - uçuyorsun.

Mantra: "Bilinmeyene güveniyorum. Her adım beni doğru yere götürüyor."
''',
    viralQuote:
        '"Deli ol: Atla, güven, uç. Kaybedecek bir şeyin yok - çünkü her şey zaten seninle."',
    shadowAspect:
        'Sorumsuzluk, kaçış, gerçeklikten kopma, çocuksu davranış, sonuçları düşünmeme.',
  ),

  1: const MajorArcanaContent(
    number: 1,
    name: 'The Magician',
    nameTr: 'Büyücü',
    archetype: 'Yaratıcı İrade',
    element: 'Hava',
    planet: 'Merkür',
    hebrewLetter: 'Beth (ב)',
    keywords: 'Manifestasyon, irade gücü, beceri, konsantrasyon, eylem',
    shortMeaning:
        'Düşüncelerini gerçeğe dönüştürme gücü. "Yukarıda ne varsa, aşağıda da o var."',
    deepMeaning: '''
Büyücü, kozmik enerjinin maddeye dönüştüğü noktadır. Bir eliyle göğü, diğeriyle yeri işaret eder - o bir kanaldır.

Hermetik öğretinin temel ilkesi burada somutlaşır: "As above, so below." Büyücü, bu ilkeyi uygulayan kişidir.

Masasında dört element sembolü var: Asa (Ateş/İrade), Kupa (Su/Duygu), Kılıç (Hava/Düşünce), Pentakl (Toprak/Madde). Tüm araçlar elinde - şimdi sadece kullanmak kaldı.

Başının üzerindeki sonsuzluk sembolü (∞), sınırsız potansiyeli gösterir. O bir yaratıcıdır - ve sen de öylesin.
''',
    reversedMeaning: '''
Ters Büyücü, gücün kötüye kullanımını veya potansiyelin boşa harcanmasını gösterir.

Belki yeteneklerini manipülasyon için kullanıyorsun. Belki de gücünün farkında değilsin ve kendini küçümsüyorsun.

Araçların var ama kullanmıyorsun. Ya da yanlış amaçlar için kullanıyorsun. Niyetini sorgula.
''',
    symbolism: '''
• Sonsuzluk sembolü (∞): Sınırsız potansiyel
• Beyaz bant (başta): Saf bilinç
• Kırmızı pelerin: Tutku ve irade
• Beyaz iç giysi: Saflık ve bilgelik
• Dört element: Yaratımın araçları
• Güller ve zambaklar: Tutku ve saflığın dengesi
• Yukarı ve aşağı işaret eden eller: "As above, so below"
''',
    spiritualLesson: '''
Ruhsal ders: Sen bir yaratıcısın.

Düşüncelerinin gücünü küçümseme. Her düşünce bir tohum, her niyet bir büyü. Neyi yaratıyorsun?

Büyü, doğaüstü değildir - doğanın gizli yasalarını bilmektir. Ve sen bu yasaları öğrenebilirsin.
''',
    loveReading: '''
Aşkta aktif rol alma zamanı. Bekleyerek bir şey olmaz - ilk adımı at.

Çekicilik enerjin yüksek. İstediğini çekebilirsin - ama önce ne istediğini net olarak bil.

Uyarı: Manipülasyondan kaçın. Gerçek büyü, zorlama değil - çekimdir.
''',
    careerReading: '''
Kariyerde manifestasyon gücün dorukta. Projeler başlat, sunumlar yap, liderlik al.

Tüm becerilerini bir araya getirme zamanı. Sen düşündüğünden daha yeteneklisin.

Girişimcilik, satış, pazarlama, yaratıcı projeler için mükemmel.
''',
    advice: 'Gücünü bil. Odaklan. Niyet koy. Sonra harekete geç.',
    meditation: '''
Gözlerini kapat. Kendini evrenin merkezinde hayal et. Bir elinle göğe, diğeriyle yere dokun.

Kozmik enerji tependen giriyor, kalbinde dönüşüyor, ellerinden akıyor.

Mantra: "Ben bir kanalım. Evrenin gücü benim aracılığımla akar."
''',
    viralQuote:
        '"Büyücü ol: Düşün, niyetlen, yarat. Sen evrenin eli, kainatın kalemisin."',
    shadowAspect:
        'Manipülasyon, aldatma, güç sarhoşluğu, yeteneklerin kötüye kullanımı.',
  ),

  2: const MajorArcanaContent(
    number: 2,
    name: 'The High Priestess',
    nameTr: 'Yüksek Rahibe',
    archetype: 'Sezgisel Bilgelik',
    element: 'Su',
    planet: 'Ay',
    hebrewLetter: 'Gimel (ג)',
    keywords: 'Sezgi, gizem, bilinçaltı, içsel bilgi, sessizlik',
    shortMeaning:
        'Görünmeyeni gören, bilinmeyeni bilen. İçsel bilgeliğin sesi.',
    deepMeaning: '''
Yüksek Rahibe, bilinçli ve bilinçdışı arasındaki perdenin bekçisidir. Arkasındaki perde, gizemlerin dünyasını örter - ama o geçişe izin verebilir.

Kabala'da Gimel harfi, "deve" anlamına gelir - çölü geçen, bilinmeyeni taşıyan. Rahibe de öyle: O, gizli bilginin taşıyıcısıdır.

Isis, Persephone, Artemis - kadim tanrıçaların hepsi onda birleşir. O, dişil bilgeliğin arketipidir: Alıcı, sezgisel, döngüsel.

Elindeki Tora kitabı, yazılı olmayan bilgiyi temsil eder. Bazı şeyler kelimelerle anlatılamaz - sadece bilinir.
''',
    reversedMeaning: '''
Ters Rahibe, sezgilerin bastırılmasını veya gizli bilginin kötüye kullanılmasını gösterir.

Belki iç sesinizi susturuyorsunuz. Belki de "mantıklı" olmaya çalışırken sezgilerinizi görmezden geliyorsunuz.

Ya da tam tersi: Gizli bilgiyi başkalarını manipüle etmek için kullanıyorsunuz. Sırlar güç verir - ama sorumluluk da.
''',
    symbolism: '''
• Mavi pelerin: Bilinçaltı, sezgi
• Ay tacı: Dişil enerji, döngüler
• Siyah ve beyaz sütunlar (B ve J): Dualite, polarite
• Perde: Görünen ve görünmeyen arasındaki sınır
• Su: Duygu, sezgi akışı
• Narlar: Persephone'un meyvesi, yeraltı bilgeliği
• Tora/kitap: Gizli bilgi
''',
    spiritualLesson: '''
Ruhsal ders: Sessizlikte dinle.

Cevaplar dışarıda değil - içeride. Meditasyon, rüyalar, sezgiler... Hepsi içsel bilgeliğinin sesleri.

Bazen en güçlü eylem, eylemsizliktir. Bekle, gözlemle, dinle.
''',
    loveReading: '''
Aşkta gizli bir şeyler var. Belki karşı tarafın söylemedikleri, belki senin fark etmediklerin.

Sezgilerine güven. "Bir şeyler yanlış" hissi varsa, muhtemelen haklısın. Ama hemen tepki verme - önce dinle.

Gizemli ol. Her şeyi hemen açıklama. Biraz sır, çekiciliği artırır.
''',
    careerReading: '''
Kariyerde araştırma, analiz ve gizli bilgiye erişim ön planda.

Henüz ortaya çıkmamış fırsatlar var. Piyasayı, rakipleri, trendleri gözlemle.

Psikoloji, araştırma, arşivcilik, danışmanlık alanları uygun.
''',
    advice: 'Sus ve dinle. Cevap geliyor - ama sessizlikte.',
    meditation: '''
Gözlerini kapat. Ay ışığında bir tapınakta oturduğunu hayal et. Önünde bir perde var.

Perdenin ardına bakma isteğini hisset. Ama acele etme. Perde kendi zamanında açılacak.

Mantra: "İçsel bilgeliğimi duyuyorum. Sessizlikte cevaplar bana geliyor."
''',
    viralQuote: '"Rahibe ol: Sus, dinle, bil. Gizem sende - sen gizemsin."',
    shadowAspect:
        'Gizlilik takıntısı, pasiflik, gerçeklikten kopma, manipülatif sezgi kullanımı.',
  ),

  3: const MajorArcanaContent(
    number: 3,
    name: 'The Empress',
    nameTr: 'İmparatoriçe',
    archetype: 'Bereket Tanrıçası',
    element: 'Toprak',
    planet: 'Venüs',
    hebrewLetter: 'Daleth (ד)',
    keywords: 'Bereket, yaratıcılık, doğurganlık, doğa, şefkat, güzellik',
    shortMeaning:
        'Yaşamın doğurgan gücü. Bolluk, güzellik ve şefkatin kaynağı.',
    deepMeaning: '''
İmparatoriçe, Büyük Anne'dir - tüm yaşamın doğduğu rahimdir. O, Gaia, Demeter, İştar'ın Tarot'taki yansımasıdır.

Kabala'da Daleth, "kapı" anlamına gelir. İmparatoriçe, ruhun maddeye geçiş kapısıdır - doğumun, yaratımın kapısı.

Rahibe'nin gizli bilgeliği, İmparatoriçe'de somutlaşır. Fikirler tohumdur - İmparatoriçe onları büyütür, besler, meyveye dönüştürür.

Tahtı buğday tarlasında, ayakları suda, başında yıldızlardan taç. O, göğün ve yerin, ruhun ve maddenin birleşimidir.
''',
    reversedMeaning: '''
Ters İmparatoriçe, yaratıcı tıkanıklık, kısırlık veya aşırı bağımlılığı gösterir.

Belki kendine bakmayı ihmal ediyorsun. Belki başkalarına o kadar veriyorsun ki, kendi kaynakların kuruyor.

Ya da tam tersi: Aşırı sahiplenme, boğucu sevgi, "koruyucu anne" sendromu.
''',
    symbolism: '''
• Buğday tarlası: Bereket, hasat
• Yıldızlı taç: Kozmik anne
• Venüs sembolü (kalpte): Aşk ve güzellik
• Kırmızı kadife: Tutku ve yaşam gücü
• Şelale/su: Duygu akışı, temizlenme
• Ağaçlar: Büyüme, kökler
• Yastık: Konfor, beslenme
''',
    spiritualLesson: '''
Ruhsal ders: Kendini besle.

Vermeden önce dolmalısın. Başkalarına sevgi dağıtmak için önce kendini sevmelisin.

Doğa senin öğretmenin. Ağaçlar nasıl büyür, çiçekler nasıl açar - izle ve öğren.
''',
    loveReading: '''
Aşkta bereket dönemi. Mevcut ilişki derinleşiyor, yeni ilişki çiçek açıyor.

Şefkat ve romantizm için mükemmel zaman. Duygularını ifade et, sevgini göster.

Hamilelik, evlilik veya ilişkide yeni bir aşama olabilir.
''',
    careerReading: '''
Kariyerde yaratıcı projeler büyüyor. Ektiğin tohumlar filizleniyor.

Sanat, tasarım, güzellik, sağlık, çocuklarla ilgili işler ön planda.

Sabırlı ol - hasat zamanı yaklaşıyor.
''',
    advice:
        'Besle - kendini, başkalarını, projelerini. Sevgiyle sular, sabırla bekle.',
    meditation: '''
Gözlerini kapat. Bereketli bir bahçede oturduğunu hayal et. Her tarafında çiçekler, meyveler, kuşlar var.

Toprakla bağlantını hisset. Kökler ayaklarından yerin derinliklerine iniyor.

Mantra: "Ben bereket kaynağıyım. Verdikçe çoğalıyorum."
''',
    viralQuote:
        '"İmparatoriçe ol: Besle, büyüt, çiçek aç. Sevgin dünyayı dönüştüren güç."',
    shadowAspect:
        'Aşırı korumacılık, bağımlılık yaratma, kendini ihmal, duygusal manipülasyon.',
  ),

  4: const MajorArcanaContent(
    number: 4,
    name: 'The Emperor',
    nameTr: 'İmparator',
    archetype: 'Otorite Figürü',
    element: 'Ateş',
    planet: 'Mars / Koç',
    hebrewLetter: 'Heh (ה)',
    keywords: 'Otorite, yapı, düzen, liderlik, koruma, disiplin',
    shortMeaning: 'Düzeni ve yasayı temsil eden güç. Koruyucu baba, lider.',
    deepMeaning: '''
İmparator, kaosun içinde düzen kuran güçtür. İmparatoriçe'nin yaratıcı enerjisine form ve yapı verir.

Kabala'da Heh harfi, "pencere" anlamına gelir. İmparator, kozmik düzenin dünyaya açılan penceresidir - yasalar onun aracılığıyla iner.

Taştan tahtı, sağlam temelleri simgeler. Koç başları, Mars enerjisini ve cesareti temsil eder. Elinde ankh - yaşamın anahtarı.

Jung'a göre İmparator, "senex" arketipidir - bilge yaşlı, toplumsal düzenin koruyucusu. Ama dikkat: Aşırı katılık tiranlığa dönüşebilir.
''',
    reversedMeaning: '''
Ters İmparator, tiranlık, aşırı kontrol veya otorite eksikliğini gösterir.

Belki çok katı kurallar koyuyorsun - kendine veya başkalarına. Belki de tam tersi: Yapı ve disiplinden yoksun bir hayat yaşıyorsun.

Baba figürüyle ilgili sorunlar olabilir. Otorite ile sağlıklı ilişki kuramamak.
''',
    symbolism: '''
• Taş taht: Sağlamlık, kalıcılık
• Koç başları: Cesaret, liderlik, Mars
• Kırmızı pelerin: Güç, tutku
• Zırh: Koruma, savunma
• Ankh: Yaşamın anahtarı
• Dağlar: Başarılar, fethedilen zirveler
• Küre: Dünyevi güç
''',
    spiritualLesson: '''
Ruhsal ders: Güç, sorumlulukla gelir.

Liderlik, başkalarının üzerinde güç değil - onlar için sorumluluk almaktır.

Yapı kurabilirsin - ama yapı hapisane olmamalı. Kurallar hizmet etmeli, köleleştirmemeli.
''',
    loveReading: '''
Aşkta istikrar ve güvenlik arayışı. Uzun vadeli taahhütler, evlilik, aile kurma.

Ancak dikkat: Kontrolcü olmak ilişkiyi boğar. Partner değil, eş arıyorsan - eşit ol.

Baba figürü veya yaşça büyük biriyle ilişki olabilir.
''',
    careerReading: '''
Kariyerde liderlik ve yöneticilik ön planda. Kurallar koymak, yapı kurmak, organizasyon.

Kendi işini kurma, yönetici pozisyonu veya danışmanlık için uygun zaman.

Hukuk, yönetim, inşaat, finans alanları ön planda.
''',
    advice: 'Yapı kur. Kuralları belirle. Ama esnekliği de unutma.',
    meditation: '''
Gözlerini kapat. Bir dağın zirvesinde, taş bir tahtta oturduğunu hayal et. Aşağıda krallığın uzanıyor.

Omuzlarındaki sorumluluğu hisset. Ama yük değil - onur.

Mantra: "Ben sağlam temeller üzerinde duruyorum. Gücüm hizmet içindir."
''',
    viralQuote:
        '"İmparator ol: Kur, koru, yönet. Ama unutma - taç ağırdır, taşıyan güçlü olmalı."',
    shadowAspect:
        'Tiranlık, aşırı kontrol, katılık, duygusal mesafe, güç sarhoşluğu.',
  ),

  5: const MajorArcanaContent(
    number: 5,
    name: 'The Hierophant',
    nameTr: 'Hierophant / Başrahip',
    archetype: 'Ruhani Öğretmen',
    element: 'Toprak',
    planet: 'Boğa',
    hebrewLetter: 'Vav (ו)',
    keywords: 'Gelenek, kurumlar, öğretim, inanç, ahlak, ritüel',
    shortMeaning: 'Kutsal bilginin öğretmeni. Gelenek ve ruhani rehberlik.',
    deepMeaning: '''
Hierophant, "kutsal olanı gösteren" anlamına gelir. O, görünmez olanı görünür kılan köprüdür - ruhani bilgiyi günlük hayata taşıyan.

Kabala'da Vav harfi, "çivi/bağlantı" anlamına gelir. Hierophant, göğü ve yeri birbirine bağlayan çividir.

Yüksek Rahibe'nin gizli bilgisi, Hierophant aracılığıyla topluma aktarılır. O bireysel değil, kolektif bilgeliktir.

Ama dikkat: Gelenek hem rehber hem hapishane olabilir. Hierophant'ın dersi, bilgeliği dogmadan ayırt etmektir.
''',
    reversedMeaning: '''
Ters Hierophant, geleneklere körü körüne bağlılık veya tamamen reddetmeyi gösterir.

Belki kuralları sorgulamadan kabul ediyorsun. Belki de her otoriteyi reddedip kendi yolunu arıyorsun.

Ruhani arayış kişisel bir yolculuğa dönüşebilir. Dışarıdan değil, içeriden öğrenme zamanı.
''',
    symbolism: '''
• Üçlü taç: Üç alem (fiziksel, zihinsel, ruhani)
• İki anahtar: Bilinç ve bilinçaltının anahtarları
• Çapraz asa: Dünyevi ve ruhani otoritenin birleşimi
• İki sütun: Dualite, denge
• İki öğrenci: Bilginin aktarımı
• Kırmızı ve beyaz giysiler: Tutku ve saflık
• El işareti: Kutsal öğretim (mudra)
''',
    spiritualLesson: '''
Ruhsal ders: Bilgelik aktarılarak çoğalır.

Öğretmen ol - ama önce öğrenci ol. Gelenekleri öğren, sonra kendi anlayışını ekle.

Dogma değil, canlı bilgelik. Kurallar değil, ilkeler.
''',
    loveReading: '''
Aşkta geleneksel yol. Resmi ilişki, nişan, evlilik, aile onayı.

Eğer geleneksel değilsen, bu kart meydan okuma olabilir. Toplum baskısını mı, yoksa kendi kalbini mi takip edeceksin?

Bir öğretmen veya mentor figürüyle ilişki olabilir.
''',
    careerReading: '''
Kariyerde kurumsal yapılar, eğitim ve geleneksel yollar ön planda.

Sertifika, diploma, resmi eğitim değerli. Bir mentor bul veya mentor ol.

Eğitim, din, hukuk, büyük kurumlar alanları uygun.
''',
    advice:
        'Geleneği öğren, ama kölesi olma. Bir öğretmen bul veya kendin öğret.',
    meditation: '''
Gözlerini kapat. Kadim bir tapınakta, bir bilgenin önünde diz çöktüğünü hayal et.

Bilge sana bir şey fısıldıyor. Dinle. Bu senin için özel bir mesaj.

Mantra: "Bilgeliği alıyorum, bilgeliği paylaşıyorum. Ben köprüyüm."
''',
    viralQuote:
        '"Hierophant ol: Öğren, öğret, aktar. Bilgelik paylaşıldıkça çoğalır."',
    shadowAspect:
        'Dogmatizm, körü körüne itaat, otorite korkusu, aşırı muhafazakarlık.',
  ),

  6: const MajorArcanaContent(
    number: 6,
    name: 'The Lovers',
    nameTr: 'Aşıklar',
    archetype: 'Birleşim',
    element: 'Hava',
    planet: 'İkizler',
    hebrewLetter: 'Zayin (ז)',
    keywords: 'Aşk, seçim, birleşim, uyum, değerler, ilişkiler',
    shortMeaning: 'Kutsal birleşim. Kalbin seçimi, değerlerin uyumu.',
    deepMeaning: '''
Aşıklar kartı, sadece romantik aşk değil - tüm birleşimlerin arketipidir. Zıtların dansı, polaritelerin kaynaşması.

Kabala'da Zayin, "kılıç" anlamına gelir. Aşıklar, ayrımcılık kılıcıyla seçim yapma yeteneğini simgeler.

Kartın altında Havva ve Adem, üstte melek Raphael. Bu, insan aşkının ilahi aşkla bağlantısını gösterir.

Jung'a göre bu, anima/animus birleşmesidir - iç dişil ve eril enerjilerin evliliği. Gerçek aşk, önce kendinde başlar.
''',
    reversedMeaning: '''
Ters Aşıklar, uyumsuzluk, değer çatışması veya zor bir seçimi gösterir.

Belki kalbin bir yöne, aklın başka yöne çekiyor. Belki de seçim yapmaktan kaçınıyorsun.

İlişkilerde sorunlar, aldatma veya güven eksikliği olabilir. Ama asıl soru: Kendine sadık mısın?
''',
    symbolism: '''
• Melek Raphael: İlahi rehberlik, şifa
• Havva ve Adem: Dişil ve eril, bilinçaltı ve bilinç
• Bilgi ağacı (yılanla): Ayartma, deneyim
• Yaşam ağacı (alevlerle): Tutku, yaşam gücü
• Güneş: Bilinç, aydınlanma
• Dağ: Başarılacak zirve
• Çıplaklık: Masumiyet, savunmasızlık
''',
    spiritualLesson: '''
Ruhsal ders: Seçim, özgürlüktür.

Her seçim bir kapıyı açar, diğerini kapar. Korku değil, sevgi ile seç.

Gerçek birleşim, iki yarımın bir bütün oluşturması değil - iki bütünün birlikte dans etmesidir.
''',
    loveReading: '''
Aşkta önemli bir dönem. Yeni bir ilişki, derin bir bağlantı veya mevcut ilişkide yeni bir seviye.

Kalbin seçimine güven. Ama sadece tutkuyla değil - değerlerinizin uyumuna da bak.

Ruh eşi enerjisi. Ama ruh eşi, mükemmel değil - seni büyüten kişidir.
''',
    careerReading: '''
Kariyerde önemli bir seçim. Değerlerine uygun mu?

Ortaklıklar, işbirlikleri, birleşmeler için uygun zaman.

Kalbin seni nereye çekiyor? Bazen "mantıksız" görünen kariyer seçimleri en doğru olanlardır.
''',
    advice:
        'Kalbinle seç. Ama aklını da dinle. Gerçek seçim, ikisinin uyumudur.',
    meditation: '''
Gözlerini kapat. Karşında bir ayna hayal et. Aynada senin "diğer yarın" var - senin zıt kutbun.

Ona yaklaş. Dokunduğunuzda, iki enerji birleşiyor. İkisi de kaybolmuyor - dönüşüyorlar.

Mantra: "Kendimle birleşiyorum. İçimdeki tüm parçalar uyum içinde."
''',
    viralQuote:
        '"Aşık ol: Kendinle, hayatla, evrenle. Gerçek aşk içeride başlar."',
    shadowAspect:
        'Bağımlılık, yanlış seçimler, değerlerden kopma, kararsızlık.',
  ),

  7: const MajorArcanaContent(
    number: 7,
    name: 'The Chariot',
    nameTr: 'Savaş Arabası',
    archetype: 'Zafer Savaşçısı',
    element: 'Su',
    planet: 'Yengeç',
    hebrewLetter: 'Cheth (ח)',
    keywords: 'Zafer, irade gücü, kararlılık, kontrol, ilerleme, fetih',
    shortMeaning: 'Zıt güçleri yöneten irade. Engelleriaşarak ilerlemek.',
    deepMeaning: '''
Savaş Arabası, içsel ve dışsal zaferin sembolüdür. Siyah ve beyaz sfenksler, zıt güçleri temsil eder - ve savaşçı onları yönlendirir.

Kabala'da Cheth, "çit/sınır" anlamına gelir. Savaş Arabası, disiplin ve irade ile sınırları aşmaktır.

Bu kart, hareket halinde meditasyondur. Savaşçının elinde dizgin yok - o sfenksleri zihinle yönetiyor. Gerçek kontrol, zorlamak değil - yönlendirmektir.

Jung'a göre bu, ego'nun bilinçdışı güçler üzerinde ustalaşmasıdır. Ama dikkat: Bastırmak değil, entegre etmek gerekir.
''',
    reversedMeaning: '''
Ters Savaş Arabası, kontrolü kaybetmeyi veya yanlış yönde ilerlemeyi gösterir.

Belki çok zorluyor, çok savaşıyorsun - ve tükeniyorsun. Belki de kontrolü başkalarına bırakmışsın.

Engellerle savaşmak yerine onlardan kaçıyor olabilirsin. Ya da yanlış savaşları veriyorsun.
''',
    symbolism: '''
• Siyah ve beyaz sfenksler: Zıt güçler, polarite
• Yıldızlı baldaken: Kozmik koruma
• Hilaller: Ay enerjisi, döngüler
• Zırh: Koruma, hazırlık
• Kanat sembolleri: Ruhani yükseliş
• Şehir surları (arkada): Fethedilen kaleler
• Dizginsiz kontrol: Zihinsel güç
''',
    spiritualLesson: '''
Ruhsal ders: Zafer, fethetmek değil - ustalaşmaktır.

Düşmanın dışarıda değil - içeride. Korku, şüphe, tembellik... Bunlarla savaş.

Ama "savaş" zorlamak değil. Akışla birlikte, ama yönlendirerek ilerle.
''',
    loveReading: '''
Aşkta ilerleme ve fetih zamanı. İstediğin ilişki için harekete geç.

Ama dikkat: Aşk savaş alanı değil. Fethetmeye değil, birleşmeye odaklan.

Uzun mesafe ilişkileri, seyahat sırasında tanışmalar olabilir.
''',
    careerReading: '''
Kariyerde zafer yakın. Projeler tamamlanıyor, hedefler gerçekleşiyor.

Rekabette öne geç. Ama dürüst oyna - hile kısa vadeli zafer, uzun vadeli kayıptır.

Satış, liderlik, girişimcilik, spor alanları ön planda.
''',
    advice:
        'Yoluna odaklan. Engeller olacak - onları yönet, onların seni yönetmesine izin verme.',
    meditation: '''
Gözlerini kapat. Bir savaş arabasında duruyorsun. Önünde iki güç var - biri seni sola, biri sağa çekiyor.

Dizginleri bırak. Zihinle yönlendir. İkisi de senin gücün - birlikte ilerle.

Mantra: "Zıtlıkları yönetiyorum. İradem beni hedefe taşıyor."
''',
    viralQuote:
        '"Savaşçı ol: Zorluklara değil, kendinle savaş. Gerçek zafer, iç barıştır."',
    shadowAspect:
        'Saldırganlık, aşırı kontrol, başkalarını ezme, duygusuz ilerleme.',
  ),

  8: const MajorArcanaContent(
    number: 8,
    name: 'Strength',
    nameTr: 'Güç',
    archetype: 'İçsel Güç',
    element: 'Ateş',
    planet: 'Aslan',
    hebrewLetter: 'Teth (ט)',
    keywords: 'İçsel güç, cesaret, şefkat, sabır, yumuşak güç',
    shortMeaning: 'Aslanı evcilleştiren şefkat. Gerçek güç, içsel güçtür.',
    deepMeaning: '''
Güç kartı, Savaş Arabası'nın zıttıdır. Orada zorla kontrol vardı - burada şefkatle dönüştürme.

Kabala'da Teth, "yılan" anlamına gelir - kundalini enerjisi, hayat gücü. Kadın, bu vahşi enerjiyi nazikçe yönlendiriyor.

Başının üzerindeki sonsuzluk sembolü, Büyücü ile bağlantıyı gösterir. Ama Büyücü dışsal güç kullanır - Güç, içsel gücü.

Bu, dişil gücün arketipidir: Kırmak değil, dönüştürmek. Bastırmak değil, entegre etmek.
''',
    reversedMeaning: '''
Ters Güç, özgüven eksikliği veya gücün kötüye kullanımını gösterir.

Belki içindeki "aslan"dan korkuyorsun - duygularını, tutkularını bastırıyorsun. Belki de aslanı serbest bırakıp kontrolü kaybediyorsun.

Kendine şefkat göstermekte zorlanıyor olabilirsin. Ya da başkalarına karşı çok sert.
''',
    symbolism: '''
• Sonsuzluk sembolü: Sınırsız iç güç
• Aslan: İçsel vahşi doğa, ego, tutku
• Beyaz elbise: Saflık, masumiyet
• Çiçek çelengi: Doğayla uyum
• Dağlar: Aşılacak zorluklar
• Nazik dokunuş: Şefkatle dönüştürme
• Sarı (aslanın rengi): Güneş enerjisi
''',
    spiritualLesson: '''
Ruhsal ders: En büyük güç, kendini yenmektir.

Öfke, korku, kıskançlık - bunlar senin "aslanların". Onları öldürme, evcilleştir. Onlar da senin gücün.

Şefkat zayıflık değil - en yüksek güçtür.
''',
    loveReading: '''
Aşkta sabır ve anlayış gerekiyor. Zorlamak yerine nazikçe yaklaş.

Partnerinizin "vahşi" yanlarını kabul edin - ve kendi vahşi yanlarınızı da.

Tutkulu ama kontrollü bir aşk. Ateşi yönetmek, söndürmek değil.
''',
    careerReading: '''
Kariyerde yumuşak güç kullan. Zorlamak yerine ikna et, etkilemek yerine ilham ver.

Zorlu durumlarla sabırla başa çık. Tepki verme - cevap ver.

Psikoloji, terapi, hayvanlarla çalışma, liderlik koçluğu alanları uygun.
''',
    advice: 'Güç gösterisi yapma. Gerçek güç, gösterilmez - hissedilir.',
    meditation: '''
Gözlerini kapat. Önünde bir aslan oturuyor. Gözleri sana bakıyor - meydan okuyan, ama aynı zamanda bekleyen.

Korkmadan yaklaş. Elini nazikçe kafasına koy. Aslan gözlerini kapatıyor, sakinleşiyor.

Mantra: "İçimdeki vahşi güçle barış içindeyim. Şefkatim benim gücüm."
''',
    viralQuote:
        '"Güçlü ol: Kırma, dönüştür. Gerçek güç, aslanı sevgiyle evcilleştirmektir."',
    shadowAspect:
        'Bastırılmış öfke, pasif-agresif davranış, aşırı kontrol, güçsüzlük hissi.',
  ),

  9: const MajorArcanaContent(
    number: 9,
    name: 'The Hermit',
    nameTr: 'Ermiş',
    archetype: 'Bilge Arayıcı',
    element: 'Toprak',
    planet: 'Başak',
    hebrewLetter: 'Yod (י)',
    keywords: 'İçe dönüş, yalnızlık, arayış, bilgelik, rehberlik, inziva',
    shortMeaning:
        'Karanlıkta ışık tutan bilge. İçsel arayış ve yalnız yolculuk.',
    deepMeaning: '''
Ermiş, dış dünyadan çekilerek iç dünyayı keşfeden bilgedir. Elindeki fener, aradığı gerçeği simgeler - ve bu gerçek içeridedir.

Kabala'da Yod, en küçük ve en kutsal harftir - ilahi kıvılcım. Ermiş, bu kıvılcımı arayan ve taşıyan kişidir.

Dağın zirvesinde yalnız durur. Yolculuk zorlu olmuştur - ama zirvedeki bakış açısı buna değer.

Bu kart, "bil kendini" ilkesinin somutlaşmasıdır. Başkalarının cevaplarını değil, kendi gerçeğini ara.
''',
    reversedMeaning: '''
Ters Ermiş, aşırı izolasyonu veya içsel arayıştan kaçışı gösterir.

Belki yalnızlık seni hasta ediyor - ama insanlarla da bağlanamıyorsun. Belki de her şeyden kaçarak "arayış" yapıyorsun.

İçe dönmek yerine kapanma. Bilgelik aramak yerine dünyadan kopma.
''',
    symbolism: '''
• Fener: İçsel ışık, bilgelik
• Yıldız (fenerde): Gerçeğin ışığı
• Gri pelerin: Alçakgönüllülük, görünmezlik
• Asa: Bilgeliğin desteği
• Dağ zirvesi: Ruhani yükseliş
• Kar: Saflık, berraklık
• Yalnızlık: İçsel yolculuk
''',
    spiritualLesson: '''
Ruhsal ders: Cevaplar içeride.

Başkalarına sormayı bırak. Kitaplarda aramayı bırak. Sessizlikte otur ve dinle.

Yalnızlık bir ceza değil - bir hediyedir. Kendinle baş başa kalabilmek, en büyük özgürlüktür.
''',
    loveReading: '''
Aşkta bir mola zamanı. Yalnız kalmak veya ilişkiyi sorgulamak gerekebilir.

Bu, kopuş değil - derinleşme. Kendini tanımadan başkasıyla nasıl birleşirsin?

Yaşça büyük, bilge bir mentor/partner olabilir.
''',
    careerReading: '''
Kariyerde araştırma, uzmanlaşma ve derinleşme zamanı.

Kalabalıktan uzaklaş. Niş alanına odaklan. Herkesin yaptığını yapma.

Danışmanlık, araştırma, yazarlık, ruhani meslekler için uygun.
''',
    advice:
        'Geri çekil. Dinle. Işığını ara - ve bulduğunda başkalarına da göster.',
    meditation: '''
Gözlerini kapat. Karanlık bir dağ yolunda yürüyorsun. Elindeki fener tek ışık kaynağı.

Her adımda sadece önündeki birkaç metreyi görebiliyorsun. Ama bu yeterli. Bir adım daha at.

Mantra: "Karanlıkta bile ışığımı taşıyorum. Yolum bana gösteriliyor."
''',
    viralQuote:
        '"Ermiş ol: Çekil, sessizleş, derinleş. Işık başkalarında değil - içinde."',
    shadowAspect:
        'Aşırı izolasyon, yabancılaşma, üstünlük kompleksi, sosyal kopukluk.',
  ),

  10: const MajorArcanaContent(
    number: 10,
    name: 'Wheel of Fortune',
    nameTr: 'Kader Çarkı',
    archetype: 'Kozmik Döngü',
    element: 'Ateş',
    planet: 'Jüpiter',
    hebrewLetter: 'Kaph (כ)',
    keywords: 'Kader, döngüler, değişim, şans, karma, dönüm noktası',
    shortMeaning:
        'Değişmeyen tek şey, değişimdir. Kaderin dönüşü ve kozmik döngüler.',
    deepMeaning: '''
Kader Çarkı, evrenin döngüsel doğasını temsil eder. Her şey döner - iyi günler, kötü günler, mevsimler, yaşamlar.

Kabala'da Kaph, "avuç içi" anlamına gelir - alıcılık, kaderi kabul etme. Ama çark sadece rastgele değil - karma yasalarına göre döner.

Çarkın etrafında dört sabit figür (boğa, aslan, kartal, melek) dört elementi ve dört evangelisti temsil eder. Onlar değişmez - değişen, çarkın üzerindekilerdir.

Sfenks (üstte) bilgeliği, Anubis (solda) düşüşü, yılan (sağda) yükselişi simgeler. Sen hangisisin?
''',
    reversedMeaning: '''
Ters Çark, değişime direnmeyi veya kötü şansı gösterir.

Belki döngünün dibindesin ve yukarı çıkış umutsuz görünüyor. Belki de değişime direniyor, geçmişe tutunuyorsun.

Karma borçları ödeme zamanı olabilir. Geçmişteki eylemlerinin sonuçları.
''',
    symbolism: '''
• Çark: Döngüler, değişim
• TARO/ROTA/ORAT: Tarot, tora, rota (yol)
• Sfenks: Bilgelik, değişmeyen
• Anubis: Düşüş, karanlık dönem
• Yılan: Yükseliş, dönüşüm
• Dört figür: Dört element, stabilite
• Bulutlar: Gizemli doğa
''',
    spiritualLesson: '''
Ruhsal ders: Değişime direnmek acı çekmektir.

Çark dönecek - ister iste ister isteme. Akışla birlikte hareket et.

Ama pasif de kalma. Karma, eylemlerinin sonucu. İyi tohumlar ek.
''',
    loveReading: '''
Aşkta beklenmedik değişimler. Yeni tanışmalar, sürpriz gelişmeler, kader anları.

"Doğru zamanda doğru yerde" enerjisi. Ama unutma: Şans, hazırlıklı olanı bulur.

Geçmiş ilişkilerden gelen karmik bağlantılar olabilir.
''',
    careerReading: '''
Kariyerde döngü değişiyor. Şanslı fırsatlar veya beklenmedik dönüşler.

Risk almak için uygun zaman - ama hesaplanmış risk. Çark senin lehine dönüyor.

Kumar, finans, yatırım, fırsatçılık gerektiren alanlar.
''',
    advice: 'Değişime hazır ol. Çark dönerken merkezde kal - orada huzur var.',
    meditation: '''
Gözlerini kapat. Devasa bir çarkın merkezinde duruyorsun. Çark dönüyor - ama sen sabitsin.

Etrafında insanlar yükseliyor, düşüyor. Sen izliyorsun - dahil olmadan, ama tamamen farkında.

Mantra: "Değişimin içinde değişmeyenim. Merkezde huzur buluyorum."
''',
    viralQuote:
        '"Çark döner: Bugünkü zirve, yarının vadisi olabilir. Değişime dans et."',
    shadowAspect: 'Kontrolsüzlük, kadercilik, pasiflik, şanssızlık döngüsü.',
  ),

  11: const MajorArcanaContent(
    number: 11,
    name: 'Justice',
    nameTr: 'Adalet',
    archetype: 'Kozmik Yargıç',
    element: 'Hava',
    planet: 'Terazi',
    hebrewLetter: 'Lamed (ל)',
    keywords: 'Adalet, denge, doğruluk, hukuk, karma, karar',
    shortMeaning:
        'Evrensel denge yasası. Eylemlerimizin sonuçlarıyla yüzleşme.',
    deepMeaning: '''
Adalet, kozmik dengenin bekçisidir. Elindeki terazi, tüm eylemlerin tartıldığını gösterir - hiçbir şey kaybolmaz.

Kabala'da Lamed, "öğretmen" anlamına gelir. Adalet bize karma yasasını öğretir: Her eylem bir tepki yaratır.

Kılıcı keskindir - gerçeği yanılgıdan, doğruyu yanlıştan ayırır. Gözleri bağlı değil (bazı versiyonlarda aksine) - o tarafsız değil, hakikati görür.

Bu kart, "herkese hak ettiğini" vaat eder. Bu bir tehdit mi, yoksa teselli mi? Eylemlerine bağlı.
''',
    reversedMeaning: '''
Ters Adalet, adaletsizlik, dengesizlik veya sorumluluğu reddetmeyi gösterir.

Belki haksızlığa uğradığını hissediyorsun. Belki de yaptıklarının sonuçlarını kabul etmiyorsun.

Yasal sorunlar, hukuki anlaşmazlıklar olabilir. Ya da kendi içinde, "ne yaptım?" sorusuyla yüzleşme zamanı.
''',
    symbolism: '''
• Terazi: Denge, tartı, değerlendirme
• Kılıç: Keskin karar, ayrımcılık
• Taç: Otorite, hakimiyet
• Kırmızı pelerin: Eylem, tutku
• İki sütun: Dualite, denge
• Mor perde: Gizem, içsel bilgi
• Kare taht: Sağlamlık, düzen
''',
    spiritualLesson: '''
Ruhsal ders: Her eylem bir enerji yaratır.

Karma karmaşık bir ceza sistemi değil - basit bir fizik yasası. Ektiğin, biçersin.

Adil ol - başkalarına ve kendine. Kendini yargılamak da, affetmek de adaletin parçası.
''',
    loveReading: '''
Aşkta denge ve karşılıklılık gerekiyor. Tek taraflı fedakarlık sürdürülebilir değil.

İlişkide adalet var mı? İkiniz de eşit veriyor ve alıyor musunuz?

Geçmiş ilişkilerden gelen karmik dersler tamamlanıyor olabilir.
''',
    careerReading: '''
Kariyerde adil sonuçlar. Çalışmanın karşılığını alıyorsun - iyi veya kötü.

Yasal konular, sözleşmeler, anlaşmalar için dikkatli ol. Her şeyi yazılı yap.

Hukuk, yargı, hakemlik, denetim alanları ön planda.
''',
    advice: 'Adil ol. Kararlarının arkasında dur. Sonuçları kabul et.',
    meditation: '''
Gözlerini kapat. Bir terazinin önünde duruyorsun. Bir kefede eylemlerin, diğerinde sonuçları.

Terazi dengeleniyor mu? Değilse, hangi eylemler eksik veya fazla?

Mantra: "Eylemlerimin sorumluluğunu alıyorum. Adalet benimle başlıyor."
''',
    viralQuote: '"Adalet zamanla dengelenir - ektiğini biçersin."',
    shadowAspect:
        'Katı yargılama, intikam, sorumsuzluk, suçlama, kendini kandırma.',
  ),

  12: const MajorArcanaContent(
    number: 12,
    name: 'The Hanged Man',
    nameTr: 'Asılan Adam',
    archetype: 'Kutsal Kurban',
    element: 'Su',
    planet: 'Neptün',
    hebrewLetter: 'Mem (מ)',
    keywords:
        'Teslimiyet, bekleyiş, fedakarlık, perspektif değişimi, aydınlanma',
    shortMeaning:
        'Baş aşağı bakınca dünya farklı görünür. Teslimiyet ve yeni perspektif.',
    deepMeaning: '''
Asılan Adam, paradoksun kartıdır. Bağlı ama özgür, düşmüş ama yükselmiş, acı çekiyor ama huzurlu.

Kabala'da Mem, "su" anlamına gelir. Asılan Adam, suyun akışına teslim olmaktır - karşı koymak yerine bırakmak.

Odin, bilgelik için kendini Yggdrasil ağacına astı. İsa, insanlık için çarmıhta asıldı. Bu arketip, fedakarlık yoluyla aydınlanmayı temsil eder.

Başının etrafındaki ışık halesi, bu "ceza"nın aslında bir bereket olduğunu gösterir. Acı dönüştürücüdür.
''',
    reversedMeaning: '''
Ters Asılan Adam, gereksiz fedakarlık veya değişime direnci gösterir.

Belki acı çekmeyi kutsallaştırıyorsun - "şehit" olmak hoşuna gidiyor. Belki de gerekli fedakarlığı yapmaktan kaçınıyorsun.

Takılı kalmışsın - ama bağların çoğu senin ellerin. Bırakmak sana kalmış.
''',
    symbolism: '''
• Baş aşağı pozisyon: Perspektif değişimi
• T-şekilli ağaç: Tau haçı, kurban
• Işık halesi: Aydınlanma, kutsallık
• Mavi giysiler: Bilgelik, huzur
• Kırmızı pantolon: Maddi dünyayla bağ
• Bağlı ayak: İstemli teslimiyet
• Serbest eller: İç özgürlük
''',
    spiritualLesson: '''
Ruhsal ders: Bazen bırakmak, savaşmaktan güçlüdür.

Kontrol ihtiyacını bırak. Evrenin planına güven. Acele etme.

Fedakarlık, kaybetmek değil - dönüştürmektir. Bir şeyi bırakmak, başka bir şeye yer açar.
''',
    loveReading: '''
Aşkta bekleyiş dönemi. Zorlamak yerine bekle, akışa bırak.

Belki ilişki için bir şeyden vazgeçmen gerekiyor. Ya da ilişkinin sana ne öğrettiğini görmelisin.

"Askıda" bir ilişki olabilir - netleşmesi zaman alacak.
''',
    careerReading: '''
Kariyerde mola zamanı. Durum netleşene kadar bekle.

Zorlamak işe yaramıyor. Geri adım at, perspektif kazan, sonra hareket et.

Sabbatical, kariyer değişikliği düşünme, araştırma dönemi.
''',
    advice:
        'Teslim ol. Bekle. Perspektifini değiştir. Bazen hiçbir şey yapmamak, en doğru eylemdir.',
    meditation: '''
Gözlerini kapat. Kendini baş aşağı asılmış hayal et. Başta rahatsız, sonra... huzur.

Dünya ters görünüyor. Ama belki dünya zaten tersken, sen doğru yöne bakıyorsun.

Mantra: "Teslim oluyorum. Evrenin zamanlamasına güveniyorum."
''',
    viralQuote:
        '"Asıl: Teslim ol, bırak, bekle. Bazen en büyük güç, hiçbir şey yapmamaktır."',
    shadowAspect:
        'Kurban zihniyeti, pasiflik, şehitlik kompleksi, gerekli eylemi yapmama.',
  ),

  13: const MajorArcanaContent(
    number: 13,
    name: 'Death',
    nameTr: 'Ölüm',
    archetype: 'Dönüşümcü',
    element: 'Su',
    planet: 'Akrep',
    hebrewLetter: 'Nun (נ)',
    keywords: 'Dönüşüm, son, yeni başlangıç, bırakma, metamorfoz',
    shortMeaning: 'Her son, bir başlangıçtır. Ölüm, yeniden doğuşun kapısıdır.',
    deepMeaning: '''
Ölüm kartı, Tarot'un en yanlış anlaşılan kartıdır. Fiziksel ölümü değil, ego ölümünü - dönüşümü - temsil eder.

Kabala'da Nun, "balık" anlamına gelir - derinlerde yaşayan, görünmeyen. Ölüm de öyle: Görünmez ama her yerde.

İskelet zırhlı, beyaz at üzerinde. Bu bir felaket değil, doğal bir süreç. Güneş doğuyor (arkada) - son değil, geçiş.

Tüm Major Arcana içinde en dönüştürücü kart budur. Korkulacak değil, onurlandırılacak bir güç.
''',
    reversedMeaning: '''
Ters Ölüm, değişime direnç veya eksik dönüşümü gösterir.

Ölmesi gereken bir şey hala yaşıyor - belki eski bir alışkanlık, belki ölü bir ilişki, belki eskimiş bir inanç.

Bırakmaktan korkuyorsun. Ama tutmak da bir tür ölüm - canlı canlı gömülmek.
''',
    symbolism: '''
• İskelet: Kalıcı olan, geçici olmayan
• Zırh: Kaçınılmazlık, koruma
• Beyaz at: Saflık, güç
• Bayrak (beyaz gül): Yeniden doğuş, saflık
• Güneş (ufukta): Yeni başlangıç
• Nehir: Akış, geçiş
• Düşen figürler: Eski benlikler
''',
    spiritualLesson: '''
Ruhsal ders: Ölüm, yaşamın parçasıdır.

Her an bir şey ölüyor, bir şey doğuyor. Nefes verdiğinde, bir parçan ölüyor. Nefes aldığında, yenileniyorsun.

Bırakmak yas ister. Yas tutmak, sevginin devamıdır.
''',
    loveReading: '''
Aşkta dönüşüm zamanı. Bir ilişki bitiyor veya tamamen dönüşüyor.

Bu son ağrıtıcı olabilir. Ama ölü bir ilişkiyi canlı tutmak, ikisini de öldürür.

Yeni aşk, ancak eskiyi gerçekten bıraktığında gelebilir.
''',
    careerReading: '''
Kariyerde büyük değişim. Bir dönem kapanıyor, yeni biri başlıyor.

İşten ayrılma, kariyer değişikliği, şirket dönüşümü olabilir.

Korkma. Bir kapı kapanınca başka kapılar açılır.
''',
    advice: 'Bırak. Tutma. Her son, bir başlangıcın tohumunu taşır.',
    meditation: '''
Gözlerini kapat. Eski benliğini karşında hayal et - geçmişin, eski inançların, eskiyen kalıpların.

Ona teşekkür et. Sarıl. Sonra bırak. İzle nasıl dönüşüyor - yok olmuyor, sadece form değiştiriyor.

Mantra: "Ölümden korkmuyorum. Her son, yeni bir başlangıç."
''',
    viralQuote:
        '"Öl ve yeniden doğ: Her gün, her an. Dönüşüm, evrenin nefesidir."',
    shadowAspect: 'Değişim korkusu, saplantılı tutunma, yıkıcılık, nihilizm.',
  ),

  14: const MajorArcanaContent(
    number: 14,
    name: 'Temperance',
    nameTr: 'Denge / Ölçülülük',
    archetype: 'Simyacı',
    element: 'Ateş',
    planet: 'Yay',
    hebrewLetter: 'Samekh (ס)',
    keywords: 'Denge, uyum, ölçülülük, entegrasyon, sabır, iyileşme',
    shortMeaning: 'Zıtların uyumu. Simya sanatı - kurşunu altına çevirmek.',
    deepMeaning: '''
Denge, Ölüm'den sonra gelen şifa kartıdır. Dönüşüm gerçekleşti - şimdi yeni dengeyi bulmak gerekiyor.

Kabala'da Samekh, "destek" anlamına gelir. Denge, bizi ayakta tutan görünmez yapıdır.

Melek, iki kupa arasında su akıtıyor - bilinç ve bilinçaltı, maddi ve ruhani birleşiyor. Bu simya sürecidir.

Bir ayağı suda, biri karada. İki dünya arasında köprü. Ne tamamen içe dönük, ne tamamen dışa.
''',
    reversedMeaning: '''
Ters Denge, aşırılık, dengesizlik veya uyumsuzluğu gösterir.

Belki hayatın bir alanı diğerlerini ezmiş. Belki de "orta yol"u bulamıyorsun.

Aşırılıklar arasında gidip gelme. Bir gün çok fazla, bir gün hiç yok.
''',
    symbolism: '''
• Melek: Koruyucu, şifacı
• İki kupa: Bilinç/bilinçaltı, madde/ruh
• Akan su: Enerji akışı, simya
• Bir ayak karada, biri suda: İki dünya arası
• Güneş (ufukta): Hedef, aydınlanma
• Iris çiçekleri: Gökkuşağı tanrıçası, köprü
• Taç: Yüksek bilinç
''',
    spiritualLesson: '''
Ruhsal ders: Orta yol, en zor yoldur.

Aşırılıklar kolay - denge zor. "Ne az ne çok" yaşamak ustalık ister.

Sabır, simyanın anahtarıdır. Kurşun bir günde altına dönüşmez.
''',
    loveReading: '''
Aşkta denge ve uyum zamanı. Orta yolu bul.

Ne çok bağımlı, ne çok mesafeli. Ne çok tutkulu, ne çok soğuk.

İlişkide şifa süreci. Eski yaralar iyileşiyor, yeni denge kuruluyor.
''',
    careerReading: '''
Kariyerde iş-yaşam dengesi kritik. Aşırı çalışma da, tembellik de zararlı.

Farklı becerileri, projeleri, ekipleri entegre etme zamanı.

Sağlık, terapi, danışmanlık, arabuluculuk alanları uygun.
''',
    advice:
        'Denge kur. Sabırlı ol. Zıtları birleştir - sonuç ikisinden de büyük olur.',
    meditation: '''
Gözlerini kapat. Ellerinde iki kupa var - birinde ateş, birinde su.

Yavaşça birinden diğerine akıt. Ateş ve su birleşiyor - buhar yükseliyor.

Mantra: "Zıtlıkları birleştiriyorum. Dengede güç buluyorum."
''',
    viralQuote: '"Denge bul: Ne az ne çok. Gerçek ustalık, ortada durmaktır."',
    shadowAspect:
        'Aşırılıklar, bağımlılık, kaçınma, yapay uyum, kendini kandırma.',
  ),

  15: const MajorArcanaContent(
    number: 15,
    name: 'The Devil',
    nameTr: 'Şeytan',
    archetype: 'Gölge',
    element: 'Toprak',
    planet: 'Oğlak',
    hebrewLetter: 'Ayin (ע)',
    keywords: 'Bağımlılık, tutku, gölge, maddecilik, kısıtlama, illüzyon',
    shortMeaning: 'Zincirlerin senin eserin. Gölgeyle yüzleşme, özgürleşme.',
    deepMeaning: '''
Şeytan, Tarot'un en yanlış anlaşılan kartlarından biridir. O dışsal bir güç değil - içsel gölgenin yansımasıdır.

Kabala'da Ayin, "göz" anlamına gelir. Şeytan, görmek istemediğimiz şeyleri görmeye zorlar.

Baphomet figürü, "yukarıda ne varsa aşağıda da o" ilkesinin karanlık yüzüdür. İki çıplak figür zincirlenmiş - ama dikkat: Zincirler gevşek, isteseler çıkabilirler.

Jung'un "gölge" kavramı burada somutlaşır. Bastırdığımız, reddettiğimiz, kabul etmediğimiz her şey.
''',
    reversedMeaning: '''
Ters Şeytan, gölgeden kurtuluşu veya gölgenin inkârını gösterir.

Belki bağımlılıktan, toksik ilişkiden, zararlı kalıptan kurtuluyorsun. Belki de gölgeni hâlâ görmezden geliyorsun.

Özgürleşme süreci başlamış - ama dikkatli ol, eski kalıplara dönüş kolay.
''',
    symbolism: '''
• Baphomet: Dualite, madde ve ruh
• Zincirlenmiş figürler: İstemli esaret
• Gevşek zincirler: Çıkış mümkün
• Meşale (aşağı doğru): Yıkıcı tutku
• Boynuzlar ve kuyruklar: Hayvansal doğa
• Siyah arka plan: Bilinçaltı, karanlık
• Ters pentagram: Maddecilik, düşmüş ruh
''',
    spiritualLesson: '''
Ruhsal ders: Gölgeni kabul et.

Reddettiğin, bastırdığın her şey güçlenir. Gölgeyle savaşma - onu tanı, anla, entegre et.

Bağımlılıklar, gölgenin sesini susturmak içindir. Ama ses susmuyor - sadece daha yüksek bağırıyor.
''',
    loveReading: '''
Aşkta bağımlılık, kontrol veya toksik kalıplar söz konusu.

İlişki seni özgürleştiriyor mu, yoksa zincirliyor mu? Dürüst ol.

Tutkulu ama yıkıcı aşk. "Kötü" olduğunu biliyorsun, ama bırakamıyorsun.
''',
    careerReading: '''
Kariyerde maddi bağımlılık veya değer çatışması.

Para için ruhunu satıyor musun? Etik çizgini aştın mı?

Kurumsal tuzaklar, altın kafesler. Güvenlik için özgürlükten vazgeçmek.
''',
    advice:
        'Zincirlerine bak. Kim taktı? Cevap aynada. Çıkış mümkün - ister misin?',
    meditation: '''
Gözlerini kapat. Karanlık bir odadasın. Gölgen karşında duruyor - senden büyük, korkutucu.

Ona doğru yürü. "Seni görüyorum" de. "Sen de benim parçamsın."

Gölge küçülüyor. Artık korkutmuyor - sadece sana bakıyor.

Mantra: "Gölgemi kabul ediyorum. O benim parçam - ama ben değilim."
''',
    viralQuote:
        '"Şeytanın yüzüne bak - kendi gözlerini göreceksin. Zincirleri sen taktın, sen çıkarırsın."',
    shadowAspect:
        'Bağımlılık, kontrol, manipülasyon, maddecilik, kendini kandırma.',
  ),

  16: const MajorArcanaContent(
    number: 16,
    name: 'The Tower',
    nameTr: 'Kule',
    archetype: 'Yıkıcı Aydınlanma',
    element: 'Ateş',
    planet: 'Mars',
    hebrewLetter: 'Peh (פ)',
    keywords: 'Ani değişim, yıkım, vahiy, kriz, çöküş, özgürleşme',
    shortMeaning:
        'Yıldırım çarptığında gerçek ortaya çıkar. Yıkımdan doğan aydınlanma.',
    deepMeaning: '''
Kule, kaçınılmaz yıkımın kartıdır. Sahte temeller üzerine kurulu yapılar yıkılmalıdır - gerçek ortaya çıksın diye.

Kabala'da Peh, "ağız" anlamına gelir. Kule, evrenin sana söylediği acı gerçektir - duymak istemesen de.

Yıldırım, ilahi müdahaledir. Taç düşüyor - ego yıkılıyor. İnsanlar düşüyor - ama belki de uçmayı öğreniyorlar.

Bu kart korkutur - ama en özgürleştirici deneyimler genellikle en acı verici olanlardır.
''',
    reversedMeaning: '''
Ters Kule, kaçınılan yıkımı veya içsel dönüşümü gösterir.

Belki felaketi kıl payı atlattın. Belki de yıkım içsel - dışarıdan görünmüyor ama içeride her şey değişti.

Değişime direnç, kaçınılmaz olanı ertelemek. Ama ertelenen yıkım daha büyük gelir.
''',
    symbolism: '''
• Kule: Ego, sahte yapılar
• Yıldırım: İlahi müdahale, ani gerçek
• Düşen taç: Ego yıkımı
• Düşen figürler: Eski benlik
• Alevler: Dönüşüm ateşi
• Karanlık gece: Ruhun karanlık gecesi
• 22 alev: 22 Major Arcana, tam döngü
''',
    spiritualLesson: '''
Ruhsal ders: Bazen yıkılması gereken şeyler vardır.

Sahte güvenlik, sahte kimlik, sahte ilişkiler... Yıkım acıtır, ama sahtelikle yaşamak daha çok acıtır.

Krizi fırsata çevir. Enkazdan ne kurtarılabilir?
''',
    loveReading: '''
Aşkta ani son, sarsıcı vahiy veya ilişkinin temelden sarsılması.

Aldatma, yalan veya uzun süredir görmezden gelinen sorunların patlaması.

Acı verici - ama gerçeği bilmek, yalanla yaşamaktan iyidir.
''',
    careerReading: '''
Kariyerde ani değişim. İşten çıkarılma, şirket iflası, sektör değişimi.

Planların çöküyor - ama belki de yanlış planlardı.

Kriz anında sakin kal. Panik kararlar verme.
''',
    advice:
        'Yıkıma direnmeSenin ellerin. Bırak çöksün. Enkazdan yeni bir şey inşa edeceksin.',
    meditation: '''
Gözlerini kapat. Büyük bir kulenin tepesinde duruyorsun. Yıldırım çakıyor, kule sallanıyor.

Korkma. Atla. Düşerken uçmayı öğreniyorsun.

Yere değil, gökyüzüne doğru düşüyorsun.

Mantra: "Yıkımdan korkmuyorum. Her çöküş, yeni bir yükselişin başlangıcı."
''',
    viralQuote:
        '"Yıkılsın: Sahte temeller, sahte hayatlar, sahte benlikler. Gerçek olan, yıkılamaz."',
    shadowAspect:
        'Yıkıcılık, ani öfke patlamaları, kaos yaratma, kendini sabotaj.',
  ),

  17: const MajorArcanaContent(
    number: 17,
    name: 'The Star',
    nameTr: 'Yıldız',
    archetype: 'Umut',
    element: 'Hava',
    planet: 'Kova',
    hebrewLetter: 'Tzaddi (צ)',
    keywords: 'Umut, ilham, huzur, iyileşme, maneviyat, bereket',
    shortMeaning: 'Fırtınadan sonra gelen sükunet. Evrensel umut ve şifa.',
    deepMeaning: '''
Yıldız, Kule'nin yıkımından sonra gelen şifa ve umuttur. En karanlık geceden sonra, yıldızlar görünür.

Kabala'da Tzaddi, "balık oltası" anlamına gelir - derinliklerden bilgelik çeken. Yıldız, kozmik bilgeliğin kaynağıdır.

Çıplak kadın iki testiden su döker - bilinç ve bilinçaltını besler. Büyük yıldız (Sirius?) ve yedi küçük yıldız, kozmik rehberliği simgeler.

Bu kart, "her şey yoluna girecek" vaadi değil - "her şey olduğu gibi mükemmel" farkındalığıdır.
''',
    reversedMeaning: '''
Ters Yıldız, umut kaybı, inanç krizi veya gerçeklikten kopuşu gösterir.

Belki karanlıkta kaybolmuş hissediyorsun - yıldızları göremiyorsun. Belki de aşırı idealizm seni gerçeklikten kopardı.

Şifa süreci sekteye uğramış olabilir. Sabır gerekiyor.
''',
    symbolism: '''
• Büyük yıldız: Kozmik rehberlik
• Yedi küçük yıldız: Çakralar, gezegenler
• Çıplak kadın: Savunmasızlık, saflık
• İki testi: Bilinç/bilinçaltı
• Akan su: Şifa, bereket
• Göl: Bilinçaltı, sezgi
• Kuş (ağaçta): Ruh, özgürlük
''',
    spiritualLesson: '''
Ruhsal ders: En karanlık gecede bile yıldızlar parlar.

Umut, koşullara bağlı değildir. Dış dünya karanlık olsa bile, içsel ışık sönmez.

Şifa zaman alır. Sabırlı ol - ama umudunu kaybetme.
''',
    loveReading: '''
Aşkta iyileşme ve yenilenme. Geçmiş yaralar şifa buluyor.

Yeni bir umut, yeni bir ilham. İdealist ama ayakları yere basan bir aşk.

Ruh eşi enerjisi - ama önce kendi ışığını bul.
''',
    careerReading: '''
Kariyerde yeni umutlar, ilham veren projeler, yaratıcı fikirler.

Zor dönemden sonra iyileşme. Yeni başlangıçlar için uygun zaman.

Sanat, müzik, yardım işleri, çevre koruma alanları ön planda.
''',
    advice:
        'Umudunu koru. Işığını paylaş. Şifa için sabırlı ol - ama şifanın geldiğine inan.',
    meditation: '''
Gözlerini kapat. Yıldızlı bir gecede, berrak bir gölün kenarında oturuyorsun.

Gökyüzüne bak. Yıldızlar seninle konuşuyor - her biri bir mesaj.

Mantra: "Evrenden rehberlik alıyorum. Işık her zaman benimle."
''',
    viralQuote:
        '"Yıldız ol: Karanlıkta parla, umut saç, şifa ver. En karanlık gecede bile, ışık var."',
    shadowAspect: 'Aşırı idealizm, gerçeklikten kopuş, pasif umut, hayalcilik.',
  ),

  18: const MajorArcanaContent(
    number: 18,
    name: 'The Moon',
    nameTr: 'Ay',
    archetype: 'Bilinçaltının Derinlikleri',
    element: 'Su',
    planet: 'Balık',
    hebrewLetter: 'Qoph (ק)',
    keywords: 'Illüzyon, bilinçaltı, korkular, gölgeler, sezgi, rüyalar',
    shortMeaning:
        'Ay ışığında her şey farklı görünür. Bilinçaltının karanlık suları.',
    deepMeaning: '''
Ay, bilinçaltının karanlık ve gizemli dünyasını temsil eder. Güneş gerçeği gösterir - Ay, gerçeğin gölgelerini.

Kabala'da Qoph, "ensee" anlamına gelir - görünmeyeni görmek. Ay, iç gözün kartıdır.

İki kule arasındaki yol, bilinçten bilinçaltına geçiştir. Köpek ve kurt, evcil ve vahşi doğamızı simgeler. Yengeç, derinlerden yüzeye çıkan ilkel güçlerdir.

Bu kart, netlik değil - belirsizlik verir. Ve bazen belirsizlik, kesinliğin dayattığı kalıplardan özgürleştirir.
''',
    reversedMeaning: '''
Ters Ay, korkularla yüzleşmeyi veya illüzyonların dağılmasını gösterir.

Belki karanlıktan korkuyordun - ama artık görebiliyorsun. Belki de korkular gerçeği gizliyor.

Bilinçaltı mesajlar netleşiyor. Rüyalar anlaşılır hale geliyor.
''',
    symbolism: '''
• Ay: Bilinçaltı, döngüler, dişil
• İki kule: Geçiş kapıları
• Köpek ve kurt: Evcil/vahşi doğa
• Yengeç: Bilinçaltından çıkan
• Yol: Bilinçaltı yolculuğu
• Su: Duygular, sezgi
• Ay'ın yüzü: Çift doğa, ışık/gölge
''',
    spiritualLesson: '''
Ruhsal ders: Karanlıktan geçmeden aydınlığa ulaşılmaz.

Korkularınla yüzleş. Gölgelerini tanı. Bilinçaltı düşman değil - sadece tanınmamış dost.

Rüyalar, sezgiler, "anlamsız" hisler... Hepsini dinle. Mesajlar şifreli ama gerçek.
''',
    loveReading: '''
Aşkta belirsizlik, gizli duygular veya illüzyonlar var.

Gerçeği görüyor musun, yoksa görmek istediğini mi? Partner hakkında bilmediğin şeyler olabilir.

Sezgilerine güven - ama paranoya ile sezgiyi ayırt et.
''',
    careerReading: '''
Kariyerde belirsizlik. Net görüntü yok - bekle.

Yaratıcı işler, sanat, psikoloji, gizem alanları için uygun.

Önemli kararlar için bu dönem uygun değil - daha fazla bilgi gerekiyor.
''',
    advice:
        'Karanlıkta yürü. Gözlerin alışacak. Sezgilerine güven - ama doğrula.',
    meditation: '''
Gözlerini kapat. Ay ışığında bir orman yolundasın. Gölgeler hareket ediyor - ya da öyle mi görünüyor?

Korkma. Yürümeye devam et. Gölgeler sadece gölge - gerçek değil.

Mantra: "Karanlıkta bile görüyorum. Sezgilerim beni yönlendiriyor."
''',
    viralQuote:
        '"Ay\'a bak: Tam değil, eksik - ama güzel. Karanlık da ışığın parçası."',
    shadowAspect: 'Korku, paranoya, illüzyon, aldatma, bilinçaltı bastırma.',
  ),

  19: const MajorArcanaContent(
    number: 19,
    name: 'The Sun',
    nameTr: 'Güneş',
    archetype: 'Neşe ve Aydınlanma',
    element: 'Ateş',
    planet: 'Güneş',
    hebrewLetter: 'Resh (ר)',
    keywords: 'Neşe, başarı, canlılık, aydınlanma, pozitiflik, berraklık',
    shortMeaning: 'Güneş her şeyi aydınlatır. Neşe, başarı ve çocuksu sevinç.',
    deepMeaning: '''
Güneş, Tarot'un en pozitif kartıdır. Ay'ın belirsizliğinden sonra, güneş her şeyi netleştirir.

Kabala'da Resh, "baş" anlamına gelir. Güneş, bilinçli farkındalığın doruk noktasıdır.

Çıplak çocuk beyaz at üzerinde - masumiyet ve zafer bir arada. Güneş çiçekleri (ayçiçeği) her zaman ışığa döner - sen de öyle ol.

Bu kart, dış başarı değil - içsel aydınlanmadır. Ama içsel ışık parlayınca, dış dünya da aydınlanır.
''',
    reversedMeaning: '''
Ters Güneş, geçici karartma veya aşırı iyimserliği gösterir.

Belki güneş bulutların arkasında - ama hâlâ orada. Belki de gerçekçi olmayan beklentilerin hayal kırıklığına yol açtı.

İçsel çocuk yaralı olabilir. Neşe kapasiteni koru.
''',
    symbolism: '''
• Güneş: Bilinç, aydınlanma, yaşam gücü
• Çocuk: Masumiyet, neşe, yeni başlangıç
• Beyaz at: Saflık, zafer
• Ayçiçekleri: Işığa dönme, büyüme
• Duvar: Aşılan engeller
• Kırmızı bayrak: Yaşam gücü, kutlama
• Çıplaklık: Saklanacak bir şey yok
''',
    spiritualLesson: '''
Ruhsal ders: Neşe, ruhun doğal halidir.

Mutluluk dış koşullara bağlı değil - içsel bir karar. İçindeki çocuğu özgür bırak.

Güneş gibi ol: Parla, ısıt, aydınlat - koşulsuz, beklentisiz.
''',
    loveReading: '''
Aşkta mutluluk, uyum ve neşe dönemi.

İlişki çiçek açıyor. Çocuklar konusu olabilir - fiziksel veya yaratıcı projeler.

Partnerle çocuk gibi eğlen. Ciddiyet her şey değil.
''',
    careerReading: '''
Kariyerde başarı ve tanınma. Çabalarının karşılığını alıyorsun.

Yaratıcı projeler parlıyor. Liderlik doğal geliyor.

Çocuklarla ilgili işler, eğlence, sanat, outdoor aktiviteler ön planda.
''',
    advice: 'Parla. Gülümse. Neşeni paylaş. İçindeki çocuğu özgür bırak.',
    meditation: '''
Gözlerini kapat. Sıcak bir güneş yüzünü okşuyor. Çocukken hissettiğin o saf neşeyi hatırla.

O çocuk hâlâ içinde. Onu selamla. Onunla oyna.

Mantra: "Işığım parlıyor. Neşem bulaşıcı. İçimdeki çocuk özgür."
''',
    viralQuote:
        '"Güneş ol: Parla, ısıt, aydınlat. Koşulsuz, karşılıksız - sadece ol."',
    shadowAspect: 'Naiflik, aşırı iyimserlik, kibirli ışık, gölgeyi reddetme.',
  ),

  20: const MajorArcanaContent(
    number: 20,
    name: 'Judgement',
    nameTr: 'Yargı / Diriliş',
    archetype: 'Kozmik Çağrı',
    element: 'Ateş / Su',
    planet: 'Pluto',
    hebrewLetter: 'Shin (ש)',
    keywords: 'Yeniden doğuş, çağrı, yargılama, uyanış, özgürleşme, kefaret',
    shortMeaning:
        'Borazan çalıyor - uyanma zamanı. Yeniden doğuş ve kozmik çağrı.',
    deepMeaning: '''
Yargı, son değil - yeni başlangıçtır. Meleklerin borazanı, ruhları uyandırır.

Kabala'da Shin, "diş" ve "ateş" anlamına gelir - dönüştürücü güç. Yargı, ateşle arınmadır.

Mezarlardan yükselen figürler, geçmiş yaşamlardan, eski benliklerden, bastırılmış potansiyellerden uyanıyorlar.

Bu kart, "kıyamet" değil - "apokalypsis" (Yunanca "perdenin kaldırılması"). Gerçek ortaya çıkıyor.
''',
    reversedMeaning: '''
Ters Yargı, çağrıyı duymamayı veya kendini affetmemeyi gösterir.

Belki içsel ses çağırıyor ama duymuyorsun - ya da duyup görmezden geliyorsun.

Geçmişten kurtulamıyorsun. Kendini affetmek zor geliyor.
''',
    symbolism: '''
• Melek (Gabriel): İlahi çağrı
• Borazan: Uyanış çağrısı
• Kırmızı haç (bayrak): Dönüşüm, kurban
• Yükselen figürler: Yeniden doğuş
• Tabutlar: Eski benlikler
• Dağlar: Aşılan engeller
• Su: Duygusal arınma
''',
    spiritualLesson: '''
Ruhsal ders: Hiçbir zaman geç değil.

Geçmiş ne olursa olsun, şimdi uyanabilirsin. Çağrı her an geliyor - duyuyor musun?

Kendini yargılamak ile kendini afetmek aynı sürecin parçaları. İkisini de yap.
''',
    loveReading: '''
Aşkta yeniden değerlendirme. İlişkiyi sorgula - ama yıkma.

Geçmiş ilişkilerden gelen karmik tamamlanmalar. Eski aşklar geri dönebilir - ama farklı bir perspektifle.

İkinci şanslar mümkün - ama bilinçli seçim gerekiyor.
''',
    careerReading: '''
Kariyerde çağrı geliyor. Gerçek misyonun ne?

Belki yıllardır ertelediğin bir yol. Belki tamamen farklı bir kariyer.

Bu bir "ya hep ya hiç" anı değil - ama dönüm noktası.
''',
    advice: 'Çağrıyı duy. Cevap ver. Geçmişi affet. Yeniden doğ.',
    meditation: '''
Gözlerini kapat. Uzaktan bir borazan sesi duyuyorsun. Seni çağırıyor.

Yerden yüksel. Eski benliğini arkanda bırak. Yeni sen doğuyor.

Mantra: "Çağrıyı duyuyorum. Uyanıyorum. Yeniden doğuyorum."
''',
    viralQuote:
        '"Uyan: Borazan çalıyor. Geçmiş geride, gelecek belirsiz - ama şimdi burada."',
    shadowAspect: 'Kendini yargılama, suçluluk, çağrıdan kaçış, affetmeme.',
  ),

  21: const MajorArcanaContent(
    number: 21,
    name: 'The World',
    nameTr: 'Dünya',
    archetype: 'Tamamlanma',
    element: 'Toprak',
    planet: 'Satürn',
    hebrewLetter: 'Tav (ת)',
    keywords: 'Tamamlanma, bütünlük, başarı, entegrasyon, döngü sonu',
    shortMeaning:
        'Yolculuk tamamlandı. Bütünlük, başarı ve yeni döngünün eşiği.',
    deepMeaning: '''
Dünya, Major Arcana'nın son kartıdır - ama aynı zamanda yeni bir başlangıcın eşiği. Deli'nin yolculuğu tamamlandı.

Kabala'da Tav, son harftir ve "işaret" anlamına gelir. Dünya, ruhsal yolculuğun tamamlanma işaretidir.

Dans eden figür, iki asa ile dengeyi bulmuş - polariteler entegre edilmiş. Çelenk (ouroboros benzeri) döngüselliği simgeler.

Dört köşedeki figürler (boğa, aslan, kartal, melek) sabit burçları ve dört elementi temsil eder - hepsi uyum içinde.
''',
    reversedMeaning: '''
Ters Dünya, eksik tamamlanmayı veya döngüde takılmayı gösterir.

Belki hedefe çok yakınsın ama son adımı atamıyorsun. Belki de başarıya ulaştın ama tatmin olmadın.

Yeni başlangıçtan önce, eski döngünün kapanması gerekiyor.
''',
    symbolism: '''
• Dans eden figür: Tamamlanmış ruh
• İki asa: Entegre polariteler
• Defne çelengi: Zafer, döngüsellik
• Dört figür: Dört element, dört sabit burç
• Mor örtü: Bilgelik, ruhaniyet
• Sonsuzluk şekli: Döngüsel doğa
• Beyaz fon: Sonsuz olasılıklar
''',
    spiritualLesson: '''
Ruhsal ders: Tamamlanma, son değil - yeni başlangıçtır.

Her döngü bir sonrakine hazırlık. Her son, bir başlangıç. Evren spiral - dairesel değil.

Başarı bir varış noktası değil - yolculuğun ta kendisi.
''',
    loveReading: '''
Aşkta tamamlanma ve bütünlük. İlişki yeni bir seviyeye ulaşıyor.

Evlilik, birlikte yaşama, kalıcı taahhütler için uygun.

Kendi içinde bütün hissetmek - bir ilişkiye "ihtiyaç" değil, "seçim" olarak yaklaşmak.
''',
    careerReading: '''
Kariyerde büyük başarı. Uzun vadeli hedefler gerçekleşiyor.

Proje tamamlanıyor. Terfi, ödül, tanınma.

Ama dikkat: Bir döngü bitiyor. Sıradaki ne?
''',
    advice:
        'Kutla. Şükret. Entegre et. Ve hazırlan - yeni bir yolculuk başlamak üzere.',
    meditation: '''
Gözlerini kapat. Evrenin merkezinde duruyorsun. Dört yön seni selamlıyor.

Her şeyle bağlantını hisset. Sen ayrı değilsin - bütünün parçasısın.

Mantra: "Ben bütünüm. Evrenle bir. Ve yolculuk devam ediyor."
''',
    viralQuote:
        '"Dünya senin: Tamamla, kutla, devam et. Her son, yeni bir şarkının girişi."',
    shadowAspect:
        'Tamamlanma yanılgısı, durgunluk, yeni başlangıçtan korku, kibirli memnuniyet.',
  ),
};

/// Tarot için viral paylaşım metinleri
class TarotViralTexts {
  static const List<String> generalTexts = [
    'Kartlar ne söylüyor? 🎴',
    'Bugünün arketipi seninle 🔮',
    'Evren mesaj gönderiyor ✨',
    'Tarot aynası: İçindekini gör 🪞',
    'Kadim semboller, derin içgörüler 🌟',
  ];

  static String getForCard(int number) {
    final card = majorArcanaContents[number];
    if (card == null) return generalTexts[0];
    return card.viralQuote;
  }
}
