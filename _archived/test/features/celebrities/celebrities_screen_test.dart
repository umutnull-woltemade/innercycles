import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/celebrities/presentation/celebrities_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Celebrities Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('CelebritiesScreen renders scaffold', (tester) async {
    await tester.pumpApp(const CelebritiesScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
