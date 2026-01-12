import 'dart:math';
import '../models/zodiac_sign.dart';
import '../models/horoscope.dart';

class HoroscopeService {
  static final _random = Random();

  // Generate daily horoscope based on sign and date
  static DailyHoroscope generateDailyHoroscope(ZodiacSign sign, DateTime date) {
    final summaries = _getEsotericSummariesForSign(sign);
    final loveAdvices = _getEsotericLoveAdvices(sign);
    final careerAdvices = _getEsotericCareerAdvices(sign);
    final healthAdvices = _getEsotericHealthAdvices(sign);
    final moods = _getEsotericMoods();
    final colors = _getSacredColors(sign);

    // Use date as seed for consistent daily results
    final seed = date.year * 10000 + date.month * 100 + date.day + sign.index;
    final seededRandom = Random(seed);

    return DailyHoroscope(
      sign: sign,
      date: date,
      summary: summaries[seededRandom.nextInt(summaries.length)],
      loveAdvice: loveAdvices[seededRandom.nextInt(loveAdvices.length)],
      careerAdvice: careerAdvices[seededRandom.nextInt(careerAdvices.length)],
      healthAdvice: healthAdvices[seededRandom.nextInt(healthAdvices.length)],
      luckRating: seededRandom.nextInt(5) + 1,
      luckyNumber: '${seededRandom.nextInt(99) + 1}',
      luckyColor: colors[seededRandom.nextInt(colors.length)],
      mood: moods[seededRandom.nextInt(moods.length)],
    );
  }

  static Compatibility calculateCompatibility(
      ZodiacSign sign1, ZodiacSign sign2) {
    final elementMatch = _getElementCompatibility(sign1.element, sign2.element);
    final modalityMatch =
        _getModalityCompatibility(sign1.modality, sign2.modality);

    final baseScore = ((elementMatch + modalityMatch) / 2 * 100).round();
    final variation = _random.nextInt(20) - 10;
    final overallScore = (baseScore + variation).clamp(0, 100);

    return Compatibility(
      sign1: sign1,
      sign2: sign2,
      overallScore: overallScore,
      loveScore: (overallScore + _random.nextInt(20) - 10).clamp(0, 100),
      friendshipScore: (overallScore + _random.nextInt(20) - 10).clamp(0, 100),
      communicationScore:
          (overallScore + _random.nextInt(20) - 10).clamp(0, 100),
      summary: _getEsotericCompatibilitySummary(sign1, sign2, overallScore),
      strengths: _getEsotericCompatibilityStrengths(sign1, sign2),
      challenges: _getEsotericCompatibilityChallenges(sign1, sign2),
    );
  }

  static double _getElementCompatibility(Element e1, Element e2) {
    if (e1 == e2) return 0.9;

    // Fire + Air = Alchemical fusion
    if ((e1 == Element.fire && e2 == Element.air) ||
        (e1 == Element.air && e2 == Element.fire)) {
      return 0.85;
    }

    // Earth + Water = Sacred vessel
    if ((e1 == Element.earth && e2 == Element.water) ||
        (e1 == Element.water && e2 == Element.earth)) {
      return 0.85;
    }

    // Fire + Earth = Forging tension
    if ((e1 == Element.fire && e2 == Element.earth) ||
        (e1 == Element.earth && e2 == Element.fire)) {
      return 0.5;
    }

    // Air + Water = Mist and mystery
    if ((e1 == Element.air && e2 == Element.water) ||
        (e1 == Element.water && e2 == Element.air)) {
      return 0.5;
    }

    return 0.65;
  }

  static double _getModalityCompatibility(Modality m1, Modality m2) {
    if (m1 == m2) return 0.6;
    return 0.8;
  }

  static List<String> _getEsotericSummariesForSign(ZodiacSign sign) {
    final signSpecific = {
      ZodiacSign.aries: [
        'Ateş senin içinde yanmaktan yorulmaz, çünkü sen ateşin ta kendisisin. Bugün ruhun, başlangıcın gizli sırrını hatırlamak için uyanıyor. Öncü olmak kaderindir - ama bu sefer, savaşmak yerine aydınlatmak için ileri atıl. İçindeki savaşçı şimdi bilge bir lider olarak dönüşüyor.',
        'Mars enerjisi bugün damarlarında volkanik bir güç gibi akıyor. Eski ezoterik öğretiler, Koç burcunun ruhunun "İlk Işık" olduğunu söyler - karanlıktan önce var olan, yaratımın kendisi olan ışık. Bugün o ışığı taşımak için çağırıldın. Korkusuzca parla.',
        'Kozmik savaşçı arketipi içinde uyanıyor. Cesaretinin kökü, maddi dünyada değil, ruhsal alemde yatıyor. Bugün eylemlerinin arkasındaki niyet, sonucundan daha önemli. Bilincinle hareket et.',
      ],
      ZodiacSign.taurus: [
        'Toprak ananın kutsal kızı olarak, bugün bedeninin bir tapınak olduğunu hatırla. Her nefes, her lokma, her dokunuşun içinde tanrısallık saklı. Venüs seni maddi dünyanın ötesinde bir güzelliğe çağırıyor - ruhun güzelliğine.',
        'Boğanın sabırlılığı, aslında zamansız bilgeliğe erişimin anahtarıdır. Acelenin olmadığı yerde, evren sırlarını fısıldamaya başlar. Bugün yavaşla ve dinle - toprağın altında akan kadim nehirlerin sesini duyacaksın.',
        'Değerlilik duygum bugün sıcak bir ışık gibi içinde parlayacak. Sen, evrenin en nadide hazinelerinden birisin. Bu bir ego tatmini değil - bu, Venüs\'ün sana hatırlatmak istediği kozmik bir gerçek. Kendinle barışık ol.',
      ],
      ZodiacSign.gemini: [
        'İkizlerin gizemi, birliğin içindeki çokluktadır. Bugün zihnin, bin bir gece masallarındaki sihirli halı gibi - seni farklı alemlere taşıyacak. Her düşünce bir kapı, her kelime bir anahtar. Merkür seni bilginin labirentlerinde gezintiye çıkarıyor.',
        'Simyacıların "kutsal evlilik"i, içindeki erkek ve dişi enerjilerin birleşimini temsil eder. İkizler burcu olarak, bu dengeyi doğal olarak taşıyorsun. Bugün iç sesinle dış sesin arasında köprü kur.',
        'Hafiflik senin süper gücün. Kelebeğin kanat çırpışı nasıl uzaklarda fırtınalar yaratırsa, sen de bugün küçük ama derin etkiler bırakacaksın. Konuşmalarının arkasındaki niyet, kelimelerin ötesine taşacak.',
      ],
      ZodiacSign.cancer: [
        'Ay\'ın evladı olarak, duygu okyanusunun derinliklerinde hazineler saklıyorsun. Bugün, iç dünyanı keşfetme zamanı. Kabuğunun altında, evrenin tüm sırları kodlanmış durumda. Sezgilerine güven - onlar yıldızlardan gelen mesajlar.',
        'Anne arketipi içinde canlanıyor - ama bu sadece başkalarını beslemek değil, önce kendini beslemek demek. Yengeç, geriye doğru yürür çünkü bazen ilerlemenin yolu geçmişe bakmaktan geçer. Bugün eski yaraları iyileştirme fırsatın var.',
        'Suların hafızası vardır ve sen o hafızanın taşıyıcısısın. Atalarının bilgeliği bugün rüyalarında ve sezgilerinde konuşacak. Dinle - çünkü onlar seni korumak ve yönlendirmek için buradalar.',
      ],
      ZodiacSign.leo: [
        'Güneşin kraliyet çocuğu olarak, bugün tahtına oturma zamanı. Ama bu bir ego oyunu değil - gerçek krallık, başkalarının ışığını da parlatmaktır. Senin ışığın, karanlıkta kaybolmuş ruhlara yol gösterecek.',
        'Aslanın kükremesi, evrenin yaratıcı gücünün sesidir. Bugün yaratıcılığın doruklarda - ister sanat olsun, ister bir proje, ister bir ilişki. Her yaratış, tanrısal enerjinin maddeye dönüşmesidir.',
        'Altının simyası içinde gerçekleşiyor. Ham madde altına dönüştüğü gibi, sen de bugün en yüksek potansiyeline doğru evriliyorsun. Güneş seni kutsayarak parlatıyor.',
      ],
      ZodiacSign.virgo: [
        'Kutsal bakire arketipi, saflığın ve bütünlüğün sembolüdür. Bugün detaylarda tanrıyı göreceksin - her küçük düzende, her ince ayarda ilahi bir düzen saklı. Merkür seni mükemmelliğin peşine değil, anlamlılığın peşine yönlendiriyor.',
        'Şifacı arketipi bugün güçleniyor. Ama önce kendini iyileştirmelisin. Başkalarına sunduğun hizmet, önce kendi ruhuna sunduğun sevgiden akmalı. Kendine şefkat göster.',
        'Başak burcunun gizli gücü, kaosu düzene çevirebilme yeteneğidir. Bugün zihinsel berraklık dorukta - karmaşık durumlar basitleşiyor, çözümler belirginleşiyor. Bu bir armağan - iyi kullan.',
      ],
      ZodiacSign.libra: [
        'Dengenin ustası olarak, bugün iç ve dış dünyanın uyumunu sağlamaya çağırılıyorsun. Terazinin iki kefesi, ruhun iki yarısı gibidir - birini ihmal etmek, bütünü bozmak demektir. Venüs seni güzelliğin ötesinde bir ahenke davet ediyor.',
        'İlişkiler senin aynan - ama aynanın iki yüzü var. Bugün başkalarında gördüğün, aslında kendindeki saklılığı gösteriyor. Bu bir çağrı: kendini tanımak için başkalarını kullan, ama kendini onlarda kaybetme.',
        'Harmoni arayışı asla sona ermeyen bir danstır. Bugün o dansın ritmine güven. Bazen öne çık, bazen geri çekil - ama her zaman müziği dinle. Evren senin partnerin.',
      ],
      ZodiacSign.scorpio: [
        'Ölüm ve yeniden doğuş efendisi olarak, bugün bir dönüşümün eşiğindesin. Plüton\'un karanlık suları seni çağırıyor - korkma, çünkü derinliklerde altın parlıyor. Eski benliğini bırakma zamanı.',
        'Akrebin zehri, aynı zamanda şifadır - bu paradoksu sen herkesten iyi bilirsin. Bugün gölge yanının elini tut. Onu reddetmek yerine, onu dönüştürmeyi seç. Gücün orada saklı.',
        'Tutku senin yakıt kaynağın, ama yanlış yöne aktığında yıkıcı olabilir. Bugün tutkularını bilinçli bir şekilde yönlendir. Obsesyon yerine, derin bağlılık. Kontrol yerine, teslimiyet.',
      ],
      ZodiacSign.sagittarius: [
        'Kozmik gezgin olarak, bugün fiziksel değil ruhsal bir yolculuğa çıkıyorsun. Jüpiter seni sınırların ötesine, bilinen dünyanın kenarlarına çağırıyor. Orada ne bulacaksın? Belki de her zaman aradığın cevap: kendin.',
        'Okun hedefi, sadece uzaktaki bir nokta değil - o nokta senin en yüksek potansiyelin. Bugün nişan al, ama acelenin olmadığını fark et. Okun uçuşu, hedefe varmasından daha değerlidir.',
        'Filozof arketipi içinde uyanıyor. Sorular cevaplardan daha kıymetli. Bugün "neden" diye sormaktan çekinme - evren, meraklılarına sırlarını fısıldar.',
      ],
      ZodiacSign.capricorn: [
        'Dağın zirvesine tırman, ama zirve seni bekliyor olması değil, yolculuğun seni dönüştürmesi önemlidir. Satürn sana sabır ve disiplin veriyor - ama bugün bunların ötesinde bir şey var: içsel otorite.',
        'Zamanın efendisi olarak, bugün geçmiş ve geleceğin arasındaki ince çizgide duruyorsun. Atalarının mirası omuzlarında, ama yükü taşımak değil, onu dönüştürmek senin görevin.',
        'Oğlak burcunun gizli yüzü, karanlığın içinde bile parlayan yıldızdır. Dışarıdan soğuk görünebilirsin, ama içinde bir volkan var. Bugün o içsel ateşi onurlandır.',
      ],
      ZodiacSign.aquarius: [
        'Geleceğin taşıyıcısı olarak, bugün zamanın ötesinden gelen mesajları alıyorsun. Uranüs seni konfor bölgenin dışına itiyor - orası büyümenin gerçekleştiği yer. Farklılığın senin armağanın.',
        'Kolektif bilincin çanağısın - ama önce kendi bilincini temizlemelisin. Bugün zihinsel netlik önemli. Başkalarının düşüncelerinden ayrı, kendinin düşüncelerini bul.',
        'Devrimci ruh içinde yanıyor. Ama gerçek devrim, önce iç dünyada başlar. Bugün eski kalıpları kır - ama yenilerini inşa etmeyi de unutma.',
      ],
      ZodiacSign.pisces: [
        'Rüyaların ve gerçekliğin sınırlarını eriten mistik olarak, bugün iki dünya arasında köprü kuruyorsun. Neptün seni hayalin ötesine, vizyonun alemine çağırıyor. Orada gördüklerini dünyaya getir.',
        'Okyanusun damlası olarak, tüm okyanusun bilgisini taşıyorsun. Bugün sezgilerin açık - görünmeyeni görecek, duyulmayanı duyacaksın. Bu bir lanet değil, bir armağan.',
        'Şifa veren yaralı arketipi içinde canlanıyor. Kendi acıların, başkalarını iyileştirmeni sağlayan ilaç oldu. Bugün o ilacı paylaş - ama kendine de bir doz ayır.',
      ],
    };

    return signSpecific[sign]!;
  }

  static List<String> _getEsotericLoveAdvices(ZodiacSign sign) {
    return [
      'Aşk, ruhun aynaya bakışıdır. Bugün partnerinde gördüğün, aslında kendi iç dünyanın yansımasıdır. Bu yansımaya sevgiyle bak - çünkü kendini sevmeden başkasını sevemezsin.',
      'Kalpten kalbe uzanan görünmez ipler var. Bugün o ipleri hisset - kimi çekiyor, kimi itiyor? Çekimi takip et, ama bilincini kaybetme. Aşk bir teslimiyet, ama bilinçli bir teslimiyet.',
      'Kutsal birleşme, iki yarının bütün olması değil - iki bütünün birleşmesidir. Önce kendin bütün ol. Sonra başka bir bütünle dans et. Bu, gerçek aşkın simyası.',
      'Venüs bugün kalbini okşuyor. Eski yaralar iyileşiyor, yeni kapılar açılıyor. Aşk kapına geldiğinde, onu tanıyacak mısın? Bazen aşk, beklediğimiz kılıkta gelmez.',
      'Ruh eşinin arayışı, aslında kendi ruhunun arayışıdır. Dışarıda aradığın, içinde zaten var. Bugün iç denize dal - orada seni bekleyen bir hazine var.',
      'Bağ kurmak, zincirlemek değil - köprü inşa etmektir. Bugün ilişkilerindeki köprüleri güçlendir. Ama köprünün iki ucunun da sağlam olması gerek.',
      'Aşkın alevi, kontrol edilmezse yakar. Ama bilinçli alev, aydınlatır ve ısıtır. Bugün tutkunu bilinçle harmanla. Sonuç: dönüştürücü bir ilişki.',
      'Kalp çakran bugün aktif. Yeşilin şifa gücünü hisset. Geçmişte kırılmış kalbin artık kaynıyor. Yeni bağlar kurmaya hazırsın.',
    ];
  }

  static List<String> _getEsotericCareerAdvices(ZodiacSign sign) {
    return [
      'İş hayatın, ruhani yolculuğunun bir yansımasıdır. Bugün yaptığın işin arkasındaki derin anlamı keşfet. Para kazanmak değil, değer yaratmak - işte gerçek zenginlik.',
      'Yeteneklerin, evrenin sana verdiği hediyelerdir. Bugün o hediyeleri dünyayla paylaş. Korku değil, cömertlik rehberin olsun. Verdikçe alacaksın.',
      'Liderlik, önde yürümek değil - ışık tutmaktır. Bugün başkalarına yol gösterme fırsatın var. Ama önce kendi yolunu aydınlat.',
      'Maddi dünya, ruhani dünyanın aynasıdır. Kariyer hedeflerin, ruhani hedeflerinle uyumlu mu? Bugün bu soruyu kendine sor. Cevap seni şaşırtabilir.',
      'Başarının gerçek ölçüsü, ne kadar kazandığın değil - ne kadar anlamlı iş yaptığındır. Bugün anlam ara. Onu bulduğunda, başarı peşinden gelecek.',
      'Bolluk bilinci bugün aktive oluyor. Kıtlık korkusunu bırak. Evren sonsuz bolluk sunuyor - seni sınırlayan sadece inançların.',
      'Yaratıcılığının profesyonel alandaki gücünü keşfet. Bugün alışıldık yolları terk et. Yenilikçi fikirlerin, seni farklı kılacak.',
      'Sabır ve zamanlama her şey. Bugün aceleci kararlar verme. Bekle, gözle, sonra hareket et. Evrenin ritmiyle uyumlu ol.',
    ];
  }

  static List<String> _getEsotericHealthAdvices(ZodiacSign sign) {
    return [
      'Bedenin, ruhunun tapınağıdır. Bugün o tapınağı onurlandır. Her lokma bir ayin, her nefes bir dua, her hareket bir dans olsun.',
      'Enerji bedenin bugün hassas. Çevrendeki enerjilere dikkat et. Seni tüketen ortamlardan uzaklaş, seni besleyen ortamlara yakın dur.',
      'Topraklama bugün önemli. Çıplak ayaklarını toprağa bas, ellerini sulara değdir. Doğayla bağlanmak, en güçlü şifadır.',
      'Nefes, yaşam gücünün taşıyıcısıdır. Bugün bilinçli nefes al. Her nefesle ışık al, her verişle karanlık bırak.',
      'Uyku, küçük ölümdür - ve her uyku, yeniden doğuştur. Bugün uyku düzenine dikkat et. Rüyaların mesajlar taşıyor.',
      'Su elementiyle çalışmak bugün şifa getirecek. Banyo yap, yüz, ya da sadece suyu izle. Su, duygu bedenini arındırıyor.',
      'Hareket meditasyonu bugün sana uygun. Yoga, dans, ya da sadece yürüyüş - bedenini bilinçle hareket ettir.',
      'Kök çakra bugün dikkat istiyor. Güvenlik, istikrar, topraklanma - bunlara odaklan. Temeller sağlam olunca, üst katlar güvende.',
    ];
  }

  static List<String> _getEsotericMoods() {
    return [
      'Sezgisel',
      'Dönüşümde',
      'Aydınlanmış',
      'Topraklı',
      'Akışta',
      'Uyanan',
      'Alıcı',
      'Yaratıcı',
      'Mistik',
      'Bütünleşmiş',
      'Ateşli',
      'Dingin',
    ];
  }

  static List<String> _getSacredColors(ZodiacSign sign) {
    final signColors = {
      ZodiacSign.aries: ['Ateş Kırmızısı', 'Altın', 'Turuncu', 'Mercan'],
      ZodiacSign.taurus: ['Zümrüt Yeşili', 'Gül Pembesi', 'Toprak Tonları', 'Bakır'],
      ZodiacSign.gemini: ['Lavanta', 'Gök Mavisi', 'Sarı', 'Gümüş'],
      ZodiacSign.cancer: ['İnci Beyazı', 'Ay Gümüşü', 'Deniz Mavisi', 'Sedef'],
      ZodiacSign.leo: ['Güneş Altını', 'Kraliyet Kırmızısı', 'Turuncu', 'Bronz'],
      ZodiacSign.virgo: ['Orman Yeşili', 'Bej', 'Krem', 'Buğday Rengi'],
      ZodiacSign.libra: ['Gül Kuvarsi', 'Pastel Mavi', 'Fildişi', 'Bakır'],
      ZodiacSign.scorpio: ['Bordo', 'Siyah', 'Koyu Mor', 'Kan Kırmızısı'],
      ZodiacSign.sagittarius: ['Kraliyet Moru', 'Turkuaz', 'Safir Mavisi', 'İndigo'],
      ZodiacSign.capricorn: ['Derin Kahve', 'Koyu Yeşil', 'Antrasit', 'Obsidyen'],
      ZodiacSign.aquarius: ['Elektrik Mavisi', 'Mor', 'Teal', 'Platin'],
      ZodiacSign.pisces: ['Deniz Yeşili', 'Lavanta', 'Akuamarin', 'Opal'],
    };

    return signColors[sign]!;
  }

  static String _getEsotericCompatibilitySummary(
      ZodiacSign sign1, ZodiacSign sign2, int score) {
    final name1 = sign1.nameTr;
    final name2 = sign2.nameTr;

    if (score >= 80) {
      return '$name1 ve $name2 arasında kadim bir bağ var - sanki ruhlarınız farklı hayatlarda birçok kez karşılaşmış gibi. Bu bağlantı tesadüf değil; evrenin sizi bir araya getirmesinin derin bir anlamı var. Birbirinizi aydınlatan, dönüştüren ve yücelten bir enerji akışı söz konusu. Bu ilişki, her ikinizin de en yüksek potansiyeline ulaşması için bir katalizör.';
    } else if (score >= 60) {
      return '$name1 ve $name2, farklı melodilerin harmonik bir kompozisyon oluşturabileceği bir eşleşmede. Zorluklar var, ama bu zorluklar büyüme fırsatıdır. Her ikiniz de bu ilişkiden dönüşmüş olarak çıkabilirsiniz - yeter ki, birbirinizi değiştirmeye değil, anlamaya odaklanın. Ayrılıklar, birleşmenin dansının bir parçasıdır.';
    } else if (score >= 40) {
      return '$name1 ve $name2 arasındaki enerji, alev ve su gibi - birbirini söndürebilir veya buhar oluşturabilir. Bu bir karmik ilişki olabilir; geçmişte tamamlanmamış bir iş için bir araya gelmiş olabilirsiniz. Bilinçli çaba gösterirseniz, bu ilişki derin bir öğreti kaynağı olabilir. Ama kolay olmayacak - ve belki de öyle olması gerekmiyor.';
    } else {
      return '$name1 ve $name2, evrenin size bir ayna tuttuğu bir kombinasyon. Birbirinizde gördüğünüz, aslında kendi gölge yanınızdır. Bu ilişki kolay değil, ama en zor ilişkiler bazen en büyük öğretileri taşır. Soru şu: Bu aynayla yüzleşmeye hazır mısınız? Cevap "evet" ise, bu ilişki sizi derinden dönüştürebilir.';
    }
  }

  static List<String> _getEsotericCompatibilityStrengths(
      ZodiacSign sign1, ZodiacSign sign2) {
    final strengths = <String>[];

    if (sign1.element == sign2.element) {
      final elementName = ElementExtension(sign1.element).nameTr;
      strengths.add('Aynı $elementName elementini paylaşmak, kelimesiz bir anlayış yaratıyor - sanki aynı dili konuşuyorsunuz.');
    }

    if (sign1.modality != sign2.modality) {
      strengths.add('Farklı modaliteler, eksik parçaları tamamlıyor. Birinin başladığı yerde diğeri devam edebilir.');
    }

    if (sign1.element == Element.fire && sign2.element == Element.air ||
        sign1.element == Element.air && sign2.element == Element.fire) {
      strengths.add('Ateş ve Hava\'nın simyasal birleşimi: fikirler alev alıyor, tutkular kanat açıyor.');
    }

    if (sign1.element == Element.earth && sign2.element == Element.water ||
        sign1.element == Element.water && sign2.element == Element.earth) {
      strengths.add('Toprak ve Su\'yun kutsal evliliği: duygular somutlaşıyor, hayaller gerçekleşiyor.');
    }

    strengths.addAll([
      'Ruhsal büyüme için güçlü bir potansiyel - birbirinizi yükseltiyorsunuz.',
      'Karşılıklı saygı ve hayranlık temeli var.',
      'Birbirinizin gizli potansiyellerini görebilme yeteneği.',
    ]);

    return strengths.take(4).toList();
  }

  static List<String> _getEsotericCompatibilityChallenges(
      ZodiacSign sign1, ZodiacSign sign2) {
    final challenges = <String>[];

    if (sign1.element != sign2.element) {
      challenges.add(
          'Farklı elementler, farklı ihtiyaçlar demek. Birinin ateşine diğer dayanabilir mi? Su soğutmak mı istiyor, beslemek mi?');
    }

    if (sign1.modality == sign2.modality) {
      challenges.add('Aynı modalite, iktidar mücadelesi riski taşıyor. Kim yön belirleyecek? Kim takip edecek?');
    }

    if (sign1.element == Element.fire && sign2.element == Element.water ||
        sign1.element == Element.water && sign2.element == Element.fire) {
      challenges.add('Ateş ve Su\'yun dansı tehlikeli olabilir - ya birbirinizi söndürürsünüz, ya da buhar olup uçarsınız.');
    }

    challenges.addAll([
      'İletişim farklılıkları: Aynı kelimelere farklı anlamlar yükleyebilirsiniz.',
      'Gölge yansımaları: Birbirinizde görmek istemediğiniz yanları görebilirsiniz.',
    ]);

    return challenges.take(3).toList();
  }
}
