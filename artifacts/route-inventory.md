# Route Inventory - Venus One

Generated: 2026-02-09
Stack: Flutter Web + iOS + Android
Router: go_router ^14.8.0

## Summary

| Category | Count |
|----------|-------|
| Total Routes | 127 |
| Public Routes | 98 |
| Protected Routes | 7 |
| App Store Blocked | 22 |
| Legacy Redirects | 17 |

---

## Public Routes (No Auth Required)

### Core Navigation
| Path | Screen | Status | i18n |
|------|--------|--------|------|
| `/` | _SplashScreen | 200 | en,tr,de,fr |
| `/onboarding` | OnboardingScreen | 200 | en,tr,de,fr |
| `/home` | ResponsiveHomeScreen | 200 | en,tr,de,fr |
| `/insight` | InsightScreen | 200 | en,tr,de,fr |
| `/all-services` | AllServicesScreen | 200 | en,tr,de,fr |

### User Management
| Path | Screen | Status |
|------|--------|--------|
| `/profile` | ProfileScreen | 200 |
| `/settings` | SettingsScreen | 200 |
| `/saved-profiles` | SavedProfilesScreen | 200 |
| `/comparison` | ComparisonScreen | 200 |
| `/premium` | PremiumScreen | 200 |

### Horoscopes (App Store Blocked in Review Mode)
| Path | Screen | Blocked |
|------|--------|---------|
| `/horoscope` | HoroscopeScreen | YES |
| `/horoscope/:sign` | HoroscopeDetailScreen | YES |
| `/horoscope/weekly` | WeeklyHoroscopeScreen | YES |
| `/horoscope/weekly/:sign` | WeeklyHoroscopeScreen | YES |
| `/horoscope/monthly` | MonthlyHoroscopeScreen | YES |
| `/horoscope/monthly/:sign` | MonthlyHoroscopeScreen | YES |
| `/horoscope/yearly` | YearlyHoroscopeScreen | YES |
| `/horoscope/yearly/:sign` | YearlyHoroscopeScreen | YES |
| `/horoscope/love` | LoveHoroscopeScreen | YES |
| `/horoscope/love/:sign` | LoveHoroscopeScreen | YES |

### Astrology Features
| Path | Screen | Blocked |
|------|--------|---------|
| `/birth-chart` | NatalChartScreen | NO |
| `/compatibility` | CompatibilityScreen | NO |
| `/composite-chart` | CompositeChartScreen | NO |
| `/vedic-chart` | VedicChartScreen | NO |
| `/synastry` | SynastryScreen | NO |
| `/astro-cartography` | AstroCartographyScreen | NO |
| `/draconic-chart` | DraconicChartScreen | NO |
| `/asteroids` | AsteroidsScreen | NO |
| `/local-space` | LocalSpaceScreen | NO |
| `/progressions` | ProgressionsScreen | YES |
| `/saturn-return` | SaturnReturnScreen | YES |
| `/solar-return` | SolarReturnScreen | YES |
| `/year-ahead` | YearAheadScreen | YES |
| `/timing` | TimingScreen | YES |
| `/void-of-course` | VoidOfCourseScreen | YES |
| `/transits` | TransitsScreen | YES |
| `/transit-calendar` | TransitCalendarScreen | YES |
| `/eclipse-calendar` | EclipseCalendarScreen | YES |
| `/electional` | ElectionalScreen | YES |

### Numerology
| Path | Screen | Blocked |
|------|--------|---------|
| `/numerology` | NumerologyScreen | NO |
| `/numerology/life-path/:number` | LifePathDetailScreen | NO |
| `/numerology/master/:number` | MasterNumberScreen | NO |
| `/numerology/personal-year/:number` | PersonalYearScreen | YES |
| `/numerology/karmic-debt/:number` | KarmicDebtScreen | YES |

### Tarot
| Path | Screen |
|------|--------|
| `/tarot` | TarotScreen |
| `/tarot/major/:number` | MajorArcanaDetailScreen |
| `/kabbalah` | KabbalahScreen |

### Dreams
| Path | Screen |
|------|--------|
| `/dream-interpretation` | DreamInterpretationScreen |
| `/dream-glossary` | DreamGlossaryScreen |
| `/dream-share` | DreamShareScreen |
| `/dreams/falling` | DreamFallingScreen |
| `/dreams/water` | DreamWaterScreen |
| `/dreams/recurring` | DreamRecurringScreen |
| `/dreams/running` | DreamRunningScreen |
| `/dreams/flying` | DreamFlyingScreen |
| `/dreams/losing-someone` | DreamLosingScreen |
| `/dreams/darkness` | DreamDarknessScreen |
| `/dreams/someone-from-past` | DreamPastScreen |
| `/dreams/searching` | DreamSearchingScreen |
| `/dreams/voiceless` | DreamVoicelessScreen |
| `/dreams/lost` | DreamLostScreen |
| `/dreams/unable-to-fly` | DreamUnableToFlyScreen |

### Spiritual & Wellness
| Path | Screen |
|------|--------|
| `/aura` | AuraScreen |
| `/chakra-analysis` | ChakraAnalysisScreen |
| `/daily-rituals` | DailyRitualsScreen |
| `/tantra` | TantraScreen |
| `/tantra/micro-ritual` | TantraMicroRitualScreen |
| `/theta-healing` | ThetaHealingScreen |
| `/reiki` | ReikiScreen |
| `/crystal-guide` | CosmicDiscoveryScreen |
| `/moon-rituals` | CosmicDiscoveryScreen |

### Reference & Content
| Path | Screen |
|------|--------|
| `/glossary` | GlossaryScreen |
| `/gardening-moon` | GardeningMoonScreen |
| `/celebrities` | CelebritiesScreen |
| `/articles` | ArticlesScreen |
| `/quiz` | QuizScreen |
| `/content/:contentId` | ContentDetailScreen |

### Sharing
| Path | Screen |
|------|--------|
| `/share` | ScreenshotShareScreen |
| `/cosmic-share` | CosmicShareScreen |

### Cosmic Discovery
| Path | Screen |
|------|--------|
| `/discovery/daily-summary` | CosmicDiscoveryScreen |
| `/discovery/moon-energy` | CosmicDiscoveryScreen |
| `/discovery/love-energy` | CosmicDiscoveryScreen |
| `/discovery/abundance-energy` | CosmicDiscoveryScreen |
| `/discovery/spiritual-transformation` | CosmicDiscoveryScreen |
| `/discovery/life-purpose` | CosmicDiscoveryScreen |

---

## Protected Routes (Admin Auth Required)

| Path | Screen | Auth Type |
|------|--------|-----------|
| `/admin/login` | AdminLoginScreen | None (entry point) |
| `/admin` | AdminDashboardScreen | PIN (AdminAuthService) |
| `/admin/observatory` | ObservatoryScreen | PIN |
| `/admin/observatory/tech` | ObservatoryScreen | PIN |
| `/admin/observatory/language` | ObservatoryScreen | PIN |
| `/admin/observatory/content` | ObservatoryScreen | PIN |
| `/admin/observatory/safety` | ObservatoryScreen | PIN |

**Auth Flow:**
1. Navigate to `/admin` -> Redirects to `/admin/login` if not authenticated
2. Enter PIN (default: 4848)
3. Session valid for 24 hours
4. Rate limiting: 5 attempts, 15 min lockout

---

## Dynamic Route Parameters

### Zodiac Signs (:sign)
```
aries, taurus, gemini, cancer, leo, virgo,
libra, scorpio, sagittarius, capricorn, aquarius, pisces
```

### Life Path Numbers (:number)
```
1, 2, 3, 4, 5, 6, 7, 8, 9
```

### Master Numbers (:number)
```
11, 22, 33
```

### Karmic Debt Numbers (:number)
```
13, 14, 16, 19
```

### Personal Year Numbers (:number)
```
1, 2, 3, 4, 5, 6, 7, 8, 9
```

### Major Arcana (:number)
```
0 (Fool) to 21 (World)
```

---

## Legacy Redirects (SEO Backward Compatibility)

| Old Path (Turkish) | New Path (English) |
|-------------------|-------------------|
| `/ruya/dusmek` | `/dreams/falling` |
| `/ruya/su-gormek` | `/dreams/water` |
| `/ruya/tekrar-eden` | `/dreams/recurring` |
| `/ruya/kacmak` | `/dreams/running` |
| `/ruya/birini-kaybetmek` | `/dreams/losing-someone` |
| `/ruya/ucmak` | `/dreams/flying` |
| `/ruya/karanlik` | `/dreams/darkness` |
| `/ruya/gecmisten-biri` | `/dreams/someone-from-past` |
| `/ruya/bir-sey-aramak` | `/dreams/searching` |
| `/ruya/ses-cikaramamak` | `/dreams/voiceless` |
| `/ruya/kaybolmak` | `/dreams/lost` |
| `/ruya/ucamamak` | `/dreams/unable-to-fly` |
| `/kozmik/bugunku-tema` | `/cosmic/daily-theme` |
| `/kozmik-iletisim` | `/cosmic-chat` |
| `/ruya-dongusu` | `/dream-oracle` |
| `/tum-cozumlemeler` | `/all-services` |

---

## Deprecated Routes

| Path | Redirects To | Reason |
|------|--------------|--------|
| `/cosmic-chat` | `/insight` | App Store 4.3(b) compliance |
| `/dream-oracle` | `/insight` | App Store 4.3(b) compliance |

---

## Error Handling

**404 Not Found Screen:**
- Screen: `_NotFoundScreen`
- Shows path that was not found
- Offers "Return Home" and "Go to Insight" buttons
- i18n keys: `router.not_found_title`, `router.not_found_message`, `router.not_found_path`, `router.return_home`, `router.go_to_insight`

---

## App Store Review Mode

When `FeatureFlags.appStoreReviewMode = true`:
- 22 routes are blocked and redirect to `/insight`
- Blocked routes include all horoscopes, predictions, and fortune-telling features
- Safe routes (dreams, birth chart, glossary, etc.) remain accessible
