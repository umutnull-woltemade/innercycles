import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../providers/app_providers.dart';
import 'package:flutter/material.dart';

/// Local storage service using Hive for persisting user data
class StorageService {
  static const String _userProfileBoxName = 'user_profile_box';
  static const String _settingsBoxName = 'settings_box';

  static const String _profileKey = 'user_profile';
  static const String _onboardingKey = 'onboarding_complete';
  static const String _languageKey = 'app_language';
  static const String _themeModeKey = 'theme_mode';

  static Box? _profileBox;
  static Box? _settingsBox;

  /// Initialize Hive and open boxes
  static Future<void> initialize() async {
    await Hive.initFlutter();
    _profileBox = await Hive.openBox(_userProfileBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // ========== USER PROFILE ==========

  /// Save user profile to local storage
  static Future<void> saveUserProfile(UserProfile profile) async {
    final box = _profileBox;
    if (box == null) return;

    final json = jsonEncode(profile.toJson());
    await box.put(_profileKey, json);
  }

  /// Load user profile from local storage
  static UserProfile? loadUserProfile() {
    final box = _profileBox;
    if (box == null) return null;

    final json = box.get(_profileKey) as String?;
    if (json == null) return null;

    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Delete user profile from local storage
  static Future<void> deleteUserProfile() async {
    final box = _profileBox;
    if (box == null) return;

    await box.delete(_profileKey);
  }

  // ========== ONBOARDING ==========

  /// Save onboarding completion status
  static Future<void> saveOnboardingComplete(bool complete) async {
    final box = _settingsBox;
    if (box == null) return;

    await box.put(_onboardingKey, complete);
  }

  /// Load onboarding completion status
  static bool loadOnboardingComplete() {
    final box = _settingsBox;
    if (box == null) return false;

    return box.get(_onboardingKey, defaultValue: false) as bool;
  }

  // ========== LANGUAGE ==========

  /// Save selected language
  static Future<void> saveLanguage(AppLanguage language) async {
    final box = _settingsBox;
    if (box == null) return;

    await box.put(_languageKey, language.index);
  }

  /// Load selected language
  static AppLanguage loadLanguage() {
    final box = _settingsBox;
    if (box == null) return AppLanguage.tr;

    final index = box.get(_languageKey, defaultValue: AppLanguage.tr.index) as int;
    if (index >= 0 && index < AppLanguage.values.length) {
      return AppLanguage.values[index];
    }
    return AppLanguage.tr;
  }

  // ========== THEME MODE ==========

  /// Save theme mode
  static Future<void> saveThemeMode(ThemeMode mode) async {
    final box = _settingsBox;
    if (box == null) return;

    await box.put(_themeModeKey, mode.index);
  }

  /// Load theme mode (defaults to dark)
  static ThemeMode loadThemeMode() {
    final box = _settingsBox;
    if (box == null) return ThemeMode.dark;

    final index = box.get(_themeModeKey, defaultValue: ThemeMode.dark.index) as int;
    if (index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.dark;
  }

  // ========== CLEAR ALL DATA ==========

  /// Clear all stored data
  static Future<void> clearAllData() async {
    await _profileBox?.clear();
    await _settingsBox?.clear();
  }
}
