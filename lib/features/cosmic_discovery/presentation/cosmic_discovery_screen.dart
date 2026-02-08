import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/providers/app_providers.dart';
import '../../../data/models/zodiac_sign.dart' as zodiac;
import '../../../data/services/l10n_service.dart';
import '../../../shared/widgets/cosmic_background.dart';
import '../../../shared/widgets/interpretive_text.dart';

/// Kozmik Keşif - Genel Şablon Ekranı
/// Her bir keşif içeriği için özelleştirilmiş ekran
class CosmicDiscoveryScreen extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color primaryColor;
  final CosmicDiscoveryType type;

  const CosmicDiscoveryScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.primaryColor,
    required this.type,
  });

  @override
  ConsumerState<CosmicDiscoveryScreen> createState() => _CosmicDiscoveryScreenState();
}

class _CosmicDiscoveryScreenState extends ConsumerState<CosmicDiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final language = ref.watch(languageProvider);
    final sign = userProfile?.sunSign ?? zodiac.ZodiacSign.aries;
    final userName = userProfile?.name ?? L10nService.get('cosmic_discovery.default_username', language);

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, language),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Hero Section
                      _buildHeroSection(context, sign, userName, language),
                      const SizedBox(height: 24),

                      // Reveal Button or Content
                      if (!_isRevealed)
                        _buildRevealButton(context, language)
                      else
                        _buildContent(context, sign, userName, language),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Flexible(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [widget.primaryColor, Colors.white, widget.primaryColor],
                        ).createShader(bounds),
                        child: Text(
                          widget.type.getLocalizedTitle(language),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.type.getLocalizedSubtitle(language),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Share Button
          GestureDetector(
            onTap: () => _shareContent(context, language),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.primaryColor.withValues(alpha: 0.3), widget.primaryColor.withValues(alpha: 0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.primaryColor.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.share_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.primaryColor.withValues(alpha: 0.3),
            widget.primaryColor.withValues(alpha: 0.1),
            Colors.black.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.primaryColor.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Emoji ve Burç
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 50)),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [sign.color.withValues(alpha: 0.4), sign.color.withValues(alpha: 0.1)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: sign.color, width: 2),
                ),
                child: Text(sign.symbol, style: TextStyle(fontSize: 36, color: sign.color)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Başlık
          Text(
            '$userName, ${widget.title}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(color: widget.primaryColor, blurRadius: 10),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            L10nService.getWithParams(
              'cosmic_discovery.sign_analysis',
              language,
              params: {'sign': sign.localizedName(language)},
            ),
            style: TextStyle(
              fontSize: 16,
              color: sign.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealButton(BuildContext context, AppLanguage language) {
    return GestureDetector(
      onTap: () {
        setState(() => _isRevealed = true);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.primaryColor, widget.primaryColor.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: widget.primaryColor.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              L10nService.get('cosmic_discovery.discover', language),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final content = _getContent(sign, userName, language);

    return Column(
      children: [
        // Ana İçerik Kartı
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.primaryColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ana Mesaj
              AutoGlossaryText(
                text: content['mainMessage'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  height: 1.6,
                ),
                maxHighlights: 5,
              ),
              const SizedBox(height: 24),

              // Detaylar
              if (content['details'] != null) ...[
                _buildDetailSection(L10nService.get('cosmic_discovery.detailed_analysis', language), content['details']!, Icons.psychology),
                const SizedBox(height: 16),
              ],

              // Tavsiyeler
              if (content['advice'] != null) ...[
                _buildDetailSection(L10nService.get('cosmic_discovery.advice', language), content['advice']!, Icons.lightbulb_outline),
                const SizedBox(height: 16),
              ],

              // Uyarılar
              if (content['warning'] != null) ...[
                _buildWarningSection(content['warning']!),
              ],
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Paylaş Butonu
        _buildShareCard(context, content, language),
      ],
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: widget.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AutoGlossaryText(
            text: content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
            maxHighlights: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSection(String warning) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: AutoGlossaryText(
              text: warning,
              style: TextStyle(
                color: Colors.amber.shade100,
                fontSize: 13,
                height: 1.4,
              ),
              maxHighlights: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareCard(BuildContext context, Map<String, String> content, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE91E63).withValues(alpha: 0.2),
            const Color(0xFFFF5722).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.camera_alt, color: Color(0xFFE91E63), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  L10nService.get('cosmic_discovery.share_on_instagram', language),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _shareContent(context, language),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFFF5722)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    L10nService.get('cosmic_discovery.share', language),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareContent(BuildContext context, AppLanguage language) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(L10nService.get('cosmic_discovery.share_coming_soon', language)),
        backgroundColor: widget.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Map<String, String> _getContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return CosmicDiscoveryContent.getContent(widget.type, sign, userName, language);
  }
}

/// Kozmik Keşif Türleri
enum CosmicDiscoveryType {
  // Günlük Enerjiler
  dailySummary,
  moonEnergy,
  moonRituals,    // Ay Ritüelleri - distinct from moonEnergy
  loveEnergy,
  abundanceEnergy,

  // Ruhsal Dönüşüm
  spiritualTransformation,
  lifePurpose,
  subconsciousPatterns,
  karmaLessons,
  soulContract,
  innerPower,

  // Kişilik Analizleri
  shadowSelf,
  leadershipStyle,
  heartbreak,
  redFlags,
  greenFlags,
  flirtStyle,

  // Mistik Keşifler
  tarotCard,
  auraColor,
  crystalGuide,   // Kristal Rehberi - distinct from auraColor
  chakraBalance,
  lifeNumber,
  kabbalaPath,

  // Zaman & Döngüler
  saturnLessons,
  birthdayEnergy,
  eclipseEffect,
  transitFlow,

  // İlişki Analizleri
  compatibilityAnalysis,
  soulMate,
  relationshipKarma,
  celebrityTwin,
}

/// Extension for getting localized title/subtitle for CosmicDiscoveryType
extension CosmicDiscoveryTypeL10n on CosmicDiscoveryType {
  /// Get the l10n key for this type (maps enum to JSON key)
  String get _l10nKey {
    switch (this) {
      case CosmicDiscoveryType.dailySummary: return 'daily_summary';
      case CosmicDiscoveryType.moonEnergy: return 'moon_energy';
      case CosmicDiscoveryType.moonRituals: return 'moon_rituals';
      case CosmicDiscoveryType.loveEnergy: return 'love_energy';
      case CosmicDiscoveryType.abundanceEnergy: return 'abundance_energy';
      case CosmicDiscoveryType.spiritualTransformation: return 'spiritual_transformation';
      case CosmicDiscoveryType.lifePurpose: return 'life_purpose';
      case CosmicDiscoveryType.subconsciousPatterns: return 'subconscious_patterns';
      case CosmicDiscoveryType.karmaLessons: return 'karma_lessons';
      case CosmicDiscoveryType.soulContract: return 'soul_contract';
      case CosmicDiscoveryType.innerPower: return 'inner_power';
      case CosmicDiscoveryType.shadowSelf: return 'shadow_self';
      case CosmicDiscoveryType.leadershipStyle: return 'leadership_style';
      case CosmicDiscoveryType.heartbreak: return 'heartbreak';
      case CosmicDiscoveryType.redFlags: return 'red_flags';
      case CosmicDiscoveryType.greenFlags: return 'green_flags';
      case CosmicDiscoveryType.flirtStyle: return 'flirt_style';
      case CosmicDiscoveryType.tarotCard: return 'tarot_card';
      case CosmicDiscoveryType.auraColor: return 'aura_color';
      case CosmicDiscoveryType.crystalGuide: return 'crystal_guide';
      case CosmicDiscoveryType.chakraBalance: return 'chakra_balance';
      case CosmicDiscoveryType.lifeNumber: return 'life_number';
      case CosmicDiscoveryType.kabbalaPath: return 'kabbala_path';
      case CosmicDiscoveryType.saturnLessons: return 'saturn_lessons';
      case CosmicDiscoveryType.birthdayEnergy: return 'birthday_energy';
      case CosmicDiscoveryType.eclipseEffect: return 'eclipse_effect';
      case CosmicDiscoveryType.transitFlow: return 'transit_flow';
      case CosmicDiscoveryType.compatibilityAnalysis: return 'compatibility_analysis';
      case CosmicDiscoveryType.soulMate: return 'soul_mate';
      case CosmicDiscoveryType.relationshipKarma: return 'relationship_karma';
      case CosmicDiscoveryType.celebrityTwin: return 'celebrity_twin';
    }
  }

  /// Get localized title for this type
  String getLocalizedTitle(AppLanguage language) {
    return L10nService.get('cosmic_discovery.routes.$_l10nKey.title', language);
  }

  /// Get localized subtitle for this type
  String getLocalizedSubtitle(AppLanguage language) {
    return L10nService.get('cosmic_discovery.routes.$_l10nKey.subtitle', language);
  }
}

/// Kozmik Keşif İçerik Sağlayıcı
class CosmicDiscoveryContent {
  static String _signKey(zodiac.ZodiacSign sign) {
    switch (sign) {
      case zodiac.ZodiacSign.aries: return 'aries';
      case zodiac.ZodiacSign.taurus: return 'taurus';
      case zodiac.ZodiacSign.gemini: return 'gemini';
      case zodiac.ZodiacSign.cancer: return 'cancer';
      case zodiac.ZodiacSign.leo: return 'leo';
      case zodiac.ZodiacSign.virgo: return 'virgo';
      case zodiac.ZodiacSign.libra: return 'libra';
      case zodiac.ZodiacSign.scorpio: return 'scorpio';
      case zodiac.ZodiacSign.sagittarius: return 'sagittarius';
      case zodiac.ZodiacSign.capricorn: return 'capricorn';
      case zodiac.ZodiacSign.aquarius: return 'aquarius';
      case zodiac.ZodiacSign.pisces: return 'pisces';
    }
  }

  static Map<String, String> getContent(CosmicDiscoveryType type, zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    switch (type) {
      case CosmicDiscoveryType.shadowSelf:
        return _getShadowSelfContent(sign, userName, language);
      case CosmicDiscoveryType.redFlags:
        return _getRedFlagsContent(sign, userName, language);
      case CosmicDiscoveryType.greenFlags:
        return _getGreenFlagsContent(sign, userName, language);
      case CosmicDiscoveryType.lifePurpose:
        return _getLifePurposeContent(sign, userName, language);
      case CosmicDiscoveryType.karmaLessons:
        return _getKarmaLessonsContent(sign, userName, language);
      case CosmicDiscoveryType.soulContract:
        return _getSoulContractContent(sign, userName, language);
      case CosmicDiscoveryType.innerPower:
        return _getInnerPowerContent(sign, userName, language);
      case CosmicDiscoveryType.flirtStyle:
        return _getFlirtStyleContent(sign, userName, language);
      case CosmicDiscoveryType.leadershipStyle:
        return _getLeadershipStyleContent(sign, userName, language);
      case CosmicDiscoveryType.heartbreak:
        return _getHeartbreakContent(sign, userName, language);
      case CosmicDiscoveryType.soulMate:
        return _getSoulMateContent(sign, userName, language);
      case CosmicDiscoveryType.spiritualTransformation:
        return _getSpiritualTransformationContent(sign, userName, language);
      case CosmicDiscoveryType.subconsciousPatterns:
        return _getSubconsciousPatternsContent(sign, userName, language);
      case CosmicDiscoveryType.dailySummary:
        return _getDailySummaryContent(sign, userName, language);
      case CosmicDiscoveryType.moonEnergy:
        return _getMoonEnergyContent(sign, userName, language);
      case CosmicDiscoveryType.moonRituals:
        return _getMoonRitualsContent(sign, userName, language);
      case CosmicDiscoveryType.loveEnergy:
        return _getLoveEnergyContent(sign, userName, language);
      case CosmicDiscoveryType.abundanceEnergy:
        return _getAbundanceEnergyContent(sign, userName, language);
      case CosmicDiscoveryType.tarotCard:
        return _getTarotCardContent(sign, userName, language);
      case CosmicDiscoveryType.auraColor:
        return _getAuraColorContent(sign, userName, language);
      case CosmicDiscoveryType.crystalGuide:
        return _getCrystalGuideContent(sign, userName, language);
      case CosmicDiscoveryType.chakraBalance:
        return _getChakraBalanceContent(sign, userName, language);
      case CosmicDiscoveryType.lifeNumber:
        return _getLifeNumberContent(sign, userName, language);
      case CosmicDiscoveryType.kabbalaPath:
        return _getKabbalaPathContent(sign, userName, language);
      case CosmicDiscoveryType.saturnLessons:
        return _getSaturnLessonsContent(sign, userName, language);
      case CosmicDiscoveryType.birthdayEnergy:
        return _getBirthdayEnergyContent(sign, userName, language);
      case CosmicDiscoveryType.eclipseEffect:
        return _getEclipseEffectContent(sign, userName, language);
      case CosmicDiscoveryType.transitFlow:
        return _getTransitFlowContent(sign, userName, language);
      case CosmicDiscoveryType.compatibilityAnalysis:
        return _getCompatibilityAnalysisContent(sign, userName, language);
      case CosmicDiscoveryType.relationshipKarma:
        return _getRelationshipKarmaContent(sign, userName, language);
      case CosmicDiscoveryType.celebrityTwin:
        return _getCelebrityTwinContent(sign, userName, language);
    }
  }

  static Map<String, String> _getShadowSelfContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.shadow_self.$signKey.main',
        language,
        params: {'name': userName},
      ),
      'details': L10nService.get('cosmic_discovery.shadow_self.$signKey.details', language),
      'advice': L10nService.get('cosmic_discovery.shadow_self.$signKey.advice', language),
      'warning': L10nService.get('cosmic_discovery.shadow_self.$signKey.warning', language),
    };
  }

  static Map<String, String> _getRedFlagsContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.red_flags.$signKey.main',
        language,
        params: {'name': userName},
      ),
      'details': L10nService.get('cosmic_discovery.red_flags.$signKey.details', language),
      'advice': L10nService.get('cosmic_discovery.red_flags.$signKey.advice', language),
    };
  }

  static Map<String, String> _getGreenFlagsContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.green_flags.$signKey.main',
        language,
        params: {'name': userName},
      ),
      'details': L10nService.get('cosmic_discovery.green_flags.$signKey.details', language),
      'advice': L10nService.get('cosmic_discovery.green_flags.$signKey.advice', language),
    };
  }

  static Map<String, String> _getLifePurposeContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.life_purpose.$signKey.main',
        language,
        params: {'name': userName},
      ),
      'details': L10nService.get('cosmic_discovery.life_purpose.$signKey.details', language),
      'advice': L10nService.get('cosmic_discovery.life_purpose.$signKey.advice', language),
    };
  }

  static Map<String, String> _getKarmaLessonsContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signName = sign.localizedName(language);
    final elementName = sign.element.localizedName(language);
    final elementLesson = L10nService.get('cosmic_discovery.karma_lessons.${sign.element.name.toLowerCase()}_lesson', language);

    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.karma_lessons.main',
        language,
        params: {'name': userName, 'sign': signName},
      ),
      'details': '${L10nService.get('cosmic_discovery.karma_lessons.details_intro', language)}\n'
          '${L10nService.getWithParams('cosmic_discovery.karma_lessons.details_template', language, params: {'element': elementName, 'lesson': elementLesson})}\n\n'
          '${L10nService.get('cosmic_discovery.karma_lessons.soul_contract_lessons', language)}\n'
          '${L10nService.get('cosmic_discovery.karma_lessons.saturn_lessons', language)}\n'
          '${L10nService.get('cosmic_discovery.karma_lessons.chiron_wounds', language)}\n'
          '${L10nService.get('cosmic_discovery.karma_lessons.north_node', language)}\n\n'
          '${L10nService.get('cosmic_discovery.karma_lessons.karma_timeline', language)}\n'
          '${L10nService.get('cosmic_discovery.karma_lessons.karma_timeline_desc', language)}',
      'advice': L10nService.get('cosmic_discovery.karma_lessons.advice', language),
      'warning': L10nService.get('cosmic_discovery.karma_lessons.warning', language),
    };
  }

  static Map<String, String> _getSoulContractContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    final signName = sign.localizedName(language);
    final theme = L10nService.get('cosmic_discovery.soul_contract.themes.$signKey', language);

    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.soul_contract.main',
        language,
        params: {'name': userName, 'sign': signName},
      ),
      'details': '${L10nService.get('cosmic_discovery.soul_contract.contract_items', language)}\n\n'
          '${L10nService.getWithParams('cosmic_discovery.soul_contract.contract_intro', language, params: {'sign': signName, 'theme': theme})}\n\n'
          '${L10nService.get('cosmic_discovery.soul_contract.contract_details', language)}\n'
          '${L10nService.get('cosmic_discovery.soul_contract.life_purpose', language)}\n'
          '${L10nService.get('cosmic_discovery.soul_contract.past_life_legacy', language)}\n'
          '${L10nService.get('cosmic_discovery.soul_contract.healing_mission', language)}\n'
          '${L10nService.get('cosmic_discovery.soul_contract.maturation_areas', language)}\n\n'
          '${L10nService.get('cosmic_discovery.soul_contract.soul_connections', language)}\n'
          '${L10nService.get('cosmic_discovery.soul_contract.soul_connections_desc', language)}',
      'advice': L10nService.get('cosmic_discovery.soul_contract.advice', language),
      'warning': L10nService.get('cosmic_discovery.soul_contract.warning', language),
    };
  }

  static Map<String, String> _getInnerPowerContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    final signName = sign.localizedName(language);

    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.inner_power.main',
        language,
        params: {'name': userName, 'sign': signName},
      ),
      'details': '${L10nService.get('cosmic_discovery.inner_power.details_intro', language)}\n'
          '${L10nService.get('cosmic_discovery.inner_power.powers.$signKey.power1', language)}\n'
          '${L10nService.get('cosmic_discovery.inner_power.powers.$signKey.power2', language)}\n'
          '${L10nService.get('cosmic_discovery.inner_power.powers.$signKey.power3', language)}',
      'advice': L10nService.get('cosmic_discovery.inner_power.advice', language),
    };
  }

  static Map<String, String> _getFlirtStyleContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.flirt_style.$signKey.main',
        language,
        params: {'name': userName},
      ),
      'details': L10nService.get('cosmic_discovery.flirt_style.$signKey.details', language),
      'advice': L10nService.get('cosmic_discovery.flirt_style.$signKey.advice', language),
    };
  }

  static Map<String, String> _getLeadershipStyleContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    final signName = sign.localizedName(language);
    final type = L10nService.get('cosmic_discovery.leadership_style.types.$signKey', language);
    final strength = L10nService.get('cosmic_discovery.leadership_style.strengths.$signKey', language);
    final weakness = L10nService.get('cosmic_discovery.leadership_style.weaknesses.$signKey', language);
    final adviceText = L10nService.get('cosmic_discovery.leadership_style.advice.$signKey', language);

    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.leadership_style.main',
        language,
        params: {'name': userName, 'sign': signName},
      ),
      'details': L10nService.getWithParams(
        'cosmic_discovery.leadership_style.details_template',
        language,
        params: {'type': type, 'strength': strength, 'weakness': weakness},
      ),
      'advice': L10nService.getWithParams(
        'cosmic_discovery.leadership_style.advice_template',
        language,
        params: {'advice': adviceText},
      ),
    };
  }

  static Map<String, String> _getHeartbreakContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    final signName = sign.localizedName(language);
    final trigger = L10nService.get('cosmic_discovery.heartbreak.triggers.$signKey', language);
    final reaction = L10nService.get('cosmic_discovery.heartbreak.reactions.$signKey', language);
    final healing = L10nService.get('cosmic_discovery.heartbreak.healing.$signKey', language);
    final adviceText = L10nService.get('cosmic_discovery.heartbreak.advice.$signKey', language);

    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.heartbreak.main',
        language,
        params: {'name': userName, 'sign': signName},
      ),
      'details': L10nService.getWithParams(
        'cosmic_discovery.heartbreak.details_template',
        language,
        params: {'trigger': trigger, 'reaction': reaction, 'healing': healing},
      ),
      'advice': L10nService.getWithParams(
        'cosmic_discovery.heartbreak.advice_template',
        language,
        params: {'advice': adviceText},
      ),
      'warning': L10nService.get('cosmic_discovery.heartbreak.warning', language),
    };
  }

  static Map<String, String> _getSoulMateContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    final signName = sign.localizedName(language);
    final description = L10nService.get('cosmic_discovery.soul_mate.descriptions.$signKey', language);
    final compatible = L10nService.get('cosmic_discovery.soul_mate.compatible.$signKey', language);
    final places = L10nService.get('cosmic_discovery.soul_mate.places.$signKey', language);
    final adviceText = L10nService.get('cosmic_discovery.soul_mate.advice.$signKey', language);

    return {
      'mainMessage': L10nService.getWithParams(
        'cosmic_discovery.soul_mate.main',
        language,
        params: {'name': userName, 'sign': signName},
      ),
      'details': L10nService.getWithParams(
        'cosmic_discovery.soul_mate.details_template',
        language,
        params: {'description': description, 'compatible': compatible, 'places': places},
      ),
      'advice': L10nService.getWithParams(
        'cosmic_discovery.soul_mate.advice_template',
        language,
        params: {'advice': adviceText},
      ),
    };
  }

  // For content types not yet fully translated, return loading message
  static Map<String, String> _getSpiritualTransformationContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getSubconsciousPatternsContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getDailySummaryContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getMoonEnergyContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getMoonRitualsContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getLoveEnergyContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getAbundanceEnergyContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getTarotCardContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getAuraColorContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getCrystalGuideContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getChakraBalanceContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getLifeNumberContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getKabbalaPathContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getSaturnLessonsContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getBirthdayEnergyContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getEclipseEffectContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getTransitFlowContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getCompatibilityAnalysisContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getRelationshipKarmaContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }

  static Map<String, String> _getCelebrityTwinContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    return {
      'mainMessage': L10nService.get('cosmic_discovery.loading', language),
      'details': L10nService.get('cosmic_discovery.loading', language),
      'advice': L10nService.get('cosmic_discovery.loading', language),
    };
  }
}

// _CosmicBackgroundPainter removed - using CosmicBackground widget instead
