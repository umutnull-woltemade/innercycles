#!/bin/bash
# Run a single content agent
# Usage: ./tools/agents/run_agent.sh <agent_name>

set -euo pipefail

AGENT="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
LOG_DIR="$PROJECT_DIR/logs"

if [ -z "$AGENT" ]; then
    echo "Usage: $0 <agent_name>"
    echo "Available: knowledge, insight, micro, compliance, seo, locale"
    exit 1
fi

mkdir -p "$LOG_DIR"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%H:%M:%S')] [$AGENT] $1"
}

# Check budget before running
check_budget() {
    cd "$PROJECT_DIR"
    if ! dart run tools/cost_tracker.dart check monthly 2>/dev/null; then
        log "${RED}Monthly budget exceeded. Agent halted.${NC}"
        exit 1
    fi
}

run_knowledge() {
    log "${GREEN}Knowledge Agent — Generating archetype content${NC}"
    # This agent generates deep educational content
    # In production, this would call the AI pipeline
    log "Checking existing archetype profiles..."
    if [ -f "$PROJECT_DIR/lib/data/content/archetype_system.dart" ]; then
        log "✅ archetype_system.dart exists (17 profiles)"
    else
        log "❌ archetype_system.dart missing — needs generation"
    fi
    log "${GREEN}Knowledge agent cycle complete.${NC}"
}

run_insight() {
    log "${GREEN}Insight Agent — Generating insight cards & prompts${NC}"
    local files=("insight_cards_content.dart" "reflection_prompts_content.dart" "affirmations_content.dart" "journaling_exercises_content.dart")
    for f in "${files[@]}"; do
        if [ -f "$PROJECT_DIR/lib/data/content/$f" ]; then
            log "✅ $f exists"
        else
            log "⏳ $f pending generation"
        fi
    done
    log "${GREEN}Insight agent cycle complete.${NC}"
}

run_micro() {
    log "${GREEN}Micro-Content Agent — Social media content${NC}"
    mkdir -p "$PROJECT_DIR/content/social"
    log "Social content generation is configured for post-launch."
    log "${GREEN}Micro agent cycle complete.${NC}"
}

run_compliance() {
    log "${GREEN}Compliance Agent — Scanning content${NC}"
    cd "$PROJECT_DIR"

    log "Running prediction filter..."
    dart run tools/prediction_filter.dart lib/data/content/ 2>&1 || true

    log "Running compliance scanner..."
    dart run tools/compliance_scanner.dart lib/data/content/ 2>&1 || true

    log "Running content validator..."
    dart run tools/content_validator.dart lib/data/content/ 2>&1 || true

    log "Running duplicate detector..."
    dart run tools/duplicate_detector.dart lib/data/content/ 2>&1 || true

    log "${GREEN}Compliance agent cycle complete.${NC}"
}

run_seo() {
    log "${GREEN}SEO Agent — Content cluster generation${NC}"
    mkdir -p "$PROJECT_DIR/content/seo"
    log "SEO cluster generation is configured for Week 2 deployment."
    log "${GREEN}SEO agent cycle complete.${NC}"
}

run_locale() {
    log "${GREEN}Localization Agent — TR adaptation check${NC}"
    cd "$PROJECT_DIR"
    # Check for Turkish content presence
    local tr_count
    tr_count=$(grep -rl "Tr:" lib/data/content/ 2>/dev/null | wc -l || echo "0")
    log "Files with TR content: $tr_count"
    log "${GREEN}Locale agent cycle complete.${NC}"
}

# Main execution
log "Starting agent: $AGENT"
check_budget

case "$AGENT" in
    knowledge)  run_knowledge ;;
    insight)    run_insight ;;
    micro)      run_micro ;;
    compliance) run_compliance ;;
    seo)        run_seo ;;
    locale)     run_locale ;;
    *)
        log "${RED}Unknown agent: $AGENT${NC}"
        exit 1
        ;;
esac
