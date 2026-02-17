#!/bin/bash

# =============================================================================
# iOS Deployment Automation Script
# =============================================================================
# This script automates the pre-deployment steps for your Flutter iOS app
# Run this before opening Xcode to archive
# =============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}║       🚀 iOS Deployment Automation Script 🚀         ║${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# STEP 1: Verify Prerequisites
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 1: Verifying Prerequisites${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✗ Flutter not found! Install Flutter first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter found: $(flutter --version | head -n 1)${NC}"

# Check if in Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}✗ Not in a Flutter project directory!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter project detected${NC}"

# Check if iOS directory exists
if [ ! -d "ios" ]; then
    echo -e "${RED}✗ ios/ directory not found!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ iOS directory found${NC}"

# Check CocoaPods
if ! command -v pod &> /dev/null; then
    echo -e "${YELLOW}⚠ CocoaPods not found. Installing...${NC}"
    sudo gem install cocoapods
fi
echo -e "${GREEN}✓ CocoaPods found: $(pod --version)${NC}"

echo ""

# =============================================================================
# STEP 2: Clean Project
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 2: Cleaning Project${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}→ Running flutter clean...${NC}"
flutter clean

echo -e "${CYAN}→ Removing iOS build artifacts...${NC}"
rm -rf ios/build
rm -rf build/ios

echo -e "${CYAN}→ Removing pods...${NC}"
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
cd ..

echo -e "${GREEN}✓ Project cleaned${NC}"
echo ""

# =============================================================================
# STEP 3: Install Dependencies
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 3: Installing Dependencies${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}→ Running flutter pub get...${NC}"
flutter pub get

echo -e "${CYAN}→ Installing CocoaPods...${NC}"
cd ios
pod install
cd ..

echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# =============================================================================
# STEP 4: Verify Critical Files
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 4: Verifying Critical Files${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

ERRORS=0
WARNINGS=0

# Check Info.plist
if [ -f "ios/Runner/Info.plist" ]; then
    echo -e "${GREEN}✓ Info.plist found${NC}"
    
    # Check for critical keys
    if grep -q "GADApplicationIdentifier" "ios/Runner/Info.plist"; then
        GAD_ID=$(grep -A 1 "GADApplicationIdentifier" "ios/Runner/Info.plist" | tail -n 1 | sed 's/.*<string>\(.*\)<\/string>/\1/' | tr -d '[:space:]')
        if [[ $GAD_ID == *"XXXX"* ]] || [[ $GAD_ID == *"ca-app-pub-"* && ${#GAD_ID} -lt 30 ]]; then
            echo -e "${YELLOW}⚠ AdMob App ID looks like placeholder: $GAD_ID${NC}"
            echo -e "${YELLOW}  Get real ID from: https://apps.admob.com${NC}"
            WARNINGS=$((WARNINGS + 1))
        else
            echo -e "${GREEN}✓ AdMob App ID configured${NC}"
        fi
    else
        echo -e "${RED}✗ AdMob App ID (GADApplicationIdentifier) missing!${NC}"
        echo -e "${YELLOW}  Add to Info.plist - see Info.plist.SAMPLE${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    if grep -q "SKAdNetworkItems" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✓ SKAdNetwork IDs configured${NC}"
    else
        echo -e "${YELLOW}⚠ SKAdNetwork IDs missing (needed for iOS 14+ ads)${NC}"
        echo -e "${YELLOW}  See SKADNETWORK_IDS.md${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    if grep -q "LSApplicationQueriesSchemes" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✓ URL Schemes configured${NC}"
    else
        echo -e "${YELLOW}⚠ URL Schemes missing (needed for url_launcher)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    if grep -q "UIBackgroundModes" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✓ Background Modes configured${NC}"
    else
        echo -e "${YELLOW}⚠ Background Modes missing (needed for notifications)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${RED}✗ Info.plist not found!${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Check GoogleService-Info.plist
if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${GREEN}✓ GoogleService-Info.plist found${NC}"
else
    echo -e "${RED}✗ GoogleService-Info.plist missing!${NC}"
    echo -e "${YELLOW}  Download from: https://console.firebase.google.com${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Check workspace
if [ -d "ios/Runner.xcworkspace" ]; then
    echo -e "${GREEN}✓ Runner.xcworkspace exists${NC}"
else
    echo -e "${RED}✗ Runner.xcworkspace not found!${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Check app icons
if [ -d "ios/Runner/Assets.xcassets/AppIcon.appiconset" ]; then
    ICON_COUNT=$(find ios/Runner/Assets.xcassets/AppIcon.appiconset -name "*.png" 2>/dev/null | wc -l)
    if [ $ICON_COUNT -gt 5 ]; then
        echo -e "${GREEN}✓ App icons found ($ICON_COUNT images)${NC}"
    else
        echo -e "${YELLOW}⚠ Only $ICON_COUNT app icons found (need more sizes)${NC}"
        echo -e "${YELLOW}  Generate at: https://appicon.co/${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${RED}✗ AppIcon asset catalog not found!${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""

# =============================================================================
# STEP 5: Build Test
# =============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 5: Test Building for iOS${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}→ Running flutter build ios --release...${NC}"
echo -e "${YELLOW}  (This may take 5-10 minutes)${NC}"
echo ""

if flutter build ios --release --no-codesign; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
else
    echo ""
    echo -e "${RED}✗ Build failed! Fix errors before archiving.${NC}"
    ERRORS=$((ERRORS + 1))
fi

echo ""

# =============================================================================
# STEP 6: Summary & Next Steps
# =============================================================================

echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${PURPLE}Summary${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ ALL CHECKS PASSED - READY TO ARCHIVE!     ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Next Steps:${NC}"
    echo -e "1. Open Xcode: ${YELLOW}open ios/Runner.xcworkspace${NC}"
    echo -e "2. Select device: ${YELLOW}Any iOS Device (arm64)${NC}"
    echo -e "3. Configure signing:"
    echo -e "   • Runner Target → Signing & Capabilities"
    echo -e "   • Select your Team"
    echo -e "   • Enable: Sign in with Apple, Push Notifications"
    echo -e "4. Set Bundle ID, Version, Build number (General tab)"
    echo -e "5. Product → Clean Build Folder (⇧⌘K)"
    echo -e "6. Product → Archive"
    echo ""
    echo -e "${GREEN}See QUICK_DEPLOYMENT_GUIDE.md for detailed instructions!${NC}"
    
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║  ⚠ FOUND $WARNINGS WARNING(S) - REVIEW NEEDED    ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}You can proceed with archiving, but review warnings above.${NC}"
    echo -e "Warnings may affect functionality (especially ads)."
    echo ""
    echo -e "${CYAN}To fix warnings, see:${NC}"
    echo -e "• Info.plist.SAMPLE (configuration reference)"
    echo -e "• SKADNETWORK_IDS.md (ad network IDs)"
    echo -e "• TROUBLESHOOTING.md (specific fixes)"
    
else
    echo -e "${RED}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ✗ FOUND $ERRORS ERROR(S) - FIX BEFORE ARCHIVING ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}Fix the errors above before archiving.${NC}"
    echo ""
    echo -e "${CYAN}Common fixes:${NC}"
    echo -e "• Info.plist keys: See ${YELLOW}Info.plist.SAMPLE${NC}"
    echo -e "• Firebase config: Download from ${YELLOW}https://console.firebase.google.com${NC}"
    echo -e "• Build errors: See ${YELLOW}TROUBLESHOOTING.md${NC}"
    echo ""
    echo -e "${CYAN}After fixing, run this script again.${NC}"
fi

echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Additional helpful info
if [ $ERRORS -eq 0 ]; then
    echo -e "${CYAN}📚 Documentation:${NC}"
    echo -e "• Quick Guide: ${YELLOW}QUICK_DEPLOYMENT_GUIDE.md${NC}"
    echo -e "• Full Checklist: ${YELLOW}DEPLOYMENT_CHECKLIST.md${NC}"
    echo -e "• Troubleshooting: ${YELLOW}TROUBLESHOOTING.md${NC}"
    echo -e "• Overview: ${YELLOW}README_DEPLOYMENT.md${NC}"
    echo ""
    
    echo -e "${CYAN}🔍 Useful Commands:${NC}"
    echo -e "• Open Xcode: ${YELLOW}open ios/Runner.xcworkspace${NC}"
    echo -e "• Check Flutter: ${YELLOW}flutter doctor -v${NC}"
    echo -e "• Update pods: ${YELLOW}cd ios && pod update && cd ..${NC}"
    echo ""
fi

# Exit with appropriate code
if [ $ERRORS -gt 0 ]; then
    exit 1
else
    exit 0
fi
