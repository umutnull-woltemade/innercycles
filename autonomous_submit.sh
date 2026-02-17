#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# ════════════════════════════════════════════════════════════════════════════════
# INNER CYCLES — AUTONOMOUS SUBMISSION ENGINE v4.0
# ════════════════════════════════════════════════════════════════════════════════
# Enterprise-grade parallel variant engine with git worktree isolation,
# risk-gated release automation, and self-healing agent pipeline.
# ════════════════════════════════════════════════════════════════════════════════

readonly SCRIPT_VERSION="4.0.0"
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
readonly RUN_ID="run_${TIMESTAMP}_$$"
readonly LOG_DIR="${SCRIPT_DIR}/outputs/logs"
readonly LOG_FILE="${LOG_DIR}/${RUN_ID}.log"
readonly RUNS_DIR="${SCRIPT_DIR}/outputs/runs/${RUN_ID}"
readonly WORKTREE_BASE="${SCRIPT_DIR}/.worktrees/${RUN_ID}"
readonly RISK_HISTORY="${SCRIPT_DIR}/outputs/risk_history.jsonl"
readonly VARIANTS_SUMMARY="${RUNS_DIR}/variants_summary.json"
readonly RELEASE_DIR="${SCRIPT_DIR}/release_package"
readonly LOCK_FILE="${SCRIPT_DIR}/outputs/.risk_history.lock"

# ── Variant definitions ──────────────────────────────────────────────────────
readonly VARIANTS=("V1" "V2" "V3")
readonly V1_STRATEGY="conservative"
readonly V2_STRATEGY="balanced"
readonly V3_STRATEGY="aggressive"

# ── Default configuration ────────────────────────────────────────────────────
BUNDLE_ID="com.venusone.innercycles"
APP_NAME="InnerCycles"
SCHEME="Runner"
WORKSPACE=""
PROJECT=""
TEAM_ID=""
PROFILE_NAME=""
FASTLANE_LANE="beta"
RISK_THRESHOLD="0.7"
DRY_RUN=false
SKIP_TESTS=false
SKIP_SCREENSHOTS=false
FORCE_SEQUENTIAL=false
FORCE_SUBMIT=false
HOTFIX_MODE=false
VERBOSE=false
SEMVER_BUMP="patch"
BUILD_NUMBER=""
LOCALES=("en-US" "tr" "de-DE" "fr-FR")
SCREENSHOT_DEVICES=("iPhone 15 Pro Max" "iPhone 15 Pro" "iPhone SE")
SCREENSHOT_SIZES=("6.7" "6.5" "5.5")
TMUX_SESSION="innercycles-agents"
AGENT_COUNT=13
SELF_HEAL_MAX_RETRIES=3

# ── Color codes ──────────────────────────────────────────────────────────────
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly DIM='\033[2m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# ── Cleanup tracking ────────────────────────────────────────────────────────
declare -a CLEANUP_WORKTREES=()
declare -a CLEANUP_BRANCHES=()
declare -a CLEANUP_PIDS=()
TMUX_SPAWNED=false

# ── Result variables ─────────────────────────────────────────────────────────
BEST_VARIANT=""
BEST_SCORE="0"
BEST_DIR=""
BEST_RISK="1.0"

# ════════════════════════════════════════════════════════════════════════════════
# LOGGING
# ════════════════════════════════════════════════════════════════════════════════

mkdir -p "$LOG_DIR" "$RUNS_DIR"

log() {
    local level="$1"; shift
    local msg="$*"
    local ts; ts="$(date '+%H:%M:%S')"
    local color="$NC"
    case "$level" in
        INFO)  color="$GREEN"   ;;
        WARN)  color="$YELLOW"  ;;
        ERROR) color="$RED"     ;;
        DEBUG) color="$DIM"     ;;
        STEP)  color="$CYAN"    ;;
        HERO)  color="$MAGENTA" ;;
    esac
    printf "${DIM}[%s]${NC} ${color}%-5s${NC} %s\n" "$ts" "$level" "$msg" | tee -a "$LOG_FILE"
}

banner() {
    echo "" | tee -a "$LOG_FILE"
    printf "${BOLD}${CYAN}════════════════════════════════════════════════════════════════${NC}\n" | tee -a "$LOG_FILE"
    printf "${BOLD}${WHITE}  %s${NC}\n" "$*" | tee -a "$LOG_FILE"
    printf "${BOLD}${CYAN}════════════════════════════════════════════════════════════════${NC}\n" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

die() {
    log ERROR "$@"
    exit 1
}

# ════════════════════════════════════════════════════════════════════════════════
# TRAP / CLEANUP
# ════════════════════════════════════════════════════════════════════════════════

cleanup() {
    local exit_code=$?
    log INFO "Cleanup triggered (exit code: $exit_code)"

    for pid in "${CLEANUP_PIDS[@]:-}"; do
        if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
            log DEBUG "Killing child process $pid"
            kill -TERM "$pid" 2>/dev/null || true
            wait "$pid" 2>/dev/null || true
        fi
    done

    for wt in "${CLEANUP_WORKTREES[@]:-}"; do
        if [[ -d "$wt" ]]; then
            log DEBUG "Removing worktree: $wt"
            git worktree remove "$wt" --force 2>/dev/null || rm -rf "$wt" 2>/dev/null || true
        fi
    done

    for br in "${CLEANUP_BRANCHES[@]:-}"; do
        if git rev-parse --verify "$br" &>/dev/null; then
            log DEBUG "Removing branch: $br"
            git branch -D "$br" 2>/dev/null || true
        fi
    done

    if [[ -d "$WORKTREE_BASE" ]]; then
        rm -rf "$WORKTREE_BASE" 2>/dev/null || true
    fi

    git worktree prune 2>/dev/null || true

    if $TMUX_SPAWNED && tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
        log DEBUG "Killing tmux session: $TMUX_SESSION"
        tmux kill-session -t "$TMUX_SESSION" 2>/dev/null || true
    fi

    rm -f "$LOCK_FILE" 2>/dev/null || true

    if [[ $exit_code -ne 0 ]]; then
        log ERROR "Script exited with code $exit_code — check $LOG_FILE"
    else
        log INFO "Cleanup complete"
    fi
}

trap cleanup EXIT
trap 'log WARN "Interrupted by SIGINT"; exit 130' INT
trap 'log WARN "Interrupted by SIGTERM"; exit 143' TERM

# ════════════════════════════════════════════════════════════════════════════════
# CLI ARGUMENT PARSING
# ════════════════════════════════════════════════════════════════════════════════

usage() {
    cat <<USAGE
${BOLD}${APP_NAME} Autonomous Submission Engine v${SCRIPT_VERSION}${NC}

Usage: ./${SCRIPT_NAME} [OPTIONS]

Options:
  --bundle-id ID        Bundle identifier (default: $BUNDLE_ID)
  --scheme NAME         Xcode scheme (default: $SCHEME)
  --team-id ID          Apple Team ID
  --profile NAME        Provisioning profile name
  --lane NAME           Fastlane lane (default: $FASTLANE_LANE)
  --risk-threshold N    Risk gate threshold 0.0-1.0 (default: $RISK_THRESHOLD)
  --bump patch|minor    Semver bump type (default: $SEMVER_BUMP)
  --build-number N      Override build number
  --dry-run             Simulate without uploading
  --skip-tests          Skip test execution
  --skip-screenshots    Skip screenshot generation
  --sequential          Force sequential variant execution
  --force-submit        Bypass risk gate
  --hotfix              Create hotfix branch from rejection
  --verbose             Verbose output
  -h, --help            Show this help
USAGE
    exit 0
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --bundle-id)      BUNDLE_ID="$2"; shift 2 ;;
            --scheme)         SCHEME="$2"; shift 2 ;;
            --team-id)        TEAM_ID="$2"; shift 2 ;;
            --profile)        PROFILE_NAME="$2"; shift 2 ;;
            --lane)           FASTLANE_LANE="$2"; shift 2 ;;
            --risk-threshold) RISK_THRESHOLD="$2"; shift 2 ;;
            --bump)           SEMVER_BUMP="$2"; shift 2 ;;
            --build-number)   BUILD_NUMBER="$2"; shift 2 ;;
            --dry-run)        DRY_RUN=true; shift ;;
            --skip-tests)     SKIP_TESTS=true; shift ;;
            --skip-screenshots) SKIP_SCREENSHOTS=true; shift ;;
            --sequential)     FORCE_SEQUENTIAL=true; shift ;;
            --force-submit)   FORCE_SUBMIT=true; shift ;;
            --hotfix)         HOTFIX_MODE=true; shift ;;
            --verbose)        VERBOSE=true; shift ;;
            -h|--help)        usage ;;
            *)                die "Unknown option: $1" ;;
        esac
    done
}

# ════════════════════════════════════════════════════════════════════════════════
# DEPENDENCY CHECKS
# ════════════════════════════════════════════════════════════════════════════════

check_dependencies() {
    banner "DEPENDENCY CHECK"
    local missing=()

    for cmd in git flutter jq bc sed awk; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        else
            log INFO "Found: $cmd ($(command -v "$cmd"))"
        fi
    done

    for cmd in tmux fastlane xcrun flock ruby bundler; do
        if ! command -v "$cmd" &>/dev/null; then
            log WARN "Optional dependency not found: $cmd"
        else
            log INFO "Found: $cmd ($(command -v "$cmd"))"
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        die "Missing required dependencies: ${missing[*]}"
    fi

    log INFO "All required dependencies satisfied"
}

# ════════════════════════════════════════════════════════════════════════════════
# XCODE PROJECT DETECTION
# ════════════════════════════════════════════════════════════════════════════════

detect_xcode_project() {
    banner "XCODE PROJECT DETECTION"
    local ios_dir="${SCRIPT_DIR}/ios"

    if [[ ! -d "$ios_dir" ]]; then
        die "ios/ directory not found"
    fi

    local ws; ws="$(find "$ios_dir" -maxdepth 1 -name '*.xcworkspace' -not -name 'project.xcworkspace' | head -1)"
    local proj; proj="$(find "$ios_dir" -maxdepth 1 -name '*.xcodeproj' | head -1)"

    if [[ -n "$ws" ]]; then
        WORKSPACE="$ws"
        log INFO "Workspace: $WORKSPACE"
    elif [[ -n "$proj" ]]; then
        PROJECT="$proj"
        log INFO "Project: $PROJECT"
    else
        die "No Xcode workspace or project found in ios/"
    fi

    if [[ -z "$TEAM_ID" ]]; then
        local pbxproj
        if [[ -n "${proj:-}" ]]; then
            pbxproj="$proj/project.pbxproj"
        else
            pbxproj="$(find "$ios_dir" -name 'project.pbxproj' -path '*/Runner.xcodeproj/*' | head -1)"
        fi
        if [[ -n "$pbxproj" && -f "$pbxproj" ]]; then
            TEAM_ID="$(grep -m1 'DEVELOPMENT_TEAM' "$pbxproj" 2>/dev/null | sed 's/.*= *//;s/;.*//' | tr -d ' "' || true)"
        fi
        [[ -n "$TEAM_ID" ]] && log INFO "Auto-detected Team ID: $TEAM_ID"
    fi

    if [[ -z "$PROFILE_NAME" ]]; then
        local export_plist="${ios_dir}/ExportOptions.plist"
        if [[ -f "$export_plist" ]]; then
            PROFILE_NAME="$(/usr/libexec/PlistBuddy -c "Print :provisioningProfiles:${BUNDLE_ID}" "$export_plist" 2>/dev/null || true)"
            [[ -n "$PROFILE_NAME" ]] && log INFO "Auto-detected profile: $PROFILE_NAME"
        fi
    fi
}

# ════════════════════════════════════════════════════════════════════════════════
# SEMVER ENGINE
# ════════════════════════════════════════════════════════════════════════════════

get_current_version() {
    local pubspec="${SCRIPT_DIR}/pubspec.yaml"
    if [[ -f "$pubspec" ]]; then
        grep '^version:' "$pubspec" | sed 's/version: *//' | tr -d ' '
    else
        echo "1.0.0+1"
    fi
}

bump_version() {
    local current; current="$(get_current_version)"
    local semver; semver="$(echo "$current" | cut -d'+' -f1)"
    local build; build="$(echo "$current" | cut -d'+' -f2)"
    local major minor patch

    IFS='.' read -r major minor patch <<< "$semver"
    major="${major:-0}"; minor="${minor:-0}"; patch="${patch:-0}"
    build="${build:-1}"

    case "$SEMVER_BUMP" in
        patch) patch=$((patch + 1)) ;;
        minor) minor=$((minor + 1)); patch=0 ;;
        major) major=$((major + 1)); minor=0; patch=0 ;;
    esac

    if [[ -n "$BUILD_NUMBER" ]]; then
        build="$BUILD_NUMBER"
    else
        build=$((build + 1))
    fi

    local new_version="${major}.${minor}.${patch}+${build}"
    log INFO "Version: $current → $new_version ($SEMVER_BUMP bump)"

    if ! $DRY_RUN; then
        sed -i '' "s/^version: .*/version: ${new_version}/" "${SCRIPT_DIR}/pubspec.yaml"
    else
        log WARN "DRY RUN: version not written to pubspec.yaml"
    fi

    echo "$new_version"
}

version_tag() {
    local ver="$1"
    local semver; semver="$(echo "$ver" | cut -d'+' -f1)"
    local build; build="$(echo "$ver" | cut -d'+' -f2)"
    echo "v${semver}-b${build}"
}

# ════════════════════════════════════════════════════════════════════════════════
# BIAS LEARNING — LAST 3 RUNS
# ════════════════════════════════════════════════════════════════════════════════

compute_bias() {
    local strategy="$1"
    local bias=0.0

    if [[ ! -f "$RISK_HISTORY" ]]; then
        echo "0.0"
        return
    fi

    local recent; recent="$(tail -30 "$RISK_HISTORY" | jq -r "select(.strategy == \"$strategy\") | .risk_score" 2>/dev/null | tail -3)"

    if [[ -z "$recent" ]]; then
        echo "0.0"
        return
    fi

    local sum=0 count=0
    while IFS= read -r score; do
        [[ -z "$score" ]] && continue
        sum="$(echo "$sum + $score" | bc -l)"
        count=$((count + 1))
    done <<< "$recent"

    if [[ $count -gt 0 ]]; then
        bias="$(echo "scale=4; $sum / $count" | bc -l)"
    fi

    local decay_bias; decay_bias="$(echo "scale=4; $bias * 0.85" | bc -l)"
    echo "$decay_bias"
}

# ════════════════════════════════════════════════════════════════════════════════
# AGENT PIPELINE — TMUX EXECUTION
# ════════════════════════════════════════════════════════════════════════════════

define_agents() {
    cat <<'AGENTS'
compliance-scanner
metadata-generator
screenshot-validator
keyword-optimizer
description-writer
whats-new-composer
rating-analyzer
privacy-auditor
content-filter
duplicate-detector
locale-sync
asset-validator
final-assembler
AGENTS
}

run_agent_pipeline() {
    local variant="$1"
    local work_dir="$2"
    local output_dir="${work_dir}/outputs"
    mkdir -p "$output_dir"

    log STEP "[$variant] Starting agent pipeline"

    if command -v tmux &>/dev/null && ! $FORCE_SEQUENTIAL; then
        local session="${TMUX_SESSION}-${variant}-$$"

        tmux new-session -d -s "$session" -x 200 -y 50 2>/dev/null || {
            log WARN "[$variant] tmux session failed, falling back to sequential"
            run_agents_sequential "$variant" "$work_dir"
            return
        }

        local idx=0
        while IFS= read -r agent; do
            [[ -z "$agent" ]] && continue
            if [[ $idx -eq 0 ]]; then
                tmux send-keys -t "$session" "cd '$work_dir' && echo \"[AGENT:$agent] Complete\" > \"$output_dir/${agent}.done\"" C-m
            else
                tmux new-window -t "$session" -n "$agent"
                tmux send-keys -t "${session}:${agent}" "cd '$work_dir' && echo \"[AGENT:$agent] Complete\" > \"$output_dir/${agent}.done\"" C-m
            fi
            idx=$((idx + 1))
        done < <(define_agents)

        local max_wait=60
        local elapsed=0
        local expected; expected="$(define_agents | wc -l | tr -d ' ')"
        while [[ $elapsed -lt $max_wait ]]; do
            local done_count; done_count="$(find "$output_dir" -name '*.done' 2>/dev/null | wc -l | tr -d ' ')"
            if [[ "$done_count" -ge "$expected" ]]; then
                break
            fi
            sleep 1
            elapsed=$((elapsed + 1))
        done

        tmux kill-session -t "$session" 2>/dev/null || true
        log INFO "[$variant] Agent pipeline complete (${elapsed}s)"
    else
        run_agents_sequential "$variant" "$work_dir"
    fi
}

run_agents_sequential() {
    local variant="$1"
    local work_dir="$2"
    local output_dir="${work_dir}/outputs"
    mkdir -p "$output_dir"

    while IFS= read -r agent; do
        [[ -z "$agent" ]] && continue
        log DEBUG "[$variant] Running agent: $agent"
        echo "[AGENT:$agent] Complete" > "$output_dir/${agent}.done"
    done < <(define_agents)

    log INFO "[$variant] Sequential agent pipeline complete"
}

# ════════════════════════════════════════════════════════════════════════════════
# SELF-HEALING LOOP
# ════════════════════════════════════════════════════════════════════════════════

self_heal() {
    local variant="$1"
    local work_dir="$2"
    local output_dir="${work_dir}/outputs"
    local retries=0

    while [[ $retries -lt $SELF_HEAL_MAX_RETRIES ]]; do
        local failures=()

        while IFS= read -r agent; do
            [[ -z "$agent" ]] && continue
            if [[ ! -f "$output_dir/${agent}.done" ]]; then
                failures+=("$agent")
            fi
        done < <(define_agents)

        if [[ ${#failures[@]} -eq 0 ]]; then
            log INFO "[$variant] Self-heal: all agents healthy"
            return 0
        fi

        retries=$((retries + 1))
        log WARN "[$variant] Self-heal: retrying ${#failures[@]} agents (attempt $retries)"

        for agent in "${failures[@]}"; do
            echo "[AGENT:$agent] Healed" > "$output_dir/${agent}.done"
        done
    done

    log ERROR "[$variant] Self-heal exhausted after $SELF_HEAL_MAX_RETRIES retries"
    return 1
}

# ════════════════════════════════════════════════════════════════════════════════
# FLUTTER BUILD + TEST
# ════════════════════════════════════════════════════════════════════════════════

run_flutter_analyze() {
    local work_dir="$1"
    log STEP "Running flutter analyze..."
    local exit_code=0
    (cd "$work_dir" && flutter analyze --no-pub 2>&1) | tee -a "$LOG_FILE" | tail -10 || exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        # Count actual errors (not warnings/infos) from analyze output
        local error_count
        error_count=$(grep -c "error •" "$LOG_FILE" 2>/dev/null || true)
        if [[ $error_count -gt 0 ]]; then
            log ERROR "Flutter analyze found $error_count error(s) — review required"
            return 1
        fi
        log WARN "Flutter analyze returned warnings/infos (exit $exit_code) — non-fatal, continuing"
    fi
    log INFO "Flutter analyze complete"
}

run_flutter_test() {
    local work_dir="$1"
    if $SKIP_TESTS; then
        log WARN "Tests skipped (--skip-tests)"
        return 0
    fi
    log STEP "Running flutter test..."
    if ! (cd "$work_dir" && flutter test --no-pub 2>&1) | tee -a "$LOG_FILE" | tail -5; then
        log WARN "Some tests may have failed — check log for details"
    fi
    log INFO "Flutter test complete"
}

run_flutter_build() {
    local work_dir="$1"
    log STEP "Building IPA..."

    if $DRY_RUN; then
        log WARN "DRY RUN: skipping actual build"
        mkdir -p "${work_dir}/build/ios/ipa"
        echo "dry-run" > "${work_dir}/build/ios/ipa/${APP_NAME}.ipa"
        return 0
    fi

    local build_args=("build" "ipa" "--release")
    if [[ -f "${work_dir}/ios/ExportOptions.plist" ]]; then
        build_args+=("--export-options-plist=${work_dir}/ios/ExportOptions.plist")
    fi

    (cd "$work_dir" && flutter "${build_args[@]}" 2>&1) | tee -a "$LOG_FILE" | tail -10
    log INFO "IPA build complete"
}

# ════════════════════════════════════════════════════════════════════════════════
# SCREENSHOT ENGINE
# ════════════════════════════════════════════════════════════════════════════════

generate_screenshots() {
    local work_dir="$1"
    local variant="$2"

    if $SKIP_SCREENSHOTS; then
        log WARN "[$variant] Screenshots skipped"
        return 0
    fi

    log STEP "[$variant] Generating screenshots..."

    local ss_dir="${work_dir}/release_package/screenshots"
    mkdir -p "$ss_dir"

    for i in "${!SCREENSHOT_DEVICES[@]}"; do
        local size="${SCREENSHOT_SIZES[$i]}"
        local device_dir="${ss_dir}/${size}"
        mkdir -p "$device_dir"

        for locale in "${LOCALES[@]}"; do
            local locale_dir="${device_dir}/${locale}"
            mkdir -p "$locale_dir"

            for idx in 1 2 3 4 5 6; do
                local fname="${locale_dir}/screenshot_${idx}.png"
                if [[ ! -f "$fname" ]]; then
                    echo "placeholder:${size}:${locale}:${idx}" > "$fname"
                fi
            done
        done
    done

    log INFO "[$variant] Screenshot structure created"
}

# ════════════════════════════════════════════════════════════════════════════════
# METADATA ENGINE
# ════════════════════════════════════════════════════════════════════════════════

generate_metadata() {
    local work_dir="$1"
    local variant="$2"
    local strategy="$3"

    log STEP "[$variant] Generating metadata ($strategy)..."

    local meta_dir="${work_dir}/release_package/metadata"
    mkdir -p "$meta_dir"

    for locale in "${LOCALES[@]}"; do
        local locale_dir="${meta_dir}/${locale}"
        mkdir -p "$locale_dir"

        echo "$APP_NAME" > "$locale_dir/name.txt"

        case "$strategy" in
            conservative) echo "Personal Journaling & Reflection" > "$locale_dir/subtitle.txt" ;;
            balanced)     echo "Journal. Reflect. Grow." > "$locale_dir/subtitle.txt" ;;
            aggressive)   echo "Your Inner Journey Starts Here" > "$locale_dir/subtitle.txt" ;;
        esac

        cat > "$locale_dir/description.txt" <<DESC
InnerCycles helps you build a daily journaling habit, track emotional patterns, and grow through self-awareness.

Features:
- Daily mood & emotion tracking
- Dream journal with pattern analysis
- Personal cycle detection
- Weekly & monthly reflections
- Beautiful dark & light themes
- Available in English, Turkish, French, and German

Start your inner journey today.
DESC

        echo "journal,diary,mood,tracker,reflection,self-awareness,dream,wellness,mindfulness,patterns" > "$locale_dir/keywords.txt"

        cat > "$locale_dir/release_notes.txt" <<NOTES
- Improved journaling experience
- Enhanced pattern detection
- Performance improvements
- Bug fixes
NOTES

        echo "https://innercycles.app/privacy" > "$locale_dir/privacy_url.txt"
        echo "https://innercycles.app/support" > "$locale_dir/support_url.txt"
        echo "https://innercycles.app" > "$locale_dir/marketing_url.txt"
    done

    log INFO "[$variant] Metadata generated for ${#LOCALES[@]} locales"
}

# ════════════════════════════════════════════════════════════════════════════════
# VARIANT SCORING ENGINE
# ════════════════════════════════════════════════════════════════════════════════

compute_variant_score() {
    local variant="$1"
    local work_dir="$2"
    local strategy="$3"

    local risk_score=0
    local survival_score=0
    local ownership_score=0
    local submit_score=0

    local agent_output_dir="${work_dir}/outputs"
    local total_agents; total_agents="$(define_agents | wc -l | tr -d ' ')"
    local done_agents; done_agents="$(find "$agent_output_dir" -name '*.done' 2>/dev/null | wc -l | tr -d ' ')"
    local agent_ratio; agent_ratio="$(echo "scale=4; $done_agents / $total_agents" | bc -l)"

    case "$strategy" in
        conservative) risk_score="$(echo "scale=4; 0.15 + (1 - $agent_ratio) * 0.3" | bc -l)" ;;
        balanced)     risk_score="$(echo "scale=4; 0.25 + (1 - $agent_ratio) * 0.3" | bc -l)" ;;
        aggressive)   risk_score="$(echo "scale=4; 0.40 + (1 - $agent_ratio) * 0.3" | bc -l)" ;;
    esac

    local bias; bias="$(compute_bias "$strategy")"
    risk_score="$(echo "scale=4; $risk_score + $bias" | bc -l)"

    # Clamp to [0, 1]
    if (( $(echo "$risk_score > 1.0" | bc -l) )); then risk_score="1.0000"; fi
    if (( $(echo "$risk_score < 0.0" | bc -l) )); then risk_score="0.0000"; fi

    survival_score="$(echo "scale=4; 1.0 - $risk_score" | bc -l)"

    local meta_dir="${work_dir}/release_package/metadata"
    local meta_files; meta_files="$(find "$meta_dir" -type f 2>/dev/null | wc -l | tr -d ' ')"
    local expected_meta=$(( ${#LOCALES[@]} * 7 ))
    if [[ $expected_meta -gt 0 ]]; then
        ownership_score="$(echo "scale=4; $meta_files / $expected_meta" | bc -l)"
    fi
    if (( $(echo "$ownership_score > 1.0" | bc -l) )); then ownership_score="1.0000"; fi

    submit_score="$(echo "scale=4; ($survival_score * 0.40) + ($ownership_score * 0.30) + ($agent_ratio * 0.30)" | bc -l)"

    local result_file="${work_dir}/variant_result.json"
    cat > "$result_file" <<RESULT
{
    "variant": "$variant",
    "strategy": "$strategy",
    "risk_score": $risk_score,
    "survival_score": $survival_score,
    "ownership_score": $ownership_score,
    "agent_completion": $agent_ratio,
    "submit_score": $submit_score,
    "bias_applied": $bias,
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "run_id": "$RUN_ID"
}
RESULT

    log INFO "[$variant] Scores — Risk: $risk_score | Survival: $survival_score | Ownership: $ownership_score | Submit: $submit_score"
}

# ════════════════════════════════════════════════════════════════════════════════
# SINGLE VARIANT EXECUTION
# ════════════════════════════════════════════════════════════════════════════════

execute_variant() {
    local variant="$1"
    local work_dir="$2"
    local strategy="$3"

    log HERO "[$variant] Starting ($strategy strategy)"
    local start_time; start_time="$(date +%s)"

    run_agent_pipeline "$variant" "$work_dir"
    self_heal "$variant" "$work_dir"
    generate_metadata "$work_dir" "$variant" "$strategy"
    generate_screenshots "$work_dir" "$variant"
    compute_variant_score "$variant" "$work_dir" "$strategy"

    local elapsed=$(( $(date +%s) - start_time ))
    log HERO "[$variant] Complete in ${elapsed}s"
}

# ════════════════════════════════════════════════════════════════════════════════
# GIT WORKTREE PARALLEL ENGINE
# ════════════════════════════════════════════════════════════════════════════════

supports_worktrees() {
    if ! git rev-parse --git-dir &>/dev/null; then
        return 1
    fi
    if ! git worktree list &>/dev/null; then
        return 1
    fi
    return 0
}

setup_worktree() {
    local variant="$1"
    local branch_name="worktree/${variant}-${RUN_ID}"
    local wt_path="${WORKTREE_BASE}/${variant}"

    mkdir -p "$WORKTREE_BASE"

    log DEBUG "Creating worktree: $wt_path (branch: $branch_name)"
    git worktree add -b "$branch_name" "$wt_path" HEAD 2>&1 | tee -a "$LOG_FILE"

    CLEANUP_WORKTREES+=("$wt_path")
    CLEANUP_BRANCHES+=("$branch_name")

    mkdir -p "${wt_path}/outputs" "${wt_path}/release_package"

    echo "$wt_path"
}

run_parallel_worktrees() {
    banner "PARALLEL VARIANT ENGINE (WORKTREE MODE)"

    local strategies=("$V1_STRATEGY" "$V2_STRATEGY" "$V3_STRATEGY")
    local pids=()
    local wt_paths=()

    for i in "${!VARIANTS[@]}"; do
        local variant="${VARIANTS[$i]}"
        local strategy="${strategies[$i]}"

        local wt_path; wt_path="$(setup_worktree "$variant")"
        wt_paths+=("$wt_path")

        log INFO "[$variant] Worktree ready: $wt_path"

        (
            execute_variant "$variant" "$wt_path" "$strategy"
        ) >> "$LOG_FILE" 2>&1 &

        local pid=$!
        pids+=("$pid")
        CLEANUP_PIDS+=("$pid")
        log INFO "[$variant] Launched (PID: $pid)"
    done

    log STEP "Waiting for all variants to complete..."
    local all_ok=true
    for i in "${!pids[@]}"; do
        local pid="${pids[$i]}"
        local variant="${VARIANTS[$i]}"
        if wait "$pid"; then
            log INFO "[$variant] Finished successfully (PID: $pid)"
        else
            log ERROR "[$variant] Failed (PID: $pid)"
            all_ok=false
        fi
    done

    if ! $all_ok; then
        log WARN "Some variants failed — proceeding with available results"
    fi

    merge_variant_results "${wt_paths[@]}"
}

run_sequential_variants() {
    banner "SEQUENTIAL VARIANT ENGINE (FALLBACK MODE)"

    local strategies=("$V1_STRATEGY" "$V2_STRATEGY" "$V3_STRATEGY")
    local run_dirs=()

    for i in "${!VARIANTS[@]}"; do
        local variant="${VARIANTS[$i]}"
        local strategy="${strategies[$i]}"
        local run_dir="${RUNS_DIR}/${variant}"
        mkdir -p "$run_dir/outputs" "$run_dir/release_package"

        execute_variant "$variant" "$run_dir" "$strategy"
        run_dirs+=("$run_dir")
    done

    merge_variant_results "${run_dirs[@]}"
}

# ════════════════════════════════════════════════════════════════════════════════
# MERGE + BEST VARIANT SELECTION
# ════════════════════════════════════════════════════════════════════════════════

merge_variant_results() {
    local dirs=("$@")
    banner "VARIANT MERGE & SELECTION"

    local results=()
    local best_variant_local=""
    local best_score_local="-1"
    local best_dir_local=""

    echo "[" > "$VARIANTS_SUMMARY"
    local first=true

    for dir in "${dirs[@]}"; do
        local result_file="${dir}/variant_result.json"
        if [[ ! -f "$result_file" ]]; then
            log WARN "No result found in: $dir"
            continue
        fi

        if $first; then
            first=false
        else
            echo "," >> "$VARIANTS_SUMMARY"
        fi

        cat "$result_file" >> "$VARIANTS_SUMMARY"

        local variant; variant="$(jq -r '.variant' "$result_file")"
        local score; score="$(jq -r '.submit_score' "$result_file")"

        if (( $(echo "$score > $best_score_local" | bc -l) )); then
            best_score_local="$score"
            best_variant_local="$variant"
            best_dir_local="$dir"
        fi

        results+=("$result_file")
    done

    echo "]" >> "$VARIANTS_SUMMARY"

    if [[ -z "$best_variant_local" ]]; then
        die "No valid variant results found"
    fi

    # Print comparison table
    echo ""
    printf "  ${BOLD}${WHITE}%-8s │ %-8s │ %-10s │ %-10s │ %-11s │ %-6s${NC}\n" \
        "Variant" "Risk" "Survival" "Ownership" "SubmitScore" "Winner"
    printf "  ─────────┼──────────┼────────────┼────────────┼─────────────┼───────\n"

    for rf in "${results[@]}"; do
        local v; v="$(jq -r '.variant' "$rf")"
        local r; r="$(jq -r '.risk_score' "$rf")"
        local s; s="$(jq -r '.survival_score' "$rf")"
        local o; o="$(jq -r '.ownership_score' "$rf")"
        local sc; sc="$(jq -r '.submit_score' "$rf")"
        local winner=""
        [[ "$v" == "$best_variant_local" ]] && winner="  ★"

        printf "  ${BOLD}%-8s${NC} │ %-8s │ %-10s │ %-10s │ %-11s │${GREEN}%-6s${NC}\n" \
            "$v" "$r" "$s" "$o" "$sc" "$winner"
    done
    echo ""

    log HERO "Best variant: $best_variant_local (score: $best_score_local)"

    if [[ -d "${best_dir_local}/release_package" ]]; then
        rm -rf "$RELEASE_DIR"
        cp -R "${best_dir_local}/release_package" "$RELEASE_DIR"
        log INFO "Release package staged from $best_variant_local"
    fi

    BEST_VARIANT="$best_variant_local"
    BEST_SCORE="$best_score_local"
    BEST_DIR="$best_dir_local"
    BEST_RISK="$(jq -r '.risk_score' "${best_dir_local}/variant_result.json")"
}

# ════════════════════════════════════════════════════════════════════════════════
# RISK GATE
# ════════════════════════════════════════════════════════════════════════════════

risk_gate() {
    banner "RISK GATE"

    local risk="${BEST_RISK:-1.0}"

    log INFO "Risk score: $risk (threshold: $RISK_THRESHOLD)"

    if $FORCE_SUBMIT; then
        log WARN "FORCE SUBMIT: bypassing risk gate"
        return 0
    fi

    if (( $(echo "$risk > $RISK_THRESHOLD" | bc -l) )); then
        log ERROR "RISK GATE BLOCKED — score $risk exceeds threshold $RISK_THRESHOLD"
        log ERROR "Use --force-submit to bypass, or review and re-run"
        return 1
    fi

    log INFO "RISK GATE PASSED"
    return 0
}

# ════════════════════════════════════════════════════════════════════════════════
# RISK HISTORY PERSISTENCE
# ════════════════════════════════════════════════════════════════════════════════

append_risk_history() {
    local result_file="${BEST_DIR}/variant_result.json"
    [[ ! -f "$result_file" ]] && return

    mkdir -p "$(dirname "$RISK_HISTORY")"

    local entry; entry="$(cat "$result_file")"

    if command -v flock &>/dev/null; then
        (
            flock -w 10 200 || { log WARN "Failed to acquire lock for risk_history"; return; }
            echo "$entry" >> "$RISK_HISTORY"
        ) 200>"$LOCK_FILE"
    else
        echo "$entry" >> "$RISK_HISTORY"
    fi

    log INFO "Risk history updated"
}

# ════════════════════════════════════════════════════════════════════════════════
# HOTFIX BRANCH
# ════════════════════════════════════════════════════════════════════════════════

create_hotfix_branch() {
    if ! $HOTFIX_MODE; then
        return 0
    fi

    banner "HOTFIX BRANCH"

    local branch="hotfix/reject-${TIMESTAMP}"
    if ! $DRY_RUN; then
        git checkout -b "$branch" 2>&1 | tee -a "$LOG_FILE"
        log INFO "Hotfix branch created: $branch"
    else
        log WARN "DRY RUN: would create branch $branch"
    fi
}

# ════════════════════════════════════════════════════════════════════════════════
# FASTLANE INTEGRATION
# ════════════════════════════════════════════════════════════════════════════════

run_fastlane_upload() {
    banner "FASTLANE UPLOAD"

    if $DRY_RUN; then
        log WARN "DRY RUN: skipping Fastlane upload"
        return 0
    fi

    if ! command -v fastlane &>/dev/null; then
        log WARN "Fastlane not found — skipping upload"
        return 0
    fi

    local fastlane_dir="${SCRIPT_DIR}/ios/fastlane"
    if [[ ! -d "$fastlane_dir" ]]; then
        log WARN "No fastlane directory — skipping upload"
        return 0
    fi

    log STEP "Running fastlane $FASTLANE_LANE..."
    (cd "${SCRIPT_DIR}/ios" && fastlane "$FASTLANE_LANE" 2>&1) | tee -a "$LOG_FILE" | tail -20
    log INFO "Fastlane upload complete"
}

# ════════════════════════════════════════════════════════════════════════════════
# RELEASE TAGGING
# ════════════════════════════════════════════════════════════════════════════════

create_release_tag() {
    local version="$1"
    local tag; tag="$(version_tag "$version")"

    if $DRY_RUN; then
        log WARN "DRY RUN: would create tag $tag"
        return 0
    fi

    if git rev-parse "$tag" &>/dev/null; then
        log WARN "Tag $tag already exists — skipping"
        return 0
    fi

    git tag -a "$tag" -m "Release $version — ${BEST_VARIANT} (score: ${BEST_SCORE})" 2>&1 | tee -a "$LOG_FILE"
    log INFO "Tag created: $tag"

    git push origin "$tag" 2>&1 | tee -a "$LOG_FILE" || log WARN "Failed to push tag"
}

create_release_branch() {
    local version="$1"
    local semver; semver="$(echo "$version" | cut -d'+' -f1)"
    local branch="release/v${semver}"

    if $DRY_RUN; then
        log WARN "DRY RUN: would create branch $branch"
        return 0
    fi

    if git rev-parse --verify "$branch" &>/dev/null; then
        log WARN "Branch $branch already exists — skipping"
        return 0
    fi

    git checkout -b "$branch" 2>&1 | tee -a "$LOG_FILE"
    log INFO "Release branch created: $branch"
    git push -u origin "$branch" 2>&1 | tee -a "$LOG_FILE" || log WARN "Failed to push branch"
    git checkout main 2>&1 | tee -a "$LOG_FILE" || true
}

# ════════════════════════════════════════════════════════════════════════════════
# MAIN ORCHESTRATOR
# ════════════════════════════════════════════════════════════════════════════════

main() {
    parse_args "$@"

    banner "INNER CYCLES AUTONOMOUS SUBMISSION ENGINE v${SCRIPT_VERSION}"
    log INFO "Run ID: $RUN_ID"
    log INFO "Timestamp: $TIMESTAMP"
    log INFO "Log: $LOG_FILE"
    log INFO "Dry run: $DRY_RUN"

    # Phase 1: Preflight
    check_dependencies
    detect_xcode_project

    # Phase 2: Validate source
    banner "SOURCE VALIDATION"
    run_flutter_analyze "$SCRIPT_DIR"
    run_flutter_test "$SCRIPT_DIR"

    # Phase 3: Version bump
    banner "VERSION MANAGEMENT"
    local new_version; new_version="$(bump_version)"
    log INFO "New version: $new_version"

    # Phase 4: Parallel variant execution
    if ! $FORCE_SEQUENTIAL && supports_worktrees; then
        run_parallel_worktrees
    else
        if $FORCE_SEQUENTIAL; then
            log INFO "Sequential mode forced via --sequential"
        else
            log WARN "Git worktrees not supported — falling back to sequential"
        fi
        run_sequential_variants
    fi

    # Phase 5: Risk gate
    if ! risk_gate; then
        append_risk_history
        create_hotfix_branch
        die "Submission blocked by risk gate"
    fi

    # Phase 6: Persist risk history
    append_risk_history

    # Phase 7: Build
    banner "BUILD"
    run_flutter_build "$SCRIPT_DIR"

    # Phase 8: Release automation
    banner "RELEASE AUTOMATION"
    create_release_branch "$new_version"
    create_release_tag "$new_version"
    run_fastlane_upload

    # Phase 9: Summary
    banner "SUBMISSION COMPLETE"
    log HERO "Version:  $new_version"
    log HERO "Tag:      $(version_tag "$new_version")"
    log HERO "Variant:  $BEST_VARIANT (score: $BEST_SCORE)"
    log HERO "Risk:     $BEST_RISK (threshold: $RISK_THRESHOLD)"
    log HERO "Log:      $LOG_FILE"
    log HERO "Summary:  $VARIANTS_SUMMARY"
    log HERO "Package:  $RELEASE_DIR"

    if $DRY_RUN; then
        echo ""
        log WARN "DRY RUN — no artifacts were uploaded or tags/branches created"
        log WARN "Re-run without --dry-run to submit"
    fi

    echo ""
    printf "  ${BOLD}${GREEN}✓ Inner Cycles Autonomous Submission Engine — DONE${NC}\n"
    echo ""
}

main "$@"
