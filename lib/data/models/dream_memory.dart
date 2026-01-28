/// Dream Memory System - Core data model for AI-powered dream tracking
/// This is the UNIQUE MOAT - no competitor has this feature
/// Enables pattern detection, symbol tracking, and personalized interpretations
library;

/// Individual dream entry
class Dream {
  final String id;
  final String content;
  final DateTime dreamDate;
  final DateTime createdAt;
  final List<String> symbols;
  final String? dominantEmotion;
  final List<String> themes;
  final String? mood;
  final DreamInterpretation? interpretation;
  final bool isSaved;

  Dream({
    required this.id,
    required this.content,
    required this.dreamDate,
    required this.createdAt,
    this.symbols = const [],
    this.dominantEmotion,
    this.themes = const [],
    this.mood,
    this.interpretation,
    this.isSaved = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'dreamDate': dreamDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'symbols': symbols,
    'dominantEmotion': dominantEmotion,
    'themes': themes,
    'mood': mood,
    'interpretation': interpretation?.toJson(),
    'isSaved': isSaved,
  };

  factory Dream.fromJson(Map<String, dynamic> json) => Dream(
    id: json['id'],
    content: json['content'],
    dreamDate: DateTime.parse(json['dreamDate']),
    createdAt: DateTime.parse(json['createdAt']),
    symbols: List<String>.from(json['symbols'] ?? []),
    dominantEmotion: json['dominantEmotion'],
    themes: List<String>.from(json['themes'] ?? []),
    mood: json['mood'],
    interpretation: json['interpretation'] != null
        ? DreamInterpretation.fromJson(json['interpretation'])
        : null,
    isSaved: json['isSaved'] ?? true,
  );

  Dream copyWith({
    String? id,
    String? content,
    DateTime? dreamDate,
    DateTime? createdAt,
    List<String>? symbols,
    String? dominantEmotion,
    List<String>? themes,
    String? mood,
    DreamInterpretation? interpretation,
    bool? isSaved,
  }) => Dream(
    id: id ?? this.id,
    content: content ?? this.content,
    dreamDate: dreamDate ?? this.dreamDate,
    createdAt: createdAt ?? this.createdAt,
    symbols: symbols ?? this.symbols,
    dominantEmotion: dominantEmotion ?? this.dominantEmotion,
    themes: themes ?? this.themes,
    mood: mood ?? this.mood,
    interpretation: interpretation ?? this.interpretation,
    isSaved: isSaved ?? this.isSaved,
  );
}

/// AI-generated dream interpretation with layered content
class DreamInterpretation {
  final InterpretationLayer surfaceLayer;
  final InterpretationLayer emotionalLayer;
  final InterpretationLayer symbolicLayer;
  final InterpretationLayer? patternLayer;
  final InterpretationLayer? guidanceLayer;
  final String? shareText;
  final String? reflectionQuestion;
  final String modelVersion;
  final DateTime createdAt;

  DreamInterpretation({
    required this.surfaceLayer,
    required this.emotionalLayer,
    required this.symbolicLayer,
    this.patternLayer,
    this.guidanceLayer,
    this.shareText,
    this.reflectionQuestion,
    required this.modelVersion,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'surfaceLayer': surfaceLayer.toJson(),
    'emotionalLayer': emotionalLayer.toJson(),
    'symbolicLayer': symbolicLayer.toJson(),
    'patternLayer': patternLayer?.toJson(),
    'guidanceLayer': guidanceLayer?.toJson(),
    'shareText': shareText,
    'reflectionQuestion': reflectionQuestion,
    'modelVersion': modelVersion,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DreamInterpretation.fromJson(Map<String, dynamic> json) =>
      DreamInterpretation(
        surfaceLayer: InterpretationLayer.fromJson(json['surfaceLayer']),
        emotionalLayer: InterpretationLayer.fromJson(json['emotionalLayer']),
        symbolicLayer: InterpretationLayer.fromJson(json['symbolicLayer']),
        patternLayer: json['patternLayer'] != null
            ? InterpretationLayer.fromJson(json['patternLayer'])
            : null,
        guidanceLayer: json['guidanceLayer'] != null
            ? InterpretationLayer.fromJson(json['guidanceLayer'])
            : null,
        shareText: json['shareText'],
        reflectionQuestion: json['reflectionQuestion'],
        modelVersion: json['modelVersion'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}

/// Single interpretation layer (free or premium)
class InterpretationLayer {
  final String title;
  final String? content;
  final String? teaser;
  final bool isLocked;
  final int? connectionCount;

  InterpretationLayer({
    required this.title,
    this.content,
    this.teaser,
    this.isLocked = false,
    this.connectionCount,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'teaser': teaser,
    'isLocked': isLocked,
    'connectionCount': connectionCount,
  };

  factory InterpretationLayer.fromJson(Map<String, dynamic> json) =>
      InterpretationLayer(
        title: json['title'],
        content: json['content'],
        teaser: json['teaser'],
        isLocked: json['isLocked'] ?? false,
        connectionCount: json['connectionCount'],
      );
}

/// User's dream memory - aggregated patterns and symbols
class DreamMemory {
  final String userId;
  final Map<String, SymbolOccurrence> symbols;
  final EmotionalProfile emotionalProfile;
  final Map<String, ThemeOccurrence> themes;
  final DreamMilestones milestones;
  final DateTime updatedAt;

  DreamMemory({
    required this.userId,
    this.symbols = const {},
    required this.emotionalProfile,
    this.themes = const {},
    required this.milestones,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'symbols': symbols.map((key, value) => MapEntry(key, value.toJson())),
    'emotionalProfile': emotionalProfile.toJson(),
    'themes': themes.map((key, value) => MapEntry(key, value.toJson())),
    'milestones': milestones.toJson(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory DreamMemory.fromJson(Map<String, dynamic> json) => DreamMemory(
    userId: json['userId'],
    symbols:
        (json['symbols'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, SymbolOccurrence.fromJson(value)),
        ) ??
        {},
    emotionalProfile: EmotionalProfile.fromJson(
      json['emotionalProfile'] ??
          {'dominantTones': [], 'recentTrend': 'seeking'},
    ),
    themes:
        (json['themes'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, ThemeOccurrence.fromJson(value)),
        ) ??
        {},
    milestones: DreamMilestones.fromJson(
      json['milestones'] ??
          {'dreamCount': 0, 'longestStreak': 0, 'currentStreak': 0},
    ),
    updatedAt: DateTime.parse(
      json['updatedAt'] ?? DateTime.now().toIso8601String(),
    ),
  );

  /// Get recurring symbols (appeared 3+ times)
  List<MapEntry<String, SymbolOccurrence>> get recurringSymbols =>
      symbols.entries.where((e) => e.value.count >= 3).toList()
        ..sort((a, b) => b.value.count.compareTo(a.value.count));

  /// Get recent symbols (last 7 days)
  List<String> get recentSymbols => symbols.entries
      .where(
        (e) => e.value.lastSeen.isAfter(
          DateTime.now().subtract(const Duration(days: 7)),
        ),
      )
      .map((e) => e.key)
      .toList();
}

/// Symbol tracking within dreams
class SymbolOccurrence {
  final int count;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final List<String> contexts;
  final List<String> emotionalAssociations;

  SymbolOccurrence({
    required this.count,
    required this.firstSeen,
    required this.lastSeen,
    this.contexts = const [],
    this.emotionalAssociations = const [],
  });

  Map<String, dynamic> toJson() => {
    'count': count,
    'firstSeen': firstSeen.toIso8601String(),
    'lastSeen': lastSeen.toIso8601String(),
    'contexts': contexts,
    'emotionalAssociations': emotionalAssociations,
  };

  factory SymbolOccurrence.fromJson(Map<String, dynamic> json) =>
      SymbolOccurrence(
        count: json['count'] ?? 1,
        firstSeen: DateTime.parse(json['firstSeen']),
        lastSeen: DateTime.parse(json['lastSeen']),
        contexts: List<String>.from(json['contexts'] ?? []),
        emotionalAssociations: List<String>.from(
          json['emotionalAssociations'] ?? [],
        ),
      );

  SymbolOccurrence increment({String? context, String? emotion}) =>
      SymbolOccurrence(
        count: count + 1,
        firstSeen: firstSeen,
        lastSeen: DateTime.now(),
        contexts: context != null ? [...contexts, context] : contexts,
        emotionalAssociations: emotion != null
            ? [...emotionalAssociations, emotion]
            : emotionalAssociations,
      );
}

/// Emotional journey tracking
class EmotionalProfile {
  final List<String> dominantTones;
  final String recentTrend; // seeking, processing, releasing, integrating
  final List<WeeklySnapshot> weeklySnapshots;

  EmotionalProfile({
    this.dominantTones = const [],
    this.recentTrend = 'seeking',
    this.weeklySnapshots = const [],
  });

  Map<String, dynamic> toJson() => {
    'dominantTones': dominantTones,
    'recentTrend': recentTrend,
    'weeklySnapshots': weeklySnapshots.map((s) => s.toJson()).toList(),
  };

  factory EmotionalProfile.fromJson(Map<String, dynamic> json) =>
      EmotionalProfile(
        dominantTones: List<String>.from(json['dominantTones'] ?? []),
        recentTrend: json['recentTrend'] ?? 'seeking',
        weeklySnapshots:
            (json['weeklySnapshots'] as List<dynamic>?)
                ?.map((s) => WeeklySnapshot.fromJson(s))
                .toList() ??
            [],
      );
}

class WeeklySnapshot {
  final String week;
  final String dominantEmotion;
  final String symbolHighlight;

  WeeklySnapshot({
    required this.week,
    required this.dominantEmotion,
    required this.symbolHighlight,
  });

  Map<String, dynamic> toJson() => {
    'week': week,
    'dominantEmotion': dominantEmotion,
    'symbolHighlight': symbolHighlight,
  };

  factory WeeklySnapshot.fromJson(Map<String, dynamic> json) => WeeklySnapshot(
    week: json['week'],
    dominantEmotion: json['dominantEmotion'],
    symbolHighlight: json['symbolHighlight'],
  );
}

/// Theme tracking
class ThemeOccurrence {
  final int count;
  final List<String> evolution;
  final DateTime lastSeen;

  ThemeOccurrence({
    required this.count,
    this.evolution = const [],
    required this.lastSeen,
  });

  Map<String, dynamic> toJson() => {
    'count': count,
    'evolution': evolution,
    'lastSeen': lastSeen.toIso8601String(),
  };

  factory ThemeOccurrence.fromJson(Map<String, dynamic> json) =>
      ThemeOccurrence(
        count: json['count'] ?? 1,
        evolution: List<String>.from(json['evolution'] ?? []),
        lastSeen: DateTime.parse(json['lastSeen']),
      );
}

/// User milestones for gamification
class DreamMilestones {
  final int dreamCount;
  final int longestStreak;
  final int currentStreak;
  final DateTime? firstDreamAt;
  final DateTime? lastDreamAt;
  final List<String> achievements;

  DreamMilestones({
    this.dreamCount = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.firstDreamAt,
    this.lastDreamAt,
    this.achievements = const [],
  });

  Map<String, dynamic> toJson() => {
    'dreamCount': dreamCount,
    'longestStreak': longestStreak,
    'currentStreak': currentStreak,
    'firstDreamAt': firstDreamAt?.toIso8601String(),
    'lastDreamAt': lastDreamAt?.toIso8601String(),
    'achievements': achievements,
  };

  factory DreamMilestones.fromJson(Map<String, dynamic> json) =>
      DreamMilestones(
        dreamCount: json['dreamCount'] ?? 0,
        longestStreak: json['longestStreak'] ?? 0,
        currentStreak: json['currentStreak'] ?? 0,
        firstDreamAt: json['firstDreamAt'] != null
            ? DateTime.parse(json['firstDreamAt'])
            : null,
        lastDreamAt: json['lastDreamAt'] != null
            ? DateTime.parse(json['lastDreamAt'])
            : null,
        achievements: List<String>.from(json['achievements'] ?? []),
      );

  /// Check if streak continues (dream logged within 36 hours)
  bool get isStreakActive {
    if (lastDreamAt == null) return false;
    return DateTime.now().difference(lastDreamAt!).inHours < 36;
  }

  /// Calculate new streak
  DreamMilestones logDream() {
    final now = DateTime.now();
    final newStreak = isStreakActive ? currentStreak + 1 : 1;
    final newLongest = newStreak > longestStreak ? newStreak : longestStreak;

    // Check for achievements
    final newAchievements = List<String>.from(achievements);
    if (dreamCount + 1 == 10 && !achievements.contains('first_10')) {
      newAchievements.add('first_10');
    }
    if (dreamCount + 1 == 50 && !achievements.contains('dream_explorer')) {
      newAchievements.add('dream_explorer');
    }
    if (dreamCount + 1 == 100 && !achievements.contains('dream_master')) {
      newAchievements.add('dream_master');
    }
    if (newStreak == 7 && !achievements.contains('week_streak')) {
      newAchievements.add('week_streak');
    }
    if (newStreak == 30 && !achievements.contains('month_streak')) {
      newAchievements.add('month_streak');
    }

    return DreamMilestones(
      dreamCount: dreamCount + 1,
      longestStreak: newLongest,
      currentStreak: newStreak,
      firstDreamAt: firstDreamAt ?? now,
      lastDreamAt: now,
      achievements: newAchievements,
    );
  }
}

/// Dream symbol with emoji and metadata
class DreamSymbol {
  final String name;
  final String nameTr;
  final String emoji;
  final String category;
  final String shortMeaning;

  const DreamSymbol({
    required this.name,
    required this.nameTr,
    required this.emoji,
    required this.category,
    required this.shortMeaning,
  });

  static const Map<String, DreamSymbol> commonSymbols = {
    'water': DreamSymbol(
      name: 'water',
      nameTr: 'Su',
      emoji: '💧',
      category: 'elements',
      shortMeaning: 'Duygular, bilinçaltı, arınma',
    ),
    'snake': DreamSymbol(
      name: 'snake',
      nameTr: 'Yılan',
      emoji: '🐍',
      category: 'animals',
      shortMeaning: 'Dönüşüm, yenilenme, gizli tehlike',
    ),
    'flying': DreamSymbol(
      name: 'flying',
      nameTr: 'Uçmak',
      emoji: '🦅',
      category: 'actions',
      shortMeaning: 'Özgürlük, yükseliş, kaçış',
    ),
    'falling': DreamSymbol(
      name: 'falling',
      nameTr: 'Düşmek',
      emoji: '⬇️',
      category: 'actions',
      shortMeaning: 'Kontrol kaybı, kaygı, bırakma',
    ),
    'death': DreamSymbol(
      name: 'death',
      nameTr: 'Ölüm',
      emoji: '💀',
      category: 'themes',
      shortMeaning: 'Son, dönüşüm, yeniden doğuş',
    ),
    'house': DreamSymbol(
      name: 'house',
      nameTr: 'Ev',
      emoji: '🏠',
      category: 'places',
      shortMeaning: 'Benlik, güvenlik, aile',
    ),
    'baby': DreamSymbol(
      name: 'baby',
      nameTr: 'Bebek',
      emoji: '👶',
      category: 'people',
      shortMeaning: 'Yeni başlangıç, masumiyet, potansiyel',
    ),
    'teeth': DreamSymbol(
      name: 'teeth',
      nameTr: 'Diş',
      emoji: '🦷',
      category: 'body',
      shortMeaning: 'Güç, güzellik, kaygı',
    ),
    'car': DreamSymbol(
      name: 'car',
      nameTr: 'Araba',
      emoji: '🚗',
      category: 'vehicles',
      shortMeaning: 'Yolculuk, kontrol, yön',
    ),
    'dog': DreamSymbol(
      name: 'dog',
      nameTr: 'Köpek',
      emoji: '🐕',
      category: 'animals',
      shortMeaning: 'Sadakat, dostluk, koruma',
    ),
    'cat': DreamSymbol(
      name: 'cat',
      nameTr: 'Kedi',
      emoji: '🐱',
      category: 'animals',
      shortMeaning: 'Bağımsızlık, sezgi, gizem',
    ),
    'fire': DreamSymbol(
      name: 'fire',
      nameTr: 'Ateş',
      emoji: '🔥',
      category: 'elements',
      shortMeaning: 'Tutku, yıkım, dönüşüm',
    ),
    'moon': DreamSymbol(
      name: 'moon',
      nameTr: 'Ay',
      emoji: '🌙',
      category: 'celestial',
      shortMeaning: 'Bilinçaltı, döngüler, kadınsı enerji',
    ),
    'ocean': DreamSymbol(
      name: 'ocean',
      nameTr: 'Okyanus',
      emoji: '🌊',
      category: 'nature',
      shortMeaning: 'Bilinçaltı derinliği, sonsuzluk',
    ),
    'forest': DreamSymbol(
      name: 'forest',
      nameTr: 'Orman',
      emoji: '🌲',
      category: 'nature',
      shortMeaning: 'Bilinçdışı, kaybolma, keşif',
    ),
  };
}
