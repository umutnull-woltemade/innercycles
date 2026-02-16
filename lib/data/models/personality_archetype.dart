import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../services/localization_service.dart';
import '../services/l10n_service.dart';
import '../providers/app_providers.dart';

/// Personality element archetypes used for dream interpretation and reflection
enum Element { fire, earth, air, water }


/// Personality archetype signs derived from birth date
/// Used internally for personalized dream interpretation and journaling themes
enum PersonalityArchetype {
  pioneer,
  builder,
  communicator,
  nurturer,
  performer,
  analyst,
  harmonizer,
  transformer,
  explorer,
  achiever,
  visionary,
  dreamer,
}

extension PersonalityArchetypeExtension on PersonalityArchetype {
  String get name {
    switch (this) {
      case PersonalityArchetype.pioneer:
        return 'The Pioneer';
      case PersonalityArchetype.builder:
        return 'The Builder';
      case PersonalityArchetype.communicator:
        return 'The Communicator';
      case PersonalityArchetype.nurturer:
        return 'The Nurturer';
      case PersonalityArchetype.performer:
        return 'The Performer';
      case PersonalityArchetype.analyst:
        return 'The Analyst';
      case PersonalityArchetype.harmonizer:
        return 'The Harmonizer';
      case PersonalityArchetype.transformer:
        return 'The Transformer';
      case PersonalityArchetype.explorer:
        return 'The Explorer';
      case PersonalityArchetype.achiever:
        return 'The Achiever';
      case PersonalityArchetype.visionary:
        return 'The Visionary';
      case PersonalityArchetype.dreamer:
        return 'The Dreamer';
    }
  }

  String get nameTr {
    switch (this) {
      case PersonalityArchetype.pioneer:
        return 'Öncü';
      case PersonalityArchetype.builder:
        return 'Kurucu';
      case PersonalityArchetype.communicator:
        return 'İletişimci';
      case PersonalityArchetype.nurturer:
        return 'Koruyucu';
      case PersonalityArchetype.performer:
        return 'Sahne Yıldızı';
      case PersonalityArchetype.analyst:
        return 'Analist';
      case PersonalityArchetype.harmonizer:
        return 'Dengeleyici';
      case PersonalityArchetype.transformer:
        return 'Dönüştürücü';
      case PersonalityArchetype.explorer:
        return 'Kaşif';
      case PersonalityArchetype.achiever:
        return 'Başarıcı';
      case PersonalityArchetype.visionary:
        return 'Vizyoner';
      case PersonalityArchetype.dreamer:
        return 'Hayalci';
    }
  }

  /// Get localized name based on app language
  /// Uses strict isolation L10nService for supported languages (EN/TR/DE/FR)
  /// Falls back to old L10n for other languages
  String localizedName(AppLanguage language) {
    final key = toString().split('.').last; // 'pioneer', 'builder', etc.
    return L10nService.get('archetype.$key', language);
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
      case PersonalityArchetype.pioneer:
        return [
          'Warrior Spirit',
          'Fire Energy',
          'Pioneer Force',
          'Instant Action',
        ];
      case PersonalityArchetype.builder:
        return [
          'Earth Wisdom',
          'Stone Patience',
          'Loyal Heart',
          'Mountain Resolve',
        ];
      case PersonalityArchetype.communicator:
        return [
          'Wind Intelligence',
          'Curious Light',
          'Word Magic',
          'Flying Thought',
        ];
      case PersonalityArchetype.nurturer:
        return [
          'Mother Energy',
          'Deep Intuition',
          'Protective Shell',
          'Tidal Emotion',
        ];
      case PersonalityArchetype.performer:
        return [
          'Radiant Heart',
          'Creative Fire',
          'Natural Presence',
          'Stage Spirit',
        ];
      case PersonalityArchetype.analyst:
        return [
          'Detail Eye',
          'Earth Practice',
          'Service Spirit',
          'Perfect Quest',
        ];
      case PersonalityArchetype.harmonizer:
        return [
          'Balance Master',
          'Justice Scales',
          'Natural Charm',
          'Weighing Heart',
        ];
      case PersonalityArchetype.transformer:
        return [
          'Transform Power',
          'Depth Knowledge',
          'Inner Courage',
          'Mystery Veil',
        ];
      case PersonalityArchetype.explorer:
        return [
          'Archer Vision',
          'Adventure Fire',
          'Truth Arrow',
          'Free Spirit',
        ];
      case PersonalityArchetype.achiever:
        return [
          'Summit Drive',
          'Steady Discipline',
          'Mountain Patience',
          'Stone Wall',
        ];
      case PersonalityArchetype.visionary:
        return [
          'Revolutionary Mind',
          'Creative Spark',
          'Free Mind',
          'Distant Gaze',
        ];
      case PersonalityArchetype.dreamer:
        return [
          'Ocean Heart',
          'Vivid Dream',
          'Mystic Intuition',
          'Boundless Imagination',
        ];
    }
  }

  String get symbol {
    switch (this) {
      case PersonalityArchetype.pioneer:
        return '🚀';
      case PersonalityArchetype.builder:
        return '🏗️';
      case PersonalityArchetype.communicator:
        return '💬';
      case PersonalityArchetype.nurturer:
        return '🤗';
      case PersonalityArchetype.performer:
        return '🎭';
      case PersonalityArchetype.analyst:
        return '🔍';
      case PersonalityArchetype.harmonizer:
        return '⚖️';
      case PersonalityArchetype.transformer:
        return '🦋';
      case PersonalityArchetype.explorer:
        return '🧭';
      case PersonalityArchetype.achiever:
        return '🏔️';
      case PersonalityArchetype.visionary:
        return '💡';
      case PersonalityArchetype.dreamer:
        return '🌊';
    }
  }


  Element get element {
    switch (this) {
      case PersonalityArchetype.pioneer:
      case PersonalityArchetype.performer:
      case PersonalityArchetype.explorer:
        return Element.fire;
      case PersonalityArchetype.builder:
      case PersonalityArchetype.analyst:
      case PersonalityArchetype.achiever:
        return Element.earth;
      case PersonalityArchetype.communicator:
      case PersonalityArchetype.harmonizer:
      case PersonalityArchetype.visionary:
        return Element.air;
      case PersonalityArchetype.nurturer:
      case PersonalityArchetype.transformer:
      case PersonalityArchetype.dreamer:
        return Element.water;
    }
  }


  Color get color {
    switch (element) {
      case Element.fire:
        return AppColors.warmAccent;
      case Element.earth:
        return AppColors.greenAccent;
      case Element.air:
        return AppColors.blueAccent;
      case Element.water:
        return AppColors.purpleAccent;
    }
  }


  List<String> get traits {
    switch (this) {
      case PersonalityArchetype.pioneer:
        return ['Savaşçı Ruh', 'Ateş Enerjisi', 'Öncü Güç', 'Anlık Aksiyon'];
      case PersonalityArchetype.builder:
        return [
          'Toprak Bilgeliği',
          'Sabır Taşı',
          'Sadık Kalp',
          'Dağ Kararlılığı',
        ];
      case PersonalityArchetype.communicator:
        return ['Rüzgar Zekası', 'Merak Işığı', 'Söz Büyüsü', 'Uçan Düşünce'];
      case PersonalityArchetype.nurturer:
        return [
          'Anne Enerjisi',
          'Derin Sezgi',
          'Koruyucu Kabuk',
          'Gelgit Duygusu',
        ];
      case PersonalityArchetype.performer:
        return [
          'Parlak Kalp',
          'Yaratıcı Ateş',
          'Doğal Karizma',
          'Sahne Ruhu',
        ];
      case PersonalityArchetype.analyst:
        return [
          'Detay Gözü',
          'Toprak Pratiği',
          'Hizmet Ruhu',
          'Mükemmel Arayış',
        ];
      case PersonalityArchetype.harmonizer:
        return [
          'Denge Ustası',
          'Adalet Terazisi',
          'Doğal Cazibe',
          'Tartı Ruhu',
        ];
      case PersonalityArchetype.transformer:
        return [
          'Dönüşüm Gücü',
          'Derinlik Bilgisi',
          'İç Cesaret',
          'Gizem Perdesi',
        ];
      case PersonalityArchetype.explorer:
        return ['Okçu Vizyonu', 'Macera Ateşi', 'Hakikat Oku', 'Özgür Ruh'];
      case PersonalityArchetype.achiever:
        return [
          'Zirve Azmi',
          'Kararlı Disiplin',
          'Dağ Sabrı',
          'Taş Duvar',
        ];
      case PersonalityArchetype.visionary:
        return [
          'Devrimci Ruh',
          'Yaratıcı Kıvılcım',
          'Özgür Zihin',
          'Uzak Bakış',
        ];
      case PersonalityArchetype.dreamer:
        return [
          'Okyanus Kalbi',
          'Canlı Rüya',
          'Mistik Sezgi',
          'Sınırsız Hayal',
        ];
    }
  }

  String get description {
    switch (this) {
      case PersonalityArchetype.pioneer:
        return 'The Pioneer charges forward with unstoppable energy and courage, embodying new beginnings and bold initiatives.';
      case PersonalityArchetype.builder:
        return 'The Builder grounds us with stability and appreciation for beauty, seeking security and finding joy in life\'s tangible comforts.';
      case PersonalityArchetype.communicator:
        return 'The Communicator dances between ideas with a quicksilver mind, bringing curiosity and adaptability to every situation.';
      case PersonalityArchetype.nurturer:
        return 'The Nurturer protects with fierce love and emotional depth, creating sanctuary and meaningful connections wherever they go.';
      case PersonalityArchetype.performer:
        return 'The Performer leads with creative fire and generous spirit, inspiring others through authentic self-expression.';
      case PersonalityArchetype.analyst:
        return 'The Analyst observes with precision and serves with devotion, bringing a keen eye for detail and order to any situation.';
      case PersonalityArchetype.harmonizer:
        return 'The Harmonizer seeks beauty and balance in all things, weighing every option to find fairness and equilibrium.';
      case PersonalityArchetype.transformer:
        return 'The Transformer delves into depths others fear to explore, growing through intensity and emerging renewed.';
      case PersonalityArchetype.explorer:
        return 'The Explorer aims for distant horizons with optimistic spirit, seeking truth through adventure and philosophical inquiry.';
      case PersonalityArchetype.achiever:
        return 'The Achiever climbs steadily toward ambitious heights, building lasting structures through discipline and patience.';
      case PersonalityArchetype.visionary:
        return 'The Visionary pours forth innovation for humanity, envisioning a better future through progressive ideals.';
      case PersonalityArchetype.dreamer:
        return 'The Dreamer navigates deep waters of imagination, dissolving boundaries and connecting us to deeper consciousness.';
    }
  }

  /// Detaylı Türkçe açıklama (10+ cümle)
  String get detailedDescriptionTr {
    switch (this) {
      case PersonalityArchetype.pioneer:
        return '''Öncü kişilik arketipi, yeni başlangıçların ve cesaretin temsilcisidir. Güçlü bir harekete geçirici enerjiye sahip olan bu kişilik profili, liderlik özellikleri ve girişimci ruhuyla tanınır. Öncü kişilikler doğal yol açıcılardır; bilinmeyene atılmaktan çekinmez ve risk almaktan korkmazlar. Enerjileri genellikle yüksek, tepkileri hızlı olma eğilimindedir. Rekabetçi yapıları onları sporda ve iş hayatında öne çıkarabilir. Sabırsız olabilirler ancak bu özellik onları harekete geçiren bir iç motivasyon kaynağı gibidir. İlişkilerde tutkulu ve doğrudan olma eğilimindedirler; oyun oynamayı pek sevmezler. Öfkeleri çabuk parlayabilir ama genellikle aynı hızla söner. Bağımsızlıklarına düşkündürler ve kontrol edilmekten hoşlanmazlar. Öncü enerjisi, hayatımızda cesarete ihtiyaç duyduğumuz alanlarda bize ilham verebilir.''';
      case PersonalityArchetype.builder:
        return '''İnşaatçı kişilik arketipi, en kararlı ve dayanıklı profillerden biridir. Güçlü bir estetik duyarlılığa sahip olan bu kişilik profili, güzellik, konfor ve maddi güvenliğe değer verme eğilimindedir. İnşaatçı kişilikler güvenilir ve sadık olma eğilimindedirler; verdikleri sözü tutarlar. Sabırları dikkat çekicidir ancak sınırları zorlandığında inatçı ve kararlı olabilirler. Duyusal deneyimlere açıktırlar; yemek, müzik ve dokunsal deneyimlerden büyük zevk alabilirler. Değişime direnç gösterebilirler çünkü güvenlik onlar için önemli bir değerdir. İlişkilerde bağlılık ve istikrar arama eğilimindedirler; yüzeysel ilişkilerden hoşlanmazlar. Maddi konularda pratik ve tutumlu olabilirler. Doğayla derin bir bağ kurma eğilimindedirler; bahçecilik ve toprakla uğraşmak onlara huzur verebilir. İnşaatçı enerjisi, hayatımızda sağlam temeller atmamız gerektiğinde devreye girebilir.''';
      case PersonalityArchetype.communicator:
        return '''İletişimci kişilik arketipi, en meraklı ve çok yönlü profillerden biridir. Güçlü bir zihinsel çevikliğe sahip olan bu kişilik profili, iletişim ve zeka ile özdeşleşmiştir. İletişimci kişilikler doğal sohbet ustalarıdır; her konuda konuşabilir ve her ortama uyum sağlayabilirler. Çok yönlü doğaları onları karmaşık ve öngörülmez kılabilir. Sıkılmaktan hoşlanmazlar ve sürekli zihinsel uyarı arama eğilimindedirler. Hızlı düşünür, hızlı konuşur ve hızlı hareket ederler. Çok fazla projeye aynı anda başlayıp bitirmekte zorlanabilirler. Sosyal ortamlarda rahat hissederler; genellikle geniş bir sosyal çevreleri vardır. İlişkilerde zihinsel uyum onlar için fiziksel çekimden daha önemli olabilir. Mizah anlayışları keskindir ve esprili sohbetlerden büyük keyif alabilirler. İletişimci enerjisi, yeni fikirlere ve perspektiflere açık olmamızı destekleyebilir.''';
      case PersonalityArchetype.nurturer:
        return '''Bakıcı kişilik arketipi, en duygusal ve koruyucu profillerden biridir. Güçlü bir duygusal zekaya sahip olan bu kişilik profili, aile, yuva ve duygusal güvenlikle ilişkilendirilir. Bakıcı kişilikler son derece sezgisel ve empatik olma eğilimindedirler; başkalarının duygularını kolayca algılayabilirler. Koruyucu dış görünümleri altında hassas bir iç dünya yatabilir. Ailelerine ve sevdiklerine derinden bağlı olma eğilimindedirler. Geçmişe nostaljik bir bağlılıkları olabilir; anıları ve aile geleneklerini önemserler. Ruh halleri döngüsel olarak değişkenlik gösterebilir. Evlerini bir sığınak olarak görür ve yaşam alanlarına önem verme eğilimindedirler. İlişkilerde derin duygusal bağ kurarlar ve sadakat bekleyebilirler. Sezgileri genellikle güçlüdür; olası sorunları önceden hissedebilirler. Bakıcı enerjisi, başkalarını beslememiz ve korumamız gerektiğinde ortaya çıkabilir.''';
      case PersonalityArchetype.performer:
        return '''Sahne Sanatçısı kişilik arketipi, en gösterişli ve cömert profillerden biridir. Güçlü bir öz ifade dürtüsüne sahip olan bu kişilik profili, yaratıcılık, liderlik ve kendini ifade etme ile özdeşleşmiştir. Sahne Sanatçısı kişilikler doğal karizmatik bireylerdir; ilgi odağı olmayı ve takdir edilmeyi severler. Cömertlikleri dikkat çekicidir; sevdikleri için büyük fedakarlıklar yapabilirler. Gurur onların hem güçlü hem de hassas noktası olabilir. Liderlik pozisyonlarına doğal olarak yükselme eğilimindedirler. Yaratıcı enerjileri yüksektir; sanat, tiyatro ve performans alanlarında parlayabilirler. Sadakatleri sarsılmaz olma eğilimindedir; arkadaşlıklarını ve ilişkilerini ciddiye alırlar. İlişkilerde romantik jestleri sever ve bekleyebilirler. Eleştiriye karşı hassas olabilirler; benlik değeri onlar için önemlidir. Sahne Sanatçısı enerjisi, kendimizi özgürce ifade etmemiz gerektiğinde aktifleşebilir.''';
      case PersonalityArchetype.analyst:
        return '''Analist kişilik arketipi, en analitik ve mükemmeliyetçi profillerden biridir. Güçlü bir detay odaklılığa sahip olan bu kişilik profili, hizmet, sağlık ve dikkatli gözlem ile ilişkilendirilir. Analist kişilikler keskin gözlemcilerdir; en küçük detayları bile fark edebilirler. Mükemmeliyetçilikleri onları sürekli gelişmeye itebilir ancak bazen aşırı eleştirel olmalarına neden olabilir. Pratik çözümler üretmekte ustadırlar. Düzen ve temizlik onlar için önemli olma eğilimindedir; kaos onları rahatsız edebilir. Sağlık ve iyi oluş konularına büyük önem verirler. Başkalarına yardım etmekten derin bir tatmin duyabilirler. İlişkilerde sadık ve özenli olma eğilimindedirler; küçük jestler büyük jestlerden daha çok önem taşıyabilir onlar için. Endişeye yatkın olabilirler; zihinleri sürekli analiz modunda çalışma eğilimindedir. Analist enerjisi, hayatımızda düzen ve iyileştirme gerektiğinde devreye girebilir.''';
      case PersonalityArchetype.harmonizer:
        return '''Uyumlaştırıcı kişilik arketipi, en diplomatik ve estetik profillerden biridir. Güçlü bir ilişki odaklılığa sahip olan bu kişilik profili, denge, uyum ve kişilerarası ilişkilerle özdeşleşmiştir. Uyumlaştırıcı kişilikler doğal arabuluculardır; çatışmalardan kaçınır ve barış yaratmaya çalışma eğilimindedirler. Adalete derinden bağlı olabilirler; haksızlığa tahammül etmekte zorlanırlar. Güzellik ve estetik onlar için temel bir ihtiyaç olabilir. Kararsız olabilirler çünkü her durumun her iki tarafını da görme kapasitesine sahiptirler. Sosyal yetenekleri genellikle güçlüdür; her ortamda zarif ve çekici olabilirler. İlişkilere büyük önem verme eğilimindedirler; yalnızlıktan pek hoşlanmazlar. Romantik doğaları belirgindir; yakın ilişkilerine büyük yatırım yapabilirler. İşbirliği onların güçlü yönüdür; takım çalışmasında parlayabilirler. Uyumlaştırıcı enerjisi, hayatımızda denge ve uyum aradığımızda ortaya çıkabilir.''';
      case PersonalityArchetype.transformer:
        return '''Dönüştürücü kişilik arketipi, en yoğun ve değişim odaklı profillerden biridir. Güçlü bir iç motivasyona ve kararlılığa sahip olan bu kişilik profili, tutku, güç ve yenilenme ile ilişkilendirilir. Dönüştürücü kişilikler son derece kararlı ve odaklı olma eğilimindedirler; bir hedef belirlediklerinde genellikle hiçbir şey onları durduramaz. Sezgileri oldukça güçlüdür; insanların gerçek niyetlerini okuyabilirler. Gizlilik onlar için önemlidir; özel hayatlarını koruma eğilimindedirler. Duygusal derinlikleri dikkat çekicidir; yüzeysel ilişkilerden hoşlanmazlar. Sadakat ve güven konularında son derece hassas olabilirler. Geçmiş deneyimleri uzun süre hatırlama eğilimindedirler; bırakmak onlar için zor olabilir. Dönüşüm onların doğasında vardır; zorlu dönemlerden daha güçlü çıkabilirler. İlişkilerde tutkulu ve yoğun olma eğilimindedirler; tamamıyla bağlanırlar veya hiç bağlanmazlar. Dönüştürücü enerjisi, derin kişisel dönüşüm ve yenilenme zamanlarında aktifleşebilir.''';
      case PersonalityArchetype.explorer:
        return '''Kaşif kişilik arketipi, en iyimser ve maceracı profillerden biridir. Güçlü bir büyüme ve genişleme dürtüsüne sahip olan bu kişilik profili, özgürlük, felsefe ve keşifle özdeşleşmiştir. Kaşif kişilikler doğal filozoflardır; hayatın anlamını ve büyük soruları sorgulama eğilimindedirler. Seyahat ve macera onların tutkusu olabilir; farklı kültürleri tanımaktan büyük zevk alabilirler. İyimserlikleri genellikle bulaşıcıdır; etraflarına pozitif bir enerji yayma eğilimindedirler. Dürüstlükleri bazen keskin olabilir; akıllarından geçeni söyleme eğilimindedirler. Özgürlüklerine son derece düşkündürler; kısıtlanmaktan kaçınabilirler. Mizah anlayışları gelişmiştir; güldürmekten hoşlanırlar. Aşırı iyimser olmaları bazen gerçeklikten kopmalarına neden olabilir. Eğitim ve öğrenme onlar için yaşam boyu süren bir tutku olma eğilimindedir. Kaşif enerjisi, ufkumuzu genişletmemiz ve yeni perspektifler edinmemiz gerektiğinde devreye girebilir.''';
      case PersonalityArchetype.achiever:
        return '''Mimar kişilik arketipi, en hırslı ve disiplinli profillerden biridir. Güçlü bir sorumluluk duygusu ve yapılandırma yeteneğine sahip olan bu kişilik profili, başarı, sorumluluk ve geleneklerle ilişkilendirilir. Mimar kişilikler uzun vadeli düşünme eğilimindedirler; anlık tatminler yerine kalıcı başarıları tercih ederler. Çalışkanlıkları dikkat çekicidir; hedeflerine ulaşmak için büyük fedakarlıklar yapabilirler. Sorumluluk duyguları güçlüdür; verdikleri sözleri tutma eğilimindedirler. Geleneklere ve yapılandırılmış düzene saygı duyabilirler. Duygularını göstermekte zorlanabilirler; dışarıdan mesafeli görünebilirler. Maddi güvenlik onlar için genellikle son derece önemlidir. İlişkilerde sadık ve koruyucu olma eğilimindedirler; ailelerini her şeyin üstünde tutabilirler. Yaşlandıkça daha rahat ve neşeli olma eğilimi gösterebilirler; zamanla içsel bir özgürleşme yaşarlar. Mimar enerjisi, hayatımızda disiplin ve kararlılık gerektiren dönemlerde ortaya çıkabilir.''';
      case PersonalityArchetype.visionary:
        return '''Vizyoner kişilik arketipi, en özgün ve ileri görüşlü profillerden biridir. Güçlü bir yenilikçi dürtüye ve bağımsız düşünce yapısına sahip olan bu kişilik profili, yenilik, insanlık ve özgürlükle özdeşleşmiştir. Vizyoner kişilikler zamanlarının ötesinde düşünme eğilimindedirler; geleceği bugünden görebilirler. Bireyselliklerine son derece düşkündürler; kalabalığı takip etmezler. İnsani değerlere derinden bağlı olabilirler; sosyal adalet konularında aktif olma eğilimindedirler. Entelektüel bağımsızlıkları güçlüdür; kendi fikirlerini oluşturma eğilimindedirler. Duygusal mesafe koyabilirler; yakınlık bazen onları rahatsız edebilir. Arkadaşlıklara büyük değer verirler; genellikle geniş bir sosyal ağları vardır. Sıra dışı ve alışılmadık olabilirler; sıradanlıktan hoşlanmazlar. Teknoloji ve bilimle doğal bir yakınlıkları olabilir. İlişkilerde özgürlük ve entelektüel uyum arama eğilimindedirler. Vizyoner enerjisi, kalıpları kırmamız ve yenilik yapmamız gerektiğinde aktifleşebilir.''';
      case PersonalityArchetype.dreamer:
        return '''Hayalperest kişilik arketipi, en derin hisseden ve empatik profillerden biridir. Güçlü bir hayal gücü ve sezgisel kapasiteye sahip olan bu kişilik profili, yaratıcılık, şefkat ve içsel dünyayla özdeşleşmiştir. Hayalperest kişilikler son derece sezgisel olma eğilimindedirler; görünmeyeni hissedebilirler. Empati kapasiteleri olağanüstüdür; başkalarının acısını kendi acıları gibi hissedebilirler. Sanatsal yetenekleri güçlü olabilir; müzik, resim ve şiirde parlayabilirler. Gerçeklik ile hayal arasındaki sınır onlar için bazen bulanıklaşabilir. İçe çekilme eğilimleri olabilir; zorlu durumlardan kendilerini korumak için sığınak arayabilirler. Fedakar doğaları bazen kendilerini ihmal etmelerine neden olabilir. İç dünyalarına ve manevi konulara doğal bir ilgileri olabilir. İlişkilerde romantik ve idealist olma eğilimindedirler; sevgiyi yüceltebilirler. Kişisel sınırları belirsiz olabilir; nerede bittiklerini ve başkalarının nerede başladığını ayırt etmekte zorlanabilirler. Hayalperest enerjisi, şifa, yaratıcılık ve derin içsel bağlantı zamanlarında devreye girebilir.''';
    }
  }

  static PersonalityArchetype fromDate(DateTime date) {
    final month = date.month;
    final day = date.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return PersonalityArchetype.pioneer;
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return PersonalityArchetype.builder;
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return PersonalityArchetype.communicator;
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return PersonalityArchetype.nurturer;
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return PersonalityArchetype.performer;
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return PersonalityArchetype.analyst;
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return PersonalityArchetype.harmonizer;
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return PersonalityArchetype.transformer;
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return PersonalityArchetype.explorer;
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return PersonalityArchetype.achiever;
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return PersonalityArchetype.visionary;
    } else {
      return PersonalityArchetype.dreamer;
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
        return AppColors.warmAccent;
      case Element.earth:
        return AppColors.greenAccent;
      case Element.air:
        return AppColors.blueAccent;
      case Element.water:
        return AppColors.purpleAccent;
    }
  }
}

