// ════════════════════════════════════════════════════════════════════════════
// CYCLE ENTRY MODEL - InnerCycles Hormonal Cycle Tracking
// ════════════════════════════════════════════════════════════════════════════
// Tracks menstrual/hormonal cycle data for emotional pattern correlation.
// ════════════════════════════════════════════════════════════════════════════

/// The four phases of a menstrual/hormonal cycle
enum CyclePhase {
  menstrual,
  follicular,
  ovulatory,
  luteal;

  String get displayNameEn {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Menstrual';
      case CyclePhase.follicular:
        return 'Follicular';
      case CyclePhase.ovulatory:
        return 'Ovulatory';
      case CyclePhase.luteal:
        return 'Luteal';
    }
  }

  String get displayNameTr {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Adet';
      case CyclePhase.follicular:
        return 'Foliküler';
      case CyclePhase.ovulatory:
        return 'Yumurtlama';
      case CyclePhase.luteal:
        return 'Luteal';
    }
  }

  String get descriptionEn {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Rest and renewal phase';
      case CyclePhase.follicular:
        return 'Rising energy and creativity';
      case CyclePhase.ovulatory:
        return 'Peak energy and social connection';
      case CyclePhase.luteal:
        return 'Reflection and turning inward';
    }
  }

  String get descriptionTr {
    switch (this) {
      case CyclePhase.menstrual:
        return 'Dinlenme ve yenilenme dönemi';
      case CyclePhase.follicular:
        return 'Yükselen enerji ve yaratıcılık';
      case CyclePhase.ovulatory:
        return 'Zirve enerji ve sosyal bağlantı';
      case CyclePhase.luteal:
        return 'Yansıma ve içe dönüş';
    }
  }
}

/// Flow intensity for period days
enum FlowIntensity {
  light,
  medium,
  heavy;

  String get displayNameEn {
    switch (this) {
      case FlowIntensity.light:
        return 'Light';
      case FlowIntensity.medium:
        return 'Medium';
      case FlowIntensity.heavy:
        return 'Heavy';
    }
  }

  String get displayNameTr {
    switch (this) {
      case FlowIntensity.light:
        return 'Hafif';
      case FlowIntensity.medium:
        return 'Orta';
      case FlowIntensity.heavy:
        return 'Yoğun';
    }
  }
}

/// A record of a period start event
class CyclePeriodLog {
  final String id;
  final DateTime periodStartDate;
  final DateTime? periodEndDate;
  final FlowIntensity? flowIntensity;
  final List<String> symptoms;

  const CyclePeriodLog({
    required this.id,
    required this.periodStartDate,
    this.periodEndDate,
    this.flowIntensity,
    this.symptoms = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'periodStartDate': periodStartDate.toIso8601String(),
    'periodEndDate': periodEndDate?.toIso8601String(),
    'flowIntensity': flowIntensity?.name,
    'symptoms': symptoms,
  };

  factory CyclePeriodLog.fromJson(Map<String, dynamic> json) => CyclePeriodLog(
    id: json['id'] as String? ?? '',
    periodStartDate:
        DateTime.tryParse(json['periodStartDate']?.toString() ?? '') ??
        DateTime.now(),
    periodEndDate: json['periodEndDate'] != null
        ? DateTime.tryParse(json['periodEndDate'].toString())
        : null,
    flowIntensity: json['flowIntensity'] != null
        ? FlowIntensity.values.firstWhere(
            (e) => e.name == json['flowIntensity'],
            orElse: () => FlowIntensity.medium,
          )
        : null,
    symptoms:
        (json['symptoms'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
  );

  String get dateKey =>
      '${periodStartDate.year}-${periodStartDate.month.toString().padLeft(2, '0')}-${periodStartDate.day.toString().padLeft(2, '0')}';
}

/// Common cycle symptoms
class CycleSymptoms {
  CycleSymptoms._();

  static const List<(String, String, String)> all = [
    ('cramps', 'Cramps', 'Kramplar'),
    ('bloating', 'Bloating', 'Şişkinlik'),
    ('headache', 'Headache', 'Baş ağrısı'),
    ('fatigue', 'Fatigue', 'Yorgunluk'),
    ('mood_swings', 'Mood swings', 'Duygu dalgalanmaları'),
    ('backache', 'Backache', 'Sırt ağrısı'),
    ('breast_tenderness', 'Breast tenderness', 'Göğüs hassasiyeti'),
    ('insomnia', 'Insomnia', 'Uykusuzluk'),
    ('cravings', 'Cravings', 'İstek artışı'),
    ('acne', 'Acne', 'Akne'),
  ];
}
