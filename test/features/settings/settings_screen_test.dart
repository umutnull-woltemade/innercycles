import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inner_cycles/features/settings/presentation/settings_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('SettingsScreen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
    testWidgets('renders scaffold', (tester) async {
      await tester.pumpApp(const SettingsScreen());
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('has scrollable content', (tester) async {
      await tester.pumpApp(const SettingsScreen());
      await tester.pumpAndSettle();
      final hasScroll = find.byType(SingleChildScrollView).evaluate().isNotEmpty ||
                        find.byType(ListView).evaluate().isNotEmpty ||
                        find.byType(CustomScrollView).evaluate().isNotEmpty;
      expect(hasScroll, isTrue);
    });
  });
}
