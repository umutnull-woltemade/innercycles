// ════════════════════════════════════════════════════════════════════════════
// MOON PHASE SERVICE - InnerCycles Lunar Awareness
// ════════════════════════════════════════════════════════════════════════════
// Pure astronomical moon phase calculation (no API, no astrology predictions).
// Decorative lunar indicator for journal entries.
// Premium: lunar correlation analysis across focus areas.
// ════════════════════════════════════════════════════════════════════════════

import 'dart:math';

/// Moon phases in order
enum MoonPhase {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent;

  String get emoji {
    switch (this) {
      case MoonPhase.newMoon:
        return '🌑';
      case MoonPhase.waxingCrescent:
        return '🌒';
      case MoonPhase.firstQuarter:
        return '🌓';
      case MoonPhase.waxingGibbous:
        return '🌔';
      case MoonPhase.fullMoon:
        return '🌕';
      case MoonPhase.waningGibbous:
        return '🌖';
      case MoonPhase.lastQuarter:
        return '🌗';
      case MoonPhase.waningCrescent:
        return '🌘';
    }
  }

  String displayNameEn() {
    switch (this) {
      case MoonPhase.newMoon:
        return 'New Moon';
      case MoonPhase.waxingCrescent:
        return 'Waxing Crescent';
      case MoonPhase.firstQuarter:
        return 'First Quarter';
      case MoonPhase.waxingGibbous:
        return 'Waxing Gibbous';
      case MoonPhase.fullMoon:
        return 'Full Moon';
      case MoonPhase.waningGibbous:
        return 'Waning Gibbous';
      case MoonPhase.lastQuarter:
        return 'Last Quarter';
      case MoonPhase.waningCrescent:
        return 'Waning Crescent';
    }
  }

  String displayNameTr() {
    switch (this) {
      case MoonPhase.newMoon:
        return 'Yeni Ay';
      case MoonPhase.waxingCrescent:
        return 'Hilal';
      case MoonPhase.firstQuarter:
        return 'İlk Dördün';
      case MoonPhase.waxingGibbous:
        return 'Şişkin Ay';
      case MoonPhase.fullMoon:
        return 'Dolunay';
      case MoonPhase.waningGibbous:
        return 'Azalan Şişkin';
      case MoonPhase.lastQuarter:
        return 'Son Dördün';
      case MoonPhase.waningCrescent:
        return 'Azalan Hilal';
    }
  }

  /// Safe reflection prompt (no predictions)
  String reflectionPromptEn() {
    switch (this) {
      case MoonPhase.newMoon:
        return 'A time for new beginnings. What intentions feel right today?';
      case MoonPhase.waxingCrescent:
        return 'Energy may be building. What are you nurturing?';
      case MoonPhase.firstQuarter:
        return 'A natural checkpoint. How are your intentions taking shape?';
      case MoonPhase.waxingGibbous:
        return 'Things may be coming together. What progress do you notice?';
      case MoonPhase.fullMoon:
        return 'A time of clarity. What has become illuminated for you?';
      case MoonPhase.waningGibbous:
        return 'A natural time for gratitude. What are you thankful for?';
      case MoonPhase.lastQuarter:
        return 'A time to release. What can you let go of?';
      case MoonPhase.waningCrescent:
        return 'A time for rest and reflection. What have you learned?';
    }
  }

  String reflectionPromptTr() {
    switch (this) {
      case MoonPhase.newMoon:
        return 'Yeni başlangıçlar zamanı. Bugün hangi niyetler doğru hissettiriyor?';
      case MoonPhase.waxingCrescent:
        return 'Enerji artıyor olabilir. Neyi besliyorsun?';
      case MoonPhase.firstQuarter:
        return 'Doğal bir kontrol noktası. Niyetlerin nasıl şekilleniyor?';
      case MoonPhase.waxingGibbous:
        return 'İşler bir araya geliyor olabilir. Hangi ilerlemeyi fark ediyorsun?';
      case MoonPhase.fullMoon:
        return 'Netlik zamanı. Senin için ne aydınlandı?';
      case MoonPhase.waningGibbous:
        return 'Şükran için doğal bir zaman. Neye minnettarsın?';
      case MoonPhase.lastQuarter:
        return 'Bırakma zamanı. Nelerden vazgeçebilirsin?';
      case MoonPhase.waningCrescent:
        return 'Dinlenme ve yansıma zamanı. Ne öğrendin?';
    }
  }
}

/// Moon phase data for a specific date
class MoonPhaseData {
  final MoonPhase phase;
  final double illumination; // 0.0 to 1.0
  final double age; // days since new moon (0 to ~29.53)
  final DateTime date;

  const MoonPhaseData({
    required this.phase,
    required this.illumination,
    required this.age,
    required this.date,
  });
}

class MoonPhaseService {
  /// Synodic month length in days
  static const double _synodicMonth = 29.53058868;

  /// Known new moon reference: January 6, 2000, 18:14 UTC
  static final DateTime _referenceNewMoon =
      DateTime.utc(2000, 1, 6, 18, 14, 0);

  /// Calculate moon phase for a given date
  static MoonPhaseData calculate(DateTime date) {
    final utcDate = date.toUtc();
    final daysSinceReference =
        utcDate.difference(_referenceNewMoon).inMilliseconds /
            (1000 * 60 * 60 * 24);
    final moonAge = daysSinceReference % _synodicMonth;
    final normalizedAge = moonAge < 0 ? moonAge + _synodicMonth : moonAge;

    // Calculate illumination (simplified cosine approximation)
    final illumination =
        (1 - cos(2 * pi * normalizedAge / _synodicMonth)) / 2;

    // Determine phase from age
    final phase = _phaseFromAge(normalizedAge);

    return MoonPhaseData(
      phase: phase,
      illumination: illumination,
      age: normalizedAge,
      date: date,
    );
  }

  /// Get today's moon phase
  static MoonPhaseData today() => calculate(DateTime.now());

  /// Get moon phases for a date range (e.g., for monthly calendar)
  static List<MoonPhaseData> getPhaseRange(DateTime start, DateTime end) {
    final phases = <MoonPhaseData>[];
    var date = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (!date.isAfter(endDate)) {
      phases.add(calculate(date));
      date = date.add(const Duration(days: 1));
    }

    return phases;
  }

  /// Find next occurrence of a specific phase
  static DateTime nextPhase(MoonPhase targetPhase, {DateTime? from}) {
    var date = from ?? DateTime.now();
    for (int i = 0; i < 35; i++) {
      final data = calculate(date);
      if (data.phase == targetPhase && i > 0) return date;
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  /// Determine moon phase from its age in the synodic cycle
  static MoonPhase _phaseFromAge(double age) {
    final phaseLength = _synodicMonth / 8;
    if (age < phaseLength) return MoonPhase.newMoon;
    if (age < phaseLength * 2) return MoonPhase.waxingCrescent;
    if (age < phaseLength * 3) return MoonPhase.firstQuarter;
    if (age < phaseLength * 4) return MoonPhase.waxingGibbous;
    if (age < phaseLength * 5) return MoonPhase.fullMoon;
    if (age < phaseLength * 6) return MoonPhase.waningGibbous;
    if (age < phaseLength * 7) return MoonPhase.lastQuarter;
    return MoonPhase.waningCrescent;
  }
}
