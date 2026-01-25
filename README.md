# Astrobobo - Mystical Astrology App

A comprehensive astrology application built with Flutter, offering daily horoscopes, birth chart analysis, compatibility readings, and spiritual wellness features.

## Features

### Core Astrology
- **Daily/Weekly/Monthly/Yearly Horoscopes** - Personalized readings for all zodiac signs
- **Birth Chart (Natal Chart)** - Complete astrological profile with planetary positions
- **Compatibility Analysis** - Synastry and composite chart comparisons
- **Transit Tracking** - Real-time planetary movements and their effects
- **Moon Phases** - Lunar calendar with spiritual guidance

### Advanced Tools
- **Numerology** - Life path, destiny, and personal year calculations
- **Tarot Readings** - Digital card spreads with interpretations
- **Kabbalah Analysis** - Tree of Life and Hebrew letter meanings
- **Aura Colors** - Energy field analysis based on birth data
- **Vedic Astrology** - Jyotish chart calculations

### Spiritual Wellness
- **Daily Rituals** - Morning and evening meditation guides
- **Chakra Analysis** - Energy center balancing recommendations
- **Dream Interpretation** - AI-powered dream analysis (APEX Dream Engine)
- **Kozmoz AI Assistant** - Personalized cosmic guidance

### User Features
- **Multi-Profile Support** - Track astrology for family and friends
- **Profile Comparison** - Compare charts between saved profiles
- **Customizable Settings** - Theme, language, notification preferences
- **Offline Support** - Core features work without internet

## Tech Stack

- **Framework:** Flutter 3.x (Dart)
- **Platforms:** iOS, Android, Web
- **State Management:** Riverpod
- **Navigation:** go_router
- **Local Storage:** Hive (encrypted)
- **Animations:** flutter_animate
- **Typography:** Google Fonts

## Getting Started

### Prerequisites
- Flutter SDK 3.10.4 or higher
- Dart SDK 3.0 or higher
- Xcode (for iOS)
- Android Studio (for Android)

### Installation

```bash
# Clone the repository
git clone https://github.com/umutnull-woltemade/astrobobo.git

# Navigate to project directory
cd astrobobo

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build Commands

```bash
# iOS
flutter build ios

# Android
flutter build apk
flutter build appbundle

# Web
flutter build web
```

## Project Structure

```
lib/
├── core/
│   ├── constants/     # App constants, routes, cosmic symbols
│   └── theme/         # Colors, typography, app theme
├── data/
│   ├── models/        # Data models (UserProfile, ZodiacSign, etc.)
│   ├── providers/     # Riverpod providers
│   └── services/      # API services, calculations, AI content
├── features/
│   ├── home/          # Main dashboard
│   ├── horoscope/     # Daily/weekly/monthly readings
│   ├── birth_chart/   # Natal chart analysis
│   ├── compatibility/ # Synastry features
│   ├── profile/       # User profile management
│   ├── kozmoz/        # AI assistant
│   └── ...            # Other feature modules
└── shared/
    └── widgets/       # Reusable UI components
```

## Supported Languages

- Turkish (Primary)
- English
- German
- Spanish
- French
- Arabic
- Russian
- Chinese
- Japanese
- Korean
- Portuguese
- Italian
- Hindi

## Screenshots

*Coming soon*

## Contributing

This is a private project. For inquiries, please contact the maintainers.

## License

All rights reserved. This project is proprietary software.

---

Built with Flutter
