import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../providers/app_providers.dart';
import 'package:flutter/material.dart';

/// Local storage service using Hive for persisting user data
class StorageService {
  static const String _userProfileBoxName = 'user_profile_box';
  static const String _settingsBoxName = 'settings_box';

  static const String _profileKey = 'user_profile';
  static const String _allProfilesKey = 'all_profiles';
  static const String _primaryProfileIdKey = 'primary_profile_id';
  static const String _onboardingKey = 'onboarding_complete';
  static const String _disclaimerKey = 'disclaimer_accepted';
  static const String _languageKey = 'app_language';
  static const String _themeModeKey = 'theme_mode';

  static Box? _profileBox;
  static Box? _settingsBox;

  static bool get _isInitialized => _profileBox != null && _settingsBox != null;

  static void _warnIfNotInitialized(String method) {
    if (!_isInitialized && kDebugMode) {
      debugPrint('StorageService.$method called before initialize()');
    }
  }

  /// Initialize Hive and open boxes (skipped on web to prevent white screen)
  static Future<void> initialize() async {
    // Skip Hive entirely on web - IndexedDB can hang and cause white screen
    // Web will work in memory-only mode (no persistence between sessions)
    if (kIsWeb) {
      if (kDebugMode) {
        debugPrint('StorageService: Skipping Hive on web (memory-only mode)');
      }
      return;
    }

    try {
      await Hive.initFlutter();

      // Try to open boxes with individual timeouts
      _profileBox = await Hive.openBox(_userProfileBoxName).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (kDebugMode) {
            debugPrint('Warning: Profile box initialization timed out');
          }
          throw TimeoutException('Profile box timeout');
        },
      );

      _settingsBox = await Hive.openBox(_settingsBoxName).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (kDebugMode) {
            debugPrint('Warning: Settings box initialization timed out');
          }
          throw TimeoutException('Settings box timeout');
        },
      );

      if (kDebugMode) {
        debugPrint('StorageService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('StorageService initialization error: $e');
      }
      // Continue without storage - app will work in memory-only mode
    }
  }

  // ========== USER PROFILE ==========

  /// Save user profile to local storage
  static Future<void> saveUserProfile(UserProfile profile) async {
    _warnIfNotInitialized('saveUserProfile');
    final box = _profileBox;
    if (box == null) return;

    final json = jsonEncode(profile.toJson());
    await box.put(_profileKey, json);
  }

  /// Load user profile from local storage
  static UserProfile? loadUserProfile() {
    _warnIfNotInitialized('loadUserProfile');
    final box = _profileBox;
    if (box == null) return null;

    final json = box.get(_profileKey) as String?;
    if (json == null) return null;

    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final profile = UserProfile.fromJson(data);

      // Validate profile has required data (name must exist and not be empty)
      if (profile.name == null || profile.name!.isEmpty) {
        // Clear invalid data
        box.delete(_profileKey);
        return null;
      }

      return profile;
    } catch (e) {
      // Clear corrupted data
      box.delete(_profileKey);
      return null;
    }
  }

  /// Delete user profile from local storage
  static Future<void> deleteUserProfile() async {
    _warnIfNotInitialized('deleteUserProfile');
    final box = _profileBox;
    if (box == null) return;

    await box.delete(_profileKey);
  }

  // ========== MULTIPLE PROFILES ==========

  static Future<void> saveProfile(UserProfile profile) async {
    _warnIfNotInitialized('saveProfile');
    final box = _profileBox;
    if (box == null) return;

    final profiles = loadAllProfiles();
    final index = profiles.indexWhere((p) => p.id == profile.id);

    if (index >= 0) {
      profiles[index] = profile.copyWith(updatedAt: DateTime.now());
    } else {
      profiles.add(profile);
    }

    final jsonList = profiles.map((p) => p.toJson()).toList();
    await box.put(_allProfilesKey, jsonEncode(jsonList));

    if (profile.isPrimary || profiles.length == 1) {
      await setPrimaryProfileId(profile.id);
    }
  }

  static List<UserProfile> loadAllProfiles() {
    _warnIfNotInitialized('loadAllProfiles');
    final box = _profileBox;
    if (box == null) return [];

    final json = box.get(_allProfilesKey) as String?;
    if (json == null) {
      final legacy = loadUserProfile();
      if (legacy != null) {
        return [legacy.copyWith(isPrimary: true)];
      }
      return [];
    }

    try {
      final list = jsonDecode(json) as List;
      return list
          .map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .where((p) => p.name != null && p.name!.isNotEmpty)
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> deleteProfile(String id) async {
    _warnIfNotInitialized('deleteProfile');
    final box = _profileBox;
    if (box == null) return;

    final profiles = loadAllProfiles();
    profiles.removeWhere((p) => p.id == id);

    final jsonList = profiles.map((p) => p.toJson()).toList();
    await box.put(_allProfilesKey, jsonEncode(jsonList));

    final primaryId = getPrimaryProfileId();
    if (primaryId == id && profiles.isNotEmpty) {
      await setPrimaryProfileId(profiles.first.id);
    }
  }

  static Future<void> setPrimaryProfileId(String id) async {
    _warnIfNotInitialized('setPrimaryProfileId');
    final box = _profileBox;
    if (box == null) return;
    await box.put(_primaryProfileIdKey, id);
  }

  static String? getPrimaryProfileId() {
    _warnIfNotInitialized('getPrimaryProfileId');
    final box = _profileBox;
    if (box == null) return null;
    return box.get(_primaryProfileIdKey) as String?;
  }

  static UserProfile? getPrimaryProfile() {
    final profiles = loadAllProfiles();
    final primaryId = getPrimaryProfileId();

    if (primaryId != null) {
      final primary = profiles.where((p) => p.id == primaryId).firstOrNull;
      if (primary != null) return primary;
    }

    return profiles.isNotEmpty ? profiles.first : null;
  }

  static UserProfile? getProfileById(String id) {
    final profiles = loadAllProfiles();
    return profiles.where((p) => p.id == id).firstOrNull;
  }

  // ========== ONBOARDING ==========

  /// Save onboarding completion status
  static Future<void> saveOnboardingComplete(bool complete) async {
    _warnIfNotInitialized('saveOnboardingComplete');
    final box = _settingsBox;
    if (box == null) return;

    await box.put(_onboardingKey, complete);
  }

  /// Load onboarding completion status
  /// Returns false if there's no valid user profile (to force onboarding)
  static bool loadOnboardingComplete() {
    _warnIfNotInitialized('loadOnboardingComplete');
    final box = _settingsBox;
    if (box == null) return false;

    final isComplete =
        box.get(_onboardingKey, defaultValue: false) as bool? ?? false;

    // If onboarding is marked complete but there's no valid profile, reset it
    if (isComplete) {
      final profile = loadUserProfile();
      if (profile == null) {
        // Reset onboarding flag since profile is invalid
        box.put(_onboardingKey, false);
        return false;
      }
    }

    return isComplete;
  }

  // ========== DISCLAIMER ==========

  /// Save disclaimer accepted status
  static Future<void> saveDisclaimerAccepted(bool accepted) async {
    _warnIfNotInitialized('saveDisclaimerAccepted');
    final box = _settingsBox;
    if (box == null) return;

    await box.put(_disclaimerKey, accepted);
  }

  /// Load disclaimer accepted status
  static bool loadDisclaimerAccepted() {
    _warnIfNotInitialized('loadDisclaimerAccepted');
    final box = _settingsBox;
    if (box == null) return false;

    return box.get(_disclaimerKey, defaultValue: false) as bool? ?? false;
  }

  // ========== LANGUAGE ==========

  /// Save selected language (uses SharedPreferences on web, Hive on mobile)
  static Future<void> saveLanguage(AppLanguage language) async {
    // Web: use SharedPreferences (wraps localStorage)
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_languageKey, language.index);
      } catch (e) {
        if (kDebugMode) debugPrint('Web language save error: $e');
      }
      return;
    }

    // Mobile: use Hive
    _warnIfNotInitialized('saveLanguage');
    final box = _settingsBox;
    if (box == null) return;

    await box.put(_languageKey, language.index);
  }

  /// Load selected language (uses SharedPreferences on web, Hive on mobile)
  /// Default: English (AppLanguage.en)
  static AppLanguage loadLanguage() {
    // Note: Web uses async version loadLanguageAsync() for SharedPreferences
    // This sync version is for mobile only
    if (kIsWeb) {
      return AppLanguage.en; // Default to English, actual value loaded async
    }

    // Mobile: use Hive
    _warnIfNotInitialized('loadLanguage');
    final box = _settingsBox;
    if (box == null) return AppLanguage.en;

    final index =
        box.get(_languageKey, defaultValue: AppLanguage.en.index) as int? ??
        AppLanguage.en.index;
    if (index >= 0 && index < AppLanguage.values.length) {
      return AppLanguage.values[index];
    }
    return AppLanguage.en;
  }

  /// Async version of loadLanguage for web platform
  static Future<AppLanguage> loadLanguageAsync() async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final index = prefs.getInt(_languageKey) ?? AppLanguage.en.index;
        if (index >= 0 && index < AppLanguage.values.length) {
          return AppLanguage.values[index];
        }
      } catch (e) {
        if (kDebugMode) debugPrint('Web language load error: $e');
      }
      return AppLanguage.en;
    }
    return loadLanguage();
  }

  // ========== THEME MODE ==========

  /// Save theme mode
  static Future<void> saveThemeMode(ThemeMode mode) async {
    _warnIfNotInitialized('saveThemeMode');
    final box = _settingsBox;
    if (box == null) return;

    await box.put(_themeModeKey, mode.index);
  }

  /// Load theme mode (defaults to dark)
  static ThemeMode loadThemeMode() {
    _warnIfNotInitialized('loadThemeMode');
    final box = _settingsBox;
    if (box == null) return ThemeMode.dark;

    final index =
        box.get(_themeModeKey, defaultValue: ThemeMode.dark.index) as int? ??
        ThemeMode.dark.index;
    if (index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.dark;
  }

  // ========== CLEAR ALL DATA ==========

  /// Clear all stored data (Hive boxes + SharedPreferences)
  /// Required for App Store compliance: "Clear Data" must remove ALL user data
  static Future<void> clearAllData() async {
    await _profileBox?.clear();
    await _settingsBox?.clear();
    // Also clear SharedPreferences (journal entries, dreams, moods, etc.)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
