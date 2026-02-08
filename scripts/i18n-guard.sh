#!/bin/bash
# ════════════════════════════════════════════════════════════════════════════
# I18N GUARD SCRIPT - Language Isolation Checker
# ════════════════════════════════════════════════════════════════════════════
#
# Ensures strict language isolation between EN and TR content.
# Prevents hardcoded Turkish in code and mixed-language content.
#
# USAGE:
#   ./scripts/i18n-guard.sh [path]
#
# EXAMPLES:
#   ./scripts/i18n-guard.sh                    # Check entire project
#   ./scripts/i18n-guard.sh lib/               # Check lib directory
#   ./scripts/i18n-guard.sh apps/lumera-app    # Check specific app
#
# EXIT CODES:
#   0 - No language isolation violations found
#   1 - Mixed language content detected (FAIL)
# ════════════════════════════════════════════════════════════════════════════

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Target path (default: current directory)
TARGET_PATH="${1:-.}"

echo "════════════════════════════════════════════════════════════════════════════"
echo "  I18N GUARD - Language Isolation Checker"
echo "════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Scanning: $TARGET_PATH"
echo ""

FOUND_VIOLATIONS=0

# ══════════════════════════════════════════════════════════════════════════
# CHECK 1: Hardcoded Turkish in Dart Code
# ══════════════════════════════════════════════════════════════════════════

echo -e "${BLUE}[1/4] Checking for hardcoded Turkish in Dart code...${NC}"

# Common Turkish words/phrases that should use l10n
TR_MARKERS="günlük|haftalık|aylık|yıllık|bugün|yarın|şimdi|için|değil|veya|ama|fakat|çünkü|nasıl|neden|nereye|lütfen|teşekkür|merhaba|hoşgeldiniz|devam|iptal|kaydet|sil|düzenle|ekle|göster|gizle|seçin|yüklen"

HARDCODED_TR=$(grep -rniE "('|\")\s*[^'\"]*($TR_MARKERS)[^'\"]*\s*('|\")" \
  --include="*.dart" \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  --exclude-dir=build \
  --exclude-dir=.dart_tool \
  --exclude="*_test.dart" \
  --exclude="l10n_service.dart" \
  --exclude="**/l10n/*.dart" \
  "$TARGET_PATH" 2>/dev/null || true)

if [ -n "$HARDCODED_TR" ]; then
  echo -e "${RED}⚠️  HARDCODED TURKISH DETECTED:${NC}"
  echo ""
  echo "$HARDCODED_TR" | head -30
  echo ""
  FOUND_VIOLATIONS=1
else
  echo -e "${GREEN}✓ No hardcoded Turkish in Dart code${NC}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════════════
# CHECK 2: Turkish Content in English JSON Files
# ══════════════════════════════════════════════════════════════════════════

echo -e "${BLUE}[2/4] Checking for Turkish content in English JSON files...${NC}"

TR_IN_EN=$(grep -rniE "$TR_MARKERS" \
  --include="en.json" \
  --include="*_en.json" \
  "$TARGET_PATH" 2>/dev/null || true)

if [ -n "$TR_IN_EN" ]; then
  echo -e "${RED}⚠️  TURKISH CONTENT IN ENGLISH FILES:${NC}"
  echo ""
  echo "$TR_IN_EN" | head -20
  echo ""
  FOUND_VIOLATIONS=1
else
  echo -e "${GREEN}✓ No Turkish content in English files${NC}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════════════
# CHECK 3: Translation Key Parity
# ══════════════════════════════════════════════════════════════════════════

echo -e "${BLUE}[3/4] Checking translation key parity (EN vs TR)...${NC}"

EN_FILE="$TARGET_PATH/assets/l10n/en.json"
TR_FILE="$TARGET_PATH/assets/l10n/tr.json"

if [ -f "$EN_FILE" ] && [ -f "$TR_FILE" ]; then
  # Extract top-level keys from EN
  EN_KEYS=$(grep -oE '^\s*"[^"]+":' "$EN_FILE" | sed 's/[": ]//g' | sort)
  TR_KEYS=$(grep -oE '^\s*"[^"]+":' "$TR_FILE" | sed 's/[": ]//g' | sort)

  # Find keys in EN but not in TR
  MISSING_IN_TR=$(comm -23 <(echo "$EN_KEYS") <(echo "$TR_KEYS"))

  # Find keys in TR but not in EN
  MISSING_IN_EN=$(comm -13 <(echo "$EN_KEYS") <(echo "$TR_KEYS"))

  if [ -n "$MISSING_IN_TR" ]; then
    echo -e "${YELLOW}⚠️  Keys in EN missing from TR:${NC}"
    echo "$MISSING_IN_TR" | head -10
    echo ""
  fi

  if [ -n "$MISSING_IN_EN" ]; then
    echo -e "${YELLOW}⚠️  Keys in TR missing from EN:${NC}"
    echo "$MISSING_IN_EN" | head -10
    echo ""
  fi

  if [ -z "$MISSING_IN_TR" ] && [ -z "$MISSING_IN_EN" ]; then
    echo -e "${GREEN}✓ Translation keys are in parity${NC}"
  fi
else
  echo -e "${YELLOW}⚠️  Could not find l10n files for parity check${NC}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════════════
# CHECK 4: Mixed Language Strings
# ══════════════════════════════════════════════════════════════════════════

echo -e "${BLUE}[4/4] Checking for mixed EN/TR strings...${NC}"

# Pattern: English word followed by Turkish word in same string
MIXED_LANG=$(grep -rniE "('|\")\s*[A-Za-z]+\s+(için|ile|ve|veya|ama)\s*('|\")" \
  --include="*.dart" \
  --include="*.json" \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  --exclude-dir=build \
  --exclude="*_test.dart" \
  "$TARGET_PATH" 2>/dev/null || true)

if [ -n "$MIXED_LANG" ]; then
  echo -e "${YELLOW}⚠️  POSSIBLE MIXED LANGUAGE STRINGS:${NC}"
  echo ""
  echo "$MIXED_LANG" | head -20
  echo ""
  # Not a hard failure, just warning
else
  echo -e "${GREEN}✓ No obvious mixed language strings${NC}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════════════
# RESULT
# ══════════════════════════════════════════════════════════════════════════

echo "════════════════════════════════════════════════════════════════════════════"

if [ $FOUND_VIOLATIONS -eq 1 ]; then
  echo -e "${RED}❌ I18N GUARD FAILED${NC}"
  echo ""
  echo "Language isolation violations were detected."
  echo "Please fix the issues before committing."
  echo ""
  echo "Tips:"
  echo "  - Use L10n.of(context).key instead of hardcoded strings"
  echo "  - Ensure all keys exist in both en.json and tr.json"
  echo "  - Never mix languages in the same string"
  echo "════════════════════════════════════════════════════════════════════════════"
  exit 1
else
  echo -e "${GREEN}✅ I18N GUARD PASSED${NC}"
  echo ""
  echo "No language isolation violations detected."
  echo "════════════════════════════════════════════════════════════════════════════"
  exit 0
fi
