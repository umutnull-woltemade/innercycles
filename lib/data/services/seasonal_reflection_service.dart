// ════════════════════════════════════════════════════════════════════════════
// SEASONAL REFLECTION SERVICE - InnerCycles Quarterly Themes
// ════════════════════════════════════════════════════════════════════════════
// 4 seasonal modules with themed reflection prompts.
// Auto-detects current season. Premium: full seasonal archive.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum Season { spring, summer, autumn, winter }

class SeasonalPrompt {
  final int index;
  final String titleEn;
  final String titleTr;
  final String promptEn;
  final String promptTr;

  const SeasonalPrompt({
    required this.index,
    required this.titleEn,
    required this.titleTr,
    required this.promptEn,
    required this.promptTr,
  });
}

class SeasonalModule {
  final Season season;
  final String nameEn;
  final String nameTr;
  final String emoji;
  final String themeEn;
  final String themeTr;
  final List<SeasonalPrompt> prompts;

  const SeasonalModule({
    required this.season,
    required this.nameEn,
    required this.nameTr,
    required this.emoji,
    required this.themeEn,
    required this.themeTr,
    required this.prompts,
  });
}

class SeasonalProgress {
  final Season season;
  final int year;
  final Set<int> completedPrompts;

  SeasonalProgress({
    required this.season,
    required this.year,
    required this.completedPrompts,
  });

  Map<String, dynamic> toJson() => {
        'season': season.name,
        'year': year,
        'completedPrompts': completedPrompts.toList(),
      };

  factory SeasonalProgress.fromJson(Map<String, dynamic> json) =>
      SeasonalProgress(
        season: Season.values.firstWhere(
          (s) => s.name == json['season'],
          orElse: () => Season.spring,
        ),
        year: json['year'] as int? ?? 2024,
        completedPrompts:
            (json['completedPrompts'] as List<dynamic>? ?? []).cast<int>().toSet(),
      );
}

class SeasonalReflectionService {
  static const String _progressKey = 'inner_cycles_seasonal_progress';
  final SharedPreferences _prefs;
  Map<String, SeasonalProgress> _progress = {};

  SeasonalReflectionService._(this._prefs) {
    _loadProgress();
  }

  static Future<SeasonalReflectionService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SeasonalReflectionService._(prefs);
  }

  /// Detect current season based on month (Northern Hemisphere)
  static Season currentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 9 && month <= 11) return Season.autumn;
    return Season.winter;
  }

  /// Get current seasonal module
  SeasonalModule getCurrentModule() {
    return getModule(currentSeason());
  }

  /// Get a specific seasonal module
  SeasonalModule getModule(Season season) {
    return allModules.firstWhere(
      (m) => m.season == season,
      orElse: () => allModules.first,
    );
  }

  /// Get progress for current season
  SeasonalProgress getCurrentProgress() {
    final season = currentSeason();
    final year = DateTime.now().year;
    final key = '${season.name}_$year';
    return _progress[key] ??
        SeasonalProgress(season: season, year: year, completedPrompts: {});
  }

  /// Complete a prompt
  Future<void> completePrompt(int promptIndex) async {
    final season = currentSeason();
    final year = DateTime.now().year;
    final key = '${season.name}_$year';
    final current = _progress[key] ??
        SeasonalProgress(season: season, year: year, completedPrompts: {});
    current.completedPrompts.add(promptIndex);
    _progress[key] = current;
    await _persistProgress();
  }

  /// Check completion percentage
  double getCompletionPercent() {
    final module = getCurrentModule();
    final progress = getCurrentProgress();
    if (module.prompts.isEmpty) return 0;
    return progress.completedPrompts.length / module.prompts.length;
  }

  // Persistence
  void _loadProgress() {
    final jsonString = _prefs.getString(_progressKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _progress = jsonMap.map(
          (k, v) => MapEntry(k, SeasonalProgress.fromJson(v)),
        );
      } catch (_) {
        _progress = {};
      }
    }
  }

  Future<void> _persistProgress() async {
    final jsonMap = _progress.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs.setString(_progressKey, json.encode(jsonMap));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SEASONAL MODULES
  // ══════════════════════════════════════════════════════════════════════════

  static const List<SeasonalModule> allModules = [
    _springModule,
    _summerModule,
    _autumnModule,
    _winterModule,
  ];

  static const _springModule = SeasonalModule(
    season: Season.spring,
    nameEn: 'Spring Renewal',
    nameTr: 'Bahar Yenilenmesi',
    emoji: '🌱',
    themeEn: 'New beginnings and fresh intentions',
    themeTr: 'Yeni başlangıçlar ve taze niyetler',
    prompts: [
      SeasonalPrompt(index: 0, titleEn: 'Seeds of Intention', titleTr: 'Niyet Tohumları', promptEn: 'What new intentions are you planting this season? What do you want to nurture?', promptTr: 'Bu mevsim hangi yeni niyetleri ekiyorsun? Neyi beslemek istiyorsun?'),
      SeasonalPrompt(index: 1, titleEn: 'Spring Cleaning', titleTr: 'Bahar Temizliği', promptEn: 'What mental or emotional clutter can you release this spring?', promptTr: 'Bu bahar hangi zihinsel veya duygusal karmaşayı bırakabilirsin?'),
      SeasonalPrompt(index: 2, titleEn: 'Growth Mindset', titleTr: 'Büyüme Zihniyeti', promptEn: 'Where in your life do you see the most potential for growth right now?', promptTr: 'Hayatında şu an en çok büyüme potansiyelini nerede görüyorsun?'),
      SeasonalPrompt(index: 3, titleEn: 'Emerging Patterns', titleTr: 'Ortaya Çıkan Kalıplar', promptEn: 'Look back at your recent entries. What new patterns are emerging?', promptTr: 'Son kayıtlarına bak. Hangi yeni kalıplar ortaya çıkıyor?'),
      SeasonalPrompt(index: 4, titleEn: 'Equinox Balance', titleTr: 'Ekinoks Dengesi', promptEn: 'Spring equinox represents balance. Where do you need more balance in your life?', promptTr: 'Bahar ekinoksu dengeyi temsil eder. Hayatında nerede daha fazla dengeye ihtiyacın var?'),
      SeasonalPrompt(index: 5, titleEn: 'Renewal Ritual', titleTr: 'Yenilenme Ritüeli', promptEn: 'Design a personal renewal ritual for this season. What does it include?', promptTr: 'Bu mevsim için kişisel bir yenilenme ritüeli tasarla. Neler içeriyor?'),
    ],
  );

  static const _summerModule = SeasonalModule(
    season: Season.summer,
    nameEn: 'Summer Radiance',
    nameTr: 'Yaz Parlaklığı',
    emoji: '☀️',
    themeEn: 'Energy, expression, and fullness',
    themeTr: 'Enerji, ifade ve doluluk',
    prompts: [
      SeasonalPrompt(index: 0, titleEn: 'Peak Energy', titleTr: 'Doruk Enerji', promptEn: 'Summer is peak energy season. What are you pouring your energy into?', promptTr: 'Yaz doruk enerji mevsimidir. Enerjini neye harcıyorsun?'),
      SeasonalPrompt(index: 1, titleEn: 'Solstice Light', titleTr: 'Gündönümü Işığı', promptEn: 'The longest days bring the most light. What is becoming clearer for you?', promptTr: 'En uzun günler en çok ışığı getirir. Senin için ne netleşiyor?'),
      SeasonalPrompt(index: 2, titleEn: 'Joy Inventory', titleTr: 'Neşe Envanteri', promptEn: 'List 5 things that brought you genuine joy this summer.', promptTr: 'Bu yaz sana gerçek neşe getiren 5 şey listele.'),
      SeasonalPrompt(index: 3, titleEn: 'Adventure Log', titleTr: 'Macera Kaydı', promptEn: 'What adventures — big or small — have you had recently?', promptTr: 'Son zamanlarda hangi maceralar — büyük veya küçük — yaşadın?'),
      SeasonalPrompt(index: 4, titleEn: 'Connection Check', titleTr: 'Bağlantı Kontrolü', promptEn: 'Summer often brings social energy. How are your connections feeling?', promptTr: 'Yaz genellikle sosyal enerji getirir. Bağlantıların nasıl hissettiriyor?'),
      SeasonalPrompt(index: 5, titleEn: 'Harvest Preview', titleTr: 'Hasat Önizlemesi', promptEn: 'What seeds you planted earlier are now showing results?', promptTr: 'Daha önce ektiğin hangi tohumlar şimdi sonuç veriyor?'),
    ],
  );

  static const _autumnModule = SeasonalModule(
    season: Season.autumn,
    nameEn: 'Autumn Harvest',
    nameTr: 'Sonbahar Hasadı',
    emoji: '🍂',
    themeEn: 'Reflection, gratitude, and release',
    themeTr: 'Yansıma, şükran ve bırakma',
    prompts: [
      SeasonalPrompt(index: 0, titleEn: 'Gratitude Harvest', titleTr: 'Şükran Hasadı', promptEn: 'What are you most grateful for from the past season?', promptTr: 'Geçen mevsimden en çok neye minnettarsın?'),
      SeasonalPrompt(index: 1, titleEn: 'Letting Go', titleTr: 'Bırakmak', promptEn: 'Like falling leaves, what are you ready to release?', promptTr: 'Düşen yapraklar gibi, neyi bırakmaya hazırsın?'),
      SeasonalPrompt(index: 2, titleEn: 'Wisdom Gathered', titleTr: 'Toplanan Bilgelik', promptEn: 'What wisdom have you gathered from your recent experiences?', promptTr: 'Son deneyimlerinden hangi bilgeliği topladın?'),
      SeasonalPrompt(index: 3, titleEn: 'Inner Warmth', titleTr: 'İç Sıcaklık', promptEn: 'As the world cools, what keeps you warm inside?', promptTr: 'Dünya soğurken, seni içten ne sıcak tutuyor?'),
      SeasonalPrompt(index: 4, titleEn: 'Cycle Review', titleTr: 'Döngü İncelemesi', promptEn: 'Review your journal patterns from the last 3 months. What cycles do you notice?', promptTr: 'Son 3 ayın günlük kalıplarını incele. Hangi döngüleri fark ediyorsun?'),
      SeasonalPrompt(index: 5, titleEn: 'Preparation', titleTr: 'Hazırlık', promptEn: 'How are you preparing yourself for the quieter months ahead?', promptTr: 'Kendini önümüzdeki sessiz aylara nasıl hazırlıyorsun?'),
    ],
  );

  static const _winterModule = SeasonalModule(
    season: Season.winter,
    nameEn: 'Winter Stillness',
    nameTr: 'Kış Sessizliği',
    emoji: '❄️',
    themeEn: 'Rest, depth, and inner knowing',
    themeTr: 'Dinlenme, derinlik ve iç bilgelik',
    prompts: [
      SeasonalPrompt(index: 0, titleEn: 'Rest Permission', titleTr: 'Dinlenme İzni', promptEn: 'Winter invites rest. Where in your life do you need to slow down?', promptTr: 'Kış dinlenmeye davet eder. Hayatında nerede yavaşlaman gerekiyor?'),
      SeasonalPrompt(index: 1, titleEn: 'Solstice Darkness', titleTr: 'Gündönümü Karanlığı', promptEn: 'The longest night is also the return of light. What do you find in your darkness?', promptTr: 'En uzun gece aynı zamanda ışığın dönüşüdür. Karanlığında ne buluyorsun?'),
      SeasonalPrompt(index: 2, titleEn: 'Year in Review', titleTr: 'Yıl Değerlendirmesi', promptEn: 'Looking back at this year, what are your 3 biggest learnings?', promptTr: 'Bu yıla baktığında, en büyük 3 öğrenimin nedir?'),
      SeasonalPrompt(index: 3, titleEn: 'Inner Fire', titleTr: 'İç Ateş', promptEn: 'What passion or dream still burns inside you?', promptTr: 'İçinde hâlâ hangi tutku veya hayal yanıyor?'),
      SeasonalPrompt(index: 4, titleEn: 'Dream Seeds', titleTr: 'Rüya Tohumları', promptEn: 'What dreams do you want to plant for the coming year?', promptTr: 'Gelecek yıl için hangi hayalleri ekmek istiyorsun?'),
      SeasonalPrompt(index: 5, titleEn: 'Cocoon Phase', titleTr: 'Koza Evresi', promptEn: 'Like a cocoon, what transformation is happening within you right now?', promptTr: 'Bir koza gibi, şu an içinde hangi dönüşüm gerçekleşiyor?'),
    ],
  );
}
