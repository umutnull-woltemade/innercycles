#!/usr/bin/env bash
# ============================================================================
# derive_repo_key.sh
# Extracts a normalised repo key from GITHUB_REPOSITORY for secret naming.
#
# Input : GITHUB_REPOSITORY  (e.g. "umut-null/astrology_app")
# Output: REPO_KEY           (e.g. "ASTROLOGY_APP")
#
# Usage in GitHub Actions:
#   - name: Derive repo key
#     run: source scripts/derive_repo_key.sh
#
#   Then reference secrets with:
#     ${{ secrets[format('{0}_SLACK_WEBHOOK_URL', env.REPO_KEY)] }}
# ============================================================================
set -euo pipefail

REPO_FULL="${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is not set}"

# Strip owner prefix (everything up to and including /)
REPO_NAME="${REPO_FULL##*/}"

# Normalise: uppercase, replace non-alphanumeric with underscore
REPO_KEY="$(echo "${REPO_NAME}" | tr '[:lower:]' '[:upper:]' | sed 's/[^A-Z0-9]/_/g')"

echo "REPO_KEY=${REPO_KEY}"

# Export to current shell (for local testing)
export REPO_KEY

# Append to GITHUB_ENV so subsequent steps can use ${{ env.REPO_KEY }}
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "REPO_KEY=${REPO_KEY}" >> "${GITHUB_ENV}"
fi
