# Critical UI Protection System

> **PERMANENT IMMUNITY SYSTEM** for Critical UI Elements

## Overview

This system ensures that critical UI elements **cannot silently break**. Any failure is detected immediately, the exact breaking commit is identified, and CI hard-fails to block merge.

## Guarantees

| Guarantee | Implementation |
|-----------|----------------|
| Critical UI elements cannot silently break | Comprehensive regression tests |
| Any break is detected immediately | CI runs on every push/PR |
| Exact breaking commit is identified | Automated git bisect script |
| CI hard-fails and blocks merge | GitHub Actions required status |
| Auth & routing edge cases are chaos-tested | Chaos testing suite |
| Future refactors cannot bypass protections | Registry-based validation |

## Architecture

```
test/critical_ui/
├── CRITICAL_UI_PROTECTION.md      # This document
├── critical_ui_registry.dart      # PROTECTED SET definition
├── critical_ui_shield.dart        # Core verification infrastructure
├── critical_ui_regression_test.dart # Automated regression tests
├── chaos_testing.dart             # Chaos scenario definitions
└── chaos_test.dart                # Chaos test execution

scripts/
└── find_breaking_commit.sh        # Git bisect automation

.github/workflows/
└── critical_ui_gate.yml           # CI hard-fail configuration
```

## Protected Elements (PROTECTED SET)

The following UI elements are protected and must remain functional:

### Critical Severity (App Unusable if Broken)

| Element | Route | Purpose |
|---------|-------|---------|
| Onboarding Next Button | `/onboarding` | Advances onboarding |
| Onboarding Complete Button | `/onboarding` | Completes setup |
| Onboarding Name Input | `/onboarding` | Captures user name |
| Onboarding Birthdate Picker | `/onboarding` | Captures birth date |
| Apple Sign In Button | `/login` | Primary authentication |
| Premium Close Button | `/premium` | **User must not be trapped** |
| Premium Purchase Button | `/premium` | Revenue critical |

### Major Severity (Significant Feature Broken)

| Element | Route | Purpose |
|---------|-------|---------|
| Settings Button (Home) | `/home` | Access to settings |
| Search Button (Home) | `/home` | Search functionality |
| Profile Button (Home) | `/home` | Profile management |
| KOZMOZ Button (Home) | `/home` | Main feature entry |
| Settings Back Button | `/settings` | Navigation |
| Profile Settings Link | `/settings` | Profile access |
| All core route scaffolds | Various | Basic rendering |

### Important Severity (Feature Degraded)

| Element | Route | Purpose |
|---------|-------|---------|
| Theme Toggle | `/settings` | User preference |
| Language Selector | `/settings` | Localization |
| Restore Purchases | `/premium` | Subscription recovery |

## How to Add a New Critical Element

1. **Edit the Registry** (`critical_ui_registry.dart`):

```dart
const CriticalUIElement(
  id: 'unique_element_id',
  name: 'Human Readable Name',
  description: 'What this element does',
  type: CriticalUIType.primaryAction,
  severity: FailureSeverity.major,
  sourceRoute: Routes.yourRoute,
  targetRoute: Routes.destinationRoute, // or targetAction
  findStrategy: CriticalUIFindStrategy(
    byKey: 'widget_key',
    byIcon: Icons.your_icon,
    byText: 'Button Text',
  ),
),
```

2. **Add Widget Key** in the actual widget:

```dart
IconButton(
  key: const ValueKey('unique_element_id'),
  icon: const Icon(Icons.your_icon),
  onPressed: () => ...,
)
```

3. **Tests Auto-Generate**: The registry validation will automatically include your new element.

4. **CI Enforces**: The CI gate will now protect this element.

## Chaos Scenarios Tested

| Scenario | What Happens | Expected Behavior |
|----------|--------------|-------------------|
| Auth logout mid-session | User suddenly logged out | App handles gracefully, no crash |
| Profile becomes null | Profile data disappears | Redirect or error, no crash |
| Onboarding state flip | State toggles unexpectedly | Appropriate redirect |
| Invalid route | Navigation to removed route | Show 404, no crash |
| Rapid navigation | Many navigations in quick succession | Stable, no race conditions |
| Theme change mid-action | Theme switches during operation | UI updates correctly |
| Language change | Locale changes mid-session | Text updates, layout stable |
| RTL language (Arabic) | Right-to-left layout | Layout mirrors correctly |

## CI Configuration

### Required Status Checks

The `critical_ui_gate.yml` workflow creates these required checks:

1. **Critical UI Tests** - All regression tests must pass
2. **Chaos Tests** - All chaos scenarios must pass
3. **Registry Validation** - Registry must be valid
4. **Gate Result** - Final aggregation must succeed

### Branch Protection Rules

Configure in GitHub repository settings:

```
Settings → Branches → Branch protection rules → main

✅ Require status checks to pass before merging
  ✅ Critical UI Gate Result

✅ Require branches to be up to date before merging
```

## Running Tests Locally

```bash
# Run all critical UI tests
flutter test test/critical_ui/

# Run only regression tests
flutter test test/critical_ui/critical_ui_regression_test.dart

# Run only chaos tests
flutter test test/critical_ui/chaos_test.dart

# Find breaking commit
./scripts/find_breaking_commit.sh

# Find breaking commit with specific range
./scripts/find_breaking_commit.sh --good abc123 --bad HEAD
```

## Troubleshooting

### Test Fails: Element Not Found

1. Check if the widget has the correct `ValueKey`
2. Verify the route is correct in the registry
3. Ensure the element renders under test conditions

### Test Fails: Element Not Clickable

1. Check if `onPressed` / `onTap` is null
2. Look for `AbsorbPointer` or `IgnorePointer` ancestors
3. Verify the element is not disabled

### Test Fails: Silent Failure

1. The element was tapped but nothing happened
2. Check event handlers are properly wired
3. Verify state changes are propagating

### Breaking Commit Not Found

1. Ensure the "good" commit actually had passing tests
2. The tests may have always been failing in that range
3. Try a larger commit range

## Future-Proofing Rules

### Route Changes

When renaming or removing a route:

1. Update `critical_ui_registry.dart` with new route
2. Ensure all `targetRoute` references are updated
3. Run full test suite before merging

### Middleware Changes

When modifying auth middleware:

1. Run chaos tests specifically
2. Verify no silent redirect loops
3. Check protected routes still accessible when logged in

### UI Rewrites

When rewriting a screen:

1. Preserve all `ValueKey` identifiers
2. Run regression tests after rewrite
3. Verify chaos scenarios still pass

### Auth Logic Updates

When changing authentication:

1. Run all chaos auth scenarios
2. Verify login/logout flows
3. Check premium purchase flow still works

## Contact

For questions about this system, check the test files for detailed documentation or review the CI workflow configuration.

---

**Remember: Silent UI regressions are now IMPOSSIBLE.**
