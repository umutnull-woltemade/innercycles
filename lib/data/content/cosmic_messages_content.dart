/// Daily reflection themes and mindfulness prompts
/// Content designed for personal reflection and self-awareness
class CosmicMessagesContent {
  CosmicMessagesContent._();

  /// Disclaimer for all content
  static const String contentDisclaimer =
      'This content is for reflection and self-awareness only. It does not predict events or outcomes.';

  /// Helper to compute a deterministic index from a date
  static int _dateIndex(DateTime date, int listLength) {
    return (date.day + date.month * 31) % listLength;
  }

  /// Get a daily reflection message based on date
  static String getDailyCosmicMessage(DateTime date) {
    return _allCosmicMessages[_dateIndex(date, _allCosmicMessages.length)];
  }

  /// Get a random universal reflection theme
  static String getUniversalMessage({DateTime? date}) {
    final d = date ?? DateTime.now();
    final dayOfYear =
        d.difference(DateTime(d.year, 1, 1)).inDays;
    return _universalMessages[dayOfYear % _universalMessages.length];
  }

  /// Get morning reflection prompt based on date
  static String getMorningAffirmation(DateTime date) {
    return _allMorningAffirmations[
        _dateIndex(date, _allMorningAffirmations.length)];
  }

  /// Get evening reflection prompt based on date
  static String getEveningReflection(DateTime date) {
    return _allEveningReflections[
        _dateIndex(date, _allEveningReflections.length)];
  }

  /// Get reflection theme based on moon phase (cultural symbolism)
  static String getMoonPhaseInsight(String moonPhase) {
    return _moonPhaseInsights[moonPhase] ??
        _moonPhaseInsights['waxing_crescent']!;
  }

  /// Get daily intention suggestion based on date
  static String getDailyIntention(DateTime date) {
    return _allDailyIntentions[_dateIndex(date, _allDailyIntentions.length)];
  }

  /// Get extended reflection wisdom for deeper readings
  static String getExtendedCosmicWisdom(DateTime date) {
    return _allExtendedCosmicWisdoms[
        _dateIndex(date, _allExtendedCosmicWisdoms.length)];
  }

  /// Get archetype-specific daily intention (e.g., 'pioneer', 'builder')
  /// Falls back to universal intentions if archetype not found
  static String getArchetypeIntention(String archetype, {DateTime? date}) {
    final d = date ?? DateTime.now();
    final archetypeList = _dailyIntentions[archetype.toLowerCase()];

    if (archetypeList != null && archetypeList.isNotEmpty) {
      return archetypeList[_dateIndex(d, archetypeList.length)];
    }

    // Fallback to universal intentions
    return _universalIntentions[_dateIndex(d, _universalIntentions.length)];
  }

  /// Get archetype-specific extended wisdom (e.g., 'pioneer', 'builder')
  /// Falls back to universal extended wisdoms if archetype not found
  static String getArchetypeWisdom(String archetype, {DateTime? date}) {
    final d = date ?? DateTime.now();
    final archetypeList = _extendedCosmicWisdoms[archetype.toLowerCase()];

    if (archetypeList != null && archetypeList.isNotEmpty) {
      return archetypeList[_dateIndex(d, archetypeList.length)];
    }

    // Fallback to universal extended wisdoms
    return _universalExtendedWisdoms[_dateIndex(d, _universalExtendedWisdoms.length)];
  }

  // ---------------------------------------------------------------------------
  // Content lists
  // ---------------------------------------------------------------------------

  /// Universal reflection themes - applicable to all
  static final List<String> _universalMessages = [
    'Bu an için bir nefes al. Şu anki haline nazik bir bakış atabilirsin.',
    'Bugün kendine nasıl davrandığını fark etmek isteyebilirsin. Şefkatli bir yaklaşım düşünülebilir.',
    'İç dünyana dönmek için güzel bir zaman olabilir. Kalbinin sana ne söylediğini dinleyebilirsin.',
    'Akışta olmak nasıl bir his? Bu soru üzerine düşünmek isteyebilirsin.',
    'Kendinle ilgili bugün takdir edebileceğin bir şey var mı?',
    'Doğayla bağlantı kurmak için bir fırsat arayabilirsin.',
    'Birlik ve bağlantı hissi üzerine düşünmek isteyebilirsin.',
    'Yeni bir şey denemek için kendine alan tanıyabilirsin.',
    'Yaratıcı enerjini keşfetmek için bir davet olarak düşünebilirsin.',
    'Güven duygusu üzerine düşünmek faydalı olabilir.',
    'İç sesine kulak vermek isteyebilirsin.',
    'İçindeki güç hakkında düşünmek anlamlı olabilir.',
    'Ritim ve denge üzerine bir refleksiyon zamanı olabilir.',
    'Potansiyelini keşfetmek için merakla yaklaşabilirsin.',
    'Bugün nelere dikkat çekmek istiyorsun?',
    'Sezgilerine güvenmek nasıl hissettiriyor?',
    'Sessizlikte ne buluyorsun? Bu soru üzerine düşünebilirsin.',
    'Değişim ve dönüşüm temaları üzerine düşünmek isteyebilirsin.',
    'Bolluk kavramı senin için ne anlama geliyor?',
    'Bugün için bir farkındalık pratiği düşünebilirsin.',
    'Sevgi ve bağlantı üzerine düşünmek anlamlı olabilir.',
    'İç dünyanın derinliklerini keşfetmek isteyebilirsin.',
    'Neşe ve hafiflik temaları üzerine bir refleksiyon.',
    'Kendini hatırlamak için bir an ayırabilirsin.',
    'En iyi halin nasıl görünüyor? Bu soru üzerine düşünebilirsin.',
    'Sabır ve zamanlama üzerine düşünmek faydalı olabilir.',
    'İçindeki ışık hakkında düşünmek isteyebilirsin.',
    'Bağlantı ve topluluk hissi üzerine bir refleksiyon.',
    'Kendini ifade etmek için bir alan yaratabilirsin.',
    'Dönüşüm ve yenilenme temaları üzerine düşünebilirsin.',
  ];

  /// All daily cosmic messages (flattened from archetype-specific content)
  static final List<String> _allCosmicMessages = [
    'Ateş arketipi, cesaret ve inisiyatif temalarını simgeler. Bu özellikler üzerine düşünmek isteyebilirsin.',
    'Öncü olmak ne anlama geliyor? Bu soru üzerine bir refleksiyon yapabilirsin.',
    'Yeni başlangıçlar teması üzerine düşünmek anlamlı olabilir.',
    'Cesaret ve korku arasındaki denge üzerine düşünebilirsin.',
    'İçindeki güç hakkında ne fark ediyorsun?',
    'Liderlik ve ilham verme temaları üzerine bir refleksiyon.',
    'Engeller karşısında tutumun hakkında düşünmek isteyebilirsin.',
    'Toprak arketipi, istikrar ve değer temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Güzellik ve duyusal deneyimler hayatında nasıl yer alıyor?',
    'Sabır teması üzerine bir refleksiyon anlamlı olabilir.',
    'Bolluk kavramı senin için ne ifade ediyor?',
    'Fiziksel dünya ile bağlantın hakkında düşünebilirsin.',
    'Öz-değer üzerine düşünmek isteyebilirsin.',
    'Doğa ile bağlantı kurmak için bir davet olarak düşünebilirsin.',
    'Hava arketipi, iletişim ve bağlantı temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Merak ve öğrenme hayatında nasıl yer alıyor?',
    'Sorular sormak üzerine bir refleksiyon yapabilirsin.',
    'Bağlantılar ve iletişim temaları üzerine düşünmek isteyebilirsin.',
    'Zihinsel çeviklik hakkında ne fark ediyorsun?',
    'Çok yönlülük teması üzerine düşünebilirsin.',
    'Hafiflik ve esneklik üzerine bir refleksiyon.',
    'Su arketipi, duygusal derinlik ve şefkat temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Yuva ve aidiyet hissi senin için ne anlama geliyor?',
    'Sezgilerine güvenmek üzerine bir refleksiyon yapabilirsin.',
    'Duygusal iyileşme temaları üzerine düşünmek isteyebilirsin.',
    'Besleyici enerji hakkında ne fark ediyorsun?',
    'Savunmasızlık ve güç arasındaki ilişki üzerine düşünebilirsin.',
    'Döngüler ve değişim üzerine bir refleksiyon.',
    'Ateş arketipi, yaratıcılık ve kendini ifade etme temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Otantik olmak senin için ne anlama geliyor?',
    'Yaratıcı ifade üzerine bir refleksiyon yapabilirsin.',
    'Görünür olmak temaları üzerine düşünmek isteyebilirsin.',
    'Cömertlik hakkında ne fark ediyorsun?',
    'Kendini sevmek üzerine düşünebilirsin.',
    'Işık ve parlaklık metaforu üzerine bir refleksiyon.',
    'Toprak arketipi, detay ve hizmet temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Şifa ve iyileştirme senin için ne anlama geliyor?',
    'Analiz ve anlama üzerine bir refleksiyon yapabilirsin.',
    'Düzen ve sistem temaları üzerine düşünmek isteyebilirsin.',
    'İlerleme ve mükemmellik arasındaki denge hakkında ne fark ediyorsun?',
    'Hizmet etmek üzerine düşünebilirsin.',
    'Pratiklik ve gerçekçilik üzerine bir refleksiyon.',
    'Hava arketipi, denge ve uyum temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Güzellik ve estetik hayatında nasıl yer alıyor?',
    'İlişkilerde denge üzerine bir refleksiyon yapabilirsin.',
    'Estetik duyarlılık temaları üzerine düşünmek isteyebilirsin.',
    'Adalet hakkında ne düşünüyorsun?',
    'Partnerlik ve iş birliği üzerine düşünebilirsin.',
    'Perspektif kazanmak üzerine bir refleksiyon.',
    'Su arketipi, dönüşüm ve derinlik temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Dönüşüm senin için ne anlama geliyor?',
    'Derinlik ve yoğunluk üzerine bir refleksiyon yapabilirsin.',
    'Tutku temaları üzerine düşünmek isteyebilirsin.',
    'Yeniden doğuş metaforu hakkında ne düşünüyorsun?',
    'Gizem ve keşif üzerine düşünebilirsin.',
    'Derinlik ve sonsuzluk üzerine bir refleksiyon.',
    'Ateş arketipi, keşif ve anlam arayışı temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Macera ve keşif senin için ne anlama geliyor?',
    'Büyüme ve öğrenme üzerine bir refleksiyon yapabilirsin.',
    'Felsefi sorular üzerine düşünmek isteyebilirsin.',
    'Özgürlük hakkında ne hissediyorsun?',
    'İyimserlik üzerine düşünebilirsin.',
    'Keşif ve ilerleme üzerine bir refleksiyon.',
    'Toprak arketipi, hedefler ve yapı temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Disiplin ve kararlılık senin için ne anlama geliyor?',
    'Uzun vadeli hedefler üzerine bir refleksiyon yapabilirsin.',
    'Sorumluluk temaları üzerine düşünmek isteyebilirsin.',
    'Pratiklik hakkında ne düşünüyorsun?',
    'Kariyer ve amaç üzerine düşünebilirsin.',
    'Sağlam temeller üzerine bir refleksiyon.',
    'Hava arketipi, yenilik ve topluluk temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Benzersizlik senin için ne anlama geliyor?',
    'Topluluk ve bağlantı üzerine bir refleksiyon yapabilirsin.',
    'Yenilikçi düşünme temaları üzerine düşünmek isteyebilirsin.',
    'Teknoloji ve ilerleme hakkında ne düşünüyorsun?',
    'Özgürlük ve bağımsızlık üzerine düşünebilirsin.',
    'Gelecek vizyonu üzerine bir refleksiyon.',
    'Su arketipi, hayal gücü ve sezgi temalarını simgeler. Bu alanlar üzerine düşünebilirsin.',
    'Rüyalar ve hayal gücü hayatında nasıl yer alıyor?',
    'Sezgisel bilgi üzerine bir refleksiyon yapabilirsin.',
    'Empati temaları üzerine düşünmek isteyebilirsin.',
    'Yaratıcılık hakkında ne fark ediyorsun?',
    'Akış ve teslimiyet üzerine düşünebilirsin.',
    'Şefkat ve merhamet üzerine bir refleksiyon.',
    'Bu an için bir nefes al. Şu anki haline nazik bir bakış atabilirsin.',
    'Bugün kendine nasıl davrandığını fark etmek isteyebilirsin. Şefkatli bir yaklaşım düşünülebilir.',
    'İç dünyana dönmek için güzel bir zaman olabilir. Kalbinin sana ne söylediğini dinleyebilirsin.',
    'Akışta olmak nasıl bir his? Bu soru üzerine düşünmek isteyebilirsin.',
    'Kendinle ilgili bugün takdir edebileceğin bir şey var mı?',
    'Doğayla bağlantı kurmak için bir fırsat arayabilirsin.',
    'Birlik ve bağlantı hissi üzerine düşünmek isteyebilirsin.',
    'Yeni bir şey denemek için kendine alan tanıyabilirsin.',
    'Yaratıcı enerjini keşfetmek için bir davet olarak düşünebilirsin.',
    'Güven duygusu üzerine düşünmek faydalı olabilir.',
    'İç sesine kulak vermek isteyebilirsin.',
    'İçindeki güç hakkında düşünmek anlamlı olabilir.',
    'Ritim ve denge üzerine bir refleksiyon zamanı olabilir.',
    'Potansiyelini keşfetmek için merakla yaklaşabilirsin.',
    'Bugün nelere dikkat çekmek istiyorsun?',
    'Sezgilerine güvenmek nasıl hissettiriyor?',
    'Sessizlikte ne buluyorsun? Bu soru üzerine düşünebilirsin.',
    'Değişim ve dönüşüm temaları üzerine düşünmek isteyebilirsin.',
    'Bolluk kavramı senin için ne anlama geliyor?',
    'Bugün için bir farkındalık pratiği düşünebilirsin.',
    'Sevgi ve bağlantı üzerine düşünmek anlamlı olabilir.',
    'İç dünyanın derinliklerini keşfetmek isteyebilirsin.',
    'Neşe ve hafiflik temaları üzerine bir refleksiyon.',
    'Kendini hatırlamak için bir an ayırabilirsin.',
    'En iyi halin nasıl görünüyor? Bu soru üzerine düşünebilirsin.',
    'Sabır ve zamanlama üzerine düşünmek faydalı olabilir.',
    'İçindeki ışık hakkında düşünmek isteyebilirsin.',
    'Bağlantı ve topluluk hissi üzerine bir refleksiyon.',
    'Kendini ifade etmek için bir alan yaratabilirsin.',
    'Dönüşüm ve yenilenme temaları üzerine düşünebilirsin.',
  ];

  /// All morning affirmations (flattened from archetype-specific content)
  static final List<String> _allMorningAffirmations = [
    'Bugün sabırla hareket etmeyi seçebilirim.',
    'Cesaretimi yapıcı yollarla kullanmayı düşünebilirim.',
    'Liderlik temaları üzerine farkındalık geliştiriyorum.',
    'Yeni başlangıçlara açık olmayı seçebilirim.',
    'Enerjimi bilinçli yönlendirmeyi deniyorum.',
    'Öncü olmak hakkında düşünüyorum.',
    'Gücümü nasıl kullandığımı fark ediyorum.',
    'Bugün bolluğa açık olmayı seçebilirim.',
    'Değerimi hatırlamayı deniyorum.',
    'Sabır üzerine düşünüyorum.',
    'Güç ve kararlılık temaları üzerine farkındalık geliştiriyorum.',
    'Hayatın tadını çıkarmayı seçebilirim.',
    'Güvenlik hissi üzerine düşünüyorum.',
    'Her anın keyfini fark etmeyi deniyorum.',
    'Zihinsel çevikliğimi fark ediyorum.',
    'İletişim üzerine bilinçli olmayı seçebilirim.',
    'Merakımı keşfediyorum.',
    'Çok yönlülüğüm üzerine düşünüyorum.',
    'Her konuşmanın değerini fark edebilirim.',
    'Fikirlerimi paylaşmayı düşünüyorum.',
    'Öğrenmeye açık olmayı seçebilirim.',
    'Bugün duygularıma alan tanımayı seçebilirim.',
    'Sezgilerime güvenmeyi deniyorum.',
    'Sevgi alıp vermeye açık olmayı düşünüyorum.',
    'İç dünyam üzerine farkındalık geliştiriyorum.',
    'Şefkati keşfediyorum.',
    'Aile ve bağlantı üzerine düşünüyorum.',
    'Duygusal zekam üzerine farkındalık geliştiriyorum.',
    'Bugün otantik olmayı seçebilirim.',
    'Yaratıcılığımı ifade etmeyi deniyorum.',
    'Görünür olmak üzerine düşünüyorum.',
    'Cömertlik temaları üzerine farkındalık geliştiriyorum.',
    'Cesaretimi keşfediyorum.',
    'İlham verme üzerine düşünüyorum.',
    'Kendimi sevmeyi hatırlıyorum.',
    'Bugün ilerlemeye odaklanmayı seçebilirim.',
    'Analitik yeteneklerimi fark ediyorum.',
    'Hizmet etmek üzerine düşünüyorum.',
    'Düzen ve organizasyon temaları üzerine farkındalık geliştiriyorum.',
    'Sağlığımı önemsiyorum.',
    'Pratik çözümler üzerine düşünüyorum.',
    'Şifa temaları üzerine farkındalık geliştiriyorum.',
    'Bugün iç dengeyi aramayı seçebilirim.',
    'İlişkilerimde uyum üzerine düşünüyorum.',
    'Güzellik ve estetik temaları üzerine farkındalık geliştiriyorum.',
    'Adalet ve denge üzerine düşünüyorum.',
    'Diplomatik yeteneklerimi keşfediyorum.',
    'Partnerlik üzerine düşünüyorum.',
    'Barış ve sevgi temaları üzerine farkındalık geliştiriyorum.',
    'Bugün dönüşüme açık olmayı seçebilirim.',
    'Derinlik üzerine düşünüyorum.',
    'Sezgilerimi fark ediyorum.',
    'Tutku temaları üzerine farkındalık geliştiriyorum.',
    'Gölgelerimi keşfediyorum.',
    'Yeniden doğuş üzerine düşünüyorum.',
    'İç gücümü fark ediyorum.',
    'Bugün yeni ufuklar aramayı seçebilirim.',
    'İyimserliğimi fark ediyorum.',
    'Macera ruhu üzerine düşünüyorum.',
    'Bilgelik arayışı üzerine farkındalık geliştiriyorum.',
    'Özgürlük temaları üzerine düşünüyorum.',
    'İyimserliği keşfediyorum.',
    'Her günün bir keşif olduğunu hatırlıyorum.',
    'Bugün hedeflerime odaklanmayı seçebilirim.',
    'Disiplinimi fark ediyorum.',
    'Sabır ve azim üzerine düşünüyorum.',
    'Kariyer temaları üzerine farkındalık geliştiriyorum.',
    'Sağlam temeller üzerine düşünüyorum.',
    'Otorite ve sorumluluk üzerine düşünüyorum.',
    'Başarı kavramını keşfediyorum.',
    'Bugün geleceği düşünmeyi seçebilirim.',
    'Benzersizliğimi fark ediyorum.',
    'Topluluk katkısı üzerine düşünüyorum.',
    'Yenilikçi fikirler üzerine farkındalık geliştiriyorum.',
    'Özgür düşünce üzerine düşünüyorum.',
    'Topluluk bilinci üzerine düşünüyorum.',
    'İlham verme temaları üzerine farkındalık geliştiriyorum.',
    'Bugün sezgilerime güvenmeyi seçebilirim.',
    'Yaratıcılığımı fark ediyorum.',
    'Spiritüel bağlantı üzerine düşünüyorum.',
    'Empati temaları üzerine farkındalık geliştiriyorum.',
    'Rüyalarıma dikkat ediyorum.',
    'Koşulsuz sevgi üzerine düşünüyorum.',
    'Bütünlük hissi üzerine farkındalık geliştiriyorum.',
    'Bugün için farkındalık geliştirmeyi seçebilirim.',
    'Kendimle nazik olmayı deniyorum.',
    'Her şeyin yolunda olduğunu hatırlıyorum.',
    'Sevgi ve ışık temaları üzerine düşünüyorum.',
    'Bolluk kavramı üzerine farkındalık geliştiriyorum.',
    'İç gücümü fark ediyorum.',
    'Minnettarlık pratiği yapıyorum.',
  ];

  /// All evening reflections (flattened from archetype-specific content)
  static final List<String> _allEveningReflections = [
    'Bugün cesaretinle neler fark ettin? Kendini takdir edebilirsin.',
    'Hangi engeller üzerine düşündün? Gücünü hatırlayabilirsin.',
    'Sabır gösterebildin mi? İlerlemen için düşünebilirsin.',
    'Bugün hangi güzelliklerden zevk aldın?',
    'Kendine nasıl değer verdin?',
    'Minnettarlık listeni gözden geçirebilirsin.',
    'Bugün ne öğrendin? Bilgi üzerine düşünebilirsin.',
    'Hangi bağlantıları fark ettin?',
    'Fikirlerini kimlerle paylaştın?',
    'Bugün duygularınla nasıl bağ kurdun?',
    'Sevdiklerine nasıl ilgi gösterdin?',
    'İç dünyan hakkında ne fark ettin?',
    'Bugün kendini nasıl ifade ettin?',
    'Yaratıcılığını nasıl kullandın?',
    'Kimlere ilham verdin?',
    'Bugün kendine nasıl hizmet ettin?',
    'Hangi detaylar dikkatini çekti?',
    'Sağlığına nasıl baktın?',
    'Bugün dengeyi nasıl buldun?',
    'İlişkilerinde uyum sağladın mı?',
    'Güzellik hayatına nasıl dokundu?',
    'Bugün hangi derinlikleri keşfettin?',
    'Neyi dönüştürdün?',
    'Hangi içgörüler kazandın?',
    'Bugün ne keşfettin?',
    'Hangi bilgeliği buldun?',
    'Özgürlük nasıl bir his?',
    'Bugün hedeflerine nasıl yaklaştın?',
    'Hangi temelleri attın?',
    'Disiplininden memnun musun?',
    'Bugün nasıl fark yarattın?',
    'Topluma nasıl katkıda bulundun?',
    'Hangi yenilikçi fikirler aklına geldi?',
    'Bugün sezgilerin seni nereye yönlendirdi?',
    'Hangi yaratıcı düşünceler ortaya çıktı?',
    'Spiritüel bağlantın nasıl hissettirdi?',
    'Bugün için minnettarlık listeni gözden geçirebilirsin.',
    'Hangi anlar seni gülümsetti?',
    'Yarın için bir niyet belirleyebilirsin.',
  ];

  /// Moon phase reflection themes (cultural symbolism)
  static final Map<String, String> _moonPhaseInsights = {
    'new_moon':
        'Yeni Ay, birçok kültürde yeni başlangıçlarla ilişkilendirilir. Bu dönem, niyetleri netleştirmek ve içe dönmek için bir davet olarak düşünülebilir.',
    'waxing_crescent':
        'Hilal Ay, geleneksel olarak büyüme ve inanç temaları ile ilişkilendirilir. Niyetleri eyleme dönüştürmek üzerine düşünebilirsin.',
    'first_quarter':
        'İlk Dördün, karar verme ve eylem temaları ile ilişkilendirilir. Engellerle nasıl yüzleştiğin üzerine düşünebilirsin.',
    'waxing_gibbous':
        'Kabaran Ay, ince ayar ve sabır temaları ile ilişkilendirilir. Çabalarının meyvelerini görmek üzerine düşünebilirsin.',
    'full_moon':
        'Dolunay, birçok gelenekte tamamlanma ve şükran ile ilişkilendirilir. Başarılarını kutlamak için bir zaman olarak düşünülebilir.',
    'waning_gibbous':
        'Azalan Ay, bilgelik paylaşımı ve minnettarlık temaları ile ilişkilendirilir. Öğrendiklerini paylaşmak üzerine düşünebilirsin.',
    'last_quarter':
        'Son Dördün, bırakma ve affetme temaları ile ilişkilendirilir. Artık hizmet etmeyeni serbest bırakmak üzerine düşünebilirsin.',
    'waning_crescent':
        'Son Hilal, dinlenme ve arınma temaları ile ilişkilendirilir. Yenilenme için zaman ayırmak üzerine düşünebilirsin.',
  };

  /// Daily intentions by archetype
  static final Map<String, List<String>> _dailyIntentions = {
    'pioneer': [
      'Bugün sabırla hareket etmeyi seçebilirim.',
      'Cesaretimi yapıcı yönde kullanmayı deniyorum.',
      'Liderliğimi sevgiyle göstermeyi düşünüyorum.',
      'Her engeli öğrenme fırsatı olarak görebilirim.',
      'Enerjimi bilinçli yönlendirmeyi seçebilirim.',
      'Yeni başlangıçlara açık olmayı deniyorum.',
      'Gücümü başkalarını desteklemek için kullanmayı düşünüyorum.',
    ],
    'builder': [
      'Bugün bolluğa açık olmayı seçebilirim.',
      'Hayatın küçük zevklerini fark etmeyi deniyorum.',
      'Sabırla güzel şeylerin gelmesine izin vermeyi düşünüyorum.',
      'Değerimi bilmeyi ve savunmayı seçebilirim.',
      'Güvenlik içinde özgür hissetmeyi deniyorum.',
      'Doğayla bağlantı kurmayı düşünüyorum.',
      'Minnettarlık pratiği yapmayı seçebilirim.',
    ],
    'communicator': [
      'Bugün bilinçli iletişim kurmayı seçebilirim.',
      'Öğrenmeye açık bir zihinle yaklaşmayı deniyorum.',
      'Merakımı yapıcı yönde kullanmayı düşünüyorum.',
      'Fikirlerimi netleştirmeyi seçebilirim.',
      'Dinlemeye odaklanmayı deniyorum.',
      'Çok yönlülüğümü kutlamayı düşünüyorum.',
      'Bağlantılarımı derinleştirmeyi seçebilirim.',
    ],
    'nurturer': [
      'Bugün duygularıma alan tanımayı seçebilirim.',
      'Sezgilerime güvenmeyi deniyorum.',
      'Sevdiklerime sevgimi göstermeyi düşünüyorum.',
      'Kendime şefkatle davranmayı seçebilirim.',
      'Güvenli sınırlar oluşturmayı deniyorum.',
      'Geçmişi iyileştirmeyi düşünüyorum.',
      'Yuva enerjisi yaratmayı seçebilirim.',
    ],
    'performer': [
      'Bugün otantik ben olmayı seçebilirim.',
      'Yaratıcılığımı ifade etmeyi deniyorum.',
      'Başkalarının parlamasına alan açmayı düşünüyorum.',
      'Cömertlikle vermeyi seçebilirim.',
      'Kendimi sevgiyle kutlamayı deniyorum.',
      'İlham kaynağı olmayı düşünüyorum.',
      'Kalbimden konuşmayı seçebilirim.',
    ],
    'analyst': [
      'Bugün mükemmeliyetçiliği bırakmayı seçebilirim.',
      'Kendime şefkat göstermeyi deniyorum.',
      'Detaylarda anlam bulmayı düşünüyorum.',
      'Sağlığıma öncelik vermeyi seçebilirim.',
      'Hizmet ederken sınır koymayı deniyorum.',
      'İlerlemeyi kutlamayı düşünüyorum.',
      'Düzeni sevgiyle yaratmayı seçebilirim.',
    ],
    'harmonizer': [
      'Bugün iç dengeyi bulmayı seçebilirim.',
      'İlişkilerimde sağlıklı sınır koymayı deniyorum.',
      'Güzellik yaratmayı düşünüyorum.',
      'Kararlarımda kendime güvenmeyi seçebilirim.',
      'Uyumu içeriden başlatmayı deniyorum.',
      'Adalet için sesimi yükseltmeyi düşünüyorum.',
      'Barışı yaymayı seçebilirim.',
    ],
    'transformer': [
      'Bugün dönüşüme açık olmayı seçebilirim.',
      'Derinliği kucaklamayı deniyorum.',
      'Gölgelerimi aydınlatmayı düşünüyorum.',
      'Tutkumu bilinçli yönlendirmeyi seçebilirim.',
      'Güvenmeyi öğrenmeyi deniyorum.',
      'Yeniden doğuşu kutlamayı düşünüyorum.',
      'Gücümü bilgelikle kullanmayı seçebilirim.',
    ],
    'explorer': [
      'Bugün yeni ufuklar aramayı seçebilirim.',
      'Bilgelik arayışımı sürdürmeyi deniyorum.',
      'Özgürlüğümü sorumlulukla kullanmayı düşünüyorum.',
      'İyimserliği yaymayı seçebilirim.',
      'Maceraya evet demeyi deniyorum.',
      'Büyük resmi görmeyi düşünüyorum.',
      'İnancımı güçlendirmeyi seçebilirim.',
    ],
    'achiever': [
      'Bugün hedeflerime odaklanmayı seçebilirim.',
      'Sabırla ilerlemeyi deniyorum.',
      'Disiplinimi sevgiyle uygulamayı düşünüyorum.',
      'Başarıyı kutlamayı seçebilirim.',
      'Dinlenmeye de izin vermeyi deniyorum.',
      'Sorumluluklarımı dengelemeyi düşünüyorum.',
      'Zirveye yaklaşmayı seçebilirim.',
    ],
    'visionary': [
      'Bugün benzersizliğimi kutlamayı seçebilirim.',
      'İnsanlığa hizmet etmeyi deniyorum.',
      'Yenilikçi düşünmeyi düşünüyorum.',
      'Toplulukla bağ kurmayı seçebilirim.',
      'Geleceği şekillendirmeyi deniyorum.',
      'Özgür düşünceyi savunmayı düşünüyorum.',
      'Değişimi kucaklamayı seçebilirim.',
    ],
    'dreamer': [
      'Bugün sezgilerime güvenmeyi seçebilirim.',
      'Spiritüel bağlantımı derinleştirmeyi deniyorum.',
      'Yaratıcılığımı ifade etmeyi düşünüyorum.',
      'Empatiyle sınır koymayı seçebilirim.',
      'Rüyalarıma dikkat etmeyi deniyorum.',
      'Bütünlük hissi üzerine düşünüyorum.',
      'Koşulsuz sevgi vermeyi seçebilirim.',
    ],
  };

  static final List<String> _universalIntentions = [
    'Bugün farkındalıkla yaşamayı seçebilirim.',
    'Her ana teşekkür etmeyi deniyorum.',
    'Sevgi ve ışık yaymayı düşünüyorum.',
    'Potansiyelimi keşfetmeyi seçebilirim.',
    'Şu anda kalmayı deniyorum.',
    'Kendimle barışık olmayı düşünüyorum.',
    'Güven duygusunu keşfetmeyi seçebilirim.',
  ];

  /// Extended reflection themes for deeper readings
  static final Map<String, List<String>> _extendedCosmicWisdoms = {
    'pioneer': [
      'Ateş arketipi, cesaret, inisiyatif ve liderlik temalarını simgeler. Bu özellikler hayatında nasıl ortaya çıkıyor? Gerçek gücün kontrollü güç olduğu düşünülebilir. Sabırsızlık ile kararlılık arasındaki dengeyi düşünmek isteyebilirsin.',
      'Öncü arketipi olarak, liderlik enerjisi üzerine düşünebilirsin. Yeni projeler, yeni ilişkiler, yeni başlangıçlar... Hangi alanlarda inisiyatif almak istiyorsun? Korku ve cesaret arasındaki ilişkiyi keşfedebilirsin.',
      'Eylem ve düşünce arasındaki denge üzerine bir refleksiyon yapabilirsin. Sezgilerine güvenmek ne anlama geliyor? İçgüdülerinle nasıl bir ilişkin var?',
    ],
    'builder': [
      'Toprak arketipi, istikrar, değer ve duyusal deneyim temalarını simgeler. Maddi dünya ile ilişkin üzerine düşünebilirsin. Gerçek zenginliğin ne olduğunu keşfetmek isteyebilirsin.',
      'Sabır ve kararlılık temaları üzerine bir refleksiyon. Hızlı sonuçlar yerine sürdürülebilir ilerleme üzerine düşünmek faydalı olabilir. Zamanlamanın önemi hakkında ne düşünüyorsun?',
      'Duyusal zevkler ve öz-bakım temaları üzerine düşünebilirsin. Güzel bir yemek, hoş bir müzik, sevilen birinin varlığı... Bunların ruhunu nasıl beslediğini fark edebilirsin.',
    ],
    'communicator': [
      'Hava arketipi, iletişim, merak ve çok yönlülük temalarını simgeler. Zihinsel çevikliğin hayatına nasıl katkıda bulunuyor? Bilgi ve bağlantı üzerine düşünmek isteyebilirsin.',
      'Çok yönlülük teması üzerine bir refleksiyon. Aynı anda birçok ilgi alanına sahip olmak senin için ne anlama geliyor? Bu özelliğini nasıl değerlendiriyorsun?',
      'Merak ve öğrenme üzerine düşünebilirsin. Sorular sormak ve araştırmak hayatında nasıl yer alıyor? Öğrendiklerini paylaşmak hakkında ne hissediyorsun?',
    ],
    'nurturer': [
      'Su arketipi, duygusal derinlik, sezgi ve koruma temalarını simgeler. İç sesin sana ne söylüyor? Duygusal radarın üzerine düşünmek isteyebilirsin.',
      'Yuva, aile ve kökler temaları üzerine bir refleksiyon. Bunlar senin için ne anlama geliyor? Sevdiklerinle ilişkin hakkında düşünebilirsin.',
      'Duygularla ilişki üzerine düşünebilirsin. Duygusal ifade senin için ne anlama geliyor? Şefkat ve savunmasızlık arasındaki dengeyi keşfedebilirsin.',
    ],
    'performer': [
      'Ateş arketipi, yaratıcılık, kendini ifade etme ve görünürlük temalarını simgeler. Parlamak senin için ne anlama geliyor? Otantik olmak üzerine düşünmek isteyebilirsin.',
      'Yaratıcılık teması üzerine bir refleksiyon. Sanat, müzik, dans, yazı... Her türlü yaratıcı ifade senin için ne ifade ediyor? Yaratıcılığınla nasıl bir ilişkin var?',
      'Cömertlik ve paylaşım temaları üzerine düşünebilirsin. Vermek ve almak arasındaki denge hakkında ne düşünüyorsun? Cömertliğin farklı biçimlerini keşfedebilirsin.',
    ],
    'analyst': [
      'Toprak arketipi, detay, hizmet ve şifa temalarını simgeler. Analitik zekanın hayatına nasıl katkıda bulunuyor? Düzen ve anlam arayışı üzerine düşünmek isteyebilirsin.',
      'Şifa ve hizmet temaları üzerine bir refleksiyon. Kendine ve başkalarına nasıl iyilik yapıyorsun? Küçük eylemlerin büyük etkileri hakkında düşünebilirsin.',
      'Mükemmellik ve ilerleme arasındaki denge üzerine düşünebilirsin. İlerlemeyi kutlamak senin için ne anlama geliyor? Pratik zekânı nasıl değerlendiriyorsun?',
    ],
    'harmonizer': [
      'Hava arketipi, denge, uyum ve ilişki temalarını simgeler. Harmoni senin için ne anlama geliyor? İlişkilerde dengeyi bulmak üzerine düşünmek isteyebilirsin.',
      'Diplomasi ve iletişim temaları üzerine bir refleksiyon. Çatışmaları nasıl yönetiyorsun? İnsanları bir araya getirmek hakkında ne düşünüyorsun?',
      'Estetik ve güzellik üzerine düşünebilirsin. Güzellik sadece görsel değil, ruhsal da olabilir. Güzellik yaratmak ve takdir etmek senin için ne anlama geliyor?',
    ],
    'transformer': [
      'Su arketipi, dönüşüm, derinlik ve yoğunluk temalarını simgeler. Dönüşüm senin için ne anlama geliyor? Gölgelerle ilişkin üzerine düşünmek isteyebilirsin.',
      'Sezgi ve içgörü temaları üzerine bir refleksiyon. Görünmeyeni görmek, bilinmeyeni bilmek... Bu yeteneklerle nasıl bir ilişkin var?',
      'Tutku ve yoğunluk üzerine düşünebilirsin. Bu enerjiyi nasıl yönlendiriyorsun? Yaratıcı ve dönüştürücü yollar hakkında ne düşünüyorsun?',
    ],
    'explorer': [
      'Ateş arketipi, keşif, anlam arayışı ve özgürlük temalarını simgeler. Yeni ufuklar senin için ne anlama geliyor? Fiziksel, zihinsel veya ruhsal yolculuklar üzerine düşünmek isteyebilirsin.',
      'Bilgelik arayışı teması üzerine bir refleksiyon. Felsefe, spiritualite, hayatın büyük soruları... Bu konulara nasıl yaklaşıyorsun?',
      'İyimserlik ve umut temaları üzerine düşünebilirsin. Zor zamanlarda bile umut taşımak ne anlama geliyor? İyimserliğinin kaynağını keşfedebilirsin.',
    ],
    'achiever': [
      'Toprak arketipi, hedefler, yapı ve sorumluluk temalarını simgeler. Zirveye ulaşmak senin için ne anlama geliyor? Yolculuk ve varış noktası arasındaki ilişkiyi düşünmek isteyebilirsin.',
      'Uzun vadeli düşünme teması üzerine bir refleksiyon. Herkes şimdiyi düşünürken, geleceği planlamak hakkında ne hissediyorsun? Temeller ve yapılar üzerine düşünebilirsin.',
      'Otorite ve sorumluluk temaları üzerine düşünebilirsin. Liderlik etmek, yönetmek, organize etmek... Bu roller hayatında nasıl yer alıyor?',
    ],
    'visionary': [
      'Hava arketipi, yenilik, topluluk ve benzersizlik temalarını simgeler. Geleceği şekillendirmek senin için ne anlama geliyor? Vizyoner bakış açın üzerine düşünmek isteyebilirsin.',
      'Topluluk ve kolektif bilinç temaları üzerine bir refleksiyon. Bireysel başarılar ile kolektif ilerleme arasındaki denge hakkında ne düşünüyorsun?',
      'Benzersizlik ve özgünlük üzerine düşünebilirsin. Farklı olmak senin için ne anlama geliyor? Özgünlüğünü kutlamak hakkında ne hissediyorsun?',
    ],
    'dreamer': [
      'Su arketipi, hayal gücü, sezgi ve şefkat temalarını simgeler. Görünmeyen dünyalar, duyulmayan sesler, hissedilmeyen enerjiler... Bunlara erişimin hakkında düşünmek isteyebilirsin.',
      'Yaratıcılık ve hayal gücü temaları üzerine bir refleksiyon. Sanat, müzik, şiir, dans... Yaratıcı ifade senin için ne anlama geliyor?',
      'Empati ve şefkat üzerine düşünebilirsin. Başkalarının duygularını hissetmek ne anlama geliyor? Kendi sınırlarını korurken şefkatli olmak hakkında ne düşünüyorsun?',
    ],
  };

  static final List<String> _universalExtendedWisdoms = [
    'Farkındalık ve şimdiki an üzerine bir refleksiyon. Her nefes, her kalp atışı... Bu anın değerini fark etmek isteyebilirsin.',
    'Zaman ve perspektif üzerine düşünebilirsin. Geçmiş, şimdi ve gelecek... Bunlar arasındaki ilişkiyi keşfetmek faydalı olabilir.',
    'Değişim ve dönüşüm temaları üzerine bir refleksiyon. Eskiyi bırakmak ve yeniye açılmak senin için ne anlama geliyor?',
  ];

  /// All daily intentions (flattened from archetype-specific content)
  static final List<String> _allDailyIntentions = [
    'Bugün sabırla hareket etmeyi seçebilirim.',
    'Cesaretimi yapıcı yönde kullanmayı deniyorum.',
    'Liderliğimi sevgiyle göstermeyi düşünüyorum.',
    'Her engeli öğrenme fırsatı olarak görebilirim.',
    'Enerjimi bilinçli yönlendirmeyi seçebilirim.',
    'Yeni başlangıçlara açık olmayı deniyorum.',
    'Gücümü başkalarını desteklemek için kullanmayı düşünüyorum.',
    'Bugün bolluğa açık olmayı seçebilirim.',
    'Hayatın küçük zevklerini fark etmeyi deniyorum.',
    'Sabırla güzel şeylerin gelmesine izin vermeyi düşünüyorum.',
    'Değerimi bilmeyi ve savunmayı seçebilirim.',
    'Güvenlik içinde özgür hissetmeyi deniyorum.',
    'Doğayla bağlantı kurmayı düşünüyorum.',
    'Minnettarlık pratiği yapmayı seçebilirim.',
    'Bugün bilinçli iletişim kurmayı seçebilirim.',
    'Öğrenmeye açık bir zihinle yaklaşmayı deniyorum.',
    'Merakımı yapıcı yönde kullanmayı düşünüyorum.',
    'Fikirlerimi netleştirmeyi seçebilirim.',
    'Dinlemeye odaklanmayı deniyorum.',
    'Çok yönlülüğümü kutlamayı düşünüyorum.',
    'Bağlantılarımı derinleştirmeyi seçebilirim.',
    'Bugün duygularıma alan tanımayı seçebilirim.',
    'Sezgilerime güvenmeyi deniyorum.',
    'Sevdiklerime sevgimi göstermeyi düşünüyorum.',
    'Kendime şefkatle davranmayı seçebilirim.',
    'Güvenli sınırlar oluşturmayı deniyorum.',
    'Geçmişi iyileştirmeyi düşünüyorum.',
    'Yuva enerjisi yaratmayı seçebilirim.',
    'Bugün otantik ben olmayı seçebilirim.',
    'Yaratıcılığımı ifade etmeyi deniyorum.',
    'Başkalarının parlamasına alan açmayı düşünüyorum.',
    'Cömertlikle vermeyi seçebilirim.',
    'Kendimi sevgiyle kutlamayı deniyorum.',
    'İlham kaynağı olmayı düşünüyorum.',
    'Kalbimden konuşmayı seçebilirim.',
    'Bugün mükemmeliyetçiliği bırakmayı seçebilirim.',
    'Kendime şefkat göstermeyi deniyorum.',
    'Detaylarda anlam bulmayı düşünüyorum.',
    'Sağlığıma öncelik vermeyi seçebilirim.',
    'Hizmet ederken sınır koymayı deniyorum.',
    'İlerlemeyi kutlamayı düşünüyorum.',
    'Düzeni sevgiyle yaratmayı seçebilirim.',
    'Bugün iç dengeyi bulmayı seçebilirim.',
    'İlişkilerimde sağlıklı sınır koymayı deniyorum.',
    'Güzellik yaratmayı düşünüyorum.',
    'Kararlarımda kendime güvenmeyi seçebilirim.',
    'Uyumu içeriden başlatmayı deniyorum.',
    'Adalet için sesimi yükseltmeyi düşünüyorum.',
    'Barışı yaymayı seçebilirim.',
    'Bugün dönüşüme açık olmayı seçebilirim.',
    'Derinliği kucaklamayı deniyorum.',
    'Gölgelerimi aydınlatmayı düşünüyorum.',
    'Tutkumu bilinçli yönlendirmeyi seçebilirim.',
    'Güvenmeyi öğrenmeyi deniyorum.',
    'Yeniden doğuşu kutlamayı düşünüyorum.',
    'Gücümü bilgelikle kullanmayı seçebilirim.',
    'Bugün yeni ufuklar aramayı seçebilirim.',
    'Bilgelik arayışımı sürdürmeyi deniyorum.',
    'Özgürlüğümü sorumlulukla kullanmayı düşünüyorum.',
    'İyimserliği yaymayı seçebilirim.',
    'Maceraya evet demeyi deniyorum.',
    'Büyük resmi görmeyi düşünüyorum.',
    'İnancımı güçlendirmeyi seçebilirim.',
    'Bugün hedeflerime odaklanmayı seçebilirim.',
    'Sabırla ilerlemeyi deniyorum.',
    'Disiplinimi sevgiyle uygulamayı düşünüyorum.',
    'Başarıyı kutlamayı seçebilirim.',
    'Dinlenmeye de izin vermeyi deniyorum.',
    'Sorumluluklarımı dengelemeyi düşünüyorum.',
    'Zirveye yaklaşmayı seçebilirim.',
    'Bugün benzersizliğimi kutlamayı seçebilirim.',
    'İnsanlığa hizmet etmeyi deniyorum.',
    'Yenilikçi düşünmeyi düşünüyorum.',
    'Toplulukla bağ kurmayı seçebilirim.',
    'Geleceği şekillendirmeyi deniyorum.',
    'Özgür düşünceyi savunmayı düşünüyorum.',
    'Değişimi kucaklamayı seçebilirim.',
    'Bugün sezgilerime güvenmeyi seçebilirim.',
    'Spiritüel bağlantımı derinleştirmeyi deniyorum.',
    'Yaratıcılığımı ifade etmeyi düşünüyorum.',
    'Empatiyle sınır koymayı seçebilirim.',
    'Rüyalarıma dikkat etmeyi deniyorum.',
    'Bütünlük hissi üzerine düşünüyorum.',
    'Koşulsuz sevgi vermeyi seçebilirim.',
    'Bugün farkındalıkla yaşamayı seçebilirim.',
    'Her ana teşekkür etmeyi deniyorum.',
    'Sevgi ve ışık yaymayı düşünüyorum.',
    'Potansiyelimi keşfetmeyi seçebilirim.',
    'Şu anda kalmayı deniyorum.',
    'Kendimle barışık olmayı düşünüyorum.',
    'Güven duygusunu keşfetmeyi seçebilirim.',
  ];

  /// All extended cosmic wisdoms (flattened from archetype-specific content)
  static final List<String> _allExtendedCosmicWisdoms = [
    'Ateş arketipi, cesaret, inisiyatif ve liderlik temalarını simgeler. Bu özellikler hayatında nasıl ortaya çıkıyor? Gerçek gücün kontrollü güç olduğu düşünülebilir. Sabırsızlık ile kararlılık arasındaki dengeyi düşünmek isteyebilirsin.',
    'Öncü arketipi olarak, liderlik enerjisi üzerine düşünebilirsin. Yeni projeler, yeni ilişkiler, yeni başlangıçlar... Hangi alanlarda inisiyatif almak istiyorsun? Korku ve cesaret arasındaki ilişkiyi keşfedebilirsin.',
    'Eylem ve düşünce arasındaki denge üzerine bir refleksiyon yapabilirsin. Sezgilerine güvenmek ne anlama geliyor? İçgüdülerinle nasıl bir ilişkin var?',
    'Toprak arketipi, istikrar, değer ve duyusal deneyim temalarını simgeler. Maddi dünya ile ilişkin üzerine düşünebilirsin. Gerçek zenginliğin ne olduğunu keşfetmek isteyebilirsin.',
    'Sabır ve kararlılık temaları üzerine bir refleksiyon. Hızlı sonuçlar yerine sürdürülebilir ilerleme üzerine düşünmek faydalı olabilir. Zamanlamanın önemi hakkında ne düşünüyorsun?',
    'Duyusal zevkler ve öz-bakım temaları üzerine düşünebilirsin. Güzel bir yemek, hoş bir müzik, sevilen birinin varlığı... Bunların ruhunu nasıl beslediğini fark edebilirsin.',
    'Hava arketipi, iletişim, merak ve çok yönlülük temalarını simgeler. Zihinsel çevikliğin hayatına nasıl katkıda bulunuyor? Bilgi ve bağlantı üzerine düşünmek isteyebilirsin.',
    'Çok yönlülük teması üzerine bir refleksiyon. Aynı anda birçok ilgi alanına sahip olmak senin için ne anlama geliyor? Bu özelliğini nasıl değerlendiriyorsun?',
    'Merak ve öğrenme üzerine düşünebilirsin. Sorular sormak ve araştırmak hayatında nasıl yer alıyor? Öğrendiklerini paylaşmak hakkında ne hissediyorsun?',
    'Su arketipi, duygusal derinlik, sezgi ve koruma temalarını simgeler. İç sesin sana ne söylüyor? Duygusal radarın üzerine düşünmek isteyebilirsin.',
    'Yuva, aile ve kökler temaları üzerine bir refleksiyon. Bunlar senin için ne anlama geliyor? Sevdiklerinle ilişkin hakkında düşünebilirsin.',
    'Duygularla ilişki üzerine düşünebilirsin. Duygusal ifade senin için ne anlama geliyor? Şefkat ve savunmasızlık arasındaki dengeyi keşfedebilirsin.',
    'Ateş arketipi, yaratıcılık, kendini ifade etme ve görünürlük temalarını simgeler. Parlamak senin için ne anlama geliyor? Otantik olmak üzerine düşünmek isteyebilirsin.',
    'Yaratıcılık teması üzerine bir refleksiyon. Sanat, müzik, dans, yazı... Her türlü yaratıcı ifade senin için ne ifade ediyor? Yaratıcılığınla nasıl bir ilişkin var?',
    'Cömertlik ve paylaşım temaları üzerine düşünebilirsin. Vermek ve almak arasındaki denge hakkında ne düşünüyorsun? Cömertliğin farklı biçimlerini keşfedebilirsin.',
    'Toprak arketipi, detay, hizmet ve şifa temalarını simgeler. Analitik zekanın hayatına nasıl katkıda bulunuyor? Düzen ve anlam arayışı üzerine düşünmek isteyebilirsin.',
    'Şifa ve hizmet temaları üzerine bir refleksiyon. Kendine ve başkalarına nasıl iyilik yapıyorsun? Küçük eylemlerin büyük etkileri hakkında düşünebilirsin.',
    'Mükemmellik ve ilerleme arasındaki denge üzerine düşünebilirsin. İlerlemeyi kutlamak senin için ne anlama geliyor? Pratik zekânı nasıl değerlendiriyorsun?',
    'Hava arketipi, denge, uyum ve ilişki temalarını simgeler. Harmoni senin için ne anlama geliyor? İlişkilerde dengeyi bulmak üzerine düşünmek isteyebilirsin.',
    'Diplomasi ve iletişim temaları üzerine bir refleksiyon. Çatışmaları nasıl yönetiyorsun? İnsanları bir araya getirmek hakkında ne düşünüyorsun?',
    'Estetik ve güzellik üzerine düşünebilirsin. Güzellik sadece görsel değil, ruhsal da olabilir. Güzellik yaratmak ve takdir etmek senin için ne anlama geliyor?',
    'Su arketipi, dönüşüm, derinlik ve yoğunluk temalarını simgeler. Dönüşüm senin için ne anlama geliyor? Gölgelerle ilişkin üzerine düşünmek isteyebilirsin.',
    'Sezgi ve içgörü temaları üzerine bir refleksiyon. Görünmeyeni görmek, bilinmeyeni bilmek... Bu yeteneklerle nasıl bir ilişkin var?',
    'Tutku ve yoğunluk üzerine düşünebilirsin. Bu enerjiyi nasıl yönlendiriyorsun? Yaratıcı ve dönüştürücü yollar hakkında ne düşünüyorsun?',
    'Ateş arketipi, keşif, anlam arayışı ve özgürlük temalarını simgeler. Yeni ufuklar senin için ne anlama geliyor? Fiziksel, zihinsel veya ruhsal yolculuklar üzerine düşünmek isteyebilirsin.',
    'Bilgelik arayışı teması üzerine bir refleksiyon. Felsefe, spiritualite, hayatın büyük soruları... Bu konulara nasıl yaklaşıyorsun?',
    'İyimserlik ve umut temaları üzerine düşünebilirsin. Zor zamanlarda bile umut taşımak ne anlama geliyor? İyimserliğinin kaynağını keşfedebilirsin.',
    'Toprak arketipi, hedefler, yapı ve sorumluluk temalarını simgeler. Zirveye ulaşmak senin için ne anlama geliyor? Yolculuk ve varış noktası arasındaki ilişkiyi düşünmek isteyebilirsin.',
    'Uzun vadeli düşünme teması üzerine bir refleksiyon. Herkes şimdiyi düşünürken, geleceği planlamak hakkında ne hissediyorsun? Temeller ve yapılar üzerine düşünebilirsin.',
    'Otorite ve sorumluluk temaları üzerine düşünebilirsin. Liderlik etmek, yönetmek, organize etmek... Bu roller hayatında nasıl yer alıyor?',
    'Hava arketipi, yenilik, topluluk ve benzersizlik temalarını simgeler. Geleceği şekillendirmek senin için ne anlama geliyor? Vizyoner bakış açın üzerine düşünmek isteyebilirsin.',
    'Topluluk ve kolektif bilinç temaları üzerine bir refleksiyon. Bireysel başarılar ile kolektif ilerleme arasındaki denge hakkında ne düşünüyorsun?',
    'Benzersizlik ve özgünlük üzerine düşünebilirsin. Farklı olmak senin için ne anlama geliyor? Özgünlüğünü kutlamak hakkında ne hissediyorsun?',
    'Su arketipi, hayal gücü, sezgi ve şefkat temalarını simgeler. Görünmeyen dünyalar, duyulmayan sesler, hissedilmeyen enerjiler... Bunlara erişimin hakkında düşünmek isteyebilirsin.',
    'Yaratıcılık ve hayal gücü temaları üzerine bir refleksiyon. Sanat, müzik, şiir, dans... Yaratıcı ifade senin için ne anlama geliyor?',
    'Empati ve şefkat üzerine düşünebilirsin. Başkalarının duygularını hissetmek ne anlama geliyor? Kendi sınırlarını korurken şefkatli olmak hakkında ne düşünüyorsun?',
    'Farkındalık ve şimdiki an üzerine bir refleksiyon. Her nefes, her kalp atışı... Bu anın değerini fark etmek isteyebilirsin.',
    'Zaman ve perspektif üzerine düşünebilirsin. Geçmiş, şimdi ve gelecek... Bunlar arasındaki ilişkiyi keşfetmek faydalı olabilir.',
    'Değişim ve dönüşüm temaları üzerine bir refleksiyon. Eskiyi bırakmak ve yeniye açılmak senin için ne anlama geliyor?',
  ];

}
