// ════════════════════════════════════════════════════════════════════════════
// AFFIRMATION SERVICE - Daily Affirmation Engine
// ════════════════════════════════════════════════════════════════════════════
// Provides deterministic daily affirmation rotation, favorites tracking,
// and category-aware selection biased toward user engagement patterns.
// ════════════════════════════════════════════════════════════════════════════
library;

import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════════
// AFFIRMATION CATEGORY ENUM
// ════════════════════════════════════════════════════════════════

enum AffirmationCategory {
  selfWorth,
  growth,
  resilience,
  connection,
  calm,
  purpose;

  String get displayNameEn {
    switch (this) {
      case AffirmationCategory.selfWorth:
        return 'Self-Worth';
      case AffirmationCategory.growth:
        return 'Growth';
      case AffirmationCategory.resilience:
        return 'Resilience';
      case AffirmationCategory.connection:
        return 'Connection';
      case AffirmationCategory.calm:
        return 'Calm';
      case AffirmationCategory.purpose:
        return 'Purpose';
    }
  }

  String get displayNameTr {
    switch (this) {
      case AffirmationCategory.selfWorth:
        return 'Öz Değer';
      case AffirmationCategory.growth:
        return 'Gelişim';
      case AffirmationCategory.resilience:
        return 'Dayanıklılık';
      case AffirmationCategory.connection:
        return 'Bağlantı';
      case AffirmationCategory.calm:
        return 'Huzur';
      case AffirmationCategory.purpose:
        return 'Amaç';
    }
  }

  String get iconData {
    switch (this) {
      case AffirmationCategory.selfWorth:
        return 'star';
      case AffirmationCategory.growth:
        return 'eco';
      case AffirmationCategory.resilience:
        return 'shield';
      case AffirmationCategory.connection:
        return 'favorite';
      case AffirmationCategory.calm:
        return 'spa';
      case AffirmationCategory.purpose:
        return 'explore';
    }
  }
}

// ════════════════════════════════════════════════════════════════
// AFFIRMATION MODEL
// ════════════════════════════════════════════════════════════════

class Affirmation {
  final String id;
  final String textEn;
  final String textTr;
  final AffirmationCategory category;

  const Affirmation({
    required this.id,
    required this.textEn,
    required this.textTr,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'textEn': textEn,
        'textTr': textTr,
        'category': category.name,
      };

  factory Affirmation.fromJson(Map<String, dynamic> json) => Affirmation(
        id: json['id'],
        textEn: json['textEn'],
        textTr: json['textTr'],
        category: AffirmationCategory.values.firstWhere(
          (c) => c.name == json['category'],
          orElse: () => AffirmationCategory.selfWorth,
        ),
      );
}

// ════════════════════════════════════════════════════════════════
// AFFIRMATION SERVICE
// ════════════════════════════════════════════════════════════════

class AffirmationService {
  static const String _favoritesKey = 'affirmation_favorites';
  static const String _engagementKey = 'affirmation_category_engagement';

  final SharedPreferences _prefs;

  AffirmationService(this._prefs);

  /// Initialize service with SharedPreferences
  static Future<AffirmationService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return AffirmationService(prefs);
  }

  // ═══════════════════════════════════════════════════════════════
  // DAILY AFFIRMATION
  // ═══════════════════════════════════════════════════════════════

  /// Get today's affirmation using a deterministic date-based hash.
  /// Biases selection toward categories the user engages with most.
  Affirmation getDailyAffirmation() {
    final now = DateTime.now();
    final dayHash = now.year * 10000 + now.month * 100 + now.day;

    // Check engagement weights for category-aware selection
    final engagement = _getEngagementMap();
    if (engagement.isNotEmpty) {
      final totalEngagement =
          engagement.values.fold<int>(0, (sum, v) => sum + v);
      if (totalEngagement > 3) {
        // Enough data to bias
        return _weightedSelection(dayHash, engagement, totalEngagement);
      }
    }

    // Default: simple rotation across all affirmations
    final index = dayHash % _allAffirmations.length;
    return _allAffirmations[index];
  }

  Affirmation _weightedSelection(
    int seed,
    Map<String, int> engagement,
    int totalEngagement,
  ) {
    final rng = Random(seed);

    // Build weighted category list
    final weightedCategories = <AffirmationCategory>[];
    for (final cat in AffirmationCategory.values) {
      final count = engagement[cat.name] ?? 0;
      // Base weight of 1, plus engagement bonus
      final weight = 1 + count;
      for (int i = 0; i < weight; i++) {
        weightedCategories.add(cat);
      }
    }

    final selectedCategory =
        weightedCategories[rng.nextInt(weightedCategories.length)];
    final categoryAffirmations =
        _allAffirmations.where((a) => a.category == selectedCategory).toList();
    final index = seed % categoryAffirmations.length;
    return categoryAffirmations[index];
  }

  // ═══════════════════════════════════════════════════════════════
  // CATEGORY SELECTION
  // ═══════════════════════════════════════════════════════════════

  /// Get an affirmation for a specific category (rotates daily within category)
  Affirmation getAffirmationForCategory(AffirmationCategory category) {
    final now = DateTime.now();
    final dayHash = now.year * 10000 + now.month * 100 + now.day;
    final categoryAffirmations =
        _allAffirmations.where((a) => a.category == category).toList();
    final index = dayHash % categoryAffirmations.length;

    // Track engagement
    _trackEngagement(category);

    return categoryAffirmations[index];
  }

  /// Get all affirmations for a category
  List<Affirmation> getAllByCategory(AffirmationCategory category) {
    return _allAffirmations.where((a) => a.category == category).toList();
  }

  // ═══════════════════════════════════════════════════════════════
  // FAVORITES
  // ═══════════════════════════════════════════════════════════════

  /// Toggle favorite state for an affirmation. Returns new favorite state.
  Future<bool> toggleFavorite(String id) async {
    final favorites = _getFavoriteIds();
    final isNowFavorite = !favorites.contains(id);

    if (isNowFavorite) {
      favorites.add(id);
    } else {
      favorites.remove(id);
    }

    await _prefs.setStringList(_favoritesKey, favorites.toList());
    return isNowFavorite;
  }

  /// Check if an affirmation is favorited
  bool isFavorite(String id) {
    return _getFavoriteIds().contains(id);
  }

  /// Get all favorited affirmations
  List<Affirmation> getFavorites() {
    final favoriteIds = _getFavoriteIds();
    return _allAffirmations
        .where((a) => favoriteIds.contains(a.id))
        .toList();
  }

  Set<String> _getFavoriteIds() {
    final list = _prefs.getStringList(_favoritesKey) ?? [];
    return list.toSet();
  }

  // ═══════════════════════════════════════════════════════════════
  // ENGAGEMENT TRACKING
  // ═══════════════════════════════════════════════════════════════

  void _trackEngagement(AffirmationCategory category) {
    final engagement = _getEngagementMap();
    engagement[category.name] = (engagement[category.name] ?? 0) + 1;
    _prefs.setString(_engagementKey, jsonEncode(engagement));
  }

  Map<String, int> _getEngagementMap() {
    final raw = _prefs.getString(_engagementKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v as int));
  }

  // ═══════════════════════════════════════════════════════════════
  // AFFIRMATION DATA (60 total, 10 per category)
  // ═══════════════════════════════════════════════════════════════

  static final List<Affirmation> _allAffirmations = [
    // ────────────────────────────────────────────
    // SELF-WORTH (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'sw_01',
      textEn: 'I am enough, exactly as I am right now.',
      textTr: 'Tam da su an oldugum haliyle yeterliyim.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_02',
      textEn: 'My worth is not measured by my productivity.',
      textTr: 'Degerim uretkenligimle olculemez.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_03',
      textEn: 'I deserve kindness, especially from myself.',
      textTr: 'Sevgiyi hak ediyorum, ozellikle kendimden.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_04',
      textEn: 'I honor who I am becoming.',
      textTr: 'Olmaya basladigim kisiyi onurlandiriyorum.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_05',
      textEn: 'My feelings are valid and important.',
      textTr: 'Hislerim gecerli ve onemli.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_06',
      textEn: 'I choose to see the good in myself today.',
      textTr: 'Bugun kendimde iyiligi gormeyi seciyorum.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_07',
      textEn: 'I am worthy of love and belonging.',
      textTr: 'Sevgi ve ait olma duygusunu hak ediyorum.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_08',
      textEn: 'My imperfections make me beautifully human.',
      textTr: 'Kusurlarim beni guzel bir sekilde insan yapar.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_09',
      textEn: 'I release the need for others\' approval.',
      textTr: 'Baskalarina onay ihtiyacimi birakiyorum.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_10',
      textEn: 'I am a gift to the world around me.',
      textTr: 'Cevremdeki dunyaya bir hediyeyim.',
      category: AffirmationCategory.selfWorth,
    ),

    // ────────────────────────────────────────────
    // GROWTH (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'gr_01',
      textEn: 'Every small step I take matters.',
      textTr: 'Attigim her kucuk adim onemli.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_02',
      textEn: 'I am open to learning from every experience.',
      textTr: 'Her deneyimden ogrenmeye acigim.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_03',
      textEn: 'Change is my opportunity, not my enemy.',
      textTr: 'Degisim benim firsatim, dusman degil.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_04',
      textEn: 'I grow stronger with every challenge I face.',
      textTr: 'Yasadigim her zorlukla daha guclu oluyorum.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_05',
      textEn: 'My potential is limitless when I stay curious.',
      textTr: 'Merakli kaldigimda potansiyelim sinirsiz.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_06',
      textEn: 'I celebrate my progress, no matter how small.',
      textTr: 'Ilerlememi ne kadar kucuk olursa olsun kutlarim.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_07',
      textEn: 'Mistakes are stepping stones to wisdom.',
      textTr: 'Hatalar bilgelige giden basamaklardir.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_08',
      textEn: 'I trust the timing of my own journey.',
      textTr: 'Kendi yolculugumun zamanlamasina guveniyorum.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_09',
      textEn: 'Today I plant seeds for a brighter tomorrow.',
      textTr: 'Bugun daha aydinlik bir yarin icin tohumlar ekiyorum.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_10',
      textEn: 'I welcome new perspectives with an open heart.',
      textTr: 'Yeni bakis acilarini acik yurekte karsiliyorum.',
      category: AffirmationCategory.growth,
    ),

    // ────────────────────────────────────────────
    // RESILIENCE (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 're_01',
      textEn: 'I have survived difficult days before, and I will again.',
      textTr: 'Daha once zor gunler atlattim, yine atlatacagim.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_02',
      textEn: 'Storms pass. I remain.',
      textTr: 'Firtinalar gecer. Ben kalirim.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_03',
      textEn: 'My strength is greater than any struggle.',
      textTr: 'Gucum her mucadeleden buyuktur.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_04',
      textEn: 'I bend, but I do not break.',
      textTr: 'Egiliyorum ama kirilmiyorum.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_05',
      textEn: 'Healing is not linear, and that is okay.',
      textTr: 'Iyilesme duz bir cizgi degil ve bu normal.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_06',
      textEn: 'I give myself permission to rest and rebuild.',
      textTr: 'Dinlenmem ve yeniden kurulmam icin kendime izin veriyorum.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_07',
      textEn: 'Challenges reveal the depth of my courage.',
      textTr: 'Zorluklar cesaretimin derinligini ortaya koyar.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_08',
      textEn: 'I carry the wisdom of everything I have overcome.',
      textTr: 'Ustesinden geldigim her seyin bilgeligini tasiyorum.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_09',
      textEn: 'I am resilient, resourceful, and ready.',
      textTr: 'Dayanikliyim, becerikli ve hazir.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_10',
      textEn: 'Even on hard days, I choose to keep going.',
      textTr: 'Zor gunlerde bile devam etmeyi seciyorum.',
      category: AffirmationCategory.resilience,
    ),

    // ────────────────────────────────────────────
    // CONNECTION (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'cn_01',
      textEn: 'I attract meaningful relationships into my life.',
      textTr: 'Hayatima anlamli iliskiler cekiyorum.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_02',
      textEn: 'I am surrounded by people who care for me.',
      textTr: 'Beni onemseyenlerle cevriliyim.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_03',
      textEn: 'I communicate with honesty and compassion.',
      textTr: 'Durustluk ve sefkatle iletisim kuruyorum.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_04',
      textEn: 'Vulnerability is a bridge, not a weakness.',
      textTr: 'Kirilganlik bir koprudur, zayiflik degil.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_05',
      textEn: 'I nurture the bonds that nourish my soul.',
      textTr: 'Ruhumu besleyen baglari buyuturum.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_06',
      textEn: 'I am deeply connected to the world around me.',
      textTr: 'Cevremdeki dunyayla derin bir baglantim var.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_07',
      textEn: 'Love flows to me and through me effortlessly.',
      textTr: 'Sevgi zahmetsizce bana ve benden akar.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_08',
      textEn: 'I listen with presence and speak with intention.',
      textTr: 'Varligimla dinler, niyetimle konusurum.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_09',
      textEn: 'I set healthy boundaries out of love, not fear.',
      textTr: 'Saglikli sinirlarimi korkudan degil sevgiden koyarim.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_10',
      textEn: 'Every kind word I share ripples outward.',
      textTr: 'Paylasidigim her guzel soz dalga dalga yayilir.',
      category: AffirmationCategory.connection,
    ),

    // ────────────────────────────────────────────
    // CALM (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'ca_01',
      textEn: 'I give myself permission to slow down.',
      textTr: 'Yavaslama izni veriyorum kendime.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_02',
      textEn: 'Peace begins with a single breath.',
      textTr: 'Huzur tek bir nefesle baslar.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_03',
      textEn: 'I release what I cannot control.',
      textTr: 'Kontrol edemedigim seyleri birakiyorum.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_04',
      textEn: 'This moment is enough. I am safe here.',
      textTr: 'Bu an yeterli. Burada guvendeyim.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_05',
      textEn: 'My mind is clear, my heart is steady.',
      textTr: 'Zihnim berrak, kalbim sakin.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_06',
      textEn: 'I choose stillness over rush.',
      textTr: 'Acilacilik yerine duraganligi secerim.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_07',
      textEn: 'Silence is where I find my deepest clarity.',
      textTr: 'Sessizlik en derin berrakligimi buldugun yer.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_08',
      textEn: 'I am the calm in my own storm.',
      textTr: 'Kendi firtinamdaki sukunetim benim.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_09',
      textEn: 'With each exhale, I let go of tension.',
      textTr: 'Her nefes veriste gerginligi birakiyorum.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_10',
      textEn: 'I trust that everything is unfolding as it should.',
      textTr: 'Her seyin olmasi gerektigi gibi acildigina guveniyorum.',
      category: AffirmationCategory.calm,
    ),

    // ────────────────────────────────────────────
    // PURPOSE (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'pu_01',
      textEn: 'My life has meaning, and my actions have impact.',
      textTr: 'Hayatimin bir anlami var ve eylemlerimin etkisi.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_02',
      textEn: 'I am guided by my inner compass.',
      textTr: 'Ic pusulamla yonlendiriliyorum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_03',
      textEn: 'I am building a life aligned with my values.',
      textTr: 'Degerlerimle uyumlu bir hayat kuruyorum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_04',
      textEn: 'My unique gifts are needed in this world.',
      textTr: 'Benzersiz yeteneklerime bu dunyada ihtiyac var.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_05',
      textEn: 'I show up for what matters most to me.',
      textTr: 'Benim icin en onemli olan sey icin hazir bulunarim.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_06',
      textEn: 'My purpose reveals itself one step at a time.',
      textTr: 'Amacim her seferinde bir adim ortaya cikar.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_07',
      textEn: 'I contribute something valuable just by being myself.',
      textTr: 'Sadece kendim olarak degerli bir sey katiyorum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_08',
      textEn: 'I follow what lights me up inside.',
      textTr: 'Icimi aydinlatan seylerin pesinden giderim.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_09',
      textEn: 'Today I choose to live with intention.',
      textTr: 'Bugun niyetle yasamayi seciyorum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_10',
      textEn: 'I am on the right path, even when it feels uncertain.',
      textTr: 'Belirsiz hissettirdiginde bile dogru yoldayim.',
      category: AffirmationCategory.purpose,
    ),
  ];
}
