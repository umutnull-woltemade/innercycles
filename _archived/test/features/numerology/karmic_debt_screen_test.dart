import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/numerology/presentation/karmic_debt_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Karmic Debt Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  for (final number in [13, 14, 16, 19]) {
    testWidgets('KarmicDebtScreen renders for debt $number', (tester) async {
      await tester.pumpApp(KarmicDebtScreen(debtNumber: number));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
    });
  }
  });
}
