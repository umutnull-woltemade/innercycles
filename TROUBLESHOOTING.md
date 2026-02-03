# 🔧 iOS Deployment Troubleshooting Guide

## 🚨 Archive Errors

### Error: "No such module 'Firebase'"
**Cause:** CocoaPods not installed or outdated

**Fix:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod deintegrate
pod install
cd ..
# Clean Flutter
flutter clean
flutter pub get
```

**Then:** Close and reopen Runner.xcworkspace in Xcode

---

### Error: "Command PhaseScriptExecution failed"
**Cause:** Build script error, often related to pods

**Fix 1:** Clean build folder
- Xcode → Product → Clean Build Folder (⇧⌘K)

**Fix 2:** Delete DerivedData
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

**Fix 3:** Reinstall pods
```bash
cd ios
rm -rf Pods Podfile.lock .symlinks
pod install
cd ..
```

---

### Error: "Bitcode not supported"
**Cause:** Flutter doesn't support Bitcode

**Fix:**
1. Runner Target → Build Settings
2. Search "bitcode"
3. Set **Enable Bitcode** to **NO**
4. Do this for both Debug and Release

---

### Error: "Missing GoogleService-Info.plist"
**Cause:** Firebase config file not in project

**Fix:**
1. Download from Firebase Console: https://console.firebase.google.com
2. In Xcode, right-click Runner folder
3. Add Files to "Runner"
4. Select GoogleService-Info.plist
5. ☑️ Check "Copy items if needed"
6. ☑️ Check Runner target
7. Click Add

**Verify:** File should appear in Project Navigator under Runner folder

---

### Error: "Archive button is greyed out"
**Cause:** Wrong device selected

**Fix:**
- Device dropdown must show "Any iOS Device (arm64)"
- NOT "iPhone Simulator"
- NOT specific device name

---

### Error: "Code signing requires a development team"
**Cause:** No team selected or not logged in

**Fix:**
1. Xcode → Settings → Accounts
2. Click + to add Apple ID
3. Sign in with Apple Developer account
4. Back to Runner → Signing & Capabilities
5. Team dropdown → Select your team
6. ☑️ Check "Automatically manage signing"

---

### Error: "Failed to register bundle identifier"
**Cause:** Bundle ID already in use or not created

**Fix Option 1:** Change Bundle ID
1. Runner Target → General
2. Change **Bundle Identifier** to something unique
3. Update in App Store Connect too

**Fix Option 2:** Create app in App Store Connect
1. Go to: https://appstoreconnect.apple.com
2. My Apps → + → New App
3. Use exact same Bundle ID as in Xcode

---

### Error: "Provisioning profile doesn't include signing certificate"
**Cause:** Certificate/profile mismatch

**Fix:**
1. Xcode → Settings → Accounts
2. Click your Apple ID
3. Click "Manage Certificates"
4. If no certificates, click + → "Apple Distribution"
5. Back to project: Signing & Capabilities
6. ☐ Uncheck "Automatically manage signing"
7. ☑️ Re-check "Automatically manage signing"
8. Wait for provisioning profile to download

**Nuclear option:**
```bash
# Revoke all certificates and start fresh
# WARNING: This affects ALL your apps
```
1. developer.apple.com → Certificates
2. Revoke old certificates
3. Let Xcode recreate them

---

### Error: "Missing required icon file"
**Cause:** App icon sizes missing

**Fix:**
1. Generate all sizes at: https://appicon.co/
2. Upload a 1024x1024 PNG
3. Download iOS icons
4. In Xcode: Runner → Assets.xcassets → AppIcon
5. Drag icons to appropriate slots

**Required sizes:**
- 20pt (2x, 3x)
- 29pt (2x, 3x)
- 40pt (2x, 3x)
- 60pt (2x, 3x)
- 1024pt (1x - no alpha channel!)

---

## 📤 Upload Errors

### Error: "Invalid Bundle - Missing Info.plist key"
**Cause:** Required key missing from Info.plist

**Common missing keys:**

```xml
<!-- AdMob App ID -->
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXX~YYYYYYYY</string>

<!-- URL Schemes -->
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>https</string>
    <string>http</string>
</array>

<!-- Background Modes -->
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
```

**Fix:** Add missing keys to ios/Runner/Info.plist

---

### Error: "App Store Connect operation failed"
**Cause:** Various - check email for details

**Fix:**
1. Check email from Apple
2. Increment build number
3. Fix specific issue mentioned
4. Re-archive and upload

---

### Error: "Asset validation failed"
**Cause:** Icons have alpha channel or wrong size

**Fix:**
1. App Store icon (1024x1024) must have NO alpha channel
2. Use Preview app on Mac:
   - Open icon
   - File → Export
   - Uncheck "Alpha"
   - Save
3. Replace in Xcode

---

### Error: "This bundle is invalid. The bundle identifier contains disallowed characters"
**Cause:** Invalid characters in Bundle ID

**Fix:**
- Only use: letters, numbers, hyphen (-), period (.)
- Format: com.company.appname
- Must start with letter
- No spaces, underscores, or special chars

---

## 🧪 TestFlight Errors

### Error: "Missing Compliance"
**Cause:** Export compliance not answered

**Fix:**
1. App Store Connect → TestFlight
2. Click yellow warning icon
3. Answer questions:
   - "Does your app use encryption?" 
   - Usually: NO (if only HTTPS)
   - Or: YES → Is it exempt? → YES (if using standard iOS encryption)

---

### Error: "Missing Beta App Description"
**Cause:** TestFlight requires description

**Fix:**
1. TestFlight → Test Information
2. Add Beta App Description
3. Add Feedback Email
4. Save

---

### Error: "Build not appearing in TestFlight"
**Cause:** Still processing or failed

**Fix:**
1. Wait 10-60 minutes
2. Check email for "processed" or "invalid" message
3. If "invalid", check email for reason
4. Fix issue and re-upload

---

## 🔐 Capability Errors

### Error: "Signing for 'Runner' requires the 'Sign in with Apple' capability"
**Cause:** Capability not enabled in Xcode

**Fix:**
1. Runner → Signing & Capabilities
2. Click + Capability
3. Add "Sign in with Apple"
4. Ensure it shows green checkmark

---

### Error: "The entitlements specified in your application's Code Signing Entitlements file do not match"
**Cause:** Entitlements mismatch between Xcode and App Store Connect

**Fix:**
1. Check capabilities in Xcode
2. Check in developer.apple.com:
   - Identifiers → Your App ID → Capabilities
3. Ensure they match
4. If not, update in both places
5. Delete and re-create provisioning profile

---

## 🐛 Runtime Errors (After Install)

### Error: AdMob ads not showing
**Cause:** Missing GADApplicationIdentifier

**Fix:**
1. Add to Info.plist:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXX~YYYYY</string>
```
2. Get your App ID from: https://apps.admob.com
3. Re-build and upload

---

### Error: Firebase not working
**Cause:** GoogleService-Info.plist not included in bundle

**Fix:**
1. Open ios/Runner.xcworkspace
2. Find GoogleService-Info.plist in Project Navigator
3. Right panel → Target Membership
4. ☑️ Check "Runner"
5. Re-archive

---

### Error: In-app purchases not working
**Cause:** Signed with wrong profile or sandbox issue

**Fix:**
1. Test in sandbox with Test Apple ID
2. Ensure StoreKit Configuration is correct
3. Verify products exist in App Store Connect
4. Check Bundle ID matches exactly
5. Test on real device (not simulator)

---

### Error: Push notifications not working
**Cause:** Missing capability or APNs certificate

**Fix:**
1. Runner → Signing & Capabilities
2. ☑️ Add "Push Notifications"
3. developer.apple.com → Keys
4. Create APNs key for your app
5. Add key to Firebase Console (if using FCM)

---

## 🔍 Diagnostic Commands

### Check project structure
```bash
# Verify critical files
ls -la ios/Runner/Info.plist
ls -la ios/Runner/GoogleService-Info.plist
ls -la ios/Runner.xcworkspace
ls -la ios/Podfile

# Check pods
cd ios && pod --version
```

### Check Flutter setup
```bash
flutter doctor -v
flutter clean
flutter pub get
```

### Check Xcode
```bash
# Xcode version
xcodebuild -version

# Available SDKs
xcodebuild -showsdks

# Build for testing
cd ios
xcodebuild clean -workspace Runner.xcworkspace -scheme Runner
```

### Check certificates
```bash
# List installed certificates
security find-identity -v -p codesigning
```

---

## 🆘 Still Stuck?

### Gather debugging info:

1. **Build logs:**
   - Xcode → View → Navigators → Show Report Navigator (⌘9)
   - Copy error text

2. **Info.plist:**
   ```bash
   cat ios/Runner/Info.plist
   ```

3. **Podfile:**
   ```bash
   cat ios/Podfile
   ```

4. **Flutter info:**
   ```bash
   flutter doctor -v > flutter_doctor.txt
   ```

5. **Screenshot:**
   - Signing & Capabilities tab
   - Error message

---

## 🔄 Nuclear Option: Start Fresh

If all else fails, recreate iOS project:

```bash
# ⚠️ WARNING: This deletes your iOS configuration!
# Backup first: cp -r ios ios_backup

cd ios
rm -rf Runner.xcworkspace Pods Podfile.lock .symlinks
cd ..

# Recreate
flutter create --platforms=ios .
cd ios
pod install
cd ..

# Then manually:
# - Re-add GoogleService-Info.plist
# - Re-configure Info.plist keys
# - Re-add capabilities in Xcode
# - Re-configure signing
```

---

## 📊 Common Success Rates

| Issue | Fix Success Rate | Time to Fix |
|-------|------------------|-------------|
| Missing pods | 95% | 5 min |
| Signing error | 90% | 10 min |
| Missing plist keys | 99% | 5 min |
| Icon issues | 99% | 10 min |
| Bitcode error | 100% | 2 min |
| Firebase config | 95% | 5 min |
| Bundle ID conflict | 80% | 15 min |
| Certificate issues | 70% | 30 min |

---

## ✅ Prevention Checklist

Run BEFORE every archive:

```bash
# 1. Clean everything
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# 2. Run deployment check
./check_deployment.sh

# 3. Test build
flutter build ios --release

# 4. Verify in Xcode
# - Open Runner.xcworkspace
# - Check Signing & Capabilities
# - Select "Any iOS Device"
# - Product → Clean Build Folder
# - Product → Archive
```

---

**Remember:** 90% of issues are:
1. Missing Info.plist keys
2. Pods not installed correctly
3. Wrong device selected
4. Missing GoogleService-Info.plist
5. Signing configuration

**Fix these first before digging deeper!**
