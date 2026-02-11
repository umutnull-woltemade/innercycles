// ════════════════════════════════════════════════════════════════════════════
// TEST ROUTER - Minimal Router for Testing (App Store Compliant)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a minimal test router for widget testing.
/// All astrology routes have been removed for App Store compliance.
GoRouter buildTestRouter({String initialLocation = '/'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _TestHomeScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const _TestHomeScreen(),
      ),
      GoRoute(
        path: '/disclaimer',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Disclaimer'),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Onboarding'),
      ),
      GoRoute(
        path: '/insight',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Insight'),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Profile'),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Settings'),
      ),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Premium'),
      ),
      GoRoute(
        path: '/numerology',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Numerology'),
      ),
      GoRoute(
        path: '/tarot',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Tarot'),
      ),
      GoRoute(
        path: '/aura',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Aura'),
      ),
      GoRoute(
        path: '/dream-interpretation',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Dreams'),
      ),
      GoRoute(
        path: '/glossary',
        builder: (context, state) => const _TestPlaceholderScreen(title: 'Glossary'),
      ),
    ],
  );
}

/// Extension on WidgetTester for router building.
extension TestRouterExtension on WidgetTester {
  GoRouter buildTestRouter({String initialLocation = '/'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _TestHomeScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const _TestHomeScreen(),
        ),
        GoRoute(
          path: '/insight',
          builder: (context, state) => const _TestPlaceholderScreen(title: 'Insight'),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const _TestPlaceholderScreen(title: 'Profile'),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const _TestPlaceholderScreen(title: 'Settings'),
        ),
      ],
    );
  }
}

class _TestHomeScreen extends StatelessWidget {
  const _TestHomeScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Test Home')),
    );
  }
}

class _TestPlaceholderScreen extends StatelessWidget {
  final String title;

  const _TestPlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
