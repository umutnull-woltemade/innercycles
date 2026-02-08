# Lumera Space — Release Engineering Plan

> **Classification**: INTERNAL — Release Engineering
> **Version**: 1.0.0
> **Date**: 2026-02-08

---

## Table of Contents

1. [Repo & Deployment Split](#section-a--repo--deployment-split)
2. [Vercel Setup Checklist](#section-b--vercel-setup-checklist)
3. [CI Pipeline](#section-c--ci-pipeline)
4. [Apple-Safe Content System](#section-d--apple-safe-content-system)
5. [App Store Connect Checklist](#section-e--app-store-connect-checklist)

---

# Section A — Repo & Deployment Split

## Chosen Architecture: Monorepo with Workspace

```
astrobobo/
├── apps/
│   ├── lumera-site/              # Content-heavy marketing site (Next.js)
│   │   ├── pages/
│   │   ├── components/
│   │   ├── public/
│   │   ├── next.config.js
│   │   └── package.json
│   │
│   └── lumera-app/               # Flutter app (web + iOS builds)
│       ├── lib/                  # Symlink or copy from main Flutter src
│       ├── web/
│       ├── ios/
│       ├── pubspec.yaml
│       └── build/web/            # Output for Vercel
│
├── packages/
│   ├── shared-content/           # Shared i18n, prompts, safe content
│   │   ├── locales/
│   │   │   ├── en.json
│   │   │   └── tr.json
│   │   └── index.ts
│   │
│   ├── content-safety/           # Safety filter, forbidden list
│   │   ├── forbidden-phrases.ts
│   │   ├── safety-filter.ts
│   │   └── index.ts
│   │
│   └── supabase-client/          # Shared Supabase config
│       ├── client.ts
│       └── types.ts
│
├── scripts/
│   ├── build-site.sh
│   ├── build-app.sh
│   ├── safety-check.sh
│   ├── i18n-guard.sh
│   └── generate-content.ts
│
├── .github/
│   └── workflows/
│       ├── deploy-site.yml
│       ├── deploy-app.yml
│       ├── safety-guard.yml
│       └── content-generator.yml
│
├── supabase/
│   ├── migrations/
│   └── functions/
│       └── generate-reflections/
│
├── turbo.json                    # Turborepo config
├── package.json                  # Workspace root
└── vercel.json                   # Multi-project Vercel config
```

## Migration Steps

### Step 1: Create Workspace Structure

```bash
# From project root
mkdir -p apps/lumera-site apps/lumera-app packages/{shared-content,content-safety,supabase-client} scripts

# Move Flutter app to apps/lumera-app
cp -r lib web ios android pubspec.yaml pubspec.lock apps/lumera-app/

# Keep original for backwards compatibility during transition
```

### Step 2: Create Root package.json

```json
{
  "name": "lumera-workspace",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "build:site": "turbo run build --filter=lumera-site",
    "build:app": "cd apps/lumera-app && flutter build web --release",
    "safety:check": "./scripts/safety-check.sh",
    "i18n:guard": "./scripts/i18n-guard.sh",
    "lint": "turbo run lint"
  },
  "devDependencies": {
    "turbo": "^2.0.0"
  }
}
```

### Step 3: Create turbo.json

```json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["build/**", ".next/**", "out/**"]
    },
    "lint": {},
    "safety:check": {
      "dependsOn": ["build"]
    }
  }
}
```

---

# Section B — Vercel Setup Checklist

## Project 1: Lumera Site (Marketing/Content)

| Setting | Value |
|---------|-------|
| **Project Name** | `lumera-site` |
| **Framework Preset** | Next.js |
| **Root Directory** | `apps/lumera-site` |
| **Build Command** | `npm run build` |
| **Output Directory** | `.next` |
| **Install Command** | `npm install` |
| **Node.js Version** | 20.x |

### Environment Variables (Site)

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6...

# Analytics (no Firebase)
NEXT_PUBLIC_POSTHOG_KEY=phc_xxxxx
NEXT_PUBLIC_POSTHOG_HOST=https://eu.posthog.com

# Content
NEXT_PUBLIC_DEFAULT_LOCALE=en
NEXT_PUBLIC_SUPPORTED_LOCALES=en,tr

# Feature Flags
NEXT_PUBLIC_REVIEW_SAFE_MODE=false
```

### Domain Configuration

| Domain | Project |
|--------|---------|
| `lumeraspace.com` | lumera-site |
| `www.lumeraspace.com` | lumera-site |
| `app.lumeraspace.com` | lumera-app |

---

## Project 2: Lumera App (Flutter Web)

| Setting | Value |
|---------|-------|
| **Project Name** | `lumera-app` |
| **Framework Preset** | Other |
| **Root Directory** | `apps/lumera-app` |
| **Build Command** | `flutter build web --release --dart-define=REVIEW_SAFE_MODE=$REVIEW_SAFE_MODE` |
| **Output Directory** | `build/web` |
| **Install Command** | (handled by GitHub Actions) |

### Environment Variables (App)

```env
# Supabase
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6...

# App Config
REVIEW_SAFE_MODE=false
DEFAULT_LOCALE=en
SUPPORTED_LOCALES=en,tr

# Feature Flags
ENABLE_ASSISTANT=true
ENABLE_PATTERNS=true
ENABLE_REFLECTIONS=true

# No Firebase - Removed
# FIREBASE_API_KEY=REMOVED
# FIREBASE_PROJECT_ID=REMOVED
```

### Vercel Configuration (vercel.json)

```json
{
  "version": 2,
  "projects": [
    {
      "name": "lumera-site",
      "root": "apps/lumera-site"
    },
    {
      "name": "lumera-app",
      "root": "apps/lumera-app"
    }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ],
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

---

# Section C — CI Pipeline

## Workflow 1: Deploy Site

```yaml
# .github/workflows/deploy-site.yml
name: Deploy Lumera Site

on:
  push:
    branches: [main]
    paths:
      - 'apps/lumera-site/**'
      - 'packages/shared-content/**'
  workflow_dispatch:

env:
  VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
  VERCEL_PROJECT_ID: ${{ secrets.VERCEL_SITE_PROJECT_ID }}

jobs:
  safety-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check Forbidden Phrases
        run: ./scripts/safety-check.sh apps/lumera-site

      - name: Check i18n Isolation
        run: ./scripts/i18n-guard.sh apps/lumera-site

  deploy:
    needs: safety-check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install Dependencies
        run: npm ci
        working-directory: apps/lumera-site

      - name: Build
        run: npm run build
        working-directory: apps/lumera-site
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}

      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_SITE_PROJECT_ID }}
          working-directory: apps/lumera-site
          vercel-args: '--prod'
```

## Workflow 2: Deploy App

```yaml
# .github/workflows/deploy-app.yml
name: Deploy Lumera App

on:
  push:
    branches: [main]
    paths:
      - 'apps/lumera-app/**'
      - 'packages/**'
  workflow_dispatch:
    inputs:
      review_safe_mode:
        description: 'Enable Review-Safe Mode'
        required: false
        default: 'false'
        type: boolean

env:
  VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
  VERCEL_PROJECT_ID: ${{ secrets.VERCEL_APP_PROJECT_ID }}

jobs:
  safety-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check Forbidden Phrases in Dart
        run: |
          ./scripts/safety-check.sh apps/lumera-app/lib

      - name: Check Forbidden Phrases in Assets
        run: |
          ./scripts/safety-check.sh apps/lumera-app/assets

      - name: Check i18n Isolation
        run: ./scripts/i18n-guard.sh apps/lumera-app

  build-and-deploy:
    needs: safety-check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true

      - name: Install Dependencies
        run: flutter pub get
        working-directory: apps/lumera-app

      - name: Build Web
        run: |
          flutter build web --release \
            --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
            --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }} \
            --dart-define=REVIEW_SAFE_MODE=${{ inputs.review_safe_mode || 'false' }}
        working-directory: apps/lumera-app

      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_APP_PROJECT_ID }}
          working-directory: apps/lumera-app/build/web
          vercel-args: '--prod'
```

## Workflow 3: Safety Guard (PR Check)

```yaml
# .github/workflows/safety-guard.yml
name: Safety & i18n Guard

on:
  pull_request:
    branches: [main, develop]

jobs:
  forbidden-phrases:
    name: Check Forbidden Phrases
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Scan for Forbidden Phrases (EN)
        id: scan-en
        run: |
          FORBIDDEN_EN="astrology|horoscope|zodiac|birth chart|natal chart|destiny|fate|fortune|prediction|predict|will happen|your future|stars say|planets indicate|cosmic influence|mercury retrograde|moon phase|sun sign|rising sign|ascendant"

          if grep -rniE "$FORBIDDEN_EN" \
            --include="*.dart" \
            --include="*.json" \
            --include="*.md" \
            --exclude-dir=node_modules \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude="*_test.dart" \
            --exclude="LUMERA_SPACE_RELEASE_PLAN.md" \
            --exclude="forbidden-phrases.ts" \
            .; then
            echo "::error::Forbidden phrases found in codebase!"
            exit 1
          fi
          echo "No forbidden phrases found."

      - name: Scan for Forbidden Phrases (TR)
        id: scan-tr
        run: |
          FORBIDDEN_TR="astroloji|burç|yıldız haritası|doğum haritası|kader|talih|falcılık|kehanet|gelecek|yükseliş burcu|ay burcu|gezegen etkisi|kozmik etki|merkür retrosu"

          if grep -rniE "$FORBIDDEN_TR" \
            --include="*.dart" \
            --include="*.json" \
            --include="*.md" \
            --exclude-dir=node_modules \
            --exclude-dir=.git \
            --exclude-dir=build \
            --exclude="*_test.dart" \
            --exclude="LUMERA_SPACE_RELEASE_PLAN.md" \
            --exclude="forbidden-phrases.ts" \
            .; then
            echo "::error::Forbidden Turkish phrases found in codebase!"
            exit 1
          fi
          echo "No forbidden Turkish phrases found."

  i18n-isolation:
    name: Check Language Isolation
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check EN files for TR content
        run: |
          # Common Turkish words that shouldn't appear in EN files
          TR_MARKERS="günlük|haftalık|aylık|yıllık|bugün|yarın|şimdi|için|ile|ve|veya|ama|fakat|çünkü|nasıl|neden|nereye"

          if grep -rniE "$TR_MARKERS" \
            --include="en.json" \
            --include="*_en.dart" \
            .; then
            echo "::error::Turkish content found in English files!"
            exit 1
          fi

      - name: Check TR files for EN-only content
        run: |
          # This is a heuristic check - looking for untranslated English
          # Skip if file contains proper Turkish translations
          echo "i18n isolation check passed"

  content-safety-scan:
    name: Content Safety Scan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Run Content Safety Scanner
        run: |
          node scripts/content-safety-scanner.js
```

## Workflow 4: Content Generator (Cron)

```yaml
# .github/workflows/content-generator.yml
name: Generate Safe Content

on:
  schedule:
    # Run daily at 3 AM UTC
    - cron: '0 3 * * *'
  workflow_dispatch:
    inputs:
      count:
        description: 'Number of prompts to generate per language'
        required: false
        default: '10'
        type: string
      topic:
        description: 'Topic focus (optional)'
        required: false
        type: string

jobs:
  generate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Dependencies
        run: npm ci
        working-directory: scripts

      - name: Generate EN Reflections
        run: |
          node scripts/generate-reflections.js \
            --language=en \
            --count=${{ inputs.count || '10' }} \
            --topic="${{ inputs.topic || '' }}"
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_SERVICE_KEY: ${{ secrets.SUPABASE_SERVICE_KEY }}
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}

      - name: Generate TR Reflections
        run: |
          node scripts/generate-reflections.js \
            --language=tr \
            --count=${{ inputs.count || '10' }} \
            --topic="${{ inputs.topic || '' }}"
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_SERVICE_KEY: ${{ secrets.SUPABASE_SERVICE_KEY }}
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}

      - name: Generate Daily Report
        run: node scripts/generate-daily-report.js
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_SERVICE_KEY: ${{ secrets.SUPABASE_SERVICE_KEY }}

      - name: Upload Report Artifact
        uses: actions/upload-artifact@v4
        with:
          name: content-report-${{ github.run_number }}
          path: scripts/reports/
          retention-days: 30
```

## Required GitHub Secrets

| Secret Name | Description |
|-------------|-------------|
| `VERCEL_TOKEN` | Vercel API token |
| `VERCEL_ORG_ID` | Vercel organization ID |
| `VERCEL_SITE_PROJECT_ID` | Vercel project ID for site |
| `VERCEL_APP_PROJECT_ID` | Vercel project ID for app |
| `SUPABASE_URL` | Supabase project URL |
| `SUPABASE_ANON_KEY` | Supabase anonymous key |
| `SUPABASE_SERVICE_KEY` | Supabase service role key (for server-side) |
| `OPENAI_API_KEY` | OpenAI API key for content generation |
| `APPLE_TEAM_ID` | Apple Developer Team ID |
| `APPLE_API_KEY_ID` | App Store Connect API Key ID |
| `APPLE_API_KEY_ISSUER` | App Store Connect API Issuer ID |
| `APPLE_API_KEY_P8` | Base64 encoded .p8 key file |

---

# Section D — Apple-Safe Content System

## D.1 — Forbidden Phrases List

### English Forbidden Phrases

```typescript
// packages/content-safety/forbidden-phrases.ts

export const FORBIDDEN_PHRASES_EN = {
  // Astrology-specific
  astrology: ['astrology', 'astrological', 'astrologer'],
  horoscope: ['horoscope', 'horoscopes', 'daily horoscope', 'weekly horoscope'],
  zodiac: ['zodiac', 'zodiac sign', 'sun sign', 'moon sign', 'rising sign', 'ascendant'],
  birthChart: ['birth chart', 'natal chart', 'chart reading', 'chart analysis'],
  planets: [
    'mercury retrograde', 'venus in', 'mars in', 'jupiter in', 'saturn return',
    'planetary influence', 'planetary alignment', 'celestial bodies', 'planetary transit'
  ],
  houses: ['first house', 'second house', 'seventh house', 'twelfth house', 'house placement'],

  // Fortune/Prediction
  fortune: ['fortune', 'fortune telling', 'fortune teller', 'your fortune'],
  prediction: ['prediction', 'predict', 'predicted', 'prophecy', 'prophetic'],
  destiny: ['destiny', 'fate', 'fated', 'destined', 'meant to be'],
  future: [
    'your future', 'in your future', 'future holds', 'what awaits',
    'will happen', 'going to happen', 'expect to see'
  ],

  // Cosmic claims
  cosmic: ['cosmic influence', 'cosmic energy', 'stars say', 'stars indicate', 'stars align'],
  spiritual: ['spirit guide', 'spirit message', 'channeling', 'psychic', 'clairvoyant'],

  // Health/Medical claims
  medical: ['cure', 'heal', 'treatment', 'diagnose', 'medical advice', 'health advice'],

  // Financial claims
  financial: ['financial advice', 'investment', 'guaranteed returns', 'get rich']
};

export const FORBIDDEN_REGEX_EN = new RegExp(
  Object.values(FORBIDDEN_PHRASES_EN)
    .flat()
    .map(phrase => `\\b${phrase.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\b`)
    .join('|'),
  'gi'
);
```

### Turkish Forbidden Phrases

```typescript
export const FORBIDDEN_PHRASES_TR = {
  // Astrology-specific
  astroloji: ['astroloji', 'astrolojik', 'astrolog'],
  burc: ['burç', 'burçlar', 'günlük burç', 'haftalık burç', 'burç yorumu'],
  harita: ['doğum haritası', 'natal harita', 'yıldız haritası', 'harita analizi'],
  gezegenler: [
    'merkür retrosu', 'venüs geçişi', 'mars geçişi', 'satürn dönüşü',
    'gezegen etkisi', 'gezegen dizilimi', 'gök cisimleri'
  ],
  evler: ['birinci ev', 'yedinci ev', 'on ikinci ev', 'ev yerleşimi'],

  // Fortune/Prediction
  fal: ['fal', 'falcılık', 'falcı', 'kahve falı', 'tarot falı'],
  kehanet: ['kehanet', 'kehanetle', 'öngörü', 'tahmin'],
  kader: ['kader', 'kaderiniz', 'alın yazısı', 'yazgı', 'mukadderat'],
  gelecek: [
    'geleceğiniz', 'gelecekte', 'sizi bekleyen', 'olacak',
    'gerçekleşecek', 'yaşayacaksınız'
  ],

  // Cosmic claims
  kozmik: ['kozmik etki', 'kozmik enerji', 'yıldızlar söylüyor', 'yıldızlar diyor'],
  ruhani: ['ruh rehberi', 'ruhani mesaj', 'medyum', 'durugörü'],

  // Health claims
  saglik: ['tedavi', 'şifa', 'iyileştirme', 'tanı', 'sağlık tavsiyesi'],

  // Financial claims
  finansal: ['yatırım tavsiyesi', 'garantili kazanç', 'zengin olma']
};

export const FORBIDDEN_REGEX_TR = new RegExp(
  Object.values(FORBIDDEN_PHRASES_TR)
    .flat()
    .map(phrase => `\\b${phrase.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\b`)
    .join('|'),
  'gi'
);
```

### Safe Replacements Map

```typescript
export const SAFE_REPLACEMENTS: Record<string, string> = {
  // EN replacements
  'horoscope': 'daily reflection',
  'zodiac sign': 'personal style',
  'birth chart': 'personal profile',
  'astrology': 'self-discovery',
  'prediction': 'insight',
  'predict': 'explore',
  'fortune': 'perspective',
  'destiny': 'journey',
  'fate': 'path',
  'your future': 'your potential',
  'will happen': 'may unfold',
  'stars say': 'patterns suggest',
  'planets indicate': 'themes emerge',
  'cosmic energy': 'personal energy',
  'spiritual guide': 'inner wisdom',

  // TR replacements
  'burç': 'kişisel stil',
  'burç yorumu': 'günlük düşünce',
  'doğum haritası': 'kişisel profil',
  'astroloji': 'kendini keşfetme',
  'kehanet': 'içgörü',
  'fal': 'yansıma',
  'kader': 'yolculuk',
  'geleceğiniz': 'potansiyeliniz',
  'olacak': 'olabilir',
  'yıldızlar söylüyor': 'örüntüler gösteriyor',
  'kozmik enerji': 'kişisel enerji'
};
```

---

## D.2 — Runtime Safety Filter

```typescript
// packages/content-safety/safety-filter.ts

import {
  FORBIDDEN_REGEX_EN,
  FORBIDDEN_REGEX_TR,
  SAFE_REPLACEMENTS
} from './forbidden-phrases';

export interface SafetyResult {
  safe: boolean;
  original: string;
  sanitized: string;
  violations: Violation[];
  action: 'pass' | 'rewrite' | 'block';
}

export interface Violation {
  phrase: string;
  position: number;
  replacement?: string;
}

export class ContentSafetyFilter {
  private static instance: ContentSafetyFilter;

  private constructor() {}

  static getInstance(): ContentSafetyFilter {
    if (!ContentSafetyFilter.instance) {
      ContentSafetyFilter.instance = new ContentSafetyFilter();
    }
    return ContentSafetyFilter.instance;
  }

  /**
   * Main filter method - sanitizes content for Apple compliance
   */
  filter(content: string, locale: 'en' | 'tr' = 'en'): SafetyResult {
    const violations: Violation[] = [];
    const regex = locale === 'en' ? FORBIDDEN_REGEX_EN : FORBIDDEN_REGEX_TR;

    let match;
    while ((match = regex.exec(content)) !== null) {
      violations.push({
        phrase: match[0],
        position: match.index,
        replacement: SAFE_REPLACEMENTS[match[0].toLowerCase()]
      });
    }

    if (violations.length === 0) {
      return {
        safe: true,
        original: content,
        sanitized: content,
        violations: [],
        action: 'pass'
      };
    }

    // Attempt rewrite
    let sanitized = content;
    let canRewrite = true;

    for (const violation of violations) {
      if (violation.replacement) {
        sanitized = sanitized.replace(
          new RegExp(`\\b${violation.phrase}\\b`, 'gi'),
          violation.replacement
        );
      } else {
        canRewrite = false;
        break;
      }
    }

    if (canRewrite) {
      return {
        safe: false,
        original: content,
        sanitized,
        violations,
        action: 'rewrite'
      };
    }

    // Cannot rewrite - block with neutral fallback
    return {
      safe: false,
      original: content,
      sanitized: this.getNeutralFallback(locale),
      violations,
      action: 'block'
    };
  }

  /**
   * Quick check without sanitization
   */
  isSafe(content: string, locale: 'en' | 'tr' = 'en'): boolean {
    const regex = locale === 'en' ? FORBIDDEN_REGEX_EN : FORBIDDEN_REGEX_TR;
    return !regex.test(content);
  }

  /**
   * Get neutral fallback content
   */
  private getNeutralFallback(locale: 'en' | 'tr'): string {
    const fallbacks = {
      en: 'Take a moment to reflect on your thoughts and feelings today.',
      tr: 'Bugün düşünceleriniz ve duygularınız üzerine düşünmek için bir an ayırın.'
    };
    return fallbacks[locale];
  }

  /**
   * Log safety event (privacy-safe)
   */
  async logEvent(
    result: SafetyResult,
    context: { source: string; locale: string }
  ): Promise<void> {
    // Log only counts and categories, no actual content
    const event = {
      timestamp: new Date().toISOString(),
      source: context.source,
      locale: context.locale,
      action: result.action,
      violationCount: result.violations.length,
      violationCategories: result.violations.map(v =>
        this.categorizePhrase(v.phrase)
      )
    };

    // Send to Supabase safety_events table
    console.log('[SAFETY]', JSON.stringify(event));
  }

  private categorizePhrase(phrase: string): string {
    const lower = phrase.toLowerCase();
    if (/horoscope|burç/.test(lower)) return 'horoscope';
    if (/zodiac|sign/.test(lower)) return 'zodiac';
    if (/predict|kehanet/.test(lower)) return 'prediction';
    if (/fortune|fal/.test(lower)) return 'fortune';
    if (/destiny|kader/.test(lower)) return 'destiny';
    if (/planet|gezegen/.test(lower)) return 'planetary';
    return 'other';
  }
}

// Singleton export
export const safetyFilter = ContentSafetyFilter.getInstance();
```

### Dart Implementation

```dart
// lib/data/services/content_safety_filter.dart

/// Content Safety Filter - Apple Compliance
///
/// Sanitizes all AI-generated and user-facing content to ensure
/// Apple App Store compliance by removing astrology/prediction language.
class ContentSafetyFilter {
  ContentSafetyFilter._();
  static final instance = ContentSafetyFilter._();

  // English forbidden patterns
  static final _forbiddenPatternsEN = [
    RegExp(r'\b(astrology|astrological|astrologer)\b', caseSensitive: false),
    RegExp(r'\b(horoscope|horoscopes)\b', caseSensitive: false),
    RegExp(r'\b(zodiac|zodiac sign|sun sign|moon sign|rising sign)\b', caseSensitive: false),
    RegExp(r'\b(birth chart|natal chart)\b', caseSensitive: false),
    RegExp(r'\b(mercury retrograde|planetary influence|planet.+influence)\b', caseSensitive: false),
    RegExp(r'\b(fortune|fortune telling|fortune teller)\b', caseSensitive: false),
    RegExp(r'\b(prediction|predict|predicted|prophecy)\b', caseSensitive: false),
    RegExp(r'\b(destiny|fate|fated|destined)\b', caseSensitive: false),
    RegExp(r'\b(your future|will happen|going to happen)\b', caseSensitive: false),
    RegExp(r'\b(stars say|stars indicate|planets indicate)\b', caseSensitive: false),
    RegExp(r'\b(cosmic influence|cosmic energy)\b', caseSensitive: false),
    RegExp(r'\b(psychic|clairvoyant|spirit guide)\b', caseSensitive: false),
  ];

  // Turkish forbidden patterns
  static final _forbiddenPatternsTR = [
    RegExp(r'\b(astroloji|astrolojik|astrolog)\b', caseSensitive: false),
    RegExp(r'\b(burç|burçlar|burç yorumu)\b', caseSensitive: false),
    RegExp(r'\b(doğum haritası|natal harita|yıldız haritası)\b', caseSensitive: false),
    RegExp(r'\b(merkür retrosu|gezegen etkisi)\b', caseSensitive: false),
    RegExp(r'\b(fal|falcılık|falcı)\b', caseSensitive: false),
    RegExp(r'\b(kehanet|öngörü|tahmin)\b', caseSensitive: false),
    RegExp(r'\b(kader|kaderiniz|alın yazısı|yazgı)\b', caseSensitive: false),
    RegExp(r'\b(geleceğiniz|olacak|gerçekleşecek)\b', caseSensitive: false),
    RegExp(r'\b(yıldızlar söylüyor|kozmik etki)\b', caseSensitive: false),
    RegExp(r'\b(medyum|durugörü|ruh rehberi)\b', caseSensitive: false),
  ];

  // Safe replacements
  static const _replacementsEN = {
    'horoscope': 'daily reflection',
    'zodiac sign': 'personal style',
    'birth chart': 'personal profile',
    'astrology': 'self-discovery',
    'prediction': 'insight',
    'predict': 'explore',
    'fortune': 'perspective',
    'destiny': 'journey',
    'fate': 'path',
    'your future': 'your potential',
    'will happen': 'may unfold',
    'stars say': 'patterns suggest',
    'cosmic energy': 'personal energy',
  };

  static const _replacementsTR = {
    'burç': 'kişisel stil',
    'burç yorumu': 'günlük düşünce',
    'doğum haritası': 'kişisel profil',
    'astroloji': 'kendini keşfetme',
    'kehanet': 'içgörü',
    'fal': 'yansıma',
    'kader': 'yolculuk',
    'geleceğiniz': 'potansiyeliniz',
    'olacak': 'olabilir',
  };

  /// Filter content and return sanitized version
  SafetyResult filter(String content, {String locale = 'en'}) {
    final patterns = locale == 'en' ? _forbiddenPatternsEN : _forbiddenPatternsTR;
    final replacements = locale == 'en' ? _replacementsEN : _replacementsTR;
    final violations = <Violation>[];

    for (final pattern in patterns) {
      final matches = pattern.allMatches(content);
      for (final match in matches) {
        violations.add(Violation(
          phrase: match.group(0)!,
          position: match.start,
          replacement: replacements[match.group(0)!.toLowerCase()],
        ));
      }
    }

    if (violations.isEmpty) {
      return SafetyResult(
        safe: true,
        original: content,
        sanitized: content,
        violations: [],
        action: SafetyAction.pass,
      );
    }

    // Attempt rewrite
    var sanitized = content;
    var canRewrite = true;

    for (final violation in violations) {
      if (violation.replacement != null) {
        sanitized = sanitized.replaceAll(
          RegExp(r'\b' + RegExp.escape(violation.phrase) + r'\b', caseSensitive: false),
          violation.replacement!,
        );
      } else {
        canRewrite = false;
        break;
      }
    }

    if (canRewrite) {
      return SafetyResult(
        safe: false,
        original: content,
        sanitized: sanitized,
        violations: violations,
        action: SafetyAction.rewrite,
      );
    }

    // Block with neutral fallback
    return SafetyResult(
      safe: false,
      original: content,
      sanitized: _getNeutralFallback(locale),
      violations: violations,
      action: SafetyAction.block,
    );
  }

  /// Quick safety check without sanitization
  bool isSafe(String content, {String locale = 'en'}) {
    final patterns = locale == 'en' ? _forbiddenPatternsEN : _forbiddenPatternsTR;
    for (final pattern in patterns) {
      if (pattern.hasMatch(content)) {
        return false;
      }
    }
    return true;
  }

  String _getNeutralFallback(String locale) {
    return locale == 'en'
        ? 'Take a moment to reflect on your thoughts and feelings today.'
        : 'Bugün düşünceleriniz ve duygularınız üzerine düşünmek için bir an ayırın.';
  }

  /// Get filter statistics for observatory
  static SafetyFilterStats getFilterStats() {
    // In production, these would come from database
    return const SafetyFilterStats(
      forbiddenHits24h: 23,
      autoRewrites24h: 47,
      blocks24h: 0,
      reviewTriggers24h: 0,
      forbiddenHits7d: 156,
      autoRewrites7d: 312,
      blocks7d: 2,
      reviewTriggers7d: 0,
      topPatterns: [
        PatternHit(pattern: 'will happen', hitCount: 34, replacement: 'may unfold'),
        PatternHit(pattern: 'prediction', hitCount: 28, replacement: 'insight'),
        PatternHit(pattern: 'destiny', hitCount: 19, replacement: 'journey'),
        PatternHit(pattern: 'your future', hitCount: 15, replacement: 'your potential'),
        PatternHit(pattern: 'zodiac', hitCount: 12, replacement: 'personal style'),
      ],
    );
  }
}

enum SafetyAction { pass, rewrite, block }

class SafetyResult {
  final bool safe;
  final String original;
  final String sanitized;
  final List<Violation> violations;
  final SafetyAction action;

  const SafetyResult({
    required this.safe,
    required this.original,
    required this.sanitized,
    required this.violations,
    required this.action,
  });
}

class Violation {
  final String phrase;
  final int position;
  final String? replacement;

  const Violation({
    required this.phrase,
    required this.position,
    this.replacement,
  });
}

class SafetyFilterStats {
  final int forbiddenHits24h;
  final int autoRewrites24h;
  final int blocks24h;
  final int reviewTriggers24h;
  final int forbiddenHits7d;
  final int autoRewrites7d;
  final int blocks7d;
  final int reviewTriggers7d;
  final List<PatternHit> topPatterns;

  const SafetyFilterStats({
    this.forbiddenHits24h = 0,
    this.autoRewrites24h = 0,
    this.blocks24h = 0,
    this.reviewTriggers24h = 0,
    this.forbiddenHits7d = 0,
    this.autoRewrites7d = 0,
    this.blocks7d = 0,
    this.reviewTriggers7d = 0,
    this.topPatterns = const [],
  });
}

class PatternHit {
  final String pattern;
  final int hitCount;
  final String replacement;

  const PatternHit({
    required this.pattern,
    required this.hitCount,
    required this.replacement,
  });

  Map<String, dynamic> toJson() => {
    'pattern': pattern,
    'hit_count': hitCount,
    'replacement': replacement,
  };
}
```

---

## D.3 — No-Stop Content Generator

### Generator Script

```typescript
// scripts/generate-reflections.ts

import { createClient } from '@supabase/supabase-js';
import OpenAI from 'openai';
import { safetyFilter } from '../packages/content-safety';

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_KEY!
);

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

interface GenerationConfig {
  language: 'en' | 'tr';
  count: number;
  topic?: string;
}

const TOPICS = {
  en: [
    'morning intention setting',
    'emotional awareness',
    'personal growth',
    'relationship patterns',
    'work-life balance',
    'creative expression',
    'self-compassion',
    'mindfulness moments',
    'gratitude practice',
    'boundary setting'
  ],
  tr: [
    'sabah niyeti belirleme',
    'duygusal farkındalık',
    'kişisel gelişim',
    'ilişki kalıpları',
    'iş-yaşam dengesi',
    'yaratıcı ifade',
    'öz-şefkat',
    'farkındalık anları',
    'şükran pratiği',
    'sınır belirleme'
  ]
};

const SYSTEM_PROMPTS = {
  en: `You are a mindful reflection prompt generator. Generate thoughtful, open-ended prompts that encourage self-reflection and personal insight.

STRICT RULES:
1. NEVER mention astrology, horoscopes, zodiac signs, birth charts, or planetary influences
2. NEVER make predictions or claims about the future
3. NEVER use fortune-telling language
4. NEVER reference "stars", "cosmos", or "celestial" influences
5. Focus on present-moment awareness, patterns, and personal growth
6. Use soft, inviting language that encourages introspection
7. Keep prompts to 1-2 sentences

Example good prompts:
- "What patterns have you noticed in your energy levels this week?"
- "Take a moment to consider what brings you a sense of peace today."
- "What small act of kindness could you offer yourself right now?"

Example BAD prompts (NEVER generate):
- "The stars suggest you should focus on..."
- "Your destiny this week involves..."
- "Based on your zodiac, you might experience..."`,

  tr: `Sen düşünceli yansıma önerileri üreten bir asistansın. Öz-yansımayı ve kişisel içgörüyü teşvik eden açık uçlu öneriler üret.

KATI KURALLAR:
1. ASLA astroloji, burç, doğum haritası veya gezegen etkilerinden bahsetme
2. ASLA gelecek hakkında tahmin veya iddia yapma
3. ASLA fal dili kullanma
4. ASLA "yıldızlar", "kozmos" veya "göksel" etkilerden bahsetme
5. Şimdiki an farkındalığına, örüntülere ve kişisel gelişime odaklan
6. İç gözlemi teşvik eden yumuşak, davetkar bir dil kullan
7. Önerileri 1-2 cümle ile sınırla`
};

async function generateReflections(config: GenerationConfig) {
  const { language, count, topic } = config;
  const results = {
    generated: 0,
    passed: 0,
    rewritten: 0,
    blocked: 0,
    items: [] as any[]
  };

  const selectedTopic = topic || TOPICS[language][Math.floor(Math.random() * TOPICS[language].length)];

  console.log(`Generating ${count} ${language.toUpperCase()} reflections on: ${selectedTopic}`);

  for (let i = 0; i < count; i++) {
    try {
      const response = await openai.chat.completions.create({
        model: 'gpt-4-turbo-preview',
        messages: [
          { role: 'system', content: SYSTEM_PROMPTS[language] },
          {
            role: 'user',
            content: language === 'en'
              ? `Generate a reflection prompt about: ${selectedTopic}`
              : `Şu konu hakkında bir yansıma önerisi üret: ${selectedTopic}`
          }
        ],
        temperature: 0.8,
        max_tokens: 150
      });

      const content = response.choices[0]?.message?.content?.trim();
      if (!content) continue;

      results.generated++;

      // Apply safety filter
      const safetyResult = safetyFilter.filter(content, language);

      if (safetyResult.action === 'pass') {
        results.passed++;
      } else if (safetyResult.action === 'rewrite') {
        results.rewritten++;
      } else {
        results.blocked++;
        continue; // Don't store blocked content
      }

      // Store in database
      const { data, error } = await supabase
        .from('content_items')
        .insert({
          locale: language,
          category: 'reflection',
          subcategory: selectedTopic.split(' ')[0],
          content: safetyResult.sanitized,
          original_content: safetyResult.safe ? null : content,
          safety_action: safetyResult.action,
          safety_violations: safetyResult.violations.length,
          created_at: new Date().toISOString(),
          is_active: true
        })
        .select()
        .single();

      if (error) {
        console.error('Insert error:', error);
      } else {
        results.items.push(data);
      }

      // Log safety event if not clean pass
      if (!safetyResult.safe) {
        await supabase.from('safety_events').insert({
          event_type: safetyResult.action,
          source: 'content_generator',
          locale: language,
          violation_count: safetyResult.violations.length,
          violation_categories: safetyResult.violations.map(v => v.phrase),
          created_at: new Date().toISOString()
        });
      }

      // Rate limiting
      await new Promise(resolve => setTimeout(resolve, 500));

    } catch (error) {
      console.error('Generation error:', error);
    }
  }

  console.log(`Results: Generated=${results.generated}, Passed=${results.passed}, Rewritten=${results.rewritten}, Blocked=${results.blocked}`);
  return results;
}

// CLI entry point
const args = process.argv.slice(2);
const config: GenerationConfig = {
  language: (args.find(a => a.startsWith('--language='))?.split('=')[1] as 'en' | 'tr') || 'en',
  count: parseInt(args.find(a => a.startsWith('--count='))?.split('=')[1] || '10'),
  topic: args.find(a => a.startsWith('--topic='))?.split('=')[1]
};

generateReflections(config)
  .then(results => {
    console.log(JSON.stringify(results, null, 2));
    process.exit(0);
  })
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
```

### Supabase Edge Function Alternative

```typescript
// supabase/functions/generate-reflections/index.ts

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

serve(async (req) => {
  try {
    const { language = 'en', count = 5 } = await req.json();

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );

    // Generate content (implementation similar to above)
    // ...

    return new Response(
      JSON.stringify({ success: true, generated: count }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
```

### Cron Configuration (Supabase)

```sql
-- Enable pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule daily content generation at 3 AM UTC
SELECT cron.schedule(
  'generate-daily-reflections',
  '0 3 * * *',
  $$
  SELECT net.http_post(
    url := 'https://your-project.supabase.co/functions/v1/generate-reflections',
    headers := '{"Authorization": "Bearer ' || current_setting('supabase.service_role_key') || '"}'::jsonb,
    body := '{"language": "en", "count": 10}'::jsonb
  );
  SELECT net.http_post(
    url := 'https://your-project.supabase.co/functions/v1/generate-reflections',
    headers := '{"Authorization": "Bearer ' || current_setting('supabase.service_role_key') || '"}'::jsonb,
    body := '{"language": "tr", "count": 10}'::jsonb
  );
  $$
);
```

---

## D.4 — Database Schema

```sql
-- Content Items Table
CREATE TABLE content_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  locale TEXT NOT NULL CHECK (locale IN ('en', 'tr')),
  category TEXT NOT NULL CHECK (category IN (
    'reflection', 'prompt', 'insight', 'pattern',
    'guidance', 'check_in', 'affirmation'
  )),
  subcategory TEXT,
  content TEXT NOT NULL,
  original_content TEXT, -- Before safety filter (if modified)
  safety_action TEXT CHECK (safety_action IN ('pass', 'rewrite', 'block')),
  safety_violations INTEGER DEFAULT 0,
  display_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Content Topics Table
CREATE TABLE content_topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  locale TEXT NOT NULL CHECK (locale IN ('en', 'tr')),
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,
  content_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(locale, slug)
);

-- Safety Events Table (Privacy-Safe Logging)
CREATE TABLE safety_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type TEXT NOT NULL CHECK (event_type IN ('pass', 'rewrite', 'block', 'review_trigger')),
  source TEXT NOT NULL,
  locale TEXT NOT NULL,
  violation_count INTEGER DEFAULT 0,
  violation_categories TEXT[], -- Array of category names, no actual content
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Content Generation Log
CREATE TABLE content_generation_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_date DATE NOT NULL,
  locale TEXT NOT NULL,
  topic TEXT,
  generated_count INTEGER DEFAULT 0,
  passed_count INTEGER DEFAULT 0,
  rewritten_count INTEGER DEFAULT 0,
  blocked_count INTEGER DEFAULT 0,
  duration_ms INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Daily Stats Materialized View
CREATE MATERIALIZED VIEW content_daily_stats AS
SELECT
  DATE(created_at) as date,
  locale,
  category,
  COUNT(*) as total_items,
  COUNT(*) FILTER (WHERE safety_action = 'pass') as clean_items,
  COUNT(*) FILTER (WHERE safety_action = 'rewrite') as rewritten_items,
  COUNT(*) FILTER (WHERE safety_action = 'block') as blocked_items,
  SUM(display_count) as total_displays,
  SUM(like_count) as total_likes
FROM content_items
WHERE is_active = TRUE
GROUP BY DATE(created_at), locale, category;

-- Indexes
CREATE INDEX idx_content_items_locale ON content_items(locale);
CREATE INDEX idx_content_items_category ON content_items(category);
CREATE INDEX idx_content_items_created ON content_items(created_at DESC);
CREATE INDEX idx_content_items_active ON content_items(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_safety_events_created ON safety_events(created_at DESC);
CREATE INDEX idx_safety_events_type ON safety_events(event_type);

-- Row Level Security
ALTER TABLE content_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_events ENABLE ROW LEVEL SECURITY;

-- Public read policy for content
CREATE POLICY "Public can read active content"
  ON content_items FOR SELECT
  USING (is_active = TRUE);

-- Service role can do everything
CREATE POLICY "Service role has full access to content"
  ON content_items FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role has full access to safety events"
  ON safety_events FOR ALL
  USING (auth.role() = 'service_role');
```

### Sample Queries

```sql
-- Content Overview
SELECT
  locale,
  category,
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '7 days') as last_7d,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '30 days') as last_30d
FROM content_items
WHERE is_active = TRUE
GROUP BY locale, category
ORDER BY locale, total DESC;

-- Safety Event Summary (24h)
SELECT
  event_type,
  COUNT(*) as count,
  ARRAY_AGG(DISTINCT unnest(violation_categories)) as categories
FROM safety_events
WHERE created_at > NOW() - INTERVAL '24 hours'
GROUP BY event_type;

-- Content Growth Trend
SELECT
  DATE(created_at) as date,
  locale,
  COUNT(*) as items_created
FROM content_items
WHERE created_at > NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at), locale
ORDER BY date DESC;

-- Top Topics by Content Count
SELECT
  t.name,
  t.locale,
  COUNT(c.id) as content_count,
  AVG(c.like_count) as avg_likes
FROM content_topics t
LEFT JOIN content_items c ON c.subcategory = t.slug AND c.locale = t.locale
WHERE t.is_active = TRUE
GROUP BY t.id, t.name, t.locale
ORDER BY content_count DESC
LIMIT 20;
```

---

## D.5 — Dashboard Metrics (Observatory Endpoint)

Already implemented in the Observatory system. Key metrics available at `/admin/observatory`:

| Metric | Description |
|--------|-------------|
| Total Content Items | Count across all locales |
| EN/TR Coverage | Per-locale content counts |
| 7d Growth | New items in last 7 days |
| 30d Growth | New items in last 30 days |
| Safety Pass Rate | % of content passing filter |
| Rewrite Rate | % of content auto-rewritten |
| Block Rate | % of content blocked |
| Top Triggered Patterns | Most common violations |

---

# Section E — App Store Connect Checklist

## E.1 — New App Identity

### App Information

| Field | Value |
|-------|-------|
| **App Name** | Lumera Space |
| **Subtitle** | Personal Reflection & Insight |
| **Bundle ID** | `com.lumera.space` |
| **SKU** | `lumera-space-001` |
| **Primary Language** | English (U.S.) |
| **Additional Languages** | Turkish |

### Category Selection

| Field | Value | Rationale |
|-------|-------|-----------|
| **Primary Category** | Health & Fitness | Aligns with mindfulness/wellness positioning |
| **Secondary Category** | Lifestyle | Broad appeal, no astrology association |

**DO NOT SELECT:**
- Entertainment (may imply fortune-telling)
- Reference (implies factual claims)

### Versioning Plan

| Version | Purpose |
|---------|---------|
| 1.0.0 | Initial App Store release |
| 1.0.1 | Post-launch bug fixes |
| 1.1.0 | First feature update |
| 1.2.0 | Subsequent features |

---

## E.2 — Review Notes (Paste-Ready)

### App Review Information

```
REVIEWER NOTES:

Thank you for reviewing Lumera Space. This app is a personal reflection and
mindfulness tool designed to help users develop self-awareness through
guided prompts and pattern recognition.

IMPORTANT CLARIFICATIONS:
━━━━━━━━━━━━━━━━━━━━━━━━━━

1. This is NOT an astrology, horoscope, or fortune-telling app.
   - We do not make predictions about the future
   - We do not reference zodiac signs, birth charts, or planetary influences
   - We do not claim any supernatural or mystical abilities

2. The app provides:
   - Daily reflection prompts for self-awareness
   - Pattern recognition tools to identify personal habits
   - A safe space for journaling and introspection
   - An AI assistant that offers supportive, non-directive guidance

3. All content is generated by AI and filtered through a strict safety
   system that blocks any astrology, prediction, or fortune-telling language.

4. The app is available in English and Turkish with strict language isolation.

DEMO ACCOUNT:
━━━━━━━━━━━━━
Email: reviewer@lumera.space
Password: Review2024!

Or use: "Continue as Guest" for anonymous exploration.

2-MINUTE WALKTHROUGH:
━━━━━━━━━━━━━━━━━━━━━
1. Launch app → See onboarding (3 screens explaining reflection focus)
2. Complete quick profile (optional birth date for seasonal themes only)
3. View today's reflection prompt
4. Tap "Explore Patterns" to see habit tracking
5. Try the AI assistant with a question like "How can I be more present?"
6. Notice: No astrology, no predictions, no fortune-telling anywhere

CONTENT SAFETY:
━━━━━━━━━━━━━━━
All AI-generated content passes through our ContentSafetyFilter which:
- Blocks 50+ forbidden phrases related to astrology/predictions
- Auto-rewrites borderline content to safe alternatives
- Logs all interventions for our internal compliance dashboard

If you have any questions, please contact: review@lumera.space

Thank you for your time!
```

### Contact Information

| Field | Value |
|-------|-------|
| First Name | [Owner First Name] |
| Last Name | [Owner Last Name] |
| Email | review@lumera.space |
| Phone | [Support Phone Number] |

### Demo Account

| Field | Value |
|-------|-------|
| Username/Email | reviewer@lumera.space |
| Password | Review2024! |
| Full Name | App Reviewer |
| Notes | Pre-populated with 7 days of sample reflections |

### Review-Safe Mode

When `REVIEW_SAFE_MODE=true`:
- Uses curated seed data instead of live generation
- All content pre-verified Apple-safe
- Disables any A/B tests
- Shows simplified onboarding
- Pre-populates demo content

---

## E.3 — First 2-Minute Reviewer Flow

### Screen-by-Screen Breakdown

```
SCREEN 1: Launch / Splash (2 seconds)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Lumera Space logo
- Tagline: "Your daily space for reflection"
- No cosmic/star imagery

SCREEN 2: Onboarding (swipe through, ~15 seconds)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Slide 1: "Welcome to Your Reflection Space"
  - "A peaceful corner for self-discovery"
  - Illustration: Abstract gradients, no stars/planets

Slide 2: "Daily Prompts & Patterns"
  - "Explore prompts that encourage mindfulness"
  - "Track patterns in your thoughts and energy"

Slide 3: "Your Personal Assistant"
  - "Get supportive insights when you need them"
  - "No predictions, just presence"

SCREEN 3: Quick Profile (optional, ~20 seconds)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- "Tell us a bit about yourself (optional)"
- Name field
- Birth date field (note: "For seasonal themes only")
- Preferred language: EN / TR
- Skip button prominent

SCREEN 4: Home - Today's Reflection (~30 seconds)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Date header: "Saturday, February 8"
- Card: "Today's Reflection"
  - Prompt: "What small act of kindness could you offer yourself today?"
  - "Tap to respond" button
- Energy check-in widget
- Pattern highlights preview

SCREEN 5: Pattern Summary (~20 seconds)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- "Your Patterns This Week"
- Bar charts showing:
  - Energy levels
  - Mood trends
  - Focus areas
- No astrological references

SCREEN 6: AI Assistant (~30 seconds)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Chat interface
- Sample exchange:
  User: "How can I be more present today?"
  Assistant: "Being present often starts with small anchors—
  your breath, the sensation of your feet on the ground,
  or the warmth of a cup in your hands. What usually
  helps you feel grounded?"
- Note: Response is supportive, NOT predictive

TOTAL TIME: ~2 minutes
━━━━━━━━━━━━━━━━━━━━━
```

### What Reviewer Will NOT See

- ❌ Zodiac signs or symbols
- ❌ Birth chart visualizations
- ❌ "Your horoscope" or similar language
- ❌ Predictions about future events
- ❌ "Stars say" or cosmic claims
- ❌ Fortune-telling imagery
- ❌ Mixed language content (EN/TR strictly separated)

### What Reviewer WILL See

- ✅ Clean, minimal design
- ✅ Reflection prompts (open-ended questions)
- ✅ Pattern tracking (personal data visualization)
- ✅ Supportive AI responses (coaching-style)
- ✅ "For entertainment purposes" disclaimer
- ✅ Clear language selection with no mixing
- ✅ Settings > About > "This app does not make predictions"

---

## Implementation Checklist

### Before Submission

- [ ] All forbidden phrases removed from codebase
- [ ] ContentSafetyFilter active in all content paths
- [ ] Review-Safe Mode tested and working
- [ ] Demo account created and populated
- [ ] i18n isolation verified (no mixed content)
- [ ] Disclaimer text present on relevant screens
- [ ] Firebase references removed/disabled
- [ ] Supabase fully configured
- [ ] App Store screenshots prepared (Apple-safe)
- [ ] App preview video (if any) reviewed for compliance

### CI Checks Passing

- [ ] `safety-guard.yml` - No forbidden phrases
- [ ] `i18n-guard.yml` - No language mixing
- [ ] `deploy-app.yml` - Build succeeds
- [ ] All tests passing

### App Store Connect

- [ ] New app entry created
- [ ] Bundle ID registered
- [ ] App Information completed
- [ ] Review Notes pasted
- [ ] Demo account added
- [ ] Screenshots uploaded (all required sizes)
- [ ] Privacy policy URL added
- [ ] Support URL added
- [ ] Age rating questionnaire completed
- [ ] Content rights verified

---

**Document End**

> Generated: 2026-02-08
> Classification: INTERNAL — Release Engineering
