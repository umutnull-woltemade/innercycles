import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/horoscopes/presentation/love_horoscope_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('LoveHoroscopeScreen renders without sign', (tester) async {
    await tester.pumpApp(const LoveHoroscopeScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('LoveHoroscopeScreen renders with sign', (tester) async {
    await tester.pumpApp(const LoveHoroscopeScreen(signName: 'aries'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
