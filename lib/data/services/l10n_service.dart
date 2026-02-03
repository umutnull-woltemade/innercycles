import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../providers/app_providers.dart';

/// Strict isolation L10n service - NO CROSS-LANGUAGE FALLBACK
///
/// When a language is selected:
/// - ONLY that language's translations are used
/// - Missing keys return visible placeholder and trigger AI auto-repair
/// - ZERO leakage from other languages
class L10nService {
  L10nService._();

  static final Map<AppLanguage, Map<String, dynamic>> _translations = {};
  static final Set<String> _missingKeys = {};
  static bool _initialized = false;
  static AppLanguage? _currentLanguage;

  /// Supported languages with strict isolation
  /// Only these 4 languages are fully supported with complete translations
  static const Set<AppLanguage> supportedLanguages = {
    AppLanguage.en,
    AppLanguage.tr,
    AppLanguage.de,
    AppLanguage.fr,
  };

  /// Check if service is initialized
  static bool get isInitialized => _initialized;

  /// Get current language
  static AppLanguage? get currentLanguage => _currentLanguage;

  /// Initialize translations for a language
  /// Must be called before using get()
  ///
  /// Throws [UnsupportedLanguageException] if language is not in supportedLanguages
  /// Throws [LocaleLoadException] if JSON file cannot be loaded
  static Future<void> init(AppLanguage language) async {
    if (!supportedLanguages.contains(language)) {
      throw UnsupportedLanguageException(language);
    }

    // Already loaded this language
    if (_translations.containsKey(language)) {
      _currentLanguage = language;
      _initialized = true;
      return;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/l10n/${language.name}.json',
      );
      final decoded = json.decode(jsonString);
      if (decoded is Map<String, dynamic>) {
        _translations[language] = decoded;
        _currentLanguage = language;
        _initialized = true;

        if (kDebugMode) {
          debugPrint('L10nService: Loaded ${language.name}.json successfully');
        }
      } else {
        throw LocaleLoadException(language, 'Invalid JSON structure');
      }
    } catch (e) {
      if (e is LocaleLoadException) rethrow;
      throw LocaleLoadException(language, e);
    }
  }

  /// Preload all supported languages (optional optimization)
  static Future<void> preloadAll() async {
    for (final lang in supportedLanguages) {
      try {
        await init(lang);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('L10nService: Failed to preload ${lang.name}: $e');
        }
      }
    }
  }

  /// Get translation with STRICT ISOLATION (NO FALLBACK)
  ///
  /// Returns:
  /// - The translated string if found
  /// - '[$key]' placeholder if missing (triggers AI auto-repair logging)
  ///
  /// IMPORTANT: This method NEVER falls back to another language.
  /// If the key is missing in the requested language, it returns a placeholder.
  static String get(String key, AppLanguage language) {
    // Ensure language is loaded
    if (!_translations.containsKey(language)) {
      _logMissingKeyForAIRepair(key, language, 'LOCALE_NOT_LOADED');
      return '[$key]';
    }

    final value = _resolveKey(key, _translations[language]!);

    if (value == null) {
      _logMissingKeyForAIRepair(key, language, 'KEY_NOT_FOUND');
      return '[$key]';
    }

    return value;
  }

  /// Get translation with parameters
  ///
  /// Replaces {paramName} placeholders with provided values
  /// Example: get('greeting', lang, params: {'name': 'John'})
  ///          where greeting = "Hello, {name}!" returns "Hello, John!"
  static String getWithParams(
    String key,
    AppLanguage language, {
    required Map<String, String> params,
  }) {
    var result = get(key, language);

    params.forEach((paramKey, paramValue) {
      result = result.replaceAll('{$paramKey}', paramValue);
    });

    return result;
  }

  /// Get a list of strings from a translation key
  /// Returns empty list if key is not found or is not a list
  static List<String> getList(String key, AppLanguage language) {
    if (!_translations.containsKey(language)) {
      _logMissingKeyForAIRepair(key, language, 'LOCALE_NOT_LOADED');
      return [];
    }

    final value = _resolveKeyRaw(key, _translations[language]!);

    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    _logMissingKeyForAIRepair(key, language, 'KEY_NOT_LIST');
    return [];
  }

  /// Resolve nested keys like "screens.home.greeting_morning"
  static String? _resolveKey(String key, Map<String, dynamic> translations) {
    final value = _resolveKeyRaw(key, translations);
    return value is String ? value : null;
  }

  /// Resolve nested keys and return raw value (for lists, maps, etc.)
  static dynamic _resolveKeyRaw(String key, Map<String, dynamic> translations) {
    final parts = key.split('.');
    dynamic current = translations;

    for (final part in parts) {
      if (current is! Map<String, dynamic>) return null;
      current = current[part];
    }

    return current;
  }

  /// Log missing key for AI auto-repair system
  ///
  /// This logs the missing key with context so it can be:
  /// 1. Tracked for review
  /// 2. Auto-generated by AI
  /// 3. Flagged for human review
  static void _logMissingKeyForAIRepair(
    String key,
    AppLanguage language,
    String reason,
  ) {
    final missingKeyId = '${language.name}:$key';

    // Avoid duplicate logging
    if (_missingKeys.contains(missingKeyId)) return;
    _missingKeys.add(missingKeyId);

    final logData = {
      'key': key,
      'language': language.name,
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    };

    developer.log(
      'MISSING_L10N_KEY: $logData',
      name: 'L10nService',
    );

    if (kDebugMode) {
      debugPrint('L10nService: Missing key "$key" for ${language.name} ($reason)');
    }

    // TODO: Trigger AI auto-repair hook (non-blocking)
    // _triggerAIAutoRepair(key, language, reason);
  }

  /// Get all missing keys (for debugging/testing)
  static Set<String> getMissingKeys() => Set.unmodifiable(_missingKeys);

  /// Clear missing keys log (for testing)
  static void clearMissingKeys() => _missingKeys.clear();

  /// Check if a key exists for a language (for testing)
  static bool hasKey(String key, AppLanguage language) {
    if (!_translations.containsKey(language)) return false;
    return _resolveKey(key, _translations[language]!) != null;
  }

  /// Check if a language is loaded
  static bool isLanguageLoaded(AppLanguage language) {
    return _translations.containsKey(language);
  }

  /// Get all loaded languages
  static Set<AppLanguage> getLoadedLanguages() {
    return _translations.keys.toSet();
  }

  /// Reload a specific language (useful for hot reload during development)
  static Future<void> reload(AppLanguage language) async {
    _translations.remove(language);
    await init(language);
  }

  /// Clear all loaded translations (for testing)
  static void clearAll() {
    _translations.clear();
    _missingKeys.clear();
    _initialized = false;
    _currentLanguage = null;
  }
}

/// Exception thrown when an unsupported language is requested
class UnsupportedLanguageException implements Exception {
  final AppLanguage language;

  UnsupportedLanguageException(this.language);

  @override
  String toString() =>
      'UnsupportedLanguageException: ${language.name} is not supported. '
      'Supported languages: ${L10nService.supportedLanguages.map((l) => l.name).join(", ")}';
}

/// Exception thrown when a locale file cannot be loaded
class LocaleLoadException implements Exception {
  final AppLanguage language;
  final Object error;

  LocaleLoadException(this.language, this.error);

  @override
  String toString() =>
      'LocaleLoadException: Failed to load ${language.name}.json: $error';
}

/// Extension for convenient access in widgets with Riverpod
extension L10nWidgetRef on dynamic {
  /// Translate a key using the current language from languageProvider
  /// Usage: ref.tr('common.cancel')
  String tr(String key) {
    // This would be used with WidgetRef
    // final language = watch(languageProvider);
    // return L10nService.get(key, language);
    throw UnimplementedError(
      'Use L10nService.get(key, language) directly or implement tr() in your widget',
    );
  }
}

/// Global convenience function for translation
/// Usage: tr('common.cancel', AppLanguage.en)
String tr(String key, AppLanguage language) => L10nService.get(key, language);

/// Global convenience function for translation with parameters
/// Usage: trParams('greeting', AppLanguage.en, params: {'name': 'John'})
String trParams(String key, AppLanguage language, {required Map<String, String> params}) =>
    L10nService.getWithParams(key, language, params: params);
