# InnerCycles Visual System
## Premium Journaling App - Production Ready Assets

---

## 1. TRANSPARENT PLANET (BASE ASSET)

**File**: `app-logo/png/app-planet-transparent.png`
- Format: PNG with alpha channel
- Background: 100% transparent
- Planet preserved with all surface details
- Clean, sharp edges

---

## 2. APP STORE ICON VARIANTS

### Variant A - GLOW VERSION
**File**: `app-logo/png/app-appicon-glow-1024.png`
- Background: Deep space blue (#0B0F1A)
- Soft violet/purple glow around planet (~20% opacity)
- Color: #8B5CF6 (violet)
- Premium, premium feel
- Use for: Emotional, wellness-themed marketing

### Variant B - NO GLOW VERSION (RECOMMENDED)
**File**: `app-logo/png/app-appicon-noglow-1024.png`
- Background: Deep space blue (#0B0F1A)
- No glow - clean, sharp edge
- Ultra-minimal Apple-style
- Use for: Primary App Store icon

### A/B Testing Recommendation
- Start with NO-GLOW (cleaner, higher contrast)
- Test GLOW if conversion is low
- Monitor: Click-through rate, Install rate

---

## 3. COLOR PALETTE

### Primary Colors
| Name | Hex | Usage |
|------|-----|-------|
| Deep Space | #0B0F1A | App backgrounds, icons |
| Venus Pink | #E8A0B4 | Planet highlight color |
| Venus Rose | #C45C7D | Planet dark tones |
| Cosmic Violet | #8B5CF6 | Glow effects, accents |
| Cosmic Blue | #3498DB | Secondary glow |

### Text Colors
| Name | Hex | Usage |
|------|-----|-------|
| White | #FFFFFF | Primary text |
| White 70% | rgba(255,255,255,0.7) | Secondary text |
| White 50% | rgba(255,255,255,0.5) | Muted text |

---

## 4. SPLASH SCREEN ANIMATION CONCEPT

### Sequence (Duration: ~1 second)
1. **Frame 0-200ms**: Dark space background (#0B0F1A) fade in
2. **Frame 200-600ms**: Venus planet fades in with scale animation (0.95 → 1.0)
3. **Frame 400-1000ms**: Soft violet glow pulse (opacity 30% → 60% → 30%)
4. **Frame 600-1000ms**: Transition to main app UI

### Animation Parameters
```dart
// Breathing animation
scale: 0.95 + (value * 0.1)  // 0.95 to 1.05
glowOpacity: 0.3 + (value * 0.3)  // 0.3 to 0.6
duration: 2000ms (loop)
curve: easeInOut
```

### Rules
- No text on splash
- No logo names
- Calm, premium, elegant
- Suitable for Lottie / native animation

---

## 5. PAYWALL VISUAL LANGUAGE

### Layout
```
┌─────────────────────────────────────┐
│  [Dark Background #0B0F1A]          │
│                                     │
│         🪐 Venus Planet             │
│         (small, elegant)            │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  Free Plan (flat, no glow)  │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  ★ Premium (GLOW BORDER) ★  │ ←  │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  Lifetime (flat, no glow)   │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

### Visual Rules
- Dark background (#0B0F1A)
- Venus planet as hero visual (small, ~80px)
- Glow used ONLY on selected/recommended plan
- Non-selected plans remain flat
- Glow color: #8B5CF6 (violet)

### Psychology
- Glow = "correct choice"
- Calm luxury, no pressure
- No clutter, no aggressive colors
- Premium, trustworthy feeling

---

## 6. SCREENSHOT VISUAL DIRECTIONS

### For GLOW Icon Campaign
- Dark cosmic UI theme
- Subtle glowing accents
- Emotional, reflective tone
- Keywords: "Personal insights", "Discover yourself"

### For NO-GLOW Icon Campaign
- Cleaner, minimal UI
- Flat accents
- Calm, confident, premium tone
- Keywords: "Premium journaling", "Personal insights"

### Screenshot Requirements
- Consistent with icon style
- Readable at small sizes
- Emphasize "personal journaling experience"
- 6.5" iPhone size (1284 x 2778)

---

## 7. APPLE ICON COMPLIANCE

### Requirements Met
- Square canvas (1024x1024)
- Apple applies rounded corners automatically
- Planet within safe margins (150px from edges)
- Readable at small sizes (29x29)
- No important elements near edges

### Generated Sizes
**iOS**:
- 1024x1024 @1x (App Store)
- 180x180 @3x (60pt)
- 120x120 @2x, @3x (40pt, 60pt)
- 87x87 @3x (29pt)
- 80x80 @2x (40pt)
- 76x76, 152x152, 167x167 (iPad)
- 58x58, 40x40, 29x29, 20x20 (small)

**Android**:
- xxxhdpi: 192x192
- xxhdpi: 144x144
- xhdpi: 96x96
- hdpi: 72x72
- mdpi: 48x48

**Web**:
- 512x512, 192x192 (PWA)
- 16x16 (favicon)

---

## 8. EXPORT DELIVERABLES

### Completed Assets
1. ✅ Transparent planet PNG
2. ✅ App Icon 1024×1024 - Glow version
3. ✅ App Icon 1024×1024 - No-glow version
4. ✅ iOS icons (15 sizes)
5. ✅ Android icons (5 densities)
6. ✅ Web icons (5 files)
7. ✅ PWA icons (7 sizes)
8. ✅ Splash screen updated
9. ✅ Paywall visual guide (this document)

### File Locations
```
assets/brand/app-logo/
├── png/
│   ├── app-planet-transparent.png
│   ├── app-appicon-glow-1024.png
│   ├── app-appicon-noglow-1024.png
│   ├── app-logo-48.png
│   ├── app-logo-72.png
│   ├── app-logo-96.png
│   ├── app-logo-120.png
│   ├── app-logo-144.png
│   ├── app-logo-180.png
│   ├── app-logo-192.png
│   ├── app-logo-256.png
│   ├── app-logo-512.png
│   └── app-logo-1024.png
├── pwa/
│   ├── icon-48x48.png
│   ├── icon-72x72.png
│   ├── icon-96x96.png
│   ├── icon-144x144.png
│   ├── icon-192x192.png
│   ├── icon-384x384.png
│   └── icon-512x512.png
└── VISUAL_SYSTEM.md (this file)
```

---

## ABSOLUTE RULES

- ❌ Do NOT add text to the icon
- ❌ Do NOT add stars, rings, symbols
- ❌ Do NOT change the planet design
- ❌ Do NOT over-decorate
- ✅ Optimize for App Store performance
- ✅ Keep minimal, premium aesthetic

---

*Last updated: 2026-01-31*
*InnerCycles - Premium Journaling App*
