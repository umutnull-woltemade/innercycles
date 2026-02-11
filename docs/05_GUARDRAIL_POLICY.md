# Content Guardrail Policy

## Purpose

This policy defines the automated safety rails that protect InnerCycles content from Apple guideline violations, emotional manipulation, and quality degradation. Every content piece must pass all 5 validation layers before entering the app.

---

## Layer 1: Prediction Phrase Blacklist

### Blacklisted Phrases (30 entries)
| # | Phrase | Category |
|---|--------|----------|
| 1 | will happen | prediction |
| 2 | will be | prediction |
| 3 | you will | prediction |
| 4 | going to | prediction |
| 5 | destined | determinism |
| 6 | fated | determinism |
| 7 | guaranteed | guarantee |
| 8 | promise | guarantee |
| 9 | certain to | guarantee |
| 10 | definitely will | prediction |
| 11 | forecast | prediction |
| 12 | prediction | prediction |
| 13 | predict | prediction |
| 14 | fortune | prediction |
| 15 | your future | prediction |
| 16 | what awaits | prediction |
| 17 | meant to be | determinism |
| 18 | written in the stars | determinism |
| 19 | cosmic plan for you | determinism |
| 20 | the stars say | prediction |
| 21 | the planets indicate | prediction |
| 22 | your horoscope says | prediction |
| 23 | love forecast | prediction |
| 24 | money forecast | prediction |
| 25 | career forecast | prediction |
| 26 | you are going to | prediction |
| 27 | this will bring | prediction |
| 28 | expect to see | prediction |
| 29 | you should expect | prediction |
| 30 | according to your chart | prediction |

### Auto-Replacement Map
| Banned | Safe Replacement |
|--------|-----------------|
| will happen | may unfold |
| you will | you may notice |
| destined | naturally drawn |
| forecast | reflection |
| predict | explore |
| your future | your journey |
| the stars say | this archetype suggests |
| guaranteed | often experienced as |

### Enforcement
- Tool: `tools/prediction_filter.dart`
- Trigger: Every push/PR touching content files
- Action: EXIT 1 on any match
- Report: `tools/reports/prediction_filter_report.txt`

---

## Layer 2: Emotional Dependency Scoring

### Manipulation Pattern Detection
| Pattern | Risk Points | Category |
|---------|-------------|----------|
| you need this | 10 | dependency |
| without this you | 10 | dependency |
| don't miss | 8 | urgency |
| limited time | 8 | urgency |
| act now | 8 | urgency |
| only chance | 8 | urgency |
| last opportunity | 8 | urgency |
| fear of missing | 6 | FOMO |
| you must | 6 | pressure |
| don't wait | 6 | urgency |
| running out | 6 | scarcity |
| exclusive access | 4 | scarcity |
| others are | 4 | social pressure |
| falling behind | 4 | guilt |

### Threshold
- Total risk score must equal **0** (zero tolerance)
- Any single match blocks the pipeline

### Enforcement
- Tool: `tools/compliance_scanner.dart`
- Trigger: Every push/PR
- Action: EXIT 1 if risk > 0

---

## Layer 3: Duplication Similarity Threshold

### Method
1. Normalize text: lowercase, strip punctuation, trim whitespace
2. Tokenize into word-level trigrams
3. Compute Jaccard similarity coefficient between all pairs
4. Also check for exact substring matches (>20 consecutive words)

### Threshold
- **70% Jaccard similarity** = flagged as duplicate
- **90% similarity** = near-identical, auto-remove lower quality
- **Exact match >20 words** = definite duplicate

### Enforcement
- Tool: `tools/duplicate_detector.dart`
- Scope: Within same content type (insight vs insight, not insight vs affirmation)
- Report: Lists all pairs above threshold with similarity scores

---

## Layer 4: Minimum Depth Score

### Depth Scoring Algorithm
```
depth_score = (
  word_count_score +        # >50 words = 2pts, >100 = 3pts, >200 = 4pts
  specificity_score +       # Contains specific nouns/verbs = 2pts
  uniqueness_score +        # Low similarity to other content = 2pts
  actionability_score +     # Contains action verb = 1pt
  reflection_score          # Contains question mark = 1pt
) / 10

Minimum required: 3/10
```

### Content Type Minimums
| Type | Min Words | Min Depth | Max Words |
|------|-----------|-----------|-----------|
| Insight Card Body | 30 | 3/10 | 200 |
| Reflection Prompt | 10 | 2/10 | 100 |
| Affirmation | 8 | 2/10 | 50 |
| Exercise Intro | 20 | 3/10 | 150 |
| Exercise Step | 10 | 2/10 | 80 |
| Archetype Description | 40 | 4/10 | 300 |

### Enforcement
- Tool: `tools/content_validator.dart`
- Action: EXIT 1 if any content below minimum

---

## Layer 5: Apple Guideline Risk Scoring

### Risk Categories
| Category | Points | Example |
|----------|--------|---------|
| Medical claim | 10 | "cures anxiety", "treats depression" |
| Financial claim | 10 | "make money", "financial success guaranteed" |
| Predictive framing | 8 | "will happen", "your future holds" |
| Deterministic language | 8 | "destined", "fated to" |
| Urgency manipulation | 6 | "limited time", "act now" |
| Emotional dependency | 6 | "you need this", "can't live without" |
| Outcome guarantee | 6 | "guaranteed results", "proven" |
| Mixed language | 4 | Turkish in EN field or vice versa |
| Minor tone issue | 2 | Slightly assertive language |

### Aggregate Score
- **0 points**: SAFE — content approved
- **1-4 points**: WARNING — review recommended
- **5-9 points**: RISKY — must fix before merge
- **10+ points**: BLOCKED — auto-rejected

### Enforcement
- Total score across all content in batch must equal 0
- Individual piece score must equal 0
- Report includes: file, line, phrase, category, points, suggested fix

---

## Batch Compliance Report Format

```
═══════════════════════════════════════════════════
INNERCYCLES CONTENT COMPLIANCE REPORT
Generated: 2026-02-11T14:30:00Z
═══════════════════════════════════════════════════

SUMMARY
  Total items scanned:    150
  Passed all layers:      148
  Failed:                 2
  Overall risk score:     0 (after fixes)

LAYER 1 — Prediction Filter
  Status: PASS
  Violations: 0

LAYER 2 — Emotional Dependency
  Status: PASS
  Risk score: 0

LAYER 3 — Duplicate Detection
  Status: PASS
  Max similarity: 0.42 (below 0.70 threshold)

LAYER 4 — Depth Score
  Status: PASS
  Average depth: 6.8/10
  Minimum depth: 3.2/10

LAYER 5 — Apple Risk Score
  Status: PASS
  Total risk: 0

VERDICT: ✅ APPROVED FOR MERGE
═══════════════════════════════════════════════════
```
