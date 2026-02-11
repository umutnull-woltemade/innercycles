import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/cosmic_discovery/presentation/cosmic_discovery_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('Cosmic Discovery Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('CosmicDiscoveryScreen renders for dailySummary', (tester) async {
    await tester.pumpApp(const CosmicDiscoveryScreen(
      title: 'Test Title',
      subtitle: 'Test Subtitle',
      emoji: '☀️',
      primaryColor: Color(0xFFFFD700),
      type: CosmicDiscoveryType.dailySummary,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('CosmicDiscoveryScreen renders for shadowSelf', (tester) async {
    await tester.pumpApp(const CosmicDiscoveryScreen(
      title: 'Shadow Self',
      subtitle: 'Meet your dark side',
      emoji: '🌑',
      primaryColor: Color(0xFF37474F),
      type: CosmicDiscoveryType.shadowSelf,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('CosmicDiscoveryScreen renders for soulMate', (tester) async {
    await tester.pumpApp(const CosmicDiscoveryScreen(
      title: 'Soul Mate',
      subtitle: 'Find your match',
      emoji: '👫',
      primaryColor: Color(0xFFFF6B9D),
      type: CosmicDiscoveryType.soulMate,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
