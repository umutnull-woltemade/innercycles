# InnerCycles - Codex Instructions

## Project Overview
InnerCycles is a Flutter iOS app focused on personal reflection, wellness, and mindfulness.

**CRITICAL: App Store 4.3(b) Compliance**
- NO astrology, horoscopes, zodiac predictions, birth charts
- Focus: Insight, Dreams, Wellness (Chakra, Aura, Rituals), Numerology (educational)
- App was pivoted from astrology app to pass Apple review

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
├── features/       # Feature modules (insight, dreams, wellness, etc.)
└── shared/         # Shared widgets and services
```

## Safe Features (App Store Compliant)
- `/insight` - AI-powered personal reflection
- `/dream-interpretation` - Dream journal
- `/chakra-analysis` - Wellness
- `/aura` - Energy awareness
- `/numerology` - Number patterns (educational)
- `/tarot` - Card symbolism (educational)
- `/daily-rituals` - Mindfulness practices

## FORBIDDEN (Removed for App Store)
- Horoscopes, daily/weekly/monthly readings
- Birth charts, natal charts
- Compatibility/synastry
- Transits, progressions
- Any zodiac-based predictions

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
