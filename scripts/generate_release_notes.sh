#!/usr/bin/env bash
# ============================================================================
# generate_release_notes.sh
# Generates human-readable, App Store–safe release notes from git history.
#
# Input : TAG_NAME  (e.g. "v1.2.0")  — current tag being released
# Output: release_notes.md            — written to repo root
#         release_notes_short.txt     — single paragraph (≤500 chars) for stores
#
# Sections (Conventional Commits aware):
#   🚀 What's New       — feat:
#   🐛 Fixes            — fix:
#   🧪 QA / Stability   — test:, ci:, perf:
#   📦 Internal         — chore:, refactor:, docs:, build:, style:
# ============================================================================
set -euo pipefail

TAG="${TAG_NAME:?TAG_NAME is not set}"
OUTFILE="release_notes.md"
SHORT_OUTFILE="release_notes_short.txt"

# ---------------------------------------------------------------------------
# Find previous tag
# ---------------------------------------------------------------------------
PREV_TAG="$(git tag --sort=-v:refname | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+' | sed -n '2p' || true)"

if [[ -z "${PREV_TAG}" ]]; then
  # No previous tag — use full history
  RANGE="HEAD"
  RANGE_DISPLAY="initial release"
else
  RANGE="${PREV_TAG}..HEAD"
  RANGE_DISPLAY="${PREV_TAG} → ${TAG}"
fi

echo "Generating release notes for ${TAG} (${RANGE_DISPLAY})"

# ---------------------------------------------------------------------------
# Collect commits (skip merges)
# ---------------------------------------------------------------------------
COMMITS="$(git log ${RANGE} --no-merges --pretty=format:'%s' 2>/dev/null || true)"

if [[ -z "${COMMITS}" ]]; then
  COMMITS="Release ${TAG}"
fi

# ---------------------------------------------------------------------------
# Categorise
# ---------------------------------------------------------------------------
FEAT=""
FIX=""
QA=""
INTERNAL=""
OTHER=""

while IFS= read -r msg; do
  [[ -z "${msg}" ]] && continue

  # Strip conventional-commit prefix for display
  clean="$(echo "${msg}" | sed -E 's/^(feat|fix|test|ci|perf|chore|refactor|docs|build|style)(\(.+\))?:\s*//')"
  # Capitalise first letter
  clean="$(echo "${clean}" | sed 's/^./\U&/')"
  bullet="- ${clean}"

  case "${msg}" in
    feat*)        FEAT="${FEAT}${bullet}"$'\n' ;;
    fix*)         FIX="${FIX}${bullet}"$'\n' ;;
    test*|ci*|perf*) QA="${QA}${bullet}"$'\n' ;;
    chore*|refactor*|docs*|build*|style*) INTERNAL="${INTERNAL}${bullet}"$'\n' ;;
    *)            OTHER="${OTHER}${bullet}"$'\n' ;;
  esac
done <<< "${COMMITS}"

# If no conventional commits at all, put everything in What's New
if [[ -z "${FEAT}" && -z "${FIX}" && -z "${QA}" && -z "${INTERNAL}" ]]; then
  FEAT="${OTHER}"
  OTHER=""
fi

# ---------------------------------------------------------------------------
# Build markdown
# ---------------------------------------------------------------------------
{
  echo "# ${TAG} Release Notes"
  echo ""
  echo "_${RANGE_DISPLAY}_"
  echo ""

  if [[ -n "${FEAT}" ]]; then
    echo "## 🚀 What's New"
    echo ""
    echo "${FEAT}"
  fi

  if [[ -n "${FIX}" ]]; then
    echo "## 🐛 Fixes"
    echo ""
    echo "${FIX}"
  fi

  if [[ -n "${QA}" ]]; then
    echo "## 🧪 QA / Stability"
    echo ""
    echo "${QA}"
  fi

  if [[ -n "${INTERNAL}" ]]; then
    echo "## 📦 Internal"
    echo ""
    echo "${INTERNAL}"
  fi

  # Anything that didn't match goes into What's New
  if [[ -n "${OTHER}" ]]; then
    echo "## 🚀 What's New"
    echo ""
    echo "${OTHER}"
  fi
} > "${OUTFILE}"

echo "Wrote ${OUTFILE}"

# ---------------------------------------------------------------------------
# Short version for App Store / Play Console (≤500 chars)
# ---------------------------------------------------------------------------
{
  # Grab first 8 bullet points across all categories, strip markdown
  {
    echo "${FEAT}"
    echo "${FIX}"
    echo "${OTHER}"
  } | grep -v '^$' | head -8 | sed 's/^- /• /'
} | head -c 500 > "${SHORT_OUTFILE}"

echo "Wrote ${SHORT_OUTFILE}"

# Export for GitHub Actions
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    echo "release_body<<RELEASE_EOF"
    cat "${OUTFILE}"
    echo "RELEASE_EOF"
  } >> "${GITHUB_OUTPUT}"
fi
