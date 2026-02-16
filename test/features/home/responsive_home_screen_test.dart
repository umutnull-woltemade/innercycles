import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inner_cycles/features/home/presentation/responsive_home_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Responsive Home Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('ResponsiveHomeScreen renders scaffold', (tester) async {
    await tester.pumpApp(const ResponsiveHomeScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('ResponsiveHomeScreen displays content', (tester) async {
    await tester.pumpApp(const ResponsiveHomeScreen());
    await tester.pumpAndSettle();
    // Home screen should have scrollable content
    final hasScroll = find.byType(SingleChildScrollView).evaluate().isNotEmpty ||
                      find.byType(ListView).evaluate().isNotEmpty ||
                      find.byType(CustomScrollView).evaluate().isNotEmpty;
    expect(hasScroll, isTrue);
  });
  });
}
