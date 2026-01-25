/// Master Numbers - Usta Sayılar Derinlemesine Analizi
/// 11, 22, 33, 44 ve özel sayıların kapsamlı yorumları
library;

// ════════════════════════════════════════════════════════════════════════════
// USTA SAYI 11 - SPİRİTÜEL AYDINLATICI
// ════════════════════════════════════════════════════════════════════════════

class MasterNumber11 {
  static const String name = 'Spiritüel Aydınlatıcı';
  static const String element = 'Hava/Eter';
  static const String planet = 'Neptün/Uranüs';
  static const String color = 'Gümüş, Mor, Beyaz';
  static const String crystal = 'Ay Taşı, Ametist, Labradorit';

  static const String overview = '''
11, spiritüel aydınlanmanın ve sezgisel bilgeliğin sayısıdır. Bu usta sayı,
iki 1'in birleşiminden oluşur ve hem bireyselliği hem de birliği temsil eder.
11'ler, görünür ile görünmez arasında köprü kuran ruhani elçilerdir.

11 taşıyanlar, sıradan insanların göremediğini görür, duyamadığını duyar.
Bu hem bir armağan hem de bir yüktür. Yüksek duyarlılık, doğru yönlendirilmezse
aşırı stres ve anksiyeteye dönüşebilir.

Bu sayının enerjisini taşıyanlar için hayat, sürekli bir öğrenme ve öğretme
deneyimidir. Başkalarına ilham vermek, onları aydınlatmak birincil görevleridir.
''';

  static const Map<String, String> personality = {
    'güçlü_yönler': '''
• Olağanüstü sezgi ve önsezi yeteneği
• Derin empati ve başkalarını anlama kapasitesi
• Spiritüel konularda doğal yatkınlık
• İlham verici konuşma ve yazma yeteneği
• Karizmatik ve etkileyici kişilik
• Vizyoner düşünce yapısı
• Yaratıcılık ve artistik yetenekler
• Başkalarının potansiyelini görme
• Diplomatik ve uzlaştırıcı
• Derin düşünce kapasitesi
''',
    'zorluklar': '''
• Aşırı hassasiyet ve kırılganlık
• Karar vermekte zorluk
• Pratik konularda yetersizlik hissi
• Aşırı idealizm
• Sinir sistemi sorunları
• Anksiyete ve panik atak eğilimi
• Kendini ifade etmekte zorluk
• Yalnızlık hissi ve anlaşılmamışlık
• Eleştiriye aşırı duyarlılık
• Enerji dalgalanmaları
''',
    'gölge_yönler': '''
• Manipülatif olabilme
• Kurban rolüne bürünme
• Fanatizm ve aşırılık
• Gerçeklikten kopma
• Bağımlılık eğilimi
• Megalomani
• Duygusal vampirlik
• Pasif agresiflik
''',
  };

  static const List<String> idealCareers = [
    'Spiritüel danışman/Medyum',
    'Psikolog/Psikoterapist',
    'Yazar/Şair',
    'Müzisyen/Besteci',
    'Sanatçı/Ressam',
    'Film yönetmeni',
    'Motivasyonel konuşmacı',
    'Yoga/Meditasyon öğretmeni',
    'Enerji şifacısı (Reiki vb.)',
    'Din adamı/Ruhani lider',
    'Fotoğrafçı',
    'Aktör/Aktris',
    'Danışman/Koç',
    'Astroloji/Numeroloji uzmanı',
    'Alternatif tıp pratisyeni',
    'Eğitimci/Öğretmen',
    'Sosyal hizmet uzmanı',
    'Çevirmen/Tercüman',
    'Araştırmacı/Akademisyen',
    'Tasarımcı',
  ];

  static const Map<int, String> compatibilityWithNumbers = {
    1: 'Zorlayıcı ama öğretici. 1\'in liderliği 11\'i bastırabilir.',
    2: 'Mükemmel uyum. Duygusal anlayış ve destek.',
    3: 'Yaratıcı ve eğlenceli. İfade özgürlüğü sağlar.',
    4: 'Zor ama dengeleyici. 4 topraklar, 11 ilham verir.',
    5: 'Enerjik ama kaotik. Her iki taraf da özgürlük ister.',
    6: 'Şefkatli ve destekleyici. Aile odaklı uyum.',
    7: 'Spiritüel ikizler. Derin anlayış ve mistik bağ.',
    8: 'Zıtlar çeker. Maddi-manevi dengeleme.',
    9: 'Evrensel sevgi. Ortak insani misyon.',
    11: 'Yoğun ve güçlü. Ya harika ya da felaket.',
    22: 'Vizyoner ortaklık. Büyük projeler mümkün.',
    33: 'Spiritüel mükemmellik. Nadir ve kutsal birliktelik.',
  };

  static const List<String> lifeLessons = [
    'Sezgilerine güvenmeyi öğrenmek',
    'Aşırı duyarlılığı güce dönüştürmek',
    'Pratik ve spiritüel dengesini kurmak',
    'Kendi ışığını karartmadan paylaşmak',
    'Sınırları belirlemeyi öğrenmek',
    'İnançlarını dogmatik olmadan yaşamak',
    'İç huzuru dış onaya bağlamamak',
    'Sabır ve zamanlama bilinci geliştirmek',
  ];

  static const Map<String, String> healthFocus = {
    'sinir_sistemi': 'Stres yönetimi kritik. Meditasyon ve nefes çalışmaları şart.',
    'uyku': 'Kaliteli uyku gerekli. Rüyalar önemli mesajlar taşır.',
    'enerji': 'Enerji dalgalanmaları normal. Dinlenme dönemleri planla.',
    'beslenme': 'Hafif, temiz beslenme. Kafein ve alkole dikkat.',
    'hareket': 'Yoga, tai chi, yüzme gibi akışkan egzersizler.',
    'doğa': 'Doğada zaman geçirmek şarj ediyor.',
  };

  static const List<String> dailyAffirmations = [
    'Sezgilerim beni doğru yola yönlendiriyor.',
    'Hassasiyetim benim süper gücüm.',
    'Işığımı dünyayla paylaşmak için buradayım.',
    'Evrenin mesajlarına açığım.',
    'Kendimi ve sınırlarımı onurlandırıyorum.',
    'İlham aldığım kadar ilham veriyorum.',
    'Her deneyim spiritüel büyümeme katkı sağlıyor.',
    'Görünmez dünyayla bağlantım güçlü ve net.',
    'Korku değil, sevgi ile hareket ediyorum.',
    'Ben bir kanal, evrensel enerji benden akıyor.',
  ];

  static const String livingAs2Warning = '''
11 enerjisini taşımak her zaman kolay değildir. Bazı dönemlerde 11'ler,
enerjilerini 2'ye indirgeyerek yaşar. Bu, dinlenme ve toparlanma dönemidir.

2 olarak yaşarken:
• Daha az vizyoner, daha çok destekleyici rol
• Partnerliklere ve işbirliklerine odaklanma
• Daha az karizmatik, daha çok uyumlu
• Spiritüel yetenekler arka planda

Bu dönemler gerekli ve sağlıklıdır. Ancak çok uzun sürerse,
11'in gerçek potansiyelini bastırmak anlamına gelir.

11'i aktive etmek için:
• Meditasyon pratiğini başlat/artır
• Spiritüel eğitim al
• Sezgisel yetenekleri kullan
• Başkalarına öğret ve ilham ver
• Yaratıcı projeler başlat
''';
}

// ════════════════════════════════════════════════════════════════════════════
// USTA SAYI 22 - ANA İNŞAATÇI
// ════════════════════════════════════════════════════════════════════════════

class MasterNumber22 {
  static const String name = 'Ana İnşaatçı / Master Builder';
  static const String element = 'Toprak/Ateş';
  static const String planet = 'Uranüs/Satürn';
  static const String color = 'Altın, Koyu Yeşil, Bronz';
  static const String crystal = 'Sitrin, Kaplan Gözü, Zümrüt';

  static const String overview = '''
22, tüm usta sayıların en güçlüsüdür. "Master Builder" (Ana İnşaatçı) olarak
adlandırılır çünkü vizyonları somut gerçekliğe dönüştürme gücüne sahiptir.
11'in spiritüel vizyonunu 4'ün pratik becerileriyle birleştirir.

22'ler, dünyayı değiştirecek kalıcı yapılar inşa etmek için doğarlar.
Bu yapılar fiziksel (binalar, şirketler) veya soyut (sistemler, ideolojiler)
olabilir. Önemli olan kalıcı miras bırakmaktır.

Bu sayının potansiyelini tam olarak kullanmak nadir görülür.
Çoğu 22, ya 4 olarak yaşar (pratik ama sınırlı) ya da vizyonlarını
gerçekleştirmeden ömür bitirir. Gerçek 22 manifestasyonu,
hem düşsel hem de pratik olmayı gerektirir.
''';

  static const Map<String, String> personality = {
    'güçlü_yönler': '''
• Büyük vizyonları somutlaştırma yeteneği
• Olağanüstü organizasyon kapasitesi
• Pratik bilgelik ve sağduyu
• Liderlik ve yönetim becerileri
• Disiplin ve kararlılık
• Detaylara dikkat ederken büyük resmi görme
• İnsanları mobilize etme gücü
• Uzun vadeli düşünce
• Sabır ve dayanıklılık
• Diplomatik ve stratejik zeka
''',
    'zorluklar': '''
• Aşırı iş yükü ve tükenmişlik
• Mükemmeliyetçilik
• İş-yaşam dengesizliği
• Başarı baskısı
• Kontrolcü eğilimler
• Sabırsızlık (vizyonun yavaş gerçekleşmesi)
• Duygusal mesafe
• Delege etmekte zorluk
• İnatçılık
• Fiziksel sağlığı ihmal
''',
    'gölge_yönler': '''
• Tiranlık ve diktatörlük
• Başkalarını araç olarak görme
• Megalomani
• Aşırı materyalizm
• Duygusal manipülasyon
• İş bağımlılığı
• Aile ihmal etme
• Güce tapma
''',
  };

  static const List<String> idealCareers = [
    'CEO/Genel Müdür',
    'Mimar',
    'Şehir plancısı',
    'Mühendis (tüm dallar)',
    'Büyük ölçekli proje yöneticisi',
    'Politikacı/Devlet adamı',
    'Uluslararası kuruluş yöneticisi',
    'Vakıf kurucusu',
    'Holding sahibi',
    'Büyük inşaat şirketi sahibi',
    'Finansçı/Yatırım bankacısı',
    'Diplomat',
    'Üniversite rektörü',
    'Hastane/Okul inşaatçısı',
    'Altyapı planlayıcısı',
    'Sistem mühendisi',
    'Organizatör (büyük etkinlikler)',
    'Sürdürülebilirlik uzmanı',
    'Global marka yöneticisi',
    'Sosyal girişimci',
  ];

  static const Map<int, String> compatibilityWithNumbers = {
    1: 'Güçlü işbirliği. 1 başlatır, 22 inşa eder.',
    2: 'Destekleyici. 2 diplomasiyi, 22 vizyonu sağlar.',
    3: 'Yaratıcı enerji. Birlikte büyük projeler mümkün.',
    4: 'Doğal ortaklar. Her ikisi de inşaatçı.',
    5: 'Zor. 5\'in değişkenliği 22\'yi sinirlendirir.',
    6: 'Aile ve iş dengesi. 6 insani boyutu hatırlatır.',
    7: 'Derin bağ. 7 bilgelik, 22 uygulama sağlar.',
    8: 'Güç çifti. Birlikte imparatorluklar kurabilir.',
    9: 'İnsanlık için çalışma. Büyük hayırseverlik.',
    11: 'Vizyoner ortaklık. 11 ilham verir, 22 inşa eder.',
    22: 'Nadir ve güçlü. Ya mükemmel ya da rekabetçi.',
    33: 'Kutsal kombinasyon. İnsanlığa hizmet.',
  };

  static const List<String> lifeLessons = [
    'Vizyonu eyleme dönüştürme cesareti',
    'Sabır - büyük işler zaman alır',
    'İş ve kişisel yaşam dengesi',
    'Başkalarına güvenip delege etme',
    'Mükemmeliyetçiliği bırakma',
    'Duygusal zekayı geliştirme',
    'Güç ile alçakgönüllülük dengesi',
    'Kalıcı miras bırakma sorumluluğu',
  ];

  static const List<String> dailyAffirmations = [
    'Vizyonlarımı gerçeğe dönüştürme gücüm var.',
    'Her gün kalıcı bir şey inşa ediyorum.',
    'Sabırla ve disiplinle hedeflerime ulaşıyorum.',
    'Büyük düşünür, somut adımlar atarım.',
    'Başkalarıyla işbirliği yaparak daha büyük sonuçlar yaratırım.',
    'Dengeli bir yaşam, sürdürülebilir başarının temelidir.',
    'Gücümü insanlığın iyiliği için kullanıyorum.',
    'Her detay önemli, ama büyük resim öncelikli.',
    'Başarılarımı paylaşır, başkalarını yükseltirim.',
    'Maddi ve manevi dünyayı birleştiriyorum.',
  ];
}

// ════════════════════════════════════════════════════════════════════════════
// USTA SAYI 33 - ANA ÖĞRETMEN
// ════════════════════════════════════════════════════════════════════════════

class MasterNumber33 {
  static const String name = 'Ana Öğretmen / Master Teacher';
  static const String element = 'Su/Işık';
  static const String planet = 'Venüs/Neptün';
  static const String color = 'Turkuaz, Pembe, Altın';
  static const String crystal = 'Rozenkuvars, Akuamarin, Turkuaz';

  static const String overview = '''
33, en nadir ve en güçlü usta sayıdır. "Master Teacher" (Ana Öğretmen) olarak
bilinir. 11'in spiritüelliğini ve 22'nin inşa gücünü aşkın sevgiyle birleştirir.
33, koşulsuz sevgi ve şefkat enerjisidir.

Bu sayıyı taşıyanlar, dünyaya şifa getirmek için doğarlar.
Sadece öğretmezler, aynı zamanda örnek olarak yaşarlar.
33'ün enerjisi o kadar güçlüdür ki, çoğu kişi onu taşımakta zorlanır.

Gerçek bir 33, kendi ego'sunu aşmış ve hizmet için yaşayan kişidir.
Tarihteki büyük spiritüel liderler, şifacılar ve azizler
bu sayının enerjisini taşımıştır.

33 olarak yaşamak, sürekli fedakarlık ve hizmet gerektirir.
Bu yol herkes için değildir ama seçenler için en yüce mükafatı sunar:
derin iç huzur ve anlam.
''';

  static const Map<String, String> personality = {
    'güçlü_yönler': '''
• Koşulsuz sevgi kapasitesi
• Olağanüstü şifa yetenekleri
• Derin bilgelik ve anlayış
• Başkalarını yükseltme yeteneği
• Öğretmenlik ve mentorluk becerisi
• Fedakarlık ve özverililiğ
• Duygusal zeka ve empati
• İlham verici varlık
• Sabır ve şefkat
• Spiritüel olgunluk
''',
    'zorluklar': '''
• Aşırı fedakarlık ve tükenmişlik
• Kendi ihtiyaçlarını ihmal
• Başkalarının sorunlarını üstlenme
• Sınır koyamama
• Mükemmeliyetçilik (kendine karşı)
• Hayal kırıklığı (dünya beklentileri karşılamadığında)
• Yalnızlık hissi
• Anlaşılmamışlık
• Fiziksel sağlığı ihmal
• Mali zorluklar (paraya önem vermeme)
''',
    'gölge_yönler': '''
• Martir kompleksi
• Manipülatif fedakarlık
• Spiritüel kibir
• Başkalarını küçümseme
• Pasif agresiflik
• Aşırı idealizm
• Gerçeklikten kopma
• Kontrol (sevgi adı altında)
''',
  };

  static const List<String> idealCareers = [
    'Spiritüel öğretmen/Guru',
    'Şifacı/Enerji terapisti',
    'Hayır kurumu yöneticisi',
    'Sosyal hizmet uzmanı',
    'Psikolog/Danışman',
    'Öğretmen (özellikle özel eğitim)',
    'Hemşire/Doktor (palyatif bakım)',
    'Hospis çalışanı',
    'Çevre aktivisti',
    'Hayvan hakları savunucusu',
    'Barış elçisi/Arabulucu',
    'Yazar (ilham verici)',
    'Sanatçı (şifalı sanat)',
    'Müzik terapisti',
    'Çocuk psikoloğu',
    'Yaşlı bakımı uzmanı',
    'Kriz danışmanı',
    'İntihar önleme uzmanı',
    'Travma terapisti',
    'Topluluk lideri',
  ];

  static const Map<int, String> compatibilityWithNumbers = {
    1: 'Zor. 1\'in ego\'su 33\'ün şefkatini yorabilir.',
    2: 'Uyumlu. Her ikisi de ilişki odaklı.',
    3: 'Yaratıcı ve eğlenceli. Neşeli birliktelik.',
    4: 'Dengeleyici. 4 pratiklik getirir.',
    5: 'Zorlayıcı. 5\'in özgürlük arzusu çatışabilir.',
    6: 'Mükemmel uyum. Her ikisi de şefkatli.',
    7: 'Spiritüel derinlik. Mistik bağ.',
    8: 'Zor. Farklı değerler.',
    9: 'Mükemmel. Evrensel sevgi paylaşımı.',
    11: 'Spiritüel ikizler. Derin anlayış.',
    22: 'Güçlü kombinasyon. 22 inşa eder, 33 şifa verir.',
    33: 'Çok nadir ve yoğun. Kutsal birliktelik.',
  };

  static const List<String> lifeLessons = [
    'Kendine de şefkat göstermek',
    'Sağlıklı sınırlar koymak',
    'Hizmet ile fedakarlık arasındaki farkı anlamak',
    'Maddi dünyada da ayakları yere basmak',
    'Mükemmel olma beklentisini bırakmak',
    'Başkalarının yolculuğuna saygı duymak',
    'Kendi şifa yolculuğuna devam etmek',
    'Neşe ve hafifliği de yaşama katmak',
  ];

  static const List<String> dailyAffirmations = [
    'Sevgi her şeyin cevabıdır.',
    'Kendime gösterdiğim şefkat, başkalarına vereceğimi artırır.',
    'Hizmet ederek anlam buluyorum.',
    'Işığım doğal olarak parlar, zorlamaya gerek yok.',
    'Başkalarının yolculuğuna müdahale etmeden destek olurum.',
    'Sınırlarım beni korur ve hizmetimi sürdürülebilir kılar.',
    'Her an öğretme ve öğrenme fırsatıdır.',
    'Dünya benim varlığımla daha iyi bir yer.',
    'Koşulsuz sevgiyi önce kendime gösteriyorum.',
    'Ben bir şifa kanalıyım, enerji benden akar.',
  ];
}

// ════════════════════════════════════════════════════════════════════════════
// KARMİK BORÇ SAYILARI
// ════════════════════════════════════════════════════════════════════════════

class KarmicDebtNumbers {
  static const Map<int, KarmicDebt> debts = {
    13: KarmicDebt(
      number: 13,
      theme: 'Tembellik ve Sorumsuzluk Karması',
      pastLifePattern: '''
Geçmiş yaşamda kolay yolları seçmek, başkalarının sırtından geçinmek,
sorumluluktan kaçmak. İşleri yarım bırakmak, sözünde durmamak.
Belki de ayrıcalıklı bir konumda doğup, çalışmadan her şeyi elde etmek.
''',
      currentLifeLesson: '''
Bu yaşamda çalışmak, ter dökmek, sabretmek zorunlu.
Hiçbir şey kolayca gelmeyecek. Engeller, gecikmeler, başarısızlıklar
karmanın temizlenmesi için gerekli.

Ders: Disiplin, azim, sorumluluk.
''',
      challenges: [
        'Sürekli engeller ve gecikmeler',
        'İş hayatında zorluklar',
        'Kolayca pes etme eğilimi',
        'Sabırsızlık',
        'Başkalarına bağımlılık',
        'Tamamlanmamış projeler',
      ],
      healingPath: [
        'Her işi sonuna kadar götür',
        'Kısa yollar arama',
        'Fiziksel iş yap (eller ile)',
        'Düzen ve disiplin kur',
        'Söz verdiğinde tut',
        'Başkalarına yardım et (karşılıksız)',
        'Sabır meditasyonu yap',
      ],
      affirmation: 'Çalışmak benim için arınmadır. Her engel beni güçlendirir.',
    ),

    14: KarmicDebt(
      number: 14,
      theme: 'Özgürlük Suistimali Karması',
      pastLifePattern: '''
Geçmiş yaşamda özgürlüğü kötüye kullanmak. Bağımlılıklar, aşırılıklar,
başkalarının özgürlüğünü kısıtlamak. Cinsel suistimal, madde bağımlılığı,
kumar. Sorumluluk almadan yaşamak.
''',
      currentLifeLesson: '''
Bu yaşamda gerçek özgürlüğün ne olduğunu öğrenmek.
Dışsal özgürlük değil, içsel özgürlük. Bağımlılıklardan kurtulma,
kendi kendini yönetme.

Ders: Denge, ılımlılık, öz-disiplin.
''',
      challenges: [
        'Bağımlılık eğilimi (madde, ilişki, yiyecek)',
        'Aşırılıklar',
        'Kararsızlık',
        'Sık iş/ilişki değişikliği',
        'Riskli davranışlar',
        'Taahhüt korkusu',
      ],
      healingPath: [
        'Bağımlılıkları tedavi et',
        'Moderasyon prat yap',
        'Bir şeye bağlı kal (iş, ilişki, proje)',
        'Macera ihtiyacını sağlıklı yollarla karşıla',
        'Meditasyon ve farkındalık geliştir',
        'Fiziksel aktivite ile enerjiyi dengele',
        'Başkalarının özgürlüğüne saygı göster',
      ],
      affirmation: 'Gerçek özgürlük iç huzurdur. Dengede kaldıkça özgürüm.',
    ),

    16: KarmicDebt(
      number: 16,
      theme: 'Ego ve Gurur Karması',
      pastLifePattern: '''
Geçmiş yaşamda ego şişkinliği, gurur, kibir. Başkalarını küçümsemek,
kendini üstün görmek. Belki de güç konumunda olup bunu kötüye kullanmak.
Aşk ve ilişkilerde bencillik.
''',
      currentLifeLesson: '''
Bu yaşamda ego yıkımları yaşanır. Her zirveyi bir düşüş takip eder.
Bu, ego\'nun eritilmesi ve gerçek alçakgönüllülüğün öğrenilmesi içindir.

Ders: Alçakgönüllülük, ego-aşma, spiritüel uyanış.
''',
      challenges: [
        'Ani düşüşler ve kayıplar',
        'İlişki yıkımları',
        'Statü kaybı',
        'Kimlik krizleri',
        'Yalnızlık dönemleri',
        'Ani değişimler',
      ],
      healingPath: [
        'Ego ile özdeşleşmeyi bırak',
        'Alçakgönüllülük pratik et',
        'Başkalarına hizmet et',
        'Spiritüel pratiği derinleştir',
        'Düşüşleri öğrenme fırsatı olarak gör',
        'Gerçek benliğinle bağlan',
        'Affetmeyi öğren (kendini ve başkalarını)',
      ],
      affirmation: 'Her düşüş beni gerçek benliğime yaklaştırıyor. Alçakgönüllülük gücümdür.',
    ),

    19: KarmicDebt(
      number: 19,
      theme: 'Güç Suistimali Karması',
      pastLifePattern: '''
Geçmiş yaşamda güç ve otoriteyi kötüye kullanmak. Tiranlık, baskı,
başkalarını kontrol etme. Belki de kişisel kazanç için başkalarını
kullanmak. Bağımsızlığı bencilce yaşamak.
''',
      currentLifeLesson: '''
Bu yaşamda kendi ayakları üzerinde durmayı öğrenmek.
Ama aynı zamanda başkalarıyla işbirliği yapmayı. Güç ile hizmet dengesini
bulmak.

Ders: Bağımsızlık ile birlik dengesi, güçle hizmet.
''',
      challenges: [
        'Yardım kabul etmekte zorluk',
        'Aşırı bağımsızlık',
        'İzolasyon',
        'Kontrolcülük',
        'Güven sorunları',
        'İlişkilerde zorluklar',
      ],
      healingPath: [
        'Yardım istemeyi öğren',
        'Başkalarına güven',
        'İşbirliği yap',
        'Gücü paylaş',
        'Hizmet odaklı ol',
        'Bireyselliği grup içinde ifade et',
        'Ego ile özdeşleşmeyi bırak',
      ],
      affirmation: 'Güçlü olmak başkalarını yükseltmektir. Bağımsızlığım paylaştıkça artar.',
    ),
  };
}

class KarmicDebt {
  final int number;
  final String theme;
  final String pastLifePattern;
  final String currentLifeLesson;
  final List<String> challenges;
  final List<String> healingPath;
  final String affirmation;

  const KarmicDebt({
    required this.number,
    required this.theme,
    required this.pastLifePattern,
    required this.currentLifeLesson,
    required this.challenges,
    required this.healingPath,
    required this.affirmation,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// KİŞİSEL YIL DÖNGÜSÜ
// ════════════════════════════════════════════════════════════════════════════

class PersonalYearCycles {
  static const Map<int, PersonalYearMeaning> years = {
    1: PersonalYearMeaning(
      number: 1,
      theme: 'Yeni Başlangıçlar',
      overview: '''
Bu yıl 9 yıllık döngünün başlangıcıdır. Yeni projeler, yeni ilişkiler,
yeni yönler için ideal. Cesaret ve inisiyatif yılı. Ne istediğini belirle
ve harekete geç. Liderlik rollerini üstlen.
''',
      monthlyFocus: {
        1: 'Yılın niyetini belirle. Tohum ek.',
        2: 'İşbirliği fırsatları. Sabırlı ol.',
        3: 'Yaratıcılık ve ifade. Sosyalleş.',
        4: 'Temelleri at. Detaylarla ilgilen.',
        5: 'Değişimlere açık ol. Esneklik.',
        6: 'Aile ve ev odağı. Sorumluluk.',
        7: 'İç gözlem. Planları gözden geçir.',
        8: 'Kariyer hamlesi. Güç ve otorite.',
        9: 'Tamamlama. Eski bağları kopar.',
        10: 'Yeni fırsatlar. Cesaretle ilerle.',
        11: 'Spiritüel farkındalık. Sezgiler.',
        12: 'Yıl değerlendirmesi. Kutlama.',
      },
      doList: [
        'Yeni projeler başlat',
        'Bağımsız kararlar al',
        'Liderlik rolü üstlen',
        'Kendinle ilgilen',
        'Cesur adımlar at',
        'Özgünlüğü kucakla',
      ],
      avoidList: [
        'Başkalarını beklemek',
        'Eski kalıplara takılmak',
        'Kararsızlık',
        'Aşırı bağımlılık',
        'Fırsatları kaçırmak',
      ],
    ),
    // Diğer yıllar için devam...
    9: PersonalYearMeaning(
      number: 9,
      theme: 'Tamamlama ve Bırakma',
      overview: '''
Bu yıl 9 yıllık döngünün sonudur. Tamamlama, bırakma, kapanış yılı.
Artık işe yaramayan her şeyi bırak: ilişkiler, işler, inançlar.
Yeni döngüye hazırlık. Evrensel perspektif ve hizmet.
''',
      monthlyFocus: {
        1: 'Neyin bitmesi gerektiğini gör.',
        2: 'Duygusal kapanışlar. Affetme.',
        3: 'İfade et ve bırak. Yaratıcı arınma.',
        4: 'Maddi düzenleme. Minimalizm.',
        5: 'Büyük değişimler. Kabul.',
        6: 'Aile karmaları. Şifa.',
        7: 'Derin iç gözlem. Spiritüel anlam.',
        8: 'Kariyer kapanışları. Miras.',
        9: 'Tam bırakma. Boşluk kabulü.',
        10: 'Yeni döngü fısıltıları.',
        11: 'Spiritüel hazırlık.',
        12: 'Geçiş ve dönüşüm. Yeni doğum.',
      },
      doList: [
        'Eski ilişkileri tamamla',
        'Affet ve bırak',
        'Hizmet et',
        'Evrensel düşün',
        'Seyahat et (özellikle spiritüel)',
        'Sanat ve yaratıcılık',
        'Hayırseverlik',
      ],
      avoidList: [
        'Yeni projeler başlatmak',
        'Bağlanmak',
        'Geçmişe tutunmak',
        'Büyük yatırımlar',
        'Evlenmek (yılın sonuna doğru değilse)',
      ],
    ),
  };
}

class PersonalYearMeaning {
  final int number;
  final String theme;
  final String overview;
  final Map<int, String> monthlyFocus;
  final List<String> doList;
  final List<String> avoidList;

  const PersonalYearMeaning({
    required this.number,
    required this.theme,
    required this.overview,
    required this.monthlyFocus,
    required this.doList,
    required this.avoidList,
  });
}
