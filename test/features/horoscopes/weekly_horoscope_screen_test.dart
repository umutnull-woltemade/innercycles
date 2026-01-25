import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/horoscopes/presentation/weekly_horoscope_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('WeeklyHoroscopeScreen renders without sign', (tester) async {
    await tester.pumpApp(const WeeklyHoroscopeScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('WeeklyHoroscopeScreen renders with sign', (tester) async {
    await tester.pumpApp(const WeeklyHoroscopeScreen(signName: 'aries'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
