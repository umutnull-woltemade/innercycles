# INNER CYCLES — SYSTEM SPEC v1

> Generated: 2026-02-21 | War Room: 6-Agent Parallel Build
> Status: COMPLETE — All 16 Phases Merged

---

## TABLE OF CONTENTS

1. [Semantic Pillars](#phase-2--core-semantic-pillars)
2. [Emotional Architecture 2.0](#phase-3--emotional-architecture-20)
3. [Emotional Architecture 3.0](#phase-4--emotional-architecture-30)
4. [State → Cycle → Signal → Decision Conversions](#phase-5--state-conversions)
5. [Feature Taxonomy](#phase-6--feature-taxonomy)
6. [Feature Renaming Engine](#phase-7--feature-renaming-engine)
7. [Vocabulary Rules](#phase-1--generic-word-purge)
8. [UI Language System](#phase-8--ui-language-calibration)
9. [Screenshot System](#phase-9--screenshot-system)
10. [Paywall Variants](#phase-10--paywall-reframe)
11. [Category Escape](#phase-11--category-escape-manifesto)
12. [Product Narrative](#phase-12--product-narrative)
13. [VC Story](#phase-13--vc-level-story)
14. [Consistency Map](#phase-14--semantic-consistency-map)
15. [Moat Model](#phase-15--competitive-moat)
16. [Do/Don't Checklist](#dodont-checklist)

---

# PHASE 1 — GENERIC WORD PURGE

## BANNED_VOCABULARY_LIST (Never in InnerCycles UI)

```
cosmic, celestial, zodiac, universe, manifest, aura, vibration, chakra,
self-care, inner peace, transform your life, be your best self, healing,
self-love, positive vibes, zen, find your center, inner stillness,
unlock your potential, level up, supercharge, limitless, 10x, life hack,
journey (standalone), sacred, divine, spiritual awakening, higher self,
soulmate, destiny, fate, oracle, mystical, magical powers,
wellness journey, positive energy, good vibes, self-discovery (standalone)
```

## SAFE_METADATA_TERMS (ASO only, never in UI)

```
mood tracker, journal app, self-improvement, personal growth app,
mindfulness app, mental health journal, daily journal, gratitude journal,
habit tracker, meditation timer, emotional intelligence, self-reflection app,
wellness tracker, anxiety journal, mood diary
```

## GENERIC_WORD_LIST (by domain)

### Astrology / Spiritual
| Term | Risk | Why It Dilutes |
|---|---|---|
| cosmic | HIGH | New-age positioning; repels analytical users |
| celestial | HIGH | Zero functional meaning |
| zodiac | HIGH | Direct astrology association |
| manifest | HIGH | MLM/hustle-culture association |
| alignment | MEDIUM | Ambiguous (spiritual vs data) |
| energy (unqualified) | MEDIUM | Without "physical/mental" qualifier, reads as crystal healing |

### Mood / Self-Help
| Term | Risk | Why It Dilutes |
|---|---|---|
| self-care | HIGH | Meaningless from overuse |
| mindfulness | HIGH | Lost specificity |
| wellness journey | HIGH | Most diluted phrase in app store |
| transform your life | HIGH | Dark pattern territory |
| healing | HIGH | Medical overclaim risk |
| balance | MEDIUM | Fine as data descriptor; toxic as promise |

### Productivity / AI
| Term | Risk | Why It Dilutes |
|---|---|---|
| unlock your potential | HIGH | Most overused app store phrase |
| AI-powered | MEDIUM | Acceptable in technical context only |
| optimize | MEDIUM | Fine in data context; poor in lifestyle context |
| hack | HIGH | Credibility destroyer |

---

# PHASE 2 — CORE SEMANTIC PILLARS

## Pillar 1: CYCLE INTELLIGENCE
- **Definition**: Detection, mapping, and analysis of recurring behavioral patterns across personal time-series data
- **Differentiator**: Treats personal data as cyclical signal, finding recurrence where others see randomness
- **Clone Difficulty**: 8/10
- **Approved Terms**: cycle map, recurrence signal, pattern frequency, rhythm detection, phase mapping, temporal correlation, behavioral cadence
- **Banned Terms**: biorhythm, horoscope cycle, cosmic rhythm, energy cycle (unqualified), vibe check

## Pillar 2: PATTERN ARCHAEOLOGY
- **Definition**: Systematic excavation of behavioral patterns from accumulated personal data
- **Differentiator**: Forensic tool for self-understanding; user's data is authority, not the app's opinion
- **Clone Difficulty**: 7/10
- **Approved Terms**: pattern layer, data excavation, trend stratigraphy, recurring theme, signal surface, correlation artifact
- **Banned Terms**: AI prediction, fortune telling, personality test, destiny mapping

## Pillar 3: STRUCTURED SELF-OBSERVATION
- **Definition**: Disciplined, repeatable protocol for recording subjective experience in analyzable format
- **Differentiator**: Focus areas + rating scales + categorical tagging = analyzable data, not text blobs
- **Clone Difficulty**: 5/10
- **Approved Terms**: focus area, observation protocol, structured entry, dimensional logging, signal capture
- **Banned Terms**: free writing, brain dump, thought dump, express yourself freely

## Pillar 4: SIGNAL-TO-NOISE FILTERING
- **Definition**: Distinguishing meaningful behavioral patterns from random variation
- **Differentiator**: Significance thresholds (|r|>=0.3, n>=7) surface only patterns that cross meaningful thresholds
- **Clone Difficulty**: 7/10
- **Approved Terms**: signal strength, significance threshold, trend detection, pattern confidence, measurable variance
- **Banned Terms**: AI magic, smart insights (vague), cosmic guidance, hidden message

## Pillar 5: BEHAVIORAL RECURRENCE MAPPING
- **Definition**: Visual and analytical representation of how behaviors and states repeat over time
- **Differentiator**: Heatmaps, phase rings, cycle waves reveal recurrence spatially, not just temporally
- **Clone Difficulty**: 6/10
- **Approved Terms**: recurrence map, heatmap density, cycle visualization, phase ring, frequency plot
- **Banned Terms**: mood chart, feelings graph, vibes visualization, soul map

## Pillar 6: REFLECTIVE INTELLIGENCE (not Predictive)
- **Definition**: Intelligence that looks backward at documented data, never forward
- **Differentiator**: Legal/compliance moat — structurally App Store safe. "Past entries suggest" not "you will"
- **Clone Difficulty**: 9/10
- **Approved Terms**: past entries suggest, your data shows, based on your logs, documented recurrence
- **Banned Terms**: predict, forecast, will happen, expect to see, your future shows

## Pillar 7: DATA SOVEREIGNTY
- **Definition**: User data stays on device, fully exportable, app is a lens not a vault
- **Differentiator**: Local-first (SharedPreferences + Hive), no server storage. Structural privacy, not policy-based
- **Clone Difficulty**: 4/10
- **Approved Terms**: local-first, device-stored, full export, private by design, zero-knowledge
- **Banned Terms**: cloud-powered insights, we analyze your data, shared with partners

---

# PHASE 3 — EMOTIONAL ARCHITECTURE 2.0

## Framework: STATE → CYCLE → SIGNAL → DECISION → ADAPTATION

### Layer 1: STATE
- **Role**: Capture current internal condition through structured multi-axis input
- **User Value**: "I can record exactly what I am experiencing in a way computers can analyze"
- **UI**: Journal entry with 5 focus areas (Energy, Focus, Emotions, Decisions, Social), 3 sub-ratings each, mood check-in, sleep, gratitude, habits, dreams
- **Data**: `JournalEntry` with `FocusArea`, `overallRating`, `subRatings` map, linked `SleepEntry`, `GratitudeEntry`, `MoodEntry`
- **Retention**: Daily engagement through multi-modal capture points
- **Risks**: Input fatigue if too many fields required per session

### Layer 2: CYCLE
- **Role**: Detect repeating patterns over time via temporal intelligence
- **User Value**: "I can see that my emotional patterns have a shape, length, and rhythm"
- **UI**: Waveform View (animated wave curves per dimension), Heatmap Timeline, Monthly Pulse
- **Data**: `EmotionalCycleService` — rolling averages (7/14/30), peak-to-peak cycle detection, 5-phase model (Expansion/Stabilization/Contraction/Reflection/Recovery)
- **Retention**: Weekly — users return to see how their cycles are evolving
- **Risks**: Overclaiming cyclicality where data is noisy

### Layer 3: SIGNAL
- **Role**: Surface statistically meaningful findings from pattern detection
- **User Value**: "The app shows me which changes are real versus random noise"
- **UI**: Cross-Dimension Radar (Pearson correlations), Trend Compass, Pattern Loops, Blind Spot Detector
- **Data**: `PatternEngineService` — 7 cross-correlation types, minimum n=7, significance |r|>=0.3
- **Retention**: The insight reveal is the primary D7-D30 retention mechanism
- **Risks**: Spurious correlations with small samples; users misinterpreting correlation as causation

### Layer 4: DECISION
- **Role**: Convert signals into concrete behavioral micro-decisions
- **User Value**: "Based on what my data shows, here are specific actions I can take"
- **UI**: Guided Breathwork, Prompt Engine, Smart Nudge, Challenge Sequences
- **Data**: `DecisionOption` tied to triggering signal, with outcome tracking
- **Retention**: Converts passive observers into active participants
- **Risks**: Overclaiming ("do this and you will feel better"); suggestion fatigue

### Layer 5: ADAPTATION
- **Role**: Track whether decisions led to measurable change; system evolves
- **User Value**: "The app learns my patterns over time. Month 6 is sharper than Month 1"
- **UI**: Growth Ledger, Baseline Drift, Before/After Lens, Year Synthesis
- **Data**: `AdaptationProfile` — maturity index, resolved loops, personal baselines
- **Retention**: Highest long-term. This IS the switching cost. After 90 days, irreplaceable.
- **Risks**: Diminishing returns after 6 months unless new dimensions introduced

### HOW THIS ESCAPES ASTROLOGY
1. Data-driven, not birth-chart-driven — every insight references logged data with timestamps and sample sizes
2. Falsifiable — cycle lengths are detected via peak intervals, can be wrong, and says so
3. Progressive unlock tied to behavior, not birth date
4. Safe language enforced at code level ("tends to", "may", "suggests")
5. Pearson correlation with min samples and significance thresholds = statistical methodology, not divination

---

# PHASE 4 — EMOTIONAL ARCHITECTURE 3.0

## A) DATA INPUT LAYER

**Active Inputs** (implemented):
- Journal: FocusArea + overallRating + 3 subRatings + note
- Mood: 1-5 + emoji
- Sleep: 1-5 + note
- Gratitude: 1-3 text items
- Habits: binary daily completion
- Rituals: binary per item per day
- Dreams: 25+ fields (content, symbols, emotion, lucid/nightmare, characters, locations, personal dictionary)

**Passive Inputs** (derivable, no new collection):
- Entry timing (hour-of-day from `JournalEntry.createdAt`)
- Entry frequency (date gap analysis)
- Input length (note text length as engagement proxy)
- Streak continuity
- Weekday patterns

All data on-device. SharedPreferences + Hive. No server sync.

## B) PATTERN ENGINE

Three analysis modes:

**Recurrence Detection**: Peak-to-peak cycle length per FocusArea, weekday loops, rolling averages at 7/14/30-day windows

**Variability Analysis**: Standard deviation in emotional phase detection, half-split trend comparison, health status classification

**Clustering**: Pearson cross-area correlation, 7 cross-dimension types (sleep-mood, sleep-energy, gratitude-mood, ritual-focus, wellness-journal, streak-mood, sleep-stress), co-occurrence detection

**Clone Complexity**: HIGH — Not one algorithm but 7 cross-correlation types, 3 loop detection strategies, 5-phase emotional modeling, rolling averages at 3 windows, cycle length detection. Service interdependency graph requires reimplementing entire service layer.

## C) BEHAVIORAL RESPONSE MODEL

**Micro-Decisions**: Phase-appropriate actions (each `EmotionalPhase` has `actionEn()/actionTr()`), loop-specific suggestions
**Prompts**: Context-aware journal prompts adapted to current phase and under-explored dimensions
**Reflections**: Monthly summaries, seasonal reflections, year review, pattern loop resolution tracking

## D) EVOLUTION & MATURITY INDEX

| Tier | Entries | Capability |
|---|---|---|
| Observer | 0-6 | State capture, no patterns |
| Tracker | 7-13 | Basic patterns unlocked |
| Analyst | 14-29 | Loop detection, cross-correlations emerging |
| Navigator | 30-89 | Full cycle detection, phase transitions |
| Architect | 90+ | Longitudinal baselines, seasonal patterns |

**Why hard to replicate in <90 days**: Service interdependency graph (PatternEngine takes 7 services), tuned thresholds for small datasets, safe language system across 50+ message templates in EN+TR, custom 5-phase emotional model, behavioral loop detection with 3 strategies.

---

# PHASE 5 — STATE CONVERSIONS

| Generic Term | State | Cycle Name | Signal | Decision Support | Premium Label | Banned Synonyms |
|---|---|---|---|---|---|---|
| **Energy** | Current physical/mental resource level | Energy Rhythm | 7-day rolling avg drops below baseline; sleep-energy correlation | "Sleep quality and energy tend to follow. Consider adjusting tonight's routine." | Energy Rhythm Analysis | vitality, life force, chi, aura |
| **Focus** | Current capacity for sustained attention | Focus Cadence | Distractibility >3.5 for 3+ entries; clarity <2.5; weekday patterns | "Focus tends to be stronger on [bestDay]. Schedule demanding work there." | Focus Cadence Mapping | attention deficit, brain fog, mental block |
| **Mood** | Current overall emotional tone | Mood Wave | 7-day avg drops below 30-day avg; phase transition to contraction | "You may be in a contraction phase. Self-care tends to work well here." | Mood Wave Intelligence | depression, bipolar, manic, disorder |
| **Burnout** | Sustained multi-dimension depletion | Depletion Pattern | 2+ FocusAreas at HealthStatus.red simultaneously | "Multiple dimensions lower than usual. Reducing commitments aided recovery before." | Depletion Pattern Alert | burnout syndrome, breakdown, crash |
| **Anxiety** | Elevated tension with reduced calm | Tension Rhythm | Stress >3.5 + calm <2.5 over 5+ entries; sleep-stress negative correlation | "Sleep quality and stress negatively correlated. Prioritizing sleep may help." | Tension Rhythm Analysis | anxiety disorder, panic, GAD |
| **Motivation** | Current drive to initiate action | Drive Cycle | Motivation sub-rating <2.5; streak breaks; habit completion <50% | "Motivation and streak consistency reinforce each other. Start with one micro-habit." | Drive Cycle Tracking | lazy, worthless, failure |
| **Creativity** | Capacity for novel thinking | Creative Tide | Note length increases with high clarity; creative habit engagement up | "Unstructured time during peak clarity may support creative output." | Creative Tide Mapping | artistic genius, divine inspiration |
| **Overwhelm** | Demands exceeding capacity | Load Pattern | Decision certainty <2.0 + regret >3.5 + declining productivity | "This tends to be temporary. One area at a time has coincided with recovery." | Load Pattern Detection | mental breakdown, snapping |
| **Confidence** | Trust in own judgment | Assurance Pattern | Decision confidence trend; confidence-communication co-movement | "Confidence and communication tend to move together. Low-stakes interaction may help." | Assurance Pattern Analysis | inferiority complex, narcissism |
| **Fatigue** | Reduced physical/mental stamina | Stamina Rhythm | Physical energy <2.5; sleep quality declining; ritual completion dropping | "Protecting sleep and pausing non-essential rituals may help." | Stamina Rhythm Analysis | chronic fatigue syndrome, medical fatigue |
| **Procrastination** | Delayed action despite intention | Delay Pattern | Entry timing shifts later; distractibility >3.5; low motivation | "Earlier logging coincided with better focus ratings in your history." | Delay Pattern Intelligence | lazy, ADHD, executive dysfunction |
| **Sensitivity** | Heightened emotional responsiveness | Receptivity Wave | Isolation >3.0 + connection <2.5; high emotional variability | "Reducing social exposure during receptive periods coincided with stabilization." | Receptivity Wave Analysis | HSP diagnosis, fragile, overly emotional |

---

# PHASE 6 — FEATURE TAXONOMY

## Architecture: STATE → CYCLE → SIGNAL → DECISION → ADAPTATION

### CATEGORY 1: STATE CAPTURE ENGINE
| Feature | Free/Premium | Retention Role | Clone Resistance |
|---|---|---|---|
| **Pulse Log** (replaces Mood Check-in) | Free | Daily | 2 |
| **Dimension Journal** | Free (1 area) / Premium (all 5) | Daily | 6 |
| **Sleep Imprint** | Free | Daily | 2 |
| **Anchor Log** (Gratitude) | Free (1 item) / Premium (3) | Daily | 3 |
| **Voice Capture** | Premium | Daily | 4 |
| **Routine Tracker** | Free (3) / Premium (unlimited) | Daily | 4 |
| **Dream Ledger** | Premium | Daily | 5 |

### CATEGORY 2: CYCLE DETECTION SYSTEM
| Feature | Free/Premium | Retention Role | Clone Resistance |
|---|---|---|---|
| **Waveform View** (hero feature) | Premium | Weekly/Longitudinal | 9 |
| **Phase Detector** | Premium | Weekly | 8 |
| **Cycle Length Estimator** | Premium | Longitudinal | 8 |
| **Heatmap Timeline** | Free (month) / Premium (all) | Weekly | 6 |
| **Monthly Pulse** | Premium | Monthly | 7 |
| **Shift Outlook** | Premium | Weekly | 9 |

### CATEGORY 3: SIGNAL INTELLIGENCE
| Feature | Free/Premium | Retention Role | Clone Resistance |
|---|---|---|---|
| **Cross-Dimension Radar** | Premium | Weekly | 8 |
| **Trend Compass** | Free (7-day) / Premium (30-day) | Weekly | 6 |
| **Pattern Loops** | Pro tier | Longitudinal | 9 |
| **Consistency Index** | Free | Daily/Weekly | 5 |
| **Blind Spot Detector** | Pro tier | Longitudinal | 8 |
| **Day-of-Week Signature** | Premium | Monthly | 7 |

### CATEGORY 4: DECISION LAYER
| Feature | Free/Premium | Retention Role | Clone Resistance |
|---|---|---|---|
| **Guided Breathwork** | Free (3) / Premium (custom) | Daily | 3 |
| **Stillness Timer** | Free (5 min) / Premium (all) | Daily | 3 |
| **Prompt Engine** | Premium | Daily | 7 |
| **Smart Nudge** | Premium | Daily | 7 |
| **Challenge Sequences** | Premium | Weekly | 6 |
| **Year Synthesis** | Pro tier | Longitudinal | 8 |

### CATEGORY 5: ADAPTATION & IDENTITY
| Feature | Free/Premium | Retention Role | Clone Resistance |
|---|---|---|---|
| **Growth Ledger** | Free (basic) / Premium | Weekly | 5 |
| **Streak Engine** | Free / Premium (freeze) | Daily | 4 |
| **Baseline Drift** | Pro tier | Longitudinal | 9 |
| **Before/After Lens** | Pro tier | Longitudinal | 8 |
| **Archive Vault** | Free (30 days) / Premium (all) | Longitudinal | 4 |
| **Data Portability** | Free (7-day) / Premium (full) | Longitudinal | 2 |

---

# PHASE 7 — FEATURE RENAMING ENGINE

## Core Renames

| Current Name | New Premium Name | Architecture Layer |
|---|---|---|
| Today Feed | **Command Center** | DECISION |
| Daily Entry / Journal | **Dimension Journal** | STATE |
| Mood Trends | **Signal Dashboard** | SIGNAL |
| Breathing Timer | **Guided Breathwork** | DECISION |
| Profile Hub | **Growth Ledger** | ADAPTATION |
| Mood Check-in | **Pulse Log** | STATE |
| Emotional Cycles | **Waveform View** | CYCLE |
| Patterns | **Cross-Dimension Radar** | SIGNAL |
| Calendar Heatmap | **Heatmap Timeline** | CYCLE |
| Monthly Reflection | **Monthly Pulse** | CYCLE |
| Journal Archive | **Archive Vault** | ADAPTATION |
| Streak Stats | **Streak Engine** | ADAPTATION |
| Export Data | **Data Portability** | ADAPTATION |
| Gratitude Section | **Anchor Log** | STATE |
| Sleep Section | **Sleep Imprint** | STATE |
| Rituals | **Routine Tracker** | STATE |
| Wellness Detail | **Consistency Index** | SIGNAL |
| Energy Map | **Energy Profile** | SIGNAL |
| Programs | **Challenge Sequences** | DECISION |
| Affirmations | **Reframe Deck** | DECISION |
| Year Review | **Year Synthesis** | ADAPTATION |
| Blind Spot | **Blind Spot Detector** | SIGNAL |
| Prompt Library | **Prompt Engine** | DECISION |
| Weekly Digest | **Weekly Debrief** | CYCLE |
| Moon Calendar | **Natural Rhythm Calendar** | CYCLE |
| Challenges | **Protocol Lab** | DECISION |

## NAME STYLE GUIDE

### Patterns to FOLLOW
1. **Instrument Pattern**: Name like tools — "Radar", "Engine", "Vault" (not "analyzing", "storing")
2. **Specificity**: What it reveals, not what it does — "Waveform View" not "Emotional Chart"
3. **System Pattern**: Words implying larger intelligence system — "Engine", "Radar", "Index", "Protocol"
4. **Two-Word Maximum**: Never three. Never one unless highly distinctive.
5. **Action + Object**: "Pulse Log", "Streak Engine", "Signal Dashboard"

### Patterns to AVOID
1. Activity naming: "Journaling", "Breathing", "Tracking"
2. Vague containers: "Hub", "Center" alone
3. Wellness clichés: "Journey", "Path", "Bloom", "Glow", "Flow", "Zen"
4. Timer/Counter naming as primary
5. Plural collections: "Insights", "Patterns", "Stats" standalone

### Word Categories

| PREFER | BAN |
|---|---|
| Instruments: Radar, Compass, Lens, Detector | Spiritual: Ritual, Cosmic, Celestial, Chakra |
| Records: Ledger, Vault, Archive, Log, Imprint | Medical: Diagnosis, Treatment, Therapy, Heal |
| Systems: Engine, Protocol, Index, Sequence | Generic Wellness: Journey, Mindful, Zen, Harmony |
| Optics: Waveform, Spectrum, Pulse, Signal | Gamification: Challenge, Badge, Level, Quest |
| Architecture: Layer, Map, Profile, Grid | AI Hype: AI-powered, Smart (prefix), Predictive |

---

# PHASE 8 — UI LANGUAGE CALIBRATION

## Copy Rules

### DO
- Concrete nouns/verbs: "logged", "detected", "measured", "appeared"
- Reference specific data: "Your energy was 2.1 lower on Mondays this month"
- Acknowledge uncertainty: "may suggest", "tended to", "appeared more often"
- Temporal anchors: "this week", "last 30 days", "since October"
- Let user draw conclusions

### DO NOT
- Promise outcomes: "This will help you feel better"
- Use urgency: "Don't miss out!"
- Anthropomorphize: "InnerCycles thinks you should..."
- Passive-aggressive nudges: "You haven't journaled in 3 days"
- Comparative claims: "Better than therapy"
- Exclamation marks in insight text

## 10 Replacement Patterns

| Generic → | Premium → |
|---|---|
| "Track your mood" | "Record an observation" |
| "Get insights about yourself" | "Surface patterns from your entries" |
| "Start your wellness journey" | "Begin cycle mapping" |
| "Unlock your potential" | "Access your full pattern history" |
| "AI-powered insights" | "Data-grounded reflections" |
| "Your daily wellness check" | "Structured daily observation" |
| "How are you feeling today?" | "What's present for you right now?" |
| "Discover your true self" | "See what your data shows" |
| "Achieve balance in your life" | "Map where your attention goes" |
| "Transform your mindset" | "Observe how your patterns shift" |

## 20 Microcopy Examples

| Surface | Copy |
|---|---|
| Morning greeting | "What are you carrying into today?" |
| Evening greeting | "What stayed with you from today?" |
| Empty state (no entries) | "Nothing recorded yet. Your first entry starts the pattern." |
| Insight (sufficient data) | "Your focus scores dropped 18% on weeks with fewer than 3 entries." |
| Insight (insufficient) | "3 more entries to activate pattern detection." |
| Daily reminder | "9:00 AM — structured observation window" |
| Streak at risk | "Your recording streak is at 14 days. Today's entry keeps it active." |
| Weekly digest | "This week's recurrence data is ready to review." |
| Mood trends (no data) | "No observations recorded. Check in from the home screen to begin." |
| Pattern screen (insufficient) | "Pattern detection requires a minimum of 7 entries across 5 days." |
| Network error | "Could not load. Your local data is unaffected." |
| Save failure | "Entry not saved. Try again — your text is preserved." |
| Pattern calculation | "Scanning your entry history..." |
| Report generation | "Compiling 30 days of observations..." |
| Paywall headline | "Your data has more to show." |
| Feature gate (patterns) | "Full recurrence analysis available with Pro." |
| Feature gate (export) | "Export your complete dataset — all formats, all entries." |
| Post-purchase | "Pro features active. Your full pattern history is accessible." |
| Dream archive (empty) | "No dreams logged. The glossary is available when you are." |
| Sync conflict | "A newer version exists. Review before overwriting." |

---

# PHASE 9 — SCREENSHOT SYSTEM

## Primary Arc: Awareness → Pattern → Signal → Decision → Adaptation

| Slide | Headline | Subtext | Intent | Category Escape Signal |
|---|---|---|---|---|
| 1 | "Record what you notice." | "Structured daily observations across energy, focus, emotions, social, and decisions." | App = precision instrument, not diary | No "journaling" or "mood tracking" |
| 2 | "See what repeats." | "Cycle detection surfaces recurring patterns invisible in a linear timeline." | Curiosity about self-knowledge through data | "Cycle detection" = engineering, not wellness |
| 3 | "Separate signal from noise." | "Not every fluctuation matters. Confidence scores show which changes are meaningful." | Intellectual credibility | "Pattern confidence scores" = data science |
| 4 | "Data before decisions." | "Monthly reports and trend comparisons give you a factual basis before you act." | Decision-support tool | "Factual basis" rejects emotional-first framing |
| 5 | "Observe how you change." | "Long-term pattern overlays reveal how behavioral cycles shift across months." | Long-term value, justifies subscription | "Behavioral cycles shift" = behavioral science |

## Alt A: Analytical / Tech-Forward
1. "Structured behavioral logging." → "Five dimensional capture: energy, focus, emotion, social, decisions."
2. "Temporal pattern detection." → "Algorithms scan for statistically significant recurrences."
3. "Confidence-scored insights." → "Every pattern comes with a strength rating."
4. "Exportable personal dataset." → "CSV, JSON, or PDF. Your data. Your format."
5. "The longer you log, the sharper it gets." → "30 days → weekly. 90 days → seasonal."

## Alt B: Emotional / Human-Forward
1. "Notice more about your days." → "A quick structured check-in. Not a diary — a data point."
2. "Your weeks have a shape." → "After 7 entries, your first behavioral pattern appears."
3. "Not everything that fluctuates matters." → "Only patterns that cross a significance threshold."
4. "See a month at a glance." → "Heatmaps, distributions, averages — all from what you recorded."
5. "Your data stays on your device." → "Local-first architecture. No cloud. No sharing. Yours."

---

# PHASE 10 — PAYWALL VARIANTS

## Variant A: Analytical Intelligence Upgrade
- **Headline**: "Your data has more to show."
- **Value**: Full 30-day analysis | Confidence scoring | Monthly reports | Full export | All dream perspectives
- **Trust**: "Cancel anytime. Entries stay regardless." | "No data leaves your phone." | 7-day trial

## Variant B: Emotional Pattern Mastery
- **Headline**: "See the patterns your entries reveal."
- **Value**: 30/90-day emotional maps | Focus area correlations | Blind spot detection | Seasonal overlays
- **Trust**: "Based entirely on what you wrote." | "Every insight references your specific entries."

## Variant C: Behavioral Optimization System
- **Headline**: "More data. Clearer patterns. Better decisions."
- **Value**: Decision-quality scoring | Baseline tracking | Multi-month comparison | Ad-free | Growth challenges
- **Trust**: "We show you what changed. You decide what to do." | "Full export at any time."

## Cross-Variant Principles
1. Free tier must feel complete — journal, check-ins, 7-day view are FREE
2. Every paywall answers: "What specific thing can I not do right now?"
3. Price anchoring: factual only (monthly, yearly, per-month equivalent)
4. "Not now" button equally prominent to CTA
5. Post-purchase: "Pro features are now active" (not "Cosmic Door Opened")
6. Risk reversal: "No data is deleted if you cancel"

---

# PHASE 11 — CATEGORY ESCAPE MANIFESTO

## InnerCycles is NOT:
1. A meditation app
2. A mood tracker
3. A therapy replacement
4. A journaling app
5. An AI chatbot
6. An astrology/horoscope app
7. A wellness content feed
8. A gamified habit app

## InnerCycles IS:
1. A personal behavioral pattern engine with Pearson correlation across 5 dimensions
2. A structured self-tracking system producing typed, rated, timestamped data
3. A cross-correlation detector (7 distinct pipelines with significance thresholds)
4. A privacy-first local data architecture (all computation on-device)
5. A longitudinal self-observation tool
6. An adaptive insight surface (progressive unlock as data accumulates)
7. A multi-modal behavioral capture layer
8. A bilingual, culturally adaptive system with safe non-predictive language

## MANIFESTO (≤120 words)

Most self-improvement apps sell you someone else's framework. Meditate like this. Journal like that. Feel better in 7 days. None of it is built on your actual data.

InnerCycles is a behavioral pattern engine. You track five life dimensions daily — structured, rated, timestamped. The system runs Pearson correlations across your sleep, mood, energy, habits, and emotional data. After 7 entries, it starts surfacing cross-dimensional patterns only your data can reveal: how your sleep quality statistically relates to next-day stress, whether gratitude practice correlates with weekly mood, which days your focus consistently drops.

No predictions. No prescriptions. No content. Just your behavioral data, computed locally, revealing patterns you could not see without longitudinal analysis.

## NEW CATEGORY NAME

**Personal Behavioral Intelligence (PBI)**

---

# PHASE 12 — PRODUCT NARRATIVE

## Problem Statement
- People lack structured visibility into their own behavioral patterns
- Emotional data scattered across isolated apps that do not talk to each other
- Existing tools capture data but do not compute cross-dimensional relationships
- Market saturated with prescriptive content but almost none personalized to actual data

## Solution Gap
| Category | Example | Gap |
|---|---|---|
| Mood trackers | Daylio | Single-axis, no correlation |
| Journaling | Day One | Unstructured text, no trends |
| Meditation | Calm | Content delivery, zero personalization |
| AI therapy | Woebot | CBT scripts, no longitudinal analysis |
| Habit trackers | Streaks | Binary logging, no impact measurement |
| Astrology | Co-Star | Birth-data narratives, not behavioral data |

**The gap**: No consumer app computes statistical correlations across multiple behavioral dimensions from longitudinal data, on-device, with progressive insight unlocking.

## 3 Tagline Options
1. **"Your data. Your patterns. Your intelligence."**
2. **"The behavioral pattern engine for people who track themselves."**
3. **"See what your own data already knows."**

## What We Do / What We Don't Do

| DO | DON'T |
|---|---|
| Compute statistical correlations from behavioral data | Diagnose or replace professional care |
| Track 5 dimensions with 15 sub-ratings | Generate generic advice |
| Run 7 cross-correlation pipelines | Send behavioral data to any server |
| Surface insights only when significant (n>=7, \|r\|>=0.3) | Make predictions or causal claims |
| Use hedged, non-predictive language | Use AI-generated therapeutic advice |
| Store all data locally | Sell or monetize personal data |
| Progressively unlock deeper analysis | Promise results in a timeframe |
| Provide structured multi-dimensional tracking | Gamify mental health with manipulative loops |

---

# PHASE 13 — VC-LEVEL STORY

## 1-Sentence Vision
InnerCycles is building the personal behavioral intelligence layer — an on-device pattern engine that computes statistical correlations across a user's emotional, cognitive, and behavioral data to surface insights no single-axis tracking app can produce.

## 3-Sentence Elevator Pitch
Every self-improvement app captures data in isolation — mood here, sleep there, habits somewhere else. InnerCycles is the first consumer app that runs Pearson correlation analysis across 5 behavioral dimensions, 7 cross-domain data pipelines, and 15 sub-ratings, all computed on-device from the user's own longitudinal data. The more consistently a user logs, the more statistically significant their personal behavioral map becomes — creating a compounding data moat that makes the product more valuable every week.

## 30-Second Investor Pitch
People spend billions on wellness apps that tell them what to do, but almost nothing on tools that show them what is actually happening in their own lives. InnerCycles is a behavioral pattern engine. Users rate five life dimensions daily — energy, focus, emotions, decisions, social — each with three sub-dimensions. We cross-correlate that data with sleep, mood, gratitude, habits, and rituals using Pearson's r. After seven entries, the system starts surfacing statistically significant patterns. All computation happens on-device. No data leaves the phone. The result is a personal behavioral intelligence model that gets more valuable with every entry and cannot be replicated without the user's own history.

## Why Now
1. Privacy backlash is structural (post-ATT, post-GDPR)
2. Wellness app fatigue at peak (users tried 3-4 apps, churned)
3. Device compute sufficient (Pearson on thousands of points in ms)
4. Single-axis tracking is a dead end (cross-correlation is the unlock)
5. Behavioral science literacy rising (users ready for data-literate tools)

## Competitive Landscape

| Category | Examples | InnerCycles Difference |
|---|---|---|
| Mood Trackers | Daylio, Pixels | 5 dimensions, 15 sub-ratings, cross-correlations |
| Meditation | Calm, Headspace | Personalized data analysis, not generic content |
| AI Therapy | Woebot, Wysa | Statistical computation, not scripted chatbot |
| Journaling | Day One, Journey | Structured rated data for quantitative analysis |
| Astrology | Co-Star | Behavioral data insights, not birth-data narratives |
| Habits | Streaks, Habitica | Measures behavioral impact across dimensions |

## Monetization

| Tier | Price | Included |
|---|---|---|
| Free | $0 | Basic journal (1 area), mood, 7-day trends, breathing, basic dreams |
| Pro Monthly | $7.99/mo | All 5 areas, full patterns, correlations, reports, export, ad-free |
| Pro Yearly | $29.99/yr | Everything Monthly, 69% savings |
| Lifetime | $79.99 | Everything, forever |

## 12-Month Roadmap

| Quarter | Focus | Target |
|---|---|---|
| Q1 | Foundation + retention | 30-day retention >25%, entry rate >40% |
| Q2 | Depth + monetization | Premium >4%, ARPU >$2.50/mo |
| Q3 | Platform + growth | Viral coefficient >0.3, DAU/MAU >35% |
| Q4 | Intelligence + scale | 100K users, $500K ARR |

## 3-Year Vision
- Y1: Category definition, 50-100K users, $300-500K ARR
- Y2: Category leadership, 300-500K users, $1.5-2.5M ARR, predictive alerts, Apple Health integration
- Y3: Platform layer, 1M+ users, $5-8M ARR, InnerCycles API, behavioral data layer for wellness stack

---

# PHASE 14 — SEMANTIC CONSISTENCY MAP

## A) FEATURE → CATEGORY → PILLAR → TERMS → TONE

| Feature | Category | Core Pillar | Approved Terms | Banned Terms | UI Tone |
|---|---|---|---|---|---|
| Dimension Journal | State Capture | Structured Self-Observation | observation, dimension, record, structured entry | diary, express, dump, vent | Functional, precise |
| Pulse Log | State Capture | Structured Self-Observation | check-in, capture, log, snapshot | mood emoji, vibes, feeling | Quick, neutral |
| Waveform View | Cycle Detection | Cycle Intelligence | wave, phase, rhythm, recurrence, cycle | mood chart, feelings graph | Analytical, calm |
| Phase Detector | Cycle Detection | Cycle Intelligence | phase, transition, expansion, contraction | good/bad period, up/down | Technical, non-judgmental |
| Cross-Dimension Radar | Signal Intelligence | Signal-to-Noise Filtering | correlation, signal, confidence, significant | AI insight, magic, hidden | Data-forward, precise |
| Pattern Loops | Signal Intelligence | Behavioral Recurrence Mapping | loop, recurrence, trigger, sequence | prediction, fortune, destiny | Observational, grounded |
| Trend Compass | Signal Intelligence | Signal-to-Noise Filtering | trend, direction, shift, change percent | forecast, predict, expect | Directional, factual |
| Guided Breathwork | Decision | (Action tool) | breathwork, regulation, grounding, protocol | zen, inner peace, calm your mind | Instructional, neutral |
| Growth Ledger | Adaptation | Pattern Archaeology | progress, baseline, trajectory, maturity | journey, transformation, level up | Measured, evidence-based |
| Streak Engine | Adaptation | Structured Self-Observation | streak, consistency, continuity, momentum | warrior, champion, hero | Factual, non-gamified |

## B) GENERIC → PREMIUM TERM MAPPING

| Generic Term | Premium Term | Allowed In |
|---|---|---|
| mood tracker | behavioral pattern engine | Never UI; ASO metadata only |
| journal | dimension journal | UI label |
| wellness | consistency index | UI label |
| self-care | structured self-observation | UI copy, not label |
| insights | signals | UI copy |
| daily check-in | pulse log | UI label |
| patterns | recurrence data | UI copy |
| feelings | observations | UI copy |
| growth journey | adaptation trajectory | Never; too clinical. Use "progress" |
| meditation | stillness session | UI label |

## C) ARCH 2.0 LAYER → ARCH 3.0 COMPONENT → UI SURFACE

| Arch 2.0 Layer | Arch 3.0 Component | UI Surface |
|---|---|---|
| STATE | Data Input Layer (Active) | Dimension Journal, Pulse Log, Sleep Imprint, Anchor Log, Dream Ledger |
| STATE | Data Input Layer (Passive) | Entry timing analytics (derived), frequency badges |
| CYCLE | Pattern Engine (Recurrence) | Waveform View, Heatmap Timeline, Monthly Pulse |
| CYCLE | Pattern Engine (Variability) | Phase Detector, Cycle Length Estimator |
| SIGNAL | Pattern Engine (Clustering) | Cross-Dimension Radar, Pattern Loops |
| SIGNAL | Behavioral Response Model (signals) | Trend Compass, Blind Spot Detector, Consistency Index |
| DECISION | Behavioral Response Model (actions) | Guided Breathwork, Prompt Engine, Challenge Sequences |
| ADAPTATION | Evolution & Maturity Index | Growth Ledger, Baseline Drift, Year Synthesis |

## CONSISTENCY VIOLATIONS TO PREVENT

| Risk | Example | Prevention |
|---|---|---|
| Astrology residue in code → UI leakage | `CosmicBackground`, `starGold`, `nebulaPurple` | Keep as code identifiers only; never surface in user-visible strings |
| Safe language regression | New feature uses "will" or "predicts" | CI/CD string scanner for banned prediction language |
| Gamification creep | Milestones use "Champion", "Warrior" | Name review against banned word list before shipping |
| Category confusion | Screenshot says "mood tracker" | Screenshot review against SAFE_METADATA_TERMS list |
| Spiritual cliché re-entry | New copy uses "journey", "sacred", "cosmic" | All UI copy reviewed against BANNED_VOCABULARY_LIST |
| Medical overclaim | Insight card says "this will reduce anxiety" | All insight templates use hedged language only |
| Tone inconsistency | Premium screen uses hype; insight card uses calm | Apply UI_COPY_RULES uniformly across all surfaces |

---

# PHASE 15 — COMPETITIVE MOAT

## Honest Scores

| Metric | Score | Assessment |
|---|---|---|
| **MOAT_STRENGTH** | **18/100** | Almost entirely switching-cost-based for existing users |
| **CLONE_DIFFICULTY** | **Low** | 10-12 weeks for 2-3 engineers to reach 80% parity |
| **TIME_TO_PARITY** | **8-12 weeks** | Full engine replicable in under 3 months |
| **3-YEAR PROJECTION** | **Declining without intervention** | Apple Health, Daylio, Calm can absorb best features |
| **FATAL WEAKNESS** | No network effects, no data moat beyond individual history, no cloud sync (data loss = churn), basic statistics, competing in multiple established categories without owning any |

## Data Moat Assessment
- Data compounds moderately (ratings-based time series)
- Personalization deepens but remains shallow (Pearson correlations, not ML)
- DATA_COMPOUNDING_CURVE: **Moderate**

## Behavioral Lock-In
- Multi-hook daily engagement (journal + mood + sleep + gratitude + habits + streak)
- Switching loses all history, patterns, dream dictionary, cycle baselines
- PERSONAL_PATTERN_DEPENDENCY_SCORE: **45/100** (real but insights not yet non-obvious enough)

## Technology Differentiation
- 5-phase emotional model + 7 cross-correlation types are differentiated
- Statistical methods are basic (Pearson, averaging, thresholds)
- TIME_TO_PARITY: **6-8 weeks** for competent team

## Capital Resilience
- CAPITAL_SHIELD_SCORE: **15/100**
- Apple Health emotional journaling in iOS 19 = existential threat
- Daylio adding correlations = direct threat
- No network effects, API moats, or regulatory barriers

## MOAT REINFORCEMENT STRATEGY

### Short-term (0-3 months)
1. **Cloud Sync with E2E Encryption** — eliminate data loss risk (biggest anti-churn fix)
2. **Lagged Correlations** — "Sleep quality drops 2 nights → Decisions score drops 2-3 days later" (non-obvious insights competitors do not have)
3. **Anomaly Detection** — "Your Focus is unusually high this week. What changed?" (makes users feel seen)

### Mid-term (3-12 months)
4. **On-Device ML** — CoreML/TensorFlow Lite for personal pattern models that improve with time and cannot transfer
5. **Emotional Intelligence Progression** — levels system where deeper analysis unlocks with data maturity
6. **Therapist Integration Mode** — read-only pattern sharing with professionals (creates external dependency)
7. **HealthKit Deep Integration** — pull sleep, HRV, activity; become analysis layer on Apple Health raw data

### Long-term (1-3 years)
8. **Personal Behavioral Blueprint** — exportable multi-year behavioral profile document
9. **Anonymous Pattern Sharing** — "72% of users with similar Energy patterns found morning rituals helped" (network effect)
10. **Category Ownership via Thought Leadership** — publish research, partner with psychology researchers, own "InnerCycles" as a concept

---

# DO/DON'T CHECKLIST

## DO

- [ ] Use hedged language: "your entries suggest", "tends to", "may"
- [ ] Reference specific data points in every insight
- [ ] Gate premium on analysis depth, not core recording
- [ ] Name features as instruments: Radar, Engine, Ledger, Detector
- [ ] Surface pattern confidence scores alongside insights
- [ ] Keep all data on-device (local-first architecture)
- [ ] Enforce minimum sample sizes before showing patterns (n>=7)
- [ ] Design paywalls around specific blocked actions, not vague promises
- [ ] Use temporal anchors: "this week", "last 30 days"
- [ ] Let users draw their own conclusions from data
- [ ] Export in standard formats (CSV, JSON, PDF)
- [ ] Maintain bilingual parity (EN, TR, DE, FR)
- [ ] Position as "Personal Behavioral Intelligence" category
- [ ] Use structured data capture (ratings + categories, not freeform only)
- [ ] Make "Not now" equally prominent on paywalls

## DON'T

- [ ] Use prediction language: "will happen", "expect to see", "forecast"
- [ ] Use spiritual/astrology terms in UI: cosmic, celestial, zodiac, destiny
- [ ] Use wellness clichés: journey, self-care, inner peace, transform
- [ ] Use medical language: diagnose, treat, heal, therapy replacement
- [ ] Use gamification language: champion, warrior, level up, quest
- [ ] Use urgency/FOMO: "Don't miss out", "Limited time", countdown timers
- [ ] Anthropomorphize: "InnerCycles thinks you should..."
- [ ] Make comparative claims: "Better than therapy", "Replaces your journal"
- [ ] Use exclamation marks in analytical copy
- [ ] Show patterns from insufficient data (<7 entries)
- [ ] Promise outcomes: "Feel better in 7 days"
- [ ] Use pre-selected premium plans without visible alternatives
- [ ] Guilt users: "You haven't journaled in 3 days" (passive-aggressive)
- [ ] Send behavioral data to any server
- [ ] Use AI hype: "AI-powered", "Smart" as prefix, "Intelligent" as adjective

---

## TERMS TO RETIRE FROM CODEBASE UI

| Current (l10n key) | Current Display | Replace With |
|---|---|---|
| `premium.cosmic_powers` | "Cosmic Powers" | "What You Unlock" |
| `premium.cosmic_door_opened` | "Cosmic Door Opened" | "Pro Features Activated" |
| `greetings.cosmic_welcome` | (internal key) | Keep key; display values already safe |
| `common.start_journey` | "Begin Cycle Mapping" | Already migrated ✓ |
| Milestone "Gratitude Guru" | | "Gratitude Streak" |
| Milestone "Week Warrior" | | "7-Day Observer" |
| Milestone "Dream Explorer" | | "Dream Logger" |
| Milestone "Challenge Champion" | | "Challenge Completer" |

---

> **INNER CYCLES — SYSTEM SPEC v1**
> 16 Phases. 6 Agents. 1 Cohesive System.
> Category: Personal Behavioral Intelligence (PBI)
> Architecture: STATE → CYCLE → SIGNAL → DECISION → ADAPTATION
> Moat Status: 18/100 — reinforcement strategy required
> Language: Hedged, data-grounded, non-predictive, non-spiritual
> Next: Execute moat reinforcement short-term (cloud sync, lagged correlations, anomaly detection)
