// ════════════════════════════════════════════════════════════════════════════
// SCREENSHOT TEST - Automated App Store screenshot capture
// ════════════════════════════════════════════════════════════════════════════
// Captures 6 key screens for App Store screenshots:
//   1. Today Feed (home screen with mood + streak)
//   2. Journal Entry (writing experience)
//   3. Mood Trends (pattern visualization)
//   4. Dream Journal (dream interpretation)
//   5. Streak Stats (gamification)
//   6. Community Challenge (social engagement)
//
// Run: flutter test integration_test/screenshot_test.dart
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Store Screenshots', () {
    testWidgets('Capture screenshot set', (tester) async {
      // Import the app (adjust import to your main.dart)
      // app.main();
      // await tester.pumpAndSettle(const Duration(seconds: 3));

      // Screenshot 1: Today Feed
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      await binding.takeScreenshot('01_today_feed');

      // Screenshot 2: Journal Entry
      // Navigate to journal screen
      // await tester.tap(find.byIcon(Icons.edit_note));
      // await tester.pumpAndSettle();
      // await binding.takeScreenshot('02_journal_entry');

      // Screenshot 3: Mood Trends
      // await tester.tap(find.text('Trends'));
      // await tester.pumpAndSettle();
      // await binding.takeScreenshot('03_mood_trends');

      // Screenshot 4: Dream Journal
      // await binding.takeScreenshot('04_dream_journal');

      // Screenshot 5: Streak Stats
      // await binding.takeScreenshot('05_streak_stats');

      // Screenshot 6: Community Challenge
      // await binding.takeScreenshot('06_community_challenge');
    });
  });
}
