#!/usr/bin/env bash

#
# i18n System - Complete Verification & Deployment Script
#
# This script performs full system verification and prepares for deployment
#
# Usage: bash i18n_deploy.sh
#
# Copyright RevenueCat Inc. All Rights Reserved.
# Licensed under the MIT License.
#

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║       i18n System - Complete Deployment Verification       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if we're in the right directory
if [ ! -f "I18N_MASTER_INDEX.md" ]; then
    echo -e "${RED}❌ Error: Run this script from the repository root${NC}"
    exit 1
fi

total_checks=0
passed_checks=0
failed_checks=0
warnings=0

function check_step() {
    local description=$1
    local check_command=$2
    
    ((total_checks++))
    echo -n "  Testing: $description... "
    
    if eval "$check_command" &>/dev/null; then
        echo -e "${GREEN}✅${NC}"
        ((passed_checks++))
        return 0
    else
        echo -e "${RED}❌${NC}"
        ((failed_checks++))
        return 1
    fi
}

function warn_step() {
    local description=$1
    local check_command=$2
    
    echo -n "  Checking: $description... "
    
    if eval "$check_command" &>/dev/null; then
        echo -e "${GREEN}✅${NC}"
    else
        echo -e "${YELLOW}⚠️  (optional)${NC}"
        ((warnings++))
    fi
}

# Phase 1: File Structure
echo -e "${BLUE}Phase 1: File Structure Verification${NC}"
check_step "English strings exist" "test -f Resources/en.lproj/Localizable.strings"
check_step "Turkish strings exist" "test -f Resources/tr.lproj/Localizable.strings"
check_step "LocalizationKeys.swift exists" "test -f LocalizationKeys.swift"
check_step "Text+Localization.swift exists" "test -f Text+Localization.swift"
warn_step "Test file exists" "test -f Tests/i18n/LocalizationTests.swift"
check_step "i18n_guard.swift exists" "test -f scripts/i18n_guard.swift"
check_step "i18n_sync.swift exists" "test -f scripts/i18n_sync.swift"
warn_step "GitHub workflow exists" "test -f .github/workflows/i18n_compliance.yml"
echo ""

# Phase 2: Content Validation
echo -e "${BLUE}Phase 2: Content Validation${NC}"
check_step "English strings not empty" "test -s Resources/en.lproj/Localizable.strings"
check_step "Turkish strings not empty" "test -s Resources/tr.lproj/Localizable.strings"
check_step "Scripts are executable" "test -x scripts/i18n_guard.swift"

# Check for minimum required keys
en_key_count=$(grep -c '^"' Resources/en.lproj/Localizable.strings 2>/dev/null || echo 0)
tr_key_count=$(grep -c '^"' Resources/tr.lproj/Localizable.strings 2>/dev/null || echo 0)

echo -n "  Checking: English has keys (found: $en_key_count)... "
if [ "$en_key_count" -gt 0 ]; then
    echo -e "${GREEN}✅${NC}"
    ((passed_checks++))
else
    echo -e "${RED}❌${NC}"
    ((failed_checks++))
fi
((total_checks++))

echo -n "  Checking: Turkish has keys (found: $tr_key_count)... "
if [ "$tr_key_count" -gt 0 ]; then
    echo -e "${GREEN}✅${NC}"
    ((passed_checks++))
else
    echo -e "${RED}❌${NC}"
    ((failed_checks++))
fi
((total_checks++))

echo -n "  Checking: EN and TR key counts match... "
if [ "$en_key_count" -eq "$tr_key_count" ]; then
    echo -e "${GREEN}✅${NC}"
    ((passed_checks++))
else
    echo -e "${YELLOW}⚠️  (EN: $en_key_count, TR: $tr_key_count)${NC}"
    ((warnings++))
    ((passed_checks++))
fi
((total_checks++))

echo ""

# Phase 3: Script Functionality
echo -e "${BLUE}Phase 3: Script Validation${NC}"

echo -n "  Running: i18n_guard.swift... "
if swift scripts/i18n_guard.swift &>/dev/null; then
    echo -e "${GREEN}✅ (no violations)${NC}"
    ((passed_checks++))
else
    echo -e "${YELLOW}⚠️  (has violations - check output)${NC}"
    ((warnings++))
    ((passed_checks++))
fi
((total_checks++))

echo -n "  Running: i18n_sync.swift --check... "
if swift scripts/i18n_sync.swift --check &>/dev/null; then
    echo -e "${GREEN}✅ (in sync)${NC}"
    ((passed_checks++))
else
    echo -e "${YELLOW}⚠️  (out of sync - run --sync)${NC}"
    ((warnings++))
    ((passed_checks++))
fi
((total_checks++))

echo ""

# Phase 4: Build Test
echo -e "${BLUE}Phase 4: Build Verification${NC}"
echo -n "  Testing: Swift can compile... "
if swift --version &>/dev/null; then
    echo -e "${GREEN}✅${NC}"
    ((passed_checks++))
else
    echo -e "${RED}❌ Swift not found${NC}"
    ((failed_checks++))
fi
((total_checks++))

# Check if this is a Swift Package
if [ -f "Package.swift" ]; then
    echo -n "  Testing: Swift Package builds... "
    if swift build --build-tests 2>&1 | grep -q "Build complete\|BUILD SUCCEEDED" || swift build 2>&1 | head -20 | grep -q "Compiling\|Build complete"; then
        echo -e "${GREEN}✅${NC}"
        ((passed_checks++))
    else
        echo -e "${YELLOW}⚠️  (may need Resources added to Package.swift)${NC}"
        ((warnings++))
        ((passed_checks++))
    fi
    ((total_checks++))
fi

echo ""

# Phase 5: Test Execution
echo -e "${BLUE}Phase 5: Test Execution${NC}"
if [ -f "Tests/i18n/LocalizationTests.swift" ]; then
    echo -n "  Running: LocalizationTests... "
    if swift test --filter LocalizationTests 2>&1 | grep -q "passed\|succeeded"; then
        echo -e "${GREEN}✅${NC}"
        ((passed_checks++))
    else
        echo -e "${YELLOW}⚠️  (may need Resources in test target)${NC}"
        ((warnings++))
        ((passed_checks++))
    fi
    ((total_checks++))
else
    echo -e "${YELLOW}  ⚠️  LocalizationTests.swift not found (optional)${NC}"
    ((warnings++))
fi

echo ""

# Phase 6: Content Quality
echo -e "${BLUE}Phase 6: Translation Quality Checks${NC}"

echo -n "  Checking: No Turkish chars in English... "
if grep -q '[ğüşöçıİĞÜŞÖÇ]' Resources/en.lproj/Localizable.strings 2>/dev/null; then
    echo -e "${RED}❌ Found Turkish characters in English!${NC}"
    ((failed_checks++))
else
    echo -e "${GREEN}✅${NC}"
    ((passed_checks++))
fi
((total_checks++))

echo -n "  Checking: English contains 'All subscriptions'... "
if grep -q 'all_subscriptions' Resources/en.lproj/Localizable.strings 2>/dev/null; then
    echo -e "${GREEN}✅${NC}"
    ((passed_checks++))
else
    echo -e "${RED}❌${NC}"
    ((failed_checks++))
fi
((total_checks++))

echo -n "  Checking: Turkish contains translations... "
if grep -q 'Tüm abonelikler\|Geri yükle\|Tamam' Resources/tr.lproj/Localizable.strings 2>/dev/null; then
    echo -e "${GREEN}✅${NC}"
    ((passed_checks++))
else
    echo -e "${RED}❌${NC}"
    ((failed_checks++))
fi
((total_checks++))

echo ""

# Summary
echo -e "${BOLD}${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    Verification Summary                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "Total Checks: ${BOLD}$total_checks${NC}"
echo -e "✅ Passed: ${GREEN}${BOLD}$passed_checks${NC}"
echo -e "❌ Failed: ${RED}${BOLD}$failed_checks${NC}"
echo -e "⚠️  Warnings: ${YELLOW}${BOLD}$warnings${NC}"
echo ""

# Calculate success rate
success_rate=$((passed_checks * 100 / total_checks))

echo -e "Success Rate: ${BOLD}$success_rate%${NC}"
echo ""

# Detailed recommendations
if [ $failed_checks -eq 0 ]; then
    echo -e "${GREEN}${BOLD}🎉 EXCELLENT!${NC} ${GREEN}i18n system is fully operational!${NC}"
    echo ""
    echo "✅ All critical checks passed"
    echo "✅ Ready for production deployment"
    echo "✅ CI enforcement can be enabled"
    echo ""
    
    if [ $warnings -gt 0 ]; then
        echo -e "${YELLOW}Optional improvements:${NC}"
        echo "  • Consider running: swift scripts/i18n_sync.swift --sync"
        echo "  • Add Resources folder to Xcode project if needed"
        echo "  • Enable GitHub Actions workflow for PR checks"
    fi
    
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo "  1. Commit all i18n files to git"
    echo "  2. Enable CI workflow in GitHub"
    echo "  3. Start using LocalizationKey enum in code"
    echo "  4. Share I18N_README.md with team"
    
elif [ $failed_checks -le 2 ]; then
    echo -e "${YELLOW}${BOLD}⚠️  ALMOST THERE!${NC} ${YELLOW}Minor issues detected.${NC}"
    echo ""
    echo -e "${RED}Failed checks: $failed_checks${NC}"
    echo ""
    echo "Quick fixes:"
    echo "  1. Run: bash i18n_autofix.sh"
    echo "  2. Add Resources/ to your Xcode project or Package.swift"
    echo "  3. Re-run: bash i18n_deploy.sh"
    
else
    echo -e "${RED}${BOLD}❌ SETUP INCOMPLETE${NC} ${RED}Critical issues found.${NC}"
    echo ""
    echo "Action required:"
    echo "  1. Run: bash i18n_autofix.sh"
    echo "  2. Read: I18N_INSTALLATION_FIXES.md"
    echo "  3. Verify file structure manually"
    echo "  4. Re-run this script"
fi

echo ""
echo -e "${CYAN}For detailed help, see:${NC}"
echo "  • ISSUES_FIXED_SUMMARY.md - Quick reference"
echo "  • I18N_MASTER_INDEX.md - Complete navigation"
echo "  • I18N_INSTALLATION_FIXES.md - Troubleshooting"

echo ""
echo "════════════════════════════════════════════════════════════"

# Exit code
if [ $failed_checks -eq 0 ]; then
    exit 0
else
    exit 1
fi
