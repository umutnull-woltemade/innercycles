import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:inner_cycles/features/admin/presentation/admin_login_screen.dart';
import 'package:inner_cycles/features/admin/presentation/admin_dashboard_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('Admin Screens', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('AdminLoginScreen renders scaffold', (tester) async {
    await tester.pumpApp(const AdminLoginScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('AdminDashboardScreen renders scaffold', (tester) async {
    await tester.pumpApp(const AdminDashboardScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
