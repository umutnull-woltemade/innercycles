# Internal Tech & Content Observatory
## Owner-Only Platform Control System

> **Classification**: INTERNAL — Owner/Admin Access Only
> **Version**: 1.0.0
> **Last Updated**: 2026-02-08

---

## Table of Contents

1. [Proprietary Technology Inventory](#section-1--proprietary-technology-inventory)
2. [Language Engine & Translation Coverage](#section-2--language-engine--translation-coverage)
3. [Content Inventory & Statistics](#section-3--content-inventory--statistics)
4. [AI Safety & Compliance Health](#section-4--ai-safety--compliance-health)
5. [Platform Health (Web + iOS)](#section-5--platform-health-web--ios)
6. [Internal Dashboard Architecture](#section-6--internal-dashboard-architecture)
7. [Public Technology Page (Optional)](#section-7--public-technology-page-optional)
8. [Owner Value Summary](#section-8--owner-value-summary)

---

# Section 1 — Proprietary Technology Inventory

## Core Engine Registry

| Engine Name | Purpose | Inputs | Outputs | Safety Role | Visibility |
|-------------|---------|--------|---------|-------------|------------|
| **Language Engine** | i18n + strict locale isolation | User locale, translation keys | Localized strings (EN/TR/DE/FR) | Prevents cross-language contamination | Internal |
| **Reflection Engine** | Personalized insight generation | User context, session data | Contextual reflections, prompts | Content filtering before output | User-facing |
| **Pattern Detection Engine** | Behavioral pattern recognition | User interactions, timestamps | Engagement patterns, preferences | No PII exposure | Internal |
| **AI Safety Engine** | Content compliance & filtering | Raw AI/content output | Sanitized, Apple-safe content | **Primary safety gate** | Internal |
| **Personalization Engine** | Session-aware customization | User profile, history | Tailored experiences | Privacy-preserving | User-facing |
| **Dream Analysis Engine** | Multi-dimensional dream processing | Dream text, symbols | 7-layer interpretation | Content sanitization | User-facing |
| **Ephemeris Engine** | Astronomical calculations | Date, time, location | Planetary positions, aspects | N/A (pure math) | Internal |
| **Experiment Engine** | A/B testing & rollout control | Feature flags, cohorts | Variant assignments | Gradual exposure | Internal |
| **Export Engine** | Report & share generation | User data, templates | PDF, images, share cards | Watermarking, attribution | User-facing |

---

## Engine Specifications

### 1. Language Engine (L10nService)

**Location**: `lib/data/services/l10n_service.dart`

```
┌─────────────────────────────────────────────────────────────┐
│                    LANGUAGE ENGINE                          │
├─────────────────────────────────────────────────────────────┤
│  Supported Locales: EN | TR | DE | FR                       │
│  Fallback Strategy: NONE (strict isolation)                 │
│  String Source: assets/l10n/{locale}.json                   │
│  Auto-Repair: AI-assisted missing key generation            │
└─────────────────────────────────────────────────────────────┘
```

**Capabilities**:
- Strict language isolation (no cross-locale fallback)
- Hierarchical JSON namespace support
- Parameterized string interpolation
- List and map value retrieval
- Runtime missing key detection

**Safety Role**: Prevents untranslated content from reaching users in wrong language.

---

### 2. AI Safety Engine (ContentSafetyFilter)

**Location**: `lib/data/services/content_safety_filter.dart`

```
┌─────────────────────────────────────────────────────────────┐
│                  AI SAFETY ENGINE                           │
├─────────────────────────────────────────────────────────────┤
│  Forbidden Patterns: 45+ regex patterns                     │
│  Auto-Rewrite Rules: 30+ replacement mappings               │
│  Processing Modes: Filter | Rewrite | Block                 │
│  Audit Trail: Full logging of interventions                 │
└─────────────────────────────────────────────────────────────┘
```

**Pattern Categories**:
| Category | Example Patterns | Action |
|----------|-----------------|--------|
| Predictive Claims | "will happen", "guaranteed" | Rewrite → "may reflect" |
| Medical/Health | "cure", "diagnose", "treatment" | Block |
| Financial Advice | "invest", "profit", "guaranteed returns" | Block |
| Absolute Statements | "definitely", "always", "never" | Rewrite → softer language |
| Fortune Telling | "your future", "destiny awaits" | Rewrite → "possibilities" |

---

### 3. Dream Analysis Engine

**Location**: `lib/data/services/dream_interpretation_service.dart`

```
┌─────────────────────────────────────────────────────────────┐
│                 DREAM ANALYSIS ENGINE                       │
├─────────────────────────────────────────────────────────────┤
│  Dimensions: 7-layer interpretation model                   │
│  Sources: Jungian | Archetypal | Cultural | Personal        │
│  Symbol Database: 500+ universal symbols                    │
│  Personalization: Birth chart integration                   │
└─────────────────────────────────────────────────────────────┘
```

**Processing Layers**:
1. Symbol Extraction
2. Emotional Mapping
3. Archetypal Association
4. Personal Context Integration
5. Temporal Significance
6. Synthesis & Narrative
7. Actionable Reflection

---

### 4. Personalization Engine

**Location**: `lib/data/services/dream_personalization_service.dart`

```
┌─────────────────────────────────────────────────────────────┐
│               PERSONALIZATION ENGINE                        │
├─────────────────────────────────────────────────────────────┤
│  Data Points: Birth info, preferences, history              │
│  Privacy: On-device processing preferred                    │
│  Sync: Opt-in cloud backup only                             │
│  Retention: User-controlled deletion                        │
└─────────────────────────────────────────────────────────────┘
```

---

### 5. Experiment Engine

**Location**: `lib/data/services/experiment_service.dart`, `lib/data/services/hybrid_rollout_engine.dart`

```
┌─────────────────────────────────────────────────────────────┐
│                 EXPERIMENT ENGINE                           │
├─────────────────────────────────────────────────────────────┤
│  Capabilities: A/B testing, gradual rollout, ML prediction  │
│  Cohort Assignment: Deterministic hashing                   │
│  Metrics: Retention, engagement, conversion                 │
│  Safety: Automatic rollback on regression                   │
└─────────────────────────────────────────────────────────────┘
```

---

# Section 2 — Language Engine & Translation Coverage

## Translation Coverage Dashboard

### Data Model

```sql
-- Core Tables
CREATE TABLE localization_strings (
    id UUID PRIMARY KEY,
    key TEXT NOT NULL UNIQUE,
    namespace TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE translations (
    id UUID PRIMARY KEY,
    string_id UUID REFERENCES localization_strings(id),
    locale TEXT NOT NULL CHECK (locale IN ('en', 'tr', 'de', 'fr')),
    value TEXT NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    translator TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(string_id, locale)
);

CREATE TABLE hardcoded_strings (
    id UUID PRIMARY KEY,
    file_path TEXT NOT NULL,
    line_number INTEGER,
    raw_string TEXT NOT NULL,
    detected_at TIMESTAMPTZ DEFAULT NOW(),
    resolved BOOLEAN DEFAULT FALSE,
    resolution_key TEXT
);

-- Views
CREATE VIEW translation_coverage AS
SELECT
    locale,
    COUNT(*) as translated_count,
    (SELECT COUNT(*) FROM localization_strings) as total_strings,
    ROUND(COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM localization_strings) * 100, 2) as coverage_pct
FROM translations
GROUP BY locale;

CREATE VIEW missing_translations AS
SELECT
    ls.key,
    ls.namespace,
    ARRAY_AGG(DISTINCT t.locale) as has_translations,
    ARRAY['en', 'tr', 'de', 'fr'] - ARRAY_AGG(DISTINCT t.locale) as missing_locales
FROM localization_strings ls
LEFT JOIN translations t ON ls.id = t.string_id
GROUP BY ls.id, ls.key, ls.namespace
HAVING ARRAY_LENGTH(ARRAY['en', 'tr', 'de', 'fr'] - ARRAY_AGG(DISTINCT t.locale), 1) > 0;
```

### Dashboard Metrics

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    LANGUAGE COVERAGE DASHBOARD                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  TOTAL STRINGS: 2,847                     LAST SCAN: 2 hours ago        │
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │  LOCALE     │ TRANSLATED │ MISSING │ COVERAGE │ STATUS           │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │  🇺🇸 EN      │   2,847    │    0    │  100.0%  │ ✅ COMPLETE      │  │
│  │  🇹🇷 TR      │   2,831    │   16    │   99.4%  │ ⚠️ NEAR COMPLETE │  │
│  │  🇩🇪 DE      │   2,412    │  435    │   84.7%  │ 🔶 IN PROGRESS   │  │
│  │  🇫🇷 FR      │   2,398    │  449    │   84.2%  │ 🔶 IN PROGRESS   │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  HARDCODED STRINGS DETECTED: 23                                         │
│  ├─ lib/features/home/ .............. 8                                 │
│  ├─ lib/features/dreams/ ............ 6                                 │
│  ├─ lib/shared/widgets/ ............. 5                                 │
│  └─ lib/features/tarot/ ............. 4                                 │
│                                                                         │
│  [Export Report]  [Scan Now]  [View Missing Keys]                       │
└─────────────────────────────────────────────────────────────────────────┘
```

### Aggregation Queries

```sql
-- Per-module coverage breakdown
SELECT
    SPLIT_PART(ls.namespace, '.', 1) as module,
    t.locale,
    COUNT(*) as translated,
    (SELECT COUNT(*) FROM localization_strings WHERE namespace LIKE SPLIT_PART(ls.namespace, '.', 1) || '%') as total,
    ROUND(COUNT(*)::NUMERIC / NULLIF((SELECT COUNT(*) FROM localization_strings WHERE namespace LIKE SPLIT_PART(ls.namespace, '.', 1) || '%'), 0) * 100, 1) as pct
FROM localization_strings ls
JOIN translations t ON ls.id = t.string_id
GROUP BY SPLIT_PART(ls.namespace, '.', 1), t.locale
ORDER BY module, locale;

-- Recent translation activity
SELECT
    DATE(created_at) as date,
    locale,
    COUNT(*) as strings_added
FROM translations
WHERE created_at > NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at), locale
ORDER BY date DESC;

-- Hardcoded string detection results
SELECT
    file_path,
    COUNT(*) as hardcoded_count,
    MAX(detected_at) as last_detected
FROM hardcoded_strings
WHERE resolved = FALSE
GROUP BY file_path
ORDER BY hardcoded_count DESC;
```

### Acceptance Criteria

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Coverage % | ≥99% | 90-99% | <90% |
| Hardcoded Strings | 0 | 1-10 | >10 |
| Missing Keys (Primary) | 0 | 1-5 | >5 |
| Stale Translations (>30d) | 0 | 1-20 | >20 |

---

# Section 3 — Content Inventory & Statistics

## Content Observatory Dashboard

### Data Model

```sql
CREATE TYPE content_source AS ENUM ('static', 'ai_generated', 'hybrid', 'user_submitted');
CREATE TYPE content_category AS ENUM (
    'reflection', 'prompt', 'template', 'interpretation',
    'glossary', 'educational', 'guidance', 'ritual'
);

CREATE TABLE content_items (
    id UUID PRIMARY KEY,
    category content_category NOT NULL,
    source content_source NOT NULL,
    locale TEXT NOT NULL,
    title TEXT,
    body TEXT NOT NULL,
    word_count INTEGER GENERATED ALWAYS AS (array_length(regexp_split_to_array(body, '\s+'), 1)) STORED,
    char_count INTEGER GENERATED ALWAYS AS (length(body)) STORED,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    safety_score NUMERIC(3,2) CHECK (safety_score BETWEEN 0 AND 1),
    last_safety_scan TIMESTAMPTZ
);

CREATE TABLE content_usage (
    id UUID PRIMARY KEY,
    content_id UUID REFERENCES content_items(id),
    displayed_at TIMESTAMPTZ DEFAULT NOW(),
    session_id TEXT,
    locale TEXT,
    platform TEXT CHECK (platform IN ('web', 'ios', 'android'))
);

-- Aggregated daily stats
CREATE TABLE content_daily_stats (
    date DATE PRIMARY KEY,
    total_items INTEGER,
    ai_generated_count INTEGER,
    static_count INTEGER,
    new_items_count INTEGER,
    safety_scanned_count INTEGER
);
```

### Dashboard Layout

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     CONTENT OBSERVATORY                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │
│  │ TOTAL ITEMS │  │ AI-GENERATED│  │   STATIC    │  │ GROWTH (7d) │    │
│  │   12,847    │  │    8,234    │  │   4,613     │  │   +347      │    │
│  │             │  │   (64.1%)   │  │   (35.9%)   │  │   (+2.8%)   │    │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘    │
│                                                                         │
│  CATEGORY DISTRIBUTION                                                  │
│  ════════════════════════════════════════════════════════════════════  │
│  Reflection      ████████████████████████████████░░░░░░░  4,892 (38%)  │
│  Prompt          ██████████████████████░░░░░░░░░░░░░░░░░  2,827 (22%)  │
│  Interpretation  ████████████████░░░░░░░░░░░░░░░░░░░░░░░  2,056 (16%)  │
│  Template        ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  1,285 (10%)  │
│  Glossary        ████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  1,028 (8%)   │
│  Other           ██████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    759 (6%)   │
│                                                                         │
│  LANGUAGE DISTRIBUTION                                                  │
│  ════════════════════════════════════════════════════════════════════  │
│  🇺🇸 English    ████████████████████████████░░░░░░░░░░░░  5,139 (40%)  │
│  🇹🇷 Turkish    ████████████████████████████░░░░░░░░░░░░  5,012 (39%)  │
│  🇩🇪 German     ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  1,348 (10.5%)│
│  🇫🇷 French     ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  1,348 (10.5%)│
│                                                                         │
│  CONTENT GROWTH (30 days)                                               │
│  ════════════════════════════════════════════════════════════════════  │
│       ▲                                                                 │
│   400 │                              ╭─╮                                │
│   300 │              ╭───╮    ╭─────╯  ╰──╮                             │
│   200 │    ╭────────╯    ╰───╯            ╰───╮                         │
│   100 │───╯                                    ╰───                     │
│       └────────────────────────────────────────────▶                    │
│        W1        W2        W3        W4                                 │
│                                                                         │
│  [Export Inventory]  [Content Audit]  [Safety Scan All]                 │
└─────────────────────────────────────────────────────────────────────────┘
```

### Aggregation Queries

```sql
-- Content summary by category and source
SELECT
    category,
    source,
    COUNT(*) as count,
    ROUND(COUNT(*)::NUMERIC / SUM(COUNT(*)) OVER() * 100, 1) as pct,
    AVG(word_count) as avg_words
FROM content_items
WHERE is_active = TRUE
GROUP BY category, source
ORDER BY count DESC;

-- Weekly content growth
SELECT
    DATE_TRUNC('week', created_at) as week,
    source,
    COUNT(*) as items_created
FROM content_items
WHERE created_at > NOW() - INTERVAL '90 days'
GROUP BY DATE_TRUNC('week', created_at), source
ORDER BY week DESC;

-- Content freshness report
SELECT
    category,
    COUNT(*) FILTER (WHERE updated_at > NOW() - INTERVAL '7 days') as updated_7d,
    COUNT(*) FILTER (WHERE updated_at > NOW() - INTERVAL '30 days') as updated_30d,
    COUNT(*) FILTER (WHERE updated_at < NOW() - INTERVAL '90 days') as stale_90d
FROM content_items
WHERE is_active = TRUE
GROUP BY category;

-- Safety scan coverage
SELECT
    category,
    COUNT(*) as total,
    COUNT(*) FILTER (WHERE last_safety_scan IS NOT NULL) as scanned,
    COUNT(*) FILTER (WHERE safety_score >= 0.95) as safe_count,
    COUNT(*) FILTER (WHERE safety_score < 0.95) as needs_review
FROM content_items
WHERE is_active = TRUE
GROUP BY category;
```

---

# Section 4 — AI Safety & Compliance Health

## Safety Panel Dashboard

### Data Model

```sql
CREATE TYPE safety_event_type AS ENUM (
    'forbidden_phrase_hit', 'auto_rewrite', 'content_blocked',
    'review_mode_trigger', 'manual_override'
);

CREATE TABLE safety_events (
    id UUID PRIMARY KEY,
    event_type safety_event_type NOT NULL,
    source_service TEXT NOT NULL,
    original_content TEXT,
    processed_content TEXT,
    pattern_matched TEXT,
    severity TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    session_id TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    resolution_notes TEXT
);

CREATE TABLE safety_config (
    id UUID PRIMARY KEY,
    config_key TEXT UNIQUE NOT NULL,
    config_value JSONB NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by TEXT
);

-- Hourly aggregated stats
CREATE TABLE safety_hourly_stats (
    hour TIMESTAMPTZ PRIMARY KEY,
    forbidden_hits INTEGER DEFAULT 0,
    auto_rewrites INTEGER DEFAULT 0,
    blocks INTEGER DEFAULT 0,
    review_triggers INTEGER DEFAULT 0
);
```

### Safety Panel Layout

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    AI SAFETY & COMPLIANCE HEALTH                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  SYSTEM STATUS: ✅ HEALTHY               REVIEW MODE: ⚪ INACTIVE       │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │ LAST 24 HOURS                                                     │ │
│  ├───────────────────────────────────────────────────────────────────┤ │
│  │                                                                   │ │
│  │   Forbidden Phrase Hits    │████░░░░░░░░░░░░│   23    ✅ LOW      │ │
│  │   Auto-Rewrites Performed  │██████░░░░░░░░░░│   47    ✅ NORMAL   │ │
│  │   Content Blocks           │░░░░░░░░░░░░░░░░│    0    ✅ ZERO     │ │
│  │   Review Triggers          │░░░░░░░░░░░░░░░░│    0    ✅ ZERO     │ │
│  │                                                                   │ │
│  └───────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │ 7-DAY TREND                                                       │ │
│  ├───────────────────────────────────────────────────────────────────┤ │
│  │     ▲                                                             │ │
│  │  80 │  ╭╮                                                         │ │
│  │  60 │ ╭╯╰╮    ╭──╮                                                │ │
│  │  40 │╭╯   ╰──╮│   ╰╮  ╭─╮                                         │ │
│  │  20 ││       ╰╯    ╰──╯  ╰──                                      │ │
│  │     └─────────────────────────▶                                   │ │
│  │      M    T    W    T    F    S    S                              │ │
│  │                                                                   │ │
│  │   ─── Forbidden Hits   ─── Auto-Rewrites   ─── Blocks             │ │
│  └───────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  TOP TRIGGERED PATTERNS (7d)                                            │
│  ════════════════════════════════════════════════════════════════════  │
│  1. "will happen"       │ 34 hits │ → "may reflect"                    │
│  2. "guaranteed"        │ 28 hits │ → "potential"                      │
│  3. "definitely"        │ 19 hits │ → "possibly"                       │
│  4. "your future"       │ 15 hits │ → "your journey"                   │
│  5. "predict"           │ 12 hits │ → "explore"                        │
│                                                                         │
│  [View All Events]  [Export Safety Report]  [Configure Patterns]        │
└─────────────────────────────────────────────────────────────────────────┘
```

### Health Thresholds

| Metric | Green (Healthy) | Yellow (Warning) | Red (Critical) |
|--------|-----------------|------------------|----------------|
| Forbidden Hits (24h) | 0-50 | 51-150 | >150 |
| Auto-Rewrites (24h) | 0-100 | 101-300 | >300 |
| Content Blocks (24h) | 0 | 1-5 | >5 |
| Review Triggers (24h) | 0 | 1-2 | >2 |
| Unresolved Critical | 0 | 1 | >1 |

### Alert Actions

```
RED ALERT ACTIONS:
═══════════════════════════════════════════════════════════════════════

When safety status turns RED:

1. IMMEDIATE
   □ Enable Review-Safe Mode (all content pre-screened)
   □ Notify owner via push/email
   □ Pause AI content generation temporarily

2. WITHIN 1 HOUR
   □ Review all critical events manually
   □ Identify pattern causing spike
   □ Update filter rules if needed

3. RESOLUTION
   □ Document incident in safety log
   □ Update forbidden patterns if new risk found
   □ Disable Review-Safe Mode when stable
   □ Export incident report for records
```

### Aggregation Queries

```sql
-- 24-hour summary
SELECT
    event_type,
    COUNT(*) as count,
    COUNT(*) FILTER (WHERE severity = 'critical') as critical_count
FROM safety_events
WHERE created_at > NOW() - INTERVAL '24 hours'
GROUP BY event_type;

-- Hourly trend (7 days)
SELECT
    DATE_TRUNC('hour', created_at) as hour,
    event_type,
    COUNT(*) as count
FROM safety_events
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY DATE_TRUNC('hour', created_at), event_type
ORDER BY hour DESC;

-- Top triggered patterns
SELECT
    pattern_matched,
    COUNT(*) as hit_count,
    MAX(created_at) as last_hit
FROM safety_events
WHERE event_type = 'forbidden_phrase_hit'
  AND created_at > NOW() - INTERVAL '7 days'
GROUP BY pattern_matched
ORDER BY hit_count DESC
LIMIT 10;

-- Unresolved critical events
SELECT *
FROM safety_events
WHERE severity = 'critical'
  AND resolved = FALSE
ORDER BY created_at DESC;
```

---

# Section 5 — Platform Health (Web + iOS)

## Platform Health Dashboard

### Data Sources

| Metric | Source | Update Frequency |
|--------|--------|------------------|
| Web Build Status | GitHub Actions API | On push |
| iOS Build Status | GitHub Actions API | On push |
| CI History | GitHub Actions API | Every 15 min |
| Lighthouse Score | Lighthouse CI / GitHub | On deploy |
| Crash-Free Sessions | Firebase Crashlytics | Real-time |
| Cold Start Time | Firebase Performance | Hourly |
| App Store Status | App Store Connect API | Every 6 hours |

### Data Model

```sql
CREATE TABLE build_history (
    id UUID PRIMARY KEY,
    platform TEXT CHECK (platform IN ('web', 'ios', 'android')),
    workflow_name TEXT NOT NULL,
    run_id TEXT NOT NULL,
    status TEXT CHECK (status IN ('success', 'failure', 'pending', 'cancelled')),
    commit_sha TEXT,
    branch TEXT,
    duration_seconds INTEGER,
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE performance_metrics (
    id UUID PRIMARY KEY,
    platform TEXT NOT NULL,
    metric_name TEXT NOT NULL,
    metric_value NUMERIC NOT NULL,
    recorded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE lighthouse_scores (
    id UUID PRIMARY KEY,
    url TEXT NOT NULL,
    performance INTEGER CHECK (performance BETWEEN 0 AND 100),
    accessibility INTEGER CHECK (accessibility BETWEEN 0 AND 100),
    best_practices INTEGER CHECK (best_practices BETWEEN 0 AND 100),
    seo INTEGER CHECK (seo BETWEEN 0 AND 100),
    recorded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE app_store_status (
    id UUID PRIMARY KEY,
    version TEXT NOT NULL,
    build_number TEXT NOT NULL,
    status TEXT CHECK (status IN (
        'prepare_for_submission', 'waiting_for_review',
        'in_review', 'pending_developer_release',
        'ready_for_sale', 'rejected'
    )),
    submitted_at TIMESTAMPTZ,
    reviewed_at TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Dashboard Layout

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        PLATFORM HEALTH                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────┐  ┌─────────────────────────────┐      │
│  │ 🌐 WEB PLATFORM             │  │ 📱 iOS PLATFORM             │      │
│  ├─────────────────────────────┤  ├─────────────────────────────┤      │
│  │ Latest Build: ✅ SUCCESS    │  │ Latest Build: ✅ SUCCESS    │      │
│  │ Commit: a3f8c21             │  │ Commit: a3f8c21             │      │
│  │ Time: 4m 23s                │  │ Time: 12m 47s               │      │
│  │ Branch: main                │  │ Branch: main                │      │
│  │                             │  │                             │      │
│  │ Last 10 Builds:             │  │ Last 10 Builds:             │      │
│  │ ✅✅✅✅✅✅✅✅✅✅          │  │ ✅✅✅❌✅✅✅✅✅✅          │      │
│  │ Success Rate: 100%          │  │ Success Rate: 90%           │      │
│  └─────────────────────────────┘  └─────────────────────────────┘      │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │ LIGHTHOUSE SCORES (Web)                                           │ │
│  ├───────────────────────────────────────────────────────────────────┤ │
│  │                                                                   │ │
│  │   Performance    │████████████████████░░░░│  85  🟢               │ │
│  │   Accessibility  │██████████████████████░░│  92  🟢               │ │
│  │   Best Practices │████████████████████████│ 100  🟢               │ │
│  │   SEO            │██████████████████████░░│  95  🟢               │ │
│  │                                                                   │ │
│  └───────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │ iOS STABILITY (Crashlytics)                                       │ │
│  ├───────────────────────────────────────────────────────────────────┤ │
│  │                                                                   │ │
│  │   Crash-Free Sessions (7d)    │  99.7%  │ 🟢 EXCELLENT            │ │
│  │   Crash-Free Users (7d)       │  99.5%  │ 🟢 EXCELLENT            │ │
│  │   Avg Cold Start Time         │  1.8s   │ 🟢 GOOD                 │ │
│  │   Avg Warm Start Time         │  0.4s   │ 🟢 EXCELLENT            │ │
│  │                                                                   │ │
│  └───────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────────┐ │
│  │ APP STORE STATUS                                                  │ │
│  ├───────────────────────────────────────────────────────────────────┤ │
│  │                                                                   │ │
│  │   Current Version: 2.4.1 (Build 147)                              │ │
│  │   Status: ✅ READY FOR SALE                                       │ │
│  │   Last Review: 2026-02-05 (Approved in 18h)                       │ │
│  │                                                                   │ │
│  │   Pending: 2.4.2 (Build 148) — WAITING FOR REVIEW                 │ │
│  │   Submitted: 2026-02-07                                           │ │
│  │                                                                   │ │
│  └───────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  [View CI Logs]  [Trigger Build]  [View Crash Reports]                  │
└─────────────────────────────────────────────────────────────────────────┘
```

### Health Thresholds

| Metric | Green | Yellow | Red |
|--------|-------|--------|-----|
| Build Success Rate (7d) | ≥95% | 80-95% | <80% |
| Lighthouse Performance | ≥80 | 60-79 | <60 |
| Lighthouse Accessibility | ≥90 | 70-89 | <70 |
| Crash-Free Sessions | ≥99.5% | 98-99.5% | <98% |
| Cold Start Time | <2s | 2-4s | >4s |
| App Store Rejection | None | In review | Rejected |

---

# Section 6 — Internal Dashboard Architecture

## Technical Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    OBSERVATORY ARCHITECTURE                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                         FRONTEND                                 │   │
│  │  /admin/observatory                                              │   │
│  │  ├── /tech-inventory                                             │   │
│  │  ├── /language-coverage                                          │   │
│  │  ├── /content-stats                                              │   │
│  │  ├── /safety-health                                              │   │
│  │  └── /platform-health                                            │   │
│  │                                                                   │   │
│  │  Auth: PIN + Session (reuse AdminAuthService)                    │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│                              ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                     STATE MANAGEMENT                             │   │
│  │                                                                   │   │
│  │  observatoryTechProvider                                         │   │
│  │  observatoryLanguageProvider                                     │   │
│  │  observatoryContentProvider                                      │   │
│  │  observatorySafetyProvider                                       │   │
│  │  observatoryPlatformProvider                                     │   │
│  │                                                                   │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│                              ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                      SERVICES LAYER                              │   │
│  │                                                                   │   │
│  │  ObservatoryService                                              │   │
│  │  ├── fetchTechInventory()                                        │   │
│  │  ├── fetchLanguageCoverage()                                     │   │
│  │  ├── fetchContentStats()                                         │   │
│  │  ├── fetchSafetyHealth()                                         │   │
│  │  ├── fetchPlatformHealth()                                       │   │
│  │  └── exportReport(format: pdf|csv|json)                          │   │
│  │                                                                   │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                          │
│                              ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                      DATA SOURCES                                │   │
│  │                                                                   │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │   │
│  │  │   Supabase   │  │   GitHub     │  │  Firebase    │           │   │
│  │  │   Database   │  │   Actions    │  │  Analytics   │           │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘           │   │
│  │         │                 │                 │                    │   │
│  │         └─────────────────┴─────────────────┘                    │   │
│  │                           │                                      │   │
│  │                     Aggregation                                  │   │
│  │                       Cron Jobs                                  │   │
│  │                    (Every 15 min)                                │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Route Configuration

```dart
// lib/core/constants/routes.dart — additions

static const String observatory = '/admin/observatory';
static const String observatoryTech = '/admin/observatory/tech';
static const String observatoryLanguage = '/admin/observatory/language';
static const String observatoryContent = '/admin/observatory/content';
static const String observatorySafety = '/admin/observatory/safety';
static const String observatoryPlatform = '/admin/observatory/platform';
```

## API Endpoints (Edge Functions / Backend)

```
POST /api/admin/observatory/tech-inventory
  → Returns: TechInventoryResponse

POST /api/admin/observatory/language-coverage
  → Returns: LanguageCoverageResponse

POST /api/admin/observatory/content-stats
  → Query: { period: '7d' | '30d' | '90d' }
  → Returns: ContentStatsResponse

POST /api/admin/observatory/safety-health
  → Query: { period: '24h' | '7d' | '30d' }
  → Returns: SafetyHealthResponse

POST /api/admin/observatory/platform-health
  → Returns: PlatformHealthResponse

POST /api/admin/observatory/export
  → Body: { sections: string[], format: 'pdf' | 'csv' | 'json' }
  → Returns: ExportResponse { url: string, expires_at: timestamp }
```

## Cron Jobs (Background Tasks)

```sql
-- Supabase pg_cron or external scheduler

-- Every 15 minutes: Aggregate safety events
SELECT cron.schedule('aggregate-safety', '*/15 * * * *', $$
    INSERT INTO safety_hourly_stats (hour, forbidden_hits, auto_rewrites, blocks, review_triggers)
    SELECT
        DATE_TRUNC('hour', NOW()),
        COUNT(*) FILTER (WHERE event_type = 'forbidden_phrase_hit'),
        COUNT(*) FILTER (WHERE event_type = 'auto_rewrite'),
        COUNT(*) FILTER (WHERE event_type = 'content_blocked'),
        COUNT(*) FILTER (WHERE event_type = 'review_mode_trigger')
    FROM safety_events
    WHERE created_at > DATE_TRUNC('hour', NOW())
    ON CONFLICT (hour) DO UPDATE SET
        forbidden_hits = EXCLUDED.forbidden_hits,
        auto_rewrites = EXCLUDED.auto_rewrites,
        blocks = EXCLUDED.blocks,
        review_triggers = EXCLUDED.review_triggers;
$$);

-- Every hour: Content stats snapshot
SELECT cron.schedule('content-stats', '0 * * * *', $$
    INSERT INTO content_daily_stats (date, total_items, ai_generated_count, static_count, new_items_count, safety_scanned_count)
    SELECT
        CURRENT_DATE,
        COUNT(*),
        COUNT(*) FILTER (WHERE source = 'ai_generated'),
        COUNT(*) FILTER (WHERE source = 'static'),
        COUNT(*) FILTER (WHERE created_at > CURRENT_DATE),
        COUNT(*) FILTER (WHERE last_safety_scan > NOW() - INTERVAL '24 hours')
    FROM content_items
    WHERE is_active = TRUE
    ON CONFLICT (date) DO UPDATE SET
        total_items = EXCLUDED.total_items,
        ai_generated_count = EXCLUDED.ai_generated_count,
        static_count = EXCLUDED.static_count,
        new_items_count = EXCLUDED.new_items_count,
        safety_scanned_count = EXCLUDED.safety_scanned_count;
$$);

-- Every 6 hours: Scan for hardcoded strings
SELECT cron.schedule('hardcode-scan', '0 */6 * * *', $$
    -- Trigger external script or edge function
    SELECT net.http_post('https://your-project.supabase.co/functions/v1/scan-hardcoded-strings');
$$);
```

## Export Formats

### PDF Report Template

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│                    PLATFORM OBSERVATORY REPORT                          │
│                    Generated: 2026-02-08 14:30 UTC                      │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  EXECUTIVE SUMMARY                                                      │
│  ═══════════════════════════════════════════════════════════════════   │
│  Overall Health: ✅ GOOD                                                │
│  Translation Coverage: 92.1%                                            │
│  Content Items: 12,847                                                  │
│  Safety Score: 99.7%                                                    │
│  Platform Stability: 99.5%                                              │
│                                                                         │
│  [Section details follow...]                                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### CSV Export Structure

```csv
# tech_inventory.csv
engine_name,purpose,safety_role,visibility,status
Language Engine,i18n + strict locale isolation,Prevents cross-language contamination,Internal,Active
AI Safety Engine,Content compliance & filtering,Primary safety gate,Internal,Active
...

# language_coverage.csv
locale,translated_count,total_strings,coverage_pct,missing_count,last_updated
en,2847,2847,100.0,0,2026-02-08
tr,2831,2847,99.4,16,2026-02-08
...

# safety_events.csv
timestamp,event_type,severity,pattern_matched,source_service,resolved
2026-02-08T10:23:45Z,auto_rewrite,low,"will happen",dream_interpretation_service,true
...
```

---

# Section 7 — Public Technology Page (Optional)

## Safe Public Display

**Route**: `/about/technology` or `/our-technology`

### Page Structure

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│                        Our Technology                                   │
│                                                                         │
│        Built with care for privacy, personalization, and trust          │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ 🔒 Privacy-First Design                                          │   │
│  │                                                                   │   │
│  │ Your personal information stays on your device. We use           │   │
│  │ on-device processing whenever possible, ensuring your data       │   │
│  │ remains private and secure.                                      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ 🌍 Multi-Language Support                                        │   │
│  │                                                                   │   │
│  │ Experience our app in English, Turkish, German, and French.      │   │
│  │ Our language engine ensures a seamless, native experience        │   │
│  │ in your preferred language.                                      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ ✨ Personalized Experience                                       │   │
│  │                                                                   │   │
│  │ Our personalization engine learns your preferences over time,    │   │
│  │ creating a unique experience tailored just for you—without       │   │
│  │ compromising your privacy.                                       │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ 🛡️ Content Safety                                                │   │
│  │                                                                   │   │
│  │ Every piece of content is carefully reviewed by our safety       │   │
│  │ systems. We're committed to providing thoughtful, responsible    │   │
│  │ content that supports your personal reflection journey.          │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │ 📱 Cross-Platform                                                │   │
│  │                                                                   │   │
│  │ Available on iOS and Web, with a consistent experience           │   │
│  │ across all your devices. Start on one, continue on another.      │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                                                                         │
│                                                                         │
│  ─────────────────────────────────────────────────────────────────────  │
│                                                                         │
│  For Entertainment Purposes Only                                        │
│  This app provides content for personal reflection and entertainment.   │
│  It is not intended to provide professional advice of any kind.         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Section Copy (Apple-Safe)

| Section | Title | Copy |
|---------|-------|------|
| Privacy | Privacy-First Design | Your personal information stays on your device. We use on-device processing whenever possible, ensuring your data remains private and secure. |
| Language | Multi-Language Support | Experience our app in English, Turkish, German, and French. Our language engine ensures a seamless, native experience in your preferred language. |
| Personalization | Personalized Experience | Our personalization engine learns your preferences over time, creating a unique experience tailored just for you—without compromising your privacy. |
| Safety | Content Safety | Every piece of content is carefully reviewed by our safety systems. We're committed to providing thoughtful, responsible content that supports your personal reflection journey. |
| Platform | Cross-Platform | Available on iOS and Web, with a consistent experience across all your devices. Start on one, continue on another. |

### Copy Guidelines (What NOT to Say)

| Avoid | Use Instead |
|-------|-------------|
| "Predicts your future" | "Supports personal reflection" |
| "Fortune telling" | "Self-discovery tools" |
| "Accurate predictions" | "Thoughtful insights" |
| "Guaranteed results" | "Personalized experience" |
| "Astrology readings" | "Symbolic exploration" |
| "Your destiny" | "Your journey" |
| "Supernatural" | "Thoughtful" |

---

# Section 8 — Owner Value Summary

## Strategic Benefits

### 1. Product Control

```
┌─────────────────────────────────────────────────────────────────────────┐
│ PRODUCT CONTROL VALUE                                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│ ✓ Single dashboard for ALL platform metrics                            │
│ ✓ Real-time visibility into content health                             │
│ ✓ Instant detection of translation gaps                                │
│ ✓ Proactive safety monitoring (before user reports)                    │
│ ✓ Build status awareness across platforms                              │
│                                                                         │
│ OUTCOME: Make informed decisions in minutes, not hours                  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2. Apple Review Defense

```
┌─────────────────────────────────────────────────────────────────────────┐
│ APPLE REVIEW DEFENSE VALUE                                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│ EXPORTABLE PROOF ARTIFACTS:                                             │
│                                                                         │
│ □ Safety System Documentation                                           │
│   "We have a multi-layer content safety system that..."                 │
│                                                                         │
│ □ Content Filtering Report                                              │
│   "100% of AI-generated content passes through safety filters..."       │
│                                                                         │
│ □ Forbidden Pattern Registry                                            │
│   "We explicitly block 45+ patterns including..."                       │
│                                                                         │
│ □ Entertainment Disclaimer Evidence                                     │
│   "Disclaimer appears on X screens, shown Y times per session..."       │
│                                                                         │
│ □ Translation Completeness                                              │
│   "All user-facing strings are localized (no hardcoded content)..."     │
│                                                                         │
│ OUTCOME: Respond to App Review questions with data, not promises        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3. Investor Credibility

```
┌─────────────────────────────────────────────────────────────────────────┐
│ INVESTOR CREDIBILITY VALUE                                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│ DEMONSTRABLE TECHNICAL DEPTH:                                           │
│                                                                         │
│ • 9 proprietary engines with clear purposes                             │
│ • Multi-language platform (4 languages, 99%+ coverage)                  │
│ • 12,000+ content items with safety scoring                             │
│ • Real-time compliance monitoring                                       │
│ • Cross-platform CI/CD with quality gates                               │
│                                                                         │
│ EXPORTABLE METRICS:                                                     │
│                                                                         │
│ • Content growth trajectory                                             │
│ • Platform stability metrics                                            │
│ • User engagement data (anonymized)                                     │
│ • Safety system performance                                             │
│                                                                         │
│ OUTCOME: Show technical maturity without revealing proprietary details  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 4. Faster Iteration

```
┌─────────────────────────────────────────────────────────────────────────┐
│ FASTER ITERATION VALUE                                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│ BEFORE OBSERVATORY:                                                     │
│ ─────────────────────────────────────────────────────────────────────   │
│ • Check GitHub Actions manually                                         │
│ • Run local scripts to count translations                               │
│ • Search codebase for hardcoded strings                                 │
│ • Review safety logs in multiple places                                 │
│ • Hope nothing breaks between checks                                    │
│                                                                         │
│ AFTER OBSERVATORY:                                                      │
│ ─────────────────────────────────────────────────────────────────────   │
│ • Single dashboard: 30 seconds to full health check                     │
│ • Alerts for anomalies (no manual checking)                             │
│ • Export reports for any time period                                    │
│ • Historical trends for pattern recognition                             │
│ • Confidence to ship faster                                             │
│                                                                         │
│ OUTCOME: Reduce ops overhead by 80%, increase shipping confidence       │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5. Risk Reduction

```
┌─────────────────────────────────────────────────────────────────────────┐
│ RISK REDUCTION VALUE                                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│ RISKS MITIGATED:                                                        │
│                                                                         │
│ ✓ App Store Rejection                                                   │
│   → Safety dashboard proves compliance                                  │
│                                                                         │
│ ✓ Untranslated Content Reaching Users                                   │
│   → Language coverage dashboard catches gaps                            │
│                                                                         │
│ ✓ AI Content Violating Guidelines                                       │
│   → Real-time safety monitoring with alerts                             │
│                                                                         │
│ ✓ Build Failures Going Unnoticed                                        │
│   → Platform health shows CI status                                     │
│                                                                         │
│ ✓ Performance Regression                                                │
│   → Lighthouse + Crashlytics monitoring                                 │
│                                                                         │
│ ✓ Investor Due Diligence Surprises                                      │
│   → Always-ready export capability                                      │
│                                                                         │
│ OUTCOME: Sleep better knowing the platform is monitored 24/7            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Implementation Priority

| Phase | Components | Effort | Impact |
|-------|------------|--------|--------|
| **Phase 1** | Safety Health Panel + Basic Dashboard Shell | Medium | High |
| **Phase 2** | Language Coverage Dashboard | Low | High |
| **Phase 3** | Content Inventory Stats | Medium | Medium |
| **Phase 4** | Platform Health Integration | Medium | Medium |
| **Phase 5** | Export System (PDF/CSV) | Medium | High |
| **Phase 6** | Public Technology Page | Low | Low |

---

## Quick Reference: File Locations

| Component | Path |
|-----------|------|
| Admin Dashboard | `lib/features/admin/presentation/admin_dashboard_screen.dart` |
| Admin Auth | `lib/data/services/admin_auth_service.dart` |
| Content Safety Filter | `lib/data/services/content_safety_filter.dart` |
| L10n Service | `lib/data/services/l10n_service.dart` |
| Localization Files | `assets/l10n/{en,tr,de,fr}.json` |
| Routes | `lib/core/constants/routes.dart` |
| Admin Providers | `lib/data/providers/admin_providers.dart` |

---

**Document Classification**: INTERNAL — Owner/Admin Only
**Do Not Share**: Contains proprietary system architecture details
