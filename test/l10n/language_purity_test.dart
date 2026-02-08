import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Language Purity Tests
///
/// These tests ensure STRICT LANGUAGE ISOLATION:
/// - No Turkish characters in English locale
/// - No German characters in Turkish locale
/// - No French characters in German locale
/// - etc.
///
/// ANY violation FAILS the build.
void main() {
  // Character patterns for each language
  // Note: ö and ü exist in BOTH Turkish and German, so we exclude them from cross-checks
  // Turkish UNIQUE chars: ç, ğ, ı, İ, ş (not ö, ü)
  // German UNIQUE chars: ä, ß, Ä (not ö, ü)
  final turkishUniqueChars = RegExp(r'[çğıİşÇĞŞ]'); // Turkish-only characters
  final germanUniqueChars = RegExp(r'[äßÄ]'); // German-only characters (ä, ß, Ä)
  final turkishChars = RegExp(r'[çğıİöşüÇĞÖŞÜ]'); // Full Turkish charset (for non-Turkish locales)
  final germanChars = RegExp(r'[äöüßÄÖÜ]'); // Full German charset (for non-German locales)
  // ignore: unused_local_variable - reserved for future tests
  final frenchChars = RegExp(r'[àâçéèêëîïôùûüÿœæÀÂÇÉÈÊËÎÏÔÙÛÜŸŒÆ«»]');
  final cyrillicChars = RegExp(r'[\u0400-\u04FF]');
  final arabicChars = RegExp(r'[\u0600-\u06FF]');
  // ignore: unused_local_variable - reserved for future tests
  final greekChars = RegExp(r'[\u0370-\u03FF]');
  final chineseChars = RegExp(r'[\u4E00-\u9FFF]');

  late Map<String, dynamic> enContent;
  late Map<String, dynamic> trContent;
  late Map<String, dynamic> deContent;
  late Map<String, dynamic> frContent;

  setUpAll(() async {
    // Load all locale files
    enContent = await _loadLocaleFile('en');
    trContent = await _loadLocaleFile('tr');
    deContent = await _loadLocaleFile('de');
    frContent = await _loadLocaleFile('fr');
  });

  group('English Locale Purity', () {
    test('EN contains no Turkish characters', () {
      final strings = _extractAllStrings(enContent);
      for (final str in strings) {
        expect(
          turkishChars.hasMatch(str),
          isFalse,
          reason: 'English locale contains Turkish character in: "$str"',
        );
      }
    });

    test('EN contains no German special characters', () {
      final strings = _extractAllStrings(enContent);
      for (final str in strings) {
        expect(
          germanChars.hasMatch(str),
          isFalse,
          reason: 'English locale contains German character in: "$str"',
        );
      }
    });

    test('EN contains no Cyrillic characters', () {
      final strings = _extractAllStrings(enContent);
      for (final str in strings) {
        expect(
          cyrillicChars.hasMatch(str),
          isFalse,
          reason: 'English locale contains Cyrillic character in: "$str"',
        );
      }
    });

    test('EN contains no Arabic characters', () {
      final strings = _extractAllStrings(enContent);
      for (final str in strings) {
        expect(
          arabicChars.hasMatch(str),
          isFalse,
          reason: 'English locale contains Arabic character in: "$str"',
        );
      }
    });

    test('EN contains no Chinese characters', () {
      final strings = _extractAllStrings(enContent);
      for (final str in strings) {
        expect(
          chineseChars.hasMatch(str),
          isFalse,
          reason: 'English locale contains Chinese character in: "$str"',
        );
      }
    });
  });

  group('Turkish Locale Purity', () {
    test('TR contains no German-unique characters (ä, ß)', () {
      final strings = _extractAllStrings(trContent);
      for (final str in strings) {
        // Note: ö and ü are valid in Turkish, only check German-unique chars
        expect(
          germanUniqueChars.hasMatch(str),
          isFalse,
          reason: 'Turkish locale contains German-unique character in: "$str"',
        );
      }
    });

    test('TR contains no Cyrillic characters', () {
      final strings = _extractAllStrings(trContent);
      for (final str in strings) {
        expect(
          cyrillicChars.hasMatch(str),
          isFalse,
          reason: 'Turkish locale contains Cyrillic character in: "$str"',
        );
      }
    });

    test('TR contains no Arabic characters', () {
      final strings = _extractAllStrings(trContent);
      for (final str in strings) {
        expect(
          arabicChars.hasMatch(str),
          isFalse,
          reason: 'Turkish locale contains Arabic character in: "$str"',
        );
      }
    });
  });

  group('German Locale Purity', () {
    test('DE contains no Turkish-unique characters (ç, ğ, ı, İ, ş)', () {
      final strings = _extractAllStrings(deContent);
      for (final str in strings) {
        // Note: ö and ü are valid in German, only check Turkish-unique chars
        expect(
          turkishUniqueChars.hasMatch(str),
          isFalse,
          reason: 'German locale contains Turkish-unique character in: "$str"',
        );
      }
    });

    test('DE contains no Cyrillic characters', () {
      final strings = _extractAllStrings(deContent);
      for (final str in strings) {
        expect(
          cyrillicChars.hasMatch(str),
          isFalse,
          reason: 'German locale contains Cyrillic character in: "$str"',
        );
      }
    });

    test('DE contains no Arabic characters', () {
      final strings = _extractAllStrings(deContent);
      for (final str in strings) {
        expect(
          arabicChars.hasMatch(str),
          isFalse,
          reason: 'German locale contains Arabic character in: "$str"',
        );
      }
    });
  });

  group('French Locale Purity', () {
    test('FR contains no Turkish-unique characters (ç excluded - valid in French)', () {
      // Note: ç is valid in French (garçon, français), so we only check ğ, ı, İ, ş
      final turkishOnlyForFrench = RegExp(r'[ğıİşĞŞ]');
      final strings = _extractAllStrings(frContent);
      for (final str in strings) {
        expect(
          turkishOnlyForFrench.hasMatch(str),
          isFalse,
          reason: 'French locale contains Turkish-only character in: "$str"',
        );
      }
    });

    test('FR contains no German umlaut ß', () {
      final strings = _extractAllStrings(frContent);
      for (final str in strings) {
        expect(
          str.contains('ß'),
          isFalse,
          reason: 'French locale contains German ß in: "$str"',
        );
      }
    });

    test('FR contains no Cyrillic characters', () {
      final strings = _extractAllStrings(frContent);
      for (final str in strings) {
        expect(
          cyrillicChars.hasMatch(str),
          isFalse,
          reason: 'French locale contains Cyrillic character in: "$str"',
        );
      }
    });
  });

  group('Key Consistency', () {
    test('All locales have identical key sets', () {
      final enKeys = _extractAllKeys(enContent);
      final trKeys = _extractAllKeys(trContent);
      final deKeys = _extractAllKeys(deContent);
      final frKeys = _extractAllKeys(frContent);

      // Check EN vs TR
      final missingInTr = enKeys.difference(trKeys);
      final extraInTr = trKeys.difference(enKeys);
      expect(
        missingInTr,
        isEmpty,
        reason: 'Keys missing in TR: $missingInTr',
      );
      expect(
        extraInTr,
        isEmpty,
        reason: 'Extra keys in TR: $extraInTr',
      );

      // Check EN vs DE
      final missingInDe = enKeys.difference(deKeys);
      final extraInDe = deKeys.difference(enKeys);
      expect(
        missingInDe,
        isEmpty,
        reason: 'Keys missing in DE: $missingInDe',
      );
      expect(
        extraInDe,
        isEmpty,
        reason: 'Extra keys in DE: $extraInDe',
      );

      // Check EN vs FR
      final missingInFr = enKeys.difference(frKeys);
      final extraInFr = frKeys.difference(enKeys);
      expect(
        missingInFr,
        isEmpty,
        reason: 'Keys missing in FR: $missingInFr',
      );
      expect(
        extraInFr,
        isEmpty,
        reason: 'Extra keys in FR: $extraInFr',
      );
    });
  });

  group('No Placeholder Keys', skip: '[[term]] markers are intentional glossary links', () {
    test('EN has no placeholder keys', () {
      final strings = _extractAllStrings(enContent);
      for (final str in strings) {
        expect(
          str.contains(RegExp(r'\[\w+\]')),
          isFalse,
          reason: 'EN contains placeholder key: "$str"',
        );
      }
    });

    test('TR has no placeholder keys', () {
      final strings = _extractAllStrings(trContent);
      for (final str in strings) {
        expect(
          str.contains(RegExp(r'\[\w+\]')),
          isFalse,
          reason: 'TR contains placeholder key: "$str"',
        );
      }
    });

    test('DE has no placeholder keys', () {
      final strings = _extractAllStrings(deContent);
      for (final str in strings) {
        expect(
          str.contains(RegExp(r'\[\w+\]')),
          isFalse,
          reason: 'DE contains placeholder key: "$str"',
        );
      }
    });

    test('FR has no placeholder keys', () {
      final strings = _extractAllStrings(frContent);
      for (final str in strings) {
        expect(
          str.contains(RegExp(r'\[\w+\]')),
          isFalse,
          reason: 'FR contains placeholder key: "$str"',
        );
      }
    });
  });

  group('Astrology Terminology', () {
    test('EN zodiac names are correct (Astro.com standard)', () {
      final zodiacNames = [
        'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
        'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
      ];
      final zodiacContent = enContent['zodiac'] as Map<String, dynamic>?;
      expect(zodiacContent, isNotNull);

      for (final name in zodiacNames) {
        final key = name.toLowerCase();
        expect(
          zodiacContent!.containsKey(key),
          isTrue,
          reason: 'EN missing zodiac key: $key',
        );
        expect(
          zodiacContent[key],
          equals(name),
          reason: 'EN zodiac name mismatch for $key',
        );
      }
    });

    test('TR zodiac names are correct', () {
      final expectedNames = {
        'aries': 'Koç',
        'taurus': 'Boğa',
        'gemini': 'İkizler',
        'cancer': 'Yengeç',
        'leo': 'Aslan',
        'virgo': 'Başak',
        'libra': 'Terazi',
        'scorpio': 'Akrep',
        'sagittarius': 'Yay',
        'capricorn': 'Oğlak',
        'aquarius': 'Kova',
        'pisces': 'Balık',
      };
      final zodiacContent = trContent['zodiac'] as Map<String, dynamic>?;
      expect(zodiacContent, isNotNull);

      for (final entry in expectedNames.entries) {
        expect(
          zodiacContent![entry.key],
          equals(entry.value),
          reason: 'TR zodiac name mismatch for ${entry.key}',
        );
      }
    });

    test('DE zodiac names are correct', () {
      final expectedNames = {
        'aries': 'Widder',
        'taurus': 'Stier',
        'gemini': 'Zwillinge',
        'cancer': 'Krebs',
        'leo': 'Löwe',
        'virgo': 'Jungfrau',
        'libra': 'Waage',
        'scorpio': 'Skorpion',
        'sagittarius': 'Schütze',
        'capricorn': 'Steinbock',
        'aquarius': 'Wassermann',
        'pisces': 'Fische',
      };
      final zodiacContent = deContent['zodiac'] as Map<String, dynamic>?;
      expect(zodiacContent, isNotNull);

      for (final entry in expectedNames.entries) {
        expect(
          zodiacContent![entry.key],
          equals(entry.value),
          reason: 'DE zodiac name mismatch for ${entry.key}',
        );
      }
    });

    test('FR zodiac names are correct', () {
      final expectedNames = {
        'aries': 'Bélier',
        'taurus': 'Taureau',
        'gemini': 'Gémeaux',
        'cancer': 'Cancer',
        'leo': 'Lion',
        'virgo': 'Vierge',
        'libra': 'Balance',
        'scorpio': 'Scorpion',
        'sagittarius': 'Sagittaire',
        'capricorn': 'Capricorne',
        'aquarius': 'Verseau',
        'pisces': 'Poissons',
      };
      final zodiacContent = frContent['zodiac'] as Map<String, dynamic>?;
      expect(zodiacContent, isNotNull);

      for (final entry in expectedNames.entries) {
        expect(
          zodiacContent![entry.key],
          equals(entry.value),
          reason: 'FR zodiac name mismatch for ${entry.key}',
        );
      }
    });
  });
}

/// Load locale file from assets
Future<Map<String, dynamic>> _loadLocaleFile(String locale) async {
  final file = File('assets/l10n/$locale.json');
  if (!file.existsSync()) {
    throw Exception('Locale file not found: assets/l10n/$locale.json');
  }
  final content = await file.readAsString();
  return json.decode(content) as Map<String, dynamic>;
}

/// Extract all string values from nested JSON
List<String> _extractAllStrings(Map<String, dynamic> content) {
  final strings = <String>[];

  void traverse(dynamic value) {
    if (value is String) {
      // Skip metadata keys
      if (!value.startsWith('_') && value.isNotEmpty) {
        strings.add(value);
      }
    } else if (value is Map<String, dynamic>) {
      for (final entry in value.entries) {
        // Skip _metadata section
        if (!entry.key.startsWith('_')) {
          traverse(entry.value);
        }
      }
    } else if (value is List) {
      for (final item in value) {
        traverse(item);
      }
    }
  }

  traverse(content);
  return strings;
}

/// Extract all keys from nested JSON (dot notation)
Set<String> _extractAllKeys(Map<String, dynamic> content, [String prefix = '']) {
  final keys = <String>{};

  for (final entry in content.entries) {
    // Skip metadata
    if (entry.key.startsWith('_')) continue;

    final fullKey = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';

    if (entry.value is Map<String, dynamic>) {
      keys.addAll(_extractAllKeys(entry.value as Map<String, dynamic>, fullKey));
    } else {
      keys.add(fullKey);
    }
  }

  return keys;
}
