import 'dart:math';

import '../models/premium_astrology.dart';
import '../models/zodiac_sign.dart';
import '../providers/app_providers.dart';
import 'l10n_service.dart';

class PremiumAstrologyService {
  static final PremiumAstrologyService _instance =
      PremiumAstrologyService._internal();
  factory PremiumAstrologyService() => _instance;
  PremiumAstrologyService._internal();

  /// Generate AstroCartography data for a birth chart
  AstroCartographyData generateAstroCartography({
    required String userName,
    required DateTime birthDate,
    required double birthLatitude,
    required double birthLongitude,
    AppLanguage language = AppLanguage.tr,
  }) {
    final random = Random(birthDate.millisecondsSinceEpoch);
    final planets = _getPlanetNames(language);

    final planetaryLines = <PlanetaryLine>[];
    for (final planet in planets) {
      for (final lineType in LineType.values) {
        // Generate line coordinates across the globe
        final coordinates = <GeoPoint>[];
        for (int i = 0; i < 20; i++) {
          coordinates.add(
            GeoPoint(
              latitude: -90 + (i * 9.0) + random.nextDouble() * 5,
              longitude: random.nextDouble() * 360 - 180,
            ),
          );
        }
        coordinates.sort((a, b) => a.latitude.compareTo(b.latitude));

        planetaryLines.add(
          PlanetaryLine(
            planet: planet,
            lineType: lineType,
            coordinates: coordinates,
            meaning: _getPlanetaryLineMeaning(
              planet,
              lineType,
              language: language,
            ),
            advice: _getPlanetaryLineAdvice(
              planet,
              lineType,
              language: language,
            ),
            isPositive: _isPlanetaryLinePositive(planet, lineType),
          ),
        );
      }
    }

    final powerPlaces = _generatePowerPlaces(
      birthDate,
      random,
      language: language,
    );

    return AstroCartographyData(
      userName: userName,
      birthDate: birthDate,
      birthLatitude: birthLatitude,
      birthLongitude: birthLongitude,
      planetaryLines: planetaryLines,
      powerPlaces: powerPlaces,
      overallAnalysis: _generateCartographyAnalysis(
        userName,
        birthDate,
        language: language,
      ),
    );
  }

  List<String> _getPlanetNames(AppLanguage language) {
    if (language == AppLanguage.tr) {
      return ['Güneş', 'Ay', 'Merkür', 'Venüs', 'Mars', 'Jüpiter', 'Satürn'];
    } else {
      return ['Sun', 'Moon', 'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn'];
    }
  }

  String _getPlanetaryLineMeaning(
    String planet,
    LineType lineType, {
    AppLanguage language = AppLanguage.tr,
  }) {
    // Map planet name to key
    final planetKey = _getPlanetKey(planet);
    final lineKey = lineType.name;
    final key = 'premium_astrology.planetary_line_meanings.$planetKey.$lineKey';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // Fallback
    final trMeanings = {
      'Güneş': {
        LineType.ascendant:
            'Kişisel güç ve kimlik burada en yoğun. Liderlik potansiyeliniz parlar.',
        LineType.descendant:
            'İlişkilerde güneş gibi parlarsınız. Ortaklıklar size enerji verir.',
        LineType.midheaven:
            'Kariyer ve toplumsal statü için güçlü bir konum. Tanınırlık potansiyeli.',
        LineType.imumCoeli:
            'Aileniz ve köklerinizle derin bağ. Ev ve yuva konularında bereket.',
      },
      'Ay': {
        LineType.ascendant:
            'Duygusal hassasiyet artar. Sezgisel yetenekleriniz güçlenir.',
        LineType.descendant:
            'İlişkilerde duygusal derinlik. Empatik bağlar kurulur.',
        LineType.midheaven:
            'Toplum tarafından duygusal olarak kabul görürsünüz. Şifa meslekleri için ideal.',
        LineType.imumCoeli:
            'Ev ortamında huzur bulursunuz. Aile bağları güçlüdür.',
      },
      'Merkür': {
        LineType.ascendant:
            'İletişim becerileri zirve yapar. Öğrenme ve öğretme için ideal.',
        LineType.descendant: 'İş ortaklıkları ve müzakereler için güçlü konum.',
        LineType.midheaven: 'Yazarlık, medya ve eğitim kariyeri için mükemmel.',
        LineType.imumCoeli:
            'Ev ofis çalışması için ideal. Ailede iletişim güçlü.',
      },
      'Venüs': {
        LineType.ascendant:
            'Çekicilik ve cazibe artar. Sanat ve güzellik alanında başarı.',
        LineType.descendant:
            'Romantik ilişkiler için muhteşem konum. Aşk burada çiçek açar.',
        LineType.midheaven:
            'Sanat, moda ve güzellik sektörlerinde kariyer fırsatları.',
        LineType.imumCoeli: 'Güzel ve huzurlu bir ev ortamı. Aile içi uyum.',
      },
      'Mars': {
        LineType.ascendant:
            'Fiziksel enerji ve motivasyon zirve yapar. Spor başarıları.',
        LineType.descendant:
            'İlişkilerde tutku ama dikkatli olun, çatışma potansiyeli.',
        LineType.midheaven:
            'Rekabetçi iş ortamlarında başarı. Liderlik rolleri.',
        LineType.imumCoeli:
            'Ev ortamında hareketlilik. Ev tadilatı veya inşaat işleri.',
      },
      'Jüpiter': {
        LineType.ascendant:
            'Şans ve bereket sizi takip eder. Büyüme fırsatları.',
        LineType.descendant:
            'İş ortaklıkları genişler. Yabancılarla bağlantılar.',
        LineType.midheaven: 'Kariyer zirve yapar. Uluslararası fırsatlar.',
        LineType.imumCoeli: 'Geniş aile. Miras ve mülk konularında bereket.',
      },
      'Satürn': {
        LineType.ascendant:
            'Disiplin ve olgunluk gerektirir. Zorluklar büyüme getirir.',
        LineType.descendant: 'İlişkilerde ciddiyet. Uzun vadeli bağlılıklar.',
        LineType.midheaven:
            'Kariyer zaman alır ama kalıcı başarı. Otorite pozisyonları.',
        LineType.imumCoeli: 'Aile sorumlulukları. Geleneklerle yüzleşme.',
      },
    };

    final enMeanings = {
      'Sun': {
        LineType.ascendant:
            'Personal power and identity are most intense here. Your leadership potential shines.',
        LineType.descendant:
            'You shine like the sun in relationships. Partnerships give you energy.',
        LineType.midheaven:
            'Strong position for career and social status. Recognition potential.',
        LineType.imumCoeli:
            'Deep connection with family and roots. Blessings in home matters.',
      },
      'Moon': {
        LineType.ascendant:
            'Emotional sensitivity increases. Your intuitive abilities strengthen.',
        LineType.descendant:
            'Emotional depth in relationships. Empathic bonds are formed.',
        LineType.midheaven:
            'Emotionally accepted by society. Ideal for healing professions.',
        LineType.imumCoeli:
            'You find peace in home environment. Family bonds are strong.',
      },
      'Mercury': {
        LineType.ascendant:
            'Communication skills peak. Ideal for learning and teaching.',
        LineType.descendant:
            'Strong position for business partnerships and negotiations.',
        LineType.midheaven: 'Perfect for writing, media and education careers.',
        LineType.imumCoeli:
            'Ideal for home office work. Strong family communication.',
      },
      'Venus': {
        LineType.ascendant:
            'Attractiveness and charm increase. Success in art and beauty.',
        LineType.descendant:
            'Wonderful position for romantic relationships. Love blooms here.',
        LineType.midheaven:
            'Career opportunities in art, fashion and beauty sectors.',
        LineType.imumCoeli:
            'Beautiful and peaceful home environment. Family harmony.',
      },
      'Mars': {
        LineType.ascendant:
            'Physical energy and motivation peak. Sports achievements.',
        LineType.descendant:
            'Passion in relationships but be careful, conflict potential.',
        LineType.midheaven:
            'Success in competitive work environments. Leadership roles.',
        LineType.imumCoeli:
            'Activity in home environment. Home renovation or construction.',
      },
      'Jupiter': {
        LineType.ascendant:
            'Luck and blessings follow you. Growth opportunities.',
        LineType.descendant:
            'Business partnerships expand. Connections with foreigners.',
        LineType.midheaven: 'Career peaks. International opportunities.',
        LineType.imumCoeli:
            'Large family. Blessings in inheritance and property matters.',
      },
      'Saturn': {
        LineType.ascendant:
            'Requires discipline and maturity. Challenges bring growth.',
        LineType.descendant:
            'Seriousness in relationships. Long-term commitments.',
        LineType.midheaven:
            'Career takes time but lasting success. Authority positions.',
        LineType.imumCoeli: 'Family responsibilities. Confronting traditions.',
      },
    };

    final meanings = language == AppLanguage.tr ? trMeanings : enMeanings;
    final defaultMsg = language == AppLanguage.tr
        ? 'Bu konum sizin için özel anlamlar taşır.'
        : 'This position holds special meaning for you.';
    return meanings[planet]?[lineType] ?? defaultMsg;
  }

  String _getPlanetKey(String planet) {
    final keyMap = {
      'Güneş': 'sun',
      'Sun': 'sun',
      'Ay': 'moon',
      'Moon': 'moon',
      'Merkür': 'mercury',
      'Mercury': 'mercury',
      'Venüs': 'venus',
      'Venus': 'venus',
      'Mars': 'mars',
      'Jüpiter': 'jupiter',
      'Jupiter': 'jupiter',
      'Satürn': 'saturn',
      'Saturn': 'saturn',
      'Uranüs': 'uranus',
      'Uranus': 'uranus',
      'Neptün': 'neptune',
      'Neptune': 'neptune',
      'Pluto': 'pluto',
    };
    return keyMap[planet] ?? planet.toLowerCase();
  }

  String _getPlanetaryLineAdvice(
    String planet,
    LineType lineType, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final planetKey = _getPlanetKey(planet);
    final lineKey = lineType.name;
    final key = 'premium_astrology.planetary_line_advice.$planetKey.$lineKey';
    final localized = L10nService.get(key, language);
    if (localized != key) return localized;

    // Fallback
    final trAdvice = {
      'Güneş': {
        LineType.ascendant:
            'Bu bölgede kendinizi ifade edin ve liderlik rollerini üstlenin.',
        LineType.descendant: 'İş ortaklıkları için bu bölgeleri değerlendirin.',
        LineType.midheaven:
            'Kariyer atılımları için bu bölgelerde fırsatları takip edin.',
        LineType.imumCoeli: 'Emeklilik veya aile yuvası kurmak için düşünün.',
      },
      'Ay': {
        LineType.ascendant: 'Duygusal şifa için bu bölgeleri ziyaret edin.',
        LineType.descendant:
            'Bu bölgelerde derin duygusal bağlantı temaları keşfedilebilir.',
        LineType.midheaven:
            'Terapi veya şifa meslekleri için bu bölgeler idealdir.',
        LineType.imumCoeli:
            'Aile kökleriyle bağlantı kurmak için bu yerleri ziyaret edin.',
      },
      'Venüs': {
        LineType.ascendant:
            'Kişisel stil ve güzellik işleri için bu bölgeler mükemmel.',
        LineType.descendant: 'Romantik tatiller ve balayı için ideal yerler.',
        LineType.midheaven: 'Sanat galerisi açmak veya moda işi için düşünün.',
        LineType.imumCoeli:
            'Güzel bir ev dekorasyonu bu bölgelerde ilham verir.',
      },
      'Jüpiter': {
        LineType.ascendant:
            'Yeni başlangıçlar için şanslı bölgeler. Risk alın!',
        LineType.descendant: 'Uluslararası iş ortaklıkları kurun.',
        LineType.midheaven: 'Global kariyer fırsatlarını değerlendirin.',
        LineType.imumCoeli: 'Mülk yatırımları için değerlendirin.',
      },
    };

    final enAdvice = {
      'Sun': {
        LineType.ascendant:
            'Express yourself and take on leadership roles in this region.',
        LineType.descendant: 'Evaluate this region for business partnerships.',
        LineType.midheaven:
            'Follow opportunities in this region for career breakthroughs.',
        LineType.imumCoeli:
            'Consider for retirement or establishing a family home.',
      },
      'Moon': {
        LineType.ascendant: 'Visit this region for emotional healing.',
        LineType.descendant:
            'This region may offer themes of deep emotional connection.',
        LineType.midheaven:
            'This region is ideal for therapy or healing professions.',
        LineType.imumCoeli: 'Visit these places to connect with family roots.',
      },
      'Venus': {
        LineType.ascendant:
            'Perfect regions for personal style and beauty businesses.',
        LineType.descendant:
            'Ideal places for romantic holidays and honeymoons.',
        LineType.midheaven:
            'Consider for opening an art gallery or fashion business.',
        LineType.imumCoeli:
            'Beautiful home decoration is inspired in these regions.',
      },
      'Jupiter': {
        LineType.ascendant: 'Lucky regions for new beginnings. Take risks!',
        LineType.descendant: 'Establish international business partnerships.',
        LineType.midheaven: 'Evaluate global career opportunities.',
        LineType.imumCoeli: 'Evaluate for property investments.',
      },
    };

    final advice = language == AppLanguage.tr ? trAdvice : enAdvice;
    final defaultMsg = language == AppLanguage.tr
        ? 'Bu enerjiyi bilinçli olarak kullanın ve fırsatları değerlendirin.'
        : 'Use this energy consciously and evaluate opportunities.';
    return advice[planet]?[lineType] ?? defaultMsg;
  }

  bool _isPlanetaryLinePositive(String planet, LineType lineType) {
    final positives = ['Güneş', 'Venüs', 'Jüpiter'];
    final challenging = ['Satürn', 'Mars'];

    if (positives.contains(planet)) return true;
    if (challenging.contains(planet)) {
      return lineType == LineType.midheaven; // Career focus is positive
    }
    return true;
  }

  List<PowerPlace> _generatePowerPlaces(
    DateTime birthDate,
    Random random, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final trCities = [
      {
        'name': 'İstanbul',
        'country': 'Türkiye',
        'lat': 41.0082,
        'lng': 28.9784,
      },
      {'name': 'Paris', 'country': 'Fransa', 'lat': 48.8566, 'lng': 2.3522},
      {
        'name': 'Londra',
        'country': 'İngiltere',
        'lat': 51.5074,
        'lng': -0.1278,
      },
      {'name': 'New York', 'country': 'ABD', 'lat': 40.7128, 'lng': -74.0060},
      {'name': 'Tokyo', 'country': 'Japonya', 'lat': 35.6762, 'lng': 139.6503},
      {'name': 'Dubai', 'country': 'BAE', 'lat': 25.2048, 'lng': 55.2708},
      {
        'name': 'Barselona',
        'country': 'İspanya',
        'lat': 41.3851,
        'lng': 2.1734,
      },
      {'name': 'Roma', 'country': 'İtalya', 'lat': 41.9028, 'lng': 12.4964},
      {
        'name': 'Amsterdam',
        'country': 'Hollanda',
        'lat': 52.3676,
        'lng': 4.9041,
      },
      {
        'name': 'Sidney',
        'country': 'Avustralya',
        'lat': -33.8688,
        'lng': 151.2093,
      },
    ];

    final enCities = [
      {'name': 'Istanbul', 'country': 'Turkey', 'lat': 41.0082, 'lng': 28.9784},
      {'name': 'Paris', 'country': 'France', 'lat': 48.8566, 'lng': 2.3522},
      {'name': 'London', 'country': 'UK', 'lat': 51.5074, 'lng': -0.1278},
      {'name': 'New York', 'country': 'USA', 'lat': 40.7128, 'lng': -74.0060},
      {'name': 'Tokyo', 'country': 'Japan', 'lat': 35.6762, 'lng': 139.6503},
      {'name': 'Dubai', 'country': 'UAE', 'lat': 25.2048, 'lng': 55.2708},
      {'name': 'Barcelona', 'country': 'Spain', 'lat': 41.3851, 'lng': 2.1734},
      {'name': 'Rome', 'country': 'Italy', 'lat': 41.9028, 'lng': 12.4964},
      {
        'name': 'Amsterdam',
        'country': 'Netherlands',
        'lat': 52.3676,
        'lng': 4.9041,
      },
      {
        'name': 'Sydney',
        'country': 'Australia',
        'lat': -33.8688,
        'lng': 151.2093,
      },
    ];

    final cities = language == AppLanguage.tr ? trCities : enCities;

    final trEnergyTypes = [
      'Kariyer ve Başarı',
      'Aşk ve Romantizm',
      'Spiritüel Gelişim',
      'Finansal Bereket',
      'Yaratıcı İlham',
      'Sağlık ve Şifa',
    ];
    final enEnergyTypes = [
      'Career and Success',
      'Love and Romance',
      'Spiritual Growth',
      'Financial Abundance',
      'Creative Inspiration',
      'Health and Healing',
    ];
    final energyTypes = language == AppLanguage.tr
        ? trEnergyTypes
        : enEnergyTypes;

    final planets = _getPlanetNames(language);

    return cities.map((city) {
      final activePlanets = <String>[];
      for (int i = 0; i < 2 + random.nextInt(3); i++) {
        final planet = planets[random.nextInt(planets.length)];
        if (!activePlanets.contains(planet)) {
          activePlanets.add(planet);
        }
      }

      final energyType = energyTypes[random.nextInt(energyTypes.length)];

      return PowerPlace(
        name: city['name'] as String,
        country: city['country'] as String,
        latitude: city['lat'] as double,
        longitude: city['lng'] as double,
        activePlanets: activePlanets,
        energyType: energyType,
        description: _getPowerPlaceDescription(
          city['name'] as String,
          energyType,
          activePlanets,
          language: language,
        ),
        powerRating: 3 + random.nextInt(3),
      );
    }).toList();
  }

  String _getPowerPlaceDescription(
    String city,
    String energyType,
    List<String> planets, {
    AppLanguage language = AppLanguage.tr,
  }) {
    if (language == AppLanguage.tr) {
      return '$city, sizin için $energyType enerjisi taşıyor. '
          '${planets.join(", ")} gezegenleri burada güçleniyor. '
          'Bu şehri ziyaret etmek veya burada zaman geçirmek, '
          'bu alanlarda büyük fırsatlar sunabilir.';
    } else {
      return '$city carries $energyType energy for you. '
          '${planets.join(", ")} planets are strengthened here. '
          'Visiting this city or spending time here '
          'can offer great opportunities in these areas.';
    }
  }

  String _generateCartographyAnalysis(
    String userName,
    DateTime birthDate, {
    AppLanguage language = AppLanguage.tr,
  }) {
    if (language == AppLanguage.tr) {
      return '''$userName, AstroCartography haritanız dünya üzerindeki enerji noktalarınızı gösteriyor.

Her gezegen çizgisi, o gezegenin enerjisinin sizin için en güçlü olduğu yerleri işaret eder. Yükselen (AC) çizgileri kişisel güç ve kimlik, Alçalan (DC) çizgileri ilişkiler, Gökyüzü Ortası (MC) çizgileri kariyer ve Göğün Dibi (IC) çizgileri ev ve aile konularını etkiler.

Güç noktalarınız, birden fazla olumlu gezegen enerjisinin kesiştiği yerlerdir. Bu şehirler sizin için özel fırsatlar barındırır.

Tavsiye: Seyahat planlarınızı yaparken veya taşınma düşünürken bu haritayı referans alın. Bazı yerler kariyer için idealken, bazıları aşk veya spiritüel gelişim için daha uygun olabilir.''';
    } else {
      return '''$userName, your AstroCartography map shows your energy points around the world.

Each planetary line indicates places where that planet's energy is strongest for you. Ascendant (AC) lines affect personal power and identity, Descendant (DC) lines affect relationships, Midheaven (MC) lines affect career, and Imum Coeli (IC) lines affect home and family matters.

Your power points are where multiple positive planetary energies intersect. These cities hold special opportunities for you.

Advice: Use this map as a reference when planning travel or considering relocation. Some places are ideal for career, while others may be more suitable for love or spiritual growth.''';
    }
  }

  /// Generate Electional Chart for finding auspicious times
  ElectionalChart generateElectionalChart({
    required ElectionalPurpose purpose,
    required DateTime startDate,
    required DateTime endDate,
    AppLanguage language = AppLanguage.tr,
  }) {
    final random = Random(startDate.millisecondsSinceEpoch + purpose.index);
    final favorableWindows = <ElectionalWindow>[];
    final unfavorableWindows = <ElectionalWindow>[];

    // Generate windows throughout the date range
    var currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      final isFavorable = random.nextDouble() > 0.4;
      final duration = Duration(hours: 2 + random.nextInt(6));

      final window = ElectionalWindow(
        start: currentDate,
        end: currentDate.add(duration),
        description: isFavorable
            ? _getFavorableDescription(purpose, random, language: language)
            : _getUnfavorableDescription(purpose, random, language: language),
        supportingAspects: _getAspects(
          purpose,
          isFavorable,
          random,
          language: language,
        ),
        score: isFavorable ? 60 + random.nextInt(40) : 20 + random.nextInt(40),
      );

      if (isFavorable) {
        favorableWindows.add(window);
      } else {
        unfavorableWindows.add(window);
      }

      currentDate = currentDate.add(Duration(hours: 8 + random.nextInt(16)));
    }

    // Sort by score
    favorableWindows.sort((a, b) => b.score.compareTo(a.score));

    final purposeName = purpose.localizedName(language);

    return ElectionalChart(
      purpose: purposeName,
      selectedDate: startDate,
      favorableWindows: favorableWindows.take(10).toList(),
      unfavorableWindows: unfavorableWindows.take(5).toList(),
      moonPhaseAdvice: _getMoonPhaseAdvice(
        purpose,
        startDate,
        language: language,
      ),
      retrogradeWarning: _getRetrogradeWarning(startDate, language: language),
      overallRecommendation: _getOverallRecommendation(
        purpose,
        favorableWindows,
        language: language,
      ),
      optimalScore: favorableWindows.isNotEmpty
          ? favorableWindows.first.score
          : 50,
    );
  }

  String _getFavorableDescription(
    ElectionalPurpose purpose,
    Random random, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final trDescriptions = {
      ElectionalPurpose.wedding: [
        'Venüs-Jüpiter üçgeni evlilik için muhteşem',
        'Ay yükselen burçta, duygusal uyum güçlü',
        'Güneş 7. evde, ortaklıklar destekleniyor',
      ],
      ElectionalPurpose.businessStart: [
        'Merkür güçlü konumda, iletişim ve sözleşmeler için ideal',
        'Jüpiter 10. evde, iş başarısı için mükemmel',
        'Mars enerji veriyor, girişimcilik destekleniyor',
      ],
      ElectionalPurpose.travel: [
        'Merkür-Jüpiter olumlu açıda, seyahat için güvenli',
        '9. ev aktif, uzak yolculuklar için ideal',
        'Ay sabit burçta, plan değişikliği olmaz',
      ],
      ElectionalPurpose.investment: [
        '2. ev ve 8. ev uyumlu, finansal kazançlar',
        'Jüpiter-Pluto güçlü açıda, büyük yatırımlar için',
        'Venüs 2. evde, maddi bereket potansiyeli',
      ],
    };

    final enDescriptions = {
      ElectionalPurpose.wedding: [
        'Venus-Jupiter trine is wonderful for marriage',
        'Moon in rising sign, emotional harmony is strong',
        'Sun in 7th house, partnerships are supported',
      ],
      ElectionalPurpose.businessStart: [
        'Mercury in strong position, ideal for communication and contracts',
        'Jupiter in 10th house, perfect for business success',
        'Mars is energizing, entrepreneurship is supported',
      ],
      ElectionalPurpose.travel: [
        'Mercury-Jupiter in positive aspect, safe for travel',
        '9th house is active, ideal for long journeys',
        'Moon in fixed sign, no plan changes',
      ],
      ElectionalPurpose.investment: [
        '2nd and 8th houses harmonious, financial gains',
        'Jupiter-Pluto in strong aspect, for big investments',
        'Venus in 2nd house, material abundance potential',
      ],
    };

    final descriptions = language == AppLanguage.tr
        ? trDescriptions
        : enDescriptions;
    final defaultDescs = language == AppLanguage.tr
        ? ['Genel olarak olumlu koşullar mevcut', 'Gezegen enerjileri uyumlu']
        : [
            'Generally favorable conditions present',
            'Planetary energies are harmonious',
          ];

    final purposeDescs = descriptions[purpose] ?? defaultDescs;
    return purposeDescs[random.nextInt(purposeDescs.length)];
  }

  String _getUnfavorableDescription(
    ElectionalPurpose purpose,
    Random random, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final trDescriptions = [
      'Ay boşlukta - önemli kararlar ertelenmeli',
      'Merkür retrosu etkili - sözleşmeler için riskli',
      'Mars-Satürn karesi - engellerle karşılaşılabilir',
      'Ay azalan fazda - yeni başlangıçlar için uygun değil',
      'Venüs zayıf konumda - ilişki konuları için dikkatli olun',
    ];

    final enDescriptions = [
      'Moon void of course - important decisions should be postponed',
      'Mercury retrograde in effect - risky for contracts',
      'Mars-Saturn square - obstacles may be encountered',
      'Moon in waning phase - not suitable for new beginnings',
      'Venus in weak position - be careful with relationship matters',
    ];

    final descriptions = language == AppLanguage.tr
        ? trDescriptions
        : enDescriptions;
    return descriptions[random.nextInt(descriptions.length)];
  }

  List<String> _getAspects(
    ElectionalPurpose purpose,
    bool isFavorable,
    Random random, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final trFavorable = [
      'Venüs üçgen Jüpiter',
      'Ay altıgen Güneş',
      'Merkür üçgen Uranüs',
      'Güneş kavuşum Jüpiter',
      'Venüs altıgen Mars',
    ];
    final enFavorable = [
      'Venus trine Jupiter',
      'Moon sextile Sun',
      'Mercury trine Uranus',
      'Sun conjunct Jupiter',
      'Venus sextile Mars',
    ];

    final trUnfavorable = [
      'Mars kare Satürn',
      'Ay karşıt Pluto',
      'Merkür kare Neptün',
      'Güneş karşıt Satürn',
    ];
    final enUnfavorable = [
      'Mars square Saturn',
      'Moon opposite Pluto',
      'Mercury square Neptune',
      'Sun opposite Saturn',
    ];

    final favorable = language == AppLanguage.tr ? trFavorable : enFavorable;
    final unfavorable = language == AppLanguage.tr
        ? trUnfavorable
        : enUnfavorable;

    final source = isFavorable ? favorable : unfavorable;
    final count = 2 + random.nextInt(3);
    final result = <String>[];

    for (int i = 0; i < count; i++) {
      final aspect = source[random.nextInt(source.length)];
      if (!result.contains(aspect)) {
        result.add(aspect);
      }
    }

    return result;
  }

  String _getMoonPhaseAdvice(
    ElectionalPurpose purpose,
    DateTime date, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final dayOfMonth = date.day;
    final purposeName = purpose.localizedName(language);

    if (language == AppLanguage.tr) {
      if (dayOfMonth <= 7) {
        return 'Yeni Ay dönemi: Yeni başlangıçlar için mükemmel. $purposeName için tohum ekme zamanı.';
      } else if (dayOfMonth <= 15) {
        return 'Büyüyen Ay: Projeler momentum kazanır. $purposeName için aksiyona geçme zamanı.';
      } else if (dayOfMonth <= 22) {
        return 'Dolunay dönemi: Sonuçlar netleşir. Başlamış projeleri tamamlamak için ideal.';
      } else {
        return 'Azalan Ay: Planlama ve değerlendirme zamanı. Yeni $purposeName için bir sonraki yeni ayı bekleyin.';
      }
    } else {
      if (dayOfMonth <= 7) {
        return 'New Moon period: Perfect for new beginnings. Time to plant seeds for $purposeName.';
      } else if (dayOfMonth <= 15) {
        return 'Waxing Moon: Projects gain momentum. Time to take action for $purposeName.';
      } else if (dayOfMonth <= 22) {
        return 'Full Moon period: Results become clear. Ideal for completing started projects.';
      } else {
        return 'Waning Moon: Time for planning and evaluation. Wait for the next new moon for new $purposeName.';
      }
    }
  }

  String _getRetrogradeWarning(
    DateTime date, {
    AppLanguage language = AppLanguage.tr,
  }) {
    // Simplified retrograde check based on month
    final month = date.month;

    if (language == AppLanguage.tr) {
      if (month == 1 || month == 5 || month == 9) {
        return '⚠️ Merkür retrosu dönemine dikkat! Sözleşmeleri iki kez kontrol edin, iletişim aksaklıklarına hazırlıklı olun.';
      } else if (month == 7 || month == 12) {
        return '⚠️ Venüs retrosu: İlişki kararları için dikkatli olun. Eski bağlantılar gündeme gelebilir.';
      }
      return '✓ Şu anda önemli bir retro dönemi yok. Planlanan aktiviteler için uygun.';
    } else {
      if (month == 1 || month == 5 || month == 9) {
        return '⚠️ Mercury retrograde period! Double-check contracts, be prepared for communication disruptions.';
      } else if (month == 7 || month == 12) {
        return '⚠️ Venus retrograde: Be careful with relationship decisions. Old connections may come up.';
      }
      return '✓ No significant retrograde period currently. Suitable for planned activities.';
    }
  }

  String _getOverallRecommendation(
    ElectionalPurpose purpose,
    List<ElectionalWindow> windows, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final purposeName = purpose.localizedName(language);

    if (windows.isEmpty) {
      return language == AppLanguage.tr
          ? 'Seçilen tarih aralığında uygun zaman penceresi bulunamadı. Farklı tarihler denemeyi düşünün.'
          : 'No suitable time window found in the selected date range. Consider trying different dates.';
    }

    final best = windows.first;
    final dateStr = '${best.start.day}/${best.start.month}/${best.start.year}';
    final timeStr =
        '${best.start.hour.toString().padLeft(2, '0')}:${best.start.minute.toString().padLeft(2, '0')}';

    if (language == AppLanguage.tr) {
      return '$purposeName için en uygun zaman: $dateStr saat $timeStr. Bu zaman diliminde gezegen enerjileri sizin lehinize çalışıyor. Skor: ${best.score}/100. ${best.description}';
    } else {
      return 'Most suitable time for $purposeName: $dateStr at $timeStr. Planetary energies are working in your favor during this time. Score: ${best.score}/100. ${best.description}';
    }
  }

  /// Generate Draconic Chart for soul-level astrology
  DraconicChart generateDraconicChart({
    required DateTime birthDate,
    required ZodiacSign natalSun,
    required ZodiacSign natalMoon,
    required ZodiacSign natalAscendant,
    AppLanguage language = AppLanguage.tr,
  }) {
    final random = Random(birthDate.millisecondsSinceEpoch);

    // Draconic chart uses North Node at 0° Aries as reference
    // This shifts all positions by the natal North Node position
    final nodeOffset = random.nextInt(12);

    final draconicSun = ZodiacSign.values[(natalSun.index + nodeOffset) % 12];
    final draconicMoon = ZodiacSign.values[(natalMoon.index + nodeOffset) % 12];
    final draconicAscendant =
        ZodiacSign.values[(natalAscendant.index + nodeOffset) % 12];

    final planets = _generateDraconicPlanets(
      birthDate,
      nodeOffset,
      random,
      language: language,
    );

    return DraconicChart(
      birthDate: birthDate,
      draconicSun: draconicSun,
      draconicMoon: draconicMoon,
      draconicAscendant: draconicAscendant,
      planets: planets,
      soulPurpose: _getSoulPurpose(draconicSun, language: language),
      karmicLessons: _getKarmicLessons(
        draconicMoon,
        draconicAscendant,
        language: language,
      ),
      spiritualGifts: _getSpiritualGifts(planets, language: language),
      pastLifeIndicators: _getPastLifeIndicators(
        draconicSun,
        draconicMoon,
        language: language,
      ),
      evolutionaryPath: _getEvolutionaryPath(
        draconicAscendant,
        language: language,
      ),
    );
  }

  List<DraconicPlanet> _generateDraconicPlanets(
    DateTime birthDate,
    int offset,
    Random random, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final trPlanetNames = [
      'Güneş',
      'Ay',
      'Merkür',
      'Venüs',
      'Mars',
      'Jüpiter',
      'Satürn',
      'Uranüs',
      'Neptün',
      'Pluto',
    ];
    final enPlanetNames = [
      'Sun',
      'Moon',
      'Mercury',
      'Venus',
      'Mars',
      'Jupiter',
      'Saturn',
      'Uranus',
      'Neptune',
      'Pluto',
    ];
    final planetNames = language == AppLanguage.tr
        ? trPlanetNames
        : enPlanetNames;

    return planetNames.map((name) {
      final signIndex = (random.nextInt(12) + offset) % 12;
      final sign = ZodiacSign.values[signIndex];
      final house = 1 + random.nextInt(12);
      final degree = random.nextDouble() * 30;

      return DraconicPlanet(
        planet: name,
        sign: sign,
        degree: degree,
        house: house,
        interpretation: _getDraconicPlanetInterpretation(
          name,
          sign,
          house,
          language: language,
        ),
      );
    }).toList();
  }

  String _getDraconicPlanetInterpretation(
    String planet,
    ZodiacSign sign,
    int house, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final signName = language == AppLanguage.tr ? sign.nameTr : sign.name;

    if (language == AppLanguage.tr) {
      final interpretations = {
        'Güneş':
            'Ruhunuzun özü $signName enerjisi taşıyor. $house. ev konumu, yaşam amacınızın bu alanla derinden bağlantılı olduğunu gösterir.',
        'Ay':
            'Ruhsal duygusal doğanız $signName kalitelerini yansıtıyor. $house. evde, geçmiş yaşam duygusal kalıplarınız bu alanda açığa çıkıyor.',
        'Venüs':
            'Ruhsal sevgi diliniz $signName üzerinden ifade buluyor. $house. ev, karmik ilişki temalarınızı işaret ediyor.',
        'Mars':
            'Ruhsal irade gücünüz $signName enerjisiyle besleniyor. $house. evde, geçmiş yaşam mücadelelerinizin izleri var.',
        'Jüpiter':
            'Ruhsal bilgeliğiniz $signName felsefesini taşıyor. $house. ev, spiritüel büyüme alanınızı gösteriyor.',
      };
      return interpretations[planet] ??
          '$signName burcundaki $planet, ruhsal yolculuğunuzun önemli bir parçası. $house. ev konumu, bu enerjinin yaşamınızda nasıl aktif olduğunu gösterir.';
    } else {
      final interpretations = {
        'Sun':
            'Your soul essence carries $signName energy. The $house house position shows your life purpose is deeply connected to this area.',
        'Moon':
            'Your spiritual emotional nature reflects $signName qualities. In the $house house, your past life emotional patterns emerge in this area.',
        'Venus':
            'Your spiritual love language expresses through $signName. The $house house indicates your karmic relationship themes.',
        'Mars':
            'Your spiritual willpower is nourished by $signName energy. In the $house house, there are traces of your past life struggles.',
        'Jupiter':
            'Your spiritual wisdom carries $signName philosophy. The $house house shows your area of spiritual growth.',
      };
      return interpretations[planet] ??
          '$planet in $signName is an important part of your spiritual journey. The $house house position shows how this energy is active in your life.';
    }
  }

  String _getSoulPurpose(
    ZodiacSign draconicSun, {
    AppLanguage language = AppLanguage.tr,
  }) {
    if (language == AppLanguage.tr) {
      final purposes = {
        ZodiacSign.aries:
            'Ruhunuz cesaret ve öncülük için buraya geldi. Yeni yollar açmak ve başkalarına ilham vermek sizin kutsal göreviniz.',
        ZodiacSign.taurus:
            'Ruhunuz değer ve istikrar yaratmak için enkarne oldu. Güzellik ve bolluk manifestasyonu sizin spiritüel hediyeniz.',
        ZodiacSign.gemini:
            'Ruhunuz iletişim köprüleri kurmak için burada. Bilgiyi yaymak ve bağlantılar oluşturmak kutsal amacınız.',
        ZodiacSign.cancer:
            'Ruhunuz şifa ve koruma için geldi. Başkalarını beslemek ve güvenli alanlar yaratmak sizin spiritüel misyonunuz.',
        ZodiacSign.leo:
            'Ruhunuz yaratıcı ifade ve liderlik için enkarne oldu. Işığınızla başkalarını aydınlatmak kutsal hediyeniz.',
        ZodiacSign.virgo:
            'Ruhunuz hizmet ve iyileştirme için burada. Mükemmelliği arayış ve başkalarına yardım etmek spiritüel amacınız.',
        ZodiacSign.libra:
            'Ruhunuz denge ve uyum yaratmak için geldi. İlişkilerde barış ve adalet getirmek kutsal göreviniz.',
        ZodiacSign.scorpio:
            'Ruhunuz dönüşüm ve şifa için enkarne oldu. Derin hakikatleri ortaya çıkarmak ve başkalarını dönüştürmek misyonunuz.',
        ZodiacSign.sagittarius:
            'Ruhunuz bilgelik arayışı ve öğretme için burada. Yüksek gerçekleri paylaşmak spiritüel hediyeniz.',
        ZodiacSign.capricorn:
            'Ruhunuz kalıcı yapılar kurmak için geldi. Topluma katkı sağlayan başarılar kutsal amacınız.',
        ZodiacSign.aquarius:
            'Ruhunuz insanlığa hizmet ve yenilik için enkarne oldu. Geleceği şekillendirmek spiritüel misyonunuz.',
        ZodiacSign.pisces:
            'Ruhunuz evrensel şefkat ve spiritüel birlik için burada. Sınırları aşan sevgi yaymak kutsal hediyeniz.',
      };
      return purposes[draconicSun] ??
          'Ruhunuz benzersiz bir amaçla bu dünyaya geldi.';
    } else {
      final purposes = {
        ZodiacSign.aries:
            'Your soul came here for courage and pioneering. Opening new paths and inspiring others is your sacred duty.',
        ZodiacSign.taurus:
            'Your soul incarnated to create value and stability. Beauty and abundance manifestation is your spiritual gift.',
        ZodiacSign.gemini:
            'Your soul is here to build bridges of communication. Spreading knowledge and creating connections is your sacred purpose.',
        ZodiacSign.cancer:
            'Your soul came for healing and protection. Nurturing others and creating safe spaces is your spiritual mission.',
        ZodiacSign.leo:
            'Your soul incarnated for creative expression and leadership. Illuminating others with your light is your sacred gift.',
        ZodiacSign.virgo:
            'Your soul is here for service and healing. The pursuit of perfection and helping others is your spiritual purpose.',
        ZodiacSign.libra:
            'Your soul came to create balance and harmony. Bringing peace and justice to relationships is your sacred duty.',
        ZodiacSign.scorpio:
            'Your soul incarnated for transformation and healing. Revealing deep truths and transforming others is your mission.',
        ZodiacSign.sagittarius:
            'Your soul is here for wisdom seeking and teaching. Sharing higher truths is your spiritual gift.',
        ZodiacSign.capricorn:
            'Your soul came to build lasting structures. Achievements that contribute to society is your sacred purpose.',
        ZodiacSign.aquarius:
            'Your soul incarnated to serve humanity and innovate. Shaping the future is your spiritual mission.',
        ZodiacSign.pisces:
            'Your soul is here for universal compassion and spiritual unity. Spreading love that transcends boundaries is your sacred gift.',
      };
      return purposes[draconicSun] ??
          'Your soul came to this world with a unique purpose.';
    }
  }

  String _getKarmicLessons(
    ZodiacSign moon,
    ZodiacSign ascendant, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final moonName = language == AppLanguage.tr ? moon.nameTr : moon.name;
    final ascendantName = language == AppLanguage.tr
        ? ascendant.nameTr
        : ascendant.name;
    final moonElement = language == AppLanguage.tr
        ? moon.element.nameTr
        : moon.element.name;
    final ascendantModality = language == AppLanguage.tr
        ? ascendant.modality.nameTr
        : ascendant.modality.name;

    if (language == AppLanguage.tr) {
      return '''Drakonik Ay'ınız $moonName burcunda, duygusal karmik kalıplarınızı gösteriyor.
Geçmiş yaşamlardan getirdiğiniz duygusal tepkiler ve bağlanma biçimleri bu burç üzerinden ifade buluyor.

Drakonik Yükseleniz $ascendantName, bu yaşamda geliştirmeniz gereken ruhsal nitelikleri işaret ediyor.
Bu enerjiyi benimsemek, ruhsal evrriminiz için kritik önem taşıyor.

Karmik dersleriniz:
1. $moonElement elementinin duygusal dengesi
2. $ascendantModality modalitesinin yaşam yaklaşımı
3. $moonName ve $ascendantName enerjilerinin entegrasyonu''';
    } else {
      return '''Your Draconic Moon in $moonName shows your emotional karmic patterns.
Emotional reactions and attachment patterns brought from past lives are expressed through this sign.

Your Draconic Ascendant $ascendantName indicates the spiritual qualities you need to develop in this life.
Embracing this energy is critical for your spiritual evolution.

Your karmic lessons:
1. Emotional balance of the $moonElement element
2. Life approach of the $ascendantModality modality
3. Integration of $moonName and $ascendantName energies''';
    }
  }

  String _getSpiritualGifts(
    List<DraconicPlanet> planets, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final gifts = <String>[];

    for (final planet in planets.take(5)) {
      final signName = language == AppLanguage.tr
          ? planet.sign.nameTr
          : planet.sign.name;
      if (planet.house == 9 || planet.house == 12) {
        final giftType = language == AppLanguage.tr
            ? 'Spiritüel sezgi'
            : 'Spiritual intuition';
        gifts.add('${planet.planet} $signName - $giftType');
      }
      if (planet.house == 5 || planet.house == 1) {
        final giftType = language == AppLanguage.tr
            ? 'Yaratıcı güç'
            : 'Creative power';
        gifts.add('${planet.planet} $signName - $giftType');
      }
    }

    if (gifts.isEmpty) {
      if (language == AppLanguage.tr) {
        gifts.add('Evrensel şifa enerjisi');
        gifts.add('Empati ve anlayış');
      } else {
        gifts.add('Universal healing energy');
        gifts.add('Empathy and understanding');
      }
    }

    final title = language == AppLanguage.tr
        ? 'Spiritüel hediyeleriniz:'
        : 'Your spiritual gifts:';
    final footer = language == AppLanguage.tr
        ? 'Bu yetenekler geçmiş yaşamlardan taşıdığınız bilgeliği temsil eder.'
        : 'These abilities represent wisdom carried from past lives.';

    return '$title\n\n${gifts.map((g) => '• $g').join('\n')}\n\n$footer';
  }

  String _getPastLifeIndicators(
    ZodiacSign sun,
    ZodiacSign moon, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final sunName = language == AppLanguage.tr ? sun.nameTr : sun.name;
    final moonName = language == AppLanguage.tr ? moon.nameTr : moon.name;
    final sunElement = language == AppLanguage.tr
        ? sun.element.nameTr
        : sun.element.name;
    final moonElement = language == AppLanguage.tr
        ? moon.element.nameTr
        : moon.element.name;
    final moonModality = language == AppLanguage.tr
        ? moon.modality.nameTr
        : moon.modality.name;

    if (language == AppLanguage.tr) {
      return '''Drakonik haritanız, ruhunuzun geçmiş yaşam deneyimlerine dair ipuçları taşıyor.

$sunName Güneşi: Geçmiş yaşamlarda liderlik veya yaratıcı ifade rolleri üstlenmiş olabilirsiniz.
$sunElement elementi bu yaşamların genel tonunu gösteriyor.

$moonName Ay'ı: Duygusal kalıplarınız $moonElement elementi yaşamlarından geliyor.
Aile ve ilişki dinamikleriniz bu geçmişle şekillendi.

Güçlü göstergeler:
• ${sun.rulingPlanet} enerjisiyle bağlantılı yaşamlar
• $moonModality modalitesi dönemlerinde önemli gelişmeler
• Ruhsal evrim $sunName-$moonName ekseni üzerinden sürmüş''';
    } else {
      return '''Your Draconic chart carries clues about your soul's past life experiences.

$sunName Sun: You may have taken on leadership or creative expression roles in past lives.
The $sunElement element shows the general tone of these lives.

$moonName Moon: Your emotional patterns come from $moonElement element lives.
Your family and relationship dynamics were shaped by this past.

Strong indicators:
• Lives connected to ${sun.rulingPlanet} energy
• Important developments during $moonModality modality periods
• Spiritual evolution continued through the $sunName-$moonName axis''';
    }
  }

  String _getEvolutionaryPath(
    ZodiacSign ascendant, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final ascendantName = language == AppLanguage.tr
        ? ascendant.nameTr
        : ascendant.name;
    final element = language == AppLanguage.tr
        ? ascendant.element.nameTr
        : ascendant.element.name;
    final modality = language == AppLanguage.tr
        ? ascendant.modality.nameTr
        : ascendant.modality.name;
    final traits = ascendant.traits
        .take(2)
        .join(language == AppLanguage.tr ? ' ve ' : ' and ');

    if (language == AppLanguage.tr) {
      return '''Drakonik Yükseleniz $ascendantName, bu yaşamdaki evrimsel yönünüzü gösteriyor.

Ruhunuz $element elementi üzerinden deneyim kazanmak istiyor.
$modality modalitesi, bu yolculuktaki yaklaşımınızı belirliyor.

Evrimsel hedefler:
1. $traits niteliklerini geliştirmek
2. ${ascendant.rulingPlanet} gezegeninin derslerini öğrenmek
3. $ascendantName arketipini bilinçli olarak yaşamak

Bu yol kolay olmayabilir, ama ruhunuzun büyümesi için gerekli.
Her zorluk, daha yüksek bir bilinç seviyesine adımdır.''';
    } else {
      return '''Your Draconic Ascendant $ascendantName shows your evolutionary direction in this life.

Your soul wants to gain experience through the $element element.
The $modality modality determines your approach on this journey.

Evolutionary goals:
1. Develop $traits qualities
2. Learn the lessons of ${ascendant.rulingPlanet}
3. Consciously live the $ascendantName archetype

This path may not be easy, but it is necessary for your soul's growth.
Every challenge is a step towards a higher level of consciousness.''';
    }
  }

  /// Generate Extended Asteroid Chart
  AsteroidChart generateAsteroidChart({
    required DateTime birthDate,
    required ZodiacSign sunSign,
    AppLanguage language = AppLanguage.tr,
  }) {
    final random = Random(birthDate.millisecondsSinceEpoch);

    final trAspects = [
      'Güneş ile üçgen',
      'Ay ile altıgen',
      'Venüs ile kavuşum',
    ];
    final enAspects = [
      'Trine with Sun',
      'Sextile with Moon',
      'Conjunction with Venus',
    ];
    final aspectList = language == AppLanguage.tr ? trAspects : enAspects;

    final asteroids = Asteroid.values.map((asteroid) {
      final signIndex = (sunSign.index + random.nextInt(6) - 3 + 12) % 12;
      final sign = ZodiacSign.values[signIndex];
      final house = 1 + random.nextInt(12);
      final degree = random.nextDouble() * 30;

      final aspects = <String>[];
      if (random.nextBool()) aspects.add(aspectList[0]);
      if (random.nextBool()) aspects.add(aspectList[1]);
      if (random.nextBool()) aspects.add(aspectList[2]);

      return AsteroidPosition(
        asteroid: asteroid,
        sign: sign,
        degree: degree,
        house: house,
        aspects: aspects,
        interpretation: _getAsteroidInterpretation(
          asteroid,
          sign,
          house,
          language: language,
        ),
      );
    }).toList();

    final chironPos = asteroids.firstWhere(
      (a) => a.asteroid == Asteroid.chiron,
    );
    final ceresPos = asteroids.firstWhere((a) => a.asteroid == Asteroid.ceres);
    final pallasPos = asteroids.firstWhere(
      (a) => a.asteroid == Asteroid.pallas,
    );
    final junoPos = asteroids.firstWhere((a) => a.asteroid == Asteroid.juno);
    final vestaPos = asteroids.firstWhere((a) => a.asteroid == Asteroid.vesta);

    return AsteroidChart(
      birthDate: birthDate,
      asteroids: asteroids,
      chiron: _getChironAnalysis(chironPos, language: language),
      ceres: _getCeresAnalysis(ceresPos, language: language),
      pallas: _getPallasAnalysis(pallasPos, language: language),
      juno: _getJunoAnalysis(junoPos, language: language),
      vesta: _getVestaAnalysis(vestaPos, language: language),
      overallAnalysis: _getOverallAsteroidAnalysis(
        asteroids,
        language: language,
      ),
    );
  }

  String _getAsteroidInterpretation(
    Asteroid asteroid,
    ZodiacSign sign,
    int house, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final asteroidName = language == AppLanguage.tr
        ? asteroid.nameTr
        : asteroid.name;
    final signName = language == AppLanguage.tr ? sign.nameTr : sign.name;
    final elementName = language == AppLanguage.tr
        ? sign.element.nameTr
        : sign.element.name;
    final theme = _getAsteroidTheme(asteroid, language);

    if (language == AppLanguage.tr) {
      return '$asteroidName $signName burcunda, $house. evde. $theme Bu konum, $elementName elementi üzerinden ifade buluyor ve $house. ev konularında özellikle aktif.';
    } else {
      return '$asteroidName in $signName, in the $house house. $theme This position expresses through the $elementName element and is particularly active in $house house matters.';
    }
  }

  String _getAsteroidTheme(Asteroid asteroid, AppLanguage language) {
    if (language == AppLanguage.tr) return asteroid.theme;

    final enThemes = {
      Asteroid.chiron: 'Wounded healer - Deep wounds transforming into healing',
      Asteroid.ceres: 'Motherhood, nurturing, growth cycles',
      Asteroid.pallas: 'Creative intelligence, strategy, pattern recognition',
      Asteroid.juno: 'Commitment, marriage, partner dynamics',
      Asteroid.vesta: 'Sacred flame, focus, dedication',
      Asteroid.eros: 'Erotic passion, life force, creative energy',
      Asteroid.psyche: 'Soul, transformation, spiritual growth',
      Asteroid.lilith: 'Shadow self, suppressed power, liberation',
      Asteroid.nessus: 'Intergenerational patterns, cycles to break',
      Asteroid.pholus: 'Sudden changes, small triggers big results',
    };
    return enThemes[asteroid] ?? 'Special cosmic influence';
  }

  String _getChironAnalysis(
    AsteroidPosition pos, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final signName = language == AppLanguage.tr
        ? pos.sign.nameTr
        : pos.sign.name;
    final elementName = language == AppLanguage.tr
        ? pos.sign.element.nameTr
        : pos.sign.element.name;

    if (language == AppLanguage.tr) {
      return '''Kiron - Yaralı Şifacı

$signName burcunda, ${pos.house}. evde.

Kiron'unuz derin yaranızı ve şifa potansiyelinizi gösteriyor. $signName enerjisi, yaranın doğasını belirliyor - $elementName elementi üzerinden deneyimlenen acılar.

${pos.house}. ev konumu, bu yaranın hayatınızın hangi alanında en çok hissedildiğini gösterir. Ancak aynı zamanda, başkalarına şifa getirme kapasitenizin de bu alanda yoğunlaştığı anlamına gelir.

Şifa yolculuğunuz, yaranızı kabullenmek ve bu deneyimi bilgeliğe dönüştürmekle başlar. Kiron'unuz ne kadar güçlüyse, şifacılık potansiyeliniz de o kadar büyüktür.''';
    } else {
      return '''Chiron - The Wounded Healer

In $signName, in the ${pos.house} house.

Your Chiron shows your deep wound and healing potential. $signName energy determines the nature of the wound - pain experienced through the $elementName element.

The ${pos.house} house position shows in which area of your life this wound is most felt. However, it also means your capacity to bring healing to others is also concentrated in this area.

Your healing journey begins with accepting your wound and transforming this experience into wisdom. The stronger your Chiron, the greater your healing potential.''';
    }
  }

  String _getCeresAnalysis(
    AsteroidPosition pos, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final signName = language == AppLanguage.tr
        ? pos.sign.nameTr
        : pos.sign.name;
    final modalityName = language == AppLanguage.tr
        ? pos.sign.modality.nameTr
        : pos.sign.modality.name;

    if (language == AppLanguage.tr) {
      return '''Ceres - Besleme ve Bakım

$signName burcunda, ${pos.house}. evde.

Ceres'iniz nasıl beslendiğinizi ve nasıl beslediğinizi gösterir. $signName enerjisi, bakım stilinizi belirler - $modalityName bir yaklaşımla sevginizi ifade edersiniz.

${pos.house}. ev konumu, bakım ihtiyaçlarınızın ve verme kapasitenizin odaklandığı yaşam alanını gösterir. Annelik arketipi bu evde en güçlü şekilde hissedilir.

Ceres aynı zamanda kayıp ve geri dönüş döngülerini de temsil eder. Bu konumdaki deneyimleriniz, bırakma ve tekrar kabullenme derslerini içerir.''';
    } else {
      return '''Ceres - Nurturing and Care

In $signName, in the ${pos.house} house.

Your Ceres shows how you are nurtured and how you nurture. $signName energy determines your care style - you express your love with a $modalityName approach.

The ${pos.house} house position shows the life area where your care needs and giving capacity are focused. The motherhood archetype is felt most strongly in this house.

Ceres also represents loss and return cycles. Your experiences in this position include lessons of letting go and accepting again.''';
    }
  }

  String _getPallasAnalysis(
    AsteroidPosition pos, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final signName = language == AppLanguage.tr
        ? pos.sign.nameTr
        : pos.sign.name;
    final elementName = language == AppLanguage.tr
        ? pos.sign.element.nameTr
        : pos.sign.element.name;

    if (language == AppLanguage.tr) {
      return '''Pallas Athena - Bilgelik ve Strateji

$signName burcunda, ${pos.house}. evde.

Pallas'ınız yaratıcı zekanızı ve stratejik düşünme kapasitenizi gösterir. $signName enerjisi, problem çözme stilinizi belirler - $elementName elementi üzerinden çözümler üretirsiniz.

${pos.house}. ev konumu, zeka ve bilgeliğinizin en çok parladığı alanı gösterir. Politik becerileriniz ve örüntü tanıma yeteneğiniz bu evde yoğunlaşır.

Pallas aynı zamanda baba-kız dinamiğini ve kadınsı bilgeliği temsil eder. Bu konum, otoriteyle ilişkiniz hakkında da ipuçları verir.''';
    } else {
      return '''Pallas Athena - Wisdom and Strategy

In $signName, in the ${pos.house} house.

Your Pallas shows your creative intelligence and strategic thinking capacity. $signName energy determines your problem-solving style - you generate solutions through the $elementName element.

The ${pos.house} house position shows the area where your intelligence and wisdom shine most. Your political skills and pattern recognition abilities concentrate in this house.

Pallas also represents father-daughter dynamics and feminine wisdom. This position also gives clues about your relationship with authority.''';
    }
  }

  String _getJunoAnalysis(
    AsteroidPosition pos, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final signName = language == AppLanguage.tr
        ? pos.sign.nameTr
        : pos.sign.name;
    final modalityName = language == AppLanguage.tr
        ? pos.sign.modality.nameTr
        : pos.sign.modality.name;

    if (language == AppLanguage.tr) {
      return '''Juno - Evlilik ve Bağlılık

$signName burcunda, ${pos.house}. evde.

Juno'nuz ideal eş konseptinizi ve bağlılık biçiminizi gösterir. $signName enerjisi, evlilikte ne aradığınızı belirler - $modalityName bir partner dinamiği tercih edersiniz.

${pos.house}. ev konumu, eş bulma ve evlilik konularının hayatınızın hangi alanıyla bağlantılı olduğunu gösterir. Sadakat ve güven temaları bu evde odaklanır.

Juno güçlü veya zorlu açılarda, ilişkilerde güç dengeleri ve eşitlik mücadeleleri gündeme gelebilir. Sağlıklı ortaklıklar için bu enerjinin bilinçli çalışılması önerilir.''';
    } else {
      return '''Juno - Marriage and Commitment

In $signName, in the ${pos.house} house.

Your Juno shows your ideal spouse concept and commitment style. $signName energy determines what you seek in marriage - you prefer a $modalityName partner dynamic.

The ${pos.house} house position shows which area of your life is connected to finding a spouse and marriage matters. Loyalty and trust themes focus in this house.

With strong or challenging Juno aspects, power balances and equality struggles may come up in relationships. Conscious work with this energy is recommended for healthy partnerships.''';
    }
  }

  String _getVestaAnalysis(
    AsteroidPosition pos, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final signName = language == AppLanguage.tr
        ? pos.sign.nameTr
        : pos.sign.name;
    final elementName = language == AppLanguage.tr
        ? pos.sign.element.nameTr
        : pos.sign.element.name;

    if (language == AppLanguage.tr) {
      return '''Vesta - Kutsal Alev ve Adanmışlık

$signName burcunda, ${pos.house}. evde.

Vesta'nız neye adadığınızı ve kutsal ateşinizin nerede yandığını gösterir. $signName enerjisi, adanmışlık stilinizi belirler - $elementName elementi üzerinden hizmet verirsiniz.

${pos.house}. ev konumu, en derin odaklanma ve kendini adama alanınızı gösterir. Burada cinsellik ve maneviyat iç içe geçebilir.

Vesta aynı zamanda yalnızlık ihtiyacını ve kendi içinize çekilme dönemlerini temsil eder. Bu konum, spiritüel pratikleriniz ve ritüelleriniz hakkında bilgi verir.''';
    } else {
      return '''Vesta - Sacred Flame and Devotion

In $signName, in the ${pos.house} house.

Your Vesta shows what you are devoted to and where your sacred fire burns. $signName energy determines your devotion style - you serve through the $elementName element.

The ${pos.house} house position shows your deepest focus and self-dedication area. Here sexuality and spirituality may intertwine.

Vesta also represents the need for solitude and periods of withdrawal into yourself. This position provides information about your spiritual practices and rituals.''';
    }
  }

  String _getOverallAsteroidAnalysis(
    List<AsteroidPosition> asteroids, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final elements = <Element, int>{};
    for (final pos in asteroids) {
      elements[pos.sign.element] = (elements[pos.sign.element] ?? 0) + 1;
    }

    final dominantElement = elements.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    final elementName = language == AppLanguage.tr
        ? dominantElement.nameTr
        : dominantElement.name;

    if (language == AppLanguage.tr) {
      return '''Asteroid Haritası Genel Analizi

Asteroidleriniz, ana gezegenlerin ötesinde kişiliğinizin daha ince katmanlarını ortaya koyar. Bu küçük gök cisimleri, arketipsel temaları ve ruhsal dersleri temsil eder.

Baskın element: $elementName
Bu, asteroidlerinizin genel olarak $elementName enerjisi üzerinden ifade bulduğunu gösterir. ${dominantElement.symbol} elementi, şifa, bakım, bilgelik ve adanmışlık temalarınızda belirleyicidir.

Kiron-Ceres ilişkisi, yaralanma ve iyileşme döngünüzü gösterir.
Pallas-Vesta ilişkisi, bilgelik ve adanmışlık arasındaki dengenizi yansıtır.
Juno'nun konumu, ideal partner dinamiklerinizi ve bağlılık kalıplarınızı açıklar.

Bu asteroidlerle çalışmak, kendinizi daha derinden anlamanıza ve spiritüel gelişiminizi hızlandırmanıza yardımcı olur.''';
    } else {
      return '''Asteroid Chart Overall Analysis

Your asteroids reveal finer layers of your personality beyond the main planets. These small celestial bodies represent archetypal themes and spiritual lessons.

Dominant element: $elementName
This shows that your asteroids generally express through $elementName energy. The ${dominantElement.symbol} element is determining in your healing, nurturing, wisdom and devotion themes.

The Chiron-Ceres relationship shows your wounding and healing cycle.
The Pallas-Vesta relationship reflects the balance between wisdom and devotion.
Juno's position explains your ideal partner dynamics and commitment patterns.

Working with these asteroids helps you understand yourself more deeply and accelerate your spiritual development.''';
    }
  }
}
