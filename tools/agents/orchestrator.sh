#!/bin/bash
# InnerCycles Content Orchestrator
# Manages multi-agent content generation pipeline via TMUX
#
# Usage: ./tools/agents/orchestrator.sh [start|stop|status|restart]

set -euo pipefail

SESSION="innercycles-agents"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_DIR="$PROJECT_DIR/logs"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

mkdir -p "$LOG_DIR"

log() {
    echo -e "${BLUE}[orchestrator]${NC} $(date '+%H:%M:%S') $1"
}

start_session() {
    if tmux has-session -t "$SESSION" 2>/dev/null; then
        log "${YELLOW}Session '$SESSION' already exists. Use 'restart' to recreate.${NC}"
        exit 1
    fi

    log "${GREEN}Starting InnerCycles agent session...${NC}"

    # Create session with orchestrator window
    tmux new-session -d -s "$SESSION" -n "orchestrator"
    tmux send-keys -t "$SESSION:orchestrator" "cd $PROJECT_DIR && $SCRIPT_DIR/status.sh" Enter

    # Create agent windows
    local agents=("knowledge" "insight" "micro" "compliance" "seo" "locale")
    for agent in "${agents[@]}"; do
        tmux new-window -t "$SESSION" -n "$agent"
        tmux send-keys -t "$SESSION:$agent" "cd $PROJECT_DIR && $SCRIPT_DIR/run_agent.sh $agent 2>&1 | tee $LOG_DIR/${agent}.log" Enter
    done

    # Monitor window
    tmux new-window -t "$SESSION" -n "monitor"
    tmux send-keys -t "$SESSION:monitor" "cd $PROJECT_DIR && watch -n 10 'dart run tools/cost_tracker.dart report 2>/dev/null || echo \"No cost data yet\"'" Enter

    # Select orchestrator window
    tmux select-window -t "$SESSION:orchestrator"

    log "${GREEN}Session started with ${#agents[@]} agents + monitor.${NC}"
    log "Attach with: tmux attach -t $SESSION"
}

stop_session() {
    if ! tmux has-session -t "$SESSION" 2>/dev/null; then
        log "${YELLOW}No active session found.${NC}"
        exit 0
    fi

    log "${RED}Stopping all agents...${NC}"
    tmux kill-session -t "$SESSION"
    log "${GREEN}Session stopped.${NC}"
}

show_status() {
    if ! tmux has-session -t "$SESSION" 2>/dev/null; then
        log "${YELLOW}No active session.${NC}"
        exit 0
    fi

    echo ""
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║       InnerCycles Agent Orchestrator — Status       ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo ""

    tmux list-windows -t "$SESSION" -F "  #{window_index}: #{window_name} (#{pane_current_command})" 2>/dev/null

    echo ""
    echo "── Recent Logs ──"
    for logfile in "$LOG_DIR"/*.log; do
        if [ -f "$logfile" ]; then
            agent=$(basename "$logfile" .log)
            last_line=$(tail -1 "$logfile" 2>/dev/null || echo "no output")
            echo "  $agent: $last_line"
        fi
    done

    echo ""
    echo "── Cost Summary ──"
    cd "$PROJECT_DIR" && dart run tools/cost_tracker.dart report 2>/dev/null || echo "  No cost data yet."
}

case "${1:-status}" in
    start)   start_session ;;
    stop)    stop_session ;;
    status)  show_status ;;
    restart) stop_session; sleep 1; start_session ;;
    *)
        echo "Usage: $0 [start|stop|status|restart]"
        exit 1
        ;;
esac
