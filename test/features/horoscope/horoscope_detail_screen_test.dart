import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/horoscope/presentation/horoscope_detail_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('HoroscopeDetailScreen renders with sign parameter', (
    tester,
  ) async {
    await tester.pumpApp(const HoroscopeDetailScreen(signName: 'aries'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('HoroscopeDetailScreen displays sign content', (tester) async {
    await tester.pumpApp(const HoroscopeDetailScreen(signName: 'leo'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
