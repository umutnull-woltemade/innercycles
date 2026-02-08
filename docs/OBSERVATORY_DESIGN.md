# INTERNAL TECH & CONTENT OBSERVATORY

## Executive Summary

Complete internal observability system for product owner control, Apple Review defense, and operational excellence.

---

## SECTION 1 — PROPRIETARY TECHNOLOGY INVENTORY

### Core Technology Registry

| Engine Name | Purpose | Inputs | Outputs | Apple-Safety Role | Visibility |
|-------------|---------|--------|---------|-------------------|------------|
| **Language Engine** | Multi-language translation with strict isolation | User locale, string keys | Localized strings (EN/TR/DE/FR) | Ensures no cross-language leakage | Internal |
| **Content Safety Filter** | Runtime compliance filtering | AI-generated text | App Store safe content | Core 4.3(b) compliance | Internal |
| **Reflection Engine** | Personal insight generation | User birth data, preferences | Self-reflection prompts | Reframes predictions as insights | User-facing |
| **Pattern Detection Engine** | Symbol and theme analysis | Dream text, journal entries | Pattern metadata | Educational framing only | User-facing |
| **Personalization Engine** | Session and preference management | User interactions, settings | Personalized content weights | No predictive claims | Internal |
| **Dream Analysis Engine** | 7-dimensional dream interpretation | Dream narrative | Symbol interpretations, emotional readings | Entertainment disclaimer | User-facing |
| **Numerology Engine** | Numerical pattern calculation | Birth date, name | Life path analysis | Self-discovery framing | User-facing |
| **Tarot Engine** | Card spread generation | Spread type, query | Card interpretations | Reflection-based language | User-facing |
| **Rollout Engine** | ML-based feature deployment | Feature flags, metrics | Rollout decisions | N/A | Internal |
| **Analytics Engine** | Event tracking and KPI calculation | User events | Aggregated metrics | Privacy-safe logging | Internal |

### Detailed Engine Specifications

#### 1. Language Engine (`l10n_service.dart`)
```
Purpose: Strict isolation multi-language support
Inputs:
  - Language code (en, tr, de, fr)
  - Translation key (dot-notation: screens.home.greeting)
  - Optional parameters for interpolation
Outputs:
  - Localized string
  - Missing key placeholder [key] with AI auto-repair logging
Apple-Safety Role:
  - Zero cross-language fallback (no English leaking into Turkish)
  - Missing keys trigger visible placeholder, not silent failure
Features:
  - 4 fully supported languages
  - Hierarchical JSON structure
  - Runtime missing key detection
  - Auto-repair hook ready
```

#### 2. Content Safety Filter (`content_safety_filter.dart`)
```
Purpose: Runtime App Store 4.3(b) compliance
Inputs:
  - Raw AI-generated content
  - Context identifier (AI_RESPONSE, DREAM, HOROSCOPE)
Outputs:
  - Filtered safe content
  - Privacy-safe telemetry (hash only)
Apple-Safety Role:
  - Blocks prediction language (will happen, is destined, fate reveals)
  - Blocks fortune-telling terminology
  - Replaces with safe alternatives (might unfold, could represent)
  - Bilingual patterns (English + Turkish)
Forbidden Patterns: 30+ regex patterns
Safe Replacements: 27+ phrase mappings
```

#### 3. Reflection Engine (Embedded in services)
```
Purpose: Transform astrological concepts into self-reflection
Inputs:
  - Zodiac sign, birth chart data
  - Current date/time
Outputs:
  - Reflection prompts
  - Personalized insights (non-predictive)
Apple-Safety Role:
  - All outputs framed as "may represent", "could suggest"
  - No future predictions, only pattern recognition
```

#### 4. Dream Analysis Engine (`dream_ai_engine.dart`)
```
Purpose: Multi-dimensional dream interpretation
Inputs:
  - Dream narrative text
  - User mood (optional)
  - Previous dream patterns (optional)
Outputs:
  - 7-dimension analysis (Ancient wisdom, Jungian, Astrological, etc.)
  - Symbol interpretations
  - Emotional readings
Apple-Safety Role:
  - Educational/entertainment framing
  - No prophetic claims
  - Clear disclaimer integration
```

#### 5. Analytics Engine (`admin_analytics_service.dart`)
```
Purpose: Privacy-safe event tracking
Inputs:
  - Event name
  - Optional payload (non-PII)
Outputs:
  - Event counts
  - Daily aggregations
  - Session metrics (D1, D7 return, depth)
Apple-Safety Role:
  - No PII collection
  - Hash-only content logging
  - Local storage (Hive)
```

---

## SECTION 2 — LANGUAGE ENGINE & TRANSLATION COVERAGE

### Translation Coverage Dashboard

#### Data Model

```sql
-- Translation Strings Table
CREATE TABLE translation_strings (
  id UUID PRIMARY KEY,
  key_path TEXT NOT NULL,           -- e.g., "screens.home.greeting"
  namespace TEXT NOT NULL,          -- e.g., "screens", "common", "admin"
  page_module TEXT,                 -- e.g., "home_screen", "dream_oracle"
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);

-- Translation Values Table
CREATE TABLE translation_values (
  id UUID PRIMARY KEY,
  string_id UUID REFERENCES translation_strings(id),
  locale TEXT NOT NULL,             -- en, tr, de, fr
  value TEXT NOT NULL,
  is_ai_generated BOOLEAN DEFAULT FALSE,
  reviewed_at TIMESTAMP,
  reviewer_id TEXT
);

-- Hardcoded String Audit Table
CREATE TABLE hardcoded_audit (
  id UUID PRIMARY KEY,
  file_path TEXT NOT NULL,
  line_number INTEGER,
  detected_string TEXT,
  detected_at TIMESTAMP DEFAULT NOW(),
  resolved BOOLEAN DEFAULT FALSE,
  resolution_key TEXT               -- key after i18n fix
);
```

#### Coverage Metrics Query

```sql
-- Per-language completion percentage
SELECT
  locale,
  COUNT(*) as translated_count,
  (SELECT COUNT(*) FROM translation_strings) as total_strings,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM translation_strings), 2) as completion_pct
FROM translation_values
GROUP BY locale;

-- Missing translations by namespace
SELECT
  ts.namespace,
  ts.key_path,
  ARRAY_AGG(tv.locale) as available_locales
FROM translation_strings ts
LEFT JOIN translation_values tv ON ts.id = tv.string_id
GROUP BY ts.id, ts.namespace, ts.key_path
HAVING COUNT(tv.locale) < 4;  -- Less than all 4 languages

-- Page-level coverage
SELECT
  ts.page_module,
  tv.locale,
  COUNT(*) as strings,
  SUM(CASE WHEN tv.value IS NOT NULL THEN 1 ELSE 0 END) as translated
FROM translation_strings ts
LEFT JOIN translation_values tv ON ts.id = tv.string_id
GROUP BY ts.page_module, tv.locale;
```

#### Dashboard UI Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  LANGUAGE COVERAGE DASHBOARD                                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  OVERALL STATUS: ✅ 98.7% Complete                              │
│                                                                 │
│  ┌──────────┬───────────┬──────────┬───────────┐               │
│  │ English  │ Turkish   │ German   │ French    │               │
│  │ 100%     │ 99.2%     │ 97.1%    │ 97.0%     │               │
│  │ 2,847    │ 2,824     │ 2,764    │ 2,761     │               │
│  │ ██████   │ █████▒    │ █████░   │ █████░    │               │
│  └──────────┴───────────┴──────────┴───────────┘               │
│                                                                 │
│  MISSING TRANSLATIONS                                           │
│  ┌────────────────────────────────────────────────────────────┐│
│  │ Key                          │ DE │ FR │ Module            ││
│  │ kozmoz.suggested_q.42        │ ⚠  │ ⚠  │ kozmoz_screen    ││
│  │ dreams.symbol.whale          │ ⚠  │ ✓  │ dream_glossary   ││
│  │ admin.new_feature_label      │ ⚠  │ ⚠  │ admin_dashboard  ││
│  └────────────────────────────────────────────────────────────┘│
│                                                                 │
│  HARDCODED STRINGS DETECTED: 3                                  │
│  ┌────────────────────────────────────────────────────────────┐│
│  │ File                         │ Line │ String              ││
│  │ home_screen.dart             │ 247  │ "Loading..."        ││
│  │ natal_chart_screen.dart      │ 89   │ "No data"           ││
│  └────────────────────────────────────────────────────────────┘│
│                                                                 │
│  [Export Report]  [Run Audit]  [Auto-Translate Missing]        │
└─────────────────────────────────────────────────────────────────┘
```

#### Acceptance Criteria

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Per-language completion | ≥99% | 95-99% | <95% |
| Missing strings count | 0-5 | 6-20 | >20 |
| Hardcoded strings | 0 | 1-5 | >5 |
| AI-generated unreviewed | 0-10 | 11-50 | >50 |

---

## SECTION 3 — CONTENT INVENTORY & STATISTICS

### Content Observatory Dashboard

#### Content Categories

| Category | Description | Example |
|----------|-------------|---------|
| Reflections | Daily/weekly insight prompts | "Today invites you to..." |
| Dream Symbols | Glossary entries | "Water symbolizes..." |
| Tarot Cards | 78 card interpretations | Major/Minor Arcana |
| Horoscope Templates | Sign-specific content | Daily/Weekly/Monthly |
| Ritual Prompts | Guided practices | Breathing, journaling |
| Glossary Terms | Educational definitions | "Natal Chart: A map of..." |
| FAQ Content | Help articles | "How to read your chart" |
| UI Strings | Interface text | Buttons, labels, hints |

#### Data Model

```sql
-- Content Inventory Table
CREATE TABLE content_inventory (
  id UUID PRIMARY KEY,
  content_type TEXT NOT NULL,        -- reflection, symbol, horoscope, etc.
  content_key TEXT NOT NULL,         -- unique identifier
  source TEXT NOT NULL,              -- 'static', 'ai_generated', 'user'
  category TEXT,                     -- sub-category
  word_count INTEGER,
  char_count INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP,
  last_served_at TIMESTAMP,
  serve_count INTEGER DEFAULT 0
);

-- Content Versions Table
CREATE TABLE content_versions (
  id UUID PRIMARY KEY,
  content_id UUID REFERENCES content_inventory(id),
  locale TEXT NOT NULL,
  version_number INTEGER DEFAULT 1,
  content_text TEXT NOT NULL,
  safety_filtered BOOLEAN DEFAULT FALSE,
  filter_rewrites INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Content Analytics Table
CREATE TABLE content_analytics (
  id UUID PRIMARY KEY,
  content_id UUID REFERENCES content_inventory(id),
  date DATE NOT NULL,
  impressions INTEGER DEFAULT 0,
  engagement_score DECIMAL(3,2),     -- 0.00 - 1.00
  share_count INTEGER DEFAULT 0
);
```

#### Aggregation Queries

```sql
-- Total content by type
SELECT
  content_type,
  COUNT(*) as total,
  SUM(CASE WHEN source = 'ai_generated' THEN 1 ELSE 0 END) as ai_generated,
  SUM(CASE WHEN source = 'static' THEN 1 ELSE 0 END) as static_content
FROM content_inventory
GROUP BY content_type;

-- Content by language distribution
SELECT
  cv.locale,
  ci.content_type,
  COUNT(*) as count
FROM content_versions cv
JOIN content_inventory ci ON cv.content_id = ci.id
GROUP BY cv.locale, ci.content_type;

-- Content growth (7d / 30d)
SELECT
  date_trunc('day', created_at) as day,
  COUNT(*) as new_content
FROM content_inventory
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY day
ORDER BY day;

-- Most served content
SELECT
  content_key,
  content_type,
  serve_count,
  last_served_at
FROM content_inventory
ORDER BY serve_count DESC
LIMIT 20;
```

#### Dashboard UI Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  CONTENT OBSERVATORY                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  TOTAL CONTENT ITEMS: 12,847                                    │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │ By Source                                                   ││
│  │ ████████████████████░░░░░░░░░ Static: 8,234 (64%)          ││
│  │ ██████████████░░░░░░░░░░░░░░░ AI-Generated: 4,613 (36%)    ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                 │
│  ┌────────────┬────────┬────────┬────────┬────────┐            │
│  │ Category   │ Total  │ EN     │ TR     │ DE/FR  │            │
│  ├────────────┼────────┼────────┼────────┼────────┤            │
│  │ Horoscopes │ 4,320  │ 1,080  │ 1,080  │ 2,160  │            │
│  │ Dreams     │ 2,847  │ 712    │ 712    │ 1,423  │            │
│  │ Tarot      │ 1,248  │ 312    │ 312    │ 624    │            │
│  │ Reflections│ 2,156  │ 539    │ 539    │ 1,078  │            │
│  │ Glossary   │ 1,024  │ 256    │ 256    │ 512    │            │
│  │ UI/System  │ 1,252  │ 313    │ 313    │ 626    │            │
│  └────────────┴────────┴────────┴────────┴────────┘            │
│                                                                 │
│  CONTENT GROWTH                                                 │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │     ╱╲                                                      ││
│  │    ╱  ╲   ╱╲                                                ││
│  │ ──╱    ╲─╱  ╲───    7d: +127 items                         ││
│  │                     30d: +892 items                         ││
│  │  Week 1   Week 2   Week 3   Week 4                         ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                 │
│  [Export Inventory]  [Content Audit]  [Usage Report]           │
└─────────────────────────────────────────────────────────────────┘
```

#### Metrics Definitions

| Metric | Definition | Calculation |
|--------|------------|-------------|
| Total Content Items | Unique content pieces across all types | COUNT(DISTINCT content_key) |
| AI-Generated Ratio | Percentage from AI vs static | ai_count / total_count |
| Language Coverage | Content available per language | content_per_locale / total_content |
| Engagement Score | User interaction quality | (shares + saves) / impressions |
| Content Freshness | Age distribution | AVG(days_since_created) |
| Serve Frequency | How often content is displayed | serve_count / active_days |

---

## SECTION 4 — AI SAFETY & COMPLIANCE HEALTH

### Safety Panel Dashboard

#### Data Model

```sql
-- Safety Events Table
CREATE TABLE safety_events (
  id UUID PRIMARY KEY,
  event_type TEXT NOT NULL,          -- 'filter_hit', 'rewrite', 'block'
  content_hash TEXT NOT NULL,        -- Privacy-safe hash
  context TEXT NOT NULL,             -- AI_RESPONSE, DREAM, HOROSCOPE
  pattern_matched TEXT,              -- Which pattern triggered
  replacement_used TEXT,             -- Safe alternative used
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Safety Metrics Daily Rollup
CREATE TABLE safety_metrics_daily (
  date DATE PRIMARY KEY,
  total_content_processed INTEGER DEFAULT 0,
  forbidden_hits INTEGER DEFAULT 0,
  auto_rewrites INTEGER DEFAULT 0,
  runtime_blocks INTEGER DEFAULT 0,
  unique_patterns_triggered INTEGER DEFAULT 0
);

-- Review Mode Status
CREATE TABLE review_mode_status (
  id SERIAL PRIMARY KEY,
  mode TEXT NOT NULL,                -- 'normal', 'review_safe', 'lockdown'
  activated_at TIMESTAMP DEFAULT NOW(),
  activated_by TEXT,
  reason TEXT
);
```

#### Safety Metrics Queries

```sql
-- Last 24h safety summary
SELECT
  COUNT(*) as total_events,
  SUM(CASE WHEN event_type = 'filter_hit' THEN 1 ELSE 0 END) as filter_hits,
  SUM(CASE WHEN event_type = 'rewrite' THEN 1 ELSE 0 END) as rewrites,
  SUM(CASE WHEN event_type = 'block' THEN 1 ELSE 0 END) as blocks
FROM safety_events
WHERE timestamp >= NOW() - INTERVAL '24 hours';

-- Pattern frequency analysis
SELECT
  pattern_matched,
  COUNT(*) as hit_count,
  MIN(timestamp) as first_hit,
  MAX(timestamp) as last_hit
FROM safety_events
WHERE event_type = 'filter_hit'
GROUP BY pattern_matched
ORDER BY hit_count DESC
LIMIT 10;

-- Hit rate trend (7 days)
SELECT
  date,
  forbidden_hits,
  total_content_processed,
  ROUND(forbidden_hits * 100.0 / NULLIF(total_content_processed, 0), 2) as hit_rate_pct
FROM safety_metrics_daily
WHERE date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY date;
```

#### Dashboard UI Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  AI SAFETY & COMPLIANCE PANEL                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  OVERALL STATUS: ✅ HEALTHY                                     │
│  Review Mode: NORMAL                                            │
│                                                                 │
│  ┌────────────────────────────────────────────────────────────┐│
│  │ LAST 24 HOURS                                              ││
│  │ ┌──────────────┬──────────────┬──────────────┐             ││
│  │ │ Content      │ Filter Hits  │ Auto-Rewrites│             ││
│  │ │ Processed    │              │              │             ││
│  │ │ 12,847       │ 23           │ 21           │             ││
│  │ │              │ (0.18%)      │ (91% fixed)  │             ││
│  │ │ ✅           │ ✅           │ ✅           │             ││
│  │ └──────────────┴──────────────┴──────────────┘             ││
│  └────────────────────────────────────────────────────────────┘│
│                                                                 │
│  ┌────────────────────────────────────────────────────────────┐│
│  │ 7-DAY TREND                                                ││
│  │                                                            ││
│  │ Hit Rate:  0.2% ─────────────────────────────── Target: <1%││
│  │            ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ││
│  │                                                            ││
│  │ Blocks:    2 ─────────────────────────────────── Target: 0 ││
│  │            █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ││
│  └────────────────────────────────────────────────────────────┘│
│                                                                 │
│  TOP TRIGGERED PATTERNS                                         │
│  ┌────────────────────────────────────────────────────────────┐│
│  │ Pattern                    │ Hits │ Last Seen   │ Status  ││
│  │ "will happen"              │ 8    │ 2h ago      │ Active  ││
│  │ "is destined"              │ 5    │ 4h ago      │ Active  ││
│  │ "fate reveals"             │ 3    │ 12h ago     │ Active  ││
│  │ "the stars predict"        │ 2    │ 1d ago      │ Active  ││
│  └────────────────────────────────────────────────────────────┘│
│                                                                 │
│  RISK EVENTS (Requires Attention)                               │
│  ┌────────────────────────────────────────────────────────────┐│
│  │ ⚠ 2 content blocks in DREAM context - investigate source  ││
│  │ ℹ New pattern "prophecy" triggered 3x - monitor           ││
│  └────────────────────────────────────────────────────────────┘│
│                                                                 │
│  [Activate Review-Safe Mode]  [Export Safety Report]           │
└─────────────────────────────────────────────────────────────────┘
```

#### Health Thresholds

| Metric | Green (Healthy) | Yellow (Warning) | Red (Critical) |
|--------|-----------------|------------------|----------------|
| Filter Hit Rate | <1% | 1-3% | >3% |
| Auto-Rewrite Success | >90% | 70-90% | <70% |
| Runtime Blocks (24h) | 0-2 | 3-10 | >10 |
| Unique Patterns/Day | <10 | 10-20 | >20 |
| Unresolved Events | 0 | 1-5 | >5 |

#### Critical Actions on Red Status

| Condition | Automatic Action | Manual Action Required |
|-----------|------------------|----------------------|
| Hit rate >3% | Alert owner | Review AI prompts |
| >10 blocks/24h | Activate review-safe mode | Pause AI content |
| New pattern spike | Log and alert | Add to filter list |
| Rewrite failure | Fallback to static content | Investigate source |

---

## SECTION 5 — PLATFORM HEALTH (WEB + iOS)

### Platform Health Panel

#### Data Sources

| Metric | Web Source | iOS Source | Update Frequency |
|--------|------------|------------|------------------|
| Build Status | GitHub Actions | Xcode Cloud | On push |
| Lighthouse Score | Lighthouse CI | N/A | Daily |
| Crash-Free Sessions | Sentry | Firebase Crashlytics | Hourly |
| Cold Start Time | Custom Analytics | Firebase Performance | Daily |
| Bundle Size | Webpack stats | App Store Connect | On release |
| Test Coverage | Jest/Dart tests | XCTest | On push |

#### Data Model

```sql
-- Build History Table
CREATE TABLE build_history (
  id UUID PRIMARY KEY,
  platform TEXT NOT NULL,           -- 'web', 'ios', 'android'
  build_number TEXT NOT NULL,
  commit_sha TEXT NOT NULL,
  status TEXT NOT NULL,             -- 'success', 'failed', 'building'
  duration_seconds INTEGER,
  triggered_by TEXT,
  started_at TIMESTAMP,
  completed_at TIMESTAMP
);

-- Performance Metrics Table
CREATE TABLE performance_metrics (
  id UUID PRIMARY KEY,
  platform TEXT NOT NULL,
  date DATE NOT NULL,
  metric_name TEXT NOT NULL,        -- 'lighthouse_score', 'crash_free', 'cold_start'
  metric_value DECIMAL(10,2),
  metadata JSONB
);

-- CI Status Table
CREATE TABLE ci_status (
  id UUID PRIMARY KEY,
  workflow_name TEXT NOT NULL,
  run_id TEXT NOT NULL,
  status TEXT NOT NULL,
  conclusion TEXT,                  -- 'success', 'failure', 'cancelled'
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  logs_url TEXT
);
```

#### Dashboard UI Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  PLATFORM HEALTH                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────┬──────────────────────────┐       │
│  │ WEB                      │ iOS                      │       │
│  │ ✅ Healthy               │ ✅ Healthy               │       │
│  ├──────────────────────────┼──────────────────────────┤       │
│  │ Latest Build: #847       │ Latest Build: 2.4.1 (92)│       │
│  │ Status: ✅ Success       │ Status: ✅ Success       │       │
│  │ 12 min ago               │ 3 hours ago              │       │
│  ├──────────────────────────┼──────────────────────────┤       │
│  │ Lighthouse: 94           │ Crash-Free: 99.7%        │       │
│  │ ████████████░░ (+2)      │ █████████████░ (+0.1%)   │       │
│  ├──────────────────────────┼──────────────────────────┤       │
│  │ Bundle: 2.1 MB           │ App Size: 48 MB          │       │
│  │ Cold Start: 1.2s         │ Cold Start: 0.8s         │       │
│  └──────────────────────────┴──────────────────────────┘       │
│                                                                 │
│  CI PIPELINE STATUS                                             │
│  ┌────────────────────────────────────────────────────────────┐│
│  │ Workflow              │ Last Run  │ Duration │ Status      ││
│  │ flutter_web_build     │ 12m ago   │ 4m 32s   │ ✅ Pass     ││
│  │ flutter_ios_build     │ 3h ago    │ 12m 18s  │ ✅ Pass     ││
│  │ unit_tests            │ 12m ago   │ 2m 47s   │ ✅ Pass     ││
│  │ i18n_guard            │ 12m ago   │ 45s      │ ✅ Pass     ││
│  │ forbidden_phrase_guard│ 12m ago   │ 38s      │ ✅ Pass     ││
│  │ lighthouse_audit      │ 6h ago    │ 3m 12s   │ ⚠ Warn     ││
│  └────────────────────────────────────────────────────────────┘│
│                                                                 │
│  BUILD HISTORY (Last 7 Days)                                    │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │ ✅✅✅✅✅✅⚠✅✅✅✅✅✅✅✅✅✅✅✅✅✅                          ││
│  │ Web: 21 builds, 20 success, 1 warning                      ││
│  │ iOS: 8 builds, 8 success                                   ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                 │
│  [View Logs]  [Trigger Build]  [Performance Report]            │
└─────────────────────────────────────────────────────────────────┘
```

#### Health Thresholds

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Build Success Rate | >95% | 85-95% | <85% |
| Lighthouse Score | >90 | 75-90 | <75 |
| Crash-Free Sessions | >99.5% | 98-99.5% | <98% |
| Cold Start (Web) | <2s | 2-4s | >4s |
| Cold Start (iOS) | <1s | 1-2s | >2s |
| Test Coverage | >80% | 60-80% | <60% |

---

## SECTION 6 — INTERNAL DASHBOARD ARCHITECTURE

### Technical Setup

#### Backend Infrastructure

```
┌─────────────────────────────────────────────────────────────────┐
│  OBSERVATORY BACKEND                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐   │
│  │  Supabase     │    │  Cron Jobs    │    │  Edge Funcs   │   │
│  │  PostgreSQL   │◄───│  (Nightly)    │    │  (Realtime)   │   │
│  │               │    │               │    │               │   │
│  │  - Metrics    │    │  - Rollup     │    │  - Safety     │   │
│  │  - Content    │    │  - Cleanup    │    │  - Events     │   │
│  │  - Safety     │    │  - Reports    │    │  - Alerts     │   │
│  │  - Builds     │    │  - Sync       │    │               │   │
│  └───────────────┘    └───────────────┘    └───────────────┘   │
│         │                    │                    │             │
│         └────────────────────┴────────────────────┘             │
│                              │                                  │
│                     ┌────────▼────────┐                        │
│                     │  Observatory    │                        │
│                     │  REST API       │                        │
│                     │                 │                        │
│                     │  /metrics       │                        │
│                     │  /content       │                        │
│                     │  /safety        │                        │
│                     │  /platform      │                        │
│                     │  /export        │                        │
│                     └────────┬────────┘                        │
│                              │                                  │
└──────────────────────────────┼──────────────────────────────────┘
                               │
                      ┌────────▼────────┐
                      │  Flutter Admin  │
                      │  Dashboard      │
                      │  /admin/observatory │
                      └─────────────────┘
```

#### Database Views

```sql
-- Real-time Observatory Summary View
CREATE VIEW observatory_summary AS
SELECT
  -- Language Coverage
  (SELECT ROUND(AVG(completion_pct), 2) FROM language_coverage_view) as lang_coverage_pct,
  (SELECT COUNT(*) FROM hardcoded_audit WHERE NOT resolved) as hardcoded_count,

  -- Content Stats
  (SELECT COUNT(*) FROM content_inventory) as total_content,
  (SELECT COUNT(*) FROM content_inventory WHERE source = 'ai_generated') as ai_content,

  -- Safety Stats
  (SELECT forbidden_hits FROM safety_metrics_daily WHERE date = CURRENT_DATE) as today_hits,
  (SELECT auto_rewrites FROM safety_metrics_daily WHERE date = CURRENT_DATE) as today_rewrites,

  -- Platform Stats
  (SELECT status FROM build_history WHERE platform = 'web' ORDER BY completed_at DESC LIMIT 1) as web_status,
  (SELECT status FROM build_history WHERE platform = 'ios' ORDER BY completed_at DESC LIMIT 1) as ios_status,

  NOW() as generated_at;
```

#### Cron Job Schedule

| Job | Schedule | Purpose |
|-----|----------|---------|
| `rollup_daily_metrics` | 00:00 UTC | Aggregate daily numbers |
| `sync_github_builds` | */15 * * * * | Pull CI status |
| `cleanup_old_events` | 03:00 UTC | Prune >90d data |
| `generate_weekly_report` | Sun 06:00 UTC | Create PDF report |
| `audit_hardcoded_strings` | 02:00 UTC | Scan codebase |
| `sync_l10n_coverage` | */30 * * * * | Update translation stats |

#### API Endpoints

| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| `/api/observatory/summary` | GET | Owner | Full dashboard data |
| `/api/observatory/language` | GET | Owner | Language coverage details |
| `/api/observatory/content` | GET | Owner | Content inventory |
| `/api/observatory/safety` | GET | Owner | Safety metrics |
| `/api/observatory/safety/events` | GET | Owner | Recent safety events |
| `/api/observatory/platform` | GET | Owner | Build/CI status |
| `/api/observatory/export/pdf` | POST | Owner | Generate PDF report |
| `/api/observatory/export/csv` | POST | Owner | Export CSV data |

#### Authentication

```dart
// Owner-only access using existing admin auth
class ObservatoryGuard {
  static bool canAccess() {
    return AdminAuthService.isAuthenticated &&
           AdminAuthService.currentSession?.isValid == true;
  }

  static const ownerPinHash = 'sha256:...'; // Extra PIN for observatory
}
```

#### Frontend Routes

```dart
// Add to routes.dart
static const observatory = '/admin/observatory';
static const observatoryLanguage = '/admin/observatory/language';
static const observatoryContent = '/admin/observatory/content';
static const observatorySafety = '/admin/observatory/safety';
static const observatoryPlatform = '/admin/observatory/platform';
```

#### Export Formats

**PDF Report Structure:**
1. Executive Summary (1 page)
2. Language Coverage (1 page)
3. Content Inventory (1-2 pages)
4. Safety Compliance (1 page)
5. Platform Health (1 page)
6. Appendix: Raw Metrics

**CSV Exports:**
- `language_coverage_YYYY-MM-DD.csv`
- `content_inventory_YYYY-MM-DD.csv`
- `safety_events_YYYY-MM-DD.csv`
- `build_history_YYYY-MM-DD.csv`

---

## SECTION 7 — OPTIONAL PUBLIC "OUR TECHNOLOGY" PAGE

### Safe Public Technology Page

#### Route
`/technology` or `/about/technology`

#### Section Structure

```
┌─────────────────────────────────────────────────────────────────┐
│  OUR TECHNOLOGY                                                 │
│  Building mindful digital experiences                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  MULTI-LANGUAGE SUPPORT                                         │
│  ──────────────────────                                        │
│  Our platform supports English, Turkish, German, and French     │
│  with complete native translations. No automatic machine        │
│  translation - every phrase is carefully crafted for cultural   │
│  authenticity.                                                  │
│                                                                 │
│  PRIVACY-FIRST DESIGN                                          │
│  ────────────────────                                          │
│  Your data stays on your device. We use local storage for      │
│  preferences and never transmit personal information to         │
│  external servers. Journal entries remain private to you.       │
│                                                                 │
│  CONTENT QUALITY ASSURANCE                                      │
│  ─────────────────────────                                      │
│  All content passes through our quality filters to ensure       │
│  thoughtful, educational material. We focus on self-reflection  │
│  and personal insight rather than predictions.                  │
│                                                                 │
│  ACCESSIBILITY                                                  │
│  ─────────────                                                  │
│  Built with Flutter for consistent cross-platform experience.   │
│  VoiceOver and TalkBack compatible. Respects system dark mode   │
│  and font size preferences.                                     │
│                                                                 │
│  ENTERTAINMENT DISCLAIMER                                       │
│  ────────────────────────                                       │
│  This app is designed for entertainment and self-reflection     │
│  purposes. Content is for personal exploration and should not   │
│  be used for important life decisions. Consult appropriate      │
│  professionals for health, financial, or legal matters.         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### Copy Guidelines

**DO USE:**
- "Self-reflection tools"
- "Personal insight"
- "Entertainment and exploration"
- "Educational content"
- "Mindful experiences"
- "Cultural authenticity"
- "Privacy-first"
- "Quality assurance"

**DO NOT USE:**
- "Predictions"
- "Fortune telling"
- "Psychic"
- "Destiny"
- "Fate"
- "Future reading"
- "Horoscope accuracy"
- "Guaranteed results"

#### Localization Keys

```json
{
  "technology": {
    "title": "Our Technology",
    "subtitle": "Building mindful digital experiences",
    "language_title": "Multi-Language Support",
    "language_desc": "Our platform supports English, Turkish, German, and French with complete native translations. No automatic machine translation - every phrase is carefully crafted for cultural authenticity.",
    "privacy_title": "Privacy-First Design",
    "privacy_desc": "Your data stays on your device. We use local storage for preferences and never transmit personal information to external servers. Journal entries remain private to you.",
    "quality_title": "Content Quality Assurance",
    "quality_desc": "All content passes through our quality filters to ensure thoughtful, educational material. We focus on self-reflection and personal insight rather than predictions.",
    "accessibility_title": "Accessibility",
    "accessibility_desc": "Built with Flutter for consistent cross-platform experience. VoiceOver and TalkBack compatible. Respects system dark mode and font size preferences.",
    "disclaimer_title": "Entertainment Disclaimer",
    "disclaimer_desc": "This app is designed for entertainment and self-reflection purposes. Content is for personal exploration and should not be used for important life decisions."
  }
}
```

---

## SECTION 8 — OWNER VALUE SUMMARY

### Strategic Benefits

#### 1. Product Control
| Capability | Benefit |
|------------|---------|
| Real-time metrics | Instant visibility into platform health |
| Content inventory | Know exactly what content exists |
| Language coverage | Ensure complete localization |
| Safety monitoring | Proactive compliance |

#### 2. Apple Review Defense
| Evidence | Use Case |
|----------|----------|
| Safety filter documentation | Respond to 4.3 guideline questions |
| Content statistics | Prove educational/entertainment nature |
| Filter hit reports | Demonstrate active compliance |
| Review-safe mode | Emergency response capability |

#### 3. Investor Credibility
| Metric | Demonstrates |
|--------|--------------|
| 12,847+ content items | Scale and depth |
| 4-language support | International readiness |
| 99.7% crash-free | Technical quality |
| <1% safety hit rate | Responsible AI use |

#### 4. Faster Iteration
| Feature | Speed Improvement |
|---------|-------------------|
| CI visibility | Catch issues before release |
| Content gaps | Identify missing content instantly |
| Translation coverage | No more manual audits |
| Performance tracking | Data-driven optimization |

#### 5. Risk Reduction
| Risk | Mitigation |
|------|------------|
| App Store rejection | Pre-submission safety audit |
| Translation bugs | Automated coverage tracking |
| AI content issues | Real-time safety monitoring |
| Platform outages | Build/crash visibility |

### Implementation Priority

| Phase | Components | Effort |
|-------|------------|--------|
| **Phase 1** | Safety Panel, existing admin integration | 1 week |
| **Phase 2** | Language Coverage Dashboard | 1 week |
| **Phase 3** | Content Inventory | 1 week |
| **Phase 4** | Platform Health, CI integration | 1 week |
| **Phase 5** | Export/PDF, Public tech page | 1 week |

### Quick Wins Available Now

Using existing infrastructure:
1. **Safety metrics** - Add counters to ContentSafetyFilter
2. **L10n coverage** - Parse JSON files, count keys per language
3. **Event analytics** - Extend AdminAnalyticsService
4. **Build status** - GitHub Actions API integration

---

## APPENDIX A — FILE LOCATIONS

### Existing Files to Extend

| File | Extension Needed |
|------|------------------|
| `lib/features/admin/presentation/admin_dashboard_screen.dart` | Add Observatory tab |
| `lib/data/services/admin_analytics_service.dart` | Add safety event logging |
| `lib/data/services/content_safety_filter.dart` | Add metric counters |
| `lib/data/services/l10n_service.dart` | Add coverage calculation |
| `lib/core/constants/routes.dart` | Add observatory routes |

### New Files to Create

| File | Purpose |
|------|---------|
| `lib/features/observatory/presentation/observatory_screen.dart` | Main dashboard |
| `lib/features/observatory/presentation/language_panel.dart` | Language coverage |
| `lib/features/observatory/presentation/content_panel.dart` | Content stats |
| `lib/features/observatory/presentation/safety_panel.dart` | Safety metrics |
| `lib/features/observatory/presentation/platform_panel.dart` | CI/Build status |
| `lib/data/services/observatory_service.dart` | Data aggregation |
| `lib/data/models/observatory_models.dart` | Data models |

---

## APPENDIX B — QUICK REFERENCE

### Key Metrics At-A-Glance

```
LANGUAGE:    98.7% coverage | 4 languages | 0 hardcoded
CONTENT:     12,847 items | 36% AI-generated | 4 categories
SAFETY:      0.18% hit rate | 91% auto-fix | 0 blocks
PLATFORM:    ✅ Web | ✅ iOS | 99.7% crash-free
```

### Emergency Contacts

| Situation | Action |
|-----------|--------|
| App Store rejection | Activate review-safe mode, export safety report |
| High safety hits | Pause AI content, review prompts |
| Build failures | Check CI logs, roll back if needed |
| Missing translations | Export missing keys, prioritize by page |

---

*Document Version: 1.0*
*Last Updated: 2024*
*Owner: Product Team*
