import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/router_service.dart';
import 'shared/widgets/interpretive_text.dart';
import 'data/services/ad_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/admin_auth_service.dart';
import 'data/services/admin_analytics_service.dart';
import 'data/providers/app_providers.dart';
import 'data/models/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // On web, the file is served from assets/.env
  await dotenv.load(fileName: 'assets/.env');

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase with values from .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? 'https://placeholder.supabase.co',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'placeholder-key',
  );

  // Initialize Crashlytics (mobile only)
  if (!kIsWeb) {
    // Pass all uncaught Flutter errors to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught async errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Disable collection in debug mode
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  // Initialize glossary cache for fast term lookups
  GlossaryCache().initialize();

  // Initialize local storage
  await StorageService.initialize();

  // Initialize admin services
  await AdminAuthService.initialize();
  await AdminAnalyticsService.initialize();

  // Load saved settings
  final savedLanguage = StorageService.loadLanguage();
  final savedThemeMode = StorageService.loadThemeMode();
  final savedOnboardingComplete = StorageService.loadOnboardingComplete();
  final savedProfile = StorageService.loadUserProfile();

  // Initialize notifications (only on mobile platforms)
  if (!kIsWeb) {
    await NotificationService().initialize();
  }

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
      child: const Venus OneApp(),
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

class Venus OneApp extends ConsumerWidget {
  const Venus OneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Venus One',
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
