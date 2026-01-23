import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/natal_chart.dart';
import '../../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../../shared/widgets/interpretive_text.dart';

class ChartSummaryCard extends StatelessWidget {
  final NatalChart chart;

  const ChartSummaryCard({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    final sunSign = chart.sunSign;
    final signColor = zodiac.ZodiacSignExtension(sunSign).color;
    final signSymbol = zodiac.ZodiacSignExtension(sunSign).symbol;
    final signNameTr = zodiac.ZodiacSignExtension(sunSign).nameTr;
    final elementNameTr = zodiac.ElementExtension(sunSign.element).nameTr;
    final elementSymbol = zodiac.ElementExtension(sunSign.element).symbol;
    final modalityNameTr = zodiac.ModalityExtension(sunSign.modality).nameTr;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            signColor.withAlpha(76),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: signColor.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: signColor.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  signSymbol,
                  style: TextStyle(fontSize: 32, color: signColor),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signNameTr,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: signColor,
                          ),
                    ),
                    Text(
                      '$elementNameTr $elementSymbol | $modalityNameTr',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          _buildInfoRow(
            context,
            'Doğum Tarihi',
            _formatDate(chart.birthDate),
            Icons.calendar_today,
          ),
          if (chart.birthTime != null)
            _buildInfoRow(
              context,
              'Doğum Saati',
              chart.birthTime!,
              Icons.access_time,
            ),
          if (chart.birthPlace != null)
            _buildInfoRow(
              context,
              'Doğum Yeri',
              chart.birthPlace!,
              Icons.location_on,
            ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withAlpha(128),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Gezegen',
                  value: '${chart.planets.length}',
                  icon: Icons.public,
                ),
                _StatItem(
                  label: 'Ev',
                  value: '${chart.houses.length}',
                  icon: Icons.home,
                ),
                _StatItem(
                  label: 'Aci',
                  value: '${chart.aspects.length}',
                  icon: Icons.compare_arrows,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Deep Interpretation Section
          DeepInterpretationCard(
            title: '$signNameTr Güneşiniz',
            summary: _getSunSignSummary(sunSign),
            deepInterpretation: _getSunSignDeepInterpretation(sunSign),
            icon: Icons.wb_sunny,
            accentColor: signColor,
            relatedTerms: [signNameTr, elementNameTr, modalityNameTr, 'Güneş'],
          ),
        ],
      ),
    );
  }

  String _getSunSignSummary(zodiac.ZodiacSign sign) {
    final summaries = {
      zodiac.ZodiacSign.aries: '[[Ateş]] element enerjisiyle dolu, [[Koç]] burcu liderliği ve inisiyatifi simgeler. [[Güneş]] burada güçlü bir irade ve cesaret verir.',
      zodiac.ZodiacSign.taurus: '[[Toprak]] elementinin istikrarlı enerjisiyle, [[Boğa]] burcu güvenliği ve konforu arar. [[Venüs]] yönetiminde sanat ve güzellik önemlidir.',
      zodiac.ZodiacSign.gemini: '[[Hava]] elementinin zekâsı ve merakıyla, [[İkizler]] burcu iletişim ve öğrenme yetenekleriyle öne çıkar. [[Merkür]] yönetiminde bilgi akışı önemlidir.',
      zodiac.ZodiacSign.cancer: '[[Su]] elementinin duygusal derinliğiyle, [[Yengeç]] burcu aile ve yuva konularında hassastır. [[Ay]] yönetiminde duygular yoğundur.',
      zodiac.ZodiacSign.leo: '[[Ateş]] elementinin yaratıcı enerjisiyle, [[Aslan]] burcu kendini ifade etme ve drama ile özdeşleşir. [[Güneş]] burada en güçlü haliyle parlar.',
      zodiac.ZodiacSign.virgo: '[[Toprak]] elementinin pratik enerjisiyle, [[Başak]] burcu detaylara ve mükemmelliğe odaklanır. [[Merkür]] yönetiminde analiz gücü yüksektir.',
      zodiac.ZodiacSign.libra: '[[Hava]] elementinin sosyal enerjisiyle, [[Terazi]] burcu denge ve uyum arar. [[Venüs]] yönetiminde ilişkiler ön plandadır.',
      zodiac.ZodiacSign.scorpio: '[[Su]] elementinin transformatif enerjisiyle, [[Akrep]] burcu derin ve yoğun duygular yaşar. [[Pluto]] yönetiminde dönüşüm esastır.',
      zodiac.ZodiacSign.sagittarius: '[[Ateş]] elementinin macera enerjisiyle, [[Yay]] burcu özgürlük ve keşfetme arzusu çeker. [[Jüpiter]] yönetiminde genişleme önemlidir.',
      zodiac.ZodiacSign.capricorn: '[[Toprak]] elementinin disiplinli enerjisiyle, [[Oğlak]] burcu başarı ve sorumluluk bilincine sahiptir. [[Satürn]] yönetiminde yapı ve sınırlar önemlidir.',
      zodiac.ZodiacSign.aquarius: '[[Hava]] elementinin yenilikçi enerjisiyle, [[Kova]] burcu bağımsızlık ve insanlık için çalışır. [[Uranüs]] yönetiminde devrimci fikirler öne çıkar.',
      zodiac.ZodiacSign.pisces: '[[Su]] elementinin mistik enerjisiyle, [[Balık]] burcu sezgi ve spiritüel bağlantılara açıktır. [[Neptün]] yönetiminde hayal gücü sınırsızdır.',
    };
    return summaries[sign] ?? 'Burcunuz kozmik enerjileri benzersiz bir şekilde yansıtır.';
  }

  String _getSunSignDeepInterpretation(zodiac.ZodiacSign sign) {
    final interpretations = {
      zodiac.ZodiacSign.aries: '''[[Koç]] burcunda [[Güneş]] sahibi olmak, ruhunuzun özünde bir savaşçı ve öncü olduğunu gösterir. [[Mars]]\'ın yönetimindeki bu enerji, size hayatta ilk adımı atma cesareti verir.

[[Kardinal]] nitelikli bu burç, yeni başlangıçlar ve liderlik için doğal bir yeteneğe sahiptir. [[Ateş]] elementi ile birlikte, tutkunuz ve enerjiniz etrafınızdakileri etkiler ve motive eder.

Evrimsel yolculuğunuzda, [[ego]] ve bireysellik temaları önemlidir. [[1. Ev]] ile doğal ilişkiniz, kendinizi keşfetme ve otantik kimliğinizi ifade etme ihtiyacını vurgular.

[[Güneş]] burada \"yükselimde\" (exaltation) olduğu için, yaşam gücünüz ve iradeniz son derece güçlüdür. Dikkat edilmesi gereken [[gölge]] yönü ise sabırsızlık ve düşünmeden hareket etme eğilimidir.''',

      zodiac.ZodiacSign.taurus: '''[[Boğa]] burcunda [[Güneş]] sahibi olmak, ruhunuzun [[Toprak]] elementinin en istikrarlı formunda tezahür ettiğini gösterir. [[Venüs]]\'ün yönetiminde, güzellik, değerler ve maddi dünya ile derin bir bağlantınız vardır.

[[Sabit]] nitelikli bu burç, size dayanıklılık ve kararlılık verir. Bir kere karar verdiğinizde, hedefinize ulaşana kadar durmazsınız - bu hem güçlü yanınız hem de potansiyel [[gölge]] alanınızdır.

[[2. Ev]] ile doğal ilişkiniz, maddi güvenlik, öz değer ve kaynaklarınızı yönetme konusunda yetenekler sağlar. [[Boğaz çakrası]] ile ilişkili olarak, ses ve ifade sizin için önemli temalardır.

Duyusal deneyimler - yemek, müzik, dokunma - sizin için sadece zevk değil, ruhani beslenmedir. [[Venüs]] geçişleri hayatınızda önemli dönemleri işaret eder.''',

      zodiac.ZodiacSign.gemini: '''[[İkizler]] burcunda [[Güneş]] sahibi olmak, zihninizin sürekli hareket halinde olduğunu ve bilgi toplama konusunda doymak bilmez bir merak taşıdığınızı gösterir. [[Merkür]]\'ün yönetiminde, iletişim ve bilgi sizin süper gücünüzdür.

[[Değişken]] nitelikli bu burç, adaptasyon ve esneklik yeteneği verir. Çoklu ilgi alanları ve yetenekler sizin doğal halinizdir - bu bir dağınıklık değil, [[Hava]] elementinin doğal ifadesidir.

[[3. Ev]] ile doğal ilişkiniz, yakın çevre, kardeşler ve kısa yolculuklar konusunda önemli deneyimler getirir. [[Dualite]] - iki yön arasında gidip gelme - sizin için önemli bir temadır.

[[Merkür retrosu]] dönemleri sizin için özellikle önemlidir; bu dönemlerde iç gözlem ve geçmişe bakış değerlidir. Zihinsel sağlığınız için meditasyon ve sessizlik pratiği önerilir.''',

      zodiac.ZodiacSign.cancer: '''[[Yengeç]] burcunda [[Güneş]] sahibi olmak, duygusal zekânızın ve koruyucu içgüdülerinizin güçlü olduğunu gösterir. [[Ay]]\'ın yönetiminde, duygular ve sezgiler hayatınızın merkezindedir.

[[Kardinal]] nitelikli [[Su]] burcu olarak, duygusal liderlik ve inisiyatif alma kapasiteniz yüksektir. Aileniz ve sevilenleriniz için her şeyi yapabilirsiniz.

[[4. Ev]] ile doğal ilişkiniz, ev, aile kökleri ve duygusal güvenlik temalarını ön plana çıkarır. [[Anne arketipi]] ve besleyici enerji sizinle güçlü bir şekilde rezonans eder.

[[Ay fazları]] hayatınızı derinden etkiler. Dolunay ve yeniay dönemleri sizin için özellikle hassas ve güçlü zamanlardır. Duygusal sınırlar koymayı öğrenmek evrimsel görevinizdir.''',

      zodiac.ZodiacSign.leo: '''[[Aslan]] burcunda [[Güneş]] sahibi olmak, ruhunuzun en parlak ve görkemli ifadesini temsil eder. [[Güneş]] burada \"evinde\" (domicile) olduğu için, yaratıcı gücünüz ve öz-ifadeniz son derece güçlüdür.

[[Sabit]] [[Ateş]] burcu olarak, tutkunuz ve kararlılığınız etkileyicidir. Sahnede olmak, görülmek ve takdir edilmek sizin için sadece ego değil, ruhsal bir ihtiyaçtır.

[[5. Ev]] ile doğal ilişkiniz, yaratıcılık, romantizm, çocuklar ve eğlence temalarında önemli deneyimler getirir. [[Kalp çakrası]] sizinle güçlü bir şekilde bağlantılıdır.

[[Güneş tutulmaları]] hayatınızda dönüm noktaları oluşturur. Alçakgönüllülük ve başkalarının ışığını görme kapasitesi, evrimsel yolculuğunuzda geliştirilecek niteliklerdir.''',

      zodiac.ZodiacSign.virgo: '''[[Başak]] burcunda [[Güneş]] sahibi olmak, analitik zekânızın ve hizmet odaklı doğanızın güçlü olduğunu gösterir. [[Merkür]]\'ün yönetiminde, detayları görme ve düzenleme kapasiteniz üstündür.

[[Değişken]] [[Toprak]] burcu olarak, pratik çözümler üretme ve adaptasyon yeteneğiniz gelişkindir. Mükemmeliyetçilik hem güçlü yanınız hem de [[gölge]] alanınızdır.

[[6. Ev]] ile doğal ilişkiniz, sağlık, günlük rutinler ve hizmet temalarını ön plana çıkarır. Vücudunuzla bilinçli bir ilişki kurmanız önemlidir.

[[Merkür]]\'ün [[Başak]]\'taki gücü, şifacılık ve analiz yetenekleri verir. Kendinize de başkalarına gösterdiğiniz özeni göstermeyi öğrenmek evrimsel görevinizdir.''',

      zodiac.ZodiacSign.libra: '''[[Terazi]] burcunda [[Güneş]] sahibi olmak, ilişkilerin ve dengenin hayatınızın merkezinde olduğunu gösterir. [[Venüs]]\'ün yönetiminde, uyum ve güzellik sizin için temel değerlerdir.

[[Kardinal]] [[Hava]] burcu olarak, sosyal inisiyatif alma ve ilişkiler kurma konusunda doğal bir yeteneğiniz var. Diplomasi ve adalet duygunuz gelişkindir.

[[7. Ev]] ile doğal ilişkiniz, ortaklıklar, evlilik ve \"öteki\" temasında önemli yaşam dersleri getirir. [[Projeksiyon]] mekanizmasını anlamak sizin için önemlidir.

[[Güneş]] burada \"düşüşte\" (fall) olduğundan, bireysellik ve bağımsızlık temaları zorlayıcı olabilir. Kendi kimliğinizi korurken ilişki kurma dengesini bulmak evrimsel görevinizdir.''',

      zodiac.ZodiacSign.scorpio: '''[[Akrep]] burcunda [[Güneş]] sahibi olmak, ruhunuzun derin dönüşüm ve yeniden doğuş temalarıyla bağlantılı olduğunu gösterir. [[Pluto]]\'nun yönetiminde, yoğunluk ve güç sizin doğal halinizdir.

[[Sabit]] [[Su]] burcu olarak, duygusal derinliğiniz ve kararlılığınız etkileyicidir. Yüzeyin altını görme ve gizli gerçekleri ortaya çıkarma yeteneğiniz güçlüdür.

[[8. Ev]] ile doğal ilişkiniz, paylaşılan kaynaklar, cinsellik, ölüm-yeniden doğuş döngüsü ve [[psikolojik dönüşüm]] temalarında derin deneyimler getirir.

[[Pluto geçişleri]] hayatınızda radikal dönüşüm dönemlerini işaret eder. Kontrol bırakma ve güvenme, evrimsel yolculuğunuzda öğrenilecek en önemli derslerdir.''',

      zodiac.ZodiacSign.sagittarius: '''[[Yay]] burcunda [[Güneş]] sahibi olmak, ruhunuzun özgürlük, macera ve anlam arayışıyla karakterize olduğunu gösterir. [[Jüpiter]]\'in yönetiminde, genişleme ve büyüme sizin doğal eğiliminizdir.

[[Değişken]] [[Ateş]] burcu olarak, coşkunuz ve idealleriniz sizi ileriye taşır. Felsefe, yüksek öğrenim ve yabancı kültürler size ilham verir.

[[9. Ev]] ile doğal ilişkiniz, uzun yolculuklar, yüksek öğrenim, felsefe ve inanç sistemleri temalarında önemli deneyimler getirir.

[[Jüpiter]] geçişleri hayatınızda şans ve genişleme dönemlerini işaret eder. Dağınıklığı önlemek ve derinleşmek, evrimsel yolculuğunuzda geliştirilecek niteliklerdir.''',

      zodiac.ZodiacSign.capricorn: '''[[Oğlak]] burcunda [[Güneş]] sahibi olmak, ruhunuzun başarı, sorumluluk ve uzun vadeli hedeflerle derinden bağlantılı olduğunu gösterir. [[Satürn]]\'ün yönetiminde, disiplin ve yapı sizin doğal halinizdir.

[[Kardinal]] [[Toprak]] burcu olarak, liderlik ve pratik başarı elde etme kapasiteniz yüksektir. Zaman sizin müttefikinizdir - yaşla birlikte daha da güçlenirsiniz.

[[10. Ev]] ile doğal ilişkiniz, kariyer, toplumsal statü, itibar ve [[baba arketipi]] temalarında önemli yaşam dersleri getirir.

[[Satürn dönüşü]] (yaklaşık her 29 yılda bir) hayatınızda önemli olgunlaşma dönemlerini işaret eder. Duygusal yumuşaklık ve zevk almayı öğrenmek evrimsel görevinizdir.''',

      zodiac.ZodiacSign.aquarius: '''[[Kova]] burcunda [[Güneş]] sahibi olmak, ruhunuzun benzersizlik, insanlık ve ilerlemeyle derinden bağlantılı olduğunu gösterir. [[Uranüs]]\'ün yönetiminde, devrimci fikirler ve orijinallik sizin doğal halinizdir.

[[Sabit]] [[Hava]] burcu olarak, fikirlerinize olan bağlılığınız güçlüdür. Toplumsal değişim ve kolektif bilinç size ilham verir.

[[11. Ev]] ile doğal ilişkiniz, gruplar, dostluklar, umutlar ve insani idealler temalarında önemli deneyimler getirir.

[[Uranüs]] geçişleri hayatınızda beklenmedik değişimler ve özgürleşme dönemlerini işaret eder. Duygusal yakınlık ve bireysel bağlar kurmak evrimsel görevinizdir.''',

      zodiac.ZodiacSign.pisces: '''[[Balık]] burcunda [[Güneş]] sahibi olmak, ruhunuzun spiritüel alemlere, sezgiye ve kolektif bilinçdışına derinden bağlı olduğunu gösterir. [[Neptün]]\'ün yönetiminde, mistisizm ve yaratıcılık sizin doğal halinizdir.

[[Değişken]] [[Su]] burcu olarak, empati ve uyum sağlama kapasiteniz son derece gelişkindir. Sınırların erimesi hem güçlü yanınız hem de dikkat edilecek [[gölge]] alanınızdır.

[[12. Ev]] ile doğal ilişkiniz, bilinçdışı, spiritüel pratikler, yalnızlık ve [[karmik]] temalar konusunda derin deneyimler getirir.

[[Neptün]] geçişleri hayatınızda spiritüel uyanış ve çözülme dönemlerini işaret eder. Sağlıklı sınırlar koymak ve pratik gerçeklikle bağlantıda kalmak evrimsel görevinizdir.''',
    };
    return interpretations[sign] ?? 'Güneş burcu yorumunuz hazırlanıyor...';
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.auroraStart, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textMuted,
              ),
        ),
      ],
    );
  }
}
