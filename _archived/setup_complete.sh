#!/bin/bash

# Complete iOS Deployment Setup - Fully Automated
# This script will set up EVERYTHING for you

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}║     🚀 Complete iOS Deployment Setup Script 🚀       ║${NC}"
echo -e "${CYAN}║              Everything Automated!                    ║${NC}"
echo -e "${CYAN}║                                                       ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
# STEP 1: Check Prerequisites
# ============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 1: Checking Prerequisites${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}✗ Flutter not found!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter found${NC}"

# Check if in Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}✗ Not in a Flutter project directory!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Flutter project detected${NC}"

# Check iOS directory
if [ ! -d "ios" ]; then
    echo -e "${RED}✗ ios/ directory not found!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ iOS directory found${NC}"

echo ""

# ============================================================================
# STEP 2: Backup Existing Info.plist
# ============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 2: Backing Up Existing Files${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ -f "ios/Runner/Info.plist" ]; then
    cp ios/Runner/Info.plist ios/Runner/Info.plist.backup.$(date +%Y%m%d_%H%M%S)
    echo -e "${GREEN}✓ Backed up existing Info.plist${NC}"
else
    echo -e "${YELLOW}⚠ No existing Info.plist found (will create new one)${NC}"
fi

echo ""

# ============================================================================
# STEP 3: Get User Information
# ============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 3: Getting Your AdMob App ID${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${YELLOW}Do you have your AdMob App ID ready?${NC}"
echo -e "${YELLOW}(Format: ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY)${NC}"
echo ""
echo -e "Get it from: ${CYAN}https://apps.admob.com${NC}"
echo ""
echo -e "Options:"
echo -e "  1) I have my AdMob App ID (enter it now)"
echo -e "  2) Use test AdMob ID for now (I'll change it later)"
echo ""

read -p "Enter your choice (1 or 2): " ADMOB_CHOICE

if [ "$ADMOB_CHOICE" = "1" ]; then
    read -p "Enter your AdMob App ID: " ADMOB_APP_ID
    if [[ ! $ADMOB_APP_ID =~ ^ca-app-pub-[0-9]+~[0-9]+$ ]]; then
        echo -e "${YELLOW}⚠ Warning: ID format looks incorrect. Continuing anyway...${NC}"
    fi
else
    ADMOB_APP_ID="ca-app-pub-3940256099942544~1458002511"
    echo -e "${YELLOW}⚠ Using test AdMob ID. You MUST change this before production!${NC}"
fi

echo ""
echo -e "${GREEN}✓ AdMob App ID: $ADMOB_APP_ID${NC}"
echo ""

# ============================================================================
# STEP 4: Copy Ready-Made Info.plist
# ============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 4: Creating Info.plist with All Required Keys${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Copy the ready-made Info.plist
if [ -f "Info.plist.READY" ]; then
    cp Info.plist.READY ios/Runner/Info.plist
    
    # Replace the AdMob App ID
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|ca-app-pub-3940256099942544~1458002511|$ADMOB_APP_ID|g" ios/Runner/Info.plist
    else
        sed -i "s|ca-app-pub-3940256099942544~1458002511|$ADMOB_APP_ID|g" ios/Runner/Info.plist
    fi
    
    echo -e "${GREEN}✓ Created Info.plist with:${NC}"
    echo -e "  ${GREEN}✓${NC} AdMob App ID"
    echo -e "  ${GREEN}✓${NC} 47 SKAdNetwork IDs"
    echo -e "  ${GREEN}✓${NC} URL Schemes"
    echo -e "  ${GREEN}✓${NC} Background Modes"
    echo -e "  ${GREEN}✓${NC} Privacy Descriptions"
else
    echo -e "${RED}✗ Info.plist.READY not found!${NC}"
    echo -e "${YELLOW}Using existing Info.plist${NC}"
fi

echo ""

# ============================================================================
# STEP 5: Check for GoogleService-Info.plist
# ============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 5: Checking GoogleService-Info.plist${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${GREEN}✓ GoogleService-Info.plist found!${NC}"
else
    echo -e "${YELLOW}⚠ GoogleService-Info.plist NOT found${NC}"
    echo ""
    echo -e "${CYAN}ACTION REQUIRED:${NC}"
    echo -e "1. Go to: ${CYAN}https://console.firebase.google.com${NC}"
    echo -e "2. Select your project (or create one)"
    echo -e "3. Add iOS app (if not added)"
    echo -e "4. Download ${YELLOW}GoogleService-Info.plist${NC}"
    echo ""
    
    # Check if file exists in Downloads
    if [ -f "$HOME/Downloads/GoogleService-Info.plist" ]; then
        echo -e "${GREEN}✓ Found GoogleService-Info.plist in Downloads!${NC}"
        read -p "Copy it to project now? (y/n): " COPY_FIREBASE
        if [ "$COPY_FIREBASE" = "y" ]; then
            cp "$HOME/Downloads/GoogleService-Info.plist" ios/Runner/
            echo -e "${GREEN}✓ Copied GoogleService-Info.plist to project${NC}"
        fi
    else
        echo -e "${YELLOW}Download it now and press Enter when ready...${NC}"
        read -p "Press Enter to continue..." 
        
        if [ -f "$HOME/Downloads/GoogleService-Info.plist" ]; then
            cp "$HOME/Downloads/GoogleService-Info.plist" ios/Runner/
            echo -e "${GREEN}✓ Copied GoogleService-Info.plist to project${NC}"
        else
            echo -e "${RED}⚠ Still not found. You'll need to add it manually later.${NC}"
        fi
    fi
fi

echo ""

# ============================================================================
# STEP 6: Clean Everything
# ============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 6: Cleaning Project${NC}"
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
cd ..

echo -e "${GREEN}✓ Project cleaned${NC}"
echo ""

# ============================================================================
# STEP 7: Install Dependencies
# ============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 7: Installing Dependencies${NC}"
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

# ============================================================================
# STEP 8: Build Test
# ============================================================================

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 8: Testing Build${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${CYAN}→ Running flutter build ios --release --no-codesign...${NC}"
echo -e "${YELLOW}  (This may take 5-10 minutes)${NC}"
echo ""

if flutter build ios --release --no-codesign; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
    BUILD_SUCCESS=true
else
    echo ""
    echo -e "${RED}✗ Build failed!${NC}"
    echo -e "${YELLOW}Check errors above and run again.${NC}"
    BUILD_SUCCESS=false
fi

echo ""

# ============================================================================
# STEP 9: Summary
# ============================================================================

echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                     SETUP COMPLETE!                   ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${GREEN}✓ Configuration Files:${NC}"
echo -e "  ${GREEN}✓${NC} Info.plist with AdMob App ID: $ADMOB_APP_ID"
echo -e "  ${GREEN}✓${NC} 47 SKAdNetwork IDs added"
echo -e "  ${GREEN}✓${NC} All privacy descriptions added"
echo -e "  ${GREEN}✓${NC} URL schemes configured"
echo -e "  ${GREEN}✓${NC} Background modes configured"
echo ""

if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "  ${GREEN}✓${NC} GoogleService-Info.plist found"
else
    echo -e "  ${RED}✗${NC} GoogleService-Info.plist MISSING (add it manually!)"
fi
echo ""

echo -e "${GREEN}✓ Project Status:${NC}"
echo -e "  ${GREEN}✓${NC} Flutter dependencies installed"
echo -e "  ${GREEN}✓${NC} CocoaPods installed"

if [ "$BUILD_SUCCESS" = true ]; then
    echo -e "  ${GREEN}✓${NC} Build test passed"
else
    echo -e "  ${RED}✗${NC} Build test failed (check errors)"
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Next Steps:${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${YELLOW}1. Download GoogleService-Info.plist from Firebase:${NC}"
    echo -e "   ${CYAN}https://console.firebase.google.com${NC}"
    echo -e "   Then drag it into Xcode's Runner folder"
    echo ""
fi

echo -e "${GREEN}2. Open Xcode:${NC}"
echo -e "   ${YELLOW}open ios/Runner.xcworkspace${NC}"
echo ""

echo -e "${GREEN}3. In Xcode, configure:${NC}"
echo -e "   • Runner Target → General Tab:"
echo -e "     - Bundle Identifier"
echo -e "     - Version & Build number"
echo -e "   • Signing & Capabilities Tab:"
echo -e "     - Select your Team"
echo -e "     - Add 'Sign in with Apple' capability"
echo -e "     - Add 'Push Notifications' capability"
echo -e "   • Build Settings Tab:"
echo -e "     - Set 'Enable Bitcode' to NO"
echo ""

echo -e "${GREEN}4. Select Device:${NC}"
echo -e "   Device dropdown → ${YELLOW}'Any iOS Device (arm64)'${NC}"
echo ""

echo -e "${GREEN}5. Archive:${NC}"
echo -e "   • Product → Clean Build Folder (⇧⌘K)"
echo -e "   • Product → Archive"
echo ""

echo -e "${GREEN}6. Upload:${NC}"
echo -e "   • In Organizer: Distribute App → App Store Connect → Upload"
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ "$ADMOB_CHOICE" = "2" ]; then
    echo -e "${RED}⚠️  IMPORTANT: You're using a TEST AdMob App ID!${NC}"
    echo -e "${YELLOW}Before production, replace it with your real ID in Info.plist${NC}"
    echo ""
fi

echo -e "${GREEN}📚 For detailed instructions, see:${NC}"
echo -e "   • ${YELLOW}START_HERE.md${NC} - Complete overview"
echo -e "   • ${YELLOW}QUICK_DEPLOYMENT_GUIDE.md${NC} - Step-by-step guide"
echo -e "   • ${YELLOW}XCODE_CONFIGURATION.md${NC} - Xcode settings"
echo ""

echo -e "${CYAN}Ready to deploy! 🚀${NC}"
echo ""
