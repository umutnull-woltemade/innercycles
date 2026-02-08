import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/horoscopes/presentation/monthly_horoscope_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Monthly Horoscope Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('MonthlyHoroscopeScreen renders without sign', (tester) async {
    await tester.pumpApp(const MonthlyHoroscopeScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('MonthlyHoroscopeScreen renders with sign', (tester) async {
    await tester.pumpApp(const MonthlyHoroscopeScreen(signName: 'aries'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
