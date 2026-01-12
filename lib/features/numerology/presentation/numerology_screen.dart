import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/numerology_service.dart';
import '../../../shared/widgets/cosmic_background.dart';

class NumerologyScreen extends ConsumerWidget {
  const NumerologyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return Scaffold(
        body: CosmicBackground(
          child: Center(
            child: Text(
              'Lütfen önce doğum bilgilerinizi girin',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ),
      );
    }

    final lifePath = NumerologyService.calculateLifePathNumber(userProfile.birthDate);
    final birthday = NumerologyService.calculateBirthdayNumber(userProfile.birthDate);
    final personalYear = NumerologyService.calculatePersonalYearNumber(
        userProfile.birthDate, DateTime.now().year);
    final lifePathMeaning = NumerologyService.getNumberMeaning(lifePath);

    // If user has name, calculate name-based numbers
    int? destinyNumber;
    int? soulUrgeNumber;
    int? personalityNumber;
    NumerologyMeaning? destinyMeaning;

    if (userProfile.name != null && userProfile.name!.isNotEmpty) {
      destinyNumber = NumerologyService.calculateDestinyNumber(userProfile.name!);
      soulUrgeNumber = NumerologyService.calculateSoulUrgeNumber(userProfile.name!);
      personalityNumber = NumerologyService.calculatePersonalityNumber(userProfile.name!);
      destinyMeaning = NumerologyService.getNumberMeaning(destinyNumber);
    }

    final karmicDebts = NumerologyService.findKarmicDebtNumbers(userProfile.birthDate);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                floating: true,
                title: Text(
                  'Numeroloji',
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
                    // Esoteric intro
                    _buildEsotericIntro(context),
                    const SizedBox(height: AppConstants.spacingLg),
                    // Life Path Number - Main card
                    _buildMainNumberCard(
                      context,
                      'Yaşam Yolu Sayısı',
                      lifePath,
                      lifePathMeaning.title,
                      lifePathMeaning.meaning,
                      AppColors.starGold,
                      Icons.route,
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Quick stats row
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickStat(
                            context,
                            'Doğum Günü',
                            birthday.toString(),
                            AppColors.auroraStart,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: _buildQuickStat(
                            context,
                            'Kişisel Yıl',
                            personalYear.toString(),
                            AppColors.auroraEnd,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Name-based numbers (if name provided)
                    if (destinyNumber != null) ...[
                      _buildSectionTitle(context, 'İsim Numerolojisi'),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildNumberCard(
                        context,
                        'Kader Sayısı',
                        destinyNumber,
                        destinyMeaning?.title ?? '',
                        'İsminizin toplam değerinden hesaplanan bu sayı, hayatınızdaki ana amacınızı ve potansiyelinizi ortaya koyar.',
                        AppColors.fireElement,
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: AppConstants.spacingMd),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickStat(
                              context,
                              'Ruh Dürtüsü',
                              soulUrgeNumber.toString(),
                              AppColors.waterElement,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMd),
                          Expanded(
                            child: _buildQuickStat(
                              context,
                              'Kişilik',
                              personalityNumber.toString(),
                              AppColors.earthElement,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                      const SizedBox(height: AppConstants.spacingLg),
                    ],

                    // Karmic debts
                    if (karmicDebts.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Karmik Borç Sayıları'),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildKarmicDebtCard(context, karmicDebts)
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms),
                      const SizedBox(height: AppConstants.spacingLg),
                    ],

                    // Life Path detailed interpretation
                    _buildSectionTitle(context, 'Yaşam Yolu Yorumu'),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildInterpretationCard(context, lifePath, lifePathMeaning)
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Detailed interpretation - NEW
                    if (lifePathMeaning.detailedInterpretation.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Derin Yorum'),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildDetailedInterpretationCard(context, lifePathMeaning)
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 400.ms),
                      const SizedBox(height: AppConstants.spacingLg),
                    ],

                    // Career & Spiritual sections - NEW
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Kariyer Yolu',
                            lifePathMeaning.careerPath,
                            Icons.work,
                            AppColors.auroraEnd,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            'Uyumlu Sayılar',
                            lifePathMeaning.compatibleNumbers,
                            Icons.favorite,
                            AppColors.fireElement,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Spiritual lesson - NEW
                    _buildSpiritualLessonCard(context, lifePathMeaning)
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Shadow side - NEW
                    _buildShadowSideCard(context, lifePathMeaning)
                        .animate()
                        .fadeIn(delay: 900.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingXl),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainNumberCard(
    BuildContext context,
    String title,
    int number,
    String subtitle,
    String description,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withAlpha(76),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: color.withAlpha(128)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildNumberCard(
    BuildContext context,
    String title,
    int number,
    String subtitle,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withAlpha(76)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
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
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                      ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKarmicDebtCard(BuildContext context, List<int> karmicDebts) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.error.withAlpha(38),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.error.withAlpha(76)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              Text(
                'Karmik Borç Sayıları',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.error,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: karmicDebts.map((debt) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  debt.toString(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            _getKarmicDebtDescription(karmicDebts.first),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
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

  Widget _buildInterpretationCard(
      BuildContext context, int number, NumerologyMeaning meaning) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: Colors.white.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Keywords
          Row(
            children: [
              Icon(Icons.tag, color: AppColors.auroraStart, size: 18),
              const SizedBox(width: 8),
              Text(
                'Anahtar Kelimeler',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.auroraStart,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meaning.keywords,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Strengths
          Row(
            children: [
              Icon(Icons.star, color: AppColors.success, size: 18),
              const SizedBox(width: 8),
              Text(
                'Güçlü Yanlar',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.success,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meaning.strengths,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Challenges
          Row(
            children: [
              Icon(Icons.psychology, color: AppColors.warning, size: 18),
              const SizedBox(width: 8),
              Text(
                'Zorluklar',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.warning,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meaning.challenges,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Love style
          Row(
            children: [
              Icon(Icons.favorite, color: AppColors.fireElement, size: 18),
              const SizedBox(width: 8),
              Text(
                'Aşk ve İlişki',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.fireElement,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            meaning.loveStyle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  String _getKarmicDebtDescription(int debt) {
    switch (debt) {
      case 13:
        return 'Tembellik ve sorumsuzluktan kaynaklanan karmik bir borç. Bu hayatta sıkı çalışma ve disiplin yoluyla dengelenmelidir.';
      case 14:
        return 'Özgürlüğü kötüye kullanmaktan kaynaklanan bir borç. Bu hayatta sorumluluk ve ölçülülük öğrenmek gerekiyor.';
      case 16:
        return 'Ego ve ilişki sorunlarından kaynaklanan bir borç. Alçakgönüllülük ve içsel dönüşüm gerektiriyor.';
      case 19:
        return 'Güç ve otoriteyi kötüye kullanmaktan kaynaklanan bir borç. Bağımsızlık ve başkalarına yardım etme dengesi öğrenmek gerekiyor.';
      default:
        return 'Bu sayı karmik bir borç taşıyor ve bu hayatta belirli dersler öğrenilmesini gerektiriyor.';
    }
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
                'Sayıların Kadim Sırrı',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.starGold,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Numeroloji, evrenin matematiksel bir dille konuştuğu kadim bir bilgeliktir. Pisagor\'dan Kabala\'ya, tüm ezoterik gelenekler sayıların gücünü bilir. Doğum tarihin ve ismin, ruhunun bu dünyaya getirdiği titreşimi taşır. Her sayı bir frekans, bir enerji, bir kaderdir. Burada gördüklerin rastlantı değil - ruhunun şifresidir.',
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

  Widget _buildDetailedInterpretationCard(
      BuildContext context, NumerologyMeaning meaning) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.auroraStart.withAlpha(20),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.auroraStart.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.auroraStart.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  meaning.number.toString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.auroraStart,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Text(
                  '${meaning.number} Sayısının Derinliği',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.auroraStart,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            meaning.detailedInterpretation.trim(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpiritualLessonCard(BuildContext context, NumerologyMeaning meaning) {
    if (meaning.spiritualLesson.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.moonSilver.withAlpha(20),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.moonSilver.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.moonSilver.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb,
                  size: 18,
                  color: AppColors.moonSilver,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Text(
                  'Ruhsal Ders',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.moonSilver,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            meaning.spiritualLesson,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadowSideCard(BuildContext context, NumerologyMeaning meaning) {
    if (meaning.shadowSide.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.error.withAlpha(15),
            AppColors.surfaceDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.error.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nights_stay,
                  size: 18,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Text(
                  'Gölge Taraf',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.error,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            meaning.shadowSide,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Bu yönler farkındalıkla dönüştürülebilir. Gölgeyi kabullenmek, ona güç vermek değil - onu entegre etmektir.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
