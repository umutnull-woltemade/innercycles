/// Navigation Content Library for InnerCycles
/// Back-Button-Free, Engagement-First Navigation System
/// Every page ends with 4 mandatory exploration sections
library;

import '../providers/app_providers.dart';
import '../services/l10n_service.dart';

// ============================================================
// NAVIGATION SECTION MODELS
// ============================================================

class NavigationCard {
  final String title;
  final String description;
  final String route;
  final String? emoji;
  final String? titleKey; // L10n key for title
  final String? descriptionKey; // L10n key for description

  const NavigationCard({
    required this.title,
    required this.description,
    required this.route,
    this.emoji,
    this.titleKey,
    this.descriptionKey,
  });

  /// Get localized title - uses l10n key if available, otherwise falls back to title
  String getLocalizedTitle(AppLanguage language) {
    if (titleKey != null) {
      final localized = L10nService.get(titleKey!, language);
      if (!localized.startsWith('[')) return localized;
    }
    return title;
  }

  /// Get localized description - uses l10n key if available, otherwise falls back to description
  String getLocalizedDescription(AppLanguage language) {
    if (descriptionKey != null) {
      final localized = L10nService.get(descriptionKey!, language);
      if (!localized.startsWith('[')) return localized;
    }
    return description;
  }
}

class PageNavigation {
  final String pageRoute;
  final String pageType;
  final List<NavigationCard> alsoViewed; // "Bunu Okuyanlar Şuna da Baktı"
  final List<NavigationCard> goDeeper; // "Bir Adım Daha Derinleş"
  final List<NavigationCard> keepExploring; // "Keşfetmeye Devam Et"
  final List<NavigationCard> continueWithoutBack; // "Geri Dönmeden Devam Et"

  const PageNavigation({
    required this.pageRoute,
    required this.pageType,
    required this.alsoViewed,
    required this.goDeeper,
    required this.keepExploring,
    required this.continueWithoutBack,
  });
}

// ============================================================
// PAGE 1: HOMEPAGE (/)
// ============================================================

class HomepageNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/',
    pageType: 'homepage',
    alsoViewed: [
      NavigationCard(
        title: 'Bugünün İç Enerjisi',
        description:
            'Bugün kendini nasıl hissediyorsun? Günlük yansımalarına göz at.',
        route: '/insight',
        emoji: '🌟',
        titleKey: 'navigation.cards.todays_inner_energy.title',
        descriptionKey: 'navigation.cards.todays_inner_energy.description',
      ),
      NavigationCard(
        title: 'Kişisel Profilim Ne Söylüyor?',
        description: 'Kendini daha yakından keşfet.',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.personal_profile_question.title',
        descriptionKey: 'navigation.cards.personal_profile_question.description',
      ),
      NavigationCard(
        title: 'İlişkilerimde Uyumlu muyuz?',
        description: 'İki kişinin dinamiklerini keşfet.',
        route: '/insight',
        emoji: '💑',
        titleKey: 'navigation.cards.partner_compatible.title',
        descriptionKey: 'navigation.cards.partner_compatible.description',
      ),
      NavigationCard(
        title: 'Şu Anki Döngüm',
        description: 'Hayatındaki değişimler seni nasıl etkiliyor?',
        route: '/insight',
        emoji: '🔄',
        titleKey: 'navigation.cards.current_cycle.title',
        descriptionKey: 'navigation.cards.current_cycle.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Rüyanı Anlat, Birlikte Keşfedelim',
        description: 'Bu gece ne gördün? Sembolik bir yolculuğa çıkalım.',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.dream_interpretation.title',
        descriptionKey: 'navigation.cards.dream_interpretation.description',
      ),
      NavigationCard(
        title: 'İçsel Rehberlik Al',
        description: 'İçindeki soruyu sor, cevaplar gelsin.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.inner_guidance.title',
        descriptionKey: 'navigation.cards.inner_guidance.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Bilinçaltının aynasına bak -- bugünkü içgörünü keşfet.',
        route: '/journal',
        emoji: '📝',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.daily_reflection_insight.description',
      ),
      NavigationCard(
        title: 'Sayılarının Sırrı',
        description: 'Doğum tarihin ve ismin ne anlatıyor?',
        route: '/insights-discovery',
        emoji: '🔢',
        titleKey: 'navigation.cards.number_secrets.title',
        descriptionKey: 'navigation.cards.number_secrets.description',
      ),
      NavigationCard(
        title: 'Enerji Alanın',
        description: 'Auranın renkleri ve chakra dengen.',
        route: '/insight',
        emoji: '🌈',
        titleKey: 'navigation.cards.energy_field.title',
        descriptionKey: 'navigation.cards.energy_field.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Keşif Merkezi',
        description: 'Tüm özellikler tek yerde',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.discovery_center.title',
        descriptionKey: 'navigation.cards.discovery_center.description',
      ),
      NavigationCard(
        title: 'Kavram Sözlüğü',
        description: 'Terimleri öğren',
        route: '/glossary',
        emoji: '📖',
        titleKey: 'navigation.cards.wellness_glossary.title',
        descriptionKey: 'navigation.cards.wellness_glossary.description',
      ),
      NavigationCard(
        title: 'Premium Özellikler',
        description: 'Gelişmiş kişisel gelişim araçları',
        route: '/premium',
        emoji: '👑',
        titleKey: 'navigation.cards.premium_features.title',
        descriptionKey: 'navigation.cards.premium_features.description',
      ),
    ],
  );
}

// ============================================================
// PAGE 2: DAILY INSIGHT HUB (/insight)
// ============================================================

class InsightHubNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/insight',
    pageType: 'hub',
    alsoViewed: [
      NavigationCard(
        title: 'En Çok Okunan Yansıma',
        description: 'Derinliklere dalmak için bir adım at.',
        route: '/insight',
        emoji: '🔍',
        titleKey: 'navigation.cards.most_read_reflection.title',
        descriptionKey: 'navigation.cards.most_read_reflection.description',
      ),
      NavigationCard(
        title: 'Trend: Değişim Dönemi',
        description: 'Değişimin rüzgarları esiyor.',
        route: '/insight',
        emoji: '🌊',
        titleKey: 'navigation.cards.trending_change_period.title',
        descriptionKey: 'navigation.cards.trending_change_period.description',
      ),
      NavigationCard(
        title: 'Haftalık Genel Bakış',
        description: 'Bu hafta seni neler bekliyor?',
        route: '/journal',
        emoji: '📅',
        titleKey: 'navigation.cards.weekly_overview.title',
        descriptionKey: 'navigation.cards.weekly_overview.description',
      ),
      NavigationCard(
        title: 'Aylık Derinlik',
        description: 'Ayın büyük teması ne?',
        route: '/journal',
        emoji: '🌕',
        titleKey: 'navigation.cards.monthly_depth.title',
        descriptionKey: 'navigation.cards.monthly_depth.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Bu Gece Rüyanda Ne Gördün?',
        description: 'İç enerjin rüyalarına nasıl yansıyor?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.dream_tonight.title',
        descriptionKey: 'navigation.cards.dream_tonight.description',
      ),
      NavigationCard(
        title: 'Günlük İçsel Mesajın',
        description: 'Bugün içindeki ses sana ne söylemek istiyor?',
        route: '/insight',
        emoji: '💫',
        titleKey: 'navigation.cards.daily_inner_message.title',
        descriptionKey: 'navigation.cards.daily_inner_message.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Kişisel Profilini Gör',
        description: 'Kendini daha derinlemesine tanı.',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.view_personal_profile.title',
        descriptionKey: 'navigation.cards.view_personal_profile.description',
      ),
      NavigationCard(
        title: 'İlişki Uyumu',
        description: 'Sen ve o — dinamikler nasıl?',
        route: '/insight',
        emoji: '💕',
        titleKey: 'navigation.cards.relationship_compatibility.title',
        descriptionKey:
            'navigation.cards.relationship_compatibility.description',
      ),
      NavigationCard(
        title: 'Günlük İçgörü',
        description: 'Bugün sana ne söylüyor?',
        route: '/journal',
        emoji: '📝',
        titleKey: 'navigation.cards.daily_insight.title',
        descriptionKey: 'navigation.cards.daily_insight.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Keşif Merkezi',
        description: 'Tüm özellikler',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.discovery_center.title',
        descriptionKey: 'navigation.cards.discovery_center.description',
      ),
      NavigationCard(
        title: 'Kavram Sözlüğü',
        description: 'Kavramları öğren',
        route: '/glossary',
        emoji: '📖',
        titleKey: 'navigation.cards.wellness_glossary.title',
        descriptionKey: 'navigation.cards.wellness_glossary.description',
      ),
    ],
  );
}

// ============================================================
// PAGES 3-14: ARCHETYPE PERSONALITY PAGES
// ============================================================

class ArchetypeNavigation {
  static PageNavigation getNavigationForArchetype(String archetype) {
    final archetypeData = _archetypeData[archetype];
    if (archetypeData == null) return _defaultArchetypeNavigation(archetype);

    return PageNavigation(
      pageRoute: '/insight/$archetype',
      pageType: 'archetype',
      alsoViewed: [
        NavigationCard(
          title: '${archetypeData['compatibleSign1']} ile Benzerliğin',
          description: 'Bu iki profil nasıl etkileşiyor?',
          route: '/insight',
          emoji: archetypeData['compatibleEmoji1'],
          titleKey: 'navigation.phrases.compatibility_with',
          descriptionKey: 'navigation.phrases.how_this_pair_dances',
        ),
        NavigationCard(
          title: '${archetypeData['elementBuddy1']} Arketipi',
          description: 'Aynı element, farklı enerji.',
          route: '/insight/${archetypeData['elementBuddyRoute1']}',
          emoji: archetypeData['elementBuddyEmoji1'],
          titleKey:
              'navigation.archetype.${archetypeData['elementBuddyRoute1']}.title',
          descriptionKey: 'navigation.phrases.same_element_different_energy',
        ),
        NavigationCard(
          title: '${archetypeData['elementBuddy2']} Arketipi',
          description: 'Kardeş element enerjisi.',
          route: '/insight/${archetypeData['elementBuddyRoute2']}',
          emoji: archetypeData['elementBuddyEmoji2'],
          titleKey:
              'navigation.archetype.${archetypeData['elementBuddyRoute2']}.title',
          descriptionKey: 'navigation.phrases.sibling_element_energy',
        ),
        NavigationCard(
          title: 'Haftalık ${archetypeData['name']} Yansıması',
          description: 'Bu haftanın yansıma temaları',
          route: '/journal',
          emoji: '📅',
          titleKey: 'navigation.cards.weekly_overview.title',
          descriptionKey: 'navigation.phrases.what_awaits_this_week',
        ),
      ],
      goDeeper: [
        NavigationCard(
          title: '${archetypeData['name']} Rüyaları',
          description: 'Bu kişilik tipindekiler en çok hangi rüyaları görür?',
          route: '/dream-interpretation',
          emoji: '🌙',
          titleKey: 'navigation.archetype.$archetype.dreams_title',
          descriptionKey: 'navigation.phrases.which_dreams_this_type_sees',
        ),
        NavigationCard(
          title: 'Bugün Sana Özel Mesaj',
          description: 'İçsel rehberlik al.',
          route: '/insight',
          emoji: '✨',
          titleKey: 'navigation.phrases.special_message_for_today',
          descriptionKey: 'navigation.phrases.inner_guidance',
        ),
      ],
      keepExploring: [
        NavigationCard(
          title: 'Kişisel Profilini Gör',
          description: '${archetypeData['name']} profilinin ötesinde ne var?',
          route: '/insight',
          emoji: '🗺️',
          titleKey: 'navigation.cards.view_personal_profile.title',
          descriptionKey: 'navigation.phrases.beyond_your_profile',
        ),
        NavigationCard(
          title: '${archetypeData['ruler']} Döngüsü',
          description: 'Yönetici enerjin şu an nerede?',
          route: '/insight',
          emoji: '🔄',
          titleKey: 'navigation.archetype.$archetype.ruler_cycle',
          descriptionKey: 'navigation.phrases.where_is_your_ruler',
        ),
        NavigationCard(
          title: 'Günlük Yansıma',
          description: '${archetypeData['name']} enerjisiyle uyumlu bir içgörü.',
          route: '/journal',
          emoji: '📝',
          titleKey: 'navigation.cards.daily_reflection.title',
          descriptionKey: 'navigation.phrases.reading_aligned_with_energy',
        ),
      ],
      continueWithoutBack: [
        NavigationCard(
          title: 'Tüm Kişilik Tipleri',
          description: '12 arketipi gez',
          route: '/insight',
          emoji: '🧭',
          titleKey: 'navigation.cards.all_archetypes.title',
          descriptionKey: 'navigation.cards.all_archetypes.description',
        ),
        NavigationCard(
          title: 'Ana Sayfa',
          description: 'Başa dön',
          route: '/',
          emoji: '🏠',
          titleKey: 'navigation.cards.home.title',
          descriptionKey: 'navigation.cards.home.description',
        ),
        NavigationCard(
          title: 'Kişilik Uyumu',
          description: 'İkili analiz',
          route: '/insight',
          emoji: '💕',
          titleKey: 'navigation.cards.personality_compatibility.title',
          descriptionKey: 'navigation.cards.personality_compatibility.description',
        ),
      ],
    );
  }

  static const Map<String, Map<String, dynamic>> _archetypeData = {
    'aries': {
      'name': 'Öncü',
      'compatibleSign1': 'Sahne Yıldızı',
      'compatibleRoute1': 'leo',
      'compatibleEmoji1': '🌟',
      'elementBuddy1': 'Sahne Yıldızı',
      'elementBuddyRoute1': 'leo',
      'elementBuddyEmoji1': '🌟',
      'elementBuddy2': 'Kaşif',
      'elementBuddyRoute2': 'sagittarius',
      'elementBuddyEmoji2': '🧭',
    },
    'taurus': {
      'name': 'Kurucu',
      'compatibleSign1': 'Analist',
      'compatibleRoute1': 'virgo',
      'compatibleEmoji1': '🔍',
      'elementBuddy1': 'Analist',
      'elementBuddyRoute1': 'virgo',
      'elementBuddyEmoji1': '🔍',
      'elementBuddy2': 'Başarıcı',
      'elementBuddyRoute2': 'capricorn',
      'elementBuddyEmoji2': '🏔',
    },
    'gemini': {
      'name': 'İletişimci',
      'compatibleSign1': 'Dengeleyici',
      'compatibleRoute1': 'libra',
      'compatibleEmoji1': '⚖️',
      'elementBuddy1': 'Dengeleyici',
      'elementBuddyRoute1': 'libra',
      'elementBuddyEmoji1': '⚖️',
      'elementBuddy2': 'Vizyoner',
      'elementBuddyRoute2': 'aquarius',
      'elementBuddyEmoji2': '💡',
    },
    'cancer': {
      'name': 'Koruyucu',
      'compatibleSign1': 'Dönüştürücü',
      'compatibleRoute1': 'scorpio',
      'compatibleEmoji1': '🦋',
      'elementBuddy1': 'Dönüştürücü',
      'elementBuddyRoute1': 'scorpio',
      'elementBuddyEmoji1': '🦋',
      'elementBuddy2': 'Hayalci',
      'elementBuddyRoute2': 'pisces',
      'elementBuddyEmoji2': '🌙',
    },
    'leo': {
      'name': 'Sahne Yıldızı',
      'compatibleSign1': 'Öncü',
      'compatibleRoute1': 'aries',
      'compatibleEmoji1': '🚀',
      'elementBuddy1': 'Öncü',
      'elementBuddyRoute1': 'aries',
      'elementBuddyEmoji1': '🚀',
      'elementBuddy2': 'Kaşif',
      'elementBuddyRoute2': 'sagittarius',
      'elementBuddyEmoji2': '🧭',
    },
    'virgo': {
      'name': 'Analist',
      'compatibleSign1': 'Kurucu',
      'compatibleRoute1': 'taurus',
      'compatibleEmoji1': '🏗',
      'elementBuddy1': 'Kurucu',
      'elementBuddyRoute1': 'taurus',
      'elementBuddyEmoji1': '🏗',
      'elementBuddy2': 'Başarıcı',
      'elementBuddyRoute2': 'capricorn',
      'elementBuddyEmoji2': '🏔',
    },
    'libra': {
      'name': 'Dengeleyici',
      'compatibleSign1': 'İletişimci',
      'compatibleRoute1': 'gemini',
      'compatibleEmoji1': '💬',
      'elementBuddy1': 'İletişimci',
      'elementBuddyRoute1': 'gemini',
      'elementBuddyEmoji1': '💬',
      'elementBuddy2': 'Vizyoner',
      'elementBuddyRoute2': 'aquarius',
      'elementBuddyEmoji2': '💡',
    },
    'scorpio': {
      'name': 'Dönüştürücü',
      'compatibleSign1': 'Koruyucu',
      'compatibleRoute1': 'cancer',
      'compatibleEmoji1': '🛡',
      'elementBuddy1': 'Koruyucu',
      'elementBuddyRoute1': 'cancer',
      'elementBuddyEmoji1': '🛡',
      'elementBuddy2': 'Hayalci',
      'elementBuddyRoute2': 'pisces',
      'elementBuddyEmoji2': '🌙',
    },
    'sagittarius': {
      'name': 'Kaşif',
      'compatibleSign1': 'Öncü',
      'compatibleRoute1': 'aries',
      'compatibleEmoji1': '🚀',
      'elementBuddy1': 'Öncü',
      'elementBuddyRoute1': 'aries',
      'elementBuddyEmoji1': '🚀',
      'elementBuddy2': 'Sahne Yıldızı',
      'elementBuddyRoute2': 'leo',
      'elementBuddyEmoji2': '🌟',
    },
    'capricorn': {
      'name': 'Başarıcı',
      'compatibleSign1': 'Kurucu',
      'compatibleRoute1': 'taurus',
      'compatibleEmoji1': '🏗',
      'elementBuddy1': 'Kurucu',
      'elementBuddyRoute1': 'taurus',
      'elementBuddyEmoji1': '🏗',
      'elementBuddy2': 'Analist',
      'elementBuddyRoute2': 'virgo',
      'elementBuddyEmoji2': '🔍',
    },
    'aquarius': {
      'name': 'Vizyoner',
      'compatibleSign1': 'İletişimci',
      'compatibleRoute1': 'gemini',
      'compatibleEmoji1': '💬',
      'elementBuddy1': 'İletişimci',
      'elementBuddyRoute1': 'gemini',
      'elementBuddyEmoji1': '💬',
      'elementBuddy2': 'Dengeleyici',
      'elementBuddyRoute2': 'libra',
      'elementBuddyEmoji2': '⚖️',
    },
    'pisces': {
      'name': 'Hayalci',
      'compatibleSign1': 'Koruyucu',
      'compatibleRoute1': 'cancer',
      'compatibleEmoji1': '🛡',
      'elementBuddy1': 'Koruyucu',
      'elementBuddyRoute1': 'cancer',
      'elementBuddyEmoji1': '🛡',
      'elementBuddy2': 'Dönüştürücü',
      'elementBuddyRoute2': 'scorpio',
      'elementBuddyEmoji2': '🦋',
    },
  };

  static PageNavigation _defaultArchetypeNavigation(String archetype) {
    return PageNavigation(
      pageRoute: '/insight/$archetype',
      pageType: 'archetype',
      alsoViewed: const [],
      goDeeper: const [],
      keepExploring: const [],
      continueWithoutBack: const [],
    );
  }
}

// ============================================================
// PAGE 15: PERSONAL PROFILE (/insight)
// ============================================================

class PersonalProfileNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/insight',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Şu Anki Döngüler',
        description: 'Profilini bugünün enerjisiyle karşılaştır.',
        route: '/insight',
        emoji: '🔄',
        titleKey: 'navigation.cards.current_cycles.title',
        descriptionKey: 'navigation.cards.compare_profile_today.description',
      ),
      NavigationCard(
        title: 'İlişki Analizi',
        description: 'Profilini bir başkasıyla birleştir.',
        route: '/insight',
        emoji: '💑',
        titleKey: 'navigation.cards.relationship_analysis.title',
        descriptionKey: 'navigation.cards.relationship_analysis.description',
      ),
      NavigationCard(
        title: 'Yıllık Yansıma',
        description: 'Bu yılın teması nasıl?',
        route: '/insight',
        emoji: '🎂',
        titleKey: 'navigation.cards.yearly_reflection.title',
        descriptionKey: 'navigation.cards.yearly_reflection.description',
      ),
      NavigationCard(
        title: 'Kişisel Gelişim',
        description: 'İçsel evrimini takip et.',
        route: '/journal',
        emoji: '📈',
        titleKey: 'navigation.cards.personal_growth.title',
        descriptionKey: 'navigation.cards.personal_growth.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Profilinle Bağlantılı Rüyalar',
        description: 'İç dünyan rüyalarına nasıl yansıyor?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.profile_connected_dreams.title',
        descriptionKey: 'navigation.cards.profile_connected_dreams.description',
      ),
      NavigationCard(
        title: 'Kişisel İçsel Mesaj',
        description: 'Profiline özel rehberlik.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.personal_inner_message.title',
        descriptionKey: 'navigation.cards.personal_inner_message.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Farklı Bakış Açısı',
        description: 'Doğu felsefesi perspektifi.',
        route: '/insight',
        emoji: '🕉️',
        titleKey: 'navigation.cards.different_perspective.title',
        descriptionKey: 'navigation.cards.different_perspective.description',
      ),
      NavigationCard(
        title: 'Derin Profil',
        description: 'Ruhsal kökenin.',
        route: '/insight',
        emoji: '🐉',
        titleKey: 'navigation.cards.deep_profile.title',
        descriptionKey: 'navigation.cards.deep_profile.description',
      ),
      NavigationCard(
        title: 'Detaylı Analiz',
        description: 'Chiron, Lilith ve diğerleri.',
        route: '/insight',
        emoji: '☄️',
        titleKey: 'navigation.cards.detailed_analysis.title',
        descriptionKey: 'navigation.cards.detailed_analysis.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Tüm Kişilik Tipleri',
        description: 'Arketip sayfaları',
        route: '/insight',
        emoji: '🧭',
        titleKey: 'navigation.cards.all_archetypes.title',
        descriptionKey: 'navigation.cards.all_archetypes.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Kavram Sözlüğü',
        description: 'Terimleri öğren',
        route: '/glossary',
        emoji: '📖',
        titleKey: 'navigation.cards.wellness_glossary.title',
        descriptionKey: 'navigation.cards.wellness_glossary.description',
      ),
    ],
  );
}

// ============================================================
// PAGE 16: JOURNAL (/journal)
// ============================================================

class JournalNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/journal',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Bugünün iç enerjisi.',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.todays_inner_energy.description',
      ),
      NavigationCard(
        title: 'Rüya Yorumu',
        description: 'Bu gece ne gördün?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.dream_interpretation.title',
        descriptionKey: 'navigation.cards.dream_tonight.description',
      ),
      NavigationCard(
        title: 'Kişisel Profil',
        description: 'İçsel kimliğin.',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.personal_profile.title',
        descriptionKey: 'navigation.cards.inner_identity.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Rüyandaki Sembolleri Çöz',
        description: 'Rüyalar ve günlük yazılar benzer bir dil konuşur.',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.decode_dream_symbols.title',
        descriptionKey: 'navigation.cards.decode_dream_symbols.description',
      ),
      NavigationCard(
        title: 'İçsel Rehberlik',
        description: 'Günlüğünün ötesinde bir mesaj.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.inner_guidance_beyond.title',
        descriptionKey: 'navigation.cards.inner_guidance_beyond.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Keşif Merkezi',
        description: 'Tüm özellikler.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.discovery_center.title',
        descriptionKey: 'navigation.cards.discovery_center.description',
      ),
      NavigationCard(
        title: 'Kavram Sözlüğü',
        description: 'Terimleri öğren.',
        route: '/glossary',
        emoji: '📖',
        titleKey: 'navigation.cards.wellness_glossary.title',
        descriptionKey: 'navigation.cards.wellness_glossary.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Kavram Sözlüğü',
        description: 'Günlük terimleri',
        route: '/glossary',
        emoji: '📖',
        titleKey: 'navigation.cards.wellness_glossary.title',
        descriptionKey: 'navigation.cards.wellness_glossary.description',
      ),
    ],
  );
}

// ============================================================
// PAGE 17: NUMEROLOGY (/numerology)
// ============================================================

class DiscoveryNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/numerology',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Kabala Sayıları',
        description: 'Sayıların mistik kökeni.',
        route: '/insight',
        emoji: '🌳',
        titleKey: 'navigation.cards.kabbalah_numbers.title',
        descriptionKey: 'navigation.cards.kabbalah_numbers.description',
      ),
      NavigationCard(
        title: 'Kişisel Profil',
        description: 'Kişisel gelişim perspektifi.',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.personal_profile.title',
        descriptionKey: 'navigation.cards.personal_growth_perspective.description',
      ),
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Sayılarla birlikte keşfet.',
        route: '/journal',
        emoji: '📝',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.explore_with_numbers.description',
      ),
      NavigationCard(
        title: 'İlişki Uyumu',
        description: 'Sayısal uyum analizi.',
        route: '/insight',
        emoji: '💑',
        titleKey: 'navigation.cards.relationship_compatibility.title',
        descriptionKey: 'navigation.cards.numerical_compatibility.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Sayılarla Rüya Yorumu',
        description: 'Rüyandaki sayılar ne anlatıyor?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.dream_with_numbers.title',
        descriptionKey: 'navigation.cards.dream_with_numbers.description',
      ),
      NavigationCard(
        title: 'Kişisel Yıl Mesajı',
        description: 'Bu yılın sayısal enerjisi.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.personal_year_message.title',
        descriptionKey: 'navigation.cards.personal_year_message.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Sayılarla birlikte oku.',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.read_with_numbers.description',
      ),
      NavigationCard(
        title: 'Aura Renkleri',
        description: 'Enerji alanın.',
        route: '/insight',
        emoji: '🌈',
        titleKey: 'navigation.cards.aura_colors.title',
        descriptionKey: 'navigation.cards.energy_field.description',
      ),
      NavigationCard(
        title: 'Chakra Dengesi',
        description: 'Sayılar ve chakralar.',
        route: '/insight',
        emoji: '🧘',
        titleKey: 'navigation.cards.chakra_balance.title',
        descriptionKey: 'navigation.cards.numbers_and_chakras.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Tüm Çözümlemeler',
        description: 'Diğer sistemler',
        route: '/insight',
        emoji: '🧰',
        titleKey: 'navigation.cards.all_analyses.title',
        descriptionKey: 'navigation.cards.other_systems.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Sayı Anlamları',
        description: '1-9 ve master sayılar',
        route: '/glossary',
        emoji: '🔢',
        titleKey: 'navigation.cards.number_meanings.title',
        descriptionKey: 'navigation.cards.number_meanings.description',
      ),
    ],
  );
}

// ============================================================
// PAGE 18: COMPATIBILITY (/insight - relationship section)
// ============================================================

class CompatibilityNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/insight',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'İlişki Derinliği',
        description: 'Profilleri detaylı karşılaştır.',
        route: '/insight',
        emoji: '🔍',
        titleKey: 'navigation.cards.relationship_depth.title',
        descriptionKey: 'navigation.cards.relationship_depth.description',
      ),
      NavigationCard(
        title: 'Birlikte Profil',
        description: 'İlişkinin kendi profili.',
        route: '/insight',
        emoji: '💞',
        titleKey: 'navigation.cards.combined_profile.title',
        descriptionKey: 'navigation.cards.combined_profile.description',
      ),
      NavigationCard(
        title: 'Aşk Yansıması',
        description: 'Haftalık aşk enerjisi',
        route: '/insight',
        emoji: '💕',
        titleKey: 'navigation.cards.love_reflection.title',
        descriptionKey: 'navigation.cards.love_reflection.description',
      ),
      NavigationCard(
        title: 'Venüs ve Mars',
        description: 'Aşk enerjilerini incele.',
        route: '/insight',
        emoji: '🪐',
        titleKey: 'navigation.cards.venus_and_mars.title',
        descriptionKey: 'navigation.cards.venus_and_mars.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'İlişki Rüyaları',
        description: 'Partnerinle ilgili rüyalar ne anlatıyor?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.relationship_dreams.title',
        descriptionKey: 'navigation.cards.relationship_dreams.description',
      ),
      NavigationCard(
        title: 'İlişki Rehberliği',
        description: 'İçsel perspektif.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.relationship_guidance.title',
        descriptionKey: 'navigation.cards.inner_perspective.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'İlişki Günlüğü',
        description: 'İlişki yansımalarını keşfet.',
        route: '/journal',
        emoji: '💕',
        titleKey: 'navigation.cards.relationship_journal.title',
        descriptionKey: 'navigation.cards.relationship_journal.description',
      ),
      NavigationCard(
        title: 'Sayısal Uyum',
        description: 'İsimlerle numeroloji.',
        route: '/insights-discovery',
        emoji: '🔢',
        titleKey: 'navigation.cards.numerical_harmony.title',
        descriptionKey: 'navigation.cards.numerical_harmony.description',
      ),
      NavigationCard(
        title: 'Venüs Döngüsü',
        description: 'Aşk enerjisi nerede?',
        route: '/insight',
        emoji: '💖',
        titleKey: 'navigation.cards.venus_cycle.title',
        descriptionKey: 'navigation.cards.venus_cycle.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Tüm Kişilik Tipleri',
        description: 'Arketip sayfaları',
        route: '/insight',
        emoji: '🧭',
        titleKey: 'navigation.cards.all_archetypes.title',
        descriptionKey: 'navigation.cards.archetype_pages.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Ünlü Çiftler',
        description: 'Ünlülerin uyumu',
        route: '/insight',
        emoji: '🌟',
        titleKey: 'navigation.cards.celebrity_couples.title',
        descriptionKey: 'navigation.cards.celebrity_couples.description',
      ),
    ],
  );
}

// ============================================================
// PAGE 19: AURA (/aura)
// ============================================================

class WellnessNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/aura',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Chakra Analizi',
        description: 'Enerji merkezlerini keşfet.',
        route: '/insight',
        emoji: '🧘',
        titleKey: 'navigation.cards.chakra_analysis.title',
        descriptionKey: 'navigation.cards.discover_energy_centers.description',
      ),
      NavigationCard(
        title: 'Ay Ritüelleri',
        description: 'Enerji temizliği pratikleri.',
        route: '/rituals',
        emoji: '🌕',
        titleKey: 'navigation.cards.moon_rituals.title',
        descriptionKey: 'navigation.cards.moon_rituals.description',
      ),
      NavigationCard(
        title: 'Kişisel Profil',
        description: 'İç enerji haritası.',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.personal_profile.title',
        descriptionKey: 'navigation.cards.inner_energy_map.description',
      ),
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Enerji farkındalığı yolu.',
        route: '/journal',
        emoji: '📝',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.energy_awareness_path.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Enerji Rüyaları',
        description: 'Renkler ve ışık rüyalarının anlamı.',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.energy_dreams.title',
        descriptionKey: 'navigation.cards.energy_dreams.description',
      ),
      NavigationCard(
        title: 'Günlük Enerji Mesajı',
        description: 'Bugünün enerji akışı.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.daily_energy_message.title',
        descriptionKey: 'navigation.cards.daily_energy_message.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Numeroloji',
        description: 'Sayısal titreşimler.',
        route: '/insights-discovery',
        emoji: '🔢',
        titleKey: 'navigation.cards.numerology.title',
        descriptionKey: 'navigation.cards.numerical_vibrations.description',
      ),
      NavigationCard(
        title: 'Kabala',
        description: 'Sefirot enerjileri.',
        route: '/insight',
        emoji: '🌳',
        titleKey: 'navigation.cards.kabbalah.title',
        descriptionKey: 'navigation.cards.sefirot_energies.description',
      ),
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'İç enerji.',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.inner_energy.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Tüm Çözümlemeler',
        description: 'Diğer keşif yolları',
        route: '/insight',
        emoji: '🧰',
        titleKey: 'navigation.cards.all_analyses.title',
        descriptionKey: 'navigation.cards.other_exploration_paths.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Renk Anlamları',
        description: 'Aura renkleri sözlüğü',
        route: '/glossary',
        emoji: '🌈',
        titleKey: 'navigation.cards.color_meanings.title',
        descriptionKey: 'navigation.cards.color_meanings.description',
      ),
    ],
  );
}

// ============================================================
// PAGE 20: KABBALAH (/kabbalah)
// ============================================================

class WisdomNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/kabbalah',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'İçsel Yolculuk',
        description: 'Derinlemesine keşif patikası.',
        route: '/journal',
        emoji: '🧭',
        titleKey: 'navigation.cards.inner_journey.title',
        descriptionKey: 'navigation.cards.inner_journey.description',
      ),
      NavigationCard(
        title: 'Numeroloji',
        description: 'Gematria ve sayılar.',
        route: '/insights-discovery',
        emoji: '🔢',
        titleKey: 'navigation.cards.numerology.title',
        descriptionKey: 'navigation.cards.gematria_and_numbers.description',
      ),
      NavigationCard(
        title: 'Kişisel Gelişim Bağlantısı',
        description: 'Sefirot ve kişisel gelişim.',
        route: '/insight',
        emoji: '🪐',
        titleKey: 'navigation.cards.personal_growth_connection.title',
        descriptionKey: 'navigation.cards.personal_growth_connection.description',
      ),
      NavigationCard(
        title: 'Chakra Sistemi',
        description: 'Doğu ve Batı enerji haritaları.',
        route: '/insight',
        emoji: '🧘',
        titleKey: 'navigation.cards.chakra_system.title',
        descriptionKey: 'navigation.cards.chakra_system.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Mistik Rüyalar',
        description: 'Ruhani semboller ve rüyalar.',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.mystic_dreams.title',
        descriptionKey: 'navigation.cards.mystic_dreams.description',
      ),
      NavigationCard(
        title: 'Sefirot Meditasyonu',
        description: 'Hayat Ağacında yolculuk.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.sefirot_meditation.title',
        descriptionKey: 'navigation.cards.sefirot_meditation.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Aura Okuma',
        description: 'Enerji alanı.',
        route: '/insight',
        emoji: '🌈',
        titleKey: 'navigation.cards.aura_reading.title',
        descriptionKey: 'navigation.cards.energy_field.description',
      ),
      NavigationCard(
        title: 'Ay Ritüelleri',
        description: 'Spiritüel pratikler.',
        route: '/rituals',
        emoji: '🌕',
        titleKey: 'navigation.cards.moon_rituals.title',
        descriptionKey: 'navigation.cards.spiritual_practices.description',
      ),
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'İçsel perspektif.',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.inner_perspective.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Tüm Çözümlemeler',
        description: 'Diğer sistemler',
        route: '/insight',
        emoji: '🧰',
        titleKey: 'navigation.cards.all_analyses.title',
        descriptionKey: 'navigation.cards.other_systems.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Sefirot Sözlüğü',
        description: '10 sefirah anlamları',
        route: '/glossary',
        emoji: '🌳',
        titleKey: 'navigation.cards.sefirot_glossary.title',
        descriptionKey: 'navigation.cards.sefirot_glossary.description',
      ),
    ],
  );
}

// ============================================================
// PAGE 21: LIFE CYCLES (/insight - cycles section)
// ============================================================

class LifeCyclesNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/insight',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Kişisel Profilim',
        description: 'Döngüler profilime nasıl etkiliyor?',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.my_personal_profile.title',
        descriptionKey: 'navigation.cards.cycles_affecting_profile.description',
      ),
      NavigationCard(
        title: 'Yıllık Yansıma',
        description: 'Bu yılın teması.',
        route: '/insight',
        emoji: '🎂',
        titleKey: 'navigation.cards.yearly_reflection.title',
        descriptionKey: 'navigation.cards.this_years_theme.description',
      ),
      NavigationCard(
        title: 'Kişisel Gelişim',
        description: 'İçsel evrim takibi.',
        route: '/journal',
        emoji: '📈',
        titleKey: 'navigation.cards.personal_growth.title',
        descriptionKey: 'navigation.cards.inner_evolution_tracking.description',
      ),
      NavigationCard(
        title: 'Hayat Dönüm Noktası',
        description: '29 yaş dönüm noktası.',
        route: '/insight',
        emoji: '🔄',
        titleKey: 'navigation.cards.life_milestone.title',
        descriptionKey: 'navigation.cards.life_milestone.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Değişim Döneminde Rüyalar',
        description: 'Yoğun dönemlerde rüyalar ne anlatır?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.transition_dreams.title',
        descriptionKey: 'navigation.cards.transition_dreams.description',
      ),
      NavigationCard(
        title: 'Kişisel Dönem Rehberliği',
        description: 'Bu dönem için özel mesaj.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.personal_cycle_guidance.title',
        descriptionKey:
            'navigation.cards.personal_cycle_guidance.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Bugünün enerjisi.',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.todays_energy.description',
      ),
      NavigationCard(
        title: 'Zamanlama Rehberi',
        description: 'Uygun zamanları seç.',
        route: '/journal/patterns',
        emoji: '📅',
        titleKey: 'navigation.cards.timing_guide.title',
        descriptionKey: 'navigation.cards.timing_guide.description',
      ),
      NavigationCard(
        title: 'Gözden Geçirme Takvimi',
        description: 'Merkür gözden geçirme dönemi ne zaman?',
        route: '/insight',
        emoji: '↩️',
        titleKey: 'navigation.cards.review_calendar.title',
        descriptionKey: 'navigation.cards.review_calendar.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Kişisel Profilim',
        description: 'İçsel kimliğin',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.my_personal_profile.title',
        descriptionKey: 'navigation.cards.inner_identity.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Kavram Sözlüğü',
        description: 'Döngü anlamları',
        route: '/glossary',
        emoji: '📖',
        titleKey: 'navigation.cards.concept_glossary.title',
        descriptionKey: 'navigation.cards.concept_glossary.description',
      ),
    ],
  );
}

// ============================================================
// ADDITIONAL PAGES NAVIGATION
// ============================================================

class DreamInterpretationNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/dream-interpretation',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Ay Fazları ve Rüyalar',
        description: 'Ayın döngüsü rüyaları nasıl etkiler?',
        route: '/rituals',
        emoji: '🌙',
        titleKey: 'navigation.cards.moon_phases_dreams.title',
        descriptionKey: 'navigation.cards.moon_phases_dreams.description',
      ),
      NavigationCard(
        title: 'Kişilik ve Rüya Kalıpları',
        description: 'Kişiliğin rüyalarına nasıl yansıyor?',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.personality_dream_patterns.title',
        descriptionKey: 'navigation.cards.personality_dream_patterns.description',
      ),
      NavigationCard(
        title: 'Bilinçaltı Keşfi',
        description: 'Rüyalar ve günlükler benzer dil konuşur.',
        route: '/journal',
        emoji: '📝',
        titleKey: 'navigation.cards.subconscious_exploration.title',
        descriptionKey: 'navigation.cards.subconscious_exploration.description',
      ),
      NavigationCard(
        title: 'İçsel Keşif ve Rüyalar',
        description: 'Kişisel profilinde rüya kalıpların.',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.inner_discovery_dreams.title',
        descriptionKey: 'navigation.cards.inner_discovery_dreams.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'İçsel Mesajın',
        description: 'Rüyanın ötesinde rehberlik.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.your_inner_message.title',
        descriptionKey: 'navigation.cards.guidance_beyond_dream.description',
      ),
      NavigationCard(
        title: 'Başka Bir Rüya Anlat',
        description: 'Yeni bir yolculuğa başla.',
        route: '/dream-interpretation',
        emoji: '🔮',
        titleKey: 'navigation.cards.tell_another_dream.title',
        descriptionKey: 'navigation.cards.tell_another_dream.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Chakra ve Rüyalar',
        description: 'Enerji merkezleri ve bilinçaltı.',
        route: '/insight',
        emoji: '🧘',
        titleKey: 'navigation.cards.chakra_and_dreams.title',
        descriptionKey: 'navigation.cards.chakra_and_dreams.description',
      ),
      NavigationCard(
        title: 'Aura Okuma',
        description: 'Enerji alanın.',
        route: '/insight',
        emoji: '🌈',
        titleKey: 'navigation.cards.aura_reading.title',
        descriptionKey: 'navigation.cards.energy_field.description',
      ),
      NavigationCard(
        title: 'Neptün Döngüsü',
        description: 'Rüya enerjisi nerede?',
        route: '/insight',
        emoji: '🪐',
        titleKey: 'navigation.cards.neptune_cycle.title',
        descriptionKey: 'navigation.cards.neptune_cycle.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Tüm Çözümlemeler',
        description: 'Diğer keşif yolları',
        route: '/insight',
        emoji: '🧰',
        titleKey: 'navigation.cards.all_analyses.title',
        descriptionKey: 'navigation.cards.other_exploration_paths.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Sembol Sözlüğü',
        description: 'Rüya sembolleri',
        route: '/glossary',
        emoji: '📖',
        titleKey: 'navigation.cards.symbol_glossary.title',
        descriptionKey: 'navigation.cards.symbol_glossary.description',
      ),
    ],
  );
}

class ReflectionNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/kozmoz',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Bugünün iç enerjisi.',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.daily_reflection_reading.title',
        descriptionKey: 'navigation.cards.todays_inner_energy.description',
      ),
      NavigationCard(
        title: 'Günlük Günlük',
        description: 'Bugünkü yansıman.',
        route: '/journal',
        emoji: '📝',
        titleKey: 'navigation.cards.daily_journal.title',
        descriptionKey: 'navigation.cards.todays_reflection.description',
      ),
      NavigationCard(
        title: 'Ay Fazı',
        description: 'Ayın bugünkü etkisi.',
        route: '/rituals',
        emoji: '🌙',
        titleKey: 'navigation.cards.moon_phase.title',
        descriptionKey: 'navigation.cards.moon_phase.description',
      ),
      NavigationCard(
        title: 'Döngüler',
        description: 'Hayatındaki döngüler bugün.',
        route: '/insight',
        emoji: '🔄',
        titleKey: 'navigation.cards.cycles.title',
        descriptionKey: 'navigation.cards.life_cycles_today.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Rüyanı Anlat',
        description: 'İçsel mesajın rüyalara nasıl yansıyor?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.tell_your_dream.title',
        descriptionKey: 'navigation.cards.inner_message_dreams.description',
      ),
      NavigationCard(
        title: 'İçsel Keşif',
        description: 'Daha fazla içgörü al.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.inner_discovery.title',
        descriptionKey: 'navigation.cards.get_more_insight.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Kişisel Profilim',
        description: 'İçsel kimliğim.',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.my_personal_profile.title',
        descriptionKey: 'navigation.cards.my_inner_identity.description',
      ),
      NavigationCard(
        title: 'Numeroloji',
        description: 'Sayıların bilgeliği.',
        route: '/insights-discovery',
        emoji: '🔢',
        titleKey: 'navigation.cards.numerology.title',
        descriptionKey: 'navigation.cards.numerology.description',
      ),
      NavigationCard(
        title: 'Chakra Dengesi',
        description: 'Enerji merkezlerim.',
        route: '/insight',
        emoji: '🧘',
        titleKey: 'navigation.cards.chakra_balance.title',
        descriptionKey: 'navigation.cards.my_energy_centers.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Premium Özellikler',
        description: 'Gelişmiş kişisel gelişim',
        route: '/premium',
        emoji: '👑',
        titleKey: 'navigation.cards.premium_features.title',
        descriptionKey: 'navigation.cards.advanced_personal_growth.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Kavram Sözlüğü',
        description: 'Kavramları öğren',
        route: '/glossary',
        emoji: '📖',
        titleKey: 'navigation.cards.wellness_glossary.title',
        descriptionKey: 'navigation.cards.learn_concepts.description',
      ),
    ],
  );
}

class EnergyNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/chakra-analysis',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Aura Renkleri',
        description: 'Enerji alanın ve chakralar.',
        route: '/insight',
        emoji: '🌈',
        titleKey: 'navigation.cards.aura_colors.title',
        descriptionKey: 'navigation.cards.energy_field_chakras.description',
      ),
      NavigationCard(
        title: 'Ay Ritüelleri',
        description: 'Chakra dengeleme pratikleri.',
        route: '/rituals',
        emoji: '🌕',
        titleKey: 'navigation.cards.moon_rituals.title',
        descriptionKey:
            'navigation.cards.chakra_balancing_practices.description',
      ),
      NavigationCard(
        title: 'Kabala Sefirotları',
        description: 'Doğu-Batı enerji haritaları.',
        route: '/insight',
        emoji: '🌳',
        titleKey: 'navigation.cards.kabbalah_sefirot.title',
        descriptionKey: 'navigation.cards.east_west_energy_maps.description',
      ),
      NavigationCard(
        title: 'Kişisel Profil',
        description: 'Enerji profili ve chakralar.',
        route: '/insight',
        emoji: '🗺️',
        titleKey: 'navigation.cards.personal_profile.title',
        descriptionKey: 'navigation.cards.energy_profile_chakras.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Chakra ve Rüyalar',
        description: 'Enerji blokajları rüyalara nasıl yansır?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.chakra_and_dreams.title',
        descriptionKey: 'navigation.cards.energy_blockages_dreams.description',
      ),
      NavigationCard(
        title: 'Enerji Rehberliği',
        description: 'Chakralarına özel mesaj.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.energy_guidance.title',
        descriptionKey: 'navigation.cards.chakra_special_message.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Enerji farkındalığı.',
        route: '/journal',
        emoji: '📝',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.energy_awareness.description',
      ),
      NavigationCard(
        title: 'Numeroloji',
        description: 'Sayısal titreşimler.',
        route: '/insights-discovery',
        emoji: '🔢',
        titleKey: 'navigation.cards.numerology.title',
        descriptionKey: 'navigation.cards.numerical_vibrations.description',
      ),
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'İç enerji.',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.inner_energy.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Tüm Çözümlemeler',
        description: 'Diğer sistemler',
        route: '/insight',
        emoji: '🧰',
        titleKey: 'navigation.cards.all_analyses.title',
        descriptionKey: 'navigation.cards.other_systems.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: '7 Chakra Rehberi',
        description: 'Detaylı açıklamalar',
        route: '/glossary',
        emoji: '🧘',
        titleKey: 'navigation.cards.seven_chakra_guide.title',
        descriptionKey: 'navigation.cards.seven_chakra_guide.description',
      ),
    ],
  );
}

class RitualNavigation {
  static const navigation = PageNavigation(
    pageRoute: '/moon-rituals',
    pageType: 'tool',
    alsoViewed: [
      NavigationCard(
        title: 'Ay Takvimi',
        description: 'Yeniay ve dolunay tarihleri.',
        route: '/journal/patterns',
        emoji: '📅',
        titleKey: 'navigation.cards.moon_calendar.title',
        descriptionKey: 'navigation.cards.moon_calendar.description',
      ),
      NavigationCard(
        title: 'Chakra Dengeleme',
        description: 'Ritüellerle enerji çalışması.',
        route: '/insight',
        emoji: '🧘',
        titleKey: 'navigation.cards.chakra_balancing.title',
        descriptionKey: 'navigation.cards.energy_work_rituals.description',
      ),
      NavigationCard(
        title: 'Aura Temizliği',
        description: 'Enerji alanını arındır.',
        route: '/insight',
        emoji: '🌈',
        titleKey: 'navigation.cards.aura_cleansing.title',
        descriptionKey: 'navigation.cards.aura_cleansing.description',
      ),
      NavigationCard(
        title: 'Günlük Meditasyon',
        description: 'İçsel farkındalık meditasyonu.',
        route: '/journal',
        emoji: '🧘',
        titleKey: 'navigation.cards.daily_meditation.title',
        descriptionKey: 'navigation.cards.daily_meditation.description',
      ),
    ],
    goDeeper: [
      NavigationCard(
        title: 'Ritüel Sonrası Rüyalar',
        description: 'Ritüeller rüyaları nasıl etkiler?',
        route: '/dream-interpretation',
        emoji: '🌙',
        titleKey: 'navigation.cards.post_ritual_dreams.title',
        descriptionKey: 'navigation.cards.post_ritual_dreams.description',
      ),
      NavigationCard(
        title: 'Niyet Rehberliği',
        description: 'Bu ay için içsel mesaj.',
        route: '/insight',
        emoji: '✨',
        titleKey: 'navigation.cards.intention_guidance.title',
        descriptionKey: 'navigation.cards.intention_guidance.description',
      ),
    ],
    keepExploring: [
      NavigationCard(
        title: 'Günlük Yansıma',
        description: 'Bugünün enerjisi.',
        route: '/insight',
        emoji: '⭐',
        titleKey: 'navigation.cards.daily_reflection.title',
        descriptionKey: 'navigation.cards.todays_energy.description',
      ),
      NavigationCard(
        title: 'Döngüler',
        description: 'Ay ve yaşam döngüleri.',
        route: '/insight',
        emoji: '🔄',
        titleKey: 'navigation.cards.cycles.title',
        descriptionKey: 'navigation.cards.moon_life_cycles.description',
      ),
      NavigationCard(
        title: 'Kabala Meditasyonu',
        description: 'Sefirot yolculuğu.',
        route: '/insight',
        emoji: '🌳',
        titleKey: 'navigation.cards.kabbalah_meditation.title',
        descriptionKey: 'navigation.cards.kabbalah_meditation.description',
      ),
    ],
    continueWithoutBack: [
      NavigationCard(
        title: 'Tüm Çözümlemeler',
        description: 'Diğer pratikler',
        route: '/insight',
        emoji: '🧰',
        titleKey: 'navigation.cards.all_analyses.title',
        descriptionKey: 'navigation.cards.other_practices.description',
      ),
      NavigationCard(
        title: 'Ana Sayfa',
        description: 'Başa dön',
        route: '/',
        emoji: '🏠',
        titleKey: 'navigation.cards.home.title',
        descriptionKey: 'navigation.cards.home.description',
      ),
      NavigationCard(
        title: 'Ritüel Rehberi',
        description: 'Adım adım talimatlar',
        route: '/rituals',
        emoji: '📖',
        titleKey: 'navigation.cards.ritual_guide.title',
        descriptionKey: 'navigation.cards.ritual_guide.description',
      ),
    ],
  );
}

// ============================================================
// NAVIGATION SERVICE
// ============================================================

class NavigationService {
  static PageNavigation getNavigationForRoute(String route) {
    // Normalize route
    final normalizedRoute = route
        .replaceAll(RegExp(r'^/+|/+$'), '')
        .toLowerCase();

    // Check for archetype pages
    if (normalizedRoute.startsWith('insight/')) {
      final archetype = normalizedRoute.split('/').last;
      return ArchetypeNavigation.getNavigationForArchetype(archetype);
    }

    // Map routes to navigation
    switch (normalizedRoute) {
      case '':
      case 'home':
        return HomepageNavigation.navigation;
      case 'insight':
        return InsightHubNavigation.navigation;
      case 'journal':
        return JournalNavigation.navigation;
      case 'discovery':
        return DiscoveryNavigation.navigation;
      case 'wellness':
        return WellnessNavigation.navigation;
      case 'wisdom':
        return WisdomNavigation.navigation;
      case 'dream-interpretation':
        return DreamInterpretationNavigation.navigation;
      case 'reflection':
        return ReflectionNavigation.navigation;
      case 'energy':
        return EnergyNavigation.navigation;
      case 'rituals':
        return RitualNavigation.navigation;
      // Redirect archived routes to insight
      case 'legacy-horoscope':
      case 'legacy-birth-chart':
      case 'legacy-tarot':
      case 'legacy-transits':
      case 'legacy-compat':
      case 'legacy-saturn-return':
      case 'legacy-synastry':
      case 'legacy-solar-return':
      case 'legacy-progressions':
      case 'legacy-vedic':
      case 'legacy-draconic':
      case 'legacy-asteroids':
      case 'legacy-composite':
      case 'legacy-transit-cal':
      case 'legacy-timing':
        return InsightHubNavigation.navigation;
      default:
        return _defaultNavigation(normalizedRoute);
    }
  }

  static PageNavigation _defaultNavigation(String route) {
    return PageNavigation(
      pageRoute: '/$route',
      pageType: 'default',
      alsoViewed: const [
        NavigationCard(
          title: 'Günlük Yansıma',
          description: 'Bugünün enerjisi.',
          route: '/insight',
          emoji: '⭐',
          titleKey: 'navigation.cards.daily_reflection_reading.title',
          descriptionKey: 'navigation.cards.todays_energy.description',
        ),
        NavigationCard(
          title: 'Kişisel Profil',
          description: 'İçsel kimliğin.',
          route: '/insight',
          emoji: '🗺️',
          titleKey: 'navigation.cards.personal_profile.title',
          descriptionKey: 'navigation.cards.inner_identity.description',
        ),
        NavigationCard(
          title: 'Günlük Yansıma',
          description: 'Günlük içgörü.',
          route: '/journal',
          emoji: '📝',
          titleKey: 'navigation.cards.daily_reflection.title',
          descriptionKey: 'navigation.cards.daily_insight.description',
        ),
      ],
      goDeeper: const [
        NavigationCard(
          title: 'Rüyanı Anlat',
          description: 'Bilinçaltınla konuş.',
          route: '/dream-interpretation',
          emoji: '🌙',
          titleKey: 'navigation.cards.tell_your_dream.title',
          descriptionKey: 'navigation.cards.speak_subconscious.description',
        ),
        NavigationCard(
          title: 'İçsel Rehberlik',
          description: 'Kişisel mesaj al.',
          route: '/insight',
          emoji: '✨',
          titleKey: 'navigation.cards.inner_guidance.title',
          descriptionKey: 'navigation.cards.get_personal_message.description',
        ),
      ],
      keepExploring: const [
        NavigationCard(
          title: 'Numeroloji',
          description: 'Sayıların sırrı.',
          route: '/insights-discovery',
          emoji: '🔢',
          titleKey: 'navigation.cards.numerology.title',
          descriptionKey: 'navigation.cards.secret_of_numbers.description',
        ),
        NavigationCard(
          title: 'Aura',
          description: 'Enerji alanın.',
          route: '/insight',
          emoji: '🌈',
          titleKey: 'navigation.cards.aura.title',
          descriptionKey: 'navigation.cards.energy_field.description',
        ),
        NavigationCard(
          title: 'Ritüeller',
          description: 'Ay pratikleri.',
          route: '/rituals',
          emoji: '🌕',
          titleKey: 'navigation.cards.rituals.title',
          descriptionKey: 'navigation.cards.moon_practices.description',
        ),
      ],
      continueWithoutBack: const [
        NavigationCard(
          title: 'Tüm Kişilik Tipleri',
          description: '12 arketip',
          route: '/insight',
          emoji: '🧭',
          titleKey: 'navigation.cards.all_archetypes.title',
          descriptionKey: 'navigation.cards.twelve_archetypes.description',
        ),
        NavigationCard(
          title: 'Ana Sayfa',
          description: 'Başa dön',
          route: '/',
          emoji: '🏠',
          titleKey: 'navigation.cards.home.title',
          descriptionKey: 'navigation.cards.home.description',
        ),
        NavigationCard(
          title: 'Sözlük',
          description: 'Terimler',
          route: '/glossary',
          emoji: '📖',
          titleKey: 'navigation.cards.glossary.title',
          descriptionKey: 'navigation.cards.terms.description',
        ),
      ],
    );
  }
}
