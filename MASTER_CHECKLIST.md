# 📋 iOS Deployment Master Checklist

**Print this and check off each item as you go!**

Date: _____________ | App Version: _____________ | Build: _____________

---

## ✅ Phase 1: Pre-Configuration (Do Once)

### Apple Developer Account
- [ ] Apple Developer Program active ($99/year paid)
- [ ] Apple ID added to Xcode (Xcode → Settings → Accounts)
- [ ] Certificates downloaded (should happen automatically)

### App Store Connect Setup
- [ ] App created in App Store Connect
- [ ] Bundle ID matches Xcode (com.yourcompany.appname)
- [ ] App name reserved
- [ ] Primary language set
- [ ] SKU created

### AdMob Configuration
- [ ] AdMob account created
- [ ] iOS app registered in AdMob
- [ ] App ID obtained (ca-app-pub-XXXXX~YYYYY)
- [ ] Ad units created and IDs saved

### Firebase Setup
- [ ] Firebase project created
- [ ] iOS app added to Firebase project
- [ ] GoogleService-Info.plist downloaded
- [ ] Bundle ID matches in Firebase console

---

## ✅ Phase 2: Project Configuration (Do Once, Verify Each Build)

### Files Check
- [ ] ios/Runner/Info.plist exists
- [ ] ios/Runner/GoogleService-Info.plist exists
- [ ] ios/Runner.xcworkspace exists (not just .xcodeproj)
- [ ] ios/Podfile exists
- [ ] ios/Runner/Assets.xcassets/AppIcon.appiconset exists

### Info.plist Keys (See Info.plist.SAMPLE)
- [ ] GADApplicationIdentifier with real AdMob App ID
- [ ] SKAdNetworkItems array with 40+ network IDs
- [ ] LSApplicationQueriesSchemes array (https, http, mailto, tel)
- [ ] UIBackgroundModes array (remote-notification)
- [ ] NSUserTrackingUsageDescription with clear message
- [ ] CFBundleIdentifier set to $(PRODUCT_BUNDLE_IDENTIFIER)
- [ ] CFBundleShortVersionString set to $(FLUTTER_BUILD_NAME)
- [ ] CFBundleVersion set to $(FLUTTER_BUILD_NUMBER)

### App Icons (Generate at appicon.co)
- [ ] 1024x1024 (App Store, no alpha channel!)
- [ ] 60pt @2x (120x120) - iPhone App
- [ ] 60pt @3x (180x180) - iPhone App
- [ ] 40pt @2x (80x80) - iPhone Spotlight
- [ ] 40pt @3x (120x120) - iPhone Spotlight
- [ ] 29pt @2x (58x58) - iPhone Settings
- [ ] 29pt @3x (87x87) - iPhone Settings
- [ ] 20pt @2x (40x40) - iPhone Notification
- [ ] 20pt @3x (60x60) - iPhone Notification
- [ ] All icon slots filled (no yellow warnings in Xcode)

### Code Check
- [ ] AppDelegate.swift exists and updated
- [ ] GeneratedPluginRegistrant imported
- [ ] No obvious build errors in Dart code
- [ ] pubspec.yaml version set correctly (e.g., version: 1.0.0+1)

---

## ✅ Phase 3: Terminal Commands (Do Before Each Archive)

### Clean Everything
```bash
cd /path/to/your/flutter/project

# Run these commands in order:
```

- [ ] `flutter clean`
- [ ] `flutter pub get`
- [ ] `cd ios`
- [ ] `rm -rf Pods Podfile.lock`
- [ ] `pod install` (wait for completion)
- [ ] `cd ..`
- [ ] `flutter build ios --release --no-codesign`

### Run Deployment Script
- [ ] `chmod +x deploy_ios.sh` (first time only)
- [ ] `./deploy_ios.sh`
- [ ] Script passed with 0 errors
- [ ] Script passed with 0 warnings (or warnings acknowledged)

---

## ✅ Phase 4: Xcode Configuration (Verify Before Archive)

### Open Xcode
- [ ] Opened: `open ios/Runner.xcworkspace` (NOT .xcodeproj!)
- [ ] Xcode fully loaded (no indexing in progress)

### Project Navigator
- [ ] Selected "Runner" (blue icon) in left sidebar
- [ ] Under TARGETS, selected "Runner" (not PROJECT)

### General Tab
- [ ] Display Name: ________________
- [ ] Bundle Identifier: ________________ (must match App Store Connect!)
- [ ] Version: ________ (e.g., 1.0.0)
- [ ] Build: ________ (increment each upload: 1, 2, 3...)
- [ ] Deployment Target: iOS 13.0 or higher
- [ ] App Icons: All slots filled, no warnings

### Signing & Capabilities Tab
- [ ] "Automatically manage signing" CHECKED
- [ ] Team: ________________ (your Apple Developer team selected)
- [ ] Provisioning Profile: Shows "Xcode Managed Profile"
- [ ] Sign in with Apple capability added (GREEN checkmark)
- [ ] Push Notifications capability added (GREEN checkmark)
- [ ] Associated Domains (optional, only if using deep links)
- [ ] NO red X marks
- [ ] NO yellow warnings

### Build Settings Tab
- [ ] Searched for "bitcode"
- [ ] Enable Bitcode set to NO for Debug
- [ ] Enable Bitcode set to NO for Release

### Info Tab (or Info.plist)
- [ ] GADApplicationIdentifier present and correct
- [ ] SKAdNetworkItems present with full array
- [ ] NSUserTrackingUsageDescription present
- [ ] No red errors shown

### Project Navigator (Files)
- [ ] GoogleService-Info.plist under Runner folder
- [ ] GoogleService-Info.plist target membership: Runner CHECKED (right panel)
- [ ] Assets.xcassets present
- [ ] AppIcon.appiconset shows icon previews

### Device Selection (Top Bar)
- [ ] Scheme: Runner
- [ ] Device: **Any iOS Device (arm64)** ← CRITICAL!
- [ ] NOT a simulator
- [ ] NOT a specific device name

---

## ✅ Phase 5: Archive (The Big Moment!)

### Clean Build
- [ ] Product → Clean Build Folder (or ⇧⌘K)
- [ ] Waited for "Clean Finished" message

### Archive
- [ ] Product → Archive (must use menu, no keyboard shortcut)
- [ ] Watched progress in top bar
- [ ] No errors in Report Navigator (⌘9)
- [ ] Waited 5-15 minutes for completion

### Organizer Window
- [ ] Organizer appeared automatically (or Window → Organizer)
- [ ] New archive visible in list
- [ ] Archive shows correct version and build number
- [ ] Archive has valid date/time

**If archive failed:**
- [ ] Checked TROUBLESHOOTING.md for error message
- [ ] Fixed issue
- [ ] Returned to Phase 4 and verified all settings
- [ ] Tried archive again

---

## ✅ Phase 6: Upload to App Store Connect

### Organizer
- [ ] Selected your new archive
- [ ] Clicked "Distribute App" button

### Distribution Method
- [ ] Selected "App Store Connect"
- [ ] Clicked Next

### Distribution Options
- [ ] Selected "Upload"
- [ ] Clicked Next

### App Store Connect Distribution Options
- [ ] Upload symbols: CHECKED (recommended for crashlytics)
- [ ] Manage version and build number: Optional
- [ ] Clicked Next

### Re-sign
- [ ] Automatic signing selected
- [ ] Certificate shows "Apple Distribution"
- [ ] Provisioning Profile shows correct profile
- [ ] Clicked Next

### Review
- [ ] Reviewed summary
- [ ] Clicked Upload

### Upload Progress
- [ ] Watched upload progress (2-10 minutes)
- [ ] Upload completed successfully
- [ ] Got "Upload Successful" message
- [ ] Clicked Done

---

## ✅ Phase 7: App Store Connect Processing

### Check Email
- [ ] Received email from Apple (within minutes)
- [ ] Subject: "Your app has been received"
- [ ] No immediate rejection errors

### App Store Connect
- [ ] Logged in to https://appstoreconnect.apple.com
- [ ] Selected your app
- [ ] Clicked TestFlight tab
- [ ] Build shows "Processing" (yellow)
- [ ] Waited 10-60 minutes for processing

### After Processing
- [ ] Build status changed to ready (blue)
- [ ] Build shows version and build number
- [ ] No warnings or errors

---

## ✅ Phase 8: Export Compliance

### In TestFlight Tab
- [ ] Clicked yellow warning icon (if present)
- [ ] Answered: "Is your app designed to use cryptography or does it contain or incorporate cryptography?"
  - [ ] Selected NO (if only using HTTPS/standard iOS encryption)
  - [ ] Or Selected YES → Is exempt (if using standard encryption)
- [ ] Saved export compliance

---

## ✅ Phase 9: TestFlight Testing

### Add Internal Testers
- [ ] TestFlight → App Store Connect Users group
- [ ] Added yourself as tester
- [ ] Added team members (optional)

### Enable Build for Testing
- [ ] Selected your build
- [ ] Provided "What to Test" notes
- [ ] Clicked "Save"

### Install TestFlight
- [ ] Installed TestFlight app on iOS device
- [ ] Logged in with Apple ID
- [ ] Saw your app in TestFlight
- [ ] Installed build

### Test Your App
- [ ] App launches successfully
- [ ] Main features work
- [ ] AdMob ads display (may take time to activate)
- [ ] In-app purchases work (test with sandbox account)
- [ ] Push notifications work
- [ ] Sign in with Apple works
- [ ] No crashes
- [ ] No critical bugs

---

## ✅ Phase 10: App Store Submission (When Ready)

### App Information
- [ ] App Store → App Information
- [ ] Name: ________________
- [ ] Subtitle: ________________ (optional)
- [ ] Privacy Policy URL: ________________
- [ ] Category: Primary ________ Secondary ________ (optional)

### Pricing and Availability
- [ ] Price: Selected price tier or Free
- [ ] Territories: Selected countries
- [ ] Pre-order: Yes/No

### App Privacy
- [ ] App Privacy → Get Started
- [ ] Answered all data collection questions:
  - [ ] Contact Info (if collected)
  - [ ] Usage Data (Analytics)
  - [ ] Identifiers (AdMob)
  - [ ] Purchases (RevenueCat)
  - [ ] Crash Data (Crashlytics)
- [ ] Published privacy details

### Prepare for Submission
- [ ] Version Information → 1.0 (or your version)
- [ ] Selected build from TestFlight
- [ ] Added screenshots:
  - [ ] 6.7" Display (1290 x 2796) - iPhone 15 Pro Max
  - [ ] 6.5" Display (1242 x 2688) - iPhone 11 Pro Max
  - [ ] 5.5" Display (1242 x 2208) - iPhone 8 Plus
  - [ ] iPad Pro (2048 x 2732) - if supporting iPad
- [ ] Description written (4000 char max)
- [ ] Keywords added (100 char max)
- [ ] Support URL: ________________
- [ ] Marketing URL: ________________ (optional)

### Age Rating
- [ ] Age Rating → Edit
- [ ] Answered all questions honestly
- [ ] Rating calculated and acceptable

### Review Information
- [ ] First Name: ________________
- [ ] Last Name: ________________
- [ ] Phone: ________________
- [ ] Email: ________________
- [ ] Notes to Reviewer: ________________ (optional but helpful)
- [ ] Demo account (if app requires login):
  - [ ] Username: ________________
  - [ ] Password: ________________

### Version Release
- [ ] Selected release method:
  - [ ] Manually release after approval
  - [ ] Or: Automatically release after approval

### Submit for Review
- [ ] Reviewed all information
- [ ] Clicked "Save"
- [ ] Clicked "Add for Review"
- [ ] Confirmed submission
- [ ] Status changed to "Waiting for Review"

---

## ✅ Phase 11: During Review (1-3 Days)

### Monitor Status
- [ ] Checked App Store Connect daily
- [ ] Status: "In Review" (being reviewed)
- [ ] Checked email for updates

### If Rejected
- [ ] Read rejection reason carefully
- [ ] Checked Resolution Center in App Store Connect
- [ ] Fixed issues
- [ ] Incremented build number
- [ ] Archived new build
- [ ] Uploaded to TestFlight
- [ ] Resubmitted for review

### If Approved
- [ ] Status: "Pending Developer Release" or "Ready for Sale"
- [ ] Received approval email
- [ ] Released app (if manual release)
- [ ] 🎉 CELEBRATED! 🎉

---

## ✅ Post-Launch Checklist

### Verify on App Store
- [ ] Searched for app in App Store
- [ ] App appears in search results
- [ ] Screenshots display correctly
- [ ] Description correct
- [ ] Price correct
- [ ] Download and install from App Store

### Monitor
- [ ] Firebase Analytics for usage
- [ ] Firebase Crashlytics for crashes
- [ ] AdMob for ad performance
- [ ] RevenueCat for purchase metrics
- [ ] App Store Connect for downloads and ratings

### Marketing
- [ ] Announced on social media
- [ ] Added App Store link to website
- [ ] Sent to beta testers and friends
- [ ] Requested reviews (in-app or personal outreach)

---

## 📝 Notes and Issues

**Problems encountered:**
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________

**Solutions:**
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________

**Time spent:**
- Configuration: _______ hours
- Archive/Upload: _______ minutes
- TestFlight testing: _______ hours
- Review time: _______ days
- Total: _______ 

**Next version reminders:**
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________

---

## 🎯 Quick Reference

| Resource | Location |
|----------|----------|
| **App Store Connect** | https://appstoreconnect.apple.com |
| **AdMob Console** | https://apps.admob.com |
| **Firebase Console** | https://console.firebase.google.com |
| **Developer Portal** | https://developer.apple.com |
| **Icon Generator** | https://appicon.co |
| **Screenshot Tool** | macOS Screenshots app (⌘⇧5) |

| Guide | File |
|-------|------|
| **Quick Start** | QUICK_DEPLOYMENT_GUIDE.md |
| **Full Reference** | DEPLOYMENT_CHECKLIST.md |
| **Xcode Setup** | XCODE_CONFIGURATION.md |
| **Troubleshooting** | TROUBLESHOOTING.md |
| **Info.plist Template** | Info.plist.SAMPLE |
| **Ad Network IDs** | SKADNETWORK_IDS.md |
| **Overview** | README_DEPLOYMENT.md |

---

**Version History:**

| Date | Version | Build | Status | Notes |
|------|---------|-------|--------|-------|
| _____ | _____ | _____ | _____ | _____ |
| _____ | _____ | _____ | _____ | _____ |
| _____ | _____ | _____ | _____ | _____ |
| _____ | _____ | _____ | _____ | _____ |

---

**Remember:**
- ✅ Increment build number for EVERY upload
- ✅ Test on TestFlight before submitting for review
- ✅ Keep this checklist for future releases
- ✅ Save successful configurations in version control
- ✅ Document any custom changes or workarounds

**You've got this!** 🚀💪
