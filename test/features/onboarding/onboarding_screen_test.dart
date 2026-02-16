import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inner_cycles/features/onboarding/presentation/onboarding_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Onboarding Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('OnboardingScreen renders scaffold', (tester) async {
    await tester.pumpApp(const OnboardingScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('OnboardingScreen has interactive elements', (tester) async {
    await tester.pumpApp(const OnboardingScreen());
    await tester.pumpAndSettle();
    // Onboarding typically has buttons or page indicators
    expect(find.byType(ElevatedButton).evaluate().isNotEmpty ||
           find.byType(TextButton).evaluate().isNotEmpty ||
           find.byType(IconButton).evaluate().isNotEmpty, isTrue);
  });
  });
}
