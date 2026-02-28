// ════════════════════════════════════════════════════════════════════════════
// SHADOW WORK ENTRY MODEL - InnerCycles Shadow Integration Journal
// ════════════════════════════════════════════════════════════════════════════
// Tracks shadow work journal entries for guided self-exploration.
// ════════════════════════════════════════════════════════════════════════════

/// The eight shadow archetypes for guided exploration
enum ShadowArchetype {
  innerCritic,
  peoplePleaser,
  perfectionist,
  controller,
  victim,
  rebel,
  avoider,
  caretaker;

  String get displayNameEn {
    switch (this) {
      case ShadowArchetype.innerCritic:
        return 'Inner Critic';
      case ShadowArchetype.peoplePleaser:
        return 'People Pleaser';
      case ShadowArchetype.perfectionist:
        return 'Perfectionist';
      case ShadowArchetype.controller:
        return 'Controller';
      case ShadowArchetype.victim:
        return 'Victim';
      case ShadowArchetype.rebel:
        return 'Rebel';
      case ShadowArchetype.avoider:
        return 'Avoider';
      case ShadowArchetype.caretaker:
        return 'Caretaker';
    }
  }

  String get displayNameTr {
    switch (this) {
      case ShadowArchetype.innerCritic:
        return 'İç Eleştirmen';
      case ShadowArchetype.peoplePleaser:
        return 'Onay Arayıcı';
      case ShadowArchetype.perfectionist:
        return 'Mükemmeliyetçi';
      case ShadowArchetype.controller:
        return 'Kontrolcü';
      case ShadowArchetype.victim:
        return 'Kurban';
      case ShadowArchetype.rebel:
        return 'Asi';
      case ShadowArchetype.avoider:
        return 'Kaçınmacı';
      case ShadowArchetype.caretaker:
        return 'Bakıcı';
    }

  }

  String localizedName(bool isEn) => isEn ? displayNameEn : displayNameTr;

  String get descriptionEn {
    switch (this) {
      case ShadowArchetype.innerCritic:
        return 'The voice that judges and criticizes you harshly';
      case ShadowArchetype.peoplePleaser:
        return 'The part that sacrifices your needs for approval';
      case ShadowArchetype.perfectionist:
        return 'The drive to be flawless at the cost of peace';
      case ShadowArchetype.controller:
        return 'The need to manage everything and everyone';
      case ShadowArchetype.victim:
        return 'The feeling of helplessness or being wronged';
      case ShadowArchetype.rebel:
        return 'The impulse to resist and defy authority';
      case ShadowArchetype.avoider:
        return 'The tendency to escape discomfort or conflict';
      case ShadowArchetype.caretaker:
        return 'Caring for others while neglecting yourself';
    }
  }

  String get descriptionTr {
    switch (this) {
      case ShadowArchetype.innerCritic:
        return 'Seni sert bir şekilde yargılayan ve eleştiren ses';
      case ShadowArchetype.peoplePleaser:
        return 'Onay için kendi ihtiyaçlarından vazgeçen parça';
      case ShadowArchetype.perfectionist:
        return 'Huzur pahasına kusursuz olma dürtüsü';
      case ShadowArchetype.controller:
        return 'Her şeyi ve herkesi yönetme ihtiyacı';
      case ShadowArchetype.victim:
        return 'Çaresizlik veya haksızlığa uğramışlık hissi';
      case ShadowArchetype.rebel:
        return 'Otoriteye direnmek ve karşı çıkma dürtüsü';
      case ShadowArchetype.avoider:
        return 'Rahatsızlıktan veya çatışmadan kaçma eğilimi';
      case ShadowArchetype.caretaker:
        return 'Kendini ihmal ederek başkalarına bakma';
    }
  }

  String get iconEmoji {
    switch (this) {
      case ShadowArchetype.innerCritic:
        return '🪞';
      case ShadowArchetype.peoplePleaser:
        return '🎭';
      case ShadowArchetype.perfectionist:
        return '⚖️';
      case ShadowArchetype.controller:
        return '🏰';
      case ShadowArchetype.victim:
        return '🕊️';
      case ShadowArchetype.rebel:
        return '🔥';
      case ShadowArchetype.avoider:
        return '🌫️';
      case ShadowArchetype.caretaker:
        return '🤲';
    }
  }
}

/// Depth level for shadow work prompts
enum ShadowDepth {
  gentle,
  moderate,
  deep;

  String get displayNameEn {
    switch (this) {
      case ShadowDepth.gentle:
        return 'Gentle';
      case ShadowDepth.moderate:
        return 'Moderate';
      case ShadowDepth.deep:
        return 'Deep';
    }
  }

  String get displayNameTr {
    switch (this) {
      case ShadowDepth.gentle:
        return 'Nazik';
      case ShadowDepth.moderate:
        return 'Orta';
      case ShadowDepth.deep:
        return 'Derin';
    }
  }

  String localizedName(bool isEn) => isEn ? displayNameEn : displayNameTr;

}

/// A single shadow work journal entry
class ShadowWorkEntry {
  final String id;
  final DateTime date;
  final ShadowArchetype archetype;
  final String prompt;
  final String response;
  final int intensity; // 1-10
  final bool breakthroughMoment;

  const ShadowWorkEntry({
    required this.id,
    required this.date,
    required this.archetype,
    required this.prompt,
    required this.response,
    required this.intensity,
    this.breakthroughMoment = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'archetype': archetype.name,
    'prompt': prompt,
    'response': response,
    'intensity': intensity,
    'breakthroughMoment': breakthroughMoment,
  };

  factory ShadowWorkEntry.fromJson(Map<String, dynamic> json) =>
      ShadowWorkEntry(
        id: json['id'] as String? ?? '',
        date:
            DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
        archetype: ShadowArchetype.values.firstWhere(
          (e) => e.name == json['archetype'],
          orElse: () => ShadowArchetype.innerCritic,
        ),
        prompt: json['prompt'] as String? ?? '',
        response: json['response'] as String? ?? '',
        intensity: (json['intensity'] as num?)?.toInt().clamp(1, 10) ?? 5,
        breakthroughMoment: json['breakthroughMoment'] as bool? ?? false,
      );

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
