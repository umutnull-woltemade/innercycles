import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrology_app/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CelestialApp()),
    );

    // Verify the app launches
    expect(find.text('Celestial'), findsOneWidget);
  });
}
