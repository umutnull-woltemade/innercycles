#!/usr/bin/env bash
# =============================================================
# Stop InnerCycles Content Domination System
# =============================================================

set -euo pipefail

SESSION="content_domination"
PROJECT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
HEALTH_DIR="$PROJECT_DIR/logs/health"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Stopping content domination session: $SESSION"

  # Mark all agents as stopped
  if [ -d "$HEALTH_DIR" ]; then
    find "$HEALTH_DIR" -name '*.running' -exec rm {} \; 2>/dev/null || true
    echo "Health markers cleared."
  fi

  tmux kill-session -t "$SESSION"
  echo ""
  echo "All 13 agents stopped."
  echo "Logs preserved at: $PROJECT_DIR/logs/agents/"
  echo "Outputs preserved at: $PROJECT_DIR/outputs/"
else
  echo "No active content_domination session found."
fi
