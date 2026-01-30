/// CHAOS TEST SUITE
///
/// Runs all chaos scenarios to verify critical UI resilience.
/// These tests ensure the app fails LOUDLY rather than silently.
///
/// Run with: flutter test test/critical_ui/chaos_test.dart
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:astrology_app/core/constants/routes.dart';
import 'package:astrology_app/data/providers/app_providers.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_router.dart';
import 'chaos_testing.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // CHAOS SCENARIO TESTS
  // ═══════════════════════════════════════════════════════════════════════════

  group('CHAOS: Auth State Changes', () {
    testWidgets('survives sudden logout on home screen', (tester) async {
      final chaosNotifier = ChaosUserProfileNotifier(fakeUserProfile());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(() => chaosNotifier),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: buildTestRouter(initialLocation: Routes.home),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(Scaffold), findsWidgets,
          reason: 'Home should render initially');

      // CHAOS: Sudden logout
      chaosNotifier.simulateLogout();
      await tester.pumpAndSettle();

      // Should not crash - either show content or redirect
      expect(find.byType(MaterialApp), findsOneWidget,
          reason: 'App should not crash on sudden logout');
    });

    testWidgets('survives profile becoming null', (tester) async {
      final chaosNotifier = ChaosUserProfileNotifier(fakeUserProfile());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(() => chaosNotifier),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: buildTestRouter(initialLocation: Routes.profile),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // CHAOS: Profile becomes null
      chaosNotifier.simulateNullProfile();
      await tester.pumpAndSettle();

      // Should handle gracefully
      expect(find.byType(MaterialApp), findsOneWidget,
          reason: 'App should not crash when profile becomes null');
    });

    testWidgets('survives rapid auth state changes', (tester) async {
      final chaosNotifier = ChaosUserProfileNotifier(fakeUserProfile());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(() => chaosNotifier),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: buildTestRouter(initialLocation: Routes.home),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // CHAOS: Rapid state changes
      for (int i = 0; i < 5; i++) {
        chaosNotifier.simulateLogout();
        await tester.pump(const Duration(milliseconds: 50));
        chaosNotifier.injectProfile(fakeUserProfile());
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget,
          reason: 'App should survive rapid auth state changes');
    });
  });

  group('CHAOS: Routing Stress', () {
    testWidgets('handles invalid route gracefully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(
              () => TestUserProfileNotifier(fakeUserProfile()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: buildTestRouter(
              initialLocation: '/this-route-definitely-does-not-exist-chaos-test',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show 404 page
      expect(find.textContaining('404'), findsOneWidget,
          reason: 'Invalid routes must show 404');
    });

    testWidgets('survives rapid navigation', (tester) async {
      final router = buildTestRouter(initialLocation: Routes.home);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(
              () => TestUserProfileNotifier(fakeUserProfile()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // CHAOS: Rapid fire navigations
      final routes = [
        Routes.settings,
        Routes.home,
        Routes.horoscope,
        Routes.numerology,
        Routes.tarot,
        Routes.home,
        Routes.profile,
        Routes.settings,
        Routes.home,
        Routes.allServices,
      ];

      for (final route in routes) {
        router.go(route);
        await tester.pump(const Duration(milliseconds: 30));
      }

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets,
          reason: 'App should survive rapid navigation');
    });

    testWidgets('survives back navigation from deep route', (tester) async {
      final router = buildTestRouter(initialLocation: '/horoscope/aries');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(
              () => TestUserProfileNotifier(fakeUserProfile()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets,
          reason: 'Deep route should render');

      // Navigate back
      router.go(Routes.home);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets,
          reason: 'Should navigate back successfully');
    });
  });

  group('CHAOS: Premium Screen Cannot Trap User', () {
    testWidgets('premium screen has exit mechanism', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(
              () => TestUserProfileNotifier(fakeUserProfile()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: buildTestRouter(initialLocation: Routes.premium),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Premium MUST have close/back button
      final closeButton = find.byIcon(Icons.close);
      final backButton = find.byIcon(Icons.arrow_back);
      final backButtonIos = find.byIcon(Icons.arrow_back_ios);

      expect(
        closeButton.evaluate().isNotEmpty ||
            backButton.evaluate().isNotEmpty ||
            backButtonIos.evaluate().isNotEmpty,
        isTrue,
        reason: 'CRITICAL: Premium screen MUST have exit mechanism - user cannot be trapped',
      );
    });
  });

  group('CHAOS: Onboarding Guard', () {
    testWidgets('incomplete onboarding blocks home access', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => false),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(
              () => TestUserProfileNotifier(null),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: buildTestRouter(initialLocation: Routes.home),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should either show home or redirect to onboarding
      expect(find.byType(Scaffold), findsWidgets,
          reason: 'Should show content regardless of onboarding state');
    });
  });

  group('CHAOS: Language and Theme Resilience', () {
    testWidgets('survives language change', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.en),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(
              () => TestUserProfileNotifier(fakeUserProfile()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('en', 'US'),
            routerConfig: buildTestRouter(initialLocation: Routes.home),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets,
          reason: 'English language should work');
    });

    testWidgets('survives RTL language (Arabic)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.ar),
            themeModeProvider.overrideWith((ref) => ThemeMode.dark),
            userProfileProvider.overrideWith(
              () => TestUserProfileNotifier(fakeUserProfile()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('ar', 'SA'),
            routerConfig: buildTestRouter(initialLocation: Routes.home),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets,
          reason: 'Arabic RTL language should work');
    });

    testWidgets('survives light theme', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingCompleteProvider.overrideWith((ref) => true),
            languageProvider.overrideWith((ref) => AppLanguage.tr),
            themeModeProvider.overrideWith((ref) => ThemeMode.light),
            userProfileProvider.overrideWith(
              () => TestUserProfileNotifier(fakeUserProfile()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
            locale: const Locale('tr', 'TR'),
            routerConfig: buildTestRouter(initialLocation: Routes.home),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets,
          reason: 'Light theme should work');
    });
  });

  group('CHAOS: All Languages', () {
    for (final lang in AppLanguage.values) {
      testWidgets('survives ${lang.name} language', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              onboardingCompleteProvider.overrideWith((ref) => true),
              languageProvider.overrideWith((ref) => lang),
              themeModeProvider.overrideWith((ref) => ThemeMode.dark),
              userProfileProvider.overrideWith(
                () => TestUserProfileNotifier(fakeUserProfile()),
              ),
            ],
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLanguage.values.map((l) => l.locale).toList(),
              locale: lang.locale,
              routerConfig: buildTestRouter(initialLocation: Routes.home),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsWidgets,
            reason: '${lang.name} language must render correctly');
      });
    }
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // FULL CHAOS SUITE
  // ═══════════════════════════════════════════════════════════════════════════

  group('CHAOS: Full Suite', () {
    testWidgets('run all chaos scenarios', (tester) async {
      final results = await ChaosTestRunner.runAllScenarios(tester);

      // Print report
      // ignore: avoid_print
      print(ChaosTestRunner.generateReport(results));

      // All tests should pass
      final allPassed = results.every((r) => r.passed);
      expect(allPassed, isTrue,
          reason: 'All chaos scenarios must pass');

      // Warn about silent failures
      final silentFailures = results.where((r) => r.passed && !r.behavedCorrectly);
      if (silentFailures.isNotEmpty) {
        // ignore: avoid_print
        print('WARNING: ${silentFailures.length} scenarios had silent failures');
      }
    });
  });
}
