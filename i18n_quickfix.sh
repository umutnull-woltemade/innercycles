#!/usr/bin/env bash

#
# i18n Quick Fix - Manual File Organization
#
# This script moves remaining files to correct locations
# Run from repository root
#

set -e

echo "🔧 i18n Quick Fix - Moving Remaining Files"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

moved=0
already_ok=0
not_found=0

# Create scripts directory if needed
mkdir -p scripts

echo "📁 Moving script files..."

# Move i18n_guard.swift
if [ -f "scriptsi18n_guard.swift" ]; then
    mv scriptsi18n_guard.swift scripts/i18n_guard.swift
    chmod +x scripts/i18n_guard.swift
    echo -e "${GREEN}✅ Moved i18n_guard.swift${NC}"
    ((moved++))
elif [ -f "scripts/i18n_guard.swift" ]; then
    echo -e "${YELLOW}⚠️  i18n_guard.swift already in correct location${NC}"
    ((already_ok++))
else
    echo -e "${RED}❌ scriptsi18n_guard.swift not found${NC}"
    ((not_found++))
fi

# Move i18n_sync.swift
if [ -f "scriptsi18n_sync.swift" ]; then
    mv scriptsi18n_sync.swift scripts/i18n_sync.swift
    chmod +x scripts/i18n_sync.swift
    echo -e "${GREEN}✅ Moved i18n_sync.swift${NC}"
    ((moved++))
elif [ -f "scripts/i18n_sync.swift" ]; then
    echo -e "${YELLOW}⚠️  i18n_sync.swift already in correct location${NC}"
    ((already_ok++))
else
    echo -e "${RED}❌ scriptsi18n_sync.swift not found${NC}"
    ((not_found++))
fi

# Move i18n_migration.sh
if [ -f "scriptsi18n_migration.sh" ]; then
    mv scriptsi18n_migration.sh scripts/i18n_migration.sh
    chmod +x scripts/i18n_migration.sh
    echo -e "${GREEN}✅ Moved i18n_migration.sh${NC}"
    ((moved++))
elif [ -f "scripts/i18n_migration.sh" ]; then
    echo -e "${YELLOW}⚠️  i18n_migration.sh already in correct location${NC}"
    ((already_ok++))
else
    echo -e "${RED}❌ scriptsi18n_migration.sh not found${NC}"
    ((not_found++))
fi

echo ""
echo "📁 Creating .github/workflows if needed..."
mkdir -p .github/workflows

# Move GitHub workflow
if [ -f ".githubworkflowsi18n_compliance.yml" ]; then
    mv .githubworkflowsi18n_compliance.yml .github/workflows/i18n_compliance.yml
    echo -e "${GREEN}✅ Moved i18n_compliance.yml${NC}"
    ((moved++))
elif [ -f ".github/workflows/i18n_compliance.yml" ]; then
    echo -e "${YELLOW}⚠️  i18n_compliance.yml already in correct location${NC}"
    ((already_ok++))
else
    echo -e "${YELLOW}⚠️  .githubworkflowsi18n_compliance.yml not found (optional)${NC}"
fi

echo ""
echo "=========================================="
echo -e "Files moved: ${GREEN}$moved${NC}"
echo -e "Already OK: ${YELLOW}$already_ok${NC}"
echo -e "Not found: ${RED}$not_found${NC}"
echo ""

if [ -f "scripts/i18n_guard.swift" ] && [ -f "scripts/i18n_sync.swift" ]; then
    echo -e "${GREEN}🎉 SUCCESS! Critical scripts now in place${NC}"
    echo ""
    echo "Verify installation:"
    echo "  swift scripts/i18n_guard.swift"
    echo "  swift scripts/i18n_sync.swift --check"
    echo ""
    echo "Next: Add Resources/ folder to your Xcode project"
else
    echo -e "${RED}⚠️  Some script files still missing${NC}"
    echo ""
    echo "You may need to recreate them. See:"
    echo "  I18N_INSTALLATION_FIXES.md"
fi

echo ""
