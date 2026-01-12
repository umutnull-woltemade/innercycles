import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/router_service.dart';
import 'data/services/ad_service.dart';
import 'data/services/storage_service.dart';
import 'data/providers/app_providers.dart';
import 'data/models/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await StorageService.initialize();

  // Load saved settings
  final savedLanguage = StorageService.loadLanguage();
  final savedThemeMode = StorageService.loadThemeMode();
  final savedOnboardingComplete = StorageService.loadOnboardingComplete();
  final savedProfile = StorageService.loadUserProfile();

  // Initialize ads (only on mobile platforms)
  if (!kIsWeb) {
    final adService = AdService();
    await adService.initialize();
  }

  runApp(
    ProviderScope(
      overrides: [
        languageProvider.overrideWith((ref) => savedLanguage),
        themeModeProvider.overrideWith((ref) => savedThemeMode),
        onboardingCompleteProvider.overrideWith((ref) => savedOnboardingComplete),
        if (savedProfile != null)
          userProfileProvider.overrideWith(() => _InitializedUserProfileNotifier(savedProfile)),
      ],
      child: const CelestialApp(),
    ),
  );
}

/// Notifier that starts with an initial profile
class _InitializedUserProfileNotifier extends UserProfileNotifier {
  final UserProfile _initialProfile;

  _InitializedUserProfileNotifier(this._initialProfile);

  @override
  UserProfile? build() => _initialProfile;
}

class CelestialApp extends ConsumerWidget {
  const CelestialApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Celestial',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      locale: language.locale,
      supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Apply RTL direction for Arabic
        return Directionality(
          textDirection: language.isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
