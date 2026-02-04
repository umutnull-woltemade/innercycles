#!/bin/bash

#
#  Copyright RevenueCat Inc. All Rights Reserved.
#
#  Licensed under the MIT License.
#
#  i18n_migration.sh
#
#  One-time migration script to find and report hardcoded strings
#
#  Usage: bash scripts/i18n_migration.sh
#

set -e

echo "🔍 Scanning for hardcoded user-facing strings..."
echo ""

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Patterns to search for
PATTERNS=(
    'Text("'
    'alert.*Text("'
    'Button.*Text("'
    '.navigationTitle("'
    '.accessibilityLabel("'
)

# Directories to scan
DIRS="Sources RevenueCatUI"

# Excluded patterns
EXCLUDE_PATTERNS=(
    "systemName:"
    "Image("
    "LocalizationKey"
    "bundle:"
    "// swiftlint:disable"
    "Tests/"
    "Generated"
)

echo "📂 Scanning directories: $DIRS"
echo ""

total_findings=0

for dir in $DIRS; do
    if [ ! -d "$dir" ]; then
        echo "${YELLOW}⚠️  Directory not found: $dir${NC}"
        continue
    fi
    
    echo "Scanning $dir..."
    
    # Find all Swift files
    while IFS= read -r file; do
        findings=0
        
        # Search for hardcoded string patterns
        while IFS= read -r line_num; do
            [ -z "$line_num" ] && continue
            
            line=$(sed -n "${line_num}p" "$file")
            
            # Check if line should be excluded
            should_exclude=false
            for exclude in "${EXCLUDE_PATTERNS[@]}"; do
                if echo "$line" | grep -q "$exclude"; then
                    should_exclude=true
                    break
                fi
            done
            
            if [ "$should_exclude" = false ]; then
                if [ $findings -eq 0 ]; then
                    echo ""
                    echo "${YELLOW}$file:${NC}"
                fi
                
                echo "  ${RED}Line $line_num:${NC} $(echo "$line" | xargs)"
                ((findings++))
                ((total_findings++))
            fi
            
        done < <(grep -n 'Text("' "$file" | cut -d: -f1 || true)
        
    done < <(find "$dir" -name "*.swift" -type f)
done

echo ""
echo "════════════════════════════════════════════════════════════"

if [ $total_findings -eq 0 ]; then
    echo "${GREEN}✅ No hardcoded strings found!${NC}"
else
    echo "${YELLOW}⚠️  Found $total_findings potential hardcoded strings${NC}"
    echo ""
    echo "Action items:"
    echo "1. Review each finding above"
    echo "2. Add key to LocalizationKeys.swift enum"
    echo "3. Add translations to en.lproj and tr.lproj"
    echo "4. Replace hardcoded string with:"
    echo "   Text(LocalizationKey.yourKey.rawValue, bundle: localizedBundle)"
    echo ""
    echo "5. Run: swift scripts/i18n_sync.swift --sync"
    echo "6. Run: swift scripts/i18n_guard.swift"
fi

echo "════════════════════════════════════════════════════════════"

exit 0
