/// Schema.org Markup Service for Structured Data Generation
/// Generates page-specific JSON-LD markup for SEO
library;

import 'dart:convert';
import 'seo_meta_service.dart';
import '../providers/app_providers.dart';

class SchemaMarkupService {
  static const String _baseUrl = 'https://venusone.com';
  static const String _logoUrl = '$_baseUrl/icons/Icon-512.png';
  static const String _orgName = 'Venus One';

  /// Generate JSON-LD script tag content for a given route
  static String generateSchemaMarkup(String route, {AppLanguage language = AppLanguage.tr}) {
    final meta = SeoMetaService.getMetaForRoute(route, language: language);
    final schemas = <Map<String, dynamic>>[];

    // Always add Organization schema
    schemas.add(_organizationSchema(language: language));

    // Always add WebSite schema
    schemas.add(_websiteSchema(language: language));

    // Add BreadcrumbList
    schemas.add(_breadcrumbSchema(route, meta.title, language: language));

    // Add page-specific schema based on type
    switch (meta.schemaType) {
      case SchemaType.webApplication:
        schemas.add(_webApplicationSchema(meta, language: language));
        break;
      case SchemaType.article:
        schemas.add(_articleSchema(meta, language: language));
        break;
      case SchemaType.howTo:
        schemas.add(_howToSchema(meta, language: language));
        break;
      case SchemaType.product:
        schemas.add(_productSchema(meta, language: language));
        break;
      case SchemaType.collectionPage:
        schemas.add(_collectionPageSchema(meta, language: language));
        break;
      case SchemaType.definedTermSet:
        schemas.add(_definedTermSetSchema(meta, language: language));
        break;
      case SchemaType.faqPage:
        schemas.add(_faqPageSchema(meta, language: language));
        break;
      case SchemaType.profilePage:
        schemas.add(_profilePageSchema(meta));
        break;
      case SchemaType.webPage:
        schemas.add(_webPageSchema(meta));
        break;
    }

    // Return as script tags
    return schemas.map((s) => '<script type="application/ld+json">${jsonEncode(s)}</script>').join('\n');
  }

  /// Organization schema - appears on all pages
  static Map<String, dynamic> _organizationSchema({AppLanguage language = AppLanguage.tr}) {
    return {
      '@context': 'https://schema.org',
      '@type': 'Organization',
      'name': _orgName,
      'url': _baseUrl,
      'logo': _logoUrl,
      'sameAs': [
        'https://twitter.com/venusoneapp',
        'https://instagram.com/venusoneapp',
        'https://facebook.com/venusoneapp',
      ],
      'contactPoint': {
        '@type': 'ContactPoint',
        'contactType': 'customer service',
        'availableLanguage': ['Turkish', 'English'],
      },
    };
  }

  /// WebSite schema with search action
  static Map<String, dynamic> _websiteSchema({AppLanguage language = AppLanguage.tr}) {
    final description = language == AppLanguage.tr
      ? "Türkiye'nin en kapsamlı astroloji, numeroloji ve tarot uygulaması"
      : "The most comprehensive astrology, numerology and tarot application";
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    return {
      '@context': 'https://schema.org',
      '@type': 'WebSite',
      'name': _orgName,
      'url': _baseUrl,
      'description': description,
      'potentialAction': {
        '@type': 'SearchAction',
        'target': '$_baseUrl/search?q={search_term_string}',
        'query-input': 'required name=search_term_string',
      },
      'inLanguage': languageCode,
    };
  }

  /// Breadcrumb schema
  static Map<String, dynamic> _breadcrumbSchema(String route, String title, {AppLanguage language = AppLanguage.tr}) {
    final normalizedRoute = route.replaceAll(RegExp(r'^/+|/+$'), '').toLowerCase();
    final homeName = language == AppLanguage.tr ? 'Ana Sayfa' : 'Home';
    final items = <Map<String, dynamic>>[
      {
        '@type': 'ListItem',
        'position': 1,
        'name': homeName,
        'item': _baseUrl,
      },
    ];

    if (normalizedRoute.isNotEmpty && normalizedRoute != 'home') {
      items.add({
        '@type': 'ListItem',
        'position': 2,
        'name': title.split(' — ').first.split(' | ').first,
        'item': '$_baseUrl/$normalizedRoute',
      });
    }

    return {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      'itemListElement': items,
    };
  }

  /// Web Application schema for tools
  static Map<String, dynamic> _webApplicationSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    final currency = language == AppLanguage.tr ? 'TRY' : 'USD';
    return {
      '@context': 'https://schema.org',
      '@type': 'WebApplication',
      'name': meta.title.split(' — ').first.split(' | ').first,
      'url': meta.getCanonicalUrl(_baseUrl),
      'description': meta.description,
      'applicationCategory': 'LifestyleApplication',
      'operatingSystem': 'Web, iOS, Android',
      'offers': {
        '@type': 'Offer',
        'price': '0',
        'priceCurrency': currency,
      },
      'author': {
        '@type': 'Organization',
        'name': _orgName,
      },
      'inLanguage': languageCode,
    };
  }

  /// Article schema for content pages
  static Map<String, dynamic> _articleSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final now = DateTime.now().toIso8601String();
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    return {
      '@context': 'https://schema.org',
      '@type': 'Article',
      'headline': meta.title.split(' — ').first.split(' | ').first,
      'description': meta.description,
      'url': meta.getCanonicalUrl(_baseUrl),
      'datePublished': now,
      'dateModified': now,
      'author': {
        '@type': 'Organization',
        'name': _orgName,
        'url': _baseUrl,
      },
      'publisher': {
        '@type': 'Organization',
        'name': _orgName,
        'logo': {
          '@type': 'ImageObject',
          'url': _logoUrl,
        },
      },
      'mainEntityOfPage': {
        '@type': 'WebPage',
        '@id': meta.getCanonicalUrl(_baseUrl),
      },
      'inLanguage': languageCode,
    };
  }

  /// HowTo schema for ritual/guide pages
  static Map<String, dynamic> _howToSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    final steps = language == AppLanguage.tr
      ? [
          {'@type': 'HowToStep', 'name': 'Hazırlık', 'text': 'Sessiz ve rahat bir ortam oluşturun.'},
          {'@type': 'HowToStep', 'name': 'Niyet Belirleme', 'text': 'Açık ve net niyetinizi belirleyin.'},
          {'@type': 'HowToStep', 'name': 'Uygulama', 'text': 'Ritüeli talimatlar doğrultusunda gerçekleştirin.'},
        ]
      : [
          {'@type': 'HowToStep', 'name': 'Preparation', 'text': 'Create a quiet and comfortable environment.'},
          {'@type': 'HowToStep', 'name': 'Set Intention', 'text': 'Clearly define your intention.'},
          {'@type': 'HowToStep', 'name': 'Practice', 'text': 'Perform the ritual according to the instructions.'},
        ];
    return {
      '@context': 'https://schema.org',
      '@type': 'HowTo',
      'name': meta.title.split(' — ').first.split(' | ').first,
      'description': meta.description,
      'url': meta.getCanonicalUrl(_baseUrl),
      'inLanguage': languageCode,
      'step': steps,
    };
  }

  /// Product schema for premium page
  static Map<String, dynamic> _productSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final currency = language == AppLanguage.tr ? 'TRY' : 'USD';
    return {
      '@context': 'https://schema.org',
      '@type': 'Product',
      'name': 'Venus One Premium',
      'description': meta.description,
      'url': meta.getCanonicalUrl(_baseUrl),
      'brand': {
        '@type': 'Brand',
        'name': _orgName,
      },
      'offers': {
        '@type': 'Offer',
        'priceCurrency': currency,
        'availability': 'https://schema.org/InStock',
      },
    };
  }

  /// Collection page schema
  static Map<String, dynamic> _collectionPageSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    return {
      '@context': 'https://schema.org',
      '@type': 'CollectionPage',
      'name': meta.title.split(' — ').first.split(' | ').first,
      'description': meta.description,
      'url': meta.getCanonicalUrl(_baseUrl),
      'inLanguage': languageCode,
    };
  }

  /// Defined term set schema for glossary
  static Map<String, dynamic> _definedTermSetSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    return {
      '@context': 'https://schema.org',
      '@type': 'DefinedTermSet',
      'name': meta.title.split(' — ').first.split(' | ').first,
      'description': meta.description,
      'url': meta.getCanonicalUrl(_baseUrl),
      'inLanguage': languageCode,
    };
  }

  /// FAQ page schema
  static Map<String, dynamic> _faqPageSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    return {
      '@context': 'https://schema.org',
      '@type': 'FAQPage',
      'name': meta.title.split(' — ').first.split(' | ').first,
      'description': meta.description,
      'url': meta.getCanonicalUrl(_baseUrl),
      'mainEntity': [],
      'inLanguage': languageCode,
    };
  }

  /// Profile page schema
  static Map<String, dynamic> _profilePageSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    return {
      '@context': 'https://schema.org',
      '@type': 'ProfilePage',
      'name': meta.title.split(' — ').first.split(' | ').first,
      'description': meta.description,
      'url': meta.getCanonicalUrl(_baseUrl),
      'inLanguage': languageCode,
    };
  }

  /// Generic web page schema
  static Map<String, dynamic> _webPageSchema(PageMeta meta, {AppLanguage language = AppLanguage.tr}) {
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    return {
      '@context': 'https://schema.org',
      '@type': 'WebPage',
      'name': meta.title.split(' — ').first.split(' | ').first,
      'description': meta.description,
      'url': meta.getCanonicalUrl(_baseUrl),
      'inLanguage': languageCode,
    };
  }

  /// Generate FAQ schema from a list of FAQ items
  static Map<String, dynamic> generateFaqSchema(List<Map<String, String>> faqs) {
    return {
      '@context': 'https://schema.org',
      '@type': 'FAQPage',
      'mainEntity': faqs.map((faq) {
        return {
          '@type': 'Question',
          'name': faq['question'],
          'acceptedAnswer': {
            '@type': 'Answer',
            'text': faq['answer'],
          },
        };
      }).toList(),
    };
  }

  /// Generate zodiac-specific article schema
  static Map<String, dynamic> generateZodiacArticleSchema({
    required String signName,
    required String signSymbol,
    required String description,
    required String dates,
    AppLanguage language = AppLanguage.tr,
  }) {
    final now = DateTime.now().toIso8601String();
    final languageCode = language == AppLanguage.tr ? 'tr-TR' : 'en-US';
    final headline = language == AppLanguage.tr
      ? '$signName Burcu $signSymbol — Günlük Burç Yorumu'
      : '$signName $signSymbol — Daily Horoscope';
    final signLabel = language == AppLanguage.tr ? '$signName Burcu' : signName;
    final datesDescription = language == AppLanguage.tr
      ? '$dates tarihleri arasında doğanlar'
      : 'Born between $dates';
    return {
      '@context': 'https://schema.org',
      '@type': 'Article',
      'headline': headline,
      'description': description,
      'url': '$_baseUrl/horoscope/${signName.toLowerCase()}',
      'datePublished': now,
      'dateModified': now,
      'author': {
        '@type': 'Organization',
        'name': _orgName,
      },
      'publisher': {
        '@type': 'Organization',
        'name': _orgName,
        'logo': {
          '@type': 'ImageObject',
          'url': _logoUrl,
        },
      },
      'about': {
        '@type': 'Thing',
        'name': signLabel,
        'description': datesDescription,
      },
      'inLanguage': languageCode,
    };
  }
}
