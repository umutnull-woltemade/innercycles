#!/usr/bin/env bash
# =============================================================
# INNERCYCLES CONTENT DOMINATION TMUX ORCHESTRATION SYSTEM
# =============================================================
# 13-Agent Autonomous Content Pipeline
# Usage: bash scripts/tmux/start-agents.sh
# Stop:  bash scripts/tmux/stop-agents.sh
# =============================================================

set -euo pipefail

SESSION="content_domination"
PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LOG_DIR="$PROJECT_DIR/logs/agents"
OUTPUT_DIR="$PROJECT_DIR/outputs"
RETRY_DIR="$PROJECT_DIR/logs/retries"
HEALTH_DIR="$PROJECT_DIR/logs/health"

mkdir -p "$LOG_DIR" "$OUTPUT_DIR" "$RETRY_DIR" "$HEALTH_DIR"

# Kill existing session if running
tmux kill-session -t "$SESSION" 2>/dev/null || true

echo "==========================================="
echo "  INNERCYCLES CONTENT DOMINATION SYSTEM"
echo "==========================================="
echo "Project:  $PROJECT_DIR"
echo "Logs:     $LOG_DIR"
echo "Outputs:  $OUTPUT_DIR"
echo "Session:  $SESSION"
echo ""

# ─── PANE 1: ORCHESTRATOR ──────────────────────────────────
tmux new-session -d -s "$SESSION" -n "orchestrator" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:orchestrator" \
  "echo '[$SESSION] ORCHESTRATOR ONLINE' && \
   echo 'Agents: 13 | Self-healing: ON | Retry limit: 2' && \
   echo 'Monitoring health at: $HEALTH_DIR' && \
   echo '---' && \
   while true; do \
     sleep 30; \
     FAILED=\$(find $HEALTH_DIR -name '*.failed' -mmin -5 2>/dev/null | wc -l | tr -d ' '); \
     RUNNING=\$(find $HEALTH_DIR -name '*.running' -mmin -5 2>/dev/null | wc -l | tr -d ' '); \
     echo \"[HEARTBEAT] \$(date '+%H:%M:%S') | Running: \$RUNNING | Failed: \$FAILED\"; \
     if [ \"\$FAILED\" -gt 0 ]; then \
       echo '[ALERT] Failed agents detected - check $HEALTH_DIR/*.failed'; \
     fi; \
   done 2>&1 | tee $LOG_DIR/orchestrator.log" C-m

# ─── PANE 2: COMPETITOR INTELLIGENCE ───────────────────────
tmux new-window -t "$SESSION" -n "competitor" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:competitor" \
  "echo '[COMPETITOR_INTEL] Ready.' && \
   echo 'Output: $OUTPUT_DIR/competitor.md' && \
   echo 'Monitors: Co-Star, The Pattern, CHANI, Moonly, Sanctuary, Soulloop, Rosebud, Mindsera' && \
   touch $HEALTH_DIR/competitor.running \
   2>&1 | tee $LOG_DIR/competitor.log" C-m

# ─── PANE 3: TOOL GAP ANALYSIS ────────────────────────────
tmux new-window -t "$SESSION" -n "tool_gap" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:tool_gap" \
  "echo '[TOOL_GAP] Ready.' && \
   echo 'Output: $OUTPUT_DIR/tool_gap.md' && \
   echo 'Scans competitor features vs InnerCycles capabilities' && \
   touch $HEALTH_DIR/tool_gap.running \
   2>&1 | tee $LOG_DIR/tool_gap.log" C-m

# ─── PANE 4: CONTENT ARCHITECT ─────────────────────────────
tmux new-window -t "$SESSION" -n "content_architect" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:content_architect" \
  "echo '[CONTENT_ARCHITECT] Ready.' && \
   echo 'Output: $OUTPUT_DIR/content_architecture.md' && \
   echo 'Engine: [Pattern] + [Time] + [Archetype] + [Growth] + [Prompt] + [Habit]' && \
   touch $HEALTH_DIR/content_architect.running \
   2>&1 | tee $LOG_DIR/content_architect.log" C-m

# ─── PANE 5: MULTI-LANGUAGE ───────────────────────────────
tmux new-window -t "$SESSION" -n "multilang" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:multilang" \
  "echo '[MULTI_LANGUAGE] Ready.' && \
   echo 'Output: $OUTPUT_DIR/multilang.md' && \
   echo 'Languages: EN | TR | DE | FR | ES' && \
   touch $HEALTH_DIR/multilang.running \
   2>&1 | tee $LOG_DIR/multilang.log" C-m

# ─── PANE 6: CONTENT GENERATION ───────────────────────────
tmux new-window -t "$SESSION" -n "content_gen" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:content_gen" \
  "echo '[CONTENT_GEN] Ready.' && \
   echo 'Output: $OUTPUT_DIR/content_generated.md' && \
   echo 'Batch: node scripts/content-gen/batch-generate.mjs' && \
   echo 'Types: insights, deep-dives, archetypes, seasonal, dreams, rituals, education' && \
   touch $HEALTH_DIR/content_gen.running \
   2>&1 | tee $LOG_DIR/content_gen.log" C-m

# ─── PANE 7: SEO OPTIMIZATION ─────────────────────────────
tmux new-window -t "$SESSION" -n "seo" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:seo" \
  "echo '[SEO] Ready.' && \
   echo 'Output: $OUTPUT_DIR/seo.md' && \
   echo 'Tasks: keywords, titles, meta, sitemap, linking, schema' && \
   echo 'Sitemap: node scripts/seo/generate-sitemap.mjs' && \
   touch $HEALTH_DIR/seo.running \
   2>&1 | tee $LOG_DIR/seo.log" C-m

# ─── PANE 8: QA VALIDATION ────────────────────────────────
tmux new-window -t "$SESSION" -n "qa" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:qa" \
  "echo '[QA_VALIDATION] Ready.' && \
   echo 'Output: $OUTPUT_DIR/qa_validation.md' && \
   echo 'Checks: compliance, duplication, depth, Barnum, language, tone' && \
   echo 'Scripts: node scripts/validation/compliance-check.mjs' && \
   echo '         node scripts/validation/duplicate-detector.mjs' && \
   echo '         node scripts/validation/content-filter.mjs' && \
   touch $HEALTH_DIR/qa.running \
   2>&1 | tee $LOG_DIR/qa.log" C-m

# ─── PANE 9: ANALYTICS ────────────────────────────────────
tmux new-window -t "$SESSION" -n "analytics" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:analytics" \
  "echo '[ANALYTICS] Ready.' && \
   echo 'Output: $OUTPUT_DIR/analytics.md' && \
   echo 'KPIs: CTR, Retention, Session Time, Conversion, Engagement' && \
   touch $HEALTH_DIR/analytics.running \
   2>&1 | tee $LOG_DIR/analytics.log" C-m

# ─── PANE 10: REVISION ────────────────────────────────────
tmux new-window -t "$SESSION" -n "revision" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:revision" \
  "echo '[REVISION] Ready.' && \
   echo 'Output: $OUTPUT_DIR/revisions.md' && \
   echo 'Monitors: low-CTR content, stale SEO, repetition buildup' && \
   touch $HEALTH_DIR/revision.running \
   2>&1 | tee $LOG_DIR/revision.log" C-m

# ─── PANE 11: MONETIZATION ────────────────────────────────
tmux new-window -t "$SESSION" -n "monetization" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:monetization" \
  "echo '[MONETIZATION] Ready.' && \
   echo 'Output: $OUTPUT_DIR/monetization.md' && \
   echo 'Tiers: Free (basic) | Premium \$6.99/mo | Lifetime \$99.99' && \
   touch $HEALTH_DIR/monetization.running \
   2>&1 | tee $LOG_DIR/monetization.log" C-m

# ─── PANE 12: RETENTION ───────────────────────────────────
tmux new-window -t "$SESSION" -n "retention" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:retention" \
  "echo '[RETENTION] Ready.' && \
   echo 'Output: $OUTPUT_DIR/retention.md' && \
   echo 'Tracks: D1/D7/D30/D90, streaks, re-engagement, lifecycle' && \
   touch $HEALTH_DIR/retention.running \
   2>&1 | tee $LOG_DIR/retention.log" C-m

# ─── PANE 13: FINAL SYNTHESIS ─────────────────────────────
tmux new-window -t "$SESSION" -n "synthesis" -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:synthesis" \
  "echo '[FINAL_SYNTHESIS] Ready.' && \
   echo 'Output: $OUTPUT_DIR/master_domination_blueprint.md' && \
   echo 'Merges all agent outputs into unified strategy' && \
   touch $HEALTH_DIR/synthesis.running \
   2>&1 | tee $LOG_DIR/synthesis.log" C-m

echo ""
echo "==========================================="
echo "  CONTENT DOMINATION SYSTEM ONLINE"
echo "==========================================="
echo ""
echo "  Session: $SESSION"
echo "  Windows:"
tmux list-windows -t "$SESSION" -F "    #{window_index}: #{window_name}"
echo ""
echo "  Attach:  tmux attach -t $SESSION"
echo "  Stop:    bash scripts/tmux/stop-agents.sh"
echo "  Health:  ls -la $HEALTH_DIR/"
echo "  Logs:    ls -la $LOG_DIR/"
echo ""
echo "==========================================="
