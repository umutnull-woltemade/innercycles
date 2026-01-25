import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/admin/presentation/admin_login_screen.dart';
import 'package:astrology_app/features/admin/presentation/admin_dashboard_screen.dart';

import '../../helpers/pump_app.dart';

void main() {
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
}
