import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/tantra/presentation/tantra_screen.dart';
import 'package:astrology_app/features/tantra/presentation/canonical/tantra_micro_ritual_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('TantraScreen renders scaffold', (tester) async {
    await tester.pumpApp(const TantraScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('TantraMicroRitualScreen renders scaffold', (tester) async {
    await tester.pumpApp(const TantraMicroRitualScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
