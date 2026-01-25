import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/numerology/presentation/master_number_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  for (final number in [11, 22, 33]) {
    testWidgets('MasterNumberScreen renders for $number', (tester) async {
      await tester.pumpApp(MasterNumberScreen(number: number));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
    });
  }
}
