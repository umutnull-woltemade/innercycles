import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/profile/presentation/saved_profiles_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('SavedProfilesScreen renders scaffold', (tester) async {
    await tester.pumpApp(const SavedProfilesScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
