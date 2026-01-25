import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/settings/presentation/settings_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('SettingsScreen renders scaffold', (tester) async {
    await tester.pumpApp(const SettingsScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('SettingsScreen has scrollable content', (tester) async {
    await tester.pumpApp(const SettingsScreen());
    await tester.pumpAndSettle();
    final hasScroll = find.byType(SingleChildScrollView).evaluate().isNotEmpty ||
                      find.byType(ListView).evaluate().isNotEmpty ||
                      find.byType(CustomScrollView).evaluate().isNotEmpty;
    expect(hasScroll, isTrue);
  });
}
