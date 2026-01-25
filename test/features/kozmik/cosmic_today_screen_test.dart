import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/kozmik/presentation/canonical/cosmic_today_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('CosmicTodayScreen renders scaffold', (tester) async {
    await tester.pumpApp(const CosmicTodayScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
