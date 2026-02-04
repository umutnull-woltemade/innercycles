import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/app_providers.dart';
import 'storage_service.dart';

/// Service to synchronize language preference between iOS and Web via Supabase
class LanguageSyncService {
  static const String _languageColumn = 'preferred_language';

  /// Get Supabase client
  static SupabaseClient get _supabase => Supabase.instance.client;

  /// Check if user is logged in
  static bool get isLoggedIn => _supabase.auth.currentUser != null;

  /// Get current user ID
  static String? get userId => _supabase.auth.currentUser?.id;

  /// Sync language preference from Supabase on login
  /// Returns the synced language or null if no preference is stored
  static Future<AppLanguage?> syncFromCloud() async {
    if (!isLoggedIn) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select(_languageColumn)
          .eq('id', userId!)
          .maybeSingle();

      if (response != null && response[_languageColumn] != null) {
        final langCode = response[_languageColumn] as String;
        final language = _parseLanguageCode(langCode);
        if (language != null) {
          // Save to local storage
          await StorageService.saveLanguage(language);
          return language;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LanguageSyncService.syncFromCloud error: $e');
      }
    }
    return null;
  }

  /// Save language preference to Supabase
  static Future<void> syncToCloud(AppLanguage language) async {
    if (!isLoggedIn) return;

    try {
      await _supabase.from('profiles').upsert({
        'id': userId,
        _languageColumn: language.name,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');

      if (kDebugMode) {
        debugPrint('LanguageSyncService: Synced ${language.name} to cloud');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LanguageSyncService.syncToCloud error: $e');
      }
    }
  }

  /// Handle language change - save locally and sync to cloud
  static Future<void> onLanguageChanged(AppLanguage language) async {
    // Always save locally first
    await StorageService.saveLanguage(language);

    // Sync to cloud if logged in
    if (isLoggedIn) {
      await syncToCloud(language);
    }
  }

  /// Handle login - sync language preference from cloud
  /// Returns the synced language or the current local language
  static Future<AppLanguage> onLogin() async {
    // Try to get cloud preference
    final cloudLanguage = await syncFromCloud();
    if (cloudLanguage != null) {
      return cloudLanguage;
    }

    // If no cloud preference, sync local preference to cloud
    final localLanguage = await StorageService.loadLanguageAsync();
    await syncToCloud(localLanguage);
    return localLanguage;
  }

  /// Parse language code string to AppLanguage enum
  static AppLanguage? _parseLanguageCode(String code) {
    try {
      return AppLanguage.values.firstWhere(
        (lang) => lang.name == code,
        orElse: () => AppLanguage.en,
      );
    } catch (e) {
      return null;
    }
  }
}
