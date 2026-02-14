// ════════════════════════════════════════════════════════════════════════════
// JOURNAL PROMPT SERVICE - Curated Journaling Prompts Engine
// ════════════════════════════════════════════════════════════════════════════
// Provides 80 bilingual (EN/TR) journaling prompts across 8 categories.
// Deterministic daily prompt, smart selection, and completion tracking.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../content/reflection_prompts_content.dart';

// ════════════════════════════════════════════════════════════════════════════
// ENUMS
// ════════════════════════════════════════════════════════════════════════════

enum PromptCategory {
  selfDiscovery,
  relationships,
  gratitude,
  emotions,
  goals,
  healing,
  creativity,
  mindfulness,
}

enum PromptDepth {
  surface,
  medium,
  deep,
}

// ════════════════════════════════════════════════════════════════════════════
// JOURNAL PROMPT MODEL
// ════════════════════════════════════════════════════════════════════════════

class JournalPrompt {
  final String id;
  final String promptEn;
  final String promptTr;
  final PromptCategory category;
  final PromptDepth depth;

  const JournalPrompt({
    required this.id,
    required this.promptEn,
    required this.promptTr,
    required this.category,
    required this.depth,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'promptEn': promptEn,
        'promptTr': promptTr,
        'category': category.name,
        'depth': depth.name,
      };

  factory JournalPrompt.fromJson(Map<String, dynamic> json) => JournalPrompt(
        id: json['id'] as String,
        promptEn: json['promptEn'] as String,
        promptTr: json['promptTr'] as String,
        category: PromptCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => PromptCategory.selfDiscovery,
        ),
        depth: PromptDepth.values.firstWhere(
          (e) => e.name == json['depth'],
          orElse: () => PromptDepth.medium,
        ),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// JOURNAL PROMPT SERVICE
// ════════════════════════════════════════════════════════════════════════════

class JournalPromptService {
  static const String _completedKey = 'journal_prompts_completed';
  static const String _skippedKey = 'journal_prompts_skipped';
  static const String _recentKey = 'journal_prompts_recent';

  final SharedPreferences _prefs;
  Set<String> _completedIds = {};
  Set<String> _skippedIds = {};
  List<String> _recentIds = [];

  JournalPromptService._(this._prefs) {
    _loadState();
  }

  /// Initialize service with SharedPreferences
  static Future<JournalPromptService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return JournalPromptService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STATE PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadState() {
    final completedJson = _prefs.getString(_completedKey);
    if (completedJson != null) {
      _completedIds = Set<String>.from(jsonDecode(completedJson) as List);
    }

    final skippedJson = _prefs.getString(_skippedKey);
    if (skippedJson != null) {
      _skippedIds = Set<String>.from(jsonDecode(skippedJson) as List);
    }

    final recentJson = _prefs.getString(_recentKey);
    if (recentJson != null) {
      _recentIds = List<String>.from(jsonDecode(recentJson) as List);
    }
  }

  Future<void> _persistCompleted() async {
    await _prefs.setString(
      _completedKey,
      jsonEncode(_completedIds.toList()),
    );
  }

  Future<void> _persistSkipped() async {
    await _prefs.setString(
      _skippedKey,
      jsonEncode(_skippedIds.toList()),
    );
  }

  Future<void> _persistRecent() async {
    await _prefs.setString(
      _recentKey,
      jsonEncode(_recentIds),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DAILY PROMPT - Deterministic per day via date hash
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns a deterministic prompt for today based on date hash.
  JournalPrompt getDailyPrompt() {
    final now = DateTime.now();
    final dateHash = now.year * 10000 + now.month * 100 + now.day;
    final index = dateHash % allPrompts.length;
    return allPrompts[index];
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SMART SELECTION
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns a smart prompt for a given category.
  /// Avoids recently shown prompts, biases toward unused categories.
  JournalPrompt getPromptForCategory(PromptCategory category) {
    final candidates = allPrompts
        .where((p) => p.category == category)
        .where((p) => !_recentIds.contains(p.id))
        .where((p) => !_completedIds.contains(p.id))
        .toList();

    if (candidates.isEmpty) {
      // Fallback: return any prompt from category not recently shown
      final fallback = allPrompts
          .where((p) => p.category == category)
          .where((p) => !_recentIds.contains(p.id))
          .toList();
      if (fallback.isEmpty) {
        // Final fallback: return random from category
        final all = allPrompts.where((p) => p.category == category).toList();
        return all[Random().nextInt(all.length)];
      }
      return fallback[Random().nextInt(fallback.length)];
    }

    final selected = candidates[Random().nextInt(candidates.length)];
    _trackRecent(selected.id);
    return selected;
  }

  void _trackRecent(String id) {
    _recentIds.insert(0, id);
    // Keep only last 20 recent prompts
    if (_recentIds.length > 20) {
      _recentIds = _recentIds.sublist(0, 20);
    }
    _persistRecent();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TRACKING
  // ══════════════════════════════════════════════════════════════════════════

  /// Mark a prompt as completed
  Future<void> markCompleted(String id) async {
    _completedIds.add(id);
    _skippedIds.remove(id);
    await _persistCompleted();
    await _persistSkipped();
  }

  /// Mark a prompt as skipped
  Future<void> markSkipped(String id) async {
    _skippedIds.add(id);
    await _persistSkipped();
  }

  /// Check if a prompt is completed
  bool isCompleted(String id) => _completedIds.contains(id);

  /// Check if a prompt is skipped
  bool isSkipped(String id) => _skippedIds.contains(id);

  /// Get completed prompt count
  int getCompletedCount() => _completedIds.length;

  /// Get completion percentage (0.0 to 1.0)
  double getCompletionPercent() {
    if (allPrompts.isEmpty) return 0.0;
    return _completedIds.length / allPrompts.length;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ══════════════════════════════════════════════════════════════════════════

  /// Get all prompts for a given category
  List<JournalPrompt> getPromptsByCategory(PromptCategory category) {
    return allPrompts.where((p) => p.category == category).toList();
  }

  /// Get all prompts
  List<JournalPrompt> getAllPrompts() => List.unmodifiable(allPrompts);

  // ══════════════════════════════════════════════════════════════════════════
  // REFLECTION PROMPTS (108 deep prompts with follow-up questions)
  // ══════════════════════════════════════════════════════════════════════════

  /// Returns a deterministic reflection prompt for today (from the 108-prompt pool).
  ReflectionPrompt getDailyReflection() {
    final now = DateTime.now();
    final dateHash = now.year * 10000 + now.month * 100 + now.day;
    final index = dateHash % allReflectionPrompts.length;
    return allReflectionPrompts[index];
  }

  /// Returns reflection prompts filtered by focus area.
  List<ReflectionPrompt> getReflectionsByArea(String area) {
    return allReflectionPrompts.where((p) => p.focusArea == area).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 80 CURATED PROMPTS - 10 per category, bilingual EN/TR
  // ══════════════════════════════════════════════════════════════════════════

  static const List<JournalPrompt> allPrompts = [
    // ════════════════════════════════════════════════════════════════
    // SELF-DISCOVERY (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'sd_01',
      promptEn: 'What is one thing you have learned about yourself this week that surprised you?',
      promptTr: 'Bu hafta kendiniz hakkinda sizi sasirtan bir sey ogrendiniz mi?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'sd_02',
      promptEn: 'Reflect on a moment when you felt truly like yourself. What were you doing?',
      promptTr: 'Kendinizi gercekten kendiniz gibi hissettiginiz bir ani dusunun. Ne yapiyordunuz?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'sd_03',
      promptEn: 'What values matter most to you, and how do your daily actions reflect them?',
      promptTr: 'Sizin icin en onemli degerler nelerdir ve gunluk eylemleriniz bunlari nasil yansitiyor?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'sd_04',
      promptEn: 'If you could give advice to your younger self, what would you say?',
      promptTr: 'Genc kendinize bir tavsiye verebilseydiniz ne soylemeniz gerekirdi?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'sd_05',
      promptEn: 'What do you notice about the way you talk to yourself? Is it kind or critical?',
      promptTr: 'Kendinizle konusma sekiliniz hakkinda ne fark ediyorsunuz? Nazik mi, elestirici mi?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'sd_06',
      promptEn: 'Describe three qualities you appreciate about yourself right now.',
      promptTr: 'Su anda kendinizde takdir ettiginiz uc ozelligi tanimlayin.',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'sd_07',
      promptEn: 'Consider a belief you hold strongly. Where did it come from, and does it still serve you?',
      promptTr: 'Guclu bir seilde inandaginiz bir seyi dusunun. Nereden geldi ve hala size hizmet ediyor mu?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'sd_08',
      promptEn: 'What activities make you lose track of time? What do they reveal about you?',
      promptTr: 'Hangi aktiviteler zaman kavramini kaybetmenize neden oluyor? Bunlar sizin hakkinda ne ortaya koyuyor?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'sd_09',
      promptEn: 'When was the last time you stepped outside your comfort zone? How did it feel?',
      promptTr: 'En son ne zaman konfor alaninizin disina ciktiniz? Nasil hissettiniz?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'sd_10',
      promptEn: 'What patterns do you notice repeating in your life? What might they be trying to teach you?',
      promptTr: 'Hayatinizda tekrar eden hangi kaliplari fark ediyorsunuz? Size ne ogretmeye calisiyor olabilirler?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.deep,
    ),

    // ════════════════════════════════════════════════════════════════
    // RELATIONSHIPS (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'rl_01',
      promptEn: 'Think of someone who has positively influenced your life. What did they teach you?',
      promptTr: 'Hayatinizi olumlu etkileyen birini dusunun. Size ne ogretti?',
      category: PromptCategory.relationships,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'rl_02',
      promptEn: 'Reflect on how you handle conflict. What do you notice about your approach?',
      promptTr: 'Catisamalari nasil ele aldiginizi dusunun. Yaklasimiz hakkinda ne fark ediyorsunuz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'rl_03',
      promptEn: 'What does a meaningful connection look like to you? How do you nurture it?',
      promptTr: 'Anlamli bir baglanti sizin icin neye benziyor? Onu nasil besliyorsunuz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'rl_04',
      promptEn: 'Consider a relationship that has changed recently. What have you learned from this shift?',
      promptTr: 'Son zamanlarda degisen bir iliskinizi dusunun. Bu degisimden ne ogrendiniz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'rl_05',
      promptEn: 'What boundaries do you find hardest to set? What makes them challenging?',
      promptTr: 'Hangi sinirlari belirlemek sizin icin en zor? Onlari zorlastiran ne?',
      category: PromptCategory.relationships,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'rl_06',
      promptEn: 'Write about a time someone showed you unexpected kindness. How did it affect you?',
      promptTr: 'Birinin size beklenmedik bir sekilde iyilik gosterdigini yazin. Sizi nasil etkiledi?',
      category: PromptCategory.relationships,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'rl_07',
      promptEn: 'What role do you tend to take in group settings? Does it feel natural or forced?',
      promptTr: 'Grup ortamlarinda hangi rolu ustlenme egiliminde olursunuz? Dogal mi yoksa zoraki mi hissediyorsunuz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'rl_08',
      promptEn: 'Reflect on a conversation that stayed with you. Why do you think it mattered?',
      promptTr: 'Aklinizdan cikamayan bir konusmayi dusunun. Sizce neden onemli?',
      category: PromptCategory.relationships,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'rl_09',
      promptEn: 'What do you wish others understood about you that you rarely express?',
      promptTr: 'Basklarinin sizin hakkinda anlamasini isteyip de nadiren ifade ettiginiz sey ne?',
      category: PromptCategory.relationships,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'rl_10',
      promptEn: 'How do you show love and care to the people closest to you?',
      promptTr: 'Size en yakin insanlara sevgi ve ilginizi nasil gosteriyorsunuz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.surface,
    ),

    // ════════════════════════════════════════════════════════════════
    // GRATITUDE (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'gr_01',
      promptEn: 'Name three small things from today that brought you a moment of peace or joy.',
      promptTr: 'Bugun size bir an huzur veya mutluluk getiren uc kucuk seyi sayisayin.',
      category: PromptCategory.gratitude,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'gr_02',
      promptEn: 'Reflect on a challenge you faced that ultimately helped you grow. What are you thankful for in that experience?',
      promptTr: 'Sonunda buyumenize yardimci olan bir zorlugudinizi dusunun. O deneyimde neye minnettar siniz?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'gr_03',
      promptEn: 'What part of your body or health do you feel grateful for today? Consider what it allows you to do.',
      promptTr: 'Bugun bedeninizin veya sagliginizin hangi kismi icin minnettar hissediyorsunuz? Size ne yapmaniza izin verdigini dusunun.',
      category: PromptCategory.gratitude,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'gr_04',
      promptEn: 'Write about a place that makes you feel safe and grateful. What makes it special?',
      promptTr: 'Sizi guvenli ve minnettar hissettiren bir yeri yazin. Onu ozel kilan ne?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'gr_05',
      promptEn: 'Consider a simple comfort you often take for granted. What would life be like without it?',
      promptTr: 'Genellikle hafife aldiginiz basit bir konforu dusunun. Onsuz hayat nasil olurdu?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'gr_06',
      promptEn: 'Who is someone in your life you have not thanked recently? What would you say to them?',
      promptTr: 'Hayatinizda son zamanlarda tesekkur etmediginiz biri kim? Ona ne soylemeniz gerekirdi?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'gr_07',
      promptEn: 'What skill or ability do you have that you feel thankful for? How did you develop it?',
      promptTr: 'Minnettar oldugunuz bir beceri veya yeteneginiz nedir? Onu nasil gelistirdiniz?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'gr_08',
      promptEn: 'Reflect on a difficult season of your life. What unexpected gifts did it bring?',
      promptTr: 'Hayatinizin zor bir donemini dusunun. Beklenmedik hangi hediyeleri getirdi?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'gr_09',
      promptEn: 'What is one thing about your daily routine that you genuinely enjoy?',
      promptTr: 'Gunluk rutininizde gercekten keyif aldiginiz bir sey nedir?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'gr_10',
      promptEn: 'Think about a memory that always makes you smile. Why does it hold such warmth?',
      promptTr: 'Sizi her zaman gulumseten bir aniyi dusunun. Neden bu kadar sicaklik tasiyor?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.deep,
    ),

    // ════════════════════════════════════════════════════════════════
    // EMOTIONS (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'em_01',
      promptEn: 'What emotion have you felt most strongly today? Where did you notice it in your body?',
      promptTr: 'Bugun en guclu hissettiginiz duygu neydi? Bedeninizde nerede hissettiniz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'em_02',
      promptEn: 'Reflect on a time you suppressed an emotion. What were you afraid might happen if you expressed it?',
      promptTr: 'Bir duyguyu bastirdiginiz bir zamani dusunun. Onu ifade etseydiniz ne olmasindan korkuyordunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'em_03',
      promptEn: 'What does sadness feel like for you? Consider how you typically respond to it.',
      promptTr: 'Uzuntu sizin icin nasil hissettiriyor? Genellikle ona nasil tepki verdiginizi dusunun.',
      category: PromptCategory.emotions,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'em_04',
      promptEn: 'Describe your current emotional state as a weather pattern. What is the forecast?',
      promptTr: 'Mevcut duygusal durumunuzu bir hava durumu olarak tanimlayin. Tahmin nedir?',
      category: PromptCategory.emotions,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'em_05',
      promptEn: 'What triggers your anxiety most often? What do you notice about those situations?',
      promptTr: 'Kayginiizi en sik ne tetikler? Bu durumlar hakkinda ne fark ediyorsunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'em_06',
      promptEn: 'When you feel joy, how does it show up? Do you let yourself fully experience it?',
      promptTr: 'Siz mutluluk hissettiginizde, nasil ortaya cikar? Kendinizi tamamen yasamaniza izin veriyor musunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'em_07',
      promptEn: 'What emotion do you find most difficult to sit with? What would it look like to allow it?',
      promptTr: 'Hangi duyguyla basa cikmak sizin icin en zor? Ona izin vermek nasil gorunurdu?',
      category: PromptCategory.emotions,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'em_08',
      promptEn: 'Consider how your mood has shifted over this past week. What patterns do you notice?',
      promptTr: 'Gecen hafta boyunca ruh halinizin nasil degistigini dusunun. Hangi kaliplari fark ediyorsunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'em_09',
      promptEn: 'Write a letter to an emotion you are currently feeling. What would you like to say to it?',
      promptTr: 'Su anda hissettiginiz bir duyguya bir mektup yazin. Ona ne soylemek isterdiniz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'em_10',
      promptEn: 'What makes you feel calm? List the sensations, places, or people that bring you peace.',
      promptTr: 'Sizi sakin hissettiren nedir? Size huzur getiren duyumlari, yerleri veya insanlari listeleyin.',
      category: PromptCategory.emotions,
      depth: PromptDepth.surface,
    ),

    // ════════════════════════════════════════════════════════════════
    // GOALS (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'go_01',
      promptEn: 'What is one small step you can take today toward something that matters to you?',
      promptTr: 'Bugun sizin icin onemli olan bir seye dogru atabilecegini kucuk bir adim nedir?',
      category: PromptCategory.goals,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'go_02',
      promptEn: 'Reflect on a goal you once achieved. What inner strengths helped you get there?',
      promptTr: 'Bir zamanlar ulastiginiz bir hedefe dusunun. Sizi oraya goturen ic guclerin nelerdi?',
      category: PromptCategory.goals,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'go_03',
      promptEn: 'What dream have you been putting off? What do you notice holding you back?',
      promptTr: 'Hangi hayali erteliyorsunuz? Sizi geri tutan ne oldugunu fark ediyor musunuz?',
      category: PromptCategory.goals,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'go_04',
      promptEn: 'Imagine your ideal day one year from now. Describe it in detail.',
      promptTr: 'Bir yil sonra ideal gununuzu hayal edin. Detayli olarak tanimlayin.',
      category: PromptCategory.goals,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'go_05',
      promptEn: 'What habit would you like to build? What is the smallest version of that habit you could start today?',
      promptTr: 'Hangi aliskanlik olusturmak istersiniz? Bugun baslayabileceginiz en kucuk versiyonu ne olurdu?',
      category: PromptCategory.goals,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'go_06',
      promptEn: 'Consider what success means to you personally, not by others\' standards. How would you define it?',
      promptTr: 'Basarinin sizin icin kisisel olarak ne anlama geldigini dusunun, baskalarina gore degil. Onu nasil tanimlarsiniz?',
      category: PromptCategory.goals,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'go_07',
      promptEn: 'What are you currently learning or want to learn? Why does it call to you?',
      promptTr: 'Su anda ne ogreniyorsunuz veya ne ogrenmek istiyorsunuz? Neden sizi cekiyor?',
      category: PromptCategory.goals,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'go_08',
      promptEn: 'Write about a time you failed at something. What did that experience teach you about perseverance?',
      promptTr: 'Bir seyde basarisiz oldugunuz bir zamani yazin. O deneyim size azim hakkinda ne ogretti?',
      category: PromptCategory.goals,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'go_09',
      promptEn: 'What would you do differently if you knew you could not fail?',
      promptTr: 'Basarisiz olamayacaginizi bilseydiniz neyi farkli yapardini?',
      category: PromptCategory.goals,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'go_10',
      promptEn: 'List three things you accomplished this month, no matter how small.',
      promptTr: 'Bu ay basardiginiz ne kadar kucuk olursa olsun uc seyi listeleyin.',
      category: PromptCategory.goals,
      depth: PromptDepth.surface,
    ),

    // ════════════════════════════════════════════════════════════════
    // HEALING (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'hl_01',
      promptEn: 'What is one thing you need to forgive yourself for? Write it down and consider letting it go.',
      promptTr: 'Kendinizi affetmeniz gereken bir sey nedir? Yazin ve birakmayi dusunun.',
      category: PromptCategory.healing,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'hl_02',
      promptEn: 'Reflect on a wound that has started to heal. What helped the process?',
      promptTr: 'Iyilesmeye baslayan bir yarayi dusunun. Surece ne yardimci oldu?',
      category: PromptCategory.healing,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'hl_03',
      promptEn: 'What does self-care look like for you right now? Is there something you have been neglecting?',
      promptTr: 'Su anda oz bakim sizin icin neye benziyor? Ihmal ettiginiz bir sey var mi?',
      category: PromptCategory.healing,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'hl_04',
      promptEn: 'Consider a painful memory. If you could speak to yourself in that moment, what comfort would you offer?',
      promptTr: 'Aci veren bir aniyi dusunun. O anda kendinizle konusabilseydiniz hangi teselli sunardniz?',
      category: PromptCategory.healing,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'hl_05',
      promptEn: 'What does rest truly mean to you? How often do you allow yourself genuine rest?',
      promptTr: 'Dinlenme sizin icin gercekten ne anlama geliyor? Ne siklikla kendinize gercek dinlenme izni veriyorsunuz?',
      category: PromptCategory.healing,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'hl_06',
      promptEn: 'Write about something heavy you have been carrying. What would it feel like to set it down?',
      promptTr: 'Tasidiginiz agir bir sey hakkinda yazin. Onu birakmak nasil hissettirir?',
      category: PromptCategory.healing,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'hl_07',
      promptEn: 'What is one kind thing you can do for yourself today?',
      promptTr: 'Bugun kendiniz icin yapabileceginiz nazik bir sey nedir?',
      category: PromptCategory.healing,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'hl_08',
      promptEn: 'Reflect on how your body holds stress. Where do you feel tension, and what might it be telling you?',
      promptTr: 'Bedeninizin stresi nasil tuttugunuzu dusunun. Gerilimi nerede hissediyorsunuz ve size ne soyluyor olabilir?',
      category: PromptCategory.healing,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'hl_09',
      promptEn: 'What old story about yourself are you ready to rewrite?',
      promptTr: 'Kendiniz hakkinda yeniden yazmaya hazir oldugunuz eski bir hikaye nedir?',
      category: PromptCategory.healing,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'hl_10',
      promptEn: 'Name one thing that makes you feel safe. How can you bring more of it into your life?',
      promptTr: 'Sizi guvenli hissettiren bir seyi adlandirin. Hayatiniza daha fazlasini nasil katabilirsiniz?',
      category: PromptCategory.healing,
      depth: PromptDepth.surface,
    ),

    // ════════════════════════════════════════════════════════════════
    // CREATIVITY (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'cr_01',
      promptEn: 'If you had an entire day with no obligations, how would you spend it creatively?',
      promptTr: 'Hicbir zorunlulugunuz olmayan bir gununuz olsaydi, yaratici olarak nasil gecirirdiniz?',
      category: PromptCategory.creativity,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'cr_02',
      promptEn: 'What creative pursuit have you always been curious about but never tried?',
      promptTr: 'Her zaman merak ettiginiz ama hic denemediginiz yaratici ugras nedir?',
      category: PromptCategory.creativity,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'cr_03',
      promptEn: 'Reflect on a time when creating something made you feel alive. What was the experience like?',
      promptTr: 'Bir sey yarattiginizda kendinizi canli hissettiginiz bir ani dusunun. Deneyim nasil di?',
      category: PromptCategory.creativity,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'cr_04',
      promptEn: 'Write a short scene about a character who discovers a hidden door. Where does it lead?',
      promptTr: 'Gizli bir kapi kesfeden bir karakter hakkinda kisa bir sahne yazin. Kapi nereye aciliyor?',
      category: PromptCategory.creativity,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'cr_05',
      promptEn: 'What does your inner critic say about your creativity? How might you respond to that voice?',
      promptTr: 'Ic elestirmeniniz yaraticiligini hakkinda ne diyor? Bu sese nasil karsilik verebilirsiniz?',
      category: PromptCategory.creativity,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'cr_06',
      promptEn: 'Describe the world outside your window using all five senses.',
      promptTr: 'Pencerenizinokundaki dunyayi bes duyunuzu kullanarak tanimlayin.',
      category: PromptCategory.creativity,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'cr_07',
      promptEn: 'If your life were a book, what would the current chapter be called?',
      promptTr: 'Hayatiniz bir kitap olsaydi, mevcut bolumun adi ne olurdu?',
      category: PromptCategory.creativity,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'cr_08',
      promptEn: 'Consider what blocks your creative expression. What would it take to move through that block?',
      promptTr: 'Yaratici ifadenizi nelerin engelledligi dusunun. O engeli asmak icin ne gerekir?',
      category: PromptCategory.creativity,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'cr_09',
      promptEn: 'Write about a color that resonates with your mood today. Why this color?',
      promptTr: 'Bugunun ruh halinize uygun bir renk hakkinda yazin. Neden bu renk?',
      category: PromptCategory.creativity,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'cr_10',
      promptEn: 'Imagine you could create anything without limitation. What would you make, and who would it be for?',
      promptTr: 'Hicbir sinirla olmadan herhangi bir sey yaratabilecegini hayal edin. Ne yapardiniz ve kimin icin olurdu?',
      category: PromptCategory.creativity,
      depth: PromptDepth.deep,
    ),

    // ════════════════════════════════════════════════════════════════
    // MINDFULNESS (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'mf_01',
      promptEn: 'Pause and take three deep breaths. What do you notice in your body right now?',
      promptTr: 'Durun ve uc derin nefes alin. Su anda bedeninizde ne fark ediyorsunuz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'mf_02',
      promptEn: 'Reflect on a moment today when you were fully present. What made that possible?',
      promptTr: 'Bugun tamamen su anda oldugunuz bir ani dusunun. Bunu ne mumkun kildi?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'mf_03',
      promptEn: 'What thoughts keep circling in your mind? Can you observe them without judgment?',
      promptTr: 'Hangi dusunceler zihninizde donup duruyor? Onlari yargilamadan gozlemleyebilir misiniz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'mf_04',
      promptEn: 'Describe the sounds you can hear right now. Which ones are soothing?',
      promptTr: 'Su anda duyabildiginiz sesleri tanimlayin. Hangileri rahatlatici?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'mf_05',
      promptEn: 'What does it feel like when your mind is quiet? When was the last time you experienced that?',
      promptTr: 'Zihniniz sessiz oldugunda nasil hissediyorsunuz? Bunu en son ne zaman yasadiniz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'mf_06',
      promptEn: 'Consider one thing you did today on autopilot. What would it be like to do it mindfully?',
      promptTr: 'Bugun otomatik pilotta yaptiginiz bir seyi dusunun. Onu bilinli olarak yapmak nasil olurdu?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'mf_07',
      promptEn: 'What are you holding onto that no longer serves you? Can you notice it and breathe?',
      promptTr: 'Artik size hizmet etmeyen neye tutunuyorsunuz? Fark edip nefes alabilir misiniz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'mf_08',
      promptEn: 'Write about something you see every day but rarely truly look at. Describe it in detail.',
      promptTr: 'Her gun gordugunuz ama nadiren gercekten baktiginiz bir sey hakkinda yazin. Detayli tanimlayin.',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'mf_09',
      promptEn: 'Reflect on how you transition between activities. Do you rush, or do you allow a pause?',
      promptTr: 'Aktiviteler arasinda nasil gecis yaptiginizi dusunun. Acele mi ediyorsunuz, yoksa bir duraklama izni veriyor musunuz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'mf_10',
      promptEn: 'What would your day look like if you approached every task with curiosity instead of urgency?',
      promptTr: 'Her goreve acelecilik yerine merakla yaklassaydiniz gununuz nasil gorunurdu?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.deep,
    ),
  ];
}
