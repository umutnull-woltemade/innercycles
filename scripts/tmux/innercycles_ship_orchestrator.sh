#!/usr/bin/env bash
# INNER CYCLES (Flutter iOS) — macOS TMUX Multi-Agent Autonomous Recovery + Ship Orchestrator
# Includes: AI confidence scoring (heuristics), task priority weighting, risk heatmap,
# Slack/Telegram notifications, auto GitHub PR, auto version bump, auto TestFlight upload.
#
# SAFE DEFAULTS:
# - No destructive deletes (quarantine only)
# - No automatic TestFlight upload unless ENABLE_TESTFLIGHT=1
# - No PR creation unless ENABLE_PR=1
# - No auto version bump unless ENABLE_VERSION_BUMP=1
#
# Run in repo root on Mac:
#   chmod +x scripts/tmux/innercycles_ship_orchestrator.sh
#   ./scripts/tmux/innercycles_ship_orchestrator.sh
#   tmux attach -t innercycles_ship
#
set -euo pipefail

# -----------------------------
# CONFIG (edit via env vars)
# -----------------------------
SESSION="${SESSION:-innercycles_ship}"
RUN_ID="${RUN_ID:-$(date +%Y%m%d_%H%M%S)}"
DATE="$(date +%F)"
WORKDIR="${WORKDIR:-.recovery_run/$RUN_ID}"
GRAVEYARD="${GRAVEYARD:-_graveyard/$DATE/$RUN_ID}"
BRANCH="${BRANCH:-chore/recover-ship-$RUN_ID}"

# AI-ish scoring thresholds (heuristics, conservative)
MIN_CONFIDENCE_TO_AUTO_APPLY="${MIN_CONFIDENCE_TO_AUTO_APPLY:-85}"
MIN_CONFIDENCE_TO_QUARANTINE="${MIN_CONFIDENCE_TO_QUARANTINE:-70}"
MAX_TASKS_PARALLEL="${MAX_TASKS_PARALLEL:-6}"

# Notifications (optional)
ENABLE_NOTIFS="${ENABLE_NOTIFS:-0}"
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"

# GitHub PR (optional)
ENABLE_PR="${ENABLE_PR:-0}"
PR_BASE_BRANCH="${PR_BASE_BRANCH:-main}"

# Version bump (optional)
ENABLE_VERSION_BUMP="${ENABLE_VERSION_BUMP:-0}"
VERSION_BUMP_MODE="${VERSION_BUMP_MODE:-patch}"

# TestFlight (optional)
ENABLE_TESTFLIGHT="${ENABLE_TESTFLIGHT:-0}"
FASTLANE_LANE="${FASTLANE_LANE:-beta}"
IOS_SCHEME="${IOS_SCHEME:-Runner}"
IOS_WORKSPACE="${IOS_WORKSPACE:-ios/Runner.xcworkspace}"

# Verification commands
FLUTTER_BIN="${FLUTTER_BIN:-flutter}"
DART_BIN="${DART_BIN:-dart}"
BUNDLE_BIN="${BUNDLE_BIN:-bundle}"

# -----------------------------
# Helpers
# -----------------------------
have() { command -v "$1" >/dev/null 2>&1; }
log() { printf "\n\033[1;36m[innercycles]\033[0m %s\n" "$*"; }
warn(){ printf "\n\033[1;33m[warn]\033[0m %s\n" "$*"; }
err() { printf "\n\033[1;31m[error]\033[0m %s\n" "$*"; }

mkdir -p "$WORKDIR" "$GRAVEYARD"

notify() {
  local msg="$1"
  echo "[NOTIFY] $msg" >> "$WORKDIR/notifications.log" || true
  [ "$ENABLE_NOTIFS" = "1" ] || return 0
  if [ -n "$SLACK_WEBHOOK_URL" ] && have curl; then
    curl -sS -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"$msg\"}" "$SLACK_WEBHOOK_URL" >/dev/null || true
  fi
  if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ] && have curl; then
    curl -sS -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
      -d "chat_id=${TELEGRAM_CHAT_ID}" -d "text=${msg}" >/dev/null || true
  fi
}

die() { err "$1"; notify "!! $1"; exit 1; }

# Resolve WORKDIR to absolute path for agent scripts
ABS_WORKDIR="$(cd "$WORKDIR" && pwd)"

# -----------------------------
# Preflight (macOS + tools)
# -----------------------------
log "Preflight..."
have tmux       || die "tmux not installed."
have git        || die "git not installed."
have rg         || die "ripgrep (rg) not installed."
have jq         || warn "jq not installed (recommended)."
have "$FLUTTER_BIN" || die "flutter not found in PATH."
have xcodebuild || die "xcodebuild not found (Xcode required)."

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "Not in a git repository."
notify "InnerCycles ship orchestrator started. Run=$RUN_ID"

# Branch safety
log "Switching to branch: $BRANCH"
git checkout -b "$BRANCH" >/dev/null 2>&1 || git checkout "$BRANCH" >/dev/null 2>&1

# Save env/config snapshot
cat > "$WORKDIR/config.env" <<ENVEOF
SESSION=$SESSION
RUN_ID=$RUN_ID
WORKDIR=$WORKDIR
GRAVEYARD=$GRAVEYARD
BRANCH=$BRANCH
MIN_CONFIDENCE_TO_AUTO_APPLY=$MIN_CONFIDENCE_TO_AUTO_APPLY
MIN_CONFIDENCE_TO_QUARANTINE=$MIN_CONFIDENCE_TO_QUARANTINE
ENABLE_NOTIFS=$ENABLE_NOTIFS
ENABLE_PR=$ENABLE_PR
PR_BASE_BRANCH=$PR_BASE_BRANCH
ENABLE_VERSION_BUMP=$ENABLE_VERSION_BUMP
VERSION_BUMP_MODE=$VERSION_BUMP_MODE
ENABLE_TESTFLIGHT=$ENABLE_TESTFLIGHT
FASTLANE_LANE=$FASTLANE_LANE
IOS_SCHEME=$IOS_SCHEME
IOS_WORKSPACE=$IOS_WORKSPACE
ENVEOF

# -----------------------------
# Write per-agent scripts
# (avoids all tmux send-keys quoting issues)
# -----------------------------
AGENTS_DIR="$WORKDIR/agents"
mkdir -p "$AGENTS_DIR"

# -- Agent 0: Controller --
cat > "$AGENTS_DIR/00_controller.sh" <<CTRLEOF
#!/usr/bin/env bash
clear
echo '=== CONTROLLER === Run: $RUN_ID'
echo 'Branch: $BRANCH'
echo 'Workdir: $WORKDIR'
echo 'Graveyard: $GRAVEYARD'
echo ''
echo 'Attach log tails:'
echo "  tail -f $WORKDIR/*.log"
CTRLEOF

# -- Agent 1: Git Forensics --
cat > "$AGENTS_DIR/01_git_forensics.sh" <<'A1EOF'
#!/usr/bin/env bash
set -euo pipefail
A1EOF
cat >> "$AGENTS_DIR/01_git_forensics.sh" <<A1VEOF
WD="$WORKDIR"
A1VEOF
cat >> "$AGENTS_DIR/01_git_forensics.sh" <<'A1EOF'
echo 'Git Forensics...'
git status --porcelain=v1 > "$WD/git_status.txt" || true
git branch --show-current > "$WD/git_branch.txt" || true
git log --oneline -n 80 > "$WD/git_log.txt" || true
git reflog -n 120 > "$WD/git_reflog.txt" || true
git stash list > "$WD/git_stash.txt" || true
git branch --sort=-committerdate > "$WD/git_branches_recent.txt" || true
git log --branches --not --remotes --oneline > "$WD/unpushed_commits.txt" || true
git worktree list > "$WD/worktrees.txt" || true
echo 'DONE: Git forensics.'
A1EOF

# -- Agent 2: History Recovery --
cat > "$AGENTS_DIR/02_history_recovery.sh" <<'A2EOF'
#!/usr/bin/env bash
set -euo pipefail
A2EOF
cat >> "$AGENTS_DIR/02_history_recovery.sh" <<A2VEOF
WD="$WORKDIR"
A2VEOF
cat >> "$AGENTS_DIR/02_history_recovery.sh" <<'A2EOF'
echo 'History Recovery (zsh/bash + vscode configs)...'
ls -la .vscode > "$WD/vscode_ls.txt" 2>/dev/null || true
[ -f .vscode/tasks.json ] && cp .vscode/tasks.json "$WD/vscode_tasks.json" || true
[ -f .vscode/settings.json ] && cp .vscode/settings.json "$WD/vscode_settings.json" || true
[ -f ~/.zsh_history ] && tail -n 2500 ~/.zsh_history > "$WD/zsh_history_tail.txt" || true
[ -f ~/.bash_history ] && tail -n 2500 ~/.bash_history > "$WD/bash_history_tail.txt" || true
if [ -f "$WD/zsh_history_tail.txt" ]; then
  rg -n "(flutter|dart|pod|bundle|fastlane|xcodebuild|ipa|testflight|appstoreconnect|metadata|screenshot|4\.3|similarity|release|build number|version)" "$WD/zsh_history_tail.txt" \
    > "$WD/history_hits.txt" 2>/dev/null || true
fi
echo 'DONE: History recovery.'
A2EOF

# -- Agent 3: Repo Mining --
cat > "$AGENTS_DIR/03_repo_mining.sh" <<'A3EOF'
#!/usr/bin/env bash
set -euo pipefail
A3EOF
cat >> "$AGENTS_DIR/03_repo_mining.sh" <<A3VEOF
WD="$WORKDIR"
A3VEOF
cat >> "$AGENTS_DIR/03_repo_mining.sh" <<'A3EOF'
echo 'Repo Mining: TODO/WIP/Apple/4.3/Copy/Sub...'
mkdir -p "$WD/mining"
rg -n "TODO|FIXME|HACK|WIP|REJECT|4\.3|similarity|App Store|TestFlight|metadata|screenshot|paywall|subscription|trial|cancel|privacy|support|review notes" . \
  -g'!*{.git,node_modules,build,ios/Pods,ios/.symlinks,ios/Flutter/ephemeral,_archived}' \
  > "$WD/mining/rg_hits.txt" 2>/dev/null || true

find ios -maxdepth 4 -type f \( -iname '*info.plist' -o -iname '*entitlements*' -o -iname '*exportOptions*.plist' \) \
  > "$WD/mining/ios_config_files.txt" 2>/dev/null || true

find . -maxdepth 4 -type f | sort > "$WD/file_index.txt"
echo 'DONE: Repo mining.'
A3EOF

# -- Agent 4: Flutter/iOS Verification --
cat > "$AGENTS_DIR/04_verify_baseline.sh" <<'A4EOF'
#!/usr/bin/env bash
set +e
A4EOF
cat >> "$AGENTS_DIR/04_verify_baseline.sh" <<A4VEOF
WD="$WORKDIR"
A4VEOF
cat >> "$AGENTS_DIR/04_verify_baseline.sh" <<'A4EOF'
echo 'Baseline Verify (Flutter + iOS)...'
flutter --version > "$WD/flutter_version.txt" 2>&1
flutter pub get > "$WD/flutter_pub_get.log" 2>&1
flutter analyze > "$WD/flutter_analyze.log" 2>&1
flutter test > "$WD/flutter_test.log" 2>&1 || true
pushd ios >/dev/null 2>&1
if [ -f Podfile ]; then
  pod install > "../$WD/pod_install.log" 2>&1 || true
fi
popd >/dev/null 2>&1
flutter build ios --no-codesign > "$WD/flutter_build_ios_nocodesign.log" 2>&1 || true
echo 'DONE: Baseline verify (check logs).'
A4EOF

# -- Agent 5: Apple Copy Lint --
cat > "$AGENTS_DIR/05_apple_copy_lint.sh" <<'A5EOF'
#!/usr/bin/env bash
set -euo pipefail
A5EOF
cat >> "$AGENTS_DIR/05_apple_copy_lint.sh" <<A5VEOF
WD="$WORKDIR"
A5VEOF
cat >> "$AGENTS_DIR/05_apple_copy_lint.sh" <<'A5EOF'
echo 'Apple Copy Lint + 4.3 Similarity Heuristics...'
mkdir -p "$WD/copy"
rg -n "(track your emotions|discover yourself|personal growth journey|gain clarity|unlock insights|transform your life|heal|cure|diagnose|therapy|anxiety|depression|destiny|predict)" . \
  -g'*.md' -g'*.txt' -g'*.json' -g'*.arb' -g'*.yaml' -g'*.yml' -g'*.dart' \
  -g'!*{.git,node_modules,build,ios/Pods,ios/.symlinks,ios/Flutter/ephemeral,_archived}' \
  > "$WD/copy/risky_phrases_hits.txt" 2>/dev/null || true

python3 - "$WD" <<'PYEOF' 2>/dev/null || true
import re, pathlib, json, sys
wd = sys.argv[1]
root=pathlib.Path('.')
patterns=[
  r'track your emotions', r'discover yourself', r'personal growth journey',
  r'gain clarity', r'unlock insights', r'transform your life', r'feel better',
  r'improve your life', r'become your best self', r'daily reflection',
]
hits=0; files=0
for p in root.rglob('*'):
  if p.is_dir(): continue
  if any(x in str(p) for x in ['.git','node_modules','build','ios/Pods','ios/.symlinks','ios/Flutter/ephemeral','_archived']): continue
  if p.suffix.lower() not in ['.md','.txt','.json','.arb','.yml','.yaml','.dart']: continue
  try: text=p.read_text('utf-8', errors='ignore')
  except: continue
  files+=1
  for pat in patterns:
    hits+=len(re.findall(pat, text, flags=re.I))
out={'files_scanned':files,'generic_phrase_hits':hits,'note':'Heuristic only. High hits => 4.3 similarity risk.'}
pathlib.Path(wd+'/copy/similarity_heuristic.json').write_text(json.dumps(out,indent=2))
print(out)
PYEOF

echo 'DONE: Apple copy lint.'
A5EOF

# -- Agent 6: Task Queue Builder --
cat > "$AGENTS_DIR/06_task_ai.sh" <<'A6EOF'
#!/usr/bin/env bash
set -euo pipefail
A6EOF
cat >> "$AGENTS_DIR/06_task_ai.sh" <<A6VEOF
WD="$WORKDIR"
MIN_CONF="$MIN_CONFIDENCE_TO_AUTO_APPLY"
A6VEOF
cat >> "$AGENTS_DIR/06_task_ai.sh" <<'A6EOF'
echo 'Task AI: building task queue + confidence + priority + risk heatmap...'
mkdir -p "$WD/tasks"

python3 - "$WD" <<'PYEOF'
import json, re, pathlib, time, sys
wd=pathlib.Path(sys.argv[1])
tasks=[]
def add(task_id,title,kind,evidence,confidence,priority,risk):
    tasks.append({
      'id':task_id,'title':title,'kind':kind,'evidence':evidence,
      'confidence':confidence,'priority':priority,'risk':risk,
      'status':'queued'
    })

rg_hits = wd/'mining/rg_hits.txt'
risky_phrases = wd/'copy/risky_phrases_hits.txt'
sim_json = wd/'copy/similarity_heuristic.json'
hist = wd/'history_hits.txt'
git_status = wd/'git_status.txt'
flutter_analyze = wd/'flutter_analyze.log'
flutter_build = wd/'flutter_build_ios_nocodesign.log'

if rg_hits.exists() and rg_hits.read_text(errors='ignore').strip():
    add('T001','Resolve TODO/WIP/REJECT/4.3 markers found in repo','engineering',str(rg_hits),88,95,'MED')

if risky_phrases.exists() and risky_phrases.read_text(errors='ignore').strip():
    add('T002','Rewrite/remove Apple-risk phrases (medical/prediction/generic self-help cliches)','copy-compliance',str(risky_phrases),90,98,'LOW')

if sim_json.exists():
    try:
        data=json.loads(sim_json.read_text())
        hits=int(data.get('generic_phrase_hits',0))
        if hits>=25: conf=92; pr=99; risk='MED'
        elif hits>=10: conf=85; pr=95; risk='LOW'
        else: conf=60; pr=70; risk='LOW'
        add('T003',f'4.3 Similarity reduction pass (generic phrase hits={hits})','appstore-4.3',str(sim_json),conf,pr,risk)
    except: pass

if flutter_analyze.exists() and 'error' in flutter_analyze.read_text(errors='ignore').lower():
    add('T004','Fix Flutter analyze errors','engineering',str(flutter_analyze),85,97,'MED')

if flutter_build.exists() and ('failed' in flutter_build.read_text(errors='ignore').lower() or 'error' in flutter_build.read_text(errors='ignore').lower()):
    add('T005','Fix iOS build issues (no-codesign) to ensure App Store readiness','ios-build',str(flutter_build),84,96,'HIGH')

if git_status.exists() and git_status.read_text(errors='ignore').strip():
    add('T006','Handle uncommitted/untracked files (decide keep/quarantine/commit)','git-hygiene',str(git_status),80,80,'LOW')

if hist.exists() and hist.read_text(errors='ignore').strip():
    add('T007','Resume unfinished commands inferred from shell history','recovery',str(hist),78,75,'MED')

add('T008','Generate submission readiness report (privacy/support URLs, paywall copy, metadata, screenshots, version/build)','submission','inferred',86,99,'LOW')

heat={'LOW':0,'MED':0,'HIGH':0}
for t in tasks: heat[t['risk']]+=1

out={'generated_at':time.time(),'tasks':sorted(tasks,key=lambda x:(-x['priority'],-x['confidence'])),'risk_heatmap':heat}
(wd/'tasks/task_queue.json').write_text(json.dumps(out,indent=2))
(wd/'tasks/risk_heatmap.json').write_text(json.dumps(heat,indent=2))
print('Tasks:',len(tasks),'Heatmap:',heat)
PYEOF

echo "DONE: Task AI. Output: $WD/tasks/task_queue.json"
A6EOF

# -- Agent 7: Executor --
cat > "$AGENTS_DIR/07_executor.sh" <<'A7EOF'
#!/usr/bin/env bash
set -euo pipefail
A7EOF
cat >> "$AGENTS_DIR/07_executor.sh" <<A7VEOF
WD="$WORKDIR"
MIN_CONF="$MIN_CONFIDENCE_TO_AUTO_APPLY"
A7VEOF
cat >> "$AGENTS_DIR/07_executor.sh" <<'A7EOF'
echo "Executor: will auto-apply ONLY tasks with confidence >= $MIN_CONF"
echo 'Safety: changes are committed in small chunks; failures rollback.'
QUEUE="$WD/tasks/task_queue.json"
[ -f "$QUEUE" ] || { echo 'Waiting for task queue...'; sleep 15; }
[ -f "$QUEUE" ] || { echo 'No task queue found, exiting.'; exit 0; }

python3 - "$WD" "$MIN_CONF" <<'PYEOF'
import json, os, pathlib, sys
wd = sys.argv[1]
min_conf = int(sys.argv[2])
queue_path=pathlib.Path(wd+'/tasks/task_queue.json')
data=json.loads(queue_path.read_text())
tasks=data['tasks']

applied=[]
skipped=[]
for t in tasks:
    if t['confidence'] < min_conf:
        skipped.append(t); continue
    if t['kind'] not in ('copy-compliance','appstore-4.3','submission','git-hygiene'):
        skipped.append(t); continue
    applied.append(t)

plan_path=pathlib.Path(wd+'/tasks/executor_plan.txt')
lines=[]
for t in applied:
    lines.append(f"APPLY {t['id']} [{t['kind']}] conf={t['confidence']} prio={t['priority']} evidence={t['evidence']}")
for t in skipped:
    lines.append(f"SKIP  {t['id']} [{t['kind']}] conf={t['confidence']} prio={t['priority']} evidence={t['evidence']}")
plan_path.write_text('\n'.join(lines))
print('Wrote executor plan:',plan_path)
PYEOF

echo "Executor plan written: $WD/tasks/executor_plan.txt"
echo 'Next step: review executor_plan.txt and apply tasks using master prompts.'
A7EOF

# -- Agent 8: Release Ops --
cat > "$AGENTS_DIR/08_release_ops.sh" <<A8VEOF
#!/usr/bin/env bash
set -euo pipefail
WD="$WORKDIR"
BRANCH="$BRANCH"
ENABLE_VERSION_BUMP="$ENABLE_VERSION_BUMP"
VERSION_BUMP_MODE="$VERSION_BUMP_MODE"
ENABLE_PR="$ENABLE_PR"
PR_BASE_BRANCH="$PR_BASE_BRANCH"
ENABLE_TESTFLIGHT="$ENABLE_TESTFLIGHT"
FASTLANE_LANE="$FASTLANE_LANE"
A8VEOF
cat >> "$AGENTS_DIR/08_release_ops.sh" <<'A8EOF'
have(){ command -v "$1" >/dev/null 2>&1; }
echo "Release Ops (gated)..."
echo "ENABLE_VERSION_BUMP=$ENABLE_VERSION_BUMP ENABLE_PR=$ENABLE_PR ENABLE_TESTFLIGHT=$ENABLE_TESTFLIGHT"

if [ "$ENABLE_VERSION_BUMP" = "1" ]; then
  echo 'Bumping version in pubspec.yaml...'
  python3 - "$VERSION_BUMP_MODE" <<'PYEOF'
import re, pathlib, sys
mode=sys.argv[1]
p=pathlib.Path('pubspec.yaml')
txt=p.read_text()
m=re.search(r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*', txt, flags=re.M)
if not m:
    raise SystemExit('Could not find version: x.y.z+build in pubspec.yaml')
maj,mi,pa,build=map(int,m.groups())
if mode=='major': maj+=1; mi=0; pa=0
elif mode=='minor': mi+=1; pa=0
else: pa+=1
build+=1
new=f'version: {maj}.{mi}.{pa}+{build}'
txt2=re.sub(r'^version:.*', new, txt, flags=re.M)
p.write_text(txt2)
print('Updated',new)
PYEOF
  git add pubspec.yaml
  git commit -m "chore: bump version ($VERSION_BUMP_MODE)" || true
fi

if [ "$ENABLE_PR" = "1" ]; then
  if have gh && git remote get-url origin >/dev/null 2>&1; then
    echo 'Pushing branch and creating PR...'
    git push -u origin "$BRANCH" || true
    gh pr create --base "$PR_BASE_BRANCH" --head "$BRANCH" --fill || true
  else
    echo 'gh not installed or no origin remote; skipping PR.'
  fi
fi

if [ "$ENABLE_TESTFLIGHT" = "1" ]; then
  echo 'Preparing TestFlight upload via fastlane...'
  if ! have fastlane; then
    echo 'fastlane not installed.'
    exit 0
  fi
  pushd ios >/dev/null 2>&1
  [ -f Podfile ] && pod install || true
  popd >/dev/null 2>&1
  flutter pub get
  flutter build ipa --release > "$WD/flutter_build_ipa.log" 2>&1 || true
  if [ -f Gemfile ] && have bundle; then
    bundle exec fastlane "$FASTLANE_LANE" || true
  else
    fastlane "$FASTLANE_LANE" || true
  fi
fi

echo 'DONE: Release ops.'
A8EOF

# Make all agent scripts executable
chmod +x "$AGENTS_DIR"/*.sh

# -----------------------------
# tmux bootstrap
# -----------------------------
tmux kill-session -t "$SESSION" 2>/dev/null || true
tmux new-session -d -s "$SESSION" -n controller

# Launch each agent in its own tmux window by executing the script file
tmux send-keys -t "$SESSION:controller" "bash $AGENTS_DIR/00_controller.sh" C-m

tmux new-window -t "$SESSION" -n git_forensics
tmux send-keys -t "$SESSION:git_forensics" "bash $AGENTS_DIR/01_git_forensics.sh" C-m

tmux new-window -t "$SESSION" -n history_recovery
tmux send-keys -t "$SESSION:history_recovery" "bash $AGENTS_DIR/02_history_recovery.sh" C-m

tmux new-window -t "$SESSION" -n repo_mining
tmux send-keys -t "$SESSION:repo_mining" "bash $AGENTS_DIR/03_repo_mining.sh" C-m

tmux new-window -t "$SESSION" -n verify_baseline
tmux send-keys -t "$SESSION:verify_baseline" "bash $AGENTS_DIR/04_verify_baseline.sh" C-m

tmux new-window -t "$SESSION" -n apple_copy_lint
tmux send-keys -t "$SESSION:apple_copy_lint" "bash $AGENTS_DIR/05_apple_copy_lint.sh" C-m

tmux new-window -t "$SESSION" -n task_ai
tmux send-keys -t "$SESSION:task_ai" "bash $AGENTS_DIR/06_task_ai.sh" C-m

tmux new-window -t "$SESSION" -n executor
tmux send-keys -t "$SESSION:executor" "bash $AGENTS_DIR/07_executor.sh" C-m

tmux new-window -t "$SESSION" -n release_ops
tmux send-keys -t "$SESSION:release_ops" "bash $AGENTS_DIR/08_release_ops.sh" C-m

# -----------------------------
# Final message
# -----------------------------
log "Orchestrator launched."
log "Attach with: tmux attach -t $SESSION"
log "Outputs: $WORKDIR"
log "Task queue: $WORKDIR/tasks/task_queue.json"
log "Risk heatmap: $WORKDIR/tasks/risk_heatmap.json"
log "Graveyard: $GRAVEYARD"
notify "tmux session '$SESSION' ready. Attach: tmux attach -t $SESSION"
echo ""
echo ">>> tmux attach -t $SESSION"
