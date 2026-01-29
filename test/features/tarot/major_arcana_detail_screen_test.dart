import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/tarot/presentation/major_arcana_detail_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('MajorArcanaDetailScreen renders for card 0 (The Fool)', (
    tester,
  ) async {
    await tester.pumpApp(const MajorArcanaDetailScreen(cardNumber: 0));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('MajorArcanaDetailScreen renders for card 21 (The World)', (
    tester,
  ) async {
    await tester.pumpApp(const MajorArcanaDetailScreen(cardNumber: 21));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
