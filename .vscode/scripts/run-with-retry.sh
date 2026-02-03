#!/bin/bash
# run-with-retry.sh - Execute command with retry and timeout protection
# Usage: run-with-retry.sh "command" [max_attempts] [timeout_seconds]
#
# Examples:
#   ./run-with-retry.sh "flutter test" 3 300
#   ./run-with-retry.sh "./deploy.sh" 1 600

set -o pipefail

# === CONFIGURATION ===
COMMAND="${1:?Command required}"
MAX_ATTEMPTS="${2:-3}"
TIMEOUT_SECONDS="${3:-300}"

# === COLORS ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# === FUNCTIONS ===
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

print_header() {
  local cmd_display="${COMMAND}"
  if [ ${#cmd_display} -gt 55 ]; then
    cmd_display="${cmd_display:0:52}..."
  fi

  echo ""
  echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC} ${BOLD}AGENT TASK RUNNER${NC}"
  echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════╣${NC}"
  echo -e "${CYAN}║${NC} Command: ${cmd_display}"
  echo -e "${CYAN}║${NC} Max Attempts: ${MAX_ATTEMPTS} | Timeout: ${TIMEOUT_SECONDS}s"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

run_with_timeout() {
  local cmd="$1"
  local timeout="$2"
  local pid
  local exit_code

  # Start command in background
  eval "$cmd" &
  pid=$!

  # Monitor with timeout
  local elapsed=0
  while kill -0 $pid 2>/dev/null; do
    if [ $elapsed -ge $timeout ]; then
      log_error "TIMEOUT after ${timeout}s - killing process (PID: $pid)"
      kill -TERM $pid 2>/dev/null
      sleep 2
      # Force kill if still running
      if kill -0 $pid 2>/dev/null; then
        kill -KILL $pid 2>/dev/null
      fi
      return 124
    fi
    sleep 1
    ((elapsed++))

    # Progress indicator every 30 seconds
    if [ $((elapsed % 30)) -eq 0 ]; then
      echo -e "${BLUE}[PROGRESS]${NC} Running for ${elapsed}s / ${timeout}s max"
    fi
  done

  wait $pid
  return $?
}

format_duration() {
  local seconds=$1
  if [ $seconds -lt 60 ]; then
    echo "${seconds}s"
  else
    local mins=$((seconds / 60))
    local secs=$((seconds % 60))
    echo "${mins}m ${secs}s"
  fi
}

# === MAIN EXECUTION ===
print_header

ATTEMPT=1
TOTAL_START=$(date +%s)

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  log_info "Attempt ${ATTEMPT} of ${MAX_ATTEMPTS}"
  echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""

  START_TIME=$(date +%s)

  run_with_timeout "$COMMAND" "$TIMEOUT_SECONDS"
  EXIT_CODE=$?

  END_TIME=$(date +%s)
  DURATION=$((END_TIME - START_TIME))
  DURATION_FMT=$(format_duration $DURATION)

  echo ""

  if [ $EXIT_CODE -eq 0 ]; then
    TOTAL_END=$(date +%s)
    TOTAL_DURATION=$(format_duration $((TOTAL_END - TOTAL_START)))

    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC} ${BOLD}✓ TASK COMPLETED SUCCESSFULLY${NC}"
    echo -e "${GREEN}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} Duration: ${DURATION_FMT} (Total: ${TOTAL_DURATION})"
    echo -e "${GREEN}║${NC} Attempts: ${ATTEMPT} of ${MAX_ATTEMPTS}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    exit 0
  elif [ $EXIT_CODE -eq 124 ]; then
    log_error "Attempt ${ATTEMPT}: TIMEOUT after ${TIMEOUT_SECONDS}s"
  else
    log_error "Attempt ${ATTEMPT}: Failed with exit code ${EXIT_CODE} (${DURATION_FMT})"
  fi

  if [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
    SLEEP_TIME=$((ATTEMPT * 5))
    log_warning "Retrying in ${SLEEP_TIME}s..."
    sleep $SLEEP_TIME
  fi

  ((ATTEMPT++))
done

TOTAL_END=$(date +%s)
TOTAL_DURATION=$(format_duration $((TOTAL_END - TOTAL_START)))

echo ""
echo -e "${RED}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║${NC} ${BOLD}✗ TASK FAILED${NC}"
echo -e "${RED}╠══════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${RED}║${NC} All ${MAX_ATTEMPTS} attempts exhausted"
echo -e "${RED}║${NC} Total time: ${TOTAL_DURATION}"
echo -e "${RED}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""
exit 1
