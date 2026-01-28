/// Vedic Jyotish Content - Kadim Hint Astrolojisi ve Tantrik Bilgelik
/// Navagraha, Nakshatra, Dasha, Yoga ve Ezoterik Uygulamalar
/// 2500+ satır derin mistik içerik
library;

// ════════════════════════════════════════════════════════════════════════════
// MODELS - VERİ MODELLERİ
// ════════════════════════════════════════════════════════════════════════════

/// Navagraha (9 Gezegen) Modeli
class Graha {
  final String sanskritName;
  final String turkishName;
  final String deity;
  final String mantra;
  final String beejMantra;
  final String yantraDescription;
  final String gemstone;
  final String alternativeGemstone;
  final String day;
  final String color;
  final List<String> bodyParts;
  final String spiritualLesson;
  final String tantricSignificance;
  final String pujaRitual;
  final String mythology;
  final int mantraCount;
  final String metal;
  final String direction;
  final String taste;
  final String season;
  final List<String> signRulership;
  final String exaltation;
  final String debilitation;
  final String moolaTrikona;
  final String element;
  final String guna;
  final String caste;
  final String nature;
  final String gender;
  final String cabinet;
  final String dlessonAdvanced;

  const Graha({
    required this.sanskritName,
    required this.turkishName,
    required this.deity,
    required this.mantra,
    required this.beejMantra,
    required this.yantraDescription,
    required this.gemstone,
    required this.alternativeGemstone,
    required this.day,
    required this.color,
    required this.bodyParts,
    required this.spiritualLesson,
    required this.tantricSignificance,
    required this.pujaRitual,
    required this.mythology,
    required this.mantraCount,
    required this.metal,
    required this.direction,
    required this.taste,
    required this.season,
    required this.signRulership,
    required this.exaltation,
    required this.debilitation,
    required this.moolaTrikona,
    required this.element,
    required this.guna,
    required this.caste,
    required this.nature,
    required this.gender,
    required this.cabinet,
    required this.dlessonAdvanced,
  });
}

/// Nakshatra (27 Ay Konağı) Modeli
class Nakshatra {
  final int number;
  final String name;
  final String meaning;
  final String rulingDeity;
  final String rulingPlanet;
  final String symbol;
  final String shakti;
  final String nature;
  final String gana;
  final String animal;
  final String bird;
  final String tree;
  final String guna;
  final String tattva;
  final String caste;
  final String gender;
  final String temperament;
  final String primaryMotivation;
  final String bodyPart;
  final String tantricPractice;
  final String sexualEnergy;
  final List<String> compatibleNakshatras;
  final String remedy;
  final String deepMeaning;
  final String spiritualPath;
  final List<String> pada;

  const Nakshatra({
    required this.number,
    required this.name,
    required this.meaning,
    required this.rulingDeity,
    required this.rulingPlanet,
    required this.symbol,
    required this.shakti,
    required this.nature,
    required this.gana,
    required this.animal,
    required this.bird,
    required this.tree,
    required this.guna,
    required this.tattva,
    required this.caste,
    required this.gender,
    required this.temperament,
    required this.primaryMotivation,
    required this.bodyPart,
    required this.tantricPractice,
    required this.sexualEnergy,
    required this.compatibleNakshatras,
    required this.remedy,
    required this.deepMeaning,
    required this.spiritualPath,
    required this.pada,
  });
}

/// Dasha (Gezegen Periyodu) Modeli
class DashaPeriod {
  final String planet;
  final int years;
  final String meaning;
  final String spiritualEvolution;
  final String challenges;
  final String opportunities;
  final String karma;
  final Map<String, String> antardashas;

  const DashaPeriod({
    required this.planet,
    required this.years,
    required this.meaning,
    required this.spiritualEvolution,
    required this.challenges,
    required this.opportunities,
    required this.karma,
    required this.antardashas,
  });
}

/// Yoga (Gezegen Kombinasyonu) Modeli
class JyotishYoga {
  final String name;
  final String category;
  final String formation;
  final String effect;
  final String spiritualMeaning;
  final String tantricImplication;
  final String rarity;
  final List<String> celebrities;

  const JyotishYoga({
    required this.name,
    required this.category,
    required this.formation,
    required this.effect,
    required this.spiritualMeaning,
    required this.tantricImplication,
    required this.rarity,
    required this.celebrities,
  });
}

/// Muhurta (Seçim Astrolojisi) Modeli
class Muhurta {
  final String name;
  final String purpose;
  final String auspiciousTiming;
  final String avoidTiming;
  final String nakshatraRecommendation;
  final String tithi;
  final String weekday;
  final String tantricTiming;

  const Muhurta({
    required this.name,
    required this.purpose,
    required this.auspiciousTiming,
    required this.avoidTiming,
    required this.nakshatraRecommendation,
    required this.tithi,
    required this.weekday,
    required this.tantricTiming,
  });
}

/// Upaya (Çare/Remedy) Modeli
class Upaya {
  final String type;
  final String targetPlanet;
  final String method;
  final String frequency;
  final String bestTime;
  final String materials;
  final String mantra;
  final String benefits;

  const Upaya({
    required this.type,
    required this.targetPlanet,
    required this.method,
    required this.frequency,
    required this.bestTime,
    required this.materials,
    required this.mantra,
    required this.benefits,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// NAVAGRAHA - 9 GEZEGENİN DERİN MİSTİK İÇERİĞİ
// ════════════════════════════════════════════════════════════════════════════

class NavagrahaContent {
  static const List<Graha> allGrahas = [
    // ═══════════════════════════════════════════════════════════════════════
    // SURYA - GÜNEŞ
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Surya',
      turkishName: 'Güneş',
      deity: 'Surya Deva - Güneş Tanrısı',
      mantra: 'Om Suryaya Namaha',
      beejMantra: 'Om Hraam Hreem Hraum Sah Suryaya Namaha',
      yantraDescription: '''
Surya Yantra, merkezi bir nokta (bindu) etrafında altı üçgenden oluşur.
Lotus yapraklarıyla çevrili bu yantra, kozmik bilincin merkezini temsil eder.
Altın veya bakır üzerine kazınmalı, doğuya bakacak şekilde yerleştirilmelidir.
Yantra'nın geometrisi, güneş ışınlarının yayılma paternini simgeler.
''',
      gemstone: 'Yakut (Manikya)',
      alternativeGemstone: 'Kırmızı Granat, Kırmızı Spinel',
      day: 'Pazar',
      color: 'Kırmızı, Altın, Turuncu',
      bodyParts: ['Kalp', 'Göz', 'Kemik', 'Omurga', 'Beyin'],
      spiritualLesson: '''
Surya, bireysel ruhun (Atman) evrensel ruhla (Brahman) birliğini öğretir.
Ego'nun sağlıklı gelişimi, öz-farkındalık ve iç ışığın keşfi Surya'nın dersleridir.
Güneş olmadan yaşam olmaz - benzer şekilde, sağlıklı bir ego olmadan
gerçek spiritüel gelişim mümkün değildir.
''',
      tantricSignificance: '''
Tantrik gelenekte Surya, Sushumna nadi'nin tepesindeki Sahasrara çakrayı
aydınlatır. Güneş tapınması, Kundalini'nin yükselmesi için temel enerjiyi sağlar.
Surya Namaskar (Güneş Selamı) sekansı, bedenin her hücresine prana
(yaşam enerjisi) pompalayan güçlü bir tantrik pratiktir.
Solar pranayama teknikleri, Pingala nadi'yi aktive eder ve içsel ateşi (Agni) uyandırır.
''',
      pujaRitual: '''
SURYA PUJA RİTÜELİ:
1. Gün doğumundan önce uyanın, temiz su ile banyo yapın
2. Temiz kırmızı veya turuncu giysiler giyin
3. Doğuya dönün, bir bakır kap içinde su tutun
4. "Om Mitraya Namaha, Om Ravaye Namaha..." 12 Surya mantrası okuyun
5. Suyu yavaşça dökerken Gayatri mantrası söyleyin
6. Bir Tulsi yaprağı veya kırmızı çiçek sunun
7. Yakut veya kırmızı taş taşıyın
8. Güneş doğarken 21 kez "Om Suryaya Namaha" tekrarlayın

EN İYİ ZAMAN: Pazar günü, gün doğumu
MANTRA SAYISI: 7000 kez (40 gün boyunca günde 175)
''',
      mythology: '''
Surya, Aditi ve Kashyapa'nın oğludur. Yedi atlı arabayla gökyüzünü geçer.
Arabacısı Aruna (şafak), atları yedi rengin ve yedi günün tezahürüdür.
Surya'nın üç eşi vardır: Sanjna (bilinç), Chhaya (gölge) ve Ragyi (tutku).
Karna, Surya'nın Kunti'den olan oğludur - kaderin güçlü bir sembolü.
Hanuman, Surya'nın öğrencisiydi ve ondan tüm Vedaları öğrendi.
Yama (ölüm tanrısı) ve Shani (Satürn) Surya'nın oğullarıdır.
''',
      mantraCount: 7000,
      metal: 'Altın, Bakır',
      direction: 'Doğu',
      taste: 'Acı',
      season: 'Yaz (Grishma)',
      signRulership: ['Aslan (Simha)'],
      exaltation: 'Koç 10°',
      debilitation: 'Terazi 10°',
      moolaTrikona: 'Aslan 0-20°',
      element: 'Ateş (Agni)',
      guna: 'Sattva',
      caste: 'Kshatriya (Savaşçı)',
      nature: 'Shubha (Hayırlı)',
      gender: 'Erkek',
      cabinet: 'Kral (Raja)',
      dlessonAdvanced: '''
Surya'nın ileri düzey spiritüel dersi "Aham Brahmasmi" - Ben Brahman'ım bilincine
ulaşmaktır. Bu, ego'nun yok edilmesi değil, dönüştürülmesidir.

Güneş'in harita'daki konumu, bu yaşamda hangi alanda "parlamak" için
doğduğumuzu gösterir. Zayıf bir Surya, öz-değer sorunlarına, otorite figürleriyle
çatışmalara ve hayatta yön bulmakta zorluğa işaret eder.

Tantrik perspektiften Surya, "Tejas" - ilahi ışık ve parlaklık prensibini temsil eder.
Güçlü Surya'sı olanlar doğal olarak karizmatik, ilham verici ve liderlik
özelliklerine sahiptir.
''',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // CHANDRA - AY
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Chandra',
      turkishName: 'Ay',
      deity: 'Chandra Deva / Soma',
      mantra: 'Om Chandraya Namaha',
      beejMantra: 'Om Shraam Shreem Shraum Sah Chandraya Namaha',
      yantraDescription: '''
Chandra Yantra, hilal şeklinde merkezi tasarıma sahiptir.
Gümüş veya beyaz bakır üzerine kazınır.
16 yapraklı lotus ile çevrili, 16 Kala'yı (Ay'ın fazlarını) temsil eder.
Kuzeybatı yönüne bakmalı, Pazartesi günü kurulmalıdır.
Su elementini çağırır ve duygusal dengeyi sağlar.
''',
      gemstone: 'İnci (Moti)',
      alternativeGemstone: 'Ay Taşı, Beyaz Mercan',
      day: 'Pazartesi',
      color: 'Beyaz, Gümüş, Krem',
      bodyParts: ['Akciğer', 'Meme', 'Mide', 'Sıvılar', 'Sol göz', 'Uterus'],
      spiritualLesson: '''
Chandra, duyguların akışkanlığını ve zihnin değişken doğasını öğretir.
Ay'ın sürekli değişen fazları, hiçbir durumun kalıcı olmadığını hatırlatır.
Annelik, besleyicilik ve koşulsuz sevgi Chandra'nın armağanlarıdır.
Zihin kontrolü ve meditasyon, Ay enerjisinin dengelenmesiyle gelir.
''',
      tantricSignificance: '''
Tantrik gelenekte Ay, Soma'dır - ölümsüzlük nektarı.
Chandra, İda nadi ile ilişkilidir - feminen, alıcı enerji kanalı.
Ay tapınması, psychic yetenekleri güçlendirir ve rüya bilincini açar.
Chandra Namaskar (Ay Selamı), özellikle kadınlar için güçlü bir pratiktir.
Tantrik birliktelikte Ay, Shakti prensibini - ilahi feminen enerjiyi temsil eder.
''',
      pujaRitual: '''
CHANDRA PUJA RİTÜELİ:
1. Pazartesi gecesi, dolunay veya artan ay döneminde yapın
2. Beyaz giysiler giyin, gümüş takılar kullanın
3. Bir gümüş kap içine süt doldurun
4. Ay'a bakarak "Om Som Somaya Namaha" 108 kez tekrarlayın
5. Sütle Shiva Lingam'a abhisheka yapın
6. Beyaz çiçekler (yasemin, zambak) sunun
7. Beyaz tatlılar (kheer, rabri) dağıtın
8. Shiva tapınağını ziyaret edin

EN İYİ ZAMAN: Pazartesi, Purnima (dolunay), gece yarısı
MANTRA SAYISI: 11000 kez (40 gün boyunca)
''',
      mythology: '''
Chandra, 27 nakshatra'nın kocasıdır - hepsini eşit sevmesi gerekirken
sadece Rohini'yi tercih ettiği için kayınpederi Daksha tarafından lanetlendi.
Shiva, Chandra'yı başında taşıyarak onu korudu ve laneti azalttı.
Ay'ın evreleri, Daksha'nın lanetinin sonucudur.
Chandra, Samudra Manthan (okyanusun çalkalanması) sırasında ortaya çıktı.
Budha (Merkür), Chandra'nın Tara ile olan birlikteliğinden doğmuştur.
''',
      mantraCount: 11000,
      metal: 'Gümüş',
      direction: 'Kuzeybatı',
      taste: 'Tuzlu',
      season: 'Varsha (Yağmur mevsimi)',
      signRulership: ['Yengeç (Karka)'],
      exaltation: 'Boğa 3°',
      debilitation: 'Akrep 3°',
      moolaTrikona: 'Boğa 4-30°',
      element: 'Su (Jala)',
      guna: 'Sattva',
      caste: 'Vaishya (Tüccar)',
      nature: 'Shubha (Hayırlı)',
      gender: 'Kadın',
      cabinet: 'Kraliçe (Rani)',
      dlessonAdvanced: '''
Chandra'nın ileri dersi, zihin ile benliğin ayrımını anlamaktır.
Vedanta'da "Mana" (zihin) gerçek benlik değildir - sadece bir araçtır.

Ay'ın harita'daki konumu ve gücü, kişinin duygusal zebasını,
anneyle ilişkisini ve iç huzurunu belirler.

Tantrik açıdan Chandra, "Ojas" - yaşamsal öz ve bağışıklık gücünü temsil eder.
Zayıf Ay, anksiyete, depresyon ve uyku bozukluklarına yol açar.

Ay'ın nakshatra'sı, kişinin en derin duygusal ihtiyaçlarını ortaya koyar.
Janma nakshatra (doğum nakshatra'sı) tüm Vedik analiz için temeldir.
''',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // MANGAL - MARS
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Mangal / Kuja',
      turkishName: 'Mars',
      deity: 'Kartikeya / Skanda - Savaş Tanrısı',
      mantra: 'Om Mangalaya Namaha',
      beejMantra: 'Om Kraam Kreem Kraum Sah Bhaumaya Namaha',
      yantraDescription: '''
Mangal Yantra, altı köşeli yıldız (Shatkona) formundadır.
Kırmızı bakır üzerine kazınır, güneye bakmalıdır.
Merkezdeki üçgen, yukarı doğru ateş elementini temsil eder.
Mars'ın savaşçı enerjisini yönlendirir ve Manglik dosha'yı azaltır.
''',
      gemstone: 'Kırmızı Mercan (Moonga)',
      alternativeGemstone: 'Karnelyan, Kan Taşı',
      day: 'Salı',
      color: 'Kırmızı, Turuncu, Mercan',
      bodyParts: ['Kan', 'Kas', 'Kemik iliği', 'Enerji', 'Adrenal bezler'],
      spiritualLesson: '''
Mangal, cesaret ve korkunun aynı enerjinin iki yüzü olduğunu öğretir.
Öfkeyi yönetmek, onu bastırmak değil, dönüştürmektir.
Gerçek savaşçılık, iç şeytanlarla - korkular, bağımlılıklar, ego ile savaşmaktır.
Mars enerjisi doğru yönlendirildiğinde, spiritüel disiplin ve tapas (çilecilik) olur.
''',
      tantricSignificance: '''
Mangal, Kundalini'nin ateşli gücünü temsil eder.
Muladhara (kök) çakra ile doğrudan bağlantılıdır.
Tantrik savaşçı yolu, Mars enerjisinin sublimasyonunu gerektirir.
Cinsel enerji (Kama) Mars'ın domenindedir - bu enerji ya yaratıcı
ya da yıkıcı olabilir.
Çelik ve demirle yapılan ritüeller, Mars enerjisini dengeler.
''',
      pujaRitual: '''
MANGAL PUJA RİTÜELİ:
1. Salı günü, gün doğumunda başlayın
2. Kırmızı giysiler giyin
3. Hanuman tapınağını ziyaret edin
4. Sindoor (vermilyon) sunun
5. Hanuman Chalisa okuyun
6. "Om Kraam Kreem Kraum Sah Bhaumaya Namaha" 108 kez
7. Kırmızı masoor dal (mercimek) bağışlayın
8. Oruç tutun veya sadece bir öğün yiyin

MANGLIK DOSHA İÇİN:
- Evlenmeden önce Mangal Shanti puja yapılmalı
- Kumbh Vivah (tören) düşünülebilir

EN İYİ ZAMAN: Salı, Bharani veya Mrigashira nakshatra
MANTRA SAYISI: 10000 kez (40 gün boyunca)
''',
      mythology: '''
Mangal, Shiva'nın terinden doğmuştur - ilahi öfkenin tezahürü.
Kartikeya olarak, Shiva ve Parvati'nin altı yüzlü savaşçı oğludur.
Tarakasura'yı (demon) öldürmek için yaratıldı.
Altı annesi vardır - Krittika nakshatra'sının altı yıldızı (Pleiades).
Her zaman bekar kalır, savaşa adanmıştır.
Tavus kuşu onun vahana'sıdır (taşıyıcısı).
''',
      mantraCount: 10000,
      metal: 'Bakır, Demir',
      direction: 'Güney',
      taste: 'Acı, Buruk',
      season: 'Grishma (Yaz)',
      signRulership: ['Koç (Mesha)', 'Akrep (Vrishchika)'],
      exaltation: 'Oğlak 28°',
      debilitation: 'Yengeç 28°',
      moolaTrikona: 'Koç 0-12°',
      element: 'Ateş (Agni)',
      guna: 'Tamas',
      caste: 'Kshatriya (Savaşçı)',
      nature: 'Papa (Zorlu)',
      gender: 'Erkek',
      cabinet: 'Komutan (Senapati)',
      dlessonAdvanced: '''
Mars'ın ileri dersi, "Ahimsa" (şiddetsizlik) paradoksunu anlamaktır.
Gerçek savaşçı, savaşmadan kazanmayı bilendir.

Mars harita'da zayıf veya afflicted ise:
- Kan hastalıkları, kazalar, ameliyatlar olabilir
- Kardeş ilişkilerinde sorunlar
- Mülkiyet anlaşmazlıkları
- Evlilikte çatışma (Manglik dosha)

Tantrik perspektiften Mars, "Virya" - cinsel ve yaşamsal gücü temsil eder.
Bu güç korunmalı ve yukarı yönlendirilmelidir (Urdhvareta).

Evrimleşmiş Mars, savaşçı-aziz arketipini - Gandhi, Martin Luther King gibi
figürleri ortaya çıkarır.
''',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // BUDH - MERKÜR
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Budha',
      turkishName: 'Merkür',
      deity: 'Vishnu / Narayana',
      mantra: 'Om Budhaya Namaha',
      beejMantra: 'Om Braam Breem Braum Sah Budhaya Namaha',
      yantraDescription: '''
Budha Yantra, beş köşeli yıldız (pentagram) formundadır.
Bronz veya pirinç üzerine kazınır.
Beş element ve beş duyunun entegrasyonunu simgeler.
Kuzeye bakmalı, Çarşamba günü kurulmalıdır.
İletişim ve zeka artırıcı özellikler taşır.
''',
      gemstone: 'Zümrüt (Panna)',
      alternativeGemstone: 'Peridot, Yeşil Turmalin',
      day: 'Çarşamba',
      color: 'Yeşil',
      bodyParts: ['Sinir sistemi', 'Deri', 'Akciğer', 'Dil', 'Kollar', 'Eller'],
      spiritualLesson: '''
Budha, aklın iki yönlü kılıç olduğunu öğretir - hem bağlar hem özgürleştirir.
Gerçek zeka, bilgiyi bilgeliğe dönüştürmektir.
İletişim sadece konuşmak değil, gerçekten dinlemektir.
Merak ve öğrenme, ruhun evriminin motorlarıdır.
''',
      tantricSignificance: '''
Budha, Vishuddhi (boğaz) çakra ile ilişkilidir.
Mantra yoga, Budha'nın domeni altındadır - ses titreşimlerinin gücü.
Yazar, şair, müzisyen ve hatiplerin koruyucusudur.
Tantrik gelenekte, Budha saf bilincin kristalleşmesidir.
Hermes Trismegistus ile eşdeğerdir - "Yukarıda olan aşağıda da vardır."
''',
      pujaRitual: '''
BUDHA PUJA RİTÜELİ:
1. Çarşamba günü, gündoğumunda veya Budha hora'da başlayın
2. Yeşil giysiler giyin
3. Vishnu tapınağını ziyaret edin
4. Yeşil moong dal (maş fasulyesi) bağışlayın
5. "Om Braam Breem Braum Sah Budhaya Namaha" 108 kez
6. Tulsi yaprağı sunun
7. Vishnu Sahasranama okuyun
8. Yeşil sebzelerden oluşan bir öğün yiyin

ZEKA GELİŞTİRME İÇİN:
- Her sabah "Om Aim Saraswatyai Namaha" 108 kez
- Yazma pratiği yapın

EN İYİ ZAMAN: Çarşamba, Ashlesha veya Revati nakshatra
MANTRA SAYISI: 9000 kez (40 gün boyunca)
''',
      mythology: '''
Budha, Ay (Chandra) ve Tara'nın (Brihaspati'nin karısı) yasak aşkından doğdu.
Bu nedenle Jüpiter (Guru) ve Merkür arasında doğal bir gerilim vardır.
Budha cinsiyetsiz veya çift cinsiyetli olarak betimlenir.
Hem maskülen hem feminen enerjileri dengeler.
Vishnu'nun avatarları ile yakından ilişkilidir.
Ayrımcı bilincin (Viveka) tanrısıdır.
''',
      mantraCount: 9000,
      metal: 'Bronz, Pirinç',
      direction: 'Kuzey',
      taste: 'Karışık',
      season: 'Sharad (Sonbahar)',
      signRulership: ['İkizler (Mithuna)', 'Başak (Kanya)'],
      exaltation: 'Başak 15°',
      debilitation: 'Balık 15°',
      moolaTrikona: 'Başak 16-20°',
      element: 'Toprak (Prithvi)',
      guna: 'Rajas',
      caste: 'Vaishya (Tüccar)',
      nature: 'Shubha (Hayırlı) - iyi gezegenlerle',
      gender: 'Nötr / Hermafrodit',
      cabinet: 'Veliaht Prens (Yuvaraja)',
      dlessonAdvanced: '''
Budha'nın ileri dersi, "Prajna" - transandantal bilgeliği anlamaktır.
Entelektüel bilgi (Jnana) ile sezgisel bilgelik (Prajna) farklıdır.

Merkür harita'da zayıf veya combustion ise:
- Öğrenme güçlükleri, konuşma bozuklukları
- Sinir sistemi sorunları
- İletişim problemleri, yanlış anlaşılmalar
- Ticari başarısızlıklar

Tantrik perspektiften Budha, "Buddhi" - ayrımcı zekayı temsil eder.
Bu, Maya'nın (illüzyon) perdesini delip geçen keskin zekadır.

Budha'nın güçlü olduğu kişiler doğal öğretmenler, yazarlar ve
aracılardır.
''',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // GURU / BRIHASPATI - JÜPİTER
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Guru / Brihaspati',
      turkishName: 'Jüpiter',
      deity: 'Brihaspati - Tanrıların Öğretmeni',
      mantra: 'Om Gurave Namaha',
      beejMantra: 'Om Graam Greem Graum Sah Gurave Namaha',
      yantraDescription: '''
Guru Yantra, altın veya sarı bakır üzerine kazınır.
Dört köşeli bir kare (Bhupura) içinde iç içe geçmiş üçgenler.
Bilgelik ve genişleme enerjisini kanallar.
Kuzeydoğuya bakmalı, Perşembe günü kurulmalıdır.
''',
      gemstone: 'Sarı Safir (Pukhraj)',
      alternativeGemstone: 'Sarı Topaz, Sitrin',
      day: 'Perşembe',
      color: 'Sarı, Altın',
      bodyParts: ['Karaciğer', 'Yağ dokusu', 'Kalça', 'Uyluk', 'Kulaklar'],
      spiritualLesson: '''
Guru, bilgeliğin entelektüel değil, deneyimsel olduğunu öğretir.
Gerçek zenginlik, maddi değil spiritüeldir.
Öğretmenin (Guru) rolü, karanlıktan (gu) aydınlığa (ru) götürmektir.
Adharma (adaletsizlik) anında susmak, en büyük günahtır.
''',
      tantricSignificance: '''
Guru, Ajna (üçüncü göz) çakra ile ilişkilidir.
Diksha (spiritüel initiation) Guru'nun domeni altındadır.
Guru-shishya (öğretmen-öğrenci) ilişkisi tantrik aktarımın temelidir.
Jüpiter, Akasha (eter) elementi ile bağlantılıdır - en ince element.
Mantra aktarımı ve spiritüel güç transferi Guru aracılığıyla olur.
''',
      pujaRitual: '''
GURU PUJA RİTÜELİ (BRIHASPATIVAR VRATA):
1. Perşembe günü, gündoğumunda başlayın
2. Sarı giysiler giyin
3. Vishnu veya Dakshinamurti tapınağını ziyaret edin
4. Sarı çiçekler (ayçiçeği, sarı gül) sunun
5. "Om Graam Greem Graum Sah Gurave Namaha" 108 kez
6. Guru Stotram okuyun
7. Chana dal (nohut) bağışlayın
8. Brahminlere yemek verin
9. Banana (muz) sunun

SPİRİTÜEL GELİŞİM İÇİN:
- Her Perşembe 16 hafta boyunca vrat tutun
- Guru Gita okuyun

EN İYİ ZAMAN: Perşembe, Punarvasu veya Vishakha nakshatra
MANTRA SAYISI: 19000 kez (40 gün boyunca)
''',
      mythology: '''
Brihaspati, Angiras rishi'nin oğludur.
Deva'ların (tanrıların) öğretmeni ve danışmanıdır.
Asura'ların (demonların) öğretmeni Shukra ile rekabet halindedir.
Tara (yıldız tanrıçası) ile evlidir, ancak Chandra onu kaçırdı.
Bilgelik, adalet ve doğruluk tanrısıdır.
İndra'nın (tanrıların kralı) en güvendiği danışmandır.
''',
      mantraCount: 19000,
      metal: 'Altın',
      direction: 'Kuzeydoğu',
      taste: 'Tatlı',
      season: 'Hemanta (Kış başlangıcı)',
      signRulership: ['Yay (Dhanu)', 'Balık (Meena)'],
      exaltation: 'Yengeç 5°',
      debilitation: 'Oğlak 5°',
      moolaTrikona: 'Yay 0-10°',
      element: 'Eter (Akasha)',
      guna: 'Sattva',
      caste: 'Brahmin (Rahip)',
      nature: 'Shubha (Hayırlı)',
      gender: 'Erkek',
      cabinet: 'Başbakan (Mantri)',
      dlessonAdvanced: '''
Guru'nun ileri dersi, "Dharma" - kozmik düzeni ve kişisel görevi anlamaktır.
Her ruhun bu yaşamda yerine getirmesi gereken benzersiz bir dharma'sı vardır.

Jüpiter harita'da zayıf ise:
- Spiritüel rehberlik eksikliği
- Aşırıya kaçma, obezite
- Kötü karar verme
- Çocuklarla ilgili zorluklar
- Finansal istikrarsızlık

Tantrik perspektiften Guru, "Sat-Chit-Ananda" bilincini -
Varlık, Bilinç ve Mutluluğu temsil eder.

Güçlü Guru, doğal öğretmenler, filozoflar, hukukçular ve
spiritüel liderler yaratır.
''',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // SHUKRA - VENÜS
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Shukra',
      turkishName: 'Venüs',
      deity: 'Shukracharya - Asuraların Öğretmeni',
      mantra: 'Om Shukraya Namaha',
      beejMantra: 'Om Draam Dreem Draum Sah Shukraya Namaha',
      yantraDescription: '''
Shukra Yantra, altı yapraklı lotus içinde bir pentagram içerir.
Gümüş veya beyaz bronz üzerine kazınır.
Aşk, güzellik ve bolluk enerjilerini çeker.
Güneydoğuya bakmalı, Cuma günü kurulmalıdır.
''',
      gemstone: 'Elmas (Heera)',
      alternativeGemstone: 'Beyaz Safir, Zirkon',
      day: 'Cuma',
      color: 'Beyaz, Pembe, Gökkuşağı renkleri',
      bodyParts: ['Üreme organları', 'Böbrekler', 'Yüz', 'Gözler', 'Boğaz'],
      spiritualLesson: '''
Shukra, güzelliğin ilahi bir yansıma olduğunu öğretir.
Gerçek aşk, bağımlılık değil, özgürleştirmedir.
Maddi zevkler spiritüelliğin düşmanı değil, kapısı olabilir.
Tantra'da, duyusal deneyim aydınlanmaya giden bir yol olabilir.
''',
      tantricSignificance: '''
Shukra, tantrik pratiğin kalbidir - Shakti enerjisi.
Svadhisthana (sakral) çakra ile doğrudan ilişkilidir.
Kama (arzu) ve Rati (zevk) Venüs'ün domeni altındadır.
Tantrik birliktelik (Maithuna) Shukra'nın en yüksek ifadesidir.
Sanjivani Vidya (ölümsüzlük ilmi) Shukracharya'nın gizli bilgisidir.
''',
      pujaRitual: '''
SHUKRA PUJA RİTÜELİ:
1. Cuma günü, gündoğumunda başlayın
2. Beyaz veya pembe giysiler giyin
3. Lakshmi veya Saraswati tapınağını ziyaret edin
4. Beyaz çiçekler (yasemin, zambak, beyaz gül) sunun
5. "Om Draam Dreem Draum Sah Shukraya Namaha" 108 kez
6. Şeker veya tatlı sunun
7. Parfüm veya güzel kokular kullanın
8. Pirinç ve şeker bağışlayın
9. Kadınlara hediye verin

EVLİLİK VE AŞK İÇİN:
- 16 Cuma boyunca Santoshi Maa vrat
- Shukra Stotram okuyun

EN İYİ ZAMAN: Cuma, Bharani veya Purva Phalguni nakshatra
MANTRA SAYISI: 16000 kez (40 gün boyunca)
''',
      mythology: '''
Shukracharya, Bhrigu Rishi'nin oğludur.
Asura'ların (titanların) öğretmenidir - Brihaspati'nin rakibi.
Sanjivani Vidya'yı bilir - ölüleri diriltme gücü.
Bir gözünü Vamana avatar için Bali'yi korumaya çalışırken kaybetti.
Aşkın, sanatın ve maddi bolluğun tanrısıdır.
Hem spiritüel hem maddi zenginliğin kaynağıdır.
''',
      mantraCount: 16000,
      metal: 'Gümüş, Platin',
      direction: 'Güneydoğu',
      taste: 'Ekşi',
      season: 'Vasanta (İlkbahar)',
      signRulership: ['Boğa (Vrishabha)', 'Terazi (Tula)'],
      exaltation: 'Balık 27°',
      debilitation: 'Başak 27°',
      moolaTrikona: 'Terazi 0-15°',
      element: 'Su (Jala)',
      guna: 'Rajas',
      caste: 'Brahmin (Rahip)',
      nature: 'Shubha (Hayırlı)',
      gender: 'Kadın',
      cabinet: 'Başbakan Yardımcısı',
      dlessonAdvanced: '''
Shukra'nın ileri dersi, "Kama" (arzu) enerjisini anlamaktır.
Arzu bastırılmamalı, dönüştürülmelidir.

Venüs harita'da zayıf ise:
- İlişki sorunları, çekim eksikliği
- Maddi zorluklar
- Sanatsal ifade blokajı
- Sağlıksız bağımlılıklar
- Özdeğer sorunları

Tantrik perspektiften Shukra, "Sundaram" - ilahi güzelliği temsil eder.
Satyam (Gerçek), Shivam (İyilik), Sundaram (Güzellik) üçlemesinin bir parçasıdır.

Güçlü Shukra, sanatçılar, tasarımcılar, diplomatlar ve
aşk konularında danışmanlar yaratır.
''',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // SHANI - SATÜRN
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Shani',
      turkishName: 'Satürn',
      deity: 'Shani Deva - Karma Lordu',
      mantra: 'Om Shanaye Namaha',
      beejMantra: 'Om Praam Preem Praum Sah Shanaye Namaha',
      yantraDescription: '''
Shani Yantra, sekiz köşeli yıldız (Ashtakona) formundadır.
Demir veya çelik üzerine kazınır.
Karmanın dengelenmesini ve Shani'nin gazabının azaltılmasını sağlar.
Batıya bakmalı, Cumartesi günü kurulmalıdır.
''',
      gemstone: 'Mavi Safir (Neelam)',
      alternativeGemstone: 'Ametist, Lapis Lazuli',
      day: 'Cumartesi',
      color: 'Siyah, Koyu Mavi, Mor',
      bodyParts: ['Kemikler', 'Dişler', 'Diz', 'Bacaklar', 'Dalak'],
      spiritualLesson: '''
Shani, sabır ve disiplinin en büyük öğretmenler olduğunu gösterir.
Acı, direnci kırmak değil, onu inşa etmek içindir.
Karma kaçınılmazdır - ekileni biçersiniz.
Gerçek özgürlük, sorumluluğu kabulle gelir.
''',
      tantricSignificance: '''
Shani, Muladhara (kök) çakranın derinliklerini yönetir.
Karanlık gece (Dark Night of the Soul) Shani'nin inisiyasyonudur.
Tantrik çileciliğin (Tapas) koruyucusudur.
Shani, ego'nun ölümü ve ruhun yeniden doğuşunu temsil eder.
Kala (zaman) ve Mrityu (ölüm) Shani'nin elçileridir.
''',
      pujaRitual: '''
SHANI PUJA RİTÜELİ (SHANIVAR VRATA):
1. Cumartesi günü, gün doğumundan önce başlayın
2. Siyah veya koyu mavi giysiler giyin
3. Shani tapınağını veya Hanuman tapınağını ziyaret edin
4. Siyah çiçekler (koyu mor) sunun
5. Susam yağı lambası yakın
6. "Om Praam Preem Praum Sah Shanaye Namaha" 108 kez
7. Shani Stotram veya Shani Chalisa okuyun
8. Siyah urad dal (mercimek) bağışlayın
9. Demir kaplar bağışlayın
10. Fakirlere yiyecek verin

SADE SATI VE SHANI DASHA İÇİN:
- 19 veya 23 Cumartesi kesintisiz vrat
- Hanuman Chalisa günlük okuyun
- Shani Mahamantra: "Nilanjana samabhasam..."

EN İYİ ZAMAN: Cumartesi, Pushya veya Anuradha nakshatra
MANTRA SAYISI: 23000 kez (40 gün boyunca)
''',
      mythology: '''
Shani, Surya (Güneş) ve Chhaya'nın (gölge) oğludur.
Babası Surya ile karmaşık bir ilişkisi vardır.
Kardeşi Yama, ölüm tanrısıdır.
Doğduğunda Shani'nin bakışı babasını yaraladı - bu yüzden bakışı uğursuz sayılır.
Adaletli ama acımasızdır - karma hesabını eksiksiz tutar.
Hanuman, Shani'yi mağlup ederek onun gazabından koruyan tek tanrıdır.
''',
      mantraCount: 23000,
      metal: 'Demir, Çelik',
      direction: 'Batı',
      taste: 'Buruk, Acı',
      season: 'Shishira (Kış ortası)',
      signRulership: ['Oğlak (Makara)', 'Kova (Kumbha)'],
      exaltation: 'Terazi 20°',
      debilitation: 'Koç 20°',
      moolaTrikona: 'Kova 0-20°',
      element: 'Hava (Vayu)',
      guna: 'Tamas',
      caste: 'Shudra (İşçi)',
      nature: 'Papa (Zorlu)',
      gender: 'Nötr (Hadım)',
      cabinet: 'Hizmetkar',
      dlessonAdvanced: '''
Shani'nin ileri dersi, "Vairagya" - bağımsızlığı anlamaktır.
Gerçek özgürlük, hiçbir şeye bağlı olmamaktır.

Satürn dönemleri (Sade Sati, Shani Dasha):
- 7.5 yıl Sade Sati: Yaşamın yeniden yapılandırılması
- Shani Return (29.5 yıl): Olgunluk testleri
- Karmaik borçların ödenmesi

SADE SATI FAZLARI:
1. İlk 2.5 yıl: Mental stres, aile sorunları
2. Orta 2.5 yıl: Kariyer ve sağlık testleri
3. Son 2.5 yıl: Finansal zorluklar, ilişki testleri

Tantrik perspektiften Shani, "Kala" - zamanın efendisidir.
Zaman, Maya'nın en güçlü silahıdır - ama aynı zamanda aydınlanmanın kapısıdır.

Evrimleşmiş Shani, bilge yaşlı, yogi ve aziz arketipini yaratır.
''',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // RAHU - KUZEY AY DÜĞÜMÜ
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Rahu',
      turkishName: 'Kuzey Ay Düğümü',
      deity: 'Rahu - Gölge Gezegen (Başsız Beden)',
      mantra: 'Om Rahave Namaha',
      beejMantra: 'Om Bhraam Bhreem Bhraum Sah Rahave Namaha',
      yantraDescription: '''
Rahu Yantra, karanlık bir arka plan üzerinde aşağı bakan üçgen içerir.
Kurşun veya demir üzerine kazınır.
Maya'nın (illüzyon) penetrasyonunu ve Rahu'nun etkilerinin yatıştırılmasını sağlar.
Güneybatıya bakmalı, Cumartesi veya Rahu Kalam'da kurulmalıdır.
''',
      gemstone: 'Hessonit Granat (Gomed)',
      alternativeGemstone: 'Smoky Kuvars, Sarı Zirkon',
      day: 'Cumartesi (veya Rahu Kalam)',
      color: 'Dumanlı Gri, Lacivert, Ultraviyole',
      bodyParts: ['Baş (hastalıklar)', 'Sinir sistemi', 'Cilt', 'Ayaklar'],
      spiritualLesson: '''
Rahu, arzuların sonsuz döngüsünü ve tatminsizliği öğretir.
Dünyevi hırslar peşinde koşmak, asla doyumsuzluğa yol açar.
Maya'nın (illüzyon) doğasını anlamak, özgürleşmenin ilk adımıdır.
Obsesyon ile tutku arasındaki ince çizgiyi gösterir.
''',
      tantricSignificance: '''
Rahu, Kundalini'nin uyanışında kritik bir rol oynar.
Karanlık tanrıçalar (Kali, Chinnamasta) ile ilişkilidir.
Vama Marga (sol el yolu) tantrik pratiğin koruyucusudur.
Tabular ve yasaklar Rahu'nun domeni altındadır.
Gölge benliğin (Shadow Self) entegrasyonu Rahu çalışmasıdır.
''',
      pujaRitual: '''
RAHU PUJA RİTÜELİ:
1. Rahu Kalam'da veya Cumartesi gecesi yapın
2. Koyu mavi veya siyah giysiler giyin
3. Durga veya Kali tapınağını ziyaret edin
4. Mavi çiçekler sunun
5. "Om Bhraam Bhreem Bhraum Sah Rahave Namaha" 108 kez
6. Rahu Stotram okuyun
7. Hindistan cevizi ve hardal yağı lambası yakın
8. Siyah örtü veya şemsiye bağışlayın
9. Yılan tapınağını ziyaret edin (Naga devata)

RAHU MAHADASHA İÇİN:
- Durga Saptashati (700 ayet) okuyun
- Sarı hardal tohumları taşıyın

EN İYİ ZAMAN: Rahu Kalam (her gün değişir), Ardra veya Swati nakshatra
MANTRA SAYISI: 18000 kez (40 gün boyunca)
''',
      mythology: '''
Rahu, Samudra Manthan (okyanusun çalkalanması) sırasında ortaya çıktı.
Amrita (ölümsüzlük nektarı) içmeye çalışan bir Asura idi.
Vishnu'nun Mohini formu onu keşfetti ve Sudarshana Chakra ile
başını kesti - ancak nektar zaten boğazından geçmişti.
Baş Rahu, gövde Ketu oldu - ikisi de ölümsüzleşti.
Güneş ve Ay'a olan öfkesi (onu ihbar ettiler) tutulmalara neden olur.
''',
      mantraCount: 18000,
      metal: 'Kurşun, Anahtar Demiri',
      direction: 'Güneybatı',
      taste: 'Zehirli, Uyuşturucu',
      season: 'N/A (Gölge gezegen)',
      signRulership: ['Kova (modern yorum)'],
      exaltation: 'Boğa (bazı sistemlerde)',
      debilitation: 'Akrep (bazı sistemlerde)',
      moolaTrikona: 'İkizler (bazı sistemlerde)',
      element: 'Hava (Vayu)',
      guna: 'Tamas',
      caste: 'Outcaste',
      nature: 'Papa (Zorlu)',
      gender: 'Erkek',
      cabinet: 'Ordu (isyancı)',
      dlessonAdvanced: '''
Rahu'nun ileri dersi, "Maya" - illüzyonu anlamaktır.
Dünya gerçek değil, ama gerçek değilmiş gibi davranmak da yanlıştır.

Rahu harita'da güçlü ise:
- Büyük hırslar, dünyevi başarı potansiyeli
- Teknoloji, yabancı yerler, unconventional yollar
- Bağımlılık riski (madde, kumar, seks)
- Ani yükselişler ve düşüşler

RAHU MAHADASHA (18 yıl):
- Yabancı temaslar, seyahatler
- Teknoloji ve inovasyon
- İllüzyonlar ve aldanmalar
- Spiritüel arayış veya materyalizm

Tantrik perspektiften Rahu, "Avidya" - temel cehaleti temsil eder.
Bu cehalet, arzuların sonsuz zincirinin köküdür.

Evrimleşmiş Rahu, guru, mistik veya vizyoner olabilir.
''',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // KETU - GÜNEY AY DÜĞÜMÜ
    // ═══════════════════════════════════════════════════════════════════════
    Graha(
      sanskritName: 'Ketu',
      turkishName: 'Güney Ay Düğümü',
      deity: 'Ketu - Gölge Gezegen (Başsız Gövde)',
      mantra: 'Om Ketave Namaha',
      beejMantra: 'Om Sraam Sreem Sraum Sah Ketave Namaha',
      yantraDescription: '''
Ketu Yantra, yukarı bakan bir üçgen içinde bir nokta içerir.
Gümüş veya demir üzerine kazınır.
Moksha (kurtuluş) enerjisini kanallar ve geçmiş yaşam karmalarını çözer.
Güneye bakmalı, Salı veya Ketu Kalam'da kurulmalıdır.
''',
      gemstone: 'Kedi Gözü (Lahsuniya / Cat\'s Eye)',
      alternativeGemstone: 'Kaplan Gözü, Turmalin',
      day: 'Salı (veya Perşembe)',
      color: 'Çok renkli, Duman rengi, Gri',
      bodyParts: ['Bacaklar', 'Ayaklar', 'Sırt', 'Omurga alt kısmı'],
      spiritualLesson: '''
Ketu, bağlılıkların acı verdiğini ve bırakmanın özgürleştirdiğini öğretir.
Geçmiş yaşam yetenekleri ve karmalar Ketu aracılığıyla gelir.
Spiritüel arayış, maddi dünyadan kopuşla başlar.
Moksha (kurtuluş), tüm arzuların sona ermesiyle gelir.
''',
      tantricSignificance: '''
Ketu, Sahasrara (taç) çakra ile doğrudan bağlantılıdır.
Kundalini'nin nihai hedefi olan kozmik bilinçtir.
Keşiş ve sanyasi (dünyadan el çekmiş) arketipinin koruyucusudur.
Astral seyahat ve geçmiş yaşam hatırlamaları Ketu domenidir.
Moksha'nın (nihai kurtuluş) anahtarıdır.
''',
      pujaRitual: '''
KETU PUJA RİTÜELİ:
1. Salı veya Perşembe, gün doğumunda yapın
2. Gri, kahverengi veya çok renkli giysiler giyin
3. Ganesha tapınağını ziyaret edin (engelleri kaldıran)
4. Sarı veya çok renkli çiçekler sunun
5. "Om Sraam Sreem Sraum Sah Ketave Namaha" 108 kez
6. Ketu Stotram okuyun
7. Susam yağı lambası yakın
8. Battaniye veya örtü bağışlayın
9. Köpeklere yemek verin

KETU MAHADASHA İÇİN:
- Ganesha Atharvashirsha okuyun
- Meditasyon pratiğini yoğunlaştırın

EN İYİ ZAMAN: Magha, Moola veya Ashwini nakshatra
MANTRA SAYISI: 17000 kez (40 gün boyunca)
''',
      mythology: '''
Ketu, Rahu'nun kesilen gövdesidir.
Başsız olduğu için düşünemez ama güçlü sezgilere sahiptir.
Dünyevi meselelere ilgisizdir - sadece spiritüel kurtuluş ister.
Yılan bayraklıdır (Dhwaja) - Kundalini sembolizmi.
Moksha karaka'dır - kurtuluşun göstergesi.
''',
      mantraCount: 17000,
      metal: 'Karışık metaller',
      direction: 'Güney',
      taste: 'Acı, Yakıcı',
      season: 'N/A (Gölge gezegen)',
      signRulership: ['Akrep (modern yorum)'],
      exaltation: 'Akrep (bazı sistemlerde)',
      debilitation: 'Boğa (bazı sistemlerde)',
      moolaTrikona: 'Yay (bazı sistemlerde)',
      element: 'Ateş (Agni) - spiritüel ateş',
      guna: 'Tamas (ama Sattva dönüstürücü)',
      caste: 'Mlechha (yabancı)',
      nature: 'Papa (Zorlu) ama Moksha karaka',
      gender: 'Nötr',
      cabinet: 'Ordu (gizli)',
      dlessonAdvanced: '''
Ketu'nun ileri dersi, "Moksha" - nihai kurtuluşu anlamaktır.
Ketu, samsara (varoluş çarkı) döngüsünden çıkış kapısıdır.

Ketu harita'da güçlü ise:
- Güçlü sezgi ve psychic yetenekler
- Spiritüel eğilimler, mistisizm
- Dünyevi meselelere ilgisizlik
- Geçmiş yaşam yetenekleri (özellikle okült)

KETU MAHADASHA (7 yıl):
- Spiritüel uyanış veya kafa karışıklığı
- Kayıplar yoluyla bırakma dersleri
- Geçmiş yaşam karmalarının çözülmesi
- Psişik deneyimler, rüyalar

Tantrik perspektiften Ketu, "Jnana" - saf bilgiyi temsil eder.
Bu bilgi, entelektüel değil, doğrudan deneyimseldir.

Evrimleşmiş Ketu, aydınlanmış guru, mistik veya aziz olarak tezahür eder.
''',
    ),
  ];

  /// Graha'yı ismine göre bul
  static Graha? getGrahaByName(String name) {
    try {
      return allGrahas.firstWhere(
        (g) =>
            g.sanskritName.toLowerCase() == name.toLowerCase() ||
            g.turkishName.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Günün Graha'sını al
  static Graha getDailyGraha() {
    final weekday = DateTime.now().weekday;
    switch (weekday) {
      case DateTime.sunday:
        return allGrahas[0]; // Surya
      case DateTime.monday:
        return allGrahas[1]; // Chandra
      case DateTime.tuesday:
        return allGrahas[2]; // Mangal
      case DateTime.wednesday:
        return allGrahas[3]; // Budha
      case DateTime.thursday:
        return allGrahas[4]; // Guru
      case DateTime.friday:
        return allGrahas[5]; // Shukra
      case DateTime.saturday:
        return allGrahas[6]; // Shani
      default:
        return allGrahas[0];
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// NAKSHATRA - 27 AY KONAĞININ DERİN MİSTİK İÇERİĞİ
// ════════════════════════════════════════════════════════════════════════════

class NakshatraContent {
  static const List<Nakshatra> allNakshatras = [
    // ═══════════════════════════════════════════════════════════════════════
    // 1. ASHWINI - AT İKİZLERİ
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 1,
      name: 'Ashwini',
      meaning: 'At Binicileri, Şifacı İkizler',
      rulingDeity: 'Ashwini Kumarlar - İlahi İkiz Şifacılar',
      rulingPlanet: 'Ketu',
      symbol: 'At başı, At arabası',
      shakti: 'Shidravyapani Shakti - Hızlı ulaşım ve şifa gücü',
      nature: 'Laghu/Kshipra (Hafif, Hızlı)',
      gana: 'Deva (Tanrısal)',
      animal: 'Erkek At (Ashwa)',
      bird: 'Kuzgun',
      tree: 'Zehirli Fındık (Strychnos nux-vomica)',
      guna: 'Rajas',
      tattva: 'Toprak (Prithvi)',
      caste: 'Vaishya (Tüccar)',
      gender: 'Erkek',
      temperament: 'Dharma (Doğruluk)',
      primaryMotivation: 'Dharma - Kozmik Düzen',
      bodyPart: 'Diz kapakları',
      tantricPractice: '''
Ashwini enerjisi, Kundalini'nin ilk kıpırdanmasını temsil eder.
Hızlı şifa ritüelleri ve acil enerji aktarımları bu nakshatra ile yapılır.
Tantrik pranayama teknikleri, özellikle Kapalabhati ve Bhastrika,
Ashwini enerjisini harekete geçirir.
Ashwini Mudra (anal sfinkter kasılması) bu nakshatra'nın adını taşır.
''',
      sexualEnergy: '''
Ashwini, hızlı ve dinamik cinsel enerjiyi temsil eder.
Spontane, tutkulu ve macera dolu birliktelikleri destekler.
Cinsel enerjinin hızlı yükselmesi ve dönüşümü bu nakshatra'nın özelliğidir.
Tantrik pratiklerde, enerjiyi hızla yükseltmek için kullanılır.
''',
      compatibleNakshatras: ['Bharani', 'Revati', 'Hasta', 'Swati'],
      remedy: '''
Ashwini zayıfsa:
- Ketu mantrasını günlük okuyun
- Sarı ve turuncu giysiler giyin
- At figürleri veya resimleri ile çalışın
- Şifacılık ve tıp alanında hizmet edin
''',
      deepMeaning: '''
Ashwini, Vedik astrolojinin başlangıç noktasıdır - Mesha rashi'nin (Koç) ilk 13°20'.
İkiz at tanrıları, ruhun fiziksel dünyaya ilk girişini simgeler.
Bu nakshatra'da doğanlar, doğal şifacılar ve öncülerdir.
Hız, yenilik ve cesaret temel özelliklerdir.
''',
      spiritualPath: '''
Ashwini, Karma Yoga yolunu destekler - eylem yoluyla kurtuluş.
Hızlı spiritüel ilerleme mümkündür ancak sabır gereklidir.
Şifacılık yeteneğini insanlığın hizmetine sunmak dharma'dır.
Geçmiş yaşam yetenekleri (Ketu) bu nakshatra'da aktive olur.
''',
      pada: [
        '1. Pada (Koç navamsha): Cesaret, öncülük, fiziksel güç',
        '2. Pada (Boğa navamsha): Pratiklik, kaynak yönetimi',
        '3. Pada (İkizler navamsha): İletişim, öğretme, yazma',
        '4. Pada (Yengeç navamsha): Duygusal şifa, annelik',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 2. BHARANI - TAŞIYICI
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 2,
      name: 'Bharani',
      meaning: 'Taşıyan, Besleyen',
      rulingDeity: 'Yama - Ölüm ve Dharma Tanrısı',
      rulingPlanet: 'Shukra (Venüs)',
      symbol: 'Yoni (Kadın üreme organı), Vulva',
      shakti: 'Apabharani Shakti - Uzaklaştırma/Taşıma gücü',
      nature: 'Ugra (Şiddetli, Yoğun)',
      gana: 'Manushya (İnsani)',
      animal: 'Fil (Gaja)',
      bird: 'Karga',
      tree: 'Amla (Hint Bektaşi üzümü)',
      guna: 'Rajas',
      tattva: 'Toprak (Prithvi)',
      caste: 'Mleccha (Dışlanmış)',
      gender: 'Kadın',
      temperament: 'Artha (Maddi refah)',
      primaryMotivation: 'Artha - Maddi Güvenlik',
      bodyPart: 'Baş tepesi, Beyin tabanı',
      tantricPractice: '''
Bharani, tantrik pratiğin en güçlü nakshatra'larından biridir.
Ölüm ve yeniden doğuş ritüelleri bu enerji altında yapılır.
Yoni puja ve Shakti tapınması Bharani ile doğrudan bağlantılıdır.
Cinsel enerjiyi spiritüel güce dönüştürme pratiği burada güçlenir.
Kali ve Durga gibi karanlık tanrıçaların enerjisi Bharani'de yoğunlaşır.
''',
      sexualEnergy: '''
Bharani, en yoğun cinsel enerjiyi taşıyan nakshatra'dır.
Sembolü (yoni) doğrudan üreme ve cinselliği temsil eder.
Bu enerji ya yaratıcı ya da yıkıcı olabilir - bilinçli yönetim şarttır.
Tantrik birliktelik için en güçlü nakshatra'lardan biridir.
Cinsel enerji burada transformatif bir güç haline gelir.
''',
      compatibleNakshatras: ['Revati', 'Pushya', 'Shravana', 'Ashwini'],
      remedy: '''
Bharani zorlu etkiler gösteriyorsa:
- Shukra mantrasını okuyun
- Beyaz çiçekler sunun
- Yama'ya puja yapın
- Yaşamın geçiciliği üzerine meditasyon
''',
      deepMeaning: '''
Bharani, doğum ve ölüm arasındaki geçidi temsil eder.
Yama'nın yönetimi, her şeyin bir sonu olduğunu hatırlatır.
Bu nakshatra'da doğanlar, derin dönüşümler yaşar.
Tabuları kırmak ve toplumsal normları sorgulamak doğalarında vardır.
''',
      spiritualPath: '''
Bharani, Bhakti Yoga ile Tantra'nın birleştiği noktadır.
Ölüme yaklaşım, spiritüel olgunluğun göstergesidir.
Yama Niyama (etik kurallar) pratiği bu nakshatra için esastır.
Bırakma ve kabul etme, Bharani'nin spiritüel dersidir.
''',
      pada: [
        '1. Pada (Aslan navamsha): Yaratıcılık, liderlik, drama',
        '2. Pada (Başak navamsha): Analiz, detay, hizmet',
        '3. Pada (Terazi navamsha): İlişkiler, estetik, denge',
        '4. Pada (Akrep navamsha): En yoğun, dönüşüm, okült',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 3. KRITTIKA - KESİCİ
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 3,
      name: 'Krittika',
      meaning: 'Kesiciler, Ateşli Kızlar',
      rulingDeity: 'Agni - Ateş Tanrısı',
      rulingPlanet: 'Surya (Güneş)',
      symbol: 'Alev, Jilet, Balta',
      shakti: 'Dahana Shakti - Yakma, Arındırma gücü',
      nature: 'Mishra (Karışık)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Dişi Keçi',
      bird: 'Tavuskuşu',
      tree: 'Dumur (İncir türü)',
      guna: 'Rajas',
      tattva: 'Ateş (Agni)',
      caste: 'Brahmin (Rahip)',
      gender: 'Kadın',
      temperament: 'Kama (Arzu)',
      primaryMotivation: 'Kama - Arzu ve Zevk',
      bodyPart: 'Kalça, Bel',
      tantricPractice: '''
Krittika, Agni çalışmasının nakshatra'sıdır.
Homa ve yagna (ateş ritüelleri) burada en etkilidir.
İç ateşin (Tapas) uyandırılması Krittika enerjisiyle yapılır.
Kartikeya'nın altı annesi (Krittika yıldızları) tantrik gücü sembolize eder.
Saflaştırma ve arındırma ritüelleri bu nakshatra'da gerçekleştirilir.
''',
      sexualEnergy: '''
Krittika, keskin ve yoğun bir cinsel enerji taşır.
Ateş elementi, tutku ve yanmayı temsil eder.
Cinsel enerji burada transformatif ateş haline gelir.
Tantrik pratiklerde, içsel ateşin uyandırılması için kullanılır.
''',
      compatibleNakshatras: [
        'Rohini',
        'Mrigashira',
        'Pushya',
        'Uttara Phalguni',
      ],
      remedy: '''
Krittika dengesizse:
- Surya mantrasını okuyun
- Ateş ritüelleri (homa) yapın
- Kırmızı ve turuncu giysiler giyin
- Gün doğumu meditasyonu
''',
      deepMeaning: '''
Krittika, Pleiades yıldız kümesidir - altı görünür yıldız.
Kartikeya'yı besleyen altı anne figürüdür.
Bu nakshatra, kesme ve ayırma gücünü verir.
Gerçeği yalandan, iyiyi kötüden ayırt etme yeteneği.
''',
      spiritualPath: '''
Krittika, Jnana Yoga (bilgi yolu) için idealdir.
Ayrımcı bilgelik (Viveka) burada gelişir.
Agni tapınması, içsel arınma yolunu açar.
Spiritüel savaşçılık ve disiplin bu nakshatra'nın armağanıdır.
''',
      pada: [
        '1. Pada (Yay navamsha): Dharma, öğretim, felsefe',
        '2. Pada (Oğlak navamsha): Kariyer, otorite, yapı',
        '3. Pada (Kova navamsha): Yenilikçilik, insancıllık',
        '4. Pada (Balık navamsha): Sezgi, spiritüellik, hayal gücü',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 4. ROHINI - KIRMIZI
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 4,
      name: 'Rohini',
      meaning: 'Kırmızı, Yükselen',
      rulingDeity: 'Brahma - Yaratıcı Tanrı',
      rulingPlanet: 'Chandra (Ay)',
      symbol: 'Öküz arabası, Araba, Tapınak',
      shakti: 'Rohana Shakti - Büyütme, Yetiştirme gücü',
      nature: 'Dhruva (Sabit)',
      gana: 'Manushya (İnsani)',
      animal: 'Erkek Yılan (Cobra)',
      bird: 'Baykuş',
      tree: 'Jamun (Hint Erik)',
      guna: 'Rajas',
      tattva: 'Toprak (Prithvi)',
      caste: 'Shudra (İşçi)',
      gender: 'Kadın',
      temperament: 'Moksha (Kurtuluş)',
      primaryMotivation: 'Moksha - Spiritüel Kurtuluş',
      bodyPart: 'Bacaklar, Baldırlar',
      tantricPractice: '''
Rohini, yaratıcılık ve doğurganlık tantrik pratiklerinin merkezidir.
Brahma puja ve yaratım ritüelleri bu nakshatra'da güçlenir.
Cinsel yaratıcılığın spiritüel yaratıcılığa dönüştürülmesi burada olur.
Shakti'nin besleyici yönü Rohini'de yoğunlaşır.
Ay enerjisinin en saf hali bu nakshatra'dadır.
''',
      sexualEnergy: '''
Rohini, en çekici ve manyetik cinsel enerjiyi taşır.
Ay'ın en sevdiği eşi (nakshatra) olarak bilinir.
Şehvetli, duyusal ve derin bağlanma arzusu.
Cinsel enerji burada besleyici ve yaratıcı bir güç olur.
''',
      compatibleNakshatras: ['Uttara Phalguni', 'Hasta', 'Shravana', 'Revati'],
      remedy: '''
Rohini dengesizse:
- Chandra mantrasını okuyun
- Ay ışığında meditasyon
- Beyaz çiçekler ve süt sunun
- Sanatsal ifadeye yönelin
''',
      deepMeaning: '''
Rohini, Boğa burcunun kalbinde yer alır (Aldebaran yıldızı).
Ay'ın en güçlü olduğu nokta burasıdır.
Güzellik, çekim ve maddi bolluk Rohini'nin armağanlarıdır.
Krishna'nın favori nakshatra'sı olarak bilinir.
''',
      spiritualPath: '''
Rohini, Bhakti Yoga için en uygun nakshatra'dır.
Tanrısal güzelliğe aşık olmak, kurtuluş yoludur.
Sanat ve yaratıcılık yoluyla spiritüellik ifade edilir.
İlahi feminen (Shakti) ile birleşme arzusu güçlüdür.
''',
      pada: [
        '1. Pada (Koç navamsha): İnisiyatif, cesaret, dinamizm',
        '2. Pada (Boğa navamsha): En güçlü, maddi bolluk',
        '3. Pada (İkizler navamsha): Sanatsal ifade, iletişim',
        '4. Pada (Yengeç navamsha): Duygusal derinlik, annelik',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 5. MRIGASHIRA - GEYİK BAŞI
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 5,
      name: 'Mrigashira',
      meaning: 'Geyik Başı, Arayış',
      rulingDeity: 'Soma - Ay Tanrısı, Nektar',
      rulingPlanet: 'Mangal (Mars)',
      symbol: 'Geyik başı, Av köpeği',
      shakti: 'Prinana Shakti - Tatmin ve Doyum gücü',
      nature: 'Mridu (Yumuşak)',
      gana: 'Deva (Tanrısal)',
      animal: 'Dişi Yılan',
      bird: 'Horoz',
      tree: 'Khadira (Akasya)',
      guna: 'Tamas',
      tattva: 'Toprak (Prithvi)',
      caste: 'Kshatriya (Savaşçı)',
      gender: 'Nötr',
      temperament: 'Moksha (Kurtuluş)',
      primaryMotivation: 'Moksha - Spiritüel Kurtuluş',
      bodyPart: 'Gözler, Kaşlar',
      tantricPractice: '''
Mrigashira, arayış ve keşif enerjisini taşır.
Tantrik arayış, içsel soma'yı (nektar) bulmaktır.
Shiva'nın geyik avı hikayesi, ruhun arayışını simgeler.
Soma ritüelleri bu nakshatra ile güçlenir.
Merak ve araştırma tantrik pratiğin motorudur.
''',
      sexualEnergy: '''
Mrigashira, flört ve çekim oyununun nakshatra'sıdır.
Kovalama ve aranma dinamiği cinsel enerjiyi canlandırır.
Hafif, oyuncu ve meraklı bir cinsel enerji taşır.
Keşif ve deneyim arzusu öne çıkar.
''',
      compatibleNakshatras: ['Chitra', 'Anuradha', 'Revati', 'Hasta'],
      remedy: '''
Mrigashira dengesizse:
- Soma/Chandra mantrasını okuyun
- Doğada yürüyüş yapın
- Merakınızı spiritüel arayışa yönlendirin
- Geyik sembolizmi ile çalışın
''',
      deepMeaning: '''
Mrigashira, Orion takımyıldızının başı (Lambda Orionis).
Boğa ve İkizler arasında köprü kurar.
Arayış ruhu - hem maddi hem spiritüel tatmin arzusu.
Brahma'nın kendi kızı Rohini'yi kovalaması hikayesi.
''',
      spiritualPath: '''
Mrigashira, Jnana Yoga ile Raja Yoga karışımını destekler.
Sorgulama ve araştırma yoluyla gerçeğe ulaşma.
Tatminsizlik, spiritüel arayışın motorudur.
Soma'yı (ölümsüzlük nektarı) içsel olarak bulmak hedefdir.
''',
      pada: [
        '1. Pada (Aslan navamsha): Yaratıcı arayış, liderlik',
        '2. Pada (Başak navamsha): Analitik araştırma, detay',
        '3. Pada (Terazi navamsha): İlişkisel arayış, estetik',
        '4. Pada (Akrep navamsha): Derin araştırma, okült',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 6. ARDRA - NEMLI
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 6,
      name: 'Ardra',
      meaning: 'Nemli, Taze, Gözyaşı',
      rulingDeity: 'Rudra - Fırtına Tanrısı, Shiva\'nın Yıkıcı Formu',
      rulingPlanet: 'Rahu',
      symbol: 'Gözyaşı damlası, Elmas, Insan başı',
      shakti: 'Yatna Shakti - Çaba ve Ulaşım gücü',
      nature: 'Tikshna (Keskin)',
      gana: 'Manushya (İnsani)',
      animal: 'Dişi Köpek',
      bird: 'Andira',
      tree: 'Ber (Hint Hurması)',
      guna: 'Tamas',
      tattva: 'Su (Jala)',
      caste: 'Butcher (Kasap)',
      gender: 'Kadın',
      temperament: 'Kama (Arzu)',
      primaryMotivation: 'Kama - Arzu ve Zevk',
      bodyPart: 'Göz arkası, Beyin',
      tantricPractice: '''
Ardra, yıkım yoluyla dönüşümün nakshatra'sıdır.
Rudra tapınması ve Shiva'nın yıkıcı formları burada çalışılır.
Karanlık gecenin (Dark Night of the Soul) nakshatra'sıdır.
Gözyaşları, arınmanın ve teslimiyetin aracıdır.
Fırtına enerjisi, stagnasyonu kırmak için kullanılır.
''',
      sexualEnergy: '''
Ardra, yoğun ve fırtınalı bir cinsel enerji taşır.
Tutkulu ama kaotik, derin ama çalkantılı.
Yıkım ve yeniden yaratım dinamiği cinsellikte de görülür.
Rahu'nun etkisi, alışılmadık ve tabu arzuları getirebilir.
''',
      compatibleNakshatras: ['Swati', 'Shatabhisha', 'Punarvasu', 'Ashlesha'],
      remedy: '''
Ardra zorlu dönemlerde:
- Rudra Abhisheka (Shiva'ya libation)
- Rahu mantrasını okuyun
- Gözyaşlarınızla arınmaya izin verin
- Fırtına sonrası yeniden doğuşu kutlayın
''',
      deepMeaning: '''
Ardra, Betelgeuse yıldızıdır (Orion'un omzunda).
İkizler burcunun kalbinde yer alır.
Acı yoluyla büyüme, yıkım yoluyla dönüşüm.
Rudra'nın gözyaşları, yaratımın tohumlarıdır.
''',
      spiritualPath: '''
Ardra, ego'nun yıkımı yoluyla kurtuluşu destekler.
Teslimiyet ve bırakma burada öğrenilir.
Rudra (yıkıcı) aslında şifacıdır - Shiva'nın tıp tanrısı yönü.
En karanlık gece, şafaktan hemen öncedir.
''',
      pada: [
        '1. Pada (Yay navamsha): Felsefi sorgulama, anlam arayışı',
        '2. Pada (Oğlak navamsha): Pratik dönüşüm, yeniden yapılanma',
        '3. Pada (Kova navamsha): Devrimci fikirler, insani dönüşüm',
        '4. Pada (Balık navamsha): Spiritüel yeniden doğuş, mistisizm',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 7. PUNARVASU - YENİDEN IŞIK
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 7,
      name: 'Punarvasu',
      meaning: 'Yeniden Dönüş, Işığın Restorasyon',
      rulingDeity: 'Aditi - Kozmik Anne, Sonsuzluk Tanrıçası',
      rulingPlanet: 'Guru (Jüpiter)',
      symbol: 'Ok kılıfı, Ev, Ok',
      shakti: 'Vasutva Prapana Shakti - Zenginlik ve Bolluk gücü',
      nature: 'Chara (Hareketli)',
      gana: 'Deva (Tanrısal)',
      animal: 'Dişi Kedi',
      bird: 'Kuğu',
      tree: 'Bambu',
      guna: 'Sattva',
      tattva: 'Su (Jala)',
      caste: 'Vaishya (Tüccar)',
      gender: 'Erkek',
      temperament: 'Artha (Maddi refah)',
      primaryMotivation: 'Artha - Maddi Güvenlik',
      bodyPart: 'Parmaklar, Burun',
      tantricPractice: '''
Punarvasu, restorasyon ve yenilenme ritüellerinin nakshatra'sıdır.
Aditi (kozmik anne) puja, sınırsızlık bilincini açar.
Eve dönüş teması, Atman'ın kaynağına dönüşünü simgeler.
Kayıpların geri kazanılması ritüelleri burada yapılır.
Guru'nun bereketiyle spiritüel bilgi restore edilir.
''',
      sexualEnergy: '''
Punarvasu, besleyici ve koruyucu cinsel enerji taşır.
Anne-çocuk dinamiği, güvenli bağlanmayı destekler.
Cinsel enerji, ev ve aile kurma arzusuna dönüşür.
Yeniden başlama ve tazelenme teması cinsellikte de görülür.
''',
      compatibleNakshatras: [
        'Pushya',
        'Uttara Phalguni',
        'Uttarashadha',
        'Hasta',
      ],
      remedy: '''
Punarvasu zayıfsa:
- Guru mantrasını okuyun
- Aditi'ye dua edin
- Sarı ve altın renk kullanın
- Eve ve köklerinize odaklanın
''',
      deepMeaning: '''
Punarvasu, Castor ve Pollux (İkizler) yıldızlarıdır.
İkizler ve Yengeç burçları arasında köprü kurar.
Kaybolanı geri getirme, hasar görenı restore etme gücü.
Rama'nın nakshatra'sıdır - dharma'nın restorasyonu.
''',
      spiritualPath: '''
Punarvasu, Bhakti Yoga ile Karma Yoga'yı birleştirir.
Kozmik anneye (Aditi) teslimiyet kurtuluş yoludur.
Spiritüel bilginin nesilden nesile aktarımı.
"Eve dönüş" teması - ruhun kaynağına dönüşü.
''',
      pada: [
        '1. Pada (Koç navamsha): Yeni başlangıçlar, cesaret',
        '2. Pada (Boğa navamsha): Maddi restorasyon, bolluk',
        '3. Pada (İkizler navamsha): Bilgi aktarımı, iletişim',
        '4. Pada (Yengeç navamsha): Duygusal şifa, annelik',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 8. PUSHYA - BESLEYİCİ
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 8,
      name: 'Pushya',
      meaning: 'Besleyici, Çiçek',
      rulingDeity: 'Brihaspati - Guru, Tanrıların Öğretmeni',
      rulingPlanet: 'Shani (Satürn)',
      symbol: 'Lotus çiçeği, İnek memesi, Ok, Çember',
      shakti: 'Brahmavarchasa Shakti - Spiritüel parlaklık gücü',
      nature: 'Kshipra (Hızlı, Hafif)',
      gana: 'Deva (Tanrısal)',
      animal: 'Erkek Keçi',
      bird: 'Kaz',
      tree: 'Peepal (Bodhi ağacı)',
      guna: 'Tamas - ama sattvic sonuçlar',
      tattva: 'Su (Jala)',
      caste: 'Kshatriya (Savaşçı)',
      gender: 'Erkek',
      temperament: 'Dharma (Doğruluk)',
      primaryMotivation: 'Dharma - Kozmik Düzen',
      bodyPart: 'Ağız, Yüz, İfade',
      tantricPractice: '''
Pushya, en auspicious (uğurlu) nakshatra olarak bilinir.
Diksha (spiritüel initiation) için en uygun zamandır.
Guru-shishya ilişkisinin kurulması Pushya'da idealdir.
Brahman bilincine ulaşma ritüelleri burada yapılır.
Peepal ağacı altında meditasyon özellikle güçlüdür.
''',
      sexualEnergy: '''
Pushya, en saf ve besleyici cinsel enerjiyi taşır.
Cinsellik burada kutsal bir birleşme olarak deneyimlenir.
Spiritüel ve fiziksel beslenme iç içe geçer.
Üreme ve nesil devamı teması öne çıkar.
''',
      compatibleNakshatras: [
        'Punarvasu',
        'Ashlesha',
        'Anuradha',
        'Uttara Bhadrapada',
      ],
      remedy: '''
Pushya enerjisini güçlendirmek için:
- Perşembe ve Cumartesi ritüelleri birleştirin
- Peepal ağacına su dökün
- Brahminlere yemek verin
- Spiritüel eğitim alın veya verin
''',
      deepMeaning: '''
Pushya, Yengeç burcunun kalbinde yer alır.
Shani yönetiminde olmasına rağmen en auspicious nakshatra'dır.
Bu paradoks, disiplin yoluyla spiritüel parlaklığı gösterir.
Her türlü başlangıç için en uygun nakshatra.
''',
      spiritualPath: '''
Pushya, tüm yoga yolları için idealdir.
Guru'nun (Brihaspati) bereketini taşır.
Shani'nin disiplini, spiritüel ilerlemeyi destekler.
"Brahmavarchasa" - Brahman'ın parlaklığını yansıtma.
''',
      pada: [
        '1. Pada (Aslan navamsha): Spiritüel liderlik, öğretmenlik',
        '2. Pada (Başak navamsha): Hizmet, detaylı çalışma',
        '3. Pada (Terazi navamsha): Dengeli spiritüellik, ilişkiler',
        '4. Pada (Akrep navamsha): Derin dönüşüm, okült bilgi',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 9. ASHLESHA - KUCAKLAYICI
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 9,
      name: 'Ashlesha',
      meaning: 'Kucaklayan, Sarmalayan',
      rulingDeity: 'Naga - Yılan Tanrıları',
      rulingPlanet: 'Budha (Merkür)',
      symbol: 'Sarmalanmış yılan, Yılan halkası',
      shakti: 'Vishasleshana Shakti - Zehir aşılama gücü',
      nature: 'Tikshna (Keskin)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Erkek Kedi',
      bird: 'Küçük mavi baştankara',
      tree: 'Champa (Manolya)',
      guna: 'Sattva',
      tattva: 'Su (Jala)',
      caste: 'Mleccha (Dışlanmış)',
      gender: 'Kadın',
      temperament: 'Dharma (Doğruluk)',
      primaryMotivation: 'Dharma - Kozmik Düzen',
      bodyPart: 'Tırnaklar, Eklemler',
      tantricPractice: '''
Ashlesha, Kundalini enerjisinin doğrudan nakshatra'sıdır.
Naga puja ve yılan ritüelleri burada en güçlüdür.
Zehirin ilaca dönüştürülmesi (simya) Ashlesha'nın sırrıdır.
Hypnotik ve manyetik güçler bu nakshatra ile gelişir.
Gizli bilgi ve mistik sırlar Ashlesha'nın domenidir.
''',
      sexualEnergy: '''
Ashlesha, en yoğun ve manyetik cinsel enerjiyi taşır.
Yılan gibi sarmalayan, hipnotize eden bir çekim.
Cinsel enerji burada Kundalini ile doğrudan bağlantılıdır.
Bağımlılık yapıcı ve obsesif olabilir - dikkat gerektirir.
''',
      compatibleNakshatras: ['Punarvasu', 'Pushya', 'Jyeshtha', 'Moola'],
      remedy: '''
Ashlesha zorlu etkiler gösteriyorsa:
- Naga Panchami'de yılan tapınağını ziyaret edin
- Budha mantrasını okuyun
- Sütle yılan figürlerine abhisheka yapın
- Olumsuz düşünce kalıplarını dönüştürün
''',
      deepMeaning: '''
Ashlesha, Yengeç burcunun sonunda yer alır.
Hydra takımyıldızının başıdır.
Yılan sembolizmi - bilgelik, tehlike, dönüşüm.
Gandanta (karmik düğüm) noktasındadır.
''',
      spiritualPath: '''
Ashlesha, Tantra'nın en derin yolunu temsil eder.
Kundalini yoga bu nakshatra ile doğrudan ilişkilidir.
Zehirin nektara dönüşümü - spiritüel simya.
Gölge benlikle yüzleşme ve entegrasyon.
''',
      pada: [
        '1. Pada (Yay navamsha): Felsefi yılan bilgeliği',
        '2. Pada (Oğlak navamsha): Pratik ve stratejik güç',
        '3. Pada (Kova navamsha): Mistik bilgi, reformcu',
        '4. Pada (Balık navamsha): En spiritüel, moksha odaklı',
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // 10. MAGHA - BÜYÜK
    // ═══════════════════════════════════════════════════════════════════════
    Nakshatra(
      number: 10,
      name: 'Magha',
      meaning: 'Büyük, Güçlü, Cömert',
      rulingDeity: 'Pitris - Atalar, Ölmüş Ruhlar',
      rulingPlanet: 'Ketu',
      symbol: 'Taht, Kraliyet odası, Palankin',
      shakti: 'Tyaga Kshepani Shakti - Bırakma ve ayrılma gücü',
      nature: 'Ugra (Şiddetli)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Erkek Sıçan',
      bird: 'Kartal',
      tree: 'Banyan (Vata)',
      guna: 'Tamas',
      tattva: 'Ateş (Agni)',
      caste: 'Shudra (İşçi)',
      gender: 'Kadın',
      temperament: 'Artha (Maddi refah)',
      primaryMotivation: 'Artha - Maddi Güvenlik',
      bodyPart: 'Dudaklar, Çene, Sağ yanağın altı',
      tantricPractice: '''
Magha, ata ruhları (Pitris) ile çalışmanın nakshatra'sıdır.
Shraddha (ata ritüelleri) burada en etkilidir.
Ketu'nun etkisi, geçmiş yaşam hatırlamalarını getirir.
Kraliyet tantrik pratikleri - güç ve otorite ritüelleri.
Soy ağacı şifası ve karmik miras çalışması.
''',
      sexualEnergy: '''
Magha, kraliyet ve asalet enerjisi taşır.
Cinsel enerji burada güç ve otorite ile ilişkilidir.
Soy devamı ve hanedan kurma arzusu öne çıkar.
Cinsellik bir "görev" veya "miras" olarak algılanabilir.
''',
      compatibleNakshatras: ['Uttara Phalguni', 'Swati', 'Shravana', 'Revati'],
      remedy: '''
Magha dengesizse:
- Atalara shraddha yapın
- Ketu mantrasını okuyun
- Banyan ağacına su dökün
- Geçmiş yaşam regresyonu düşünün
''',
      deepMeaning: '''
Magha, Regulus yıldızıdır - "Küçük Kral".
Aslan burcunun başlangıcında yer alır.
Kraliyet, liderlik ve otorite nakshatra'sıdır.
Atalarla bağlantı, köklerle temas.
''',
      spiritualPath: '''
Magha, Karma Yoga ile ata bilgeliğini birleştirir.
Geçmişi onurlandırarak geleceği inşa etme.
Ketu'nun spiritüel bırakma dersi burada güçlenir.
Dünyevi başarı ve spiritüel ayrılık paradoksu.
''',
      pada: [
        '1. Pada (Koç navamsha): Liderlik, cesaret, öncülük',
        '2. Pada (Boğa navamsha): Maddi miras, zenginlik',
        '3. Pada (İkizler navamsha): Entelektüel miras, bilgi',
        '4. Pada (Yengeç navamsha): Duygusal kökler, aile mirası',
      ],
    ),

    // Devam eden nakshatralar için özet formatla devam ediyoruz
    // ═══════════════════════════════════════════════════════════════════════
    // 11-27. DİĞER NAKSHATRALAR
    // ═══════════════════════════════════════════════════════════════════════

    // 11. PURVA PHALGUNI
    Nakshatra(
      number: 11,
      name: 'Purva Phalguni',
      meaning: 'Önceki Kızıl, Meyve Ağacı',
      rulingDeity: 'Bhaga - Zevk ve Zenginlik Tanrısı',
      rulingPlanet: 'Shukra (Venüs)',
      symbol: 'Yatak, Hamak, Ön ayakları of çardak',
      shakti: 'Prajanana Shakti - Üretme ve Yaratma gücü',
      nature: 'Ugra (Şiddetli)',
      gana: 'Manushya (İnsani)',
      animal: 'Dişi Sıçan',
      bird: 'Kartal',
      tree: 'Palash (Butea monosperma)',
      guna: 'Rajas',
      tattva: 'Ateş (Agni)',
      caste: 'Brahmin',
      gender: 'Kadın',
      temperament: 'Kama (Arzu)',
      primaryMotivation: 'Kama - Arzu ve Zevk',
      bodyPart: 'Üreme organları, Sağ el',
      tantricPractice:
          'Aşk ve zevk ritüelleri, tantrik birleşme pratikleri, Bhaga puja',
      sexualEnergy:
          'En romantik ve zevk odaklı cinsel enerji. Yaratıcı ve üretken.',
      compatibleNakshatras: ['Uttara Phalguni', 'Hasta', 'Swati', 'Anuradha'],
      remedy:
          'Shukra mantrasını okuyun, Lakshmi puja yapın, pembe çiçekler sunun',
      deepMeaning: 'Zevk yoluyla yaratım, romantik aşkın spiritüel boyutu',
      spiritualPath: 'Tantra yoluyla aydınlanma, zevki spiritüelleştirme',
      pada: [
        'Aslan - yaratıcılık',
        'Başak - pratik zevk',
        'Terazi - ilişkisel',
        'Akrep - derin tutku',
      ],
    ),

    // 12. UTTARA PHALGUNI
    Nakshatra(
      number: 12,
      name: 'Uttara Phalguni',
      meaning: 'Sonraki Kızıl',
      rulingDeity: 'Aryaman - Sözleşmeler ve Birlik Tanrısı',
      rulingPlanet: 'Surya (Güneş)',
      symbol: 'Yatak, Dört ayaklı çardak',
      shakti: 'Chayani Shakti - Zenginlik biriktirme gücü',
      nature: 'Dhruva (Sabit)',
      gana: 'Manushya (İnsani)',
      animal: 'Erkek İnek (Boğa)',
      bird: 'Kulkuş',
      tree: 'Gül ağacı',
      guna: 'Rajas',
      tattva: 'Ateş (Agni)',
      caste: 'Kshatriya',
      gender: 'Kadın',
      temperament: 'Moksha (Kurtuluş)',
      primaryMotivation: 'Moksha - Spiritüel Kurtuluş',
      bodyPart: 'Sol el, Cinsel organlar',
      tantricPractice:
          'Evlilik ve birlik ritüelleri, bağlılık tantrik pratikleri',
      sexualEnergy: 'Sadık, derin ve kalıcı cinsel bağlanma. Evlilik odaklı.',
      compatibleNakshatras: ['Purva Phalguni', 'Hasta', 'Chitra', 'Swati'],
      remedy: 'Surya mantrasını okuyun, evlilik sözleşmelerini kutlayın',
      deepMeaning: 'Birlik yoluyla kurtuluş, sadakat ve bağlılık',
      spiritualPath: 'Grihasta (ev sahibi) dharma yoluyla moksha',
      pada: [
        'Yay - felsefi birlik',
        'Oğlak - pratik ortaklık',
        'Kova - insancıl birlik',
        'Balık - spiritüel birlik',
      ],
    ),

    // 13. HASTA
    Nakshatra(
      number: 13,
      name: 'Hasta',
      meaning: 'El',
      rulingDeity: 'Savitar - Güneş Tanrısının Yaratıcı Formu',
      rulingPlanet: 'Chandra (Ay)',
      symbol: 'El, Avuç içi, Yumruk',
      shakti: 'Hasta Sthapaniya Agama Shakti - Ellerle elde etme gücü',
      nature: 'Kshipra (Hızlı)',
      gana: 'Deva (Tanrısal)',
      animal: 'Dişi Manda',
      bird: 'Karga',
      tree: 'Bilva (Hint Ayvası)',
      guna: 'Rajas',
      tattva: 'Toprak (Prithvi)',
      caste: 'Vaishya',
      gender: 'Erkek',
      temperament: 'Moksha (Kurtuluş)',
      primaryMotivation: 'Moksha - Spiritüel Kurtuluş',
      bodyPart: 'Eller, Parmaklar',
      tantricPractice: 'Mudra pratikleri, el ile şifa, sanat ritüelleri',
      sexualEnergy: 'Ellerle ifade edilen duyusal enerji. Masaj ve dokunuş.',
      compatibleNakshatras: ['Ashwini', 'Swati', 'Shravana', 'Revati'],
      remedy:
          'Savitar Gayatri mantrasını okuyun, eller ile yaratıcı işler yapın',
      deepMeaning:
          'Yaratıcılığın el becerileriyle ifadesi, sanat yoluyla kurtuluş',
      spiritualPath: 'Karma Yoga - eller ile hizmet',
      pada: [
        'Koç - beceri',
        'Boğa - zanaat',
        'İkizler - iletişim',
        'Yengeç - duygusal yaratım',
      ],
    ),

    // 14. CHITRA
    Nakshatra(
      number: 14,
      name: 'Chitra',
      meaning: 'Parlak, Renkli, Mücevher',
      rulingDeity: 'Tvashtar - İlahi Mimar ve Zanaatkar',
      rulingPlanet: 'Mangal (Mars)',
      symbol: 'Parlak mücevher, İnci',
      shakti: 'Punya Chayani Shakti - Erdem biriktirme gücü',
      nature: 'Mridu (Yumuşak)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Dişi Kaplan',
      bird: 'Yeşil güvercin',
      tree: 'Bilva',
      guna: 'Tamas',
      tattva: 'Ateş (Agni)',
      caste: 'Vaishya',
      gender: 'Kadın',
      temperament: 'Kama (Arzu)',
      primaryMotivation: 'Kama - Arzu ve Zevk',
      bodyPart: 'Alın, Boyun',
      tantricPractice:
          'Güzellik ritüelleri, estetik meditasyonlar, yaratıcı tantrik sanat',
      sexualEnergy:
          'Estetik ve görsel çekicilik. Güzellik yoluyla cinsel enerji.',
      compatibleNakshatras: ['Mrigashira', 'Anuradha', 'Hasta', 'Swati'],
      remedy: 'Tvashtar mantrasını okuyun, güzel sanatlarla uğraşın',
      deepMeaning: 'İlahi yaratıcılık, evrensel güzellik',
      spiritualPath: 'Sanat yoluyla aydınlanma',
      pada: [
        'Aslan - yaratıcı ifade',
        'Başak - teknik ustalık',
        'Terazi - estetik denge',
        'Akrep - derin sanat',
      ],
    ),

    // 15. SWATI
    Nakshatra(
      number: 15,
      name: 'Swati',
      meaning: 'Bağımsız, Kılıç',
      rulingDeity: 'Vayu - Rüzgar Tanrısı',
      rulingPlanet: 'Rahu',
      symbol: 'Mercan, Genç bitki, Kılıç',
      shakti: 'Pradhvamsa Shakti - Dağıtma gücü',
      nature: 'Chara (Hareketli)',
      gana: 'Deva (Tanrısal)',
      animal: 'Erkek Manda',
      bird: 'Arı kuşu',
      tree: 'Arjuna ağacı',
      guna: 'Tamas',
      tattva: 'Hava (Vayu)',
      caste: 'Butcher',
      gender: 'Kadın',
      temperament: 'Artha (Maddi refah)',
      primaryMotivation: 'Artha - Maddi Güvenlik',
      bodyPart: 'Göğüs, Meme',
      tantricPractice: 'Nefes çalışmaları, prana yönetimi, rüzgar ritüelleri',
      sexualEnergy: 'Özgür, hafif, esnek. Bağımsızlık içinde birleşme.',
      compatibleNakshatras: ['Ashwini', 'Hasta', 'Shravana', 'Shatabhisha'],
      remedy:
          'Vayu puja yapın, derin nefes egzersizleri, açık havada meditasyon',
      deepMeaning: 'Rüzgar gibi özgür ama güçlü, bağımsızlık ve denge',
      spiritualPath: 'Pranayama ve nefes yoluyla kurtuluş',
      pada: [
        'Yay - felsefi özgürlük',
        'Oğlak - pratik bağımsızlık',
        'Kova - sosyal özgürlük',
        'Balık - spiritüel özgürlük',
      ],
    ),

    // 16. VISHAKHA
    Nakshatra(
      number: 16,
      name: 'Vishakha',
      meaning: 'Dallı, İkiye Ayrılmış',
      rulingDeity: 'Indra-Agni - Şimşek ve Ateş Tanrıları',
      rulingPlanet: 'Guru (Jüpiter)',
      symbol: 'Zafer kemeri, Dal',
      shakti: 'Vyapana Shakti - Ulaşma ve Yayılma gücü',
      nature: 'Mishra (Karışık)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Erkek Kaplan',
      bird: 'Kızıl kuyruklu kartal',
      tree: 'Vikantaka (Dikenli)',
      guna: 'Sattva',
      tattva: 'Ateş (Agni)',
      caste: 'Mleccha',
      gender: 'Kadın',
      temperament: 'Dharma (Doğruluk)',
      primaryMotivation: 'Dharma - Kozmik Düzen',
      bodyPart: 'Kollar, Meme',
      tantricPractice: 'Hedef odaklı ritüeller, zafer tantras, Indra-Agni puja',
      sexualEnergy: 'Yoğun, hedef odaklı, fetih arzusu. Güçlü ve kararlı.',
      compatibleNakshatras: [
        'Anuradha',
        'Jyeshtha',
        'Uttarashadha',
        'Shravana',
      ],
      remedy: 'Indra ve Agni mantrasını okuyun, hedeflerinizi netleştirin',
      deepMeaning: 'Kararlılık ve odaklanma yoluyla başarı',
      spiritualPath: 'Tek hedefe odaklanma yoluyla aydınlanma',
      pada: [
        'Koç - savaşçı kararlılık',
        'Boğa - maddi hedefler',
        'İkizler - entelektüel hedefler',
        'Yengeç - duygusal hedefler',
      ],
    ),

    // 17. ANURADHA
    Nakshatra(
      number: 17,
      name: 'Anuradha',
      meaning: 'Radha\'nın Ardından',
      rulingDeity: 'Mitra - Dostluk Tanrısı',
      rulingPlanet: 'Shani (Satürn)',
      symbol: 'Lotus, Kadro, Üçlü iz',
      shakti: 'Radhana Shakti - Tapınma gücü',
      nature: 'Mridu (Yumuşak)',
      gana: 'Deva (Tanrısal)',
      animal: 'Dişi Geyik/Tavşan',
      bird: 'Saksağan',
      tree: 'Bakula (Mimusops)',
      guna: 'Tamas',
      tattva: 'Ateş (Agni)',
      caste: 'Shudra',
      gender: 'Erkek',
      temperament: 'Dharma (Doğruluk)',
      primaryMotivation: 'Dharma - Kozmik Düzen',
      bodyPart: 'Karın, Mide, Rahım',
      tantricPractice:
          'Dostluk ve sevgi ritüelleri, Mitra puja, bhakti tantras',
      sexualEnergy: 'Derin dostluk ve bağlılık yoluyla cinsel enerji. Sadakat.',
      compatibleNakshatras: [
        'Vishakha',
        'Jyeshtha',
        'Shravana',
        'Uttara Bhadrapada',
      ],
      remedy: 'Mitra mantrasını okuyun, dostlukları güçlendirin',
      deepMeaning: 'Dostluk ve sadakat yoluyla ilahi aşka ulaşma',
      spiritualPath: 'Bhakti Yoga - aşk ve bağlılık',
      pada: [
        'Aslan - yaratıcı dostluk',
        'Başak - hizmet eden dostluk',
        'Terazi - dengeli ilişki',
        'Akrep - derin bağ',
      ],
    ),

    // 18. JYESHTHA
    Nakshatra(
      number: 18,
      name: 'Jyeshtha',
      meaning: 'En Yaşlı, En Büyük',
      rulingDeity: 'Indra - Tanrıların Kralı',
      rulingPlanet: 'Budha (Merkür)',
      symbol: 'Yuvarlak tılsım, Küpe, Şemsiye',
      shakti: 'Arohana Shakti - Yükselme gücü',
      nature: 'Tikshna (Keskin)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Erkek Geyik/Tavşan',
      bird: 'Karatavuk',
      tree: 'Veta (Calamus)',
      guna: 'Sattva',
      tattva: 'Su (Jala)',
      caste: 'Kshatriya',
      gender: 'Kadın',
      temperament: 'Artha (Maddi refah)',
      primaryMotivation: 'Artha - Maddi Güvenlik',
      bodyPart: 'Dil, Boyun, Sağ taraf',
      tantricPractice:
          'Güç ve liderlik ritüelleri, Indra puja, koruyucu tantras',
      sexualEnergy: 'Dominant, güçlü, koruyucu. Liderlik yoluyla çekim.',
      compatibleNakshatras: ['Ashlesha', 'Anuradha', 'Moola', 'Shatabhisha'],
      remedy: 'Indra mantrasını okuyun, liderlik rollerini üstlenin',
      deepMeaning: 'Gerçek büyüklük, sorumluluk ile gelir',
      spiritualPath: 'Liderlik yoluyla hizmet',
      pada: [
        'Yay - felsefi liderlik',
        'Oğlak - pratik otorite',
        'Kova - insancıl liderlik',
        'Balık - spiritüel rehberlik',
      ],
    ),

    // 19. MOOLA
    Nakshatra(
      number: 19,
      name: 'Moola',
      meaning: 'Kök',
      rulingDeity: 'Nirriti - Yıkım Tanrıçası, Kali',
      rulingPlanet: 'Ketu',
      symbol: 'Kökler, Aslan kuyruğu',
      shakti: 'Barhana Shakti - Kökten söküm gücü',
      nature: 'Tikshna (Keskin)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Erkek Köpek',
      bird: 'Kırmızı akbaba',
      tree: 'Sarala (Çam)',
      guna: 'Tamas',
      tattva: 'Hava (Vayu)',
      caste: 'Butcher',
      gender: 'Nötr',
      temperament: 'Kama (Arzu)',
      primaryMotivation: 'Kama - Arzu ve Zevk',
      bodyPart: 'Ayaklar, Sol taraf',
      tantricPractice:
          'Kali puja, yıkım ve yeniden doğuş ritüelleri, kök çalışması',
      sexualEnergy: 'Yoğun, dönüştürücü, kökten sarsıcı. Tabuları kıran.',
      compatibleNakshatras: [
        'Ashlesha',
        'Jyeshtha',
        'Purvashadha',
        'Purva Bhadrapada',
      ],
      remedy:
          'Kali mantrasını okuyun, köklerinizi araştırın, bağımlılıkları bırakın',
      deepMeaning: 'Köke inme, temel gerçeklerle yüzleşme',
      spiritualPath: 'Yıkım yoluyla kurtuluş, sıfırdan başlama',
      pada: [
        'Koç - köklü cesaret',
        'Boğa - maddi kökler',
        'İkizler - entelektüel kökler',
        'Yengeç - duygusal kökler',
      ],
    ),

    // 20. PURVASHADHA
    Nakshatra(
      number: 20,
      name: 'Purvashadha',
      meaning: 'Önceki Yenilmez',
      rulingDeity: 'Apas - Su Tanrıçası',
      rulingPlanet: 'Shukra (Venüs)',
      symbol: 'Yelpaze, Fil dişi',
      shakti: 'Varchoghana Shakti - Canlandırma gücü',
      nature: 'Ugra (Şiddetli)',
      gana: 'Manushya (İnsani)',
      animal: 'Erkek Maymun',
      bird: 'Francolin',
      tree: 'Sita Ashoka',
      guna: 'Rajas',
      tattva: 'Toprak (Prithvi)',
      caste: 'Brahmin',
      gender: 'Kadın',
      temperament: 'Moksha (Kurtuluş)',
      primaryMotivation: 'Moksha - Spiritüel Kurtuluş',
      bodyPart: 'Sırt, Uyluklar',
      tantricPractice: 'Su ritüelleri, arınma tantras, Apas puja',
      sexualEnergy: 'Akışkan, arındırıcı, yenileyici. Su gibi adapte olan.',
      compatibleNakshatras: ['Moola', 'Uttarashadha', 'Shravana', 'Dhanishtha'],
      remedy: 'Su tanrıçasına dua edin, nehir veya okyanusta arınma yapın',
      deepMeaning: 'Su gibi engelleri aşma, yenilmez irade',
      spiritualPath: 'Akış ile kurtuluş, su elementi yoluyla arınma',
      pada: [
        'Aslan - yaratıcı akış',
        'Başak - pratik arınma',
        'Terazi - dengeli akış',
        'Akrep - derin dönüşüm',
      ],
    ),

    // 21. UTTARASHADHA
    Nakshatra(
      number: 21,
      name: 'Uttarashadha',
      meaning: 'Sonraki Yenilmez',
      rulingDeity: 'Vishve Devas - Evrensel Tanrılar',
      rulingPlanet: 'Surya (Güneş)',
      symbol: 'Fil dişi, Küçük yatak',
      shakti: 'Apradhrishya Shakti - Yenilemezlik gücü',
      nature: 'Dhruva (Sabit)',
      gana: 'Manushya (İnsani)',
      animal: 'Dişi Manda',
      bird: 'Leylek',
      tree: 'Kathal (Jackfruit)',
      guna: 'Rajas',
      tattva: 'Hava (Vayu)',
      caste: 'Kshatriya',
      gender: 'Kadın',
      temperament: 'Moksha (Kurtuluş)',
      primaryMotivation: 'Moksha - Spiritüel Kurtuluş',
      bodyPart: 'Uyluklar, Kalça',
      tantricPractice:
          'Evrensel tanrılar puja, zafer ritüelleri, liderlik tantras',
      sexualEnergy: 'Güçlü, kararlı, zafer odaklı. Evrensel enerji.',
      compatibleNakshatras: [
        'Purvashadha',
        'Shravana',
        'Dhanishtha',
        'Punarvasu',
      ],
      remedy: 'Vishve Devas mantrasını okuyun, evrensel değerlere bağlanın',
      deepMeaning: 'Nihai zafer, evrensel başarı',
      spiritualPath: 'Dharma yoluyla evrensel kurtuluş',
      pada: [
        'Yay - felsefi zafer',
        'Oğlak - pratik başarı',
        'Kova - insancıl zafer',
        'Balık - spiritüel zafer',
      ],
    ),

    // 22. SHRAVANA
    Nakshatra(
      number: 22,
      name: 'Shravana',
      meaning: 'Dinleme',
      rulingDeity: 'Vishnu - Koruyucu Tanrı',
      rulingPlanet: 'Chandra (Ay)',
      symbol: 'Kulak, Üç ayak izi',
      shakti: 'Samhanana Shakti - Bağlama gücü',
      nature: 'Chara (Hareketli)',
      gana: 'Deva (Tanrısal)',
      animal: 'Dişi Maymun',
      bird: 'Kartal',
      tree: 'Arka (Calotropis)',
      guna: 'Rajas',
      tattva: 'Su (Jala)',
      caste: 'Mleccha',
      gender: 'Erkek',
      temperament: 'Artha (Maddi refah)',
      primaryMotivation: 'Artha - Maddi Güvenlik',
      bodyPart: 'Kulaklar, Genital bölge',
      tantricPractice: 'Mantra yoga, dinleme meditasyonları, Vishnu puja',
      sexualEnergy: 'Dinleme ve alma odaklı. Alıcı, duyarlı cinsel enerji.',
      compatibleNakshatras: ['Hasta', 'Swati', 'Uttarashadha', 'Dhanishtha'],
      remedy: 'Vishnu mantrasını dinleyin, sessizlik pratiği yapın',
      deepMeaning: 'İlahi sesi dinleme yoluyla bilgelik',
      spiritualPath: 'Nada Yoga - ses yoluyla kurtuluş',
      pada: [
        'Koç - aktif dinleme',
        'Boğa - pratik öğrenme',
        'İkizler - entelektüel dinleme',
        'Yengeç - duygusal dinleme',
      ],
    ),

    // 23. DHANISHTHA
    Nakshatra(
      number: 23,
      name: 'Dhanishtha',
      meaning: 'Zenginlik, Şöhret',
      rulingDeity: 'Ashta Vasus - Sekiz Vasu',
      rulingPlanet: 'Mangal (Mars)',
      symbol: 'Davul, Flüt',
      shakti: 'Khyapayitri Shakti - Ün kazanma gücü',
      nature: 'Chara (Hareketli)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Dişi Aslan',
      bird: 'Altın kaz',
      tree: 'Shami (Prosopis)',
      guna: 'Tamas',
      tattva: 'Eter (Akasha)',
      caste: 'Vaishya',
      gender: 'Kadın',
      temperament: 'Dharma (Doğruluk)',
      primaryMotivation: 'Dharma - Kozmik Düzen',
      bodyPart: 'Sırt, Anüs',
      tantricPractice: 'Müzik ritüelleri, ritm tantras, Vasu puja',
      sexualEnergy: 'Ritmik, müzikal, şöhret odaklı. Performans enerjisi.',
      compatibleNakshatras: [
        'Shravana',
        'Shatabhisha',
        'Purva Bhadrapada',
        'Uttara Bhadrapada',
      ],
      remedy: 'Müzik ile meditasyon, Ashta Vasu mantrasını okuyun',
      deepMeaning: 'Ritim ve harmoni yoluyla evrensel zenginlik',
      spiritualPath: 'Sanat ve müzik yoluyla kurtuluş',
      pada: [
        'Aslan - yaratıcı şöhret',
        'Başak - pratik başarı',
        'Terazi - dengeli ün',
        'Akrep - derin şöhret',
      ],
    ),

    // 24. SHATABHISHA
    Nakshatra(
      number: 24,
      name: 'Shatabhisha',
      meaning: 'Yüz Şifacı',
      rulingDeity: 'Varuna - Okyanus Tanrısı',
      rulingPlanet: 'Rahu',
      symbol: 'Boş daire, Yüz yıldız',
      shakti: 'Bheshaja Shakti - Şifa gücü',
      nature: 'Chara (Hareketli)',
      gana: 'Rakshasa (Demonik)',
      animal: 'Dişi At',
      bird: 'Saksağan',
      tree: 'Kadamba',
      guna: 'Tamas',
      tattva: 'Eter (Akasha)',
      caste: 'Butcher',
      gender: 'Nötr',
      temperament: 'Dharma (Doğruluk)',
      primaryMotivation: 'Dharma - Kozmik Düzen',
      bodyPart: 'Sağ uyluk, Çene',
      tantricPractice: 'Şifa ritüelleri, okült pratikler, Varuna puja',
      sexualEnergy: 'Gizemli, şifalı, derin. Okült ve gizli enerji.',
      compatibleNakshatras: [
        'Ardra',
        'Swati',
        'Dhanishtha',
        'Purva Bhadrapada',
      ],
      remedy: 'Varuna mantrasını okuyun, şifa pratikleri yapın',
      deepMeaning: 'Gizli şifa bilgisi, okült güçler',
      spiritualPath: 'Şifa yoluyla kurtuluş',
      pada: [
        'Yay - felsefi şifa',
        'Oğlak - pratik tıp',
        'Kova - insancıl şifa',
        'Balık - spiritüel şifa',
      ],
    ),

    // 25. PURVA BHADRAPADA
    Nakshatra(
      number: 25,
      name: 'Purva Bhadrapada',
      meaning: 'Önceki Şanslı Ayak',
      rulingDeity: 'Aja Ekapada - Tek Ayaklı Keçi',
      rulingPlanet: 'Guru (Jüpiter)',
      symbol: 'İki yüzlü adam, Kılıç, Yatak',
      shakti: 'Yajamana Udyamana Shakti - Yükselme gücü',
      nature: 'Ugra (Şiddetli)',
      gana: 'Manushya (İnsani)',
      animal: 'Erkek Aslan',
      bird: 'Avosetta',
      tree: 'Neem',
      guna: 'Sattva',
      tattva: 'Eter (Akasha)',
      caste: 'Brahmin',
      gender: 'Erkek',
      temperament: 'Artha (Maddi refah)',
      primaryMotivation: 'Artha - Maddi Güvenlik',
      bodyPart: 'Sol taraf, Kalça',
      tantricPractice: 'Ateş ritüelleri, yükselme tantras, Rudra puja',
      sexualEnergy: 'İkili doğa, yoğun, dönüştürücü. Ateşli ve spiritüel.',
      compatibleNakshatras: [
        'Moola',
        'Shatabhisha',
        'Uttara Bhadrapada',
        'Revati',
      ],
      remedy: 'Aja Ekapada mantrasını okuyun, ateş ritüelleri yapın',
      deepMeaning: 'İkili doğanın birleşimi, spiritüel yükseliş',
      spiritualPath: 'Tapas (çilecilik) yoluyla kurtuluş',
      pada: [
        'Koç - cesur yükseliş',
        'Boğa - maddi dönüşüm',
        'İkizler - entelektüel evrim',
        'Yengeç - duygusal dönüşüm',
      ],
    ),

    // 26. UTTARA BHADRAPADA
    Nakshatra(
      number: 26,
      name: 'Uttara Bhadrapada',
      meaning: 'Sonraki Şanslı Ayak',
      rulingDeity: 'Ahirbudhnya - Derin Deniz Yılanı',
      rulingPlanet: 'Shani (Satürn)',
      symbol: 'İkizler, Yılan, Yatak',
      shakti: 'Varshodyamana Shakti - Yağmur getirme gücü',
      nature: 'Dhruva (Sabit)',
      gana: 'Manushya (İnsani)',
      animal: 'Dişi İnek',
      bird: 'Koralazurite',
      tree: 'Neem',
      guna: 'Tamas',
      tattva: 'Eter (Akasha)',
      caste: 'Kshatriya',
      gender: 'Kadın',
      temperament: 'Kama (Arzu)',
      primaryMotivation: 'Kama - Arzu ve Zevk',
      bodyPart: 'Bacaklar, Ayak tabanı',
      tantricPractice: 'Kundalini yoga, derin meditasyonlar, Shiva puja',
      sexualEnergy: 'Derin, gizemli, Kundalini odaklı. Spiritüel birleşme.',
      compatibleNakshatras: [
        'Anuradha',
        'Pushya',
        'Purva Bhadrapada',
        'Revati',
      ],
      remedy: 'Ahirbudhnya mantrasını okuyun, derin meditasyon yapın',
      deepMeaning: 'Kozmik derinlik, spiritüel bilgelik',
      spiritualPath: 'Derin meditasyon yoluyla kurtuluş',
      pada: [
        'Aslan - yaratıcı derinlik',
        'Başak - pratik bilgelik',
        'Terazi - dengeli spiritüellik',
        'Akrep - derin dönüşüm',
      ],
    ),

    // 27. REVATI
    Nakshatra(
      number: 27,
      name: 'Revati',
      meaning: 'Zengin, Refah',
      rulingDeity: 'Pushan - Yolların Tanrısı, Koruyucu',
      rulingPlanet: 'Budha (Merkür)',
      symbol: 'Balık, Davul',
      shakti: 'Kshiradyapani Shakti - Beslenme gücü',
      nature: 'Mridu (Yumuşak)',
      gana: 'Deva (Tanrısal)',
      animal: 'Dişi Fil',
      bird: 'Hint papağanı',
      tree: 'Madhuca (Mahua)',
      guna: 'Sattva',
      tattva: 'Eter (Akasha)',
      caste: 'Shudra',
      gender: 'Kadın',
      temperament: 'Moksha (Kurtuluş)',
      primaryMotivation: 'Moksha - Spiritüel Kurtuluş',
      bodyPart: 'Ayak bilekleri, Ayaklar',
      tantricPractice: 'Koruyucu ritüeller, yolculuk tantras, Pushan puja',
      sexualEnergy: 'Besleyici, koruyucu, şefkatli. Koşulsuz sevgi enerjisi.',
      compatibleNakshatras: [
        'Ashwini',
        'Bharani',
        'Hasta',
        'Uttara Bhadrapada',
      ],
      remedy: 'Pushan mantrasını okuyun, seyahatlerde dua edin',
      deepMeaning: 'Yolculuğun sonu ve yeni başlangıç, döngünün tamamlanması',
      spiritualPath: 'Teslimiyet ve bırakma yoluyla kurtuluş',
      pada: [
        'Yay - felsefi yolculuk',
        'Oğlak - pratik sonuç',
        'Kova - insancıl döngü',
        'Balık - spiritüel tamamlanma',
      ],
    ),
  ];

  /// Nakshatra'yı numarasına göre bul
  static Nakshatra? getNakshatraByNumber(int number) {
    if (number < 1 || number > 27) return null;
    return allNakshatras[number - 1];
  }

  /// Nakshatra'yı ismine göre bul
  static Nakshatra? getNakshatraByName(String name) {
    try {
      return allNakshatras.firstWhere(
        (n) => n.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Gezegene göre nakshatra'ları filtrele
  static List<Nakshatra> getNakshatrasByPlanet(String planet) {
    return allNakshatras
        .where(
          (n) => n.rulingPlanet.toLowerCase().contains(planet.toLowerCase()),
        )
        .toList();
  }

  /// Gana'ya göre nakshatra'ları filtrele
  static List<Nakshatra> getNakshatrasByGana(String gana) {
    return allNakshatras
        .where((n) => n.gana.toLowerCase().contains(gana.toLowerCase()))
        .toList();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// DASHA - GEZEGEN PERİYOTLARI SİSTEMİ
// ════════════════════════════════════════════════════════════════════════════

class DashaContent {
  /// Vimshottari Dasha Sistemi - 120 Yıllık Döngü
  static const String vimshottariExplanation = '''
VİMSHOTTARİ DASHA SİSTEMİ

Vimshottari Dasha, Vedik astrolojinin en önemli tahmin aracıdır.
120 yıllık bir döngüde 9 gezegen sırayla egemenlik sürer.

TEMEL İLKELER:
• Doğum nakshatra'sının yönetici gezegeni, ilk dasha'yı belirler
• Her gezegen belirli bir süre boyunca yaşamı etkiler
• Antardasha (alt dönem) ana gezegen içinde diğer gezegenlerin etkisini gösterir
• Pratyantardasha daha da ince alt dönemlerdir

DÖNGÜ SIRASI:
Ketu → Şukra → Surya → Chandra → Mangal → Rahu → Guru → Shani → Budha

SPİRİTÜEL ANLAM:
Her dasha dönemi, ruhun belirli dersler öğrenmesi için tasarlanmıştır.
Zor dashalar, karmik borçların ödenmesi içindir.
Olumlu dashalar, geçmiş iyi karmaların meyvelerini toplamaktır.
''';

  static const List<DashaPeriod> allDashas = [
    // KETU DASHA - 7 YIL
    DashaPeriod(
      planet: 'Ketu',
      years: 7,
      meaning: '''
Ketu Dasha, spiritüel uyanış ve dünyevi bağlardan kopuş dönemidir.
Geçmiş yaşam karmaları yüzeye çıkar, tamamlanmamış işler bitirilir.
Kayıplar yoluyla bırakma öğrenilir.
''',
      spiritualEvolution: '''
Ketu dönemi, ego'nun eritilmesi ve ruhun özgürleşmesi içindir.
Meditasyon ve içe dönüş doğal olarak derinleşir.
Geçmiş yaşam yetenekleri ortaya çıkabilir.
Moksha (kurtuluş) arzusu güçlenir.
''',
      challenges: '''
• Kafa karışıklığı ve yön bulmakta zorluk
• Ani kayıplar ve ayrılıklar
• Sağlık sorunları (özellikle sinir sistemi)
• Dünyevi başarıda zorluklar
• İzolasyon ve yalnızlık hissi
''',
      opportunities: '''
• Spiritüel aydınlanma
• Geçmiş yaşam hatırlamaları
• Psişik yeteneklerin gelişimi
• Karmaik borçların temizlenmesi
• Derin meditasyon deneyimleri
''',
      karma: '''
Ketu dasha, geçmiş yaşamlardan getirilen spiritüel yeteneklerin
ve eksik kalan derslerin işlenmesi içindir. Bu dönemde
dünyevi hırslar zayıflar, spiritüel arayış öne çıkar.
''',
      antardashas: {
        'Ketu-Ketu': 'En yoğun kopuş dönemi, derin meditasyon',
        'Ketu-Shukra': 'İlişkilerde bırakma, sanat yoluyla şifa',
        'Ketu-Surya': 'Ego ile yüzleşme, otorite sorunları',
        'Ketu-Chandra': 'Duygusal arınma, anne konuları',
        'Ketu-Mangal': 'Enerji dengesizlikleri, spiritüel savaşçılık',
        'Ketu-Rahu': 'Karmaik dönüm noktası, kafa karışıklığı',
        'Ketu-Guru': 'Spiritüel öğretmenle karşılaşma, bilgelik',
        'Ketu-Shani': 'Zorlu ama dönüştürücü, disiplin',
        'Ketu-Budha': 'Mental netlik arayışı, öğrenme',
      },
    ),

    // SHUKRA DASHA - 20 YIL
    DashaPeriod(
      planet: 'Shukra',
      years: 20,
      meaning: '''
Venüs dasha'sı en uzun dönemlerden biridir (20 yıl).
Aşk, güzellik, maddi bolluk ve duyusal zevkler öne çıkar.
Evlilik, sanat ve finansal büyüme bu dönemin temaları.
''',
      spiritualEvolution: '''
Shukra dönemi, güzellik yoluyla Tanrı'yı bulmayı öğretir.
Tantrik yol, cinsel enerjiyi spiritüel güce dönüştürme fırsatı sunar.
Bhakti (aşk yoluyla ibadet) bu dönemde derinleşir.
İlişkiler, ayna görevi görerek kendi gölgemizi gösterir.
''',
      challenges: '''
• Aşırı indulgence ve bağımlılıklar
• Yüzeysellik ve materyalizm
• İlişki dramları ve hayal kırıklıkları
• Finansal savurganlık
• Beğenilme ihtiyacı ve özdeğer sorunları
''',
      opportunities: '''
• Evlilik ve derin ilişkiler
• Sanatsal başarı ve yaratıcılık
• Maddi bolluk ve konfor
• Güzellik ve estetik geliştirme
• Diplomasi ve sosyal beceriler
''',
      karma: '''
Shukra dasha, geçmiş yaşamlardaki ilişki karmalarını işler.
Verdiğiniz ve aldığınız sevgi, bu dönemde geri döner.
Maddi karma da (zenginlik veya yoksulluk) bu dönemde olgunlaşır.
''',
      antardashas: {
        'Shukra-Shukra': 'En güçlü Venüs etkisi, aşk ve bolluk',
        'Shukra-Surya': 'Yaratıcılık, sanat liderliği',
        'Shukra-Chandra': 'Duygusal ilişkiler, annelik/babalık',
        'Shukra-Mangal': 'Tutkulu ilişkiler, çatışma ve uzlaşma',
        'Shukra-Rahu': 'Alışılmadık ilişkiler, yabancı etkiler',
        'Shukra-Guru': 'Bilge aşk, spiritüel ilişkiler',
        'Shukra-Shani': 'İlişkilerde olgunlaşma, sadakat testleri',
        'Shukra-Budha': 'Sanat ve iletişim, ticari başarı',
        'Shukra-Ketu': 'İlişkilerde bırakma, spiritüel aşk',
      },
    ),

    // SURYA DASHA - 6 YIL
    DashaPeriod(
      planet: 'Surya',
      years: 6,
      meaning: '''
Güneş dasha'sı, ego'nun güçlenmesi ve kimlik oluşumu dönemidir.
Liderlik, tanınma, otorite ve baba konuları öne çıkar.
Kariyer atılımları ve toplumsal statü bu dönemde şekillenir.
''',
      spiritualEvolution: '''
Surya dönemi, Atman'ı (gerçek benliği) keşfetme fırsatı sunar.
Güneş, spiritüel ışığın kaynağıdır - "Aham Brahmasmi" bilinci.
Ego'nun sağlıklı gelişimi, spiritüel yolculuk için gereklidir.
Dharma (yaşam amacı) bu dönemde netleşir.
''',
      challenges: '''
• Ego şişmesi ve kibir
• Otorite figürleriyle çatışmalar
• Baba sorunları veya kayıpları
• Aşırı hırs ve tükenmişlik
• Kalp ve göz sağlığı sorunları
''',
      opportunities: '''
• Liderlik pozisyonları
• Kariyer başarısı ve tanınma
• Öz-güven gelişimi
• Sağlık ve canlılık
• Hükümet veya otorite ile olumlu ilişkiler
''',
      karma: '''
Surya dasha, geçmiş yaşamlardaki güç ve otorite karmalarını işler.
Başkalarına nasıl davrandığınız, bu dönemde geri döner.
Baba ile ilişki, geçmiş yaşam bağlantılarını yansıtır.
''',
      antardashas: {
        'Surya-Surya': 'Kimlik netleşmesi, güç artışı',
        'Surya-Chandra': 'Anne-baba dinamiği, duygusal denge',
        'Surya-Mangal': 'Cesaret ve savaşçılık, liderlik',
        'Surya-Rahu': 'Alışılmadık başarılar, yurt dışı',
        'Surya-Guru': 'Bilgelik ve otorite birleşimi, öğretmenlik',
        'Surya-Shani': 'Otorite testleri, disiplin öğrenme',
        'Surya-Budha': 'İletişim liderliği, ticaret',
        'Surya-Ketu': 'Ego bırakma, spiritüel liderlik',
        'Surya-Shukra': 'Yaratıcı liderlik, sanat ve güç',
      },
    ),

    // CHANDRA DASHA - 10 YIL
    DashaPeriod(
      planet: 'Chandra',
      years: 10,
      meaning: '''
Ay dasha'sı, duygusal yaşam, anne ve aile konularının öne çıktığı dönemdir.
Ev, güvenlik, beslenme ve içsel dünya bu dönemin odağıdır.
Zihinsel aktivite ve psikolojik süreçler yoğunlaşır.
''',
      spiritualEvolution: '''
Chandra dönemi, zihnin doğasını ve koşullanmaları anlamayı öğretir.
Ay, Maya'nın (illüzyon) yansımasıdır - gerçek ile görünen arasındaki fark.
Duygusal arınma ve içsel şifa bu dönemde gerçekleşir.
Meditasyon pratiği doğal olarak derinleşir.
''',
      challenges: '''
• Duygusal istikrarsızlık ve mood değişimleri
• Anne sorunları veya kayıpları
• Anksiyete ve depresyon riski
• Ev ve aile sorunları
• Bağımlılık ve duygusal bağımlılık
''',
      opportunities: '''
• Duygusal zeka gelişimi
• Aile ve ev kurma
• Yaratıcılık ve sanat
• Sezgisel yeteneklerin açılması
• Psikolojik şifa ve terapi
''',
      karma: '''
Chandra dasha, anne karması ve duygusal yaraları işler.
Geçmiş yaşamlardan getirilen duygusal kalıplar yüzeye çıkar.
Besleyicilik ve bakım verme/alma karması olgunlaşır.
''',
      antardashas: {
        'Chandra-Chandra': 'Duygusal yoğunluk, sezgisel açılım',
        'Chandra-Mangal': 'Duygusal cesaret, anne-oğul dinamiği',
        'Chandra-Rahu': 'Duygusal kafa karışıklığı, yabancı etkiler',
        'Chandra-Guru': 'Duygusal bilgelik, spiritüel anne',
        'Chandra-Shani': 'Duygusal olgunlaşma, zorlu ama dönüştürücü',
        'Chandra-Budha': 'Duygusal iletişim, yazarlık',
        'Chandra-Ketu': 'Duygusal bırakma, spiritüel duyarlılık',
        'Chandra-Shukra': 'Aşk ve duygular, romantizm',
        'Chandra-Surya': 'Anne-baba birliği, kimlik ve duygular',
      },
    ),

    // MANGAL DASHA - 7 YIL
    DashaPeriod(
      planet: 'Mangal',
      years: 7,
      meaning: '''
Mars dasha'sı, enerji, cesaret, rekabet ve mücadele dönemidir.
Fiziksel aktivite, spor, mülk konuları ve kardeşler öne çıkar.
Çatışma ve zafer temaları bu dönemde yoğunlaşır.
''',
      spiritualEvolution: '''
Mangal dönemi, içsel savaşçıyı uyandırır - ego ile mücadele.
Korkuları yenmek ve cesareti geliştirmek spiritüel derslerdir.
Tapas (spiritüel çilecilik) bu dönemde doğal hale gelir.
Cinsel enerjinin yüceltilmesi ve dönüştürülmesi öğrenilir.
''',
      challenges: '''
• Öfke patlamaları ve agresyon
• Kazalar ve yaralanmalar riski
• Çatışmalar ve düşmanlıklar
• Sabırsızlık ve dürtüsellik
• Kardeş sorunları ve mülk anlaşmazlıkları
''',
      opportunities: '''
• Fiziksel güç ve dayanıklılık
• Cesaret ve kararlılık
• Mülk edinme
• Spor ve atletik başarı
• Teknik ve mühendislik becerileri
''',
      karma: '''
Mangal dasha, savaş ve çatışma karmalarını işler.
Geçmiş yaşamlardaki şiddet veya korunma karmaları yüzeye çıkar.
Kardeşlerle ilişki, geçmiş yaşam bağlantılarını yansıtır.
''',
      antardashas: {
        'Mangal-Mangal': 'Maksimum enerji, cesaret ve risk',
        'Mangal-Rahu': 'Alışılmadık eylemler, teknoloji',
        'Mangal-Guru': 'Dharma için savaş, öğretmen savaşçı',
        'Mangal-Shani': 'Disiplinli mücadele, zorlu ama ödüllendirici',
        'Mangal-Budha': 'Stratejik düşünce, polemik',
        'Mangal-Ketu': 'Spiritüel savaşçılık, içsel fetih',
        'Mangal-Shukra': 'Tutkulu ilişkiler, sanat ve enerji',
        'Mangal-Surya': 'Liderlik mücadelesi, güç gösterisi',
        'Mangal-Chandra': 'Duygusal cesaret, aile koruması',
      },
    ),

    // RAHU DASHA - 18 YIL
    DashaPeriod(
      planet: 'Rahu',
      years: 18,
      meaning: '''
Rahu dasha'sı en uzun ve en dönüştürücü dönemlerden biridir (18 yıl).
Dünyevi hırslar, yabancı etkiler, teknoloji ve alışılmadık yollar öne çıkar.
Maya (illüzyon) ve gerçeklik arasındaki mücadele bu dönemin temasıdır.
''',
      spiritualEvolution: '''
Rahu dönemi, arzuların sonsuz döngüsünü deneyimleterek öğretir.
Maya'nın gerçek doğasını anlamak için arzuları deneyimlemek gerekir.
Gölge benlik (Shadow Self) ile yüzleşme bu dönemde gerçekleşir.
Obsesyonlar spiritüel arayışa dönüştürülebilir.
''',
      challenges: '''
• Obsesyonlar ve bağımlılıklar
• Aldatılma ve yanılgılar
• Ani yükselişler ve düşüşler
• Skandallar ve itibar sorunları
• Zihinsel karışıklık ve kafa karışıklığı
''',
      opportunities: '''
• Dünyevi başarı ve zenginlik
• Teknoloji ve inovasyonda ilerleme
• Yurt dışı fırsatları
• Alışılmadık kariyer yolları
• Okült ve gizli bilimlerde ilerleme
''',
      karma: '''
Rahu dasha, tamamlanmamış dünyevi arzuların karmasını işler.
Geçmiş yaşamlarda bastırılan istekler yüzeye çıkar.
Bu arzuları deneyimlemek ve aşmak, karmik serbestleşme sağlar.
''',
      antardashas: {
        'Rahu-Rahu': 'En yoğun Maya, obsesyon ve potansiyel uyanış',
        'Rahu-Guru': 'Bilgelik ve arzu arasında denge',
        'Rahu-Shani': 'Karmaik dersler, zorlu ama dönüştürücü',
        'Rahu-Budha': 'Mental obsesyonlar, zekice planlar',
        'Rahu-Ketu': 'Derin karmaik dönüm noktası',
        'Rahu-Shukra': 'Aşırı zevkler, lüks ve tehlike',
        'Rahu-Surya': 'Güç obsesyonu, ego şişmesi',
        'Rahu-Chandra': 'Duygusal karmaşa, psişik deneyimler',
        'Rahu-Mangal': 'Agresif hırslar, riskli eylemler',
      },
    ),

    // GURU DASHA - 16 YIL
    DashaPeriod(
      planet: 'Guru',
      years: 16,
      meaning: '''
Jüpiter dasha'sı, genişleme, bilgelik, şans ve spiritüel büyüme dönemidir.
Eğitim, öğretmenlik, çocuklar ve dharma konuları öne çıkar.
Bereket ve bolluk bu dönemin genel temasıdır.
''',
      spiritualEvolution: '''
Guru dönemi, gerçek bir spiritüel öğretmenle karşılaşma fırsatı sunar.
Dharma (yaşam amacı) ve Jnana (bilgelik) bu dönemde netleşir.
Genişleyen bilinç, evrensel bakış açısı getirir.
Diksha (spiritüel initiation) bu dönemde gerçekleşebilir.
''',
      challenges: '''
• Aşırı iyimserlik ve gerçekçilik eksikliği
• Kilo alma ve sağlık ihmalı
• Dogmatizm ve bağnazlık
• Aşırı genişleme ve dağılma
• Çocuklarla ilgili endişeler
''',
      opportunities: '''
• Spiritüel öğretmenle karşılaşma
• Yükseköğretim ve bilgelik
• Yurt dışı seyahatler ve genişleme
• Çocuk sahibi olma
• Finansal bolluk ve şans
''',
      karma: '''
Guru dasha, öğretmenlik ve bilgelik karmalarını işler.
Geçmiş yaşamlarda verilen veya alınan bilgi geri döner.
Dharma (görevi yerine getirme) karması olgunlaşır.
''',
      antardashas: {
        'Guru-Guru': 'Maksimum bilgelik ve bereket',
        'Guru-Shani': 'Disiplinli spiritüel pratik',
        'Guru-Budha': 'Entelektüel genişleme, öğretmenlik',
        'Guru-Ketu': 'Spiritüel kurtuluşa doğru ilerleme',
        'Guru-Shukra': 'Zenginlik ve ilişkilerde bereket',
        'Guru-Surya': 'Otorite ve bilgelik birleşimi',
        'Guru-Chandra': 'Duygusal bilgelik, annelik/babalık',
        'Guru-Mangal': 'Dharma için cesaret, öğretmen savaşçı',
        'Guru-Rahu': 'Genişleyen hırslar, dikkatli olunmalı',
      },
    ),

    // SHANI DASHA - 19 YIL
    DashaPeriod(
      planet: 'Shani',
      years: 19,
      meaning: '''
Satürn dasha'sı, en zorlu ama en dönüştürücü dönemdir (19 yıl).
Karma, disiplin, sınırlama ve olgunlaşma temaları öne çıkar.
Hayatın gerçekleriyle yüzleşme ve sorumluluk alma dönemidir.
''',
      spiritualEvolution: '''
Shani dönemi, ego'nun tamamen yeniden yapılandırılmasını sağlar.
Karanlık gece (Dark Night of the Soul) deneyimi bu dönemde yaşanır.
Gerçek teslimiyet ve tevazu, Shani'nin armağanlarıdır.
Vairagya (bağımsızlık) bilinci bu dönemde gelişir.
''',
      challenges: '''
• Kronik sağlık sorunları
• Kariyer engelleri ve gecikmeler
• Depresyon ve pesimizm
• İzolasyon ve yalnızlık
• Finansal kısıtlamalar
''',
      opportunities: '''
• Derin olgunlaşma ve bilgelik
• Kalıcı başarılar inşa etme
• Disiplin ve yapı geliştirme
• Karmaik borçların temizlenmesi
• Spiritüel derinleşme
''',
      karma: '''
Shani dasha, tüm karmik hesapların ödenmesi zamanıdır.
Geçmiş eylemlerin sonuçları bu dönemde olgunlaşır.
"Ekileni biçersin" prensibi en net bu dönemde çalışır.
''',
      antardashas: {
        'Shani-Shani': 'En yoğun karma ödeme, derin dönüşüm',
        'Shani-Budha': 'Disiplinli öğrenme, pratik bilgelik',
        'Shani-Ketu': 'Spiritüel çilecilik, bırakma',
        'Shani-Shukra': 'İlişkilerde testler, olgun aşk',
        'Shani-Surya': 'Otorite ile yüzleşme, ego disiplini',
        'Shani-Chandra': 'Duygusal olgunlaşma, anne karması',
        'Shani-Mangal': 'Disiplinli enerji, yapıcı güç',
        'Shani-Rahu': 'Karmaik dönüm noktası, kafa karışıklığı',
        'Shani-Guru': 'Bilgelik ve disiplin birleşimi, öğretmenlik',
      },
    ),

    // BUDHA DASHA - 17 YIL
    DashaPeriod(
      planet: 'Budha',
      years: 17,
      meaning: '''
Merkür dasha'sı, iletişim, öğrenme, ticaret ve analiz dönemidir.
Zeka, beceri, uyum sağlama ve çoklu yetenekler öne çıkar.
İş, yazı, öğretim ve ticaret alanlarında aktivite artar.
''',
      spiritualEvolution: '''
Budha dönemi, ayrımcı bilgeliği (Viveka) geliştirme fırsatı sunar.
Zihin, gerçek ile yanılgıyı ayırt etmeyi öğrenir.
Mantra yoga ve ses titreşimleri bu dönemde güçlenir.
Jnana Yoga (bilgi yolu) doğal olarak derinleşir.
''',
      challenges: '''
• Sinir sistemi sorunları
• Aşırı analiz ve endişe
• İletişim sorunları ve yanlış anlaşılmalar
• Dağınıklık ve odaklanma zorlukları
• Cilt ve solunum sorunları
''',
      opportunities: '''
• Entelektüel gelişim ve öğrenme
• İş ve ticaret başarısı
• Yazarlık ve iletişim
• Teknoloji ve bilgi işlem
• Çoklu projeler ve beceriler
''',
      karma: '''
Budha dasha, iletişim ve öğrenme karmalarını işler.
Geçmiş yaşamlarda kullanılan veya kötüye kullanılan bilgi geri döner.
Dil ve konuşma karması bu dönemde olgunlaşır.
''',
      antardashas: {
        'Budha-Budha': 'Maksimum entelektüel aktivite',
        'Budha-Ketu': 'Spiritüel entelektüalizm, sezgisel bilgi',
        'Budha-Shukra': 'Sanat ve iletişim, ticari başarı',
        'Budha-Surya': 'İletişim liderliği, kamu konuşması',
        'Budha-Chandra': 'Duygusal zeka, yazarlık',
        'Budha-Mangal': 'Cesur iletişim, polemik',
        'Budha-Rahu': 'Teknoloji ve inovasyon, dikkatli olunmalı',
        'Budha-Guru': 'Bilgelik ve öğretmenlik, yükseköğretim',
        'Budha-Shani': 'Disiplinli çalışma, pratik bilgi',
      },
    ),
  ];

  /// Dasha dönemini gezegen adına göre bul
  static DashaPeriod? getDashaByPlanet(String planet) {
    try {
      return allDashas.firstWhere(
        (d) => d.planet.toLowerCase() == planet.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Tüm dasha dönemlerinin toplam süresini hesapla
  static int getTotalDashaCycle() {
    return allDashas.fold(0, (sum, d) => sum + d.years);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// YOGA - GEZEGEN KOMBİNASYONLARI
// ════════════════════════════════════════════════════════════════════════════

class YogaContent {
  static const List<JyotishYoga> allYogas = [
    // ═══════════════════════════════════════════════════════════════════════
    // RAJA YOGALAR - GÜÇ VE OTORİTE
    // ═══════════════════════════════════════════════════════════════════════
    JyotishYoga(
      name: 'Gaja Kesari Yoga',
      category: 'Raja Yoga',
      formation: 'Jüpiter, Ay\'dan kendra konumunda (1., 4., 7., 10. evler)',
      effect: '''
Kişiye aslan gibi cesaret, fil gibi güç ve bilgelik verir.
Toplumda saygınlık, liderlik pozisyonları ve etkili konuşma yeteneği.
Uzun ömür, refah ve başkalarını yönlendirme kapasitesi.
''',
      spiritualMeaning: '''
Bu yoga, bilgeliğin (Guru) ve zihnin (Chandra) harmonik birleşimini temsil eder.
Spiritüel öğretiler kolayca anlaşılır ve uygulanır.
Dharma yolunda doğal liderlik ortaya çıkar.
''',
      tantricImplication: '''
Gaja Kesari, Kundalini uyanışı için uygun bir zemin hazırlar.
Guru'nun bereketli enerjisi, Chandra'nın alıcı doğasıyla birleşir.
Spiritüel initiation ve mantra diksha için idealdir.
''',
      rarity: 'Orta (haritaların yaklaşık %25\'inde)',
      celebrities: ['Mahatma Gandhi', 'Abraham Lincoln'],
    ),

    JyotishYoga(
      name: 'Pancha Mahapurusha Yoga - Ruchaka',
      category: 'Raja Yoga',
      formation: 'Mars kendi burcunda veya uccha\'da, kendra evinde',
      effect: '''
Komutan, savaşçı, lider karakteri verir.
Fiziksel güç, cesaret, mülk sahipliği.
Askeri veya polis kariyerinde başarı.
''',
      spiritualMeaning: '''
Ruchaka Yoga, dharma için savaşma cesaretini verir.
Spiritüel savaşçı arketipi - içsel şeytanlarla mücadele.
Koruyucu ve savunucu rol, zayıfları koruma.
''',
      tantricImplication: '''
Mars enerjisi, Kundalini'nin ateşli gücünü destekler.
Muladhara çakranın aktivasyonu güçlüdür.
Tantrik çilecilik (Tapas) için uygun enerji sağlar.
''',
      rarity: 'Nadir (haritaların yaklaşık %5\'inde)',
      celebrities: ['Subhash Chandra Bose', 'Alexander the Great'],
    ),

    JyotishYoga(
      name: 'Pancha Mahapurusha Yoga - Bhadra',
      category: 'Raja Yoga',
      formation: 'Merkür kendi burcunda veya uccha\'da, kendra evinde',
      effect: '''
Mükemmel iletişim, zeka ve analitik düşünce.
Ticaret, eğitim ve yazarlıkta başarı.
Gençlik görünümü, çekicilik ve ikna kabiliyeti.
''',
      spiritualMeaning: '''
Bhadra Yoga, ilahi bilgiyi ifade etme yeteneği verir.
Spiritüel öğretileri anlaşılır şekilde aktarabilme.
Viveka (ayrımcı bilgelik) doğal olarak gelişir.
''',
      tantricImplication: '''
Merkür, Vishuddha çakrayı güçlendirir.
Mantra yoga ve ses titreşimleri doğal olarak ustalaşılır.
Spiritüel öğretileri yazılı aktarma yeteneği.
''',
      rarity: 'Nadir (haritaların yaklaşık %5\'inde)',
      celebrities: ['Albert Einstein', 'Warren Buffett'],
    ),

    JyotishYoga(
      name: 'Pancha Mahapurusha Yoga - Hamsa',
      category: 'Raja Yoga',
      formation: 'Jüpiter kendi burcunda veya uccha\'da, kendra evinde',
      effect: '''
Bilgelik, spiritüellik, öğretmenlik ve refah.
Toplumda saygınlık, ahlaki otorite.
Brahminler ve bilginler arasında önder.
''',
      spiritualMeaning: '''
Hamsa (kuğu), Brahman'ı gerçeklikten ayırt edebilen bilgeliği simgeler.
"Neti Neti" - ne bu ne o - ayrımcı bilgelik.
Spiritüel öğretmenlik ve guru potansiyeli.
''',
      tantricImplication: '''
Guru, Ajna çakrayı aktive eder - üçüncü göz.
Diksha (spiritüel initiation) verme yeteneği.
Mantra siddhi (mantra ustalığı) kolayca elde edilir.
''',
      rarity: 'Çok Nadir (haritaların yaklaşık %2\'sinde)',
      celebrities: ['Ramana Maharshi', 'Dalai Lama'],
    ),

    JyotishYoga(
      name: 'Pancha Mahapurusha Yoga - Malavya',
      category: 'Raja Yoga',
      formation: 'Venüs kendi burcunda veya uccha\'da, kendra evinde',
      effect: '''
Güzellik, çekicilik, sanat, lüks ve konfor.
Evlilik mutluluğu, romantik başarı.
Sanat, moda ve lüks sektörlerde başarı.
''',
      spiritualMeaning: '''
Malavya Yoga, ilahi güzelliği dünyada yansıtma yeteneği verir.
Bhakti (aşk yoluyla ibadet) doğal eğilim.
Güzellik yoluyla Tanrı'yı görebilme.
''',
      tantricImplication: '''
Venüs, Svadhisthana ve Anahata çakraları güçlendirir.
Tantrik aşk pratikleri için ideal enerji.
Shakti prensibinin dünyevi tezahürü.
''',
      rarity: 'Nadir (haritaların yaklaşık %5\'inde)',
      celebrities: ['Marilyn Monroe', 'Princess Diana'],
    ),

    JyotishYoga(
      name: 'Pancha Mahapurusha Yoga - Shasha',
      category: 'Raja Yoga',
      formation: 'Satürn kendi burcunda veya uccha\'da, kendra evinde',
      effect: '''
Otorite, disiplin, uzun ömür ve kalıcı başarı.
Politika, yönetim ve organizasyonda mükemmellik.
Halk lideri, köy veya şehir yöneticisi.
''',
      spiritualMeaning: '''
Shasha Yoga, sabır ve disiplin yoluyla spiritüel ilerleme sağlar.
Karma Yoga'nın mükemmel ifadesi.
Dharma'ya bağlılık ve sorumluluk bilinci.
''',
      tantricImplication: '''
Satürn, Muladhara'yı temelden güçlendirir.
Uzun süreli sadhana (spiritüel pratik) için dayanıklılık.
Tapasya (çilecilik) doğal hale gelir.
''',
      rarity: 'Nadir (haritaların yaklaşık %5\'inde)',
      celebrities: ['Abraham Lincoln', 'Angela Merkel'],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // DHANA YOGALAR - ZENGİNLİK
    // ═══════════════════════════════════════════════════════════════════════
    JyotishYoga(
      name: 'Lakshmi Yoga',
      category: 'Dhana Yoga',
      formation: '9. ev lordu kendra veya trikona\'da, güçlü konumda',
      effect: '''
Büyük zenginlik, şans ve refah.
Beklenmedik miras ve kazançlar.
Hayatta bolluk ve bereket.
''',
      spiritualMeaning: '''
Lakshmi, sadece maddi değil spiritüel zenginliği de temsil eder.
Dharma (9. ev) ile bağlantı, zenginliğin doğru kullanımını sağlar.
Bereket, başkalarıyla paylaşıldığında çoğalır.
''',
      tantricImplication: '''
Lakshmi puja ve Sri Yantra çalışması güçlenir.
Maddi bolluk, spiritüel yolculuğu destekler.
Dana (bağış) karması bu yoga ile ilişkilidir.
''',
      rarity: 'Orta-Nadir',
      celebrities: ['Bill Gates', 'Mukesh Ambani'],
    ),

    JyotishYoga(
      name: 'Dhana Yoga',
      category: 'Dhana Yoga',
      formation: '2. ve 11. ev lordlarının karşılıklı bağlantısı',
      effect: '''
Kazanç ve birikim yetenekleri.
Finansal istikrar ve büyüme.
Aile zenginliği ve miras.
''',
      spiritualMeaning: '''
Maddi güvenlik, spiritüel arayış için zemin hazırlar.
2. ev değerler, 11. ev kazançlar - ikisinin dengesi.
Zenginlik bir test olarak da görülebilir.
''',
      tantricImplication: '''
Kubera (zenginlik tanrısı) ile çalışma güçlenir.
Maddi kaynakları spiritüel amaçlar için kullanma.
''',
      rarity: 'Orta',
      celebrities: ['Warren Buffett', 'Elon Musk'],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // SPİRİTÜEL YOGALAR
    // ═══════════════════════════════════════════════════════════════════════
    JyotishYoga(
      name: 'Moksha Yoga',
      category: 'Spiritüel Yoga',
      formation: 'Ketu 12. evde, Jupiter aspekt ile',
      effect: '''
Spiritüel kurtuluş eğilimi.
Dünyevi bağlardan doğal kopuş.
Meditasyon ve içe dönüş yeteneği.
''',
      spiritualMeaning: '''
Moksha Yoga, bu yaşamda aydınlanma potansiyelini gösterir.
Samsara (varoluş çarkı) döngüsünden çıkış imkanı.
Guru'nun bereketli etkisi, Ketu'nun bırakma gücü ile birleşir.
''',
      tantricImplication: '''
Sahasrara çakra aktivasyonu için ideal.
Kundalini'nin nihai hedefine ulaşma potansiyeli.
Samadhi (derin meditasyon) deneyimleri.
''',
      rarity: 'Çok Nadir',
      celebrities: ['Ramana Maharshi', 'Nisargadatta Maharaj'],
    ),

    JyotishYoga(
      name: 'Pravrajya Yoga',
      category: 'Spiritüel Yoga',
      formation: '4+ gezegen tek evde, Satürn dahil',
      effect: '''
Sanyasa (dünyadan el çekme) eğilimi.
Keşiş veya münzevi yaşam.
Dünyevi bağlardan radikal kopuş.
''',
      spiritualMeaning: '''
Bu yoga, ruhun dünyadan tamamen çekilme ihtiyacını gösterir.
Tek başına spiritüel arayış, toplumdan uzaklaşma.
Monastik yaşam veya uzun süreli inziva dönemleri.
''',
      tantricImplication: '''
Tantrik keşiş geleneği için uygun.
Yoğun sadhana dönemleri, tek başına pratik.
Derin meditasyon ve tapas.
''',
      rarity: 'Çok Nadir',
      celebrities: ['Swami Vivekananda', 'Buddha (doğum haritası)'],
    ),

    JyotishYoga(
      name: 'Saraswati Yoga',
      category: 'Spiritüel Yoga',
      formation: 'Jüpiter, Venüs ve Merkür kendra veya trikona\'da',
      effect: '''
Mükemmel bilgelik, öğrenme ve sanat.
Edebiyat, müzik ve eğitimde başarı.
Çoklu dillere hakimiyet.
''',
      spiritualMeaning: '''
Saraswati, ilahi bilginin akışını temsil eder.
Veda'lar ve kutsal metinlerin anlaşılması.
Spiritüel bilgiyi sanat yoluyla ifade etme.
''',
      tantricImplication: '''
Saraswati puja ve mantra yoga güçlenir.
Kutsal metinlerin ezoterik anlamlarına ulaşma.
Ses ve müzik yoluyla spiritüel deneyim.
''',
      rarity: 'Nadir',
      celebrities: ['Rabindranath Tagore', 'Pandit Ravi Shankar'],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // TANTRİK YOGALAR
    // ═══════════════════════════════════════════════════════════════════════
    JyotishYoga(
      name: 'Kundalini Yoga',
      category: 'Tantrik Yoga',
      formation: 'Ketu 1. evde, Mars veya Rahu ile aspekt',
      effect: '''
Güçlü Kundalini aktivasyonu potansiyeli.
Spiritüel deneyimler ve uyanışlar.
Psişik yetenekler ve sezgi.
''',
      spiritualMeaning: '''
Kundalini, omurgada uyuyan yılan enerjisidir.
Bu yoga, enerjinin doğal olarak yükselmesini destekler.
Dikkatli pratik ve yol gösterici gerektirir.
''',
      tantricImplication: '''
Tantrik initiation için güçlü aday.
Shakti uyanışı ve çakra aktivasyonu.
Guru rehberliği kritik önem taşır.
''',
      rarity: 'Nadir',
      celebrities: ['Paramahansa Yogananda', 'Gopi Krishna'],
    ),

    JyotishYoga(
      name: 'Shakti Yoga',
      category: 'Tantrik Yoga',
      formation: 'Venüs ve Mars birlikte veya karşılıklı aspekt',
      effect: '''
Güçlü cinsel ve yaratıcı enerji.
Çekim gücü ve manyetizma.
Sanat ve yaratıcılıkta ustalık.
''',
      spiritualMeaning: '''
Shakti (feminin) ve Shiva (maskülen) enerjilerinin birleşimi.
Yaratıcı gücün spiritüel dönüşümü.
İçsel evlilik - Animus ve Anima entegrasyonu.
''',
      tantricImplication: '''
Tantrik birliktelik pratikleri için ideal enerji.
Cinsel enerjinin yüceltilmesi.
Kundalini'nin Shakti yönünün güçlü ifadesi.
''',
      rarity: 'Orta',
      celebrities: ['Osho', 'Tantra öğretmenleri'],
    ),

    JyotishYoga(
      name: 'Vimala Yoga',
      category: 'Spiritüel Yoga',
      formation: '12. ev lordu 12. evde veya kendi burcunda',
      effect: '''
Spiritüel saflık ve bırakma yeteneği.
Yurt dışında yaşama veya spiritüel inziva.
Hayırseverlik ve hizmet.
''',
      spiritualMeaning: '''
12. ev moksha (kurtuluş) evidir.
Bu yoga, dünyevi bağlardan arınmayı kolaylaştırır.
Ruhun özgürleşme yolculuğu desteklenir.
''',
      tantricImplication: '''
Meditasyon ve içe dönüş pratikleri güçlenir.
Astral seyahat ve rüya bilinci.
Sonsuzluk bilincine açılım.
''',
      rarity: 'Orta-Nadir',
      celebrities: ['Mother Teresa', 'Spiritüel liderler'],
    ),
  ];

  /// Yoga'yı kategoriye göre filtrele
  static List<JyotishYoga> getYogasByCategory(String category) {
    return allYogas
        .where((y) => y.category.toLowerCase().contains(category.toLowerCase()))
        .toList();
  }

  /// Yoga'yı ismine göre bul
  static JyotishYoga? getYogaByName(String name) {
    try {
      return allYogas.firstWhere(
        (y) => y.name.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MUHURTA - SEÇİM ASTROLOJİSİ VE UYGUN ZAMANLAR
// ════════════════════════════════════════════════════════════════════════════

class MuhurtaContent {
  static const String muhurtaExplanation = '''
MUHURTA - UYGUN ZAMAN SEÇİMİ

Muhurta, Vedik astrolojinin önemli bir dalıdır.
Doğru zamanda başlayan işler, kozmik enerjiyle uyumlu olduğundan
başarı şansı artar.

TEMEL İLKELER:
• Shubha (hayırlı) nakshatralar önemli işler için seçilir
• Tithi (ay günü) aktiviteye uygun olmalı
• Var (gün) gezegenlerin doğasına göre seçilir
• Yoga ve Karana ek faktörler olarak değerlendirilir
• Lagna (yükselen burç) aktiviteye uygun olmalı

PANCHANGA - 5 UNSUR:
1. Tithi - Ay günü (30 tithi bir ay döngüsünde)
2. Vara - Hafta günü (7 gün)
3. Nakshatra - Ay konağı (27 nakshatra)
4. Yoga - Güneş ve Ay kombinasyonu (27 yoga)
5. Karana - Yarım tithi (11 karana)
''';

  static const List<Muhurta> allMuhurtas = [
    // EVLİLİK MUHURTASI
    Muhurta(
      name: 'Vivaha Muhurta',
      purpose: 'Evlilik ve Nikah Töreni',
      auspiciousTiming: '''
EN UYGUN DÖNEMLER:
• Uttara Phalguni, Rohini, Mrigashira, Magha nakshatra'ları
• Shukla Paksha (artan ay) dönemleri
• 2., 3., 5., 7., 10., 11., 13. tithiler
• Perşembe, Cuma, Pazartesi, Çarşamba günleri

YÜKSELEN BURÇ:
• Boğa, Yengeç, Aslan, Başak, Kova, Balık tercih edilir
• 7. evde malefik (zararlı) gezegen olmamalı
''',
      avoidTiming: '''
KAÇINILACAK DÖNEMLER:
• Bhadra (Vishti Karana) dönemleri
• Rikta Tithi (4., 9., 14. tithiler)
• Amavasya (yeni ay) ve Purnima (dolunay)
• Salı ve Cumartesi
• Koç, Akrep, Oğlak burçları lagna'da
• Rahu Kalam zamanları
''',
      nakshatraRecommendation: '''
EN İYİ NAKSHATRALAR:
1. Rohini - En auspicious, bolluk ve güzellik
2. Uttara Phalguni - Evlilik nakshatra'sı
3. Hasta - El ele tutuşma, beceri
4. Swati - Bağımsızlık içinde birlik
5. Anuradha - Dostluk ve sadakat

KAÇINILACAK NAKSHATRALAR:
• Bharani (ölüm ile ilişkili)
• Ardra, Ashlesha (zorlu)
• Moola, Jyeshtha (gandanta noktaları)
''',
      tithi: '2, 3, 5, 7, 10, 11, 12, 13',
      weekday: 'Perşembe, Cuma, Pazartesi, Çarşamba',
      tantricTiming: '''
TANTRİK EVLİLİK ZAMANLARI:
• Dolunay (Purnima) tantrik birleşme için güçlü
• Venüs hora'sı romantik bağ için ideal
• Pushya nakshatra'sı spiritüel evlilik için en uygun
• Gece saatleri (Nishitha kala) tantrik ritüeller için
''',
    ),

    // SPİRİTÜEL INİTİATION MUHURTASI
    Muhurta(
      name: 'Diksha Muhurta',
      purpose: 'Spiritüel İnitiation (Diksha) ve Mantra Aktarımı',
      auspiciousTiming: '''
EN UYGUN DÖNEMLER:
• Pushya nakshatra - En auspicious diksha için
• Punarvasu, Hasta, Shravana nakshatra'ları
• Perşembe (Guruvar) - Guru'nun günü
• Shukla Paksha (artan ay), özellikle Ekadashi

GURU'NUN KONUMU:
• Jüpiter güçlü ve auspicious konumda olmalı
• Jüpiter combustion (yanık) veya retrograd olmamalı
• 5. ve 9. evler güçlü olmalı (spiritüel evler)
''',
      avoidTiming: '''
KAÇINILACAK DÖNEMLER:
• Amavasya (yeni ay)
• Jüpiter zayıf veya afflicted
• Malefik nakshatra'lar (Ardra, Ashlesha, Jyeshtha, Moola)
• Rahu-Ketu ekseni aktif
• Guru combustion dönemleri
''',
      nakshatraRecommendation: '''
DİKSHA İÇİN EN İYİ NAKSHATRALAR:
1. Pushya - Brahmin nakshatra'sı, en auspicious
2. Punarvasu - Eve dönüş, bilgelik
3. Shravana - Dinleme ve öğrenme
4. Hasta - Eller ile aktarım
5. Ashwini - Hızlı başlangıç
''',
      tithi: '2, 3, 5, 7, 10, 11, 12',
      weekday: 'Perşembe (ideal), Pazartesi, Çarşamba',
      tantricTiming: '''
TANTRİK İNİTİATION ZAMANLARI:
• Brahma Muhurta (gün doğumundan 96 dk önce) - En kutsal
• Abhijit Muhurta (güneş tam tepede) - Güçlü
• Dolunay geceleri - Ay enerjisi en yüksek
• Maha Shivaratri - Shiva diksha için ideal
• Navaratri - Shakti diksha için ideal
''',
    ),

    // TANTRİK PRATİK MUHURTASI
    Muhurta(
      name: 'Tantra Sadhana Muhurta',
      purpose: 'Tantrik Pratik ve Sadhana',
      auspiciousTiming: '''
GENEL TANTRİK PRATİK ZAMANLARI:
• Brahma Muhurta (03:30 - 06:00) - Sattvik pratikler
• Sandhya (alacakaranlık) zamanları - Geçiş enerjisi
• Gece yarısı (Nishitha Kala) - Tantrik pratikler
• Amavasya (yeni ay) - Karanlık tanrıçalar

KUNDALINI PRATİKLERİ:
• Shukla Paksha (artan ay) - Enerji yükselişi
• Tam dolunay geceleri - Maksimum enerji
• Gün doğumu - Sushumna aktivasyonu
''',
      avoidTiming: '''
KAÇINILACAK DÖNEMLER:
• Tutulmalar sırasında yeni pratiklere başlamayın
• Rahu Kalam - Dikkatli olunmalı
• Hasta veya yorgunken pratik yapmayın
• Aşırı duygusal dönemlerde dikkat
''',
      nakshatraRecommendation: '''
TANTRİK PRATİK NAKSHATRALARI:
1. Ashlesha - Kundalini, yılan enerjisi
2. Bharani - Ölüm ve yeniden doğuş
3. Moola - Kök, temel dönüşüm
4. Ardra - Yıkım ve arınma
5. Chitra - Yaratıcı tantrik sanat
''',
      tithi: 'Amavasya (yeni ay), 8. tithi (Ashtami), 14. tithi (Chaturdashi)',
      weekday:
          'Salı (Mars enerjisi), Cumartesi (Shani disiplini), Pazar (Surya gücü)',
      tantricTiming: '''
ÖZEL TANTRİK ZAMANLAR:
• Kali Puja - Amavasya geceleri, özellikle Diwali amavasya
• Shakti Sadhana - Navaratri dokuzu
• Shiva Pratikler - Pradosh (13. tithi akşamı)
• Maithuna (tantrik birleşme) - Dolunay geceleri
• Yantra Siddhi - Perşembe veya Cuma, şafakta
''',
    ),

    // KUTSAL BİRLİKTELİK MUHURTASI
    Muhurta(
      name: 'Maithuna Muhurta',
      purpose: 'Kutsal Birleşme ve Tantrik Union',
      auspiciousTiming: '''
EN UYGUN DÖNEMLER:
• Dolunay (Purnima) geceleri - Maksimum lunar enerji
• Shukla Paksha (artan ay) - Artan enerji
• Venüs hora'sı - Aşk ve bağlanma
• Gece yarısından sonrası - Derin birleşme

GEZEGEN KONUMLARI:
• Venüs güçlü ve auspicious olmalı
• Mars dengeli olmalı (aşırı değil)
• Ay güçlü ve artan fazda olmalı
''',
      avoidTiming: '''
KAÇINILACAK DÖNEMLER:
• Amavasya (yeni ay) - Enerji düşük
• Krishna Paksha (azalan ay) son günleri
• Tutulmalar ve yakın dönemleri
• Adet döneminde (geleneksel yorum)
• Hastalık ve yorgunluk dönemlerinde
''',
      nakshatraRecommendation: '''
KUTSAL BİRLEŞME İÇİN NAKSHATRALAR:
1. Rohini - En duyusal ve besleyici
2. Purva Phalguni - Zevk ve yaratım
3. Bharani - Derin dönüşüm
4. Mrigashira - Oyuncu keşif
5. Swati - Özgür birleşme
''',
      tithi: 'Purnima (dolunay), 5., 10., 15. tithiler',
      weekday: 'Cuma (Venüs günü), Pazartesi (Ay günü)',
      tantricTiming: '''
TANTRİK BİRLEŞME ZAMANLARI:
• Dolunay gecesi (Purnima) - Soma (nektar) en yoğun
• Venüs saati - Aşk enerjisi güçlü
• Gece yarısı (Nishitha) - Gizli zamanlar
• Brahma Muhurta - Spiritüel birleşme
• Purnima'dan 3 gün önce ve sonra - Yoğun dönem
''',
    ),

    // MANTRA SADHANA MUHURTASI
    Muhurta(
      name: 'Mantra Sadhana Muhurta',
      purpose: 'Mantra Pratiği ve Japa',
      auspiciousTiming: '''
EN UYGUN ZAMANLAR:
• Brahma Muhurta (gün doğumundan 96 dk önce) - En kutsal
• Sandhya (alacakaranlık) - Sabah ve akşam
• Öğle vakti (Madhyahna) - Gayatri için
• Gece yarısı - Tantrik mantralar için

GEZEGEN SAATLERI:
• Jüpiter hora - Guru ve bilgelik mantraları
• Venüs hora - Lakshmi, aşk mantraları
• Ay hora - Chandra, zihin mantraları
''',
      avoidTiming: '''
KAÇINILACAK DÖNEMLER:
• Yemek yerken veya hemen sonrasında
• Tuvalet veya banyo sırasında
• Aşırı yorgun veya hasta iken
• Öfkeli veya duygusal iken
''',
      nakshatraRecommendation: '''
MANTRA PRATİĞİ İÇİN NAKSHATRALAR:
1. Pushya - En auspicious, tüm mantralar
2. Shravana - Dinleme ve ses
3. Hasta - Mala (tespih) kullanımı
4. Ashwini - Hızlı siddhi (ustalık)
5. Rohini - Besleyici mantralar
''',
      tithi: 'Shukla Paksha günleri, özellikle Ekadashi',
      weekday: 'Gezegenin kendi günü (Surya-Pazar, Chandra-Pazartesi, vb.)',
      tantricTiming: '''
MANTRA SİDDHİ İÇİN ÖZEL ZAMANLAR:
• 40 gün kesintisiz pratik (Mandala)
• Tutulma dönemleri - 10x güçlü
• Maha Shivaratri - Shiva mantraları
• Navaratri - Devi mantraları
• Guru Purnima - Guru mantraları
''',
    ),

    // YANTRA SIDDHI MUHURTASI
    Muhurta(
      name: 'Yantra Puja Muhurta',
      purpose: 'Yantra Kurulum ve Enerji Yükleme',
      auspiciousTiming: '''
EN UYGUN ZAMANLAR:
• Perşembe (Guruvar) - Genel yantralar için
• Cuma (Shukravar) - Sri Yantra için
• Cumartesi - Shani yantra için
• Brahma Muhurta - Enerji yükleme için ideal

GEZEGEN SAATLERI:
• İlgili gezegenin hora'sında kurulum
• Shubha muhurta seçilmeli
• Tutulmalardan kaçınılmalı
''',
      avoidTiming: '''
KAÇINILACAK DÖNEMLER:
• Rahu Kalam zamanları
• Amavasya (yeni ay) - Çoğu yantra için
• İlgili gezegenin zayıf olduğu dönemler
• Retrograd dönemleri
''',
      nakshatraRecommendation: '''
YANTRA KURULUM İÇİN NAKSHATRALAR:
1. Pushya - En auspicious
2. Ashwini - Hızlı aktivasyon
3. Rohini - Güçlü enerji
4. Hasta - El becerileri
5. Uttara Phalguni - Kalıcılık
''',
      tithi: '2., 3., 5., 7., 10., 11., 12. tithiler',
      weekday: 'Yantra\'nın ilişkili olduğu gezegenin günü',
      tantricTiming: '''
YANTRA AKTİVASYON RİTÜELİ:
1. Yantra'yı Ganga suyu ile yıkayın
2. Süt, bal, ghee ile abhisheka yapın
3. Çiçekler ve tütsü sunun
4. İlgili mantra'yı 108 veya 1008 kez okuyun
5. Ghee lambası yakın
6. Yantra'yı uygun yöne yerleştirin
''',
    ),
  ];

  /// Muhurta'yı amaca göre bul
  static Muhurta? getMuhurtaByPurpose(String purpose) {
    try {
      return allMuhurtas.firstWhere(
        (m) => m.purpose.toLowerCase().contains(purpose.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }

  /// Tüm muhurtaları al
  static List<Muhurta> getAllMuhurtas() => allMuhurtas;
}

// ════════════════════════════════════════════════════════════════════════════
// UPAYA - ÇARE VE REMEDY SİSTEMİ
// ════════════════════════════════════════════════════════════════════════════

class UpayaContent {
  static const String upayaExplanation = '''
UPAYA - VEDİK ÇARELER VE REMEDİLER

Upaya, Vedik astrolojide gezegen etkilerini dengelemek için
kullanılan spiritüel çareler sistemidir.

TEMEL ÇARE TÜRLERİ:
1. Mantra Japa - Mantra tekrarı
2. Ratna (Gemstone) - Taş terapisi
3. Yantra - Geometrik enerjiler
4. Dana (Charity) - Bağış ve hayırseverlik
5. Vrata (Fasting) - Oruç tutma
6. Puja & Homa - Ritüel ve ateş törenleri
7. Seva (Service) - Hizmet

ÖNEMLİ İLKELER:
• Çareler, gezegen enerjisini güçlendirir veya dengeler
• Zayıf gezegen için güçlendirme, zorlu aspekt için yatıştırma
• Niyetle yapılan çareler daha etkilidir
• Düzenlilik ve tutarlılık önemlidir
• Guru rehberliği tavsiye edilir
''';

  static const List<Upaya> allUpayas = [
    // SURYA UPAYAS
    Upaya(
      type: 'Mantra Japa',
      targetPlanet: 'Surya (Güneş)',
      method: '''
SURYA MANTRASI:
• "Om Suryaya Namaha" - 108 veya 1008 kez
• "Om Hraam Hreem Hraum Sah Suryaya Namaha" - Beej mantra
• Aditya Hridayam - Güçlü Surya stotrası
• Gayatri Mantra - Evrensel güneş mantrası
''',
      frequency: 'Günlük, özellikle Pazar günleri',
      bestTime: 'Gün doğumu, Surya hora',
      materials: 'Mala (tespih), bakır kap, su',
      mantra: 'Om Suryaya Namaha',
      benefits: '''
• Öz-güven ve liderlik artışı
• Sağlık ve canlılık
• Kariyer başarısı
• Baba ilişkisinde iyileşme
• Göz ve kalp sağlığı
''',
    ),

    Upaya(
      type: 'Gemstone',
      targetPlanet: 'Surya (Güneş)',
      method: '''
YAKUT (MANIKYA):
• Minimum 3 karat, net ve temiz
• Altın yüzük içinde
• Yüzük parmağında (sağ el)
• Pazar günü, Surya hora'da takın
• "Om Suryaya Namaha" 108 kez okuyarak aktive edin

ALTERNATİF TAŞLAR:
• Kırmızı Granat
• Kırmızı Spinel
• Rubellit
''',
      frequency: 'Sürekli (aktive edildikten sonra)',
      bestTime: 'Pazar, gün doğumu',
      materials: 'Yakut (min. 3 karat), altın yüzük',
      mantra: 'Om Suryaya Namaha (aktive ederken)',
      benefits: '''
• Surya enerjisinin güçlenmesi
• Liderlik ve otorite
• Kalp sağlığı
• Kariyer yükselişi
''',
    ),

    // CHANDRA UPAYAS
    Upaya(
      type: 'Mantra Japa',
      targetPlanet: 'Chandra (Ay)',
      method: '''
CHANDRA MANTRASI:
• "Om Chandraya Namaha" - 108 veya 1008 kez
• "Om Shraam Shreem Shraum Sah Chandraya Namaha" - Beej mantra
• Chandra Kavacham - Ay koruma stotrası
• Shiva Panchakshari - "Om Namah Shivaya" (Shiva Ay'ı taşır)
''',
      frequency: 'Günlük, özellikle Pazartesi günleri',
      bestTime: 'Akşam, Ay doğunca, Chandra hora',
      materials: 'Gümüş kap, süt, beyaz çiçekler',
      mantra: 'Om Chandraya Namaha',
      benefits: '''
• Duygusal denge
• Zihin huzuru
• Anne ilişkisinde iyileşme
• Uyku kalitesi
• Sezgisel yetenekler
''',
    ),

    Upaya(
      type: 'Gemstone',
      targetPlanet: 'Chandra (Ay)',
      method: '''
İNCİ (MOTI):
• Minimum 4 karat, yuvarlak, parlak
• Gümüş yüzük içinde
• Küçük parmak (sağ el)
• Pazartesi günü, Chandra hora'da takın
• "Om Chandraya Namaha" 108 kez okuyarak aktive edin

ALTERNATİF TAŞLAR:
• Ay Taşı (Moonstone)
• Beyaz Mercan
• Beyaz Safir
''',
      frequency: 'Sürekli',
      bestTime: 'Pazartesi, akşam',
      materials: 'İnci (min. 4 karat), gümüş yüzük',
      mantra: 'Om Chandraya Namaha',
      benefits: '''
• Duygusal istikrar
• Zihin berraklığı
• Annelik/babalık
• Sezgi güçlenmesi
''',
    ),

    // SHANI UPAYAS (ÖNEMLİ - SADE SATI İÇİN)
    Upaya(
      type: 'Comprehensive',
      targetPlanet: 'Shani (Satürn)',
      method: '''
SHANI ÇARE PAKETİ:

1. MANTRA:
• "Om Shanaye Namaha" - 108 kez, Cumartesi
• "Om Praam Preem Praum Sah Shanaye Namaha" - Beej mantra
• Shani Chalisa - Her Cumartesi
• Hanuman Chalisa - Shani'nin korktuğu Hanuman

2. ORUÇ:
• Cumartesi orucu (sadece akşam yemeği)
• 19 veya 23 hafta kesintisiz

3. DANA (BAĞIŞ):
• Siyah urad dal (mercimek)
• Demir eşyalar
• Siyah giysiler
• Susam yağı
• Fakirlere yiyecek

4. SEVA (HİZMET):
• Yaşlılara hizmet
• Engellilere yardım
• Temizlik işleri
''',
      frequency: 'Haftalık (Cumartesi), Sade Sati boyunca yoğun',
      bestTime: 'Cumartesi, gün doğumundan önce',
      materials: 'Siyah urad dal, demir, susam yağı, siyah kumaş',
      mantra: 'Om Shanaye Namaha, Hanuman Chalisa',
      benefits: '''
• Sade Sati etkilerinin azalması
• Karmaik temizlik
• Sabır ve disiplin
• Kronik sağlık sorunlarında iyileşme
• Kariyer engellerinin kalkması
''',
    ),

    // RAHU UPAYAS
    Upaya(
      type: 'Comprehensive',
      targetPlanet: 'Rahu',
      method: '''
RAHU ÇARE PAKETİ:

1. MANTRA:
• "Om Rahave Namaha" - 108 kez
• "Om Bhraam Bhreem Bhraum Sah Rahave Namaha" - Beej
• Durga Saptashati - 700 ayet, güçlü koruma

2. PUJA:
• Rahu Kalam'da Durga puja
• Naga (yılan) puja

3. DANA:
• Siyah örtü, şemsiye
• Hindistan cevizi
• Sarı hardal tohumu
• Mavi çiçekler

4. ÖZEL ÇARELER:
• Sarı hardal taşıma
• Gümüş yüzük (Rahu metal karşıtı)
''',
      frequency: 'Cumartesi veya Rahu Kalam',
      bestTime: 'Rahu Kalam (her gün değişir)',
      materials: 'Hindistan cevizi, mavi çiçekler, sarı hardal',
      mantra: 'Om Bhraam Bhreem Bhraum Sah Rahave Namaha',
      benefits: '''
• Obsesyonların azalması
• Mental netlik
• Kafa karışıklığının giderilmesi
• Korku ve fobilerin azalması
• Bağımlılıktan kurtulma
''',
    ),

    // KETU UPAYAS
    Upaya(
      type: 'Comprehensive',
      targetPlanet: 'Ketu',
      method: '''
KETU ÇARE PAKETİ:

1. MANTRA:
• "Om Ketave Namaha" - 108 kez
• "Om Sraam Sreem Sraum Sah Ketave Namaha" - Beej
• Ganesha Atharvashirsha

2. PUJA:
• Ganesha puja (engel kaldırıcı)
• Ketu özellikle Ganesha ile yatıştırılır

3. DANA:
• Battaniye, örtü
• Çok renkli kumaşlar
• Köpeklere yemek

4. MEDİTASYON:
• Sessizlik pratiği
• Geçmiş yaşam meditasyonu
• Bırakma çalışması
''',
      frequency: 'Salı veya Perşembe',
      bestTime: 'Gün doğumu',
      materials: 'Battaniye, çok renkli kumaş, köpek maması',
      mantra: 'Om Ketave Namaha, Om Gam Ganapataye Namaha',
      benefits: '''
• Spiritüel ilerleme
• Geçmiş yaşam karmalarının çözülmesi
• Sezgisel yetenekler
• İç huzur
• Bırakma kapasitesi
''',
    ),

    // MANGAL UPAYAS
    Upaya(
      type: 'Manglik Dosha',
      targetPlanet: 'Mangal (Mars)',
      method: '''
MANGLİK DOSHA ÇARE PAKETİ:

1. MANTRA:
• "Om Mangalaya Namaha" - 108 kez
• Hanuman Chalisa - Çok güçlü
• Kartikeya stotrası

2. PUJA:
• Mangal Shanti Puja - Evlilik öncesi şart
• Kumbh Vivah - Sembolik evlilik (zorlu durumlarda)

3. ÖZEL ÇARELER:
• Kırmızı mercan taşı
• Salı orucu
• Hanuman tapınağı ziyareti

4. DANA:
• Kırmızı masoor dal
• Kırmızı kumaş
• Buğday ve jaggery
''',
      frequency: 'Salı günleri',
      bestTime: 'Gün doğumu, Mangal hora',
      materials: 'Kırmızı masoor dal, kırmızı kumaş, mercan',
      mantra: 'Om Kraam Kreem Kraum Sah Bhaumaya Namaha',
      benefits: '''
• Manglik dosha etkilerinin azalması
• Evlilikte uyum
• Öfke kontrolü
• Enerji dengesi
• Kardeş ilişkilerinde iyileşme
''',
    ),
  ];

  /// Gezegene göre upaya'ları filtrele
  static List<Upaya> getUpayasByPlanet(String planet) {
    return allUpayas
        .where(
          (u) => u.targetPlanet.toLowerCase().contains(planet.toLowerCase()),
        )
        .toList();
  }

  /// Tipe göre upaya'ları filtrele
  static List<Upaya> getUpayasByType(String type) {
    return allUpayas
        .where((u) => u.type.toLowerCase().contains(type.toLowerCase()))
        .toList();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TANTRİK JYOTİSH - KUNDALINI VE SPİRİTÜEL EVRİM
// ════════════════════════════════════════════════════════════════════════════

class TantrikJyotishContent {
  static const String introduction = '''
TANTRİK JYOTİSH - DOĞUM HARİTASINDA KUNDALİNİ VE SPİRİTÜEL YOLCULUK

Tantrik Jyotish, geleneksel Vedik astrolojiyi Tantra bilgeliği ile
birleştirir. Doğum haritası, ruhun spiritüel potansiyelini ve
Kundalini uyanışının yolunu gösterir.

TEMEL KAVRAMLAR:
• Kundalini - Muladhara'da uyuyan yılan enerji
• Chakralar - Enerji merkezleri (7 ana chakra)
• Nadiler - Enerji kanalları (Ida, Pingala, Sushumna)
• Moksha - Nihai kurtuluş
• Shakti - İlahi feminin enerji
• Shiva - Saf bilinç

DOĞUM HARİTASI VE KUNDALİNİ:
Harita, ruhun bu yaşamda hangi çakraları çalışacağını,
hangi nadilerin aktif olduğunu ve Kundalini uyanışının
potansiyelini gösterir.
''';

  static const String kundaliniIndicators = '''
KUNDALİNİ GÖSTERGELERİ

GÜÇLÜ KUNDALİNİ POTANSİYELİ:
1. Ketu 1. veya 8. evde
2. Rahu-Ketu ekseni 1-7 veya 4-10 evlerinde
3. Mars veya Ketu ile aspektli 8. ev
4. Akrep veya Balık lagna'da güçlü gezegenler
5. 12. ev güçlü - moksha potansiyeli
6. Jüpiter ve Ketu birlikte - spiritüel bırakma

ÇAKRA AKTASYONLARI:
• Muladhara (Kök): Mars, Satürn konumları
• Svadhisthana (Sakral): Venüs, Ay konumları
• Manipura (Güneş Pleksusu): Güneş, Mars konumları
• Anahata (Kalp): Venüs, Ay, Jüpiter konumları
• Vishuddhi (Boğaz): Merkür, Jüpiter konumları
• Ajna (Üçüncü Göz): Güneş, Ay, Jüpiter konumları
• Sahasrara (Taç): Ketu, Jüpiter konumları

NADİ AKTASYONLARI:
• Ida (sol, lunar): Güçlü Ay, feminin gezegenler
• Pingala (sağ, solar): Güçlü Güneş, maskülen gezegenler
• Sushumna (merkez): Rahu-Ketu dengesi, 8. ve 12. ev
''';

  static const String sexualEnergyIndicators = '''
CİNSEL ENERJİ VE DOĞUM HARİTASI

YÜKSEK CİNSEL ENERJİ GÖSTERGELERİ:
1. Venüs-Mars aspekti veya birleşimi
2. 5. veya 7. evde Mars
3. Akrep burcunda güçlü gezegenler
4. 8. ev aktif (dönüşüm evi)
5. Bharani, Ashlesha nakshatra'larında gezegenler

CİNSEL ENERJİNİN SPİRİTÜEL DÖNÜŞÜMÜ:
• Brahmacharya potansiyeli: Satürn 5. veya 7. evde
• Tantrik dönüşüm: 8. ev lordu 12. evde
• Ojas (yaşamsal öz) korunması: Güçlü Jüpiter
• Virya (cinsel güç) sublimasyonu: Mars-Ketu aspekti

TANTRİK BİRLİKTELİK UYUMU:
İki harita arasındaki uyum:
• Venüs-Mars sinastri aspektleri
• 5-5, 7-7 ev uyumu
• Nakshatra uyumu (Yoni Kuta)
• Rahu-Ketu eksen uyumu
''';

  static const String spiritualEvolutionPath = '''
SPİRİTÜEL EVRİM YOLU

MOKSHA KARAKA (KURTULUŞ GÖSTERGELERİ):
Ketu, moksha'nın ana göstergesidir.
Ketu'nun konumu, kurtuluş yolunu işaret eder.

1. Ketu 1. evde: Bu yaşamda aydınlanma potansiyeli
2. Ketu 4. evde: İç huzur yoluyla kurtuluş
3. Ketu 8. evde: Dönüşüm yoluyla kurtuluş
4. Ketu 12. evde: Meditasyon yoluyla kurtuluş

12. EV - MOKSHA EVİ:
12. ev, varoluş döngüsünden çıkış kapısıdır.
Bu evdeki gezegenler, kurtuluş yöntemini gösterir.

• Güneş 12. evde: Ego'nun teslimiyeti
• Ay 12. evde: Duygusal arınma
• Mars 12. evde: Eylem yoluyla kurtuluş
• Merkür 12. evde: Bilgi yoluyla kurtuluş
• Jüpiter 12. evde: Bilgelik yoluyla kurtuluş
• Venüs 12. evde: Aşk yoluyla kurtuluş
• Satürn 12. evde: Disiplin yoluyla kurtuluş
• Rahu 12. evde: İllüzyonu aşma
• Ketu 12. evde: Doğal moksha eğilimi

SPİRİTÜEL YOLCULUK AŞAMALARI:
1. ARZU (Kama): 5. ev, Venüs - Deneyim toplama
2. GÜVENLİK (Artha): 2., 11. evler - Maddi zemin
3. GÖREV (Dharma): 1., 5., 9. evler - Yaşam amacı
4. KURTULUŞ (Moksha): 4., 8., 12. evler - Spiritüel hedef
''';

  static const String tantraYogasCombinations = '''
TANTRİK YOGA KOMBİNASYONLARI

1. KUNDALİNİ YOGA:
Oluşum: Ketu 1. evde, Mars veya Rahu aspekti
Etki: Güçlü Kundalini aktivasyon potansiyeli
Dikkat: Guru rehberliği kritik

2. SHAKTİ YOGA:
Oluşum: Venüs-Mars birleşimi veya aspekti
Etki: Feminin ve maskülen enerjilerin dengesi
Tantrik: İçsel evlilik potansiyeli

3. SİDDHİ YOGA:
Oluşum: 8. ev lordu 9. evde, Jüpiter aspekti
Etki: Spiritüel güçler ve yetenekler
Dikkat: Güç ego'yu şişirebilir

4. MOKSHA YOGA:
Oluşum: Ketu 12. evde, Jüpiter aspekti
Etki: Bu yaşamda aydınlanma potansiyeli
Dikkat: Dünyevi sorumluluklar ihmal edilebilir

5. NAGA YOGA:
Oluşum: Rahu veya Ketu Ashlesha nakshatra'sında
Etki: Yılan bilgeliği, Kundalini farkındalığı
Tantrik: Naga tanrıları ile çalışma

6. BRAHMA YOGA:
Oluşum: Jüpiter 1. veya 9. evde, güçlü
Etki: Brahman bilincine açıklık
Spiritüel: Vedantik aydınlanma yolu

7. TANTRİK TRİANGLE:
Oluşum: 1., 5., 9. evler arasında güçlü bağlantılar
Etki: Dharma trilojisi aktif
Spiritüel: Tantrik öğretileri anlama ve uygulama
''';

  static const String practicalGuidelines = '''
PRATİK KILAVUZ - TANTRİK JYOTİSH UYGULAMASI

DOĞUM HARİTASI ANALİZİ:
1. Lagna (Yükselen Burç): Ruhun bu yaşamdaki "giriş noktası"
2. Ay Burcu: Duygusal ve psişik doğa
3. 8. Ev: Dönüşüm ve okült potansiyel
4. 12. Ev: Moksha ve spiritüel kurtuluş
5. Ketu Konumu: Geçmiş yaşam bilgeliği ve bırakma
6. Nakshatra: Ay nakshatra'sı temel karakter

DASHA ANALİZİ:
• Ketu Dasha: Spiritüel uyanış dönemi
• Rahu Dasha: Maya ile yüzleşme
• Jüpiter Dasha: Bilgelik ve genişleme
• Satürn Dasha: Karmaik temizlik

TANTRİK PRATİK ÖNERİLERİ:
Harita analizine göre uygun pratikler:

1. Güçlü Ketu: Meditasyon, geçmiş yaşam çalışması
2. Güçlü Rahu: Gölge entegrasyonu, maya farkındalığı
3. Güçlü Mars: Kundalini yoga, enerji çalışması
4. Güçlü Venüs: Tantrik ilişki, güzellik yoluyla aydınlanma
5. Güçlü Jüpiter: Guru bağlantısı, mantra siddhi
6. Güçlü Satürn: Tapas, disiplinli pratik
7. Güçlü Ay: Shakti tapınması, lunar ritüeller
8. Güçlü Güneş: Atman farkındalığı, solar pranayama

UYARILAR:
• Kundalini uyanışı tehlikeli olabilir - guru rehberliği şart
• Tantrik pratikler ego'yu şişirebilir - tevazu önemli
• Siddhiler (güçler) hedef değil, yan üründür
• Spiritüel gurur en tehlikeli tuzaktır
''';

  /// Tüm tantrik jyotish içeriğini al
  static Map<String, String> getAllContent() {
    return {
      'introduction': introduction,
      'kundaliniIndicators': kundaliniIndicators,
      'sexualEnergyIndicators': sexualEnergyIndicators,
      'spiritualEvolutionPath': spiritualEvolutionPath,
      'tantraYogasCombinations': tantraYogasCombinations,
      'practicalGuidelines': practicalGuidelines,
    };
  }
}

// ════════════════════════════════════════════════════════════════════════════
// ANA SERVİS SINIFI - TÜM İÇERİĞE ERİŞİM
// ════════════════════════════════════════════════════════════════════════════

class VedicJyotishService {
  /// Tüm Graha'ları al
  static List<Graha> getAllGrahas() => NavagrahaContent.allGrahas;

  /// Günün Graha'sını al
  static Graha getDailyGraha() => NavagrahaContent.getDailyGraha();

  /// Tüm Nakshatra'ları al
  static List<Nakshatra> getAllNakshatras() => NakshatraContent.allNakshatras;

  /// Tüm Dasha dönemlerini al
  static List<DashaPeriod> getAllDashas() => DashaContent.allDashas;

  /// Tüm Yoga'ları al
  static List<JyotishYoga> getAllYogas() => YogaContent.allYogas;

  /// Tüm Muhurta'ları al
  static List<Muhurta> getAllMuhurtas() => MuhurtaContent.allMuhurtas;

  /// Tüm Upaya'ları al
  static List<Upaya> getAllUpayas() => UpayaContent.allUpayas;

  /// Tantrik Jyotish içeriğini al
  static Map<String, String> getTantrikJyotishContent() =>
      TantrikJyotishContent.getAllContent();

  /// Gezegen için kapsamlı bilgi al
  static Map<String, dynamic> getComprehensivePlanetInfo(String planetName) {
    final graha = NavagrahaContent.getGrahaByName(planetName);
    final dashaInfo = DashaContent.getDashaByPlanet(planetName);
    final upayas = UpayaContent.getUpayasByPlanet(planetName);
    final nakshatras = NakshatraContent.getNakshatrasByPlanet(planetName);

    return {
      'graha': graha,
      'dasha': dashaInfo,
      'upayas': upayas,
      'nakshatras': nakshatras,
    };
  }

  /// Nakshatra için kapsamlı bilgi al
  static Map<String, dynamic> getComprehensiveNakshatraInfo(
    int nakshatraNumber,
  ) {
    final nakshatra = NakshatraContent.getNakshatraByNumber(nakshatraNumber);
    if (nakshatra == null) return {};

    final rulingPlanet = NavagrahaContent.getGrahaByName(
      nakshatra.rulingPlanet.split(' ').first,
    );

    return {
      'nakshatra': nakshatra,
      'rulingPlanet': rulingPlanet,
      'compatibleNakshatras': nakshatra.compatibleNakshatras
          .map((name) => NakshatraContent.getNakshatraByName(name))
          .where((n) => n != null)
          .toList(),
    };
  }

  /// Günlük astrolojik özet
  static Map<String, dynamic> getDailySummary() {
    final now = DateTime.now();
    final dailyGraha = getDailyGraha();
    final dayOfWeek = now.weekday;

    return {
      'date': now,
      'graha': dailyGraha,
      'dayName': _getDayNameTurkish(dayOfWeek),
      'recommendation':
          'Bugün ${dailyGraha.turkishName} enerjisi aktif. '
          '${dailyGraha.mantra} mantrasını okuyabilirsiniz.',
      'color': dailyGraha.color,
      'gemstone': dailyGraha.gemstone,
    };
  }

  static String _getDayNameTurkish(int weekday) {
    switch (weekday) {
      case 1:
        return 'Pazartesi';
      case 2:
        return 'Salı';
      case 3:
        return 'Çarşamba';
      case 4:
        return 'Perşembe';
      case 5:
        return 'Cuma';
      case 6:
        return 'Cumartesi';
      case 7:
        return 'Pazar';
      default:
        return '';
    }
  }
}
