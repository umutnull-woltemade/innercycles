import 'zodiac_sign.dart';

/// Available house systems
enum HouseSystem {
  placidus,
  wholeSigns,
  equalHouse,
  koch,
  porphyry,
  regiomontanus,
  campanus,
}

extension HouseSystemExtension on HouseSystem {
  String get name {
    switch (this) {
      case HouseSystem.placidus: return 'Placidus';
      case HouseSystem.wholeSigns: return 'Whole Sign';
      case HouseSystem.equalHouse: return 'Equal House';
      case HouseSystem.koch: return 'Koch';
      case HouseSystem.porphyry: return 'Porphyry';
      case HouseSystem.regiomontanus: return 'Regiomontanus';
      case HouseSystem.campanus: return 'Campanus';
    }
  }

  String get nameTr {
    switch (this) {
      case HouseSystem.placidus: return 'Placidus';
      case HouseSystem.wholeSigns: return 'Tam Burc';
      case HouseSystem.equalHouse: return 'Esit Ev';
      case HouseSystem.koch: return 'Koch';
      case HouseSystem.porphyry: return 'Porphyry';
      case HouseSystem.regiomontanus: return 'Regiomontanus';
      case HouseSystem.campanus: return 'Campanus';
    }
  }

  String get description {
    switch (this) {
      case HouseSystem.placidus:
        return 'En yaygin kullanilan sistem. Zaman bazli bolunme.';
      case HouseSystem.wholeSigns:
        return 'En eski sistem. Her burc bir ev.';
      case HouseSystem.equalHouse:
        return 'Yukselen burctan 30 derece aralikli evler.';
      case HouseSystem.koch:
        return 'Almanya\'da populer. Placidus\'a benzer.';
      case HouseSystem.porphyry:
        return 'Kadran bazli basit bolunme.';
      case HouseSystem.regiomontanus:
        return 'Ekvator bazli hesaplama.';
      case HouseSystem.campanus:
        return 'Uzay bazli bolunme.';
    }
  }
}

/// Represents an astrological house
enum House {
  first,
  second,
  third,
  fourth,
  fifth,
  sixth,
  seventh,
  eighth,
  ninth,
  tenth,
  eleventh,
  twelfth,
}

extension HouseExtension on House {
  int get number => index + 1;

  String get name => '${number}. Ev';

  String get nameTr {
    switch (this) {
      case House.first: return '1. Ev - Benlik';
      case House.second: return '2. Ev - Para & Değerler';
      case House.third: return '3. Ev - İletişim';
      case House.fourth: return '4. Ev - Aile & Kökler';
      case House.fifth: return '5. Ev - Aşk & Yaratıcılık';
      case House.sixth: return '6. Ev - İş & Sağlık';
      case House.seventh: return '7. Ev - Evlilik & Partner';
      case House.eighth: return '8. Ev - Cinsellik & Dönüşüm';
      case House.ninth: return '9. Ev - Felsefe & Yolculuk';
      case House.tenth: return '10. Ev - Kariyer & Statü';
      case House.eleventh: return '11. Ev - Arkadaşlar & Topluluk';
      case House.twelfth: return '12. Ev - Bilinçaltı & Gizli';
    }
  }

  String get meaning {
    switch (this) {
      case House.first:
        return 'Kişilik, dış imaj, fiziksel görünüm, hayata bakış açısı, yeni başlangıçlar';
      case House.second:
        return 'Para, maddi değerler, öz değer, yetenekler, kazanç tarzı';
      case House.third:
        return 'İletişim, düşünce, kardeşler, kısa yolculuklar, eğitim';
      case House.fourth:
        return 'Aile, ev, kökler, anne, iç güvenlik, son yıllar';
      case House.fifth:
        return 'Aşk, romantizm, yaratıcılık, çocuklar, eğlence, flört';
      case House.sixth:
        return 'Günlük iş, sağlık, rutinler, hizmet, evcil hayvanlar';
      case House.seventh:
        return 'Evlilik, partner, ortaklıklar, açık düşmanlar, sözleşmeler';
      case House.eighth:
        return 'Cinsellik, ölüm/yeniden doğuş, ortak para, krizler, miras';
      case House.ninth:
        return 'Yüksek öğrenim, felsefe, din, uzak yolculuklar, hukuk';
      case House.tenth:
        return 'Kariyer, toplumsal statü, başarı, baba, otorite';
      case House.eleventh:
        return 'Arkadaşlar, gruplar, hayaller, insani idealler, teknoloji';
      case House.twelfth:
        return 'Bilinçaltı, gizli düşmanlar, yalnızlık, spiritüellik, kayıplar';
    }
  }

  String get keywords {
    switch (this) {
      case House.first: return 'Benlik • İmaj • Başlangıç';
      case House.second: return 'Para • Değer • Güvenlik';
      case House.third: return 'İletişim • Öğrenme • Kardeş';
      case House.fourth: return 'Ev • Aile • Kökler';
      case House.fifth: return 'Aşk • Yaratıcılık • Eğlence';
      case House.sixth: return 'Sağlık • İş • Rutin';
      case House.seventh: return 'Partner • Evlilik • Ortaklık';
      case House.eighth: return 'Cinsellik • Dönüşüm • Kriz';
      case House.ninth: return 'Felsefe • Yolculuk • İnanç';
      case House.tenth: return 'Kariyer • Statü • Başarı';
      case House.eleventh: return 'Arkadaş • Topluluk • Hayal';
      case House.twelfth: return 'Bilinçaltı • Gizli • Spiritüel';
    }
  }

  /// Angular houses are the most powerful (1, 4, 7, 10)
  bool get isAngular =>
      this == House.first ||
      this == House.fourth ||
      this == House.seventh ||
      this == House.tenth;

  /// Succedent houses (2, 5, 8, 11)
  bool get isSuccedent =>
      this == House.second ||
      this == House.fifth ||
      this == House.eighth ||
      this == House.eleventh;

  /// Cadent houses (3, 6, 9, 12)
  bool get isCadent =>
      this == House.third ||
      this == House.sixth ||
      this == House.ninth ||
      this == House.twelfth;
}

/// A house cusp position
class HouseCusp {
  final House house;
  final double longitude; // 0-360 degrees

  HouseCusp({
    required this.house,
    required this.longitude,
  });

  ZodiacSign get sign {
    final signIndex = (longitude / 30).floor() % 12;
    return ZodiacSign.values[signIndex];
  }

  int get degree => (longitude % 30).floor();

  String get positionString => '${degree}° ${sign.symbol}';
}
