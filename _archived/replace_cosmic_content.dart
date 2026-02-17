// This is the new i18n-enabled CosmicDiscoveryContent class to replace the old one

const newCosmicDiscoveryContent = r'''
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
    final signKey = _signKey(sign);
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
    final advice = L10nService.get('cosmic_discovery.leadership_style.advice.$signKey', language);

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
        params: {'advice': advice},
      ),
    };
  }

  static Map<String, String> _getHeartbreakContent(zodiac.ZodiacSign sign, String userName, AppLanguage language) {
    final signKey = _signKey(sign);
    final signName = sign.localizedName(language);
    final trigger = L10nService.get('cosmic_discovery.heartbreak.triggers.$signKey', language);
    final reaction = L10nService.get('cosmic_discovery.heartbreak.reactions.$signKey', language);
    final healing = L10nService.get('cosmic_discovery.heartbreak.healing.$signKey', language);
    final advice = L10nService.get('cosmic_discovery.heartbreak.advice.$signKey', language);

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
        params: {'advice': advice},
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
    final advice = L10nService.get('cosmic_discovery.soul_mate.advice.$signKey', language);

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
        params: {'advice': advice},
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
''';

void main() {
  // ignore: avoid_print
  print(newCosmicDiscoveryContent);
}
