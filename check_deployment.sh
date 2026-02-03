#!/bin/bash

# iOS Deployment Pre-Flight Check
# Run this script before archiving to catch common issues

echo "🔍 Flutter iOS Deployment Pre-Flight Check"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Check 1: Flutter installation
echo "✓ Checking Flutter installation..."
if command -v flutter &> /dev/null; then
    echo -e "${GREEN}✓ Flutter found: $(flutter --version | head -n 1)${NC}"
else
    echo -e "${RED}✗ Flutter not found in PATH${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 2: iOS directory structure
echo "✓ Checking iOS directory structure..."
if [ -d "ios" ]; then
    echo -e "${GREEN}✓ ios/ directory exists${NC}"
else
    echo -e "${RED}✗ ios/ directory not found${NC}"
    ERRORS=$((ERRORS + 1))
    exit 1
fi

if [ -d "ios/Runner.xcworkspace" ]; then
    echo -e "${GREEN}✓ Runner.xcworkspace exists${NC}"
else
    echo -e "${RED}✗ Runner.xcworkspace not found - run 'pod install' first${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 3: Critical files
echo "✓ Checking critical files..."
if [ -f "ios/Runner/Info.plist" ]; then
    echo -e "${GREEN}✓ Info.plist exists${NC}"
else
    echo -e "${RED}✗ Info.plist not found${NC}"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${GREEN}✓ GoogleService-Info.plist exists${NC}"
else
    echo -e "${YELLOW}⚠ GoogleService-Info.plist not found (required for Firebase)${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

if [ -f "ios/Podfile" ]; then
    echo -e "${GREEN}✓ Podfile exists${NC}"
else
    echo -e "${RED}✗ Podfile not found${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 4: Pods installation
echo "✓ Checking CocoaPods..."
if [ -d "ios/Pods" ]; then
    echo -e "${GREEN}✓ Pods directory exists${NC}"
else
    echo -e "${YELLOW}⚠ Pods not installed - run 'cd ios && pod install'${NC}"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Check 5: Info.plist required keys
echo "✓ Checking Info.plist required keys..."
if [ -f "ios/Runner/Info.plist" ]; then
    # Check for common required keys
    if grep -q "CFBundleIdentifier" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✓ Bundle Identifier configured${NC}"
    else
        echo -e "${RED}✗ Bundle Identifier not found${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    if grep -q "GADApplicationIdentifier" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✓ AdMob App ID configured${NC}"
    else
        echo -e "${YELLOW}⚠ AdMob App ID not found (add if using ads)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    if grep -q "LSApplicationQueriesSchemes" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✓ URL Schemes configured${NC}"
    else
        echo -e "${YELLOW}⚠ URL Schemes not configured (may be needed for url_launcher)${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
fi
echo ""

# Check 6: App Icons
echo "✓ Checking App Icons..."
if [ -d "ios/Runner/Assets.xcassets/AppIcon.appiconset" ]; then
    ICON_COUNT=$(find ios/Runner/Assets.xcassets/AppIcon.appiconset -name "*.png" | wc -l)
    if [ $ICON_COUNT -gt 5 ]; then
        echo -e "${GREEN}✓ App icons found ($ICON_COUNT images)${NC}"
    else
        echo -e "${YELLOW}⚠ Few app icons found ($ICON_COUNT) - may need more sizes${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${RED}✗ AppIcon asset catalog not found${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 7: Build configuration
echo "✓ Checking build configuration..."
if [ -f "pubspec.yaml" ]; then
    echo -e "${GREEN}✓ pubspec.yaml exists${NC}"
    
    # Extract version info
    VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')
    if [ ! -z "$VERSION" ]; then
        echo -e "${GREEN}✓ App version: $VERSION${NC}"
    else
        echo -e "${YELLOW}⚠ Version not found in pubspec.yaml${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${RED}✗ pubspec.yaml not found${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Summary
echo "=========================================="
echo "Summary:"
echo "=========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! Ready to archive.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Open ios/Runner.xcworkspace in Xcode"
    echo "2. Select 'Any iOS Device' in device dropdown"
    echo "3. Product → Archive"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Found $WARNINGS warning(s) but no errors.${NC}"
    echo -e "${YELLOW}⚠ Review warnings before archiving.${NC}"
else
    echo -e "${RED}✗ Found $ERRORS error(s) and $WARNINGS warning(s).${NC}"
    echo -e "${RED}✗ Fix errors before archiving.${NC}"
fi
echo ""

# Recommended commands
echo "Recommended pre-archive commands:"
echo "=========================================="
echo "# Clean and rebuild"
echo "flutter clean"
echo "flutter pub get"
echo "cd ios"
echo "pod install"
echo "cd .."
echo "flutter build ios --release"
echo ""

# Exit with error if there are errors
if [ $ERRORS -gt 0 ]; then
    exit 1
else
    exit 0
fi
