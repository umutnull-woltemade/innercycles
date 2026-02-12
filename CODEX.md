# InnerCycles - Codex Instructions

## Project Overview
InnerCycles is a Flutter iOS app focused on personal journaling, mood tracking, and wellness.

**CRITICAL: App Store 4.3(b) Compliance**
- Focus: Journaling, Mood Tracking, Dream Journal, Wellness, Pattern Analysis
- All content is reflective and educational — no predictions or forecasts

## Tech Stack
- Flutter 3.x / Dart
- Riverpod for state management
- GoRouter for navigation
- RevenueCat for subscriptions
- Firebase for analytics

## Key Directories
```
lib/
├── core/           # Constants, theme, config
├── data/           # Models, providers, services
├── features/       # Feature modules (journal, dreams, wellness, etc.)
└── shared/         # Shared widgets and services
```

## Core Features
- `/journal` - Daily mood journal with guided prompts
- `/dream-interpretation` - Dream journal with symbol library
- `/patterns` - Emotional pattern analysis over time
- `/wellness` - Wellness tools (chakra, aura, rituals)
- `/challenges` - Personal growth challenges
- `/daily-rituals` - Mindfulness practices

## Commands
```bash
# Build iOS
flutter build ios --no-codesign

# Analyze
flutter analyze

# Test
flutter test

# Run
flutter run
```

## Code Style
- Use `AppLanguage.en` / `AppLanguage.tr` for i18n
- Use `Routes.*` constants for navigation
- Use `AppColors.*` for theming
- Prefer `ConsumerWidget` for Riverpod
