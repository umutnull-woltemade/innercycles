# Customer Center UI Quick Reference Guide

## 🎯 Purpose
Quick reference for developers working on Customer Center UI components.

---

## 📦 New Files Created

### 1. **CustomerCenterIcons.swift**
Centralized SF Symbol icon constants with standardized sizes.

**Usage Example:**
```swift
Image(systemName: CustomerCenterIcons.chevronForward)
    .frame(width: CustomerCenterIcons.Size.chevron, 
           height: CustomerCenterIcons.Size.chevron)
```

### 2. **CustomerCenterDesignTokens.swift**
Design system tokens for spacing, colors, typography, and layouts.

**Usage Example:**
```swift
VStack(spacing: CustomerCenterDesignTokens.Spacing.medium) {
    // content
}
.cornerRadius(CustomerCenterDesignTokens.CornerRadius.card)
```

### 3. **UI_AUDIT_REPORT.md**
Comprehensive audit of all UI components with detailed findings.

---

## 🎨 Icon Reference

| Purpose | Constant | Preview |
|---------|----------|---------|
| Navigation | `CustomerCenterIcons.chevronForward` | → |
| Success | `CustomerCenterIcons.success` | ✓ |
| Error | `CustomerCenterIcons.error` | ✗ |
| Warning | `CustomerCenterIcons.warning` | ⚠️ |
| Info | `CustomerCenterIcons.info` | ℹ️ |
| Unknown | `CustomerCenterIcons.unknown` | ? |
| Update | `CustomerCenterIcons.update` | ↑ |

### Icon Sizes
- **Chevron**: 12x12pt (navigation indicators)
- **Status Icons**: 16x16pt (info, warning, error)
- **Action Icons**: 24x24pt (large interactive elements)

---

## 📏 Spacing Scale

```swift
extraTiny: 2pt   // ▪
tiny:      4pt   // ▪▪
small:     8pt   // ▪▪▪▪
medium:    12pt  // ▪▪▪▪▪▪
standard:  16pt  // ▪▪▪▪▪▪▪▪
large:     24pt  // ▪▪▪▪▪▪▪▪▪▪▪▪
extraLarge: 32pt // ▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪
```

**Common Usage:**
- Element groups: `medium` (12pt)
- Card padding: `standard` (16pt)
- Section breaks: `large` (24pt)
- Major sections: `extraLarge` (32pt)

---

## 🔵 Corner Radius

```swift
badge:  4pt  // Small rounded corners for badges
button: 8pt  // Medium corners for buttons
card:   10pt // Standard for most containers
modal:  16pt // Large for sheets and modals
```

---

## 🎭 Badge Colors & States

### Active States
```swift
.active       // Green: 52/199/89, 20% opacity
.freeTrial    // Yellow: 245/202/92, 20% opacity
```

### Inactive/Warning States
```swift
.cancelled      // Red: 242/84/91, 15% opacity
.cancelledTrial // Red: 242/84/91, 15% opacity
.expired        // Gray: 242/242/247, 20% opacity
```

### Special States
```swift
.lifetime // Border only: 60/60/67, 29% opacity
```

---

## 🎬 Animation Guidelines

### Durations
- **Fast** (0.15s): Micro-interactions, hover states
- **Standard** (0.3s): Most transitions, state changes
- **Slow** (0.6s): Major state changes, modal presentations

### Common Patterns
```swift
// Opacity fade
.animation(.easeInOut(duration: 0.3), value: isVisible)

// State transition
.transition(.opacity)

// Combined transition
.transition(.opacity.combined(with: .scale))

// Explicit animation
withAnimation {
    showContent = true
}
```

---

## 🎨 Adaptive Colors

### Light Mode
```swift
Card Background:      .systemBackground
Secondary Background: .secondarySystemFill
Screen Background:    .secondarySystemBackground
Button Tint:          .black
```

### Dark Mode
```swift
Card Background:      .secondarySystemBackground
Secondary Background: .tertiarySystemBackground
Screen Background:    .systemBackground
Button Tint:          .white
```

### Helper Methods
```swift
// Get adaptive background
CustomerCenterDesignTokens.AdaptiveColor.cardBackground(for: colorScheme)

// Get adaptive button tint
CustomerCenterDesignTokens.AdaptiveColor.buttonTint(for: colorScheme)
```

---

## 📱 View Structure Patterns

### Standard Card View
```swift
VStack(alignment: .leading, spacing: 0) {
    // Content
}
.padding()
.background(CustomerCenterDesignTokens.AdaptiveColor.cardBackground(for: colorScheme))
.cornerRadius(CustomerCenterDesignTokens.CornerRadius.card)
.padding(.horizontal)
```

### List Section
```swift
ScrollViewSection(title: localization[.sectionTitle]) {
    // Section content
    .cornerRadius(CustomerCenterDesignTokens.CornerRadius.card)
    .padding(.horizontal)
    .padding(.bottom, CustomerCenterDesignTokens.Spacing.large)
}
```

### Button with Chevron
```swift
Button {
    // Action
} label: {
    CompatibilityLabeledContent(localization[.buttonLabel]) {
        Image(systemName: CustomerCenterIcons.chevronForward)
    }
}
.buttonStyle(.customerCenterButtonStyle(for: colorScheme))
.tint(CustomerCenterDesignTokens.AdaptiveColor.buttonTint(for: colorScheme))
```

---

## ✅ Accessibility Checklist

When creating new UI components:

- [ ] Add accessibility identifiers for testing
- [ ] Use semantic colors (`.primary`, `.secondary`)
- [ ] Ensure minimum 44pt touch targets
- [ ] Support Dynamic Type
- [ ] Test with VoiceOver
- [ ] Add meaningful accessibility labels
- [ ] Support dark mode
- [ ] Handle reduced motion preferences

---

## 🧪 Preview Template

```swift
#if DEBUG
@available(iOS 15.0, *)
struct YourView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            YourView()
                .preferredColorScheme(colorScheme)
                .previewDisplayName("View Name - \(colorScheme)")
        }
        .environment(\.localization, CustomerCenterConfigData.default.localization)
        .environment(\.appearance, CustomerCenterConfigData.default.appearance)
    }
}
#endif
```

---

## 🔍 Common Modifiers

### Dismiss Button
```swift
.dismissCircleButtonToolbarIfNeeded()
```

### Scrollable When Needed
```swift
.scrollableIfNecessary(.vertical)
```

### Conditional Navigation
```swift
.compatibleNavigation(
    isPresented: $showDestination,
    usesNavigationStack: navigationOptions.usesNavigationStack
) {
    DestinationView()
}
```

### Customer Center Action Handling
```swift
.modifier(CustomerCenterActionViewModifier(actionWrapper: actionWrapper))
```

---

## 📊 View States Pattern

```swift
enum ViewState: Equatable {
    case loading
    case loaded(Data)
    case error
}

// In view body
switch viewModel.viewState {
case .loading:
    ProgressView()
        .transition(.opacity)
        
case .loaded(let data):
    ContentView(data: data)
        .transition(.opacity)
        
case .error:
    ErrorView()
        .transition(.opacity)
}
```

---

## 🎯 Best Practices

### ✅ DO
- Use constants for all spacing, colors, and icons
- Support both light and dark modes
- Add Xcode previews for all views
- Use `LazyVStack` for lists
- Animate state changes
- Test with different locales

### ❌ DON'T
- Hard-code spacing values
- Use fixed colors that don't adapt
- Create views without previews
- Use regular `VStack` for long lists
- Change state without animation
- Assume English-only text

---

## 📚 Additional Resources

- **SwiftUI Documentation**: [developer.apple.com/swiftui](https://developer.apple.com/swiftui)
- **SF Symbols Browser**: Available in Xcode
- **Human Interface Guidelines**: [developer.apple.com/design](https://developer.apple.com/design)
- **Accessibility**: [developer.apple.com/accessibility](https://developer.apple.com/accessibility)

---

## 🤝 Contributing

When adding new UI components:

1. Follow existing patterns from this guide
2. Use design tokens for all visual properties
3. Add comprehensive previews
4. Test in both light and dark mode
5. Ensure accessibility compliance
6. Update this guide if introducing new patterns

---

**Last Updated**: February 2, 2026
**Maintainer**: RevenueCat Team
