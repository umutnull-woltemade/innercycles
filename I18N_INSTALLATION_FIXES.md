# i18n System - Installation & Issue Fixes

## 🔴 CRITICAL: File Path Issues Fixed

The automated file creation had path concatenation issues. Follow these steps to properly install the i18n system.

---

## STEP 1: Create Directory Structure

```bash
# From repository root
mkdir -p Resources/en.lproj
mkdir -p Resources/tr.lproj
mkdir -p Tests/i18n
mkdir -p scripts
mkdir -p .github/workflows
```

---

## STEP 2: Move Generated Files to Correct Locations

### Localization String Files

**File:** `Resourcesen.lprojLocalizable.strings` (WRONG PATH)
**Move to:** `Resources/en.lproj/Localizable.strings`

**File:** `Resourcestr.lprojLocalizable.strings` (WRONG PATH)  
**Move to:** `Resources/tr.lproj/Localizable.strings`

```bash
# Fix commands:
mv Resourcesen.lprojLocalizable.strings Resources/en.lproj/Localizable.strings
mv Resourcestr.lprojLocalizable.strings Resources/tr.lproj/Localizable.strings
```

### Test Files

**File:** `TestsLocalizationTests.swift` (WRONG PATH)  
**Move to:** `Tests/i18n/LocalizationTests.swift`

```bash
mv TestsLocalizationTests.swift Tests/i18n/LocalizationTests.swift
```

### Scripts

**File:** `scriptsi18n_guard.swift` (WRONG PATH)  
**Move to:** `scripts/i18n_guard.swift`

**File:** `scriptsi18n_sync.swift` (WRONG PATH)  
**Move to:** `scripts/i18n_sync.swift`

**File:** `scriptsi18n_migration.sh` (WRONG PATH)  
**Move to:** `scripts/i18n_migration.sh`

```bash
mv scriptsi18n_guard.swift scripts/i18n_guard.swift
mv scriptsi18n_sync.swift scripts/i18n_sync.swift
mv scriptsi18n_migration.sh scripts/i18n_migration.sh

# Make scripts executable
chmod +x scripts/i18n_guard.swift
chmod +x scripts/i18n_sync.swift
chmod +x scripts/i18n_migration.sh
```

### GitHub Workflow

**File:** `.githubworkflowsi18n_compliance.yml` (WRONG PATH)  
**Move to:** `.github/workflows/i18n_compliance.yml`

```bash
mv .githubworkflowsi18n_compliance.yml .github/workflows/i18n_compliance.yml
```

---

## STEP 3: Update Script Paths

The scripts reference paths that need to match your actual project structure. Update these constants:

### In `scripts/i18n_guard.swift`:

Find line ~20:
```swift
struct I18nConfig {
    static let supportedLocales = ["en", "tr"]
    static let resourcesPath = "Resources"  // ← Verify this matches your project
    static let sourcePaths = ["Sources", "RevenueCatUI"]  // ← Update to match actual source dirs
```

**Action:** Update `sourcePaths` to match where your `.swift` files are located.

### In `scripts/i18n_sync.swift`:

Find line ~32:
```swift
struct SyncConfig {
    static let resourcesPath = "Resources"  // ← Verify this matches your project
    static let supportedLocales = ["en", "tr"]
```

---

## STEP 4: Fix FooterView Import Issue

The updated `FooterView.swift` uses `LocalizationKey` enum but may need the import.

**File:** `FooterView.swift`

**Issue:** Missing import or module reference for `LocalizationKey`

**Fix:** Ensure `LocalizationKeys.swift` is in the same module/target as `FooterView.swift` in your Xcode project.

If they're in different modules, add import:
```swift
import RevenueCatUI // or whatever module contains LocalizationKeys.swift
```

---

## STEP 5: Update Package.swift (SPM) or Xcode Project

### For Swift Package Manager:

Add localization resources to your `Package.swift`:

```swift
.target(
    name: "RevenueCatUI",
    dependencies: ["RevenueCat"],
    resources: [
        .process("Resources")  // ← Add this
    ]
)
```

Add test target:
```swift
.testTarget(
    name: "RevenueCatUITests",
    dependencies: ["RevenueCatUI"],
    path: "Tests"
)
```

### For Xcode Project (.xcodeproj):

1. **Add Resources folder:**
   - Drag `Resources/` folder into Xcode
   - Select "Create folder references" (blue folder)
   - Add to target: RevenueCatUI

2. **Add .strings files:**
   - Right-click `Resources` → New File → Strings File
   - Name: `Localizable.strings`
   - Click "Localize..." in File Inspector
   - Enable: English, Turkish

3. **Add source files:**
   - Add `LocalizationKeys.swift` to target
   - Add `Text+Localization.swift` to target

4. **Add test files:**
   - Add `Tests/i18n/LocalizationTests.swift` to test target

---

## STEP 6: Fix Turkish Percent Format

**Issue:** Turkish strings have `%%%d` which is CORRECT for escaping `%` in `.strings` files.

When localized, this becomes `%25 indirim` (25% off) correctly.

**No action needed** - this is intentional.

---

## STEP 7: Verify Installation

Run validation checks:

```bash
# 1. Check file structure
ls -R Resources/
# Should show:
# Resources/en.lproj/Localizable.strings
# Resources/tr.lproj/Localizable.strings

# 2. Test i18n guard
swift scripts/i18n_guard.swift

# 3. Test i18n sync
swift scripts/i18n_sync.swift --check

# 4. Run tests
swift test --filter LocalizationTests
```

---

## STEP 8: Common Issues & Fixes

### Issue: "Could not find module RevenueCatUI"

**Fix:** Build the module first:
```bash
swift build
```

### Issue: "Bundle.module not found"

**Fix:** Ensure you're using Swift Package Manager OR have the CocoaPods compatibility shim:
- File already created: `Bundle+Extensions.swift`
- Verify it's in your target

### Issue: "LocalizationKey not found in FooterView"

**Fix:** Both files must be in same target. Check Xcode target membership.

### Issue: Scripts can't find files

**Fix:** Run scripts from repository root:
```bash
cd /path/to/repo
swift scripts/i18n_guard.swift
```

### Issue: Tests fail with "TestHelpers.package undefined"

**Fix:** The test file has placeholder code. Replace lines 173-183 with actual test data:

```swift
#if DEBUG
private enum TestHelpers {
    static let package: Package = {
        // Use actual test package from your test suite
        // Or create a minimal mock:
        Package(
            identifier: "$rc_monthly",
            packageType: .monthly,
            storeProduct: YourTestStoreProduct,
            offeringIdentifier: "default",
            webCheckoutUrl: nil
        )
    }()
    
    static let localization: ProcessedLocalizedConfiguration = {
        ProcessedLocalizedConfiguration(
            title: "Test Title",
            subtitle: nil,
            callToAction: "Subscribe",
            // ... fill in required fields
        )
    }()
}
#endif
```

Or **comment out test 6** until you have proper test fixtures.

---

## STEP 9: Update Localization.swift (Optional Enhancement)

To support the new `LocalizationKey` enum, you can add this extension to `Localization.swift`:

```swift
extension Localization {
    /// Get localized string using LocalizationKey enum
    static func string(
        for key: LocalizationKey,
        locale: Locale = .current
    ) -> String {
        return key.localized(
            in: Self.localizedBundle(locale),
            locale: locale
        )
    }
}
```

---

## STEP 10: Final Validation Checklist

- [ ] Directory structure created correctly
- [ ] All files moved to proper paths
- [ ] Scripts are executable (`chmod +x`)
- [ ] Resources added to Xcode project/Package.swift
- [ ] `swift scripts/i18n_guard.swift` passes
- [ ] `swift scripts/i18n_sync.swift --check` passes
- [ ] `swift test --filter LocalizationTests` passes (or test 6 disabled)
- [ ] `FooterView.swift` compiles without errors
- [ ] CI workflow file is in `.github/workflows/`

---

## STEP 11: Clean Up (Optional)

Remove incorrectly-named files if they still exist:

```bash
rm -f Resourcesen.lprojLocalizable.strings
rm -f Resourcestr.lprojLocalizable.strings
rm -f TestsLocalizationTests.swift
rm -f scriptsi18n_guard.swift
rm -f scriptsi18n_sync.swift
rm -f scriptsi18n_migration.sh
rm -f .githubworkflowsi18n_compliance.yml
```

---

## Verification Commands

After installation, run:

```bash
# Verify structure
tree Resources/ Tests/ scripts/ .github/

# Verify content
cat Resources/en.lproj/Localizable.strings | head -20
cat Resources/tr.lproj/Localizable.strings | head -20

# Test scripts
swift scripts/i18n_guard.swift
swift scripts/i18n_sync.swift --check

# Run tests
swift test --filter LocalizationTests
```

---

## Success Criteria

You'll know installation succeeded when:

✅ All files in correct directories  
✅ `swift build` completes successfully  
✅ `i18n_guard.swift` exits 0 (no violations)  
✅ `i18n_sync.swift --check` exits 0 (in sync)  
✅ Tests pass (or test 6 disabled with note)  
✅ FooterView renders with localized strings  

---

## Need Help?

If issues persist:

1. Check file paths match your project structure
2. Verify Xcode target membership for all new files
3. Ensure Swift Package Manager resources are declared
4. Check module imports between files
5. Review console output for specific error messages

---

## Next Steps After Installation

1. Run migration scanner: `bash scripts/i18n_migration.sh`
2. Review any remaining hardcoded strings
3. Add new localization keys as needed
4. Commit changes with i18n system enabled
5. Watch CI enforce compliance on all future PRs

---

**Installation should take ~10 minutes with these fixes.**
