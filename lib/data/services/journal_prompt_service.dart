// ════════════════════════════════════════════════════════════════════════════
// JOURNAL PROMPT SERVICE - Curated Journaling Prompts Engine
// ════════════════════════════════════════════════════════════════════════════
// Provides 80 bilingual (EN/TR) journaling prompts across 8 categories.
// Deterministic daily prompt, smart selection, and completion tracking.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:async';
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
  recovery,
  creativity,
  mindfulness,
}

enum PromptDepth { surface, medium, deep }

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
    id: json['id'] as String? ?? '',
    promptEn: json['promptEn'] as String? ?? '',
    promptTr: json['promptTr'] as String? ?? '',
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
    try {
      final completedJson = _prefs.getString(_completedKey);
      if (completedJson != null) {
        final completedDecoded = jsonDecode(completedJson);
        if (completedDecoded is List) {
          _completedIds = completedDecoded.whereType<String>().toSet();
        }
      }

      final skippedJson = _prefs.getString(_skippedKey);
      if (skippedJson != null) {
        final skippedDecoded = jsonDecode(skippedJson);
        if (skippedDecoded is List) {
          _skippedIds = skippedDecoded.whereType<String>().toSet();
        }
      }

      final recentJson = _prefs.getString(_recentKey);
      if (recentJson != null) {
        final recentDecoded = jsonDecode(recentJson);
        if (recentDecoded is List) {
          _recentIds = recentDecoded.whereType<String>().toList();
        }
      }
    } catch (_) {
      _completedIds = {};
      _skippedIds = {};
      _recentIds = [];
    }
  }

  Future<void> _persistCompleted() async {
    await _prefs.setString(_completedKey, jsonEncode(_completedIds.toList()));
  }

  Future<void> _persistSkipped() async {
    await _prefs.setString(_skippedKey, jsonEncode(_skippedIds.toList()));
  }

  Future<void> _persistRecent() async {
    await _prefs.setString(_recentKey, jsonEncode(_recentIds));
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
    unawaited(_persistRecent());
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
      promptEn:
          'What is one thing you have learned about yourself this week that surprised you?',
      promptTr:
          'Bu hafta kendiniz hakkında sizi şaşırtan bir şey öğrendiniz mi?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'sd_02',
      promptEn:
          'Reflect on a moment when you felt truly like yourself. What were you doing?',
      promptTr:
          'Kendinizi gerçekten kendiniz gibi hissettiğiniz bir anı düşünün. Ne yapıyordunuz?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'sd_03',
      promptEn:
          'What values matter most to you, and how do your daily actions reflect them?',
      promptTr:
          'Sizin için en önemli değerler nelerdir ve günlük eylemleriniz bunları nasıl yansıtıyor?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'sd_04',
      promptEn:
          'If you could give advice to your younger self, what would you say?',
      promptTr:
          'Genç kendinize bir tavsiye verebilseydiniz ne söylemeniz gerekirdi?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'sd_05',
      promptEn:
          'What do you notice about the way you talk to yourself? Is it kind or critical?',
      promptTr:
          'Kendinizle konuşma şekliniz hakkında ne fark ediyorsunuz? Nazik mi, eleştirici mi?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'sd_06',
      promptEn:
          'Describe three qualities you appreciate about yourself right now.',
      promptTr: 'Şu anda kendinizde takdir ettiğiniz üç özelliği tanımlayın.',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'sd_07',
      promptEn:
          'Consider a belief you hold strongly. Where did it come from, and does it still serve you?',
      promptTr:
          'Güçlü bir şekilde inandığınız bir şeyi düşünün. Nereden geldi ve hala size hizmet ediyor mu?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'sd_08',
      promptEn:
          'What activities make you lose track of time? What do they reveal about you?',
      promptTr:
          'Hangi aktiviteler zaman kavramını kaybetmenize neden oluyor? Bunlar sizin hakkında ne ortaya koyuyor?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'sd_09',
      promptEn:
          'When was the last time you stepped outside your comfort zone? How did it feel?',
      promptTr:
          'En son ne zaman konfor alanınızın dışına çıktınız? Nasıl hissettiniz?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'sd_10',
      promptEn:
          'What patterns do you notice repeating in your life? What might they be trying to teach you?',
      promptTr:
          'Hayatınızda tekrar eden hangi kalıpları fark ediyorsunuz? Size ne öğretmeye çalışıyor olabilirler?',
      category: PromptCategory.selfDiscovery,
      depth: PromptDepth.deep,
    ),

    // ════════════════════════════════════════════════════════════════
    // RELATIONSHIPS (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'rl_01',
      promptEn:
          'Think of someone who has positively influenced your life. What did they teach you?',
      promptTr: 'Hayatınızı olumlu etkileyen birini düşünün. Size ne öğretti?',
      category: PromptCategory.relationships,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'rl_02',
      promptEn:
          'Reflect on how you handle conflict. What do you notice about your approach?',
      promptTr:
          'Çatışmaları nasıl ele aldığınızı düşünün. Yaklaşımınız hakkında ne fark ediyorsunuz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'rl_03',
      promptEn:
          'What does a meaningful connection look like to you? How do you nurture it?',
      promptTr:
          'Anlamlı bir bağlantı sizin için neye benziyor? Onu nasıl besliyorsunuz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'rl_04',
      promptEn:
          'Consider a relationship that has changed recently. What have you learned from this shift?',
      promptTr:
          'Son zamanlarda değişen bir ilişkinizi düşünün. Bu değişimden ne öğrendiniz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'rl_05',
      promptEn:
          'What boundaries do you find hardest to set? What makes them challenging?',
      promptTr:
          'Hangi sınırları belirlemek sizin için en zor? Onları zorlaştıran ne?',
      category: PromptCategory.relationships,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'rl_06',
      promptEn:
          'Write about a time someone showed you unexpected kindness. How did it affect you?',
      promptTr:
          'Birinin size beklenmedik bir şekilde iyilik gösterdiğini yazın. Sizi nasıl etkiledi?',
      category: PromptCategory.relationships,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'rl_07',
      promptEn:
          'What role do you tend to take in group settings? Does it feel natural or forced?',
      promptTr:
          'Grup ortamlarında hangi rolü üstlenme eğiliminde olursunuz? Doğal mı yoksa zoraki mi hissediyorsunuz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'rl_08',
      promptEn:
          'Reflect on a conversation that stayed with you. Why do you think it mattered?',
      promptTr:
          'Aklınızdan çıkamayan bir konuşmayı düşünün. Sizce neden önemli?',
      category: PromptCategory.relationships,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'rl_09',
      promptEn:
          'What do you wish others understood about you that you rarely express?',
      promptTr:
          'Başkalarının sizin hakkında anlamasını isteyip de nadiren ifade ettiğiniz şey ne?',
      category: PromptCategory.relationships,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'rl_10',
      promptEn: 'How do you show love and care to the people closest to you?',
      promptTr:
          'Size en yakın insanlara sevgi ve ilginizi nasıl gösteriyorsunuz?',
      category: PromptCategory.relationships,
      depth: PromptDepth.surface,
    ),

    // ════════════════════════════════════════════════════════════════
    // GRATITUDE (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'gr_01',
      promptEn:
          'Name three small things from today that brought you a moment of peace or joy.',
      promptTr:
          'Bugün size bir an huzur veya mutluluk getiren üç küçük şeyi sayın.',
      category: PromptCategory.gratitude,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'gr_02',
      promptEn:
          'Reflect on a challenge you faced that ultimately helped you grow. What are you thankful for in that experience?',
      promptTr:
          'Sonunda büyümenize yardımcı olan bir zorluğunuzu düşünün. O deneyimde neye minnettarsınız?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'gr_03',
      promptEn:
          'What part of your body or health do you feel grateful for today? Consider what it allows you to do.',
      promptTr:
          'Bugün bedeninizin veya sağlığınızın hangi kısmı için minnettar hissediyorsunuz? Size ne yapmanıza izin verdiğini düşünün.',
      category: PromptCategory.gratitude,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'gr_04',
      promptEn:
          'Write about a place that makes you feel safe and grateful. What makes it special?',
      promptTr:
          'Sizi güvenli ve minnettar hissettiren bir yeri yazın. Onu özel kılan ne?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'gr_05',
      promptEn:
          'Consider a simple comfort you often take for granted. What would life be like without it?',
      promptTr:
          'Genellikle hafife aldığınız basit bir konforu düşünün. Onsuz hayat nasıl olurdu?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'gr_06',
      promptEn:
          'Who is someone in your life you have not thanked recently? What would you say to them?',
      promptTr:
          'Hayatınızda son zamanlarda teşekkür etmediğiniz biri kim? Ona ne söylemeniz gerekirdi?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'gr_07',
      promptEn:
          'What skill or ability do you have that you feel thankful for? How did you develop it?',
      promptTr:
          'Minnettar olduğunuz bir beceri veya yeteneğiniz nedir? Onu nasıl geliştirdiniz?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'gr_08',
      promptEn:
          'Reflect on a difficult season of your life. What unexpected gifts did it bring?',
      promptTr:
          'Hayatınızın zor bir dönemini düşünün. Beklenmedik hangi hediyeleri getirdi?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'gr_09',
      promptEn:
          'What is one thing about your daily routine that you genuinely enjoy?',
      promptTr: 'Günlük rutininizde gerçekten keyif aldığınız bir şey nedir?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'gr_10',
      promptEn:
          'Think about a memory that always makes you smile. Why does it hold such warmth?',
      promptTr:
          'Sizi her zaman gülümseten bir anıyı düşünün. Neden bu kadar sıcaklık taşıyor?',
      category: PromptCategory.gratitude,
      depth: PromptDepth.deep,
    ),

    // ════════════════════════════════════════════════════════════════
    // EMOTIONS (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'em_01',
      promptEn:
          'What emotion have you felt most strongly today? Where did you notice it in your body?',
      promptTr:
          'Bugün en güçlü hissettiğiniz duygu neydi? Bedeninizde nerede hissettiniz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'em_02',
      promptEn:
          'Reflect on a time you suppressed an emotion. What were you afraid might happen if you expressed it?',
      promptTr:
          'Bir duyguyu bastırdığınız bir zamanı düşünün. Onu ifade etseydiniz ne olmasından korkuyordunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'em_03',
      promptEn:
          'What does sadness feel like for you? Consider how you typically respond to it.',
      promptTr:
          'Üzüntü sizin için nasıl hissettiriyor? Genellikle ona nasıl tepki verdiğinizi düşünün.',
      category: PromptCategory.emotions,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'em_04',
      promptEn:
          'Describe your current emotional state as a weather pattern. What do you notice?',
      promptTr:
          'Mevcut duygusal durumunuzu bir hava durumu olarak tanımlayın. Ne fark ediyorsunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'em_05',
      promptEn:
          'What triggers your anxiety most often? What do you notice about those situations?',
      promptTr:
          'Kaygınızı en sık ne tetikler? Bu durumlar hakkında ne fark ediyorsunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'em_06',
      promptEn:
          'When you feel joy, how does it show up? Do you let yourself fully experience it?',
      promptTr:
          'Siz mutluluk hissettiğinizde, nasıl ortaya çıkar? Kendinizi tamamen yaşamanıza izin veriyor musunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'em_07',
      promptEn:
          'What emotion do you find most difficult to sit with? What would it look like to allow it?',
      promptTr:
          'Hangi duyguyla başa çıkmak sizin için en zor? Ona izin vermek nasıl görünürdü?',
      category: PromptCategory.emotions,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'em_08',
      promptEn:
          'Consider how your mood has shifted over this past week. What patterns do you notice?',
      promptTr:
          'Geçen hafta boyunca ruh halinizin nasıl değiştiğini düşünün. Hangi kalıpları fark ediyorsunuz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'em_09',
      promptEn:
          'Write a letter to an emotion you are currently feeling. What would you like to say to it?',
      promptTr:
          'Şu anda hissettiğiniz bir duyguya bir mektup yazın. Ona ne söylemek isterdiniz?',
      category: PromptCategory.emotions,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'em_10',
      promptEn:
          'What makes you feel calm? List the sensations, places, or people that bring you peace.',
      promptTr:
          'Sizi sakin hissettiren nedir? Size huzur getiren duyumları, yerleri veya insanları listeleyin.',
      category: PromptCategory.emotions,
      depth: PromptDepth.surface,
    ),

    // ════════════════════════════════════════════════════════════════
    // GOALS (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'go_01',
      promptEn:
          'What is one small step you can take today toward something that matters to you?',
      promptTr:
          'Bugün sizin için önemli olan bir şeye doğru atabileceğiniz küçük bir adım nedir?',
      category: PromptCategory.goals,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'go_02',
      promptEn:
          'Reflect on a goal you once achieved. What inner strengths helped you get there?',
      promptTr:
          'Bir zamanlar ulaştığınız bir hedefi düşünün. Sizi oraya götüren iç güçleriniz nelerdi?',
      category: PromptCategory.goals,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'go_03',
      promptEn:
          'What dream have you been putting off? What do you notice holding you back?',
      promptTr:
          'Hangi hayali erteliyorsunuz? Sizi geri tutan ne olduğunu fark ediyor musunuz?',
      category: PromptCategory.goals,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'go_04',
      promptEn:
          'Imagine your ideal day one year from now. Describe it in detail.',
      promptTr:
          'Bir yıl sonra ideal gününüzü hayal edin. Detaylı olarak tanımlayın.',
      category: PromptCategory.goals,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'go_05',
      promptEn:
          'What habit would you like to build? What is the smallest version of that habit you could start today?',
      promptTr:
          'Hangi alışkanlık oluşturmak istersiniz? Bugün başlayabileceğiniz en küçük versiyonu ne olurdu?',
      category: PromptCategory.goals,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'go_06',
      promptEn:
          'Consider what success means to you personally, not by others\' standards. How would you define it?',
      promptTr:
          'Başarının sizin için kişisel olarak ne anlama geldiğini düşünün, başkalarına göre değil. Onu nasıl tanımlarsınız?',
      category: PromptCategory.goals,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'go_07',
      promptEn:
          'What are you currently learning or want to learn? Why does it call to you?',
      promptTr:
          'Şu anda ne öğreniyorsunuz veya ne öğrenmek istiyorsunuz? Neden sizi çekiyor?',
      category: PromptCategory.goals,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'go_08',
      promptEn:
          'Write about a time you failed at something. What did that experience teach you about perseverance?',
      promptTr:
          'Bir şeyde başarısız olduğunuz bir zamanı yazın. O deneyim size azim hakkında ne öğretti?',
      category: PromptCategory.goals,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'go_09',
      promptEn: 'What would you do differently if you knew you could not fail?',
      promptTr: 'Başarısız olamayacağınızı bilseydiniz neyi farklı yapardınız?',
      category: PromptCategory.goals,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'go_10',
      promptEn:
          'List three things you accomplished this month, no matter how small.',
      promptTr:
          'Bu ay başardığınız ne kadar küçük olursa olsun üç şeyi listeleyin.',
      category: PromptCategory.goals,
      depth: PromptDepth.surface,
    ),

    // ════════════════════════════════════════════════════════════════
    // RECOVERY (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'hl_01',
      promptEn:
          'What is one thing you need to forgive yourself for? Write it down and consider letting it go.',
      promptTr:
          'Kendinizi affetmeniz gereken bir şey nedir? Yazın ve bırakmayı düşünün.',
      category: PromptCategory.recovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'hl_02',
      promptEn:
          'Reflect on a difficulty that has started to ease. What helped the process?',
      promptTr:
          'İyileşmeye başlayan bir yarayı düşünün. Sürece ne yardımcı oldu?',
      category: PromptCategory.recovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'hl_03',
      promptEn:
          'What does looking after yourself look like right now? Is there something you have been neglecting?',
      promptTr:
          'Şu anda kendinize bakmak sizin için neye benziyor? İhmal ettiğiniz bir şey var mı?',
      category: PromptCategory.recovery,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'hl_04',
      promptEn:
          'Consider a painful memory. If you could speak to yourself in that moment, what comfort would you offer?',
      promptTr:
          'Acı veren bir anıyı düşünün. O anda kendinizle konuşabilseydiniz hangi teselli sunardınız?',
      category: PromptCategory.recovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'hl_05',
      promptEn:
          'What does rest truly mean to you? How often do you allow yourself genuine rest?',
      promptTr:
          'Dinlenme sizin için gerçekten ne anlama geliyor? Ne sıklıkla kendinize gerçek dinlenme izni veriyorsunuz?',
      category: PromptCategory.recovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'hl_06',
      promptEn:
          'Write about something heavy you have been carrying. What would it feel like to set it down?',
      promptTr:
          'Taşıdığınız ağır bir şey hakkında yazın. Onu bırakmak nasıl hissettirir?',
      category: PromptCategory.recovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'hl_07',
      promptEn: 'What is one kind thing you can do for yourself today?',
      promptTr: 'Bugün kendiniz için yapabileceğiniz nazik bir şey nedir?',
      category: PromptCategory.recovery,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'hl_08',
      promptEn:
          'Reflect on how your body holds stress. Where do you feel tension, and what might it be telling you?',
      promptTr:
          'Bedeninizin stresi nasıl tuttuğunu düşünün. Gerilimi nerede hissediyorsunuz ve size ne söylüyor olabilir?',
      category: PromptCategory.recovery,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'hl_09',
      promptEn: 'What old story about yourself are you ready to rewrite?',
      promptTr:
          'Kendiniz hakkında yeniden yazmaya hazır olduğunuz eski bir hikaye nedir?',
      category: PromptCategory.recovery,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'hl_10',
      promptEn:
          'Name one thing that makes you feel safe. How can you bring more of it into your life?',
      promptTr:
          'Sizi güvenli hissettiren bir şeyi adlandırın. Hayatınıza daha fazlasını nasıl katabilirsiniz?',
      category: PromptCategory.recovery,
      depth: PromptDepth.surface,
    ),

    // ════════════════════════════════════════════════════════════════
    // CREATIVITY (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'cr_01',
      promptEn:
          'If you had an entire day with no obligations, how would you spend it creatively?',
      promptTr:
          'Hiçbir zorunluluğunuz olmayan bir gününüz olsaydı, yaratıcı olarak nasıl geçirirdiniz?',
      category: PromptCategory.creativity,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'cr_02',
      promptEn:
          'What creative pursuit have you always been curious about but never tried?',
      promptTr:
          'Her zaman merak ettiğiniz ama hiç denemediğiniz yaratıcı uğraş nedir?',
      category: PromptCategory.creativity,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'cr_03',
      promptEn:
          'Reflect on a time when creating something made you feel alive. What was the experience like?',
      promptTr:
          'Bir şey yarattığınızda kendinizi canlı hissettiğiniz bir anı düşünün. Deneyim nasıldı?',
      category: PromptCategory.creativity,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'cr_04',
      promptEn:
          'Write a short scene about a character who discovers a hidden door. Where does it lead?',
      promptTr:
          'Gizli bir kapı keşfeden bir karakter hakkında kısa bir sahne yazın. Kapı nereye açılıyor?',
      category: PromptCategory.creativity,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'cr_05',
      promptEn:
          'What does your inner critic say about your creativity? How might you respond to that voice?',
      promptTr:
          'İç eleştirmeniniz yaratıcılığınız hakkında ne diyor? Bu sese nasıl karşılık verebilirsiniz?',
      category: PromptCategory.creativity,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'cr_06',
      promptEn: 'Describe the world outside your window using all five senses.',
      promptTr:
          'Pencerenizin dışındaki dünyayı beş duyunuzu kullanarak tanımlayın.',
      category: PromptCategory.creativity,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'cr_07',
      promptEn:
          'If your life were a book, what would the current chapter be called?',
      promptTr: 'Hayatınız bir kitap olsaydı, mevcut bölümün adı ne olurdu?',
      category: PromptCategory.creativity,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'cr_08',
      promptEn:
          'Consider what blocks your creative expression. What would it take to move through that block?',
      promptTr:
          'Yaratıcı ifadenizi nelerin engellediğini düşünün. O engeli aşmak için ne gerekir?',
      category: PromptCategory.creativity,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'cr_09',
      promptEn:
          'Write about a color that resonates with your mood today. Why this color?',
      promptTr:
          'Bugünün ruh halinize uygun bir renk hakkında yazın. Neden bu renk?',
      category: PromptCategory.creativity,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'cr_10',
      promptEn:
          'Imagine you could create anything without limitation. What would you make, and who would it be for?',
      promptTr:
          'Hiçbir sınırlama olmadan herhangi bir şey yaratabileceğinizi hayal edin. Ne yapardınız ve kimin için olurdu?',
      category: PromptCategory.creativity,
      depth: PromptDepth.deep,
    ),

    // ════════════════════════════════════════════════════════════════
    // MINDFULNESS (10)
    // ════════════════════════════════════════════════════════════════
    JournalPrompt(
      id: 'mf_01',
      promptEn:
          'Pause and take three deep breaths. What do you notice in your body right now?',
      promptTr:
          'Durun ve üç derin nefes alın. Şu anda bedeninizde ne fark ediyorsunuz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'mf_02',
      promptEn:
          'Reflect on a moment today when you were fully present. What made that possible?',
      promptTr:
          'Bugün tamamen şu anda olduğunuz bir anı düşünün. Bunu ne mümkün kıldı?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'mf_03',
      promptEn:
          'What thoughts keep circling in your mind? Can you observe them without judgment?',
      promptTr:
          'Hangi düşünceler zihninizde dönüp duruyor? Onları yargılamadan gözlemleyebilir misiniz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'mf_04',
      promptEn:
          'Describe the sounds you can hear right now. Which ones are soothing?',
      promptTr:
          'Şu anda duyabildiğiniz sesleri tanımlayın. Hangileri rahatlatıcı?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'mf_05',
      promptEn:
          'What does it feel like when your mind is quiet? When was the last time you experienced that?',
      promptTr:
          'Zihniniz sessiz olduğunda nasıl hissediyorsunuz? Bunu en son ne zaman yaşadınız?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'mf_06',
      promptEn:
          'Consider one thing you did today on autopilot. What would it be like to do it mindfully?',
      promptTr:
          'Bugün otomatik pilotta yaptığınız bir şeyi düşünün. Onu bilinçli olarak yapmak nasıl olurdu?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'mf_07',
      promptEn:
          'What are you holding onto that no longer serves you? Can you notice it and breathe?',
      promptTr:
          'Artık size hizmet etmeyen neye tutunuyorsunuz? Fark edip nefes alabilir misiniz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.deep,
    ),
    JournalPrompt(
      id: 'mf_08',
      promptEn:
          'Write about something you see every day but rarely truly look at. Describe it in detail.',
      promptTr:
          'Her gün gördüğünüz ama nadiren gerçekten baktığınız bir şey hakkında yazın. Detaylı tanımlayın.',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.surface,
    ),
    JournalPrompt(
      id: 'mf_09',
      promptEn:
          'Reflect on how you transition between activities. Do you rush, or do you allow a pause?',
      promptTr:
          'Aktiviteler arasında nasıl geçiş yaptığınızı düşünün. Acele mi ediyorsunuz, yoksa bir duraklama izni veriyor musunuz?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.medium,
    ),
    JournalPrompt(
      id: 'mf_10',
      promptEn:
          'What would your day look like if you approached every task with curiosity instead of urgency?',
      promptTr:
          'Her göreve acelecilik yerine merakla yaklaşsaydınız gününüz nasıl görünürdü?',
      category: PromptCategory.mindfulness,
      depth: PromptDepth.deep,
    ),
  ];
}
