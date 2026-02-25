import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'shared/services/router_service.dart';
import 'shared/widgets/app_error_widget.dart';
import 'data/services/ad_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/notification_lifecycle_service.dart';
import 'data/services/daily_hook_service.dart';
import 'data/services/journal_service.dart';
import 'data/services/admin_auth_service.dart';
import 'data/services/admin_analytics_service.dart';
import 'data/services/analytics_service.dart';
import 'data/services/web_error_service.dart';
import 'data/services/l10n_service.dart';
import 'data/services/sync_service.dart';
import 'data/services/data_migration_service.dart';
import 'data/services/birthday_contact_service.dart';
import 'data/services/error_reporting_service.dart';
import 'data/services/paywall_experiment_service.dart';
import 'data/services/telemetry_service.dart';
import 'data/services/progressive_unlock_service.dart';
import 'data/providers/app_providers.dart';
import 'data/services/premium_service.dart';
import 'data/models/user_profile.dart';
// cosmic_loading_indicator import removed — loading states use basic widgets
// to avoid requiring MaterialApp ancestor before InnerCyclesApp mounts.

// ═══════════════════════════════════════════════════════════════════════════
// SAFE STARTUP PATTERN - Prevents white screen on Flutter Web
// Key: runApp() is called IMMEDIATELY, async init happens INSIDE widget tree
// ═══════════════════════════════════════════════════════════════════════════

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup error handling FIRST
  _setupGlobalErrorHandling();

  // Run app IMMEDIATELY - NO async before this point
  // This ensures Flutter Web always renders something
  runApp(const BootstrapApp());
}

// ═══════════════════════════════════════════════════════════════════════════
// BOOTSTRAP APP - Crash-proof entry point
// ═══════════════════════════════════════════════════════════════════════════

class BootstrapApp extends StatelessWidget {
  const BootstrapApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Minimal wrapper — NO MaterialApp here.
    // InnerCyclesApp provides the single MaterialApp.router.
    return Theme(
      data: AppTheme.dark,
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: AppInitializer(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// APP INITIALIZER - Handles all async init with FutureBuilder
// ═══════════════════════════════════════════════════════════════════════════

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<_InitResult> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeApp();
  }

  Future<_InitResult> _initializeApp() async {
    if (kDebugMode) {
      debugPrint('🚀 InnerCycles: Starting initialization...');
    }

    // Load .env (optional - may not exist on web)
    try {
      await dotenv.load(fileName: 'assets/.env');
      if (kDebugMode) {
        debugPrint('✓ Environment variables loaded');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Warning: Could not load .env file: $e');
      }
    }

    // Initialize Supabase (ALL PLATFORMS)
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

      if (supabaseUrl.isNotEmpty && !supabaseUrl.contains('placeholder')) {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseKey,
          authOptions: const FlutterAuthClientOptions(
            authFlowType: AuthFlowType.pkce,
          ),
          // Deep link for Apple Sign In callback (iOS native)
          // Uses bundle ID as scheme: com.venusone.innercycles://
        ).timeout(
          const Duration(seconds: 15),
        ); // Extended for iPad/slow networks
        if (kDebugMode) {
          debugPrint('✓ Supabase initialized');
        }
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ Supabase: No valid URL configured');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Supabase initialization failed: $e');
      }
    }

    // Initialize analytics (after Supabase so it can detect the connection)
    try {
      await AnalyticsService().initialize();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AnalyticsService init failed: $e');
      }
    }

    // Initialize error reporting service
    try {
      await ErrorReportingService.initialize();
      if (kDebugMode) {
        debugPrint('✓ ErrorReportingService initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ ErrorReportingService init failed: $e');
      }
    }

    // Glossary cache disabled for 4.3(b) compliance
    // if (!kIsWeb) {
    //   Future.microtask(() => GlossaryCache().initialize());
    // }

    // Initialize storage
    try {
      await StorageService.initialize().timeout(const Duration(seconds: 5));
      if (kDebugMode) {
        debugPrint('✓ Storage initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Storage initialization failed: $e');
      }
    }

    // Initialize admin services (MOBILE ONLY)
    if (!kIsWeb) {
      try {
        await AdminAuthService.initialize().timeout(const Duration(seconds: 5));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ AdminAuthService init failed: $e');
        }
      }
      try {
        await AdminAnalyticsService.initialize().timeout(
          const Duration(seconds: 5),
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ AdminAnalyticsService init failed: $e');
        }
      }
    }

    // Load saved settings
    var savedLanguage = StorageService.loadLanguage();
    final savedThemeMode = StorageService.loadThemeMode();
    final savedOnboardingComplete = StorageService.loadOnboardingComplete();
    final savedProfile = StorageService.loadUserProfile();

    // Ensure language is supported
    if (!L10nService.supportedLanguages.contains(savedLanguage)) {
      savedLanguage = AppLanguage.en;
      StorageService.saveLanguage(savedLanguage);
    }

    // Initialize L10nService
    try {
      await L10nService.init(savedLanguage);
      if (kDebugMode) {
        debugPrint('✓ L10nService initialized for ${savedLanguage.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ L10nService failed for ${savedLanguage.name}: $e');
      }
      // Fallback to English
      try {
        await L10nService.init(AppLanguage.en);
        savedLanguage = AppLanguage.en;
        if (kDebugMode) {
          debugPrint('✓ L10nService fallback to English');
        }
      } catch (e2) {
        if (kDebugMode) {
          debugPrint('⚠️ L10nService English fallback also failed: $e2');
        }
      }
    }

    // Initialize notifications (MOBILE ONLY)
    if (!kIsWeb) {
      try {
        await NotificationService().initialize();

        // Refresh daily notification with personalized hook message
        final notifService = NotificationService();
        final isDailyEnabled = await notifService.isDailyReflectionEnabled();
        if (isDailyEnabled) {
          final dailyTime = await notifService.getDailyReflectionTime();
          if (dailyTime != null) {
            final hookService = await DailyHookService.init();
            final isEnglish = savedLanguage == AppLanguage.en;
            final hookMessage = hookService.getMorningHook(
              isEnglish: isEnglish,
            );
            await notifService.scheduleDailyReflection(
              hour: dailyTime.hour,
              minute: dailyTime.minute,
              personalizedMessage: hookMessage,
            );
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ NotificationService init failed: $e');
        }
      }

      // Reschedule birthday notifications on app launch
      try {
        final birthdayService = await BirthdayContactService.init();
        final allContacts = birthdayService.getAllContacts();
        if (allContacts.isNotEmpty) {
          await NotificationService().rescheduleAllBirthdayNotifications(
            allContacts,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ Birthday notification reschedule failed: $e');
        }
      }

      // Initialize notification lifecycle service (MOBILE ONLY)
      try {
        final lifecycleService = await NotificationLifecycleService.init();
        final journalService = await JournalService.init();
        await lifecycleService
            .recordActivity(); // Record app open for re-engagement timer
        await lifecycleService.evaluate(journalService);
        if (kDebugMode) {
          debugPrint('✓ NotificationLifecycleService initialized');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ NotificationLifecycleService init failed: $e');
        }
      }
    }

    // Initialize ads (MOBILE ONLY) — ATT is now requested inside AdService
    // only for free-tier users, right before first ad load
    if (!kIsWeb) {
      try {
        final adService = AdService();
        await adService.initialize();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ AdService init failed: $e');
        }
      }
    }

    // Initialize sync service (MOBILE ONLY - web uses session storage)
    if (!kIsWeb) {
      try {
        await SyncService.initialize();
        SyncService.registerMergeHandler(
          'user_profiles',
          StorageService.mergeRemoteProfiles,
        );
        if (kDebugMode) {
          debugPrint('✓ SyncService initialized');
        }

        // Run one-time data migration if user is logged in
        // (only if Supabase was initialized — requires valid URL in .env)
        try {
          final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
          final currentUser =
              (supabaseUrl.isNotEmpty && !supabaseUrl.contains('placeholder'))
              ? Supabase.instance.client.auth.currentUser
              : null;
          if (currentUser != null &&
              await DataMigrationService.needsMigration()) {
            if (kDebugMode) {
              debugPrint('🔄 Starting data migration to Supabase...');
            }
            final result = await DataMigrationService.migrateAllLocalData(
              userId: currentUser.id,
              onProgress: (current, total, table) {
                if (kDebugMode) {
                  debugPrint('  Migration ($current/$total): $table');
                }
              },
            );
            if (kDebugMode) {
              debugPrint(
                '✓ Data migration complete: ${result.migrated} records'
                '${result.hasErrors ? ', ${result.errors.length} errors' : ''}',
              );
            }
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ DataMigration failed: $e');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ SyncService init failed: $e');
        }
      }
    }

    // Initialize paywall experiment and increment session
    try {
      final experiment = await PaywallExperimentService.init();
      experiment.incrementSession();
      if (kDebugMode) {
        debugPrint(
          '✓ PaywallExperiment: pricing=${experiment.pricingVariant.name}, '
          'timing=${experiment.timingVariant.name}, '
          'session=${experiment.sessionCount}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ PaywallExperimentService init failed: $e');
      }
    }

    // Initialize telemetry service
    TelemetryService? telemetryInstance;
    try {
      telemetryInstance = await TelemetryService.init();
      await telemetryInstance.appOpened(
        sessionCount: telemetryInstance.sessionCount,
      );
      if (kDebugMode) {
        debugPrint(
          '✓ TelemetryService initialized (session #${telemetryInstance.sessionCount})',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ TelemetryService init failed: $e');
      }
    }

    // Initialize progressive unlock service
    try {
      final unlockService = await ProgressiveUnlockService.init();
      if (kDebugMode) {
        debugPrint(
          '✓ ProgressiveUnlockService: ${unlockService.entryCount} entries, '
          '${unlockService.nextUnlockMessage}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ ProgressiveUnlockService init failed: $e');
      }
    }

    if (kDebugMode) {
      debugPrint('✅ InnerCycles: Initialization complete!');
    }

    return _InitResult(
      language: savedLanguage,
      themeMode: savedThemeMode,
      onboardingComplete: savedOnboardingComplete,
      profile: savedProfile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_InitResult>(
      future: _initFuture,
      builder: (context, snapshot) {
        // LOADING STATE - Always show visible UI
        // Uses Container (not Scaffold) to avoid needing MaterialApp ancestor.
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: AppColors.deepSpace,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: AppColors.starGold,
                      strokeWidth: 2.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'InnerCycles',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ERROR STATE - Show error message (never white screen)
        // Uses Container (not Scaffold) to avoid needing MaterialApp ancestor.
        if (snapshot.hasError) {
          return Container(
            color: AppColors.deepSpace,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.warning,
                      size: 64,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'InnerCycles',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // SUCCESS - Launch the real app with providers
        if (snapshot.data == null) {
          return Container(
            color: AppColors.deepSpace,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.starGold,
                strokeWidth: 2.5,
              ),
            ),
          );
        }
        final result = snapshot.data!;

        if (kDebugMode) {
          debugPrint('🎨 Launching InnerCycles with providers...');
        }

        return ProviderScope(
          overrides: [
            languageProvider.overrideWith((ref) => result.language),
            themeModeProvider.overrideWith((ref) => result.themeMode),
            onboardingCompleteProvider.overrideWith(
              (ref) => result.onboardingComplete,
            ),
            if (result.profile != null)
              userProfileProvider.overrideWith(
                () => _InitializedUserProfileNotifier(result.profile!),
              ),
          ],
          child: const InnerCyclesApp(),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INIT RESULT - Holds all initialization results
// ═══════════════════════════════════════════════════════════════════════════

class _InitResult {
  final AppLanguage language;
  final ThemeMode themeMode;
  final bool onboardingComplete;
  final UserProfile? profile;

  _InitResult({
    required this.language,
    required this.themeMode,
    required this.onboardingComplete,
    this.profile,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
// NOTIFIER FOR INITIAL PROFILE
// ═══════════════════════════════════════════════════════════════════════════

class _InitializedUserProfileNotifier extends UserProfileNotifier {
  final UserProfile _initialProfile;

  _InitializedUserProfileNotifier(this._initialProfile);

  @override
  UserProfile? build() => _initialProfile;
}

// ═══════════════════════════════════════════════════════════════════════════
// INNERCYCLES APP - Main app widget
// ═══════════════════════════════════════════════════════════════════════════

class InnerCyclesApp extends ConsumerStatefulWidget {
  const InnerCyclesApp({super.key});

  @override
  ConsumerState<InnerCyclesApp> createState() => _InnerCyclesAppState();
}

class _InnerCyclesAppState extends ConsumerState<InnerCyclesApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Set global error widget builder ONCE (not on every rebuild)
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return AppErrorWidget(details: details);
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-verify premium entitlement when returning from background
      ref.read(premiumProvider.notifier).onAppResumed();
      // Trigger full sync (push pending + pull remote changes)
      SyncService.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'InnerCycles',
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

// ═══════════════════════════════════════════════════════════════════════════
// GLOBAL ERROR HANDLING
// ═══════════════════════════════════════════════════════════════════════════

void _setupGlobalErrorHandling() {
  // Catch all synchronous Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('FLUTTER ERROR CAUGHT:');
      debugPrint('${details.exception}');
      debugPrint('═══════════════════════════════════════════════════════════');
    }

    // Report to ErrorReportingService (Supabase + Slack)
    ErrorReportingService.handleFlutterError(details);

    // Also log to web console if on web
    if (kIsWeb) {
      WebErrorService().logError(details.exception.toString());
    }

    FlutterError.presentError(details);
  };

  // Catch all asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════════════════════════');
      debugPrint('ASYNC ERROR CAUGHT:');
      debugPrint('$error');
      debugPrint('Stack: $stack');
      debugPrint('═══════════════════════════════════════════════════════════');
    }

    // Report to ErrorReportingService (Supabase + Slack)
    ErrorReportingService.handleAsyncError(error, stack);

    // Also log to web console if on web
    if (kIsWeb) {
      WebErrorService().logError(error.toString());
    }

    return true;
  };

  if (kDebugMode) {
    debugPrint('✓ Global error handling initialized');
  }
}
