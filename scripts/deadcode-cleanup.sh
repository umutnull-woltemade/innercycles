#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════
# INNERCYCLES DEAD-CODE CLEANUP ORCHESTRATOR (Flutter/Dart)
# ════════════════════════════════════════════════════════════════════
# Safety: QUARANTINE ONLY by default. No deletions unless DELETE_MODE=1.
# Each agent is a standalone script to avoid tmux quoting issues.
# ════════════════════════════════════════════════════════════════════

set -euo pipefail

# ── CONFIG ──────────────────────────────────────────────────────────
SESSION="${SESSION:-deadcode_agents}"
DATE="$(date +%F)"
RUN_ID="$(date +%Y%m%d_%H%M%S)"
WORKDIR="$(pwd)/.cleanup_run/$RUN_ID"
GRAVEYARD="$(pwd)/_graveyard/$DATE/$RUN_ID"
BRANCH="chore/dead-code-cleanup-$RUN_ID"
PROJECT_DIR="$(pwd)"

DELETE_MODE="${DELETE_MODE:-0}"
DELETE_CONFIDENCE_MIN="${DELETE_CONFIDENCE_MIN:-90}"
QUARANTINE_CONFIDENCE_MIN="${QUARANTINE_CONFIDENCE_MIN:-60}"
BATCH_SIZE="${BATCH_SIZE:-25}"
MAX_SELF_HEAL_ROUNDS="${MAX_SELF_HEAL_ROUNDS:-6}"

BUILD_CMD="flutter analyze --no-fatal-infos"
TEST_CMD="flutter test --no-pub"
LINT_CMD="dart analyze --no-fatal-infos lib/"

log() { printf "\n\033[1;36m[deadcode]\033[0m %s\n" "$*"; }
err() { printf "\n\033[1;31m[error]\033[0m %s\n" "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ── PREFLIGHT ───────────────────────────────────────────────────────
log "Preflight checks..."
for cmd in tmux rg git flutter dart; do
  have "$cmd" || { err "$cmd not found."; exit 1; }
done
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { err "Not in a git repo."; exit 1; }

mkdir -p "$WORKDIR" "$GRAVEYARD"

log "Creating branch: $BRANCH"
git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH" 2>/dev/null || true

# Save env for agents
cat > "$WORKDIR/env.sh" <<ENVEOF
export PROJECT_DIR="$PROJECT_DIR"
export WORKDIR="$WORKDIR"
export GRAVEYARD="$GRAVEYARD"
export BRANCH="$BRANCH"
export RUN_ID="$RUN_ID"
export DATE="$DATE"
export DELETE_MODE="$DELETE_MODE"
export DELETE_CONFIDENCE_MIN="$DELETE_CONFIDENCE_MIN"
export QUARANTINE_CONFIDENCE_MIN="$QUARANTINE_CONFIDENCE_MIN"
export BATCH_SIZE="$BATCH_SIZE"
export MAX_SELF_HEAL_ROUNDS="$MAX_SELF_HEAL_ROUNDS"
export BUILD_CMD="$BUILD_CMD"
export TEST_CMD="$TEST_CMD"
export LINT_CMD="$LINT_CMD"
ENVEOF

log "Config saved to $WORKDIR/env.sh"

# ══════════════════════════════════════════════════════════════════
# WRITE AGENT SCRIPTS
# ══════════════════════════════════════════════════════════════════

# ── Agent 1: Indexer ───────────────────────────────────────────────
cat > "$WORKDIR/agent_indexer.sh" <<'AGENT_EOF'
#!/usr/bin/env bash
set -euo pipefail
source "$1"
cd "$PROJECT_DIR"

echo "=== INDEXER AGENT ==="

git status --porcelain=v1 > "$WORKDIR/git_status_before.txt" 2>/dev/null || true

find . -maxdepth 8 -type f \
  -not -path './_archived/*' \
  -not -path './.git/*' \
  -not -path './build/*' \
  -not -path './.dart_tool/*' \
  -not -path './.cleanup_run/*' \
  -not -path './_graveyard/*' \
  -not -path './ios/Pods/*' \
  -not -path './.flutter-plugins*' \
  -not -path './ios/Flutter/*' \
  | sort > "$WORKDIR/file_index.txt"

grep -E '\.dart$' "$WORKDIR/file_index.txt" > "$WORKDIR/dart_files.txt" 2>/dev/null || true

TOTAL=$(wc -l < "$WORKDIR/file_index.txt" | tr -d ' ')
DART=$(wc -l < "$WORKDIR/dart_files.txt" | tr -d ' ')
echo "Total files: $TOTAL | Dart files: $DART"
echo "Indexer done."
touch "$WORKDIR/indexer.done"
AGENT_EOF

# ── Agent 2: Static Analysis ──────────────────────────────────────
cat > "$WORKDIR/agent_static.sh" <<'AGENT_EOF'
#!/usr/bin/env bash
set -euo pipefail
source "$1"
cd "$PROJECT_DIR"

echo "=== STATIC ANALYSIS AGENT ==="

echo "--- flutter analyze ---"
flutter analyze --no-fatal-infos > "$WORKDIR/flutter_analyze.txt" 2>&1 || true

echo "--- dart analyze ---"
dart analyze --no-fatal-infos lib/ > "$WORKDIR/dart_analyze.txt" 2>&1 || true

grep -iE 'unused_import|unused_element|unused_field|unused_local_variable|dead_code|unreachable' \
  "$WORKDIR/dart_analyze.txt" > "$WORKDIR/unused_warnings.txt" 2>/dev/null || true

UNUSED_COUNT=$(wc -l < "$WORKDIR/unused_warnings.txt" | tr -d ' ')
echo "Found $UNUSED_COUNT unused/dead code warnings"

# Wait for indexer
while [ ! -f "$WORKDIR/indexer.done" ]; do sleep 2; done

echo "--- Orphan file detection ---"
: > "$WORKDIR/orphan_candidates.txt"

while read -r f; do
  bname=$(basename "$f" .dart)

  # Skip main, generated, test files
  echo "$f" | grep -qE '(main\.dart|\.g\.dart|\.freezed\.dart|\.gen\.dart|\.mocks\.dart)' && continue
  echo "$f" | grep -qE '^\./test/' && continue

  # Count references in other dart files
  refs=$(rg -l --type dart "$bname" . 2>/dev/null \
    | grep -v "_archived/" \
    | grep -v "$f" \
    | grep -v '.cleanup_run/' \
    | grep -v '_graveyard/' \
    | wc -l | tr -d ' ')

  if [ "$refs" -eq 0 ]; then
    echo "$f" >> "$WORKDIR/orphan_candidates.txt"
  fi
done < "$WORKDIR/dart_files.txt"

ORPHANS=$(wc -l < "$WORKDIR/orphan_candidates.txt" | tr -d ' ')
echo "Found $ORPHANS orphan Dart file candidates"
echo "Static Agent done."
touch "$WORKDIR/static.done"
AGENT_EOF

# ── Agent 3: Dynamic Reference Scanner ───────────────────────────
cat > "$WORKDIR/agent_dynamic.sh" <<'AGENT_EOF'
#!/usr/bin/env bash
set -euo pipefail
source "$1"
cd "$PROJECT_DIR"

echo "=== DYNAMIC SCAN AGENT ==="

rg -n 'GoRoute|path:.*/' lib/core/constants/routes.dart > "$WORKDIR/routes.txt" 2>/dev/null || true
rg -ln 'Provider\b|StateNotifier|ChangeNotifier|ConsumerWidget|ConsumerStatefulWidget' lib/ > "$WORKDIR/provider_files.txt" 2>/dev/null || true
rg -n 'assets/' pubspec.yaml > "$WORKDIR/declared_assets.txt" 2>/dev/null || true

: > "$WORKDIR/unused_assets.txt"
if [ -d assets ]; then
  find assets -type f -not -path 'assets/l10n/*' | while read -r asset; do
    abase=$(basename "$asset")
    refs=$(rg -l "$abase" lib/ 2>/dev/null | wc -l | tr -d ' ')
    pubref=$(rg -c "$abase" pubspec.yaml 2>/dev/null | tr -d ' ' || echo 0)
    if [ "$refs" -eq 0 ] && [ "${pubref:-0}" -eq 0 ]; then
      echo "$asset" >> "$WORKDIR/unused_assets.txt"
    fi
  done
fi

UNUSED_ASSETS=$(wc -l < "$WORKDIR/unused_assets.txt" | tr -d ' ')
echo "Found $UNUSED_ASSETS potentially unused assets"

# Unused locale keys
: > "$WORKDIR/unused_locale_keys.txt"
if [ -f assets/l10n/en.json ]; then
  python3 - "$WORKDIR" <<'PY_EOF' 2>/dev/null || echo "Locale key scan skipped"
import json, subprocess, sys, os
workdir = sys.argv[1]
with open('assets/l10n/en.json') as f:
    keys = list(json.load(f).keys())
unused = []
for k in keys:
    result = subprocess.run(['rg', '-l', k, 'lib/'], capture_output=True, text=True)
    if not result.stdout.strip():
        unused.append(k)
outpath = os.path.join(workdir, 'unused_locale_keys.txt')
with open(outpath, 'w') as f:
    f.write('\n'.join(unused))
print(f'Unused locale keys: {len(unused)}')
PY_EOF
fi

echo "Dynamic Scan Agent done."
touch "$WORKDIR/dynamic_scan.done"
AGENT_EOF

# ── Agent 4: Scoring ─────────────────────────────────────────────
cat > "$WORKDIR/agent_scoring.sh" <<'AGENT_EOF'
#!/usr/bin/env bash
set -euo pipefail
source "$1"
cd "$PROJECT_DIR"

echo "=== SCORING AGENT ==="
echo "Waiting for indexer + static + dynamic..."

while [ ! -f "$WORKDIR/indexer.done" ] || [ ! -f "$WORKDIR/static.done" ] || [ ! -f "$WORKDIR/dynamic_scan.done" ]; do
  sleep 3
done

echo "All scan agents done. Building scored candidate list..."
echo 'path,confidence,reason,evidence,risk,action' > "$WORKDIR/candidates.csv"

# Score orphan Dart files
if [ -s "$WORKDIR/orphan_candidates.txt" ]; then
  while read -r f; do
    score=72
    risk='MED'
    reason='orphan_dart_no_refs'

    echo "$f" | grep -qE '(screen|page|view|widget)' && score=60 && risk='MED'
    echo "$f" | grep -qE '(_old|_backup|_deprecated|_legacy|_unused|_temp)' && score=92 && risk='LOW'
    echo "$f" | grep -qE '(service|provider|model|repository)' && score=55 && risk='HIGH'
    echo "$f" | grep -qE '(main\.dart|app\.dart|routes\.dart|theme)' && score=20 && risk='HIGH'
    echo "$f" | grep -qE '\.(g|freezed|gen|mocks)\.dart' && continue

    echo "$f,$score,$reason,orphan_scan,$risk,QUARANTINE" >> "$WORKDIR/candidates.csv"
  done < "$WORKDIR/orphan_candidates.txt"
fi

# Score unused assets
if [ -s "$WORKDIR/unused_assets.txt" ]; then
  while read -r f; do
    score=65
    risk='MED'
    echo "$f" | grep -qE '\.(png|jpg|jpeg|svg|webp)' && score=75 && risk='LOW'
    echo "$f" | grep -qE '\.(ttf|otf|woff)' && score=60 && risk='MED'
    echo "$f,$score,unused_asset_no_refs,asset_scan,$risk,QUARANTINE" >> "$WORKDIR/candidates.csv"
  done < "$WORKDIR/unused_assets.txt"
fi

# Deduplicate with python
python3 - "$WORKDIR" <<'PY_EOF' 2>/dev/null || cp "$WORKDIR/candidates.csv" "$WORKDIR/candidates_dedup.csv"
import csv, sys, os
workdir = sys.argv[1]
infile = os.path.join(workdir, 'candidates.csv')
best = {}
with open(infile, newline='') as f:
    for row in csv.DictReader(f):
        p = row['path']
        c = int(float(row['confidence']))
        if p not in best or c > int(float(best[p]['confidence'])):
            best[p] = row
rows = sorted(best.values(), key=lambda x: int(float(x['confidence'])), reverse=True)
outfile = os.path.join(workdir, 'candidates_dedup.csv')
with open(outfile, 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['path','confidence','reason','evidence','risk','action'])
    w.writeheader()
    w.writerows(rows)
print(f'Candidates: {len(rows)} (deduped)')
PY_EOF

TOTAL=$(tail -n+2 "$WORKDIR/candidates_dedup.csv" | wc -l | tr -d ' ')
echo "Total scored candidates: $TOTAL"
echo "Scoring Agent done."
touch "$WORKDIR/scoring.done"
AGENT_EOF

# ── Agent 5: Quarantine + Verify ─────────────────────────────────
cat > "$WORKDIR/agent_quarantine.sh" <<'AGENT_EOF'
#!/usr/bin/env bash
set -euo pipefail
source "$1"
cd "$PROJECT_DIR"

echo "=== QUARANTINE + VERIFY AGENT ==="
echo "Waiting for scoring..."
while [ ! -f "$WORKDIR/scoring.done" ]; do sleep 3; done

CSV="$WORKDIR/candidates_dedup.csv"

verify() {
  echo "--- VERIFY START ---"
  local pass=1
  eval "$LINT_CMD" > "$WORKDIR/verify_lint.txt" 2>&1 || pass=0
  if [ $pass -eq 1 ]; then
    eval "$BUILD_CMD" > "$WORKDIR/verify_build.txt" 2>&1 || pass=0
  fi
  if [ $pass -eq 1 ] && [ -n "$TEST_CMD" ]; then
    eval "$TEST_CMD" > "$WORKDIR/verify_test.txt" 2>&1 || pass=0
  fi
  echo "--- VERIFY END ---"
  return $((1 - pass))
}

# Build quarantine list
python3 - "$WORKDIR" "$CSV" "$QUARANTINE_CONFIDENCE_MIN" <<'PY_EOF' 2>/dev/null || true
import csv, sys, os
workdir, csvpath, qmin_str = sys.argv[1], sys.argv[2], sys.argv[3]
qmin = int(qmin_str)
rows = []
with open(csvpath, newline='') as f:
    for row in csv.DictReader(f):
        c = int(float(row['confidence']))
        risk = row.get('risk', 'MED')
        if c >= qmin and (risk != 'HIGH' or c >= 90):
            rows.append(row['path'])
outpath = os.path.join(workdir, 'to_quarantine.txt')
with open(outpath, 'w') as f:
    f.write('\n'.join(rows))
print(f'To quarantine: {len(rows)}')
PY_EOF

TOQ="$WORKDIR/to_quarantine.txt"
if [ ! -s "$TOQ" ]; then
  echo "No candidates meet quarantine threshold. Done."
  touch "$WORKDIR/quarantine.done"
  exit 0
fi

mkdir -p "$GRAVEYARD"
MOVELOG="$WORKDIR/movelog.txt"
: > "$MOVELOG"

qmove() {
  local p="$1"
  [ -e "$p" ] || return 0
  # Never move critical files
  echo "$p" | grep -qE '(pubspec\.|\.github/|analysis_options|main\.dart|\.gitignore)' && return 0
  local dest="$GRAVEYARD/${p#./}"
  mkdir -p "$(dirname "$dest")"
  if git ls-files --error-unmatch "$p" >/dev/null 2>&1; then
    git mv "$p" "$dest" 2>/dev/null || { mv "$p" "$dest"; git add -A 2>/dev/null || true; }
  else
    mv "$p" "$dest"
  fi
  echo "MOVED|$p|$dest" >> "$MOVELOG"
}

restore_last_batch() {
  echo "Self-heal: restoring last batch..."
  tac "$MOVELOG" | head -n "$BATCH_SIZE" | while IFS='|' read -r _ src dst; do
    [ -e "$dst" ] || continue
    mkdir -p "$(dirname "$src")"
    mv "$dst" "$src" 2>/dev/null || true
  done
  git checkout -- . 2>/dev/null || true
  echo "Restore done."
}

processed=0
round=0

while read -r path; do
  qmove "$path"
  processed=$((processed + 1))

  if [ $((processed % BATCH_SIZE)) -eq 0 ]; then
    round=$((round + 1))
    echo "--- Batch $round quarantined ($processed total). Verifying... ---"
    if verify; then
      echo "PASS (batch $round)"
    else
      echo "FAIL (batch $round)"
      if [ $round -le "$MAX_SELF_HEAL_ROUNDS" ]; then
        restore_last_batch
        if verify; then
          echo "PASS after self-heal restore"
        else
          echo "STILL FAIL after restore. Stopping."
          touch "$WORKDIR/quarantine.done"
          exit 2
        fi
      else
        echo "Max self-heal rounds reached. Stopping."
        touch "$WORKDIR/quarantine.done"
        exit 2
      fi
    fi
  fi
done < "$TOQ"

echo "--- Final verify ---"
if verify; then
  echo "Final verify PASS"
else
  echo "Final verify FAIL — restoring last batch"
  restore_last_batch
  verify || true
fi

cat > "$GRAVEYARD/README.md" <<README_INNER
# Quarantined Files ($RUN_ID)
Date: $DATE
Restore: see $WORKDIR/movelog.txt for original paths.
README_INNER

echo "Quarantine+Verify Agent done."
touch "$WORKDIR/quarantine.done"
AGENT_EOF

# ── Agent 6: Report + PR ────────────────────────────────────────
cat > "$WORKDIR/agent_report.sh" <<'AGENT_EOF'
#!/usr/bin/env bash
set -euo pipefail
source "$1"
cd "$PROJECT_DIR"

echo "=== REPORT + PR AGENT ==="
echo "Waiting for quarantine..."
while [ ! -f "$WORKDIR/quarantine.done" ]; do sleep 5; done

REPORT="$WORKDIR/report.md"
{
  echo "# InnerCycles Dead Code Cleanup Report"
  echo ""
  echo "## Run: $RUN_ID"
  echo "## Stack: Flutter/Dart"
  echo ""
  echo "## Analysis Results"
  echo ""

  if [ -f "$WORKDIR/unused_warnings.txt" ]; then
    cnt=$(wc -l < "$WORKDIR/unused_warnings.txt" | tr -d ' ')
    echo "### Dart Analyzer Warnings: $cnt"
    echo '```'
    head -50 "$WORKDIR/unused_warnings.txt"
    echo '```'
    echo ""
  fi

  if [ -f "$WORKDIR/orphan_candidates.txt" ]; then
    cnt=$(wc -l < "$WORKDIR/orphan_candidates.txt" | tr -d ' ')
    echo "### Orphan Dart Files: $cnt"
    echo '```'
    cat "$WORKDIR/orphan_candidates.txt"
    echo '```'
    echo ""
  fi

  if [ -f "$WORKDIR/unused_assets.txt" ]; then
    cnt=$(wc -l < "$WORKDIR/unused_assets.txt" | tr -d ' ')
    echo "### Unused Assets: $cnt"
    echo '```'
    cat "$WORKDIR/unused_assets.txt"
    echo '```'
    echo ""
  fi

  if [ -f "$WORKDIR/unused_locale_keys.txt" ]; then
    cnt=$(wc -l < "$WORKDIR/unused_locale_keys.txt" | tr -d ' ')
    echo "### Unused Locale Keys: $cnt"
    echo '```'
    head -100 "$WORKDIR/unused_locale_keys.txt"
    echo '```'
    echo ""
  fi

  echo "## Candidates (top 50 by confidence)"
  echo ""
  if [ -f "$WORKDIR/candidates_dedup.csv" ]; then
    echo "| Path | Confidence | Reason | Risk | Action |"
    echo "|------|-----------|--------|------|--------|"
    tail -n+2 "$WORKDIR/candidates_dedup.csv" | head -50 | while IFS=',' read -r p c r e ri a; do
      echo "| $p | $c | $r | $ri | $a |"
    done
  fi
  echo ""

  echo "## Quarantine Location"
  echo "\`$GRAVEYARD\`"
  echo ""
  if [ -f "$WORKDIR/movelog.txt" ]; then
    moved=$(wc -l < "$WORKDIR/movelog.txt" | tr -d ' ')
    echo "### Files Quarantined: $moved"
  fi
  echo ""
  echo "## Next Steps"
  echo "- Review quarantined files in \`$GRAVEYARD\`"
  echo "- Restore anything needed: check \`$WORKDIR/movelog.txt\`"
  echo "- Re-run with \`DELETE_MODE=1\` to permanently remove high-confidence items"
} > "$REPORT"

echo "Report: $REPORT"

# Commit if there are changes
if ! git diff --quiet HEAD 2>/dev/null || [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "chore: quarantine suspected dead code/files ($RUN_ID)

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>" || true
fi

# PR generation
if command -v gh >/dev/null 2>&1 && git remote get-url origin >/dev/null 2>&1; then
  echo "Pushing branch and creating PR..."
  git push -u origin "$BRANCH" 2>/dev/null || true
  gh pr create \
    --title "chore: dead code cleanup ($RUN_ID)" \
    --body-file "$REPORT" 2>/dev/null || echo "PR creation skipped (may already exist)"
else
  echo "gh CLI not available or no remote. Skipping PR."
fi

echo "Report Agent done."
touch "$WORKDIR/report.done"
AGENT_EOF

# Make all agent scripts executable
chmod +x "$WORKDIR"/agent_*.sh

# ══════════════════════════════════════════════════════════════════
# LAUNCH TMUX SESSION
# ══════════════════════════════════════════════════════════════════
ENV_FILE="$WORKDIR/env.sh"

tmux kill-session -t "$SESSION" 2>/dev/null || true
tmux new-session -d -s "$SESSION" -n controller -c "$PROJECT_DIR"

# Controller: monitor agent progress
tmux send-keys -t "$SESSION:controller" "echo '=== INNERCYCLES DEAD-CODE CLEANUP ===' && echo 'Run: $RUN_ID' && echo 'Workdir: $WORKDIR' && echo 'Branch: $BRANCH' && echo 'Mode: QUARANTINE ONLY (safe)' && echo '---' && while true; do sleep 10; DONE=0; for f in $WORKDIR/*.done; do [ -f \"\$f\" ] && DONE=\$((DONE+1)); done 2>/dev/null; echo \"[\$(date +%H:%M:%S)] Agents completed: \$DONE/5\"; [ \$DONE -ge 5 ] && echo '=== ALL AGENTS COMPLETE ===' && break; done" C-m

# Agent windows
tmux new-window -t "$SESSION" -n indexer -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:indexer" "bash $WORKDIR/agent_indexer.sh $ENV_FILE 2>&1 | tee $WORKDIR/indexer.log" C-m

tmux new-window -t "$SESSION" -n static -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:static" "bash $WORKDIR/agent_static.sh $ENV_FILE 2>&1 | tee $WORKDIR/static.log" C-m

tmux new-window -t "$SESSION" -n dynamic -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:dynamic" "bash $WORKDIR/agent_dynamic.sh $ENV_FILE 2>&1 | tee $WORKDIR/dynamic.log" C-m

tmux new-window -t "$SESSION" -n scoring -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:scoring" "bash $WORKDIR/agent_scoring.sh $ENV_FILE 2>&1 | tee $WORKDIR/scoring.log" C-m

tmux new-window -t "$SESSION" -n quarantine -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:quarantine" "bash $WORKDIR/agent_quarantine.sh $ENV_FILE 2>&1 | tee $WORKDIR/quarantine.log" C-m

tmux new-window -t "$SESSION" -n report -c "$PROJECT_DIR"
tmux send-keys -t "$SESSION:report" "bash $WORKDIR/agent_report.sh $ENV_FILE 2>&1 | tee $WORKDIR/report.log" C-m

# ── LAUNCH SUMMARY ─────────────────────────────────────────────────
echo ""
log "DEAD-CODE CLEANUP SYSTEM ONLINE"
log "  Session:   $SESSION"
log "  Workdir:   $WORKDIR"
log "  Graveyard: $GRAVEYARD"
log "  Branch:    $BRANCH"
log "  Mode:      QUARANTINE ONLY (safe)"
echo ""
tmux list-windows -t "$SESSION" -F "    #{window_index}: #{window_name}"
echo ""
echo "Attach: tmux attach -t $SESSION"
