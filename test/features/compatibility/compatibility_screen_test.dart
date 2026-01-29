import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/compatibility/presentation/compatibility_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('CompatibilityScreen renders scaffold', (tester) async {
    await tester.pumpApp(const CompatibilityScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('CompatibilityScreen has sign selection', (tester) async {
    await tester.pumpApp(const CompatibilityScreen());
    await tester.pumpAndSettle();
    // Should have interactive elements for selecting signs
    expect(
      find.byType(GestureDetector).evaluate().isNotEmpty ||
          find.byType(InkWell).evaluate().isNotEmpty,
      isTrue,
    );
  });
}
