// ════════════════════════════════════════════════════════════════════════════
// APP PROVIDERS - Core State Management (App Store 4.3(b) Compliant)
// ════════════════════════════════════════════════════════════════════════════
// All legacy providers have been removed for App Store compliance.
// This file now focuses on:
// - User profile management
// - Language settings
// - Theme settings
// - Dream journal
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/zodiac_sign.dart' as zodiac;

import '../services/storage_service.dart';
import '../services/dream_journal_service.dart';
import '../services/journal_service.dart';
import '../models/journal_entry.dart';

// =============================================================================
// USER PROFILE PROVIDERS
// =============================================================================

/// User profile state using Notifier (Riverpod 2.x+)
final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile?>(
  () {
    return UserProfileNotifier();
  },
);

class UserProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => null;

  void setProfile(UserProfile profile) {
    state = profile;
    _syncToStorage(profile);
  }

  void clearProfile() {
    state = null;
  }

  void updateBirthDate(DateTime date) {
    if (state != null) {
      final updated = state!.copyWith(
        birthDate: date,
        sunSign: zodiac.ZodiacSignExtension.fromDate(date),
      );
      state = updated;
      _syncToStorage(updated);
    }
  }

  void _syncToStorage(UserProfile profile) {
    StorageService.saveUserProfile(profile);
    ref.read(savedProfilesProvider.notifier).updateProfile(profile);
  }
}

/// Multiple profiles provider
final savedProfilesProvider =
    NotifierProvider<SavedProfilesNotifier, List<UserProfile>>(() {
      return SavedProfilesNotifier();
    });

class SavedProfilesNotifier extends Notifier<List<UserProfile>> {
  @override
  List<UserProfile> build() {
    return StorageService.loadAllProfiles();
  }

  Future<void> addProfile(UserProfile profile) async {
    await StorageService.saveProfile(profile);
    state = StorageService.loadAllProfiles();
  }

  Future<void> updateProfile(UserProfile profile) async {
    await StorageService.saveProfile(profile);
    state = StorageService.loadAllProfiles();
  }

  Future<void> removeProfile(String id) async {
    await StorageService.deleteProfile(id);
    state = StorageService.loadAllProfiles();
  }

  Future<void> setPrimary(String id) async {
    await StorageService.setPrimaryProfileId(id);
    final profiles = state.map((p) {
      return p.copyWith(isPrimary: p.id == id);
    }).toList();
    state = profiles;
  }

  void refresh() {
    state = StorageService.loadAllProfiles();
  }
}

/// Primary profile provider
final primaryProfileProvider = Provider<UserProfile?>((ref) {
  final profiles = ref.watch(savedProfilesProvider);
  final primaryId = StorageService.getPrimaryProfileId();

  if (primaryId != null) {
    final primary = profiles.where((p) => p.id == primaryId).firstOrNull;
    if (primary != null) return primary;
  }

  return profiles.isNotEmpty ? profiles.first : null;
});

/// Comparison profiles selection (for pattern comparison, not astrology)
final comparisonProfile1Provider = StateProvider<UserProfile?>((ref) => null);
final comparisonProfile2Provider = StateProvider<UserProfile?>((ref) => null);

// =============================================================================
// APP STATE PROVIDERS
// =============================================================================

/// Onboarding completed flag
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

/// Bottom navigation index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// =============================================================================
// LANGUAGE PROVIDER
// =============================================================================

enum AppLanguage {
  en, // English
  tr, // Türkçe
  el, // Ελληνικά (Greek)
  bg, // Български (Bulgarian)
  ru, // Русский (Russian)
  zh, // 中文 (Chinese)
  fr, // Français (French)
  de, // Deutsch (German)
  es, // Español (Spanish)
  ar, // العربية (Arabic - RTL)
}

extension AppLanguageExtension on AppLanguage {
  String get displayName {
    switch (this) {
      case AppLanguage.en:
        return 'English';
      case AppLanguage.tr:
        return 'Türkçe';
      case AppLanguage.el:
        return 'Ελληνικά';
      case AppLanguage.bg:
        return 'Български';
      case AppLanguage.ru:
        return 'Русский';
      case AppLanguage.zh:
        return '中文';
      case AppLanguage.fr:
        return 'Français';
      case AppLanguage.de:
        return 'Deutsch';
      case AppLanguage.es:
        return 'Español';
      case AppLanguage.ar:
        return 'العربية';
    }
  }

  String get flag {
    switch (this) {
      case AppLanguage.en:
        return '🇬🇧';
      case AppLanguage.tr:
        return '🇹🇷';
      case AppLanguage.el:
        return '🇬🇷';
      case AppLanguage.bg:
        return '🇧🇬';
      case AppLanguage.ru:
        return '🇷🇺';
      case AppLanguage.zh:
        return '🇨🇳';
      case AppLanguage.fr:
        return '🇫🇷';
      case AppLanguage.de:
        return '🇩🇪';
      case AppLanguage.es:
        return '🇪🇸';
      case AppLanguage.ar:
        return '🇸🇦';
    }
  }

  bool get isRTL => this == AppLanguage.ar;

  /// Languages with complete translations and strict isolation support
  bool get hasStrictIsolation {
    return this == AppLanguage.en ||
        this == AppLanguage.tr ||
        this == AppLanguage.de ||
        this == AppLanguage.fr;
  }

  /// Languages that are fully available for selection
  bool get isFullyAvailable => hasStrictIsolation;

  Locale get locale {
    switch (this) {
      case AppLanguage.en:
        return const Locale('en', 'US');
      case AppLanguage.tr:
        return const Locale('tr', 'TR');
      case AppLanguage.el:
        return const Locale('el', 'GR');
      case AppLanguage.bg:
        return const Locale('bg', 'BG');
      case AppLanguage.ru:
        return const Locale('ru', 'RU');
      case AppLanguage.zh:
        return const Locale('zh', 'CN');
      case AppLanguage.fr:
        return const Locale('fr', 'FR');
      case AppLanguage.de:
        return const Locale('de', 'DE');
      case AppLanguage.es:
        return const Locale('es', 'ES');
      case AppLanguage.ar:
        return const Locale('ar', 'SA');
    }
  }
}

final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.en);

// =============================================================================
// THEME PROVIDER
// =============================================================================

/// Theme mode provider - default is dark
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

// =============================================================================
// DREAM JOURNAL PROVIDER
// =============================================================================

/// Dream Journal Service provider - async initialization
final dreamJournalServiceProvider = FutureProvider<DreamJournalService>((
  ref,
) async {
  return await DreamJournalService.init();
});

// =============================================================================
// JOURNAL PROVIDERS (InnerCycles)
// =============================================================================

/// Journal Service provider - async initialization
final journalServiceProvider = FutureProvider<JournalService>((ref) async {
  return await JournalService.init();
});

/// Today's journal entry (null if not logged yet)
final todayJournalEntryProvider = FutureProvider<JournalEntry?>((ref) async {
  final service = await ref.watch(journalServiceProvider.future);
  return service.getTodayEntry();
});

/// Current streak count
final journalStreakProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(journalServiceProvider.future);
  return service.getCurrentStreak();
});
