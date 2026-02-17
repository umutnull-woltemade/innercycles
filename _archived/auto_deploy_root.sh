#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

clear
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   🚀 iOS DEPLOYMENT - AUTOMATED SETUP 🚀             ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# Check prerequisites
echo -e "${PURPLE}[1/8] Checking prerequisites...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✗ Flutter not found!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter found${NC}"

if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}✗ Not in Flutter project!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter project detected${NC}"
echo ""

# Backup
echo -e "${PURPLE}[2/8] Backing up files...${NC}"
if [ -f "ios/Runner/Info.plist" ]; then
    cp ios/Runner/Info.plist ios/Runner/Info.plist.backup.$(date +%Y%m%d_%H%M%S)
    echo -e "${GREEN}✓ Backed up Info.plist${NC}"
fi
echo ""

# Check Firebase
echo -e "${PURPLE}[3/8] Checking Firebase config...${NC}"
if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${GREEN}✓ GoogleService-Info.plist found${NC}"
elif [ -f "$HOME/Downloads/GoogleService-Info.plist" ]; then
    cp "$HOME/Downloads/GoogleService-Info.plist" ios/Runner/
    echo -e "${GREEN}✓ Copied from Downloads${NC}"
else
    echo -e "${YELLOW}⚠ GoogleService-Info.plist NOT found${NC}"
    echo -e "${CYAN}  Get it from: https://console.firebase.google.com${NC}"
fi
echo ""

# Clean Flutter
echo -e "${PURPLE}[4/8] Cleaning Flutter project...${NC}"
flutter clean > /dev/null 2>&1
rm -rf ios/build build/ios > /dev/null 2>&1
echo -e "${GREEN}✓ Flutter cleaned${NC}"
echo ""

# Clean iOS
echo -e "${PURPLE}[5/8] Cleaning iOS build...${NC}"
cd ios
rm -rf Pods Podfile.lock .symlinks > /dev/null 2>&1
cd ..
echo -e "${GREEN}✓ iOS cleaned${NC}"
echo ""

# Install deps
echo -e "${PURPLE}[6/8] Installing Flutter dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Flutter deps installed${NC}"
echo ""

# Install pods
echo -e "${PURPLE}[7/8] Installing CocoaPods (may take 2-5 min)...${NC}"
cd ios
pod install
cd ..
echo -e "${GREEN}✓ CocoaPods installed${NC}"
echo ""

# Build test
echo -e "${PURPLE}[8/8] Testing build (may take 5-10 min)...${NC}"
if flutter build ios --release --no-codesign; then
    echo -e "${GREEN}✓ Build successful!${NC}"
    BUILD_OK=true
else
    echo -e "${RED}✗ Build failed${NC}"
    BUILD_OK=false
fi
echo ""

# Summary
echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║              ✅ SETUP COMPLETE! ✅                     ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${GREEN}✓${NC} GoogleService-Info.plist: Found"
else
    echo -e "${RED}✗${NC} GoogleService-Info.plist: MISSING (add it!)"
fi

if [ "$BUILD_OK" = true ]; then
    echo -e "${GREEN}✓${NC} Build test: PASSED"
else
    echo -e "${YELLOW}⚠${NC} Build test: FAILED (check errors)"
fi

echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo -e "1. ${YELLOW}open ios/Runner.xcworkspace${NC}"
echo -e "2. Select Team (Signing & Capabilities)"
echo -e "3. Add capabilities (Sign in with Apple, Push Notifications)"
echo -e "4. Set Bundle ID, Version, Build"
echo -e "5. Product → Archive"
echo ""

if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${YELLOW}⚠ Don't forget to get GoogleService-Info.plist from:${NC}"
    echo -e "   ${CYAN}https://console.firebase.google.com${NC}"
    echo ""
fi

echo -e "${GREEN}🚀 Ready to deploy!${NC}"
echo ""
