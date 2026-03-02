// ════════════════════════════════════════════════════════════════════════════
// SIGNAL RESPONSE SERVICE - Contextual micro-interventions for low moods
// ════════════════════════════════════════════════════════════════════════════

import '../content/signal_content.dart';

enum ResponseType { breathing, sprint, shadowWork, gratitude }

class SignalResponse {
  final ResponseType type;
  final String titleEn;
  final String titleTr;
  final String descEn;
  final String descTr;
  final String route;
  final String icon;
  final int durationSeconds;

  const SignalResponse({
    required this.type,
    required this.titleEn,
    required this.titleTr,
    required this.descEn,
    required this.descTr,
    required this.route,
    required this.icon,
    required this.durationSeconds,
  });

  String title(bool isEn) => isEn ? titleEn : titleTr;
  String desc(bool isEn) => isEn ? descEn : descTr;
}

class SignalResponseService {
  static const _stormResponses = [
    SignalResponse(
      type: ResponseType.breathing,
      titleEn: 'Ground Yourself',
      titleTr: 'Kendini Topla',
      descEn: '2-minute breathing to release tension',
      descTr: '2 dakika nefes egzersizi ile rahatlama',
      route: '/breathing',
      icon: 'air',
      durationSeconds: 120,
    ),
    SignalResponse(
      type: ResponseType.sprint,
      titleEn: '60-Second Release',
      titleTr: '60 Saniyelik Boşalım',
      descEn: 'Write whatever comes to mind — no filter',
      descTr: 'Aklına ne gelirse yaz — filtre yok',
      route: '/journal/sprint',
      icon: 'bolt',
      durationSeconds: 60,
    ),
    SignalResponse(
      type: ResponseType.shadowWork,
      titleEn: 'Name the Storm',
      titleTr: 'Fırtınayı Adlandır',
      descEn: 'A guided prompt to understand what triggered this',
      descTr: 'Bunu neyin tetiklediğini anlamak için yönlendirilmiş yazma',
      route: '/shadow-work',
      icon: 'psychology',
      durationSeconds: 300,
    ),
  ];

  static const _shadowResponses = [
    SignalResponse(
      type: ResponseType.gratitude,
      titleEn: 'Tiny Bright Spot',
      titleTr: 'Küçük Bir Aydınlık',
      descEn: 'Name one small thing you\'re grateful for right now',
      descTr: 'Şu an minnettar olduğun küçük bir şeyi adlandır',
      route: '/gratitude',
      icon: 'favorite',
      durationSeconds: 60,
    ),
    SignalResponse(
      type: ResponseType.breathing,
      titleEn: 'Gentle Reset',
      titleTr: 'Nazik Sıfırlama',
      descEn: 'Slow breathing to lift your energy',
      descTr: 'Enerjini yükseltmek için yavaş nefes',
      route: '/breathing',
      icon: 'air',
      durationSeconds: 120,
    ),
    SignalResponse(
      type: ResponseType.sprint,
      titleEn: 'Stream of Thought',
      titleTr: 'Düşünce Akışı',
      descEn: 'Just 60 seconds — let it flow',
      descTr: 'Sadece 60 saniye — akışına bırak',
      route: '/journal/sprint',
      icon: 'edit_note',
      durationSeconds: 60,
    ),
  ];

  /// Get appropriate responses for a quadrant
  static List<SignalResponse> getResponses(SignalQuadrant quadrant) {
    switch (quadrant) {
      case SignalQuadrant.storm:
        return _stormResponses;
      case SignalQuadrant.shadow:
        return _shadowResponses;
      default:
        return [];
    }
  }

  /// Whether this quadrant should trigger a response sheet
  static bool shouldShowResponse(SignalQuadrant quadrant) {
    return quadrant == SignalQuadrant.storm || quadrant == SignalQuadrant.shadow;
  }
}
