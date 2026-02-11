# Hybrid AI Architecture — Local + Cloud Orchestration

## Overview

InnerCycles uses a hybrid Local LLM (Ollama) + Cloud LLM (Claude API) architecture for content generation, validation, and refinement. Local handles 75% of volume; Cloud handles 25% of quality-critical tasks.

---

## Architecture Diagram

```
                    ┌─────────────────────┐
                    │   Orchestrator       │
                    │   (tmux session)     │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
     ┌────────▼──────┐  ┌─────▼──────┐  ┌──────▼───────┐
     │  LOCAL TIER    │  │ CLOUD TIER │  │  VALIDATION  │
     │  (Ollama)      │  │ (Claude)   │  │  TIER        │
     │                │  │            │  │              │
     │ • Knowledge    │  │ • Insight  │  │ • Compliance │
     │   Architect    │  │   Expansion│  │ • Duplicate  │
     │ • Micro Content│  │ • Locale   │  │ • Prediction │
     │ • SEO Builder  │  │ • Metadata │  │ • Quality    │
     │ • Draft Gen    │  │ • Tone Fix │  │ • Language   │
     └───────┬────────┘  └─────┬──────┘  └──────┬───────┘
             │                 │                 │
             └────────────────┬┘─────────────────┘
                              │
                    ┌─────────▼─────────┐
                    │   Merge Pipeline   │
                    │   + Final Report   │
                    └───────────────────┘
```

## Routing Logic

### Local LLM Tasks (Ollama — llama3.1/mistral)
| Task | Model | Reason |
|------|-------|--------|
| Bulk content structure | llama3.1:8b | High volume, low cost |
| SEO cluster generation | llama3.1:8b | Repetitive pattern work |
| Micro content cards | mistral:7b | Short-form generation |
| Draft affirmations | llama3.1:8b | Template-based |
| Keyword expansion | mistral:7b | Simple extraction |
| First-pass translation | llama3.1:8b | Bulk TR drafts |

### Cloud LLM Tasks (Claude API)
| Task | Model | Reason |
|------|-------|--------|
| Deep insight writing | claude-sonnet-4-5 | Nuance required |
| Compliance validation | claude-haiku-4-5 | Fast, accurate |
| Cultural adaptation | claude-sonnet-4-5 | Cultural sensitivity |
| Tone correction | claude-haiku-4-5 | Pattern matching |
| Final refinement | claude-sonnet-4-5 | Quality gate |
| Subscription copy | claude-sonnet-4-5 | Conversion critical |
| App Store metadata | claude-sonnet-4-5 | Compliance critical |

## Priority System

```
Priority 1 (CRITICAL): Compliance validation — always cloud
Priority 2 (HIGH):     Deep content — cloud for final, local for draft
Priority 3 (MEDIUM):   Micro content — local first, cloud if quality < threshold
Priority 4 (LOW):      SEO clusters — always local
```

## Escalation Triggers

Content escalates from Local → Cloud when:
1. **Quality score < 6/10** — Local draft insufficient
2. **Compliance failure** — Predictive language detected in local output
3. **Cultural sensitivity flag** — TR content needs nuanced adaptation
4. **Similarity > 60%** — Local output too similar to existing content
5. **Manual override** — Operator flags for cloud refinement

## Load Balancing

```yaml
# Concurrent agent limits
local_max_concurrent: 4    # Limited by GPU/CPU
cloud_max_concurrent: 3    # Limited by API rate limits
validation_max_concurrent: 2

# Queue management
queue_strategy: priority_weighted
overflow_action: delay_and_retry
max_queue_depth: 100
stale_task_timeout: 600s
```

## Failure Recovery

```
Agent Failure:
  1. Log failure details + context
  2. Retry with same model (max 3x, exponential backoff)
  3. If still failing: escalate to alternative model
     - Local fail → Cloud fallback
     - Cloud fail → Different cloud model
  4. If all retries exhausted: skip task, log for manual review
  5. Never block pipeline for single task failure

Pipeline Failure:
  1. Checkpoint state after each successful batch
  2. Resume from last checkpoint on restart
  3. Partial results are preserved (never discard good output)
  4. Alert operator if >20% tasks failing
```

## Data Flow

```
1. Orchestrator reads task queue
2. Routes task to appropriate agent (local/cloud)
3. Agent generates output → raw content file
4. Validation tier runs all 5 checks
5. If PASS: content enters merge pipeline
6. If FAIL: content re-routed for correction
   - Minor issues: auto-fix with regex/rules
   - Major issues: re-generate with cloud
7. Merge pipeline combines all passing content
8. Final report generated
9. Content committed to repository (if all gates pass)
```

## Model Configuration

### Ollama Setup
```bash
# Required models
ollama pull llama3.1:8b
ollama pull mistral:7b

# Performance tuning
OLLAMA_NUM_PARALLEL=4
OLLAMA_MAX_LOADED_MODELS=2
OLLAMA_FLASH_ATTENTION=1

# Context window
OLLAMA_NUM_CTX=4096  # Sufficient for content generation
```

### Claude API Setup
```bash
# Environment variables
ANTHROPIC_API_KEY=<key>
CLAUDE_MODEL_DEEP=claude-sonnet-4-5-20250929
CLAUDE_MODEL_FAST=claude-haiku-4-5-20251001
CLAUDE_MAX_TOKENS=4096
CLAUDE_TEMPERATURE=0.7  # Balanced creativity/consistency
```
