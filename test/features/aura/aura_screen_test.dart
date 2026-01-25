import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/aura/presentation/aura_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AuraScreen renders scaffold', (tester) async {
    await tester.pumpApp(const AuraScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
