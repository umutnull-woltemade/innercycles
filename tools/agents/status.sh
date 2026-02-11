#!/bin/bash
# InnerCycles Agent Status Dashboard
# Displays real-time status of all agents and content pipeline

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

while true; do
    clear
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║     InnerCycles — Agent Pipeline Dashboard          ║"
    echo "║     $(date '+%Y-%m-%d %H:%M:%S')                            ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo ""

    # Content Status
    echo "── Content Files ──"
    content_dir="$PROJECT_DIR/lib/data/content"
    files=(
        "archetype_system.dart:17 archetype profiles"
        "insight_cards_content.dart:120 insight cards"
        "reflection_prompts_content.dart:60 reflection prompts"
        "affirmations_content.dart:100 affirmations"
        "journaling_exercises_content.dart:50 exercises"
    )
    for entry in "${files[@]}"; do
        file="${entry%%:*}"
        desc="${entry#*:}"
        if [ -f "$content_dir/$file" ]; then
            size=$(wc -l < "$content_dir/$file" 2>/dev/null || echo "?")
            echo "  ✅ $file ($size lines) — $desc"
        else
            echo "  ⏳ $file — $desc"
        fi
    done

    echo ""

    # Liquid Glass Status
    echo "── Liquid Glass UI ──"
    glass_dir="$PROJECT_DIR/lib/core/theme/liquid_glass"
    glass_files=("glass_tokens.dart" "glass_panel.dart" "glass_card.dart" "glass_button.dart" "glass_scaffold.dart" "glass_animations.dart" "liquid_glass.dart")
    for f in "${glass_files[@]}"; do
        if [ -f "$glass_dir/$f" ]; then
            echo "  ✅ $f"
        else
            echo "  ❌ $f"
        fi
    done

    echo ""

    # Tools Status
    echo "── Validation Tools ──"
    tools_dir="$PROJECT_DIR/tools"
    tool_files=("prediction_filter.dart" "compliance_scanner.dart" "duplicate_detector.dart" "content_validator.dart" "cost_tracker.dart")
    for f in "${tool_files[@]}"; do
        if [ -f "$tools_dir/$f" ]; then
            echo "  ✅ $f"
        else
            echo "  ❌ $f"
        fi
    done

    echo ""

    # Build Status
    echo "── Build Status ──"
    if [ -f "$PROJECT_DIR/build/ios" ]; then
        echo "  ✅ iOS build present"
    else
        echo "  ⏳ iOS build not found"
    fi

    echo ""

    # Cost Status
    echo "── Cost Budget ──"
    cd "$PROJECT_DIR"
    dart run tools/cost_tracker.dart report 2>/dev/null || echo "  No cost data yet."

    echo ""
    echo "── Press Ctrl+C to exit ──"

    sleep 10
done
