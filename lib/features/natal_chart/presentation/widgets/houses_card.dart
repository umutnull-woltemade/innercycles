import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/natal_chart.dart';
import '../../../../data/models/house.dart';
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Evlerin hesaplanabilmesi için doğum saati ve yeri bilgisi gereklidir. Lütfen profil ayarlarından bu bilgileri ekleyin.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Group houses by type
    final angularHouses =
        chart.houses.where((h) => h.house.isAngular).toList();
    final succedentHouses =
        chart.houses.where((h) => h.house.isSuccedent).toList();
    final cadentHouses =
        chart.houses.where((h) => h.house.isCadent).toList();

    return Column(
      children: [
        _buildHouseTypeSection(
          context,
          'Acisal Evler',
          'En guclu ve aktif evler (1, 4, 7, 10)',
          angularHouses,
          AppColors.starGold,
          0,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        _buildHouseTypeSection(
          context,
          'Ardil Evler',
          'Kaynaklar ve degerler (2, 5, 8, 11)',
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: accentColor,
                            ),
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

class _HouseRow extends StatelessWidget {
  final HouseCusp house;
  final List<PlanetPosition> planetsInHouse;
  final bool isLast;

  const _HouseRow({
    required this.house,
    required this.planetsInHouse,
    this.isLast = false,
  });

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

    return '$signName enerjisi ${houseNumber}. evinde $theme konularına yaklaşımını $trait şekillendiriyor. Bu yerleşim, bu hayat alanında nasıl hareket ettiğini ve deneyimlediğini gösteriyor.';
  }

  String _getPlanetsInHouseInterpretation(int houseNumber, List<PlanetPosition> planets) {
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
    final signColor = zodiac.ZodiacSignExtension(house.sign).color;
    final signSymbol = zodiac.ZodiacSignExtension(house.sign).symbol;

    return ExpansionTile(
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
          color: signColor.withAlpha(51),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${house.house.number}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: signColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
      title: Text(
        house.house.nameTr,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
            ),
      ),
      subtitle: Text(
        house.house.keywords,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            signSymbol,
            style: TextStyle(fontSize: 18, color: signColor),
          ),
          const SizedBox(width: 4),
          Text(
            '${house.degree}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: signColor,
                ),
          ),
          if (planetsInHouse.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.auroraStart.withAlpha(51),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${planetsInHouse.length}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.auroraStart,
                    ),
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
              colors: [
                signColor.withAlpha(25),
                AppColors.surfaceDark,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            border: Border.all(color: signColor.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                house.house.meaning,
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
                          '${zodiac.ZodiacSignExtension(house.sign).nameTr} Yönetiminde',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: signColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getHouseSignInterpretation(house.house.number, house.sign),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),

              if (planetsInHouse.isNotEmpty) ...[
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
                  children: planetsInHouse.map((planet) {
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
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  _getPlanetsInHouseInterpretation(house.house.number, planetsInHouse),
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
                      Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bu evde gezegen yok - bu alanın aktif olmadığı anlamına gelmez. Evin yönetici burcu olan ${zodiac.ZodiacSignExtension(house.sign).nameTr} ve onun yönetici gezegeni bu alanı aktive eder.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
}
