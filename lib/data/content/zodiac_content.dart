import '../models/zodiac_sign.dart';

/// Comprehensive zodiac sign content with detailed information
class ZodiacContent {
  static ZodiacDetailedInfo getDetailedInfo(ZodiacSign sign) {
    return _zodiacData[sign]!;
  }

  static List<ZodiacDetailedInfo> getAllZodiacInfo() {
    return ZodiacSign.values.map((sign) => _zodiacData[sign]!).toList();
  }

  static final Map<ZodiacSign, ZodiacDetailedInfo> _zodiacData = {
    // ============== KOÇ (ARIES) ==============
    ZodiacSign.aries: ZodiacDetailedInfo(
      sign: ZodiacSign.aries,
      overview: '''Koç burcu, zodyağın ilk burcu olarak yeni başlangıçların, cesaretin ve öncü ruhun simgesidir. 21 Mart - 19 Nisan tarihleri arasında doğanlar bu burca aittir. Mars gezegeninin yönetimindeki bu ateş burcu, sonsuz enerji, liderlik kapasitesi ve girişimci ruhuyla tanınır.

Koç insanları doğuştan liderlerdir. Kalabalığın önünde yürümekten, risk almaktan ve bilinmeyene atılmaktan çekinmezler. "İlk" olmak onların doğasında vardır - ilk adımı atan, ilk sözü söyleyen, ilk harekete geçen hep onlardır.

Bu burcun sembolü olan Koç, azim ve kararlılığı temsil eder. Tıpkı dağa tırmanan bir koç gibi, hedeflerine ulaşmak için her engeli aşmaya hazırdırlar. Ateş elementi onlara tutku, heyecan ve yaşam enerjisi verir.''',

      personality: PersonalityTraits(
        strengths: [
          'Cesaret ve yüreklilik - korku onları durduramaz',
          'Doğal liderlik yeteneği ve karizması',
          'Girişimci ruh ve risk alma kapasitesi',
          'Dürüstlük ve doğrudanlık',
          'Yüksek enerji ve dinamizm',
          'Hızlı karar alma yeteneği',
          'Rekabetçi ve başarı odaklı yapı',
          'Bağımsızlık ve özgüven',
          'İyimserlik ve pozitif bakış açısı',
          'Koruyucu ve sadık dost olma',
        ],
        weaknesses: [
          'Sabırsızlık ve aceleci davranışlar',
          'Düşünmeden hareket etme eğilimi',
          'Öfkeyi kontrol etmekte zorluk',
          'Bencillik ve ego sorunları',
          'Detayları gözden kaçırma',
          'Uzun vadeli projelerde istikrarsızlık',
          'Başkalarının duygularına duyarsızlık',
          'Otoriteye karşı gelme',
          'Rekabeti abartma',
          'Dinlemeden konuşma',
        ],
        hiddenTraits: [
          'Dış görünüşlerinin aksine, derin bir güvensizlik taşıyabilirler',
          'Sert kabukları altında romantik ve hassas bir kalp yatar',
          'Reddedilmekten gizlice korkarlar',
          'Başarısızlık onları derinden etkiler ama belli etmezler',
          'Sevdiklerini korumak için her şeyi yaparlar',
        ],
      ),

      loveAndRelationships: LoveProfile(
        generalApproach: '''Koç aşkta tıpkı hayatın diğer alanlarında olduğu gibi tutkulu, doğrudan ve yoğundur. Aşık olduklarında tüm dünya durur - o kişi hayatlarının merkezi haline gelir. Flört oyunlarından hoşlanmazlar; ilgilendikleri kişiye doğrudan yaklaşırlar.

Koç'un aşkı ateşli ve heyecan vericidir. Süprizler, spontan romantik jestler ve macera dolu randevular onların tarzıdır. Sıkıcılık ilişkileri için en büyük tehlikedir.

İlişkide bağımsızlıklarını korumak isterler. Yapışkan veya kıskanç partnerlerle zorluk yaşayabilirler. İdeal partnerleri, kendi ayakları üzerinde durabilen, özgüven sahibi ve hayattan zevk alan kişilerdir.''',
        compatibleSigns: [
          SignCompatibility(
            sign: ZodiacSign.leo,
            percentage: 95,
            description: 'Mükemmel uyum! İki ateş burcu birlikte yanarak parlayabilir. Karşılıklı hayranlık ve tutku bu ilişkinin temelidir.',
          ),
          SignCompatibility(
            sign: ZodiacSign.sagittarius,
            percentage: 93,
            description: 'Macera dolu bir ilişki. İkisi de özgürlüğe değer verir ve birlikte dünyayı keşfetmekten zevk alır.',
          ),
          SignCompatibility(
            sign: ZodiacSign.gemini,
            percentage: 85,
            description: 'Entelektüel uyum ve eğlence. İkizler\'in zekası Koç\'u büyüler, Koç\'un enerjisi İkizler\'i heyecanlandırır.',
          ),
          SignCompatibility(
            sign: ZodiacSign.aquarius,
            percentage: 82,
            description: 'Bağımsız ruhların buluşması. Birbirlerinin özgürlüğüne saygı duyarlar.',
          ),
        ],
        challengingSigns: [
          SignCompatibility(
            sign: ZodiacSign.cancer,
            percentage: 45,
            description: 'Koç\'un sertliği Yengeç\'i incitebilir. Yengeç\'in duygusallığı Koç\'u bunaltabilir.',
          ),
          SignCompatibility(
            sign: ZodiacSign.capricorn,
            percentage: 50,
            description: 'İkisi de liderlik ister. Güç mücadelesi kaçınılmazdır ama karşılıklı saygıyla aşılabilir.',
          ),
        ],
        loveAdvice: [
          'Partnerinizin duygularını dinlemeyi öğrenin',
          'Sabırlı olun - her şey anında olmak zorunda değil',
          'Öfkenizi kontrol edin, pişman olacağınız şeyler söylemeyin',
          'Uzlaşma ilişkilerin temelidir, her zaman haklı olmak zorunda değilsiniz',
          'Romantik jestleri küçümsemeyin',
        ],
      ),

      careerAndMoney: CareerProfile(
        strengths: [
          'Liderlik ve yöneticilik',
          'Girişimcilik ve iş kurma',
          'Hızlı karar alma',
          'Risk yönetimi',
          'Motivasyon ve takım yönetimi',
          'Rekabetçi ortamlarda başarı',
          'Yenilikçi düşünce',
          'Kriz yönetimi',
        ],
        idealCareers: [
          CareerSuggestion(
            title: 'Girişimci / CEO',
            description: 'Kendi işini kurma ve yönetme, doğal liderlik yeteneklerini kullanma',
            suitabilityScore: 98,
          ),
          CareerSuggestion(
            title: 'Sporcu / Antrenör',
            description: 'Rekabetçi ruhu ve fiziksel enerjisini kullanma',
            suitabilityScore: 95,
          ),
          CareerSuggestion(
            title: 'Satış Direktörü',
            description: 'İkna kabiliyeti ve hedef odaklı çalışma',
            suitabilityScore: 92,
          ),
          CareerSuggestion(
            title: 'Acil Servis Doktoru / Cerrah',
            description: 'Hızlı karar alma ve baskı altında çalışma',
            suitabilityScore: 90,
          ),
          CareerSuggestion(
            title: 'Polis / Asker',
            description: 'Cesaret, koruyuculuk ve aksiyon',
            suitabilityScore: 88,
          ),
          CareerSuggestion(
            title: 'Stuntman / Aksiyon Oyuncusu',
            description: 'Risk alma ve fiziksel cesaret',
            suitabilityScore: 85,
          ),
        ],
        moneyHabits: '''Koç parayla ilişkisinde de tipik karakterini gösterir: hızlı kazanır, hızlı harcar. Anlık kararlarla büyük alışverişler yapabilir. Bütçe planlaması onlar için sıkıcıdır ama öğrenmeleri gereken önemli bir beceridir.

Yatırım konusunda risk almaktan çekinmezler. Bu bazen büyük kazançlar, bazen de büyük kayıplar getirir. Uzun vadeli yatırımlar yerine hızlı getiri vaat eden fırsatları tercih ederler.

Para biriktirmek için motivasyona ihtiyaç duyarlar. Somut bir hedef (araba, ev, seyahat) onları tasarrufa yönlendirir. Soyut "gelecek için biriktirme" kavramı onlara çekici gelmez.''',
        financialAdvice: [
          'Büyük alışverişlerde 24 saat bekleme kuralı uygulayın',
          'Otomatik tasarruf hesabı açın',
          'Portföyünüzü çeşitlendirin, tüm yumurtaları bir sepete koymayın',
          'Finansal danışman yardımı almayı düşünün',
          'Acil durum fonu oluşturun',
        ],
      ),

      healthAndWellness: HealthProfile(
        bodyAreas: ['Baş', 'Yüz', 'Beyin', 'Gözler', 'Üst çene'],
        commonIssues: [
          'Migren ve baş ağrıları',
          'Yüz bölgesi cilt sorunları',
          'Göz yorgunluğu',
          'Sinüzit',
          'Stres kaynaklı gerilim',
          'Ani ateş yükselmeleri',
        ],
        exerciseRecommendations: [
          'Yüksek tempolu interval antrenmanları (HIIT)',
          'Boks ve dövüş sanatları',
          'Koşu ve sprint',
          'Rekabetçi takım sporları',
          'CrossFit',
          'Dağ tırmanışı',
        ],
        stressManagement: '''Koç burcu stresle başa çıkmak için fiziksel aktiviteye ihtiyaç duyar. Hareketsiz kalmak onların en büyük düşmanıdır. Öfke ve gerilim biriktiğinde, yoğun bir antrenman veya koşu mucizeler yaratır.

Meditasyon ve nefes egzersizleri başta zor gelse de, düzenli pratikle öfke kontrolünde çok yardımcı olur. Sabır gerektiren hobiler (puzzle, bahçecilik) dengeleyici etki yapar.

Uyku düzeni Koç için kritiktir. Yeterince uyumadıklarında öfke kontrolü zorlaşır ve karar verme yetenekleri zayıflar.''',
        dietaryAdvice: [
          'Kırmızı et ve protein açısından zengin beslenme',
          'Baharatlı yiyecekler metabolizmayı hızlandırır',
          'Demir içeren gıdalara önem verin',
          'Kafein alımını kontrol edin - zaten yeterince enerjiğiniz var',
          'Hidrasyon çok önemli - bol su için',
        ],
      ),

      luckyElements: LuckyElements(
        numbers: [1, 9, 17, 27, 36, 45],
        colors: ['Kırmızı', 'Turuncu', 'Altın sarısı', 'Beyaz'],
        days: ['Salı', 'Cumartesi'],
        gemstones: ['Elmas', 'Yakut', 'Kırmızı mercan', 'Akik'],
        metals: ['Demir', 'Çelik'],
        flowers: ['Karanfil', 'Gelincik', 'Zambak'],
        direction: 'Doğu',
      ),

      famousPeople: [
        FamousPerson(name: 'Leonardo da Vinci', profession: 'Sanatçı, Mucit', birthDate: '15 Nisan 1452'),
        FamousPerson(name: 'Lady Gaga', profession: 'Şarkıcı', birthDate: '28 Mart 1986'),
        FamousPerson(name: 'Robert Downey Jr.', profession: 'Oyuncu', birthDate: '4 Nisan 1965'),
        FamousPerson(name: 'Elton John', profession: 'Müzisyen', birthDate: '25 Mart 1947'),
        FamousPerson(name: 'Mariah Carey', profession: 'Şarkıcı', birthDate: '27 Mart 1969'),
        FamousPerson(name: 'Emma Watson', profession: 'Oyuncu', birthDate: '15 Nisan 1990'),
        FamousPerson(name: 'Quentin Tarantino', profession: 'Yönetmen', birthDate: '27 Mart 1963'),
        FamousPerson(name: 'Fatih Sultan Mehmet', profession: 'Osmanlı Padişahı', birthDate: '30 Mart 1432'),
      ],

      mythologyAndSymbolism: '''Koç burcu, antik mitolojide önemli bir yere sahiptir. Yunan mitolojisinde, Altın Post'un sahibi olan koç, Phrixus ve Helle'yi kurtarmıştır. Bu koç, Zeus tarafından gökyüzüne yerleştirilmiş ve bir takımyıldız haline gelmiştir.

Koç sembolü, birçok kültürde cesaret, savaşçı ruhu ve liderliği temsil eder. Antik Mısır'da Amon-Ra, koç başlı bir tanrı olarak tasvir edilirdi. Kelt mitolojisinde koç, erkeklik gücü ve bereketliğin simgesiydi.

Astrolojik olarak Koç, ilkbahar ekinoksuyla başlar - bu, yeniden doğuşun, yeni başlangıcların ve doğanın uyanışının zamanıdır. Bu nedenle Koç burcu, yaşam enerjisi ve yenilenmeyle derinden bağlantılıdır.

Mars gezegeninin yönetimi, Koç'a savaşçı ruhu, rekabetçiliği ve harekete geçme gücünü verir. Mars, Roma savaş tanrısının adını taşır ve Koç'un karakterindeki cesaret ile kararlılığın kaynağıdır.''',

      seasonalAdvice: SeasonalAdvice(
        spring: 'İlkbahar sizin mevsiminizdir! Yeni projeler başlatmak, fitness hedeflerine odaklanmak ve sosyal hayatınızı canlandırmak için ideal zaman. Doğum gününüz etrafında büyük kararlar almak şanslı olabilir.',
        summer: 'Enerjiniz zirvededir. Tatil planları yapın ama aşırı hırslarınızı kontrol edin. Aşk hayatınızda heyecanlı gelişmeler olabilir. Güneş yanıklarına dikkat!',
        autumn: 'Yavaşlama zamanı. İlişkilere ve iç dünyanıza odaklanın. Mali konularda temkinli olun. Yeni beceriler öğrenmek için iyi bir dönem.',
        winter: 'Kariyer odaklı olun. Uzun vadeli planlar yapın. Aile ilişkilerinizi güçlendirin. Fiziksel aktiviteyi azaltmayın, kış depresyonuna karşı koruyucudur.',
      ),

      lifeLessons: [
        'Sabır bir erdemdir - her şeyin zamanı vardır',
        'Başkalarını dinlemek, kendi sesinizi duyurmak kadar önemlidir',
        'Güçlü olmak, her zaman savaşmak anlamına gelmez',
        'Hata yapmak insanidir, hatalardan ders almak bilgeliktir',
        'Liderlik, hizmet etmektir',
        'Öfke kontrol edilmezse, sizi kontrol eder',
        'Bağımsızlık önemlidir ama bağlılık da güzeldir',
        'Her yarışı kazanmak zorunda değilsiniz',
      ],
    ),

    // ============== BOĞA (TAURUS) ==============
    ZodiacSign.taurus: ZodiacDetailedInfo(
      sign: ZodiacSign.taurus,
      overview: '''Boğa burcu, zodyağın ikinci burcu olarak istikrar, güvenlik ve yaşamın güzelliklerinin simgesidir. 20 Nisan - 20 Mayıs tarihleri arasında doğanlar bu burca aittir. Venüs gezegeninin yönetimindeki bu toprak burcu, sadakat, kararlılık ve duyusal zevklerle tanınır.

Boğa insanları hayatın sağlam temellerini oluşturur. Güvenilir, sabırlı ve azimlidirler. Bir Boğa arkadaş, iş ortağı veya sevgili, hayatınızdaki en güvenilir kişilerden biri olacaktır.

Bu burcun sembolü olan Boğa, güç ve dayanıklılığı temsil eder. Toprak elementi onlara pratiklik, somutluk ve ayakları yere basan bir bakış açısı verir. Venüs yönetimi ise güzellik, sanat ve aşka olan derin ilgiyi getirir.''',

      personality: PersonalityTraits(
        strengths: [
          'Olağanüstü sadakat ve güvenilirlik',
          'Sabır ve azim',
          'Pratik düşünce ve çözüm üretme',
          'Finansal zeka ve tutum',
          'Duyusal zevkleri anlama ve takdir etme',
          'Kararlılık ve tutarlılık',
          'Sakinleştirici ve dengeleyici varlık',
          'Estetik anlayış ve sanat takdiri',
          'Doğayla uyum',
          'Koruyucu ve besleyici',
        ],
        weaknesses: [
          'İnatçılık ve esnenemezlik',
          'Değişime direnç',
          'Maddi konularda aşırı bağlılık',
          'Tembel olma eğilimi',
          'Sahiplenici davranışlar',
          'Kıskançlık',
          'Rutinden çıkamama',
          'Aşırı yeme ve tüketim',
          'Kin tutma',
          'Karar vermekte yavaşlık',
        ],
        hiddenTraits: [
          'Sakin görünümlerinin altında derin bir güvensizlik yatabilir',
          'Değişimden korkarlar ama aslında büyümek isterler',
          'Son derece romantik ve şairdirler ama göstermekte zorlanırlar',
          'Reddedilmek onları derinden yaralar',
          'Sevdikleri için sessizce büyük fedakarlıklar yaparlar',
        ],
      ),

      loveAndRelationships: LoveProfile(
        generalApproach: '''Boğa aşkta yavaş ama derindir. Hemen aşık olmaz, tanımak için zaman alırlar. Ama bir kez bağlandıklarında, sadakatleri sarsılmazdır. Onlar için aşk bir sprint değil, maratondur.

Romantik jestleri severler - güzel bir akşam yemeği, kaliteli bir hediye, fiziksel yakınlık. Beş duyu onlar için aşkın dilidir. Dokunuşa, kokuya ve tada büyük önem verirler.

Güvenlik Boğa için aşkın temelidir. Güvenmedikleri birine açılmazlar. Partner seçiminde uzun vadeli uyumu gözetir, anlık çekimlerden çok kalıcı bağlara değer verirler.''',
        compatibleSigns: [
          SignCompatibility(
            sign: ZodiacSign.cancer,
            percentage: 96,
            description: 'Mükemmel ev ve aile uyumu. İkisi de güvenlik ve sadakate değer verir. Birlikte huzurlu bir yuva kurarlar.',
          ),
          SignCompatibility(
            sign: ZodiacSign.virgo,
            percentage: 94,
            description: 'Toprak burçları olarak doğal uyum. Pratik, güvenilir ve birbirlerini anlayan bir çift.',
          ),
          SignCompatibility(
            sign: ZodiacSign.pisces,
            percentage: 88,
            description: 'Romantik ve rüya gibi bir bağ. Balık\'ın hassasiyeti Boğa\'yı yumuşatır, Boğa\'nın sağlamlığı Balık\'ı güvende tutar.',
          ),
          SignCompatibility(
            sign: ZodiacSign.capricorn,
            percentage: 92,
            description: 'Uzun vadeli başarı birlikte. İş ve aile hedeflerinde mükemmel uyum.',
          ),
        ],
        challengingSigns: [
          SignCompatibility(
            sign: ZodiacSign.leo,
            percentage: 55,
            description: 'İnatçılık çatışması. İkisi de taviz vermekte zorlanır. Güç mücadelesi yorucu olabilir.',
          ),
          SignCompatibility(
            sign: ZodiacSign.aquarius,
            percentage: 48,
            description: 'Çok farklı dünyalar. Kova\'nın değişkenliği Boğa\'yı strese sokar. Boğa\'nın rutini Kova\'yı sıkar.',
          ),
        ],
        loveAdvice: [
          'Değişime açık olun - ilişkiler de evrim geçirir',
          'Sahiplenicilik aşkı boğar, özgürlük tanıyın',
          'Kıskançlığınızı kontrol edin',
          'Duyguları ifade etmek zayıflık değildir',
          'Bazen spontan olmak ilişkiyi canlandırır',
        ],
      ),

      careerAndMoney: CareerProfile(
        strengths: [
          'Finansal planlama ve yatırım',
          'Uzun vadeli proje yönetimi',
          'Güvenilirlik ve tutarlılık',
          'Detaylara dikkat',
          'Sanat ve tasarım yetenekleri',
          'Müzakere becerileri',
          'Kalite kontrolü',
          'Müşteri ilişkileri',
        ],
        idealCareers: [
          CareerSuggestion(
            title: 'Bankacı / Finans Yöneticisi',
            description: 'Para yönetimi ve uzun vadeli planlama',
            suitabilityScore: 97,
          ),
          CareerSuggestion(
            title: 'Şef / Gastronomi Uzmanı',
            description: 'Duyusal deneyimler ve lezzet yaratımı',
            suitabilityScore: 95,
          ),
          CareerSuggestion(
            title: 'Mimar / İç Mimar',
            description: 'Estetik ve pratikliği birleştirme',
            suitabilityScore: 93,
          ),
          CareerSuggestion(
            title: 'Emlak Danışmanı',
            description: 'Mülk değerleme ve uzun vadeli yatırım',
            suitabilityScore: 91,
          ),
          CareerSuggestion(
            title: 'Müzisyen / Ses Mühendisi',
            description: 'Duyusal hassasiyet ve sanat',
            suitabilityScore: 88,
          ),
          CareerSuggestion(
            title: 'Bahçıvan / Peyzaj Mimarı',
            description: 'Doğayla çalışma ve somut sonuçlar',
            suitabilityScore: 86,
          ),
        ],
        moneyHabits: '''Boğa, zodyağın en iyi para yöneticisidir. Finansal güvenlik onlar için birinci önceliktir. Tutumlu ama cimri değildirler - kaliteye para harcarlar ama israf etmezler.

Yatırım konusunda muhafazakardırlar. Hisse senetleri yerine gayrimenkul, altın veya sabit getirili yatırımları tercih ederler. Uzun vadeli düşünürler ve ani kararlar vermezler.

Lüks ve kaliteli ürünlere para harcamaktan çekinmezler. Onlar için ucuz ve kötü kalite, uzun vadede daha pahalıya gelir. "Bir kere ağla" felsefesini benimserler.''',
        financialAdvice: [
          'Aşırı muhafazakarlık bazen fırsatları kaçırmanıza neden olabilir',
          'Yatırım portföyünüzü çeşitlendirmeyi düşünün',
          'Lükse harcama yaparken bütçeyi gözden kaçırmayın',
          'Acil durum fonu mutlaka olmalı',
          'Bazen riske girmek gerekebilir',
        ],
      ),

      healthAndWellness: HealthProfile(
        bodyAreas: ['Boyun', 'Boğaz', 'Tiroid', 'Ses telleri', 'Omuzlar'],
        commonIssues: [
          'Tiroid sorunları',
          'Boğaz enfeksiyonları',
          'Boyun ağrıları ve sertliği',
          'Ses problemleri',
          'Kilo kontrolü zorlukları',
          'Metabolizma yavaşlığı',
        ],
        exerciseRecommendations: [
          'Yürüyüş ve hiking',
          'Yoga ve pilates',
          'Yüzme',
          'Dans (özellikle salsa, tango)',
          'Bahçe işleri',
          'Ağırlık antrenmanı (ağır tempoda)',
        ],
        stressManagement: '''Boğa stresi fiziksel rahatlıkla çözer. Masaj, sıcak banyo, aromaterapi onlar için harika stres gidericilerdir. Doğada zaman geçirmek ruhlarını yeniler.

Yemek yemek Boğa için hem zevk hem de stres yönetimi aracıdır. Ancak bu, stresli dönemlerde aşırı yemeye yol açabilir. Bilinçli beslenme pratikleri önemlidir.

Müzik Boğa için güçlü bir şifa aracıdır. Yatıştırıcı melodiler veya sevdikleri şarkılar stresi eritir. Bir enstrüman çalmak veya şarkı söylemek özellikle faydalıdır.''',
        dietaryAdvice: [
          'Metabolizmanızı hızlandıracak gıdalara yönelin',
          'Porsiyonlara dikkat edin',
          'Ağır yemekleri akşam saatlerinde yemeyin',
          'Tiroid sağlığı için iyot içeren gıdalar tüketin',
          'Bol su içerek metabolizmayı destekleyin',
        ],
      ),

      luckyElements: LuckyElements(
        numbers: [2, 6, 15, 24, 33, 42],
        colors: ['Yeşil', 'Pembe', 'Toprak tonları', 'Pastel renkler'],
        days: ['Cuma', 'Pazartesi'],
        gemstones: ['Zümrüt', 'Safir', 'Akuamarin', 'Yeşim'],
        metals: ['Bakır', 'Bronz'],
        flowers: ['Gül', 'Papatya', 'Zambak'],
        direction: 'Güneydoğu',
      ),

      famousPeople: [
        FamousPerson(name: 'Adele', profession: 'Şarkıcı', birthDate: '5 Mayıs 1988'),
        FamousPerson(name: 'Dwayne Johnson', profession: 'Oyuncu, Güreşçi', birthDate: '2 Mayıs 1972'),
        FamousPerson(name: 'Queen Elizabeth II', profession: 'Kraliçe', birthDate: '21 Nisan 1926'),
        FamousPerson(name: 'David Beckham', profession: 'Futbolcu', birthDate: '2 Mayıs 1975'),
        FamousPerson(name: 'Cher', profession: 'Şarkıcı, Oyuncu', birthDate: '20 Mayıs 1946'),
        FamousPerson(name: 'Mustafa Kemal Atatürk', profession: 'Devlet Adamı', birthDate: '19 Mayıs 1881'),
        FamousPerson(name: 'William Shakespeare', profession: 'Yazar', birthDate: '23 Nisan 1564'),
        FamousPerson(name: 'Penelope Cruz', profession: 'Oyuncu', birthDate: '28 Nisan 1974'),
      ],

      mythologyAndSymbolism: '''Boğa takımyıldızı, antik uygarlıklar tarafından büyük önem verilen sembollerden biridir. Yunan mitolojisinde, Zeus'un Europa'yı kaçırmak için dönüştüğü beyaz boğa formunu temsil eder. Bu efsane, güzellik, güç ve aşkın birleşimini simgeler.

Mısır'da Apis boğası kutsal kabul edilir ve bereketin, gücün sembolü olarak tapınılırdı. Sümer medeniyetinde, "Göklerin Boğası" cennetin koruyucusu olarak görülürdü.

Astrolojik olarak Boğa, ilkbaharın tam ortasına denk gelir - doğanın çiçeklendiği, meyvelerin oluşmaya başladığı zaman. Bu nedenle bolluk, verimlilik ve büyümeyle ilişkilendirilir.

Venüs'ün yönetimi, Boğa'ya güzellik takdiri, sanat yeteneği ve aşka olan derin bağlılığı getirir. Venüs aynı zamanda zenginlik ve lüksle de ilişkilidir, bu da Boğa'nın maddi dünyaya olan ilgisini açıklar.''',

      seasonalAdvice: SeasonalAdvice(
        spring: 'Doğum gününüzün zamanı! Yeni başlangıçlar için ideal. Bahçe işleri ve doğayla bağlantı kurun. Finansal hedefler belirleyin.',
        summer: 'Rahatlama ve keyif zamanı. Tatilde kaliteli vakit geçirin. Aşk hayatınızda romantizme odaklanın. Sağlıklı beslenmeye dikkat.',
        autumn: 'Kariyer hamlelerini planlayın. Evle ilgili projeler için uygun. Mali konuları gözden geçirin. Yeni hobiler edinin.',
        winter: 'İç dünyanıza dönün. Sevdiklerinizle kaliteli zaman geçirin. Geleceği planlayın. Konfor ve sıcaklığın tadını çıkarın.',
      ),

      lifeLessons: [
        'Değişim kaçınılmazdır ve büyümenin bir parçasıdır',
        'Maddi güvenlik önemlidir ama tek şey değildir',
        'Esneklik gücün bir göstergesidir',
        'Başkalarını kontrol etmeye çalışmak sizi yorar',
        'Bazen bırakmak, tutmaktan daha güçlüdür',
        'Konfor alanından çıkmak sizi geliştirir',
        'Sahip olduklarınızla kendinizi tanımlamayın',
        'Değer verdiğiniz şeyler için değişebilirsiniz',
      ],
    ),

    // ============== İKİZLER (GEMINI) ==============
    ZodiacSign.gemini: ZodiacDetailedInfo(
      sign: ZodiacSign.gemini,
      overview: '''İkizler burcu, zodyağın üçüncü burcu olarak iletişim, zeka ve çok yönlülüğün simgesidir. 21 Mayıs - 20 Haziran tarihleri arasında doğanlar bu burca aittir. Merkür gezegeninin yönetimindeki bu hava burcu, merak, uyum sağlama ve sosyal becerilerle tanınır.

İkizler insanları zihinsel jimnastik ustalarıdır. Bir konudan diğerine kolayca geçebilir, birden fazla projeyi aynı anda yönetebilir ve her ortama uyum sağlayabilirler. Sıkıcılık onların en büyük düşmanıdır.

Bu burcun sembolü olan İkizler, dual doğayı ve çok yönlülüğü temsil eder. Hava elementi onlara zihinsel çeviklik, iletişim yeteneği ve sosyal uyum verir. Merkür yönetimi ise hız, zeka ve sözel ifade gücü getirir.''',

      personality: PersonalityTraits(
        strengths: [
          'Üstün iletişim becerileri',
          'Çok yönlülük ve uyum sağlama',
          'Hızlı öğrenme yeteneği',
          'Yaratıcı düşünce ve fikirler',
          'Sosyal zeka ve çekicilik',
          'Mizah anlayışı',
          'Merak ve araştırma ruhu',
          'Esneklik ve açık fikirlilik',
          'Entelektüel derinlik',
          'Genç ve dinamik enerji',
        ],
        weaknesses: [
          'Tutarsızlık ve kararsızlık',
          'Yüzeysellik eğilimi',
          'Dikkati dağıtma ve odaklanamama',
          'İki yüzlülük algısı',
          'Dedikodu yapma',
          'Taahhütlerden kaçma',
          'Sabırsızlık',
          'Duygusal mesafe',
          'Manipülasyon eğilimi',
          'Gerginlik ve kaygı',
        ],
        hiddenTraits: [
          'Çift kişilikli görünseler de aslında bütünlük ararlar',
          'Yüzeysel görünseler de derin düşünceler taşırlar',
          'Sosyal görünseler de yalnızlığa ihtiyaç duyarlar',
          'Değişken görünseler de derin bağlılıklar kurabilirler',
          'Rahat görünseler de kaygı ve endişe taşırlar',
        ],
      ),

      loveAndRelationships: LoveProfile(
        generalApproach: '''İkizler aşkta zihinsel uyumu her şeyin üstünde tutar. Onlar için aşk önce kafada başlar - esprili sohbetler, entelektüel tartışmalar, ortak ilgi alanları. Sıkıcı bir partner en büyük kabuslarıdır.

Flört etmekten büyük zevk alırlar. Sosyal kelebek olarak her ortamda ilgi çekerler. Ancak bağlanma konusunda zorlanabilirler - özgürlüklerini kaybetme korkusu güçlüdür.

Çeşitlilik İkizler için cazip. Rutin ilişkiler onları boğar. İdeal partnerleri, sürekli yeni şeyler keşfetmeye açık, bağımsız ve entelektüel birisidir.''',
        compatibleSigns: [
          SignCompatibility(
            sign: ZodiacSign.libra,
            percentage: 94,
            description: 'Mükemmel entelektüel uyum. İki hava burcu birlikte uçuşur. Sohbetleri bitmeyen, sosyal ve eğlenceli bir çift.',
          ),
          SignCompatibility(
            sign: ZodiacSign.aquarius,
            percentage: 92,
            description: 'Bağımsızlık ve entelektüel bağ. Birbirlerinin özgürlüğüne saygı duyar, ufuk açıcı sohbetler yaparlar.',
          ),
          SignCompatibility(
            sign: ZodiacSign.aries,
            percentage: 85,
            description: 'Heyecanlı ve dinamik. Koç\'un enerjisi İkizler\'i harekete geçirir, İkizler\'in zekası Koç\'u büyüler.',
          ),
          SignCompatibility(
            sign: ZodiacSign.leo,
            percentage: 83,
            description: 'Eğlenceli ve sosyal çift. Aslan\'ın sıcaklığı, İkizler\'in çevikliği birlikte harika işler çıkarır.',
          ),
        ],
        challengingSigns: [
          SignCompatibility(
            sign: ZodiacSign.pisces,
            percentage: 52,
            description: 'İkizler\'in mantığı Balık\'ın duygusallığını anlamakta zorlanır. İletişim kopukluğu olabilir.',
          ),
          SignCompatibility(
            sign: ZodiacSign.virgo,
            percentage: 55,
            description: 'İki Merkür yönetimli burç ama çok farklı. Başak\'ın eleştiriciliği İkizler\'i daraltabilir.',
          ),
        ],
        loveAdvice: [
          'Duygusal derinlik, entelektüel bağ kadar önemlidir',
          'Taahhüt korkusunun üstesinden gelin',
          'Partnerinize duygusal olarak da açılın',
          'Tek eşlilik zor olabilir ama imkansız değil',
          'Sabır gösterin - her şey an\'da olmak zorunda değil',
        ],
      ),

      careerAndMoney: CareerProfile(
        strengths: [
          'Yazarlık ve editörlük',
          'Halkla ilişkiler ve iletişim',
          'Satış ve pazarlama',
          'Medya ve gazetecilik',
          'Çoklu görev yönetimi',
          'Ağ kurma (networking)',
          'Dil becerileri',
          'Hızlı adaptasyon',
        ],
        idealCareers: [
          CareerSuggestion(
            title: 'Gazeteci / Yazar',
            description: 'Araştırma, iletişim ve sürekli yeni konular',
            suitabilityScore: 97,
          ),
          CareerSuggestion(
            title: 'Halkla İlişkiler Uzmanı',
            description: 'İletişim becerileri ve sosyal zeka',
            suitabilityScore: 95,
          ),
          CareerSuggestion(
            title: 'Tercüman / Çevirmen',
            description: 'Dil yetenekleri ve kültürler arası köprü',
            suitabilityScore: 93,
          ),
          CareerSuggestion(
            title: 'Sosyal Medya Yöneticisi',
            description: 'Dijital iletişim ve trend takibi',
            suitabilityScore: 91,
          ),
          CareerSuggestion(
            title: 'Öğretmen / Eğitimci',
            description: 'Bilgi paylaşımı ve iletişim',
            suitabilityScore: 88,
          ),
          CareerSuggestion(
            title: 'Stand-up Komedyen / Sunucu',
            description: 'Mizah ve sahne performansı',
            suitabilityScore: 85,
          ),
        ],
        moneyHabits: '''İkizler parayla ilişkisinde tutarsız olabilir. Bir gün tasarruf konusunda kararlıyken, ertesi gün impulsif alışverişler yapabilirler. Finansal disiplin onlar için zordur.

Birden fazla gelir kaynağına ilgi duyarlar. Yan işler, freelance projeler, yatırımlar - tek bir kaynağa bağlı kalmak onlara sıkıcı gelir.

Deneyimlere para harcamayı severler. Seyahat, kurslar, kitaplar, teknolojik aletler - zihinsel uyarı sağlayan her şey bütçelerinde yer bulur.''',
        financialAdvice: [
          'Otomatik tasarruf planı oluşturun',
          'Alışveriş yapmadan önce 24 saat bekleyin',
          'Bütçe uygulaması kullanın',
          'Tek bir finansal hedefe odaklanmayı öğrenin',
          'Finansal danışmanlık almayı düşünün',
        ],
      ),

      healthAndWellness: HealthProfile(
        bodyAreas: ['Akciğerler', 'Kollar', 'Eller', 'Sinir sistemi', 'Omuzlar'],
        commonIssues: [
          'Solunum sistemi sorunları',
          'El ve bilek problemleri (karpal tünel)',
          'Sinirlilik ve gerginlik',
          'Uyku bozuklukları',
          'Kaygı ve panik atak',
          'Dikkat dağınıklığı',
        ],
        exerciseRecommendations: [
          'Tenis ve badminton',
          'Dans (özellikle partner dansları)',
          'Bisiklet',
          'Grup fitness dersleri',
          'Yürüyüş (podcast dinleyerek)',
          'El-göz koordinasyonu gerektiren sporlar',
        ],
        stressManagement: '''İkizler stresi zihinsel aktiviteyle hem artırır hem azaltır. Aşırı düşünme (overthinking) en büyük stres kaynağıdır. Zihni sakinleştiren aktiviteler kritiktir.

Yazı yazmak, günlük tutmak veya blog yazmak stresi azaltır. Düşüncelerini dışa vurmak onlar için terapötiktir. Konuşmak da benzer etki yapar.

Meditasyon başta zor gelebilir çünkü zihinleri sürekli hareket halindedir. Yürüyüş meditasyonu veya guided meditasyon daha uygun olabilir. Nefes egzersizleri panik ataklara karşı çok etkilidir.''',
        dietaryAdvice: [
          'Omega-3 içeren gıdalar sinir sistemi için faydalı',
          'Kafein alımını kontrol edin - sizi daha gergin yapabilir',
          'Düzenli öğün saatleri belirleyin',
          'B vitamini açısından zengin beslenin',
          'Bol su içerek zihinsel netliği koruyun',
        ],
      ),

      luckyElements: LuckyElements(
        numbers: [3, 5, 12, 14, 23, 32],
        colors: ['Sarı', 'Açık mavi', 'Yeşil', 'Turuncu'],
        days: ['Çarşamba', 'Pazar'],
        gemstones: ['Sitrin', 'Akik', 'Kaplan gözü', 'Turkuaz'],
        metals: ['Cıva (sembolik)', 'Gümüş'],
        flowers: ['Lavanta', 'Papatya', 'Orkide'],
        direction: 'Kuzeybatı',
      ),

      famousPeople: [
        FamousPerson(name: 'Marilyn Monroe', profession: 'Aktris', birthDate: '1 Haziran 1926'),
        FamousPerson(name: 'Johnny Depp', profession: 'Aktör', birthDate: '9 Haziran 1963'),
        FamousPerson(name: 'Angelina Jolie', profession: 'Aktris', birthDate: '4 Haziran 1975'),
        FamousPerson(name: 'Kanye West', profession: 'Müzisyen', birthDate: '8 Haziran 1977'),
        FamousPerson(name: 'Natalie Portman', profession: 'Aktris', birthDate: '9 Haziran 1981'),
        FamousPerson(name: 'Che Guevara', profession: 'Devrimci', birthDate: '14 Haziran 1928'),
        FamousPerson(name: 'Bob Dylan', profession: 'Müzisyen', birthDate: '24 Mayıs 1941'),
        FamousPerson(name: 'Tarkan', profession: 'Şarkıcı', birthDate: '17 Ekim 1972'),
      ],

      mythologyAndSymbolism: '''İkizler takımyıldızı, Yunan mitolojisinde Castor ve Pollux ikizlerini temsil eder. Bu kardeşler, biri ölümlü (Castor), diğeri ölümsüz (Pollux) olan yarı tanrılardı. Birbirlerine olan bağlılıkları efsanevidir.

Castor öldüğünde, Pollux kardeşiyle birlikte olmak için ölümsüzlüğünün yarısını paylaştı. Zeus bu fedakarlığı onurlandırarak ikisini de gökyüzüne yerleştirdi. Bu efsane, İkizler'in sadakat, kardeşlik ve ikilik temalarını yansıtır.

Mitolojik olarak Merkür (Hermes), tanrıların habercisi, yolcuların ve tüccarların koruyucusudur. Hız, zeka, iletişim ve geçiş noktalarıyla ilişkilidir. Bu özellikler İkizler karakterinde açıkça görülür.

Astrolojik olarak İkizler, yılın en sosyal ve hareketli dönemini temsil eder. Yazın başlangıcı, okul dönemi sonu, iletişimin yoğunlaştığı zamandır.''',

      seasonalAdvice: SeasonalAdvice(
        spring: 'Yeni projelere başlamak için mükemmel zaman. İletişim ağınızı genişletin. Yeni beceriler öğrenmeye odaklanın.',
        summer: 'Doğum gününüz! Enerjiniz yüksek. Seyahat planları yapın. Sosyal hayatınız zirvededir. Yeni insanlarla tanışın.',
        autumn: 'Daha içe dönük bir dönem. Başladığınız projeleri bitirmeye odaklanın. İlişkileri derinleştirin.',
        winter: 'Kariyer odaklı olun. Yeni yıl hedefleri belirleyin. Aile ve yakın çevreyle vakit geçirin. Okuma ve öğrenme için ideal.',
      ),

      lifeLessons: [
        'Derinlik, genişlik kadar değerlidir',
        'Bitirmek, başlamak kadar önemlidir',
        'Tutarlılık güven inşa eder',
        'Duygular mantık kadar önemlidir',
        'Bazen yavaşlamak gerekir',
        'Odaklanma, başarının anahtarıdır',
        'Söz vermeden önce düşünün',
        'Gerçek bağlar yüzeysel ilişkilerden değerlidir',
      ],
    ),

    // ============== YENGEÇ (CANCER) ==============
    ZodiacSign.cancer: ZodiacDetailedInfo(
      sign: ZodiacSign.cancer,
      overview: '''Yengeç burcu, zodyağın dördüncü burcu olarak duygusal derinlik, aile ve koruyuculuğun simgesidir. 21 Haziran - 22 Temmuz tarihleri arasında doğanlar bu burca aittir. Ay'ın yönetimindeki bu su burcu, empati, sezgi ve annelik içgüdüsüyle tanınır.

Yengeç insanları duygusal dünyanın ustalarıdır. Başkalarının hislerini anında algılayabilir, empati kurabilir ve teselli edebilirler. Yuva onlar için kutsal bir mekandır.

Bu burcun sembolü olan Yengeç, koruyucu kabuğu ve hassas iç dünyayı temsil eder. Su elementi onlara duygusal akışkanlık, sezgi ve derin hisler verir. Ay yönetimi ise döngüsellik, duygu dalgalanmaları ve annelik enerjisi getirir.''',

      personality: PersonalityTraits(
        strengths: [
          'Derin empati ve şefkat',
          'Güçlü sezgi ve önsezi',
          'Sadakat ve bağlılık',
          'Koruyuculuk ve besleyicilik',
          'Yaratıcılık ve hayal gücü',
          'Aile değerlerine bağlılık',
          'Duygusal zeka',
          'Hafıza ve geçmişi anlama',
          'Sanat ve estetik anlayışı',
          'İş bitiricilik (evle ilgili)',
        ],
        weaknesses: [
          'Aşırı duygusallık',
          'Duygu dalgalanmaları',
          'Geçmişe takılma',
          'Manipülasyon eğilimi',
          'Aşırı koruyuculuk',
          'Alınganlık',
          'Pasif agresiflik',
          'Değişime direnç',
          'Kendini kapatma',
          'Karamsar düşünceler',
        ],
        hiddenTraits: [
          'Sert görünebildikleri kadar kırılgandırlar',
          'Kendilerini korumak için mesafe koyabilirler',
          'Terk edilme korkusu derindir',
          'Güçlü oldukları kadar savunmasızdırlar',
          'Kontrol ihtiyaçları aslında güvensizlikten gelir',
        ],
      ),

      loveAndRelationships: LoveProfile(
        generalApproach: '''Yengeç aşkta tamamıyla bağlanır. Yüzeysel ilişkiler onlara göre değildir - ya tam içindeler ya da hiç değil. Duygusal güvenlik onlar için her şeydir.

Romantik ve nostaljiktirler. İlk buluşmanın tarihini, özel anları ve küçük detayları hatırlarlar. Partnerleri için besleyici ve koruyucu bir rol üstlenirler.

Güven inşa etmek zaman alır. Kalplerini kolayca açmazlar ama bir kez açtıklarında sonsuz derinlikte bir sevgi sunarlar. Aile kurmak en büyük hayallerinden biridir.''',
        compatibleSigns: [
          SignCompatibility(
            sign: ZodiacSign.taurus,
            percentage: 96,
            description: 'Mükemmel yuva uyumu. İkisi de güvenlik ve sadakate değer verir. Birlikte huzurlu bir aile kurarlar.',
          ),
          SignCompatibility(
            sign: ZodiacSign.scorpio,
            percentage: 94,
            description: 'Derin su burcu bağı. Birbirlerini ruhsal düzeyde anlarlar. Tutkulu ve yoğun bir ilişki.',
          ),
          SignCompatibility(
            sign: ZodiacSign.pisces,
            percentage: 93,
            description: 'Rüya gibi romantik bağ. Empati ve anlayış doruğunda. Spiritüel uyum.',
          ),
          SignCompatibility(
            sign: ZodiacSign.virgo,
            percentage: 85,
            description: 'Pratik ve duygusal dengenin buluşması. Birbirlerinin eksiklerini tamamlarlar.',
          ),
        ],
        challengingSigns: [
          SignCompatibility(
            sign: ZodiacSign.aries,
            percentage: 45,
            description: 'Koç\'un sertliği Yengeç\'i incitebilir. Farklı hızlarda hareket ederler.',
          ),
          SignCompatibility(
            sign: ZodiacSign.libra,
            percentage: 50,
            description: 'Terazi\'nin sosyalliği Yengeç\'i güvensiz hissettirebilir. İletişim tarzları farklı.',
          ),
        ],
        loveAdvice: [
          'Geçmişi bırakın, bugüne odaklanın',
          'Manipülasyon yerine doğrudan iletişim kurun',
          'Partneri boğmadan sevin',
          'Reddedilme aşkın sonu değil',
          'Kendi ihtiyaçlarınızı da dile getirin',
        ],
      ),

      careerAndMoney: CareerProfile(
        strengths: [
          'İnsan ilişkileri yönetimi',
          'Bakım ve sağlık hizmetleri',
          'Ev ve aile işleri',
          'Yemek ve gastronomi',
          'Tarih ve arşivcilik',
          'Emlak ve mülk yönetimi',
          'Çocuk gelişimi',
          'Psikolojik danışmanlık',
        ],
        idealCareers: [
          CareerSuggestion(
            title: 'Psikolog / Terapist',
            description: 'Empati ve duygusal anlayış',
            suitabilityScore: 97,
          ),
          CareerSuggestion(
            title: 'Hemşire / Sağlık Personeli',
            description: 'Bakım ve şefkat',
            suitabilityScore: 95,
          ),
          CareerSuggestion(
            title: 'Şef / Aşçı',
            description: 'Besleme içgüdüsü ve yaratıcılık',
            suitabilityScore: 93,
          ),
          CareerSuggestion(
            title: 'Öğretmen (İlkokul)',
            description: 'Çocuklarla çalışma ve yetiştirme',
            suitabilityScore: 91,
          ),
          CareerSuggestion(
            title: 'İç Mimar',
            description: 'Ev ve yaşam alanları tasarımı',
            suitabilityScore: 88,
          ),
          CareerSuggestion(
            title: 'Tarihçi / Müze Küratörü',
            description: 'Geçmişe bağlılık ve koruma',
            suitabilityScore: 85,
          ),
        ],
        moneyHabits: '''Yengeç finansal güvenliğe büyük önem verir. Aile için biriktirme içgüdüsü güçlüdür. Cimri değildirler ama savurgan da değillerdir - özellikle zor zamanlara karşı yastık altı yapmaktan hoşlanırlar.

Gayrimenkul yatırımı onlar için çekicidir. Ev sahibi olmak duygusal güvenlik sağlar. Aile mirası ve geleneksel varlıklara değer verirler.

Duygusal harcama yapma eğiliminde olabilirler. Stresli veya üzgün dönemlerde alışveriş teselli olabilir. Bu konuda farkındalık geliştirmeleri önemlidir.''',
        financialAdvice: [
          'Duygusal alışverişe dikkat edin',
          'Uzun vadeli yatırım planı yapın',
          'Aile bütçesini düzenli takip edin',
          'Acil durum fonu mutlaka olmalı',
          'Sigorta ve güvenceler önemlidir',
        ],
      ),

      healthAndWellness: HealthProfile(
        bodyAreas: ['Mide', 'Göğüs', 'Sindirim sistemi', 'Rahim (kadınlarda)', 'Lenf sistemi'],
        commonIssues: [
          'Mide ve sindirim sorunları',
          'Stres kaynaklı yeme bozuklukları',
          'Göğüs hassasiyeti',
          'Su tutma',
          'Depresyon eğilimi',
          'Hormonal dengesizlikler',
        ],
        exerciseRecommendations: [
          'Yüzme (suyun rahatlatıcı etkisi)',
          'Su jimnastiği',
          'Yoga (özellikle restoratif)',
          'Yürüyüş (doğada)',
          'Dans (duygusal ifade)',
          'Bahçecilik',
        ],
        stressManagement: '''Yengeç stresi derinden hisseder ve genellikle fiziksel semptomlarla (mide ağrısı, baş ağrısı) yaşar. Su ve ev ortamı en iyi şifa kaynaklarıdır.

Yemek yapmak terapötik bir aktivitedir. Sevdikleri için yemek hazırlamak hem onları rahatlatır hem de bağ kurmalarını sağlar.

Ağlamak Yengeç için sağlıklı bir duygusal boşalma yoludur. Gözyaşlarını bastırmak stresi artırır. Güvenli bir ortamda duygularını ifade etmeleri önemlidir.''',
        dietaryAdvice: [
          'Sindirim sistemi hassas - probiyotiklere önem verin',
          'Duygusal yemeye dikkat edin',
          'Ev yapımı yemekleri tercih edin',
          'Su içmeyi ihmal etmeyin',
          'Rahatlatıcı çaylar (papatya, rezene) faydalı',
        ],
      ),

      luckyElements: LuckyElements(
        numbers: [2, 7, 11, 16, 20, 27],
        colors: ['Gümüş', 'Beyaz', 'Krem', 'Açık mavi', 'Deniz yeşili'],
        days: ['Pazartesi', 'Perşembe'],
        gemstones: ['İnci', 'Ay taşı', 'Opal', 'Akuamarin'],
        metals: ['Gümüş'],
        flowers: ['Nilüfer', 'Beyaz gül', 'Yasemin'],
        direction: 'Kuzey',
      ),

      famousPeople: [
        FamousPerson(name: 'Lionel Messi', profession: 'Futbolcu', birthDate: '24 Haziran 1987'),
        FamousPerson(name: 'Meryl Streep', profession: 'Aktris', birthDate: '22 Haziran 1949'),
        FamousPerson(name: 'Tom Hanks', profession: 'Aktör', birthDate: '9 Temmuz 1956'),
        FamousPerson(name: 'Frida Kahlo', profession: 'Ressam', birthDate: '6 Temmuz 1907'),
        FamousPerson(name: 'Princess Diana', profession: 'Prenses', birthDate: '1 Temmuz 1961'),
        FamousPerson(name: 'Sezen Aksu', profession: 'Şarkıcı', birthDate: '13 Temmuz 1954'),
        FamousPerson(name: 'Elon Musk', profession: 'Girişimci', birthDate: '28 Haziran 1971'),
        FamousPerson(name: 'Robin Williams', profession: 'Komedyen, Aktör', birthDate: '21 Temmuz 1951'),
      ],

      mythologyAndSymbolism: '''Yengeç takımyıldızı, Yunan mitolojisinde Herakles\'in Lerna Ejderhası ile savaşırken ona saldıran dev yengeci temsil eder. Hera tarafından gönderilen bu yengeç, kahramana sadık kalarak savaştı ve ölümünün ardından gökyüzüne yerleştirildi.

Antik Mısır'da skarab böceği (yengeçe benzer) yeniden doğuşu ve korunmayı simgeliyordu. Birçok kültürde yengeç, anneliği, evi ve korumayı temsil eder.

Ay'ın yönetimi, Yengeç'e derin duygusal döngüsellik verir. Tıpkı Ay'ın evreleri gibi, Yengeç de duygusal inişler ve çıkışlar yaşar. Ay aynı zamanda anne arketipini, geceyi ve bilinçaltını temsil eder.

Astrolojik olarak Yengeç, yazın ortasına ve yılın en uzun gününe (yaz gündönümü) denk gelir. Bu, ışık ve karanlık arasındaki dengeyi, içe dönüşü ve ailenin önemini vurgular.''',

      seasonalAdvice: SeasonalAdvice(
        spring: 'Ev ve bahçe projeleri için ideal. Aile ilişkilerini güçlendirin. Yeni duygusal başlangıçlar mümkün.',
        summer: 'Doğum gününüz! Kendinize odaklanın. Plaj ve su aktiviteleri ideal. Aile tatili planlayın.',
        autumn: 'Kariyer ve dış dünyaya odaklanma zamanı. Ev dekorasyonu projeleri. Kış hazırlıkları.',
        winter: 'İç dünyaya dönüş. Aile ile sıcak anlar. Nostaljik aktiviteler. Kendine bakım zamanı.',
      ),

      lifeLessons: [
        'Geçmiş geçmişte kaldı, bugünü yaşayın',
        'Koruyuculuk kontrol değildir',
        'Kendi ihtiyaçlarınız da önemli',
        'Duygular geçicidir, değişirler',
        'Kabuk her zaman gerekli değil',
        'Reddedilmek son değildir',
        'Bağımsızlık sevgiyi azaltmaz',
        'Değişim büyümenin bir parçasıdır',
      ],
    ),

    // ============== ASLAN (LEO) ==============
    ZodiacSign.leo: ZodiacDetailedInfo(
      sign: ZodiacSign.leo,
      overview: '''Aslan burcu, zodyağın beşinci burcu olarak yaratıcılık, liderlik ve kendini ifadenin simgesidir. 23 Temmuz - 22 Ağustos tarihleri arasında doğanlar bu burca aittir. Güneş'in yönetimindeki bu ateş burcu, karizma, cömertlik ve gösteriş ile tanınır.

Aslan insanları doğal yıldızlardır. Odaya girdiklerinde fark edilir, konuştukları zaman dinlenirler. Yaşam onlar için bir sahne, her gün yeni bir performanstır.

Bu burcun sembolü olan Aslan, kraliyet, güç ve cesaretin evrensel simgesidir. Ateş elementi onlara tutku, yaratıcılık ve sıcaklık verir. Güneş yönetimi ise hayati enerji, özgüven ve merkez olma ihtiyacı getirir.''',

      personality: PersonalityTraits(
        strengths: [
          'Doğal karizma ve liderlik',
          'Cömertlik ve büyükgönüllülük',
          'Yaratıcılık ve sanatsal yetenek',
          'Sadakat ve koruyuculuk',
          'Cesaret ve özgüven',
          'Sıcaklık ve pozitif enerji',
          'Motivasyon ve ilham verme',
          'Eğlence ve neşe yayma',
          'Kararlılık ve azim',
          'Onur ve dürüstlük',
        ],
        weaknesses: [
          'Ego ve kibir',
          'Övgü bağımlılığı',
          'Dikkat çekme ihtiyacı',
          'İnatçılık',
          'Eleştiriye aşırı hassasiyet',
          'Dramatizasyon eğilimi',
          'Bencillik',
          'Otoriterlik',
          'Gösteriş düşkünlüğü',
          'Rekabet takıntısı',
        ],
        hiddenTraits: [
          'Güçlü görünüşlerinin altında onay arayışı yatar',
          'Eleştiri onları sandığınızdan çok derinden yaralar',
          'Sevilmemekten gizlice korkarlar',
          'Başarısızlık onlar için kabul edilemez',
          'Zayıflık göstermek en büyük korkularıdır',
        ],
      ),

      loveAndRelationships: LoveProfile(
        generalApproach: '''Aslan aşkta romantizmin kralıdır. Büyük jestler, görkemli kutlamalar ve heyecan verici maceralar onların tarzıdır. Sevdikleri kişiyi bir tahtın üzerine oturtur ve ona tapar.

Sadakatleri mutlaktır - ama karşılığında da aynı sadakati beklerler. İhanet asla affedilmez. Övgü ve takdir onları mutlu eder; görmezden gelinmek en büyük cezadır.

Gösterişli ve cömert sevgili olan Aslan, partnerini şımartmaktan büyük zevk alır. Ancak ilişkide de lider olmayı beklerler. Güç paylaşımı öğrenmeleri gereken bir derstir.''',
        compatibleSigns: [
          SignCompatibility(
            sign: ZodiacSign.aries,
            percentage: 95,
            description: 'Ateşli tutku. İki güçlü kişilik birbirini tamamlar. Heyecan ve macera eksik olmaz.',
          ),
          SignCompatibility(
            sign: ZodiacSign.sagittarius,
            percentage: 93,
            description: 'Eğlence ve özgürlük birlikteliği. İkisi de hayattan keyif almayı sever.',
          ),
          SignCompatibility(
            sign: ZodiacSign.gemini,
            percentage: 85,
            description: 'Sosyal ve eğlenceli çift. İkizler\'in zekası Aslan\'ı büyüler.',
          ),
          SignCompatibility(
            sign: ZodiacSign.libra,
            percentage: 88,
            description: 'Estetik ve sosyal uyum. Birlikte parıldayan bir çift.',
          ),
        ],
        challengingSigns: [
          SignCompatibility(
            sign: ZodiacSign.taurus,
            percentage: 55,
            description: 'İki inatçı burcun çatışması. Kim taviz verecek?',
          ),
          SignCompatibility(
            sign: ZodiacSign.scorpio,
            percentage: 52,
            description: 'Güç mücadelesi kaçınılmaz. İkisi de kontrolü bırakmak istemez.',
          ),
        ],
        loveAdvice: [
          'Partnerinizin de parlamasına izin verin',
          'Eleştiriyi kişisel almayın',
          'Ego savaşlarından kaçının',
          'Takdir edilmek kadar takdir etmeyi de öğrenin',
          'Kırılganlık göstermek güçsüzlük değil',
        ],
      ),

      careerAndMoney: CareerProfile(
        strengths: [
          'Liderlik ve yönetim',
          'Sahne sanatları ve performans',
          'Yaratıcı yönetmenlik',
          'Motivasyonel konuşma',
          'Marka oluşturma',
          'Organizasyon yönetimi',
          'Eğlence sektörü',
          'Lüks ve moda endüstrisi',
        ],
        idealCareers: [
          CareerSuggestion(
            title: 'CEO / Üst Düzey Yönetici',
            description: 'Doğal liderlik ve vizyon',
            suitabilityScore: 97,
          ),
          CareerSuggestion(
            title: 'Aktör / Performans Sanatçısı',
            description: 'Sahne varlığı ve karizması',
            suitabilityScore: 96,
          ),
          CareerSuggestion(
            title: 'Moda Tasarımcısı',
            description: 'Yaratıcılık ve gösteriş',
            suitabilityScore: 92,
          ),
          CareerSuggestion(
            title: 'Etkinlik Organizatörü',
            description: 'Büyük projeler yönetme ve gösteriş',
            suitabilityScore: 90,
          ),
          CareerSuggestion(
            title: 'YouTuber / İçerik Üreticisi',
            description: 'Dikkat çekme ve performans',
            suitabilityScore: 88,
          ),
          CareerSuggestion(
            title: 'Motivasyonel Konuşmacı',
            description: 'İlham verme ve liderlik',
            suitabilityScore: 87,
          ),
        ],
        moneyHabits: '''Aslan cömertçe harcar ve cömertçe kazanır. Para onlar için statü ve yaşam kalitesinin bir aracıdır. Lüksten hoşlanır ve en iyisine sahip olmak isterler.

Cömertlikleri bazen bütçelerini zorlayabilir. Arkadaşlara hesabı ödemek, pahalı hediyeler almak, kendilerine yatırım yapmak - harcama kalemleri uzundur.

Kariyer yoluyla zenginlik hedeflerler. Pasif gelir yerine aktif kazanç tercih ederler. Başarılarını görünür kılmak isterler.''',
        financialAdvice: [
          'Cömertlik güzel ama bütçeyi aşmayın',
          'Gösteriş için değil, değer için harcayın',
          'Uzun vadeli yatırım planı yapın',
          'Ego alışverişinden kaçının',
          'Finansal danışmanlık almayı düşünün',
        ],
      ),

      healthAndWellness: HealthProfile(
        bodyAreas: ['Kalp', 'Sırt', 'Omurga', 'Kan dolaşımı'],
        commonIssues: [
          'Kalp ve damar sorunları',
          'Sırt ağrıları',
          'Yüksek tansiyon',
          'Aşırı yorgunluk',
          'Stres kaynaklı sorunlar',
          'Ego yaralanmalarından depresyon',
        ],
        exerciseRecommendations: [
          'Dans (özellikle gösterişli stiller)',
          'Tenis ve golf',
          'Fitness ve vücut geliştirme',
          'Yoga (güçlü stiller)',
          'Yüzme',
          'Grup fitness dersleri (liderlik yapabilecekleri)',
        ],
        stressManagement: '''Aslan stresi genellikle takdir edilmemekten veya başarısızlık hissinden gelir. Özgüvenleri sarsıldığında zorlanırlar.

Yaratıcı ifade en iyi stres gidericidir. Resim, müzik, dans, yazı - sanat Aslan\'ın ruhunu besler.

Fiziksel aktivite de kritiktir. Vücutlarını güçlü hissetmek özgüvenlerini artırır. Ancak aşırı rekabetçi ortamlardan kaçınmaları gerekebilir.''',
        dietaryAdvice: [
          'Kalp sağlığı için omega-3 içeren gıdalar',
          'Stres altında aşırı yemekten kaçının',
          'Bol su ve taze meyve-sebze',
          'Alkol ve kafein tüketimini dengeleyin',
          'Kaliteli protein kaynakları tercih edin',
        ],
      ),

      luckyElements: LuckyElements(
        numbers: [1, 5, 9, 14, 19, 23],
        colors: ['Altın', 'Turuncu', 'Sarı', 'Kırmızı', 'Mor'],
        days: ['Pazar', 'Salı'],
        gemstones: ['Yakut', 'Elmas', 'Kehribar', 'Sitrin'],
        metals: ['Altın'],
        flowers: ['Ayçiçeği', 'Kadife çiçeği', 'Gül'],
        direction: 'Güney',
      ),

      famousPeople: [
        FamousPerson(name: 'Barack Obama', profession: 'ABD Eski Başkanı', birthDate: '4 Ağustos 1961'),
        FamousPerson(name: 'Jennifer Lopez', profession: 'Şarkıcı, Aktris', birthDate: '24 Temmuz 1969'),
        FamousPerson(name: 'Madonna', profession: 'Pop Yıldızı', birthDate: '16 Ağustos 1958'),
        FamousPerson(name: 'Napoleon Bonaparte', profession: 'Fransız İmparator', birthDate: '15 Ağustos 1769'),
        FamousPerson(name: 'Whitney Houston', profession: 'Şarkıcı', birthDate: '9 Ağustos 1963'),
        FamousPerson(name: 'Kylie Jenner', profession: 'İş İnsanı', birthDate: '10 Ağustos 1997'),
        FamousPerson(name: 'Mick Jagger', profession: 'Rock Yıldızı', birthDate: '26 Temmuz 1943'),
        FamousPerson(name: 'Daniel Radcliffe', profession: 'Aktör', birthDate: '23 Temmuz 1989'),
      ],

      mythologyAndSymbolism: '''Aslan, insanlık tarihinin en eski ve en güçlü sembollerinden biridir. Antik Mısır'da Sfenks aslan vücutlu, antik Babil'de İştar kapısı aslan figürleriyle süslüydü.

Yunan mitolojisinde Nemea Aslanı, Herakles'in ilk görevi olarak yendiği yenilmez canavar olarak bilinir. Bu aslanın derisi dokunulmaz bir zırh haline gelmiştir.

Güneş, antik zamanlardan beri yaşamın kaynağı ve tanrısal güç olarak görülmüştür. Mısır'da Ra, Roma'da Sol Invictus Güneş tanrılarıydı. Güneş'in yönetimi Aslan burcuna kraliyet enerjisi, hayat verme gücü ve merkez olma özelliği katar.

Astrolojik olarak Aslan, yazın en sıcak günlerine denk gelir. Güneş'in gücünün zirvede olduğu bu dönem, enerji, canlılık ve yaratıcılıkla doludur.''',

      seasonalAdvice: SeasonalAdvice(
        spring: 'Yaratıcı projeler başlatın. Sosyal hayatınızı canlandırın. Yeni hobi edinin. Romantizme açık olun.',
        summer: 'Doğum gününüz! Parlamak için mükemmel zaman. Tatil planları yapın. Kendinizi şımartın.',
        autumn: 'Kariyer odaklı olun. Finansal hedefler belirleyin. Aile ilişkilerine zaman ayırın.',
        winter: 'İç dünyanıza dönün. Yaratıcı projelere odaklanın. Sağlığınıza dikkat edin. Yeni yıl planları yapın.',
      ),

      lifeLessons: [
        'Işığınızı başkalarını gölgelemeden parlayın',
        'Takdir edilmek güzel ama bağımlılık yapmayın',
        'Başarısızlık büyümenin bir parçasıdır',
        'Zayıflık göstermek cesaret ister',
        'Liderlik hizmet etmektir',
        'Ego bazen en büyük düşmanınızdır',
        'Başkalarının başarısı sizin başarınızı azaltmaz',
        'Gerçek güç içten gelir',
      ],
    ),

    // Diğer burçlar için kısaltılmış versiyon (uzunluk sınırı nedeniyle)
    // ============== BAŞAK (VIRGO) ==============
    ZodiacSign.virgo: _createBasicInfo(
      ZodiacSign.virgo,
      'Başak burcu analiz, mükemmeliyetçilik ve hizmetin simgesidir.',
    ),

    // ============== TERAZİ (LIBRA) ==============
    ZodiacSign.libra: _createBasicInfo(
      ZodiacSign.libra,
      'Terazi burcu denge, uyum ve ilişkilerin simgesidir.',
    ),

    // ============== AKREP (SCORPIO) ==============
    ZodiacSign.scorpio: _createBasicInfo(
      ZodiacSign.scorpio,
      'Akrep burcu tutku, dönüşüm ve gizemin simgesidir.',
    ),

    // ============== YAY (SAGITTARIUS) ==============
    ZodiacSign.sagittarius: _createBasicInfo(
      ZodiacSign.sagittarius,
      'Yay burcu macera, özgürlük ve felsefenin simgesidir.',
    ),

    // ============== OĞLAK (CAPRICORN) ==============
    ZodiacSign.capricorn: _createBasicInfo(
      ZodiacSign.capricorn,
      'Oğlak burcu hırs, disiplin ve başarının simgesidir.',
    ),

    // ============== KOVA (AQUARIUS) ==============
    ZodiacSign.aquarius: _createBasicInfo(
      ZodiacSign.aquarius,
      'Kova burcu yenilik, insanlık ve özgünlüğün simgesidir.',
    ),

    // ============== BALIK (PISCES) ==============
    ZodiacSign.pisces: _createBasicInfo(
      ZodiacSign.pisces,
      'Balık burcu empati, hayal gücü ve spiritüelliğin simgesidir.',
    ),
  };

  static ZodiacDetailedInfo _createBasicInfo(ZodiacSign sign, String overview) {
    return ZodiacDetailedInfo(
      sign: sign,
      overview: overview,
      personality: PersonalityTraits(
        strengths: sign.traits.take(5).toList(),
        weaknesses: ['Detaylı bilgi yakında eklenecek'],
        hiddenTraits: ['Detaylı bilgi yakında eklenecek'],
      ),
      loveAndRelationships: LoveProfile(
        generalApproach: 'Detaylı aşk analizi yakında eklenecek.',
        compatibleSigns: [],
        challengingSigns: [],
        loveAdvice: ['Detaylı tavsiyeler yakında eklenecek'],
      ),
      careerAndMoney: CareerProfile(
        strengths: ['Detaylı bilgi yakında eklenecek'],
        idealCareers: [],
        moneyHabits: 'Detaylı finansal analiz yakında eklenecek.',
        financialAdvice: ['Detaylı tavsiyeler yakında eklenecek'],
      ),
      healthAndWellness: HealthProfile(
        bodyAreas: ['Detaylı bilgi yakında eklenecek'],
        commonIssues: ['Detaylı bilgi yakında eklenecek'],
        exerciseRecommendations: ['Detaylı öneriler yakında eklenecek'],
        stressManagement: 'Detaylı stres yönetimi yakında eklenecek.',
        dietaryAdvice: ['Detaylı öneriler yakında eklenecek'],
      ),
      luckyElements: LuckyElements(
        numbers: [1, 7, 13],
        colors: ['Detay yakında'],
        days: ['Detay yakında'],
        gemstones: ['Detay yakında'],
        metals: ['Detay yakında'],
        flowers: ['Detay yakında'],
        direction: 'Detay yakında',
      ),
      famousPeople: [],
      mythologyAndSymbolism: 'Detaylı mitoloji bilgisi yakında eklenecek.',
      seasonalAdvice: SeasonalAdvice(
        spring: 'Detaylı tavsiye yakında',
        summer: 'Detaylı tavsiye yakında',
        autumn: 'Detaylı tavsiye yakında',
        winter: 'Detaylı tavsiye yakında',
      ),
      lifeLessons: ['Detaylı dersler yakında eklenecek'],
    );
  }
}

// ==================== DATA MODELS ====================

class ZodiacDetailedInfo {
  final ZodiacSign sign;
  final String overview;
  final PersonalityTraits personality;
  final LoveProfile loveAndRelationships;
  final CareerProfile careerAndMoney;
  final HealthProfile healthAndWellness;
  final LuckyElements luckyElements;
  final List<FamousPerson> famousPeople;
  final String mythologyAndSymbolism;
  final SeasonalAdvice seasonalAdvice;
  final List<String> lifeLessons;

  ZodiacDetailedInfo({
    required this.sign,
    required this.overview,
    required this.personality,
    required this.loveAndRelationships,
    required this.careerAndMoney,
    required this.healthAndWellness,
    required this.luckyElements,
    required this.famousPeople,
    required this.mythologyAndSymbolism,
    required this.seasonalAdvice,
    required this.lifeLessons,
  });
}

class PersonalityTraits {
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> hiddenTraits;

  PersonalityTraits({
    required this.strengths,
    required this.weaknesses,
    required this.hiddenTraits,
  });
}

class LoveProfile {
  final String generalApproach;
  final List<SignCompatibility> compatibleSigns;
  final List<SignCompatibility> challengingSigns;
  final List<String> loveAdvice;

  LoveProfile({
    required this.generalApproach,
    required this.compatibleSigns,
    required this.challengingSigns,
    required this.loveAdvice,
  });
}

class SignCompatibility {
  final ZodiacSign sign;
  final int percentage;
  final String description;

  SignCompatibility({
    required this.sign,
    required this.percentage,
    required this.description,
  });
}

class CareerProfile {
  final List<String> strengths;
  final List<CareerSuggestion> idealCareers;
  final String moneyHabits;
  final List<String> financialAdvice;

  CareerProfile({
    required this.strengths,
    required this.idealCareers,
    required this.moneyHabits,
    required this.financialAdvice,
  });
}

class CareerSuggestion {
  final String title;
  final String description;
  final int suitabilityScore;

  CareerSuggestion({
    required this.title,
    required this.description,
    required this.suitabilityScore,
  });
}

class HealthProfile {
  final List<String> bodyAreas;
  final List<String> commonIssues;
  final List<String> exerciseRecommendations;
  final String stressManagement;
  final List<String> dietaryAdvice;

  HealthProfile({
    required this.bodyAreas,
    required this.commonIssues,
    required this.exerciseRecommendations,
    required this.stressManagement,
    required this.dietaryAdvice,
  });
}

class LuckyElements {
  final List<int> numbers;
  final List<String> colors;
  final List<String> days;
  final List<String> gemstones;
  final List<String> metals;
  final List<String> flowers;
  final String direction;

  LuckyElements({
    required this.numbers,
    required this.colors,
    required this.days,
    required this.gemstones,
    required this.metals,
    required this.flowers,
    required this.direction,
  });
}

class FamousPerson {
  final String name;
  final String profession;
  final String birthDate;

  FamousPerson({
    required this.name,
    required this.profession,
    required this.birthDate,
  });
}

class SeasonalAdvice {
  final String spring;
  final String summer;
  final String autumn;
  final String winter;

  SeasonalAdvice({
    required this.spring,
    required this.summer,
    required this.autumn,
    required this.winter,
  });
}
