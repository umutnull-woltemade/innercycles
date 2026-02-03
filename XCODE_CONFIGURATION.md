# Xcode Configuration Checklist

## Open Xcode Workspace

```bash
open ios/Runner.xcworkspace
```

⚠️ **Important:** Always open the `.xcworkspace` file, NOT the `.xcodeproj` file!

---

## 1. Project Navigator Setup

### Select Runner
1. Click **Runner** (blue icon) in left sidebar
2. Under **TARGETS**, select **Runner** (not PROJECT)

You should see tabs: General, Signing & Capabilities, Resource Tags, Info, Build Settings, Build Phases, Build Rules

---

## 2. General Tab Configuration

### Identity Section

| Setting | Value | Notes |
|---------|-------|-------|
| **Display Name** | Your App Name | What users see on home screen |
| **Bundle Identifier** | com.yourcompany.appname | MUST match App Store Connect |
| **Version** | 1.0.0 | Semantic versioning (user-facing) |
| **Build** | 1 | Increment for EACH upload: 1, 2, 3... |

### Deployment Info Section

| Setting | Value | Notes |
|---------|-------|-------|
| **iPhone** | ☑️ Checked | |
| **iPad** | ☑️ Checked (if supporting iPad) | |
| **Deployment Target** | iOS 13.0 | Minimum (required for RevenueCat & Sign in with Apple) |
| **Device Orientation** | Portrait | Uncheck landscape if not needed |
| **Status Bar Style** | Default | Or choose based on your app |
| **Hide Status Bar** | ☐ Unchecked | Usually leave visible |
| **Requires Full Screen** | ☑️ Checked (iPhone) | Recommended for iPhone apps |

### App Icons and Launch Screen

| Setting | Value | Notes |
|---------|-------|-------|
| **App Icons Source** | AppIcon | Should show preview of icons |
| **Launch Screen File** | LaunchScreen | Default Flutter launch screen |

**If icons missing:**
1. Generate at https://appicon.co/
2. Drag into Assets.xcassets/AppIcon.appiconset
3. All slots should be filled (no yellow warnings)

---

## 3. Signing & Capabilities Tab ⚠️ CRITICAL

### Signing Section

| Setting | Value | Notes |
|---------|-------|-------|
| **Automatically manage signing** | ☑️ CHECKED | Recommended for most cases |
| **Team** | Your Apple Developer Team | Select from dropdown |
| **Provisioning Profile** | Xcode Managed Profile | Auto-populated when team selected |
| **Signing Certificate** | Apple Distribution | Auto-populated |

**Troubleshooting:**
- If team dropdown empty: Xcode → Settings → Accounts → Add Apple ID
- If certificate error: Uncheck/recheck "Automatically manage signing"
- If still issues: See TROUBLESHOOTING.md

### Required Capabilities (Click + Capability to add)

#### ✅ Sign in with Apple
- **Required:** YES (if you have ANY other sign-in method)
- **Status:** Should show green checkmark
- **Entitlement:** `com.apple.developer.applesignin`

**To Add:**
1. Click **+ Capability**
2. Search "Sign in with Apple"
3. Double-click to add
4. Verify green checkmark appears

#### ✅ Push Notifications
- **Required:** YES (for flutter_local_notifications)
- **Status:** Should show green checkmark
- **Entitlement:** `aps-environment`

**To Add:**
1. Click **+ Capability**
2. Search "Push Notifications"
3. Double-click to add
4. Verify green checkmark appears

#### 🔵 Associated Domains (Optional - only if using deep links)
- **Required:** Only if using app_links for deep linking
- **Domains format:** `applinks:yourdomain.com`
- **Requires:** Apple App Site Association (AASA) file on your server

**To Add:**
1. Click **+ Capability**
2. Search "Associated Domains"
3. Add domain: `applinks:yourdomain.com` (replace with your domain)

#### 🔵 Background Modes (May already be configured)
- Usually configured via Info.plist
- If needed: Enable "Remote notifications"

### Verification
All capabilities should show:
- ✅ Green checkmark
- No red X or yellow warning

If you see errors, check:
- App ID in developer.apple.com has matching capabilities
- Provisioning profile is up to date
- Team selection is correct

---

## 4. Resource Tags Tab

Usually no changes needed - skip this tab.

---

## 5. Info Tab

This shows the same information as Info.plist. You can edit here or in the plist file directly.

### Critical Keys to Verify

Click **+** to expand any section.

#### Privacy - Tracking Usage Description
- **Key:** `NSUserTrackingUsageDescription`
- **Value:** "We use your data to provide personalized ads and improve your experience."
- **Required for:** AdMob personalized ads (iOS 14+)

#### App Transport Security Settings
- **Key:** `NSAppTransportSecurity`
- **Should contain:** `NSAllowsArbitraryLoads` set to `NO` (secure)

#### Queried URL Schemes
- **Key:** `LSApplicationQueriesSchemes`
- **Should contain:** Array with `https`, `http`, `mailto`, `tel`

#### GAD Application Identifier
- **Key:** `GADApplicationIdentifier`
- **Value:** Your AdMob App ID (ca-app-pub-XXXXX~YYYYY)
- **Get from:** https://apps.admob.com

#### SKAdNetwork Items
- **Key:** `SKAdNetworkItems`
- **Should contain:** Array of 40+ ad network IDs
- **See:** SKADNETWORK_IDS.md for complete list

**Prefer editing plist as source code?**
- Right-click Info.plist → Open As → Source Code
- More precise control
- See Info.plist.SAMPLE for copy-paste ready format

---

## 6. Build Settings Tab ⚠️ IMPORTANT

**Filter:** Type in search box to find specific settings

### Critical Settings

| Setting | Configuration | Value | Notes |
|---------|---------------|-------|-------|
| **Enable Bitcode** | All | **NO** | Flutter doesn't support bitcode |
| **Strip Debug Symbols** | Release | **YES** | Reduces app size |
| **Debug Information Format** | Release | **DWARF with dSYM File** | For crashlytics |
| **Optimization Level** | Release | **Fastest, Smallest [-Os]** | |
| **Validate Workspace** | All | **YES** | Recommended |
| **Dead Code Stripping** | Release | **YES** | Reduces size |

### How to Change Settings

1. Click **Build Settings** tab
2. Ensure **All** and **Combined** are selected at top
3. Use search box to find setting name
4. Double-click value to edit
5. If shows dropdown, select from options
6. If shows both Debug/Release, ensure Release is set correctly

### Enable Bitcode = NO (MOST IMPORTANT)

**Why:** Flutter doesn't compile with bitcode enabled.

**Steps:**
1. Search: `bitcode`
2. Find: **Enable Bitcode**
3. For **Debug**: Set to **NO**
4. For **Release**: Set to **NO**

If you see "Yes" anywhere, the build will fail!

---

## 7. Build Phases Tab

Usually you don't need to change anything here. These are configured by Flutter and CocoaPods.

### Should See These Phases:

1. **Dependencies** - Manage dependencies
2. **Thin Binary** - Flutter framework thinning
3. **Run Script** - Flutter build script (xcode_backend.sh)
4. **[CP] Check Pods Manifest.lock** - CocoaPods verification
5. **Compile Sources** - AppDelegate.swift, etc.
6. **Link Binary With Libraries** - Flutter frameworks, pods
7. **[CP] Embed Pods Frameworks** - CocoaPods frameworks
8. **[CP] Copy Pods Resources** - CocoaPods resources
9. **Copy Bundle Resources** - App resources (assets, plists)

**If missing or errors:**
```bash
cd ios
pod deintegrate
pod install
cd ..
```

---

## 8. Device Selection (Top Bar)

**Critical for archiving!**

### Correct Settings:

| Setting | Value |
|---------|-------|
| **Scheme** | Runner |
| **Device** | Any iOS Device (arm64) |

### Wrong Settings (Archive will be disabled):

❌ iPhone 15 Simulator
❌ iPhone 14 Pro Simulator  
❌ Any Simulator
❌ Specific device name (e.g., "John's iPhone")

**If you don't see "Any iOS Device":**
1. Plug in a real iOS device
2. Or: Select device dropdown → "Add Additional Simulators..." → Devices tab → Add device
3. Then select "Any iOS Device (arm64)"

---

## 9. Pre-Archive Checklist

Before clicking Product → Archive:

### General Tab
- [ ] Bundle Identifier is correct and matches App Store Connect
- [ ] Version number is set (e.g., 1.0.0)
- [ ] Build number is set and incremented (e.g., 1)
- [ ] Deployment target is iOS 13.0 or higher
- [ ] App icons show no warnings

### Signing & Capabilities Tab
- [ ] Team is selected
- [ ] "Automatically manage signing" is checked
- [ ] Sign in with Apple capability added (green checkmark)
- [ ] Push Notifications capability added (green checkmark)
- [ ] No red X or yellow warnings shown

### Info Tab / Info.plist
- [ ] GADApplicationIdentifier added with real AdMob App ID
- [ ] SKAdNetworkItems array added
- [ ] NSUserTrackingUsageDescription added
- [ ] LSApplicationQueriesSchemes array added
- [ ] UIBackgroundModes array added

### Build Settings Tab
- [ ] Enable Bitcode = NO (for both Debug and Release)

### Files in Project Navigator
- [ ] GoogleService-Info.plist is present under Runner folder
- [ ] GoogleService-Info.plist has Runner target checked (right panel)
- [ ] AppDelegate.swift is present
- [ ] Assets.xcassets/AppIcon.appiconset has all icon sizes

### Device Selection
- [ ] "Any iOS Device (arm64)" is selected (not simulator!)

### Pre-Build
- [ ] Run: `flutter clean && flutter pub get`
- [ ] Run: `cd ios && pod install && cd ..`
- [ ] Run: `flutter build ios --release --no-codesign`
- [ ] No build errors

---

## 10. Archive Process

### Clean Build Folder
1. **Menu:** Product → Clean Build Folder
2. **Keyboard:** ⇧⌘K (Shift-Command-K)
3. Wait for "Clean Finished"

### Start Archive
1. **Menu:** Product → Archive
2. **Keyboard:** None (must use menu)
3. **Wait:** 5-15 minutes (watch progress in top bar)

### During Archive
- Don't close Xcode
- Don't switch device selection
- Watch for errors in Report Navigator (⌘9)

### After Archive Success
- **Organizer window** appears automatically
- Your archive appears in list with:
  - App name
  - Version and build number
  - Date and time
  - Size
- If it doesn't appear: Window → Organizer → Archives tab

---

## 11. Common Xcode Errors

### "Signing for 'Runner' requires a development team"
**Fix:** Signing & Capabilities → Select Team from dropdown

### "Archive button greyed out"
**Fix:** Select "Any iOS Device (arm64)" instead of simulator

### "No such module 'Firebase'"
**Fix:** 
```bash
cd ios && pod install && cd ..
```
Then close and reopen Xcode workspace

### "Bitcode error"
**Fix:** Build Settings → Enable Bitcode → Set to NO

### "Provisioning profile doesn't match"
**Fix:** 
1. Uncheck "Automatically manage signing"
2. Re-check it
3. Wait for Xcode to download profiles

### "Command PhaseScriptExecution failed"
**Fix:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```
Then Product → Clean Build Folder

---

## 12. Quick Reference Commands

### Open Workspace
```bash
open ios/Runner.xcworkspace
```

### Reset Pods
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### Clean Flutter
```bash
flutter clean
flutter pub get
```

### Clean Xcode DerivedData
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### Check Certificates
```bash
security find-identity -v -p codesigning
```

---

## 13. Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| **Build** | ⌘B |
| **Clean Build Folder** | ⇧⌘K |
| **Run** | ⌘R |
| **Stop** | ⌘. |
| **Show Project Navigator** | ⌘1 |
| **Show Report Navigator** | ⌘9 |
| **Quick Open** | ⇧⌘O |
| **Preferences** | ⌘, |
| **Organizer** | ⇧⌘⌥O |

---

## 14. Save This Configuration

Once you have everything working:

1. Commit to version control:
   ```bash
   git add ios/
   git commit -m "Configure iOS for deployment"
   ```

2. Document your settings:
   - Bundle ID
   - Team ID
   - Capabilities enabled
   - Build/version numbers used

3. Keep a deployment log:
   - Date archived
   - Version/build uploaded
   - Any issues encountered
   - Time to process

---

## ✅ Ready to Archive?

If all checks pass:

1. ✅ Device shows "Any iOS Device (arm64)"
2. ✅ Product → Clean Build Folder (⇧⌘K)
3. ✅ Product → Archive
4. ✅ Wait for Organizer window
5. ✅ Continue with distribution (see QUICK_DEPLOYMENT_GUIDE.md)

**Good luck!** 🚀
