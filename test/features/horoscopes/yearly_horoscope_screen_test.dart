import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/horoscopes/presentation/yearly_horoscope_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('YearlyHoroscopeScreen renders without sign', (tester) async {
    await tester.pumpApp(const YearlyHoroscopeScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('YearlyHoroscopeScreen renders with sign', (tester) async {
    await tester.pumpApp(const YearlyHoroscopeScreen(signName: 'aries'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
