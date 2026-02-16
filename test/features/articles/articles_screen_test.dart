import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inner_cycles/features/articles/presentation/articles_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Articles Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('ArticlesScreen renders scaffold', (tester) async {
    await tester.pumpApp(const ArticlesScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
