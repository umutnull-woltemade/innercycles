import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/numerology/presentation/numerology_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('NumerologyScreen renders scaffold', (tester) async {
    await tester.pumpApp(const NumerologyScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
