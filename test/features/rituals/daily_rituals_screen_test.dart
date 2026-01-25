import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/rituals/presentation/daily_rituals_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('DailyRitualsScreen renders scaffold', (tester) async {
    await tester.pumpApp(const DailyRitualsScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
