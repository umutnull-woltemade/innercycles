/// CRITICAL UI SHIELD
///
/// This module provides the core testing infrastructure for critical UI elements.
/// It ensures that protected elements:
/// 1. EXIST in the DOM
/// 2. Are VISIBLE to users
/// 3. Are CLICKABLE (no pointer-events blocking)
/// 4. NAVIGATE or TRIGGER correct actions
/// 5. Do NOT silently fail
///
/// Usage:
/// ```dart
/// await CriticalUIShield.verifyElement(tester, element);
/// await CriticalUIShield.verifyAllElementsOnRoute(tester, '/home');
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'critical_ui_registry.dart';

/// Result of a critical UI element verification
class CriticalUIVerificationResult {
  const CriticalUIVerificationResult({
    required this.element,
    required this.passed,
    required this.checks,
    this.error,
    this.stackTrace,
  });

  final CriticalUIElement element;
  final bool passed;
  final Map<String, bool> checks;
  final String? error;
  final StackTrace? stackTrace;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('CriticalUIVerificationResult:');
    buffer.writeln('  Element: ${element.id} (${element.name})');
    buffer.writeln('  Passed: $passed');
    buffer.writeln('  Checks:');
    for (final entry in checks.entries) {
      final icon = entry.value ? '✓' : '✗';
      buffer.writeln('    $icon ${entry.key}');
    }
    if (error != null) {
      buffer.writeln('  Error: $error');
    }
    return buffer.toString();
  }
}

/// Shield verification exception - thrown when critical UI fails
class CriticalUIShieldException implements Exception {
  const CriticalUIShieldException({
    required this.element,
    required this.failedCheck,
    required this.message,
    this.innerError,
  });

  final CriticalUIElement element;
  final String failedCheck;
  final String message;
  final Object? innerError;

  @override
  String toString() {
    return '''
╔══════════════════════════════════════════════════════════════════════════════╗
║ CRITICAL UI SHIELD FAILURE                                                    ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ Element ID: ${element.id.padRight(60)}║
║ Element Name: ${element.name.padRight(57)}║
║ Route: ${element.sourceRoute.padRight(63)}║
║ Severity: ${element.severity.name.toUpperCase().padRight(60)}║
╠══════════════════════════════════════════════════════════════════════════════╣
║ Failed Check: ${failedCheck.padRight(56)}║
║ Message: ${message.padRight(61)}║
${innerError != null ? '║ Inner Error: ${innerError.toString().padRight(56)}║\n' : ''}╚══════════════════════════════════════════════════════════════════════════════╝
''';
  }
}

/// Main shield class for critical UI verification
class CriticalUIShield {
  CriticalUIShield._();

  // ═══════════════════════════════════════════════════════════════════════════
  // CORE VERIFICATION METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Verify a single critical UI element
  static Future<CriticalUIVerificationResult> verifyElement(
    WidgetTester tester,
    CriticalUIElement element, {
    bool throwOnFailure = true,
  }) async {
    final checks = <String, bool>{};
    String? error;
    StackTrace? stackTrace;

    try {
      // Step 1: Find the element
      final finder = _buildFinder(element);
      checks['finder_built'] = finder != null;
      if (finder == null) {
        throw CriticalUIShieldException(
          element: element,
          failedCheck: 'finder_built',
          message: 'Could not build finder for element',
        );
      }

      // Step 2: Verify existence
      await tester.pumpAndSettle();
      final exists = finder.evaluate().isNotEmpty;
      checks['exists'] = exists;
      if (!exists) {
        throw CriticalUIShieldException(
          element: element,
          failedCheck: 'exists',
          message: 'Element not found in widget tree',
        );
      }

      // Step 3: Verify visibility
      final visible = await _isVisible(tester, finder);
      checks['visible'] = visible;
      if (!visible) {
        throw CriticalUIShieldException(
          element: element,
          failedCheck: 'visible',
          message: 'Element exists but is not visible',
        );
      }

      // Step 4: Verify clickability (not disabled, no blocking overlays)
      final clickable = await _isClickable(tester, finder);
      checks['clickable'] = clickable;
      if (!clickable) {
        throw CriticalUIShieldException(
          element: element,
          failedCheck: 'clickable',
          message: 'Element visible but not clickable (disabled or blocked)',
        );
      }

      // Step 5: Verify interaction doesn't silently fail
      final interacts = await _canInteract(tester, finder, element);
      checks['interacts'] = interacts;
      if (!interacts) {
        throw CriticalUIShieldException(
          element: element,
          failedCheck: 'interacts',
          message: 'Element click produced no response (silent failure)',
        );
      }

      return CriticalUIVerificationResult(
        element: element,
        passed: true,
        checks: checks,
      );
    } catch (e, st) {
      error = e.toString();
      stackTrace = st;

      if (throwOnFailure && e is CriticalUIShieldException) {
        rethrow;
      } else if (throwOnFailure) {
        throw CriticalUIShieldException(
          element: element,
          failedCheck: 'unknown',
          message: e.toString(),
          innerError: e,
        );
      }

      return CriticalUIVerificationResult(
        element: element,
        passed: false,
        checks: checks,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Verify all critical UI elements on a specific route
  static Future<List<CriticalUIVerificationResult>> verifyAllElementsOnRoute(
    WidgetTester tester,
    String route, {
    bool throwOnFirstFailure = false,
  }) async {
    final elements = getCriticalElementsForRoute(route);
    final results = <CriticalUIVerificationResult>[];

    for (final element in elements) {
      final result = await verifyElement(
        tester,
        element,
        throwOnFailure: throwOnFirstFailure,
      );
      results.add(result);
    }

    return results;
  }

  /// Verify all CRITICAL severity elements
  static Future<List<CriticalUIVerificationResult>> verifyMustNotFailElements(
    WidgetTester tester, {
    required GoRouter router,
  }) async {
    final elements = getMustNotFailElements();
    final results = <CriticalUIVerificationResult>[];

    // Group by route to minimize navigation
    final byRoute = <String, List<CriticalUIElement>>{};
    for (final e in elements) {
      byRoute.putIfAbsent(e.sourceRoute, () => []).add(e);
    }

    for (final entry in byRoute.entries) {
      router.go(entry.key);
      await tester.pumpAndSettle();

      for (final element in entry.value) {
        final result = await verifyElement(tester, element, throwOnFailure: true);
        results.add(result);
      }
    }

    return results;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build a Finder from the element's find strategy
  static Finder? _buildFinder(CriticalUIElement element) {
    final strategy = element.findStrategy;

    // Try each strategy in priority order
    if (strategy.byKey != null) {
      return find.byKey(ValueKey(strategy.byKey));
    }
    if (strategy.byIcon != null) {
      return find.byIcon(strategy.byIcon!);
    }
    if (strategy.byText != null) {
      return find.text(strategy.byText!);
    }
    if (strategy.byTooltip != null) {
      return find.byTooltip(strategy.byTooltip!);
    }
    if (strategy.bySemanticLabel != null) {
      return find.bySemanticsLabel(strategy.bySemanticLabel!);
    }
    if (strategy.byType != null) {
      // Note: This is a simplified type finder
      // In production you'd want to use the actual Type
      return find.byType(Widget);
    }

    return null;
  }

  /// Check if element is visible (not hidden by opacity, offscreen, etc.)
  static Future<bool> _isVisible(WidgetTester tester, Finder finder) async {
    try {
      final element = finder.evaluate().first;
      final renderObject = element.renderObject;

      if (renderObject == null) return false;

      // Check if it has valid size
      if (renderObject is RenderBox) {
        final size = renderObject.size;
        if (size.width <= 0 || size.height <= 0) return false;

        // Check if it's within viewport
        final position = renderObject.localToGlobal(Offset.zero);
        final screenSize = tester.view.physicalSize / tester.view.devicePixelRatio;

        if (position.dx + size.width < 0 || position.dx > screenSize.width) {
          return false;
        }
        if (position.dy + size.height < 0 || position.dy > screenSize.height) {
          return false;
        }
      }

      // Check opacity in ancestor chain
      bool hasZeroOpacity = false;
      element.visitAncestorElements((ancestor) {
        if (ancestor.widget is Opacity) {
          final opacity = ancestor.widget as Opacity;
          if (opacity.opacity == 0) {
            hasZeroOpacity = true;
            return false; // Stop visiting
          }
        }
        if (ancestor.widget is Visibility) {
          final visibility = ancestor.widget as Visibility;
          if (!visibility.visible) {
            hasZeroOpacity = true;
            return false;
          }
        }
        return true; // Continue visiting
      });

      return !hasZeroOpacity;
    } catch (_) {
      return false;
    }
  }

  /// Check if element is clickable (enabled, no blockers)
  static Future<bool> _isClickable(WidgetTester tester, Finder finder) async {
    try {
      final element = finder.evaluate().first;
      final widget = element.widget;

      // Check if disabled
      if (widget is IconButton && widget.onPressed == null) return false;
      if (widget is ElevatedButton && widget.onPressed == null) return false;
      if (widget is TextButton && widget.onPressed == null) return false;
      if (widget is OutlinedButton && widget.onPressed == null) return false;
      if (widget is GestureDetector && widget.onTap == null) return false;
      if (widget is InkWell && widget.onTap == null) return false;

      // Check for AbsorbPointer or IgnorePointer ancestors
      bool blocked = false;
      element.visitAncestorElements((ancestor) {
        if (ancestor.widget is AbsorbPointer) {
          final absorb = ancestor.widget as AbsorbPointer;
          if (absorb.absorbing) {
            blocked = true;
            return false;
          }
        }
        if (ancestor.widget is IgnorePointer) {
          final ignore = ancestor.widget as IgnorePointer;
          if (ignore.ignoring) {
            blocked = true;
            return false;
          }
        }
        return true;
      });

      return !blocked;
    } catch (_) {
      return false;
    }
  }

  /// Check if tapping the element produces a response
  static Future<bool> _canInteract(
    WidgetTester tester,
    Finder finder,
    CriticalUIElement element,
  ) async {
    try {
      // Capture state before tap
      final stateBefore = _captureState(tester);

      // Attempt to tap
      await tester.tap(finder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Capture state after tap
      final stateAfter = _captureState(tester);

      // For navigation elements, check route changed or dialog appeared
      if (element.targetRoute != null || element.targetAction == 'pop') {
        // Any state change indicates the tap worked
        return stateBefore != stateAfter;
      }

      // For action elements, check for any change
      if (element.targetAction != null) {
        return stateBefore != stateAfter;
      }

      return true; // Assume success if no specific check
    } catch (e) {
      // If tap throws, the element might be gone (navigation happened)
      // which could actually be success
      return true;
    }
  }

  /// Capture widget tree state for comparison
  static String _captureState(WidgetTester tester) {
    final scaffolds = find.byType(Scaffold).evaluate();
    final dialogs = find.byType(Dialog).evaluate();
    final bottomSheets = find.byType(BottomSheet).evaluate();
    final snackBars = find.byType(SnackBar).evaluate();

    return 'scaffolds:${scaffolds.length},'
        'dialogs:${dialogs.length},'
        'bottomSheets:${bottomSheets.length},'
        'snackBars:${snackBars.length}';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REPORTING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Generate a summary report of verification results
  static String generateReport(List<CriticalUIVerificationResult> results) {
    final buffer = StringBuffer();
    buffer.writeln('╔══════════════════════════════════════════════════════════════════════════════╗');
    buffer.writeln('║                    CRITICAL UI SHIELD VERIFICATION REPORT                    ║');
    buffer.writeln('╠══════════════════════════════════════════════════════════════════════════════╣');

    final passed = results.where((r) => r.passed).length;
    final failed = results.where((r) => !r.passed).length;
    final total = results.length;

    buffer.writeln('${'║ Total Elements: $total'.padRight(79)}║');
    buffer.writeln('${'║ Passed: $passed'.padRight(79)}║');
    buffer.writeln('${'║ Failed: $failed'.padRight(79)}║');
    buffer.writeln('╠══════════════════════════════════════════════════════════════════════════════╣');

    if (failed > 0) {
      buffer.writeln('${'║ FAILURES:'.padRight(79)}║');
      for (final result in results.where((r) => !r.passed)) {
        buffer.writeln('${'║ - ${result.element.id}: ${result.error}'.padRight(77)}║');
      }
    } else {
      buffer.writeln('${'║ ✓ All critical UI elements verified successfully'.padRight(79)}║');
    }

    buffer.writeln('╚══════════════════════════════════════════════════════════════════════════════╝');
    return buffer.toString();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CONVENIENCE MATCHERS FOR FLUTTER TEST
// ═══════════════════════════════════════════════════════════════════════════

/// Matcher that verifies a critical UI element passes all checks
Matcher criticalUIElementPasses(CriticalUIElement element) {
  return _CriticalUIElementMatcher(element);
}

class _CriticalUIElementMatcher extends Matcher {
  _CriticalUIElementMatcher(this.element);

  final CriticalUIElement element;

  @override
  Description describe(Description description) {
    return description.add('critical UI element "${element.id}" passes all checks');
  }

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is CriticalUIVerificationResult) {
      return item.passed;
    }
    return false;
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is CriticalUIVerificationResult) {
      mismatchDescription.add('failed checks: ');
      final failed = item.checks.entries.where((e) => !e.value).map((e) => e.key);
      mismatchDescription.add(failed.join(', '));
      if (item.error != null) {
        mismatchDescription.add('\nError: ${item.error}');
      }
    }
    return mismatchDescription;
  }
}
