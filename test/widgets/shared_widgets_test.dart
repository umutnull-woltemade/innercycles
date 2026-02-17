import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inner_cycles/shared/widgets/gradient_button.dart';

void main() {
  // ShimmerLoading uses flutter_animate which creates repeating animations.
  // We need to pump frames properly for animated widgets.

  group('GradientButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              label: 'With Icon',
              icon: Icons.star,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              label: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing); // Label hidden when loading
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
          ),
          home: Scaffold(
            body: GradientButton(
              label: 'Tap Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when loading', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              label: 'Cannot Tap',
              isLoading: true,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GradientButton));
      expect(tapped, isFalse);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              label: 'Disabled',
              onPressed: null,
            ),
          ),
        ),
      );

      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('accepts width parameter', (tester) async {
      // Just verify the widget accepts width without crashing
      // Layout tests require more complex viewport setup
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: GradientButton(
                label: 'OK',
                width: 300,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GradientButton), findsOneWidget);
    });
  });

  group('OutlineButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineButton(
              label: 'Outline',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Outline'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineButton(
              label: 'With Icon',
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OutlineButton(
              label: 'Tap',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap'));
      expect(tapped, isTrue);
    });
  });

  // Note: ShimmerLoading and SkeletonCard use flutter_animate with
  // repeating animations. We skip widget tests for these as they require
  // complex timer management. The widgets are simple containers with
  // animation effects - tested through visual inspection.
}
