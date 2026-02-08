import '../providers/app_providers.dart';
import 'l10n_service.dart';

/// Kabala numeroloji ve Hayat Ağacı servisi
class KabbalahService {
  /// Kabala sayısını hesapla (isimden)
  static int calculateKabbalahNumber(String name) {
    final cleanName = name.toUpperCase().replaceAll(RegExp(r'[^A-ZÇĞİÖŞÜ]'), '');
    var sum = 0;

    for (final char in cleanName.split('')) {
      sum += _hebrewLetterValue(char);
    }

    return _reduceToSingleDigit(sum);
  }

  /// Ruh Sayısını hesapla (sadece sesli harfler)
  static int calculateSoulNumber(String name) {
    final cleanName = name.toUpperCase().replaceAll(RegExp(r'[^A-ZÇĞİÖŞÜ]'), '');
    const vowels = 'AEIİOÖUÜ';
    var sum = 0;

    for (final char in cleanName.split('')) {
      if (vowels.contains(char)) {
        sum += _hebrewLetterValue(char);
      }
    }

    return _reduceToSingleDigit(sum);
  }

  /// Persona Sayısını hesapla (sadece sessiz harfler)
  static int calculatePersonaNumber(String name) {
    final cleanName = name.toUpperCase().replaceAll(RegExp(r'[^A-ZÇĞİÖŞÜ]'), '');
    const vowels = 'AEIİOÖUÜ';
    var sum = 0;

    for (final char in cleanName.split('')) {
      if (!vowels.contains(char)) {
        sum += _hebrewLetterValue(char);
      }
    }

    return _reduceToSingleDigit(sum);
  }

  /// Doğum tarihinden Yaşam Yolu Sefirası hesapla
  static Sefirah calculateLifePathSefirah(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;
    final year = birthDate.year;

    final sum = _digitSum(day) + _digitSum(month) + _digitSum(year);
    final reduced = _reduceToSingleDigit(sum);

    return _sefirahFromNumber(reduced);
  }

  /// İsimden Kişilik Sefirası hesapla
  static Sefirah calculateNameSefirah(String name) {
    final kabbalahNumber = calculateKabbalahNumber(name);
    return _sefirahFromNumber(kabbalahNumber);
  }

  /// Gematria değerini hesapla
  static int calculateGematria(String text) {
    final cleanText = text.toUpperCase().replaceAll(RegExp(r'[^A-ZÇĞİÖŞÜ]'), '');
    var sum = 0;

    for (final char in cleanText.split('')) {
      sum += _hebrewLetterValue(char);
    }

    return sum;
  }

  /// İki isim arasındaki Kabalistik uyumu hesapla
  static KabbalahCompatibility calculateCompatibility(String name1, String name2) {
    final kab1 = calculateKabbalahNumber(name1);
    final kab2 = calculateKabbalahNumber(name2);
    final soul1 = calculateSoulNumber(name1);
    final soul2 = calculateSoulNumber(name2);

    final sefirah1 = _sefirahFromNumber(kab1);
    final sefirah2 = _sefirahFromNumber(kab2);

    // Aynı Sefirah veya tamamlayıcı Sefirahlar
    final sefirahCompatibility = _getSefirahCompatibility(sefirah1, sefirah2);

    // Ruh sayıları uyumu
    final soulCompatibility = _getNumberCompatibility(soul1, soul2);

    // Genel skor
    final overallScore = ((sefirahCompatibility + soulCompatibility) / 2).round();

    return KabbalahCompatibility(
      person1Number: kab1,
      person2Number: kab2,
      person1Sefirah: sefirah1,
      person2Sefirah: sefirah2,
      sefirahCompatibility: sefirahCompatibility,
      soulCompatibility: soulCompatibility,
      overallScore: overallScore,
      interpretation: _getCompatibilityInterpretation(sefirah1, sefirah2, overallScore, language: AppLanguage.tr),
    );
  }

  /// Günlük Kabala enerjisi
  static DailyKabbalahEnergy getDailyEnergy(DateTime date) {
    final daySum = _digitSum(date.day) + _digitSum(date.month) + _digitSum(date.year);
    final reduced = _reduceToSingleDigit(daySum);
    final sefirah = _sefirahFromNumber(reduced);

    return DailyKabbalahEnergy(
      date: date,
      sefirah: sefirah,
      number: reduced,
      guidance: _getDailyGuidance(sefirah, language: AppLanguage.tr),
      meditation: _getDailyMeditation(sefirah, language: AppLanguage.tr),
    );
  }

  static Sefirah _sefirahFromNumber(int number) {
    switch (number) {
      case 1: return Sefirah.keter;
      case 2: return Sefirah.chokhmah;
      case 3: return Sefirah.binah;
      case 4: return Sefirah.chesed;
      case 5: return Sefirah.gevurah;
      case 6: return Sefirah.tiferet;
      case 7: return Sefirah.netzach;
      case 8: return Sefirah.hod;
      case 9: return Sefirah.yesod;
      case 10: return Sefirah.malkut;
      default: return Sefirah.malkut;
    }
  }

  static int _hebrewLetterValue(String letter) {
    // Latin harflerini İbranice sayısal değerlere eşle
    const values = {
      'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8, 'I': 9, 'İ': 9,
      'J': 10, 'K': 20, 'L': 30, 'M': 40, 'N': 50, 'O': 60, 'Ö': 60, 'P': 70, 'Q': 80,
      'R': 90, 'S': 100, 'Ş': 100, 'T': 200, 'U': 300, 'Ü': 300, 'V': 400, 'W': 500,
      'X': 600, 'Y': 700, 'Z': 800, 'Ç': 3, 'Ğ': 7,
    };
    return values[letter] ?? 0;
  }

  static int _reduceToSingleDigit(int number) {
    while (number > 10) {
      number = _digitSum(number);
    }
    // Kabala'da 10 özel bir sayıdır (Malkut)
    if (number == 10) return 10;
    return number;
  }

  static int _digitSum(int number) {
    var sum = 0;
    while (number > 0) {
      sum += number % 10;
      number ~/= 10;
    }
    return sum;
  }

  static int _getSefirahCompatibility(Sefirah s1, Sefirah s2) {
    if (s1 == s2) return 95;

    // Tamamlayıcı sefirahlar
    final complementary = {
      Sefirah.keter: [Sefirah.malkut],
      Sefirah.chokhmah: [Sefirah.binah],
      Sefirah.chesed: [Sefirah.gevurah],
      Sefirah.tiferet: [Sefirah.yesod],
      Sefirah.netzach: [Sefirah.hod],
    };

    if (complementary[s1]?.contains(s2) ?? false) return 90;
    if (complementary[s2]?.contains(s1) ?? false) return 90;

    // Aynı sütundaki sefirahlar
    final rightPillar = [Sefirah.chokhmah, Sefirah.chesed, Sefirah.netzach];
    final leftPillar = [Sefirah.binah, Sefirah.gevurah, Sefirah.hod];
    final middlePillar = [Sefirah.keter, Sefirah.tiferet, Sefirah.yesod, Sefirah.malkut];

    if ((rightPillar.contains(s1) && rightPillar.contains(s2)) ||
        (leftPillar.contains(s1) && leftPillar.contains(s2)) ||
        (middlePillar.contains(s1) && middlePillar.contains(s2))) {
      return 80;
    }

    return 65;
  }

  static int _getNumberCompatibility(int n1, int n2) {
    if (n1 == n2) return 95;
    final diff = (n1 - n2).abs();
    if (diff <= 2) return 85;
    if (diff <= 4) return 70;
    return 55;
  }

  static String _getCompatibilityInterpretation(Sefirah s1, Sefirah s2, int score, {AppLanguage language = AppLanguage.tr}) {
    final s1Name = s1.localizedName(language);
    final s2Name = s2.localizedName(language);
    String key;
    if (score >= 90) {
      key = 'kabbalah.compatibility.very_high';
    } else if (score >= 80) {
      key = 'kabbalah.compatibility.high';
    } else if (score >= 70) {
      key = 'kabbalah.compatibility.medium';
    } else {
      key = 'kabbalah.compatibility.low';
    }
    final localized = L10nService.get(key, language);
    if (localized != key) {
      return localized.replaceAll('{s1}', s1Name).replaceAll('{s2}', s2Name);
    }
    // Fallback
    if (score >= 90) {
      return 'There is a deep bond between your souls. $s1Name and $s2Name energies complement each other, together forming high spiritual harmony.';
    } else if (score >= 80) {
      return 'You have a strong energy connection. $s1Name and $s2Name carry supportive energies.';
    } else if (score >= 70) {
      return 'Although $s1Name and $s2Name carry different energies, these differences offer growth opportunities.';
    } else {
      return '$s1Name and $s2Name energies are different. This relationship contains lessons for both sides to learn.';
    }
  }

  static String _getDailyGuidance(Sefirah sefirah, {AppLanguage language = AppLanguage.tr}) {
    final key = 'kabbalah.daily_guidance.${sefirah.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback English
    switch (sefirah) {
      case Sefirah.keter:
        return 'Today is a day to connect with infinite potential. Make time for meditation and inner silence. Let divine will guide you.';
      case Sefirah.chokhmah:
        return 'Today is a day of wisdom and insight. Sudden inspirations may come. Be open to new ideas and visions.';
      case Sefirah.binah:
        return 'Today is a day of understanding and comprehension. Focus on details, analyze. Trust your emotional depth.';
      case Sefirah.chesed:
        return 'Today is a day of love and compassion. Help others, be generous. Keep your heart chakra open.';
      case Sefirah.gevurah:
        return 'Today is a day of strength and discipline. Protect your boundaries, make necessary decisions. Trust your inner power.';
      case Sefirah.tiferet:
        return 'Today is a day of balance and beauty. Try to balance opposites. Appreciate inner and outer beauty.';
      case Sefirah.netzach:
        return 'Today is a day of determination and victory. Focus on your goals, don\'t give up. Use your creative energy.';
      case Sefirah.hod:
        return 'Today is a day of communication and analysis. Clarify your thoughts, share knowledge. Seek mental clarity.';
      case Sefirah.yesod:
        return 'Today is a day of foundation and connection. Pay attention to your dreams, trust your intuitions. Astral connections are strong.';
      case Sefirah.malkut:
        return 'Today is a day of material world and manifestation. Focus on practical matters, take concrete steps. Connect with nature.';
    }
  }

  static String _getDailyMeditation(Sefirah sefirah, {AppLanguage language = AppLanguage.tr}) {
    final key = 'kabbalah.daily_meditation.${sefirah.name}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback English
    switch (sefirah) {
      case Sefirah.keter:
        return 'Close your eyelids and imagine a bright white light above your head. Feel this light uniting you with infinity.';
      case Sefirah.chokhmah:
        return 'Imagine a gray space - neither completely light nor completely dark. Feel new ideas being born in this uncertainty.';
      case Sefirah.binah:
        return 'Imagine you are in a deep blue ocean. Feel the infinite depth bringing you understanding.';
      case Sefirah.chesed:
        return 'Imagine golden light radiating from your heart. Feel this light carrying love and compassion to all beings.';
      case Sefirah.gevurah:
        return 'Imagine a red flame - burning but purifying. Feel this fire cleansing everything unnecessary.';
      case Sefirah.tiferet:
        return 'Imagine being bathed in golden sunlight. Feel this light keeping all opposites in balance.';
      case Sefirah.netzach:
        return 'Imagine you are in the middle of a lush green forest. Feel nature\'s resilience and victory.';
      case Sefirah.hod:
        return 'Imagine an orange sphere of light illuminating your mind. Feel your thoughts becoming clearer.';
      case Sefirah.yesod:
        return 'Imagine a purple light surrounding your navel area. Feel the door to the dream realm and subconscious opening.';
      case Sefirah.malkut:
        return 'Imagine your feet rooting into the earth. Feel the earth\'s energy giving you strength.';
    }
  }
}

/// Sefirah (Hayat Ağacındaki emanasyonlar)
enum Sefirah {
  keter,    // 1 - Taç
  chokhmah, // 2 - Bilgelik
  binah,    // 3 - Anlayış
  chesed,   // 4 - Merhamet
  gevurah,  // 5 - Güç
  tiferet,  // 6 - Güzellik
  netzach,  // 7 - Zafer
  hod,      // 8 - Görkem
  yesod,    // 9 - Temel
  malkut,   // 10 - Krallık
}

extension SefirahExtension on Sefirah {
  String get name {
    switch (this) {
      case Sefirah.keter: return 'Keter';
      case Sefirah.chokhmah: return 'Chokhmah';
      case Sefirah.binah: return 'Binah';
      case Sefirah.chesed: return 'Chesed';
      case Sefirah.gevurah: return 'Gevurah';
      case Sefirah.tiferet: return 'Tiferet';
      case Sefirah.netzach: return 'Netzach';
      case Sefirah.hod: return 'Hod';
      case Sefirah.yesod: return 'Yesod';
      case Sefirah.malkut: return 'Malkut';
    }
  }

  String get nameTr {
    switch (this) {
      case Sefirah.keter: return 'Taç (Keter)';
      case Sefirah.chokhmah: return 'Bilgelik (Hokmah)';
      case Sefirah.binah: return 'Anlayış (Binah)';
      case Sefirah.chesed: return 'Merhamet (Hesed)';
      case Sefirah.gevurah: return 'Güç (Gevurah)';
      case Sefirah.tiferet: return 'Güzellik (Tiferet)';
      case Sefirah.netzach: return 'Zafer (Netsah)';
      case Sefirah.hod: return 'Görkem (Hod)';
      case Sefirah.yesod: return 'Temel (Yesod)';
      case Sefirah.malkut: return 'Krallık (Malkut)';
    }
  }

  String localizedName(AppLanguage language) {
    final key = 'kabbalah.sefirah_names.${name.toLowerCase()}';
    return L10nService.get(key, language);
  }

  String get meaning => localizedMeaning(AppLanguage.tr);

  String localizedMeaning(AppLanguage language) {
    final key = 'kabbalah.sefirah_meanings.${name.toLowerCase()}';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;
    // Fallback English
    switch (this) {
      case Sefirah.keter:
        return 'Point of union with infinity. Source of divine will. Beginning of all potentials.';
      case Sefirah.chokhmah:
        return 'Pure wisdom and inspiration. Creative spark. Source of masculine energy and vision.';
      case Sefirah.binah:
        return 'Deep understanding and comprehension. Form-giving energy. Feminine wisdom and intuition.';
      case Sefirah.chesed:
        return 'Unconditional love and compassion. Expansion and abundance. Generosity and healing.';
      case Sefirah.gevurah:
        return 'Inner strength and discipline. Boundaries and justice. Purification and focus.';
      case Sefirah.tiferet:
        return 'Center of balance and harmony. Beauty and truth. Union of heart and soul.';
      case Sefirah.netzach:
        return 'Determination and resilience. Emotional strength and passion. Creative expression.';
      case Sefirah.hod:
        return 'Mental clarity and communication. Analytical thinking. Spiritual understanding.';
      case Sefirah.yesod:
        return 'Astral connection and dreams. Subconscious and intuition. Foundation of manifestation.';
      case Sefirah.malkut:
        return 'Physical world and matter. Grounding and realization. Daily life.';
    }
  }

  /// Derin ezoterik açıklama - Kabalistik gelenekten
  String get esotericMeaning {
    switch (this) {
      case Sefirah.keter:
        return '''Keter, İbranice'de "Taç" anlamına gelir ve Hayat Ağacı'nın en yüksek noktasıdır. Ein Sof'un (Sınırsız Işık) ilk tezahürü olan Keter, insan aklının kavrayamayacağı mutlak birliği temsil eder. Zohar'da "Kadim Günlerin Kadimi" (Atik Yomin) olarak anılır - zamandan ve mekândan önceki ilk nokta.

Keter'in deneyimi, mistiklerin "devekut" (Tanrı'ya yapışma) dedikleri, benliğin tamamen erimesi halidir. Bu Sefirah, ruhun en yüksek kısmı olan "yechida" ile ilişkilidir - bireysel benliğin ötesindeki ilahi kıvılcım. Simyada Philosopher's Stone'un (Felsefe Taşı) nihai hedefi olan "rubedo" aşamasına tekabül eder.

Keter enerjisi taşıyan ruhlar genellikle derin bir "eve dönüş" özlemi hisseder - bu dünyada tam olarak ait olamama duygusu. Onların görevi, yüksek vizyonu yeryüzüne indirmek, köprü olmaktır.''';

      case Sefirah.chokhmah:
        return '''Chokhmah, "Bilgelik" demektir ve Hayat Ağacı'nın sağ sütununda (Rahmet Sütunu) yer alır. Keter'den akan ilk aktif enerjidir - yaratılışın "Baba" prensibi. Zohar'da "Reshit" (Başlangıç) olarak adlandırılır: "Bilgelik ile başlangıç" (Be-reishit).

Bu Sefirah, saf potansiyelin ilk kıpırdanışıdır - henüz form almamış, tanımsız ama sonsuz imkân. Yunan felsefesindeki "Nous" (İlahi Akıl) kavramına denktir. Jung psikolojisinde kolektif bilinçdışının arketipsel enerjisidir - ham, şekillenmemiş ilham.

Chokhmah'ın enerjisi anlık kavrayıştır: "Aha!" anı, satori, bir şimşek gibi gelen içgörü. Mantık öncesidir, analiz gerektirmez. Chokhmah insanları vizyonerlerdir - resmin tamamını bir anda görürler ama detayları açıklamakta zorlanabilirler. Onların görevi, kozmik ilhamı dünyaya taşımaktır.''';

      case Sefirah.binah:
        return '''Binah, "Anlayış" veya "Kavrayış" demektir ve sol sütunda (Şiddet Sütunu) yer alır. Chokhmah'ın "Baba" enerjisini alan "Ana" prensibidir - Zohar'da "Ima" (Anne) olarak anılır. Supernal Üçlü'nün (Keter-Chokhmah-Binah) üçüncü ve tamamlayıcı parçasıdır.

Chokhmah saf potansiyel iken, Binah form verendir. Ham ilhamı alır, işler, yapılandırır. Bu nedenle "Saray" (Hekal) olarak da bilinir - içinde Bilgeliğin oturduğu yapı. Platoncu felsefede, formların (ideaların) ilk tezahür ettiği alemdir.

Binah'ın bir diğer yönü de sınırlamadır. Form vermek, aynı zamanda sınırlamaktır - sonsuz potansiyeli belirli bir kalıba dökmek. Bu nedenle Binah, hem yaratıcı hem de kısıtlayıcı bir enerjidir. Satürn gezegeniyle ilişkilendirilir - zaman, yapı, sınır. Binah insanları analitik düşünürlerdir, detayları görür, sistemler kurar. Onların görevi, vizyonu somut forma dönüştürmektir.''';

      case Sefirah.chesed:
        return '''Chesed (veya Gedulah - "Büyüklük"), "Merhamet" ve "Sevecen İyilik" anlamına gelir. Hayat Ağacı'nın sağ sütununda, aşağı âlemlerde Chokhmah'ın yansımasıdır. Zohar'da "Sağ Kol" (Yad Yamin) olarak anılır - verenin, kutsayanın eli.

Chesed, saf genişleme ve bolluğun enerjisidir. Koşulsuz verme, sınırsız merhamet, her şeyi kucaklayan sevgi. Jüpiter gezegeniyle ilişkilendirilir - genişleme, büyüme, bereket. Sufizmde bu enerji "Rahman" (Merhametli) sıfatına denk gelir.

Ancak Chesed'in gölge yönü de vardır: Sınırsız verme, alıcıyı zayıflatabilir, bağımlılık yaratabilir. Dengelenmemiş merhamet, adalet duygusunu köreltir. Bu nedenle Chesed, karşısındaki Gevurah ile dengelenir. Chesed insanları doğal iyilikseverlerdir, şifacılar, yardım edenlerdir. Onların dersi, verirken sınır koymayı da öğrenmektir.''';

      case Sefirah.gevurah:
        return '''Gevurah, "Güç" veya "Şiddet" anlamına gelir ve Hayat Ağacı'nın sol sütununda yer alır. Din (Yargı) olarak da bilinir. Zohar'da "Sol Kol" (Yad Smol) olarak anılır - kısıtlayan, sınır koyan, yargılayan güç.

Gevurah, Chesed'in dengeleyicisidir. Chesed sınırsız verme ise, Gevurah "Hayır" deme gücüdür. Disiplin, sınır, odaklanma, arındırma. Mars gezegeniyle ilişkilendirilir - savaşçı enerji, kararlılık, cesaret. Simyada bu, gereksiz olanı yakıp yok eden "calcinatio" (kireçleme) sürecidir.

Gevurah'ın korkulan bir yönü vardır - "Din" (Yargı) olarak, hak edeni cezalandıran güçtür. Ancak bu yargı keyfî değil, kozmik dengenin korunması içindir. Gevurah olmadan evren kaosa sürüklenirdi. Gevurah insanları doğal liderlerdir, karar vericiler, sınır koyanlardır. Onların dersi, gücü merhamet ile yumuşatmak, yargıyı sevgi ile dengelemektir.''';

      case Sefirah.tiferet:
        return '''Tiferet, "Güzellik" ve "Uyum" anlamına gelir. Hayat Ağacı'nın tam merkezinde yer alan bu Sefirah, tüm diğer Sefirot'un kesişim noktasıdır. Zohar'da "Küçük Yüz" (Ze'ir Anpin) olarak anılır - ilahi yüzün algılanabilir tezahürü.

Tiferet, Chesed ve Gevurah'ın mükemmel dengesini temsil eder - merhamet ve yargının uyumu, sevgi ve disiplinin birliği. Bu nedenle "Hakikat" (Emet) olarak da bilinir. Güneş ile ilişkilendirilir - aydınlatan, ısıtan, hayat veren merkez.

Mistik gelenekte Tiferet, "Kalp" ile özdeşleştirilir - hem fiziksel hem spiritüel merkez. Hristiyan Kabalasında İsa'nın Sefirah'ı olarak görülür. Jung psikolojisinde "Self" (Benlik) - ego'nun ötesindeki bütünleşik merkez. Tiferet insanları doğal arabuluculardır, denge arayanlardır. Onların görevi, zıtlıkları birleştirmek, uyum yaratmaktır.''';

      case Sefirah.netzach:
        return '''Netzach, "Zafer" veya "Sonsuzluk" anlamına gelir. Sağ sütunun en alt Sefirah'ıdır ve duygusal, içgüdüsel enerjilerin kaynağıdır. Zohar'da "Sağ Bacak" olarak anılır - ileri taşıyan, hareket ettiren güç.

Netzach, doğanın yaratıcı gücünü temsil eder - döngüsel, daima yenilenen, tükenmez. Venüs gezegeniyle ilişkilendirilir - aşk, güzellik, sanat, tutku. Bu Sefirah, mantık öncesi bir enerjiye sahiptir; hisseder, sever, yaratır - analiz etmez.

Simyada Netzach, "viriditas" (yeşillik) kavramına denktir - Hildegard von Bingen'in deyişiyle, tüm yaratılışı canlandıran yaşam gücü. Sanatçıların, müzisyenlerin, şairlerin Sefirah'ıdır. Netzach insanları tutkulu, yaratıcı, kararlıdır. Onların dersi, duygusal enerjilerini yapıcı kanallara yönlendirmek, azimlerini bilgelik ile birleştirmektir.''';

      case Sefirah.hod:
        return '''Hod, "Görkem" veya "İhtişam" anlamına gelir. Sol sütunun en alt Sefirah'ıdır ve zihinsel, analitik enerjilerin merkezidir. Zohar'da "Sol Bacak" olarak anılır - denge ve hassasiyet sağlayan güç.

Hod, Netzach'ın dengeleyicisidir. Netzach hissederken, Hod düşünür. Netzach sezgisel iken, Hod analitiktir. Merkür gezegeniyle ilişkilendirilir - iletişim, ticaret, bilgi. Hermes Trismegistus'un "Zümrüt Tablet"indeki "Yukarıda ne varsa, aşağıda da o vardır" ilkesinin pratik uygulamasıdır.

Hod, büyü (magic) ile yakından ilişkilidir. Kabalistik gelenekte, ritüeller ve formüller Hod enerjisi ile çalışır - kelimeler, semboller, yapılandırılmış niyetler. Bilim insanlarının, yazarların, iletişimcilerin Sefirah'ıdır. Hod insanları analitik, artiküle, detay odaklıdır. Onların dersi, zihinsel kavrayışı duygusal derinlik ile dengelemektir.''';

      case Sefirah.yesod:
        return '''Yesod, "Temel" anlamına gelir ve Hayat Ağacı'nın dokuzuncu Sefirah'ıdır. Orta sütunda, Tiferet ile Malkut arasında köprü görevi görür. Zohar'da "Tsaddik" (Ermiş) olarak anılır - dünyaları birbirine bağlayan kanal.

Yesod, astral plan ile fiziksel plan arasındaki geçiş noktasıdır. Rüyaların, vizyonların, bilinçdışının Sefirah'ıdır. Ay ile ilişkilendirilir - döngüsel değişim, yansıma, gizem. Freud'un bilinçdışı kavramı, Jung'un kolektif bilinçdışı, hepsi Yesod enerjisine tekabül eder.

Cinsellik ve üreme de Yesod ile ilişkilidir - yaşam enerjisinin (hayim) fiziksel dünyaya aktarılması. Tantrik geleneklerde "kundalini" enerjisinin ikinci merkezidir. Yesod insanları sezgisel, rüya gören, psişik yeteneklere açıktır. Onların dersi, bu hassas enerjiyi korumak, fantezi ile gerçekliği ayırt etmek, temeli sağlamlaştırmaktır.''';

      case Sefirah.malkut:
        return '''Malkut, "Krallık" anlamına gelir ve Hayat Ağacı'nın onuncu ve en alttaki Sefirah'ıdır. Zohar'da "Şekhinah" (İlahi Mevcudiyet) olarak anılır - Tanrı'nın dünyada içkin olan yüzü. Aynı zamanda "Kala" (Gelin) olarak da bilinir - Tiferet ile mistik birliği bekleyen dişil prensip.

Malkut, fiziksel evrenin tamamını temsil eder - dünya elementi, madde, somut gerçeklik. Ancak bu "en düşük" Sefirah olması onu değersiz kılmaz. Aksine, Kabala'da maddi dünya, tüm yüksek enerjilerin nihai ifade bulduğu kutsal mekândır. "Krallık" adı, buranın bir çöplük değil, bir saray olduğunu vurgular.

Malkut'un gizemi şudur: Yolculuk yukarı çıkmak için önce burada, maddede başlamalıdır. Fiziksel beden, kutsal bir tapınaktır. Günlük yaşam, spiritüel pratiktir. Malkut insanları pratik, yerleşik, topraklıdır. Onların dersi, sıradan olanın içindeki kutsalı görmek, maddeyi ruhsallaştırmaktır.''';
    }
  }

  /// İlahi İsim - her Sefirah'ın ilişkilendirildiği Tanrı ismi
  String get divineName => divineNameEn; // Divine names are universal

  String get divineNameEn {
    switch (this) {
      case Sefirah.keter: return 'Ehyeh Asher Ehyeh (I Am That I Am)';
      case Sefirah.chokhmah: return 'Yah (Yod-Heh)';
      case Sefirah.binah: return 'YHVH Elohim';
      case Sefirah.chesed: return 'El (God)';
      case Sefirah.gevurah: return 'Elohim Gibor (Mighty God)';
      case Sefirah.tiferet: return 'YHVH Eloah ve-Daath';
      case Sefirah.netzach: return 'YHVH Tzavaot (Lord of Hosts)';
      case Sefirah.hod: return 'Elohim Tzavaot';
      case Sefirah.yesod: return 'El Chai (Living God)';
      case Sefirah.malkut: return 'Adonai (Lord)';
    }
  }

  String get divineNameTr {
    switch (this) {
      case Sefirah.keter: return 'Ehyeh Asher Ehyeh (Ben Olanım)';
      case Sefirah.chokhmah: return 'Yah (Yod-Heh)';
      case Sefirah.binah: return 'YHVH Elohim';
      case Sefirah.chesed: return 'El (Tanrı)';
      case Sefirah.gevurah: return 'Elohim Gibor (Güçlü Tanrı)';
      case Sefirah.tiferet: return 'YHVH Eloah ve-Daath';
      case Sefirah.netzach: return 'YHVH Tzavaot (Ordular Tanrısı)';
      case Sefirah.hod: return 'Elohim Tzavaot';
      case Sefirah.yesod: return 'El Chai (Yaşayan Tanrı)';
      case Sefirah.malkut: return 'Adonai (Efendim)';
    }
  }

  String localizedDivineName(AppLanguage language) {
    return language == AppLanguage.tr ? divineNameTr : divineNameEn;
  }

  /// Başmelek - her Sefirah'ın koruyucu meleği
  String get archangel => archangelEn;

  String get archangelEn {
    switch (this) {
      case Sefirah.keter: return 'Metatron';
      case Sefirah.chokhmah: return 'Raziel (Angel of Secrets)';
      case Sefirah.binah: return 'Tzafkiel (God\'s Watcher)';
      case Sefirah.chesed: return 'Tzadkiel (God\'s Justice)';
      case Sefirah.gevurah: return 'Kamael (Who Sees God)';
      case Sefirah.tiferet: return 'Mikhael (Who Is Like God)';
      case Sefirah.netzach: return 'Haniel (Grace of God)';
      case Sefirah.hod: return 'Raphael (God Heals)';
      case Sefirah.yesod: return 'Gabriel (Strength of God)';
      case Sefirah.malkut: return 'Sandalphon';
    }
  }

  String get archangelTr {
    switch (this) {
      case Sefirah.keter: return 'Metatron';
      case Sefirah.chokhmah: return 'Raziel (Sırların Meleği)';
      case Sefirah.binah: return 'Tzafkiel (Tanrı\'nın Gözcüsü)';
      case Sefirah.chesed: return 'Tzadkiel (Tanrı\'nın Adaleti)';
      case Sefirah.gevurah: return 'Kamael (Tanrı\'yı Gören)';
      case Sefirah.tiferet: return 'Mikhael (Tanrı Gibi Olan)';
      case Sefirah.netzach: return 'Haniel (Tanrı\'nın Lütfu)';
      case Sefirah.hod: return 'Raphael (Tanrı Şifa Verir)';
      case Sefirah.yesod: return 'Gabriel (Tanrı\'nın Gücü)';
      case Sefirah.malkut: return 'Sandalphon';
    }
  }

  String localizedArchangel(AppLanguage language) {
    return language == AppLanguage.tr ? archangelTr : archangelEn;
  }

  /// Gezegen etkisi
  String get planet => planetEn;

  String get planetEn {
    switch (this) {
      case Sefirah.keter: return 'Primum Mobile (First Movement)';
      case Sefirah.chokhmah: return 'Fixed Stars';
      case Sefirah.binah: return 'Saturn';
      case Sefirah.chesed: return 'Jupiter';
      case Sefirah.gevurah: return 'Mars';
      case Sefirah.tiferet: return 'Sun';
      case Sefirah.netzach: return 'Venus';
      case Sefirah.hod: return 'Mercury';
      case Sefirah.yesod: return 'Moon';
      case Sefirah.malkut: return 'Earth (Elements)';
    }
  }

  String get planetTr {
    switch (this) {
      case Sefirah.keter: return 'Primum Mobile (İlk Hareket)';
      case Sefirah.chokhmah: return 'Sabit Yıldızlar';
      case Sefirah.binah: return 'Satürn';
      case Sefirah.chesed: return 'Jüpiter';
      case Sefirah.gevurah: return 'Mars';
      case Sefirah.tiferet: return 'Güneş';
      case Sefirah.netzach: return 'Venüs';
      case Sefirah.hod: return 'Merkür';
      case Sefirah.yesod: return 'Ay';
      case Sefirah.malkut: return 'Dünya (Elementler)';
    }
  }

  String localizedPlanet(AppLanguage language) {
    return language == AppLanguage.tr ? planetTr : planetEn;
  }

  /// Hayat Ağacı'ndaki sütun
  String get pillar => pillarEn;

  String get pillarEn {
    switch (this) {
      case Sefirah.keter:
      case Sefirah.tiferet:
      case Sefirah.yesod:
      case Sefirah.malkut:
        return 'Middle Pillar (Balance)';
      case Sefirah.chokhmah:
      case Sefirah.chesed:
      case Sefirah.netzach:
        return 'Right Pillar (Mercy)';
      case Sefirah.binah:
      case Sefirah.gevurah:
      case Sefirah.hod:
        return 'Left Pillar (Severity)';
    }
  }

  String get pillarTr {
    switch (this) {
      case Sefirah.keter:
      case Sefirah.tiferet:
      case Sefirah.yesod:
      case Sefirah.malkut:
        return 'Orta Sütun (Denge)';
      case Sefirah.chokhmah:
      case Sefirah.chesed:
      case Sefirah.netzach:
        return 'Sağ Sütun (Rahmet)';
      case Sefirah.binah:
      case Sefirah.gevurah:
      case Sefirah.hod:
        return 'Sol Sütun (Şiddet)';
    }
  }

  String localizedPillar(AppLanguage language) {
    return language == AppLanguage.tr ? pillarTr : pillarEn;
  }

  /// Ruh düzeyi
  String get soulLevel {
    switch (this) {
      case Sefirah.keter: return 'Yechida (Teklik)';
      case Sefirah.chokhmah: return 'Chaya (Yaşam Gücü)';
      case Sefirah.binah: return 'Neshamah (Yüksek Ruh)';
      case Sefirah.chesed:
      case Sefirah.gevurah:
      case Sefirah.tiferet:
        return 'Ruach (Ruh/Nefes)';
      case Sefirah.netzach:
      case Sefirah.hod:
      case Sefirah.yesod:
        return 'Ruach (Duygusal/Zihinsel)';
      case Sefirah.malkut:
        return 'Nefesh (Hayvansal Ruh)';
    }
  }

  /// Vücut bölgesi
  String get bodyPart {
    switch (this) {
      case Sefirah.keter: return 'Başın tepesi (Taç)';
      case Sefirah.chokhmah: return 'Sağ beyin yarımküresi';
      case Sefirah.binah: return 'Sol beyin yarımküresi';
      case Sefirah.chesed: return 'Sağ omuz/kol';
      case Sefirah.gevurah: return 'Sol omuz/kol';
      case Sefirah.tiferet: return 'Kalp/Göğüs';
      case Sefirah.netzach: return 'Sağ kalça/bacak';
      case Sefirah.hod: return 'Sol kalça/bacak';
      case Sefirah.yesod: return 'Üreme organları';
      case Sefirah.malkut: return 'Ayaklar/Tüm beden';
    }
  }

  /// Erdem (olumlu nitelik)
  String get virtue => virtueEn;

  String get virtueEn {
    switch (this) {
      case Sefirah.keter: return 'Infinite Will, Unity Consciousness';
      case Sefirah.chokhmah: return 'Pure Wisdom, Inspiration';
      case Sefirah.binah: return 'Deep Understanding, Silence';
      case Sefirah.chesed: return 'Compassion, Generosity';
      case Sefirah.gevurah: return 'Courage, Discipline';
      case Sefirah.tiferet: return 'Kindness, Balance, Beauty';
      case Sefirah.netzach: return 'Determination, Loyalty';
      case Sefirah.hod: return 'Honesty, Openness';
      case Sefirah.yesod: return 'Purity, Independence';
      case Sefirah.malkut: return 'Discernment, Grounding';
    }
  }

  String get virtueTr {
    switch (this) {
      case Sefirah.keter: return 'Sonsuz İrade, Birlik Bilinci';
      case Sefirah.chokhmah: return 'Saf Bilgelik, İlham';
      case Sefirah.binah: return 'Derin Anlayış, Sessizlik';
      case Sefirah.chesed: return 'Merhamet, Cömertlik';
      case Sefirah.gevurah: return 'Cesaret, Disiplin';
      case Sefirah.tiferet: return 'Şefkat, Denge, Güzellik';
      case Sefirah.netzach: return 'Kararlılık, Sadakat';
      case Sefirah.hod: return 'Dürüstlük, Açıklık';
      case Sefirah.yesod: return 'Saflık, Bağımsızlık';
      case Sefirah.malkut: return 'Ayrımcılık, Topraklanma';
    }
  }

  String localizedVirtue(AppLanguage language) {
    return language == AppLanguage.tr ? virtueTr : virtueEn;
  }

  /// Kusur (dengelenmemiş hali)
  String get vice => viceEn;

  String get viceEn {
    switch (this) {
      case Sefirah.keter: return 'Lack of commitment';
      case Sefirah.chokhmah: return 'Evil, Destructiveness';
      case Sefirah.binah: return 'Greed, Jealousy';
      case Sefirah.chesed: return 'Extravagance, Dependency';
      case Sefirah.gevurah: return 'Cruelty, Ruthlessness';
      case Sefirah.tiferet: return 'Pride, False glory';
      case Sefirah.netzach: return 'Lust, Obsession';
      case Sefirah.hod: return 'Dishonesty, Deceit';
      case Sefirah.yesod: return 'Indecision, Fantasy-prone';
      case Sefirah.malkut: return 'Laziness, Materialism';
    }
  }

  String get viceTr {
    switch (this) {
      case Sefirah.keter: return 'Bağlılık eksikliği';
      case Sefirah.chokhmah: return 'Kötülük, Yıkıcılık';
      case Sefirah.binah: return 'Açgözlülük, Kıskançlık';
      case Sefirah.chesed: return 'Savurganlık, Bağımlılık';
      case Sefirah.gevurah: return 'Zalimlik, Acımasızlık';
      case Sefirah.tiferet: return 'Kibir, Yanlış gurur';
      case Sefirah.netzach: return 'Şehvet, Saplantı';
      case Sefirah.hod: return 'Yalancılık, Sahtecilik';
      case Sefirah.yesod: return 'Kararsızlık, Hayal düşkünlüğü';
      case Sefirah.malkut: return 'Tembellik, Materyalizm';
    }
  }

  String localizedVice(AppLanguage language) {
    return language == AppLanguage.tr ? viceTr : viceEn;
  }

  String get color => colorEn;

  String get colorEn {
    switch (this) {
      case Sefirah.keter: return 'White/Brilliant';
      case Sefirah.chokhmah: return 'Gray/Silver';
      case Sefirah.binah: return 'Black/Dark Blue';
      case Sefirah.chesed: return 'Blue';
      case Sefirah.gevurah: return 'Red';
      case Sefirah.tiferet: return 'Gold/Yellow';
      case Sefirah.netzach: return 'Green';
      case Sefirah.hod: return 'Orange';
      case Sefirah.yesod: return 'Purple';
      case Sefirah.malkut: return 'Earth Tones';
    }
  }

  String get colorTr {
    switch (this) {
      case Sefirah.keter: return 'Beyaz/Parlak';
      case Sefirah.chokhmah: return 'Gri/Gümüş';
      case Sefirah.binah: return 'Siyah/Koyu Mavi';
      case Sefirah.chesed: return 'Mavi';
      case Sefirah.gevurah: return 'Kırmızı';
      case Sefirah.tiferet: return 'Altın/Sarı';
      case Sefirah.netzach: return 'Yeşil';
      case Sefirah.hod: return 'Turuncu';
      case Sefirah.yesod: return 'Mor';
      case Sefirah.malkut: return 'Toprak Tonları';
    }
  }

  String localizedColor(AppLanguage language) {
    return language == AppLanguage.tr ? colorTr : colorEn;
  }

  int get number {
    switch (this) {
      case Sefirah.keter: return 1;
      case Sefirah.chokhmah: return 2;
      case Sefirah.binah: return 3;
      case Sefirah.chesed: return 4;
      case Sefirah.gevurah: return 5;
      case Sefirah.tiferet: return 6;
      case Sefirah.netzach: return 7;
      case Sefirah.hod: return 8;
      case Sefirah.yesod: return 9;
      case Sefirah.malkut: return 10;
    }
  }

  static Sefirah fromNumber(int number) {
    switch (number) {
      case 1: return Sefirah.keter;
      case 2: return Sefirah.chokhmah;
      case 3: return Sefirah.binah;
      case 4: return Sefirah.chesed;
      case 5: return Sefirah.gevurah;
      case 6: return Sefirah.tiferet;
      case 7: return Sefirah.netzach;
      case 8: return Sefirah.hod;
      case 9: return Sefirah.yesod;
      case 10: return Sefirah.malkut;
      default: return Sefirah.malkut;
    }
  }
}

/// Kabala uyumluluk sonucu
class KabbalahCompatibility {
  final int person1Number;
  final int person2Number;
  final Sefirah person1Sefirah;
  final Sefirah person2Sefirah;
  final int sefirahCompatibility;
  final int soulCompatibility;
  final int overallScore;
  final String interpretation;

  KabbalahCompatibility({
    required this.person1Number,
    required this.person2Number,
    required this.person1Sefirah,
    required this.person2Sefirah,
    required this.sefirahCompatibility,
    required this.soulCompatibility,
    required this.overallScore,
    required this.interpretation,
  });
}

/// Günlük Kabala enerjisi
class DailyKabbalahEnergy {
  final DateTime date;
  final Sefirah sefirah;
  final int number;
  final String guidance;
  final String meditation;

  DailyKabbalahEnergy({
    required this.date,
    required this.sefirah,
    required this.number,
    required this.guidance,
    required this.meditation,
  });
}
