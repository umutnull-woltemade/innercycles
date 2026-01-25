import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/all_services/presentation/all_services_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AllServicesScreen renders scaffold', (tester) async {
    await tester.pumpApp(const AllServicesScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
