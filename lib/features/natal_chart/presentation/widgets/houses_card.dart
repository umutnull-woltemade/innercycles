import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/house.dart';
import '../../../../data/models/natal_chart.dart';
import '../../../../data/models/planet.dart';
import '../../../../data/models/zodiac_sign.dart' as zodiac;

class HousesCard extends StatelessWidget {
  final NatalChart chart;

  const HousesCard({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    if (chart.houses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: Colors.white.withAlpha(25)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.textMuted,
              size: 48,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Ev Hesaplaması İçin Doğum Saati Gerekli',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Evlerin hesaplanabilmesi için doğum saati ve yeri bilgisi gereklidir. Lütfen profil ayarlarından bu bilgileri ekleyin.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Group houses by type
    final angularHouses = chart.houses.where((h) => h.house.isAngular).toList();
    final succedentHouses = chart.houses
        .where((h) => h.house.isSuccedent)
        .toList();
    final cadentHouses = chart.houses.where((h) => h.house.isCadent).toList();

    return Column(
      children: [
        _buildHouseTypeSection(
          context,
          'Açısal Evler',
          'En güçlü ve aktif evler (1, 4, 7, 10)',
          angularHouses,
          AppColors.starGold,
          0,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildHouseTypeSection(
          context,
          'Ardıl Evler',
          'Kaynaklar ve değerler (2, 5, 8, 11)',
          succedentHouses,
          AppColors.auroraStart,
          100,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildHouseTypeSection(
          context,
          'Dusen Evler',
          'Ogrenme ve uyum (3, 6, 9, 12)',
          cadentHouses,
          AppColors.auroraEnd,
          200,
        ),
      ],
    );
  }

  Widget _buildHouseTypeSection(
    BuildContext context,
    String title,
    String subtitle,
    List<HouseCusp> houses,
    Color accentColor,
    int delayMs,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: accentColor.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: accentColor),
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),
          ...houses.asMap().entries.map((entry) {
            final index = entry.key;
            final house = entry.value;
            final planetsInHouse = chart.planetsInHouse(house.house);
            return _HouseRow(
              house: house,
              planetsInHouse: planetsInHouse.cast<PlanetPosition>(),
              isLast: index == houses.length - 1,
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: delayMs.ms, duration: 400.ms);
  }
}

class _HouseRow extends StatefulWidget {
  final HouseCusp house;
  final List<PlanetPosition> planetsInHouse;
  final bool isLast;

  const _HouseRow({
    required this.house,
    required this.planetsInHouse,
    this.isLast = false,
  });

  @override
  State<_HouseRow> createState() => _HouseRowState();
}

class _HouseRowState extends State<_HouseRow> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
  }

  // Ev için detaylı ezoterik yorum
  String _getEsotericHouseInterpretation(
    int houseNumber,
    zodiac.ZodiacSign sign,
  ) {
    final interpretations = {
      1: {
        'title': 'Benliğin Kapısı',
        'esoteric':
            'Birinci ev, ruhunun bu dünyaya ilk dokunuşudur - ilk nefes, ilk bakış, ilk "ben" duygusu. Bu ev senin "kozmik masken"dir; ruhunun dünyaya kendini nasıl sunmayı seçtiğini gösterir. ${sign.nameTr} burada yükselen olarak, hayata yaklaşımını, fiziksel görünümünü ve başkalarının seni ilk nasıl algıladığını renklendirir.',
        'shadow':
            'Gölge yönü: Maskenin arkasına saklanma, dış görünüşe aşırı önem verme.',
        'gift': 'Armağan: Her anı yeni bir başlangıç olarak yaşama yeteneği.',
        'keywords': [
          'Kimlik',
          'İlk İzlenim',
          'Beden',
          'Benlik İfadesi',
          'Yaşam Enerjisi',
        ],
      },
      2: {
        'title': 'Değerler Tapınağı',
        'esoteric':
            'İkinci ev, maddi dünyanın kutsal mabedidir. Para sadece kağıt değil - senin değer sisteminin yansımasıdır. ${sign.nameTr} bu evde konumlanarak para kazanma tarzını, neye değer verdiğini ve güvenlik ihtiyacını şekillendiriyor. Bu ev "sahip olmak" fiilinin ruhsal boyutunu taşır.',
        'shadow':
            'Gölge yönü: Güvenliği sadece maddiyatta arama, açgözlülük veya aşırı tutumculuk.',
        'gift':
            'Armağan: Bolluk bilincini geliştirme ve kaynakları bilgece kullanma.',
        'keywords': ['Para', 'Değerler', 'Yetenekler', 'Özsaygı', 'Kaynaklar'],
      },
      3: {
        'title': 'Zihnin Bahçesi',
        'esoteric':
            'Üçüncü ev, zihnin ve iletişimin kutsal alanıdır. ${sign.nameTr} burada düşünme tarzını, konuşma stilini ve öğrenme biçimini belirliyor. Bu ev kardeşler, komşular ve yakın çevre ile ilişkiyi de yönetir. Zihin burada ya bir bahçe ya da bir orman olur - diktiğin tohumlar büyür.',
        'shadow': 'Gölge yönü: Yüzeysellik, dedikodu, dikkat dağınıklığı.',
        'gift': 'Armağan: Sözcüklerle dünyaları birleştirme gücü.',
        'keywords': [
          'İletişim',
          'Öğrenme',
          'Kardeşler',
          'Yakın Çevre',
          'Zihin',
        ],
      },
      4: {
        'title': 'Ruhun Kökü',
        'esoteric':
            'Dördüncü ev, haritanın en derin noktasıdır - ruhunun kökü. ${sign.nameTr} burada aile kalıplarını, duygusal güvenlik ihtiyacını ve "yuva" kavramını şekillendiriyor. Bu ev ataların mirasını ve bilinçaltındaki en eski izlenimleri taşır. Nereden geldiğini bilmeden nereye gittiğini anlayamazsın.',
        'shadow':
            'Gölge yönü: Geçmişe takılıp kalma, aile kalıplarını körü körüne tekrarlama.',
        'gift': 'Armağan: Derin duygusal bilgelik ve içsel huzur kapasitesi.',
        'keywords': ['Aile', 'Kökler', 'Yuva', 'Anne', 'İç Dünya'],
      },
      5: {
        'title': 'Yaratıcının Sahnesi',
        'esoteric':
            'Beşinci ev, ruhunun yaratıcı ifade bulduğu sahnedir. ${sign.nameTr} burada yaratıcılık tarzını, romantik ifadeni, çocuklarla ilişkini ve "oyun"a yaklaşımını renklendirir. Bu ev kalbin neşesinin fışkırdığı yerdir - içindeki çocuğun evi.',
        'shadow':
            'Gölge yönü: Ego şişkinliği, dikkat bağımlılığı, riskli davranışlar.',
        'gift':
            'Armağan: Saf yaratıcı enerji ve başkalarına ilham verme yeteneği.',
        'keywords': [
          'Yaratıcılık',
          'Romantizm',
          'Çocuklar',
          'Eğlence',
          'Kendini İfade',
        ],
      },
      6: {
        'title': 'Hizmetin Atelyesi',
        'esoteric':
            'Altıncı ev, günlük yaşamın kutsal ritüellerinin evidir. ${sign.nameTr} burada iş rutinlerini, sağlık alışkanlıklarını ve hizmet anlayışını belirliyor. Bu ev "nasıl hizmet ederim?" sorusunun cevabını taşır. Bedenin bir tapınaktır - altıncı ev onun bakım kılavuzudur.',
        'shadow':
            'Gölge yönü: Obsesif mükemmeliyetçilik, kendini ihmal ederek başkalarına hizmet.',
        'gift': 'Armağan: Düzeni ve iyileşmeyi yaratma kapasitesi.',
        'keywords': [
          'Sağlık',
          'İş Rutini',
          'Hizmet',
          'Detaylar',
          'İyileştirme',
        ],
      },
      7: {
        'title': 'Aynanın Ötesi',
        'esoteric':
            'Yedinci ev, "öteki"nin aynasıdır - ilişkilerin, ortaklıkların ve evliliğin evidir. ${sign.nameTr} burada partnerlerinde aradığın nitelikleri, ilişki tarzını ve "biz" kavramını şekillendiriyor. Karşına çıkan herkes içindeki bir şeyi yansıtır - bu ev o aynadır.',
        'shadow':
            'Gölge yönü: Kendini ilişkiler üzerinden tanımlama, bağımlı ilişkiler.',
        'gift': 'Armağan: Derin bağlar kurma ve başkalarında kendini görme.',
        'keywords': ['İlişkiler', 'Evlilik', 'Ortaklıklar', 'Öteki', 'Denge'],
      },
      8: {
        'title': 'Dönüşümün Kuyusu',
        'esoteric':
            'Sekizinci ev, ölüm-yeniden doğuş döngüsünün evidir - en derin dönüşümlerin yeri. ${sign.nameTr} burada krizlerle başa çıkma tarzını, paylaşılan kaynakları, cinselliği ve gizemlere yaklaşımını belirliyor. Bu ev, gölgelerle yüzleşme cesareti gerektirir.',
        'shadow': 'Gölge yönü: Kontrol obsesyonu, manipülasyon, kayıp korkusu.',
        'gift':
            'Armağan: Anka kuşu gibi her kül yığınından yeniden doğma gücü.',
        'keywords': [
          'Dönüşüm',
          'Gizem',
          'Paylaşılan Kaynaklar',
          'Cinsellik',
          'Ölüm-Yeniden Doğuş',
        ],
      },
      9: {
        'title': 'Hakikat Arayışı',
        'esoteric':
            'Dokuzuncu ev, anlam arayışının evidir - felsefe, yüksek öğrenim, uzak yolculuklar ve spiritüel genişleme. ${sign.nameTr} burada inanç sistemini, öğretme/öğrenme tarzını ve "büyük resmi" görme biçimini şekillendiriyor. Bu ev "neden?" sorusunun peşinden gider.',
        'shadow': 'Gölge yönü: Dogmatizm, körü körüne inanç, yerinde duramama.',
        'gift':
            'Armağan: Bilgeliği deneyimden süzme ve başkalarını aydınlatma.',
        'keywords': [
          'Felsefe',
          'Yüksek Öğrenim',
          'Yolculuklar',
          'İnanç',
          'Genişleme',
        ],
      },
      10: {
        'title': 'Zirvenin Tacı',
        'esoteric':
            'Onuncu ev, haritanın zirvesidir - kariyer, toplumsal statü ve yaşam misyonunun evidir. ${sign.nameTr} burada dünyada bırakmak istediğin izi, kariyer tarzını ve otorite figürleriyle ilişkini belirliyor. Bu ev "dünyada kim olmak istiyorum?" sorusunun cevabıdır.',
        'shadow':
            'Gölge yönü: Statü takıntısı, iş bağımlılığı, başarı için fedakarlık.',
        'gift': 'Armağan: Dünyada kalıcı ve anlamlı bir iz bırakma kapasitesi.',
        'keywords': ['Kariyer', 'Statü', 'Hedefler', 'Baba', 'Toplumsal Rol'],
      },
      11: {
        'title': 'Rüyaların Kolektifi',
        'esoteric':
            'On birinci ev, kolektif rüyaların, ideallerin ve arkadaşlıkların evidir. ${sign.nameTr} burada sosyal çevreni, grup dinamiklerini ve geleceğe dair vizyonunu şekillendiriyor. Bu ev "kabileni" bulmakla ilgilidir - tek başına değiştiremediğini birlikte dönüştürürsün.',
        'shadow':
            'Gölge yönü: Gruba uyum için bireyselligi kaybetme, ütopik hayaller.',
        'gift':
            'Armağan: Kolektif iyiliğe hizmet ederken bireysel özgünlüğü koruma.',
        'keywords': [
          'Arkadaşlıklar',
          'Gruplar',
          'İdealler',
          'Gelecek Vizyonu',
          'İnsanlık',
        ],
      },
      12: {
        'title': 'Sonsuzluğun Kapısı',
        'esoteric':
            'On ikinci ev, haritanın en gizemli köşesidir - bilinçaltı, spiritüellik, karma ve çözülmenin evidir. ${sign.nameTr} burada bilinçaltı kalıplarını, spiritüel yolculuğunu ve "bırakma" derslerini taşıyor. Bu ev, egodan öteye, sonsuzluğa açılan kapıdır.',
        'shadow': 'Gölge yönü: Kaçış eğilimi, kurban rolü, gerçeklikten kopuş.',
        'gift': 'Armağan: Sınırsız şefkat ve evrensel birlik deneyimi.',
        'keywords': [
          'Bilinçaltı',
          'Spiritüellik',
          'Karma',
          'Yalnızlık',
          'Çözülme',
        ],
      },
    };

    final houseData = interpretations[houseNumber] ?? {};
    return houseData['esoteric'] as String? ?? '';
  }

  String _getHouseShadowAndGift(int houseNumber) {
    final interpretations = {
      1: {
        'shadow': 'Gölge: Maskenin arkasına saklanma',
        'gift': 'Armağan: Yeni başlangıçlar yaratma',
      },
      2: {
        'shadow': 'Gölge: Maddeye bağımlılık',
        'gift': 'Armağan: Bolluk bilinci',
      },
      3: {'shadow': 'Gölge: Yüzeysellik', 'gift': 'Armağan: İletişim ustalığı'},
      4: {
        'shadow': 'Gölge: Geçmişe takılma',
        'gift': 'Armağan: Duygusal bilgelik',
      },
      5: {'shadow': 'Gölge: Ego şişkinliği', 'gift': 'Armağan: Yaratıcı ifade'},
      6: {
        'shadow': 'Gölge: Mükemmeliyetçilik',
        'gift': 'Armağan: İyileştirme gücü',
      },
      7: {
        'shadow': 'Gölge: İlişki bağımlılığı',
        'gift': 'Armağan: Derin bağlar',
      },
      8: {
        'shadow': 'Gölge: Kontrol takıntısı',
        'gift': 'Armağan: Dönüşüm gücü',
      },
      9: {'shadow': 'Gölge: Dogmatizm', 'gift': 'Armağan: Bilgelik'},
      10: {
        'shadow': 'Gölge: Statü takıntısı',
        'gift': 'Armağan: Kalıcı iz bırakma',
      },
      11: {
        'shadow': 'Gölge: Bireyselliği kaybetme',
        'gift': 'Armağan: Kolektif vizyon',
      },
      12: {
        'shadow': 'Gölge: Kaçış eğilimi',
        'gift': 'Armağan: Sınırsız şefkat',
      },
    };
    final data = interpretations[houseNumber] ?? {'shadow': '', 'gift': ''};
    return '${data['shadow']} | ${data['gift']}';
  }

  String _getHouseSignInterpretation(int houseNumber, zodiac.ZodiacSign sign) {
    final signName = zodiac.ZodiacSignExtension(sign).nameTr;
    final houseThemes = {
      1: 'kimlik, benlik ifadesi ve dış görünüş',
      2: 'para, değerler ve maddi güvenlik',
      3: 'iletişim, öğrenme ve yakın çevre',
      4: 'aile, kökler ve iç dünya',
      5: 'yaratıcılık, romantizm ve çocuklar',
      6: 'sağlık, iş rutini ve hizmet',
      7: 'ilişkiler, ortaklıklar ve evlilik',
      8: 'dönüşüm, paylaşılan kaynaklar ve gizem',
      9: 'felsefe, yüksek öğrenim ve uzak yerler',
      10: 'kariyer, toplumsal statü ve hedefler',
      11: 'arkadaşlıklar, gruplar ve idealler',
      12: 'bilinçaltı, spiritüellik ve karma',
    };

    final signTraits = {
      zodiac.ZodiacSign.aries: 'enerjik, cesur ve girişimci bir şekilde',
      zodiac.ZodiacSign.taurus: 'istikrarlı, duyusal ve sabırlı bir şekilde',
      zodiac.ZodiacSign.gemini: 'meraklı, iletişimci ve esnek bir şekilde',
      zodiac.ZodiacSign.cancer: 'duygusal, koruyucu ve sezgisel bir şekilde',
      zodiac.ZodiacSign.leo: 'yaratıcı, dramatik ve cömert bir şekilde',
      zodiac.ZodiacSign.virgo: 'analitik, pratik ve mükemmeliyetçi bir şekilde',
      zodiac.ZodiacSign.libra: 'dengeli, diplomatik ve estetik bir şekilde',
      zodiac.ZodiacSign.scorpio: 'yoğun, dönüştürücü ve tutkulu bir şekilde',
      zodiac.ZodiacSign.sagittarius: 'özgür, felsefi ve iyimser bir şekilde',
      zodiac.ZodiacSign.capricorn: 'disiplinli, hırslı ve sorumlu bir şekilde',
      zodiac.ZodiacSign.aquarius: 'özgün, yenilikçi ve bağımsız bir şekilde',
      zodiac.ZodiacSign.pisces: 'sezgisel, empatik ve rüya gibi bir şekilde',
    };

    final theme = houseThemes[houseNumber] ?? 'bu alan';
    final trait = signTraits[sign] ?? 'benzersiz bir şekilde';

    return '$signName enerjisi $houseNumber. evinde $theme konularına yaklaşımını $trait şekillendiriyor. Bu yerleşim, bu hayat alanında nasıl hareket ettiğini ve deneyimlediğini gösteriyor.';
  }

  String _getPlanetsInHouseInterpretation(
    int houseNumber,
    List<PlanetPosition> planets,
  ) {
    if (planets.isEmpty) return '';

    final houseAreas = {
      1: 'kimlik ve benlik ifaden',
      2: 'para ve değerler alanın',
      3: 'iletişim ve öğrenme tarzın',
      4: 'aile ve yuva dinamiklerin',
      5: 'yaratıcılık ve romantizm alanın',
      6: 'iş ve sağlık rutinlerin',
      7: 'ilişki ve ortaklık dinamiklerin',
      8: 'dönüşüm ve paylaşım alanın',
      9: 'anlam arayışı ve öğrenme yolculuğun',
      10: 'kariyer ve toplumsal rolün',
      11: 'sosyal bağlantılar ve ideallerin',
      12: 'bilinçaltı ve spiritüel yolculuğun',
    };

    final area = houseAreas[houseNumber] ?? 'bu alan';
    final planetNames = planets.map((p) => p.planet.nameTr).join(', ');
    final count = planets.length;

    if (count == 1) {
      return '$planetNames bu evde konumlanmış - $area ${planets.first.planet.meaning.toLowerCase()} enerjisiyle güçleniyor.';
    } else {
      return 'Bu evde $count gezegen var: $planetNames. $area çoklu gezegen enerjileriyle aktif ve yoğun.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final signColor = zodiac.ZodiacSignExtension(widget.house.sign).color;
    final signSymbol = zodiac.ZodiacSignExtension(widget.house.sign).symbol;
    final esotericInterp = _getEsotericHouseInterpretation(
      widget.house.house.number,
      widget.house.sign,
    );
    final shadowGift = _getHouseShadowAndGift(widget.house.house.number);

    return ExpansionTile(
      initiallyExpanded: false,
      onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
      tilePadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: 0,
      ),
      childrenPadding: const EdgeInsets.only(
        left: AppConstants.spacingMd,
        right: AppConstants.spacingMd,
        bottom: AppConstants.spacingMd,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _isExpanded
              ? signColor.withAlpha(80)
              : signColor.withAlpha(51),
          borderRadius: BorderRadius.circular(8),
          border: _isExpanded ? Border.all(color: signColor, width: 2) : null,
        ),
        child: Center(
          child: Text(
            '${widget.house.house.number}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: signColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        widget.house.house.nameTr,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: _isExpanded ? signColor : AppColors.textPrimary,
          fontWeight: _isExpanded ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        widget.house.house.keywords,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(signSymbol, style: TextStyle(fontSize: 18, color: signColor)),
          const SizedBox(width: 4),
          Text(
            '${widget.house.degree}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: signColor),
          ),
          if (widget.planetsInHouse.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.auroraStart.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${widget.planetsInHouse.length}',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.auroraStart),
              ),
            ),
          ],
        ],
      ),
      iconColor: AppColors.textMuted,
      collapsedIconColor: AppColors.textMuted,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [signColor.withAlpha(25), AppColors.surfaceDark],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            border: Border.all(color: signColor.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ezoterik Başlık
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [signColor.withAlpha(40), Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text('✨', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getEsotericTitle(widget.house.house.number),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: signColor,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Ezoterik Yorum
              if (esotericInterp.isNotEmpty) ...[
                Text(
                  esotericInterp,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Gölge ve Armağan
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withAlpha(15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('🌑', style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(
                            shadowGift.split(' | ')[0],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.orange.shade300,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.white12),
                    Expanded(
                      child: Column(
                        children: [
                          Text('🌟', style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(
                            shadowGift.split(' | ')[1],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.starGold,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // House meaning header
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: AppColors.starGold),
                  const SizedBox(width: 8),
                  Text(
                    'Bu Evin Anlamı',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.starGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.house.house.meaning,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),

              // Detailed house interpretation
              const SizedBox(height: AppConstants.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: signColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: signColor.withAlpha(50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          signSymbol,
                          style: TextStyle(fontSize: 14, color: signColor),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${zodiac.ZodiacSignExtension(widget.house.sign).nameTr} Yönetiminde',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: signColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getHouseSignInterpretation(
                        widget.house.house.number,
                        widget.house.sign,
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.planetsInHouse.isNotEmpty) ...[
                const SizedBox(height: AppConstants.spacingMd),
                Row(
                  children: [
                    Icon(Icons.public, size: 16, color: AppColors.auroraStart),
                    const SizedBox(width: 8),
                    Text(
                      'Bu Evdeki Gezegenler',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.auroraStart,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.planetsInHouse.map((planet) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: planet.planet.color.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: planet.planet.color.withAlpha(128),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            planet.planet.symbol,
                            style: TextStyle(
                              fontSize: 14,
                              color: planet.planet.color,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            planet.planet.nameTr,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  _getPlanetsInHouseInterpretation(
                    widget.house.house.number,
                    widget.planetsInHouse,
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ] else ...[
                const SizedBox(height: AppConstants.spacingMd),
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingSm),
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bu evde gezegen yok - bu alanın aktif olmadığı anlamına gelmez. Evin yönetici burcu olan ${zodiac.ZodiacSignExtension(widget.house.sign).nameTr} ve onun yönetici gezegeni bu alanı aktive eder.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getEsotericTitle(int houseNumber) {
    final titles = {
      1: 'Benliğin Kapısı',
      2: 'Değerler Tapınağı',
      3: 'Zihnin Bahçesi',
      4: 'Ruhun Kökü',
      5: 'Yaratıcının Sahnesi',
      6: 'Hizmetin Atelyesi',
      7: 'Aynanın Ötesi',
      8: 'Dönüşümün Kuyusu',
      9: 'Hakikat Arayışı',
      10: 'Zirvenin Tacı',
      11: 'Rüyaların Kolektifi',
      12: 'Sonsuzluğun Kapısı',
    };
    return titles[houseNumber] ?? '$houseNumber. Ev';
  }
}
