# TMUX Multi-Agent Orchestration Model

## Session Layout

```
┌─────────────────────────────────────────────────┐
│ tmux session: innercycles-agents                │
├────────┬────────┬────────┬────────┬─────────────┤
│ Win 0  │ Win 1  │ Win 2  │ Win 3  │ Win 4       │
│ Orch.  │ Know.  │ Insight│ Micro  │ Compliance  │
├────────┼────────┼────────┼────────┼─────────────┤
│ Win 5  │ Win 6  │ Win 7  │        │             │
│ SEO    │ Locale │ Cost   │        │             │
└────────┴────────┴────────┴────────┴─────────────┘
```

## Window Definitions

### Window 0: Orchestrator
- Role: Monitor all agents, trigger cross-validation, run merge pipeline
- Script: `tools/agents/orchestrator.sh`
- Runs continuously until all agents complete
- Outputs: `tools/reports/orchestration_summary.txt`

### Window 1: Knowledge Architect (Local)
- Model: ollama/llama3.1:8b
- Role: Build hierarchical topic trees, content structure maps
- Input: Archetype system definition
- Output: Structured content outlines per archetype node
- Batch size: 10 topics per batch
- Expected runtime: 15-30 minutes per batch
- Log: `tools/logs/knowledge.log`

### Window 2: Insight Expansion (Cloud)
- Model: claude-sonnet-4-5
- Role: Generate deep, nuanced insight content
- Input: Content outlines from Knowledge Architect
- Output: Full insight cards, reflection prompts
- Batch size: 5 insights per batch
- Expected runtime: 2-5 minutes per batch
- Log: `tools/logs/insight.log`

### Window 3: Micro Content (Local)
- Model: ollama/mistral:7b
- Role: Generate short-form cards, affirmations, quick prompts
- Input: Theme lists and archetype profiles
- Output: Affirmation cards, micro-insights, daily tips
- Batch size: 20 items per batch
- Expected runtime: 5-10 minutes per batch
- Log: `tools/logs/micro.log`

### Window 4: Compliance Filter (Cloud)
- Model: claude-haiku-4-5
- Role: Validate all generated content against Apple guidelines
- Input: Content batches from all generators
- Output: Pass/fail reports with specific violations
- Batch size: 50 items per batch
- Expected runtime: 1-2 minutes per batch
- Log: `tools/logs/compliance.log`

### Window 5: SEO Builder (Local)
- Model: ollama/llama3.1:8b
- Role: Generate SEO clusters, keyword matrices, internal linking maps
- Input: Topic tree from Knowledge Architect
- Output: SEO cluster definitions with keywords and linking structure
- Batch size: 10 clusters per batch
- Expected runtime: 10-20 minutes per batch
- Log: `tools/logs/seo.log`

### Window 6: Localization (Cloud)
- Model: claude-sonnet-4-5
- Role: Cultural adaptation of EN content to TR
- Input: Finalized EN content
- Output: Culturally adapted TR content (not literal translation)
- Batch size: 10 items per batch
- Expected runtime: 3-5 minutes per batch
- Log: `tools/logs/localization.log`

### Window 7: Cost Monitor
- Script: `watch -n 30 dart run tools/cost_tracker.dart`
- Role: Real-time cost tracking across all cloud API calls
- Auto-alerts if budget threshold reached (80% warning, 100% stop)
- Log: `tools/logs/cost.log`

## Execution Timeline

```
Phase 1: Structure (Minutes 0-30)
  ├── Knowledge Architect builds topic tree
  └── SEO Builder starts cluster generation

Phase 2: Content Generation (Minutes 30-120)
  ├── Insight Expansion writes deep content (from topic tree)
  ├── Micro Content generates cards/affirmations
  └── Compliance Filter validates in real-time

Phase 3: Localization (Minutes 120-180)
  ├── Localization agent adapts all EN→TR
  └── Compliance Filter re-validates TR content

Phase 4: Merge + Validation (Minutes 180-210)
  ├── Cross-agent validation check
  ├── Duplicate detection across all content
  ├── Final compliance sweep
  └── Merge pipeline produces final output

Phase 5: Report (Minutes 210-220)
  ├── Generate quality report
  ├── Generate cost report
  ├── Generate compliance certificate
  └── Commit to repository (if all gates pass)
```

## Inter-Agent Dependencies

```
Knowledge Architect ──→ Insight Expansion (needs topic tree)
Knowledge Architect ──→ Micro Content (needs theme lists)
Knowledge Architect ──→ SEO Builder (needs topic hierarchy)
Insight Expansion ────→ Localization (needs EN content)
Micro Content ────────→ Localization (needs EN content)
All Generators ───────→ Compliance Filter (needs content to validate)
All Agents ───────────→ Cost Monitor (tracks all API calls)
```

## Commands Reference

```bash
# Start full orchestration
tools/agents/orchestrator.sh

# Attach to tmux session
tmux attach -t innercycles-agents

# Switch between windows
Ctrl-b 0  # Orchestrator
Ctrl-b 1  # Knowledge
Ctrl-b 2  # Insight
...

# Check all agent status
tools/agents/status.sh

# Stop all agents
tools/agents/stop_all.sh

# View specific agent log
tail -f tools/logs/insight.log

# Run single validation pass
dart run tools/compliance_scanner.dart
dart run tools/prediction_filter.dart
dart run tools/content_validator.dart
dart run tools/duplicate_detector.dart
```

## Retry Policy

| Scenario | Action | Max Retries | Backoff |
|----------|--------|-------------|---------|
| Local model timeout | Retry same task | 3 | 5s, 10s, 20s |
| Cloud API rate limit | Wait and retry | 5 | 30s, 60s, 120s |
| Quality score < 6 | Escalate to cloud | 1 | Immediate |
| Compliance failure | Re-generate with stricter prompt | 2 | 5s |
| Duplicate detected | Re-generate with different seed | 2 | 5s |
| Budget exceeded | Stop cloud agents, local-only mode | 0 | N/A |

## Logging Format

```
[TIMESTAMP] [AGENT_NAME] [LEVEL] [TASK_ID] Message
[2026-02-11T14:30:00] [insight] [INFO] [task_042] Generating insight card for Sun archetype
[2026-02-11T14:30:05] [insight] [SUCCESS] [task_042] Card generated, quality=8.2, tokens=450
[2026-02-11T14:30:06] [compliance] [INFO] [task_042] Validating card... PASS
[2026-02-11T14:30:10] [cost] [INFO] [cycle_001] Running total: $1.23 / $10.00 budget
```
