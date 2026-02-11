# Token Economy & Cost Optimization Model

## Cost Structure

### Model Pricing (per 1M tokens)
| Model | Input | Output | Local? |
|-------|-------|--------|--------|
| claude-opus-4-6 | $15.00 | $75.00 | No |
| claude-sonnet-4-5 | $3.00 | $15.00 | No |
| claude-haiku-4-5 | $0.25 | $1.25 | No |
| ollama/llama3.1:8b | $0.00 | $0.00 | Yes |
| ollama/mistral:7b | $0.00 | $0.00 | Yes |

### Hybrid Cost Split Target
| Tier | Volume Share | Cost Share |
|------|-------------|-----------|
| Local (Ollama) | 75% of tasks | $0 (hardware only) |
| Cloud Fast (Haiku) | 15% of tasks | ~20% of spend |
| Cloud Deep (Sonnet) | 10% of tasks | ~80% of spend |

---

## Budget Limits

| Scope | Limit | Auto-Stop |
|-------|-------|-----------|
| Per agent per run | $2.00 | Yes |
| Per generation cycle | $10.00 | Yes |
| Per week | $50.00 | Warning at 80% |
| Per month | $200.00 | Hard stop |

---

## Token Usage Estimates Per Content Type

### Content Generation (one-time seed)
| Content Type | Items | Avg Tokens/Item | Model | Est. Cost |
|-------------|-------|-----------------|-------|-----------|
| Archetype profiles | 17 | 800 in + 600 out | Sonnet | $0.20 |
| Insight cards | 120 | 400 in + 300 out | Mixed | $0.80 |
| Reflection prompts | 60 | 300 in + 200 out | Sonnet | $0.25 |
| Affirmations | 100 | 200 in + 150 out | Local | $0.00 |
| Exercises | 50 | 500 in + 400 out | Sonnet | $0.35 |
| SEO clusters | 200 | 300 in + 200 out | Local | $0.00 |
| **Subtotal** | **547** | | | **$1.60** |

### Validation (per cycle)
| Check | Items | Tokens/Item | Model | Est. Cost |
|-------|-------|-------------|-------|-----------|
| Compliance scan | 547 | 200 in + 50 out | Haiku | $0.06 |
| Prediction filter | 547 | 100 in + 20 out | Local | $0.00 |
| Duplicate detect | 547 | 50 in + 10 out | Local | $0.00 |
| **Subtotal** | | | | **$0.06** |

### Localization (EN → TR)
| Content Type | Items | Tokens/Item | Model | Est. Cost |
|-------------|-------|-------------|-------|-----------|
| All content TR adapt | 547 | 500 in + 400 out | Sonnet | $1.85 |
| **Subtotal** | | | | **$1.85** |

### Total Seed Generation Cost
| Phase | Cost |
|-------|------|
| Content generation | $1.60 |
| Validation | $0.06 |
| Localization | $1.85 |
| Retries (15% buffer) | $0.53 |
| **Grand Total** | **$4.04** |

---

## Monthly Projection (Ongoing Content)

### Maintenance Mode (post-seed)
| Activity | Frequency | Monthly Cost |
|----------|-----------|-------------|
| New weekly insights (4/week) | 16/month | $0.30 |
| New affirmations (10/month) | 10/month | $0.05 |
| Compliance re-validation | 4x/month | $0.24 |
| TR localization updates | As needed | $0.40 |
| **Monthly Total** | | **$0.99** |

### Growth Mode (1000x scaling)
| Activity | Volume | Monthly Cost |
|----------|--------|-------------|
| Bulk content batches | 500 items | $8.00 |
| Validation cycles | 10x/month | $0.60 |
| TR localization | 500 items | $9.25 |
| Quality refinement | 50 items | $1.50 |
| **Monthly Total** | | **$19.35** |

---

## Cost Log Schema

```json
{
  "cost_log": [
    {
      "timestamp": "2026-02-11T14:30:00Z",
      "cycle_id": "cycle_001",
      "agent_name": "insight_expansion",
      "model": "claude-sonnet-4-5",
      "task_id": "task_042",
      "tokens_input": 450,
      "tokens_output": 320,
      "cost_usd": 0.006,
      "cumulative_cycle_cost": 1.23,
      "cumulative_monthly_cost": 4.56,
      "budget_remaining_cycle": 8.77,
      "budget_remaining_monthly": 195.44
    }
  ]
}
```

## Budget Guardrail Rules

```
Rule 1: Agent Budget
  IF agent_cycle_cost > $2.00
  THEN pause agent, log warning, continue other agents

Rule 2: Cycle Budget
  IF cycle_total_cost > $10.00
  THEN stop all cloud agents, switch to local-only mode

Rule 3: Weekly Budget
  IF weekly_cost > $40.00 (80% of $50)
  THEN send warning, reduce cloud batch sizes by 50%

Rule 4: Monthly Budget
  IF monthly_cost > $160.00 (80% of $200)
  THEN send critical warning, local-only for rest of month

Rule 5: Monthly Hard Stop
  IF monthly_cost >= $200.00
  THEN stop ALL cloud API calls, local-only until next month
```

## Hardware Cost (Local LLM)

| Component | Spec | One-Time Cost |
|-----------|------|--------------|
| Mac (existing) | M-series, 16GB+ RAM | $0 (already owned) |
| Ollama | Free, open source | $0 |
| llama3.1:8b | ~4.7GB model | $0 |
| mistral:7b | ~4.1GB model | $0 |
| **Total Hardware** | | **$0** |

### Local Performance Estimates
| Model | Tokens/sec (M1 Pro) | Tokens/sec (M2 Max) |
|-------|--------------------|--------------------|
| llama3.1:8b | ~25 tok/s | ~40 tok/s |
| mistral:7b | ~30 tok/s | ~45 tok/s |

### Break-Even Analysis
- Cloud-only seed generation: ~$15-20
- Hybrid (75% local): ~$4-5
- **Savings: 70-75% per generation cycle**
