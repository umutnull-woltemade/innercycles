import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/chakra/presentation/chakra_analysis_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Chakra Analysis Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('ChakraAnalysisScreen renders scaffold', (tester) async {
    await tester.pumpApp(const ChakraAnalysisScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
