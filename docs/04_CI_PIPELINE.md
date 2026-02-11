# Self-Healing CI Pipeline

## Pipeline Architecture

```
Push/PR on lib/data/content/**
        │
        ▼
┌───────────────────┐
│ Stage 1: Generate │ (content generation - manual/agent)
└───────┬───────────┘
        ▼
┌───────────────────┐
│ Stage 2: Predict  │ tools/prediction_filter.dart
│ Phrase Detection   │ EXIT 1 if violations found
└───────┬───────────┘
        ▼
┌───────────────────┐
│ Stage 3: Emotion  │ tools/compliance_scanner.dart
│ Dependency Score   │ EXIT 1 if risk score > 0
└───────┬───────────┘
        ▼
┌───────────────────┐
│ Stage 4: Language │ tools/compliance_scanner.dart (mixed lang check)
│ Isolation Check    │ EXIT 1 if EN/TR mixing detected
└───────┬───────────┘
        ▼
┌───────────────────┐
│ Stage 5: Duplicate│ tools/duplicate_detector.dart
│ Detection          │ EXIT 1 if >70% Jaccard similarity
└───────┬───────────┘
        ▼
┌───────────────────┐
│ Stage 6: SEO      │ tools/content_validator.dart (structure check)
│ Structure Valid    │ EXIT 1 if required fields missing
└───────┬───────────┘
        ▼
┌───────────────────┐
│ Stage 7: UI Token │ flutter analyze
│ Validation         │ EXIT 1 if analysis errors
└───────┬───────────┘
        ▼
┌───────────────────┐
│ Stage 8: Metadata │ tools/compliance_scanner.dart (metadata mode)
│ Compliance Check   │ EXIT 1 if App Store violations
└───────┬───────────┘
        ▼
┌───────────────────┐
│ Stage 9: Cost     │ tools/cost_tracker.dart
│ Validation         │ WARN if over budget
└───────┬───────────┘
        ▼
    ALL PASS?
    ├── YES → ✅ Merge allowed
    └── NO  → 🔄 Self-heal attempt
              ├── Identify failing stage
              ├── Re-generate affected batch
              ├── Re-run validation
              └── If still failing → Block merge, alert maintainer
```

## Self-Healing Protocol

### Prediction Phrase Detected
```
1. Identify specific file and line
2. Extract surrounding context (50 chars before/after)
3. Generate replacement using safe-language regex rules:
   "will happen" → "may unfold"
   "you will"    → "you may notice"
   "destined"    → "drawn toward"
   "forecast"    → "reflection"
   "predict"     → "explore"
4. Apply fix automatically
5. Re-run prediction filter
6. If still failing: escalate to cloud LLM for rewrite
```

### Duplicate Content Detected
```
1. Identify duplicate pair
2. Keep higher-quality version (by depth score)
3. Re-generate replacement for lower-quality version
4. Use different seed prompt to ensure diversity
5. Re-run duplicate detector
```

### Compliance Failure
```
1. Categorize violation type
2. If medical/financial claim: delete and regenerate
3. If urgency language: auto-replace with safe alternative
4. If mixed language: route to localization agent
5. Re-run compliance scanner
```

## Environment Variables

```bash
# CI Configuration
FLUTTER_VERSION=3.24.0
DART_SDK_VERSION=3.5.0

# Validation Thresholds
PREDICTION_TOLERANCE=0          # Zero tolerance
COMPLIANCE_MAX_RISK_SCORE=0     # Zero tolerance
DUPLICATE_SIMILARITY_THRESHOLD=0.7
MIN_CONTENT_DEPTH_SCORE=3
MIN_INSIGHT_LENGTH=100
MIN_PROMPT_LENGTH=30
MIN_AFFIRMATION_LENGTH=20
MIN_EXERCISE_STEPS=3

# Cost Limits
COST_BUDGET_PER_CYCLE=10.00
COST_BUDGET_MONTHLY=200.00
COST_WARNING_THRESHOLD=0.80

# Agent Configuration
OLLAMA_HOST=http://localhost:11434
ANTHROPIC_API_KEY=${{ secrets.ANTHROPIC_API_KEY }}
AGENT_MAX_RETRIES=3
AGENT_TIMEOUT_SECONDS=300
```

## Validation Rule Definitions

### Rule 1: Prediction Phrase Detection
- Scope: All `.dart` files in `lib/data/content/`
- Method: Case-insensitive regex matching against 30+ blacklisted phrases
- Severity: CRITICAL (blocks merge)
- Auto-fix: Yes (regex replacement)

### Rule 2: Emotional Dependency Scoring
- Scope: All content strings
- Method: Pattern matching for manipulation phrases
- Scoring: Each match adds risk points (2-10 per type)
- Threshold: Total risk must equal 0
- Severity: CRITICAL (blocks merge)
- Auto-fix: Yes (phrase replacement)

### Rule 3: Language Isolation
- Scope: All bilingual content (EN/TR field pairs)
- Method: Character set analysis + known word detection
- Check: Turkish chars (ş,ğ,ı,ö,ü,ç) in EN fields = violation
- Check: Common English words in TR-only fields = warning
- Severity: HIGH (blocks merge)
- Auto-fix: Route to localization agent

### Rule 4: Duplicate Detection
- Scope: All content within same type (card vs card, prompt vs prompt)
- Method: Trigram Jaccard similarity
- Threshold: 70% similarity = duplicate
- Severity: MEDIUM (blocks merge, offers auto-fix)
- Auto-fix: Regenerate lower-quality duplicate

### Rule 5: Content Structure Validation
- Scope: All content data classes
- Method: Field presence and length checks
- Requirements: All fields non-empty, meet minimums
- Severity: HIGH (blocks merge)
- Auto-fix: No (structural issues need human review)

### Rule 6: Cost Validation
- Scope: Token usage logs
- Method: Budget comparison
- Threshold: Monthly budget cap
- Severity: WARNING (does not block, alerts maintainer)
- Auto-fix: No (budget decisions need human approval)
