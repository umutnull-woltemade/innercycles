#!/usr/bin/env bash

#
# i18n Auto-Fix Script
# 
# Automatically reorganizes all i18n files to correct paths
# Run from repository root: bash i18n_autofix.sh
#
# Copyright RevenueCat Inc. All Rights Reserved.
# Licensed under the MIT License.
#

set -e

echo "🌍 i18n System Auto-Fix"
echo "======================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check we're in the right directory
if [ ! -f "I18N_MASTER_INDEX.md" ]; then
    echo -e "${RED}❌ Error: Run this script from the repository root${NC}"
    echo "   Current directory: $(pwd)"
    echo "   Expected: Directory containing I18N_MASTER_INDEX.md"
    exit 1
fi

echo -e "${BLUE}Step 1: Creating directory structure...${NC}"
mkdir -p Resources/en.lproj
mkdir -p Resources/tr.lproj
mkdir -p Tests/i18n
mkdir -p scripts
mkdir -p .github/workflows
echo -e "${GREEN}✅ Directories created${NC}"
echo ""

echo -e "${BLUE}Step 2: Moving localization files...${NC}"

# Move English strings
if [ -f "Resourcesen.lprojLocalizable.strings" ]; then
    mv Resourcesen.lprojLocalizable.strings Resources/en.lproj/Localizable.strings
    echo -e "${GREEN}✅ Moved en.lproj/Localizable.strings${NC}"
elif [ -f "Resources/en.lproj/Localizable.strings" ]; then
    echo -e "${YELLOW}⚠️  en.lproj/Localizable.strings already in correct location${NC}"
else
    echo -e "${RED}❌ English strings file not found${NC}"
fi

# Move Turkish strings
if [ -f "Resourcestr.lprojLocalizable.strings" ]; then
    mv Resourcestr.lprojLocalizable.strings Resources/tr.lproj/Localizable.strings
    echo -e "${GREEN}✅ Moved tr.lproj/Localizable.strings${NC}"
elif [ -f "Resources/tr.lproj/Localizable.strings" ]; then
    echo -e "${YELLOW}⚠️  tr.lproj/Localizable.strings already in correct location${NC}"
else
    echo -e "${RED}❌ Turkish strings file not found${NC}"
fi
echo ""

echo -e "${BLUE}Step 3: Moving test files...${NC}"
if [ -f "TestsLocalizationTests.swift" ]; then
    mv TestsLocalizationTests.swift Tests/i18n/LocalizationTests.swift
    echo -e "${GREEN}✅ Moved LocalizationTests.swift${NC}"
elif [ -f "Tests/i18n/LocalizationTests.swift" ]; then
    echo -e "${YELLOW}⚠️  LocalizationTests.swift already in correct location${NC}"
else
    echo -e "${YELLOW}⚠️  LocalizationTests.swift not found (may already be moved)${NC}"
fi
echo ""

echo -e "${BLUE}Step 4: Moving script files...${NC}"

# Move i18n_guard.swift
if [ -f "scriptsi18n_guard.swift" ]; then
    mv scriptsi18n_guard.swift scripts/i18n_guard.swift
    echo -e "${GREEN}✅ Moved i18n_guard.swift${NC}"
elif [ -f "scripts/i18n_guard.swift" ]; then
    echo -e "${YELLOW}⚠️  i18n_guard.swift already in correct location${NC}"
else
    echo -e "${YELLOW}⚠️  i18n_guard.swift not found${NC}"
fi

# Move i18n_sync.swift
if [ -f "scriptsi18n_sync.swift" ]; then
    mv scriptsi18n_sync.swift scripts/i18n_sync.swift
    echo -e "${GREEN}✅ Moved i18n_sync.swift${NC}"
elif [ -f "scripts/i18n_sync.swift" ]; then
    echo -e "${YELLOW}⚠️  i18n_sync.swift already in correct location${NC}"
else
    echo -e "${YELLOW}⚠️  i18n_sync.swift not found${NC}"
fi

# Move i18n_migration.sh
if [ -f "scriptsi18n_migration.sh" ]; then
    mv scriptsi18n_migration.sh scripts/i18n_migration.sh
    echo -e "${GREEN}✅ Moved i18n_migration.sh${NC}"
elif [ -f "scripts/i18n_migration.sh" ]; then
    echo -e "${YELLOW}⚠️  i18n_migration.sh already in correct location${NC}"
else
    echo -e "${YELLOW}⚠️  i18n_migration.sh not found${NC}"
fi
echo ""

echo -e "${BLUE}Step 5: Moving GitHub workflow...${NC}"
if [ -f ".githubworkflowsi18n_compliance.yml" ]; then
    mv .githubworkflowsi18n_compliance.yml .github/workflows/i18n_compliance.yml
    echo -e "${GREEN}✅ Moved i18n_compliance.yml${NC}"
elif [ -f ".github/workflows/i18n_compliance.yml" ]; then
    echo -e "${YELLOW}⚠️  i18n_compliance.yml already in correct location${NC}"
else
    echo -e "${YELLOW}⚠️  i18n_compliance.yml not found${NC}"
fi
echo ""

echo -e "${BLUE}Step 6: Making scripts executable...${NC}"
chmod +x scripts/*.swift scripts/*.sh 2>/dev/null || true
echo -e "${GREEN}✅ Scripts are now executable${NC}"
echo ""

echo -e "${BLUE}Step 7: Verifying installation...${NC}"
echo ""

verification_passed=true

# Check English strings
if [ -f "Resources/en.lproj/Localizable.strings" ]; then
    echo -e "${GREEN}✅ English strings: Resources/en.lproj/Localizable.strings${NC}"
else
    echo -e "${RED}❌ English strings: NOT FOUND${NC}"
    verification_passed=false
fi

# Check Turkish strings
if [ -f "Resources/tr.lproj/Localizable.strings" ]; then
    echo -e "${GREEN}✅ Turkish strings: Resources/tr.lproj/Localizable.strings${NC}"
else
    echo -e "${RED}❌ Turkish strings: NOT FOUND${NC}"
    verification_passed=false
fi

# Check test file
if [ -f "Tests/i18n/LocalizationTests.swift" ]; then
    echo -e "${GREEN}✅ Tests: Tests/i18n/LocalizationTests.swift${NC}"
else
    echo -e "${YELLOW}⚠️  Tests: Tests/i18n/LocalizationTests.swift (optional)${NC}"
fi

# Check scripts
if [ -f "scripts/i18n_guard.swift" ]; then
    echo -e "${GREEN}✅ Guard script: scripts/i18n_guard.swift${NC}"
else
    echo -e "${RED}❌ Guard script: NOT FOUND${NC}"
    verification_passed=false
fi

if [ -f "scripts/i18n_sync.swift" ]; then
    echo -e "${GREEN}✅ Sync script: scripts/i18n_sync.swift${NC}"
else
    echo -e "${RED}❌ Sync script: NOT FOUND${NC}"
    verification_passed=false
fi

# Check workflow
if [ -f ".github/workflows/i18n_compliance.yml" ]; then
    echo -e "${GREEN}✅ CI workflow: .github/workflows/i18n_compliance.yml${NC}"
else
    echo -e "${YELLOW}⚠️  CI workflow: .github/workflows/i18n_compliance.yml (optional)${NC}"
fi

echo ""
echo "======================="

if [ "$verification_passed" = true ]; then
    echo -e "${GREEN}🎉 SUCCESS! All critical files in correct locations${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Add Resources/ folder to your Xcode project (or Package.swift)"
    echo "2. Run: swift scripts/i18n_guard.swift"
    echo "3. Run: swift scripts/i18n_sync.swift --check"
    echo "4. Read: I18N_README.md for usage documentation"
    echo ""
    echo "Test the system:"
    echo "  swift scripts/i18n_guard.swift"
else
    echo -e "${YELLOW}⚠️  PARTIAL SUCCESS - Some files missing${NC}"
    echo ""
    echo "Some files could not be found or moved."
    echo "This might be okay if you've already organized them manually."
    echo ""
    echo "Check the output above for details."
    echo "Refer to I18N_INSTALLATION_FIXES.md for manual steps."
fi

echo ""
echo "For more information, read:"
echo "  - I18N_MASTER_INDEX.md (overview)"
echo "  - I18N_ISSUES_FIXED.md (issues and solutions)"
echo "  - I18N_README.md (usage documentation)"
echo ""
