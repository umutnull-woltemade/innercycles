#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
# SAFETY CHECK SCRIPT - App Store 4.3(b) Compliance Scanner
# ════════════════════════════════════════════════════════════════════════════
#
# Scans codebase for forbidden astrology/prediction phrases.
# Used by CI pipeline to block non-compliant commits.
#
# USAGE:
#   ./scripts/safety-check.sh [path]
#
# EXAMPLES:
#   ./scripts/safety-check.sh                    # Scan entire project
#   ./scripts/safety-check.sh lib/               # Scan lib directory
#   ./scripts/safety-check.sh apps/lumera-app    # Scan specific app
#
# EXIT CODES:
#   0 - No forbidden phrases found
#   1 - Forbidden phrases detected (FAIL)
# ════════════════════════════════════════════════════════════════════════════

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Target path (default: current directory)
TARGET_PATH="${1:-.}"

echo "════════════════════════════════════════════════════════════════════════════"
echo "  CONTENT SAFETY SCANNER - App Store Compliance Check"
echo "════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Scanning: $TARGET_PATH"
echo ""

# ══════════════════════════════════════════════════════════════════════════
# FORBIDDEN PHRASES (English)
# ══════════════════════════════════════════════════════════════════════════

FORBIDDEN_EN="astrology|astrological|astrologer"
FORBIDDEN_EN="$FORBIDDEN_EN|horoscope|horoscopes|daily horoscope|weekly horoscope"
FORBIDDEN_EN="$FORBIDDEN_EN|zodiac sign|sun sign|moon sign|rising sign|ascendant"
FORBIDDEN_EN="$FORBIDDEN_EN|birth chart|natal chart|chart reading"
FORBIDDEN_EN="$FORBIDDEN_EN|mercury retrograde|saturn return|planetary influence"
FORBIDDEN_EN="$FORBIDDEN_EN|fortune telling|fortune teller|your fortune"
FORBIDDEN_EN="$FORBIDDEN_EN|prediction|prophecy|prophetic"
FORBIDDEN_EN="$FORBIDDEN_EN|destiny|fated|destined|meant to be"
FORBIDDEN_EN="$FORBIDDEN_EN|your future|future holds|will happen"
FORBIDDEN_EN="$FORBIDDEN_EN|stars say|stars indicate|stars align"
FORBIDDEN_EN="$FORBIDDEN_EN|cosmic influence|cosmic energy"
FORBIDDEN_EN="$FORBIDDEN_EN|psychic|clairvoyant|spirit guide"

# ══════════════════════════════════════════════════════════════════════════
# FORBIDDEN PHRASES (Turkish)
# ══════════════════════════════════════════════════════════════════════════

FORBIDDEN_TR="astroloji|astrolojik|astrolog"
FORBIDDEN_TR="$FORBIDDEN_TR|burç yorumu|günlük burç|haftalık burç"
FORBIDDEN_TR="$FORBIDDEN_TR|doğum haritası|natal harita|yıldız haritası"
FORBIDDEN_TR="$FORBIDDEN_TR|merkür retrosu|gezegen etkisi|gezegen dizilimi"
FORBIDDEN_TR="$FORBIDDEN_TR|falcılık|falcı|kahve falı|tarot falı"
FORBIDDEN_TR="$FORBIDDEN_TR|kehanet|kehanetle|öngörü"
FORBIDDEN_TR="$FORBIDDEN_TR|kaderiniz|alın yazısı|yazgı|mukadderat"
FORBIDDEN_TR="$FORBIDDEN_TR|geleceğiniz|sizi bekleyen|gerçekleşecek"
FORBIDDEN_TR="$FORBIDDEN_TR|yıldızlar söylüyor|yıldızlar diyor"
FORBIDDEN_TR="$FORBIDDEN_TR|kozmik etki|kozmik enerji"
FORBIDDEN_TR="$FORBIDDEN_TR|medyum|durugörü|ruh rehberi"

# ══════════════════════════════════════════════════════════════════════════
# EXCLUSIONS
# ══════════════════════════════════════════════════════════════════════════

EXCLUSIONS=(
  "--exclude-dir=node_modules"
  "--exclude-dir=.git"
  "--exclude-dir=build"
  "--exclude-dir=.dart_tool"
  "--exclude-dir=.idea"
  "--exclude-dir=coverage"
  "--exclude=*.lock"
  "--exclude=*_test.dart"
  "--exclude=*_test.ts"
  "--exclude=*.test.ts"
  "--exclude=*.spec.ts"
  "--exclude=LUMERA_SPACE_RELEASE_PLAN.md"
  "--exclude=INTERNAL_OBSERVATORY_SPEC.md"
  "--exclude=forbidden-phrases.ts"
  "--exclude=content_safety_filter.dart"
  "--exclude=content_safety_filter_test.dart"
  "--exclude=safety-check.sh"
)

# ══════════════════════════════════════════════════════════════════════════
# SCAN FUNCTION
# ══════════════════════════════════════════════════════════════════════════

FOUND_VIOLATIONS=0

scan_for_phrases() {
  local PHRASES="$1"
  local LANGUAGE="$2"
  local FILE_TYPES="$3"

  echo -e "${YELLOW}Scanning for $LANGUAGE phrases in $FILE_TYPES files...${NC}"

  # Run grep and capture output
  MATCHES=$(grep -rniE "$PHRASES" \
    --include="*.dart" \
    --include="*.ts" \
    --include="*.tsx" \
    --include="*.js" \
    --include="*.json" \
    --include="*.md" \
    "${EXCLUSIONS[@]}" \
    "$TARGET_PATH" 2>/dev/null || true)

  if [ -n "$MATCHES" ]; then
    echo -e "${RED}⚠️  FORBIDDEN PHRASES DETECTED ($LANGUAGE):${NC}"
    echo ""
    echo "$MATCHES" | head -50
    echo ""
    if [ $(echo "$MATCHES" | wc -l) -gt 50 ]; then
      echo -e "${YELLOW}... and more (showing first 50 matches)${NC}"
    fi
    FOUND_VIOLATIONS=1
  else
    echo -e "${GREEN}✓ No forbidden $LANGUAGE phrases found${NC}"
  fi
  echo ""
}

# ══════════════════════════════════════════════════════════════════════════
# RUN SCANS
# ══════════════════════════════════════════════════════════════════════════

scan_for_phrases "$FORBIDDEN_EN" "English" "code/content"
scan_for_phrases "$FORBIDDEN_TR" "Turkish" "code/content"

# ══════════════════════════════════════════════════════════════════════════
# RESULT
# ══════════════════════════════════════════════════════════════════════════

echo "════════════════════════════════════════════════════════════════════════════"

if [ $FOUND_VIOLATIONS -eq 1 ]; then
  echo -e "${RED}❌ SAFETY CHECK FAILED${NC}"
  echo ""
  echo "Forbidden phrases were detected in the codebase."
  echo "Please remove or replace these phrases before committing."
  echo ""
  echo "See: docs/LUMERA_SPACE_RELEASE_PLAN.md for safe replacements."
  echo "════════════════════════════════════════════════════════════════════════════"
  exit 1
else
  echo -e "${GREEN}✅ SAFETY CHECK PASSED${NC}"
  echo ""
  echo "No forbidden phrases detected. Content is App Store compliant."
  echo "════════════════════════════════════════════════════════════════════════════"
  exit 0
fi
