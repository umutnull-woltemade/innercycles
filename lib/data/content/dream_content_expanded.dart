/// Dream Content Expanded - Zenginleştirilmiş Rüya İçerikleri
/// 100+ Kadim Giriş, 50+ Yeni Sembol, Tekrarlayan Rüya Kalıpları, Kâbus Dönüşümleri
library;

import '../models/dream_interpretation_models.dart';

// ════════════════════════════════════════════════════════════════════════════
// KADİM GİRİŞ ŞABLONLARI - 100+ Varyasyon
// ════════════════════════════════════════════════════════════════════════════

/// Kadim giriş şablonları - mitolojik ve içsel
class KadimGirisTemplates {
  /// Genel kadim girişler
  static const List<String> genel = [
    'Kadim bilgeler derler ki, rüyalar ruhun aynadaki yansımasıdır. Bu gece bilinçaltın sana bir mesaj gönderdi.',
    'Binlerce yıldır rüya okuyucuları bilir: gece görülen her sembol, gündüz yaşanan bir hakikatin şifresidir.',
    'Antik Mısır tapınaklarında rüya yorumcuları kutsal kabul edilirdi. Çünkü rüya, tanrıların insanla konuşma dilidir.',
    'Sufi geleneğinde rüya "mükaşefe" - perdenin aralanmasıdır. Bu gece perde senin için aralandı.',
    'Jung şöyle derdi: "Rüya, egonun görmek istemediği gerçeği gösteren küçük gizli kapıdır."',
    'Şamanlar rüyayı "ruhun gece yolculuğu" olarak tanımlar. Bu gece ruhun nereye gitti?',
    'Eski Yunan\'da rüyalar Hypnos\'un armağanıydı. Uyku tanrısı bu gece sana ne fısıldadı?',
    'Tibet bilgeleri rüyayı "Bardo" - ara boyut olarak görür. Bu gece hangi boyuta geçtin?',
    'Kızılderili gelenekte rüya, ataların sesini taşır. Bu gece atalarından ne duydun?',
    'İslam bilginlerince rüya üç türdür: rahmani, nefsani, şeytani. Bu rüya hangi kapıdan geldi?',
  ];

  /// Ay fazına göre girişler
  static const Map<String, List<String>> ayFazina = {
    'yeniay': [
      'Yeniay\'ın karanlığında gelen rüyalar tohum mesajları taşır. Bu gece bilinçaltın yeni bir niyet ekti.',
      'Karanlık ay zamanında görülen rüyalar en kadim bilgeliği barındırır. Sessizlikte dinle.',
      'Yeniay, yeni döngünün başlangıcı. Bu rüya, önündeki 28 günün haritasını çiziyor.',
      'Ay görünmezken bile çalışır. Bu rüya, görünmeyen potansiyelini aydınlatıyor.',
    ],
    'hilal': [
      'Hilal Ay döneminde rüyalar büyüme çağrısı yapar. Tohum topraktan başını çıkarmak istiyor.',
      'Işık artarken gelen bu rüya, cesaret ve ilerleme mesajı taşıyor.',
      'Hilal, umudun sembolü. Bu rüya sana "başla" diyor.',
    ],
    'ilkDordun': [
      'İlk Dördün\'de rüyalar karar noktalarını gösterir. İki yol ayrımındasın.',
      'Yarı aydınlık, yarı karanlık - bu rüya sana dengeyi öğretiyor.',
      'Gerilim zamanı. Bu rüya bir çatışmayı veya seçimi yansıtıyor.',
    ],
    'dolunay': [
      'Dolunay\'ın aydınlığında gelen rüyalar farkındalık doruk noktasıdır. Her şey görünür.',
      'Ay tam daireyken bilinçaltı da tam konuşur. Bu rüya sana tüm gerçeği gösteriyor.',
      'Dolunay enerjisi yoğun. Bu rüya bastırılanları yüzeye çıkarıyor.',
      'Işık en güçlüyken gölge de en belirgin. Bu rüya sana aynayı tutuyor.',
    ],
    'sonDordun': [
      'Son Dördün bırakma zamanıdır. Bu rüya sana neyi bırakman gerektiğini gösteriyor.',
      'Işık azalırken bilgelik artar. Bu rüya bir döngüyü kapatmanı istiyor.',
      'Hasat zamanı geçti, şimdi toprak dinlenecek. Sen de neyi dinlendirmelisin?',
    ],
    'karanlikAy': [
      'Karanlık Ay\'da gelen rüyalar en derin katmandan gelir. Dikkatle dinle.',
      'Ay görünmeden önce, en kadim mesajlar iletilir. Bu rüya bir uyarı veya hazırlık.',
      'Karanlıkta görülen rüyalar, yaklaşan ışığın habercisidir.',
    ],
  };

  /// Sembol kategorisine göre girişler
  static const Map<SymbolCategory, List<String>> kategoriye = {
    SymbolCategory.hayvan: [
      'Hayvanlar, bilinçaltının en kadim dili. Bu gece hangi içgüdüsel güç seninle konuştu?',
      'Şamanlar hayvan rüyalarını "güç hayvanı" mesajı olarak yorumlar. Totem enerjin uyanıyor.',
      'Hayvan sembolleri, insanlığın en eski arketiplerindendir. İçgüdüsel bilgeliğine kulak ver.',
      'Doğa senin aracılığınla konuşuyor. Bu hayvan, bastırdığın hangi yönünü temsil ediyor?',
    ],
    SymbolCategory.mekan: [
      'Mekanlar, ruhsal yapının haritasıdır. Bu gece iç dünyanın hangi odasına girdin?',
      'Jung\'a göre evler benliği temsil eder. Rüyandaki mekan, psişenin bir bölgesi.',
      'Her oda bir sır, her koridor bir yolculuk. Mekan sana ne anlatıyor?',
      'İç mimarlık dış mimarlığı belirler. Rüyandaki yapı, iç yapını yansıtıyor.',
    ],
    SymbolCategory.insan: [
      'Rüyalardaki insanlar genellikle kendi yönlerimizi temsil eder. Bu figür sende neyi uyandırıyor?',
      'Jung\'un Anima/Animus teorisine göre karşı cins rüya figürleri, bilinçdışı yönlerimizdir.',
      'Tanıdık yüzler, tanıdık gölgeler. Bu kişi hangi projeksiyonunu taşıyor?',
      'İnsan figürleri ayna gibidir. Kendinin hangi yönünü gördün?',
    ],
    SymbolCategory.eylem: [
      'Rüyalardaki eylemler, hayattaki duruşumuzu yansıtır. Koşuyor musun, duruyorsun mu, uçuyor musun?',
      'Hareket yön belirler. Rüyandaki eylem, hayatındaki hareketi gösteriyor.',
      'Ne yapıyordun değil, nasıl hissediyordun önemli. Eylem duygusal durumunu yansıtıyor.',
    ],
    SymbolCategory.nesne: [
      'Nesneler, anlam yüklü sembollerdir. Bu obje senin için ne ifade ediyor?',
      'Objeler, iç dünyanın dış temsilleri. Rüyandaki nesne hangi değeri simgeliyor?',
      'Araçlar, güç ve yetenekleri temsil eder. Bu nesneyle ne yapabilirsin?',
    ],
    SymbolCategory.dogaOlayi: [
      'Doğa olayları, doğanın dilidir. Derin duygular dış dünyada yansımasını buluyor.',
      'Fırtına, yağmur, deprem - iç dünyanın iklimi dışarıda görünüyor.',
      'Doğa olayları dönüşümün habercisidir. Hangi değişim temaları öne çıkıyor?',
    ],
    SymbolCategory.soyut: [
      'Soyut rüyalar en derin mesajları taşır. Kavramlar imgelere dönüşüyor.',
      'Somut olmayan, sezgisel olan konuşuyor. Mantık değil, his rehberin.',
      'Soyut semboller evrensel arketiplerdir. Kolektif bilinçten mesaj alıyorsun.',
    ],
  };

  /// Duygusal tona göre girişler
  static const Map<EmotionalTone, List<String>> duygusalTona = {
    EmotionalTone.korku: [
      'Korku rüyaları, bilinçaltının alarm sistemidir. Bir şey dikkatini çekmeye çalışıyor.',
      'Korkutucu rüyalar paradoksal olarak şifa taşır. Gölgeyle yüzleşme daveti.',
      'Jung der ki: "Rüyada korktuğumuz şey, uyanıkken kaçtığımız şeydir."',
      'Kabus değil, çağrı. Bu korku sana ne öğretmek istiyor?',
    ],
    EmotionalTone.huzur: [
      'Huzurlu rüyalar, iç dengenin göstergesi. Bir şey doğru yolda.',
      'Sakinlik, bilinçaltının onay mührü. İçsel bir çatışma çözülmüş.',
      'Huzur rüyaları nadir ve değerli. Bu duyguyu uyanıkken de hatırla.',
    ],
    EmotionalTone.merak: [
      'Merak, ruhun pusulası. Bu rüya seni keşfe çağırıyor.',
      'Soru soran rüyalar, cevap arayan ruhlara gelir. Ne öğrenmek istiyorsun?',
      'Merak, bilgeliğin tohumudur. Bu rüya bir arayışın başlangıcı.',
    ],
    EmotionalTone.sucluluk: [
      'Suçluluk rüyaları, tamamlanmamış duygusal iş işareti. Affetme zamanı.',
      'Bilinçaltı hesap soruyor. Ama yargılamak için değil, iyileştirmek için.',
      'Suçluluk, bağlantı kopukluğunun sesi. Kiminle barışman gerekiyor - kendine mi?',
    ],
    EmotionalTone.ozlem: [
      'Özlem rüyaları, kayıp bütünlüğün anısını taşır. Ne eksik?',
      'Nostalji, zamanın ötesinden gelen çağrı. Geçmişte ne bıraktın?',
      'Özlem, sevginin başka hali. Bu duygu sana ne anlatıyor?',
    ],
    EmotionalTone.heyecan: [
      'Heyecan rüyaları, yaklaşan değişimin habercisi. Bir şey geliyor.',
      'Enerji yükseliyor. Bu rüya yeni bir döngünün açılışı.',
      'Heyecan, hayat enerjisinin doruğu. Bu gücü nereye yönlendireceksin?',
    ],
    EmotionalTone.donukluk: [
      'Donukluk, aşırı hissetmekten korunma. Bilinçaltı mola istiyor.',
      'Uyuşukluk bazen gerekli. Ama uyanma zamanı yaklaşıyor.',
      'Hissizlik, kalkanın arkasındaki duyguyu gizliyor. Ne hissetmekten kaçınıyorsun?',
    ],
    EmotionalTone.ofke: [
      'Öfke rüyaları, bastırılmış gücün sesi. Sınırların ihlal edildi.',
      'Kızgınlık, korunan bir değerin işareti. Ne uğruna öfkeleniyorsun?',
      'Öfke, dönüşüm enerjisi taşır. Bu gücü yapıcı kullan.',
    ],
  };

  /// Rastgele kadim giriş seç
  static String rastgeleSecim({
    MoonPhase? ayFazi,
    SymbolCategory? kategori,
    EmotionalTone? duygu,
  }) {
    // Öncelik: duygu > ay fazı > kategori > genel
    final duyguListe = duygu != null ? duygusalTona[duygu] : null;
    if (duyguListe != null && duyguListe.isNotEmpty) {
      return duyguListe[DateTime.now().millisecond % duyguListe.length];
    }

    if (ayFazi != null) {
      final key = ayFazi.name;
      final fazListe = ayFazina[key];
      if (fazListe != null && fazListe.isNotEmpty) {
        return fazListe[DateTime.now().millisecond % fazListe.length];
      }
    }

    final kategoriyeListe = kategori != null ? kategoriye[kategori] : null;
    if (kategoriyeListe != null && kategoriyeListe.isNotEmpty) {
      final liste = kategoriyeListe;
      return liste[DateTime.now().millisecond % liste.length];
    }

    return genel[DateTime.now().millisecond % genel.length];
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TEKRARLAYAN RÜYA KALIPLARI
// ════════════════════════════════════════════════════════════════════════════

/// Tekrarlayan rüya kalıpları ve anlamları
class TekrarlayanRuyaKaliplari {
  static const List<RecurringDreamPattern> kaliplar = [
    RecurringDreamPattern(
      patternId: 'chase',
      title: 'Kovalanma Rüyaları',
      description: 'Sürekli bir şey veya biri tarafından kovalanıyorsun',
      commonSymbols: ['kovalayan', 'kaçmak', 'korku', 'koşmak'],
      frequency: 'En yaygın tekrarlayan rüya kalıbı',
      psychologicalMeaning:
          'Kaçınılan bir durumla yüzleşme çağrısı. Kovalayan genellikle bastırılmış korku, stres veya sorumluluğu temsil eder.',
      jungianAnalysis:
          'Jung\'a göre kovalayan figür genellikle Gölge arketipidir - kendi reddedilmiş yönlerimiz. '
          'Bu rüya, entegrasyon çağrısıdır.',
      actionAdvice: [
        'Rüyada dur ve kovalayan figürle yüzleş',
        'Kovalayan figüre "Ne istiyorsun?" diye sor',
        'Uyanıkken: Kaçındığın durumu belirle ve küçük adımlar at',
      ],
      evolutionNotes:
          'Eğer rüyada kovalayan figürle yüzleşmeyi başarırsan, bu rüyaların sıklığı azalır veya biter.',
      breakingAdvice:
          'Döngüyü kırmak için aktif hayal tekniği kullan: gün içinde rüyayı canlandır ve farklı bir sonuç hayal et.',
    ),
    RecurringDreamPattern(
      patternId: 'falling',
      title: 'Düşme Rüyaları',
      description: 'Boşlukta düşme, yüksekten düşme',
      commonSymbols: ['uçurum', 'düşmek', 'yerçekimi', 'korku'],
      frequency: 'Çok yaygın, özellikle stres dönemlerinde',
      psychologicalMeaning:
          'Kontrol kaybı, güvensizlik veya başarısızlık korkusunu yansıtır. Hayatta bir alanda "düşme" hissi.',
      jungianAnalysis:
          'Düşme, ego\'nun bilinçdışına düşüşünü sembolize edebilir. Dönüşüm öncesi "ölüm" deneyimi.',
      actionAdvice: [
        'Rüyada düşerken kanatların olduğunu hayal et',
        'Düşüşü kabul et ve nereye indiğini gör',
        'Uyanıkken: Kontrol kaybı korkunu incele',
      ],
      evolutionNotes:
          'Düşme rüyaları, bırakma ve teslim olma öğrenildiğinde uçma rüyalarına dönüşebilir.',
      breakingAdvice:
          'Yatmadan önce niyet koy: "Düşersem kanat açacağım." Bu lucid rüya girişimini tetikler.',
    ),
    RecurringDreamPattern(
      patternId: 'teeth',
      title: 'Diş Dökülme Rüyaları',
      description: 'Dişlerin dökülmesi, kırılması veya çürümesi',
      commonSymbols: ['dişler', 'düşmek', 'ayna', 'konuşmak'],
      frequency: 'Çok yaygın, özellikle imaj ve iletişim kaygılarında',
      psychologicalMeaning:
          'Özgüven kaybı, yaşlanma korkusu, iletişim sorunları. Dişler güç ve çekicilik sembolüdür.',
      jungianAnalysis:
          'Dişler persona ile bağlantılı - sosyal imajımız. Dökülen dişler, sosyal maskenin çatlamasını temsil edebilir.',
      actionAdvice: [
        'Rüyada aynaya bak ve kabul et',
        'İmaj kaygılarını sorgula',
        'Söyleyemediğin şeyleri not et',
      ],
      evolutionNotes:
          'Özgüven artışıyla bu rüyalar azalır. Bazen diş doktoruna gitme zamanı hatırlatıcısı olabilir!',
      breakingAdvice:
          'Kendine "Gerçek değerim dış görünüşümden bağımsızdır" onaylamasını tekrarla.',
    ),
    RecurringDreamPattern(
      patternId: 'naked',
      title: 'Çıplak Kalma Rüyaları',
      description: 'Toplum içinde çıplak veya uygunsuz giyinmiş olma',
      commonSymbols: ['çıplaklık', 'utanç', 'kalabalık', 'ifşa'],
      frequency: 'Yaygın, özellikle yeni durumlarda',
      psychologicalMeaning:
          'Savunmasızlık, ifşa olma korkusu, imposter sendromu. Gerçek benliğin açığa çıkması kaygısı.',
      jungianAnalysis:
          'Maskelerin düşürülmesi, persona\'nın çözülmesi. İlginç şekilde, çoğu zaman rüyadaki başkaları fark etmez - bu kendi kendini yargılamayı gösterir.',
      actionAdvice: [
        'Rüyada fark et: başkaları gerçekten umursuyor mu?',
        'Savunmasızlığı kabul et',
        'Mükemmeliyetçiliği sorgula',
      ],
      evolutionNotes:
          'Özgüven ve öz-kabul arttıkça, çıplaklık utancı rüyalarda azalır veya artık rahatsız etmez.',
      breakingAdvice:
          'Kırılganlık cesarettir. Brené Brown\'ın çalışmalarını oku.',
    ),
    RecurringDreamPattern(
      patternId: 'late',
      title: 'Geç Kalma / Kaçırma Rüyaları',
      description: 'Uçağı kaçırma, sınava geç kalma, randevuyu kaçırma',
      commonSymbols: ['saat', 'koşmak', 'kaçırmak', 'engeller'],
      frequency: 'Çok yaygın, özellikle iş/okul stresinde',
      psychologicalMeaning:
          'Zaman baskısı, fırsat kaçırma korkusu, yetersizlik hissi. Hayata yetişememe kaygısı.',
      jungianAnalysis:
          'Zaman, ölümlülüğün hatırlatıcısıdır. Geç kalma rüyaları, "yaşam görevi"ni tamamlayamama korkusunu yansıtabilir.',
      actionAdvice: [
        'Gerçekçi olmayan beklentileri sorgula',
        'Önceliklerini belirle',
        '"Yeterince iyi" kavramını öğren',
      ],
      evolutionNotes:
          'Zaman yönetimi ve önceliklendirme iyileştiğinde, bu rüyalar azalır.',
      breakingAdvice:
          'Yatmadan önce yarının planını yaz. Bilinçaltı, organize olduğunu bilsin.',
    ),
    RecurringDreamPattern(
      patternId: 'house',
      title: 'Ev Keşfi Rüyaları',
      description: 'Evde bilinmeyen odalar keşfetme',
      commonSymbols: ['ev', 'yeni odalar', 'gizli kapılar', 'bodrum', 'çatı'],
      frequency: 'Yaygın, özellikle kişisel gelişim dönemlerinde',
      psychologicalMeaning:
          'Keşfedilmemiş potansiyel, bilinmeyen benlik yönleri. Ev = psişe. Yeni odalar = fark edilmemiş yetenekler.',
      jungianAnalysis:
          'Jung ev rüyalarını çok önemsedi. Bodrum = bilinçdışı, üst katlar = bilinç, çatı = içsel alan.',
      actionAdvice: [
        'Keşfettiğin odanın özelliklerini not et',
        'Bu alan hayatında neyi temsil ediyor?',
        'Yeni yetenekleri keşfetme cesareti göster',
      ],
      evolutionNotes:
          'Pozitif gelişim işareti. Yeni odalar, büyüme potansiyelini gösterir.',
      breakingAdvice:
          'Bu kalıbı "kırmak" değil, takip etmek gerekir. Her yeni oda bir mesajdır.',
    ),
    RecurringDreamPattern(
      patternId: 'exam',
      title: 'Sınav Rüyaları',
      description: 'Hazırlıksız sınava girme, soruları bilememe',
      commonSymbols: ['sınav', 'okul', 'test', 'hazırlıksız', 'başarısızlık'],
      frequency: 'Çok yaygın, mezuniyetten yıllar sonra bile',
      psychologicalMeaning:
          'Değerlendirilme kaygısı, yetersizlik korkusu. Hayatta "sınanma" hissi.',
      jungianAnalysis:
          'Yargıç arketipinin aktif olması. İç eleştirmen çok güçlü. Bazen dış otoriteyle çatışma.',
      actionAdvice: [
        'Hangi alanda test edildiğini hissediyorsun?',
        'İç eleştirmenle diyalog kur',
        'Mükemmeliyetçiliği bırak',
      ],
      evolutionNotes:
          'Öz-kabul ve başarısızlık korkusunun azalmasıyla bu rüyalar seyrekleşir.',
      breakingAdvice:
          'Kendine hatırlat: Okulu bitirdin. Artık hayat sınavı var ve bunun cevap anahtarı yok.',
    ),
    RecurringDreamPattern(
      patternId: 'flying',
      title: 'Uçma Rüyaları (Olumlu Tekrar)',
      description: 'Kontrollü uçma, özgürce süzülme',
      commonSymbols: ['uçmak', 'gökyüzü', 'özgürlük', 'kontrol'],
      frequency: 'Yaygın, pozitif gelişim dönemlerinde artar',
      psychologicalMeaning:
          'Özgürlük, kontrol hissi, sınırlamaları aşma. Genellikle pozitif psikolojik durumun işareti.',
      jungianAnalysis:
          'Ego\'nun bilinçdışı ile sağlıklı ilişkisi. Kahraman arketipinin olumlu tezahürü.',
      actionAdvice: [
        'Uçuşu hatırla ve o özgürlük hissini gün içinde taşı',
        'Bu his hangi başarıyla bağlantılı?',
        'Daha fazla uçuş için: lucid rüya pratikleri',
      ],
      evolutionNotes:
          'Bu pozitif bir kalıp. Devam etmesi sağlıklı psişenin işareti.',
      breakingAdvice:
          'Kırma değil, artırma hedefle. Uçuş rüyalarını lucid rüyaya çevir.',
    ),
    RecurringDreamPattern(
      patternId: 'water-danger',
      title: 'Su Tehlikesi Rüyaları',
      description: 'Boğulma, sel, fırtınalı deniz',
      commonSymbols: ['su', 'boğulma', 'dalga', 'fırtına', 'sel'],
      frequency: 'Yaygın, duygusal çalkantı dönemlerinde',
      psychologicalMeaning:
          'Duygusal bunaltı, bastırılmış duyguların yüzeye çıkması. Su = duygular, tehlike = kontrol kaybı.',
      jungianAnalysis:
          'Bilinçdışının ego\'yu tehdit etmesi. Duyguların bastırılması artık işe yaramıyor.',
      actionAdvice: [
        'Hangi duygular bastırılıyor?',
        'Ağlamaya, hissetmeye izin ver',
        'Duygusal ifade kanalları bul',
      ],
      evolutionNotes:
          'Duygusal ifade öğrenildiğinde, su rüyaları sakinleşir - sakin göller, berrak akarsular.',
      breakingAdvice: 'Duygular bataklık değil, akarsudur. Akmasına izin ver.',
    ),
    RecurringDreamPattern(
      patternId: 'death-loved',
      title: 'Sevilen Birinin Ölümü Rüyaları',
      description: 'Anne, baba, eş veya çocuğun ölümü',
      commonSymbols: ['ölüm', 'aile', 'kayıp', 'cenaze', 'veda'],
      frequency: 'Yaygın, özellikle bağlanma kaygısı olanlarda',
      psychologicalMeaning:
          'Kaybetme korkusu, bağımlılık farkındalığı. Bazen ilişkideki "ölü" yönleri temsil eder.',
      jungianAnalysis:
          'İçselleştirilmiş figürün dönüşümü. Ebeveyn rüyaları, iç ebeveyn arketipinin değişimini gösterebilir.',
      actionAdvice: [
        'Bu kişiyle ilişkini incele',
        'Bağımlılık mı, sağlıklı bağ mı?',
        '"Ölüm" neyin bitişini temsil edebilir?',
      ],
      evolutionNotes:
          'İlişkiler olgunlaştığında, ölüm rüyaları dönüşüm rüyalarına dönüşür.',
      breakingAdvice:
          'Sevdiklerinle zaman geçir, ifade et. Ama bağımlılık değil, olgun sevgi geliştir.',
    ),
  ];

  /// Kalıp ID\'sine göre bul
  static RecurringDreamPattern? getByPatternId(String id) {
    return kaliplar.where((k) => k.patternId == id).firstOrNull;
  }

  /// Sembole göre kalıp bul
  static List<RecurringDreamPattern> findBySymbol(String symbol) {
    return kaliplar
        .where(
          (k) => k.commonSymbols.any(
            (s) => s.toLowerCase().contains(symbol.toLowerCase()),
          ),
        )
        .toList();
  }
}

/// Tekrarlayan rüya kalıbı modeli
class RecurringDreamPattern {
  final String patternId;
  final String title;
  final String description;
  final List<String> commonSymbols;
  final String frequency;
  final String psychologicalMeaning;
  final String jungianAnalysis;
  final List<String> actionAdvice;
  final String evolutionNotes;
  final String breakingAdvice;

  const RecurringDreamPattern({
    required this.patternId,
    required this.title,
    required this.description,
    required this.commonSymbols,
    required this.frequency,
    required this.psychologicalMeaning,
    required this.jungianAnalysis,
    required this.actionAdvice,
    required this.evolutionNotes,
    required this.breakingAdvice,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// KÂBUS DÖNÜŞÜM REHBERİ
// ════════════════════════════════════════════════════════════════════════════

/// Kâbus dönüşüm teknikleri ve yorumları
class KabusDonusumRehberi {
  static const List<NightmareGuide> rehberler = [
    NightmareGuide(
      nightmareType: 'monster',
      title: 'Canavar / Yaratık Kâbusları',
      description: 'Korkunç yaratıklar, canavarlar tarafından tehdit edilme',
      shadowElement: 'Reddedilen öfke, güç veya cinsellik',
      transformationMessage:
          'Canavar, bastırılmış gücündür. Korktukça büyür, kucakladıkça dost olur.',
      integrationSteps: [
        'Uyanınca canavari çiz - detaylara bak',
        'Canavara bir isim ver',
        'Hayal et: Canavarla konuşuyorsun, ne istiyor?',
        'Hangi bastırılmış gücü temsil ediyor?',
        'Bu gücü sağlıklı nasıl ifade edebilirsin?',
      ],
      empowermentNote:
          'Gölge entegre edildiğinde, canavar koruyucu güce dönüşür. Sonraki rüyalarında '
          'aynı yaratık sana yardım edebilir.',
      safetyReminder:
          'Bu yorumlar eğitim amaçlıdır. Travma sonrası kâbuslar için profesyonel destek alın.',
    ),
    NightmareGuide(
      nightmareType: 'attack',
      title: 'Saldırı / Şiddet Kâbusları',
      description: 'Fiziksel saldırı, silah, yaralanma',
      shadowElement: 'Sınır ihlalleri, bastırılmış öfke, travma',
      transformationMessage:
          'Saldırı rüyaları, sınırlarının ihlal edildiğini gösterir. İçsel savaşçını uyandırma çağrısı.',
      integrationSteps: [
        'Saldırgan kim? Tanıdık mı, yabancı mı?',
        'Hayatında sınırların nerede ihlal ediliyor?',
        'Savunma mekanizmalarını güçlendir',
        'Asertiflik pratikleri yap',
        'Güvenli ortamda öfke ifade et (spor, yazı, terapi)',
      ],
      empowermentNote:
          'Sınırlarını korumayı öğrendiğinde, rüyalarda saldırgana karşı koyabilir veya '
          'saldırı rüyaları biter.',
      safetyReminder:
          'Gerçek şiddet deneyimi varsa, mutlaka travma uzmanıyla çalış. EMDR etkili olabilir.',
    ),
    NightmareGuide(
      nightmareType: 'death-self',
      title: 'Kendi Ölümü Kâbusları',
      description: 'Ölmek, öldürülmek, ölüm anı deneyimi',
      shadowElement: 'Dönüşüm korkusu, ego ölümü, büyük değişim',
      transformationMessage:
          'Rüyada ölmek, genellikle ego\'nun dönüşümüdür. Bir şey bitiyor ki yenisi başlasın.',
      integrationSteps: [
        'Nasıl öldün? Bu detay önemli',
        'Ölümden sonra ne oldu? Rüya devam etti mi?',
        'Hayatında ne bitiyor veya bitmesi gerekiyor?',
        'Değişime direncini fark et',
        'Bırakma ritüeli yap: Ne gidecek, ne kalacak?',
      ],
      empowermentNote:
          'Ölüm rüyasını tamamlayabilenler (yani rüyada ölüp sonrasını görenler) '
          'genellikle derin dönüşüm yaşar.',
      safetyReminder:
          'Gerçek ölüm düşünceleri varsa, hemen yardım al: 182 (Türkiye İntihar Önleme Hattı)',
    ),
    NightmareGuide(
      nightmareType: 'paralysis',
      title: 'Uyku Felci Kâbusları',
      description: 'Hareket edememe, baskı hissi, gölge figürler',
      shadowElement: 'Kontrol kaybı, bastırılmış korku, yaşam geçişleri',
      transformationMessage:
          'Uyku felci, REM atonisinin farkındalığıdır. Korkunç hissettiren şey, '
          'kontrol kaybıdır - ki bu da bırakmayı öğretir.',
      integrationSteps: [
        'Felç anında paniğe kapılma - geçici',
        'Sadece bir parmağını kıpırdatmaya odaklan',
        'Nefese odaklan',
        'Gölge figür varsa, soru sor: "Ne istiyorsun?"',
        'Uyku hijyenini düzenle (düzenli uyku, az kafein)',
      ],
      empowermentNote:
          'Uyku felci, lucid rüyaya geçiş kapısı olabilir. Korku yerine merak ile yaklaş.',
      safetyReminder:
          'Sık uyku felci, uyku bozukluğunun işareti olabilir. Uyku kliniğine danış.',
    ),
    NightmareGuide(
      nightmareType: 'falling-endless',
      title: 'Sonsuz Düşüş Kâbusları',
      description: 'Bitmeyen düşüş, dibe çarpma',
      shadowElement: 'Kontrolsüzlük, başarısızlık korkusu, temelsizlik',
      transformationMessage:
          'Düşüş, bırakma çağrısıdır. Tutunmayı bıraktığında, kanatların açılır.',
      integrationSteps: [
        'Düşerken ne hissettin? Korku mu, teslim mi?',
        'Dibe çarptın mı? Sonra ne oldu?',
        'Hayatında neyi kontrol etmeye çalışıyorsun?',
        'Kontrolü bırakma pratiği yap',
        'Güven: Evren seni tutar',
      ],
      empowermentNote:
          'Düşüşü kabul edenler, rüyada uçmaya başlar. Bu en güçlü dönüşümlerden biridir.',
      safetyReminder:
          'Düşme rüyaları bazen fizyolojik (tansiyon, iç kulak). Sık oluyorsa kontrol ettir.',
    ),
    NightmareGuide(
      nightmareType: 'trapped',
      title: 'Sıkışmış Kalma Kâbusları',
      description: 'Dar alan, hapis, çıkış yok',
      shadowElement: 'Kısıtlanma, ilişki/iş tuzağı, özgürlük kaybı',
      transformationMessage:
          'Sıkışmışlık, farkındalık eksikliğidir. Çıkış her zaman var - bakış açını değiştir.',
      integrationSteps: [
        'Nerede sıkıştın? Detayları not et',
        'Hayatında nerede "tuzakta" hissediyorsun?',
        'Çıkış olasılıklarını listele (gerçek hayatta)',
        'En küçük adımı belirle',
        'Yardım istemeye cesaret et',
      ],
      empowermentNote:
          'Rüyada çıkış bulduğunda veya tuzağı kırdığında, gerçek hayatta da '
          'çözüm yolları açılır.',
      safetyReminder:
          'Gerçek hayatta sıkışmışlık hissi yoğunsa (ilişki, iş), profesyonel destek al.',
    ),
  ];

  /// Tip\'e göre rehber bul
  static NightmareGuide? getByType(String type) {
    return rehberler.where((r) => r.nightmareType == type).firstOrNull;
  }
}

/// Kâbus dönüşüm rehberi modeli
class NightmareGuide {
  final String nightmareType;
  final String title;
  final String description;
  final String shadowElement;
  final String transformationMessage;
  final List<String> integrationSteps;
  final String empowermentNote;
  final String safetyReminder;

  const NightmareGuide({
    required this.nightmareType,
    required this.title,
    required this.description,
    required this.shadowElement,
    required this.transformationMessage,
    required this.integrationSteps,
    required this.empowermentNote,
    required this.safetyReminder,
  });
}
