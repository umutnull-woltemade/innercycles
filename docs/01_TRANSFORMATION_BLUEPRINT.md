# InnerCycles Transformation Blueprint

## Executive Summary

InnerCycles is repositioned from an astrology prediction app to a reflective insight platform powered by archetypal psychology, journaling science, and self-awareness frameworks. This document defines the complete transformation across product, content, technology, monetization, and growth.

---

## 1. Product Identity

| Attribute | Before (Astrobobo) | After (InnerCycles) |
|-----------|-------------------|---------------------|
| Core promise | "Know your future" | "Understand yourself" |
| Tone | Predictive, deterministic | Reflective, educational |
| Content model | Zodiac-based forecasts | Archetype-based insights |
| User relationship | Dependency (check daily) | Empowerment (grow daily) |
| Apple safety | 4.3(b) violation risk | Fully compliant |

## 2. Core Value Proposition

**EN:** "InnerCycles is your personal reflection companion. Explore archetypal patterns, track your inner cycles, and discover insights that help you understand yourself more deeply."

**TR:** "InnerCycles kisisel yansimanizin yol arkadasidir. Arketipsel kaliplari kesfedin, ic dongulerinizi takip edin ve kendinizi daha derinden anlamaniza yardimci olan icgoruleri kesfet."

## 3. Feature Architecture

### Tier 1 — Core (Free)
- Daily Journal (5 focus areas, sub-ratings, notes)
- Pattern Engine (trends after 7 entries)
- Monthly Reflection
- Archive with search/filter
- 3 free archetype profiles
- 20 daily insight cards (rotating)
- Dream Journal (existing)

### Tier 2 — Extended (Premium)
- All 17 archetype profiles with deep content
- 120+ insight cards (full library)
- 100 guided affirmations
- 50 journaling exercises
- 60 reflection prompt library
- Advanced pattern correlations
- Monthly archetype report
- Export journal data

### Tier 3 — Programs (Premium+)
- 7-day self-discovery program
- 21-day mindfulness journey
- 30-day journaling challenge
- Seasonal reflection guides
- Custom archetype deep-dives

## 4. Safety Architecture

### Banned Phrases (enforced by CI)
```
will happen, will be, you will, going to, destined, fated,
guaranteed, promise, certain to, definitely will, forecast,
prediction, predict, fortune, your future, what awaits,
meant to be, written in the stars, cosmic plan for you,
the stars say, the planets indicate, your horoscope says
```

### Required Language Patterns
```
you may notice, consider exploring, past patterns suggest,
this archetype invites, reflect on, you might find,
some people experience, this can be an opportunity,
explore the possibility, what resonates with you
```

### Emotional Safety
- No urgency triggers ("act now", "limited time")
- No dependency patterns ("you need this", "without this")
- No guilt manipulation ("don't miss", "you're falling behind")
- No outcome guarantees ("guaranteed", "proven results")

## 5. Technology Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.24+ / Dart |
| State | Riverpod |
| Navigation | GoRouter |
| Persistence | SharedPreferences + Hive |
| Animation | flutter_animate |
| UI System | Liquid Glass Cosmic |
| Content | Static Dart content files |
| CI | GitHub Actions |
| Validation | Custom Dart tools |
| Content Gen | Ollama (local) + Claude (cloud) |

## 6. Content Architecture

```
Archetype System
├── Planetary (10): Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto
├── Elemental (4): Fire, Earth, Air, Water
└── Modal (3): Cardinal, Fixed, Mutable

Per Archetype Node:
├── Profile (description, themes, strengths, growth areas)
├── Insight Cards (12 per planetary archetype)
├── Reflection Prompts (6 per archetype)
├── Journaling Exercises (5 per archetype)
└── Affirmations (mapped by theme)

Content Totals:
├── 17 archetype profiles
├── 120 insight cards
├── 60 reflection prompts
├── 50 journaling exercises
├── 100 affirmations
├── 200+ SEO content clusters
└── Expandable to 10,000+ via agent pipeline
```

## 7. Quality Gates

Every content piece must pass:

1. **Prediction Filter** — zero tolerance for deterministic language
2. **Compliance Scanner** — Apple 4.3(b), no medical/financial claims
3. **Content Validator** — minimum depth, length, structure requirements
4. **Duplicate Detector** — <70% Jaccard similarity threshold
5. **Language Isolation** — strict EN/TR separation

## 8. Success Metrics

| Metric | Target (30 day) | Target (90 day) |
|--------|-----------------|-----------------|
| DAU | 500 | 3,000 |
| 7-day retention | 35% | 45% |
| 30-day retention | 15% | 25% |
| Journal entries/user/week | 3 | 5 |
| Premium conversion | 3% | 6% |
| App Store rating | 4.5+ | 4.7+ |
| Crash rate | <0.5% | <0.1% |
| App Store review pass | First attempt | Maintained |
