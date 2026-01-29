/// Integration tests that exercise real app navigation flows.
///
/// These tests use GoRouter with the production route table to verify
/// that navigation between screens works as expected.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:astrology_app/core/constants/routes.dart';
import 'package:astrology_app/data/providers/app_providers.dart';
import 'package:astrology_app/data/models/user_profile.dart';

import '../test/helpers/pump_app.dart';
import '../test/helpers/test_router.dart';

// ---------------------------------------------------------------------------
// Shared pump helper for integration tests
// ---------------------------------------------------------------------------
extension IntegrationPump on WidgetTester {
  Future<GoRouter> pumpAppWithRouter({
    String initialLocation = '/home',
    List<Override> overrides = const [],
  }) async {
    final profile = fakeUserProfile();
    final router = buildTestRouter(initialLocation: initialLocation);

    await pumpWidget(
      ProviderScope(
        overrides: [
          onboardingCompleteProvider.overrideWith((ref) => true),
          languageProvider.overrideWith((ref) => AppLanguage.tr),
          themeModeProvider.overrideWith((ref) => ThemeMode.dark),
          userProfileProvider.overrideWith(
            () => TestUserProfileNotifier(profile),
          ),
          savedProfilesProvider.overrideWith(
            () => _IntTestSavedProfiles([profile]),
          ),
          ...overrides,
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF7C4DFF),
              brightness: Brightness.dark,
            ),
          ),
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
    await pumpAndSettle();
    return router;
  }
}

class _IntTestSavedProfiles extends SavedProfilesNotifier {
  final List<UserProfile> _initial;
  _IntTestSavedProfiles(this._initial);

  @override
  List<UserProfile> build() => _initial;
}

// ---------------------------------------------------------------------------
// FLOW 1 — App launch → Home
// ---------------------------------------------------------------------------
void main() {
  group('Flow 1: App launch → Home', () {
    testWidgets('navigates to home and renders scaffold', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.home);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 2 — Onboarding entry
  // -------------------------------------------------------------------------
  group('Flow 2: Onboarding entry', () {
    testWidgets('onboarding screen loads when navigated to', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.onboarding);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 3 — Horoscope list → detail
  // -------------------------------------------------------------------------
  group('Flow 3: Horoscope list → detail via route', () {
    testWidgets('horoscope screen loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.horoscope);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('horoscope detail loads for aries', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/horoscope/aries');
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('horoscope detail loads for scorpio', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/horoscope/scorpio');
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 4 — Numerology hub → life path detail
  // -------------------------------------------------------------------------
  group('Flow 4: Numerology → Life Path detail', () {
    testWidgets('numerology hub loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.numerology);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('life path 7 loads via deep link', (tester) async {
      await tester.pumpAppWithRouter(
        initialLocation: '/numerology/life-path/7',
      );
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('master number 22 loads via deep link', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/numerology/master/22');
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('personal year 5 loads via deep link', (tester) async {
      await tester.pumpAppWithRouter(
        initialLocation: '/numerology/personal-year/5',
      );
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('karmic debt 16 loads via deep link', (tester) async {
      await tester.pumpAppWithRouter(
        initialLocation: '/numerology/karmic-debt/16',
      );
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 5 — Tarot hub → Major Arcana detail
  // -------------------------------------------------------------------------
  group('Flow 5: Tarot → Major Arcana detail', () {
    testWidgets('tarot hub loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.tarot);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('major arcana card 0 (The Fool) loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/tarot/major/0');
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('major arcana card 13 (Death) loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/tarot/major/13');
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 6 — Extended Horoscopes deep links
  // -------------------------------------------------------------------------
  group('Flow 6: Extended Horoscope deep links', () {
    testWidgets('weekly horoscope loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.weeklyHoroscope);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('weekly horoscope for leo loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/horoscope/weekly/leo');
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('monthly horoscope loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.monthlyHoroscope);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('yearly horoscope loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.yearlyHoroscope);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('love horoscope for pisces loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/horoscope/love/pisces');
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('eclipse calendar loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.eclipseCalendar);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 7 — Dream canonical pages (deep link capable)
  // -------------------------------------------------------------------------
  group('Flow 7: Dream canonical deep links', () {
    testWidgets('dream falling loads via /ruya/dusmek', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.dreamFalling);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('dream water loads via /ruya/su-gormek', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.dreamWater);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('dream flying loads via /ruya/ucmak', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.dreamFlying);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('dream lost loads via /ruya/kaybolmak', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.dreamLost);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('dream interpretation loads', (tester) async {
      await tester.pumpAppWithRouter(
        initialLocation: Routes.dreamInterpretation,
      );
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('dream oracle loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.ruyaDongusu);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 8 — Cosmic Discovery deep links
  // -------------------------------------------------------------------------
  group('Flow 8: Cosmic Discovery deep links', () {
    testWidgets('daily summary loads via /kesif/gunun-ozeti', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.dailySummary);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('cosmic today loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.cosmicToday);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 9 — Advanced Astrology deep links
  // -------------------------------------------------------------------------
  group('Flow 9: Advanced Astrology deep links', () {
    for (final route in [
      Routes.compositeChart,
      Routes.vedicChart,
      Routes.progressions,
      Routes.saturnReturn,
      Routes.solarReturn,
      Routes.yearAhead,
      Routes.synastry,
      Routes.astroCartography,
    ]) {
      testWidgets('$route loads scaffold', (tester) async {
        await tester.pumpAppWithRouter(initialLocation: route);
        expect(find.byType(Scaffold), findsWidgets);
      });
    }
  });

  // -------------------------------------------------------------------------
  // FLOW 10 — Profile & Settings
  // -------------------------------------------------------------------------
  group('Flow 10: Profile & Settings', () {
    testWidgets('profile screen loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.profile);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('saved profiles loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.savedProfiles);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('comparison screen loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.comparison);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('settings screen loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.settings);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 11 — Hub screens
  // -------------------------------------------------------------------------
  group('Flow 11: Hub screens', () {
    testWidgets('kozmoz hub loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.kozmoz);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('all services hub loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.allServices);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 12 — Quiz funnel
  // -------------------------------------------------------------------------
  group('Flow 12: Quiz funnel', () {
    testWidgets('quiz loads with default type', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/quiz');
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('quiz loads with type & source params', (tester) async {
      await tester.pumpAppWithRouter(
        initialLocation: '/quiz?type=general&source=discover',
      );
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 13 — Admin
  // -------------------------------------------------------------------------
  group('Flow 13: Admin', () {
    testWidgets('admin login loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.adminLogin);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 14 — 404 not found
  // -------------------------------------------------------------------------
  group('Flow 14: 404 error route', () {
    testWidgets('unknown route shows 404 text', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/nonexistent-route');
      expect(find.textContaining('404'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 15 — Glossary with search query parameter
  // -------------------------------------------------------------------------
  group('Flow 15: Glossary deep link with search', () {
    testWidgets('glossary loads without search', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.glossary);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('glossary loads with search=venus', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: '/glossary?search=venus');
      expect(find.byType(Scaffold), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // FLOW 16 — Spiritual & Wellness deep links
  // -------------------------------------------------------------------------
  group('Flow 16: Spiritual & Wellness', () {
    for (final route in [
      Routes.dailyRituals,
      Routes.chakraAnalysis,
      Routes.crystalGuide,
      Routes.moonRituals,
      Routes.tantra,
      Routes.tantraMicroRitual,
    ]) {
      testWidgets('$route loads scaffold', (tester) async {
        await tester.pumpAppWithRouter(initialLocation: route);
        expect(find.byType(Scaffold), findsWidgets);
      });
    }
  });

  // -------------------------------------------------------------------------
  // FLOW 17 — Share screens
  // -------------------------------------------------------------------------
  group('Flow 17: Share screens', () {
    testWidgets('share summary loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.shareSummary);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('cosmic share loads', (tester) async {
      await tester.pumpAppWithRouter(initialLocation: Routes.cosmicShare);
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
