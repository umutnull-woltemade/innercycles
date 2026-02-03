#!/bin/bash
# iOS Deployment - Quick Command Reference
# Save this file and use as a quick reference

# ============================================================================
# SETUP COMMANDS (Run Once)
# ============================================================================

# Make scripts executable
chmod +x deploy_ios.sh check_deployment.sh

# ============================================================================
# BEFORE EVERY ARCHIVE (Run These in Order)
# ============================================================================

# 1. Clean Flutter project
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Clean iOS build
cd ios
rm -rf Pods Podfile.lock build
pod install
cd ..

# 4. Test build (optional but recommended)
flutter build ios --release --no-codesign

# 5. Run automated deployment check
./deploy_ios.sh

# ============================================================================
# OPEN XCODE
# ============================================================================

# Always open workspace, not project!
open ios/Runner.xcworkspace

# ============================================================================
# XCODE COMMANDS (From Terminal)
# ============================================================================

# Clean build folder
xcodebuild clean -workspace ios/Runner.xcworkspace -scheme Runner

# Build for testing
xcodebuild build -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release -destination 'generic/platform=iOS'

# Archive (advanced - usually do this in Xcode GUI)
xcodebuild archive \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive

# ============================================================================
# VERIFICATION COMMANDS
# ============================================================================

# Check Flutter setup
flutter doctor -v

# Check CocoaPods version
pod --version

# Verify critical files exist
ls -la ios/Runner/Info.plist
ls -la ios/Runner/GoogleService-Info.plist
ls -la ios/Runner.xcworkspace

# Check Info.plist for required keys
grep -A 1 "GADApplicationIdentifier" ios/Runner/Info.plist
grep -A 1 "SKAdNetworkItems" ios/Runner/Info.plist

# Validate Info.plist XML
plutil -lint ios/Runner/Info.plist

# Check installed certificates
security find-identity -v -p codesigning

# ============================================================================
# TROUBLESHOOTING COMMANDS
# ============================================================================

# Nuclear option: Delete all build artifacts
flutter clean
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks ios/build
rm -rf build/
rm -rf ~/Library/Developer/Xcode/DerivedData

# Reinstall pods
cd ios
pod deintegrate
pod install
cd ..

# Update pods to latest versions
cd ios
pod update
cd ..

# Check for pod issues
cd ios
pod install --verbose
cd ..

# ============================================================================
# DIAGNOSTICS
# ============================================================================

# Flutter diagnostics
flutter doctor -v > flutter_diagnostics.txt
cat flutter_diagnostics.txt

# List installed simulators
xcrun simctl list devices

# Check Xcode version
xcodebuild -version

# Check available SDKs
xcodebuild -showsdks

# ============================================================================
# GIT COMMANDS (Version Control)
# ============================================================================

# Save working configuration
git add ios/
git add pubspec.yaml pubspec.lock
git commit -m "Configure iOS for deployment - Version X.X.X Build XX"

# Create tag for this release
git tag -a v1.0.0-build-1 -m "First production build"
git push origin v1.0.0-build-1

# ============================================================================
# APP STORE CONNECT
# ============================================================================

# Open App Store Connect (requires login)
open https://appstoreconnect.apple.com

# Open AdMob Console
open https://apps.admob.com

# Open Firebase Console
open https://console.firebase.google.com

# Open Apple Developer Portal
open https://developer.apple.com

# ============================================================================
# USEFUL FILE PATHS
# ============================================================================

# Info.plist
# Path: ios/Runner/Info.plist

# GoogleService-Info.plist
# Path: ios/Runner/GoogleService-Info.plist

# Podfile
# Path: ios/Podfile

# AppDelegate
# Path: ios/Runner/AppDelegate.swift

# Assets/Icons
# Path: ios/Runner/Assets.xcassets/AppIcon.appiconset

# ============================================================================
# QUICK FIXES
# ============================================================================

# Fix "No such module" error
cd ios && pod install && cd ..
# Then close and reopen Xcode

# Fix signing issues
# In Xcode: Signing & Capabilities → Uncheck/recheck "Automatically manage signing"

# Fix Bitcode error
# In Xcode: Build Settings → Search "bitcode" → Set to NO

# Increment build number (in pubspec.yaml)
# Change: version: 1.0.0+1
# To:     version: 1.0.0+2

# ============================================================================
# DEPLOYMENT WORKFLOW (Complete Process)
# ============================================================================

echo "🚀 Starting iOS Deployment Workflow..."

# Step 1: Clean
echo "📦 Cleaning project..."
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# Step 2: Get dependencies
echo "📥 Installing dependencies..."
flutter pub get

# Step 3: Test build
echo "🔨 Testing build..."
flutter build ios --release --no-codesign

# Step 4: Run checks
echo "✅ Running deployment checks..."
./deploy_ios.sh

# Step 5: Open Xcode
echo "🎯 Opening Xcode..."
open ios/Runner.xcworkspace

echo "
✅ Ready for Xcode!

Next steps in Xcode:
1. Select 'Any iOS Device (arm64)' from device dropdown
2. Runner Target → Signing & Capabilities → Select Team
3. Verify capabilities: Sign in with Apple, Push Notifications
4. Product → Clean Build Folder (⇧⌘K)
5. Product → Archive
6. In Organizer: Distribute App → App Store Connect → Upload

📚 For detailed instructions, see: QUICK_DEPLOYMENT_GUIDE.md
"

# ============================================================================
# TESTING COMMANDS
# ============================================================================

# Run Flutter tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# ============================================================================
# PERFORMANCE & SIZE
# ============================================================================

# Check app size
du -sh ios/build/Release-iphoneos/Runner.app

# Analyze build
flutter build ios --release --analyze-size

# ============================================================================
# ENVIRONMENT INFO
# ============================================================================

# Print all environment information
echo "Flutter version:"
flutter --version
echo ""
echo "Xcode version:"
xcodebuild -version
echo ""
echo "CocoaPods version:"
pod --version
echo ""
echo "Ruby version:"
ruby --version
echo ""
echo "Current directory:"
pwd
echo ""
echo "Flutter doctor:"
flutter doctor

# ============================================================================
# NOTES
# ============================================================================

# Always:
# - Run deploy_ios.sh before archiving
# - Increment build number for each upload
# - Test on TestFlight before App Store submission
# - Open .xcworkspace, not .xcodeproj
# - Select "Any iOS Device (arm64)" not simulator

# For help:
# - See START_HERE.md for overview
# - See QUICK_DEPLOYMENT_GUIDE.md for steps
# - See TROUBLESHOOTING.md for errors
# - See XCODE_CONFIGURATION.md for Xcode settings
