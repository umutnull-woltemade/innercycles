import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inner_cycles/features/glossary/presentation/glossary_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Glossary Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('GlossaryScreen renders scaffold', (tester) async {
    await tester.pumpApp(const GlossaryScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('GlossaryScreen renders with initialSearch', (tester) async {
    await tester.pumpApp(const GlossaryScreen(initialSearch: 'venus'));
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
