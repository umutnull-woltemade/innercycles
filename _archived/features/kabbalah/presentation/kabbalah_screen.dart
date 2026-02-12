import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/services/kabbalah_service.dart';
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/entertainment_disclaimer.dart';
import '../../../shared/widgets/null_profile_placeholder.dart';

class KabbalahScreen extends ConsumerWidget {
  const KabbalahScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);

    if (userProfile == null) {
      return const NullProfilePlaceholder(
        emoji: '🕎',
        titleKey: 'kabbalah_analysis',
        messageKey: 'enter_birth_info_kabbalah',
      );
    }

    final lifePathSefirah = KabbalahService.calculateLifePathSefirah(
      userProfile.birthDate,
    );
    final dailyEnergy = KabbalahService.getDailyEnergy(DateTime.now());

    Sefirah? nameSefirah;
    int? kabbalahNumber;
    int? soulNumber;
    int? personaNumber;

    if (userProfile.name != null && userProfile.name!.isNotEmpty) {
      nameSefirah = KabbalahService.calculateNameSefirah(userProfile.name!);
      kabbalahNumber = KabbalahService.calculateKabbalahNumber(
        userProfile.name!,
      );
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
                  L10nService.get('kabbalah.title', language),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.starGold,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Ezoterik giriş
                    _buildEsotericIntro(context, language),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Ana Sefirah kartı
                    _buildMainSefirahCard(
                      context,
                      lifePathSefirah,
                      language,
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // İsim bazlı sayılar
                    if (nameSefirah != null) ...[
                      _buildSectionTitle(
                        context,
                        L10nService.get('kabbalah.name_kabbalah', language),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      _buildNameKabbalahCard(
                        context,
                        nameSefirah,
                        kabbalahNumber!,
                        soulNumber!,
                        personaNumber!,
                        userProfile.name!,
                        language,
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: AppConstants.spacingLg),
                    ],

                    // Günlük enerji
                    _buildSectionTitle(
                      context,
                      L10nService.get('kabbalah.daily_energy', language),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildDailyEnergyCard(
                      context,
                      dailyEnergy,
                      language,
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Hayat Ağacı
                    _buildSectionTitle(
                      context,
                      L10nService.get('kabbalah.tree_of_life', language),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildTreeOfLifeCard(
                      context,
                      lifePathSefirah,
                      nameSefirah,
                      language,
                    ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                    const SizedBox(height: AppConstants.spacingXl),
                    // Entertainment Disclaimer
                    PageFooterWithDisclaimer(
                      brandText: 'Kabala — Venus One',
                      disclaimerText: DisclaimerTexts.astrology(language),
                      language: language,
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

  Widget _buildEsotericIntro(BuildContext context, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.starGold.withAlpha(25), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.starGold.withAlpha(51)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppColors.starGold,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                L10nService.get('kabbalah.tree_of_life_secret', language),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.starGold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            L10nService.get('kabbalah.tree_of_life_intro', language),
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

  Widget _buildMainSefirahCard(
    BuildContext context,
    Sefirah sefirah,
    AppLanguage language,
  ) {
    final sefirahColor = _getSefirahColor(sefirah);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [sefirahColor.withAlpha(76), AppColors.surfaceDark],
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
                      L10nService.get('kabbalah.life_path_sefirah', language),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      sefirah.localizedName(language),
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(color: sefirahColor),
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
              _buildSefirahAttribute(
                context,
                L10nService.get('kabbalah.color', language),
                sefirah.color,
                sefirahColor,
              ),
              const SizedBox(width: AppConstants.spacingMd),
              _buildSefirahAttribute(
                context,
                L10nService.get('kabbalah.number', language),
                sefirah.number.toString(),
                sefirahColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSefirahAttribute(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
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
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: color),
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
    AppLanguage language,
  ) {
    final sefirahColor = _getSefirahColor(sefirah);
    final personalInterpretation = _generateNameInterpretation(
      name,
      sefirah,
      kabbalahNumber,
      soulNumber,
      personaNumber,
      language,
    );

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
                  '${L10nService.get('kabbalah.name_analysis', language)}: $name',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: sefirahColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: _buildNumberBox(
                  context,
                  L10nService.get('kabbalah.kabbalah_number', language),
                  kabbalahNumber,
                  sefirahColor,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Expanded(
                child: _buildNumberBox(
                  context,
                  L10nService.get('kabbalah.soul_number', language),
                  soulNumber,
                  AppColors.waterElement,
                ),
              ),
              const SizedBox(width: AppConstants.spacingSm),
              Expanded(
                child: _buildNumberBox(
                  context,
                  L10nService.get('kabbalah.persona_number', language),
                  personaNumber,
                  AppColors.earthElement,
                ),
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
                    '${L10nService.get('kabbalah.name_sefirah', language)}: ${sefirah.localizedName(language)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: sefirahColor),
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
                colors: [sefirahColor.withAlpha(15), Colors.transparent],
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
                      L10nService.get(
                        'kabbalah.personal_interpretation',
                        language,
                      ),
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
          _buildSoulPersonaDetails(
            context,
            soulNumber,
            personaNumber,
            language,
          ),
        ],
      ),
    );
  }

  Widget _buildSoulPersonaDetails(
    BuildContext context,
    int soulNumber,
    int personaNumber,
    AppLanguage language,
  ) {
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
                  '${L10nService.get('kabbalah.soul_label', language)} ($soulNumber - ${soulSefirah.localizedName(language)}): ${_getSoulMeaning(soulNumber, language)}',
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
                  '${L10nService.get('kabbalah.persona_label', language)} ($personaNumber - ${personaSefirah.localizedName(language)}): ${_getPersonaMeaning(personaNumber, language)}',
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

  String _generateNameInterpretation(
    String name,
    Sefirah sefirah,
    int kabbalahNumber,
    int soulNumber,
    int personaNumber,
    AppLanguage language,
  ) {
    final gematria = KabbalahService.calculateGematria(name);

    // Personalized interpretations
    String introTemplate = L10nService.get(
      'kabbalah.interpretation.name_intro',
      language,
    );
    String interpretation = introTemplate
        .replaceAll('{name}', name)
        .replaceAll('{gematria}', gematria.toString())
        .replaceAll('{sefirah}', sefirah.localizedName(language));

    // Sefirah-based personality traits
    final sefirahKey =
        'kabbalah.interpretation.sefirah_${sefirah.name.toLowerCase()}';
    interpretation += L10nService.get(sefirahKey, language);

    // Additional comment based on Soul and Persona balance
    final difference = (soulNumber - personaNumber).abs();
    if (difference <= 2) {
      interpretation += L10nService.get(
        'kabbalah.interpretation.balance_harmony',
        language,
      );
    } else if (difference <= 4) {
      interpretation += L10nService.get(
        'kabbalah.interpretation.balance_dynamic',
        language,
      );
    } else {
      interpretation += L10nService.get(
        'kabbalah.interpretation.balance_mystery',
        language,
      );
    }

    return interpretation;
  }

  String _getSoulMeaning(int number, AppLanguage language) {
    final key = number >= 1 && number <= 10
        ? 'kabbalah.soul_meanings.$number'
        : 'kabbalah.soul_meanings.default';
    return L10nService.get(key, language);
  }

  String _getPersonaMeaning(int number, AppLanguage language) {
    final key = number >= 1 && number <= 10
        ? 'kabbalah.persona_meanings.$number'
        : 'kabbalah.persona_meanings.default';
    return L10nService.get(key, language);
  }

  Widget _buildNumberBox(
    BuildContext context,
    String label,
    int number,
    Color color,
  ) {
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
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyEnergyCard(
    BuildContext context,
    DailyKabbalahEnergy energy,
    AppLanguage language,
  ) {
    final sefirahColor = _getSefirahColor(energy.sefirah);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [sefirahColor.withAlpha(38), AppColors.surfaceDark],
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
                '${L10nService.get('kabbalah.todays_sefirah', language)}: ${energy.sefirah.localizedName(language)}',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: sefirahColor),
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
                      L10nService.get('kabbalah.daily_meditation', language),
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: sefirahColor),
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

  Widget _buildTreeOfLifeCard(
    BuildContext context,
    Sefirah lifePath,
    Sefirah? namePath,
    AppLanguage language,
  ) {
    final treeInterpretation = _generateTreeInterpretation(
      lifePath,
      namePath,
      language,
    );

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
            L10nService.get('kabbalah.your_place_on_tree', language),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.starGold),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          // Basit Hayat Ağacı görselleştirmesi
          _buildSimpleTreeOfLife(context, lifePath, namePath),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            '${L10nService.get('kabbalah.marked_red', language)}\n'
            '${namePath != null ? L10nService.get('kabbalah.marked_blue', language) : ''}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
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
                colors: [AppColors.starGold.withAlpha(15), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.starGold.withAlpha(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_tree,
                      color: AppColors.starGold,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      L10nService.get('kabbalah.spiritual_journey', language),
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
          _buildSefirahDetails(context, lifePath, namePath, language),
        ],
      ),
    );
  }

  Widget _buildSefirahDetails(
    BuildContext context,
    Sefirah lifePath,
    Sefirah? namePath,
    AppLanguage language,
  ) {
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
                      '${lifePath.localizedName(language)} - ${lifePath.pillar}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: lifePathColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${L10nService.get('kabbalah.archangel', language)}: ${lifePath.archangel}',
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
            '${L10nService.get('kabbalah.virtue', language)}: ${lifePath.virtue}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            '${L10nService.get('kabbalah.caution', language)}: ${lifePath.vice}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
          ),
          Text(
            '${L10nService.get('kabbalah.planet', language)}: ${lifePath.planet}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  String _generateTreeInterpretation(
    Sefirah lifePath,
    Sefirah? namePath,
    AppLanguage language,
  ) {
    String interpretation = '';

    // Column-based interpretation
    if (lifePath == Sefirah.keter ||
        lifePath == Sefirah.tiferet ||
        lifePath == Sefirah.yesod ||
        lifePath == Sefirah.malkut) {
      interpretation += L10nService.get(
        'kabbalah.tree_interpretation.middle_pillar',
        language,
      );
    } else if (lifePath == Sefirah.chokhmah ||
        lifePath == Sefirah.chesed ||
        lifePath == Sefirah.netzach) {
      interpretation += L10nService.get(
        'kabbalah.tree_interpretation.right_pillar',
        language,
      );
    } else {
      interpretation += L10nService.get(
        'kabbalah.tree_interpretation.left_pillar',
        language,
      );
    }

    // Name and Life Path combination
    if (namePath != null) {
      if (lifePath == namePath) {
        interpretation += L10nService.get(
          'kabbalah.tree_interpretation.same_sefirah',
          language,
        );
      } else {
        final lifeNum = lifePath.number;
        final nameNum = namePath.number;

        if ((lifeNum <= 3 && nameNum >= 8) || (lifeNum >= 8 && nameNum <= 3)) {
          String template = L10nService.get(
            'kabbalah.tree_interpretation.full_journey',
            language,
          );
          interpretation += template
              .replaceAll('{lifePath}', lifePath.localizedName(language))
              .replaceAll('{namePath}', namePath.localizedName(language));
        } else {
          String template = L10nService.get(
            'kabbalah.tree_interpretation.unique_signature',
            language,
          );
          interpretation += template
              .replaceAll('{lifePath}', lifePath.localizedName(language))
              .replaceAll('{namePath}', namePath.localizedName(language));
        }
      }
    } else {
      String template = L10nService.get(
        'kabbalah.tree_interpretation.single_sefirah',
        language,
      );
      interpretation += template.replaceAll(
        '{lifePath}',
        lifePath.localizedName(language),
      );
    }

    return interpretation;
  }

  Widget _buildSimpleTreeOfLife(
    BuildContext context,
    Sefirah lifePath,
    Sefirah? namePath,
  ) {
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

  Widget _buildSefirahNode(
    BuildContext context,
    Sefirah sefirah,
    Sefirah lifePath,
    Sefirah? namePath,
  ) {
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
            color: isLifePath || isNamePath
                ? AppColors.textPrimary
                : sefirahColor,
            fontWeight: isLifePath || isNamePath
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
    );
  }

  Color _getSefirahColor(Sefirah sefirah) {
    switch (sefirah) {
      case Sefirah.keter:
        return Colors.white;
      case Sefirah.chokhmah:
        return Colors.grey;
      case Sefirah.binah:
        return const Color(0xFF1A237E);
      case Sefirah.chesed:
        return Colors.blue;
      case Sefirah.gevurah:
        return Colors.red;
      case Sefirah.tiferet:
        return AppColors.starGold;
      case Sefirah.netzach:
        return Colors.green;
      case Sefirah.hod:
        return Colors.orange;
      case Sefirah.yesod:
        return Colors.purple;
      case Sefirah.malkut:
        return const Color(0xFF8B4513);
    }
  }
}
