# 🚀 Quick Deployment Reference Card

## Before You Start

### ✅ Prerequisites Checklist
- [ ] Apple Developer Program membership ($99/year) active
- [ ] App created in App Store Connect
- [ ] Bundle ID matches between Xcode and App Store Connect
- [ ] All required capabilities enabled
- [ ] GoogleService-Info.plist added to project
- [ ] All app icons generated and added
- [ ] Privacy policy URL ready (if collecting data)
- [ ] App tested thoroughly on device

---

## 🔧 Fix Common Issues First

### 1. Clean Your Project
```bash
# Run these commands in terminal from project root
flutter clean
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter build ios --release
```

### 2. Check Info.plist Keys
**MUST HAVE for your app:**
- ✅ `GADApplicationIdentifier` - Your AdMob App ID
- ✅ `SKAdNetworkItems` - Array of ad network IDs
- ✅ `LSApplicationQueriesSchemes` - URL schemes array
- ✅ `UIBackgroundModes` - For notifications
- ✅ `NSUserTrackingUsageDescription` - For ad tracking

**Get them from:** See Info.plist.SAMPLE file

### 3. Enable Required Capabilities
Open Xcode → Runner Target → Signing & Capabilities:
- ✅ Sign in with Apple
- ✅ Push Notifications  
- ✅ Associated Domains (if using deep links)

---

## 📦 Archive Process (Step-by-Step)

### Step 1: Prepare Xcode
```bash
# Open the WORKSPACE, not the project
open ios/Runner.xcworkspace
```

### Step 2: Select Runner Target
1. Click "Runner" in left sidebar (project navigator)
2. Select "Runner" under TARGETS (not PROJECT)

### Step 3: General Tab Configuration
- **Display Name:** Your App's Display Name
- **Bundle Identifier:** com.yourcompany.appname (must match App Store Connect)
- **Version:** 1.0.0 (semantic versioning)
- **Build:** 1 (increment for each upload: 1, 2, 3...)
- **Deployment Target:** iOS 13.0 or higher (recommended)

### Step 4: Signing & Capabilities Tab
1. ☑️ Check "Automatically manage signing"
2. **Team:** Select your Apple Developer Team
3. **Provisioning Profile:** Should auto-populate
4. Verify all capabilities show green checkmarks

### Step 5: Build Settings (Optional Check)
Search for these settings:
- **Enable Bitcode:** NO (Flutter requirement)
- **Validate Workspace:** YES
- **Strip Debug Symbols:** YES (Release only)

### Step 6: Select Device
**Device dropdown** → "Any iOS Device (arm64)"
- Must NOT be simulator
- Must NOT be specific device

### Step 7: Clean Build
**Menu:** Product → Clean Build Folder (or press ⇧⌘K)

### Step 8: Archive
**Menu:** Product → Archive
- Wait 5-15 minutes
- Watch for errors in console
- Success = Organizer window appears

### Step 9: Organizer - Distribute
1. **Distribute App** button
2. Select **App Store Connect**
3. Select **Upload**
4. Click **Next**
5. Options screen:
   - ☑️ Upload symbols (recommended)
   - ☑️ Manage Version and Build Number (if desired)
6. Click **Upload**
7. Wait for upload (2-10 minutes)

### Step 10: Wait for Processing
- Check email for confirmation
- App Store Connect → TestFlight
- Wait 10-60 minutes for processing

---

## 🐛 Common Errors & Quick Fixes

| Error | Quick Fix |
|-------|-----------|
| "No such module" | `cd ios && pod install` |
| "Code signing error" | Check Team selection in Signing tab |
| "Bundle ID not found" | Create app in App Store Connect first |
| "Missing GoogleService-Info.plist" | Add file to ios/Runner in Xcode |
| "Invalid Info.plist" | Add missing keys (see Info.plist.SAMPLE) |
| "Missing icons" | Generate all sizes at appicon.co |
| "Bitcode error" | Set Enable Bitcode to NO |
| "Archive button disabled" | Select "Any iOS Device" not simulator |
| "Upload failed" | Increment build number and retry |

---

## 📝 After Upload

### 1. App Store Connect
Go to: https://appstoreconnect.apple.com

### 2. TestFlight
- **My Apps** → Your App → **TestFlight** tab
- Wait for "Processing" to complete
- Answer **Export Compliance** questions:
  - Usually "NO" if you only use standard HTTPS
  - "YES" if you have custom encryption

### 3. Internal Testing
- Add yourself to **App Store Connect Users**
- Add to **Internal Testing** group
- Install TestFlight app on device
- Test the build

### 4. App Privacy
**App Store** → **App Privacy** section

Declare data collection for:
- ✅ AdMob (user tracking, device info)
- ✅ Firebase Crashlytics (crash data)
- ✅ RevenueCat (purchase history)
- ✅ Firebase Analytics (usage data)

### 5. Submit for Review
- Fill in all app metadata
- Upload screenshots (use screenshots.app on Mac)
- Write description
- Set pricing
- Click **Submit for Review**

---

## 🔍 Verification Commands

Run before archiving:
```bash
# Check critical files exist
ls -la ios/Runner/Info.plist
ls -la ios/Runner/GoogleService-Info.plist
ls -la ios/Runner.xcworkspace

# Verify Flutter configuration
flutter doctor -v

# Build test
flutter build ios --release

# Run deployment check script
chmod +x check_deployment.sh
./check_deployment.sh
```

---

## 📱 AdMob Setup (CRITICAL)

### Get Your AdMob App ID
1. Go to: https://apps.admob.com
2. Select your app
3. Copy **App ID** (format: ca-app-pub-XXXXX~YYYYY)
4. Add to Info.plist:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXX~YYYYY</string>
```

### Get SKAdNetwork IDs
1. Go to: https://developers.google.com/admob/ios/quick-start#import_the_mobile_ads_sdk
2. Copy the complete SKAdNetworkItems array
3. Add to Info.plist

**Without these, AdMob will NOT work in production!**

---

## 🎯 Final Checklist

Before clicking "Submit for Review":

- [ ] Tested on real device via TestFlight
- [ ] All features work (in-app purchases, ads, notifications)
- [ ] No crashes or critical bugs
- [ ] Privacy policy URL added
- [ ] App Privacy details filled out
- [ ] Screenshots uploaded (all required sizes)
- [ ] App description written
- [ ] Keywords added
- [ ] Support URL provided
- [ ] Marketing URL (optional)
- [ ] Age rating completed
- [ ] Export compliance answered
- [ ] Version 1.0.0, Build 1 (or higher if resubmitting)

---

## 📞 Need Help?

If you get stuck:

1. **Run the check script:**
   ```bash
   ./check_deployment.sh
   ```

2. **Check build logs in Xcode:**
   - View → Navigators → Show Report Navigator (⌘9)
   - Click on latest Archive
   - Look for red errors

3. **Common resources:**
   - Flutter docs: https://docs.flutter.dev/deployment/ios
   - App Store Connect: https://appstoreconnect.apple.com
   - AdMob console: https://apps.admob.com
   - Firebase console: https://console.firebase.google.com

4. **Share with me:**
   - Exact error message
   - Screenshot of Signing & Capabilities tab
   - Info.plist file
   - Build logs

---

## 🚀 You've Got This!

**Average timeline:**
- Archive: 5-15 minutes
- Upload: 2-10 minutes  
- Processing: 10-60 minutes
- Review: 1-3 days (first submission)

**Remember:** Most apps get rejected on first try. Common reasons:
- Missing privacy policy
- Incomplete App Privacy details
- Missing Sign in with Apple (if you have other sign-in)
- Crashes on review device
- Missing permission descriptions

**Stay calm, fix issues, resubmit.** 💪
