import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/profile/presentation/profile_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('Profile Screen', skip: !runFeatureScreenTests ? featureScreenSkipReason : null, () {
  testWidgets('ProfileScreen renders scaffold', (tester) async {
    await tester.pumpApp(const ProfileScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
  });
}
