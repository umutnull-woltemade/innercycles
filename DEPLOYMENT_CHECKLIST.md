# iOS Deployment Checklist & Fixes

## Your App's Required Configurations

Based on your plugins, here are the critical deployment requirements:

### 1. Info.plist Requirements

Your app uses these plugins that require Info.plist entries:

#### **Firebase Crashlytics & Core**
No specific Info.plist entries required, but GoogleService-Info.plist must be present.

#### **Flutter Local Notifications**
Add if not present:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

#### **Google Mobile Ads**
Add:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXX~YYYYYYYYYY</string>
<key>SKAdNetworkItems</key>
<array>
    <!-- Add SKAdNetwork IDs from Google -->
</array>
```

#### **Sign in with Apple**
No Info.plist required, but needs capability in Xcode.

#### **URL Launcher**
Add:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>https</string>
    <string>http</string>
    <string>mailto</string>
    <string>tel</string>
    <string>sms</string>
</array>
```

#### **App Links**
Add:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
</dict>
```

---

## 2. Required Capabilities (Signing & Capabilities Tab)

✅ **Sign in with Apple** - REQUIRED
✅ **Push Notifications** - REQUIRED (for local notifications)
✅ **Associated Domains** - May be required for app_links

---

## 3. Bundle Identifier & Versioning

**Location:** Runner Target → General Tab

- **Bundle Identifier:** Must match App Store Connect (e.g., com.yourcompany.appname)
- **Version:** User-facing version (e.g., 1.0.0)
- **Build:** Increment for each upload (e.g., 1, 2, 3...)

---

## 4. Deployment Target

**Minimum iOS Version:** Check your pubspec.yaml and set appropriately
- Most Flutter apps: iOS 12.0+
- RevenueCat (purchases_flutter): iOS 13.0+
- Sign in with Apple: iOS 13.0+

**Recommended:** Set to **iOS 13.0** or higher

---

## 5. Build Settings to Check

### Release Configuration
1. Open Runner.xcworkspace (NOT Runner.xcodeproj)
2. Runner Target → Build Settings
3. Search for these:

**Strip Debug Symbols:** YES (Release only)
**Enable Bitcode:** NO (Flutter doesn't support it)
**Validate Workspace:** YES

---

## 6. GoogleService-Info.plist

**Location:** ios/Runner/GoogleService-Info.plist

This file MUST be present for Firebase to work. Get it from:
- Firebase Console → Project Settings → iOS App → Download

**Xcode Setup:**
- File must be in Runner folder
- Must be added to Runner target (check target membership)

---

## 7. App Icons

**Location:** Runner → Assets.xcassets → AppIcon

Required sizes:
- iPhone: 20pt (2x, 3x), 29pt (2x, 3x), 40pt (2x, 3x), 60pt (2x, 3x)
- iPad: Additional sizes if supporting iPad
- App Store: 1024x1024 (no alpha channel)

---

## 8. Common Archive Errors & Fixes

### Error: "Failed to register bundle identifier"
**Fix:** Bundle ID already exists or team doesn't have permission
- Check App Store Connect for existing app
- Verify team selection in Signing & Capabilities

### Error: "Provisioning profile doesn't include signing certificate"
**Fix:** 
1. Xcode → Settings → Accounts → Download Manual Profiles
2. Or: Enable "Automatically manage signing"

### Error: "Missing GoogleService-Info.plist"
**Fix:**
1. Download from Firebase Console
2. Drag into ios/Runner folder in Xcode
3. Check "Copy items if needed"
4. Select Runner target

### Error: "Missing Info.plist values"
**Fix:** Add all required keys listed in section 1 above

### Error: "Invalid Bundle - Missing required icons"
**Fix:** Generate all required icon sizes at https://appicon.co/

### Error: "App Store Connect operation error"
**Fix:**
- Increment build number
- Check App Store Connect for app status
- Verify Apple Developer Program membership is active

---

## 9. Pre-Archive Checklist

Run these commands in your project directory:

```bash
# Clean Flutter build
flutter clean

# Get dependencies
flutter pub get

# Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod install
pod update
cd ..

# Build to check for errors
flutter build ios --release
```

---

## 10. Archive Process (Step by Step)

1. ✅ Open ios/Runner.xcworkspace in Xcode
2. ✅ Select "Runner" in left sidebar (project navigator)
3. ✅ Select "Runner" under TARGETS
4. ✅ Click "General" tab first:
   - Set Display Name
   - Set Bundle Identifier
   - Set Version & Build number
   - Set Deployment Target (iOS 13.0+)
5. ✅ Click "Signing & Capabilities" tab:
   - Check "Automatically manage signing"
   - Select your Team
   - Verify capabilities: Sign in with Apple, Push Notifications
6. ✅ Device dropdown → "Any iOS Device (arm64)"
7. ✅ Menu: Product → Clean Build Folder (⇧⌘K)
8. ✅ Menu: Product → Archive
9. ✅ Wait for archive (5-15 minutes)
10. ✅ In Organizer:
    - Click "Distribute App"
    - Select "App Store Connect"
    - Select "Upload"
    - Click "Next" through options
    - Wait for upload
    - Check for email confirmation from Apple

---

## 11. Post-Upload Steps

### In App Store Connect:
1. Go to your app → TestFlight
2. Wait for processing (10-60 minutes)
3. Answer Export Compliance questions
4. Add to testing group
5. Test via TestFlight before submitting for review

### Export Compliance:
Most apps answer "No" to encryption if:
- Only using HTTPS
- No custom encryption
- Standard Flutter/iOS encryption only

---

## 12. Common Rejection Reasons & Prevention

### Sign in with Apple
If you offer Google/Email sign in, you MUST offer Sign in with Apple.
- Already included in your plugins ✅

### Privacy Policy
Required if you collect any user data.
- Add URL in App Store Connect

### App Privacy Details
Must declare all data collection:
- Firebase Analytics
- AdMob
- RevenueCat
- Crashlytics

### Permissions Descriptions
Every permission needs a clear description in Info.plist:
```xml
<key>NSUserTrackingUsageDescription</key>
<string>We use data to show you personalized ads</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Allow access to save/share content</string>
```

---

## Quick Command Reference

```bash
# Flutter
flutter clean
flutter pub get
flutter build ios --release

# CocoaPods
cd ios
pod install
pod update
pod deintegrate  # Nuclear option if pods broken
pod install
cd ..

# Xcode CLI
xcodebuild clean -workspace ios/Runner.xcworkspace -scheme Runner
xcodebuild archive -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release -archivePath build/Runner.xcarchive
```

---

## Need Help?

If you encounter specific errors, share:
1. The exact error message
2. Which step you're on
3. Screenshots of Signing & Capabilities tab
4. Your Info.plist file

---

## Files to Check/Create

Run this in terminal to verify structure:
```bash
# Check if critical files exist
ls -la ios/Runner/Info.plist
ls -la ios/Runner/GoogleService-Info.plist
ls -la ios/Podfile
ls -la ios/Runner.xcworkspace
```
