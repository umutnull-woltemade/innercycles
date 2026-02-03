import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/router_service.dart';
import 'shared/widgets/interpretive_text.dart';
import 'shared/widgets/app_error_widget.dart';
import 'data/services/ad_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/admin_auth_service.dart';
import 'data/services/admin_analytics_service.dart';
import 'data/services/web_error_service.dart';
import 'data/services/l10n_service.dart';
import 'data/providers/app_providers.dart';
import 'data/models/user_profile.dart';

void main() async {
  // ═══════════════════════════════════════════════════════════════════════════
  // OUTER TRY-CATCH: Prevents white screen on ANY uncaught error
  // ═══════════════════════════════════════════════════════════════════════════
  try {
    await _initializeAndRunApp();
  } catch (e, stack) {
    debugPrint('❌ FATAL: App initialization failed: $e');
    debugPrint('Stack: $stack');
    // Run minimal fallback app to show SOMETHING instead of white screen
    _runFallbackApp(e.toString());
  }
}

Future<void> _initializeAndRunApp() async {
  if (kDebugMode) {
    debugPrint('🚀 Venus One: Starting initialization...');
  }

  WidgetsFlutterBinding.ensureInitialized();

  // ═══════════════════════════════════════════════════════════════════════════
  // GLOBAL ERROR HANDLING - Prevent white screen on ANY error
  // ═══════════════════════════════════════════════════════════════════════════
  _setupGlobalErrorHandling();

  if (kDebugMode) {
    debugPrint('✓ WidgetsBinding initialized');
  }

  // Load environment variables with error handling for web
  try {
    await dotenv.load(fileName: 'assets/.env');
    if (kDebugMode) {
      debugPrint('✓ Environment variables loaded');
    }
  } catch (e) {
    // On web, .env may not exist or be empty - continue with defaults
    if (kDebugMode) {
      debugPrint('⚠️ Warning: Could not load .env file: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WEB: Skip Supabase to prevent white screen
  // These services can throw uncaught errors on web due to IndexedDB/CORS issues
  // ═══════════════════════════════════════════════════════════════════════════

  // Initialize Supabase with values from .env (MOBILE ONLY)
  if (!kIsWeb) {
    if (kDebugMode) {
      debugPrint('⏳ Initializing Supabase (mobile)...');
    }
    try {
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL'] ?? 'https://placeholder.supabase.co',
        anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'placeholder-key',
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (kDebugMode) {
            debugPrint('⚠️ Warning: Supabase initialization timed out');
          }
          throw TimeoutException('Supabase timeout');
        },
      );
      if (kDebugMode) {
        debugPrint('✓ Supabase initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Warning: Supabase initialization failed: $e');
      }
    }
  } else {
    debugPrint('⚠️ Web: Skipping Supabase (prevents white screen)');
  }

  // Initialize glossary cache asynchronously (MOBILE ONLY)
  // Web'de 300+ terimlik regex JavaScript event loop'u blokluyor → beyaz ekran
  if (!kIsWeb) {
    Future.microtask(() => GlossaryCache().initialize());
  }

  // Initialize local storage with timeout for web
  if (kDebugMode) {
    debugPrint('⏳ Initializing Storage...');
  }
  try {
    await StorageService.initialize().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        if (kDebugMode) {
          debugPrint('⚠️ Warning: Storage initialization timed out');
        }
      },
    );
    if (kDebugMode) {
      debugPrint('✓ Storage initialized');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️ Warning: Storage initialization failed: $e');
    }
  }

  // Initialize admin services (mobile only - skip on web to prevent white screen)
  // Admin services use Hive.openBox() which can hang on web's IndexedDB or iOS simulator
  if (!kIsWeb) {
    try {
      await AdminAuthService.initialize().timeout(const Duration(seconds: 5));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AdminAuthService init failed/timeout: $e');
      }
    }
    try {
      await AdminAnalyticsService.initialize().timeout(const Duration(seconds: 5));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AdminAnalyticsService init failed/timeout: $e');
      }
    }
  } else {
    if (kDebugMode) {
      debugPrint('⚠️ Skipping admin services on web (prevents white screen)');
    }
  }

  // Load saved settings with defaults
  var savedLanguage = StorageService.loadLanguage();
  final savedThemeMode = StorageService.loadThemeMode();
  final savedOnboardingComplete = StorageService.loadOnboardingComplete();
  final savedProfile = StorageService.loadUserProfile();

  // Ensure saved language is supported with strict isolation
  // If not, default to English
  if (!L10nService.supportedLanguages.contains(savedLanguage)) {
    savedLanguage = AppLanguage.en;
    StorageService.saveLanguage(savedLanguage);
  }

  // Initialize L10nService with strict isolation (no fallback)
  if (!kIsWeb) {
    try {
      await L10nService.init(savedLanguage);
      if (kDebugMode) {
        debugPrint('✓ L10nService initialized for ${savedLanguage.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ L10nService initialization failed: $e');
      }
      // Fallback to English if locale load fails
      try {
        await L10nService.init(AppLanguage.en);
        savedLanguage = AppLanguage.en;
      } catch (_) {
        // Continue without localization
      }
    }
  }

  // Initialize notifications (only on mobile platforms)
  if (!kIsWeb) {
    await NotificationService().initialize();
  }

  // Initialize ads (only on mobile platforms)
  if (!kIsWeb) {
    final adService = AdService();
    await adService.initialize();
  }

  if (kDebugMode) {
    debugPrint('🎨 Starting Flutter app...');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WEB: Bypass ProviderScope and GoRouter - they cause white screen
  // Ultra-minimal test showed MaterialApp + Scaffold works
  // ═══════════════════════════════════════════════════════════════════════════
  if (kIsWeb) {
    // ignore: avoid_print
    print('🌐 WEB: Bypassing ProviderScope and GoRouter');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        ),
        home: Scaffold(
          backgroundColor: const Color(0xFF0D0D1A),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1a1a2e),
                  Color(0xFF0D0D1A),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 60),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  const Text(
                    'Venus One',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  const Text(
                    'Kozmik Yolculuğuna Başla',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Info text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Web versiyonu yakında! Şimdilik mobil uygulamayı indirin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // ignore: avoid_print
    print('✅ Venus One Web: App started!');
    return;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MOBILE: Full app with ProviderScope and GoRouter
  // ═══════════════════════════════════════════════════════════════════════════
  runApp(
    ProviderScope(
      overrides: [
        languageProvider.overrideWith((ref) => savedLanguage),
        themeModeProvider.overrideWith((ref) => savedThemeMode),
        onboardingCompleteProvider.overrideWith((ref) => savedOnboardingComplete),
        if (savedProfile != null)
          userProfileProvider.overrideWith(() => _InitializedUserProfileNotifier(savedProfile)),
      ],
      child: const VenusOneApp(),
    ),
  );

  if (kDebugMode) {
    debugPrint('✅ Venus One: Initialization complete!');
  }
}

/// Notifier that starts with an initial profile
class _InitializedUserProfileNotifier extends UserProfileNotifier {
  final UserProfile _initialProfile;

  _InitializedUserProfileNotifier(this._initialProfile);

  @override
  UserProfile? build() => _initialProfile;
}

class VenusOneApp extends ConsumerWidget {
  const VenusOneApp({super.key});

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
        // Set global error widget builder to prevent white screen
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return AppErrorWidget(details: details);
        };

        // Apply RTL direction for Arabic
        return Directionality(
          textDirection: language.isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// GLOBAL ERROR HANDLING SETUP
// ═══════════════════════════════════════════════════════════════════════════

/// Sets up global error handling to prevent white screens
/// This ensures ANY uncaught error shows a fallback UI instead of blank screen
void _setupGlobalErrorHandling() {
  // Catch all synchronous Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('FLUTTER ERROR CAUGHT (prevents white screen):');
      debugPrint('${details.exception}');
      debugPrint('═══════════════════════════════════════════════════════════');
    }

    // Log to analytics on web
    if (kIsWeb) {
      WebErrorService().logError(details.exception.toString());
    }

    // Present the error using Flutter's built-in mechanism
    FlutterError.presentError(details);
  };

  // Catch all asynchronous errors (Futures, Streams, etc.)
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('ASYNC ERROR CAUGHT (prevents white screen):');
      debugPrint('$error');
      debugPrint('Stack: $stack');
      debugPrint('═══════════════════════════════════════════════════════════');
    }

    // Log to analytics on web
    if (kIsWeb) {
      WebErrorService().logError(error.toString());
    }

    // Return true to indicate the error was handled
    return true;
  };

  if (kDebugMode) {
    debugPrint('✓ Global error handling initialized (white screen protection)');
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FALLBACK APP - Shows when initialization fails completely
// ═══════════════════════════════════════════════════════════════════════════
void _runFallbackApp(String errorMessage) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0D0D1A),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.amber,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Venus One',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Uygulama yüklenirken bir hata oluştu.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lütfen sayfayı yenileyin veya daha sonra tekrar deneyin.',
                    style: TextStyle(
                      color: Colors.white.withAlpha(120),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
