import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/features/share/presentation/screenshot_share_screen.dart';
import '../../helpers/pump_app.dart';

void main() {
  testWidgets('ScreenshotShareScreen renders scaffold', (tester) async {
    await tester.pumpApp(const ScreenshotShareScreen());
    await tester.pumpAndSettle();
    expect(find.byType(Scaffold), findsWidgets);
  });
}
