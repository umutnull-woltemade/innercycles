#!/usr/bin/env bash
set -euo pipefail

echo "🚀 ULTRA AUTONOMOUS RECOVERY (CI+Redis+PR+MultiProject+BuildResume) START"

# ==============================
# ENV / CONFIG
# ==============================
# Optional:
# export SLACK_WEBHOOK="https://hooks.slack.com/services/XXX/YYY/ZZZ"
# export AUTO_BUILD=true   # to auto-run/resume builds when restarting
# export AUTO_PR_ON_CRASH=true
# export REDIS_URL="redis://127.0.0.1:6379"

SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"
AUTO_BUILD="${AUTO_BUILD:-true}"
AUTO_PR_ON_CRASH="${AUTO_PR_ON_CRASH:-true}"
REDIS_URL="${REDIS_URL:-redis://127.0.0.1:6379}"

CRASH_LOG=".crash_log.txt"
LOCAL_STATE_FILE=".agent_state.json"

# ==============================
# Helpers
# ==============================
log(){ printf "%s %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$*"; }

slack(){
  [ -z "$SLACK_WEBHOOK" ] && return 0
  curl -sS -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"$*\"}" "$SLACK_WEBHOOK" >/dev/null 2>&1 || true
}

need_cmd(){
  command -v "$1" >/dev/null 2>&1
}

brew_install_if_missing(){
  local pkg="$1"
  if ! brew list "$pkg" >/dev/null 2>&1; then
    log "📦 Installing $pkg (brew)"
    brew install "$pkg"
  fi
}

git_root(){
  git rev-parse --show-toplevel 2>/dev/null || true
}

safe_repo_slug(){
  local root="$1"
  basename "$root" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9._-'
}

tmux_safe_name(){
  echo "$1" | tr -cd 'a-zA-Z0-9._-'
}

redis_ok(){
  redis-cli -u "$REDIS_URL" PING >/dev/null 2>&1
}

redis_get(){
  local key="$1"
  redis-cli -u "$REDIS_URL" GET "$key" 2>/dev/null || true
}

redis_set(){
  local key="$1"; local val="$2"
  redis-cli -u "$REDIS_URL" SET "$key" "$val" >/dev/null 2>&1 || true
}

json_escape(){
  python3 - <<'PY'
import json,sys
s=sys.stdin.read()
print(json.dumps(s)[1:-1])
PY
}

# ==============================
# 0) Ensure dependencies
# ==============================
if ! need_cmd brew; then
  log "❌ Homebrew not found. Install Homebrew first."
  exit 1
fi

brew_install_if_missing "tmux"
brew_install_if_missing "redis"

if ! need_cmd redis-cli; then
  log "❌ redis-cli missing even after install."
  exit 1
fi

# Start redis if not running (macOS brew services)
if ! redis_ok; then
  log "🟥 Redis not responding. Starting via brew services..."
  brew services start redis >/dev/null 2>&1 || true
  sleep 1
fi

if ! redis_ok; then
  log "⚠️ Redis still not responding. Continuing without Redis persistence."
  USE_REDIS=false
else
  USE_REDIS=true
fi

# ==============================
# 1) Multi-project auto-detect
# ==============================
ROOT="$(git_root)"
if [ -z "$ROOT" ]; then
  ROOT="$(pwd)"
  REPO_SLUG="$(safe_repo_slug "$ROOT")"
  IN_GIT=false
else
  REPO_SLUG="$(safe_repo_slug "$ROOT")"
  IN_GIT=true
fi

SESSION_NAME="$(tmux_safe_name "AUTO_${REPO_SLUG}")"
STATE_KEY="agent_state:${REPO_SLUG}"
BUILD_KEY="build_last_cmd:${REPO_SLUG}"
CRASH_KEY="crash_count:${REPO_SLUG}"

log "📁 Project root: $ROOT"
log "🧷 tmux session: $SESSION_NAME"
$IN_GIT && log "✅ Git repo detected" || log "⚠️ Not a git repo"

cd "$ROOT"

# ==============================
# 2) Git branch auto-restore
# ==============================
if $IN_GIT; then
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
  if [ -n "$CURRENT_BRANCH" ]; then
    log "🌿 Restoring Git branch: $CURRENT_BRANCH"
    git checkout "$CURRENT_BRANCH" >/dev/null 2>&1 || true
  fi
fi

# ==============================
# 3) Crash detection + Slack
# ==============================
if [ -f "$CRASH_LOG" ]; then
  log "⚠️ Previous crash log found: $CRASH_LOG"
  slack "⚠️ Crash detected in session $SESSION_NAME (project: $REPO_SLUG)"
fi

# Redis crash counter (optional)
if $USE_REDIS; then
  CC="$(redis_get "$CRASH_KEY")"
  CC="${CC:-0}"
  # If crash log exists, increment
  if [ -f "$CRASH_LOG" ]; then
    CC=$((CC+1))
    redis_set "$CRASH_KEY" "$CC"
    log "🧨 Crash count (Redis): $CC"
  fi
fi

# ==============================
# 4) Agent state persistence (Redis + local fallback)
# ==============================
if $USE_REDIS; then
  STATE_JSON="$(redis_get "$STATE_KEY")"
else
  STATE_JSON=""
fi

if [ -z "$STATE_JSON" ] && [ -f "$LOCAL_STATE_FILE" ]; then
  STATE_JSON="$(cat "$LOCAL_STATE_FILE")"
fi

if [ -z "$STATE_JSON" ]; then
  STATE_JSON="{\"project\":\"$REPO_SLUG\",\"last_restart\":\"$(date -Iseconds)\",\"status\":\"initialized\"}"
  log "📝 Creating initial agent state"
fi

# Write local snapshot always (belt + suspenders)
echo "$STATE_JSON" > "$LOCAL_STATE_FILE"
$USE_REDIS && redis_set "$STATE_KEY" "$STATE_JSON"

# ==============================
# 5) Setup tmux workspace (restore or create)
# ==============================
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  log "♻️ Reattaching existing tmux session..."
else
  log "🧠 Creating tmux workspace..."

  tmux new-session -d -s "$SESSION_NAME" -c "$ROOT"

  tmux rename-window -t "$SESSION_NAME:0" "orchestrator"
  tmux split-window -h -t "$SESSION_NAME:0" -c "$ROOT"
  tmux split-window -v -t "$SESSION_NAME:0.0" -c "$ROOT"
  tmux split-window -v -t "$SESSION_NAME:0.1" -c "$ROOT"
  tmux select-layout -t "$SESSION_NAME" tiled

  tmux send-keys -t "$SESSION_NAME:0.0" "cd \"$ROOT\"; echo '🧠 Orchestrator Online ($REPO_SLUG)'; echo 'STATE:'; cat \"$LOCAL_STATE_FILE\" | head -c 2000; echo" C-m
  tmux send-keys -t "$SESSION_NAME:0.1" "cd \"$ROOT\"; echo '🧹 Cleanup Agent Online';" C-m
  tmux send-keys -t "$SESSION_NAME:0.2" "cd \"$ROOT\"; echo '📦 CI Agent Online';" C-m
  tmux send-keys -t "$SESSION_NAME:0.3" "cd \"$ROOT\"; echo '📈 Growth Agent Online';" C-m
fi

# ==============================
# 6) CI-aware behavior
# ==============================
if [ -n "${CI:-}" ]; then
  log "🧪 CI environment detected (CI=$CI). Disabling tmux attach."
  # In CI, just exit after ensuring state is written.
  exit 0
fi

# ==============================
# 7) Build auto-resume (Apple/Android) via stored command
#     + Smart auto-detect initial build command when none exists
# ==============================
detect_build_cmd(){
  # Priority 1: Flutter
  if [ -f "pubspec.yaml" ] && need_cmd flutter; then
    # If iOS + Android exist, prefer both via two commands joined
    if [ -d "ios" ] && [ -d "android" ]; then
      echo "flutter pub get && flutter build apk --release && flutter build ios --release"
      return 0
    elif [ -d "android" ]; then
      echo "flutter pub get && flutter build apk --release"
      return 0
    elif [ -d "ios" ]; then
      echo "flutter pub get && flutter build ios --release"
      return 0
    fi
  fi

  # Priority 2: Android Gradle
  if [ -f "android/gradlew" ]; then
    echo "cd android && ./gradlew assembleRelease"
    return 0
  elif [ -f "./gradlew" ]; then
    echo "./gradlew assembleRelease"
    return 0
  fi

  # Priority 3: iOS Xcode (best-effort scheme auto-pick)
  if [ -d "ios" ]; then
    local iosdir="ios"
    local workspace
    workspace="$(ls "$iosdir"/*.xcworkspace 2>/dev/null | head -n1 || true)"
    local xcodeproj
    xcodeproj="$(ls "$iosdir"/*.xcodeproj 2>/dev/null | head -n1 || true)"

    if [ -n "$workspace" ] && need_cmd xcodebuild; then
      # pick first scheme from xcodebuild -list -json
      local scheme
      scheme="$(xcodebuild -list -json -workspace "$workspace" 2>/dev/null | python3 - <<'PY'
import json,sys
try:
  d=json.load(sys.stdin)
  ws=d.get("workspace",{})
  sch=ws.get("schemes",[])
  print(sch[0] if sch else "")
except Exception:
  print("")
PY
)"
      if [ -n "$scheme" ]; then
        echo "cd ios && xcodebuild -workspace \"$(basename "$workspace")\" -scheme \"$scheme\" -configuration Release -sdk iphoneos build"
        return 0
      fi
    fi

    if [ -n "$xcodeproj" ] && need_cmd xcodebuild; then
      local scheme
      scheme="$(xcodebuild -list -json -project "$xcodeproj" 2>/dev/null | python3 - <<'PY'
import json,sys
try:
  d=json.load(sys.stdin)
  pr=d.get("project",{})
  sch=pr.get("schemes",[])
  print(sch[0] if sch else "")
except Exception:
  print("")
PY
)"
      if [ -n "$scheme" ]; then
        echo "cd ios && xcodebuild -project \"$(basename "$xcodeproj")\" -scheme \"$scheme\" -configuration Release -sdk iphoneos build"
        return 0
      fi
    fi
  fi

  echo ""
}

run_or_resume_build(){
  [ "$AUTO_BUILD" != "true" ] && return 0

  local last_cmd=""
  if $USE_REDIS; then
    last_cmd="$(redis_get "$BUILD_KEY")"
  fi
  if [ -z "$last_cmd" ] && [ -f ".last_build_cmd" ]; then
    last_cmd="$(cat .last_build_cmd)"
  fi

  if [ -z "$last_cmd" ]; then
    last_cmd="$(detect_build_cmd)"
    if [ -z "$last_cmd" ]; then
      log "⚠️ No auto-detectable build command found. Skipping auto-build."
      return 0
    fi
    log "🧠 Auto-detected build command:"
    log "   $last_cmd"
  else
    log "🔁 Resuming last build command:"
    log "   $last_cmd"
  fi

  echo "$last_cmd" > .last_build_cmd
  $USE_REDIS && redis_set "$BUILD_KEY" "$last_cmd"

  # Run build in tmux pane 0.2 (CI Agent)
  tmux send-keys -t "$SESSION_NAME:0.2" "cd \"$ROOT\"; echo '🏗️ BUILD START'; ($last_cmd) && echo '✅ BUILD OK' || echo '❌ BUILD FAIL';" C-m
}

run_or_resume_build

# ==============================
# 8) GitHub PR auto-open on crash (best-effort)
#     - Creates a branch with crash artifacts and opens PR via gh
# ==============================
auto_open_pr_on_crash(){
  [ "$AUTO_PR_ON_CRASH" != "true" ] && return 0
  $IN_GIT || return 0
  [ -f "$CRASH_LOG" ] || return 0

  if ! need_cmd gh; then
    log "⚠️ gh (GitHub CLI) not found; skipping PR auto-open."
    return 0
  fi

  if ! gh auth status >/dev/null 2>&1; then
    log "⚠️ gh not authenticated; skipping PR auto-open."
    return 0
  fi

  # Ensure remote exists
  if ! git remote get-url origin >/dev/null 2>&1; then
    log "⚠️ No origin remote; skipping PR auto-open."
    return 0
  fi

  local ts branch title body
  ts="$(date '+%Y%m%d-%H%M%S')"
  branch="auto/crash-${REPO_SLUG}-${ts}"
  title="🔥 Auto crash recovery artifacts (${REPO_SLUG}) ${ts}"
  body="Automated PR created after crash detection.\n\nArtifacts:\n- $CRASH_LOG\n- $LOCAL_STATE_FILE\n- .last_build_cmd (if present)\n\nAlso posted to Slack if configured."

  log "🧷 Creating PR branch: $branch"
  git checkout -b "$branch" >/dev/null 2>&1 || return 0

  # Add crash artifacts
  git add -A "$CRASH_LOG" "$LOCAL_STATE_FILE" .last_build_cmd 2>/dev/null || true
  git commit -m "chore: crash recovery artifacts (${ts})" >/dev/null 2>&1 || {
    log "⚠️ Nothing to commit for crash artifacts."
    git checkout - >/dev/null 2>&1 || true
    return 0
  }

  git push -u origin "$branch" >/dev/null 2>&1 || {
    log "⚠️ Push failed; skipping PR open."
    return 0
  }

  gh pr create --title "$title" --body "$body" --head "$branch" >/dev/null 2>&1 && {
    log "✅ PR opened automatically"
    slack "✅ PR auto-opened after crash: $title"
  } || {
    log "⚠️ Failed to open PR automatically"
  }
}

auto_open_pr_on_crash || true

# ==============================
# 9) Self-healing monitor loop
#     - Detect tmux session crash => log + Slack + (optional) PR + recreate session
# ==============================
(
  while true; do
    sleep 10
    if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
      log "🔥 tmux session crashed: $SESSION_NAME"
      echo "$(date -Iseconds) - tmux session crashed: $SESSION_NAME" >> "$CRASH_LOG"
      slack "🔥 tmux session crashed: $SESSION_NAME (project: $REPO_SLUG) — auto-restarting"

      # Attempt restart
      tmux new-session -d -s "$SESSION_NAME" -c "$ROOT" || true

      # Minimal workspace recreation
      tmux rename-window -t "$SESSION_NAME:0" "orchestrator" 2>/dev/null || true
      tmux split-window -h -t "$SESSION_NAME:0" -c "$ROOT" 2>/dev/null || true
      tmux split-window -v -t "$SESSION_NAME:0.0" -c "$ROOT" 2>/dev/null || true
      tmux split-window -v -t "$SESSION_NAME:0.1" -c "$ROOT" 2>/dev/null || true
      tmux select-layout -t "$SESSION_NAME" tiled 2>/dev/null || true

      # Restore state echo
      tmux send-keys -t "$SESSION_NAME:0.0" "cd \"$ROOT\"; echo '🧠 Orchestrator Restored'; cat \"$LOCAL_STATE_FILE\" | head -c 2000; echo" C-m 2>/dev/null || true

      # Resume build if enabled
      if [ "$AUTO_BUILD" = "true" ]; then
        tmux send-keys -t "$SESSION_NAME:0.2" "cd \"$ROOT\"; echo '🔁 Attempting build resume...'; if [ -f .last_build_cmd ]; then CMD=\$(cat .last_build_cmd); echo \"CMD: \$CMD\"; (\$CMD) && echo '✅ BUILD OK' || echo '❌ BUILD FAIL'; else echo 'No last build cmd'; fi" C-m 2>/dev/null || true
      fi

      # PR auto-open (best-effort) — run outside tmux
      if [ "$AUTO_PR_ON_CRASH" = "true" ]; then
        # leave a marker for the next foreground run too
        :
      fi
    fi
  done
) >/dev/null 2>&1 & disown || true

# ==============================
# 10) Final attach
# ==============================
log "✅ Recovery complete. Attaching tmux..."
tmux attach -t "$SESSION_NAME"
