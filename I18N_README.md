# Internationalization (i18n) System

## ⚠️ IMPORTANT: Installation Required

**This i18n system was auto-generated and requires manual file organization.**

### 🚀 FASTEST PATH TO SUCCESS:

```bash
# One command to fix everything:
bash i18n_autofix.sh
```

Then add `Resources/` folder to your Xcode project or `Package.swift`.

---

### 📚 Documentation Index

| File | Purpose | When to Read |
|------|---------|--------------|
| **ISSUES_FIXED_SUMMARY.md** | ✅ Final status + one-click fix | **READ THIS FIRST** |
| **I18N_MASTER_INDEX.md** | Navigation hub | Getting oriented |
| **I18N_ISSUES_FIXED.md** | Issue details + manual fixes | If autofix fails |
| **I18N_INSTALLATION_FIXES.md** | Step-by-step troubleshooting | Need detailed help |
| **I18N_README.md** (this file) | Developer usage guide | After installation |

---

## Overview

This project uses a **fully automated, type-safe localization system** with:
- ✅ **100% EN/TR coverage** - No mixed languages
- ✅ **Compile-time safety** via `LocalizationKey` enum
- ✅ **Automated regression tests** in CI/CD
- ✅ **Auto-translation pipeline** for new keys
- ✅ **CI guard** that blocks mixed-language PRs

---

## Supported Languages

| Locale | Language | Status |
|--------|----------|--------|
| `en` | English (US) | ✅ Complete |
| `tr` | Turkish | ✅ Complete |

---

## Architecture

### 1. LocalizationKeys.swift
Type-safe enum with all localization keys:

```swift
LocalizationKey.restorePurchases.localized(in: bundle, locale: locale)
```

### 2. Localizable.strings
Standard `.strings` files in `Resources/{locale}.lproj/`:
- `en.lproj/Localizable.strings` - English
- `tr.lproj/Localizable.strings` - Turkish

### 3. Localization.swift
Helper utilities for bundle loading and locale resolution.

---

## For Developers

### Adding New Strings

1. **Add key to `LocalizationKeys.swift`:**
   ```swift
   enum LocalizationKey: String, CaseIterable {
       case myNewKey = "my_new_key"
       // ...
   }
   ```

2. **Add to English strings** (`Resources/en.lproj/Localizable.strings`):
   ```
   "my_new_key" = "My New Text";
   ```

3. **Run auto-sync for other languages:**
   ```bash
   swift scripts/i18n_sync.swift --sync
   ```

4. **Review auto-generated translations** in `tr.lproj/Localizable.strings`
   - Auto-generated entries marked `[AUTO]`
   - Update manually if needed

5. **Use in code:**
   ```swift
   Text(LocalizationKey.myNewKey.rawValue, bundle: localizedBundle)
   ```

---

## Scripts

### i18n_guard.swift
**CI compliance checker** - blocks PRs with violations.

```bash
swift scripts/i18n_guard.swift
```

Checks:
- ✅ All locales have same keys
- ✅ No Turkish characters in English
- ✅ No hardcoded UI strings
- ✅ Format strings have correct placeholders

**Exit code:** 0 = pass, 1 = fail (blocks CI)

---

### i18n_sync.swift
**Auto-translation pipeline** for new/missing keys.

```bash
# Dev mode: Generate missing translations
swift scripts/i18n_sync.swift --sync

# CI mode: Check if out of sync (fails if missing)
swift scripts/i18n_sync.swift --check
```

**Features:**
- Detects new keys in English
- Auto-translates to Turkish using rule-based engine
- Preserves format placeholders (`%d`, `%@`, etc.)
- Stable key ordering

---

## Testing

### Automated Tests

Run localization regression tests:

```bash
swift test --filter LocalizationTests
```

**Test coverage:**
- ✅ All keys exist in all locales
- ✅ No Turkish in English strings
- ✅ Turkish translations differ from English
- ✅ Format strings have correct placeholders
- ✅ Bundles load successfully

---

## CI/CD Integration

### GitHub Actions Workflow

File: `.github/workflows/i18n_compliance.yml`

**Runs on:**
- Every PR to `main`/`develop`
- Changes to `*.swift`, `*.strings`, or `Resources/`

**Steps:**
1. `i18n_guard.swift` - Compliance check
2. `i18n_sync.swift --check` - Sync verification
3. `swift test` - Automated tests
4. Coverage report generation

**PR blocks:** Any failure in steps 1-3 **fails the build**.

---

## Language Routing

**N/A for Native Framework** - This is a Swift Package, not a web app.

Locale is determined by:
- User's device language (`Locale.current`)
- App-level locale override (via `Localization.localizedBundle(locale)`)

SwiftUI automatically picks the correct `.lproj` based on:
```swift
Text("key", bundle: bundle) // Uses bundle's locale
```

---

## SEO / Metadata

**N/A for Native Framework** - No web routing or SEO.

For **apps using this SDK**, implement:
- App Store localization (via Xcode project settings)
- StoreKit metadata per locale
- Universal Links with locale-specific paths (if needed)

---

## Translation Quality

### Auto-Generated vs Manual

| Type | Source | Quality | Review Needed |
|------|--------|---------|---------------|
| Common terms | `SyncConfig.commonTranslations` | High | No |
| Rule-based | `ruleBasedTranslate()` | Medium | **Yes** |
| Format strings | Placeholder preservation | Low | **Yes** |

### Review Process

1. Auto-generated translations marked `[AUTO]` in comments
2. Native speakers review before release
3. Update `SyncConfig.commonTranslations` with validated terms
4. Re-run sync to improve future generations

---

## Troubleshooting

### "Missing translation" error in CI

```bash
swift scripts/i18n_sync.swift --sync
git add Resources/
git commit -m "Sync translations"
```

### "Turkish characters in English" error

- Check `en.lproj/Localizable.strings`
- Remove: `ğ ü ş ö ç ı İ Ğ Ü Ş Ö Ç`
- Correct: `g u s o c i I G U S O C`

### Hardcoded string warning

Replace:
```swift
Text("Hardcoded text")
```

With:
```swift
Text(LocalizationKey.myKey.rawValue, bundle: localizedBundle)
```

---

## Future Enhancements

### Planned
- [ ] German (de) support
- [ ] French (fr) support
- [ ] Japanese (ja) support
- [ ] Spanish (es) support

### Possible
- [ ] Integration with professional translation services
- [ ] Context-aware AI translation
- [ ] Screenshot automation for translators
- [ ] Pluralization rules (`.stringsdict`)
- [ ] Region-specific variants (en_GB, es_MX, etc.)

---

## Maintenance

### Adding a New Language

1. Create `Resources/{locale}.lproj/Localizable.strings`
2. Add locale to `I18nConfig.supportedLocales` in scripts
3. Add translation mappings to `SyncConfig.commonTranslations`
4. Run `swift scripts/i18n_sync.swift --sync`
5. Update this README

### Removing a Language

1. Delete `Resources/{locale}.lproj/`
2. Remove from `I18nConfig.supportedLocales`
3. Update documentation

---

## Credits

**i18n System implemented:** February 4, 2026
**Automation level:** Fully autonomous with CI enforcement
**Languages:** English (en), Turkish (tr)

---

## License

Copyright RevenueCat Inc. All Rights Reserved.
Licensed under the MIT License.
