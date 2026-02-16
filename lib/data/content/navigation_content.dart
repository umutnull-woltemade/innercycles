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
        description: 'Enerjini ve dengenı keşfet.',
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
    'pioneer': {
      'name': 'Öncü',
      'compatibleSign1': 'Sahne Yıldızı',
      'compatibleRoute1': 'performer',
      'compatibleEmoji1': '🌟',
      'elementBuddy1': 'Sahne Yıldızı',
      'elementBuddyRoute1': 'performer',
      'elementBuddyEmoji1': '🌟',
      'elementBuddy2': 'Kaşif',
      'elementBuddyRoute2': 'explorer',
      'elementBuddyEmoji2': '🧭',
    },
    'builder': {
      'name': 'Kurucu',
      'compatibleSign1': 'Analist',
      'compatibleRoute1': 'analyst',
      'compatibleEmoji1': '🔍',
      'elementBuddy1': 'Analist',
      'elementBuddyRoute1': 'analyst',
      'elementBuddyEmoji1': '🔍',
      'elementBuddy2': 'Başarıcı',
      'elementBuddyRoute2': 'achiever',
      'elementBuddyEmoji2': '🏔',
    },
    'communicator': {
      'name': 'İletişimci',
      'compatibleSign1': 'Dengeleyici',
      'compatibleRoute1': 'harmonizer',
      'compatibleEmoji1': '⚖️',
      'elementBuddy1': 'Dengeleyici',
      'elementBuddyRoute1': 'harmonizer',
      'elementBuddyEmoji1': '⚖️',
      'elementBuddy2': 'Vizyoner',
      'elementBuddyRoute2': 'visionary',
      'elementBuddyEmoji2': '💡',
    },
    'nurturer': {
      'name': 'Koruyucu',
      'compatibleSign1': 'Dönüştürücü',
      'compatibleRoute1': 'transformer',
      'compatibleEmoji1': '🦋',
      'elementBuddy1': 'Dönüştürücü',
      'elementBuddyRoute1': 'transformer',
      'elementBuddyEmoji1': '🦋',
      'elementBuddy2': 'Hayalci',
      'elementBuddyRoute2': 'dreamer',
      'elementBuddyEmoji2': '🌙',
    },
    'performer': {
      'name': 'Sahne Yıldızı',
      'compatibleSign1': 'Öncü',
      'compatibleRoute1': 'pioneer',
      'compatibleEmoji1': '🚀',
      'elementBuddy1': 'Öncü',
      'elementBuddyRoute1': 'pioneer',
      'elementBuddyEmoji1': '🚀',
      'elementBuddy2': 'Kaşif',
      'elementBuddyRoute2': 'explorer',
      'elementBuddyEmoji2': '🧭',
    },
    'analyst': {
      'name': 'Analist',
      'compatibleSign1': 'Kurucu',
      'compatibleRoute1': 'builder',
      'compatibleEmoji1': '🏗',
      'elementBuddy1': 'Kurucu',
      'elementBuddyRoute1': 'builder',
      'elementBuddyEmoji1': '🏗',
      'elementBuddy2': 'Başarıcı',
      'elementBuddyRoute2': 'achiever',
      'elementBuddyEmoji2': '🏔',
    },
    'harmonizer': {
      'name': 'Dengeleyici',
      'compatibleSign1': 'İletişimci',
      'compatibleRoute1': 'communicator',
      'compatibleEmoji1': '💬',
      'elementBuddy1': 'İletişimci',
      'elementBuddyRoute1': 'communicator',
      'elementBuddyEmoji1': '💬',
      'elementBuddy2': 'Vizyoner',
      'elementBuddyRoute2': 'visionary',
      'elementBuddyEmoji2': '💡',
    },
    'transformer': {
      'name': 'Dönüştürücü',
      'compatibleSign1': 'Koruyucu',
      'compatibleRoute1': 'nurturer',
      'compatibleEmoji1': '🛡',
      'elementBuddy1': 'Koruyucu',
      'elementBuddyRoute1': 'nurturer',
      'elementBuddyEmoji1': '🛡',
      'elementBuddy2': 'Hayalci',
      'elementBuddyRoute2': 'dreamer',
      'elementBuddyEmoji2': '🌙',
    },
    'explorer': {
      'name': 'Kaşif',
      'compatibleSign1': 'Öncü',
      'compatibleRoute1': 'pioneer',
      'compatibleEmoji1': '🚀',
      'elementBuddy1': 'Öncü',
      'elementBuddyRoute1': 'pioneer',
      'elementBuddyEmoji1': '🚀',
      'elementBuddy2': 'Sahne Yıldızı',
      'elementBuddyRoute2': 'performer',
      'elementBuddyEmoji2': '🌟',
    },
    'achiever': {
      'name': 'Başarıcı',
      'compatibleSign1': 'Kurucu',
      'compatibleRoute1': 'builder',
      'compatibleEmoji1': '🏗',
      'elementBuddy1': 'Kurucu',
      'elementBuddyRoute1': 'builder',
      'elementBuddyEmoji1': '🏗',
      'elementBuddy2': 'Analist',
      'elementBuddyRoute2': 'analyst',
      'elementBuddyEmoji2': '🔍',
    },
    'visionary': {
      'name': 'Vizyoner',
      'compatibleSign1': 'İletişimci',
      'compatibleRoute1': 'communicator',
      'compatibleEmoji1': '💬',
      'elementBuddy1': 'İletişimci',
      'elementBuddyRoute1': 'communicator',
      'elementBuddyEmoji1': '💬',
      'elementBuddy2': 'Dengeleyici',
      'elementBuddyRoute2': 'harmonizer',
      'elementBuddyEmoji2': '⚖️',
    },
    'dreamer': {
      'name': 'Hayalci',
      'compatibleSign1': 'Koruyucu',
      'compatibleRoute1': 'nurturer',
      'compatibleEmoji1': '🛡',
      'elementBuddy1': 'Koruyucu',
      'elementBuddyRoute1': 'nurturer',
      'elementBuddyEmoji1': '🛡',
      'elementBuddy2': 'Dönüştürücü',
      'elementBuddyRoute2': 'transformer',
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
        title: 'İlişki Enerjisi',
        description: 'Aşk enerjilerini incele.',
        route: '/insight',
        emoji: '💞',
        titleKey: 'navigation.cards.relationship_energy.title',
        descriptionKey: 'navigation.cards.relationship_energy.description',
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
        description: 'İsimlerle keşif.',
        route: '/insights-discovery',
        emoji: '🔢',
        titleKey: 'navigation.cards.numerical_harmony.title',
        descriptionKey: 'navigation.cards.numerical_harmony.description',
      ),
      NavigationCard(
        title: 'Duygusal Döngü',
        description: 'İlişki enerjin nerede?',
        route: '/insight',
        emoji: '💖',
        titleKey: 'navigation.cards.emotional_cycle.title',
        descriptionKey: 'navigation.cards.emotional_cycle.description',
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
        description: 'Gözden geçirme dönemi ne zaman?',
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
        title: 'Rüya Günlüğü',
        description: 'Rüyalarını kaydet ve takip et.',
        route: '/journal',
        emoji: '📓',
        titleKey: 'navigation.cards.dream_journal.title',
        descriptionKey: 'navigation.cards.dream_journal.description',
      ),
      NavigationCard(
        title: 'Uyku Kalitesi',
        description: 'Uyku düzenini keşfet.',
        route: '/insight',
        emoji: '😴',
        titleKey: 'navigation.cards.sleep_quality.title',
        descriptionKey: 'navigation.cards.sleep_quality.description',
      ),
      NavigationCard(
        title: 'İçsel Keşif',
        description: 'Kişilik kalıplarını incele.',
        route: '/insights-discovery',
        emoji: '🔍',
        titleKey: 'navigation.cards.inner_discovery.title',
        descriptionKey: 'navigation.cards.inner_discovery.description',
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
      case 'dream-interpretation':
        return DreamInterpretationNavigation.navigation;
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
          title: 'Kendini Keşfet',
          description: 'Kişilik testi ve içgörüler.',
          route: '/insights-discovery',
          emoji: '🔍',
          titleKey: 'navigation.cards.discover_yourself.title',
          descriptionKey: 'navigation.cards.personality_test.description',
        ),
        NavigationCard(
          title: 'Günlük',
          description: 'Bugün nasıl hissediyorsun?',
          route: '/journal',
          emoji: '📝',
          titleKey: 'navigation.cards.journal.title',
          descriptionKey: 'navigation.cards.how_feeling_today.description',
        ),
        NavigationCard(
          title: 'Ritüeller',
          description: 'Günlük pratikler.',
          route: '/rituals',
          emoji: '🌿',
          titleKey: 'navigation.cards.rituals.title',
          descriptionKey: 'navigation.cards.daily_practices.description',
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
