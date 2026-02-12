import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/numerology/presentation/personal_year_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Personal Year Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('PersonalYearScreen renders for year 1', (tester) async {
    await tester.pumpApp(const PersonalYearScreen(year: 1));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
