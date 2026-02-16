import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/main.dart';

// Basic test to verify the main app class exists and is properly exported.
// Full widget tests with app initialization are in integration tests.
void main() {
  test('VenusOneApp is exported from main.dart', () {
    // Verify the app class can be constructed
    // Note: We don't pump the widget because it requires Firebase,
    // platform channels, and other integrations that need full setup
    expect(VenusOneApp, isNotNull);
    expect(const VenusOneApp(), isA<VenusOneApp>());
  });
}
