import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/horoscopes/presentation/eclipse_calendar_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Eclipse Calendar Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('EclipseCalendarScreen renders', (tester) async {
    await tester.pumpApp(const EclipseCalendarScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
