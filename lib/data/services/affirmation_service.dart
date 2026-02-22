// ════════════════════════════════════════════════════════════════════════════
// AFFIRMATION SERVICE - Daily Affirmation Engine
// ════════════════════════════════════════════════════════════════════════════
// Provides deterministic daily affirmation rotation, favorites tracking,
// and category-aware selection biased toward user engagement patterns.
// ════════════════════════════════════════════════════════════════════════════
library;

import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
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

  static const _defaultAffirmation = Affirmation(
    id: 'default',
    textEn: 'You are growing every day.',
    textTr: 'Her gun buyuyorsun.',
    category: AffirmationCategory.growth,
  );

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
      final totalEngagement = engagement.values.fold<int>(
        0,
        (sum, v) => sum + v,
      );
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
    final categoryAffirmations = _allAffirmations
        .where((a) => a.category == selectedCategory)
        .toList();
    if (categoryAffirmations.isEmpty) {
      if (_allAffirmations.isEmpty) return _defaultAffirmation;
      return _allAffirmations.first;
    }
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
    final categoryAffirmations = _allAffirmations
        .where((a) => a.category == category)
        .toList();
    if (categoryAffirmations.isEmpty) {
      if (_allAffirmations.isEmpty) return _defaultAffirmation;
      return _allAffirmations.first;
    }
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
    return _allAffirmations.where((a) => favoriteIds.contains(a.id)).toList();
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
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as int? ?? 0));
    } catch (e) {
      if (kDebugMode) debugPrint('Affirmation: decode engagement map: $e');
      return {};
    }
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
      textTr: 'Tam da şu an olduğum haliyle yeterliyim.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_02',
      textEn: 'My worth is not measured by my productivity.',
      textTr: 'Değerim üretkenliğimle ölçülemez.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_03',
      textEn: 'I deserve kindness, especially from myself.',
      textTr: 'Sevgiyi hak ediyorum, özellikle kendimden.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_04',
      textEn: 'I honor who I am becoming.',
      textTr: 'Olmaya başladığım kişiyi onurlandırıyorum.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_05',
      textEn: 'My feelings are valid and important.',
      textTr: 'Hislerim geçerli ve önemli.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_06',
      textEn: 'I choose to see the good in myself today.',
      textTr: 'Bugün kendimde iyiliği görmeyi seçiyorum.',
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
      textTr: 'Kusurlarım beni güzel bir şekilde insan yapar.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_09',
      textEn: 'I release the need for others\' approval.',
      textTr: 'Başkalarına onay ihtiyacımı bırakıyorum.',
      category: AffirmationCategory.selfWorth,
    ),
    const Affirmation(
      id: 'sw_10',
      textEn: 'I am a gift to the world around me.',
      textTr: 'Çevremdeki dünyaya bir hediyeyim.',
      category: AffirmationCategory.selfWorth,
    ),

    // ────────────────────────────────────────────
    // GROWTH (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'gr_01',
      textEn: 'Every small step I take matters.',
      textTr: 'Attığım her küçük adım önemli.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_02',
      textEn: 'I am open to learning from every experience.',
      textTr: 'Her deneyimden öğrenmeye açığım.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_03',
      textEn: 'Change is my opportunity, not my enemy.',
      textTr: 'Değişim benim fırsatım, düşman değil.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_04',
      textEn: 'I grow stronger with every challenge I face.',
      textTr: 'Yaşadığım her zorlukla daha güçlü oluyorum.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_05',
      textEn: 'My potential keeps expanding when I stay curious.',
      textTr: 'Meraklı kaldığımda potansiyelim sınırsız.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_06',
      textEn: 'I celebrate my progress, no matter how small.',
      textTr: 'İlerlememi ne kadar küçük olursa olsun kutlarım.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_07',
      textEn: 'Mistakes are stepping stones to wisdom.',
      textTr: 'Hatalar bilgeliğe giden basamaklardır.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_08',
      textEn: 'I trust the timing of my own progress.',
      textTr: 'Kendi sürecimin zamanlamasına güveniyorum.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_09',
      textEn: 'Today I plant seeds for a brighter tomorrow.',
      textTr: 'Bugün daha aydınlık bir yarın için tohumlar ekiyorum.',
      category: AffirmationCategory.growth,
    ),
    const Affirmation(
      id: 'gr_10',
      textEn: 'I welcome new perspectives with an open heart.',
      textTr: 'Yeni bakış açılarını açık yürekte karşılıyorum.',
      category: AffirmationCategory.growth,
    ),

    // ────────────────────────────────────────────
    // RESILIENCE (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 're_01',
      textEn: 'I have survived difficult days before, and I will again.',
      textTr: 'Daha önce zor günler atlattım, yine atlatacağım.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_02',
      textEn: 'Storms pass. I remain.',
      textTr: 'Fırtınalar geçer. Ben kalırım.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_03',
      textEn: 'My strength is greater than any struggle.',
      textTr: 'Gücüm her mücadeleden büyüktür.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_04',
      textEn: 'I bend, but I do not break.',
      textTr: 'Eğiliyorum ama kırılmıyorum.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_05',
      textEn: 'Recovery is not linear, and that is okay.',
      textTr: 'İyileşme düz bir çizgi değil ve bu normal.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_06',
      textEn: 'I give myself permission to rest and rebuild.',
      textTr: 'Dinlenmem ve yeniden kurulmam için kendime izin veriyorum.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_07',
      textEn: 'Challenges reveal the depth of my courage.',
      textTr: 'Zorluklar cesaretimin derinliğini ortaya koyar.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_08',
      textEn: 'I carry the wisdom of everything I have overcome.',
      textTr: 'Üstesinden geldiğim her şeyin bilgeliğini taşıyorum.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_09',
      textEn: 'I am resilient, resourceful, and ready.',
      textTr: 'Dayanıklıyım, becerikli ve hazır.',
      category: AffirmationCategory.resilience,
    ),
    const Affirmation(
      id: 're_10',
      textEn: 'Even on hard days, I choose to keep going.',
      textTr: 'Zor günlerde bile devam etmeyi seçiyorum.',
      category: AffirmationCategory.resilience,
    ),

    // ────────────────────────────────────────────
    // CONNECTION (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'cn_01',
      textEn: 'I attract meaningful relationships into my life.',
      textTr: 'Hayatıma anlamlı ilişkiler çekiyorum.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_02',
      textEn: 'I am surrounded by people who care for me.',
      textTr: 'Beni önemseyenlerle çevriliyim.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_03',
      textEn: 'I communicate with honesty and compassion.',
      textTr: 'Dürüstlük ve şefkatle iletişim kuruyorum.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_04',
      textEn: 'Vulnerability is a bridge, not a weakness.',
      textTr: 'Kırılganlık bir köprüdür, zayıflık değil.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_05',
      textEn: 'I nurture the bonds that nourish my heart.',
      textTr: 'Kalbimi besleyen bağları büyütürüm.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_06',
      textEn: 'I am deeply connected to the world around me.',
      textTr: 'Çevremdeki dünyayla derin bir bağlantım var.',
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
      textTr: 'Varlığımla dinler, niyetimle konuşurum.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_09',
      textEn: 'I set healthy boundaries out of love, not fear.',
      textTr: 'Sağlıklı sınırlarımı korkudan değil sevgiden koyarım.',
      category: AffirmationCategory.connection,
    ),
    const Affirmation(
      id: 'cn_10',
      textEn: 'Every kind word I share ripples outward.',
      textTr: 'Paylaştığım her güzel söz dalga dalga yayılır.',
      category: AffirmationCategory.connection,
    ),

    // ────────────────────────────────────────────
    // CALM (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'ca_01',
      textEn: 'I give myself permission to slow down.',
      textTr: 'Yavaşlama izni veriyorum kendime.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_02',
      textEn: 'Peace begins with a single breath.',
      textTr: 'Huzur tek bir nefesle başlar.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_03',
      textEn: 'I release what I cannot control.',
      textTr: 'Kontrol edemediğim şeyleri bırakıyorum.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_04',
      textEn: 'This moment is enough. I am safe here.',
      textTr: 'Bu an yeterli. Burada güvendeyim.',
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
      textTr: 'Acelecilik yerine durağanlığı seçerim.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_07',
      textEn: 'Silence is where I find my deepest clarity.',
      textTr: 'Sessizlik en derin berraklığımı bulduğum yer.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_08',
      textEn: 'I am the calm in my own storm.',
      textTr: 'Kendi fırtınamdaki sükûnetim benim.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_09',
      textEn: 'With each exhale, I let go of tension.',
      textTr: 'Her nefes verişte gerginliği bırakıyorum.',
      category: AffirmationCategory.calm,
    ),
    const Affirmation(
      id: 'ca_10',
      textEn: 'I trust that everything is unfolding as it should.',
      textTr: 'Her şeyin olması gerektiği gibi açıldığına güveniyorum.',
      category: AffirmationCategory.calm,
    ),

    // ────────────────────────────────────────────
    // PURPOSE (10)
    // ────────────────────────────────────────────
    const Affirmation(
      id: 'pu_01',
      textEn: 'My life has meaning, and my actions have impact.',
      textTr: 'Hayatımın bir anlamı var ve eylemlerimin etkisi.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_02',
      textEn: 'I am guided by my inner compass.',
      textTr: 'İç pusulamla yönlendiriliyorum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_03',
      textEn: 'I am building a life aligned with my values.',
      textTr: 'Değerlerimle uyumlu bir hayat kuruyorum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_04',
      textEn: 'My unique gifts are needed in this world.',
      textTr: 'Benzersiz yeteneklerime bu dünyada ihtiyaç var.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_05',
      textEn: 'I show up for what matters most to me.',
      textTr: 'Benim için en önemli olan şey için hazır bulunurum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_06',
      textEn: 'My purpose reveals itself one step at a time.',
      textTr: 'Amacım her seferinde bir adım ortaya çıkar.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_07',
      textEn: 'I contribute something valuable just by being myself.',
      textTr: 'Sadece kendim olarak değerli bir şey katıyorum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_08',
      textEn: 'I follow what lights me up inside.',
      textTr: 'İçimi aydınlatan şeylerin peşinden giderim.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_09',
      textEn: 'Today I choose to live with intention.',
      textTr: 'Bugün niyetle yaşamayı seçiyorum.',
      category: AffirmationCategory.purpose,
    ),
    const Affirmation(
      id: 'pu_10',
      textEn: 'I am on the right path, even when it feels uncertain.',
      textTr: 'Belirsiz hissettirdiğinde bile doğru yoldayım.',
      category: AffirmationCategory.purpose,
    ),
  ];
}
