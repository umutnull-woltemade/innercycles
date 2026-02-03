// Tantra Content System - 50 Modular Wellness Units
// Safe, non-explicit, Instagram-shareable content
// Focus: Farkındalık, nefes, bağlanma, enerji

// ═══════════════════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════════════════

enum TantraTheme {
  breathAwareness,
  emotionalConnection,
  energyBalance,
  bodyAwareness,
  ritualIntent,
  trustInRelationship,
  slownessAttention,
  selfCompassion,
  presentMoment,
  sharedRhythms,
}

extension TantraThemeExtension on TantraTheme {
  /// Localized name for the theme - falls back to Turkish for now
  String localizedName(dynamic language) => nameTr;

  String get nameTr {
    switch (this) {
      case TantraTheme.breathAwareness:
        return 'Nefes & Farkındalık';
      case TantraTheme.emotionalConnection:
        return 'Duygusal Bağlanma';
      case TantraTheme.energyBalance:
        return 'Enerji Dengesi';
      case TantraTheme.bodyAwareness:
        return 'Beden Farkındalığı';
      case TantraTheme.ritualIntent:
        return 'Ritüel & Niyet';
      case TantraTheme.trustInRelationship:
        return 'İlişkide Güven';
      case TantraTheme.slownessAttention:
        return 'Yavaşlık & Dikkat';
      case TantraTheme.selfCompassion:
        return 'Kendilik Şefkati';
      case TantraTheme.presentMoment:
        return 'An\'da Kalma';
      case TantraTheme.sharedRhythms:
        return 'Paylaşılan Ritimler';
    }
  }

  String get icon {
    switch (this) {
      case TantraTheme.breathAwareness:
        return '🌬️';
      case TantraTheme.emotionalConnection:
        return '💫';
      case TantraTheme.energyBalance:
        return '⚖️';
      case TantraTheme.bodyAwareness:
        return '🧘';
      case TantraTheme.ritualIntent:
        return '🕯️';
      case TantraTheme.trustInRelationship:
        return '🤝';
      case TantraTheme.slownessAttention:
        return '🐢';
      case TantraTheme.selfCompassion:
        return '💝';
      case TantraTheme.presentMoment:
        return '⏳';
      case TantraTheme.sharedRhythms:
        return '🎵';
    }
  }

  String get colorHex {
    switch (this) {
      case TantraTheme.breathAwareness:
        return '#87CEEB';
      case TantraTheme.emotionalConnection:
        return '#E8B4B8';
      case TantraTheme.energyBalance:
        return '#C4A484';
      case TantraTheme.bodyAwareness:
        return '#98D8C8';
      case TantraTheme.ritualIntent:
        return '#DDA0DD';
      case TantraTheme.trustInRelationship:
        return '#F0E68C';
      case TantraTheme.slownessAttention:
        return '#B8860B';
      case TantraTheme.selfCompassion:
        return '#FFB6C1';
      case TantraTheme.presentMoment:
        return '#BC544B';
      case TantraTheme.sharedRhythms:
        return '#9370DB';
    }
  }

  /// Short description of the theme
  String get description {
    switch (this) {
      case TantraTheme.breathAwareness:
        return 'Nefes, yaşamın en temel ritmidir. Bilinçli nefes, bedeni sakinleştirir ve zihni berraklaştırır.';
      case TantraTheme.emotionalConnection:
        return 'Duygusal bağlanma, kalbi açar ve ilişkilerde derinlik yaratır. Kendini ve başkalarını anlamanın anahtarıdır.';
      case TantraTheme.energyBalance:
        return 'Enerji dengesi, verme ve alma arasındaki harmonidir. İç huzur ve dış dünya arasında köprü kurar.';
      case TantraTheme.bodyAwareness:
        return 'Beden, duyguların ve düşüncelerin evidir. Bedensel farkındalık, içsel bilgeliğe kapı açar.';
      case TantraTheme.ritualIntent:
        return 'Ritüeller, günlük yaşama anlam katar. Bilinçli niyet, eylemlere güç ve yön verir.';
      case TantraTheme.trustInRelationship:
        return 'Güven, tüm ilişkilerin temelidir. Açıklık ve dürüstlük, gerçek bağlanmayı mümkün kılar.';
      case TantraTheme.slownessAttention:
        return 'Yavaşlamak, her anı tam olarak yaşamaktır. Dikkat, farkındalığın en güçlü aracıdır.';
      case TantraTheme.selfCompassion:
        return 'Kendinize şefkat göstermek, başkalarına da şefkat göstermenin başlangıcıdır.';
      case TantraTheme.presentMoment:
        return 'An\'da kalma, geçmişin ve geleceğin kaygısından kurtulmaktır. Şimdi, gerçek yaşamın yeridir.';
      case TantraTheme.sharedRhythms:
        return 'Paylaşılan ritimler, iki ruhun dans etmesidir. Uyum, beraber büyümenin şarkısıdır.';
    }
  }
}

class TantraModule {
  final int id;
  final String title;
  final String coreInsight;
  final String reflection;
  final String practice;
  final TantraTheme theme;
  final int durationMinutes;

  const TantraModule({
    required this.id,
    required this.title,
    required this.coreInsight,
    required this.reflection,
    required this.practice,
    required this.theme,
    this.durationMinutes = 5,
  });
}

class TantraQuestion {
  final String question;
  final TantraQuestionPurpose purpose;

  const TantraQuestion({required this.question, required this.purpose});
}

enum TantraQuestionPurpose {
  awarenessOpening,
  emotionalClarity,
  relationalBond,
  preRitualIntent,
  dailyCheckIn,
}

extension TantraQuestionPurposeExtension on TantraQuestionPurpose {
  /// Localized name - falls back to Turkish for now
  String localizedName(dynamic language) => nameTr;

  String get nameTr {
    switch (this) {
      case TantraQuestionPurpose.awarenessOpening:
        return 'Farkındalık Açma';
      case TantraQuestionPurpose.emotionalClarity:
        return 'Duygusal Netlik';
      case TantraQuestionPurpose.relationalBond:
        return 'İlişkisel Bağ';
      case TantraQuestionPurpose.preRitualIntent:
        return 'Ritüel Niyeti';
      case TantraQuestionPurpose.dailyCheckIn:
        return 'Günlük Check-in';
    }
  }

  String get description {
    switch (this) {
      case TantraQuestionPurpose.awarenessOpening:
        return 'Günün başında veya bir pratiğe başlamadan önce farkındalığı açmak için kullanılır.';
      case TantraQuestionPurpose.emotionalClarity:
        return 'Duygusal durumunu anlamak ve netlik kazanmak için düşündürücü sorular.';
      case TantraQuestionPurpose.relationalBond:
        return 'Partnerinle veya sevdiklerinle daha derin bağ kurmak için sorular.';
      case TantraQuestionPurpose.preRitualIntent:
        return 'Ritüel veya meditasyon öncesi niyetini belirlemek için yönlendirici sorular.';
      case TantraQuestionPurpose.dailyCheckIn:
        return 'Her gün kendinle iletişim kurmak için kısa ve etkili kontrol soruları.';
    }
  }

  String get icon {
    switch (this) {
      case TantraQuestionPurpose.awarenessOpening:
        return '👁️';
      case TantraQuestionPurpose.emotionalClarity:
        return '💎';
      case TantraQuestionPurpose.relationalBond:
        return '💕';
      case TantraQuestionPurpose.preRitualIntent:
        return '🕯️';
      case TantraQuestionPurpose.dailyCheckIn:
        return '☀️';
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CONTENT SERVICE
// ═══════════════════════════════════════════════════════════════════════════

class TantraContent {
  static List<TantraModule> getAllModules() => _allModules;

  static List<TantraModule> getByTheme(TantraTheme theme) =>
      _allModules.where((m) => m.theme == theme).toList();

  static List<TantraQuestion> getAllQuestions() => _allQuestions;

  static List<TantraQuestion> getByPurpose(TantraQuestionPurpose purpose) =>
      _allQuestions.where((q) => q.purpose == purpose).toList();

  static TantraModule? getModuleById(int id) {
    try {
      return _allModules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  static TantraModule getDailyModule() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return _allModules[dayOfYear % _allModules.length];
  }

  static List<TantraModule> getRecommendedForTime() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 9) {
      // Morning
      return _allModules
          .where(
            (m) =>
                m.theme == TantraTheme.breathAwareness ||
                m.theme == TantraTheme.ritualIntent,
          )
          .take(3)
          .toList();
    } else if (hour >= 18 && hour < 22) {
      // Evening
      return _allModules
          .where(
            (m) =>
                m.theme == TantraTheme.emotionalConnection ||
                m.theme == TantraTheme.sharedRhythms,
          )
          .take(3)
          .toList();
    } else if (hour >= 22 || hour < 5) {
      // Night
      return _allModules
          .where(
            (m) =>
                m.theme == TantraTheme.selfCompassion ||
                m.theme == TantraTheme.presentMoment,
          )
          .take(3)
          .toList();
    }
    // Daytime
    return _allModules
        .where(
          (m) =>
              m.theme == TantraTheme.energyBalance ||
              m.theme == TantraTheme.slownessAttention,
        )
        .take(3)
        .toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 50 MODULES
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<TantraModule> _allModules = [
    // THEME: Nefes & Farkındalık (1-5)
    TantraModule(
      id: 1,
      title: 'Farkında Nefes',
      coreInsight: 'Nefes, bedenle zihin arasındaki köprüdür',
      reflection: 'Son ne zaman nefesini gerçekten hissettin?',
      practice: '3 dakika gözler kapalı, sadece nefesin sesini dinle',
      theme: TantraTheme.breathAwareness,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 2,
      title: 'Birlikte Nefes',
      coreInsight: 'Aynı ritimde nefes almak görünmez bir bağ kurar',
      reflection: 'Kiminle sessizce yan yana durabilirsin?',
      practice: 'Bir yakınınla 2 dakika göz teması ile senkron nefes',
      theme: TantraTheme.breathAwareness,
      durationMinutes: 2,
    ),
    TantraModule(
      id: 3,
      title: 'Nefes Dalgası',
      coreInsight: 'Her nefes bir başlangıç ve bitişi taşır',
      reflection: 'Hayatında neyi bırakmaya hazırsın?',
      practice: 'Nefes verirken zihinsel olarak bir yükü bırak',
      theme: TantraTheme.breathAwareness,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 4,
      title: 'Sabah Uyanışı',
      coreInsight: 'Günün ilk nefesi niyetini belirler',
      reflection: 'Bugün hangi enerjiyle başlamak istiyorsun?',
      practice: 'Yataktan kalkmadan 5 bilinçli nefes al',
      theme: TantraTheme.breathAwareness,
      durationMinutes: 2,
    ),
    TantraModule(
      id: 5,
      title: 'Akşam Dinginliği',
      coreInsight: 'Gün sonu nefesi bedeni yeniler',
      reflection: 'Bugün seni en çok ne yordu?',
      practice: 'Yatmadan önce 4-7-8 nefes tekniği',
      theme: TantraTheme.breathAwareness,
      durationMinutes: 5,
    ),

    // THEME: Duygusal Bağlanma (6-10)
    TantraModule(
      id: 6,
      title: 'Güvenli Alan',
      coreInsight: 'Bağlanma güvenle başlar',
      reflection: 'Kendini en güvende nerede hissediyorsun?',
      practice: 'O alanı zihninde canlandır, 1 dakika orada kal',
      theme: TantraTheme.emotionalConnection,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 7,
      title: 'Sessiz Anlama',
      coreInsight: 'Bazen kelimeler yetersizdir',
      reflection: 'Kimi kelimesiz anlıyorsun?',
      practice: 'Bugün birine sözsüz bir şefkat göster',
      theme: TantraTheme.emotionalConnection,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 8,
      title: 'Duygusal Dürüstlük',
      coreInsight: 'Gerçek bağ, maskelerin arkasında kurulmaz',
      reflection: 'Bugün hangi duygunu sakladın?',
      practice: 'Bir duygunu yargılamadan fark et',
      theme: TantraTheme.emotionalConnection,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 9,
      title: 'Kırılganlık Cesareti',
      coreInsight: 'Açılmak güç gerektirir',
      reflection: 'En son ne zaman zayıf görünmeyi göze aldın?',
      practice: 'Güvendiğin birine küçük bir endişeni paylaş',
      theme: TantraTheme.emotionalConnection,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 10,
      title: 'Empatik Dinleme',
      coreInsight: 'Dinlemek, cevap vermekten daha değerlidir',
      reflection: 'Dinlerken aklın ne kadar cevap arıyor?',
      practice: 'Bugün birini 3 dakika sadece dinle',
      theme: TantraTheme.emotionalConnection,
      durationMinutes: 3,
    ),

    // THEME: Enerji Dengesi (11-15)
    TantraModule(
      id: 11,
      title: 'Enerji Haritası',
      coreInsight: 'Beden enerjiyi depolar ve yansıtır',
      reflection: 'Enerjin bugün nerede yoğunlaşmış?',
      practice: 'Bedenini tarayarak gergin noktaları bul',
      theme: TantraTheme.energyBalance,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 12,
      title: 'Veren ve Alan',
      coreInsight: 'Sağlıklı ilişki iki yönlü akar',
      reflection: 'Daha çok veren misin, alan mı?',
      practice: 'Bugün dengeyi gözlemle',
      theme: TantraTheme.energyBalance,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 13,
      title: 'Enerji Sınırları',
      coreInsight: 'Korumak vermekten önce gelir',
      reflection: 'Kimin enerjisi seni tüketiyor?',
      practice: 'Hayır demenin bir yolunu bul',
      theme: TantraTheme.energyBalance,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 14,
      title: 'Topraklama',
      coreInsight: 'Dağınık enerji toprağa verilir',
      reflection: 'Kendini havada mı hissediyorsun?',
      practice: 'Ayakları yere bas, 1 dakika kökleri hisset',
      theme: TantraTheme.energyBalance,
      durationMinutes: 2,
    ),
    TantraModule(
      id: 15,
      title: 'Enerji Yenileme',
      coreInsight: 'Boşalan enerji bilinçle doldurulur',
      reflection: 'Seni en çok ne şarj ediyor?',
      practice: 'O aktiviteye bugün 10 dakika ayır',
      theme: TantraTheme.energyBalance,
      durationMinutes: 10,
    ),

    // THEME: Beden Farkındalığı (16-20)
    TantraModule(
      id: 16,
      title: 'Beden Taraması',
      coreInsight: 'Beden sürekli konuşur, mesele duymaktır',
      reflection: 'Bedenin şu an ne söylüyor?',
      practice: 'Baştan ayağa zihinsel tarama yap',
      theme: TantraTheme.bodyAwareness,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 17,
      title: 'Gerilim Haritası',
      coreInsight: 'Bastırılan duygular bedende birikir',
      reflection: 'Omuzların, çenen, karının nasıl?',
      practice: 'Gergin bölgeye nefes gönder',
      theme: TantraTheme.bodyAwareness,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 18,
      title: 'Hareketle Akış',
      coreInsight: 'Durağan enerji hareketle çözülür',
      reflection: 'Bugün bedenin ne kadar hareket etti?',
      practice: '2 dakika serbest, yargısız hareket',
      theme: TantraTheme.bodyAwareness,
      durationMinutes: 2,
    ),
    TantraModule(
      id: 19,
      title: 'Dokunuşun Dili',
      coreInsight: 'Dokunuş kelimelerin ötesinde iletişimdir',
      reflection: 'Kendi bedenine ne kadar naziksin?',
      practice: 'Ellerine 1 dakika şefkatle masaj yap',
      theme: TantraTheme.bodyAwareness,
      durationMinutes: 2,
    ),
    TantraModule(
      id: 20,
      title: 'Beden Minnettarlığı',
      coreInsight: 'Beden kusursuz değil, mucizedir',
      reflection: 'Bedenin bugün sana ne sağladı?',
      practice: '3 şey için bedenine teşekkür et',
      theme: TantraTheme.bodyAwareness,
      durationMinutes: 3,
    ),

    // THEME: Ritüel & Niyet (21-25)
    TantraModule(
      id: 21,
      title: 'Niyet Belirleme',
      coreInsight: 'Net niyet, net sonuç getirir',
      reflection: 'Bu anın niyeti ne?',
      practice: 'Tek cümlelik bir niyet yaz',
      theme: TantraTheme.ritualIntent,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 22,
      title: 'Sabah Ritüeli',
      coreInsight: 'Rutin olmadan ritüel, ritüel olmadan anlam',
      reflection: 'Sabahların nasıl başlıyor?',
      practice: '3 dakikalık kişisel sabah ritüeli oluştur',
      theme: TantraTheme.ritualIntent,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 23,
      title: 'Akşam Kapanışı',
      coreInsight: 'Gün bilinçli kapatılmalı',
      reflection: 'Bugünü nasıl onurlandırabilirsin?',
      practice: 'Günün 3 anını minnetle hatırla',
      theme: TantraTheme.ritualIntent,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 24,
      title: 'Geçiş Anları',
      coreInsight: 'Geçişler farkındalık noktalarıdır',
      reflection: 'Ev-iş, iş-ev arasında ne hissediyorsun?',
      practice: 'Her geçişte 3 nefes al',
      theme: TantraTheme.ritualIntent,
      durationMinutes: 1,
    ),
    TantraModule(
      id: 25,
      title: 'Kutsal Alan',
      coreInsight: 'Fiziksel alan içsel durumu etkiler',
      reflection: 'Evinde seni dinlendiren yer neresi?',
      practice: 'Küçük bir köşeyi kendi ritüel alanın yap',
      theme: TantraTheme.ritualIntent,
      durationMinutes: 10,
    ),

    // THEME: İlişkide Güven (26-30)
    TantraModule(
      id: 26,
      title: 'Güven Temeli',
      coreInsight: 'Güven inşa edilir, varsayılmaz',
      reflection: 'Güveni ne inşa eder sence?',
      practice: 'Bugün güvenilir bir davranış sergile',
      theme: TantraTheme.trustInRelationship,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 27,
      title: 'Sözün Değeri',
      coreInsight: 'Tutulmayan söz güveni aşındırır',
      reflection: 'Son tutmadığın söz neydi?',
      practice: 'Sadece tutacağın sözler ver',
      theme: TantraTheme.trustInRelationship,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 28,
      title: 'Şeffaflık',
      coreInsight: 'Şeffaflık güvenin oksijenidir',
      reflection: 'Neyi paylaşmaktan kaçınıyorsun?',
      practice: 'Küçük bir şeyi şeffafça paylaş',
      theme: TantraTheme.trustInRelationship,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 29,
      title: 'Affetme Pratiği',
      coreInsight: 'Affetmek bırakmaktır',
      reflection: 'Kimi affetmeye hazırsın?',
      practice: 'O kişiyi zihninde serbest bırak',
      theme: TantraTheme.trustInRelationship,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 30,
      title: 'Yeniden Başlangıç',
      coreInsight: 'Her an yeni başlangıç mümkündür',
      reflection: 'Neye yeniden başlamak istersin?',
      practice: 'Bugün temiz sayfa aç',
      theme: TantraTheme.trustInRelationship,
      durationMinutes: 3,
    ),

    // THEME: Yavaşlık & Dikkat (31-35)
    TantraModule(
      id: 31,
      title: 'Yavaşlamanın Gücü',
      coreInsight: 'Hız farkındalığı öldürür',
      reflection: 'Hayatın hangi alanı çok hızlı?',
      practice: 'Bir aktiviteyi yarı hızda yap',
      theme: TantraTheme.slownessAttention,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 32,
      title: 'Tek İş Odağı',
      coreInsight: 'Çoklu görev dikkat dağıtır',
      reflection: 'En son ne zaman tek şeye odaklandın?',
      practice: '15 dakika tek iş, telefon kapalı',
      theme: TantraTheme.slownessAttention,
      durationMinutes: 15,
    ),
    TantraModule(
      id: 33,
      title: 'Yemekle Bağ',
      coreInsight: 'Yemek farkındalık pratiğidir',
      reflection: 'Son yemeğini nasıl yedin?',
      practice: 'Bir öğünü sessizce, tadarak ye',
      theme: TantraTheme.slownessAttention,
      durationMinutes: 15,
    ),
    TantraModule(
      id: 34,
      title: 'Dikkatli Dinleme',
      coreInsight: 'Tam dikkat en büyük armağandır',
      reflection: 'Dinlerken aklın ne kadar başka yerde?',
      practice: 'Bugün birini %100 dikkatle dinle',
      theme: TantraTheme.slownessAttention,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 35,
      title: 'Detaylarda Güzellik',
      coreInsight: 'Güzellik dikkat edene görünür',
      reflection: 'Bugün neyi fark etmedin?',
      practice: 'Çevrende 5 güzel detay bul',
      theme: TantraTheme.slownessAttention,
      durationMinutes: 5,
    ),

    // THEME: Kendilik Şefkati (36-40)
    TantraModule(
      id: 36,
      title: 'İç Eleştirmen',
      coreInsight: 'En sert yargıç içimizdedir',
      reflection: 'Kendine ne söylüyorsun başarısız olduğunda?',
      practice: 'O sesi fark et, yumuşat',
      theme: TantraTheme.selfCompassion,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 37,
      title: 'Kendine Nazik Olmak',
      coreInsight: 'Şefkat başkasına vermeden önce içe akar',
      reflection: 'Kendine yeterince nazik misin?',
      practice: 'Bugün kendine bir iyilik yap',
      theme: TantraTheme.selfCompassion,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 38,
      title: 'Kusur Kabulü',
      coreInsight: 'Kusur insan olmanın parçasıdır',
      reflection: 'Hangi kusurunu kabullenmekte zorlanıyorsun?',
      practice: 'O kusura "merhaba" de',
      theme: TantraTheme.selfCompassion,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 39,
      title: 'Dinlenme Hakkı',
      coreInsight: 'Dinlenme üretkenliğin parçasıdır',
      reflection: 'Suçluluk duymadan ne kadar dinlenebiliyorsun?',
      practice: 'Bugün 15 dakika suçsuzca dinlen',
      theme: TantraTheme.selfCompassion,
      durationMinutes: 15,
    ),
    TantraModule(
      id: 40,
      title: 'Kendine Mektup',
      coreInsight: 'Yazı içsel diyalogu netleştirir',
      reflection: 'Kendine ne söylemek isterdin?',
      practice: '10 yıl önceki haline kısa mektup yaz',
      theme: TantraTheme.selfCompassion,
      durationMinutes: 10,
    ),

    // THEME: An'da Kalma (41-45)
    TantraModule(
      id: 41,
      title: 'Şimdi Farkındalığı',
      coreInsight: 'Geçmiş ve gelecek zihin üretir',
      reflection: 'Şu an zihnin nerede?',
      practice: '5 duyu ile şu anı tarifle',
      theme: TantraTheme.presentMoment,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 42,
      title: 'Düşünce Gözlemi',
      coreInsight: 'Düşünceler bulut gibi geçer',
      reflection: 'Hangi düşünce bugün seni ele geçirdi?',
      practice: 'Düşünceleri etiketlemeden izle',
      theme: TantraTheme.presentMoment,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 43,
      title: 'Duygu Dalgası',
      coreInsight: 'Duygular gelir ve gider',
      reflection: 'Hangi duyguya tutunuyorsun?',
      practice: 'Duyguyu dalga gibi gel-git olarak izle',
      theme: TantraTheme.presentMoment,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 44,
      title: 'Beklenti Bırakma',
      coreInsight: 'Beklenti anı gölgeler',
      reflection: 'Bu andan ne bekliyorsun?',
      practice: 'Beklentiyi fark et ve bırak',
      theme: TantraTheme.presentMoment,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 45,
      title: 'Mevcudiyet Pratiği',
      coreInsight: 'Mevcudiyet en değerli hediyedir',
      reflection: 'En son ne zaman tamamen oradaydın?',
      practice: '5 dakika hiçbir şey yapmadan ol',
      theme: TantraTheme.presentMoment,
      durationMinutes: 5,
    ),

    // THEME: Paylaşılan Ritimler (46-50)
    TantraModule(
      id: 46,
      title: 'Ortak Sessizlik',
      coreInsight: 'Sessizlik paylaşıldığında derinleşir',
      reflection: 'Kiminle sessiz kalabilirsin?',
      practice: 'Biriyle 5 dakika sessizce otur',
      theme: TantraTheme.sharedRhythms,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 47,
      title: 'Senkron Hareket',
      coreInsight: 'Birlikte hareket bağ kurar',
      reflection: 'Kiminle aynı ritimde hareket ediyorsun?',
      practice: 'Biriyle yürüyüş sırasında adım senkronla',
      theme: TantraTheme.sharedRhythms,
      durationMinutes: 10,
    ),
    TantraModule(
      id: 48,
      title: 'Paylaşılan Niyet',
      coreInsight: 'Ortak niyet gücü katlıyor',
      reflection: 'Kiminle ortak hedefin var?',
      practice: 'Bir yakınla günün niyetini paylaş',
      theme: TantraTheme.sharedRhythms,
      durationMinutes: 3,
    ),
    TantraModule(
      id: 49,
      title: 'Ritüel Ortaklığı',
      coreInsight: 'Paylaşılan ritüel ilişkiyi güçlendirir',
      reflection: 'Kiminle düzenli paylaşımın var?',
      practice: 'Haftalık ortak ritüel başlat',
      theme: TantraTheme.sharedRhythms,
      durationMinutes: 5,
    ),
    TantraModule(
      id: 50,
      title: 'Minnettarlık Paylaşımı',
      coreInsight: 'Paylaşılan minnettarlık çoğalır',
      reflection: 'Kime teşekkür etmedin?',
      practice: 'Bugün birine spesifik teşekkür et',
      theme: TantraTheme.sharedRhythms,
      durationMinutes: 3,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // QUESTIONS POOL (60+)
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<TantraQuestion> _allQuestions = [
    // Farkındalık Açma
    TantraQuestion(
      question: 'Şu an bedeninde ne hissediyorsun?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'Zihnin şu an nerede?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'Son ne zaman tamamen şimdiki andaydın?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'Bugün hangi düşünce seni en çok meşgul etti?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'Nefesini son ne zaman fark ettin?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'Çevrende şu an hangi ses var?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'Bedeninin en gergin yeri neresi?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'Şu an hangi duyguyu taşıyorsun?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'Bugün kendini nasıl tanımlarsın tek kelimeyle?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),
    TantraQuestion(
      question: 'En son ne zaman durup baktın?',
      purpose: TantraQuestionPurpose.awarenessOpening,
    ),

    // Duygusal Netlik
    TantraQuestion(
      question: 'Bugün baskın duygum ne?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Bu duygu nereden geliyor?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Bedenimde bu duygu nerede oturuyor?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Bu duyguyla ne yapmak istiyorum?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Hangi duyguyu bastırıyorum?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Kendimi nasıl hissetmek istiyorum?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Bu duygu bana ne söylüyor?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Bu duyguyla barışık mıyım?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Hangi duygudan kaçınıyorum?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),
    TantraQuestion(
      question: 'Bugün ne beni mutlu etti?',
      purpose: TantraQuestionPurpose.emotionalClarity,
    ),

    // İlişkisel Bağ
    TantraQuestion(
      question: 'Bugün kimi düşündüm?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Kime teşekkür etmedim?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Kiminle daha derin bağ kurmak istiyorum?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Hangi ilişkim bakım istiyor?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Kimi anlamakta zorlanıyorum?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Kiminle daha fazla zaman geçirmeliyim?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Hangi sözümü tutmadım?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Kime özür borçluyum?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Kim beni şu an en iyi anlıyor?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),
    TantraQuestion(
      question: 'Kiminle sessiz kalabiliyorum?',
      purpose: TantraQuestionPurpose.relationalBond,
    ),

    // Ritüel Niyeti
    TantraQuestion(
      question: 'Bu pratiğe ne için geliyorum?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Bu andan ne almak istiyorum?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Neyi bırakmaya hazırım?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Hangi enerjiyi çağırıyorum?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Kalbim şu an ne istiyor?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Bu pratik bana ne kazandırabilir?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Niyetim net mi?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Bu anı nasıl onurlandırabilirim?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Kendime ne söz veriyorum?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),
    TantraQuestion(
      question: 'Bu deneyime nasıl açık olabilirim?',
      purpose: TantraQuestionPurpose.preRitualIntent,
    ),

    // Günlük Check-in
    TantraQuestion(
      question: 'Dün geceyi nasıl geçirdim?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Enerji seviyem nasıl?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Bugün için önceliğim ne?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Neye minnettarım?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Neleri erteliyorum?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Bugün kendime ne vaat ediyorum?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Hangi alışkanlığımı değiştirmek istiyorum?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Bugün kimi arayacağım?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Kendime ne kadar zaman ayıracağım?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
    TantraQuestion(
      question: 'Gün sonunda nasıl hissetmek istiyorum?',
      purpose: TantraQuestionPurpose.dailyCheckIn,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // FAQ RESPONSES
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, String> faqResponses = {
    'uygunluk':
        'İçeriklerimiz farkındalık, nefes ve duygusal bağlanma odaklıdır. Cinsel içerik bulunmaz. Her yaş ve ilişki durumuna uygundur.',
    'baslangic':
        'Nefes & Farkındalık bölümü ideal başlangıç noktasıdır. Günde 3-5 dakika yeterli. Pratikler basit ve evde yapılabilir.',
    'siklik':
        'Günlük kısa pratikler idealdir. Haftada 3 kez düzenli olmak yeterli. Kalite, miktar değil. Zorlamadan, akışla.',
    'solo':
        'Çoğu pratik bireyseldir. Kendinle bağ kurmak temeldir. Partner pratikleri opsiyoneldir. Solo yolculuk tamamen geçerli.',
    'spiritüel':
        'İkisi de, dengeyle. Spiritüel çerçeve, pratik uygulamalar. Dogma yok, deneyim var. Kendi anlamını sen bulursun.',
    'gizlilik':
        'Veriler cihazda kalır. Paylaşım tamamen opsiyonel. Pratik geçmişi şifreli. Üçüncü tarafla paylaşım yok.',
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BÖLÜM 1: ÇAKRA TANTRA SİSTEMİ
  // Yedi Ana Çakra - Ezoterik Bilgelik
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, Map<String, dynamic>> chakraSystem = {
    // ─────────────────────────────────────────────────────────────────────────
    // 1. MULADHARA - KÖK ÇAKRA
    // ─────────────────────────────────────────────────────────────────────────
    'muladhara': {
      'name': 'Muladhara',
      'nameTr': 'Kök Çakra',
      'sanskritMeaning': 'Kök Destek - Mula (Kök) + Adhara (Destek)',
      'location': 'Omurganın tabanı, kuyruk sokumu',
      'element': 'Toprak (Prithvi)',
      'color': 'Koyu Kırmızı',
      'colorHex': '#8B0000',
      'bijaMantra': 'LAM',
      'bijaMantraAciklama':
          'LAM mantrasının titreşimi toprak elementini uyandırır. '
          'Derin, guttural bir sesle söylenir ve kök çakranın enerji merkezini aktive eder.',
      'symbol': 'Dört yapraklı lotus, içinde sarı kare (toprak yantra)',
      'petals': 4,
      'petalMantras': ['Vam', 'Şam', 'Şham', 'Sam'],
      'deity': {
        'masculine': 'Brahma - Yaratıcı Tanrı',
        'feminine': 'Dakini Shakti - Kırmızı Gözlü Tanrıça',
      },
      'physicalAssociations': [
        'Böbrekler ve böbrek üstü bezleri',
        'Omurga ve iskelet sistemi',
        'Kalın bağırsak ve rektum',
        'Bacaklar, dizler, ayaklar',
        'Kemik iliği ve kan üretimi',
        'Bağışıklık sisteminin temeli',
        'Dişler ve tırnaklar',
      ],
      'emotionalAssociations': [
        'Güvenlik ve emniyet duygusu',
        'Hayatta kalma içgüdüleri',
        'Topraklanma ve istikrar',
        'Aile ve kabile bağları',
        'Maddi güvenlik kaygıları',
        'Fiziksel dünyaya aidiyet',
        'Temel güven duygusu',
      ],
      'blockedSymptoms': {
        'physical': [
          'Kronik yorgunluk ve enerji düşüklüğü',
          'Bel ve bacak ağrıları',
          'Sindirim sorunları, kabızlık',
          'Bağışıklık sistemi zayıflığı',
          'Kemik ve eklem problemleri',
          'Ayak soğukluğu ve dolaşım bozukluğu',
        ],
        'emotional': [
          'Sürekli endişe ve korku',
          'Güvensizlik ve paranoya',
          'Maddi takıntılar veya israf',
          'Kendini evsiz veya köksüz hissetme',
          'Aşırı materyalizm veya maddeye kayıtsızlık',
          'Hayatta kalma korkusu',
        ],
        'spiritual': [
          'Ruhsal yolculuğa başlayamama',
          'Meditasyonda topraklanma zorluğu',
          'Bedenle bağlantı kopukluğu',
          'Doğayla kopukluk hissi',
        ],
      },
      'balancedSymptoms': {
        'physical': [
          'Güçlü ve dirençli beden',
          'Sağlıklı sindirim sistemi',
          'Dengeli enerji seviyeleri',
          'Güçlü bağışıklık sistemi',
        ],
        'emotional': [
          'Derin güvenlik hissi',
          'Maddi konularda denge',
          'Aileden bağımsız sağlıklı bağlar',
          'İçsel istikrar ve huzur',
        ],
        'spiritual': [
          'Güçlü topraklanma yeteneği',
          'Bedenle uyumlu ruhsal pratik',
          'Fiziksel dünyada kutsal olanı görme',
        ],
      },
      'kundaliniStage': {
        'description':
            'Kundalini Shakti burada uyur. Üç buçuk kıvrım halinde '
            'sarılmış yılan, Shiva lingamının etrafında bekler. Uyanış burada başlar.',
        'awakeningSigns': [
          'Kuyruk sokumunda ısı veya titreşim',
          'Omurgada elektriksel akımlar',
          'Spontan beden hareketleri (kriyas)',
          'Derin topraklanma deneyimleri',
        ],
        'practices': [
          'Mulabandha (kök kilidi) pratiği',
          'Toprak elementli meditasyonlar',
          'Kırmızı yiyeceklerle beslenme',
          'Yalın ayak yürüyüşler',
        ],
      },
      'meditationTechnique': {
        'name': 'Muladhara Dhyana',
        'duration': '20-30 dakika',
        'steps': [
          'Rahat bir oturma pozisyonunda yerleş, tercihen yerde otur.',
          'Gözlerini kapat ve nefesini derinleştir.',
          'Dikkatini kuyruk sokumuna yönelt.',
          'Orada dönen koyu kırmızı bir enerji topu hayal et.',
          'Her nefes alışta bu topun büyüdüğünü gör.',
          'LAM mantrasını içinden veya sesli olarak tekrarla.',
          'Toprak enerjisinin bacaklarından yükseldiğini hisset.',
          'Köklerinin derinlere uzandığını görselleştir.',
          'Bu köklerin seni dünyaya bağladığını hisset.',
          '21 kez LAM mantrasını tekrarla.',
          'Sessizlikte birkaç dakika kal.',
          'Yavaşça gözlerini aç.',
        ],
      },
      'partnerPractice': {
        'name': 'Kök Çakra Senkronizasyonu',
        'description': 'İki kişinin kök çakralarını uyumlaması',
        'steps': [
          'Karşı karşıya oturun, dizleriniz değsin.',
          'Ellerinizi birbirinizin dizlerine koyun.',
          'Birlikte derin nefesler alın.',
          'Aynı anda LAM mantrasını söyleyin.',
          'Aranızda kırmızı enerji köprüsü hayal edin.',
          'Bu enerji köprüsünün sizi toprakladığını hissedin.',
          '7 dakika bu bağlantıda kalın.',
        ],
      },
      'healingAffirmations': [
        'Güvendeyim ve korunuyorum.',
        'Dünyada yerim var.',
        'Bedenim sağlıklı ve güçlü.',
        'Tüm ihtiyaçlarım karşılanıyor.',
        'Köklerim derinlere uzanıyor.',
        'Hayatta kalmak için her şeye sahibim.',
        'Dünya beni destekliyor.',
        'Burada, şimdi, tam olarak varım.',
      ],
      'healingRituals': [
        {
          'name': 'Toprak Banyosu',
          'description': 'Toprakla doğrudan temas ritüeli',
          'steps': [
            'Doğada sessiz bir yer bul.',
            'Yalın ayak toprağa bas.',
            'Ellerini toprağa koy.',
            'Olumsuz enerjiyi toprağa ver.',
            'Toprağın şifa enerjisini al.',
            '15-20 dakika bu bağlantıda kal.',
          ],
        },
        {
          'name': 'Kırmızı Mum Ritüeli',
          'description': 'Ateş ve kök çakra aktivasyonu',
          'steps': [
            'Kırmızı bir mum yak.',
            'Alev önünde meditasyona otur.',
            'Alevin sıcaklığını kökünde hisset.',
            'Korkularını aleve ver.',
            'Güvenlik niyetini belirle.',
            'Mumu güvenle söndür.',
          ],
        },
      ],
      'crystals': [
        'Kırmızı Jasper',
        'Hematit',
        'Siyah Turmalin',
        'Garnet',
        'Obsidyen',
      ],
      'essentialOils': ['Paçuli', 'Sedir', 'Vetiver', 'Sandal Ağacı'],
      'foods': [
        'Kök sebzeler',
        'Kırmızı meyveler',
        'Protein',
        'Toprak altı yiyecekler',
      ],
      'yogaAsanas': ['Tadasana', 'Virabhadrasana', 'Malasana', 'Balasana'],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // 2. SVADHISTHANA - SAKRAL ÇAKRA
    // ─────────────────────────────────────────────────────────────────────────
    'svadhisthana': {
      'name': 'Svadhisthana',
      'nameTr': 'Sakral Çakra',
      'sanskritMeaning': 'Kendi Yeri - Sva (Kendi) + Adhisthana (Yer)',
      'location': 'Göbek altı, sakrum bölgesi',
      'element': 'Su (Apas)',
      'color': 'Turuncu',
      'colorHex': '#FF6600',
      'bijaMantra': 'VAM',
      'bijaMantraAciklama':
          'VAM mantrasının titreşimi su elementini uyandırır. '
          'Akışkan ve yumuşak bir sesle söylenir, yaratıcılığı ve hazzı aktive eder.',
      'symbol': 'Altı yapraklı lotus, içinde hilal ay (su yantra)',
      'petals': 6,
      'petalMantras': ['Bam', 'Bham', 'Mam', 'Yam', 'Ram', 'Lam'],
      'deity': {
        'masculine': 'Vishnu - Koruyucu Tanrı',
        'feminine': 'Rakini Shakti - Mavi Lotus Tanrıça',
      },
      'physicalAssociations': [
        'Üreme organları',
        'Böbrekler ve mesane',
        'Kalça ve pelvis',
        'Lenf sistemi',
        'Vücut sıvıları',
        'Cinsel bezler',
        'Bağırsak alt kısmı',
      ],
      'emotionalAssociations': [
        'Haz ve zevk alma kapasitesi',
        'Yaratıcılık ve üretkenlik',
        'Cinsellik ve tutku',
        'Duygusal akışkanlık',
        'İlişkilerde yakınlık',
        'Değişime uyum sağlama',
        'Kendinle barışık olma',
      ],
      'blockedSymptoms': {
        'physical': [
          'Üreme sistemi sorunları',
          'Mesane enfeksiyonları',
          'Bel ağrıları',
          'Cinsel işlev bozuklukları',
          'Hormonal dengesizlikler',
          'Böbrek sorunları',
        ],
        'emotional': [
          'Duygusal donukluk',
          'Yaratıcılık tıkanması',
          'Haz alma zorluğu',
          'Cinsel sorunlar veya takıntılar',
          'Bağımlılık eğilimleri',
          'Suçluluk duyguları',
        ],
        'spiritual': [
          'Yaşam enerjisinde düşüklük',
          'Shakti enerjisine erişememe',
          'Akış halinde olamama',
          'Yaratıcı ilhamdan yoksunluk',
        ],
      },
      'balancedSymptoms': {
        'physical': [
          'Sağlıklı üreme sistemi',
          'Dengeli hormonlar',
          'Esnek ve hareketli kalça',
          'İyi hidrasyon ve sıvı dengesi',
        ],
        'emotional': [
          'Sağlıklı haz alma kapasitesi',
          'Akan yaratıcılık',
          'Dengeli cinsel enerji',
          'Duygusal esneklik',
        ],
        'spiritual': [
          'Shakti enerjisiyle bağlantı',
          'Yaratıcı ilham akışı',
          'Yaşam enerjisinin kutlanması',
        ],
      },
      'kundaliniStage': {
        'description':
            'Kundalini burada ilk uyanışını deneyimler. Su elementi '
            'enerjinin akışını kolaylaştırır. Shakti burada dans etmeye başlar.',
        'awakeningSigns': [
          'Pelvis bölgesinde sıcaklık',
          'Artan yaratıcılık dürtüsü',
          'Duygusal salınımlar',
          'Rüyaların yoğunlaşması',
        ],
        'practices': [
          'Kalça açıcı yoga hareketleri',
          'Su elementli meditasyonlar',
          'Dans ve serbest hareket',
          'Yaratıcı sanat aktiviteleri',
        ],
      },
      'meditationTechnique': {
        'name': 'Svadhisthana Dhyana',
        'duration': '20-30 dakika',
        'steps': [
          'Rahat bir pozisyonda otur, kalçalarını gevşet.',
          'Gözlerini kapat ve nefesini doğallaştır.',
          'Dikkatini göbek altına yönelt.',
          'Orada dönen turuncu bir enerji topu hayal et.',
          'Bu topun su gibi akışkan olduğunu hisset.',
          'VAM mantrasını akışkan bir sesle tekrarla.',
          'Duygularının su gibi aktığını izle.',
          'Yaratıcılığının kaynağına bağlan.',
          'Haz alma hakkını onayla.',
          '21 kez VAM mantrasını tekrarla.',
          'Akışta birkaç dakika kal.',
          'Yavaşça gözlerini aç.',
        ],
      },
      'partnerPractice': {
        'name': 'Sakral Enerji Dansı',
        'description': 'Çiftlerin yaratıcı enerji akışı',
        'steps': [
          'Karşı karşıya durun, birbirinize bakın.',
          'Eller kalça hizasında, avuçlar birbirine dönük.',
          'Yavaş, dairesel kalça hareketleri yapın.',
          'Aynı anda VAM mantrasını söyleyin.',
          'Aranızda turuncu enerji akışı hayal edin.',
          'Bu enerjinin dans ettiğini hissedin.',
          '7 dakika bu akışta kalın.',
        ],
      },
      'healingAffirmations': [
        'Haz almak doğal hakkım.',
        'Duygularım özgürce akıyor.',
        'Yaratıcılığım sınırsız.',
        'Bedenimle barışığım.',
        'Değişime açığım.',
        'Hayatın tadını çıkarıyorum.',
        'Tutkularım kutsal.',
        'Kendimi sevmeme izin veriyorum.',
      ],
      'healingRituals': [
        {
          'name': 'Su Arınma Ritüeli',
          'description': 'Su elementiyle sakral çakra temizliği',
          'steps': [
            'Ilık bir banyo hazırla.',
            'Turuncu çiçekler veya turuncu tuz ekle.',
            'Suya girerken VAM mantrasını söyle.',
            'Suyun seni arındırdığını hisset.',
            'Tüm blokajların suyla aktığını hayal et.',
            '20 dakika bu arınmada kal.',
          ],
        },
        {
          'name': 'Ay Işığı Meditasyonu',
          'description': 'Hilal ay enerjisiyle çalışma',
          'steps': [
            'Hilal ay gecesi dışarı çık.',
            'Ay ışığının sakral çakrana döküldüğünü hayal et.',
            'Bu gümüşi enerjinin seni beslediğini hisset.',
            'Kadınsal/alıcı enerjini aktive et.',
            'Ayın döngüsüyle uyumlan.',
            '15 dakika bu bağlantıda kal.',
          ],
        },
      ],
      'crystals': [
        'Karneol',
        'Turuncu Kalsit',
        'Ay Taşı',
        'Mercan',
        'Kehribar',
      ],
      'essentialOils': ['Ylang Ylang', 'Sandal', 'Portakal', 'Neroli'],
      'foods': ['Turuncu meyveler', 'Bal kabağı', 'Havuç', 'Badem'],
      'yogaAsanas': [
        'Baddha Konasana',
        'Upavistha Konasana',
        'Bhujangasana',
        'Pigeon Pose',
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // 3. MANIPURA - SOLAR PLEKSUS ÇAKRA
    // ─────────────────────────────────────────────────────────────────────────
    'manipura': {
      'name': 'Manipura',
      'nameTr': 'Solar Pleksus Çakra',
      'sanskritMeaning': 'Mücevher Şehri - Mani (Mücevher) + Pura (Şehir)',
      'location': 'Göbek üstü, mide bölgesi',
      'element': 'Ateş (Agni)',
      'color': 'Sarı',
      'colorHex': '#FFCC00',
      'bijaMantra': 'RAM',
      'bijaMantraAciklama':
          'RAM mantrasının titreşimi ateş elementini uyandırır. '
          'Güçlü ve kararlı bir sesle söylenir, iradeyi ve gücü aktive eder.',
      'symbol': 'On yapraklı lotus, içinde aşağı bakan üçgen (ateş yantra)',
      'petals': 10,
      'petalMantras': [
        'Dam',
        'Dham',
        'Nam',
        'Tam',
        'Tham',
        'Dam',
        'Dham',
        'Nam',
        'Pam',
        'Pham',
      ],
      'deity': {
        'masculine': 'Rudra - Dönüşüm Tanrısı',
        'feminine': 'Lakini Shakti - Üç Yüzlü Tanrıça',
      },
      'physicalAssociations': [
        'Sindirim sistemi',
        'Mide ve pankreas',
        'Karaciğer ve safra kesesi',
        'Dalak',
        'Adrenal bezler',
        'Metabolizma',
        'Göbek bölgesi kasları',
      ],
      'emotionalAssociations': [
        'Kişisel güç ve irade',
        'Öz güven ve öz değer',
        'Karar verme yetisi',
        'Motivasyon ve kararlılık',
        'Ego ve kimlik',
        'Kontrol ve özerklik',
        'Cesaret ve risk alma',
      ],
      'blockedSymptoms': {
        'physical': [
          'Sindirim sorunları',
          'Mide ülseri ve gastrit',
          'Diyabet veya kan şekeri sorunları',
          'Karaciğer problemleri',
          'Kronik yorgunluk',
          'Kas zayıflığı',
        ],
        'emotional': [
          'Düşük öz güven',
          'Karar verememe',
          'Kontrolcülük veya güçsüzlük',
          'Öfke patlamaları',
          'Mükemmeliyetçilik',
          'Başarısızlık korkusu',
        ],
        'spiritual': [
          'İrade gücü eksikliği',
          'Ruhsal disiplin zorluğu',
          'İç ateşe erişememe',
          'Dönüşüm korkusu',
        ],
      },
      'balancedSymptoms': {
        'physical': [
          'Sağlıklı sindirim',
          'Dengeli metabolizma',
          'Güçlü çekirdek kasları',
          'İyi enerji seviyeleri',
        ],
        'emotional': [
          'Sağlıklı öz güven',
          'Net karar verme',
          'Dengeli ego',
          'Yapıcı irade gücü',
        ],
        'spiritual': [
          'İç ateşle bağlantı',
          'Dönüşüm kapasitesi',
          'Spiritüel disiplin',
        ],
      },
      'kundaliniStage': {
        'description':
            'Kundalini burada ateşle karşılaşır. Sindirici ateş (Jatharagni) '
            'enerjiyi rafine eder. Ego burada dönüşür, irade güçlenir.',
        'awakeningSigns': [
          'Mide bölgesinde ısı',
          'Artan irade gücü',
          'Ego dönüşümü deneyimleri',
          'Spontan oruç isteği',
        ],
        'practices': [
          'Kapalabhati pranayama',
          'Ateş meditasyonları',
          'Güneş selamlama pratiği',
          'Çekirdek güçlendirme',
        ],
      },
      'meditationTechnique': {
        'name': 'Manipura Dhyana',
        'duration': '20-30 dakika',
        'steps': [
          'Dik bir pozisyonda otur, omurgayı uzat.',
          'Gözlerini kapat ve karnını gevşet.',
          'Dikkatini göbek üstüne yönelt.',
          'Orada parlayan sarı bir güneş hayal et.',
          'Bu güneşin içinden ateş yükseliyor.',
          'RAM mantrasını güçlü bir sesle tekrarla.',
          'İrade gücünün arttığını hisset.',
          'İçsel güneşinin parladığını gör.',
          'Gücünü ve cesaretini onayla.',
          '21 kez RAM mantrasını tekrarla.',
          'Ateşin dengelendiğini hisset.',
          'Yavaşça gözlerini aç.',
        ],
      },
      'partnerPractice': {
        'name': 'Güç Çemberi',
        'description': 'Çiftlerin irade enerjisi paylaşımı',
        'steps': [
          'Karşı karşıya oturun, eller göbek hizasında.',
          'Avuçlarınızı birbirinizin karnına koyun.',
          'Birlikte derin karından nefesler alın.',
          'Aynı anda RAM mantrasını söyleyin.',
          'Aranızda altın ışık köprüsü hayal edin.',
          'Bu enerjinin ikinizi güçlendirdiğini hissedin.',
          '7 dakika bu bağlantıda kalın.',
        ],
      },
      'healingAffirmations': [
        'Gücüm içimde.',
        'Kararlarıma güveniyorum.',
        'Cesaretim sınırsız.',
        'Değerli ve yeterliyim.',
        'İradem güçlü.',
        'Hedeflerime ulaşıyorum.',
        'İç ateşim parlıyor.',
        'Kendime sahip çıkıyorum.',
      ],
      'healingRituals': [
        {
          'name': 'Güneş Doğumu Ritüeli',
          'description': 'Güneş enerjisiyle solar pleksus aktivasyonu',
          'steps': [
            'Güneş doğarken doğuya dön.',
            'Güneşin ışığını karnına çek.',
            'RAM mantrasını güneşe söyle.',
            'Güneşin gücünün sana aktığını hisset.',
            'Günün niyetini güçle belirle.',
            '10 dakika güneşle bağlantıda kal.',
          ],
        },
        {
          'name': 'Mum Bakışı (Trataka)',
          'description': 'Ateş odaklı konsantrasyon',
          'steps': [
            'Sarı bir mum yak.',
            'Göz hizasında, bir kol mesafesinde yerleştir.',
            'Aleve kırpmadan bak.',
            'Gözlerin sulanınca kapat.',
            'Alevin imajını içinde tut.',
            'İç ateşini canlandır.',
            '15 dakika pratik yap.',
          ],
        },
      ],
      'crystals': ['Sitrin', 'Kaplan Gözü', 'Sarı Topaz', 'Amber', 'Pirit'],
      'essentialOils': ['Limon', 'Zencefil', 'Karanfil', 'Biberiye'],
      'foods': ['Sarı yiyecekler', 'Tahıllar', 'Baharatlar', 'Limon'],
      'yogaAsanas': [
        'Navasana',
        'Ardha Matsyendrasana',
        'Dhanurasana',
        'Ustrasana',
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // 4. ANAHATA - KALP ÇAKRA
    // ─────────────────────────────────────────────────────────────────────────
    'anahata': {
      'name': 'Anahata',
      'nameTr': 'Kalp Çakra',
      'sanskritMeaning': 'Vurulmamış Ses - Kozmik titreşimin kaynağı',
      'location': 'Göğüs merkezi, kalp bölgesi',
      'element': 'Hava (Vayu)',
      'color': 'Yeşil (Pembe ikincil)',
      'colorHex': '#00FF00',
      'bijaMantra': 'YAM',
      'bijaMantraAciklama':
          'YAM mantrasının titreşimi hava elementini uyandırır. '
          'Yumuşak ve açık bir sesle söylenir, sevgiyi ve şefkati aktive eder.',
      'symbol':
          'On iki yapraklı lotus, içinde altı köşeli yıldız (iki üçgenin birleşimi)',
      'petals': 12,
      'petalMantras': [
        'Kam',
        'Kham',
        'Gam',
        'Gham',
        'Ngam',
        'Cham',
        'Chham',
        'Jam',
        'Jham',
        'Nyam',
        'Tam',
        'Tham',
      ],
      'deity': {
        'masculine': 'Ishana - Shiva\'nın Barış Formu',
        'feminine': 'Kakini Shakti - Altın Tanrıça',
      },
      'physicalAssociations': [
        'Kalp ve dolaşım sistemi',
        'Akciğerler ve solunum',
        'Timus bezi (bağışıklık)',
        'Göğüs kafesi',
        'Kollar ve eller',
        'Omuzlar',
        'Kan basıncı düzenleme',
      ],
      'emotionalAssociations': [
        'Koşulsuz sevgi',
        'Şefkat ve merhamet',
        'Affetme kapasitesi',
        'Empati ve anlayış',
        'Kendini sevme',
        'Bağlanma ve yakınlık',
        'Keder ve kayıp işleme',
      ],
      'blockedSymptoms': {
        'physical': [
          'Kalp sorunları',
          'Kan basıncı dengesizlikleri',
          'Solunum zorlukları',
          'Astım ve alerji',
          'Omuz ve kol ağrıları',
          'Bağışıklık zayıflığı',
        ],
        'emotional': [
          'Sevgi vermekte zorluk',
          'Sevgi almakta zorluk',
          'Affetme zorluğu',
          'Yalnızlık ve izolasyon',
          'Bağlanma korkusu',
          'Aşırı fedakarlık',
        ],
        'spiritual': [
          'Evrensel sevgiye kapalılık',
          'Birlik bilincinden uzaklık',
          'Kalp merkezli yaşayamama',
          'Şefkat eksikliği',
        ],
      },
      'balancedSymptoms': {
        'physical': [
          'Sağlıklı kalp ve dolaşım',
          'Derin ve özgür nefes',
          'Güçlü bağışıklık sistemi',
          'Enerji akışı dengesi',
        ],
        'emotional': [
          'Koşulsuz sevgi kapasitesi',
          'Sağlıklı sınırlarla şefkat',
          'Affetme kolaylığı',
          'Derin bağlanma yetisi',
        ],
        'spiritual': [
          'Evrensel sevgiyle bağlantı',
          'Birlik bilinci deneyimi',
          'Kalp merkezli yaşam',
        ],
      },
      'kundaliniStage': {
        'description':
            'Kundalini kalp çakrasına ulaştığında büyük dönüşüm başlar. '
            'Alt üç çakra (maddi) ile üst üç çakra (spiritüel) burada birleşir. '
            'Shiva ve Shakti\'nin ilk buluşması burada gerçekleşir.',
        'awakeningSigns': [
          'Göğüste genişleme hissi',
          'Spontan sevgi dalgaları',
          'Evrensel birlik deneyimleri',
          'Affetme kolaylığı',
        ],
        'practices': [
          'Metta (sevgi-şefkat) meditasyonu',
          'Kalp açıcı yoga pozları',
          'Nefes çalışmaları',
          'Doğada zaman geçirme',
        ],
      },
      'meditationTechnique': {
        'name': 'Anahata Dhyana',
        'duration': '20-30 dakika',
        'steps': [
          'Rahat bir pozisyonda otur, göğsünü aç.',
          'Gözlerini kapat ve kalbine odaklan.',
          'Ellerini kalbinin üstüne koy.',
          'Orada parlayan yeşil bir ışık hayal et.',
          'Bu ışığın her nefesle genişlediğini gör.',
          'YAM mantrasını yumuşak bir sesle tekrarla.',
          'Sevginin kalbinden taştığını hisset.',
          'Bu sevginin tüm varlıklara ulaştığını gör.',
          'Kendini affet, başkalarını affet.',
          '21 kez YAM mantrasını tekrarla.',
          'Sevgi içinde birkaç dakika kal.',
          'Yavaşça gözlerini aç.',
        ],
      },
      'partnerPractice': {
        'name': 'Kalp Köprüsü',
        'description': 'Çiftlerin kalp enerjisi birleşimi',
        'steps': [
          'Karşı karşıya oturun, göz hizasında.',
          'Sağ elinizi birbirinizin kalbine koyun.',
          'Sol elinizi kendi kalbinize koyun.',
          'Birlikte derin göğüs nefesleri alın.',
          'Aynı anda YAM mantrasını söyleyin.',
          'Kalplerınız arasında yeşil ışık köprüsü hayal edin.',
          'Bu köprüden sevginin aktığını hissedin.',
          '11 dakika bu bağlantıda kalın.',
          'Birbirinize teşekkür edin.',
        ],
      },
      'healingAffirmations': [
        'Sevgi her yerde.',
        'Sevilmeye layığım.',
        'Kalbim açık ve güvende.',
        'Affediyorum ve özgürleşiyorum.',
        'Şefkat doğam.',
        'Sevgi veriyorum, sevgi alıyorum.',
        'Tüm varlıklarla birim.',
        'Kalbim koşulsuz seviyor.',
      ],
      'healingRituals': [
        {
          'name': 'Gül Yaprağı Ritüeli',
          'description': 'Gül enerjisiyle kalp açma',
          'steps': [
            'Pembe veya kırmızı gül yaprakları topla.',
            'Sessiz bir alan oluştur.',
            'Yaprakları kalbine yaklaştır.',
            'Her yaprakla bir affetme niyeti belirle.',
            'Yaprakları suya veya toprağa bırak.',
            'Sevgi niyetini evrene gönder.',
          ],
        },
        {
          'name': 'Şefkat Meditasyonu',
          'description': 'Metta Bhavana - Sevgi-Şefkat pratiği',
          'steps': [
            'Rahat bir pozisyonda otur.',
            'Önce kendine sevgi gönder.',
            'Sonra sevdiklerine sevgi gönder.',
            'Ardından tanımadıklarına sevgi gönder.',
            'Son olarak zor kişilere sevgi gönder.',
            'Tüm varlıklara sevgi gönder.',
            '20 dakika bu akışta kal.',
          ],
        },
      ],
      'crystals': [
        'Gül Kuvars',
        'Yeşil Aventurin',
        'Yeşim',
        'Rodokrozit',
        'Malakit',
      ],
      'essentialOils': ['Gül', 'Yasemin', 'Bergamot', 'Melissa'],
      'foods': ['Yeşil yapraklı sebzeler', 'Yeşil çay', 'Brokoli', 'Avokado'],
      'yogaAsanas': ['Ustrasana', 'Bhujangasana', 'Matsyasana', 'Gomukhasana'],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // 5. VISHUDDHA - BOĞAZ ÇAKRA
    // ─────────────────────────────────────────────────────────────────────────
    'vishuddha': {
      'name': 'Vishuddha',
      'nameTr': 'Boğaz Çakra',
      'sanskritMeaning': 'Arınma Merkezi - Visha (Zehir) + Shuddhi (Arınma)',
      'location': 'Boğaz, boyun bölgesi',
      'element': 'Eter/Uzay (Akasha)',
      'color': 'Mavi',
      'colorHex': '#00BFFF',
      'bijaMantra': 'HAM',
      'bijaMantraAciklama':
          'HAM mantrasının titreşimi eter elementini uyandırır. '
          'Açık ve net bir sesle söylenir, ifadeyi ve iletişimi aktive eder.',
      'symbol': 'On altı yapraklı lotus, içinde daire (eter yantra)',
      'petals': 16,
      'petalMantras': [
        'Am',
        'Aam',
        'Im',
        'Iim',
        'Um',
        'Uum',
        'Rm',
        'Rrm',
        'Lrm',
        'Llrm',
        'Em',
        'Aim',
        'Om',
        'Aum',
        'Am',
        'Ah',
      ],
      'deity': {
        'masculine': 'Sadashiva - Sonsuz Shiva',
        'feminine': 'Shakini - Beyaz Tanrıça',
      },
      'physicalAssociations': [
        'Tiroit ve paratiroit bezleri',
        'Boğaz ve ses telleri',
        'Boyun omurları',
        'Çene ve dil',
        'Kulaklar',
        'Üst omurga',
        'Bronşlar',
      ],
      'emotionalAssociations': [
        'Özgün ifade',
        'Hakikati konuşma',
        'Yaratıcı iletişim',
        'Dinleme kapasitesi',
        'Otantik ses',
        'Artistik ifade',
        'İç bilgeliği paylaşma',
      ],
      'blockedSymptoms': {
        'physical': [
          'Tiroit sorunları',
          'Boğaz enfeksiyonları',
          'Boyun ağrıları',
          'Ses kısıklığı',
          'Çene gerginliği',
          'Kulak sorunları',
        ],
        'emotional': [
          'İfade zorluğu',
          'Yalan veya abartı eğilimi',
          'Çekingen iletişim',
          'Dinleme zorluğu',
          'Otantik olamama',
          'Eleştiri korkusu',
        ],
        'spiritual': [
          'İç sese erişememe',
          'Mantra pratiğinde zorluk',
          'Hakikati ifade edememe',
          'Evrensel sese kapalılık',
        ],
      },
      'balancedSymptoms': {
        'physical': [
          'Sağlıklı tiroit fonksiyonu',
          'Net ve güçlü ses',
          'Esnek boyun',
          'Sağlıklı solunum',
        ],
        'emotional': [
          'Özgün ve net ifade',
          'Aktif ve empatik dinleme',
          'Hakikati cesaretle söyleme',
          'Yaratıcı iletişim',
        ],
        'spiritual': [
          'İç sesle uyum',
          'Mantra gücü',
          'Evrensel hakikate açıklık',
        ],
      },
      'kundaliniStage': {
        'description':
            'Kundalini boğaz çakrasına ulaştığında Nada (kozmik ses) '
            'deneyimlenir. Eter elementi sınırsız ifade alanı açar. Hakikat burada konuşur.',
        'awakeningSigns': [
          'Boğazda titreşim veya basınç',
          'Spontan ses çıkarma isteği',
          'İç sesleri duyma',
          'Telepatik deneyimler',
        ],
        'practices': [
          'Mantra japa (tekrar)',
          'Ses çalışmaları',
          'Sessizlik pratiği (mauna)',
          'Boyun açıcı yoga pozları',
        ],
      },
      'meditationTechnique': {
        'name': 'Vishuddha Dhyana',
        'duration': '20-30 dakika',
        'steps': [
          'Rahat bir pozisyonda otur, boynunu uzat.',
          'Gözlerini kapat ve boğazına odaklan.',
          'Orada parlayan mavi bir ışık hayal et.',
          'Bu ışığın bir safir gibi parladığını gör.',
          'HAM mantrasını net bir sesle tekrarla.',
          'Sesin uzayda yayıldığını hisset.',
          'İç sesinle bağlan.',
          'Hakikatini ifade etme cesaretini hisset.',
          '21 kez HAM mantrasını tekrarla.',
          'Sessizlikte birkaç dakika kal.',
          'Yavaşça gözlerini aç.',
        ],
      },
      'partnerPractice': {
        'name': 'Hakikat Paylaşımı',
        'description': 'Çiftlerin derin iletişim pratiği',
        'steps': [
          'Karşı karşıya oturun, rahat olun.',
          'Birlikte HAM mantrasını söyleyin.',
          'Sırayla hakikatinizi paylaşın.',
          'Dinleyen sadece dinler, yargılamaz.',
          'Her paylaşımdan sonra sessizlik.',
          'Birbirinizin hakikatini onaylayın.',
          '15 dakika bu paylaşımda kalın.',
        ],
      },
      'healingAffirmations': [
        'Sesim değerli.',
        'Hakikatimi cesaretle söylüyorum.',
        'İfadem özgün ve net.',
        'Dinlemek de konuşmak kadar kutsal.',
        'Yaratıcılığım sesimde.',
        'İç sesime güveniyorum.',
        'Sözlerim şifa taşıyor.',
        'Evrenle uyum içinde konuşuyorum.',
      ],
      'healingRituals': [
        {
          'name': 'Ses Arınması',
          'description': 'Ses titreşimleriyle boğaz çakra temizliği',
          'steps': [
            'Sessiz bir alan bul.',
            'Ağzını aç, spontan sesler çıkar.',
            'Sesin nereye gitmek istediğini izle.',
            'Farklı tonları dene.',
            'HAM mantrasıyla sonlandır.',
            '10 dakika ses pratiği yap.',
          ],
        },
        {
          'name': 'Mauna (Sessizlik) Ritüeli',
          'description': 'Bilinçli sessizlik pratiği',
          'steps': [
            'Bir gün veya yarım gün sessizlik niyeti belirle.',
            'Tüm konuşmayı durdur.',
            'İç sesi dinle.',
            'Yazarak veya jestlerle iletişim kur.',
            'Sessizliğin gücünü deneyimle.',
            'Sessizlik sonrası ilk sözlerini bilinçli seç.',
          ],
        },
      ],
      'crystals': [
        'Lapis Lazuli',
        'Akuamarin',
        'Mavi Topaz',
        'Sodalit',
        'Türkuaz',
      ],
      'essentialOils': ['Okaliptüs', 'Nane', 'Çam', 'Lavanta'],
      'foods': ['Mavi/mor meyveler', 'Yosun', 'Bal', 'Limon'],
      'yogaAsanas': ['Sarvangasana', 'Halasana', 'Simhasana', 'Matsyasana'],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // 6. AJNA - ÜÇÜNCÜ GÖZ ÇAKRA
    // ─────────────────────────────────────────────────────────────────────────
    'ajna': {
      'name': 'Ajna',
      'nameTr': 'Üçüncü Göz Çakra',
      'sanskritMeaning': 'Komut Merkezi - Bilme ve Algılama',
      'location': 'Kaşların arasında, alın merkezi',
      'element': 'Işık (Jyoti) / Zihin (Manas)',
      'color': 'Çivit Mavisi / Mor',
      'colorHex': '#4B0082',
      'bijaMantra': 'OM / AUM',
      'bijaMantraAciklama':
          'OM mantrasının titreşimi evrensel bilinçle bağlantı kurar. '
          'Derin ve kutsal bir sesle söylenir, sezgiyi ve içgörüyü aktive eder.',
      'symbol': 'İki yapraklı lotus, içinde OM sembolü',
      'petals': 2,
      'petalMantras': ['Ham', 'Ksham'],
      'deity': {
        'masculine': 'Paramasiva - Aşkın Shiva',
        'feminine': 'Hakini Shakti - Altı Yüzlü Tanrıça',
      },
      'physicalAssociations': [
        'Hipofiz bezi (ana bez)',
        'Gözler ve görme',
        'Beyin alt kısmı',
        'Sinir sistemi',
        'Kulaklar ve denge',
        'Burun ve koku',
        'Alın bölgesi',
      ],
      'emotionalAssociations': [
        'Sezgi ve içgörü',
        'Berrak görme',
        'Hayal gücü',
        'Ruhsal görü',
        'Anlayış ve kavrayış',
        'Düşünce netliği',
        'İçsel bilgelik',
      ],
      'blockedSymptoms': {
        'physical': [
          'Baş ağrıları ve migren',
          'Görme sorunları',
          'Sinüs problemleri',
          'Uyku bozuklukları',
          'Hormonal dengesizlikler',
          'Konsantrasyon zorluğu',
        ],
        'emotional': [
          'Sezgi eksikliği',
          'Kararsızlık',
          'Aşırı şüphecilik',
          'Hayal gücü tıkanması',
          'Gerçeklik algısı sorunları',
          'Aşırı entelektüellik',
        ],
        'spiritual': [
          'Ruhsal körlük',
          'Meditasyonda görselleştirme zorluğu',
          'İç rehberliğe kapalılık',
          'Rüyaları hatırlamama',
        ],
      },
      'balancedSymptoms': {
        'physical': [
          'Net görüş',
          'Sağlıklı uyku döngüsü',
          'Dengeli hormonlar',
          'İyi konsantrasyon',
        ],
        'emotional': [
          'Güçlü sezgi',
          'Net düşünce',
          'Canlı hayal gücü',
          'Bilge karar verme',
        ],
        'spiritual': [
          'Ruhsal görü aktif',
          'Meditasyon derinliği',
          'İç rehberlikle bağlantı',
          'Rüya farkındalığı',
        ],
      },
      'kundaliniStage': {
        'description':
            'Kundalini ajna çakrasına ulaştığında üçüncü göz açılır. '
            'Ida ve Pingala nadileri burada birleşir. Dualite çözülür, birlik algısı başlar.',
        'awakeningSigns': [
          'Alında basınç veya nabız atışı',
          'Gözler kapalıyken ışık görme',
          'Sezgisel bilgi akışı',
          'Lucid rüyalar',
        ],
        'practices': [
          'Trataka (mum bakışı)',
          'Shambhavi mudra',
          'Üçüncü göz meditasyonu',
          'Görselleştirme pratikleri',
        ],
      },
      'meditationTechnique': {
        'name': 'Ajna Dhyana',
        'duration': '20-30 dakika',
        'steps': [
          'Rahat bir pozisyonda otur, omurgayı dik tut.',
          'Gözlerini kapat ve dikkatini kaşların arasına yönelt.',
          'Orada çivit mavisi bir ışık noktası hayal et.',
          'Bu noktanın giderek genişlediğini gör.',
          'OM mantrasını derin bir sesle tekrarla.',
          'İç gözünün açıldığını hisset.',
          'Sezginin akmasına izin ver.',
          'Görselleştirmelerin netleştiğini fark et.',
          '21 kez OM mantrasını tekrarla.',
          'Sessizlikte birkaç dakika kal.',
          'Yavaşça gözlerini aç.',
        ],
      },
      'partnerPractice': {
        'name': 'Üçüncü Göz Bağlantısı',
        'description': 'Çiftlerin sezgisel bağ kurması',
        'steps': [
          'Karşı karşıya oturun, alınlarınız yakın.',
          'Gözlerinizi kapatın.',
          'Birlikte OM mantrasını söyleyin.',
          'Üçüncü gözleriniz arasında ışık köprüsü hayal edin.',
          'Birbirinizin düşüncelerini hissetmeye çalışın.',
          'Sezgisel mesajlara açık olun.',
          '11 dakika bu bağlantıda kalın.',
        ],
      },
      'healingAffirmations': [
        'İç gözüm açık.',
        'Sezgime güveniyorum.',
        'Hakikati net görüyorum.',
        'İç bilgeliğim beni yönlendiriyor.',
        'Ötesini görme yeteneğim var.',
        'Evrensel bilgeliğe bağlıyım.',
        'Rüyalarım mesajlar taşıyor.',
        'İçsel rehberliğimi izliyorum.',
      ],
      'healingRituals': [
        {
          'name': 'Ay Işığı Meditasyonu',
          'description': 'Dolunay enerjisiyle üçüncü göz aktivasyonu',
          'steps': [
            'Dolunay gecesi dışarı çık.',
            'Ay ışığının alnına döküldüğünü hayal et.',
            'Gümüşi enerjinin üçüncü gözünü aktive ettiğini hisset.',
            'OM mantrasını aya söyle.',
            'Sezgisel mesajlara açık ol.',
            '15 dakika bu bağlantıda kal.',
          ],
        },
        {
          'name': 'Bindu Noktası Aktivasyonu',
          'description': 'Alın merkezi odaklı pratik',
          'steps': [
            'Alnının ortasına sandal pastı veya nokta koy.',
            'Bu noktaya odaklan.',
            'Dikkatini buradan ayırma.',
            'Enerjinin bu noktada yoğunlaştığını hisset.',
            '20 dakika bu odakta kal.',
          ],
        },
      ],
      'crystals': ['Ametist', 'Lapis Lazuli', 'Florit', 'Labradorit', 'Azurit'],
      'essentialOils': ['Sandal', 'Adaçayı', 'Akgünlük', 'Lavanta'],
      'foods': ['Mor sebzeler', 'Bitter çikolata', 'Yabanmersini', 'Üzüm'],
      'yogaAsanas': ['Balasana', 'Vajrasana', 'Padmasana', 'Sirsasana'],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // 7. SAHASRARA - TAÇ ÇAKRA
    // ─────────────────────────────────────────────────────────────────────────
    'sahasrara': {
      'name': 'Sahasrara',
      'nameTr': 'Taç Çakra',
      'sanskritMeaning': 'Bin Yapraklı - Sahara (Bin) + Ara (Yaprak)',
      'location': 'Başın tepesi, fontanel',
      'element': 'Saf Bilinç (Purusha) / Ötesi',
      'color': 'Mor / Beyaz / Altın',
      'colorHex': '#9400D3',
      'bijaMantra': 'Sessizlik / OM / AH',
      'bijaMantraAciklama':
          'Sahasrara tüm seslerin ötesindedir. Sessizlik en yüce mantradır. '
          'Ancak OM evrensel titreşim olarak burada da kullanılabilir.',
      'symbol': 'Bin yapraklı lotus, saf ışık',
      'petals': 1000,
      'petalMantras': ['Tüm Sanskrit harfleri 20 kez tekrar'],
      'deity': {
        'masculine': 'Parama Shiva - Saf Bilinç',
        'feminine': 'Maha Shakti - Kozmik Enerji',
      },
      'physicalAssociations': [
        'Epifiz bezi (pineal)',
        'Beyin üst kısmı',
        'Merkezi sinir sistemi',
        'Biyoritim düzenleme',
        'Melatonin üretimi',
        'Bilinç seviyeleri',
        'Tüm bedenin koordinasyonu',
      ],
      'emotionalAssociations': [
        'Aşkın mutluluk (ananda)',
        'Birlik bilinci',
        'Evrensel bağlantı',
        'İlahi aşk',
        'Sınırsız barış',
        'Ego çözülmesi',
        'Kozmik anlayış',
      ],
      'blockedSymptoms': {
        'physical': [
          'Kronik yorgunluk',
          'Işığa hassasiyet',
          'Nörolojik sorunlar',
          'Uyku bozuklukları',
          'Baş ağrıları',
          'Koordinasyon sorunları',
        ],
        'emotional': [
          'Anlamsızlık duygusu',
          'Ruhsal boşluk',
          'Depresyon',
          'Amaçsızlık',
          'İzolasyon',
          'Spiritüel kriz',
        ],
        'spiritual': [
          'Tanrısal bağlantı eksikliği',
          'Meditasyonda derinleşememe',
          'Birlik deneyiminden yoksunluk',
          'Aşkınlık korkusu',
        ],
      },
      'balancedSymptoms': {
        'physical': [
          'Optimal biyoritim',
          'Derin ve canlandırıcı uyku',
          'Genel sağlık ve canlılık',
          'Işıkla uyum',
        ],
        'emotional': [
          'Derin huzur ve ananda',
          'Birlik deneyimi',
          'Evrensel sevgi',
          'Anlam dolu yaşam',
        ],
        'spiritual': [
          'Tanrısal birlik',
          'Samadhi deneyimleri',
          'Aydınlanma sürecinde ilerleme',
          'Kozmik bilinç',
        ],
      },
      'kundaliniStage': {
        'description':
            'Kundalini taç çakrasına ulaştığında Shiva ve Shakti birleşir. '
            'Bu, kozmik evlilik (Maithuna) ve aydınlanmanın zirvesidir. '
            'Bireysel bilinç evrensel bilince kavuşur.',
        'awakeningSigns': [
          'Başın tepesinde basınç veya açılma hissi',
          'Yoğun ışık deneyimleri',
          'Ego çözülmesi',
          'Birlik bilinci anlık deneyimleri',
          'Sınırsız genişleme hissi',
        ],
        'practices': [
          'Derin meditasyon',
          'Sessizlik pratiği',
          'Satsang (kutsal sohbet)',
          'Adanmışlık (bhakti)',
        ],
      },
      'meditationTechnique': {
        'name': 'Sahasrara Dhyana',
        'duration': '30-60 dakika',
        'steps': [
          'Derin meditasyon deneyimine hazır ol.',
          'Rahat ama dik bir pozisyonda otur.',
          'Gözlerini kapat ve tüm çakralardan geç.',
          'Dikkatini başının tepesine yönelt.',
          'Orada bin yapraklı lotus hayal et.',
          'Bu lotusun açıldığını ve ışık yaydığını gör.',
          'Sessizlikte kal veya OM\'u çok yumuşak tekrarla.',
          'Bireysel sınırlarının çözüldüğünü hisset.',
          'Evrensel bilince açıl.',
          'Şükran ve teslimiyet içinde kal.',
          'Ne kadar süre kalırsan kal.',
          'Çok yavaş, kademeli olarak geri dön.',
        ],
      },
      'partnerPractice': {
        'name': 'Kutsal Birlik Meditasyonu',
        'description': 'Çiftlerin kozmik birlik deneyimi',
        'steps': [
          'Karşı karşıya lotus pozisyonunda oturun.',
          'Ellerinizi birbirinizin başının tepesine koyun.',
          'Gözlerinizi kapatın.',
          'Birlikte sessizliğe dalın.',
          'Enerjilerinizin taçlarda birleştiğini hissedin.',
          'Bireyselliğin ötesine geçin.',
          'Birlikte kozmik bilince açılın.',
          'En az 20 dakika bu derinlikte kalın.',
          'Birlikte çok yavaş geri dönün.',
        ],
      },
      'healingAffirmations': [
        'Ben evrensel bilincin parçasıyım.',
        'İlahi ışık içimden akıyor.',
        'Sonsuzluğa açığım.',
        'Birlik benim doğam.',
        'Aydınlanma yolundayım.',
        'Tüm varlıklarla birim.',
        'Tanrısal sevgi her şeyin kaynağı.',
        'Sınırlarımın ötesindeyim.',
      ],
      'healingRituals': [
        {
          'name': 'Şafak Meditasyonu',
          'description': 'Güneş doğuşuyla taç çakra aktivasyonu',
          'steps': [
            'Şafaktan önce uyan.',
            'Doğuya dönerek meditasyona otur.',
            'İlk ışıkların başının tepesine aktığını hayal et.',
            'Güneşin yükselişiyle birlikte yüksel.',
            'Işıkla dolduğunu hisset.',
            'Bu kutsal başlangıcı onurlandır.',
          ],
        },
        {
          'name': 'Samadhi Hazırlığı',
          'description': 'Derin meditasyon ritüeli',
          'steps': [
            'Üç gün hafif beslen.',
            'Sessizlik niyeti belirle.',
            'Kutsal bir alan oluştur.',
            'Tüm çakraları sırayla aktive et.',
            'Taç çakrada uzun süre kal.',
            'Teslimiyete geç.',
            'Deneyimi zorlamadan izle.',
          ],
        },
      ],
      'crystals': [
        'Temiz Kuvars',
        'Ametist',
        'Selenit',
        'Danburit',
        'Fenakite',
      ],
      'essentialOils': ['Lotus', 'Akgünlük', 'Mür', 'Sandal'],
      'foods': ['Oruç', 'Hafif meyveler', 'Saf su', 'Bilinçli beslenme'],
      'yogaAsanas': [
        'Sirsasana',
        'Savasana',
        'Padmasana',
        'Meditasyon pozları',
      ],
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BÖLÜM 2: KUNDALİNİ UYANIŞ REHBERİ
  // Yılan Enerjisi - Ezoterik Bilgelik
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, dynamic> kundaliniAwakeningGuide = {
    // ─────────────────────────────────────────────────────────────────────────
    // TEMEL KAVRAMLAR
    // ─────────────────────────────────────────────────────────────────────────
    'introduction': {
      'title': 'Kundalini Shakti - Uyuyan Yılan',
      'description': '''
Kundalini, Sanskrit dilinde "kıvrılmış" anlamına gelir. Bu kadim kavram,
omurganın tabanında, Muladhara çakrasında uyuyan ilahi enerjiyi simgeler.

Üç buçuk kıvrım halinde sarılmış bu yılan, Shakti'nin en yoğunlaşmış halidir.
Shiva lingamının etrafında bekler, uyanışı için hazır durur.

Kundalini uyanışı, bireysel bilincin evrensel bilince kavuşma yolculuğudur.
Bu süreç, tüm çakraları sırayla aktive ederek, nihayetinde Sahasrara'da
Shiva ile Shakti'nin kozmik birleşmesine yol açar.
''',
      'metaphor': '''
Kundalini, toprak altında bekleyen bir tohum gibidir. Doğru koşullar
sağlandığında - bilinçli pratik, arınma ve adanmışlık ile - bu tohum
filizlenir ve omurga boyunca yükselir. Her çakra, bu büyümenin bir
aşamasıdır. Sonunda, bin yapraklı lotus açılır ve ruh, kaynağına döner.
''',
      'warnings': [
        'Kundalini uyanışı hafife alınmamalıdır.',
        'Deneyimli bir rehber olmadan zorlanmamalıdır.',
        'Fiziksel ve psikolojik hazırlık şarttır.',
        'Ego dönüşümü zorlu olabilir.',
        'Sabır ve şefkat temel gereksinimlerdir.',
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // NADİ SİSTEMİ
    // ─────────────────────────────────────────────────────────────────────────
    'nadiSystem': {
      'overview': '''
Nadi, Sanskrit dilinde "kanal" veya "akış" anlamına gelir. İnce beden içinde
72.000 enerji kanalı bulunur. Bunların arasında üç tanesi en önemlidir:
Sushumna, Ida ve Pingala.

Bu üç ana nadi, omurga boyunca uzanır ve çakraları birbirine bağlar.
Kundalini uyanışı, bu kanalların dengelenmesi ve arınmasıyla başlar.
''',
      'mainNadis': {
        'sushumna': {
          'name': 'Sushumna Nadi',
          'nameTr': 'Merkezi Kanal',
          'location': 'Omurganın içinde, merkezi kanal',
          'description': '''
Sushumna, en kutsal nadidir. Muladhara'dan Sahasrara'ya uzanır.
Kundalini bu kanal içinden yükselir. Sushumna aktif olduğunda,
Ida ve Pingala dengeli olduğunda, bilinç genişler.

Bu kanal, Brahma Nadi olarak da bilinir ve aydınlanmanın yoludur.
Meditasyon, pranayama ve yoga pratiği Sushumna'yı açar.
''',
          'qualities': [
            'Saf bilinç kanalı',
            'Dualite ötesi',
            'Derin meditasyon durumu',
            'Kundalini yükselişinin yolu',
            'Shiva-Shakti birleşim noktası',
          ],
          'activationSigns': [
            'Omurgada sıcaklık veya titreşim',
            'Derin huzur ve sessizlik',
            'Zaman algısının değişmesi',
            'Işık deneyimleri',
            'Spontan meditasyon derinliği',
          ],
          'practices': [
            'Nadi Shodhana pranayama',
            'Sushumna meditasyonu',
            'Mudra ve bandha pratikleri',
            'Omurga odaklı yoga',
          ],
        },
        'ida': {
          'name': 'Ida Nadi',
          'nameTr': 'Ay Kanalı',
          'location':
              'Sol burun deliğinden başlar, omurganın solunda iner-çıkar',
          'description': '''
Ida, kadınsal, alıcı, soğutucu enerjiyi taşır. Ay enerjisi (Chandra)
ile ilişkilidir. Sol beyin yarımküresiyle bağlantılıdır.

Bu kanal, dinginlik, içe dönüklük, sezgi ve yaratıcılık getirir.
Ida baskın olduğunda, meditasyon ve içsel çalışmalar kolaylaşır.
Ancak aşırı Ida, durgunluk ve atalet getirebilir.
''',
          'qualities': [
            'Kadınsal (Shakti) enerji',
            'Ay (Chandra) ile ilişkili',
            'Soğutucu ve dinlendirici',
            'Sezgi ve hayal gücü',
            'Sol beyin yarımküresi',
            'Geçmişe yönelim',
            'İçe dönüklük',
          ],
          'balanceIndicators': {
            'balanced': [
              'Sağlıklı sezgi',
              'Yaratıcı ilham',
              'Duygusal denge',
              'Kaliteli uyku',
              'Empatik bağlantı',
            ],
            'excessive': [
              'Aşırı uyku isteği',
              'Duygusal dalgalanmalar',
              'Motivasyon eksikliği',
              'Depresif eğilimler',
              'Fiziksel soğukluk',
            ],
            'deficient': [
              'Sezgi eksikliği',
              'Duygusal donukluk',
              'Empati zorluğu',
              'Uyku sorunları',
              'Yaratıcılık tıkanması',
            ],
          },
        },
        'pingala': {
          'name': 'Pingala Nadi',
          'nameTr': 'Güneş Kanalı',
          'location':
              'Sağ burun deliğinden başlar, omurganın sağında iner-çıkar',
          'description': '''
Pingala, erkeksel, verici, ısıtıcı enerjiyi taşır. Güneş enerjisi (Surya)
ile ilişkilidir. Sağ beyin yarımküresiyle bağlantılıdır.

Bu kanal, aktivite, dışa dönüklük, mantık ve fiziksel güç getirir.
Pingala baskın olduğunda, iş ve fiziksel aktiviteler kolaylaşır.
Ancak aşırı Pingala, stres ve tükenmişlik getirebilir.
''',
          'qualities': [
            'Erkeksel (Shiva) enerji',
            'Güneş (Surya) ile ilişkili',
            'Isıtıcı ve aktive edici',
            'Mantık ve analiz',
            'Sağ beyin yarımküresi',
            'Geleceğe yönelim',
            'Dışa dönüklük',
          ],
          'balanceIndicators': {
            'balanced': [
              'Sağlıklı motivasyon',
              'Net düşünce',
              'Fiziksel enerji',
              'Karar verme yetisi',
              'Hedef odaklılık',
            ],
            'excessive': [
              'Aşırı aktivite',
              'Stres ve gerginlik',
              'Uyuyamama',
              'Agresif eğilimler',
              'Fiziksel sıcaklık',
            ],
            'deficient': [
              'Motivasyon eksikliği',
              'Zihinsel bulanıklık',
              'Fiziksel yorgunluk',
              'Karar verememe',
              'Tembellik',
            ],
          },
        },
      },
      'balancingPractices': {
        'nadiShodhana': {
          'name': 'Nadi Shodhana Pranayama',
          'nameTr': 'Alternatif Burun Deliği Nefesi',
          'description': 'Ida ve Pingala\'yı dengeleyen en etkili pratik',
          'steps': [
            'Rahat bir oturuş pozisyonunda yerleş.',
            'Sol elini dizine koy, Gyan mudra\'da.',
            'Sağ elin baş parmağı ile sağ burun deliğini kapat.',
            'Sol burun deliğinden 4 sayı nefes al.',
            'Her iki burun deliğini kapatarak 16 sayı tut.',
            'Sağ burun deliğinden 8 sayı nefes ver.',
            'Aynı burun deliğinden 4 sayı nefes al.',
            'Her iki burun deliğini kapatarak 16 sayı tut.',
            'Sol burun deliğinden 8 sayı nefes ver.',
            'Bu bir döngüdür. 9-27 döngü tekrarla.',
          ],
          'benefits': [
            'Ida ve Pingala dengesi',
            'Zihinsel berraklık',
            'Duygusal denge',
            'Sushumna aktivasyonu hazırlığı',
            'Stres azaltma',
          ],
          'duration': '15-20 dakika',
          'bestTime': 'Sabah erken veya akşam üzeri',
        },
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // UYANIŞ AŞAMALARI
    // ─────────────────────────────────────────────────────────────────────────
    'awakeningStages': {
      'overview': '''
Kundalini uyanışı genellikle kademeli ve aşamalı bir süreçtir.
Her birey benzersiz bir deneyim yaşar, ancak ortak aşamalar gözlemlenir.
Bu yolculuk, sabır, adanmışlık ve rehberlik gerektirir.
''',
      'stages': [
        {
          'stage': 1,
          'name': 'Arambha (Başlangıç)',
          'description': '''
Kundalini'nin ilk kıpırdanışı. Muladhara'da enerji hareketlenir.
Brahma granthi (ilk düğüm) gevşemeye başlar. Fiziksel ve enerjetik
farkındalık artar. Bedenle yeni bir ilişki kurulur.
''',
          'signs': [
            'Kuyruk sokumunda ısı veya titreşim',
            'Spontan beden hareketleri',
            'Artan enerji farkındalığı',
            'Rüyaların canlılaşması',
            'Fiziksel duyarlılığın artması',
          ],
          'challenges': [
            'Korku ve endişe',
            'Fiziksel rahatsızlıklar',
            'Uyku düzensizlikleri',
            'Maddi güvenlik kaygıları',
          ],
          'practices': [
            'Topraklama meditasyonları',
            'Kök çakra çalışması',
            'Doğada zaman geçirme',
            'Düzenli yoga pratiği',
          ],
          'duration': 'Haftalar ile aylar arası',
        },
        {
          'stage': 2,
          'name': 'Ghata (Birleşme)',
          'description': '''
Kundalini sakral ve solar pleksus çakralarından yükselir.
Vishnu granthi (ikinci düğüm) ile karşılaşılır. Duygusal
temizlik başlar. Yaratıcılık ve kişisel güç dönüşür.
''',
          'signs': [
            'Yoğun duygusal deneyimler',
            'Artan yaratıcılık',
            'İrade gücünde değişimler',
            'Sindirimin değişmesi',
            'Enerji dalgalanmaları',
          ],
          'challenges': [
            'Duygusal karmaşa',
            'Geçmişin yüzeye çıkması',
            'Ego ile mücadele',
            'İlişkilerde dalgalanmalar',
          ],
          'practices': [
            'Duygusal farkındalık çalışması',
            'Su elementi meditasyonları',
            'Yaratıcı ifade',
            'Solar pleksus güçlendirme',
          ],
          'duration': 'Aylar ile yıllar arası',
        },
        {
          'stage': 3,
          'name': 'Parichaya (Tanışma)',
          'description': '''
Kundalini kalp çakrasına ulaşır. Büyük dönüşüm başlar.
Alt ve üst çakralar arasında köprü kurulur. Koşulsuz
sevgi deneyimleri başlar. Evrensel birlik ilk kez hissedilir.
''',
          'signs': [
            'Yoğun sevgi dalgaları',
            'Birlik deneyimleri',
            'Göğüste genişleme hissi',
            'Affetme kolaylığı',
            'Empatinin derinleşmesi',
          ],
          'challenges': [
            'Aşırı duyarlılık',
            'İlişkilerde derinleşme veya bitişler',
            'Ego ölümü deneyimleri',
            'Eski yaşam tarzının yetersiz gelmesi',
          ],
          'practices': [
            'Metta meditasyonu',
            'Kalp açıcı yoga',
            'Şükran pratiği',
            'Hizmet (seva) çalışması',
          ],
          'duration': 'Yıllar',
        },
        {
          'stage': 4,
          'name': 'Nishpatti (Olgunlaşma)',
          'description': '''
Kundalini üst çakralara ulaşır. Rudra granthi (üçüncü düğüm)
çözülür. Boğaz, üçüncü göz ve taç çakraları aktive olur.
Spiritüel yetenekler açılır. Samadhi deneyimleri başlar.
''',
          'signs': [
            'Sezgisel yeteneklerin açılması',
            'İç sesin netleşmesi',
            'Işık deneyimleri',
            'Bilinç genişlemesi',
            'Ego çözülmesi',
          ],
          'challenges': [
            'Spiritüel kibir riski',
            'Dünyadan kopma eğilimi',
            'Güçlerin cazibesine kapılma',
            'Entegrasyon zorlukları',
          ],
          'practices': [
            'Derin meditasyon',
            'Sessizlik pratiği (mauna)',
            'Üçüncü göz meditasyonu',
            'Adanmışlık pratiği',
          ],
          'duration': 'Yıllar ile ömür boyu',
        },
        {
          'stage': 5,
          'name': 'Sahaja (Doğal Hal)',
          'description': '''
Kundalini Sahasrara'da Shiva ile birleşir. Bu, kozmik evlilik,
Maithuna'dır. Bireysel bilinç evrensel bilince kavuşur. Sahaja
samadhi - sürekli ve doğal aydınlanma hali - yerleşir.
''',
          'signs': [
            'Sürekli huzur ve ananda',
            'Birlik bilincinde kalıcılık',
            'Ego yok oluşu',
            'Koşulsuz sevgi hali',
            'Tanrısal bağlantı',
          ],
          'characteristics': [
            'Eylemde eylemsizlik',
            'Dünyada ama dünyaya ait olmayan',
            'Doğal bilgelik akışı',
            'Tüm varlıklara şefkat',
            'Zamanın ötesinde varoluş',
          ],
          'description2': '''
Bu aşamaya ulaşan çok az sayıda ruh vardır. Burası aydınlanmış
varlıkların, ustaların ve avatarların halidir. Ancak bu potansiyel
her ruhun içinde vardır ve evrimsel yolculuğun nihai hedefidir.
''',
        },
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // UYANIŞ BELİRTİLERİ
    // ─────────────────────────────────────────────────────────────────────────
    'awakeningSymptoms': {
      'physical': {
        'category': 'Fiziksel Belirtiler',
        'symptoms': [
          {
            'symptom': 'Omurgada ısı veya soğukluk',
            'description': 'Enerji akışının fiziksel tezahürü',
            'advice': 'Doğal kabul et, zorlamadan izle',
          },
          {
            'symptom': 'Titreşimler ve sarsıntılar',
            'description': 'Enerji bloklarının çözülmesi',
            'advice': 'Bırak ve akmasına izin ver',
          },
          {
            'symptom': 'Spontan beden hareketleri (kriyas)',
            'description': 'Bedenin enerjiyi dengeleme çabası',
            'advice': 'Güvenli bir ortamda izin ver',
          },
          {
            'symptom': 'Uyku düzeni değişimleri',
            'description': 'Bilinç seviyelerinin yeniden düzenlenmesi',
            'advice': 'Dinlenme ihtiyacını karşıla',
          },
          {
            'symptom': 'Beslenme değişiklikleri',
            'description': 'Bedenin arınma ihtiyacı',
            'advice': 'Bedenini dinle, zorlama',
          },
          {
            'symptom': 'Cinsel enerji değişimleri',
            'description': 'Yaşam enerjisinin dönüşümü',
            'advice': 'Brahmacharya veya bilinçli yönlendirme',
          },
          {
            'symptom': 'Baş ağrıları veya basınç',
            'description': 'Üst çakraların aktivasyonu',
            'advice': 'Topraklama pratikleri, su içme',
          },
          {
            'symptom': 'Kalp çarpıntıları',
            'description': 'Anahata aktivasyonu',
            'advice': 'Derin nefesler, tıbbi kontrol',
          },
        ],
      },
      'emotional': {
        'category': 'Duygusal Belirtiler',
        'symptoms': [
          {
            'symptom': 'Yoğun duygusal dalgalar',
            'description': 'Bastırılmış duyguların yüzeye çıkması',
            'advice': 'Duyguları yargılamadan kabul et',
          },
          {
            'symptom': 'Spontan ağlama veya gülme',
            'description': 'Duygusal salınım ve arınma',
            'advice': 'Doğal ifadeye izin ver',
          },
          {
            'symptom': 'Geçmişin yüzeye çıkması',
            'description': 'Karma temizliği',
            'advice': 'İşle ve bırak',
          },
          {
            'symptom': 'Yoğun sevgi hissi',
            'description': 'Kalp çakra açılışı',
            'advice': 'Bu hediyeyi kutla',
          },
          {
            'symptom': 'Korku veya endişe',
            'description': 'Ego\'nun direnişi',
            'advice': 'Güvende olduğunu hatırla',
          },
          {
            'symptom': 'Yalnızlık hissi',
            'description': 'Eski kimlikten kopuş',
            'advice': 'Topluluk desteği ara',
          },
        ],
      },
      'mental': {
        'category': 'Zihinsel Belirtiler',
        'symptoms': [
          {
            'symptom': 'Düşünce kalıplarının değişimi',
            'description': 'Zihinsel yeniden yapılanma',
            'advice': 'Eski düşünceleri bırak',
          },
          {
            'symptom': 'Artan farkındalık',
            'description': 'Bilinç genişlemesi',
            'advice': 'Bu yeni algıyla tanış',
          },
          {
            'symptom': 'Konsantrasyon değişimleri',
            'description': 'Dikkat yeniden yönlenmesi',
            'advice': 'Sabırlı ol, bu geçici',
          },
          {
            'symptom': 'Canlı rüyalar',
            'description': 'Bilinçaltı aktivasyonu',
            'advice': 'Rüya günlüğü tut',
          },
          {
            'symptom': 'Zaman algısının değişmesi',
            'description': 'Şimdiki an farkındalığı',
            'advice': 'Bu genişlemeye izin ver',
          },
        ],
      },
      'spiritual': {
        'category': 'Spiritüel Belirtiler',
        'symptoms': [
          {
            'symptom': 'Birlik deneyimleri',
            'description': 'Ego sınırlarının geçici çözülmesi',
            'advice': 'Bu kutsal anları onurlandır',
          },
          {
            'symptom': 'İç sesler veya görüntüler',
            'description': 'İnce algının açılması',
            'advice': 'Ayırt etme yetisi geliştir',
          },
          {
            'symptom': 'Senkronisiteler',
            'description': 'Evrenle uyum',
            'advice': 'İşaretlere dikkat et',
          },
          {
            'symptom': 'Işık deneyimleri',
            'description': 'İç ışığın algılanması',
            'advice': 'Meditatif halde gözlemle',
          },
          {
            'symptom': 'Derin barış halleri',
            'description': 'Samadhi öncesi deneyimler',
            'advice': 'Bu hali besle',
          },
          {
            'symptom': 'Evrensel sevgi',
            'description': 'Anahata tam açılışı',
            'advice': 'Bu sevgiyi paylaş',
          },
        ],
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // GÜVENLİK PRATİKLERİ
    // ─────────────────────────────────────────────────────────────────────────
    'safetyPractices': {
      'overview': '''
Kundalini uyanışı güçlü bir süreçtir ve bilinçli yaklaşım gerektirir.
Güvenlik pratikleri, bu yolculuğun sağlıklı ve dengeli ilerlemesini sağlar.
Aşırılıktan kaçınmak ve bedenle uyum içinde olmak temeldir.
''',
      'essentialPractices': [
        {
          'name': 'Topraklama (Grounding)',
          'importance': 'Temel',
          'description': '''
Kundalini yükselirken topraklanma hayati önem taşır. Enerji yukarı
akarken, köklerle bağlantı kopmamalıdır. Topraklama, deneyimi
dengelenmiş ve entegre tutar.
''',
          'techniques': [
            'Yalın ayak yürüyüş',
            'Doğada zaman geçirme',
            'Kök çakra meditasyonu',
            'Fiziksel egzersiz',
            'Topraklanma yiyecekleri (kök sebzeler)',
            'Hematit veya turmalin taşları',
          ],
        },
        {
          'name': 'Denge Pratiği',
          'importance': 'Temel',
          'description': '''
Ida ve Pingala, Sushumna'nın iki yanında dengelenmelidir.
Bir tarafın baskınlığı, dengesiz uyandırma getirir.
Nadi Shodhana bu dengenin anahtarıdır.
''',
          'techniques': [
            'Nadi Shodhana pranayama',
            'Alternatif nostril breathing',
            'Hatha yoga pratiği',
            'Yaşam dengesi (iş-dinlenme)',
          ],
        },
        {
          'name': 'Arınma (Shuddhi)',
          'importance': 'Çok Önemli',
          'description': '''
Kundalini yükselmeden önce kanalların temiz olması gerekir.
Bloklu nadiler, enerji tıkanmalarına ve sorunlara yol açar.
Fiziksel, duygusal ve zihinsel arınma şarttır.
''',
          'techniques': [
            'Shatkarma (altı arınma tekniği)',
            'Oruç ve hafif beslenme',
            'Duygusal temizlik çalışması',
            'Meditasyon ve sessizlik',
            'Doğal beslenme',
            'Dijital detoks',
          ],
        },
        {
          'name': 'Yavaş İlerleme',
          'importance': 'Kritik',
          'description': '''
Kundalini'yi zorlamak tehlikelidir. Doğal tempo izlenmelidir.
Ego'nun hızla aydınlanma arzusu tuzaktır. Sabır erdemdir.
Her aşama kendi zamanında olgunlaşmalıdır.
''',
          'guidelines': [
            'Pratikleri kademeli artır',
            'Belirtileri gözlemle ve dinle',
            'Rahatsızlık hissinde yavaşla',
            'Deneyimli rehber eşliğinde ilerle',
            'Ego\'nun aceleciliğini fark et',
          ],
        },
        {
          'name': 'Topluluk Desteği',
          'importance': 'Önemli',
          'description': '''
Bu yolculuk yalnız yürünmemelidir. Deneyimli bir öğretmen,
destekleyici bir topluluk veya ruhani arkadaşlar değerlidir.
Paylaşım ve rehberlik süreci kolaylaştırır.
''',
          'suggestions': [
            'Deneyimli guru veya öğretmen bul',
            'Spiritüel toplulukla bağlan',
            'Satsang (kutsal sohbet) katıl',
            'Güvenilir dostlarla paylaş',
            'Gerekirse profesyonel destek al',
          ],
        },
      ],
      'warningSignsToSlowDown': [
        'Sürekli baş ağrısı veya basınç',
        'Uyuyamama veya aşırı uyku',
        'Yoğun korku veya panik',
        'Gerçeklik algısı sorunları',
        'Fiziksel ağrılar',
        'Duygusal kontrolsüzlük',
        'İlişkilerde ciddi sorunlar',
        'İş veya günlük yaşamı sürdürememe',
      ],
      'whenToSeekHelp': [
        'Belirtiler günlük yaşamı ciddi etkiliyor',
        'Fiziksel sağlık sorunları oluşuyor',
        'Psikolojik denge bozuluyor',
        'Sürekli korku veya panik yaşanıyor',
        'Yardım almadan baş edilemiyor',
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // ENTEGRASYON TEKNİKLERİ
    // ─────────────────────────────────────────────────────────────────────────
    'integrationTechniques': {
      'overview': '''
Kundalini deneyimlerinin günlük yaşama entegrasyonu kritik öneme sahiptir.
Spiritüel deneyimler dünyevi yaşamdan kopuk kalmamalıdır.
Gerçek uyanış, hayatın her anında bilinçli var olabilmektir.
''',
      'techniques': [
        {
          'name': 'Bedenle Bağlantı',
          'description': 'Spiritüel deneyimleri bedende yerleştirme',
          'practices': [
            'Günlük yoga veya hareket pratiği',
            'Bilinçli yürüyüş',
            'Bedensel farkındalık meditasyonu',
            'Dans ve serbest hareket',
            'Doğada vakit geçirme',
          ],
        },
        {
          'name': 'Duygusal İşleme',
          'description': 'Yüzeye çıkan duyguları sağlıklı işleme',
          'practices': [
            'Günlük tutma',
            'Güvenilir kişilerle paylaşım',
            'Profesyonel destek (gerekirse)',
            'Sanat ve yaratıcı ifade',
            'Duygu farkındalığı meditasyonu',
          ],
        },
        {
          'name': 'Zihinsel Netlik',
          'description': 'Zihinsel berraklığı koruma',
          'practices': [
            'Düzenli meditasyon',
            'Zihinsel hijyen (negatif içerikten kaçınma)',
            'Okuma ve öğrenme dengesi',
            'Sessizlik pratikleri',
            'Doğa teması',
          ],
        },
        {
          'name': 'Sosyal Denge',
          'description': 'İlişkilerde ve toplumda sağlıklı kalma',
          'practices': [
            'Sevdiklerle kaliteli zaman',
            'Hizmet ve gönüllülük',
            'Topluluk bağlantısı',
            'İş yaşamı dengesi',
            'Sağlıklı sınırlar',
          ],
        },
        {
          'name': 'Spiritüel Süreklilik',
          'description': 'Pratiklerin düzenli devamı',
          'practices': [
            'Günlük meditasyon rutini',
            'Haftalık derin pratik',
            'Düzenli satsang veya topluluk',
            'Öğretmenle düzenli temas',
            'Spiritüel okuma ve çalışma',
          ],
        },
      ],
      'dailyRoutineSuggestion': {
        'morning': [
          'Erken uyanış (güneş doğmadan önce ideal)',
          'Banyo ve arınma',
          'Pranayama pratiği (15-30 dk)',
          'Meditasyon (20-40 dk)',
          'Hafif yoga (15-30 dk)',
          'Bilinçli kahvaltı',
        ],
        'daytime': [
          'İşte veya aktivitede farkındalık',
          'Kısa nefes molaları',
          'Bilinçli öğle yemeği',
          'Doğada kısa yürüyüş (mümkünse)',
          'Topraklama anları',
        ],
        'evening': [
          'Akşam meditasyonu (15-30 dk)',
          'Günlük değerlendirme',
          'Hafif yoga veya esnemeler',
          'Erken ve hafif akşam yemeği',
          'Ekran detoksu (uyumadan 2 saat önce)',
          'Şükran pratiği',
          'Erken yatış',
        ],
      },
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BÖLÜM 3: KUTSAL CİNSELLİK BİLGELİĞİ
  // Enerji Değişimi ve Ruhsal Birlik İlkeleri
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, dynamic> sacredSexualityWisdom = {
    // ─────────────────────────────────────────────────────────────────────────
    // GİRİŞ VE FELSEFE
    // ─────────────────────────────────────────────────────────────────────────
    'introduction': {
      'title': 'Kutsal Birlik - Shiva ve Shakti Dansı',
      'description': '''
Tantra felsefesinde, cinsellik yalnızca fiziksel bir eylem değil,
kutsal bir enerji değişimi ve ruhsal birlik pratiğidir. Shiva (saf bilinç)
ve Shakti (yaratıcı enerji) arasındaki kozmik dans, her birlikte yansır.

Bu antik bilgelik, partnerlerin birbirlerini tanrısal varlıklar olarak
görmelerini, birlikteliklerini bir meditasyon ve ibadet haline
getirmelerini öğretir. Amaç, fiziksel hazzın ötesinde, ruhsal uyanış
ve kozmik birlik deneyimidir.

Bu bölüm, bu kadim bilgeliği saygılı ve spiritüel bir çerçevede sunar.
Fiziksel detaylar yerine, enerji prensipleri ve ruhsal yaklaşıma odaklanır.
''',
      'corePhilosophy': '''
Tantrik birlik, iki bireyin ötesine geçer. Bu, evrensel erkeksel ve
dişil prensiplerin buluşmasıdır. Her erkek içinde Shakti, her kadın
içinde Shiva vardır. Birlikte, bu kutuplar bütünlüğe kavuşur.

Bu birlik yoluyla:
- Bireysel ego çözülür
- Evrensel sevgi deneyimlenir
- Kundalini doğal olarak yükselir
- Samadhi halleri mümkün olur
- İlahi olanla bağlantı kurulur
''',
      'warnings': [
        'Bu pratikler karşılıklı rıza ve sevgi gerektirir.',
        'Ego tatmini için kullanılmamalıdır.',
        'Deneyimli rehberlik önerilir.',
        'Duygusal olgunluk şarttır.',
        'Fiziksel sağlık gözetilmelidir.',
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // ENERJİ DEĞİŞİMİ İLKELERİ
    // ─────────────────────────────────────────────────────────────────────────
    'energyExchangePrinciples': {
      'overview': '''
İki birey birlikte olduğunda, sadece fiziksel değil, enerjetik bir
değişim de gerçekleşir. Auralar karışır, çakralar etkileşir ve
karşılıklı bir enerji akışı oluşur. Tantrik pratik, bu doğal süreci
bilinçli ve kutsal kılar.
''',
      'principles': [
        {
          'name': 'Bilinçli Niyet',
          'description': '''
Her birliktelik, bilinçli bir niyetle başlar. Bu niyet, yalnızca fiziksel
haz değil, ruhsal birlik, şifa veya sevginin derinleşmesi olabilir.
Niyetin netliği, enerji akışının kalitesini belirler.
''',
          'practice': '''
Birliktelik öncesi, birlikte sessizce oturun. Gözlerinizi kapatın ve
niyetinizi belirleyin. Bu niyeti kalbinizde hissedin ve partnerinizle
paylaşın. Niyetinizi kutsal bir dua gibi formüle edin.
''',
        },
        {
          'name': 'Nefes Senkronizasyonu',
          'description': '''
Nefes, prana (yaşam enerjisi) taşır. İki partnerin nefeslerini
senkronize etmesi, enerji alanlarını birleştirir ve derin bir
bağlantı oluşturur. Bu, tantrik birliğin temelidir.
''',
          'practice': '''
Karşı karşıya oturun veya uzanın. Birbirinizin nefesini gözlemleyin.
Yavaşça aynı ritme geçin. Biri nefes alırken diğeri versin veya
birlikte aynı anda alıp verin. Bu senkronizasyonu 5-10 dakika sürdürün.
''',
        },
        {
          'name': 'Göz Teması (Soul Gazing)',
          'description': '''
Gözler, ruhun pencereleridir. Derin göz teması, maskelerin düşmesini
ve ruhların buluşmasını sağlar. Bu pratik, ego sınırlarını çözer
ve birlik bilincine kapı açar.
''',
          'practice': '''
Rahat bir mesafede karşı karşıya oturun. Yumuşak bir bakışla
birbirinizin gözlerine bakın. Yargılamadan, beklemeden, sadece görün.
5-20 dakika bu bağlantıda kalın. Duyguları akmasına izin verin.
''',
        },
        {
          'name': 'Çakra Hizalama',
          'description': '''
Her iki partnerin çakraları birbirleriyle etkileşir. Hizalanmış çakralar,
enerji akışını kolaylaştırır. Özellikle kalp çakrası bağlantısı,
birlikteliği kutsal kılar.
''',
          'practice': '''
Yan yana veya karşı karşıya pozisyonda, çakralarınızın hizalanmasına
dikkat edin. Her çakra için birkaç nefes alın. Özellikle kalp çakrasında
bir ışık köprüsü hayal edin. Bu bağlantıyı tüm birliktelik boyunca koruyun.
''',
        },
        {
          'name': 'Enerji Döngüsü',
          'description': '''
Tantrik birlikte, enerji bir döngü halinde akar. Erkeksel enerji
yukarı, dişil enerji aşağı yönelir. Bu döngü, her iki partneri
besler ve dengeler.
''',
          'practice': '''
Birlikte olurken, enerjinin bir döngü halinde aktığını hayal edin.
Partner A'dan B'ye, B'den A'ya sürekli bir akış. Bu döngünün
giderek parlaklaştığını ve her ikinizi aydınlattığını görselleştirin.
''',
        },
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // NEFES ÇALIŞMALARI
    // ─────────────────────────────────────────────────────────────────────────
    'breathworkForIntimacy': {
      'overview': '''
Nefes, tantrik pratiğin temelidir. Doğru nefes çalışması, farkındalığı
artırır, enerjiyi yönlendirir ve deneyimi derinleştirir. Partner
nefes pratikleri, birliği güçlendirir.
''',
      'practices': [
        {
          'name': 'Yinelenen Nefes (Circular Breath)',
          'description': 'Kesintisiz, dairesel nefes akışı',
          'steps': [
            'Rahat bir pozisyonda karşı karşıya oturun.',
            'Nefes alış ve verişi birleştirin, arada duraklamayın.',
            'Nefes dairesel bir akış gibi sürekli aksın.',
            'Bu nefesi 5-10 dakika sürdürün.',
            'Enerji yoğunluğunun arttığını hissedin.',
          ],
          'benefits': [
            'Enerji akışını artırır',
            'Bilinç halini değiştirir',
            'Partnerleri birleştirir',
            'Farkındalığı yoğunlaştırır',
          ],
        },
        {
          'name': 'Nefes Paylaşımı',
          'description': 'Birbirinin nefesini alma pratiği',
          'steps': [
            'Yüz yüze çok yakın mesafede durun.',
            'Biri nefes verirken diğeri alsın.',
            'Partnerinizin nefesini alın, o da sizinkini.',
            'Bu değişimi 5 dakika sürdürün.',
            'Enerji ve öz paylaşımını hissedin.',
          ],
          'benefits': [
            'Derin bağ oluşturur',
            'Prana paylaşımı sağlar',
            'Ego sınırlarını çözer',
            'Birlik hissi verir',
          ],
        },
        {
          'name': 'Kundalini Nefesi',
          'description': 'Omurga boyunca enerji yükseltme',
          'steps': [
            'Karşı karşıya lotus pozisyonunda oturun.',
            'Nefes alırken enerjiyi kökten başa çekin.',
            'Nefes verirken enerjiyi partnerinize gönderin.',
            'Partneriniz aynısını sizin için yapsın.',
            'İki omurganız arasında ışık döngüsü oluşturun.',
          ],
          'benefits': [
            'Kundalini aktivasyonunu destekler',
            'Çakra uyumunu sağlar',
            'Derin birlik deneyimi',
            'Spiritüel uyanışı tetikler',
          ],
        },
        {
          'name': 'Kalp Nefesi',
          'description': 'Kalp merkezli sevgi nefesi',
          'steps': [
            'Ellerinizi birbirinizin kalbine koyun.',
            'Nefesi kalpten alıp verin.',
            'Her nefes alışta sevgi çekin.',
            'Her nefes verişte sevgi gönderin.',
            '10 dakika bu akışı sürdürün.',
          ],
          'benefits': [
            'Kalp bağlantısını derinleştirir',
            'Koşulsuz sevgi açar',
            'Şifa enerjisi akışı',
            'Duygusal yakınlık',
          ],
        },
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // KALP-KALP BAĞLANTISI
    // ─────────────────────────────────────────────────────────────────────────
    'heartToHeartConnection': {
      'overview': '''
Tantrik birliğin özü, kalp bağlantısıdır. Fiziksel birlik olmadan da
derin kalp bağlantısı deneyimlenebilir. Bu bağlantı, koşulsuz sevginin
ve ruhsal birliğin kapısıdır.
''',
      'importance': '''
Kalp çakrası, alt ve üst çakralar arasındaki köprüdür. İki partnerin
kalpleri birleştiğinde, bu köprü genişler ve kozmik sevgiye açılır.
Kalpsiz birlik, tantrik değildir.
''',
      'practices': [
        {
          'name': 'Kalp Rezonansı',
          'description': 'Kalp atışlarını hissetme pratiği',
          'steps': [
            'Partnerinizin göğsüne kulağınızı koyun.',
            'Kalp atışını dinleyin.',
            'Kendi kalp atışınızı hissedin.',
            'İki kalbin birlikte attığını hayal edin.',
            '5-10 dakika bu dinlemede kalın.',
          ],
          'effects': [
            'Oksitosih salınımı',
            'Derin güven oluşumu',
            'Kalp açılması',
            'Bağlanma güçlenmesi',
          ],
        },
        {
          'name': 'Kalp Kucaklaması',
          'description': 'Kalp hizasında kucaklama pratiği',
          'steps': [
            'Ayakta veya oturarak karşı karşıya durun.',
            'Kalplerınız birbirine değecek şekilde sarılın.',
            'Nefeslerinizi uyumluyin.',
            'Kalpler arasında ışık hayal edin.',
            '5-15 dakika bu kucaklamada kalın.',
          ],
          'effects': [
            'Kalp çakra aktivasyonu',
            'Sevgi hormonları',
            'Duygusal şifa',
            'Derin bağ',
          ],
        },
        {
          'name': 'Kalp Mühürü',
          'description': 'Sevgi niyetini mühürleme',
          'steps': [
            'Özel bir anın sonunda, kalplerinizi birleştirin.',
            'Birlikte bir niyet belirleyin.',
            'Bu niyeti kalplerinize yerleştirin.',
            '"Bu sevgi mühürlendi" deyin.',
            'Bir anlık sessizlikle tamamlayın.',
          ],
          'effects': [
            'Spiritüel bağ güçlenir',
            'Niyet gerçekleşme gücü',
            'Kutsal söz',
            'Ritüel tamamlama',
          ],
        },
      ],
      'dailyPractice': {
        'name': 'Günlük Kalp Bağlantısı',
        'description': 'Her gün birkaç dakikalık kalp teması',
        'steps': [
          'Günde en az bir kez göz teması kurun.',
          'Kalplerinizi fiziksel olarak yaklaştırın.',
          'Birbirinize teşekkür edin.',
          'Sevginizi sözel olarak ifade edin.',
          'Bir anlık sessiz birliktelik yaşayın.',
        ],
        'duration': '5-10 dakika',
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // KUTSAL ALAN OLUŞTURMA
    // ─────────────────────────────────────────────────────────────────────────
    'sacredSpaceCreation': {
      'overview': '''
Tantrik pratik, kutsal bir alan gerektirir. Bu alan, fiziksel ortamın
düzenlenmesi kadar, zihinsel ve enerjetik hazırlığı da kapsar.
Kutsal alan, günlük yaşamdan spiritüel alana geçişi simgeler.
''',
      'physicalSpace': {
        'elements': [
          {
            'name': 'Temizlik',
            'description': 'Mekanın fiziksel arınması',
            'suggestions': [
              'Düzenli ve temiz ortam',
              'Dağınıklıktan arınma',
              'Doğal temizlik ürünleri',
              'Havalandırma',
            ],
          },
          {
            'name': 'Aydınlatma',
            'description': 'Yumuşak ve sıcak ışık',
            'suggestions': [
              'Mum ışığı (güvenli yerleşim)',
              'Dimlenebilir ışıklar',
              'Tuz lambası',
              'Doğal ışık (gündüz)',
            ],
          },
          {
            'name': 'Koku',
            'description': 'Aromatik atmosfer',
            'suggestions': [
              'Tütsü (sandal, amber, gül)',
              'Esansiyel yağlar',
              'Taze çiçekler',
              'Doğal kokular',
            ],
          },
          {
            'name': 'Ses',
            'description': 'Destekleyici ses ortamı',
            'suggestions': [
              'Sessizlik',
              'Yumuşak meditasyon müziği',
              'Doğa sesleri',
              'Tibet kaseleri',
            ],
          },
          {
            'name': 'Dokunma',
            'description': 'Rahatlatıcı dokular',
            'suggestions': [
              'Yumuşak kumaşlar',
              'Rahat yataklar/mindeler',
              'Sıcak battaniyeler',
              'Doğal lifler',
            ],
          },
        ],
      },
      'energeticCleansing': {
        'methods': [
          {
            'name': 'Adaçayı ile Tütsüleme',
            'description': 'Mekanı olumsuz enerjiden arındırma',
            'steps': [
              'Adaçayı demetini yak.',
              'Odanın her köşesinde gezdır.',
              'Arınma niyetini belirt.',
              'Pencereleri açarak enerjiyi dışarı gönder.',
            ],
          },
          {
            'name': 'Ses ile Arınma',
            'description': 'Ses titreşimleriyle alan temizleme',
            'steps': [
              'Tibet kasesi veya zil çal.',
              'Sesi odada gezdır.',
              'OM mantrasını söyle.',
              'Titreşimin her yere ulaşmasını sağla.',
            ],
          },
          {
            'name': 'Niyet ile Arınma',
            'description': 'Zihinsel temizleme',
            'steps': [
              'Mekanın merkezinde dur.',
              'Arınma niyetini belirt.',
              'Işık görselleştirmesi yap.',
              'Kutsal koruma çağır.',
            ],
          },
        ],
      },
      'sacredObjects': {
        'suggestions': [
          {
            'item': 'Sunak (Altar)',
            'purpose': 'Spiritüel odak noktası',
            'elements': ['Mum', 'Çiçek', 'Kristal', 'Kutsal semboller'],
          },
          {
            'item': 'Kristaller',
            'purpose': 'Enerji yükseltme ve koruma',
            'suggestions': ['Gül kuvars', 'Ametist', 'Temiz kuvars'],
          },
          {
            'item': 'Kutsal Metinler',
            'purpose': 'İlham ve rehberlik',
            'suggestions': ['Tantra metinleri', 'Şiirler', 'Afirmasyonlar'],
          },
          {
            'item': 'Doğal Elementler',
            'purpose': 'Topraklama ve bağlantı',
            'suggestions': ['Bitkiler', 'Taşlar', 'Su', 'Tüyler'],
          },
        ],
      },
      'ritualOpening': {
        'name': 'Kutsal Alan Açma Ritüeli',
        'steps': [
          'Mekanı fiziksel olarak hazırlayın.',
          'Enerjetik temizlik yapın.',
          'Birlikte nefes alın.',
          'Niyetinizi belirleyin ve paylaşın.',
          'Kutsal koruma çağırın.',
          'Birbirinize saygı gösterin (namaste).',
          'Ritüelin başladığını ilan edin.',
        ],
      },
      'ritualClosing': {
        'name': 'Kutsal Alan Kapama Ritüeli',
        'steps': [
          'Sessizliğe geçin.',
          'Deneyime şükret.',
          'Birbirinize teşekkür edin.',
          'Enerjiyi toprakla.',
          'Korumayı kapatın.',
          'Mumları söndürün.',
          'Günlük bilince dönün.',
        ],
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // TANTRİK DOKUNUŞ İLKELERİ
    // ─────────────────────────────────────────────────────────────────────────
    'tantricTouchPrinciples': {
      'overview': '''
Tantrik dokunuş, sıradan dokunuştan farklıdır. Bilinç, niyet ve
farkındalıkla dolu bir enerji aktarımıdır. Her dokunuş, bir meditasyon,
bir dua, bir şifa olabilir.
''',
      'principles': [
        {
          'name': 'Mevcudiyet',
          'description': 'Tamamen şimdiki anda var olmak',
          'explanation': '''
Tantrik dokunuş, tam mevcudiyet gerektirir. Zihin geçmişte veya
gelecekte değil, tam olarak bu anda, bu dokunuşta olmalıdır.
Dikkat dağınıkken dokunuş, enerjiden yoksun kalır.
''',
          'practice': 'Her dokunuştan önce bir nefes al ve o ana gel.',
        },
        {
          'name': 'Niyet',
          'description': 'Dokunuşa anlam katmak',
          'explanation': '''
Her dokunuş bir niyet taşıyabilir: şifa, sevgi, teselli, haz.
Bu niyet, dokunuşun enerjisini belirler. Niyetsiz dokunuş,
yalnızca fiziksel temas olarak kalır.
''',
          'practice': 'Dokunmadan önce niyetini içinden belirle.',
        },
        {
          'name': 'Yavaşlık',
          'description': 'Acele etmeden, sabırla dokunmak',
          'explanation': '''
Tantrik dokunuş yavaştır. Hız, farkındalığı öldürür.
Yavaşlık, her dokunuşun derinleşmesini, her anın genişlemesini
sağlar. Sabır, erdemdir.
''',
          'practice': 'Normal hızının yarısında dokun.',
        },
        {
          'name': 'Dinleme',
          'description': 'Dokunarak dinlemek',
          'explanation': '''
Tantrik dokunuş, iki yönlü iletişimdir. Yalnızca vermek değil,
almak da vardır. Eller, partnerinizin bedenini, enerjisini,
ihtiyaçlarını dinler.
''',
          'practice': 'Dokunurken partnerinin tepkilerini gözlemle.',
        },
        {
          'name': 'Şükran',
          'description': 'Minnettarlıkla dokunmak',
          'explanation': '''
Her dokunuş, bir ayrıcalıktır. Bir başka ruhun bedenine
dokunabilmek, kutsal bir izindir. Bu farkındalık, dokunuşu
kutsal kılar.
''',
          'practice': 'Her dokunuşla içinden "teşekkür ederim" de.',
        },
      ],
      'touchMeditation': {
        'name': 'Dokunuş Meditasyonu',
        'description': 'Eller aracılığıyla bağlantı ve şifa',
        'steps': [
          'Partneriniz rahat bir pozisyonda uzansın.',
          'Ellerinizi birkaç dakika ovuşturarak ısıtın.',
          'Ellerinizi partnerinizin omuzlarına koyun.',
          '3 derin nefes alın, bağlantıyı kurun.',
          'Çok yavaş hareketlerle bedenini keşfedin.',
          'Her bölgede birkaç nefes kalın.',
          'Gerilim veya soğukluk hissederseniz orada kalın.',
          'Enerjinin ellerinizden aktığını hayal edin.',
          '20-30 dakika bu meditasyonu sürdürün.',
          'Kalp bölgesinde sonlandırın.',
          'Ellerinizi yavaşça çekin.',
          'Birkaç dakika sessiz kalın.',
        ],
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // MAİTHUNA FELSEFESİ
    // ─────────────────────────────────────────────────────────────────────────
    'maithunaPhilosophy': {
      'overview': '''
Maithuna, Tantrik gelenekte kutsal birliği ifade eder. Sanskritçe
"birleşme" anlamına gelir. Bu, yalnızca fiziksel değil, spiritüel
bir kavuşmadır. Shiva ve Shakti'nin kozmik dansının mikrokozmik
yansımasıdır.
''',
      'spiritualMeaning': '''
Maithuna'da, iki birey bireyselliklerinin ötesine geçer. Erkeksel
ve dişil prensipler birleşir. Bu birlik, evrenin yaratılışını
yansıtan kutsal bir eylemdir.

Her birlik, potansiyel bir yaratım, bir doğum taşır. Bu, fiziksel
doğum olabileceği gibi, spiritüel bir uyanış, yaratıcı bir ilham
veya bilinç genişlemesi de olabilir.
''',
      'sacredPrinciples': [
        {
          'name': 'Saygı (Shradda)',
          'description': 'Partnere tanrısal varlık olarak yaklaşmak',
          'explanation': '''
Maithuna'da, partner yalnızca bir insan değil, ilahi olanın
tezahürüdür. Kadın, Shakti'nin, erkek, Shiva'nın bedenleşmesidir.
Bu bakış açısı, birliği kutsal kılar.
''',
        },
        {
          'name': 'Bilinç (Chaitanya)',
          'description': 'Tam farkındalık ve mevcudiyet',
          'explanation': '''
Maithuna, meditasyondur. Zihin kaybolmamalı, tam tersi, en
keskin farkındalık haline gelmelidir. Her an, her duyum,
bilinçli olarak deneyimlenir.
''',
        },
        {
          'name': 'Sublimation (Urdhvareta)',
          'description': 'Enerjinin yukarı yönlendirilmesi',
          'explanation': '''
Cinsel enerji, en güçlü yaşam enerjisidir. Tantrik pratikte,
bu enerji yalnızca dışa değil, içe ve yukarıya yönlendirilir.
Bu, Kundalini uyanışını destekler.
''',
        },
        {
          'name': 'Teslimiyet (Prapatti)',
          'description': 'Ego\'nun ilahi olana teslimi',
          'explanation': '''
Maithuna'nın zirvesinde, bireysel kimlik çözülür. Kontrolü
bırakmak, ilahi akışa teslim olmak gerekir. Bu teslimiyet,
özgürleşmenin kapısıdır.
''',
        },
      ],
      'preparation': {
        'physical': [
          'Temizlik ve arınma',
          'Hafif beslenme',
          'Dinlenmiş olmak',
          'Sağlıklı beden',
        ],
        'emotional': [
          'Duygusal denge',
          'Partnerle uyum',
          'Geçmiş sorunların çözümü',
          'Açık iletişim',
        ],
        'spiritual': [
          'Meditasyon pratiği',
          'Niyet netliği',
          'Adanmışlık hali',
          'Kutsal alan hazırlığı',
        ],
      },
      'stages': [
        {
          'stage': 'Arambha - Başlangıç',
          'description': 'Hazırlık ve niyet belirleme',
          'duration': '15-30 dakika',
        },
        {
          'stage': 'Pratyahara - İçe Çekilme',
          'description': 'Dış dünyadan içe dönüş',
          'duration': '10-20 dakika',
        },
        {
          'stage': 'Dharana - Odaklanma',
          'description': 'Partnere ve birliğe odaklanma',
          'duration': 'Değişken',
        },
        {
          'stage': 'Dhyana - Meditasyon',
          'description': 'Birlik içinde meditasyon hali',
          'duration': 'Değişken',
        },
        {
          'stage': 'Samadhi - Birlik',
          'description': 'Ego çözülmesi ve kozmik birlik',
          'duration': 'Zamansız',
        },
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // İLAHİ DİŞİL VE ERKEKSİL
    // ─────────────────────────────────────────────────────────────────────────
    'divineEnergyPrinciples': {
      'shakti': {
        'name': 'Shakti - İlahi Dişil',
        'description': '''
Shakti, evrenin yaratıcı gücüdür. Dinamik, aktif, hareket eden
enerjidir. Doğanın, bereketin, üretkenliğin kaynağıdır.

Her kadın, Shakti'nin tezahürüdür. Ancak her erkek de içinde
Shakti taşır. Bu enerji, yaratıcılık, sezgi, duygu ve akış ile
ifade bulur.
''',
        'qualities': [
          'Yaratıcılık ve bereket',
          'Sezgi ve bilgelik',
          'Akış ve değişim',
          'Besleyicilik ve koruma',
          'Tutku ve hareket',
          'Doğayla bağlantı',
        ],
        'manifestations': [
          'Kundalini enerjisi olarak',
          'Yaratıcı ilham olarak',
          'Maternal sevgi olarak',
          'Doğanın gücü olarak',
          'Dönüştürücü ateş olarak',
        ],
        'honoring': [
          'Kadınsal enerjiye saygı',
          'Doğa ile bağlantı',
          'Yaratıcı ifade',
          'Sezgiye güven',
          'Ay döngüleriyle uyum',
        ],
      },
      'shiva': {
        'name': 'Shiva - İlahi Erkeksel',
        'description': '''
Shiva, saf, değişmez bilinçtir. Durağan, tanık, gözlemleyen
prensiptir. Shakti'nin dansının sahne olduğu sonsuz uzaydır.

Her erkek, Shiva'nın tezahürüdür. Ancak her kadın da içinde
Shiva taşır. Bu enerji, bilinç, kararlılık, koruma ve tanıklık
ile ifade bulur.
''',
        'qualities': [
          'Saf bilinç ve tanıklık',
          'Kararlılık ve güç',
          'Koruyuculuk ve sınır',
          'Durağanlık ve huzur',
          'Dönüşüm ve yıkım',
          'Aşkınlık ve özgürlük',
        ],
        'manifestations': [
          'Tanık bilinç olarak',
          'Koruyucu güç olarak',
          'Dönüştürücü ateş olarak',
          'Meditasyon derinliği olarak',
          'Özgürleştirici bilgelik olarak',
        ],
        'honoring': [
          'Erkeksel enerjiye saygı',
          'Bilinç pratiği',
          'Meditasyon disiplini',
          'Koruyucu güç',
          'Güneş döngüleriyle uyum',
        ],
      },
      'union': {
        'name': 'Ardhanarishvara - Bütünlük',
        'description': '''
Shiva ve Shakti'nin birliği, Ardhanarishvara'dır - yarısı erkek,
yarısı kadın olan ilahi form. Bu, dualite ötesindeki bütünlüğün
sembolüdür.

Her birey bu bütünlüğü içinde taşır. Tantrik pratik, bu iç dengeyi
keşfetmeyi ve deneyimlemeyi amaçlar. Partner ile birlik, bu iç
birliğin dış yansımasıdır.
''',
        'practices': [
          'İç dengeyi keşfetme meditasyonu',
          'Erkeksel ve dişil yönleri onurlandırma',
          'Kutupları dengeleme pratiği',
          'Bütünlük görselleştirmesi',
        ],
      },
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BÖLÜM 4: EZOTERİK RİTÜELLER
  // Ay Fazları, Gezegen Saatleri, Semboller ve Mantralar
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, dynamic> esotericRituals = {
    // ─────────────────────────────────────────────────────────────────────────
    // AY FAZI RİTÜELLERİ
    // ─────────────────────────────────────────────────────────────────────────
    'moonPhaseRituals': {
      'overview': '''
Ay, kadınsal enerji ve duygusal döngülerle derin bağlantılıdır.
Tantrik gelenekte, Ay (Chandra), Ida nadi ile ilişkilidir ve
sezgi, alıcılık ve iç dünya ile bağlantı kurar.

Her Ay fazı, farklı enerjiler taşır ve farklı pratikler için
uygundur. Bu döngüleri takip etmek, doğal akışla uyum sağlar.
''',
      'phases': [
        {
          'phase': 'Yeni Ay (Amavasya)',
          'energy': 'Başlangıç, tohum ekme, içe dönüş',
          'description': '''
Yeni Ay, karanlığın zirvesidir. Görünmez Ay, içsel çalışmalar
için idealdir. Bu dönem, yeni niyetler ekmek, bilinçaltına
tohum bırakmak için uygundur.
''',
          'rituals': [
            {
              'name': 'Yeni Ay Niyet Ritüeli',
              'timing': 'Yeni Ay gecesi',
              'steps': [
                'Karanlık ve sessiz bir alan oluştur.',
                'Tek bir mum yak (siyah veya koyu mor).',
                'Meditasyona otur, içe dön.',
                'Önümüzdeki ay döngüsü için niyetini belirle.',
                'Bu niyeti bir kağıda yaz.',
                'Kağıdı muma yaklaştır ve alevin önünde oku.',
                'Niyetini toprağa göm veya güvenli bir yerde sakla.',
                'Sessizlikle ritüeli kapat.',
              ],
              'focus': 'Başlangıçlar, bilinçaltı, gizli potansiyel',
            },
            {
              'name': 'Gölge Çalışması',
              'timing': 'Yeni Ay etrafındaki 3 gün',
              'description': '''
Yeni Ay, bilinçdışıyla yüzleşmek için güçlü bir zamandır.
Bastırılmış yönler, korkular ve gölge kendileri bu dönemde
daha erişilebilir olur.
''',
              'steps': [
                'Karanlık bir odada meditasyona otur.',
                'Korkularını ve bastırdıklarını düşün.',
                'Bu yönleri yargılamadan gözlemle.',
                'Gölgeni kabul et ve entegre et.',
                'Günlüğüne keşiflerini yaz.',
              ],
            },
          ],
          'tantricPractice': '''
Yeni Ay, cinsel enerjinin içe yönlendirilmesi için idealdir.
Brahmacharya (enerji muhafazası) veya solo enerji çalışması
bu dönemde derinleşir. Partner pratikleri yerine bireysel
içsel çalışmalar tercih edilir.
''',
        },
        {
          'phase': 'Hilal Ay (Şukla Paksha Başlangıcı)',
          'energy': 'Büyüme, çıkış, harekete geçme',
          'description': '''
İlk ışık görünür. Karanlıktan aydınlığa geçiş başlar.
Bu dönem, niyetleri eyleme dönüştürmek, projelere
başlamak için uygundur.
''',
          'rituals': [
            {
              'name': 'Filizlenme Ritüeli',
              'timing': 'Hilal görünür görünmez',
              'steps': [
                'Yeni Ay\'da belirlediğin niyeti hatırla.',
                'Bu niyet için ilk adımı belirle.',
                'Bir tohum veya bitki ek.',
                'Bu tohum, niyetinin fiziksel sembolü olsun.',
                'Büyümesini gözlemle ve niyetinle bağlantıla.',
              ],
              'focus': 'Başlangıç cesareti, ilk adım',
            },
          ],
          'tantricPractice': '''
Hilal Ay döneminde, enerji dışa akmaya başlar. Bu dönemde
partnere açılmak, yeni yakınlık formları denemek uygundur.
Enerji hâlâ hassastır, nazik ve yavaş pratikler idealdir.
''',
        },
        {
          'phase': 'İlk Dördün',
          'energy': 'Mücadele, karar, harekete geçme',
          'description': '''
Ay yarısı aydınlık, yarısı karanlıktır. Bu denge noktası,
kararların, taahhütlerin zamanıdır. Engellerle yüzleşme
ve aşma enerjisi güçlüdür.
''',
          'rituals': [
            {
              'name': 'Engel Aşma Ritüeli',
              'timing': 'İlk Dördün gecesi',
              'steps': [
                'Niyetinin önündeki engelleri listele.',
                'Her engel için bir çözüm düşün.',
                'Bu engelleri temsil eden bir nesne al.',
                'Nesneyi dönüştür veya bırak.',
                'Kararlılığını sesli olarak beyan et.',
              ],
              'focus': 'Kararlılık, engel aşma, taahhüt',
            },
          ],
          'tantricPractice': '''
İlk Dördün, partner çalışmalarında kararlılık ve güç için
uygundur. Aktif, dinamik pratikler tercih edilir. İrade
gücü ve karar verme odaklı çalışmalar desteklenir.
''',
        },
        {
          'phase': 'Dolunay (Purnima)',
          'energy': 'Doruk, bereket, kutlama, aydınlanma',
          'description': '''
Ay tam doluluğunda, ışığın zirvesindedir. Enerjiler en
yüksektedir. Bu dönem, kutlama, şükran ve doruk deneyimler
için uygundur. Meditasyon derinleşir, sezgi keskinleşir.
''',
          'rituals': [
            {
              'name': 'Dolunay Kutlama Ritüeli',
              'timing': 'Dolunay gecesi, Ay görünürken',
              'steps': [
                'Açık havada, Ay ışığında bir alan oluştur.',
                'Beyaz mum yak.',
                'Ay ışığının üzerine düşmesine izin ver.',
                'Başarılarını ve bereketlerini hatırla.',
                'Şükran listesi yaz veya söyle.',
                'Ay ışığında dans et veya hareket et.',
                'Su veya kristalleri Ay ışığında şarj et.',
              ],
              'focus': 'Bereket, şükran, kutlama, doruk',
            },
            {
              'name': 'Dolunay Meditasyonu',
              'timing': 'Gece yarısına doğru',
              'steps': [
                'Ay\'ın göründüğü bir yerde otur.',
                'Gözlerini aç ve Ay\'a bak.',
                'Ay ışığının üçüncü gözüne aktığını hayal et.',
                'Bu ışıkla dolduğunu hisset.',
                '30 dakika bu bağlantıda kal.',
                'Sezgisel mesajlara açık ol.',
              ],
              'focus': 'Aydınlanma, sezgi, tanrısal bağlantı',
            },
          ],
          'tantricPractice': '''
Dolunay, tantrik birliğin en güçlü zamanıdır. Enerjiler
doruktadır ve doruk deneyimler kolaylaşır. Shakti enerjisi
maksimum güçtedir. Derin partner pratikleri ve Kundalini
çalışmaları için idealdir.
''',
        },
        {
          'phase': 'Azalan Ay (Krishna Paksha)',
          'energy': 'Bırakma, arınma, azaltma',
          'description': '''
Dolunay'dan sonra Ay küçülmeye başlar. Bu dönem, artık
işe yaramayanı bırakmak, arınmak ve sadeleşmek için
uygundur. İç temizlik zamanıdır.
''',
          'rituals': [
            {
              'name': 'Bırakma Ritüeli',
              'timing': 'Azalan Ay döneminin herhangi bir gecesi',
              'steps': [
                'Bırakmak istediklerini listele.',
                'Her maddeyi bir kağıda yaz.',
                'Kağıtları güvenli şekilde yak.',
                'Küllerin rüzgara veya suya verilmesini izle.',
                'Her bırakışla nefes ver.',
                '"Bırakıyorum" de.',
              ],
              'focus': 'Bırakma, arınma, hafiflik',
            },
            {
              'name': 'Detoks Ritüeli',
              'timing': 'Azalan Ay boyunca',
              'description': '''
Bu dönem, fiziksel ve enerjetik detoks için idealdir.
Oruç, temizleme diyetleri ve arınma pratikleri desteklenir.
''',
              'suggestions': [
                'Hafif beslenme veya oruç',
                'Su içmeyi artır',
                'Dijital detoks',
                'Eski eşyalardan kurtul',
                'Mekan temizliği',
              ],
            },
          ],
          'tantricPractice': '''
Azalan Ay döneminde, cinsel enerji içe ve yukarı yönlendirilir.
Enerji muhafazası (brahmacharya) pratikleri desteklenir.
Bu dönem, enerjiyi biriktirip Kundalini çalışmasına yönlendirmek
için uygundur.
''',
        },
        {
          'phase': 'Son Dördün',
          'energy': 'Değerlendirme, tamamlama, hazırlık',
          'description': '''
Tekrar yarı aydınlık, yarı karanlık. Bu denge noktası,
döngünün değerlendirilmesi, tamamlanmamışların bitirilmesi
ve yeni döngüye hazırlık zamanıdır.
''',
          'rituals': [
            {
              'name': 'Döngü Değerlendirmesi',
              'timing': 'Son Dördün gecesi',
              'steps': [
                'Geçen Ay döngüsünü değerlendir.',
                'Başardıklarını ve başaramadıklarını listele.',
                'Derslerini çıkar.',
                'Tamamlanmamışları tamamla veya bırak.',
                'Yeni döngü için hazırlan.',
              ],
              'focus': 'Değerlendirme, dersler, tamamlama',
            },
          ],
          'tantricPractice': '''
Son Dördün, dengeleme zamanıdır. Partner ile açık iletişim,
döngünün değerlendirilmesi ve ilişkinin değerlendirilmesi
için uygundur. Denge odaklı pratikler tercih edilir.
''',
        },
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // GEZEGEN SAATİ PRATİKLERİ
    // ─────────────────────────────────────────────────────────────────────────
    'planetaryHourPractices': {
      'overview': '''
Kadim astrolojide, günün her saati bir gezegen tarafından yönetilir.
Bu gezegen saatleri, farklı enerjiler taşır ve farklı pratikler için
uygundur. Tantrik çalışmalar, bu saatlere uyumlanarak güçlendirilebilir.
''',
      'planetaryHours': [
        {
          'planet': 'Güneş (Surya)',
          'day': 'Pazar',
          'energy': 'Güç, canlılık, liderlik, benlik',
          'color': 'Altın, turuncu',
          'tantricPractice': '''
Güneş saatleri, solar pleksus çakra çalışması, irade gücü
pratikleri ve erkeksel enerji aktivasyonu için uygundur.
Güneş enerjisi, Pingala nadi'yi aktive eder.
''',
          'rituals': [
            'Güneş selamlaması (Surya Namaskar)',
            'Solar pleksus meditasyonu',
            'Altın ışık görselleştirmesi',
            'RAM mantra pratiği',
          ],
          'crystals': ['Sitrin', 'Kaplan Gözü', 'Güneş Taşı'],
        },
        {
          'planet': 'Ay (Chandra)',
          'day': 'Pazartesi',
          'energy': 'Sezgi, duygular, anne, iç dünya',
          'color': 'Gümüş, beyaz',
          'tantricPractice': '''
Ay saatleri, sezgisel çalışmalar, duygusal şifa ve dişil enerji
pratikleri için uygundur. Ay enerjisi, Ida nadi'yi aktive eder.
Kalp ve sakral çakra çalışmaları desteklenir.
''',
          'rituals': [
            'Ay meditasyonu',
            'Sakral çakra aktivasyonu',
            'Su elementi çalışması',
            'VAM mantra pratiği',
          ],
          'crystals': ['Ay Taşı', 'Sedef', 'Opal'],
        },
        {
          'planet': 'Mars (Mangal)',
          'day': 'Salı',
          'energy': 'Enerji, tutku, cesaret, cinsellik',
          'color': 'Kırmızı',
          'tantricPractice': '''
Mars saatleri, Kundalini aktivasyonu, cinsel enerji çalışması
ve kök çakra pratikleri için güçlüdür. Dinamik ve aktif
tantrik pratikler desteklenir.
''',
          'rituals': [
            'Kök çakra aktivasyonu',
            'Kundalini nefesi',
            'Enerji yükseltme pratiği',
            'LAM mantra pratiği',
          ],
          'crystals': ['Kırmızı Jasper', 'Garnet', 'Kanlı Taş'],
        },
        {
          'planet': 'Merkür (Budha)',
          'day': 'Çarşamba',
          'energy': 'İletişim, zeka, öğrenme',
          'color': 'Yeşil',
          'tantricPractice': '''
Merkür saatleri, mantra pratiği, kutsal metinler okuma
ve boğaz çakra çalışması için uygundur. İletişim ve
ifade odaklı tantrik pratikler desteklenir.
''',
          'rituals': [
            'Mantra meditasyonu',
            'Kutsal metin okuma',
            'Boğaz çakra aktivasyonu',
            'HAM mantra pratiği',
          ],
          'crystals': ['Yeşil Aventurin', 'Zümrüt', 'Peridot'],
        },
        {
          'planet': 'Jüpiter (Guru)',
          'day': 'Perşembe',
          'energy': 'Bilgelik, genişleme, spiritüellik',
          'color': 'Sarı, mor',
          'tantricPractice': '''
Jüpiter saatleri, spiritüel öğreti alma, guru'ya bağlanma
ve taç çakra çalışması için idealdir. Aydınlanma ve
genişleme odaklı pratikler desteklenir.
''',
          'rituals': [
            'Guru puja',
            'Taç çakra meditasyonu',
            'Bilgelik niyeti',
            'OM mantra pratiği',
          ],
          'crystals': ['Ametist', 'Safir', 'Lapis Lazuli'],
        },
        {
          'planet': 'Venüs (Shukra)',
          'day': 'Cuma',
          'energy': 'Aşk, güzellik, ilişkiler, haz',
          'color': 'Pembe, yeşil',
          'tantricPractice': '''
Venüs saatleri, partner pratikleri, kalp çakra çalışması
ve kutsal birlik için en uygun zamandır. Aşk, haz ve
güzellik odaklı tantrik pratikler desteklenir.
''',
          'rituals': [
            'Kalp çakra meditasyonu',
            'Partner ritüeli',
            'Güzellik takdiri',
            'YAM mantra pratiği',
          ],
          'crystals': ['Gül Kuvars', 'Yeşim', 'Zümrüt'],
        },
        {
          'planet': 'Satürn (Shani)',
          'day': 'Cumartesi',
          'energy': 'Disiplin, karma, dersler, yapı',
          'color': 'Siyah, lacivert',
          'tantricPractice': '''
Satürn saatleri, karma temizliği, disiplin pratiği ve
derin meditasyon için uygundur. Gölge çalışması ve
sınırları aşma pratikleri desteklenir.
''',
          'rituals': [
            'Karma meditasyonu',
            'Gölge çalışması',
            'Disiplin niyeti',
            'Sessizlik pratiği',
          ],
          'crystals': ['Obsidyen', 'Oniks', 'Hematit'],
        },
      ],
      'howToCalculate': '''
Gezegen saatlerini hesaplamak için:
1. Gün doğumu ve gün batımı saatlerini belirle.
2. Gündüz süresini 12'ye böl (gündüz saati uzunluğu).
3. Gece süresini 12'ye böl (gece saati uzunluğu).
4. İlk gündüz saati, o günün yönetici gezegenine aittir.
5. Sırasıyla: Güneş, Venüs, Merkür, Ay, Satürn, Jüpiter, Mars.
''',
    },

    // ─────────────────────────────────────────────────────────────────────────
    // YONİ VE LİNGAM SEMBOLİZMİ
    // ─────────────────────────────────────────────────────────────────────────
    'sacredSymbolism': {
      'overview': '''
Tantra'da, Yoni ve Lingam kutsal sembollerdir. Bunlar, fiziksel
organlardan çok öte, kozmik prensipleri temsil eder. Shakti ve
Shiva'nın, yaratıcı ve bilinç güçlerinin sembolleridir.
''',
      'yoni': {
        'name': 'Yoni',
        'meaning': 'Kaynak, Rahm, Kutsal Dişil',
        'symbolism': '''
Yoni, Sanskrit'te "kaynak" veya "rahm" anlamına gelir. Bu sembol,
yaratıcı Shakti gücünü, doğurganlığı ve evreni doğuran ana rahmini
temsil eder.

Yoni, boşluk ve potansiyel alandır. Shunya (boşluk) kavramıyla
bağlantılıdır. Tüm varlığın çıktığı ve döneceği kozmik rahmdir.
''',
        'spiritualMeaning': [
          'Yaratıcı potansiyel',
          'Doğurganlık ve bereket',
          'Kozmik ana rahmi',
          'Alıcı, kapsayıcı enerji',
          'Shakti\'nin sembolü',
        ],
        'meditation': {
          'name': 'Yoni Mudra Meditasyonu',
          'description': 'Dişil enerji ile bağlantı',
          'steps': [
            'Rahat bir pozisyonda otur.',
            'Ellerini yoni şeklinde birleştir (baş parmaklar üstte, işaret parmakları altta).',
            'Bu mudra\'yı kalbinin önünde tut.',
            'Shakti enerjisini çağır.',
            'Yaratıcı potansiyelinle bağlan.',
            '10-20 dakika meditasyonda kal.',
          ],
        },
      },
      'lingam': {
        'name': 'Lingam',
        'meaning': 'İşaret, Sembol, Kutsal Erkeksel',
        'symbolism': '''
Lingam, Sanskrit'te "işaret" veya "sembol" anlamına gelir. Bu sembol,
saf bilinç Shiva'yı, yaratıcı gücü ve evrenin eksenini temsil eder.

Lingam, genellikle Yoni içinde tasvir edilir ve bu, Shiva-Shakti
birliğini, bilinç ve enerjinin birleşimini simgeler. Bu birlik,
evrenin yaratılışının ve sürdürülüşünün sembolüdür.
''',
        'spiritualMeaning': [
          'Saf bilinç',
          'Yaratıcı güç',
          'Evrensel eksen (axis mundi)',
          'Verici, yönlendirici enerji',
          'Shiva\'nın sembolü',
        ],
        'meditation': {
          'name': 'Lingam Dhyana',
          'description': 'Erkeksel bilinç ile bağlantı',
          'steps': [
            'Rahat bir pozisyonda otur.',
            'Omurganı bir ışık sütunu olarak hayal et.',
            'Bu sütunun evrenin eksenine bağlandığını gör.',
            'Shiva bilincini çağır.',
            'Saf farkındalıkla bağlan.',
            '10-20 dakika meditasyonda kal.',
          ],
        },
      },
      'unionSymbol': {
        'name': 'Yoni-Lingam Birliği',
        'symbolism': '''
Yoni içinde Lingam, kozmik birliğin sembolüdür. Bu imge, Shiva ve
Shakti'nin ayrılmaz birliğini, bilinç ve enerjinin dansını temsil eder.

Bu sembol, yaratılışın gizemini taşır. Boşluktan (Yoni) form (Lingam)
doğar ve form tekrar boşluğa döner. Bu sonsuz döngü, evrenin nefesidir.
''',
        'meditation': {
          'name': 'Birlik Meditasyonu',
          'steps': [
            'İçindeki erkeksel ve dişil enerjileri fark et.',
            'Bu iki enerjiyi omurganda birleştir.',
            'Birliğin hissini deneyimle.',
            'Dualite ötesine geç.',
            'Bütünlükte dinlen.',
          ],
        },
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // KUTSAL GEOMETRİ - YANTRALAR
    // ─────────────────────────────────────────────────────────────────────────
    'sacredGeometry': {
      'overview': '''
Yantra, Sanskrit'te "araç" veya "makine" anlamına gelir. Bunlar,
evrensel enerjileri odaklayan geometrik diyagramlardır. Tantra'da,
yantralar meditasyon ve ritüel için güçlü araçlardır.

Her yantra, belirli bir tanrısallığı veya enerjiyi temsil eder ve
meditasyon yoluyla bu enerjiyle bağlantı kurmayı sağlar.
''',
      'yantras': [
        {
          'name': 'Sri Yantra',
          'description': 'En kutsal ve karmaşık yantra',
          'symbolism': '''
Sri Yantra, dokuz iç içe geçmiş üçgenden oluşur. Dört yukarı bakan
üçgen Shiva'yı (bilinç), beş aşağı bakan üçgen Shakti'yi (enerji)
temsil eder. Merkezde, bindu (nokta) bulunur - saf potansiyel.

Bu yantra, tüm evrenin haritasıdır. Makrokozmos ve mikrokozmos
burada birleşir. Sri Yantra meditasyonu, kozmik bilince açar.
''',
          'meditation': {
            'steps': [
              'Sri Yantra\'yı göz hizasında yerleştir.',
              'Dış çemberden başlayarak içe doğru bak.',
              'Yavaşça merkeze, bindu\'ya ulaş.',
              'Bindu\'da odaklan ve kal.',
              'Yantra\'yı içselleştir.',
              'Gözleri kapatarak yantra\'yı içinde gör.',
              '20-40 dakika meditasyonda kal.',
            ],
            'benefits': [
              'Bilinç genişlemesi',
              'Bereket ve bolluk',
              'Tanrısal bağlantı',
              'Derin huzur',
            ],
          },
        },
        {
          'name': 'Çakra Yantraları',
          'description': 'Her çakranın geometrik temsili',
          'details': [
            {
              'chakra': 'Muladhara',
              'shape': 'Sarı kare içinde kırmızı lotus',
              'meaning': 'Toprak elementi, stabilite',
            },
            {
              'chakra': 'Svadhisthana',
              'shape': 'Hilal ay içinde turuncu lotus',
              'meaning': 'Su elementi, akış',
            },
            {
              'chakra': 'Manipura',
              'shape': 'Aşağı bakan üçgen içinde sarı lotus',
              'meaning': 'Ateş elementi, dönüşüm',
            },
            {
              'chakra': 'Anahata',
              'shape': 'Altı köşeli yıldız içinde yeşil lotus',
              'meaning': 'Hava elementi, denge',
            },
            {
              'chakra': 'Vishuddha',
              'shape': 'Daire içinde mavi lotus',
              'meaning': 'Eter elementi, uzay',
            },
            {
              'chakra': 'Ajna',
              'shape': 'OM içeren iki yapraklı lotus',
              'meaning': 'Işık elementi, sezgi',
            },
            {
              'chakra': 'Sahasrara',
              'shape': 'Bin yapraklı lotus',
              'meaning': 'Saf bilinç, aşkınlık',
            },
          ],
        },
        {
          'name': 'Kali Yantra',
          'description': 'Dönüşüm ve koruyucu güç',
          'symbolism': '''
Kali Yantra, beş aşağı bakan üçgenden oluşur. Shakti'nin
yıkıcı-dönüştürücü yönünü temsil eder. Korku ve ego'yu
yok eden, özgürleştiren enerji.
''',
          'uses': [
            'Korku ile yüzleşme',
            'Ego dönüşümü',
            'Koruma ritüelleri',
            'Derin dönüşüm çalışması',
          ],
        },
      ],
      'howToUse': {
        'preparation': [
          'Yantra\'yı temiz bir alana yerleştir.',
          'Mum veya tütsü yak.',
          'Niyetini belirle.',
          'Saygıyla yaklaş.',
        ],
        'meditation': [
          'Yumuşak bakışla yantra\'ya bak.',
          'Dıştan içe doğru ilerle.',
          'Merkeze ulaş ve orada kal.',
          'Gözleri kapatarak içselleştir.',
          'Yantra\'nın enerjisiyle birleş.',
        ],
        'aftercare': [
          'Şükranla ritüeli kapat.',
          'Yantra\'yı saygıyla sakla.',
          'Deneyimi günlüğe kaydet.',
        ],
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // MANTRA PRATİKLERİ
    // ─────────────────────────────────────────────────────────────────────────
    'mantraPractices': {
      'overview': '''
Mantra, Sanskrit'te "zihin aracı" anlamına gelir (man = zihin, tra = araç).
Mantralar, kutsal ses formülleridir ve titreşimleri yoluyla bilinç
durumlarını değiştirir, enerjileri aktive eder.

Tantrik gelenekte, mantralar ritüel ve meditasyonun temel araçlarıdır.
Doğru telaffuz ve niyet ile söylenen mantralar güçlü dönüşüm sağlar.
''',
      'mainMantras': [
        {
          'mantra': 'OM (AUM)',
          'meaning': 'Evrensel titreşim, yaratılışın sesi',
          'description': '''
OM, tüm mantraların anasıdır. Üç harf A-U-M, yaratılış-sürdürme-dönüşümü
temsil eder. Bu ses, evrenin temel titreşimidir ve tüm varlığı kapsar.

OM söylendiğinde, bilinç evrensel titreşimle uyumlanır. Bu mantra,
her türlü spiritüel pratiğin başlangıcı ve sonudur.
''',
          'pronunciation': 'AAAAAA-UUUUUU-MMMMMM',
          'chakra': 'Ajna ve Sahasrara',
          'practice': {
            'japa': '108 kez mala ile tekrar',
            'meditation': 'OM\'un titreşimini içte dinleme',
            'duration': '20-40 dakika',
          },
          'benefits': [
            'Bilinç genişlemesi',
            'Evrensel bağlantı',
            'İç huzur',
            'Çakra uyumu',
          ],
        },
        {
          'mantra': 'SO HAM',
          'meaning': 'Ben O\'yum - Bireysel ruhun evrensel ruhla birliği',
          'description': '''
SO HAM, nefesle birlikte söylenen doğal mantradır. Nefes alırken
SO (O), nefes verirken HAM (Ben). Bu mantra, Atman'ın (bireysel ruh)
Brahman'la (evrensel ruh) birliğini onaylar.

Her canlı, her nefeste farkında olmadan bu mantrayı söyler.
Bilinçli tekrar, bu doğal gerçeği farkındalığa getirir.
''',
          'pronunciation': 'Nefes al: SOOOOO, Nefes ver: HAMMMM',
          'chakra': 'Tüm çakralar',
          'practice': {
            'technique': 'Nefesle senkronize tekrar',
            'duration': '15-30 dakika',
          },
          'benefits': [
            'Birlik bilinci',
            'Nefes farkındalığı',
            'Ego çözülmesi',
            'Derin meditasyon',
          ],
        },
        {
          'mantra': 'OM NAMAH SHIVAYA',
          'meaning': 'Shiva\'ya selamlarım - Saf bilince teslimiyet',
          'description': '''
Bu beş heceli mantra (Panchakshara), Shiva'ya adanmıştır.
Shiva, saf bilinç, dönüşüm ve aydınlanma tanrısıdır.
Bu mantra, egonun Tanrısal olana teslimiyetini ifade eder.

Na-Ma-Shi-Va-Ya beş elementi temsil eder: toprak, su, ateş, hava, eter.
Bu mantra, tüm elementleri arındırır ve dengeler.
''',
          'pronunciation': 'OM NA-MAH SHI-VA-YA',
          'chakra': 'Tüm çakralar, özellikle Ajna',
          'practice': {
            'japa': '108 veya 1008 tekrar',
            'duration': '30-60 dakika',
          },
          'benefits': [
            'Shiva bağlantısı',
            'Ego teslimiyeti',
            'Element dengesi',
            'Dönüşüm ve arınma',
          ],
        },
        {
          'mantra': 'OM SHAKTI OM',
          'meaning': 'Evrensel enerji, ilahi dişil güç',
          'description': '''
Bu mantra, Shakti'yi - evrensel yaratıcı enerjiyi - çağırır.
Kundalini aktivasyonu ve dişil enerji ile bağlantı için kullanılır.
''',
          'pronunciation': 'OM SHAK-TI OM',
          'chakra': 'Muladhara, Svadhisthana, Anahata',
          'practice': {'japa': '108 tekrar', 'duration': '20-30 dakika'},
          'benefits': [
            'Shakti aktivasyonu',
            'Kundalini uyanışı',
            'Dişil enerji dengesi',
            'Yaratıcılık',
          ],
        },
        {
          'mantra': 'Gayatri Mantra',
          'fullText':
              'Om Bhur Bhuvaḥ Swaḥ, Tat Savitur Vareṇyaṃ, Bhargo Devasya Dhīmahi, Dhiyo Yo Naḥ Prachodayāt',
          'meaning': 'Güneş tanrısına dua - Aydınlanma ve bilgelik talebi',
          'description': '''
Gayatri, en kutsal Vedik mantradır. Güneş tanrısı Savitur'a yöneliktir
ve aydınlanmış bilinç için dua eder. Brahminlerin günde üç kez
okuduğu bu mantra, evrensel bilgeliği çağırır.
''',
          'pronunciation': 'Geleneksel Vedik telaffuz öğrenilmeli',
          'chakra': 'Ajna ve Sahasrara',
          'practice': {
            'times': 'Güneş doğuşu, öğlen, güneş batışı',
            'japa': '108 tekrar',
          },
          'benefits': [
            'Zihinsel aydınlanma',
            'Spiritüel bilgelik',
            'Arınma',
            'Güneş enerjisi',
          ],
        },
      ],
      'bijaMantrasSummary': {
        'description': 'Tek heceli tohum mantralar - çakra aktivasyonu için',
        'mantras': [
          {'bija': 'LAM', 'chakra': 'Muladhara', 'element': 'Toprak'},
          {'bija': 'VAM', 'chakra': 'Svadhisthana', 'element': 'Su'},
          {'bija': 'RAM', 'chakra': 'Manipura', 'element': 'Ateş'},
          {'bija': 'YAM', 'chakra': 'Anahata', 'element': 'Hava'},
          {'bija': 'HAM', 'chakra': 'Vishuddha', 'element': 'Eter'},
          {'bija': 'OM', 'chakra': 'Ajna', 'element': 'Işık/Zihin'},
          {'bija': 'Sessizlik', 'chakra': 'Sahasrara', 'element': 'Saf Bilinç'},
        ],
      },
      'japaPractice': {
        'description': 'Mala ile mantra tekrarı',
        'instructions': [
          'Kutsal bir alan oluştur.',
          'Rahat bir pozisyonda otur.',
          'Mala\'yı sağ elde tut.',
          'Orta parmak ve baş parmakla boncukları say.',
          'İşaret parmağını kullanma (ego\'yu temsil eder).',
          'Her boncukta bir mantra tekrarla.',
          'Guru boncuğunda dur, mantra söyleme.',
          'Devam edeceksen yön değiştir.',
          '108 boncuk bir tur.',
        ],
        'counts': {
          'standard': '108 (bir mala)',
          'deepPractice': '1008 (yaklaşık 10 mala)',
          'extended': '100.000+ (uzun süreli pratik)',
        },
      },
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BÖLÜM 5: TANTRİK ASTROLOJİ ENTEGRASYONU
  // Venüs, Mars, 8. Ev ve Tantrik Uyumluluk
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, dynamic> tantricAstrology = {
    // ─────────────────────────────────────────────────────────────────────────
    // VENÜS TANTRA - BURÇLARA GÖRE
    // ─────────────────────────────────────────────────────────────────────────
    'venusTantra': {
      'overview': '''
Venüs, astrolojide aşk, güzellik, haz ve ilişkilerin gezegenidir.
Tantrik perspektiften, Venüs Shakti enerjisinin tezahürüdür -
çekicilik, birleştirme ve yaratıcı haz gücü.

Doğum haritasında Venüs'ün burcu, kişinin sevme, sevilme ve
haz alma tarzını gösterir. Bu bilgi, tantrik pratiklerde partnerin
enerji dilini anlamak için değerlidir.
''',
      'byZodiac': {
        'aries': {
          'sign': 'Koç',
          'element': 'Ateş',
          'venusExpression': 'Tutkulu, spontan, fethetmeye yönelik',
          'tantricQualities': [
            'Yoğun ve anlık tutku',
            'Liderlik ve inisiyatif alma',
            'Fiziksel enerji ve hareket',
            'Macera ve yenilik arayışı',
            'Doğrudan ve cesur ifade',
          ],
          'sacredSexualityStyle': '''
Koç Venüsü, tutkulu ve aktif bir enerji taşır. Spontanlık ve
macera ister. Uzun hazırlıklardan çok, anlık ateşi tercih eder.
Partner pratiklerinde liderlik almaktan hoşlanır.
''',
          'tantricPractices': [
            'Aktif Kundalini nefesi',
            'Spontan dans ve hareket',
            'Güçlü enerji yükseltme',
            'Ateş elementi meditasyonu',
          ],
          'partnerTips': [
            'Spontanlığa açık ol',
            'İnisiyatif almasına izin ver',
            'Fiziksel aktivite içeren pratikler öner',
            'Enerjisine ayak uydur',
          ],
        },
        'taurus': {
          'sign': 'Boğa',
          'element': 'Toprak',
          'venusExpression': 'Duyusal, sadık, yavaş ve derin',
          'tantricQualities': [
            'Beş duyu odaklı deneyim',
            'Yavaş ve derin bağlantı',
            'Fiziksel konfor ve güzellik',
            'Sadakat ve güvenilirlik',
            'Doğal ve organik akış',
          ],
          'sacredSexualityStyle': '''
Boğa Venüsü, duyusal zevklerin ustasıdır. Acele etmez, her anın
tadını çıkarır. Dokunuş, koku, tat - tüm duyular önemlidir.
Güvenli ve güzel bir ortam şarttır.
''',
          'tantricPractices': [
            'Yavaş tantrik masaj',
            'Aromatik ritüeller',
            'Toprak elementi meditasyonu',
            'Beş duyu farkındalığı',
          ],
          'partnerTips': [
            'Acele etme, sabırlı ol',
            'Fiziksel ortamı güzelleştir',
            'Duyusal detaylara dikkat et',
            'Güven inşa etmeye zaman ayır',
          ],
        },
        'gemini': {
          'sign': 'İkizler',
          'element': 'Hava',
          'venusExpression': 'Meraklı, iletişimci, çeşitlilik arayan',
          'tantricQualities': [
            'Zihinsel uyarılma öncelikli',
            'Sözel iletişim ve flört',
            'Çeşitlilik ve yenilik',
            'Oyuncu ve hafif enerji',
            'Öğrenme ve keşif isteği',
          ],
          'sacredSexualityStyle': '''
İkizler Venüsü, zihinden başlar. Konuşma, flört ve entelektüel
bağlantı önemlidir. Monotonluktan kaçınır, yenilik ister.
Sözel ifade ve geri bildirim değerlidir.
''',
          'tantricPractices': [
            'Mantra ve ses çalışmaları',
            'Partner iletişim ritüelleri',
            'Nefes paylaşımı pratikleri',
            'Keşfedici, çeşitli pratikler',
          ],
          'partnerTips': [
            'Konuşmayı ihmal etme',
            'Yeni şeyler öner',
            'Zihinsel bağlantı kur',
            'Hafif ve oyuncu ol',
          ],
        },
        'cancer': {
          'sign': 'Yengeç',
          'element': 'Su',
          'venusExpression': 'Duygusal, bakım veren, koruyucu',
          'tantricQualities': [
            'Derin duygusal bağ ihtiyacı',
            'Besleyici ve koruyucu enerji',
            'Yuva ve güvenlik önceliği',
            'Sezgisel ve empatik',
            'Geçmişe ve anılara bağlılık',
          ],
          'sacredSexualityStyle': '''
Yengeç Venüsü, duygusal güvenlik arar. Önce kalpten bağlanmalıdır.
Besleyici, kucaklayıcı ve koruyucu bir ortam ister.
Duygusal açıklık ve savunmasızlık değerlidir.
''',
          'tantricPractices': [
            'Kalp çakra odaklı pratikler',
            'Su elementi meditasyonu',
            'Ay döngüsü ritüelleri',
            'Duygusal şifa çalışması',
          ],
          'partnerTips': [
            'Duygusal güvenlik sağla',
            'Savunmasızlığını onurlandır',
            'Yuva atmosferi oluştur',
            'Bakım ve ilgi göster',
          ],
        },
        'leo': {
          'sign': 'Aslan',
          'element': 'Ateş',
          'venusExpression': 'Dramatik, cömert, merkez olmak isteyen',
          'tantricQualities': [
            'Görkemli ve teatral ifade',
            'Cömert ve verici enerji',
            'Takdir ve hayranlık ihtiyacı',
            'Yaratıcı ve eğlenceli',
            'Kalp merkezli liderlik',
          ],
          'sacredSexualityStyle': '''
Aslan Venüsü, ışıldamak ve ışıldatmak ister. Cömert bir aşıktır
ama karşılığında takdir bekler. Romantizm ve özel hissetmek önemlidir.
Yaratıcı ve oyuncu bir enerji taşır.
''',
          'tantricPractices': [
            'Kalp çakra güçlendirme',
            'Yaratıcı ritüeller',
            'Güneş meditasyonu',
            'Onurlandırma pratikleri',
          ],
          'partnerTips': [
            'Bol takdir ve övgü ver',
            'Romantik atmosfer oluştur',
            'Cömertliğini karşılıksız bırakma',
            'Özel hissettir',
          ],
        },
        'virgo': {
          'sign': 'Başak',
          'element': 'Toprak',
          'venusExpression': 'Hizmet odaklı, detaycı, mütevazı',
          'tantricQualities': [
            'Detaylara dikkat',
            'Hizmet yoluyla sevgi',
            'Arınma ve mükemmellik',
            'Pratik ve somut ifade',
            'Sağlık ve beden farkındalığı',
          ],
          'sacredSexualityStyle': '''
Başak Venüsü, hizmet ederek sever. Detaycı ve özenlidir.
Temizlik ve düzen önemlidir. Bedensel farkındalık yüksektir.
Mükemmeliyetçilik bazen engel olabilir.
''',
          'tantricPractices': [
            'Beden tarama meditasyonu',
            'Arınma ritüelleri',
            'Detaylı tantrik masaj',
            'Sağlık odaklı pratikler',
          ],
          'partnerTips': [
            'Temiz ve düzenli ortam sağla',
            'Hizmetini takdir et',
            'Bedenine dikkat göster',
            'Mükemmeliyetçiliği yumuşat',
          ],
        },
        'libra': {
          'sign': 'Terazi',
          'element': 'Hava',
          'venusExpression': 'Uyumlu, estetik, partner odaklı',
          'tantricQualities': [
            'İlişki ve ortaklık odağı',
            'Güzellik ve estetik duyarlılık',
            'Denge ve uyum arayışı',
            'Diplomasi ve incelik',
            'Romantizm ve zarfet',
          ],
          'sacredSexualityStyle': '''
Terazi Venüsü, uyum ve güzellik arar. Estetik ortam, zarif
yaklaşım önemlidir. Karşılıklılık ve eşitlik değerlidir.
Kaba veya dengesiz enerjiden rahatsız olur.
''',
          'tantricPractices': [
            'Partner dengeleme pratikleri',
            'Estetik ritüeller',
            'Yin-Yang meditasyonu',
            'Uyum odaklı nefes çalışması',
          ],
          'partnerTips': [
            'Estetik detaylara özen göster',
            'Dengeli ver-al ilişkisi kur',
            'Zariflik ve incelik göster',
            'Uyumu koru',
          ],
        },
        'scorpio': {
          'sign': 'Akrep',
          'element': 'Su',
          'venusExpression': 'Yoğun, dönüştürücü, derin',
          'tantricQualities': [
            'Yoğun ve derin tutku',
            'Dönüşüm ve yeniden doğuş',
            'Gizem ve keşfetme isteği',
            'Güç ve kontrol dinamikleri',
            'Ölüm-yeniden doğuş döngüsü',
          ],
          'sacredSexualityStyle': '''
Akrep Venüsü, yüzeyselliğe tahammül edemez. Derinlik, yoğunluk
ve dönüşüm arar. Gölge ile çalışmaktan korkmaz.
Kutsal birlik, ego ölümü deneyimi olabilir.
''',
          'tantricPractices': [
            'Derin Kundalini çalışması',
            'Gölge entegrasyonu',
            'Dönüşüm meditasyonları',
            'Ego ölümü pratikleri',
          ],
          'partnerTips': [
            'Yüzeysel kalma',
            'Gölge ile çalışmaya hazır ol',
            'Yoğunluğu kaldır',
            'Güven ve sadakat göster',
          ],
        },
        'sagittarius': {
          'sign': 'Yay',
          'element': 'Ateş',
          'venusExpression': 'Maceraperest, özgür, felsefi',
          'tantricQualities': [
            'Özgürlük ve macera isteği',
            'Felsefi ve spiritüel arayış',
            'Neşeli ve optimist enerji',
            'Keşif ve genişleme',
            'Yabancı kültürlere ilgi',
          ],
          'sacredSexualityStyle': '''
Yay Venüsü, birliği spiritüel bir arayış olarak görür.
Özgürlük önemlidir, bağımlılıktan kaçınır. Macera, keşif
ve felsefi derinlik arar. Neşeli ve açık bir enerji taşır.
''',
          'tantricPractices': [
            'Felsefi tantra çalışması',
            'Genişleme meditasyonları',
            'Farklı gelenek keşfi',
            'Açık hava ritüelleri',
          ],
          'partnerTips': [
            'Özgürlük alanı ver',
            'Spiritüel derinlik sun',
            'Macera ve yenilik ekle',
            'Felsefi sohbetler kur',
          ],
        },
        'capricorn': {
          'sign': 'Oğlak',
          'element': 'Toprak',
          'venusExpression': 'Kararlı, geleneksel, uzun vadeli',
          'tantricQualities': [
            'Disiplin ve kararlılık',
            'Uzun vadeli bağlılık',
            'Geleneksel değerler',
            'Yapı ve sınırlar',
            'Zamana yayılan derinlik',
          ],
          'sacredSexualityStyle': '''
Oğlak Venüsü, hemen açılmaz. Güven yavaşça inşa edilir.
Disiplinli ve kararlı bir aşıktır. Geleneksel yapılara
saygı duyar. Uzun vadeli, derin bağlılık arar.
''',
          'tantricPractices': [
            'Disiplinli pratik rutini',
            'Uzun vadeli tantrik yolculuk',
            'Yapılandırılmış ritüeller',
            'Topraklama meditasyonları',
          ],
          'partnerTips': [
            'Sabırlı ol, acele etme',
            'Güvenilirlik göster',
            'Yapı ve düzen sağla',
            'Uzun vadeli düşün',
          ],
        },
        'aquarius': {
          'sign': 'Kova',
          'element': 'Hava',
          'venusExpression': 'Özgün, deneysel, insancıl',
          'tantricQualities': [
            'Özgünlük ve bireysellik',
            'Deneysel yaklaşım',
            'Arkadaşlık temelli aşk',
            'İnsanlığa hizmet',
            'Geleneksel olmayan yollar',
          ],
          'sacredSexualityStyle': '''
Kova Venüsü, kalıpları kırar. Geleneksel olmayan, deneysel
yaklaşımlar sever. Önce arkadaş, sonra aşıktır.
Bireysellik ve özgürlük korunmalıdır.
''',
          'tantricPractices': [
            'Deneysel tantra teknikleri',
            'Grup enerji çalışmaları',
            'Bilimsel-spiritüel yaklaşım',
            'Yenilikçi pratikler',
          ],
          'partnerTips': [
            'Bireyselliğine saygı göster',
            'Yeni şeyler denemeye açık ol',
            'Arkadaşlık temelini koru',
            'Geleneksele zorlamak',
          ],
        },
        'pisces': {
          'sign': 'Balık',
          'element': 'Su',
          'venusExpression': 'Romantik, empatik, sınırsız',
          'tantricQualities': [
            'Sınırsız, okyanus gibi sevgi',
            'Derin empati ve birleşme',
            'Spiritüel ve mistik bağlantı',
            'Hayal gücü ve fantezi',
            'Fedakarlık ve teslimiyet',
          ],
          'sacredSexualityStyle': '''
Balık Venüsü, birlikte kaybolmak ister. Sınırlar belirsizleşir,
ruhlar birleşir. Mistik, rüya gibi bir deneyim arar.
Teslimiyet ve kaynaşma doğaldır.
''',
          'tantricPractices': [
            'Su elementi meditasyonu',
            'Mistik birleşme pratikleri',
            'Rüya çalışması',
            'Teslimiyet meditasyonu',
          ],
          'partnerTips': [
            'Mistik derinliğe açık ol',
            'Hayal gücünü onurlandır',
            'Sınırları nazikçe koru',
            'Spiritüel bağlantıyı besle',
          ],
        },
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // MARS CİNSELLİĞİ - BURÇLARA GÖRE
    // ─────────────────────────────────────────────────────────────────────────
    'marsSexuality': {
      'overview': '''
Mars, cinsel dürtü, tutku ve enerji gezegenidir. Tantrik perspektiften,
Mars Kundalini'nin ateşidir - harekete geçiren, yükselen, dönüştüren
ilkel güç.

Doğum haritasında Mars'ın burcu, kişinin cinsel enerjisini nasıl
ifade ettiğini, neyin ateşlediğini ve tutku dinamiklerini gösterir.
''',
      'byZodiac': {
        'aries': {
          'sign': 'Koç',
          'marsExpression': 'Doğrudan, hızlı, fetihçi',
          'sexualEnergy': '''
Mars Koç'ta evindedir. Doğrudan, güçlü ve anlık ateşlenir.
Fethetme içgüdüsü güçlüdür. Sabırsız olabilir ama tutku
yoğundur. İlk adımı atmaktan çekinmez.
''',
          'kundaliniStyle': 'Hızlı ve patlayıcı yükseliş',
          'tantricChallenge': 'Yavaşlamak ve derinleşmek',
          'practices': ['Ateş nefesi', 'Aktif Kundalini', 'Güç pratikleri'],
        },
        'taurus': {
          'sign': 'Boğa',
          'marsExpression': 'Yavaş, kararlı, duyusal',
          'sexualEnergy': '''
Mars Boğa'da yavaş ama kararlıdır. Acele etmez, enerji biriktirir.
Duyusal zevkler önemlidir. Bir kez ateşlenince uzun süre yanar.
Fiziksel dayanıklılık yüksektir.
''',
          'kundaliniStyle': 'Yavaş, istikrarlı yükseliş',
          'tantricChallenge': 'Esneklik ve değişim',
          'practices': [
            'Yavaş enerji çalışması',
            'Duyusal farkındalık',
            'Topraklama',
          ],
        },
        'gemini': {
          'sign': 'İkizler',
          'marsExpression': 'Zihinsel, çeşitli, oyuncu',
          'sexualEnergy': '''
Mars İkizler'de zihinle başlar. Sözel uyarılma, çeşitlilik ve
oyun önemlidir. Tek bir şeyle sınırlı kalmak istemez.
Merak ve keşif dürtüsü güçlüdür.
''',
          'kundaliniStyle': 'Dalgalı, değişken akış',
          'tantricChallenge': 'Odaklanma ve derinleşme',
          'practices': [
            'Mantra çalışması',
            'Nefes varyasyonları',
            'Zihin-beden bağlantısı',
          ],
        },
        'cancer': {
          'sign': 'Yengeç',
          'marsExpression': 'Duygusal, koruyucu, döngüsel',
          'sexualEnergy': '''
Mars Yengeç'te duygusal güvenlikle bağlantılıdır. Duygusal bağ
olmadan fiziksel enerji akmaz. Ay döngüleriyle etkilenir.
Koruyucu ve besleyici bir tutku taşır.
''',
          'kundaliniStyle': 'Duygusal tetiklemelerle yükselme',
          'tantricChallenge': 'Duygusal savunmasızlık',
          'practices': [
            'Kalp odaklı pratikler',
            'Ay ritüelleri',
            'Duygusal şifa',
          ],
        },
        'leo': {
          'sign': 'Aslan',
          'marsExpression': 'Dramatik, cömert, gösterişli',
          'sexualEnergy': '''
Mars Aslan'da görkemli ve teatraldir. Performans ve takdir önemlidir.
Cömert bir aşıktır ama karşılık bekler. Ego ve tutku iç içedir.
Yaratıcı ve eğlenceli bir enerji taşır.
''',
          'kundaliniStyle': 'Parlak, merkeze yayılan enerji',
          'tantricChallenge': 'Ego dönüşümü',
          'practices': ['Kalp yangını', 'Yaratıcı ifade', 'Güneş meditasyonu'],
        },
        'virgo': {
          'sign': 'Başak',
          'marsExpression': 'Kontrollü, detaycı, hizmet odaklı',
          'sexualEnergy': '''
Mars Başak'ta kontrollü ve tekniktir. Detaylar önemlidir.
Hizmet yoluyla tatmin bulur. Mükemmeliyetçilik bazen
spontanlığı engelleyebilir.
''',
          'kundaliniStyle': 'Metodili, kademeli yükseliş',
          'tantricChallenge': 'Kontrolü bırakmak',
          'practices': [
            'Beden farkındalığı',
            'Arınma teknikleri',
            'Detaylı pratikler',
          ],
        },
        'libra': {
          'sign': 'Terazi',
          'marsExpression': 'Diplomatik, dengeli, partner odaklı',
          'sexualEnergy': '''
Mars Terazi'de partner odaklıdır. Karşılıklılık ve uyum önemlidir.
Çatışmadan kaçınır, zarfet arar. Bazen kendi isteklerini
bastırabilir.
''',
          'kundaliniStyle': 'Dengeli, partnere yansıyan akış',
          'tantricChallenge': 'Kendi arzularını onurlandırmak',
          'practices': [
            'Partner dengesi',
            'Yin-Yang çalışması',
            'Uyum pratikleri',
          ],
        },
        'scorpio': {
          'sign': 'Akrep',
          'marsExpression': 'Yoğun, dönüştürücü, güçlü',
          'sexualEnergy': '''
Mars Akrep'te ikinci evindedir. Yoğun, derin ve dönüştürücüdür.
Yüzeyselliğe tahammülü yoktur. Birlik, ego ölümü ve yeniden
doğuş deneyimi olabilir. Gizem ve derinlik arar.
''',
          'kundaliniStyle': 'Yoğun, dönüştürücü yükseliş',
          'tantricChallenge': 'Kontrol bırakma ve teslimiyet',
          'practices': [
            'Derin dönüşüm',
            'Gölge çalışması',
            'Ölüm-yeniden doğuş',
          ],
        },
        'sagittarius': {
          'sign': 'Yay',
          'marsExpression': 'Maceraperest, özgür, ateşli',
          'sexualEnergy': '''
Mars Yay'da maceraperesttir. Özgürlük ve keşif önemlidir.
Felsefi derinlik arar. Neşeli ve optimist bir tutku taşır.
Bağımlılık ve rutinden kaçınır.
''',
          'kundaliniStyle': 'Genişleyen, yükselen akış',
          'tantricChallenge': 'Odaklanma ve bağlılık',
          'practices': [
            'Genişleme meditasyonu',
            'Felsefi tantra',
            'Macera pratikleri',
          ],
        },
        'capricorn': {
          'sign': 'Oğlak',
          'marsExpression': 'Disiplinli, kararlı, dayanıklı',
          'sexualEnergy': '''
Mars Oğlak'ta yüceltilmiş konumdadır. Disiplinli, kararlı ve
dayanıklıdır. Enerji uzun süre kontrol edilebilir.
Hedef odaklı, stratejik bir tutku taşır.
''',
          'kundaliniStyle': 'Kontrollü, tırmanan yükseliş',
          'tantricChallenge': 'Spontanlık ve akış',
          'practices': [
            'Enerji muhafazası',
            'Disiplin pratiği',
            'Dağ meditasyonu',
          ],
        },
        'aquarius': {
          'sign': 'Kova',
          'marsExpression': 'Deneysel, özgün, ayrılıkçı',
          'sexualEnergy': '''
Mars Kova'da geleneksel değildir. Deneysel, özgün yaklaşımlar sever.
Bazen entelektüel mesafe koyar. Bireysellik ve özgürlük korunmalıdır.
Yenilikçi ve alışılmadık pratikler çeker.
''',
          'kundaliniStyle': 'Elektriksel, düzensiz akış',
          'tantricChallenge': 'Duygusal bağlantı',
          'practices': [
            'Yenilikçi teknikler',
            'Elektrik meditasyonu',
            'Özgün pratikler',
          ],
        },
        'pisces': {
          'sign': 'Balık',
          'marsExpression': 'Akışkan, teslim, sınırsız',
          'sexualEnergy': '''
Mars Balık'ta akışkan ve sınırsızdır. Net sınırlar çizmek zordur.
Teslimiyet ve kaynaşma doğaldır. Spiritüel ve mistik bir
tutku taşır. Bazen edilgen olabilir.
''',
          'kundaliniStyle': 'Dalga gibi, akışkan yükseliş',
          'tantricChallenge': 'Topraklama ve sınırlar',
          'practices': [
            'Su meditasyonu',
            'Teslimiyet pratiği',
            'Mistik birleşme',
          ],
        },
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // 8. EV TANTRİK SIRLARI
    // ─────────────────────────────────────────────────────────────────────────
    'eighthHouseSecrets': {
      'overview': '''
8. Ev, astrolojide dönüşüm, ölüm-yeniden doğuş, cinsellik, gizli konular
ve ortak kaynaklar evidir. Tantrik perspektiften, bu ev en derin
dönüşümün ve kutsal birliğin alanıdır.

8. Ev, Kundalini uyanışının, ego ölümünün ve ruhsal birleşmenin
astrolojik karşılığıdır. Bu evdeki gezegenler ve burçlar, kişinin
dönüşüm ve derin birlik deneyimlerini gösterir.
''',
      'signInterpretations': {
        'aries': {
          'sign': 'Koç',
          'interpretation': '''
8. Ev Koç'ta: Dönüşüm ani ve patlayıcı olur. Cesaretle gölgeye dalınır.
Tantrik pratiklerde liderlik alınır. Ego ölümü savaşçı bir süreçtir.
''',
          'tantricPath': 'Cesaret yoluyla dönüşüm',
          'kundaliniStyle': 'Ani, güçlü uyanışlar',
        },
        'taurus': {
          'sign': 'Boğa',
          'interpretation': '''
8. Ev Boğa'da: Dönüşüm yavaş ve duyusal deneyim yoluyla olur.
Maddi ve fiziksel bağların bırakılması zorlayıcıdır.
Bedensel dönüşüm derin ve kalıcıdır.
''',
          'tantricPath': 'Duyusal farkındalık yoluyla dönüşüm',
          'kundaliniStyle': 'Yavaş, topraklanmış yükseliş',
        },
        'gemini': {
          'sign': 'İkizler',
          'interpretation': '''
8. Ev İkizler'de: Dönüşüm zihinsel keşif yoluyla olur.
Gizli bilgilere ilgi vardır. İletişim yoluyla şifa mümkündür.
Düşünce kalıplarının dönüşümü önemlidir.
''',
          'tantricPath': 'Bilgi ve mantra yoluyla dönüşüm',
          'kundaliniStyle': 'Zihinsel aktivasyonla tetiklenen',
        },
        'cancer': {
          'sign': 'Yengeç',
          'interpretation': '''
8. Ev Yengeç'te: Dönüşüm duygusal derinlik yoluyla olur.
Aile ve geçmişle ilgili gizli konular önemlidir.
Duygusal güvenlik içinde dönüşüm mümkündür.
''',
          'tantricPath': 'Duygusal şifa yoluyla dönüşüm',
          'kundaliniStyle': 'Duygusal tetiklemelerle',
        },
        'leo': {
          'sign': 'Aslan',
          'interpretation': '''
8. Ev Aslan'da: Dönüşüm yaratıcı ifade ve ego dönüşümü yoluyla olur.
Güç ve kontrol konuları önemlidir. Kalp merkezli dönüşüm güçlüdür.
''',
          'tantricPath': 'Yaratıcılık ve kalp yoluyla dönüşüm',
          'kundaliniStyle': 'Kalp yangını ile yükselme',
        },
        'virgo': {
          'sign': 'Başak',
          'interpretation': '''
8. Ev Başak'ta: Dönüşüm analiz ve arınma yoluyla olur.
Sağlık krizleri dönüştürücü olabilir. Detaylı iç çalışma gerekir.
''',
          'tantricPath': 'Arınma ve hizmet yoluyla dönüşüm',
          'kundaliniStyle': 'Metodlu, detaylı yükseliş',
        },
        'libra': {
          'sign': 'Terazi',
          'interpretation': '''
8. Ev Terazi'de: Dönüşüm ilişkiler yoluyla olur.
Partner dinamikleri derin dönüşüm getirir.
İlişkisel gölge çalışması önemlidir.
''',
          'tantricPath': 'İlişki yoluyla dönüşüm',
          'kundaliniStyle': 'Partner enerji paylaşımıyla',
        },
        'scorpio': {
          'sign': 'Akrep',
          'interpretation': '''
8. Ev Akrep'te: En güçlü dönüşüm konumu. Derin, yoğun ve
kaçınılmaz dönüşümler. Ölüm-yeniden doğuş deneyimleri güçlü.
Tantrik potansiyel en yüksek.
''',
          'tantricPath': 'Yoğunluk ve derinlik yoluyla dönüşüm',
          'kundaliniStyle': 'Derin, dönüştürücü uyanış',
        },
        'sagittarius': {
          'sign': 'Yay',
          'interpretation': '''
8. Ev Yay'da: Dönüşüm felsefi ve spiritüel arayış yoluyla olur.
İnanç sistemlerinin dönüşümü önemlidir. Yabancı öğretiler çeker.
''',
          'tantricPath': 'Bilgelik ve inanç yoluyla dönüşüm',
          'kundaliniStyle': 'Spiritüel arayışla tetiklenen',
        },
        'capricorn': {
          'sign': 'Oğlak',
          'interpretation': '''
8. Ev Oğlak'ta: Dönüşüm yapıların yıkılması ve yeniden inşası yoluyla
olur. Otorite ve kontrol konuları derin. Disiplinli dönüşüm yolu.
''',
          'tantricPath': 'Disiplin ve yapı yoluyla dönüşüm',
          'kundaliniStyle': 'Kontrollü, kademeli yükseliş',
        },
        'aquarius': {
          'sign': 'Kova',
          'interpretation': '''
8. Ev Kova'da: Dönüşüm radikal ve beklenmedik olur.
Kolektif bilinç ve insanlık konuları derin. Teknoloji veya
bilim yoluyla dönüşüm mümkün.
''',
          'tantricPath': 'Yenilik ve özgürlük yoluyla dönüşüm',
          'kundaliniStyle': 'Ani, elektriksel uyanış',
        },
        'pisces': {
          'sign': 'Balık',
          'interpretation': '''
8. Ev Balık'ta: Dönüşüm çözülme ve teslimiyet yoluyla olur.
Mistik deneyimler ve sınırların erimesi. Spiritüel birleşme derin.
''',
          'tantricPath': 'Teslimiyet ve mistisizm yoluyla dönüşüm',
          'kundaliniStyle': 'Mistik, sınırsız uyanış',
        },
      },
      'planetaryInfluences': {
        'sun': 'Kimlik dönüşümü, ego ölümü deneyimleri',
        'moon': 'Duygusal dönüşüm, bilinçaltı şifa',
        'mercury': 'Düşünce dönüşümü, gizli bilgiye erişim',
        'venus': 'İlişki yoluyla dönüşüm, değerler dönüşümü',
        'mars': 'Cinsel enerji yoluyla dönüşüm, güç dinamikleri',
        'jupiter': 'Spiritüel genişleme, inanç dönüşümü',
        'saturn': 'Karma temizliği, yapısal dönüşüm',
        'uranus': 'Ani uyanışlar, radikal dönüşüm',
        'neptune': 'Mistik birleşme, sınırların çözülmesi',
        'pluto': 'En derin dönüşüm, ölüm-yeniden doğuş',
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // TANTRİK UYUMLULUK
    // ─────────────────────────────────────────────────────────────────────────
    'tantricCompatibility': {
      'overview': '''
Tantrik uyumluluk, iki partnerin enerji dinamiklerinin nasıl etkileştiğini
gösterir. Astrolojik uyumluluk (sinastri), tantrik birliğin potansiyelini
ve zorluklarını ortaya koyar.

Mükemmel uyumluluk gerekmez - aslında zorlayıcı açılar bile derin
dönüşüm ve büyüme için fırsat sunar. Önemli olan, bu dinamikleri
anlamak ve bilinçli çalışmaktır.
''',
      'keyAspects': {
        'venusVenus': {
          'aspect': 'Venüs-Venüs',
          'meaning': 'Sevme ve sevilme tarzlarının uyumu',
          'harmonious': 'Doğal uyum, karşılıklı memnuniyet',
          'challenging': 'Farklı aşk dilleri, öğrenme fırsatı',
        },
        'marsMars': {
          'aspect': 'Mars-Mars',
          'meaning': 'Cinsel enerji ve tutku dinamikleri',
          'harmonious': 'Enerji akışı, karşılıklı ateşleme',
          'challenging': 'Rekabet veya çatışma, güç mücadelesi',
        },
        'venusMarsCross': {
          'aspect': 'Venüs-Mars (çapraz)',
          'meaning': 'Çekim ve tutku dinamiği',
          'significance': '''
Bir partnerin Venüs'ü diğerinin Mars'ına aspekt yaptığında,
güçlü çekim ve cinsel enerji oluşur. Bu, tantrik birlik için
en önemli göstergelerden biridir.
''',
          'harmonious': 'Doğal çekim, yin-yang dengesi',
          'challenging': 'Yoğun ama zorlayıcı dinamikler',
        },
        'moonMoon': {
          'aspect': 'Ay-Ay',
          'meaning': 'Duygusal uyum ve güvenlik',
          'harmonious': 'Duygusal anlayış, yuva hissi',
          'challenging': 'Duygusal uyumsuzluk, güvensizlik',
        },
        'eighthHouseConnections': {
          'aspect': '8. Ev bağlantıları',
          'meaning': 'Dönüşüm ve derin birlik potansiyeli',
          'significance': '''
Bir partnerin gezegeni diğerinin 8. Evine düştüğünde,
derin dönüşüm ve yoğun birlik deneyimi mümkündür.
Bu, tantrik ilişkiler için güçlü bir göstergedir.
''',
        },
      },
      'elementalCompatibility': {
        'fireWater': {
          'elements': 'Ateş - Su',
          'dynamic': 'Buhar - yoğun ve dönüştürücü',
          'tantricPotential': '''
Zıtların birliği güçlü dönüşüm getirir. Ateşin tutkusu ve
suyun derinliği birleştiğinde, yoğun tantrik deneyimler mümkündür.
''',
          'challenges': 'Söndürme veya buharlaşma riski',
          'practices': ['Dengeleme nefesleri', 'Element meditasyonu'],
        },
        'earthAir': {
          'elements': 'Toprak - Hava',
          'dynamic': 'Tozlanma - üretken birlik',
          'tantricPotential': '''
Toprağın somutluğu ve havanın hafifliği birleştiğinde,
hem topraklanmış hem de genişlemiş pratikler mümkündür.
''',
          'challenges': 'Ağırlık ve hafiflik dengesi',
          'practices': ['Topraklama ve genişleme', 'Nefes-beden bütünlüğü'],
        },
        'fireFire': {
          'elements': 'Ateş - Ateş',
          'dynamic': 'Alev - yoğun ve tutkulu',
          'tantricPotential': '''
Çifte ateş çok yoğun bir enerji yaratır. Kundalini hızla
aktive olabilir. Pratikler güçlü ve transformatiftir.
''',
          'challenges': 'Tükenme veya rekabet riski',
          'practices': ['Enerji yönetimi', 'Soğutma teknikleri'],
        },
        'waterWater': {
          'elements': 'Su - Su',
          'dynamic': 'Okyanus - derin ve sınırsız',
          'tantricPotential': '''
Çifte su çok derin duygusal birlik sağlar. Sınırlar kolayca
erir, mistik birleşme doğaldır.
''',
          'challenges': 'Boğulma veya kaybolma riski',
          'practices': ['Sınır farkındalığı', 'Topraklama'],
        },
        'earthEarth': {
          'elements': 'Toprak - Toprak',
          'dynamic': 'Dağ - sağlam ve kalıcı',
          'tantricPotential': '''
Çifte toprak derin topraklanma ve uzun süreli pratik sağlar.
Duyusal deneyimler yoğundur. Sabır ve dayanıklılık vardır.
''',
          'challenges': 'Durağanlık veya rutine düşme riski',
          'practices': ['Yenilik ekleme', 'Ateş elementi pratikleri'],
        },
        'airAir': {
          'elements': 'Hava - Hava',
          'dynamic': 'Rüzgar - hafif ve değişken',
          'tantricPotential': '''
Çifte hava zihinsel bağlantı ve iletişim sağlar.
Mantra ve nefes pratikleri güçlüdür. Çeşitlilik ve
yenilik kolaylaşır.
''',
          'challenges': 'Topraklanma zorluğu',
          'practices': ['Beden farkındalığı', 'Topraklama teknikleri'],
        },
      },
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // BÖLÜM 6: ENERJİ BEDEN SİSTEMİ
  // Aura Katmanları, Pranik Beden, Eterik ve Nedensel Bedenler
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, dynamic> energyBodySystem = {
    // ─────────────────────────────────────────────────────────────────────────
    // GENEL BAKIŞ
    // ─────────────────────────────────────────────────────────────────────────
    'overview': {
      'title': 'İnce Bedenler - Kosha Sistemi',
      'description': '''
Tantrik ve Yogik geleneklerde, insan varlığı sadece fiziksel bedenden
ibaret değildir. Birden fazla "ince beden" veya "kılıf" (kosha) katmanı
vardır. Bu katmanlar, fiziksel bedeni çevreler ve birbirine nüfuz eder.

Beş Kosha modeli, en yaygın sistemdir:
1. Annamaya Kosha - Fiziksel Beden (yiyecekten oluşan)
2. Pranamaya Kosha - Enerji/Prana Bedeni
3. Manomaya Kosha - Zihinsel Beden
4. Vijnanamaya Kosha - Bilgelik/Sezgi Bedeni
5. Anandamaya Kosha - Mutluluk Bedeni

Bu sistemin ötesinde, Batı ezoterik geleneğinden etkilenen daha
detaylı aura katmanı modelleri de vardır. Tantrik pratik, tüm
bu katmanları arındırır, dengeler ve birleştirir.
''',
      'importance': '''
Enerji bedeni farkındalığı, tantrik pratiğin temelidir. Sadece
fiziksel bedende çalışmak yüzeysel kalır. Gerçek dönüşüm, tüm
katmanlarda eşzamanlı olarak gerçekleşir.

Partner pratiklerinde, enerji bedenlerinin etkileşimi, fiziksel
temastan bile daha derin bağlantı sağlar. Auraların karışması,
pranik değişim ve bilinç birleşmesi - bunlar tantrik birliğin
özüdür.
''',
    },

    // ─────────────────────────────────────────────────────────────────────────
    // AURA KATMANLARI
    // ─────────────────────────────────────────────────────────────────────────
    'auraLayers': {
      'overview': '''
Aura, fiziksel bedeni çevreleyen enerji alanıdır. Yedi ana katmandan
oluşur ve her katman, farklı bir bilinç ve enerji seviyesini temsil eder.
Aura, kişinin fiziksel, duygusal, zihinsel ve spiritüel durumunu yansıtır.
''',
      'layers': [
        {
          'layer': 1,
          'name': 'Eterik Beden',
          'sanskritName': 'Pranamaya Kosha (kısmen)',
          'distance': 'Fiziksel bedenden 2-7 cm',
          'color': 'Mavimsi-gri, açık mavi',
          'description': '''
Eterik beden, fiziksel bedenin enerji şablonudur. Fiziksel formun
bir kopyası gibidir ve fiziksel sağlığı doğrudan yansıtır.
Akupunktur meridyenleri ve çakralar bu katmanda bulunur.
''',
          'functions': [
            'Fiziksel bedenin enerji şablonu',
            'Prana dağıtımı',
            'Fiziksel sağlık yansıması',
            'Duyusal algının temeli',
          ],
          'healthIndicators': {
            'healthy': [
              'Parlak, net mavi renk',
              'Düzgün yoğunluk',
              'Fiziksel beden çevresinde eşit dağılım',
            ],
            'imbalanced': [
              'Soluk veya gri alanlar',
              'Delikler veya boşluklar',
              'Düzensiz kenarlar',
            ],
          },
          'tantricRelevance': '''
Eterik beden, partner pratiklerinde en kolay algılanan katmandır.
İki partnerin eterik bedenleri birbirine yaklaştığında, enerji
akışı başlar. Eller arası ısı veya karıncalanma hissi, eterik
etkileşimin işaretidir.
''',
          'practices': [
            'Prana nefesi (Pranayama)',
            'Eterik beden taraması',
            'Eller arası enerji hissetme',
            'Reiki veya prana şifası',
          ],
        },
        {
          'layer': 2,
          'name': 'Duygusal Beden',
          'sanskritName': 'Manomaya Kosha (duygusal yönü)',
          'distance': 'Fiziksel bedenden 2-7 cm ötesi',
          'color': 'Gökkuşağı renkleri, değişken',
          'description': '''
Duygusal beden, duyguların enerji alanıdır. Sürekli değişen renkler
ve formlar içerir. Her duygu, belirli bir renk ve titreşim olarak
tezahür eder. Bu katman, en değişken ve dinamik olandır.
''',
          'functions': [
            'Duyguların enerji ifadesi',
            'Duygusal hafıza deposu',
            'Kişilerarası duygusal iletişim',
            'Empati ve duygusal algı',
          ],
          'colorMeanings': {
            'kirmizi': 'Öfke, tutku, güç',
            'turuncu': 'Yaratıcılık, cinsellik, heyecan',
            'sari': 'Neşe, zihinsel aktivite, güç',
            'yesil': 'Sevgi, şifa, denge',
            'mavi': 'Huzur, iletişim, hakikat',
            'mor': 'Spiritüellik, sezgi, dönüşüm',
            'pembe': 'Koşulsuz sevgi, şefkat',
            'gri': 'Korku, depresyon, blokaj',
            'siyah': 'Olumsuz enerji, hastalık, gölge',
          },
          'healthIndicators': {
            'healthy': [
              'Canlı, akan renkler',
              'Dengeli renk dağılımı',
              'Duyguların özgürce akması',
            ],
            'imbalanced': [
              'Donuk veya bulanık renkler',
              'Takılı, durağan enerji',
              'Aşırı veya eksik belirli renkler',
            ],
          },
          'tantricRelevance': '''
Duygusal beden, tantrik birlikte en yoğun etkileşime giren katmandır.
Partner pratiklerinde, duygusal bedenler birleşir ve karşılıklı
empati derinleşir. Bastırılmış duygular yüzeye çıkabilir ve şifa
bulabilir.
''',
          'practices': [
            'Duygu farkındalığı meditasyonu',
            'Duygusal salınım çalışması',
            'Katarsis teknikleri',
            'Partner duygusal ayna çalışması',
          ],
        },
        {
          'layer': 3,
          'name': 'Zihinsel Beden',
          'sanskritName': 'Manomaya Kosha (zihinsel yönü)',
          'distance': 'Duygusal bedenden 7-20 cm ötesi',
          'color': 'Sarı, altın tonları',
          'description': '''
Zihinsel beden, düşüncelerin ve inançların enerji alanıdır.
Düşünce formları (thought forms) burada oluşur ve birikir.
Zihinsel kalıplar, inançlar ve fikirler bu katmanda depolanır.
''',
          'functions': [
            'Düşünce üretimi ve işleme',
            'İnanç sistemleri deposu',
            'Zihinsel kalıpların saklanması',
            'Mantık ve analiz',
          ],
          'healthIndicators': {
            'healthy': [
              'Parlak sarı ışıltı',
              'Net ve organize yapı',
              'Aktif ama dengeli',
            ],
            'imbalanced': [
              'Bulanık veya kaotik',
              'Aşırı aktivite veya donukluk',
              'Katı veya dağınık yapı',
            ],
          },
          'tantricRelevance': '''
Zihinsel beden, tantrik pratikte "ego" ile ilişkilidir. Meditasyon
ve pratik yoluyla zihinsel kalıplar gevşer. Partner pratiklerinde,
zihinsel yargılar ve beklentiler bırakılır.
''',
          'practices': [
            'Zihin sessizliği meditasyonu',
            'İnanç sorgulaması',
            'Düşünce gözlemi',
            'Mantra ile zihin arınması',
          ],
        },
        {
          'layer': 4,
          'name': 'Astral Beden',
          'sanskritName': 'Kama-Manas (arzu zihni)',
          'distance': 'Zihinsel bedenden 15-30 cm ötesi',
          'color': 'Gökkuşağı, pembe tonları baskın',
          'description': '''
Astral beden, fiziksel ve spiritüel arasındaki köprüdür.
İlişkiler, bağlantılar ve kordonlar bu katmanda oluşur.
Rüya bedeni ve astral seyahat bu katmanla ilişkilidir.
''',
          'functions': [
            'İlişki bağları ve kordonlar',
            'Astral seyahat',
            'Rüya deneyimleri',
            'Fiziksel-spiritüel köprü',
          ],
          'healthIndicators': {
            'healthy': [
              'Pembe ve parlak',
              'Sağlıklı ilişki bağları',
              'Açık astral algı',
            ],
            'imbalanced': [
              'Soluk veya gri',
              'Sağlıksız bağımlılık kordonları',
              'Astral blokajlar',
            ],
          },
          'tantricRelevance': '''
Astral beden, tantrik birliğin en derin katmanlarından biridir.
Partner pratiklerinde, astral bedenler birleşebilir ve derin
bağlantı kurulur. Enerji kordonları oluşur ve karşılıklı
beslenme başlar.
''',
          'practices': [
            'Astral farkındalık meditasyonu',
            'Bilinçli rüya çalışması',
            'Kordon temizliği',
            'Partner astral bağlantı',
          ],
        },
        {
          'layer': 5,
          'name': 'Eterik Şablon Beden',
          'sanskritName': 'Vijnanamaya Kosha (kısmen)',
          'distance': 'Astral bedenden 45-60 cm ötesi',
          'color': 'Koyu mavi',
          'description': '''
Eterik şablon, fiziksel bedenin ilahi planıdır. Mükemmel sağlık
ve form bilgisini taşır. Şifa çalışmalarında bu katmana erişim
önemlidir, çünkü orijinal şablona dönüşü destekler.
''',
          'functions': [
            'Fiziksel bedenin ilahi şablonu',
            'Mükemmel sağlık bilgisi',
            'Manifestasyon şablonu',
            'İlahi plan erişimi',
          ],
          'healthIndicators': {
            'healthy': [
              'Koyu mavi, net çizgiler',
              'Fiziksel bedenle uyumlu',
              'Güçlü ve belirgin',
            ],
            'imbalanced': [
              'Bulanık veya çarpık çizgiler',
              'Fiziksel bedenle uyumsuz',
              'Zayıf veya silik',
            ],
          },
          'tantricRelevance': '''
Eterik şablon, tantrik şifa çalışmalarında önemlidir.
Partner pratiklerinde, karşılıklı şifa niyeti bu katmanda
çalışır. Mükemmel sağlık ve bütünlük görselleştirmesi
burada gerçekleşir.
''',
          'practices': [
            'Şablon görselleştirmesi',
            'İlahi plan meditasyonu',
            'Şifa niyeti çalışması',
            'Mükemmel form meditasyonu',
          ],
        },
        {
          'layer': 6,
          'name': 'Selestiyal Beden',
          'sanskritName': 'Vijnanamaya/Anandamaya',
          'distance': '60-80 cm',
          'color': 'Sedefli, opalescent ışık',
          'description': '''
Selestiyal beden, spiritüel mutluluk ve ilahi sevginin alanıdır.
Meditasyonda ulaşılan yüksek duygusal deneyimler burada gerçekleşir.
Koşulsuz sevgi ve evrensel birlik bu katmanın doğasıdır.
''',
          'functions': [
            'Spiritüel mutluluk',
            'İlahi sevgi deneyimi',
            'Evrensel birlik hissi',
            'Yüksek duygusal algı',
          ],
          'healthIndicators': {
            'healthy': [
              'Parlak, sedefli ışık',
              'Huzur ve mutluluk hissi',
              'Evrensel sevgi akışı',
            ],
            'imbalanced': [
              'Soluk veya erişilemez',
              'Spiritüel kopukluk',
              'İlahi bağlantı eksikliği',
            ],
          },
          'tantricRelevance': '''
Selestiyal beden, tantrik birliğin mutluluk boyutudur.
Partner pratiklerinde, karşılıklı ilahi sevgi deneyimi
bu katmanda gerçekleşir. Samadhi benzeri durumlar burada
paylaşılır.
''',
          'practices': [
            'Bhakti (adanmışlık) meditasyonu',
            'Koşulsuz sevgi meditasyonu',
            'İlahi birlik görselleştirmesi',
            'Partner mutluluk paylaşımı',
          ],
        },
        {
          'layer': 7,
          'name': 'Ketherik/Nedensel Beden',
          'sanskritName': 'Anandamaya Kosha / Karana Sharira',
          'distance': '75-100+ cm',
          'color': 'Altın ışık, tüm renkler',
          'description': '''
Nedensel beden, en dış ve en yüksek katmandır. Bireysel ruhun
evrensel ruhla bağlantı noktasıdır. Tüm yaşamların ve deneyimlerin
özü burada saklanır. Aydınlanma bu katmanın tam açılmasıdır.
''',
          'functions': [
            'Evrensel bilinç bağlantısı',
            'Ruh özü',
            'Tüm yaşamların kaydı',
            'Aydınlanma potansiyeli',
          ],
          'healthIndicators': {
            'healthy': [
              'Parlak altın ışık',
              'Güçlü koruyucu alan',
              'Evrensel bağlantı hissi',
            ],
            'imbalanced': [
              'Zayıf veya delikli',
              'Spiritüel koruma eksikliği',
              'Evrensel kopukluk',
            ],
          },
          'tantricRelevance': '''
Nedensel beden, tantrik birliğin en yüce amacıdır.
Partner pratiklerinde, her iki partnerin nedensel bedenleri
birleştiğinde, kozmik birlik deneyimlenir. Shiva-Shakti
birleşmesi bu katmanda tamamlanır.
''',
          'practices': [
            'Evrensel bilinç meditasyonu',
            'Altın ışık görselleştirmesi',
            'Ruh özü bağlantısı',
            'Partner kozmik birlik',
          ],
        },
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // PRANİK BEDEN
    // ─────────────────────────────────────────────────────────────────────────
    'pranicBody': {
      'overview': '''
Pranik beden, yaşam enerjisinin (prana) taşındığı ve dağıtıldığı
sistemdir. Nadiler (enerji kanalları), çakralar (enerji merkezleri)
ve prana vayular (enerji rüzgarları) bu sistemin parçalarıdır.

Tantrik pratiğin büyük bölümü, pranik bedende çalışır. Pranayama,
mudra, bandha ve asana pratikleri, pranik sistemi arındırır,
dengeler ve güçlendirir.
''',
      'pranaVayus': {
        'overview': '''
Prana, beş ana "vayu" (rüzgar) olarak hareket eder. Her vayu,
bedenin farklı bölgelerinde ve farklı işlevlerde aktiftir.
Bu vayuların dengesi, sağlık ve spiritüel ilerleme için kritiktir.
''',
        'vayus': [
          {
            'name': 'Prana Vayu',
            'location': 'Kalp bölgesi, göğüs',
            'direction': 'İçe ve yukarı',
            'functions': [
              'Nefes alma',
              'Enerji alımı',
              'Hayati fonksiyonlar',
              'Bilinç ve uyanıklık',
            ],
            'imbalance': 'Nefes sorunları, endişe, enerji eksikliği',
            'balancingPractices': [
              'Derin diyafragma nefesi',
              'Pranayama (özellikle nefes alma vurgusu)',
              'Kalp açıcı asanalar',
            ],
          },
          {
            'name': 'Apana Vayu',
            'location': 'Pelvis, alt karın',
            'direction': 'Aşağı ve dışa',
            'functions': [
              'Atım (dışkılama, idrar)',
              'Üreme fonksiyonları',
              'Doğum',
              'Topraklama',
            ],
            'imbalance':
                'Sindirim sorunları, üreme sorunları, topraklanma zorluğu',
            'balancingPractices': [
              'Mula bandha',
              'Apanasana',
              'Topraklama meditasyonu',
            ],
          },
          {
            'name': 'Samana Vayu',
            'location': 'Göbek bölgesi, solar pleksus',
            'direction': 'İçe, spiraling',
            'functions': [
              'Sindirim (fiziksel ve zihinsel)',
              'Asimilasyon',
              'Metabolizma',
              'Dengeleme',
            ],
            'imbalance':
                'Sindirim sorunları, metabolizma bozuklukları, karar verememe',
            'balancingPractices': ['Agni sara', 'Nauli', 'Ateş nefesi'],
          },
          {
            'name': 'Udana Vayu',
            'location': 'Boğaz, kafa',
            'direction': 'Yukarı',
            'functions': [
              'Konuşma ve ses',
              'İfade',
              'Büyüme',
              'Bilinç yükselişi',
            ],
            'imbalance': 'Ses sorunları, ifade güçlüğü, tiroit sorunları',
            'balancingPractices': [
              'Jalandhara bandha',
              'Ujjayi nefesi',
              'Mantra pratiği',
            ],
          },
          {
            'name': 'Vyana Vayu',
            'location': 'Tüm beden',
            'direction': 'Dışa, perifere',
            'functions': [
              'Dolaşım',
              'Koordinasyon',
              'Enerji dağıtımı',
              'Bütünleşme',
            ],
            'imbalance':
                'Dolaşım sorunları, koordinasyon eksikliği, bağlantı kopukluğu',
            'balancingPractices': [
              'Hatha yoga genel pratiği',
              'Nadi shodhana',
              'Tam beden farkındalığı',
            ],
          },
        ],
      },
      'pranicHealing': {
        'principles': [
          'Prana, niyet ile yönlendirilir',
          'Enerji, dikkat nereye giderse oraya akar',
          'Bloklar, farkındalık ve nefesle çözülür',
          'Verici ve alıcı denge önemlidir',
        ],
        'selfHealing': {
          'steps': [
            'Rahat bir pozisyonda otur veya uzan.',
            'Nefesini derinleştir ve farkındalığını içe çevir.',
            'Şifa gereken bölgeyi belirle.',
            'Nefes alırken o bölgeye prana gönder.',
            'Nefes verirken blokajların çözüldüğünü hayal et.',
            'Altın veya beyaz ışık görselleştirmesi ekle.',
            '10-20 dakika bu çalışmayı sürdür.',
            'Şükranla tamamla.',
          ],
        },
        'partnerHealing': {
          'steps': [
            'Karşılıklı niyet belirleyin.',
            'Şifa veren, ellerini ısıtsın ve enerji hissetsin.',
            'Alıcı, rahat bir pozisyonda uzansın.',
            'Şifa veren, ellerini bedenin birkaç cm üstünde tutsun.',
            'Enerji akışını hissedin ve yönlendirin.',
            'Blokaj bölgelerinde daha uzun kalın.',
            '20-30 dakika pratik yapın.',
            'Roller değiştirilebilir.',
            'Şükranla kapatın.',
          ],
        },
      },
    },

    // ─────────────────────────────────────────────────────────────────────────
    // DUYGUSAL BEDEN ÇALIŞMASI
    // ─────────────────────────────────────────────────────────────────────────
    'emotionalBodyWork': {
      'overview': '''
Duygusal beden, geçmiş deneyimlerin, travmaların ve bastırılmış
duyguların izlerini taşır. Bu izler, enerji blokajları olarak
kalır ve fiziksel, zihinsel ve spiritüel sağlığı etkiler.

Tantrik pratik, duygusal bedenin arınmasını ve şifasını içerir.
Bu, hem bireysel hem de partner çalışması yoluyla gerçekleşir.
''',
      'emotionalBlocks': {
        'causes': [
          'Bastırılmış duygular',
          'Çözülmemiş travmalar',
          'Tamamlanmamış keder',
          'Affetmeme',
          'Korku ve endişe birikimi',
          'İlişkisel yaralar',
        ],
        'effects': [
          'Fiziksel gerginlik ve ağrı',
          'Enerji akışı tıkanması',
          'İlişki zorlukları',
          'Spiritüel ilerleme engeli',
          'Tekrarlayan kalıplar',
        ],
        'locations': {
          'throat': 'İfade edilmemiş duygular',
          'heart': 'Kalp kırıklığı, keder',
          'solarPlexus': 'Korku, güç kaybı',
          'sacral': 'Cinsel travma, utanç',
          'root': 'Güvenlik travmaları, hayatta kalma korkuları',
        },
      },
      'healingPractices': [
        {
          'name': 'Duygu Farkındalığı Meditasyonu',
          'description': 'Duyguları yargılamadan gözlemleme',
          'steps': [
            'Rahat bir pozisyonda otur.',
            'Gözlerini kapat ve nefesini izle.',
            'Şu anki duygunu fark et.',
            'Onu isimlendirme - sadece hisset.',
            'Bedende nerede olduğunu bul.',
            'O bölgeye nefes gönder.',
            'Duygunun doğal seyrini izle.',
            'Yargılamadan, değiştirmeye çalışmadan.',
            '15-20 dakika bu farkındalıkta kal.',
          ],
        },
        {
          'name': 'Duygusal Salınım',
          'description':
              'Bastırılmış duyguları hareket yoluyla serbest bırakma',
          'steps': [
            'Güvenli ve özel bir alan oluştur.',
            'Bedenini serbest hareketle gevşet.',
            'Duygulara fiziksel ifade ver.',
            'Ses çıkarmana izin ver.',
            'Ağlama, gülme, bağırma - ne gelirse.',
            'Bedeni takip et, zorla.',
            '10-30 dakika bu salınımda kal.',
            'Savasana ile tamamla.',
          ],
        },
        {
          'name': 'Partner Duygusal Ayna',
          'description': 'Partnerle karşılıklı duygusal şifa',
          'steps': [
            'Karşı karşıya oturun.',
            'Göz temasında kalın.',
            'Sırayla, birer dakika içinizdeki duyguyu ifade edin.',
            'Dinleyen sadece tanıklık eder, yorum yapmaz.',
            'Her paylaşımdan sonra sessizlik.',
            'Birbirinize ayna olun.',
            '20-30 dakika bu paylaşımda kalın.',
            'Kucaklaşma ile kapatın.',
          ],
        },
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // ZİHİNSEL BEDEN ARINMASI
    // ─────────────────────────────────────────────────────────────────────────
    'mentalBodyPurification': {
      'overview': '''
Zihinsel beden, düşünce kalıpları, inançlar ve zihinsel alışkanlıklarla
doludur. Bunların çoğu, farkında olmadan edinilmiş ve artık işlevsel
olmayabilir. Tantrik pratik, zihinsel bedeni arındırır ve dönüştürür.
''',
      'mentalPatterns': {
        'limitingBeliefs': [
          'Değersizlik inancı',
          'Yeterli olmama',
          'Hak etmeme',
          'Güvensizlik',
          'Sevilemez olma',
        ],
        'thoughtPatterns': [
          'Aşırı düşünme',
          'Endişe döngüleri',
          'Yargılama',
          'Karşılaştırma',
          'Geçmişe takılma',
          'Geleceğe odaklanma',
        ],
      },
      'purificationPractices': [
        {
          'name': 'Zihin Sessizliği (Mauna Manasa)',
          'description': 'İç diyaloğu durdurmak',
          'steps': [
            'Rahat bir meditasyon pozisyonunda otur.',
            'Gözlerini kapat.',
            'Düşüncelerin geçişini gözlemle.',
            'Düşüncelere tutunma, bırak geçsinler.',
            'Düşünceler arasındaki boşluğu fark et.',
            'Bu boşlukta kal.',
            'Boşluk genişledikçe, sessizliğe dal.',
            '20-40 dakika pratik yap.',
          ],
        },
        {
          'name': 'İnanç Sorgulaması',
          'description': 'Sınırlayıcı inançları dönüştürme',
          'steps': [
            'Sınırlayıcı bir inancı belirle.',
            'Bu inancın nereden geldiğini sor.',
            'Bu inanç gerçekten doğru mu, sor.',
            'Bu inancın karşıtını düşün.',
            'Yeni, güçlendirici inanç oluştur.',
            'Yeni inancı afirmasyon olarak tekrarla.',
            'Bedeninde hissederek içselleştir.',
          ],
        },
        {
          'name': 'Mantra Arınması',
          'description': 'Kutsal sesle zihin temizliği',
          'steps': [
            'Arınma niyetli bir mantra seç (ör. OM).',
            'Sessiz bir alanda otur.',
            'Mantrayı sesli tekrarla.',
            'Titreşimin zihnini doldurmasına izin ver.',
            'Düşünceler yerine mantra kalsın.',
            '108 veya daha fazla tekrar.',
            'Sessizlikle tamamla.',
          ],
        },
      ],
    },

    // ─────────────────────────────────────────────────────────────────────────
    // NEDENSEL BEDEN BAĞLANTISI
    // ─────────────────────────────────────────────────────────────────────────
    'causalBodyConnection': {
      'overview': '''
Nedensel beden (Karana Sharira), ruhun en derin özüdür. Tüm yaşamların,
tüm deneyimlerin ve tüm bilgeliğin deposudur. Aydınlanma, nedensel
bedenin tam bilincine varmaktır.

Tantrik pratiğin nihai amacı, nedensel bedenle bilinçli bağlantı
kurmak ve bu bağlantıyı kalıcı kılmaktır.
''',
      'accessingCausalBody': {
        'preparatoryPractices': [
          'Arınma - tüm katmanlarda temizlik',
          'Meditasyon - düzenli ve derin',
          'Adanmışlık - ego teslimiyeti',
          'Hizmet - bencillikten çıkış',
          'Satsang - yüksek titreşimli birliktelik',
        ],
        'directAccess': {
          'name': 'Nedensel Beden Meditasyonu',
          'steps': [
            'Derin bir meditasyon durumuna gir.',
            'Tüm ince bedenleri sırayla geç.',
            'Her katmandan vazgeç, bırak.',
            'Fiziksel beden farkındalığını bırak.',
            'Eterik titreşimi bırak.',
            'Duygusal dalgalanmaları bırak.',
            'Zihinsel aktiviteyi bırak.',
            'Astral formları bırak.',
            'Şablonları bırak.',
            'Selestiyal mutluluğu bile bırak.',
            'Geriye ne kalırsa, o nedensel öz.',
            'Bu özde dinlen.',
            'Sınırsız, zamansız, formsuz.',
            'Olabildiğince uzun kal.',
            'Çok yavaş geri dön.',
          ],
        },
      },
      'causalLevelPractices': [
        {
          'name': 'Atman Vichara (Öz Sorgulaması)',
          'description': '"Ben kimim?" sorusuyla öze ulaşma',
          'practice': '''
Ramana Maharshi'nin öğrettiği bu yöntem, "Ben kimim?" sorusunu
sürekli sormayı içerir. Her cevap reddedilir, çünkü gerçek ben,
tanımlanamaz. Bu süreç, nedensel öze götürür.
''',
        },
        {
          'name': 'Neti Neti (Bu Değil, Bu Değil)',
          'description': 'Olumsuzlama yoluyla öze ulaşma',
          'practice': '''
Her şeyi reddet: "Ben beden değilim, ben zihin değilim, ben
duygular değilim..." Geriye kalan, reddedilemez öz, nedensel
bedendir.
''',
        },
        {
          'name': 'Samadhi Pratiği',
          'description': 'Derin birleşme meditasyonu',
          'practice': '''
Uzun süreli, kesintisiz meditasyon yoluyla, bilinç tüm katmanları
aşar ve nedensel özde dinlenir. Bu, Nirvikalpa Samadhi veya
formsuz birlik halidir.
''',
        },
      ],
      'integrationWithDaily': '''
Nedensel beden bağlantısı, meditasyon dışında da sürdürülebilir.
Günlük aktivitelerde "tanık bilinci" aktif tutulur. "Ben" hissi,
nedensel öze yerleşir. Dünya, bu özden izlenir.

Bu, Sahaja Samadhi - doğal ve sürekli aydınlanma halidir.
Tantrik yolun nihai meyvesidir.
''',
    },

    // ─────────────────────────────────────────────────────────────────────────
    // ENERJİ BEDENI ENTEGRASYONU
    // ─────────────────────────────────────────────────────────────────────────
    'energyBodyIntegration': {
      'overview': '''
Tantrik pratik, tüm enerji bedenlerinin uyumlu çalışmasını hedefler.
Bir katmandaki dengesizlik, diğerlerini etkiler. Bütünsel şifa ve
gelişim, tüm katmanlarda eşzamanlı çalışmayı gerektirir.
''',
      'integrationPrinciples': [
        'Her katman birbirine bağlıdır',
        'Şifa yukarıdan aşağıya veya aşağıdan yukarıya olabilir',
        'Fiziksel pratik, ince bedenleri etkiler',
        'Meditasyon, fiziksel bedeni şifalandırabilir',
        'Denge, tek bir katmanda değil, bütünde aranır',
      ],
      'dailyIntegrationPractice': {
        'name': 'Yedi Katman Meditasyonu',
        'description': 'Tüm enerji bedenlerini uyumlayan günlük pratik',
        'duration': '30-45 dakika',
        'steps': [
          'Rahat bir pozisyonda otur.',
          'Nefesini derinleştir.',
          'Fiziksel bedeni tara ve gevşet.',
          'Eterik bedeni hisset - ısı, karıncalanma.',
          'Duygusal bedeni gözlemle - şu anki duygu.',
          'Zihinsel bedeni izle - düşünceler.',
          'Astral bedeni fark et - bağlantılar, rüyalar.',
          'Eterik şablonu hayal et - mükemmel form.',
          'Selestiyal mutluluğa açıl - ilahi sevgi.',
          'Nedensel öze bağlan - saf bilinç.',
          'Tüm katmanları tek bir ışıkta birleştir.',
          'Bu bütünlükte birkaç dakika kal.',
          'Yavaşça günlük bilince dön.',
          'Bütünlük hissini taşı.',
        ],
      },
      'partnerIntegration': {
        'name': 'Çift Enerji Beden Birleşimi',
        'description': 'Partnerlerin tüm katmanlarda birleşimi',
        'steps': [
          'Karşı karşıya oturun.',
          'Nefeslerinizi senkronize edin.',
          'Fiziksel temas kurun (eller).',
          'Eterik bedenlerinizin birleştiğini hissedin.',
          'Duygusal bedenlerinizi paylaşın.',
          'Zihinsel sessizliğe birlikte girin.',
          'Astral bağınızı güçlendirin.',
          'Birlikte şablona bağlanın.',
          'Selestiyal mutluluğu paylaşın.',
          'Nedensel özde birleşin.',
          'İki değil, tek bir bilinç olun.',
          'Bu birlikte olabildiğince kalın.',
          'Çok yavaş, birlikte ayrılın.',
          'Şükranla kapatın.',
        ],
      },
    },
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // YARDIMCI METODLAR
  // ═══════════════════════════════════════════════════════════════════════════

  /// Çakra bilgisini isimle al
  static Map<String, dynamic>? getChakraByName(String name) {
    return chakraSystem[name.toLowerCase()];
  }

  /// Tüm çakra isimlerini al
  static List<String> getAllChakraNames() {
    return chakraSystem.keys.toList();
  }

  /// Kundalini aşamasını numarayla al
  static Map<String, dynamic>? getKundaliniStage(int stage) {
    final stages = kundaliniAwakeningGuide['awakeningStages']['stages'] as List;
    return stages.firstWhere((s) => s['stage'] == stage, orElse: () => null);
  }

  /// Ay fazı ritüelini al
  static Map<String, dynamic>? getMoonPhaseRitual(String phase) {
    final phases = esotericRituals['moonPhaseRituals']['phases'] as List;
    return phases.firstWhere(
      (p) => (p['phase'] as String).toLowerCase().contains(phase.toLowerCase()),
      orElse: () => null,
    );
  }

  /// Venüs tantra bilgisini burca göre al
  static Map<String, dynamic>? getVenusTantraBySign(String sign) {
    return tantricAstrology['venusTantra']['byZodiac'][sign.toLowerCase()];
  }

  /// Mars cinsellik bilgisini burca göre al
  static Map<String, dynamic>? getMarsSexualityBySign(String sign) {
    return tantricAstrology['marsSexuality']['byZodiac'][sign.toLowerCase()];
  }

  /// Aura katmanını numarayla al
  static Map<String, dynamic>? getAuraLayer(int layer) {
    final layers = energyBodySystem['auraLayers']['layers'] as List;
    return layers.firstWhere((l) => l['layer'] == layer, orElse: () => null);
  }

  /// Prana vayu bilgisini al
  static Map<String, dynamic>? getPranaVayu(String name) {
    final vayus = energyBodySystem['pranicBody']['pranaVayus']['vayus'] as List;
    return vayus.firstWhere(
      (v) => (v['name'] as String).toLowerCase().contains(name.toLowerCase()),
      orElse: () => null,
    );
  }

  /// Mantra bilgisini al
  static Map<String, dynamic>? getMantraInfo(String mantra) {
    final mantras = esotericRituals['mantraPractices']['mainMantras'] as List;
    return mantras.firstWhere(
      (m) =>
          (m['mantra'] as String).toLowerCase().contains(mantra.toLowerCase()),
      orElse: () => null,
    );
  }
}
