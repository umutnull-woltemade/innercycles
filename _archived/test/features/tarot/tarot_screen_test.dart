import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/tarot/presentation/tarot_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Tarot Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('TarotScreen renders scaffold', (tester) async {
    await tester.pumpApp(const TarotScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
