import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/premium/presentation/premium_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('PremiumScreen renders scaffold', (tester) async {
    await tester.pumpApp(const PremiumScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
