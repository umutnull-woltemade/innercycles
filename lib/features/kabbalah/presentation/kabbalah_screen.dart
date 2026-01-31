import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/kabbalah_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../shared/widgets/null_profile_placeholder.dart';

class KabbalahScreen extends ConsumerWidget {
  const KabbalahScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return const NullProfilePlaceholder(
        emoji: '🕎',
        titleKey: 'kabbalah_analysis',
        messageKey: 'enter_birth_info_kabbalah',
      );
    }

    final lifePathSefirah = KabbalahService.calculateLifePathSefirah(userProfile.birthDate);
    final dailyEnergy = KabbalahService.getDailyEnergy(DateTime.now());

    Sefirah? nameSefirah;
    int? kabbalahNumber;
    int? soulNumber;
    int? personaNumber;

    if (userProfile.name != null && userProfile.name!.isNotEmpty) {
      nameSefirah = KabbalahService.calculateNameSefirah(userProfile.name!);
      kabbalahNumber = KabbalahService.calculateKabbalahNumber(userProfile.name!);
      soulNumber = KabbalahService.calculateSoulNumber(userProfile.name!);
      personaNumber = KabbalahService.calculatePersonaNumber(userProfile.name!);
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                floating: true,
                snap: true,
                title: Text(
                  'Kabala',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.starGold,
                      ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Ezoterik giriş
                    _buildEsotericIntro(context),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Ana Sefirah kartı
                    _buildMainSefirahCard(context, lifePathSefirah)
                        .animate()
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // İsim bazlı sayılar
                    if (nameSefirah != null) ...[
                      _buildSectionTitle(context, 'İsim Kabalası'),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildNameKabbalahCard(
                        context,
                        nameSefirah,
                        kabbalahNumber!,
                        soulNumber!,
                        personaNumber!,
                        userProfile.name!,
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: AppConstants.spacingLg),
                    ],

                    // Günlük enerji
                    _buildSectionTitle(context, 'Günlük Kabala Enerjisi'),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildDailyEnergyCard(context, dailyEnergy)
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Hayat Ağacı
                    _buildSectionTitle(context, 'Hayat Ağacı'),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildTreeOfLifeCard(context, lifePathSefirah, nameSefirah)
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingXl),
                    // Entertainment Disclaimer
                    const PageFooterWithDisclaimer(
                      brandText: 'Kabala — Venus One',
                      disclaimerText: DisclaimerTexts.astrology,
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEsotericIntro(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.starGold.withAlpha(25),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.starGold, size: 18),
              const SizedBox(width: 8),
              Text(
                'Hayat Ağacının Sırrı',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Kabala, evrenin ve ruhun yapısını anlatan kadim bir bilgelik sistemidir. Hayat Ağacı (Etz Chaim), on Sefirah\'tan oluşur - her biri ilahi enerjinin farklı bir yönünü temsil eder. İsmin ve doğum tarihin, bu kozmik ağaçtaki yerini belirler. Bu bilgi, ruhsal yolculuğunda sana rehberlik edecektir.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMainSefirahCard(BuildContext context, Sefirah sefirah) {
    final sefirahColor = _getSefirahColor(sefirah);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sefirahColor.withAlpha(76),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: sefirahColor.withAlpha(128)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: sefirahColor.withAlpha(51),
                  shape: BoxShape.circle,
                  border: Border.all(color: sefirahColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    sefirah.number.toString(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: sefirahColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yaşam Yolu Sefirah\'ın',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                    Text(
                      sefirah.nameTr,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: sefirahColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            sefirah.meaning,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              _buildSefirahAttribute(context, 'Renk', sefirah.color, sefirahColor),
              const SizedBox(width: AppConstants.spacingMd),
              _buildSefirahAttribute(context, 'Sayı', sefirah.number.toString(), sefirahColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSefirahAttribute(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameKabbalahCard(
    BuildContext context,
    Sefirah sefirah,
    int kabbalahNumber,
    int soulNumber,
    int personaNumber,
    String name,
  ) {
    final sefirahColor = _getSefirahColor(sefirah);
    final personalInterpretation = _generateNameInterpretation(name, sefirah, kabbalahNumber, soulNumber, personaNumber);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: sefirahColor.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: sefirahColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'İsim Analizi: $name',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: sefirahColor,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: _buildNumberBox(context, 'Kabala', kabbalahNumber, sefirahColor),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Expanded(
                child: _buildNumberBox(context, 'Ruh', soulNumber, AppColors.waterElement),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Expanded(
                child: _buildNumberBox(context, 'Persona', personaNumber, AppColors.earthElement),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingSm),
            decoration: BoxDecoration(
              color: sefirahColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.star, color: sefirahColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'İsim Sefirah\'ın: ${sefirah.nameTr}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: sefirahColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Kişiye özel ezoterik yorum
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  sefirahColor.withAlpha(15),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: sefirahColor.withAlpha(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: sefirahColor, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Kişisel Kabalistik Yorum',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: sefirahColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  personalInterpretation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Ruh ve Persona detayları
          _buildSoulPersonaDetails(context, soulNumber, personaNumber),
        ],
      ),
    );
  }

  Widget _buildSoulPersonaDetails(BuildContext context, int soulNumber, int personaNumber) {
    final soulSefirah = SefirahExtension.fromNumber(soulNumber);
    final personaSefirah = SefirahExtension.fromNumber(personaNumber);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.favorite, color: AppColors.waterElement, size: 12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Ruh ($soulNumber - ${soulSefirah.nameTr}): ${_getSoulMeaning(soulNumber)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.face, color: AppColors.earthElement, size: 12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Persona ($personaNumber - ${personaSefirah.nameTr}): ${_getPersonaMeaning(personaNumber)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _generateNameInterpretation(String name, Sefirah sefirah, int kabbalahNumber, int soulNumber, int personaNumber) {
    final gematria = KabbalahService.calculateGematria(name);

    // Kişiye özel yorumlar
    String interpretation = '"$name" ismi, Gematria değeri $gematria ile ${sefirah.nameTr} enerjisini taşıyor. ';

    // Sefirah'a göre kişilik özellikleri
    switch (sefirah) {
      case Sefirah.keter:
        interpretation += 'Ruhun sonsuzlukla bağlantılı - ilahi iradenin taşıyıcısı olarak doğdun. Sezgilerin güçlü, vizyonun geniş. ';
        break;
      case Sefirah.chokhmah:
        interpretation += 'Bilgelik tohumlarını taşıyorsun - ani içgörüler ve ilhamlar senin için doğal. Vizyoner bir ruh. ';
        break;
      case Sefirah.binah:
        interpretation += 'Derin anlayış kapasiten var - kavramları derinlemesine işler, form verirsin. Analitik ve sezgisel. ';
        break;
      case Sefirah.chesed:
        interpretation += 'Merhamet ve sevgi senin doğan - şifa verici, besleyici bir enerji taşıyorsun. Cömertlik ruhunda. ';
        break;
      case Sefirah.gevurah:
        interpretation += 'İç gücün güçlü - disiplin ve kararlılık senin silahların. Adalet duygun keskin. ';
        break;
      case Sefirah.tiferet:
        interpretation += 'Denge noktasındasın - güzellik ve uyumu doğal olarak yaratırsın. Kalp merkezlisin. ';
        break;
      case Sefirah.netzach:
        interpretation += 'Azim ve tutku senin yolun - yaratıcı enerjin tükenmez. Hedeflerine ulaşana dek durmazsın. ';
        break;
      case Sefirah.hod:
        interpretation += 'İletişim ve analiz yeteneğin güçlü - düşüncelerini berrak ifade edersin. Zihinsel parlaklık. ';
        break;
      case Sefirah.yesod:
        interpretation += 'Sezgisel derinliğin var - rüyalar ve semboller seninle konuşur. Astral bağlantın güçlü. ';
        break;
      case Sefirah.malkut:
        interpretation += 'Topraklanmış ve pratiksin - fikirleri gerçeğe dönüştürme yeteneğin var. Dünya senin krallığın. ';
        break;
    }

    // Ruh ve Persona dengesine göre ek yorum
    final difference = (soulNumber - personaNumber).abs();
    if (difference <= 2) {
      interpretation += 'İç dünyan ile dışa yansıttığın uyum içinde - otantik bir kişilik.';
    } else if (difference <= 4) {
      interpretation += 'İç ve dış dünyaların arasında ilginç bir dinamik var - bu gerilim büyüme potansiyeli taşıyor.';
    } else {
      interpretation += 'Derin iç dünyan ile gösterdiğin yüz farklı - bu gizem seni güçlü kılıyor.';
    }

    return interpretation;
  }

  String _getSoulMeaning(int number) {
    switch (number) {
      case 1: return 'Birlik arayışı, spiritüel özlem';
      case 2: return 'Sezgisel bilgelik, ilham';
      case 3: return 'Derin anlayış, kavrayış';
      case 4: return 'Sevgi ihtiyacı, şefkat';
      case 5: return 'Güç arayışı, bağımsızlık';
      case 6: return 'Uyum özlemi, denge';
      case 7: return 'Tutku, yaratıcı ifade';
      case 8: return 'Bilgi aşkı, iletişim';
      case 9: return 'Rüyalar, sezgisel derinlik';
      case 10: return 'Topraklanma, gerçekleşme';
      default: return 'Mistik derinlik';
    }
  }

  String _getPersonaMeaning(int number) {
    switch (number) {
      case 1: return 'Lider görünüm, ilham verici';
      case 2: return 'Bilge görünüm, danışman';
      case 3: return 'Analitik, düşünceli';
      case 4: return 'Yardımsever, sıcak';
      case 5: return 'Güçlü, kararlı';
      case 6: return 'Dengeli, uyumlu';
      case 7: return 'Tutkulu, çekici';
      case 8: return 'Zeki, konuşkan';
      case 9: return 'Gizemli, sezgisel';
      case 10: return 'Pratik, güvenilir';
      default: return 'Çok yönlü';
    }
  }

  Widget _buildNumberBox(BuildContext context, String label, int number, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Column(
        children: [
          Text(
            number.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyEnergyCard(BuildContext context, DailyKabbalahEnergy energy) {
    final sefirahColor = _getSefirahColor(energy.sefirah);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sefirahColor.withAlpha(38),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: sefirahColor.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny, color: sefirahColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Bugünün Sefirah\'ı: ${energy.sefirah.nameTr}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: sefirahColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            energy.guidance,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: sefirahColor.withAlpha(25),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.self_improvement, color: sefirahColor, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Günlük Meditasyon',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: sefirahColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  energy.meditation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeOfLifeCard(BuildContext context, Sefirah lifePath, Sefirah? namePath) {
    final treeInterpretation = _generateTreeInterpretation(lifePath, namePath);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withAlpha(76)),
      ),
      child: Column(
        children: [
          Text(
            'Hayat Ağacındaki Yerin',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.starGold,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Basit Hayat Ağacı görselleştirmesi
          _buildSimpleTreeOfLife(context, lifePath, namePath),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Kırmızı ile işaretli: Yaşam Yolu Sefirah\'ın\n'
            '${namePath != null ? 'Mavi ile işaretli: İsim Sefirah\'ın' : ''}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Hayat Ağacı ezoterik yorumu
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.starGold.withAlpha(15),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.starGold.withAlpha(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_tree, color: AppColors.starGold, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Spiritüel Yolculuğun',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.starGold,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  treeInterpretation,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          // Sefirah detayları
          _buildSefirahDetails(context, lifePath, namePath),
        ],
      ),
    );
  }

  Widget _buildSefirahDetails(BuildContext context, Sefirah lifePath, Sefirah? namePath) {
    final lifePathColor = _getSefirahColor(lifePath);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: lifePathColor.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yaşam Yolu Sefirah detayları
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: lifePathColor.withAlpha(50),
                  shape: BoxShape.circle,
                  border: Border.all(color: lifePathColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    lifePath.number.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: lifePathColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${lifePath.nameTr} - ${lifePath.pillar}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: lifePathColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Melek: ${lifePath.archangel}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Erdem: ${lifePath.virtue}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            'Dikkat: ${lifePath.vice}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          Text(
            'Gezegen: ${lifePath.planet}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }

  String _generateTreeInterpretation(Sefirah lifePath, Sefirah? namePath) {
    String interpretation = 'Hayat Ağacı\'nda ${lifePath.pillar}\'nda yer alıyorsun. ';

    // Sütuna göre yorum
    if (lifePath == Sefirah.keter || lifePath == Sefirah.tiferet ||
        lifePath == Sefirah.yesod || lifePath == Sefirah.malkut) {
      interpretation += 'Orta sütun, denge yoludur - zıtlıkları birleştirme, uyum yaratma görevin var. ';
    } else if (lifePath == Sefirah.chokhmah || lifePath == Sefirah.chesed ||
        lifePath == Sefirah.netzach) {
      interpretation += 'Sağ sütun, rahmet ve genişleme yoludur - sevgi, cömertlik ve yaratıcılık senin alanın. ';
    } else {
      interpretation += 'Sol sütun, form ve disiplin yoludur - sınır koyma, analiz ve güç senin alanın. ';
    }

    // İsim ve Yaşam yolu kombinasyonu
    if (namePath != null) {
      if (lifePath == namePath) {
        interpretation += 'İsmin ve doğum tarihin aynı Sefirah\'a işaret ediyor - bu enerjide çok güçlüsün!';
      } else {
        final lifeNum = lifePath.number;
        final nameNum = namePath.number;

        if ((lifeNum <= 3 && nameNum >= 8) || (lifeNum >= 8 && nameNum <= 3)) {
          interpretation += '${lifePath.nameTr} ile ${namePath.nameTr} arasındaki yolculuğun, Hayat Ağacı\'nın tamamını kapsıyor - derin bir ruhsal evrim yaşıyorsun.';
        } else {
          interpretation += '${lifePath.nameTr} doğuştan enerjin, ${namePath.nameTr} ise isminle gelen titreşimin - bu ikisi birlikte benzersiz bir spiritüel imza oluşturuyor.';
        }
      }
    } else {
      interpretation += '${lifePath.nameTr} enerjisi, bu yaşamda öğrenmen gereken ana dersi temsil ediyor.';
    }

    return interpretation;
  }

  Widget _buildSimpleTreeOfLife(BuildContext context, Sefirah lifePath, Sefirah? namePath) {
    // Basitleştirilmiş Hayat Ağacı düzeni
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Keter
        _buildSefirahNode(context, Sefirah.keter, lifePath, namePath),
        const SizedBox(height: 6),
        // Chokhmah ve Binah
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSefirahNode(context, Sefirah.binah, lifePath, namePath),
            const SizedBox(width: 50),
            _buildSefirahNode(context, Sefirah.chokhmah, lifePath, namePath),
          ],
        ),
        const SizedBox(height: 6),
        // Tiferet ve yanları
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSefirahNode(context, Sefirah.gevurah, lifePath, namePath),
            const SizedBox(width: 16),
            _buildSefirahNode(context, Sefirah.tiferet, lifePath, namePath),
            const SizedBox(width: 16),
            _buildSefirahNode(context, Sefirah.chesed, lifePath, namePath),
          ],
        ),
        const SizedBox(height: 6),
        // Hod ve Netzach
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSefirahNode(context, Sefirah.hod, lifePath, namePath),
            const SizedBox(width: 50),
            _buildSefirahNode(context, Sefirah.netzach, lifePath, namePath),
          ],
        ),
        const SizedBox(height: 6),
        // Yesod
        _buildSefirahNode(context, Sefirah.yesod, lifePath, namePath),
        const SizedBox(height: 6),
        // Malkut
        _buildSefirahNode(context, Sefirah.malkut, lifePath, namePath),
      ],
    );
  }

  Widget _buildSefirahNode(BuildContext context, Sefirah sefirah, Sefirah lifePath, Sefirah? namePath) {
    final isLifePath = sefirah == lifePath;
    final isNamePath = sefirah == namePath;
    final sefirahColor = _getSefirahColor(sefirah);

    Color borderColor = sefirahColor.withAlpha(100);
    double borderWidth = 1;

    if (isLifePath) {
      borderColor = AppColors.fireElement;
      borderWidth = 3;
    } else if (isNamePath) {
      borderColor = AppColors.waterElement;
      borderWidth = 3;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: sefirahColor.withAlpha(isLifePath || isNamePath ? 100 : 50),
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Center(
        child: Text(
          sefirah.number.toString(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isLifePath || isNamePath ? AppColors.textPrimary : sefirahColor,
                fontWeight: isLifePath || isNamePath ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
    );
  }

  Color _getSefirahColor(Sefirah sefirah) {
    switch (sefirah) {
      case Sefirah.keter: return Colors.white;
      case Sefirah.chokhmah: return Colors.grey;
      case Sefirah.binah: return const Color(0xFF1A237E);
      case Sefirah.chesed: return Colors.blue;
      case Sefirah.gevurah: return Colors.red;
      case Sefirah.tiferet: return AppColors.starGold;
      case Sefirah.netzach: return Colors.green;
      case Sefirah.hod: return Colors.orange;
      case Sefirah.yesod: return Colors.purple;
      case Sefirah.malkut: return const Color(0xFF8B4513);
    }
  }
}
