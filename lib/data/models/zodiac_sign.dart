import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../services/localization_service.dart';
import '../services/l10n_service.dart';
import '../providers/app_providers.dart';

enum Element { fire, earth, air, water }

enum Modality { cardinal, fixed, mutable }

enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces,
}

extension ZodiacSignExtension on ZodiacSign {
  String get name {
    switch (this) {
      case ZodiacSign.aries:
        return 'Aries';
      case ZodiacSign.taurus:
        return 'Taurus';
      case ZodiacSign.gemini:
        return 'Gemini';
      case ZodiacSign.cancer:
        return 'Cancer';
      case ZodiacSign.leo:
        return 'Leo';
      case ZodiacSign.virgo:
        return 'Virgo';
      case ZodiacSign.libra:
        return 'Libra';
      case ZodiacSign.scorpio:
        return 'Scorpio';
      case ZodiacSign.sagittarius:
        return 'Sagittarius';
      case ZodiacSign.capricorn:
        return 'Capricorn';
      case ZodiacSign.aquarius:
        return 'Aquarius';
      case ZodiacSign.pisces:
        return 'Pisces';
    }
  }

  String get nameTr {
    switch (this) {
      case ZodiacSign.aries:
        return 'Koç';
      case ZodiacSign.taurus:
        return 'Boğa';
      case ZodiacSign.gemini:
        return 'İkizler';
      case ZodiacSign.cancer:
        return 'Yengeç';
      case ZodiacSign.leo:
        return 'Aslan';
      case ZodiacSign.virgo:
        return 'Başak';
      case ZodiacSign.libra:
        return 'Terazi';
      case ZodiacSign.scorpio:
        return 'Akrep';
      case ZodiacSign.sagittarius:
        return 'Yay';
      case ZodiacSign.capricorn:
        return 'Oğlak';
      case ZodiacSign.aquarius:
        return 'Kova';
      case ZodiacSign.pisces:
        return 'Balık';
    }
  }

  /// Get localized name based on app language
  /// Uses strict isolation L10nService for supported languages (EN/TR/DE/FR)
  /// Falls back to old L10n for other languages
  String localizedName(AppLanguage language) {
    final key = toString().split('.').last; // 'aries', 'taurus', etc.

    // Use strict isolation L10nService for supported languages
    if (L10nService.supportedLanguages.contains(language) &&
        L10nService.isLanguageLoaded(language)) {
      return L10nService.get('zodiac.$key', language);
    }

    // Fallback to old L10n for unsupported languages
    return L10n.get(key, language);
  }

  /// Alias for localizedName - consistent naming with other getters
  String getLocalizedName(AppLanguage language) => localizedName(language);

  /// Get localized detailed description based on app language
  /// Currently only Turkish detailed descriptions are available, other languages fall back to English
  String getLocalizedDetailedDescription(AppLanguage language) {
    // For now, return Turkish for TR and English description for others
    // Full localization would require adding detailed descriptions for each language
    if (language == AppLanguage.tr) {
      return detailedDescriptionTr;
    }
    return description;
  }

  /// Get localized traits based on app language
  /// Currently only Turkish traits are available, other languages fall back to generic traits
  List<String> getLocalizedTraits(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return traits;
    }
    // English trait equivalents
    switch (this) {
      case ZodiacSign.aries:
        return ['Warrior Spirit', 'Fire Energy', 'Pioneer Force', 'Instant Action'];
      case ZodiacSign.taurus:
        return ['Earth Wisdom', 'Stone Patience', 'Loyal Heart', 'Mountain Resolve'];
      case ZodiacSign.gemini:
        return ['Wind Intelligence', 'Curious Light', 'Word Magic', 'Flying Thought'];
      case ZodiacSign.cancer:
        return ['Mother Energy', 'Moon Intuition', 'Protective Shell', 'Tidal Emotion'];
      case ZodiacSign.leo:
        return ['Sun Heart', 'Creative Fire', 'Royal Aura', 'Stage Spirit'];
      case ZodiacSign.virgo:
        return ['Detail Eye', 'Earth Practice', 'Service Spirit', 'Perfect Quest'];
      case ZodiacSign.libra:
        return ['Balance Master', 'Justice Scales', 'Venus Charm', 'Weighing Soul'];
      case ZodiacSign.scorpio:
        return ['Transform Power', 'Depth Knowledge', 'Pluto Courage', 'Mystery Veil'];
      case ZodiacSign.sagittarius:
        return ['Archer Vision', 'Adventure Fire', 'Truth Arrow', 'Free Spirit'];
      case ZodiacSign.capricorn:
        return ['Summit Drive', 'Saturn Discipline', 'Mountain Patience', 'Stone Wall'];
      case ZodiacSign.aquarius:
        return ['Revolutionary Soul', 'Uranus Spark', 'Free Mind', 'Distant Gaze'];
      case ZodiacSign.pisces:
        return ['Ocean Heart', 'Neptune Dream', 'Mystic Intuition', 'Boundless Imagination'];
    }
  }

  String get symbol {
    switch (this) {
      case ZodiacSign.aries:
        return '♈';
      case ZodiacSign.taurus:
        return '♉';
      case ZodiacSign.gemini:
        return '♊';
      case ZodiacSign.cancer:
        return '♋';
      case ZodiacSign.leo:
        return '♌';
      case ZodiacSign.virgo:
        return '♍';
      case ZodiacSign.libra:
        return '♎';
      case ZodiacSign.scorpio:
        return '♏';
      case ZodiacSign.sagittarius:
        return '♐';
      case ZodiacSign.capricorn:
        return '♑';
      case ZodiacSign.aquarius:
        return '♒';
      case ZodiacSign.pisces:
        return '♓';
    }
  }

  String get dateRange {
    switch (this) {
      case ZodiacSign.aries:
        return 'Mar 21 - Apr 19';
      case ZodiacSign.taurus:
        return 'Apr 20 - May 20';
      case ZodiacSign.gemini:
        return 'May 21 - Jun 20';
      case ZodiacSign.cancer:
        return 'Jun 21 - Jul 22';
      case ZodiacSign.leo:
        return 'Jul 23 - Aug 22';
      case ZodiacSign.virgo:
        return 'Aug 23 - Sep 22';
      case ZodiacSign.libra:
        return 'Sep 23 - Oct 22';
      case ZodiacSign.scorpio:
        return 'Oct 23 - Nov 21';
      case ZodiacSign.sagittarius:
        return 'Nov 22 - Dec 21';
      case ZodiacSign.capricorn:
        return 'Dec 22 - Jan 19';
      case ZodiacSign.aquarius:
        return 'Jan 20 - Feb 18';
      case ZodiacSign.pisces:
        return 'Feb 19 - Mar 20';
    }
  }

  Element get element {
    switch (this) {
      case ZodiacSign.aries:
      case ZodiacSign.leo:
      case ZodiacSign.sagittarius:
        return Element.fire;
      case ZodiacSign.taurus:
      case ZodiacSign.virgo:
      case ZodiacSign.capricorn:
        return Element.earth;
      case ZodiacSign.gemini:
      case ZodiacSign.libra:
      case ZodiacSign.aquarius:
        return Element.air;
      case ZodiacSign.cancer:
      case ZodiacSign.scorpio:
      case ZodiacSign.pisces:
        return Element.water;
    }
  }

  Modality get modality {
    switch (this) {
      case ZodiacSign.aries:
      case ZodiacSign.cancer:
      case ZodiacSign.libra:
      case ZodiacSign.capricorn:
        return Modality.cardinal;
      case ZodiacSign.taurus:
      case ZodiacSign.leo:
      case ZodiacSign.scorpio:
      case ZodiacSign.aquarius:
        return Modality.fixed;
      case ZodiacSign.gemini:
      case ZodiacSign.virgo:
      case ZodiacSign.sagittarius:
      case ZodiacSign.pisces:
        return Modality.mutable;
    }
  }

  Color get color {
    switch (element) {
      case Element.fire:
        return AppColors.fireElement;
      case Element.earth:
        return AppColors.earthElement;
      case Element.air:
        return AppColors.airElement;
      case Element.water:
        return AppColors.waterElement;
    }
  }

  String get rulingPlanet {
    switch (this) {
      case ZodiacSign.aries:
        return 'Mars';
      case ZodiacSign.taurus:
        return 'Venus';
      case ZodiacSign.gemini:
        return 'Mercury';
      case ZodiacSign.cancer:
        return 'Moon';
      case ZodiacSign.leo:
        return 'Sun';
      case ZodiacSign.virgo:
        return 'Mercury';
      case ZodiacSign.libra:
        return 'Venus';
      case ZodiacSign.scorpio:
        return 'Pluto';
      case ZodiacSign.sagittarius:
        return 'Jupiter';
      case ZodiacSign.capricorn:
        return 'Saturn';
      case ZodiacSign.aquarius:
        return 'Uranus';
      case ZodiacSign.pisces:
        return 'Neptune';
    }
  }

  String get rulingPlanetTr {
    switch (this) {
      case ZodiacSign.aries:
        return 'Mars';
      case ZodiacSign.taurus:
        return 'Venüs';
      case ZodiacSign.gemini:
        return 'Merkür';
      case ZodiacSign.cancer:
        return 'Ay';
      case ZodiacSign.leo:
        return 'Güneş';
      case ZodiacSign.virgo:
        return 'Merkür';
      case ZodiacSign.libra:
        return 'Venüs';
      case ZodiacSign.scorpio:
        return 'Plüton';
      case ZodiacSign.sagittarius:
        return 'Jüpiter';
      case ZodiacSign.capricorn:
        return 'Satürn';
      case ZodiacSign.aquarius:
        return 'Uranüs';
      case ZodiacSign.pisces:
        return 'Neptün';
    }
  }

  List<String> get traits {
    switch (this) {
      case ZodiacSign.aries:
        return ['Savaşçı Ruh', 'Ateş Enerjisi', 'Öncü Güç', 'Anlık Aksiyon'];
      case ZodiacSign.taurus:
        return ['Toprak Bilgeliği', 'Sabır Taşı', 'Sadık Kalp', 'Dağ Kararlılığı'];
      case ZodiacSign.gemini:
        return ['Rüzgar Zekası', 'Merak Işığı', 'Söz Büyüsü', 'Uçan Düşünce'];
      case ZodiacSign.cancer:
        return ['Anne Enerjisi', 'Ay Sezgisi', 'Koruyucu Kabuk', 'Gelgit Duygusu'];
      case ZodiacSign.leo:
        return ['Güneş Kalbi', 'Yaratıcı Ateş', 'Kral Aurası', 'Sahne Ruhu'];
      case ZodiacSign.virgo:
        return ['Detay Gözü', 'Toprak Pratiği', 'Hizmet Ruhu', 'Mükemmel Arayış'];
      case ZodiacSign.libra:
        return ['Denge Ustası', 'Adalet Terazisi', 'Venüs Cazibesi', 'Tartı Ruhu'];
      case ZodiacSign.scorpio:
        return ['Dönüşüm Gücü', 'Derinlik Bilgisi', 'Plüton Cesareti', 'Gizem Perdesi'];
      case ZodiacSign.sagittarius:
        return ['Okçu Vizyonu', 'Macera Ateşi', 'Hakikat Oku', 'Özgür Ruh'];
      case ZodiacSign.capricorn:
        return ['Zirve Azmi', 'Saturn Disiplini', 'Dağ Sabrı', 'Taş Duvar'];
      case ZodiacSign.aquarius:
        return ['Devrimci Ruh', 'Uranüs Kıvılcımı', 'Özgür Zihin', 'Uzak Bakış'];
      case ZodiacSign.pisces:
        return ['Okyanus Kalbi', 'Neptün Rüyası', 'Mistik Sezgi', 'Sınırsız Hayal'];
    }
  }

  String get description {
    switch (this) {
      case ZodiacSign.aries:
        return 'The Ram charges forward with unstoppable energy and courage. As the first sign of the zodiac, Aries embodies new beginnings and bold initiatives.';
      case ZodiacSign.taurus:
        return 'The Bull grounds us with stability and sensual pleasures. Taurus seeks security and finds joy in life\'s tangible comforts.';
      case ZodiacSign.gemini:
        return 'The Twins dance between ideas with quicksilver minds. Gemini\'s dual nature brings curiosity and adaptability to every situation.';
      case ZodiacSign.cancer:
        return 'The Crab protects with fierce love and emotional depth. Cancer nurtures connections and creates sanctuary wherever they go.';
      case ZodiacSign.leo:
        return 'The Lion roars with creative fire and generous spirit. Leo leads with warmth and inspires others through authentic self-expression.';
      case ZodiacSign.virgo:
        return 'The Maiden analyzes with precision and serves with devotion. Virgo\'s keen eye for detail brings order to chaos.';
      case ZodiacSign.libra:
        return 'The Scales seek harmony and beauty in all things. Libra weighs every option to find balance and fairness.';
      case ZodiacSign.scorpio:
        return 'The Scorpion delves into depths others fear to explore. Scorpio transforms through intensity and emerges renewed.';
      case ZodiacSign.sagittarius:
        return 'The Archer aims for distant horizons with optimistic spirit. Sagittarius seeks truth through adventure and philosophical exploration.';
      case ZodiacSign.capricorn:
        return 'The Sea-Goat climbs steadily toward ambitious heights. Capricorn builds lasting structures through discipline and patience.';
      case ZodiacSign.aquarius:
        return 'The Water-Bearer pours forth innovation for humanity. Aquarius envisions a better future through progressive ideals.';
      case ZodiacSign.pisces:
        return 'The Fish swim through mystical waters of imagination. Pisces dissolves boundaries and connects us to the universal ocean of consciousness.';
    }
  }

  /// Detaylı Türkçe açıklama (10+ cümle)
  String get detailedDescriptionTr {
    switch (this) {
      case ZodiacSign.aries:
        return '''Koç burcu, zodyağın ilk burcu olarak yeni başlangıçların ve cesaretin simgesidir. Mars gezegeninin yönetimindeki bu ateş burcu, liderlik özellikleri ve girişimci ruhuyla tanınır. Koç insanları doğal öncülerdir; bilinmeyene atılmaktan çekinmezler ve risk almaktan korkmazlar. Enerjileri yüksek, tepkileri hızlıdır. Rekabetçi yapıları onları sporda ve iş hayatında öne çıkarır. Sabırsız olabilirler ancak bu özellik onları harekete geçiren bir motor gibidir. İlişkilerde tutkulu ve doğrudandırlar; oyun oynamayı sevmezler. Öfkeleri çabuk parlayabilir ama aynı hızla söner. Bağımsızlıklarına düşkündürler ve kontrol edilmekten hoşlanmazlar. Koç enerjisi, hayatımızda cesarete ihtiyaç duyduğumuz alanlarda bize ilham verir.''';
      case ZodiacSign.taurus:
        return '''Boğa burcu, zodyağın en kararlı ve dayanıklı burcudur. Venüs gezegeninin yönetiminde olan bu toprak burcu, güzellik, konfor ve maddi güvenliğe değer verir. Boğa insanları güvenilir ve sadıktırlar; verdikleri sözü tutarlar. Sabırları efsanevidir ancak sınırları zorlandığında inatçı ve öfkeli olabilirler. Beş duyuları son derece gelişmiştir; yemek, müzik ve dokunsal deneyimlerden büyük zevk alırlar. Değişime dirençlidirler çünkü güvenlik onlar için en önemli değerdir. İlişkilerde bağlılık ve istikrar ararlar; flört oyunlarından hoşlanmazlar. Maddi konularda pratik ve tutumludurlar. Doğayla derin bir bağları vardır; bahçecilik ve toprakla uğraşmak onlara huzur verir. Boğa enerjisi, hayatımızda sağlam temeller atmamız gerektiğinde devreye girer.''';
      case ZodiacSign.gemini:
        return '''İkizler burcu, zodyağın en meraklı ve çok yönlü burcudur. Merkür gezegeninin yönetiminde olan bu hava burcu, iletişim ve zeka ile özdeşleşmiştir. İkizler insanları doğal iletişimcilerdir; her konuda konuşabilir ve her ortama uyum sağlayabilirler. Çift yönlü doğaları onları karmaşık ve öngörülmez kılar. Sıkılmaktan nefret ederler ve sürekli zihinsel uyarı ararlar. Hızlı düşünür, hızlı konuşur ve hızlı hareket ederler. Çok fazla projeye aynı anda başlayıp bitirmekte zorlanabilirler. Sosyal kelebeklerdir; geniş bir sosyal çevreleri vardır. İlişkilerde zihinsel uyum onlar için fiziksel çekimden daha önemlidir. Mizah anlayışları keskindir ve esprili sohbetlerden büyük keyif alırlar. İkizler enerjisi, yeni fikirlere ve perspektiflere açık olmamızı sağlar.''';
      case ZodiacSign.cancer:
        return '''Yengeç burcu, zodyağın en duygusal ve koruyucu burcudur. Ay'ın yönetiminde olan bu su burcu, aile, yuva ve duygusal güvenlikle ilişkilendirilir. Yengeç insanları son derece sezgisel ve empatiktirler; başkalarının duygularını kolayca algılarlar. Koruyucu kabukları altında hassas bir kalp yatar. Ailelerine ve sevdiklerine son derece bağlıdırlar. Geçmişe nostaljik bir bağlılıkları vardır; anıları ve aile geleneklerini önemserler. Ruh halleri Ay'ın evreleri gibi değişkendir. Evlerini bir sığınak olarak görür ve dekorasyona önem verirler. İlişkilerde derin duygusal bağ kurarlar ve sadakat beklerler. Sezgileri güçlüdür; tehlikeyi önceden hissedebilirler. Yengeç enerjisi, başkalarını beslememiz ve korumamız gerektiğinde ortaya çıkar.''';
      case ZodiacSign.leo:
        return '''Aslan burcu, zodyağın en gösterişli ve cömert burcudur. Güneş'in yönetiminde olan bu ateş burcu, yaratıcılık, liderlik ve öz ifade ile özdeşleşmiştir. Aslan insanları doğal yıldızlardır; sahneye çıkmayı ve takdir edilmeyi severler. Cömertlikleri efsanevidir; sevdikleri için her şeyi yaparlar. Gurur onların en güçlü ve en zayıf noktasıdır. Liderlik pozisyonlarına doğal olarak yükselirler. Yaratıcı enerjileri yüksektir; sanat, tiyatro ve performans alanlarında parlayabilirler. Sadakatleri sarsılmazdır; arkadaşlıklarını ve ilişkilerini ciddiye alırlar. İlişkilerde romantik jestleri sever ve beklerler. Eleştiriye karşı hassastırlar; ego yaralanmaları derin olabilir. Aslan enerjisi, kendimizi özgürce ifade etmemiz ve parlamamamız gerektiğinde aktifleşir.''';
      case ZodiacSign.virgo:
        return '''Başak burcu, zodyağın en analitik ve mükemmeliyetçi burcudur. Merkür gezegeninin yönetiminde olan bu toprak burcu, hizmet, sağlık ve detaylara dikkat ile ilişkilendirilir. Başak insanları keskin gözlemcilerdir; en küçük detayları bile fark ederler. Mükemmeliyetçilikleri onları sürekli gelişmeye iter ancak bazen aşırı eleştirel olmalarına neden olur. Pratik çözümler üretmekte ustadırlar. Düzen ve temizlik onlar için önemlidir; kaos onları rahatsız eder. Sağlık konularına büyük önem verirler. Başkalarına yardım etmekten derin bir tatmin duyarlar. İlişkilerde sadık ve özenlidirler; küçük jestler büyük jestlerden daha çok önemlidir onlar için. Endişeye yatkın olabilirler; zihinleri sürekli analiz modundadır. Başak enerjisi, hayatımızda düzen ve iyileştirme gerektiğinde devreye girer.''';
      case ZodiacSign.libra:
        return '''Terazi burcu, zodyağın en diplomatik ve estetik burcudur. Venüs gezegeninin yönetiminde olan bu hava burcu, denge, uyum ve ilişkilerle özdeşleşmiştir. Terazi insanları doğal arabuluculardır; çatışmalardan kaçınır ve barış yaratmaya çalışırlar. Adalete derinden bağlıdırlar; haksızlığa tahammül edemezler. Güzellik ve estetik onlar için temel ihtiyaçtır. Kararsız olabilirler çünkü her durumun her iki tarafını da görebilirler. Sosyal yetenekleri mükemmeldir; her ortamda zarif ve çekicidirler. İlişkilere büyük önem verirler; yalnızlıktan hoşlanmazlar. Romantik doğaları güçlüdür; aşk hayatlarına büyük yatırım yaparlar. İşbirliği onların güçlü yönüdür; takım çalışmasında parlayabilirler. Terazi enerjisi, hayatımızda denge ve uyum aradığımızda ortaya çıkar.''';
      case ZodiacSign.scorpio:
        return '''Akrep burcu, zodyağın en yoğun ve dönüştürücü burcudur. Plüton ve Mars gezegenlerinin yönetiminde olan bu su burcu, tutku, güç ve yeniden doğuşla ilişkilendirilir. Akrep insanları son derece kararlı ve odaklıdırlar; bir hedef belirlediklerinde hiçbir şey onları durduramaz. Sezgileri neredeyse doğaüstüdür; insanların gerçek niyetlerini okuyabilirler. Gizlilik onlar için önemlidir; özel hayatlarını korurlar. Duygusal derinlikleri sonsuzdur; yüzeysel ilişkilerden hoşlanmazlar. Sadakat ve ihanet konularında son derece hassastırlar. İntikam duyguları güçlü olabilir; unutmak onlar için zordur. Dönüşüm onların doğasında vardır; krizlerden daha güçlü çıkarlar. İlişkilerde tutkulu ve yoğundurlar; tamamıyla bağlanırlar veya hiç bağlanmazlar. Akrep enerjisi, derin dönüşüm ve yenilenme zamanlarında aktifleşir.''';
      case ZodiacSign.sagittarius:
        return '''Yay burcu, zodyağın en iyimser ve maceracı burcudur. Jüpiter gezegeninin yönetiminde olan bu ateş burcu, özgürlük, felsefe ve keşifle özdeşleşmiştir. Yay insanları doğal filozoflardır; hayatın anlamını ve büyük soruları sorgularlar. Seyahat ve macera onların kanındadır; farklı kültürleri tanımaktan büyük zevk alırlar. İyimserlikleri bulaşıcıdır; etraflarına pozitif enerji yayarlar. Dürüstlükleri bazen acımasız olabilir; akıllarından geçeni söylerler. Özgürlüklerine son derece düşkündürler; bağlanmaktan kaçınabilirler. Mizah anlayışları gelişmiştir; güldürmekten hoşlanırlar. Aşırı iyimser olmaları bazen gerçeklikten kopmalarına neden olabilir. Eğitim ve öğrenme onlar için yaşam boyu süren tutkudur. Yay enerjisi, ufkumuzu genişletmemiz ve yeni perspektifler edinmemiz gerektiğinde devreye girer.''';
      case ZodiacSign.capricorn:
        return '''Oğlak burcu, zodyağın en hırslı ve disiplinli burcudur. Satürn gezegeninin yönetiminde olan bu toprak burcu, başarı, sorumluluk ve geleneklerle ilişkilendirilir. Oğlak insanları uzun vadeli düşünürler; anlık tatminler yerine kalıcı başarıları tercih ederler. Çalışkanlıkları efsanevidir; hedeflerine ulaşmak için her türlü fedakarlığı yaparlar. Sorumluluk duyguları güçlüdür; verdikleri sözleri tutarlar. Geleneklere ve otoriteye saygı duyarlar. Duygularını göstermekte zorlanabilirler; dışarıdan soğuk görünebilirler. Maddi güvenlik onlar için son derece önemlidir. İlişkilerde sadık ve koruyucudurlar; ailelerini her şeyin üstünde tutarlar. Yaşlandıkça gençleşir gibi görünürler; zamanla daha rahat ve neşeli olurlar. Oğlak enerjisi, hayatımızda disiplin ve kararlılık gerektiren dönemlerde ortaya çıkar.''';
      case ZodiacSign.aquarius:
        return '''Kova burcu, zodyağın en özgün ve vizyoner burcudur. Uranüs ve Satürn gezegenlerinin yönetiminde olan bu hava burcu, yenilik, insanlık ve özgürlükle özdeşleşmiştir. Kova insanları zamanlarının ötesinde düşünürler; geleceği bugünden görürler. Bireyselliklerine son derece düşkündürler; kalabalığı takip etmezler. İnsani değerlere derinden bağlıdırlar; sosyal adalet konularında aktiftirler. Entelektüel bağımsızlıkları güçlüdür; kendi fikirlerini oluştururlar. Duygusal mesafe koyabilirler; yakınlık bazen onları rahatsız eder. Arkadaşlıklara büyük değer verirler; geniş bir sosyal ağları vardır. Sıra dışı ve eksantrik olabilirler; normalden hoşlanmazlar. Teknoloji ve bilimle doğal bir yakınlıkları vardır. İlişkilerde özgürlük ve entelektüel uyum ararlar. Kova enerjisi, kalıpları kırmamız ve yenilik yapmamız gerektiğinde aktifleşir.''';
      case ZodiacSign.pisces:
        return '''Balık burcu, zodyağın en spiritüel ve empatik burcudur. Neptün ve Jüpiter gezegenlerinin yönetiminde olan bu su burcu, hayal gücü, şefkat ve mistisizmle özdeşleşmiştir. Balık insanları son derece sezgisel ve psişiktirler; görünmeyeni hissedebilirler. Empati kapasiteleri sonsuzdur; başkalarının acısını kendi acıları gibi hissederler. Sanatsal yetenekleri güçlüdür; müzik, resim ve şiirde parlayabilirler. Gerçeklik ile hayal arasındaki sınır onlar için bulanıktır. Kaçış eğilimleri olabilir; zor durumlardan sığınak ararlar. Fedakar doğaları bazen kendilerini ihmal etmelerine neden olur. Ruhani konulara doğal bir ilgileri vardır. İlişkilerde romantik ve idealisttirler; aşkı masalsallaştırabilirler. Sınırları belirsiz olabilir; nerede bittiklerini ve başkalarının nerede başladığını ayırt etmekte zorlanabilirler. Balık enerjisi, şifa, yaratıcılık ve spiritüel bağlantı zamanlarında devreye girer.''';
    }
  }

  static ZodiacSign fromDate(DateTime date) {
    final month = date.month;
    final day = date.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return ZodiacSign.aries;
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return ZodiacSign.taurus;
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return ZodiacSign.gemini;
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return ZodiacSign.cancer;
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return ZodiacSign.leo;
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return ZodiacSign.virgo;
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return ZodiacSign.libra;
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return ZodiacSign.scorpio;
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return ZodiacSign.sagittarius;
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return ZodiacSign.capricorn;
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return ZodiacSign.aquarius;
    } else {
      return ZodiacSign.pisces;
    }
  }
}

extension ElementExtension on Element {
  String get name {
    switch (this) {
      case Element.fire:
        return 'Fire';
      case Element.earth:
        return 'Earth';
      case Element.air:
        return 'Air';
      case Element.water:
        return 'Water';
    }
  }

  String get nameTr {
    switch (this) {
      case Element.fire:
        return 'Ateş';
      case Element.earth:
        return 'Toprak';
      case Element.air:
        return 'Hava';
      case Element.water:
        return 'Su';
    }
  }

  /// Get localized element name based on app language
  String localizedName(AppLanguage language) {
    switch (this) {
      case Element.fire:
        return L10n.get('element_fire', language);
      case Element.earth:
        return L10n.get('element_earth', language);
      case Element.air:
        return L10n.get('element_air', language);
      case Element.water:
        return L10n.get('element_water', language);
    }
  }

  /// Alias for localizedName - consistent naming
  String getLocalizedName(AppLanguage language) => localizedName(language);

  String get symbol {
    switch (this) {
      case Element.fire:
        return '🔥';
      case Element.earth:
        return '🌍';
      case Element.air:
        return '💨';
      case Element.water:
        return '💧';
    }
  }

  Color get color {
    switch (this) {
      case Element.fire:
        return AppColors.fireElement;
      case Element.earth:
        return AppColors.earthElement;
      case Element.air:
        return AppColors.airElement;
      case Element.water:
        return AppColors.waterElement;
    }
  }
}

extension ModalityExtension on Modality {
  String get name {
    switch (this) {
      case Modality.cardinal:
        return 'Cardinal';
      case Modality.fixed:
        return 'Fixed';
      case Modality.mutable:
        return 'Mutable';
    }
  }

  String get nameTr {
    switch (this) {
      case Modality.cardinal:
        return 'Öncü';
      case Modality.fixed:
        return 'Sabit';
      case Modality.mutable:
        return 'Değişken';
    }
  }

  /// Get localized modality name based on app language
  String localizedName(AppLanguage language) {
    switch (this) {
      case Modality.cardinal:
        return L10n.get('modality_cardinal', language);
      case Modality.fixed:
        return L10n.get('modality_fixed', language);
      case Modality.mutable:
        return L10n.get('modality_mutable', language);
    }
  }

  /// Alias for localizedName - consistent naming
  String getLocalizedName(AppLanguage language) => localizedName(language);

  String get symbol {
    switch (this) {
      case Modality.cardinal:
        return '⟁';
      case Modality.fixed:
        return '◇';
      case Modality.mutable:
        return '☆';
    }
  }

  String get description {
    switch (this) {
      case Modality.cardinal:
        return 'Initiators and leaders';
      case Modality.fixed:
        return 'Stabilizers and persisters';
      case Modality.mutable:
        return 'Adaptors and transformers';
    }
  }
}
