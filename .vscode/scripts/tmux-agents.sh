#!/bin/bash
# tmux-agents.sh - Launch 4 agents in tmux panes
# Supports: detach/reattach, auto-recovery, dedicated logging
#
# Usage:
#   ./tmux-agents.sh              # Use current directory
#   ./tmux-agents.sh /path/to/workspace  # Use specific workspace
#
# Controls:
#   Ctrl+B then D     - Detach from session
#   Ctrl+B then [     - Scroll mode (q to exit)
#   Ctrl+B then arrow - Navigate between panes

set -e

SESSION_NAME="agents"
WORKSPACE="${1:-$(pwd)}"

# === COLORS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# === AGENT COMMANDS (with retry wrapper) ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RETRY_SCRIPT="${SCRIPT_DIR}/run-with-retry.sh"

# Commands with retry + timeout
CMD_I18N="$RETRY_SCRIPT 'flutter test test/l10n/language_purity_test.dart' 3 300"
CMD_SNAPSHOT="$RETRY_SCRIPT 'flutter test test/critical_ui/critical_ui_regression_test.dart' 3 600"
CMD_CHAOS="$RETRY_SCRIPT 'flutter test test/critical_ui/chaos_testing.dart' 2 600"
CMD_APPSTORE="$RETRY_SCRIPT './auto_deploy.sh' 1 900"

# === CHECK PREREQUISITES ===
if ! command -v tmux &>/dev/null; then
  echo -e "${RED}ERROR:${NC} tmux is not installed."
  echo ""
  echo "Install with:"
  echo "  macOS:  brew install tmux"
  echo "  Ubuntu: sudo apt install tmux"
  echo ""
  exit 1
fi

if ! command -v flutter &>/dev/null; then
  echo -e "${YELLOW}WARNING:${NC} Flutter not found in PATH. Tasks may fail."
fi

# === KILL EXISTING SESSION ===
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  echo -e "${YELLOW}Killing existing '$SESSION_NAME' session...${NC}"
  tmux kill-session -t "$SESSION_NAME"
fi

# === HEADER ===
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} ${BOLD}AGENTS TMUX SESSION LAUNCHER${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} Session: ${SESSION_NAME}"
echo -e "${CYAN}║${NC} Workspace: ${WORKSPACE}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} Panes:"
echo -e "${CYAN}║${NC}   [0] agent:i18n     - Language purity tests"
echo -e "${CYAN}║${NC}   [1] agent:snapshot - Critical UI regression"
echo -e "${CYAN}║${NC}   [2] agent:chaos    - Chaos/fault injection"
echo -e "${CYAN}║${NC}   [3] agent:appstore - iOS deployment validation"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# === CREATE SESSION ===
cd "$WORKSPACE"

# Create new session (detached) with first pane
tmux new-session -d -s "$SESSION_NAME" -n "agents" -x 200 -y 50

# Configure session
tmux set-option -t "$SESSION_NAME" pane-border-format " #{pane_index}: #{pane_title} "
tmux set-option -t "$SESSION_NAME" pane-border-status top
tmux set-option -t "$SESSION_NAME" pane-border-style "fg=colour240"
tmux set-option -t "$SESSION_NAME" pane-active-border-style "fg=colour45"
tmux set-option -t "$SESSION_NAME" mouse on

# Split into 4 panes (2x2 grid)
# Start with one pane, split right, then split both vertically
tmux split-window -t "$SESSION_NAME:0" -h -p 50
tmux split-window -t "$SESSION_NAME:0.0" -v -p 50
tmux split-window -t "$SESSION_NAME:0.2" -v -p 50

# Apply tiled layout for even distribution
tmux select-layout -t "$SESSION_NAME" tiled

# === CONFIGURE AND LAUNCH AGENTS ===

# Pane 0: i18n
tmux select-pane -t "$SESSION_NAME:0.0" -T "agent:i18n"
tmux send-keys -t "$SESSION_NAME:0.0" "cd '$WORKSPACE' && echo -e '\\033[1;36m=== agent:i18n ===\\033[0m' && $CMD_I18N" C-m

# Pane 1: snapshot
tmux select-pane -t "$SESSION_NAME:0.1" -T "agent:snapshot"
tmux send-keys -t "$SESSION_NAME:0.1" "cd '$WORKSPACE' && echo -e '\\033[1;36m=== agent:snapshot ===\\033[0m' && $CMD_SNAPSHOT" C-m

# Pane 2: chaos
tmux select-pane -t "$SESSION_NAME:0.2" -T "agent:chaos"
tmux send-keys -t "$SESSION_NAME:0.2" "cd '$WORKSPACE' && echo -e '\\033[1;36m=== agent:chaos ===\\033[0m' && $CMD_CHAOS" C-m

# Pane 3: appstore
tmux select-pane -t "$SESSION_NAME:0.3" -T "agent:appstore"
tmux send-keys -t "$SESSION_NAME:0.3" "cd '$WORKSPACE' && echo -e '\\033[1;36m=== agent:appstore ===\\033[0m' && $CMD_APPSTORE" C-m

# Select first pane as default
tmux select-pane -t "$SESSION_NAME:0.0"

# === SUCCESS MESSAGE ===
echo -e "${GREEN}✓${NC} Session '${SESSION_NAME}' created with 4 agent panes"
echo ""
echo -e "${BOLD}Controls:${NC}"
echo "  Ctrl+B then D        Detach from session"
echo "  Ctrl+B then [        Scroll mode (q to exit)"
echo "  Ctrl+B then arrow    Navigate between panes"
echo "  Ctrl+B then z        Zoom current pane (toggle)"
echo ""
echo -e "${BOLD}Commands:${NC}"
echo "  tmux attach -t $SESSION_NAME        Reattach to session"
echo "  tmux kill-session -t $SESSION_NAME  Kill all agents"
echo ""
echo -e "${CYAN}Attaching to session...${NC}"
echo ""

# Attach to session
tmux attach-session -t "$SESSION_NAME"
