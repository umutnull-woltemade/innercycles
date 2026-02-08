aa# Xcode Project Integration Guide

## Quick Reference for Adding i18n System to Xcode Projects

This guide is for projects using `.xcodeproj` (not Swift Package Manager).

---

## Step 1: Add Resource Files

### 1.1 Create Localizable.strings

**In Xcode:**
1. Right-click on your project in Project Navigator
2. Select **New File...** → **Strings File**
3. Name it: `Localizable.strings`
4. Save to `Resources/` folder (create if needed)

### 1.2 Localize the File

1. Select `Localizable.strings` in Project Navigator
2. Open **File Inspector** (⌘⌥1)
3. Click **"Localize..."** button
4. Choose **English** as base language
5. Click **"Localize"**

### 1.3 Add Additional Languages

1. Select your **Project** (blue icon at top)
2. Go to **Info** tab
3. Under **Localizations**, click **+**
4. Add **Turkish**
5. Check `Localizable.strings` in dialog
6. Click **Finish**

### 1.4 Populate String Files

**English (en):**
Copy content from `Resources/en.lproj/Localizable.strings`

**Turkish (tr):**
Copy content from `Resources/tr.lproj/Localizable.strings`

---

## Step 2: Add Source Files

### 2.1 Add LocalizationKeys.swift

1. Drag `LocalizationKeys.swift` into Xcode
2. Ensure **"Copy items if needed"** is checked
3. Select appropriate **target(s)**
4. Click **Add**

### 2.2 Add Text+Localization.swift

Same process as above for `Text+Localization.swift`

### 2.3 Verify Target Membership

For each file:
1. Select file in Project Navigator
2. Open **File Inspector** (⌘⌥1)
3. Verify **Target Membership** includes your app target

---

## Step 3: Update Existing Files

### 3.1 Update FooterView.swift

The file has already been updated to use `LocalizationKey`.

Verify it compiles by building (⌘B).

### 3.2 Verify Imports

Ensure all files using `LocalizationKey` can access it:
- Same module: No import needed
- Different module: Add `import YourModuleName`

---

## Step 4: Add Tests (Optional)

### 4.1 Create Test Group

1. Right-click on test directory
2. Select **New Group**
3. Name it: `i18n`

### 4.2 Add Test File

1. Drag `Tests/i18n/LocalizationTests.swift` into Xcode
2. Ensure added to **Test Target**
3. Click **Add**

---

## Step 5: Add Scripts to Build Phases (Optional but Recommended)

### 5.1 Add i18n Guard to Build

1. Select your **Target**
2. Go to **Build Phases** tab
3. Click **+** → **New Run Script Phase**
4. Name it: `i18n Compliance Check`
5. Add script:
   ```bash
   swift "${SRCROOT}/scripts/i18n_guard.swift"
   ```

This will fail the build if i18n violations are found.

### 5.2 Add Pre-commit Check (Optional)

Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
swift scripts/i18n_guard.swift || exit 1
```

Make executable:
```bash
chmod +x .git/hooks/pre-commit
```

---

## Step 6: Verify Installation

### 6.1 Build Project

Press **⌘B** to build.

**Expected:** No errors

### 6.2 Run Tests

Press **⌘U** to run all tests.

**Expected:** LocalizationTests should pass (if added)

### 6.3 Check Localization at Runtime

1. Run app in Simulator
2. Go to **Settings** → **General** → **Language & Region**
3. Change to **Turkish**
4. Launch your app
5. Verify UI shows Turkish text

Change back to English and verify English text appears.

---

## Step 7: Common Issues & Fixes

### Issue: "Cannot find 'LocalizationKey' in scope"

**Fix:**
- Verify `LocalizationKeys.swift` is in same target
- Check target membership in File Inspector
- Clean build folder (⇧⌘K) and rebuild

### Issue: Strings don't load / appear as keys

**Fix:**
- Verify `Localizable.strings` is localized (blue folder icon)
- Check bundle target membership
- Ensure `.strings` file syntax is correct (no syntax errors)
- Verify encoding is UTF-8 (File Inspector → Text Encoding)

### Issue: Turkish strings show in English mode

**Fix:**
- Check device language setting
- Verify `Localization.localizedBundle(locale)` gets correct locale
- Ensure you're passing `bundle: localizedBundle` to Text()

### Issue: Build phase script doesn't run

**Fix:**
- Verify script is in correct target's build phases
- Check script path is correct: `${SRCROOT}/scripts/i18n_guard.swift`
- Ensure scripts are executable: `chmod +x scripts/*.swift`

---

## Step 8: Xcode Project File Structure

After integration, your project should look like:

```
YourApp.xcodeproj
YourApp/
├── Sources/
│   ├── LocalizationKeys.swift       ← Added
│   ├── Text+Localization.swift      ← Added
│   ├── Localization.swift           ← Existing
│   ├── FooterView.swift             ← Updated
│   └── ... other files
├── Resources/
│   ├── en.lproj/
│   │   └── Localizable.strings      ← Added & localized
│   └── tr.lproj/
│       └── Localizable.strings      ← Added & localized
└── Tests/
    └── i18n/
        └── LocalizationTests.swift  ← Added (optional)

scripts/
├── i18n_guard.swift                 ← Added
├── i18n_sync.swift                  ← Added
└── i18n_migration.sh                ← Added
```

---

## Step 9: Using in Your Code

### Basic Usage

```swift
import SwiftUI

struct MyView: View {
    @Environment(\.locale) var locale
    
    var body: some View {
        VStack {
            // Use LocalizationKey enum
            Text(
                LocalizationKey.restorePurchases.rawValue,
                bundle: Localization.localizedBundle(locale)
            )
            
            // Alternative using extension
            Text(localizationKey: .restore, bundle: Localization.localizedBundle(locale))
        }
    }
}
```

### With Format Strings

```swift
// For "25% off"
let discount = 25
let text = String(
    localizationKey: .percentOff,
    in: Localization.localizedBundle(locale),
    locale: locale,
    arguments: discount
)
```

### In UIKit

```swift
import UIKit

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = Locale.current
        let bundle = Localization.localizedBundle(locale)
        
        let text = bundle.localizedString(
            forKey: LocalizationKey.restorePurchases.rawValue,
            value: nil,
            table: nil
        )
        
        button.setTitle(text, for: .normal)
    }
}
```

---

## Step 10: Maintenance Workflow

### Adding New Localized Strings

1. **Add to enum:**
   ```swift
   // In LocalizationKeys.swift
   case myNewFeature = "my_new_feature"
   ```

2. **Add to fallback:**
   ```swift
   // In fallbackValue computed property
   case .myNewFeature: return "My New Feature"
   ```

3. **Add to English strings:**
   In `en.lproj/Localizable.strings`:
   ```
   "my_new_feature" = "My New Feature";
   ```

4. **Auto-translate:**
   ```bash
   swift scripts/i18n_sync.swift --sync
   ```

5. **Review Turkish** in `tr.lproj/Localizable.strings`

6. **Use in code:**
   ```swift
   Text(LocalizationKey.myNewFeature.rawValue, bundle: bundle)
   ```

7. **Verify:**
   ```bash
   swift scripts/i18n_guard.swift
   ```

---

## Verification Checklist

- [ ] Localizable.strings exists for en and tr
- [ ] Both .strings files are localized (blue folder icon)
- [ ] LocalizationKeys.swift added to target
- [ ] Text+Localization.swift added to target
- [ ] FooterView.swift compiles without errors
- [ ] Project builds successfully (⌘B)
- [ ] Tests pass (⌘U)
- [ ] App shows English when device is English
- [ ] App shows Turkish when device is Turkish
- [ ] `swift scripts/i18n_guard.swift` exits 0
- [ ] Build phase script runs (if added)

---

## Advanced: Xcode Scheme for Testing Localizations

### Create Turkish Test Scheme

1. **Product** → **Scheme** → **Manage Schemes...**
2. Duplicate your main scheme
3. Rename to "YourApp (Turkish)"
4. Edit scheme → **Run** → **Options**
5. Set **Application Language** to "Turkish"
6. Set **Application Region** to "Turkey"

Now you can quickly test Turkish without changing device settings!

---

## Need More Help?

- **General usage:** I18N_README.md
- **Troubleshooting:** I18N_INSTALLATION_FIXES.md
- **System overview:** I18N_MASTER_INDEX.md

---

**Estimated integration time: 10-15 minutes**

Happy localizing! 🌍
