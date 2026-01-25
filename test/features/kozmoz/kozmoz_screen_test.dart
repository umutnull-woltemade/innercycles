import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/kozmoz/presentation/kozmoz_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('KozmozScreen renders scaffold', (tester) async {
    await tester.pumpApp(const KozmozScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
