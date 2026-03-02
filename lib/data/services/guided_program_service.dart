// ════════════════════════════════════════════════════════════════════════════
// GUIDED PROGRAM SERVICE - InnerCycles Structured Reflection Programs
// ════════════════════════════════════════════════════════════════════════════
// 7-day and 21-day structured programs with daily prompts.
// Free: 1 program at a time. Premium: all programs + completion badges.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_providers.dart';

/// A single day's prompt in a program
class ProgramDay {
  final int dayNumber;
  final String titleEn;
  final String titleTr;
  final String promptEn;
  final String promptTr;

  const ProgramDay({
    required this.dayNumber,
    required this.titleEn,
    required this.titleTr,
    required this.promptEn,
    required this.promptTr,
  });

  String localizedTitle(AppLanguage language) =>
      language == AppLanguage.en ? titleEn : titleTr;

  String localizedPrompt(AppLanguage language) =>
      language == AppLanguage.en ? promptEn : promptTr;
}

/// A guided reflection program
class GuidedProgram {
  final String id;
  final String titleEn;
  final String titleTr;
  final String descriptionEn;
  final String descriptionTr;
  final String emoji;
  final int durationDays;
  final List<ProgramDay> days;
  final bool isPremium;

  const GuidedProgram({
    required this.id,
    required this.titleEn,
    required this.titleTr,
    required this.descriptionEn,
    required this.descriptionTr,
    required this.emoji,
    required this.durationDays,
    required this.days,
    this.isPremium = false,
  });

  String localizedTitle(AppLanguage language) =>
      language == AppLanguage.en ? titleEn : titleTr;

  String localizedDescription(AppLanguage language) =>
      language == AppLanguage.en ? descriptionEn : descriptionTr;
}

/// User's progress in a program
class ProgramProgress {
  final String programId;
  final DateTime startedAt;
  final Set<int> completedDays; // day numbers
  final Map<int, String> reflections; // dayNumber -> reflection text
  final bool isCompleted;

  ProgramProgress({
    required this.programId,
    required this.startedAt,
    required this.completedDays,
    this.reflections = const {},
    this.isCompleted = false,
  });

  int get currentDay {
    final daysSinceStart = DateTime.now().difference(startedAt).inDays + 1;
    return daysSinceStart;
  }

  Map<String, dynamic> toJson() => {
    'programId': programId,
    'startedAt': startedAt.toIso8601String(),
    'completedDays': completedDays.toList(),
    'reflections': reflections.map((k, v) => MapEntry(k.toString(), v)),
    'isCompleted': isCompleted,
  };

  factory ProgramProgress.fromJson(Map<String, dynamic> json) =>
      ProgramProgress(
        programId: json['programId'] as String? ?? '',
        startedAt:
            DateTime.tryParse(json['startedAt']?.toString() ?? '') ??
            DateTime.now(),
        completedDays: (json['completedDays'] as List<dynamic>? ?? [])
            .whereType<int>()
            .toSet(),
        reflections: json['reflections'] is Map
            ? (json['reflections'] as Map<String, dynamic>).map(
                (k, v) => MapEntry(int.tryParse(k) ?? 0, v as String? ?? ''),
              )
            : {},
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}

class GuidedProgramService {
  static const String _progressKey = 'inner_cycles_program_progress';
  static const String _completedKey = 'inner_cycles_completed_programs';

  final SharedPreferences _prefs;
  Map<String, ProgramProgress> _activePrograms = {};
  Set<String> _completedProgramIds = {};

  GuidedProgramService._(this._prefs) {
    _loadProgress();
    _loadCompletedPrograms();
  }

  static Future<GuidedProgramService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return GuidedProgramService._(prefs);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROGRAMS CATALOG
  // ══════════════════════════════════════════════════════════════════════════

  static const List<GuidedProgram> allPrograms = [
    _energyDiscovery,
    _decisionClarity,
    _socialMapping,
    _dreamAwareness,
    _freshStart,
  ];

  List<GuidedProgram> getAvailablePrograms({bool isPremium = false}) {
    if (isPremium) return allPrograms;
    return allPrograms.where((p) => !p.isPremium).toList();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROGRESS MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════

  /// Start a new program
  Future<ProgramProgress> startProgram(String programId) async {
    final progress = ProgramProgress(
      programId: programId,
      startedAt: DateTime.now(),
      completedDays: {},
    );
    _activePrograms[programId] = progress;
    await _persistProgress();
    return progress;
  }

  /// Complete a day in a program with optional reflection text
  Future<void> completeDay(
    String programId,
    int dayNumber, {
    String? reflection,
  }) async {
    final progress = _activePrograms[programId];
    if (progress == null) return;

    progress.completedDays.add(dayNumber);

    // Save reflection if provided
    final updatedReflections = Map<int, String>.from(progress.reflections);
    if (reflection != null && reflection.trim().isNotEmpty) {
      updatedReflections[dayNumber] = reflection.trim();
    }

    // Check if program is fully completed
    final program = allPrograms.firstWhere(
      (p) => p.id == programId,
      orElse: () => allPrograms.first,
    );

    if (progress.completedDays.length >= program.durationDays) {
      _activePrograms[programId] = ProgramProgress(
        programId: programId,
        startedAt: progress.startedAt,
        completedDays: progress.completedDays,
        reflections: updatedReflections,
        isCompleted: true,
      );
      _completedProgramIds.add(programId);
      await _persistCompletedPrograms();
    } else {
      _activePrograms[programId] = ProgramProgress(
        programId: programId,
        startedAt: progress.startedAt,
        completedDays: progress.completedDays,
        reflections: updatedReflections,
      );
    }

    await _persistProgress();
  }

  /// Get reflection for a specific day
  String? getReflection(String programId, int dayNumber) {
    return _activePrograms[programId]?.reflections[dayNumber];
  }

  /// Get active progress for a program
  ProgramProgress? getProgress(String programId) {
    return _activePrograms[programId];
  }

  /// Get the first non-completed active progress (for home feed card)
  ProgramProgress? getActiveProgress() {
    for (final p in _activePrograms.values) {
      if (!p.isCompleted) return p;
    }
    return null;
  }

  /// Look up a program by id from the catalog
  GuidedProgram? getProgram(String programId) {
    for (final p in allPrograms) {
      if (p.id == programId) return p;
    }
    return null;
  }

  /// Check if a program has been completed
  bool isProgramCompleted(String programId) {
    return _completedProgramIds.contains(programId);
  }

  /// Get today's prompt for an active program
  ProgramDay? getTodayPrompt(String programId) {
    final progress = _activePrograms[programId];
    if (progress == null || progress.isCompleted) return null;

    final program = allPrograms.firstWhere(
      (p) => p.id == programId,
      orElse: () => allPrograms.first,
    );

    final currentDay = progress.currentDay;
    if (currentDay > program.durationDays) return null;

    return program.days.firstWhere(
      (d) => d.dayNumber == currentDay,
      orElse: () => program.days.last,
    );
  }

  /// Get count of active programs
  int get activeProgramCount =>
      _activePrograms.values.where((p) => !p.isCompleted).length;

  /// Get count of completed programs
  int get completedProgramCount => _completedProgramIds.length;

  /// Abandon a program
  Future<void> abandonProgram(String programId) async {
    _activePrograms.remove(programId);
    await _persistProgress();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ══════════════════════════════════════════════════════════════════════════

  void _loadProgress() {
    final jsonString = _prefs.getString(_progressKey);
    if (jsonString != null) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _activePrograms = jsonMap.map(
          (k, v) => MapEntry(k, ProgramProgress.fromJson(v)),
        );
      } catch (_) {
        _activePrograms = {};
      }
    }
  }

  Future<void> _persistProgress() async {
    final jsonMap = _activePrograms.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs.setString(_progressKey, json.encode(jsonMap));
  }

  void _loadCompletedPrograms() {
    final jsonString = _prefs.getString(_completedKey);
    if (jsonString != null) {
      try {
        final List<dynamic> list = json.decode(jsonString);
        _completedProgramIds = list.whereType<String>().toSet();
      } catch (_) {
        _completedProgramIds = {};
      }
    }
  }

  Future<void> _persistCompletedPrograms() async {
    await _prefs.setString(
      _completedKey,
      json.encode(_completedProgramIds.toList()),
    );
  }

  Future<void> clearAll() async {
    _activePrograms.clear();
    _completedProgramIds.clear();
    await _prefs.remove(_progressKey);
    await _prefs.remove(_completedKey);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PROGRAM DEFINITIONS
  // ══════════════════════════════════════════════════════════════════════════

  static const _energyDiscovery = GuidedProgram(
    id: 'energy_discovery',
    titleEn: 'Energy Discovery',
    titleTr: 'Enerji Keşfi',
    descriptionEn: 'Understand your energy patterns over 7 days',
    descriptionTr: '7 günde enerji kalıplarını anla',
    emoji: '⚡',
    durationDays: 7,
    days: [
      ProgramDay(
        dayNumber: 1,
        titleEn: 'Baseline',
        titleTr: 'Başlangıç',
        promptEn:
            'Rate your energy right now on 1-5. What time of day feels most energizing?',
        promptTr:
            'Enerjini 1-5 arasında puanla. Günün hangi saati en enerjik hissettiriyor?',
      ),
      ProgramDay(
        dayNumber: 2,
        titleEn: 'Morning Check',
        titleTr: 'Sabah Kontrolü',
        promptEn: 'How did you wake up today? What was your first thought?',
        promptTr: 'Bugün nasıl uyandın? İlk düşüncen neydi?',
      ),
      ProgramDay(
        dayNumber: 3,
        titleEn: 'Energy Drains',
        titleTr: 'Enerji Kayıpları',
        promptEn: 'What drained your energy today? Notice any patterns.',
        promptTr: 'Bugün enerjini ne tüketti? Kalıpları fark et.',
      ),
      ProgramDay(
        dayNumber: 4,
        titleEn: 'Energy Sources',
        titleTr: 'Enerji Kaynakları',
        promptEn: 'What gave you energy today? What activities lift you up?',
        promptTr:
            'Bugün sana ne enerji verdi? Hangi aktiviteler seni yükseltiyor?',
      ),
      ProgramDay(
        dayNumber: 5,
        titleEn: 'Mid-Week Review',
        titleTr: 'Hafta Ortası Gözden Geçirme',
        promptEn:
            'Compare your energy levels across the week. Notice any shifts.',
        promptTr:
            'Hafta boyunca enerji seviyelerini karşılaştır. Değişimleri fark et.',
      ),
      ProgramDay(
        dayNumber: 6,
        titleEn: 'Physical Connection',
        titleTr: 'Fiziksel Bağlantı',
        promptEn: 'How does your body feel today? What does it need?',
        promptTr: 'Bugün vücudun nasıl hissediyor? Neye ihtiyacı var?',
      ),
      ProgramDay(
        dayNumber: 7,
        titleEn: 'Integration',
        titleTr: 'Bütünleştirme',
        promptEn:
            'What did you learn about your energy this week? What will you carry forward?',
        promptTr:
            'Bu hafta enerjin hakkında ne öğrendin? Neyi ileriye taşıyacaksın?',
      ),
    ],
  );

  static const _decisionClarity = GuidedProgram(
    id: 'decision_clarity',
    titleEn: 'Decision Clarity',
    titleTr: 'Karar Netliği',
    descriptionEn: 'Build confidence in your decision-making over 7 days',
    descriptionTr: '7 günde karar verme güvenini oluştur',
    emoji: '🧭',
    durationDays: 7,
    isPremium: true,
    days: [
      ProgramDay(
        dayNumber: 1,
        titleEn: 'Current Decisions',
        titleTr: 'Mevcut Kararlar',
        promptEn:
            'What decisions are you facing right now? List them without judgment.',
        promptTr:
            'Şu anda hangi kararlarla karşı karşıyasın? Yargılamadan listele.',
      ),
      ProgramDay(
        dayNumber: 2,
        titleEn: 'Past Wins',
        titleTr: 'Geçmiş Başarılar',
        promptEn: 'Recall a decision you are proud of. What guided you?',
        promptTr: 'Gurur duyduğun bir kararı hatırla. Seni ne yönlendirdi?',
      ),
      ProgramDay(
        dayNumber: 3,
        titleEn: 'Values Check',
        titleTr: 'Değerler Kontrolü',
        promptEn:
            'What are your top 3 values? How do they influence your choices?',
        promptTr: 'En önemli 3 değerin nedir? Seçimlerini nasıl etkiliyor?',
      ),
      ProgramDay(
        dayNumber: 4,
        titleEn: 'Fear vs. Wisdom',
        titleTr: 'Korku vs. Bilgelik',
        promptEn:
            'Is fear driving any of your current decisions? How can you tell?',
        promptTr:
            'Mevcut kararlarından herhangi birini korku mu yönlendiriyor? Nasıl anlarsın?',
      ),
      ProgramDay(
        dayNumber: 5,
        titleEn: 'Body Compass',
        titleTr: 'Beden Pusulası',
        promptEn: 'Think about a choice. Where do you feel it in your body?',
        promptTr: 'Bir seçim hakkında düşün. Vücudunda nerede hissediyorsun?',
      ),
      ProgramDay(
        dayNumber: 6,
        titleEn: 'Advice Column',
        titleTr: 'Tavsiye Köşesi',
        promptEn: 'What advice would you give a friend facing your situation?',
        promptTr: 'Senin durumundaki bir arkadaşına ne tavsiye ederdin?',
      ),
      ProgramDay(
        dayNumber: 7,
        titleEn: 'Decision Map',
        titleTr: 'Karar Haritası',
        promptEn:
            'Choose one decision. Write down the best and worst outcomes. What feels right?',
        promptTr:
            'Bir karar seç. En iyi ve en kötü sonuçları yaz. Ne doğru hissettiriyor?',
      ),
    ],
  );

  static const _socialMapping = GuidedProgram(
    id: 'social_mapping',
    titleEn: 'Social Mapping',
    titleTr: 'Sosyal Haritalama',
    descriptionEn: 'Understand your social patterns over 7 days',
    descriptionTr: '7 günde sosyal kalıplarını anla',
    emoji: '🤝',
    durationDays: 7,
    isPremium: true,
    days: [
      ProgramDay(
        dayNumber: 1,
        titleEn: 'Social Inventory',
        titleTr: 'Sosyal Envanter',
        promptEn:
            'Who did you interact with today? How did each interaction feel?',
        promptTr:
            'Bugün kimlerle etkileşimde bulundun? Her etkileşim nasıl hissettirdi?',
      ),
      ProgramDay(
        dayNumber: 2,
        titleEn: 'Energy Givers',
        titleTr: 'Enerji Verenler',
        promptEn: 'Which people energize you? What is it about them?',
        promptTr: 'Hangi insanlar sana enerji veriyor? Onlar hakkında ne var?',
      ),
      ProgramDay(
        dayNumber: 3,
        titleEn: 'Boundaries',
        titleTr: 'Sınırlar',
        promptEn:
            'Where do you need stronger boundaries? What would that look like?',
        promptTr:
            'Nerede daha güçlü sınırlara ihtiyacın var? Bu nasıl görünürdü?',
      ),
      ProgramDay(
        dayNumber: 4,
        titleEn: 'Alone Time',
        titleTr: 'Yalnız Zaman',
        promptEn: 'How much alone time do you need? Are you getting enough?',
        promptTr:
            'Ne kadar yalnız zamana ihtiyacın var? Yeterince alıyor musun?',
      ),
      ProgramDay(
        dayNumber: 5,
        titleEn: 'Connection Quality',
        titleTr: 'Bağlantı Kalitesi',
        promptEn:
            'Rate the depth of your connections this week. Surface vs. meaningful.',
        promptTr:
            'Bu haftaki bağlantılarının derinliğini puanla. Yüzeysel vs. anlamlı.',
      ),
      ProgramDay(
        dayNumber: 6,
        titleEn: 'Communication',
        titleTr: 'İletişim',
        promptEn:
            'Is there something unsaid? What would you say if you felt safe?',
        promptTr:
            'Söylenmemiş bir şey var mı? Güvende hissetseydin ne söylerdin?',
      ),
      ProgramDay(
        dayNumber: 7,
        titleEn: 'Social Map',
        titleTr: 'Sosyal Harita',
        promptEn:
            'Draw a mental map of your relationships. Who is closest? Who do you want closer?',
        promptTr:
            'İlişkilerinin zihinsel haritasını çiz. Kim en yakın? Kimi daha yakın istiyorsun?',
      ),
    ],
  );

  static const _dreamAwareness = GuidedProgram(
    id: 'dream_awareness',
    titleEn: 'Dream Awareness',
    titleTr: 'Rüya Farkındalığı',
    descriptionEn: 'Develop deep dream recall and insight over 21 days',
    descriptionTr: '21 günde derin rüya hatırlama ve içgörü geliştir',
    emoji: '🌙',
    durationDays: 21,
    isPremium: true,
    days: [
      // Week 1: Building Recall
      ProgramDay(
        dayNumber: 1,
        titleEn: 'Dream Intention',
        titleTr: 'Rüya Niyeti',
        promptEn:
            'Before bed tonight, set an intention to remember your dreams. Write it down. Place a notebook by your bed.',
        promptTr:
            'Bu gece yatmadan önce rüyalarını hatırlama niyeti koy. Yaz. Yatağının yanına defter koy.',
      ),
      ProgramDay(
        dayNumber: 2,
        titleEn: 'First Fragments',
        titleTr: 'İlk Parçalar',
        promptEn:
            'What do you remember from last night? Even fragments count. Write immediately upon waking.',
        promptTr:
            'Dün geceden ne hatırlıyorsun? Parçalar bile sayılır. Uyandığında hemen yaz.',
      ),
      ProgramDay(
        dayNumber: 3,
        titleEn: 'Sensory Details',
        titleTr: 'Duyusal Detaylar',
        promptEn:
            'Focus on colors, sounds, or textures in your dream. What sensory details stand out?',
        promptTr:
            'Rüyandaki renklere, seslere veya dokulara odaklan. Hangi duyusal detaylar öne çıkıyor?',
      ),
      ProgramDay(
        dayNumber: 4,
        titleEn: 'Emotions in Dreams',
        titleTr: 'Rüyalardaki Duygular',
        promptEn:
            'Focus on how you felt in your dream, not just what happened. Name the dominant emotion.',
        promptTr:
            'Rüyanda ne olduğuna değil, nasıl hissettiğine odaklan. Baskın duyguyu adlandır.',
      ),
      ProgramDay(
        dayNumber: 5,
        titleEn: 'Dream Characters',
        titleTr: 'Rüya Karakterleri',
        promptEn:
            'Who appeared in your dreams this week? What role did they play? Do they represent a part of you?',
        promptTr:
            'Bu hafta rüyalarında kim belirdi? Hangi rolü oynadılar? Seni temsil ediyorlar mı?',
      ),
      ProgramDay(
        dayNumber: 6,
        titleEn: 'Dream Settings',
        titleTr: 'Rüya Mekanları',
        promptEn:
            'Where did your dreams take place? Familiar or unfamiliar? What does the setting suggest?',
        promptTr:
            'Rüyaların nerede gerçekleşti? Tanıdık mı yabancı mı? Mekan ne öneriyor?',
      ),
      ProgramDay(
        dayNumber: 7,
        titleEn: 'Week 1 Review',
        titleTr: 'Hafta 1 Gözden Geçirme',
        promptEn:
            'Review your dream notes. Has your recall improved? What patterns do you notice?',
        promptTr:
            'Rüya notlarını gözden geçir. Hatırlaman gelişti mi? Hangi kalıpları fark ediyorsun?',
      ),
      // Week 2: Deepening Understanding
      ProgramDay(
        dayNumber: 8,
        titleEn: 'Recurring Themes',
        titleTr: 'Tekrarlayan Temalar',
        promptEn:
            'Do you have recurring dream themes? What might they reflect about your waking concerns?',
        promptTr:
            'Tekrarlayan rüya temaların var mı? Uyanık hayatındaki kaygılar hakkında ne yansıtabilirler?',
      ),
      ProgramDay(
        dayNumber: 9,
        titleEn: 'Dream Symbols',
        titleTr: 'Rüya Sembolleri',
        promptEn:
            'What symbols appeared in your recent dreams? Write what each one means to you personally.',
        promptTr:
            'Son rüyalarında hangi semboller belirdi? Her birinin senin için kişisel olarak ne anlama geldiğini yaz.',
      ),
      ProgramDay(
        dayNumber: 10,
        titleEn: 'Day-Dream Connection',
        titleTr: 'Gün-Rüya Bağlantısı',
        promptEn:
            'Can you connect any dream to something from your waking life? Look for emotional parallels.',
        promptTr:
            'Herhangi bir rüyayı uyanık hayatından bir şeyle bağlantılayabilir misin? Duygusal paralellikleri ara.',
      ),
      ProgramDay(
        dayNumber: 11,
        titleEn: 'Dream Dialogue',
        titleTr: 'Rüya Diyaloğu',
        promptEn:
            'Choose a dream character or symbol. Write a short dialogue with it. What does it want to tell you?',
        promptTr:
            'Bir rüya karakteri veya sembol seç. Onunla kısa bir diyalog yaz. Sana ne söylemek istiyor?',
      ),
      ProgramDay(
        dayNumber: 12,
        titleEn: 'Nighttime Emotions',
        titleTr: 'Gece Duyguları',
        promptEn:
            'What emotion did you wake up with today? Can you trace it back to a dream moment?',
        promptTr:
            'Bugün hangi duyguyla uyandın? Onu bir rüya anına kadar izleyebilir misin?',
      ),
      ProgramDay(
        dayNumber: 13,
        titleEn: 'Dream vs. Reality',
        titleTr: 'Rüya vs. Gerçeklik',
        promptEn:
            'What do your dreams show you that your waking mind avoids? Reflect on any uncomfortable truths.',
        promptTr:
            'Rüyaların, uyanık zihninin kaçındığı ne gösteriyor? Rahatsız edici gerçekler üzerine düşün.',
      ),
      ProgramDay(
        dayNumber: 14,
        titleEn: 'Week 2 Review',
        titleTr: 'Hafta 2 Gözden Geçirme',
        promptEn:
            'Halfway through. Compare your dream life to your waking life. What themes overlap?',
        promptTr:
            'Yarı yoldasın. Rüya hayatını uyanık hayatınla karşılaştır. Hangi temalar örtüşüyor?',
      ),
      // Week 3: Integration
      ProgramDay(
        dayNumber: 15,
        titleEn: 'Sleep Environment',
        titleTr: 'Uyku Ortamı',
        promptEn:
            'How does your sleep environment affect your dreams? Notice temperature, light, sound.',
        promptTr:
            'Uyku ortamın rüyalarını nasıl etkiliyor? Sıcaklık, ışık, ses fark et.',
      ),
      ProgramDay(
        dayNumber: 16,
        titleEn: 'Pre-Sleep Ritual',
        titleTr: 'Uyku Öncesi Ritüeli',
        promptEn:
            'What you do before sleep tends to shape your dreams. Design a calming pre-sleep ritual tonight.',
        promptTr:
            'Uyumadan önce yaptığın şey rüyalarını şekillendirme eğilimindedir. Bu gece sakinleştirici bir uyku öncesi ritüeli tasarla.',
      ),
      ProgramDay(
        dayNumber: 17,
        titleEn: 'Dream Wisdom',
        titleTr: 'Rüya Bilgeliği',
        promptEn:
            'What is one insight your dreams have offered you during this program? How could you honor it?',
        promptTr:
            'Bu program sırasında rüyaların sana sunduğu bir içgörü nedir? Onu nasıl onurlandırabilirsin?',
      ),
      ProgramDay(
        dayNumber: 18,
        titleEn: 'Waking Dreams',
        titleTr: 'Uyanık Rüyalar',
        promptEn:
            'Notice moments of daydreaming today. What do your waking dreams tell you about your desires?',
        promptTr:
            'Bugün hayal kurma anlarını fark et. Uyanık rüyaların arzuların hakkında ne söylüyor?',
      ),
      ProgramDay(
        dayNumber: 19,
        titleEn: 'Dream Letter',
        titleTr: 'Rüya Mektubu',
        promptEn:
            'Write a letter to your dream self. Thank it for the messages. Ask one question you want answered.',
        promptTr:
            'Rüya benliğine bir mektup yaz. Mesajları için teşekkür et. Cevaplanmasını istediğin bir soru sor.',
      ),
      ProgramDay(
        dayNumber: 20,
        titleEn: 'Dream & Body',
        titleTr: 'Rüya & Beden',
        promptEn:
            'How does your body feel after vivid dreams vs. dreamless sleep? Notice the physical connection.',
        promptTr:
            'Canlı rüyalardan sonra bedenin nasıl hissediyor vs. rüyasız uyku? Fiziksel bağlantıyı fark et.',
      ),
      ProgramDay(
        dayNumber: 21,
        titleEn: 'Integration',
        titleTr: 'Bütünleştirme',
        promptEn:
            'Review your 21-day dream log. What 3 discoveries stand out? How will you continue listening to your dreams?',
        promptTr:
            '21 günlük rüya kaydını gözden geçir. Hangi 3 keşif öne çıkıyor? Rüyalarını dinlemeye nasıl devam edeceksin?',
      ),
    ],
  );

  static const _freshStart = GuidedProgram(
    id: 'fresh_start',
    titleEn: 'Fresh Start',
    titleTr: 'Yeni Başlangıç',
    descriptionEn: 'A 7-day reset to reconnect with yourself',
    descriptionTr: 'Kendinle yeniden bağlantı kurmak için 7 günlük sıfırlama',
    emoji: '🌱',
    durationDays: 7,
    days: [
      ProgramDay(
        dayNumber: 1,
        titleEn: 'Where You Are',
        titleTr: 'Neredesin',
        promptEn:
            'Honestly assess where you are right now. No judgment, just truth. Rate your well-being 1-10.',
        promptTr:
            'Şu an nerede olduğunu dürüstçe değerlendir. Yargılama yok, sadece gerçek. İyiliğini 1-10 puanla.',
      ),
      ProgramDay(
        dayNumber: 2,
        titleEn: 'What to Release',
        titleTr: 'Ne Bırakacaksın',
        promptEn:
            'What habits, thoughts, or patterns no longer serve you? Name three things you are ready to let go of.',
        promptTr:
            'Hangi alışkanlıklar, düşünceler veya kalıplar artık sana hizmet etmiyor? Bırakmaya hazır olduğun üç şeyi adlandır.',
      ),
      ProgramDay(
        dayNumber: 3,
        titleEn: 'Core Values',
        titleTr: 'Temel Değerler',
        promptEn:
            'Define 3 values that will guide your fresh start. How do they show up in your daily life?',
        promptTr:
            'Yeni başlangıcına rehberlik edecek 3 değer belirle. Günlük hayatında nasıl ortaya çıkıyorlar?',
      ),
      ProgramDay(
        dayNumber: 4,
        titleEn: 'Morning Ritual',
        titleTr: 'Sabah Ritüeli',
        promptEn:
            'Design your ideal morning routine. Try it tomorrow. Keep it simple — 3 steps maximum.',
        promptTr:
            'İdeal sabah rutinini tasarla. Yarın dene. Basit tut — en fazla 3 adım.',
      ),
      ProgramDay(
        dayNumber: 5,
        titleEn: 'Gratitude Anchor',
        titleTr: 'Şükran Çapası',
        promptEn:
            'List 5 things you are grateful for. Feel each one. Notice how gratitude shifts your state.',
        promptTr:
            '5 şükran maddesi listele. Her birini hisset. Şükranın durumunu nasıl değiştirdiğini fark et.',
      ),
      ProgramDay(
        dayNumber: 6,
        titleEn: 'Body Listen',
        titleTr: 'Beden Dinle',
        promptEn:
            'Scan your body from head to toe. What is it telling you? What does it need more of?',
        promptTr:
            'Vücudunu tepeden tırnağa tara. Sana ne söylüyor? Neye daha fazla ihtiyacı var?',
      ),
      ProgramDay(
        dayNumber: 7,
        titleEn: 'Integration',
        titleTr: 'Bütünleştirme',
        promptEn:
            'Review your 7-day progress. What one habit will you keep? What is your intention going forward?',
        promptTr:
            '7 günlük sürecini gözden geçir. Hangi alışkanlığı koruyacaksın? İleriye dönük niyetin ne?',
      ),
    ],
  );
}
