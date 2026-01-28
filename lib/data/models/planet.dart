import 'package:flutter/material.dart';

import '../models/zodiac_sign.dart';

/// Represents a celestial body
enum Planet {
  sun,
  moon,
  mercury,
  venus,
  mars,
  jupiter,
  saturn,
  uranus,
  neptune,
  pluto,
  northNode,
  southNode,
  chiron,
  lilith,
  ascendant,
  midheaven,
  ic,
  descendant,
}

extension PlanetExtension on Planet {
  String get name {
    switch (this) {
      case Planet.sun:
        return 'Sun';
      case Planet.moon:
        return 'Moon';
      case Planet.mercury:
        return 'Mercury';
      case Planet.venus:
        return 'Venus';
      case Planet.mars:
        return 'Mars';
      case Planet.jupiter:
        return 'Jupiter';
      case Planet.saturn:
        return 'Saturn';
      case Planet.uranus:
        return 'Uranus';
      case Planet.neptune:
        return 'Neptune';
      case Planet.pluto:
        return 'Pluto';
      case Planet.northNode:
        return 'North Node';
      case Planet.southNode:
        return 'South Node';
      case Planet.chiron:
        return 'Chiron';
      case Planet.lilith:
        return 'Lilith';
      case Planet.ascendant:
        return 'Ascendant';
      case Planet.midheaven:
        return 'Midheaven';
      case Planet.ic:
        return 'IC';
      case Planet.descendant:
        return 'Descendant';
    }
  }

  String get nameTr {
    switch (this) {
      case Planet.sun:
        return 'Güneş';
      case Planet.moon:
        return 'Ay';
      case Planet.mercury:
        return 'Merkür';
      case Planet.venus:
        return 'Venüs';
      case Planet.mars:
        return 'Mars';
      case Planet.jupiter:
        return 'Jüpiter';
      case Planet.saturn:
        return 'Satürn';
      case Planet.uranus:
        return 'Uranüs';
      case Planet.neptune:
        return 'Neptün';
      case Planet.pluto:
        return 'Plüton';
      case Planet.northNode:
        return 'Kuzey Ay Düğümü';
      case Planet.southNode:
        return 'Güney Ay Düğümü';
      case Planet.chiron:
        return 'Chiron';
      case Planet.lilith:
        return 'Lilith (Kara Ay)';
      case Planet.ascendant:
        return 'Yükselen';
      case Planet.midheaven:
        return 'MC (Gökyüzü Ortası)';
      case Planet.ic:
        return 'IC (Dip Nokta)';
      case Planet.descendant:
        return 'Alçalan';
    }
  }

  String get symbol {
    switch (this) {
      case Planet.sun:
        return '☉';
      case Planet.moon:
        return '☽';
      case Planet.mercury:
        return '☿';
      case Planet.venus:
        return '♀';
      case Planet.mars:
        return '♂';
      case Planet.jupiter:
        return '♃';
      case Planet.saturn:
        return '♄';
      case Planet.uranus:
        return '♅';
      case Planet.neptune:
        return '♆';
      case Planet.pluto:
        return '♇';
      case Planet.northNode:
        return '☊';
      case Planet.southNode:
        return '☋';
      case Planet.chiron:
        return '⚷';
      case Planet.lilith:
        return '⚸';
      case Planet.ascendant:
        return 'ASC';
      case Planet.midheaven:
        return 'MC';
      case Planet.ic:
        return 'IC';
      case Planet.descendant:
        return 'DSC';
    }
  }

  Color get color {
    switch (this) {
      case Planet.sun:
        return const Color(0xFFFFD700);
      case Planet.moon:
        return const Color(0xFFC0C0C0);
      case Planet.mercury:
        return const Color(0xFF87CEEB);
      case Planet.venus:
        return const Color(0xFFFF69B4);
      case Planet.mars:
        return const Color(0xFFDC143C);
      case Planet.jupiter:
        return const Color(0xFFFF8C00);
      case Planet.saturn:
        return const Color(0xFF8B4513);
      case Planet.uranus:
        return const Color(0xFF00CED1);
      case Planet.neptune:
        return const Color(0xFF4169E1);
      case Planet.pluto:
        return const Color(0xFF800080);
      case Planet.northNode:
        return const Color(0xFF9370DB);
      case Planet.southNode:
        return const Color(0xFF6B8E23);
      case Planet.chiron:
        return const Color(0xFF20B2AA);
      case Planet.lilith:
        return const Color(0xFF2F4F4F);
      case Planet.ascendant:
        return const Color(0xFFFF6347);
      case Planet.midheaven:
        return const Color(0xFF4682B4);
      case Planet.ic:
        return const Color(0xFF8FBC8F);
      case Planet.descendant:
        return const Color(0xFFDDA0DD);
    }
  }

  String get meaning {
    switch (this) {
      case Planet.sun:
        return 'Kimlik, ego, yaşam enerjisi, benlik ifadesi';
      case Planet.moon:
        return 'Duygular, güven ihtiyacı, iç dünya, anne';
      case Planet.mercury:
        return 'Zihin, iletişim, düşünce tarzı, öğrenme';
      case Planet.venus:
        return 'Aşk, çekim, ilişki dili, estetik, para';
      case Planet.mars:
        return 'Arzu, motivasyon, cinsellik, enerji, öfke';
      case Planet.jupiter:
        return 'Şans, büyüme, felsefe, inanç, bolluk';
      case Planet.saturn:
        return 'Sorumluluk, sınırlar, olgunluk, sınavlar';
      case Planet.uranus:
        return 'Özgürlük, sıra dışılık, devrim, yenilik';
      case Planet.neptune:
        return 'Hayaller, sezgi, illüzyon, ruhaniyet';
      case Planet.pluto:
        return 'Güç, dönüşüm, kriz, yeniden doğuş';
      case Planet.northNode:
        return 'Ruhun bu hayatta öğrenmesi gereken ders';
      case Planet.southNode:
        return 'Geçmiş yaşam alışkanlıkları, konfor alanı';
      case Planet.chiron:
        return 'En derin yara, şifa potansiyeli';
      case Planet.lilith:
        return 'Bastırılan arzular, tabular, gölge';
      case Planet.ascendant:
        return 'Dış imaj, ilk izlenim, fiziksel görünüm';
      case Planet.midheaven:
        return 'Kariyer, toplumsal rol, hedefler';
      case Planet.ic:
        return 'Aile kökleri, iç dünya, ev';
      case Planet.descendant:
        return 'Partner, ilişki tarzı, projeksiyon';
    }
  }

  bool get isPersonalPlanet {
    return this == Planet.sun ||
        this == Planet.moon ||
        this == Planet.mercury ||
        this == Planet.venus ||
        this == Planet.mars;
  }

  bool get isSocialPlanet {
    return this == Planet.jupiter || this == Planet.saturn;
  }

  bool get isOuterPlanet {
    return this == Planet.uranus ||
        this == Planet.neptune ||
        this == Planet.pluto;
  }
}

/// A planet's position in a chart
class PlanetPosition {
  final Planet planet;
  final double longitude; // 0-360 degrees
  final double latitude;
  final bool isRetrograde;
  final int house; // 1-12

  PlanetPosition({
    required this.planet,
    required this.longitude,
    this.latitude = 0,
    this.isRetrograde = false,
    this.house = 1,
  });

  ZodiacSign get sign {
    final signIndex = (longitude / 30).floor() % 12;
    return ZodiacSign.values[signIndex];
  }

  int get degree => (longitude % 30).floor();
  int get minute => ((longitude % 1) * 60).floor();

  String get positionString {
    return '$degree° ${sign.symbol} ${minute.toString().padLeft(2, '0')}\'';
  }

  String get fullPosition {
    final retro = isRetrograde ? ' ℞' : '';
    return '${planet.symbol} $positionString$retro (House $house)';
  }

  Map<String, dynamic> toJson() => {
    'planet': planet.name,
    'longitude': longitude,
    'latitude': latitude,
    'isRetrograde': isRetrograde,
    'house': house,
  };

  factory PlanetPosition.fromJson(Map<String, dynamic> json) {
    return PlanetPosition(
      planet: Planet.values.firstWhere((p) => p.name == json['planet']),
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      isRetrograde: json['isRetrograde'] as bool? ?? false,
      house: json['house'] as int? ?? 1,
    );
  }
}
