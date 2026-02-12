import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/gardening/presentation/gardening_moon_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Gardening Moon Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('GardeningMoonScreen renders scaffold', (tester) async {
    await tester.pumpApp(const GardeningMoonScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
