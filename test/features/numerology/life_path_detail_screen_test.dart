import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/numerology/presentation/life_path_detail_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Life Path Detail Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  for (final number in [1, 2, 3, 4, 5, 6, 7, 8, 9]) {
    testWidgets('LifePathDetailScreen renders for number $number', (tester) async {
      await tester.pumpApp(LifePathDetailScreen(number: number));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
    });
  }
  });
}
