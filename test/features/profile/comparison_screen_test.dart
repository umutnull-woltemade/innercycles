import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/profile/presentation/comparison_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Comparison Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('ComparisonScreen renders scaffold', (tester) async {
    await tester.pumpApp(const ComparisonScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
