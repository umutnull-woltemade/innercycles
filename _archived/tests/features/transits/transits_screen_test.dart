import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/transits/presentation/transits_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Transits Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('TransitsScreen renders scaffold', (tester) async {
    await tester.pumpApp(const TransitsScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
