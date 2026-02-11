import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/natal_chart/presentation/natal_chart_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Natal Chart Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('NatalChartScreen renders scaffold', (tester) async {
    await tester.pumpApp(const NatalChartScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
