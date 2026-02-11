import 'zodiac_sign.dart';
import '../providers/app_providers.dart';

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
      case HouseSystem.placidus:
        return 'Placidus';
      case HouseSystem.wholeSigns:
        return 'Whole Sign';
      case HouseSystem.equalHouse:
        return 'Equal House';
      case HouseSystem.koch:
        return 'Koch';
      case HouseSystem.porphyry:
        return 'Porphyry';
      case HouseSystem.regiomontanus:
        return 'Regiomontanus';
      case HouseSystem.campanus:
        return 'Campanus';
    }
  }

  String get nameTr {
    switch (this) {
      case HouseSystem.placidus:
        return 'Placidus';
      case HouseSystem.wholeSigns:
        return 'Tam Burc';
      case HouseSystem.equalHouse:
        return 'Esit Ev';
      case HouseSystem.koch:
        return 'Koch';
      case HouseSystem.porphyry:
        return 'Porphyry';
      case HouseSystem.regiomontanus:
        return 'Regiomontanus';
      case HouseSystem.campanus:
        return 'Campanus';
    }
  }

  String get nameEn => name;

  String get nameDe {
    switch (this) {
      case HouseSystem.placidus:
        return 'Placidus';
      case HouseSystem.wholeSigns:
        return 'Ganze Zeichen';
      case HouseSystem.equalHouse:
        return 'Gleiche Hauser';
      case HouseSystem.koch:
        return 'Koch';
      case HouseSystem.porphyry:
        return 'Porphyrius';
      case HouseSystem.regiomontanus:
        return 'Regiomontanus';
      case HouseSystem.campanus:
        return 'Campanus';
    }
  }

  String get nameFr {
    switch (this) {
      case HouseSystem.placidus:
        return 'Placidus';
      case HouseSystem.wholeSigns:
        return 'Signes entiers';
      case HouseSystem.equalHouse:
        return 'Maisons egales';
      case HouseSystem.koch:
        return 'Koch';
      case HouseSystem.porphyry:
        return 'Porphyre';
      case HouseSystem.regiomontanus:
        return 'Regiomontanus';
      case HouseSystem.campanus:
        return 'Campanus';
    }
  }

  String localizedName(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return nameEn;
      case AppLanguage.de:
        return nameDe;
      case AppLanguage.fr:
        return nameFr;
      case AppLanguage.tr:
      default:
        return nameTr;
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

  String get name => '$number. Ev';

  String get nameTr {
    switch (this) {
      case House.first:
        return '1. Ev - Benlik';
      case House.second:
        return '2. Ev - Para & Değerler';
      case House.third:
        return '3. Ev - İletişim';
      case House.fourth:
        return '4. Ev - Aile & Kökler';
      case House.fifth:
        return '5. Ev - Aşk & Yaratıcılık';
      case House.sixth:
        return '6. Ev - İş & Sağlık';
      case House.seventh:
        return '7. Ev - Evlilik & Partner';
      case House.eighth:
        return '8. Ev - Cinsellik & Dönüşüm';
      case House.ninth:
        return '9. Ev - Felsefe & Yolculuk';
      case House.tenth:
        return '10. Ev - Kariyer & Statü';
      case House.eleventh:
        return '11. Ev - Arkadaşlar & Topluluk';
      case House.twelfth:
        return '12. Ev - Bilinçaltı & Gizli';
    }
  }

  String get nameEn {
    switch (this) {
      case House.first:
        return '1st House - Self';
      case House.second:
        return '2nd House - Money & Values';
      case House.third:
        return '3rd House - Communication';
      case House.fourth:
        return '4th House - Family & Roots';
      case House.fifth:
        return '5th House - Love & Creativity';
      case House.sixth:
        return '6th House - Work & Health';
      case House.seventh:
        return '7th House - Marriage & Partner';
      case House.eighth:
        return '8th House - Sexuality & Transformation';
      case House.ninth:
        return '9th House - Philosophy & Travel';
      case House.tenth:
        return '10th House - Career & Status';
      case House.eleventh:
        return '11th House - Friends & Community';
      case House.twelfth:
        return '12th House - Subconscious & Hidden';
    }
  }

  String get nameDe {
    switch (this) {
      case House.first:
        return '1. Haus - Selbst';
      case House.second:
        return '2. Haus - Geld & Werte';
      case House.third:
        return '3. Haus - Kommunikation';
      case House.fourth:
        return '4. Haus - Familie & Wurzeln';
      case House.fifth:
        return '5. Haus - Liebe & Kreativitat';
      case House.sixth:
        return '6. Haus - Arbeit & Gesundheit';
      case House.seventh:
        return '7. Haus - Ehe & Partner';
      case House.eighth:
        return '8. Haus - Sexualitat & Transformation';
      case House.ninth:
        return '9. Haus - Philosophie & Reisen';
      case House.tenth:
        return '10. Haus - Karriere & Status';
      case House.eleventh:
        return '11. Haus - Freunde & Gemeinschaft';
      case House.twelfth:
        return '12. Haus - Unterbewusstsein & Verborgenes';
    }
  }

  String get nameFr {
    switch (this) {
      case House.first:
        return '1ere Maison - Soi';
      case House.second:
        return '2eme Maison - Argent & Valeurs';
      case House.third:
        return '3eme Maison - Communication';
      case House.fourth:
        return '4eme Maison - Famille & Racines';
      case House.fifth:
        return '5eme Maison - Amour & Creativite';
      case House.sixth:
        return '6eme Maison - Travail & Sante';
      case House.seventh:
        return '7eme Maison - Mariage & Partenaire';
      case House.eighth:
        return '8eme Maison - Sexualite & Transformation';
      case House.ninth:
        return '9eme Maison - Philosophie & Voyage';
      case House.tenth:
        return '10eme Maison - Carriere & Statut';
      case House.eleventh:
        return '11eme Maison - Amis & Communaute';
      case House.twelfth:
        return '12eme Maison - Subconscient & Cache';
    }
  }

  String localizedName(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return nameEn;
      case AppLanguage.de:
        return nameDe;
      case AppLanguage.fr:
        return nameFr;
      case AppLanguage.tr:
      default:
        return nameTr;
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
      case House.first:
        return 'Benlik • İmaj • Başlangıç';
      case House.second:
        return 'Para • Değer • Güvenlik';
      case House.third:
        return 'İletişim • Öğrenme • Kardeş';
      case House.fourth:
        return 'Ev • Aile • Kökler';
      case House.fifth:
        return 'Aşk • Yaratıcılık • Eğlence';
      case House.sixth:
        return 'Sağlık • İş • Rutin';
      case House.seventh:
        return 'Partner • Evlilik • Ortaklık';
      case House.eighth:
        return 'Cinsellik • Dönüşüm • Kriz';
      case House.ninth:
        return 'Felsefe • Yolculuk • İnanç';
      case House.tenth:
        return 'Kariyer • Statü • Başarı';
      case House.eleventh:
        return 'Arkadaş • Topluluk • Hayal';
      case House.twelfth:
        return 'Bilinçaltı • Gizli • Spiritüel';
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

  HouseCusp({required this.house, required this.longitude});

  ZodiacSign get sign {
    final signIndex = (longitude / 30).floor() % 12;
    return ZodiacSign.values[signIndex];
  }

  int get degree => (longitude % 30).floor();

  String get positionString => '$degree° ${sign.symbol}';
}
