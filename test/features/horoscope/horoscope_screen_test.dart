import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/horoscope/presentation/horoscope_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('HoroscopeScreen renders scaffold', (tester) async {
    await tester.pumpApp(const HoroscopeScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('HoroscopeScreen shows zodiac content', (tester) async {
    await tester.pumpApp(const HoroscopeScreen());
    await tester.pumpAndSettle();
    // Should display zodiac signs or horoscope content
    expect(
      find.byType(GestureDetector).evaluate().isNotEmpty ||
          find.byType(InkWell).evaluate().isNotEmpty ||
          find.byType(ListTile).evaluate().isNotEmpty,
      isTrue,
    );
  });
}
